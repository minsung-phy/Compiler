gcd_entry:
    move $fp $sp
    sw $ra 0($sp)
    addiu $sp $sp -4

        lw $a0 12($fp)
        sw $a0 0($sp)
        addiu $sp $sp -4
        li $a0 0
        lw $t1 4($sp)
        addiu $sp $sp 4
        beq $a0 $t1 true1

    false1:
        sw $fp 0($sp) -- $fp를 stack에 저장
        addiu $sp $sp -4

        lw $a0 8($fp) -- x를 $a0에 로드
        sw $a0 0($sp) -- x를 stack에 넣음
        addiu $sp $sp -4

        lw $a0 12($fp) -- y를 $a0에 가져옴
        lw $t1 4(%sp) -- x를 stack에서 $t1에 가져옴
        div $t1 $a0 -- x / y
        mfhi $t1 -- $t2 <- x % y
        sw $t1, 0($sp) -- x % y를 스택에 넣음
        addiu $sp, $sp, -4

        jal gcd_entry

        lw $fp, 4($sp) -- 호출 후 fp 복원
        addiu $sp $sp 4 -- stack 복구

    true1:                        -- y == 0인 경우
        lw $a0, 8($fp)            -- $a0 <- x (결과는 x)

    endif1:
        lw $ra, 4($sp)            -- 반환 주소 복원
        addiu $sp, $sp, 16        -- 스택 복구 (스택에서 로컬 변수와 호출자 스택 복원)
        lw $fp, 0($sp)            -- fp 복원
        addiu $sp, $sp, 4         -- 스택 복구 (스택에서 프레임 포인터 복원)
        jr $ra                    -- 반환



