**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		5/18/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"yokseq3.asm"
	.title	"Yokozuna animation sequences"
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

	.ref	PCNT

	;BRET
	.ref	hrt_3_head_held_anim
	.ref	H3GU4A,H3DU3A,H3BF3A

	;BAM BAM
	.ref	bam_3_head_held_anim
	.ref	B3GU4A,B3BF3C

	;DOINK
	.ref	dnk_3_head_held_anim
	.ref	D3HT3Z,D3BF3A,D4SK4A

	;LEX
	.ref	lex_3_head_held_anim
	.ref	L3DU3A,L3BF3B

	;RAZOR
	.ref	rzr_3_head_held_anim
	.ref	R3GU4A,R3DU3B,R3BF3A

	;SHAWN
	.ref	shn_3_head_held_anim
	.ref	S3GU4A,S3BF3A

	;TAKER
	.ref	und_3_head_held_anim
	.ref	U3DU3B,U4BF3Z

	;YOKO
	.ref	yok_stand4_anim,yok_dizzy_anim
	.ref	Y3GU2A,Y3BF3A


	;MISC
	.ref	CALL_MISSES,set_position,set_skeleton_pal,am_I_dizzy
	.ref	start_smoke,set_my_pal,make_norm,DO_GRUNT,make_white
	.ref	DO_NONO,DO_OTHERNONO,FIND_AND_KILL_ENDLESS,SPIN_SWEAT
	.ref	slaveanim_tbl,target_whoihit,MOVE_NAME_ANNC

	.ref	CALL_MISS_YOKO,DO_WAIL,CALL_SPECIAL_MOVE,CALL_NASTY_MOVE
	.ref	CALL_THROWN_OUT
	.ref	slaveanim_tbl,clear_opp_counts

	.ref	hrt_slambounce_anim
	.ref	rzr_slambounce_anim
	.ref	und_slambounce_anim
	.ref	yok_slambounce_anim
	.ref	shn_slambounce_anim
	.ref	bam_slambounce_anim
	.ref	dnk_slambounce_anim
	.ref	und_slambounce_anim
	.ref	lex_slambounce_anim
	.ref	yok_combo_knee_anim
	.ref	DO_COMBO_MESS
	.ref	yok_combo_butt_drop_anim
	.ref	yok_combo_uppercut_anim
	.ref	yok_combo_gut_push_anim
	.ref	yok_combo_slap_anim

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* GET BUZZED FROM DOINK

 SUBR	yok_get_buzz_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;	.word	ANI_XFLIP
	.word	ANI_GRAVITY_OFF

	WL	ANI_CODE,set_position

	WL	ANI_CODE,set_skeleton_pal
	WL	2,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,Y4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	ANI_CODE,make_white
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_norm
	WL	ANI_CODE,set_my_pal
	WL	3,Y4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,Y4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_white
	WL	3,Y4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,Y4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,Y4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	ANI_CODE,make_white
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_norm
	WL	ANI_CODE,set_my_pal
	WL	3,Y4BZ4A+FR1

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
	WL	3,Y4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,Y4BZ4A+FR1
	WL	ANI_CODE,#make_black
	WL	3,Y4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,Y4BZ4A+FR1
	WL	ANI_CODE,#make_black
	WL	3,Y4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,Y4BZ4A+FR1

	.word	ANI_WAITHITGND
	.word	ANI_XFLIP
	.word	ANI_FACEDOWN
	.word	ANI_OFFSET,-20,0,0			;x,y,z

	WL	1,Y4ST4Y+FR4
	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	.ref	yok_fall_back_anim

	WL	ANI_CHANGEANIM,yok_fall_back_anim
;	.word	ANI_END

#nodead

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#make_black

;This is a black color within the wrestler's pal.  It is different for each
;wrestler.
	movi	0f0fh,a14

	move	a14,*a13(OBJ_CONST)
	move	*a13(OBJ_CONTROL),a14
	andni	01111b,a14
	ori	M_CONNON,a14
	move	a14,*a13(OBJ_CONTROL)
	rets

#*****************************************************************************

 SUBR	yok_3_head_held_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_HEADHELD

	.word	ANI_SETWORD,USR_VAR1,0		;loop count

#loop
	WL	4,Y3BF3A+FR1
	WL	4,Y3BF3A+FR3
	WL	4,Y3BF3A+FR5
	WL	4,Y3BF3A+FR7
	WL	4,Y3BF3A+FR9
	WL	4,Y3BF3A+FR11
	WL	ANI_CODE,#inc_loop
	WL	ANI_IFNOTSTATUS,#loop

;Continue into break...

 SUBR	yok_3_head_held_brk_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	ANI_CODE,FIND_AND_KILL_ENDLESS

	WLW	ANI_SET_XVEL,-38000h,AM_NEWFACE_REL
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	WL	4,Y3LB3A+FR9
	.word	ANI_DETACH

;Standard #2 head hit from spin kick
	WL	3,Y2AH2A+FR1
	WL	3,Y2AH2A+FR2
	WL	3,Y2AH2A+FR3
	WL	1,Y2AH2A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	4,Y2AH2A+FR5
	WL	4,Y2AH2A+FR6
	WL	4,Y2AH2A+FR7

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

 SUBR	yok_3_head_held_stand_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	4,Y3LB3A+FR9
	WL	3,Y1TT5Z+FR2	;2.5
	.word	ANI_DETACH

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


	
;#*****************************************************************************
;*
;* This one is special.  If shawn tries a frankensteiner on yoko, it backfires
;* and he ends up falling off.  To keep this smooth, we have to turn yoko into
;* the attacker.  jump here.
;*
;
; SUBR	yok_frnk_backfire_anim
;
;	.word	ANI_ZEROVELS
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
;
;	.word	ANI_ATTACHZ,0,0,10
;	WL	ANI_CODE,CALL_MISS_YOKO
;
;	WWLLW	ANI_SUPERSLAVE2,8,Y1TT5Z+FR2,#puppet_tbl,0
;	WWLLW	ANI_SUPERSLAVE2,4,Y1TT5Z+FR2,#puppet_tbl,1
;	WWLLW	ANI_SUPERSLAVE2,4,Y1TT5Z+FR2,#puppet_tbl,2
;	WWLLW	ANI_SUPERSLAVE2,4,Y1TT5Z+FR2,#puppet_tbl,3
;	WWLLW	ANI_SUPERSLAVE2,4,Y1TT5Z+FR2,#puppet_tbl,4
;
;	;let go
;;	.word	ANI_OPP_GETUP,TSEC
;	WL	ANI_SLAVEANIM,#drop_table
;	.word	ANI_DETACH
;
;	;wind down
;	WL	4,Y1TT5Z+FR3
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_SETPLYRMODE,MODE_NORMAL
;	.word	ANI_END
;
;#puppet_tbl
; .long #Bret
; .long #Razor
; .long #Taker
; .long #Yokozuna
; .long #Shawn
; .long #BamBam
; .long #Doink
; .long #Adam
; .long #Lex
;#Shawn
; LWWW S3ZI3A+FR3,-5,30,0
; LWWW S3ZI3A+FR4,1,31,0
; LWWW S3ZI3A+FR5,2,15,0
; LWWW S3ZI3A+FR6,0,20,0
; LWWW S3ZI3A+FR7,-5,-12,0
;#Bret
;#Razor
;#Taker
;#Yokozuna
;#BamBam
;#Doink
;#Adam
;#Lex
; .long 0
;
;#drop_table
;	.long	0,0,0,0
;	.long	shn_frnk_backfire_anim,0,0,0,0
;
#******************************************************************************

 SUBR	yok_2_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	1,Y1TT5Z+FR2
	WL	1,Y1TT5Z+FR3

 SUBR	yok_4_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	2,Y4WS4A+FR1

	LEAPATOPP 7,999,80,80,30000h,TGT_HEAD,26,0,10
	WL	3,Y4WS4A+FR2
	WL	4,Y4WS4A+FR3
	.word	ANI_ZERO_XZVELS

	.word	ANI_ATTACK_ON, AMODE_PUPPET2,15,0,35,22 ;mode,x,y,w,h
	WL	4,Y4WS4A+FR4
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;got him
	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2
	.word	ANI_CLR_BUTCOUNT
	WL	ANI_CODE,clear_opp_counts
	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	WL	ANI_CODE,DO_NONO
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SOUND,98h			;neck break (5-7 ticks late)

	WWLLW	ANI_SUPERSLAVE2,3,Y4WS4A+FR4,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,Y4WS4A+FR5,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,Y4WS4A+FR6,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,Y4WS4A+FR7,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,Y4WS4A+FR8,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,Y4GH3C+FR9,#puppet_tbl,5

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	1,Y4GH3C+FR9
	.word	ANI_CLROPPMODE,MODE_GHOST

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
	WL	20,Y4WS4A+FR4
	WL	3,Y4WS4A+FR3
	WL	3,Y4WS4A+FR2
	WL	3,Y4WS4A+FR1


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
 LWWW H3GU4A+FR1,38,-46,0
 LWWW H3GU4A+FR3,59,-40,0
 LWWW H3DU3A+FR3,52,-31,1
 LWWW H3DU3A+FR4,57,-22,1
 LWWW H3DU3A+FR5,55,-32,1
 LWWW H3BF3A+FR1,61,-33,0
 .long 0
#Razor
 LWWW R3GU2A+FR3,41,-37,0
 LWWW R3GU4A+FR3,53,-33,0
 LWWW R3GU4A+FR5,53,-34,0
 LWWW R3DU3B+FR2,52,-36,1
 LWWW R3DU3B+FR4,56,-32,1
 LWWW R3BF3A+FR1,59,-34,0
 .long 0
#Taker
 LWWW U3DU3B+FR2,46,-38,1
 LWWW U3DU3B+FR5,53,-30,1
 LWWW U3DU3B+FR6,57,-28,1
 LWWW U3DU3B+FR8,47,-25,1
 LWWW U3DU3B+FR10,55,-24,1
 LWWW U4BF3Z+FR5,61,-14,0
 .long 0
#Yokozuna
 LWWW Y3GU2A+FR1,47,-32,0
 LWWW Y3GU2A+FR2,56,-25,0
 LWWW Y3GU2A+FR6,40,-32,0
 LWWW Y3GU2A+FR8,46,-30,0
 LWWW Y3GU2A+FR11,60,-29,0
 LWWW Y3BF3A+FR1,60,-23,0
 .long 0
#Shawn
 LWWW S3GU2A+FR1,47,-40,0
 LWWW S3GU4A+FR2,53,-32,0
 LWWW S3GU4A+FR4,55,-36,0
 LWWW S3GU4A+FR6,57,-24,0
 LWWW S3GU4A+FR7,59,-34,0
 LWWW S3BF3A+FR1,48,-34,0
 .long 0
#BamBam
 LWWW B3GU4A+FR3,46,-36,0
 LWWW B3GU4A+FR4,53,-34,0
 LWWW B3GU4A+FR5,59,-33,0
 LWWW B3GU4A+FR7,50,-31,0
 LWWW B3GU4A+FR10,49,-32,0
 LWWW B3BF3C+FR5,61,-27,0
 .long 0
#Doink
 LWWW D3GU4A+FR2,49,-43,0
 LWWW D3GU4A+FR4,49,-41,0
 LWWW D3GU4A+FR5,41,-27,0
 LWWW D3GU4A+FR6,47,-30,0
 LWWW D3GU4A+FR7,57,-42,0
 LWWW D3BF3A+FR2,56,-33,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3GU4A+FR1,48,-40,0
 LWWW L3DU3A+FR4,33,-29,1
 LWWW L3DU3A+FR6,35,-31,1
 LWWW L3DU3A+FR7,41,-27,1
 LWWW L3DU3A+FR9,56,-34,1
 LWWW L3BF3B+FR5,56,-30,0
 .long 0


#******************************************************************************

 SUBR	yok_4_taunt_anim

	.word	ANI_SETMODE,MODE_UNINT
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	4,Y4CO4D+FR1
	WL	4,Y4CO4D+FR2

	WL	4,Y4CO4D+FR3
	WL	4,Y4CO4D+FR4
	WL	4,Y4CO4D+FR5
	WL	4,Y4CO4D+FR6
	WL	4,Y4CO4D+FR7
	WL	4,Y4CO4D+FR8

	WL	4,Y4CO4D+FR3
	WL	4,Y4CO4D+FR4
	WL	4,Y4CO4D+FR5
	WL	4,Y4CO4D+FR6
	WL	4,Y4CO4D+FR7
	WL	4,Y4CO4D+FR8

	WL	4,Y4CO4D+FR1

;	.ref	set_taunt_bit
;	WL	ANI_CODE,set_taunt_bit

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,yok_stand4_anim
;	.word	ANI_END

#*****************************************************************************
*
* HELD OVERHEAD ANIMATION

 SUBR	yok_heldoh_anim

	.word	ANI_SETPLYRMODE,MODE_ATTACHED
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_SETSPEED,100h

	.word	ANI_SETWORD,USR_VAR1,0		;loop count
	WL	ANI_CODE,DO_OTHERNONO

#loop

	WL	4,Y3MF3B+FR1
	WL	4,Y3MF3B+FR2
	WL	4,Y3MF3B+FR3
	WL	4,Y3MF3B+FR4
	WL	4,Y3MF3B+FR5
	WL	4,Y3MF3B+FR6
	WL	4,Y3MF3B+FR7

	WL	ANI_CODE,#inc_loop
	WL	ANI_IFNOTSTATUS,#loop

