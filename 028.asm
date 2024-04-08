section .data
    msg db "%lld", 10, 0  ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    mov     edi, 4      ;init edi (loop counter)
    mov     ebx, 1      ;init total
    mov     esi, 1      ;intermediate sum
    mov     ecx, 4      ;for divisions

sum:
    xor     edx, edx    ;reset remainder
    mov     eax, edi    ;copy counter
    div     ecx         ;divide by 4
    shl     eax, 1      ;multiply by 2
    add     esi, eax    ;intermediate sum += result
    add     ebx, esi    ;add to total
    inc     edi         ;increase counter
    cmp     edi, 2004   ;limit = 2 * size + 2
    jl      sum         ;if lower, repeat

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
