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

;RJR START
	.include	"bretimg.h"
	.include	"razorimg.h"
	.include	"takerimg.h"
	.include	"yokoimg.h"
	.include	"shawnimg.h"
	.include	"bamimg.h"
	.include	"doinkimg.h"
	.include	"leximg.h"
;RJR END

	.include	"display.equ"
	.include	"damage.equ"

******************************************************************************
* EXTERNAL REFERENCES
  
	;BRET
	.ref	hrt_3_head_held_anim
	.ref	H3GU4A,H3DU3A,H3BF3A

	;BAM BAM
	.ref	bam_3_head_held_anim
	.ref	B3GU4A,B3DU3A,B3BF3C

	;DOINK
	.ref	dnk_3_head_held_anim
	.ref	D3DU3A,D3HT3Z,D3BF3A,D4SK4A

	;LEX
	.ref	lex_3_head_held_anim
	.ref	L3DU3A,L3BF3B

	;RAZOR
	.ref	rzr_3_head_held_anim
	.ref	R3GU4A,R3DU3B,R3BF3A

	;SHAWN
	.ref	shn_frnk_backfire_anim,shn_3_head_held_anim
	.ref	S3GU4A,S3DU3A,S3BF3A

	;TAKER
	.ref	und_3_head_held_anim
	.ref	U3DU3B,U4BF3Z

	;YOKO
	.ref	yok_stand4_anim,yok_dizzy_anim
	.ref	Y3GU2A,Y3BF3A


	;MISC
	.ref	CALL_MISSES,set_position,set_skeleton_pal,am_I_dizzy
	.ref	start_smoke,set_my_pal,make_white,make_norm


;RJR START
	.ref	slaveanim_tbl

	.ref	hrt_slambounce_anim
	.ref	rzr_slambounce_anim
	.ref	und_slambounce_anim
	.ref	yok_slambounce_anim
	.ref	shn_slambounce_anim
	.ref	bam_slambounce_anim
	.ref	dnk_slambounce_anim
	.ref	und_slambounce_anim
	.ref	lex_slambounce_anim
;RJR END

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* GET BUZZED FROM DOINK

 SUBR	yok_get_buzz_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
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
	.word	ANI_END

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

 SUBR	yok_3_head_held_stand_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	4,Y3LB3A+FR9
	WL	3,Y1TT5Z+FR2	;2.5
	.word	ANI_DETACH

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


	
#*****************************************************************************
*
* This one is special.  If shawn tries a frankensteiner on yoko, it backfires
* and he ends up falling off.  To keep this smooth, we have to turn yoko into
* the attacker.  jump here.
*

 SUBR	yok_frnk_backfire_anim

	.word	ANI_ZEROVELS
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_ATTACHZ,0,0,10

	WWLLW	ANI_SUPERSLAVE2,8,Y1TT5Z+FR2,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,Y1TT5Z+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,Y1TT5Z+FR2,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,Y1TT5Z+FR2,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,Y1TT5Z+FR2,#puppet_tbl,4

	;let go
	.word	ANI_OPP_GETUP,TSEC
	WL	ANI_SLAVEANIM,#drop_table
	.word	ANI_DETACH

	;wind down
	WL	4,Y1TT5Z+FR3
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
#Shawn
 LWWW S3ZI3A+FR3,-5,30,0
 LWWW S3ZI3A+FR4,1,31,0
 LWWW S3ZI3A+FR5,2,15,0
 LWWW S3ZI3A+FR6,0,20,0
 LWWW S3ZI3A+FR7,-5,-12,0
#Bret
#Razor
#Taker
#Yokozuna
#BamBam
#Doink
#Adam
#Lex
 .long 0

#drop_table
	.long	0,0,0,0
	.long	shn_frnk_backfire_anim,0,0,0,0

#******************************************************************************

 SUBR	yok_2_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	2,Y1TT5Z+FR2
	WL	2,Y1TT5Z+FR3

 SUBR	yok_4_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