;Fall out of overhead hold by reversing thru pickup frames
	.word	ANI_DETACH

 
	.word	ANI_SETMODE,MODE_NORMAL|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_INAIR
	WL	ANI_CODE,FIND_AND_KILL_ENDLESS

	WL	ANI_SET_YVEL,10000h
	WLW	ANI_SET_XVEL,-40000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,10000h,AM_ABS
	.word	ANI_FRICTION,3000h

	WL	2,Y3MF3B+FR7
	.word	ANI_OFFSET,-20,-50,0			;x,y,z
	WL	4,Y3MS3Z+FR4
	WL	4,Y3MS3Z+FR3
	WL	4,Y3MS3Z+FR2
	WL	4,Y3MS3Z+FR1
	.word	ANI_WAITHITGND
	WL	2,Y2ST2Z+FR4

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

 SUBR	yok_break_neck2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,50000h
	WLW	ANI_SET_ZVEL,8000h,AM_ABS
	.word	ANI_SHAKER,50

	.ref	ckzpos
	WL	ANI_CODE,ckzpos
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim

	.word	ANI_XFLIP
	WL	3,Y3FD3N+FR5
	WL	8,Y3FD3N+FR6
	WL	3,Y3FD3N+FR7
	WL	3,Y3FD3N+FR8
	.word	ANI_WAITHITGND
	.ref	HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim



	.word	ANI_OFFSET,-20,0,0



	.word	ANI_ZEROVELS

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	3,Y3KF3B+FR1		
	WL	3,Y3KF3B+FR2		
	WL	3,Y3KF3B+FR3		
	WL	3,Y3KF3B+FR4		
	WL	3,Y3KF3B+FR5		
	WL	3,Y3KF3B+FR6		

	WL	3,Y3KF3B+FR6		
	.word	ANI_WAITROLL
	.ref	yok_faceup_getup_anim

	WL	ANI_CHANGEANIM,yok_faceup_getup_anim
;	.word	ANI_END

 SUBR	yok_break_neck3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,58000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	.ref	ckzpos
	WL	ANI_CODE,ckzpos

	.word	ANI_DEBRIS,150,5,0,-5,0	;%chance, tbl index, x,y,z off

	WL 	15,Y4POGO+FR4
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim

	.word	ANI_XFLIP
	WL	3,Y3FD3N+FR4
	WL	3,Y3FD3N+FR5
	WL	8,Y3FD3N+FR6
	WL	3,Y3FD3N+FR7
	WL	3,Y3FD3N+FR8
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_OFFSET,-20,0,0
	.word	ANI_ZEROVELS

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	3,Y3KF3B+FR1		
	WL	3,Y3KF3B+FR2		
	WL	3,Y3KF3B+FR3		
	WL	3,Y3KF3B+FR4		
	WL	3,Y3KF3B+FR5		
	WL	3,Y3KF3B+FR6		

	WL	3,Y3KF3B+FR6		
	.word	ANI_WAITROLL

	WL	ANI_CHANGEANIM,yok_faceup_getup_anim
;	.word	ANI_END

#*****************************************************************************
*
* THROWN FROM RING (shn_bslm, shn_frnk)

 SUBR	yok_flyout_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETSPEED,100h

	WWL	ANI_SETLONG,OBJ_GRAVITY,0f000h
	.word	ANI_SET_IDIOT
	WL	ANI_CODE,DO_WAIL


	WL	6,Y3FL3W+FR4
	WL	6,Y3FL3W+FR5
#cont	WL	6,Y3FL3W+FR6
	WL	6,Y3FL3W+FR7
	.word	ANI_WAITHITGND
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,60

	.word	ANI_DAMAGE,D_HIPTOSS

;	.word	ANI_SETWORD,DELAY_METER,0
;	.word	ANI_GETUP,500

	.word	ANI_OFFSET,10,0,0
	WL	3,Y3FD3A+FR7
	.word	ANI_XFLIP
	.ref	yok_hitonground_anim
	WL	ANI_CHANGEANIM,yok_hitonground_anim

 SUBR	yok_flyout2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETSPEED,100h

	WWL	ANI_SETLONG,OBJ_GRAVITY,0E000h
	.word	ANI_SET_IDIOT
	WL	ANI_CODE,DO_WAIL
	WL	ANI_GOTO,#cont

;FIX!!  Make throw out of ring if close to ropes
#*****************************************************************************
*
* FLIP/FALL FROM HIPTOSS

 SUBR	yok_tossed_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

	.word	ANI_XFLIP

	WL	ANI_CODE,ckzpos

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_SET_IDIOT
	.word	ANI_GETUP,STAY_TIME
	WL	ANI_CODE,HIT_THE_MAT
	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,50000h
	.word	ANI_OFFSET,15,0,0	;x,y,z
	WL	4,Y3CP3B+FR1
	WL	4,Y3CP3B+FR2
	WL	4,Y3CP3B+FR3
	WL	4,Y3CP3B+FR4
	WL	4,Y3CP3B+FR5
	WL	4,Y3CP3B+FR6
	.word	ANI_ZEROVELS
	WL	4,Y3CP3B+FR7
	WL	4,Y3CP3B+FR8

	.word	ANI_WAITHITGND
	.ref	SMALL_BOUNCE
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,Y3RL1A+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,yok_faceup_getup_anim
;	.word	ANI_END

;FIX!!  Make throw out of ring if close to ropes
#*****************************************************************************
*
* FLIP/FALL FROM BAM BAM DUCK TOSS

 SUBR	yok_tossed2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim

	WL	ANI_CODE,ckzpos

	WLW	ANI_SET_XVEL,60000h,AM_HIT_REL
	WL	ANI_SET_YVEL,30000h
	.word	ANI_OFFSET,-20,20,0			;x,y,z
	WL	4,Y3FL3W+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_GETUP,STAY_TIME
	.word	ANI_DAMAGE,D_HIPTOSS

	WL	4,Y3FL3W+FR7
	WL	3,Y3FD3A+FR7

	.word	ANI_XFLIP

	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,50000h
	.word	ANI_OFFSET,15,0,0	;x,y,z
	WL	4,Y3CP3B+FR1
	WL	4,Y3CP3B+FR2
	WL	4,Y3CP3B+FR3
	WL	4,Y3CP3B+FR4
	WL	4,Y3CP3B+FR5
	WL	4,Y3CP3B+FR6
	.word	ANI_ZEROVELS
	WL	4,Y3CP3B+FR7
	WL	4,Y3CP3B+FR8

	.word	ANI_WAITHITGND
	.ref	SMALL_BOUNCE
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	1,Y3RL1A+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,yok_faceup_getup_anim
;	.word	ANI_END

#*****************************************************************************

	.bss	#opp_xvel,32

 SUBR	yok_3_fake_hold_anim
;Head hold when standing next to player
;No collisions possible
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold

	.word	ANI_STARTATTACK,AT_PUPPET,6
	WL	3,Y4GH3C+FR2
	WL	3,Y4GH3C+FR3

	WL	7,Y4GH3C+FR4
	WL	ANI_GOTO,#missed

 SUBR	yok_3_head_hold2_anim
;Head hold when standing next to player
;No collisions possible
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold

	.word	ANI_STARTATTACK,AT_PUPPET,6
	WL	3,Y4GH3C+FR2
	WL	3,Y4GH3C+FR3

	.word	ANI_ATTACK_ON, AMODE_PUPPET_HDGRAB,40-40,80,37+60,23 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,7,Y4GH3C+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb
	WL	ANI_GOTO,#gothim

 SUBR	yok_3_head_hold_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold
	.word	ANI_STARTATTACK,AT_PUPPET,6

	WL	2,Y4GH3C+FR2
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 6,999,76,45,90000h,TGT_HEAD,46,105,0
	LEAPATOPP 9,999,40,45,90000h,TGT_HEAD,46,105,0
	WL	3,Y4GH3C+FR3

	.word	ANI_ATTACK_ON, AMODE_PUPPET,40-40,80,37+40,23 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,6,Y4GH3C+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb
#gothim
;got him
	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2
	.word	ANI_SETWORD,USR_VAR2,0

	.word	ANI_CLR_BUTCOUNT
	.ref	head_grab_time
	WL	ANI_CODE,head_grab_time

	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	WL	ANI_CODE,DO_NONO
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,1,Y4GH3C+FR5,#puppet_tbl,0

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WWLLW	ANI_SUPERSLAVE2,4,Y4GH3C+FR5,#puppet_tbl,0

	WWLLW	ANI_SUPERSLAVE2,4,Y4GH3C+FR7,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,Y4GH3C+FR8,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,Y4GH3C+FR9,#puppet_tbl,3

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	1,Y4GH3C+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	.word	ANI_ZEROVELS
	WL	ANI_SET_YVEL,30000h

	WL	ANI_CODE,CALL_MISSES

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,Y4GH3C+FR4
	WL	3,Y4GH3C+FR3
	WL	3,Y4GH3C+FR2

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,Y4GH3C+FR4
	WL	3,Y4GH3C+FR3
	WL	3,Y4GH3C+FR2

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
 LWWW H4AH3A+FR1,56,5,0
 LWWW H3HB3A+FR3,60,0,0
 LWWW H3HB3A+FR2,59,-5,0
 LWWW H3BF3A+FR1,59,-33,0
 .long 0
#Razor
 LWWW R4AH4C+FR3,59,4,0
 LWWW R3HB3A+FR3,63,0,0
 LWWW R3HB3A+FR2,68,-15,0
 LWWW R3BF3A+FR1,66,-35,0
 .long 0
#Taker
 LWWW U4AH3A+FR2,51,14,0
 LWWW U4BF3A+FR2,57,12,0
 LWWW U4BF3A+FR3,38,-2,0
 LWWW U4BF3Z+FR5,62,-14,0
 .long 0
#Yokozuna
 LWWW Y4AE4A+FR2,71,-5,0
 LWWW Y4AM4A+FR1,76,1,0
 LWWW Y4AM4A+FR2,73,-4,0
 LWWW Y3BF3A+FR1,65,-23,0
 .long 0
#Shawn
 LWWW S4AH3D+FR5,53,-4,0
 LWWW S4AH3D+FR1,51,6,0
 LWWW S4BF3A+FR2,62,-7,0
 LWWW S3BF3A+FR1,51,-34,0
 .long 0
#BamBam
 LWWW B4AH4A+FR1,48,-1,0
 LWWW B4BF3A+FR1,72,11,0
 LWWW B3HB3A+FR2,63,-18,0
 LWWW B3BF3C+FR5,63,-27,0
 .long 0
#Doink
 LWWW D3AH3B+FR1,51,1,0
 LWWW D3AK3A+FR3,51,10,0
 LWWW D3AK3A+FR2,65,-5,0
 LWWW D3BF3A+FR2,60,-33,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L4AH4B+FR3,50,-3,0
 LWWW L3BF3A+FR1,62,7,1
 LWWW L3BF3A+FR2,64,-8,1
 LWWW L3BF3B+FR5,60,-31,0
 .long 0

	.ref	rzr_3_head_held_anim
	.ref	bam_3_head_held_anim
	.ref	und_3_head_held_anim
;	.ref	yok_3_head_held_anim
	.ref	hrt_3_head_held_anim
	.ref	lex_3_head_held_anim
	.ref	shn_3_head_held_anim

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
* VERTICAL SUPLEX

 SUBR	yok_vsuplex_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP


	;make sure we're attached - needed for the reversal
	.word	ANI_ATTACK_ON,AMODE_PUPPET,10,48,56,36
	WWL	ANI_WAITHITOPP,3,Y4SU4A+FR1
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;got him
	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2
	.word	ANI_SOUND,82h			;Effort grunt

	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

;	WL	ANI_SLAVEANIM,slaveanim_tbl
;	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	.word	ANI_SETOPPMODE,MODE_GHOST

	WWLLW	ANI_SUPERSLAVE2,4,Y4SU4A+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,Y4SU4A+FR2,#puppet_tbl,1

	WL	ANI_SET_YVEL,38000h
	WWLLW	ANI_SUPERSLAVE2,4,Y4SU4A+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,Y4SU4A+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,Y4SU4B+FR1,#puppet_tbl,4
	.word	ANI_WAITHITGND
	.word	ANI_SHAKER,25
	WL	ANI_CODE,HIT_THE_MAT
	WWLLW	ANI_SUPERSLAVE2,12,Y4SU4B+FR1,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,28,Y4SU4B+FR2,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,3,Y4SU4B+FR3,#puppet_tbl,6
;	.word	ANI_OFFSET,0,45,0	;x,y,z
;	WL	ANI_SET_YVEL,030000h
;	WLW	ANI_SET_XVEL,-30000h,AM_FACE_REL
	WWLLW	ANI_SUPERSLAVE2,3,Y4SU4B+FR4,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,3,Y4SU4B+FR5,#puppet_tbl,8
	WWLLW	ANI_SUPERSLAVE2,3,Y4SU4B+FR6,#puppet_tbl,9

;	WWLLW	ANI_SUPERSLAVE2,3,Y4SU4B+FR7,#puppet_tbl,10
;	.word	ANI_WAITHITGND

	.word	ANI_ZEROVELS

	.word	ANI_DRAW_NAME,42
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,45

	.word	ANI_DAMAGEOPP,D_HIPTOSS,RD_HIPTOSS
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	WWLLW	ANI_SUPERSLAVE2,3,Y4SU4B+FR7,#puppet_tbl,10
	WWLLW	ANI_SUPERSLAVE2,2,Y4SU4B+FR8,#puppet_tbl,11
	WWLLW	ANI_SUPERSLAVE2,2,Y4SU4B+FR9,#puppet_tbl,12

	WL	ANI_XFLIP_TBL,#xflip_tbl
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	WL	ANI_SLAVEANIM,#breakneck_tbl
	WL	ANI_OPPOFFSET,#release_table
	WLLL	ANI_SETOPPVELS,-20000h,70000h,0		;x,y,z vels

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_DETACH

	WL	15,Y4SU4B+FR10

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,yok_faceup_getup2_anim

