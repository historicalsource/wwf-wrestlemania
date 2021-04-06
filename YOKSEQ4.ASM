**************************************************************
*
* Software:		Jason Skiles
* Initiated:		26 Aug 94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"yokseq4.asm"
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
	.include	"yokoimg.h"
	.include	"display.equ"
	.include	"ring.equ"
	.include	"damage.equ"
	.INCLUDE	"SWEAT.EQU"


******************************************************************************
* EXTERNAL REFERENCES

	;YOKO
	.ref	yok_3_head_held_anim,yok_2_hiptoss_anim

	;MISC
	.ref	HIT_THE_MAT,SMALL_BOUNCE,am_I_dead,ckzpos
	.ref	DO_BLOCKED,DO_SCREAM,free_toss_check,setup_freetoss

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE


#*****************************************************************************
*
* #4 BLOCK + HITBLOCK

 SUBR	yok_4_block_anim

	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

;	WL	ANI_CODE,block_if_safe
	.word	ANI_SETPLYRMODE,MODE_BLOCK
	WL	3,Y4BK3A+FR3
;	.word	ANI_SETPLYRMODE,MODE_BLOCK

#hold_block
	WL	2,Y4BK3A+FR5
	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT|MODE_FRICTION
;	.word	ANI_ZERO_XZVELS
	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
	.word	ANI_SETMODE,MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETFACING
	WL	3,Y4BK3A+FR3

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	yok_4_hitblock_anim
	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT
	.word	ANI_FRICTION,5000h
	.word	ANI_SETSPEED,100h
	WL	ANI_CODE,DO_BLOCKED
	WL	2,Y4BK3A+FR6
	WL	2,Y4BK3A+FR5
	WL	ANI_GOTO,#hold_block

 SUBR	yok_4_hitblock2_anim
	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT
	.word	ANI_FRICTION,4000h
	.word	ANI_SETSPEED,100h
	WL	ANI_CODE,DO_BLOCKED
	WL	ANI_SET_YVEL,38000h
	WL	3,Y4BK3A+FR6
	WL	3,Y4BK3A+FR5
	WL	3,Y4BK3A+FR6
	WL	3,Y4BK3A+FR5
	WL	3,Y4BK3A+FR6
	WL	3,Y4BK3A+FR5
	WL	ANI_GOTO,#hold_block


#*****************************************************************************
*
* #4 LOSE BALANCE

#FRICTION_VAL	equ	3000h

 SUBR	yok_4_losebal_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_FRICTION,#FRICTION_VAL
	.word	ANI_SETSPEED,100h
	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,Y4PB3A+FR1
	WL	3,Y4PB3A+FR2
	WL	3,Y4PB3A+FR3
	WL	3,Y4PB3A+FR4
	WL	3,Y4PB3A+FR5
	WL	3,Y4PB3A+FR6
	WL	3,Y4PB3A+FR7
	WL	3,Y4PB3A+FR8
	WL	3,Y4PB3A+FR9

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 HEAD HIT

 SUBR	yok_2_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,Y2AH2A+FR2
	WL	3,Y2AH2A+FR3
	WL	3,Y2AH2A+FR4
	WL	3,Y2AH2A+FR5
	WL	3,Y2AH2A+FR6
	WL	3,Y2AH2A+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 HEAD HIT

 SUBR	yok_4_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,Y4AH4A+FR2
	WL	3,Y4AH4A+FR3
	WL	3,Y4AH4A+FR4
	WL	3,Y4AH4A+FR5
	WL	3,Y4AH4A+FR6
	WL	3,Y4AH4A+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************
*
* #2 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	yok_2_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

;	WL	3,Y2AH2A+FR2
;	WL	15,Y2AH2A+FR3
;	WL	4,Y2AH2A+FR4


	WL	1,Y4PS3B+FR4
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_XVEL,30000h,AM_FACE_REL

	WL	2,Y4PS3B+FR4
	WL	2,Y4PS3B+FR5
	WL	1,Y4PS3B+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	20,Y4PS3B+FR6
	WL	3,Y4PS3B+FR7
	WL	3,Y4PS3B+FR8
	WL	3,Y4PS3B+FR9

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	yok_4_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

