#Morgan Noonan (men83)
.data
  returned: .asciiz "The function returned\n"
.text
.globl main

main:
  # Decode the first instruction in function "func" (addi v0, zero, 0x1337)
  la a0, func
  jal decode_instruction

  # Encode the instruction addi v0, zero, 0x1234
  li a0, 8
  li a1, 0
  li a2, 2
  li a3, 0x1234
  jal encode_instruction

  # Print string
  la a0, returned
  li v0, 4
  syscall
  # Call function
  jal func
  # Print return value
  move a0, v0
  li v0, 34
  syscall

  # Exit
  li v0, 10
  syscall

func:
	addi v0, zero, 0x1337
	jr ra

# Prints the different fields of an I-type instruction
# decode_instruction(a0: memory address of instruction)
decode_instruction:
	move a1,a0		#a1 has instruction
	srl a0,a1,26
	and a0,a0,0x3F
	li v0,1
	syscall
	
	li a0, '\n'
	li v0,11
	syscall
	
	srl a0,a1,21
	and a0,a0,0x1F
	li v0,1
	syscall
	
	li a0, '\n'
	li v0,11
	syscall
	
	srl a0,a1, 16
	and a0,a0,0x1F
	li v0,1
	syscall
	
	li a0, '\n'
	li v0,11
	syscall
	
	and a0,a1,0xFFFF
	li v0,34
	syscall
	
	li a0, '\n'
	li v0,11
	syscall
	
	jr ra


# Encodes the fields of an I-type instruction and returns it
# encode_instruction(a0: opcode, a1: rs, a2: rt, a3: immediate)
encode_instruction:
	
	li t0,0
	sll t0,a0,26
	sll a1,a1,21
	sll a2,a2,16
	or t0,t0,a1
	or t0,t0,a2
	or t0,t0,a3
	move a0,t0
	li v0, 34
	syscall
	
	li a0,'\n'
	li v0,11
	syscall
	
  	jr ra

