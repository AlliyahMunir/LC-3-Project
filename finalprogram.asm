;GROUP NAME: WE'RE ALL IN THIS TOGETHER 
;GROUP MEMBERS: ALLIYAH MUNIR, ISAAC MARTINEZ, ARIANA NELSON, LISSETTE SERRATO
;PROJECT: IMPLEMENT BUBBLE SORT INTO A PROGRAM THAT OBTAINS 8 NUMBERS RANGING FROM 
;0-100 AND SORTS THEM IN ASCENDING ORDER 

.ORIG x3000				
					;begin by loading prompts	
LEA R0, FIRSTPROMPT			;Load first prompt instructing user of what to input
PUTS					;Display prompt on console
AND R0, R0, x0				;Clear R0 to initiate another prompt
LEA R0, SPACE				;SPACE allows "\n" to be used in seperating each inputted digit
PUTS					;Display prompt on console
AND R0, R0, x0				;Clear R0 to initiate another prompt
LEA R0, SAMPLE				;Load example prompt to help user understand what to input
PUTS					;Display prompt on console

LD R3, POINTER				;Implement and load pointer in R3
LD R6, IOCOUNTER			;load R6 with User Interface(I/O) Counter

INPUT	

					;This manages first digit inputted
	IN				;Input first digit
	AND R2, R2, x0			;Clear R2
	AND R5, R5, x0			;Clear R5
	LD R5, PLACEHUNDRED		;Load value 100 to R5 to eventually counter
	LD R2, HEXN48			;R2 is loaded with negative offset
	ADD R0, R0, R2			;Add ASCII offset(negative) to inputted value(R0)
	ADD R2, R0, x0			;Move inputted value(R0) to R2
	AND R0, R0, x0			;Clear R0 since it will be used for next value

					;Now we loop to obtain first digit from user
	FIRST_NUM			;loop titled "FIRST_NUM" for first digit 
		ADD R0, R0, R2		;first digit input value(R0) + 0
		ADD R5, R5, x-1		;decrement counter
		BRp FIRST_NUM		;If positive, loop 100 times
		ADD R1, R0, x0		;R1 now contains first digit which was previously in R0
		AND R0, R0, x0		;Clear R0 since we are reusing it


					;This manages second digit in input
	IN				;Input second digit
	AND R2, R2, x0			;Clear R2
	AND R5, R5, x0			;Clear R5
	LD R5, PLACETEN			;Load value 10 to R5 for countering	
	LD R2, HEXN48			;R2 is loaded with negative offset
	ADD R0, R0, R2			;Add ASCII offset(negative) to input value(R0)
	ADD R2, R0, x0			;Move inputted value(R0) to R2
	AND R0, R0, x0			;Clear R0 since it will be used for next value

					;Now we loop to obtain second digit from user
	SECOND_NUM			;loop titled "SECOND_NUM" for second digit
		ADD R0, R0, R2		;second digit input value(R0) + 0
		ADD R5, R5, x-1		;decrement counter
		BRp SECOND_NUM		;If positive, loop 10 times
		ADD R4, R0, x0		;R4 now contains second digit which was previously in R0
		AND R0, R0, x0		;Clear R0 since we are going to reuse it


					;This manages third digit in input
	IN				;Input third digit
	AND R2, R2, x0			;Clear R2
					;We don't require R5 this time, due to no counter
	LD R2, HEXN48			;Load negative ASCII offset to R2
	ADD R0, R0, R2			;Add ASCII offset(negative) to input value(R0)
					;Now the third digit is located in R0
	AND R2, R2, x0			;Clear R2 since we are going to reuse it 



					;Form the three seperately inputted values into one 3-digit number
	ADD R2, R1, R4			;R2 = First value (R1) + second value(R4)
	ADD R2, R0, R2			;R2 = (R1 + R2) + third value (R0)
	STR R2, R3, x0			;Store the 3-digit value in R2, in an array with pointer(R3)
	ADD R3, R3, x1			;Increase pointer value
	ADD R6, R6, x-1			;Decrease input loop(R6) by counter
	BRp INPUT			;check condition by branching: If counter(R6) is positive, loop



				
	JSR BUBBLESORT			;Jump to BUBBLESORT subroutine
	JSR PRODUCTLOOP			;Jump to the final(output) subroutine
	HALT				;HALT the program


