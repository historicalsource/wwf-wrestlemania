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

	.file	"bamseq3.asm"
	.title	"Bam Bam Bigelo animation sequences"
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

	.include	"bamimg.h"

	.include	"display.equ"
	.include	"damage.equ"



******************************************************************************
* EXTERNAL REFERENCES

	.ref	DO_PILE_MESS
	.REF	DO_BODY_MESS
	.REF	DO_BACK_MESS
	.ref	CALL_SETUP

	.ref	D4SK4A,bam_faceup_getup_anim
	.REF	HIT_THE_MAT,CALL_SPECIAL_MOVE
	.ref	CALL_MISSES,tgt_tbukl,tbukl_flip
	.ref	set_position,make_white,make_norm,start_smoke
	.ref	am_I_dizzy
	.ref	bam_dizzy_anim
	.ref	set_skeleton_pal,set_my_pal

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* GRAB OPPONENT AND HOLD OVERHEAD


 SUBR	bam_2_graboh_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,15
	WL	2,B1TT5Z+FR2	;2.5
	WL	2,B1TT5Z+FR3	;3.5

 SUBR	bam_4_graboh_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_LEAPING,11
	WL	3,B3PO4A+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,80,80,60,90000h,TGT_CHEST,66,67,0
	WL	ANI_SET_YVEL,20000h
;	.ref	store_opp_xvel
;	WL	ANI_CODE,store_opp_xvel

	WL	3,B3PO4A+FR2
	WL	3,B3PO4A+FR3

	.word	ANI_ATTACK_ON, AMODE_PUPPET,29,47,39,45 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,5,B3PO4A+FR4
	.word	ANI_ATTACK_OFF
	.word	ANI_ZEROVELS

	WL	ANI_IFNOTSTATUS,#missed

	WL	ANI_IFBLOCKED,#missed

;#gothim
	.ref	merge_xvels
	WL	ANI_CODE,CALL_SETUP

	.word	ANI_SOUND,82h			;Effort grunt

	.word	ANI_ATTACHZ,0,0,2		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,4,B3PO4A+FR4,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,B3PO4A+FR5,#puppet_tbl,1

;	.word	ANI_WAITHITGND
;	.word	ANI_ZEROVELS

	WWLLW	ANI_SUPERSLAVE2,4,B3PO4A+FR6,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,B3PO4A+FR7,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,B3PO4A+FR8,#puppet_tbl,4

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	ANI_SLAVEANIM,#strt_flail_tbl

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_OPPOVERHEAD
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	20,B3PO4A+FR4
	WL	3,B3PO4A+FR3
	WL	3,B3PO4A+FR2
	WL	3,B3PO4A+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
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
	.ref	H3MS3Z,H4MF4B
	.ref	R3MS3Z,R4MF4B
	.ref	U4GH3C,U3MS3Z,U4PM3C,U4GH3C
	.ref	Y3MS3Z,Y3MF3B
	.ref	S3PM4B,S3MS3Z,S3MF3B
;	.ref	B3MS3Z,B4MF4A
	.ref	D3GS3X,D4MF4A
	.ref	L3MS3Z,L3MF3B
#Bret
 LWWW H3MS3Z+FR1,53,16,0
 LWWW H3MS3Z+FR2,37,20,0
 LWWW H3MS3Z+FR3,24,22,0
 LWWW H3MS3Z+FR4,-12,26,0
 LWWW H4MF4B+FR1,-31,10,0
 .long 0
#Razor
 LWWW R3MS3Z+FR1,57,7,0
 LWWW R3MS3Z+FR2,37,13,0
 LWWW R3MS3Z+FR3,10,13,0
 LWWW R3MS3Z+FR4,-25,21,0
 LWWW R4MF4B+FR6,-40,16,0
 .long 0
#Taker
 LWWW U4GH3C+FR10,67,16,0
 LWWW U3MS3Z+FR1,31,36,0
 LWWW U3MS3Z+FR2,-6,32,0
 LWWW U3MS3Z+FR4,-31,17,0
 LWWW U4PM3C+FR6,-44,20,0
 .long 0
#Yokozuna
 LWWW Y3MS3Z+FR1,65,4,0
 LWWW Y3MS3Z+FR2,48,30,0
 LWWW Y3MS3Z+FR3,24,30,0
 LWWW Y3MS3Z+FR5,-29,28,0
 LWWW Y3MF3B+FR7,-32,19,0
 .long 0
#Shawn
 LWWW S3PM4B+FR1,53,14,0
 LWWW S3MS3Z+FR1,18,20,0
 LWWW S3MS3Z+FR2,3,20,0
 LWWW S3MS3Z+FR4,-33,19,0
 LWWW S3MF3B+FR6,-45,21,0
 .long 0
#BamBam
 LWWW B3MS3Z+FR1,60,13,0
 LWWW B3MS3Z+FR2,38,13,0
 LWWW B3MS3Z+FR3,15,10,0
 LWWW B3MS3Z+FR4,-21,27,0
 LWWW B4MF4A+FR6,-41,31,0
 .long 0
#Doink
 LWWW D3GS3X+FR1,70,0,0
 LWWW D3GS3X+FR3,35,22,0
 LWWW D3GS3X+FR4,18,15,0
 LWWW D3GS3X+FR5,-16,19,0
 LWWW D4MF4A+FR1,-36,14,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3MS3Z+FR1,63,8,0
 LWWW L3MS3Z+FR2,37,22,0
 LWWW L3MS3Z+FR3,7,12,0
 LWWW L3MS3Z+FR5,-32,16,0
 LWWW L3MF3B+FR6,-37,14,0
 .long 0
 
	.ref	hrt_heldoh_anim
	.ref	rzr_heldoh_anim
	.ref	und_heldoh_anim
	.ref	yok_heldoh_anim
	.ref	shn_heldoh_anim
;	.ref	bam_heldoh_anim
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


 SUBR	bam_stndholdoh_anim

	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	999,B3PO4A+FR8
	.word	ANI_REPEAT


#*****************************************************************************
*
* OPPONENT HELD OVERHEAD - SLAM DOWN


 SUBR	bam_slamdwn_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_ATTACK_ON, AMODE_PUPPET,-30,138,64,11 ;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,6,B3PO4A+FR8
	.word	ANI_ATTACK_OFF

	.word	ANI_ATTACHZ,0,0,4
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_KEEPATTACHED|MODE_OVERLAP|MODE_NOCONFINE

	WWLLW	ANI_SUPERSLAVE2,4,B4CF4A+FR1,#puppet_tbl,0

	.word	ANI_SOUND,82h			;Effort grunt

	WLW	ANI_SET_ZVEL,-18000h,AM_ABS
	WL	ANI_SET_YVEL,50000h
;Float away from side ropes!
;Float toward the center of ring!
	WL	ANI_CODE,set_xdrift

	WL	ANI_CODE,DO_BODY_MESS

	WWLLW	ANI_SUPERSLAVE2,4,B4CF4A+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,B4CF4A+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,B4CF4A+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,B4CF4A+FR5,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,B4CF4A+FR6,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,3,B4CF4A+FR7,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,3,B4CF4A+FR8,#puppet_tbl,7

	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS

	WWLLW	ANI_SUPERSLAVE2,3,B4CF4A+FR9,#puppet_tbl,8

	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_DAMAGEOPP,D_HIPTOSS
	.word	ANI_SHAKER,30

	WL	ANI_CODE,CALL_SPECIAL_MOVE

	.word	ANI_OFFSET,-20,0,0			;x,y,z

	WL	ANI_SLAVEANIM,#faced_tbl
	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WL	ANI_SET_YVEL,30000h
	WLW	ANI_SET_ZVEL,-10000h,AM_ABS
	WL	5,B4CF4A+FR9
	WL	ANI_CODE,#set_opp_y

	WL	2,B4CF4A+FR9

	.word	ANI_WAITHITGND
	WL	4,B3PO4E+FR2
	WL	4,B3PO4E+FR3
	WL	4,B3PO4E+FR4

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL

;	.word	ANI_SETPLYRMODE,MODE_OPPOVERHEAD
;	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_END

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

	.ref	S3CF3Z,Y3KF3B,L3TF3X

#Bret
 LWWW H4MF4B+FR1,-29,11,0
 LWWW H4MF4B+FR1,-31,8,0
 LWWW H4MF4B+FR1,-34,9,0
 LWWW H4MF4B+FR1,-39,7,0
 LWWW H4MF4B+FR1,-43,10,0
 LWWW H4MF4B+FR1,-40,14,0
 LWWW H4MF4B+FR1,-33,15,0
 LWWW H4MF4B+FR1,-13,6,0
 LWWW H4MF4B+FR1,-8,-41,0
 .long 0
#Razor
 LWWW R4MF4B+FR6,-35,15,0
 LWWW R4MF4B+FR6,-38,14,0
 LWWW R4MF4B+FR6,-40,15,0
 LWWW R4MF4B+FR6,-41,16,0
 LWWW R4MF4B+FR6,-38,24,0
 LWWW R4MF4B+FR6,-43,24,0
 LWWW R4MF4B+FR6,-41,21,0
 LWWW R4MF4B+FR6,-29,11,0
 LWWW R3MS3Z+FR6,25,-46,0
 .long 0
