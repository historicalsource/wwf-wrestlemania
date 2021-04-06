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
	.include	"sound.h"

	.include	"display.equ"

	.include	"bretimg.h"
	.include	"razorimg.h"
	.include	"takerimg.h"
	.include	"yokoimg.h"
	.include	"shawnimg.h"
	.include	"bamimg.h"
	.include	"doinkimg.h"
	.include	"leximg.h"

	.include	"damage.equ"


******************************************************************************
* EXTERNAL REFERENCES

;RJR START
	.ref	DO_SNAP_MESS,CALL_SPECIAL_MOVE
;RJR END

	;BAM BAM
	.ref	bam_3_head_held_anim
	.ref	B3GU4A,B3DU3A,B3BF3C

	;DOINK
	.ref	dnk_3_head_held_anim
	.ref	D3DU3A,D3HT3Z,D3BF3A

	;BRET
	.ref	hrt_hitonground_facedown_anim,hrt_stand4_anim
	.ref	hrt_flyout2_anim,hrt_faceup_getup_anim
	.ref	H3GU4A,H3DU3A,H3BF3A

	;LEX
	.ref	lex_3_head_held_anim
	.ref	L3DU3A,L3BF3B

	;RAZOR
	.ref	rzr_3_head_held_anim
	.ref	R3GU4A,R3DU3B,R3BF3A

	;SHAWN
	.ref	shn_3_head_held_anim
	.ref	S3GU4A,S3DU3A,S3BF3A

	;TAKER
	.ref	und_3_head_held_anim
	.ref	U3DU3B,U4BF3Z

	;YOKO
	.ref	yok_3_head_held_anim
	.ref	Y3GU2A,Y3BF3A

	;MISC
	.ref	CALL_MISSES,SMALL_BOUNCE
	.ref	tgt_tbukl,tbukl_flip


	.ref	HIT_THE_MAT

	.ref	slaveanim_tbl

	.ref	hrt_slambounce_anim
	.ref	rzr_slambounce_anim
	.ref	und_slambounce_anim
	.ref	yok_slambounce_anim
	.ref	shn_slambounce_anim
	.ref	bam_slambounce_anim
	.ref	dnk_slambounce_anim
	.ref	lex_slambounce_anim

	.ref	rzr_break_face_anim
	.ref	und_break_face_anim
	.ref	yok_break_face_anim
	.ref	shn_break_face_anim
	.ref	bam_break_face_anim
	.ref	dnk_break_face_anim
	.ref	lex_break_face_anim

;RJR START
	.ref	hrt_tossed_anim
	.ref	rzr_tossed_anim
	.ref	und_tossed_anim
	.ref	yok_tossed_anim
	.ref	shn_tossed_anim
	.ref	bam_tossed_anim
	.ref	dnk_tossed_anim
	.ref	lex_tossed_anim
;RJR END


******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE


#*****************************************************************************
*
* HELD OVERHEAD ANIMATION

 SUBR	hrt_heldoh_anim

	.word	ANI_SETPLYRMODE,MODE_ATTACHED
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_SETSPEED,100h

	.word	ANI_SETWORD,USR_VAR1,0		;loop count

#loop
	WL	3,H4MF4B+FR1
	WL	3,H4MF4B+FR2
	WL	3,H4MF4B+FR3
	WL	3,H4MF4B+FR4
	WL	3,H4MF4B+FR5
	WL	3,H4MF4B+FR6
	WL	3,H4MF4B+FR7
	WL	3,H4MF4B+FR8
	WL	3,H4MF4B+FR9

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

	WL	5,H4MF4B+FR1
	.word	ANI_OFFSET,-20,-50,0			;x,y,z
	WL	4,H3MS3Z+FR4
	WL	4,H3MS3Z+FR3
	WL	4,H3MS3Z+FR2
	WL	4,H3MS3Z+FR1
	.word	ANI_WAITHITGND
	WL	4,H2ST2A+FR1

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

 SUBR	hrt_backbreaker_anim

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* NECK BREAKER

 SUBR	hrt_neckbreaker_anim

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* END OF NECK BROKEN SEQ.

 SUBR	hrt_neckbroken_anim

	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim

#*****************************************************************************
*
* POGO STICK HEAD CRUNCHER

 SUBR	hrt_pogo_anim

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* CLIMB UP TURNBUCKLES

#yoff	equ	20

 SUBR	hrt_climb_up_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	4,H4HU4B+FR1
	WL	4,H4HU4B+FR2
	WL	ANI_CODE,tgt_tbukl
	.word	ANI_LEAPATPOS,20,200,8,-3,0	;#ticks,dist,xoff,yoff,zoff
	WL	20,H4HU4B+FR3

	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONTURNBKL
	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE | MODE_NOGRAVITY
	.word	ANI_SHAKECORNER

	.word	ANI_OFFSET,0,#yoff,0
	WL	4,H4HU4B+FR4
	WL	4,H4HU4B+FR7

