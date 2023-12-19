# Morgan Noonan (men83)

.data
	str: .asciiz "What is the first value?\n"
	str2: .asciiz "\nWhat is anothor value?\n"
	dash: .asciiz "-"
	equal: .asciiz "="
	a: .word 0
	b: .word 0
	c: .word 0
.text
.global main
main: 
#A
	la a0, str    # printString(str)
 	li v0, 4
 	syscall

	li v0, 5      # a = getInteger()
 	syscall
 	sw v0, a
		move t0, v0

  	li v0, 11     # printChar('\n')
  	li a0, '\n'   # equivalent to printChar(10)
  	syscall

 	li v0, 1      # printInteger(a)
  	lw a0, a
  	syscall

#B
	la a0, str2    # printString(str2)
  	li v0, 4
  	syscall

  	li v0, 5      # a = getInteger()
  	syscall
  	sw v0, b
		move t1, v0
	
  	li v0, 11     # printChar('\n')
  	li a0, '\n'   # equivalent to printChar(10)
  	syscall

  	li v0, 1      # printInteger(b)
  	lw a0, b
  	syscall
 #C
	sub t2, t0,t1	#subtract
	sw, t2, c
	
	li v0, 11	#printChar('\n')
	li a0, '\n'
	syscall
#print equation
	li v0, 1	#print a
	lw a0, a
	syscall

	la a0, dash	#print dash
	li v0, 4
	syscall

	li v0, 1	#print b
	lw a0, b
	syscall

	la a0, equal	#print equal
	li v0, 4
	syscall

	li v0, 1	#printInteger(c)
	lw, a0, c
	syscall

  	li v0, 10     # exit() - stops the program
  	syscall
