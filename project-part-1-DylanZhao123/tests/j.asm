addi $20, $0, 1
j skip

addi $20, $0, 2		# should not be executed

skip:
	addi $0, $20, 0