#repeat
	WL	4,H4SB4B+FR1
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR2
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR3
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR4
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR5
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR6
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR7
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR6
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR5
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR4
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR3
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR2
	WL	ANI_CODE,tbukl_flip
	WL	ANI_GOTO,#repeat


#*****************************************************************************
*
* CLIMB DOWN TURNBUCKLES

 SUBR	hrt_climb_down_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SHAKECORNER

	WL	4,H4HU4B+FR2

	WLW	ANI_SET_XVEL,10000h,AM_FACE_REL
	WLW	ANI_SET_ZVEL,-10000h,AM_FACE_REL
	WL	ANI_SET_YVEL,20000h

	WL	1,H4HU4B+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	4,H4HU4B+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

;RJR START
#*****************************************************************************
*
* HIP SLAM
*

 SUBR	hrt_hipslam_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCONFINE
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,8

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,48,0,2
	WL	ANI_SET_YVEL,0

	WL	4,H3HT3X+FR1
	WL	4,H3HT3X+FR2

	.word	ANI_ATTACK_ON,AMODE_PUPPET,19,59,70,38
	WWL	ANI_WAITHITOPP,3,H3HT3X+FR3

	.word	ANI_ZERO_XZVELS

	WL	ANI_IFBLOCKED,#missedblk
	WL	ANI_IFSTATUS,#got_him

	WWL	ANI_WAITHITOPP,20,H3HT3X+FR3
	.word	ANI_ATTACK_OFF

	WL	ANI_IFBLOCKED,#missedblk
	WL	ANI_IFNOTSTATUS,#missed

#got_him
	.word	ANI_ATTACK_OFF
	WL	ANI_CODE,DO_SNAP_MESS
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	.word	ANI_ATTACHZ,0,0,2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,4,H3HT3X+FR3,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,H3HT3X+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,H3HT3X+FR5,#puppet_tbl,2
	WLW	ANI_SET_XVEL,-18000h,AM_FACE_REL
	WL	ANI_SET_YVEL,08000h
	.word	ANI_OFFSET,0,43,0			;x,y,z
	WWLLW	ANI_SUPERSLAVE2,4,H3HT3X+FR6,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,H3HT3X+FR7,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,1,H3HT3X+FR8,#puppet_tbl,5
	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	;impact
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_DAMAGEOPP,D_HIPTOSS

	WWLLW	ANI_SUPERSLAVE2,3,H3HT3X+FR9,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,3,H3HT3X+FR10,#puppet_tbl,7

	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#rollout_tbl
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_DETACH
	.word	ANI_FACE,MOVE_LEFT|MOVE_UP
	WL	10,H3HT3X+FR10
	.word	ANI_XFLIP
	WL	4,H3HT3X+FR11
	WL	4,H3HT3X+FR12

	WL	4,H3GU2A+FR7
	WL	4,H3GU2A+FR8
	WL	4,H3GU2A+FR9
	WL	4,H3GU2A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END



#missedblk
	WL	10,H3HT3X+FR3
	WL	20,H3HT3X+FR3
#missed
	WL	ANI_CODE,CALL_MISSES

	WL	6,H3HT3X+FR2
	WL	6,H3HT3X+FR1
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
 LWWW H2AH3A+FR5,55,11,0
 LWWW H2AM3A+FR1,42,16,0
 LWWW H2AM3A+FR7,25,1,0
 LWWW H3FR3A+FR2,2,32,0
 LWWW H3FR3A+FR3,-17,62,0
 LWWW H3FR3A+FR4,-40,49,0
 LWWW H3FR3A+FR5,-69,4,0
 LWWW H2CP3A+FR8,-142,-30,1
 .long 0
#Razor
 LWWW R4AH4C+FR3,65,18,0
 LWWW R3TD3A+FR1,40,16,0
 LWWW R3TD3A+FR3,13,1,0
 LWWW R3TD3A+FR4,-4,22,0
 LWWW R3TD3A+FR5,-8,38,0
 LWWW R3TD3A+FR6,-30,37,0
 LWWW R3TD3A+FR7,-65,16,0
 LWWW R3GU2A+FR1,-159,-28,1
 .long 0
#Taker
 LWWW U3AE4A+FR1,69,24,0
 LWWW U4AM4C+FR4,41,13,0
 LWWW U3FH3A+FR1,28,7,1
 LWWW U3FH3A+FR2,2,36,1
 LWWW U3FH3A+FR3,-14,48,1
 LWWW U3FH3A+FR4,-45,48,1
 LWWW U3FH3A+FR5,-80,24,1
 LWWW U3CP3B+FR1,-161,-25,1
 .long 0
