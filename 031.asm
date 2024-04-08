section .data
    msg db "%d", 10, 0  ;return string for printf (just the result)
    coins dd 1, 2, 5, 10, 20, 50, 100, 200  ;coin values
    sums times 201 dd 0 ;array of sums, result will be in sums[200]

section .text
    extern printf
    global main

main:
    mov     dword [sums], 1         ;set sums[0] to 1
    xor     eax, eax                ;coins index

sum_outer:
    mov     ebx, [coins + 4 * eax]  ;coins[eax] in ebx

sum_inner:
    mov     edx, ebx                ;copy coins[eax] to edx
    sub     edx, [coins + 4 * eax]  ;subtract coins[eax]
    mov     edi, [sums + 4 * edx]   ;move result in edi
    add     [sums + 4 * ebx], edi   ;add to sums[ebx]
    inc     ebx                     ;inc inner loop index
    cmp     ebx, 200                ;end of sums array?
    jle     sum_inner               ;if lower, continue inner loop
    inc     eax                     ;else increase outer loop index
    cmp     eax, 8                  ;end of coins array?
    jl      sum_outer               ;if lower, start over with outer loop
    

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     dword esi, [sums + 4 * 200]
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
