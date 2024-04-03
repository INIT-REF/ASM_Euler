section .data
    msg db "%lld", 10, 0    ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    mov     rax, 1      ;result
    mov     rbx, 1      ;loop counter

paths:
    mov     rcx, rbx    ;copy counter to rcx
    add     rcx, 20     ;add 20
    mul     rcx         ;multiply rax * rcx
    div     rbx         ;divide by counter
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