#Taker
	.ref	U3CF3Q
 LWWW U4PM3C+FR6,-42,17,0
 LWWW U4PM3C+FR6,-44,14,0
 LWWW U4PM3C+FR6,-47,14,0
 LWWW U4PM3C+FR6,-48,14,0
 LWWW U4PM3C+FR6,-44,21,0
 LWWW U4PM3C+FR6,-49,21,0
 LWWW U4PM3C+FR6,-46,19,0
 LWWW U4PM3C+FR6,-30,10,0
 LWWW U3CF3Q+FR1,14,-62,0
 .long 0
#Yokozuna
 LWWW Y3MF3B+FR7,-37,18,0
 LWWW Y3MF3B+FR7,-42,15,0
 LWWW Y3MF3B+FR7,-45,16,0
 LWWW Y3MF3B+FR7,-46,16,0
 LWWW Y3MF3B+FR7,-42,23,0
 LWWW Y3MF3B+FR7,-46,23,0
 LWWW Y3MF3B+FR7,-42,22,0
 LWWW Y3MF3B+FR7,-20,14,0
 LWWW Y3KF3B+FR1,18,-37,0
 .long 0
#Shawn
 LWWW S3MF3B+FR6,-43,18,0
 LWWW S3MF3B+FR6,-44,16,0
 LWWW S3MF3B+FR6,-47,17,0
 LWWW S3MF3B+FR6,-48,17,0
 LWWW S3MF3B+FR6,-44,23,0
 LWWW S3MF3B+FR6,-49,23,0
 LWWW S3MF3B+FR6,-47,20,0
 LWWW S3MF3B+FR6,-28,10,0
 LWWW S3CF3Z+FR1,27,-59,0
 .long 0
#BamBam
 LWWW B4MF4A+FR6,-48,35,0
 LWWW B4MF4A+FR6,-50,34,0
 LWWW B4MF4A+FR6,-54,34,0
 LWWW B4MF4A+FR6,-58,32,0
 LWWW B4MF4A+FR6,-56,37,0
 LWWW B4MF4A+FR6,-61,37,0
 LWWW B4MF4A+FR6,-53,40,0
 LWWW B4MF4A+FR6,-33,29,0
 LWWW B3RL1A+FR7,35,-55,0
 .long 0
#Doink
 LWWW D4MF4A+FR1,-34,15,0
 LWWW D4MF4A+FR1,-36,12,0
 LWWW D4MF4A+FR1,-39,13,0
 LWWW D4MF4A+FR1,-42,12,0
 LWWW D4MF4A+FR1,-40,19,0
 LWWW D4MF4A+FR1,-44,19,0
 LWWW D4MF4A+FR1,-34,17,0
 LWWW D4MF4A+FR1,-24,6,0
 LWWW D3GS3X+FR8,20,-59,0
 LWWW B4CF4A+FR1,-47,141,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3MF3B+FR6,-35,12,0
 LWWW L3MF3B+FR6,-36,9,0
 LWWW L3MF3B+FR6,-37,10,0
 LWWW L3MF3B+FR6,-38,11,0
 LWWW L3MF3B+FR6,-35,19,0
 LWWW L3MF3B+FR6,-40,18,0
 LWWW L3MF3B+FR6,-40,16,0
 LWWW L3MF3B+FR6,-30,5,0
 LWWW L3TF3X+FR1,9,-55,0
 .long 0
 
	.ref	hrt_break_face_anim,rzr_break_face_anim
	.ref	und_break_face_anim
	.ref	shn_break_face_anim
	.ref	dnk_break_face_anim
;	.ref	bam_break_face_anim
	.ref	lex_break_face_anim
	.ref	yok_break_face_anim

#faced_tbl
	.long	hrt_break_face_anim,rzr_break_face_anim
	.long	und_break_face_anim
	.long	yok_break_face_anim
	.long	shn_break_face_anim,bam_break_face_anim
	.long	dnk_break_face_anim,0,lex_break_face_anim

#*****************************************************************************
*
* HELD OVERHEAD ANIMATION

 SUBR	bam_heldoh_anim

	.word	ANI_SETPLYRMODE,MODE_ATTACHED
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_SETSPEED,100h

	.word	ANI_SETWORD,USR_VAR1,0		;loop count

#loop	WL	5,B4MF4A+FR1
	WL	5,B4MF4A+FR2
	WL	5,B4MF4A+FR3
	WL	5,B4MF4A+FR4
	WL	5,B4MF4A+FR5
	WL	5,B4MF4A+FR6
	WL	5,B4MF4A+FR7

	WL	ANI_CODE,#inc_loop
	WL	ANI_IFNOTSTATUS,#loop

;Fall out of overhead hold by reversing thru pickup frames
	.word	ANI_DETACH

	.word	ANI_OFFSET,-20,-50,0			;x,y,z
 
	.word	ANI_SETMODE,MODE_NORMAL|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_INAIR

	WL	ANI_SET_YVEL,10000h
	WLW	ANI_SET_XVEL,-40000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,10000h,AM_ABS
	.word	ANI_FRICTION,3000h

	WL	5,B3MS3Z+FR4
	WL	5,B3MS3Z+FR3
	WL	5,B3MS3Z+FR2
	WL	5,B3MS3Z+FR1
	WL	5,B2ST2A+FR1

	.word	ANI_WAITHITGND
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
* BACK BREAKER

 SUBR	bam_backbreaker_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_ATTACK_ON, AMODE_PUPPET,-30,138,64,11 ;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,6,B3PO4A+FR8
	.word	ANI_ATTACK_OFF

	.word	ANI_ATTACHZ,0,0,4
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_KEEPATTACHED|MODE_OVERLAP|MODE_NOCONFINE

	.word	ANI_OFFSET,0,10,0			;x,y,z

	WLW	ANI_SET_ZVEL,-18000h,AM_ABS
	WL	ANI_SET_YVEL,70000h
;Float away from side ropes!
;Float toward the center of ring!
	WL	ANI_CODE,set_xdrift

	WL	ANI_CODE,DO_BACK_MESS

	WWLLW	ANI_SUPERSLAVE2,16,B4BB1X+FR2,#puppet_tbl,0
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_ZEROVELS
	.word	ANI_SOUND,82h			;Effort grunt

	WWLLW	ANI_SUPERSLAVE2,4,B4BB1X+FR3,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,B4BB1X+FR4,#puppet_tbl,2
	.word	ANI_SOUND,33h			;neck break (5-7 ticks late)
	WWLLW	ANI_SUPERSLAVE2,4,B4BB1X+FR5,#puppet_tbl,3
	.word	ANI_DAMAGEOPP,D_BACKBRKR

;Perhaps even shake ropes
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,50

	WL	ANI_CODE,CALL_SPECIAL_MOVE

	WL	ANI_SLAVEANIM,#bncoff_tbl

	.word	ANI_DETACH

	WL	30,B4BB1X+FR5
	WL	4,B4BB1X+FR6
	WL	4,B4BB1X+FR7
	WL	4,B4BB1X+FR8
	WL	4,B4BB1X+FR9

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	set_xdrift

;Float
;This could become a leap at position command
;Leap at the center of ring!

;Check to make sure I'm in ring!
	move	*a13(INRING),a1
	jrnz	#ok

	move	*a13(OBJ_XPOSINT),a0
	subi	RING_X_MID,a0
	abs	a0
	cmpi	60h,a0
	jrlt	#ok

	move	*a13(OBJ_XPOSINT),a0
	cmpi	RING_X_MID,a0
	jrgt	#onrgt

	movi	[3,0000h],a0
	move	a0,*a13(OBJ_XVEL),L
	rets
#onrgt
	movi	-[3,0000h],a0
	move	a0,*a13(OBJ_XVEL),L
#ok
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
	.ref	H3BR3Z
	.ref	H3DC3A
 LWWW H3BR3Z+FR4,-28,16,1
 LWWW H3DC3A+FR5,-9,32,1
 LWWW H3DC3A+FR5,-11,30,1
 LWWW H3BR3Z+FR1,4,-23,1
 .long 0
#Razor
	.ref	R3BR3Z
	.ref	R3FD3B
 LWWW R3BR3Z+FR1,-21,15,1
 LWWW R3FD3B+FR9,-15,18,1
; LWWW R3FD3B+FR6,-19,34,1
 LWWW R3FD3B+FR9,-15,18,1
 LWWW R3BR3Z+FR3,-15,-30,1
 .long 0
#Taker
	.ref	U3BR3Z
	.ref	U3CP3B
 LWWW U3BR3Z+FR1,-30,10,1
 LWWW U3BR3Z+FR2,-31,10,1
 LWWW U3CP3B+FR4,-28,36,0
 LWWW U3BR3Z+FR3,-18,-21,1
 .long 0
