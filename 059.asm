section .data
    msg db "%d", 10, 0              ;return string for printf
    file db "0059_cipher.txt", 0    ;file name
    
section .bss
    buf resb 5000       ;buffer for file contents
    cip resb 5000       ;cipher
    key resb 3          ;key

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
    mov     edx, 5000   ;5000 bytes
    syscall    
    mov     edi, eax    ;file descriptor
    mov     eax, 6      ;close
    syscall

    xor     edi, edi    ;array index for buf
    xor     esi, esi    ;array index for cip
    xor     eax, eax    ;for chars
    xor     ebx, ebx    ;dito
    xor     ecx, ecx    ;sum

getcipher:
    mov     al, [buf + edi]         ;buf[edi] in al
    cmp     byte al, 0              ;end of content?
    je      decode                  ;if yes, start decoding
    sub     al, '0'                 ;convert digit char to int
    inc     edi                     ;next char
    cmp     byte [buf + edi], ','   ;is it a comma?
    jne     greater9                ;if not, number is >= 10
    mov     [cip + esi], al         ;else put number in cip[esi]
    inc     edi                     ;increase indices
    inc     esi
    jmp     getcipher               ;and repeat

greater9:
    mov     bl, [buf + edi]         ;second digit in bl
    sub     bl, '0'                 ;convert to int
    imul    eax, 10                 ;multiply eax by 10
    add     al, bl                  ;add second digit
    mov     [cip + esi], al         ;result in cip[esi]
    inc     esi                     ;increase indices
    add     edi, 2
    jmp     getcipher               ;and repeat

decode:
    mov     byte [cip + esi], 255       ;end of data flag
    mov     byte [cip + esi + 1], 255   ;end of data flag
    mov     byte [cip + esi + 2], 255   ;end of data flag
    xor     edi, edi                    ;key index
    xor     eax, eax                    ;reset registers
    xor     ebx, ebx
    xor     esi, esi

nextkeychar:
    cmp     edi, 3                  ;finished?
    je      getsum                  ;if yes, get the sum
    mov     bl, 'a'                 ;'a' in bl
    mov     esi, edi                ;reset cipher index

testkeychar:
    cmp     byte [cip + esi], 255   ;end of cipher reached?
    je      valid                   ;if yes, key char is valid
    mov     al, [cip + esi]         ;else put cip[esi] in al
    xor     eax, ebx
    mov     [buf + esi], al
    cmp     eax, 32                 ;result < 32 (Space)?
    jl      notvalid                ;if yes, key char is not valid
    cmp     eax, 122                ;result > 122 ('z')?
    jg      notvalid                ;dito
    cmp     eax, 92                 ;result = '\' or '`'?
    je      notvalid                ;dito
    cmp     eax, 96
    je      notvalid
    add     esi, 3                  ;else increase index and repeat
    jmp     testkeychar

notvalid:
    inc     bl                      ;next char in key[edi]
    mov     esi, edi                ;reset cipher index
    jmp     testkeychar             ;test that char

valid:
    mov     [key + edi], bl         ;put char in key[edi]
    inc     edi                     ;increase key index
    jmp     nextkeychar             ;and test next char

getsum:
    sub     esi, 2                  ;reset esi to end of text
    mov     byte [buf + esi], 255   ;end of data flag
    xor     edi, edi                ;reset registers
    xor     eax, eax

sumloop:
    mov     al, [buf + edi]         ;char in al
    cmp     byte al, 255            ;end of text?
    je      print                   ;if yes, print result
    add     ecx, eax                ;else add ascii value to sum
    inc     edi                     ;increase index
    jmp     sumloop                 ;and repeat
        
print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, ecx
    call    printf
    pop     rbp
    
exit:                   ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

back:
    ret
     
section .note.GNU-stack     ;just for gcc
