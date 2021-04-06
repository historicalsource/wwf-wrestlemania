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
* Initiated:		5/18/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"yokseq1.asm"
	.title	"Yokozuna animation sequences"
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

	.include	"doinkimg.h"		;temp!!!
	.include	"yokoimg.h"


******************************************************************************
* EXTERNAL REFERENCES

	.ref	SMALL_RUN

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* STANDS

 SUBR	yok_zip_anim
	WL	60*60,Y2ST2Z+FR1
	.word	0	;<--??????
	.word	ANI_END


 SUBR	yok_stand2_anim
 SUBR	yok_stand8_anim
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	WL	5,Y2ST2Z+FR4
	WL	5,Y2ST2Z+FR5
	WL	5,Y2ST2Z+FR6
;	WL	9,Y2ST2Z+FR7
	WL	5,Y2ST2Z+FR6
	WL	5,Y2ST2Z+FR5
	WL	5,Y2ST2Z+FR4
	WL	5,Y2ST2Z+FR3
	WL	5,Y2ST2Z+FR2
;	WL	9,Y2ST2Z+FR1
	WL	5,Y2ST2Z+FR2
	WL	5,Y2ST2Z+FR3

	.word	ANI_REPEAT


 SUBR	yok_stand4_anim
 SUBR	yok_stand6_anim
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	WL	5,Y4ST4Y+FR4
	WL	5,Y4ST4Y+FR5
	WL	5,Y4ST4Y+FR6
;	WL	5,Y4ST4Y+FR7
;	WL	9,Y4ST4Y+FR8
;	WL	5,Y4ST4Y+FR7
	WL	5,Y4ST4Y+FR6
	WL	5,Y4ST4Y+FR5
	WL	5,Y4ST4Y+FR4
	WL	5,Y4ST4Y+FR3
	WL	5,Y4ST4Y+FR2
;	WL	9,Y4ST4Y+FR1
	WL	5,Y4ST4Y+FR2
	WL	5,Y4ST4Y+FR3

	.word	ANI_REPEAT


#*****************************************************************************
*
* WALKING TORSOS

 SUBR	yok_torso2_anim
 SUBR	yok_torso8_anim

	WL	4,Y2TW2X+FR1
	WL	4,Y2TW2X+FR2
	WL	4,Y2TW2X+FR3
	WL	4,Y2TW2X+FR4
	WL	4,Y2TW2X+FR3
	WL	4,Y2TW2X+FR2
	.word	ANI_REPEAT


 SUBR	yok_torso4_anim
 SUBR	yok_torso6_anim

	WL	4,Y4TW4X+FR1
	WL	4,Y4TW4X+FR2
	WL	4,Y4TW4X+FR3
	WL	4,Y4TW4X+FR4
	WL	4,Y4TW4X+FR3
	WL	4,Y4TW4X+FR2
	.word	ANI_REPEAT


