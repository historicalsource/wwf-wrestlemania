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
* Software:		Jason Skiles
* Initiated:		26 Aug 94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"shnseq4.asm"
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
	.include	"shawnimg.h"
	.include	"takerimg.h"
	.include	"display.equ"
	.include	"ring.equ"

	.include	"damage.equ"


******************************************************************************
* EXTERNAL REFERENCES

	;MISC
	.ref	HIT_THE_MAT,SMALL_BOUNCE,set_position,set_skeleton_pal
	.ref	am_I_dizzy,start_smoke,D4SK4A,set_my_pal,make_white
	.ref	make_norm,am_I_dead,ckzpos

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* #3 LOSE BALANCE

#FRICTION_VAL	equ	3000h

 SUBR	shn_4_losebal_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_FRICTION,#FRICTION_VAL
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL

	WL	4,S4LB3A+FR1
	WL	4,S4LB3A+FR2
	WL	4,S4LB3A+FR3
	WL	4,S4LB3A+FR4
	WL	4,S4LB3A+FR5
	WL	4,S4LB3A+FR6
	WL	4,S4LB3A+FR7
	WL	4,S4LB3A+FR8
	WL	4,S4LB3A+FR9

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 HEAD HIT

 SUBR	shn_2_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off
	WL	3,S2AH3A+FR1
	WL	3,S2AH3A+FR2
	WL	3,S2AH3A+FR3
	WL	3,S2AH3A+FR4
	WL	3,S2AH3A+FR5
	WL	3,S2AH3A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 HEAD HIT

 SUBR	shn_4_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off
	WL	3,S4AH3D+FR1
	WL	3,S4AH3D+FR2
	WL	3,S4AH3D+FR3
	WL	3,S4AH3D+FR4
	WL	3,S4AH3D+FR5
	WL	3,S4AH3D+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************
*
* #2 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	shn_2_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

	WL	3,S2AH3A+FR1
	WL	15,S2AH3A+FR2
	WL	4,S2AH3A+FR3

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	shn_4_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

	WL	3,S4AH3D+FR1
	WL	3,S4AH3D+FR2
	WL	14,S4AH3D+FR3
	WL	2,S4AH3D+FR4

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


* #4 RUNNING BOUNCE OFF OF OPPONENT

;Bounce off but stay dizzy!

 SUBR	shn_4_bncoff_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	3,S4AH3D+FR1
	WL	3,S4AH3D+FR2
	WL	14,S4AH3D+FR3
	WL	2,S4AH3D+FR4

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,shn_dizzy_anim
	.word	ANI_END



#*****************************************************************************
*
* #2 HEAD HIT2 - Hands on face

 SUBR	shn_2_head_hit2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h
	.word	ANI_SETSPEED,100h

	WL	3,S2AE3A+FR1
	WL	3,S2AE3A+FR2
	WL	3,S2AE3A+FR3
	WL	3,S2AE3A+FR4
	WL	3,S2AE3A+FR5
	WL	3,S2AE3A+FR6
	WL	3,S2AE3A+FR7
	WL	3,S2AE3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 HEAD HIT2 - Hands on face

 SUBR	shn_4_head_hit2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h
	.word	ANI_SETSPEED,100h

	WL	3,S4AE3B+FR1
	WL	3,S4AE3B+FR2
	WL	3,S4AE3B+FR3
	WL	3,S4AE3B+FR4
	WL	3,S4AE3B+FR5
	WL	3,S4AE3B+FR6
	WL	3,S4AE3B+FR7
	WL	3,S4AE3B+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #2 HEAD HIT3 - From spin kick

 SUBR	shn_2_head_hit3_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,40000h

	WL	3,S2AH3A+FR1
	.word	ANI_DEBRIS,150,2,-21,100,0	;%chance, tbl index, x,y,z off
	WL	3,S2AH3A+FR2
	WL	3,S2AH3A+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,S2AH3A+FR4
	WL	3,S2AH3A+FR5
	WL	3,S2AH3A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 HEAD HIT3 - From spin kick

 SUBR	shn_4_head_hit3_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-20000h,AM_ABS
	WL	ANI_SET_YVEL,40000h

	WL	3,S4AH3D+FR1
	.word	ANI_DEBRIS,150,2,-21,100,0	;%chance, tbl index, x,y,z off
	WL	3,S4AH3D+FR2
	WL	3,S4AH3D+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,S4AH3D+FR4
	WL	3,S4AH3D+FR5
	WL	3,S4AH3D+FR6

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	shn_4_head_hit4_anim
;From earslap

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
;	WLW	ANI_SET_ZVEL,-20000h,AM_ABS
	WL	ANI_SET_YVEL,50000h

	WL	4,S4AH3D+FR3
