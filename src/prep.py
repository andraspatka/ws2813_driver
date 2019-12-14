#!/usr/bin/env python3
import os
import sys
import fileinput
from shutil import copyfile

if os.path.isdir("vivado"):
    os.remove("vivado")

os.mkdir("vivado")

required_files = ["WS2813_Controller.vhd", "WS2813_Driver.vhd", "WS2813_TopLevel.vhd", "WS2813.xdc", "build.tcl", "bram_01.coe"]
for file in required_files:
    extension = file.split('.')[1]
    path = ""
    if extension == "vhd":
        path = "design/"
    if extension == "xdc":
        path = "constraints/"
    if extension == "coe":
        path = "coefficients/"
    path = path + file
    if not os.path.exists(path):
        print("File: " + file + "does not exist!")
        sys.exit()
    copyfile(path, "vivado/" + file)

# Put actual pwd into build.tcl
pwd = os.getcwd().replace('\\', '/') + "/vivado"
for line in fileinput.input("vivado/build.tcl", inplace=1):
    if "set directory" in line:
        line = "set directory " + pwd
        sys.stdout.write(line)
        sys.stdout.write(os.linesep)
    else:
        sys.stdout.write(line)

