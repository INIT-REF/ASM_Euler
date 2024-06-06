format ELF64 executable 9

segment readable
    f: db "0099_base_exp.txt", 0  ;file name

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0
    buf: rb 14000
    base dd 0
    exp dd 0
    res dd 0

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
    mov     edx, 14000  ;14000 bytes
    syscall    
    mov     edi, eax    ;file descriptor
    mov     eax, 6      ;close
    syscall

    xor     edi, edi            ;index in buf
    mov     esi, 1              ;line number
    xor     ebx, ebx            ;for char conversions
    mov     ecx, 10             ;for multiplication
    xor     r8d, r8d            ;max value
    xor     r9d, r9d            ;line number with max value

next_base:
    xor     eax, eax            ;reset eax for the base
    
convert_base:
    mov     bl, [buf + edi]
    cmp     ebx, '0'            ;is buf[esi] not a digit (i.e. ',' or '\n')?
    jl      base_done           ;if yes, we are at the end of the number
    mul     ecx                 ;else convert string to number
    sub     ebx, '0'
    add     eax, ebx
    inc     edi
    jmp     convert_base

base_done:
    mov     [base], eax         ;put result in base
    xor     eax, eax            ;reset eax for the exponent
    inc     edi                 ;next index in buf

convert_exp:                    ;do the same for the exponent
    mov     bl, [buf + edi]
    cmp     ebx, '0'
    jl      exp_done
    mul     ecx
    sub     ebx, '0'
    add     eax, ebx
    inc     edi
    jmp     convert_exp

exp_done:
    mov     [exp], eax
    xor     eax, eax
    inc     edi
    
    finit                       ;init FPU and get exp * log2(base)
    fild    dword [exp]
    fild    dword [base]
    fyl2x
    fisttp  dword [res]
    mov     eax, [res]          ;truncated result in eax
    cmp     eax, r8d            ;result > current max?
    cmovg   r8d, eax            ;if yes, update max and max line number
    cmovg   r9d, esi
    inc     esi                 ;next line
    cmp     esi, 1000           ;finished?
    jl      next_base           ;if not, repeat

finished:
    mov     eax, r9d
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
