section .data
    msg db "%d", 10, 0              ;return string for printf (just the result)
    steps dd 3, 2, 1, 3, 1, 2, 3    ;how the multiples of 3 and 5 are spaced

section .text
    extern printf
    global main

main:
    xor     eax, eax        ;result
    xor     ebx, ebx        ;current number
    xor     ecx, ecx        ;array index
    xor     edx, edx        ;zero for cmov later

countup:
    add     eax, ebx                ;add current number to result
    add     ebx, [steps + ecx * 4]  ;add steps@ecx to current number
    inc     ecx                     ;increase the array index
    cmp     ecx, 7                  ;check if end of steps
    cmove   ecx, edx                ;if yes, zero ecx
    cmp     ebx, 1000               ;check if we reached 1000
    jl      countup                 ;if not, continue

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