#Yokozuna
	.ref	Y3RL1A
	.ref	Y3CP3B
	.ref	Y3BR3Z
 LWWW Y3RL1A+FR3,-21,18,0
 LWWW Y3RL1A+FR2,-21,22,0
 LWWW Y3CP3B+FR1,-8,24,0
 LWWW Y3BR3Z+FR1,-21,-11,1
 .long 0
#Shawn
	.ref	S3RL3A
	.ref	S3BR3Z
 LWWW S3RL3A+FR3,-21,16,0
 LWWW S3RL3A+FR1,-25,14,0
 LWWW S3BR3Z+FR5,-23,19,1
 LWWW S3BR3Z+FR3,6,-27,1
 .long 0
#BamBam
	.ref	B3BR3Z
 LWWW B3BR3Z+FR11,-27,21,1
 LWWW B3BR3Z+FR12,-29,29,1
 LWWW B3BR3Z+FR13,-27,19,1
 LWWW B3BR3Z+FR14,-24,-8,1
 .long 0
#Doink
	.ref	D3UC3A
	.ref	D3BK3Z
 LWWW D3BK3Z+FR2,-15,11,1
 LWWW D3BK3Z+FR3,-9,20,1
 LWWW D3UC3A+FR5,-13,28,1
 LWWW D3BK3Z+FR7,-18,-30,1
 .long 0
#Adam
 .long 0
#Lex
	.ref	L3RL1A
	.ref	L3UC3A
	.ref	L3BR3Z
 LWWW L3RL1A+FR7,-29,16,0
 LWWW L3RL1A+FR9,-23,12,0
 LWWW L3UC3A+FR4,-21,24,1
 LWWW L3BR3Z+FR1,-14,-28,1
 .long 0

#bncoff_tbl
	.ref	hrt_backbroken_anim
	.ref	rzr_backbroken_anim
	.ref	und_backbroken_anim
	.ref	yok_backbroken_anim
	.ref	shn_backbroken_anim
	.ref	dnk_backbroken_anim
	.ref	lex_backbroken_anim

	.long	hrt_backbroken_anim
	.long	rzr_backbroken_anim
	.long	und_backbroken_anim
	.long	yok_backbroken_anim
	.long	shn_backbroken_anim
	.long	bam_backbroken_anim
	.long	dnk_backbroken_anim
	.long	0
	.long	lex_backbroken_anim


#*****************************************************************************
*
* END OF BACK BROKEN SEQ.

 SUBR	bam_backbroken_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_DETACH

	.word	ANI_GRAVITY_OFF
	WL	5,B3BR3Z+FR14
	.word	ANI_GRAVITY_ON

	WL	ANI_SET_YVEL,070000h
	WLW	ANI_SET_ZVEL,20000h,AM_ABS

;	WL	15,B3BR3Z+FR15
;	WL	4,B3BR3Z+FR16

	WL	25,B3BR3Z+FR14
	WL	4,B3BR3Z+FR16
	.word	ANI_XFLIP
	WL	2,B3RL1A+FR3



;	WL	3,B3RL1A+FR4
;	WL	3,B3RL1A+FR5
;	WL	3,B3RL1A+FR6
;	WL	3,B3RL1A+FR7

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_BOUNCE,2
	.word	ANI_DEBRIS,200,1,0,8,0		;%chance, tbl index, x,y,z off
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT

;	.word	ANI_XFLIP

	WL	3,B3MS3X+FR1
	WL	3,B3MS3X+FR2
	WL	3,B3MS3X+FR3

	.word	ANI_SETPLYRMODE,MODE_ONGROUND
;	.word	ANI_GETUP,100

;No stars around head here...

	.word	ANI_DETACH

	WL	20,B3RL1A+FR7

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_faceup_getup_anim
	.word	ANI_END

#*****************************************************************************
*
* NECK BREAKER

; SUBR	bam_neckbreaker_anim
;
;	.if	0
;
;	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
;	.word	ANI_ZEROVELS
;	.word	ANI_SETSPEED,100h
;
;	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
;
;	WL	6,B4GH3B+FR1
;	WL	6,B4GH3B+FR2
;	WL	6,B4GH3B+FR3
;	WL	6,B4GH3B+FR4
;
;	.word	ANI_ATTACK_ON, AMODE_PUPPET,13,90,71,16 ;mode,x,y,w,h
;	WL	6,B4GH3B+FR5
;	.word	ANI_ATTACK_OFF
;
;	WL	ANI_IFSTATUS,#gotim
;
;;missed
;	WL	ANI_CODE,CALL_MISSES
;	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
;
;	WL	6,B4GH3B+FR4
;	WL	6,B4GH3B+FR3
;	WL	6,B4GH3B+FR2
;	WL	6,B4GH3B+FR1
;
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END
;
;
;#gotim
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_KEEPATTACHED
;	.word	ANI_ATTACHZ,0,0,-4
;
;	WLW	ANI_SUPERSLAVE,#puppet_tbl,0
;	WL	6,B4GH3B+FR5
;	WLW	ANI_SUPERSLAVE,#puppet_tbl,1
;	WL	6,B4GH3B+FR6
;	WLW	ANI_SUPERSLAVE,#puppet_tbl,2
;	WL	6,B4GH3B+FR7
;	WLW	ANI_SUPERSLAVE,#puppet_tbl,3
;	WL	6,B3DD3B+FR1
;	WLW	ANI_SUPERSLAVE,#puppet_tbl,4
;	WL	6,B3DD3B+FR2
;	WLW	ANI_SUPERSLAVE,#puppet_tbl,5
;	WL	6,B3DD3B+FR3
;	WLW	ANI_SUPERSLAVE,#puppet_tbl,6
;	WL	6,B3DD3B+FR4
;	WLW	ANI_SUPERSLAVE,#puppet_tbl,7
;	WL	6,B3DD3B+FR5
;
;	WL	ANI_SET_YVEL,080000h
;
;	WLW	ANI_SUPERSLAVE,#puppet_tbl,8
;	WL	6,B3DD3B+FR6
;	WLW	ANI_SUPERSLAVE,#puppet_tbl,9
;	WL	6,B3DD3B+FR8
;	WLW	ANI_SUPERSLAVE,#puppet_tbl,10
;	WL	6,B3DD3B+FR9
;
;	.word	ANI_WAITHITGND
;	.word	ANI_ZEROVELS
;
;	WLW	ANI_SUPERSLAVE,#puppet_tbl,11
;	WL	6,B3DD3B+FR11
;
;	WL	ANI_SLAVEANIM,#slaveanim_tbl
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
;
;	WL	6,B3DD3B+FR12
;	WL	6,B3GU4A+FR4
;	WL	6,B3GU4A+FR5
;	WL	6,B3GU4A+FR6
;	WL	6,B3GU4A+FR7
;	WL	6,B3GU4A+FR8
;	WL	6,B3GU4A+FR9
;
;	.word	ANI_DETACH
;
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END
;
;
;#slaveanim_tbl
; .long 0			;Bret
; .long 0			;Razor
; .long 0			;Taker
; .long 0			;Yokozuna
; .long 0			;Shawn
; .long bam_neckbroken_anim	;BamBam
; .long 0			;Doink
; .long 0			;Adam
; .long 0			;Lex
;
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
;#Bret
; .long 0
;#Razor
; .long 0
;#Taker
; LWWW U4BF3A+FR1,79,0,1
; LWWW U4BF3A+FR2,84,-2,1
; LWWW U4BF3A+FR3,85,8,1
; LWWW U3DD3B+FR1,70,10,1
; LWWW U3DD3B+FR2,84,8,1
; LWWW U3DD3B+FR3,90,10,1
; LWWW U3DD3B+FR4,78,6,1
; LWWW U3DD3B+FR5,75,5,1
; LWWW U3DD3B+FR6,74,9,1
; LWWW U3DD3B+FR6,82,9,1
; LWWW U3DD3B+FR7,89,11,1
; LWWW U3DD3B+FR9,113,1,1
;#Yokozuna
; .long 0
;#Shawn
; .long 0
;#BamBam
; LWWW B4BF3A+FR1,86,4,0
; LWWW B4BF3A+FR2,86,4,0
; LWWW B4BF3A+FR3,84,4,0
; LWWW B3DD3D+FR1,86,4,1
; LWWW B3DD3D+FR2,81,3,1
; LWWW B3DD3D+FR3,92,2,1
; LWWW B3DD3D+FR4,88,-7,1
; LWWW B3DD3D+FR5,92,-8,1
; LWWW B3DD3D+FR6,100,3,1
; LWWW B3DD3D+FR6,103,10,1
; LWWW B3DD3D+FR7,118,21,1
; LWWW B3DD3D+FR10,148,-8,1
;#Doink
; .long 0
;#Adam
; .long 0
;#Lex
; .long 0
;
;	.endif
;

#*****************************************************************************
*
* END OF NECK BROKEN SEQ.

 SUBR	bam_neckbroken_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,060000h
