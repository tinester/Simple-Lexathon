.data
gameWord: .asciiz "blackjack" # This is the word the entire game will be based around. Middle letter is randomized. Any 9 letter word can be choosen.

mainScreenPlaceholder1: .asciiz "Welcome to Lexathon! Please wait a moment... \n\n"
mainScreenMatrixPlaceholder: .asciiz "3x3 matrix of letters here\n"
mainScreenScore: .asciiz "\nYour score is "
mainScreenStrikes: .asciiz "\nThe number of strikes you have is "
mainScreenEnterGuess: .asciiz "\nEnter a guess, or enter a 1 to scramble the matrix: "
gameOverPlayAgainQ: .asciiz "Enter 1 to play again or anything else to exit: "
incrementedScore: .asciiz "\nYou guessed a word correctly!\n\n"
incrementedStrike: .asciiz "\nYou guessed a word incorrectly.\n\n"
correctWordsPrompt: .asciiz "The correct words were: \n\n"
invalidWordPrompt: .asciiz "\nYou must enter a word between 4-9 (including 4 and 9).\n"
foundWordsAcknowledgement: .asciiz "Your found words were: "
rescrambleMessage: .asciiz "\nRescrambled!\n\n"
scoreAcknowledgement: .asciiz "Your score was: "
nothing: .asciiz "Nothing\n"
thisBeATestString: .asciiz "\ntest\n"
alreadyInFoundWordsPrompt: .asciiz "\nYou've already guessed that word!\n\n"
guessStr: .space 100

foundWords: .space 500
correctWords: .space 5000
dictSpace: .space 500000
tempWord: .space 10
temp2: .space 10
dictFile: .asciiz "updatedwords"
centralLetter: .space 1

startGame: .asciiz "Enter anything to Start Game and (0) to Automatically End Game: "

# Print matrix data
tempStr: .space 10 #Another tempStr to use if necessary in scrambleWord
scrambledWord: .space 10 #Put the scrambled word in here
newLine: .byte '\n'
nullTerminator: .byte '\0'
spacing: .asciiz "  "



.text

li $v0, 4 # Prints "Welcome to Lexathon"
la $a0, mainScreenPlaceholder1
syscall
j beginGame

#THESE ARE ALL FUNCTIONS.#################################################################################
#######################################################################################################
# Checks if input str is already in foundWords
# $a0 = input str; returns 1 if inputStr is in foundWords; returns 0 if not in foundWords
checkIfStrInFound: addi $t0, $a0, 0 #$t0 holds the input str address
		   #lb $t1, ($t0) #$t1 contains the current char in the input str
		   la $t2, foundWords #$t2 contains the address of foundWords
		   #lb $t3, ($t2) #$t3 contains the current char in foundWords
		   la $t4, newLine
		   lb $t4, ($t4) #$t4 contains the newline char '\n'
		   la $t5, nullTerminator
		   lb $t5, ($t5) #$t5 contains the null terminator char '\0'
checkIfStrInFoundMainLoop: lb $t1, ($t0) #$t1 contains the current char in the input str 
			   lb $t3, ($t2) #$t3 contains the current char in foundWords
			   addi $t0, $t0, 1
			   addi $t2, $t2, 1
			   beq $t3, $t4, checkIfStrInFoundStrMatch # See if current char in foundWords is newline
			   beq $t1, $t3, checkIfStrInFoundMainLoop # If current chars match up keep looping
			   beq $t3, $t5, checkIfStrInFoundStrNotMatch #checks if current char in foundWords is null
			   j getToNextFoundWord
checkIfStrInFoundStrMatch: li $v0, 4
			   la $a0, alreadyInFoundWordsPrompt
			   syscall
			   li $v0, 1
			   jr $ra
checkIfStrInFoundStrNotMatch: li $v0, 0
			      jr $ra
getToNextFoundWord: lb $t3, ($t2)
		    addi $t2, $t2, 1
		    bne $t3, $t4, getToNextFoundWord
		    addi $t0, $a0, 0 
		    j checkIfStrInFoundMainLoop
		    
			   

# Decides whether to rescramble or not, then maybe rescramble; returns 1 if rescrambles and 0 otherwise (in $v0)
# If guessStr is "1\n" then we rescramble
rescrambleTheWordQ: la $t0, guessStr #$t0 has the guessed str
		   lb $t1, ($t0) #$t1 holds first char in guessStr
		   addi $t0, $t0, 1
		   lb $t2, ($t0) #$t2 holds second char in guessStr
		   beq $t1, 49, rescrambleTheWordQFirstIsOne #branch if 1st char is ascii for '1'
		   li $v0, 0
		   jr $ra
rescrambleTheWordQFirstIsOne: beq $t2, 10, rescrambleTheWordQSecondIsNewLine #check if second char is ascii for '\n'
			      li $v0, 0
			      jr $ra
