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
* Initiated:		5/17/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"hrtseq3.asm"
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

	.include	"bretimg.h"
	.include	"bamimg.h"

	.include	"display.equ"
	.include	"damage.equ"



******************************************************************************
* EXTERNAL REFERENCES


	.REF	SMALL_BOUNCE
	.REF	HIT_THE_MAT
	.ref	D4SK4A

	.ref	set_position
	.ref	set_skeleton_pal
	.ref	am_I_dizzy
	.ref	start_smoke
	.ref	set_my_pal
	.ref	make_white
	.ref	make_norm

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* #2 BLOCK & HITBLOCK

 SUBR	hrt_2_block_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_FRICTION,3000h
	WLW	ANI_SET_ZVEL,0,AM_ABS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
;Rotate toward opponent if needed!
	.word	ANI_SETPLYRMODE,MODE_BLOCK
	WL	4,H2BK3A+FR1
	WL	10,H2BK3A+FR2
#2block
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	WL	1,H2BK3A+FR2
	.word	ANI_ZERO_XZVELS
	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	4,H2BK3A+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_2_hitblock_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h
	WL	4,H2BK3A+FR4
	WL	4,H2BK3A+FR3
	WL	ANI_GOTO,#2block

#************
*
* #4 BLOCK & HITBLOCK

 SUBR	hrt_4_block_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_FRICTION,3000h
	WLW	ANI_SET_ZVEL,0,AM_ABS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
;Rotate toward opponent if needed!
	.word	ANI_SETPLYRMODE,MODE_BLOCK
	WL	4,H4BK3A+FR1
	WL	10,H4BK3A+FR2
#4block
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	WL	1,H4BK3A+FR2
	.word	ANI_ZERO_XZVELS
	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	WL	4,H4BK3A+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_hitblock_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h
	WL	4,H4BK3A+FR4
	WL	4,H4BK3A+FR3
	WL	ANI_GOTO,#4block


#*****************************************************************************
*
* #2 HEAD HIT

 SUBR	hrt_2_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

	WL	3,H2AH3A+FR1
	WL	3,H2AH3A+FR2
	WL	3,H2AH3A+FR3
	WL	3,H2AH3A+FR4
	WL	3,H2AH3A+FR5
	WL	3,H2AH3A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_2_head_hit3_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,40000h

	.word	ANI_DEBRIS,300,2,-21,100,0	;%chance, tbl index, x,y,z off

	WL	3,H2AH3A+FR1
	WL	4,H2AH3A+FR2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	4,H2AH3A+FR3
	WL	3,H2AH3A+FR4
	WL	3,H2AH3A+FR5
	WL	3,H2AH3A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 HEAD HIT

 SUBR	hrt_4_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

	WL	3,H4AH3A+FR1
	WL	3,H4AH3A+FR2
	WL	3,H4AH3A+FR3
	WL	3,H4AH3A+FR4
	WL	3,H4AH3A+FR5
	WL	3,H4AH3A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_head_hit3_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-20000h,AM_ABS
	WL	ANI_SET_YVEL,40000h

	.word	ANI_DEBRIS,300,2,-21,100,0	;%chance, tbl index, x,y,z off

	WL	3,H4AH3A+FR1
	WL	4,H4AH3A+FR2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	4,H4AH3A+FR3
	WL	3,H4AH3A+FR4
	WL	3,H4AH3A+FR5
	WL	3,H4AH3A+FR6

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_head_hit4_anim
;From earslap

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
;	WLW	ANI_SET_ZVEL,-20000h,AM_ABS
	WL	ANI_SET_YVEL,40000h

	WL	4,H4AH3A+FR2
;	.word	ANI_WAITHITGND
;	.word	ANI_ZEROVELS
	WL	4,H4AH3A+FR3
	WL	4,H4AH3A+FR4
	WL	4,H4AH3A+FR5
	WL	4,H4AH3A+FR6

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 HEAD HIT2 (HANDS ON FACE)

 SUBR	hrt_2_head_hit2_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h

	WL	4,H2AE3A+FR1
	WL	4,H2AE3A+FR2
	WL	4,H2AE3A+FR3
	WL	4,H2AE3A+FR4
	WL	4,H2AE3A+FR5
	WL	4,H2AE3A+FR6
	WL	4,H2AE3A+FR7
	WL	4,H2AE3A+FR8

