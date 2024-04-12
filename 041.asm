section .data
    msg db "%d", 10, 0          ;return string for printf (just the result)
    abc times 8 db 0           ;digits in number
    pds db "1234567", 1       ;pandigital string

section .text
    extern printf
    global main

main:
    mov     edi, 10                 ;for divisions
    mov     r10d, 7654321           ;upper limit in r10d

next:
    sub     r10d, 2                 ;next lower odd number
    mov     esi, 1                  ;divisor for prime test

primetest:
    add     esi, 2      ;next odd divisor
    mov     eax, esi    ;square divisor
    mul     esi
    cmp     eax, r10d   ;check if divisor > number
    jg      isprime     ;if yes, we have a prime
    mov     eax, r10d   ;number in eax for division
    xor     edx, edx    ;reset remainder
    div     esi         ;divide by current divisor
    test    edx, edx    ;is remainder 0?
    jnz     primetest   ;if not, continue
    jmp     next        ;else check next number

isprime:
    mov     eax, r10d   ;number in eax
    push    rax         ;put number on the stack
    call    digits      ;digits in abc and compare with pds
    pop     rax         ;get number back
    cmp     esi, 8    ;is abc 1-n pandigital?
    jne     next        ;if not, try next prime

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, eax
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

digits:
    xor     esi, esi                ;reset esi, array index
    
resetabc:
    mov     byte [abc + esi], 0     ;reset abc[esi] to 0
    inc     esi                     ;next index
    cmp     esi, 8                  ;end of abc?
    jl      resetabc                ;if not, continue

convert:
    xor     edx, edx                    ;reset remainder
    div     edi                         ;divide by 10
    mov     [abc + edx - 1], dl         ;put digit in abc string
    add     byte [abc + edx - 1], '0'   ;add '0' to get the ASCII char
    test    eax, eax                    ;number reduced to 0?
    jnz     convert                     ;if not, continue
    xor     esi, esi                    ;reset esi

cmpstr:
    mov     r8b, [abc + esi]    ;char @ abc[eax]
    mov     r9b, [pds + esi]    ;char @ pds[eax]
    inc     esi                 ;next char
    cmp     r8b, r9b            ;both characters match?
    je      cmpstr              ;if yes, continue

back:
    ret

section .note.GNU-stack     ;just for gcc
