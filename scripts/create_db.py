#!/bin/env python

"""
Create sqlite db from raw json data I use python instead of dart because sqflite
in dart does not work isolated script (not a part of flutter app)

python scripts/create_db.py
"""

import json
import os
import sys
import re
import sqlite3

path = os.path
SCRIPT_DIRECTORY = path.dirname(path.realpath(__file__))
DB_PATH = path.normpath(
    path.join(SCRIPT_DIRECTORY, '../assets/data/data.sqlite'))
DB_TEST_PATH = path.normpath(
    path.join(SCRIPT_DIRECTORY, '../assets/data/data.test.sqlite'))
EXERCISE_JSON_PATH = path.normpath(
    path.join(SCRIPT_DIRECTORY, '../assets/data/exercises.json'))
FAVORITE_JSON_PATH = path.normpath(
    path.join(SCRIPT_DIRECTORY, '../assets/data/favorites.json'))

EXERCISE_TABLE = 'Exercise'
EXERCISE_EQUIPMENT_TABLE = 'Exercise_Equipment'
EQUIPMENT_TABLE = 'Equipment'
MUSCLE_TABLE = 'Muscle'
EXERCISE_MUSCLE_TABLE = 'Exercise_Muscle'
FAVORITE_TABLE = 'Favorite'
CONNECTION = None
CURSOR = None


def setup_db(db_path):
    if path.isfile(db_path):
        try:  # delete file if exist only
            os.remove(db_path)
        except PermissionError:
            print(
                'Cannot delete old db file because it is being used by another process.')
            sys.exit()
    connect_db(db_path)


def connect_db(db_path):
    global CONNECTION
    global CURSOR
    CONNECTION = sqlite3.connect(db_path)
    CURSOR = CONNECTION.cursor()


def read_json_from_file(path):
    """ return a python object of the json file's content """
    with open(path, 'r') as file:
        return json.load(file)


def uglify(data):
    """ return a string of compressed json text """
    result = json.dumps(data, separators=(',', ':'))

    if result == r'{}' or result == '[]' or result == 'null':
        return None
    return result


def create_table_if_not_exists():
    CURSOR.execute('''
      CREATE TABLE IF NOT EXISTS {} (
        [id] INTEGER NOT NULL PRIMARY KEY,
        [name] NVARCHAR,
        [description] NVARCHAR,
        [imageCount] INTEGER,
        [thumbnailImageIndex] INTEGER,
        [type] NVARCHAR,
        [variation] NVARCHAR,
        [keywords] NVARCHAR
      )'''.format(EXERCISE_TABLE))

    CURSOR.execute('''
      CREATE TABLE IF NOT EXISTS {} (
        [id] NVARCHAR NOT NULL PRIMARY KEY
      )'''.format(MUSCLE_TABLE))

    CURSOR.execute('''
      CREATE TABLE IF NOT EXISTS {0} (
        [exerciseId] INTEGER REFERENCES {1}(id),
        [muscleId] NVARCHAR REFERENCES {2}(id),
        [target] NVARCHAR,
        CONSTRAINT pk_{0} PRIMARY KEY ([exerciseId], [muscleId], [target])
      )'''.format(EXERCISE_MUSCLE_TABLE, EXERCISE_TABLE, MUSCLE_TABLE))

    CURSOR.execute('''
      CREATE TABLE IF NOT EXISTS {} (
        [id] NVARCHAR NOT NULL PRIMARY KEY
      )'''.format(EQUIPMENT_TABLE))

    CURSOR.execute('''
      CREATE TABLE IF NOT EXISTS {0} (
        [exerciseId] INTEGER REFERENCES {1}(id),
        [equipmentId] NVARCHAR REFERENCES {2}(id),
        CONSTRAINT pk_{0} PRIMARY KEY ([exerciseId], [equipmentId])
      )'''.format(EXERCISE_EQUIPMENT_TABLE, EXERCISE_TABLE, EQUIPMENT_TABLE))

    CURSOR.execute('''
      CREATE TABLE IF NOT EXISTS {0} (
        [exerciseId] INTEGER REFERENCES {1}(id),
        [favorite] BIT,
        CONSTRAINT pk_{0} PRIMARY KEY ([exerciseId])
      )'''.format(FAVORITE_TABLE, EXERCISE_TABLE))