;	WL	3,Y4AH4A+FR2
;	WL	3,Y4AH4A+FR3
;	WL	14,Y4AH4A+FR4
;	WL	2,Y4AH4A+FR5

	WL	1,Y4PS3B+FR4
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_XVEL,30000h,AM_FACE_REL

	WL	2,Y4PS3B+FR4
	WL	2,Y4PS3B+FR5
	WL	1,Y4PS3B+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	20,Y4PS3B+FR6
	WL	3,Y4PS3B+FR7
	WL	3,Y4PS3B+FR8
	WL	3,Y4PS3B+FR9
	WL	3,Y4PS3B+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************
*
* #2 RUNNING BOUNCE OFF OF GATE

 SUBR	yok_2_bncoff_gate_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

	WL	3,Y2AH2A+FR2
	WL	15,Y2AH2A+FR3
	WL	4,Y2AH2A+FR4

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 RUNNING BOUNCE OFF OF GATE

 SUBR	yok_4_bncoff_gate_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

	WL	3,Y4AH4A+FR2
	WL	3,Y4AH4A+FR3
	WL	14,Y4AH4A+FR4
	WL	2,Y4AH4A+FR5

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


* #4 RUNNING BOUNCE OFF OF OPPONENT

;Bounce off but stay dizzy!

 SUBR	yok_4_bncoff_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	3,Y4AH4A+FR2
	WL	3,Y4AH4A+FR3
	WL	14,Y4AH4A+FR4
	WL	2,Y4AH4A+FR5

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,yok_dizzy_anim
;	.word	ANI_END

#************
*
* #4 HEAD HIT2 (hands on face)

 SUBR	yok_2_head_hit2_anim
 SUBR	yok_4_head_hit2_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,Y4AE4A+FR1
	WL	3,Y4AE4A+FR2
	WL	3,Y4AE4A+FR3
	WL	2,Y4AE4A+FR4
	WL	3,Y4AE4A+FR5
	WL	2,Y4AE4A+FR6
	WL	3,Y4AE4A+FR7
	WL	2,Y4AE4A+FR8
	WL	3,Y4AE4A+FR9

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,yok_fall_back_anim
;	.word	ANI_END

#nodead
	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
       	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	yok_4_head_hit2s_anim
;Salt hits me in face

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.ref	create_impact_salt
	WL	ANI_CODE,create_impact_salt

	WL	3,Y4AE4A+FR1
	WL	3,Y4AE4A+FR2
	WL	3,Y4AE4A+FR3
	WL	3,Y4AE4A+FR4
	WL	3,Y4AE4A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_FRICTION,4000h
	WL	50,Y4AE4A+FR5
	.word	ANI_ZEROVELS
	WL	3,Y4AE4A+FR6
	WL	2,Y4AE4A+FR7
	WL	3,Y4AE4A+FR8
	WL	2,Y4AE4A+FR9

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
       	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #2 HEAD HIT - From spin kick

 SUBR	yok_2_head_hit3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,40000h

	WL	3,Y2AH2A+FR1
	.word	ANI_DEBRIS,150,2,-21,100,0	;%chance, tbl index, x,y,z off
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,Y2AH2A+FR2
	WL	3,Y2AH2A+FR3
	WL	1,Y2AH2A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,Y2AH2A+FR5
	WL	3,Y2AH2A+FR6
	WL	2,Y2AH2A+FR7

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 HEAD HIT - From spin kick

 SUBR	yok_4_head_hit3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-20000h,AM_ABS
	WL	ANI_SET_YVEL,40000h

	WL	3,Y4AH4A+FR1
	.word	ANI_DEBRIS,150,2,-21,100,0	;%chance, tbl index, x,y,z off
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,Y4AH4A+FR2
	WL	3,Y4AH4A+FR3
	WL	1,Y4AH4A+FR4

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	2,Y4AH4A+FR5
	WL	3,Y4AH4A+FR6
	WL	2,Y4AH4A+FR7

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	yok_4_head_hit4_anim

