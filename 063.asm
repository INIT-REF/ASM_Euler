section .data
    msg db "%d", 10, 0  ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    xor     rdi, rdi    ;base
    mov     ecx, 1      ;counter (set to 1 because 9^21 > 2^64) 
    mov     r9, 10      ;for divisions

nextbase:
    inc     rdi         ;next base
    cmp     rdi, 10     ;base = 10
    je      print       ;if yes, print result
    inc     ecx         ;counter for n^1
    mov     esi, 1      ;power

nextpower:
    inc     esi         ;next higher power
    mov     r10d, esi   ;copy in r10d
    mov     rax, rdi    ;base in eax

power:
    mul     rdi         ;multiply by base
    dec     r10d        ;decrease power
    cmp     r10d, 1     ;finished?
    jg      power       ;if not, repeat
    xor     r8d, r8d    ;reset length

length:
    xor     rdx, rdx    ;reset remainder
    div     r9          ;divide by 10
    inc     r8d         ;increase length
    test    rax, rax    ;reduced to 0?
    jnz     length      ;if not, repeat
    cmp     r8d, esi    ;length = power?
    jne     nextbase    ;if not, try next base
    inc     ecx         ;else increase count
    jmp     nextpower   ;and try next power

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
