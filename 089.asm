format ELF64 executable 9

segment readable
    f: db "0089_roman.txt", 0               ;file name
    optl: db 0, 1, 2, 3, 2, 1, 2, 3, 4, 2   ;optimal length of 1-9/10-90/100-900
    val: times 67 dd 0                      ;value of numerals
                  dd 100, 500, 0, 0, 0, 0, 1, 0, 0, 50, 1000, 0, 0, 0, 0, 0
                  dd 0, 0, 0, 5, 0, 10

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0
    buf: rb 10000               ;buffer
    nums: rd 1000               ;array for the numbers in int form
    curr: rb 16                 ;buffer for current number

segment readable executable
    entry start

start:
    mov     eax, 5      ;file open
    mov     edi, f      ;file name
    mov     esi, 0      ;read only
    syscall
    mov     edi, eax    ;file descriptor
    mov     eax, 3      ;read
    mov     esi, buf    ;into buffer
    mov     edx, 10000  ;10000 bytes
    syscall    
    mov     edi, eax    ;file descriptor
    mov     eax, 6      ;close
    syscall

    xor     edi, edi    ;index in buf
    xor     ecx, ecx    ;saved chars (result)
    mov     r8d, 10     ;for /mod 10
    mov     r10d, 1000  ;for /mod 1000
    xor     r9d, r9d    ;index in nums

readnext:
    cmp     r9d, 1000               ;1000 numbers done?
    je      finished                ;if yes, we are finished
    xor     rax, rax                ;clear curr
    mov     [curr], rax
    mov     [curr + 8], rax
    xor     esi, esi                ;reset index for curr

readloop:
    mov     al, [buf + edi]         ;get char
    mov     [curr + esi], al        ;put it in curr
    inc     edi                     ;increase indices
    inc     esi
    cmp     byte [buf + edi], 67    ;is char >= 'C'?
    jge     readloop                ;if yes, repeat
    inc     edi                     ;else skip that
    push    rsi                     ;length on the stack for sub later
    xor     ebx, ebx                ;for previous value

getnum:
    dec     esi
    mov     al, [curr + esi]        ;char in al
    mov     eax, [val + 4 * eax]    ;convert to int value
    cmp     eax, ebx                ;is value < last value
    jl      subtract                ;if yes, subtract it
    add     [nums + 4 * r9d], eax   ;else add it
    jmp     nextval

subtract:
    sub     [nums + 4 * r9d], eax

nextval:
    mov     ebx, eax                ;update last value
    xor     eax, eax                ;clear eax
    test    esi, esi                ;repeat if index > 0
    jnz     getnum
    mov     eax, [nums + 4 * r9d]   ;current number in eax
    xor     ebx, ebx                ;for opt length
    xor     edx, edx                ;get 1000s
    div     r10d
    mov     ebx, eax
    mov     eax, edx

getopt:
    xor     edx, edx                ;reset remainder and divide by 10
    div     r8d
    add     bl, [optl + edx]        ;add optimal length to total
    test    eax, eax                ;number reduced to 0?
    jnz     getopt                  ;if not repeat
    pop     rsi                     ;get original length from the stack
    sub     esi, ebx                ;subtract optimal length
    add     ecx, esi                ;add diff to result
    inc     r9d                     ;increase nums index
    jmp     readnext                ;and read next number

finished:
    mov     eax, ecx
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
