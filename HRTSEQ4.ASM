**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		5/17/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"hrtseq4.asm"
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
	.include	"razorimg.h"
	.include	"takerimg.h"
	.include	"yokoimg.h"
	.include	"shawnimg.h"
	.include	"bamimg.h"
	.include	"doinkimg.h"
	.include	"leximg.h"

	.include	"display.equ"
	.include	"damage.equ"
	.INCLUDE	"SWEAT.EQU"



******************************************************************************
* EXTERNAL REFERENCES


	.ref	free_toss_check,setup_freetoss,hrt_hiptoss_anim
	.ref	DO_WAIL,DO_SCREAM
	.ref	DO_BLOCKED
	.ref	SMALL_BOUNCE
	.ref	HIT_THE_MAT
	.ref	D4SK4A
   	.ref	set_position
	.ref	set_skeleton_pal
	.ref	am_I_dizzy
	.ref	start_smoke
	.ref	set_my_pal
	.ref	make_norm,make_white
	.ref	set_wrestler_xflip

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

;#*****************************************************************************
;*
;* #2 BLOCK & HITBLOCK
;
; SUBR	hrt_2_block_anim
;
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
;	.word	ANI_FRICTION,3000h
;	.word	ANI_ZERO_XZVELS
;	.word	ANI_SETSPEED,100h
;
;	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
;	.word	ANI_SET_WRESTLER_XFLIP
;;Rotate toward opponent if needed!
;	.word	ANI_SETPLYRMODE,MODE_BLOCK
;	WL	3,H2BK3A+FR1
;#2block
;	WL	3,H2BK3A+FR2
;	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT
;	.word	ANI_ZERO_XZVELS
;	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
;	.word	ANI_SETMODE,MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_SETFACING
;	WL	3,H2BK3A+FR1
;	.word	ANI_SETPLYRMODE,MODE_NORMAL
;	.word	ANI_END
;
; SUBR	hrt_2_hitblock_anim
;
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
;	.word	ANI_SETSPEED,100h
;	.word	ANI_FRICTION,3000h
;	WL	4,H2BK3A+FR4
;	WL	4,H2BK3A+FR3
;	WL	ANI_GOTO,#2block

#************
*
* #4 BLOCK & HITBLOCK

 SUBR	hrt_4_block_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

;	WL	ANI_CODE,block_if_safe
	.word	ANI_SETPLYRMODE,MODE_BLOCK
	WL	3,H4BK3A+FR1
;	.word	ANI_SETPLYRMODE,MODE_BLOCK
#4block
	WL	3,H4BK3A+FR2
	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT|MODE_FRICTION
	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
;	.word	ANI_ZERO_XZVELS
	.word	ANI_SETMODE,MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETFACING
	WL	3,H4BK3A+FR1
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_hitblock_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,5000h
	WL	ANI_CODE,DO_BLOCKED
	WL	2,H4BK3A+FR4
	WL	2,H4BK3A+FR3
	WL	ANI_GOTO,#4block

 SUBR	hrt_4_hitblock2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,4000h
	WL	ANI_CODE,DO_BLOCKED
	WL	ANI_SET_YVEL,38000h
	WL	3,H4BK3A+FR4
	WL	3,H4BK3A+FR3
	WL	3,H4BK3A+FR4
	WL	3,H4BK3A+FR3
	WL	3,H4BK3A+FR4
	WL	3,H4BK3A+FR3
	WL	ANI_GOTO,#4block


#*****************************************************************************
*
* #2 HEAD HIT

 SUBR	hrt_2_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,H2AH3A+FR1
	WL	3,H2AH3A+FR2
	WL	3,H2AH3A+FR3
	WL	3,H2AH3A+FR4
	WL	3,H2AH3A+FR5
	WL	3,H2AH3A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_2_head_hit3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,40000h

	.word	ANI_DEBRIS,300,2,-21,100,0	;%chance, tbl index, x,y,z off

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
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
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

	WL	3,H4AH3A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,H4AH3A+FR2
	WL	3,H4AH3A+FR3
	WL	3,H4AH3A+FR4
	WL	3,H4AH3A+FR5
	WL	3,H4AH3A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_head_hit3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-20000h,AM_ABS
	WL	ANI_SET_YVEL,40000h

	.word	ANI_DEBRIS,300,2,-21,100,0	;%chance, tbl index, x,y,z off

	WL	3,H4AH3A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
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

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

