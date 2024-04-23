section .data
    msg db "%d", 10, 0  ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    mov     ebx, 209    ;(2 * 3 * 5 * 7) - 1

reset:
    xor     r8d, r8d    ;number counter

next:
    xor     esi, esi    ;prime factor counter
    inc     ebx         ;next number
    mov     ecx, ebx    ;copy in ecx
    test    ecx, 1      ;is number odd?
    jnz     odd         ;if yes, jump to odd
    inc     esi         ;if not, increase esi, because 2 is a factor

even:
    shr     ecx, 1      ;eax / 2
    test    ecx, 1      ;is eax now odd?
    jz      even        ;if not, continue dividing by 2
    cmp     ecx, 105    ;number < 3 * 5 * 7?
    jl      reset       ;if yes, reset

odd:
    mov     edi, 1      ;for trial divisions

incdiv:
    add     edi, 2      ;next odd divisor
    mov     eax, ecx    ;number in eax for trial divison
    xor     edx, edx    ;reset remainder
    div     edi         ;divide by edi
    test    edx, edx    ;is remainder 0?
    jnz     incdiv      ;if not, try next divisor
    inc     esi         ;else increase counter
    cmp     esi, 4      ;counter > 4?
    jg      reset       ;if yes, reset

divide:
    mov     eax, ecx    ;number in eax for divison
    xor     edx, edx    ;reset remainder
    div     edi         ;divide by current divisor
    test    edx, edx    ;remainder still 0?
    jnz     incdiv      ;if not, try next divisor
    mov     ecx, eax    ;else put result in ecx
    cmp     ecx, 1      ;number reduced to 1?
    je      finished    ;if yes, jump to finished
    mov     eax, edi    ;else put divisor in eax for squaring
    mul     edi         ;square
    cmp     eax, ecx    ;square <= number
    jle     divide      ;if yes, continue
    inc     esi         ;else account for remaining prime factor

finished:
    cmp     esi, 4      ;else check if we have 4 distinct prime factors
    jl      reset       ;if not, reset number count
    inc     r8d         ;if yes, increase number counter
    cmp     r8d, 4      ;have we found 4 consecutive numbers?
    jl      next        ;if not, try next number
    sub     ebx, 3      ;else subtract 3 from ebx to get the first number
    
print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, ebx
    call    printf
    pop     rbp

exit:                   ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack ;just for gcc
