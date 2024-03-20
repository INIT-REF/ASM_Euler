
section .data
    msg db "%d", 10, 0        ;return string for printf (just the result)

section .text
extern printf
global main

main:
    mov     rbx, 600851475143   ;the number to factor
    mov     rcx, 2              ;initialize rcx for trial divisions
    test    rbx, 1              ;check if number is even
    jz      divide2             ;if it is, jump to divide2

divide2:
    mov     rax, rbx    ;put current number in rax as the dividend
    xor     rdx, rdx    ;prepare rdx which will store the remainder
    div     rcx         ;divide by 2
    test    rdx, rdx    ;check if remainder is zero
    jnz     odd         ;if not, continue with odd divisors
    mov     rbx, rax    ;put result of last division in rbx
    cmp     rbx, 4      ;check if greater or equal to 4
    jge     divide2     ;if yes, continue divisions
    jl      switch      ;if not, the number has arrived at 2
                        ;or the remainder is a prime greater than 2

odd:
    mov     rcx, 1      ;set rcx to 1 to prepare for odd divisors

incdiv:
    add     rcx, 2      ;increase by 2 (so we begin with 3)

divide:
    mov     rax, rbx    ;put current number in rax as the dividend
    xor     rdx, rdx    ;prepare rdx which will store the remainder
    div     rcx         ;divide by current divisor
    test    rdx, rdx    ;check if remainder is zero
    jnz     incdiv      ;if not, jump to incdiv
    mov     rbx, rax    ;put result of last division in rbx
    mov     rax, rcx    ;put current divisor in rax
    mul     rax         ;square of current divisor (rax * rax)
    cmp     rax, rbx    ;check if less or equal to current dividend
    jle     divide      ;if yes, continue divisions
    cmp     rcx, rbx    ;else compare last factor with dividend
    jg      print       ;if the factor is greater, print that

switch:
    mov     rcx, rbx    ;else print the dividend


print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     rdi, msg
    mov     rsi, rcx
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     rax, 1
    xor     rdi, rdi
    syscall

section .note.GNU-stack     ;just for gcc
