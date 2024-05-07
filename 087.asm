section .data
    msg db "%d", 10, 0          ;return string for printf (just the result)
    primes times 7071 db 1      ;array for the prime sieve (limit sqrt(5e7))

section .bss
    nums resb 50000000          ;array for found numbers

section .text
    extern printf
    global main

main:
    mov     byte [primes], 0        ;set primes[0] = 0
    mov     byte [primes + 1], 0    ;set primes[1] = 0
    mov     ebx, 1                  ;array index for outer loop
    xor     r9d, r9d                ;count

sieve_outer:
    inc     ebx                     ;increase index
    cmp     byte [primes + ebx], 0  ;check if ebx is no prime
    je      sieve_outer             ;if no prime, try next number
    mov     eax, ebx                ;copy to eax for squaring
    mul     ebx                     ;square
    cmp     eax, 7071               ;check if square is > limit    
    jg      reset                   ;if it is, jump to reset

sieve_inner:
    mov     byte [primes + eax], 0  ;set multiple to not prime
    add     eax, ebx                ;next multiple
    cmp     eax, 7071               ;check if multiple is <= limit
    jl      sieve_inner             ;if it is, continue with inner loop
    jmp     sieve_outer             ;if not, continue with outer loop

reset:                              ;reset registers for next operation
    mov     ebx, 1                  ;squares

square:
    inc     ebx                     ;next base for square
    cmp     byte [primes + ebx], 1  ;is it prime?
    jne     square                  ;if not, try next number
    mov     eax, ebx                ;copy to eax
    mul     ebx                     ;square
    cmp     eax, 50000000           ;limit reached?
    jge     print                   ;if yes, jump to result
    mov     esi, eax                ;result in esi
    mov     ecx, 1                  ;reset ecx

cube:
    inc     ecx                     ;next base for cube
    cmp     byte [primes + ecx], 1  ;is it prime?
    jne     cube                    ;if not, try next number
    mov     eax, ecx                ;copy to eax
    mul     ecx                     ;^2
    mul     ecx                     ;^3
    add     eax, esi                ;add square
    cmp     eax, 50000000           ;limit reached?
    jge     square                  ;if yes, try next square
    mov     r8d, eax                ;result in r8d
    mov     edi, 1                  ;reset edi

fourthpow:
    inc     edi                     ;next base for 4th power
    cmp     byte [primes + edi], 1  ;is it prime?
    jne     fourthpow               ;if not, try next
    mov     eax, edi                ;copy to eax
    mul     edi                     ;^2
    mul     eax                     ;^4
    add     eax, r8d                ;add square + cube
    cmp     eax, 50000000           ;limit reached?
    jge     cube                    ;if yes, try next cube
    cmp     byte [nums + eax], 1    ;number already found?
    je      fourthpow               ;if yes, skip next step
    inc     r9d                     ;else increase count
    mov     byte [nums + eax], 1    ;and set nums[eax] to 1
    jmp     fourthpow               ;and repeat

print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, r9d
    call    printf
    pop     rbp

exit:                   ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
