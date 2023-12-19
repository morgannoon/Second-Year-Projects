## This file implements the functions that display the pixels based on the model

# Include the macros file so that we save some typing! :)
.include "macros.asm"
# Include the constants settings file with the board settings! :)
.include "constants.asm"
# We will need to access the pixel model, include the structure offset definitions
.include "pixel_struct.asm"

# This function needs to be called by other files, so it needs to be global
.globl pixel_draw

.text
# void pixel_draw()
#	1. This function goes through the array of pixels and for each
#		1.1. Gets its (x, y) coordinates and selected status
#		1.2. Prints it in the display using function display_set_pixel (display.asm)
#			1.2.1. If the pixel is not selected, print it using some color (Not COLOR_BLACK, as this is the background color)
#			1.2.2. If the pixel is selected, print it using another color

pixel_draw:
	enter s0
	# Your code goes in here
	li s0, 0
	pixel_draw_loop:
		move a0, s0
		jal pixel_get_element
		
		add a0, v0, pixel_x
		lw a0, (a0)
		add a1, v0, pixel_y
		lw a1, (a1)
		add t0, v0, pixel_selected
		lw t0, (t0)
		#if pixel is selected white; else, red
		beq t0, 0, else
			li a2, COLOR_RED
			j end_if
		else:
			li a2, COLOR_WHITE
		end_if:
		
		jal display_set_pixel
	
	addi s0, s0, 1
	li t0, n_pixels
	blt s0, t0, pixel_draw_loop
	
	leave s0
