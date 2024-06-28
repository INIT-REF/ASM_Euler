section .data
    msg db "%d", 10, 0          ;return string for printf (just the result)

section .bss
    isabnum resq 440    ;28160 bits for flags
    sums    resq 440    ;dito

section .text
    extern printf
    global main

main:
    xor     eax, eax    ;index for outer sum loop
    mov     ecx, 11     ;starting number

abnums:
    inc     ecx                             ;next number
    cmp     ecx, 28124                      ;check if we are < 28124
    je      sum_init                        ;if not, jump to sum_init
    call    divsum                          ;get sum of divisors
    cmp     r8d, ecx                        ;check if sum is <= number
    jle     abnums                          ;if yes, try next number
    bts     [isabnum], ecx                  ;else set number to abnum
    jmp     abnums                          ;try next number

sum_init:
    xor     eax, eax                        ;reset eax

sum_outer:
    mov     ebx, eax                        ;starting index for inner loop
    inc     eax                             ;next number
    cmp     eax, 28123                      ;finished?
    jge     result                          ;then calculate result
    bt      [isabnum], eax                  ;test if eax is abundandt
    jnc     sum_outer                       ;if not, try next number

sum_inner:
    inc     ebx                             ;next number
    bt      [isabnum], ebx                  ;check if ebx is abundant
    jnc     sum_inner                       ;if not, try next number
    mov     ecx, eax                        ;move eax to ecx
    add     ecx, ebx                        ;add ebx
    cmp     ecx, 28123                      ;check if sum < 28124
    jg      sum_outer                       ;if not, go to outer loop
    bts     [sums], ecx                     ;set sums @ sum to 1
    jmp     sum_inner

result:
    xor     ecx, ecx    ;reset registers for sum building
    xor     ebx, ebx

sum:
    inc     ebx                         ;next number
    cmp     ebx, 28123                  ;check if we are finished
    jge     print                       ;then print result
    bt      [sums], ebx                 ;else check if we have a sum
    jc      sum                         ;then skip that number
    add     ecx, ebx                    ;else add it to total
    jmp     sum                         ;repeat

print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, ecx
    call    printf
    pop     rbp

exit:                   ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

divsum:
    mov     ebx, 1      ;reset divisor
    xor     r8d, r8d    ;reset sum of divisors

divide:
    inc     ebx         ;increase divisor (start with 2)
    mov     eax, ebx    ;put divisor in eax
    mul     ebx         ;square
    cmp     eax, ecx    ;check if suqare is > number
    jg      finished    ;if yes, we are finished
    mov     eax, ecx    ;else put number in eax
    xor     edx, edx    ;reset remainder
    div     ebx         ;divide by current divisor
    test    edx, edx    ;check if remainder = 0
    jnz     divide      ;if not, try next divisor
    cmp     eax, ebx    ;else check if result is equal to divisor
    je      add1        ;if yes, just add the divisor

add2:
    add     r8d, ebx    ;else add divisor and number / divisor
    add     r8d, eax
    jmp     divide

add1:
    add     r8d, ebx
    jmp     divide

finished:
    inc     r8d         ;add 1, as this is always a divisor
    ret


section .note.GNU-stack ;just for gcc
