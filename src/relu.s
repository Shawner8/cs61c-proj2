.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
	# Prologue
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    
    bgt a1, zero, loop_start
    li a0, 36
    j exit
    
loop_start:
    addi s0, a0, 0  # load the address of array into s0
    addi s1, a1, 0  # load the size of array into s1
    li t0, 0        # set t0 as counter

loop_continue:
    slli t1, t0, 2
    add t1, t1, s0  # save the address of t0 th element of array into t1
    lw t2, 0(t1)    # load t0 th element of array into t2
    blt zero, t2, loop_end
    sw zero, 0(t1)  # set t0 th element of array to 0 if less than 0

loop_end:
    addi t0, t0, 1  # counter increment
    bne t0, s1, loop_continue

	# Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8

	ret
