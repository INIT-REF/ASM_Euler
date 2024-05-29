format ELF64 executable 9

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0
    chains: rb 71               ;578 bits for "89 flags"

segment readable executable
    entry start

start:
    xor     edi, edi        ;init n
    mov     esi, 10         ;for divisions
    xor     ebx, ebx        ;result

first567:
    inc     edi             ;next n
    cmp     edi, 567        ;n > 567?  
    jg      next            ;if yes jump to next
    mov     eax, edi        ;number in eax for dss

getchains:
    xor     ecx, ecx        ;for the digit-square-sums
    call    dss
    mov     eax, ecx        ;sum back in eax
    cmp     eax, 1          ;is it 1?
    je      first567        ;if yes, try next number
    cmp     eax, 89         ;is it 89?
    jne     getchains       ;if not, continue chain
    inc     ebx             ;if yes, increase count
    bts     [chains], edi   ;set chains[n] to 1
    jmp     first567        ;and try next number

next:
    cmp     edi, 10000000   ;limit reached
    je      finished        ;if yes, we are finished
    xor     ecx, ecx        ;reset digit-square-sum
    mov     eax, edi        ;number in eax for dss
    call    dss             ;get dss of n
    inc     edi             ;and increase n
    bt      [chains], ecx   ;is it a "89 chain"?
    jnc     next            ;if not, try next number
    inc     ebx             ;else increase count
    jmp     next            ;and try next number

dss:
    xor     edx, edx        ;reset remainder
    div     esi             ;divide by 10
    imul    edx, edx        ;square remainder
    add     ecx, edx        ;add to sum
    test    eax, eax        ;repeat until eax is 0
    jnz     dss
    ret

finished:
    mov     eax, ebx
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
