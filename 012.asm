section .data
    msg db "%d", 10, 0        ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    mov     ebx, 1      ;starting point
    mov     edi, 1      ;dito

nexttri:
    inc     edi         ;increase edi
    add     ebx, edi    ;add to ebx, result is next triangular number
    mov     esi, 2      ;base for number of divisors (1 and number itself)
    mov     ecx, 1      ;reset divisor for trial divisions
    call    divide      ;call divide
    cmp     esi, 500    ;check if number of divisors > 500
    jg      print       ;if it is, print result
    jmp     nexttri     ;else go to next triangular number

divide:
    inc     ecx         ;increase divisor
    mov     eax, ecx    ;put divisor in eax
    mul     ecx         ;square
    cmp     eax, ebx    ;compare square to number
    je      plus1       ;if equal, go to plus1
    jg      back        ;if greater go to back
    mov     eax, ebx    ;put current number in eax
    xor     edx, edx    ;prepare edx for the remainder
    div     ecx         ;divide by current divisor
    test    edx, edx    ;check if remainer = 0
    jnz     divide      ;if not, continue with next divisor
    add     esi, 2      ;if yes, add 2 to number of divisors
    jmp     divide      ;try next divisor

plus1:
    inc     esi         ;add 1 if divisor is square root of number

back:
    ret                 ;return

print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, ebx
    call    printf
    pop     rbp

exit:                   ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
