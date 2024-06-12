format ELF64 executable 9

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0
    sieve: rd 12001             ;array for (limit + 1) integers

segment readable executable
    entry start

start:
    mov     edi, 3              ;init bounding fractions 1/3 and 1/2
    mov     esi, 2
    xor     ebx, ebx            ;loop counter

sieve_outer:
    inc     ebx
    cmp     ebx, 12000
    jg      finished
    mov     eax, ebx            ;get ceil(ebx/2)
    xor     edx, edx
    div     esi
    test    edx, edx
    jz      no_ceil1
    inc     eax
    
no_ceil1:
    mov     ecx, eax
    mov     eax, ebx            ;get ceil(ebx/3)
    xor     edx, edx
    div     edi
    test    edx, edx
    jz      no_ceil2
    inc     eax

no_ceil2:
    sub     ecx, eax
    dec     ecx                     ;ecx = ceil(ebx/2) - ceil(ebx/3) - 1
    add     [sieve + 4 * ebx], ecx  ;add result to sieve[ebx]
    mov     ecx, ebx                ;init inner loop index ecx to 2 * ebx
    shl     ecx, 1
    cmp     ecx, 12000              ;ecx > limit?
    jg      sieve_outer             ;if yes, start over with outer loop

sieve_inner:
    mov     edx, [sieve + 4 * ebx]  ;subtract sieve[ebx] from sieve[ecx]
    sub     [sieve + 4 * ecx], edx
    add     ecx, ebx                ;increase index
    cmp     ecx, 12000              ;and repeat while < limit
    jle     sieve_inner
    jmp     sieve_outer
 
finished:
    xor     edi, edi
    xor     eax, eax

sum:                                ;sum of all elements in sieve = result
    inc     edi
    add     eax, [sieve + 4 * edi]
    cmp     edi, 12000
    jl      sum
    mov     ebx, 10
    mov     ecx, 9    

convert_result:                     ;convert to string, print and exit
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
