############## data section ###################################################################
	.data
week1: .word 0:7
week2: .word 0:7
listsz: .word 7

inputPrompt: 	.asciiz "Enter the production of day "
colon: 			.asciiz ": "
newline: 		.asciiz "\n"
highest: 		.asciiz "\tHighest: "
lowest: 		.asciiz "\tLowest: "
equal: 			.asciiz "\tBoth Weeks have equally produced : "
higher_week1:	.asciiz "\tWeek 1 > Week 2\n "
higher_week2:	.asciiz "\tWeek 2 > Week 1\n "
w1:				.asciiz "----------------------- Week 1 ---------------------------\n\n"
w2:				.asciiz "----------------------- Week 2 ---------------------------\n\n"
cmp:			.asciiz "----------------------- Comparing Data -----------------------\n"
day:			.asciiz "Day "
displayheader:  .asciiz "----------------------- Production of the Week 1 ---------------------\n\n"
############## code section ###################################################################
	.text
	
main:
	lw $s1,listsz					#declaring the array size
	
	# Week 1 header
	la $a0,w1
	li $v0,4
	syscall

	# InputProduction function for week 1
	la $s0,week1 					
	jal InputProduction

	# Week 2 Header
	la $a0,newline
	li $v0,4
	syscall
	syscall
	syscall
	la $a0,w2
	syscall

	# InputProduction function for week 2
	la $s0,week2					
	jal InputProduction
	
	# Adding spaces
	la $a0,newline
	li $v0,4
	syscall
	syscall
	
	# Comparing data header
	la $a0,cmp
	syscall

	# CompareProduction function
	jal CompareProduction

	# Adding spaces
	la $a0,newline
	li $v0,4
	syscall
	syscall
	
	# Display data header
	la $a0,displayheader
	syscall

	#Dispaly Production for week 1
	la $s0,week1
	jal DisplayProduction

	#End
	li $v0,10
	syscall

###############################################################################################

InputProduction:
	li $t0,0 						# loop control variable
	
	loopinput:
		beq $t0,$s1,endinput		# loop condition
	
	# input prompt
		la $a0,inputPrompt
		li $v0,4
		syscall
		addi $a0,$t0,1
		li $v0,1
		syscall
		li $v0,4
		la $a0,colon
		syscall

	# entering the production value
		li $v0,5
		syscall

		sw $v0,0($s0)				# storing the input
		addi $s0,$s0,4				# incrementing the array indexes
		addi $t0,$t0,1				# incrementing the loop control variable
		j loopinput

	endinput:
		jr $ra

###############################################################################################

CompareProduction:
	la $s2,week1				# loading week 1 address
	la $s3,week2				# loading week 2 address
	li $t3,0					# loop control variable

	loopcmp:
		beq $t3,$s1,endcmp		# loop condition
	
		# day heading		
		li $v0,4
		la $a0,newline
		syscall
		la $a0,day
		syscall
		li $v0,1
		addi $a0,$t3,1
		syscall
		li $v0,4
		la $a0,colon
		syscall
		la $a0,newline
		syscall
				

		# loading values from addresses
		lw $t1,0($s2)
		lw $t2,0($s3)

		bgt $t1,$t2,greater		# if production of week 1 > week 2 
		blt $t1,$t2,lesser		# if production of week 2 > week 1
		b else					# if week 1 = week 2

		return:
			addi $s2,$s2,4		# incrementing the array indexes
			addi $s3,$s3,4		# incrementing the array indexes
			addi $t3,$t3,1		# incrementing the loop control variable
			j loopcmp

		endcmp:
			jr $ra
		

	greater:
		# display the highest value
		la $a0,highest
		li $v0,4
		syscall
		move $a0,$t1
		li $v0,1
		syscall

		# new line
		la $a0,newline
		li $v0,4
		syscall

		# display the lowest value
		la $a0,lowest
		li $v0,4
		syscall
		move $a0,$t2
		li $v0,1
		syscall

		#newline
		la $a0,newline
		li $v0,4
		syscall

		# displaying week 1 > week 2
		la $a0,higher_week1
		syscall
		j return				# jumping back to loop

	lesser:
		# display the highest value
		la $a0,highest
		li $v0,4
		syscall
		move $a0,$t2
		li $v0,1
		syscall

		# new line
		la $a0,newline
		li $v0,4
		syscall

		# display the lowest value
		la $a0,lowest
		li $v0,4
		syscall
		move $a0,$t1
		li $v0,1
		syscall
		
		# new line
		la $a0,newline
		li $v0,4
		syscall

		# displaying week 2 > week 1
		la $a0,higher_week2
		syscall
		j return				# jumping back to loop

	else:
		#display the value
		la $a0,equal
		li $v0,4
		syscall
		move $a0,$t2
		li $v0,1
		syscall

		#newline
		la $a0,newline
		li $v0,4
		syscall
		j return				# jumping back to loop

		
###############################################################################################

DisplayProduction:
	li $t4,0					# loop control variable

	loopDisplay:
		beq $t4,$s1,endDisplay	# loop condition

		# day heading
		li $v0,4
		la $a0,day
		syscall
		addi $a0,$t4,1
		li $v0,1
		syscall
		li $v0,4
		la $a0,colon
		syscall
		
		# displaying the production for the day
		lw $a0,0($s0)
		li $v0,1
		syscall

		#newline
		li $v0,4
		la $a0,newline
		syscall

		addi $s0,$s0,4				# incrementing the array indexes
		addi $t4,$t4,1				# incrementing the loop control variable

		j loopDisplay				#jumping back to the loop

	endDisplay:
		jr $ra

	


