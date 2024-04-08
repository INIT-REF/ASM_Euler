section .data
    msg db "%d", 10, 0              ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    xor     ecx, ecx        ;total
    mov     edi, 10         ;for divisions by 10 to get the digits
    mov     ebx, 354295     ;6 * 9^5 as upper limit

nextnumber:
    dec     ebx
    cmp     ebx, 1          ;arrived at 1?
    je      print           ;if yes, print result
    xor     esi, esi        ;reset sum of digits
    mov     eax, ebx        ;copy number in eax

getsum:
    xor     edx, edx        ;reset remainder
    div     edi             ;divide by 10
    push    rax             ;reduced number on the stack
    mov     eax, edx        ;remainder (last digit) in eax
    push    rdx             ;digit on the stack
    mul     eax             ;digit^2
    mul     eax             ;digit^4
    pop     rdx             ;digit back from the stack
    mul     edx             ;digit^5
    add     esi, eax        ;add to sum
    pop     rax             ;partial number back from the stack
    test    eax, eax        ;check if number was reduced to 0
    jnz     getsum          ;if not, repeat
    cmp     ebx, esi        ;sum = number
    jne     nextnumber      ;if not, try next number
    add     ecx, esi        ;else add sum to toal
    jmp     nextnumber      ;and try next number

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, ecx
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
