**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		11/28/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"dnkseq4.asm"
	.title	"Dink animation sequences"
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
	.include	"doinkimg.h"
	.include	"damage.equ"
	.INCLUDE	"SWEAT.EQU"


******************************************************************************
* EXTERNAL REFERENCES

	.REF	DO_SCREAM
	.REF	HIT_THE_MAT,SMALL_BOUNCE
	.REF	CALL_MISSES
 	.ref	am_I_dizzy
	.ref	am_I_dead
	.ref	ckzpos
	.ref	start_run_anim
	.ref	dnk_faceup_getup_anim
	.ref	dnk_2_faceup_getup_anim

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* GENERIC BOUNCE

 SUBR	dnk_slamnobounce_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	1,D3SA3A+FR2
	WL	3,D3SA3A+FR2
	WL	4,D3SA3A+FR3
	WL	4,D3SA3A+FR4
	WL	4,D3SA3A+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	2,D3SA3A+FR8

	WL	10,D3SA3A+FR9

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,dnk_2_faceup_getup_anim

 SUBR	dnk_slambounce_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_DEBRIS,200,1,0,8,0		;%chance, tbl index, x,y,z off

;	.word	ANI_GROUND

	WL	1,D3SA3A+FR2
	.ref	ckzpos
	WL	ANI_CODE,ckzpos
	WL	ANI_SET_YVEL,040000h
	WL	3,D3SA3A+FR2
	WL	4,D3SA3A+FR3
	WL	4,D3SA3A+FR4
	WL	4,D3SA3A+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	2,D3SA3A+FR8

	WL	10,D3SA3A+FR9

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,dnk_faceup_getup_anim

 SUBR	dnk_slambounce2_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;	WL	ANI_SET_YVEL,040000h

	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_DEBRIS,200,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	1,D3SA3X+FR2
	WL	ANI_CODE,ckzpos

	WL	3,D3SA3X+FR2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_XFLIP

	WL	ANI_SET_YVEL,030000h
	WL	3,D3SA3A+FR2
	WL	4,D3SA3A+FR3
	WL	4,D3SA3A+FR4
	WL	4,D3SA3A+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	2,D3SA3A+FR8

	WL	10,D3SA3A+FR9

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,dnk_faceup_getup_anim

#*****************************************************************************

 SUBR	dnk_breakneck2_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_OFFSET,20,47,0			;x,y,z

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYD_SWEAT,SWEAT_PER,0
	WL	6,D3UC3A+FR4
	WL	6,D3UC3A+FR5
	WL	6,D3UC3A+FR6
	WL	1,D3UC3A+FR7

	.word	ANI_WAITHITGND

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,25

	WL	3,D3FD3E+FR2
	WL	3,D3FD3E+FR3
	WL	3,D3FD3E+FR4
	WL	3,D3FD3E+FR5
	WL	3,D3FD3E+FR6
	WL	3,D3FD3E+FR7
	WL	3,D3FD3E+FR8
	WL	3,D3FD3E+FR9

	.word	ANI_ZERO_XZVELS

	WL	ANI_CODE,HIT_THE_MAT
	WL	8,D3RL1B+FR6

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,dnk_faceup_getup_anim

#*****************************************************************************

 SUBR	dnk_arm_broken_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_XVEL,-38000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,10000h,AM_HIT_REL

	WL	ANI_CODE,DO_SCREAM
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	4,D3AH3B+FR2
	WL	4,D3AH3B+FR3
	WL	4,D3AH3B+FR5
	WL	1,D4ST4E+FR3

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	.ref	dnk_fall_back_anim

	WL	ANI_CHANGEANIM,dnk_fall_back_anim
;	.word	ANI_END

#nodead

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************

	.end
