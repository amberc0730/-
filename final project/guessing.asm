include Irvine32.inc
main	EQU start@0
.data
HOME BYTE "Wellcome~! Press 'Enter' to play the game. ",10
     BYTE "To see our group members press 'g or G'. ",0Dh,0Ah,0
	 
HINT   BYTE "And Maybe there is something in the white bar!? ",0Dh,0Ah,0
SECRET BYTE "You can press C to Cheat in this page. XD",0Dh,0Ah,0

GROUPMEMBER BYTE "104403555 Jason Young",10
			BYTE "104403034 Amber Chou",10


QUIT        BYTE "Press 'ENTER' to return to homepage.",0Dh,0Ah,0
	

.code
Main PROC	;Main START
	
HOMEPAGE:
	MOV EAX,15
	CALL SetTextColor
	CALL Clrscr
	MOV EDX,offset HOME
	CALL WriteString
	CALL ReadChar	;Read user choice
	CMP AL,0Dh	;judge the advanced mode
	JZ ML1
	CMP AL,"g"	;judge the advanced mode
	JZ ML2
	CMP AL,"G"	;judge the advanced mode
	JZ ML2
		
	JMP HOMEPAGE

	
	ML2:
		CALL Clrscr
		MOV EDX,offset GROUPMEMBER
		CALL WriteString
		MOV EDX,OFFSET HINT
		CALL WriteString
		MOV EAX,255
		CALL SetTextColor
		MOV EDX,OFFSET SECRET
		CALL WriteString
		MOV EAX,15
		CALL SetTextColor
		CALL Crlf
		CALL Crlf
		CALL Crlf
		MOV EDX,OFFSET QUIT
		CALL WriteString
		CALL ReadChar
		CMP AL,0Dh
		JZ HOMEPAGE
		CMP AL,'C'
		JZ ML1
		JMP ML2
	
	
	
	ML1:
		CALL Advancedmode	;START Advanced Mode
		JMP ML3	;STOP Main

	
	ML3:
		call waitmsg
		exit

Main ENDP	;Main END
;-----------------------------------------------------------------
.data
	
	win BYTE "You win !!! ^¤f^ ",0Dh,0Ah,0
	playtime BYTE "You play ",0
	playtime_2 BYTE " times. ",0
	looptemp DWORD ? 
	divided DWORD 0
	atimes BYTE "A",0
	btimes BYTE "B",0Dh,0Ah,0
	Atitle BYTE "Please choose what mode do you want to play ? ",0Dh,0Ah,0
	Amode BYTE "( P : practice mode / R : real mode ) ",0Dh,0Ah,0
	Arequest BYTE "Please enter four numbers(0~9) : ",0
	Arandnum DWORD 4 DUP(10)	;Store the random number
	Auseripu DWORD 4 DUP (?)	;Store user input
	Atime DWORD 0	;what times does the user guess in Advanced mode
	Aa DWORD 0	;the A's times of Advanced Mode
	Ab DWORD 0	;the B's times of Advanced Mode
.code
Advancedmode PROC	;Advanced Main START
	PUSH EAX
	CALL Clrscr
	MOV ESI,offset Arandnum	;move the addrress of stored random number to esi
	CALL Randomize	;Call the random number seed
	MOV ECX,4	;produce four random number
RL1:
	MOV EAX,10	;the range of the random number in 0 ~ 9
	CALL RandomRange	;produce the random number
	MOV [ESI],EAX
	ADD ESI,type Arandnum
	LOOP RL1

RL2:
	POP EAX
	CALL Apractice	;START Advanced practice mode
	JMP RL4


RL4:RET	;exit the procedure
Advancedmode ENDP	;Advanced Main END
;-----------------------------------------------------------------
Apractice PROC	;Advanced Practice Mode START


CMP AL,'C'
JZ FORCHEAT
JMP APL2


FORCHEAT:
		CALL Clrscr	;clean the console screen
		MOV ESI,offset Arandnum	;move the addrress of stored random number to esi
		MOV ECX,4
	APL1:	;show what the random number is
		MOV EAX,[ESI]
		CALL WriteDec
		ADD ESI,type Arandnum
		LOOP APL1
		CALL Crlf

