#Morgan Noonan (men83)


.data

	list:			.word	0:10
	request_for_input:	.asciiz	"\nInsert a number: "
	message_list_contents:	.asciiz "\nThe contents of the array are: "
	number: .word 0

.text
.globl main

main:
	# variable i is in register s0
	move	s0, zero			# for( i = 0;
_main_for_insert:
	bge	s0, 10, _reset_count	#      i < 10;
                                  		#      i++) (*) check before main_endForInsert
	## For implementation
	# Print request for input
	li	v0, 4
	la	a0, request_for_input
	syscall					# print_string("\nInsert a number: "); // syscall

	# Get user input
	li	v0, 5
	syscall
	move	s1, v0                  	# The result of the syscall is in v0

	# write list[i]
	# Calculate the memory address of list[i]
	la	t1, list			# Load the address of the list
	li	t2, 4				# Load the size of a word
	mul	t3, s0, t2 			# Multiply i by the size of a word (i*4)
	add	t4, t1, t3 			# Calculate the memory address of element i (list +i*4)
	# Store the user value
	sw	s1, 0(t4)			# list[i] = s1

	addi	s0, s0, 1			# (*) i++
	j	_main_for_insert
_reset_count:
	move s0, zero	#set s0 back to 0
	li v0, 4
	la a0,  message_list_contents	#print message_list_contents
	syscall
_list_contents:
	bge s0, 10, _swapped	#s0>=10 goto _swapped
	
	la t1, list	#load address of list array
	li t2,4		#load immediate 4
	mul t3,s0,t2	#get address
	add t4, t1, t3
	lw t5, 0(t4)	#load word content into t5
	
	li v0, 1
	move a0, t5	#print t5
	syscall
	 
	li v0, 11
	li a0, ' '	#print space
	syscall
	 
	addi s0,s0,1	#increment s0
	j _list_contents
_check: 
	bne s2, 1, _count_reset3	#swapped!=1 jump to _count_reset3
_swapped:
	move s2, zero	#reset s0, and s2 to 0
	move s0, zero
_sort:
	bge s0, 9, _check	#s0>= 9 goto _check for if swapped
	
	la t1, list	#load address of list
	li t2,4
	mul t3,s0,t2	#get content of a[i]
	add t4, t1, t3
	lw t5, 0(t4) #1 a[i]=t5

	add t6, s0, 1
	mul t7,t6,t2	#get content of a[i+1]
	add t8,t1,t7
	lw t9, 0(t8) #2 a[i+1]=t9
	
	bge t5,t9, _swap	#t5>=t9 _swap
	addi s0,s0,1		#increment s0
	j _sort
	
_swap: 
	sw t5, 0(t8)	#swap content
	sw t9, 0(t4)
	
	li s2, 1	#swapped = 1 
	addi s0,s0,1	#increment s0
	j _sort
_count_reset3:
	move s0, zero	#reset s0 back to 0
	li v0, 4
	la a0,  message_list_contents	#print message_list_contents
	syscall
_list:
	bge s0, 10, _exit_code	#s0>=10 goto _ext_code
	
	la t1, list	#load address of list array
	li t2,4		#load immediate 4
	mul t3,s0,t2	#get address
	add t4, t1, t3
	lw t5, 0(t4)	#load word content into t5
	
	li v0, 1
	move a0, t5	#print t5
	syscall
	 
	li v0, 11
	li a0, ' '	#print space
	syscall
	 
	addi s0,s0,1	#increment s0
	j _list
_exit_code:
	# Exit
	li v0, 10
	syscall
	