rescrambleTheWordQSecondIsNewLine: addi $sp, $sp, -4
				   sw $ra, 0($sp)
				   jal rescramble #rescrambles
				   lw $ra, 0($sp)
				   addi $sp, $sp, 4
				   la $a0, rescrambleMessage #Tells user that you rescrambled
				   li $v0, 4
				   syscall
				   li $v0, 1
				   jr $ra 

#rescrambles scambledWord; requires no arguments
rescramble: addi $sp, $sp, -4 #Copy scambledWord into tempStr
	    sw $ra, 0($sp)
	    la $a0, scrambledWord
	    la $a1, tempStr
	    jal copyStr
	    lw $ra, 0($sp)
	    addi $sp, $sp, 4
	    
	    addi $sp, $sp, -4
	    sw $ra, 0($sp)
	    la $a0, tempStr
	    jal scrambleWordRetain
	    lw $ra, 0($sp)
	    addi $sp, $sp, 4
	    
	    jr $ra

#a0 == the input str to check; $v0 will hold 1 if valid(input is 4-9 char long) and 0 if invalid
# Assumes will be null terminated with an extra '/n' at the end. e.g hello\n\0
checkStr: add $t0, $a0, $0 #$t0 is the address of the input str
	  add $t1, $0, $0 #$t1 will be the length of the input str 
	  add $t2, $0, $0 #$t2 is true/false depending on if the input str is valid/invalid
	  addi $t3, $0, 12 #$t3 holds 11
	  
	  addi $sp, $sp, -20 #Get the length of the input str
	  sw $t0, 0($sp)
	  sw $t1, 4($sp)
	  sw $t2, 8($sp)
	  sw $t3, 12($sp)
	  sw $ra, 16($sp)
	  addi $a0, $t0, 0
	  jal strLen
	  lw $t0, 0($sp)
	  lw $t1, 4($sp)
	  lw $t2, 8($sp)
	  lw $t3, 12($sp)
	  lw $ra, 16($sp)
	  addi $sp, $sp, 20
	  
	  addi $t1, $v0, 0 #Checks if inputStr between 4 and 9 characters
	  sgt $t2, $t1, 4
	  beq $t2, 0, checkStrInvalid
	  slt $t2, $t1, $t3
	  beq $t2, 0, checkStrInvalid
	  j checkStrValid
checkStrInvalid: la $a0, invalidWordPrompt
		 li $v0, 4
		 syscall
		 addi $v0, $0, 0
		 jr $ra
checkStrValid: addi $v0, $0, 1
	       jr $ra

# $a0 == source string; $a1 == destination string(the string at this address that will be replaced by string at source string)
copyStr: add $t0, $a0, $0 #$t0 is the src string
	 add $t1, $a1, $0 #$t1 is the destinations string
	 li $t2, 0 #$t2 is the current index
	 li $t3, 0 #$t3 holds the current character
	 lb $t5, newLine
copyStrLoop: add $t0, $a0, $t2
	     add $t1, $a1, $t2
	     lb $t3, ($t0)
	     sb $t3, ($t1)
	     addi $t2, $t2, 1
	     add $t4, $0, $0
	     beq $t3, $t5, copyStrExit
	     bne $t3, $t4, copyStrLoop
	     copyStrExit:
	     jr $ra

# Returns the length of a null terminated string(returned in in $v0); $a0: the given str
strLen: add $t0, $0, $a0 #$t0 holds the address of the given str
	li $t1, 0 # $t1 holds the length of the string
	la $t2, nullTerminator
	lb $t2, ($t2) #$t2 has the null terminator byte
	#lb $t3, ($t3) #$t3 has the new line char byte
	li $v0, 11
	lb $a0, ($t0)
strLenLoop: #syscall #Prints out the whole for each strLen call; just for testing
	    addi $t1, $t1, 1
	    add $t0, $t0, 1 #$t0 has the address of the current char
	    lb $a0, ($t0)
	    bne $a0, $t2, strLenLoop
	    #li $v0, 1 #prints out the strLen; just for testing
	    #add $a0, $0, $t1 #prints out the strLen; just for testing
	    #syscall #prints out the strLen; just for testing
	    move $v0, $t1
	    jr $ra

# Places a given null-terminated string with a given index deleted in tempStr; $a0: address of input str 
#$a1: index to be deleted; if $a1 is bigger than 10, nothing happens($v0 doesn't change).
#$v0 contains the ascii char that was deleted
deleteIndex: add $t0, $0, $a0 #$t0 holds the address of the memory space we're copying to
	     addi $t0, $t0, -1
	     addi $a0, $a0, -1
 	     la $t1, nullTerminator
	     lb $t1, ($t1) #$t2 has the null terminator byte
	     li $t3, -1 #$t3 keeps track of how many iterations it has been
