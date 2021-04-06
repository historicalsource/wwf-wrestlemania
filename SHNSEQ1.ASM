**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		5/26/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"shnseq1.asm"
	.title	"walks, runs, stances, and turns"
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
	.include	"shawnimg.h"

	.include	"doinkimg.h"		;temp!!!
	.include	"bamimg.h"	;temp!!!
	.include	"takerimg.h"	;temp!!!


******************************************************************************
* EXTERNAL REFERENCES
  
	.ref	SMALL_RUN
	.REF	MAYBE_BOUNCE_ROPE

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* STANDS

 SUBR	shn_zip_anim
	WL	60*60,B2ST2A+FR1
	.word	0	;<--??????
	.word	ANI_END


 SUBR	shn_stand2_anim
 SUBR	shn_stand8_anim
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	WL	4,S2ST2C+FR1
	WL	4,S2ST2C+FR3
	WL	4,S2ST2C+FR5
	WL	4,S2ST2C+FR7
	WL	4,S2ST2C+FR9
	WL	4,S2ST2C+FR11
	WL	4,S2ST2C+FR13
	WL	4,S2ST2C+FR15
	WL	4,S2ST2C+FR17
	.word	ANI_REPEAT


 SUBR	shn_stand4_anim
 SUBR	shn_stand6_anim
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	WL	4,S4ST4C+FR1
	WL	4,S4ST4C+FR3
	WL	4,S4ST4C+FR5
	WL	4,S4ST4C+FR7
	WL	4,S4ST4C+FR9
	WL	4,S4ST4C+FR11
	WL	4,S4ST4C+FR13
	WL	4,S4ST4C+FR15
	WL	4,S4ST4C+FR17
	WL	4,S4ST4C+FR19
	.word	ANI_REPEAT


#*****************************************************************************
*
* WALKING TORSOS

 SUBR	shn_torso2_anim
 SUBR	shn_torso8_anim

	WL	6,S2TW2B+FR1
	WL	6,S2TW2B+FR2
	WL	6,S2TW2B+FR3
	WL	6,S2TW2B+FR4
	WL	6,S2TW2B+FR3
	WL	6,S2TW2B+FR2
	.word	ANI_REPEAT


 SUBR	shn_torso4_anim
 SUBR	shn_torso6_anim

	WL	6,S4TW4C+FR1
	WL	6,S4TW4C+FR2
	WL	6,S4TW4C+FR3
	WL	6,S4TW4C+FR4
	WL	6,S4TW4C+FR3
	WL	6,S4TW4C+FR2
	.word	ANI_REPEAT


