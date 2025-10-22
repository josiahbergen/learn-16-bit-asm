
### your mission:
print "hello, world!" onto the screen, then stop execution. <br>

use `./build.sh` to build and run your code. <br>
you might need to install nasm and qemu first: `brew install nasm qemu`

### useful resources:

https://en.wikipedia.org/wiki/BIOS_interrupt_call <br>
https://en.wikipedia.org/wiki/INT_10H <br>
https://en.wikipedia.org/wiki/INT_16H <br>
https://wiki.osdev.org/CPU_Registers_x86

### basic x86 assembly instructions: 
(you will eventually memorize these just by using them so much) 

- `mov a, b`: move the contents of b to a. b can be a register or a literal
- `$`: shorthand for _the current line of execution._ (hint: what would happen if you infinitely jump to the current line?)
- `jmp a`: unconditaionally move execution to a label or address
- `inc a`: increment the value in a by 1
- `cmp a, b`: compares a to b. result will be put in flag registers. see below:
    - to jump if a = b: `je equal_label`
    - to jump if a < b: `jl less_than_label`
    - to jump if a > b: `jg greater_than_label`
- `call`: call subroutine
- `ret`: return from subroutine
- to define a string: `string_label: db "string", 0`
    - `db`: define bytes
    - `"string"`: the content of the string
    - `0`: make the string null-terminated
    - you could also do this (it's the same): `string_label: db 'h', 'i', 0`
    - remember that `string_label` functions as a _pointer_ to the beginning of the string in memory.

### keep in mind:
- we are in _16-bit real mode._ only the 16-bit registers will work.
- BIOS interrupts are your friend.
