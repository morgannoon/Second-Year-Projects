#Morgan Noonan (men83)
.text
.globl main
main:
	li	s0, 0x1337BEEF
	li	s1, 0x00C0FFEE

	jal	function

	li	v0, 10
	syscall		# terminate program

function:
	sub sp,sp,4	#push	ra
	sw ra ,(sp)
	
	sub sp,sp,4	#push	s0
	sw s0, (sp)
	
	sub sp,sp,4	#push	s1
	sw s1,(sp)

	li	s0, 54
	addi	s1, s0, 100

	lw s1, (sp)	#pop	s1
	add sp,sp,4
	
	lw s0, (sp)	#pop	s0
	add sp,sp,4
		
	lw ra, (sp)	#pop	ra
	add sp,sp,4

	jr	ra