;	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
;	WLW	ANI_SET_ZVEL,-20000h,AM_ABS
	WL	ANI_SET_YVEL,40000h

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,H4AH3A+FR2
;	.word	ANI_WAITHITGND
;	.word	ANI_ZEROVELS
	WL	3,H4AH3A+FR3
	WL	3,H4AH3A+FR4
	WL	3,H4AH3A+FR5
	WL	3,H4AH3A+FR6

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 HEAD HIT2 (HANDS ON FACE)

 SUBR	hrt_2_head_hit2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,H2AE3A+FR1
	WL	3,H2AE3A+FR2
	WL	3,H2AE3A+FR3
	WL	3,H2AE3A+FR4
	WL	3,H2AE3A+FR5
	WL	3,H2AE3A+FR6
	WL	3,H2AE3A+FR7
	WL	3,H2AE3A+FR8

	.word	ANI_FACEUP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 HEAD HIT2 (HANDS ON FACE)

 SUBR	hrt_4_head_hit2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,H4AE3A+FR1
	WL	3,H4AE3A+FR2
	WL	3,H4AE3A+FR3
	WL	3,H4AE3A+FR4
	WL	3,H4AE3A+FR5
	WL	3,H4AE3A+FR6
	WL	3,H4AE3A+FR7
	WL	3,H4AE3A+FR8

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,hrt_fall_back_anim
;	.word	ANI_END

#nodead
	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
       	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_head_hit2s_anim
;Salt hits me in face

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.ref	create_impact_salt
	WL	ANI_CODE,create_impact_salt

	WL	3,H4AE3A+FR1
	WL	3,H4AE3A+FR2
	WL	4,H4AE3A+FR3
	WL	4,H4AE3A+FR4
	WL	4,H4AE3A+FR5
	WL	4,H4AE3A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_FRICTION,4000h
	WL	50,H4AE3A+FR6
	.word	ANI_ZEROVELS
	WL	4,H4AE3A+FR7
	WL	4,H4AE3A+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
       	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 HEAD HIT2 (ENDS IN DIZZY)

 SUBR	hrt_4_head_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	.word	ANI_DEBRIS,300,3,-21,100,0	;%chance, tbl index, x,y,z off

	WL	3,H4AE3A+FR1
	WL	3,H4AE3A+FR2
	WL	3,H4AE3A+FR3
	WL	3,H4AE3A+FR4
	WL	3,H4AE3A+FR5
	WL	3,H4AE3A+FR6
	WL	3,H4AE3A+FR7
	WL	3,H4AE3A+FR8

	.word	ANI_FACEDOWN
;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,hrt_dizzy_anim

;	.word	ANI_END

******************************************************************************
*
* #2 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	hrt_2_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

	WL	3,H2AH3A+FR1
	WL	15,H2AH3A+FR2
	WL	4,H2AH3A+FR3

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	hrt_4_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
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

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	3,H4AH3A+FR1
	WL	3,H4AH3A+FR2
	WL	14,H4AH3A+FR3
	WL	2,H4AH3A+FR5

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,hrt_dizzy_anim
;	.word	ANI_END



#*****************************************************************************
*
* #2 BODY HIT

 SUBR	hrt_2_body_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL

	.word	ANI_DEBRIS,300,0,-4,71,0	;%chance, tbl index, x,y,z off

	WL	3,H2AM3A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	3,H2AM3A+FR2
	WL	3,H2AM3A+FR3

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,H2AM3A+FR4
	WL	3,H2AM3A+FR5
	WL	3,H2AM3A+FR6
	WL	3,H2AM3A+FR7
	WL	3,H2AM3A+FR8

	.word	ANI_FACEUP
	
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

; SUBR	hrt_2_body_hit_dizzy_anim
;
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_ZEROVELS
;	.word	ANI_SETSPEED,100h
;	WL	ANI_SET_YVEL,48000h
;	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
;
;	WL	3,H2AM3A+FR1
;	WL	3,H2AM3A+FR2
;	WL	3,H2AM3A+FR3
;
;	.word	ANI_WAITHITGND
;	.word	ANI_ZEROVELS
;
;	WL	3,H2AM3A+FR4
;	WL	3,H2AM3A+FR5
;	WL	3,H2AM3A+FR6
;	WL	3,H2AM3A+FR7
;	WL	3,H2AM3A+FR8
;
;	.word	ANI_SETPLYRMODE,MODE_DIZZY
;	WL	ANI_CHANGEANIM,hrt_dizzy_anim
;	.word	ANI_END

#************
*
* #4 BODY HIT

 SUBR	hrt_4_body_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,048000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-04000h,AM_ABS

	.word	ANI_DEBRIS,100,0,-4,71,0	;%chance, tbl index, x,y,z off

	WL	3,H4AM3A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	3,H4AM3A+FR2
	WL	3,H4AM3A+FR3

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,H4AM3A+FR4
	WL	3,H4AM3A+FR5
	WL	3,H4AM3A+FR6
	WL	3,H4AM3A+FR7
	WL	3,H4AM3A+FR8

	.word	ANI_CHECKWORD,USR_VAR1
	WL	ANI_IFNOTSTATUS,#reg

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

