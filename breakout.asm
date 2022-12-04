# CSC258H1F Fall 2022 Assembly Final Project: Breakout
# Juan Martin 1006934766

# Bitmap Display Configuration:
# - Unit width in pixels:      8
# - Unit height in pixels:     8
# - Display width in pixels:   256
# - Display height in pixels:  256
# - Base Address for Display:  0x10008000 ($gp)

.data
ADDR_DSPL:      .word 0x10008000
ADDR_KBRD:      .word 0xffff0000
PADDLE_POS:     .word 3640
SND_PADDLE_POS: .word 3768
BALL_POS:       .word 3512
BALL_DIR:       .word 0
NUM_LIVES:      .word 3
START_TIME:     .word 0

.text
.globl main

main:

# get current time and store in START_TIME
li $v0, 30
syscall
la $t0, START_TIME
sw $a0, 0($t0)

# paint top wall
lw $t0, ADDR_DSPL
li $t1, 0x777777
add $t2, $zero, -4
top_wall:
beq $t2, 124, top_wall_end
add $t2, $t2, 4
add $t3, $t0, $t2
sw $t1, 0($t3)
j top_wall
top_wall_end:

# paint bottom wall
lw $t0, ADDR_DSPL
li $t1, 0x000003
add $t2, $zero, 3968
bottom_wall:
beq $t2, 4088, bottom_wall_end
add $t2, $t2, 4
add $t3, $t0, $t2
sw $t1, 0($t3)
j bottom_wall
bottom_wall_end:

# paint left wall
lw $t0, ADDR_DSPL
li $t1, 0x777776
add $t2, $zero, 0
left_wall:
beq $t2, 3968, left_wall_end
add $t2, $t2, 128
add $t3, $t0, $t2
sw $t1, 0($t3)
j left_wall
left_wall_end:

# paint right wall
lw $t0, ADDR_DSPL
li $t1, 0x777778
add $t2, $zero, 124
right_wall:
beq $t2, 4092, right_wall_end
add $t2, $t2, 128
add $t3, $t0, $t2
sw $t1, 0($t3)
j right_wall
right_wall_end:

# paint bricks 1
lw $t0, ADDR_DSPL
li $t1, 0xffabab
add $t5, $zero, 0
bricks_1d:
add $t2, $zero, 0
add $t3, $t5, 136
bricks_1a:
beq $t2, 2, bricks_1b
add $t3, $t3, 4
add $t4, $t0, $t3
sw $t1, 0($t4)
add $t2, $t2, 1
j bricks_1a
bricks_1b:
add $t6, $t5, 240
beq $t3, $t6, bricks_1c
add $t2, $zero, 0
add $t3, $t3, 4
j bricks_1a
bricks_1c:
beq $t5, 768, bricks_1e
add $t5, $t5, 256
j bricks_1d
bricks_1e:

# paint bricks 2
lw $t0, ADDR_DSPL
li $t1, 0xabe9ff
add $t5, $zero, 768
bricks_2d:
add $t2, $zero, 0
add $t3, $t5, 136
bricks_2a:
beq $t2, 2, bricks_2b
add $t3, $t3, 4
add $t4, $t0, $t3
sw $t1, 0($t4)
add $t2, $t2, 1
j bricks_2a
bricks_2b:
add $t6, $t5, 240
beq $t3, $t6, bricks_2c
add $t2, $zero, 0
add $t3, $t3, 4
j bricks_2a
bricks_2c:
beq $t5, 1280, bricks_2e
add $t5, $t5, 256
j bricks_2d
bricks_2e:

# paint bricks 3
lw $t0, ADDR_DSPL
li $t1, 0xfffcab
add $t5, $zero, 1280
bricks_3d:
add $t2, $zero, 0
add $t3, $t5, 136
bricks_3a:
beq $t2, 2, bricks_3b
add $t3, $t3, 4
add $t4, $t0, $t3
sw $t1, 0($t4)
add $t2, $t2, 1
j bricks_3a
bricks_3b:
add $t6, $t5, 240
beq $t3, $t6, bricks_3c
add $t2, $zero, 0
add $t3, $t3, 4
j bricks_3a
bricks_3c:
beq $t5, 1536, bricks_3e
add $t5, $t5, 256
j bricks_3d
bricks_3e:

