.globl make_node
.globl insert
.globl get
.globl getAtMost

make_node: 
  addi sp, sp, -16 #allocate memory for ra and s0
  sw ra, 12(sp)
  sw s0, 8(sp)

  addi s0, a0, 0 #store val in s0  

  li a0, 12
  jal ra, malloc #a0 contains the pointer malloc returns
  
  sw s0, 0(a0)
  sw zero, 4(a0)
  sw zero, 8(a0)

  lw s0, 8(sp)  #restore ra and s0
  lw ra, 12(sp)
  addi sp, sp, 16
  ret 

insert:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)

    addi s0, a0, 0
    addi s1, a1, 0

    jal ra, make_node

    addi t0, s0, 0

loop:
    lw t1, 0(t0)

    blt s1, t1, go_left
    bgt s1, t1, go_right

go_right:
    lw t2, 8(t0)
    beq t2, zero, insert_right
    addi t0, t2, 0
    j loop

insert_right:
    sw a0, 8(t0)
    j done

go_left:
    lw t2, 4(t0)
    beq t2, zero, insert_left
    addi t0, t2, 0
    j loop

insert_left:
    sw a0, 4(t0)

done:
    addi a0, s0, 0 #returns the root
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    addi sp, sp, 16
    ret

get:
  beq a0, zero, fail
  lw t0, 0(a0)
  beq t0, a1, success

  blt a1, t0, move_left
  bgt a1, t0, move_right

  move_left:
    lw a0, 4(a0)
    j get
  move_right:
    lw a0, 8(a0)
    j get
  fail:
    addi a0, zero, 0
    ret
  success:
    ret

getAtMost:
  li   t0, -1
  addi t1, a1, 0

loop:
  beq  t1, zero, finish
  lw   t2, 0(t1)
  beq  t2, a0, match
  bgt  t2, a0, left

  addi t0, t2, 0
  lw   t1, 8(t1)
  j    loop

left:
  lw   t1, 4(t1)
  j    loop

match:
  addi t0, t2, 0
  j    finish

finish:
  addi a0, t0, 0
  ret


  
