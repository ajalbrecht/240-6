;*****************************************************************************************************************************
; Program name: "Find_Circumference".  This program allow the user to find the harmonic series to the degree that the user   *
; inputs, while also telling the user how long the computation took.                        Copyright (C) 2020 AJ Albrecht   *
; This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
; version 3 as published by the Free Software Foundation.                                                                    *
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
; Warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
; A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
;*****************************************************************************************************************************
;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;
;Author information
;Author name: AJ Albrecht
;Author email: ajalbrecht@fullerton.edu
;
;Program information
;  Program name: Least_to_Greatest
;  Programming languages: C++, x86 Assembly and Bash
;  Date program began:     2020-Nov-29
;  Date program completed: 2020-Dec-6
;  Date comments upgraded: 2020-Dec-6
;  Files in this program: r.sh, Main.cpp, Manager.asm, read_clock.asm, getfrequency.asm
;  Status: Complete. No bugs found after testing.
;
;References for this program
;  Albrecht, Find_Circumference, version 1
;  Albrecht, Least_to_Greatest, version 1
;  Holiday, getfrequency, version 1
;  Holiday Integer Arithmetic, version 1
;
;Purpose
;  Find the harmonic series to the nth term, which the user will input into the program.
;
;This file
;   File name: Manager.asm
;   Language: X86 with Intel syntax
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l Manager.lis -o Manager.o Manager.asm
;   Link: g++ -m64 -no-pie -o Harmonic_Sum.out -std=c17 Main.o Manager.o read_clock.o getfrequency.o
;   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
;
;Purpose of this file
;   Calculate Harmonic series and calculate how long the calculation took.

global manager

segment .data
stringoutputformat db "%s", 0 ; writes
stringinputformat db "%s",0 ; inputs
floatform db "%lf", 0 ; allows for decimal outputs
signedintegerinputformat db "%ld",0 ; inputs
prompt db "Please enter the number of terms to be included in the sum: ", 0
time_before db 10, "The clock is now %ld tics and the computation will begin" , 10, 0
header db 10, "Terms completed - Harmonic sum", 10, 0

term db "%ld - ", 0    ; (1/2)     ; report progress to user approximately 10 times for most cases
current db "%1.13lf", 10, 0   ; (2/2)

time_after db 10, "The clock is now %ld tics.", 10, 0
total_tics db "The elapsed time was %ld tics, ", 0   ; (1/2)
seconds db "which equals %1.7lf seconds", 10, 10, 0     ; (2/2)
goodbye db "The harmonic sum will be returned to the driver.", 10, 10, 0

segment .bss
; There are no arrays in this program

segment .text

manager:
; Declare the names of programs called from this X86 source file, but whose own source code is not in this file.
extern printf
extern scanf
extern get_time
extern getfreq

; Back up the general purpose registers for the sole purpose of protecting the data of the caller.
push rbp                                                    ;Backup rbp
mov  rbp,rsp                                                ;The base pointer now points to top of stack
push rdi                                                    ;Backup rdi
push rsi                                                    ;Backup rsi
push rdx                                                    ;Backup rdx
push rcx                                                    ;Backup rcx
push r8                                                     ;Backup r8
push r9                                                     ;Backup r9
push r10                                                    ;Backup r10
push r11                                                    ;Backup r11
push r12                                                    ;Backup r12
push r13                                                    ;Backup r13
push r14                                                    ;Backup r14
push r15                                                    ;Backup r15
push rbx                                                    ;Backup rbx
pushf                                                       ;Backup rflags

push qword -1                                               ;Now the number of pushes is even

; Program register usage list
; r15 - used to display the initial time
; r14 - amount of terms
; r13 - loop counter
; r12 - used to store tell how many spaces are needed before reporting progress / later used to get end time
; rbx - used to tell when to write a status report
; rcx - used to pass values that are no longer need after one line
; xmm15 - stores the series as it grows
; xmm14 - holds 1 as 1/n + other terms
; xmm13 - holds n as 1/n + other terms
; xmm12 - the end time minus the start time
; xmm11 - tick constant for the users computer
; xmm10 - holds 1000000000, to convert Ghz to hz

; Ask the user for a positive int input.
mov qword rdi, stringoutputformat
mov qword rsi, prompt
mov qword rax, 0
call printf

; Take in a positive integer representing the amount of terms.
mov qword rdi, signedintegerinputformat
push qword 0
mov qword rsi, rsp
mov qword rax, 0
call scanf
pop qword r14

