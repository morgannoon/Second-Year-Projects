
.include "macros.asm"

.globl up_pressed
.globl down_pressed
.globl left_pressed
.globl right_pressed
.globl action_pressed

# The status of each button I use
.data

up_pressed:	.word	0
down_pressed:	.word	0
left_pressed:	.word	0
right_pressed:	.word	0
action_pressed:	.word	0