;;	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 HEAD HIT2 (HANDS ON FACE)

 SUBR	hrt_4_head_hit2_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h

	WL	4,H4AE3A+FR1
	WL	4,H4AE3A+FR2
	WL	4,H4AE3A+FR3
	WL	4,H4AE3A+FR4
	WL	4,H4AE3A+FR5
	WL	4,H4AE3A+FR6
	WL	4,H4AE3A+FR7
	WL	4,H4AE3A+FR8

;;	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	.word	ANI_FACEDOWN

       	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 HEAD HIT2 (ENDS IN DIZZY)

 SUBR	hrt_4_head_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	.word	ANI_DEBRIS,300,3,-21,100,0	;%chance, tbl index, x,y,z off

	WL	4,H4AE3A+FR1
	WL	4,H4AE3A+FR2
	WL	4,H4AE3A+FR3
	WL	4,H4AE3A+FR4
	WL	4,H4AE3A+FR5
	WL	4,H4AE3A+FR6
	WL	4,H4AE3A+FR7
	WL	4,H4AE3A+FR8

	.word	ANI_FACEDOWN
;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,hrt_dizzy_anim

	.word	ANI_END

******************************************************************************
*
* #2 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	hrt_2_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

	WL	3,H2AH3A+FR1
	WL	15,H2AH3A+FR2
	WL	4,H2AH3A+FR3

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	hrt_4_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

	WL	3,H4AH3A+FR1
	WL	3,H4AH3A+FR2
	WL	14,H4AH3A+FR3
	WL	2,H4AH3A+FR4

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


* #4 RUNNING BOUNCE OFF OF OPPONENT

;Bounce off but stay dizzy!

 SUBR	hrt_4_bncoff_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	3,H4AH3A+FR1
	WL	3,H4AH3A+FR2
	WL	14,H4AH3A+FR3
	WL	2,H4AH3A+FR5

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,hrt_dizzy_anim
	.word	ANI_END



#*****************************************************************************
*
* #2 BODY HIT

 SUBR	hrt_2_body_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL

	.word	ANI_DEBRIS,300,0,-4,71,0	;%chance, tbl index, x,y,z off

	WL	4,H2AM3A+FR1
	WL	4,H2AM3A+FR2
	WL	4,H2AM3A+FR3

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	4,H2AM3A+FR4
	WL	4,H2AM3A+FR5
	WL	4,H2AM3A+FR6
	WL	4,H2AM3A+FR7
	WL	4,H2AM3A+FR8

	.word	ANI_FACEUP
	
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

; SUBR	hrt_2_body_hit_dizzy_anim
;
;	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_ZEROVELS
;	.word	ANI_SETSPEED,100h
;	WL	ANI_SET_YVEL,48000h
;	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
;
;	WL	4,H2AM3A+FR1
;	WL	4,H2AM3A+FR2
;	WL	4,H2AM3A+FR3
;
;	.word	ANI_WAITHITGND
;	.word	ANI_ZEROVELS
;
;	WL	4,H2AM3A+FR4
;	WL	4,H2AM3A+FR5
;	WL	4,H2AM3A+FR6
;	WL	4,H2AM3A+FR7
;	WL	4,H2AM3A+FR8
;
;	.word	ANI_SETPLYRMODE,MODE_DIZZY
;	WL	ANI_CHANGEANIM,hrt_dizzy_anim
;	.word	ANI_END

