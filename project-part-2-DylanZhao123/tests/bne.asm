addi $4, $0, 0
addi $5, $0, 1
bne $5, $0, skip
addi $6, $0, 1234	# should not execute

skip:
	addi $0, $6, 0
	bne $4, $0, skip2
	addi $7, $0, 1	# should execute immediately after the bne

skip2:
	addi $7, $0, 2
