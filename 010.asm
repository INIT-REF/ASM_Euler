section .data
    msg db "%lld", 10, 0        ;return string for printf (just the result)
    primes times 250000 db 255  ;array for the prime sieve

section .text
    extern printf
    global main

main:
    mov     ebx, 1          ;array index for outer loop

sieve_outer:
    inc     ebx             ;increase index
    mov     eax, ebx        ;copy to eax for squaring
    mul     ebx             ;square
    cmp     eax, 2000000    ;check if square is > limit    
    jg      reset           ;if it is, jump to reset
    bt      [primes], ebx   ;check if ebx is no prime
    jnc     sieve_outer     ;if no prime, try next number

sieve_inner:
    btr     [primes], eax   ;set multiple to not prime
    add     eax, ebx        ;next multiple
    cmp     eax, 2000000    ;check if multiple is <= limit
    jl      sieve_inner     ;if it is, continue with inner loop
    jmp     sieve_outer     ;if not, continue with outer loop

reset:
    mov     rbx, 1          ;reset rax and rbx for building the sum
    xor     rax, rax

sum:
    inc     ebx             ;increase array index
    cmp     ebx, 2000000    ;check if index has arrived ad 2,000,000
    je      print           ;if yes, print result
    bt      [primes], ebx   ;check if primes[ebx] is 1
    jnc     sum             ;if not, continue
    add     rax, rbx        ;if yes, add prime to sum
    jmp     sum             ;back to sum
    
print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     rsi, rax
    call    printf
    pop     rbp

exit:                   ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack ;just for gcc
