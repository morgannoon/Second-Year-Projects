#Morgan Noonan (men83)

.data
matrix: .word   1, 2, 3, 4, 5, 
		6, 7, 8, 9, 10, 
		11, 12, 13, 14, 15, 
		16, 17, 18, 19, 20, 
		21, 22, 23, 24, 25
.text
# This function calculates the address an element in a array of words
# Inputs:
#	 a0: The base address of the array
#	 a1: The index of the element
# Outputs:
#	 v0: The address of the element
array_element_address:


	mul t0,a1,4	#get content of a[i]
	add v0, a0, t0
	jr ra

# This function calculates the address of the element (i, j) in a matrix of words
# Inputs:
#	 a0: The base address of the matrix
#	 a1: The index (i) of the row
#	 a2: The index (j) of the column
#	 a3: The number of elements in a row
# Outputs:
#	 v0: The address of the element
matrix_element_address:
	
	mul t1, a1, a3	#t0=row
	add t1, t1, a2	#t0= row,col
	mul t1,t1,4
	add v0, a0, t1
	jr ra
.globl main
main:
	li s0, 0
	
_loop:
	bge s0, 25, _end_loop
	move a1, s0
	la a0, matrix
	jal array_element_address
	
	lw a0, (v0)
	li v0, 1
	syscall
	
	li a0 , ' ' 
	li v0, 11
	syscall
	
	addi s0,s0,1 
	j _loop
_end_loop:
	li a0 , '\n' 
	li v0, 11
	syscall
#matrix print
	li s0,0
_loop2:
	li s1, 0
	bge s0,5, _exit
	_inner_loop:
		bge s1,5, _end_inner
		la a0, matrix
		move a1,s0
		move a2, s1
		li a3, 5
		jal matrix_element_address
		
		lw a0, (v0)
		li v0, 1
		syscall
		
		li a0 , ' ' 
		li v0, 11
		syscall
		
		addi s1, s1, 1
		j _inner_loop
	_end_inner:
	addi s0, s0, 1
	j _loop2
_exit:
	li v0, 10
	syscall
