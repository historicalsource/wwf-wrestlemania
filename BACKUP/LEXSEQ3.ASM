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
* Initiated:		7/15/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"lexseq3.asm"
	.title	"Lex Luger animation sequences"
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


******************************************************************************
* EXTERNAL REFERENCES

	.ref	tgt_tbukl
	.ref	set_position
	.ref	set_skeleton_pal
	.ref	am_I_dizzy
	.ref	start_smoke
	.ref	ckzpos
	.ref	set_my_pal
	.ref	make_white
	.ref	CALL_SETUP
	.ref	HIT_THE_MAT
	.ref	SMALL_BOUNCE
	.ref	tbukl_flip
	.ref	make_norm
	.ref	CALL_MISSES
	.REF	CALL_SETUP

	.REF	DO_SNAP_MESS
	.REF	CALL_SPECIAL_MOVE
	.ref	slaveanim_tbl

	.ref	lex_stand4_anim
	.ref	lex_dizzy_anim
	.ref	lex_faceup_getup_anim

	.ref	hrt_breakneck2_anim
	.ref	rzr_breakneck2_anim
	.ref	und_breakneck2_anim
	.ref	yok_breakneck2_anim
	.ref	shn_breakneck2_anim
	.ref	bam_breakneck2_anim
	.ref	dnk_breakneck2_anim
	.ref	lex_breakneck2_anim

	.ref	hrt_tossed_anim
	.ref	rzr_tossed_anim
	.ref	und_tossed_anim
	.ref	yok_tossed_anim
	.ref	shn_tossed_anim
	.ref	bam_tossed_anim
	.ref	dnk_tossed_anim
	.ref	lex_tossed_anim

	.ref	hrt_3_head_held_anim
	.ref	rzr_3_head_held_anim
	.ref	und_3_head_held_anim
	.ref	yok_3_head_held_anim
	.ref	shn_3_head_held_anim
	.ref	bam_3_head_held_anim
	.ref	dnk_3_head_held_anim

	.ref	hrt_slambounce_anim
	.ref	rzr_slambounce_anim
	.ref	und_slambounce_anim
	.ref	yok_slambounce_anim
	.ref	shn_slambounce_anim
	.ref	bam_slambounce_anim
	.ref	dnk_slambounce_anim
	.ref	lex_slambounce_anim

;RJR START
	.ref	hrt_break_neck2_anim
	.ref	rzr_break_neck2_anim
	.ref	und_break_neck2_anim
	.ref	yok_break_neck2_anim
	.ref	shn_break_neck2_anim
	.ref	bam_break_neck2_anim
	.ref	dnk_break_neck2_anim
;RJR END


******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* GRAB OPPONENT AND HOLD OVERHEAD


 SUBR	lex_4_graboh_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

;	.word	ANI_STARTATTACK,AT_GRABHOLD,16
	WL	4,U4PO4C+FR1
	WL	4,U4PO4C+FR2
	WL	4,U4PO4C+FR3
	WL	4,U4PO4C+FR4

	.word	ANI_ATTACK_ON, AMODE_GRABHOLD,43,27,32,64 ;mode,x,y,w,h
	.word	ANI_ATTACHZ,73,60,4
	WL	4,U4PO4C+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#gothim
;missed
	WL	ANI_CODE,CALL_MISSES
	WL	6,U4PO4C+FR5
	WL	4,U4PO4C+FR4
	WL	4,U4PO4C+FR3
	WL	4,U4PO4C+FR2
	WL	4,U4PO4C+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#gothim

	WL	ANI_CODE,CALL_SETUP
	.word	ANI_ATTACH,71,73
	WL	4,U4PO4C+FR6
	.word	ANI_ATTACH,62,101
	WL	4,U4PO4C+FR7
	.word	ANI_ATTACH,39,121
	WL	4,U4PO4C+FR8
	.word	ANI_ATTACH,12,131
	WL	4,U4PO4C+FR9
	.word	ANI_ATTACH,-2,133
	WL	4,U4PO4C+FR10

; .if 0
;
;	.word	ANI_ATTACH,59,64
;	WL	3,D3PO4B+FR7
;	.word	ANI_ATTACH,35,96
;	WL	3,D3PO4B+FR8
;	.word	ANI_ATTACH,15,116
;	WL	3,D3PO4B+FR9
;	.word	ANI_ATTACH,9,124
;	WL	3,D3PO4B+FR10
; .endif

	.word	ANI_SETPLYRMODE,MODE_OPPOVERHEAD
	.word	ANI_SETMODE,+MODE_NOAUTOFLIP
	.word	ANI_END

 SUBR	lex_stndholdoh_anim

	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	999,U4PO4C+FR10
	.word	ANI_REPEAT

#*****************************************************************************
*
* HELD OVERHEAD ANIMATION

 SUBR	lex_heldoh_anim

	.word	ANI_SETPLYRMODE,MODE_ATTACHED
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_SETSPEED,100h

	.word	ANI_SETWORD,USR_VAR1,0		;loop count
#loop
	WL	4,L3MF3B+FR1
	WL	4,L3MF3B+FR2
	WL	4,L3MF3B+FR3
	WL	4,L3MF3B+FR4
	WL	4,L3MF3B+FR5
	WL	4,L3MF3B+FR6
	WL	4,L3MF3B+FR7

	WL	ANI_CODE,#inc_loop
	WL	ANI_IFNOTSTATUS,#loop

;Fall out of overhead hold by reversing thru pickup frames
	.word	ANI_DETACH

 
	.word	ANI_SETMODE,MODE_NORMAL|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_INAIR

	WL	ANI_SET_YVEL,10000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,10000h,AM_ABS

	WL	5,L3MF3B+FR6
	.word	ANI_OFFSET,-20,-50,0			;x,y,z
	WL	4,L3MS3Z+FR5
	WL	4,L3MS3Z+FR3
	WL	4,L3MS3Z+FR2
	WL	4,L3MS3Z+FR1
	.word	ANI_WAITHITGND
	WL	2,L2ST2C+FR7

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

 SUBR	lex_summon_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	4,U4SW4A+FR1
	WL	4,U4SW4A+FR2
	WL	4,U4SW4A+FR3
	WL	4,U4SW4A+FR4
	WL	4,U4SW4A+FR5
	WL	20,U4SW4A+FR6
	WL	4,U4SW4A+FR5
	WL	4,U4SW4A+FR4
	WL	4,U4SW4A+FR3
	WL	4,U4SW4A+FR2
	WL	4,U4SW4A+FR1
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************

 SUBR	lex_summon2_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* FLIP

 SUBR	lex_flip_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	.word	ANI_STARTATTACK,AT_PUPPET,12
	WL	6,L4SH3A+FR1
	WL	6,L4SH3A+FR2
	.word	ANI_ATTACK_ON, AMODE_PUPPET,33,96,43,18 ;mode,x,y,w,h
	WL	6,L4SH3A+FR3
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#gotim

;missed
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	WL	6,L4SH3A+FR3
	WL	6,L4SH3A+FR2
	WL	6,L4SH3A+FR1

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#gotim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_KEEPATTACHED
	.word	ANI_ATTACHZ,0,0,-4

	WLW	ANI_SUPERSLAVE,#puppet_tbl,0
	WL	6,L4SH3A+FR3
	WLW	ANI_SUPERSLAVE,#puppet_tbl,1
	WL	6,L4SH3A+FR4
	WLW	ANI_SUPERSLAVE,#puppet_tbl,2
	WL	6,L3FL3A+FR1
	WLW	ANI_SUPERSLAVE,#puppet_tbl,3
	WL	6,L3FL3A+FR2
	WLW	ANI_SUPERSLAVE,#puppet_tbl,4
	WL	6,L3FL3A+FR3
	WLW	ANI_SUPERSLAVE,#puppet_tbl,5
	WL	6,L3FL3A+FR4
	WLW	ANI_SUPERSLAVE,#puppet_tbl,6

	WL	1,L3FL3A+FR6

	WL	ANI_SLAVEANIM,#slaveanim_tbl
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	WL	5,L3FL3A+FR6

	WL	6,L3FL3A+FR7
	WL	6,L3FL3A+FR8
	WL	6,L3FL3A+FR9

	.word	ANI_DETACH

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#slaveanim_tbl
 .long 0			;Bret
 .long 0			;Razor
 .long 0			;Taker
 .long 0			;Yokozuna
 .long 0			;Shawn
 .long 0			;BamBam
 .long 0			;Doink
 .long 0			;Adam
 .long lex_flipped_anim		;Lex


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
 .long 0
#Razor



 LWWW R3BF3A+FR5,69,3,1
 LWWW R3BF3A+FR5,69,3,1



 LWWW R3BF3A+FR5,69,3,1
 LWWW R3BF3A+FR5,69,3,1

 LWWW R3TD3A+FR4,88,5,1
 LWWW R3TD3A+FR6,47,32,1
 LWWW R3TD3A+FR8,-35,44,1
