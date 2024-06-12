format ELF64 executable 9
    
segment readable
    limit equ 1000000           ;limit

segment readable writable
    result: times 20 db 0       ;empty string for printing the result later
                     db 10, 0
    phi: rd limit               ;for phi(n)

segment readable executable
    entry start

start:
    xor     edi, edi                ;init n
    xor     rcx, rcx                ;result

init_phi:
    inc     edi                     ;next n
    mov     [phi + 4 * edi], edi    ;phi[n] = n
    cmp     edi, limit              ;limit reached?
    jl      init_phi                ;if not, repeat
    mov     edi, 1                  ;index for outer loop

phi_outer:
    inc     edi                     ;next index outer loop
    cmp     edi, limit              ;limit reached?
    jg      finished                ;if yes, we are done
    cmp     [phi + 4 * edi], edi    ;phi[edi] = edi?
    jne     sum                     ;if not, just add phi[edi] to result
    mov     esi, edi                ;init inner index

phi_inner:
    mov     eax, [phi + 4 * esi]    ;eax = phi[esi]
    xor     edx, edx                ;reset remainder
    div     edi                     ;eax = phi[esi] / edi
    sub     [phi + 4 * esi], eax    ;phi[esi] -= eax
    add     esi, edi                ;next
    cmp     esi, limit              ;limit reached?
    jle     phi_inner               ;if not, repeat

sum:
    mov     ebx, [phi + 4 * edi]    ;add phi[edi] to result
    add     rcx, rbx
    jmp     phi_outer               ;continue with outer loop
    
finished:                           ;convert to string, print and exit
    mov     rax, rcx
    mov     ebx, 10
    mov     ecx, 19    

convert_result:
    xor     rdx, rdx
    div     rbx
    add     dl, '0'
    mov     [result + ecx], dl
    dec     ecx
    test    rax, rax
    jnz     convert_result

print:
    mov     eax, 4
    mov     edi, 1
    mov     esi, result
    mov     edx, 22
    syscall

exit:
    mov     eax, 1
    xor     edi, edi
    syscall
