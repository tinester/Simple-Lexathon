.text
li $s0, 0 #$s0 will help the syscalls wait
playOdeToJoy: 
li $a1, 1000
li $a2, 80
li $a3, 50
li $v0, 31 
li $s0, 0

# first bar
li $a0, 64#e
syscall
wait1: addi $s0, $s0, 1
       blt $s0, 300000, wait1
       li $s0, 0
       
li $a0, 64#e
syscall
wait2: addi $s0, $s0, 1
       blt $s0, 300000, wait2
       li $s0, 0
       
li $a0, 65#f
syscall
wait3: addi $s0, $s0, 1
       blt $s0, 300000, wait3
       li $s0, 0
       
li $a0, 67#g
syscall
wait4: addi $s0, $s0, 1
       blt $s0, 300000, wait4
       li $s0, 0
       
li $a0, 67#g
syscall
wait5: addi $s0, $s0, 1
       blt $s0, 300000, wait5
       li $s0, 0
       
li $a0, 65#f
syscall
wait6: addi $s0, $s0, 1
       blt $s0, 300000, wait6
	li $s0, 0
	
li $a0, 64#e
syscall
wait7: addi $s0, $s0, 1
       blt $s0, 300000, wait7
       li $s0, 0
       
li $a0, 62 #d
syscall
wait8: addi $s0, $s0, 1
       blt $s0, 300000, wait8
       li $s0, 0
       
li $a0, 60 #c
syscall
wait9: addi $s0, $s0, 1
       blt $s0, 300000, wait9
       li $s0, 0
       
li $a0, 60 #c
syscall
wait10: addi $s0, $s0, 1
       blt $s0, 300000, wait10
       li $s0, 0
       
li $a0, 62 #d
syscall
wait11: addi $s0, $s0, 1
       blt $s0, 300000, wait11
       li $s0, 0       
      
li $a0, 64 #e
syscall
wait12: addi $s0, $s0, 1
       blt $s0, 300000, wait12
       li $s0, 0
       
li $a0, 64 #e
syscall
wait13: addi $s0, $s0, 1
       blt $s0, 450000, wait13
       li $s0, 0       
       
li $a0, 62 #d
syscall
wait14: addi $s0, $s0, 1
       blt $s0, 150000, wait14
       li $s0, 0 
       
li $a0, 62 #d
syscall
wait15: addi $s0, $s0, 1
       blt $s0, 600000, wait15
       li $s0, 0 
       
#2nd bar

li $a0, 64#e
syscall
wait16: addi $s0, $s0, 1
       blt $s0, 300000, wait16
       li $s0, 0
       
li $a0, 64#e
syscall
waitScrewUp: addi $s0, $s0, 1
       blt $s0, 300000, waitScrewUp
       li $s0, 0
       
li $a0, 65#f
syscall
wait17: addi $s0, $s0, 1
       blt $s0, 300000, wait17
       li $s0, 0
       
li $a0, 67#g
syscall
wait18: addi $s0, $s0, 1
       blt $s0, 300000, wait18
       li $s0, 0
       
li $a0, 67#g
syscall
wait19: addi $s0, $s0, 1
       blt $s0, 300000, wait19
       li $s0, 0
       
li $a0, 65#f
syscall
wait20: addi $s0, $s0, 1
       blt $s0, 300000, wait20
	li $s0, 0
	
li $a0, 64#e
syscall
wait21: addi $s0, $s0, 1
       blt $s0, 300000, wait21
       li $s0, 0
       
li $a0, 62 #d
syscall
wait22: addi $s0, $s0, 1
       blt $s0, 300000, wait22
       li $s0, 0
       
li $a0, 60 #c
syscall
wait23: addi $s0, $s0, 1
       blt $s0, 300000, wait23
       li $s0, 0
       
li $a0, 60 #c
syscall
wait24: addi $s0, $s0, 1
       blt $s0, 300000, wait24
       li $s0, 0
       
li $a0, 62 #d
syscall
wait25: addi $s0, $s0, 1
       blt $s0, 300000, wait25
       li $s0, 0       
      
li $a0, 64 #e
syscall
wait26: addi $s0, $s0, 1
       blt $s0, 300000, wait26
       li $s0, 0
       
li $a0, 62 #d
syscall
wait27: addi $s0, $s0, 1
       blt $s0, 450000, wait27
       li $s0, 0       
       
li $a0, 60 #c
syscall
wait28: addi $s0, $s0, 1
       blt $s0, 150000, wait28
       li $s0, 0 
       
li $a0, 60 #c
syscall
wait29: addi $s0, $s0, 1
       blt $s0, 600000, wait29
       li $s0, 0 
       
#3rd bar


li $a0, 62 #d
syscall
wait30: addi $s0, $s0, 1
       blt $s0, 300000, wait30
       li $s0, 0
       
