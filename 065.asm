section .data
    msg db "%d", 10, 0      ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    mov     rdi, 3      ;counter
    mov     rbx, 2      ;n-2
    mov     rcx, 3      ;n-1
    mov     rsi, 3      ;for divisions

find100th:
    mov     rax, rdi    ;counter in eax
    xor     rdx, rdx    ;reset remainder
    div     rsi         ;divide by 3
    test    rdx, rdx    ;test remainder
    jnz     not3rd      ;if not zero jump to not3rd
    shl     rax, 1      ;else double result
    jmp     next        ;and jump to next
    
not3rd:
    mov     rax, 1      ;set eax to 1

next:
    inc     rdi         ;increase counter
    mul     rcx         ;multiply n-1 by eax
    add     rax, rbx    ;add n-2
    mov     rbx, rcx    ;n-2 is now old n-1
    mov     rcx, rax    ;n-1 is now new n
    cmp     rdi, 101    ;limit reached?
    je      getdigits   ;if yes, get the digits of n
    jmp     find100th   ;and repeat

getdigits:
    xor     rbx, rbx    ;sum
    mov     rcx, 10     ;for divisions

digitloop:
    xor     rdx, rdx    ;reset remainder
    div     rcx         ;divide by 10
    add     rbx, rdx    ;add digit to sum
    test    rax, rax    ;eax reduced to 0?
    jnz     digitloop   ;if not, repeat

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
