section .data
    msg db "%d", 10, 0          ;return string for printf (just the result)
    abc times 10 db 0           ;digits in number
    pds db "123456789", 1       ;pandigital string
    primes times 7654321 db 1   ;array for prime sieve

section .text
    extern printf
    global main

main:
    mov     byte [primes], 0        ;set primes[0] = 0
    mov     byte [primes + 1], 0    ;set primes[1] = 0
    mov     ebx, 1                  ;array index for outer loop
    mov     edi, 10                 ;for divisions

sieve_outer:
    inc     ebx                     ;increase index
    mov     eax, ebx                ;copy to eax for squaring
    mul     ebx                     ;square
    cmp     eax, 7654321            ;check if square is > limit    
    jg      reset                   ;if it is, jump to reset
    cmp     byte [primes + ebx], 0  ;check if ebx is no prime
    je      sieve_outer             ;if no prime, try next number

sieve_inner:
    mov     byte [primes + eax], 0  ;set multiple to not prime
    add     eax, ebx                ;next multiple
    cmp     eax, 7654321            ;check if square is <= limit
    jl      sieve_inner             ;if it is, continue with inner loop
    jmp     sieve_outer             ;if not, continue with outer loop

reset:
    mov     eax, 7654321            ;upper limit in eax

next:
    dec     eax                     ;next lower number
    cmp     byte [primes + eax], 1  ;is number prime?
    jne     next                    ;if not, try next
    push    rax         ;put number on the stack
    call    digits      ;digits in abc and compare with pds
    pop     rax         ;get number back
    cmp     esi, ebx    ;is abc 1-n pandigital?
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
    mov     ebx, 1                  ;length of number
    
resetabc:
    mov     byte [abc + esi], 0     ;reset abc[esi] to 0
    inc     esi                     ;next index
    cmp     esi, 8                  ;end of abc?
    jl      resetabc                ;if not, continue

convert:
    inc     ebx                         ;increase length counter
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
