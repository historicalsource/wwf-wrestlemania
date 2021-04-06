**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		5/17/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"bamseq1.asm"
	.title	"Bam Bam Bigelo animation sequences"
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

	.include	"bamimg.h"
	.include	"takerimg.h"	;<---temp!!!


******************************************************************************
* EXTERNAL REFERENCES

	.ref	SMALL_RUN,fix_bnc_flip,MAYBE_BOUNCE_ROPE

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* STANDS

 SUBR	bam_zip_anim
	WL	60*60,B2ST2A+FR1
	.word	ANI_END


 SUBR	bam_stand2_anim
 SUBR	bam_stand8_anim
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	WL	4,B2ST2A+FR1
	WL	4,B2ST2A+FR2
	WL	4,B2ST2A+FR3
	WL	4,B2ST2A+FR4
	WL	4,B2ST2A+FR5
	WL	4,B2ST2A+FR6
	WL	4,B2ST2A+FR7
	WL	4,B2ST2A+FR8
	WL	4,B2ST2A+FR9
	WL	4,B2ST2A+FR10
	WL	4,B2ST2A+FR11
	WL	4,B2ST2A+FR12
	WL	4,B2ST2A+FR13
	.word	ANI_REPEAT


 SUBR	bam_stand4_anim
 SUBR	bam_stand6_anim
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	WL	6,B4ST4Z+FR1
	WL	6,B4ST4Z+FR2
	WL	6,B4ST4Z+FR3
	WL	6,B4ST4Z+FR4
	WL	6,B4ST4Z+FR5
	WL	6,B4ST4Z+FR6
	WL	6,B4ST4Z+FR7
	WL	6,B4ST4Z+FR8
	WL	6,B4ST4Z+FR9
	.word	ANI_REPEAT


#*****************************************************************************
*
* WALKING TORSOS

 SUBR	bam_torso2_anim
 SUBR	bam_torso8_anim

	WL	6,B2TW2Z+FR1
	WL	6,B2TW2Z+FR2
	WL	6,B2TW2Z+FR3
	WL	6,B2TW2Z+FR2
	.word	ANI_REPEAT


 SUBR	bam_torso4_anim
 SUBR	bam_torso6_anim

	WL	6,B4TW4Z+FR1
	WL	6,B4TW4Z+FR2
	WL	6,B4TW4Z+FR3
	WL	6,B4TW4Z+FR2
	.word	ANI_REPEAT

 SUBR	bam_holdoh_anim
	WL	999,B4PO4Z+FR1
	.word	ANI_REPEAT


