section .data
    msg db "%d", 10, 0  ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    mov     edi, 10         ;for divisions
    mov     ebx, 7654321    ;upper limit

next:
    sub     ebx, 2      ;next lower odd number
    mov     esi, 1      ;divisor for prime test

primetest:
    add     esi, 2      ;next odd divisor
    mov     eax, esi    ;square divisor
    mul     esi
    cmp     eax, ebx    ;check if divisor^2 > number
    jg      isprime     ;if yes, we have a prime
    mov     eax, ebx    ;number in eax for division
    xor     edx, edx    ;reset remainder
    div     esi         ;divide by current divisor
    test    edx, edx    ;is remainder 0?
    jnz     primetest   ;if not, continue
    jmp     next        ;else check next number

isprime:
    mov     eax, ebx    ;number in eax
    xor     ecx, ecx    ;for bit test
    xor     r8d, r8d    ;dito

pd_test:
    bts     r8d, 0      ;set bit @0 in r8d
    shl     r8d, 1      ;shift r8d left
    xor     edx, edx    ;reset remainder
    div     edi
    bts     ecx, edx    ;set bit @remainder in ecx
    test    eax, eax    ;number reduced to 0?
    jnz     pd_test     ;if not repeat
    cmp     ecx, r8d    ;ecx = r8d --> 1-n pandigital
    jne     next        ;if not, try next prime

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, ebx
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