;	.word	ANI_WAITHITGND
;	.word	ANI_ZEROVELS
	WL	4,S4AH3D+FR4
	WL	4,S4AH3D+FR5
	WL	4,S4AH3D+FR6


	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 HEAD HIT - ends in dizzy

 SUBR	shn_4_head_hit_dizzy_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WLW	ANI_SET_XVEL,-40000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h

	WL	3,S4AH3D+FR1
	.word	ANI_DEBRIS,150,2,-21,100,0	;%chance, tbl index, x,y,z off
	WL	3,S4AH3D+FR2
	WL	3,S4AH3D+FR3
	WL	3,S4AH3D+FR4
	WL	3,S4AH3D+FR5
	WL	3,S4AH3D+FR6

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,shn_dizzy_anim
	.word	ANI_END


#*****************************************************************************
*
* #2 BODY HIT

 SUBR	shn_2_body_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL

	.word	ANI_DEBRIS,150,0,-4,71,0	;%chance, tbl index, x,y,z off
	WL	3,S2AM3A+FR2
	WL	3,S2AM3A+FR3
	WL	1,S2AM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,S2AM3A+FR5
	WL	3,S2AM3A+FR6
	WL	3,S2AM3A+FR7
	WL	3,S2AM3A+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	shn_2_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-40000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,8000h,AM_ABS

	.word	ANI_DEBRIS,150,0,-4,71,0	;%chance, tbl index, x,y,z off
	WL	3,S2AM3A+FR2
	WL	3,S2AM3A+FR3
	WL	1,S2AM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,S2AM3A+FR5
	WL	3,S2AM3A+FR6
	WL	3,S2AM3A+FR7
	WL	3,S2AM3A+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 BODY HIT

 SUBR	shn_4_body_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL

	.word	ANI_DEBRIS,150,0,-4,71,0	;%chance, tbl index, x,y,z off
	WL	3,S4AM3A+FR2
	WL	3,S4AM3A+FR3
	WL	1,S4AM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,S4AM3A+FR5
	WL	3,S4AM3A+FR6
	WL	3,S4AM3A+FR7
	WL	3,S4AM3A+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	shn_4_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-40000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-8000h,AM_ABS

	.word	ANI_DEBRIS,150,0,-4,71,0	;%chance, tbl index, x,y,z off
	WL	3,S4AM3A+FR2
	WL	3,S4AM3A+FR3
	WL	1,S4AM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,S4AM3A+FR5
	WL	3,S4AM3A+FR6
	WL	3,S4AM3A+FR7
	WL	3,S4AM3A+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	shn_4_body_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	.word	ANI_DEBRIS,150,0,-4,71,0	;%chance, tbl index, x,y,z off
	WL	3,S4AM3A+FR2
	WL	3,S4AM3A+FR3
	WL	1,S4AM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,S4AM3A+FR5
	WL	3,S4AM3A+FR6
	WL	3,S4AM3A+FR7
	WL	3,S4AM3A+FR8

	.word	ANI_FACEDOWN
	WL	ANI_CHANGEANIM,shn_dizzy_anim
	.word	ANI_END

 SUBR	shn_4_knee_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-8000h,AM_ABS
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	.word	ANI_DEBRIS,150,0,-4,71,0	;%chance, tbl index, x,y,z off
	WL	3,S4AM3A+FR2
	WL	3,S4AM3A+FR3
	WL	1,S4AM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,S4AM3A+FR5
	WL	3,S4AM3A+FR6
	WL	3,S4AM3A+FR7
	WL	3,S4AM3A+FR8

	.word	ANI_FACEDOWN
	WL	ANI_CHANGEANIM,shn_dizzy_anim
	.word	ANI_END

 SUBR	shn_quick_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h

	WL	3,S4AM3A+FR2
	WL	3,S4AM3A+FR3
	WL	3,S4AM3A+FR4
	WL	3,S4AM3A+FR5
	WL	3,S4AM3A+FR6
	WL	3,S4AM3A+FR7
	WL	3,S4AM3A+FR8

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,shn_fall_back_anim
	.word	ANI_END

