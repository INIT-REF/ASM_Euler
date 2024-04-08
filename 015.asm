section .data
    msg db "%lld", 10, 0    ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    mov     rax, 1      ;result
    mov     rbx, 1      ;loop counter

paths:
    mov     rcx, 41     ;put 41 in rcx (n + 1)
    sub     rcx, rbx    ;subtract rbx (n + 1 - i)
    mul     rcx         ;multiply
    div     rbx         ;divide (/i)
    inc     rbx         ;increase counter
    cmp     rbx, 20     ;check if counter is <= 20
    jle     paths       ;if yes, repeat

print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     rsi, rax
    call    printf
    pop     rbp

exit:                   ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack ;just for gcc
