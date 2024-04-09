section .data
    msg db "%d", 10, 0          ;return string for printf (just the result)
    abc times 10 db 0           ;digits in a * b = c
    pds db "123456789", 1       ;pandigital string
    products times 9877 db 0    ;flags for valid products

section .text
    extern printf
    global main

main:
    mov     ebx, 1      ;init multiplicand
    mov     edi, 10     ;for divisions

nextA:
    inc     ebx         ;increase multiplicand
    cmp     ebx, 100    ;no need to look further than sqrt(9876)
    je      finished
    mov     ecx, ebx    ;init multiplier (start with a = b)

nextB:
    mov     eax, ebx    ;multiplicand in eax
    inc     ecx         ;next b
    mul     ecx         ;a * b
    cmp     eax, 1234   ;a * b >= 1234?
    jl      nextB       ;if not, try next b
    cmp     eax, 9876   ;a * b > 9876
    jg      nextA       ;if yes, try next a

examine:
    push    rax         ;keep product on the stack
    call    digits      ;digits of product in abc string
    mov     eax, ebx    ;a in eax
    call    convert     ;digits of multiplicand in abc string
    mov     eax, ecx    ;b in eax
    call    convert     ;digits of multiplier in abc string
    xor     esi, esi    ;reset ecx for loop counter
    call    cmpstr      ;compare abc and pds
    pop     rax         ;get multiplier back
    cmp     esi, 10     ;is abc 1-9 pandigital?
    jne     nextB       ;if not, try next b
    mov     byte [products + eax], 1    ;if yes, set product[eax] = 1
    jmp     nextB       ;and try next b

finished:
    mov     eax, 1233   ;reset eax as loop counter
    xor     ebx, ebx    ;sum

sum:
    inc     eax                         ;next product
    cmp     eax, 9877                   ;end of array?
    je      print                       ;then print result
    cmp     byte [products + eax], 1    ;valid product @ products[eax]
    jne     sum                         ;if not, try next number
    add     ebx, eax                    ;else add product to sum
    jmp     sum                         ;and repeat
    
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

digits:
    xor     esi, esi                ;reset esi, array index
    
resetabc:
    mov     byte [abc + esi], 0     ;reset abc[esi] to 0
    inc     esi                     ;next index
    cmp     esi, 9                  ;end of abc?
    jl      resetabc                ;if not, continue

convert:
    xor     edx, edx                    ;reset remainder
    div     edi                         ;divide by 10
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
