format ELF64 executable 9

segment readable writable
    result: times 10 db 0       ;empty string for printing the result later
                     db 10, 0

segment readable executable
    entry start

start:
    mov     eax, 2              ;init a/b to 2/5
    mov     ebx, 5

get_next:
    mov     edi, eax            ;old a = result
    add     eax, 3              ;new a = a + numerator to the right
    add     ebx, 7              ;new b = b + denominator to the right
    cmp     ebx, 1000000        ;if b >= 1e6 we are finished
    jl      get_next
    
finished:
    mov     eax, edi            ;convert result to string, print and exit
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
    mov     rax, 1
    xor     rdi, rdi
    syscall
