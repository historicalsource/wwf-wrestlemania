**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		12/8/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"bamseq4.asm"
	.title	"Bam Bam animation sequences"
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
	.include	"bamimg.h"
	.include	"damage.equ"
	.INCLUDE	"SWEAT.EQU"


******************************************************************************
* EXTERNAL REFERENCES

	.ref	DO_SCREAM,HIT_THE_MAT,SMALL_BOUNCE,CALL_MISSES
	.ref	am_I_dizzy,am_I_dead,ckzpos,start_run_anim
	.ref	bam_faceup_getup_anim,bam_fall_back_anim

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* GENERIC BOUNCE
 SUBR	bam_slamnobounce_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	1,B3CP3B+FR1
	WL	3,B3CP3B+FR1
	WL	4,B3CP3B+FR2
	WL	4,B3CP3B+FR3
	WL	4,B3CP3B+FR4
	WL	4,B3CP3B+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	2,B3CP3B+FR7

	WL	10,B3RL1A+FR1		;1st frame of roll

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_faceup_getup_anim


 SUBR	bam_slambounce_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h


	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	1,B3CP3B+FR1
	WL	ANI_CODE,ckzpos
	WL	ANI_SET_YVEL,040000h
	WL	3,B3CP3B+FR1
	WL	4,B3CP3B+FR2
	WL	4,B3CP3B+FR3
	WL	4,B3CP3B+FR4
	WL	4,B3CP3B+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	2,B3CP3B+FR7

	WL	10,B3RL1A+FR1		;1st frame of roll

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_faceup_getup_anim

 SUBR	bam_slambounce2_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	1,B4UC3Z+FR8
	WL	ANI_CODE,ckzpos
	WL	3,B4UC3Z+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_XFLIP
	WL	ANI_SET_YVEL,030000h

	WL	4,B3CP3B+FR1
	WL	4,B3CP3B+FR2
	WL	4,B3CP3B+FR3
	WL	4,B3CP3B+FR4
	WL	4,B3CP3B+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	2,B3CP3B+FR7

	WL	10,B3RL1A+FR1		;1st frame of roll

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_faceup_getup_anim

#*****************************************************************************

 SUBR	bam_breakneck2_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYD_SWEAT,SWEAT_PER,0
	.word	ANI_OFFSET,0,52,0
	WL	6,B4UC3B+FR3
	WL	6,B4UC3B+FR4
	WL	6,B4UC3B+FR5
	WL	1,B4UC3B+FR6

	.word	ANI_WAITHITGND

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40

	WL	3,B3FD3C+FR1
	WL	3,B3FD3C+FR2
	WL	3,B3FD3C+FR3
	WL	3,B3FD3C+FR4
	WL	3,B3FD3C+FR5

	.word	ANI_ZERO_XZVELS

	WL	ANI_CODE,HIT_THE_MAT
	WL	8,B3RL1A+FR7

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_faceup_getup_anim

#*****************************************************************************

 SUBR	bam_arm_broken_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_XVEL,-38000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,10000h,AM_HIT_REL

	WL	ANI_CODE,DO_SCREAM
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	4,B4AH4A+FR2
	WL	4,B4AH4A+FR3
	WL	4,B4AH4A+FR4
	WL	4,B4AH4A+FR5
	WL	4,B4AH4A+FR6

	WL	1,B4ST4Z+FR1

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,bam_fall_back_anim
;	.word	ANI_END

#nodead
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************

	.end
