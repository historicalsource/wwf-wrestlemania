**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		7/15/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"lexseq1.asm"

	.title	"Lex Luger animation sequences"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"macros.h"
	.include	"mproc.equ"		;Mproc equates
	.include	"sys.equ"
	.include	"game.equ"
	.include	"plyr.equ"
	.include	"anim.equ"
	.include	"sound.h"

	.include	"leximg.h"
	.include	"takerimg.h"		;<-- temp!


******************************************************************************
* EXTERNAL REFERENCES

	.REF	SMALL_RUN

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* STANDS

 SUBR	lex_zip_anim
	WL	60*60,L2ST2C+FR1
	.word	ANI_END


 SUBR	lex_stand2_anim
 SUBR	lex_stand8_anim
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	WL	3,L2ST2C+FR7
	WL	3,L2ST2C+FR8
	WL	3,L2ST2C+FR9
	WL	3,L2ST2C+FR10
	WL	3,L2ST2C+FR11
	WL	3,L2ST2C+FR12

	WL	3,L2ST2C+FR11
	WL	3,L2ST2C+FR10
	WL	3,L2ST2C+FR9
	WL	3,L2ST2C+FR8
	WL	3,L2ST2C+FR7
	WL	3,L2ST2C+FR6
	WL	3,L2ST2C+FR5
	WL	3,L2ST2C+FR4
	WL	3,L2ST2C+FR3

	WL	3,L2ST2C+FR2
	WL	3,L2ST2C+FR3
	WL	3,L2ST2C+FR4
	WL	3,L2ST2C+FR5
	WL	3,L2ST2C+FR6

	.word	ANI_REPEAT


 SUBR	lex_stand4_anim
 SUBR	lex_stand6_anim
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	WL	3,L4ST4A+FR5
	WL	3,L4ST4A+FR6
	WL	3,L4ST4A+FR7
	WL	3,L4ST4A+FR8
	WL	3,L4ST4A+FR9
	WL	3,L4ST4A+FR10
	WL	3,L4ST4A+FR11
	WL	3,L4ST4A+FR10
	WL	3,L4ST4A+FR9
	WL	3,L4ST4A+FR8
	WL	3,L4ST4A+FR7
	WL	3,L4ST4A+FR6
	WL	3,L4ST4A+FR5
	WL	3,L4ST4A+FR4
	WL	3,L4ST4A+FR3
	WL	3,L4ST4A+FR2

	WL	3,L4ST4A+FR1
	WL	3,L4ST4A+FR2
	WL	3,L4ST4A+FR3
	WL	3,L4ST4A+FR4

	.word	ANI_REPEAT


#*****************************************************************************
*
* WALKING TORSOS

 SUBR	lex_torso2_anim
 SUBR	lex_torso8_anim

	WL	4,L2TW2Z+FR1
	WL	4,L2TW2Z+FR2
	WL	4,L2TW2Z+FR3
	WL	4,L2TW2Z+FR4
	WL	4,L2TW2Z+FR5
	WL	4,L2TW2Z+FR4
	WL	4,L2TW2Z+FR3
	WL	4,L2TW2Z+FR2
	.word	ANI_REPEAT


 SUBR	lex_torso4_anim
 SUBR	lex_torso6_anim

	WL	4,L4TW4Z+FR1
	WL	4,L4TW4Z+FR2
	WL	4,L4TW4Z+FR3
	WL	4,L4TW4Z+FR4
	WL	4,L4TW4Z+FR5
	WL	4,L4TW4Z+FR4
	WL	4,L4TW4Z+FR3
	WL	4,L4TW4Z+FR2
	.word	ANI_REPEAT


