**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		5/17/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"hrtseq1.asm"
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

	.include	"bretimg.h"


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

 SUBR	hrt_zip_anim
	WL	60*60,H2ST2A+FR1
	.word	ANI_END


 SUBR	hrt_stand2_anim
 SUBR	hrt_stand8_anim
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	WL	4,H2ST2A+FR5
	WL	4,H2ST2A+FR6
	WL	4,H2ST2A+FR7
	WL	4+2,H2ST2A+FR8

	WL	4,H2ST2A+FR7
	WL	4,H2ST2A+FR6
	WL	4,H2ST2A+FR5
	WL	4,H2ST2A+FR4
	WL	4,H2ST2A+FR3
	WL	4,H2ST2A+FR2

	WL	4+2,H2ST2A+FR1
	WL	4,H2ST2A+FR2
	WL	4,H2ST2A+FR3
	WL	4,H2ST2A+FR4

	.word	ANI_REPEAT


 SUBR	hrt_stand4_anim
 SUBR	hrt_stand6_anim
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	WL	4,H4ST4A+FR2
	WL	4,H4ST4A+FR3
	WL	4,H4ST4A+FR4
	WL	4,H4ST4A+FR5
	WL	4,H4ST4A+FR6
	WL	4,H4ST4A+FR7
	WL	4+2,H4ST4A+FR8

	WL	4,H4ST4A+FR7
	WL	4,H4ST4A+FR6
	WL	4,H4ST4A+FR5
	WL	4,H4ST4A+FR4
	WL	4,H4ST4A+FR3
	WL	4,H4ST4A+FR2

	WL	4+2,H4ST4A+FR1

	.word	ANI_REPEAT


#*****************************************************************************
*
* WALKING TORSOS

 SUBR	hrt_torso2_anim
 SUBR	hrt_torso8_anim

	WL	4,H2TW2A+FR1
	WL	4,H2TW2A+FR2
	WL	4,H2TW2A+FR3
	WL	4,H2TW2A+FR4
	WL	4,H2TW2A+FR3
	WL	4,H2TW2A+FR2
	.word	ANI_REPEAT


 SUBR	hrt_torso4_anim
 SUBR	hrt_torso6_anim

	WL	4,H4TW4A+FR1
	WL	4,H4TW4A+FR2
	WL	4,H4TW4A+FR3
	WL	4,H4TW4A+FR4
	WL	4,H4TW4A+FR3
	WL	4,H4TW4A+FR2
	.word	ANI_REPEAT


