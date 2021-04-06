**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		7/15/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"lexseq3.asm"
	.title	"lockup stuff and special attacks"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"macros.h"
	.include	"mproc.equ"		;Mproc equates
	.include	"sys.equ"
	.include	"game.equ"
	.include	"plyr.equ"
	.include	"anim.equ"
	.include	"ring.equ"
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

	.ref	CALL_OTHER_AVERAGE,CALL_ANI_AVERAGE_MOVE
	.ref	CALL_THROWN_OUT,MOVE_NAME_ANNC
	.ref	DO_NONO,DO_OTHERNONO,FIND_AND_KILL_ENDLESS,CALL_SETUP
	.ref	CALL_SPECIAL_MOVE,HIT_THE_MAT,SMALL_BOUNCE
	.ref	CALL_MISSES,clear_opp_counts
	.ref	DO_COMBO_MESS,set_xdrift

	.ref	tgt_tbukl,set_position,set_skeleton_pal,start_smoke
	.ref	ckzpos,set_my_pal,make_white,tbukl_flip,make_norm

	.ref	slaveanim_tbl

	.ref	lex_stand4_anim
	.ref	lex_faceup_getup_anim

	.ref	hrt_breakneck2_anim,rzr_breakneck2_anim,und_breakneck2_anim
	.ref	yok_breakneck2_anim,shn_breakneck2_anim,bam_breakneck2_anim
	.ref	dnk_breakneck2_anim,lex_breakneck2_anim

	.ref	hrt_tossed_anim,rzr_tossed_anim,und_tossed_anim
	.ref	yok_tossed_anim,shn_tossed_anim,bam_tossed_anim
	.ref	dnk_tossed_anim,lex_tossed_anim

	.ref	hrt_3_head_held_anim,rzr_3_head_held_anim
	.ref	und_3_head_held_anim,yok_3_head_held_anim
	.ref	shn_3_head_held_anim,bam_3_head_held_anim
	.ref	dnk_3_head_held_anim

	.ref	hrt_slambounce_anim,rzr_slambounce_anim,und_slambounce_anim
	.ref	yok_slambounce_anim,shn_slambounce_anim,bam_slambounce_anim
	.ref	dnk_slambounce_anim,lex_slambounce_anim

	.ref	hrt_break_neck2_anim,rzr_break_neck2_anim
	.ref	und_break_neck2_anim,yok_break_neck2_anim
	.ref	shn_break_neck2_anim,bam_break_neck2_anim
	.ref	dnk_break_neck2_anim
	.ref	lex_combo_ground_punch_anim

	.REF    lex_combo_knee_fall_anim
	.ref	lex_combo_ground_clobber_anim
	.REF	lex_combo_hammer_anim
	.REF	lex_combo_clobber_anim
	.REF	CALL_BONE_BREAK


#*****************************************************************************
*
* HELD OVERHEAD ANIMATION

 SUBR	lex_heldoh_anim

	.word	ANI_SETPLYRMODE,MODE_ATTACHED
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_SETSPEED,100h

	.word	ANI_SETWORD,USR_VAR1,0		;loop count
	WL	ANI_CODE,DO_OTHERNONO
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

	WL	ANI_CODE,FIND_AND_KILL_ENDLESS
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
*
* CLIMB UP TURNBUCKLES

 SUBR	lex_climb_up_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SCROLL_CTRL,LEX_TBUKLY
	WL	3,L4HU4A+FR5
	WL	3,L4HU4A+FR6
	WL	3,L4HU4A+FR7
	WL	ANI_CODE,tgt_tbukl
	.word	ANI_LEAPATPOS,24,200,8,8,0	;#ticks,dist,xoff,yoff,zoff
	WL	15,L4HU4A+FR8
	WL	9,L4HU4A+FR9

	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONTURNBKL
	.word	ANI_SHAKECORNER
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOGRAVITY|MODE_OVERLAP
	.word	ANI_SCROLL_CTRL,SC_RESTORE
	WL	3,L4HU4A+FR7
	WL	ANI_CODE,tbukl_flip

#repeat
	WL	5,L4SB4A+FR1
	WL	ANI_CODE,tbukl_flip
	WL	5,L4SB4A+FR2
	WL	ANI_CODE,tbukl_flip
	WL	5,L4SB4A+FR3
	WL	ANI_CODE,tbukl_flip
	WL	5,L4SB4A+FR4
	WL	ANI_CODE,tbukl_flip
	WL	5,L4SB4A+FR5
	WL	ANI_CODE,tbukl_flip
	WL	5,L4SB4A+FR6
	WL	ANI_CODE,tbukl_flip
	WL	5,L4SB4A+FR7
	WL	ANI_CODE,tbukl_flip
	WL	ANI_GOTO,#repeat

#*****************************************************************************
*
* CLIMB DOWN TURNBUCKLES

 SUBR	lex_climb_down_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SCROLL_CTRL,SC_RESTORE

	.word	ANI_SHAKECORNER

	WLW	ANI_SET_XVEL,10000h,AM_FACE_REL
	WLW	ANI_SET_ZVEL,10000h,AM_ABS
	WL	ANI_SET_YVEL,20000h

	WL	1,L4HU4A+FR8

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,L4HU4A+FR7
	WL	3,L4HU4A+FR6
	WL	3,L4HU4A+FR5

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* GET BUZZED FROM DOINK

 SUBR	lex_get_buzz_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable

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

	WL	1,L4ST4C+FR4
	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	.ref	lex_fall_back_anim
	WL	ANI_CHANGEANIM,lex_fall_back_anim
;	.word	ANI_END

#nodead


	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#make_black

;This is a black color within the wrestler's pal.  It is different for each
;wrestler.
	movi	1a1ah,a14

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
	cmpi	3,a0
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
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h

	WWWL	ANI_IFROPE,RC_EITHER,100,#fall_back

	;plenty of room.  break yer neck.
	.word	ANI_OFFSET,-9,0,0
	WL	4,L3FD3B+FR3
	.word	ANI_OFFSET,-8,0,0
	WL	4,L3FD3B+FR4
	.word	ANI_OFFSET,-8,0,0
	WL	4,L3FD3B+FR5
	.word	ANI_OFFSET,1,0,0
	WL	4,L3FD3B+FR6
	.word	ANI_OFFSET,-32,0,0
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
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_OFFSET,-15,0,0

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	20,L3RL1A+FR5
	.word	ANI_WAITROLL

	WL	ANI_CHANGEANIM,lex_faceup_getup_anim
;	.word	ANI_END

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

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_OFFSET,-15,0,0

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	20,L3RL1A+FR5
	.word	ANI_WAITROLL

	WL	ANI_CHANGEANIM,lex_faceup_getup_anim
;	.word	ANI_END

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
	WL	1,L1TT5A+FR4
	WL	1,L1TT5A+FR5
	WL	1,L1TT5A+FR6

 SUBR	lex_4_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_STARTATTACK,AT_PUPPET,12
	WL	3,L4WS4B+FR1

	LEAPATOPP 8,999,80,80,30000h,TGT_HEAD,26,6,-2
	WL	4,L4WS4B+FR2
	WL	4,L4WS4B+FR3
	.word	ANI_ZERO_XZVELS

	.word	ANI_ATTACK_ON, AMODE_PUPPET2,24,0,32,20 ;mode,x,y,w,h
	WL	4,L4WS4B+FR4
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2