#missed
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#release_table
	;	X Y
	.word	-25,0		;Bret
	.word	0,0		;Razor
	.word	0,0		;Taker
	.word	0,0		;Yokozuna
	.word	0,0		;Shawn
	.word	0,0		;BamBam
	.word	0,0		;Doink
	.word	0,0		;Adam
	.word	0,0		;Lex

#xflip_tbl
	.word	1 ;bret
	.word	1 ;razor
	.word	1 ;taker
	.word	1 ;yoko
	.word	1 ;shawn
	.word	1 ;bam
	.word	1 ;doink
	.word	0 ;spare
	.word	1 ;lex

	.ref	hrt_break_neck2_anim
	.ref	rzr_break_neck2_anim
	.ref	und_break_neck2_anim
	.ref	shn_break_neck2_anim
	.ref	bam_break_neck2_anim
	.ref	dnk_break_neck2_anim
	.ref	lex_break_neck2_anim

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
 LWWW H3PP3X+FR1,23,-30,0
 LWWW H3PP3X+FR2,20,16,0
 LWWW H3PP3X+FR4,21,38,0
 LWWW H3PP3X+FR5,22,53,0
 LWWW H3PP3X+FR6,16,63,0
 LWWW H3PP3X+FR6,15,63,0
 LWWW H3PP3X+FR6,13,64,0
 LWWW H3PP3X+FR6,9,70,0
 LWWW H3PP3X+FR6,10,68,0
 LWWW H3PP3X+FR6,2,73,0
 LWWW H3PP3X+FR6,-13,78,0
 LWWW H3PP3X+FR7,-42,14,0
 LWWW H3PP3X+FR8,-42,-7,0
 .long 0
#Razor
 LWWW R3GP3Z+FR1,22,-31,0
 LWWW R3GP3Z+FR2,27,-16,0
 LWWW R3GP3Z+FR4,34,38,0
 LWWW R3GP3Z+FR5,27,49,0
 LWWW R3GP3Z+FR5,30,56,0
 LWWW R3GP3Z+FR5,30,56,0
 LWWW R3GP3Z+FR6,26,58,0
 LWWW R3GP3Z+FR6,27,62,0
 LWWW R3GP3Z+FR6,27,61,0
 LWWW R3GP3Z+FR6,19,71,0
 LWWW R3GP3Z+FR6,6,77,0
 LWWW R3GP3Z+FR7,-33,25,0
 LWWW R3GP3Z+FR8,-34,-16,0
 .long 0
#Taker
 LWWW U3PP3X+FR1,30,-24,1
 LWWW U3PP3X+FR3,26,-7,1
 LWWW U3PP3X+FR4,19,7,1
 LWWW U3PP3X+FR5,25,38,1
 LWWW U3PP3X+FR6,30,68,1
 LWWW U3PP3X+FR6,29,68,1
 LWWW U3PP3X+FR6,25,71,1
 LWWW U3PP3X+FR6,26,77,1
 LWWW U3PP3X+FR6,24,76,1
 LWWW U3PP3X+FR6,15,82,1
 LWWW U3PP3X+FR6,-4,87,1
 LWWW U3GP3X+FR1,-33,8,1
 LWWW U3GP3X+FR2,-25,-18,1
 .long 0
#Yokozuna
 LWWW Y3PP3Q+FR1,24,-20,0
 LWWW Y3PP3Q+FR2,26,-9,0
 LWWW Y3PP3Q+FR3,27,-6,0
 LWWW Y3PP3Q+FR4,26,-1,0
 LWWW Y3PP3Q+FR6,22,28,0
 LWWW Y3PP3Q+FR7,21,34,0
 LWWW Y3PP3Q+FR7,15,41,0
 LWWW Y3PP3Q+FR7,12,47,0
 LWWW Y3PP3Q+FR7,13,44,0
 LWWW Y3PP3Q+FR7,3,52,0
 LWWW Y3PP3Q+FR7,-11,61,0
 LWWW Y3FD3N+FR3,-45,1,0
 LWWW Y3FD3N+FR4,-35,15,0
 .long 0
#Shawn
 LWWW S3GP3X+FR1,32,-28,0
 LWWW S3GP3X+FR2,29,-12,0
 LWWW S3GP3X+FR3,27,3,0
 LWWW S3GP3X+FR4,25,39,0
 LWWW S3GP3X+FR5,31,55,0
 LWWW S3GP3X+FR5,30,55,0
 LWWW S3OS3X+FR8,24,52,1
 LWWW S3OS3X+FR8,24,53,1
 LWWW S3OS3X+FR8,24,47,1
 LWWW S3OS3X+FR8,16,53,1
 LWWW S3OS3X+FR8,-2,58,1
 LWWW S3FD3X+FR2,-32,19,0
 LWWW S3GP3X+FR6,-29,-10,0
 .long 0
#BamBam
 LWWW B3PP3Q+FR1,24,-31,0
 LWWW B3PP3Q+FR2,27,-11,0
 LWWW B3PP3Q+FR3,31,6,0
 LWWW B3PP3Q+FR4,30,33,0
 LWWW B3PP3Q+FR5,30,57,0
 LWWW B3PP3Q+FR5,29,57,0
 LWWW B3PP3Q+FR6,14,65,0
 LWWW B3PP3Q+FR6,14,65,0
 LWWW B3PP3Q+FR6,10,61,0
 LWWW B3PP3Q+FR6,1,68,0
 LWWW B3PP3Q+FR6,-16,80,0
 LWWW B3PP3Q+FR7,-48,20,0
 LWWW B3FD3C+FR1,-49,-5,0
 .long 0
#Doink
 LWWW D3PD3Z+FR1,29,-38,1
 LWWW D3PD3Z+FR2,32,-9,1
 LWWW D3PD3Z+FR3,29,13,1
 LWWW D3PD3Z+FR5,19,55,1
 LWWW D3PD3Z+FR5,22,62,1
 LWWW D3PD3Z+FR5,21,62,1
 LWWW D3PD3Z+FR6,27,53,1
 LWWW D3PD3Z+FR6,28,58,1
 LWWW D3PD3Z+FR6,24,57,1
 LWWW D3PD3Z+FR6,14,62,1
 LWWW D3PD3Z+FR6,-2,65,1
 LWWW D3PD3Z+FR8,-36,2,1
 LWWW D3PD3Z+FR9,-30,-19,1
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3GP3Z+FR1,28,-28,0
 LWWW L3GP3Z+FR2,31,-10,0
 LWWW L3GP3Z+FR3,30,-5,0
 LWWW L3GP3Z+FR5,28,27,0
 LWWW L3GP3Z+FR6,28,50,0
 LWWW L3GP3Z+FR6,27,50,0
 LWWW L3GP3Z+FR6,22,54,0
 LWWW L3GP3Z+FR6,22,56,0
 LWWW L3GP3Z+FR6,22,50,0
 LWWW L3GP3Z+FR6,14,56,0
 LWWW L3GP3Z+FR6,0,64,0
 LWWW L3FH3A+FR6,-37,16,0
 LWWW L3FD3B+FR1,-29,-11,0
 .long 0


#*****************************************************************************
*
* HIPTOSS

 SUBR	yok_combo_hiptoss_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,8

	.word	ANI_SET_RPTCOUNT,3
#slam_loop
	.word	ANI_CLR_BUTCOUNT

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 12,100,100,35,90000h,TGT_CHEST,39,73,0
	WL	ANI_SET_YVEL,0h

	WL	3,Y4LZ3A+FR1

	.word	ANI_ATTACK_ON, AMODE_PUPPET,0,44,80,52 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,Y4LZ3A+FR1
	.word	ANI_ZERO_XZVELS
	WWL	ANI_WAITHITOPP,3,Y4LZ3A+FR1
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missedc
	WL	ANI_IFBLOCKED,#missedbc
;got him
	WL	ANI_CODE,DO_GRUNT

	.word	ANI_ATTACHZ,0,0,-2		;put opp behind attacker

	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,2,Y4LZ3A+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,Y4LZ3A+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,2,Y4LZ3A+FR3,#puppet_tbl,2
	.word	ANI_FACE,MOVE_LEFT|MOVE_DOWN
	WWWL	ANI_IFROPE,RC_FRONT,XTOSSDIST_CLOSE,#throw_him_outc
	WWLLW	ANI_SUPERSLAVE2,3,Y4LZ3A+FR4,#puppet_tbl,3
	.word	ANI_OFFSET,0,50,0	;x,y,z
	WWLLW	ANI_SUPERSLAVE2,2,Y4LZ3A+FR5,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,Y4LZ3A+FR6,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,2,Y4LZ3A+FR7,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,3,Y4LZ3A+FR8,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,2,Y4LZ3A+FR9,#puppet_tbl,8

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,60
	.word	ANI_OPP_GETUP,-30

	.word	ANI_DAMAGEOPP,D_HIPTOSS,RD_HIPTOSS

	WL	ANI_XFLIP_TBL,#xflip_tbl
	.word	ANI_CLROPPMODE,MODE_GHOST
	WL	ANI_SLAVEANIM,SLAM_HIM
	WLLL	ANI_SETOPPVELS,0,090000h,0000h		;x,y,z vels
	.word	ANI_DETACH

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	WL	4,Y4LZ3A+FR9
	.word	ANI_XFLIP

	.ref	yok_faceup_getup2_anim
;	WL	ANI_CHANGEANIM,yok_faceup_getup2_anim

	WL	2,Y3GU2A+FR4
;	WL	2,Y3GU2A+FR5
	WL	2,Y3GU2A+FR6
	WL	2,Y3GU2A+FR7
	WL	2,Y3GU2A+FR8
;	WL	2,Y3GU2A+FR9
	WL	2,Y3GU2A+FR10
	WL	2,Y3GU2A+FR11
	WL	2,Y3GU2A+FR12

	WL	2,Y3GU4A+FR13
	WL	2,Y3GU4A+FR14
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	1,Y3GU4A+FR14

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#NO_REPEAT
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#slam_loop

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#NO_REPEAT
	WL	ANI_CHANGEANIM,yok_combo_spinslam_anim
	
#NO_REPEAT
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedbc
	WL	10,Y4LZ3A+FR1
#missedc
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_CODE,CALL_MISSES
	WL	15,Y4LZ3A+FR1
	.word	ANI_SETMODE,MODE_NORMAL
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


*******************************************

 SUBR	yok_4_hiptoss2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,6

;Rotate into 2 dir
;	WL	2,Y1TT5Z+FR3
;	WL	2,Y1TT5Z+FR2

 SUBR	yok_2_hiptoss2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.WORD	ANI_ADD_MOVE,MOVE_C_1,2,2
	.word	ANI_STARTATTACK,AT_PUPPET,3
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 7,65,60,40,90000h,TGT_CHEST,20,0,0
	WL	ANI_SET_YVEL,0h

	WL	3,Y4LZ3A+FR1

	.word	ANI_ATTACK_ON, AMODE_PUPPET_TOSS,33,36,44,48 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,8,Y4LZ3A+FR1
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACK_OFF

	WL	ANI_GOTO,#cont

 SUBR	yok_4_hiptoss_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,7
;Rotate into 2 dir
;	WL	2,Y1TT5Z+FR3
;	WL	2,Y1TT5Z+FR2

 SUBR	yok_2_hiptoss_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,10
	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,50,30,40,90000h,TGT_CHEST,39,73,0
	WL	ANI_SET_YVEL,0h

	WL	4,Y4LZ3A+FR1

	.word	ANI_ATTACK_ON, AMODE_PUPPET_TOSS,0,44,52-8,52 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,Y4LZ3A+FR1
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACK_OFF
	WL	4,Y4LZ3A+FR1

#cont
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb
#got_him
	WL	ANI_CODE,DO_GRUNT

	.word	ANI_DRAW_NAME,26
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	.word	ANI_ATTACHZ,0,0,-2		;put opp behind attacker
;	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.

	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,2,Y4LZ3A+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,Y4LZ3A+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,Y4LZ3A+FR3,#puppet_tbl,2
	.word	ANI_FACE,MOVE_LEFT|MOVE_DOWN
	WWLLW	ANI_SUPERSLAVE2,2,Y4LZ3A+FR4,#puppet_tbl,3
	WWWL	ANI_IFROPE,RC_FRONT,XTOSSDIST_CLOSE,#throw_him_out
	.word	ANI_OFFSET,0,50,0	;x,y,z
;	WL	ANI_SET_YVEL,02000h
	WWLLW	ANI_SUPERSLAVE2,4,Y4LZ3A+FR5,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,Y4LZ3A+FR6,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,4,Y4LZ3A+FR7,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,4,Y4LZ3A+FR8,#puppet_tbl,7

