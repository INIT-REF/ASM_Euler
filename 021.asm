section .data
    msg db "%d", 10, 0              ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    mov     ecx, 1      ;starting number
    xor     r9d, r9d    ;sum

findamicables:
    inc     ecx             ;next number
    cmp     ecx, 10000      ;check if we are under 10000
    je      print           ;if not, print result
    call    divsum          ;calculate sum of divisors
    cmp     ecx, r8d        ;check if sum = numer (i.e. a perfect number)
    je      findamicables   ;if yes, skip that
    push    rcx             ;put current number on the stack
    mov     ecx, r8d        ;put divsum in ebx
    call    divsum          ;calculate divsum of that
    pop     rcx             ;get number back from the stack
    cmp     ecx, r8d        ;check if n = divsum of divsum n (i.e. amicables)
    jne     findamicables   ;if not, try next number
    add     r9d, ecx        ;else add number to sum
    jmp     findamicables   ;continue with next number

divsum:
    mov     ebx, 1      ;reset divisor
    xor     r8d, r8d    ;reset sum of divisors

divide:
    inc     ebx         ;increase divisor (start with 2)
    mov     eax, ebx    ;put divisor in eax
    mul     ebx         ;square
    cmp     eax, ecx    ;check if suqare is > number
    jg      finished    ;if yes, we are finished
    mov     eax, ecx    ;else put number in eax
    xor     edx, edx    ;reset remainder
    div     ebx         ;divide by current divisor
    test    edx, edx    ;check if remainder = 0
    jnz     divide      ;if not, try next divisor
    cmp     eax, ebx    ;else check if result is equal to divisor
    je      add1        ;if yes, just add the divisor

add2:
    add     r8d, ebx    ;else add divisor and number / divisor
    add     r8d, eax
    jmp     divide

add1:
    add     r8d, ebx
    jmp     divide

finished:
    inc     r8d         ;add 1, as this is always a divisor
    ret

print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, r9d
    call    printf
    pop     rbp

exit:                   ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack ;just for gcc
