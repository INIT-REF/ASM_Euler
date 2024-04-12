section .data
    msg db "%d", 10, 0          ;return string for printf (just the result)
    abc times 10 db 0           ;digits in number
    pds db "123456789", 1       ;pandigital string

section .text
    extern printf
    global main

main:
    mov     ebx, 1      ;init multiplicand
    xor     r10d, r10d  ;max
    mov     r11d, 10    ;for divisions

next:
    inc     ebx         ;next number
    cmp     ebx, 10000  ;number >= 10000
    jge     print       ;if yes, we are finished
    mov     ecx, 1      ;init n
    mov     esi, ebx    ;number in esi (number * 1)

multiply:
    inc     ecx         ;next n
    cmp     ecx, 10     ;is n = 10?
    je      next        ;if yes, try next number
    mov     eax, ebx    ;number in eax
    mul     ecx         ;multiply by n
    mov     edi, 1      ;1 in edi

combine:
    imul    edi, 10         ;multiply edi by 10
    imul    esi, 10         ;multiply esi by 10
    cmp     edi, eax        ;until edi is > eax
    jl      combine
    add     esi, eax        ;add eax to esi
    cmp     esi, 987654321  ;result > 987654321?
    jg      next            ;if yes, try next number
    push    rsi             ;else push result on the stack
    mov     eax, esi        ;put result in eax
    call    digits          ;get the digits in abc string
    xor     esi, esi        ;reset counter
    call    cmpstr          ;compare abc with pds
    cmp     esi, 10         ;if esi = 10, number is pandigital
    pop     rsi             ;get number back from the stack
    jne     multiply        ;if esi != 10, continue with multiplication

updatemax:
    cmp     esi, r10d       ;if esi = 10, update max
    cmovg   r10d, esi
    jmp     next

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

digits:
    xor     esi, esi                ;reset esi, array index
    
resetabc:
    mov     byte [abc + esi], 0     ;reset abc[esi] to 0
    inc     esi                     ;next index
    cmp     esi, 9                  ;end of abc?
    jl      resetabc                ;if not, continue

convert:
    xor     edx, edx                    ;reset remainder
    div     r11d                        ;divide by 10
    mov     [abc + edx - 1], dl         ;put digit in abc string
    add     byte [abc + edx - 1], '0'   ;add '0' to get the ASCII char
    test    eax, eax                    ;number reduced to 0?
    jnz     convert                     ;if not, continue
    ret

cmpstr:
    mov     r8b, [abc + esi]    ;char @ abc[eax]
    mov     r9b, [pds + esi]    ;char @ pds[eax]
    inc     esi                 ;next char
    cmp     r8b, r9b            ;both characters match?
    je      cmpstr              ;if yes, continue

back:
    ret

section .note.GNU-stack     ;just for gcc
