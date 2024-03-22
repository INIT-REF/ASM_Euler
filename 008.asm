section .data
    msg db "%lld", 10, 0    ;return string for printf (just the result)
    max dq 0                ;variable to store the current max
    list    db "73167176531330624919225119674426574742355349194934"
            db "96983520312774506326239578318016984801869478851843"
            db "85861560789112949495459501737958331952853208805511"
            db "12540698747158523863050715693290963295227443043557"
            db "66896648950445244523161731856403098711121722383113"
            db "62229893423380308135336276614282806444486645238749"
            db "30358907296290491560440772390713810515859307960866"
            db "70172427121883998797908792274921901699720888093776"
            db "65727333001053367881220235421809751254540594752243"
            db "52584907711670556013604839586446706324415722155397"
            db "53697817977846174064955149290862569321978468622482"
            db "83972241375657056057490261407972968652414535100474"
            db "82166370484403199890008895243450658541227588666881"
            db "16427171479924442928230863465674813919123162824586"
            db "17866458359124566529476545682848912883142607690042"
            db "24219022671055626321111109370544217506941658960408"
            db "07198403850962455444362981230987879927244284909188"
            db "84580156166097919133875499200524063689912560717606"
            db "05886116467109405077541002256983155200055935729725"
            db "71636269561882670428252483600823257530420752963450"

section .text
    extern printf
    global main

main:
    xor     ebx, ebx    ;prepare ebx, counter for outer loop
    xor     rax, rax    ;prepare rax, will store the current product

updatemax:
    cmp     rax, [max]              ;check if current product is greater than max
    jle     next                    ;if not, continue with next product
    mov     [max], rax              ;if yes, store product in max

next:
    xor     rax, rax                ;prepare rax again for the next product
    mov     al, [list + ebx]        ;store char at current position in al
    sub     rax, '0'                ;subtract '0' which give the int value
    mov     edi, 1                  ;put 1 in edi (starting index for inner loop)

product:
    xor     rcx, rcx                ;prepare rcx, which will store the current digit
    mov     cl, [list + ebx + edi]  ;put digit @ ebx + edi in cl
    sub     rcx, '0'                ;subtract '0' to get the int value
    mul     rcx                     ;multiply
    inc     edi                     ;increase index for inner loop
    cmp     edi, 12                 ;check if is <= 12
    jle     product                 ;if yes, continue multiplying
    inc     ebx                     ;else increase index of outer loop
    cmp     ebx, 989                ;check if we reached the end of the list
    jle     updatemax               ;if not, go to updatemax and continue

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     rsi, [max]
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     rax, 1
    xor     rdi, rdi
    syscall

section .note.GNU-stack     ;just for gcc