#*****************************************************************************
*
* WALKS FACING #2

 SUBR	lex_walk1_f2_anim

	WL	3,L2WL1B+FR1
	WL	3,L2WL1B+FR2
	WL	3,L2WL1B+FR3
	WL	3,L2WL1B+FR4
	WL	3,L2WL1B+FR5
	WL	3,L2WL1B+FR6
	WL	3,L2WL1B+FR7
	WL	3,L2WL1B+FR8
	WL	3,L2WL1B+FR9
	WL	3,L2WL1B+FR10
	WL	3,L2WL1B+FR11
	WL	3,L2WL1B+FR12
	WL	3,L2WL1B+FR13
	WL	3,L2WL1B+FR14
	WL	3,L2WL1B+FR15
	WL	3,L2WL1B+FR16

	.word	ANI_REPEAT

 SUBR	lex_walk2_f2_anim

	WL	3,L2WL2A+FR1
	WL	3,L2WL2A+FR2
	WL	3,L2WL2A+FR3
	WL	3,L2WL2A+FR4
	WL	3,L2WL2A+FR5
	WL	3,L2WL2A+FR6
	WL	3,L2WL2A+FR7
	WL	3,L2WL2A+FR8
	WL	3,L2WL2A+FR9
	WL	3,L2WL2A+FR10
	WL	3,L2WL2A+FR11
	WL	3,L2WL2A+FR12
	WL	3,L2WL2A+FR13
	WL	3,L2WL2A+FR14
	WL	3,L2WL2A+FR15
	WL	3,L2WL2A+FR16
	WL	3,L2WL2A+FR17
	WL	3,L2WL2A+FR18

	.word	ANI_REPEAT

 SUBR	lex_walk4_f2_anim

	WL	3,L2WL8A+FR1
	WL	3,L2WL8A+FR2
	WL	3,L2WL8A+FR3
	WL	3,L2WL8A+FR4
	WL	3,L2WL8A+FR5
	WL	3,L2WL8A+FR6
	WL	3,L2WL8A+FR7
	WL	3,L2WL8A+FR8
	WL	3,L2WL8A+FR9
	WL	3,L2WL8A+FR10
	WL	3,L2WL8A+FR11
	WL	3,L2WL8A+FR12
	WL	3,L2WL8A+FR13
	WL	3,L2WL8A+FR14
	WL	3,L2WL8A+FR15
	WL	3,L2WL8A+FR16
	WL	3,L2WL8A+FR17

	.word	ANI_REPEAT

 SUBR	lex_walk5_f2_anim

	WL	3,L2WL1B+FR16
	WL	3,L2WL1B+FR15
	WL	3,L2WL1B+FR14
	WL	3,L2WL1B+FR13
	WL	3,L2WL1B+FR12
	WL	3,L2WL1B+FR11
	WL	3,L2WL1B+FR10
	WL	3,L2WL1B+FR9
	WL	3,L2WL1B+FR8
	WL	3,L2WL1B+FR7
	WL	3,L2WL1B+FR6
	WL	3,L2WL1B+FR5
	WL	3,L2WL1B+FR4
	WL	3,L2WL1B+FR3
	WL	3,L2WL1B+FR2
	WL	3,L2WL1B+FR1

	.word	ANI_REPEAT

 SUBR	lex_walk6_f2_anim

	WL	3,L2WL2A+FR18
	WL	3,L2WL2A+FR17
	WL	3,L2WL2A+FR16
	WL	3,L2WL2A+FR15
	WL	3,L2WL2A+FR14
	WL	3,L2WL2A+FR13
	WL	3,L2WL2A+FR12
	WL	3,L2WL2A+FR11
	WL	3,L2WL2A+FR10
	WL	3,L2WL2A+FR9
	WL	3,L2WL2A+FR8
	WL	3,L2WL2A+FR7
	WL	3,L2WL2A+FR6
	WL	3,L2WL2A+FR5
	WL	3,L2WL2A+FR4
	WL	3,L2WL2A+FR3
	WL	3,L2WL2A+FR2
	WL	3,L2WL2A+FR1

	.word	ANI_REPEAT


 SUBR	lex_walk8_f2_anim

	WL	3,L2WL8A+FR17
	WL	3,L2WL8A+FR16
	WL	3,L2WL8A+FR15
	WL	3,L2WL8A+FR14
	WL	3,L2WL8A+FR13
	WL	3,L2WL8A+FR12
	WL	3,L2WL8A+FR11
	WL	3,L2WL8A+FR10
	WL	3,L2WL8A+FR9
	WL	3,L2WL8A+FR8
	WL	3,L2WL8A+FR7
	WL	3,L2WL8A+FR6
	WL	3,L2WL8A+FR5
	WL	3,L2WL8A+FR4
	WL	3,L2WL8A+FR3
	WL	3,L2WL8A+FR2
	WL	3,L2WL8A+FR1
	.word	ANI_REPEAT