;got him
	.word	ANI_CLR_BUTCOUNT
	WL	ANI_CODE,clear_opp_counts
	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	WL	ANI_CODE,DO_NONO
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	WL	ANI_CODE,CALL_SETUP

	.word	ANI_SOUND,98h			;neck break (5-7 ticks late)

	WWLLW	ANI_SUPERSLAVE2,3,L4GH3B+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,L4GH3B+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,L4GH3B+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,L4GH3B+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,L4GH3B+FR5,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,L4GH3B+FR6,#puppet_tbl,5

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	3,L4GH3B+FR6
	.word	ANI_CLROPPMODE,MODE_GHOST

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	20,L4WS4B+FR4
	WL	3,L4WS4B+FR3
	WL	3,L4WS4B+FR2
	WL	3,L4WS4B+FR1

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
 LWWW H3GU4A+FR1,41,-34,0
 LWWW H3GU4A+FR3,63,-41,0
 LWWW H3DU3A+FR3,57,-41,1
 LWWW H3DU3A+FR4,59,-29,1
 LWWW H3DU3A+FR5,57,-28,1
 LWWW H3BF3A+FR1,41,-34,0
 .long 0
#Razor
 LWWW R3GU2A+FR3,41,-25,0
 LWWW R3GU4A+FR4,51,-35,0
 LWWW R3GU4A+FR5,57,-44,0
 LWWW R3GU4A+FR6,56,-42,0
 LWWW R3DU3B+FR4,53,-27,1
 LWWW R3BF3A+FR1,44,-36,0
 .long 0
#Taker
 LWWW U3DU3B+FR2,43,-26,1
 LWWW U3DU3B+FR5,55,-31,1
 LWWW U3DU3B+FR6,59,-39,1
 LWWW U3DU3B+FR8,50,-33,1
 LWWW U3DU3B+FR10,52,-20,1
 LWWW U4BF3Z+FR5,36,-15,0
 .long 0
#Yokozuna
 LWWW Y3GU2A+FR1,45,-20,0
 LWWW Y3GU2A+FR3,62,-22,0
 LWWW Y3GU2A+FR4,37,-35,0
 LWWW Y3GU2A+FR7,38,-44,0
 LWWW Y3GU2A+FR11,55,-31,0
 LWWW Y3BF3A+FR1,40,-24,0
 .long 0
#Shawn
 LWWW S3GU2A+FR1,40,-28,0
 LWWW S3GU4A+FR2,47,-33,0
 LWWW S3GU4A+FR4,56,-46,0
 LWWW S3GU4A+FR6,60,-31,0
 LWWW S3GU4A+FR7,59,-31,0
 LWWW S3BF3A+FR1,28,-35,0
 .long 0
#BamBam
 LWWW B3GU4A+FR3,46,-24,0
 LWWW B3GU4A+FR5,57,-32,0
 LWWW B3GU4A+FR7,57,-38,0
 LWWW B3GU4A+FR8,58,-33,0
 LWWW B3GU4A+FR9,61,-24,0
 LWWW B3BF3C+FR5,45,-28,0
 .long 0
#Doink
 LWWW D3GU4A+FR2,41,-31,0
 LWWW D3GU4A+FR3,46,-39,0
 LWWW D3GU4A+FR5,44,-37,0
 LWWW D3GU4A+FR6,51,-37,0
 LWWW D3GU4A+FR7,59,-37,0
 LWWW D3BF3A+FR2,37,-34,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3GU4A+FR1,48,-28,0
 LWWW L3DU3A+FR4,37,-30,1
 LWWW L3DU3A+FR6,38,-41,1
 LWWW L3DU3A+FR7,45,-35,1
 LWWW L3DU3A+FR9,47,-29,1
 LWWW L3BF3B+FR5,34,-32,0
 .long 0
#******************************************************************************

 SUBR	lex_4_taunt_anim

	.word	ANI_SETMODE,MODE_UNINT
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

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

;	.ref	set_taunt_bit
;	WL	ANI_CODE,set_taunt_bit

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,lex_stand4_anim
;	.word	ANI_END

#*****************************************************************************
*
* Head slams into mat
;From head slam - repeated head slam

 SUBR	lex_break_face2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	.word	ANI_ZEROVELS

	WL	2,L3TF3X+FR1		;Face down
	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off
	WL	ANI_SET_YVEL,80000h
	WL	1,L3TF3X+FR1		;Face down
	WL	3,L3TF3X+FR2		;Face down
	WL	3,L3TF3X+FR3		;Face down
	WL	3,L3TF3X+FR4		;Face down
	WL	3,L3TF3X+FR5		;Face down
	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	.word	ANI_WAITROLL
	WL	3,L3TF3X+FR1		;Face down
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim
	
 SUBR	lex_break_face3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS

	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off
	WL	3,L3MS3Z+FR4
	WL	ANI_SET_YVEL,078000h
	WL	100,L3MS3Z+FR4
	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim
	


* Head slams into mat
;From head slam

 SUBR	lex_break_face_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	.word	ANI_ZEROVELS


	WL	2,L3TF3X+FR1		;Face down
	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off
	WL	ANI_SET_YVEL,40000h
	WL	1,L3TF3X+FR1		;Face down
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

#*****************************************************************************
*
* END OF BACK BROKEN SEQ.

 SUBR	lex_backbroken_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
;	.word	ANI_DETACH

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
;	.word	ANI_END

#*****************************************************************************
*
* #3 HEAD HOLD AND HEAD HOLD2

	.bss	#opp_xvel,32

 SUBR	lex_3_fake_hold_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,6
	WL	3,L4GH3Z+FR1
	WL	3,L4GH3Z+FR2
	WL	7,L4GH3Z+FR3
	WL	ANI_GOTO,#missed

 SUBR	lex_3_head_hold2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,6
	WL	3,L4GH3Z+FR1
	WL	3,L4GH3Z+FR2
	.word	ANI_ATTACK_ON,AMODE_PUPPET_HDGRAB,14,96,64,21 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,7,L4GH3Z+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb
	WL	ANI_GOTO,#gothim

 SUBR	lex_3_head_hold_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,9
	WL	2,L4GH3Z+FR1
	WL	2,L4GH3Z+FR2
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 6,999,65,45,90000h,TGT_HEAD,60,100,0
	LEAPATOPP 9,999,40,45,90000h,TGT_HEAD,60,100,0
	WL	3,L4GH3Z+FR3
	.word	ANI_ATTACK_ON, AMODE_PUPPET,14,96,64,21 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,5,L4GH3Z+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb
#gothim
	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	.word	ANI_SETWORD,USR_VAR2,0
	.word	ANI_CLR_BUTCOUNT
	.ref	head_grab_time
	WL	ANI_CODE,head_grab_time

	.word	ANI_ATTACHZ,0,0,-10		;x & y don't matter.
	WL	ANI_CODE,DO_NONO
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,1,L4GH3Z+FR3,#puppet_tbl,0

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WWLLW	ANI_SUPERSLAVE2,2,L4GH3Z+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,2,L4GH3Z+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,2,L4GH3B+FR6,#puppet_tbl,3

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	1,L4GH3B+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	5,L4GH3Z+FR3
	WL	3,L4GH3Z+FR2
	WL	3,L4GH3Z+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	.word	ANI_ZEROVELS
	WL	ANI_SET_YVEL,30000h

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	5,L4GH3Z+FR3
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
 LWWW H4AH3A+FR1,45,10,0
 LWWW H3HB3A+FR3,45,-7,0
 LWWW H3HB3A+FR2,35,-13,0
 LWWW H3BF3A+FR1,30,-34,0
 .long 0
#Razor
 LWWW R4AH4C+FR3,47,9,0
 LWWW R3HB3A+FR3,46,-9,0
 LWWW R3HB3A+FR2,42,-24,0
 LWWW R3BF3A+FR1,34,-36,0
 .long 0
#Taker
 LWWW U4AH3A+FR2,35,19,0
 LWWW U4BF3A+FR2,30,5,0
 LWWW U4BF3A+FR3,7,-10,0
 LWWW U4BF3Z+FR5,32,-15,0
 .long 0
