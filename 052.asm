section .data
    msg db "%d", 10, 0              ;return string for printf (just the result)

section .bss
    o resb 10   ;digit pattern of n
    m resb 10   ;digit pattern of multiple

section .text
    extern printf
    global main

main:
    mov     ebx, 1      ;staring number
    mov     ecx, 10     ;for divisions

nextn:
    inc     ebx         ;next number
    mov     eax, ebx    ;copy to eax
    xor     edi, edi    ;reset edi (array index)

reseto:
    mov     byte [o + edi], 0   ;reset o to all zeros
    inc     edi
    cmp     edi, 10
    jl      reseto

getodigits:                     ;get digit pattern of x in o
    xor     edx, edx
    div     ecx
    inc     byte [o + edx]
    cmp     eax, 0
    jg      getodigits
    mov     esi, 1

nextmultiple:                   ;get next multiple
    inc     esi
    cmp     esi, 7
    je      print
    mov     eax, ebx
    mul     esi
    xor     edi, edi

resetm:                 
    mov     byte [m + edi], 0   ;reset m to all zeros
    inc     edi
    cmp     edi, 10
    jl      resetm

getmdigits:                     ;get digit pattern of multiple
    xor     edx, edx
    div     ecx
    inc     byte [m + edx]
    cmp     eax, 0
    jg      getmdigits
    xor     edi, edi
    xor     eax, eax
    xor     edx, edx

compare:                        ;compare both patterns and either try next
    mov     al, [o + edi]       ;multiple if they match or next number if
    mov     dl, [m + edi]       ;they don't
    inc     edi
    cmp     edi, 11
    je      nextmultiple
    cmp     al, dl
    je      compare
    jmp     nextn

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