#Yokozuna
 LWWW Y4AE4A+FR1,66,12,0
 LWWW Y3FL3W+FR2,31,6,0
 LWWW Y3FL3W+FR3,5,8,0
 LWWW Y3FL3W+FR4,8,45,0
 LWWW Y3FL3W+FR5,-3,64,0
 LWWW Y3FL3W+FR6,-43,62,0
 LWWW Y3FL3W+FR7,-84,18,0
 LWWW Y3FD3A+FR7,-127,-3,0
 .long 0
#Shawn
 LWWW S3OS3X+FR2,43,9,1
 LWWW S3OS3X+FR4,9,8,1
 LWWW S3OS3X+FR5,-16,6,1
 LWWW S3OS3X+FR6,-14,54,1
 LWWW S3OS3X+FR7,-13,71,1
 LWWW S3OS3X+FR8,-27,61,1
 LWWW S3OS3X+FR9,-88,33,1
 LWWW S3OS3X+FR10,-136,-20,1
 .long 0
#BamBam
 LWWW B4AH4A+FR1,56,13,0
 LWWW B4TD3B+FR2,25,13,0
 LWWW B4TD3B+FR3,2,8,0
 LWWW B4TD3B+FR4,2,25,0
 LWWW B4TD3B+FR5,-17,59,0
 LWWW B4TD3B+FR6,-45,57,0
 LWWW B4TD3B+FR7,-79,29,0
 LWWW B4TD3B+FR9,-130,-10,0
 .long 0
#Doink
 LWWW D3AE3B+FR8,63,13,0
 LWWW D3PM4C+FR2,21,18,0
 LWWW D3OS3A+FR2,3,10,0
 LWWW D3OS3A+FR4,-17,34,0
 LWWW D3OS3A+FR5,-22,42,0
 LWWW D3OS3A+FR6,-42,36,0
 LWWW D3FD3E+FR2,-79,-6,0
 LWWW D3SA3A+FR2,-144,-21,1
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3FH3A+FR1,44,-8,0
 LWWW L3FH3A+FR2,39,-16,0
 LWWW L3FH3A+FR3,21,5,0
 LWWW L3FH3A+FR4,10,35,0
 LWWW L3FH3A+FR5,-11,46,0
 LWWW L3FH3A+FR6,-39,45,0
 LWWW L3FH3A+FR6,-63,14,0
 LWWW L3CP3B+FR1,-150,-23,1
 .long 0


 .if 0

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCONFINE
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,8
	WL	4,H3HT3X+FR1
	WL	4,H3HT3X+FR2

	;don't do it if it's just gonna lock on a hit
	.word	ANI_IFOPP,W_BRET,-1
	WL	ANI_IFNOTSTATUS,#missed

	.word	ANI_ATTACK_ON,AMODE_PUPPET,46,88,42,23
	WL	4,H3HT3X+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	.word	ANI_ATTACHZ,0,0,4
	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WLW	ANI_SUPERSLAVE,#puppet_tbl,0
	WL	8,H3HT3X+FR3
	WLW	ANI_SUPERSLAVE,#puppet_tbl,1
	WL	4,H3HT3X+FR4

	WL	ANI_SET_YVEL,30000h

	WLW	ANI_SUPERSLAVE,#puppet_tbl,2
	WL	4,H3HT3X+FR5

	WWWL	ANI_IFROPE,RC_BACK,128,#throw_him_out
	
	WLW	ANI_SUPERSLAVE,#puppet_tbl,3
	WL	4,H3HT3X+FR6
	WLW	ANI_SUPERSLAVE,#puppet_tbl,4
	WL	4,H3HT3X+FR7
	WLW	ANI_SUPERSLAVE,#puppet_tbl,5
	WL	4,H3HT3X+FR8
	WLW	ANI_SUPERSLAVE,#puppet_tbl,6
	WL	4,H3HT3X+FR9

	;impact
	.word	ANI_SOUND,0C2h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,60
	.word	ANI_DAMAGEOPP,16
	.word	ANI_OPP_GETUP,30

	WL	ANI_SLAVEANIM,#recover_tbl
	.word	ANI_DETACH
#attacker_lands
	.word	ANI_ZEROVELS
	WL	10,H3HT3X+FR10
	WL	4,H3HT3X+FR11
	WL	4,H3HT3X+FR12

	;get up
	WL	4,H3GU2A+FR8
	WL	4,H3GU2A+FR9
	WL	4,H3GU2A+FR10
	.word	ANI_FACEUP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#throw_him_out
	;release him
	WL	ANI_SLAVEANIM,#flyout_tbl
	.word	ANI_DETACH
	WL	4,H3HT3X+FR6
	WL	4,H3HT3X+FR7
	WL	4,H3HT3X+FR8
	WL	4,H3HT3X+FR9
	WL	ANI_GOTO,#attacker_lands

