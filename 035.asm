section .data
    msg db "%d", 10, 0          ;return string for printf (just the result)
    primes times 125000 db 255  ;array for the prime sieve

section .text
    extern printf
    global main

main:
    mov     ebx, 1          ;array index for outer loop

sieve_outer:
    inc     ebx             ;increase index
    mov     eax, ebx        ;copy to eax for squaring
    mul     ebx             ;square
    cmp     eax, 1000000    ;check if square is > limit    
    jg      reset           ;if it is, jump to reset
    bt      [primes], ebx   ;check if ebx is no prime
    jnc     sieve_outer     ;if no prime, try next number

sieve_inner:
    btr     [primes], eax   ;set multiple to not prime
    add     eax, ebx        ;next multiple
    cmp     eax, 1000000    ;check if square is <= limit
    jl      sieve_inner     ;if it is, continue with inner loop
    jmp     sieve_outer     ;if not, continue with outer loop

reset:                      ;set up registers for next operation
    mov     edi, 1          ;index for prime
    mov     esi, 10         ;for divisions
    xor     ecx, ecx        ;counter

nextprime:
    inc     edi             ;next number
    cmp     edi, 1000000    ;finished?
    jge     print           ;if yes, print result
    bt      [primes], edi   ;is edi prime?
    jnc     nextprime       ;if not, try next number
    cmp     edi, 11         ;prime <= 11
    jle     circular        ;if yes, go to circular
    mov     ebx, 1          ;1 in ebx for the number of digits
    mov     eax, edi        ;prime in eax for division

getlength:
    xor     edx, edx        ;reset remainder
    div     esi             ;divide by 10
    test    eax, eax        ;reduced to 0?
    jz      prepare         ;if yes, jump to prepare 
    imul    ebx, esi        ;else multiply esi by 10
    jmp     getlength       ;and repeat

prepare:
    mov     eax, edi        ;prime in eax

rotate:
    xor     edx, edx        ;reset remainder
    div     esi             ;divide by 10
    imul    edx, ebx        ;multiply remainder by ebx
    add     eax, edx        ;add edx --> rotation
    bt      [primes], eax   ;is rotation prime?
    jnc     nextprime       ;if not, jump to nextprime
    cmp     eax, edi        ;rotation = original?
    jne     rotate          ;if not, continue rotating

circular:
    inc     ecx
    jmp     nextprime

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, ecx
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
