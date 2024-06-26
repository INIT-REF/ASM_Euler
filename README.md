Just for fun and to get a better understanding about how CPUs work, I started to learn Assembly with FreeBSD. Solving Project Euler problems is one of my favourite ways to get familiar with a new programming language. It won't teach you how to write good software, but it is a great way to learn the syntax etc.

Most solutions were done using NASM, but I switched to FASM later.

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
I use an array representation of the number, and split it in chunks of 18-digits, so 17 qwords are needed. It's a bit more efficient than using a byte array with 302 single digits.

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

### 025
Again using an array to represent the big integers, similar to problems 016 and 020.

### 026
The solution works by first calculating a = 10 mod D and then loop with a = (a * 10) mod d until a gets zero. The number of iterations gives the cycle length.

### 027
As the formula needs to deliver a prime for n = 0, we can limit the range for b to primes below 1000. I set the limit for the prime sieve to 2000, because the highest prime that the formula delivers (given the restrictions) is below that. Also, a has to be odd in order for the formula to only produce odd numbers.

### 028
It is intended that I first divide by 4 and then multiply by 2 in the sum function, instead of just dividing by 2. We need the integer division by 4 first, in order to loose the two rightmost bits. 

### 032
We only need to take 4-digit products between 1234 and 9876 into account. If the product had 3 digits or less, we would need to use 6 digits or more for multiplicand and multiplier, which could never result in a product that small. Vice versa, if the product had 5 digits or more, we couldn’t make that using only 4 digits or less for multiplicand and multiplier.

### 033
It can be shown, that the only possibility to "simplify" fractions that satisfy the problem is to cancel out the second digit of the numerator and the first digit of the denominator. Hence, my solution checks if these both digits match and skips all fractions for which it is not the case.

### 034
I used 7 * 9! as the upper bound, because 8 * 9! is still a 7-digit number. The acutal greatest number that can be written as the sum of its digit factorials is much lower than this, but it was ok as a rough guess.

### 036
We only need to check odd numbers, because the least significant bit in base 2 can't be 0 for this problem.

### 039
Again using Dickson's method from problem 009. As this produces perimeters of <= 1000 for input values up to 168, we can limit the range to this value.

### 041
We can set the upper limit to 7654321, because all 8- and 9-digit numbers are divisible by three (as the digit sum is divisible by three). And because I assumed that the number would be a large 7-digit number, I didn't implement a prime sieve but instead used a quick trial division to identify primes.

### 044
I assumed that the first (lowest) pair, for which the difference and sum are pentagonal is the one with the lowest difference. Unfortunately, I have no proof for that assumption, but it turned out to be the correct answer. Also, I set an arbitrary limit to only search within the first 2500 pentagonal numbers.

### 045
As all hexagonal numbers are also triangular numbers, it is sufficient to find the next pentagonal number which is also hexagonal.

### 050
I build up the sum of all primes from increasing starting primes until the sum goes over 1000000. Then I continuously subtract the last primes until the sum itself is a prime. I set an arbitrary limit for the starting prime of 1000, because I assumed that the longest chains would result from the lowest starting primes.