;;	WLW	ANI_SET_ZVEL,20000h,AM_ABS

	.word	ANI_XFLIP

	WL	3,B3CP3B+FR4
	WL	6,B3CP3B+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	5,B3CP3B+FR6
	WL	5,B3CP3B+FR7

	WL	10,B3RL1A+FR1		;1st frame of roll

	.word	ANI_DETACH
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_faceup_getup_anim
	.word	ANI_END

#*****************************************************************************
*
* POGO STICK HEAD CRUNCHER

 SUBR	bam_pogo_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

;Put cool cheers here
;	.word	ANI_CHEER,3
	.word	ANI_ATTACK_ON, AMODE_PUPPET,32,25,42h,21 ;mode,x,y,w,h

;#contpd
	WWL	ANI_WAITHITOPP,4,B3PG3A+FR1
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;Check to see if I have tried to pile drive Yokozuna!

;FIX!! Yoko check
;	WL	ANI_CODE,is_this_yoko
;	WL	ANI_IFSTATUS,#yoko_miss

;got him
	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SOUND,82h			;Effort grunt

	WWLLW	ANI_SUPERSLAVE2,4,B3PG3A+FR1,#puppet_tbl,0
	.word	ANI_WAITHITGND
	WWLLW	ANI_SUPERSLAVE2,20,B3PG3A+FR1,#puppet_tbl,0

	WWLLW	ANI_SUPERSLAVE2,5,B3PG3A+FR2,#puppet_tbl,1

	WL	ANI_SET_YVEL,60000h
	WLW	ANI_SET_ZVEL,-28000h,AM_ABS
;Float toward the center of ring!
;	WL	ANI_CODE,set_xdrift

	WWLLW	ANI_SUPERSLAVE2,5,B3PG3A+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,5,B3PG3A+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,7,B3PG3A+FR5,#puppet_tbl,4

	.word	ANI_SET_RPTCOUNT,4	;3 times
	.word	ANI_CLR_BUTCOUNT

;Place opponent in front of me in z

	.word	ANI_ATTACHZ,0,0,4
	WLW	ANI_ATTCHIMAGE,BCDARM+FR2,10
	WWLLW	ANI_SUPERSLAVE2,1,B4CD3B+FR2,#puppet_tbl,5

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WLW	ANI_ATTCHIMAGE,BCDARM+FR4,10
	WWLLW	ANI_SUPERSLAVE2,1,B4CD3B+FR4,#puppet_tbl,6
	WLW	ANI_ATTCHIMAGE,BCDARM+FR5,10
	WWLLW	ANI_SUPERSLAVE2,1,B4CD3B+FR5,#puppet_tbl,7
	WLW	ANI_ATTCHIMAGE,BCDARM+FR6,10
	WWLLW	ANI_SUPERSLAVE2,1,B4CD3B+FR6,#puppet_tbl,8
	WLW	ANI_ATTCHIMAGE,BCDARM+FR8,10
	WWLLW	ANI_SUPERSLAVE2,1,B4CD3B+FR8,#puppet_tbl,9

	WLW	ANI_ATTCHIMAGE,BCDARM+FR8,10
	WWLLW	ANI_SUPERSLAVE2,4,B4CD3B+FR8,#puppet_tbl,10

	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_POGO1

	WL	ANI_CODE,CALL_SPECIAL_MOVE
;	WL	ANI_CODE,#set_opp_xflip

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,3,#letgo
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#rpt_loop
#letgo
	WL	ANI_SLAVEANIM,#rollout_tbl
	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_DETACH
	WLW	ANI_ATTCHIMAGE,0,0		;Turn it off
	WL	20,B4CF4A+FR9

	.word	ANI_WAITHITGND
	WL	4,B3PO4E+FR2
	WL	4,B3PO4E+FR3
	WL	4,B3PO4E+FR4

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WL	4,B3PG3A+FR1
	WL	4,B3PG3A+FR2
	WL	4,B3PG3A+FR3
	WL	4,B3PG3A+FR4

#cont	WL	ANI_SET_YVEL,30000h

	WL	3,B3PG3A+FR5
	.word	ANI_OFFSET,0,26,0			;x,y,z

	WL	4,B4CD3A+FR3
	WL	4,B4CD3A+FR4
	WL	4,B4CD3A+FR5

;	WL	ANI_SET_YVEL,-20000h

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

;Maybe do a bounce

	;impact
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30

	WL	4,B4CD3A+FR6

;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
;	WL	18,D4HS3B+FR8

	WL	4,B4CD3A+FR6

	WLW	ANI_SET_ZVEL,-10000h,AM_ABS

	WL	3,B3PG3A+FR9
	WL	3,B3PG3A+FR10
	WL	3,B3PG3A+FR11
	WL	3,B3PG3A+FR12

	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#rpt_loop
	.word	ANI_CLR_BUTCOUNT

	WL	ANI_SET_YVEL,60000h

	WLW	ANI_ATTCHIMAGE,BCDARM+FR8,10
	WWLLW	ANI_SUPERSLAVE2,3,B4CD3B+FR8,#puppet_tbl,10
	WLW	ANI_ATTCHIMAGE,BCDARM+FR8,10
	WWLLW	ANI_SUPERSLAVE2,3,B4CD3B+FR8,#puppet_tbl,9
	WLW	ANI_ATTCHIMAGE,BCDARM+FR6,10
	WWLLW	ANI_SUPERSLAVE2,3,B4CD3B+FR6,#puppet_tbl,8
	WLW	ANI_ATTCHIMAGE,BCDARM+FR5,10
	WWLLW	ANI_SUPERSLAVE2,3,B4CD3B+FR5,#puppet_tbl,7
	WLW	ANI_ATTCHIMAGE,BCDARM+FR4,10
	WWLLW	ANI_SUPERSLAVE2,3,B4CD3B+FR4,#puppet_tbl,6
	WLW	ANI_ATTCHIMAGE,BCDARM+FR2,10
	WWLLW	ANI_SUPERSLAVE2,3,B4CD3B+FR2,#puppet_tbl,5

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WLW	ANI_ATTCHIMAGE,BCDARM+FR4,10
	WWLLW	ANI_SUPERSLAVE2,1,B4CD3B+FR4,#puppet_tbl,6
	WLW	ANI_ATTCHIMAGE,BCDARM+FR5,10
	WWLLW	ANI_SUPERSLAVE2,1,B4CD3B+FR5,#puppet_tbl,7
	WLW	ANI_ATTCHIMAGE,BCDARM+FR6,10
	WWLLW	ANI_SUPERSLAVE2,1,B4CD3B+FR6,#puppet_tbl,8
	WLW	ANI_ATTCHIMAGE,BCDARM+FR8,10
	WWLLW	ANI_SUPERSLAVE2,1,B4CD3B+FR8,#puppet_tbl,9
	WLW	ANI_ATTCHIMAGE,BCDARM+FR8,10
	WWLLW	ANI_SUPERSLAVE2,4,B4CD3B+FR8,#puppet_tbl,10

	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,20
	.word	ANI_DAMAGEOPP,D_POGO2

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,3,#letgo
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#rpt_loop
	WL	ANI_GOTO,#letgo

#set_opp_xflip
	move	*a13(ATTACH_PROC),a0,L

	move	*a0(OBJ_CONTROL),a14
	xori	M_FLIPH,a14
	move	a14,*a0(OBJ_CONTROL)

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

	.ref	H3BF3A,H3PP3X,H4POGO
	.ref	R3BF3A,R3GP3Z,R4POGO
	.ref	U4BF3Z,U3PP3X,U3GP3X,U4POGO
	.ref	Y3BF3A,Y3PP3Q,Y3FD3N,Y4POGO
	.ref	S3BF3A,S3GP3X,S3OS3X,S3FD3X,S4POGO
 	.ref	D3BF3A,D3PD3Z,D4POGO
	.ref	L3BF3B,L3GP3Z,L3FH3A,L3FD3B,L4POGO
;	.ref	B4AM4A,B3PP3Q,B4POGO,B4PO00

#Bret
 LWWW H3BF3A+FR3,38,-13,0
 LWWW H3PP3X+FR1,18,-32,0
 LWWW H3PP3X+FR2,9,7,0
 LWWW H3PP3X+FR3,19,43,0
 LWWW H3PP3X+FR6,18,36,0

 LWWW H4POGO+FR1,26,50,1
 LWWW H4POGO+FR1,29,51,1
 LWWW H4POGO+FR1,28,56,1
 LWWW H4POGO+FR1,28,50,1
 LWWW H4POGO+FR2,-3,20,1
 LWWW H4POGO+FR3,-9,9,1
 .long 0
#Razor
 LWWW R3BF3A+FR9,39,-18,0
 LWWW R3GP3Z+FR1,25,-29,0
 LWWW R3GP3Z+FR2,21,-22,0
 LWWW R3GP3Z+FR4,37,44,0
 LWWW R3GP3Z+FR5,32,44,0

 LWWW R4POGO+FR3,-1,44,1
 LWWW R4POGO+FR3,0,44,1
 LWWW R4POGO+FR3,-4,50,1
 LWWW R4POGO+FR3,-3,48,1
 LWWW R4POGO+FR4,-15,23,1
 LWWW R4POGO+FR5,-21,2,1
 .long 0
