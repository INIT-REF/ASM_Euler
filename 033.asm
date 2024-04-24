section .data
    msg db "%d", 10, 0              ;return string for printf (just the result)
    nums dd 11, 12, 13, 14, 15, 16, 17, 18, 19, 21   ;valid numbers for n and d
         dd 22, 23, 24, 25, 26, 27, 28, 29, 31, 32
         dd 33, 34, 35, 36, 37, 38, 39, 41, 42, 43
         dd 44, 45, 46, 47, 48, 49, 51, 52, 53, 54
         dd 55, 56, 57, 58, 59, 61, 62, 63, 64, 65
         dd 66, 67, 68, 69, 71, 72, 73, 74, 75, 76
         dd 77, 78, 79, 81, 82, 83, 84, 85, 86, 87
         dd 88, 89, 91, 92, 93, 94, 95, 96, 97, 98, 99

section .text
    extern printf
    global main

main:
    xor     edi, edi    ;nominator index
    xor     esi, esi    ;denominator index
    mov     r14d, 1     ;nominator product for result
    mov     r15d, 1     ;denominator product for result
    mov     ecx, 10     ;for divisions by 10
    jmp     nextd       ;jump to nextd for first iteration

nextn:
    inc     edi         ;next nominator
    cmp     edi, 80     ;last nominator reached?
    je      result      ;if yes, get result
    mov     esi, edi

nextd:
    inc     esi                     ;next denominator
    cmp     esi, 81                 ;end of array?
    je      nextn                   ;if yes, continue with next nominator
    mov     r8d, [nums + 4 * edi]   ;nominator value in r8d
    mov     r9d, [nums + 4 * esi]   ;dito with denominator
    mov     eax, r8d                ;r8d in eax for digit check
    xor     edx, edx                ;reset remainder
    div     ecx                     ;divide by 10
    mov     ebx, edx                ;remainder in ebx
    mov     eax, r9d                ;r9d in eax for digit check
    xor     edx, edx                ;reset remainder
    div     ecx                     ;divide by 10
    cmp     eax, ebx                ;second digit of n = first digit of d?
    jne     nextd                   ;if not, try text
    mov     eax, r8d                ;copy values in eax/ebx for gcd
    mov     ebx, r9d
    call    gcd_start               ;gcd is now in ebx
    cmp     ebx, 1                  ;is gcd = 1 (fraction can't be reducded)?
    je      nextd                   ;if yes, try next denominator
    
reduce:
    mov     eax, r8d    ;nominator in eax
    div     ebx         ;divide by gcd
    mov     r8d, eax    ;result back in r8d
    mov     eax, r9d    ;denominator in eax
    div     ebx         ;divide by gcd
    mov     r9d, eax    ;result back in r9d

simplify:
    mov     eax, [nums + 4 * edi]   ;nominator in eax
    div     ecx                     ;divide by 10
    mov     ebx, eax                ;result in ebx for gcd
    mov     r10d, eax               ;and in r10d for later
    mov     eax, [nums + 4 * esi]   ;denominator in eax
    xor     edx, edx                ;reset remainder
    div     ecx                     ;divide by 10
    mov     eax, edx                ;remainder in eax for gcd
    mov     r11d, edx               ;and in r11d for later
    call    gcd_start               ;get gcd of simplified fraction
    cmp     ebx, 1                  ;is gcd 1?
    je      compare                 ;if yes, compare fractions
    mov     eax, r10d               ;else divide both by gcd
    div     ebx
    mov     r10d, eax
    mov     eax, r11d
    div     ebx
    mov     r11d, eax

compare:
    cmp     r8d, r10d               ;reduced original n = reduced simplified n?
    jne     nextd                   ;if not, try next
    cmp     r9d, r11d               ;reduced original d = reduced simplified d?
    jne     nextd                   ;if not, try next
    imul    r14d, [nums + 4 * edi]  ;if both match, update product
    imul    r15d, [nums + 4 * esi]
    jmp     nextd                   ;and try next

result:
    mov     eax, r14d   ;nominator product in eax for gcd
    mov     ebx, r15d   ;denominator product in ebx for gcd
    call    gcd_start
    mov     eax, r15d   ;denominator product in eax
    div     ebx         ;divide by gcd

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
    ret

section .note.GNU-stack     ;just for gcc
