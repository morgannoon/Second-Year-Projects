.data
  a: .byte 0x12, 0x34, 0x56, 0x78
  b: .word 0x12345678

.text
.globl main
main:

	lbu a0, 0x10010000
	li v0, 34
	syscall
	
	li a0, '\n'
	li v0, 11
	syscall
	
	lbu a0, 0x10010001
	li v0, 34
	syscall
	
	li a0, '\n'
	li v0, 11
	syscall
	
	lbu a0, 0x10010002
	li v0, 34
	syscall
	
	li a0, '\n'
	li v0, 11
	syscall
	
	lbu a0, 0x10010003
	li v0, 34
	syscall
	