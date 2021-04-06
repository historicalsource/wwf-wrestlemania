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

	.file	"bamseq2.asm"
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
	.include	"ring.equ"
	.include	"bamimg.h"
	.include	"damage.equ"


******************************************************************************
* EXTERNAL REFERENCES

	.ref	SET_DIR_FACE,start_run_anim,HIT_THE_MAT,SMALL_BOUNCE
	.ref	choose_2or4,no_bk_xvel,CALL_MISSES,CALL_NASTY_MOVE
	.ref	DO_CROWD_CHEER,check_xvel,hit_puppet,BAMBLU_P,pal_getf

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************

 SUBR	bam_2_fpunch_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_DETACH

	.word	ANI_SET_RPTCOUNT,4	;3 times

#loop
	.word	ANI_CLR_BUTCOUNT

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 08h,999,54h,45,90000h,TGT_HEAD,50,105,10

	.word	ANI_STARTATTACK,AT_PUNCH,10

	WL	2,B2FH3Z+FR1
	WL	3,B2FH3Z+FR2
	WL	3,B2FH3Z+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,B2FH3Z+FR4
	.word	ANI_ATTACK_ON, AMODE_PUNCH,7,44,59,68	;mode,x,y,w,h
	WL	3,B2FH3Z+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#gotim
;missed
	WL	3,B2FH3Z+FR6
	WL	3,B2FH3Z+FR7

	WL	ANI_CODE,CALL_MISSES

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#gotim
	.word	ANI_IMMOBILIZE,30
	WL	ANI_CODE,CALL_NASTY_MOVE
	.word	ANI_STARTATTACK,AT_PUNCH,5

	WL	ANI_CODE,#set_opp_xy

	WL	2,B2FH3Z+FR6
	WL	3,B2FH3Z+FR7

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 08h,999,54h,45,90000h,TGT_HEAD,40,105,-10

	WL	2,B4FH3Z+FR1
	WL	3,B4FH3Z+FR2
	WL	3,B4FH3Z+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,B4FH3Z+FR4
	.word	ANI_CLR_STATUS
	.word	ANI_ATTACK_ON, AMODE_PUNCH,7,44,59,68	;mode,x,y,w,h
	WL	3,B4FH3Z+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#gotim2
;missed
	WL	3,B4FH3Z+FR6
	WL	3,B4FH3Z+FR7

	WL	ANI_CODE,CALL_MISSES

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#gotim2
	.word	ANI_IMMOBILIZE,30
	WL	ANI_CODE,#set_opp_xy

	WL	2,B4FH3Z+FR6
	WL	3,B4FH3Z+FR7

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,4,#fail
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#loop
#fail

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_4_fpunch_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_DETACH

	.word	ANI_SET_RPTCOUNT,4	;3 times

#loop2
	.word	ANI_STARTATTACK,AT_PUNCH,10
	.word	ANI_CLR_BUTCOUNT

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 08h,999,54h,45,90000h,TGT_HEAD,50,105,-10

	WL	2,B4FH3Z+FR1
	WL	3,B4FH3Z+FR2
	WL	3,B4FH3Z+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,B4FH3Z+FR4
	.word	ANI_ATTACK_ON, AMODE_PUNCH,7,44,59,68	;mode,x,y,w,h
	WL	3,B4FH3Z+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#gotim2a
;missed
	WL	3,B4FH3Z+FR6
	WL	3,B4FH3Z+FR7

	WL	ANI_CODE,CALL_MISSES

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#gotim2a
	.word	ANI_IMMOBILIZE,30
	.word	ANI_STARTATTACK,AT_PUNCH,15
	WL	ANI_CODE,CALL_NASTY_MOVE

	WL	ANI_CODE,#set_opp_xy

	WL	2,B4FH3Z+FR6
	WL	3,B4FH3Z+FR7

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 08h,999,54h,45,90000h,TGT_HEAD,40,105,10

	WL	2,B2FH3Z+FR1
	WL	3,B2FH3Z+FR2
	WL	3,B2FH3Z+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,B2FH3Z+FR4
	.word	ANI_CLR_STATUS
	.word	ANI_ATTACK_ON, AMODE_PUNCH,7,44,59,68	;mode,x,y,w,h
	WL	3,B2FH3Z+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#gotima
;missed
	WL	3,B2FH3Z+FR6
	WL	3,B2FH3Z+FR7

	WL	ANI_CODE,CALL_MISSES

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#gotima
	.word	ANI_IMMOBILIZE,30
	WL	ANI_CODE,#set_opp_xy

	WL	2,B2FH3Z+FR6
	WL	3,B2FH3Z+FR7

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,4,#fail2
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#loop
#fail2
      
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#set_opp_xy
	move	*a13(WHOIHIT),a0,L
	movi	[2,0],a14
	move	a14,*a0(OBJ_YVEL),L

	movi	-[2,0],a1
	move	*a0(NEW_FACING_DIR),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#abs			;right
	neg	a1			;left
#abs
	move	a1,*a0(OBJ_XVEL),L
 
	.ref	create_impact3
	calla	create_impact3
	rets

#*****************************************************************************
*
* #2 NORMAL PUNCH

 SUBR	bam_2_punch_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	WL	3,B2PU3C+FR4
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_PUNCH,7
	WL	3,B2PU3C+FR5
	WL	3,B2PU3C+FR6

	WL	1,B2PU3C+FR7
	.word	ANI_ATTACK_ON, AMODE_PUNCH,28,92,56,10	;mode,x,y,w,h
	WL	3,B2PU3C+FR7
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-30000h,#no_hit

	WL	ANI_SET_YVEL,30000h
	WL	3,B2PU3C+FR7
#no_hit

	WL	2,B2PU3C+FR7

	WL	3,B2PU3C+FR8
	WL	2,B2PU3C+FR9
	WL	2,B2PU3C+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 NORMAL PUNCH

 SUBR	bam_4_punch_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	WL	3,B4PU3D+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_PUNCH,7
	WL	3,B4PU3D+FR3
	WL	3,B4PU3D+FR4

	WL	1,B4PU3D+FR5
	.word	ANI_ATTACK_ON, AMODE_PUNCH,28,92,56,10	;mode,x,y,w,h
	WL	3,B4PU3D+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-30000h,#no_hit

	WL	ANI_SET_YVEL,30000h
	WL	3,B4PU3D+FR5
#no_hit
	WL	2,B4PU3D+FR5

	WL	3,B4PU3D+FR6
	WL	2,B4PU3D+FR7
	WL	2,B4PU3D+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 PUSH

 SUBR	bam_2_push_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUSH,15
      	WL	2,B2PS3A+FR1
	WL	2,B2PS3A+FR2
	WL	2,B2PS3A+FR3
	WL	2,B2PS3A+FR4
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	WL	2,B2PS3A+FR5
	WL	2,B2PS3A+FR6

;	WL	ANI_CODE,#fireball
	.word	ANI_ATTACK_ON, AMODE_PUSH,36,85,49,17 ;mode,x,y,w,h
	WL	3,B2PS3A+FR7
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

	WWL	ANI_SLIDE_BACK,40h,-60000h,#no_hit	;range,vel,addr
	WL	15,B2PS3A+FR7
#no_hit
	WL	7,B2PS3A+FR7
	WL	4,B2PS3A+FR8
	WL	4,B2PS3A+FR9
;	WL	4,B2PS3A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedb
#missed
	WL	7,B2PS3A+FR7
	WL	4,B2PS3A+FR8
	WL	4,B2PS3A+FR9
;	WL	4,B2PS3A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#fireball
	move	a13,a11
	.ref	bam_fireball
	CREATE0	bam_fireball
	rets

#************
*
* #4 PUSH

 SUBR	bam_4_push_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUSH,12
	WL	3,B4PS3A+FR1
	WL	3,B4PS3A+FR2
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	WL	3,B4PS3A+FR3
	WL	3,B4PS3A+FR4
;	WL	ANI_CODE,#fireball
	.word	ANI_ATTACK_ON, AMODE_PUSH,36,85,49,17 ;mode,x,y,w,h
	WL	3,B4PS3A+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

	WWL	ANI_SLIDE_BACK,40h,-60000h,#no_hit	;range,vel,addr
	WL	15,B4PS3A+FR5
#no_hit
	WL	7,B4PS3A+FR5
	WL	4,B4PS3A+FR6
	WL	4,B4PS3A+FR7
	WL	4,B4PS3A+FR8
	WL	4,B4PS3A+FR9
	WL	4,B4PS3A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END
#missedb
#missed
	WL	7,B4PS3A+FR5
	WL	4,B4PS3A+FR6
	WL	4,B4PS3A+FR7
	WL	4,B4PS3A+FR8
	WL	4,B4PS3A+FR9
	WL	4,B4PS3A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#fireball
	move	a13,a11
	CREATE0	bam_fireball
	rets

******************************************************************************
*
* #2 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	bam_2_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

	WL	3,B2AH2A+FR2
	WL	15,B2AH2A+FR3
	WL	3,B2AH2A+FR4
	WL	3,B2AH2A+FR5
	WL	3,B2AH2A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	bam_4_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

	WL	3,B4AH4A+FR2
	WL	3,B4AH4A+FR3
	WL	14,B4AH4A+FR4
	WL	2,B4AH4A+FR5
	WL	2,B4AH4A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


* #4 RUNNING BOUNCE OFF OF OPPONENT

;Bounce off but stay dizzy!

 SUBR	bam_4_bncoff_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	3,B4AH4A+FR2
	WL	3,B4AH4A+FR3
	WL	14,B4AH4A+FR4
	WL	2,B4AH4A+FR5
	WL	2,B4AH4A+FR6

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,bam_dizzy_anim
	.word	ANI_END


******************************************************************************
*
* #4 LOSE BALANCE

 SUBR	bam_4_losebal_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_FRICTION,3000h
	.word	ANI_SETSPEED,100h
	WLW	ANI_SET_XVEL,-60000h,AM_HIT_REL

	WL	4,B4LB4B+FR1
	WL	4,B4LB4B+FR2
	WL	4,B4LB4B+FR3
	WL	4,B4LB4B+FR4
	WL	4,B4LB4B+FR5
	WL	4,B4LB4B+FR6
	WL	4,B4LB4B+FR7

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 ELBOW DROP

#yoff	equ	50

 SUBR	bam_2_lbowdrop_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_STARTATTACK,AT_LBDROP,-1
	WL	3,B2PJ3A+FR3
	WL	3,B2PJ3A+FR4

	;if we're gonna miss, do a leapat
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,19,-6,-40,33,31,50
	WL	1,B2PJ3A+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#no_leapat

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	.word	ANI_TARGET,TGT_CHEST,TGT_GROIN,ATM_CLOSEST
	LEAPATOPP 20,999,112,96,90000h,TGT_USER,35,0+#yoff,-40
	.word	ANI_SETPLYRMODE,MODE_INAIR
	WL	ANI_CODE,no_bk_xvel

#no_leapat
	WL	3,B2PJ3A+FR5
	WL	3,B2PJ3A+FR6
	.word	ANI_OFFSET,0,#yoff,0
	WL	4,B2PJ3A+FR7
	WL	4,B2PJ3A+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_ATTACK_ON_Z,AMODE_LBOWDROP,19,-6,-40,33,31,50
	WL	1,B2PJ3A+FR9
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

	.word	ANI_SHAKER,20
	.word	ANI_SHAKEALL,2
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#hit
#missed
	WL	ANI_CODE,CALL_MISSES
