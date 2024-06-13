section .data
    msg db "%lld", 10, 0        ;return string for printf (just the result)
    primes times 250000 db 255  ;array for the prime sieve

section .text
    extern printf
    global main

main:
    mov     ebx, 1          ;array index for outer loop
    xor     ecx, ecx        ;sum

sieve_outer:
    inc     ebx             ;increase index
    mov     eax, ebx        ;copy to eax for squaring
    mul     ebx             ;square
    cmp     eax, 2000000    ;check if square is > limit    
    jg      sum             ;if it is, sum rest of primes
    bt      [primes], ebx   ;check if ebx is no prime
    jnc     sieve_outer     ;if no prime, try next number
    add     rcx, rbx        ;if yes, add prime to sum

sieve_inner:
    btr     [primes], eax   ;set multiple to not prime
    add     eax, ebx        ;next multiple
    cmp     eax, 2000000    ;check if multiple is <= limit
    jle     sieve_inner     ;if it is, continue with inner loop
    jmp     sieve_outer     ;if not, continue with outer loop

sum:
    xor     eax, eax        ;zero eax
    inc     ebx             ;increase array index
    bt      [primes], ebx   ;check if primes[ebx] is 1
    cmovc   eax, ebx        ;if yes, put prime in eax
    add     rcx, rax        ;and add prime (or 0) to sum
    cmp     ebx, 2000000    ;end of array?
    jl      sum             ;if not, repeat
    
print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     rsi, rcx
    call    printf
    pop     rbp

exit:                   ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack ;just for gcc
