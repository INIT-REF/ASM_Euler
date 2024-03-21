section .data
    msg db "%d", 10, 0  ;return string for printf (just the result)
    max dd 0            ;variable to store current maximum

section .text
extern printf
global main

main:
    mov     ecx, 10     ;10 in eax for computing the reverse later
    mov     edi, 99     ;starting number for building the products
                        ;will be increased to 100 in the next step

reset:
    inc     edi         ;increase multiplicand
    cmp     edi, 1000   ;check the multiplicand reached 1000
    je      print       ;if yes, print the result
    mov     esi, edi    ;put multiplicand in multiplier

nextproduct:
    mov     eax, edi    ;put multipicand in eax
    mul     esi         ;multiply by multiplier
    push    rax         ;push product on the stack
    inc     esi         ;increase the multiplier
    cmp     esi, 1000   ;check if the multiplier reached 1000
    je      reset       ;if yes, go to reset
    xor     ebx, ebx    ;prepare ebx which will store the reverse
   
ispalindrome:
    push    rax             ;push current (partial) product on the stack
    mov     eax, ebx        ;put current (partial) reverse in eax
    mul     ecx             ;multiply that by 10
    mov     ebx, eax        ;move result back in ebx
    xor     edx, edx        ;reset edx, which will hold the remainder
    pop     rax             ;get current product back from the stack
    div     ecx             ;divide it by 10
    add     ebx, edx        ;add remainder to ebx
    test    eax, eax        ;check if product was reduced to zero
    jnz     ispalindrome    ;if not, continue reveral process
    pop     rax             ;else get original product back from the stack
    cmp     ebx, eax        ;check if reverse = product
    jne     nextproduct     ;if not, continue with the next product
    cmp     ebx, [max]      ;if yes, check if it is greater than current max
    jle     nextproduct     ;if lower, continue with next product
    mov     [max], ebx      ;if greater, put it in max
    jmp     nextproduct     ;and continue with next product

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, [max]
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