#************
*
* #4 BODY HIT

 SUBR	hrt_4_body_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL

	.word	ANI_DEBRIS,300,0,-4,71,0	;%chance, tbl index, x,y,z off

	WL	4,H4AM3A+FR1
	WL	4,H4AM3A+FR2
	WL	4,H4AM3A+FR3

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	4,H4AM3A+FR4
	WL	4,H4AM3A+FR5
	WL	4,H4AM3A+FR6
	WL	4,H4AM3A+FR7
	WL	4,H4AM3A+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_body_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	.word	ANI_DEBRIS,300,0,-4,71,0	;%chance, tbl index, x,y,z off

	WL	4,H4AM3A+FR1
	WL	4,H4AM3A+FR2
	WL	4,H4AM3A+FR3

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	4,H4AM3A+FR4
	WL	4,H4AM3A+FR5
	WL	4,H4AM3A+FR6
	WL	4,H4AM3A+FR7
	WL	4,H4AM3A+FR8

	.word	ANI_FACEDOWN
;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,hrt_dizzy_anim
	.word	ANI_END




 SUBR	hrt_2_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,04000h,AM_ABS

	.word	ANI_DEBRIS,300,0,-4,71,0	;%chance, tbl index, x,y,z off

	WL	4,H2AM3A+FR1
	WL	4,H2AM3A+FR2
	WL	4,H2AM3A+FR3

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	4,H2AM3A+FR4
	WL	4,H2AM3A+FR5
	WL	4,H2AM3A+FR6
	WL	4,H2AM3A+FR7
	WL	4,H2AM3A+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-04000h,AM_ABS

	.word	ANI_DEBRIS,300,0,-4,71,0	;%chance, tbl index, x,y,z off

	WL	4,H4AM3A+FR1
	WL	4,H4AM3A+FR2
	WL	4,H4AM3A+FR3

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	4,H4AM3A+FR4
	WL	4,H4AM3A+FR5
	WL	4,H4AM3A+FR6
	WL	4,H4AM3A+FR7
	WL	4,H4AM3A+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_knee_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,08000h,AM_ABS
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	.word	ANI_DEBRIS,300,0,-4,71,0	;%chance, tbl index, x,y,z off

	WL	4,H4AM3A+FR1
	WL	4,H4AM3A+FR2
	WL	4,H4AM3A+FR3

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	4,H4AM3A+FR4
	WL	4,H4AM3A+FR5
	WL	4,H4AM3A+FR6
	WL	4,H4AM3A+FR7
	WL	4,H4AM3A+FR8

	.word	ANI_OFFSET,0,0,0			;x,y,z

	.word	ANI_FACEDOWN
;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,hrt_dizzy_anim
	.word	ANI_END


;Being held by head, hit by a quick knee!
 SUBR	hrt_quick_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_OFFSET,0,0,2			;x,y,z

	WL	4,H2AM3A+FR1
	WL	4,H2AM3A+FR2
	WL	4,H2AM3A+FR3
	WL	4,H2AM3A+FR4

	.word	ANI_WAITHITGND
	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,hrt_fall_back_anim
	.word	ANI_END

#nodead
	.ref	hrt_3_head_held_anim

	WL	ANI_CHANGEANIM,hrt_3_head_held_anim

	.word	ANI_END




#*****************************************************************************
*
* HITS ON GROUND

 SUBR	hrt_hitonground_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,39000h

	.word	ANI_DEBRIS,50,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	3,H2CP3A+FR1
	WL	3,H2CP3A+FR2
	WL	3,H2CP3A+FR3
	WL	3,H2CP3A+FR4
	WL	3,H2CP3A+FR5
	WL	3,H2CP3A+FR6
	WL	3,H2CP3A+FR7
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,H2CP3A+FR8
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim


 SUBR	hrt_hitonground_facedown_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h

	.word	ANI_BOUNCE,3

	.word	ANI_DEBRIS,100,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	3,H3MS3X+FR1
	WL	3,H3MS3X+FR2
	WL	3,H3MS3X+FR3
	WL	3,H3MS3X+FR4
	WL	3,H3MS3X+FR5
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim

