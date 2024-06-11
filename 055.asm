format ELF64 executable 9

segment readable writable
    result: times 20 db 0       ;empty string for printing the result later
                     db 10, 0

segment readable executable
    entry start

start:
    xor     rdi, rdi            ;init n
    mov     rbx, 10             ;10 in rbx for reverse loop
    xor     r8d, r8d            ;counter
    jmp     next_n

count:
    pop     rdi
    inc     r8d

next_n:
    inc     rdi                 ;next n
    cmp     rdi, 10000          ;finished?
    je      finished
    push    rdi                 ;on the stack to save it
    call    reverse             ;reverse n, result in rcx
    xor     rsi, rsi            ;loop counter

lychrel:
    inc     rsi
    cmp     rsi, 50             ;50 iterations done?
    je      count               ;if yes, we can increase the counter
    add     rdi, rcx            ;add reverse to n
    call    reverse             ;reverse result
    cmp     rdi, rcx            ;result = reverse (i.e. a palindrome)?
    jne     lychrel             ;if not, repeat
    pop     rdi                 ;else reset rdi
    jmp     next_n              ;and try next number

reverse:
    mov     rax, rdi            ;reverse rdi, result in rcx
    xor     rcx, rcx

reverse_loop:
    imul    rcx, rbx
    xor     rdx, rdx
    div     rbx
    add     rcx, rdx
    test    rax, rax
    jnz     reverse_loop
    ret

finished:                       ;convert count to strin, print and exit
    mov     eax, r8d
    mov     ebx, 10
    mov     ecx, 19

convert_result:
    xor     edx, edx
    div     ebx
    add     edx, '0'
    mov     [result + rcx], dl
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
