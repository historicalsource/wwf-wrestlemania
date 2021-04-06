*************************
*
* WE NEED TO INSERT THIS AT THE BEGINNING
*
* OF EACH 'ATTACK' SEQUENCE
*
* EQUATES ARE DEFINED IN DAMAGE.EQU
*
*
*	.word	ANI_STARTATTACK,AT_PUNCH,8	;type, #ticks 'til attack on
*
*
*
*************************



**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		10/12/93
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"dnkseq1.asm"
	.title	"Krusty the Clown animation sequences"
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
	.include	"doinkimg.h"


******************************************************************************
* EXTERNAL REFERENCES

	.REF	SMALL_RUN

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

TSEC 	equ	53

#*****************************************************************************
*
* STANDS

 SUBR	dnk_zip_anim
	WL	TSEC*60,D2ST2B+FR3
	.word	ANI_END

 SUBR	dnk_stand2_anim
 SUBR	dnk_stand8_anim
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	WL	6,D2ST2B+FR3
	WL	6,D2ST2B+FR4
	WL	6,D2ST2B+FR5
	WL	6,D2ST2B+FR6
	WL	6,D2ST2B+FR5
	WL	6,D2ST2B+FR4
	.word	ANI_REPEAT

 SUBR	dnk_stand4_anim
 SUBR	dnk_stand6_anim
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	WL	6,D4ST4E+FR3
	WL	6,D4ST4E+FR4
	WL	6,D4ST4E+FR5
	WL	6,D4ST4E+FR6
	WL	6,D4ST4E+FR5
	WL	6,D4ST4E+FR4
	.word	ANI_REPEAT

#*****************************************************************************
*
* WALKING TORSOS


 SUBR	dnk_torso2_anim
 SUBR	dnk_torso8_anim
	WL	4,D2TW2B+FR1
	WL	4,D2TW2B+FR2
	WL	4,D2TW2B+FR3
	WL	4,D2TW2B+FR4
	WL	4,D2TW2B+FR3
	WL	4,D2TW2B+FR2
	.word	ANI_REPEAT



 SUBR	dnk_torso4_anim
 SUBR	dnk_torso6_anim
	WL	4,D4TW4B+FR1
	WL	4,D4TW4B+FR2
	WL	4,D4TW4B+FR3
	WL	4,D4TW4B+FR4
	WL	4,D4TW4B+FR3
	WL	4,D4TW4B+FR2
	.word	ANI_REPEAT

 SUBR	dnk_holdoh_anim
	WL	999,D4TH4A+FR1
	.word	ANI_REPEAT


