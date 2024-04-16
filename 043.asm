section .data
    msg db "%s", 10, 0              ;return string for printf (just the result)
    string db "1023456789"
    result db "0000000000"
    fac dd 362880, 40320, 5040, 720, 120, 24, 6, 2, 1, 1    ;9! ... 0!
   
section .text
    extern printf
    global main

main:
    xor     eax, eax          ;number of permutation (original is 1st)

next:
    inc     eax
    push    rax
    xor     ebx, ebx          ;index for factorials

permute:
    cmp     ebx, 10                     ;finished?
    je      print
    xor     edx, edx                    ;reset remainder
    mov     dword ecx, [fac + 4 * ebx]  ;ebx!
    div     ecx                         ;divide eax by ebx!
    mov     sil, [string + eax]         ;copy digit @ eax
    mov     [result + ebx], sil         ;move digit to result @ ebx
    inc     ebx                         ;next factorial
    mov     edi, eax                    ;copy index of digit to edi
    mov     eax, edx                    ;remainder = next dividend

updatestring:
    inc     edi                         ;next digit of string
    mov     sil, [string + edi]         ;copy to sil
    dec     edi                         ;decrease index
    mov     [string + edi], sil         ;move digit there
    inc     edi                         ;increase index again
    cmp     edi, 10                     ;finished?
    jl      updatestring                ;if not, repeat
    jmp     permute                     ;else continue with permute
    pop     rax
    mov     edi, 1
    xor     r8d, r8d

getdigits:
    mov     r8b, [result + edi]
    mov     r9b, [result + edi + 1]
    mov     r10b, [result + edi + 2]
    imul    r8d, 100
    imul    r9d, 10
    add     r8d, r9d
    add     r8d, r10d
    ret
      

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, result
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
