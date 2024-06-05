format ELF64 executable 9

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0

segment readable executable
    entry start

start:
    mov     eax, 1          ;length
    xor     ecx, ecx        ;counter

next_l:
    cmp     ecx, 1000000    ;count > 1e6?
    jg      finished        ;if yes, we are finished
    inc     eax             ;next length
    mov     edx, eax        ;in edx
    shl     edx, 1          ;2 * l as limit of next loop
    mov     ebx, 3          ;init width + height

next_wh:
    mov     edi, eax
    imul    edi, eax        ;l^2
    mov     esi, ebx
    imul    esi, ebx        ;(w + h)^2
    add     edi, esi        ;l^2 + (w + h)^2
    test    edi, 1          ;is result even (last bit 0)?
    jz      even            ;if yes, jump directly to even

mod_8:
    mov     esi, edi        ;any odd perfect square must be 1 (mod 8)
    and     esi, 7
    cmp     esi, 1
    jne     skip_count
    jmp     even

even:
    mov     esi, edi        ;while n is a power of 4, shift right 2 bits
    and     esi, 3
    test    esi, esi
    jnz     and_7
    shr     edi, 2
    jmp     even

and_7:                      ;if result & 7 != 1, n is not a perfect square
    mov     esi, edi
    and     esi, 7
    cmp     esi, 1
    jne     skip_count

    mov     esi, 1          ;prepare for squaretest
    mov     r8d, 1

squaretest:
    add     r8d, 2
    add     esi, r8d
    cmp     esi, edi
    jl      squaretest
    jg      skip_count

is_square:
    cmp     ebx, eax        ;is w + h <= l?
    jle     not_greater     ;if yes, jump to not_greater
    mov     edi, ebx        ;else calclulate (l - ((w + h + 1) / 2)) + 1
    mov     esi, eax
    inc     edi
    shr     edi, 1
    sub     esi, edi
    inc     esi
    add     ecx, esi        ;add result to count and continue
    jmp     skip_count

not_greater:
    mov     edi, ebx        ;calculate (w + h) / 2
    shr     edi, 1
    add     ecx, edi        ;and add to count

skip_count:
    inc     ebx             ;next width + height
    cmp     ebx, edx        ;<= 2 * l?
    jle     next_wh         ;if yes, repeat
    jmp     next_l          ;else take next l

finished:
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
