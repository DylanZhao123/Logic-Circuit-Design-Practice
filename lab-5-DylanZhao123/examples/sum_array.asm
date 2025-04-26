# Add the numbers in an array
# Expected output: Data address 0 contains 42 (0x2a)

# Here is the C code for adding 5 numbers from an array.

# int sum, i;
# int A[5] = {7,8,9,10,8};
#
# main() {
#   sum = 0;
#   for (i=0; i<5; i++)
#     sum = sum + A[i];
# }

# Here is the corresponding MIPS assembly version.
# It has been developed by converting the C code to
# assembly line-by-line. The corresponding line of
# C code is shown in the comments.

# In this file, we store variables sum and A in .data. See the comments in .data.
# Registers $s0, $t0 and $t1 are again used as scratch registers.
# $s0 holds sum and $t0 holds i. $t1 is a scratch register that holds
# several temporary results: the array offset i*4,
# the array element A[i], and the Boolean (i<5).

# Macro used at end of program
# "Define once, use many times" capability
# See README section titled Macro for more information

# syscall with the immediate %service_num in $v0
#
# 	%service_num: immediate that is put in $v0 for the syscall
#
# 	clobbers: $v0
.macro syscall_val (%service_num)
li 	$v0, %service_num	# $v0 = %service_num
syscall
.end_macro

.data

sum:    .space 4		# reserve 4 bytes of space (int sum), uninitialized (i.e., 0)
A:      .word 7,8,9,10,8	# reserve space for 5 words (32-bit), initialized to the given values

.text

main:
     	addi	$s0, $0, 0     	# $s0 = sum = 0
     	addi	$t0, $0, 0    	# $t0 = i = 0


loop:
	sll	$t0, $t0, 2    	# convert i to word offset by multiplying by 4
				# self-check: Why convert i to word offset? Why can't we index A using i without word-offsetting?
	lw	$t1, A($t0)  	# $t1 = A[i]
				# pseudo-syntax that means
				# load into $t1 the word at &A + i*4
				# i.e., the int at &A[i]
    	add	$s0, $s0, $t1	# sum = sum + A[i];
    	srl	$t0, $t0, 2	# undo word-offset to i	
     	addi	$t0, $t0, 1     # for (...; ...; i++
     	slti	$t1, $t0, 5     # for (...; i<5;
     	bne	$t1, $0, loop

	sw	$s0, sum($0)   	# update final sum in memory
				# pseudo-syntax that means store $s0 at &sum + 0, which is &sum
				# when assembled, sum is automatically converted to an immediate address
  				# so the actual instruction looks like
  				# sw $16, 0x00000000($0)
     
     
end:
	syscall_val (10)	# use macro to exit program with syscall 10
