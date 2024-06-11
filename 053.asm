format ELF64 executable 9

segment readable writable
    result: times 20 db 0       ;empty string for printing the result later
                     db 10, 0
    tri: times 5151 dd 1        ;for n = 101 rows of pascal's triangle
                                ;n * (n + 1) / 2 elements

segment readable executable
    entry start

start:
    mov     edi, 1                  ;row in tri
    mov     edx, 1000000            ;limit
    xor     r8d, r8d                ;counter

next_row:
    inc     edi                     ;next row
    cmp     edi, 100                ;finished?
    jg      finished
    mov     esi, edi
    mov     eax, edi
    inc     eax
    imul    esi, eax
    shr     esi, 1                  ;first element = row * (row + 1) / 2
    mov     ecx, edi                ;loop counter
    dec     ecx
    
next_col:
    inc     esi                     ;next element
    dec     ecx                     ;decrease loop counter
    mov     eax, esi
    sub     eax, edi
    mov     ebx, [tri + 4 * eax]
    dec     eax
    add     ebx, [tri + 4 * eax]
    cmp     ebx, edx                ;sum > 1e6?
    jle     continue                ;if not, just place the sum 
    mov     ebx, edx                ;else replace sum with 1e6
    inc     r8d                     ;and increase counter

continue:      
    mov     [tri + 4 * esi], ebx    ;put sum of elements above in tri[esi]
    test    ecx, ecx
    jnz     next_col
    jmp     next_row
    
finished:
    mov     eax, r8d
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
