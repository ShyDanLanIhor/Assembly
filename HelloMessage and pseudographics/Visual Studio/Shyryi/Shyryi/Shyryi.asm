.686
.model flat, stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib
.data
hConsoleOutput dd 0
NumberOfCharsWritten dd 0
ShyryiMessage db 'Shyryi', 10, 13
NumberOfCharsToWrite dd $-ShyryiMessage
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