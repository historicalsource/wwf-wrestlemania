**************************************************************
*
* Software:		Jason Skiles
* Initiated:		26 Aug 94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"rzrseq4.asm"
	.title	"blocks, reactions to routine and special attacks"
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
	.include	"display.equ"
	.include	"ring.equ"
	.include	"damage.equ"
	.INCLUDE	"SWEAT.EQU"

******************************************************************************
* EXTERNAL REFERENCES

	;RAZOR
	.ref	rzr_3_head_held_anim

	;MISC
	.ref	HIT_THE_MAT,SMALL_BOUNCE,ckzpos
	.ref	DO_RAZOR_PUSH
	.ref	DO_WAIL
	.ref	DO_BLOCKED
	.ref	DO_SCREAM
	.ref	free_toss_check,setup_freetoss,rzr_4_hiptoss_anim

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* #2 BLOCK + HITBLOCK

 SUBR	rzr_2_block_anim

	.word	ANI_SETMODE,MODE_UNINT
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
;Rotate toward opponent if needed!

;	WL	ANI_CODE,block_if_safe
	.word	ANI_SETPLYRMODE,MODE_BLOCK
	WL	2,R2BK3E+FR1
	WL	1,R4BK3D+FR1
;	.word	ANI_SETPLYRMODE,MODE_BLOCK
	WL	1,R4BK3D+FR1
	WL	1,R4BK3D+FR2
	WL	ANI_GOTO,#hold_block


************
*
* #4 BLOCK + HITBLOCK

 SUBR	rzr_4_block_anim

	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

;Rotate toward opponent if needed!
;	WL	ANI_CODE,block_if_safe
	.word	ANI_SETPLYRMODE,MODE_BLOCK
	WL	2,R4BK3D+FR1
	WL	1,R4BK3D+FR2
;	.word	ANI_SETPLYRMODE,MODE_BLOCK
	WL	1,R4BK3D+FR2
#hold_block
	WL	2,R4BK3D+FR3
	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT|MODE_FRICTION
;	.word	ANI_ZERO_XZVELS
	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
	.word	ANI_SETMODE,MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETFACING
	WL	2,R4BK3D+FR2
	WL	2,R4BK3D+FR1
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_END


 SUBR	rzr_4_hitblock_anim

	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT
	.word	ANI_FRICTION,5000h
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,DO_BLOCKED

	WL	1,R4BK3D+FR5
	WL	2,R4BK3D+FR6
	WL	1,R4BK3D+FR5

	WL	ANI_GOTO,#hold_block

 SUBR	rzr_4_hitblock2_anim

	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT
	.word	ANI_FRICTION,4000h
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,DO_BLOCKED
	WL	ANI_SET_YVEL,38000h

	WL	3,R4BK3D+FR5
	WL	3,R4BK3D+FR6
	WL	3,R4BK3D+FR5
	WL	3,R4BK3D+FR6
	WL	3,R4BK3D+FR5
	WL	3,R4BK3D+FR6

	WL	ANI_GOTO,#hold_block


#*****************************************************************************
*
* #4 LOSE BALANCE

#FRICTION_VAL	equ	3000h

 SUBR	rzr_4_losebal_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_FRICTION,#FRICTION_VAL
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WLW	ANI_SET_XVEL,-60000h,AM_HIT_REL

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0

	WL	ANI_CODE,DO_RAZOR_PUSH
	WL	3,R4LB4Z+FR1
	WL	3,R4LB4Z+FR2
	WL	3,R4LB4Z+FR3
	WL	3,R4LB4Z+FR4
	.word	ANI_WAITHITGND
	WL	3,R4LB4Z+FR4

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #2 HEAD HIT

 SUBR	rzr_2_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,R2AH2D+FR3
	WL	3,R2AH2D+FR5
	WL	3,R2AH2D+FR6
	WL	3,R2AH2D+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


