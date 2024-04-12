section .data
    msg db "%d", 10, 0  ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    mov     ebx, 1      ;first number
    xor     r8d, r8d    ;sum
    
base10:
    mov     eax, ebx    ;number in eax for division
    xor     ecx, ecx    ;clear ecx for storing the reverse
    mov     edi, 10     ;10 in edi for division
    call    reverse     ;reverse base 10 number
    cmp     ebx, ecx    ;check if reverse = number
    jne     next        ;if not, try next
    mov     eax, ebx    ;else put number in eax again
    xor     rcx, rcx    ;clear rcx for soring the base 2 number
    mov     edi, 2      ;put 2 in edi for division

base2:
    xor     rdx, rdx    ;clear remainder
    div     edi         ;divide by 2
    imul    rcx, 10     ;multiply rcx by 10 
    add     rcx, rdx    ;add remainder
    test    eax, eax    ;number reduced to 0?
    jnz     base2       ;if not, continue
    mov     rax, rcx    ;put base 2 result in rax for division
    push    rax         ;put it on the stack for later
    xor     rcx, rcx    ;clear rcx for sotring the reverse
    mov     edi, 10     ;put 10 in edi for division
    call    reverse     ;reverse base 2 number
    pop     rax         ;get original from the stack
    cmp     rax, rcx    ;compare base 2 with reverse
    jne     next        ;if not equal, try next number
    add     r8d, ebx    ;else add number to sum

next:
    add     ebx, 2          ;next odd number
    cmp     ebx, 1000000    ;finished?
    jl      base10          ;if not, continue

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

reverse:
    xor     rdx, rdx    ;clear remainder
    div     rdi         ;divide by 10
    imul    rcx, 10     ;multiply rcx by 10
    add     rcx, rdx    ;add remainder
    test    rax, rax    ;number reduced to 0
    jnz     reverse     ;if not, repeat
    ret

section .note.GNU-stack     ;just for gcc