;From earslap

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,40000h

	WL	3,Y4AH4A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,Y4AH4A+FR2
	WL	3,Y4AH4A+FR3
	WL	3,Y4AH4A+FR4

	WL	2,Y4AH4A+FR5
	WL	3,Y4AH4A+FR6
	WL	2,Y4AH4A+FR7

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 HEAD HIT (ends in dizzy)

 SUBR	yok_4_head_hit_dizzy_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETSPEED,100h
	WLW	ANI_SET_XVEL,-60000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h

	.word	ANI_SETPLYRMODE,MODE_DIZZY

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	4,Y4AE4A+FR1
	WL	4,Y4AE4A+FR2
	WL	4,Y4AE4A+FR3
	WL	4,Y4AE4A+FR4
	WL	4,Y4AE4A+FR5
	WL	4,Y4AE4A+FR6
	WL	4,Y4AE4A+FR7
	WL	4,Y4AE4A+FR8
	WL	4,Y4AE4A+FR9

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,yok_dizzy_anim

#*****************************************************************************
*
* #2 BODY HIT

 SUBR	yok_2_body_hit_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,30000h
	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL

	.word	ANI_DEBRIS,150,0,-4,71,0	;%chance, tbl index, x,y,z off

	WL	3,Y2AM2C+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	3,Y2AM2C+FR2
	WL	1,Y2AM2C+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,Y2AM2C+FR4
	WL	3,Y2AM2C+FR5
	WL	2,Y2AM2C+FR6
	WL	3,Y2AM2C+FR7
	WL	2,Y2AM2C+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 BODY HIT

 SUBR	yok_4_body_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,30000h
	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL

	.word	ANI_DEBRIS,150,0,-4,71,0	;%chance, tbl index, x,y,z off

	WL	3,Y4AM4A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	3,Y4AM4A+FR2
	WL	1,Y4AM4A+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,Y4AM4A+FR4
	WL	2,Y4AM4A+FR5
	WL	3,Y4AM4A+FR6
	WL	2,Y4AM4A+FR7
	WL	3,Y4AM4A+FR8
	.word	ANI_CHECKWORD,USR_VAR1
	WL	ANI_IFNOTSTATUS,#reg

	WL	10,Y4TI4C+FR4
	WL	10,Y4TI4C+FR5
	WL	10,Y4TI4C+FR6
	WL	10,Y4TI4C+FR7
	WL	10,Y4TI4C+FR8
	WL	10,Y4TI4C+FR7
	WL	10,Y4TI4C+FR6
	WL	10,Y4TI4C+FR5

	WL	10,Y4TI4C+FR4
	WL	10,Y4TI4C+FR5
	WL	10,Y4TI4C+FR6
	WL	10,Y4TI4C+FR7
	WL	10,Y4TI4C+FR8

#reg
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	yok_4_body_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,30000h
	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	.word	ANI_DEBRIS,150,0,-4,71,0	;%chance, tbl index, x,y,z off

	WL	4,Y4AM4A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	4,Y4AM4A+FR2
	WL	1,Y4AM4A+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	4,Y4AM4A+FR4
	WL	4,Y4AM4A+FR5
	WL	4,Y4AM4A+FR6
	WL	4,Y4AM4A+FR7
	WL	4,Y4AM4A+FR8

	.word	ANI_FACEDOWN
;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,yok_dizzy_anim
;	.word	ANI_END

* #4 BODY HIT FROM KNEE

 SUBR	yok_4_knee_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,60000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,8000h,AM_ABS
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	.word	ANI_DEBRIS,150,0,-4,71,0	;%chance, tbl index, x,y,z off

	WL	4,Y4AM4A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	4,Y4AM4A+FR2
	WL	1,Y4AM4A+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	4,Y4AM4A+FR4
	WL	4,Y4AM4A+FR5
	WL	4,Y4AM4A+FR6
	WL	4,Y4AM4A+FR7
	WL	4,Y4AM4A+FR8

	.word	ANI_FACEDOWN
;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,yok_dizzy_anim
;	.word	ANI_END

 SUBR	yok_2_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,60000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,8000h,AM_ABS

	.word	ANI_DEBRIS,150,0,-4,71,0	;%chance, tbl index, x,y,z off

	WL	3,Y2AM2C+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	3,Y2AM2C+FR2
	WL	1,Y2AM2C+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,Y2AM2C+FR4
	WL	2,Y2AM2C+FR5
	WL	3,Y2AM2C+FR6
	WL	2,Y2AM2C+FR7
	WL	3,Y2AM2C+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	yok_4_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,60000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,8000h,AM_ABS

	.word	ANI_DEBRIS,150,0,-4,71,0	;%chance, tbl index, x,y,z off

	WL	3,Y4AM4A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	3,Y4AM4A+FR2
	WL	1,Y4AM4A+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,Y4AM4A+FR4
	WL	2,Y4AM4A+FR5
	WL	3,Y4AM4A+FR6
	WL	2,Y4AM4A+FR7
	WL	3,Y4AM4A+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	yok_quick_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	WL	ANI_SET_YVEL,10000h
	.word	ANI_SETSPEED,100h

	.word	ANI_OFFSET,0,0,2			;x,y,z

	WL	ANI_SET_YVEL,38000h
