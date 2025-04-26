.include "macros.asm"

.data
pattern:    	.space 17	# 16 + null
newline:        .byte 10, 0
prompt:         .asciiz "Enter the number of bits (1 <= N <= 16): "

.text

main:
	print_str_label (prompt)
	read_int

	# Check bounds
	li $t0, 1
	blt $v0, $t0, exit
	li $t0, 16
	bgt $v0, $t0, exit

	sb $0, pattern($v0)      # null terminate

	move $a0, $v0            # $a0 = N
	move $a1, $v0            # $a1 = n
	jal bingen
	j exit

# Stack Frame:
# $fp -> $ra
#        $fp
#        saved $a1

bingen:
    addiu $sp, $sp, -12
    sw $ra, 8($sp)
    sw $fp, 4($sp)
    sw $a1, 0($sp)
    addiu $fp, $sp, 8

    beqz $a1, base_case

    # index = N - n
    sub $t0, $a0, $a1
    la  $t1, pattern
    add $t1, $t1, $t0

    li $t2, '0'
    sb $t2, 0($t1)

    addiu $a1, $a1, -1
    jal bingen

    lw $a1, 0($sp)

    li $t2, '1'
    sb $t2, 0($t1)

    addiu $a1, $a1, -1
    jal bingen

    j end_bingen


base_case:
	print_str_label (pattern)
	print_str_label (newline)
	j end_bingen

end_bingen:
	lw $ra, 8($sp)
	lw $fp, 4($sp)
	lw $a1, 0($sp)
	addiu $sp, $sp, 12
	jr $ra

exit:
	syscall_val (10)