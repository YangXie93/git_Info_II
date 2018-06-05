.data

x: .word 3
y: .word 5
n: .asciiz "\n"
.text

main:   la $a0,x
        la $a1,x
        jal func

        lw $a0,x
        li $v0,1
        syscall

        la $a0,n
        li $v0,4
        syscall

        lw $a0,y
        li $v0,1
        syscall

        la $a0,n
        li $v0,4
        syscall

        li $v0,10
        syscall



func:   addi $sp,$sp,-12
        sw $ra,0($sp)
        move $t0,$a0
        move $t1,$a1
        lw $a0,0($a0)
        lw $a1,0($a1)
        sw $a1,0($t0)
        sw $a0,0($t1)
        lw $ra,0($sp)
        addi $sp,$sp,12
        jal $ra
