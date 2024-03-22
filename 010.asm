section .data
    msg db "%lld", 10, 0        ;return string for printf (just the result)
    primes times 2000000 db 1   ;array for the prime sieve

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
    cmp     eax, 2000000            ;check if square is > limit    
    jg      reset                   ;if it is, jump to reset
    cmp     byte [primes + ebx], 0  ;check if primes[edi] = 1
    je      sieve_outer             ;if yes, continue
    mov     eax, ebx                ;array indexer for inner loop
    mul     ebx                     ;begin with square of outer index

sieve_inner:
    mov     byte [primes + eax], 0  ;set multiple to not prime
    add     eax, ebx                ;next multiple
    cmp     eax, 2000000            ;check if square is <= limit
    jl      sieve_inner             ;if it is, continue with inner loop
    jmp     sieve_outer             ;if not, continue with outer loop

reset:
    xor     rbx, rbx                ;reset ebx and eax for building the sum
    xor     rax, rax

sum:
    inc     ebx                     ;increase array index
    cmp     ebx, 2000000            ;check if index has arrived ad 2,000,000
    je      print                   ;if yes, print result
    cmp     byte [primes + ebx], 1  ;check if primes[ebx] is 1
    jne     sum                     ;if not, continue
    add     rax, rbx                ;if yes, add prime to sum
    jmp     sum                     ;back to sum
    
print:                              ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     rsi, rax
    call    printf
    pop     rbp

exit:                               ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