#Taker
 LWWW U4BF3Z+FR1,37,-12,0
 LWWW U3PP3X+FR1,23,-25,1
 LWWW U3PP3X+FR2,24,-15,1
 LWWW U3PP3X+FR4,17,18,1
 LWWW U3PP3X+FR6,28,58,1

 LWWW U4POGO+FR1,16,59,1
 LWWW U4POGO+FR1,17,61,1
 LWWW U4POGO+FR1,16,69,1
 LWWW U4POGO+FR1,18,64,1
 LWWW U4POGO+FR3,-16,12,1
 LWWW U4POGO+FR4,-19,-3,1
 .long 0
#Yokozuna
 LWWW Y3BF3A+FR11,46,-7,0
 LWWW Y3PP3Q+FR1,24,-22,0
 LWWW Y3PP3Q+FR3,25,-11,0
 LWWW Y3PP3Q+FR4,35,3,0
 LWWW Y3PP3Q+FR7,25,21,0

 LWWW Y4POGO+FR1,13,44,1
 LWWW Y4POGO+FR1,14,46,1
 LWWW Y4POGO+FR1,11,54,1
 LWWW Y4POGO+FR1,11,53,1
 LWWW Y4POGO+FR3,4,21,1
 LWWW Y4POGO+FR4,-4,7,1
 .long 0
#Shawn
 LWWW S3BF3A+FR5,29,-27,0
 LWWW S3GP3X+FR1,30,-31,0
 LWWW S3GP3X+FR2,23,-21,0
 LWWW S3GP3X+FR3,27,5,0
 LWWW S3GP3X+FR5,30,40,0

 LWWW S4POGO+FR1,20,49,1
 LWWW S4POGO+FR1,21,49,1
 LWWW S4POGO+FR1,17,57,1
 LWWW S4POGO+FR1,17,54,1
 LWWW S4POGO+FR2,0,26,1
 LWWW S4POGO+FR3,-9,-1,1
 .long 0
#BamBam
 LWWW B4AM4A+FR5,41,-13,0
 LWWW B3PP3Q+FR1,23,-32,0
 LWWW B3PP3Q+FR2,23,-14,0
 LWWW B3PP3Q+FR3,27,12,0
 LWWW B3PP3Q+FR5,33,34,0

 LWWW B4POGO+FR5,16,60,1
 LWWW B4POGO+FR5,17,63,1
 LWWW B4POGO+FR5,15,69,1
 LWWW B4POGO+FR5,17,64,1
 LWWW B4POGO+FR3,-7,32,1
 LWWW B4POGO+FR4,-11,1,1

 .long 0
#Doink
 LWWW D3BF3A+FR1,40,-14,0
 LWWW D3PD3Z+FR1,29,-36,1
 LWWW D3PD3Z+FR2,24,-14,1
 LWWW D3PD3Z+FR3,26,16,1
 LWWW D3PD3Z+FR6,34,39,1

 LWWW D4POGO+FR2,11,55,1
 LWWW D4POGO+FR2,12,58,1
 LWWW D4POGO+FR2,9,63,1
 LWWW D4POGO+FR2,9,58,1
 LWWW D4POGO+FR3,-3,29,1
 LWWW D4POGO+FR4,-15,7,1
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3BF3B+FR1,27,-21,0
 LWWW L3GP3Z+FR1,25,-29,0
 LWWW L3GP3Z+FR2,23,-13,0
 LWWW L3GP3Z+FR4,29,23,0
 LWWW L3GP3Z+FR6,30,36,0

 LWWW L4POGO+FR1,13,54,1
 LWWW L4POGO+FR1,15,56,1
 LWWW L4POGO+FR1,13,61,1
 LWWW L4POGO+FR1,15,59,1
 LWWW L4POGO+FR3,9,30,1
 LWWW L4POGO+FR4,-8,11,1
 .long 0

	.ref	hrt_break_neck3_anim
	.ref	shn_break_neck4_anim
	.ref	dnk_break_neck3_anim
	.ref	und_break_neck3_anim
	.ref	lex_break_neck3_anim
	.ref	rzr_break_neck3_anim
	.ref	yok_break_neck3_anim

#rollout_tbl
	.long	hrt_break_neck3_anim,rzr_break_neck3_anim
	.long	und_break_neck3_anim
	.long	yok_break_neck3_anim
	.long	shn_break_neck4_anim,bam_break_neck3_anim
	.long	dnk_break_neck3_anim,0,lex_break_neck3_anim


#*****************************************************************************
*
* CLIMB UP TURNBUCKLES

 SUBR	bam_climb_up_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	4,B4HU4B+FR7
	WL	4,B4HU4B+FR8
	WL	4,B4HU4B+FR9

	.word	ANI_OFFSET,0,20,0

	WL	ANI_CODE,tgt_tbukl
	.word	ANI_LEAPATPOS,20,200,10,4,0	;#ticks,dist,xoff,yoff,zoff
	WL	20,B4HU4B+FR11

	.word	ANI_SETPLYRMODE,MODE_ONTURNBKL
	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE | MODE_NOGRAVITY
	.word	ANI_SHAKECORNER
	.word	ANI_ZEROVELS
	WL	4,B4HU4B+FR12

	WL	5,B4SB4A+FR1
	WL	5,B4SB4A+FR2
	WL	5,B4SB4A+FR3
	WL	5,B4SB4A+FR4
	WL	5,B4SB4A+FR5
	WL	5,B4SB4A+FR6
	WL	5,B4SB4A+FR7
	WL	5,B4SB4A+FR8
	WL	5,B4SB4A+FR9
#repeat
	WL	7,B4SB4A+FR10
	WL	ANI_CODE,tbukl_flip
	WL	7,B4SB4A+FR9
	WL	ANI_CODE,tbukl_flip
	WL	7,B4SB4A+FR8
	WL	ANI_CODE,tbukl_flip
	WL	7,B4SB4A+FR7
	WL	ANI_CODE,tbukl_flip
	WL	7,B4SB4A+FR8
	WL	ANI_CODE,tbukl_flip
	WL	7,B4SB4A+FR9
	WL	ANI_CODE,tbukl_flip
	WL	ANI_GOTO,#repeat
	

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* CLIMB DOWN TURNBUCKLES

 SUBR	bam_climb_down_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SHAKECORNER
;	WL	4,B4SB4A+FR7
;	WL	4,B2JD4A+FR1
	WL	4,B2JD4A+FR2

	WLW	ANI_SET_XVEL,18000h,AM_FACE_REL
	WLW	ANI_SET_ZVEL,10000h,AM_ABS
	WL	ANI_SET_YVEL,20000h

	.word	ANI_GRAVITY_ON
	WL	4,B2JD4A+FR3
	WL	4,B2JD4A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_SHAKECORNER

	WL	4,B2JD4A+FR6
	WL	4,B2JD4A+FR8
	WL	4,B2JD4A+FR9

	.word	ANI_FACEDOWN

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* GET BUZZED FROM DOINK

 SUBR	bam_get_buzz_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;	.word	ANI_XFLIP
	.word	ANI_GRAVITY_OFF

	WL	ANI_CODE,set_position

	WL	ANI_CODE,set_skeleton_pal
	WL	2,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,B4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	ANI_CODE,make_white
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_norm
	WL	ANI_CODE,set_my_pal
	WL	3,B4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,B4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_white
	WL	3,B4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,B4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,B4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	ANI_CODE,make_white
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_norm
	WL	ANI_CODE,set_my_pal
	WL	3,B4BZ4A+FR1

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
	WL	3,B4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,B4BZ4A+FR1
	WL	ANI_CODE,#make_black
	WL	3,B4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,B4BZ4A+FR1
	WL	ANI_CODE,#make_black
	WL	3,B4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,B4BZ4A+FR1

	.word	ANI_WAITHITGND
	.word	ANI_XFLIP
	.word	ANI_FACEDOWN
	.word	ANI_OFFSET,-20,0,0			;x,y,z

	WL	1,B4ST4Z+FR1

	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	.ref	bam_fall_back_anim

	WL	ANI_CHANGEANIM,bam_fall_back_anim
	.word	ANI_END

#nodead

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#make_black

;This is a black color within the wrestler's pal.  It is different for each
;wrestler.
	movi	0b0bh,a14

	move	a14,*a13(OBJ_CONST)
	move	*a13(OBJ_CONTROL),a14
	andni	01111b,a14
	ori	M_CONNON,a14
	move	a14,*a13(OBJ_CONTROL)
	rets


#*****************************************************************************

 SUBR	bam_3_head_held_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_HEADHELD
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim

;	WL	4,D3BF3Z+FR1
;	WL	4,D3BF3Z+FR2

	.word	ANI_SETWORD,USR_VAR1,0		;loop count

#loop
	WL	4,B3BF3C+FR5
	WL	4,B3BF3C+FR6
	WL	4,B3BF3C+FR7
	WL	4,B3BF3C+FR8
	WL	4,B3BF3C+FR9
	WL	4,B3BF3C+FR1
	WL	4,B3BF3C+FR2
	WL	4,B3BF3C+FR3
	WL	4,B3BF3C+FR4
	WL	ANI_CODE,#inc_loop
	WL	ANI_IFNOTSTATUS,#loop

