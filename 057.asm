format ELF64 executable 9

segment readable
    e16 equ 10000000000000000   ;1e16 for 16-digit chunks

segment readable writable
    result: times 20 db 0       ;empty string for printing the result later
                     db 10, 0
    num rq 25                   ;"BigInt" buffer for numerator 1600 Bits
    den rq 25                   ;dito for denominator

segment readable executable
    entry start

start:
    mov     r8, e16             ;1e16 in r8
    mov     [num + 8 * 24], 1   ;init num/den to 1
    mov     [den + 8 * 24], 1
    mov     edi, 1              ;init i
    xor     r11d, r11d          ;counter (result)
    
next_conv:
    inc     edi                 ;increase i
    cmp     edi, 1000           ;finished?
    je      finished
    mov     esi, 25             ;end of array
    xor     r9, r9              ;num carry
    xor     r10, r10            ;den carry

conv_loop:
    dec     esi                     ;decrease index
    mov     rax, [den + 8 * esi]    ;current num/den in rax/rbx
    mov     rbx, [num + 8 * esi]
    add     rbx, rax                ;den + num for later
    shl     rax, 1                  ;den * 2
    add     rax, r9                 ;add carry
    add     rax, [num + 8 * esi]    ;add num
    xor     rdx, rdx
    div     r8
    mov     [num + 8 * esi], rdx    ;num %= 1e16
    mov     r9, rax                 ;rest in carry
    mov     rax, rbx                ;old num + den in rax
    add     rax, r10                ;add carry
    xor     rdx, rdx
    div     r8
    mov     [den + 8 * esi], rdx    ;den %= 1e16
    mov     r10, rax                ;rest in carry
    test    esi, esi                ;loop done?
    jnz     conv_loop               ;if not, repeat
    mov     esi, 25                 ;reset index

get_first_sig:
    dec     esi                     ;decrease esi until num[esi] is 0
    mov     rax, [num + 8 * esi]
    test    rax, rax
    jnz     get_first_sig
    inc     esi                     ;increase esi again
    mov     rax, [num + 8 * esi]    ;get first digits of num
    mov     rbx, [den + 8 * esi]    ;dito for den
    test    rbx, rbx                ;is den[esi] = 0
    jz      count                   ;then increase counter
    mov     rcx, 10                 ;else put 10 in rcx for divisions

get_length:
    xor     rdx, rdx                ;reset remainder
    div     rcx                     ;divide num[esi] by 10
    xchg    rax, rbx                ;exchange rax and rbx
    xor     rdx, rdx                ;reset remainder again
    div     rcx                     ;divide den[esi] by 10
    xchg    rax, rbx                ;exchange rax/rbx to original
    test    rbx, rbx                ;den[esi] reduced to 0?
    jnz     get_length              ;if not, repeat
    test    rax, rax                ;is num[esi] still > 0 (= had more digits)
    jz      next_conv               ;if not, get next convergent

count:
    inc     r11d                    ;else increase counter
    jmp     next_conv               ;and get next convergent

finished:
    mov     eax, r11d
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