#Taker
 LWWW U4BF3A+FR2,96,-7,1
 LWWW U4BF3A+FR3,96,1,1
 LWWW U4BF3A+FR4,73,5,1
 LWWW U4BF3A+FR4,73,5,1
 LWWW U3FH3A+FR1,71,14,1
 LWWW U3FH3A+FR2,61,26,1
 LWWW U3FH3A+FR4,-15,52,1
#Yokozuna
 .long 0
#Shawn
 .long 0
#BamBam
 LWWW B4BF3A+FR1,96,-1,1
 LWWW B4BF3A+FR3,96,-1,1
 LWWW B3BF3C+FR5,76,-8,1
 LWWW B3SV3B+FR5,76,-24,1
 LWWW B3SV3B+FR6,35,17,1
 LWWW B3SV3B+FR7,10,29,1
 LWWW B3SV3B+FR8,-70,12,1
#Doink
; LWWW D3BF3Z+FR1,78,6,1
; LWWW D3BF3Z+FR2,76,6,1
; LWWW D3BF3Z+FR3,57,7,1
; LWWW D3BF3Z+FR3,57,7,1
 LWWW D3FH3A+FR2,71,14,1
 LWWW D3FH3A+FR3,50,40,1
 LWWW D3FH3A+FR6,-19,51,1
#Adam
 .long 0
#Lex
 LWWW L3BF3A+FR1,87,0,1
 LWWW L3BF3A+FR2,80,0,1
 LWWW L3BF3A+FR3,73,0,1
 LWWW L3FH3A+FR3,91,5,1
 LWWW L3FH3A+FR4,63,35,1
 LWWW L3FH3A+FR5,51,52,1
 LWWW L3FH3A+FR6,-36,57,1

#*****************************************************************************
*
* END OF FLIPPED SEQ.

 SUBR	lex_flipped_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,060000h,AM_FACE_REL
	WL	ANI_SET_YVEL,060000h
	WL	1,L3FH3A+FR6

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_DETACH
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim


#*****************************************************************************
*
* CLIMB UP TURNBUCKLES

 SUBR	lex_climb_up_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	4,L4HU4A+FR5
	WL	4,L4HU4A+FR6
	WL	4,L4HU4A+FR7
	WL	ANI_CODE,tgt_tbukl
	.word	ANI_LEAPATPOS,24,200,8,8,0	;#ticks,dist,xoff,yoff,zoff
	WL	15,L4HU4A+FR8
	WL	9,L4HU4A+FR9

	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONTURNBKL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOGRAVITY
	.word	ANI_SHAKECORNER

	WL	4,L4HU4A+FR7

#repeat
	WL	6,L4SB4A+FR1
	WL	ANI_CODE,tbukl_flip
	WL	6,L4SB4A+FR2
	WL	ANI_CODE,tbukl_flip
	WL	6,L4SB4A+FR3
	WL	ANI_CODE,tbukl_flip
	WL	6,L4SB4A+FR4
	WL	ANI_CODE,tbukl_flip
	WL	6,L4SB4A+FR5
	WL	ANI_CODE,tbukl_flip
	WL	6,L4SB4A+FR6
	WL	ANI_CODE,tbukl_flip
	WL	6,L4SB4A+FR7
	WL	ANI_CODE,tbukl_flip
	WL	ANI_GOTO,#repeat

#*****************************************************************************
*
* CLIMB DOWN TURNBUCKLES

 SUBR	lex_climb_down_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SHAKECORNER

	WLW	ANI_SET_XVEL,10000h,AM_FACE_REL
	WLW	ANI_SET_ZVEL,10000h,AM_ABS
	WL	ANI_SET_YVEL,20000h

	WL	1,L4HU4A+FR8

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	4,L4HU4A+FR7
	WL	4,L4HU4A+FR6
	WL	4,L4HU4A+FR5

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* GET BUZZED FROM DOINK

 SUBR	lex_get_buzz_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable

;	.word	ANI_ZEROVELS

	.word	ANI_SETSPEED,100h


;	.word	ANI_XFLIP

	.word	ANI_GRAVITY_OFF

	WL	ANI_CODE,set_position

	WL	ANI_CODE,set_skeleton_pal
	WL	2,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,L4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	ANI_CODE,make_white
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_norm
	WL	ANI_CODE,set_my_pal
	WL	3,L4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,L4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_white
	WL	3,L4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,L4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,L4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	ANI_CODE,make_white
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_norm
	WL	ANI_CODE,set_my_pal
	WL	3,L4BZ4A+FR1

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
	WL	3,L4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,L4BZ4A+FR1
	WL	ANI_CODE,#make_black
	WL	3,L4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,L4BZ4A+FR1
	WL	ANI_CODE,#make_black
	WL	3,L4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,L4BZ4A+FR1

	.word	ANI_WAITHITGND
	.word	ANI_XFLIP
	.word	ANI_FACEDOWN
	.word	ANI_OFFSET,-20,0,0			;x,y,z

;MJT Start
	WL	1,L4ST4A+FR5
	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	.ref	lex_fall_back_anim
	WL	ANI_CHANGEANIM,lex_fall_back_anim
	.word	ANI_END

#nodead

;MJT End

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#make_black

;This is a black color within the wrestler's pal.  It is different for each
;wrestler.
	movi	3e3eh,a14

	move	a14,*a13(OBJ_CONST)
	move	*a13(OBJ_CONTROL),a14
	andni	01111b,a14
	ori	M_CONNON,a14
	move	a14,*a13(OBJ_CONTROL)
	rets

#*****************************************************************************

 SUBR	lex_3_head_held_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_HEADHELD
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim

	.word	ANI_SETWORD,USR_VAR1,0		;loop count

#loop
	WL	4,L3BF3B+FR5
	WL	4,L3BF3B+FR6
	WL	4,L3BF3B+FR1
	WL	4,L3BF3B+FR2
	WL	4,L3BF3B+FR3
	WL	4,L3BF3B+FR4
	WL	ANI_CODE,#inc_loop
	WL	ANI_IFNOTSTATUS,#loop

;Continue into break...

 SUBR	lex_3_head_held_brk_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WLW	ANI_SET_XVEL,-38000h,AM_NEWFACE_REL
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	.word	ANI_XFLIP
	WL	4,L3BF3A+FR2
	.word	ANI_XFLIP
	.word	ANI_DETACH

;Standard #2 head hit from spin kick
	WL	4,L2AH2A+FR3
	WL	4,L2AH2A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	4,L2AH2A+FR5
	WL	4,L2AH2A+FR6
	WL	4,L2AH2A+FR7
;	WL	4,L2AH2A+FR8

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

 SUBR	lex_3_head_held_stand_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_XFLIP
	WL	4,L3BF3A+FR2
	.word	ANI_XFLIP
	WL	3,L1TT5A+FR5	;2.5
	.word	ANI_DETACH

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* ROLL OVER AND BREAK YER STINKIN' NECK
*

 SUBR	lex_break_neck_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h

	WWWL	ANI_IFROPE,RC_EITHER,100,#fall_back

	;plenty of room.  break yer neck.
	.word	ANI_OFFSET,9,0,0
	WL	4,L3FD3B+FR3
	.word	ANI_OFFSET,8,0,0
	WL	4,L3FD3B+FR4
	.word	ANI_OFFSET,8,0,0
	WL	4,L3FD3B+FR5
	.word	ANI_OFFSET,-1,0,0
	WL	4,L3FD3B+FR6
	.word	ANI_OFFSET,32,0,0
	WL	1,L3RL1A+FR5
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim

#fall_back
	;sans.  too close to the rope.
	WL	4,L3FD3B+FR2
	.word	ANI_OFFSET,-15,0,0
	WL	4,L3UC3X+FR7
	WL	4,L3UC3X+FR8
	WL	4,L3UC3X+FR9
	.word	ANI_OFFSET,-17,0,0
	.word	ANI_XFLIP
	WL	1,L3RL1A+FR11
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim

 SUBR	lex_break_neck2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	;break the neck
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WL	ANI_SET_YVEL,60000h
	WLW	ANI_SET_ZVEL,8000h,AM_ABS
	.word	ANI_XFLIP

	.word	ANI_OFFSET,-5,0,0

	WL	4,L3FD3B+FR2
	WL	4,L3FD3B+FR3
	WL	4,L3FD3B+FR4
	WL	4,L3FD3B+FR5
	WL	4,L3FD3B+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_OFFSET,-25,0,0

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	10,L3RL1A+FR5
	.word	ANI_WAITROLL

	WL	ANI_CHANGEANIM,lex_faceup_getup_anim
	.word	ANI_END

 SUBR	lex_break_neck3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,58000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	WL	ANI_CODE,ckzpos

	.word	ANI_DEBRIS,300,5,0,-5,0	;%chance, tbl index, x,y,z off

	WL 	15,L4POGO+FR4
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_XFLIP

	.word	ANI_OFFSET,-5,0,0

	WL	3,L3FH3A+FR6
	WL	3,L3FD3B+FR1
	WL	3,L3FD3B+FR2
	WL	3,L3FD3B+FR3
	WL	3,L3FD3B+FR4
	WL	3,L3FD3B+FR5
	WL	3,L3FD3B+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_OFFSET,-25,0,0

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	10,L3RL1A+FR5
	.word	ANI_WAITROLL

	WL	ANI_CHANGEANIM,lex_faceup_getup_anim
	.word	ANI_END

 SUBR	lex_break_neck4_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h

	WL	4,L3UC3X+FR6
	WL	4,L3FD3B+FR1
	WL	4,L3FD3B+FR2

	WL	ANI_CHANGEANIM,lex_break_neck_anim

