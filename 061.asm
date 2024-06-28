section .data
    msg db "%d", 10, 0              ;return string for printf (just the result)

section .bss
    nums resb 10000                 ;for bit flags
    first resb 10000                ;for first two digits
    last resb 10000                 ;for last two digits
    nset resd 6                     ;for sets
    
    
section .text
    extern printf
    global main

main:
    mov     edi, 1
    xor     eax, eax
    xor     ebx, ebx
                                    ;set flags for all figurate numbers
set_tri:
    mov     bl, [nums + eax]
    bts     ebx, 0
    mov     [nums + eax], bl
    add     eax, edi
    inc     edi
    cmp     eax, 10000
    jl      set_tri
    mov     edi, 1
    xor     eax, eax

set_squ:
    mov     bl, [nums + eax]
    bts     ebx, 1
    mov     [nums + eax], bl
    add     eax, edi
    add     edi, 2
    cmp     eax, 10000
    jl      set_squ
    mov     edi, 1
    xor     eax, eax
    
set_pen:
    mov     bl, [nums + eax]
    bts     ebx, 2
    mov     [nums + eax], bl
    add     eax, edi
    add     edi, 3
    cmp     eax, 10000
    jl      set_pen
    mov     edi, 1
    xor     eax, eax

set_hex:
    mov     bl, [nums + eax]
    bts     ebx, 3
    mov     [nums + eax], bl
    add     eax, edi
    add     edi, 4
    cmp     eax, 10000
    jl      set_hex
    mov     edi, 1
    xor     eax, eax

set_hep:
    mov     bl, [nums + eax]
    bts     ebx, 4
    mov     [nums + eax], bl
    add     eax, edi
    add     edi, 5
    cmp     eax, 10000
    jl      set_hep
    mov     edi, 1
    xor     eax, eax

set_oct:
    mov     bl, [nums + eax]
    bts     ebx, 5
    mov     [nums + eax], bl
    add     eax, edi
    add     edi, 6
    cmp     eax, 10000
    jl      set_oct
    mov     edi, 1000
    mov     ebx, 100

get_first_last:                     ;get first/last two digits
    mov     eax, edi
    xor     edx, edx
    div     ebx
    mov     [first + edi], al
    mov     [last + edi], dl
    inc     edi
    cmp     edi, 10000
    jl      get_first_last
    

    xor     eax, eax                ;result
    xor     ebx, ebx                ;for flags
    xor     ecx, ecx                ;dito
    mov     edi, 999                ;init n

next_starter:
    inc     edi
    mov     bl, [nums + edi]
    test    ebx, ebx
    jz      next_starter
    push    rdi                     ;remember starter
    mov     [nset], edi
    mov     r9b, [last + edi]
    mov     esi, 1                  ;index for nset
    mov     edi, 999

next_follower:
    inc     edi
    cmp     edi, 10000
    je      backtrack
    mov     cl, [nums + edi]
    or      ecx, ebx
    cmp     ecx, ebx
    je      next_follower
    cmp     r9b, [first + edi]
    jne     next_follower

backtrack:
    mov     byte [nest + esi], 0
    dec     esi
    mov     eax, edi

print:
    push    rbp
    mov     edi, msg
    mov     esi, eax
    call    printf
    pop     rbp

exit:
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