;	WL	5,H4TI4B+FR1
;	WL	5,H4TI4B+FR2
;	WL	5,H4TI4B+FR3
;	WL	5,H4TI4B+FR4
;	WL	5,H4TI4B+FR5
;	WL	5,H4TI4B+FR6
;	WL	5,H4TI4B+FR7
;	WL	5,H4TI4B+FR8
;	WL	5,H4TI4B+FR7
;	WL	5,H4TI4B+FR6

#reg
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_body_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	.word	ANI_DEBRIS,300,0,-4,71,0	;%chance, tbl index, x,y,z off

	WL	3,H4AM3A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	3,H4AM3A+FR2
	WL	3,H4AM3A+FR3

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,H4AM3A+FR4
	WL	3,H4AM3A+FR5
	WL	3,H4AM3A+FR6
	WL	3,H4AM3A+FR7
	WL	3,H4AM3A+FR8

	.word	ANI_FACEDOWN
;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,hrt_dizzy_anim
;	.word	ANI_END




 SUBR	hrt_2_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,04000h,AM_ABS

	.word	ANI_DEBRIS,300,0,-4,71,0	;%chance, tbl index, x,y,z off

	WL	3,H2AM3A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	3,H2AM3A+FR2
	WL	3,H2AM3A+FR3

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,H2AM3A+FR4
	WL	3,H2AM3A+FR5
	WL	3,H2AM3A+FR6
	WL	3,H2AM3A+FR7
	WL	3,H2AM3A+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-04000h,AM_ABS

	.word	ANI_DEBRIS,300,0,-4,71,0	;%chance, tbl index, x,y,z off

	WL	3,H4AM3A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	3,H4AM3A+FR2
	WL	3,H4AM3A+FR3

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,H4AM3A+FR4
	WL	3,H4AM3A+FR5
	WL	3,H4AM3A+FR6
	WL	3,H4AM3A+FR7
	WL	3,H4AM3A+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_knee_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,08000h,AM_ABS
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	.word	ANI_DEBRIS,300,0,-4,71,0	;%chance, tbl index, x,y,z off

	WL	3,H4AM3A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	3,H4AM3A+FR2
	WL	3,H4AM3A+FR3

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,H4AM3A+FR4
	WL	3,H4AM3A+FR5
	WL	3,H4AM3A+FR6
	WL	3,H4AM3A+FR7
	WL	3,H4AM3A+FR8


	.word	ANI_FACEDOWN
;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,hrt_dizzy_anim
;	.word	ANI_END


;Being held by head, hit by a quick knee!
 SUBR	hrt_quick_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_OFFSET,0,0,2			;x,y,z

	WL	3,H2AM3A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	3,H2AM3A+FR2
	WL	3,H2AM3A+FR3
	WL	3,H2AM3A+FR4

	.word	ANI_WAITHITGND
	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,hrt_fall_back_anim
;	.word	ANI_END

#nodead
	.ref	hrt_3_head_held_anim

	WL	ANI_CHANGEANIM,hrt_3_head_held_anim

;	.word	ANI_END




#*****************************************************************************
*
* HITS ON GROUND

 SUBR	hrt_up_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.WORD	ANI_XFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h
         WL      10,H3FR3A+FR2

	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,H2CP3A+FR8
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim

 SUBR	hrt_hitonground_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,39000h

	.word	ANI_DEBRIS,50,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	3,H2CP3A+FR1
	WL	3,H2CP3A+FR2
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPITUP_SWEAT,SWEAT_PER,0
	WL	3,H2CP3A+FR3
	WL	3,H2CP3A+FR4
	WL	3,H2CP3A+FR5
	WL	3,H2CP3A+FR6
	WL	3,H2CP3A+FR7
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	1,H2CP3A+FR8
 SUBR	hrt_liedown_anim
	WL	1,H2CP3A+FR8
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim


 SUBR	hrt_hitonground_facedown_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
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

#*****************************************************************************
*
* FALL BACK

 SUBR	hrt_fall_back_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCOLLIS
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZERO_XZVELS
	WL	ANI_MIN_YVEL,60000h
	WLW	ANI_SET_ZVEL,10000h,AM_FACE_REL

	.word	ANI_SCROLL_CTRL,HRT_TBUKLY

	.ref	ckzpos
	WL	ANI_CODE,ckzpos

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYC_SWEAT,SWEAT_PER,0
	WWL	ANI_SETLONG,DEBRIS_X,[99,-10]	;Y,X of head
	WL	3,H3UC3X+FR1

	.word	ANI_OFFSET,0,45,0			;x,y,z
	WWL	ANI_SETLONG,DEBRIS_X,[44,-38]	;Y,X of head
	WL	3,H3UC3X+FR2
	WWL	ANI_SETLONG,DEBRIS_X,[38,-39]	;Y,X of head
	WL	3,H3UC3X+FR3
	WWL	ANI_SETLONG,DEBRIS_X,[33,-39]	;Y,X of head
	WL	3,H3UC3X+FR4

	WWL	ANI_SETLONG,DEBRIS_X,[26,-39]	;Y,X of head
	WL	3,H3UC3X+FR5
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
	WL	3,H3UC3X+FR7
	WWL	ANI_SETLONG,DEBRIS_X,[5,-49]	;Y,X of head
	WL	3,H3UC3X+FR8
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WWL	ANI_SETLONG,DEBRIS_X,[5,-49]	;Y,X of head
	WL	3,H3UC3X+FR9
	WWL	ANI_SETLONG,DEBRIS_X,0		;Y,X of head
	WL	3,H3UC3X+FR10
	.word	ANI_XFLIP

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	WL	1,H3RL1A+FR1	;1st frame of roll

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim
;	.word	ANI_END