#******************************************************************************

 SUBR	lex_2_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

;There are too many rotate frames listed here...
	WL	2,L1TT5A+FR4
	WL	2,L1TT5A+FR5
	WL	2,L1TT5A+FR6

 SUBR	lex_4_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

;Put cool cheers here
;	.word	ANI_RAWSOUND,2055		;big cheer #1
;	.word	ANI_CHEER,3

	.word	ANI_STARTATTACK,AT_PUPPET,12
	WL	4,L4WS4B+FR1

	LEAPATOPP 8,999,80,80,30000h,TGT_HEAD,26,6,-2
	WL	4,L4WS4B+FR2
	WL	4,L4WS4B+FR3
	.word	ANI_ZERO_XZVELS

	.word	ANI_ATTACK_ON, AMODE_PUPPET,24,0,32,20 ;mode,x,y,w,h
	WL	4,L4WS4B+FR4
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;got him
	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	WL	ANI_CODE,CALL_SETUP

	.word	ANI_SOUND,33h			;neck break (5-7 ticks late)
	.word	ANI_DAMAGEOPP,10

	WWLLW	ANI_SUPERSLAVE2,4,L4GH3B+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,L4GH3B+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,L4GH3B+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,L4GH3B+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,L4GH3B+FR5,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,L4GH3B+FR6,#puppet_tbl,5

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	3,L4GH3B+FR6
	.word	ANI_CLROPPMODE,MODE_GHOST

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	20,L4WS4B+FR4
	WL	4,L4WS4B+FR3
	WL	4,L4WS4B+FR2
	WL	4,L4WS4B+FR1

	WL	ANI_CODE,CALL_MISSES
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#headheld_tbl
	.long	hrt_3_head_held_anim
	.long	rzr_3_head_held_anim
	.long	und_3_head_held_anim
	.long	yok_3_head_held_anim
	.long	shn_3_head_held_anim
	.long	bam_3_head_held_anim
	.long	dnk_3_head_held_anim
	.long	0
	.long	lex_3_head_held_anim

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
 LWWW H3GU4A+FR1,43,-35,0
 LWWW H3GU4A+FR3,57,-41,0
 LWWW H3DU3A+FR3,59,-42,1
 LWWW H3DU3A+FR4,67,-31,1
 LWWW H3DU3A+FR5,65,-28,1
 LWWW H3BF3A+FR1,43,-36,0
 .long 0
#Razor
 LWWW R3GU4A+FR2,43,-35,1
 LWWW R3GU4A+FR3,49,-38,0
 LWWW R3GU4A+FR5,58,-42,0
 LWWW R3DU3B+FR2,60,-38,1
 LWWW R3DU3B+FR4,58,-26,1
 LWWW R3BF3A+FR4,47,-35,0
 .long 0
#Taker
 LWWW U3DU3B+FR2,45,-27,1
 LWWW U3DU3B+FR5,49,-33,1
 LWWW U3DU3B+FR6,55,-40,1
 LWWW U3DU3B+FR8,53,-31,1
 LWWW U3DU3B+FR10,56,-16,1
 LWWW U4BF3Z+FR5,42,-14,0
 .long 0
#Yokozuna
 LWWW Y3GU2A+FR1,45,-23,0
 LWWW Y3GU2A+FR3,55,-23,0
 LWWW Y3GU2A+FR6,39,-42,0
 LWWW Y3GU2A+FR9,66,-36,0
 LWWW Y3GU2A+FR12,57,-23,0
 LWWW Y3BF3A+FR1,40,-24,0
 .long 0
#Shawn
 LWWW S3GU4A+FR1,43,-35,1
 LWWW S3GU4A+FR2,48,-37,0
 LWWW S3GU4A+FR4,60,-40,0
 LWWW S3GU4A+FR5,64,-36,0
 LWWW S3DU3A+FR2,58,-36,1
 LWWW S3BF3A+FR1,32,-34,0
 .long 0
#BamBam
 LWWW B3GU4A+FR3,45,-24,0
 LWWW B3GU4A+FR4,51,-34,0
 LWWW B3GU4A+FR6,62,-32,0
 LWWW B3GU4A+FR7,65,-38,0
 LWWW B3DU3A+FR2,62,-26,1
 LWWW B3BF3C+FR5,43,-27,0
 .long 0
#Doink
 LWWW D3DU3A+FR2,39,-29,1
 LWWW D3DU3A+FR3,47,-36,1
 LWWW D3DU3A+FR5,52,-36,1
 LWWW D3DU3A+FR8,59,-38,1
 LWWW D3HT3Z+FR1,60,-24,1
 LWWW D3BF3A+FR2,42,-33,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3DU3A+FR2,49,-34,1
 LWWW L3DU3A+FR4,41,-28,1
 LWWW L3DU3A+FR6,50,-37,1
 LWWW L3DU3A+FR7,57,-29,1
 LWWW L3DU3A+FR9,65,-27,1
 LWWW L3BF3B+FR2,43,-37,0
 .long 0

#******************************************************************************

 SUBR	lex_4_taunt_anim

	.word	ANI_SETMODE,MODE_UNINT
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	4,L4CO4Z+FR1
	WL	4,L4CO4Z+FR2
	WL	4,L4CO4Z+FR3
	WL	4,L4CO4Z+FR4
	WL	4,L4CO4Z+FR5
	WL	4,L4CO4Z+FR6
	WL	4,L4CO4Z+FR7
	WL	4,L4CO4Z+FR8
	WL	4,L4CO4Z+FR9

	WL	4,L4CO4Z+FR8
	WL	4,L4CO4Z+FR7
	WL	4,L4CO4Z+FR6
	WL	4,L4CO4Z+FR5
	WL	4,L4CO4Z+FR4
	WL	4,L4CO4Z+FR3
	WL	4,L4CO4Z+FR2
	WL	4,L4CO4Z+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,lex_stand4_anim
	.word	ANI_END

#*****************************************************************************
*
* Head slams into mat
;From head slam - repeated head slam

 SUBR	lex_break_face2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	.word	ANI_ZEROVELS


	WL	3,L3TF3X+FR1		;Face down
	WL	ANI_SET_YVEL,80000h
	WL	3,L3TF3X+FR2		;Face down
	WL	3,L3TF3X+FR3		;Face down
	WL	3,L3TF3X+FR4		;Face down
	WL	3,L3TF3X+FR5		;Face down
	.word	ANI_WAITHITGND
	.word	ANI_END
	

* Head slams into mat
;From head slam

 SUBR	lex_break_face_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	.word	ANI_ZEROVELS


	WL	3,L3TF3X+FR1		;Face down
	WL	ANI_SET_YVEL,40000h
	WL	3,L3TF3X+FR2		;Face down
	WL	3,L3TF3X+FR3		;Face down
	WL	3,L3TF3X+FR4		;Face down
	WL	3,L3TF3X+FR5		;Face down
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,L3TF3X+FR2		;Face down
	WL	3,L3TF3X+FR3		;Face down
	WL	3,L3TF3X+FR4		;Face down
	WL	3,L3TF3X+FR5		;Face down

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	3,L3TF3X+FR5		;Face down
	.word	ANI_WAITROLL

	WL	ANI_CHANGEANIM,lex_faceup_getup_anim
	.word	ANI_END

;MJT Start
#*****************************************************************************
*
* END OF BACK BROKEN SEQ.

 SUBR	lex_backbroken_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_DETACH

	.word	ANI_GRAVITY_OFF
	WL	5,L3BR3Z+FR1
	.word	ANI_GRAVITY_ON

	WL	ANI_SET_YVEL,070000h
	WLW	ANI_SET_ZVEL,20000h,AM_ABS

	WL	25,L3BR3Z+FR1

