format ELF64 executable 9

segment readable writable
    result: times 20 db 0       ;empty string for printing the result later
                     db 10, 0
    p: rd 101

segment readable executable
    entry start

start:
    mov     dword [p], 1        ;set p[0] to 1
    xor     edi, edi            ;init n

sum_outer:
    inc     edi                 ;n++
    mov     esi, edi            ;m = n                

sum_inner:
    push    rsi
    sub     esi, edi                ;m - n
    mov     eax, [p + 4 * esi]      ;p[m - n]
    pop     rsi
    add     [p + 4 * esi], eax      ;p[m] += p[m - n]
    inc     esi                     ;m++
    cmp     esi, 100                ;end of p?
    jle     sum_inner               ;if not, continue inner loop
    cmp     edi, 99
    jl      sum_outer

finished:
    mov     eax, [p + 400]          ;result in p[100]
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