#nodead

	.word	ANI_FACEDOWN
	WL	ANI_CHANGEANIM,shn_3_head_held_anim

#*****************************************************************************
*
* HITS ON GROUND

 SUBR	shn_hitonground_xflip_anim
	.word	ANI_XFLIP

 SUBR	shn_hitonground_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h
	WL	1,S3CP3B+FR1
	WL	ANI_SET_YVEL,40000h
	WL	ANI_CODE,ckzpos
	WL	2,S3CP3B+FR1
	WL	3,S3CP3B+FR2
	.word	ANI_DEBRIS,50,1,0,8,0		;%chance, tbl index, x,y,z off
	WL	3,S3CP3B+FR3
	WL	3,S3CP3B+FR4
	WL	3,S3CP3B+FR5
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,S3CP3B+FR6
	WL	3,S3CP3B+FR7
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,shn_faceup_getup_anim

#*****************************************************************************
*
* #2 BLOCK + HITBLOCK

 SUBR	shn_2_block_anim

	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT
	.word	ANI_SETPLYRMODE,MODE_BLOCK
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING
	.word	ANI_SET_WRESTLER_XFLIP
;Rotate toward opponent if needed!

	WL	3,S2BK3C+FR1
	WL	3,S2BK3C+FR2
	WL	3,S2BK3C+FR3
#hold_block
	.word	ANI_SETMODE,MODE_NOAUTOFLIP		;turn off UNINT
	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT
	WL	3,S2BK3C+FR2
	WL	3,S2BK3C+FR1
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


 SUBR	shn_2_hitblock_anim
	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT
	.word	ANI_FRICTION,3000h
	.word	ANI_SETSPEED,100h
	WL	3,S2BK3C+FR4
	WL	3,S2BK3C+FR5
	WL	3,S2BK3C+FR6
	WL	3,S2BK3C+FR3
	WL	ANI_GOTO,#hold_block


#************
*
* #4 BLOCK + HITBLOCK

 SUBR	shn_4_block_anim

	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT
	.word	ANI_SETPLYRMODE,MODE_BLOCK
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
;Rotate toward opponent if needed!

	WL	3,S4BK3A+FR1
	WL	3,S4BK3A+FR2
#hold_block
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT
	WL	3,S4BK3A+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


 SUBR	shn_4_hitblock_anim
	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT
	.word	ANI_FRICTION,3000h
	.word	ANI_SETSPEED,100h
	WL	3,S4BK3A+FR3
	WL	3,S4BK3A+FR4
	WL	3,S4BK3A+FR5
	WL	3,S4BK3A+FR2
	WL	ANI_GOTO,#hold_block


