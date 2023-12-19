#Morgan Noonan (men83)
.data
	menu_welcome: .asciiz "=================================\nWelcome to TNW, let's play a game\n=================================\nWhat do you want to do?\n(1) Play\t(2)Quit\n"
	play_quit: .word 0
	buffer: .space,6 
	words_matrix: .byte 'a''r''e''n''a''i''m''a''g''e''p''l''a''n''t''w''h''a''l''e''r''o''m''a''n'
	ask_for_guess: .asciiz "Input a five letter word: "
	lost: .asciiz "Too many guesses you lost\nIt was  "
	win: .asciiz "You won! The correct word was "
	wrong: .asciiz "incorrect guess"
	myGuess: .byte 'a' 'a' 'a' 'a' 'a'
		# Outputs v0: The address of the element
	
.text
#s0: guess count
#s1: wrong word flag
#s2:stores a0
#s3: stores a1
#s4:word length increment for check_letters

#a0: words_matrix address
#a1: myGuess address
#a2: column count
#a3:matches letter/any part of the word

get_letter:
push ra
	lb a0,(a1)
	li v0,11
	syscall
pop ra
jr ra
matches_letter:
push ra
	lb t0, (a1)
	lb t1,(a0)
	beq t0,t1,_exit
	li s1,1		#s1 = 1 flag wrong word
	li a3,0		#a3 = 0 no match
	jr ra
	_exit:
	li a3,1		#a3 = 1 match
pop ra
jr ra
matches_any_part_of_word: 
	push ra
	lb t0, (a1)
	li t2, 0
	_loop:
	beq t2,5,_exit
	add t3,t2,s2
	lb t1,(t3)
	beq t0,t1, _break
	addi t2,t2,1
	j _loop			
	_break:
	li a3,1		#a3 = 1 match
	_exit:
	pop ra
	jr ra		#a3 = 0 no match
print_word:
push ra
	move t0, a0
	li t1,0
	_inner_loop:	#print out word
	bge t1,5, _exit
	move a1,t0
	jal get_letter
	addi t1,t1,1
	addi t0,t0,1
	j _inner_loop
	_exit:
	pop ra
	jr ra
	
.globl main
main:

_menu:
la a0, menu_welcome		#welcome menu
li v0, 4
syscall

li v0, 5			#read play/quit input
syscall
bge v0, 2, _quit

li v0, 42			#randomly select word
li a0, 0			# v0 = syscall(GET_RANDOM_INT, 0, 5);
li a1, 5
syscall	

la a0, words_matrix		#load in address of matrix = a0	
mul t0, v0,5
add a0,a0,t0			#set to a0=row
move s2,a0			#store address of byte in s2 (address of word)
li a2, -1			#load in column count
li s4, -1

li s1,0 			#wrong word flag (if =1 wrong word, if =0 correct word)
li s0,0 			#guess count
	
_guess:
	beq s0,5,_lost
	la a0, ask_for_guess	#ask for guess
	li v0, 4
	syscall
	
	#read guess
	la t0, myGuess
	li v0,12
	syscall
	sb v0, (t0)
	
	li v0,12
	syscall
	sb v0, 1(t0)
	
	li v0,12
	syscall
	sb v0, 2(t0)
	
	li v0,12
	syscall
	sb v0, 3(t0)
	
	li v0,12
	syscall
	sb v0, 4(t0)
	

	la a1,myGuess
	move s3,a1
	
	
	li a0, '\n'
	li v0, 11
	syscall
	move a2, s4
_check_letters:
addi a2,a2,1
beq a2,5, _check_flag
	_check_spot:
		li a3,0				#if matches letter =1
		move a0,s2
		add a0,a0,a2
		move a1,s3
		add a1,a1,a2
		
		jal matches_letter
		bne a3,1, _check_word
		
		li a0, '['
		li v0,11
		syscall
		
		move a0,s2
		add a0,a0,a2		#print letter
		jal get_letter
		
		li a0, ']'
		li v0,11
		syscall
		
		j _check_letters
	_check_word:
		add a0, s2, a2
		add a1, s3, a2
		li a3,0
		jal matches_any_part_of_word	#if letter matches any part of word
		bne a3,1, _skip
		li a0, '('
		li v0,11
		syscall
	
		move a0,s2
		add a0,a0,a2		#print letter
		jal get_letter
		
		li a0, ')'
		li v0,11
		syscall
		j _check_letters
	_skip:
		move a0,s2		#reset a0 address 
		add a0,a0,a2		#load in column count to address
		jal get_letter		#does not match any part of word, print letter
		j _check_letters
	
	_check_flag:
	beq s1,0,_win
	li s1,0
	
	li a0,'\n'
	li v0,11
	syscall
	
	la a0, wrong
	li v0,4
	syscall
	add s0,s0,1
	
	li a0,'\n'
	li v0,11
	syscall
	j _guess
		
	_win:
	la a0, win
	li v0,4
	syscall
	
	li a0,'\n'
	li v0,11
	syscall
	
	move a0,s2		#reset a0 address 
	li a2, 0		#load in column count
	jal print_word
	
	li a0,'\n'
	li v0,11
	syscall
	
	j _menu
	
	_lost:
	la a0, lost	#print lost
	li v0, 4
	syscall
	move a0,s2		#reset a0 address 
	move a2,s4		#load in column count
	jal print_word
	j _quit
	
_quit:
li v0, 10
syscall