* #4 HEAD HIT

 SUBR	rzr_4_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,R4AH4C+FR3
	WL	3,R4AH4C+FR4
	WL	3,R4AH4C+FR5
	WL	3,R4AH4C+FR6
	WL	3,R4AH4C+FR7
	WL	3,R4AH4C+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	rzr_2_head_hit3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,40000h

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,R2AH2D+FR3
	.word	ANI_DEBRIS,100,2,-21,100,0	;%chance, tbl index, x,y,z off
	WL	3,R2AH2D+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,R2AH2D+FR6
	WL	3,R2AH2D+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


* #4 HEAD HIT

 SUBR	rzr_4_head_hit3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-20000h,AM_ABS
	WL	ANI_SET_YVEL,40000h

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,R4AH4C+FR3
	.word	ANI_DEBRIS,300,2,-21,100,0	;%chance, tbl index, x,y,z off
	WL	3,R4AH4C+FR4
	WL	3,R4AH4C+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,R4AH4C+FR6
	WL	3,R4AH4C+FR7
	WL	3,R4AH4C+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	rzr_4_head_hit4_anim

;From earslap
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

;	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
;	WLW	ANI_SET_ZVEL,-20000h,AM_ABS
	WL	ANI_SET_YVEL,40000h

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	4,R4AH4C+FR4
	WL	4,R4AH4C+FR5
;	.word	ANI_WAITHITGND
;	.word	ANI_ZEROVELS
	WL	4,R4AH4C+FR6
	WL	4,R4AH4C+FR7
	WL	4,R4AH4C+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************
*
* #2 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	rzr_2_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

	WL	3,R2AH2D+FR3
	WL	15,R2AH2D+FR5
	WL	4,R2AH2D+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	rzr_4_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

	WL	3,R4AH4C+FR3
	WL	3,R4AH4C+FR4
	WL	14,R4AH4C+FR5
	WL	2,R4AH4C+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


* #4 RUNNING BOUNCE OFF OF OPPONENT

;Bounce off but stay dizzy!

 SUBR	rzr_4_bncoff_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	3,R4AH4C+FR3
	WL	3,R4AH4C+FR4
	WL	14,R4AH4C+FR5
	WL	2,R4AH4C+FR6

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,rzr_dizzy_anim
;	.word	ANI_END


#*****************************************************************************
*
* #2 HEAD HIT2 (hands on face)

 SUBR	rzr_2_head_hit2_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h
	.word	ANI_SETSPEED,100h

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,R2AE2A+FR1
	WL	3,R2AE2A+FR2
	WL	3,R2AE2A+FR3
	WL	3,R2AE2A+FR4
	WL	3,R2AE2A+FR5
	WL	3,R2AE2A+FR6
	WL	3,R2AE2A+FR7
	WL	3,R2AE2A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*************
*
* #4 HEAD HIT2 (hands on face)

;TODO (JS) This seq takes too long.  Cut something.

 SUBR	rzr_4_head_hit2_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h
	.word	ANI_SETSPEED,100h

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,R4AE4B+FR1
	WL	3,R4AE4B+FR2
	WL	3,R4AE4B+FR3
	WL	3,R4AE4B+FR4
	WL	3,R4AE4B+FR5
	WL	3,R4AE4B+FR6
	WL	2,R4AE4B+FR7
	WL	2,R4AE4B+FR8
	WL	2,R4AE4B+FR9
	WL	2,R4AE4B+FR10
	WL	2,R4AE4B+FR11
	WL	2,R4AE4B+FR12

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,rzr_fall_back_anim
;	.word	ANI_END

#nodead
	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
       	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	rzr_4_head_hit2s_anim
