section .data
    msg db "%d", 10, 0          ;return string for printf (just the result)
    primes times 115000 db 1    ;array for the prime sieve

section .text
    extern printf
    global main

main:
    mov     byte [primes], 0        ;set primes[0] = 0
    mov     byte [primes + 1], 0    ;set primes[1] = 0
    mov     ebx, 1                  ;array indexer for outer loop

sieve_outer:
    inc     ebx                     ;increase index
    mov     eax, ebx                ;copy to eyx for squaring
    mul     ebx                     ;square
    cmp     eax, 115000             ;check if square is > limit    
    jg      reset                   ;if it is, jump to reset
    cmp     byte [primes + ebx], 0  ;check if primes[edi] = 1
    je      sieve_outer             ;if yes, continue
    mov     eax, ebx                ;array indexer for inner loop
    mul     ebx                     ;begin with square of outer index

sieve_inner:
    mov     byte [primes + eax], 0  ;set multiple to not prime
    add     eax, ebx                ;next multiple
    cmp     eax, 115000             ;check if square is <= limit
    jl      sieve_inner             ;if it is, continue with inner loop
    jmp     sieve_outer             ;if not, continue with outer loop

reset:                              ;reset registers for next operation
    xor     ebx, ebx
    xor     ecx, ecx

find10001st:
    inc     ebx                     ;increase array index
    cmp     byte [primes + ebx], 1  ;check if primes[ebx] is 1
    jne     find10001st             ;if not, continue
    inc     ecx                     ;if yes, increase counter
    cmp     ecx, 10001              ;check if counter arrived at 10001
    jl      find10001st             ;if not, continue
    
print:                              ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, ebx
    call    printf
    pop     rbp

exit:                               ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
