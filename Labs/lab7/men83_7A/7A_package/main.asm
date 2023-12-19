.include "constants.asm"
.include "macros.asm"

.data
str_insert_the: 	.asciiz 	"Please enter the "
str_x: 		.asciiz		"x"
str_y: 		.asciiz		"y"
str_size: 		.asciiz		"size: \n"
str_coordinate: 	.asciiz 	" coordinate of the position: \n"
str_colour: 		.asciiz		"colour (w - white, g - green, y - yellow, r - red): \n"
str_invalid: 		.asciiz		"\nInvalid colour. Options are w - white, g - green, y - yellow, r - red"


.text
.globl main


main:

	# Request x coordinate
	li	v0, 4
	la	a0, str_insert_the
	syscall
	la	a0, str_x
	syscall
	la	a0, str_coordinate
	syscall

	# Get x coordinate
	li	v0, 5
	syscall
	move	s0, v0

	# Request y coordinate
	li	v0, 4
	la	a0, str_insert_the
	syscall
	la	a0, str_y
	syscall
	la	a0, str_coordinate
	syscall

	# Get y
	li	v0, 5
	syscall
	move	s1, v0

	# Request size
	li	v0, 4
	la	a0, str_insert_the
	syscall
	la	a0, str_size
	syscall
	# Get size
	li	v0, 5
	syscall
	move	s2, v0

	# Request colour
	li	v0, 4
	la	a0, str_insert_the
	syscall
	la	a0, str_colour
	syscall
	# Get colour
	li	v0, 12
	syscall
	move	s3, v0

	# switch colour to correct value
	beq	s3, 'w', _main_colour_white
	beq	s3, 'g', _main_colour_green
	beq	s3, 'y', _main_colour_yellow
	beq	s3, 'r', _main_colour_red
	j	_main_colour_default

_main_colour_white:
	li	s3, COLOR_WHITE
	j	_main_colour_done
_main_colour_green:
	li	s3, COLOR_GREEN
	j	_main_colour_done
_main_colour_yellow:
	li	s3, COLOR_YELLOW
	j	_main_colour_done
_main_colour_red:
	li	s3, COLOR_RED
	j	_main_colour_done
_main_colour_default:
	li	v0, 4
	la	a0, str_invalid
	syscall
	# Cheeky, but I know what I'm doing :)
	j	_main_end
_main_colour_done:

	# Call function drawVerticalLine
	move	a0, s0
	move	a1, s1
	move	a2, s2
	move	a3, s3
	jal	draw_spiral

	# Refresh the display
	jal	display_update_and_clear
_main_end:

	syscall_exit



# void draw_horizontal_line(int x, int y, int size, int colour)
# for(i=0; i<size; i++) {
#   display_set_pixel(x+i, y, colour);
# }
draw_horizontal_line:
	# prologue
	enter	s0, s1, s2, s3, s4

	# Preserve all input parameters
	move	s0, a0					# s0 contains x
	move	s1, a1					# s1 contains y
	move	s2, a2					# s2 contains size
	move	s3, a3					# s3 contains colour

	li	s4, 0					# s4 contains i, initialize i=0
_draw_horizontal_line_loop:
	bge	s4, s2, _draw_horizontal_line_exit	# Check if i >= size
	# for loop implementation
	add	a0, s0, s4				# Calculate x-coordinate = x+i
	move	a1, s1					# Calculate y-coordinate is fixed
	move	a2, s3					# Colour set by user
	jal	display_set_pixel
	inc	s4					# Increment i
	j	_draw_horizontal_line_loop
_draw_horizontal_line_exit:
	# epilogue
	leave	s0, s1, s2, s3, s4
	
	
# void draw_vertical_line(int x, int y, int size, int colour)
# for(i=0; i<size; i++) {
#   display_set_pixel(x, y+i, colour);
# }
draw_vertical_line:
	# prologue
	enter	s0, s1, s2, s3, s4

	# Preserve all input parameters
	move	s0, a0					# s0 contains x
	move	s1, a1					# s1 contains y
	move	s2, a2					# s2 contains size
	move	s3, a3					# s3 contains colour

	li	s4, 0					# s4 contains i, initialize i=0
_draw_vertical_line_loop:
	bge	s4, s2, _draw_vertical_line_exit	# Check if i >= size
	# for loop implementation
	move	a0, s0					# Calculate x-coordinate is fixed
	add	a1, s1, s4				# Calculate y-coordinate = x+i
	move	a2, s3					# Colour set by user
	jal	display_set_pixel
	inc	s4					# Increment i
	j	_draw_vertical_line_loop
_draw_vertical_line_exit:
	# epilogue
	leave	s0, s1, s2, s3, s4


# void draw_spiral(int x, int y, int size, int color) {
#	while(size>1) {
#		draw_horizontal_line(x, y, size, color);
#		x = x + size - 1;
#		size--;

#		draw_vertical_line(x, y, size, color);
#		y = y + size - 1;
#		size--;

#		x = x - size + 1;
#		draw_horizontal_line(x, y, size, color);
#		size--;

#		y = y - size + 1;
#		draw_vertical_line(x, y, size, color);
#		size--;
#	}}
draw_spiral:
	# prologue
	enter	s0, s1, s2, s3, s4

	# Preserve all input parameters
	move	s0, a0					# s0 contains x
	move	s1, a1					# s1 contains y
	move	s2, a2					# s2 contains size
	move	s3, a3					# s3 contains colour

	li	s4, 0					# s4 contains i, initialize i=0
_draw_spiral_loop:
	beq s2,1, _draw_spiral_exit
	move a1,s1					#reset y
	jal draw_horizontal_line
	add a0,s0,s2					#x=x+size
	sub a0,a0,1					#x=x-1
	sub a2,s2,1					#size-1
	move s0,a0
	move s2,a2
	
	jal draw_vertical_line
	add a1,s1,s2					#y=y+size
	sub a1,a1,1					#y=y-1
	sub a2,s2,1					#size-1
	move s1,a1
	move s2,a2
	
	sub a0,s0,s2					#x=x-size
	add a0,a0,1					#x=x+1
	move s0,a0
	
	jal draw_horizontal_line
	sub a2,s2,1					#size-1
	move s2,a2
	
	move a0,s0					#reset x
	sub a1,s1,s2					#y=y-size
	add a1,a1,1					#y=y+1
	move s1,a1
	
	jal draw_vertical_line
	sub a2,s2,1					#size-1
	move s2,a2
	j _draw_spiral_loop
_draw_spiral_exit:
	# epilogue
	leave	s0, s1, s2, s3, s4
