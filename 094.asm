format ELF64 executable 9

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0

segment readable executable
    entry start

start:
    mov     rdi, 2              ;x
    mov     rsi, 1              ;y
    xor     r8, r8              ;result
    mov     r9, 3               ;for mod 3

getresult:                      ;start with the plus one case
    mov     rbx, rdi            ;get (2 * x) - 1
    shl     rbx, 1
    dec     rbx
    cmp     rbx, 1000000000     ;limit reached?
    jge     finished            ;if yes, we are finished
    mov     rcx, rdi            ;get y * (x - 2)
    sub     rcx, 2
    imul    rcx, rsi
    cmp     rbx, 0              ;(2 * x) - 1 > 0?
    jle     minus_1             ;if not, try minus one case
    cmp     rcx, 0              ;y * (x - 2) > 0?
    jle     minus_1             ;if not, try minus one case
    mov     rax, rcx
    xor     rdx, rdx
    div     r9
    test    rdx, rdx            ;y * (x - 2) mod 3 = 0?
    jnz     minus_1             ;if not, try minus one case
    mov     rax, rbx
    xor     rdx, rdx
    div     r9
    test    rdx, rdx            ;(2 * x) - 1 mod 3 = 0?
    jnz     minus_1             ;if not, try minus one case
    inc     rbx                 ;add (2 * x) to result
    add     r8, rbx             ;and add to result
    
minus_1:
    mov     rbx, rdi            ;get (2 * x) + 1
    shl     rbx, 1
    inc     rbx
    mov     rcx, rdi            ;get y * (x + 2) and continue like above
    add     rcx, 2
    imul    rcx, rsi
    cmp     rbx, 0
    jle     next_xy
    cmp     rcx, 0
    jle     next_xy
    mov     rax, rcx
    xor     rdx, rdx
    div     r9
    test    rdx, rdx
    jnz     next_xy
    mov     rax, rbx
    xor     rdx, rdx
    div     r9
    test    rdx, rdx
    jnz     next_xy
    dec     rbx
    add     r8, rbx

next_xy:
    push    rdi
    shl     rdi, 1              ;next x = (2 * x) + (3 * y)
    mov     rax, rsi
    imul    rax, 3
    add     rdi, rax
    pop     rax                 ;next y = (2 * y) + x
    shl     rsi, 1
    add     rsi, rax
    jmp     getresult

finished:
    mov     rax, r8
    mov     rbx, 10
    mov     ecx, 9

convert_result:
    xor     rdx, rdx
    div     rbx
    add     rdx, '0'
    mov     [result + ecx], dl
    dec     ecx
    test    rax, rax
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
