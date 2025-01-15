#
# Usage: ./calculator <op> <arg1> <arg2>
#

# Make `main` accessible outside of this module
.global main

# Start of the code section
.text

# int main(int argc, char argv[][])
main:
  # Function prologue
  enter $0, $0

  # Variable mappings:
  # op -> %r12
  # arg1 -> %r13
  # arg2 -> %r14
  movq 8(%rsi), %r12  # op = argv[1]
  movq 16(%rsi), %r13 # arg1 = argv[2]
  movq 24(%rsi), %r14 # arg2 = argv[3] 
  

  # Hint: Convert 1st operand to long int

  # Hint: Convert 2nd operand to long int

  movq %r13, %rdi
  call atol
  movq %rax, %r13

  movq %r14, %rdi
  call atol
  movq %rax, %r14

  # Hint: Copy the first char of op into an 8-bit register
  # i.e., op_char = op[0] - something like: 
  movb 0(%r12), %al

  # Explanation: Since each argument is a string, the contents of %r12 are 
  # actually a memory address pointing to the beginning of the string (which 
  # is a sequence of characters). When correctly completed, the above 
  # instruction copy the first byte (i.e., the first character) to a register
  # for further use.

  # if (op_char == '+') {
  #   ...
  # }
  # else if (op_char == '-') {
  #  ...
  # }
  # ...
  # else {
  #   // print error
  #   // return 1 from main
  # }

  cmpb $'+', %al
  je .Plus
  cmpb $'-', %al
  je .Min
  cmpb $'/', %al
  je .Div
  cmpb $'*', %al
  je .Mul
  movq $error, %rdi
  call printf

  .Plus: 
    addq %r14, %r13
    movq %r13, %rsi
    movq $format, %rdi
    call printf
    jmp .Cont

  .Min:
    subq %r14, %r13
    movq %r13, %rsi
    movq $format, %rdi
    call printf
    jmp .Cont

  .Div:
    movq %r13, %rax
    movq %r14, %rbx
    cqto
    idivq %rbx
    movq %rax, %rsi 
    movq $format, %rdi
    call printf
    jmp .Cont

  .Mul:
    imulq %r14, %r13
    movq %r13, %rsi
    movq $format, %rdi
    call printf
    jmp .Cont
  
  .Cont:

  # Function epilogue
  leave
  ret


# Start of the data section
.data

add: .asciz "%+"
sub: .asciz "%-"
div: .asciz "%/"
mul: .asciz "%*"

error:
  .asciz "Unknown Operation"

format: 
  .asciz "%ld\n"

