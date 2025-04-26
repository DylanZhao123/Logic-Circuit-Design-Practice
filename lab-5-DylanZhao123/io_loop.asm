.include "macros.asm"

.text

main:
loop:
	print_str ("Enter width: ")
	read_int			# $v0 = width
	add	$t0, $0, $v0		# $t0 = width
					# copy $v0 value to $t0 because $v0 will be clobbered in the next print_str macro call
	li $t3, -1          
    beq $t0, $t3, exit     
    
	print_str ("Enter height: ")
	read_int			# $v0 = height
	add	$t1, $0, $v0		# $t1 = height
	
	mult	$t0, $t1		# compute area
					# results of mult are in registers lo and hi (self-check: why are 2 registers needed?)
	mflo 	$t2			# $t2 = lo
					# move from lo to $t2 (assume hi not needed)
					
	print_str ("Rectangle's area: ")
	print_reg_int ($t2)		# print area
	print_str ("\n")
	
	add	$t2, $0, $t0		# $t2 = perimeter, initialized to width
	add	$t2, $t2, $t0		# perimeter += width
	add	$t2, $t2, $t1		# perimeter += height
	add	$t2, $t2, $t1		# perimeter += height
	
	print_str ("Rectangle's perimeter: ")
	print_reg_int ($t2)		# print perimeter
	print_str ("\n")

  j loop
exit:
	syscall_val (10)		# exit program with syscall 10
