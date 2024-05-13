section .data
    msg db "%lld", 10, 0              ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    mov     rbx, 1010101030     ;square root of 1020304050607080900 + 20
    mov     rcx, 10             ;for divisions
    mov     rsi, 10000          ;dito
    xor     r8d, r8d            ;counter
    mov     r10d, 60            ;for adding 60 if counter is even

nextn:
    mov     r9d, 40     ;for adding 40 if counter is odd
    inc     r8d         ;increase counter
    test    r8d, 1      ;is counter even?
    cmovz   r9d, r10d   ;if yes, set r9d to 60
    add     rbx, r9     ;add 40 or 60 (last two digits need to be 30 or 70)
    mov     rax, rbx    ;in rax for mul/div
    mul     rbx         ;square
    mov     rdi, 8      ;reset rdi to 8
    xor     rdx, rdx    ;reset remainder
    div     rsi         ;divide by 10000 to get to the "8" digit

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
