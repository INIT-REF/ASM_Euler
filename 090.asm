format ELF64 executable 9

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0
    dice: rd 210
    squares dd 1, 4, 9, 16, 25, 36, 49, 64, 81

segment readable executable
    entry start

start:
    xor     eax, eax                ;init n
    xor     edi, edi                ;array index for dice[]
    xor     r10d, r10d              ;counter for valid die combinations

get_dice:
    inc     eax                     ;next n
    cmp     eax, 1024               ;we only need 10 bits
    je      combine                 ;if n > 1024, start combining
    popcnt  esi, eax                ;get bit count of eax
    cmp     esi, 6                  ;is it 6?
    jne     get_dice                ;if not continue
    mov     [dice + 4 * edi], eax   ;else put number in dice[edi]
    inc     edi
    jmp     get_dice                ;and repeat

combine:
    xor     edi, edi                ;init index of die 1 in dice[]

die_1:
    mov     esi, edi                ;init index of die 2 in dice[]

die_2:
    inc     esi                     ;next die 2 (can't be the same as die 1)
    mov     ebx, [dice + 4 * edi]   ;die 1 in ebx
    mov     ecx, [dice + 4 * esi]   ;die 2 in ecx
    mov     edx, 576                ;288 in edx (only bit 6 and 9 set)
    and     edx, ebx                ;logical and with die 1
    test    edx, edx                ;result 0?
    jz      test_69_2               ;if yes, test die 2
    or      ebx, 576                ;else set bits 6 and 9

test_69_2:
    mov     edx, 576                ;repeat for die 2
    and     edx, ecx
    test    edx, edx
    jz      try_squares
    or      ecx, 576

try_squares:
    xor     r8d, r8d                    ;init some registers
    mov     r9d, 10
    xor     r11d, r11d

_loop:
    mov     eax, [squares + 4 * r8d]    ;current square in eax
    xor     edx, edx
    div     r9d                         ;divide by 10
    bt      ebx, eax                    ;10s in die 1?
    setc    r11b                        ;if yes, set r11d to 1
    shl     r11d, 1                     ;and shift left
    bt      ecx, edx                    ;1s in die 2?
    adc     r11d, 0                     ;if yes, set bit 0 in r11d
    cmp     r11d, 3                     ;is r11d 3 (binary 11)?
    je      valid                       ;if yes, we have a valid solution
    xor     r11d, r11d
    bt      ecx, eax                    ;do the same with switched dies
    setc    r11b
    shl     r11d, 1
    bt      ebx, edx
    adc     r11d, 0
    cmp     r11d, 3
    jne     not_valid

valid:
    xor     r11d, r11d                  ;reset r11d and try next square
    inc     r8d
    cmp     r8d, 8                      ;until all squares done
    jle     _loop
    inc     r10d                        ;count valid combo

not_valid:
    cmp     esi, 209                    ;and get next combo
    jl      die_2
    inc     edi
    cmp     edi, 208
    jl      die_1

finished:
    mov     eax, r10d
    mov     ebx, 10
    mov     ecx, 9    

convert_result:                     ;convert to string, print and exit
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
    mov     rax, 1
    xor     rdi, rdi
    syscall