;	WL	4,L3BR3Z+FR2
	WL	4,L3UC3A+FR6

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_BOUNCE,2
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_DEBRIS,200,1,0,8,0		;%chance, tbl index, x,y,z off
	.word	ANI_XFLIP

	WL	3,L3CP3X+FR2
	WL	3,L3CP3X+FR3
	WL	3,L3CP3X+FR4
	WL	3,L3CP3X+FR5
	WL	3,L3CP3X+FR6
	WL	3,L3CP3X+FR7
	WL	3,L3CP3X+FR1

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

;No stars around head here...

	.word	ANI_DETACH

	WL	1,L3CP3X+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim
	.word	ANI_END

#*****************************************************************************

	.bss	#opp_xvel,32

 SUBR	lex_3_head_hold_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold

	.word	ANI_STARTATTACK,AT_PUPPET,12
	WL	3,L4GH3Z+FR1
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 9,999,60,40,90000h,TGT_HEAD,60,96,8

	.word	ANI_ATTACK_ON, AMODE_PUPPET,44,96,34,21 ;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,9,L4GH3Z+FR2

	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	WL	ANI_IFBLOCKED,#missed

;got him

	WL	ANI_CODE,CALL_SETUP

	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,4,L4GH3Z+FR3,#puppet_tbl,0

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WWLLW	ANI_SUPERSLAVE2,4,L4GH3Z+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,L4GH3Z+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,L4GH3B+FR6,#puppet_tbl,3

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	4,L4GH3B+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
;RJR START
	WL	ANI_CODE,CALL_MISSES
;RJR END

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	25,L4GH3Z+FR3
	WL	3,L4GH3Z+FR2
	WL	3,L4GH3Z+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

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
 LWWW H2AH3A+FR1,44,8,0
 LWWW H3HB3A+FR3,47,-6,0
 LWWW H3HB3A+FR2,39,-13,0
 LWWW H3HB3A+FR1,37,-35,0
 .long 0
#Razor
 LWWW R3HB3A+FR3,54,-8,0
 LWWW R3HB3A+FR3,49,-6,0
 LWWW R3HB3A+FR2,46,-22,0
 LWWW R3BF3A+FR1,39,-36,0
 .long 0
#Taker
 LWWW U4AM4C+FR2,41,-2,0
 LWWW U4BF3A+FR2,39,4,0
 LWWW U4BF3A+FR3,15,-9,0
 LWWW U4BF3Z+FR3,43,-22,0
 .long 0
#Yokozuna
 LWWW Y3LB3A+FR2,56,1,0
 LWWW Y3LB3A+FR2,56,6,0
 LWWW Y3LB3A+FR9,39,-20,0
 LWWW Y3BF3A+FR1,39,-24,0
 .long 0
#Shawn
 LWWW S4AH3D+FR5,37,-6,0
 LWWW S4AH3D+FR5,37,-1,0
 LWWW S4BF3A+FR2,42,-15,0
 LWWW S4BF3A+FR3,24,-23,0
 .long 0
#BamBam
 LWWW B4BF3A+FR1,55,-2,0
 LWWW B4BF3A+FR1,55,3,0
 LWWW B3HB3A+FR2,44,-29,0
 LWWW B3BF3C+FR5,40,-28,0
 .long 0
#Doink
 LWWW D3AK3A+FR3,34,1,0
 LWWW D3AK3A+FR3,33,6,0
 LWWW D3AK3A+FR2,40,-12,0
 LWWW D3BF3A+FR1,40,-34,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L4AH4B+FR3,38,-5,0
 LWWW L3BF3A+FR1,47,-1,1
 LWWW L3BF3A+FR2,44,-17,1
 LWWW L3BF3B+FR5,41,-32,0
 .long 0

#headheld_tbl
	.long	hrt_3_head_held_anim
	.long	rzr_3_head_held_anim
	.long	und_3_head_held_anim
	.long	yok_3_head_held_anim
	.long	shn_3_head_held_anim
	.long	bam_3_head_held_anim
	.long	dnk_3_head_held_anim
	.long	0
	.long	lex_3_head_held_anim

#*****************************************************************************
*
* VERTICAL SUPLEX (FROM HEAD HOLD)

 SUBR	lex_vsuplex_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WWL	ANI_SETLONG,OBJ_GRAVITY,0f000h

	WL	ANI_SLAVEANIM,slaveanim_tbl

	WWLLW	ANI_SUPERSLAVE2,3,L3VS3A+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,L3VS3A+FR3,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,L3VS3A+FR4,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,L3VS3A+FR5,#puppet_tbl,3

	WL	ANI_SET_YVEL,060000h

	WLW	ANI_SET_XVEL,-10000h,AM_FACE_REL
	WWLLW	ANI_SUPERSLAVE2,3,L3VS3A+FR6,#puppet_tbl,4
	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL
	WWLLW	ANI_SUPERSLAVE2,3,L3VS3A+FR7,#puppet_tbl,5
	.word	ANI_OFFSET,0,54,0			;x,y,z
	WLW	ANI_SET_XVEL,-30000h,AM_FACE_REL
	WWLLW	ANI_SUPERSLAVE2,5,L3VS3A+FR8,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,7,L3VS3A+FR9,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,5,L3VS3A+FR10,#puppet_tbl,8

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40

	WWLLW	ANI_SUPERSLAVE2,3,L3UC3A+FR6,#puppet_tbl,9

	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#slambounce_tbl
	WLLL	ANI_SETOPPVELS,-30000h,40000h,0		;x,y,z vels

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_DETACH
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

	.word	ANI_XFLIP
	WL	1,L3GU4A+FR1
	WL	ANI_SET_YVEL,040000h
	.word	ANI_WAITHITGND

;;;	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETMODE,MODE_NORMAL


	WL	ANI_CHANGEANIM,lex_faceup_getup_anim


#xflip_tbl
	.word	1 ;bret
	.word	0 ;razor
	.word	0 ;taker
	.word	0 ;yoko
	.word	0 ;shawn
	.word	1 ;bam
	.word	0 ;doink
	.word	0 ;spare
	.word	0 ;lex

#slambounce_tbl
	.long	hrt_slambounce_anim	;bret
	.long	rzr_slambounce_anim	;razor
	.long	und_slambounce_anim	;taker
	.long	yok_slambounce_anim	;yoko
	.long	shn_slambounce_anim	;shawn
	.long	bam_slambounce_anim	;bam
	.long	dnk_slambounce_anim	;doink
	.long	und_slambounce_anim	;spare
	.long	lex_slambounce_anim	;lex

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
 LWWW H3BF3A+FR3,24,-36,0
 LWWW H3PP3X+FR1,19,-39,0
 LWWW H3PP3X+FR2,15,11,0
 LWWW H3PP3X+FR3,8,42,0
 LWWW H3PP3X+FR4,2,59,0
 LWWW H3PP3X+FR5,13,76,0
 LWWW H3PP3X+FR6,-1,82,0
 LWWW H3UC3X+FR8,-27,44,0
 LWWW H3UC3X+FR9,-72,10,0
 LWWW H3UC3X+FR10,-91,8,0
 .long 0
#Razor
 LWWW R3GP3Z+FR1,17,-43,0
 LWWW R3GP3Z+FR2,14,-27,0
 LWWW R3GP3Z+FR3,12,17,0
 LWWW R3GP3Z+FR4,22,52,0
 LWWW R3GP3Z+FR5,19,70,0
 LWWW R3GP3Z+FR6,22,73,0
 LWWW R3GP3Z+FR7,-5,61,0
 LWWW R3TD3A+FR7,-12,59,0
 LWWW R3TD3A+FR8,-37,35,0
 LWWW R3GU2A+FR1,-112,-10,1
 .long 0
#Taker
 LWWW U3PP3X+FR1,19,-39,1
 LWWW U3PP3X+FR2,18,-22,1
 LWWW U3PP3X+FR3,14,-6,1
 LWWW U3PP3X+FR4,7,26,1
 LWWW U3PP3X+FR5,11,74,1
 LWWW U3PP3X+FR6,14,96,1
 LWWW U3FH3A+FR5,-33,64,1
 LWWW U3FH3A+FR5,-38,67,1
 LWWW U3FD3B+FR7,-114,-15,0
 LWWW U3CP3B+FR1,-128,-6,1
 .long 0
#Yokozuna
 LWWW Y3BF3A+FR11,23,-28,0
 LWWW Y3PP3Q+FR1,17,-20,0
 LWWW Y3PP3Q+FR3,23,-2,0
 LWWW Y3PP3Q+FR4,21,21,0
 LWWW Y3PP3Q+FR6,0,48,0
 LWWW Y3PP3Q+FR7,0,53,0
 LWWW Y3PP3Q+FR7,-8,58,0
 LWWW Y3FD3A+FR5,-70,45,0
 LWWW Y3FD3A+FR6,-78,13,0
 LWWW Y3FD3A+FR7,-97,14,0
 .long 0
