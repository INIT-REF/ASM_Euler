section .data
    msg db "%d", 10, 0              ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    mov     ebx, 10         ;init numerator
    mov     edi, 10         ;for divisions

nextn:
    inc     ebx             ;next numerator
    cmp     ebx, 100        ;numerator = 100
    je      finished        ;if yes, we are finished
    xor     edx, edx        ;reset remainder
    mov     eax, ebx        ;copy numerator in eax
    div     edi             ;divide by 10
    test    rdx, rdx        ;remainder = 0?
    jz      nextn           ;if yes, go to next numerator
    mov     r8d, edx        ;2nd digit of numerator in e8d
    mov     eax, r8d        ;digit in eax
    mul     edi             ;multiply by 10
    mov     ecx, eax        ;result in ecx (denominator)

nextd:
    add     ecx, 1
    inc     r8d
    cmp     r8d, 10
    je      nextn
    mov     eax, ebx
    xor     edx, edx
    div     ecx          
    test    edx, edx
    jz      nextd
    mov     eax, ecx
    div     edi
    mov     r9d, eax
    mov     eax, ecx

gcd_start:
    cmp     eax, ebx    ;check if eax > ebx
    jg      gcd_mod     ;if yes, jump to the gcd loop
    xchg    ebx, eax    ;if not, exchange both numbers
    
gcd_mod:
    test    eax, eax    ;if eax or ebx are 0, go to gcd
    jz      gcd
    test    ebx, ebx
    jz      gcd
    xor     edx, edx    ;prepare rdx for the remainder    
    div     ebx         ;divide by the smaller number
    mov     eax, edx    ;replace bigger number with remainder
    jmp     gcd_start   ;back to the start with the new numbers

gcd:
    test    eax, eax    ;check if eax is zero
    cmovnz  ebx, eax    ;if not, replace ebx with eax (as ebx was zero)


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
