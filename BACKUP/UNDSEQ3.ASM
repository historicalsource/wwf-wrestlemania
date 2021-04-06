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

	.file	"undseq3.asm"
	.title	"Undertaker animation sequences"
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
	.include	"miscimg.glo"

	.include	"damage.equ"

******************************************************************************
* EXTERNAL REFERENCES

	.REF	CALL_ANI_AVERAGE_MOVE,CALL_SETUP
	.REF	CALL_SPECIAL_MOVE,CALL_DROP_KICK
	.REF	HIT_THE_MAT,SMALL_BOUNCE
	.ref	D4SK4A,und_getup_anim
	.REF	CALL_MISSES
	.ref	slaveanim_tbl
	.ref	und_faceup_getup_anim
	.ref	tgt_tbukl,tbukl_flip

	.ref	hrt_slambounce_anim
	.ref	rzr_slambounce_anim
	.ref	und_slambounce_anim
	.ref	yok_slambounce_anim
	.ref	shn_slambounce_anim
	.ref	bam_slambounce_anim
	.ref	dnk_slambounce_anim
	.ref	lex_slambounce_anim

	.ref	hrt_slambounce2_anim
	.ref	rzr_slambounce2_anim
	.ref	und_slambounce2_anim
	.ref	yok_slambounce2_anim
	.ref	shn_slambounce2_anim
	.ref	bam_slambounce2_anim
	.ref	dnk_slambounce2_anim
	.ref	lex_slambounce2_anim

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* HELD OVERHEAD ANIMATION

 SUBR	und_heldoh_anim

	.word	ANI_SETPLYRMODE,MODE_ATTACHED
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_SETSPEED,100h

	.word	ANI_SETWORD,USR_VAR1,0		;loop count

#loop
	WL	4,U4PM3C+FR1
	WL	4,U4PM3C+FR2
	WL	4,U4PM3C+FR3
	WL	4,U4PM3C+FR4
	WL	4,U4PM3C+FR5
	WL	4,U4PM3C+FR6
	WL	4,U4PM3C+FR7

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

	WL	5,U4PM3C+FR6
	.word	ANI_OFFSET,-20,-50,0			;x,y,z
	WL	4,U3MS3Z+FR5
	WL	4,U3MS3Z+FR4
	WL	4,U3MS3Z+FR3
	WL	4,U3MS3Z+FR2
	WL	4,U3MS3Z+FR1
	WL	4,U4GH3C+FR10
	.word	ANI_WAITHITGND
	WL	4,U2ST2C+FR1

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

; SUBR	und_summon_anim
;
;	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
;	.word	ANI_ZEROVELS
;	.word	ANI_SETSPEED,100h
;
;	WL	4,U4SW4A+FR1
;	WL	4,U4SW4A+FR2
;	WL	4,U4SW4A+FR3
;	WL	4,U4SW4A+FR4
;	WL	4,U4SW4A+FR5
;	WL	20,U4SW4A+FR6
;	WL	4,U4SW4A+FR5
;	WL	4,U4SW4A+FR4
;	WL	4,U4SW4A+FR3
;	WL	4,U4SW4A+FR2
;	WL	4,U4SW4A+FR1
;	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
;
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END

#*****************************************************************************

; SUBR	und_summon2_anim
;
;	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
;	.word	ANI_ZEROVELS
;	.word	ANI_SETSPEED,100h
;
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END

#*****************************************************************************
*
* TOMBSTONE SMASH ATTACK

 SUBR	und_tombstone_smash_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	2,U3TBSM+FR1
	WL	1,U3TBSM+FR2

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR1,1 ;image, zoff (priority)
	WL	1,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR2,1 ;image, zoff (priority)
	WL	1,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR3,1 ;image, zoff (priority)
	WL	1,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR4,1 ;image, zoff (priority)
	WL	1,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR5,1 ;image, zoff (priority)
	WL	1,U3TBSM+FR2
	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE

	.word	ANI_SET_RPTCOUNT,5	;repeat max 3 times
#rpt_loop
	.word	ANI_CLR_BUTCOUNT

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR6,-1 ;image, zoff (priority)
	WL	1,U3TBSM+FR3

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR7,-1 ;image, zoff (priority)
	WL	1,U3TBSM+FR4

	.word	ANI_STARTATTACK,AT_LEAPING,10

	WWL	ANI_SETLONG,OBJ_GRAVITY,0c000h
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 10,999,65,45,90000h,TGT_HEAD,80,102,2
	LEAPATOPP 10,999,65,45,90000h,TGT_HEAD,80,102,-10

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR8,-1 ;image, zoff (priority)
	WL	4,U3TBSM+FR5

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR9,-1 ;image, zoff (priority)
	WL	3,U3TBSM+FR6

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR10,-1 ;image, zoff (priority)
	WL	3,U3TBSM+FR7

	.word	ANI_ATTACK_ON, AMODE_TOMB,54,95,50,31 ;mode,x,y,w,h
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR11,-1 ;image, zoff (priority)
	WL	4,U3TBSM+FR8

	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

	WL	ANI_IFNOTSTATUS,#missed_nancy_boy
	WL	ANI_IFBLOCKED,#missed_nancy_boy

;got him
	.ref	und_tombbits
	WLWWWW	ANI_CREATEPROC,und_tombbits,00h,0,0,0	;addr,ID,w1,w2,w3

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#last_hit
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IFNOT_RPTCOUNT,#last_hit

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR15,-1 ;image, zoff (priority)
	WL	1,U3TBSM+FR11
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT

	WL	6,U3TBSM+FR11

	WL	ANI_GOTO,#rpt_loop

#last_hit
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR15,-1 ;image, zoff (priority)
	WL	1,U3TBSM+FR11
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	WL	6,U3TBSM+FR11

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR5,1 ;image, zoff (priority)
	WL	3,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR4,1 ;image, zoff (priority)
	WL	3,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR3,1 ;image, zoff (priority)
	WL	3,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR2,1 ;image, zoff (priority)
	WL	3,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR1,1 ;image, zoff (priority)
	WL	3,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,0,0
	WL	1,U3TBSM+FR2
	WL	3,U3TBSM+FR1

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed_nancy_boy
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR12,-1 ;image, zoff (priority)
	WL	2,U3TBSM+FR9
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR16,-1 ;image, zoff (priority)

	WL	1,U3TBSM+FR9

	.ref	und_tombbits2
	WLWWWW	ANI_CREATEPROC,und_tombbits2,00h,0,0,0	;addr,ID,w1,w2,w3

	WL	2,U3TBSM+FR9
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR17,-1 ;image, zoff (priority)
	WL	10,U3TBSM+FR9

	WLW	ANI_ATTCHIMAGE,0,0
	WL	1,U3TBSM+FR9

	WL	3,U3TBSM+FR10
	WL	3,U3TBSM+FR11

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#gothim	;once
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR11,-1 ;image, zoff (priority)
	WL	3,U3TBSM+FR6

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR12,-1 ;image, zoff (priority)
	WL	16,U3TBSM+FR7
	WLW	ANI_ATTCHIMAGE,0,0

	WL	3,U3TBSM+FR8
	WL	3,U3TBSM+FR9
	WL	3,U3TBSM+FR10

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#TOMBSTONE
	.long	0		;0
	.long	TOMBFORM01	;1
	.long	TOMBFORM02	;2
	.long	TOMBFORM03	;3
	.long	TOMBFORM04	;4
	.long	TOMBSTN01	;5
	.long	TOMBSTN02	;6
	.long	TOMBSTN03	;7
	.long	TOMBSTN04	;8
	.long	TOMBSTN05	;9
	.long	TOMBSTN06	;10
	.long	TOMBSTN07	;11
	.long	TOMBSTN08	;12
	.long	TOMBSTN09	;13
	.long	TOMBSTN010	;14
	.long	TOMBSTN011	;15
	.long	TOMBSTN012	;16
	.long	TOMBSTN013	;17


