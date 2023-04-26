#                                           CS 240, Lab #2
# 
#                                          IMPORTATNT NOTES:
# 
#			Write your assembly code only in the marked blocks.
# 
#			Remember to fill in your name, student ID in the designated sections.
#
#			DO NOT change anything outside the marked blocks.
# 
#			DO NOT change the name of this file. Submit to Gradescope, not Canvas.
#
#			DO NOT COPY CODE. We use a similarity checker and will find you. It is
#			CHEATING to both use someone else's code AND to give someone else your
#			code, these actions will be punished equally.
#
#			*Note that the autograder will test more values than are present here.
#			It is a good idea to test other values yourself.
# 
#
j main
###############################################################
#                           Data Section
.data
# 
# Fill in your name, student ID in the designated sections.
# 
student_name: .asciiz "Bryce Jarboe"
student_id: .asciiz "825033151"

new_line: .asciiz "\n"
space: .asciiz " "
count_ones_lbl: .asciiz "\nCount Ones \nExpected output:\n20 24 13\nObtained output:\n"
bcd_2_bin_lbl: .asciiz "\nBCD to Binary (Hexadecimal Values)\nExpected output:\n004CC853 00BC614E 00008AE0\nObtained output:\n"
bin_2_bcd_lbl: .asciiz "\nBinary to BCD (Hexadecimal Values) \nExpected output:\n05032019 06636321 00065535\nObtained output:\n"

count_ones_test_data:  .word 0xBABABABA, 0xFEABBAEF, 0x09876543

bcd_2_bin_test_data: .word 0x05032019, 0x12345678, 0x35552

bin_2_bcd_test_data: .word 0x4CC853, 0x654321, 0xFFFF

hex_digits: .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

###############################################################
#                           Text Section
.text
# Utility function to print hexadecimal numbers
print_hex:
move $t0, $a0
li $t1, 8 # digits
lui $t2, 0xf000 # mask
mask_and_print:
# print last hex digit
and $t4, $t0, $t2 
srl $t4, $t4, 28
la    $t3, hex_digits  
add   $t3, $t3, $t4 
lb    $a0, 0($t3)            
li    $v0, 11                
syscall 
# shift 4 times
sll $t0, $t0, 4
addi $t1, $t1, -1
bgtz $t1, mask_and_print
exit:
jr $ra
###############################################################
###############################################################
###############################################################
#                            PART 1 (Count Bits)
# 
# You are given a 32-bits integer stored in $t0. Count the number of 1's
# in the given number. Store your result in $t0.
# For example: 1111 0000 should return 4
.globl count_ones
count_ones:
move $t0, $a0 
############################ Part 1: your code begins here ###

#	t0 = input	t1 = result	t2 = extractedNum

addi $t1, $zero, 0 	#Initialize result
WHILE1:			#while t0 != 0
beq $t0, $zero, DONE1
and $t2, $t0, 0x00000001	# Extract last bit				| t2 = and(t0, mask)
add $t1, $t1, $t2		# result = result + extractedNum		| t1 = t1 + t2
srl $t0, $t0, 1			# Analyze the next digit			| shiftLeft(t0, 1)

j WHILE1

DONE1:
add $t0, $zero, $t1		#set t0 equal to the final result		| t0 = t1
############################ Part 1: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################

###############################################################
###############################################################
###############################################################
#                            PART 2 (BCD to Binary)
# 
# You are given a 32-bits integer stored in $t0. This 32-bits
# present a BCD number. You need to convert it to a binary number.
# For example: 0x7654_3210 should return 0x48FF4EA.
# The result must be stored inside $t0 as well.
.globl bcd2bin
bcd2bin:
move $t0, $a0
############################ Part 2: your code begins here ###

#	t0 = input	t1 = result	t2 = multiplier = 10	t3 = first4bits

addi $t1, $zero, 0	#Ensure result t1 begins at 0
addi $t2, $zero, 10	#Initialize multiplier t2

WHILE2:			#while t0 != 0
beq $t0, $zero, DONE2
andi $t3, $t0, 0xF0000000	# Extract first 4 bits from input	| t3 = and(t0, mask)
srl $t3, $t3, 28		# Isolate first 4 bits			| t3 = rightShift(t3, 28)
mult $t1, $t2			#
mflo $t1			# result = result * multiplier		| t1 = t1 * t2
add $t1, $t1, $t3		# result = result + first4bits		| t1 = t1 + t3
sll $t0, $t0, 4			# Eliminate the first 4 bits		| t0 = shiftLeft(t0, 4)
j WHILE2

DONE2:
add $t0, $zero, $t1		# input = result			| t0 = t1

############################ Part 2: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
#                            PART 3 (Binary to BCD)
# 
# You are given a 32-bits integer stored in $t0. This 32-bits
# present an integer number. You need to convert it to a BCD.
# The result must be stored inside $t0 as well.
.globl bin2bcd
bin2bcd:
move $t0, $a0
############################ Part 3: your code begins here ###

#	t0 = input	t1 = result	t2 = DIVISOR = 10	t3 = shiftAmt	t4 = remainder

addi $t1, $zero, 0	# Initialize result
addi $t2, $zero, 10	# Initialize DIVISOR (10)
addi $t3, $zero, 0	# Initialize shiftAmt

WHILE3:			# while t0 != 0
beq $t0, $zero, DONE3
div $t0, $t2 			# Divide input by DIVISOR
mflo $t0 			# Store quotient into t0	| t0 = t0 / t2
mfhi $t4			# Store remainder into t4	| t4 = rem(t0, t2)
sllv $t4, $t4, $t3		# Shift remainder left		| t4 = shiftLeft(t4, t3)
add $t1, $t1, $t4		# result = result + remainder	| t1 = t1 + t4
addi $t3, $t3, 4		# shiftAmt += 4			| t3 = t3 + 4
j WHILE3
DONE3:
add $t0, $zero, $t1		# input = result		| t0 = t1

############################ Part 3: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
#                          Main Function                       
main:

li $v0, 4
la $a0, student_name
syscall
la $a0, new_line
syscall  
la $a0, student_id
syscall 
la $a0, new_line
syscall
la $a0, count_ones_lbl
syscall

# Testing part 1
li $s0, 3 # num of test cases
li $s1, 0
la $s2, count_ones_test_data

test_p1:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal count_ones

move $a0, $v0        # $integer to print
li $v0, 1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p1

li $v0, 4
la $a0, new_line
syscall
la $a0, bcd_2_bin_lbl
syscall

# Testing part 2
li $s0, 3 # num of test cases
li $s1, 0
la $s2, bcd_2_bin_test_data

test_p2:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal bcd2bin

move $a0, $v0        # hex to print
jal print_hex

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p2

li $v0, 4
la $a0, new_line
syscall
la $a0, bin_2_bcd_lbl
syscall

# Testing part 3
li $s0, 3 # num of test cases
li $s1, 0
la $s2, bin_2_bcd_test_data

test_p3:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal bin2bcd

move $a0, $v0        # hex to print
jal print_hex

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p3

_end:
# end program
li $v0, 10
syscall