#*****************************************************************************
*
* WALKS FACING #2

 SUBR	shn_walk1_f2_anim
	WL	2,S2WL1A+FR1
	WL	2,S2WL1A+FR2
	WL	2,S2WL1A+FR3
	WL	2,S2WL1A+FR4
	WL	2,S2WL1A+FR5
	WL	2,S2WL1A+FR6
	WL	2,S2WL1A+FR7
	WL	2,S2WL1A+FR8
	WL	2,S2WL1A+FR9
	WL	2,S2WL1A+FR10
	WL	2,S2WL1A+FR11
	WL	2,S2WL1A+FR12
	WL	2,S2WL1A+FR13
	WL	2,S2WL1A+FR14
	WL	2,S2WL1A+FR15
	WL	2,S2WL1A+FR16
	WL	2,S2WL1A+FR17
	.word	ANI_REPEAT

 SUBR	shn_walk2_f2_anim
	WL	2,S2WL2B+FR1
	WL	2,S2WL2B+FR2
	WL	2,S2WL2B+FR3
	WL	2,S2WL2B+FR4
	WL	2,S2WL2B+FR5
	WL	2,S2WL2B+FR6
	WL	2,S2WL2B+FR7
	WL	2,S2WL2B+FR8
	WL	2,S2WL2B+FR9
	WL	2,S2WL2B+FR10
	WL	2,S2WL2B+FR11
	WL	2,S2WL2B+FR12
	WL	2,S2WL2B+FR13
	WL	2,S2WL2B+FR14
	WL	2,S2WL2B+FR15
	WL	2,S2WL2B+FR16
	WL	2,S2WL2B+FR17
	.word	ANI_REPEAT

 SUBR	shn_walk4_f2_anim
	WL	2,S2WL8A+FR1
	WL	2,S2WL8A+FR2
	WL	2,S2WL8A+FR3
	WL	2,S2WL8A+FR4
	WL	2,S2WL8A+FR5
	WL	2,S2WL8A+FR6
	WL	2,S2WL8A+FR7
	WL	2,S2WL8A+FR8
	WL	2,S2WL8A+FR9
	WL	2,S2WL8A+FR10
	WL	2,S2WL8A+FR11
	WL	2,S2WL8A+FR12
	WL	2,S2WL8A+FR13
	WL	2,S2WL8A+FR14
	WL	2,S2WL8A+FR15
	WL	2,S2WL8A+FR16
	.word	ANI_REPEAT

 SUBR	shn_walk5_f2_anim
	WL	2,S2WL1A+FR17
	WL	2,S2WL1A+FR16
	WL	2,S2WL1A+FR15
	WL	2,S2WL1A+FR14
	WL	2,S2WL1A+FR13
	WL	2,S2WL1A+FR12
	WL	2,S2WL1A+FR11
	WL	2,S2WL1A+FR10
	WL	2,S2WL1A+FR9
	WL	2,S2WL1A+FR8
	WL	2,S2WL1A+FR7
	WL	2,S2WL1A+FR6
	WL	2,S2WL1A+FR5
	WL	2,S2WL1A+FR4
	WL	2,S2WL1A+FR3
	WL	2,S2WL1A+FR2
	WL	2,S2WL1A+FR1
	.word	ANI_REPEAT

 SUBR	shn_walk6_f2_anim
	WL	2,S2WL2B+FR17
	WL	2,S2WL2B+FR16
	WL	2,S2WL2B+FR15
	WL	2,S2WL2B+FR14
	WL	2,S2WL2B+FR13
	WL	2,S2WL2B+FR12
	WL	2,S2WL2B+FR11
	WL	2,S2WL2B+FR10
	WL	2,S2WL2B+FR9
	WL	2,S2WL2B+FR8
	WL	2,S2WL2B+FR7
	WL	2,S2WL2B+FR6
	WL	2,S2WL2B+FR5
	WL	2,S2WL2B+FR4
	WL	2,S2WL2B+FR3
	WL	2,S2WL2B+FR2
	WL	2,S2WL2B+FR1
	.word	ANI_REPEAT


 SUBR	shn_walk8_f2_anim
	WL	2,S2WL8A+FR16
	WL	2,S2WL8A+FR15
	WL	2,S2WL8A+FR14
	WL	2,S2WL8A+FR13
	WL	2,S2WL8A+FR12
	WL	2,S2WL8A+FR11
	WL	2,S2WL8A+FR10
	WL	2,S2WL8A+FR9
	WL	2,S2WL8A+FR8
	WL	2,S2WL8A+FR7
	WL	2,S2WL8A+FR6
	WL	2,S2WL8A+FR5
	WL	2,S2WL8A+FR4
	WL	2,S2WL8A+FR3
	WL	2,S2WL8A+FR2
	WL	2,S2WL8A+FR1
	.word	ANI_REPEAT