;Continue into break...

 SUBR	bam_3_head_held_brk_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WLW	ANI_SET_XVEL,-38000h,AM_NEWFACE_REL
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	WL	4,B3BF3C+FR5
	.word	ANI_DETACH

;Standard #2 head hit from spin kick
	WL	3,B2AH2A+FR4
	WL	3,B2AH2A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,B2AH2A+FR6

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


;Loop 4 times, then break out!
#inc_loop
	move	*a13(USR_VAR1),a0
	inc	a0
	move	a0,*a13(USR_VAR1)
	cmpi	2,a0
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

 SUBR	bam_3_head_held_stand_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	3,B3BF3C+FR5
	WL	3,B1TT5Z+FR2	;2.5
	.word	ANI_DETACH

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* ROLL OVER AND BREAK YER STINKIN' NECK

 SUBR	bam_break_neck2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,60000h
	WLW	ANI_SET_ZVEL,8000h,AM_ABS

	.ref	ckzpos
	WL	ANI_CODE,ckzpos

	.word	ANI_XFLIP
;	.word	ANI_OFFSET,25,0,0
	.word	ANI_DEBRIS,300,5,0,-5,0	;%chance, tbl index, x,y,z off
	WL	6,B3FD3C+FR1
	WL	8,B3FD3C+FR2
	WL	3,B3FD3C+FR3
	WL	3,B3FD3C+FR4
	WL	3,B3FD3C+FR5
	.word	ANI_WAITHITGND
	WL	4,B3FD3C+FR5

	;hit.  stay.
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_OFFSET,-30,0,0
	.word	ANI_ZEROVELS

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	23,B3RL1A+FR7
	.word	ANI_WAITROLL

	.word	ANI_OFFSET,10,0,-6
	.ref	bam_4_faceup_getup_anim
	WL	ANI_CHANGEANIM,bam_4_faceup_getup_anim
	.word	ANI_END

 SUBR	bam_break_neck3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,58000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	.ref	ckzpos
	WL	ANI_CODE,ckzpos

	.word	ANI_DEBRIS,300,5,0,-5,0	;%chance, tbl index, x,y,z off

	WL 	15,B4POGO+FR4
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_XFLIP
	WL	3,B3FD3C+FR3
	WL	3,B3FD3C+FR4
	WL	3,B3FD3C+FR5

	;hit.  stay.
 
	.word	ANI_OFFSET,-30,0,0
	.word	ANI_ZEROVELS

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	23,B3RL1A+FR7
	.word	ANI_WAITROLL

	.word	ANI_OFFSET,10,0,-6
	.ref	bam_4_faceup_getup_anim

	WL	ANI_CHANGEANIM,bam_4_faceup_getup_anim
	.word	ANI_END

 SUBR	bam_break_neck4_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,60000h
	WL	ANI_CODE,ckzpos

	WWWL	ANI_IFROPE,RC_EITHER,100,#fall_back4

	WL	4,B4UC3B+FR6
	WL	4,B3FD3C+FR2
	WL	4,B3FD3C+FR3
	WL	4,B3FD3C+FR4
	WL	4,B3FD3C+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_4_faceup_getup_anim

#fall_back4
	WL	4,B4UC3B+FR6
	WL	4,B4UC3B+FR7
	WL	4,B4UC3B+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_4_faceup_getup_anim



 SUBR	bam_break_neck_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WWWL	ANI_IFROPE,RC_EITHER,100,#fall_back

	;plenty of room.  fall over.
	.word	ANI_OFFSET,20,0,0
	WL	5,B3FD3C+FR4
	.word	ANI_OFFSET,13,0,0
	WL	5,B3FD3C+FR5
	.word	ANI_OFFSET,51,0,0
	WL	5,B3RL1A+FR7
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_4_faceup_getup_anim

#fall_back
	;no room.  roll back onto yer back.
	.word	ANI_OFFSET,14,0,0
	WL	5,B4TD3B+FR7
	.word	ANI_OFFSET,-12,0,0
	WL	5,B4TD3B+FR8
	.word	ANI_OFFSET,-26,0,0
	WL	5,B4UC3B+FR7
	.word	ANI_OFFSET,-16,0,0
	.word	ANI_XFLIP
	WL	10,B3RL1A+FR1
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_4_faceup_getup_anim


#******************************************************************************

 SUBR	bam_2_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_STARTATTACK,AT_PUPPET,16
	WL	2,B1TT5Z+FR2	;2.5
	WL	2,B1TT5Z+FR3	;3.5

 SUBR	bam_4_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_STARTATTACK,AT_PUPPET,12

;Put cool cheers here
;	.word	ANI_CHEER,3

	WL	4,B4WS4A+FR1

	LEAPATOPP 8,999,80,80,30000h,TGT_HEAD,26,6,-2
	WL	4,B4WS4A+FR2
	WL	4,B4WS4A+FR3
	.word	ANI_ZERO_XZVELS

	.word	ANI_ATTACK_ON, AMODE_PUPPET,25,0,25,22 ;mode,x,y,w,h
	WL	4,B4WS4A+FR4
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;got him
	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WL	ANI_CODE,CALL_SETUP

	.word	ANI_SOUND,33h			;neck break (5-7 ticks late)

	WWLLW	ANI_SUPERSLAVE2,4,B4WS4A+FR4,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,B4GH3D+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,B4GH3D+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,B4GH3D+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,B4GH3D+FR5,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,B4GH3D+FR5,#puppet_tbl,5

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	3,B4GH3D+FR5
	.word	ANI_CLROPPMODE,MODE_GHOST

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
	WL	20,B4WS4A+FR4
	WL	4,B4WS4A+FR3
	WL	4,B4WS4A+FR2
	WL	4,B4WS4A+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


	.ref	rzr_3_head_held_anim
;	.ref	bam_3_head_held_anim
	.ref	und_3_head_held_anim
	.ref	yok_3_head_held_anim
	.ref	hrt_3_head_held_anim
	.ref	lex_3_head_held_anim
	.ref	shn_3_head_held_anim
	.ref	dnk_3_head_held_anim

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

	.ref	H3GU4A,H3DU3A,H3BF3A
	.ref	R3GU4A,R3DU3B,R3BF3A
	.ref	U3DU3B,U4BF3Z
	.ref	Y3GU2A,Y3BF3A
	.ref	S3GU4A,S3DU3A,S3BF3A
	.ref	B3GU4A,B3DU3A,B3BF3C
	.ref	D3DU3A,D3HT3Z,D3BF3A
	.ref	L3DU3A,L3BF3B

#Bret
 LWWW H3GU4A+FR1,33,-42,0
 LWWW H3GU4A+FR3,62,-31,0
 LWWW H3DU3A+FR3,59,-38,1
 LWWW H3DU3A+FR4,64,-36,1
 LWWW H3DU3A+FR5,63,-33,1
 LWWW H3BF3A+FR1,60,-34,0
 .long 0
#Razor
 LWWW R3GU4A+FR2,41,-43,1
 LWWW R3GU4A+FR3,46,-31,0
 LWWW R3GU4A+FR5,59,-44,0
 LWWW R3DU3B+FR2,59,-48,1
 LWWW R3DU3B+FR4,60,-31,1
 LWWW R3BF3A+FR4,64,-35,0
 .long 0
#Taker
 LWWW U3DU3B+FR2,39,-40,1
 LWWW U3DU3B+FR5,36,-29,1
 LWWW U3DU3B+FR6,49,-44,1
 LWWW U3DU3B+FR8,60,-40,1
 LWWW U3DU3B+FR10,56,-27,1
 LWWW U4BF3Z+FR5,64,-14,0
 .long 0
#Yokozuna
 LWWW Y3GU2A+FR1,45,-28,0
 LWWW Y3GU2A+FR3,53,-16,0
 LWWW Y3GU2A+FR6,32,-43,0
 LWWW Y3GU2A+FR9,55,-45,0
 LWWW Y3GU2A+FR12,61,-31,0
 LWWW Y3BF3A+FR1,65,-24,0
 .long 0
#Shawn
 LWWW S3GU4A+FR1,39,-42,1
 LWWW S3GU4A+FR2,47,-26,0
 LWWW S3GU4A+FR4,64,-43,0
 LWWW S3GU4A+FR5,59,-39,0
 LWWW S3DU3A+FR2,60,-42,1
 LWWW S3BF3A+FR1,50,-34,0
 .long 0
#BamBam
 LWWW B3GU4A+FR3,46,-30,0
 LWWW B3GU4A+FR4,50,-24,0
 LWWW B3GU4A+FR6,58,-34,0
 LWWW B3GU4A+FR7,59,-50,0
 LWWW B3DU3A+FR2,60,-33,1
 LWWW B3BF3C+FR5,69,-28,0
 .long 0
