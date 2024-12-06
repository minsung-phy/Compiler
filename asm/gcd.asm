# def gcd(x, y) = if y = 0 then x else gcd(y, x%y)

gcd_entry :
    move $fp $sp # set fp
    sw $ra 0($sp) # Push ra
    addiu $sp $sp -4

#cgen(if y = 0 then x else gcd(y, x%y)) # body
    lw $a0 12($fp) # cgen(y)
    sw $a0 0($sp)
    addiu $sp $sp -4
    lw $a0 0 # cgen(0)
    lw $t1 4($sp)
    addiu $sp $sp 4
    beq $a0 $t1 true1

false1 :
    # cgen(gcd(y, x%y))
    sw $fp 0($sp) # 현재 frame pointer 값을 stack에 저장
    addiu $sp $sp -4
    lw $a0 12($fp) # y를 $a0에 가져옴
    sw $a0 0($sp) # y를 stack에 저장
    addiu $sp $sp -4

    # cgen(x%y)
    # x%y 로드
    lw $a0 8($fp) # x를 $a0에 가져옴
    lw $t1 4($sp) # 임시 레지스터에 y를 가져옴
    div $a0 $tl # x % y
    mfhi $a0

    # 스택 상황 : 맨 위에 y가 있음
    # 인자가 y와 x%y 2개임 -> $a0(x%y)를 스택에 넣자
    sw $a0 0($sp) 
    addiu $sp $sp -4
    jal gcd_entry # gcd_entry로 jump
    
    b endfi1

true1 :
    lw $a0 8($fp) # cgen(x)

endif1 :
    lw $ra 4($fp) # load ra
    addiu $sp $sp 16 # pop args
    lw $fp 0($sp) # restore old fp
    jr $ra # Caller로 jump


