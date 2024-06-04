format ELF64 executable 9

segment readable
    limit equ 2000000

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0

segment readable executable
    entry start

start:
    mov     edi, 2000       ;init width
    mov     r8d, 1000       ;min difference (init from a 2000 x 1 grid)
    xor     r9d, r9d        ;area with min difference

nextwidth:
    dec     edi             ;decrease width
    mov     eax, edi
    inc     eax
    mul     edi
    mov     ebx, eax        ;copy in ebx
    mov     esi, 1          ;height

nextheight:
    inc     esi             ;increase height
    cmp     esi, edi
    jge     finished        ;if height = width, we are finished
    mov     eax, esi
    inc     eax
    mul     esi
    mul     ebx
    shr     eax, 2          ;w * (w + 1) * h * (h + 1) / 4
    push    rax
    sub     eax, limit      ;get difference from limit
    cmp     eax, 0
    jg      pos_diff
    neg     eax

pos_diff:
    cmp     eax, r8d        ;is difference less than current limit?
    jg      no_new_min      ;if not, jump to no_new_min
    mov     r8d, eax        ;else update r8d and r9d
    mov     r9d, edi
    imul    r9d, esi

no_new_min:
    pop     rax
    cmp     eax, limit
    jl      nextheight
    jmp     nextwidth

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