#*****************************************************************************
*
* WALKS FACING #2

 SUBR	yok_walk1_f2_anim
	WL	2,Y2WL1A+FR1
	WL	2,Y2WL1A+FR2
	WL	2,Y2WL1A+FR3
	WL	2,Y2WL1A+FR4
	WL	2,Y2WL1A+FR5
	WL	2,Y2WL1A+FR6
	WL	2,Y2WL1A+FR7
	WL	2,Y2WL1A+FR8
	WL	2,Y2WL1A+FR9
	WL	2,Y2WL1A+FR10
	WL	2,Y2WL1A+FR11
	WL	2,Y2WL1A+FR12
	WL	2,Y2WL1A+FR13
	WL	2,Y2WL1A+FR14
	WL	2,Y2WL1A+FR15
	WL	2,Y2WL1A+FR16
	WL	2,Y2WL1A+FR17
	WL	2,Y2WL1A+FR18
	WL	2,Y2WL1A+FR19
	WL	2,Y2WL1A+FR20
	WL	2,Y2WL1A+FR21
	WL	2,Y2WL1A+FR22
	.word	ANI_REPEAT

 SUBR	yok_walk2_f2_anim
	WL	2,Y2WL2Z+FR1
	WL	2,Y2WL2Z+FR2
	WL	2,Y2WL2Z+FR3
	WL	2,Y2WL2Z+FR4
	WL	2,Y2WL2Z+FR5
	WL	2,Y2WL2Z+FR6
	WL	2,Y2WL2Z+FR7
	WL	2,Y2WL2Z+FR8
	WL	2,Y2WL2Z+FR9
	WL	2,Y2WL2Z+FR10
	WL	2,Y2WL2Z+FR11
	WL	2,Y2WL2Z+FR12
	WL	2,Y2WL2Z+FR13
	WL	2,Y2WL2Z+FR14
	WL	2,Y2WL2Z+FR15
	WL	2,Y2WL2Z+FR16
	WL	2,Y2WL2Z+FR17
	WL	2,Y2WL2Z+FR18
	WL	2,Y2WL2Z+FR19
	WL	2,Y2WL2Z+FR20
	.word	ANI_REPEAT

 SUBR	yok_walk4_f2_anim
	WL	2,Y2WL8C+FR1
	WL	2,Y2WL8C+FR2
	WL	2,Y2WL8C+FR3
	WL	2,Y2WL8C+FR4
	WL	2,Y2WL8C+FR5
	WL	2,Y2WL8C+FR6
	WL	2,Y2WL8C+FR7
	WL	2,Y2WL8C+FR8
	WL	2,Y2WL8C+FR9
	WL	2,Y2WL8C+FR10
	WL	2,Y2WL8C+FR11
	WL	2,Y2WL8C+FR12
	WL	2,Y2WL8C+FR13
	WL	2,Y2WL8C+FR14
	WL	2,Y2WL8C+FR15
	WL	2,Y2WL8C+FR16
	WL	2,Y2WL8C+FR17
	WL	2,Y2WL8C+FR18
	WL	2,Y2WL8C+FR19
	WL	2,Y2WL8C+FR20
	WL	2,Y2WL8C+FR21
	WL	2,Y2WL8C+FR22
	.word	ANI_REPEAT

 SUBR	yok_walk5_f2_anim
	WL	2,Y2WL1A+FR22
	WL	2,Y2WL1A+FR21
	WL	2,Y2WL1A+FR20
	WL	2,Y2WL1A+FR19
	WL	2,Y2WL1A+FR18
	WL	2,Y2WL1A+FR17
	WL	2,Y2WL1A+FR16
	WL	2,Y2WL1A+FR15
	WL	2,Y2WL1A+FR14
	WL	2,Y2WL1A+FR13
	WL	2,Y2WL1A+FR12
	WL	2,Y2WL1A+FR11
	WL	2,Y2WL1A+FR10
	WL	2,Y2WL1A+FR9
	WL	2,Y2WL1A+FR8
	WL	2,Y2WL1A+FR7
	WL	2,Y2WL1A+FR6
	WL	2,Y2WL1A+FR5
	WL	2,Y2WL1A+FR4
	WL	2,Y2WL1A+FR3
	WL	2,Y2WL1A+FR2
	WL	2,Y2WL1A+FR1
	.word	ANI_REPEAT

 SUBR	yok_walk6_f2_anim
	WL	2,Y2WL2Z+FR20
	WL	2,Y2WL2Z+FR19
	WL	2,Y2WL2Z+FR18
	WL	2,Y2WL2Z+FR17
	WL	2,Y2WL2Z+FR16
	WL	2,Y2WL2Z+FR15
	WL	2,Y2WL2Z+FR14
	WL	2,Y2WL2Z+FR13
	WL	2,Y2WL2Z+FR12
	WL	2,Y2WL2Z+FR11
	WL	2,Y2WL2Z+FR10
	WL	2,Y2WL2Z+FR9
	WL	2,Y2WL2Z+FR8
	WL	2,Y2WL2Z+FR7
	WL	2,Y2WL2Z+FR6
	WL	2,Y2WL2Z+FR5
	WL	2,Y2WL2Z+FR4
	WL	2,Y2WL2Z+FR3
	WL	2,Y2WL2Z+FR2
	WL	2,Y2WL2Z+FR1
	.word	ANI_REPEAT


 SUBR	yok_walk8_f2_anim
	WL	2,Y2WL8C+FR22
	WL	2,Y2WL8C+FR21
	WL	2,Y2WL8C+FR20
	WL	2,Y2WL8C+FR19
	WL	2,Y2WL8C+FR18
	WL	2,Y2WL8C+FR17
	WL	2,Y2WL8C+FR16
	WL	2,Y2WL8C+FR15
	WL	2,Y2WL8C+FR14
	WL	2,Y2WL8C+FR13
	WL	2,Y2WL8C+FR12
	WL	2,Y2WL8C+FR11
	WL	2,Y2WL8C+FR10
	WL	2,Y2WL8C+FR9
	WL	2,Y2WL8C+FR8
	WL	2,Y2WL8C+FR7
	WL	2,Y2WL8C+FR6
	WL	2,Y2WL8C+FR5
	WL	2,Y2WL8C+FR4
	WL	2,Y2WL8C+FR3
	WL	2,Y2WL8C+FR2
	WL	2,Y2WL8C+FR1
	.word	ANI_REPEAT



