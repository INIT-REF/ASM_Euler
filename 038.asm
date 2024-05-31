section .data
    msg db "%d", 10, 0          ;return string for printf (just the result)
    abc times 10 db 0           ;digits in number
    pds db 0,1,1,1,1,1,1,1,1,1  ;pandigital string

section .text
    extern printf
    global main

main:
    mov     ebx, 1      ;init multiplicand
    xor     r10d, r10d  ;max
    mov     r11d, 10    ;for divisions

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
    mov     eax, esi        ;put result in eax
    call    digits          ;get the digits in abc string
    call    cmpstr          ;compare abc with pds
    cmp     r9d, r11d       ;if r9d != r11d, number is pandigital
    je      multiply        ;else continue with multiplication

updatemax:
    cmp     esi, r10d       ;update max
    cmovg   r10d, esi
    jmp     next

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

digits:
    xor     r8, r8          ;reset r8
    mov     [abc], r8       ;clear abc
    mov     [abc + 2], r8

convert:
    xor     edx, edx            ;reset remainder
    div     r11d                ;divide by 10
    lea     r8d, [abc + edx]    ;increase digit count in abc string
    inc     byte [r8d]
    test    eax, eax            ;number reduced to 0?
    jnz     convert             ;if not, continue
    ret

cmpstr:
    xor     r9d, r9d
    mov     r8, [abc]           ;compare first 8 bytes
    cmp     r8, [pds]
    cmovne  r9d, r11d
    mov     r8, [abc + 2]       ;compare last 8 bytes
    cmp     r8, [pds + 2]
    cmovne  r9d, r11d
    ret

section .note.GNU-stack     ;just for gcc
