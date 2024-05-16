section .data
    msg db "%d", 10, 0      ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    mov     ebx, 1          ;init n
    xor     r10d, r10d      ;counter

nextn:
    inc     ebx             ;next n
    cmp     ebx, 10000      ;limit reached?
    jg      print           ;if yes, print result
    xor     ecx, ecx        ;for floor(sqrt(n))
    xor     edi, edi        ;preiod length

findrootfloor:
    inc     ecx             ;increase ecx and square it
    mov     eax, ecx
    mul     ecx
    cmp     eax, ebx        ;compare square to n
    je      nextn           ;if equal, n is a perfect square, skip that
    jl      findrootfloor   ;if lower, increase ecx
    dec     ecx             ;if it was greater, decrease ecx again, finished
    mov     esi, ecx        ;a0
    mov     r8d, 0          ;m0
    mov     r9d, 1          ;d0

getperiodlength:
    inc     edi
    imul    esi, r9d        ;a * d
    sub     esi, r8d        ;a * d - m
    mov     r8d, esi        ;new m
    mov     eax, ebx        ;n
    imul    esi, esi        ;(new m)^2
    sub     eax, esi        ;n - (new m)^2
    xor     edx, edx        ;reset remainder
    div     r9d             ;(n - (new m)^2) / d
    mov     r9d, eax        ;new d
    mov     eax, ecx        ;a0
    add     eax, r8d        ;a0 + new m
    xor     edx, edx        ;reset remainder
    div     r9d             ;(a0 + new m) / new d
    mov     esi, eax        ;new a
    mov     eax, ecx        ;a0
    shl     eax, 1          ;2 * a0
    cmp     esi, eax        ;new a = 2 * a0?
    jne     getperiodlength ;if not, repeat
    test    edi, 1          ;is period length odd?
    jz      nextn           ;if not, try next number
    inc     r10d            ;else increase counter
    jmp     nextn           ;and try next number

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
