#Morgan Noonan (men83)
.data
	moving: .asciiz "Moving disk "
	from: .asciiz " from "
	to: .asciiz " to "
.text	
.globl main
main:

	li	a0, 5	# a0 - height of the tower
	li	a1, 'L'	# a1 - source pole
	li	a2, 'R'	# a2 - destination pole
	li	a3, 'C'	# a3 - auxiliary pole
	
	jal solve_hanoi		# call solve_hanoi here

	li	v0, 10
	syscall

solve_hanoi:
	push ra
	push s0
	push s1
	push s2
	push s3
	
	move s0,a0
	move s1,a1
	move s2,a2
	move s3,a3
	 
	beq s0, 0, _base
	sub a0,a0 1
	
	move a2,s3
	move a3, s2
	jal solve_hanoi
	
	la a0, moving
	li v0,4
	syscall
	
	move a0, s0
	li v0, 1
	syscall
	
	la a0, from
	li v0,4
	syscall
	
	move a0, s1
	li v0, 11
	syscall
	
	la a0, to
	li v0,4
	syscall
	
	move a0, s2
	li v0, 11
	syscall
	
	li a0, '\n'
	li v0, 11
	syscall
	
	sub a0,s0,1
	move a1,s3
	move a3, s1
	move a2, s2
	
	jal solve_hanoi
	
_base:
	pop s3
	pop s2
	pop s1
	pop s0
	pop ra
	jr ra