#*****************************************************************************
*
* FALL BACK

 SUBR	hrt_fall_back2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,20000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	.ref	ckzpos
	WL	ANI_CODE,ckzpos

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYC_SWEAT,SWEAT_PER,0
	WL	3,H3UC3X+FR1

	.word	ANI_OFFSET,0,45,0			;x,y,z
	WL	3,H3UC3X+FR2
	WL	3,H3UC3X+FR3
	WL	3,H3UC3X+FR4

	WL	3,H3UC3X+FR5
	WL	3,H3UC3X+FR6
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
;	.word	ANI_END

#*****************************************************************************
*
* FALL FROM TURNBUCKLE

 SUBR	hrt_fall_back_tbukl_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETSPEED,100h

	WL	3,H3UC3X+FR1

	.word	ANI_OFFSET,0,45,0			;x,y,z
	WL	3,H3UC3X+FR2
	WL	3,H3UC3X+FR3
	WL	3,H3UC3X+FR4

	WL	3,H3UC3X+FR5
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
	WL	3,H3UC3X+FR7
	WL	3,H3UC3X+FR8
;	.word	ANI_WAITHITGND
;	WL	ANI_CODE,SMALL_BOUNCE
;	.word	ANI_ZEROVELS
	WL	3,H3UC3X+FR9
	WL	3,H3UC3X+FR10
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
	WL	2,H3GU2A+FR1
	WL	2,H3GU2A+FR2
	WL	2,H3GU2A+FR3
	WL	2,H3GU2A+FR4
	WL	2,H3GU2A+FR5
	WL	2,H3GU2A+FR6
	WL	2,H3GU2A+FR7
	WL	2,H3GU2A+FR8
	WL	2,H3GU2A+FR9
	WL	2,H3GU2A+FR10

	.word	ANI_SAFE_TIME,50

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,11,83,70,20
	WL	1,H3GU2A+FR10
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,hrt_4_push_anim
#no_freetoss

	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#getup_in_4
	WL	2,H3GU4A+FR1
	WL	2,H3GU4A+FR2
	WL	2,H3GU4A+FR3
	WL	2,H3GU4A+FR4
	WL	ANI_GOTO,#common_4

 SUBR	hrt_4_faceup_getup2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

#common_4
	WL	2,H3GU4A+FR5
	WL	2,H3GU4A+FR6
	WL	2,H3GU4A+FR7
	WL	2,H3GU4A+FR8
	WL	2,H3GU4A+FR9
	WL	2,H3GU4A+FR10

	.word	ANI_SAFE_TIME,50

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss1
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,11,83,70,20
	.ref	hrt_4_push_anim
	WL	1,H3GU4A+FR10
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss1

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,hrt_4_push_anim
#no_freetoss1

	.word	ANI_SETFACING
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

	WL	2,H3GU4A+FR4
	WL	2,H3GU4A+FR5
	WL	2,H3GU4A+FR6
	WL	2,H3GU4A+FR7
	WL	ANI_CODE,#set_wrestler_xflip
	WL	2,H3GU4A+FR8
	WL	2,H3GU4A+FR9
	WL	2,H3GU4A+FR10
	.word	ANI_SAFE_TIME,50

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,11,83,70,20
	WL	1,H3GU4A+FR10
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,hrt_4_push_anim
#no_freetoss

	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

*****
* call set_wrestler_xflip
#set_wrestler_xflip
	move	a13,a0
	calla	set_wrestler_xflip
	rets

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
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	WWWL	ANI_IFROPE,RC_FRONT,100,#fall_back

	;break the neck
	WL	3,H3UC3Z+FR2
	.word	ANI_OFFSET,-16,0,0
	WL	3,H3UC3Z+FR3
	.word	ANI_OFFSET,-18,0,0
	WL	3,H3UC3Z+FR4
	.word	ANI_OFFSET,-30,0,0
	WL	3,H3UC3Z+FR5
	.word	ANI_OFFSET,-28,0,0
	WL	3,H3RL1A+FR8
	.word	ANI_FACEDOWN
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_facedown_getup_anim

