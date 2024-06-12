format ELF64 executable 9

segment readable writable
    result: times 17 db 0                   ;string for printing the result
                     db 10, 0
    string db 1,2,3,4,5,6,7,8,9,10          ;string for permutations
    s2r db 0,5,6,1,6,7,2,7,8,3,8,9,4,9,5    ;ngon position map

segment readable executable
    entry start

start:
    mov     eax, 1                  ;permutation index

next_permutation:
    inc     eax
    mov     edi, 9

get_pivot:                          ;find first number > right neighbur
    dec     edi
    mov     bl, [string + edi]
    cmp     bl, [string + edi + 1]
    jg      get_pivot
    mov     esi, 10

get_larger:                         ;find first numer > pivot
    dec     esi
    mov     cl, [string + esi]
    cmp     cl, bl
    jl      get_larger
    mov     [string + edi], cl      ;swap both
    mov     [string + esi], bl
    inc     edi
    mov     esi, 9

reverse:                            ;reverse substring after pivot
    mov     bl, [string + edi]
    mov     cl, [string + esi]
    mov     [string + edi], cl
    mov     [string + esi], bl
    inc     edi
    dec     esi
    cmp     edi, esi
    jl      reverse
    cmp     [string], 7             ;is lowest number in outer ring 7?
    je      finished                ;if yes, we are finished

    mov     r8b, [string]           ;sum of first "line"
    add     r8b, [string + 5]
    add     r8b, [string + 6]
    mov     edi, 3

test_ngon:                          ;sum of all other lines the same?
    mov     bl, [s2r + edi]
    mov     r9b, [string + ebx]
    inc     edi
    mov     bl, [s2r + edi]
    add     r9b, [string + ebx]
    inc     edi
    mov     bl, [s2r + edi]
    add     r9b, [string + ebx]
    cmp     r8b, r9b
    jne     next_permutation        ;if not, try next permutation
    inc     edi
    cmp     edi, 14
    jl      test_ngon
    xor     edi, edi                ;if yes, put current perm in result
    xor     esi, esi

set_result:
    mov     bl, [s2r + edi]
    mov     cl, [string + ebx]
    cmp     cl, 10
    je      set_10
    mov     [result + esi], cl
    inc     esi
    inc     edi
    cmp     esi, 16
    jl      set_result
    jmp     next_permutation

set_10:
    mov     byte [result + esi], 1
    inc     esi
    mov     byte [result + esi], 0
    inc     esi
    inc     edi
    cmp     esi, 16
    jl      set_result
    jmp     next_permutation

finished:                           ;convert result to string and print
    xor     edi, edi

convert_result:
    add     byte [result + edi], '0'
    inc     edi
    cmp     edi, 16
    jl      convert_result
    
print:
    mov     eax, 4
    mov     edi, 1
    mov     esi, result
    mov     edx, 18
    syscall

exit:
    mov     eax, 1
    xor     edi, edi
    syscall
