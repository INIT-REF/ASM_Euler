section .data
    msg db "%d", 10, 0  ;return string for printf (just the result)
    tri dd 75
        dd 95,64
        dd 17,47,82
        dd 18,35,87,10
        dd 20,04,82,47,65
        dd 19,01,23,75,03,34
        dd 88,02,77,73,07,63,67
        dd 99,65,04,28,06,16,70,92
        dd 41,41,26,56,83,40,80,70,33
        dd 41,48,72,33,47,32,37,16,94,29
        dd 53,71,44,65,25,43,91,52,97,51,14
        dd 70,11,33,28,77,73,17,78,39,68,17,57
        dd 91,71,52,38,17,14,91,43,58,50,27,29,48
        dd 63,66,04,68,89,53,67,30,73,16,69,87,40,31
        dd 04,62,98,27,23,09,70,98,73,93,38,53,60,04,23

section .text
    extern printf
    global main

main:
    mov     eax, 105                ;index of first number in last row
    xor     edi, edi                ;column counter
    mov     esi, 14                 ;end of row indicator

pathsum:
    mov     ebx, [tri + 4 * eax]    ;tri @ index in ebx
    inc     eax                     ;next index
    mov     ecx, [tri + 4 * eax]    ;tri @ next index in ecx
    dec     eax                     ;reset eax
    cmp     ebx, ecx                ;compare both numbers
    jg      sum                     ;if ebx > ecx replace
    xchg    ebx, ecx                ;else exchange ebx and ecx

sum:
    sub     eax, esi                ;go to number above
    add     [tri + 4 * eax], ebx    ;add greater number
    cmp     eax, 0                  ;check if finished
    je      print                   ;if yes, print result
    add     eax, esi                ;next position
    inc     eax
    inc     edi                     ;increase column index
    cmp     edi, esi                ;check if end of row is reached
    jl      pathsum                 ;if not, continue

reset:
    xor     edi, edi                ;reset column index
    sub     eax, esi                ;go to previous row
    sub     eax, esi                ;go to first of row
    dec     esi                     ;decrease end of row indicator
    jmp     pathsum                 ;back to pathsum

print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, [tri]
    call    printf
    pop     rbp

exit:                   ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack ;just for gcc
