.include "macros.asm"

.data

A:	.space 80  	# allocate space for integer array with 20 elements ( int A[20] )

.text

main:	
	# ----------------------------------------------------------------------------------
	# Do not modify
	#
	# The following MIPS code performs the I/O C code below:
	#
	# 	int A[20];
	#	int size = 0;
	#	int v = 0;
	#
	#	printf("Enter array size [between 1 and 20]: " );
	#	scanf( "%d", &size );
	#
	#	for (int i=0; i<size; i++ ) {
	#
	#		printf( "A[%d] = ", i );
	#		scanf( "%d", &A[i]  );
	#
	#	}
	#
	#	printf( "Enter search value: " );
	#	scanf( "%d", &v  );
	#
	# ----------------------------------------------------------------------------------
	# the following code is technically unnecessary because MARS initializes the registers to 0.
	# the comments show what we use the variables for.
	addi	$s0, $0, 0		# $s0 = size = 0
	addi	$s1, $0, 0		# $s1 = v = 0 (v is the search variable)
	addi	$t0, $0, 0		# $t0 = i = 0

	print_str ("Enter array size (between 1 and 20): ")
	read_int			# $v0 = size
	add	$s0, $0, $v0		# $s0 = size
					# copy $v0 value to $s0 because $v0 will be clobbered


prompt_loop:
	slt	$t1, $t0, $s0		# $t1 = (i < size) ? 1 : 0
					# above syntax means if( i < size ) $t1 = 1 (true); else $t1 = 0 (false)
					# more info: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Conditional_operator
	beq	$t1, $0, end_prompt_loop
	print_str ("A[")
  	print_reg_int ($t0)		# print value of i (not word-offsetted)
  	print_str ("] = ")		 
	sll	$t0, $t0, 2		# i = i * 4 (4-byte word offset)
					# self-check: Why do we need the word offset? Why can't we just use i to index A?
  	
  	read_int			# $v0 = user-inputted array value
  	sw	$v0, A($t0)		# A[i] = $v0
  					# pseudo-syntax that means store $v0 at &A + i*4, which is &A[i]
  					# when assembled, A is automatically converted to an immediate address
  					# so the actual instruction looks like
  					# sw $2,0x00000000($8)
  					# alternate real instruction implementation:
  					# la $t1, A
  					# add $t1, $t1, $t0
  					# sw $v0, 0($t1)
	
	srl	$t0, $t0, 2		# i = i // 4 (undo word offset)
	addi	$t0, $t0, 1		# i++
	
	j prompt_loop
	
	
end_prompt_loop:
  	print_str ("Enter search value: ")
  	read_int			# $v0 = v (search value)
	add	$s1, $0, $v0		# $s1 = v
					# copy $v0 value to $s1 because $v0 will be clobbered		

	# ----------------------------------------------------------------------------------
	# TODO:	Part 1
	#	Write MIPS code that performs the bubble sort C code below.
	#	The above code has already created array A and A[0] to A[size-1] have been 
	#	entered by the user. After the bubble sort has been completed, the values in
	#	A are sorted in increasing order, i.e. A[0] holds the smallest value and 
	#	A[size -1] holds the largest value.
	#	
	#	int t = 0;
	#	
	#	for ( int i=0; i<size-1; i++ ) {
	#		for ( int j=0; j<size-1-i; j++ ) {
 	#			if ( A[j] > A[j+1] ) {
	#				t = A[j+1];
	#				A[j+1] = A[j];
	#				A[j] = t;
	#			}
	#		}
	#	}
	#			
	# ----------------------------------------------------------------------------------
	
	add $t2, $0, $s0		# $t2 = size

	addi $t0, $0, 0		# i = 0
outer_loop:
	subi $t6, $t2, 1		# size - 1
	bge $t0, $t6, end_bubble

	addi $t1, $0, 0		# j = 0
inner_loop:
	subu $t7, $t2, 1
	subu $t7, $t7, $t0	# size - 1 - i
	bge $t1, $t7, end_inner

	sll $t8, $t1, 2		# offset = j * 4
	lw $t4, A($t8)		# A[j]

	addi $t9, $t1, 1
	sll $t9, $t9, 2		# offset = (j+1) * 4
	lw $t5, A($t9)		# A[j+1]

	ble $t4, $t5, skip_swap

	# swap A[j] and A[j+1]
	add $t3, $0, $t5	# t = A[j+1]
	sw $t4, A($t9)		# A[j+1] = A[j]
	sw $t3, A($t8)		# A[j] = t

skip_swap:
	addi $t1, $t1, 1
	j inner_loop

end_inner:
	addi $t0, $t0, 1
	j outer_loop

end_bubble:
	
	# ----------------------------------------------------------------------------------
	# TODO:	Part 2
	#	Write MIPS code that performs the binary search C code below.
	#	The array A has already been sorted by your code above in Part 1, where A[0] 
	#	holds the smallest value and A[size -1] holds the largest value, and v holds 
	# 	the search value entered by the user.
	#	
	#	int left = 0;
	# 	int right = size - 1;
	#	int middle = 0;
	#	int element_index = -1;
 	#
	#	while ( left <= right ) { 
      	#
      	#		middle = left + (right - left) / 2; 
	#
      	#		if ( A[middle] == v) {
      	#    			element_index = middle;
      	#    			break;
      	#		}
      	#
      	#		if ( A[middle] < v ) {
      	#    			left = middle + 1; 
      	#		} else {
      	#    			right = middle - 1;
    	#		} 
	#	}
	#
	#	if ( element_index < 0 ) {
    	#		printf( "%d not in sorted A\n", v );
    	#	} else {
    	#		printf( "Sorted A[%d] = %d\n", element_index, v );
    	#	}
	# ----------------------------------------------------------------------------------
  	
  	addi $t0, $0, 0			# left = 0
	add $t1, $s0, $0
	addi $t1, $t1, -1		# right = size - 1
	li $t3, -1			# element_index = -1

binary_search_loop:
	bgt $t0, $t1, end_search

	subu $t5, $t1, $t0		# right - left
	sra $t5, $t5, 1			# / 2
	add $t2, $t0, $t5		# middle = left + (right - left)/2

	sll $t6, $t2, 2
	lw $t4, A($t6)			# A[middle]

	beq $t4, $s1, found
	blt $t4, $s1, go_right

	# when A[middle] > v
	addi $t1, $t2, -1
	j binary_search_loop

go_right:
	addi $t0, $t2, 1
	j binary_search_loop

found:
	add $t3, $0, $t2		# element_index = middle

end_search:
	bltz $t3, not_found
	# print: Sorted A[%d] = %d\n
	print_str ("Sorted A[")
	print_reg_int ($t3)
	print_str ("] = ")
	print_reg_int ($s1)
	print_str ("\n")
	j exit

not_found:
	print_reg_int ($s1)
	print_str (" not in sorted A\n")
  	
# ----------------------------------------------------------------------------------
# Do not modify
# ----------------------------------------------------------------------------------
exit:
	syscall_val (10)		# exit program with syscall 10