#*****************************************************************************
*
* WALKS FACING #4

 SUBR	lex_walk1_f4_anim

	WL	3,L4WL5A+FR17
	WL	3,L4WL5A+FR16
	WL	3,L4WL5A+FR15
	WL	3,L4WL5A+FR14
	WL	3,L4WL5A+FR13
	WL	3,L4WL5A+FR12
	WL	3,L4WL5A+FR11
	WL	3,L4WL5A+FR10
	WL	3,L4WL5A+FR9
	WL	3,L4WL5A+FR8
	WL	3,L4WL5A+FR7
	WL	3,L4WL5A+FR6
	WL	3,L4WL5A+FR5
	WL	3,L4WL5A+FR4
	WL	3,L4WL5A+FR3
	WL	3,L4WL5A+FR2
	WL	3,L4WL5A+FR1
	.word	ANI_REPEAT

 SUBR	lex_walk2_f4_anim

	WL	3,L4WL2B+FR1
	WL	3,L4WL2B+FR2
	WL	3,L4WL2B+FR3
	WL	3,L4WL2B+FR4
	WL	3,L4WL2B+FR5
	WL	3,L4WL2B+FR6
	WL	3,L4WL2B+FR7
	WL	3,L4WL2B+FR8
	WL	3,L4WL2B+FR9
	WL	3,L4WL2B+FR10
	WL	3,L4WL2B+FR11
	WL	3,L4WL2B+FR12
	WL	3,L4WL2B+FR13
	WL	3,L4WL2B+FR14
	WL	3,L4WL2B+FR15
	WL	3,L4WL2B+FR16

	.word	ANI_REPEAT

 SUBR	lex_walk4_f4_anim

	WL	3,L4WL4A+FR1
	WL	3,L4WL4A+FR2
	WL	3,L4WL4A+FR3
	WL	3,L4WL4A+FR4
	WL	3,L4WL4A+FR5
	WL	3,L4WL4A+FR6
	WL	3,L4WL4A+FR7
	WL	3,L4WL4A+FR8
	WL	3,L4WL4A+FR9
	WL	3,L4WL4A+FR10
	WL	3,L4WL4A+FR11
	WL	3,L4WL4A+FR12
	WL	3,L4WL4A+FR13
	WL	3,L4WL4A+FR14
	WL	3,L4WL4A+FR15
	WL	3,L4WL4A+FR16
	WL	3,L4WL4A+FR17
	WL	3,L4WL4A+FR18

	.word	ANI_REPEAT

 SUBR	lex_walk5_f4_anim

	WL	3,L4WL5A+FR1
	WL	3,L4WL5A+FR2
	WL	3,L4WL5A+FR3
	WL	3,L4WL5A+FR4
	WL	3,L4WL5A+FR5
	WL	3,L4WL5A+FR6
	WL	3,L4WL5A+FR7
	WL	3,L4WL5A+FR8
	WL	3,L4WL5A+FR9
	WL	3,L4WL5A+FR10
	WL	3,L4WL5A+FR11
	WL	3,L4WL5A+FR12
	WL	3,L4WL5A+FR13
	WL	3,L4WL5A+FR14
	WL	3,L4WL5A+FR15
	WL	3,L4WL5A+FR16
	WL	3,L4WL5A+FR17

	.word	ANI_REPEAT

 SUBR	lex_walk6_f4_anim

	WL	3,L4WL2B+FR16
	WL	3,L4WL2B+FR15
	WL	3,L4WL2B+FR14
	WL	3,L4WL2B+FR13
	WL	3,L4WL2B+FR12
	WL	3,L4WL2B+FR11
	WL	3,L4WL2B+FR10
	WL	3,L4WL2B+FR9
	WL	3,L4WL2B+FR8
	WL	3,L4WL2B+FR7
	WL	3,L4WL2B+FR6
	WL	3,L4WL2B+FR5
	WL	3,L4WL2B+FR4
	WL	3,L4WL2B+FR3
	WL	3,L4WL2B+FR2
	WL	3,L4WL2B+FR1

	.word	ANI_REPEAT

 SUBR	lex_walk8_f4_anim

	WL	3,L4WL4A+FR18
	WL	3,L4WL4A+FR17
	WL	3,L4WL4A+FR16
	WL	3,L4WL4A+FR15
	WL	3,L4WL4A+FR14
	WL	3,L4WL4A+FR13
	WL	3,L4WL4A+FR12
	WL	3,L4WL4A+FR11
	WL	3,L4WL4A+FR10
	WL	3,L4WL4A+FR9
	WL	3,L4WL4A+FR8
	WL	3,L4WL4A+FR7
	WL	3,L4WL4A+FR6
	WL	3,L4WL4A+FR5
	WL	3,L4WL4A+FR4
	WL	3,L4WL4A+FR3
	WL	3,L4WL4A+FR2
	WL	3,L4WL4A+FR1

	.word	ANI_REPEAT