;MJT Start
#*****************************************************************************
*
* FALL BACK

 SUBR	hrt_fall_back_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,60000h

	.ref	ckzpos
	WL	ANI_CODE,ckzpos

	WWL	ANI_SETLONG,DEBRIS_X,[99,-10]	;Y,X of head
	WL	4,H3UC3X+FR1

	.word	ANI_OFFSET,0,45,0			;x,y,z
	WWL	ANI_SETLONG,DEBRIS_X,[44,-38]	;Y,X of head
	WL	4,H3UC3X+FR2
	WWL	ANI_SETLONG,DEBRIS_X,[38,-39]	;Y,X of head
	WL	4,H3UC3X+FR3
	WWL	ANI_SETLONG,DEBRIS_X,[33,-39]	;Y,X of head
	WL	4,H3UC3X+FR4

	WWL	ANI_SETLONG,DEBRIS_X,[26,-39]	;Y,X of head
	WL	4,H3UC3X+FR5
	.word	ANI_WAITHITGND

	.word	ANI_DEBRIS,100,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,30

	.word	ANI_FRICTION,3000h

	WWL	ANI_SETLONG,DEBRIS_X,[9,-49]	;Y,X of head
	WL	2,H3UC3X+FR6
	.word	ANI_BOUNCE,5
	WL	2,H3UC3X+FR6
	WWL	ANI_SETLONG,DEBRIS_X,[5,-49]	;Y,X of head
	WL	4,H3UC3X+FR7
	WWL	ANI_SETLONG,DEBRIS_X,[5,-49]	;Y,X of head
	WL	4,H3UC3X+FR8
	.word	ANI_WAITHITGND
;MJT Start
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WWL	ANI_SETLONG,DEBRIS_X,[5,-49]	;Y,X of head
	WL	4,H3UC3X+FR9
	WWL	ANI_SETLONG,DEBRIS_X,0		;Y,X of head
	WL	4,H3UC3X+FR10
	.word	ANI_XFLIP

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
;MJT End
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	WL	1,H3RL1A+FR1	;1st frame of roll

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim
	.word	ANI_END

#*****************************************************************************
*
* FALL BACK

 SUBR	hrt_fall_back2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,20000h

	.ref	ckzpos
	WL	ANI_CODE,ckzpos

	WL	4,H3UC3X+FR1

	.word	ANI_OFFSET,0,45,0			;x,y,z
	WL	4,H3UC3X+FR2
	WL	4,H3UC3X+FR3
	WL	4,H3UC3X+FR4

	WL	4,H3UC3X+FR5
	WL	4,H3UC3X+FR6
	.word	ANI_WAITHITGND

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,30
	.word	ANI_ZEROVELS		
	WLW	ANI_SET_ZVEL,18000h,AM_ABS
	WLW	ANI_SET_XVEL,-30000h,AM_FACE_REL

	WL	3,H3UC3Z+FR1
	WL	3,H3UC3Z+FR2
	WL	3,H3UC3Z+FR3
	WL	3,H3UC3Z+FR4
	WL	3,H3UC3Z+FR5
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_OFFSET,-20,0,0			;x,y,z
	WL	3,H3MS3X+FR1
	WL	3,H3MS3X+FR2
	WL	3,H3MS3X+FR3
	WL	3,H3MS3X+FR4
	WL	25,H3MS3X+FR5

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim
	.word	ANI_END

#*****************************************************************************
*
* FALL FROM TURNBUCKLE

 SUBR	hrt_fall_back_tbukl_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETSPEED,100h

	WL	4,H3UC3X+FR1

	.word	ANI_OFFSET,0,45,0			;x,y,z
	WL	4,H3UC3X+FR2
	WL	4,H3UC3X+FR3
	WL	4,H3UC3X+FR4

	WL	4,H3UC3X+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_DAMAGE,D_HITCONCRETE

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,30

;	.word	ANI_FRICTION,3000h

	WL	2,H3UC3X+FR6
;	.word	ANI_BOUNCE,5
	WL	2,H3UC3X+FR6
	WL	4,H3UC3X+FR7
	WL	4,H3UC3X+FR8
;	.word	ANI_WAITHITGND
;	WL	ANI_CODE,SMALL_BOUNCE
;	.word	ANI_ZEROVELS
	WL	4,H3UC3X+FR9
	WL	4,H3UC3X+FR10
	.word	ANI_XFLIP

	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	WL	1,H3RL1A+FR1	;1st frame of roll

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim

#*****************************************************************************
*
* FACE UP GETUP

 SUBR	hrt_faceup_getup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,choose_2or4
	WL	ANI_IFSTATUS,#getup_in_4

