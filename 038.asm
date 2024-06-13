section .data
    msg db "%d", 10, 0          ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    mov     ebx, 1      ;init multiplicand
    xor     r8d, r8d    ;max
    mov     r10d, 10    ;for divisions

next:
    inc     ebx         ;next number
    cmp     ebx, 10000  ;number >= 10000
    jge     print       ;if yes, we are finished
    mov     ecx, 1      ;init n
    mov     esi, ebx    ;number in esi (number * 1)

multiply:
    inc     ecx         ;next n
    cmp     ecx, 10     ;is n = 10?
    je      next        ;if yes, try next number
    mov     eax, ebx    ;number in eax
    mul     ecx         ;multiply by n
    mov     edi, 1      ;1 in edi

combine:
    imul    edi, 10         ;multiply edi by 10
    imul    esi, 10         ;multiply esi by 10
    cmp     edi, eax        ;until edi is > eax
    jl      combine
    add     esi, eax        ;add eax to esi
    cmp     esi, 987654321  ;result > 987654321?
    jg      next            ;if yes, try next number
    cmp     esi, 123456789  ;result < 123456789
    jl      next            ;dito
    mov     eax, esi        ;put result in eax
    xor     r9d, r9d        ;reset r9d
    
_loop:
    xor     edx, edx        ;reset remainder
    div     r10d            ;divide by 10
    bts     r9d, edx        ;set bit @ remainder
    test    eax, eax        ;number reduced to 0?
    jnz     _loop           ;if not, repeat
    cmp     r9d, 1022       ;if r8d = 1022, number is 1-9 pandigital
    jne     multiply        ;else continue with multiplication
    cmp     esi, r8d        ;update max
    cmovg   r8d, esi
    jmp     next

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, r8d
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

digits:
    ret

section .note.GNU-stack     ;just for gcc
