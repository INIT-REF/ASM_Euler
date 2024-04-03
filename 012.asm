section .data
    msg db "%d", 10, 0  ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    mov     ebx, 1      ;starting point
    mov     edi, 1      ;dito

nexttri:
    inc     edi         ;increase edi
    add     ebx, edi    ;add to ebx, result is next triangular number
    mov     r8d, 1      ;reset number of divisors
    mov     r9d, 1      ;reset prime factor counter
    mov     ecx, 2      ;reset divisor for prime factorization
    push    rbx         ;push current number on the stack
    call    divisors    ;call divisors
    pop     rbx         ;get number back from the stack
    cmp     r8d, 500    ;check if number of divisors > 500
    jg      print       ;if it is, print result
    jmp     nexttri     ;else go to next triangular number

divisors:
    test    ebx, 1      ;check if number is odd
    jnz     odd         ;if it is, go to odd
    shr     ebx, 1      ;else divide by 2
    inc     r9d         ;increase counter
    jmp     divisors    ;repeat

odd:
    mov     r8d, r9d    ;update number of divisors
    cmp     ebx, 1      ;check if number was reduced to 1
    je      back        ;if yes, return
    mov     r9d, 1      ;reset count
    mov     ecx, 1      ;prepare ecx for odd divisors

incdiv:
    add     ecx, 2      ;next odd divisor
    mov     eax, ecx    ;put current divisor in eax for squaring
    mul     ecx         ;square
    cmp     eax, ebx    ;check if square is > current number
    jg      double      ;if yes, finish
    cmp     r9d, 1      ;else check if count has increased
    je      divide      ;if not, jump to divide
    mov     eax, r8d    ;number of divisors in eax for product
    mul     r9d         ;multiply with count
    mov     r8d, eax    ;product back in number of divisors
    mov     r9d, 1      ;reset count

divide:
    xor     edx, edx    ;reset edx for remainder
    mov     eax, ebx    ;number in eax for division
    div     ecx         ;divide by current divisor
    test    edx, edx    ;check remainder
    jnz     incdiv      ;back to incdiv if not 0
    mov     ebx, eax    ;else update number with result
    inc     r9d         ;increase count
    jmp     divide      ;try dividing again
    
double:
    mov     eax, r8d    ;calculate final product
    mul     r9d
    mov     r8d, eax
    cmp     ebx, 2      ;check if remaining number is > 2
    jle     back        ;if not, return
    shl     r8d, 1      ;if yes, double number of divisors
    
back:
    ret

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

section .note.GNU-stack     ;just for gcc