#fall_back
	WL	6,H3UC3Z+FR2
	.word	ANI_OFFSET,-8,0,0
	WL	3,H3UC3Z+FR1
	.word	ANI_OFFSET,-10,0,0
	WL	3,H3UC3X+FR7
	WL	3,H3UC3X+FR8
	WL	3,H3UC3X+FR9
	WL	3,H3UC3X+FR10
	.word	ANI_XFLIP
	WL	3,H2CP3A+FR8
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
;	.word	ANI_END

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

	WL	4,H3RL1A+FR8	;10
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim
;	.word	ANI_END


******************************************************************************
*
* #4 LOSE BALANCE

 SUBR	hrt_4_losebal_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_FRICTION,3000h
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WLW	ANI_SET_XVEL,-60000h,AM_HIT_REL

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,H4LB3A+FR1
	WL	3,H4LB3A+FR3
	WL	3,H4LB3A+FR4
	.REF	DO_BRET_PUSH
	WL	ANI_CODE,DO_BRET_PUSH
	WL	3,H4LB3A+FR5
	WL	3,H4LB3A+FR6
	WL	3,H4LB3A+FR9
	WL	3,H4LB3A+FR10

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_losebal_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_FRICTION,3000h
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	3,H4LB3A+FR1
	WL	3,H4LB3A+FR3
	WL	3,H4LB3A+FR4
	WL	3,H4LB3A+FR5
	WL	3,H4LB3A+FR6
	WL	3,H4LB3A+FR9
	WL	3,H4LB3A+FR10

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,hrt_dizzy_anim
;	.word	ANI_END

#*****************************************************************************
*
* GET BUZZED FROM DOINK

 SUBR	hrt_get_buzz_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable

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
	WL	1,H4ST4A+FR5

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,hrt_fall_back_anim
;	.word	ANI_END

#nodead

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

	WWL	ANI_SETLONG,OBJ_GRAVITY,0E000h
	.word	ANI_SET_IDIOT
	WL	ANI_CODE,DO_WAIL

	WL	7,H3FR3A+FR4
	WL	7,H3FR3A+FR5
	WL	7,H3FR3A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

	.word	ANI_DAMAGE,D_HIPTOSS
;	.word	ANI_SETWORD,DELAY_METER,0
;	.word	ANI_GETUP,500


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

	WWL	ANI_SETLONG,OBJ_GRAVITY,0E000h
	.word	ANI_SET_IDIOT
	WL	ANI_CODE,DO_WAIL

	WL	3,H3UC3X+FR5
	.word	ANI_WAITHITGND

	;IMPACT
	WL	ANI_CODE,HIT_THE_MAT
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,60
	.word	ANI_DAMAGE,D_HITCONCRETE
	.word	ANI_ZEROVELS

	.word	ANI_DAMAGE,D_HIPTOSS

	WL	10,H3UC3X+FR6
	WL	3,H3UC3Z+FR1
	WL	3,H3UC3Z+FR2
	WL	3,H3UC3Z+FR3
	WL	3,H3UC3Z+FR4
	WL	3,H3UC3Z+FR5
	.word	ANI_XFLIP
	.word	ANI_OFFSET,84,0,0
	WL	3,H3MS3X+FR1
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_hitonground_facedown_anim

#*****************************************************************************
*
* END OF BACK BROKEN SEQ.

 SUBR	hrt_backbroken_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
;	.word	ANI_DETACH

	.word	ANI_GRAVITY_OFF
	WL	5,H3BR3Z+FR1
	.word	ANI_GRAVITY_ON

	WL	ANI_SET_YVEL,070000h
	WLW	ANI_SET_ZVEL,20000h,AM_ABS


	WL	25,H3BR3Z+FR1


;	WL	3,H3BR3Z+FR2
	WL	3,H3BR3Z+FR3
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
;	.word	ANI_END

#*****************************************************************************
*
* GENERIC BOUNCE

 SUBR	hrt_slamnobounce_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_FACE,MOVE_LEFT|MOVE_UP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	1,H2CP3A+FR8
	WL	3,H2CP3A+FR8
	WL	3,H2CP3A+FR2
	WL	3,H2CP3A+FR3
	WL	3,H2CP3A+FR4
	WL	3,H2CP3A+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	2,H2CP3A+FR7
	WL	10,H2CP3A+FR8

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim

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
	WL	3,H2CP3A+FR2
	WL	3,H2CP3A+FR3
	WL	3,H2CP3A+FR4
	WL	3,H2CP3A+FR5

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
	WL	3,H2CP3A+FR2
	WL	3,H2CP3A+FR3
	WL	3,H2CP3A+FR4
	WL	3,H2CP3A+FR5

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

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYD_SWEAT,SWEAT_PER,0
	WL	3,H3UC3X+FR2
	WL	3,H3UC3X+FR3
	WL	3,H3UC3X+FR4
	WL	1,H3UC3X+FR5

	.word	ANI_WAITHITGND

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
	WL	ANI_CODE,HIT_THE_MAT

	WL	8,H3RL1A+FR8

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_facedown_getup_anim


