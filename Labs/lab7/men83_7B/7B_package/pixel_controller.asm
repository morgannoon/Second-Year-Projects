## This file implements the functions that control the pixels based on the keyboard input

# Include the macros file so that we save some typing! :)
.include "macros.asm"
# Include the constants settings file with the board settings! :)
.include "constants.asm"
# We will need to access the pixel model, include the structure offset definitions
.include "pixel_struct.asm"

# This function needs to be called by other files, so it needs to be global
.globl pixel_update


.text
# void pixel_update(int current_frame)
#	1. This function goes through the array of pixels and finds the one that is selected (maybe you want to implement this as a different function?)
#	2. If no pixel is selected, then select pixel 0
#	3. Reads the state of the keyboard buttons and move the selected pixel accordingly
#		3.1. The pixel moves up to one pixel up/down and up to one pixel left/right according to the keyboard input.
#		3.2. The pixel must not leave the bounds of the display (check the .eqv in constants.asm)
#	4. Every 60 frames (use the input): If the user pressed the action button (B) the current selected pixel is deselected and the next pixel is selected (the array loops around).
#		You may need some variables!
pixel_update:
	enter s0
	# Your code goes in here
	li s0, 0
	pixel_update_loop:
		move a0, s0
		jal pixel_get_element
		
		add t0, v0, pixel_selected
		lw t0, (t0)
		#if pixel is selected
		bne t0, 1, end_if
			#use selected pixel
			move s0, v0
			j selected_pixel
		end_if:
	addi s0, s0, 1
	li t0, n_pixels
	blt s0, t0, pixel_update_loop
	
	#default to pixel 0
	li a0, 0
	jal pixel_get_element
	move s0, v0
	li t0, 1
	sw t0, pixel_selected(s0)
	
	selected_pixel:
	#s0 holds address of selected pixel
	
	#if B pressed
	jal wait_for_next_frame
	jal input_get_keys_held
	and t0, v0, KEY_B
	beq t0, 0, end_if_2
		#change selected pixel to next one
		sw zero, pixel_selected(s0)
		add s0, s0, pixel_size
		li t0, 1
		sw t0, pixel_selected(s0)
	end_if_2:
	
	#check for movement
	jal input_get_keys_held
	
	#switch case
	and t0, v0, KEY_R
	bne t0, 0, right
	and t0, v0, KEY_L
	bne t0, 0, left
	and t0, v0, KEY_U
	bne t0, 0, up
	and t0, v0, KEY_D
	bne t0, 0, down
	j end_switch
	up:
		lw t0, pixel_y(s0)
		#if at top edge, don't move
		beq t0, 0, end_switch
		#else
		sub t0, t0, 1
		sw t0, pixel_y(s0)
		j end_switch
	down:
		lw t0, pixel_y(s0)
		#if at bottom edge, don't move
		beq t0, 63, end_switch
		#else
		add t0, t0, 1
		sw t0, pixel_y(s0)
		j end_switch
	left:
		lw t0, pixel_x(s0)
		#if at left edge, don't move
		beq t0, 0, end_switch
		#else
		sub t0, t0, 1
		sw t0, pixel_x(s0)
		j end_switch
	right:
		lw t0, pixel_x(s0)
		#if at top edge, don't move
		beq t0, 63, end_switch
		#else
		add t0, t0, 1
		sw t0, pixel_x(s0)
	end_switch:
	
	leave s0

# Perhaps implement this function?
pixel_find_selected:
	enter
	# Your code goes in here

	leave
