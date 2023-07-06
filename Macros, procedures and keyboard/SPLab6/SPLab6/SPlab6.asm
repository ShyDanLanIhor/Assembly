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
X dd 10 dup(0)          ; �����
N equ ($-X) / type X    ; ����� ������
hConsoleInput dd 0      ; ���������� �������� ������
hConsoleOutput dd 0     ; ���������� ��������� ������
NumberOfChars dd 0      ; ������� ���������� ��� ��������� �������
ReadBuf db 32 dup(0)    ; ����� ��� ��������
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
    add esp, 12 ; ������ ���� ���� ������� �������
    push ebx
    call Output
    pop ebx
invoke ExitProcess, 0

; ��������� �������� �
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

; ��������� �������� - ���������, �� ����������� ����� �������� ����
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

    ; ��������� ���������� - ���������, ������� ����� ����, ��������� � eax
Calculation proc
    push ebp
    mov ebp, esp
    mov ecx, [ebp + 8] ; ecx = N
    mov ebx, 0 ;������� ����� ������ �� �
    mov edx, 0 ;������� ����� ������ �� �

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

    mov eax, ebx ; ���������� ������� �����, ������ �� A
    pop ebp
    ret 10 ; �������� ����� � �����������
Calculation endp

; ��������� ��������� - ���������, �� ����������� ����� �������� ����
Output proc
       ; ��������� ������� ��������, ������ � ������ �� �
    cmp ebx, edx
    je EqualCount
    jl SmallerThanA
    jg GreaterThanA

    EqualCount:
        ; ���� �������, ���������� ����������� Equal
        invoke GetStdHandle, -11
        mov hConsoleOutput, eax
        invoke WriteConsoleA, hConsoleOutput, addr Equal, 62, addr NumberOfChars, 0
        jmp EndOfComparation

    SmallerThanA:
        ; ���� ����� �������� ����� �� A, ���������� ����������� Smaller
        invoke GetStdHandle, -11
        mov hConsoleOutput, eax
        invoke WriteConsoleA, hConsoleOutput, addr Smaller, 43, addr NumberOfChars, 0
        jmp EndOfComparation

    GreaterThanA:
        ; ���� ����� �������� ����� �� A, ���������� ����������� Greater
        invoke GetStdHandle, -11
        mov hConsoleOutput, eax
        invoke WriteConsoleA, hConsoleOutput, addr Greater, 43, addr NumberOfChars, 0

    EndOfComparation:
    ret
Output endp

end start