;	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL
 
	WL	4,Y4AM4A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	3,Y4AM4A+FR2
	WL	3,Y4AM4A+FR3
	WL	3,Y4AM4A+FR2
	WL	3,Y4AM4A+FR4
	WL	3,Y4AM4A+FR5
	WL	3,Y4AM4A+FR6
	WL	3,Y4AM4A+FR7
	WL	3,Y4AM4A+FR8

	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,yok_fall_back_anim
;	.word	ANI_END

#nodead

	.word	ANI_FACEDOWN
	WL	ANI_CHANGEANIM,yok_3_head_held_anim
;	.word	ANI_END

******************************************************************************
*
* #3 FALL DOWN

 SUBR	yok_fall_back_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCOLLIS
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZERO_XZVELS
	WL	ANI_MIN_YVEL,58000h
	WLW	ANI_SET_ZVEL,10000h,AM_FACE_REL

	.word	ANI_SCROLL_CTRL,YOK_TBUKLY
	WL	ANI_CODE,ckzpos

	WWL	ANI_SETLONG,DEBRIS_X,[99,-20]	;Y,X of head
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYC_SWEAT,SWEAT_PER,0
	WL	4,Y3FD3A+FR1
	WWL	ANI_SETLONG,DEBRIS_X,[99,-32]	;Y,X of head
	WL	4,Y3FD3A+FR2
	.word	ANI_OFFSET,0,41,0			;x,y,z
	WWL	ANI_SETLONG,DEBRIS_X,[49,-38]	;Y,X of head
	WL	4,Y3FD3A+FR3
	WWL	ANI_SETLONG,DEBRIS_X,[37,-49]	;Y,X of head
	WL	4,Y3FD3A+FR4
	WWL	ANI_SETLONG,DEBRIS_X,[26,-51]	;Y,X of head
	WL	4,Y3FD3A+FR5
	.word	ANI_WAITHITGND

	.word	ANI_DEBRIS,200,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,50

	.word	ANI_FRICTION,3000h

	WWL	ANI_SETLONG,DEBRIS_X,[9,-45]	;Y,X of head
	WL	2,Y3FD3A+FR6
	.word	ANI_BOUNCE,4
	WL	2,Y3FD3A+FR6
	WWL	ANI_SETLONG,DEBRIS_X,[9,-45]	;Y,X of head
	WL	2,Y3FD3A+FR7
	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WWL	ANI_SETLONG,DEBRIS_X,0		;Y,X of head

;Stay on ground for awhile...  Maybe this will be table driven
	.word	ANI_XFLIP
	WL	1,Y3RL1A+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,yok_faceup_getup_anim
;	.word	ANI_END

******************************************************************************
*
* #3 FALL DOWN

 SUBR	yok_fall_back2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,10000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS
	WL	ANI_CODE,ckzpos

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYC_SWEAT,SWEAT_PER,0
	WL	4,Y3FD3A+FR1
	WL	4,Y3FD3A+FR2
	.word	ANI_OFFSET,0,41,0			;x,y,z
	WL	4,Y3FD3A+FR3
	WL	4,Y3FD3A+FR4
	WL	4,Y3FD3A+FR5
	.word	ANI_WAITHITGND

	.word	ANI_DEBRIS,150,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,50
	.word	ANI_ZEROVELS		
	WLW	ANI_SET_ZVEL,18000h,AM_ABS
	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL

	.word	ANI_OFFSET,-20,0,0			;x,y,z

	WL	3,Y3FD3N+FR1
	WL	3,Y3FD3N+FR2
	WL	3,Y3FD3N+FR3
	WL	3,Y3FD3N+FR4
	WL	3,Y3FD3N+FR5
	WL	3,Y3FD3N+FR6
	WL	3,Y3FD3N+FR7
	WL	3,Y3FD3N+FR8
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_OFFSET,-20,0,0			;x,y,z
	.word	ANI_ZEROVELS		
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	3,Y3KF3B+FR1		
	WL	3,Y3KF3B+FR2		
	WL	3,Y3KF3B+FR3		
	WL	3,Y3KF3B+FR4		
	WL	3,Y3KF3B+FR5		
	WL	ANI_CODE,HIT_THE_MAT
	WL	30,Y3KF3B+FR6

	WL	ANI_CHANGEANIM,yok_faceup_getup_anim
