section .data
    msg db "%lld", 10, 0        ;return string for printf (just the result)
    primes times 1000000 db 1   ;array for the prime sieve

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
    cmp     eax, 1000000            ;check if square is > limit    
    jg      reset                   ;if it is, jump to reset
    cmp     byte [primes + ebx], 0  ;check if ebx is not prime
    je      sieve_outer             ;if not prime, try next number

sieve_inner:
    mov     byte [primes + eax], 0  ;set multiple to not prime
    add     eax, ebx                ;next multiple
    cmp     eax, 1000000            ;check if square is <= limit
    jl      sieve_inner             ;if it is, continue with inner loop
    jmp     sieve_outer             ;if not, continue with outer loop

reset:
    mov     ebx, 10                 ;10 in ebx (primes < 10 not considered)
    mov     edi, 10                 ;10 in edi for divisions
    xor     ecx, ecx                ;sum
    xor     r8d, r8d                ;counter

nextprime:
    inc     ebx                     ;next number
    cmp     byte [primes + ebx], 1  ;is it prime?
    jne     nextprime               ;if not, find next prime
    mov     eax, ebx                ;prime in eax for next step

trunc_right:
    xor     edx, edx                ;reset remainder
    div     edi                     ;divide by 10
    cmp     byte [primes + eax], 1  ;is truncated number prime?
    jne     nextprime               ;if not, try next prime
    cmp     eax, 10                 ;number still >= 10?
    jge     trunc_right             ;if yes, repeat
    mov     esi, 1000000            ;1000000 in esi for division
 
setdivisor:
    mov     eax, esi                ;esi in eax for division
    xor     edx, edx                ;reset remainder
    div     edi                     ;divide by 10
    mov     esi, eax                ;result back in esi
    cmp     esi, ebx                ;esi < number?
    jg      setdivisor              ;if not, repeat
    mov     eax, ebx                ;prime in eax

trunc_left:
    xor     edx, edx                ;reset remainder
    div     esi                     ;divide by esi
    mov     eax, edx                ;remainder in eax
    cmp     byte [primes + eax], 1  ;is remainder prime?
    jne     nextprime               ;if not try next prime
    push    rax                     ;result on the stack
    mov     eax, esi                ;esi in eax
    xor     edx, edx                ;reset remainder
    div     edi                     ;divide by 10
    mov     esi, eax                ;result back in esi
    pop     rax                     ;number back from the stack
    cmp     eax, 10                 ;number still >= 10?
    jge     trunc_left              ;if yes, repeat
    add     ecx, ebx                ;else add prime to sum
    inc     r8d                     ;increase counter
    cmp     r8d, 11                 ;are all 11 candidates found?
    jl      nextprime               ;if not, try next prime

print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, ecx
    call    printf
    pop     rbp

exit:                   ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack ;just for gcc
