import os
import sys

#set the directory and file name
dfirst = str(os.getcwd())
duse = raw_input("Enter the desired directory: ")
os.chdir(dfirst+duse)
filename = raw_input("Enter the desired g-code file name: ")
gcode = open(filename, "w")

#set units
units = raw_input("Are your numeric values in inches or mm? ")

if units == "inches":
    gcode.write("G20 ")
elif units == "mm":
        gcode.write("G21 ")
else:
    sys.exit("Invalid Unit Type")
#set zero
gcode.write("G90\n")

#set variables
fr = float(raw_input("Enter the feed rate in units/minute: "))          #def - 100mm/min
pr = float(raw_input("Enter the plunge rate in units/minute: "))        #def - 100mm/min
d = float(raw_input("Enter the diameter of the bit: "))                 
dpc = float(raw_input("Enter the depth per cut: "))                     #0.1mm
length = float(raw_input("Enter cut length: "))                         
wall = float(raw_input("Enter wall thickness: "))                       #+- 100 micron
space = float(raw_input("Enter groove spaceing: "))                     #+- 100 micron
depth = float(raw_input("Enter how deep the grooves are: "))            
streamline = float(raw_input("Enter the distance of the streamline side: ")) 
cross = float(raw_input ("Enter the distance of the cross side: "))

#distance between start points of grooves, l is X-axis, w is Y-axis
incrementl = space + length + d
incrementw = wall + d

#move to the zero coordinate and set base values at zero
gcode.write("G1 X0 Y0 Z0 ")
X = 0.0
Y = 0.0
Z = 0.0

#set the speed for the above action
gcode.write("F" + str(pr) + "\n")

#calculate number of grooves in each row and column as well as the number
#of nessacery full cuts per groove
segs = int(streamline/incrementl)
channels = int(cross/incrementw)
cuts = int(depth/dpc)

#helper functions
#move horizontally
def move(x, y):
    gcode.write("G1" + " X" + str(x) + " Y" + str(y) + " F" + str(fr) + "\n")
#^ max speed
def fmove(x, y):
    gcode.write("G0" + " X" + str(x) + " Y" + str(y) + "\n")
#z-axis analog
def drill(z):
    gcode.write("G1" + " Z" + str(z) + " F" + str(pr) + "\n")
def fz(z):
    gcode.write("G0" + " Z" + str(z) + "\n")
    
#code to create a groove
def groove():
    #full cut
    for i in range (1, cuts + 1):
        drill(Z - (dpc * i))
        move(X + length, Y)
        move(X, Y)
    #last partial cut
    drill(Z - depth)
    move(X + length, Y)
    move(X, Y)
    drill(Z)
    
#cut all of the grooves    
for j in range (0, channels):
    X = 0.0
    for k in range (0, segs):
        fz(Z + 1)
        fmove(X, Y)
        drill(Z)
        groove()
        X += incrementl
    Y += incrementw

gcode.close
os.chdir(dfirst)