#*****************************************************************************
*
* FALL BACK

 SUBR	shn_fall_back_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,50000h		;70000h
	WL	ANI_CODE,ckzpos

	WWL	ANI_SETLONG,DEBRIS_X,[105,-19]	;Y,X of head
	WL	3,S3UC3X+FR1
	.word	ANI_OFFSET,0,58,0
	WWL	ANI_SETLONG,DEBRIS_X,[44,-29]	;Y,X of head
	WL	3,S3UC3X+FR2
	WWL	ANI_SETLONG,DEBRIS_X,[37,-36]	;Y,X of head
	WL	3,S3UC3X+FR3
	WWL	ANI_SETLONG,DEBRIS_X,[29,-40]	;Y,X of head
	WL	3,S3UC3X+FR4
	WWL	ANI_SETLONG,DEBRIS_X,[19,-40]	;Y,X of head
	WL	3,S3UC3X+FR5
	WWL	ANI_SETLONG,DEBRIS_X,[6,-38]	;Y,X of head
	WL	3,S3UC3X+FR6
	.word	ANI_WAITHITGND

	.word	ANI_DEBRIS,100,1,0,8,0		;%chance, tbl index, x,y,z off
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,35

	.word	ANI_FRICTION,3000h

	WWL	ANI_SETLONG,DEBRIS_X,[5,-38]	;Y,X of head
	WL	2,S3UC3X+FR7
	.word	ANI_BOUNCE,5
	WL	1,S3UC3X+FR7
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE

	.word	ANI_ZEROVELS
	WWL	ANI_SETLONG,DEBRIS_X,[6,-40]	;Y,X of head
	WL	3,S3UC3X+FR8
	WWL	ANI_SETLONG,DEBRIS_X,0		;Y,X of head

	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP

	.word	ANI_XFLIP
	WL	6,S3CP3B+FR7

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,shn_faceup_getup_anim

#*****************************************************************************
*
* FALL BACK

 SUBR	shn_fall_back2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;This is currently set in react1 - hit_flykick
;	WLW	ANI_SET_XVEL,-0C0000h,AM_HIT_REL

	WL	ANI_SET_YVEL,10000h		;70000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS
	WL	ANI_CODE,ckzpos

	WL	3,S3UC3X+FR1
	.word	ANI_OFFSET,0,58,0
	WL	3,S3UC3X+FR2
	WL	3,S3UC3X+FR3
	WL	3,S3UC3X+FR4
	WL	3,S3UC3X+FR5
;	WL	3,S3UC3X+FR6
	.word	ANI_WAITHITGND

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,35
	.word	ANI_ZEROVELS		
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	WLW	ANI_SET_XVEL,-30000h,AM_FACE_REL

	WL	3,S3FD3X+FR1
	WL	3,S3FD3X+FR2
	WL	3,S3FD3X+FR3
	WL	3,S3FD3X+FR4
	WL	3,S3FD3X+FR5
	WL	3,S3FD3X+FR6
	WL	3,S3FD3X+FR7

	.word	ANI_ZEROVELS		
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	3,S3CF3Z+FR1
	WL	3,S3CF3Z+FR2
	WL	3,S3CF3Z+FR3
	WL	3,S3CF3Z+FR4
	WL	3,S3CF3Z+FR5
	WL	3,S3CF3Z+FR6

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT

	WL	ANI_CHANGEANIM,shn_faceup_getup_anim
	.word	ANI_END


#*****************************************************************************

 SUBR	shn_fall_back3_anim	;shawn fliptoss

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,60000h
	WLW	ANI_SET_XVEL,-28000h,AM_FACE_REL

	WL	3,S3FD3X+FR1
	.word	ANI_OFFSET,12,0,0
	WL	3,S3FD3X+FR2
	.word	ANI_OFFSET,9,0,0
	WL	3,S3FD3X+FR3
	.word	ANI_OFFSET,10,0,0

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,SMALL_BOUNCE

	WL	ANI_CHANGEANIM,shn_break_neck3_anim