# paint paddle
lw $t0, ADDR_DSPL
lw $t2, PADDLE_POS
add $t2, $t2, $t0
li $t1, 0x4287f5
sw $t1, 0($t2)
sw $t1, 4($t2)
li $t1, 0x4287f6
sw $t1, 8($t2)
sw $t1, 12($t2)

# paint second paddle
lw $t0, ADDR_DSPL
lw $t2, SND_PADDLE_POS
add $t2, $t2, $t0
li $t1, 0x4287f5
sw $t1, 0($t2)
sw $t1, 4($t2)
li $t1, 0x4287f6
sw $t1, 8($t2)
sw $t1, 12($t2)

# paint ball
lw $t0, ADDR_DSPL
li $t1, 0xff0000
lw $t2, BALL_POS
add $t2, $t2, $t0
sw $t1, 0($t2)

game_loop:

# exit if time limit passed
li $v0, 30
syscall
lw $t0, START_TIME
li $t5, -1
mult, $t0, $t5
mflo $t8
add $t1, $a0, $t8
li $t6, 10000
bgt $t1, $t6, game_over

# unbreacable bricks
lw $t0, ADDR_DSPL
li $t1, 0x555556
li $t2, 1676
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 1680
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 1688
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 1692
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 236
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 240
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 228
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 224
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 216
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 212
add $t2, $t2, $t0
sw $t1, 0($t2)

lw $t0, ADDR_KBRD
lw $t1, 0($t0)
bne $t1, 1, key_end
lw $a0, 4($t0)

# if 'q' is pressed (exit)
beq $a0, 0x71, exit

# if 'p' is pressed (pause)
bne $a0, 0x70, key_p_end
pause_loop:
lw $t0, ADDR_KBRD
lw $t1, 0($t0)
bne $t1, 1, pause_loop
lw $a0, 4($t0)
beq $a0, 0x75, key_p_end
j pause_loop
key_p_end:

# if 'a' is not pressed
bne $a0, 0x61, key_a_end
# paint current paddle as black
lw $t0, ADDR_DSPL
li $t1, 0xf000000
lw $t2, PADDLE_POS
beq $t2, 3588, key_a_end
add $t2, $t2, $t0
sw $t1, 0($t2)
sw $t1, 4($t2)
sw $t1, 8($t2)
sw $t1, 12($t2)
# paint paddle one pixel to the left
la $t0, PADDLE_POS
lw $t1, PADDLE_POS
lw $t2, ADDR_DSPL
add $t1, $t1, -4
sw $t1, 0($t0)
add $t1, $t1, $t2
li $t3, 0x4287f5
sw $t3, 0($t1)
sw $t3, 4($t1)
li $t3, 0x4287f6
sw $t3, 8($t1)
sw $t3, 12($t1)
key_a_end:

# if 'd' is not pressed
bne $a0, 0x64, key_d_end
# paint current paddle as black
lw $t0, ADDR_DSPL
li $t1, 0xf000000
lw $t2, PADDLE_POS
beq $t2, 3692, key_d_end
add $t2, $t2, $t0
sw $t1, 0($t2)
sw $t1, 4($t2)
sw $t1, 8($t2)
sw $t1, 12($t2)
# paint paddle one pixel to the left
la $t0, PADDLE_POS
lw $t1, PADDLE_POS
lw $t2, ADDR_DSPL
add $t1, $t1, 4
sw $t1, 0($t0)
add $t1, $t1, $t2
li $t3, 0x4287f5
sw $t3, 0($t1)
sw $t3, 4($t1)
li $t3, 0x4287f6
sw $t3, 8($t1)
sw $t3, 12($t1)
key_d_end:

# if 'z' is not pressed
bne $a0, 0x7a, key_z_end
# paint current paddle as black
lw $t0, ADDR_DSPL
li $t1, 0xf000000
lw $t2, SND_PADDLE_POS
beq $t2, 3716, key_z_end
add $t2, $t2, $t0
sw $t1, 0($t2)
sw $t1, 4($t2)
sw $t1, 8($t2)
sw $t1, 12($t2)
# paint paddle one pixel to the left
la $t0, SND_PADDLE_POS
lw $t1, SND_PADDLE_POS
lw $t2, ADDR_DSPL
add $t1, $t1, -4
sw $t1, 0($t0)
add $t1, $t1, $t2
li $t3, 0x4287f5
sw $t3, 0($t1)
sw $t3, 4($t1)
li $t3, 0x4287f6
sw $t3, 8($t1)
sw $t3, 12($t1)
key_z_end:

# if 'c' is not pressed
bne $a0, 0x63, key_c_end
# paint current paddle as black
lw $t0, ADDR_DSPL
li $t1, 0xf000000
lw $t2, SND_PADDLE_POS
beq $t2, 3820, key_c_end
add $t2, $t2, $t0
sw $t1, 0($t2)
sw $t1, 4($t2)
sw $t1, 8($t2)
sw $t1, 12($t2)
# paint paddle one pixel to the left
la $t0, SND_PADDLE_POS
lw $t1, SND_PADDLE_POS
lw $t2, ADDR_DSPL
add $t1, $t1, 4
sw $t1, 0($t0)
add $t1, $t1, $t2
li $t3, 0x4287f5
sw $t3, 0($t1)
sw $t3, 4($t1)
li $t3, 0x4287f6
sw $t3, 8($t1)
sw $t3, 12($t1)
key_c_end:

# if 'r' is not pressed
bne $a0, 0x72, key_r_end
r:
lw $t2, ADDR_DSPL
lw $t3, BALL_POS
add $t4, $t2, $t3
li $t5, 0x000000
sw $t5, 0($t4)
la $t0, BALL_POS
li $t1, 3480
li $v0, 42
li $a0, 0
li $a1, 20
syscall
li $t7, 4
mult $a0, $t7
mflo $t8
add $t1, $t1, $t8
sw $t1, 0($t0)
la $t0, BALL_DIR
li $t1, 1
sw $t1, 0($t0)
key_r_end:

key_end:

# if ball reached the bottom
lw $t0, BALL_POS
lw $t1, ADDR_DSPL
add $t2, $t0, $t1
add $t2, $t2, 4
add $t6, $t2, -8
li $t3, 0x000003
li $t5, 0x777778
lw $t4, 0($t2)
lw $t9, 0($t6)
beq $t3, $t4, remove_life
bne $t5, $t4, end_bottom_reached
beq $t3, $t9, remove_life
end_bottom_reached:

# if ball in left corner
lw $t0, BALL_POS
beq $t0, 132, ball_down_right
# if ball in right corner
lw $t0, BALL_POS
beq $t0, 248, ball_down_left

# if ball dir is up left
lw $t0, BALL_DIR
bne $t0, 0, end_up_left_branch
# if ball in brick
lw $t0, BALL_POS
lw $t1, ADDR_DSPL
add $t2, $t0, -4
add $t2, $t2, $t1
add $t3, $t0, 4
add $t3, $t3, $t1
li $t4, 0xffabab
li $t5, 0xabe9ff
li $t6, 0xfffcab
li $t7, 0x000000
li $a0, 0x555556
lw $t8, 0($t2)
lw $t9, 0($t3)
# (left == black) and (right == red or right == blue or right == yellow)
add $t3, $t0, 8
add $t3, $t3, $t1
lw $t9, 0($t3)
bne $t9, $t7, end_up_left_left_black
add $t3, $t0, 4
add $t3, $t3, $t1
lw $t9, 0($t3)
bne $t8, $t7, end_up_left_left_black
beq $t9, $t4, up_left_remove_brick_right
beq $t9, $t5, up_left_remove_brick_right
beq $t9, $t6, up_left_remove_brick_right
beq $t9, $a0, ball_down_left
j end_up_left_left_black
up_left_remove_brick_right:
sw $t7, 0($t3)
# sound
li $v0, 33
li $t0, 50
li $t1, 200
li $t2, 50
li $t3, 120
add $a0, $t0, $zero
add $a1, $t1, $zero
add $a2, $t1, $zero
add $a3, $t1, $zero
syscall
j ball_down_left
end_up_left_left_black:
# (right == black) and (left == red or left == blue or left == yellow)
add $t3, $t0, -8
add $t3, $t3, $t1
lw $t9, 0($t3)
bne $t9, $t7, end_up_left_right_black
add $t3, $t0, 4
add $t3, $t3, $t1
lw $t9, 0($t3)
bne $t9, $t7, end_up_left_right_black
beq $t8, $t4, up_left_remove_brick_left
beq $t8, $t5, up_left_remove_brick_left
beq $t8, $t6, up_left_remove_brick_left
beq $t8, $a0, ball_down_right
j end_up_left_right_black
up_left_remove_brick_left:
sw $t7, 0($t2)
# sound
li $v0, 33
li $t0, 50
li $t1, 200
li $t2, 50
li $t3, 120
add $a0, $t0, $zero
add $a1, $t1, $zero
add $a2, $t1, $zero
add $a3, $t1, $zero
syscall
j ball_down_right
end_up_left_right_black:
# if next ball move in left wall
lw $t0, BALL_POS
lw $t2, ADDR_DSPL
add $t1, $zero, $t0
add $t1, $t1, -132
add $t1, $t1, $t2
lw $t3, 0($t1)
li $t4, 0x777776
beq $t3, $t4, ball_up_right
# if next ball move in top wall
lw $t0, BALL_POS
lw $t2, ADDR_DSPL
add $t1, $zero, $t0
add $t1, $t1, -132
add $t1, $t1, $t2
lw $t3, 0($t1)
li $t4, 0x777777
beq $t3, $t4, ball_down_left
end_up_left_branch:

# if ball dir is up right
lw $t0, BALL_DIR
bne $t0, 1, end_up_right_branch
# if ball in brick
lw $t0, BALL_POS
lw $t1, ADDR_DSPL
add $t2, $t0, -4
add $t2, $t2, $t1
add $t3, $t0, 4
add $t3, $t3, $t1
li $t4, 0xffabab
li $t5, 0xabe9ff
li $t6, 0xfffcab
li $t7, 0x000000
li $a0, 0x555556
lw $t8, 0($t2)
lw $t9, 0($t3)
# (left == black) and (right == red or right == blue or right == yellow)
add $t3, $t0, 8
add $t3, $t3, $t1
lw $t9, 0($t3)
bne $t9, $t7, end_up_right_left_black
add $t3, $t0, 4
add $t3, $t3, $t1
lw $t9, 0($t3)
bne $t8, $t7, end_up_right_left_black
beq $t9, $t4, up_right_remove_brick_right
beq $t9, $t5, up_right_remove_brick_right
beq $t9, $t6, up_right_remove_brick_right
beq $t9, $a0, ball_down_left
j end_up_right_left_black
up_right_remove_brick_right:
sw $t7, 0($t3)
# sound
li $v0, 33
li $t0, 50
li $t1, 200
li $t2, 50
li $t3, 120
add $a0, $t0, $zero
add $a1, $t1, $zero
add $a2, $t1, $zero
add $a3, $t1, $zero
syscall
j ball_down_left
end_up_right_left_black:
# (right == black) and (left == red or left == blue or left == yellow)
add $t3, $t0, -8
add $t3, $t3, $t1
lw $t9, 0($t3)
bne $t9, $t7, end_up_right_right_black
add $t3, $t0, 4
add $t3, $t3, $t1
lw $t9, 0($t3)
bne $t9, $t7, end_up_right_right_black
beq $t8, $t4, up_right_remove_brick_left
beq $t8, $t5, up_right_remove_brick_left
beq $t8, $t6, up_right_remove_brick_left
beq $t8, $a0, ball_down_right
j end_up_right_right_black
up_right_remove_brick_left:
sw $t7, 0($t2)
# sound
li $v0, 33
li $t0, 50
li $t1, 200
li $t2, 50
li $t3, 120
add $a0, $t0, $zero
add $a1, $t1, $zero
add $a2, $t1, $zero
add $a3, $t1, $zero
syscall
j ball_down_right
end_up_right_right_black:
# if next ball move in right wall
lw $t0, BALL_POS
lw $t2, ADDR_DSPL
add $t1, $zero, $t0
add $t1, $t1, -124
add $t1, $t1, $t2
lw $t3, 0($t1)
li $t4, 0x777778
beq $t3, $t4, ball_up_left
# if next ball move in top wall
lw $t0, BALL_POS
lw $t2, ADDR_DSPL
add $t1, $zero, $t0
add $t1, $t1, -124
add $t1, $t1, $t2
lw $t3, 0($t1)
li $t4, 0x777777
beq $t3, $t4, ball_down_right
end_up_right_branch:

# if ball dir is down left
lw $t0, BALL_DIR
bne $t0, 2, end_down_left_branch
# if ball in brick
lw $t0, BALL_POS
lw $t1, ADDR_DSPL
add $t2, $t0, -4
add $t2, $t2, $t1
add $t3, $t0, 4
add $t3, $t3, $t1
li $t4, 0xffabab
li $t5, 0xabe9ff
li $t6, 0xfffcab
li $t7, 0x000000
li $a0, 0x555556
lw $t8, 0($t2)
lw $t9, 0($t3)
# (left == black) and (right == red or right == blue or right == yellow)
add $t3, $t0, 8
add $t3, $t3, $t1
lw $t9, 0($t3)
bne $t9, $t7, end_down_left_left_black
add $t3, $t0, 4
add $t3, $t3, $t1
lw $t9, 0($t3)
bne $t8, $t7, end_down_left_left_black
beq $t9, $t4, down_left_remove_brick_right
beq $t9, $t5, down_left_remove_brick_right
beq $t9, $t6, down_left_remove_brick_right
beq $t9, $a0, ball_up_left
j end_down_left_left_black
down_left_remove_brick_right:
sw $t7, 0($t3)
# sound
li $v0, 33
li $t0, 50
li $t1, 200
li $t2, 50
li $t3, 120
add $a0, $t0, $zero
add $a1, $t1, $zero
add $a2, $t1, $zero
add $a3, $t1, $zero
syscall
j ball_up_left
end_down_left_left_black:
# (right == black) and (left == red or left == blue or left == yellow)
add $t3, $t0, -8
add $t3, $t3, $t1
lw $t9, 0($t3)
bne $t9, $t7, end_down_left_right_black
add $t3, $t0, 4
add $t3, $t3, $t1
lw $t9, 0($t3)
bne $t9, $t7, end_down_left_right_black
beq $t8, $t4, down_left_remove_brick_left
beq $t8, $t5, down_left_remove_brick_left
beq $t8, $t6, down_left_remove_brick_left
beq $t8, $a0, ball_up_right
j end_down_left_right_black
down_left_remove_brick_left:
sw $t7, 0($t2)
# sound
li $v0, 33
li $t0, 50
li $t1, 200
li $t2, 50
li $t3, 120
add $a0, $t0, $zero
add $a1, $t1, $zero
add $a2, $t1, $zero
add $a3, $t1, $zero
syscall
j ball_up_right
end_down_left_right_black:

# if next ball move in paddle left
lw $t0, BALL_POS
lw $t2, ADDR_DSPL
add $t1, $zero, $t0
add $t1, $t1, 124
add $t1, $t1, $t2
lw $t3, 0($t1)
li $t4, 0x4287f5
beq $t3, $t4, ball_up_left
# if next ball move in paddle right
lw $t0, BALL_POS
lw $t2, ADDR_DSPL
add $t1, $zero, $t0
add $t1, $t1, 124
add $t1, $t1, $t2
lw $t3, 0($t1)
li $t4, 0x4287f6
beq $t3, $t4, ball_up_right
# if next ball move in left wall
lw $t0, BALL_POS
lw $t2, ADDR_DSPL
add $t1, $zero, $t0
add $t1, $t1, 124
add $t1, $t1, $t2
lw $t3, 0($t1)
li $t4, 0x777776
beq $t3, $t4, ball_down_right
#if next ball move out
end_down_left_branch:

# if ball dir is down right
lw $t0, BALL_DIR
bne $t0, 3, end_down_right_branch
# if ball in brick
lw $t0, BALL_POS
lw $t1, ADDR_DSPL
add $t2, $t0, -4
add $t2, $t2, $t1
add $t3, $t0, 4
add $t3, $t3, $t1
li $t4, 0xffabab
li $t5, 0xabe9ff
li $t6, 0xfffcab
li $t7, 0x000000
li $a0, 0x555556
lw $t8, 0($t2)
lw $t9, 0($t3)
# (left == black) and (right == red or right == blue or right == yellow)
add $t3, $t0, 8
add $t3, $t3, $t1
lw $t9, 0($t3)
bne $t9, $t7, end_down_right_left_black
add $t3, $t0, 4
add $t3, $t3, $t1
lw $t9, 0($t3)
bne $t8, $t7, end_down_right_left_black
beq $t9, $t4, down_right_remove_brick_right
beq $t9, $t5, down_right_remove_brick_right
beq $t9, $t6, down_right_remove_brick_right
beq $t9, $a0, ball_up_left
j end_down_right_left_black
down_right_remove_brick_right:
sw $t7, 0($t3)
# sound
li $v0, 33
li $t0, 50
li $t1, 200
li $t2, 50
li $t3, 120
add $a0, $t0, $zero
add $a1, $t1, $zero
add $a2, $t1, $zero
add $a3, $t1, $zero
syscall
j ball_up_left
end_down_right_left_black:
# (right == black) and (left == red or left == blue or left == yellow)
add $t3, $t0, -8
add $t3, $t3, $t1
lw $t9, 0($t3)
bne $t9, $t7, end_down_right_right_black
add $t3, $t0, 4
add $t3, $t3, $t1
lw $t9, 0($t3)
bne $t9, $t7, end_down_right_right_black
beq $t8, $t4, down_right_remove_brick_left
beq $t8, $t5, down_right_remove_brick_left
beq $t8, $t6, down_right_remove_brick_left
beq $t8, $a0, ball_up_right
j end_down_right_right_black
down_right_remove_brick_left:
sw $t7, 0($t2)
# sound
li $v0, 33
li $t0, 50
li $t1, 200
li $t2, 50
li $t3, 120
add $a0, $t0, $zero
add $a1, $t1, $zero
add $a2, $t1, $zero
add $a3, $t1, $zero
syscall
j ball_up_right
end_down_right_right_black:
# if next ball move in paddle left
lw $t0, BALL_POS
lw $t2, ADDR_DSPL
add $t1, $zero, $t0
add $t1, $t1, 132
add $t1, $t1, $t2
lw $t3, 0($t1)
li $t4, 0x4287f5
beq $t3, $t4, ball_up_left
# if next ball move in paddle right
lw $t0, BALL_POS
lw $t2, ADDR_DSPL
add $t1, $zero, $t0
add $t1, $t1, 132
add $t1, $t1, $t2
lw $t3, 0($t1)
li $t4, 0x4287f6
beq $t3, $t4, ball_up_right
# if next ball move in brick
# if next ball move in right wall
lw $t0, BALL_POS
lw $t2, ADDR_DSPL
add $t1, $zero, $t0
add $t1, $t1, 132
add $t1, $t1, $t2
lw $t3, 0($t1)
li $t4, 0x777778
beq $t3, $t4, ball_down_left
#if next ball move out
end_down_right_branch:

# if no collision, ball doesn't change direction
lw $t0, BALL_DIR
beq $t0, 0, ball_up_left
beq $t0, 1, ball_up_right
beq $t0, 2, ball_down_left
beq $t0, 3, ball_down_right

# move ball 1 pixel up and 1 pixel left
ball_up_left:
la $t0, BALL_DIR
li $t1, 0
sw $t1, 0($t0)
la $t0, BALL_POS
lw $t1, BALL_POS
lw $t2, ADDR_DSPL
# paint ball as black
add $t4, $zero, 0
add $t4, $t4, $t1
add $t4, $t4, $t2
li $t3, 0x000000
sw $t3, 0($t4)
# paint ball 1 pixel up and 1 pixel left
add $t1, $t1, -132
sw $t1, 0($t0)
add $t1, $t1, $t2
li $t3, 0xff0000
sw $t3, 0($t1)
j end_ball_movement

# move ball 1 pixel up and 1 pixel right
ball_up_right:
la $t0, BALL_DIR
li $t1, 1
sw $t1, 0($t0)
la $t0, BALL_POS
lw $t1, BALL_POS
lw $t2, ADDR_DSPL
# paint ball as black
add $t4, $zero, 0
add $t4, $t4, $t1
add $t4, $t4, $t2
li $t3, 0x000000
sw $t3, 0($t4)
# paint ball 1 pixel up and 1 pixel right
add $t1, $t1, -124
sw $t1, 0($t0)
add $t1, $t1, $t2
li $t3, 0xff0000
sw $t3, 0($t1)
j end_ball_movement

