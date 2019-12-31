import os
import re

SCRIPT_DIRECTORY = os.path.dirname(os.path.realpath(__file__))
LARGE_IMAGE_PATH = os.path.normpath(
    os.path.join(SCRIPT_DIRECTORY, '../assets/images/exercises'))
SMALL_IMAGE_PATH = os.path.normpath(
    os.path.join(SCRIPT_DIRECTORY, '../assets/images/exercise_small'))

large_files = []
small_files = []


for (dirpath, dirnames, filenames) in os.walk(SMALL_IMAGE_PATH):
    small_files = filenames

for (dirpath, dirnames, filenames) in os.walk(LARGE_IMAGE_PATH):
    large_files = filenames

indexes = []
for file in small_files:
    if not file.endswith('0.jpg'):
        continue

    m = re.search('exercise_workout_(.+?)_', file)
    if m:
        index = int(m.group(1))
        indexes.append(index)

not_found = []
for index in indexes:
    filename = 'exercise_workout_{0}_0.jpg'.format(index)
    if 'exercise_workout_{0}_0.jpg'.format(index) not in large_files:
        print(filename)
        not_found.append(filename)

print('total exercises without large images: {0}'.format(len(not_found)))