#getup_in_2
	WL	4,H3GU2A+FR1
	WL	4,H3GU2A+FR2
	WL	4,H3GU2A+FR3
	WL	4,H3GU2A+FR4
	WL	4,H3GU2A+FR5
	WL	4,H3GU2A+FR6
	WL	4,H3GU2A+FR7
	WL	4,H3GU2A+FR8
	WL	4,H3GU2A+FR9
	WL	4,H3GU2A+FR10
	.word	ANI_FACEUP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#getup_in_4
	WL	4,H3GU4A+FR1
	WL	4,H3GU4A+FR2
	WL	4,H3GU4A+FR3
	WL	4,H3GU4A+FR4
	WL	ANI_GOTO,#common_4

 SUBR	hrt_4_faceup_getup2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

#common_4
	WL	4,H3GU4A+FR5
	WL	4,H3GU4A+FR6
	WL	4,H3GU4A+FR7
	WL	4,H3GU4A+FR8
	WL	4,H3GU4A+FR9
	WL	4,H3GU4A+FR10
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
* FACE DOWN GETUP

 SUBR	hrt_facedown_getup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

;	WL	4,H3RL1A+FR9
;	WL	4,H3RL1A+FR10
	WL	4,H3GU4A+FR4
	WL	4,H3GU4A+FR5
	WL	4,H3GU4A+FR6
	WL	4,H3GU4A+FR7
	WL	4,H3GU4A+FR8
	WL	4,H3GU4A+FR9
	WL	4,H3GU4A+FR10
	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* DIZZY

 SUBR	hrt_dizzy_anim

	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_START_DIZZY,0	;0=Standing dizzy
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

#loop

	WL	5,H4TI4B+FR1
	WL	5,H4TI4B+FR2
	WL	5,H4TI4B+FR3
	WL	5,H4TI4B+FR4
	WL	5,H4TI4B+FR5
	WL	5,H4TI4B+FR6
	WL	5,H4TI4B+FR7
	WL	5,H4TI4B+FR8
	WL	5,H4TI4B+FR7
	WL	5,H4TI4B+FR6
	WL	5,H4TI4B+FR5
	WL	5,H4TI4B+FR4
	WL	5,H4TI4B+FR3
	WL	5,H4TI4B+FR2

	WL	ANI_GOTO,#loop

#*****************************************************************************
*
* ROLL OVER AND BREAK YER STINKIN' NECK

 SUBR	hrt_break_neck_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	WWWL	ANI_IFROPE,RC_FRONT,100,#fall_back

	;break the neck
	WL	4,H3UC3Z+FR2
	.word	ANI_OFFSET,16,0,0
	WL	4,H3UC3Z+FR3
	.word	ANI_OFFSET,18,0,0
	WL	4,H3UC3Z+FR4
	.word	ANI_OFFSET,30,0,0
	WL	4,H3UC3Z+FR5
	.word	ANI_OFFSET,28,0,0
	WL	4,H3RL1A+FR8
	.word	ANI_FACEDOWN
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_facedown_getup_anim