#*****************************************************************************
*
* WALKS FACING #4

 SUBR	yok_walk1_f4_anim
	WL	2,Y4WL5A+FR24
	WL	2,Y4WL5A+FR23
	WL	2,Y4WL5A+FR22
	WL	2,Y4WL5A+FR21
	WL	2,Y4WL5A+FR20
	WL	2,Y4WL5A+FR19
	WL	2,Y4WL5A+FR18
	WL	2,Y4WL5A+FR17
	WL	2,Y4WL5A+FR16
	WL	2,Y4WL5A+FR15
	WL	2,Y4WL5A+FR14
	WL	2,Y4WL5A+FR13
	WL	2,Y4WL5A+FR12
	WL	2,Y4WL5A+FR11
	WL	2,Y4WL5A+FR10
	WL	2,Y4WL5A+FR9
	WL	2,Y4WL5A+FR8
	WL	2,Y4WL5A+FR7
	WL	2,Y4WL5A+FR6
	WL	2,Y4WL5A+FR5
	WL	2,Y4WL5A+FR4
	WL	2,Y4WL5A+FR3
	WL	2,Y4WL5A+FR2
	WL	2,Y4WL5A+FR1
	.word	ANI_REPEAT

 SUBR	yok_walk2_f4_anim
	WL	2,Y4WL2C+FR1
	WL	2,Y4WL2C+FR2
	WL	2,Y4WL2C+FR3
	WL	2,Y4WL2C+FR4
	WL	2,Y4WL2C+FR5
	WL	2,Y4WL2C+FR6
	WL	2,Y4WL2C+FR7
	WL	2,Y4WL2C+FR8
	WL	2,Y4WL2C+FR9
	WL	2,Y4WL2C+FR10
	WL	2,Y4WL2C+FR11
	WL	2,Y4WL2C+FR12
	WL	2,Y4WL2C+FR13
	WL	2,Y4WL2C+FR14
	WL	2,Y4WL2C+FR15
	WL	2,Y4WL2C+FR16
	WL	2,Y4WL2C+FR17
	WL	2,Y4WL2C+FR18
	WL	2,Y4WL2C+FR19
	WL	2,Y4WL2C+FR20
	.word	ANI_REPEAT

 SUBR	yok_walk4_f4_anim
	WL	2,Y4WL4B+FR1
	WL	2,Y4WL4B+FR2
	WL	2,Y4WL4B+FR3
	WL	2,Y4WL4B+FR4
	WL	2,Y4WL4B+FR5
	WL	2,Y4WL4B+FR6
	WL	2,Y4WL4B+FR7
	WL	2,Y4WL4B+FR8
	WL	2,Y4WL4B+FR9
	WL	2,Y4WL4B+FR10
	WL	2,Y4WL4B+FR11
	WL	2,Y4WL4B+FR12
	WL	2,Y4WL4B+FR13
	WL	2,Y4WL4B+FR14
	WL	2,Y4WL4B+FR15
	WL	2,Y4WL4B+FR16
	WL	2,Y4WL4B+FR17
	WL	2,Y4WL4B+FR18
	WL	2,Y4WL4B+FR19
	WL	2,Y4WL4B+FR20
	WL	2,Y4WL4B+FR21
	WL	2,Y4WL4B+FR22
	WL	2,Y4WL4B+FR23
	WL	2,Y4WL4B+FR24
	.word	ANI_REPEAT

 SUBR	yok_walk5_f4_anim
	WL	2,Y4WL5A+FR1
	WL	2,Y4WL5A+FR2
	WL	2,Y4WL5A+FR3
	WL	2,Y4WL5A+FR4
	WL	2,Y4WL5A+FR5
	WL	2,Y4WL5A+FR6
	WL	2,Y4WL5A+FR7
	WL	2,Y4WL5A+FR8
	WL	2,Y4WL5A+FR9
	WL	2,Y4WL5A+FR10
	WL	2,Y4WL5A+FR11
	WL	2,Y4WL5A+FR12
	WL	2,Y4WL5A+FR13
	WL	2,Y4WL5A+FR14
	WL	2,Y4WL5A+FR15
	WL	2,Y4WL5A+FR16
	WL	2,Y4WL5A+FR17
	WL	2,Y4WL5A+FR18
	WL	2,Y4WL5A+FR19
	WL	2,Y4WL5A+FR20
	WL	2,Y4WL5A+FR21
	WL	2,Y4WL5A+FR22
	WL	2,Y4WL5A+FR23
	WL	2,Y4WL5A+FR24
	.word	ANI_REPEAT

 SUBR	yok_walk6_f4_anim
	WL	2,Y4WL2C+FR20
	WL	2,Y4WL2C+FR19
	WL	2,Y4WL2C+FR18
	WL	2,Y4WL2C+FR17
	WL	2,Y4WL2C+FR16
	WL	2,Y4WL2C+FR15
	WL	2,Y4WL2C+FR14
	WL	2,Y4WL2C+FR13
	WL	2,Y4WL2C+FR12
	WL	2,Y4WL2C+FR11
	WL	2,Y4WL2C+FR10
	WL	2,Y4WL2C+FR9
	WL	2,Y4WL2C+FR8
	WL	2,Y4WL2C+FR7
	WL	2,Y4WL2C+FR6
	WL	2,Y4WL2C+FR5
	WL	2,Y4WL2C+FR4
	WL	2,Y4WL2C+FR3
	WL	2,Y4WL2C+FR2
	WL	2,Y4WL2C+FR1
	.word	ANI_REPEAT

 SUBR	yok_walk8_f4_anim
	WL	2,Y4WL4B+FR24
	WL	2,Y4WL4B+FR23
	WL	2,Y4WL4B+FR22
	WL	2,Y4WL4B+FR21
	WL	2,Y4WL4B+FR20
	WL	2,Y4WL4B+FR19
	WL	2,Y4WL4B+FR18
	WL	2,Y4WL4B+FR17
	WL	2,Y4WL4B+FR16
	WL	2,Y4WL4B+FR15
	WL	2,Y4WL4B+FR14
	WL	2,Y4WL4B+FR13
	WL	2,Y4WL4B+FR12
	WL	2,Y4WL4B+FR11
	WL	2,Y4WL4B+FR10
	WL	2,Y4WL4B+FR9
	WL	2,Y4WL4B+FR8
	WL	2,Y4WL4B+FR7
	WL	2,Y4WL4B+FR6
	WL	2,Y4WL4B+FR5
	WL	2,Y4WL4B+FR4
	WL	2,Y4WL4B+FR3
	WL	2,Y4WL4B+FR2
	WL	2,Y4WL4B+FR1
	.word	ANI_REPEAT

