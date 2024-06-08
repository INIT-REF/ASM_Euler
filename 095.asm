format ELF64 executable 9

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0
    
    divsum: rd 1000000
    chain:  rd 101     

segment readable executable
    entry start

start:
    xor     edi, edi                ;index for outer loop

divsum_outer:
    inc     edi                     ;next index
    cmp     edi, 500000             ;index > limit / 2?
    jg      reset                   ;if yes, sieve is finished
    mov     esi, edi                ;inner index = outer index * 2
    shl     esi, 1

divsum_inner:
    add     [divsum + 4 * esi], edi ;add outer index to divsum[inner index]
    add     esi, edi
    cmp     esi, 1000000            ;limit reached?
    jl      divsum_inner            ;if not, repeat
    jmp     divsum_outer            ;else jump to outer loop

reset:
    xor     eax, eax                ;starting number
    xor     r8d, r8d                ;result
    xor     r9d, r9d                ;max chain length

next:
    inc     eax
    cmp     eax, 1000000            ;limit reached?
    jg      finished                ;if yes, we are finished
    mov     ecx, eax                ;copy
    xor     ebx, ebx                ;reset chain length
    mov     esi, 1000000            ;smallest member
    mov     edi, 100

build_chain:
    inc     ebx                     ;increase chain length
    mov     ecx, [divsum + 4 * ecx] ;continue chain
    cmp     ecx, 1000000            ;divsum > limit?
    jg      next                    ;if yes, try next starter
    cmp     ecx, esi                ;new smallest member?
    cmovl   esi, ecx                ;if yes, update esi
    cmp     ecx, eax                ;closed chain?
    jne     build_chain             ;if not, repeat
    jl      next
    cmp     ebx, r8d                ;new max length?
    cmovg   r9d, ebx                ;if yes, update r8d
    cmovg   r8d, esi                ;and esi
    jmp     next                    ;and use next starter

finished:
    mov     eax, r8d
    mov     ebx, 10
    mov     ecx, 9

convert_result:
    xor     edx, edx
    div     ebx
    add     edx, '0'
    mov     [result + ecx], dl
    dec     ecx
    test    eax, eax
    jnz     convert_result

print:
    mov     eax, 4
    mov     edi, 1
    mov     esi, result
    mov     edx, 12
    syscall

exit:
    mov     eax, 1
    xor     edi, edi
    syscall