BUBBLESORT 				;sorting subroutine
					;Reset pointer and counters to use for sorting loops
	AND R3, R3, x0			;Clear R3(pointer)
	LD R3, POINTER			;reload register in pointer 
	AND R4, R4, x0			;Clear R4(FINALOUT_LOOP COUNTER)
	LD R4, IOCOUNTER		;Reload register in counter
	AND R5, R5, x0			;Clear R5(FINALIN_LOOP COUNTER)
	LD R5, IOCOUNTER		;Reset counter value

					
	FINALOUT_LOOP			;Outer loop used in array
		ADD R4, R4, x-1		;ensure loop runs 8 times, constantly decreasing by 1
		BRz SORTED		;check condition by branching: If value begins with 0, it is sorted
		ADD R5, R4, x0		;Moving FINALOUT_LOOP COUNTER(R4) into FINALIN_LOOP COUNTER(R5)
		LD R3, POINTER		;Reload register in pointer to start from beginning of array
					
	FINALIN_LOOP			;Inner loop, runs through array once and sorts
		LDR R0, R3, x0		;Load first three digit number using pointer(R3), store to R0
		LDR R1, R3, x1		;Load second three digit number using pointer(R3), store to R1
		AND R2, R2, x0		;Clear R2 to reuse
		NOT R2, R1		;Two's compliment
		ADD R2, R2, x1		;NOT and AND make R2 become negative
		ADD R2, R0, R2		;R2 = first three digit number(R0) - (R2)second three digit number
		BRn AUTOSWAP		;check condition by branching:swap if negative,meaning the first input is smaller than second
					;Perform the swap	
		STR R1, R3, x0		;Second 3 digit number, now stored before first 3 digit number
		STR R0, R3, x1		;First 3 digit number now after second 3 digit number

				
	AUTOSWAP			;Swapping 3 digit numbers in ascending order
		ADD R3, R3, x1		;Increase pointer(R3) to view other 3 digit numbers
		ADD R5, R5, x-1		;Decreaase in counter loop
		BRp FINALIN_LOOP	;Check condition by branching: If Positive, continue going through FINAL_IN loop
		BRzp FINALOUT_LOOP	;check condition by branching:If Positive/Zero, go back to FINAL_OUT loop
		SORTED	RET		;one array is sorted, Return to calling program
		RET			;else, Return to calling program



