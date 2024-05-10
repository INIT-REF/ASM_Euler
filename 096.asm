section .data
    msg db "%d", 10, 0        ;return string for printf
    file db "p096_sudoku.txt", 0
    ;fir = first in row index for every cell
    ;fic = first in col index for every cell
    ;fib = first in box index for every cell 
    fir dd 00,00,00,00,00,00,00,00,00,09,09,09,09,09,09,09,09,09,18,18,18,18,18,18,18,18,18
        dd 27,27,27,27,27,27,27,27,27,36,36,36,36,36,36,36,36,36,45,45,45,45,45,45,45,45,45
        dd 54,54,54,54,54,54,54,54,54,63,63,63,63,63,63,63,63,63,72,72,72,72,72,72,72,72,72
    fic dd 00,01,02,03,04,05,06,07,08,00,01,02,03,04,05,06,07,08,00,01,02,03,04,05,06,07,08
        dd 00,01,02,03,04,05,06,07,08,00,01,02,03,04,05,06,07,08,00,01,02,03,04,05,06,07,08
        dd 00,01,02,03,04,05,06,07,08,00,01,02,03,04,05,06,07,08,00,01,02,03,04,05,06,07,08
    fib dd 00,00,00,03,03,03,06,06,06,00,00,00,03,03,03,06,06,06,00,00,00,03,03,03,06,06,06
        dd 27,27,27,30,30,30,33,33,33,27,27,27,30,30,30,33,33,33,27,27,27,30,30,30,33,33,33
        dd 54,54,54,57,57,57,60,60,60,54,54,54,57,57,57,60,60,60,54,54,54,57,57,57,60,60,60
    
section .bss
    buf resb 5000   ;buffer for file contents
    s resb 81       ;current sudoku
    f resb 81       ;copy of unsolved sudoku for identifying fixed numbers
    t resb 27       ;test array for row/col/box contents

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
 
    xor     r8d, r8d    ;result
    xor     r9d, r9d    ;index for buffer
    xor     r10d, r10d  ;index for sudoku no

readnext:
    inc     r10d        ;next sudoku
    cmp     r10d, 51    ;all sudokus solved?
    je      print       ;if yes, print result

findstart:
    add     r9d, 8          ;add 8 to skip "Grid XX\n"
    xor     esi, esi        ;reset esi
    
read:
    mov     al, [buf + r9d] ;read Sukodu and skip line breaks
    cmp     al, 10
    je      skipped
    mov     [s + esi], al
    mov     [f + esi], al
    inc     esi

skipped:
    inc     r9d
    cmp     esi, 81
    jl      read
    xor     edi, edi        ;reset edi, will be index for current sudoku string
    mov     cl, '1'         ;put '1' in cl to start the backtracking algorithm

solve:
    call    skipfixfwd      ;skip fixed positions
    cmp     edi, 81         ;end of sudoku reached (last digit is fixed)?
    jge     sum             ;if yes, add first three digits to sum
    call    rowcolbox       ;else get digits in col/row/box

testn:
    xor     esi, esi        ;reset esi
    call    valid           ;is current digit valid in s[edi]?
    cmp     ebx, 0
    je      nextn           ;if not, try next higher digit
    mov     [s + edi], cl   ;else move digit in s[edi]
    mov     cl, '1'         ;reset cl
    inc     edi             ;and increase index
    cmp     edi, 81         ;sudoku solved?
    je      sum             ;if yes, jump to sum
    jmp     solve           ;else repeat solving

nextn:
    inc     cl              ;next higher digit
    cmp     cl, '9'         ;is it <= 9?
    jle     testn           ;if yes, test it

backtrack:
    call    skipfixbwd          ;else backtrack to last set digit
    mov     cl, [s + edi]       ;put its value in cl
    cmp     byte cl, '9'        ;see if it is 9
    mov     byte [s + edi], '0' ;reset s[edi] to 0
    je      backtrack           ;if it is 9, backtrack again
    inc     cl                  ;else increase cl
    jmp     solve               ;and continue solving

sum:
    xor     edi, edi            ;reset registers
    xor     esi, esi
    xor     eax, eax

sumloop:
    imul    edi, 10             ;get the first three digits as a number
    mov     al, [s + esi]
    sub     al, '0'
    add     edi, eax
    inc     esi
    cmp     esi, 3
    jl      sumloop
    add     r8d, edi            ;and add to result
    jmp     readnext
        
print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, r8d
    call    printf
    pop     rbp
    
exit:                   ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

rowcolbox:                          ;get row/col/box and put digits in t
    xor     eax, eax
    xor     esi, esi
    mov     eax, [fir + 4 * edi]

row:
    mov     bl, [s + eax + esi]
    mov     [t + esi], bl
    inc     esi
    cmp     esi, 9
    jl      row
    mov     eax, [fic + 4 * edi]

col:
    mov     bl, [s + eax]
    mov     [t + esi], bl
    inc     esi
    add     eax, 9
    cmp     esi, 18
    jl      col
    mov     eax, [fib + 4 * edi]

box:
    mov     bl, [s + eax]
    mov     [t + esi], bl
    inc     eax
    inc     esi
    cmp     esi, 21
    je      add6
    cmp     esi, 24
    je      add6
    cmp     esi, 27
    jl      box
    xor     esi, esi
    ret

add6:
    add     eax, 6
    jmp     box

valid:                      ;check if current candidate is already in t
    cmp     esi, 27
    je      back
    mov     bl, [t + esi]
    inc     esi
    cmp     bl, cl
    jne     valid
    xor     ebx, ebx
    ret

skipfixfwd:                 ;skip fixed positions forward
    mov     bl, [f + edi]
    cmp     bl, '0'
    je      back
    inc     edi
    jmp     skipfixfwd

skipfixbwd:                 ;skip fixed positions backward
    dec     edi
    mov     bl, [f + edi]
    cmp     bl, '0'
    jne     skipfixbwd

back:
    ret
     
section .note.GNU-stack     ;just for gcc