;	.word	ANI_WAITHITGND
;	.word	ANI_ZEROVELS

	WWLLW	ANI_SUPERSLAVE2,4,Y4LZ3A+FR9,#puppet_tbl,8

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,60
	.word	ANI_OPP_GETUP,300

	.word	ANI_DAMAGEOPP,D_HIPTOSS,RD_HIPTOSS

	WL	ANI_XFLIP_TBL,#xflip_tbl
	.word	ANI_CLROPPMODE,MODE_GHOST
	WL	ANI_SLAVEANIM,#slambounce_tbl
	WLLL	ANI_SETOPPVELS,20000h,40000h,00000h	;x,y,z vels
	.word	ANI_DETACH

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	WL	3,Y4LZ3A+FR9
	.word	ANI_XFLIP
	.ref	yok_faceup_getup2_anim
	WL	ANI_CHANGEANIM,yok_faceup_getup2_anim

#missedb
;	.ref	ck_hiptoss
;	WL	ANI_CODE,ck_hiptoss
;	WL	ANI_IFNOTSTATUS,#got_him

	WL	10,Y4LZ3A+FR1
;Delay longer if 2nd hiptoss in quick succession!
	.ref	hiptoss_delay
	WL	ANI_CODE,hiptoss_delay
	WL	ANI_IFNOTSTATUS,#missed
	WL	24,Y4LZ3A+FR1
#missed
	WL	ANI_CODE,CALL_MISSES
	WL	8,Y4LZ3A+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#throw_him_out
	WL	ANI_CODE,CALL_THROWN_OUT
	WLLL	ANI_ATTACHVEL,080000h,90000h,0h		;x,y,z
	WL	ANI_SLAVEANIM,#flyout_tbl
	WL	ANI_OPPOFFSET,#release_table
	.word	ANI_DETACH
	WL	3,Y4LZ3A+FR4
	.word	ANI_OFFSET,0,50,0	;x,y,z
	WL	ANI_SET_YVEL,02000h
	WL	3,Y4LZ3A+FR5
	WL	3,Y4LZ3A+FR6
	WL	3,Y4LZ3A+FR7
	WL	3,Y4LZ3A+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,20

	WL	3,Y4LZ3A+FR9
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	WL	3,Y4LZ3A+FR9

	.word	ANI_XFLIP
	.ref	yok_faceup_getup2_anim
	WL	ANI_CHANGEANIM,yok_faceup_getup2_anim

#xflip_tbl
	.word	0 ;bret
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
 LWWW H2AH3A+FR5,37,5,0
 LWWW H3FR3A+FR1,16,-1,0
 LWWW H3MS3Z+FR1,-8,8,0
 LWWW H3PP3X+FR1,14,-15,1
 LWWW H3FR3A+FR2,40,2,1
 LWWW H3FR3A+FR3,29,28,1
 LWWW H3FR3A+FR4,16,37,1
 LWWW H3FR3A+FR5,-8,38,1
 LWWW H2CP3A+FR8,-115,-13,0
 .long 0
#Razor
 LWWW R4AM4B+FR2,39,6,0
 LWWW R3TD3A+FR1,15,17,0
 LWWW R3TD3A+FR3,-9,-6,0
 LWWW R3TD3A+FR4,9,-1,1
 LWWW R3TD3A+FR5,51,16,1
 LWWW R3TD3A+FR6,49,37,1
 LWWW R3TD3A+FR7,26,58,1
 LWWW R3TD3A+FR8,-1,59,1
 LWWW R3GU2A+FR1,-110,-9,0
 .long 0
#Taker
 LWWW U3AE4A+FR1,36,17,0
 LWWW U4AM4C+FR4,14,8,0
 LWWW U3FH3A+FR1,12,-13,1
 LWWW U3FH3A+FR2,16,3,0
 LWWW U3FH3A+FR3,41,17,0
 LWWW U3FH3A+FR4,32,40,0
 LWWW U3FH3A+FR5,10,60,0
 LWWW U3FH3A+FR5,-6,60,0
 LWWW U3CP3B+FR1,-120,-7,0
 .long 0
#Yokozuna
 LWWW Y4AE4A+FR1,46,5,0
 LWWW Y3FL3W+FR1,16,16,0
 LWWW Y3FL3W+FR2,-5,1,0
 LWWW Y3FL3W+FR3,-1,3,1
 LWWW Y3FL3W+FR4,30,22,1
 LWWW Y3FL3W+FR5,28,36,1
 LWWW Y3FL3W+FR6,2,43,1
 LWWW Y3FL3W+FR7,-21,45,1
 LWWW Y3FD3A+FR7,-93,13,1
 .long 0
#Shawn
 LWWW S3OS3X+FR2,24,5,1
 LWWW S3OS3X+FR3,14,17,1
 LWWW S3OS3X+FR4,-13,-3,1
 LWWW S3OS3X+FR5,-3,-5,0
 LWWW S3OS3X+FR6,35,32,0
 LWWW S3OS3X+FR7,45,53,0
 LWWW S3OS3X+FR8,35,62,0
 LWWW S3OS3X+FR9,-14,59,0
 LWWW S3OS3X+FR10,-90,-2,0
 .long 0
#BamBam
 LWWW B4AM4A+FR2,38,13,0
 LWWW B4AM4A+FR3,22,15,0
 LWWW B4TD3B+FR3,-9,-1,0
 LWWW B4TD3B+FR4,18,-1,1
 LWWW B4TD3B+FR5,41,32,1
 LWWW B4TD3B+FR6,41,56,1
 LWWW B4TD3B+FR7,19,57,1
 LWWW B4TD3B+FR8,-6,57,1
 LWWW B4TD3B+FR9,-77,6,1
 .long 0
#Doink
 LWWW D3AH3B+FR2,21,-2,0
 LWWW D3PM4C+FR2,-6,18,0
 LWWW D3OS3A+FR1,2,0,0
 LWWW D3OS3A+FR2,10,-2,1
 LWWW D3OS3A+FR3,31,9,1
 LWWW D3OS3A+FR4,33,24,1
 LWWW D3OS3A+FR5,28,32,1
 LWWW D3OS3A+FR6,2,44,1
 LWWW D3SA3A+FR9,-112,-8,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L4AM4B+FR2,42,-1,0
 LWWW L3FH3A+FR1,7,11,0
 LWWW L3FH3A+FR2,-3,-13,0
 LWWW L3FH3A+FR3,12,4,1
 LWWW L3FH3A+FR4,45,18,1
 LWWW L3FH3A+FR5,41,28,1
 LWWW L3FH3A+FR6,21,50,1
 LWWW L3FH3A+FR6,3,48,1
 LWWW L3CP3B+FR1,-116,-9,0
 .long 0

#release_table
	;	X Y
	.word	0,38		;Bret
	.word	0,10		;Razor
	.word	0,10		;Taker
	.word	0,15		;Yokozuna
	.word	0,10		;Shawn
	.word	0,50		;BamBam
	.word	0,0		;Doink
	.word	0,0		;Adam
	.word	0,10		;Lex

#flyout_tbl
	.REF	hrt_flyout_anim
	.REF	rzr_flyout_anim
	.REF	und_flyout_anim
	.REF	shn_flyout_anim
	.REF	bam_flyout_anim
	.REF	dnk_flyout_anim
	.REF	lex_flyout_anim

	.long	hrt_flyout_anim
	.long	rzr_flyout_anim
	.long	und_flyout_anim
	.long	yok_flyout_anim
	.long	shn_flyout_anim
	.long	bam_flyout_anim
	.long	dnk_flyout_anim
	.long	0
	.long	lex_flyout_anim

#*****************************************************************************
*
* HELD HEADBUTT

****************************************************************************
 SUBR	yok_combo_heldheadbutt_rpt_anim

 	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_CLR_BUTCOUNT

	.word	ANI_STARTATTACK,AT_PUPPET,6
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	WL	2,Y4CD3A+FR1
	.word	ANI_ATTACK_ON, AMODE_PUPPET,33,36,64,48 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,Y4CD3A+FR2
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missedc
	WL	ANI_IFBLOCKED,#missedbc		;Yes, I hit blocker

	.word	ANI_ATTACHZ,0,0,-2	;put opp behind attacker
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,7,Y4CD3A+FR2,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,Y4CD3A+FR4,#puppet_tbl,1

	.word	ANI_SET_RPTCOUNT,4
#loopc
	WWLLW	ANI_SUPERSLAVE2,3,Y4CD3A+FR7,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,1,Y4CD3A+FR8,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,1,Y4CD3A+FR9,#puppet_tbl,4

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IFNOT_RPTCOUNT,#last_hitc
	.word	ANI_CLR_BUTCOUNT

	.word	ANI_DEBRISAT,100,2,0,100,0	;%chance, tbl index, x,y,z off
	WL	ANI_CODE,impact_sound
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,25
	.word	ANI_DAMAGEOPP,D_HDBUTT2,RD_HDBUTT2
	.WORD	ANI_INC_COMBO
	WL	3,Y4CD3A+FR9
	WWLLW	ANI_SUPERSLAVE2,2,Y4CD3Z+FR2,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,1,Y4CD3Z+FR1,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,2,Y4CD3A+FR8,#puppet_tbl,7
	WL	ANI_GOTO,#loopc
#last_hitc
	WL	ANI_CODE,impact_sound
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,25
	.word	ANI_DAMAGEOPP,D_HDBUTT,RD_HDBUTT
	.word	ANI_DEBRISAT,100,1,0,8,0	;%chance,tbl index,x,y,z off

	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#NO_KNEE
	WL	ANI_CHANGEANIM,yok_combo_knee_anim
#NO_KNEE
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#NO_UPPER
	WL	ANI_CHANGEANIM,yok_combo_uppercut_anim
#NO_UPPER
	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#NO_HIPTOSS
	WL	ANI_CHANGEANIM,yok_combo_hiptoss_anim
#NO_HIPTOSS
	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#NO_GUT
	WL	ANI_CHANGEANIM,yok_combo_gut_push_anim
#NO_GUT
	WL	ANI_SLAVEANIM,#head_hit2_tbl
	WL	7,Y4CD3A+FR9
	WL	4,Y4CD3Z+FR1
	WL	5,Y4ST4Y+FR4

	.WORD	ANI_DETACH
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedbc
	WL	10,Y4CD3A+FR2
#missedc
	.WORD	ANI_DETACH
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	10,Y4CD3A+FR2
	WL	4,Y4CD3A+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END
****************************************************************************

 SUBR	yok_heldheadbutt_rpt_anim

 	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_CLR_BUTCOUNT

	.word	ANI_STARTATTACK,AT_PUPPET,2
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	WL	2,Y4CD3A+FR1
	.word	ANI_ATTACK_ON, AMODE_PUPPET_NOFLAIL,33,56,44,18 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,Y4CD3A+FR2
	.word	ANI_ATTACK_OFF

	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

	.word	ANI_ATTACHZ,0,0,-2	;put opp behind attacker
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,10,Y4CD3A+FR2,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,Y4CD3A+FR4,#puppet_tbl,1

	.word	ANI_SET_RPTCOUNT,4
#loop
	WWLLW	ANI_SUPERSLAVE2,5,Y4CD3A+FR7,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,2,Y4CD3A+FR8,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,1,Y4CD3A+FR9,#puppet_tbl,4

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#last_hit
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IFNOT_RPTCOUNT,#last_hit
	.word	ANI_CLR_BUTCOUNT

	.word	ANI_DEBRISAT,100,2,0,100,0	;%chance, tbl index, x,y,z off
	WL	ANI_CODE,impact_sound
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,25
	.word	ANI_DAMAGEOPP,D_HDBUTT2,RD_HDBUTT2
	WL	3,Y4CD3A+FR9
	WWLLW	ANI_SUPERSLAVE2,2,Y4CD3Z+FR2,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,2,Y4CD3Z+FR1,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,2,Y4CD3A+FR8,#puppet_tbl,7
	WL	ANI_GOTO,#loop

#last_hit
	WL	ANI_CODE,CALL_SPECIAL_MOVE
	WL	ANI_CODE,impact_sound
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,25
	.word	ANI_DAMAGEOPP,D_HDBUTT,RD_HDBUTT
	.word	ANI_DEBRISAT,100,1,0,8,0	;%chance,tbl index,x,y,z off

;	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	WL	ANI_SLAVEANIM,#head_hit2_tbl
	WLLL	ANI_SETOPPVELS,30000h,60000h,10000h	;x,y,z vels
	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WL	7,Y4CD3A+FR9
	WL	4,Y4CD3Z+FR1
	WL	5,Y4ST4Y+FR4

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	impact_sound

	WRSNDX	HDBUTT_L1,HDBUTT_L2

	move	*a13(ATTACH_PROC),a0,L
	jrz	#x
	WRSNDX	a0,RUGSLAM_YELL,RUGSLAM_IMPACT
#x	rets


#missedb
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit
#no_hit	WLLL	ANI_SETOPPVELS,60000h,18000h,0h		;x,y,z vels
	WL	8,Y4CD3A+FR2
#missed
	WL	8,Y4CD3A+FR2
	WL	4,Y4CD3A+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

	.ref	hrt_fall_back_anim
	.ref	rzr_fall_back_anim
	.ref	und_fall_back_anim
	.ref	shn_fall_back_anim
	.ref	bam_fall_back_anim
	.ref	dnk_fall_back_anim
	.ref	lex_fall_back_anim

;A fall down is cooler from this head butt

