**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		1/25/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"rzrseq1.asm"
	.title	"Razor Ramon animation sequences"
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

	.include	"razorimg.h"


******************************************************************************
* EXTERNAL REFERENCES

	.REF	MAYBE_BOUNCE_ROPE
	.ref	SMALL_RUN

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

TSEC 	equ	53

#*****************************************************************************
*
* STANDS

 SUBR	rzr_zip_anim
	WL	TSEC*60,R2ST2C+FR3
	.word	0

 SUBR	rzr_stand2_anim
 SUBR	rzr_stand8_anim

	WL	7,R2ST2C+FR3
	WL	6,R2ST2C+FR5
	WL	6,R2ST2C+FR7
	WL	6,R2ST2C+FR9
	WL	6,R2ST2C+FR7
	WL	7,R2ST2C+FR5
	.word	ANI_REPEAT


 SUBR	rzr_stand4_anim
 SUBR	rzr_stand6_anim

	WL	7,R4ST4G+FR1
	WL	6,R4ST4G+FR3
	WL	6,R4ST4G+FR5
	WL	6,R4ST4G+FR7
	WL	6,R4ST4G+FR5
	WL	7,R4ST4G+FR3
	.word	ANI_REPEAT


#*****************************************************************************
*
* WALKING TORSOS

 SUBR	rzr_torso2_anim
 SUBR	rzr_torso8_anim
	WL	4,R2TW2Z+FR1
	WL	4,R2TW2Z+FR2
	WL	4,R2TW2Z+FR3
	WL	4,R2TW2Z+FR4
	WL	4,R2TW2Z+FR3
	WL	4,R2TW2Z+FR2
	.word	ANI_REPEAT


 SUBR	rzr_torso4_anim
 SUBR	rzr_torso6_anim
	WL	4,R4TW4Z+FR1
	WL	4,R4TW4Z+FR2
	WL	4,R4TW4Z+FR3
	WL	4,R4TW4Z+FR4
	WL	4,R4TW4Z+FR3
	WL	4,R4TW4Z+FR2
	.word	ANI_REPEAT


