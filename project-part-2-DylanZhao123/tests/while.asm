# while (a < b) a++
addi $t0, $0, 1

while:
    slti $t1, $t0, 5
    beq $t1, $0, end
    addi $t0, $t0, 1
    j while

end:
    addi $0, $t0, 0
