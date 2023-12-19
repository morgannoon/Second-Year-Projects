#Morgan Noonan (men83)

.data
.text
get_bit:
	srl v0,a0,a1
	and v0,v0,1
	jr ra
set_bit:
	li t0,1
	sll t0,t0,a1
	or v0,t0,a0
	jr ra

reset_bit:
	li t0,1
	sll t0,t0,a1
	not t0,t0
	and v0,t0,a0
	jr ra
