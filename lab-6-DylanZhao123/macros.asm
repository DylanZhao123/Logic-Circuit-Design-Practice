# ============================================================================= #
# NOTE: For this lab, the macros have been modified to save and restore
# $a0 in the stack.
# Thus, our macros will not clobber $a0, which may be used by your code.
# For example, if $a0 holds the value 1 when you invoke a macro,
# $a0 will continue to hold the value 1 after the macro body is done executing.
# See the updated clobbers: ... comments.
# Although this makes coding easier, note that this
# does not follow MIPS caller-callee contracts (macro is like a callee).
# ============================================================================= #

# ==================== #
# Do not modify the
# given macros
# ==================== #

# syscall with the immediate %service_num in $v0
#
# 	%service_num: immediate that is put in $v0 for the syscall
#
#	clobbers: $v0
.macro syscall_val (%service_num)
li	$v0, %service_num
syscall
.end_macro


# >>> New macros >>>

# for bingen
# print string in .data given its label using system call 4
# different from print_str because print_str takes
# a string literal
#
#	%label: label of string (array of chars) in .data
#
# 	clobbers: $v0
.macro print_str_label (%label)
addi	$sp, $sp, -4
sw	$a0, 0($sp)

la	$a0, %label
syscall_val (4)

lw	$a0, 0($sp)
addi	$sp, $sp, 4
.end_macro

.eqv	NULL 0		# NULL is 0, see usage in new_node below

# similar function to C's malloc (malloc uses sbrk internally)
# allocate %bytes bytes in heap memory and return a pointer
# to allocated memory using system call 9 (sbrk)
#
#	%bytes: register or constant representing the
#		number of bytes to allocate
#
#	returns: pointer to allocated memory in $v0
#
#	clobbers: $v0
.macro sbrk (%bytes)
addi	$sp, $sp, -4
sw	$a0, 0($sp)

add	$a0, $0, %bytes	# %bytes can be register or constant
syscall_val (9)		# sbrk (allocate heap memory)

lw	$a0, 0($sp)
addi	$sp, $sp, 4
.end_macro


# translation of bst.c new_node
# return pointer to new BST node initialized
# with data %x and left and right fields NULL
#
#	%x: register or constant representing
#	    node data (int)
#
#	returns: pointer to initialized BST node in $v0
#
#	clobbers: $v0
.macro new_node (%x)
addi	$sp, $sp, -4
sw	$a0, 0($sp)

sbrk (12)		# $v0 = pointer to newly
			# allocated 12 bytes in heap
			# self-check: Why 12 per BST struct?
add	$a0, $0, %x	# %x can be register or constant
			# use $a0 to avoid clobbering
			# another register
			# $a0 is saved in stack anyway
sw	$a0, 0($v0)	# root->data = %x
			# self-check: Why 0($v0)?
li	$a0, NULL
sw	$a0, 4($v0)	# root->left = NULL
			# self-check: Why 4($v0)?
sw	$a0, 8($v0)	# root->right = NULL
			# self-check: Why 8($v0)?

lw	$a0, 0($sp)
addi	$sp, $sp, 4
.end_macro

# <<< New macros <<<


# print string literal using system call 4
#
#	%str: ASCII string literal
#
# 	clobbers: $v0
.macro print_str (%str)
.data
str_label:	.asciiz %str	# store %str in .data section
.text
addi	$sp, $sp, -4
sw	$a0, 0($sp)

la	$a0, str_label	# $a0 = address of %str
syscall_val (4)		# print string

lw	$a0, 0($sp)
addi	$sp, $sp, 4
.end_macro


# print contents of %reg as integer using system call 1
#
#	%reg: register with contents to be printed as integer
#
# 	clobbers: $v0
.macro print_reg_int (%reg)
addi	$sp, $sp, -4
sw	$a0, 0($sp)

add	$a0, $0, %reg
syscall_val (1)		# print integer

lw	$a0, 0($sp)
addi	$sp, $sp, 4
.end_macro


# read integer from stdin into $v0 using system call 5
#	
#	returns: integer read from stdin in $v0
#
#	clobbers: $v0
.macro read_int
syscall_val (5)		# read integer
.end_macro

# ==================== #
# End of given code
# You may add macros
# after here, if you
# wish
# ==================== #