#hit
	WL	3,B2PJ3A+FR9
	WL	4,B2PJ3A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,bam_2_faceup_getup2_anim

#*****************************************************************************
*
* #4 ELBOW DROP

#yoff	equ	40

 SUBR	bam_4_lbowdrop_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_LBDROP,-1
	WL	3,B3PJ3B+FR3
	WL	3,B3PJ3B+FR4

	;if we're gonna miss, do a leapat
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,19,-6,-40,33,31,50
	WL	1,B3PJ3B+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#no_leapat

	.word	ANI_TARGET,TGT_CHEST,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 20,999,112,96,90000h,TGT_USER,32,#yoff,40
	WL	ANI_CODE,no_bk_xvel

#no_leapat
	WL	2,B3PJ3B+FR5
	.word	ANI_OFFSET,0,#yoff,0
	WL	3,B3PJ3B+FR6
	WL	3,B3PJ3B+FR7
	WL	3,B3PJ3B+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_ATTACK_ON_Z,AMODE_LBOWDROP,12,-9,-10,42,42,50
	WL	1,B3PJ3B+FR9
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	.word	ANI_SHAKER,20
	.word	ANI_SHAKEALL,2

	;bounce off the guy
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_ZVEL,-18000h,AM_ABS
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#hit

#missed
	WL	ANI_CODE,CALL_MISSES
#hit

	WL	3,B3PJ3B+FR9
	WL	4,B3GU4A+FR4

	.word	ANI_SETMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,bam_4_faceup_getup2_anim

#*****************************************************************************
*
* #3 FLYING BUTT-DROP

#yoff	equ	51

 SUBR	bam_3_butt_drop_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_BUTTSTOMP,38
	WL	4,B3JK3A+FR4
	WL	4,B3JK3A+FR5

;	.word	ANI_TARGET,TGT_HEAD,TGT_GROIN,ATM_FARTHEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 30,999,112,96,90000h,TGT_CHEST,9,3+#yoff,-20

	.word	ANI_SETPLYRMODE,MODE_INAIR

	WL	ANI_CODE,no_bk_xvel
	WL	4,B3JK3A+FR6
	.word	ANI_OFFSET,0,#yoff,0
	WL	4,B3JK3A+FR7
	.word	ANI_ATTACK_ON,AMODE_BUTTSTOMP,-25,-7+5,55,23
	WWL	ANI_WAITHITOPP,26,B3JK3A+FR8
	.word	ANI_ATTACK_OFF

	.word	ANI_SHAKER,35
	.word	ANI_SHAKEALL,1
	WL	ANI_CODE,HIT_THE_MAT

	WL	ANI_IFNOTSTATUS,#miss

#hit
	.word	ANI_ZEROVELS
	WL	ANI_SET_YVEL,50000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS
	WL	4,B3JK3A+FR9
	WL	4,B3JK3A+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,1
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	4,B3JK3A+FR9
	WL	4,B3JK3A+FR10
	.word	ANI_OFFSET,15,9,0
	.word	ANI_FACEUP
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,bam_2_faceup_getup2_anim

#miss	;missed
	WL	ANI_CODE,CALL_MISSES

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	4,B3JK3A+FR9
	WL	4,B3JK3A+FR10
	.word	ANI_OFFSET,15,9,0
	.word	ANI_FACEUP
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,bam_2_faceup_getup2_anim

#*****************************************************************************
*
* TURNBUCKLE BELLYFLOP

 SUBR	bam_bellyflop_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCONFINE|MODE_NOCOLLIS|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING

	.word	ANI_STARTATTACK,AT_LEAPING,44
	WL	4,B4FK4B+FR3
	WL	4,B4FK4B+FR4
	.word	ANI_OFFSET,17,40,0

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 36,190,190,190,90000h,TGT_CHEST,18,0,20

	.word	ANI_SETPLYRMODE,MODE_INAIR2
	.word	ANI_GRAVITY_ON
	.word	ANI_SHAKECORNER

	WL	ANI_CODE,check_xvel

	WL	4,B4FK4B+FR5
	WL	4,B4FK4B+FR6
	WL	4,B4FK4B+FR7
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-14,0,-20,86,27,60
	WWL	ANI_IFOPPMODE,MODE_ONGROUND,#opp_onground
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-14,15,-20,86,27,60
#opp_onground
	WWL	ANI_WAITHITOPP,26,B4FK4B+FR8
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#hit

	;missed
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SHAKER,40
	.word	ANI_SHAKEALL,2
	WL	4,B4FK4B+FR9
	WL	4,B4FK4B+FR10
	.word	ANI_BOUNCE,4
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	WL	ANI_CHANGEANIM,bam_4_faceup_getup3_anim

#hit
	WL	4,B4FK4F+FR9
	WL	4,B4FK4F+FR10
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SOUND,0C1h
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_ZEROVELS
	.word	ANI_SHAKER,20
	.word	ANI_SHAKEALL,3

	WL	ANI_CODE,#attach_victim
	WL	ANI_SLAVEANIM,#release_table
	.word	ANI_DETACH

	.word	ANI_SETMODE,MODE_UNINT|MODE_INVISIBLE|MODE_NOSHADOW|MODE_NOCOLLIS
	.word	ANI_PAUSE,40

	;reappear
	WL	ANI_CODE,#set_new_position
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOSHADOW|MODE_NOCOLLIS

	.word	ANI_SOUND,0ABh
	WL	4,B4RS4A+FR1
	WL	4,B4RS4A+FR2
	WL	4,B4RS4A+FR3
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	WL	4,B4RS4A+FR4
	WL	4,B4RS4A+FR5
	WL	4,B4RS4A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


;attach victim just as if we'd puppeted him
 SUBRP	#attach_victim

	move	*a13(WHOIHIT),a14,L

	PUSH	a13
	move	a13,a10
	move	a14,a13
	calla	hit_puppet		;pretend collision
	PULL	a13
	rets


;for now, just go to the middle of the ring
 SUBRP	#set_new_position

	movi	RING_X_CENTER,a14
	move	a14,*a13(OBJ_XPOSINT)
	movi	RING_Z_CENTER,a14
	move	a14,*a13(OBJ_ZPOSINT)
	movi	MAT_Y,a14
	move	a14,*a13(OBJ_YPOSINT)
	rets


#release_table
	.long	xxx_burn_anim,xxx_burn_anim,xxx_burn_anim
	.long	xxx_burn_anim,xxx_burn_anim,xxx_burn_anim
	.long	xxx_burn_anim,xxx_burn_anim,xxx_burn_anim

#*****************************************************************************
*
* BURN FROM BAM BAM FLAMING TURNBUCKLE SPLASH (generic - everyone uses this)

 SUBR	xxx_burn_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	ANI_CODE,#set_pal
	WL	6,B4FK4F+FR11
	WL	6,B4FK4F+FR12
	WL	5,B4FK4F+FR13
	WL	5,B4FK4F+FR14

	.word	ANI_SET_RPTCOUNT,2
#loop
	WL	4,BURNBODY+FR1
	WL	4,BURNBODY+FR2
	WL	4,BURNBODY+FR3
	WL	4,BURNBODY+FR4
	WL	4,BURNBODY+FR5
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#loop

	WL	ANI_CODE,#restore_pal
	WL	ANI_CHANGEANIM_TBL,#getup_table

#set_pal
	movi	BAMBLU_P,a0
	calla	pal_getf
	move	*a13(OBJ_PAL),*a13(MY_PAL),W
	move	a0,*a13(OBJ_PAL),W
	rets

#restore_pal
	move	*a13(MY_PAL),*a13(OBJ_PAL),W
	rets


	.ref	hrt_faceup_getup_anim
	.ref	rzr_faceup_getup_anim
	.ref	und_faceup_getup_anim
	.ref	yok_faceup_getup_anim
	.ref	shn_faceup_getup_anim
	.ref	dnk_faceup_getup_anim
	.ref	lex_faceup_getup_anim

#getup_table
	.long	hrt_faceup_getup_anim		;0 Bret Hart
	.long	rzr_faceup_getup_anim		;1 Razor Ramon
	.long	und_faceup_getup_anim		;2 Undertaker
	.long	yok_faceup_getup_anim		;3 Yokozuna
	.long	shn_faceup_getup_anim		;4 Shawn Michaels
	.long	bam_faceup_getup_anim		;5 Bam Bam
	.long	dnk_faceup_getup_anim		;6 Doink
	.long	0
	.long	lex_faceup_getup_anim		;8 Lex Luger

#*****************************************************************************
*
* #2 HEADBUTT

 SUBR	bam_2_butt_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,B2BC3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_HDBUTT,12
	WL	3,B2BC3A+FR3
	WL	3,B2BC3A+FR4
	WL	3,B2BC3A+FR5
	WL	3,B2BC3A+FR6

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,5,79,40,19	;mode,x,y,w,h
	WL	3,B2BC3A+FR7
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-48000h,#no_hit

	WL	ANI_SET_YVEL,38000h
	WL	6,B2BC3A+FR7
#no_hit

	WL	5,B2BC3A+FR7

	WL	3,B2BC3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 HEADBUTT

 SUBR	bam_4_butt_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,B4BC3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_HDBUTT,12
	WL	3,B4BC3A+FR2
	WL	3,B4BC3A+FR3
	WL	3,B4BC3A+FR4
	WL	3,B4BC3A+FR5

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,5,79,40,19	;mode,x,y,w,h
	WL	3,B4BC3A+FR6
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-48000h,#no_hit2

	WL	ANI_SET_YVEL,38000h
	WL	6,B4BC3A+FR6
#no_hit2
	WL	5,B4BC3A+FR6

	WL	3,B4BC3A+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 KICK

 SUBR	bam_2_kick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	2,B2KM3B+FR1
	WL	1,B2KM3B+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KICK,5
	WL	1,B2KM3B+FR2
	WL	2,B2KM3B+FR3
	WL	2,B2KM3B+FR4

	WL	ANI_SET_YVEL,20000h
	.word	ANI_ATTACK_ON, AMODE_KICK,35,65,66,43	;mode,x,y,w,h
	WL	6,B2KM3B+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-40000h,#no_hit2
	WL	ANI_SET_YVEL,30000h
	WL	6,B2KM3B+FR5

#no_hit2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,B2KM3B+FR6
	WL	3,B2KM3B+FR7
	WL	3,B2KM3B+FR8
	WL	3,B2KM3B+FR9
	WL	3,B2KM3B+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 KICK

 SUBR	bam_4_kick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	2,B4KM3A+FR1
	WL	1,B4KM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KICK,5
	WL	1,B4KM3A+FR2
	WL	2,B4KM3A+FR3
	WL	2,B4KM3A+FR4

	WL	ANI_SET_YVEL,20000h
	.word	ANI_ATTACK_ON, AMODE_KICK,37,62,62,35	;mode,x,y,w,h
	WL	6,B4KM3A+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-40000h,#no_hit2
	WL	ANI_SET_YVEL,30000h
	WL	6,B4KM3A+FR5