#*****************************************************************************
*
* SLIDING CHOKE ATTACK

 SUBR	und_sliding_choke_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	4,U2LN2A+FR1

	.ref	UNDNEG_P
	.ref	UNDGRY_P
	WLWW	ANI_SHADOWTRAIL,UNDNEG_P,3,12	;pal,rate,lifespan

	.word	ANI_STARTATTACK,AT_PUPPET,5
	WL	1,U2LN2A+FR2
	.word	ANI_ATTACK_ON, AMODE_PUPPET,7,83,68,24 ;mode,x,y,w,h

	;max ticks,velocity,max z,tgt,xoff,yoff,zoff
	WWLWWWWW ANI_SLIDEATOPP,30,060000h,80,TGT_HEAD,69,99,0

;;	;ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;;	LEAPATOPP 10,80,70,50,90000h,TGT_HEAD,69,99,0
;;	LEAPATOPP 30,480,370,350,90000h,TGT_HEAD,69,99,0
;;	WL	ANI_SET_YVEL,0

	WWL	ANI_WAITHITOPP,30,U2LN2A+FR2
;;;	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#gothim

;missed - punish him!

	WL	ANI_CODE,CALL_MISSES
	.word	ANI_FRICTION,4000h
	WWL	ANI_WAITHITOPP,10,U2LN2A+FR2
	WL	ANI_IFSTATUS,#gothim	;2nd chance to hit
	.word	ANI_SHADOWTRAIL,0	;off
	WWL	ANI_WAITHITOPP,25,U2LN2A+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#gothim	;2nd chance to hit
	WL	25,U2LN2A+FR2
	WL	4,U2LN2A+FR1
	.word	ANI_FACE,MOVE_RIGHT|MOVE_UP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END



#gothim
	WL	ANI_CODE,CALL_SETUP
	.word	ANI_SETPLYRMODE,MODE_CHOKEHOLD
	.word	ANI_ATTACK_OFF
	.word	ANI_ATTACHZ,0,0,-2		;put opp behind attacker

	.word	ANI_SETOPPMODE,MODE_GHOST	;can go through ground
	.word	ANI_OPP_GETUP,-140		;(neg means always set)

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_FRICTION,4000h

; attacker sequence
	WWLLW	ANI_SUPERSLAVE2,18,U2LN2A+FR2,#puppet_tbl,0
	.word	ANI_SHADOWTRAIL,0	;off
	WWLLW	ANI_SUPERSLAVE2,3,U2LN2A+FR3,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,U2LN2A+FR4,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,U2LN2A+FR5,#puppet_tbl,3

	WWLLW	ANI_SUPERSLAVE2,1,U2LN2A+FR6,#puppet_tbl,4

	.word	ANI_SETOPPFACING

	WL	ANI_SLAVEANIM,#chokeanim_tbl

	.word	ANI_FACE,MOVE_UP|MOVE_RIGHT
	.word	ANI_SETMODE,MODE_NORMAL|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_END



#chokeanim_tbl
	.long	hrt_choking_anim	;bret
	.long	rzr_choking_anim	;razor
	.long	und_choking_anim	;taker
	.long	yok_choking_anim	;yoko
	.long	shn_choking_anim	;shawn
	.long	bam_choking_anim	;bam
	.long	dnk_choking_anim	;doink
	.long	und_choking_anim	;spare
	.long	lex_choking_anim	;lex




hrt_choking_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOGRAVITY
	.word	ANI_SETPLYRMODE,MODE_CHOKING
	WL	6, H4TN4X+FR4
	WL	6, H4TN4X+FR3
	WL	6, H4TN4X+FR4
	WL	12,H4TN4X+FR5
	WL	6, H4TN4X+FR4
	WL	12,H4TN4X+FR3
	WL	6, H4TN4X+FR4
	WL	6, H4TN4X+FR5
	WL	12,H4TN4X+FR4
	WL	18,H4TN4X+FR5
	.word	ANI_REPEAT

rzr_choking_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOGRAVITY
	.word	ANI_SETPLYRMODE,MODE_CHOKING
	WL	6, R3TN3X+FR4
	WL	6, R3TN3X+FR5
	WL	6, R3TN3X+FR4
	WL	12,R3TN3X+FR3
	WL	6, R3TN3X+FR4
	WL	12,R3TN3X+FR5
	WL	6, R3TN3X+FR4
	WL	12,R3TN3X+FR5
	WL	12,R3TN3X+FR4
	WL	18,R3TN3X+FR5
	.word	ANI_REPEAT

und_choking_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOGRAVITY
	.word	ANI_SETPLYRMODE,MODE_CHOKING
	WL	6, U3TN3B+FR5
	WL	5, U3TN3B+FR3
	WL	12,U3TN3B+FR2
	WL	5, U3TN3B+FR3
	WL	6, U3TN3B+FR5
	WL	16,U3TN3B+FR6
	.word	ANI_REPEAT

yok_choking_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOGRAVITY
	.word	ANI_SETPLYRMODE,MODE_CHOKING
	WL	6, Y3TN3Z+FR5
	WL	6, Y3TN3Z+FR4
	WL	6, Y3TN3Z+FR3
	WL	6, Y3TN3Z+FR2
	WL	12,Y3TN3Z+FR1
	WL	6, Y3TN3Z+FR2
	WL	6, Y3TN3Z+FR3
	WL	6, Y3TN3Z+FR4
	WL	14-6,Y3TN3Z+FR5
	.word	ANI_REPEAT

shn_choking_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOGRAVITY
	.word	ANI_SETPLYRMODE,MODE_CHOKING
	WL	6, S3TN3X+FR3
	WL	6, S3TN3X+FR2
	WL	6, S3TN3X+FR3
	WL	6, S3TN3X+FR4
	WL	6, S3TN3X+FR3
	WL	6, S3TN3X+FR2
	WL	6, S3TN3X+FR3
	WL	12,S3TN3X+FR4
	WL	6, S3TN3X+FR3
	WL	12,S3TN3X+FR2
	WL	6, S3TN3X+FR3
	WL	12,S3TN3X+FR4
	.word	ANI_REPEAT

bam_choking_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOGRAVITY
	.word	ANI_SETPLYRMODE,MODE_CHOKING
	WL	6, B4TN4X+FR4
	WL	6, B4TN4X+FR5
	WL	12,B4TN4X+FR4
	WL	12,B4TN4X+FR5
	WL	12,B4TN4X+FR4
	WL	12,B4TN4X+FR5
	WL	12,B4TN4X+FR4
	WL	18,B4TN4X+FR5
	.word	ANI_REPEAT

dnk_choking_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOGRAVITY
	.word	ANI_SETPLYRMODE,MODE_CHOKING
	WL	6, D3TN3A+FR2
	WL	6, D3TN3A+FR3
	WL	6, D3TN3A+FR4
	WL	6, D3TN3A+FR6
	.word	ANI_REPEAT

lex_choking_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOGRAVITY
	.word	ANI_SETPLYRMODE,MODE_CHOKING
	WL	6, L3TN3X+FR4
	WL	6, L3TN3X+FR3
	WL	6, L3TN3X+FR4
	WL	6, L3TN3X+FR5
	WL	6, L3TN3X+FR4
	WL	12,L3TN3X+FR3
	WL	6, L3TN3X+FR4
	WL	12,L3TN3X+FR5
	WL	12,L3TN3X+FR4
	WL	6, L3TN3X+FR5
	WL	6, L3TN3X+FR4
	WL	12,L3TN3X+FR5
	.word	ANI_REPEAT


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
 LWWW H4TN4X+FR1,74,-4,0
 LWWW H4TN4X+FR2,62,3,0
 LWWW H4TN4X+FR3,48,11,0
 LWWW H4TN4X+FR4,38,14,0
 LWWW H4TN4X+FR5,31,13,0
 .long 0
#Razor
 LWWW R3TN3X+FR1,62,-2,0
 LWWW R3TN3X+FR2,44,6,0
 LWWW R3TN3X+FR3,49,12,0
 LWWW R3TN3X+FR4,42,14,0
 LWWW R3TN3X+FR5,36,12,0
 .long 0