#*****************************************************************************
*
* FALL FROM TURNBUCKLE

 SUBR	shn_fall_back_tbukl_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETSPEED,100h

	WL	3,S3UC3X+FR1
	.word	ANI_OFFSET,0,58,0
	WL	3,S3UC3X+FR2
	WL	3,S3UC3X+FR3
	WL	3,S3UC3X+FR4
	WL	3,S3UC3X+FR5
	WL	3,S3UC3X+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_DAMAGE,D_HITCONCRETE

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,35

;	.word	ANI_FRICTION,3000h

	WL	2,S3UC3X+FR7
;	.word	ANI_BOUNCE,5
	WL	1,S3UC3X+FR7
;	.word	ANI_WAITHITGND
;	WL	ANI_CODE,SMALL_BOUNCE

;	.word	ANI_ZEROVELS		
	WL	3,S3UC3X+FR8

	.word	ANI_XFLIP
	WL	12,S3CP3B+FR7

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,shn_faceup_getup_anim

#*****************************************************************************
*
* GETUPS

 SUBR	shn_faceup_getup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	WL	4,S3GU2A+FR1
	WL	ANI_CODE,choose_2or4
	WL	ANI_IFSTATUS,#getup_in_4

#getup_in_2
	WL	4,S3GU2A+FR2
	WL	4,S3GU2A+FR3
	WL	4,S3GU2A+FR4
	WL	4,S3GU2A+FR5
	WL	4,S3GU2A+FR6
	WL	4,S3GU2A+FR7

	WL	2,S3GU2A+FR8
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,S3GU2A+FR8
	WL	4,S3GU2A+FR9
	.word	ANI_FACEUP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#getup_in_4
	WL	4,S3GU4A+FR2
	WL	4,S3GU4A+FR3
#g4_frame_4
	WL	4,S3GU4A+FR4
	WL	4,S3GU4A+FR5
	WL	4,S3GU4A+FR6
	WL	4,S3GU4A+FR7

	WL	2,S3GU4A+FR8
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,S3GU4A+FR8
	WL	4,S3GU4A+FR9
	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


 SUBR	shn_faceup_getup2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	WL	ANI_GOTO,#g4_frame_4

*****
* set status bit for a getup in 4, clear for a 2.
 SUBR	choose_2or4

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
* DIZZY

 SUBR	shn_dizzy_anim

	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_START_DIZZY,0	;0=Standing dizzy
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

#loop

	WL	9,S4TI4B+FR1
	WL	9,S4TI4B+FR2
	WL	9,S4TI4B+FR3
	WL	9,S4TI4B+FR4
	WL	9,S4TI4B+FR3
	WL	9,S4TI4B+FR2

	WL	ANI_GOTO,#loop


#*****************************************************************************
*
* HELD OVERHEAD ANIMATION

 SUBR	shn_heldoh_anim

	.word	ANI_SETPLYRMODE,MODE_ATTACHED
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_SETSPEED,100h

	.word	ANI_SETWORD,USR_VAR1,0		;loop count

#loop
	WL	4,S3MF3B+FR1
	WL	4,S3MF3B+FR2
	WL	4,S3MF3B+FR3
	WL	4,S3MF3B+FR4
	WL	4,S3MF3B+FR5
	WL	4,S3MF3B+FR6
	WL	4,S3MF3B+FR7

	WL	ANI_CODE,#inc_loop
	WL	ANI_IFNOTSTATUS,#loop

;Fall out of overhead hold by reversing thru pickup frames
	.word	ANI_DETACH

	.word	ANI_SETMODE,MODE_NORMAL|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_INAIR

	WL	ANI_SET_YVEL,10000h
	WLW	ANI_SET_XVEL,-40000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,10000h,AM_ABS
	.word	ANI_FRICTION,3000h

	WL	2,S3MF3B+FR6
	.word	ANI_OFFSET,-20,-50,0			;x,y,z
	WL	5,S3MS3Z+FR4
	WL	5,S3MS3Z+FR2
	WL	5,S3MS3Z+FR1
	.word	ANI_WAITHITGND
	WL	2,S2ST2C+FR1

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