deleteIndexLoop: addi $t3, $t3, 1
		 addi $a0, $a0, 1
	         beq $t3, $a1, deleteIndexSetReturnChar
	         addi $t0, $t0, 1
                 lb $t2, ($a0)  
	         sb $t2, ($t0)
	         bne $t2, $t1, deleteIndexLoop #Keep looping if the current char isn't \0
	         move $v0, $t4
	         jr $ra
deleteIndexSetReturnChar: lb $t4, ($a0)
 			  j deleteIndexLoop

 #$a0 is the null-terminated str we want to scramble
 # Puts scrambled word in scrambledWord 
 # Randomly scrambles all letters. Keeps the central letter the same    
 scrambleWordRetain: move $t0, $a0 #$t0 holds the address of the given null-terminated str
	      li $t1, 0 #$t1 holds the current index of scrambledWord
	      li $v0, 30 #Get a seed for random number
	      la $t2, scrambledWord #$t2 is the resulting scrambledWord
	      syscall
	      add $a1, $0, $a0 #Set seed for random number
	      li $v0 40
	      syscall
	      
	      #Put the fifth letter in gameWord in the middle of the scrambledWord #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE(not true here)
	      # Before we even start iterating. Be sure to skip the 4th index in this case. #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE(not true here)
	      # By skipping the 4th index, we assume that input str will always be 9 letters #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE(not true here)
	      addi $sp, $sp, -20 # Delete a random char from given str #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE(not true here)
	      sw $t0, 0($sp) #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE(not true here)
	      sw $t1, 4($sp) #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE (not true here)
	      sw $t2, 8($sp) #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE (not true here)
	      sw $t3, 12($sp) #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE (not true here)
	      sw $ra, 16($sp) #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE (not true here)
	      addi $a1, $0, 4 #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE(not true here)
	      add $a0, $t0, $0 #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE(not true here)
	      jal deleteIndex #delete first char from tempStr #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE(not true here)
	      lw $t0, 0($sp) #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE(not true here)
	      lw $t1, 4($sp) #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE(not true here)
	      lw $t2, 8($sp) #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE(not true here)
	      lw $t3, 12($sp) #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE(not true here)
	      lw $ra, 16($sp) #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE(not true here)
	      addi $sp, $sp, 20 #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE(not true here)
	      addi $t3, $t2, 4 #$t3 is the the address of the central byte of scrambledWord #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE(not true here)
	      sb $v0, ($t3) #Loads the first char of tempStr into index 4 of scrambledWord #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE(not true here)
scrambleWordLoop: beq $t1, 4, skipIndexFour #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE(not true here)
		  add $t3, $t2, $t1 #$t3 is the address of scrambledWord plus the index
		  addi $sp, $sp, -20 # Get the current length of the given str
	      	  sw $t0, 0($sp)
	      	  sw $t1, 4($sp)
	      	  sw $t2, 8($sp)
	      	  sw $t3, 12($sp)
	      	  sw $ra, 16($sp)
	      	  add $a0, $0, $t0
	      	  jal strLen 
	      	  lw $t0, 0($sp)
	      	  lw $t1, 4($sp)
	      	  lw $t2, 8($sp)
	      	  lw $t3, 12($sp)
	      	  lw $ra, 16($sp)
	      	  addi $sp, $sp, 20
	      
	      	  add $a1, $0, $v0
	      	  li $v0, 42 #Get pseudorandom
	      	  syscall
	      	  
	      	  addi $sp, $sp, -20 # Delete a random char from given str
	      	  sw $t0, 0($sp)
	      	  sw $t1, 4($sp)
	      	  sw $t2, 8($sp)
	      	  sw $t3, 12($sp)
	      	  sw $ra, 16($sp)
	      	  add $a1, $0, $a0
	      	  add $a0, $t0, $0
	      	  jal deleteIndex 
	      	  lw $t0, 0($sp)
	      	  lw $t1, 4($sp)
	      	  lw $t2, 8($sp)
	      	  lw $t3, 12($sp)
	      	  lw $ra, 16($sp)
	      	  addi $sp, $sp, 20
	      	  
	      	  sb $v0, ($t3)
	      	  addi $t1, $t1, 1 #Increment the scrambledWord index
	      	  bne $t1, 9, scrambleWordLoop
	      	  jr $ra
skipIndexFour: addi $t1, $t1, 1 #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
	       j scrambleWordLoop #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE 

 #$a0 is the null-terminated str we want to scramble
 # Puts scrambled word in scrambledWord 
 # Randomly scrambles all letters including the central character                     
