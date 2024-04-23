section .data
    msg db "%d", 10, 0      ;return string for printf (just the result)
    primes times 10000 db 1 ;array for the prime sieve

section .text
    extern printf
    global main

main:
    mov     byte [primes], 0        ;set primes[0] = 0
    mov     byte [primes + 1], 0    ;set primes[1] = 0
    mov     ebx, 1                  ;array index for outer loop

sieve_outer:
    inc     ebx                     ;increase index
    mov     eax, ebx                ;copy to eax for squaring
    mul     ebx                     ;square
    cmp     eax, 10000              ;check if square is > limit    
    jg      reset                   ;if it is, jump to reset
    cmp     byte [primes + ebx], 0  ;check if ebx is no prime
    je      sieve_outer             ;if no prime, try next number

sieve_inner:
    mov     byte [primes + eax], 0  ;set multiple to not prime
    add     eax, ebx                ;next multiple
    cmp     eax, 10000              ;check if multiple is <= limit
    jl      sieve_inner             ;if it is, continue with inner loop
    jmp     sieve_outer             ;if not, continue with outer loop

reset:                              ;reset registers for next steps
    mov     eax, 33
    xor     ebx, ebx

next:
    add     eax, 2                  ;next odd number
    cmp     byte [primes + eax], 0  ;is it a composite number?
    jne     next                    ;if not, try next
    mov     ebx, eax                ;copy of eax in ebx

lowerprime:
    sub     ebx, 2                  ;next lower odd number
    cmp     ebx, 1                  ;have we reached 1?
    je      print                   ;if yes, print result
    cmp     byte [primes + ebx], 1  ;is it prime?
    jne     lowerprime              ;if not, try next
    mov     ecx, eax                ;copy of composite
    sub     ecx, ebx                ;subtract prime
    shr     ecx, 1                  ;result / 2
    mov     edi, 1                  ;init edi for squaretest

squaretest:
    inc     edi         ;next candidate for square root
    mov     esi, edi    ;copy to esi
    imul    esi, edi    ;square
    cmp     esi, ecx    ;square = ecx?
    jg      lowerprime  ;if esi > ecx, ecx is no perfect square
    jl      squaretest  ;if esi < ecx, continue testing
    jmp     next        ;if ecx is perfect square, try next composite        

print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, eax
    call    printf
    pop     rbp

exit:                   ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack ;just for gcc
