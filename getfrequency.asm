;Author: Floyd Holliday
;Library program name: Get Processor Frequency
;Purpose: Extract the CPU max speed from the processor

;Prototype:  double getfreq()

;Translation: nasm -f elf64 -o freq.o getfrequency.asm

global getfreq

extern atof

segment .data

segment .bss

segment .text
getfreq:

;Back up all GPRs: to be inserted later
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
push r15                                               ;Now the number of pushes is even

;Extract data from processor in the form of two 4-byte strings
mov rax, 0x0000000080000004
cpuid
;Answer is in ebx:eax as big endian strings
mov       r15, rbx      ;Second part of string saved in r15
mov       r14, rax      ;First part of string saved in r14


;Catenate the two short strings into one 8-byte string in big endian
and r15, 0x00000000000000FF    ;Convert non-numeric chars to nulls
shl r15, 32
or r15, r14                    ;Combined string is in r15


;Convert string to quadword numeric double.
push r15
mov rax,1
mov rdi,rsp
call atof          ;The number is now in xmm0
pop rax


;Restore the values of all GPRs: to be inserted later
;Restore the original values to the general registers before returning to the caller.
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

ret
