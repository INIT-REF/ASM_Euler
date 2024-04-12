section .data
    msg db "%d", 10, 0  ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    mov     ebx, 1      ;first number
    xor     r8d, r8d    ;sum
    
findpalindromes:
    mov     eax, ebx    ;number in eax for division
    xor     ecx, ecx    ;clear ecx for storing the reverse
    mov     edi, 10     ;10 in edi for division
    call    reverse     ;reverse base 10 number
    cmp     ebx, ecx    ;check if reverse = number
    jne     next        ;if not, try next
    mov     eax, ebx    ;else do the same for base 2
    xor     ecx, ecx
    mov     edi, 2
    call    reverse
    cmp     ebx, ecx
    jne     next
    add     r8d, ebx    ;add number to sum if both are palindromes

next:
    add     ebx, 2          ;next odd number
    cmp     ebx, 1000000    ;finished?
    jl      findpalindromes ;if not, continue

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
    xor     edx, edx    ;clear remainder
    div     edi         ;divide by base
    imul    ecx, edi    ;multiply rcx by base
    add     ecx, edx    ;add remainder
    test    eax, eax    ;number reduced to 0
    jnz     reverse     ;if not, repeat
    ret

section .note.GNU-stack     ;just for gcc
