# Morgan Noonan (men83)

.data

	input: .asciiz "Input a number between 0-99:"
	tooLow: .asciiz "You're too low\n"
	tooHigh: .asciiz "You're too high\n"
	cold: .asciiz "You're cold\n"
	warm: .asciiz "You're warm\n"
	lost: .asciiz "You lost, too many guesses! It was\n"
	win: .asciiz "You won!\n"
	myGuess: .word 0
	answer: .word 0
.text
.globl main

main:
	li v0, 42
	li a0, 0
	li a1, 100
	syscall			# v0 = syscall(GET_RANDOM_INT, 0, 100);
	sw v0, answer
	li t0, 0
	
_loop:
	beq, t0, 5,_end		#out of guesses end
	li v0, 4
	la a0, input		#print input
	syscall
	
	li v0, 5 		#read guess
	syscall
	sw v0, myGuess		#store guess
	lw t1, myGuess 		#load guess in t1
	lw t2, answer		#load answer in t2
		
	bne t1, t2, _compare 	#guess!=random -->compared
	li v0, 4
	la a0, win		#print win
	syscall
	j _break
	
_compare:
	lw t1, myGuess 		#reload guess in t1
	lw t2, answer		#reload answer in t2
	bgt t1, t2, _high	#guess>random -->high
	
	li v0, 4		
	la a0, tooLow		#print tooLow
	syscall
			
	sub t3,t2,10		#t3=random-10
	add t4,t2,10		#t4=random+10
	bge t1, t3, _warm	#guess>=lowbound
	li v0, 4
	la a0, cold		#print cold
	syscall
	j _increment
						
_high:
	lw t1, myGuess 		#reload guess in t1
	lw t2, answer		#reload answer in t2
	
	li v0, 4
	la a0, tooHigh		#print tooHigh
	syscall
			
	
	ble t1, t4, _warm
	li v0, 4
	la a0, cold		#print cold
	syscall
	j _increment
	
_warm:
	li v0, 4
	la a0, warm		#print warm
	syscall
	j _increment
	
_increment: 
	add t0,t0,1 	#increment count
	j _loop		#jump to top
_end:
	li v0, 4
	la a0, lost	#print lost
	syscall	
	
	li v0, 1
	lw a0, answer	#print answer
	syscall
	j _break

_break:
	li v0, 10     # exit() - stops the program
  	syscall
			
