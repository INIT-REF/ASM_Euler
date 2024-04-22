section .data
    msg db "%d", 10, 0  ;return string for printf (just the result)

section .bss
    pent resd 2501      ;for the first 2500 pentagonal numbers
    ispent resb 9373750 ;flags for pentagonal numbers

section .text
    extern printf
    global main

main:
    xor     edi, edi    ;array index for pentagonals

setuppent:
    inc     edi                     ;n for next pentagonal number
    mov     eax, edi                ;n in eax
    lea     eax, [eax + 2 * eax]    ;3n
    dec     eax                     ;3n-1
    mul     edi                     ;n(3n-1)
    shr     eax, 1                  ;n(3n-1)/2
    mov     [pent + 4 * edi], eax   ;result in pent[edi]
    mov     byte [ispent + eax], 1  ;set flag
    cmp     edi, 2500               ;end of array?
    jl      setuppent               ;if not, continue
    xor     edi, edi                ;reset registers for next op

findpair_outer:
    inc     edi                     ;next index for outer loop
    mov     esi, edi                ;index for inner loop
    mov     eax, [pent + 4 * edi]   ;first number of pair

findpair_inner:
    inc     esi
    cmp     esi, 2500               ;end of array?
    jg      findpair_outer          ;if yes, try next first number
    mov     ebx, [pent + 4 * esi]   ;second number of pair
    mov     ecx, ebx                ;copy of ebx for difference
    sub     ecx, eax                ;difference
    mov     r10d, ecx               ;copy difference in r10d
    cmp     byte [ispent + ecx], 0  ;is difference pentagonal?
    je      findpair_inner          ;if not, try next pair
    mov     ecx, ebx                ;ebx back in ecx
    add     ecx, eax                ;sum
    cmp     ecx, [pent + 10000]     ;sum > limit?
    jg      findpair_outer          ;if yes, continue with next outer 
    cmp     byte [ispent + ecx], 0  ;is sum pentagonal?
    je      findpair_inner          ;if not, try next pair

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, r10d
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