;Put cool cheers here
;	.word	ANI_RAWSOUND,2055		;big cheer #1
;	.word	ANI_CHEER,3
	.word	ANI_STARTATTACK,AT_BUTTSTOMP,36
	.word	ANI_STARTATTACK,AT_PUPPET,8

	WL	4,Y4WS4A+FR1

	LEAPATOPP 8,999,80,80,30000h,TGT_HEAD,26,0,10
	WL	4,Y4WS4A+FR2
	WL	4,Y4WS4A+FR3
	.word	ANI_ZERO_XZVELS

	.word	ANI_ATTACK_ON, AMODE_PUPPET,15,0,25,22 ;mode,x,y,w,h
	WL	4,Y4WS4A+FR4
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;got him
	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SOUND,33h			;neck break (5-7 ticks late)

	WWLLW	ANI_SUPERSLAVE2,4,Y4WS4A+FR4,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,Y4WS4A+FR5,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,Y4WS4A+FR6,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,Y4WS4A+FR7,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,Y4WS4A+FR8,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,Y4GH3C+FR9,#puppet_tbl,5

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	3,Y4GH3C+FR9
	.word	ANI_CLROPPMODE,MODE_GHOST

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
	WL	20,Y4WS4A+FR4
	WL	4,Y4WS4A+FR3
	WL	4,Y4WS4A+FR2
	WL	4,Y4WS4A+FR1


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
 LWWW H3GU4A+FR1,38,-51,0
 LWWW H3GU4A+FR3,46,-48,0
 LWWW H3DU3A+FR3,47,-37,1
 LWWW H3DU3A+FR4,56,-26,1
 LWWW H3DU3A+FR5,53,-35,1
 LWWW H3BF3A+FR1,71,-34,0
 .long 0
#Razor
 LWWW R3GU4A+FR2,42,-47,1
 LWWW R3GU4A+FR3,43,-38,0
 LWWW R3GU4A+FR5,43,-37,0
 LWWW R3DU3B+FR2,44,-36,1
 LWWW R3DU3B+FR4,57,-28,1
 LWWW R3BF3A+FR4,68,-33,0
 .long 0
#Taker
 LWWW U3DU3B+FR2,38,-41,1
 LWWW U3DU3B+FR5,41,-34,1
 LWWW U3DU3B+FR6,46,-33,1
 LWWW U3DU3B+FR8,43,-27,1
 LWWW U3DU3B+FR10,60,-28,1
 LWWW U4BF3Z+FR5,66,-14,0
 .long 0
#Yokozuna
 LWWW Y3GU2A+FR1,37,-35,0
 LWWW Y3GU2A+FR3,54,-27,0
 LWWW Y3GU2A+FR6,27,-37,0
 LWWW Y3GU2A+FR9,54,-30,0
 LWWW Y3GU2A+FR12,60,-29,0
 LWWW Y3BF3A+FR1,67,-23,0
 .long 0
#Shawn
 LWWW S3GU4A+FR1,43,-46,1
 LWWW S3GU4A+FR2,42,-36,0
 LWWW S3GU4A+FR4,49,-39,0
 LWWW S3GU4A+FR5,49,-37,0
 LWWW S3DU3A+FR2,60,-41,1
 LWWW S3BF3A+FR1,56,-34,0
 .long 0
#BamBam
 LWWW B3GU4A+FR3,43,-37,0
 LWWW B3GU4A+FR4,44,-37,0
 LWWW B3GU4A+FR6,40,-30,0
 LWWW B3GU4A+FR7,39,-38,0
 LWWW B3DU3A+FR2,57,-31,1
 LWWW B3BF3C+FR5,72,-27,0
 .long 0
#Doink
 LWWW D3DU3A+FR2,38,-40,1
 LWWW D3DU3A+FR3,45,-34,1
 LWWW D3DU3A+FR5,45,-27,1
 LWWW D3DU3A+FR8,41,-29,1
 LWWW D3HT3Z+FR1,55,-33,1
 LWWW D3BF3A+FR2,60,-32,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3DU3A+FR2,44,-51,1
 LWWW L3DU3A+FR4,25,-34,1
 LWWW L3DU3A+FR6,30,-37,1
 LWWW L3DU3A+FR7,33,-31,1
 LWWW L3DU3A+FR9,48,-36,1
 LWWW L3BF3B+FR2,63,-37,0
 .long 0

#******************************************************************************

 SUBR	yok_4_taunt_anim

	.word	ANI_SETMODE,MODE_UNINT
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

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

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,yok_stand4_anim
	.word	ANI_END

