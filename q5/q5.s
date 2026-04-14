.section .rodata
filename:   .string "input.txt"
mode:       .string "r"
str_no:     .string "No\n"
str_yes:    .string "Yes\n"

    .section .text
    .globl main

main:
    addi sp, sp, -48            # allocate forty eight bytes to maintain sixteen byte stack alignment
    sd ra, 40(sp)
    sd s0, 32(sp)               # s zero is the file pointer
    sd s1, 24(sp)               # s one is the file size
    sd s2, 16(sp)               # s two is the loop counter
    sd s3, 8(sp)                # s three is the left character

    lla a0, filename
    lla a1, mode
    call fopen
    mv s0, a0                   # store file pointer in a callee saved register

    beqz s0, early_fail         # exit early if the file failed to open

    mv a0, s0
    li a1, 0
    li a2, 2                    # seek end is two
    call fseek                  # move to the end of the file to determine its size

    mv a0, s0
    call ftell
    mv s1, a0                   # store file size

    li s2, 0

loop_start:
    srai t0, s1, 1              # t zero is n divided by two using arithmetic shift right by one
    bge s2, t0, check_success   # if i is greater than or equal to n divided by two all pairs matched it is a palindrome

    mv a0, s0
    mv a1, s2
    li a2, 0                    # seek set is zero
    call fseek                  # move to position i on the left side

    mv a0, s0
    call fgetc
    mv s3, a0                   # save the left character

    mv a0, s0
    sub a1, s1, s2
    addi a1, a1, -1             # calculate index n minus one minus i
    li a2, 0
    call fseek                  # move to position n minus one minus i on the right side

    mv a0, s0
    call fgetc                  # read the right character into a zero

    bne s3, a0, check_fail      # if left does not equal right it is not a palindrome

    addi s2, s2, 1              # increment i
    j loop_start

check_fail:
    lla a0, str_no
    call printf

    mv a0, s0
    call fclose

    li a0, 0
    j epilogue

check_success:
    lla a0, str_yes
    call printf

    mv a0, s0
    call fclose

    li a0, 0
    j epilogue

early_fail:
    lla a0, str_no
    call printf

    li a0, 0

epilogue:
    ld ra, 40(sp)               # restore return address and callee saved registers
    ld s0, 32(sp)
    ld s1, 24(sp)
    ld s2, 16(sp)
    ld s3, 8(sp)
    addi sp, sp, 48             # deallocate stack
    ret
