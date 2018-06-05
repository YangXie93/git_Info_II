
.data

x: .word 1,2,3,4,5,6,7,8,9,10
y: .word 3,5,2,6,6,23,4,7,0,23
z: .word 10,9,8,7,6,5,4,3,2,1

sp: .asciiz " "
n: .asciiz "\n"

.text
main:   ################ AUSGABE der Felder Vor dem Sortieren ##################
        la $a0,x
        addi $a1,$a0,40
        jal print

        la $a0,y
        addi $a1,$a0,40
        jal print

        la $a0,z
        addi $a1,$a0,40
        jal print

        la $a0,n
        li $v0,4
        syscall

        ################# SORTIEREN DER FELDER #################################

        la $a0,x
        addi $a1,$a0,36
        jal sort

        la $a0,y
        addi $a1,$a0,36
        jal sort

        la $a0,z
        addi $a1,$a0,36
        jal sort

        ##################### AUSGABE DER FELDER NACH DEM SORTIEREN ############

        la $a0,x
        addi $a1,$a0,40
        jal print

        la $a0,y
        addi $a1,$a0,40
        jal print

        la $a0,z
        addi $a1,$a0,40
        jal print

        ####################### PROGRAMMENDE ###################################

        li $v0,10
        syscall

######################### FUNKTION ZUR EINFACHEREN AUSGABE VON FELDERN #########

print:  addi $sp,$sp,-4
        sw $ra,0($sp)
        move $t1,$a0

        loop:   sub $t0,$t1,$a1
                bgez $t0,back
                lw $a0,0($t1)
                li $v0,1
                syscall
                la $a0,sp
                li $v0,4
                syscall
                addi $t1,$t1,4
                j loop

        back:   la $a0,n
                li $v0,4
                syscall
                lw $ra,0($sp)
                addi $sp,$sp,4
                jr $ra

###################### SORTIER FUNKTION #######################################

sort:   addi $sp,$sp,-12
        sw $ra,0($sp)
        sw $a1,4($sp)
        sw $a0,8($sp)

        sub $t0,$a0,$a1
        bgez $t0,returnSort     # wenn $a0 -$a1 >= 0 ==> returnSort

        jal great               # Der größte Wert wird gesucht
        move $a1,$v0
        lw $a0,8($sp)           # $a0 wird in great verändert und muss zurückgesetzt werden

        jal func                # Der größte wird mit dem ersten getauscht

        addi $a0,$a0,4
        lw $a1,4($sp)           # $a1 muss wieder zurückgesgetzt werde, da func
                                # das Ergebnis in $a1 brauchte
        lw $ra,0($sp)           # $ra muss zurückgesetzt werden, da die anderen
                                # Funktionen mit jal aufgerufen wurden
        j sort

        returnSort: lw $ra,0($sp)
                    addi $sp,$sp,8
                    jr $ra

###################### FUNKTION ZUM TAUSCH ZWEIER WERTE IM SPEICHER ###########

func:   addi $sp,$sp,-4
        sw $ra,0($sp)       # Es wird platz gemacht und die $ra wird gespeichert

        move $t0,$a0
        move $t1,$a1        # $a0 und $a1 werden nochmal in anderen Registern gesp.

        lw $a0,0($a0)       # $a0 = deref($a0)
        lw $a1,0($a1)       # $a1 = deref($a1)
        sw $a1,0($t0)       # Der wert in dem Register, dessen Adresse in $a0 gesp. war
                            # wird in den Wert geändert aus dem Regis, dessen Adresse in $a1
                            # gesp. war
        sw $a0,0($t1)       # nochmal das gleiche nur anders herum

        lw $ra,0($sp)       # $ra wird wieder gesetzt
        move $a0,$t0        # $a0 wird auf seinen Ursprünglichen Wert gesetzt
        move $a1,$t1        # $a1 wird auf seinen Ursprünglichen Wert gesetzt

        addi $sp,$sp,4      # $sp wird zurück gesetzt
        jr  $ra

########################### FUNKTION ZUM ERMITTELN DES GRÖßTEN WERTES im ARRAY##

great:  addi $sp,$sp,-8             # Der Sp wird erweitert und später wichtige
        sw $ra,0($sp)               # Variablen werden gespeichert
        lw $t0,0($a0)
        sw $a0,4($sp)               # in $a0 wird das Ergebnis gesp.

        while:  sub $t3,$a0,$a1
                bgez $t3,return     # wenn $a0 -$a1 >= 0 ==> return

                lw $t1,4($a0)
                sub $t2,$t0,$t1
                bltz $t2,switch     # wenn ($a0) < 4($a0) ==> switch

                addi $a0,$a0,4      # sonst schieb den pointer einen weiter und
                j while             # ==> while

        switch: move $t0,$t1
                addi $a0,$a0,4
                sw $a0,4($sp)       # nach verschieben des pointers wird der neue
                j while             # größere Wert in $a0 gesp.

        return: lw $ra,0($sp)
                lw $v0,4($sp)       # die Adresse wird in $v0 gesp.
                addi $sp,$sp,8
                move $v1,$t0        # der Wert wird in $v1 gesp.
                jr $ra
