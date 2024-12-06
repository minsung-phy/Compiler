# def sumto(x) = if (x = 0) then 0 else x + sumto(x - 1)

sumto_entry :
    move $fp $sp # set fp
    sw $ra 0($sp) # Push ra
    addiu $sp $sp -4

# cgen(if (x = 0) then 0 else x + sumto(x - 1)) # body

    lw $a0 4($sp) # cgen(x)
    sw $s0 0($sp)
    addiu $sp $sp -4

    li $a0 0 # cgen(0)

    lw $t1 4($sp)
    addiu $sp $sp 4
    beq $a0 $t1 true_branch

false_branch :

# cgen(x + sumto(x - 1))
    lw $a0 4($sp) # cgen(x)
    sw $a0 0($sp)
    addiu $sp $sp -4

    # cgen(sumto(x - 1))

    lw $t1 4($sp)
    add $a0 $t1 $a0
    addiu $sp $sp 4

    b end_if

true_branch :
    li $a0 0  # cgen(0)

end_if :
    lw $ra 4($fp) # load ra
    addiu $sp $sp 12 # pop args
    lw $fp 0($sp) # restore old fp
    jr $ra # Caller로 jump