#missed
	WL	ANI_CODE,CALL_MISSES
	WL	10,H3HT3X+FR3
	WL	4,H3HT3X+FR2
	WL	4,H3HT3X+FR1
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
#Bret
 LWWW H3UC3X+FR1,72,-2,1
 LWWW H3UC3X+FR3,58,24,1
 LWWW H3UC3X+FR5,50,73,1
 LWWW H3UC3Z+FR1,23,94,1
 LWWW H3UC3Z+FR2,6,78,1
 LWWW H3UC3Z+FR4,5,45,1
 LWWW H3MS3X+FR1,-100,0,0
#Razor
 .long 0
#Taker
 .long 0
#Yokozuna
 .long 0
#Shawn
 .long 0
#BamBam
 .long 0
#Doink
 .long 0
#Adam
 .long 0
#Lex
 .long 0

#recover_tbl
	.long	hrt_hitonground_facedown_anim,0,0,0
	.long	0,0,0,0,0

#flyout_tbl
	.long	hrt_flyout2_anim,0,0,0
	.long	0,0,0,0,0


 .endif

;RJR END
#*****************************************************************************

 SUBR	hrt_3_head_held_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_HEADHELD
	.word	ANI_SETFACING
	.word	ANI_SETWORD,USR_VAR1,0		;loop count

#loop
	WL	4,H3BF3A+FR1
	WL	4,H3BF3A+FR2
	WL	4,H3BF3A+FR3
	WL	4,H3BF3A+FR4
	WL	4,H3BF3A+FR5
	WL	4,H3BF3A+FR6
	WL	ANI_CODE,#inc_loop
	WL	ANI_IFNOTSTATUS,#loop

;Continue into break...

 SUBR	hrt_3_head_held_brk_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WLW	ANI_SET_XVEL,-38000h,AM_NEWFACE_REL
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	WL	4,H3HB3A+FR2
	.word	ANI_DETACH

;Standard #2 head hit from spin kick
	WL	3,H2AH3A+FR1
	WL	3,H2AH3A+FR2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,H2AH3A+FR3
	WL	3,H2AH3A+FR4
	WL	3,H2AH3A+FR5
	WL	3,H2AH3A+FR6

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

 SUBR	hrt_3_head_held_stand_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	3,H3HB3A+FR3
	WL	3,H1TL5A+FR3	;2.5
	.word	ANI_DETACH

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#******************************************************************************

 SUBR	hrt_4_taunt_anim

	.word	ANI_SETMODE,MODE_UNINT
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	5,H4SL4C+FR1
	WL	5,H4SL4C+FR2
	WL	5,H4SL4C+FR3
	WL	5,H4SL4C+FR4
	WL	5,H4SL4C+FR5
	WL	5,H4SL4C+FR6
	WL	5,H4SL4C+FR5
	WL	5,H4SL4C+FR4
	WL	5,H4SL4C+FR7
	WL	5,H4SL4C+FR8
	WL	5,H4SL4C+FR9
	WL	5,H4SL4C+FR8
	WL	5,H4SL4C+FR7

	WL	5,H4SL4C+FR4
	WL	5,H4SL4C+FR5
	WL	5,H4SL4C+FR6
	WL	5,H4SL4C+FR5
	WL	5,H4SL4C+FR4
	WL	5,H4SL4C+FR7

	WL	5,H4SL4C+FR3
	WL	5,H4SL4C+FR2
	WL	5,H4SL4C+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,hrt_stand4_anim
	.word	ANI_END

#******************************************************************************

 SUBR	hrt_2_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_STARTATTACK,AT_PUPPET,15
	WL	2,H1TL5A+FR3	;2.5
	WL	2,H1TL5A+FR4	;3.5

 SUBR	hrt_4_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

;Put cool cheers here
;	.word	ANI_CHEER,3

	.word	ANI_STARTATTACK,AT_PUPPET,11
	WL	3,H4GH3Z+FR1

	LEAPATOPP 8,999,80,80,40000h,TGT_HEAD,10,6,-2

	WL	4,H4GH3Z+FR2
	WL	4,H4GH3Z+FR3
	.word	ANI_ZERO_XZVELS

	.word	ANI_ATTACK_ON, AMODE_PUPPET,18,0,25,18 ;mode,x,y,w,h
	WL	5,H4GH3Z+FR3
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;got him
	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SOUND,33h			;neck break (5-7 ticks late)
	.word	ANI_DAMAGEOPP,10

	WWLLW	ANI_SUPERSLAVE2,4,H4GH3Z+FR4,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,H4GH3Z+FR5,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,H4GH3Z+FR6,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,H4GH3Z+FR7,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,H4GH3Z+FR8,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,H4GH3Z+FR8,#puppet_tbl,5

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	4,H4GH3Z+FR8
	.word	ANI_CLROPPMODE,MODE_GHOST

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	20,H4GH3Z+FR3
	WL	3,H4GH3Z+FR2
	WL	3,H4GH3Z+FR1

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
 LWWW H3GU4A+FR1,30,-33,0
 LWWW H3GU4A+FR3,46,-36,0
 LWWW H3DU3A+FR3,48,-34,1
 LWWW H3DU3A+FR4,55,-25,1
 LWWW H3DU3A+FR5,53,-37,1
 LWWW H3BF3A+FR1,52,-38,0
 .long 0
