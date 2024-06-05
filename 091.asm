format ELF64 executable 9

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0

segment readable executable
    entry start

start:
    mov     ecx, 7500       ;50 * 50 * 3 "trivial" cases
    xor     edi, edi        ;outer loop index

next_a:
    inc     edi
    cmp     edi, 50         ;a > limit?
    jg      finished        ;if yes, we are finished
    xor     esi, esi        ;inner loop index

next_b:
    inc     esi
    mov     eax, edi
    mov     ebx, esi
    call    gcd             ;get gcd(a, b)
    push    rbx             ;and put it on the stack
    imul    ebx, esi        ;gcd * b
    mov     eax, ebx
    xor     edx, edx
    div     edi             ;divide by a        
    pop     rbx             ;gcd back from the stack
    push    rax             ;put prior result on the stack
    mov     eax, 50
    sub     eax, edi        ;50 - a
    mul     ebx
    xor     edx, edx
    div     esi             ;(50 - a) * gcd(a, b) / b
    pop     rbx             ;prior result in ebx
    cmp     eax, ebx        ;get minimum of eax and ebx
    cmovg   eax, ebx        ;and put it in eax
    shl     eax, 1          ;double that
    add     ecx, eax        ;and add to count
    cmp     esi, 50         ;b > limit?
    jl      next_b          ;if not, continue inner loop
    jmp     next_a          ;else jump to outer loop

gcd:
    xchg    eax, ebx        ;get gcd(m, n), result in ebx
    xor     edx, edx
    div     ebx
    mov     eax, edx
    test    eax, eax
    jnz     gcd
    ret

finished:
    mov     eax, ecx        ;convert result to string, print and exit
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
