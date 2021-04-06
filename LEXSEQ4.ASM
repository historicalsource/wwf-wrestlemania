**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		11/28/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"lexseq4.asm"
	.title	"blocks, reactions to routine and special attacks"
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
	.INCLUDE	"SWEAT.EQU"


******************************************************************************
* EXTERNAL REFERENCES

	.ref	ckzpos,CALL_ANI_AVERAGE_MOVE,DO_WAIL,DO_BLOCKED
	.ref	DO_SCREAM,free_toss_check,setup_freetoss,lex_hiptoss_anim

#*****************************************************************************
*
* #2 BLOCK & HITBLOCK

; SUBR	lex_2_block_anim
;
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
;	.word	ANI_SETSPEED,100h
;	.word	ANI_ZEROVELS
;	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
;	.word	ANI_SET_WRESTLER_XFLIP
;
;	WL	ANI_CODE,block_if_safe
;	WL	3,L2BK3A+FR1
;	.word	ANI_SETPLYRMODE,MODE_BLOCK
;	WL	3,L2BK3A+FR2
;#blk2	WL	3,L2BK3A+FR5
;	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT
;	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
;	.word	ANI_SETMODE,MODE_NOAUTOFLIP
;	.word	ANI_SETFACING
;	WL	2,L2BK3A+FR2
;	WL	2,L2BK3A+FR1
;	.word	ANI_SETPLYRMODE,MODE_NORMAL
;	.word	ANI_END
;
; SUBR	lex_2_hitblock_anim
;
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
;	.word	ANI_FRICTION,4000h
;	.word	ANI_SETSPEED,100h
;
;	WL	ANI_CODE,DO_BLOCKED
;	WL	4,L2BK3B+FR2
;	WL	4,L2BK3B+FR1
;	WL	ANI_GOTO,#blk2

#************
*
* #4 BLOCK & HITBLOCK

 SUBR	lex_4_block_anim

	.word	ANI_SETMODE,MODE_UNINT
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
;Rotate toward opponent if needed!

;	WL	ANI_CODE,block_if_safe
	.word	ANI_SETPLYRMODE,MODE_BLOCK
	WL	3,L4BK3B+FR3
;	.word	ANI_SETPLYRMODE,MODE_BLOCK
#blk4	WL	2,L4BK3B+FR5
	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT|MODE_FRICTION
;	.word	ANI_ZERO_XZVELS
	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_SETFACING
	WL	3,L4BK3B+FR3
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_4_hitblock_anim

	.word	ANI_SETMODE,MODE_UNINT
	.word	ANI_FRICTION,5000h
	.word	ANI_SETSPEED,100h
	WL	ANI_CODE,DO_BLOCKED
	WL	2,L4BK3C+FR2
	WL	2,L4BK3C+FR1
	WL	ANI_GOTO,#blk4

 SUBR	lex_4_hitblock2_anim

	.word	ANI_SETMODE,MODE_UNINT
	.word	ANI_FRICTION,4000h
	.word	ANI_SETSPEED,100h
	WL	ANI_CODE,DO_BLOCKED
	WL	ANI_SET_YVEL,38000h
	WL	3,L4BK3C+FR1
	WL	3,L4BK3C+FR2
	WL	3,L4BK3C+FR1
	WL	3,L4BK3C+FR2
	WL	3,L4BK3C+FR1
	WL	3,L4BK3C+FR2
	WL	ANI_GOTO,#blk4

#*****************************************************************************
*
* GENERIC BOUNCE

 SUBR	lex_slamnobounce_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	4,L3CP3X+FR3
	WL	4,L3CP3X+FR4
	WL	4,L3CP3X+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	2,L3CP3X+FR7
	WL	10,L3CP3X+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim

 SUBR	lex_slambounce_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,040000h

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	1,L3CP3X+FR3
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

	.word	ANI_OFFSET,30,59,0			;x,y,z

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYD_SWEAT,SWEAT_PER,0
	WL	4,L3UC3X+FR3
	WL	4,L3UC3X+FR4
	WL	1,L3UC3X+FR5

	.word	ANI_WAITHITGND

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30

	WL	3,L3UC3X+FR6
 	WL	3,L3FD3B+FR1
	WL	3,L3FD3B+FR2
	WL	3,L3FD3B+FR3
	WL	3,L3FD3B+FR4
	WL	3,L3FD3B+FR5

	.word	ANI_ZERO_XZVELS

	WL	3,L3FD3B+FR6
	WL	2,L3CP3X+FR7
	WL	ANI_CODE,HIT_THE_MAT
	WL	6,L3CP3X+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim

#*****************************************************************************

 SUBR	lex_arm_broken_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_XVEL,-38000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,10000h,AM_HIT_REL

	WL	ANI_CODE,DO_SCREAM
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	5,L4AH4A+FR3
	WL	5,L4AH4A+FR4
	WL	5,L4AH4A+FR5

	WL	1,L4ST4C+FR4
	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,lex_fall_back_anim
;	.word	ANI_END

#nodead
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 HEAD HIT

 SUBR	lex_2_head_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,L2AH2A+FR3
	WL	2,L2AH2A+FR4
	WL	3,L2AH2A+FR5
	WL	2,L2AH2A+FR6
	WL	3,L2AH2A+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

;From spin kick
 SUBR	lex_2_head_hit3_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,40000h

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,L2AH2A+FR3
	.word	ANI_DEBRIS,300,2,-23,102,0	;%chance, tbl index, x,y,z off
	WL	4,L2AH2A+FR4
	WL	4,L2AH2A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,L2AH2A+FR6
	WL	3,L2AH2A+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 HEAD HIT

 SUBR	lex_4_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	3,L4AH4A+FR1
	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,L4AH4A+FR2
	WL	2,L4AH4A+FR3
	WL	3,L4AH4A+FR4
	WL	2,L4AH4A+FR5
	WL	3,L4AH4A+FR6
	WL	2,L4AH4A+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

;From spin kick
 SUBR	lex_4_head_hit3_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-20000h,AM_ABS
	WL	ANI_SET_YVEL,40000h

	WL	3,L4AH4A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,L4AH4A+FR2
	WL	3,L4AH4A+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,L4AH4A+FR4
	WL	2,L4AH4A+FR5
	WL	3,L4AH4A+FR6
	WL	2,L4AH4A+FR7

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_4_head_hit4_anim
;From earslap

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	ANI_SET_YVEL,40000h

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	4,L4AH4A+FR3
	WL	3,L4AH4A+FR4
	WL	4,L4AH4A+FR5
	WL	3,L4AH4A+FR6
	WL	4,L4AH4A+FR7

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 HEAD HIT2 (HANDS ON FACE)

 SUBR	lex_2_head_hit2_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WLW	ANI_SET_XVEL,-40000h,AM_HIT_REL
	WL	ANI_SET_YVEL,30000h
	.word	ANI_FRICTION,3000h

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,L2AE2A+FR1
	WL	2,L2AE2A+FR2
	WL	3,L2AE2A+FR3
	WL	2,L2AE2A+FR4
	WL	3,L2AE2A+FR5
	WL	2,L2AE2A+FR6
	WL	3,L2AE2A+FR7
	WL	2,L2AE2A+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 HEAD HIT2 (HANDS ON FACE)

 SUBR	lex_4_head_hit2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WLW	ANI_SET_XVEL,-40000h,AM_HIT_REL
	WL	ANI_SET_YVEL,30000h
	.word	ANI_FRICTION,3000h

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,L4AE4A+FR1
	WL	3,L4AE4A+FR2
	WL	3,L4AE4A+FR3
	WL	3,L4AE4A+FR4
	WL	3,L4AE4A+FR5

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,lex_fall_back_anim
;	.word	ANI_END

#nodead
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_4_head_hit2s_anim
;Salt hits me in face

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP


	.ref	create_impact_salt
	WL	ANI_CODE,create_impact_salt

	WL	4,L4AE4A+FR1
	WL	4,L4AE4A+FR2
	WL	4,L4AE4A+FR3
	.word	ANI_WAITHITGND
	.word	ANI_FRICTION,4000h
	WL	50,L4AE4A+FR3
	.word	ANI_ZEROVELS
	WL	3,L4AE4A+FR4
	WL	3,L4AE4A+FR5

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* HEAD HIT2 (ENDS IN DIZZY)

 SUBR	lex_head_hit_dizzy_anim


	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WLW	ANI_SET_XVEL,-40000h,AM_HIT_REL
	WL	ANI_SET_YVEL,20000h
	.word	ANI_FRICTION,3000h
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	4,L4AE4A+FR1
	WL	4,L4AE4A+FR2
	WL	4,L4AE4A+FR3
	WL	4,L4AE4A+FR4
	WL	4,L4AE4A+FR5

	.word	ANI_FACEDOWN

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,lex_dizzy_anim

;	.word	ANI_END


