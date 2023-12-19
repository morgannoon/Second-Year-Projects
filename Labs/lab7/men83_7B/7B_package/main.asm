# lun8
# Luis Filipe Oliveira
# This is my solution! Not the only solution!!

.include "macros.asm"

.text
# --------------------------------------------------------------------------------------------------

.globl main

main:
	# set up anything you need to here,
	# and wait for the user to press a key to start.

_main_loop:
	# check for input, this function sets the following variables (check keyboard_model.asm/keyboard_controller.asm):
	#	left_pressed
	#	right_pressed
	#	up_pressed
	#	down_pressed
	#	action_pressed
	jal     handle_input

	# update everything,
	lw	a0, frame_counter
	jal	pixel_update

	# then draw everything.
	jal	pixel_draw

	jal	display_update_and_clear

	## This function will block waiting for the next frame!
	jal	wait_for_next_frame
	b	_main_loop

_main_game_over:
	syscall_exit
