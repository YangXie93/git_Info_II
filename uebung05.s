.data

i:       .word   0
newline: .asciiz "\n"

.text
main:   li $v0,5            #Der zu quadrierende Wert wird eingelesen
        syscall
        move $s0,$v0        #Der Wert wird in $s0 gespeichert

ngtv:   bltz $s0,mkPstv     #ist der Wert kleiner Null gehe zu Zeile 36

        lw $t0,i            #die Zählervariable wird in $t0 gespeichert
        li $t1,1            #In $t1 wird eine 1 gespeichert
        move $t3,$zero      #$t3 wird gleich Null gesetzt

while:  addi $t0,1          #Der Zähler wird um 1 erhöht

        add $t2,$t0,$t0     #$t2 = $t0 *2
        sub $t2,$t2,$t1     #$t2 = $t2 -1
        add $t3,$t3,$t2     #$t3 += $t2

        bne $t0,$s0,while   #wenn der Zähler nicht gleich dem Eingelesesem Wert gehe zu Zeile 17

        move $a0,$t3        #Das Ergebnis wird in das Ausdruck Register verschoben und gedruckt
        li $v0,1
        syscall

        la $a0,newline      #Ein Zeilenumbruch wird gedruckt
        li $v0,4
        syscall

        li $v0,10           #Das Programm wird beendet
        syscall

mkPstv: sub $s0,$zero,$s0   #  0 - (-n) = n
        j ngtv