#*****************************************************************************
*
* HELD OVERHEAD ANIMATION

 SUBR	yok_heldoh_anim

	.word	ANI_SETPLYRMODE,MODE_ATTACHED
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_SETSPEED,100h

	.word	ANI_SETWORD,USR_VAR1,0		;loop count

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
	.word	ANI_OFFSET,0,0,0
	.ref	yok_faceup_getup_anim

	WL	ANI_CHANGEANIM,yok_faceup_getup_anim
	.word	ANI_END

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

;	.word	ANI_GETUP,50
	WL	3,Y3KF3B+FR6		
	.word	ANI_WAITROLL
;	.word	ANI_OFFSET,0,0,0

	WL	ANI_CHANGEANIM,yok_faceup_getup_anim
	.word	ANI_END

#*****************************************************************************
*
* THROWN FROM RING (shn_bslm, shn_frnk)

 SUBR	yok_flyout_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETSPEED,100h

	WL	6,Y3FL3W+FR4
	WL	6,Y3FL3W+FR5
	WL	6,Y3FL3W+FR6
	WL	6,Y3FL3W+FR7
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,60

	.word	ANI_DAMAGE,D_HIPTOSS
	.word	ANI_SETWORD,DELAY_METER,0
	.word	ANI_GETUP,500

	.word	ANI_OFFSET,10,0,0
	WL	3,Y3FD3A+FR7
	.word	ANI_XFLIP
	.ref	yok_hitonground_anim
	WL	ANI_CHANGEANIM,yok_hitonground_anim


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

	.word	ANI_GETUP,300
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
	.word	ANI_END

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
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_GETUP,300
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
	WL	3,Y3RL1A+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,yok_faceup_getup_anim
	.word	ANI_END

#*****************************************************************************

	.bss	#opp_xvel,32

 SUBR	yok_3_head_hold_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold
	.word	ANI_STARTATTACK,AT_PUPPET,12

	WL	3,Y4GH3C+FR2
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 9,999,60,40,90000h,TGT_HEAD,56,93,8
	WL	3,Y4GH3C+FR3

	.word	ANI_ATTACK_ON, AMODE_PUPPET,40,80,37,23 ;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,6,Y4GH3C+FR4

	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	WL	ANI_IFBLOCKED,#missed

;got him
	.ref	CALL_SETUP
	WL	ANI_CODE,CALL_SETUP

	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,4,Y4GH3C+FR5,#puppet_tbl,0

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WWLLW	ANI_SUPERSLAVE2,4,Y4GH3C+FR7,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,Y4GH3C+FR8,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,Y4GH3C+FR9,#puppet_tbl,3

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	4,Y4GH3C+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	25,Y4GH3C+FR4
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

	.ref	H2AH3A,H3HB3A,H3BF3A
	.ref	R2AH2D,R3HB3A,R3BF3A
	.ref	U4BF3A,U4BF3Z,U4AM4C
;	.ref	Y3BF3A,Y3LB3A
	.ref	S4AH3D,S4BF3A
	.ref	B4BF3A,B3HB3A,B3BF3C
	.ref	D3AK3A,D3BF3A
	.ref	L2AH2A,L3BF3A,L3BF3B,L4AH4B
#Bret
 LWWW H2AH3A+FR1,63,11,0
 LWWW H3HB3A+FR3,70,1,0
 LWWW H3HB3A+FR2,62,-5,0
 LWWW H3HB3A+FR1,59,-35,0
 .long 0
#Razor
 LWWW R3HB3A+FR3,79,-11,0
 LWWW R3HB3A+FR3,76,-1,0
 LWWW R3HB3A+FR2,75,-16,0
 LWWW R3BF3A+FR1,67,-35,0
 .long 0
#Taker
 LWWW U4AM4C+FR2,69,-1,0
 LWWW U4BF3A+FR2,66,11,0
 LWWW U4BF3A+FR3,39,-2,0
 LWWW U4BF3Z+FR3,64,-22,0
 .long 0
#Yokozuna
 LWWW Y3LB3A+FR2,73,1,0
 LWWW Y3LB3A+FR2,70,11,0
 LWWW Y3LB3A+FR9,60,-13,0
 LWWW Y3BF3A+FR1,62,-23,0
 .long 0
