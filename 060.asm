format ELF64 executable 9

segment readable writable
    result: times 20 db 0       ;empty string for printing the result later
                     db 10, 0
    ps: times 12500000 db 255                       ;prime sieve, 1e8 bits
    pc: db 10, 20, 21, 30, 31, 32, 40, 41, 42, 43   ;combinations
    pf: rd 5                                        ;prime family

segment readable executable
    entry start

start:
    mov     ebx, 1          ;array index for outer sieve loop

sieve_outer:
    inc     ebx             ;increase index
    mov     eax, ebx        ;in eax for squaring
    mul     ebx             ;square
    cmp     eax, 100000000  ;check if square is > limit    
    jg      reset           ;if it is, sieve is done
    bt      [ps], ebx       ;check if ebx is no prime
    jnc     sieve_outer     ;if no prime, try next number

sieve_inner:
    btr     [ps], eax       ;set multiple to not prime
    add     eax, ebx        ;next multiple
    cmp     eax, 100000000  ;check if multiple is <= limit
    jle     sieve_inner     ;if it is, continue with inner loop
    jmp     sieve_outer     ;if not, continue with outer loop

reset:
    mov     edi, 1          ;init prime index

next_starter:
    add     edi, 2          ;next odd number
    bt      [ps], edi       ;is it prime?
    jnc     next_starter    ;if not, repeat
    mov     [pf], edi       ;if yes, put it in pf[0]
    xor     esi, esi        ;reset pf[] index

forward:
    inc     esi             ;next index in pf[]

forward_loop:
    add     edi, 2              ;find next prime
    cmp     edi, 10000          ;is it > 10000?
    jg      backtrack           ;if yes, backtrack
    bt      [ps], edi
    jnc     forward_loop
    mov     [pf + 4 * esi], edi ;else put it in pf[esi]
    xor     ecx, ecx

check_primes:
    xor     eax, eax            ;check all combinations of primes in pf[]
    mov     ebx, 10
    xor     edx, edx
    mov     al, [pc + ecx]
    div     ebx
    mov     eax, [pf + 4 * eax]
    test    eax, eax
    jz      forward
    mov     ebx, [pf + 4 * edx]
    push    rax
    push    rbx
    call    concat
    bt      [ps], eax
    jnc     forward_loop
    pop     rax
    pop     rbx
    call    concat
    bt      [ps], eax
    jnc     forward_loop
    inc     ecx
    cmp     ecx, 9
    jle     check_primes
    jmp     sum

backtrack:
    mov     dword [pf + 4 * esi], 0 ;reset current prime and continue
    dec     esi
    mov     edi, [pf + 4 * esi]
    test    esi, esi
    jz      next_starter
    dec     esi
    jmp     forward

sum:
    mov     edi, 5
    xor     eax, eax

_loop:
    dec     edi
    add     eax, [pf + 4 * edi]
    test    edi, edi
    jnz     _loop

finished:                       ;convert result to string, print and exit
    mov     eax, eax
    mov     ebx, 10
    mov     ecx, 19

convert_result:
    xor     edx, edx
    div     ebx
    add     edx, '0'
    mov     [result + rcx], dl
    dec     ecx
    test    eax, eax
    jnz     convert_result

print:
    mov     eax, 4
    mov     edi, 1
    mov     esi, result
    mov     edx, 22
    syscall

exit:
    mov     eax, 1
    xor     edi, edi
    syscall

concat:
    mov     edx, 1          ;init multiplier
    
cat_loop:
    imul    edx, 10         ;multiplier *= 10
    cmp     edx, ebx        ;multiplier > ebx
    jl      cat_loop        ;if not, repeat
    imul    eax, edx        ;eax * multiplier
    add     eax, ebx        ;add ebx --> catenated result in eax
    ret 