#Yokozuna
 LWWW Y4AE4A+FR2,56,0,0
 LWWW Y4AM4A+FR1,54,-6,0
 LWWW Y4AM4A+FR2,45,-12,0
 LWWW Y3BF3A+FR1,34,-24,0
 .long 0
#Shawn
 LWWW S4AH3D+FR5,42,-1,0
 LWWW S4AH3D+FR1,33,-2,0
 LWWW S4BF3A+FR2,36,-15,0
 LWWW S3BF3A+FR1,20,-35,0
 .long 0
#BamBam
 LWWW B4AH4A+FR1,38,4,0
 LWWW B4BF3A+FR1,47,4,0
 LWWW B3HB3A+FR2,35,-26,0
 LWWW B3BF3C+FR5,29,-28,0
 .long 0
#Doink
 LWWW D3AH3B+FR1,37,6,0
 LWWW D3AK3A+FR3,36,3,0
 LWWW D3AK3A+FR2,44,-12,0
 LWWW D3BF3A+FR2,33,-34,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L4AH4B+FR3,37,2,0
 LWWW L3BF3A+FR1,43,0,1
 LWWW L3BF3A+FR2,39,-16,1
 LWWW L3BF3B+FR5,29,-32,0
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

**************************************
 SUBR	lex_combo_vsuplex_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 6,40,40,40,90000h,TGT_CHEST,40,0,0
	.word	ANI_ATTACK_ON, AMODE_PUPPET,30,46,60,38 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,8,L3VS3A+FR1
	.word	ANI_ATTACK_OFF
	.word	ANI_ZEROVELS

	WL	ANI_IFNOTSTATUS,#missedc

	.word	ANI_INC_COMBO
	.word	ANI_SOUND,82h			;Effort grunt

	.word	ANI_ATTACHZ,0,0,5
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWWL	ANI_IFROPE,RC_BACK,XTOSSDIST_CLOSE,#throw_him_outc

	WWL	ANI_SETLONG,OBJ_GRAVITY,0f000h

;	WL	ANI_SLAVEANIM,slaveanim_tbl

	WWLLW	ANI_SUPERSLAVE2,3,L3VS3A+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,L3VS3A+FR3,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,L3VS3A+FR4,#puppet_tbl,2
	WL	ANI_SET_YVEL,030000h
	WWLLW	ANI_SUPERSLAVE2,3,L3VS3A+FR5,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,15,L3VS3A+FR6,#puppet_tbl,4
	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WL	ANI_SET_YVEL,080000h

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
	.word	ANI_DAMAGEOPP,D_PILEDRIVER,RD_PILEDRIVER

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

	.word	ANI_SETMODE,MODE_NORMAL

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim

#missedc
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#throw_him_outc
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_GOTO,#throw_him_out

**************************************
 SUBR	lex_vsuplex_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_ATTACK_ON,AMODE_PUPPET,10,48,76,36
	WWL	ANI_WAITHITOPP,3,L3VS3A+FR1
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;got him
	.word	ANI_SOUND,82h			;Effort grunt

	.word	ANI_ATTACHZ,0,0,5
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWWL	ANI_IFROPE,RC_BACK,XTOSSDIST_CLOSE,#throw_him_out

	WWLLW	ANI_SUPERSLAVE2,3,L3VS3A+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,L3VS3A+FR3,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,L3VS3A+FR4,#puppet_tbl,2
	WL	ANI_SET_YVEL,030000h
	WWLLW	ANI_SUPERSLAVE2,3,L3VS3A+FR5,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,15,L3VS3A+FR6,#puppet_tbl,4
	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WWL	ANI_SETLONG,OBJ_GRAVITY,0f000h
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

	.WORD	ANI_ADD_MOVE,MOVE_C_2,2,2
	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_PILEDRIVER,RD_PILEDRIVER
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	.word	ANI_DRAW_NAME,42
	WWLLW	ANI_SUPERSLAVE2,3,L3UC3A+FR6,#puppet_tbl,9

	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#slambounce_tbl
	WLLL	ANI_SETOPPVELS,-30000h,40000h,0		;x,y,z vels

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_DETACH
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

	.word	ANI_XFLIP
	WL	1,L3GU4A+FR1
	WL	ANI_SET_YVEL,030000h
	.word	ANI_WAITHITGND

	.word	ANI_SETMODE,MODE_NORMAL

	WL	ANI_CHANGEANIM,lex_faceup_getup_anim

#missed
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#throw_him_out
	WWLLW	ANI_SUPERSLAVE2,3,L3VS3A+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,17,L3VS3A+FR3,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,2,L3VS3A+FR4,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,2,L3VS3A+FR5,#puppet_tbl,3
	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL
	WL	ANI_SET_YVEL,030000h
	WWLLW	ANI_SUPERSLAVE2,2,L3VS3A+FR6,#puppet_tbl,4
	WL	ANI_CODE,CALL_THROWN_OUT
	WLLL	ANI_ATTACHVEL,-0A0000h,70000h,0h		;x,y,z
	WL	ANI_SLAVEANIM,#flyout_tbl2
	WL	ANI_OPPOFFSET,#release_table
	WL	ANI_XFLIP_TBL,#xflip_tbl2
	.word	ANI_DETACH
	WL	2,L3VS3A+FR6
	WL	1,L3VS3A+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	WL	3,L3VS3A+FR7
	WL	3,L3VS3A+FR6
	WL	3,L3VS3A+FR5
	WL	3,L3VS3A+FR4
	WL	3,L3VS3A+FR3
	WL	3,L3VS3A+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#release_table
	;	X Y
	.word	0,40		;Bret
	.word	0,20		;Razor
	.word	0,20		;Taker
	.word	0,20		;Yokozuna
	.word	0,-20		;Shawn
	.word	0,50		;BamBam
	.word	0,-40		;Doink
	.word	0,0		;Adam
	.word	0,20		;Lex

	.ref	und_flyout2_anim
	.ref	yok_flyout2_anim
	.ref	bam_flyout2_anim
	.ref	dnk_flyout2_anim
	.ref	lex_flyout2_anim

#flyout_tbl2
	.long	hrt_flyout_anim
	.long	rzr_flyout_anim
	.long	und_flyout2_anim
	.long	yok_flyout2_anim
	.long	shn_flyout_anim
	.long	bam_flyout2_anim
	.long	dnk_flyout2_anim
	.long	0
	.long	lex_flyout2_anim


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

#xflip_tbl2
	.word	0 ;bret
	.word	0 ;razor
	.word	0 ;taker
	.word	0 ;yoko
	.word	1 ;shawn
	.word	0 ;bam
	.word	1 ;doink
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
*
*
 SUBR	lex_4_graboh_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_STARTATTACK,AT_PUPPET,10
	WL	3,L4PO4A+FR1
	LEAPATOPP 10,70,55,55,90000h,TGT_CHEST,70,78,0
	WL	ANI_SET_YVEL,20000h
	WL	4,L4PO4A+FR2
	WL	2,L4PO4A+FR3
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	.word	ANI_ATTACK_ON, AMODE_PUPPET,31,51,56,53 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,6,L4PO4A+FR3
	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

	WL	ANI_IFNOTSTATUS,#missed
	.WORD	ANI_ADD_MOVE,MOVE_C_2,2,2
	WL	ANI_IFBLOCKED,#missedb