#Taker
 LWWW U3TN3B+FR2,33,6,0
 LWWW U3TN3B+FR3,35,10,0
 LWWW U3TN3B+FR4,57,16,0
 LWWW U3TN3B+FR5,49,19,0
 LWWW U3TN3B+FR6,45,18,0
 .long 0
#Yokozuna
 LWWW Y3TN3Z+FR1,44,-8,0
 LWWW Y3TN3Z+FR2,42,-1,0
 LWWW Y3TN3Z+FR3,43,10,0
 LWWW Y3TN3Z+FR4,45,15,0
 LWWW Y3TN3Z+FR5,41,15,0
 .long 0
#Shawn
 LWWW S3TN3X+FR1,64,-3,0
 LWWW S3TN3X+FR2,60,3,0
 LWWW S3TN3X+FR3,50,10,0
 LWWW S3TN3X+FR4,40,14,0
 LWWW S3TN3X+FR5,30,11,0
 .long 0
#BamBam
 LWWW B4TN4X+FR1,63,-4,0
 LWWW B4TN4X+FR2,49,4,0
 LWWW B4TN4X+FR3,46,9,0
 LWWW B4TN4X+FR4,40,13,0
 LWWW B4TN4X+FR5,34,13,0
 .long 0
#Doink
 LWWW D3TN3A+FR2,61,-8,0
 LWWW D3TN3A+FR3,54,0,0
 LWWW D3TN3A+FR4,39,8,0
 LWWW D3TN3A+FR5,30,13,0
 LWWW D3TN3A+FR6,32,11,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3TN3X+FR1,67,-4,0
 LWWW L3TN3X+FR2,64,2,0
 LWWW L3TN3X+FR3,57,10,0
 LWWW L3TN3X+FR4,45,13,0
 LWWW L3TN3X+FR5,38,12,0
 .long 0


#*****************************************************************************
*
* SLAM DOWN FROM CHOKE HOLD (U_NKSL)

 SUBR	und_chokeslam_anim

	WL	ANI_SET_YVEL,48000h

;Fix!!  Make other name for this move
	WL	ANI_CODE,DO_PILE_MESS

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_ATTACHZ,0,0,-2		;put opp behind attacker
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	WL	ANI_SLAVEANIM,slaveanim_tbl
	WWLLW	ANI_SUPERSLAVE2,4,U2NS3X+FR1,#puppet_tbl,0
	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker
	WWLLW	ANI_SUPERSLAVE2,4,U2NS3X+FR2,#puppet_tbl,1
	WLW	ANI_SET_ZVEL,-60000h,AM_ABS
	WWLLW	ANI_SUPERSLAVE2,4,U2NS3X+FR3,#puppet_tbl,2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT

	WWLLW	ANI_SUPERSLAVE2,3,U2NS3X+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,U2NS3X+FR5,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,U2NS3X+FR6,#puppet_tbl,5

	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_ATTACHZ,0,0,50		;put opp in front of attacker
	WWLLW	ANI_SUPERSLAVE2,2,U2NS3X+FR7,#puppet_tbl,6

	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#slambounce_tbl
	WLLL	ANI_SETOPPVELS,0,40000h,30000h		;x,y,z vels

	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_NECKSLAM

;;;	.word	ANI_OPP_GETUP,150	;30

	WL	22,U2NS3X+FR7
	WL	4,U2NS3X+FR8
	WL	4,U2NS3X+FR9
	WL	4,U2NS3X+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END



;	WL	4,U4NS3B+FR11
; this isn't loaded-----------------




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
 LWWW H3UC3X+FR1,37,18,1
 LWWW H3UC3X+FR2,20,27,1
 LWWW H3UC3X+FR3,13,23,1
 LWWW H3UC3X+FR4,9,33,1
 LWWW H3UC3X+FR5,18,40,1
 LWWW H3UC3X+FR5,28,11,1
 LWWW H2CP3A+FR8,19,-57,0
 .long 0
#Razor
 LWWW R3FD3B+FR1,35,18,1
 LWWW R3FD3B+FR2,25,22,1
 LWWW R3FD3B+FR3,23,23,1
 LWWW R3FD3B+FR4,16,31,1
 LWWW R3FD3B+FR5,17,29,1
 LWWW R3FD3B+FR5,28,-4,1
 LWWW R3GU2A+FR1,30,-52,0
 .long 0
#Taker
 LWWW U3FD3X+FR1,30,16,0
 LWWW U3FD3X+FR2,24,18,0
 LWWW U3FD3X+FR3,15,16,0
 LWWW U3FD3X+FR4,-2,32,0
 LWWW U3FD3X+FR5,4,50,0
 LWWW U3FD3X+FR5,13,17,0
 LWWW U3CP3B+FR1,13,-48,0
 .long 0
#Yokozuna
 LWWW Y3BO3C+FR4,19,18,0
 LWWW Y3FD3A+FR2,18,38,1
 LWWW Y3FD3A+FR3,21,28,1
 LWWW Y3FD3A+FR4,18,35,1
 LWWW Y3FD3A+FR5,22,38,1
 LWWW Y3FD3A+FR5,36,12,1
 LWWW Y3FD3A+FR7,32,-31,1
 .long 0
#Shawn
 LWWW S4LB3A+FR7,34,21,1
 LWWW S3UC3X+FR2,11,25,1
 LWWW S3UC3X+FR3,19,17,1
 LWWW S3UC3X+FR4,15,19,1
 LWWW S3UC3X+FR5,16,32,1
 LWWW S3UC3X+FR6,32,21,1
 LWWW S3OS3X+FR10,32,-49,0
 .long 0
#BamBam
 LWWW B4UC3B+FR1,22,21,1
 LWWW B4UC3B+FR2,22,20,1
 LWWW B4UC3B+FR3,22,10,1
 LWWW B4UC3B+FR4,18,20,1
 LWWW B4UC3B+FR5,20,33,1
 LWWW B4UC3B+FR5,31,3,1
 LWWW B3RL1A+FR1,30,-47,0
 .long 0
#Doink
 LWWW D3UC3A+FR1,30,16,1
 LWWW D3UC3A+FR3,13,37,1
 LWWW D3UC3A+FR4,14,29,1
 LWWW D3UC3A+FR5,9,33,1
 LWWW D3UC3A+FR6,15,20,1
 LWWW D3UC3A+FR7,23,14,1
 LWWW D3SA3A+FR9,17,-53,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3TN3X+FR5,38,12,1
 LWWW L3UC3X+FR1,17,19,1
 LWWW L3UC3X+FR2,24,15,1
 LWWW L3UC3X+FR3,23,6,1
 LWWW L3UC3X+FR4,19,39,1
 LWWW L3UC3X+FR5,23,59,1
 LWWW L3UC3X+FR5,36,19,1
 LWWW L3CP3X+FR1,34,-51,1
 .long 0


#*****************************************************************************
*
* TOMBSTONE (FROM HEAD HOLD)  (U_TOMB)

 SUBR	und_tombstone_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL



	.word	ANI_ATTACK_ON, AMODE_PUPPET,32,15,45,41 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,U3PG3A+FR7
	.word	ANI_ATTACK_OFF

;	WL	ANI_IFNOTSTATUS,#missed

;Check to see if I have tried to pile drive Yokozuna!

	.word	ANI_SOUND,82h			;Effort grunt

;FIX!! Yoko check
;	WL	ANI_CODE,is_this_yoko
;	WL	ANI_IFSTATUS,#yoko_miss

;got him
	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED





	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WL	ANI_SET_YVEL,28000h

