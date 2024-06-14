format ELF64 executable 9

segment readable writable
    result: times 20 db 0       ;empty string for printing the result later
                     db 10, 0
    p: rd 100000

segment readable executable
    entry start

start:
    mov     dword [p], 1        ;p[0] = 1
    xor     edi, edi            ;init n

next_n:
    inc     edi                 ;n++
    xor     esi, esi            ;init m
    mov     ebx, 1              ;init gpn(n) (generalized pentagonal number)

p_loop:
    mov     eax, [p + 4 * edi]  ;p[n]
    mov     ecx, edi
    sub     ecx, ebx            ;n - gpn(m)
    mov     ebx, [p + 4 * ecx]  ;p[n - gpn(m)]
    test    esi, 2              ;m mod 4 > 1?
    jz      continue            ;if not, jump to continue
    neg     ebx                 ;else negate ebx

continue:
    add     eax, ebx            ;p[n] +/- p[n - gpn(m)]
    mov     ebx, 1000000
    cdq
    idiv    ebx
    mov     [p + 4 * edi], edx  ;result mod 1e6 in p[n]
    inc     esi                 ;m++
    mov     eax, esi            ;get new gpn(m):
    shr     eax, 1
    inc     eax                 ;k = (m / 2) + 1
    mov     ebx, eax
    imul    ebx, ebx
    imul    ebx, 3              ;3 * k * k
    test    esi, 1              ;m even?
    jnz     odd                 ;if not, jump to odd
    neg     eax                 ;if yes, negate eax

odd:
    add     ebx, eax
    shr     ebx, 1              ;gpn(m) = ((3 * k * k) +/- k) / 2
    cmp     ebx, edi
    jle     p_loop
    mov     eax, [p + 4 * edi]  ;p[n] = 0 (i. e. p[n] was divisible by 1e6)?
    test    eax, eax
    jnz     next_n              ;if not, continue with next n

finished:
    mov     eax, edi
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