;Loop 4 times, then break out!
#inc_loop
	move	*a13(USR_VAR1),a0
	inc	a0
	move	a0,*a13(USR_VAR1)
	cmpi	3,a0
	jrgt	#breakout
	
;	move	*a13(ATTACH_PROC),a0,L
;	jrz	#breakout

	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets

#breakout
	move	*a13(ANIMODE),a1
	ori	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets


#*****************************************************************************
*
* ROLL OVER AND BREAK YER STINKIN' NECK

 SUBR	shn_break_neck_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WL	9,S3FD3X+FR4
	WL	ANI_GOTO,#common

 SUBR	shn_break_neck3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

#common
	WWWL	ANI_IFROPE,RC_EITHER,100,#fall_back

	;plenty o' room.  roll over
	WL	3,S3FD3X+FR4
	.word	ANI_OFFSET,9,0,0
	WL	3,S3FD3X+FR5
	.word	ANI_OFFSET,8,0,0
	WL	3,S3FD3X+FR6
	.word	ANI_OFFSET,12,0,0
	WL	3,S3FD3X+FR7
	.word	ANI_OFFSET,-2,0,0
	WL	3,S3FD3X+FR8

	;hit.  stay.
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_OFFSET,6,0,0
	WL	12,S3RL3A+FR5

	.word	ANI_FACEDOWN
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,shn_faceup_getup_anim

#fall_back
	;too close to the ropes.  fall back
	WL	6,S3FD3X+FR3
	.word	ANI_OFFSET,-9,0,0
	WL	5,S3FD3X+FR2
	.word	ANI_ZEROVELS
	.word	ANI_OFFSET,-10,0,0
	WL	4,S3FD3X+FR1
	WL	3,S3UC3X+FR8
	.word	ANI_XFLIP
	WL	18,S3CP3B+FR7
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,shn_faceup_getup_anim
	

 SUBR	shn_break_neck2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,60000h
	WL	ANI_CODE,ckzpos
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim

	.word	ANI_XFLIP
	WL	4,S3GP3X+FR7
	WL	4,S3FD3X+FR3
	WL	4,S3FD3X+FR4
	WL	4,S3FD3X+FR5
	WL	4,S3FD3X+FR6
	WL	4,S3FD3X+FR7
	.word	ANI_WAITHITGND
	WL	4,S3FD3X+FR8

	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	10,S3RL3A+FR5
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,shn_faceup_getup_anim

 SUBR	shn_break_neck4_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,58000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	WL	ANI_CODE,ckzpos

	.word	ANI_DEBRIS,300,5,0,-5,0	;%chance, tbl index, x,y,z off

	WL 	15,S4POGO+FR3
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim

	.word	ANI_XFLIP
	WL	3,S3FD3X+FR2
	WL	3,S3FD3X+FR3
	WL	3,S3FD3X+FR4
	WL	3,S3FD3X+FR5
	WL	3,S3FD3X+FR6
	WL	3,S3FD3X+FR7
	.word	ANI_WAITHITGND
	WL	3,S3FD3X+FR8

	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	10,S3RL3A+FR5
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,shn_faceup_getup_anim


#*****************************************************************************
*
* THROWN FROM RING (shn_bslm, shn_frnk)

 SUBR	shn_flyout_anim		;starts on OSX7

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETSPEED,100h

	WL	8,S3OS3X+FR7
	.word	ANI_OFFSET,0,10,0
	WL	8,S3OS3X+FR8
	.word	ANI_OFFSET,0,10,0
	WL	ANI_GOTO,#common

 SUBR	shn_flyout2_anim	;starts on OSX9

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETSPEED,100h

