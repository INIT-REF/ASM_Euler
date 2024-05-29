format ELF64 executable 9

segment readable writable
    result: times 15 db 0       ;empty string for printing the result later
                     db 10, 0
    hashes: rq 10000            ;for 10000 hashes
    dig: rb 10                  ;for counting digits of a cube
    count: rb 10000             ;for the count of a given hash

segment readable executable
    entry start

start:
    mov     rdi, 1          ;init n
    mov     rsi, 10         ;for divisions

nextn:
    inc     rdi             ;next n
    cmp     rdi, 10000      ;limit reached?
    je      getresult       ;if yes, we are finished
    mov     rax, rdi        ;else move base in rax
    mul     rdi             ;square
    mul     rdi             ;cube
    xor     rbx, rbx        ;reset rbx

resetdig:
    mov     byte [dig + rbx], 0 ;reset dig[rbx]
    inc     rbx                 ;increase index
    cmp     rbx, 10             ;end of dig?
    jl      resetdig            ;if not, repeat

getdigits:
    xor     rdx, rdx            ;reset remainder
    div     rsi                 ;divide by 10
    inc     byte [dig + rdx]    ;increase dig[remainder]
    test    rax, rax            ;cube reduced to 0?
    jnz     getdigits           ;if not, repeat
    mov     rbx, 9              ;init digit index
    xor     rax, rax            ;reset rax for hash
    xor     rcx, rcx            ;reset rcx

gethash:
    mov     cl, [dig + rbx]     ;digit count in cl
    cmp     rcx, 0              ;is it 0?
    jne     buildup             ;if yes, build hash
    dec     rbx                 ;else decrease rbx
    cmp     rbx, 0              ;is it >= 0?    
    jge     gethash             ;if yes, repeat
    xor     rbx, rbx            ;else reset rbx
    jmp     scanhashes          ;and jump to scanhashes

buildup:
    mul     rsi
    add     rax, rbx            ;else add digit to hash
    dec     rcx                 ;decrease digit count @rbx
    test    rcx, rcx            ;count reduced to 0?
    jnz     buildup             ;if not repeat
    dec     rbx                 ;if yes, decrease rbx
    jmp     gethash             ;and continue

scanhashes:
    inc     rbx                             ;next base
    cmp     rbx, 10000                      ;end of hashes?
    je      newhash                         ;if yes, set new hash in hashes
    cmp     qword [hashes + 8 * rbx], rax   ;hash already in hashes[rbx]?
    jne     scanhashes                      ;if not, repeat
    inc     byte [count + rbx]              ;else increase count for that hash
    jmp     nextn                           ;and jump to nextn

newhash:
    mov     [hashes + 8 * rdi], rax     ;current hash in hashes[edi]
    mov     byte [count + rdi], 1       ;set count for current hash to 1
    jmp     nextn                       ;continue with next n

getresult:
    xor     rax, rax                    ;reset rax

nextcount:
    inc     rax                         ;next base
    cmp     byte [count + rax], 5       ;count for that base = 5?
    jne     nextcount                   ;if not, repeat
    mov     rdi, rax
    mul     rdi
    mul     rdi

finished:
    mov     ebx, 10     ;convert result to string, print and exit
    mov     ecx, 14    

convert_result:
    xor     rdx, rdx
    div     rbx
    add     rdx, '0'
    mov     [result + ecx], dl
    dec     ecx
    test    rax, rax
    jnz     convert_result

print:
    mov     eax, 4
    mov     edi, 1
    mov     esi, result
    mov     edx, 17
    syscall

exit:
    mov     rax, 1
    xor     rdi, rdi
    syscall
