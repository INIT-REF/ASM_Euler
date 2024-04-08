section .data
    msg db "%d", 10, 0      ;return string for printf (just the result)
    primes times 2000 db 1  ;array for the prime sieve

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
    cmp     eax, 2000               ;check if square is > limit    
    jg      reset                   ;if it is, jump to reset
    cmp     byte [primes + ebx], 0  ;check if ebx is no prime
    je      sieve_outer             ;if no prime, try next number

sieve_inner:
    mov     byte [primes + eax], 0  ;set multiple to not prime
    add     eax, ebx                ;next multiple
    cmp     eax, 2000               ;check if square is <= limit
    jl      sieve_inner             ;if it is, continue with inner loop
    jmp     sieve_outer             ;if not, continue with outer loop

reset:                  ;reset registers for next operation
    mov     ecx, 1      ;b
    xor     edi, edi    ;max n
    xor     esi, esi    ;max a * b

incB:
    inc     ecx                     ;next b
    cmp     byte [primes + ecx], 1  ;is b prime?
    jne     incB                    ;if not, try next
    cmp     ecx, 1000               ;limit reached?
    jge     print                   ;if yes, print result
    mov     ebx, 1001               ;set a to -1001
    neg     ebx              

incA:
    add     ebx, 2      ;next a
    cmp     ebx, 1000   ;a > 1000
    jg      incB        ;if yes, try next b
    xor     eax, eax    ;reset n

countprimes:
    push    rax                     ;n on the stack
    push    rax                     ;twice
    mul     eax                     ;n^2
    add     eax, ecx                ;n^2 + b
    mov     r8d, eax                ;copy result
    pop     rax                     ;n back from the stack
    mul     ebx                     ;n * a
    add     eax, r8d                ;n^2 + (a * n) + b
    cmp     byte [primes + eax], 0  ;is result prime?
    pop     rax                     ;get n back
    je      updatemax               ;if not, updatemax
    inc     eax                     ;else increase n
    jmp     countprimes             ;and continue

updatemax:
    cmp     eax, edi    ;n > max n
    jl      incA        ;if not, back to next A
    mov     edi, eax    ;else update max
    mov     eax, ebx    ;a in eax
    mul     ecx         ;a * b
    mov     esi, eax    ;result in esi
    jmp     incA        ;and back to incA

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
