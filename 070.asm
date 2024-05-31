format ELF64 executable 9
    
segment readable
    limit equ 10000000          ;limit
    mult equ 10000000           ;multiplier for ratios
    max dq  100000000000000     ;init max

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0
    phi: rd limit               ;for phi(n)
    dign: rb 10                 ;for digits in n
    digp: rb 10                 ;for digits in phi(n)

segment readable executable
    entry start

start:
    xor     edi, edi                ;init n
    xor     r8d, r8d                ;n with minimal n/phi ratio
    mov     r9, [max]               ;minimal n/phi ratio

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
    
nextn:
    inc     edi                     ;next n
    cmp     edi, limit              ;limit reached?
    je      finished                ;if yes, we are finished
    xor     rax, rax                ;clear dign and digp
    mov     [dign], rax
    mov     [dign + 2], rax
    mov     [digp], rax
    mov     [digp + 2], rax
    mov     eax, edi                ;get digits of n and phi(n)
    mov     ecx, dign
    mov     esi, 10
    call    getdigits
    mov     eax, [phi + 4 * edi]
    mov     ecx, digp
    call    getdigits
    mov     rax, [dign]             ;compare first 8 bytes of dign and digp
    cmp     rax, [digp]
    jne     nextn                   ;if not equal, try next number
    mov     rax, [dign + 2]         ;compare last 8 bytes of dign and digp
    cmp     rax, [digp + 2]
    jne     nextn                   ;if not equal, try next number
    mov     rax, rdi                ;get ratio
    xor     rbx, rbx
    mov     ebx, [phi + 4 * edi]
    imul    rax, mult
    xor     rdx, rdx
    div     rbx                     ;n/phi(n)
    cmp     rax, r9                 ;lower than current min?
    cmovl   r9, rax                 ;if yes, replace r9 and r8d
    cmovl   r8d, edi
    jmp     nextn                   ;and jump to nextn

getdigits:
    xor     edx, edx            ;reset remainder
    div     esi                 ;divide eax by 10
    lea     ebx, [ecx + edx]    ;pointer to dign/digp[digit]
    inc     byte [ebx]          ;increase digit count
    test    eax, eax            ;number reduced to 0?
    jnz     getdigits           ;if not, repeat
    ret
    
finished:
    mov     eax, r8d            ;convert result to string, print and exit
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