#no_hit2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,B4KM3A+FR6
	WL	3,B4KM3A+FR7
	WL	3,B4KM3A+FR8
	WL	3,B4KM3A+FR9
	WL	3,B4KM3A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #2 SUPER KARATE KICK

 SUBR	bam_2_superkick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	3,B2BG3A+FR1

* #4 SUPER KARATE KICK

 SUBR	bam_4_superkick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_STARTATTACK,AT_LEAPING,10
	WL	3,B4KM3E+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,999,65,35,90000h,TGT_HEAD,64,82,10
;	WLW	ANI_SET_ZVEL,0h,AM_ABS
	WL	ANI_SET_YVEL,30000h
	.word	ANI_FRICTION,4000h
	WL	3,B4KM3E+FR2
	WL	4,B4KM3E+FR3
	.word	ANI_ATTACK_ON, AMODE_KICK,12,58,60,40	;mode,x,y,w,h
	WL	2,B4KM3E+FR5
	WLW	ANI_SET_ZVEL,0h,AM_ABS
	WL	5,B4KM3E+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

;hit
	.ref	create_impact2
	WL	ANI_CODE,create_impact2

	.word	ANI_ZEROVELS
	WWL	ANI_SLIDE_BACK,30h,-40000h,#no_hit2
	WL	ANI_SET_YVEL,30000h
	WL	7,B4KM3E+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

#no_hit2
;	.word	ANI_WAITHITGND
;	.word	ANI_ZEROVELS

	.word	ANI_WAITHITGND
	WL	3,B4KM3E+FR5
	WL	3,B4KM3E+FR6
	WL	3,B4KM3E+FR7
	WL	3,B4KM3E+FR7
	WL	3,B4KM3E+FR8
	WL	3,B4KM3E+FR9
	WL	3,B4KM3E+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missed
#missedb
	WL	ANI_CODE,CALL_MISSES
	WL	3,B4KM3E+FR5
	.word	ANI_WAITHITGND
	WL	3,B4KM3E+FR6
	WL	3,B4KM3E+FR7
	WL	3,B4KM3E+FR8
	WL	3,B4KM3E+FR9
	WL	3,B4KM3E+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #2 & #4 TURBO KICK

 SUBR	bam_4_jumpkick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

;;;	.word	ANI_SLOWMO,2

	.word	ANI_STARTATTACK,AT_LEAPING,19
	WL	3,B4KM3H+FR2
	WL	3,B4KM3H+FR3
	WL	3,B4KM3H+FR4

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 10,999,95,50,90000h,TGT_HEAD,70,100,20

	WL	4,B4KM3H+FR5
	WL	3,B4KM3H+FR6
	WL	3,B4KM3H+FR7


	.word	ANI_ATTACK_ON, AMODE_JUMPKICK,49,87,34,20	;mode,x,y,w,h
	WL	3,B4KM3H+FR9
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACK_OFF
	WL	6,B4KM3H+FR9

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	6,B4KM3H+FR9

	WL	3,B4KM3H+FR10
	WL	3,B4KM3H+FR11
	WL	3,B4KM3H+FR12

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #3 FLYING KICK

 SUBR	bam_flying_kick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h

	WL	3,B3DC3B+FR4

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_LEAPING,15

	WL	1,B3DC3B+FR4

	.ref	get_leap
	WL	ANI_CODE,get_leap
	WL	ANI_IFSTATUS,#no_xvel

;	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 17,999,145,65,90000h,TGT_HEAD,67,75,0
	LEAPATOPP 14,999,145,65,90000h,TGT_HEAD,57,75,0

	WL	ANI_GOTO,#cont

#no_xvel
	.word	ANI_ZERO_XZVELS
	WL	ANI_SET_YVEL,64000h
#cont
	WL	4,B3DC3B+FR5
	WL	7,B3DC3B+FR6
	.word	ANI_OFFSET,0,50,0			;x,y,z
	WL	3,B3DC3B+FR7

	.word	ANI_CLR_STATUS

	.word	ANI_ATTACK_ON, AMODE_FLYKICK,53,23,27,29 ;mode,x,y,w,h
	WL	3,B3DC3B+FR8
	.word	ANI_ATTACK_OFF
	WL	3,B3DC3B+FR9
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_BOUNCE,3

	WL	3,B3DC3B+FR11
;	WL	3,B3DC3B+FR9
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
;	WL	2,B3DC3B+FR9

	WL	5,B3DC3B+FR11

	.word	ANI_XFLIP
	.word	ANI_OFFSET,5,0,0			;x,y,z

	WL	3,B3GU2A+FR5
	WL	3,B3GU2A+FR6
	WL	3,B3GU2A+FR7
	WL	3,B3GU2A+FR8
	WL	3,B3GU2A+FR9

;Check for a flip here
	WL	1,B3GU2A+FR10
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,B3GU2A+FR10


	WL	3,B3GU2A+FR10
	WL	3,B3GU2A+FR11
	WL	3,B3GU2A+FR12
	WL	3,B3GU2A+FR13

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END



;#*****************************************************************************
;*
;* #3 RUNNING HEADBUTT
;
; SUBR	bam_running_headbutt
;
;	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
;	.word	ANI_SETSPEED,100h
;
;	.word	ANI_ZEROVELS
;	WLW	ANI_SET_XVEL,50000h,AM_FACE_REL
;
;#lp1
;
;;	WL	3,B3RN3A+FR1
;;	WL	3,B3RN3A+FR2
;;	WL	3,B3RN3A+FR3
;;	WL	3,B3RN3A+FR4
;;	WL	3,B3RN3A+FR5
;;	.word	ANI_SOUND,run_snd
;;	WL	3,B3RN3A+FR6
;;	WL	3,B3RN3A+FR7
;	.word	ANI_STARTATTACK,AT_HDBUTT,36
;	WL	3,B3RN3A+FR8
;	WL	3,B3RN3A+FR9
;	WL	3,B3RN3A+FR10
;	WL	3,B3RN3A+FR11
;	.word	ANI_SOUND,run_snd
;	WL	3,B3RN3A+FR12
;
;	WL	3,B3RN3A+FR1
;	WL	3,B3RN3A+FR2
;
;	.word	ANI_ZEROVELS
;
;;;	WL	3,B2BC3A+FR2
;	WL	3,B2BC3A+FR3
;	WL	3,B2BC3A+FR4
;	WL	3,B2BC3A+FR5
;	WL	3,B2BC3A+FR6
;
;	.word	ANI_ATTACK_ON, AMODE_HDBUTT,5,79,40,19	;mode,x,y,w,h
;	WL	3,B2BC3A+FR7
;	.word	ANI_ATTACK_OFF
;	WL	6,B2BC3A+FR7
;
;	WL	4,B2BC3A+FR8
;
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END
;
;
;	WL	ANI_GOTO,#lp1

#*****************************************************************************
*
* #2 STOMP ON FALLEN OPPONENT

 SUBR	bam_2_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	4,B2MP2A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_STOMP,16
	WL	3,B2MP2A+FR2

	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,13,0,-40,22,28,50
	WL	1,B2MP2A+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#leapat_stomp

	WL	4,B2MP2A+FR3
	WL	4,B2MP2A+FR4
	WL	4,B2MP2A+FR5
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,13,0,-40,22,28,50
	WL	1,B2MP2A+FR6
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	.word	ANI_SHAKER,20
	.word	ANI_SHAKEALL,1
	WL	ANI_GOTO,#hit
#missed
	WL	ANI_CODE,CALL_MISSES
#hit
	WL	5,B2MP2A+FR6
	WL	4,B2MP2A+FR7
	WL	4,B2MP2A+FR8
	WL	4,B2MP2A+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END



#leapat_stomp
	.word	ANI_TARGET,TGT_CHEST,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,112,96,40000h,TGT_USER,24,0,-30
	WL	ANI_CODE,no_bk_xvel

	WL	4,B2MP2A+FR3
	WL	4,B2MP2A+FR4
	WL	4,B2MP2A+FR5
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,13,0,-40,22,28,50
	WL	1,B2MP2A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#l_missed
	.word	ANI_SHAKER,20
	.word	ANI_SHAKEALL,1
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_ZVEL,13000h,AM_ABS
	WL	ANI_GOTO,#l_hit
#l_missed
	WL	ANI_CODE,CALL_MISSES
#l_hit
	WL	5,B2MP2A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	4,B2MP2A+FR7
	WL	4,B2MP2A+FR8
	WL	4,B2MP2A+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 STOMP ON FALLEN OPPONENT

 SUBR	bam_4_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	4,B4MP4A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	3,B4MP4A+FR2

	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,-3,-5,-10,46,35,50
	WL	1,B4MP4A+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#leapat

	.word	ANI_STARTATTACK,AT_STOMP,9
	WL	4,B4MP4A+FR3
	WL	3,B4MP4A+FR4
	WL	2,B4MP4A+FR5
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,-3,-5,-10,46,35,50
	WL	1,B4MP4A+FR6
	.word	ANI_ATTACK_OFF
	WL	ANI_GOTO,#common

#leapat
	.word	ANI_TARGET,TGT_CHEST,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,112,96,40000h,TGT_USER,12,0,30
	WL	ANI_CODE,no_bk_xvel

	.word	ANI_STARTATTACK,AT_STOMP,16
	WL	3,B4MP4A+FR3
	WL	3,B4MP4A+FR4
	WL	3,B4MP4A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,-3,-5,-10,46,35,50
	WL	1,B4MP4A+FR6
	.word	ANI_ATTACK_OFF

#common
	WL	ANI_IFNOTSTATUS,#missed
	.word	ANI_SHAKER,20
	.word	ANI_SHAKEALL,1
	WL	ANI_GOTO,#hit
#missed
	WL	ANI_CODE,CALL_MISSES
#hit
	WL	5,B4MP4A+FR6
	WL	4,B4MP4A+FR7
	WL	4,B4MP4A+FR8
	WL	4,B4MP4A+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 BIG BOOT

; SUBR	bam_2_bigboot_anim
;
;	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_SETSPEED,100h
;	.word	ANI_ZEROVELS
;
;	.word	ANI_STARTATTACK,AT_BIGBOOT,12
;	WL	3,B2KM3B+FR1
;	WL	3,B2KM3B+FR2
;	WL	3,B2KM3B+FR3
;	WL	3,B2KM3B+FR4
;
;	WL	ANI_CODE,#clrcnt
;	WL	ANI_SET_YVEL,20000h
;	.word	ANI_ATTACK_ON, AMODE_BIGBOOT,35,65,66,43	;mode,x,y,w,h
;	WL	2,B2KM3B+FR5
;	.word	ANI_WAITHITGND
;	.word	ANI_ZEROVELS
;#lp
;	WL	2,B2KM3B+FR5
;	WL	ANI_CODE,#holdup
;	WL	ANI_IFSTATUS,#lp
;	.word	ANI_ATTACK_OFF
;
;	WL	3,B2KM3B+FR6
;	WL	3,B2KM3B+FR7
;	WL	3,B2KM3B+FR8
;	WL	3,B2KM3B+FR9
;	WL	3,B2KM3B+FR10
;
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END