#*****************************************************************************

 SUBR	hrt_arm_broken_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_XVEL,-38000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,10000h,AM_HIT_REL

	WL	ANI_CODE,DO_SCREAM
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	4,H4AE3A+FR1
	WL	4,H4AE3A+FR2
	WL	4,H4AE3A+FR4
	WL	5,H4AE3A+FR5

	WL	1,H4ST4A+FR5

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,hrt_fall_back_anim
;	.word	ANI_END

#nodead
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************

 SUBR	hrt_2_shooter_anim


	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_STARTATTACK,AT_PUPPET,15
	WL	2,H1TL5A+FR3	;2.5
	WL	2,H1TL5A+FR4	;3.5

 SUBR	hrt_4_shooter_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_CLR_BUTCOUNT
	.word	ANI_STARTATTACK,AT_PUPPET,2
	WL	1,H4GH3Z+FR1
	.word	ANI_ATTACK_ON, AMODE_PUPPET,18,0,25,18 ;mode,x,y,w,h
	WL	1,H4GH3Z+FR1
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
;got him
	.word	ANI_DRAW_NAME,5
	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	.ref	DO_NONO
	WL	ANI_CODE,DO_NONO
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

;	.word	ANI_SHAKER,30
	WL	ANI_CODE,impact_sound

	WWLLW	ANI_SUPERSLAVE2,1,H4GH3Z+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,H4GH3Z+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,H4GH3Z+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,H4GH3Z+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,H4GH3Z+FR5,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,H4GH3Z+FR6,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,3,H4ZZ4C+FR2,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,3,H4ZZ4C+FR3,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,3,H4ZZ4C+FR4,#puppet_tbl,8

	.ref	MAKE_HIM_SCREAM
	WL	ANI_CODE,MAKE_HIM_SCREAM
	.word	ANI_DAMAGEOPP,D_SHOOTER,RD_SHOOTER
	WWLLW	ANI_SUPERSLAVE2,3,H4ZZ4C+FR5,#puppet_tbl,9
	WWLLW	ANI_SUPERSLAVE2,3,H4ZZ4C+FR6,#puppet_tbl,10

	WWLLW	ANI_SUPERSLAVE2,15,H4ZZ4B+FR2,#puppet_tbl,11
	.word	ANI_SOUND,9bh			;neck break (5-7 ticks late)
	.word	ANI_DAMAGEOPP,D_SHOOTER,RD_SHOOTER
	WWLLW	ANI_SUPERSLAVE2,15,H4ZZ4B+FR3,#puppet_tbl,12
	WWLLW	ANI_SUPERSLAVE2,4,H4ZZ4B+FR2,#puppet_tbl,11
	.word	ANI_DEBRISAT,100,1,0,8,0	;%chance,tbl index,x,y,z off
	.word	ANI_SOUND,98h			;neck break (5-7 ticks late)

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,2,#fail
	.word	ANI_CLR_BUTCOUNT

	.word	ANI_DAMAGEOPP,D_SHOOTER,RD_SHOOTER
	WL	ANI_CODE,MAKE_HIM_SCREAM
	WWLLW	ANI_SUPERSLAVE2,20,H4ZZ4B+FR3,#puppet_tbl,12
	WWLLW	ANI_SUPERSLAVE2,15,H4ZZ4B+FR2,#puppet_tbl,11
	.word	ANI_SOUND,98h			;neck break (5-7 ticks late)

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,2,#fail
	.word	ANI_CLR_BUTCOUNT

	.word	ANI_DAMAGEOPP,D_SHOOTER,RD_SHOOTER
	WWLLW	ANI_SUPERSLAVE2,14,H4ZZ4B+FR3,#puppet_tbl,12
	WWLLW	ANI_SUPERSLAVE2,20,H4ZZ4B+FR2,#puppet_tbl,11
	.word	ANI_SOUND,9bh			;neck break (5-7 ticks late)

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,2,#fail
	.word	ANI_CLR_BUTCOUNT

	.word	ANI_DAMAGEOPP,D_SHOOTER,RD_SHOOTER
	WWLLW	ANI_SUPERSLAVE2,20,H4ZZ4B+FR3,#puppet_tbl,12
	WWLLW	ANI_SUPERSLAVE2,9,H4ZZ4B+FR2,#puppet_tbl,11
	.word	ANI_SOUND,98h			;neck break (5-7 ticks late)

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,2,#fail
	.word	ANI_CLR_BUTCOUNT

	.word	ANI_DAMAGEOPP,D_SHOOTER,RD_SHOOTER
	WWLLW	ANI_SUPERSLAVE2,9,H4ZZ4B+FR3,#puppet_tbl,12
	WL	ANI_CODE,MAKE_HIM_SCREAM
	WWLLW	ANI_SUPERSLAVE2,20,H4ZZ4B+FR2,#puppet_tbl,11
	.word	ANI_SOUND,98h			;neck break (5-7 ticks late)