#*****************************************************************************
*
* WALKS FACING #2

 SUBR	dnk_walk1_f2_anim
	WL	2,D2WL1A+FR1
	WL	2,D2WL1A+FR2
	WL	2,D2WL1A+FR3
	WL	2,D2WL1A+FR4
	WL	2,D2WL1A+FR5
	WL	2,D2WL1A+FR6
	WL	2,D2WL1A+FR7
	WL	2,D2WL1A+FR8
	WL	2,D2WL1A+FR9
	WL	2,D2WL1A+FR10
	WL	2,D2WL1A+FR11
	WL	2,D2WL1A+FR12
	WL	2,D2WL1A+FR13
	WL	2,D2WL1A+FR14
	WL	2,D2WL1A+FR15
	WL	2,D2WL1A+FR16
	WL	2,D2WL1A+FR17
	WL	2,D2WL1A+FR18
	.word	ANI_REPEAT

 SUBR	dnk_walk2_f2_anim
	WL	2,D2WL2A+FR1
	WL	2,D2WL2A+FR2
	WL	2,D2WL2A+FR3
	WL	2,D2WL2A+FR4
	WL	2,D2WL2A+FR5
	WL	2,D2WL2A+FR6
	WL	2,D2WL2A+FR7
	WL	2,D2WL2A+FR8
	WL	2,D2WL2A+FR9
	WL	2,D2WL2A+FR10
	WL	2,D2WL2A+FR11
	WL	2,D2WL2A+FR12
	WL	2,D2WL2A+FR13
	WL	2,D2WL2A+FR14
	WL	2,D2WL2A+FR15
	WL	2,D2WL2A+FR16
	WL	2,D2WL2A+FR17
	.word	ANI_REPEAT

 SUBR	dnk_walk4_f2_anim
	WL	2,D2WL4B+FR1
	WL	2,D2WL4B+FR2
	WL	2,D2WL4B+FR3
	WL	2,D2WL4B+FR4
	WL	2,D2WL4B+FR5
	WL	2,D2WL4B+FR6
	WL	2,D2WL4B+FR7
	WL	2,D2WL4B+FR8
	WL	2,D2WL4B+FR9
	WL	2,D2WL4B+FR10
	WL	2,D2WL4B+FR11
	WL	2,D2WL4B+FR12
	WL	2,D2WL4B+FR13
	WL	2,D2WL4B+FR14
	WL	2,D2WL4B+FR15
	WL	2,D2WL4B+FR16
	WL	2,D2WL4B+FR17
	WL	2,D2WL4B+FR18
	.word	ANI_REPEAT

 SUBR	dnk_walk5_f2_anim
	WL	2,D2WL1A+FR18
	WL	2,D2WL1A+FR17
	WL	2,D2WL1A+FR16
	WL	2,D2WL1A+FR15
	WL	2,D2WL1A+FR14
	WL	2,D2WL1A+FR13
	WL	2,D2WL1A+FR12
	WL	2,D2WL1A+FR11
	WL	2,D2WL1A+FR10
	WL	2,D2WL1A+FR9
	WL	2,D2WL1A+FR8
	WL	2,D2WL1A+FR7
	WL	2,D2WL1A+FR6
	WL	2,D2WL1A+FR5
	WL	2,D2WL1A+FR4
	WL	2,D2WL1A+FR3
	WL	2,D2WL1A+FR2
	WL	2,D2WL1A+FR1
	.word	ANI_REPEAT

 SUBR	dnk_walk6_f2_anim
	WL	2,D2WL2A+FR17
	WL	2,D2WL2A+FR16
	WL	2,D2WL2A+FR15
	WL	2,D2WL2A+FR14
	WL	2,D2WL2A+FR13
	WL	2,D2WL2A+FR12
	WL	2,D2WL2A+FR11
	WL	2,D2WL2A+FR10
	WL	2,D2WL2A+FR9
	WL	2,D2WL2A+FR8
	WL	2,D2WL2A+FR7
	WL	2,D2WL2A+FR6
	WL	2,D2WL2A+FR5
	WL	2,D2WL2A+FR4
	WL	2,D2WL2A+FR3
	WL	2,D2WL2A+FR2
	WL	2,D2WL2A+FR1
	.word	ANI_REPEAT


 SUBR	dnk_walk8_f2_anim
	WL	2,D2WL4B+FR18
	WL	2,D2WL4B+FR17
	WL	2,D2WL4B+FR16
	WL	2,D2WL4B+FR15
	WL	2,D2WL4B+FR14
	WL	2,D2WL4B+FR13
	WL	2,D2WL4B+FR12
	WL	2,D2WL4B+FR11
	WL	2,D2WL4B+FR10
	WL	2,D2WL4B+FR9
	WL	2,D2WL4B+FR8
	WL	2,D2WL4B+FR7
	WL	2,D2WL4B+FR6
	WL	2,D2WL4B+FR5
	WL	2,D2WL4B+FR4
	WL	2,D2WL4B+FR3
	WL	2,D2WL4B+FR2
	WL	2,D2WL4B+FR1
	.word	ANI_REPEAT



