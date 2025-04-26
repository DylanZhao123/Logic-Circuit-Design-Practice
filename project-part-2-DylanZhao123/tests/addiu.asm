addiu $4, $0, -20
addiu $5, $4, 0x7FFF
addiu $6, $5, 0x7018
addiu $7, $6, 0x5311
addiu $0, $4, 0
addiu $0, $0, 0
addiu $8, $0, -0x8000	# the immediate field is 0x8000, and $8 is 0xffff8000 (sign-extended)
addiu $0, $8, 0
