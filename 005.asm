section .data
    msg db "%d", 10, 0              ;return string for printf (just the result)

section .text
extern printf
global main

main:
    mov     eax, 1      ;put 1 in eax
    mov     ebx, 1      ;put 1 in ebx, will be increased in the nest step

next:
    inc     ebx         ;increase eax to compule GCD/LCM with next number
    push    rbx         ;push both numbers on the stack for LCM later
    push    rax

gcd_start:
    cmp     eax, ebx    ;check if eax > ebx
    jg      gcd_mod     ;if yes, jump to the gcd loop
    xchg    ebx, eax    ;if not, exchange both numbers
    
gcd_mod:
    test    eax, eax    ;check if eax or ebx are 0 and go to gcd if one of them is
    jz      gcd
    test    ebx, ebx
    jz      gcd
    xor     edx, edx    ;prepare rdx for the remainder    
    div     ebx         ;divide by the smaller number
    mov     eax, edx    ;replace bigger number with remainder
    jmp     gcd_start   ;back to the start with the new numbers

gcd:
    test    ebx, ebx    ;check if ebx is zero
    jz      lcm         ;if it is, go directly to lcm
    mov     eax, ebx    ;if not, replace eax with ebx (as eax was zero)

lcm:
    mov     ebx, eax    ;put gcd in ebx for division
    pop     rax         ;get original number 1 from the stack
    div     ebx         ;divide by gcd
    pop     rbx         ;get original number 2 from the stack
    mul     ebx         ;multiply
    cmp     ebx, 20     ;check if ebx is still below 20 
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
