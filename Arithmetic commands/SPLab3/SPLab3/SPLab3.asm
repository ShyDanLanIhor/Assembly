.686
.model flat, stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
.data
K EQU 74569024h
B dw 10000
Cc db -10
D dd 100000
E dw 10000
F dw -10000
X dd ?
Message db 'X = K - B / C + D + E * F =                ', 13, 10
NumberOfCharsToWrite dd $-Message
format db '%d', 0
hConsoleOutput dd 0
NumberOfCharsWritten dd 0

.code
start:
;X = K - B / C + D + E * F

; B / C ---> eax
movsx   eax, B		; eax = B
movsx   ecx, Cc		; ecx = Cc
cdq
idiv    ecx			;15h / 4h = 3h

; K - ecx ---> ecx
mov     edx, K		; edx = K
sub     edx, eax	; 74569024h - 3h = 74569021h

add     edx, D		; 74569021h + 2003h = 7456B024h

; E * F ---> eax
movsx   eax, E		; eax = E
movsx   ecx, F		; ecx = F
imul    eax, ecx	; 10h * 24h = 240h

add     edx, eax	; 7456B024h + 240h = 7456B264h
mov     X, edx		; X = edx (результат)

push X
push offset format
push offset [Message+28]
call wsprintfA
push -11
call GetStdHandle
mov hConsoleOutput, eax
push 0
push offset NumberOfCharsWritten
push NumberOfCharsToWrite
push offset Message
push hConsoleOutput
call WriteConsoleA
push 0
call ExitProcess
end start