#Doink
 LWWW D3DU3A+FR2,41,-36,1
 LWWW D3DU3A+FR3,53,-25,1
 LWWW D3DU3A+FR5,49,-39,1
 LWWW D3DU3A+FR8,55,-47,1
 LWWW D3HT3Z+FR1,56,-34,1
 LWWW D3BF3A+FR2,62,-34,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3DU3A+FR2,50,-39,1
 LWWW L3DU3A+FR4,33,-18,1
 LWWW L3DU3A+FR6,37,-39,1
 LWWW L3DU3A+FR7,52,-34,1
 LWWW L3DU3A+FR9,65,-39,1
 LWWW L3BF3B+FR2,65,-38,0
 .long 0


#******************************************************************************

 SUBR	bam_4_taunt_anim

	.word	ANI_SETMODE,MODE_UNINT
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	4,B4SW4B+FR3
	WL	4,B4SW4B+FR4
	WL	4,B4SW4B+FR5
	WL	4,B4SW4B+FR6
	WL	4,B4SW4B+FR7
	WL	4,B4SW4B+FR8

	WL	4,B4SW4B+FR3
	WL	4,B4SW4B+FR4
	WL	4,B4SW4B+FR5
	WL	4,B4SW4B+FR6
	WL	4,B4SW4B+FR7
	WL	4,B4SW4B+FR8

	WL	4,B4SW4B+FR3
	WL	4,B4SW4B+FR4
	WL	4,B4SW4B+FR5
	WL	4,B4SW4B+FR6
	WL	4,B4SW4B+FR7
	WL	4,B4SW4B+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.ref	bam_stand4_anim
	WL	ANI_CHANGEANIM,bam_stand4_anim
	.word	ANI_END

#*****************************************************************************
*
* Head slams into mat
;From head slam - repeated head slam

 SUBR	bam_break_face2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS

	WL	2,B3RL1A+FR7		;Face down
	WL	ANI_SET_YVEL,80000h
	WL	4,B3MS3X+FR1
	WL	4,B3MS3X+FR2
	WL	4,B3MS3X+FR3
	.word	ANI_WAITHITGND
	.word	ANI_END
	

* Head slams into mat
;From head slam

 SUBR	bam_break_face_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS

	WL	2,B3RL1A+FR7		;Face down
	WL	ANI_SET_YVEL,40000h
	WL	4,B3MS3X+FR1
	WL	4,B3MS3X+FR2
	WL	4,B3MS3X+FR3
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	.ref	SMALL_BOUNCE
;	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	4,B3MS3X+FR1
	WL	4,B3MS3X+FR2
	WL	4,B3MS3X+FR3

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	2,B3RL1A+FR7		;Face down
	.word	ANI_WAITROLL

	WL	ANI_CHANGEANIM,bam_4_faceup_getup_anim
	.word	ANI_END


 SUBR	bam_3_pile_driver_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

;Put cool cheers here
;	.word	ANI_CHEER,3
	.word	ANI_ATTACK_ON, AMODE_PUPPET,32,25,42h,21 ;mode,x,y,w,h

;#contpd
	WWL	ANI_WAITHITOPP,4,B3PG3A+FR1
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;Check to see if I have tried to pile drive Yokozuna!

;FIX!! Yoko check
;	WL	ANI_CODE,is_this_yoko
;	WL	ANI_IFSTATUS,#yoko_miss

;got him
	WL	ANI_CODE,DO_PILE_MESS

	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SOUND,82h			;Effort grunt

	WWLLW	ANI_SUPERSLAVE2,4,B3PG3A+FR1,#puppet_tbl,0
	.word	ANI_WAITHITGND
	WWLLW	ANI_SUPERSLAVE2,20,B3PG3A+FR1,#puppet_tbl,0

	WWLLW	ANI_SUPERSLAVE2,5,B3PG3A+FR2,#puppet_tbl,1

;	WL	ANI_SET_YVEL,30000h
	WL	ANI_SET_YVEL,70000h
;Float toward the center of ring!
	WL	ANI_CODE,set_xdrift

	WWLLW	ANI_SUPERSLAVE2,5,B3PG3A+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,5,B3PG3A+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,5,B3PG3A+FR5,#puppet_tbl,4

;Mess with the physics!

;	WL	ANI_SET_YVEL,-20000h

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

;	WWLLW	ANI_SUPERSLAVE2,2,B3PG3A+FR5,#puppet_tbl,4	;13
	WWLLW	ANI_SUPERSLAVE2,2,B4CD3A+FR3,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,2,B4CD3A+FR4,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,2,B4CD3A+FR5,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,2,B4CD3A+FR6,#puppet_tbl,8
	WWLLW	ANI_SUPERSLAVE2,2,B3PG3A+FR9,#puppet_tbl,9

	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_PILEDRIVER

	WL	ANI_CODE,CALL_SPECIAL_MOVE
	WL	ANI_CODE,#set_opp_xflip

	WL	ANI_SLAVEANIM,#rollout_tbl
	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_DETACH

	WL	20,B3PG3A+FR9
	WLW	ANI_SET_ZVEL,-10000h,AM_ABS
	WL	3,B3PG3A+FR10
	WL	3,B3PG3A+FR11
	WL	3,B3PG3A+FR12

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

;#yoko_miss
;;Cause Yoko to stand up out of his head hold and break free
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
;
;	WL	ANI_CODE,CALL_MISS_YOKO
;
;	WL	3,D3PP3Z+FR1
;	WL	3,D3PP3Z+FR2
;	WL	3,D3PP3Z+FR3
;	WL	3,D3PP3Z+FR4
;	WL	ANI_CODE,#break
;	WL	ANI_GOTO,#cont
;

#missed
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WL	4,B3PG3A+FR1
	WL	4,B3PG3A+FR2
	WL	4,B3PG3A+FR3
	WL	4,B3PG3A+FR4

#cont	WL	ANI_SET_YVEL,30000h

	WL	3,B3PG3A+FR5
	.word	ANI_OFFSET,0,26,0			;x,y,z

	WL	4,B4CD3A+FR3
	WL	4,B4CD3A+FR4
	WL	4,B4CD3A+FR5

;	WL	ANI_SET_YVEL,-20000h

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

;Maybe do a bounce

	;impact
;	WL	ANI_CODE,SMALL_BOUNCE
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30

	WL	4,B4CD3A+FR6

;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
;	WL	18,D4HS3B+FR8

	WL	4,B4CD3A+FR6

	WLW	ANI_SET_ZVEL,-10000h,AM_ABS

	WL	3,B3PG3A+FR9
	WL	3,B3PG3A+FR10
	WL	3,B3PG3A+FR11
	WL	3,B3PG3A+FR12

	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#set_opp_xflip
	move	*a13(ATTACH_PROC),a0,L

	move	*a0(OBJ_CONTROL),a14
	xori	M_FLIPH,a14
	move	a14,*a0(OBJ_CONTROL)

	rets

;Check to see if I have tried to pile drive Yokozuna!

; SUBR	is_this_yoko
;
;	move	*a13(ATTACH_PROC),a0,L
;	move	*a0(WRESTLERNUM),a0
;	cmpi	3,a0
;	jrnz	#ok
;
;;Yes, this is Yoko!
;
;	move	*a13(ANIMODE),a1
;	ori	MODE_STATUS,a1
;	move	a1,*a13(ANIMODE)
;	rets
;#ok
;	move	*a13(ANIMODE),a1
;	andni	MODE_STATUS,a1
;	move	a1,*a13(ANIMODE)
;	rets
;
;;For Yoko breaking free
;#break
;	move	*a13(ATTACH_PROC),a2,L
;	.ref	yok_3_head_held_brk_anim
;	movi	yok_3_head_held_brk_anim,a0
;;a0 = * animation script
;;a2 = * wrestler process
;	.ref	change_anim_anim
;	calla	change_anim_anim
;	rets


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

	.ref	H3BF3A,H3PP3X
	.ref	R3BF3A,R3GP3Z
	.ref	U4BF3Z,U3PP3X,U3GP3X
	.ref	Y3BF3A,Y3PP3Q,Y3FD3N
	.ref	S3BF3A,S3GP3X,S3OS3X,S3FD3X
 	.ref	B4AM4A,B3PP3Q
 	.ref	D3BF3A,D3PD3Z
	.ref	L3BF3B,L3GP3Z,L3FH3A,L3FD3B

#Bret
 LWWW H3BF3A+FR3,38,-13,0
 LWWW H3PP3X+FR1,18,-32,0
 LWWW H3PP3X+FR2,9,7,0
 LWWW H3PP3X+FR3,17,52,0
 LWWW H3PP3X+FR6,18,72,0
 LWWW H3PP3X+FR6,28,74,0
 LWWW H3PP3X+FR6,34,71,0
 LWWW H3PP3X+FR6,43,67,0
 LWWW H3PP3X+FR7,47,-9,0
 LWWW H3PP3X+FR8,42,-29,0
 .long 0
