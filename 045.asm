section .data
    msg db "%lld", 10, 0  ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    mov     rbx, 165    ;init n

next:
    inc     rbx         ;next n
    mov     rax, rbx    ;get P(n)
    imul    rax, 3
    dec     rax
    mul     rbx
    shr     rax, 1      ;rax is now P(n), next test for "hexagonality"
    mov     r8, rax     ;and save a copy for printing the result later
    shl     rax, 3      ;8 x P(n)
    inc     rax         ;8 x P(n) + 1
    mov     rdi, 1      ;init rdi for squaretest

squaretest:
    inc     rdi         ;next candidate
    mov     rsi, rdi    ;copy to rsi
    imul    rsi, rdi    ;square
    cmp     rsi, rax    ;check if square = rax
    jg      next        ;if greater, rax is no perfect square
    jl      squaretest  ;if lower, continue

hextest:
    inc     rdi         ;sqrt(8 * P(n) + 1) + 1
    test    rdi, 3      ;check if evenly divisible by 4 (last two bits are 0)?
    jnz     next        ;if not, try next n
        
print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     rsi, r8
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
