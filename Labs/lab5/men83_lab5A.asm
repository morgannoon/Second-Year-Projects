#Morgan Noonan (men83)
.data
	a: .word 2
	b: .word 12
.text
.globl main
main:

	lw a0 a
	lw a1 b
	
	jal func
	
	move a0,v0
	li v0,1
	syscall
	
	li v0, 10
	syscall

# Multiply 2 4-bit numbers!
# s0 -->a0 - input number one
# t1 --> a1 - input number two
# s0-->v0 - return value
func:
	move	t0, a0
	move	t3, a1
	li	t4, 0
	li	a1, 1
	li	t2, 4
_func_do:
	and	t9, t3, a1
	beq	t9, zero, _func_endif
	add	t4, t4, t0
_func_endif:
	sll	t0, t0, 1
	sll	a1, a1, 1
	sub	t2, t2, 1
	bne	t2, zero, _func_do
	move	v0, t4
	jr	ra	#return to main
