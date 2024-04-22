section .data
    msg db "%lld", 10, 0              ;return string for printf (just the result)
    num dd 1, 0, 2, 3, 4, 5, 6, 7, 8, 9 ;first perutation
    divs dd 2, 3, 5, 7, 11, 13, 17      ;divisors
   
section .text
    extern printf
    global main

main:
    xor     esi, esi            ;setup some registers
    xor     rcx, rcx
    
reset:
    xor     rax, rax
    xor     edi, edi
    call    convert             ;convert current permutation to actual number
    mov     rbx, 9876543210     ;last permutation reached?
    cmp     rax, rbx
    jge     print               ;if yes, print result
    xor     rax, rax            ;else reset some registers
    xor     rbx, rbx
    mov     edi, 1
    xor     esi, esi

divisortest: 
    mov     eax, [num + 4 * edi]    ;extract the three-digit number
    imul    eax, 10
    inc     edi
    add     eax, [num + 4 * edi]
    imul    eax, 10
    inc     edi
    add     eax, [num + 4 * edi]
    mov     ebx, [divs + 4 * esi]
    xor     edx, edx                ;reset remainder
    div     ebx                     ;divide by divs @ esi
    test    edx, edx                ;check remainder
    jnz     nextperm                ;if not zero, try next permuation
    dec     edi                     ;else setup for next test
    inc     esi
    cmp     esi, 7                  ;last divisor reached?
    je      addnum                  ;if yes, add current permutation to result
    jmp     divisortest             ;else continue divisor test

addnum:
    xor     edi, edi    ;prepare registers for conversion
    xor     rax, rax
    call    convert     ;call convert function
    add     rcx, rax    ;add permutation to result

nextperm:
    mov     edi, 9      ;set up registers for next permutation
    mov     esi, 10
    xor     rax, rax
    xor     rbx, rbx

findpivot:                          ;find the "pivot"
    dec     edi
    mov     eax, [num + 4 * edi]
    inc     edi
    mov     ebx, [num + 4 * edi]
    dec     edi
    cmp     eax, ebx
    jg      findpivot

findceil:                           ;find the "ceiling"
    dec     esi
    mov     eax, [num + 4 * esi]
    cmp     eax, [num + 4 * edi]
    jl      findceil

swap:                               ;swap pivot and ceiling
    mov     ebx, [num + 4 * edi]
    mov     [num + 4 * edi], eax
    mov     [num + 4 * esi], ebx
    inc     edi
    mov     esi, 9

reverse:                            ;reverse substring after pivot
    cmp     edi, esi
    jge     reset
    mov     eax, [num + 4 * edi]
    mov     ebx, [num + 4 * esi]
    mov     [num + 4 * edi], ebx
    mov     [num + 4 * esi], eax
    inc     edi
    dec     esi
    jmp     reverse

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     rsi, rcx
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

convert:                            ;convert current permutation to number
    imul    rax, 10
    mov     ebx, [num + 4 * edi]
    add     rax, rbx
    inc     edi
    cmp     edi, 10
    jl      convert
    ret

section .note.GNU-stack     ;just for gcc