* #4 BIG BOOT

 SUBR	bam_4_bigboot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_STARTATTACK,AT_BIGBOOT,12
	WL	3,B4KM3A+FR1
	WL	3,B4KM3A+FR2
	WL	3,B4KM3A+FR3
	WL	3,B4KM3A+FR4

	WL	ANI_CODE,#clrcnt
	WL	ANI_SET_YVEL,20000h
	.word	ANI_ATTACK_ON, AMODE_BIGBOOT,37,62,62,35	;mode,x,y,w,h
	WL	2,B4KM3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
#lp0
	WL	2,B4KM3A+FR5
	WL	ANI_CODE,#holdup
	WL	ANI_IFSTATUS,#lp0
	.word	ANI_ATTACK_OFF

	WL	3,B4KM3A+FR6
	WL	3,B4KM3A+FR7
	WL	3,B4KM3A+FR8
	WL	3,B4KM3A+FR9
	WL	3,B4KM3A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#clrcnt
;We are re-using BUT_COUNT in the player process
	clr	a0
	move	a0,*a13(BUT_COUNT)
	rets

#holdup
	move	*a13(BUT_COUNT),a0
	inc	a0
	move	a0,*a13(BUT_COUNT)

;Max time to hold up in air (*2 ticks)
	cmpi	25,a0
	jrgt	#button_up

	move	*a13(PLYRNUM),a0
	.ref	wres_get_but_val_cur
	calla	wres_get_but_val_cur
	btst	PLAYER_SKICK_BIT,a0		;still down?
	jrz	#button_up

;Still holding...

	move	*a13(ANIMODE),a1
	ori	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets

#button_up
	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets


#*****************************************************************************
*
* #2 KNEE

 SUBR	bam_2_knee_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,B2NM3A+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KNEE,21

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 21,999,36,30,90000h,TGT_CHEST,56,74,0

	WL	3,B2NM3A+FR4

	.word	ANI_ATTACK_ON, AMODE_KNEE,34,31,52,51	;mode,x,y,w,h
	WL	3,B2NM3A+FR5
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-40000h,#no_hit
	WL	ANI_SET_YVEL,60000h
	WLW	ANI_SET_ZVEL,10000h,AM_ABS
	WL	3,B2NM3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#cont

#no_hit
	WL	ANI_IFNOTSTATUS,#nodrft
	WLW	ANI_SET_ZVEL,10000h,AM_ABS
	WL	15,B2NM3A+FR5
	.word	ANI_ZERO_XZVELS
#nodrft
	WL	1,B2NM3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	WL	3,B2NM3A+FR5
#cont
	WL	3,B2NM3A+FR6
	WL	3,B2NM3A+FR7
	WL	3,B2NM3A+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 KNEE

 SUBR	bam_4_knee_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,B4NM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KNEE,21
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 21,999,36,20,90000h,TGT_CHEST,46,74,0
	WL	3,B4NM3A+FR3
	WL	3,B4NM3A+FR4

	.word	ANI_ATTACK_ON, AMODE_KNEE,29,32,46,40	;mode,x,y,w,h
	WL	3,B4NM3A+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-50000h,#no_hit2
	WL	ANI_SET_YVEL,60000h
	WLW	ANI_SET_ZVEL,-10000h,AM_ABS
	WL	3,B4NM3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#cont2
#no_hit2
	WL	1,B4NM3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
#cont2
	WL	3,B4NM3A+FR5
	WL	3,B4NM3A+FR4
	WL	3,B4NM3A+FR3
	WL	3,B4NM3A+FR2

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* GRAB & FLING OPPONENT (INTO A RUN)


 SUBR	bam_2_grabfling_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_STARTATTACK,AT_PUPPET,14
	WL	3,B1TT5Z+FR2
	WL	3,B1TT5Z+FR3
	WL	ANI_GOTO,#cont

 SUBR	bam_4_grabfling_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_STARTATTACK,AT_PUPPET,8

#cont
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,40,0,25
	WL	ANI_SET_YVEL,0000h

	WL	4,B4GF3A+FR1

	.word	ANI_ATTACK_ON, AMODE_PUPPET,33,56,44,18 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,B4GF3A+FR2
;	WL	4,B4GF3A+FR2
	.word	ANI_ZERO_XZVELS
	WWL	ANI_WAITHITOPP,4,B4GF3A+FR3
;	WL	4,B4GF3A+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

;got him
	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

; attacker sequence
	WWLLW	ANI_SUPERSLAVE2,10,B4GF3A+FR4,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,7,B4GF3A+FR5,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,5,B4GF3A+FR6,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,5,B4GF3A+FR7,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,5,B4GF3A+FR8,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,5,B4GF3A+FR9,#puppet_tbl,5

	WL	ANI_SLAVEANIM,#strt_run_tbl

	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_DETACH
	WL	6,B4GF3A+FR9
	WL	4,B4GF3A+FR11
	.word	ANI_OFFSET,0,0,0			;x,y,z

	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#missedb
	WL	15,B4GF3A+FR3
#missed
	WL	ANI_CODE,CALL_MISSES
	WL	8,B4GF3A+FR3
	WL	4,B4GF3A+FR2
	WL	4,B4GF3A+FR1

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

	.ref	H4YR3A,H3RN3A
	.ref	R4YR3A,R3RN3D
	.ref	U4YR3B,U3RN3A
	.ref	Y4YR3A,Y3RN3C
	.ref	S4YR3A,S3RN3A
	.ref	B4YR3A,B3RN3A
	.ref	D4YR3B,D3RN3B
	.ref	L4YR3B,L3RN3B

#Bret
 LWWW H4YR3A+FR1,54,5,1
 LWWW H4YR3A+FR2,44,7,1
 LWWW H4YR3A+FR3,34,12,1
 LWWW H4YR3A+FR5,16,8,1
 LWWW H3RN3A+FR1,10,-10,0
 LWWW H3RN3A+FR2,-45,-8,0
#Razor
 LWWW R4YR3A+FR1,37,14,0
 LWWW R4YR3A+FR2,21,18,0
 LWWW R4YR3A+FR3,-9,14,0
 LWWW R4YR3A+FR4,-28,10,0
 LWWW R3RN3D+FR10,16,3,0
 LWWW R3RN3D+FR11,-29,2,0
#Taker
 LWWW U4YR3B+FR2,42,18,0
 LWWW U4YR3B+FR3,37,15,0
 LWWW U4YR3B+FR4,15,26,0
 LWWW U4YR3B+FR5,4,19,0
 LWWW U3RN3A+FR1,17,4,0
 LWWW U3RN3A+FR2,-31,1,0
#Yokozuna
 LWWW Y4YR3A+FR1,54,10,1
 LWWW Y4YR3A+FR4,25,13,1
 LWWW Y4YR3A+FR5,14,17,1
 LWWW Y4YR3A+FR7,-10,1,1
 LWWW Y3RN3C+FR7,34,3,0
 LWWW Y3RN3C+FR8,2,0,0
#Shawn
 LWWW S4YR3A+FR2,36,4,1
 LWWW S4YR3A+FR3,45,-4,1
 LWWW S4YR3A+FR5,8,14,1
 LWWW S4YR3A+FR6,-4,6,1
 LWWW S3RN3A+FR2,18,-4,0
 LWWW S3RN3A+FR3,-19,-5,0
#BamBam
 LWWW B4YR3A+FR3,46,11,0
 LWWW B4YR3A+FR4,53,7,0
 LWWW B4YR3A+FR5,46,13,0
 LWWW B4YR3A+FR7,-21,3,0
 LWWW B3RN3A+FR1,16,0,0
 LWWW B3RN3A+FR2,-41,0,0
#Doink
 LWWW D4YR3B+FR1,71,9,1
 LWWW D4YR3B+FR2,60,13,1
 LWWW D4YR3B+FR3,38,17,1
 LWWW D4YR3B+FR4,8,12,1
 LWWW D3RN3B+FR3,27,3,0
 LWWW D3RN3B+FR4,-35,-1,0
#Adam
 .long 0
#Lex
 LWWW L4YR3B+FR1,67,10,1
 LWWW L4YR3B+FR2,43,5,1
 LWWW L4YR3B+FR3,20,12,1
 LWWW L4YR3B+FR4,-27,5,1
 LWWW L3RN3B+FR2,27,1,0
 LWWW L3RN3B+FR3,-19,-3,0


#strt_run_tbl
	.ref	start_run_flung

	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung


#*****************************************************************************
*
* #2 HEAD HIT

 SUBR	bam_2_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,B2AH2A+FR1
	WL	3,B2AH2A+FR2
	WL	3,B2AH2A+FR3
	WL	3,B2AH2A+FR4
	WL	3,B2AH2A+FR5
	WL	3,B2AH2A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 HEAD HIT

 SUBR	bam_4_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,B4AH4A+FR1
	WL	3,B4AH4A+FR2
	WL	3,B4AH4A+FR3
	WL	3,B4AH4A+FR4
	WL	3,B4AH4A+FR5
	WL	3,B4AH4A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #2 HEAD HIT - From spin kick

 SUBR	bam_2_head_hit2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,40000h

	WL	3,B2AH2A+FR1
	WL	3,B2AH2A+FR2
	WL	1,B2AH2A+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,B2AH2A+FR4
	WL	3,B2AH2A+FR5
	WL	3,B2AH2A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 HEAD HIT - From spin kick

 SUBR	bam_4_head_hit2_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-20000h,AM_ABS
	WL	ANI_SET_YVEL,40000h

	WL	3,B4AH4A+FR1
	WL	3,B4AH4A+FR2
	WL	1,B4AH4A+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,B4AH4A+FR4
	WL	3,B4AH4A+FR5
	WL	3,B4AH4A+FR6


	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_4_head_hit4_anim
;From earslap

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
;	WLW	ANI_SET_ZVEL,-20000h,AM_ABS
	WL	ANI_SET_YVEL,40000h

	WL	4,B4AH4A+FR3
;	.word	ANI_WAITHITGND
;	.word	ANI_ZEROVELS
	WL	4,B4AH4A+FR4
	WL	4,B4AH4A+FR5
	WL	4,B4AH4A+FR6

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* HEAD HIT2 (HANDS ON FACE)

 SUBR	bam_head_hit2_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WLW	ANI_SET_XVEL,-40000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h

	WL	4,B3AE3A+FR2
	WL	4,B3AE3A+FR3
	WL	4,B3AE3A+FR4
	WL	4,B3AE3A+FR5
	WL	4,B3AE3A+FR6
	WL	4,B3AE3A+FR7
	WL	4,B3AE3A+FR8
	WL	4,B3AE3A+FR9
	WL	4,B3AE3A+FR10
	WL	4,B3AE3A+FR11
	WL	4,B3AE3A+FR12

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* HEAD HIT2 (ENDS IN DIZZY)

 SUBR	bam_head_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WLW	ANI_SET_XVEL,-60000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	4,B3AE3A+FR2
	WL	4,B3AE3A+FR3
	WL	4,B3AE3A+FR4
	WL	4,B3AE3A+FR5
	WL	4,B3AE3A+FR6
	WL	4,B3AE3A+FR7
	WL	4,B3AE3A+FR8
	WL	4,B3AE3A+FR9
	WL	4,B3AE3A+FR10
	WL	4,B3AE3A+FR11
	WL	4,B3AE3A+FR12

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,bam_dizzy_anim

	.word	ANI_END


