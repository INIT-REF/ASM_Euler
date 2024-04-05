Just for fun and to get a better understanding about how CPUs work, I started to learn Assembly with NASM in FreeBSD. Solving Project Euler problems is one of my favourite ways to get familiar with a new programming language. It won't teach you how to write good software, but it is a great way to learn the syntax etc.

These solutions should compile and run as-is in FreeBSD 64bit using the following commands:

`nasm -f elf64 <filename>.asm`

`gcc <filename>.o -o <filename>`

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
The upper bound for the prime sieve can be found with the fact that the Nth prime number is guaranteed to be less that N * (ln N + ln(ln N)).

### 009
The solution is based on [Dickson's method](https://en.wikipedia.org/wiki/Formulas_for_generating_Pythagorean_triples#Dickson's_method) for generating pythagorean triplets.

### 011
The grid is surrounded by 0s on three sides. This simplifies the algorithm, because we can check every direction at each index and "invalid products" which would go beyond the edges will become 0.

### 013
It is sufficient to truncate the numbers to the first 11 digits to get the result. I convert the result to a string and let printf output the first 10 characters.

### 015
This boils down to an "n choose k" problem, with n being twice the grid width and k being the width, so "40 choose 20". We can then use the [Muliplicative Formula](https://en.wikipedia.org/wiki/Binomial_coefficient#Multiplicative_formula) to compute the result without needing to calculate factorials.

### 016
I use an array representation of the number and compute each power digit by digit.

### 017
I left that one more or less uncommented. It's just what can be done with pen and paper or a calculator and builds the sum in loops according to how many times a number is used below 1000.

### 020
Pretty much the same solution as 016, just with an increasing multiplier instead of the constant factor.

### 022
Although this is a trivial problem in most higher level languages, it was really hard for me getting it done in Assembly. I didn't want to "cheat" by using extern C functions like qsort etc (apart from printf for printing the final result as usual), so I implemented everything using only "pure" assembly and system functions for file handling.

Because Bubble Sort was the easiest to implement, the solution is quite slow compared to using C and qsort, and takes 200ms. But I'm glad that I got it working at all.

Also, I'm sure I could have saved quite a lot of instructions and registers by using the stack effectively etc...

### 024
I used the an implementation of the [Lehmer code](https://en.wikipedia.org/wiki/Lehmer_code) to solve this. It has the advantage that you can directly compute the Nth permutation without needing to build the ones in between. The `updatestring` function shifts all digits from the current index one step to the left, so that the remaining digits form a "shorter" array where the already selected digits are missing.
