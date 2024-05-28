format ELF64 executable 9

segment readable writable
    result: times 10 db 0           ;empty string for printing the result later
                     db 10, 0
    chain: rd 60
    fact: dd 1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880

segment readable executable
    entry start

start:
    xor     edi, edi                ;init n
    xor     esi, esi                ;result
    mov     ecx, 10                 ;for divisions
    xor     r9d, r9d

nextn:
    inc     edi                     ;next n
    cmp     edi, 1000000            
    je      finished
    xor     ebx, ebx                ;chain index

clearchain:
    mov     dword [chain + 4 * ebx], 0
    inc     ebx
    cmp     ebx, 60
    jl      clearchain
    xor     ebx, ebx

    mov     [chain], edi            ;starting number in chain[0]
    mov     eax, edi                ;n in eax for divisions
    xor     r8d, r8d                ;for digit factorial sum

digitfact:
    xor     edx, edx                ;reset remainder
    div     ecx                     ;divide by 10
    add     r8d, [fact + 4 * edx]   ;add factorial of digit to sum
    test    eax, eax                ;repeat until eax is 0
    jnz     digitfact
    
findduplicates:
    cmp     [chain + 4 * ebx], r8d      ;number in chain?
    je      nextn                       ;if yes, try next n
    inc     ebx                         ;next index
    cmp     ebx, 59                     ;end of chain reached?
    je      noduplicates                ;if yes, jump to noduplicates
    cmp     dword [chain + 4 * ebx], 0  ;chain[ebx] = 0?
    jne     findduplicates              ;if not, repeat
    mov     [chain + 4 * ebx], r8d      ;else put sum in chain
    xor     ebx, ebx                    ;reset ebx
    mov     eax, r8d                    ;replace eax with sum
    xor     r8d, r8d                    ;reset sum
    jmp     digitfact                   ;and repeat with digit factorial sum

noduplicates:
    inc     esi                         ;increase counter
    jmp     nextn                       ;and try next n


finished:
    mov     eax, esi
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