#*****************************************************************************
*
* WALKS FACING #4

 SUBR	dnk_walk1_f4_anim
	WL	2,D4WL5A+FR18
	WL	2,D4WL5A+FR17
	WL	2,D4WL5A+FR16
	WL	2,D4WL5A+FR15
	WL	2,D4WL5A+FR14
	WL	2,D4WL5A+FR13
	WL	2,D4WL5A+FR12
	WL	2,D4WL5A+FR11
	WL	2,D4WL5A+FR10
	WL	2,D4WL5A+FR9
	WL	2,D4WL5A+FR8
	WL	2,D4WL5A+FR7
	WL	2,D4WL5A+FR6
	WL	2,D4WL5A+FR5
	WL	2,D4WL5A+FR4
	WL	2,D4WL5A+FR3
	WL	2,D4WL5A+FR2
	WL	2,D4WL5A+FR1
	.word	ANI_REPEAT

 SUBR	dnk_walk2_f4_anim
	WL	2,D4WL2A+FR1
	WL	2,D4WL2A+FR2
	WL	2,D4WL2A+FR3
	WL	2,D4WL2A+FR4
	WL	2,D4WL2A+FR5
	WL	2,D4WL2A+FR6
	WL	2,D4WL2A+FR7
	WL	2,D4WL2A+FR8
	WL	2,D4WL2A+FR9
	WL	2,D4WL2A+FR10
	WL	2,D4WL2A+FR11
	WL	2,D4WL2A+FR12
	WL	2,D4WL2A+FR13
	WL	2,D4WL2A+FR14
	WL	2,D4WL2A+FR15
	WL	2,D4WL2A+FR16
	WL	2,D4WL2A+FR17
	WL	2,D4WL2A+FR18
	.word	ANI_REPEAT

 SUBR	dnk_walk4_f4_anim
	WL	2,D4WL4A+FR1
	WL	2,D4WL4A+FR2
	WL	2,D4WL4A+FR3
	WL	2,D4WL4A+FR4
	WL	2,D4WL4A+FR5
	WL	2,D4WL4A+FR6
	WL	2,D4WL4A+FR7
	WL	2,D4WL4A+FR8
	WL	2,D4WL4A+FR9
	WL	2,D4WL4A+FR10
	WL	2,D4WL4A+FR11
	WL	2,D4WL4A+FR12
	WL	2,D4WL4A+FR13
	WL	2,D4WL4A+FR14
	WL	2,D4WL4A+FR15
	WL	2,D4WL4A+FR16
	WL	2,D4WL4A+FR17
	WL	2,D4WL4A+FR18
	.word	ANI_REPEAT

 SUBR	dnk_walk5_f4_anim
	WL	2,D4WL5A+FR1
	WL	2,D4WL5A+FR2
	WL	2,D4WL5A+FR3
	WL	2,D4WL5A+FR4
	WL	2,D4WL5A+FR5
	WL	2,D4WL5A+FR6
	WL	2,D4WL5A+FR7
	WL	2,D4WL5A+FR8
	WL	2,D4WL5A+FR9
	WL	2,D4WL5A+FR10
	WL	2,D4WL5A+FR11
	WL	2,D4WL5A+FR12
	WL	2,D4WL5A+FR13
	WL	2,D4WL5A+FR14
	WL	2,D4WL5A+FR15
	WL	2,D4WL5A+FR16
	WL	2,D4WL5A+FR17
	WL	2,D4WL5A+FR18
	.word	ANI_REPEAT

 SUBR	dnk_walk6_f4_anim
	WL	2,D4WL2A+FR18
	WL	2,D4WL2A+FR17
	WL	2,D4WL2A+FR16
	WL	2,D4WL2A+FR15
	WL	2,D4WL2A+FR14
	WL	2,D4WL2A+FR13
	WL	2,D4WL2A+FR12
	WL	2,D4WL2A+FR11
	WL	2,D4WL2A+FR10
	WL	2,D4WL2A+FR9
	WL	2,D4WL2A+FR8
	WL	2,D4WL2A+FR7
	WL	2,D4WL2A+FR6
	WL	2,D4WL2A+FR5
	WL	2,D4WL2A+FR4
	WL	2,D4WL2A+FR3
	WL	2,D4WL2A+FR2
	WL	2,D4WL2A+FR1
	.word	ANI_REPEAT

 SUBR	dnk_walk8_f4_anim
	WL	2,D4WL4A+FR18
	WL	2,D4WL4A+FR17
	WL	2,D4WL4A+FR16
	WL	2,D4WL4A+FR15
	WL	2,D4WL4A+FR14
	WL	2,D4WL4A+FR13
	WL	2,D4WL4A+FR12
	WL	2,D4WL4A+FR11
	WL	2,D4WL4A+FR10
	WL	2,D4WL4A+FR9
	WL	2,D4WL4A+FR8
	WL	2,D4WL4A+FR7
	WL	2,D4WL4A+FR6
	WL	2,D4WL4A+FR5
	WL	2,D4WL4A+FR4
	WL	2,D4WL4A+FR3
	WL	2,D4WL4A+FR2
	WL	2,D4WL4A+FR1
	.word	ANI_REPEAT