#Razor
 LWWW R3GU4A+FR2,36,-30,1
 LWWW R3GU4A+FR3,36,-29,0
 LWWW R3GU4A+FR5,55,-35,0
 LWWW R3DU3B+FR2,50,-35,1
 LWWW R3DU3B+FR4,52,-33,1
 LWWW R3BF3A+FR4,48,-40,0
 .long 0
#Taker
 LWWW U3DU3B+FR2,41,-26,1
 LWWW U3DU3B+FR5,36,-27,1
 LWWW U3DU3B+FR6,47,-35,1
 LWWW U3DU3B+FR8,49,-31,1
 LWWW U3DU3B+FR10,52,-32,1
 LWWW U4BF3Z+FR5,62,-20,0
 .long 0
#Yokozuna
 LWWW Y3GU2A+FR1,31,-21,0
 LWWW Y3GU2A+FR3,47,-16,0
 LWWW Y3GU2A+FR6,32,-38,0
 LWWW Y3GU2A+FR9,52,-35,0
 LWWW Y3GU2A+FR12,51,-32,0
 LWWW Y3BF3A+FR1,48,-29,0
 .long 0
#Shawn
 LWWW S3GU4A+FR1,35,-32,1
 LWWW S3GU4A+FR2,39,-29,0
 LWWW S3GU4A+FR4,51,-34,0
 LWWW S3GU4A+FR5,50,-36,0
 LWWW S3DU3A+FR2,56,-40,1
 LWWW S3BF3A+FR1,39,-39,0
 .long 0
#BamBam
 LWWW B3GU4A+FR3,39,-15,0
 LWWW B3GU4A+FR4,44,-23,0
 LWWW B3GU4A+FR6,48,-27,0
 LWWW B3GU4A+FR7,48,-38,0
 LWWW B3DU3A+FR2,48,-34,1
 LWWW B3BF3C+FR5,59,-33,0
 .long 0
#Doink
 LWWW D3DU3A+FR2,33,-25,1
 LWWW D3DU3A+FR3,43,-27,1
 LWWW D3DU3A+FR5,45,-30,1
 LWWW D3DU3A+FR8,48,-38,1
 LWWW D3HT3Z+FR1,48,-38,1
 LWWW D3BF3A+FR2,49,-37,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3DU3A+FR2,37,-27,1
 LWWW L3DU3A+FR4,25,-16,1
 LWWW L3DU3A+FR6,28,-30,1
 LWWW L3DU3A+FR7,41,-27,1
 LWWW L3DU3A+FR9,53,-37,1
 LWWW L3BF3B+FR2,61,-41,0
 .long 0


#*****************************************************************************
*
* Head slams into mat
;From head slam - repeated head slam

 SUBR	hrt_break_face2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	.word	ANI_ZEROVELS

	WL	2,H3MS3X+FR5		;Face down
	WL	ANI_SET_YVEL,80000h
	WL	3,H3MS3X+FR2
	WL	3,H3MS3X+FR3
	WL	3,H3MS3X+FR4
	WL	3,H3MS3X+FR5
	.word	ANI_WAITHITGND
	.word	ANI_END
	

* Head slams into mat
;From head slam

 SUBR	hrt_break_face_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	.word	ANI_ZEROVELS

	WL	2,H3MS3X+FR5		;Face down
	WL	ANI_SET_YVEL,40000h
	WL	3,H3MS3X+FR2
	WL	3,H3MS3X+FR3
	WL	3,H3MS3X+FR4
	WL	3,H3MS3X+FR5
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,H3MS3X+FR2
	WL	3,H3MS3X+FR3
	WL	3,H3MS3X+FR4
	WL	3,H3MS3X+FR5

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	3,H3MS3X+FR5
	.word	ANI_WAITROLL

	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim
	.word	ANI_END

#*****************************************************************************

	.bss	#opp_xvel,32

 SUBR	hrt_3_head_hold_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold

	.word	ANI_STARTATTACK,AT_PUPPET,12
	WL	3,H4GH3C+FR1
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 9,999,60,40,90000h,TGT_HEAD,56,93,8
	WL	3,H4GH3C+FR2

	.word	ANI_ATTACK_ON, AMODE_PUPPET,40,80,37,23 ;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,3,H4GH3C+FR3
	WWL	ANI_WAITHITOPP,6,H4GH3C+FR4

	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	WL	ANI_IFBLOCKED,#missed

;got him
;	WL	ANI_CODE,merge_xvels

	.ref	CALL_SETUP
	WL	ANI_CODE,CALL_SETUP

	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,4,H4GH3C+FR5,#puppet_tbl,0

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WWLLW	ANI_SUPERSLAVE2,4,H4GH3C+FR6,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,H4GH3C+FR7,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,H4GH3Z+FR8,#puppet_tbl,3

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	4,H4GH3Z+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	25,H4GH3C+FR4
	WL	3,H4GH3C+FR3
	WL	3,H4GH3C+FR2
	WL	3,H4GH3C+FR1

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

