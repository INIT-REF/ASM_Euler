section .data
    msg db "%d", 10, 0  ;return string for printf (just the result)
    limit equ 100000
section .bss
    nums resd limit ;array of numbers
    sums resd limit ;array of sums

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
    cmp     eax, limit
    jl      setnums
    xor     ecx, ecx                ;reset ecx
    mov     esi, 1000000            ;1e6 in esi

sum_outer:
    mov     ebx, [nums + 4 * ecx]   ;nums[eax] in ebx

sum_inner:
    mov     edx, ebx                ;copy ebx to edx
    sub     edx, [nums + 4 * ecx]   ;subtract nums[ecx]
    mov     edi, [sums + 4 * edx]   ;move sums[edx] in edi
    mov     eax, [sums + 4 * ebx]
    add     eax, edi                ;add to sums[ebx]
    xor     edx, edx
    div     esi
    mov     [nums + 4 * ebx], edx
    inc     ebx                     ;inc inner loop index
    cmp     ebx, limit              ;end of sums array?
    jl      sum_inner               ;if lower, continue inner loop
    inc     ecx                     ;else increase outer loop index
    cmp     ecx, limit              ;end of nums array?
    jl      sum_outer               ;if lower, start over with outer loop
    xor     ebx, ebx
    jmp     print

result:
    inc     ebx
    mov     eax, [sums + 4 * ebx]
    xor     edx, edx
    div     esi
    test    edx, edx
    jnz     result
    

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