#*****************************************************************************
*
* TURNS (STANDS)

 SUBR	yok_2_to_4_turn_anim
 SUBR	yok_8_to_6_turn_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,Y1TT5Z+FR2
	WL	1,Y1TT5Z+FR3
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	yok_4_to_2_turn_anim
 SUBR	yok_6_to_8_turn_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,Y1TT5Z+FR3
	WL	1,Y1TT5Z+FR2
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	yok_4_to_6_turn_anim
 SUBR	yok_6_to_4_turn_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,Y1TT5Z+FR4
	.word	ANI_XFLIP
	WL	1,Y1TT5Z+FR4
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	yok_2_to_8_turn_anim
 SUBR	yok_8_to_2_turn_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,Y1TT5Z+FR1
	.word	ANI_XFLIP
	WL	1,Y1TT5Z+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	yok_4_to_8_turn_anim
 SUBR	yok_6_to_2_turn_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,Y1TT5Z+FR3
	WL	1,Y1TT5Z+FR2
	WL	1,Y1TT5Z+FR1
	.word	ANI_XFLIP
	WL	1,Y1TT5Z+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	yok_2_to_6_turn_anim
 SUBR	yok_8_to_4_turn_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,Y1TT5Z+FR2
	WL	1,Y1TT5Z+FR3
	WL	1,Y1TT5Z+FR4
	.word	ANI_XFLIP
	WL	1,Y1TT5Z+FR4
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* TURNS (TORSOS)


 SUBR	yok_2_to_4_turn2_anim
 SUBR	yok_8_to_6_turn2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,Y1TR5Z+FR4
	.word	ANI_SETFACING
	WL	1,Y1TR5Z+FR5
	WL	1,Y1TR5Z+FR6
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	yok_4_to_2_turn2_anim
 SUBR	yok_6_to_8_turn2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,Y1TR5Z+FR6
	.word	ANI_SETFACING
	WL	1,Y1TR5Z+FR5
	WL	1,Y1TR5Z+FR4
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	yok_4_to_6_turn2_anim
 SUBR	yok_6_to_4_turn2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,Y1TR5Z+FR9
	.word	ANI_SETFACING
	WL	1,Y1TR5Z+FR9
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	yok_2_to_8_turn2_anim
 SUBR	yok_8_to_2_turn2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,Y1TR5Z+FR1
	.word	ANI_SETFACING
	WL	1,Y1TR5Z+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	yok_4_to_8_turn2_anim
 SUBR	yok_6_to_2_turn2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,Y1TR5Z+FR9
	.word	ANI_SETFACING
	WL	1,Y1TR5Z+FR9
	WL	1,Y1TR5Z+FR8
	WL	1,Y1TR5Z+FR6
	.word	ANI_SETFACING
	WL	1,Y1TR5Z+FR5
	WL	1,Y1TR5Z+FR4
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	yok_2_to_6_turn2_anim
 SUBR	yok_8_to_4_turn2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	WL	1,Y1TR5Z+FR4
	.word	ANI_SETFACING
	WL	1,Y1TR5Z+FR5
	WL	1,Y1TR5Z+FR6
	WL	1,Y1TR5Z+FR8
	WL	1,Y1TR5Z+FR9
	.word	ANI_SETFACING
	WL	1,Y1TR5Z+FR9
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* RUNNING IN #3