;	.word	ANI_END

#*****************************************************************************
*
* GETUPS

 SUBR	yok_faceup_getup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	WL	2,Y3GU2A+FR1
	WL	3,Y3GU2A+FR2
	WL	2,Y3GU2A+FR3
	WL	ANI_GOTO,#common

	;like above, but skip first three frames
 SUBR	yok_faceup_getup2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

#common
	WL	3,Y3GU2A+FR4
	WL	2,Y3GU2A+FR6
	WL	3,Y3GU2A+FR7
	WL	2,Y3GU2A+FR8
	WL	3,Y3GU2A+FR10
	WL	2,Y3GU2A+FR11
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WL	3,Y3GU2A+FR12

	WL	ANI_CODE,#choose_2or4
	WL	ANI_IFSTATUS,#getup_in_4

#getup_in_2

	WL	3,Y3GU2A+FR13
	WL	2,Y3GU2A+FR14
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	1,Y3GU2A+FR14

	.word	ANI_SAFE_TIME,50
  
	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,0,44,52-8,52
	WL	1,Y3GU2A+FR14
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,yok_4_push_anim
#no_freetoss

	.word	ANI_FACEUP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#getup_in_4
	WL	3,Y3GU4A+FR13
	WL	2,Y3GU4A+FR14
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	1,Y3GU4A+FR14

	.word	ANI_SAFE_TIME,50

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss2
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,0,44,52-8,52
	WL	1,Y3GU4A+FR14
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss2

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	.ref	yok_4_push_anim
	WL	ANI_CHANGEANIM,yok_4_push_anim
#no_freetoss2

	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

*****
* set status bit for a getup in 4, clear for a 2.
#choose_2or4

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

 SUBR	yok_dizzy_anim

	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_START_DIZZY,0	;0=Standing dizzy
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

#loop
	WL	10,Y4TI4C+FR4
	WL	10,Y4TI4C+FR5
	WL	10,Y4TI4C+FR6
	WL	10,Y4TI4C+FR7
	WL	10,Y4TI4C+FR8
	WL	10,Y4TI4C+FR7
	WL	10,Y4TI4C+FR6
	WL	10,Y4TI4C+FR5

	WL	ANI_GOTO,#loop

#*****************************************************************************
*
* HITS ON GROUND

 SUBR	yok_hitonground_xflip_anim
	.word	ANI_XFLIP

 SUBR	yok_hitonground_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h
	WL	1,Y3CP3B+FR1
	WL	ANI_SET_YVEL,34000h

	.word	ANI_DEBRIS,50,1,0,8,0		;%chance, tbl index, x,y,z off
	WL	2,Y3CP3B+FR1

	WL	2,Y3CP3B+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPITUP_SWEAT,SWEAT_PER,0
	WL	2,Y3CP3B+FR2
	WL	2,Y3CP3B+FR3
	WL	2,Y3CP3B+FR4
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	2,Y3CP3B+FR5
	WL	2,Y3CP3B+FR6
	WL	2,Y3CP3B+FR7
	WL	2,Y3CP3B+FR8
 SUBR	yok_liedown_anim
	WL	1,Y3RL1A+FR1
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,yok_faceup_getup_anim

 SUBR	yok_up_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.WORD	ANI_XFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h
	WL	10,Y3FL3W+FR3

	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_ZEROVELS
	WL	3,Y3CP3B+FR5
	WL	3,Y3CP3B+FR6
	WL	3,Y3CP3B+FR7
	WL	3,Y3CP3B+FR8
	WL	3,Y3RL1A+FR1
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,yok_faceup_getup_anim