#*****************************************************************************
*
* WALKS FACING #2

 SUBR	rzr_walk1_f2_anim
	WL	2,R2WL1A+FR1
	WL	2,R2WL1A+FR2
	WL	2,R2WL1A+FR3
	WL	2,R2WL1A+FR4
	WL	2,R2WL1A+FR5
	WL	2,R2WL1A+FR6
	WL	2,R2WL1A+FR7
	WL	2,R2WL1A+FR8
	WL	2,R2WL1A+FR9
	WL	2,R2WL1A+FR10
	WL	2,R2WL1A+FR11
	WL	2,R2WL1A+FR12
	WL	2,R2WL1A+FR13
	WL	2,R2WL1A+FR14
	WL	2,R2WL1A+FR15
	WL	2,R2WL1A+FR16
	WL	2,R2WL1A+FR17
	WL	2,R2WL1A+FR18
	WL	2,R2WL1A+FR19
	WL	2,R2WL1A+FR20
	.word	ANI_REPEAT

 SUBR	rzr_walk2_f2_anim
	WL	2,R2WL2A+FR1
	WL	2,R2WL2A+FR2
	WL	2,R2WL2A+FR3
	WL	2,R2WL2A+FR4
	WL	2,R2WL2A+FR5
	WL	2,R2WL2A+FR6
	WL	2,R2WL2A+FR7
	WL	2,R2WL2A+FR8
	WL	2,R2WL2A+FR9
	WL	2,R2WL2A+FR10
	WL	2,R2WL2A+FR11
	WL	2,R2WL2A+FR12
	WL	2,R2WL2A+FR13
	WL	2,R2WL2A+FR14
	WL	2,R2WL2A+FR15
	WL	2,R2WL2A+FR16
	WL	2,R2WL2A+FR17
	WL	2,R2WL2A+FR18
	WL	2,R2WL2A+FR19
	WL	2,R2WL2A+FR20
	.word	ANI_REPEAT

 SUBR	rzr_walk4_f2_anim
	WL	2,R2WL4B+FR1
	WL	2,R2WL4B+FR2
	WL	2,R2WL4B+FR3
	WL	2,R2WL4B+FR4
	WL	2,R2WL4B+FR5
	WL	2,R2WL4B+FR6
	WL	2,R2WL4B+FR7
	WL	2,R2WL4B+FR8
	WL	2,R2WL4B+FR9
	WL	2,R2WL4B+FR10
	WL	2,R2WL4B+FR11
	WL	2,R2WL4B+FR12
	WL	2,R2WL4B+FR13
	WL	2,R2WL4B+FR14
	WL	2,R2WL4B+FR15
	WL	2,R2WL4B+FR16
	WL	2,R2WL4B+FR17
	WL	2,R2WL4B+FR18
	WL	2,R2WL4B+FR19
	WL	2,R2WL4B+FR20
	WL	2,R2WL4B+FR21
	.word	ANI_REPEAT

 SUBR	rzr_walk5_f2_anim
	WL	2,R2WL1A+FR20
	WL	2,R2WL1A+FR19
	WL	2,R2WL1A+FR18
	WL	2,R2WL1A+FR17
	WL	2,R2WL1A+FR16
	WL	2,R2WL1A+FR15
	WL	2,R2WL1A+FR14
	WL	2,R2WL1A+FR13
	WL	2,R2WL1A+FR12
	WL	2,R2WL1A+FR11
	WL	2,R2WL1A+FR10
	WL	2,R2WL1A+FR9
	WL	2,R2WL1A+FR8
	WL	2,R2WL1A+FR7
	WL	2,R2WL1A+FR6
	WL	2,R2WL1A+FR5
	WL	2,R2WL1A+FR4
	WL	2,R2WL1A+FR3
	WL	2,R2WL1A+FR2
	WL	2,R2WL1A+FR1
	.word	ANI_REPEAT

 SUBR	rzr_walk6_f2_anim
	WL	2,R2WL2A+FR20
	WL	2,R2WL2A+FR19
	WL	2,R2WL2A+FR18
	WL	2,R2WL2A+FR17
	WL	2,R2WL2A+FR16
	WL	2,R2WL2A+FR15
	WL	2,R2WL2A+FR14
	WL	2,R2WL2A+FR13
	WL	2,R2WL2A+FR12
	WL	2,R2WL2A+FR11
	WL	2,R2WL2A+FR10
	WL	2,R2WL2A+FR9
	WL	2,R2WL2A+FR8
	WL	2,R2WL2A+FR7
	WL	2,R2WL2A+FR6
	WL	2,R2WL2A+FR5
	WL	2,R2WL2A+FR4
	WL	2,R2WL2A+FR3
	WL	2,R2WL2A+FR2
	WL	2,R2WL2A+FR1
	.word	ANI_REPEAT


 SUBR	rzr_walk8_f2_anim
	WL	2,R2WL4B+FR21
	WL	2,R2WL4B+FR20
	WL	2,R2WL4B+FR19
	WL	2,R2WL4B+FR18
	WL	2,R2WL4B+FR17
	WL	2,R2WL4B+FR16
	WL	2,R2WL4B+FR15
	WL	2,R2WL4B+FR14
	WL	2,R2WL4B+FR13
	WL	2,R2WL4B+FR12
	WL	2,R2WL4B+FR11
	WL	2,R2WL4B+FR10
	WL	2,R2WL4B+FR9
	WL	2,R2WL4B+FR8
	WL	2,R2WL4B+FR7
	WL	2,R2WL4B+FR6
	WL	2,R2WL4B+FR5
	WL	2,R2WL4B+FR4
	WL	2,R2WL4B+FR3
	WL	2,R2WL4B+FR2
	WL	2,R2WL4B+FR1
	.word	ANI_REPEAT



