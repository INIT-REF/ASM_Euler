section .data
    msg db "%d", 10, 0                  ;return string for printf (just the result)
    ps db 4, 9, 16, 25, 36, 49, 64, 81  ;perfect squares below 100 (sans 1)
    
section .bss
    a resb 110  ;"Bigint" array for a
    b resb 110  ;dito for b

section .text
    extern printf
    global main

main:
    mov     ecx, 1              ;init n
    xor     r8d, r8d            ;index for perfect squares array
    xor     r9d, r9d            ;result

nextn:
    inc     ecx                 ;next n
    cmp     ecx, 100            ;finished?
    je      print               ;if yes, print result
    cmp     byte cl, [ps + r8d] ;is current n a perfrect square?
    jne     continue            ;if not, jump to continue
    inc     r8d                 ;if yes get index of next perfect square
    jmp     nextn               ;and increase n

continue:
    xor     edi, edi            ;reset edi

clear:
    mov     byte [a + edi], 0   ;init a and b to all zeros
    mov     byte [b + edi], 0
    inc     edi
    cmp     edi, 110
    jl      clear

    mov     eax, ecx            ;set initial state (a = 5 * n, b = 5)
    imul    eax, 5
    mov     ebx, 10
    xor     edx, edx
    div     ebx
    mov     [a + 108], al
    mov     [a + 109], dl
    mov     byte [b + 109], 5

getroot:
    xor     edi, edi            ;reset registers
    xor     eax, eax
    xor     ebx, ebx
    cmp     byte [b + 1], 0     ;required precision reached?
    jne     getsum              ;if yes, get digit sum

findgreater:
    inc     edi                 ;is a > b?
    mov     al, [a + edi]
    mov     bl, [b + edi]
    cmp     eax, ebx
    jg      ag                  ;if yes, go to ag
    jl      bg                  ;else to bg
    jmp     findgreater

ag:
    mov     edi, 109    
    xor     esi, esi
 
aa:
    mov     al, [a + edi]       ;calculate a - b
    mov     bl, [b + edi]
    add     ebx, esi
    xor     esi, esi
    cmp     eax, ebx
    jge     minus
    add     eax, 10
    mov     esi, 1

minus:
    sub     eax, ebx
    mov     [a + edi], al
    dec     edi
    test    edi, edi
    jnz     aa
    mov     edi, 108
 
ab:
    cmp     byte [b + edi], 9   ;add 10 to b
    jl      incdigit
    mov     byte [b + edi], 0
    dec     edi
    jmp     ab
    
incdigit:
    inc     byte [b + edi]
    jmp     getroot             ;and back to a <> b check
    
bg:
    mov     edi, 2
    xor     esi, esi

ba:
    mov     al, [a + edi]       ;append two zeros to a
    mov     [a + esi], al
    inc     edi
    inc     esi
    cmp     edi, 110
    jl      ba
    mov     byte [a + 108], 0
    mov     byte [a + 109], 0
    mov     edi, 1
    xor     esi, esi

bb:
    mov     bl, [b + edi]       ;insert a 0 into b before the last digit
    mov     [b + esi], bl
    inc     edi
    inc     esi
    cmp     edi, 109
    jl      bb
    mov     byte [b + 108], 0
    jmp     getroot

getsum:
    mov     edi, 1              ;reset registers
    xor     esi, esi
    xor     r10d, r10d          ;digit sum

sumloop:
    mov     bl, [b + edi]       ;get sum of digits and add to result
    add     r10d, ebx
    inc     edi
    inc     esi
    cmp     esi, 100
    jl      sumloop
    add     r9d, r10d
    jmp     nextn               ;calculate next root

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, r9d
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
