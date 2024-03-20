Just for fun and to get a better understanding about how CPUs work, I started to learn Assembly with NASM in FreeBSD. Solving Project Euler problems is one of my favourite ways to get familiar with a new programming language. It won't teach you how to write good software, but it is a great way to learn the syntax etc.

These solutions should compile and run as-is in FreeBSD 64bit using the following commands:

`nasm -f elf64 <filename.asm>`

`gcc <filename.o> -o <filename>`

For debugging with gdb, you should replace the first command with:

`nasm -f elf64 -g -F dwarf <filename>.asm`

## Some comments about specific solutions:

### 001
I made use of the fact that the multiples of 3 or 5 are spaced at a repeating pattern. Starting from 0, you do +3, +2, +1, +3, +1, +2, +3 and then it starts over again. This saves us from doing modulo divisions or building solutions with multiple loops (e.g. adding up the multiples of 3, than those of 5 and finally subtracting the multiples od 15 once, as they are counted twice in this case).

### 003
I made the solution more universal than it needs to be, because the number to factor is odd. You could omit the whole "dividing by 2" part and still arrive at the correct solution.