#fail
	.word	ANI_DAMAGEOPP,D_SHOOTER,RD_SHOOTER
	.word	ANI_DEBRISAT,100,1,0,8,0	;%chance,tbl index,x,y,z off

	WWLLW	ANI_SUPERSLAVE2,3,H4ZZ4C+FR6,#puppet_tbl,10
	WWLLW	ANI_SUPERSLAVE2,3,H4ZZ4C+FR5,#puppet_tbl,9
	WWLLW	ANI_SUPERSLAVE2,3,H4ZZ4C+FR4,#puppet_tbl,8

;	WWLLW	ANI_SUPERSLAVE2,3,H4ZZ4C+FR3,#puppet_tbl,7
;	WWLLW	ANI_SUPERSLAVE2,3,H4ZZ4C+FR2,#puppet_tbl,6
;	WWLLW	ANI_SUPERSLAVE2,3,H4GH3Z+FR6,#puppet_tbl,5
;	WWLLW	ANI_SUPERSLAVE2,3,H4GH3Z+FR5,#puppet_tbl,4
;	WWLLW	ANI_SUPERSLAVE2,3,H4GH3Z+FR4,#puppet_tbl,3
;	WWLLW	ANI_SUPERSLAVE2,3,H4GH3Z+FR3,#puppet_tbl,2
;	WWLLW	ANI_SUPERSLAVE2,3,H4GH3Z+FR2,#puppet_tbl,1
;	WWLLW	ANI_SUPERSLAVE2,3,H4GH3Z+FR1,#puppet_tbl,0


	.ref	hitonground_tbl
	WL	ANI_SLAVEANIM,hitonground_tbl
	.word	ANI_DETACH

	WL	ANI_SET_YVEL,30000h
	WLW	ANI_SET_ZVEL,30000h,AM_ABS
	WLW	ANI_SET_XVEL,-28000h,AM_ABS

	WL	4,H4ZZ4C+FR4

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETFACING
	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	4,H4GH3Z+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBRP	impact_sound

	move	*a13(ATTACH_PROC),a0,L
	jrz	#x
	WRSNDX	a0,RUGSLAM_YELL,RUGSLAM_IMPACT
#x	rets


#puppet_tbl
 .long #Bret
 .long #Razor
 .long #Taker
 .long #Yokozuna
 .long #Shawn
 .long #BamBam
 .long #Doink
 .long #Adam
 .long #Lex
#Bret
 LWWW H3RL1A+FR1,19,-76,1
 LWWW H3RL1A+FR3,26,-42,1
 LWWW H3RL1A+FR4,24,-29,1
 LWWW H3RL1A+FR5,27,-33,1
 LWWW H3RL1A+FR6,27,-45,1
 LWWW H3ZS3A+FR1,54,-31,1
 LWWW H3ZS3A+FR1,49,-47,1
 LWWW H3ZS3A+FR1,37,-46,1
 LWWW H3ZS3A+FR1,6,-45,1
 LWWW H3ZS3A+FR2,10,-23,1
 LWWW H3ZS3A+FR2,3,-19,1
 LWWW H3ZS3A+FR2,2,-14,1
 LWWW H3ZS3A+FR3,-10,-18,1
 .long 0
#Razor
 LWWW R3RL1B+FR11,19,-79,1
 LWWW R3RL1B+FR10,28,-46,1
 LWWW R3RL1B+FR9,32,-28,1
 LWWW R3RL1B+FR8,32,-29,1
 LWWW R3RL1B+FR7,28,-47,1
 LWWW R3ZS3C+FR1,50,-34,1
 LWWW R3ZS3C+FR1,47,-50,1
 LWWW R3ZS3C+FR1,34,-49,1
 LWWW R3ZS3C+FR1,3,-48,1
 LWWW R3ZS3C+FR2,-9,-21,1
 LWWW R3ZS3C+FR2,-18,-17,1
 LWWW R3ZS3C+FR2,-15,-12,1
 LWWW R3ZS3C+FR3,-3,-8,1
 .long 0