#*****************************************************************************
*
* Head slams into mat
;From head slam - repeated head slam

 SUBR	yok_break_face2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	.word	ANI_ZEROVELS

	WL	2,Y3KF3B+FR1		;Face down
	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off
	WL	ANI_SET_YVEL,80000h
	WL	3,Y3KF3B+FR2		;Face down
	WL	3,Y3KF3B+FR3		;Face down
	WL	3,Y3KF3B+FR4		;Face down
	WL	3,Y3KF3B+FR5		;Face down
	WL	3,Y3KF3B+FR6		;Face down
	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	.word	ANI_WAITROLL
	WL	3,Y3KF3B+FR1		;Face down
	WL	ANI_CHANGEANIM,yok_faceup_getup_anim
	
 SUBR	yok_break_face3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS

	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off
	WL	3,Y3MS3Z+FR4
	WL	ANI_SET_YVEL,078000h
	WL	100,Y3MS3Z+FR4
	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,yok_faceup_getup_anim
	


* Head slams into mat
;From head slam

 SUBR	yok_break_face_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	.word	ANI_ZEROVELS

	WL	2,Y3KF3B+FR1		;Face down
	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off
	WL	ANI_SET_YVEL,40000h
	WL	1,Y3KF3B+FR1		;Face down
	WL	3,Y3KF3B+FR2		;Face down
	WL	3,Y3KF3B+FR3		;Face down
	WL	3,Y3KF3B+FR4		;Face down
	WL	3,Y3KF3B+FR5		;Face down
	WL	3,Y3KF3B+FR6		;Face down
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,Y3KF3B+FR2		;Face down
	WL	3,Y3KF3B+FR3		;Face down
	WL	3,Y3KF3B+FR4		;Face down
	WL	3,Y3KF3B+FR5		;Face down

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	3,Y3KF3B+FR6		;Face down
	.word	ANI_WAITROLL

	WL	ANI_CHANGEANIM,yok_faceup_getup_anim
;	.word	ANI_END
	

#*****************************************************************************
*
* ROLL OVER AND BREAK YER STINKIN' NECK
*

 SUBR	yok_break_neck_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim

	WL	9,Y3FD3N+FR4

	;pick an action, roll or fall back
	WWWL	ANI_IFROPE,RC_EITHER,100,#fall_back

	;plenty o' room. roll over
	.word	ANI_OFFSET,-5,0,0
	WL	4,Y3FD3N+FR5
	.word	ANI_OFFSET,-6,0,0
	WL	4,Y3FD3N+FR6
	.word	ANI_OFFSET,-6,0,0
	WL	4,Y3FD3N+FR7
	.word	ANI_OFFSET,-19,0,0
	WL	4,Y3FD3N+FR8

	;hit.  stay
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_OFFSET,-39,0,0
	WL	3,Y3RL1A+FR6

	.word	ANI_FACEDOWN
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,yok_faceup_getup_anim

#fall_back
	;sans.  no room.  fall back
	.word	ANI_OFFSET,-2,0,0
	WL	6,Y3FD3N+FR3
	.word	ANI_OFFSET,-2,0,0
	WL	6,Y3FD3N+FR2
	.word	ANI_OFFSET,-3,0,0
	WL	6,Y3FD3N+FR1
	.word	ANI_OFFSET,-27,0,0
	.word	ANI_XFLIP
	WL	6,Y3RL1A+FR1	;10

	.word	ANI_FACEDOWN
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,yok_faceup_getup_anim


#*****************************************************************************

 SUBR	yok_roll_frames

	.word	7		;speed
	.long	50000h		;z velocity
	.long	10000h*9/255	;inv multiply (0-255 -> 0-9)

	.long	Y3RL1A+FR1	;0
	.long	Y3RL1A+FR2	;1
	.long	Y3RL1A+FR3	;2
	.long	Y3RL1A+FR4	;3
	.long	Y3RL1A+FR5	;4
	.long	Y3RL1A+FR6	;5
	.long	Y3RL1A+FR7	;6
	.long	Y3RL1A+FR8	;7
	.long	Y3RL1A+FR9	;8
	.long	Y3RL1A+FR10	;9
	.long	0,0,0,0,0,0,0


#*****************************************************************************
*
* END OF BACK BROKEN SEQ.

 SUBR	yok_backbroken_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