#fall_back
	WL	6,H3UC3Z+FR2
	.word	ANI_OFFSET,-8,0,0
	WL	4,H3UC3Z+FR1
	.word	ANI_OFFSET,-10,0,0
	WL	4,H3UC3X+FR7
	WL	4,H3UC3X+FR8
	WL	4,H3UC3X+FR9
	WL	4,H3UC3X+FR10
	.word	ANI_XFLIP
	WL	4,H2CP3A+FR8
	.word	ANI_FACEDOWN
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_facedown_getup_anim
	
 SUBR	hrt_break_neck2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	;break the neck
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WL	ANI_SET_YVEL,60000h
	WLW	ANI_SET_ZVEL,8000h,AM_ABS
	.ref	ckzpos
	WL	ANI_CODE,ckzpos
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_XFLIP

	.word	ANI_OFFSET,15,0,0

	WL	4,H3UC3Z+FR2
	.word	ANI_OFFSET,-3,0,0
	WL	4,H3UC3Z+FR3
	.word	ANI_OFFSET,-3,0,0
	WL	4,H3UC3Z+FR4
	WL	4,H3UC3Z+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_OFFSET,-20,0,0

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!

	WL	10,H3RL1A+FR8
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim
	.word	ANI_END

 SUBR	hrt_break_neck3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,58000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	.ref	ckzpos
	WL	ANI_CODE,ckzpos

	.word	ANI_DEBRIS,300,5,0,-5,0	;%chance, tbl index, x,y,z off

	WL 	15,H4POGO+FR3
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_XFLIP

	.word	ANI_OFFSET,0,0,0

	WL	3,H3PP3X+FR7
	.word	ANI_OFFSET,15,0,0
	WL	3,H3UC3Z+FR2
	.word	ANI_OFFSET,-3,0,0
	WL	3,H3UC3Z+FR3
	.word	ANI_OFFSET,-3,0,0
	WL	3,H3UC3Z+FR4
	WL	3,H3UC3Z+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_OFFSET,-20,0,0

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!

	WL	10,H3RL1A+FR8
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim
	.word	ANI_END


******************************************************************************
*
* #4 LOSE BALANCE

 SUBR	hrt_4_losebal_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_FRICTION,3000h
	.word	ANI_SETSPEED,100h
	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL

	WL	4,H4LB3A+FR1
	WL	4,H4LB3A+FR3
	WL	4,H4LB3A+FR4
	WL	4,H4LB3A+FR5
	WL	4,H4LB3A+FR6
	WL	4,H4LB3A+FR9
	WL	4,H4LB3A+FR10

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_losebal_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_FRICTION,3000h
	.word	ANI_SETSPEED,100h
	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	4,H4LB3A+FR1
	WL	4,H4LB3A+FR3
	WL	4,H4LB3A+FR4
	WL	4,H4LB3A+FR5
	WL	4,H4LB3A+FR6
	WL	4,H4LB3A+FR9
	WL	4,H4LB3A+FR10

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,hrt_dizzy_anim
	.word	ANI_END

#*****************************************************************************
*
* GET BUZZED FROM DOINK

 SUBR	hrt_get_buzz_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable

;	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;	.word	ANI_XFLIP

	.word	ANI_GRAVITY_OFF

	WL	ANI_CODE,set_position

	WL	ANI_CODE,set_skeleton_pal
	WL	2,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,H4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	ANI_CODE,make_white
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_norm
	WL	ANI_CODE,set_my_pal
	WL	3,H4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,H4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_white
	WL	3,H4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,H4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,H4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	ANI_CODE,make_white
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_norm
	WL	ANI_CODE,set_my_pal
	WL	3,H4BZ4A+FR1

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
	WL	3,H4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,H4BZ4A+FR1
	WL	ANI_CODE,#make_black
	WL	3,H4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,H4BZ4A+FR1
	WL	ANI_CODE,#make_black
	WL	3,H4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,H4BZ4A+FR1

	.word	ANI_WAITHITGND
	.word	ANI_XFLIP
	.word	ANI_FACEDOWN
	.word	ANI_OFFSET,-20,0,0			;x,y,z
;MJT Start
	WL	1,H4ST4A+FR5

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,hrt_fall_back_anim
	.word	ANI_END

#nodead
;MJT End

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#make_black

;This is a black color within the wrestler's pal.  It is different for each
;wrestler.
	movi	2f2fh,a14

	move	a14,*a13(OBJ_CONST)
	move	*a13(OBJ_CONTROL),a14
	andni	01111b,a14
	ori	M_CONNON,a14
	move	a14,*a13(OBJ_CONTROL)
	rets


#*****************************************************************************
*
* THROWN FROM RING (shn_bslm, shn_frnk)

 SUBR	hrt_flyout_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETSPEED,100h

	WL	8,H3FR3A+FR4
	WL	8,H3FR3A+FR5
	WL	8,H3FR3A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_DAMAGE,D_HIPTOSS
	.word	ANI_SETWORD,DELAY_METER,0
	.word	ANI_GETUP,500


	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,60
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,hrt_hitonground_anim