;There are too many rotate frames listed here...


#*****************************************************************************
*
* TURNS (STANDS)

 SUBR	lex_2_to_4_turn_anim
 SUBR	lex_8_to_6_turn_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
;Fix!!!
;Take out these extra frames
	WL	2,L1TT5A+FR4
	WL	2,L1TT5A+FR5
	WL	2,L1TT5A+FR6
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_4_to_2_turn_anim
 SUBR	lex_6_to_8_turn_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	2,L1TT5A+FR6
	WL	2,L1TT5A+FR5
	WL	2,L1TT5A+FR4
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_4_to_6_turn_anim
 SUBR	lex_6_to_4_turn_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	2,L1TT5A+FR8
	.word	ANI_XFLIP
	WL	2,L1TT5A+FR9
	WL	2,L1TT5A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_2_to_8_turn_anim
 SUBR	lex_8_to_2_turn_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	2,L1TT5A+FR2
	.word	ANI_XFLIP
	WL	2,L1TT5A+FR1
	WL	2,L1TT5A+FR2
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_4_to_8_turn_anim
 SUBR	lex_6_to_2_turn_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	2,L1TT5A+FR8
	.word	ANI_XFLIP
	WL	2,L1TT5A+FR9
	WL	2,L1TT5A+FR8
	WL	2,L4ST4A+FR5	;#4 stand
	WL	2,L1TT5A+FR6
	WL	2,L1TT5A+FR5
	WL	2,L1TT5A+FR4
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_2_to_6_turn_anim
 SUBR	lex_8_to_4_turn_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	2,L1TT5A+FR4
	WL	2,L1TT5A+FR5
	WL	2,L1TT5A+FR6
	WL	2,L4ST4A+FR5	;#4 stand
	WL	2,L1TT5A+FR8
	.word	ANI_XFLIP
	WL	2,L1TT5A+FR9
	WL	2,L1TT5A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* TURNS (TORSOS)

 SUBR	lex_2_to_4_turn2_anim
 SUBR	lex_8_to_6_turn2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	2,L1TR5A+FR4
	WL	2,L1TR5A+FR5
	.word	ANI_SETFACING
	WL	2,L1TR5A+FR5
	WL	2,L1TR5A+FR6
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_4_to_2_turn2_anim
 SUBR	lex_6_to_8_turn2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	2,L1TR5A+FR6
	WL	2,L1TR5A+FR5
	.word	ANI_SETFACING
	WL	2,L1TR5A+FR5
	WL	2,L1TR5A+FR4
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_4_to_6_turn2_anim
 SUBR	lex_6_to_4_turn2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	2,L1TR5A+FR8
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	2,L1TR5A+FR9
	WL	2,L1TR5A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_2_to_8_turn2_anim
 SUBR	lex_8_to_2_turn2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	2,L1TR5A+FR2
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	2,L1TR5A+FR1
	WL	2,L1TR5A+FR2
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_4_to_8_turn2_anim
 SUBR	lex_6_to_2_turn2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	2,L1TR5A+FR8
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	2,L1TR5A+FR9
	WL	2,L1TR5A+FR8
	WL	2,L4TW4Z+FR1	;#4 stand (torso)
	WL	2,L1TR5A+FR6
	WL	2,L1TR5A+FR5
	WL	2,L1TR5A+FR4
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_2_to_6_turn2_anim
 SUBR	lex_8_to_4_turn2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	2,L1TR5A+FR4
	WL	2,L1TR5A+FR5
	WL	2,L1TR5A+FR6
	WL	2,L4TW4Z+FR1	;#4 stand (torso)
	WL	2,L1TR5A+FR8
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	2,L1TR5A+FR9
	WL	2,L1TR5A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* RUNNING IN #3

 SUBR	lex_run2_anim

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