#Shawn
 LWWW S4AH3D+FR5,57,-2,0
 LWWW S4AH3D+FR5,54,8,0
 LWWW S4BF3A+FR2,73,-8,0
 LWWW S4BF3A+FR3,55,-23,0
 .long 0
#BamBam
 LWWW B4BF3A+FR1,72,-4,0
 LWWW B4BF3A+FR1,69,6,0
 LWWW B3HB3A+FR2,60,-23,0
 LWWW B3BF3C+FR5,68,-27,0
 .long 0
#Doink
 LWWW D3AK3A+FR3,54,3,0
 LWWW D3AK3A+FR3,51,13,0
 LWWW D3AK3A+FR2,67,-4,0
 LWWW D3BF3A+FR1,63,-33,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L4AH4B+FR3,55,-3,0
 LWWW L3BF3A+FR1,72,6,1
 LWWW L3BF3A+FR2,68,-8,1
 LWWW L3BF3B+FR5,55,-30,0
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

;RJR START
#*****************************************************************************
*
* VERTICAL SUPLEX

 SUBR	yok_vsuplex_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_ATTACHZ,0,0,2	;put opp in front of attacker

	WL	ANI_SLAVEANIM,slaveanim_tbl
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	.word	ANI_SETOPPMODE,MODE_GHOST

	WWLLW	ANI_SUPERSLAVE2,4,Y4SU4A+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,Y4SU4A+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,Y4SU4A+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,Y4SU4A+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,Y4SU4B+FR1,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,Y4SU4B+FR2,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,4,Y4SU4B+FR3,#puppet_tbl,6
	.word	ANI_OFFSET,0,45,0	;x,y,z
	WL	ANI_SET_YVEL,020000h
	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL
	WWLLW	ANI_SUPERSLAVE2,4,Y4SU4B+FR4,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,4,Y4SU4B+FR5,#puppet_tbl,8
	WWLLW	ANI_SUPERSLAVE2,4,Y4SU4B+FR6,#puppet_tbl,9
	WWLLW	ANI_SUPERSLAVE2,4,Y4SU4B+FR7,#puppet_tbl,10

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,45

	.word	ANI_DAMAGE,D_HIPTOSS


	WWLLW	ANI_SUPERSLAVE2,4,Y4SU4B+FR8,#puppet_tbl,11
	WWLLW	ANI_SUPERSLAVE2,4,Y4SU4B+FR9,#puppet_tbl,12

	WL	ANI_XFLIP_TBL,#xflip_tbl
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	WL	ANI_SLAVEANIM,#breakneck_tbl
	WLLL	ANI_SETOPPVELS,-10000h,40000h,0		;x,y,z vels

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_DETACH

	WL	10,Y4SU4B+FR10

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,yok_faceup_getup2_anim

#xflip_tbl
	.word	0 ;bret
	.word	1 ;razor
	.word	0 ;taker
	.word	0 ;yoko
	.word	0 ;shawn
	.word	0 ;bam
	.word	1 ;doink
	.word	0 ;spare
	.word	0 ;lex

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
 LWWW H4AM3A+FR5,37,-25,0
 LWWW H3PP3X+FR1,37,-20,0
 LWWW H3PP3X+FR2,21,42,0
 LWWW H3PP3X+FR3,4,59,0
 LWWW H3PP3X+FR5,20,73,0
 LWWW H3PP3X+FR6,15,75,0
 LWWW H3PP3X+FR6,14,74,0
 LWWW H3PP3X+FR6,12,79,0
 LWWW H3PP3X+FR6,13,78,0
 LWWW H3PP3X+FR6,4,75,0
 LWWW H3PP3X+FR6,-13,78,0
 LWWW H3PP3X+FR7,-42,9,0
 LWWW H3PP3X+FR8,-39,-11,0
 .long 0