#*****************************************************************************
*
* #2 BODY HIT

 SUBR	lex_2_body_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL

	WL	3,L2AM2B+FR2
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	.word	ANI_DEBRIS,100,0,6,72,0	;%chance, tbl index, x,y,z off
	WL	3,L2AM2B+FR3
	WL	3,L2AM2B+FR4
	WL	3,L2AM2B+FR5
	WL	3,L2AM2B+FR6
	WL	2,L2AM2B+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,L2AM2B+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_2_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,78000h

	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,4000h,AM_ABS

	WL	3,L2AM2B+FR2
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	.word	ANI_DEBRIS,100,0,6,72,0	;%chance, tbl index, x,y,z off
	WL	3,L2AM2B+FR3
	WL	3,L2AM2B+FR4
	WL	3,L2AM2B+FR5
	WL	3,L2AM2B+FR6
	WL	2,L2AM2B+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,L2AM2B+FR8

	.word	ANI_FACEUP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 BODY HIT

 SUBR	lex_4_body_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL

	WL	3,L4AM4B+FR2
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	.word	ANI_DEBRIS,100,0,6,72,0	;%chance, tbl index, x,y,z off
	WL	3,L4AM4B+FR3
	WL	3,L4AM4B+FR4
	WL	3,L4AM4B+FR5
	WL	3,L4AM4B+FR6
	WL	3,L4AM4B+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,L4AM4B+FR8

	.word	ANI_CHECKWORD,USR_VAR1
	WL	ANI_IFNOTSTATUS,#reg

	WL	8,L4TI4B+FR5
	WL	8,L4TI4B+FR6
	WL	8,L4TI4B+FR7
	WL	8,L4TI4B+FR8
	WL	8,L4TI4B+FR9
	WL	8,L4TI4B+FR8
	WL	8,L4TI4B+FR7
	WL	8,L4TI4B+FR6

#reg	
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_4_body_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	3,L4AM4B+FR2
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	.word	ANI_DEBRIS,100,0,6,72,0	;%chance, tbl index, x,y,z off
	WL	3,L4AM4B+FR3
	WL	3,L4AM4B+FR4
	WL	3,L4AM4B+FR5
	WL	3,L4AM4B+FR6
	WL	3,L4AM4B+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,L4AM4B+FR8

	.word	ANI_FACEDOWN

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,lex_dizzy_anim
;	.word	ANI_END

 SUBR	lex_4_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,78000h

	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-4000h,AM_ABS

	WL	3,L4AM4B+FR2
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	.word	ANI_DEBRIS,100,0,6,72,0	;%chance, tbl index, x,y,z off
	WL	3,L4AM4B+FR3
	WL	3,L4AM4B+FR4
	WL	3,L4AM4B+FR5
	WL	3,L4AM4B+FR6
	WL	3,L4AM4B+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,L4AM4B+FR8

	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_quick_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h

	WL	3,L4AM4B+FR2
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	3,L4AM4B+FR3
	WL	3,L4AM4B+FR4
	WL	3,L4AM4B+FR5
	WL	3,L4AM4B+FR6
	WL	3,L4AM4B+FR7
	WL	3,L4AM4B+FR8
	.word	ANI_WAITHITGND

	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,lex_fall_back_anim
;	.word	ANI_END

#nodead

	.ref	lex_3_head_held_anim
	WL	ANI_CHANGEANIM,lex_3_head_held_anim
;	.word	ANI_END

 SUBR	lex_4_knee_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,78000h

	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-4000h,AM_ABS

	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	4,L4AM4B+FR2
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	4,L4AM4B+FR3
	WL	4,L4AM4B+FR4
	WL	4,L4AM4B+FR5
	WL	4,L4AM4B+FR6
	WL	4,L4AM4B+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	4,L4AM4B+FR8

	.word	ANI_FACEDOWN

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,lex_dizzy_anim
;	.word	ANI_END

#*****************************************************************************
*
* HITS ON GROUND

 SUBR	lex_hitonground_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h

	WL	1,L3CP3X+FR2
	WL	ANI_SET_YVEL,39000h
	.word	ANI_DEBRIS,50,1,0,8,0		;%chance, tbl index, x,y,z off

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPITUP_SWEAT,SWEAT_PER,0
	WL	2,L3CP3X+FR2
	WL	3,L3CP3X+FR3
	WL	2,L3CP3X+FR4
	WL	3,L3CP3X+FR5
	WL	2,L3CP3X+FR6
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_ZEROVELS
	WL	3,L3CP3X+FR7
 SUBR	lex_liedown_anim
	WL	1,L3CP3X+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim

 SUBR	lex_up_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.WORD	ANI_XFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h

	WL	10,L3FH3A+FR2
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_ZEROVELS
	WL	3,L3CP3X+FR7
	WL	3,L3CP3X+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim

#*****************************************************************************
*
* FALL BACK

 SUBR	lex_fall_back_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCOLLIS
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZERO_XZVELS
	WL	ANI_MIN_YVEL,70000h
	WLW	ANI_SET_ZVEL,10000h,AM_FACE_REL

	.word	ANI_SCROLL_CTRL,LEX_TBUKLY

	WL	ANI_CODE,ckzpos

	WWL	ANI_SETLONG,DEBRIS_X,[102,13]	;Y,X of head
	WL	4,L3UC3A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYC_SWEAT,SWEAT_PER,0
	WWL	ANI_SETLONG,DEBRIS_X,[107,-2]	;Y,X of head
	WL	4,L3UC3A+FR2

;Need more frames here to make smoother!

	.word	ANI_OFFSET,0,47,0			;x,y,z

	WWL	ANI_SETLONG,DEBRIS_X,[39,-50]	;Y,X of head
	WL	4,L3UC3A+FR3
	WWL	ANI_SETLONG,DEBRIS_X,[28,-54]	;Y,X of head
	WL	4,L3UC3A+FR4
	WWL	ANI_SETLONG,DEBRIS_X,[13,-59]	;Y,X of head
	WL	4,L3UC3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	.word	ANI_DEBRIS,100,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,35

	.word	ANI_FRICTION,3000h

	WWL	ANI_SETLONG,DEBRIS_X,0		;Y,X of head
	.word	ANI_XFLIP
	WL	2,L3CP3X+FR2
	.word	ANI_BOUNCE,5

	WL	ANI_CHANGEANIM,lex_hitonground_anim

#*****************************************************************************
*
* FALL BACK

 SUBR	lex_fall_back2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,10000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	WL	ANI_CODE,ckzpos

;	WL	4,L3UC3A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYC_SWEAT,SWEAT_PER,0
	WL	4,L3UC3A+FR2

;Need more frames here to make smoother!

	.word	ANI_OFFSET,0,47,0			;x,y,z

	WL	4,L3UC3A+FR3
	WL	4,L3UC3A+FR4
	WL	4,L3UC3A+FR5
	.word	ANI_WAITHITGND

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,35

	.word	ANI_FRICTION,3000h

	.word	ANI_XFLIP
	WL	2,L3CP3X+FR2
	.word	ANI_BOUNCE,5

	WL	ANI_CHANGEANIM,lex_hitonground_anim


#*****************************************************************************
*
* FALL FROM TURNBUCKLE

 SUBR	lex_fall_back_tbukl_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETSPEED,100h

	WL	4,L3UC3A+FR1
	WL	4,L3UC3A+FR2

	.word	ANI_OFFSET,0,47,0			;x,y,z

	WL	4,L3UC3A+FR3
	WL	4,L3UC3A+FR4
	WL	4,L3UC3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_DAMAGE,D_HITCONCRETE

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,35

;	.word	ANI_FRICTION,3000h

	.word	ANI_XFLIP
	WL	2,L3CP3X+FR2
;	.word	ANI_BOUNCE,5

	WL	ANI_CHANGEANIM,lex_hitonground_anim

#*****************************************************************************
*
* THROWN FROM RING (shn_bslm, shn_frnk)

 SUBR	lex_flyout_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETSPEED,100h

	WWL	ANI_SETLONG,OBJ_GRAVITY,0f000h

	.word	ANI_SET_IDIOT
	WL	ANI_CODE,DO_WAIL
	WL	8,L3FH3A+FR4
#cont	WL	8,L3FH3A+FR5
	WL	1,L3FH3A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_ZEROVELS
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,60
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

	.word	ANI_DAMAGE,D_HIPTOSS

	WL	3,L3UC3X+FR6
	WL	3,L3UC3X+FR7
	WL	3,L3UC3X+FR8
	WL	3,L3UC3X+FR9
	WL	3,L3UC3X+FR10
	.word	ANI_XFLIP
	WL	1,L3CP3X+FR1
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim


 SUBR	lex_flyout2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETSPEED,100h
	WWL	ANI_SETLONG,OBJ_GRAVITY,0E000h

	.word	ANI_SET_IDIOT
	WL	ANI_CODE,DO_WAIL
	WL	ANI_GOTO,#cont

#*****************************************************************************
*

 SUBR	lex_faceup_getup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

;	WL	4,L3GU4A+FR1
;	WL	4,L3GU4A+FR2
	.ref	choose_2or4
	WL	ANI_CODE,choose_2or4
	WL	ANI_IFSTATUS,#getup_in_4

