section .data
    msg db "%d", 10, 0              ;return string for printf (just the result)
    fib1 times 1000 dd 0
    fib2 times 1000 dd 0

section .text
    extern printf
    global main

main:
    mov     dword [fib1 + 4 * 999], 1   ;init fib1
    mov     dword [fib2 + 4 * 999], 1   ;init fib2
    mov     esi, 998                    ;index of first significant digit - 1
    mov     ecx, 1                      ;index of Fibonacci number
    mov     r8d, 10                     ;for divisions

fib_outer:
    inc     ecx                 ;increase index of Fibonacci number
    xor     ebx, ebx            ;carry
    mov     edi, 1000           ;index for inner loop
    cmp     dword [fib1], 0     ;check if we reached 1000 digits
    jg      print               ;if yes, print result

fib_inner:
    dec     edi                     ;decrease index
    xor     edx, edx                ;reset remainder
    mov     eax, [fib1 + 4 * edi]   ;fib1 @ edi in eax
    add     eax, [fib2 + 4 * edi]   ;add fib2 @ edi 
    add     eax, ebx                ;add carry
    div     r8d                     ;divide by 10
    mov     [fib2 + 4 * edi], edx   ;remainder in fib2 @ edi
    mov     ebx, eax                ;carry = result
    mov     eax, [fib2 + 4 * edi]   ;swap fib1 <-> fib 2
    mov     edx, [fib1 + 4 * edi]
    mov     [fib1 + 4 * edi], eax
    mov     [fib2 + 4 * edi], edx
    cmp     edi, esi                    ;reached first significant digit?
    jg      fib_inner                   ;if not, continue inner loop
    cmp     dword [fib1 + 4 * esi], 0   ;else check if fib1 @ esi > 0
    jg      updatesig                   ;if yes, update esi
    jmp     fib_outer                   ;else jump to outer loop

updatesig:
    dec     esi         ;decrease first significant digit
    jmp     fib_outer   ;jump to outer loop

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
