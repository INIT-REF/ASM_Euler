format ELF64 executable 9

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0
    primes: times 125000 db 255 ;prime sieve (1e6 bits)
    repd: rb 10                 ;for counting repeated digits

segment readable executable
    entry start

start:
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
    cmp     eax, 1000000    ;check if multiple is <= limit
    jl      sieve_inner     ;if it is, continue with inner loop
    jmp     sieve_outer     ;if not, continue with outer loop

reset:
    mov     edi, 1000       ;init index for primes

nextprime:
    inc     edi             ;next number
    bt      [primes], edi   ;is it prime?
    jnc     nextprime       ;if not, try next
    mov     eax, edi        ;prime in eax for divisions later
    xor     esi, esi        ;reset index for clear_repd

clear_repd:
    mov     byte [repd + esi], 0    ;set repd[esi] to 0
    inc     esi                     ;increase esi
    cmp     esi, 10                 ;end of repd?
    jl      clear_repd              ;if not, repeat
    xor     edx, edx                ;reset remainder
    div     esi                     ;divide by 10 (drop last digit)

get_repd:
    xor     edx, edx                ;reset remainder
    div     esi                     ;divide by 10
    inc     byte [repd + edx]       ;increase digit count in repd[edx]
    test    eax, eax                ;number reduced to 0?
    jnz     get_repd                ;if not, repeat
    xor     esi, esi                ;reset esi

get_012_count:
    cmp     esi, 3                  ;0, 1 or 2 not repeated 3 times?
    je      nextprime               ;then try next prime
    mov     al, [repd + esi]        ;repd[esi] in al
    cmp     eax, 3                  ;is count = 3?
    je      template                ;if yes, make template
    inc     esi                     ;if not increase esi
    jmp     get_012_count           ;and repeat

template:
    mov     eax, 10000000           ;tmp variable
    mov     ecx, 10                 ;for divisions

getlength:
    xor     edx, edx                ;reduce eax to length of edi
    div     ecx
    cmp     eax, edi
    jg      getlength
    mov     ebx, eax                ;result in ebx
    xor     r8d, r8d                ;will become the template
    mov     eax, edi                ;number in eax

templateloop:
    xor     edx, edx                ;reset remainder
    div     ebx                     ;divide by ebx
    test    edx, edx                ;remainder = 0?
    jz      findfamily              ;if yes, start finding the family
    cmp     eax, esi                ;else compare current digit to repeated
    mov     eax, edx                ;put remainder in eax
    jne     skipped                 ;if digit != repeated jump to skipped
    add     r8d, ebx                ;else add ebx to template

skipped:
    push    rax                     ;reduce ebx and repeat
    mov     eax, ebx
    xor     edx, edx
    div     ecx
    mov     ebx, eax
    pop     rax
    jmp     templateloop

findfamily:
    mov     eax, edi        ;prime in eax
    mov     ecx, esi
    mov     ebx, 1          ;counter for family size
    
familyloop:
    cmp     ebx, 8          ;family count = 8?
    je      finished        ;if yes, we are finished
    inc     ecx
    cmp     ecx, 10         ;last possible replacement done?
    je      nextprime       ;if yes, try next prime
    add     eax, r8d        ;add template
    bt      [primes], eax   ;is new number prime?
    jnc     familyloop      ;if not, repeat
    inc     ebx             ;else increase counter
    jmp     familyloop      ;and try next substitution


finished:
    mov     eax, edi        ;convert result to string, print and exit
    mov     ebx, 10
    mov     ecx, 9    

convert_result:
    xor     edx, edx
    div     ebx
    add     edx, '0'
    mov     [result + ecx], dl
    dec     ecx
    test    eax, eax
    jnz     convert_result

print:
    mov     eax, 4
    mov     edi, 1
    mov     esi, result
    mov     edx, 12
    syscall

exit:
    mov     rax, 1
    xor     rdi, rdi
    syscall