;Jason, put in the correct (more angled) bounce off of ropes for Yoko.
;Also, make run better!  Longer strides?  Shake screen?  Animate slower?

 SUBR	yok_run2_anim
  
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

;I'm turning on an attack box for the entire run sequence.
;I never turn it off.

	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,18h,71	;mode,x,y,w,h
	WL	ANI_GOTO,#run2

 SUBR	yok_run_anim

	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,18h,71	;mode,x,y,w,h

#lp1
	WL	3,Y3RN3C+FR1
	WL	3,Y3RN3C+FR2
	WL	3,Y3RN3C+FR3
	WL	3,Y3RN3C+FR4
	WL	3,Y3RN3C+FR5

	WL	ANI_CODE,SMALL_RUN
	WL	ANI_SET_YVEL,14000h
	.word	ANI_SHAKER,8
#run2
	.word	ANI_SETMODE,MODE_NORMAL		;clear UNINT bit
	.word	ANI_ATTACK_ON,AMODE_RUN,-3,29,18h,71	;mode,x,y,w,h
	WL	3,Y3RN3C+FR6
	WL	3,Y3RN3C+FR7
	WL	3,Y3RN3C+FR8
	WL	3,Y3RN3C+FR9
	WL	3,Y3RN3C+FR10
	WL	3,Y3RN3C+FR11

	WL	ANI_CODE,SMALL_RUN
	WL	ANI_SET_YVEL,14000h
	.word	ANI_SHAKER,8

	WL	3,Y3RN3C+FR12
	WL	ANI_GOTO,#lp1


#*****************************************************************************
*
* BOUNCE OFF ROPES

 SUBR	yok_bounce_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_OVERLAP+MODE_NOAUTOFLIP| MODE_NOCONFINE	;uninterruptable

	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	3,Y3BO3C+FR1

	WL	2,Y3BO3C+FR2
	.word	ANI_BOUNCEROPE,0
	WL	ANI_CODE,SMALL_RUN
	WL	1,Y3BO3C+FR2

	.word	ANI_SHAKER,10

	WL	2,Y3BO3C+FR3
	.word	ANI_BOUNCEROPE,1
	WL	1,Y3BO3C+FR3

	WL	3,Y3BO3C+FR4
	.word	ANI_BOUNCEROPE,2
	WL	1,Y3BO3C+FR4

	.word	ANI_ZEROVELS

	WL	4,Y3BO3C+FR5
	.word	ANI_BOUNCEROPE,3
	WL	1,Y3BO3C+FR5
	WL	5,Y3BO3C+FR6
	.word	ANI_BOUNCEROPE,4
	WL	1,Y3BO3C+FR6
	WL	3,Y3BO3C+FR7
	.word	ANI_BOUNCEROPE,0
	WL	1,Y3BO3C+FR7
	WL	2,Y3BO3C+FR8
	.word	ANI_BOUNCEROPE,-1
	.word	ANI_SHAKER,10

	WL	ANI_CODE,SMALL_RUN
	WL	1,Y3BO3C+FR8
	WL	3,Y3BO3C+FR9
	WL	3,Y3BO3C+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************

 SUBR	yok_frnk_recover_anim
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	WL	4,Y1TT5Z+FR3
	WL	ANI_CHANGEANIM,yok_stand4_anim

******************************************************************************
	.end