#Razor
 LWWW R3GP3Z+FR1,28,-31,0
 LWWW R3GP3Z+FR2,30,-15,0
 LWWW R3GP3Z+FR4,38,55,0
 LWWW R3GP3Z+FR5,26,60,0
 LWWW R3GP3Z+FR5,26,66,0
 LWWW R3GP3Z+FR5,27,65,0
 LWWW R3GP3Z+FR5,26,64,0
 LWWW R3GP3Z+FR6,33,66,0
 LWWW R3GP3Z+FR6,34,67,0
 LWWW R3GP3Z+FR6,21,76,0
 LWWW R3GP3Z+FR6,6,81,0
 LWWW R3GP3Z+FR7,-37,24,0
 LWWW R3GP3Z+FR8,-30,-18,0
 .long 0
#Taker
 LWWW U3PP3X+FR1,34,-26,1
 LWWW U3PP3X+FR3,30,-4,1
 LWWW U3PP3X+FR4,20,25,1
 LWWW U3PP3X+FR5,24,48,1
 LWWW U3PP3X+FR6,31,76,1
 LWWW U3PP3X+FR6,31,75,1
 LWWW U3PP3X+FR6,30,74,1
 LWWW U3PP3X+FR6,24,81,1
 LWWW U3PP3X+FR6,25,81,1
 LWWW U3PP3X+FR6,16,94,1
 LWWW U3PP3X+FR6,1,102,1
 LWWW U3GP3X+FR1,-41,3,1
 LWWW U3GP3X+FR2,-34,-23,1
 .long 0
#Yokozuna
 LWWW Y3BF3A+FR11,34,-17,0
 LWWW Y3PP3Q+FR1,31,-13,0
 LWWW Y3PP3Q+FR3,30,9,0
 LWWW Y3PP3Q+FR6,14,35,0
 LWWW Y3PP3Q+FR6,17,40,0
 LWWW Y3PP3Q+FR6,17,39,0
 LWWW Y3PP3Q+FR7,13,49,0
 LWWW Y3PP3Q+FR7,11,52,0
 LWWW Y3PP3Q+FR7,10,51,0
 LWWW Y3PP3Q+FR7,5,52,0
 LWWW Y3PP3Q+FR7,-11,52,0
 LWWW Y3FD3N+FR2,-52,7,0
 LWWW Y3FD3N+FR3,-42,4,0
 .long 0
#Shawn
 LWWW S3BF3A+FR5,24,-31,0
 LWWW S3GP3X+FR1,38,-20,0
 LWWW S3GP3X+FR2,31,1,0
 LWWW S3GP3X+FR3,20,17,0
 LWWW S3GP3X+FR4,28,50,0
 LWWW S3GP3X+FR5,30,56,0
 LWWW S3GP3X+FR5,29,55,0
 LWWW S3GP3X+FR5,28,63,0
 LWWW S3GP3X+FR5,30,63,0
 LWWW S3OS3X+FR8,16,56,1
 LWWW S3OS3X+FR8,-2,56,1
 LWWW S3FD3X+FR2,-34,17,0
 LWWW S3GP3X+FR6,-29,-11,0
 .long 0
#BamBam
 LWWW B3PP3Q+FR1,28,-31,0
 LWWW B3PP3Q+FR2,38,-6,0
 LWWW B3PP3Q+FR3,35,23,0
 LWWW B3PP3Q+FR4,22,50,0
 LWWW B3PP3Q+FR5,27,69,0
 LWWW B3PP3Q+FR5,27,68,0
 LWWW B3PP3Q+FR5,26,67,0
 LWWW B3PP3Q+FR6,8,77,0
 LWWW B3PP3Q+FR6,1,76,0
 LWWW B3PP3Q+FR6,-6,76,0
 LWWW B3PP3Q+FR6,-20,76,0
 LWWW B3PP3Q+FR7,-48,18,0
 LWWW B3FD3C+FR1,-48,-7,0
 .long 0
#Doink
 LWWW D3PD3Z+FR1,40,-38,1
 LWWW D3PD3Z+FR2,39,-8,1
 LWWW D3PD3Z+FR3,34,22,1
 LWWW D3PD3Z+FR4,23,62,1
 LWWW D3PD3Z+FR5,20,75,1
 LWWW D3PD3Z+FR5,20,74,1
 LWWW D3PD3Z+FR5,19,73,1
 LWWW D3PD3Z+FR6,21,66,1
 LWWW D3PD3Z+FR6,21,62,1
 LWWW D3PD3Z+FR6,12,69,1
 LWWW D3PD3Z+FR6,-8,71,1
 LWWW D3PD3Z+FR8,-35,-1,1
 LWWW D3PD3Z+FR9,-33,-23,1
 .long 0