;2 TICKS = 1
#*****************************************************************************
*
* TURNS (STANDS)

 SUBR	dnk_2_to_4_turn_anim
 SUBR	dnk_8_to_6_turn_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,D1TT5Z+FR2	;2.5
	WL	1,D1TT5Z+FR3	;3.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	dnk_4_to_2_turn_anim
 SUBR	dnk_6_to_8_turn_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,D1TT5Z+FR3	;3.5
	WL	1,D1TT5Z+FR2	;2.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	dnk_4_to_6_turn_anim
 SUBR	dnk_6_to_4_turn_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,D1TT5Z+FR4	;4.5
	.word	ANI_XFLIP
	WL	1,D1TT5Z+FR4	;4.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	dnk_2_to_8_turn_anim
 SUBR	dnk_8_to_2_turn_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,D1TT5Z+FR1	;1.5
	.word	ANI_XFLIP
	WL	1,D1TT5Z+FR1	;1.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	dnk_4_to_8_turn_anim
 SUBR	dnk_6_to_2_turn_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,D1TT5Z+FR3	;3.5
	WL	1,D1TT5Z+FR2	;2.5
	WL	1,D1TT5Z+FR1	;1.5
	.word	ANI_XFLIP
	WL	1,D1TT5Z+FR1	;1.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	dnk_2_to_6_turn_anim
 SUBR	dnk_8_to_4_turn_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,D1TT5Z+FR2	;2.5
	WL	1,D1TT5Z+FR3	;3.5
	WL	1,D1TT5Z+FR4	;4.5
	.word	ANI_XFLIP
	WL	1,D1TT5Z+FR4	;4.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* TURNS (TORSOS)

 SUBR	dnk_2_to_4_turn2_anim
 SUBR	dnk_8_to_6_turn2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,D1TR5Z+FR2	;2.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	1,D1TR5Z+FR3	;3.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	dnk_4_to_2_turn2_anim
 SUBR	dnk_6_to_8_turn2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,D1TR5Z+FR3	;3.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	1,D1TR5Z+FR2	;2.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	dnk_4_to_6_turn2_anim
 SUBR	dnk_6_to_4_turn2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,D1TR5Z+FR4	;4.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	1,D1TR5Z+FR4	;4.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	dnk_2_to_8_turn2_anim
 SUBR	dnk_8_to_2_turn2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,D1TR5Z+FR1	;1.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	1,D1TR5Z+FR1	;1.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	dnk_4_to_8_turn2_anim
 SUBR	dnk_6_to_2_turn2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,D1TR5Z+FR4	;4.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	1,D1TR5Z+FR4	;4.5
	WL	1,D1TR5Z+FR3	;3.5
	.word	ANI_SETFACING
	WL	1,D1TR5Z+FR2	;2.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	dnk_2_to_6_turn2_anim
 SUBR	dnk_8_to_4_turn2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,D1TR5Z+FR2	;2.5
	.word	ANI_SETFACING
	WL	1,D1TR5Z+FR3	;3.5
	WL	1,D1TR5Z+FR4	;4.5
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	1,D1TR5Z+FR4	;4.5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* RUNNING IN #3

 SUBR	dnk_run2_anim

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

;I'm turning on an attack box for the entire run sequence.
;I never turn it off.

	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,16,71	;mode,x,y,w,h
	WL	ANI_GOTO,#run2

 SUBR	dnk_run_anim

	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,16,71	;mode,x,y,w,h

#lp1
	WL	1,D3RN3B+FR1
;	.word	ANI_SOUND,run_snd
	WL	ANI_CODE,SMALL_RUN
	WL	1,D3RN3B+FR1
	WL	3,D3RN3B+FR2
	WL	2,D3RN3B+FR3
	WL	3,D3RN3B+FR4
	WL	2,D3RN3B+FR5
#run2
	.word	ANI_SETMODE,MODE_NORMAL		;clear UNINT bit
	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,16,71	;mode,x,y,w,h
	WL	2,D3RN3B+FR6
;	.word	ANI_SOUND,run_snd
	WL	ANI_CODE,SMALL_RUN
	WL	1,D3RN3B+FR6
	WL	2,D3RN3B+FR7
	WL	3,D3RN3B+FR8
	WL	2,D3RN3B+FR9
	WL	3,D3RN3B+FR10
	WL	2,D3RN3B+FR11

	WL	ANI_GOTO,#lp1

#*****************************************************************************
*
* BOUNCE OFF ROPES

 SUBR	dnk_bounce_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_OVERLAP+MODE_NOAUTOFLIP| MODE_NOCONFINE	;uninterruptable

	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	2,D3BO3B+FR2
	.word	ANI_BOUNCEROPE,0
	WL	1,D3BO3B+FR2

	WL	2,D3BO3B+FR3
	.word	ANI_BOUNCEROPE,1
	WL	ANI_CODE,SMALL_RUN
;	.word	ANI_SOUND,run_snd

	WL	1,D3BO3B+FR3

	WL	2,D3BO3B+FR4
	.word	ANI_BOUNCEROPE,2
	WL	1,D3BO3B+FR4

	WL	2,D3BO3B+FR5
	.word	ANI_BOUNCEROPE,3
	WL	1,D3BO3B+FR5

	.word	ANI_ZEROVELS

	WL	2,D3BO3B+FR6
	.word	ANI_BOUNCEROPE,4
	WL	1,D3BO3B+FR6
	WL	3,D3BO3B+FR7
	WL	2,D3BO3B+FR8
	.word	ANI_BOUNCEROPE,0
	WL	1,D3BO3B+FR8
	WL	2,D3BO3B+FR9
	.word	ANI_BOUNCEROPE,-1
	WL	ANI_CODE,SMALL_RUN
;	.word	ANI_SOUND,run_snd
	WL	1,D3BO3B+FR9
	WL	3,D3BO3B+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


******************************************************************************
	.end