scrambleWordInitial: move $t0, $a0 #$t0 holds the address of the given null-terminated str
	      li $t1, 0 #$t1 holds the current index of scrambledWord
	      li $v0, 30 #Get a seed for random number
	      la $t2, scrambledWord #$t2 is the resulting scrambledWord
	      syscall
	      add $a1, $0, $a0 #Set seed for random number
	      li $v0 40
	      syscall
	      
	      #Put the first letter in gameWord in the middle of the scrambledWord #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
	      # Before we even start iterating. Be sure to skip the 4th index in this case. #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
	      # By skipping the 4th index, we assume that input str will always be 9 letters #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
	      #addi $sp, $sp, -20 # Delete a random char from given str #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
	      #sw $t0, 0($sp) #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
	      #sw $t1, 4($sp) #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
	      #sw $t2, 8($sp) #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
	      #sw $t3, 12($sp) #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
	      #sw $ra, 16($sp) #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
	      #addi $a1, $0, 0 #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
	      #add $a0, $t0, $0 #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
	      #jal deleteIndex #delete first char from tempStr #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
	      #lw $t0, 0($sp) #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
	      #lw $t1, 4($sp) #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
	      #lw $t2, 8($sp) #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
	      #lw $t3, 12($sp) #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
	      #lw $ra, 16($sp) #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
	      #addi $sp, $sp, 20 #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
	      #addi $t3, $t2, 4 #$t3 is the the address of the central byte of scrambledWord #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
	      #sb $v0, ($t3) #Loads the first char of tempStr into index 4 of scrambledWord #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
scrambleWordLoopInitial: #beq $t1, 4, skipIndexFour #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
		  add $t3, $t2, $t1 #$t3 is the address of scrambledWord plus the index
		  addi $sp, $sp, -20 # Get the current length of the given str
	      	  sw $t0, 0($sp)
	      	  sw $t1, 4($sp)
	      	  sw $t2, 8($sp)
	      	  sw $t3, 12($sp)
	      	  sw $ra, 16($sp)
	      	  add $a0, $0, $t0
	      	  jal strLen 
	      	  lw $t0, 0($sp)
	      	  lw $t1, 4($sp)
	      	  lw $t2, 8($sp)
	      	  lw $t3, 12($sp)
	      	  lw $ra, 16($sp)
	      	  addi $sp, $sp, 20
	      
	      	  add $a1, $0, $v0
	      	  li $v0, 42 #Get pseudorandom
	      	  syscall
	      	  
	      	  addi $sp, $sp, -20 # Delete a random char from given str
	      	  sw $t0, 0($sp)
	      	  sw $t1, 4($sp)
	      	  sw $t2, 8($sp)
	      	  sw $t3, 12($sp)
	      	  sw $ra, 16($sp)
	      	  add $a1, $0, $a0
	      	  add $a0, $t0, $0
	      	  jal deleteIndex 
	      	  lw $t0, 0($sp)
	      	  lw $t1, 4($sp)
	      	  lw $t2, 8($sp)
	      	  lw $t3, 12($sp)
	      	  lw $ra, 16($sp)
	      	  addi $sp, $sp, 20
	      	  
	      	  sb $v0, ($t3)
	      	  addi $t1, $t1, 1 #Increment the scrambledWord index
	      	  bne $t1, 9, scrambleWordLoopInitial
	      	  
	      	  # Saves the central letter in central letter space
	      	  la $t7, scrambledWord
addi $t7, $t7, 4
lb $t7, ($t7)
la $t9, centralLetter
sb $t7, ($t9)  	  
	      	  jr $ra
#skipIndexFour: addi $t1, $t1, 1 #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE
#	       j scrambleWordLoop #THIS ASSIGNS FIRST CHAR TO MIDDLE (NOT RANDOM). DELETE THIS IF YOU WANT RANDOM MIDDLE 
         
# Prints a new line		
printNewLine: li $v0, 11
	      la $t0, newLine
	      lb $a0, ($t0)
	      syscall
	      jr $ra

# $a0 is the given str you want to print
# $v0 will contain the central character 
printMatrix: add $t0, $a0, $0 #$t0 has the address of the given str
	     add $t1, $0, $0 #$t1 has the index
printMatrixLoop: lb $a0, ($t0)
      		 li $v0, 11
      		 syscall
      		 la $a0, spacing
      		 li $v0, 4
      		 syscall
      		 addi $t0, $t0, 1
      		 addi $t1, $t1, 1
      		 
      		 beq $t1, 5, setCentralCharacter
      		 beq $t1, 3, printMatrixNewline
      		 beq $t1, 6, printMatrixNewline
      		 bne $t1, 9, printMatrixLoop
      		 add $v0, $t2, $0
      		 jr $ra
printMatrixNewline: addi $sp, $sp, -16
      		    sw $t0, 0($sp)
      		    sw $t1, 4($sp)
      		    sw $t2, 8($sp)
      		    sw $ra, 12($sp)
      		    jal printNewLine
      		    lw $t0, 0($sp)
      		    lw $t1, 4($sp)
      		    lw $t2, 8($sp)
      		    lw $ra, 12($sp)
      		    addi $sp, $sp, 16
      		    j printMatrixLoop