#head_hit2_tbl

	.long	hrt_fall_back_anim	;0 Bret Hart
	.long	rzr_fall_back_anim	;1 Razor Ramon
	.long	und_fall_back_anim	;2 Undertaker
	.long	yok_fall_back_anim	;3 Yokozuna
	.long	shn_fall_back_anim	;4 Shawn Michaels
	.long	bam_fall_back_anim	;5 Bam Bam
	.long	dnk_fall_back_anim	;6 Doink
	.long	0		  	;7 spare
	.long	lex_fall_back_anim	;8 Lex Luger

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
 LWWW H4AH3A+FR4,38,-1,0
 LWWW H4AH3A+FR5,48,6,0
 LWWW H4AH3A+FR5,46,3,0
 LWWW H4AH3A+FR6,56,-3,0
 LWWW H4AH3A+FR1,56,6,0
 LWWW H4AH3A+FR2,48,11,0
 LWWW H4AH3A+FR3,63,6,0
 LWWW H4AH3A+FR4,54,-5,0
 .long 0
#Razor
 LWWW R4AH4C+FR5,39,2,0
 LWWW R4AH4C+FR6,48,5,0
 LWWW R4AH4C+FR7,46,5,0
 LWWW R4AH4C+FR8,55,2,0
 LWWW R4AH4C+FR3,54,3,0
 LWWW R4AH4C+FR4,46,9,0
 LWWW R4AH4C+FR5,61,4,0
 LWWW R4AH4C+FR6,54,-1,0
 .long 0
#Taker
 LWWW U4AH3A+FR2,28,19,0
 LWWW U4AH3A+FR4,31,16,0
 LWWW U4AH3A+FR5,40,7,0
 LWWW U4AH3A+FR6,48,-1,0
 LWWW U4AH3A+FR2,42,15,0
 LWWW U4AH3A+FR3,30,31,0
 LWWW U4AH3A+FR4,44,16,0
 LWWW U4AH3A+FR5,49,4,0
 .long 0
#Yokozuna
 LWWW Y4AH4A+FR4,30,-6,0
 LWWW Y4AH4A+FR5,40,1,0
 LWWW Y4AH4A+FR5,38,-2,0
 LWWW Y4AH4A+FR6,46,0,0
 LWWW Y4AH4A+FR1,57,-2,0
 LWWW Y4AH4A+FR2,47,6,0
 LWWW Y4AH4A+FR3,55,-7,0
 LWWW Y4AH4A+FR4,45,-10,0
 .long 0
#Shawn
 LWWW S4AH3D+FR2,42,-5,0
 LWWW S4AH3D+FR3,53,-6,0
 LWWW S4AH3D+FR5,53,-2,0
 LWWW S4AH3D+FR6,61,-2,0
 LWWW S4AH3D+FR1,53,-4,0
 LWWW S4AH3D+FR2,50,2,0
 LWWW S4AH3D+FR3,66,-6,0
 LWWW S4AH3D+FR4,60,-12,0
 .long 0
#BamBam
 LWWW B4AH4A+FR2,27,-4,0
 LWWW B4AH4A+FR3,36,-2,0
 LWWW B4AH4A+FR4,35,-4,0
 LWWW B4AH4A+FR5,45,-4,0
 LWWW B4AH4A+FR6,39,-3,0
 LWWW B4AH4A+FR1,36,11,0
 LWWW B4AH4A+FR2,49,-2,0
 LWWW B4AH4A+FR3,42,-8,0
 .long 0
#Doink
 LWWW D3AH3B+FR3,31,-7,0
 LWWW D3AH3B+FR5,42,1,0
 LWWW D3AH3B+FR5,40,-2,0
 LWWW D3AM3A+FR1,53,-13,0
 LWWW D3AH3B+FR1,38,1,0
 LWWW D3AH3B+FR2,34,0,0
 LWWW D3AH3B+FR3,53,-5,0
 LWWW D3AH3B+FR5,49,-5,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L4AH4A+FR3,38,-1,0
 LWWW L4AH4A+FR4,48,3,0
 LWWW L4AH4A+FR5,46,3,0
 LWWW L4AH4A+FR6,55,1,0
 LWWW L4AH4A+FR1,53,-2,0
 LWWW L4AH4A+FR2,42,6,0
 LWWW L4AH4A+FR3,60,1,0
 LWWW L4AH4A+FR4,54,-3,0
 .long 0

#*****************************************************************************
*
* SPIN & SLAM
***************************************************************

;do_next_bit
;	.WORD	ANI_PAUSE,22     
;	WL	ANI_CHANGEANIM,yok_combo_slap_anim

 SUBR	yok_combo_spinslam_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_IFOPP,W_DOINK,-1
	WL	ANI_IFSTATUS,#NO_BUTTa	;do_next_bit
	.word	ANI_IFOPP,W_RAZOR,-1
	WL	ANI_IFSTATUS,#NO_BUTTa	;do_next_bit

	.WORD	ANI_SET_ATTACH
	.word	ANI_ATTACHZ,0,0,2	;put opp in front of attacker
	WL	ANI_SLAVEANIM,slaveanim_tbl
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	.word	ANI_SETOPPMODE,MODE_GHOST

	.word	ANI_SET_RPTCOUNT,3
;*** start of spin sequence
#spin_loop
	.word	ANI_CLR_BUTCOUNT
	.word	ANI_ATTACHZ,0,0,-2	;put opp behind attacker
	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,0,2,0
	WWLLW	ANI_SUPERSLAVE2,2,Y4HT3Z+FR1,#puppet_tbl,4

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,1,2,0
	WWLLW	ANI_SUPERSLAVE2,1,Y5JS5A+FR3,#puppet_tbl,5

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,2,1,0
	WWLLW	ANI_SUPERSLAVE2,1,Y5JS5A+FR2,#puppet_tbl,6

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,3,0,0
	WWLLW	ANI_SUPERSLAVE2,1,Y5JS5A+FR1,#puppet_tbl,7

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,4,0,0
	WWLLW	ANI_SUPERSLAVE2,1,Y5JS5F+FR2,#puppet_tbl,8

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,5,1,0
	WWLLW	ANI_SUPERSLAVE2,1,Y5JS5F+FR3,#puppet_tbl,9

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,6,2,0
	WWLLW	ANI_SUPERSLAVE2,1,Y5JS5F+FR4,#puppet_tbl,10
	.word	ANI_ATTACHZ,0,0,2	;put opp in front of attacker

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,7,2,0
	WWLLW	ANI_SUPERSLAVE2,2,Y5JS5F+FR5,#puppet_tbl,11

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,8,1,0
	WWLLW	ANI_SUPERSLAVE2,1,Y5JS5F+FR6,#puppet_tbl,12

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,9,0,0
	WWLLW	ANI_SUPERSLAVE2,2,Y5JS5A+FR6,#puppet_tbl,13

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,10,0,0
	WWLLW	ANI_SUPERSLAVE2,1,Y5JS5A+FR5,#puppet_tbl,14
;*** end of spin sequence
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#spin_loop

	.word	ANI_ATTACHZ,0,0,-2	;put opp behind attacker
	WWLLW	ANI_SUPERSLAVE2,2,Y5JS5A+FR4,#puppet_tbl,15
	WWLLW	ANI_SUPERSLAVE2,2,Y3GS3A+FR2,#puppet_tbl,16
	WWLLW	ANI_SUPERSLAVE2,2,Y3GS3A+FR3,#puppet_tbl,17

	WWLLW	ANI_SUPERSLAVE2,2,Y4OT3A+FR1,#puppet_tbl,18
	WWLLW	ANI_SUPERSLAVE2,2,Y4OT3A+FR2,#puppet_tbl,19
	WWLLW	ANI_SUPERSLAVE2,2,Y4OT3A+FR3,#puppet_tbl,20
	WWLLW	ANI_SUPERSLAVE2,2,Y4OT3A+FR4,#puppet_tbl,21
	WWLLW	ANI_SUPERSLAVE2,3,Y4OT3A+FR5,#puppet_tbl,22
	.word	ANI_ATTACHZ,0,0,2	;put opp in front of attacker
	WWLLW	ANI_SUPERSLAVE2,3,Y4OT3A+FR6,#puppet_tbl,23

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,45

	.word	ANI_DAMAGEOPP,D_HIPTOSS,RD_HIPTOSS
	.word	ANI_INC_COMBO

	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,SLAM_HIM
	WLLL	ANI_SETOPPVELS,0,090000h,0000h		;x,y,z vels
	.word	ANI_DETACH

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	WL	3,Y4OT3A+FR6
	WL	3,Y4OT3A+FR7
	WL	3,Y4OT3A+FR8

	.word	ANI_FACE,MOVE_LEFT|MOVE_DOWN
	.word	ANI_XFLIP
	WL	1,Y4ST4Y+FR4
;	.word	ANI_IMMOBILIZE,75

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#NO_SLAP
	WL	ANI_CHANGEANIM,yok_combo_slap_anim
#NO_SLAP

	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#NO_BUTT
	WL	ANI_CHANGEANIM,yok_combo_butt_drop_anim

#NO_BUTT
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#NO_BUTTa
	WL	ANI_CODE,#set_immob
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#set_immob
	PUSH	a9
	move	*a13(WHOIHIT),a9,L
	CREATE0	#keep_ongrnd
	PULL	a9
	rets

#keep_ongrnd
	SLEEPK	10
;Yoko will elbow drop this guy
	movi	60,a0
	move	a0,*a9(IMMOBILIZE_TIME)
	DIE

***************************************************************

 SUBR	yok_spinslam_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_ZEROVELS
	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2
	.word	ANI_SETSPEED,100h

	.word	ANI_IFOPP,W_DOINK,-1
	WL	ANI_IFSTATUS,yok_overhd_slam_anim
	.word	ANI_IFOPP,W_RAZOR,-1
	WL	ANI_IFSTATUS,yok_overhd_slam_anim

	.word	ANI_ATTACHZ,0,0,2	;put opp in front of attacker
	WL	ANI_SLAVEANIM,slaveanim_tbl
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	.word	ANI_SETOPPMODE,MODE_GHOST

	.ref	MAKE_HIM_SCREAM
	WL	ANI_CODE,MAKE_HIM_SCREAM

	WWLLW	ANI_SUPERSLAVE2,3,Y4OT3F+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,Y4OT3F+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,Y4OT3F+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,Y4OT3F+FR4,#puppet_tbl,3

	WL	ANI_CODE,CALL_SPECIAL_MOVE
;*** start of spin sequence
	.word	ANI_ATTACHZ,0,0,-2	;put opp behind attacker

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,0,2,0
	WWLLW	ANI_SUPERSLAVE2,2,Y4HT3Z+FR1,#puppet_tbl,4

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,1,2,0
	WWLLW	ANI_SUPERSLAVE2,1,Y5JS5A+FR3,#puppet_tbl,5

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,2,1,0
	WWLLW	ANI_SUPERSLAVE2,1,Y5JS5A+FR2,#puppet_tbl,6

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,3,0,0
	WWLLW	ANI_SUPERSLAVE2,1,Y5JS5A+FR1,#puppet_tbl,7

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,4,0,0
	WWLLW	ANI_SUPERSLAVE2,1,Y5JS5F+FR2,#puppet_tbl,8

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,5,1,0
	WWLLW	ANI_SUPERSLAVE2,1,Y5JS5F+FR3,#puppet_tbl,9

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,6,2,0
	WWLLW	ANI_SUPERSLAVE2,2,Y5JS5F+FR4,#puppet_tbl,10

	.word	ANI_ATTACHZ,0,0,2	;put opp in front of attacker
	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,7,2,0
	WWLLW	ANI_SUPERSLAVE2,2,Y5JS5F+FR5,#puppet_tbl,11

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,8,1,0
	WWLLW	ANI_SUPERSLAVE2,2,Y5JS5F+FR6,#puppet_tbl,12

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,9,0,0
	WWLLW	ANI_SUPERSLAVE2,2,Y5JS5A+FR6,#puppet_tbl,13

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,10,0,0
	WWLLW	ANI_SUPERSLAVE2,2,Y5JS5A+FR5,#puppet_tbl,14
;*** end of spin sequence
;*** start of spin sequence
	WL	ANI_CODE,MAKE_HIM_SCREAM
	.word	ANI_ATTACHZ,0,0,-2	;put opp behind attacker
	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,0,2,0
	WWLLW	ANI_SUPERSLAVE2,2,Y4HT3Z+FR1,#puppet_tbl,4

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,1,1,0
	WWLLW	ANI_SUPERSLAVE2,1,Y5JS5A+FR3,#puppet_tbl,5

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,2,0,0
	WWLLW	ANI_SUPERSLAVE2,1,Y5JS5A+FR2,#puppet_tbl,6

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,3,0,0
	WWLLW	ANI_SUPERSLAVE2,1,Y5JS5A+FR1,#puppet_tbl,7

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,4,0,0
	WWLLW	ANI_SUPERSLAVE2,1,Y5JS5F+FR2,#puppet_tbl,8

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,5,1,0
	WWLLW	ANI_SUPERSLAVE2,1,Y5JS5F+FR3,#puppet_tbl,9

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,6,2,0
	WWLLW	ANI_SUPERSLAVE2,2,Y5JS5F+FR4,#puppet_tbl,10

	.word	ANI_ATTACHZ,0,0,2	;put opp in front of attacker
	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,7,1,0
	WWLLW	ANI_SUPERSLAVE2,2,Y5JS5F+FR5,#puppet_tbl,11

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,8,1,0
	WWLLW	ANI_SUPERSLAVE2,2,Y5JS5F+FR6,#puppet_tbl,12

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,9,0,0
	WWLLW	ANI_SUPERSLAVE2,2,Y5JS5A+FR6,#puppet_tbl,13

	WLWWWW	ANI_CREATEPROC,SPIN_SWEAT,0,10,0,0
	WWLLW	ANI_SUPERSLAVE2,2,Y5JS5A+FR5,#puppet_tbl,14
