format ELF64 executable 9

segment readable
    plimit equ 1000000              ;1e6, limit for the sieve

segment readable writable
    result: times 20 db 0           ;empty string for printing the result later
                     db 10, 0
    sieve: times 125000 db 255      ;prime sieve, 1e6 bits

segment readable executable
    entry start

start:
    mov     ebx, 1          ;array index for outer loop

sieve_outer:
    inc     ebx             ;increase index
    mov     eax, ebx        ;copy to eax for squaring
    mul     ebx             ;square
    cmp     eax, plimit     ;check if square is > limit    
    jg      reset           ;if it is, sieve is done
    bt      [sieve], ebx    ;check if ebx is no prime
    jnc     sieve_outer     ;if no prime, try next number

sieve_inner:
    btr     [sieve], eax    ;set multiple to not prime
    add     eax, ebx        ;next multiple
    cmp     eax, plimit     ;check if multiple is <= limit
    jl      sieve_inner     ;if it is, continue with inner loop
    jmp     sieve_outer     ;if not, continue with outer loop

reset:
    mov     eax, 1          ;number on the diagonal
    xor     ebx, ebx        ;counter
    xor     edi, edi        ;difference between numbers on the diagonal

next_layer:
    add     edi, 2          ;increase difference by 2
    mov     esi, 4          ;loop counter (4 corners)

layer_loop:
    dec     esi             ;decrease loop counter
    add     eax, edi        ;add difference to eax
    push    rax
    call    is_prime        ;is it prime
    pop     rax
    test    ecx, ecx
    jz      no_prime
    inc     ebx             ;if yes, increase count

no_prime:
    test    esi, esi        ;loop counter > 0?
    jnz     layer_loop      ;if yes, repeat
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
    mov     r8d, eax
    mov     r9d, 1
    
inc_div:
    inc     r9d
    bt      [sieve], r9d
    jnc     inc_div
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
    xor     ecx, ecx

back:
    ret