setCentralCharacter: addi $t0, $t0, -1
		     lb $t2, ($t0) #$t2 will hold the central character within the printMatrix subroutine
		     addi $t0, $t0, 1
		     j printMatrixLoop

# $a0 is the address of the string we want to load into foundWords; Assumes input string is null-terminated
LoadIntoFoundWord: la $t0, foundWords #$t0 has the address of the first byte in foundWords
		   add $t1, $a0, $0 #$t1 has the address of the str we want to load
		   la $t3, nullTerminator #$t3 has '\0'
		   lb $t3, ($t3) #If foundWords is empty, immediately start loading into foundWords
		   lb $t4, ($t0)
		   beq $t4, $t3, LoadIntoFoundWordLoop
findWhereToStartInFoundWords: addi $t0, $t0, 1 # Keep incrementing the address of foundWords til it points to a null character
			      lb $t4, ($t0) #$t4 has the current char in foundWords
			      bne $t4, $t3, findWhereToStartInFoundWords
LoadIntoFoundWordLoop: lb $t4, ($t1) #t4 now has the current char in the input string
		       beq $t4, $t3, finishLoadWord #Exit function if $t4 is '\0'
		       sb $t4, ($t0)
		       addi $t0, $t0, 1
		       addi $t1, $t1, 1
		       j LoadIntoFoundWordLoop
finishLoadWord: jr $ra

# Makes foundWords all null terminator characters; requires no arguments
clearFoundWords: la $t0, foundWords #$t0 has the address of foundWords
		 la $t1, nullTerminator #$t1 has '\0'
		 lb $t1, ($t1) #If foundWords is empty, immediately start loading into foundWords
clearFoundWordsLoop: lb $t2, ($t0) #$, t2 has current char in foundWords
		     beq $t2, $t1, endClearFoundWords
		     sb $t1, ($t0)
		     addi $t0, $t0, 1
		     j clearFoundWordsLoop
endClearFoundWords: jr $ra
			      
# LANE CODE		   

### CHECK WORD FUNCTION ###		   		   
# Check word assumes a user-given word has been stored in $v0, to check against the words loaded in correctWords.		   
checkWord: 
li $t0, 0 # $t0 will serve as a byte counter, checking we do not exceed buffer space
la $t1, correctWords # Load the buffer of words into $t1

newwordloop:
la $t2, ($a0) # Load the word to check against into $t2

strloop:
lb $t3, ($t1) # Load current byte of word buffer into $t3
lb $t4, ($t2) # Load current byte of the correct word into $t4

# Check if we are at the end of the words
lb $t5, newLine
lb $t6, nullTerminator
beq $t4, $t5, strend
beq $t4, $t6, match
beq $t3, $t5, bufend

# If the bytes are not equal, go on to the next word
bne $t3, $t4, bufend

# Increment to the next byte in the word
addi $t1, $t1, 1
addi $t2 $t2, 1
addi $t0, $t0, 1 # Increment our byte counter

bgt $t0, 5000, mismatch # If buffer is exceeded, the string was not found. MUST UPDATE BUFFER SIZE HERE IF CHANGED !!!!!!!

j strloop
strend:
beq $t3, $t4, match # If $t3 and $t4 both contain \n here, the strings were a match
beq $t3, $t6, match # Also if the word is at a null term, it was a match
bufend:
bgt $t0, 5000, mismatch # If buffer is exceeded, the string was not found. MUST UPDATE BUFFER SIZE HERE IF CHNANGED !!!!!!!
lb $t3, ($t1) # Load current byte of word buffer into $t3
addi $t1, $t1, 1 # Get next byte of the word buffer
addi $t0, $t0, 1 # Increment buffer counter
beq $t3, $t5, newwordloop # Check if it is the end of the word
j bufend

bufendexit:
addi $t1, $t1, 1 # Get next byte of the word buffer
j newwordloop

match:
li $s0, 1
jr $ra
mismatch:
li $s0, 0
jr $ra


### PRINT DICTIONARY FUNCTION ### 
# printDictionary prints out the correct board words
printDictionary:
# Print the correct words prompt
li $v0 4
la $a0, correctWordsPrompt
syscall
# Print the correct words buffer
li $v0 4
la $a0, correctWords
syscall
jr $ra

printFoundWords:# Print the foundWords buffer
la $t0, foundWords #$t0 holds the first byte of foundWords
lb $t0, ($t0)
la $t1, nullTerminator #$t1 holds '\0'
lb $t1, ($t1)
beq $t0, $t1, printNothingIfFoundWordsEmpty #Print "Nothing" if nothing in foundWords

li $v0, 4
la $a0, foundWordsAcknowledgement
syscall
li $v0 4
la $a0, foundWords
syscall
jr $ra
printNothingIfFoundWordsEmpty: 
li $v0, 4
la $a0, foundWordsAcknowledgement
syscall
li $v0 4
la $a0, nothing
syscall
jr $ra