;	WWL	ANI_SETLONG,OBJ_GRAVITY,0c000h
;	WL	ANI_SET_YVEL,080000h

	WL	ANI_SLAVEANIM,slaveanim_tbl

	WWLLW	ANI_SUPERSLAVE2,5,U3PG3A+FR7,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,5,U3PG3A+FR8,#puppet_tbl,1
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	WWLLW	ANI_SUPERSLAVE2,4,U3ZT3A+FR1,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,U3ZT3A+FR2,#puppet_tbl,3
	WWL	ANI_SETLONG,OBJ_GRAVITY,09800h
	WL	ANI_SET_YVEL,0a0000h
;Float toward the center of ring!
	.ref	set_xdrift
	WL	ANI_CODE,set_xdrift
	WWLLW	ANI_SUPERSLAVE2,4,U3ZT3A+FR3,#puppet_tbl,4
	.word	ANI_OFFSET,0,32,0			;x,y,z
	WWLLW	ANI_SUPERSLAVE2,4,U3ZT3A+FR4,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,10,U3ZT3A+FR5,#puppet_tbl,6

;do message
;Fix!!  Make other name for this move
	.ref	DO_PILE_MESS
	WL	ANI_CODE,DO_PILE_MESS

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

;impact
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_PILEDRIVER

	WWLLW	ANI_SUPERSLAVE2,4,U3ZT3A+FR7,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,4,U3ZT3A+FR8,#puppet_tbl,8

	WL	ANI_CODE,CALL_SPECIAL_MOVE

	WL	ANI_XFLIP_TBL,#xflip_tbl
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	WL	ANI_SLAVEANIM,#breakneck_tbl
	WLLL	ANI_SETOPPVELS,30000h,60000h,0	;x,y,z vels

	.word	ANI_DETACH

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	WL	12,U3ZT3A+FR8

	WL	6,U3GD2A+FR5
	WL	6,U3GD2A+FR6
	WL	6,U3GD4A+FR7
	WL	6,U3GD4A+FR8

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
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
 LWWW H3PP3X+FR1,21,-42,0
 LWWW H3PP3X+FR2,16,10,0
 LWWW H3PP3X+FR3,8,29,0
 LWWW H3PP3X+FR4,12,28,0
 LWWW H3PP3X+FR5,32,47,0
 LWWW H3PP3X+FR6,36,49,0
 LWWW H3PP3X+FR6,41,49,0
 LWWW H3PP3X+FR7,51,14,0
 LWWW H3PP3X+FR8,71,-3,0
 .long 0
#Razor
 LWWW R3GP3Z+FR1,20,-41,0
 LWWW R3GP3Z+FR2,24,-19,0
 LWWW R3GP3Z+FR3,16,14,0
 LWWW R3GP3Z+FR4,31,30,0
 LWWW R3GP3Z+FR5,41,45,0
 LWWW R3GP3Z+FR6,49,47,0
 LWWW R3GP3Z+FR6,54,47,0
 LWWW R3GP3Z+FR7,51,32,0
 LWWW R3GP3Z+FR8,70,-6,0
 .long 0
#Taker
 LWWW U3PP3X+FR1,19,-37,1
 LWWW U3PP3X+FR2,25,-16,1
 LWWW U3PP3X+FR3,11,-14,1
 LWWW U3PP3X+FR4,12,-3,1
 LWWW U3PP3X+FR5,35,33,1
 LWWW U3PP3X+FR6,44,56,1
 LWWW U3PP3X+FR6,49,56,1
 LWWW U3GP3X+FR1,54,8,1
 LWWW U3GP3X+FR2,81,-12,1
 .long 0
#Yokozuna
 LWWW Y3PP3Q+FR1,17,-37,0
 LWWW Y3PP3Q+FR2,22,-21,0
 LWWW Y3PP3Q+FR3,20,-17,0
 LWWW Y3PP3Q+FR4,29,-14,0
 LWWW Y3PP3Q+FR6,33,11,0
 LWWW Y3PP3Q+FR7,39,18,0
 LWWW Y3PP3Q+FR7,44,18,0
 LWWW Y3FD3N+FR2,50,13,0
 LWWW Y3FD3N+FR3,72,16,0
 .long 0
#Shawn
 LWWW S3GP3X+FR1,25,-41,0
 LWWW S3GP3X+FR2,24,-18,0
 LWWW S3GP3X+FR3,20,-5,0
 LWWW S3GP3X+FR4,26,23,0
 LWWW S3GP3X+FR5,38,35,0
 LWWW S3OS3X+FR8,50,29,1
 LWWW S3OS3X+FR8,55,29,1
 LWWW S3FD3X+FR2,60,21,0
 LWWW S3GP3X+FR6,79,-3,0
 .long 0
#BamBam
 LWWW B3PP3Q+FR1,19,-44,0
 LWWW B3PP3Q+FR2,25,-12,0
 LWWW B3PP3Q+FR3,24,5,0
 LWWW B3PP3Q+FR4,31,21,0
 LWWW B3PP3Q+FR5,43,39,0
 LWWW B3PP3Q+FR6,41,47,0
 LWWW B3PP3Q+FR6,46,47,0
 LWWW B3PP3Q+FR7,54,22,0
 LWWW B3FD3C+FR1,69,2,0
 .long 0
#Doink
 LWWW D3PD3Z+FR1,20,-49,1
 LWWW D3PD3Z+FR2,25,-17,1
 LWWW D3PD3Z+FR3,18,2,1
 LWWW D3PD3Z+FR4,20,31,1
 LWWW D3PD3Z+FR5,32,44,1
 LWWW D3PD3Z+FR6,51,36,1
 LWWW D3PD3Z+FR6,56,36,1
 LWWW D3PD3Z+FR8,60,4,1
 LWWW D3PD3Z+FR9,85,-12,1
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3GP3Z+FR1,17,-42,0
 LWWW L3GP3Z+FR2,26,-20,0
 LWWW L3GP3Z+FR3,22,-13,0
 LWWW L3GP3Z+FR4,24,3,0
 LWWW L3GP3Z+FR5,38,18,0
 LWWW L3GP3Z+FR6,47,34,0
 LWWW L3GP3Z+FR6,52,34,0
 LWWW L3FH3A+FR6,51,17,0
 LWWW L3FD3B+FR1,75,-4,0
 .long 0


	.ref	hrt_break_neck2_anim
	.ref	rzr_break_neck2_anim
	.ref	yok_break_neck2_anim
	.ref	shn_break_neck2_anim
	.ref	bam_break_neck2_anim
	.ref	dnk_break_neck2_anim
	.ref	lex_break_neck2_anim

#breakneck_tbl
	.long	hrt_break_neck2_anim	;0
	.long	rzr_break_neck2_anim	;1
	.long	und_break_neck2_anim	;2
	.long	yok_break_neck2_anim	;3
	.long	shn_break_neck2_anim	;4
	.long	bam_break_neck2_anim	;5
	.long	dnk_break_neck2_anim	;6
	.long	lex_break_neck2_anim	;7
	.long	lex_break_neck2_anim	;8


#*****************************************************************************
*
* NECKBREAKER (from head hold)

 SUBR	und_neckbreaker2_anim
;Standing no vel

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_ATTACK_ON, AMODE_PUPPET,0,15,45,41 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,22,U4GH3C+FR11
	WL	4,U4GH3C+FR11
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missed

	.word	ANI_OFFSET,15,0,0	;x,y,z
	WL	ANI_GOTO,#gothim

 SUBR	und_neckbreaker3_anim
;Sliding neck breaker

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
  
	WLWW	ANI_SHADOWTRAIL,UNDNEG_P,3,12	;pal,rate,lifespan

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,70,70,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_SET_YVEL,0000h

	.word	ANI_ATTACK_ON, AMODE_PUPPET,0,15,45,41 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,12,U4GH3C+FR11
	.word	ANI_ZERO_XZVELS
	WL	4,U4GH3C+FR11
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missed

	.word	ANI_OFFSET,15,0,0	;x,y,z
	WL	ANI_GOTO,#gothim

 SUBR	und_neckbreaker_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h


;Do this to setup attach_proc
;Also allow misses!

	.word	ANI_OFFSET,15,0,0	;x,y,z
	.word	ANI_ATTACK_ON, AMODE_PUPPET,32,15,45,41 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,U3DD3A+FR1
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missed