#*****************************************************************************
*
* WALKS FACING #4

 SUBR	shn_walk1_f4_anim
	WL	2,S4WL5B+FR16
	WL	2,S4WL5B+FR15
	WL	2,S4WL5B+FR14
	WL	2,S4WL5B+FR13
	WL	2,S4WL5B+FR12
	WL	2,S4WL5B+FR11
	WL	2,S4WL5B+FR10
	WL	2,S4WL5B+FR9
	WL	2,S4WL5B+FR8
	WL	2,S4WL5B+FR7
	WL	2,S4WL5B+FR6
	WL	2,S4WL5B+FR5
	WL	2,S4WL5B+FR4
	WL	2,S4WL5B+FR3
	WL	2,S4WL5B+FR2
	WL	2,S4WL5B+FR1
	.word	ANI_REPEAT

 SUBR	shn_walk2_f4_anim
	WL	2,S4WL2A+FR1
	WL	2,S4WL2A+FR2
	WL	2,S4WL2A+FR3
	WL	2,S4WL2A+FR4
	WL	2,S4WL2A+FR5
	WL	2,S4WL2A+FR6
	WL	2,S4WL2A+FR7
	WL	2,S4WL2A+FR8
	WL	2,S4WL2A+FR9
	WL	2,S4WL2A+FR10
	WL	2,S4WL2A+FR11
	WL	2,S4WL2A+FR12
	WL	2,S4WL2A+FR13
	WL	2,S4WL2A+FR14
	WL	2,S4WL2A+FR15
	WL	2,S4WL2A+FR16
	.word	ANI_REPEAT

 SUBR	shn_walk4_f4_anim
	WL	2,S4WL4C+FR1
	WL	2,S4WL4C+FR2
	WL	2,S4WL4C+FR3
	WL	2,S4WL4C+FR4
	WL	2,S4WL4C+FR5
	WL	2,S4WL4C+FR6
	WL	2,S4WL4C+FR7
	WL	2,S4WL4C+FR8
	WL	2,S4WL4C+FR9
	WL	2,S4WL4C+FR10
	WL	2,S4WL4C+FR11
	WL	2,S4WL4C+FR12
	WL	2,S4WL4C+FR13
	WL	2,S4WL4C+FR14
	WL	2,S4WL4C+FR15
	WL	2,S4WL4C+FR16
	WL	2,S4WL4C+FR17
	WL	2,S4WL4C+FR18
	.word	ANI_REPEAT

 SUBR	shn_walk5_f4_anim
	WL	2,S4WL5B+FR1
	WL	2,S4WL5B+FR2
	WL	2,S4WL5B+FR3
	WL	2,S4WL5B+FR4
	WL	2,S4WL5B+FR5
	WL	2,S4WL5B+FR6
	WL	2,S4WL5B+FR7
	WL	2,S4WL5B+FR8
	WL	2,S4WL5B+FR9
	WL	2,S4WL5B+FR10
	WL	2,S4WL5B+FR11
	WL	2,S4WL5B+FR12
	WL	2,S4WL5B+FR13
	WL	2,S4WL5B+FR14
	WL	2,S4WL5B+FR15
	WL	2,S4WL5B+FR16
	.word	ANI_REPEAT

 SUBR	shn_walk6_f4_anim
	WL	2,S4WL2A+FR16
	WL	2,S4WL2A+FR15
	WL	2,S4WL2A+FR14
	WL	2,S4WL2A+FR13
	WL	2,S4WL2A+FR12
	WL	2,S4WL2A+FR11
	WL	2,S4WL2A+FR10
	WL	2,S4WL2A+FR9
	WL	2,S4WL2A+FR8
	WL	2,S4WL2A+FR7
	WL	2,S4WL2A+FR6
	WL	2,S4WL2A+FR5
	WL	2,S4WL2A+FR4
	WL	2,S4WL2A+FR3
	WL	2,S4WL2A+FR2
	WL	2,S4WL2A+FR1
	.word	ANI_REPEAT

 SUBR	shn_walk8_f4_anim
	WL	2,S4WL4C+FR18
	WL	2,S4WL4C+FR17
	WL	2,S4WL4C+FR16
	WL	2,S4WL4C+FR15
	WL	2,S4WL4C+FR14
	WL	2,S4WL4C+FR13
	WL	2,S4WL4C+FR12
	WL	2,S4WL4C+FR11
	WL	2,S4WL4C+FR10
	WL	2,S4WL4C+FR9
	WL	2,S4WL4C+FR8
	WL	2,S4WL4C+FR7
	WL	2,S4WL4C+FR6
	WL	2,S4WL4C+FR5
	WL	2,S4WL4C+FR4
	WL	2,S4WL4C+FR3
	WL	2,S4WL4C+FR2
	WL	2,S4WL4C+FR1
	.word	ANI_REPEAT