#Taker
 LWWW U3CR3A+FR1,23,-73,1
 LWWW U3CR3A+FR3,25,-41,1
 LWWW U3CR3A+FR4,31,-24,1
 LWWW U3CR3A+FR5,31,-28,1
 LWWW U3CR3A+FR6,33,-46,1
 LWWW U3ZS3B+FR1,48,-38,1
 LWWW U3ZS3B+FR1,42,-54,1
 LWWW U3ZS3B+FR1,28,-53,1
 LWWW U3ZS3B+FR2,13,-22,1
 LWWW U3ZS3B+FR2,-9,-16,1
 LWWW U3ZS3B+FR2,-16,-12,1
 LWWW U3ZS3B+FR2,-14,-7,1
 LWWW U3ZS3B+FR3,-5,-9,1
 .long 0
#Yokozuna
 LWWW Y3RL1A+FR1,24,-65,1
 LWWW Y3RL1A+FR10,30,-35,1
 LWWW Y3RL1A+FR9,21,-24,1
 LWWW Y3RL1A+FR8,21,-30,1
 LWWW Y3RL1A+FR7,19,-43,1
 LWWW Y3ZS3A+FR1,36,-45,1
 LWWW Y3ZS3A+FR1,33,-61,1
 LWWW Y3ZS3A+FR1,21,-60,1
 LWWW Y3ZS3A+FR2,13,-28,1
 LWWW Y3ZS3A+FR2,-7,-22,1
 LWWW Y3ZS3A+FR2,-15,-18,1
 LWWW Y3ZS3A+FR2,-14,-13,1
 LWWW Y3ZS3A+FR3,-11,-2,1
 .long 0
#Shawn
 LWWW S3CP3B+FR7,27,-78,1
 LWWW S3RL3A+FR9,30,-32,1
 LWWW S3RL3A+FR8,30,-24,1
 LWWW S3RL3A+FR7,29,-33,1
 LWWW S3RL3A+FR6,32,-48,1
 LWWW S3ZS3A+FR1,45,-38,1
 LWWW S3ZS3A+FR1,39,-54,1
 LWWW S3ZS3A+FR1,25,-53,1
 LWWW S3ZS3A+FR2,1,-35,1
 LWWW S3ZS3A+FR2,-18,-29,1
 LWWW S3ZS3A+FR2,-22,-25,1
 LWWW S3ZS3A+FR2,-20,-20,1
 LWWW S3ZS3A+FR3,-8,-13,1
 .long 0
#BamBam
 LWWW B3RL1A+FR1,28,-69,1
 LWWW B3RL1A+FR11,30,-33,1
 LWWW B3RL1A+FR10,30,-19,1
 LWWW B3RL1A+FR9,26,-20,1
 LWWW B3RL1A+FR8,28,-40,1
 LWWW B3ZS3A+FR1,48,-39,1
 LWWW B3ZS3A+FR1,43,-55,1
 LWWW B3ZS3A+FR1,31,-54,1
 LWWW B3ZS3A+FR1,0,-53,1
 LWWW B3ZS3A+FR2,-6,-20,1
 LWWW B3ZS3A+FR2,-13,-16,1
 LWWW B3ZS3A+FR2,-14,-11,1
 LWWW B3ZS3A+FR3,-5,-5,1
 .long 0
#Doink
 LWWW D3GU4A+FR1,34,-80,1
 LWWW D3RL1B+FR11,35,-42,1
 LWWW D3RL1B+FR10,36,-27,1
 LWWW D3RL1B+FR9,35,-34,1
 LWWW D3RL1B+FR8,34,-42,1
 LWWW D3ZS3A+FR1,41,-47,1
 LWWW D3ZS3A+FR1,35,-63,1
 LWWW D3ZS3A+FR1,21,-62,1
 LWWW D3ZS3A+FR2,5,-27,1
 LWWW D3ZS3A+FR2,-14,-21,1
 LWWW D3ZS3A+FR2,-18,-17,1
 LWWW D3ZS3A+FR2,-16,-12,1
 LWWW D3ZS3A+FR3,-10,-15,1
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3RL1A+FR11,18,-74,1
 LWWW L3RL1A+FR1,25,-42,1
 LWWW L3RL1A+FR2,24,-29,1
 LWWW L3RL1A+FR3,19,-33,1
 LWWW L3RL1A+FR4,19,-48,1
 LWWW L3ZS3A+FR1,47,-26,1
 LWWW L3ZS3A+FR1,44,-42,1
 LWWW L3ZS3A+FR1,32,-41,1
 LWWW L3ZS3A+FR1,-1,-40,1
 LWWW L3ZS3A+FR2,-12,-25,1
 LWWW L3ZS3A+FR2,-20,-21,1
 LWWW L3ZS3A+FR2,-19,-16,1
 LWWW L3ZS3A+FR3,-5,-8,1
 .long 0
;
;#release_tbl
;	.long	hrt_hitonground_anim,rzr_hitonground_anim
;	.long	und_hitonground_anim,yok_hitonground_anim
;	.long	shn_hitonground_anim,bam_hitonground_anim
;	.long	dnk_hitonground_anim,0,lex_hitonground_anim

******************************************************************************

	.end
