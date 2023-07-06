.686
.model flat, stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
.data
A db 2
B db -120
X dw 0
Hello   db 13, 10, ' X = A/B - 1 if A < B', 13, 10
        db ' X = 10 - A if A = B', 13, 10
        db ' X = (-2 * B - 5)/A if A > B', 13, 10
Operands db 13, 10, ' A =       B =      ', 13, 10
NumberOfCharsToWrite_Hello dd $-Hello
Error db 13, 10, ' Error - Devided by zero!', 13, 10
NumberOfCharsToWrite_Error dd $-Error
Result db 13, 10, ' X =    ', 13, 10
NumberOfCharsToWrite_Result dd $-Result
format db '%hd', 0
hConsoleOutput dd 0
NumberOfCharsWritten dd 0
.code
start:
;вивід повідомлення Hello
mov al, A
cbw
push ax
push offset format
push offset [Operands+8]
call wsprintfA
mov al, B
cbw
push ax
push offset format
push offset [Operands+17]
call wsprintfA
push -11
call GetStdHandle
mov hConsoleOutput, eax
push 0
push offset NumberOfCharsWritten
push NumberOfCharsToWrite_Hello
push offset Hello
push hConsoleOutput
call WriteConsoleA
; X = A == B ? (10 - A) : goto AnotB
        movsx   edx, A      ; edx = A
        movsx   eax, B      ; eax = B
        cmp     edx, eax    ; edx == eax
        jne     AnotB       ; якщо ні, то goto AnotB
        movsx   ecx, A      ; ecx = A
        mov     edx, 10     ; edx = 10
        sub     edx, ecx    ; edx - ecx
        mov     X, dx       ; X = dx
        jmp     GoToOutput  ; goto GoToOutput
AnotB:
; X = A < B ? (A/B + 1) : goto AnotLessB
        movsx   eax, A      ; eax = A
        movsx   ecx, B      ; ecx = B
        cmp     eax, ecx    ; eax < ecx
        jge     AnotLessB   ; якщо ні, то goto AnotLessB
        cmp ecx, 0          ; ecx == 0
        je      OutputError ; якщо так, то goto OutputError
        movsx   eax, A      ; eax = A
        movsx   ecx, B      ; ecx = B
        cdq
        idiv    ecx         ; A / B
        sub     eax, 1      ; A/B + 1
        mov     X, ax       ; X = ax
        jmp     GoToOutput  ; goto GoToOutput
AnotLessB:
;X = A < B ? ((-2 * B - 5)/A) : goto GoToOutput
        movsx   eax, A      ; eax = A
        movsx   ecx, B      ; ecx = B
        cmp     eax, ecx    ; eax > ecx
        jle     GoToOutput  ; якщо ні, то goto GoToOutput
        cmp     eax, 0      ; eax == 0
        je      OutputError ; якщо так, то goto OutputError
        movsx   edx, B      ; edx = B
        imul    eax, edx, -2; -2 * B
        sub     eax, 5      ; -2 * B - 5
        movsx   ecx, A      ; ecx = A
        cdq
        idiv    ecx         ; (-2 * B - 5) / A
        mov     X, ax       ; X = ax
;вивід результату
GoToOutput:
push X
push offset format
push offset [Result+8]
call wsprintfA
push offset NumberOfCharsWritten
push NumberOfCharsToWrite_Result
push offset Result
push hConsoleOutput
call WriteConsoleA
jmp exit
;вивід повідомлення про ділення на нуль
OutputError:
push offset NumberOfCharsWritten
push NumberOfCharsToWrite_Error
push offset Error
push hConsoleOutput
call WriteConsoleA
jmp exit
;вихід з програми
exit:
push 0
call ExitProcess
end start