section .data
    msg db "%d", 10, 0  ;return string for printf (just the result)
    num times 158 dd 0  ;array for big number representation

section .text
    extern printf
    global main

main:
    mov     ecx, 10                     ;for divisions
    mov     esi, 1                      ;factorial counter
    mov     edi, 157                    ;array index
    mov     dword [num + 4 * edi], 1    ;initial state

factorial:
    inc     esi                         ;increase counter
    mov     edi, 157                    ;reset array index
    xor     ebx, ebx                    ;reset carry

multiply:
    mov     eax, [num + 4 * edi]        ;put current digit in eax
    mul     esi                         ;multiply
    add     eax, ebx                    ;add carry
    xor     edx, edx                    ;reset remainder
    div     ecx                         ;divide by 10
    mov     ebx, eax                    ;carry = result
    mov     dword [num + 4 * edi], edx  ;digit @ edi = remainder
    dec     edi                         ;decrease index
    cmp     edi, 0                      ;check if index >= 0
    jge     multiply                    ;if yes, repeat
    cmp     esi, 100                    ;check if completed
    jl      factorial                   ;if not, jump to factorial
    xor     eax, eax                    ;else reset eax and ebx
    xor     ebx, ebx

sum:                                    ;sum all digits
    add     eax, [num + 4 * ebx]
    inc     ebx
    cmp     ebx, 157
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
