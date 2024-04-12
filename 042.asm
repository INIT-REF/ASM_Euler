section .data
    msg db "%d", 10, 0              ;return string for printf (just the result)
    file db "0042_words.txt", 0
    tri times 25 dd 0

section .bss
    buf resb 17000      ;buffer for file contents

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
    mov     edx, 17000  ;17000 bytes
    syscall
    
    mov     edi, eax    ;file descriptor
    mov     eax, 6      ;close
    syscall

    xor     eax, eax    ;nth triangle number
    mov     ebx, 1      ;next integer
    mov     edi, 0      ;array counter
    xor     ecx, ecx    ;count

tris:
    add     eax, ebx                    ;next triangle number
    mov     dword [tri + 4 * edi], eax  ;in tri[edi]
    inc     ebx                         ;next integer
    inc     edi                         ;next index
    cmp     edi, 25                     ;end of array?
    jl      tris                        ;if not, repeat

    mov     edi, 1      ;beginning of first word in buf
    xor     eax, eax    ;word value
    xor     ebx, ebx    ;char value
    jmp     getvalue    ;jump to getvalue for first word

next:
    add     edi, 1      ;increase edi to start of next word
    xor     eax, eax    ;clear eax

getvalue:
    mov     bl, [buf + edi]         ;char @ edi in bl
    sub     bl, 64                  ;subtract 64 for the int value
    add     eax, ebx                ;add to word value
    inc     edi                     ;next char
    cmp     byte [buf + edi], '"'   ;is next char '"'?
    jl      print                   ;if lower, we have EOF
    jne     getvalue                ;if not equal, repeat
    xor     esi, esi                ;if equal, reset esi

tritest:
    cmp     dword eax, [tri + 4 * esi]  ;is eax tri[esi]?
    je      istri                       ;if yes, jump to istri
    inc     esi                         ;else increase esi
    cmp     esi, 25                     ;end of tri array?
    jl      tritest                     ;if not, repeat
    jmp     next                        ;else go to next word

istri:
    inc     ecx     ;increase count
    jmp     next    ;go to next word

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
