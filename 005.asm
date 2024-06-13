section .data
    msg db "%d", 10, 0  ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    mov     eax, 1      ;put 1 in eax
    mov     ebx, 1      ;put 1 in ebx, will be increased in the nest step

next:
    inc     ebx         ;increase eax to compute GCD/LCM with next number
    push    rbx         ;push both numbers on the stack for LCM later
    push    rax

gcd:
    xchg    eax, ebx        ;get gcd(m, n), result in ebx
    xor     edx, edx
    div     ebx
    mov     eax, edx
    test    eax, eax
    jnz     gcd

lcm:
    pop     rax         ;get original number 1 from the stack
    div     ebx         ;divide by gcd
    pop     rbx         ;get original number 2 from the stack
    mul     ebx         ;multiply
    cmp     ebx, 20     ;check if ebx is still <= 20 
    jle     next        ;if it is, continue with next number

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
