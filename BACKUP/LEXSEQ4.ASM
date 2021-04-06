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

	.file	"lexseq4.asm"
	.title	"Lex Loser animation sequences"
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

	.include	"leximg.h"
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
	.ref	lex_faceup_getup_anim

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* GENERIC BOUNCE

 SUBR	lex_slambounce_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,040000h

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	1,L3CP3X+FR3
	.ref	ckzpos
	WL	ANI_CODE,ckzpos
	WL	3,L3CP3X+FR3
	WL	4,L3CP3X+FR4
	WL	4,L3CP3X+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	2,L3CP3X+FR7

	WL	10,L3CP3X+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim

 SUBR	lex_slambounce2_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	1,L3UC3Z+FR10
	.ref	ckzpos
	WL	ANI_CODE,ckzpos
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_XFLIP
	WL	ANI_SET_YVEL,030000h
	WL	4,L3CP3X+FR3
	WL	4,L3CP3X+FR4
	WL	4,L3CP3X+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	2,L3CP3X+FR7

	WL	10,L3CP3X+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim

#*****************************************************************************

 SUBR	lex_breakneck2_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_OFFSET,0,39,0			;x,y,z

	WL	4,L3UC3X+FR3
	WL	4,L3UC3X+FR4
	WL	1,L3UC3X+FR5

	.word	ANI_WAITHITGND
;;;	.word	ANI_ZERO_XZVELS

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,20

	WL	3,L3UC3X+FR6

	WL	3,L3FD3B+FR1
	WL	3,L3FD3B+FR2
	WL	3,L3FD3B+FR3
	WL	3,L3FD3B+FR4
	WL	3,L3FD3B+FR5

	.word	ANI_ZERO_XZVELS

	WL	3,L3FD3B+FR6

;;;	.word	ANI_XFLIP
	WL	2,L3CP3X+FR7
	WL	1+5,L3CP3X+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim

******************************************************************************
	.end
