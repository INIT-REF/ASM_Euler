section .data
    msg db "%d", 10, 0          ;return string for printf (just the result)
    cache times 1000000 dd 0    ;cache for already computed chain lengths

section .text
    extern printf
    global main

main:
    mov     ebx, 1          ;starting number
    xor     r9d, r9d        ;max length
    xor     r10d, r10d      ;number with max length

collatz:
    inc     ebx             ;next number
    cmp     ebx, 1000000    ;check if we reached 1000000
    je      print           ;if yes, print result
    mov     rax, rbx        ;copy number to rax
    xor     r8d, r8d        ;reset chain length
    call    even            ;compute the sequence
    jmp     collatz         ;repeat

even:
    cmp     rax, 1000000            ;check if current number < 1000000
    jge     continue                ;if not, jump to continue
    mov     edi, [cache + 4 * eax]  ;if yes, check cache @ current number
    test    edi, edi
    jnz     updatemax               ;if > 0 break and jump to updatemax

continue:
    test    eax, 1      ;check if curent number is odd
    jnz     odd         ;if yes, jump to odd
    shr     rax, 1      ;else half
    inc     r8d         ;increase chain legth
    jmp     even        ;back

odd:
    cmp     rax, 1      ;check if we reached 1
    je      updatemax   ;if yes, jump to updatemax
    mov     rcx, rax    ;compute 3 * n + 1
    shl     rax, 1
    add     rax, rcx
    inc     rax
    inc     r8d         ;increase chain length
    jmp     even        ;back to even

updatemax:
    add     r8d, [cache + 4 * eax]  ;add cache @ current number to length
    mov     [cache + 4 * ebx], r8d  ;update cache
    cmp     r8d, r9d                ;check if current length > max
    cmovg     r9d, r8d                ;if yes update max length
    cmovg     r10d, ebx               ;update number of max length
    ret

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, r10d
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