#Adam
 .long 0
#Lex
 LWWW L4AM4B+FR4,36,-29,0
 LWWW L3GP3Z+FR1,35,-17,0
 LWWW L3GP3Z+FR2,29,2,0
 LWWW L3GP3Z+FR4,23,31,0
 LWWW L3GP3Z+FR5,28,43,0
 LWWW L3GP3Z+FR6,26,57,0
 LWWW L3GP3Z+FR6,25,55,0
 LWWW L3GP3Z+FR6,25,62,0
 LWWW L3GP3Z+FR6,25,64,0
 LWWW L3GP3Z+FR6,18,63,0
 LWWW L3GP3Z+FR6,0,65,0
 LWWW L3FH3A+FR6,-40,12,0
 LWWW L3FD3B+FR1,-31,-11,0
 .long 0

#*****************************************************************************
*
* GRAB & FLIP

 SUBR	yok_grabflip_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,8

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,50,50,35,90000h,TGT_CHEST,39,73,0
	WL	ANI_SET_YVEL,20000h

	WL	4,Y4LZ3A+FR1

	.word	ANI_ATTACHZ,0,0,-2	;put opp behind attacker

	.word	ANI_ATTACK_ON, AMODE_PUPPET,0,44,52-8,52 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,Y4LZ3A+FR1
	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missed

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,4,Y4LZ3A+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,Y4LZ3A+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,Y4LZ3A+FR3,#puppet_tbl,2
	.word	ANI_FACE,MOVE_LEFT|MOVE_DOWN
	WWLLW	ANI_SUPERSLAVE2,4,Y4LZ3A+FR4,#puppet_tbl,3
	.word	ANI_OFFSET,0,50,0	;x,y,z
	WL	ANI_SET_YVEL,02000h
	WWLLW	ANI_SUPERSLAVE2,3,Y4LZ3A+FR5,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,Y4LZ3A+FR6,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,3,Y4LZ3A+FR7,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,3,Y4LZ3A+FR8,#puppet_tbl,7

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,60

	.word	ANI_DAMAGE,D_HIPTOSS


	WWLLW	ANI_SUPERSLAVE2,4,Y4LZ3A+FR9,#puppet_tbl,8
	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#slambounce_tbl
	WLLL	ANI_SETOPPVELS,20000h,40000h,00000h	;x,y,z vels
	.word	ANI_DETACH

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	WL	14,Y4LZ3A+FR9
	.word	ANI_XFLIP
	.ref	yok_faceup_getup2_anim
	WL	ANI_CHANGEANIM,yok_faceup_getup2_anim

#missed
	WL	20,Y4LZ3A+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

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

#*****************************************************************************
*
* SPIN & SLAM

#*****************************************************************************
*
* GRAB OPPONENT AND HOLD OVERHEAD

 SUBR	yok_graboh_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,8

	WL	4,Y4PO4X+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,50,50,35,90000h,TGT_CHEST,71,64,0
	WL	ANI_SET_YVEL,20000h

	WL	5,Y4PO4X+FR2

	.word	ANI_ATTACK_ON, AMODE_PUPPET,8,46,65,33 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,5,Y4PO4X+FR2
	.word	ANI_ATTACK_OFF

	.word	ANI_ZERO_XZVELS

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missed

	WL	ANI_CODE,CALL_SETUP
	.word	ANI_ATTACHZ,0,0,2	;put opp in front of attacker

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,9,Y4PO4X+FR3,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,Y4PO4X+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,Y4PO4X+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,Y4PO4X+FR6,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,Y4PO4X+FR7,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,Y4PO4X+FR8,#puppet_tbl,5

	WL	ANI_SLAVEANIM,#strt_flail_tbl

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETPLYRMODE,MODE_OPPOVERHEAD
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	20,Y4PO4X+FR3
	WL	4,Y4PO4X+FR2
	WL	4,Y4PO4X+FR1

	.word	ANI_SETMODE,MODE_NORMAL
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

;RJR END
******************************************************************************

	.end
