section .data
    msg db "%lld", 10, 0    ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    mov     rbx, 10000000000    ;for mod 1e10
    xor     rdi, rdi            ;number
    xor     rcx, rcx            ;sum

next:
    inc     rdi         ;next number
    cmp     rdi, 1000   ;finished?
    jg      finished    ;if yes, jump to finished
    mov     rax, rdi    ;copy number in rax
    mov     rsi, 1      ;exponent count

power:
    mul     rdi         ;multiply
    xor     rdx, rdx    ;reset remainder
    div     rbx         ;divide by 1e10
    mov     rax, rdx    ;move remainder in rax
    inc     rsi         ;next iteration
    cmp     rsi, rdi    ;power finished?
    jl      power       ;if not, continue
    add     rcx, rax    ;else add result to sum
    jmp     next        ;and jump to next

finished:
    mov     rax, rcx    ;sum in rax
    xor     rdx, rdx    ;reset remainder
    div     rbx         ;divide by 1e10

print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     rsi, rdx
    call    printf
    pop     rbp

exit:                   ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
