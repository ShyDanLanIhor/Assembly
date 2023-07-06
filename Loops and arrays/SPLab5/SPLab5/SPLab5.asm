.686
.model flat, stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
.data
A dd 7
X dd 10, 10, 10, 10, 5, 6, 7, 8, 9, 10 ;масив
N equ ($-X) / type X ;розмір масиву
Greater db '1 - There are more numbers greater than A', 13, 10, 0
Smaller db '0 - There are more numbers smaller than A', 13, 10, 0
Equal db '0 - The number of smaller and larger numbers for A is the same', 13, 10, 0
hConsoleOutput dd 0
NumberOfCharsWritten dd 0
.code
start:
;обчислення кількості чисел більших та менших за A
mov ecx, N
mov ebx, 0 ;кількість чисел більших за А
mov edx, 0 ;кількість чисел менших за А
L:
mov eax, [X + ecx * type X - type X] ; значення елемента X[ECX-1] в регістр EAX
cmp eax, A
jg GreaterCount
jl SmallerCount
jmp Next
GreaterCount:
inc ebx
jmp Next
SmallerCount:
inc edx
Next:
loop L
;вивід результату
cmp ebx, edx
je EqualCount
jl MoreSmaller
push offset Greater
push -11
call GetStdHandle
mov hConsoleOutput, eax
push 0
push offset NumberOfCharsWritten
push sizeof Greater
push offset Greater
push hConsoleOutput
call WriteConsoleA
jmp EndProgram
EqualCount:
push offset Equal
push -11
call GetStdHandle
mov hConsoleOutput, eax
push 0
push offset NumberOfCharsWritten
push sizeof Equal
push offset Equal
push hConsoleOutput
call WriteConsoleA
jmp EndProgram
MoreSmaller:
push offset Smaller
push -11
call GetStdHandle
mov hConsoleOutput, eax
push 0
push offset NumberOfCharsWritten
push sizeof Smaller
push offset Smaller
push hConsoleOutput
call WriteConsoleA
EndProgram:
push 0
call ExitProcess
end start