APL2:	;user input and check A and B
	MOV EDX,offset Arequest
	CALL WriteString
	CALL ReadInt	;user input
	CALL ACutNum	;cut user input to four pieces and store to Buseripu
	INC Atime	;count the guess times
	CALL Acheck	;check user input
	MOV EAX,Aa	;show the A times
	CALL WriteDec
	MOV EDX,offset atimes
	CALL WriteString
	MOV EAX,Ab	;show the B times
	CALL WriteDec
	MOV EDX,offset btimes
	CALL WriteString
	MOV EAX,Aa
	CMP EAX,4	;not win input number again
	JNZ APL2
	CMP EAX,4	;if you win
	JZ APL

APL:
	CALL Aprint	;show win message
	RET	;exit the procedure
Apractice ENDP	;Advanced Practice Mode END
;-----------------------------------------------------------------
ACutNum PROC	;Cut the input num START
	MOV ECX,4
	MOV ESI,offset Auseripu
	ADD ESI,12	;input should be inserted at tail
ACutL1:
	MOV EBX,0
	MOV divided,EBX
ACutL2:	;ACutL2 in order to take the remainder
	CMP EAX,10
	JL ACutL3
	SUB EAX,10
	INC divided	;inorder to take the quotient
	JMP ACutL2
ACutL3:
	MOV [ESI],EAX	;put the remainder into user input
	MOV EAX,divided	;quotient is the next dividend
	SUB ESI,type Auseripu
	LOOP ACutL1

	RET	;exit the procedure
ACutNum ENDP	;Cut the input num END
;-----------------------------------------------------------------

Acheck PROC
	MOV EDX,10	;initialize the used user input to 10
	MOV ESI,0	;the address shift of randon number
	MOV EDI,0	;the address shift of user input
	MOV ECX,4	;random numbers have four numbers
	MOV Aa,ESI	;A times return to zero
	MOV Ab,ESI	;B times return to zero
AC1:
	MOV looptemp,ECX	;reserve external loop's eax
	MOV ECX,4	;access internal loop's times to ecx
	MOV EDI,0	;the address of the Buseripu return to head
	MOV EBX,Arandnum[ESI]	;put the number that has to check to ebx
	CMP EBX,Auseripu[ESI]	;if the Buseripu number and the Brandnum number is the same in the same address
	JZ AC3
	CMP EBX,Auseripu[ESI]	;if the Buseripu number and the Brandnum number is different
	JNZ AC2
AC3:
	MOV Auseripu[ESI],EDX	;initialize the used user input to 10
	INC Aa	;the times of A add 1
	JMP AC4	;operate external the next internal loop
AC2:
	CMP ESI,EDI	;if the address is different
	JNZ AC5
	CMP ESI,EDI	;if the address is the same
	JZ AC6
AC5:
	CMP EBX,Auseripu[EDI]	;if the Buseripu number and the Brandnum number is the same in different address
	JZ AC7
	CMP EBX,Auseripu[EDI]	;if the Buseripu number and the Brandnum number is different
	JNZ AC6
AC7:
	MOV Auseripu[EDI],EDX	;initialize the used user input to 10
	INC Ab	;the times of B add 1
	JMP AC4	;operate external the next internal loop
AC6:	;operate the next internal loop
	ADD EDI,type Auseripu
	LOOP AC2
AC4:	;operate external the next internal loop
	MOV ECX,looptemp
	ADD ESI,type Arandnum
	LOOP AC1

	RET	;exit the procedure
Acheck ENDP
;-----------------------------------------------------------------
Aprint PROC	;print win message to user
	MOV EDX,offset win
	CALL WriteString
	MOV EDX,offset playtime
	CALL WriteString
	MOV EAX,Atime
	CALL WriteDec
	MOV EDX,offset playtime_2
	CALL WriteString

	RET	;exit the procedure
Aprint ENDP
;-----------------------------------------------------------------
END Main	;program END