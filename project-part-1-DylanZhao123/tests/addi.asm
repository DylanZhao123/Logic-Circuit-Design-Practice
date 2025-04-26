addi $4, $0, -20
addi $5, $4, 0x7FFF
addi $6, $5, 0x7018
addi $7, $6, 0x5311
addi $0, $4, 0
addi $0, $0, 0
addi $8, $0, -0x8000	# the immediate field is 0x8000, and $8 is 0xffff8000 (sign-extended)
addi $0, $8, 0
