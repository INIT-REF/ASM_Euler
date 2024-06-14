format ELF64 executable 9

segment readable writable
    result: times 20 db 0       ;empty string for printing the result later
                     db 10, 0
    ps: times 2500 db 255       ;prime sieve, 20000 bits

segment readable executable
    entry start

start:
    mov     ebx, 1          ;array index for outer sieve loop

sieve_outer:
    inc     ebx             ;increase index
    mov     eax, ebx        ;in eax for squaring
    mul     ebx             ;square
    cmp     eax, 20000      ;check if square is > limit    
    jg      sum             ;if it is, sum rest of primes
    bt      [ps], ebx       ;check if ebx is no prime
    jnc     sieve_outer     ;if no prime, try next number

sieve_inner:
    btr     [ps], eax       ;set multiple to not prime
    add     eax, ebx        ;next multiple
    cmp     eax, 20000      ;check if multiple is <= limit
    jle     sieve_inner     ;if it is, continue with inner loop
    jmp     sieve_outer     ;if not, continue with outer loop

sum:
    mov     edi, 1
    xor     eax, eax

_loop:
    inc     edi
    bt      [ps], edi
    adc     eax, 0
    cmp     edi, 100
    jl      _loop

finished:                       ;convert result to string, print and exit
    ;mov     eax, edi
    mov     ebx, 10
    mov     ecx, 19

convert_result:
    xor     edx, edx
    div     ebx
    add     edx, '0'
    mov     [result + rcx], dl
    dec     ecx
    test    eax, eax
    jnz     convert_result

print:
    mov     eax, 4
    mov     edi, 1
    mov     esi, result
    mov     edx, 22
    syscall

exit:
    mov     eax, 1
    xor     edi, edi
    syscall
