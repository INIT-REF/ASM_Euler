format ELF64 executable 9

segment readable writable
    result: times 10 db 0           ;empty string for printing the result later
                     db 10, 0

segment readable executable
    entry start

start:
    mov     rdi, 10000000000    ;1e10 for mod
    mov     rbx, 2              ;base
    mov     rcx, 7830457        ;exponent
    mov     rax, 1              ;init result

modpow:
    mul     rbx
    xor     rdx, rdx
    div     rdi
    mov     rax, rdx
    dec     rcx
    test    rcx, rcx
    jnz     modpow

finished:
    imul    rax, 28433
    xor     rdx, rdx
    div     rdi
    mov     rax, rdx
    inc     rax

    mov     rbx, 10
    mov     rcx, 9

convert_result:
    xor     rdx, rdx
    div     rbx
    add     rdx, '0'
    mov     [result + ecx], dl
    dec     rcx
    test    rax, rax
    jnz     convert_result

print:
    mov     rax, 4
    mov     rdi, 1
    mov     rsi, result
    mov     rdx, 12
    syscall

exit:
    mov     rax, 1
    xor     rdi, rdi
    syscall
