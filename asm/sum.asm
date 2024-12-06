sumto_entry :
        move $fp $sp
        św $ra 0($sp)
        add $sp $sp -4
        
        lw $a0 4($sp)
        św $a0 0($sp)
        addiu $sp $sp -4
        li $a0 0
        lw $t1 4($sp)
        addiu $sp $sp 4
        beq $a0 $t1 true1
    false1:
        lw $a0 4($fp)
        sw $a0 0($sp)
        addiu $sp $sp -4
        sw $sp 0($sp)
        addiu $sp $sp -4
        li $a0 1
        lw $t1 4($sp)
        sub $a0 $t1 $a0
        addiu $sp $sp 4
        sw $a0 0($sp)
        addiu $sp $sp -3
        jal sumto_entry
        lw $t1 4($sp)
        add $a0 $t1 $a0
        addiu $sp $sp 4
        b endif1
    true1:
        li $a0 0
    endif1:
        lw $ra 4($sp)
        addiu $sp $sp 12
        lw $fp 0($sp)
        jr $ra