;	.ref	H2AH3A,H3HB3A,H3BF3A
	.ref	R2AH2D,R3HB3A,R3BF3A
	.ref	U4BF3A,U4BF3Z,U4AM4C
	.ref	Y3BF3A,Y3LB3A
	.ref	S4AH3D,S4BF3A
	.ref	B4BF3A,B3HB3A,B3BF3C
	.ref	D3AK3A,D3BF3A
	.ref	L2AH2A,L3BF3A,L3BF3B,L4AH4B
#Bret
 LWWW H2AH3A+FR1,79,25,0
 LWWW H3HB3A+FR3,65,2,0
 LWWW H3HB3A+FR2,56,-8,0
 LWWW H3HB3A+FR1,49,-40,0
 .long 0
#Razor
 LWWW R3HB3A+FR3,70,3,0
 LWWW R3HB3A+FR3,74,0,0
 LWWW R3HB3A+FR2,71,-19,0
 LWWW R3BF3A+FR1,53,-40,0
 .long 0
#Taker
 LWWW U4AM4C+FR2,61,12,0
 LWWW U4BF3A+FR2,66,13,0
 LWWW U4BF3A+FR3,34,-7,0
 LWWW U4BF3Z+FR3,55,-29,0
 .long 0
#Yokozuna
 LWWW Y3LB3A+FR2,74,15,0
 LWWW Y3LB3A+FR2,78,12,0
 LWWW Y3LB3A+FR9,60,-18,0
 LWWW Y3BF3A+FR1,56,-30,0
 .long 0
#Shawn
 LWWW S4AH3D+FR5,78,8,0
 LWWW S4AH3D+FR5,82,5,0
 LWWW S4BF3A+FR2,68,-12,0
 LWWW S4BF3A+FR3,30,-28,0
 .long 0
#BamBam
 LWWW B4BF3A+FR1,79,12,0
 LWWW B4BF3A+FR1,83,9,0
 LWWW B3HB3A+FR2,69,-25,0
 LWWW B3BF3C+FR5,60,-34,0
 .long 0
#Doink
 LWWW D3AK3A+FR3,58,17,0
 LWWW D3AK3A+FR3,62,14,0
 LWWW D3AK3A+FR2,66,-9,0
 LWWW D3BF3A+FR1,53,-40,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L4AH4B+FR3,74,13,0
 LWWW L3BF3A+FR1,81,9,1
 LWWW L3BF3A+FR2,72,-12,1
 LWWW L3BF3B+FR5,54,-34,0
 .long 0

	.ref	rzr_3_head_held_anim
	.ref	bam_3_head_held_anim
	.ref	und_3_head_held_anim
	.ref	yok_3_head_held_anim
;	.ref	hrt_3_head_held_anim
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
* DDT (FROM HEAD HOLD)

 SUBR	hrt_hh_2_ddt_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker

	WL	ANI_SLAVEANIM,slaveanim_tbl
	.word	ANI_SETOPPMODE,MODE_GHOST

	WWLLW	ANI_SUPERSLAVE2,3,H1TL5A+FR5,#puppet_tbl,0
	.word	ANI_XFLIP
	WWLLW	ANI_SUPERSLAVE2,3,H1TL5A+FR6,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,H1TL5A+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,H3DD3Z+FR1,#puppet_tbl,3

	WWL	ANI_SETLONG,OBJ_GRAVITY,0a000h
	WL	ANI_SET_YVEL,70000h

	WWLLW	ANI_SUPERSLAVE2,4,H3DD3Z+FR2,#puppet_tbl,4
	.word	ANI_OFFSET,0,53,0	;x,y,z
	WWLLW	ANI_SUPERSLAVE2,4,H3DD3Z+FR3,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,4,H3DD3Z+FR4,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,4,H3DD3Z+FR5,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,1,H3DD3Z+FR6,#puppet_tbl,8

	.word	ANI_WAITHITGND
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40

	WWLLW	ANI_SUPERSLAVE2,4,H3DD3Z+FR7,#puppet_tbl,9
	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#break_face_tbl

	.word	ANI_SETOPP_PLYRMODE,MODE_ONGROUND
	.word	ANI_DETACH
	WL	8,H3UC3X+FR9
	WL	8,H3UC3X+FR10

	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim


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