;I'm turning on an attack box for the entire run sequence.
;I never turn it off.

	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,16,71	;mode,x,y,w,h
	WL	ANI_GOTO,#run2

 SUBR	lex_run_anim

	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,16,71	;mode,x,y,w,h

#lp1
	WL	3,L3RN3B+FR5
	WL	3,L3RN3B+FR6
	WL	3,L3RN3B+FR7
	WL	3,L3RN3B+FR8
	WL	ANI_CODE,SMALL_RUN
#run2
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,16,71	;mode,x,y,w,h
	WL	3,L3RN3B+FR9
	WL	3,L3RN3B+FR10
	WL	3,L3RN3B+FR11
	WL	3,L3RN3B+FR12
	WL	3,L3RN3B+FR1
	WL	3,L3RN3B+FR2
	WL	3,L3RN3B+FR3
	WL	ANI_CODE,SMALL_RUN
	WL	3,L3RN3B+FR4
 
	WL	ANI_GOTO,#lp1


#*****************************************************************************
*
* BOUNCE OFF ROPES

 SUBR	lex_bounce_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_OVERLAP+MODE_NOAUTOFLIP| MODE_NOCONFINE	;uninterruptable

	.ref	fix_bnc_flip
	WL	ANI_CODE,fix_bnc_flip
  
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	2,L4BO3Z+FR1
	.word	ANI_BOUNCEROPE,0
	WL	1,L4BO3Z+FR1

	WL	2,L4BO3Z+FR2
	.word	ANI_BOUNCEROPE,1
	WL	ANI_CODE,SMALL_RUN

	WL	1,L4BO3Z+FR2

	WL	2,L4BO3Z+FR3
	.word	ANI_BOUNCEROPE,2
	WL	1,L4BO3Z+FR3

	WL	2,L4BO3Z+FR4
	.word	ANI_BOUNCEROPE,3
	WL	1,L4BO3Z+FR4

	.word	ANI_ZEROVELS

	WL	2,L4BO3Z+FR5
	.word	ANI_BOUNCEROPE,4
	WL	1,L4BO3Z+FR5
	WL	3,L4BO3Z+FR6
	WL	2,L4BO3Z+FR7
	.word	ANI_BOUNCEROPE,0
	WL	1,L4BO3Z+FR7
	WL	2,L4BO3Z+FR8
	.word	ANI_BOUNCEROPE,-1
	WL	ANI_CODE,SMALL_RUN
	WL	1,L4BO3Z+FR8
	WL	3,L4BO3Z+FR9
	WL	3,L4BO3Z+FR10

	.word	ANI_OFFSET,15,0,0

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


******************************************************************************
 
	.end