li $a0, 62 #d
syscall
wait31: addi $s0, $s0, 1
       blt $s0, 300000, wait31
       li $s0, 0
       
li $a0, 64 #e
syscall
wait32: addi $s0, $s0, 1
       blt $s0, 300000, wait32
       li $s0, 0
       
li $a0, 60 #c
syscall
wait33: addi $s0, $s0, 1
       blt $s0, 300000, wait33
       li $s0, 0
       
li $a0, 62 #d
syscall
wait34: addi $s0, $s0, 1
       blt $s0, 300000, wait34
       li $s0, 0
       
li $a0, 64 #e
syscall
wait35: addi $s0, $s0, 1
       blt $s0, 150000, wait35
       li $s0, 0
       
li $a0, 65 #f
syscall
wait36: addi $s0, $s0, 1
       blt $s0, 150000, wait36
       li $s0, 0
       
li $a0, 64 #e
syscall
wait37: addi $s0, $s0, 1
       blt $s0, 300000, wait37
       li $s0, 0    
       
li $a0, 60 #c
syscall
wait38: addi $s0, $s0, 1
       blt $s0, 300000, wait38
       li $s0, 0   
       
li $a0, 62 #d
syscall
wait39: addi $s0, $s0, 1
       blt $s0, 300000, wait39
       li $s0, 0
       
li $a0, 64 #e
syscall
wait40: addi $s0, $s0, 1
       blt $s0, 150000, wait40
       li $s0, 0
       
li $a0, 65 #f
syscall
wait41: addi $s0, $s0, 1
       blt $s0, 150000, wait41
       li $s0, 0
       
li $a0, 64 #e
syscall
wait42: addi $s0, $s0, 1
       blt $s0, 300000, wait42
       li $s0, 0 
       
li $a0, 62 #d
syscall
wait43: addi $s0, $s0, 1
       blt $s0, 300000, wait43
       li $s0, 0 
       
li $a0, 60 #c
syscall
wait44: addi $s0, $s0, 1
       blt $s0, 300000, wait44
       li $s0, 0 
       
li $a0, 62 #d
syscall
wait45: addi $s0, $s0, 1
       blt $s0, 300000, wait45
       li $s0, 0 
       
li $a0, 55 #low g
syscall
wait46: addi $s0, $s0, 1
       blt $s0, 300000, wait46
       li $s0, 0 
       
li $a0, 64 #e
syscall
wait47: addi $s0, $s0, 1
       blt $s0, 300000, wait47
       li $s0, 0 

#4th bar


li $a0, 64#e
syscall
wait48: addi $s0, $s0, 1
       blt $s0, 300000, wait48
       li $s0, 0
       
li $a0, 64#e
syscall
waitScrewUp15: addi $s0, $s0, 1
       blt $s0, 300000, waitScrewUp15
       li $s0, 0
       
li $a0, 65#f
syscall
wait49: addi $s0, $s0, 1
       blt $s0, 300000, wait49
       li $s0, 0
       
li $a0, 67#g
syscall
wait50: addi $s0, $s0, 1
       blt $s0, 300000, wait50
       li $s0, 0
       
li $a0, 67#g
syscall
wait51: addi $s0, $s0, 1
       blt $s0, 300000, wait51
       li $s0, 0
       
li $a0, 65#f
syscall
wait52: addi $s0, $s0, 1
       blt $s0, 300000, wait52
	li $s0, 0
	
li $a0, 64#e
syscall
wait53: addi $s0, $s0, 1
       blt $s0, 300000, wait53
       li $s0, 0
       
li $a0, 62 #d
syscall
wait54: addi $s0, $s0, 1
       blt $s0, 300000, wait54
       li $s0, 0
       
li $a0, 60 #c
syscall
wait55: addi $s0, $s0, 1
       blt $s0, 300000, wait55
       li $s0, 0
       
li $a0, 60 #c
syscall
wait56: addi $s0, $s0, 1
       blt $s0, 300000, wait56
       li $s0, 0
       
li $a0, 62 #d
syscall
wait57: addi $s0, $s0, 1
       blt $s0, 300000, wait57
       li $s0, 0       
      
li $a0, 64 #e
syscall
wait58: addi $s0, $s0, 1
       blt $s0, 300000, wait58
       li $s0, 0
       
li $a0, 62 #d
syscall
wait59: addi $s0, $s0, 1
       blt $s0, 450000, wait59
       li $s0, 0       
       
li $a0, 60 #c
syscall
wait60: addi $s0, $s0, 1
       blt $s0, 150000, wait60
       li $s0, 0 
       
li $a0, 60 #c
syscall
wait61: addi $s0, $s0, 1
       bne $s0, 600000, wait61
       li $s0, 0 
       
waitJump: addi $s0, $s0, 1
       bne $s0, 600000, waitJump
       li $s0, 0        
       j playOdeToJoy

       