#*****************************************************************************
*
* WALKS FACING #4

 SUBR	rzr_walk1_f4_anim
	WL	2,R4WL5A+FR18
	WL	2,R4WL5A+FR17
	WL	2,R4WL5A+FR16
	WL	2,R4WL5A+FR15
	WL	2,R4WL5A+FR14
	WL	2,R4WL5A+FR13
	WL	2,R4WL5A+FR12
	WL	2,R4WL5A+FR11
	WL	2,R4WL5A+FR10
	WL	2,R4WL5A+FR9
	WL	2,R4WL5A+FR8
	WL	2,R4WL5A+FR7
	WL	2,R4WL5A+FR6
	WL	2,R4WL5A+FR5
	WL	2,R4WL5A+FR4
	WL	2,R4WL5A+FR3
	WL	2,R4WL5A+FR2
	WL	2,R4WL5A+FR1
	.word	ANI_REPEAT

 SUBR	rzr_walk2_f4_anim
	WL	2,R4WL2A+FR1
	WL	2,R4WL2A+FR2
	WL	2,R4WL2A+FR3
	WL	2,R4WL2A+FR4
	WL	2,R4WL2A+FR5
	WL	2,R4WL2A+FR6
	WL	2,R4WL2A+FR7
	WL	2,R4WL2A+FR8
	WL	2,R4WL2A+FR9
	WL	2,R4WL2A+FR10
	WL	2,R4WL2A+FR11
	WL	2,R4WL2A+FR12
	WL	2,R4WL2A+FR13
	WL	2,R4WL2A+FR14
	WL	2,R4WL2A+FR15
	WL	2,R4WL2A+FR16
	WL	2,R4WL2A+FR17
	WL	2,R4WL2A+FR18
	WL	2,R4WL2A+FR19
	WL	2,R4WL2A+FR20
	.word	ANI_REPEAT

 SUBR	rzr_walk4_f4_anim
	WL	2,R4WL4A+FR1
	WL	2,R4WL4A+FR2
	WL	2,R4WL4A+FR3
	WL	2,R4WL4A+FR4
	WL	2,R4WL4A+FR5
	WL	2,R4WL4A+FR6
	WL	2,R4WL4A+FR7
	WL	2,R4WL4A+FR8
	WL	2,R4WL4A+FR9
	WL	2,R4WL4A+FR10
	WL	2,R4WL4A+FR11
	WL	2,R4WL4A+FR12
	WL	2,R4WL4A+FR13
	WL	2,R4WL4A+FR14
	WL	2,R4WL4A+FR15
	WL	2,R4WL4A+FR16
	WL	2,R4WL4A+FR17
	WL	2,R4WL4A+FR18
	.word	ANI_REPEAT

 SUBR	rzr_walk5_f4_anim
	WL	2,R4WL5A+FR1
	WL	2,R4WL5A+FR2
	WL	2,R4WL5A+FR3
	WL	2,R4WL5A+FR4
	WL	2,R4WL5A+FR5
	WL	2,R4WL5A+FR6
	WL	2,R4WL5A+FR7
	WL	2,R4WL5A+FR8
	WL	2,R4WL5A+FR9
	WL	2,R4WL5A+FR10
	WL	2,R4WL5A+FR11
	WL	2,R4WL5A+FR12
	WL	2,R4WL5A+FR13
	WL	2,R4WL5A+FR14
	WL	2,R4WL5A+FR15
	WL	2,R4WL5A+FR16
	WL	2,R4WL5A+FR17
	WL	2,R4WL5A+FR18
	.word	ANI_REPEAT

 SUBR	rzr_walk6_f4_anim
	WL	2,R4WL2A+FR20
	WL	2,R4WL2A+FR19
	WL	2,R4WL2A+FR18
	WL	2,R4WL2A+FR17
	WL	2,R4WL2A+FR16
	WL	2,R4WL2A+FR15
	WL	2,R4WL2A+FR14
	WL	2,R4WL2A+FR13
	WL	2,R4WL2A+FR12
	WL	2,R4WL2A+FR11
	WL	2,R4WL2A+FR10
	WL	2,R4WL2A+FR9
	WL	2,R4WL2A+FR8
	WL	2,R4WL2A+FR7
	WL	2,R4WL2A+FR6
	WL	2,R4WL2A+FR5
	WL	2,R4WL2A+FR4
	WL	2,R4WL2A+FR3
	WL	2,R4WL2A+FR2
	WL	2,R4WL2A+FR1
	.word	ANI_REPEAT

 SUBR	rzr_walk8_f4_anim
	WL	2,R4WL4A+FR18
	WL	2,R4WL4A+FR17
	WL	2,R4WL4A+FR16
	WL	2,R4WL4A+FR15
	WL	2,R4WL4A+FR14
	WL	2,R4WL4A+FR13
	WL	2,R4WL4A+FR12
	WL	2,R4WL4A+FR11
	WL	2,R4WL4A+FR10
	WL	2,R4WL4A+FR9
	WL	2,R4WL4A+FR8
	WL	2,R4WL4A+FR7
	WL	2,R4WL4A+FR6
	WL	2,R4WL4A+FR5
	WL	2,R4WL4A+FR4
	WL	2,R4WL4A+FR3
	WL	2,R4WL4A+FR2
	WL	2,R4WL4A+FR1
	.word	ANI_REPEAT



