**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		5/12/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"admseq3.asm"
	.title	"Adam Bomb animation sequences"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"macros.h"
	.include	"mproc.equ"		;Mproc equates
	.include	"sys.equ"
	.include	"display.equ"
	.include	"game.equ"
	.include	"plyr.equ"
	.include	"anim.equ"
	.include	"sound.h"
	.include	"ring.equ"

	.include	"adamimg.h"


******************************************************************************
* EXTERNAL REFERENCES

	.ref	wres_get_stick_val_cur
	.ref	RNDRNG0
	.ref	set_target_offsets
	.ref	get_opp_process

	.ref	get_leap
	.ref	shake_all_ropes

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

TSEC 	equ	53

#*****************************************************************************

 SUBR	adm_2_break_lockup_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WLW	ANI_SET_XVEL,-30000h,1		;facing relative
	.word	ANI_FRICTION,3000h
	WL	3,A2FG3A+FR4
	WL	3,A2FG3A+FR3
	WL	3,A2FG3A+FR2
	WL	3,A2FG3A+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************

 SUBR	adm_2_lockup_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	4,A2FG3A+FR1
	WL	4,A2FG3A+FR2
	WL	4,A2FG3A+FR3
	WL	4,A2FG3A+FR4
	WL	4,A2FG3A+FR5
	.word	ANI_ATTACK_ON, AMODE_GRAPPLE,24,-100,48,28 ;mode,x,y,w,h
	WL	4,A2FG3A+FR6
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#grapple
	WL	4,A2FG3A+FR5
	WL	4,A2FG3A+FR4
	WL	4,A2FG3A+FR3
	WL	4,A2FG3A+FR2
	WL	4,A2FG3A+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#grapple
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_SLAVE,S4_GRAPPLE,3
	WL	8,A2GR3Z+FR5

	.word	ANI_SLAVE,S4_GRAPPLE,2
	WL	8,A2GR3Z+FR6

	.word	ANI_SLAVE,S4_GRAPPLE,1
	WL	8,A2GR3Z+FR7

	.word	ANI_SLAVE,S4_GRAPPLE,0
	WL	8,A2GR3Z+FR8

	.word	ANI_SLAVE,S4_GRAPPLE,1
	WL	8,A2GR3Z+FR7

	.word	ANI_SLAVE,S4_GRAPPLE,2
	WL	8,A2GR3Z+FR6

	WL	ANI_GOTO,#grapple


#*****************************************************************************

 SUBR	adm_4_break_lockup_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WLW	ANI_SET_XVEL,-30000h,1		;facing relative
	.word	ANI_FRICTION,3000h
	WL	3,A4FG3A+FR4
	WL	3,A4FG3A+FR3
	WL	3,A4FG3A+FR2
	WL	3,A4FG3A+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************

 SUBR	adm_4_lockup_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	4,A4FG3A+FR1
	WL	4,A4FG3A+FR2
	WL	4,A4FG3A+FR3
	WL	4,A4FG3A+FR4
	WL	4,A4FG3A+FR5
	.word	ANI_ATTACK_ON, AMODE_GRAPPLE,24,-100,48,28 ;mode,x,y,w,h
	WL	4,A4FG3A+FR6
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#grapple
	WL	4,A4FG3A+FR5
	WL	4,A4FG3A+FR4
	WL	4,A4FG3A+FR3
	WL	4,A4FG3A+FR2
	WL	4,A4FG3A+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#grapple
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_SLAVE,S2_GRAPPLE,3
	WL	8,A4GR3B+FR7

	.word	ANI_SLAVE,S2_GRAPPLE,2
	WL	8,A4GR3B+FR6

	.word	ANI_SLAVE,S2_GRAPPLE,1
	WL	8,A4GR3B+FR5

	.word	ANI_SLAVE,S2_GRAPPLE,0
	WL	8,A4GR3B+FR4

	.word	ANI_SLAVE,S2_GRAPPLE,1
	WL	8,A4GR3B+FR5

	.word	ANI_SLAVE,S2_GRAPPLE,2
	WL	8,A4GR3B+FR6

	WL	ANI_GOTO,#grapple


 .if 0
#*****************************************************************************

 SUBR	dnk_3_head_hold_anim

	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	1,D3PG3A01
	.word	ANI_ATTACHZ,45-5,0,0
	WL	3,D3PG3A01
	WL	4,D3PG3A02

	WL	4+50,D3PG3A02
	.word	ANI_END


 SUBR	dnk_3_head_held_anim

	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	4,D3BF3Z01
	WL	4,D3BF3Z02
