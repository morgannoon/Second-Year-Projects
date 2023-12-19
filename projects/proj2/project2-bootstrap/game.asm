.include "constants.asm"
.include "macros.asm"


.data
	ghost: .byte -1,4,4,4,-1,4,7,4,7,4,4,0,4,0,4,4,4,4,4,4,4,-1,4,-1,4
	wall: .byte 13,8,5,13,5,5,5,8,5,8,5,13,5,5,13,8,5,5,8,5,5,8,13,5,5
	box: .byte 10,10,10,10,10,10,-1,10,-1,10,10,10,-1,10,10,10,-1,10,-1,10,10,10,10,10,10
	target: .byte 11,0,0,0,11,0,11,0,11,0,0,0,11,0,0,0,11,0,11,0,11,0,0,0,11
	arena: .byte 	1,1,1,1,1,1,1,1,1,1,1,1,
			1,0,0,0,0,0,0,0,0,0,0,1,
			1,0,1,0,1,1,1,1,0,1,0,1,
			1,0,0,0,0,1,1,0,0,0,0,1,
			1,0,1,1,0,0,0,0,1,1,0,1,
			1,0,0,0,0,1,1,0,0,0,0,1,
			1,0,0,0,0,0,0,0,0,0,0,1,
			1,0,1,1,0,0,0,0,1,1,0,1,
			1,0,0,1,0,1,1,0,1,0,0,1,
			1,1,0,0,0,0,0,0,0,0,1,1,
			1,1,1,1,1,1,1,1,1,1,1,1
	moves: .asciiz "MOVES: "
	count: .word 0
	boxes: .byte 	0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,1,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,1,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,1,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,1,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0
	
	targets: .byte 	0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,1,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,1,0,0,0,
			0,1,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,1,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0
	playerx: .byte 1
	playery: .byte 3
.globl game
.text

game:
	enter
	
	#s0 represents game state
	#0 = starting screen
	#1 = level
	#2 = ending screen
	li s0, 0
