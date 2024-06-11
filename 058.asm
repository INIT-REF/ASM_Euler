format ELF64 executable 9

segment readable writable
    result: times 20 db 0           ;empty string for printing the result later
                     db 10, 0

segment readable executable
    entry start

start:
    mov     eax, 1          ;number on the diagonal
    xor     ebx, ebx        ;counter
    xor     edi, edi        ;difference between numbers on the diagonal

next_layer:
    add     edi, 2          ;increase difference by 2
    mov     esi, 4          ;loop counter (4 corners)

layer_loop:
    dec     esi             ;decrease loop counter
    add     eax, edi        ;add difference to eax
    test    esi, esi
    jz      done            ;skip last number (is always square)
    push    rax
    call    is_prime        ;is it prime
    pop     rax
    test    ecx, ecx
    jz      no_prime
    inc     ebx             ;if yes, increase count

no_prime:
    test    esi, esi        ;loop counter > 0?
    jnz     layer_loop      ;if yes, repeat

done:
    push    rax             ;else save rax and rbx on the stack
    push    rbx

get_ratio:
    mov     eax, ebx        ;get ratio
    imul    eax, 100
    mov     ebx, edi
    shl     ebx, 1
    inc     ebx
    xor     edx, edx
    div     ebx
    cmp     eax, 10         ;ratio >= 10?
    pop     rbx
    pop     rax
    jge     next_layer      ;if yes, continue with next layer
    inc     edi             ;else get side length and print that

finished:
    mov     eax, edi
    mov     ebx, 10
    mov     ecx, 19

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
    mov     edx, 22
    syscall

exit:
    mov     eax, 1
    xor     edi, edi
    syscall

is_prime:
    mov     ecx, 1
    test    eax, 1
    jz      not_prime
    mov     r8d, eax
    mov     r9d, 1
    
inc_div:
    add     r9d, 2
    mov     eax, r9d
    mul     r9d
    cmp     eax, r8d
    jg      back

divide:
    mov     eax, r8d
    xor     edx, edx
    div     r9d
    test    edx, edx
    jnz     inc_div

not_prime:
    xor     ecx, ecx

back:
    ret

