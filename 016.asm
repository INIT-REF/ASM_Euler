section .data
    msg db "%d", 10, 0              ;return string for printf (just the result)
    num times 17 dq 0               ;1088 bits for 2^1000 + extra
    
section .bss
    e18 equ 1000000000000000000     ;1e18 for splitting the number

section .text
    extern printf
    global main

main:
    xor     rbx, rbx                    ;carry
    mov     edi, 16                     ;array index
    mov     rcx, e18                    ;for divisions
    mov     esi, 1000                   ;power counter
    mov     qword [num + 8 * edi], 1    ;initial state

power:
    dec     esi                         ;decrease counter
    mov     edi, 17                     ;reset index

multiply:
    dec     edi
    xor     rdx, rdx                    ;reset remainder
    mov     rax, [num + 8 * edi]        ;put current digit in eax
    shl     rax, 1                      ;double
    add     rax, rbx                    ;add carry
    div     rcx                         ;divide by 1e18
    mov     rbx, rax                    ;carry = result
    mov     [num + 8 * edi], rdx        ;num @ edi = remainder
    test    edi, edi                    ;check if index >= 0
    jnz     multiply                    ;if yes, repeat
    test    esi, esi                    ;check if completed
    jnz     power                       ;if not, jump to power
    xor     rax, rax                    ;else reset registers
    xor     ecx, ecx
    mov     rbx, 10
    mov     edi, 17

sum:                                    ;sum all digits
    dec     edi
    mov     rax, [num + 8 * edi]
    
sumloop:
    xor     rdx, rdx
    div     rbx
    add     ecx, edx
    test    rax, rax
    jnz     sumloop
    test    edi, edi
    jnz     sum
    
print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, ecx
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