#Shawn
 LWWW S3BF3A+FR5,19,-40,0
 LWWW S3GP3X+FR1,20,-34,0
 LWWW S3GP3X+FR2,17,-21,0
 LWWW S3GP3X+FR3,20,9,0
 LWWW S3GP3X+FR4,16,62,0
 LWWW S3GP3X+FR5,15,65,0
 LWWW S3OS3X+FR9,-26,65,1
 LWWW S3UC3X+FR6,-31,53,0
 LWWW S3UC3X+FR8,-96,-13,0
 LWWW S3OS3X+FR10,-104,-5,1
 .long 0
#BamBam
 LWWW B3PP3Q+FR1,14,-40,0
 LWWW B3PP3Q+FR2,16,-12,0
 LWWW B3PP3Q+FR3,20,15,0
 LWWW B3PP3Q+FR4,18,42,0
 LWWW B3PP3Q+FR5,16,60,0
 LWWW B3PP3Q+FR6,9,70,0
 LWWW B4TD3B+FR8,-12,61,0
 LWWW B4TD3B+FR8,-19,64,0
 LWWW B4TD3A+FR1,-68,12,0
 LWWW B4TD3B+FR9,-90,3,0
 .long 0
#Doink
 LWWW D3PD3Z+FR1,25,-47,1
 LWWW D3PD3Z+FR2,19,-23,1
 LWWW D3PD3Z+FR3,18,4,1
 LWWW D3PD3Z+FR4,15,49,1
 LWWW D3PD3Z+FR5,8,73,1
 LWWW D3PD3Z+FR6,18,66,1
 LWWW D3PD3Z+FR6,12,65,1
 LWWW D3UC3A+FR8,-17,61,0
 LWWW D3UC3A+FR11,-90,6,0
 LWWW D3SA3A+FR2,-111,-8,1
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3BF3B+FR1,23,-40,0
 LWWW L3GP3Z+FR1,13,-31,0
 LWWW L3GP3Z+FR2,16,-13,0
 LWWW L3GP3Z+FR3,20,11,0
 LWWW L3GP3Z+FR5,21,39,0
 LWWW L3GP3Z+FR6,20,57,0
 LWWW L3GP3Z+FR6,9,66,0
 LWWW L3FH3A+FR6,-11,52,0
 LWWW L3UC3X+FR4,-94,3,0
 LWWW L3CP3X+FR1,-117,-7,1
 .long 0

#*****************************************************************************
*lift
; attacker sequence

 SUBR	lex_grab2overhead_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,10
;RJR START
	LEAPATOPP 12,40,40,40,90000h,TGT_HEAD,70,78,0
	WL	ANI_SET_YVEL,0
;RJR END
	WL	5,L4PO4A+FR1
	WL	5,L4PO4A+FR2

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	.word	ANI_ATTACK_ON, AMODE_PUPPET,31,51,56,53 ;mode,x,y,w,h
	WL	3,L4PO4A+FR3
	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

	WL	ANI_IFBLOCKED,#missedb
	WL	ANI_IFSTATUS,#gotim


;	WL	2,L4PO4A+FR3
#missedb
	WL	10,L4PO4A+FR4

;missed
	WL	14,L4PO4A+FR4
	WL	6,L4PO4A+FR3
	WL	6,L4PO4A+FR2
	WL	6,L4PO4A+FR1

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#gotim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker
	WWLLW	ANI_SUPERSLAVE2,8,L4PO4A+FR5,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,5,L4PO4A+FR6,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,5,L4PO4A+FR7,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,5,L4PO4A+FR8,#puppet_tbl,3

	WL	ANI_SLAVEANIM,#heldoh_tbl

	WL	4,L4PO4A+FR8

	.word	ANI_SETPLYRMODE,MODE_OPPOVERHEAD
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_END


	.ref	hrt_heldoh_anim
	.ref	rzr_heldoh_anim
	.ref	und_heldoh_anim
	.ref	yok_heldoh_anim
	.ref	shn_heldoh_anim
	.ref	bam_heldoh_anim
	.ref	dnk_heldoh_anim
;	.ref	lex_heldoh_anim

#heldoh_tbl
	.long	hrt_heldoh_anim
	.long	rzr_heldoh_anim
	.long	und_heldoh_anim
	.long	yok_heldoh_anim
	.long	shn_heldoh_anim
	.long	bam_heldoh_anim
	.long	dnk_heldoh_anim
	.long	0
	.long	lex_heldoh_anim

lex_grab_tbl
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
 LWWW H4AM3A+FR1,81,7,0
 LWWW H3MS3Z+FR1,35,24,0
 LWWW H3MS3Z+FR4,-1,17,0
 LWWW H4MF4B+FR9,-19,18,0
 .long 0
#Razor
 LWWW R3MS3Z+FR1,66,10,0
 LWWW R3MS3Z+FR2,39,16,0
 LWWW R3MS3Z+FR3,5,14,0
 LWWW R4MF4B+FR9,-57,28,0
 .long 0
#Taker
 LWWW U4AM4C+FR1,63,19,0
 LWWW U3MS3Z+FR1,31,35,0
 LWWW U3MS3Z+FR3,-16,13,0
 LWWW U4PM3C+FR7,-29,27,0
 .long 0
#Yokozuna
 LWWW Y4AE4A+FR1,90,14,0
 LWWW Y3MS3Z+FR2,45,25,0
 LWWW Y3MS3Z+FR4,-3,24,0
 LWWW Y3MF3B+FR7,-30,20,0
 .long 0
#Shawn
 LWWW S3OS3X+FR3,56,22,1
 LWWW S3MS3Z+FR1,29,13,0
 LWWW S3MS3Z+FR3,-16,22,0
 LWWW S3MF3B+FR7,-41,23,0
 .long 0
#BamBam
 LWWW B4AH4A+FR1,75,18,0
 LWWW B3MS3Z+FR2,42,14,0
 LWWW B3MS3Z+FR3,8,15,0
 LWWW B4MF4A+FR7,-51,35,0
 .long 0
#Doink
 LWWW D3AH3B+FR5,67,16,0
 LWWW D3GS3X+FR3,37,20,0
 LWWW D3GS3X+FR4,7,22,0
 LWWW D4MF4A+FR9,-32,37,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3MS3Z+FR1,72,4,0
 LWWW L3MS3Z+FR2,37,10,0
 LWWW L3MS3Z+FR3,-2,14,0
 LWWW L3MF3B+FR6,-34,13,0
 .long 0

;RJR START
#*****************************************************************************

 SUBR	lex_slamdown_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	ANI_SLAVEANIM,slaveanim_tbl

	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker

	WL	ANI_SET_YVEL,028000h

	WWLLW	ANI_SUPERSLAVE2,4,L3FO3A+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,L3FO3A+FR2,#puppet_tbl,1

	.word	ANI_FACE,MOVE_LEFT|MOVE_DOWN

	WWLLW	ANI_SUPERSLAVE2,3,L3FO3A+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,L3FO3A+FR4,#puppet_tbl,3

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WWLLW	ANI_SUPERSLAVE2,3,L3FO3A+FR5,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,1,L3FO3A+FR6,#puppet_tbl,5

	WL	ANI_XFLIP_TBL,#xflip_tbl
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	WL	ANI_SLAVEANIM,#breakneck_tbl
	WLLL	ANI_SETOPPVELS,30000h,40000h,0		;x,y,z vels

	.word	ANI_DETACH

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40

	WL	3,L3FO3A+FR6

	WL	4,L3FO3A+FR7
	WL	4,L3FO3A+FR8

	.word	ANI_XFLIP
	WL	4,L4ST4A+FR5

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#xflip_tbl
	.word	1 ;bret
	.word	1 ;razor
	.word	1 ;taker
	.word	1 ;yoko
	.word	1 ;shawn
	.word	1 ;bam
	.word	1 ;doink
	.word	1 ;spare
	.word	1 ;lex

#breakneck_tbl
	.long	hrt_break_neck2_anim
	.long	rzr_break_neck2_anim
	.long	und_break_neck2_anim
	.long	yok_break_neck2_anim
	.long	shn_break_neck2_anim
	.long	bam_break_neck2_anim
	.long	dnk_break_neck2_anim
	.long	0
	.long	lex_break_neck2_anim


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
 LWWW H4MF4B+FR9,-21,18,0
 LWWW H3PP3X+FR3,-19,61,0
 LWWW H3PP3X+FR4,-19,54,1
 LWWW H3PP3X+FR5,-13,55,1
 LWWW H3PP3X+FR7,-52,-16,1
 LWWW H3PP3X+FR8,-58,-36,1
 .long 0
#Razor
 LWWW R4MF4B+FR9,-58,25,0
 LWWW R3GP3Z+FR3,-17,39,0
 LWWW R3GP3Z+FR4,-18,43,1
 LWWW R3GP3Z+FR5,-10,45,1
 LWWW R3GP3Z+FR7,-48,0,1
 LWWW R3GP3Z+FR8,-53,-40,1
 .long 0
