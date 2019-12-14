import os

directory = 'C:\Users\16520\OneDrive\Desktop\gymlabb\scripts\exercise'

for filename in os.listdir(directory):
    if filename.endswith(".asm") or filename.endswith(".jpg"): 
        os.rename('a.txt', 'b.kml')
        continue
    else:
        continue