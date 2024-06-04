format ELF64 executable 9

segment readable
    f: db "0081_matrix.txt", 0

segment readable writable
    result: times 10 db 0           ;empty string for printing the result later
                     db 10, 0
    buf: rb 32000
    mat: rd 6400

segment readable executable
    entry start

start:
    mov     eax, 5      ;file open
    mov     edi, f      ;file name
    mov     esi, 0      ;read only
    syscall
    mov     edi, eax    ;file descriptor
    mov     eax, 3      ;read
    mov     esi, buf    ;into buffer
    mov     edx, 32000  ;32000 bytes
    syscall    
    mov     edi, eax    ;file descriptor
    mov     eax, 6      ;close
    syscall

    xor     edi, edi    ;reset registers for building the matrix
    xor     esi, esi
    mov     ebx, 10
    xor     ecx, ecx

next_n:
    xor     eax, eax                ;reset eax, will hold the converted number
    
convert_n:
    mov     cl, [buf + esi]
    cmp     ecx, '0'                ;is buf[esi] not a digit (i.e. ',' or '\n')?
    jl      n_done                  ;if yes, we are at the end of the number
    mul     ebx                     ;else convert string to number
    sub     ecx, '0'
    add     eax, ecx
    inc     esi
    jmp     convert_n

n_done:
    mov     [mat + 4 * edi], eax    ;put current number in mat[edi]
    inc     esi                     ;increase edi and esi and continue
    inc     edi
    cmp     edi, 6400
    jl      next_n
    mov     edi, 6399               ;reset edi to last item in mat
    mov     esi, edi                ;dito for esi

last_row_col:
    mov     eax, [mat + 4 * edi]
    mov     ebx, [mat + 4 * esi]
    dec     edi
    sub     esi, 80
    add     [mat + 4 * edi], eax    ;add mat[edi] to mat[edi - 1]
    add     [mat + 4 * esi], ebx    ;add mat[esi] to mat[esi - 80]
    cmp     esi, 159                ;finished?
    jge     last_row_col            ;if not, repeat
    mov     edi, 6398               ;reset esi and edi again
    mov     esi, 6319
    mov     ecx, 80                 ;for /mod 80

pathsum:
    mov     eax, [mat + 4 * edi]    ;add min of right and below to mat[esi]
    mov     ebx, [mat + 4 * esi]
    dec     edi
    dec     esi
    cmp     eax, ebx
    cmovg   eax, ebx
    add     [mat + 4 * esi], eax
    test    esi, esi
    jz      finished
    mov     eax, esi
    xor     edx, edx
    div     ecx
    test    edx, edx
    jnz     pathsum
    dec     edi
    dec     esi
    jmp     pathsum
    
finished:
    mov     eax, [mat]
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
    mov     eax, 1
    xor     edi, edi
    syscall
