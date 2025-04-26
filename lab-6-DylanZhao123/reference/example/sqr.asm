.include "../../macros.asm"

# Procedure and stack programming example
# See sqr.c (reference C code)
# Nothing to implement here

.text

main:
	print_str ("Non-negative integer to square: ")
	read_int		# $v0 = x
	move	$a0, $v0	# $a0 = x, pass arg x to sqr
	jal	sqr		# $v0 = sqr(x)
	print_reg_int ($v0)
	j exit


# int sqr(int x)
#	$a0 = x
#
# sqr is recursive, so it is both a caller and callee
# In sqr label, before recursive call, it saves $a0 (caller responsibility)
# In sqr and return labels, it saves and restores $ra and $fp (callee responsibility)
# In if_body label, after recursive call that may mutate $a0, it restores $a0
#
# Stack frame illustration:
# $fp -> $ra
#	 $fp
# $sp -> $a0
sqr:
	addi	$sp, $sp, -8	# Allocate stack memory to push 2 words
	sw	$ra, 4($sp)	# Save $ra for returning to caller
	sw	$fp, 0($sp)	# Save caller $fp
	addi	$fp, $sp, 4	# Set callee fp
	
	addi	$sp, $sp, -4	# Allocate stack memory to push 1 word
	sw	$a0, 0($sp)	# Save $a0
	
	bgt	$a0, 1, if_body	# if (x > 1), branch to if_body
	move	$v0, $a0	# Set rv to x before returning
	j	return

if_body:
	addi	$a0, $a0, -1	# x -= 1
	jal	sqr		# $v0 = sqr(x - 1)
	lw	$a0, -8($fp)	# Restore $a0 (mutated by sqr call if the if body executes)
	add	$v0, $v0, $a0	# $v0 += x
	add	$v0, $v0, $a0	# $v0 += x
	addi	$v0, $v0, -1	# $v0 -= 1
				# $v0 = sqr(x - 1) + x + x - 1

return:
	addi	$sp, $fp, 4	# Restore caller $sp
	lw	$ra, 0($fp)	# Restore $ra for returning to caller
	lw	$fp, -4($fp)	# Restore caller $fp
	jr	$ra		# Return to caller with correct rv in $v0
	
exit:
	syscall_val (10)	# Exit program