#break_face_tbl
	.long	hrt_break_face_anim,rzr_break_face_anim
	.long	und_break_face_anim
	.long	yok_break_face_anim
	.long	shn_break_face_anim,bam_break_face_anim
	.long	dnk_break_face_anim,0,lex_break_face_anim

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
 LWWW H3GU4A+FR10,43,-24,0

 LWWW H4AM3A+FR3,-45,-37,0
 LWWW H4AM3A+FR5,-45,-41,0
 LWWW H4AM3A+FR6,-43,-33,0
 LWWW H3MS3Z+FR1,-73,-16,0
 LWWW H3MS3Z+FR2,-84,-19,0
 LWWW H3MS3Z+FR3,-85,-20,0
 LWWW H3MS3Z+FR4,-85,-20,0
 LWWW H3MS3Z+FR5,-93,-17,0
 LWWW H3MS3Z+FR6,-65,-21,0
 .long 0
#Razor
 LWWW R4AM3X+FR2,46-10,-9,0

 LWWW R4AM3X+FR4,-47,-24,0
 LWWW R4AM3X+FR5,-48,-20,0
 LWWW R4AM3X+FR6,-47,-14,0
 LWWW R3MS3Z+FR1,-53,-15,0
 LWWW R3MS3Z+FR2,-67,-16,0
 LWWW R3MS3Z+FR3,-85,-22,0
 LWWW R3MS3Z+FR4,-96,-21,0
 LWWW R3MS3Z+FR5,-98,-25,0
 LWWW R3MS3Z+FR6,-92,-42,0
 .long 0
#Taker
 LWWW U3GD2A+FR8,50-13,-19,0

 LWWW U4BF3Z+FR2,-56,-32,0
 LWWW U4BF3Z+FR1,-59,-34,0
 LWWW U4BF3A+FR3,-60,-12,0
 LWWW U3MS3Z+FR1,-70,-3,0
 LWWW U3MS3Z+FR2,-85,-7,0
 LWWW U3MS3Z+FR3,-97,-25,0
 LWWW U3MS3Z+FR4,-99,-25,0
 LWWW U3MS3Z+FR5,-106,-26,0
 LWWW U3MS3Z+FR6,-96,-31,0
 .long 0
#Yokozuna
 LWWW Y4AM4A+FR7,44-12,-20,0

 LWWW Y4AM4A+FR5,-54,-24,0
 LWWW Y4AM4A+FR4,-58,-26,0
 LWWW Y4AM4A+FR3,-56,-25,0
 LWWW Y3MS3Z+FR1,-57,-24,0
 LWWW Y3MS3Z+FR2,-73,-4,0
 LWWW Y3MS3Z+FR3,-94,-10,0
 LWWW Y3MS3Z+FR4,-93,-13,0
 LWWW Y3MS3Z+FR5,-94,-21,0
 LWWW Y3MS3Z+FR6,-94,-41,0
 .long 0
#Shawn
 LWWW S4AM3A+FR5,44-17,-41,0

 LWWW S4AM3A+FR6,-48,-46,0
 LWWW S4AM3A+FR7,-48,-39,0
 LWWW S4AM3A+FR8,-46,-21,0
 LWWW S3MS3Z+FR1,-55,-22,0
 LWWW S3MS3Z+FR2,-76,-18,0
 LWWW S3MS3Z+FR3,-84,-18,0
 LWWW S3MS3Z+FR4,-87,-19,0
 LWWW S3MS3Z+FR5,-93,-22,0
 LWWW S3MS3Z+FR6,-97,-54,0
 .long 0
#BamBam
 LWWW B4AM4A+FR2,50-16,-21,0

 LWWW B4AM4A+FR3,-47,-29,0
 LWWW B4AM4A+FR6,-50,-31,0
 LWWW B4AM4A+FR7,-50,-25,0
 LWWW B3MS3Z+FR1,-69,-11,0
 LWWW B3MS3Z+FR2,-91,-18,0
 LWWW B3MS3Z+FR3,-104,-25,0
 LWWW B3MS3Z+FR4,-106,-14,0
 LWWW B3MS3Z+FR5,-103,-2,0
 LWWW B3MS3Z+FR6,-92,-13,0
 .long 0
#Doink
 LWWW D3AM3A+FR4,53-17,-21,0

 LWWW D3AM3A+FR5,-49,-34,0
 LWWW D3PP3A+FR3,-55,-40,0
 LWWW D3PP3A+FR2,-55,-24,0
 LWWW D3GS3X+FR1,-49,-22,0
 LWWW D3GS3X+FR3,-58,-19,0
 LWWW D3GS3X+FR4,-70,-19,0
 LWWW D3GS3X+FR5,-68,-23,0
 LWWW D3GS3X+FR7,-76,-25,0
 LWWW D3GS3X+FR8,-103,-53,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3BF3A+FR2,60-23,-18,1

 LWWW L3BF3A+FR3,-61,-34,1
 LWWW L4GH3B+FR2,-52,-34,0
 LWWW L4GH3B+FR3,-52,-25,0
 LWWW L3MS3Z+FR1,-65,-15,0
 LWWW L3MS3Z+FR2,-65,-15,0
 LWWW L3MS3Z+FR3,-74,-22,0
 LWWW L3MS3Z+FR4,-82,-26,0
 LWWW L3MS3Z+FR5,-94,-29,0
 LWWW L3MS3Z+FR6,-96,-46,0
 .long 0