;#gotim
	.ref	CALL_SETUP
	WL	ANI_CODE,CALL_SETUP
	.word	ANI_SOUND,82h			;Effort grunt
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker
	WL	ANI_CODE,DO_NONO
	WWLLW	ANI_SUPERSLAVE2,8,L4PO4A+FR5,puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,L4PO4A+FR6,puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,L4PO4A+FR7,puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,L4PO4A+FR8,puppet_tbl,3

	WL	ANI_SLAVEANIM,heldoh_tbl

	WL	1,L4PO4A+FR8

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETPLYRMODE,MODE_OPPOVERHEAD
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_END

#missedb
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	15,L4PO4A+FR4
 
#missed
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	15,L4PO4A+FR4
	WL	3,L4PO4A+FR3
	WL	3,L4PO4A+FR2
	WL	3,L4PO4A+FR1

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
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

heldoh_tbl
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
puppet_tbl
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

#*****************************************************************************

 SUBR	lex_slamdown_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_ZEROVELS
;	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_SETSPEED,100h
	WL	ANI_SLAVEANIM,slaveanim_tbl

	.word	ANI_SOUND,82h			;Effort grunt

	.word	ANI_DRAW_NAME,6

	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker

	WL	ANI_SET_YVEL,028000h
	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2

	WWLLW	ANI_SUPERSLAVE2,4,L3FO3A+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,L3FO3A+FR2,#puppet_tbl,1

	WWWL	ANI_IFROPE,RC_BACK,XTOSSDIST_CLOSE,#throw_him_out
	.word	ANI_FACE,MOVE_LEFT|MOVE_DOWN

	WWLLW	ANI_SUPERSLAVE2,3,L3FO3A+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,L3FO3A+FR4,#puppet_tbl,3

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	WWLLW	ANI_SUPERSLAVE2,3,L3FO3A+FR5,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,1,L3FO3A+FR6,#puppet_tbl,5

	WL	ANI_OPPOFFSET,#release_table
	WL	ANI_XFLIP_TBL,#xflip_tbl
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	WL	ANI_SLAVEANIM,#breakneck_tbl
	WLLL	ANI_SETOPPVELS,30000h,40000h,0		;x,y,z vels
	.word	ANI_DEBRISAT,300,1,0,8,0	;%chance,tbl index,x,y,z off

	.word	ANI_DETACH

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_HIPTOSS,RD_HIPTOSS
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	WL	3,L3FO3A+FR6
	WL	ANI_CODE,#set_opp_y
	WL	3,L3FO3A+FR7
	WL	3,L3FO3A+FR8

	.word	ANI_XFLIP
	WL	3,L4ST4C+FR4

	.word	ANI_FACEDOWN		;down looks good on a miss
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#release_table
	;	X Y
	.word	32,24		;Bret
	.word	0,0		;Razor
	.word	0,0		;Taker
	.word	0,0		;Yokozuna
	.word	0,0		;Shawn
	.word	0,0		;BamBam
	.word	0,0		;Doink
	.word	0,0		;Adam
	.word	0,0		;Lex

#set_opp_y
	move	*a13(WHOIHIT),a0,L
	movi	[5,0],a14
	move	a14,*a0(OBJ_YVEL),L
	movi	[2,0],a14
	move	a14,*a0(OBJ_ZVEL),L

	movi	-[3,0],a1
	move	*a0(NEW_FACING_DIR),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#abs			;right
	neg	a1			;left
#abs
	move	a1,*a0(OBJ_XVEL),L
	rets

#throw_him_out
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	ANI_CODE,CALL_THROWN_OUT
	WLLL	ANI_ATTACHVEL,0A0000h,70000h,0h		;x,y,z
	WL	ANI_SLAVEANIM,flyout_tbl
	.word	ANI_DETACH


	WL	3,L3FO3A+FR3
	WL	3,L3FO3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,10

	WL	3,L3FO3A+FR5
	WL	25,L3FO3A+FR6
	WL	4,L3FO3A+FR7
	WL	4,L3FO3A+FR8

	.word	ANI_XFLIP
	WL	4,L4ST4C+FR4

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

 SUBR	lex_combo_backbreak_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,10
	LEAPATOPP 12,100,40,40,90000h,TGT_HEAD,70,78,0
	WL	ANI_SET_YVEL,0
	WL	5,L4PO4A+FR1
	WL	5,L4PO4A+FR2

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	.word	ANI_ATTACK_ON, AMODE_PUPPET,31,51,56,53 ;mode,x,y,w,h
	WL	3,L4PO4A+FR3
	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

	WL	ANI_IFBLOCKED,#missedbc
	.word	ANI_INC_COMBO

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker
	WWLLW	ANI_SUPERSLAVE2,8,L4PO4A+FR5,puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,5,L4PO4A+FR6,puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,5,L4PO4A+FR7,puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,5,L4PO4A+FR8,puppet_tbl,3

	WL	ANI_SLAVEANIM,heldoh_tbl

	WL	4,L4PO4A+FR8

	WL	ANI_SLAVEANIM,slaveanim_tbl

	.word	ANI_SET_RPTCOUNT,3	;5 times
#back_loop
	.word	ANI_CLR_BUTCOUNT
	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker
	WWL	ANI_SETLONG,OBJ_GRAVITY,0a000h
	WL	ANI_SET_YVEL,060000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS
	WWLLW	ANI_SUPERSLAVE2,4,L4ZZ5B+FR1,#puppet_tbl,0

	.word	ANI_ATTACHZ,0,0,-2		;put opp behind attacker
	WWLLW	ANI_SUPERSLAVE2,1,L4ZZ5B+FR2,#puppet_tbl,1

	.word	ANI_INC_COMBO
	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

	.word	ANI_DEBRISAT,300,1,0,8,0	;%chance, tbl index, x,y,z off

	;impact
	WL	ANI_CODE,CALL_BONE_BREAK
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40

	WWLLW	ANI_SUPERSLAVE2,3,L4ZZ5B+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,L4ZZ5B+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,8,L4ZZ5B+FR5,#puppet_tbl,4

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IFNOT_RPTCOUNT,#no_more_back
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#special_exit_move
	WL	ANI_GOTO,#back_loop
#no_more_back

	WL	ANI_XFLIP_TBL,#xflip_tbl
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	WL	ANI_SLAVEANIM,#bounceoff_tbl
	WLLL	ANI_SETOPPVELS,0,0,-28000h	;x,y,z vels

	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_IMMOBILIZE,75
	WL	20,L4ZZ5B+FR5
	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#no_hammer
	.word	ANI_OPP_GETUP,-75
	WL	ANI_CHANGEANIM,lex_combo_hammer_anim

#no_hammer
	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#exit_move
	WL	ANI_CHANGEANIM,lex_combo_ground_punch_anim

#exit_move
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#special_exit_move
	WL	ANI_XFLIP_TBL,#xflip_tbl
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	WL	ANI_SLAVEANIM,#bounceoff_tbl
	WLLL	ANI_SETOPPVELS,0,0,-28000h	;x,y,z vels

	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WL	20,L4ZZ5B+FR5
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedbc
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	10,L4PO4A+FR4

	WL	14,L4PO4A+FR4
	WL	6,L4PO4A+FR3
	WL	6,L4PO4A+FR2
	WL	6,L4PO4A+FR1

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


*
* BACK BREAKER

 SUBR	lex_backbreaker_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS

	WL	ANI_SLAVEANIM,slaveanim_tbl

	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker
	WWL	ANI_SETLONG,OBJ_GRAVITY,0a000h
	WL	ANI_SET_YVEL,070000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS
	WWLLW	ANI_SUPERSLAVE2,4,L4ZZ5B+FR1,#puppet_tbl,0

	.word	ANI_ATTACHZ,0,0,-2		;put opp behind attacker
	WWLLW	ANI_SUPERSLAVE2,1,L4ZZ5B+FR2,#puppet_tbl,1

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

	.word	ANI_DEBRISAT,350,1,0,8,0	;%chance, tbl index, x,y,z off

	;impact
	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