#Razor
 LWWW R3BF3A+FR9,39,-18,0
 LWWW R3GP3Z+FR1,25,-29,0
 LWWW R3GP3Z+FR2,21,-22,0
 LWWW R3GP3Z+FR4,34,58,0
 LWWW R3GP3Z+FR5,32,74,0
 LWWW R3GP3Z+FR5,42,77,0
 LWWW R3GP3Z+FR5,45,76,0
 LWWW R3GP3Z+FR5,51,67,0
 LWWW R3GP3Z+FR7,48,9,0
 LWWW R3GP3Z+FR8,40,-33,0
 .long 0
#Taker
 LWWW U4BF3Z+FR1,37,-12,0
 LWWW U3PP3X+FR1,23,-25,1
 LWWW U3PP3X+FR2,24,-15,1
 LWWW U3PP3X+FR3,20,17,1
 LWWW U3PP3X+FR5,25,60,1
 LWWW U3PP3X+FR6,38,86,1
 LWWW U3PP3X+FR6,41,86,1
 LWWW U3PP3X+FR6,47,77,1
 LWWW U3GP3X+FR1,52,-18,1
; with a Y beneath the mat, which promptly results in his Y pos being
; set to match his GROUND_Y and his Yvel being zeroed.  This sucks.
 LWWW U3GP3X+FR2,51,-41+5,1
 .long 0
#Yokozuna
 LWWW Y3BF3A+FR11,46,-7,0
 LWWW Y3PP3Q+FR1,24,-22,0
 LWWW Y3PP3Q+FR3,28,-9,0
 LWWW Y3PP3Q+FR4,36,20,0
 LWWW Y3PP3Q+FR6,24,40,0
 LWWW Y3PP3Q+FR7,36,49,0
 LWWW Y3PP3Q+FR7,36,51,0
 LWWW Y3PP3Q+FR7,43,34,0
 LWWW Y3FD3N+FR2,52,-8,0
 LWWW Y3FD3N+FR3,48,-9,0
 .long 0
#Shawn
 LWWW S3BF3A+FR5,29,-27,0
 LWWW S3GP3X+FR1,30,-31,0
 LWWW S3GP3X+FR2,23,-19,0
 LWWW S3GP3X+FR3,28,19,0
 LWWW S3GP3X+FR4,22,65,0
 LWWW S3OS3X+FR8,43,66,1
 LWWW S3OS3X+FR8,43,66,1
 LWWW S3OS3X+FR8,47,57,1
 LWWW S3FD3X+FR2,57,-2,0
 LWWW S3GP3X+FR6,49,-30,0
 .long 0
#BamBam
 LWWW B4AM4A+FR5,41,-13,0
 LWWW B3PP3Q+FR1,23,-28,0
 LWWW B3PP3Q+FR2,23,-7,0
 LWWW B3PP3Q+FR3,29,33,0
 LWWW B3PP3Q+FR5,34,66,0
 LWWW B3PP3Q+FR6,35,74,0
 LWWW B3PP3Q+FR6,38,74,0
 LWWW B3PP3Q+FR6,46,68,0
 LWWW B3PP3Q+FR7,54,1,0
 LWWW B3FD3C+FR1,44,-23,0
 .long 0
#Doink
 LWWW D3BF3A+FR1,40,-14,0
 LWWW D3PD3Z+FR1,29,-36,1
 LWWW D3PD3Z+FR2,24,-12,1
 LWWW D3PD3Z+FR3,26,23,1
 LWWW D3PD3Z+FR4,19,63,1
 LWWW D3PD3Z+FR6,45,66,1
 LWWW D3PD3Z+FR6,47,62,1
 LWWW D3PD3Z+FR6,52,57,1
 LWWW D3PD3Z+FR8,52,-17,1
 LWWW D3PD3Z+FR9,48,-36,1
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3BF3B+FR1,27,-21,0
 LWWW L3GP3Z+FR1,25,-29,0
 LWWW L3GP3Z+FR2,23,-13,0
 LWWW L3GP3Z+FR4,29,36,0
 LWWW L3GP3Z+FR6,31,63,0
 LWWW L3GP3Z+FR6,42,64,0
 LWWW L3GP3Z+FR6,44,64,0
 LWWW L3GP3Z+FR6,53,54,0
 LWWW L3FH3A+FR6,51,-5,0
 LWWW L3FD3B+FR1,49,-30,0
 .long 0

	.ref	hrt_break_neck2_anim
	.ref	shn_break_neck2_anim
	.ref	dnk_break_neck2_anim
	.ref	und_break_neck2_anim
	.ref	lex_break_neck2_anim
	.ref	rzr_break_neck2_anim
	.ref	yok_break_neck2_anim

#rollout_tbl
	.long	hrt_break_neck2_anim,rzr_break_neck2_anim
	.long	und_break_neck2_anim
	.long	yok_break_neck2_anim
	.long	shn_break_neck2_anim,bam_break_neck2_anim
	.long	dnk_break_neck2_anim,0,lex_break_neck2_anim

#*****************************************************************************

	.bss	#opp_xvel,32

 SUBR	bam_3_head_hold2_anim
;Head hold when standing next to player
;No collisions possible

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold

	.word	ANI_STARTATTACK,AT_PUPPET,6

	WL	2,B4GH3B+FR1
	WL	2,B4GH3B+FR2
	WL	2,B4GH3B+FR3
	.word	ANI_ATTACK_ON, AMODE_PUPPET3,28,82,59,21 ;mode,x,y,w,h
	WL	3,B4GH3B+FR4
	WWL	ANI_WAITHITOPP,6,B4GH3B+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

;	WL	ANI_IFBLOCKED,#missed
	WL	ANI_GOTO,#gothim

 SUBR	bam_3_head_hold_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold
	.word	ANI_STARTATTACK,AT_LEAPING,9

	WL	3,B4GH3B+FR1
	WL	3,B4GH3B+FR2
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 7,999,60,40,90000h,TGT_HEAD,72,96,0

	WL	3,B4GH3B+FR3

	.word	ANI_ATTACK_ON, AMODE_PUPPET,28,82,59,21 ;mode,x,y,w,h
	WL	3,B4GH3B+FR4

	WWL	ANI_WAITHITOPP,6,B4GH3B+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	WL	ANI_IFBLOCKED,#missed

#gothim
;got him

	WL	ANI_CODE,CALL_SETUP

	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,4,B4GH3B+FR5,#puppet_tbl,0

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim

	WWLLW	ANI_SUPERSLAVE2,4,B4GH3B+FR6,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,B4GH3B+FR7,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,B4GH3D+FR5,#puppet_tbl,3

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	4,B4GH3D+FR5

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	25,B4GH3B+FR5
	WL	3,B4GH3B+FR4
	WL	3,B4GH3B+FR3

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
	.ref	Y3BF3A,Y3LB3A
	.ref	S4AH3D,S4BF3A
;	.ref	B4BF3A,B3HB3A,B3BF3C
	.ref	D3AK3A,D3BF3A
	.ref	L4AH4B,L3BF3A,L3BF3B
#Bret
 LWWW H2AH3A+FR1,86,19,0
 LWWW H3HB3A+FR3,78,-13,0
 LWWW H3HB3A+FR2,68,-17,0
 LWWW H3HB3A+FR1,57,-35,0
 .long 0
#Razor
 LWWW R3HB3A+FR3,80,-4,0
 LWWW R3HB3A+FR3,79,-15,0
 LWWW R3HB3A+FR2,75,-29,0
 LWWW R3BF3A+FR1,62,-36,0
 .long 0
#Taker
 LWWW U4AM4C+FR2,78,5,0
 LWWW U4BF3A+FR2,74,-1,0
 LWWW U4BF3A+FR3,44,-16,0
 LWWW U4BF3Z+FR3,63,-23,0
 .long 0
#Yokozuna
 LWWW Y3LB3A+FR2,82,10,0
 LWWW Y3LB3A+FR2,81,-1,0
 LWWW Y3LB3A+FR9,66,-26,0
 LWWW Y3BF3A+FR1,59,-23,0
 .long 0
#Shawn
 LWWW S4AH3D+FR5,78,2,0
 LWWW S4AH3D+FR5,77,-9,0
 LWWW S4BF3A+FR2,71,-21,0
 LWWW S4BF3A+FR3,44,-22,0
 .long 0
#BamBam
 LWWW B4BF3A+FR1,84,8,0
 LWWW B4BF3A+FR1,83,-3,0
 LWWW B3HB3A+FR2,74,-32,0
 LWWW B3BF3C+FR5,66,-27,0
 .long 0
#Doink
 LWWW D3AK3A+FR3,66,12,0
 LWWW D3AK3A+FR3,65,1,0
 LWWW D3AK3A+FR2,75,-19,0
 LWWW D3BF3A+FR1,62,-33,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L4AH4B+FR3,72,3,0
 LWWW L3BF3A+FR1,78,-8,1
 LWWW L3BF3A+FR2,74,-23,1
 LWWW L3BF3B+FR5,55,-31,0
 .long 0

	.ref	rzr_3_head_held_anim
;	.ref	bam_3_head_held_anim
	.ref	und_3_head_held_anim
	.ref	yok_3_head_held_anim
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


*****************************************************************************

	
	.end
