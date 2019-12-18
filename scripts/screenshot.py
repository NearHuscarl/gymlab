#!/bin/env python

import os
import keyboard
import pyautogui
import time
from pynput.mouse import Button, Controller
from collections import namedtuple

try:
    from PIL import Image
except ImportError:
    import Image
import pytesseract

try:
    from Tkinter import Tk
except ImportError:
    from tkinter import Tk

import create_db

Coord = namedtuple('Coord', 'x y')

SCRIPT_DIRECTORY = os.path.dirname(os.path.realpath(__file__))
IMAGE_PATH = os.path.normpath(
    os.path.join(SCRIPT_DIRECTORY, '../assets/images/exercise_large'))

WIDTH = 490
HEIGHT = 460

WIDTH_NAME = 490
HEIGHT_NAME = 100   

TOP_LEFT = Coord(x=1390, y=345)         
TOP_LEFT_NAME = Coord(x =1390, y = 234)

TOP_LEFT_ADB = Coord(x=1390, y=278)
TOP_LEFT_NAME_ADB = Coord(x =1390, y = 126)

BUTTON_SAVE = Coord(x = 800, y = 511)
# https://stackoverflow.com/a/53672281
pytesseract.pytesseract.tesseract_cmd = r'C:\\Program Files\\Tesseract-OCR\\tesseract.exe'

mouse = Controller()

def abc():
    print('abc')
    for i in range(10):
        if i % 2 == 0:
            print(i*2)
        else:
            print(i)

def setup():
    
    os.system('adb shell settings put system pointer_location 1')
    # pyautogui.moveTo(100, 150)

def tap(x, y):
    os.system("adb shell input tap {} {}".format(x, y))

def hold(x, y):
    os.system("adb shell input keyevent --longpress {} {}".format(x, y))

def screencap():
    os.system("adb shell screencap /sdcard/ScreenCap/screenshot.png")

def on_triggered():
    print('ssssss')

def to_clipboard(text):
    r = Tk()
    r.withdraw()
    r.clipboard_clear()
    r.clipboard_append(text)
    r.update() # now it stays on the clipboard after the window is closed
    r.destroy()


def ocr_core(filename):
    """
    This function will handle the core OCR processing of images.
    """
    text = pytesseract.image_to_string(Image.open(filename))  # We'll use Pillow's Image class to open the image and pytesseract to detect the string in the image
    return text

def screencrop():
    keyboard.press_and_release('ctrl+alt+a')
    time.sleep(1)
    pyautogui.moveTo(TOP_LEFT.x, TOP_LEFT.y)
    # 
    mouse.press(Button.left)
    pyautogui.moveTo(TOP_LEFT.x + WIDTH,TOP_LEFT.y + HEIGHT)
    mouse.release(Button.left)
    pyautogui.click(TOP_LEFT.x + WIDTH - 80, TOP_LEFT.y + HEIGHT + 20)
    keyboard.press_and_release('ctrl + v')
    pyautogui.click(BUTTON_SAVE.x,BUTTON_SAVE.y)

def screencrop_adb():
    keyboard.press_and_release('ctrl+alt+a')
    time.sleep(1)
    pyautogui.moveTo(TOP_LEFT_ADB.x, TOP_LEFT_ADB.y)
    # 
    mouse.press(Button.left)
    pyautogui.moveTo(TOP_LEFT_ADB.x + WIDTH,TOP_LEFT_ADB.y + HEIGHT)
    mouse.release(Button.left)
    pyautogui.click(TOP_LEFT_ADB.x + WIDTH - 80, TOP_LEFT_ADB.y + HEIGHT + 20)
    keyboard.press_and_release('ctrl + v')
    pyautogui.click(BUTTON_SAVE.x,BUTTON_SAVE.y)
    
def screencrop_name():
    keyboard.press_and_release('ctrl+alt+a')
    time.sleep(1)
    pyautogui.moveTo(TOP_LEFT_NAME.x, TOP_LEFT_NAME.y)
    # 
    mouse.press(Button.left)
    pyautogui.moveTo(TOP_LEFT_NAME.x + WIDTH_NAME ,TOP_LEFT_NAME.y + HEIGHT_NAME)
    mouse.release(Button.left)
    pyautogui.click(TOP_LEFT_NAME.x + WIDTH_NAME - 80, TOP_LEFT_NAME.y + HEIGHT_NAME +20 )  
    keyboard.press_and_release('n+a+m+e')
    pyautogui.click(BUTTON_SAVE.x,BUTTON_SAVE.y)

def screencrop_name_adb():
    keyboard.press_and_release('ctrl+alt+a')
    time.sleep(1)
    pyautogui.moveTo(TOP_LEFT_NAME_ADB.x, TOP_LEFT_NAME_ADB.y)
    # 
    mouse.press(Button.left)
    pyautogui.moveTo(TOP_LEFT_NAME_ADB.x + WIDTH_NAME ,TOP_LEFT_NAME_ADB.y + HEIGHT_NAME)
    mouse.release(Button.left)
    pyautogui.click(TOP_LEFT_NAME_ADB.x + WIDTH_NAME - 80, TOP_LEFT_NAME_ADB.y + HEIGHT_NAME +20 )  
    keyboard.press_and_release('n+a+m+e')
    pyautogui.click(BUTTON_SAVE.x,BUTTON_SAVE.y)

def get_name_exercise():
    create_db.connect_db(create_db.DB_TEST_PATH)
    
    # SCRIPT_DIRECTORY = os.path.dirname(os.path.realpath(__file__))

    # exercise_name = ocr_core(os.path.join(SCRIPT_DIRECTORY, './name.jpg'))
    exercise_name = 'Ring Muscleup'

    id_exercise_name = create_db.get_id_from_name(exercise_name)
    print(id_exercise_name)
    index_exercise_name = create_db.get_image_count_from_name(exercise_name)
    print(index_exercise_name)
    for x in range(index_exercise_name):
        to_clipboard('exercise_workout_'+ str(id_exercise_name) + '_' + str(x))
        time.sleep(1)
        # screencrop()
        screencrop_adb()
        time.sleep(1)
        pyautogui.doubleClick(1637,528)
    
def main():
    
    # setup()
    
    # screencrop_name()
    get_name_exercise()

def test():
    # screencrop_name()
    # screencrop_name_adb()
    create_db.connect_db(create_db.DB_TEST_PATH)
    
    # exercise_workout_large_38_0
    exercise_name = 'Dumbbell Biceps Curl, On Knee, Underhand Grip'
    id_exercise_name = create_db.get_id_from_name(exercise_name)
    # print(id_exercise_name)
    index_exercise_name = create_db.get_image_count_from_name(exercise_name)
    # print(index_exercise_name)
if __name__ == '__main__':
    # test()
    main()

    # create_db.connect_db(create_db.DB_TEST_PATH)
    # exercise_name = 'Lying Scissor Kicks'
    # id_exercise_name = str(create_db.get_id_from_name(exercise_name))
    # print(id_exercise_name)
    # index_exercise_name = create_db.get_image_count_from_name(exercise_name)
    # print(index_exercise_name)

    # exercise_workout_large_129_0.jpg
    # exercise_workout_large_{id}_{index}.jpg