;	.word	ANI_SHAKER,50

	WWLLW	ANI_SUPERSLAVE2,2,L4ZZ5B+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,2,L4ZZ5B+FR4,#puppet_tbl,3
	.word	ANI_SHAKER,50
	WWLLW	ANI_SUPERSLAVE2,6,L4ZZ5B+FR5,#puppet_tbl,4

	WL	ANI_SET_YVEL,028000h

	WL	ANI_CODE,CALL_BONE_BREAK
	WL	ANI_XFLIP_TBL,#xflip_tbl
	.word	ANI_DAMAGEOPP,D_BACKBRKR,RD_BACKBRKR
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	WL	ANI_SLAVEANIM,#bounceoff_tbl
	WLLL	ANI_SETOPPVELS,0,0,-38000h	;x,y,z vels

	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WL	12,L4ZZ5B+FR5

	.word	ANI_FACEDOWN		;down looks good on a miss
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


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
;	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_ZERO_XZVELS

	WWWL	ANI_IFNOTROPE,RC_EITHER,XTOSSDIST,#ok
	WL	ANI_CODE,#ck_flip

#ok	WL	ANI_SLAVEANIM,slaveanim_tbl
	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker

	WL	ANI_SET_YVEL,50000h
	WLW	ANI_SET_ZVEL,-10000h,AM_ABS

	.word	ANI_SOUND,82h			;Effort grunt

;	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	.word	ANI_DRAW_NAME,6
	WWLLW	ANI_SUPERSLAVE2,12,L4CF4A+FR1,#puppet_tbl,0
;	WWLLW	ANI_SUPERSLAVE2,3,L4CF4A+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,1,L4CF4A+FR2,#puppet_tbl,1
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
;	WWWL	ANI_IFNOTROPE,RC_FRONT,XTOSSDIST_CLOSE,#ok
;
;
;	.WORD	ANI_XFLIP
;
;#ok
	WWLLW	ANI_SUPERSLAVE2,3,L4CF4A+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,L4CF4A+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,L4CF4A+FR5,#puppet_tbl,4

	.word	ANI_ZERO_XZVELS
	;impact
	.WORD	ANI_ADD_MOVE,MOVE_C_6,2,2
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	WL	ANI_CODE,CALL_SPECIAL_MOVE
	.word	ANI_DAMAGEOPP,D_HIPTOSS,RD_HIPTOSS

	WWLLW	ANI_SUPERSLAVE2,4,L4CF4A+FR7,#puppet_tbl,5

	WL	ANI_CODE,CALL_SPECIAL_MOVE

	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#slambounce_tbl
	WLLL	ANI_SETOPPVELS,10000h,50000h,20000h	;x,y,z vels
	.word	ANI_DEBRISAT,300,1,0,8,0	;%chance,tbl index,x,y,z off
	.word	ANI_DETACH

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WL	ANI_SET_YVEL,30000h
	WLW	ANI_SET_ZVEL,-10000h,AM_ABS

	WL	3,L4CF4A+FR8
	WL	ANI_CODE,#set_opp_y
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	20,L4CF4A+FR8
	WL	3,L4CF4A+FR9
	WL	3,L4CF4A+FR10

	.word	ANI_FACEDOWN		;down looks good on a miss
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#ck_flip
	move	*a13(OBJ_XPOSINT),a1
	cmpi	RING_X_CENTER,a1
	jrgt	#check_right_rope