#*****************************************************************************
*
* FLY OUT #2 - (hrt_hpsl)
*

 SUBR	hrt_flyout2_anim

	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE

	WLW	ANI_SET_XVEL,60000h,AM_HIT_REL
	WL	ANI_SET_YVEL,48000h

	WL	4,H3UC3X+FR5
	.word	ANI_WAITHITGND

	;IMPACT
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,60
	.word	ANI_DAMAGE,D_HITCONCRETE
	.word	ANI_ZEROVELS

	.word	ANI_DAMAGE,D_HIPTOSS
	.word	ANI_SETWORD,DELAY_METER,0
	.word	ANI_GETUP,500


	WL	10,H3UC3X+FR6
	WL	4,H3UC3Z+FR1
	WL	4,H3UC3Z+FR2
	WL	4,H3UC3Z+FR3
	WL	4,H3UC3Z+FR4
	WL	4,H3UC3Z+FR5
	.word	ANI_XFLIP
	.word	ANI_OFFSET,84,0,0
	WL	4,H3MS3X+FR1
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_hitonground_facedown_anim
	
;MJT Start
#*****************************************************************************
*
* END OF BACK BROKEN SEQ.

 SUBR	hrt_backbroken_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_DETACH

	.word	ANI_GRAVITY_OFF
	WL	5,H3BR3Z+FR1
	.word	ANI_GRAVITY_ON

	WL	ANI_SET_YVEL,070000h
	WLW	ANI_SET_ZVEL,20000h,AM_ABS


	WL	25,H3BR3Z+FR1


;	WL	4,H3BR3Z+FR2
	WL	4,H3BR3Z+FR3
	.word	ANI_XFLIP
	WL	2,H3RL1A+FR8

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_BOUNCE,2
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT

	WL	3,H3MS3X+FR1
	WL	3,H3MS3X+FR2
	WL	3,H3MS3X+FR3
	WL	3,H3MS3X+FR4
	WL	3,H3MS3X+FR5

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

;No stars around head here...

	.word	ANI_DETACH

	WL	1,H3RL1A+FR8

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim
	.word	ANI_END
;MJT End

#*****************************************************************************
*
* GENERIC BOUNCE

 SUBR	hrt_slambounce_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,040000h

	.word	ANI_FACE,MOVE_LEFT|MOVE_UP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	1,H2CP3A+FR8
	WL	ANI_CODE,ckzpos
	WL	3,H2CP3A+FR8
	WL	4,H2CP3A+FR2
	WL	4,H2CP3A+FR3
	WL	4,H2CP3A+FR4
	WL	4,H2CP3A+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	2,H2CP3A+FR7
	WL	10,H2CP3A+FR8

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim

 SUBR	hrt_slambounce2_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_FACE,MOVE_LEFT|MOVE_UP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off
	WL	1,H3UC3Z+FR10
	.ref	ckzpos
	WL	ANI_CODE,ckzpos
	WL	10,H3UC3Z+FR10
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_XFLIP
	WL	ANI_SET_YVEL,030000h
	WL	3,H2CP3A+FR8
	WL	4,H2CP3A+FR2
	WL	4,H2CP3A+FR3
	WL	4,H2CP3A+FR4
	WL	4,H2CP3A+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	2,H2CP3A+FR7
	WL	10,H2CP3A+FR8

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim

#*****************************************************************************

 SUBR	hrt_breakneck2_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_OFFSET,0,43,0			;x,y,z

	WL	4,H3UC3X+FR2
	WL	4,H3UC3X+FR3
	WL	4,H3UC3X+FR4
	WL	1,H3UC3X+FR5

	.word	ANI_WAITHITGND
;;;	.word	ANI_ZERO_XZVELS

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,20

	WL	3,H3UC3X+FR6
	WL	3,H3UC3X+FR7

	WL	3,H3UC3Z+FR1
	WL	3,H3UC3Z+FR2
	WL	3,H3UC3Z+FR3
	WL	3,H3UC3Z+FR4
	WL	3,H3UC3Z+FR5

	.word	ANI_ZERO_XZVELS

	WL	8,H3RL1A+FR8

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_facedown_getup_anim


******************************************************************************
	.end
