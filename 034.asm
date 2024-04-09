section .data
    msg db "%d", 10, 0              ;return string for printf (just the result)
    fac dd 1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880    ;0! ... 9!

section .text
    extern printf
    global main

main:   
    xor     ebx, ebx        ;total
    mov     edi, 10         ;for divisions
    mov     ecx, 2540160    ;7 * 9!
    
nextn:
    dec     ecx             ;next lower number
    cmp     ecx, 2          ;finished?
    je      print
    xor     esi, esi        ;sum of digit factorials
    mov     eax, ecx        ;copy of number in eax

digits:
    xor     edx, edx                ;reset remainder
    div     edi                     ;divide by 10
    add     esi, [fac + 4 * rdx]    ;add digit factorial to sum
    test    eax, eax                ;number reduced to 0?
    jnz     digits                  ;if not, repeat
    cmp     esi, ecx                ;sum = number
    jne     nextn                   ;if not, try next number
    add     ebx, esi                ;else add sum to total
    jmp     nextn                   ;and try next number

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, ebx
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