#Taker
 LWWW U4PM3C+FR7,-35,26,0
 LWWW U3PP3X+FR3,-26,27,1
 LWWW U3PP3X+FR4,-32,35,0
 LWWW U3PP3X+FR5,-23,42,0
 LWWW U3GP3X+FR1,-58,-23,0
 LWWW U3GP3X+FR2,-56,-44,0
 .long 0
#Yokozuna
 LWWW Y3MF3B+FR7,-41,19,0
 LWWW Y3PP3Q+FR3,-14,21,0
 LWWW Y3PP3Q+FR4,-17,20,1
 LWWW Y3PP3Q+FR7,-31,37,1
 LWWW Y3FD3N+FR2,-67,-16,1
 LWWW Y3FD3N+FR3,-65,-15,1
 .long 0
#Shawn
 LWWW S3MF3B+FR7,-45,19,0
 LWWW S3GP3X+FR3,-10,22,0
 LWWW S3GP3X+FR4,-10,43,1
 LWWW S3GP3X+FR5,-13,33,1
 LWWW S3GP3X+FR7,-53,-15,1
 LWWW S3GP3X+FR6,-55,-32,1
 .long 0
#BamBam
 LWWW B4MF4A+FR7,-55,32,0
 LWWW B3MS3Z+FR5,-36,25,0
 LWWW B3PP3Q+FR3,-22,36,1
 LWWW B3PP3Q+FR4,-12,52,1
 LWWW B3PP3Q+FR7,-63,-7,1
 LWWW B3FD3C+FR1,-70,-29,1
 .long 0
#Doink
 LWWW D4MF4A+FR9,-29,35,0
 LWWW D3PD3Z+FR3,-8,35,1
 LWWW D3PD3Z+FR4,-13,60,0
 LWWW D3PD3Z+FR6,-3,47,0
 LWWW D3PD3Z+FR8,-48,-28,0
 LWWW D3PD3Z+FR9,-47,-46,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3MF3B+FR6,-36,14,0
 LWWW L3GP3Z+FR2,-10,19,0
 LWWW L3GP3Z+FR3,-15,20,1
 LWWW L3GP3Z+FR5,-11,37,1
 LWWW L3FH3A+FR6,-59,-12,1
 LWWW L3FD3B+FR1,-56,-35,1
 .long 0


#*****************************************************************************
*
* GRAB & SLAM ANIM

 SUBR	lex_grabslam_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,10
	LEAPATOPP 12,40,40,40,90000h,TGT_HEAD,70,78,0
	WL	ANI_SET_YVEL,0
	WL	5,L4PO4A+FR1
	WL	5,L4PO4A+FR2

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	.word	ANI_ATTACK_ON, AMODE_PUPPET,31,51,56,53 ;mode,x,y,w,h
	WL	3,L4PO4A+FR3
	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

	WL	ANI_IFBLOCKED,#missedb
	WL	ANI_IFSTATUS,#gotim

;	WL	2,L4PO4A+FR3
#missedb
	WL	10,L4PO4A+FR4

;missed
	WL	14,L4PO4A+FR4
	WL	6,L4PO4A+FR3
	WL	6,L4PO4A+FR2
	WL	6,L4PO4A+FR1

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#gotim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker
	WWLLW	ANI_SUPERSLAVE2,6,L4PO4A+FR5,lex_grab_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,L4PO4A+FR6,lex_grab_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,L4PO4A+FR7,lex_grab_tbl,2
;	WWLLW	ANI_SUPERSLAVE2,5,L4PO4A+FR8,lex_grab_tbl,3

	WL	ANI_CHANGEANIM,lex_slamdown_anim


;RJR END
#*****************************************************************************
*back breaker

 SUBR	lex_backbreaker_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	ANI_SLAVEANIM,slaveanim_tbl

	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker
	WWL	ANI_SETLONG,OBJ_GRAVITY,0a000h
	WL	ANI_SET_YVEL,060000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS
	WWLLW	ANI_SUPERSLAVE2,4,L4ZZ5B+FR1,#puppet_tbl,0

	.word	ANI_ATTACHZ,0,0,-2		;put opp behind attacker
	WWLLW	ANI_SUPERSLAVE2,1,L4ZZ5B+FR2,#puppet_tbl,1

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

	.word	ANI_DEBRISAT,300,1,0,8,0	;%chance, tbl index, x,y,z off

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40

	WWLLW	ANI_SUPERSLAVE2,3,L4ZZ5B+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,L4ZZ5B+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,8,L4ZZ5B+FR5,#puppet_tbl,4

	WL	ANI_XFLIP_TBL,#xflip_tbl
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	WL	ANI_SLAVEANIM,#bounceoff_tbl
	WLLL	ANI_SETOPPVELS,0,0,-28000h	;x,y,z vels

	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WL	20,L4ZZ5B+FR5

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END








	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker
	WWL	ANI_SETLONG,OBJ_GRAVITY,0a000h
	WL	ANI_SET_YVEL,060000h
	WWLLW	ANI_SUPERSLAVE2,4,L4ZZ5B+FR1,#puppet_tbl,0

	.word	ANI_ATTACHZ,0,0,-2		;put opp behind attacker
	WWLLW	ANI_SUPERSLAVE2,1,L4ZZ5B+FR2,#puppet_tbl,1
	.word	ANI_WAITHITGND
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40

	WWLLW	ANI_SUPERSLAVE2,3,L4ZZ5B+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,L4ZZ5B+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,14,L4ZZ5B+FR5,#puppet_tbl,4

	WWLLW	ANI_SUPERSLAVE2,4,L4ZZ5B+FR4,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,4,L4ZZ5B+FR3,#puppet_tbl,6

	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker
	WWLLW	ANI_SUPERSLAVE2,4,L4ZZ5B+FR2,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,4,L4PO4A+FR8,#puppet_tbl,8

	WL	ANI_CHANGEANIM,lex_ohslam_anim


#xflip_tbl
	.word	1 ;bret
	.word	1 ;razor
	.word	1 ;taker
	.word	0 ;yoko
	.word	1 ;shawn
	.word	1 ;bam
	.word	1 ;doink
	.word	1 ;spare
	.word	1 ;lex

#bounceoff_tbl
	.long	hrt_slambounce_anim	;bret
	.long	rzr_slambounce_anim	;razor
	.long	und_slambounce_anim	;taker
	.long	yok_slambounce_anim	;yoko
	.long	shn_slambounce_anim	;shawn
	.long	bam_slambounce_anim	;bam
	.long	dnk_slambounce_anim	;doink
	.long	und_slambounce_anim	;spare
	.long	lex_slambounce_anim	;lex

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
 LWWW H3BR3Z+FR4,-30,14,1
 LWWW H3BR3Z+FR4,-30,15,1
 LWWW H3BR3Z+FR3,-19,7,1
 LWWW H3BR3Z+FR2,-14,12,1
 LWWW H3BR3Z+FR1,-4,7,1
 LWWW H3BR3Z+FR2,-12,13,1
 LWWW H3BR3Z+FR4,-21,6,1
 LWWW H4MF4B+FR9,-21,20,1
 LWWW H4MF4B+FR9,-20,15,1
 .long 0
#Razor
 LWWW R3AM3D+FR2,-12,24,1
 LWWW R3FD3B+FR5,-18,46,1
 LWWW R3FD3B+FR5,-16,42,1
 LWWW R3BR3Z+FR2,-11,9,1
 LWWW R3BR3Z+FR3,-19,1,1
 LWWW R3BR3Z+FR2,-15,8,1
 LWWW R3AM3D+FR2,-6,10,1
 LWWW R4MF4B+FR9,-55,31,1
 LWWW R4MF4B+FR9,-57,28,1
 .long 0
#Taker
 LWWW U3CP3B+FR2,-36,18,0
 LWWW U3CP3B+FR2,-37,19,0
 LWWW U3CP3B+FR1,-34,5,0
 LWWW U3BR3Z+FR4,-25,15,1
 LWWW U3BR3Z+FR3,-23,-1,1
 LWWW U3BR3Z+FR4,-23,16,1
 LWWW U3CP3B+FR2,-28,7,1
 LWWW U4PM3C+FR7,-29,34,1
 LWWW U4PM3C+FR7,-29,27,1
 .long 0
#Yokozuna
 LWWW Y3RL1A+FR1,-33,23,0
 LWWW Y3RL1A+FR1,-30,20,0
 LWWW Y3CP3B+FR1,-13,13,0
 LWWW Y3BR3Z+FR2,-3,13,1
 LWWW Y3BR3Z+FR1,-26,11,1
 LWWW Y3BR3Z+FR2,-6,13,1
 LWWW Y3CP3B+FR1,-7,18,0
 LWWW Y3MF3B+FR7,-32,29,0
 LWWW Y3MF3B+FR7,-30,20,0
 .long 0