;*** end of spin sequence

	.word	ANI_ATTACHZ,0,0,-2	;put opp behind attacker
	WWLLW	ANI_SUPERSLAVE2,2,Y5JS5A+FR4,#puppet_tbl,15
	WWLLW	ANI_SUPERSLAVE2,2,Y3GS3A+FR2,#puppet_tbl,16
	WWLLW	ANI_SUPERSLAVE2,2,Y3GS3A+FR3,#puppet_tbl,17

;	WWWL	ANI_IFNOTROPE,RC_FRONT,200,#no_flip2
;	.word	ANI_XFLIP
;	.word	ANI_XFLIP_OPP
;#no_flip2

	WWLLW	ANI_SUPERSLAVE2,2,Y4OT3A+FR1,#puppet_tbl,18
	WWLLW	ANI_SUPERSLAVE2,2,Y4OT3A+FR2,#puppet_tbl,19
	WWLLW	ANI_SUPERSLAVE2,2,Y4OT3A+FR3,#puppet_tbl,20
	WWLLW	ANI_SUPERSLAVE2,2,Y4OT3A+FR4,#puppet_tbl,21
	WWLLW	ANI_SUPERSLAVE2,3,Y4OT3A+FR5,#puppet_tbl,22
	.word	ANI_ATTACHZ,0,0,2	;put opp in front of attacker
	WWLLW	ANI_SUPERSLAVE2,3,Y4OT3A+FR6,#puppet_tbl,23

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,45

	.word	ANI_DAMAGEOPP,D_PILEDRIVER,RD_PILEDRIVER

	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#slambounce_tbl
	WLLL	ANI_SETOPPVELS,-20000h,50000h,00000h	;x,y,z vels
;	WL	ANI_OPPOFFSET,#release_table
	.word	ANI_DETACH

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	WL	3,Y4OT3A+FR6
	WL	4,Y4OT3A+FR7
	WL	4,Y4OT3A+FR8

	.word	ANI_FACE,MOVE_LEFT|MOVE_DOWN
	.word	ANI_XFLIP
	WL	1,Y4ST4Y+FR4

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	yok_overhd_slam2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2
	.word	ANI_ATTACHZ,0,0,-2	;put opp behind attacker
	WL	ANI_SLAVEANIM,slaveanim_tbl
	.word	ANI_FACE,MOVE_LEFT|MOVE_DOWN
	.word	ANI_XFLIP

	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	.word	ANI_SETOPPMODE,MODE_GHOST

	.word	ANI_XFLIP_OPP
	.WORD	ANI_FACE_OPP,MOVE_RIGHT|MOVE_DOWN


	WWLLW	ANI_SUPERSLAVE2,3,Y4OT3A+FR1,#puppet_tbl,18
	WWLLW	ANI_SUPERSLAVE2,3,Y4OT3A+FR2,#puppet_tbl,19
	WWWL	ANI_IFROPE,RC_BACK,XTOSSDIST_CLOSE,#throw_him_out
	WL	ANI_GOTO,#inherex

 SUBR	yok_overhd_slam_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2
	.word	ANI_ATTACHZ,0,0,-2	;put opp behind attacker
	WL	ANI_SLAVEANIM,slaveanim_tbl
	.word	ANI_FACE,MOVE_LEFT|MOVE_DOWN
	.word	ANI_XFLIP

	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	.word	ANI_SETOPPMODE,MODE_GHOST

	.word	ANI_XFLIP_OPP
	.WORD	ANI_FACE_OPP,MOVE_RIGHT|MOVE_DOWN


	WWLLW	ANI_SUPERSLAVE2,3,Y4OT3A+FR1,#puppet_tbl,18
	WWLLW	ANI_SUPERSLAVE2,3,Y4OT3A+FR2,#puppet_tbl,19
;	WWWL	ANI_IFROPE,RC_BACK,XTOSSDIST_CLOSE,#throw_him_out
#inherex

	WWLLW	ANI_SUPERSLAVE2,3,Y4OT3A+FR3,#puppet_tbl,20
	WWLLW	ANI_SUPERSLAVE2,3,Y4OT3A+FR4,#puppet_tbl,21
	WWLLW	ANI_SUPERSLAVE2,3,Y4OT3A+FR5,#puppet_tbl,22
	.word	ANI_ATTACHZ,0,0,2	;put opp in front of attacker
	WWLLW	ANI_SUPERSLAVE2,1,Y4OT3A+FR6,#puppet_tbl,23

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,45

	.word	ANI_DAMAGEOPP,D_HIPTOSS,RD_HIPTOSS

	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#slambounce_tbl
	WLLL	ANI_SETOPPVELS,-20000h,50000h,20000h	;x,y,z vels
;	WL	ANI_OPPOFFSET,#release_table
	.word	ANI_DETACH

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	WL	3,Y4OT3A+FR6
	WL	4,Y4OT3A+FR7
	WL	4,Y4OT3A+FR8

	.word	ANI_FACE,MOVE_LEFT|MOVE_DOWN
	.word	ANI_XFLIP
	WL	1,Y4ST4Y+FR4

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#throw_him_out
	WL	ANI_CODE,CALL_THROWN_OUT
	WLLL	ANI_ATTACHVEL,-0A0000h,70000h,0h		;x,y,z
	WL	ANI_SLAVEANIM,flyout_tbl
	WL	ANI_OPPOFFSET,release_throw_table
	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2
	.word	ANI_DETACH

	WL	3,Y4OT3A+FR3
	WL	3,Y4OT3A+FR4
	WL	3,Y4OT3A+FR5
	WL	1,Y4OT3A+FR6

	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
;	.word	ANI_DAMAGEOPP,D_HIPTOSS,RD_HIPTOSS

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	WL	3,Y4OT3A+FR6
	WL	4,Y4OT3A+FR7
	WL	4,Y4OT3A+FR8
	.word	ANI_FACE,MOVE_LEFT|MOVE_DOWN
	.word	ANI_XFLIP
	WL	1,Y4ST4Y+FR4

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

	.ref	hrt_flyout_anim
	.ref	rzr_flyout_anim
	.ref	und_flyout_anim
	.ref	shn_flyout_anim
	.ref	bam_flyout_anim
	.ref	dnk_flyout_anim
	.ref	lex_flyout_anim

release_throw_table
	.word	0,0
	.word	0,0
	.word	0,0
	.word	0,0
	.word	0,0
	.word	0,0
	.word	0,0
	.word	0,0
	.word	0,0

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


;#release_table
;	;	X Y
;	.word	50,0		;Bret
;	.word	50,0		;Razor
;	.word	50,0		;Taker
;	.word	50,0		;Yokozuna
;	.word	50,0		;Shawn
;	.word	50,0		;BamBam
;	.word	50,0		;Doink
;	.word	50,0		;Adam
;	.word	50,0		;Lex

#xflip_tbl
	.word	0 ;bret
	.word	0 ;razor
	.word	0 ;taker
	.word	0 ;yoko
	.word	0 ;shawn
	.word	1 ;bam
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
 LWWW H3RS3A+FR5,-21,10,0
 LWWW H3RS3A+FR6,-10,8,0
 LWWW H3RS3A+FR6,19,-18,1
 LWWW H3RS3A+FR5,35,-18,1
 LWWW H3RS3A+FR4,34,-29,1
 LWWW H3RS3A+FR3,26,-28,1
 LWWW H3RS3A+FR2,22,-26,1
 LWWW H3RS3A+FR1,9,-22,1
 LWWW H3RS3A+FR2,-14,-25,0
 LWWW H3RS3A+FR3,-42,-28,0
 LWWW H3RS3A+FR4,-89,-32,0
 LWWW H3RS3A+FR5,-83,-39,0
 LWWW H3RS3A+FR6,-58,-38,0
 LWWW H3RS3A+FR6,9,-37,1
 LWWW H3RS3A+FR5,25,-38,1
 LWWW H3RS3A+FR4,31,-32,1
 LWWW H3RS3A+FR6,49,-21,1
 LWWW H3FR3A+FR1,39,7,0
 LWWW H3FR3A+FR2,36,23,0
 LWWW H3FR3A+FR3,26,50,0
 LWWW H3FR3A+FR4,3,51,0
 LWWW H3FR3A+FR4,-23,39,0
 LWWW H3FR3A+FR5,-64,-11,0
 LWWW H2CP3A+FR8,-144,-64,1
 .long 0
#Razor
 LWWW R3TD3A+FR4,21,21,0
 LWWW R3TD3A+FR4,21,21,0
 LWWW R3TD3A+FR4,21,21,0
 LWWW R3TD3A+FR4,21,21,0
 LWWW R3TD3A+FR4,21,21,0
 LWWW R3TD3A+FR4,21,21,0
 LWWW R3TD3A+FR4,21,21,0
 LWWW R3TD3A+FR4,21,21,0
 LWWW R3TD3A+FR4,21,21,0
 LWWW R3TD3A+FR4,21,21,0
 LWWW R3TD3A+FR4,21,21,0
 LWWW R3TD3A+FR4,21,21,0
 LWWW R3TD3A+FR4,21,21,0
 LWWW R3TD3A+FR4,21,21,0
 LWWW R3TD3A+FR4,21,21,0
 LWWW R3TD3A+FR4,21,21,0
 LWWW R3TD3A+FR4,21,21,0
 LWWW R3TD3A+FR4,21,21,0

 LWWW R3TD3A+FR4,21,21,0
 LWWW R3TD3A+FR5,26,30,0
 LWWW R3TD3A+FR6,-1,27,0
 LWWW R3TD3A+FR7,-23,38,0
 LWWW R3HG3B+FR1,-63,-13,0
 LWWW R3GU2A+FR1,-144,-59,1
 .long 0
#Taker
 LWWW U3RS3A+FR5,-49,18,0
 LWWW U3RS3A+FR6,-40,12,0
 LWWW U3RS3A+FR6,21,-14,1
 LWWW U3RS3A+FR5,49,-18,1
 LWWW U3RS3A+FR4,28,-32,1
 LWWW U3RS3A+FR3,14,-32,1
 LWWW U3RS3A+FR2,17,-28,1
 LWWW U3RS3A+FR1,9,-25,1
 LWWW U3RS3A+FR2,-60,-27,0
 LWWW U3RS3A+FR3,-101,-32,0
 LWWW U3RS3A+FR4,-129,-34,0
 LWWW U3RS3A+FR5,-109,-36,0
 LWWW U3RS3A+FR6,-82,-42,0
 LWWW U3RS3A+FR6,12,-42,1
 LWWW U3RS3A+FR5,24,-36,1
 LWWW U3RS3A+FR4,24,-35,1
 LWWW U3RS3A+FR6,62,-23,1
 LWWW U3FH3A+FR1,39,-11,1
 LWWW U3FH3A+FR1,45,12,1
 LWWW U3FH3A+FR2,26,23,1
 LWWW U3FH3A+FR3,5,15,1
 LWWW U3FH3A+FR4,-23,21,1
 LWWW U3FH3A+FR5,-65,8,1
 LWWW U3CP3B+FR1,-150,-60,1
 .long 0
#Yokozuna
 LWWW Y3RS3A+FR5,-48,22,0
 LWWW Y3RS3A+FR6,-27,20,0
 LWWW Y3RS3A+FR6,14,-1,1
 LWWW Y3RS3A+FR5,33,-6,1
 LWWW Y3RS3A+FR4,33,-24,1
 LWWW Y3RS3A+FR3,9,-23,1
 LWWW Y3RS3A+FR2,-3,-16,1
 LWWW Y3RS3A+FR1,3,-14,1
 LWWW Y3RS3A+FR2,-56,-16,0
 LWWW Y3RS3A+FR3,-103,-22,0
 LWWW Y3RS3A+FR4,-114,-26,0
 LWWW Y3RS3A+FR5,-108,-31,0
 LWWW Y3RS3A+FR6,-71,-33,0
 LWWW Y3RS3A+FR6,-3,-33,1
 LWWW Y3RS3A+FR5,17,-31,1
 LWWW Y3RS3A+FR4,23,-27,1
 LWWW Y3RS3A+FR6,45,-17,1
 LWWW Y3FL3W+FR2,25,14,0
 LWWW Y3FL3W+FR3,17,27,0
 LWWW Y3FL3W+FR4,22,34,0
 LWWW Y3FL3W+FR5,8,27,0
 LWWW Y3FL3W+FR6,-20,35,0
 LWWW Y3FL3W+FR7,-60,3,0
 LWWW Y3FD3A+FR7,-107,-35,0
 .long 0
#Shawn
 LWWW S3RS3A+FR5,-31,25,0
 LWWW S3RS3A+FR6,-6,20,0
 LWWW S3RS3A+FR6,29,-4,1
 LWWW S3RS3A+FR5,43,-9,1
 LWWW S3RS3A+FR4,38,-28,1
 LWWW S3RS3A+FR3,21,-24,1
 LWWW S3RS3A+FR2,13,-17,1
 LWWW S3RS3A+FR1,9,-16,1
 LWWW S3RS3A+FR2,-63,-18,0
 LWWW S3RS3A+FR3,-71,-24,0
 LWWW S3RS3A+FR4,-108,-31,0
 LWWW S3RS3A+FR5,-91,-31,0
 LWWW S3RS3A+FR6,-48,-34,0
 LWWW S3RS3A+FR6,12,-34,1
 LWWW S3RS3A+FR5,26,-30,1
 LWWW S3RS3A+FR4,32,-31,1
 LWWW S3RS3A+FR6,60,-20,1
 LWWW S3OS3X+FR4,-1,12,1
 LWWW S3OS3X+FR5,-4,27,1
 LWWW S3OS3X+FR6,0,53,1
 LWWW S3OS3X+FR7,-10,48,1
 LWWW S3OS3X+FR8,-11,53,1
 LWWW S3OS3X+FR9,-72,22,1
 LWWW S3OS3X+FR10,-122,-57,1
 .long 0
