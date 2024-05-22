section .data
    msg db "%d", 10, 0      ;return string for printf (just the result)
    limit equ 100           ;limit
    sieve times limit db 1  ;prime sieve

section .bss
    sums resd limit         ;array of sums

section .text
    extern printf
    global main

main:
    mov     dword [sums], 1         ;set sums[0] to 1
    mov     ebx, 1                  ;array index for outer loop
    xor     ecx, ecx

sieve_outer:
    inc     ebx                     ;increase index
    mov     eax, ebx                ;copy to eax for squaring
    mul     ebx                     ;square
    cmp     eax, limit              ;check if square is > limit    
    jg      reset                   ;if it is, jump to reset
    cmp     byte [sieve + ebx], 0   ;check if ebx is no prime
    je      sieve_outer             ;if no prime, try next number

sieve_inner:
    mov     byte [sieve + eax], 0   ;set multiple to not prime
    add     eax, ebx                ;next multiple
    cmp     eax, limit              ;check if multiple is <= limit
    jl      sieve_inner             ;if it is, continue with inner loop
    jmp     sieve_outer             ;if not, continue with outer loop

reset:
    mov     eax, 1                  ;reset eax

sum_outer:
    inc     eax                     ;next number
    cmp     eax, limit              ;limit reached?
    je      finished                ;if yes, get result
    cmp     byte [sieve + eax], 1   ;is it prime?
    jne     sum_outer               ;if not, increase it
    mov     ebx, eax                ;prime in ebx

sum_inner:
    mov     edx, ebx                ;copy ebx to edx
    sub     edx, eax                ;subtract eax
    mov     edi, [sums + 4 * edx]   ;move result in edi
    add     [sums + 4 * ebx], edi   ;add to sums[ebx]
    inc     ebx                     ;inc inner loop index
    cmp     ebx, limit              ;end of sums array?
    jle     sum_inner               ;if lower, continue inner loop
    jmp     sum_outer               ;else start over with outer loop

finished:
    xor     eax, eax

result:
    inc     eax                             ;next index
    cmp     dword [sums + 4 * eax], 5000    ;sums[eax] > 5000?
    jle     result                          ;if not, repeat

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, eax
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