;Check to see if I have tried to pile drive Yokozuna!
#gothim
	.word	ANI_SOUND,82h			;Effort grunt

	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST	;can go through ground
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL

	WL	ANI_SLAVEANIM,slaveanim_tbl

	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR5,#puppet_tbl,4

	WWL	ANI_SETLONG,OBJ_GRAVITY,0c000h
	WL	ANI_SET_YVEL,80000h

;do message
;Fix!!  make up other name for move...
	WL	ANI_CODE,DO_PILE_MESS

	WWLLW	ANI_SUPERSLAVE2,6,U3DD3A+FR6,#puppet_tbl,5
	.word	ANI_OFFSET,-5,45,0	;x,y,z

	WWLLW	ANI_SUPERSLAVE2,1,U3DD3A+FR7,#puppet_tbl,6
	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

;impact
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_NECKBRKR
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR9,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR10,#puppet_tbl,8

	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#slambounce_tbl
	WLLL	ANI_SETOPPVELS,0,60000h,0	;x,y,z vels

	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP

;	WL	8,U3DD3A+FR10
	WL	8,U3SU3A+FR2

;;	.word	ANI_SINGLESTEP

;	.word	ANI_FACE,MOVE_RIGHT|MOVE_UP
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END
  
	WL	ANI_CODE,#zero_butn

	.word	ANI_SHADOWTRAIL,0	;off

	WL	ANI_CHANGEANIM,und_faceup_getup_anim

#missed
;	WL	3,U3DD3A+FR1
;	WL	3,U3DD3A+FR2
;	WL	3,U3DD3A+FR3
;	WL	3,U3DD3A+FR4
;	WL	8,U3DD3A+FR5
;	WL	3,U3DD3A+FR4
;	WL	3,U3DD3A+FR3
;	WL	3,U3DD3A+FR2

	.word	ANI_SHADOWTRAIL,0	;off
	WL	ANI_CODE,#zero_butn

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#zero_butn
;Force player to start holding his button down starting at the end
;of the current buzz sequence.

	move	*a13(PLYRNUM),a0
	X16	a0
	.ref	punch_dtime1
	addi	punch_dtime1,a0
	clr	a14
	move	a14,*a0
	rets

#xflip_tbl
	.word	0 ;bret
	.word	0 ;razor
	.word	0 ;taker
	.word	1 ;yoko
	.word	0 ;shawn
	.word	0 ;bam
	.word	0 ;doink
	.word	1 ;spare
	.word	0 ;lex

#slambounce_tbl
	.long	hrt_slambounce2_anim	;bret
	.long	rzr_slambounce2_anim	;razor
	.long	und_slambounce2_anim	;taker
	.long	yok_slambounce2_anim	;yoko
	.long	shn_slambounce2_anim	;shawn
	.long	bam_slambounce2_anim	;bam
	.long	dnk_slambounce2_anim	;doink
	.long	und_slambounce2_anim	;spare
	.long	lex_slambounce2_anim	;lex

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
 LWWW H3DD3B+FR1,30,-37,1
 LWWW H3DD3B+FR2,40,-34,1
 LWWW H3DD3B+FR3,44,-21,1
 LWWW H3DD3B+FR4,51,-11,1
 LWWW H3UC3X+FR2,32,7,1
 LWWW H3UC3X+FR3,53,14,1
 LWWW H3UC3X+FR4,75,17,1
 LWWW H2CP3A+FR1,89,-12,0
 LWWW H3UC3Z+FR10,74,-2,1
 .long 0
#Razor
 LWWW R3DD3C+FR1,31,-36,1
 LWWW R3DD3C+FR2,37,-25,1
 LWWW R3DD3C+FR3,52,-13,1
 LWWW R3DD3C+FR6,60,-6,1
 LWWW R3DD3C+FR7,37,-7,1
 LWWW R3FD3B+FR4,62,21,1
 LWWW R3FD3B+FR5,77,29,1
 LWWW R3AM3D+FR2,90,-14,0
 LWWW R3AM3X+FR1,87,-16,1
 .long 0
#Taker
 LWWW U3DD3B+FR1,35,-35,1
 LWWW U3DD3B+FR2,37,-15,1
 LWWW U3DD3B+FR3,37,-9,1
 LWWW U3DD3B+FR4,46,-8,1
 LWWW U3DD3B+FR6,38,-4,1
 LWWW U3DD3B+FR7,61,3,1
 LWWW U3FD3X+FR4,60,18,0
 LWWW U3CP3B+FR3,77,0,0
 LWWW U3DD3X+FR9,79,-6,1
 .long 0
#Yokozuna
 LWWW Y4AM4A+FR4,44,-33,0
 LWWW Y4AM4A+FR3,43,-27,0
 LWWW Y3FD3B+FR2,44,-16,1
 LWWW Y3FD3B+FR3,47,-8,1
 LWWW Y3FD3B+FR4,39,15,1
 LWWW Y3FD3B+FR5,69,33,1
 LWWW Y3FD3A+FR4,78,34,1
 LWWW Y3CP3B+FR1,79,-12,0
 LWWW Y3FD3Z+FR7,80,5,1
 .long 0
#Shawn
 LWWW S3DD3B+FR1,35,-35,1
 LWWW S3DD3B+FR2,37,-23,1
 LWWW S3DD3B+FR3,39,-15,1
 LWWW S3DD3B+FR5,52,-10,1
 LWWW S3UC3X+FR2,32,4,1
 LWWW S3UC3X+FR4,66,9,1
 LWWW S3UC3X+FR5,84,28,1
 LWWW S3CP3B+FR2,87,-11,0
 LWWW S3UC3Z+FR8,90,0,1
 .long 0
#BamBam
 LWWW B3DD3D+FR1,41,-38,1
 LWWW B3DD3D+FR2,42,-23,1
 LWWW B3DD3D+FR3,44,0,1
 LWWW B3DD3D+FR4,51,17,1
 LWWW B3DD3D+FR5,41,31,1
 LWWW B3DD3D+FR6,67,39,1
 LWWW B4UC3B+FR3,82,12,1
 LWWW B3CP3B+FR2,90,19,0
 LWWW B4UC3Z+FR8,88,0,1
 .long 0
#Doink
 LWWW D3DD3C+FR1,38,-37,1
 LWWW D3DD3C+FR2,40,-26,1
 LWWW D3DD3C+FR3,37,1,1
 LWWW D3DD3C+FR4,42,15,1
 LWWW D3DD3C+FR5,31,23,1
 LWWW D3UC3A+FR3,56,21,1
 LWWW D3UC3A+FR5,75,21,1
 LWWW D3SA3A+FR4,78,-16,0
 LWWW D3SA3X+FR2,84,-18,1
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3DD3A+FR1,29,-40,1
 LWWW L3DD3A+FR2,31,-22,1
 LWWW L3DD3A+FR3,29,-21,1
 LWWW L3UC3X+FR2,49,-16,1
 LWWW L3UC3X+FR3,34,-9,1
 LWWW L3CP3X+FR2,64,-1,0
 LWWW L3CP3X+FR3,87,14,0
 LWWW L3CP3X+FR6,82,16,0
 LWWW L3UC3Z+FR10,74,1,1
 .long 0


#*****************************************************************************
*
* SNAP MIRROR (whatever)

 SUBR	und_2_snapmirror2_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	1,U1TT5A+FR3
	WL	1,U1TT5A+FR4

 SUBR	und_4_snapmirror2_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,2
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,60,60,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_SET_YVEL,0000h

	WL	2,U4FG3A+FR1
	.word	ANI_ATTACK_ON, AMODE_PUPPET,33,36,44,48 ;mode,x,y,w,h
	WL	2,U4FG3A+FR2
	WWL	ANI_WAITHITOPP,8,U4FG3A+FR3
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACK_OFF

	WL	ANI_GOTO,#cont


 SUBR	und_2_snapmirror_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	1,U1TT5A+FR3
	WL	1,U1TT5A+FR4

 SUBR	und_4_snapmirror_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,8
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_SET_YVEL,0000h

	WL	2,U4FG3A+FR1
	WL	2,U4FG3A+FR2
	.word	ANI_ATTACK_ON, AMODE_PUPPET,12,59,73,59 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,3,U4FG3A+FR3
	.word	ANI_ZERO_XZVELS
	WWL	ANI_WAITHITOPP,3,U4FG3A+FR3
	.word	ANI_ATTACK_OFF
