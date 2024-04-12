section .data
    msg db "%d", 10, 0              ;return string for printf (just the result)
    
section .bss
    cc resb 1000001

section .text
    extern printf
    global main

main:
    xor     ebx, ebx    ;init number
    mov     edi, 10     ;for divisions
    mov     esi, 1      ;array index

next:
    inc     ebx         ;next number
    mov     eax, ebx    ;number in eax for divisions
    xor     ecx, ecx    ;length of number
    
digits:
    xor     edx, edx    ;reset remainder
    div     edi         ;divide by 10
    inc     ecx         ;increase length
    push    rdx         ;digit on the stack
    test    eax, eax    ;number reduced to 0?
    jnz     digits      ;if not, repeat

buildstring:
    pop     rdx                     ;digit from the stack
    add     dl, '0'                 ;get the ASCII value
    mov     byte [cc + esi], dl     ;append digit to string
    dec     ecx                     ;decrease length counter
    inc     esi                     ;increase the array counter
    cmp     esi, 1000000            ;end of array?
    je      result                  ;if yes, compute result
    test    ecx, ecx                ;ecx reduced to 0?
    jnz     buildstring             ;if not, continue
    jmp     next                    ;else jump to next

result:
    mov     eax, 1          ;product
    xor     ebx, ebx        ;reset ebx
    mov     esi, 1          ;reset index

product:
    mov     bl, [cc + esi]  ;ASCII digit in bl
    sub     bl ,'0'         ;subtract '0' to get the int value
    mul     ebx             ;multiply
    imul    esi, 10         ;multiply index by 10
    cmp     esi, 1000000    ;last index reached?
    jl      product         ;if not, continue
    
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