#loop
	WL	4,D3BF3A01
	WL	4,D3BF3A02
	WL	4,D3BF3A03
	WL	4,D3BF3A04
	WL	4,D3BF3A05
	WL	4,D3BF3A06
	WL	4,D3BF3A07
	WL	4,D3BF3A08
	WL	ANI_GOTO,#loop


#*****************************************************************************

 SUBR	dnk_3_pile_driver_anim


	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
#lp
	.word	ANI_ATTACHZ,45-5,0,0
;;;	WL	ANI_CODE,temp_shit0
;;;	.word	ANI_SLAVE,S3_GRAP_TO_HH,0
	WL	63+00,D3PG3A01
	.word	ANI_SLAVE,S3_GRAP_TO_HH,1
	WL	3+60,D3PG3A01
	.word	ANI_SLAVE,S3_GRAP_TO_HH,2
	WL	3+60,D3PG3A02
	.word	ANI_SLAVE,S3_GRAP_TO_HH,3
	WL	10+60,D3PG3A03
	WL	3+60,D3PG3A05



;;;	WL	ANI_CODE,temp_shit

	.word	ANI_ATTACHZ,27-10,61-7,0

	.word	ANI_SLAVE,S3_PILE_DRIVEN,1

	WL	3+60,D3PG3A05

	.word	ANI_SLAVE,S3_PILE_DRIVEN,2
	WL	2+60,D3PG3A06
	.word	ANI_SLAVE,S3_PILE_DRIVEN,3
	WL	2+60,D3PG3A06
	.word	ANI_SLAVE,S3_PILE_DRIVEN,4
	WL	2+60,D3PG3A06A
	.word	ANI_SLAVE,S3_PILE_DRIVEN,5
	WL	2+60,D3PG3A06A
	.word	ANI_SLAVE,S3_PILE_DRIVEN,6
	WL	64+60,D3PG3A07

	WL	ANI_SET_YVEL,90000h
	.word	ANI_OFFSET,0,47,0			;x,y,z

	.word	ANI_ATTACHZ,27-10,0,0

	WL	4+00,D3PG3A08
	WL	4+00,D3PG3A09
	.word	ANI_WAITHITGND


	WL	4+60,D3PG3A10
	WL	ANI_GOTO,#lp


temp_shit0
	move	*a13(ATTACH_PROC),a2,L

	move	*a13(OBJ_XPOSINT),a0
	addi	45,a0
	move	a0,*a2(OBJ_XPOSINT)

	move	*a13(OBJ_YPOS),*a2(OBJ_YPOS),L

	rets



temp_shit
	move	*a13(ATTACH_PROC),a2,L
	move	*a2(OBJ_XPOSINT),a0
	subi	27,a0
	move	a0,*a2(OBJ_XPOSINT)

	move	*a2(OBJ_YPOSINT),a0
	addi	61-7,a0
	move	a0,*a2(OBJ_YPOSINT)

	rets




	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
;#lp
	.word	ANI_ATTACHZ,44,0,-4
	WL	4+60,D3PG3A01

	WL	4+6,D3PG3A01
	.word	ANI_ATTACHZ,18,54,-4
	WL	4+6,D3PG3A02
	WL	4+6,D3PG3A03
	WL	4+6,D3PG3A04
	WL	4+6,D3PG3A05
	WL	4+6,D3PG3A06
	.word	ANI_ATTACHZ,18,54,-4
	WL	4+140,D3PG3A07
;;;	WL	ANI_GOTO,#lp

	WL	ANI_CODE,clear_link

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************

 SUBR	dnk_3_pile_driven

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
#lp
	WL	4+60,D3BF3Z01
	WL	4+6,D3BF3Z02
	WL	4+6,D3BF3A01
	WL	4+6,D3PD3C01
	WL	4+6,D3PD3C02
	WL	4+6,D3PD3C02
	WL	4+6,D3PD3C03
	WL	4+6,D3PD3C04
	WL	4+6,D3PD3C04
	WL	4+140,D3PD3C05
;;;	WL	ANI_GOTO,#lp

	WL	ANI_CODE,clear_link

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


clear_link
	clr	a0
	move	a0,*a13(ATTACH_PROC),L
	rets


 .endif

******************************************************************************

	.end