#*****************************************************************************
*
* WALKS FACING #2

 SUBR	bam_walk1_f2_anim
	WL	2,B2WL1A+FR1
	WL	2,B2WL1A+FR2
	WL	2,B2WL1A+FR3
	WL	2+1,B2WL1A+FR4
	WL	2,B2WL1A+FR5
	WL	2,B2WL1A+FR6
	WL	2,B2WL1A+FR7
	WL	2+1,B2WL1A+FR8
	WL	2,B2WL1A+FR9
	WL	2,B2WL1A+FR10
	WL	2,B2WL1A+FR11
	WL	2+1,B2WL1A+FR12
	WL	2,B2WL1A+FR13
	WL	2,B2WL1A+FR14
	WL	2,B2WL1A+FR15
	WL	2+1,B2WL1A+FR16
	.word	ANI_REPEAT

 SUBR	bam_walk2_f2_anim
	WL	2,B2WL2B+FR1
	WL	2,B2WL2B+FR2
	WL	2,B2WL2B+FR3
	WL	2,B2WL2B+FR4
	WL	2,B2WL2B+FR5
	WL	2,B2WL2B+FR6
	WL	2,B2WL2B+FR7
	WL	2,B2WL2B+FR8
	WL	2,B2WL2B+FR9
	WL	2,B2WL2B+FR10
	WL	2,B2WL2B+FR11
	WL	2,B2WL2B+FR12
	WL	2,B2WL2B+FR13
	WL	2,B2WL2B+FR14
	WL	2,B2WL2B+FR15
	WL	2,B2WL2B+FR16
	WL	2,B2WL2B+FR17
	WL	2,B2WL2B+FR18
	.word	ANI_REPEAT

 SUBR	bam_walk4_f2_anim
	WL	3,B2WL8B+FR1
	WL	3,B2WL8B+FR2
	WL	3,B2WL8B+FR3
	WL	3,B2WL8B+FR4
	WL	3,B2WL8B+FR5
	WL	3,B2WL8B+FR6
	WL	3,B2WL8B+FR7
	WL	3,B2WL8B+FR8
	WL	3,B2WL8B+FR9
	WL	3,B2WL8B+FR10
	WL	3,B2WL8B+FR11
	WL	3,B2WL8B+FR12
	.word	ANI_REPEAT

 SUBR	bam_walk5_f2_anim
	WL	2,B2WL1A+FR16
	WL	2,B2WL1A+FR15
	WL	2,B2WL1A+FR14
	WL	2+1,B2WL1A+FR13
	WL	2,B2WL1A+FR12
	WL	2,B2WL1A+FR11
	WL	2,B2WL1A+FR10
	WL	2+1,B2WL1A+FR9
	WL	2,B2WL1A+FR8
	WL	2,B2WL1A+FR7
	WL	2,B2WL1A+FR6
	WL	2+1,B2WL1A+FR5
	WL	2,B2WL1A+FR4
	WL	2,B2WL1A+FR3
	WL	2,B2WL1A+FR2
	WL	2+1,B2WL1A+FR1
	.word	ANI_REPEAT

 SUBR	bam_walk6_f2_anim
	WL	2,B2WL2B+FR18
	WL	2,B2WL2B+FR17
	WL	2,B2WL2B+FR16
	WL	2,B2WL2B+FR15
	WL	2,B2WL2B+FR14
	WL	2,B2WL2B+FR13
	WL	2,B2WL2B+FR12
	WL	2,B2WL2B+FR11
	WL	2,B2WL2B+FR10
	WL	2,B2WL2B+FR9
	WL	2,B2WL2B+FR8
	WL	2,B2WL2B+FR7
	WL	2,B2WL2B+FR6
	WL	2,B2WL2B+FR5
	WL	2,B2WL2B+FR4
	WL	2,B2WL2B+FR3
	WL	2,B2WL2B+FR2
	WL	2,B2WL2B+FR1
	.word	ANI_REPEAT


 SUBR	bam_walk8_f2_anim
	WL	3,B2WL8B+FR12
	WL	3,B2WL8B+FR11
	WL	3,B2WL8B+FR10
	WL	3,B2WL8B+FR9
	WL	3,B2WL8B+FR8
	WL	3,B2WL8B+FR7
	WL	3,B2WL8B+FR6
	WL	3,B2WL8B+FR5
	WL	3,B2WL8B+FR4
	WL	3,B2WL8B+FR3
	WL	3,B2WL8B+FR2
	WL	3,B2WL8B+FR1
	.word	ANI_REPEAT



