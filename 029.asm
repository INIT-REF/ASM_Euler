section .data
    msg db "%d", 10, 0              ;return string for printf (just the result)

section .text
    extern printf
    global main

main:
    xor     ecx, ecx        ;sum of duplicates
    mov     esi, 9801       ;99^2 (all terms incl. duplicates)
    mov     eax, 1          ;first base - 1

nextbase:
    inc     eax
    cmp     eax, 11
    je      result
    mov     r9d, eax        ;copy base
    mov     edi, 1          ;power

powers:
    mul     r9d             ;next power
    cmp     eax, 100        ;result > 100
    jg      finished        ;if yes, finished with current base
    inc     edi             ;else increase power
    push    rax             ;current result on the stack
    mov     eax, 100        ;100 in eax for division
    div     edi             ;divide by power (gives duplicates + 1)
    dec     eax             ;result - 1
    add     ecx, eax        ;add to total
    pop     rax             ;back from the stack
    jmp     powers          ;and continue with next power

finished:
    mov     eax, r9d        ;reset base
    jmp     nextbase        ;jump to nextbase

result:
    dec     ecx             ;subtract 1 from total, need to find out why
    sub     esi, ecx        ;subtract total from all terms

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