#common
	WL	1,S3OS3X+FR9
	.word	ANI_WAITHITGND

	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,60

	.word	ANI_DAMAGE,D_HIPTOSS
	.word	ANI_SETWORD,DELAY_METER,0
	.word	ANI_GETUP,500

	WL	3,S3OS3X+FR10
	WL	ANI_CHANGEANIM,shn_hitonground_anim

#*****************************************************************************
*
* GET BUZZED FROM DOINK

 SUBR	shn_get_buzz_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;	.word	ANI_XFLIP
	.word	ANI_GRAVITY_OFF

	WL	ANI_CODE,set_position

	WL	ANI_CODE,set_skeleton_pal
	WL	2,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,S4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	ANI_CODE,make_white
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_norm
	WL	ANI_CODE,set_my_pal
	WL	3,S4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,S4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_white
	WL	3,S4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,S4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,S4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	ANI_CODE,make_white
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_norm
	WL	ANI_CODE,set_my_pal
	WL	3,S4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	ANI_CODE,start_smoke

	.word	ANI_DETACH

	.word	ANI_GRAVITY_ON
	WL	ANI_SET_YVEL,60000h
	WLW	ANI_SET_XVEL,-30000h,AM_FACE_REL
	WLW	ANI_SET_ZVEL,20000h,AM_ABS
	WL	ANI_CODE,#make_black
	WL	3,S4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,S4BZ4A+FR1
	WL	ANI_CODE,#make_black
	WL	3,S4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,S4BZ4A+FR1
	WL	ANI_CODE,#make_black
	WL	3,S4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,S4BZ4A+FR1

	.word	ANI_WAITHITGND
	.word	ANI_XFLIP
	.word	ANI_FACEDOWN
	.word	ANI_OFFSET,-20,0,0			;x,y,z

	WL	1,S4ST4C+FR1

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,shn_fall_back_anim
	.word	ANI_END

#nodead

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#make_black

;This is a black color within the wrestler's pal.  It is different for each
;wrestler.
	movi	2121h,a14

	move	a14,*a13(OBJ_CONST)
	move	*a13(OBJ_CONTROL),a14
	andni	01111b,a14
	ori	M_CONNON,a14
	move	a14,*a13(OBJ_CONTROL)
	rets

#*****************************************************************************

 SUBR	shn_3_head_held_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_HEADHELD
	.word	ANI_SETFACING

	.word	ANI_SETWORD,USR_VAR1,0		;loop count

#loop
	WL	4,S3BF3A+FR1
	WL	4,S3BF3A+FR2
	WL	4,S3BF3A+FR3
	WL	4,S3BF3A+FR4
	WL	4,S3BF3A+FR5
	WL	4,S3BF3A+FR6
	WL	4,S3BF3A+FR7
	WL	ANI_CODE,#inc_loop
	WL	ANI_IFNOTSTATUS,#loop

;Continue into break...

 SUBR	shn_3_head_held_brk_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WLW	ANI_SET_XVEL,-38000h,AM_NEWFACE_REL
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	WL	4,S4BF3A+FR2
	.word	ANI_DETACH

;Standard #2 head hit from spin kick
	WL	3,S2AH3A+FR1
	WL	3,S2AH3A+FR2
	WL	3,S2AH3A+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,S2AH3A+FR4
	WL	3,S2AH3A+FR5
	WL	3,S2AH3A+FR6

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


;Loop 4 times, then break out!
#inc_loop
	move	*a13(USR_VAR1),a0
	inc	a0
	move	a0,*a13(USR_VAR1)
	cmpi	4,a0
	jrgt	#breakout
	
;He may have let me go by hitting his block butn!
;Handled in mode_headheld!
;	move	*a13(ATTACH_PROC),a0,L
;	jrz	#breakout

	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets

