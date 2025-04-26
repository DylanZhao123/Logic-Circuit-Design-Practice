.include "macros.asm"

.text

# You should not need to modify this
main:
	print_str ("Enter BST size: ")
	read_int			# $v0 = size
	move	$s0, $v0		# $s0 = size
	print_str ("Value 0: ")
	read_int			# $v0 = val
	move	$t0, $v0
	new_node ($t0)			# $v0 = bst = new_node(val)
	move	$a0, $v0		# $a0 = bst, since insert expects $a0 to be BST* root
	li	$t0, 1			# $t0 = i = 1

main_loop:
	bge	$t0, $s0, main_end	# if i >= size, branch to main_end
	print_str ("Value ")
	print_reg_int ($t0)
	print_str (": ")
	read_int			# $v0 = val
	# pass args to insert
	# $a0 is already correct (see line 14)
	# $a0 hasn't changed because macros save and restore $a0
	move	$a1, $v0		# $a1 = val
	addi	$sp, $sp, -4		# allocate stack memory for pushing 1 word
	sw	$t0, 0($sp)		# save $t0 because insert may clobber
	jal	insert			# $v0 = insert(bst, val)
	lw	$t0, 0($sp)		# restore $t0
	addi	$sp, $sp, 4		# deallocate stack memory for 1 word
	addi	$t0, $t0, 1		# i++
	j	main_loop

main_end:
	print_str ("Inorder: ")
	jal	inorder			# call inorder, arg $a0 is already correct
	syscall_val (10)		# exit program


# BST* insert(BST* root, int x)
#	$a0 = root
#	$a1 = x
#	$v0 = BST* (root of BST)
#
# TODO: Put your planned stack frame here
insert:
    addiu $sp, $sp, -24
    sw    $ra, 20($sp)
    sw    $fp, 16($sp)
    sw    $s0, 12($sp)   # save callee?saved
    sw    $a0, 8($sp)    # save root
    sw    $a1, 4($sp)    # save x
    addiu $fp, $sp, 20

    move  $s0, $a0       # $s0 = root

    beq   $s0, $zero, ins_new

    lw    $t0, 0($s0)    # data
    lw    $t1, 4($sp)    # x
    slt   $t2, $t1, $t0  # x < data ?
    bne   $t2, $zero, ins_left

    # ---- insert to right ----
    lw    $a0, 8($s0)    # root->right
    move  $a1, $t1
    jal   insert
    sw    $v0, 8($s0)    # root->right = ret
    move  $v0, $s0
    j     ins_end

ins_left:
    lw    $a0, 4($s0)    # root->left
    move  $a1, $t1
    jal   insert
    sw    $v0, 4($s0)    # root->left = ret
    move  $v0, $s0
    j     ins_end

ins_new:
    lw    $a1, 4($sp)    # x
    new_node ($a1)       # v0 = ptr

ins_end:
    lw    $s0, 12($sp)
    lw    $ra, 20($sp)
    lw    $fp, 16($sp)
    addiu $sp, $sp, 24
    jr    $ra

# void inorder(BST* root)
#	$a0 = root
#
# TODO: Put your planned stack frame here
inorder:
    addiu $sp, $sp, -12
    sw $ra, 8($sp)
    sw $fp, 4($sp)
    sw $a0, 0($sp)
    addiu $fp, $sp, 8

    beq $a0, NULL, inorder_end

    # inorder(root->left)
    lw $a0, 4($a0)
    jal inorder

    # print root->data
    lw $a0, 0($sp)    # restore root
    lw $t0, 0($a0)    # t0 = root->data
    print_reg_int ($t0)
    print_str_label (space)

    # inorder(root->right)
    lw $a0, 0($sp)
    lw $a0, 8($a0)
    jal inorder

inorder_end:
    lw $ra, 8($sp)
    lw $fp, 4($sp)
    lw $a0, 0($sp)
    addiu $sp, $sp, 12
    jr $ra

exit:
	syscall_val (10)		# exit program
