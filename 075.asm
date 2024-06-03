format ELF64 executable 9

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0

    new: rd 46875               ;flags for new perimeters (1,500,000 bits)
    old: rd 46875               ;flag for old perimeters (dito)

segment readable executable
    entry start

start:
    mov     edi, 1          ;init m
    xor     r8d, r8d        ;result

next_m:
    inc     edi             ;next m
    cmp     edi, 866        ;m > sqrt(1,500,000 / 2)?
    jg      finished        ;if yes, we are finished
    xor     esi, esi        ;init n

next_n:
    inc     esi             ;next n
    cmp     esi, edi        ;n >= m?
    jge     next_m          ;if yes, take next m
    mov     eax, edi        ;is n + m odd?
    add     eax, esi
    test    eax, 1
    jz      next_n          ;if not, take next n
    mov     eax, edi        ;gcd(n, m) = 1?
    mov     ebx, esi
    call    gcd
    cmp     ebx, 1
    jne     next_n          ;if not, take next n
    mov     eax, edi        ;p = m
    mul     edi             ;p = m^2
    shl     eax, 1          ;p = 2 * m^2
    mov     ecx, edi
    imul    ecx, esi
    shl     ecx, 1          ;c = 2 * m * n
    add     eax, ecx        ;p = (2 * m^2) + (2 * n * m)
    mov     ebx, eax        ;copy in ebx for multiples

set_flags:
    cmp     eax, 1500000    ;limit reached?
    jg      next_n          ;if yes, jump to next_n
    bts     [new], eax      ;flag in new[eax] already set (and set if not)?
    jc      old_perimeter   ;if yes, jump to old_perimeter
    inc     r8d             ;else increase count
    jmp     next_multiple   ;and jump to next_multiple

old_perimeter:
    bts     [old], eax      ;flag in old[eax] already set (and set if not)?
    jc      next_multiple   ;if yes, jump to next multiple
    dec     r8d             ;else decrease count

next_multiple:
    add     eax, ebx        ;next multiple
    jmp     set_flags       ;and repeat

gcd:
    xchg    eax, ebx        ;get gcd(m, n)
    xor     edx, edx
    div     ebx
    mov     eax, edx
    test    eax, eax
    jnz     gcd
    ret

finished:
    mov     eax, r8d        ;convert result to string, print and exit
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