def get_id_from_name(name):
    CURSOR.execute('''
      SELECT id from {0}
      WHERE name = ?
      '''.format(EXERCISE_TABLE), (name,))
    return next(iter(CURSOR.fetchone()))


def get_image_count_from_name(name):
    CURSOR.execute('''
      SELECT imageCount from {0}
      WHERE name = ?
      '''.format(EXERCISE_TABLE), (name,))
    return next(iter(CURSOR.fetchone()))


def create_db(test_db):
    setup_db(DB_TEST_PATH if test_db else DB_PATH)
    create_table_if_not_exists()
    exercise_objs = read_json_from_file(EXERCISE_JSON_PATH)
    favorite_objs = read_json_from_file(FAVORITE_JSON_PATH)

    for exercise in exercise_objs:
        print('Inserting exercise ' + exercise['name'])
        CURSOR.execute('''INSERT INTO {} (
            [id],
            [name],
            [description],
            [imageCount],
            [thumbnailImageIndex],
            [type],
            [variation],
            [keywords]
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        '''
                       .format(EXERCISE_TABLE), (
                           exercise['id'],
                           exercise['name'].strip(),
                           exercise['description'],
                           exercise['imageCount'],
                           exercise['thumbnailImageIndex'],
                           exercise['type'],
                           uglify(exercise['variation']),
                           uglify(exercise['keywords'])
                       ))

        if (test_db):
            CURSOR.execute('INSERT INTO {} ([exerciseId], [favorite]) VALUES (?, ?)'
                           .format(FAVORITE_TABLE), (exercise['id'], str(exercise['id']) in favorite_objs))
        else:
            CURSOR.execute('INSERT INTO {} ([exerciseId], [favorite]) VALUES (?, ?)'
                           .format(FAVORITE_TABLE), (exercise['id'], False))

        for muscle_info in exercise['muscles']:
            CURSOR.execute('INSERT OR IGNORE INTO {} ([id]) VALUES (?)'
                           .format(MUSCLE_TABLE), (muscle_info['muscle'],))
            CURSOR.execute('INSERT OR IGNORE INTO {} ([exerciseId], [muscleId], [target]) VALUES (?, ?, ?)'
                           .format(EXERCISE_MUSCLE_TABLE),
                           (exercise['id'], muscle_info['muscle'], muscle_info['target']))

        for equipment in exercise['equipments']:
            CURSOR.execute('INSERT OR IGNORE INTO {} ([id]) VALUES (?)'
                           .format(EQUIPMENT_TABLE), (equipment,))
            CURSOR.execute('INSERT OR IGNORE INTO {} ([exerciseId], [equipmentId]) VALUES (?, ?)'
                           .format(EXERCISE_EQUIPMENT_TABLE),
                           (exercise['id'], equipment))

    # improve SELECT .. WHERE .. performance
    CURSOR.execute('CREATE INDEX [idx{}] ON {} ([id])'.format(
        EXERCISE_TABLE, EXERCISE_TABLE))

    CONNECTION.commit()


def test_db():
    CURSOR.execute(
        'SELECT * FROM {} WHERE [Keyword] LIKE ?'.format(EXERCISE_TABLE), ('%push up%',))
    rows = CURSOR.fetchall()
    for row in rows:
        for col in row:
            print(col)
        print()
    print('There are ' + str(len(rows)) + ' result(s)')


def main():
    # connect_db()
    # test_db()
    create_db(False)
    create_db(True)


if __name__ == '__main__':
    main()