#*****************************************************************************
*
* #2 BODY HIT

 SUBR	bam_2_body_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL

	.ref	ckzpos
	WL	ANI_CODE,ckzpos
     
	WL	3,B2AM2A+FR1
	WL	3,B2AM2A+FR2
	WL	3,B2AM2A+FR3
	WL	1,B2AM2A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,B2AM2A+FR5
	WL	3,B2AM2A+FR6
	WL	3,B2AM2A+FR7
	WL	3,B2AM2A+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 BODY HIT

 SUBR	bam_4_body_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL

	.ref	ckzpos
	WL	ANI_CODE,ckzpos

	WL	3,B4AM4A+FR1
	WL	3,B4AM4A+FR2
	WL	3,B4AM4A+FR3
	WL	1,B4AM4A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,B4AM4A+FR5
	WL	3,B4AM4A+FR6
	WL	3,B4AM4A+FR7
	WL	3,B4AM4A+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


* #4 BODY HIT - DIZZY

 SUBR	bam_4_body_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	.ref	ckzpos
	WL	ANI_CODE,ckzpos

	WL	3,B4AM4A+FR1
	WL	3,B4AM4A+FR2
	WL	3,B4AM4A+FR3
	WL	1,B4AM4A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,B4AM4A+FR5
	WL	3,B4AM4A+FR6
	WL	3,B4AM4A+FR7
	WL	3,B4AM4A+FR8

	.word	ANI_FACEDOWN
;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,bam_dizzy_anim

	.word	ANI_END


 SUBR	bam_2_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,8000h,AM_ABS

	.ref	ckzpos
	WL	ANI_CODE,ckzpos

	WL	3,B2AM2A+FR1
	WL	3,B2AM2A+FR2
	WL	3,B2AM2A+FR3
	WL	1,B2AM2A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,B2AM2A+FR5
	WL	3,B2AM2A+FR6
	WL	3,B2AM2A+FR7
	WL	3,B2AM2A+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_4_knee_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-8000h,AM_ABS
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	.ref	ckzpos
	WL	ANI_CODE,ckzpos

	WL	3,B4AM4A+FR1
	WL	3,B4AM4A+FR2
	WL	3,B4AM4A+FR3
	WL	1,B4AM4A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,B4AM4A+FR5
	WL	3,B4AM4A+FR6
	WL	3,B4AM4A+FR7
	WL	3,B4AM4A+FR8
;	.word	ANI_OFFSET,0,0,0			;x,y,z

	.word	ANI_FACEDOWN
;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,bam_dizzy_anim
	.word	ANI_END

* #4 BODY HIT

 SUBR	bam_4_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-8000h,AM_ABS

	.ref	ckzpos
	WL	ANI_CODE,ckzpos

	WL	3,B4AM4A+FR1
	WL	3,B4AM4A+FR2
	WL	3,B4AM4A+FR3
	WL	1,B4AM4A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,B4AM4A+FR5
	WL	3,B4AM4A+FR6
	WL	3,B4AM4A+FR7
	WL	3,B4AM4A+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_quick_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h

	WL	3,B4AM4A+FR1
	WL	3,B4AM4A+FR2
	WL	3,B4AM4A+FR3
	WL	3,B4AM4A+FR4
	WL	3,B4AM4A+FR5
	WL	3,B4AM4A+FR6
	WL	3,B4AM4A+FR7
	WL	3,B4AM4A+FR8

	.word	ANI_FACEDOWN



	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,bam_fall_back_anim
	.word	ANI_END

#nodead



	.ref	bam_3_head_held_anim
	WL	ANI_CHANGEANIM,bam_3_head_held_anim

	.word	ANI_END

#*****************************************************************************
*
* HITS ON GROUND

 SUBR	bam_hitonground_xflip_anim
	.word	ANI_XFLIP
	;fall through

 SUBR	bam_hitonground_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h

	WL	1,B3CP3B+FR1
	WL	ANI_SET_YVEL,39000h
	.word	ANI_DEBRIS,50,1,0,8,0		;%chance, tbl index, x,y,z off
	WL	2,B3CP3B+FR1
	WL	3,B3CP3B+FR2
	WL	3,B3CP3B+FR3
	WL	3,B3CP3B+FR4
	WL	3,B3CP3B+FR5
	WL	3,B3CP3B+FR6
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,B3CP3B+FR7
	WL	4,B3RL1A+FR1		;1st frame of roll

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_faceup_getup_anim
	.word	ANI_END

#*****************************************************************************
*
* FALL BACK

 SUBR	bam_fall_back_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,68000h

	.ref	ckzpos
	WL	ANI_CODE,ckzpos

	WWL	ANI_SETLONG,DEBRIS_X,[106,-29]	;Y,X of head
	WL	4,B4UC3B+FR1
	.word	ANI_OFFSET,0,52,0
	WWL	ANI_SETLONG,DEBRIS_X,[44,-42]	;Y,X of head
	WL	4,B4UC3B+FR2
	WWL	ANI_SETLONG,DEBRIS_X,[37,-45]	;Y,X of head
	WL	4,B4UC3B+FR3
	WWL	ANI_SETLONG,DEBRIS_X,[24,-50]	;Y,X of head
	WL	4,B4UC3B+FR4
	WWL	ANI_SETLONG,DEBRIS_X,[16,-54]	;Y,X of head
	WL	4,B4UC3B+FR5
	.word	ANI_WAITHITGND

	.word	ANI_DEBRIS,50,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,50

	.word	ANI_FRICTION,2000h

	WWL	ANI_SETLONG,DEBRIS_X,[14,-54]	;Y,X of head
	WL	2,B4UC3B+FR6
	.word	ANI_BOUNCE,5
	WL	2,B4UC3B+FR6

	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS

	WWL	ANI_SETLONG,DEBRIS_X,[14,-54]	;Y,X of head
	WL	4,B4UC3B+FR7
	WWL	ANI_SETLONG,DEBRIS_X,[14,-54]	;Y,X of head
	WL	4,B4UC3B+FR8
	.word	ANI_OFFSET,8,0,5			;x,y,z
	.word	ANI_XFLIP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	WWL	ANI_SETLONG,DEBRIS_X,0		;Y,X of head
	WL	4,B3RL1A+FR1
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_faceup_getup_anim
	.word	ANI_END

 SUBR	bam_fall_back2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,18000h

	WLW	ANI_SET_ZVEL,18000h,AM_ABS
	.ref	ckzpos
	WL	ANI_CODE,ckzpos

	WL	4,B4UC3B+FR1
	.word	ANI_OFFSET,0,52,0
	WL	4,B4UC3B+FR2
	WL	4,B4UC3B+FR3
	WL	4,B4UC3B+FR4
	WL	4,B4UC3B+FR5
	.word	ANI_WAITHITGND

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,50
	.word	ANI_ZEROVELS		
	WLW	ANI_SET_ZVEL,18000h,AM_ABS
	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL

	WL	4,B3FD3C+FR1
	WL	4,B3FD3C+FR2
	WL	4,B3FD3C+FR3
	WL	4,B3FD3C+FR4
	WL	4,B3FD3C+FR5
	.word	ANI_OFFSET,-35,0,0			;x,y,z
	.word	ANI_ZEROVELS		
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	ANI_CODE,HIT_THE_MAT

	WL	3,B3MS3X+FR1
	WL	3,B3MS3X+FR2
	WL	3,B3MS3X+FR3

	WL	20,B3RL1A+FR7

	WL	ANI_CHANGEANIM,bam_faceup_getup_anim
	.word	ANI_END

#*****************************************************************************
*
* FALL FROM TURNBUCKLE

 SUBR	bam_fall_back_tbukl_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETSPEED,100h

	WL	4,B4UC3B+FR1
	.word	ANI_OFFSET,0,52,0
	WL	4,B4UC3B+FR2
	WL	4,B4UC3B+FR3
	WL	4,B4UC3B+FR4
	WL	4,B4UC3B+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_DAMAGE,D_HITCONCRETE

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,50

;	.word	ANI_FRICTION,2000h

	WL	2,B4UC3B+FR6
;	.word	ANI_BOUNCE,5
	WL	2,B4UC3B+FR6

;	.word	ANI_WAITHITGND
;	WL	ANI_CODE,SMALL_BOUNCE
;	.word	ANI_ZEROVELS

	WL	4,B4UC3B+FR7
	WL	4,B4UC3B+FR8
	.word	ANI_OFFSET,8,0,5			;x,y,z
	.word	ANI_XFLIP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	WL	4,B3RL1A+FR1
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_faceup_getup_anim

#*****************************************************************************
*

 SUBR	bam_faceup_getup_anim
	WL	ANI_CODE,choose_2or4
	WL	ANI_IFSTATUS,bam_4_faceup_getup_anim
	WL	ANI_CHANGEANIM,bam_2_faceup_getup_anim

 SUBR	bam_2_faceup_getup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	.word	ANI_CLR_STARS
	.word	ANI_CLR_DAMAGE

	WL	3,B3GU2A+FR1
	WL	ANI_GOTO,#common2

 SUBR	bam_2_faceup_getup2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	.word	ANI_CLR_STARS
	.word	ANI_CLR_DAMAGE

#common2
	WL	3,B3GU2A+FR2
	WL	3,B3GU2A+FR3
	WL	3,B3GU2A+FR4
	WL	3,B3GU2A+FR5
	WL	3,B3GU2A+FR6
	WL	3,B3GU2A+FR7
	WL	3,B3GU2A+FR8
	WL	3,B3GU2A+FR9

;Check for a flip here
	WL	1,B3GU2A+FR10
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,B3GU2A+FR10

	WL	3,B3GU2A+FR11
	WL	3,B3GU2A+FR12

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_4_faceup_getup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	.word	ANI_CLR_STARS
	.word	ANI_CLR_DAMAGE
	WL	3,B3GU4A+FR1
	WL	3,B3GU4A+FR2
	WL	3,B3GU4A+FR3
	WL	ANI_GOTO,#common4

 SUBR	bam_4_faceup_getup2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	.word	ANI_CLR_STARS
	.word	ANI_CLR_DAMAGE

#common4
	WL	3,B3GU4A+FR4
	WL	3,B3GU4A+FR5
	WL	3,B3GU4A+FR6
#frame7
	WL	3,B3GU4A+FR7
	WL	3,B3GU4A+FR8
	WL	3,B3GU4A+FR9



;Check for a flip here
	WL	1,B3GU4A+FR10
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,B3GU4A+FR10

	WL	3,B3GU4A+FR11
	WL	3,B3GU4A+FR12

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


 SUBR	bam_4_faceup_getup3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	.word	ANI_CLR_STARS
	.word	ANI_CLR_DAMAGE
	WL	ANI_GOTO,#frame7


#*****************************************************************************
*
* DIZZY

 SUBR	bam_dizzy_anim

	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_START_DIZZY,0	;0=Standing dizzy
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

#loop

	WL	8,B4TI4A+FR1
	WL	8,B4TI4A+FR2
	WL	8,B4TI4A+FR3
	WL	8,B4TI4A+FR4
	WL	8,B4TI4A+FR5
	WL	8,B4TI4A+FR6
	WL	8,B4TI4A+FR7
	WL	8,B4TI4A+FR6
	WL	8,B4TI4A+FR5
	WL	8,B4TI4A+FR4
	WL	8,B4TI4A+FR3
	WL	8,B4TI4A+FR2

	WL	ANI_GOTO,#loop