#*****************************************************************************
*
* WALKS FACING #2

 SUBR	hrt_walk1_f2_anim

	WL	2,H2WL1A+FR1
	WL	2,H2WL1A+FR2
	WL	2,H2WL1A+FR3
	WL	2+1,H2WL1A+FR4
	WL	2,H2WL1A+FR5
	WL	2,H2WL1A+FR6
	WL	2,H2WL1A+FR7
	WL	2+1,H2WL1A+FR8
	WL	2,H2WL1A+FR9
	WL	2,H2WL1A+FR10
	WL	2,H2WL1A+FR11
	WL	2+1,H2WL1A+FR12
	WL	2,H2WL1A+FR13
	WL	2,H2WL1A+FR14
	WL	2,H2WL1A+FR15
	WL	2+1,H2WL1A+FR16

	.word	ANI_REPEAT

 SUBR	hrt_walk2_f2_anim

	WL	2,H2WL2A+FR1
	WL	2,H2WL2A+FR2
	WL	2,H2WL2A+FR3
	WL	2+1,H2WL2A+FR4
	WL	2,H2WL2A+FR5
	WL	2,H2WL2A+FR6
	WL	2,H2WL2A+FR7
	WL	2+1,H2WL2A+FR8
	WL	2,H2WL2A+FR9
	WL	2,H2WL2A+FR10
	WL	2,H2WL2A+FR11
	WL	2+1,H2WL2A+FR12
	WL	2,H2WL2A+FR13
	WL	2,H2WL2A+FR14
	WL	2,H2WL2A+FR15
	WL	2+1,H2WL2A+FR16

	.word	ANI_REPEAT

 SUBR	hrt_walk4_f2_anim

	WL	2,H2WL8A+FR1
	WL	2,H2WL8A+FR2
	WL	2,H2WL8A+FR3
	WL	2+1,H2WL8A+FR4
	WL	2,H2WL8A+FR5
	WL	2,H2WL8A+FR6
	WL	2,H2WL8A+FR7
	WL	2+1,H2WL8A+FR8
	WL	2,H2WL8A+FR9
	WL	2,H2WL8A+FR10
	WL	2,H2WL8A+FR11
	WL	2+1,H2WL8A+FR12
	WL	2,H2WL8A+FR13
	WL	2,H2WL8A+FR14
	WL	2,H2WL8A+FR15
	WL	2+1,H2WL8A+FR16

	.word	ANI_REPEAT

 SUBR	hrt_walk5_f2_anim

	WL	2,H2WL1A+FR16
	WL	2,H2WL1A+FR15
	WL	2,H2WL1A+FR14
	WL	2+1,H2WL1A+FR13
	WL	2,H2WL1A+FR12
	WL	2,H2WL1A+FR11
	WL	2,H2WL1A+FR10
	WL	2+1,H2WL1A+FR9
	WL	2,H2WL1A+FR8
	WL	2,H2WL1A+FR7
	WL	2,H2WL1A+FR6
	WL	2+1,H2WL1A+FR5
	WL	2,H2WL1A+FR4
	WL	2,H2WL1A+FR3
	WL	2,H2WL1A+FR2
	WL	2+1,H2WL1A+FR1

	.word	ANI_REPEAT

 SUBR	hrt_walk6_f2_anim

	WL	2,H2WL2A+FR16
	WL	2,H2WL2A+FR15
	WL	2,H2WL2A+FR14
	WL	2+1,H2WL2A+FR13
	WL	2,H2WL2A+FR12
	WL	2,H2WL2A+FR11
	WL	2,H2WL2A+FR10
	WL	2+1,H2WL2A+FR9
	WL	2,H2WL2A+FR8
	WL	2,H2WL2A+FR7
	WL	2,H2WL2A+FR6
	WL	2+1,H2WL2A+FR5
	WL	2,H2WL2A+FR4
	WL	2,H2WL2A+FR3
	WL	2,H2WL2A+FR2
	WL	2+1,H2WL2A+FR1

	.word	ANI_REPEAT


 SUBR	hrt_walk8_f2_anim

	WL	2,H2WL8A+FR16
	WL	2,H2WL8A+FR15
	WL	2,H2WL8A+FR14
	WL	2+1,H2WL8A+FR13
	WL	2,H2WL8A+FR12
	WL	2,H2WL8A+FR11
	WL	2,H2WL8A+FR10
	WL	2+1,H2WL8A+FR9
	WL	2,H2WL8A+FR8
	WL	2,H2WL8A+FR7
	WL	2,H2WL8A+FR6
	WL	2+1,H2WL8A+FR5
	WL	2,H2WL8A+FR4
	WL	2,H2WL8A+FR3
	WL	2,H2WL8A+FR2
	WL	2+1,H2WL8A+FR1

	.word	ANI_REPEAT