;Salt hits me in face

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.ref	create_impact_salt
	WL	ANI_CODE,create_impact_salt

	WL	4,R4AE4B+FR1
	WL	4,R4AE4B+FR2
	WL	4,R4AE4B+FR3
	WL	4,R4AE4B+FR4
	WL	4,R4AE4B+FR5
	WL	3,R4AE4B+FR6
	WL	3,R4AE4B+FR7
	.word	ANI_WAITHITGND
	.word	ANI_FRICTION,4000h
	WL	50,R4AE4B+FR7
	.word	ANI_ZEROVELS
	WL	3,R4AE4B+FR8
	WL	3,R4AE4B+FR9
	WL	3,R4AE4B+FR10
	WL	3,R4AE4B+FR11
	WL	3,R4AE4B+FR12

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
       	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 HEAD HIT (ends in dizzy)

 SUBR	rzr_4_head_hit_dizzy_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	.word	ANI_SETSPEED,100h
	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h

	.word	ANI_SETPLYRMODE,MODE_DIZZY
	.word	ANI_DEBRIS,300,3,-21,100,0	;%chance, tbl index, x,y,z off

	WL	3,R4AE4B+FR1
	WL	3,R4AE4B+FR2
	WL	3,R4AE4B+FR3
	WL	3,R4AE4B+FR4
	WL	3,R4AE4B+FR5
	WL	3,R4AE4B+FR6
	WL	3,R4AE4B+FR7
	WL	3,R4AE4B+FR8
	WL	4,R4AE4B+FR9
	WL	4,R4AE4B+FR10
	WL	4,R4AE4B+FR11
	WL	4,R4AE4B+FR12

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,rzr_dizzy_anim


#*****************************************************************************
*
* #2 BODY HIT

 SUBR	rzr_2_body_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL

	.word	ANI_DEBRIS,300,0,-4,71,0	;%chance, tbl index, x,y,z off
	WL	3,R4AM3X+FR1
	WL	1,R4AM3X+FR2
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,R4AM3X+FR3
	WL	2,R4AM3X+FR4
	WL	3,R4AM3X+FR5
	WL	2,R4AM3X+FR6
	WL	3,R4AM3X+FR7
	WL	2,R1TT5Z+FR2

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	rzr_2_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,8000h,AM_ABS

	.word	ANI_DEBRIS,300,0,-4,71,0	;%chance, tbl index, x,y,z off
	WL	3,R4AM3X+FR1
	WL	1,R4AM3X+FR2
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,R4AM3X+FR3
	WL	3,R4AM3X+FR4
	WL	3,R4AM3X+FR5
	WL	3,R4AM3X+FR6
	WL	3,R4AM3X+FR7
	WL	3,R1TT5Z+FR2

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 BODY HIT

 SUBR	rzr_4_body_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL

	.word	ANI_DEBRIS,300,0,-4,71,0	;%chance, tbl index, x,y,z off
	WL	3,R4AM3X+FR1
	WL	1,R4AM3X+FR2
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,R4AM3X+FR3
	WL	2,R4AM3X+FR4
	WL	3,R4AM3X+FR5
	WL	2,R4AM3X+FR6
	WL	3,R4AM3X+FR7
	WL	2,R4AM3X+FR8

	.word	ANI_CHECKWORD,USR_VAR1
	WL	ANI_IFNOTSTATUS,#reg

	WL	8,R4WP5C+FR1
	WL	8,R4WP5C+FR2
	WL	8,R4WP5C+FR3
	WL	8,R4WP5C+FR4
	WL	8,R4WP5C+FR5
	WL	8,R4WP5C+FR6
	WL	8,R4WP5C+FR7
	WL	8,R4WP5C+FR8

;	WL	8,R4WP5C+FR1
;	WL	8,R4WP5C+FR2
;	WL	8,R4WP5C+FR3
;	WL	8,R4WP5C+FR4
;	WL	8,R4WP5C+FR5
;	WL	8,R4WP5C+FR6
;	WL	8,R4WP5C+FR7
;	WL	8,R4WP5C+FR8