#*****************************************************************************

 SUBR	bam_roll_frames

	.word	7		;speed
	.long	50000h		;z velocity
	.long	10000h*10/255	;inv multiply (0-255 -> 0-10)

	.long	B3RL1A+FR1	;0
	.long	B3RL1A+FR2	;1
	.long	B3RL1A+FR3	;2
	.long	B3RL1A+FR4	;3
	.long	B3RL1A+FR5	;4
	.long	B3RL1A+FR6	;5
	.long	B3RL1A+FR7	;6
	.long	B3RL1A+FR8	;7
	.long	B3RL1A+FR9	;8
	.long	B3RL1A+FR10	;9
	.long	B3RL1A+FR11	;10
	.long	0,0,0,0,0,0


;#*****************************************************************************
;
; SUBR	bam_leap_test
;
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
;	.word	ANI_ZEROVELS
;	.word	ANI_SETSPEED,100h
;
;	.word	ANI_STARTATTACK,AT_STOMP,80
;	WL	10,B4TI4A+FR1
;
;	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 69,999,800h,20,90000h,TGT_CHEST,80,0,0
;
;	WL	70-3,B4TI4A+FR1
;
;;	.word	ANI_ATTACK_ON, AMODE_STOMP,-20,0,40,20 ;mode,x,y,w,h
;
;	.word	ANI_SLOWMO,20
;
;	WL	3,B4TI4A+FR1
;	.word	ANI_ATTACK_OFF
;
;	.word	ANI_ZEROVELS
;
;;;;	.word	ANI_SOUND,bounce_l1
;
;	.word	ANI_GRAVITY_OFF
;
;;;;	WL	ANI_CODE,#lockup
;
;	WL	3,B4TI4A+FR1
;	WL	ANI_CODE,HIT_THE_MAT
;
;	WL	20,B4TI4A+FR1
;	WL	ANI_CODE,SMALL_BOUNCE
;	.word	ANI_GRAVITY_ON
;	WL	20,B4TI4A+FR1
;
;	.word	ANI_SLOWMO,0
;
;
;	WL	60,B3RL1A+FR1
;
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END
;
;
;#lockup
;	nop
;	LOCKUP
;	nop
;	rets
;
#*****************************************************************************
*
* Get tossed out of ring from Shawn's Frankensteiner
*

 SUBR	bam_rxn2_fsteiner_anim

	.word	ANI_END

#*****************************************************************************
*
* #2 BLOCK

 SUBR	bam_2_block_anim

	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
	.word	ANI_ZERO_XZVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
;Rotate toward opponent if needed!

	.word	ANI_SETPLYRMODE,MODE_BLOCK
	WL	3,B2BK3B+FR1
	WL	3,B2BK3B+FR2
#blk2	WL	3,B2BK3B+FR3
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
	WL	3,B2BK3B+FR2
	WL	3,B2BK3B+FR1
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_2_hitblock_anim

	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
	.word	ANI_FRICTION,4000h
	.word	ANI_SETSPEED,100h

	WL	2,B2BK3B+FR4
	WL	2,B2BK3B+FR5
	WL	2,B2BK3B+FR4
	WL	ANI_GOTO,#blk2


* #4 BLOCK

 SUBR	bam_4_block_anim

	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
	.word	ANI_ZERO_XZVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
;Rotate toward opponent if needed!


	.word	ANI_SETPLYRMODE,MODE_BLOCK
	WL	3,B4BK3D+FR2
	WL	3,B4BK3D+FR3
#blk4	WL	3,B4BK3D+FR4
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
	WL	3,B4BK3D+FR3
	WL	3,B4BK3D+FR2
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_4_hitblock_anim

	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
	.word	ANI_FRICTION,4000h
	.word	ANI_SETSPEED,100h
	WL	2,B4BK3D+FR6
	WL	2,B4BK3D+FR7
	WL	2,B4BK3D+FR8
	WL	2,B4BK3D+FR7
	WL	2,B4BK3D+FR6
	WL	ANI_GOTO,#blk4


#*****************************************************************************
*
* THROWN FROM RING (shn_bslm, shn_frnk)

 SUBR	bam_flyout_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETSPEED,100h

	WL	8,B4TD3B+FR5
	WL	8,B4TD3B+FR6
	WL	8,B4TD3B+FR7
	WL	1,B4TD3B+FR8
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,60

	.word	ANI_DAMAGE,D_HIPTOSS
	.word	ANI_SETWORD,DELAY_METER,0
	.word	ANI_GETUP,500

	.word	ANI_OFFSET,10,0,0
	WL	3,B4TD3B+FR9
	WL	ANI_CHANGEANIM,bam_hitonground_xflip_anim


;FIX!!  Make throw out of ring if close to ropes
#*****************************************************************************
*
* FLIP/FALL FROM HIPTOSS

 SUBR	bam_tossed_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

	.word	ANI_XFLIP

	WL	ANI_CODE,ckzpos

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_GETUP,300
	WL	ANI_CODE,HIT_THE_MAT
	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL
	.word	ANI_OFFSET,15,0,0	;x,y,z
	WL	1,B3CP3B+FR1
	WL	ANI_SET_YVEL,50000h
	WL	3,B3CP3B+FR1
	WL	4,B3CP3B+FR2
	WL	4,B3CP3B+FR3
	WL	4,B3CP3B+FR4
	WL	4,B3CP3B+FR5
	WL	4,B3CP3B+FR6
	WL	4,B3CP3B+FR7

	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS

	WL	3,B3RL1A+FR1		;1st frame of roll
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_faceup_getup_anim
	.word	ANI_END

;FIX!!  Make throw out of ring if close to ropes
#*****************************************************************************
*
* FLIP/FALL FROM BAM BAM DUCK TOSS

 SUBR	bam_tossed2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,ckzpos

	WLW	ANI_SET_XVEL,60000h,AM_HIT_REL
	WL	ANI_SET_YVEL,30000h
	.word	ANI_OFFSET,20,20,0			;x,y,z
	WL	4,B4TD3B+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_GETUP,300
	.word	ANI_DAMAGE,D_HIPTOSS

	WL	3,B4TD3B+FR8
	WL	3,B4TD3B+FR9

	.word	ANI_XFLIP

	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,50000h
	.word	ANI_OFFSET,15,0,0	;x,y,z
	WL	4,B3CP3B+FR1
	WL	4,B3CP3B+FR2
	WL	4,B3CP3B+FR3
	WL	4,B3CP3B+FR4
	WL	4,B3CP3B+FR5
	WL	4,B3CP3B+FR6
	WL	4,B3CP3B+FR7

	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS

	WL	3,B3RL1A+FR1		;1st frame of roll
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_faceup_getup_anim
	.word	ANI_END

#*****************************************************************************
*

 SUBR	bam_knockdwn_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h
	.word	ANI_XFLIP
 
	WL	2,B3GU4A+FR12
	WL	2,B3GU4A+FR10
	WL	2,B3GU4A+FR7
	WL	ANI_SET_YVEL,39000h

	WL	3,B3CP3B+FR1
	WL	3,B3CP3B+FR2
	WL	3,B3CP3B+FR3
	WL	3,B3CP3B+FR4
	WL	3,B3CP3B+FR5
	WL	3,B3CP3B+FR6
	WL	3,B3CP3B+FR7

	WL	4,B3RL1A+FR1		;1st frame of roll


	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	.word	ANI_SETPLYRMODE,MODE_DEAD
	.word	ANI_END

#nodead

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_faceup_getup_anim
	.word	ANI_END

#*****************************************************************************
 SUBR	bam_climbthru_side_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WLW	ANI_SET_XVEL,2000h,AM_FACE_REL

	.word	ANI_OFFSET,16,0,0
	WL	4,B4CR7A+FR2
	.word	ANI_BENDROPE,0
	.word	ANI_OFFSET,3,0,0	;*****
	WL	4,B4CR7A+FR3		
	.word	ANI_OFFSET,3,0,0	;*****
	WL	4,B4CR7A+FR4

	.word	ANI_BENDROPE,2
	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH

	.word	ANI_OFFSET,5,0,0	;*****
	WL	4,B4CR7A+FR5

	.word	ANI_OFFSET,3,0,0	;*****
	WL	4,B4CR7A+FR6
	.word	ANI_BENDROPE,2
	.word	ANI_OFFSET,3,0,0	;*****
	WL	4,B4CR7A+FR7
	.word	ANI_OFFSET,4,0,0	;*****
	WL	4,B4CR7A+FR8
	.word	ANI_BENDROPE,3
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH
	.word	ANI_OFFSET,5,0,0	;*****
	WL	4,B4CR7A+FR9
	.word	ANI_OFFSET,5,0,0	;*****
	WL	4,B4CR7A+FR10
	.word	ANI_ZEROVELS
	.word	ANI_BENDROPE,-1
	.word	ANI_OFFSET,10,-3,0
	WL	4,B4CR7A+FR11
	.word	ANI_OFFSET,2,0,0	;*****
	WL	4,B4CR7A+FR12

	;now jump off...
	WL	4,B2JD4A+FR1		;D4FM4A+FR1
	WL	4,B2JD4A+FR2
	WL	3,B2JD4A+FR3

	WL	ANI_SET_YVEL,60000h

	WLW	ANI_SET_XVEL,30000h,AM_FACE_REL

	WL	3,B2JD4A+FR4
	.word	ANI_WAITHITGND

	.word	ANI_ROPE_Z,R_TOP,RZ_NORM
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM

	.word	ANI_ZEROVELS
	WL	3,B2JD4A+FR6
	WL	3,B2JD4A+FR7
	WL	6,B2JD4A+FR8
	WL	3,B2JD4A+FR9

	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	bam_climbin_side_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	ANI_CODE,SET_DIR_FACE
	.word	ANI_SETFACING
	.WORD	ANI_SET_WRESTLER_XFLIP

	;jump in
	WL	4,B2JD4A+FR1
	WL	4,B2JD4A+FR2

	WL	ANI_CODE,#set_trgt
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	.word	ANI_LEAPATPOS,1ch,200,0,0,0	;#ticks,dist,xoff,yoff,zoff

	WL	4,B2JD4A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH

	WL	4,B2JD4A+FR6
	WL	3,B2JD4A+FR7
	.word	ANI_OFFSET,13,0,0	;*****
	WL	3,B2JD4A+FR8
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM

	WL	ANI_CODE,#set_z
	WLW	ANI_SET_XVEL,2000h,AM_FACE_REL

	;climb through
	.word	ANI_OFFSET,3,0,0	;*****
	WL	3,B4CR7A+FR2
	.word	ANI_BENDROPE,0
	.word	ANI_OFFSET,3,0,0	;*****
	WL	3,B4CR7A+FR3
	.word	ANI_OFFSET,3,0,0	;*****
	WL	3,B4CR7A+FR4
	.word	ANI_OFFSET,3,0,0	;*****
	WL	3,B4CR7A+FR5

	.word	ANI_BENDROPE,2

	.word	ANI_OFFSET,3,0,0	;*****
	WL	3,B4CR7A+FR6
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH
	.word	ANI_BENDROPE,2
	.word	ANI_OFFSET,5,0,0	;*****
	WL	3,B4CR7A+FR7
	.word	ANI_OFFSET,5,0,0	;*****
	WL	3,B4CR7A+FR8
	.word	ANI_BENDROPE,3
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM
	.word	ANI_OFFSET,5,0,0	;*****
	WL	3,B4CR7A+FR9
	.word	ANI_OFFSET,5,0,0	;*****
	WL	3,B4CR7A+FR10
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_BENDROPE,-1
	.word	ANI_OFFSET,10,-3,0
	WL	3,B4CR7A+FR11
	WL	3,B4CR7A+FR12
	.word	ANI_ZEROVELS

	WL	ANI_CODE,clr_climb

	;done

	.word	ANI_ROPE_Z,R_TOP,RZ_NORM
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM

	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END

