# Add the first four integers
# Expected output: $s0 contains 10 (0xa)

# Here is the C code for adding the first four integers,
# starting with 0.

# int i, sum;
#
# main() {
#   sum = 0;
#   for (i=0; i<5; i++)
#     sum = sum + i;
# }

# Here is the corresponding MIPS assembly version.
# It has been developed by converting the C code to
# assembly line-by-line. The corresponding line of
# C code is shown in the comments.

# For this simple example, we do not place any variables
# in memory.
# (To place variables in memory, we give the
# ".data" directive to the assembler; see sum_array.asm)
# Instead, we simply
# choose to use $t0, $t1 and $s0 as scratch registers to hold
# any variables we need. In particular, $s0 holds sum,
# $t0 holds i, and $t1 is a scratch register that holds
# the Boolean result of (i<5).

# Note that $t0, $t1, and $s0 are the same as $8, $9, and $16,
# respectively (see Registers tab names and numbers in MARS).
# If you replaced the register names by register numbers,
# the code would work perfectly fine.
# However, register names v, a, t, s, etc., are assigned
# semantic meaning that we will see soon,
# so it is better to refer
# to registers using names instead of numbers.

.text

main:
	addi	$s0, $0, 0	# sum = 0
	addi	$t0, $0, 0    	# for (i = 0; ...


loop:
	add	$s0, $s0, $t0	# sum = sum + i;
	addi	$t0, $t0, 1	# for (...; ...; i++
	slti	$t1, $t0, 5	# for (...; i<5;
	bne	$t1, $0, loop	# is $t1 true?  i.e., $t1 != 0
     				# if so, branch to loop


end:
	ori	$v0, $0, 10	# system call 10 for exit
	syscall          	# we are out of here
