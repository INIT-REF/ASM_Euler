format ELF64 executable 9

segment readable
    limit equ 1000000000000

segment readable writable
    result: times 20 db 0       ;empty string for printing the result later
                     db 10, 0

segment readable executable
    entry start

start:
    mov     rbx, 15         ;b (number of blue discs)
    mov     rcx, 21         ;t (total number of discs)
    mov     rdi, limit

getresult:
    cmp     rcx, rdi        ;limit reached?
    jg      finished        ;if yes, we are finished    
    push    rbx             ;b and t on the stack
    push    rcx
    imul    rbx, 3          ;b = (3 * b) + (2 * n) - 2
    shl     rcx, 1
    add     rbx, rcx
    sub     rbx, 2
    pop     rcx             ;old b and n from the stack
    pop     rax
    imul    rcx, 3
    shl     rax, 2
    add     rcx, rax
    sub     rcx, 3          ;n = (3 * n) + (4 * b) - 3
    jmp     getresult       ;repeat

finished:
    mov     rax, rbx
    mov     rbx, 10
    mov     rcx, 19

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
    mov     rdx, 22
    syscall

exit:
    mov     rax, 1
    xor     rdi, rdi
    syscall