#cont
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb

;got him
	.ref	DO_SNAP_MESS
	WL	ANI_CODE,DO_SNAP_MESS
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	.word	ANI_OFFSET,0,0,-2			;x,y,z
	.word	ANI_ATTACHZ,0,0,-2		;put opp behind attacker
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_FACE,MOVE_LEFT|MOVE_DOWN
	WL	ANI_CODE,SMALL_BOUNCE
	WWLLW	ANI_SUPERSLAVE2,10,U4FT3A+FR3,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,6,U4FT3A+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4+0,U4FT3A+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4+0,U4FT3A+FR6,#puppet_tbl,3
	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker
	WWLLW	ANI_SUPERSLAVE2,4+0,U4FT3A+FR7,#puppet_tbl,4

	;impact
	.word	ANI_SOUND,0C1h			;plywood crash #3
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,35
	.word	ANI_DAMAGEOPP,D_HIPTOSS


	.word	ANI_OPP_GETUP,300


	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#slambounce_tbl
	.word	ANI_CLROPPMODE,MODE_GHOST
	WLLL	ANI_SETOPPVELS,30000h,40000h,0	;x,y,z vels

	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP

	WL	5,U4FT3A+FR8
	.word	ANI_XFLIP
	WL	5,U4FT3A+FR9
	WL	5,U4FT3A+FR10
	WL	5,U4FT3A+FR11

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedb
#missed
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	WL	16,U4FG3A+FR3
	WL	4,U4FG3A+FR2
	WL	4,U4FG3A+FR1

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
 LWWW H2AM3A+FR1,63,-7,1
 LWWW H3FR3A+FR2,32,34,1
 LWWW H3FR3A+FR4,-32,41,1
 LWWW H3FR3A+FR5,-59,6,1
 LWWW H2CP3A+FR8,-147,-56,0
 .long 0
#Razor
 LWWW R3TD3A+FR1,52,-1,1
 LWWW R3TD3A+FR4,33,31,1
 LWWW R3TD3A+FR6,-17,39,1
 LWWW R3TD3A+FR8,-51,19,1
 LWWW R3GU2A+FR1,-143,-53,0
 .long 0
#Taker
 LWWW U4AM4C+FR4,55,-9,1
 LWWW U3FH3A+FR2,32,38,0
 LWWW U3FH3A+FR4,-34,49,0
 LWWW U3FH3A+FR5,-59,28,0
 LWWW U3CP3B+FR1,-152,-49,0
 .long 0
#Yokozuna
 LWWW Y3MS3Z+FR2,63,0,1
 LWWW Y3FL3W+FR4,39,53,1
 LWWW Y3FL3W+FR6,-36,61,1
 LWWW Y3FL3W+FR7,-58,22,1
 LWWW Y3FD3A+FR7,-117,-32,1
 .long 0
#Shawn
 LWWW S3OS3X+FR4,28,-4,0
 LWWW S3OS3X+FR6,23,66,0
 LWWW S3OS3X+FR8,-12,71,0
 LWWW S3OS3X+FR9,-58,34,0
 LWWW S3OS3X+FR10,-115,-44,0
 .long 0
#BamBam
 LWWW B4TD3B+FR3,41,-17,1
 LWWW B4TD3B+FR5,44,54,1
 LWWW B4TD3B+FR7,-29,67,1
 LWWW B4TD3B+FR8,-51,26,1
 LWWW B4TD3B+FR9,-111,-43,1
 .long 0
#Doink
 LWWW D3PM4C+FR2,45,-4,1
 LWWW D3OS3A+FR3,32,27,1
 LWWW D3OS3A+FR6,-21,42,1
 LWWW D3FD3E+FR2,-62,-8,1
 LWWW D3SA3A+FR2,-140,-53,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L4AM4B+FR2,66,-10,1
 LWWW L3FH3A+FR3,41,44,1
 LWWW L3FH3A+FR5,-22,34,1
 LWWW L3FH3A+FR6,-45,14,1
 LWWW L3CP3X+FR1,-146,-47,0
 .long 0


#*****************************************************************************
*
* END OF NECK BROKEN SEQ.

 SUBR	und_neckbroken_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	1,U3CR3A+FR1
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,und_getup_anim


#*****************************************************************************
*
* CLIMB UP TURNBUCKLES

 SUBR	und_climb_up_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	5,U2CT2C+FR5
	WL	5,U2CT2C+FR6
	WL	9,U2CT2C+FR7
	WL	4,U2CT2C+FR8

	WL	ANI_CODE,tgt_tbukl
	.word	ANI_LEAPATPOS,25,200,10,6,0	;#ticks,dist,xoff,yoff,zoff

	WL	25,U2CT2C+FR9

	.word	ANI_SETPLYRMODE,MODE_ONTURNBKL
	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE | MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SHAKECORNER
;	WL	8,U2CT2C+FR10

#lp
	WL	5,U4SB4A+FR8
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR7
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR6
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR5
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR4
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR3
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR2
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR1
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR2
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR3
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR4
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR5
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR6
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR7
	WL	ANI_CODE,tbukl_flip
	WL	ANI_GOTO,#lp

#*****************************************************************************
*
* CLIMB DOWN TURNBUCKLES

 SUBR	und_climb_down_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SHAKECORNER

	WL	4,U2CT2C+FR8

	WLW	ANI_SET_XVEL,10000h,AM_FACE_REL
	WLW	ANI_SET_ZVEL,-10000h,AM_FACE_REL
	WL	ANI_SET_YVEL,20000h

	WL	1,U2CT2C+FR9
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	4,U2CT2C+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


	.ref	set_position,make_white,make_norm,start_smoke
	.ref	am_I_dizzy
	.ref	und_dizzy_anim
	.ref	set_skeleton_pal,set_my_pal

#*****************************************************************************
*
* GET BUZZED FROM DOINK

 SUBR	und_get_buzz_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;	.word	ANI_XFLIP
	.word	ANI_GRAVITY_OFF

	WL	ANI_CODE,set_position

	WL	ANI_CODE,set_skeleton_pal
	WL	2,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,U4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	ANI_CODE,make_white
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_norm
	WL	ANI_CODE,set_my_pal
	WL	3,U4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,U4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_white
	WL	3,U4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,U4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,U4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	ANI_CODE,make_white
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_norm
	WL	ANI_CODE,set_my_pal
	WL	3,U4BZ4A+FR1

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
	WL	3,U4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,U4BZ4A+FR1
	WL	ANI_CODE,#make_black
	WL	3,U4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,U4BZ4A+FR1
	WL	ANI_CODE,#make_black
	WL	3,U4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,U4BZ4A+FR1

	.word	ANI_WAITHITGND
	.word	ANI_XFLIP
	.word	ANI_FACEDOWN
	.word	ANI_OFFSET,-20,0,0			;x,y,z

	WL	1,U4ST4D+FR5

	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	.ref	und_fall_back_anim

	WL	ANI_CHANGEANIM,und_fall_back_anim
	.word	ANI_END

#nodead
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#make_black

;This is a black color within the wrestler's pal.  It is different for each
;wrestler.
	movi	1e1eh,a14

	move	a14,*a13(OBJ_CONST)
	move	*a13(OBJ_CONTROL),a14
	andni	01111b,a14
	ori	M_CONNON,a14
	move	a14,*a13(OBJ_CONTROL)
	rets

	
