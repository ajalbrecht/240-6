#*****************************************************************************************************************************
# Program name: "Find_Circumference".  This program allow the user to find the harmonic series to the degree that the user   *
# inputs, while also telling the user how long the computation took.                        Copyright (C) 2020 AJ Albrecht   *
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
# version 3 as published by the Free Software Foundation.                                                                    *
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
# Warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
# A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
#*****************************************************************************************************************************
#=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
#
#Author information
#Author name: AJ Albrecht
#Author email: ajalbrecht@fullerton.edu
#
#Program information
#  Program name: Least_to_Greatest
#  Programming languages: C++, x86 Assembly and Bash
#  Date program began:     2020-Nov-29
#  Date program completed: 2020-Dec-6
#  Date comments upgraded: 2020-Dec-6
#  Files in this program: r.sh, Main.cpp, Manager.asm, read_clock.asm, getfrequency.asm
#  Status: Complete. No bugs found after testing.
#
#References for this program
#  Albrecht, Find_Circumference, version 1
#  Albrecht, Least_to_Greatest, version 1
#  Holiday, getfrequency, version 1
#  Holiday Integer Arithmetic, version 1
#
#Purpose
#  Find the harmonic series to the nth term, which the user will input into the program.
#
#This file
#   File name: r.sh
#   Language: Bash
#   Max page width: 132 columns
#   Assemble: sh r.sh
#   Link: g++ -m64 -no-pie -o Harmonic_Sum.out -std=c17 Main.o Manager.o read_clock.o getfrequency.o
#   Optimal print specification: 132 columns width, 7 points, monospace, 8??x11 paper
#
#Purpose of this file
#   Calculate Harmonic series and calculate how long the calculation took.

#!/bin/bash

# Compile all individual filles togeather.
# The order of compelation is based on which file is needed first.
g++ -c -Wall -m64 -std=c++14 -no-pie -o Main.o Main.cpp
nasm -f elf64 -l Manager.lis -o Manager.o Manager.asm
nasm -f elf64 -l read_clock.lis -o read_clock.o read_clock.asm
nasm -f elf64 -l getfrequency.lis -o getfrequency.o getfrequency.asm

# Assemble files togeather
g++ -m64 -no-pie -o Harmonic_Sum.out -std=c17 Main.o Manager.o read_clock.o getfrequency.o

#Run the program
./Harmonic_Sum.out