#*****************************************************************************
*
* WALKS FACING #4

 SUBR	bam_walk1_f4_anim
	WL	2,B4WL5B+FR15
	WL	2+1,B4WL5B+FR14
	WL	2,B4WL5B+FR13
	WL	2,B4WL5B+FR12
	WL	2+1,B4WL5B+FR11
	WL	2,B4WL5B+FR10
	WL	2+1,B4WL5B+FR9
	WL	2,B4WL5B+FR8
	WL	2,B4WL5B+FR7
	WL	2+1,B4WL5B+FR6
	WL	2,B4WL5B+FR5
	WL	2+1,B4WL5B+FR4
	WL	2,B4WL5B+FR3
	WL	2,B4WL5B+FR2
	WL	2+1,B4WL5B+FR1
	.word	ANI_REPEAT

 SUBR	bam_walk2_f4_anim
	WL	2,B4WL2A+FR1
	WL	2+1,B4WL2A+FR2
	WL	2,B4WL2A+FR3
	WL	2,B4WL2A+FR4
	WL	2+1,B4WL2A+FR5
	WL	2,B4WL2A+FR6
	WL	2+1,B4WL2A+FR7
	WL	2,B4WL2A+FR8
	WL	2,B4WL2A+FR9
	WL	2+1,B4WL2A+FR10
	WL	2,B4WL2A+FR11
	WL	2+1,B4WL2A+FR12
	WL	2,B4WL2A+FR13
	WL	2,B4WL2A+FR14
	WL	2+1,B4WL2A+FR15
	.word	ANI_REPEAT

 SUBR	bam_walk4_f4_anim
	WL	2,B4WL4B+FR1
	WL	2,B4WL4B+FR2
	WL	2,B4WL4B+FR3
	WL	2,B4WL4B+FR4
	WL	2,B4WL4B+FR5
	WL	2,B4WL4B+FR6
	WL	2,B4WL4B+FR7
	WL	2,B4WL4B+FR8
	WL	2,B4WL4B+FR9
	WL	2,B4WL4B+FR10
	WL	2,B4WL4B+FR11
	WL	2,B4WL4B+FR12
	WL	2,B4WL4B+FR13
	WL	2,B4WL4B+FR14
	WL	2,B4WL4B+FR15
	WL	2,B4WL4B+FR16
	WL	2,B4WL4B+FR17
	WL	2,B4WL4B+FR18
	.word	ANI_REPEAT

 SUBR	bam_walk5_f4_anim
	WL	2,B4WL5B+FR1
	WL	2+1,B4WL5B+FR2
	WL	2,B4WL5B+FR3
	WL	2,B4WL5B+FR4
	WL	2+1,B4WL5B+FR5
	WL	2,B4WL5B+FR6
	WL	2+1,B4WL5B+FR7
	WL	2,B4WL5B+FR8
	WL	2,B4WL5B+FR9
	WL	2+1,B4WL5B+FR10
	WL	2,B4WL5B+FR11
	WL	2+1,B4WL5B+FR12
	WL	2,B4WL5B+FR13
	WL	2,B4WL5B+FR14
	WL	2+1,B4WL5B+FR15
	.word	ANI_REPEAT

 SUBR	bam_walk6_f4_anim
	WL	2,B4WL2A+FR15
	WL	2+1,B4WL2A+FR14
	WL	2,B4WL2A+FR13
	WL	2,B4WL2A+FR12
	WL	2+1,B4WL2A+FR11
	WL	2,B4WL2A+FR10
	WL	2+1,B4WL2A+FR9
	WL	2,B4WL2A+FR8
	WL	2,B4WL2A+FR7
	WL	2+1,B4WL2A+FR6
	WL	2,B4WL2A+FR5
	WL	2+1,B4WL2A+FR4
	WL	2,B4WL2A+FR3
	WL	2,B4WL2A+FR2
	WL	2+1,B4WL2A+FR1
	.word	ANI_REPEAT

 SUBR	bam_walk8_f4_anim
	WL	2,B4WL4B+FR18
	WL	2,B4WL4B+FR17
	WL	2,B4WL4B+FR16
	WL	2,B4WL4B+FR15
	WL	2,B4WL4B+FR14
	WL	2,B4WL4B+FR13
	WL	2,B4WL4B+FR12
	WL	2,B4WL4B+FR11
	WL	2,B4WL4B+FR10
	WL	2,B4WL4B+FR9
	WL	2,B4WL4B+FR8
	WL	2,B4WL4B+FR7
	WL	2,B4WL4B+FR6
	WL	2,B4WL4B+FR5
	WL	2,B4WL4B+FR4
	WL	2,B4WL4B+FR3
	WL	2,B4WL4B+FR2
	WL	2,B4WL4B+FR1
	.word	ANI_REPEAT