#*****************************************************************************

 SUBR	und_3_head_held_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_HEADHELD
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim

	.word	ANI_SETWORD,USR_VAR1,0		;loop count

#loop
	WL	4,U4BF3Z+FR5
	WL	4,U4BF3Z+FR7
	WL	4,U4BF3Z+FR9
	WL	4,U4BF3Z+FR10
	WL	4,U4BF3Z+FR1
	WL	4,U4BF3Z+FR2
	WL	4,U4BF3Z+FR3
	WL	ANI_CODE,#inc_loop
	WL	ANI_IFNOTSTATUS,#loop

;Continue into break...

 SUBR	und_3_head_held_brk_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WLW	ANI_SET_XVEL,-38000h,AM_NEWFACE_REL
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	WL	4,U4BF3A+FR2
	.word	ANI_DETACH

;Standard #2 head hit from spin kick
	WL	3,U2AH3A+FR3
	WL	3,U2AH3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,U2AH3A+FR5
	WL	3,U2AH3A+FR6
	WL	3,U2AH3A+FR7

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

 SUBR	und_3_head_held_stand_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	3,U4BF3Z+FR3
	WL	3,U1TT5A+FR2	;2.5
	.word	ANI_DETACH

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* ROLL OVER AND BREAK YER STINKIN' NECK

 SUBR	und_break_neck_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	3,U3GP3X+FR3
	.word	ANI_OFFSET,5,0,0
	WL	4,U3GP3X+FR4
	.word	ANI_OFFSET,8,0,0
	WL	4,U3GP3X+FR5
	.word	ANI_OFFSET,27,0,0
	WL	4,U3GP3X+FR6

	.word	ANI_XFLIP

	.word	ANI_OFFSET,22,0,0			;x,y,z

	WL	10,U3CR3A+FR7

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,und_getup_anim

 SUBR	und_break_neck2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,60000h
	.ref	ckzpos
	WL	ANI_CODE,ckzpos
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim

	.word	ANI_XFLIP
	WL	5,U3GP3X+FR3
	WL	5,U3GP3X+FR4
	WL	5,U3GP3X+FR5
	WL	5,U3GP3X+FR6
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
;	.word	ANI_SOUND,bounce_l1
	.word	ANI_ZEROVELS
	.word	ANI_XFLIP
	.word	ANI_OFFSET,-22,0,0			;x,y,z

	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	WL	10,U3CR3A+FR7
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,und_getup_anim

 SUBR	und_break_neck3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,58000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	.ref	ckzpos
	WL	ANI_CODE,ckzpos

	.word	ANI_DEBRIS,300,5,0,-5,0	;%chance, tbl index, x,y,z off

	WL 	15,U4POGO+FR4
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim

;	.word	ANI_XFLIP
	WL	4,U3GP3X+FR1
	WL	4,U3GP3X+FR2
	WL	4,U3GP3X+FR3
	WL	4,U3GP3X+FR4
	WL	4,U3GP3X+FR5
	WL	4,U3GP3X+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_XFLIP
	.word	ANI_OFFSET,-22,0,0			;x,y,z

	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	WL	10,U3CR3A+FR7
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,und_getup_anim

******************************************************************************

 SUBR	und_2_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

;Too many turns here!
;Fix!!
	WL	2,U1TT5A+FR2
	WL	2,U1TT5A+FR3
	WL	2,U1TT5A+FR4

 SUBR	und_4_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

;Put cool cheers here
;	.word	ANI_RAWSOUND,2055		;big cheer #1
;	.word	ANI_CHEER,3

	WL	4,U4GH3C+FR1

	LEAPATOPP 8,999,80,80,30000h,TGT_HEAD,0,6,0
	WL	4,U4GH3C+FR2
	WL	4,U4GH3C+FR3
	.word	ANI_ZERO_XZVELS
	WL	4,U4GH3C+FR4
	WL	4,U4GH3C+FR5

	.word	ANI_ATTACK_ON, AMODE_PUPPET,19,5,22,25 ;mode,x,y,w,h
	WL	4,U4GH3C+FR6
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;got him
	WL	ANI_CODE,CALL_SETUP
	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SOUND,33h			;neck break (5-7 ticks late)
	WL	ANI_CODE,CALL_SETUP
;	.word	ANI_DAMAGEOPP,10

	WWLLW	ANI_SUPERSLAVE2,4,U4GH3C+FR7,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,U4GH3C+FR8,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,U4GH3C+FR9,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,U4GH3C+FR10,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,U4GH3C+FR11,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,U4GH3C+FR11,#puppet_tbl,5

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	4,U4GH3C+FR11
	.word	ANI_CLROPPMODE,MODE_GHOST

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
	WL	20,U4GH3C+FR6
	WL	4,U4GH3C+FR5
	WL	4,U4GH3C+FR4
	WL	4,U4GH3C+FR3
	WL	4,U4GH3C+FR2
	WL	4,U4GH3C+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


	.ref	rzr_3_head_held_anim
	.ref	bam_3_head_held_anim
;	.ref	und_3_head_held_anim
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

#Bret
	.ref	H3GU4A,H3DU3A,H3BF3A
 LWWW H3GU4A+FR1,36,-43,0
 LWWW H3GU4A+FR3,45,-56,0
 LWWW H3DU3A+FR3,43,-51,1
 LWWW H3DU3A+FR4,50,-44,1
 LWWW H3DU3A+FR5,46,-42,1
 LWWW H3BF3A+FR1,44,-43,0
 .long 0
#Razor
	.ref	R3GU4A,R3DU3B,R3BF3A
 LWWW R3GU4A+FR2,45,-45,1
 LWWW R3GU4A+FR3,47,-53,0
 LWWW R3GU4A+FR5,47,-57,0
 LWWW R3DU3B+FR2,49,-56,1
 LWWW R3DU3B+FR4,47,-41,1
 LWWW R3BF3A+FR4,54,-43,0
 .long 0
#Taker
	.ref	U3DU3B,U4BF3Z
 LWWW U3DU3B+FR2,32,-40,1
 LWWW U3DU3B+FR5,43,-50,1
 LWWW U3DU3B+FR6,40,-56,1
 LWWW U3DU3B+FR8,45,-45,1
 LWWW U3DU3B+FR10,54,-39,1
 LWWW U4BF3Z+FR5,56,-22,0
 .long 0
#Yokozuna
	.ref	Y3GU2A,Y3BF3A
 LWWW Y3GU2A+FR1,33,-39,0
 LWWW Y3GU2A+FR3,54,-48,0
 LWWW Y3GU2A+FR6,32,-55,0
 LWWW Y3GU2A+FR9,45,-52,0
 LWWW Y3GU2A+FR12,47,-38,0
 LWWW Y3BF3A+FR1,54,-31,0
 .long 0
#Shawn
	.ref	S3GU4A,S3DU3A,S3BF3A
 LWWW S3GU4A+FR1,39,-42,1
 LWWW S3GU4A+FR2,40,-49,0
 LWWW S3GU4A+FR4,48,-56,0
 LWWW S3GU4A+FR5,47,-49,0
 LWWW S3DU3A+FR2,53,-47,1
 LWWW S3BF3A+FR1,45,-43,0
 .long 0
#BamBam
	.ref	B3GU4A,B3DU3A,B3BF3C
 LWWW B3GU4A+FR3,47,-30,0
 LWWW B3GU4A+FR4,49,-47,0
 LWWW B3GU4A+FR6,45,-49,0
 LWWW B3GU4A+FR7,44,-53,0
 LWWW B3DU3A+FR2,51,-39,1
 LWWW B3BF3C+FR5,65,-36,0
 .long 0
#Doink
	.ref	D3DU3A,D3HT3Z,D3BF3A
 LWWW D3DU3A+FR2,42,-39,1
 LWWW D3DU3A+FR3,51,-52,1
 LWWW D3DU3A+FR5,44,-56,1
 LWWW D3DU3A+FR8,42,-56,1
 LWWW D3HT3Z+FR1,49,-43,1
 LWWW D3BF3A+FR2,51,-42,0
 .long 0
