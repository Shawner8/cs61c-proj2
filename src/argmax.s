.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
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
    li t1, 0        # set t1 as the argmax
    lw t2, 0(s0)    # set t2 as the max num

loop_continue:
    slli t3, t0, 2
    add t3, t3, s0  # save the address of t0 th element of array into t3
    lw t3, 0(t3)    # load t0 th element of array into t3
    bge t2, t3, loop_end
    mv t1, t0
    mv t2, t3

loop_end:
    addi t0, t0, 1  # counter increment
    bne t0, s1, loop_continue
    mv a0, t1
    
	# Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8

	ret
