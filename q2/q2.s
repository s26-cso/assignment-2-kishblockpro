.section .rodata
    fmt_digit:   .asciz "%d"
    fmt_space:   .asciz " "
    fmt_newline: .asciz "\n"
.section .text
.global main
main:
    addi sp, sp, -64                # Allocate frame
    sd ra, 56(sp)                   # Save return address
    sd s0, 48(sp)                   # s0 = argc
    sd s1, 40(sp)                   # s1 = argv
    sd s2, 32(sp)                   # s2 = arr base
    sd s3, 24(sp)                   # s3 = res base
    sd s4, 16(sp)                   # s4 = stack base
    sd s5, 8(sp)                    # s5 = i
    sd s6, 0(sp)                    # s6 = stack_ptr
    mv s0, a0
    mv s1, a1
    li t0, 1
    ble s0, t0, exit_prog           # Exit if no args provided
    addi s0, s0, -1                 # n = argc - 1
    slli a0, s0, 2                  # Calculate n * 4 bytes
    call malloc                     # Allocate arr
    mv s2, a0
    slli a0, s0, 2
    call malloc                     # Allocate res
    mv s3, a0
    slli a0, s0, 2
    call malloc                     # Allocate manual stack
    mv s4, a0
    li s5, 0                        # Initialize i = 0
init_loop:
    beq s5, s0, start_algorithm
    addi t0, s5, 1                  # Offset for argv[i+1]
    slli t0, t0, 3
    add t0, s1, t0
    ld a0, 0(t0)                    # Load string pointer
    call atoi                       # Convert arg to int
    slli t1, s5, 2
    add t1, s2, t1
    sw a0, 0(t1)                    # arr[i] = atoi result
    slli t1, s5, 2
    add t1, s3, t1
    li t2, -1
    sw t2, 0(t1)                    # res[i] = -1 (default)
    addi s5, s5, 1
    j init_loop
start_algorithm:
    li s5, 0                        # i = 0
    li s6, 0                        # stack is empty
algo_loop:
    beq s5, s0, print_results
    slli t1, s5, 2
    add t1, s2, t1
    lw t0, 0(t1)                    # t0 = arr[i]
while_stack:
    blez s6, push_current           # If stack empty, push i
    addi t1, s6, -4                 # Get offset of top element
    add t1, s4, t1                  # Get addr of top element
    lw t2, 0(t1)                    # t2 = top index
    slli t4, t2, 2
    add t4, s2, t4
    lw t3, 0(t4)                    # t3 = arr[top]
    ble t0, t3, push_current        # If arr[i] <= arr[top], stop popping
    addi s6, s6, -4                 # Pop stack pointer
    slli t4, t2, 2
    add t4, s3, t4
    sw s5, 0(t4)                    # res[top] = current index i
    j while_stack
push_current:
    add t1, s4, s6                  # stack[stack_ptr] addr
    sw s5, 0(t1)                    # Push i onto stack
    addi s6, s6, 4                  # Increment stack pointer
    addi s5, s5, 1                  # i++
    j algo_loop
print_results:
    li s5, 0                        # Loop for printing
print_loop:
    beq s5, s0, end_print
    slli t0, s5, 2
    add t0, s3, t0
    lw a1, 0(t0)                    # a1 = res[i]
    la a0, fmt_digit
    call printf
    addi t0, s0, -1
    beq s5, t0, skip_space          # Check if space needed
    la a0, fmt_space
    call printf
skip_space:
    addi s5, s5, 1
    j print_loop
end_print:
    la a0, fmt_newline
    call printf
exit_prog:
    ld ra, 56(sp)                   # Restore registers
    ld s0, 48(sp)
    ld s1, 40(sp)
    ld s2, 32(sp)
    ld s3, 24(sp)
    ld s4, 16(sp)
    ld s5, 8(sp)
    ld s6, 0(sp)
    addi sp, sp, 64
    li a0, 0
    ret