#reg

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	rzr_4_body_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	.word	ANI_DEBRIS,300,0,-4,71,0	;%chance, tbl index, x,y,z off
	WL	3,R4AM3X+FR1
	WL	1,R4AM3X+FR2
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,R4AM3X+FR3
	WL	3,R4AM3X+FR4
	WL	3,R4AM3X+FR5
	WL	3,R4AM3X+FR6
	WL	3,R4AM3X+FR7
	WL	3,R4AM3X+FR8

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,rzr_dizzy_anim

	.word	ANI_END

 SUBR	rzr_4_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-8000h,AM_ABS

	.word	ANI_DEBRIS,300,0,-4,71,0	;%chance, tbl index, x,y,z off
	WL	3,R4AM3X+FR1
	WL	1,R4AM3X+FR2
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,R4AM3X+FR3
	WL	3,R4AM3X+FR4
	WL	3,R4AM3X+FR5
	WL	3,R4AM3X+FR6
	WL	3,R4AM3X+FR7
	WL	3,R4AM3X+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	rzr_4_knee_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-8000h,AM_ABS
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	.word	ANI_DEBRIS,300,0,-4,71,0	;%chance, tbl index, x,y,z off
	WL	3,R4AM3X+FR1
	WL	1,R4AM3X+FR2
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,R4AM3X+FR3
	WL	3,R4AM3X+FR4
	WL	3,R4AM3X+FR5
	WL	3,R4AM3X+FR6
	WL	3,R4AM3X+FR7
	WL	3,R4AM3X+FR8

;	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	ANI_CHANGEANIM,rzr_dizzy_anim
;	.word	ANI_END

 SUBR	rzr_quick_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h

	WL	3,R4AM3X+FR1
	WL	3,R4AM3X+FR2
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	3,R4AM3X+FR3
	WL	3,R4AM3X+FR4
	WL	3,R4AM3X+FR5
	WL	3,R4AM3X+FR6
	WL	3,R4AM3X+FR7
	WL	3,R4AM3X+FR8

	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,rzr_fall_back_anim
;	.word	ANI_END

#nodead

	WL	ANI_CHANGEANIM,rzr_3_head_held_anim
;	.word	ANI_END

#*****************************************************************************
*
* FALL BACK

 SUBR	rzr_fall_back_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCOLLIS
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZERO_XZVELS
	WL	ANI_MIN_YVEL,50000h
	WLW	ANI_SET_ZVEL,10000h,AM_FACE_REL

	.word	ANI_SCROLL_CTRL,RZR_TBUKLY-60

	WL	ANI_CODE,ckzpos

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYC_SWEAT,SWEAT_PER,0
	WWL	ANI_SETLONG,DEBRIS_X,[105,-18]	;Y,X of head
	WL	3,R3FD3B+FR1
	WWL	ANI_SETLONG,DEBRIS_X,[99,-38]	;Y,X of head
	WL	3,R3FD3B+FR2
	.word	ANI_OFFSET,0,53,0			;x,y,z
	WWL	ANI_SETLONG,DEBRIS_X,[36,-44]	;Y,X of head
	WL	3,R3FD3B+FR3
	WWL	ANI_SETLONG,DEBRIS_X,[31,-44]	;Y,X of head
	WL	3,R3FD3B+FR4
	WWL	ANI_SETLONG,DEBRIS_X,[18,-48]	;Y,X of head
	WL	3,R3FD3B+FR5
	.word	ANI_WAITHITGND

	.word	ANI_DEBRIS,100,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,30

	.word	ANI_FRICTION,3000h

	WWL	ANI_SETLONG,DEBRIS_X,[11,-42]	;Y,X of head
	WL	2,R3FD3B+FR6
	.word	ANI_BOUNCE,5
	WL	1,R3FD3B+FR6
	WWL	ANI_SETLONG,DEBRIS_X,[11,-42]	;Y,X of head
	WL	3,R3FD3B+FR7
	WWL	ANI_SETLONG,DEBRIS_X,[11,-42]	;Y,X of head
	WL	3,R3FD3B+FR8
	WWL	ANI_SETLONG,DEBRIS_X,[16,-42]	;Y,X of head
	WL	3,R3FD3B+FR9
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WWL	ANI_SETLONG,DEBRIS_X,0		;Y,X of head

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_XFLIP
	WL	3,R3GU2A+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,rzr_faceup_getup_anim


