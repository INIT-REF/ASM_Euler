section .data
    msg db "%d", 10, 0  ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    xor     ebx, ebx    ;r in Dickson's method

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
    mov     r8d, ebx    ;a = r
    add     r8d, edi    ;a = r + s
    mov     r9d, ebx    ;b = r
    add     r9d, eax    ;b = r + t
    mov     r10d, r9d   ;c = r + t
    add     r10d, edi   ;c = r + s + t
    mov     eax, r8d    ;put a in eax for product
    add     r8d, r9d    ;perimeter
    add     r8d, r10d
    cmp     r8d, 1000   ;check if perimeter = 1000
    jne     triplets    ;if not, continue with next candidate
    mul     r9d         ;calculate product
    mul     r10d

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

section .note.GNU-stack ;just for gcc
