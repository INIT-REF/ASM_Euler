section .data
    msg db "%d", 10, 0  ;return string for printf (just the result)

section .bss
    nums resd 99
    sums resd 101 ;array of sums, result will be in sums[100]

section .text
    extern printf
    global main

main:
    mov     dword [sums], 1         ;set sums[0] to 1
    xor     eax, eax                ;nums index

setnums:
    lea     ebx, [eax + 1]          ;set nums[i] = i+1
    mov     [nums + 4 * eax], ebx
    inc     eax
    cmp     eax, 99
    jl      setnums
    xor     eax, eax                ;reset eax

sum_outer:
    mov     ebx, [nums + 4 * eax]   ;nums[eax] in ebx

sum_inner:
    mov     edx, ebx                ;copy ebx to edx
    sub     edx, [nums + 4 * eax]   ;subtract nums[eax]
    mov     edi, [sums + 4 * edx]   ;move result in edi
    add     [sums + 4 * ebx], edi   ;add to sums[ebx]
    inc     ebx                     ;inc inner loop index
    cmp     ebx, 100                ;end of sums array?
    jle     sum_inner               ;if lower, continue inner loop
    inc     eax                     ;else increase outer loop index
    cmp     eax, 99                 ;end of nums array?
    jl      sum_outer               ;if lower, start over with outer loop
    

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     dword esi, [sums + 4 * 100]
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
