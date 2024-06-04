format ELF64 executable 9

segment readable
    n equ 2000000

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0

segment readable executable
    entry start

start:
    xor     eax, eax        ;width
    mov     r8d, n          ;min difference
    xor     r9d, r9d        ;area with min difference

nextwidth:
    inc     eax             ;increase width
    cmp     eax, 2000
    jg      finished
    xor     ebx, ebx        ;height

nextheight:
    inc     ebx             ;increase height
    mov     edi, eax        ;copy in counters
    mov     esi, ebx
    xor     ecx, ecx        ;height count
    xor     edx, edx        ;with count

widthsum:                   ;get sum in w direction
    add     ecx, edi
    dec     edi
    test    edi, edi
    jnz     widthsum

heightsum:                  ;get sum in h direction
    add     edx, esi
    dec     esi
    test    esi, esi
    jnz     heightsum

    imul    ecx, edx        ;update min if applicable and continue
    call    diff
    cmp     edx, r8d
    jg      nonewmin
    mov     r8d, edx
    mov     r9d, eax
    imul    r9d, ebx

nonewmin:
    cmp     ecx, n
    jl      nextheight
    jmp     nextwidth

diff:
    mov     edx, ecx
    sub     edx, n
    cmp     edx, 0
    jg      back
    neg     edx

back:
    ret

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