;RJR START
#*****************************************************************************
*
* RUNNING DDT

 SUBR	hrt_running_ddt_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_INAIR2
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,8

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 14,120,120,40,90000h,TGT_HEAD,-10,38+53,0

	WL	7,H3DD3Z+FR1
	WL	7,H3DD3Z+FR2

	.word	ANI_OFFSET,0,53,0	;x,y,z

	.word	ANI_ATTACK_ON, AMODE_PUPPET,-27,26,38,49 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,H3DD3Z+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedblk

	WL	ANI_CODE,#half_vels

	.word	ANI_ATTACHZ,0,0,2	;opp in front
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,3,H3DD3Z+FR3,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,H3DD3Z+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,H3DD3Z+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,H3DD3Z+FR6,#puppet_tbl,3

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	;impact
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_DAMAGEOPP,D_HIPTOSS


	WWLLW	ANI_SUPERSLAVE2,4,H3DD3Z+FR7,#puppet_tbl,4
	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#break_face_tbl
	WLLL	ANI_SETOPPVELS,-10000h,40000h,0	;x,y,z vels
	.word	ANI_DETACH

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WL	8,H3UC3X+FR9
	WL	8,H3UC3X+FR10

	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim


#missedblk
#missed
	WL	4,H3DD3Z+FR3
	WL	4,H3DD3Z+FR4
	WL	4,H3DD3Z+FR5
	WL	4,H3DD3Z+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	WL	4,H3DD3Z+FR7

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	WL	8,H3UC3X+FR9
	WL	8,H3UC3X+FR10

	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_XFLIP
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim


#half_vels
	move	*a13(OBJ_XVEL),a0,L
	sra	1,a0
	move	a0,*a13(OBJ_XVEL),L

	clr	a0
	movi	[2,0],a0
	move	a0,*a13(OBJ_YVEL),L
	rets

#xflip_tbl
	.word	0 ;bret
	.word	0 ;razor
	.word	0 ;taker
	.word	1 ;yoko
	.word	0 ;shawn
	.word	1 ;bam
	.word	0 ;doink
	.word	0 ;spare
	.word	0 ;lex

#break_face_tbl
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
 LWWW H3UC3X+FR1,-28,-9,0
 LWWW H3UC3X+FR2,-62,-2,0
 LWWW H3UC3X+FR3,-70,4,0
 LWWW H3UC3X+FR4,-62,4,0
 LWWW H2CP3A+FR1,-69,-39,1
 .long 0
#Razor
 LWWW R3FD3B+FR1,-36,-4,0
 LWWW R3FD3B+FR2,-62,1,0
 LWWW R3FD3B+FR4,-80,14,0
 LWWW R3FD3B+FR5,-70,15,0
 LWWW R3AM3D+FR2,-89,-42,1
 .long 0
#Taker
 LWWW U3FD3X+FR1,-30,-5,1
 LWWW U3FD3X+FR2,-43,-2,1
 LWWW U3FD3X+FR3,-50,4,1
 LWWW U3FD3X+FR4,-61,8,1
 LWWW U3CP3B+FR3,-95,-28,1
 .long 0
#Yokozuna
 LWWW Y3FD3A+FR1,-34,-11,0
 LWWW Y3FD3A+FR2,-69,16,0
 LWWW Y3FD3A+FR3,-62,17,0
 LWWW Y3FD3A+FR4,-67,11,0
 LWWW Y3CP3B+FR1,-74,-38,1
 .long 0
#Shawn
 LWWW S3UC3X+FR1,-40,-3,0
 LWWW S3UC3X+FR2,-58,-3,0
 LWWW S3UC3X+FR4,-69,-4,0
 LWWW S3UC3X+FR5,-58,9,0
 LWWW S3CP3B+FR2,-83,-37,1
 .long 0
#BamBam
 LWWW B4UC3B+FR1,-43,4,0
 LWWW B4UC3B+FR2,-58,-1,0
 LWWW B4UC3B+FR3,-76,-1,0
 LWWW B4UC3B+FR4,-82,-4,0
 LWWW B3CP3B+FR2,-84,-7,1
 .long 0
#Doink
 LWWW D3UC3A+FR2,-47,-2,0
 LWWW D3UC3A+FR3,-57,6,0
 LWWW D3UC3A+FR4,-75,8,0
 LWWW D3UC3A+FR5,-75,3,0
 LWWW D3SA3A+FR4,-79,-42,1
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3UC3X+FR2,-47,-14,0
 LWWW L3UC3X+FR3,-76,-10,0
 LWWW L3CP3X+FR2,-81,-4,1
 LWWW L3CP3X+FR3,-73,8,1
 LWWW L3CP3X+FR1,-90,-52,1
 .long 0

;RJR END
******************************************************************************

	.end