# END LANE CODE

 ###########################################################################################################
 ###########################################################################################################    		 
      

beginGame:
	# Copy gameWord into tempStr
	la $a0, gameWord
	la $a1, tempStr
	jal copyStr
	# Scramble the nine letter word that will constitute the 3x3 matrix
	la $a0, tempStr
	jal scrambleWordInitial #Don't need to save in the stack because program is just getting started
	
	###
	#For testing rescramble
	#la $a0, scrambledWord
	#li $v0, 4
	#syscall
	#jal rescramble
	#la $a0, spacing
	#li $v0, 4
	#syscall
	#la $a0, scrambledWord
	#li $v0, 4
	#yscall
	###
	
	# LANE CODE 
	# Here we load the all possible correct words into correct space
	
	# Open the dictionary
li $v0, 13 # Prepare for file reading
la $a0, dictFile # Load filename
li $a1, 0 # Open  file for reading
li $a2, 0
syscall
move $s0, $v0 # Save the file parser from $v0 !!! DON'T USE $s0 !!!

# Read the dictionary into the dictionary space
li $v0, 14 # System call for reading from file
move $a0, $s0 # Move file parser into $a0
la $a1, dictSpace # Store the next 1.2 million bytes in our buffer
la $a2, 500000 # Hard coded buffer length to take from file
syscall
		
# Close dictionary file
li $v0, 16 # Prepare for closing file
move $a0, $s0 # Load file parser into argument
syscall
	
findWords:
li $s4, 1 # $s4 will serve as binary flag if the current letter was found in the dict word
li $s3, 0 # $s3 will serve as a binary flag if the central letter was found in the word

la $t0, gameWord # $t0 holds to address of the wordToCheck
la $t1, dictSpace # $t1 will hold the address of dictSpace
la $t2, correctWords # $t2 holds the address of the correct words
la $t3, tempWord # $t3 holds the address of the 10 byte temp word space
li $t4, 0 # $t4 will serve as a byte counter for dictSpace
	
thisWord:
beq $s4, 0, nextWord # If the last letter wasn't a match, go to the next word
lb $t5, ($t1) # $t5 holds the current byte of the dictionary space
addi $t4, $t4, 1 # Increment byte counter of dict space
addi $t1, $t1, 1 # Increment the dict space
lb $t6, newLine
lb $t7, nullTerminator
beq $t5, $t6, checkWord2 # If the current byte is a new line, it only contains letters from wordToCheck. Also need to check if it contains middle letter.
beq $t5, $t7, findWordsExit # If we reach the end of the dictionary space, exit
la $t0, gameWord # Reset the wordToCheck
li $s4, 0 # Assume the letter is invalid to begin
lb $t8, newLine

thisLetter:
lb $t8, newLine
lb $t6, ($t0) # Load the current byte of the wordToCheck into $t6
addi $t0, $t0, 1 # Increment the wordToCheck to the next byte
beq $t6, $t7, thisWord # If the null term of our word to check has been reached, all letters have been checked
beq $t6, $t8, thisWord # If the end line has been reached, all letters have been checked
beq $t6, $t5, letterMatch # If the letters match, then mark and save the letter
j thisLetter # Otherwise, try the next letter of wordToCheck
letterMatch:
li $s4, 1 # Letter was found
sb $t6, ($t3) # Store the correct byte in the tempWord space
addi $t3, $t3, 1
j thisWord

nextWord:
lb $t7, newLine
lb $t8, nullTerminator
nextWordLoop:
li $s4, 1 # Reset the found letter bit
lb $t6, ($t1) # Load current byte of dictionary space
addi $t4, $t4, 1 # Increment the dictionary space byte counter
beq $t6, $t8, findWordsExit # If we reach the end of the dictionary space, exit
beq $t6, $t7, nextWordExit # If it the null term, get the next byte and return to function
addi $t1, $t1, 1 # Otherwise get next byte if it wasnt a new line
j nextWordLoop
nextWordExit:
addi $t1, $t1, 1 # Get the first letter of the new word
la $t3, tempWord # Reset tempWord space
j thisWord

checkWord2:
lb $t7, newLine
sb $t7, ($t3) # Add a newLine deliminator at the end of the temp word
la $t3, tempWord # Reset the tempWord space address
lb $t7, centralLetter # Load the middle character to look for
lb $t6, newLine
checkWordLoop:
lb $t9, ($t3) # Load the current byte of tempWord into $t9
addi $t3, $t3, 1 # Get the next byte of the tempWord
beq $t9, $t6, nextWordExit # When we encounter a newLine in the space we have reached the end
beq $t9, $t7, finalCheckStart # Branch if the central letter was found
j checkWordLoop

