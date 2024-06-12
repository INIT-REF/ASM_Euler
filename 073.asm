format ELF64 executable 9

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0

segment readable executable
    entry start

start:
    mov     ebx, 3              ;b = 3 (denominator of 1/3)
    mov     ecx, 2              ;d = 2 (denominator of 1/2)

get_next_frac:
    mov     edi, ecx            ;calculate median q = (c + d)
    add     ecx, ebx            ;while q <= 12000
    cmp     ecx, 12000
    jle     get_next_frac
    mov     ecx, edi
    xor     edi, edi

get_count:
    inc     edi
    mov     eax, 12000
    add     eax, ebx
    xor     edx, edx
    div     ecx                 ;k = (n + b) / d
    push    rcx                 ;current d on the stack
    mul     ecx
    sub     eax, ebx
    mov     ecx, eax            ;new d = k * d - b
    pop     rbx                 ;b = old d
    cmp     ecx, 2              ;d still > 2?
    jg      get_count           ;if yes, repeat
    
finished:
    mov     eax, edi
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
