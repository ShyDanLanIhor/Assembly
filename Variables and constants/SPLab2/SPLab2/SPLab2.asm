.686
.model flat, stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib
.data
    A dw 1234h, 0710h, 2003h 
    B dw 5678h
    Cc dd 10.25
LBL LABEL BYTE
    D dt 7
    E db 10
    F dq 11111010011b
    K equ 74569024
ShyryiMessage db 'Shyryi',13,10
NumberOfCharsToWrite dd $-ShyryiMessage
hConsoleOutput dd 0
NumberOfCharsWritten dd 0
.code
start:
push -11
call GetStdHandle
mov hConsoleOutput, eax
push 0
push offset NumberOfCharsWritten
push NumberOfCharsToWrite
push offset ShyryiMessage
push hConsoleOutput
call WriteConsoleA
push 0
call ExitProcess
end start