;	.word	ANI_DETACH

	.word	ANI_GRAVITY_OFF
	WL	5,Y3BR3Z+FR1
	.word	ANI_GRAVITY_ON

	WL	ANI_SET_YVEL,070000h
	WLW	ANI_SET_ZVEL,20000h,AM_ABS

	WL	25,Y3BR3Z+FR1

;	WL	4,Y3BR3Z+FR2
	.word	ANI_XFLIP
	WL	4,Y3CP3B+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_BOUNCE,2
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_DEBRIS,150,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	4,Y3CP3B+FR1
	WL	4,Y3CP3B+FR2
	WL	4,Y3CP3B+FR3
	WL	4,Y3CP3B+FR4
	WL	4,Y3CP3B+FR5
	WL	4,Y3CP3B+FR6
	WL	4,Y3CP3B+FR7
	WL	4,Y3CP3B+FR8
	WL	4,Y3RL1A+FR1

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

;No stars around head here...

	.word	ANI_DETACH

	WL	3,Y3RL1A+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,yok_faceup_getup_anim
;	.word	ANI_END

#*****************************************************************************
*
* GENERIC BOUNCE

 SUBR	yok_slamnobounce_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_XFLIP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	1,Y3CP3B+FR1
	WL	4,Y3CP3B+FR1
	WL	4,Y3CP3B+FR2
	WL	4,Y3CP3B+FR3
	WL	4,Y3CP3B+FR4

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	2,Y3CP3B+FR6
	WL	10,Y3RL1A+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,yok_faceup_getup_anim

 SUBR	yok_slambounce_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,040000h

	.word	ANI_XFLIP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_DEBRIS,150,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	1,Y3CP3B+FR1
	.ref	ckzpos
	WL	ANI_CODE,ckzpos
	WL	4,Y3CP3B+FR1
	WL	4,Y3CP3B+FR2
	WL	4,Y3CP3B+FR3
	WL	4,Y3CP3B+FR4

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	2,Y3CP3B+FR6
	WL	10,Y3RL1A+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,yok_faceup_getup_anim

 SUBR	yok_slambounce2_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_XFLIP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_DEBRIS,150,1,0,8,0		;%chance, tbl index, x,y,z off


	WL	1,Y3FD3Z+FR7
	WL	ANI_CODE,ckzpos
	WL	3,Y3FD3Z+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_XFLIP
	WL	ANI_SET_YVEL,030000h

	WL	4,Y3CP3B+FR1
	WL	4,Y3CP3B+FR2
	WL	4,Y3CP3B+FR3
	WL	4,Y3CP3B+FR4

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	WL	ANI_CODE,HIT_THE_MAT

	WL	2,Y3CP3B+FR6
	WL	10,Y3RL1A+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,yok_faceup_getup_anim

#*****************************************************************************

 SUBR	yok_breakneck2_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYD_SWEAT,SWEAT_PER,0
	WL	4,Y3FD3A+FR2
	.word	ANI_OFFSET,0,41,0	;x,y,z
	WL	4,Y3FD3A+FR3
	WL	4,Y3FD3A+FR4
	WL	4,Y3FD3A+FR5

	.word	ANI_WAITHITGND

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,50
	.word	ANI_BOUNCE,3
	.word	ANI_FRICTION,2000h

	WL	4,Y3FD3A+FR6
	WL	3,Y3FD3N+FR1
	WL	3,Y3FD3N+FR2
	WL	3,Y3FD3N+FR3
	WL	3,Y3FD3N+FR4
	WL	3,Y3FD3N+FR5
	WL	3,Y3FD3N+FR6
	WL	3,Y3FD3N+FR7
	WL	3,Y3FD3N+FR8

	.word	ANI_ZERO_XZVELS
	.word	ANI_SHAKER,20

	WL	ANI_CODE,HIT_THE_MAT
	WL	8,Y3RL1A+FR6

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,yok_faceup_getup_anim

#*****************************************************************************

 SUBR	yok_arm_broken_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_XVEL,-38000h,AM_HIT_REL

	WL	ANI_CODE,DO_SCREAM
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,Y4AH4A+FR3
	WL	3,Y4AH4A+FR4
	WL	3,Y4AH4A+FR5
	WL	3,Y4AH4A+FR6

	WL	1,Y4ST4Y+FR4
	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,yok_fall_back_anim
;	.word	ANI_END

#nodead
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************

	.end
