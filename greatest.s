.data

x:      .word 3,72,3,8,2,22,2,32,4,10
lenght: .word 6
n:      .asciiz "\n"
.text

main:   la $a0,x
        add $a1,$a0,40
        jal great
        move $a0,$v0
        li $v0,1
        syscall
        la $a0,n
        li $v0,4
        syscall
        move $a0,$v1
        li $v0,1
        syscall
        la $a0,n
        li $v0,4
        syscall
        li $v0,10
        syscall



great:  addi $sp,$sp,-8
        sw $ra,0($sp)
        lw $t0,0($a0)
        sw $a0,4($sp)

while:  sub $t3,$a0,$a1
        bgez $t3,return
        lw $t1,4($a0)
        sub $t2,$t0,$t1
        bltz $t2,switch
        addi $a0,$a0,4
        j while

switch: move $t0,$t1
        addi $a0,$a0,4
        sw $a0,4($sp)
        j while

return: lw $ra,0($sp)
        lw $v0,4($sp)
        move $v1,$t0
        j $ra