;On left side of ring
;check facing down and left

	movi	MOVE_RIGHT|MOVE_DOWN,a0
	move	*a13(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#no_flip
	xori	M_FLIPH,a14
	move	a14,*a13(OBJ_CONTROL)

	xori	MOVE_LEFT|MOVE_RIGHT,a0
#no_flip
	move	a0,*a13(FACING_DIR)
	rets

#check_right_rope
	movi	MOVE_LEFT|MOVE_DOWN,a0
	move	*a13(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrnz	#no_flip
	xori	M_FLIPH,a14
	move	a14,*a13(OBJ_CONTROL)
	xori	MOVE_RIGHT|MOVE_RIGHT,a0
	jruc	#no_flip

;	.if 0
;#throw_him_out
;	WL	ANI_CODE,CALL_THROWN_OUT
;	WLLL	ANI_ATTACHVEL,0A0000h,70000h,0h		;x,y,z
;	WL	ANI_SLAVEANIM,#flyout_tbl
;	WL	ANI_OPPOFFSET,#release_table
;
;	.WORD	ANI_FACE,MOVE_LEFT|MOVE_DOWN
;	.WORD	ANI_XFLIP
;	.word	ANI_DETACH
;	WL	3,L3FO3A+FR3
;	WL	3,L3FO3A+FR4
;	.word	ANI_WAITHITGND
;	.word	ANI_ZERO_XZVELS
;	.word	ANI_SHAKEALL,2
;	.word	ANI_SHAKER,10
;
;	WL	3,L3FO3A+FR5
;	WL	3,L3FO3A+FR6
;
;	WL	3,L3FO3A+FR6
;
;	WL	4,L3FO3A+FR7
;	WL	4,L3FO3A+FR8
;
;	.word	ANI_XFLIP
;	WL	4,L4ST4C+FR4
;
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END
;
;#release_table
;	;	X Y
;	.word	0,0		;Bret
;	.word	0,0		;Razor
;	.word	0,0		;Taker
;	.word	0,0		;Yokozuna
;	.word	0,0		;Shawn
;	.word	0,0		;BamBam
;	.word	0,0		;Doink
;	.word	0,0		;Adam
;	.word	0,0		;Lex
;
;	.ref	und_flyout2_anim
;	.ref	yok_flyout2_anim
;	.ref	bam_flyout2_anim
;	.ref	dnk_flyout2_anim
;	.ref	lex_flyout2_anim
;
;#flyout_tbl
;	.long	hrt_flyout_anim
;	.long	rzr_flyout_anim
;	.long	und_flyout2_anim
;	.long	yok_flyout2_anim
;	.long	shn_flyout_anim
;	.long	bam_flyout2_anim
;	.long	dnk_flyout2_anim
;	.long	0
;	.long	lex_flyout2_anim
;
;	.endif

#set_opp_y
	move	*a13(WHOIHIT),a0,L
	movi	[5,0],a14
	move	a14,*a0(OBJ_YVEL),L
	movi	[2,0],a14
	move	a14,*a0(OBJ_ZVEL),L

	movi	-[3,0],a1
	move	*a0(NEW_FACING_DIR),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#abs			;right
	neg	a1			;left
#abs
	move	a1,*a0(OBJ_XVEL),L
	rets

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

 SUBR	lex_combo_grab2elbow_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_STARTATTACK,AT_PUPPET,8

	WL	3,L4WS4B+FR1
	WL	3,L4WS4B+FR2

	.word	ANI_ATTACK_ON, AMODE_PUPPET,14,0,67,100 ;mode,x,y,w,h
	WL	1,L4WS4B+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#gotimc

;missed
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	8,L4WS4B+FR3
	WL	3,L4WS4B+FR2
	WL	3,L4WS4B+FR1

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#gotimc
	.word	ANI_INC_COMBO
	.word	ANI_OFFSET,0,0,-1			;x,y,z
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker

	WWLLW	ANI_SUPERSLAVE2,2,L4WS4B+FR3,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,L4WS4B+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,L4WA4B+FR6,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,L4WA4B+FR7,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,12,L4BZ3B+FR1,#puppet_tbl,4
	WL	3,L4BZ3B+FR2
	WL	3,L4BZ3B+FR3
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_XVEL,30000h,AM_FACE_REL
	WL	1,L4BZ3B+FR4
	WL	ANI_CODE,#flsh_wht

	.word	ANI_DEBRISAT,500,1,-25,35,0	;%chance, tbl index, x,y,z off
	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2

	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#breakneck2_tbl
	WLLL	ANI_SETOPPVELS,40000h,40000h,10000h	;x,y,z vels

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,35
	.word	ANI_DAMAGEOPP,D_PILEDRIVER,RD_PILEDRIVER
	.ref	impact_sound
	WL	ANI_CODE,impact_sound
	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE

	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	12,L4BZ3B+FR4
	WL	3,L4BZ3B+FR5
	WL	3,L4BZ3B+FR6
	WL	3,L4BZ3B+FR7

	.word	ANI_IMMOBILIZE,100
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#exit_move
	WL	ANI_CHANGEANIM,lex_combo_ground_clobber_anim
#exit_move

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_FACEDOWN		;down looks good on a miss
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


***************************************************

 SUBR	lex_grab2elbow_rev_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_STARTATTACK,AT_PUPPET,8
	.word	ANI_SETPLYRMODE,MODE_NORMAL

;	WL	3,L4WS4B+FR1
;	WL	3,L4WS4B+FR2

	.word	ANI_ATTACK_ON, AMODE_PUPPET,14,0,67,25 ;mode,x,y,w,h
	WL	1,L4WS4B+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#gotimr

;missed
	WL	8,L4WS4B+FR3
	WL	3,L4WS4B+FR2
	WL	3,L4WS4B+FR1

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#gotimr
	.word	ANI_OFFSET,0,0,-1			;x,y,z
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker

	WL	ANI_GOTO,#inhere

***************************************************

 SUBR	lex_grab2elbow_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_STARTATTACK,AT_PUPPET,8

	WL	3,L4WS4B+FR1
	WL	3,L4WS4B+FR2

	.word	ANI_ATTACK_ON, AMODE_PUPPET,14,0,67,25 ;mode,x,y,w,h
	WL	1,L4WS4B+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#gotim

;missed
	WL	8,L4WS4B+FR3
	WL	3,L4WS4B+FR2
	WL	3,L4WS4B+FR1

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#gotim
	.word	ANI_OFFSET,0,0,-1			;x,y,z
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker

	WWLLW	ANI_SUPERSLAVE2,4,L4WS4B+FR3,#puppet_tbl,0
#inhere	WWLLW	ANI_SUPERSLAVE2,4,L4WS4B+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,L4WA4B+FR6,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,L4WA4B+FR7,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,14,L4BZ3B+FR1,#puppet_tbl,4
	WL	3,L4BZ3B+FR2
	WL	3,L4BZ3B+FR3
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_XVEL,30000h,AM_FACE_REL
	WL	1,L4BZ3B+FR4
	WL	ANI_CODE,#flsh_wht

	.word	ANI_DEBRISAT,500,1,-25,35,0	;%chance, tbl index, x,y,z off
	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2

	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#breakneck2_tbl
	WL	ANI_CODE,#setopp_deadanim
	WLLL	ANI_SETOPPVELS,50000h,40000h,10000h	;x,y,z vels

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,35
	.word	ANI_DAMAGEOPP,D_PILEDRIVER,RD_PILEDRIVER
	.ref	impact_sound
	WL	ANI_CODE,impact_sound
	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE

	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	12,L4BZ3B+FR4
	WL	3,L4BZ3B+FR5
	WL	3,L4BZ3B+FR6
	WL	3,L4BZ3B+FR7

	.word	ANI_FACEDOWN		;down looks good on a miss
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBRP	#setopp_deadanim
	move	*a13(ATTACH_PROC),a0,L
	jrz	#rets
	move	*a0(STATUS_FLAGS),a14,L
	ori	M_DEAD_ANIM,a14
	move	a14,*a0(STATUS_FLAGS),L
#rets	rets


#flsh_wht
	.ref	flash_white
	calla	flash_white
	rets

#xflip_tbl
	.word	0 ;bret
	.word	0 ;razor
	.word	1 ;taker
	.word	0 ;yoko
	.word	0 ;shawn
	.word	0 ;bam
	.word	0 ;doink
	.word	0 ;spare
	.word	0 ;lex

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
 LWWW H3HB3A+FR1,36,-13,0
 LWWW H3HB3A+FR2,44,34,0
 LWWW H4KM3C+FR2,50,27,0
 LWWW H4KM3C+FR7,23,10,0
 LWWW H4KM3C+FR4,0,-8,0
 .long 0
#Razor
 LWWW R3HB3A+FR2,49,4,0
 LWWW R3HB3A+FR3,54,39,0
 LWWW R4KM3A+FR8,60,28,0
 LWWW R4KM3A+FR7,21,6,0
 LWWW R4KM3A+FR5,25,-3,0
 .long 0
#Taker
 LWWW U4BF3A+FR3,15,18,0
 LWWW U4BF3A+FR2,39,53,0
 LWWW U2KM3B+FR6,53,49,0
 LWWW U2KM3B+FR5,28,18,0
 LWWW U2KM3B+FR4,17,3,0
 .long 0
#Yokozuna
 LWWW Y4AM4A+FR2,51,16,0
 LWWW Y4AM4A+FR1,62,42,0
 LWWW Y4KM3A+FR8,41,28,0
 LWWW Y4KM3A+FR6,12,5,0
 LWWW Y4KM3A+FR5,18,-3,0
 .long 0
#Shawn
 LWWW S4BF3A+FR3,22,-1,0
 LWWW S4BF3A+FR2,48,31,0
 LWWW S4KM3C+FR8,60,26,0
 LWWW S4KM3C+FR7,32,-4,0
 LWWW S4KM3C+FR5,23,-14,0
 .long 0
#BamBam
 LWWW B3HB3A+FR2,45,1,0
 LWWW B4BF3A+FR1,58,52,0
 LWWW B4KM3A+FR8,41,30,0
 LWWW B4KM3A+FR7,19,14,0
 LWWW B4KM3A+FR6,18,4,0
 .long 0
#Doink
 LWWW D3AK3A+FR2,51,16,0
 LWWW D3AK3A+FR3,43,53,0
 LWWW D4KM3A+FR8,56,25,0
 LWWW D4KM3A+FR7,21,5,0
 LWWW D4KM3A+FR5,21,-5,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3BF3A+FR2,51,10,1
 LWWW L3BF3A+FR1,61,46,1
 LWWW L4KM3B+FR8,55,36,0
 LWWW L4KM3B+FR7,21,13,0
 LWWW L4KM3B+FR6,19,5,0
 .long 0


#*****************************************************************************
*
* HIP TOSS RUNNING OPPONENT

 SUBR	lex_combo_hiptoss_anim

 	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,10

	.word	ANI_SET_RPTCOUNT,3	;5 times
#hiptoss_loop
	.word	ANI_CLR_BUTCOUNT
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 6,40,40,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_SET_YVEL,0

	WL	2,L4HT3A+FR2
	.word	ANI_ATTACK_ON, AMODE_PUPPET,30,46,60,38 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,8,L4HT3A+FR2
	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

;got him
	.word	ANI_INC_COMBO
	WL	ANI_CODE,DO_GRUNT

	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,3,L4HT3A+FR6,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,L4HT3A+FR7,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,L4HT3A+FR8,#puppet_tbl,2
	WWWL	ANI_IFROPE,RC_BACK,XTOSSDIST_CLOSE,#throw_him_outc
	WWLLW	ANI_SUPERSLAVE2,3,L4HT3A+FR9,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,L4HT3A+FR10,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,L4HT3A+FR11,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,3,L4HT3A+FR11,#puppet_tbl,6

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_DAMAGEOPP,D_HIPTOSS,RD_HIPTOSS

	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,SLAM_HIM
	WLLL	ANI_SETOPPVELS,0,090000h,0000h		;x,y,z vels

	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_DETACH
	WL	8,L4HT3A+FR11
	WL	4,L4HT3A+FR12
	.word	ANI_FACE,MOVE_LEFT|MOVE_UP
	.word	ANI_XFLIP

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IFNOT_RPTCOUNT,#next_combo_bit
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#exit_move
	WL	ANI_GOTO,#hiptoss_loop

#next_combo_bit
	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#not_grab
	WL	ANI_CHANGEANIM,lex_combo_grab2elbow_anim

#not_grab
	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#exit_move
	WL	ANI_CHANGEANIM,lex_combo_vsuplex_anim

#exit_move
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedbc
	WL	10,L4HT3A+FR2
#missedc
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_CODE,CALL_MISSES
	WL	20,L4HT3A+FR2

	.word	ANI_FACEDOWN		;down looks good on a miss
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#throw_him_outc

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_GOTO,#throw_him_out

	.ref	hrt_slamnobounce_anim	;bret
	.ref	rzr_slamnobounce_anim	;razor
	.ref	und_slamnobounce_anim	;taker
	.ref	yok_slamnobounce_anim	;yoko
	.ref	shn_slamnobounce_anim	;shawn
	.ref	bam_slamnobounce_anim	;bam
	.ref	dnk_slamnobounce_anim	;doink
	.ref	und_slamnobounce_anim	;spare
	.ref	lex_slamnobounce_anim	;lex
SLAM_HIM
	.long	hrt_slamnobounce_anim	;bret
	.long	rzr_slamnobounce_anim	;razor
	.long	und_slamnobounce_anim	;taker
	.long	yok_slamnobounce_anim	;yoko
	.long	shn_slamnobounce_anim	;shawn
	.long	bam_slamnobounce_anim	;bam
	.long	dnk_slamnobounce_anim	;doink
	.long	und_slamnobounce_anim	;spare
	.long	lex_slamnobounce_anim	;lex

****************************

 SUBR	lex_hiptoss_anim

 	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,10

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_SET_YVEL,0

	WL	4,L4HT3A+FR2
	.word	ANI_ATTACK_ON, AMODE_PUPPET_TOSS,23,46,54,38 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,L4HT3A+FR2
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACK_OFF
	WL	4,L4HT3A+FR2
	WL	ANI_GOTO,#common

 SUBR	lex_hiptoss2_anim

 	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,10

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,60,55,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_SET_YVEL,0

	WL	4,L4HT3A+FR2
	.word	ANI_ATTACK_ON, AMODE_PUPPET_TOSS,23,46,54,38 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,8,L4HT3A+FR2
	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

#common
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

#got_him
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	.word	ANI_DRAW_NAME,26
	WL	ANI_CODE,CALL_SPECIAL_MOVE
	WL	ANI_CODE,DO_GRUNT

	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,3,L4HT3A+FR6,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,L4HT3A+FR7,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,L4HT3A+FR8,#puppet_tbl,2
	WWWL	ANI_IFROPE,RC_BACK,XTOSSDIST_CLOSE,#throw_him_out
	WWLLW	ANI_SUPERSLAVE2,3,L4HT3A+FR9,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,L4HT3A+FR10,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,L4HT3A+FR11,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,3,L4HT3A+FR11,#puppet_tbl,6

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,35
	.word	ANI_DAMAGEOPP,D_HIPTOSS,RD_HIPTOSS

	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#rollout_tbl

	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_DETACH

	WL	7,L4HT3A+FR11
	WL	3,L4HT3A+FR12

	.word	ANI_XFLIP
	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedb
;	.ref	ck_hiptoss
;	WL	ANI_CODE,ck_hiptoss
;	WL	ANI_IFNOTSTATUS,#got_him

	WL	10,L4HT3A+FR2
;Delay longer if 2nd hiptoss in quick succession!
	.ref	hiptoss_delay
	WL	ANI_CODE,hiptoss_delay
	WL	ANI_IFNOTSTATUS,#missed
	WL	24,L4HT3A+FR2
#missed
	WL	ANI_CODE,CALL_MISSES
	WL	8,L4HT3A+FR2

	.word	ANI_FACEDOWN		;down looks good on a miss
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#throw_him_out
	WL	ANI_CODE,CALL_THROWN_OUT
	WLLL	ANI_ATTACHVEL,-0A0000h,90000h,0h		;x,y,z
	WL	ANI_SLAVEANIM,flyout_tbl
	WL	ANI_OPPOFFSET,#release_table
	.word	ANI_DETACH

	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,10

	WL	3,L4HT3A+FR10
	WL	3,L4HT3A+FR11
	WL	3,L4HT3A+FR12

	.word	ANI_XFLIP
	.word	ANI_FACEUP		;up looks good on a hit
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#release_table
	;	X Y
	.word	0,0		;Bret
	.word	0,0		;Razor
	.word	0,0		;Taker
	.word	0,0		;Yokozuna
	.word	0,0		;Shawn
	.word	0,0		;BamBam
	.word	0,0		;Doink
	.word	0,0		;Adam
	.word	0,0		;Lex

DO_GRUNT
	WRSND	W_LUGER,GRABFLING_T1,GRABFLING_T2
	RETS

	.ref	hrt_flyout_anim
	.ref	rzr_flyout_anim
	.ref	und_flyout_anim
	.ref	yok_flyout_anim
	.ref	shn_flyout_anim
	.ref	bam_flyout_anim
	.ref	dnk_flyout_anim
	.ref	lex_flyout_anim

flyout_tbl
	.long	hrt_flyout_anim
	.long	rzr_flyout_anim
	.long	und_flyout_anim
	.long	yok_flyout_anim
	.long	shn_flyout_anim
	.long	bam_flyout_anim
	.long	dnk_flyout_anim
	.long	0
	.long	lex_flyout_anim



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
 LWWW H2CP3A+FR8,-148,-65,1
 .long 0
#Razor
 LWWW R3TD3A+FR3,51,1,0
 LWWW R3TD3A+FR4,27,-2,0
 LWWW R3TD3A+FR5,17,8,0
 LWWW R3TD3A+FR6,-13,31,0
 LWWW R3TD3A+FR7,-30,33,0
 LWWW R3TD3A+FR8,-71,21,0
 LWWW R3GU2A+FR1,-172,-63,1
 .long 0
#Taker
 LWWW U4AM4C+FR4,56,13,0
 LWWW U3FH3A+FR1,44,6,1
 LWWW U3FH3A+FR2,-2,16,1
 LWWW U3FH3A+FR3,-19,26,1
 LWWW U3FH3A+FR4,-38,20,1
 LWWW U3FH3A+FR5,-76,31,1
 LWWW U3CP3B+FR1,-169,-58,1
 .long 0
#Yokozuna
 LWWW Y3FL3W+FR1,57,25,0
 LWWW Y3FL3W+FR2,28,17,0
 LWWW Y3FL3W+FR3,-15,22,0
 LWWW Y3FL3W+FR4,-36,36,0
 LWWW Y3FL3W+FR6,-39,37,0
 LWWW Y3FL3W+FR7,-74,24,0
 LWWW Y3FD3A+FR7,-132,-40,0
 .long 0
#Shawn
 LWWW S3OS3X+FR4,26,20,1
 LWWW S3OS3X+FR5,5,11,1
 LWWW S3OS3X+FR6,-4,41,1
 LWWW S3OS3X+FR7,-26,51,1
 LWWW S3OS3X+FR8,-26,51,1
 LWWW S3OS3X+FR9,-84,34,1
 LWWW S3OS3X+FR10,-142,-54,1
 .long 0
#BamBam
 LWWW B4TD3B+FR2,39,9,0
 LWWW B4TD3B+FR3,21,12,0
 LWWW B4TD3B+FR4,6,12,0
 LWWW B4TD3B+FR6,-18,57,0
 LWWW B4TD3B+FR7,-38,38,0
 LWWW B4TD3B+FR8,-69,13,0
 LWWW B4TD3B+FR9,-121,-49,0
 .long 0
#Doink
 LWWW D3PM4C+FR2,37,20,0
 LWWW D3OS3A+FR1,31,11,0
 LWWW D3OS3A+FR3,-7,6,0
 LWWW D3OS3A+FR4,-25,28,0
 LWWW D3OS3A+FR6,-28,25,0
 LWWW D3FD3E+FR2,-67,0,0
 LWWW D3SA3A+FR2,-143,-61,1
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
 LWWW L3CP3X+FR1,-167,-59,1
 .long 0


#*****************************************************************************
*
* SLIDING ELBOW

 SUBR	lex_combo_sliding_elbow_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

	WL	6,L4BZ3C+FR1

	.word	ANI_CLR_BUTCOUNT
	;max ticks,velocity,max z,tgt,xoff,yoff,zoff
	WWLWWWWW ANI_SLIDEATOPP,18,090000h,80,TGT_CHEST,76,64,0
	.word	ANI_FRICTION,4000h

	WL	2,L4BZ3C+FR2
	WL	2,L4BZ3C+FR3
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,0,40,60,36
	WWL	ANI_WAITHITOPP,12,L4BZ3C+FR4
	.word	ANI_ATTACK_OFF

	.word	ANI_ZEROVELS

	WL	ANI_IFNOTSTATUS,#missed

	WL	2,L4BZ3C+FR4
	;impact!
	.word	ANI_ATTACK_ON,AMODE_KICK,0,40,70,36
	WL	3,L4BZ3C+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

	.word	ANI_INC_COMBO
	.word	ANI_SHAKER,35

	WLLL	ANI_SETOPPVELS,30000h,40000h,0h		;x,y,z vels
	.word	ANI_DETACH

	WL	6,L4BZ3C+FR5
	WL	2,L4BZ3C+FR6
	WL	2,L4BZ3C+FR7
	WL	2,L4BZ3C+FR8
	WL	2,L4BZ3C+FR9

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#no_clobber
	WL	ANI_CHANGEANIM,lex_combo_clobber_anim
#no_clobber
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#no_back
	WL	ANI_CHANGEANIM,lex_combo_backbreak_anim

#no_back
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#exit
	WL	ANI_CHANGEANIM,lex_combo_hiptoss_anim
#exit

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missed
#missedb
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	15,L4BZ3C+FR4
	WL	3,L4BZ3C+FR3
	WL	3,L4BZ3C+FR2
	WL	3,L4BZ3C+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* SLIDING ELBOW

 SUBR	lex_sliding_elbow_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUNCH,8
	WL	3,L4BZ3C+FR1

	;max ticks,velocity,max z,tgt,xoff,yoff,zoff
	WWLWWWWW ANI_SLIDEATOPP,18,090000h,80,TGT_CHEST,70,64,0
	.word	ANI_FRICTION,3000h

	WL	3,L4BZ3C+FR2
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,38-20,40,48+25,36
	WWL	ANI_WAITHITOPP,12,L4BZ3C+FR3
	.word	ANI_ATTACK_OFF

	.word	ANI_ZEROVELS

	WL	ANI_IFNOTSTATUS,#missed

	WL	2,L4BZ3C+FR4
	;impact!
	.word	ANI_ATTACK_ON,AMODE_KICK,18,40,68,36
	WL	3,L4BZ3C+FR5
	.word	ANI_ATTACK_OFF

	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker
	.word	ANI_DEBRISAT,500,2,0,40,0	;%chance, tbl index, x,y,z off

	.word	ANI_SHAKER,35

	WLLL	ANI_SETOPPVELS,50000h,40000h,0h		;x,y,z vels
	WL	12,L4BZ3C+FR5
	WL	3,L4BZ3C+FR6
	WL	3,L4BZ3C+FR7
	WL	3,L4BZ3C+FR8
	WL	3,L4BZ3C+FR9

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	15,L4BZ3C+FR4
	WL	3,L4BZ3C+FR3
	WL	3,L4BZ3C+FR2
	WL	3,L4BZ3C+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WL	15,L4BZ3C+FR4
	WL	3,L4BZ3C+FR3
	WL	3,L4BZ3C+FR2
	WL	3,L4BZ3C+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* HEADHOLD KNEE-KNEE-KNEE-VSUPLEX

 SUBR	lex_knees_to_head_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SET_RPTCOUNT,4	;3 times
	WL	2,L4NM3B+FR1
	WL	2,L4NM3B+FR2
	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2
#rpt_loop
	.word	ANI_CLR_BUTCOUNT
	WL	ANI_SET_YVEL,20000h
	WLW	ANI_SET_XVEL,0C000h,AM_FACE_REL
	.word	ANI_ATTACK_ON, AMODE_HEADKNEES,14,30,48,54
	WL	2,L4NM3B+FR3
	.word	ANI_ATTACK_OFF

	WL	3,L4NM3B+FR5
	WL	3,L4NM3B+FR6
	.word	ANI_ZEROVELS
	WL	3,L4NM3B+FR7

	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#exit
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#rpt_loop
	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#exit

	;suplex
	WL	ANI_CHANGEANIM,lex_vsuplex_anim

#exit
#exit2
	.word	ANI_DETACH

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

;#*****************************************************************************
;*
;* CHAIR STUFF
;
;	.ref	CHAIR_SWING
;
; SUBR	lex_pkup_chair_anim
;
;	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
;	.word	ANI_ZEROVELS
;	.word	ANI_SETSPEED,100h
;
;#lp
;	WL	4,L4WA4B+FR1
;	WL	4,L4WA4B+FR2
;	WL	4,L4WA4B+FR3
;	WL	4,L4WA4B+FR4
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR1,34,-6,1 ;image, x,y,zoff
;	WL	4,L4WA4B+FR5
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR1,37,22,1 ;image, x,y,zoff
;	WL	4,L4WA4B+FR6
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR2,44,67,1 ;image, x,y,zoff
;	WL	4,L4WA4B+FR7
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR3,32,126,1 ;image, x,y,zoff
;	WL	4,L4WA4B+FR8
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR4,-1,146,1 ;image, x,y,zoff
;	WL	4,L4WA4B+FR9
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR4,1,139,1 ;image, x,y,zoff
;	WL	4,L4WA4B+FR10
;
;
;; .word ANI_SINGLESTEP
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR6,-28,141,1 ;image, x,y,zoff
;	WL	4,L4CS3A+FR2
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR6,-41,130,1 ;image, x,y,zoff
;	WL	4,L4CS3A+FR4
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR7,-8,136,1 ;image, x,y,zoff
;	WL	4,L4CS3A+FR5
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR8,63,111,1 ;image, x,y,zoff
;	WL	4,L4CS3A+FR6
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR9,58,34,1 ;image, x,y,zoff
;	WL	4,L4CS3A+FR7
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR10,43,17,1 ;image, x,y,zoff
;	WL	4,L4CS3A+FR8
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR9,78,61,1 ;image, x,y,zoff
;	WL	4,L4CS3A+FR9
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR8,53,122,1 ;image, x,y,zoff
;	WL	4,L4CS3A+FR10
;
;; .word ANI_SINGLESTEP
;	WLW	ANI_ATTCHIMAGE,0,0
;
;	WL	ANI_GOTO,#lp


******************************************************************************

	.end

