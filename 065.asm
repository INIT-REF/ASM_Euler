format ELF64 executable 9

segment readable
    e17 equ 100000000000000000  ;1e17 for 17-digit chunks

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0
    prev rq 4                   ;"BigInt" buffer, 192 Bits
    curr rq 4                   ;dito

segment readable executable
    entry start

start:
    mov     r9, e17             ;1e17 in r9
    mov     rax, 8              ;init prev/curr to 8/11
    mov     [prev + 24], rax
    mov     rax, 11
    mov     [curr + 24], rax
    mov     edi, 4              ;init i
    mov     esi, 3              ;for mod 3
    
next_conv:
    inc     edi                 ;increase i
    mov     ecx, 1              ;a(i)
    mov     eax, edi            ;get i mod 3
    xor     edx, edx
    div     esi
    test    edx, edx            ;i mod 3 = 0?
    jnz     reset               ;if not, just do prev + curr
    mov     ecx, eax            ;else set a(i) to 2 * (i / 3)
    shl     ecx, 1

reset:
    xor     rax, rax            ;reset registers for loop
    xor     rbx, rbx
    mov     r8d, 4

_loop:
    dec     r8d                     ;decrease index
    mov     rax, [curr + 8 * r8d]   ;multiply curr[r8d] with rcx
    mul     rcx
    add     rax, [prev + 8 * r8d]   ;add prev[r8d]
    add     rax, rbx                ;add carry from last iteration
    xor     rdx, rdx                ;reset remainder
    div     r9                      ;truncate to 17 digits
    mov     rbx, [curr + 8 * r8d]   ;exchange curr and prev
    mov     [prev + 8 * r8d], rbx
    mov     [curr + 8 * r8d], rdx   ;truncated result in curr[r8d]
    mov     rbx, rax                ;rest in carry
    test    r8d, r8d                ;loop done?
    jnz     _loop                   ;if not, repeat
    cmp     edi, 100                ;100th convergent reached?
    jl      next_conv               ;if not, get next

digit_sum:
    mov     r8d, 4
    xor     ebx, ebx
    mov     r9, 10

next_n:
    dec     r8d
    mov     rax, [curr + 8 * r8d]

sum_loop:
    xor     rdx, rdx
    div     r9
    add     ebx, edx
    test    rax, rax
    jnz     sum_loop
    test    r8d, r8d
    jnz     next_n

finished:
    mov     rax, rbx
    mov     rbx, 10
    mov     ecx, 9

convert_result:
    xor     rdx, rdx
    div     rbx
    add     edx, '0'
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