; Call the time function to get start time.
mov rax, 0
call get_time
mov r15, rax

; Display the results from get times.
mov qword rdi, time_before
mov qword rsi, r15
mov qword rdx, r15
mov qword rax, 0
call printf

; Write the header before the calculation starts
mov qword rdi, stringoutputformat
mov qword rsi, header
mov qword rax, 0
call printf

; Set up the loop to calculate the harmonic sum ------------------------------------------
; Initialize loop counter and message counter as one to add first element
mov r13, 1    ; loop counter
mov rbx, 1    ; space in between messages counter

; Initialize the current addition total as zero.
mov rcx, 0
cvtsi2sd xmm15, rcx

; Divide the amount the user wants added by 10, so the loop know when to inform the user about the programs progress.
mov qword rax, r14
cqo
mov rcx, 10
idiv rcx
mov r12, rax
mov rcx, rdx

; Using the remainder, determine if the amount of increments should be rounded up
cmp rcx, 5
jl is_small
  inc r12

; If the number is 1 to 4 inputs, list all of them anyways
is_small:
cmp r12, 0
jne next_term
  inc r12

; Loop to add all terms together ============================================================
; While there are terms left to add, keep going
next_term:
cmp r13, r14
jg calculation_complete

; Move the current element and one to an xmm register for computation.
mov rcx, 1
cvtsi2sd xmm14, rcx
cvtsi2sd xmm13, r13

; Add the nth term to the computation.
divsd xmm14, xmm13    ; 1 divide by n
addsd xmm15, xmm14    ; add that element to the total

; Report the program progress if the program is on a 10% interval
cmp rbx, r12
jne no_report

  ; Write term being displayed (1/2) (one line)
  mov qword rdi, term
  mov qword rsi, r13
  mov qword rdx, r13
  mov qword rax, 0
  call printf
  ; and that terms value (2/2)
  push rcx
  mov rax, 1
  mov rdi, current
  movsd xmm0, xmm15
  call printf
  pop rcx
  mov rbx, 0

; Increment the loop counters and get ready to add the next term.
no_report:
inc rbx
inc r13
jmp next_term

; ==============================================================
; --------------------------------------------------------------

calculation_complete:
; Get the end time
mov rax, 0
call get_time
mov r12, rax

; Display the results from get time.
mov qword rdi, time_after
mov qword rsi, r12
mov qword rdx, r12
mov qword rax, 0
call printf

; Get the start time in seconds -----------------------------------------
; Compare the time and move it to a floating point xmm register
sub r12, r15
cvtsi2sd xmm12, r12

; Get the get the frequency of the computers processor
mov rax, 0
call getfreq
movsd xmm11, xmm0

; The speed is in Ghz, multiply 1000000000 to get the speed in hz.
mov rcx, 1000000000
cvtsi2sd xmm10, rcx
mulsd xmm11, xmm10

; Divide the tics taken by tics per second to get the amount of time it took the program to run.
divsd xmm12, xmm11
; ---------------------------------------------------------------

; Display time after (1/2)
mov qword rdi, total_tics
mov qword rsi, r12
mov qword rdx, r12
mov qword rax, 0
call printf

; Display the time taken computation. (2/2)
push rcx
mov rax, 1
mov rdi, seconds
movsd xmm0, xmm12
call printf
pop rcx

; Inform the user that manger.asm is about to finish running.
mov qword rdi, stringoutputformat
mov qword rsi, goodbye
mov qword rax, 0
call printf

; Store the answer into xmm0 so it can be returned to the driver.
movsd xmm0, xmm15

; Restore the original values to the general registers before returning to the caller.
pop r15                                                     ;Remove the extra -1 from the stack
popf                                                        ;Restore rflags
pop rbx                                                     ;Restore rbx
pop r15                                                     ;Restore r15
pop r14                                                     ;Restore r14
pop r13                                                     ;Restore r13
pop r12                                                     ;Restore r12
pop r11                                                     ;Restore r11
pop r10                                                     ;Restore r10
pop r9                                                      ;Restore r9
pop r8                                                      ;Restore r8
pop rcx                                                     ;Restore rcx
pop rdx                                                     ;Restore rdx
pop rsi                                                     ;Restore rsi
pop rdi                                                     ;Restore rdi
pop rbp                                                     ;Restore rbp

; Pass back the result of the area computation to the main file.
ret
