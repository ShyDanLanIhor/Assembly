.686
.model flat, stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\msvcrt.lib

.data
A dd 0
X dd 10 dup(0)          ; масив
N equ ($-X) / type X    ; розмір масиву
hConsoleInput dd 0      ; дескриптор введення консолі
hConsoleOutput dd 0     ; дескриптор виведення консолі
NumberOfChars dd 0      ; кількість прочитаних або написаних символів
ReadBuf db 32 dup(0)    ; буфер для введення
MessageInputA db 'Enter the value of A: ', 10, 13
NumberOfChToWMessageA dd $-MessageInputA
MessageInputX db 'Input elements of array: ', 10, 13
NumberOfChToWMessageX dd $-MessageInputX
Greater db '1 - There are more numbers greater than A', 13, 10, 0
Smaller db '0 - There are more numbers smaller than A', 13, 10, 0
Equal db '0 - The number of smaller and larger numbers for A is the same', 13, 10, 0

.code
start:
    call InputA
    call InputX
    push A
    push X
    push N
    call Calculation
    add esp, 12 ; очищаю стек після виклику функції
    push ebx
    call Output
    pop ebx
invoke ExitProcess, 0

; процедура введення А
InputA proc
    invoke GetStdHandle, -11
    mov hConsoleOutput, eax
    invoke WriteConsoleA, hConsoleOutput, addr MessageInputA, NumberOfChToWMessageA, addr NumberOfChars, 0
    invoke GetStdHandle, -10
    mov hConsoleInput, eax
    invoke ReadConsoleA, hConsoleInput, addr ReadBuf, 32, addr NumberOfChars, 0
    invoke crt_atoi, addr ReadBuf
    mov A, eax
    ret
InputA endp

; процедура введення - параметри, що передаються через глобальні змінні
InputX proc
    invoke GetStdHandle, -11
    mov hConsoleOutput, eax
    invoke WriteConsoleA, hConsoleOutput, addr MessageInputX, NumberOfChToWMessageX, addr NumberOfChars, 0
    invoke GetStdHandle, -10
    mov hConsoleInput, eax
    mov ecx, N
    lea ebx, X
    mov edi, 0

    L_input:
        push ecx
        invoke ReadConsoleA, hConsoleInput, addr ReadBuf, 32, addr NumberOfChars, 0
        invoke crt_atoi, addr ReadBuf
        pop ecx
        mov [ebx][edi], eax
        add edi, 4
    loop L_input

    ret
InputX endp

    ; процедура обчислення - параметри, передані через стек, результат в eax
Calculation proc
    push ebp
    mov ebp, esp
    mov ecx, [ebp + 8] ; ecx = N
    mov ebx, 0 ;кількість чисел більших за А
    mov edx, 0 ;кількість чисел менших за А

    L:
            mov eax, [X + ecx * type X - type X]
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

    mov eax, ebx ; повернення кількості чисел, більших за A
    pop ebp
    ret 10 ; очищення стеку і повернутися
Calculation endp

; процедура виведення - параметри, що передаються через глобальні змінні
Output proc
       ; Порівняння кількості елементів, більших і менших за А
    cmp ebx, edx
    je EqualCount
    jl SmallerThanA
    jg GreaterThanA

    EqualCount:
        ; Якщо дорівнює, відобразити повідомлення Equal
        invoke GetStdHandle, -11
        mov hConsoleOutput, eax
        invoke WriteConsoleA, hConsoleOutput, addr Equal, 62, addr NumberOfChars, 0
        jmp EndOfComparation

    SmallerThanA:
        ; Якщо більше елементів менші за A, відобразити повідомлення Smaller
        invoke GetStdHandle, -11
        mov hConsoleOutput, eax
        invoke WriteConsoleA, hConsoleOutput, addr Smaller, 43, addr NumberOfChars, 0
        jmp EndOfComparation

    GreaterThanA:
        ; Якщо більше елементів більше за A, відобразити повідомлення Greater
        invoke GetStdHandle, -11
        mov hConsoleOutput, eax
        invoke WriteConsoleA, hConsoleOutput, addr Greater, 43, addr NumberOfChars, 0

    EndOfComparation:
    ret
Output endp

end start