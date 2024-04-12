section .data
    msg db "%d", 10, 0  ;return string for printf (just the result)
    p times 1000 dd 0

section .text
    extern printf
    global main

main:
    xor     ebx, ebx    ;r in Dickson's method

next:
    add     ebx, 2      ;the next even r (odd values not allowed)
    cmp     ebx, 170    ;finished?
    je      finished    ;if yes, find max count
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
    add     r8d, r9d    ;perimeter
    add     r8d, r10d
    cmp     r8d, 1000   ;perimeter > 1000
    jg      triplets    ;if yes, try next divisor
    inc     dword [p + 4 * r8d] ;else increase perimeter count
    jmp     triplets    ;and continue

finished:
    xor     eax, eax    ;array index
    xor     ebx, ebx    ;max solutions

getmax:
    inc     eax                         ;next perimeter
    cmp     eax, 1000                   ;end of array?
    jg      print                       ;if yes, print result
    cmp     dword [p + 4 * eax], ebx    ;solutions > max?
    jl      getmax                      ;if not, continue
    mov     ebx, [p + 4 * eax]          ;if yes, set new max
    mov     ecx, eax                    ;and save perimeter
    jmp     getmax                      ;and continue

print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, ecx
    call    printf
    pop     rbp

exit:                   ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack ;just for gcc