;#getup_in_2
	WL	2,L3GU2A+FR1
	WL	3,L3GU2A+FR2
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WL	2,L3GU2A+FR3
	WL	3,L3GU2A+FR4
	WL	2,L3GU2A+FR5
	WL	3,L3GU2A+FR6
	WL	2,L3GU2A+FR7
	WL	3,L3GU2A+FR8
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,L3GU2A+FR9
	WL	3,L3GU2A+FR10
	.word	ANI_SAFE_TIME,50

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,11,47,91,50
	WL	1,L3GU2A+FR10
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	.ref	lex_4_push_anim
	WL	ANI_CHANGEANIM,lex_4_push_anim
#no_freetoss

	.word	ANI_FACEUP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#getup_in_4
	WL	3,L3GU4A+FR1
	WL	2,L3GU4A+FR2
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WL	3,L3GU4A+FR3
	WL	2,L3GU4A+FR4
	WL	3,L3GU4A+FR5
	WL	2,L3GU4A+FR6
	WL	3,L3GU4A+FR7
	WL	2,L3GU4A+FR8
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	3,L3GU4A+FR9
	WL	2,L3GU4A+FR10
	.word	ANI_SAFE_TIME,50

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss2
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,11,47,91,50
	WL	1,L3GU4A+FR10
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss2

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,lex_4_push_anim
#no_freetoss2

	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* DIZZY

 SUBR	lex_dizzy_anim

	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_START_DIZZY,0	;0=Standing dizzy
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

#loop

	WL	8,L4TI4B+FR5
	WL	8,L4TI4B+FR6
	WL	8,L4TI4B+FR7
	WL	8,L4TI4B+FR8
	WL	8,L4TI4B+FR9
	WL	8,L4TI4B+FR8
	WL	8,L4TI4B+FR7
	WL	8,L4TI4B+FR6

	WL	ANI_GOTO,#loop

#*****************************************************************************

 SUBR	lex_roll_frames

	.word	7		;speed
	.long	50000h		;z velocity
	.long	10000h*10/255	;inv multiply (0-255 -> 0-11)

	.long	L3RL1A+FR11	;0
	.long	L3RL1A+FR10	;1
	.long	L3RL1A+FR9	;2
	.long	L3RL1A+FR8	;3
	.long	L3RL1A+FR7	;4
	.long	L3RL1A+FR6	;5
	.long	L3RL1A+FR5	;6
	.long	L3RL1A+FR4	;7
	.long	L3RL1A+FR3	;8
	.long	L3RL1A+FR2	;9
	.long	L3RL1A+FR1	;10
	.long	0,0,0,0,0,0


	.ref	HIT_THE_MAT,SMALL_BOUNCE

;FIX!!  Make throw out of ring if close to ropes
#*****************************************************************************
*
* FLIP/FALL FROM HIPTOSS

 SUBR	lex_tossed_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

;	.word	ANI_XFLIP

	WL	ANI_CODE,ckzpos

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_GETUP,STAY_TIME
	WL	ANI_CODE,HIT_THE_MAT
	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,50000h
;	.word	ANI_OFFSET,0,0,0	;x,y,z
	WL	3,L3CP3X+FR2
	WL	3,L3CP3X+FR3
	WL	3,L3CP3X+FR4
	WL	3,L3CP3X+FR5

	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_ZEROVELS

	WL	3,L3CP3X+FR6
	WL	3,L3CP3X+FR7
	WL	3,L3CP3X+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim

;FIX!!  Make throw out of ring if close to ropes
#*****************************************************************************
*
* FLIP/FALL FROM BAM BAM DUCK TOSS

 SUBR	lex_tossed2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,ckzpos

	WLW	ANI_SET_XVEL,60000h,AM_HIT_REL
	WL	ANI_SET_YVEL,30000h
	.word	ANI_OFFSET,20,20,0			;x,y,z
	WL	4,L3FH3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_GETUP,STAY_TIME
	.word	ANI_DAMAGE,D_HIPTOSS

	WL	4,L3FH3A+FR6
	.word	ANI_XFLIP
	.word	ANI_OFFSET,20,0,0			;x,y,z
	WL	3,L3CP3X+FR1

	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,50000h
	WL	3,L3CP3X+FR2
	WL	3,L3CP3X+FR3
	WL	3,L3CP3X+FR4
	WL	3,L3CP3X+FR5

	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,L3CP3X+FR6
	WL	3,L3CP3X+FR7
	WL	3,L3CP3X+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim
;	.word	ANI_END

******************************************************************************

	.end
