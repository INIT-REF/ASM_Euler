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
    je      sieve_outer     ;if no prime, try next number

sieve_inner:
    btr     [primes], eax   ;set multiple to not prime
    add     eax, ebx        ;next multiple
    cmp     eax, 1000000    ;check if multiple is <= limit
    jl      sieve_inner     ;if it is, continue with inner loop
    jmp     sieve_outer     ;if not, continue with outer loop

reset:                      ;reset registers for next operation
    mov     eax, 1          ;start
    xor     r8d, r8d        ;max length
    xor     r9d, r9d        ;prime with max length
    
next:
    inc     eax             ;next starting number
    cmp     eax, 1000       ;limit for starting prime reached?
    je      print           ;if yes, print result
    bt      [primes], eax   ;is starting number prime?
    jnc     next            ;if not, try next
    mov     ebx, eax        ;copy of starting prime
    mov     ecx, eax        ;last prime of chain
    xor     edi, edi        ;chain length

sum:
    inc     ecx             ;next number
    bt      [primes], ecx   ;is it prime?
    jnc     sum             ;if not, try next number
    add     ebx, ecx        ;if yes, add prime to ebx
    inc     edi             ;and increase chain length
    cmp     ebx, 1000000    ;is ebx still < 1000000
    jl      sum             ;if yes, continue
    inc     ecx             ;ecx + 1

reduce:
    dec     ecx             ;decrease ecx
    bt      [primes], ecx   ;is ecx prime?
    jnc     reduce          ;if not, decrease ecx again
    sub     ebx, ecx        ;subtract last prime
    dec     edi             ;decrease chain length
    bt      [primes], ebx   ;is ebx prime?
    jnc     reduce          ;if not, reduce again
    cmp     edi, r8d        ;chain length > max?
    cmovg   r8d, edi        ;if yes, update max
    cmovg   r9d, ebx        ;and update prime for max
    jmp     next            ;and repeat with next starting prime
 
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
