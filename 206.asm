section .data
    msg db "%lld", 10, 0              ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    mov     rbx, 1010101010     ;square root of 1020304050607080900
    mov     rcx, 10             ;for divisions
    mov     rsi, 100            ;dito

nextn:
    add     rbx, 10     ;next candidate (must be a multiple of 10)
    mov     rax, rbx    ;in rax for mul/div
    mul     rbx         ;square
    mov     rdi, 9      ;reset rdi to 9
    xor     rdx, rdx    ;reset remainder
    div     rsi         ;divide by 100 to get to the "9" digit

digits:
    xor     rdx, rdx    ;reset remainder
    div     rcx         ;divide by 10
    cmp     rdx, rdi    ;remainder = rdi?
    jne     nextn       ;if not, try next number
    xor     rdx, rdx    ;else reset remainder
    div     rcx         ;divide by 10 to skip _ digit
    dec     rdi         ;decrease rdi
    test    rdi, rdi    ;still > 0?
    jnz     digits      ;if yes, repeat
    
print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     rsi, rbx
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