#*****************************************************************************
*
* FALL BACK

 SUBR	rzr_fall_back2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,20000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	WL	ANI_CODE,ckzpos

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYC_SWEAT,SWEAT_PER,0
	WL	3,R3FD3B+FR1
	WL	3,R3FD3B+FR2
	.word	ANI_OFFSET,0,53,0			;x,y,z
	WL	3,R3FD3B+FR3
	WL	3,R3FD3B+FR4
	WL	3,R3FD3B+FR5
	WL	3,R3FD3B+FR8
	.word	ANI_WAITHITGND

	.word	ANI_DEBRIS,100,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,30
	.word	ANI_ZEROVELS		
	WLW	ANI_SET_ZVEL,18000h,AM_ABS
	WLW	ANI_SET_XVEL,-30000h,AM_FACE_REL

	WL	3,R3HG3B+FR1
	.word	ANI_OFFSET,-25,0,0			;x,y,z
	WL	3,R3GP3Z+FR8
	WL	3,R3HG3B+FR3
	WL	3,R3HG3B+FR4
	WL	3,R3HG3B+FR5
	WL	3,R3HG3B+FR6
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	WL	3,R3MS3Q+FR1
	WL	3,R3MS3Q+FR2
	WL	3,R3MS3Q+FR3
	WL	3,R3MS3Q+FR4
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	WL	30,R3RL1B+FR6		;Face down

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,rzr_faceup_getup_anim

#*****************************************************************************
*
* FALL FROM TURNBUCKLE

 SUBR	rzr_fall_back_tbukl_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETSPEED,100h

	WL	3,R3FD3B+FR1
	WL	3,R3FD3B+FR2
	.word	ANI_OFFSET,0,53,0			;x,y,z
	WL	3,R3FD3B+FR3
	WL	3,R3FD3B+FR4
	WL	3,R3FD3B+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_DAMAGE,D_HITCONCRETE

	.word	ANI_DEBRIS,100,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,30

	.word	ANI_FRICTION,3000h

	WL	2,R3FD3B+FR6
;	.word	ANI_BOUNCE,5
	WL	1,R3FD3B+FR6
	WL	3,R3FD3B+FR7
	WL	3,R3FD3B+FR8
	WL	3,R3FD3B+FR9
;	.word	ANI_WAITHITGND
;	WL	ANI_CODE,SMALL_BOUNCE
;	.word	ANI_ZEROVELS

	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_XFLIP
	WL	3,R3GU2A+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,rzr_faceup_getup_anim


#*****************************************************************************
*
* FACE DOWN GETUP

;FIX!!  add wrestler_xflip at the appropriate frame for all getups!

 SUBR	rzr_facedown_getup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	.word	ANI_XFLIP
	WL	3,R3DC3C+FR10
	.word	ANI_XFLIP
	WL	ANI_CODE,choose_2or4
	WL	ANI_IFSTATUS,#getup_in_4

#getup_in_2
	WL	3,R3GU2A+FR7
	WL	3,R3GU2A+FR8
	WL	3,R3GU2A+FR9

	.word	ANI_SAFE_TIME,50

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,25,98,68,14
	WL	1,R3GU2A+FR9
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	.ref	rzr_4_push_anim
	WL	ANI_CHANGEANIM,rzr_4_push_anim
#no_freetoss

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#getup_in_4
	WL	3,R3GU4A+FR6
	WL	3,R3GU4A+FR7
	WL	3,R3GU4A+FR8
	WL	3,R3GU4A+FR9

	.word	ANI_SAFE_TIME,50

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss4
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,25,98,68,14
	WL	1,R3GU4A+FR9
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss4

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,rzr_4_push_anim
#no_freetoss4

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* FACE UP GETUP


 SUBR	rzr_faceup_getup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	WL	2,R3GU2A+FR1
	WL	3,R3GU2A+FR2
	WL	ANI_CODE,choose_2or4
	WL	ANI_IFSTATUS,#getup_in_4

