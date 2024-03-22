section .data
    msg db "%d", 10, 0  ;return string for printf (just the result)

section .text
extern printf
global main

main:
    mov     edi, 1      ;counter
    xor     ebx, ebx    ;for the square of sum
    xor     ecx, ecx    ;for the sum of squares

calc:
    add     ebx, edi    ;add current number to sum
    mov     eax, edi    ;put current number in eax
    mul     edi         ;square it
    add     ecx, eax    ;add result to sum of squares
    inc     edi         ;increase counter
    cmp     edi, 100    ;check if we reached 100
    jle     calc        ;if <= 100, continue
    mov     eax, ebx    ;else put sum in eax
    mul     ebx         ;square the sum
    sub     eax, ecx    ;subtract sum of squares

print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, eax
    call    printf
    pop     rbp

exit:                   ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
