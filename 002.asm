section .data
    msg db "%d", 10, 0              ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    xor     eax, eax    ;result
    mov     ebx, 1      ;fib (n-1)
    mov     ecx, 2      ;fib (n)

fib:
    test    ecx, 1      ;check if number is odd
    jnz     odd         ;if it is, jump to odd
    add     eax, ecx    ;if even, add to result

odd:
    xadd    ecx, ebx        ;exchange ebx and ecx, put the sum in ecx
    cmp     ecx, 4000000    ;check if we are still under 4 million
    jl      fib             ;if yes, back to fib

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, eax
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