#set_trgt
	movi	RING_X_CENTER-0f8h-60,a0		;Jump onto left side apron
	move	*a13(OBJ_XPOSINT),a14
	cmpi	RING_X_CENTER,a14
	jrlt	#onlft
;On right side
	movi	RING_X_CENTER+0f8h+60,a0		;Jump onto right side apron
#onlft
	move	a0,*a13(TGT_XOFF)

	movi	RING_Z_CENTER,a0
	move	a0,*a13(TGT_ZOFF)

	movi	MAT_Y,a0
	move	a0,*a13(TGT_YOFF)

	rets
#set_z

clr_climb

	clr	a0
	move	a0,*a13(CLIMBING_THRU)		;1=Climbing thru ropes flag
	rets

#*****************************************************************************

 SUBR	bam_climbthru_bot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

;Must rotate toward ropes!
;Do a different sequence

	;lie down
	WL	ANI_CODE,#ckspin
	WL	3,B3GU2A+FR13
	WL	3,B3GU2A+FR12
	WL	3,B3GU2A+FR11
	WL	3,B3GU2A+FR10
	WL	3,B3GU2A+FR9
	WL	3,B3GU2A+FR8
	WL	3,B3GU2A+FR7
	WL	3,B3GU2A+FR6
	WL	3,B3GU2A+FR5
	WL	3,B3GU2A+FR4
	WL	3,B3GU2A+FR2
	WL	3,B3GU2A+FR1

	;roll over once
	WLW	ANI_SET_ZVEL,0A8000h,AM_ABS

	WL	3,B3RL1A+FR1
	WL	3,B3RL1A+FR2
	WL	3,B3RL1A+FR3
	WL	3,B3RL1A+FR4
	WL	3,B3RL1A+FR5
	WL	3,B3RL1A+FR6
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP+MODE_NOSHADOW

	;climb through
	.WORD	ANI_XFLIP
	WL	ANI_CODE,NOT_IN_RING
	.word	ANI_OFFSET,20,-37h,0			;x,y,z
	WL	3,B2KM3E+FR6
	WL	3,B2KM3E+FR3
	WL	3,B2KM3E+FR2
	.WORD	ANI_XFLIP

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END
			       
#ckspin
	move	*a13(FACING_DIR),a14
	btst	0,a14
	jrnz	#faceup

	move	*a13(ANIMODE),a0
	ori	MODE_STATUS,a0
	move	a0,*a13(ANIMODE)
	RETS
#faceup
	move	*a13(ANIMODE),a0
	ANDI	0FFFFH-MODE_STATUS,a0
	move	a0,*a13(ANIMODE)
	rets

NOT_IN_RING
	MOVK	1,A0
	MOVE	A0,*A13(INRING)
	RETS

#*****************************************************************************

 SUBR	bam_climbin_bot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;climb in
	.word	ANI_GRAVITY_OFF
	.WORD	ANI_XFLIP
	WL	3,B2KM3E+FR2
	WL	3,B2KM3E+FR3
	WL	3,B2KM3E+FR6
	.word	ANI_OFFSET,-20,37h,-60

	;roll
	WLW	ANI_SET_ZVEL,-70000h,AM_ABS
	.word	ANI_FRICTION,3000h
	WL	3,B3RL1A+FR11
	WL	3,B3RL1A+FR10
	WL	3,B3RL1A+FR9
	WL	3,B3RL1A+FR8
	WL	3,B3RL1A+FR7
	WL	3,B3RL1A+FR6
	.word	ANI_ZEROVELS
	.word	ANI_GRAVITY_ON

	;get up
	WL	3,B3GU2A+FR1
	WL	3,B3GU2A+FR2
	WL	3,B3GU2A+FR3
	WL	3,B3GU2A+FR4
	WL	3,B3GU2A+FR5
	WL	3,B3GU2A+FR6
	WL	3,B3GU2A+FR7
	WL	3,B3GU2A+FR8
	WL	3,B3GU2A+FR9
	WL	3,B3GU2A+FR10
	WL	3,B3GU2A+FR11
	WL	3,B3GU2A+FR12
	WL	3,B3GU2A+FR13

	WL	ANI_CODE,clr_climb

	.WORD	ANI_FACEDOWN
	.word	ANI_ZEROVELS
	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	bam_climbthru_top_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;lie down
	WL	ANI_CODE,#set_zvel1
	WL	ANI_IFSTATUS,#dir4
;Facing #2
	WL	3,B1TT5Z+FR2
	WL	3,B1TT5Z+FR3
	
#dir4
	WL	3,B3GU4A+FR12
	WL	3,B3GU4A+FR11
	WL	3,B3GU4A+FR10
	WL	3,B3GU4A+FR9
	WL	3,B3GU4A+FR8
	WL	3,B3GU4A+FR7
	WL	3,B3GU4A+FR6
	WL	3,B3GU4A+FR5
	WL	3,B3GU4A+FR4
	WL	3,B3GU4A+FR3
	WL	3,B3GU4A+FR2
	WL	3,B3GU4A+FR1

	;roll over once
	WL	ANI_CODE,#set_zvel2
	WL	3,B3RL1A+FR11
	WL	3,B3RL1A+FR10
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP+MODE_NOSHADOW
	WL	3,B3RL1A+FR9
	WL	3,B3RL1A+FR8
	WL	3,B3RL1A+FR7

	;climb through
	.word	ANI_ZEROVELS
	.word	ANI_OFFSET,0,-61,0
	.WORD	ANI_XFLIP
	WL	3,B4KM3E+FR2
	WL	3,B4KM3E+FR1
	.WORD	ANI_XFLIP

	.word	ANI_ZERO_XZVELS

	.WORD	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END

#set_zvel1
	move	*a13(FACING_DIR),a14
	btst	0,a14
	jrz	#facedwn
	move	*a13(ANIMODE),a0
	ANDI	0FFFFH-MODE_STATUS,a0
	move	a0,*a13(ANIMODE)
	rets

#facedwn
	move	*a13(ANIMODE),a0
	ori	MODE_STATUS,a0
	move	a0,*a13(ANIMODE)
	rets

#set_zvel2
	movi	-50000h,a0
	move	a0,*a13(OBJ_ZVEL),L
	rets


#*****************************************************************************

 SUBR	bam_climbin_top_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;climb in
	WL	3,B4KM3E+FR1
	WL	3,B4KM3E+FR2
	WL	3,B4KM3E+FR4
	.word	ANI_OFFSET,0,61,0
	.WORD	ANI_XFLIP

	;roll over
	WL	ANI_CODE,#set_zvel2
	WL	3,B3RL1A+FR8
	WL	3,B3RL1A+FR9
	WL	3,B3RL1A+FR10
	WL	3,B3RL1A+FR11	

	.word	ANI_ZEROVELS

	;get up
	WL	3,B3GU4A+FR1
	WL	3,B3GU4A+FR2
	WL	3,B3GU4A+FR3
	WL	3,B3GU4A+FR4
	WL	3,B3GU4A+FR5
	WL	3,B3GU4A+FR6
	WL	3,B3GU4A+FR7
	WL	3,B3GU4A+FR8
	WL	3,B3GU4A+FR9
	WL	3,B3GU4A+FR10
	WL	3,B3GU4A+FR11
	WL	3,B3GU4A+FR12

	WL	ANI_CODE,clr_climb

	.WORD	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#set_zvel2
	movi	50000h,a0
	move	a0,*a13(OBJ_ZVEL),L
	rets

#****************************************************************************
*
* PIN OPPONENT AND RAISE ARM IN VICTORY

;Need to have this guy walk toward fallen opponent so he
;can get closer!

;This pin must be started only when opponent is on the ground!

 SUBR	bam_2_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;Rotate!
	WL	3,B1TT5Z+FR2	;2.5
	WL	3,B1TT5Z+FR3	;3.5
	WL	ANI_GOTO,#cont

 SUBR	bam_4_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

#cont
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 25,999,80h,50h,90000h,TGT_CHEST,0,57,-15

	WL	3,B2PN5A+FR3
	.word	ANI_OFFSET,0,34,0			;x,y,z
	WL	22,B2PN5A+FR4
;	.word	ANI_WAITHITGND
	.word	ANI_ATTACK_ON_Z, AMODE_STOMP,-40,-8,0,76,20,30 ;mode,x,y,z,w,h,d
	.word	ANI_ZEROVELS

;	WLW	ANI_ATTCHIMAGE,D4PN5L+FR4,10		;image, zoff (priority)
	WL	3,B2PN5A+FR5
	WL	ANI_CODE,DO_CROWD_CHEER

	.word	ANI_ATTACK_OFF
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_BOUNCE,4
;	WLW	ANI_ATTCHIMAGE,D4PN5L+FR5,10		;image, zoff (priority)
	WL	3,B2PN5A+FR6
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE

	WL	4,B2PN5A+FR7
	.ref	win_announce
	WL	ANI_CODE,win_announce
;	WLW	ANI_ATTCHIMAGE,0,0		;Turn it off
;	WL	40,D4PN5A+FR6
	.word	ANI_OFFSET,0,0,20			;x,y,z
	WL	40,B2PN5A+FR5

;???? IS THIS WHERE IT GOES ?
	.word	ANI_LOOP
;Do another ground hit on opponent
	.ref	grnd_hit
	WL	ANI_CODE,grnd_hit

	WL	ANI_SET_YVEL,42000h
	WLW	ANI_SET_ZVEL,-22000h,AM_ABS
	WL	4,B5RV5A+FR1
	WL	4,B5RV5A+FR2
	WL	4,B5RV5A+FR3
	WL	4,B5RV5A+FR4
	WL	4,B5RV5A+FR5
	WL	4,B5RV5A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	4,B4WC4B+FR1
	WL	4,B4WC4B+FR2

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


	WL	4,B4WC4B+FR2
	WL	4,B4WC4B+FR1

	WL	4,B5RV5A+FR8
	WL	1000,B5RV5A+FR7


	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* HIP TOSS RUNNING OPPONENT

 SUBR	bam_3_hiptoss_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,6

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 6,40,40,40,90000h,TGT_CHEST,20,0,0
	WL	ANI_SET_YVEL,0000h

	WL	2,B3DR3B+FR1

	.word	ANI_ATTACK_ON, AMODE_PUPPET,16,40,42,42 ;mode,x,y,w,h
	WL	2,B3DR3B+FR2
	.word	ANI_ZERO_XZVELS
	WWL	ANI_WAITHITOPP,6,B3DR3B+FR2
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

;got him
	.ref	DO_SNAP_MESS
	WL	ANI_CODE,DO_SNAP_MESS
	.ref	CALL_SPECIAL_MOVE
	WL	ANI_CODE,CALL_SPECIAL_MOVE
	.word	ANI_SOUND,82h			;Effort grunt

	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
