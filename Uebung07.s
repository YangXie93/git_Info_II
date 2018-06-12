.data

n:  .asciiz "\n"
eps: .asciiz "Bitte geben Sie die Genauigkeit ein\n"
x: .asciiz "Bitte geben Sie nun die Zahl ein\n"
erg: .asciiz "Der aproxmierte Sinuswert : "
.text
################################ Main ################################################
main:   la $a0,eps
        li $v0,4
        syscall

        li $v0,7
        syscall

        mov.d $f2,$f0

        la $a0,x
        li $v0,4
        syscall

        li $v0,7
        syscall

        jal approx

        la $a0,erg
        li $v0,4
        syscall

        li $v0,3
        syscall

        la $a0,n
        li $v0,4
        syscall

        li $v0,10
        syscall
##################################### Approximations Funktion ###############################
#------------------------- Initialisierung ---------------------------------------------------
approx: add $sp,$sp,-64
        sw $ra,56($sp)
        s.d $f0,($sp)
        s.d $f4,8($sp)
        s.d $f6,16($sp)
        s.d $f8,24($sp)

        li.d $f12,0.0
        li.d $f4,-1.0
        li.d $f8,1.0
        li.d $f6,1.0
#--------------------------------------------------------------------------------------------
loop:   s.d $f12,32($sp)            # Erneutes Speichern einiger Werte, damit nach veränderung
        s.d $f4,40($sp)             # in der Schleife mit den selben Werten weiter gearbeitet
        s.d $f2,48($sp)             # werden kann
        li.d $f4,0.0
        li.d $f2,1.0

#---------------------------------- x^2i-1 -----------------------------------------------------
        pow:    mul.d $f2,$f2,$f0   # x *x
                add.d $f4,$f4,$f8   # zähler++
                c.lt.d $f4,$f6      # solange zähler < grenze
                bc1t pow
                bc1f on

#----------------------------------------------------------------------------------------------

on:     mov.d $f0,$f6

        jal fac

        div.d $f0,$f2,$f12          #  $f0 = (x^2i-1)/(2i-1)!

        l.d $f2,48($sp)
        c.le.d $f2,$f0              # Abbruch Bedingung flag = ( (x^2i-1)/(2i-1)! <= epsilon )

        l.d $f4,40($sp)
        neg.d $f4,$f4
        mul.d $f0,$f0,$f4           # Der Term (-1)^i+1 aus der Formel wird eingebracht

        l.d $f12,32($sp)
        add.d $f12,$f12,$f0         # Das zwischen Ergebnis wird zu den vorherigen dazu addiert

        l.d $f0,($sp)               # $f0 wird zurückgesetzt

        add.d $f6,$f6,$f8
        add.d $f6,$f6,$f8

        bc1t loop                   # flag = ture ==> loop

        lw $ra,56($sp)              # Die Register werden zurückgesetzt
        l.d $f4,8($sp)              #
        l.d $f6,16($sp)             #
        l.d $f8,24($sp)             #
        add $sp,$sp,64              #

        jr $ra

#################################### Fakultät ##########################################
#--------------------------------Initialisierung---------------------------------------
fac:    add $sp,$sp,-28
        s.d $f0,($sp)
        s.d $f2,8($sp)
        sw $ra,16($sp)
        s.d $f4,20($sp)
        l.d $f4,($sp)
        li.d $f2,1.0
        li.d $f12,1.0
#--------------------------------------------------------------------------------------
#------------------------------- Runden -----------------------------------------------
for:    c.lt.d $f4,$f2              # solange $f4 > 1
        bc1t round
        sub.d $f4,$f4,$f2           # $f4 -= 1
        bc1f for

round:  li.d $f2,0.5
        c.le.d $f4,$f2              # wenn Nachkommastellen > 0,5 dann runde auf sonst ab
        li.d $f2,1.0
        bc1t down
        bc1f up

down:   sub.d $f0,$f0,$f4
        l.d $f4,20($sp)
        j while

up:     sub.d $f0,$f0,$f4
        add.d $f0,$f0,$f2
        l.d $f4,20($sp)
        j while
#--------------------------------------------------------------------------------------
#----------------------------- Schleife ----------------------------------------------
while:  c.lt.d $f0,$f2              # flag = $f0 < $f2
        bc1t exit                   # if flag == true ==> exit
        mul.d $f12,$f12,$f0
        sub.d $f0,$f0,$f2
        bc1f while

exit:   l.d $f0,($sp)               # zurück setzen der Werte und des Stackpointer
        l.d $f2,8($sp)
        lw $ra,16($sp)
        add $sp,$sp,28
        jr $ra