#*****************************************************************************
*
* TURNS (STANDS)

 SUBR	bam_2_to_4_turn_anim
 SUBR	bam_8_to_6_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,B1TT5Z+FR2	;2.5
	WL	3,B1TT5Z+FR3	;3.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_4_to_2_turn_anim
 SUBR	bam_6_to_8_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,B1TT5Z+FR3	;3.5
	WL	3,B1TT5Z+FR2	;2.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_4_to_6_turn_anim
 SUBR	bam_6_to_4_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,B1TT5Z+FR4	;4.5
	.word	ANI_XFLIP
	WL	3,B1TT5Z+FR4	;4.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_2_to_8_turn_anim
 SUBR	bam_8_to_2_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,B1TT5Z+FR1	;1.5
	.word	ANI_XFLIP
	WL	3,B1TT5Z+FR1	;1.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_4_to_8_turn_anim
 SUBR	bam_6_to_2_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,B1TT5Z+FR3	;3.5
	WL	3,B1TT5Z+FR2	;2.5
	WL	3,B1TT5Z+FR1	;1.5
	.word	ANI_XFLIP
	WL	3,B1TT5Z+FR1	;1.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_2_to_6_turn_anim
 SUBR	bam_8_to_4_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,B1TT5Z+FR2	;2.5
	WL	3,B1TT5Z+FR3	;3.5
	WL	3,B1TT5Z+FR4	;4.5
	.word	ANI_XFLIP
	WL	3,B1TT5Z+FR4	;4.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* TURNS (TORSOS)

 SUBR	bam_2_to_4_turn2_anim
 SUBR	bam_8_to_6_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,B1TR5Z+FR2	;2.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,B1TR5Z+FR3	;3.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_4_to_2_turn2_anim
 SUBR	bam_6_to_8_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,B1TR5Z+FR3	;3.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,B1TR5Z+FR2	;2.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_4_to_6_turn2_anim
 SUBR	bam_6_to_4_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,B1TR5Z+FR4	;4.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,B1TR5Z+FR4	;4.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_2_to_8_turn2_anim
 SUBR	bam_8_to_2_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,B1TR5Z+FR1	;1.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,B1TR5Z+FR1	;1.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_4_to_8_turn2_anim
 SUBR	bam_6_to_2_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,B1TR5Z+FR4	;4.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,B1TR5Z+FR4	;4.5
	WL	3,B1TR5Z+FR3	;3.5
	.word	ANI_SETFACING
	WL	3,B1TR5Z+FR2	;2.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_2_to_6_turn2_anim
 SUBR	bam_8_to_4_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,B1TR5Z+FR2	;2.5
	.word	ANI_SETFACING
	WL	3,B1TR5Z+FR3	;3.5
	WL	3,B1TR5Z+FR4	;4.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,B1TR5Z+FR4	;4.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* RUNNING IN #3

 SUBR	bam_run2_anim

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

;I'm turning on an attack box for the entire run sequence.
;I never turn it off.

	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,16+8,71	;mode,x,y,w,h
	WL	ANI_GOTO,#run2

 SUBR	bam_run_anim

	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,16,71	;mode,x,y,w,h

#lp1
	WL	3,B3RN3A+FR1
	WL	2,B3RN3A+FR2
	WL	3,B3RN3A+FR3
	WL	ANI_CODE,SMALL_RUN
	WL	2,B3RN3A+FR4
	WL	3,B3RN3A+FR5
#run2
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,16+8,71	;mode,x,y,w,h
	WL	2,B3RN3A+FR6
	WL	3,B3RN3A+FR7
	WL	2,B3RN3A+FR8
	WL	3,B3RN3A+FR9
	WL	ANI_CODE,SMALL_RUN
	WL	2,B3RN3A+FR10
	WL	3,B3RN3A+FR11
	WL	2,B3RN3A+FR12

	WL	ANI_GOTO,#lp1


#*****************************************************************************
*
* BOUNCE OFF ROPES

 SUBR	bam_bounce_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_OVERLAP|MODE_NOAUTOFLIP| MODE_NOCONFINE	;uninterruptable
  
	WL	ANI_CODE,fix_bnc_flip
	WL	ANI_CODE,MAYBE_BOUNCE_ROPE

	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	3,B4BO3Z+FR1
	.word	ANI_BOUNCEROPE,0
	WL	1,B4BO3Z+FR1

	WL	3,B4BO3Z+FR2
	.word	ANI_BOUNCEROPE,1
	WL	ANI_CODE,SMALL_RUN

	WL	1,B4BO3Z+FR2

	WL	3,B4BO3Z+FR3
	.word	ANI_BOUNCEROPE,2
	WL	1,B4BO3Z+FR3

	WL	3,B4BO3Z+FR4
	.word	ANI_BOUNCEROPE,3
	WL	1,B4BO3Z+FR4

	.word	ANI_ZEROVELS

	WL	3,B4BO3Z+FR5
	.word	ANI_BOUNCEROPE,4
	WL	1,B4BO3Z+FR5
	WL	4,B4BO3Z+FR6
	WL	3,B4BO3Z+FR7
	.word	ANI_BOUNCEROPE,0
	WL	1,B4BO3Z+FR7
	WL	3,B4BO3Z+FR8
	.word	ANI_BOUNCEROPE,-1
	WL	ANI_CODE,SMALL_RUN
	WL	1,B4BO3Z+FR8
	WL	4,B4BO3Z+FR9

	.word	ANI_OFFSET,-10,0,0

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


******************************************************************************

	.end