#getup_in_2
	WL	2,R3GU2A+FR3
	WL	3,R3GU2A+FR4
	WL	2,R3GU2A+FR5
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WL	3,R3GU2A+FR6
	WL	2,R3GU2A+FR7
	WL	3,R3GU2A+FR8
	WL	2,R3GU2A+FR9

	.word	ANI_SAFE_TIME,50

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,25,98,68,14
	WL	1,R3GU2A+FR9
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,rzr_4_push_anim
#no_freetoss

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#getup_in_4
	WL	2,R3GU4A+FR3
	WL	3,R3GU4A+FR4
	WL	2,R3GU4A+FR5
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WL	3,R3GU4A+FR6
	WL	2,R3GU4A+FR7
	WL	3,R3GU4A+FR8
	WL	2,R3GU4A+FR9

	.word	ANI_SAFE_TIME,50

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss2
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,25,98,68,14
	WL	1,R3GU4A+FR9
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss2

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,rzr_4_push_anim
#no_freetoss2

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	rzr_faceup_getup2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

#common
	WL	3,R3GU4A+FR4
	WL	2,R3GU4A+FR5
	WL	3,R3GU4A+FR6
	WL	2,R3GU4A+FR7
	WL	3,R3GU4A+FR8
	WL	2,R3GU4A+FR9

	.word	ANI_SAFE_TIME,50

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss3
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,25,98,68,14
	WL	1,R3GU4A+FR9
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss3

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,rzr_4_push_anim
#no_freetoss3

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


*****
* set status bit for a getup in 4, clear for a 2.
choose_2or4

	move	*a13(ANIMODE),a0
	andni	MODE_STATUS,a0

	move	*a13(NEW_FACING_DIR),a14
	btst	MOVE_UP_BIT,a14
	jrnz	#choose_2
	ori	MODE_STATUS,a0
#choose_2
	move	a0,*a13(ANIMODE)
	rets



#*****************************************************************************
*
* HITS ON GROUND

 SUBR	rzr_up_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.WORD	ANI_XFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	10,R3TD3A+FR4
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,R3AM3D+FR1
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,rzr_faceup_getup_anim

 SUBR	rzr_hitonground_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	ANI_CODE,ckzpos

	WL	1,R3AM3D+FR2
	WL	ANI_SET_YVEL,39000h
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPITUP_SWEAT,SWEAT_PER,0
	WL	2,R3AM3D+FR2

	.word	ANI_DEBRIS,100,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	3,R3AM3D+FR3
	WL	3,R3AM3D+FR4
	WL	3,R3AM3D+FR5
	WL	3,R3AM3D+FR6
	WL	3,R3AM3D+FR7

	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	2,R3AM3D+FR1
 SUBR	rzr_liedown_anim
	WL	1,R3AM3D+FR1
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,rzr_faceup_getup_anim

#*****************************************************************************
*
* DIZZY

 SUBR	rzr_dizzy_anim

	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_START_DIZZY,0	;0=Standing dizzy
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

#loop
	WL	8,R4WP5C+FR1
	WL	8,R4WP5C+FR2
	WL	8,R4WP5C+FR3
	WL	8,R4WP5C+FR4
	WL	8,R4WP5C+FR5
	WL	8,R4WP5C+FR6
	WL	8,R4WP5C+FR7
	WL	8,R4WP5C+FR8
	WL	ANI_GOTO,#loop


#*****************************************************************************
*
* THROWN FROM RING (shn_bslm, shn_frnk)

 SUBR	rzr_flyout_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETSPEED,100h

	WWL	ANI_SETLONG,OBJ_GRAVITY,0E000h
	.word	ANI_SET_IDIOT
	WL	ANI_CODE,DO_WAIL

	WL	7,R3TD3A+FR6
	WL	7,R3TD3A+FR7
	WL	1,R3TD3A+FR8
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,60
	.word	ANI_OFFSET,42,0,0

	.word	ANI_DAMAGE,D_HIPTOSS