PRODUCTLOOP				;product(result) subroutine

	LEA R0, PROMPTEXECUTE		;Load output prompt
	PUTS				;Display prompt on console
	LD R3, POINTER			;Reload Register with pointer
	LD R6, IOCOUNTER		;Reload Register with counter

	RESULTLOOP			;name of loop is RESULTLOOP	
		AND R1, R1, x0		;Clear R1(previously:1st digit)
		AND R2, R2, x0		;Clear R2
		AND R4, R4, x0		;Clear R4(previously:2nd digit)
		AND R5, R5, x0		;Clear R5(previously:3rd digit)
		AND R0, R0, x0		;Clear R0
		LD R0, SPACE		;Load "\n" for space and clean writing on console
		OUT			;Display on console
		AND R0, R0, x0		;Clear R0 
		LDR R0, R3, x0		;Load 3 digit inputted number using pointer (R3) value into R0 
					
					;Setup to divide by 100
		LD R2, PLACEHUNDRED	;R2 = 100
		NOT R2, R2		;Two's complement	
		ADD R2, R2, x1		;NOT and AND make R2 = -100

		MINUS01			;First loop subtracts 100 (since that is our largest input value)
			ADD R1, R1, x1	;fill R1 with value
			ADD R0, R0, R2	;R0 = Number(R0) + - 100(R2)
			BRzp MINUS01	;Once result is Positive/Zero, find the remainder
	
		REMAINDER01			;Find remainder and first digit
			AND R2, R2, x0		;Clear R2 since we are reusing
			LD R2, PLACEHUNDRED	;Reload R2 = 100
			ADD R0, R0, R2		;Result + 100 = positive remainder
			ADD R1, R1, x-1		;Subtract one from counter with result of times subtracted
			STI R1, FIRSTNUM	;R1 stored to FIRSTNUM	
			
						;Setup to divide by 10
		AND R2, R2, x0			;Clear R2  
		LD R2, PLACETEN			;load R2 = 10
		NOT R2, R2			;Two's complement
		ADD R2, R2, x1			;NOT and AND make R2 = -10
	
		MINUS02				;Second minus loop while dividing remainder by 10
			ADD R4, R4, x1		;Counter
			ADD R0, R0, R2		;R0 = Remainder(R0) + - 10(R2)
			BRzp MINUS02		;Once result is Positive/Zero, find the remainder
						
		REMAINDER2			;Find remainder, second digit, and third digit
			AND R2, R2, x0		;Clear R2 since reusing
			LD R2, PLACETEN		;R2 = 10 since 2nd inputted number is in tenths place
			ADD R5, R0, R2		;R5 = (R0)Remainder + 10(R2)
			STI R5, THIRDNUM	;store R5 in THIRDNUM, when R5 contains third digit
			ADD R4, R4, x-1		;number of times subtracted prior to positive result
			STI R4, SECONDNUM	;Second digit now in R4, store to SECONDNUM
		
						;Display first digit	
		AND R0, R0, x0			;Clear R0	
		LDI R0, FIRSTNUM		;Load the first digit number to R0
		AND R2, R2, x0			;Clear R2
		LD R2, HEX48			;Load positive offset to R2
		ADD R0, R0, R2			;R0 = first digit (R0) + offset(R2)
		OUT				;Display on console

						;Display second digit
		AND R0, R0, x0			;Clear R0
		LDI R0, SECONDNUM		;Load the second digit to R0
		AND R2, R2, x0			;Clear R2
		LD R2, HEX48			;Load positive offset to R2
		ADD R0, R0, R2			;R0 = second digit (R0) + offset(R2)
		OUT				;Display on console
						
						;Display third digit
		AND R0, R0, x0			;Clear R0
		LDI R0, THIRDNUM		;Load the third digit to R0
		AND R2, R2, x0			;Clear R2
		LD R2, HEX48			;Load positive offset to R2
		ADD R0, R0, R2			;R0 = third digit (R0) + offset(R2)
		OUT				;Display to console

		ADD R3, R3, x1			;Increment the pointer R3 (for balance from previous changes)
		ADD R6, R6, x-1			;Decrement the counter R6 (for balance from previous changes)
		BRp RESULTLOOP			;Branch positive by continue looping If loop counter positive
	        HALT				;Pause program

						;.FILL AND .STRINGZ BEFORE ENDING PROGRAM

FIRSTPROMPT	.STRINGZ	"Input 8 numbers ranging from 000 - 100 with 3 digits."
SAMPLE		.STRINGZ	"Ex: Input 15 as 015 or 5 as 005"
PROMPTEXECUTE	.STRINGZ	"Numbers in Ascending Order: "
SPACE		.STRINGZ         "\n"	
HEXN48		.FILL		xFFD0	;negative offset in ascii
HEX48		.FILL		x0030	;positive ascii offset
PLACEHUNDRED	.FILL		x0064	;used for hundredths place
PLACETEN	.FILL		x000A	;used for tenths place
POINTER		.FILL		x4000	;Array starting point
IOCOUNTER	.FILL		#8	;For our counters
FIRSTNUM	.FILL		x400A	;Storing first value/digit
SECONDNUM	.FILL		x400B	;Storing second value/digit
THIRDNUM	.FILL		x400C	;Storing third value/digit
.END					;End !!! :)


;REFERENCES FOR CREATING PROGRAM
;https://github.com/dideler/LC-3-Programs/blob/master/characterCounter.asm 
;https://www.reddit.com/r/lc3/comments/5u636w/looping_and_asking_the_same_question_then_quit/
;https://github.com/professorkaseynguyen/CIS11/blob/master/monthofyear.asm
;https://github.com/oc-cs360/s2014/blob/master/lc3/bubblesort.asm
;https://stackoverflow.com/questions/43735625/how-to-make-a-sorting-algorithm-in-assembly-code-in-lc3ht
;Lab 6 (Month of Year) from CIS-11 Course
;Lab 3 (Suminput) from CIS-11 Course
