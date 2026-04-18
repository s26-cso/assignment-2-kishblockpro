.globl make_node
.globl insert
.globl get
.globl getAtMost
make_node:
  addi sp, sp, -16
  sd ra, 8(sp)
  sd s0, 0(sp)
  addi s0, a0, 0
  li a0, 24
  jal ra, malloc
  sw s0, 0(a0)
  sd zero, 8(a0)
  sd zero, 16(a0)
  ld s0, 0(sp)
  ld ra, 8(sp)
  addi sp, sp, 16
  ret
insert:
  addi sp, sp, -32
  sd ra, 24(sp)
  sd s0, 16(sp)
  sd s1, 8(sp)
  addi s0, a0, 0
  addi s1, a1, 0
  addi a0, a1, 0
  jal ra, make_node
  addi t0, s0, 0
  beqz t0, insert_ret
iloop:                       
  lw t1, 0(t0)
  blt s1, t1, go_left
  bgt s1, t1, go_right
go_right:
  ld t2, 16(t0)
  beq t2, zero, insert_right
  addi t0, t2, 0
  j iloop
insert_right:
  sd a0, 16(t0)
  j done
go_left:
  ld t2, 8(t0)
  beq t2, zero, insert_left
  addi t0, t2, 0
  j iloop
insert_left:
  sd a0, 8(t0)
done:
  addi a0, s0, 0
insert_ret:
  ld ra, 24(sp)
  ld s0, 16(sp)
  ld s1, 8(sp)
  addi sp, sp, 32
  ret
get:
  beq a0, zero, fail
  lw t0, 0(a0)
  beq t0, a1, success
  blt a1, t0, move_left
  bgt a1, t0, move_right
move_left:
  ld a0, 8(a0)
  j get
move_right:
  ld a0, 16(a0)
  j get
fail:
  addi a0, zero, 0
  ret
success:
  ret
getAtMost:
  li   t0, -1
  addi t1, a1, 0
galoop:
  beq  t1, zero, finish
  lw   t2, 0(t1)
  beq  t2, a0, match
  bgt  t2, a0, left
  addi t0, t2, 0
  ld   t1, 16(t1)
  j    galoop
left:
  ld   t1, 8(t1)
  j    galoop
match:
  addi t0, t2, 0
  j    finish
finish:
  addi a0, t0, 0
  ret