#Adam
 .long 0
#Lex
	.ref	L3DU3A,L3BF3B
 LWWW L3DU3A+FR2,43,-41,1
 LWWW L3DU3A+FR4,24,-45,1
 LWWW L3DU3A+FR6,31,-57,1
 LWWW L3DU3A+FR7,40,-41,1
 LWWW L3DU3A+FR9,53,-42,1
 LWWW L3BF3B+FR2,61,-46,0
 .long 0

#******************************************************************************

 SUBR	und_4_taunt_anim

	.word	ANI_SETMODE,MODE_UNINT
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	4,U4CO4B+FR1
	WL	4,U4CO4B+FR2
	WL	15,U4CO4B+FR3
	WL	4,U4CO4B+FR4
	WL	4,U4CO4B+FR5
	WL	4,U4CO4B+FR6
	WL	4,U4CO4B+FR7
	WL	4,U4CO4B+FR8
	WL	4,U4CO4B+FR7
	WL	4,U4CO4B+FR6
	WL	4,U4CO4B+FR5
	WL	4,U4CO4B+FR4
	WL	15,U4CO4B+FR3
	WL	4,U4CO4B+FR4
	WL	4,U4CO4B+FR5
	WL	4,U4CO4B+FR6
	WL	4,U4CO4B+FR7
	WL	4,U4CO4B+FR8
	WL	4,U4CO4B+FR7
	WL	4,U4CO4B+FR6
	WL	4,U4CO4B+FR5
	WL	4,U4CO4B+FR4
	WL	4,U4CO4B+FR3
	WL	4,U4CO4B+FR2
	WL	4,U4CO4B+FR1


	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.ref	und_stand4_anim
	WL	ANI_CHANGEANIM,und_stand4_anim
	.word	ANI_END

#*****************************************************************************
*
* Head slams into mat
;From head slam - repeated head slam

 SUBR	und_break_face2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS

	WL	2,U3CF3Q+FR1
	WL	ANI_SET_YVEL,80000h
	WL	4,U3CF3Q+FR2
	WL	4,U3CF3Q+FR3
	WL	4,U3CF3Q+FR4
	.word	ANI_WAITHITGND
	.word	ANI_END


* Head slams into mat
;From head slam

 SUBR	und_break_face_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS

	WL	2,U3CF3Q+FR1
	WL	ANI_SET_YVEL,40000h
	WL	4,U3CF3Q+FR2
	WL	4,U3CF3Q+FR3
	WL	4,U3CF3Q+FR4
	.word	ANI_WAITHITGND
	.ref	SMALL_BOUNCE
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	2,U3CF3Q+FR1
	WL	4,U3CF3Q+FR2
	WL	4,U3CF3Q+FR3
	WL	4,U3CF3Q+FR4

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	2,U3CF3Q+FR1
	.word	ANI_WAITROLL

	WL	ANI_CHANGEANIM,und_getup_anim
	.word	ANI_END

#*****************************************************************************
*
* END OF BACK BROKEN SEQ.

 SUBR	und_backbroken_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_DETACH

	.word	ANI_GRAVITY_OFF
	WL	5,U3BR3Z+FR3
	.word	ANI_GRAVITY_ON

	WL	ANI_SET_YVEL,070000h
	WLW	ANI_SET_ZVEL,20000h,AM_ABS

	WL	25,U3BR3Z+FR3

;	WL	4,U3BR3Z+FR4

	.word	ANI_XFLIP
	WL	4,U3CP3B+FR2

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_BOUNCE,2
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT

	WL	2,U3CP3B+FR2
	.word	ANI_DEBRIS,200,1,0,8,0		;%chance, tbl index, x,y,z off
	WL	2,U3CP3B+FR2
	WL	4,U3CP3B+FR3
	WL	4,U3CP3B+FR4
	WL	4,U3CP3B+FR5

	WL	4,U3CP3B+FR1

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

;No stars around head here...

	.word	ANI_DETACH

	WL	3,U3CP3B+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,und_getup_anim
	.word	ANI_END

#*****************************************************************************

	.bss	#opp_xvel,32

 SUBR	und_3_head_hold2_anim
;Head hold when standing next to player
;No collisions possible
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold

	WL	3,U4GH3A+FR1
	WL	3,U4GH3A+FR2
	.word	ANI_ATTACK_ON, AMODE_PUPPET3,40,80,37,23 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,7,U4GH3A+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_GOTO,#gothim

 SUBR	und_3_head_hold_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold

	.word	ANI_STARTATTACK,AT_LEAPING,6
	WL	3,U4GH3A+FR1
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 9,999,60,40,90000h,TGT_HEAD,56,93,8
	WL	3,U4GH3A+FR2

	.word	ANI_ATTACK_ON, AMODE_PUPPET,40,80,37,23 ;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,6,U4GH3A+FR3

	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	WL	ANI_IFBLOCKED,#missed

#gothim
;got him
	.word	ANI_SETWORD,USR_VAR2,0
	WL	ANI_CODE,CALL_SETUP

	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,4,U4GH3A+FR3,#puppet_tbl,0

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WWLLW	ANI_SUPERSLAVE2,4,U4GH3A+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,U4GH3A+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,U4GH3C+FR11,#puppet_tbl,3

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	4,U4GH3C+FR11

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	25,U4GH3A+FR3
	WL	3,U4GH3A+FR2
	WL	3,U4GH3A+FR1

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
;	.ref	U4BF3A,U4BF3Z,U4AM4C
	.ref	Y3BF3A,Y3LB3A
	.ref	S4AH3D,S4BF3A
	.ref	B4BF3A,B3HB3A,B3BF3C
	.ref	D3AK3A,D3BF3A
	.ref	L2AH2A,L3BF3A,L3BF3B,L4AH4B
#Bret
 LWWW H2AH3A+FR1,69,15,0
 LWWW H3HB3A+FR3,62,-1,0
 LWWW H3HB3A+FR2,56,-17,0
 LWWW H3HB3A+FR1,42,-43,0
 .long 0
#Razor
 LWWW R3HB3A+FR3,76,-6,0
 LWWW R3HB3A+FR3,73,-2,0
 LWWW R3HB3A+FR2,73,-28,0
 LWWW R3BF3A+FR1,52,-43,0
 .long 0
#Taker
 LWWW U4AM4C+FR2,66,3,0
 LWWW U4BF3A+FR2,64,9,0
 LWWW U4BF3A+FR3,30,-17,0
 LWWW U4BF3Z+FR3,53,-31,0
 .long 0
#Yokozuna
 LWWW Y3LB3A+FR2,78,2,0
 LWWW Y3LB3A+FR2,76,6,0
 LWWW Y3LB3A+FR9,65,-28,0
 LWWW Y3BF3A+FR1,58,-31,0
 .long 0
#Shawn
 LWWW S4AH3D+FR5,64,1,0
 LWWW S4AH3D+FR5,58,5,0
 LWWW S4BF3A+FR2,72,-19,0
 LWWW S4BF3A+FR3,40,-31,0
 .long 0
#BamBam
 LWWW B4BF3A+FR1,78,3,0
 LWWW B4BF3A+FR1,79,7,0
 LWWW B3HB3A+FR2,70,-33,0
 LWWW B3BF3C+FR5,59,-36,0
 .long 0
#Doink
 LWWW D3AK3A+FR3,55,4,0
 LWWW D3AK3A+FR3,56,8,0
 LWWW D3AK3A+FR2,72,-19,0
 LWWW D3BF3A+FR1,50,-42,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L4AH4B+FR3,61,-2,0
 LWWW L3BF3A+FR1,73,2,1
 LWWW L3BF3A+FR2,72,-22,1
 LWWW L3BF3B+FR5,58,-38,0
 .long 0

	.ref	rzr_3_head_held_anim
	.ref	bam_3_head_held_anim
;	.ref	und_3_head_held_anim
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

******************************************************************************

	.end
