section .data
    msg db "%d", 10, 0          ;return string for printf (just the result)
    primes times 884 db 255     ;sqrt(5e7) bits for the prime sieve

section .bss
    nums resb 6250000           ;5e7 bits for found numbers

section .text
    extern printf
    global main

main:
    mov     ebx, 1          ;array index for outer loop
    xor     r9d, r9d        ;count

sieve_outer:
    inc     ebx             ;increase index
    bt      [primes], ebx   ;check if ebx is no prime
    jnc     sieve_outer     ;if no prime, try next number
    mov     eax, ebx        ;copy to eax for squaring
    mul     ebx             ;square
    cmp     eax, 7072       ;check if square is > limit    
    jg      reset           ;if it is, jump to reset

sieve_inner:
    btr     [primes], eax   ;set multiple to not prime
    add     eax, ebx        ;next multiple
    cmp     eax, 7072       ;check if multiple is <= limit
    jl      sieve_inner     ;if it is, continue with inner loop
    jmp     sieve_outer     ;if not, continue with outer loop

reset:                      ;reset registers for next operation
    mov     ebx, 1          ;squares

square:
    inc     ebx             ;next base for square
    bt      [primes], ebx   ;is it prime?
    jnc     square          ;if not, try next number
    mov     eax, ebx        ;copy to eax
    mul     ebx             ;square
    cmp     eax, 50000000   ;limit reached?
    jge     print           ;if yes, jump to result
    mov     esi, eax        ;result in esi
    mov     ecx, 1          ;reset ecx

cube:
    inc     ecx             ;next base for cube
    bt      [primes], ecx   ;is it prime?
    jnc     cube            ;if not, try next number
    mov     eax, ecx        ;copy to eax
    mul     ecx             ;^2
    mul     ecx             ;^3
    add     eax, esi        ;add square
    cmp     eax, 50000000   ;limit reached?
    jge     square          ;if yes, try next square
    mov     r8d, eax        ;result in r8d
    mov     edi, 1          ;reset edi

fourthpow:
    inc     edi             ;next base for 4th power
    bt      [primes], edi   ;is it prime?
    jnc     fourthpow       ;if not, try next
    mov     eax, edi        ;copy to eax
    mul     edi             ;^2
    mul     eax             ;^4
    add     eax, r8d        ;add square + cube
    cmp     eax, 50000000   ;limit reached?
    jge     cube            ;if yes, try next cube
    bts     [nums], eax     ;number already found (and set if not)?
    jc      fourthpow       ;if yes, skip it
    inc     r9d             ;else increase count
    jmp     fourthpow       ;and repeat

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