_game_while:
	

	jal	handle_input


	# Move stuff
	beq s0, 0, _move_start
	beq s0, 1, _move_level
	beq s0, 2, _move_end
	j _move_default
	
	_move_start:
		jal input_get_keys_held
		beq v0, 0, _end_if
			li s0, 1
		_end_if:
		j _move_end_switch
	_move_level:
		jal input_get_keys_pressed
		
		#player movement
		and t0, v0, KEY_UP
		bne t0, 0, _up
		and t0, v0, KEY_DOWN
		bne t0, 0, _down
		and t0, v0, KEY_LEFT
		bne t0, 0, _left
		and t0, v0, KEY_RIGHT
		bne t0, 0, _right
		j _end_switch_player
		_up:
			
			#check for wall
			lb a0, playerx
			lb a1, playery
			add a1, a1, -1
			la a2, arena
			jal collision_check
			#if wall don't move
			beq v0, 1, _end_if_up
			
			#check for box
			lb a0, playerx
			lb a1, playery
			add a1, a1, -1
			la a2, boxes
			jal collision_check
			
			#if box try to move
			beq v0, 0, _else_up
				lb a0, playerx
				lb a1, playery
				add a1, a1, -1
				li a2, 0
				jal try_move_box
				#if box didn't move don't move
				beq v0, 0, _end_if_up
				#else box moved--fall into else
			#else no collision--move player
			_else_up:
				lb t0, playery
				sub t0, t0, 1
				sb t0, playery
				lw t0,count
				add t0,t0,1
				sw t0,count
			_end_if_up:
			j _end_switch_player
		_down:
			#check for wall
			lb a0, playerx
			lb a1, playery
			add a1, a1, 1
			la a2, arena
			jal collision_check
			#if wall don't move
			beq v0, 1, _end_if_down
			
			#check for box
			lb a0, playerx
			lb a1, playery
			add a1, a1, 1
			la a2, boxes
			jal collision_check
			
			#if box try to move
			beq v0, 0, _else_down
				lb a0, playerx
				lb a1, playery
				add a1, a1, 1
				li a2, 1
				jal try_move_box
				#if box didn't move don't move
				beq v0, 0, _end_if_down
				#else box moved--fall into else
			#else no collision--move player
			_else_down:
				lb t0, playery
				add t0, t0, 1
				sb t0, playery
				lw t0,count
				add t0,t0,1
				sw t0,count
			_end_if_down:
			j _end_switch_player
		_left:
			#check for wall
			lb a0, playerx
			lb a1, playery
			add a0, a0, -1
			la a2, arena
			jal collision_check
			#if wall don't move
			beq v0, 1, _end_if_left
			
			#check for box
			lb a0, playerx
			lb a1, playery
			add a0, a0, -1
			la a2, boxes
			jal collision_check
			
			#if box try to move
			beq v0, 0, _else_left
				lb a0, playerx
				lb a1, playery
				add a0, a0, -1
				li a2, 2
				jal try_move_box
				#if box didn't move don't move
				beq v0, 0, _end_if_left
				#else box moved--fall into else
			#else no collision--move player
			_else_left:
				lb t0, playerx
				sub t0, t0, 1
				sb t0, playerx
				lw t0,count
				add t0,t0,1
				sw t0,count
			_end_if_left:
			j _end_switch_player
		_right:
			#check for wall
			lb a0, playerx
			lb a1, playery
			add a0, a0, 1
			la a2, arena
			jal collision_check
			#if wall don't move
			beq v0, 1, _end_if_up
			
			#check for box
			lb a0, playerx
			lb a1, playery
			add a0, a0, 1
			la a2, boxes
			jal collision_check
			
			#if box try to move
			beq v0, 0, _else_right
				lb a0, playerx
				lb a1, playery
				add a0, a0, 1
				li a2, 3
				jal try_move_box
				#if box didn't move don't move
				beq v0, 0, _end_if_right
				#else box moved--fall into else
			#else no collision--move player
			_else_right:
				lb t0, playerx
				add t0, t0, 1
				sb t0, playerx
				lw t0,count
				add t0,t0,1
				sw t0,count
			_end_if_right:
			j _end_switch_player
		_end_switch_player:
		j _move_end_switch
	_move_end:
		#placeholder--empty case
		j _move_end_switch
	_move_default:
	
	_move_end_switch:
	
	# Draw stuff
	beq s0, 0, _draw_start
	beq s0, 1, _draw_level
	beq s0, 2, _draw_end
	j _draw_default
	
	_draw_start:
		li a0, 5
		li a1, 5
		lstr a2, "Press any"
		jal display_draw_text
		
		li a0, 5
		li a1, 11
		lstr a2, "key to"
		jal display_draw_text
		
		li a0, 5
		li a1, 17
		lstr a2, "start"
		jal display_draw_text
		
		j _draw_end_switch
	_draw_level:
		
		#display arena
		li s1, 0
		_for_outer:
			li s2, 0
			_for_inner:
				#get arena value
				mul t0, s1, 12
				add t0, t0, s2
				lb t0, arena(t0)
				#if 1 in arena, draw wall
				bne t0, 1, _end_if_arena
					move a0, s2
					mul a0, a0, 5
					move a1, s1
					mul a1, a1, 5
					la a2, wall
					jal display_blit_5x5_trans
				_end_if_arena:
				
				#if 1 in targets, draw target
				mul t0, s1, 12
				add t0, t0, s2
				lb t0, targets(t0)
				bne t0, 1, _end_if_targets
					move a0, s2
					mul a0, a0, 5
					move a1, s1
					mul a1, a1, 5
					la a2, target
					jal display_blit_5x5_trans
				_end_if_targets:
				
				#if 1 in boxes, draw box
				mul t0, s1, 12
				add t0, t0, s2
				lb t0, boxes(t0)
				bne t0, 1, _end_if_boxes
					move a0, s2
					mul a0, a0, 5
					move a1, s1
					mul a1, a1, 5
					la a2, box
					jal display_blit_5x5_trans
				_end_if_boxes:
			addi s2, s2, 1
			blt s2, 12, _for_inner
		addi s1, s1, 1
		blt s1, 11, _for_outer
		
		#display player
		lb a0, playerx
		mul a0, a0, 5
		lb a1, playery
		mul a1, a1, 5
		la a2, ghost
		jal display_blit_5x5_trans
		
		#display move count
		li a0, 0
		li a1, 56
		li a2, 64
		li a3, COLOR_BLUE
		jal display_draw_hline
		
		li a0, 2
		li a1, 58
		lstr a2, "moves:"
		jal display_draw_text
		
		li a0, 40
		li a1, 58
		lw a2, count
		jal display_draw_int
		
		j _draw_end_switch
	_draw_end:
		li	a0, 5
		li	a1, 5
		# This is a macro defined in macros.asm
		lstr	a2, "You won!"
		jal	display_draw_text
		
		li 	a0, 5
		li 	a1, 20
		lw 	a2, count
		jal 	display_draw_int
		
		li	a0, 23
		li	a1, 20
		# This is a macro defined in macros.asm
		lstr	a2, "moves"
		jal	display_draw_text

		j _draw_end_switch
	_draw_default:
	
	_draw_end_switch:

	
	# Must update the frame and wait
	jal	display_update_and_clear
	jal	wait_for_next_frame
	jal	input_get_keys_held

	# Leave if x was pressed
	lw	t0, x_pressed
	bnez	t0, _game_end
	
	#check if boxes on targets
	jal target_box_match
	beq v0, 0, _continue
	
	li s0, 2
	
	_continue:
	
	j	_game_while
	
