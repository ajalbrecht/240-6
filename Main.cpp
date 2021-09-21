//*****************************************************************************************************************************
// Program name: "Find_Circumference".  This program allow the user to find the harmonic series to the degree that the user   *
// inputs, while also telling the user how long the computation took.                        Copyright (C) 2020 AJ Albrecht   *
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
// version 3 as published by the Free Software Foundation.                                                                    *
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
// Warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
// A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
//*****************************************************************************************************************************
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//Author information
//Author name: AJ Albrecht
//Author email: ajalbrecht@fullerton.edu
//
//Program information
//  Program name: Least_to_Greatest
//  Programming languages: C++, x86 Assembly and Bash
//  Date program began:     2020-Nov-29
//  Date program completed: 2020-Dec-6
//  Date comments upgraded: 2020-Dec-6
//  Files in this program: r.sh, Main.cpp, Manager.asm, read_clock.asm, getfrequency.asm
//  Status: Complete. No bugs found after testing.
//
//References for this program
//  Albrecht, Find_Circumference, version 1
//  Albrecht, Least_to_Greatest, version 1
//  Holiday, getfrequency, version 1
//  Holiday Integer Arithmetic, version 1
//
//Purpose
//  Find the harmonic series to the nth term, which the user will input into the program.
//
//This file
//   File name: Main.cpp
//   Language: c++
//   Max page width: 132 columns
//   Assemble: g++ -c -Wall -m64 -std=c++14 -no-pie -o Main.o Main.cpp
//   Link: g++ -m64 -no-pie -o Harmonic_Sum.out -std=c17 Main.o Manager.o read_clock.o getfrequency.o
//   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
//
//Purpose of this file
//   Takes the result from manager and displays the harmonic sum.

#include <iostream>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

extern "C" double manager();

int main() {

  // inroduce the user to the program
  printf("%s\n\n", "Welcome to the Harmonic Sum programmed by AJ Albrecht");

  // call manager to do organize the result
  double result = manager();

  // end the program
  printf("%s%1.7lf%s\n", "The driver received this number ", result, ", and will keep it");
  printf("%s\n", "A zero will be returned to the operating system.  Have a nice day.");

  return 0;
}
