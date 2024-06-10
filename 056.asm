format ELF64 executable 9

segment readable
    e16 equ 10000000000000000   ;1e16 for 16-digit chunks

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0
    
    pow rq 20                   ;20 * 64 bits for "BigInt" numbers

segment readable executable
    entry start

start:
    mov     edi, 100                ;init a
    xor     r8d, r8d                ;max

next_a:
    dec     edi                     ;next lower a
    cmp     edi, 1                  ;a = 1?
    je      finished                ;if yes, we are done
    mov     esi, 100                ;init b

next_b:
    dec     esi                     ;next lower b
    cmp     esi, 1                  ;b = 1?
    je      next_a                  ;if yes, get next a
    push    rsi
    mov     r9, e16                 ;1e16 in r9
    mov     rbx, 20
    xor     rax, rax

clear_pow:
    dec     rbx                     ;reset pow
    mov     [pow + 8 * rbx], rax
    test    rbx, rbx
    jnz     clear_pow
    mov     [pow + 152], 1

pow_loop:
    dec     esi
    mov     ecx, 20                 ;array index
    xor     r10, r10                ;reset carry

mult_loop:
    dec     ecx                     ;decrease index
    mov     rax, [pow + 8 * ecx]    ;multiply pow[ecx] with a
    mul     rdi
    add     rax, r10                ;add carry from last iteration
    xor     rdx, rdx                ;reset remainder
    div     r9                      ;truncate to 16 digits
    mov     [pow + 8 * ecx], rdx    ;truncated result in pow[ecx]
    mov     r10, rax                ;rest in carry
    test    ecx, ecx                ;loop done?
    jnz     mult_loop               ;if not, repeat
    test    esi, esi                ;power done
    jnz     pow_loop                ;if not, repeat
    pop     rsi
    mov     ecx, 20                 ;reset registers for digit sum
    xor     rbx, rbx
    mov     r9, 10

digit_sum:                          ;get digit sum and update max if needed
    dec     ecx
    mov     rax, [pow + 8 * ecx]

sum_loop:
    xor     rdx, rdx
    div     r9
    add     ebx, edx
    test    rax, rax
    jnz     sum_loop
    test    ecx, ecx
    jnz     digit_sum
    cmp     ebx, r8d
    cmovg   r8d, ebx
    jmp     next_b

finished:
    mov     eax, r8d
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
