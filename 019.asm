section .data
    msg db "%d", 10, 0              ;return string for printf (just the result)
    dim dd 0,31,28,31,30,31,30,31,31,30,31,30,31  ;days in a month

section .text
    extern printf
    global main

main:
    mov     ebx, 1900       ;year (to be increased soon)
    mov     edi, 2          ;1901/01/01 was a Tuesday
    mov     esi, 1          ;day in month counter
    xor     r8d, r8d        ;sum

nextyear:
    mov     ecx, 1              ;set month to January
    inc     ebx                 ;next year
    cmp     ebx, 2001           ;check if we are finished
    je      print               ;if yes, print result
    mov     dword [dim + 8], 28 ;reset febuary
    bsr     eax, ebx            ;year divisible by 4 when last two bits are 0
    cmp     eax, 2              ;result 2?
    jne     count               ;if not, go to count
    mov     dword [dim + 8], 29 ;if zero, set febuary to 29 days

count:
    cmp     esi, 1              ;check if first of month
    jne     continue            ;if not, continue
    cmp     edi, 7              ;check if it is Sunday
    jne     continue            ;if not, continue
    inc     r8d                 ;else increase count

continue:
    inc     edi                 ;increase weekday
    inc     esi                 ;increase dim counter
    call    resetweekday        ;reset weekday?
    call    nextmonth           ;next month?
    jmp     count               ;back to count

resetweekday:
    cmp     edi, 8              ;end of week?
    jl      back                ;if not, return
    mov     edi, 1              ;else reset to Monday
    ret

nextmonth:
    cmp     esi, [dim + 4 * ecx]    ;end of month?
    jle     back                    ;if not, return
    mov     esi, 1                  ;else reset to first of month
    inc     ecx                     ;increase month
    cmp     ecx, 13                 ;end of year?
    je      nextyear                ;if yes, next year
    ret
    
back:
    ret

print:                      ;printing routine, differs slightly from OS to OS
    push    rbp
    mov     edi, msg
    mov     esi, r8d
    call    printf
    pop     rbp

exit:                       ;exit routine, dito
    mov     eax, 1
    xor     edi, edi
    syscall

section .note.GNU-stack     ;just for gcc