#*****************************************************************************
*
* TURNS (STANDS)

 SUBR	shn_2_to_4_turn_anim
 SUBR	shn_8_to_6_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,S1TT5Z+FR2	;2.5
	WL	3,S1TT5Z+FR3	;3.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	shn_4_to_2_turn_anim
 SUBR	shn_6_to_8_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,S1TT5Z+FR3	;3.5
	WL	3,S1TT5Z+FR2	;2.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	shn_4_to_6_turn_anim
 SUBR	shn_6_to_4_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,S1TT5Z+FR4	;4.5
	.word	ANI_XFLIP
	WL	3,S1TT5Z+FR4	;4.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	shn_2_to_8_turn_anim
 SUBR	shn_8_to_2_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,S1TT5Z+FR1	;1.5
	.word	ANI_XFLIP
	WL	3,S1TT5Z+FR1	;1.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	shn_4_to_8_turn_anim
 SUBR	shn_6_to_2_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,S1TT5Z+FR3	;3.5
	WL	3,S1TT5Z+FR2	;2.5
	WL	3,S1TT5Z+FR1	;1.5
	.word	ANI_XFLIP
	WL	3,S1TT5Z+FR1	;1.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	shn_2_to_6_turn_anim
 SUBR	shn_8_to_4_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,S1TT5Z+FR2	;2.5
	WL	3,S1TT5Z+FR3	;3.5
	WL	3,S1TT5Z+FR4	;4.5
	.word	ANI_XFLIP
	WL	3,S1TT5Z+FR4	;4.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* TURNS (TORSOS)

 SUBR	shn_2_to_4_turn2_anim
 SUBR	shn_8_to_6_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,S1TR5Z+FR2	;2.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,S1TR5Z+FR3	;3.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	shn_4_to_2_turn2_anim
 SUBR	shn_6_to_8_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,S1TR5Z+FR3	;3.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,S1TR5Z+FR2	;2.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	shn_4_to_6_turn2_anim
 SUBR	shn_6_to_4_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,S1TR5Z+FR4	;4.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,S1TR5Z+FR4	;4.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	shn_2_to_8_turn2_anim
 SUBR	shn_8_to_2_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,S1TR5Z+FR1	;1.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,S1TR5Z+FR1	;1.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	shn_4_to_8_turn2_anim
 SUBR	shn_6_to_2_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,S1TR5Z+FR4	;4.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,S1TR5Z+FR4	;4.5
	WL	3,S1TR5Z+FR3	;3.5
	.word	ANI_SETFACING
	WL	3,S1TR5Z+FR2	;2.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	shn_2_to_6_turn2_anim
 SUBR	shn_8_to_4_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,S1TR5Z+FR2	;2.5
	.word	ANI_SETFACING
	WL	3,S1TR5Z+FR3	;3.5
	WL	3,S1TR5Z+FR4	;4.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,S1TR5Z+FR4	;4.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* RUNNING IN #3

 SUBR	shn_run2_anim

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

;I'm turning on an attack box for the entire run sequence.
;I never turn it off.

	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,18h,71	;mode,x,y,w,h
	WL	ANI_GOTO,#run2

 SUBR	shn_run_anim

	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,18h,71	;mode,x,y,w,h

#lp1
	WL	3,S3RN3A+FR1
	WL	2,S3RN3A+FR2
	WL	3,S3RN3A+FR3
	WL	2,S3RN3A+FR4
	WL	3,S3RN3A+FR5
#run2
	.word	ANI_SETMODE,MODE_NORMAL		;clear UNINT bit
	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,18h,71	;mode,x,y,w,h
	WL	2,S3RN3A+FR6
	WL	ANI_CODE,SMALL_RUN
;	.word	ANI_SOUND,run_snd
	WL	3,S3RN3A+FR7
	WL	2,S3RN3A+FR8
	WL	3,S3RN3A+FR9
	WL	2,S3RN3A+FR10
	WL	3,S3RN3A+FR11
	WL	2,S3RN3A+FR12
	WL	3,S3RN3A+FR13
	WL	ANI_CODE,SMALL_RUN
;	.word	ANI_SOUND,run_snd
	WL	ANI_GOTO,#lp1


#*****************************************************************************
*
* BOUNCE OFF ROPES

 SUBR	shn_bounce_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP| MODE_NOCONFINE	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
  
	.ref	fix_bnc_flip
	WL	ANI_CODE,fix_bnc_flip
	WL	ANI_CODE,MAYBE_BOUNCE_ROPE
  
	WL	ANI_CODE,SMALL_RUN
;	.word	ANI_SOUND,run_snd

	WL	3,S3BO3A+FR2
	.word	ANI_BOUNCEROPE,0
	WL	1,S3BO3A+FR2

	WL	3,S3BO3A+FR3
	.word	ANI_BOUNCEROPE,1
	WL	1,S3BO3A+FR3

	WL	3,S3BO3A+FR4
	.word	ANI_BOUNCEROPE,2
	WL	1,S3BO3A+FR4

	WL	3,S3BO3A+FR5
	.word	ANI_BOUNCEROPE,3
	WL	1,S3BO3A+FR5

	.word	ANI_ZEROVELS

	WL	3,S3BO3A+FR6
	.word	ANI_BOUNCEROPE,4
	WL	1,S3BO3A+FR6
	WL	4,S3BO3A+FR7

	WL	3,S3BO3A+FR8
	.word	ANI_BOUNCEROPE,0
	WL	1,S3BO3A+FR8

	.word	ANI_OFFSET,-10,0,0

	WL	3,S3BO3A+FR9
	.word	ANI_BOUNCEROPE,-1
	WL	1,S3BO3A+FR9

	WL	ANI_CODE,SMALL_RUN

	.word	ANI_OFFSET,-30,0,0

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


******************************************************************************

	.end
