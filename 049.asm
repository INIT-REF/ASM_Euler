section .data
    msg db "%lld", 10, 0    ;return string for printf (just the result)
    primes times 10000 db 1 ;array for the prime sieve
    digits times 30 db 0    ;digits for permutation check

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

reset:
    mov     byte [primes + 1487], 0 ;primes[1487] = 0 to exclude the example
    mov     rax, 1000               ;init rax
    xor     rbx, rbx                ;and clear registers
    xor     rcx, rcx
    xor     rdi, rdi

nextstarter:
    inc     eax                     ;next starting number
    cmp     byte [primes + eax], 1  ;is number prime?
    jne     nextstarter             ;if not, try next
    mov     ebx, eax                ;else set ebx
    add     ebx, 3330               ;and add 3330
    cmp     byte [primes + ebx], 1  ;is it prime?
    jne     nextstarter             ;if not, try next
    mov     ecx, ebx                ;else put it in ecx
    add     ecx, 3330               ;and add 3330
    cmp     byte [primes + ecx], 1  ;is third number prime?
    jne     nextstarter             ;if not, try next starter
    mov     r8d, eax                ;copy of eax to save it
    xor     esi, esi                ;reset esi

getdigits:
    mov     byte [digits + esi], 0  ;reset digits[edi]
    inc     esi                     ;next index
    cmp     esi, 30                 ;end of array?
    jl      getdigits               ;if not, continue
    mov     esi, 10                 ;10 in esi for division in divide
    mov     r9d, digits             ;put digits' adress in r9d
    call    divide                  ;call divide function
    mov     eax, ebx                ;put ebx in eax for divide
    lea     r9d, [digits + 10]      ;load address of digits[10] in r9d
    call    divide                  ;call divide again
    mov     eax, ecx                ;repeat for edi
    lea     r9d, [digits + 20]
    call    divide
    mov     eax, r8d                ;restore eax
    xor     esi, esi                ;reset esi and ecx for permcheck
    xor     edi, edi

permcheck:
    mov     dil, [digits + esi]             ;get digits[esi]
    cmp     byte [digits + esi + 10], dil   ;must be same as digits[esi + 10]
    jne     nextstarter                     ;if not, try next starter
    cmp     byte [digits + esi + 20], dil   ;same for digits[esi + 20]
    jne     nextstarter
    inc     esi                             ;next index
    cmp     esi, 10                         ;finished?
    jl      permcheck                       ;if not, repeat

result:
    xor     rsi, rsi                ;build the 12-digit concatenated number
    mov     rsi, rax
    imul    rsi, 100000000
    imul    rbx, 10000
    add     rsi, rbx
    add     rsi, rcx
 
print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    call    printf
    pop     rbp

exit:                   ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

divide:
    xor     edx, edx
    div     esi
    mov     byte [r9d + edx], 1
    test    eax, eax
    jnz     divide
    ret

section .note.GNU-stack     ;just for gcc