#*****************************************************************************
*
* WALKS FACING #4

 SUBR	hrt_walk1_f4_anim

	WL	2,H4WL5A+FR16
	WL	2,H4WL5A+FR15
	WL	2,H4WL5A+FR14
	WL	2+1,H4WL5A+FR13
	WL	2,H4WL5A+FR12
	WL	2,H4WL5A+FR11
	WL	2,H4WL5A+FR10
	WL	2+1,H4WL5A+FR9
	WL	2,H4WL5A+FR8
	WL	2,H4WL5A+FR7
	WL	2,H4WL5A+FR6
	WL	2+1,H4WL5A+FR5
	WL	2,H4WL5A+FR4
	WL	2,H4WL5A+FR3
	WL	2,H4WL5A+FR2
	WL	2+1,H4WL5A+FR1

	.word	ANI_REPEAT

 SUBR	hrt_walk2_f4_anim

	WL	2,H4WL2A+FR1
	WL	2,H4WL2A+FR2
	WL	2,H4WL2A+FR3
	WL	2+1,H4WL2A+FR4
	WL	2,H4WL2A+FR5
	WL	2,H4WL2A+FR6
	WL	2,H4WL2A+FR7
	WL	2+1,H4WL2A+FR8
	WL	2,H4WL2A+FR9
	WL	2,H4WL2A+FR10
	WL	2,H4WL2A+FR11
	WL	2+1,H4WL2A+FR12
	WL	2,H4WL2A+FR13
	WL	2,H4WL2A+FR14
	WL	2,H4WL2A+FR15

	.word	ANI_REPEAT

 SUBR	hrt_walk4_f4_anim

	WL	2,H4WL4A+FR1
	WL	2,H4WL4A+FR2
	WL	2,H4WL4A+FR3
	WL	2+1,H4WL4A+FR4
	WL	2,H4WL4A+FR5
	WL	2,H4WL4A+FR6
	WL	2,H4WL4A+FR7
	WL	2+1,H4WL4A+FR8
	WL	2,H4WL4A+FR9
	WL	2,H4WL4A+FR10
	WL	2,H4WL4A+FR11
	WL	2+1,H4WL4A+FR12
	WL	2,H4WL4A+FR13
	WL	2,H4WL4A+FR14
	WL	2,H4WL4A+FR15
	WL	2+1,H4WL4A+FR16

	.word	ANI_REPEAT

 SUBR	hrt_walk5_f4_anim

	WL	2,H4WL5A+FR1
	WL	2,H4WL5A+FR2
	WL	2,H4WL5A+FR3
	WL	2+1,H4WL5A+FR4
	WL	2,H4WL5A+FR5
	WL	2,H4WL5A+FR6
	WL	2,H4WL5A+FR7
	WL	2+1,H4WL5A+FR8
	WL	2,H4WL5A+FR9
	WL	2,H4WL5A+FR10
	WL	2,H4WL5A+FR11
	WL	2+1,H4WL5A+FR12
	WL	2,H4WL5A+FR13
	WL	2,H4WL5A+FR14
	WL	2,H4WL5A+FR15
	WL	2+1,H4WL5A+FR16

	.word	ANI_REPEAT

 SUBR	hrt_walk6_f4_anim

	WL	2,H4WL2A+FR15
	WL	2,H4WL2A+FR14
	WL	2,H4WL2A+FR13
	WL	2+1,H4WL2A+FR12
	WL	2,H4WL2A+FR11
	WL	2,H4WL2A+FR10
	WL	2,H4WL2A+FR9
	WL	2+1,H4WL2A+FR8
	WL	2,H4WL2A+FR7
	WL	2,H4WL2A+FR6
	WL	2,H4WL2A+FR5
	WL	2+1,H4WL2A+FR4
	WL	2,H4WL2A+FR3
	WL	2,H4WL2A+FR2
	WL	2,H4WL2A+FR1

	.word	ANI_REPEAT

 SUBR	hrt_walk8_f4_anim

	WL	2+1,H4WL4A+FR9
	WL	2,H4WL4A+FR8
	WL	2,H4WL4A+FR7
	WL	2,H4WL4A+FR6
	WL	2+1,H4WL4A+FR5
	WL	2,H4WL4A+FR4
	WL	2,H4WL4A+FR3
	WL	2,H4WL4A+FR2
	WL	2+1,H4WL4A+FR1

	WL	2,H4WL4A+FR16
	WL	2,H4WL4A+FR15
	WL	2,H4WL4A+FR14
	WL	2+1,H4WL4A+FR13
	WL	2,H4WL4A+FR12
	WL	2,H4WL4A+FR11
	WL	2,H4WL4A+FR10

	.word	ANI_REPEAT