;	.word	ANI_SETWORD,DELAY_METER,0
;	.word	ANI_GETUP,500

	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,rzr_hitonground_anim

#*****************************************************************************
*
* ROLL OVER AND BREAK YER STINKIN' NECK
*

 SUBR	rzr_break_neck_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h

	.word	ANI_ZEROVELS

	WWWL	ANI_IFROPE,RC_EITHER,100,#fall_back

	;roll over.
	WL	3,R3HG3B+FR3
	.word	ANI_OFFSET,-10,0,0
	WL	3,R3HG3B+FR4
	.word	ANI_OFFSET,-4,0,0
	WL	3,R3HG3B+FR5
	.word	ANI_OFFSET,-9,0,0
	WL	3,R3HG3B+FR6
	.word	ANI_OFFSET,-23,0,0
	WL	1,R3RL1B+FR6
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,rzr_facedown_getup_anim

#fall_back
	;no room.  fall back
	.word	ANI_OFFSET,-11,0,0
	WL	5,R3HG3B+FR1
	.word	ANI_OFFSET,19,0,0
	WL	5,R3TD3A+FR9
	.word	ANI_OFFSET,-28,0,0
	.word	ANI_XFLIP
	WL	3,R3GU2A+FR1
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,rzr_facedown_getup_anim

 SUBR	rzr_break_neck2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,60000h
	WLW	ANI_SET_ZVEL,8000h,AM_ABS

	WL	ANI_CODE,ckzpos

	.word	ANI_XFLIP
	WL	5,R3HG3B+FR3
	WL	5,R3HG3B+FR4
	WL	5,R3HG3B+FR5
	WL	5,R3HG3B+FR6
	.word	ANI_WAITHITGND

	;hit.  stay.
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	ANI_CODE,SMALL_BOUNCE
;	.word	ANI_SOUND,bounce_l1
	.word	ANI_OFFSET,-7,0,0
	.word	ANI_ZEROVELS

	WL	10,R3RL1B+FR6	;20

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,rzr_facedown_getup_anim

 SUBR	rzr_break_neck3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,58000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	WL	ANI_CODE,ckzpos

	.word	ANI_DEBRIS,300,5,0,-5,0	;%chance, tbl index, x,y,z off

	WL 	15,R4POGO+FR5
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_XFLIP
	WL	3,R3GP3Z+FR7
	WL	3,R3GP3Z+FR8

	WL	3,R3HG3B+FR3
	WL	3,R3HG3B+FR4
	WL	3,R3HG3B+FR5
	WL	3,R3HG3B+FR6
	.word	ANI_WAITHITGND

	;hit.  stay.
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	.word	ANI_OFFSET,-7,0,0
	.word	ANI_ZEROVELS

	WL	10,R3RL1B+FR6	;20

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,rzr_facedown_getup_anim


 SUBR	rzr_break_neck4_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,60000h
	WLW	ANI_SET_XVEL,-28000h,AM_FACE_REL

	WL	6,R3HG3B+FR2
	WWWL	ANI_IFROPE,RC_EITHER,100,#fall_back4

	;roll over.
	WL	3,R3HG3B+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_OFFSET,10,0,0
	WL	3,R3HG3B+FR4
	.word	ANI_OFFSET,4,0,0
	WL	3,R3HG3B+FR5
	.word	ANI_OFFSET,9,0,0
	WL	3,R3HG3B+FR6
	.word	ANI_OFFSET,23,0,0
	WL	1,R3RL1B+FR6
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,rzr_facedown_getup_anim

#fall_back4
	;no room.  fall back
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_OFFSET,-11,0,0
	WL	5,R3HG3B+FR1
	.word	ANI_OFFSET,19,0,0
	WL	5,R3TD3A+FR9
	.word	ANI_OFFSET,-28,0,0
	.word	ANI_XFLIP
	WL	1,R3GU2A+FR1
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,rzr_facedown_getup_anim

#*****************************************************************************
*
* END OF BACK BROKEN SEQ.

 SUBR	rzr_backbroken_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
