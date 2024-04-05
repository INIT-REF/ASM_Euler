section .data
    msg db "%lld", 10, 0              ;return string for printf (just the result)
    file db "0022_names.txt", 0
    names times 5163 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

section .bss
    buf resb 46447      ;buffer for file contents

section .text
    extern printf
    global main

main:
    mov     eax, 5      ;file open
    mov     edi, file   ;file name
    mov     esi, 0      ;read only
    syscall

    mov     edi, eax    ;file descriptor
    mov     eax, 3      ;read
    mov     esi, buf    ;into buffer
    mov     edx, 46447  ;46447 bytes
    syscall
    
    mov     edi, eax    ;file descriptor
    mov     eax, 6      ;close
    syscall

    mov     edi, 1      ;beginning of first name in buf
    xor     esi, esi    ;index for names array

parsenames:
    mov     al, [buf + edi]         ;put character of buf @ edi in al
    mov     [names + esi], al       ;put character in names @ esi
    inc     edi                     ;increase indices
    inc     esi
    cmp     byte [buf + edi], '"'   ;check if end of name is reached
    jne     parsenames              ;if not, continue
    mov     eax, esi                ;put current index in eax
    mov     ebx, 20                 ;put 20 (length of partition) in ebx
    xor     edx, edx                ;clear remainder
    div     ebx                     ;divide index by 20
    sub     ebx, edx                ;subtract remainder from 20
    add     esi, ebx                ;set esi to beginning of next partition
    add     edi, 3                  ;add 3 to edi to skip "," between names
    cmp     edi, 46447              ;check if end of file
    jl      parsenames              ;if not, continue
    mov     edi, 103260             ;index for outer bubble sort loop

bsort_outer:
    xor     esi, esi    ;reset inner index
    xor     edx, edx    ;flag for swapped
    mov     eax, edi    ;set up limit for inner loop
    sub     eax, 20
    
bsort_inner:
    mov     r8d, esi    ;copy current index to r8d for compare
    mov     r9d, esi    ;dito for swap
    xor     r10d, r10d  ;counter for compare & swap
    call    compare     ;call compare function
    add     esi, 20     ;next name
    cmp     esi, eax    ;check if can end the loop
    jl      bsort_inner ;if not, continue
    test    edx, edx    ;check if we had a swap in the last loop
    jz      finished    ;if not, we are finished
    cmp     edi, 0      ;check if outer loop is finished
    jg      bsort_outer ;if not, continue
    jmp     finished    ;else we are finished

compare:
    mov     al, [names + r8d]       ;first character of first name
    mov     bl, [names + r8d + 20]  ;first character of second name
    cmp     al, bl                  ;compare
    jl      back                    ;swap names if first > second
    jg      swap_init
    inc     r8d                     ;else check next character
    inc     r10d
    cmp     r10d, 20                 ;until the end of the partition
    jl      compare
    ret

swap_init:
    xor     r10d, r10d

swap:
    mov     edx, 1                  ;set swapped flag
    mov     al, [names + r9d]       ;first character of first name
    mov     bl, [names + r9d + 20]  ;first character of second name
    mov     [names + r9d + 20], al  ;swap characters
    mov     [names + r9d], bl
    inc     r9d                     ;next character
    inc     r10d                    ;increase counter
    cmp     r10d, 20                ;until the end of the partition
    jl      swap
    ret

back:
    ret

finished:
    xor     edi, edi            ;index for characters
    xor     r8d, r8d            ;index for names
    xor     ecx, ecx            ;total

scores:
    xor     eax, eax            ;name score
    xor     esi, esi            ;counter
    inc     r8d

convert:
    cmp     byte [names + edi], 0   ;skip conversion after end of name
    je      skip
    sub     byte [names + edi], 64  ;subtract 64 from character for int value

skip:
    add     al, [names + edi]       ;add int value to sum
    inc     edi                     ;next character
    inc     esi                     ;increase counter
    cmp     esi, 20                 ;check if end of name
    jl      convert                 ;if not, continue
    mul     r8d                     ;multiply by index of name
    add     ecx, eax                ;add score to total
    cmp     edi, 103260             ;check if last name
    jl      scores                  ;if not, continue

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, ecx
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