#BamBam
 LWWW B3RS3B+FR5,-50,24,0
 LWWW B3RS3B+FR6,-42,16,0
 LWWW B3RS3B+FR6,22,-7,1
 LWWW B3RS3B+FR5,25,-10,1
 LWWW B3RS3B+FR4,28,-28,1
 LWWW B3RS3B+FR3,22,-30,1
 LWWW B3RS3B+FR2,8,-30,1
 LWWW B3RS3B+FR1,-18,-26,1
 LWWW B3RS3B+FR2,-79,-30,0
 LWWW B3RS3B+FR3,-96,-31,0
 LWWW B3RS3B+FR4,-115,-36,0
 LWWW B3RS3B+FR5,-121,-35,0
 LWWW B3RS3B+FR6,-87,-39,0
 LWWW B3RS3B+FR6,8,-38,1
 LWWW B3RS3B+FR5,20,-33,1
 LWWW B3RS3B+FR4,26,-33,1
 LWWW B3RS3B+FR6,53,-23,1
 LWWW B4TD3B+FR3,22,3,1
 LWWW B4TD3B+FR4,37,17,0
 LWWW B4TD3B+FR5,17,47,0
 LWWW B4TD3B+FR6,-6,51,0
 LWWW B4TD3B+FR7,-29,49,0
 LWWW B4TD3B+FR8,-60,14,0
 LWWW B4TD3B+FR9,-112,-42,0
 .long 0
#Doink
 LWWW D3OS3A+FR3,12,23,0
 LWWW D3OS3A+FR3,12,23,0
 LWWW D3OS3A+FR3,12,23,0
 LWWW D3OS3A+FR3,12,23,0
 LWWW D3OS3A+FR3,12,23,0
 LWWW D3OS3A+FR3,12,23,0
 LWWW D3OS3A+FR3,12,23,0
 LWWW D3OS3A+FR3,12,23,0
 LWWW D3OS3A+FR3,12,23,0
 LWWW D3OS3A+FR3,12,23,0
 LWWW D3OS3A+FR3,12,23,0
 LWWW D3OS3A+FR3,12,23,0
 LWWW D3OS3A+FR3,12,23,0
 LWWW D3OS3A+FR3,12,23,0
 LWWW D3OS3A+FR3,12,23,0
 LWWW D3OS3A+FR3,12,23,0
 LWWW D3OS3A+FR3,12,23,0
 LWWW D3OS3A+FR3,12,23,0

 LWWW D3OS3A+FR3,12,23,0
 LWWW D3OS3A+FR4,11,28,0
 LWWW D3OS3A+FR5,-3,20,0
 LWWW D3OS3A+FR6,-19,28,0
 LWWW D3UC3A+FR9,-65,-22,0
 LWWW D3SA3A+FR9,-133,-60,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3RS3A+FR5,-33,11,0
 LWWW L3RS3A+FR6,-28,10,0
 LWWW L3RS3A+FR6,16,-16,1
 LWWW L3RS3A+FR5,37,-10,1
 LWWW L3RS3A+FR4,32,-20,1
 LWWW L3RS3A+FR3,19,-14,1
 LWWW L3RS3A+FR2,-7,-9,1
 LWWW L3RS3A+FR1,-14,-7,1
 LWWW L3RS3A+FR2,-69,-9,0
 LWWW L3RS3A+FR3,-109,-12,0
 LWWW L3RS3A+FR4,-102,-23,0
 LWWW L3RS3A+FR5,-93,-31,0
 LWWW L3RS3A+FR6,-70,-35,0
 LWWW L3RS3A+FR6,-4,-35,1
 LWWW L3RS3A+FR5,19,-31,1
 LWWW L3RS3A+FR4,30,-23,1
 LWWW L3RS3A+FR6,42,-29,1
 LWWW L3FH3A+FR2,25,-7,0
 LWWW L3FH3A+FR2,32,14,0
 LWWW L3FH3A+FR3,30,28,0
 LWWW L3FH3A+FR4,14,23,0
 LWWW L3FH3A+FR5,-5,22,0
 LWWW L3FH3A+FR6,-51,-5,0
 LWWW L3CP3B+FR1,-136,-58,1
 .long 0


#*****************************************************************************
*
* GRAB OPPONENT AND HOLD OVERHEAD

 SUBR	yok_graboh_TB_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETPLYRMODE,MODE_INAIR2
	.word	ANI_STARTATTACK,AT_PUPPET,7
	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2

	WL	2,Y4PO4X+FR1
	WL	ANI_SET_YVEL,70000h
	WLW	ANI_SET_XVEL,-18000h,AM_FACE_REL

	WL	5,Y4PO4X+FR2

	.word	ANI_ATTACK_ON, AMODE_PUPPET,8,46,65,33 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,8,Y4PO4X+FR3
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;#gothim
	WL	ANI_SET_YVEL,-20000h

	.ref	CALL_SETUP
	WL	ANI_CODE,CALL_SETUP
	.word	ANI_SOUND,82h			;Effort grunt
	.word	ANI_ATTACHZ,0,0,2	;put opp in front of attacker

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

;	WWLLW	ANI_SUPERSLAVE2,3,Y4PO4X+FR3,#puppet_tbl,0
;	WWLLW	ANI_SUPERSLAVE2,3,Y4PO4X+FR4,#puppet_tbl,1

	WWLLW	ANI_SUPERSLAVE2,3,Y4PO4X+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,Y4PO4X+FR6,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,Y4PO4X+FR7,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,Y4PO4X+FR8,#puppet_tbl,5

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,50

	WL	ANI_GOTO,#inhere

*****************************************************************************
*
* GRAB OPPONENT AND HOLD OVERHEAD

 SUBR	yok_graboh_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,7

	WL	3,Y4PO4X+FR1

	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,90,70,60,90000h,TGT_CHEST,71,64,0
	WL	ANI_SET_YVEL,20000h

	WL	5,Y4PO4X+FR2

	.word	ANI_ATTACK_ON, AMODE_PUPPET,8,46,65,33 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,5,Y4PO4X+FR2

	.word	ANI_ATTACK_OFF

	.word	ANI_ZERO_XZVELS

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb

;#gothim
	.ref	CALL_SETUP
	WL	ANI_CODE,CALL_SETUP
	.word	ANI_SOUND,82h			;Effort grunt
	.word	ANI_ATTACHZ,0,0,2	;put opp in front of attacker
	WL	ANI_CODE,DO_NONO

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,4,Y4PO4X+FR3,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,Y4PO4X+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,Y4PO4X+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,Y4PO4X+FR6,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,Y4PO4X+FR7,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,Y4PO4X+FR8,#puppet_tbl,5

#inhere
	WL	ANI_SLAVEANIM,#strt_flail_tbl

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETPLYRMODE,MODE_OPPOVERHEAD
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_END

#missedb
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	10,Y4PO4X+FR3
#missed
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	10,Y4PO4X+FR3
	WL	3,Y4PO4X+FR2
	WL	3,Y4PO4X+FR1

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_END

	.ref	hrt_heldoh_anim
	.ref	rzr_heldoh_anim
	.ref	und_heldoh_anim
	.ref	shn_heldoh_anim
	.ref	bam_heldoh_anim
	.ref	dnk_heldoh_anim
	.ref	lex_heldoh_anim

#strt_flail_tbl
	.long	hrt_heldoh_anim
	.long	rzr_heldoh_anim
	.long	und_heldoh_anim
	.long	yok_heldoh_anim
	.long	shn_heldoh_anim
	.long	bam_heldoh_anim
	.long	dnk_heldoh_anim
	.long	0
	.long	lex_heldoh_anim

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
 LWWW H4AM3A+FR1,60,10,0
 LWWW H3MS3Z+FR1,26,24,0
 LWWW H3MS3Z+FR2,31,27,0
 LWWW H3MS3Z+FR3,18,15,0
 LWWW H3MS3Z+FR4,-8,14,0
 LWWW H4MF4B+FR9,-20,19,0
 .long 0
#Razor
 LWWW R4AH4C+FR3,74,28,0
 LWWW R3MS3Z+FR1,47,11,0
 LWWW R3MS3Z+FR2,29,20,0
 LWWW R3MS3Z+FR3,10,9,0
 LWWW R3MS3Z+FR4,-11,12,0
 LWWW R4MF4B+FR9,-55,30,0
 .long 0
#Taker
 LWWW U4AH3A+FR5,64,28,0
 LWWW U4AM4C+FR1,43,22,0
 LWWW U3MS3Z+FR1,26,38,0
 LWWW U3MS3Z+FR2,-4,24,0
 LWWW U3MS3Z+FR3,-28,8,0
 LWWW U4PM3C+FR7,-38,26,0
 .long 0
#Yokozuna
 LWWW Y4AE4A+FR1,77,23,0
 LWWW Y3MS3Z+FR2,48,21,0
 LWWW Y3MS3Z+FR3,31,24,0
 LWWW Y3MS3Z+FR4,5,19,0
 LWWW Y3MS3Z+FR5,-22,20,0
 LWWW Y3MF3B+FR7,-31,23,0
 .long 0
#Shawn
 LWWW S4AH3D+FR1,70,20,0
 LWWW S3OS3X+FR3,43,17,1
 LWWW S3MS3Z+FR1,23,11,0
 LWWW S3MS3Z+FR3,-1,9,0
 LWWW S3MS3Z+FR5,-16,12,0
 LWWW S3MF3B+FR7,-34,22,0
 .long 0
#BamBam
 LWWW B4AH4A+FR1,68,22,0
 LWWW B3MS3Z+FR1,53,14,0
 LWWW B3MS3Z+FR2,35,19,0
 LWWW B3MS3Z+FR3,10,4,0
 LWWW B3MS3Z+FR4,-10,15,0
 LWWW B4MF4A+FR7,-49,37,0
 .long 0
#Doink
 LWWW D3AH3B+FR5,63,18,0
 LWWW D3GS3X+FR1,58,7,0
 LWWW D3GS3X+FR3,34,17,0
 LWWW D3GS3X+FR4,14,13,0
 LWWW D3GS3X+FR5,-7,3,0
 LWWW D4MF4A+FR9,-31,37,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L4AH4B+FR3,69,20,0
 LWWW L3MS3Z+FR1,51,15,0
 LWWW L3MS3Z+FR2,28,20,0
 LWWW L3MS3Z+FR3,3,6,0
 LWWW L3MS3Z+FR4,-17,0,0
 LWWW L3MF3B+FR7,-29,16,0
 .long 0

#*****************************************************************************
*
* YOKO SCISSOR CRUSH

	.bss	#opp_xvel,32

 SUBR	yok_combo_scissor_anim
;From head hold combo move

	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_LEAPING,12
	.word	ANI_CLR_BUTCOUNT

	WL	3,Y3JK3A+FR1
	WL	3,Y3JK3A+FR2
;first, if we're holding his head, let him go.
	WWL	ANI_IFOPPMODE,~MODE_HEADHELD,#no_hdrel2c
	.word	ANI_DETACH
#no_hdrel2c
	LEAPATOPP 10,200,200,45,90000h,TGT_GROIN,0,20,0
	.ref	no_bk_xvel
	WL	ANI_CODE,no_bk_xvel
	WL	3,Y3JK3A+FR3
	WL	3,Y3JK3A+FR4
	.word	ANI_OFFSET,0,55,0

	.word	ANI_ATTACK_ON,AMODE_PUPPET,10-36,-20,56,33 ;mode,x,y,w,h

	WL	ANI_CODE,#store_opp_xvel
	WWL	ANI_WAITHITOPP,17,Y3JK3A+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missedc
	WL	ANI_IFBLOCKED,#missedbc

	.word	ANI_CLR_STATUS
	.word	ANI_INC_COMBO

;hit
;Put in screams
	WWL	ANI_SETLONG,OBJ_GRAVITY,0c000h

	WL	ANI_SET_YVEL,50000h
	WL	ANI_CODE,#merge_xvels
	.word	ANI_ATTACHZ,0,0,-10		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	WWLLW	ANI_SUPERSLAVE2,4,Y3JK3Z+FR5,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,Y3JK3Z+FR5,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,Y3JK3Z+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,Y3JK3Z+FR5,#puppet_tbl,3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

;impact
	WWLLW	ANI_SUPERSLAVE2,4,Y3JK3A+FR6,#puppet_tbl,4
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,50
	.word	ANI_DAMAGEOPP,D_SCISSOR,RD_SCISSOR
	.word	ANI_OPP_GETUP,300
	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#recover_tbl
	.word	ANI_DETACH
       
	.word	ANI_IMMOBILIZE,25

	.WORD	ANI_INC_COMBO
	.word	ANI_BOUNCE,6

	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,-22,-10-10,-30,54,36,50
	WL	4,Y3JK3Z+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ATTACK_OFF

	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKER,35

	;skip this stuff if we missed
	WL	ANI_IFNOTSTATUS,#missed2nd
	.word	ANI_IMMOBILIZE,75
	.word	ANI_OFFSET,0,0,25			;x,y,z
	.word	ANI_OPP_GETUP,-100
