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
* Initiated:		11/28/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"undseq4.asm"
	.title	"Undertaker animation sequences"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"macros.h"
	.include	"mproc.equ"
	.include	"sys.equ"
	.include	"game.equ"
	.include	"plyr.equ"
	.include	"anim.equ"
	.include	"sound.h"

	.include	"takerimg.h"
	.include	"damage.equ"


******************************************************************************
* EXTERNAL REFERENCES

	.REF	HIT_THE_MAT,SMALL_BOUNCE
	.REF	CALL_MISSES
 	.ref	am_I_dizzy
	.ref	am_I_dead
	.ref	ckzpos
	.ref	ck_dizzy
	.ref	start_run_anim
	.ref	und_getup_anim

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* GENERIC BOUNCE

 SUBR	und_slambounce_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_FACE,MOVE_LEFT|MOVE_UP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_DEBRIS,100,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	WL	1,U3CP3B+FR2
	WL	ANI_SET_YVEL,040000h
	.ref	ckzpos
	WL	ANI_CODE,ckzpos
	WL	4,U3CP3B+FR2
	WL	4,U3CP3B+FR3
	WL	4,U3CP3B+FR4
	WL	4,U3CP3B+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	WL	ANI_CODE,HIT_THE_MAT

	WL	2,U3CP3B+FR7

	.word	ANI_OFFSET,2,0,0			;x,y,z
	WL	10,U3CP3B+FR1
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,und_getup_anim

 SUBR	und_slambounce2_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_FACE,MOVE_LEFT|MOVE_UP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off
	WL	1,U3DD3X+FR9
	WL	ANI_CODE,ckzpos
	WL	3,U3DD3X+FR9
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_XFLIP
	WL	ANI_SET_YVEL,030000h
	WL	4,U3CP3B+FR2
	WL	4,U3CP3B+FR3
	WL	4,U3CP3B+FR4
	WL	4,U3CP3B+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	3,U3CP3B+FR7

	.word	ANI_OFFSET,2,0,0			;x,y,z
	WL	10,U3CP3B+FR1
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,und_getup_anim

#*****************************************************************************

 SUBR	und_breakneck2_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	5,U3FD3X+FR2
	.word	ANI_OFFSET,0,49,0			;x,y,z
	WL	5,U3FD3X+FR3
	WL	5,U3FD3X+FR4
	WL	5,U3FD3X+FR5
	WL	1,U3FD3X+FR6

	.word	ANI_WAITHITGND
;;;	.word	ANI_ZERO_XZVELS

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,20

	WL	3,U3GP3X+FR1
	WL	3,U3GP3X+FR2
	WL	3,U3GP3X+FR3
	WL	3,U3GP3X+FR4
	WL	3,U3GP3X+FR5
	WL	3,U3GP3X+FR6

	.word	ANI_ZERO_XZVELS

	.word	ANI_XFLIP

	WL	8,U3CR3A+FR7

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,und_getup_anim

#*****************************************************************************
*
* SHOOT SPIRITS - Pull in opponent

 SUBR	und_spirit_pull_anim

;Drones will have to be alerted to the presence of projectiles
;and then check for them!

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	WL	2,U3MS3B+FR2
	WL	2,U3MS3B+FR3

	WL	1,U3MS3B+FR4
	WL	2,U3MS3B+FR5
	WL	ANI_CODE,#fireball
	WL	1,U3MS3B+FR6


	WL	2,U3MS3B+FR7
	WL	1,U3MS3B+FR8
	WL	2,U3MS3B+FR9
	WL	1,U3MS3B+FR10
	WL	2,U3MS3B+FR11

	WL	1,U3MS3B+FR4
	WL	2,U3MS3B+FR5
	WL	ANI_CODE,#fireball
	WL	1,U3MS3B+FR6
	WL	2,U3MS3B+FR7
	WL	1,U3MS3B+FR8
	WL	2,U3MS3B+FR9
	WL	1,U3MS3B+FR10
	WL	2,U3MS3B+FR11

	WL	1,U3MS3B+FR4
	WL	2,U3MS3B+FR5
	WL	ANI_CODE,#fireball
	WL	1,U3MS3B+FR6
	WL	2,U3MS3B+FR7
	WL	1,U3MS3B+FR8
	WL	2,U3MS3B+FR9
	WL	1,U3MS3B+FR10
	WL	2,U3MS3B+FR11

	WL	1,U3MS3B+FR4
	WL	2,U3MS3B+FR5
	WL	ANI_CODE,#fireball
	WL	1,U3MS3B+FR6
	WL	2,U3MS3B+FR7
	WL	1,U3MS3B+FR8
	WL	2,U3MS3B+FR9
	WL	1,U3MS3B+FR10
	WL	2,U3MS3B+FR11

	.word	ANI_OFFSET,-15,0,0			;x,y,z
	WL	3,U4FT3A+FR9
	WL	3,U4FT3A+FR10
	WL	3,U4FT3A+FR11

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#fireball
	move	a13,a11
	.ref	und_spirit_pull
	CREATE0	und_spirit_pull
	rets

#*****************************************************************************
*
* SHOOT SPIRITS - Push away opponent

 SUBR	und_spirit_push_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	WL	2,U3MS3B+FR2
	WL	2,U3MS3B+FR3

	WL	1,U3MS3B+FR4
	WL	2,U3MS3B+FR5
	WL	ANI_CODE,#fireball
	WL	1,U3MS3B+FR6


	WL	2,U3MS3B+FR7
	WL	1,U3MS3B+FR8
	WL	2,U3MS3B+FR9
	WL	1,U3MS3B+FR10
	WL	2,U3MS3B+FR11

	WL	1,U3MS3B+FR4
	WL	2,U3MS3B+FR5
	WL	ANI_CODE,#fireball
	WL	1,U3MS3B+FR6
	WL	2,U3MS3B+FR7
	WL	1,U3MS3B+FR8
	WL	2,U3MS3B+FR9
	WL	1,U3MS3B+FR10
	WL	2,U3MS3B+FR11

	WL	1,U3MS3B+FR4
	WL	2,U3MS3B+FR5
	WL	ANI_CODE,#fireball
	WL	1,U3MS3B+FR6
	WL	2,U3MS3B+FR7
	WL	1,U3MS3B+FR8
	WL	2,U3MS3B+FR9
	WL	1,U3MS3B+FR10
	WL	2,U3MS3B+FR11

	WL	1,U3MS3B+FR4
	WL	2,U3MS3B+FR5
	WL	ANI_CODE,#fireball
	WL	1,U3MS3B+FR6
	WL	2,U3MS3B+FR7
	WL	1,U3MS3B+FR8
	WL	2,U3MS3B+FR9
	WL	1,U3MS3B+FR10
	WL	2,U3MS3B+FR11

	.word	ANI_OFFSET,-15,0,0			;x,y,z
	WL	3,U4FT3A+FR9
	WL	3,U4FT3A+FR10
	WL	3,U4FT3A+FR11

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#fireball
	move	a13,a11
	.ref	und_spirit_push
	CREATE0	und_spirit_push
	rets

******************************************************************************
	.end