_game_end:
	# Clear the screen
	jal	display_update_and_clear
	jal	wait_for_next_frame

leave



#--------------------------------------
#check if coords in matrix contain
#a0=x
#a1=y
#a2=pointer to array
collision_check:
enter
	mul v0, a1, 12
	add v0, v0, a0
	add v0, v0, a2
	lb v0, (v0)
leave

#----------------------------------------
#moves box
#a0=x
#a1=y
#a2=direction (0=up,1=down,2=left,3=right)
#returns 1 if moved, 0 if not

try_move_box:
enter s0 s1 s2
	move s0, a0
	move s1, a1
	move s2, a2
	#get coords past box in given direction
	beq a2, 0, _up
	beq a2, 1, _down
	beq a2, 2, _left
	beq a2, 3, _right
	j _end_switch
	_up:
		sub a1, a1, 1
		j _end_switch
	_down:
		add a1, a1, 1
		j _end_switch
	_left:
		sub a0, a0, 1
		j _end_switch
	_right:
		add a0, a0, 1
	_end_switch:
	
	#check for wall
	la a2, arena
	jal collision_check
	
	#if wall in front return no
	beq v0, 1, _return_no
	
	#check for box
	la a2, boxes
	jal collision_check
	
	#if box in front return no
	beq v0, 1, _return_no
	
	#else--free past box, move it
	#set current spot to 0
	move t0, s1
	mul t0, t0, 12
	add t0, t0, s0
	sb zero, boxes(t0)
	
	#set spot past box to 1
	beq s2, 0, _up_2
	beq s2, 1, _down_2
	beq s2, 2, _left_2
	beq s2, 3, _right_2
	j _end_switch_2
	_up_2:
		sub t0, t0, 12
		j _end_switch_2
	_down_2:
		add t0, t0, 12
		j _end_switch_2
	_left_2:
		sub t0, t0, 1
		j _end_switch_2
	_right_2:
		add t0, t0, 1
	_end_switch_2:
	li t1, 1
	sb t1, boxes(t0)
	
	j _return_yes
	
	_return_no:
		li v0, 0
		j _end_func
	_return_yes:
		li v0, 1
	_end_func:
leave s0 s1 s2

#---------------------------------------------
#toggles binary value in matrix
#a0=x
#a1=y
#a2=pointer to array

toggle_value:
enter
	#get current value
	mul t0, a1, 12
	add t0, t0, a0
	add t0, t0, a2
	lb t1, (t0)
	
	#if 1 set to 0
	beq t1, 0, _else
		sb zero, (t0)
		j _end_if
	_else: #else set t0 1
		li t1, 1
		sb t1, (t0)
	_end_if:
leave
#----------------------------------------------
#matrix matching between boxes & targets

#a0 = boxes
#a1 = targets
#v0= 0=false, 1=true


target_box_match:
enter
	li t0,-1	#x coord in matrix
	li t1,0		#y coord in matrix
	li t5,0		#t5= flag count
	
	_loop:
	add t0,t0,1
	bge t0, 12,_end_loop 
	li t1,0
		_inner_loop:
			beq t1, 11, _loop
			#get box value
			move t2,t1
			move t3,t0
			mul t2, t2, 12
			add t2, t2, t3
			lb t3, boxes(t2)		#t2=box value
			#get box value
			lb t4, targets(t2)		#t4 = target value
	
			beq  t3,t4,_increment
			add t5,t5,1
			
			_increment:
			add t1,t1,1
		
			j _inner_loop
	_end_loop:
	bne t5, zero,_lose
	li v0, 1
	j _end
	_lose:
	li v0, 0
	_end:
leave	
	
	
	
