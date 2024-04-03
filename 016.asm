section .data
    msg db "%d", 10, 0              ;return string for printf (just the result)
    num times 303 dd 0

section .text
    extern printf
    global main

main:
    xor     ebx, ebx                    ;carry
    mov     edi, 302                    ;array index
    mov     ecx, 10                     ;for divisions
    mov     esi, 1000                   ;power counter
    mov     dword [num + 4 * edi], 1    ;initial state

power:
    dec     esi                         ;decrease counter
    mov     edi, 302                    ;reset index

multiply:
    xor     edx, edx                    ;reset remainder
    mov     eax, [num + 4 * edi]        ;put current digit in eax
    shl     eax, 1                      ;double
    add     eax, ebx                    ;add carry
    div     ecx                         ;divide by 10
    mov     ebx, eax                    ;carry = result
    mov     dword [num + 4 * edi], edx  ;digit @ edi = remainder
    dec     edi                         ;decrease index
    test    edi, edi                    ;check if index = 0
    jnz     multiply                    ;if not, repeat
    test    esi, esi                    ;check if completed
    jnz     power                       ;if not, jump to power
    xor     eax, eax                    ;else reset eax and ebx
    xor     ebx, ebx

sum:                                    ;sum all digits
    add     eax, [num + 4 * ebx]
    inc     ebx
    cmp     ebx, 303
    jl      sum
    
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
