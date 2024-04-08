section .data
    msg db "%d", 10, 0              ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    mov     ebx, 1      ;init d
    xor     ecx, ecx    ;max cycle length

cycle_outer:
    mov     edi, 5      ;for testing divisibility by 5 (no reciprocal cycle)
    add     ebx, 2      ;next d, only odd values can lead to reciprocal cycles
    cmp     ebx, 1000   ;finished?
    jge     print       ;then print result
    mov     eax, ebx    ;d in eax for division
    xor     edx, edx    ;clear remainder
    div     edi         ;divide by 5
    test    edx, edx    ;check if remainder = 0
    jz      cycle_outer ;if yes, try next d
    mov     eax, 10     ;init eax for inner loop
    mov     esi, 1      ;cycle length
    mov     edi, 10     ;for multiplication by 10 in inner loop

cycle_inner:
    xor     edx, edx    ;reset remainder
    div     ebx         ;for 10 mod d
    mov     eax, edx    ;remainder in eax

getlength:
    cmp     eax, 1      ;test if we are finished
    jle     setmax      ;if yes, go to setmax
    inc     esi         ;length++
    mul     edi         ;eax * 10
    xor     edx, edx    ;reset remainder
    div     ebx         ;divide by d
    mov     eax, edx    ;remainder in eax   
    jmp     getlength   ;continue

setmax:
    cmp     esi, ecx    ;check if length > max
    cmovg   ecx, esi    ;if yes, set new max
    cmovg   r8d, ebx    ;and put current d with max length in r8d
    jmp     cycle_outer ;next d
    
print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, r8d
    call    printf
    pop     rbp

exit:                   ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack ;just for gcc
