section .data
    msg db "%.10s", 10, 0   ;return string for printf (just the result)
    ans times 20 db 0       ;string for truncated result
    numbers dq 37107287533, 46376937677, 74324986199, 91942213363
            dq 23067588207, 89261670696, 28112879812, 44274228917
            dq 47451445736, 70386486105, 62176457141, 64906352462
            dq 92575867718, 58203565325, 80181199384, 35398664372
            dq 86515506006, 71693888707, 54370070576, 53282654108
            dq 36123272525, 45876576172, 17423706905, 81142660418
            dq 51934325451, 62467221648, 15732444386, 55037687525
            dq 18336384825, 80386287592, 78182833757, 16726320100
            dq 48403098129, 87086987551, 59959406895, 69793950679
            dq 41052684708, 65378607361, 35829035317, 94953759765
            dq 88902802571, 25267680276, 36270218540, 24074486908
            dq 91430288197, 34413065578, 23053081172, 11487696932
            dq 63783299490, 67720186971, 95548255300, 76085327132
            dq 37774242535, 23701913275, 29798860272, 18495701454
            dq 38298203783, 34829543829, 40957953066, 29746152185
            dq 41698116222, 62467957194, 23189706772, 86188088225
            dq 11306739708, 82959174767, 97623331044, 42846280183
            dq 55121603546, 32238195734, 75506164965, 62177842752
            dq 32924185707, 99518671430, 73267460800, 76841822524
            dq 97142617910, 87783646182, 10848802521, 71329612474
            dq 62184073572, 66627891981, 60661826293, 85786944089
            dq 66024396409, 64913982680, 16730939319, 94809377245
            dq 78639167021, 15368713711, 40789923115, 44889911501
            dq 41503128880, 81234880673, 82616570773, 22918802058
            dq 77158542502, 72107838435, 20849603980, 53503534226

section .text
    extern printf
    global main

main:
    mov     rax, [numbers]  ;sum
    xor     rbx, rbx        ;array index

sum:
    inc     ebx                         ;next number
    add     rax, [numbers + 8 * ebx]    ;add to sum
    cmp     ebx, 99                     ;check if end of array
    jl      sum                         ;if not, continue summing
    mov     ebx, 19                     ;set ebx to end of ans
    mov     ecx, 10                     ;set ecx to 10 for divisions

convert:
    xor     rdx, rdx                ;reset remainder
    div     rcx                     ;divide by 10
    add     rdx, '0'                ;get the ASCII value of the remainder
    mov     [ans + ebx], dl         ;put it in ans
    dec     ebx                     ;decrease index
    cmp     rax, 10                 ;check if number has arrived at 0
    jge     convert                 ;if not, repeat
    lea     eax, [ans + ebx]        ;else pointer to first digit in eax

print:                  ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, eax
    call    printf
    pop     rbp

exit:                   ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack ;just for gcc