#*****************************************************************************
*
* TURNS (STANDS)


 SUBR	rzr_2_to_4_turn_anim
 SUBR	rzr_8_to_6_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,R1TT5Z+FR2
	WL	3,R1TT5Z+FR3
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	rzr_4_to_2_turn_anim
 SUBR	rzr_6_to_8_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,R1TT5Z+FR3
	WL	3,R1TT5Z+FR2
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	rzr_4_to_6_turn_anim
 SUBR	rzr_6_to_4_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,R1TT5Z+FR4
	.word	ANI_XFLIP
	WL	3,R1TT5Z+FR4
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	rzr_2_to_8_turn_anim
 SUBR	rzr_8_to_2_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,R1TT5Z+FR1
	.word	ANI_XFLIP
	WL	3,R1TT5Z+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	rzr_4_to_8_turn_anim
 SUBR	rzr_6_to_2_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,R1TT5Z+FR3	;3.5
	WL	3,R1TT5Z+FR2	;2.5
	WL	3,R1TT5Z+FR1	;1.5
	.word	ANI_XFLIP
	WL	3,R1TT5Z+FR1	;1.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	rzr_2_to_6_turn_anim
 SUBR	rzr_8_to_4_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,R1TT5Z+FR2	;2.5
	WL	3,R1TT5Z+FR3	;3.5
	WL	3,R1TT5Z+FR4	;4.5
	.word	ANI_XFLIP
	WL	3,R1TT5Z+FR4	;4.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* TURNS (TORSOS)


 SUBR	rzr_2_to_4_turn2_anim
 SUBR	rzr_8_to_6_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,R1TR5Z+FR2
	.word	ANI_SETFACING
	WL	3,R1TR5Z+FR3
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	rzr_4_to_2_turn2_anim
 SUBR	rzr_6_to_8_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,R1TR5Z+FR3
	.word	ANI_SETFACING
	WL	3,R1TR5Z+FR2
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	rzr_4_to_6_turn2_anim
 SUBR	rzr_6_to_4_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,R1TR5Z+FR4
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,R1TR5Z+FR4
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	rzr_2_to_8_turn2_anim
 SUBR	rzr_8_to_2_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,R1TR5Z+FR1
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,R1TR5Z+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	rzr_4_to_8_turn2_anim
 SUBR	rzr_6_to_2_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,R1TR5Z+FR4	;4.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,R1TR5Z+FR4	;4.5
	WL	3,R1TR5Z+FR3	;3.5
	.word	ANI_SETFACING
	WL	3,R1TR5Z+FR2	;2.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	rzr_2_to_6_turn2_anim
 SUBR	rzr_8_to_4_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,R1TR5Z+FR2	;2.5
	.word	ANI_SETFACING
	WL	3,R1TR5Z+FR3	;3.5
	WL	3,R1TR5Z+FR4	;4.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,R1TR5Z+FR4	;4.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* RUNNING IN #3

 SUBR	rzr_run2_anim

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

;I'm turning on an attack box for the entire run sequence.
;I never turn it off.

	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,16,71	;mode,x,y,w,h
	WL	ANI_GOTO,#run2

 SUBR	rzr_run_anim

	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,16,71	;mode,x,y,w,h

#lp1
	WL	ANI_CODE,SMALL_RUN
	WL	2,R3RN3D+FR1
	WL	3,R3RN3D+FR2
	WL	2,R3RN3D+FR3
	WL	3,R3RN3D+FR4
	WL	2,R3RN3D+FR5
#run2
	.word	ANI_SETMODE,MODE_NORMAL		;clear UNINT bit
	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,16,71	;mode,x,y,w,h
	WL	3,R3RN3D+FR6
	WL	2,R3RN3D+FR7
	WL	ANI_CODE,SMALL_RUN
	WL	3,R3RN3D+FR8
	WL	2,R3RN3D+FR9
	WL	3,R3RN3D+FR10
	WL	2,R3RN3D+FR11
	WL	3,R3RN3D+FR12
	WL	2,R3RN3D+FR13
	WL	3,R3RN3D+FR14

	WL	ANI_GOTO,#lp1



#*****************************************************************************
*
* BOUNCE OFF ROPES

 SUBR	rzr_bounce_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP| MODE_NOCONFINE	;uninterruptable
	.word	ANI_ZEROVELS

	.ref	fix_bnc_flip
	WL	ANI_CODE,fix_bnc_flip
	WL	ANI_CODE,MAYBE_BOUNCE_ROPE
  
  	WL	2,R4BO3Z+FR1
	.word	ANI_BOUNCEROPE,0
	WL	1,R4BO3Z+FR1

	WL	3,R4BO3Z+FR2
	.word	ANI_BOUNCEROPE,1

	WL	3,R4BO3Z+FR3

	WL	ANI_CODE,SMALL_RUN

	WL	2,R4BO3Z+FR4
	.word	ANI_BOUNCEROPE,2
	WL	1,R4BO3Z+FR4

	.word	ANI_ZEROVELS

	WL	2,R4BO3Z+FR5
	.word	ANI_BOUNCEROPE,3
	WL	1,R4BO3Z+FR5

	WL	2,R4BO3Z+FR6
	.word	ANI_BOUNCEROPE,4
	WL	1,R4BO3Z+FR6

	WL	3,R4BO3Z+FR7
	.word	ANI_BOUNCEROPE,0
	WL	3,R4BO3Z+FR8

	.word	ANI_BOUNCEROPE,-1

	WL	3,R4BO3Z+FR9

	WL	ANI_CODE,SMALL_RUN

	WL	3,R4BO3Z+FR10

	.word	ANI_OFFSET,15,0,0

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


******************************************************************************

	.end
