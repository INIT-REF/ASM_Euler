format ELF64 executable 9

segment readable
    f: db "0083_matrix.txt", 0  ;file name
    wm equ 80                   ;width of the matrix
    lm equ 6400                 ;length of the matrix array
    ld equ 40960000             ;length of the distance array (lm^2)
    inf equ 100:bd0000000          ;"infinity"

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0
    buf: rb 32000               ;buffer
    mat: rd lm                  ;matrix
    dis: rd ld                  ;distance matrix

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
    xor     esi, esi

inf_1:
    xor     edi, edi

inf_2:
    cmp     edi, esi
    jne     setinf
    inc     edi

setinf:
    mov     r8d, lm
    imul    r8d, esi
    add     r8d, edi
    mov     dword [dis + 4 * r8d], inf
    inc     edi
    cmp     edi, lm
    jl      inf_2
    inc     esi
    cmp     esi, lm
    jl      inf_1
    xor     esi, esi

dis_right_1:
    xor     edi, edi

dis_right_2:
    mov     r8d, wm
    imul    r8d, esi
    add     r8d, edi
    mov     r9d, lm
    imul    r9d, r8d
    mov     eax, [mat + 4 * r8d]
    inc     r8d
    add     r9d, r8d
    mov     ebx, [mat + 4 * r8d]
    add     eax, ebx
    mov     [dis + 4 * r9d], eax
    inc     edi
    mov     eax, wm
    dec     eax
    cmp     edi, eax
    jl      dis_right_2
    inc     esi
    cmp     esi, wm
    jl      dis_right_1
    mov     esi, lm
    mov     edi, 1

dis_left:
    mov     eax, [dis + 4 * edi]
    mov     [dis + 4 * esi], eax
    add     esi, lm
    inc     esi
    add     edi, lm
    inc     edi
    cmp     esi, ld
    jl      dis_left
    xor     esi, esi

dis_down_1:
    xor     edi, edi

dis_down_2:
    mov     r8d, wm
    imul    r8d, esi
    add     r8d, edi
    mov     r9d, lm
    imul    r9d, r8d
    mov     eax, [mat + 4 * r8d]
    add     r8d, wm
    add     r9d, r8d
    mov     ebx, [mat + 4 * r8d]
    add     eax, ebx
    mov     [dis + 4 * r9d], eax
    inc     edi
    cmp     edi, wm
    jl      dis_down_2
    inc     esi
    mov     eax, wm
    dec     eax
    cmp     esi, eax
    jl      dis_down_1
    mov     esi, lm
    imul    esi, wm
    mov     edi, wm

dis_up:
    mov     eax, [dis + 4 * edi]
    mov     [dis + 4 * esi], eax
    add     edi, lm
    inc     edi
    add     esi, lm
    inc     esi
    cmp     esi, ld
    jl      dis_up
    xor     edi, edi

fma_1:
    xor     esi, esi

fma_2:
    xor     edx, edx

fma_3:
    mov     r8d, lm
    imul    r8d, esi
    add     r8d, edx
    mov     eax, [dis + 4 * r8d]
    mov     r9d, lm
    imul    r9d, esi
    add     r9d, edi
    mov     ebx, [dis + 4 * r9d]
    mov     r10d, lm
    imul    r10d, edi
    add     r10d, edx
    mov     ecx, [dis + 4 * r10d]
    add     ebx, ecx
    cmp     eax, ebx
    jle     continue_fma
    mov     [dis + 4 * r8d], ebx

continue_fma:
    inc     edx
    cmp     edx, lm
    jl      fma_3
    inc     esi
    cmp     esi, lm
    jl      fma_2
    inc     edi
    cmp     edi, lm
    jl      fma_1

    mov     edi, lm
    dec     edi
    mov     eax, [dis + 4 * edi]
    add     eax, [mat]
    add     eax, [mat + 4 * edi]
    shr     eax, 1
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
