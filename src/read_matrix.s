.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    
	# Prologue
    addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    
    mv s1, a1    # let s1 to save the address to row_num
    mv s2, a2    # let s2 to save the address to col_num
    
    # open the file
    li a1, 0
    jal fopen
    mv s0, a0
    li t0, -1
    beq s0, t0, fopen_error
    
    # read row_num and col_num from the file
    mv a0, s0
    mv a1, s1
    li a2, 4
    jal fread
    li t0, 4
    bne a0, t0, fread_error
    
    mv a0, s0
    mv a1, s2
    li a2, 4
    jal fread
    li t0, 4
    bne a0, t0, fread_error
    
    # allocate space on the heap to store the matrix
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul a0, t1, t0
    slli a0, a0, 2
    mv s3, a0    # let s3 to save the size of the matrix
    jal malloc
    mv s4, a0    # let s4 to save the address to allocated space
    beq s4, zero, malloc_error
    
    # read the matrix from the file
    mv a0, s0
    mv a1, s4
    mv a2, s3
    jal fread
    bne a0, s3, fread_error
    
    # close the file
    mv a0, s0
    jal fclose
    bne a0, zero, fclose_error
    
    # return a pointer to the matrix in memory
    mv a0, s4

	# Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24

	ret

malloc_error:
    li a0, 26
    j exit

fopen_error:
    li a0, 27
    j exit

fclose_error:
    li a0, 28
    j exit
    
fread_error:
    li a0, 29
    j exit
