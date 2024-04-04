section .data
    msg db "%d", 10, 0              ;return string for printf (just the result)
    ones dd 3,3,5,4,4,3,5,5,4               ;"one", "two" ... "nine"
    teens dd 3,6,6,8,8,7,7,9,8,8            ;"ten", "eleven" ... "nineteen"
    tens dd 6,6,5,5,5,7,6,6                 ;"twenty", "thirty" ... "ninety"
    hundreds dd 10,10,12,11,11,10,12,12,11  ;"onehundred" ... "ninehundred"

section .text
    extern printf
    global main

main:
    xor     eax, eax        ;sum
    xor     ecx, ecx        ;counter outer loop

reset1:
    xor     ebx, ebx        ;counter inner loop
    inc     ecx
    cmp     ecx, 91
    je      reset2

add1:
    add     eax, [ones + 4 * ebx]
    inc     ebx
    cmp     ebx, 9
    je      reset1
    jmp     add1

reset2:
    xor     ecx, ecx

reset3:
    xor     ebx, ebx
    inc     ecx
    cmp     ecx, 11
    je      reset4

add2:
    add     eax, [teens + 4 * ebx]
    inc     ebx
    cmp     ebx, 10
    je      reset3
    jmp     add2

reset4:
    xor     ecx, ecx

reset5:
    xor     ebx, ebx
    inc     ecx
    cmp     ecx, 101
    je      reset6

add3:
    add     eax, [tens + 4 * ebx]
    inc     ebx
    cmp     ebx, 8
    je      reset5
    jmp     add3

reset6:
    xor     ecx, ecx

reset7:
    xor     ebx, ebx
    inc     ecx
    cmp     ecx, 101
    je      addand

add4:
    add     eax, [hundreds + 4 * ebx]
    inc     ebx
    cmp     ebx, 9
    je      reset7
    jmp     add4

addand:
    add     eax, 2673   ;9 * 99 * 3 for "and" in hundreds

addonethousand:
    add     eax, 11 

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, eax
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