#missed2nd

	WL	2,Y3JK3A+FR6
	WL	2,Y3JK3A+FR7
	WL	2,Y3JK3A+FR8
	.word	ANI_XFLIP

#do_bounce_now
	WL	2,Y3GU2A+FR4
;	WL	2,Y3GU2A+FR5
	WL	2,Y3GU2A+FR6
	WL	2,Y3GU2A+FR7
	WL	2,Y3GU2A+FR8
;	WL	2,Y3GU2A+FR9
	WL	2,Y3GU2A+FR10
	WL	2,Y3GU2A+FR11
	WL	2,Y3GU2A+FR12

	WL	2,Y3GU4A+FR13
	WL	2,Y3GU4A+FR14
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	1,Y3GU4A+FR14

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#NO_REPEAT
	WL	ANI_CHANGEANIM,yok_combo_butt_drop_anim
#NO_REPEAT
	.word	ANI_OPP_GETUP,10
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedbc
	.WORD	ANI_DETACH
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_GOTO,#missedb
#missedc
	.WORD	ANI_DETACH
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_GOTO,#missed


************************************

 SUBR	yok_scissor_anim

;From head hold combo move

	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_LEAPING,12
	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2

	WL	3,Y3JK3A+FR1
	WL	3,Y3JK3A+FR2
;first, if we're holding his head, let him go.
	WWL	ANI_IFOPPMODE,~MODE_HEADHELD,#no_hdrel2
	.word	ANI_DETACH
#no_hdrel2
	LEAPATOPP 10,80,70,45,90000h,TGT_GROIN,0,20,0
	.ref	no_bk_xvel
	WL	ANI_CODE,no_bk_xvel
	WL	3,Y3JK3A+FR3
	WL	3,Y3JK3A+FR4
	.word	ANI_OFFSET,0,55,0

	.word	ANI_ATTACK_ON,AMODE_PUPPET,10-36,-20,56,33 ;mode,x,y,w,h

	WL	ANI_CODE,#store_opp_xvel
	WWL	ANI_WAITHITOPP,10,Y3JK3A+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb

	.word	ANI_CLR_STATUS

;hit
;Put in screams
	WWL	ANI_SETLONG,OBJ_GRAVITY,0c000h

	WL	ANI_SET_YVEL,50000h
	WL	ANI_CODE,#merge_xvels
	.word	ANI_ATTACHZ,0,0,-10		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	WWLLW	ANI_SUPERSLAVE2,4,Y3JK3Z+FR5,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,Y3JK3Z+FR5,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,Y3JK3Z+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,Y3JK3Z+FR5,#puppet_tbl,3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY
	.word	ANI_DRAW_NAME,34

;impact
	.ref	create_bucket_salt
	WL	ANI_CODE,create_bucket_salt
	WWL	ANI_SETLONG,DEBRIS_X,[2,1]	;Y,X of head

	WWLLW	ANI_SUPERSLAVE2,4,Y3JK3A+FR6,#puppet_tbl,4
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,50
	.word	ANI_DAMAGEOPP,D_SCISSOR,RD_SCISSOR
	.word	ANI_OPP_GETUP,300
	WL	ANI_CODE,CALL_SPECIAL_MOVE
	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#recover_tbl
	.word	ANI_DETACH

	.word	ANI_IMMOBILIZE,35

	WWL	ANI_SETLONG,DEBRIS_X,[2,8]	;Y,X of head
	.word	ANI_BOUNCE,6
	WL	4,Y3JK3Z+FR5
	WWL	ANI_SETLONG,DEBRIS_X,0		;Y,X of head
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKER,35

	.word	ANI_OFFSET,0,0,25			;x,y,z

	WL	ANI_CODE,target_whoihit
	WL	ANI_CODE,#stop_dmg
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,-22,-10-10,-30,54,36,50
	WL	1,Y3JK3A+FR6
	.word	ANI_ATTACK_OFF
	.word	ANI_IMMOBILIZE,40
	WL	ANI_IFNOTSTATUS,#miss_bounce
#miss_bounce
	WL	2,Y3JK3A+FR6
	WL	3,Y3JK3A+FR7
	WL	3,Y3JK3A+FR8
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,yok_faceup_getup2_anim

#stop_dmg
	SPCDMG	2,35
	rets

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

#missedb
;we've hit a blocker.  mistake.
;uh, for now just abort.
	WLLL	ANI_SETOPPVELS,70000h,40000h,0	;x,y,z vels
	.word	ANI_SOUND,018h			;Hard hit
	.word	ANI_ZERO_XZVELS

	WL	ANI_SET_YVEL,20000h
	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL

	WL	17,Y3JK3Z+FR5
	WLLL	ANI_SETOPPVELS,0000h,0000h,0	;x,y,z vels

#missed
	.word	ANI_DETACH
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,45
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_BOUNCE,5
	WL	3,Y3JK3A+FR6
	WL	5,Y3JK3Z+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKER,35
	WL	4,Y3JK3A+FR6
	WL	4,Y3JK3A+FR7
	WL	4,Y3JK3A+FR8
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,yok_faceup_getup2_anim

;new xvel is (attacker xvel + defender xvel)/4
#merge_xvels

	move	@#opp_xvel,a0,L
	move	*a13(OBJ_XVEL),a1,L
	add	a1,a0
	sra	2,a0
	move	a0,*a13(OBJ_XVEL),L
#rets
	rets

;save opponent's x-velocity
#store_opp_xvel
	move	*a13(CLOSEST_NUM),a0
	X32	a0
	.ref	process_ptrs
	addi	process_ptrs,a0
	move	*a0,a0,L
	move	*a0(OBJ_XVEL),a0,L
	move	a0,@#opp_xvel,L
	rets

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
 LWWW H3UC3X+FR1,8,-51,0
 LWWW H3UC3X+FR2,-34,-46,0
 LWWW H3UC3X+FR3,-52,-42,0
 LWWW H3UC3X+FR4,-49,-39,0
 LWWW H2CP3A+FR8,-68,-61,1
 .long 0
#Razor
 LWWW R3FD3B+FR1,2,-53,0
 LWWW R3FD3B+FR2,-32,-49,0
 LWWW R3FD3B+FR3,-46,-39,0
 LWWW R3FD3B+FR4,-56,-38,0
 LWWW R3AM3D+FR1,-69,-62,1
 .long 0
#Taker
 LWWW U3FD3X+FR1,8,-50,1
 LWWW U3FD3X+FR2,-10,-49,1
 LWWW U3FD3X+FR3,-29,-50,1
 LWWW U3FD3X+FR4,-39,-43,1
 LWWW U3FD3X+FR4,-39,-23,1
; LWWW U3FD3X+FR6,-62,-16,1
 .long 0
#Yokozuna
 LWWW Y3FD3A+FR1,8,-55,0
 LWWW Y3FD3A+FR2,-35,-32,0
 LWWW Y3FD3A+FR3,-39,-35,0
 LWWW Y3FD3A+FR4,-44,-37,0
 LWWW Y3CP3B+FR1,-54,-47,1
 .long 0
#Shawn
 LWWW S3UC3X+FR1,6,-46,0
 LWWW S3UC3X+FR2,-19,-47,0
 LWWW S3UC3X+FR3,-31,-47,0
 LWWW S3UC3X+FR4,-40,-50,0
 LWWW S3CP3B+FR7,-62,-56,1
 .long 0
#BamBam
 LWWW B4UC3B+FR1,3,-48,0
 LWWW B4UC3B+FR2,-18,-50,0
 LWWW B4UC3B+FR3,-44,-52,0
 LWWW B4UC3B+FR4,-50,-53,0
 LWWW B3CP3B+FR7,-67,-45,1
 .long 0
#Doink
 LWWW D3UC3A+FR1,1,-48,0
 LWWW D3UC3A+FR3,-21,-38,0
 LWWW D3UC3A+FR4,-48,-37,0
 LWWW D3UC3A+FR5,-49,-40,0
 LWWW D3SA3A+FR9,-65,-53,1
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3UC3X+FR1,13,-51,0
 LWWW L3UC3X+FR2,-4,-57,0
 LWWW L3UC3X+FR3,-37,-55,0
 LWWW L3CP3X+FR2,-55,-55,1
 LWWW L3CP3X+FR1,-69,-55,1
 .long 0

*
********

	.ref	hrt_hitonground_anim
	.ref	rzr_hitonground_anim
	.ref	und_hitonground_anim
	.ref	yok_hitonground_anim
	.ref	shn_hitonground_anim
	.ref	bam_hitonground_anim
	.ref	lex_hitonground_anim
	.ref	dnk_hitonground_anim

#recover_tbl
	.long	hrt_hitonground_anim
	.long	rzr_hitonground_anim
	.long	und_hitonground_anim
	.long	yok_hitonground_anim
	.long	shn_hitonground_anim
	.long	bam_hitonground_anim
	.long	dnk_hitonground_anim
	.long	0
	.long	lex_hitonground_anim

#*****************************************************************************
*
* YOKO SALT THROW

 SUBR	yok_2_salt_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	1,Y1TT5Z+FR2
	WL	1,Y1TT5Z+FR3

 SUBR	yok_4_salt_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL   	2,Y4RP3A+FR2
	WL	2,Y4RP3A+FR3
	WL	3,Y4RP3A+FR4
;first, if we're holding his head, let him go.
	WWL	ANI_IFOPPMODE,~MODE_HEADHELD,#no_hdrel2
	.word	ANI_DETACH
#no_hdrel2
	.word	ANI_STARTATTACK,AT_MSL,40
	WL	3,Y4RP3A+FR5
	WL	3,Y4RP3A+FR6
	.word	ANI_SETWORD,USR_VAR2,0		;Flag for salt hit


	WL	ANI_CODE,#do_salt
	WL	13,Y4RP3A+FR7
	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2
	WL	ANI_CODE,#salt_blocked
	WL	ANI_IFNOTSTATUS,#no
	WL	20,Y4RP3A+FR7
#no	WL	3,Y3AB3A+FR1

	WL	ANI_CODE,CALL_NASTY_MOVE
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

************************************
 SUBR	yok_combo_salt_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	.word	ANI_CLR_BUTCOUNT

	WL   	2,Y4RP3A+FR2
	WL	3,Y4RP3A+FR3
	WL	5,Y4RP3A+FR4
;first, if we're holding his head, let him go.
	WWL	ANI_IFOPPMODE,~MODE_HEADHELD,#no_hdrel2c
	.word	ANI_DETACH
#no_hdrel2c
	WL	3,Y4RP3A+FR5
	WL	3,Y4RP3A+FR6
	.word	ANI_SETWORD,USR_VAR2,0		;Flag for salt hit
	WL	ANI_CODE,#do_salt
	WL	25,Y4RP3A+FR7
	WL	ANI_CODE,#salt_blocked
	WL	ANI_IFNOTSTATUS,#noc
	.WORD	ANI_INC_COMBO
	WL	40,Y4RP3A+FR7
#noc	WL	3,Y3AB3A+FR1

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#NO_SCISSORS
	WL	ANI_CHANGEANIM,yok_combo_scissor_anim

#NO_SCISSORS
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

************************************

#salt_blocked
;If yes, delay some more
	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1

	move	*a13(USR_VAR2),a0
	jrz	#not_blocked
	ori	MODE_STATUS,a1
#not_blocked
	move	a1,*a13(ANIMODE)
	rets

#do_salt
	move	a13,a11
	.ref	yok_salt_spray
	CREATE0	yok_salt_spray

	rets


;#*****************************************************************************
;*
;* CHAIR STUFF
;
;	.ref	CHAIR_SWING
;
; SUBR	yok_pkup_chair_anim
;
;	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
;	.word	ANI_ZEROVELS
;	.word	ANI_SETSPEED,100h
;
;#lp
;	WL	4,Y4WA4A+FR1
;	WL	4,Y4WA4A+FR2
;	WL	4,Y4WA4A+FR3
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR1,40,-6,1 ;image, x,y,zoff
;	WL	4,Y4WA4A+FR4
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR1,38,13,1 ;image, x,y,zoff
;	WL	4,Y4WA4A+FR5
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR1,28,42,1 ;image, x,y,zoff
;	WL	4,Y4WA4A+FR6
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR2,31,82,1 ;image, x,y,zoff
;	WL	4,Y4WA4A+FR7
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR3,13,141,1 ;image, x,y,zoff
;	WL	4,Y4WA4A+FR8
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR3,18,153,1 ;image, x,y,zoff
;	WL	4,Y4WA4A+FR9
;
;; .word ANI_SINGLESTEP
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR4,-28,143,1 ;image, x,y,zoff
;	WL	4,Y4CS4A+FR2
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR5,-32,111,1 ;image, x,y,zoff
;	WL	4,Y4CS4A+FR3
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR6,3,136,1 ;image, x,y,zoff
;	WL	4,Y4CS4A+FR4
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR8,75,117,1 ;image, x,y,zoff
;	WL	4,Y4CS4A+FR5
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR9,71,49,1 ;image, x,y,zoff
;	WL	4,Y4CS4A+FR6
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR10,43,24,1 ;image, x,y,zoff
;	WL	4,Y4CS4A+FR7
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR9,70,65,1 ;image, x,y,zoff
;	WL	4,Y4CS4A+FR8
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR8,44,127,1 ;image, x,y,zoff
;	WL	4,Y4CS4A+FR9
;
;; .word ANI_SINGLESTEP
;	WLW	ANI_ATTCHIMAGE,0,0
;
;	WL	ANI_GOTO,#lp
;

******************************************************************************

	.end
