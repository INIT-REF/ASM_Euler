section .data
    msg db "%d", 10, 0              ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    xor     eax, eax
    xor     ebx, ebx    ;r in Dickson's method
    xor     ecx, ecx    ;r^2 / 2 in Dickson's method

next:
    add     ebx, 2      ;the next even r (odd values not allowed)
    mov     eax, ebx    ;put number in eax for multiplication
    mul     ebx         ;square
    shr     eax, 1      ;half
    mov     ecx, eax    ;put r^2 / 2 in ecx
    xor     edi, edi    ;for divisors of r^2 / 2

triplets:
    inc     edi         ;next divisor candidate
    mov     eax, edi    ;candidate in eax
    mul     edi         ;square
    cmp     eax, ecx    ;check if square of candidate is less than r^2 / 2
    jg      next        ;if not, go to next higher r
    xor     edx, edx    ;prepare remainder
    mov     eax, ecx    ;r^2 / 2 in eax for division
    div     edi         ;divide by current divisor
    test    edx, edx    ;check if remainder is zero
    jnz     triplets    ;if not, continue with next divisor
    mov     edx, ebx    ;a = r
    add     edx, edi    ;a = r + s
    mov     esi, ebx    ;b = r
    add     esi, eax    ;b = r + t
    mov     eax, esi    ;c = r + t
    add     eax, edi    ;c = r + s + t
    push    rdx         ;push rdx on the stack for later use
    push    rax         ;push rax on the stack, dito
    add     eax, esi    ;perimeter
    add     eax, edx
    cmp     eax, 1000   ;check if perimeter = 1000
    jne     triplets    ;if not, continue with next candidate
    pop     rax         ;if yes, compute a * b * c
    mul     esi
    pop     rdx
    mul     edx

print:                  ;printing routine, differs slightly from OS to OS
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