#Shawn
 LWWW S3CP3B+FR2,-25,25,0
 LWWW S3CP3B+FR2,-26,25,0
 LWWW S3CP3B+FR7,-24,1,0
 LWWW S3BR3Z+FR2,-6,-1,1
 LWWW S3BR3Z+FR3,4,-1,1
 LWWW S3BR3Z+FR2,-5,-3,1
 LWWW S3CP3B+FR7,-26,-2,1
 LWWW S3MF3B+FR7,-43,31,1
 LWWW S3MF3B+FR7,-41,23,1
 .long 0
#BamBam
 LWWW B3BR3Z+FR13,-32,29,1
 LWWW B3BR3Z+FR13,-34,28,1
 LWWW B3BR3Z+FR16,-27,34,1
 LWWW B3BR3Z+FR15,-22,16,1
 LWWW B3BR3Z+FR14,-28,23,1
 LWWW B3BR3Z+FR15,-22,18,1
 LWWW B3BR3Z+FR13,-25,20,1
 LWWW B4MF4A+FR7,-52,43,1
 LWWW B4MF4A+FR7,-51,35,1
 .long 0
#Doink
 LWWW D3UC3A+FR5,-34,38,1
 LWWW D3UC3A+FR5,-33,38,1
 LWWW D3SA3A+FR2,-24,3,0
 LWWW D3BK3Z+FR6,-16,9,1
 LWWW D3BK3Z+FR7,-21,-3,1
 LWWW D3BK3Z+FR7,-19,-1,1
 LWWW D3BK3Z+FR6,-20,14,1
 LWWW D4MF4A+FR9,-33,45,1
 LWWW D4MF4A+FR9,-32,37,1
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3UC3A+FR4,-22,24,1
 LWWW L3UC3A+FR4,-25,25,1
 LWWW L3UC3A+FR6,-16,9,1
 LWWW L3BR3Z+FR2,-12,3,1
 LWWW L3BR3Z+FR1,-13,-7,1
 LWWW L3BR3Z+FR2,-12,3,1
 LWWW L3UC3A+FR6,-16,9,1
 LWWW L3MF3B+FR6,-36,16,1
 LWWW L3MF3B+FR6,-34,13,1
 .long 0

#*****************************************************************************
*drop

 SUBR	lex_ohslam_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	ANI_SLAVEANIM,slaveanim_tbl

	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker

	WL	ANI_SET_YVEL,50000h
	WLW	ANI_SET_ZVEL,-10000h,AM_ABS

	WWLLW	ANI_SUPERSLAVE2,12,L4CF4A+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,L4CF4A+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,L4CF4A+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,L4CF4A+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,L4CF4A+FR5,#puppet_tbl,4

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40

	WWLLW	ANI_SUPERSLAVE2,4,L4CF4A+FR7,#puppet_tbl,5

	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#slambounce_tbl
	WLLL	ANI_SETOPPVELS,10000h,40000h,20000h	;x,y,z vels
	.word	ANI_DETACH

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	WL	4,L4CF4A+FR8
	WL	4,L4CF4A+FR9
	WL	4,L4CF4A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#xflip_tbl
	.word	0 ;bret
	.word	0 ;razor
	.word	0 ;taker
	.word	1 ;yoko
	.word	0 ;shawn
	.word	0 ;bam
	.word	0 ;doink
	.word	0 ;spare
	.word	0 ;lex

#slambounce_tbl
	.long	hrt_slambounce_anim	;bret
	.long	rzr_slambounce_anim	;razor
	.long	und_slambounce_anim	;taker
	.long	yok_slambounce_anim	;yoko
	.long	shn_slambounce_anim	;shawn
	.long	bam_slambounce_anim	;bam
	.long	dnk_slambounce_anim	;doink
	.long	und_slambounce_anim	;spare
	.long	lex_slambounce_anim	;lex

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
 LWWW H4MF4B+FR1,-33,15,0
 LWWW H4MF4B+FR1,-33,15,0
 LWWW H4MF4B+FR1,-30,15,0
 LWWW H4MF4B+FR1,-20,16,0
 LWWW H4MF4B+FR1,-9,11,0
 LWWW H3MS3X+FR1,0,-38,0
 .long 0
#Razor
 LWWW R4MF4B+FR6,-32,21,0
 LWWW R4MF4B+FR6,-32,22,0
 LWWW R4MF4B+FR6,-29,23,0
 LWWW R4MF4B+FR6,-19,22,0
 LWWW R4MF4B+FR6,-8,19,0
 LWWW R3MS3Z+FR6,3,-31,0
 .long 0
#Taker
 LWWW U4PM3C+FR6,-46,23,0
 LWWW U4PM3C+FR6,-46,24,0
 LWWW U4PM3C+FR6,-43,25,0
 LWWW U4PM3C+FR6,-33,24,0
 LWWW U4PM3C+FR6,-22,21,0
 LWWW U3CF3Q+FR1,-21,-46,0
 .long 0
#Yokozuna
 LWWW Y3MF3B+FR7,-41,27,0
 LWWW Y3MF3B+FR7,-41,28,0
 LWWW Y3MF3B+FR7,-34,27,0
 LWWW Y3MF3B+FR7,-24,27,0
 LWWW Y3MF3B+FR7,-15,22,0
 LWWW Y3KF3B+FR1,-1,-24,0
 .long 0
#Shawn
 LWWW S3MF3B+FR6,-47,23,0
 LWWW S3MF3B+FR6,-44,25,0
 LWWW S3MF3B+FR6,-37,21,0
 LWWW S3MF3B+FR6,-34,23,0
 LWWW S3MF3B+FR6,-23,18,0
 LWWW S3CF3Z+FR1,8,-43,0
 .long 0
#BamBam
 LWWW B4MF4A+FR6,-52,39,0
 LWWW B4MF4A+FR6,-52,40,0
 LWWW B4MF4A+FR6,-49,41,0
 LWWW B4MF4A+FR6,-39,40,0
 LWWW B4MF4A+FR6,-28,37,0
 LWWW B3RL1A+FR7,2,-37,0
 .long 0
#Doink
 LWWW D4MF4A+FR1,-38,17,0
 LWWW D4MF4A+FR1,-38,18,0
 LWWW D4MF4A+FR1,-35,19,0
 LWWW D4MF4A+FR1,-25,18,0
 LWWW D4MF4A+FR1,-14,15,0
 LWWW D3GS3X+FR8,-1,-43,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3MF3B+FR6,-47,16,0
 LWWW L3MF3B+FR6,-47,17,0
 LWWW L3MF3B+FR6,-44,18,0
 LWWW L3MF3B+FR6,-34,17,0
 LWWW L3MF3B+FR6,-23,14,0
 LWWW L3TF3X+FR1,-16,-39,0
 .long 0

#*****************************************************************************

 SUBR	lex_grab2elbow_anim


	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	.word	ANI_STARTATTACK,AT_PUPPET,8

	WL	4,L3RE3C+FR1
	WL	4,L3RE3C+FR2

	.word	ANI_ATTACK_ON, AMODE_PUPPET,2,1,40+10,22 ;mode,x,y,w,h
	WL	4,L3RE3C+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#gotim

;missed
	WL	8,L3RE3C+FR3
	WL	4,L3RE3C+FR2
	WL	4,L3RE3C+FR1

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#gotim
;what about block?

	.word	ANI_OFFSET,0,0,-1			;x,y,z

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker

	WWLLW	ANI_SUPERSLAVE2,4,L3RE3C+FR4,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,L3RE3C+FR5,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,10,L3RE3C+FR6,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,L3RE3C+FR7,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,L3RE3C+FR8,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,L3RE3C+FR9,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,4,L3RE3C+FR10,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,4,L3RE3C+FR12,#puppet_tbl,7

	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#breakneck2_tbl
	WLLL	ANI_SETOPPVELS,30000h,40000h,0	;x,y,z vels

	.word	ANI_DETACH

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WL	10,L3RE3C+FR12
	WL	6,L3RE3C+FR13
	WL	6,L3RE3C+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END



#xflip_tbl
	.word	0 ;bret
	.word	0 ;razor
	.word	0 ;taker
	.word	0 ;yoko
	.word	0 ;shawn
	.word	0 ;bam
	.word	0 ;doink
	.word	0 ;spare
	.word	1 ;lex

