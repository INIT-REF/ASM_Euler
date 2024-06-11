format ELF64 executable 9
    
segment readable
    limit equ 1000000           ;limit

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0
    phi: rd limit               ;for phi(n)

segment readable executable
    entry start

start:
    xor     edi, edi                ;init n

init_phi:
    inc     edi                     ;next n
    mov     [phi + 4 * edi], edi    ;phi[n] = n
    cmp     edi, limit              ;limit reached?
    jl      init_phi                ;if not, repeat
    mov     edi, 1                  ;index for outer loop

phi_outer:
    inc     edi                     ;next index outer loop
    cmp     edi, limit              ;limit reached?
    je      reset                   ;if yes, jump to reset
    cmp     [phi + 4 * edi], edi    ;phi[edi] = edi?
    jne     phi_outer               ;if not, repeat
    mov     esi, edi                ;init inner index

phi_inner:
    mov     eax, [phi + 4 * esi]    ;eax = phi[esi]
    xor     edx, edx                ;reset remainder
    div     edi                     ;eax = phi[esi] / edi
    sub     [phi + 4 * esi], eax    ;phi[esi] -= eax
    add     esi, edi                ;next
    cmp     esi, limit              ;limit reached?
    jl      phi_inner               ;if not, repeat
    jmp     phi_outer               ;else continue with outer loop


reset:
    mov     edi, 1                  ;init n
    xor     ebx, ebx                ;n with max n/phi(n) ratio
    xor     rcx, rcx                ;max n/phi(n) ratio

nextn:
    inc     edi                     ;next n
    mov     eax, edi                ;copy in eax
    shl     eax, 10                 ;multiply by 1024 to get more accuracy
    mov     esi, [phi + 4 * edi]    ;phi(n) in esi
    xor     rdx, rdx
    div     rsi                     ;get ratio
    cmp     rcx, rax                ;max < ratio?
    cmovl   rcx, rax                ;if yes, update max
    cmovl   ebx, edi                ;and max n
    cmp     edi, limit              ;continue until limit is reached
    jl      nextn

finished:
    mov     eax, ebx                ;convert result to string, print and exit
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
    mov     rax, 1
    xor     rdi, rdi
    syscall