#breakout
	move	*a13(ANIMODE),a1
	ori	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets

 SUBR	shn_3_head_held_stand_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	4,S4BF3A+FR2
	WL	3,S1TT5Z+FR2	;2.5
	.word	ANI_DETACH

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


	
#*****************************************************************************

 SUBR	shn_frnk_backfire_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_INAIR

	.word	ANI_ZEROVELS

	WL	5,S3ZI3A+FR8
	WL	5,S3ZI3A+FR9
	WL	5,S3ZI3A+FR10
	.word	ANI_WAITHITGND

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SOUND,33h
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,35
	.word	ANI_SOUND,0BFh
	.word	ANI_SOUND,0C1h			;plywood crash #3

	WL	ANI_CHANGEANIM,shn_break_neck3_anim

#*****************************************************************************

 SUBR	shn_arm_broken_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_XVEL,-38000h,AM_HIT_REL

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,S3AB3A+FR5
	WL	3,S3AB3A+FR6
	WL	3,S3AB3A+FR7
	WL	3,S3AB3A+FR8

	WL	3,S4AE3B+FR5
	WL	3,S4AE3B+FR6
	WL	3,S4AE3B+FR7
	WL	3,S4AE3B+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* END OF BACK BROKEN SEQ.

 SUBR	shn_backbroken_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_DETACH

	.word	ANI_GRAVITY_OFF
	WL	5,S3BR3Z+FR3
	.word	ANI_GRAVITY_ON

	WL	ANI_SET_YVEL,070000h
	WLW	ANI_SET_ZVEL,20000h,AM_ABS

	WL	21,S3BR3Z+FR3

	WL	4,S3BR3Z+FR2
;	WL	4,S3BR3Z+FR5
	WL	4,S3UC3X+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_BOUNCE,2
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_XFLIP

	WL	3,S3CP3B+FR1
	WL	3,S3CP3B+FR2
	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off
	WL	3,S3CP3B+FR3
	WL	3,S3CP3B+FR4
	WL	3,S3CP3B+FR5
	WL	3,S3CP3B+FR6
	WL	3,S3CP3B+FR7

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

;No stars around head here...

	.word	ANI_DETACH

	WL	1,S3CP3B+FR7

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,shn_faceup_getup_anim
	.word	ANI_END

#*****************************************************************************
*
* GENERIC BOUNCE

 SUBR	shn_slambounce_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,040000h
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	1,S3CP3B+FR2
	.ref	ckzpos
	WL	ANI_CODE,ckzpos
	WL	3,S3CP3B+FR2
	WL	4,S3CP3B+FR3

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	4,S3CP3B+FR6
	WL	10,S3CP3B+FR7

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,shn_faceup_getup_anim

 SUBR	shn_slambounce2_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,040000h
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	1,S3UC3Z+FR8
	WL	ANI_CODE,ckzpos
	WL	3,S3UC3Z+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_XFLIP
	WL	ANI_SET_YVEL,030000h

	WL	4,S3CP3B+FR2
	WL	4,S3CP3B+FR3

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	4,S3CP3B+FR6
	WL	10,S3CP3B+FR7

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,shn_faceup_getup_anim

#*****************************************************************************

 SUBR	shn_breakneck2_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;;	.word	ANI_OFFSET,0,51,0			;x,y,z

	WL	4,S3UC3X+FR2
	WL	4,S3UC3X+FR3
	WL	4,S3UC3X+FR4
	WL	4,S3UC3X+FR5
	WL	1,S3UC3X+FR6

	.word	ANI_WAITHITGND

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,20

	WL	3,S3FD3X+FR1
	WL	3,S3FD3X+FR2
	WL	3,S3FD3X+FR3
	WL	3,S3FD3X+FR4
	WL	3,S3FD3X+FR5
	WL	3,S3FD3X+FR6
	WL	3,S3FD3X+FR7
	WL	3,S3FD3X+FR8

	.word	ANI_ZERO_XZVELS

;;;	.word	ANI_XFLIP

	WL	8,S3RL3A+FR5

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,shn_faceup_getup_anim

******************************************************************************
	.end