#breakneck2_tbl
	.long	hrt_breakneck2_anim	;bret
	.long	rzr_breakneck2_anim	;razor
	.long	und_breakneck2_anim	;taker
	.long	yok_breakneck2_anim	;yoko
	.long	shn_breakneck2_anim	;shawn
	.long	bam_breakneck2_anim	;bam
	.long	dnk_breakneck2_anim	;doink
	.long	lex_breakneck2_anim	;spare
	.long	lex_breakneck2_anim	;lex


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
 LWWW H4KM3B+FR3,39,28,0
 LWWW H4KM3B+FR8,-2,-12,0
 LWWW H4KM3B+FR6,2,-17,0
 LWWW H4KM3B+FR6,7,-18,0
 LWWW H4KM3B+FR6,6,-14,0
 LWWW H4KM3B+FR6,1,-8,0
 LWWW H4KM3B+FR8,2,-17,0
 LWWW H3UC3X+FR1,58,7,0
 .long 0
#Razor
 LWWW R3LE3A+FR1,40,34,1
 LWWW R3LE3A+FR2,10,19,1
 LWWW R3LE3A+FR4,-3,5,1
 LWWW R3LE3A+FR4,2,4,1
 LWWW R3LE3A+FR4,1,8,1
 LWWW R3LE3A+FR4,-4,14,1
 LWWW R3LE3A+FR2,11,14,1
 LWWW R3FD3B+FR1,52,6,0
 .long 0
#Taker
 LWWW U4KM3E+FR6,42,33,0
 LWWW U4KM3E+FR5,17,12,0
 LWWW U4KM3E+FR4,1,-5,0
 LWWW U4KM3E+FR4,6,-6,0
 LWWW U4KM3E+FR4,5,-2,0
 LWWW U4KM3E+FR4,0,4,0
 LWWW U4KM3E+FR5,18,7,0
 LWWW U3FD3X+FR1,59,12,1
 .long 0
#Yokozuna
 LWWW Y4KB3A+FR8,31,21,0
 LWWW Y4KB3A+FR7,9,5,0
 LWWW Y4KB3A+FR6,8,-6,0
 LWWW Y4KB3A+FR6,12,-7,0
 LWWW Y4KB3A+FR6,11,-3,0
 LWWW Y4KB3A+FR6,6,3,0
 LWWW Y4KB3A+FR7,8,0,0
 LWWW Y3FD3A+FR1,57,6,0
 .long 0
#Shawn
 LWWW S4KM3C+FR8,26,27,0
 LWWW S4KM3C+FR7,-1,1,0
 LWWW S4KM3C+FR6,-12,-15,0
 LWWW S4KM3C+FR6,-7,-16,0
 LWWW S4KM3C+FR6,-8,-12,0
 LWWW S4KM3C+FR6,-13,-6,0
 LWWW S4KM3C+FR7,0,-4,0
 LWWW S3UC3X+FR2,21,4,0
 .long 0
#BamBam
 LWWW B4KM3A+FR8,21,28,0
 LWWW B4KM3A+FR7,2,15,0
 LWWW B4KM3A+FR6,-3,1,0
 LWWW B4KM3A+FR6,2,0,0
 LWWW B4KM3A+FR6,1,4,0
 LWWW B4KM3A+FR6,-4,10,0
 LWWW B4KM3A+FR7,1,10,0
 LWWW B4UC3B+FR2,23,2,0
 .long 0
#Doink
 LWWW D2KM3B+FR2,29,33,0
 LWWW D2KM3B+FR3,7,17,0
 LWWW D2KM3B+FR4,-10,6,0
 LWWW D2KM3B+FR4,-5,5,0
 LWWW D2KM3B+FR4,-6,9,0
 LWWW D2KM3B+FR4,-11,15,0
 LWWW D2KM3B+FR3,8,12,0
 LWWW D3UC3A+FR3,36,19,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3LE3A+FR1,40,31,1
 LWWW L3LE3A+FR2,9,16,1
 LWWW L3LE3A+FR3,8,5,1
 LWWW L3LE3A+FR3,13,4,1
 LWWW L3LE3A+FR3,12,8,1
 LWWW L3LE3A+FR3,7,14,1
 LWWW L3LE3A+FR2,9,11,1
 LWWW L3LE3A+FR4,2,2,1
 .long 0


#*****************************************************************************
*
* HIP TOSS RUNNING OPPONENT


 SUBR	lex_hiptoss_anim

 	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,10

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_SET_YVEL,0

	WL	2,L4HT3A+FR2
	.word	ANI_ATTACK_ON, AMODE_PUPPET,33,56,44,18 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,6,L4HT3A+FR2
	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS
	WWL	ANI_WAITHITOPP,4,L4HT3A+FR2
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

;got him
	WL	ANI_CODE,DO_SNAP_MESS
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,4,L4HT3A+FR6,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,L4HT3A+FR7,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,L4HT3A+FR8,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,L4HT3A+FR9,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,L4HT3A+FR10,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,L4HT3A+FR11,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,4,L4HT3A+FR12,#puppet_tbl,6

	;impact
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_DAMAGEOPP,D_HIPTOSS

	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#rollout_tbl

	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_DETACH

	WL	19,L4HT3A+FR12

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WL	10,L4HT3A+FR2
#missed
	WL	20,L4HT3A+FR2

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#xflip_tbl
	.word	0 ;bret
	.word	0 ;razor
	.word	0 ;taker
	.word	0 ;yoko
	.word	0 ;shawn
	.word	0 ;bam
	.word	0 ;doink
	.word	0 ;spare
	.word	0 ;lex

#rollout_tbl
	.long	hrt_tossed_anim,rzr_tossed_anim
	.long	und_tossed_anim
	.long	yok_tossed_anim
	.long	shn_tossed_anim,bam_tossed_anim
	.long	dnk_tossed_anim,0,lex_tossed_anim

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
 LWWW H2AM3A+FR1,74,10,0
 LWWW H2AM3A+FR7,33,4,0
 LWWW H3FR3A+FR2,13,7,0
 LWWW H3FR3A+FR3,-15,40,0
 LWWW H3FR3A+FR4,-28,27,0
 LWWW H3FR3A+FR5,-63,16,0
 LWWW H2CP3A+FR8,-143,-84,1
 .long 0
#Razor
 LWWW R3TD3A+FR3,51,1,0
 LWWW R3TD3A+FR4,27,-2,0
 LWWW R3TD3A+FR5,17,8,0
 LWWW R3TD3A+FR6,-13,31,0
 LWWW R3TD3A+FR7,-30,33,0
 LWWW R3TD3A+FR8,-71,21,0
 LWWW R3GU2A+FR1,-167,-82,1
 .long 0
#Taker
 LWWW U4AM4C+FR4,56,13,0
 LWWW U3FH3A+FR1,44,6,1
 LWWW U3FH3A+FR2,-2,16,1
 LWWW U3FH3A+FR3,-19,26,1
 LWWW U3FH3A+FR4,-38,20,1
 LWWW U3FH3A+FR5,-76,31,1
 LWWW U3CP3B+FR1,-164,-77,1
 .long 0
#Yokozuna
 LWWW Y3FL3W+FR1,57,25,0
 LWWW Y3FL3W+FR2,28,17,0
 LWWW Y3FL3W+FR3,-15,22,0
 LWWW Y3FL3W+FR4,-36,36,0
 LWWW Y3FL3W+FR6,-39,37,0
 LWWW Y3FL3W+FR7,-74,24,0
 LWWW Y3FD3A+FR7,-127,-59,0
 .long 0
#Shawn
 LWWW S3OS3X+FR4,26,20,1
 LWWW S3OS3X+FR5,5,11,1
 LWWW S3OS3X+FR6,-4,41,1
 LWWW S3OS3X+FR7,-26,51,1
 LWWW S3OS3X+FR8,-26,51,1
 LWWW S3OS3X+FR9,-84,34,1
 LWWW S3OS3X+FR10,-137,-73,1
 .long 0
#BamBam
 LWWW B4TD3B+FR2,39,9,0
 LWWW B4TD3B+FR3,21,12,0
 LWWW B4TD3B+FR4,6,12,0
 LWWW B4TD3B+FR6,-18,57,0
 LWWW B4TD3B+FR7,-38,38,0
 LWWW B4TD3B+FR8,-69,13,0
 LWWW B4TD3B+FR9,-116,-68,0
 .long 0
#Doink
 LWWW D3PM4C+FR2,37,20,0
 LWWW D3OS3A+FR1,31,11,0
 LWWW D3OS3A+FR3,-7,6,0
 LWWW D3OS3A+FR4,-25,28,0
 LWWW D3OS3A+FR6,-28,25,0
 LWWW D3FD3E+FR2,-67,0,0
 LWWW D3SA3A+FR2,-138,-80,1
 .long 0
#Adam
 .long 0
#Lex
 LWWW L4AM4B+FR3,63,11,0
 LWWW L3FH3A+FR2,24,5,0
 LWWW L3FH3A+FR3,8,9,0
 LWWW L3FH3A+FR4,-9,22,0
 LWWW L3FH3A+FR5,-23,11,0
 LWWW L3FH3A+FR6,-69,16,0
 LWWW L3CP3X+FR1,-162,-78,1
 .long 0


******************************************************************************

	.end
