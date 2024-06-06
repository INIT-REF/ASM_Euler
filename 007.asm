section .data
    msg db "%d", 10, 0          ;return string for printf (just the result)
    primes times 14375 db 255   ;array for the prime sieve

section .text
    extern printf
    global main

main:
    mov     ebx, 1          ;array index for outer loop
    xor     ecx, ecx        ;counter

sieve_outer:
    inc     ebx             ;increase index
    mov     eax, ebx        ;copy to eax for squaring
    mul     ebx             ;square
    cmp     eax, 115000     ;check if square is > limit    
    jg      find10001st     ;if it is, sieve is done
    bt      [primes], ebx   ;check if ebx is no prime
    jnc     sieve_outer     ;if no prime, try next number
    inc     ecx             ;else increase counter

sieve_inner:
    btr     [primes], eax   ;set multiple to not prime
    add     eax, ebx        ;next multiple
    cmp     eax, 115000     ;check if multiple is <= limit
    jl      sieve_inner     ;if it is, continue with inner loop
    jmp     sieve_outer     ;if not, continue with outer loop

find10001st:
    inc     ebx             ;increase array index
    bt      [primes], ebx   ;is it prime?
    jnc     find10001st     ;if not, skip it
    inc     ecx             ;else increase ecx
    cmp     ecx, 10001      ;check if counter arrived at 10001
    jl      find10001st     ;if not, continue
    
print:                      ;printing routine, differs slightly from OS to OS
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
