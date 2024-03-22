Just for fun and to get a better understanding about how CPUs work, I started to learn Assembly with NASM in FreeBSD. Solving Project Euler problems is one of my favourite ways to get familiar with a new programming language. It won't teach you how to write good software, but it is a great way to learn the syntax etc.

These solutions should compile and run as-is in FreeBSD 64bit using the following commands:

`nasm -f elf64 <filename.asm>`

`gcc <filename.o> -o <filename>`

For debugging with gdb, you should replace the first command with:

`nasm -f elf64 -g -F dwarf <filename>.asm`

For Linux, you should be good to go by replacing the `1` in the exit syscall with `60` and adding a `-no-pie` option to the gcc command. No idea about Windows, sorry.



## Some comments about specific solutions:

### 001
I made use of the fact that the multiples of 3 or 5 are spaced at a repeating pattern. Starting from 0, you do +3, +2, +1, +3, +1, +2, +3 and then it starts over again. This saves us from doing modulo divisions or building solutions with multiple loops (e.g. adding up the multiples of 3, than those of 5 and finally subtracting the multiples od 15 once, as they are counted twice in this case).

### 003
I made the solution more universal than it needs to be, because the number to factor is odd. You could omit the whole "dividing by 2" part and still arrive at the correct solution. I am not totally sure that it works for any input number, but at least the corner cases that I checked (powers of 2, primes, numbers with just 2 and another prime as factors) worked. If you find a case which shows a wrong result or leads to an infinite loop, please let me know!

### 004
The Palindrome check works by reversing the current product. I continuously divide the product by 10 and add the remainder to the reverse. Then the reverse is multiplied by 10 to "make room" for the next remainder.

### 007
The upper bound for the prime sieve can be found with the fact that the Nth prime number is guaranteed to be less that N * (ln N + ln(ln N))