finalCheckStart:
la $t9, temp2
la $t0, gameWord
copyLoop: # Copy loop just compies the word to check into temp2
lb $t6, ($t0)
sb $t6, ($t9)
addi $t9, $t9, 1
addi $t0, $t0, 1
lb $t7, nullTerminator
lb $t5, newLine
beq $t6, $t7, finalCheck
beq $t6, $t5, finalCheck
j copyLoop
finalCheck:
la $t8, tempWord
lb $t4, nullTerminator
lb $t5, newLine
sb $t5, ($t9)
finalCheckOuter:
la $t9, temp2
lb $t6, ($t8)
addi $t8, $t8, 1
beq $t6, $t5, saveWord # If we reach the end of the word without branching, all letters were contained
finalCheckLoop:
lb $t7, ($t9)
beq $t6, $t7, finalLetterMatch
addi $t9, $t9, 1
beq $t7, $t5, nextWordExit # If the letter wasn't found, go to the next word as this wasn't a match
j finalCheckLoop
finalLetterMatch:
sb $zero, ($t9)
j finalCheckOuter
		
saveWord:
la $t3, tempWord # Reset tempWord space
lb $t6, newLine # Store newLine deliminator
saveWordLoop:
lb $t9, ($t3) # Load current byte of the temp word
addi $t3, $t3, 1 # Increment the tempword space to next byte
sb $t9, ($t2) # Store this byte in the correct word space
addi $t2, $t2, 1 # Increment correct space to the next byte
beq $t6, $t9, saveWordExit # If current byte is a new line deliminator, exit the loop as it has been stored
j saveWordLoop
saveWordExit:
#li $v0, 4
#la $a0, tempWord
#syscall
la $t3, tempWord
j thisWord

findWordsExit:
#la $a0, correctWords
#li $v0, 4
#syscall		
		
	# END LANE CODE
	
	
	
	
	#Ask 1 to start/ 0 to exit
     	li $v0, 4
     	la $a0, startGame
     	syscall   
     	#Get User Input
     	li $v0, 12			
     	syscall
     	#If 0 is entered go to game over screen
     	beq $v0, 48, exit
     	# Padding
     	li $v0, 4
     	la $a0, newLine
     	syscall
     	syscall
     	
# Will loop until the user enters 0 to quit the game
# $s1 == number of strikes; $s2 == the user's score; $s3 the central character
CurrentGameLoop: beq $s1, 3, GameOverScreen # Game over if you have 3 strikes
		 
		 #Prints the 3x3 matrix
		 addi $sp, $sp, -12
		 sw $s1, 0($sp)
		 sw $s2, 4($sp)
		 sw $s3, 8($sp)
		 la $a0, scrambledWord
		 jal printMatrix
		 lw $s1, 0($sp)
		 lw $s2, 4($sp)
		 lw $s3, 8($sp)
		 addi $sp, $sp, 12
		 
		 move $s3, $v0
		 la $a0, newLine
		 li $v0, 4
		 syscall
		 # Prints your score at the moment. 1 point per correctly guessed
		 # word.
		 la $a0, mainScreenScore
		 li $v0, 4
		 syscall
		 li $v0, 1 # Prints the score number
		 move $a0, $s2
		 syscall
		 li $v0, 4  # Prints the number of strikes you have
		 la $a0, mainScreenStrikes
		 syscall
		 li $v0, 1 # Prints the number
		 move $a0, $s1
		 syscall
		 li $v0, 4 # Prompts the user to enter a guess
		 la $a0, mainScreenEnterGuess
		 syscall
		 li $v0, 8 # Loads the guess into the memory address guessStr
		 la $a0, guessStr
		 li $a1, 100
		 syscall
		 # Print out the guessed word for testing
		 #li $v0, 4
		 #la $a0, guessStr
		 #syscall
		 
		 
		 addi $sp, $sp, -12 # See if the guessStr is in foundWords
	    	 sw $s1, 0($sp)
	    	 sw $s2, 4($sp)
	    	 sw $s3, 8($sp)
	    	 la $a0, guessStr
	    	 jal checkIfStrInFound
	    	 lw $s1, 0($sp)
	    	 lw $s2, 4($sp)
	    	 lw $s3, 8($sp)
	    	 addi $sp, $sp, 12
	    	 beq $v0, 1, guessAlreadyInFoundWords
		 
		 #Check if the user entered a 1; scrambles and returns 1 if so, return 0 otherwise (in $v0)
		 addi $sp, $sp, -12
	    	 sw $s1, 0($sp)
	    	 sw $s2, 4($sp)
	    	 sw $s3, 8($sp)
	    	 jal rescrambleTheWordQ
	    	 lw $s1, 0($sp)
	    	 lw $s2, 4($sp)
	    	 lw $s3, 8($sp)
	    	 addi $sp, $sp, 12
	    	 
	    	 beq $v0, 1, CurrentGameLoop
		 
		 addi $sp, $sp, -12 # Checks if guessStr is valid ($v0==1) or invalid($v0==0)
	    	 sw $s1, 0($sp)
	    	 sw $s2, 4($sp)
	    	 sw $s3, 8($sp)
	    	 la $a0, guessStr
	    	 jal checkStr
	    	 lw $s1, 0($sp)
	    	 lw $s2, 4($sp)
	    	 lw $s3, 8($sp)
	    	 addi $sp, $sp, 12
	    	 
	    	 beq $v0, 0, CurrentGameLoop# Branches back to CurrentGameLoop w/o incrementing strike or score
	    	 # if guessStr is invalid, otherwise keep going
		 
		 # Puts the guess's address into $a0 for the 
		 # following function
		 # Check if the guessStr is in our list of possible words
		 # Returns 0 if guessStr is not a possible word; returns 1 if it is
		 # possible
		 addi $sp, $sp, -12 # Save number of strikes and the score to the 
		 		   # stack
		 sw $s1, 0($sp)
		 sw $s2, 4($sp)
		 sw $s3, 8($sp)
		 la $a0, guessStr
		 jal checkWord # LANE ADDED THIS LINE AS WELL !!!!!!!!!!!
		 lw $s1, 0($sp)
		 lw $s2, 4($sp)
		 lw $s3, 8($sp)
		 addi $sp, $sp, 12
		 # Assumes that the returned boolean value of 1:true or 0:false
		 # for the preceding checking function is placed in $s0
		 beq $s0, $0, IncrementTheStrikes
		 beq $s0, 1, IncrementTheScore	 