# move ball 1 pixel down and 1 pixel left
ball_down_left:
la $t0, BALL_DIR
li $t1, 2
sw $t1, 0($t0)
la $t0, BALL_POS
lw $t1, BALL_POS
lw $t2, ADDR_DSPL
# paint ball as black
add $t4, $zero, 0
add $t4, $t4, $t1
add $t4, $t4, $t2
li $t3, 0x000000
sw $t3, 0($t4)
# paint ball 1 pixel down and 1 pixel left
add $t1, $t1, 124
sw $t1, 0($t0)
add $t1, $t1, $t2
li $t3, 0xff0000
sw $t3, 0($t1)
j end_ball_movement

# move ball 1 pixel down and 1 pixel right
ball_down_right:
la $t0, BALL_DIR
li $t1, 3
sw $t1, 0($t0)
la $t0, BALL_POS
lw $t1, BALL_POS
lw $t2, ADDR_DSPL
# paint ball as black
add $t4, $zero, 0
add $t4, $t4, $t1
add $t4, $t4, $t2
li $t3, 0x000000
sw $t3, 0($t4)
# paint ball 1 pixel down and 1 pixel right
add $t1, $t1, 132
sw $t1, 0($t0)
add $t1, $t1, $t2
li $t3, 0xff0000
sw $t3, 0($t1)
j end_ball_movement

end_ball_movement:

# sleep
li $v0, 32
li $a0, 150
syscall

j game_loop

exit:
li $v0, 10
syscall

remove_life:
la $t0, NUM_LIVES
lw $t1, NUM_LIVES
li $t9, -1
add $t2, $t1, $t9
sw $t2, 0($t0)
beq $t2, 0, game_over
j r

game_over:

# sound
li $v0, 33
li $t0, 50
li $t1, 2000
li $t2, 50
li $t3, 120
add $a0, $t0, $zero
add $a1, $t1, $zero
add $a2, $t1, $zero
add $a3, $t1, $zero
syscall

# game over screen
lw $t0, ADDR_DSPL
li $t1, 0x555555
add $t2, $zero, -4
all_gray:
beq $t2, 6000, all_gray_end
add $t2, $t2, 4
add $t3, $t0, $t2
sw $t1, 0($t3)
j all_gray
all_gray_end:
lw $t0, ADDR_DSPL
li $t1, 0xff5555
li $t2, 3464
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3468
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3336
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3208
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3212
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3476
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3480
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3352
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3224
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3220
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3488
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3496
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3504
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3512
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3528
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3360
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3364
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3368
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3372
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3376
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3384
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3256
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3260
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3516
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3532
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3536
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3400
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3272
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3276
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3280
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3408
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3548
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3416
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3288
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3424
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3296
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3416
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3560
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3564
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3432
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3304
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3308
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3572
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3444
add $t2, $t2, $t0
sw $t1, 0($t2)
li $t2, 3448
add $t2, $t2, $t0
sw $t1, 0($t2)

game_over_loop:

lw $t0, ADDR_KBRD
lw $t1, 0($t0)
bne $t1, 1, end_key_x
lw $a0, 4($t0)

bne $a0, 0x78, end_key_x
# reset default values
la $t0, PADDLE_POS
li $t1, 3640
sw $t1, 0($t0)
la $t0, SND_PADDLE_POS
li $t1, 3768
sw $t1, 0($t0)
la $t0, BALL_POS
li $t1, 3512
sw $t1, 0($t0)
la $t0, BALL_DIR
li $t1, 0
sw $t1, 0($t0)
la $t0, NUM_LIVES
li $t1, 3
sw $t1, 0($t0)
# reset display
lw $t0, ADDR_DSPL
li $t1, 0x000000
add $t2, $zero, 0
reset:
beq $t2, 6000, reset_end
add $t2, $t2, 4
add $t3, $t0, $t2
sw $t1, 0($t3)
j reset
reset_end:
# back to main to restart game
j main
end_key_x:

j game_over_loop



