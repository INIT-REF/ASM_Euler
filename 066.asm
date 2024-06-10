format ELF64 executable 9

segment readable
    e17 equ 100000000000000000  ;1e17 for 17-digit chunks

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0
    prev rq 3                   ;"BigInt" buffer, 192 Bits
    curr rq 3                   ;dito
    cf rb 96                    ;for continued fractions of sqrt(D)
    max rq 1                    ;max x
    max_D rd 1

segment readable executable
    entry start

start:
    mov     ebx, 1              ;init D

next_D:
    inc     ebx                 ;next D and on the stack for later
    cmp     ebx, 1000
    jg      finished
    push    rbx
    mov     edi, 12
    xor     rax, rax

clear_cf:                       ;clear cf array for next continued fraction
    dec     edi
    mov     qword [cf + 8 * edi], rax
    test    edi, edi
    jnz     clear_cf
    xor     ecx, ecx

find_root_floor:
    inc     ecx                 ;increase ecx and square it
    mov     eax, ecx
    mul     ecx
    cmp     eax, ebx            ;compare square to D
    je      next_D              ;if equal, D is a perfect square, skip that
    jl      find_root_floor     ;if lower, increase ecx
    dec     ecx                 ;if it was greater, decrease ecx again, finished
    mov     [curr + 16], rcx    ;floor(sqrt(D)) in curr
    mov     esi, ecx            ;a0
    mov     r8d, 0              ;m0
    mov     r9d, 1              ;d0
    mov     r10d, 1             ;loop counter for even/odd periods

get_cf:
    imul    esi, r9d        ;a * d
    sub     esi, r8d        ;a * d - m
    mov     r8d, esi        ;new m
    mov     eax, ebx        ;n
    imul    esi, esi        ;(new m)^2
    sub     eax, esi        ;n - (new m)^2
    xor     edx, edx        ;reset remainder
    div     r9d             ;(n - (new m)^2) / d
    mov     r9d, eax        ;new d
    mov     eax, ecx        ;a0
    add     eax, r8d        ;a0 + new m
    xor     edx, edx        ;reset remainder
    div     r9d             ;(a0 + new m) / new d
    mov     esi, eax        ;new a
    mov     [cf + edi], sil ;in cf[edi]
    inc     edi
    mov     eax, ecx        ;a0
    shl     eax, 1          ;2 * a0
    cmp     esi, eax        ;new a = 2 * a0?
    jne     get_cf          ;if not, repeat
    test    edi, 1          ;is period length even?
    jz      even            ;if yes, jump to even 
    inc     r10d            ;else set loop counter to 2

even:
    mov     r9, e17
    mov     rax, 1              ;init prev/curr
    mov     [prev + 16], rax
    xor     rax, rax
    mov     [curr + 8], rax
    mov     [prev + 8], rax
    mov     [curr], rax
    mov     [prev], rax

conv_start:
    dec     r10
    xor     edi, edi            ;init i
    xor     rcx, rcx

next_conv:
    mov     cl, [cf + edi]
    xor     rax, rax            ;reset registers for loop
    xor     rbx, rbx
    mov     r8d, 3

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
    inc     edi
    cmp     byte [cf + edi], 0      ;period finished?
    jg      next_conv               ;if not, get next convergent
    test    r10d, r10d              ;period loop done?
    jnz     conv_start              ;if not, repeat
    pop     rbx                     ;compare x to max and update max if greater
    mov     rax, [curr]
    cmp     rax, [max]
    jle     next_D
    mov     [max], rax
    mov     [max_D], ebx
    jmp     next_D

finished:
    mov     eax, [max_D]
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
