section .data
    msg db "%d", 10, 0          ;return string for printf (just the result)
    primes times 1000000 db 0   ;array for the prime sieve

section .text
    extern printf
    global main

main:
    mov     byte [primes], 1        ;set primes[0] = 1
    mov     byte [primes + 1], 1    ;set primes[1] = 1
    mov     ebx, 1                  ;array index for outer loop

sieve_outer:
    inc     ebx                     ;increase index
    mov     eax, ebx                ;copy to eax for squaring
    mul     ebx                     ;square
    cmp     eax, 1000000            ;check if square is >= limit    
    jge     reset                   ;if it is, jump to reset
    mov     eax, ebx                ;else put ebx in eax
    cmp     byte [primes + ebx], 0  ;check if primes[ebx] is 0
    je      sieve_inner             ;if not, try next number
    jmp     sieve_outer

sieve_inner:
    add     byte [primes + eax], 1  ;increase factor count
    add     eax, ebx                ;next multiple
    cmp     eax, 1000000            ;check if multiple is <= limit
    jl      sieve_inner             ;if it is, continue with inner loop
    jmp     sieve_outer             ;if not, continue with outer loop

reset:
    xor     edi, edi                ;current number

resetcount:
    xor     esi, esi                ;number counter

findfirst:
    inc     edi                     ;next number
    cmp     byte [primes + edi], 4  ;has 4 distinct prime factors?
    jne     findfirst               ;if not, try next number
    inc     esi                     ;if yes, increase counter

findnext:
    inc     edi                     ;next number
    cmp     byte [primes + edi], 4  ;has 4 distinct prime factors?
    jne     resetcount              ;if not, reset counter
    inc     esi                     ;else increase counter
    cmp     esi, 4                  ;4 consecutive numbers found?
    jl      findnext                ;if not, continue

finished:
    mov     esi, edi    ;copy last number to esi
    sub     esi, 3      ;subtract 3 to get first number
 
print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    call    printf
    pop     rbp

exit:                   ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