guessAlreadyInFoundWords: j CurrentGameLoop
IncrementTheStrikes: addi $s1, $s1, 1
		     li $v0, 4
		     la $a0, incrementedStrike
		     syscall
		     j CurrentGameLoop
IncrementTheScore: addi $s2, $s2, 1
		   li $v0, 4
		   la $a0, incrementedScore
		   syscall
		   
		   addi $sp, $sp, -12
	    	   sw $s1, 0($sp)
	    	   sw $s2, 4($sp)
	           sw $s3, 8($sp)
	    	   la $a0, guessStr #Load guessStr into foundWords
	    	   jal LoadIntoFoundWord
	    	   lw $s1, 0($sp)
	    	   lw $s2, 4($sp)
	    	   lw $s3, 8($sp)
	    	   addi $sp, $sp, 12
		   j CurrentGameLoop
		   
BeginAgain: addi $sp, $sp, -12
	    sw $s1, 0($sp)
	    sw $s2, 4($sp)
	    sw $s3, 8($sp)
	    la $a0, gameWord # Copy gameWord into tempStr
	    la $a1, tempStr
	    jal copyStr
	    lw $s1, 0($sp)
	    lw $s2, 4($sp)
	    lw $s3, 8($sp)
	    addi $sp, $sp, 12
	    
	    addi $sp, $sp, -12 # Set scrambleWord to a new scrambleWord
	    sw $s1, 0($sp)
	    sw $s2, 4($sp)
	    sw $s3, 8($sp)
	    la $a0, tempStr
	    jal scrambleWordInitial
	    lw $s1, 0($sp)
	    lw $s2, 4($sp)
	    lw $s3, 8($sp)
	    addi $sp, $sp, 12
	    
	    addi $sp, $sp, -12 # Set scrambleWord to a new scrambleWord
	    sw $s1, 0($sp)
	    sw $s2, 4($sp)
	    sw $s3, 8($sp)
	    jal clearFoundWords
	    lw $s1, 0($sp)
	    lw $s2, 4($sp)
	    lw $s3, 8($sp)
	    addi $sp, $sp, 12
	    
	    li $s1, 0 #reset strikes and score
	    li $s2, 0
	    
	    la $a0, newLine
	    li $v0, 4
	    syscall
	    j CurrentGameLoop

GameOverScreen: 
		addi $sp, $sp, -12 # Prints the dictionary out *Need to implement
	       	sw $s1, 0($sp)
	        sw $s2, 4($sp)
	        sw $s3, 8($sp)
	        jal printDictionary
	        lw $s1, 0($sp)
	        lw $s2, 4($sp)
	        lw $s3, 8($sp)
	        addi $sp, $sp, 12
	        
	        addi $sp, $sp, -12 # Prints the foundWords out
	       	sw $s1, 0($sp)
	        sw $s2, 4($sp)
	        sw $s3, 8($sp)
	        jal printFoundWords
	        lw $s1, 0($sp)
	        lw $s2, 4($sp)
	        lw $s3, 8($sp)
	        addi $sp, $sp, 12
	        
	        li $v0, 4 # Tells the user his score
	        la $a0, scoreAcknowledgement
	        syscall
	        add $a0, $s2, $0
	        li $v0, 1
	        syscall
	        la $a0, newLine
	        li $v0, 4
	        syscall
		
		li $v0, 4
		la $a0, gameOverPlayAgainQ
		syscall
		li $v0, 12
		syscall
		beq $v0, 49, BeginAgain

exit: 