#*****************************************************************************
*
* TURNS (STANDS)

 SUBR	hrt_2_to_4_turn_anim
 SUBR	hrt_8_to_6_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,H1TL5A+FR3	;2.5
	WL	3,H1TL5A+FR4	;3.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_to_2_turn_anim
 SUBR	hrt_6_to_8_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,H1TL5A+FR4	;3.5
	WL	3,H1TL5A+FR3	;2.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_to_6_turn_anim
 SUBR	hrt_6_to_4_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,H1TL5A+FR5	;4.5
	.word	ANI_XFLIP
	WL	3,H1TL5A+FR5	;4.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_2_to_8_turn_anim
 SUBR	hrt_8_to_2_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,H1TL5A+FR2	;1.5
	.word	ANI_XFLIP
	WL	3,H1TL5A+FR2	;1.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_to_8_turn_anim
 SUBR	hrt_6_to_2_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,H1TL5A+FR4	;3.5
	WL	3,H1TL5A+FR3	;2.5
	WL	3,H1TL5A+FR2	;1.5
	.word	ANI_XFLIP
	WL	3,H1TL5A+FR2	;1.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_2_to_6_turn_anim
 SUBR	hrt_8_to_4_turn_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,H1TL5A+FR3	;2.5
	WL	3,H1TL5A+FR4	;3.5
	WL	3,H1TL5A+FR5	;4.5
	.word	ANI_XFLIP
	WL	3,H1TL5A+FR5	;4.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* TURNS (TORSOS)

 SUBR	hrt_2_to_4_turn2_anim
 SUBR	hrt_8_to_6_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,H1TT5A+FR3	;2.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,H1TT5A+FR4	;3.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_to_2_turn2_anim
 SUBR	hrt_6_to_8_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,H1TT5A+FR4	;3.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,H1TT5A+FR3	;2.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_to_6_turn2_anim
 SUBR	hrt_6_to_4_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,H1TT5A+FR5	;4.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,H1TT5A+FR5	;4.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_2_to_8_turn2_anim
 SUBR	hrt_8_to_2_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,H1TT5A+FR2	;1.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,H1TT5A+FR2	;1.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_to_8_turn2_anim
 SUBR	hrt_6_to_2_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,H1TT5A+FR5	;4.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,H1TT5A+FR5	;4.5
	WL	3,H1TT5A+FR4	;3.5
	.word	ANI_SETFACING
	WL	3,H1TT5A+FR3	;2.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_2_to_6_turn2_anim
 SUBR	hrt_8_to_4_turn2_anim
	.word	ANI_SETMODE,MODE_INTURN|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	3,H1TT5A+FR3	;2.5
	.word	ANI_SETFACING
	WL	3,H1TT5A+FR4	;3.5
	WL	3,H1TT5A+FR5	;4.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	3,H1TT5A+FR5	;4.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* RUNNING IN #3

 SUBR	hrt_run2_anim
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

;I'm turning on an attack box for the entire run sequence.
;I never turn it off.

	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,16,71	;mode,x,y,w,h
	WL	ANI_GOTO,#run2

 SUBR	hrt_run_anim

	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,16,71	;mode,x,y,w,h

#lp1
	WL	2,H3RN3A+FR1
	WL	3,H3RN3A+FR2
	WL	2,H3RN3A+FR3
	WL	3,H3RN3A+FR4
	WL	2,H3RN3A+FR5
	WL	ANI_CODE,SMALL_RUN
;	.word	ANI_SOUND,run_snd
#run2
	.word	ANI_SETMODE,MODE_NORMAL		;clear UNINT bit
	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,16,71	;mode,x,y,w,h
	WL	3,H3RN3A+FR6
	WL	2,H3RN3A+FR7
	WL	3,H3RN3A+FR8
	WL	2,H3RN3A+FR9
	WL	3,H3RN3A+FR10
	WL	2,H3RN3A+FR11
	WL	ANI_CODE,SMALL_RUN
;	.word	ANI_SOUND,run_snd
	WL	3,H3RN3A+FR12

	WL	ANI_GOTO,#lp1


#*****************************************************************************
*
* BOUNCE OFF ROPES

 SUBR	hrt_bounce_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_OVERLAP|MODE_NOAUTOFLIP| MODE_NOCONFINE	;uninterruptable

	.ref	fix_bnc_flip
	WL	ANI_CODE,fix_bnc_flip
	WL	ANI_CODE,MAYBE_BOUNCE_ROPE
  
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	2,H3BO3A+FR1
	.word	ANI_BOUNCEROPE,0
	WL	1,H3BO3A+FR1

	WL	2,H3BO3A+FR2
	.word	ANI_BOUNCEROPE,1
	WL	ANI_CODE,SMALL_RUN
;	.word	ANI_SOUND,run_snd

	WL	1,H3BO3A+FR2

	WL	2,H3BO3A+FR3
	.word	ANI_BOUNCEROPE,2
	WL	1,H3BO3A+FR4

	WL	2,H3BO3A+FR4
	.word	ANI_BOUNCEROPE,3
	WL	1,H3BO3A+FR4

	.word	ANI_ZEROVELS

	WL	2,H3BO3A+FR5
	.word	ANI_BOUNCEROPE,4
	WL	1,H3BO3A+FR5
	WL	3,H3BO3A+FR6
	WL	2,H3BO3A+FR7
	.word	ANI_BOUNCEROPE,0
	WL	1,H3BO3A+FR7
	WL	2,H3BO3A+FR8
	.word	ANI_BOUNCEROPE,-1
	WL	ANI_CODE,SMALL_RUN
;	.word	ANI_SOUND,run_snd
	WL	1,H3BO3A+FR8
	WL	3,H3BO3A+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END



******************************************************************************

	.end