;	.word	ANI_DETACH

	.word	ANI_GRAVITY_OFF
	WL	5,R3BR3Z+FR3
	.word	ANI_GRAVITY_ON

	WL	ANI_SET_YVEL,040000h
	WLW	ANI_SET_ZVEL,20000h,AM_ABS

	WL	4,R3BR3Z+FR2
	WL	4,R3FD3B+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_BOUNCE,2
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_XFLIP

	WL	3,R3AM3D+FR2

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	3,R3AM3D+FR3
	WL	3,R3AM3D+FR4
	WL	3,R3AM3D+FR5
	WL	3,R3AM3D+FR6
	WL	3,R3AM3D+FR7
	WL	3,R3AM3D+FR1

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

;No stars around head here...

	.word	ANI_DETACH

	WL	10,R3AM3D+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,rzr_faceup_getup_anim
;	.word	ANI_END

#*****************************************************************************
*
* GENERIC BOUNCE

 SUBR	rzr_slamnobounce_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_FACE,MOVE_LEFT|MOVE_UP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	1,R3AM3D+FR1
	WL	3,R3AM3D+FR1
	WL	4,R3AM3D+FR2
	WL	4,R3AM3D+FR3
	WL	4,R3AM3D+FR4
	WL	4,R3AM3D+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	2,R3AM3D+FR7
	WL	10,R3AM3D+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,rzr_faceup_getup_anim


 SUBR	rzr_slambounce_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,040000h

	.word	ANI_FACE,MOVE_LEFT|MOVE_UP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	1,R3AM3D+FR1
	.ref	ckzpos
	WL	ANI_CODE,ckzpos
	WL	3,R3AM3D+FR1
	WL	4,R3AM3D+FR2
	WL	4,R3AM3D+FR3
	WL	4,R3AM3D+FR4
	WL	4,R3AM3D+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	2,R3AM3D+FR7
	WL	4,R3AM3D+FR1	;10

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,rzr_faceup_getup_anim

 SUBR	rzr_slambounce2_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_FACE,MOVE_LEFT|MOVE_UP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	1,R3AM3X+FR1
	WL	ANI_CODE,ckzpos
	WL	3,R3AM3X+FR1
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_XFLIP
	WL	ANI_SET_YVEL,030000h

	WL	4,R3AM3D+FR1
	WL	4,R3AM3D+FR2
	WL	4,R3AM3D+FR3
	WL	4,R3AM3D+FR4
	WL	4,R3AM3D+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	2,R3AM3D+FR7
	WL	10,R3AM3D+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,rzr_faceup_getup_anim

#*****************************************************************************

 SUBR	rzr_breakneck2_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYD_SWEAT,SWEAT_PER,0
	WL	4,R3FD3B+FR2
	.word	ANI_OFFSET,0,53,0			;x,y,z
	WL	4,R3FD3B+FR3
	WL	4,R3FD3B+FR4
	WL	1,R3FD3B+FR5

	.word	ANI_WAITHITGND

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,20

	WL	3,R3FD3B+FR6

	WL	3,R3HG3B+FR1
	WL	3,R3HG3B+FR2
	WL	3,R3HG3B+FR3
	WL	3,R3HG3B+FR4
	WL	3,R3HG3B+FR5
	WL	3,R3HG3B+FR6

	.word	ANI_ZERO_XZVELS
	WL	ANI_CODE,HIT_THE_MAT

	WL	8,R3RL1B+FR6

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,rzr_facedown_getup_anim

#*****************************************************************************

 SUBR	rzr_arm_broken_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_XVEL,-38000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,10000h,AM_HIT_REL

	WL	ANI_CODE,DO_SCREAM
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	4,R4AM4B+FR2
	WL	4,R4AM4B+FR3
	WL	4,R4AM4B+FR4
	WL	4,R4AM4B+FR5

	WL	1,R4ST4G+FR1
	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,rzr_fall_back_anim
;	.word	ANI_END

#nodead
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************

	.end