;	.word	ANI_DAMAGEOPP,D_HIPTOSS

; attacker sequence
	WWLLW	ANI_SUPERSLAVE2,3,B3DR3B+FR3,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,B3DR3B+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,B3DR3B+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,B3DR3B+FR6,#puppet_tbl,3
	WL	ANI_SET_YVEL,20000h
;	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL
	WWLLW	ANI_SUPERSLAVE2,3,B3DR3B+FR7,#puppet_tbl,4

	WL	ANI_SLAVEANIM,#rollout_tbl

	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_DETACH

	WL	10,B3DR3B+FR8
	WL	6,B3DR3B+FR9

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	6,B3DR3B+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WL	15,B3DR3B+FR3
#missed
	WL	10,B3DR3B+FR3
	WL	4,B3DR3B+FR2
	WL	4,B3DR3B+FR1

	WL	ANI_CODE,CALL_MISSES

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
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
	.ref	H3FR3A,H2AM3A
 LWWW H3FR3A+FR1,34,16,0
 LWWW H2AM3A+FR7,27,17,0
 LWWW H3FR3A+FR2,11,12,0
 LWWW H3FR3A+FR3,1,27,0
 LWWW H3FR3A+FR3,-9,13,0
 .long 0

#Razor
	.ref	R3TD3A
 LWWW R3TD3A+FR2,24,15,0
 LWWW R3TD3A+FR3,16,14,0
 LWWW R3TD3A+FR4,8,11,0
 LWWW R3TD3A+FR5,7,24,0
 LWWW R3TD3A+FR6,-3,22,0
 .long 0
#Taker
	.ref	U4AM4C,U3FH3A
 LWWW U4AM4C+FR4,25,38,0
 LWWW U3FH3A+FR1,27,20,1
 LWWW U3FH3A+FR2,8,9,1
 LWWW U3FH3A+FR3,1,4,1
 LWWW U3FH3A+FR4,-8,8,1
 .long 0
#Yokozuna
	.ref	Y3FL3W,Y5GU4B
 LWWW Y5GU4B+FR7,23,26,0
 LWWW Y5GU4B+FR7,15,32,0
 LWWW Y3FL3W+FR3,-15,22,0
; LWWW Y3PP3Q+FR1,-2,22,0
 LWWW Y3FL3W+FR4,-15,16,0
 LWWW Y3FL3W+FR5,-4,15,0



; LWWW Y3FL3W+FR1,28,43,0
; LWWW Y3FL3W+FR2,12,38,0
; LWWW Y3FL3W+FR3,-15,22,0
; LWWW Y3FL3W+FR4,-15,16,0
; LWWW Y3FL3W+FR5,-4,15,0
 .long 0
#Shawn
	.ref	S3OS3X
 LWWW S3OS3X+FR3,23,47,1
 LWWW S3OS3X+FR4,-7,41,1
 LWWW S3OS3X+FR5,-31,25,1
 LWWW S3OS3X+FR6,-27,43,1
 LWWW S3OS3X+FR7,-8,42,1
 .long 0
#BamBam
	.ref	B4TD3B
 LWWW B4TD3B+FR2,19,30,0
 LWWW B4TD3B+FR3,11,27,0
 LWWW B4TD3B+FR4,7,15,0
 LWWW B4TD3B+FR5,-3,35,0
 LWWW B4TD3B+FR6,-10,43,0
 .long 0
#Doink
	.ref	D3OS3A
 LWWW D3OS3A+FR1,26,19,0
 LWWW D3OS3A+FR2,9,22,0
 LWWW D3OS3A+FR3,-7,13,0
 LWWW D3OS3A+FR4,-12,12,0
 LWWW D3OS3A+FR5,-6,11,0
 .long 0
#Adam
 .long 0
#Lex
 	.ref	L4AM4B,L3FH3A
 LWWW L3FH3A+FR1,22,25,0
 LWWW L3FH3A+FR2,19,10,0
 LWWW L3FH3A+FR3,11,14,0
 LWWW L3FH3A+FR4,12,12,0
 LWWW L3FH3A+FR5,8,7,0
 .long 0

	.ref	hrt_tossed2_anim
	.ref	shn_tossed2_anim
;	.ref	bam_tossed2_anim
	.ref	dnk_tossed2_anim
	.ref	und_tossed2_anim
	.ref	lex_tossed2_anim
	.ref	rzr_tossed2_anim
	.ref	yok_tossed2_anim

#rollout_tbl
	.long	hrt_tossed2_anim,rzr_tossed2_anim
	.long	und_tossed2_anim
	.long	yok_tossed2_anim
	.long	shn_tossed2_anim,bam_tossed2_anim
	.long	dnk_tossed2_anim,0,lex_tossed2_anim

#*****************************************************************************
*
* #2,4 FLYING CLOTHESLINE

 SUBR	bam_fly_cline_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_OVERLAP+MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_LEAPING,9
	WL	3,B3RC3A+FR1

	WLW	ANI_SET_XVEL,70000h,AM_FACE_REL
	WWL	ANI_SETLONG,OBJ_GRAVITY,08000h
	WL	3,B3RC3A+FR2
	WL	3,B3RC3A+FR3
	WL	ANI_SET_YVEL,50000h
	WL	3,B3RC3A+FR4
	.word	ANI_OFFSET,0,45,0			;x,y,z
	.word	ANI_ATTACK_ON, AMODE_CLINE,2,5,14,53 ;mode,x,y,w,h ;31
	WL	20,B3RC3A+FR5
	.word	ANI_ATTACK_OFF
	WL	3,B3RC3A+FR7
	.word	ANI_WAITHITGND
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	WL	3,B3RC3A+FR8
	WLW	ANI_SET_XVEL,50000h,AM_FACE_REL
	.word	ANI_FRICTION,3000h
	.word	ANI_BOUNCE,4

	WL	3,B3RC3A+FR8
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	WL	15,B3RC3A+FR8

	WL	ANI_IFSTATUS,#gothim
;He missed, have him stay on ground for awhile!
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	WL	30,B3RC3A+FR8
#gothim
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_faceup_getup_anim
	.word	ANI_END

;
;	WL	3,D3RL1B+FR7
;	WL	3,D3RL1B+FR9
;	WL	3,D3RL1B+FR11
;
;;Perhaps we should turn off collisions when getting up!?
;;Getting up, set no_collis
;	.word	ANI_SETMODE,MODE_UNINT+MODE_OVERLAP+MODE_NOAUTOFLIP+MODE_NOCOLLIS
;
;	WL	3,D3GU4A+FR2
;	WL	3,D3GU4A+FR3
;	WL	3,D3GU4A+FR4
;	WL	3,D3GU4A+FR5
;	WL	3,D3GU4A+FR6
;
;;Check for a flip here
;	WL	1,D3GU4A+FR7
;	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
;	.word	ANI_SET_WRESTLER_XFLIP
;
;	WL	2,D3GU4A+FR7
;	WL	3,D3GU4A+FR8
;	WL	3,D3GU4A+FR9
;
;	.word	ANI_SAFE_TIME,0
;
;	.word	ANI_FACEDOWN
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_SETPLYRMODE,MODE_NORMAL
;	.word	ANI_END

#*****************************************************************************
* #4 SLAP

;Leaping fire head butt

 SUBR	bam_2_slap_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_LEAPING,20

	WL	2,B1TT5Z+FR2	;2.5
	WL	2,B1TT5Z+FR3	;3.5

 SUBR	bam_4_slap_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_LEAPING,16
	WL	3,B3FH3F+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 13,999,4ah,50,90000h,TGT_HEAD,40,101,10

	.word	ANI_CLR_STATUS
	WL	3,B3FH3F+FR2
	WL	3,B3FH3F+FR3
	WL	3,B3FH3F+FR4
	WL	2,B3FH3F+FR5
	WL	2,B3FH3F+FR6
	WL	1,B3FH3F+FR7

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,32,47,39,55	;mode,x,y,w,h
	WL	2,B3FH3F+FR7
	WL	3,B3FH3F+FR8
	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker
;hit
	.ref	create_impact
	WL	ANI_CODE,create_impact

	WWL	ANI_SLIDE_BACK,30h,-50000h,#no_hit2
	WL	ANI_SET_YVEL,40000h
#no_hit2
#missed
#missedb
	WL	3,B3FH3F+FR8
	WL	3,B3FH3F+FR9
	WL	3,B3FH3F+FR10
	WL	3,B3FH3F+FR11

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************

 SUBR	bam_knees_anim
;From head hold mode

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_SETWORD,USR_VAR2,0

	WL	2,B4KM3A+FR1
	.word	ANI_SET_RPTCOUNT,3	;3 times
#rpt_loop
	.word	ANI_STARTATTACK,AT_KNEE,6
	.word	ANI_CLR_BUTCOUNT

	WL	2,B4KM3A+FR2
	WL	2,B4KM3A+FR3
	WL	2,B4KM3A+FR4
	.word	ANI_ATTACK_ON, AMODE_HEADKNEES,37,62,62,35	;mode,x,y,w,h
	WL	2,B4KM3A+FR5
	.word	ANI_ATTACK_OFF
	WL	2,B4KM3A+FR6
	WL	2,B4KM3A+FR7
	WL	2,B4KM3A+FR8
;	WL	1,B4KM3A+FR9

	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#missed2
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#rpt_loop
	.word	ANI_SETWORD,USR_VAR2,1
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#missed2

	.word	ANI_DETACH
;	WLW	ANI_SET_XVEL,18000h,AM_FACE_REL
	WL	ANI_CHANGEANIM,bam_3_hiptoss_anim
	.word	ANI_END

#missed2
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#missed3
	.ref	bam_4_graboh_anim
	WL	ANI_CHANGEANIM,bam_4_graboh_anim
	.word	ANI_END

#missed3
	WL	3,B4KM3A+FR10

	.word	ANI_DETACH
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#******************************************************************************

 SUBR	bam_hdbutts_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_SETWORD,USR_VAR2,0

	WLW	ANI_SET_XVEL,50000h,AM_FACE_REL
	.word	ANI_SET_RPTCOUNT,3	;3 times
#rpt_loop
	.word	ANI_CLR_BUTCOUNT
	.word	ANI_STARTATTACK,AT_HDBUTT,10

	WL	2,B4BC3A+FR1
	WL	2,B4BC3A+FR2
	WL	2,B4BC3A+FR3
	WL	2,B4BC3A+FR4
	WL	2,B4BC3A+FR5

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,5,79,40,19	;mode,x,y,w,h
	WL	2,B4BC3A+FR6
	.word	ANI_ATTACK_OFF
	WL	2,B4BC3A+FR6

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#missed2
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#rpt_loop
	.word	ANI_SETWORD,USR_VAR2,1
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#missed2

	.word	ANI_DETACH
	WL	ANI_CHANGEANIM,bam_3_hiptoss_anim
	.word	ANI_END

#missed2
	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#missed3
	.ref	bam_4_graboh_anim
	.ref	bam_pogo_anim
	WL	ANI_CHANGEANIM,bam_pogo_anim
	.word	ANI_END

#missed3
	WL	2,B4BC3A+FR7

	.word	ANI_DETACH
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************
	.end
