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

	.file	"undseq2.asm"
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
	.include	"ring.equ"

	.include	"takerimg.h"
	.include	"damage.equ"
	.include	"miscimg.glo"


******************************************************************************
* EXTERNAL REFERENCES

	.REF	DO_CROWD_CHEER
	.ref	SET_DIR_FACE
	.REF	HIT_THE_MAT,SMALL_BOUNCE

	.REF	CALL_MISSES
 	.ref	am_I_dizzy
	.ref	am_I_dead
	.ref	ckzpos
	.ref	ck_dizzy
	.ref	start_run_anim
	.ref	no_bk_xvel,check_xvel

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* #2 NORMAL PUNCH

 SUBR	und_2_punch_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	WL	3,U2PL3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_PUNCH,6
	WL	3,U2PL3A+FR3
	WL	3,U2PL3A+FR4
	.word	ANI_ATTACK_ON, AMODE_PUNCH,53,92,48,12	;mode,x,y,w,h
	WL	8,U2PL3A+FR5
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-30000h,#no_hit

	WL	ANI_SET_YVEL,30000h
	WL	5,U2PL3A+FR5
#no_hit
	WL	3,U2PL3A+FR6
	WL	3,U2PL3A+FR7
	WL	3,U2PL3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 NORMAL PUNCH

 SUBR	und_4_punch_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	WL	3,U4PL3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_PUNCH,6
	WL	3,U4PL3A+FR3
	WL	3,U4PL3A+FR4
	.word	ANI_ATTACK_ON, AMODE_PUNCH,53,92,48,12	;mode,x,y,w,h
	WL	8,U4PL3A+FR5
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-30000h,#no_hit2

	WL	ANI_SET_YVEL,30000h
	WL	5,U4PL3A+FR5
	
#no_hit2
	WL	3,U4PL3A+FR6
	WL	3,U4PL3A+FR7
	WL	3,U4PL3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 UPPERCUT

 SUBR	und_2_uppercut_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

* #4 UPPERCUT

 SUBR	und_4_uppercut_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	.word	ANI_STARTATTACK,AT_PUNCH,8
	WL	2,U4UP3C+FR1
	WL	2,U4UP3C+FR2
	WL	2,U4UP3C+FR3
	WL	2,U4UP3C+FR4
	.word	ANI_ATTACK_ON, AMODE_UPRCUT,46,55,29,59	;mode,x,y,w,h
	WL	2,U4UP3C+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker
;Hit, spray some explosions
;Turn on explosion sound effect
	.ref	create_impact4
	WL	ANI_CODE,create_impact4
	WL	ANI_CODE,HIT_THE_MAT



	WWL	ANI_SLIDE_BACK,30h,-40000h,#no_hit2
	WL	10,U4UP3C+FR5

#no_hit2
	WL	20,U4UP3C+FR5
	.word	ANI_OFFSET,0,0,-5			;x,y,z
	WL	3,U4UP3C+FR4
	WL	3,U4UP3C+FR3
	WL	3,U4UP3C+FR2
	WL	3,U4UP3C+FR1

;	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WL	20,U4UP3C+FR5
#missed
	WL	5,U4UP3C+FR5
	WL	3,U4UP3C+FR4
	WL	3,U4UP3C+FR3
	WL	3,U4UP3C+FR2
	WL	3,U4UP3C+FR1

;	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
* #4 SLAP

;Leaping urn slam

 SUBR	und_2_slap_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	2,U1TT5A+FR3
	WL	2,U1TT5A+FR4

 SUBR	und_4_slap_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_LEAPING,12

	WLW	ANI_ATTCHIMAGE,#GLOVE+FR1,1 ;image, zoff (priority)
	WL	3,U4WA4H+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 0dh,999,4ah,50,90000h,TGT_HEAD,75,101,10

	.word	ANI_CLR_STATUS
	WLW	ANI_ATTCHIMAGE,#GLOVE+FR2,1 ;image, zoff (priority)
	WL	8,U4WA4H+FR2
	WLW	ANI_ATTCHIMAGE,#GLOVE+FR3,1 ;image, zoff (priority)
	WL	3,U4WA4H+FR3
	WLW	ANI_ATTCHIMAGE,#GLOVE+FR4,1 ;image, zoff (priority)
	WL	1,U4WA4H+FR4

;MJT Start 2
	.word	ANI_ATTACK_ON, AMODE_URN,31,63,56,38	;mode,x,y,w,h
;MJT End 2
	WL	2,U4WA4H+FR4
	WLW	ANI_ATTCHIMAGE,#GLOVE+FR5,1 ;image, zoff (priority)
	WL	3,U4WA4H+FR5
	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker
;hit
	.ref	create_impact
	WL	ANI_CODE,create_impact
;Put in URN smash sound!
	WL	ANI_CODE,HIT_THE_MAT

	WWL	ANI_SLIDE_BACK,30h,-50000h,#no_hit2
	WL	ANI_SET_YVEL,40000h
#no_hit2
#missed
#missedb
	WL	2,U4WA4H+FR5
	WL	ANI_CODE,HIT_THE_MAT
	WLW	ANI_ATTCHIMAGE,#GLOVE+FR6,1 ;image, zoff (priority)
	WL	3,U4WA4H+FR6
	WL	ANI_CODE,HIT_THE_MAT
	WLW	ANI_ATTCHIMAGE,#GLOVE+FR7,1 ;image, zoff (priority)
	WL	3,U4WA4H+FR7
	WLW	ANI_ATTCHIMAGE,#GLOVE+FR8,1 ;image, zoff (priority)
	WL	3,U4WA4H+FR8
	WLW	ANI_ATTCHIMAGE,#GLOVE+FR9,1 ;image, zoff (priority)
	WL	3,U4WA4H+FR10

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WLW	ANI_ATTCHIMAGE,0,0

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#GLOVE
	.long	0
	.long	GLVHIT01
	.long	GLVHIT02
	.long	GLVHIT03
	.long	GLVHIT04
	.long	GLVHIT05
	.long	GLVHIT06
	.long	GLVHIT07
	.long	GLVHIT08
	.long	GLVHIT09

#*****************************************************************************
*
* #2 PUSH

 SUBR	und_2_push_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUSH,12
	WL	3,U2PS3A+FR1
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	WL	3,U2PS3A+FR2
	WL	3,U2PS3A+FR3
	WL	3,U2PS3A+FR4
	.word	ANI_ATTACK_ON, AMODE_PUSH,33,85,65,17 ;mode,x,y,w,h
	WL	3,U2PS3A+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

	WWL	ANI_SLIDE_BACK,40h,-60000h,#no_hit	;range,vel,addr
	WL	15,U2PS3A+FR5
#no_hit
	WL	10,U2PS3A+FR5
	WL	4,U2PS3A+FR6
	WL	4,U2PS3A+FR7
	WL	4,U2PS3A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END
#missedb
#missed
	WL	10,U2PS3A+FR5
	WL	4,U2PS3A+FR6
	WL	4,U2PS3A+FR7
	WL	4,U2PS3A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 PUSH

 SUBR	und_4_push_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUSH,12
	WL	3,U4PS3A+FR1
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	WL	3,U4PS3A+FR2
	WL	3,U4PS3A+FR3
	WL	3,U4PS3A+FR4
	.word	ANI_ATTACK_ON, AMODE_PUSH,33,85,65,17 ;mode,x,y,w,h
	WL	3,U4PS3A+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

	WWL	ANI_SLIDE_BACK,40h,-60000h,#no_hit	;range,vel,addr
	WL	15,U4PS3A+FR5
#no_hit
	WL	7,U4PS3A+FR5
	WL	4,U4PS3A+FR6
	WL	4,U4PS3A+FR7
	WL	4,U4PS3A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END
#missedb
#missed
	WL	7,U4PS3A+FR5
	WL	4,U4PS3A+FR6
	WL	4,U4PS3A+FR7
	WL	4,U4PS3A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************
*
* #2 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	und_2_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

	WL	3,U2AH3A+FR3
	WL	15,U2AH3A+FR4
	WL	4,U2AH3A+FR5

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	und_4_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

	WL	4,U4AH3A+FR2
	WL	14,U4AH3A+FR3
	WL	4,U4AH3A+FR4
	WL	4,U4AH3A+FR5

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


* #4 RUNNING BOUNCE OFF OF OPPONENT

;Bounce off but stay dizzy!

 SUBR	und_4_bncoff_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	4,U4AH3A+FR2
	WL	14,U4AH3A+FR3
	WL	4,U4AH3A+FR4
	WL	4,U4AH3A+FR5

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,und_dizzy_anim
	.word	ANI_END

******************************************************************************
*
* #4 LOSE BALANCE

 SUBR	und_4_losebal_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_FRICTION,3000h
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL

	WL	4,U4LB4A+FR1
	WL	4,U4LB4A+FR2
	WL	4,U4LB4A+FR3
	WL	4,U4LB4A+FR4
	WL	4,U4LB4A+FR5
	WL	4,U4LB4A+FR6
	WL	4,U4LB4A+FR1

	.word	ANI_FACEDOWN
;	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 LOSE BALANCE - Go dizzy

 SUBR	und_4_losebal_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_FRICTION,3000h
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	4,U4LB4A+FR1
	WL	4,U4LB4A+FR2
	WL	4,U4LB4A+FR3
	WL	4,U4LB4A+FR4
	WL	4,U4LB4A+FR5
	WL	4,U4LB4A+FR6
	WL	4,U4LB4A+FR1

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,und_dizzy_anim
	.word	ANI_END

#*****************************************************************************
*
* #2 ELBOW DROP

#yoff	equ	40

 SUBR	und_2_lbowdrop_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	3,U2JP2C+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	3,U2JP2C+FR2
	WL	3,U2JP2C+FR3

	;skip the leap if simply falling down will do.
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,29,-14,-40,25,36,50
	WL	1,U2JP2C+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#skip_leapat

	.word	ANI_TARGET,TGT_CHEST,TGT_CHEST,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 20,999,112,96,90000h,TGT_USER,44,#yoff,-30
	WL	ANI_GOTO,#do_leapat

#skip_leapat
	WL	ANI_SET_YVEL,30000h
#do_leapat
	.word	ANI_OFFSET,0,#yoff,0
	WL	3,U2JP2C+FR4
	WL	3,U2JP2C+FR5
	WL	3,U2JP2C+FR6
	WL	3,U2JP2C+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_SHAKER,40
	.word	ANI_SHAKEALL,2
	.word	ANI_CLR_STATUS
	.word	ANI_ATTACK_ON_Z,AMODE_LBOWDROP,29,-14,-40,25,36,50
	WL	4,U2JP2C+FR8
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#hit

	WL	ANI_CODE,CALL_MISSES
#hit
	WL	8,U2JP2C+FR9

	;getup
	.word	ANI_OFFSET,13,0,0
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	3,U3GD2A+FR4
	WL	3,U3GD2A+FR5
	WL	3,U3GD2A+FR6
	WL	3,U3GD2A+FR7
;Keep this frame in game...
	WL	1,U3GD2A+FR8
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,U3GD2A+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #4 ELBOW DROP

#yoff	equ	40

 SUBR	und_4_lbowdrop_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	3,U4JP4D+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	3,U4JP4D+FR2
	WL	3,U4JP4D+FR3

	;skip the leap if simply falling down will do.
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,3,-16,-10,27,35,50
	WL	1,U4JP4D+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#skip_leapat

#skip_leapat
	.word	ANI_TARGET,TGT_CHEST,TGT_CHEST,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 20,999,112,96,90000h,TGT_USER,19,#yoff,60
	WL	ANI_GOTO,#do_leapat

;#skip_leapat
	WL	ANI_SET_YVEL,30000h
#do_leapat
	.word	ANI_OFFSET,0,#yoff,0
	WL	3,U4JP4D+FR4
	WL	3,U4JP4D+FR5
	WL	3,U4JP4D+FR6
	WL	3,U4JP4D+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKER,40
	.word	ANI_SHAKEALL,2
	.word	ANI_CLR_STATUS
	.word	ANI_ATTACK_ON_Z,AMODE_LBOWDROP,3,-16,-10,27,35,70
	WL	4,U4JP4D+FR8
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#hit

	WL	ANI_CODE,CALL_MISSES
#hit
	WL	8,U4JP4D+FR9

	;getup
	.word	ANI_OFFSET,19,0,0
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	3,U3GD4A+FR5
	WL	3,U3GD4A+FR6
	WL	3,U3GD4A+FR7
	WL	1,U3GD4A+FR8
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,U3GD4A+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #2 HEADBUTT

 SUBR	und_2_butt_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	3,U2BC3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_PUNCH,8
	WL	2,U2BC3A+FR2
	WL	2,U2BC3A+FR3
	WL	2,U2BC3A+FR4
	WL	2,U2BC3A+FR5
	.word	ANI_ATTACK_ON, AMODE_HDBUTT,-8,83,73,36	;mode,x,y,w,h
	WL	3,U2BC3A+FR6
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-48000h,#no_hit

	WL	ANI_SET_YVEL,38000h
	WL	6,U2BC3A+FR7
#no_hit
	WL	5,U2BC3A+FR7
	WL	3,U2BC3A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 HEADBUTT

 SUBR	und_4_butt_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	3,U4BC3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_PUNCH,8
	WL	2,U4BC3A+FR2
	WL	2,U4BC3A+FR3
	WL	2,U4BC3A+FR4
	WL	2,U4BC3A+FR5
	.word	ANI_ATTACK_ON, AMODE_HDBUTT,-8,83,73,36	;mode,x,y,w,h
	WL	3,U4BC3A+FR6
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-48000h,#no_hit2

	WL	ANI_SET_YVEL,38000h
	WL	6,U4BC3A+FR7
#no_hit2
	WL	5,U4BC3A+FR7
	WL	3,U4BC3A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 KICK

 SUBR	und_2_kick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	3,U2KM3B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KICK,5
	WL	3,U2KM3B+FR2
	WL	2,U2KM3B+FR3
	WWL	ANI_SETLONG,OBJ_GRAVITY,0c000h
	WL	ANI_SET_YVEL,40000h
	.word	ANI_ATTACK_ON, AMODE_KICK,27,59,68,20	;mode,x,y,w,h
	WL	7,U2KM3B+FR4
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-40000h,#no_hit
	WL	ANI_SET_YVEL,30000h
	WL	10,U2KM3B+FR4

#no_hit
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY
	WL	3,U2KM3B+FR5
	WL	3,U2KM3B+FR6
	WL	3,U2KM3B+FR7
	WL	3,U2KM3B+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 KICK

 SUBR	und_4_kick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	3,U4KM3E+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KICK,5
	WL	3,U4KM3E+FR2
	WL	2,U4KM3E+FR3
	WWL	ANI_SETLONG,OBJ_GRAVITY,0c000h
	WL	ANI_SET_YVEL,40000h
	.word	ANI_ATTACK_ON, AMODE_KICK,27,59,68,20	;mode,x,y,w,h
	WL	7,U4KM3E+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-40000h,#no_hit2
	WL	ANI_SET_YVEL,30000h
	WL	10,U4KM3E+FR4
	
#no_hit2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY
	WL	3,U4KM3E+FR5
	WL	3,U4KM3E+FR6
	WL	3,U4KM3E+FR8
	WL	3,U4KM3E+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 SUPER KICK

 SUBR	und_2_super_kick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_LEAPING,15
	WL	3,U2KB3A+FR1
	.word	ANI_OFFSET,5,0,0
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 12,999,80,40,90000h,TGT_CHEST,64,0,20
	WL	ANI_SET_YVEL,48000h
	WL	4,U2KB3A+FR2
	WL	4,U2KB3A+FR3
	WL	4,U2KB3A+FR4

	.word	ANI_ATTACK_ON, AMODE_KICK,19,60,68,27	;mode,x,y,w,h
	WL	2,U2KB3A+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

;Hit
;Turn on spirits
	.ref	create_impact2
	WL	ANI_CODE,create_impact2
	.word	ANI_ZERO_XZVELS

	WWL	ANI_SLIDE_BACK,30h,-40000h,#no_hit2
	WL	ANI_SET_YVEL,30000h
	WLW	ANI_SET_ZVEL,-28000h,AM_ABS
	WL	9,U2KB3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	5,U2KB3A+FR6
	WL	5,U2KB3A+FR7

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#no_hit2
	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL
	WLW	ANI_SET_ZVEL,-28000h,AM_ABS
	WL	ANI_SET_YVEL,20000h
	WL	2,U2KB3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	5,U2KB3A+FR6
	WL	5,U2KB3A+FR7

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WL	ANI_CODE,CALL_MISSES
#missed
	WL	3,U2KB3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	5,U2KB3A+FR6
	WL	5,U2KB3A+FR7

	.word	ANI_FACEDOWN
;	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#* #4 SUPER KICK

 SUBR	und_4_super_kick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_STARTATTACK,AT_LEAPING,15

	WL	3,U4KB3A+FR2
	.word	ANI_OFFSET,5,0,0
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 12,999,80,40,90000h,TGT_CHEST,64,0,-20
	WL	ANI_SET_YVEL,48000h
	WL	4,U4KB3A+FR3
	WL	4,U4KB3A+FR4
	WL	4,U4KB3A+FR5

	.word	ANI_ATTACK_ON, AMODE_KICK,8,48,74,33	;mode,x,y,w,h
	WL	2,U4KB3A+FR7
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

;Hit
;Turn on spirits
	.ref	create_impact2
	WL	ANI_CODE,create_impact2
	.word	ANI_ZERO_XZVELS

	WWL	ANI_SLIDE_BACK,30h,-40000h,#no_hit2
	WL	ANI_SET_YVEL,30000h
	WLW	ANI_SET_ZVEL,28000h,AM_ABS
	WL	9,U4KB3A+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	5,U4KB3A+FR8
;	WL	4,U4KB3A+FR9

	.word	ANI_FACEUP
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#no_hit2
	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL
	WLW	ANI_SET_ZVEL,28000h,AM_ABS
	WL	ANI_SET_YVEL,20000h
	WL	2,U4KB3A+FR7

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	5,U4KB3A+FR8
;	WL	4,U4KB3A+FR9

	.word	ANI_FACEUP
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WL	ANI_CODE,CALL_MISSES
#missed
	WL	5,U4KB3A+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	5,U4KB3A+FR8
;	WL	4,U4KB3A+FR9

	.word	ANI_FACEUP
;	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #2 STOMP ON FALLEN OPPONENT

 SUBR	und_2_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,U2MP2A+FR1
	WL	3,U2MP2A+FR2

	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,9,-1,-40,28,31,50
	WL	1,U2MP2A+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#leapat

	WL	ANI_SET_YVEL,28000h
	WL	ANI_GOTO,#common
#leapat
	.word	ANI_TARGET,TGT_HEAD,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,112,96,40000h,TGT_USER,19,0,-30
	WL	ANI_CODE,no_bk_xvel
#common
	WL	4,U2MP2A+FR3
	WL	1,U2MP2A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_CLR_STATUS
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,9,-1,-40,28,31,50
	WL	1,U2MP2A+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	.word	ANI_SHAKER,20
	.word	ANI_SHAKEALL,1
	WL	ANI_GOTO,#hit
#missed
	WL	ANI_CODE,CALL_MISSES
#hit
	WL	4,U2MP2A+FR5
	WL	4,U2MP2A+FR6
	WL	4,U2MP2A+FR7
	WL	4,U2MP2A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #4 STOMP ON FALLEN OPPONENT


 SUBR	und_4_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,U4MP4A+FR1
	WL	3,U4MP4A+FR2

	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,-21,-11,-10,42,33,50
	WL	1,U4MP4A+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#leapat

	WL	ANI_SET_YVEL,28000h
	WL	ANI_GOTO,#common
#leapat
	.word	ANI_TARGET,TGT_HEAD,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,112,96,40000h,TGT_USER,-13,0,30
	WL	ANI_CODE,no_bk_xvel
#common
	WL	4,U4MP4A+FR3
;Frame was not loaded...So I took it out...
;	WL	1,U4MP4A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_CLR_STATUS
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,-21,-11,-10,42,33,50
	WL	1,U4MP4A+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	.word	ANI_SHAKER,20
	.word	ANI_SHAKEALL,1
	WL	ANI_GOTO,#hit
#missed
	WL	ANI_CODE,CALL_MISSES
#hit
	WL	4,U4MP4A+FR5
	WL	4,U4MP4A+FR6
	WL	4,U4MP4A+FR7
	WL	4,U4MP4A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************]
*
* #3 FLYING BUTT-DROP

#yoff	equ	50

 SUBR	und_flying_butt_drop_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h

	WL	4,U4JK4A+FR3
	.word	ANI_OFFSET,0,#yoff,0

	.word	ANI_TARGET,TGT_CHEST,TGT_CHEST,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 30,200,150,90,90000h,TGT_USER,0,0,-10

	.word	ANI_SETPLYRMODE,MODE_INAIR

	WL	ANI_CODE,no_bk_xvel
	WL	4,U4JK4A+FR4
	WL	4,U4JK4A+FR5
	WL	4,U4JK4A+FR6
	WL	4,U4JK4A+FR7
	.word	ANI_ATTACK_ON,AMODE_BUTTSTOMP,-25,-7+5,55,23
	WWL	ANI_WAITHITOPP,18,U4JK4A+FR8
	.word	ANI_ATTACK_OFF

	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,1
	WL	ANI_CODE,HIT_THE_MAT

	WL	ANI_IFNOTSTATUS,#miss

#hit
	;bounce is automatic...

	WL	4,U4JK4A+FR10
	WL	4,U4JK4A+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_XFLIP
	.word	ANI_FACEUP
	WL	ANI_CHANGEANIM,und_getup2_anim

#miss	;missed
	WL	ANI_CODE,CALL_MISSES

	WL	12,U4JK4A+FR10
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_XFLIP
	.word	ANI_FACEUP
	WL	ANI_CHANGEANIM,und_getup2_anim

#*****************************************************************************]
*
* TURNBUCKLE BUTT-DROP

#yoff	equ	50

 SUBR	und_tbukl_butt_drop_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCONFINE|MODE_NOCOLLIS|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING

	.word	ANI_STARTATTACK,AT_LEAPING,35

;	WL	3,U4JK4A+FR1
;	WL	3,U4JK4A+FR2
	WL	3,U4JK4A+FR3
	.word	ANI_OFFSET,0,#yoff,0

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 36,190,190,190,90000h,TGT_GROIN,0,0,-20

	.word	ANI_SETPLYRMODE,MODE_INAIR2
	.word	ANI_GRAVITY_ON
	.word	ANI_SHAKECORNER

;Check x vel to make sure we aren't going to land on ropes!
	WL	ANI_CODE,check_xvel

	WL	3,U4JK4A+FR4
	WL	3,U4JK4A+FR5
	WL	3,U4JK4A+FR6
	WL	3,U4JK4A+FR7
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-25,8,-30,55,23,60
	WWL	ANI_IFOPPMODE,~MODE_ONGROUND,#not_onground
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-25,-2,-30,55,23,60
#not_onground
	WWL	ANI_WAITHITOPP,30,U4JK4A+FR8
	.word	ANI_ATTACK_OFF

	.word	ANI_ZERO_XZVELS
	.word	ANI_SETPLYRMODE,MODE_INAIR

	.word	ANI_SHAKER,40
	.word	ANI_SHAKEALL,2
	WL	ANI_CODE,HIT_THE_MAT

	WL	ANI_IFNOTSTATUS,#miss

#hit
	.word	ANI_WAITHITGND
	WL	ANI_SET_YVEL,50000h
	WLW	ANI_SET_ZVEL,28000h,AM_ABS
	.word	ANI_SETPLYRMODE,MODE_INAIR
	WL	4,U4JK4A+FR10
	WL	4,U4JK4A+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_XFLIP
	.word	ANI_FACEUP
	WL	ANI_CHANGEANIM,und_getup2_anim

#miss	;missed
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_BOUNCE,4
	.word	ANI_SHAKER,20
	.word	ANI_SHAKEALL,1
	.word	ANI_WAITHITGND

	WL	1,U4JK4A+FR10
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_ZEROVELS
	WL	12,U4JK4A+FR10
	.word	ANI_XFLIP
	.word	ANI_FACEUP
	WL	ANI_CHANGEANIM,und_getup2_anim

#*****************************************************************************
*
* #4 BIG BOOT

 SUBR	und_4_bigboot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_STARTATTACK,AT_BIGBOOT,8
	WL	4,U4BG3A+FR2
	WL	4,U4BG3A+FR3
	WL	ANI_CODE,#clrcnt
	.word	ANI_ATTACK_ON, AMODE_BIGBOOT,30,89,68,20 ;mode,x,y,w,h
	WL	2,U4BG3A+FR4
#lp
	WL	2,U4BG3A+FR4
	WL	ANI_CODE,#holdup
	WL	ANI_IFSTATUS,#lp

	.word	ANI_ATTACK_OFF

	WL	4,U4BG3A+FR5
	WL	4,U4BG3A+FR6
	WL	4,U4BG3A+FR7

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
	.ref	get_but_val_cur
	calla	get_but_val_cur
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

 SUBR	und_2_knee_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,U2NM3A+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KICK,6
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 12h,999,20h,20,90000h,TGT_CHEST,20,50,0
	WL	3,U2NM3A+FR4
	.word	ANI_ATTACK_ON, AMODE_KNEE,8,31,46,32	;mode,x,y,w,h
	WL	3,U2NM3A+FR5
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-48000h,#no_hit
	WL	ANI_SET_YVEL,50000h
	WLW	ANI_SET_ZVEL,8000h,AM_ABS
	WL	1,U2NM3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#cont
#no_hit
	WL	ANI_IFNOTSTATUS,#nodrft
	WLW	ANI_SET_ZVEL,10000h,AM_ABS
#nodrft
	WL	0ch,U2NM3A+FR5
	.word	ANI_ZERO_XZVELS
	WL	1,U2NM3A+FR5
	.word	ANI_WAITHITGND
#cont
	WL	3,U2NM3A+FR6
	WL	3,U2NM3A+FR7
	WL	3,U2NM3A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 KNEE

 SUBR	und_4_knee_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,U4NM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KICK,6

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 12h,999,20h,20,90000h,TGT_CHEST,20,50,0
	WL	3,U4NM3A+FR3
	.word	ANI_ATTACK_ON, AMODE_KNEE,8,31,46,32	;mode,x,y,w,h
#cont0	WL	3,U4NM3A+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-48000h,#no_hit2
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_ZVEL,-10000h,AM_ABS
	WL	1,U4NM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#cont2
#no_hit2
	WL	ANI_IFNOTSTATUS,#nodrft2
	WLW	ANI_SET_ZVEL,-10000h,AM_ABS
#nodrft2
	WL	0ch,U4NM3A+FR4
	.word	ANI_ZERO_XZVELS
	WL	1,U4NM3A+FR4
	.word	ANI_WAITHITGND
#cont2
	WL	3,U4NM3A+FR5
	WL	3,U4NM3A+FR6
	WL	3,U4NM3A+FR7
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	und_4_knee_fall_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_KICK,6
	WL	3,U4NM3A+FR2

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 12h,999,20h,20,90000h,TGT_CHEST,20,50,0
	WL	3,U4NM3A+FR3
	.word	ANI_ATTACK_ON, AMODE_BIGKNEE,8,31,46,32	;mode,x,y,w,h
	WL	ANI_GOTO,#cont0

 SUBR	und_4_knee_butts_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_CLR_BUTCOUNT
	.word	ANI_SETWORD,USR_VAR2,0

	WL	ANI_SET_YVEL,30000h
	WLW	ANI_SET_XVEL,10000h,AM_FACE_REL
	.word	ANI_OFFSET,0,0,-10			;x,y,z

	WL	2,U4NM3A+FR2
	WL	2,U4NM3A+FR3
	.word	ANI_ATTACK_ON, AMODE_HEADKNEES,8,31,46,32	;mode,x,y,w,h
	WL	2,U4NM3A+FR4
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	WL	3,U4NM3A+FR4
	WL	3,U4NM3A+FR5
	WL	3,U4NM3A+FR6
	WL	3,U4NM3A+FR7

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#exit2

;Now try consecutive head butts

	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_SET_RPTCOUNT,3	;rpt 2 times
	.word	ANI_ZERO_XZVELS
#rpt
	.word	ANI_CLR_BUTCOUNT
	WL	2,U4BC3A+FR1
	WL	1,U4BC3A+FR2
	WL	2,U4BC3A+FR3
	WL	1,U4BC3A+FR4
	WL	2,U4BC3A+FR5
	.word	ANI_SOUND,43H
	.word	ANI_ATTACK_ON, AMODE_HDBUTT2,-8,63,73,56	;mode,x,y,w,h
	WL	2,U4BC3A+FR6
	.word	ANI_ATTACK_OFF
	.word	ANI_ZEROVELS
	WL	ANI_IFNOTSTATUS,#missed0
	WL	2,U4BC3A+FR7
	WL	2,U4BC3A+FR8

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#exit
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#rpt

	.word	ANI_SETWORD,USR_VAR2,1

;Now, 1 last butt, check skick
	.word	ANI_CLR_BUTCOUNT
	WL	2,U4BC3A+FR1
	WL	2,U4BC3A+FR2
	WL	2,U4BC3A+FR3
	WL	2,U4BC3A+FR4
	WL	2,U4BC3A+FR5
	.word	ANI_SOUND,43H
;MJT Start 2
	.word	ANI_ATTACK_ON, AMODE_HDBUTT2,-8,63,73,56	;mode,x,y,w,h
;MJT End 2
	WL	2,U4BC3A+FR6
	.word	ANI_ATTACK_OFF
	.word	ANI_ZEROVELS
	WL	ANI_IFNOTSTATUS,#missed0
	WL	2,U4BC3A+FR7
	WL	2,U4BC3A+FR8

;Try reading other buttons here...
	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#next1
	.ref	und_neckbreaker_anim
	WL	ANI_CHANGEANIM,und_neckbreaker_anim
#next1
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#exit0
	.ref	und_tombstone_anim
	WL	ANI_CHANGEANIM,und_tombstone_anim

#exit0
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed0
	WL	2,U4BC3A+FR7
	WL	2,U4BC3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#exit
#missed
	.word	ANI_DETACH

	WL	3,U4NM3A+FR4
	WL	3,U4NM3A+FR5
	WL	3,U4NM3A+FR6
	WL	3,U4NM3A+FR7

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#exit2
	.word	ANI_DETACH	;From just a knee!

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* GRAB & FLING OPPONENT (INTO A RUN)

 SUBR	und_2_grabfling_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_STARTATTACK,AT_PUPPET,6
	WL	2,U1TT5A+FR2
	WL	2,U1TT5A+FR3
	WL	2,U1TT5A+FR4
	WL	ANI_GOTO,#cont

 SUBR	und_4_grabfling_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
#cont
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,40,0,25
	.word	ANI_STARTATTACK,AT_PUPPET,6
	WL	ANI_SET_YVEL,0000h
	WL	4,U4GF3A+FR1
	.word	ANI_ATTACK_ON, AMODE_PUPPET,19,68,80,16 ;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,4,U4GF3A+FR2
;	WL	4,U4GF3A+FR2
	.word	ANI_ZERO_XZVELS
	WWL	ANI_WAITHITOPP,4,U4GF3A+FR3
;	WL	4,U4GF3A+FR3
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker
;got him
	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

; attacker sequence
	WWLLW	ANI_SUPERSLAVE2,10,U4GF3A+FR3,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,6,U4GF3A+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,U4GF3A+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,U4GF3A+FR6,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,U4GF3A+FR7,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,U4GF3A+FR8,#puppet_tbl,5

	WL	ANI_SLAVEANIM,#strt_run_tbl

	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_DETACH
	WL	13,U4GF3A+FR8
	.word	ANI_OFFSET,-10,0,0			;x,y,z

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WL	25,U4GF3A+FR4
#missed
	.ref	CALL_MISSES
	WL	ANI_CODE,CALL_MISSES
	WL	8,U4GF3A+FR4
	WL	4,U4GF3A+FR3
	WL	4,U4GF3A+FR2
	WL	4,U4GF3A+FR1

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
	.ref	D4YR3B,D3RN3B
	.ref	Y4YR3A,Y3RN3C
	.ref	S4YR3A,S3RN3A
	.ref	B4YR3A,B3RN3A
	.ref	L4YR3B,L3RN3B

#Bret
 LWWW H4YR3A+FR1,61,-4,1
 LWWW H4YR3A+FR2,54,-1,1
 LWWW H4YR3A+FR3,63,2,1
 LWWW H4YR3A+FR5,49,-1,1
 LWWW H3RN3A+FR1,-6,-10,0
 LWWW H3RN3A+FR2,4,-7,0
#Razor
 LWWW R4YR3A+FR1,48,6,0
 LWWW R4YR3A+FR2,37,9,0
 LWWW R4YR3A+FR3,33,6,0
 LWWW R4YR3A+FR4,9,-1,0
 LWWW R3RN3D+FR10,0,1,0
 LWWW R3RN3D+FR11,7,4,0
#Taker
 LWWW U4YR3B+FR2,40,9,0
 LWWW U4YR3B+FR3,51,5,0
 LWWW U4YR3B+FR4,32,6,0
 LWWW U4YR3B+FR5,-3,4,0
 LWWW U3RN3A+FR1,-8,2,0
 LWWW U3RN3A+FR2,-42,0,0
#Yokozuna
 LWWW Y4YR3A+FR1,63,-3,1
 LWWW Y4YR3A+FR4,34,-1,1
 LWWW Y4YR3A+FR5,29,6,1
 LWWW Y4YR3A+FR7,19,1,1
 LWWW Y3RN3C+FR7,29,4,0
 LWWW Y3RN3C+FR8,4,-1,0
#Shawn
 LWWW S4YR3A+FR2,36,-7,1
 LWWW S4YR3A+FR3,45,-13,1
 LWWW S4YR3A+FR5,28,2,1
 LWWW S4YR3A+FR6,8,-5,1
 LWWW S3RN3A+FR2,-3,-4,0
 LWWW S3RN3A+FR3,0,0,0
#BamBam
 LWWW B4YR3A+FR3,43,1,0
 LWWW B4YR3A+FR4,50,-2,0
 LWWW B4YR3A+FR5,63,3,0
 LWWW B4YR3A+FR7,10,-9,0
 LWWW B3RN3A+FR1,10,0,0
 LWWW B3RN3A+FR2,0,5,0
#Doink
 LWWW D4YR3B+FR1,61,-2,1
 LWWW D4YR3B+FR2,50,3,1
 LWWW D4YR3B+FR3,53,6,1
 LWWW D4YR3B+FR4,36,1,1
 LWWW D3RN3B+FR3,6,-1,0
 LWWW D3RN3B+FR4,-2,0,0
#Adam
 .long 0
#Lex
 LWWW L4YR3B+FR1,77,3,1
 LWWW L4YR3B+FR2,58,-1,1
 LWWW L4YR3B+FR3,47,6,1
 LWWW L4YR3B+FR4,5,-3,1
 LWWW L3RN3B+FR2,-1,4,0
 LWWW L3RN3B+FR3,17,-1,0


#strt_run_tbl
	.ref	start_run_flung

	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung

#*****************************************************************************
*
* #2 HEAD HIT

 SUBR	und_2_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	4,U2AH3A+FR3
	WL	6,U2AH3A+FR4
	WL	4,U2AH3A+FR5
	WL	3,U2AH3A+FR6
	WL	3,U2AH3A+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 HEAD HIT

 SUBR	und_4_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	4,U4AH3A+FR2
	WL	4,U4AH3A+FR3
	WL	4,U4AH3A+FR4
	WL	4,U4AH3A+FR5
	WL	4,U4AH3A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #2 HEAD HIT - From spin kick & backhand slap

 SUBR	und_2_head_hit2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,40000h

	WL	3,U2AH3A+FR3
	WL	3,U2AH3A+FR4
	WL	1,U2AH3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,U2AH3A+FR6
	WL	3,U2AH3A+FR7

;Try auto push here!
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 HEAD HIT - From spin kick & backhand slap

 SUBR	und_4_head_hit2_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-20000h,AM_ABS
	WL	ANI_SET_YVEL,40000h

	WL	3,U4AH3A+FR2
	WL	3,U4AH3A+FR3
	WL	1,U4AH3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,U4AH3A+FR5
	WL	3,U4AH3A+FR6

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************

 SUBR	und_4_head_hit4_anim

;From earslap
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
;	WLW	ANI_SET_ZVEL,-20000h,AM_ABS
	WL	ANI_SET_YVEL,40000h

	WL	4,U4AH3A+FR4
;	.word	ANI_WAITHITGND
;	.word	ANI_ZEROVELS
	WL	4,U4AH3A+FR5
	WL	4,U4AH3A+FR6
	.word	ANI_WAITHITGND

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* HEAD HIT2 (HANDS ON FACE)

 SUBR	und_head_hit2_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,28000h
	WLW	ANI_SET_XVEL,-40000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h

	WL	4,U3AE4A+FR1
	WL	10,U3AE4A+FR2
	WL	4,U3AE4A+FR3
	WL	4,U3AE4A+FR4
	WL	4,U3AE4A+FR5
	WL	4,U3AE4A+FR6
	WL	4,U3AE4A+FR7
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


* HEAD HIT2 (ENDS IN DIZZY)

 SUBR	und_head_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,38000h
	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	4,U3AE4A+FR1
	WL	10,U3AE4A+FR2
	WL	4,U3AE4A+FR3
	WL	4,U3AE4A+FR4
	WL	4,U3AE4A+FR5
	WL	4,U3AE4A+FR6
	WL	4,U3AE4A+FR7

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,und_dizzy_anim
	.word	ANI_END


#*****************************************************************************
*
* #2 BODY HIT

 SUBR	und_2_body_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL

	.ref	ckzpos
	WL	ANI_CODE,ckzpos
	WL	1,U2AM2A+FR2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,U2AM2A+FR3
	WL	3,U2AM2A+FR4
	WL	3,U2AM2A+FR5
	WL	3,U2AM2A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 BODY HIT

 SUBR	und_4_body_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL

	.ref	ckzpos
	WL	ANI_CODE,ckzpos
	WL	3,U4AM4C+FR2
	WL	1,U4AM4C+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,U4AM4C+FR4
	WL	3,U4AM4C+FR5
	WL	3,U4AM4C+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


* #2 BODY HIT BY KNEE

 SUBR	und_2_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,04000h,AM_ABS

	.ref	ckzpos
	WL	ANI_CODE,ckzpos
	WL	1,U2AM2A+FR2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,U2AM2A+FR3
	WL	3,U2AM2A+FR4
	WL	3,U2AM2A+FR5
	WL	3,U2AM2A+FR6

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 BODY HIT BY KNEE

 SUBR	und_4_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-04000h,AM_ABS

	.ref	ckzpos
	WL	ANI_CODE,ckzpos
	WL	3,U4AM4C+FR2
	WL	1,U4AM4C+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,U4AM4C+FR4
	WL	3,U4AM4C+FR5
	WL	3,U4AM4C+FR6

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	und_4_knee_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	.ref	ckzpos
	WL	ANI_CODE,ckzpos
	WL	3,U4AM4C+FR2
	WL	1,U4AM4C+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,U4AM4C+FR4
	WL	3,U4AM4C+FR5
	WL	3,U4AM4C+FR6

	.word	ANI_FACEDOWN
;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,und_dizzy_anim
	.word	ANI_END

 SUBR	und_quick_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h

	WL	3,U4AM4C+FR2
	WL	3,U4AM4C+FR3
	WL	3,U4AM4C+FR4
	WL	3,U4AM4C+FR5
	WL	3,U4AM4C+FR6

	.word	ANI_FACEDOWN

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,und_fall_back_anim
	.word	ANI_END

#nodead



	.ref	und_3_head_held_anim
	WL	ANI_CHANGEANIM,und_3_head_held_anim

	.word	ANI_END

* #4 BODY HIT - While I was dizzy

 SUBR	und_4_body_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	.ref	ckzpos
	WL	ANI_CODE,ckzpos
	WL	3,U4AM4C+FR2
	WL	1,U4AM4C+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,U4AM4C+FR4
	WL	3,U4AM4C+FR5
	WL	3,U4AM4C+FR6

	.word	ANI_FACEDOWN
;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,und_dizzy_anim
	.word	ANI_END


#*****************************************************************************
*
* HITS ON GROUND

 SUBR	und_hitonground_xflip_anim
	.word	ANI_XFLIP
	;fall through

 SUBR	und_hitonground_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h

	WL	1,U3CP3B+FR2
	.word	ANI_DEBRIS,50,1,0,8,0		;%chance, tbl index, x,y,z off
	WL	ANI_SET_YVEL,39000h
	WL	3,U3CP3B+FR2
	WL	4,U3CP3B+FR3
	WL	4,U3CP3B+FR4
	WL	4,U3CP3B+FR5

	WL	4,U3CP3B+FR6
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS

	WL	4,U3CP3B+FR7

	WL	1,U3CP3B+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,und_getup_anim

#*****************************************************************************
*
* FALL BACK

 SUBR	und_fall_back_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;	WL	ANI_CODE,am_I_dead
;If I'm dead, don't go up into air
;	WL	ANI_IFSTATUS,#dead
	WL	ANI_SET_YVEL,60000h
;#dead
	WL	ANI_CODE,ckzpos

	WWL	ANI_SETLONG,DEBRIS_X,[104,2]	;Y,X of head
	WL	3,U3FD3B+FR1
	WWL	ANI_SETLONG,DEBRIS_X,[104,-24]	;Y,X of head
	WL	3,U3FD3B+FR2

	.word	ANI_OFFSET,0,53,0			;x,y,z

	WWL	ANI_SETLONG,DEBRIS_X,[50,-20]	;Y,X of head
	WL	3,U3FD3B+FR3
	WWL	ANI_SETLONG,DEBRIS_X,[43,-26]	;Y,X of head
	WL	3,U3FD3B+FR4
	WWL	ANI_SETLONG,DEBRIS_X,[32,-41]	;Y,X of head
	WL	2,U3FD3B+FR5
	.word	ANI_WAITHITGND

	.word	ANI_DEBRIS,100,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,25
	.word	ANI_FRICTION,3000h

	WWL	ANI_SETLONG,DEBRIS_X,[8,-51]	;Y,X of head
	WL	2,U3FD3B+FR6
	.word	ANI_BOUNCE,4
	WWL	ANI_SETLONG,DEBRIS_X,[9,-53]	;Y,X of head
	WL	2,U3FD3B+FR7
	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_SOUND,bounce_l1
	.word	ANI_ZEROVELS
	WWL	ANI_SETLONG,DEBRIS_X,0		;Y,X of head

	.word	ANI_XFLIP
	WL	3,U3CP3B+FR1	;1st frame of roll

;Now, also check to see if this made him dizzy

;Stay on ground for awhile...  Maybe this will be table driven
	WL	3,U3CP3B+FR1	;1st frame of roll
;#done
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,und_getup_anim

#*****************************************************************************
*
* FALL BACK

;From clothesline

 SUBR	und_fall_back2_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,10000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS
	WL	ANI_CODE,ckzpos

	.word	ANI_XFLIP
	WL	3,U3FD3X+FR1
	WL	3,U3FD3X+FR2

	.word	ANI_OFFSET,0,49,0			;x,y,z

	WL	3,U3FD3X+FR3
	WL	3,U3FD3X+FR4
	WL	3,U3FD3X+FR5
	WL	3,U3FD3X+FR6
	.word	ANI_WAITHITGND

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,35
	.word	ANI_ZEROVELS		
	WLW	ANI_SET_ZVEL,18000h,AM_ABS
	WLW	ANI_SET_XVEL,-40000h,AM_FACE_REL

	.word	ANI_OFFSET,-20,0,0			;x,y,z

	WL	3,U3GP3X+FR1
	WL	3,U3GP3X+FR2
	WL	3,U3GP3X+FR3
	WL	3,U3GP3X+FR4
	WL	3,U3GP3X+FR5
	WL	3,U3GP3X+FR6
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_ZEROVELS		
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!

	.word	ANI_XFLIP
	.word	ANI_OFFSET,-20,0,0			;x,y,z
	WL	4,U3CF3Q+FR1
	WL	4,U3CF3Q+FR2
	WL	4,U3CF3Q+FR3
	WL	4,U3CF3Q+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	WL	15,U3GD2A+FR1

	WL	4,U3GD2A+FR1
	WL	4,U3GD2A+FR2
	WL	4,U3GD2A+FR3
	WL	4,U3GD2A+FR4

	WL	ANI_CODE,choose_2or4
	WL	ANI_IFSTATUS,#getup_in_4

	WL	4,U3GD2A+FR5
	WL	4,U3GD2A+FR6
	WL	4,U3GD2A+FR7
	WL	2,U3GD2A+FR8
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,U3GD2A+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#getup_in_4
	WL	4,U3GD4A+FR5
	WL	4,U3GD4A+FR6
	WL	4,U3GD4A+FR7
	WL	2,U3GD4A+FR8
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,U3GD4A+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* FALL FROM TURNBUCKLE

 SUBR	und_fall_back_tbukl_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETSPEED,100h

	WL	3,U3FD3B+FR1
	WL	3,U3FD3B+FR2

	.word	ANI_OFFSET,0,53,0			;x,y,z

	WL	3,U3FD3B+FR3
	WL	3,U3FD3B+FR4
	WL	2,U3FD3B+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_DAMAGE,D_HITCONCRETE

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,25
;	.word	ANI_FRICTION,3000h

	WL	2,U3FD3B+FR6
;	.word	ANI_BOUNCE,4
	WL	2,U3FD3B+FR7
;	.word	ANI_WAITHITGND
;	WL	ANI_CODE,SMALL_BOUNCE
;	.word	ANI_SOUND,bounce_l1
;	.word	ANI_ZEROVELS

	.word	ANI_XFLIP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	WL	3,U3CP3B+FR1	;1st frame of roll

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,und_getup_anim


#*****************************************************************************
*

 SUBR	und_faceup_getup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	.word	ANI_CLR_STARS
	.word	ANI_CLR_DAMAGE

;;;	WL	4,U3SU3A+FR1
	WL	4,U3SU3A+FR2
	WL	4,U3SU3A+FR3
	WL	4,U3SU3A+FR4
	WL	4,U3SU3A+FR5

	WL	4,U3SU3A+FR6

;;;	WL	60+4,U3SU3A+FR6

	.ref	choose_2or4
	WL	ANI_CODE,choose_2or4
	WL	ANI_IFSTATUS,#getup_in_4


	WL	4,U3SU2B+FR1
	WL	4,U3SU2B+FR2
	WL	4,U3SU2B+FR3
	WL	4,U3SU2B+FR4
	WL	4,U3SU2B+FR5
	WL	4,U3SU2B+FR6
	WL	2,U3SU2B+FR7
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,U3SU2B+FR7
	WL	4,U3SU2B+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#getup_in_4
	WL	4,U3SU3A+FR7
	WL	4,U3SU3A+FR8

	WL	4,U3SU4A+FR1
	WL	4,U3SU4A+FR2
	WL	4,U3SU4A+FR3
	WL	4,U3SU4A+FR4
	WL	4,U3SU4A+FR5
	WL	4,U3SU4A+FR6
	WL	2,U3SU4A+FR7
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,U3SU4A+FR7

	WL	4,U3SU4A+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*

 SUBR	und_getup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	.word	ANI_CLR_STARS
	.word	ANI_CLR_DAMAGE

	WL	4,U3SU3A+FR1
	WL	4,U3SU3A+FR2
	WL	4,U3SU3A+FR3
	WL	4,U3SU3A+FR4
	WL	4,U3SU3A+FR5
	WL	4,U3SU3A+FR6

;;;	WL	60+4,U3SU3A+FR6
	WL	ANI_GOTO,#common

;getup from seated position

 SUBR	und_getup2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	.word	ANI_CLR_STARS
	.word	ANI_CLR_DAMAGE

#common
	.ref	choose_2or4
	WL	ANI_CODE,choose_2or4
	WL	ANI_IFSTATUS,#getup_in_4

	WL	4,U3SU2B+FR1
	WL	4,U3SU2B+FR2
	WL	4,U3SU2B+FR3
	WL	4,U3SU2B+FR4
	WL	4,U3SU2B+FR5
	WL	4,U3SU2B+FR6
	WL	2,U3SU2B+FR7
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,U3SU2B+FR7
	WL	4,U3SU2B+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#getup_in_4
	WL	4,U3SU3A+FR7
	WL	4,U3SU3A+FR8

	WL	4,U3SU4A+FR1
	WL	4,U3SU4A+FR2
	WL	4,U3SU4A+FR3
	WL	4,U3SU4A+FR4
	WL	4,U3SU4A+FR5
	WL	4,U3SU4A+FR6
	WL	2,U3SU4A+FR7
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,U3SU4A+FR7
	WL	4,U3SU4A+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* DIZZY

 SUBR	und_dizzy_anim

	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_START_DIZZY,0	;0=Standing dizzy
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

#loop

	WL	10,U4TI4C+FR1
	WL	10,U4TI4C+FR3
	WL	10,U4TI4C+FR5
	WL	10,U4TI4C+FR7
	WL	10,U4TI4C+FR5
	WL	10,U4TI4C+FR3

	WL	ANI_GOTO,#loop


#*****************************************************************************
*
* #2 BLOCK

 SUBR	und_2_block_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZERO_XZVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
;Rotate toward opponent if needed!
	.word	ANI_SETPLYRMODE,MODE_BLOCK

	WL	3,U2BK3A+FR1
	WL	3,U2BK3A+FR2
#blk2	WL	3,U2BK3A+FR3
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
	WL	3,U2BK3A+FR2
	WL	3,U2BK3A+FR1
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	und_2_hitblock_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_FRICTION,3000h
	.word	ANI_SETSPEED,100h

	WL	4,U2BK3A+FR4
	WL	4,U2BK3A+FR5
	WL	ANI_GOTO,#blk2


* #4 BLOCK

 SUBR	und_4_block_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZERO_XZVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
;Rotate toward opponent if needed!

	.word	ANI_SETPLYRMODE,MODE_BLOCK
	WL	3,U4BK3C+FR1
	WL	3,U4BK3C+FR2
#blk4	WL	3,U4BK3C+FR3
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
	WL	3,U4BK3C+FR2
	WL	3,U4BK3C+FR1
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	und_4_hitblock_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_FRICTION,3000h
	.word	ANI_SETSPEED,100h
	WL	4,U4BK3C+FR5
	WL	4,U4BK3C+FR6
	WL	ANI_GOTO,#blk4

#*****************************************************************************
*
* THROWN FROM RING (shn_bslm, shn_frnk)

 SUBR	und_flyout_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETSPEED,100h

	WL	8,U3FH3A+FR3
	WL	8,U3FH3A+FR4
	WL	1,U3FH3A+FR5
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,60
	.word	ANI_OFFSET,48,0,0

	.word	ANI_DAMAGE,D_HIPTOSS
	.word	ANI_SETWORD,DELAY_METER,0
	.word	ANI_GETUP,500

	WL	ANI_CHANGEANIM,und_hitonground_anim

;MJT Start 2
#****************************************************************************
*
* PIN OPPONENT AND RAISE ARM IN VICTORY

;Need to have this guy walk toward fallen opponent so he
;can get closer!

;This pin must be started only when opponent is on the ground!

;Jamie, taker needs to be above fallen opponent.  His hand should
;end up laying across opponents chest area.  Not below it!

 SUBR	und_2_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;Rotate!
	WL	2,U1TT5A+FR2
	WL	2,U1TT5A+FR3
	WL	2,U1TT5A+FR4
	WL	ANI_GOTO,#cont

 SUBR	und_4_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

#cont
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 25,999,80h,50h,90000h,TGT_CHEST,0,57,20

	WL	4,U5PN5A+FR1
	.word	ANI_OFFSET,0,15,0			;x,y,z
	WL	18,U5PN5A+FR2
	.word	ANI_ATTACK_ON_Z, AMODE_STOMP,-40,-8,0,76,20,30 ;mode,x,y,z,w,h,d
	.word	ANI_ZEROVELS

	WL	3,U5PN5A+FR3
;	WL	3,U5PN5A+FR4
;	.word	ANI_OFFSET,0,0,25			;x,y,z
	.word	ANI_SET_ATTACH
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_ATTACHZ,0,0,-5		;x & y don't matter.
	WL	3,U5PN5A+FR6
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_DETACH
	WL	3,U5PN5A+FR5

	.word	ANI_ATTACK_OFF
	WL	ANI_CODE,HIT_THE_MAT

	WL	ANI_CODE,DO_CROWD_CHEER

	.word	ANI_BOUNCE,4
	WL	4,U5PN5A+FR6
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE

	WL	4,U5PN5A+FR6
	WL	ANI_CODE,win_announce
	WL	40,U5PN5A+FR6

	.word	ANI_LOOP

;Do another ground hit on opponent
	WL	ANI_CODE,grnd_hit

	WL	ANI_SET_YVEL,42000h
	WLW	ANI_SET_ZVEL,22000h,AM_ABS
	WL	3,U5PN5A+FR5
	WL	3,U5PN5A+FR4
	WL	3,U5PN5A+FR3
	WL	3,U5PN5A+FR2
	WL	3,U5PN5A+FR1
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#cont2


 SUBR	und_4_pin2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	5,U3PN5A+FR1
	WL	5,U3PN5A+FR2
	WL	5,U3PN5A+FR3
	WL	5,U3PN5A+FR4
	WL	5,U3PN5A+FR5
	WL	5,U3PN5A+FR6
	WL	5,U3PN5A+FR7
	WL	5,U3PN5A+FR8

	.ref	create_impact5
	WL	ANI_CODE,create_impact5

;Do a ground hit on opponent
	.ref	grnd_hit
	WL	ANI_CODE,grnd_hit
	WLW	ANI_ATTCHIMAGE,UARMPN+FR9,1	;image, zoff (priority)

	WL	ANI_CODE,DO_CROWD_CHEER

	WL	25,U3PN5A+FR9
	.word	ANI_DEBRIS,1000,7,0,8,0		;%chance, tbl index, x,y,z off
	WL	65,U3PN5A+FR9
	.ref	win_announce
	WL	ANI_CODE,win_announce

	.word	ANI_LOOP

	WLW	ANI_ATTCHIMAGE,0,0		;Turn it off
	WL	3,U3PN5A+FR11
	WL	3,U3PN5A+FR12

#cont2
;Place spirits around Undertaker as he stands up!

	WL	3,U5RV5A+FR1
	WL	3,U5RV5A+FR2
	WL	3,U5RV5A+FR3
	WL	3,U5RV5A+FR4
	WL	3,U5RV5A+FR5

	WL	1000,U5RV5A+FR6

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


;MJT End 2
#*****************************************************************************

 SUBR	und_roll_frames

	.word	7		;speed
	.long	50000h		;z velocity
	.long	10000h*11/255	;inv multiply (0-255 -> 0-11)

	.long	U3CP3B+FR1	;0
	.long	U3CR3A+FR12	;1
	.long	U3CR3A+FR11	;2
	.long	U3CR3A+FR10	;3
	.long	U3CR3A+FR9	;4
	.long	U3CR3A+FR8	;5
	.long	U3CR3A+FR7	;6
	.long	U3CR3A+FR6	;7
	.long	U3CR3A+FR5	;8
	.long	U3CR3A+FR4	;9
	.long	U3CR3A+FR3	;10
	.long	U3CR3A+FR2	;11
	.long	0,0,0,0,0,0


#*****************************************************************************
*
* #3 FLYING KICK

 SUBR	und_flying_kick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h

	WL	3,U3DC3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.ref	get_leap
	WL	ANI_CODE,get_leap
	WL	ANI_IFSTATUS,#no_xvel

	WL	3,U3DC3A+FR2

;	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 19,999,150,65,90000h,TGT_HEAD,30,100,0
	.word	ANI_STARTATTACK,AT_LEAPING,21

	WL	ANI_GOTO,#cont

#no_xvel
	.word	ANI_ZEROVELS

	WL	3,U3DC3A+FR2
	WL	ANI_SET_YVEL,64000h
#cont
	WL	3,U3DC3A+FR3
	WL	4,U3DC3A+FR4

	.word	ANI_OFFSET,0,38,0			;x,y,z
	WL	7,U3DC3A+FR5

	.word	ANI_CLR_STATUS

	.word	ANI_ATTACK_ON, AMODE_FLYKICK,57,21,37,44 ;mode,x,y,w,h
	WL	3,U3DC3A+FR6
	.word	ANI_ATTACK_OFF
	WL	4,U3DC3A+FR6
	WL	4,U3DC3A+FR7

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT
	WL	4,U3DC3A+FR8

	WL	ANI_IFSTATUS,#got
;Missed him
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_BOUNCE,3
	.word	ANI_SOUND,bounce_l1
	WL	3,U3DC3A+FR8
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	WL	3,U3DC3A+FR8
	
#got
	WL	3,U3DC3A+FR8
#cont2
	WL	3,U3DC3A+FR8

	.word	ANI_XFLIP
	.word	ANI_OFFSET,5,0,0			;x,y,z

	WL	3,U3GD2A+FR1
	WL	3,U3GD2A+FR2
	WL	3,U3GD2A+FR3
	WL	3,U3GD2A+FR4


	WL	ANI_CODE,choose_2or4
	WL	ANI_IFSTATUS,#getup_in_4

	WL	3,U3GD2A+FR5
	WL	3,U3GD2A+FR6
	WL	3,U3GD2A+FR7
	WL	1,U3GD2A+FR8
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,U3GD2A+FR8
	.word	ANI_SAFE_TIME,15

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#getup_in_4
	WL	3,U3GD4A+FR5
	WL	3,U3GD4A+FR6
	WL	3,U3GD4A+FR7
	WL	1,U3GD4A+FR8
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,U3GD4A+FR8
	.word	ANI_SAFE_TIME,15

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


	.ref	HIT_THE_MAT,SMALL_BOUNCE
	.ref	ck_dizzy,ckzpos

;FIX!!  Make throw out of ring if close to ropes
#*****************************************************************************
*
* FLIP/FALL FROM HIPTOSS

 SUBR	und_tossed_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

;	.word	ANI_XFLIP

	WL	ANI_CODE,ckzpos

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_GETUP,300
	WL	ANI_CODE,HIT_THE_MAT
	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,50000h
	WL	4,U3CP3B+FR2
	WL	4,U3CP3B+FR3
	WL	4,U3CP3B+FR4
	WL	4,U3CP3B+FR5

	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,U3CP3B+FR1	;1st frame of roll

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,und_getup_anim
	.word	ANI_END

;FIX!!  Make throw out of ring if close to ropes
#*****************************************************************************
*
* FLIP/FALL FROM BAM BAM DUCK TOSS

 SUBR	und_tossed2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,ckzpos

	WLW	ANI_SET_XVEL,60000h,AM_HIT_REL
	WL	ANI_SET_YVEL,30000h
	.word	ANI_OFFSET,20,20,0			;x,y,z
	WL	4,U3FH3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_GETUP,300
	.word	ANI_DAMAGE,D_HIPTOSS

	WL	4,U3FH3A+FR4
	.word	ANI_OFFSET,23h,0,0			;x,y,z
	WL	3,U3CP3B+FR1

	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,50000h
	WL	4,U3CP3B+FR2
	WL	4,U3CP3B+FR3
	WL	4,U3CP3B+FR4
	WL	4,U3CP3B+FR5

	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,U3CP3B+FR1	;1st frame of roll

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,und_getup_anim
	.word	ANI_END

#*****************************************************************************
*

 SUBR	und_knockdwn_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h
	.word	ANI_XFLIP
 

	WL	2,U3GD2A+FR7
	WL	2,U3GD2A+FR5
	WL	2,U3GD2A+FR3
	WL	ANI_SET_YVEL,39000h

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off
	WL	4,U3CP3B+FR2
	WL	4,U3CP3B+FR3
	WL	4,U3CP3B+FR4
	WL	4,U3CP3B+FR5
	WL	4,U3CP3B+FR1

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	.word	ANI_SETPLYRMODE,MODE_DEAD
	.word	ANI_END

#nodead

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,und_getup_anim


#*****************************************************************************
 SUBR	und_climbthru_side_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH

	WLW	ANI_SET_XVEL,4000h,AM_FACE_REL

	.word	ANI_OFFSET,16,0,0
	WL	4,U3CR3B+FR1
	.word	ANI_BENDROPE,5
	.word	ANI_OFFSET,7,0,0	;*****
	WL	4,U3CR3B+FR2
	.word	ANI_OFFSET,7,0,0	;*****
	WL	4,U3CR3B+FR3		
	.word	ANI_OFFSET,7,0,0	;*****
	WL	4,U3CR3B+FR4

	.word	ANI_OFFSET,7,0,0	;*****
	WL	4,U3CR3B+FR5

	.word	ANI_ZEROVELS
	.word	ANI_OFFSET,7,0,0	;*****
	WL	4,U3CR3B+FR6
	.word	ANI_OFFSET,7,0,0	;*****
	WL	4,U3CR3B+FR7
	.word	ANI_OFFSET,7,0,0	;*****
	WL	4,U3CR3B+FR8
	.word	ANI_OFFSET,5,0,0	;*****
	WL	4,U3CR3B+FR9
	WL	4,U3CR3B+FR10
	.word	ANI_BENDROPE,-1
	.word	ANI_OFFSET,0,-3,0

	;now jump off...
	WL	4,U4JD4A+FR1		;D4FM4A+FR1
	WL	4,U4JD4A+FR2
	WL	3,U4JD4A+FR3

	WL	ANI_SET_YVEL,60000h

	WLW	ANI_SET_XVEL,30000h,AM_FACE_REL

	WL	3,U4JD4A+FR4
	.word	ANI_WAITHITGND

	.word	ANI_ROPE_Z,R_TOP,RZ_NORM
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM

	.word	ANI_ZEROVELS
	WL	3,U4JD4A+FR6
	WL	3,U4JD4A+FR7
	WL	6,U4JD4A+FR8

	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	und_climbin_side_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	ANI_CODE,SET_DIR_FACE
	.word	ANI_SETFACING
	.WORD	ANI_SET_WRESTLER_XFLIP

	;jump in
	WL	4,U4JD4A+FR1
	WL	4,U4JD4A+FR2

	WL	ANI_CODE,#set_trgt
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	.word	ANI_LEAPATPOS,1ch,200,0,0,0	;#ticks,dist,xoff,yoff,zoff

	WL	4,U4JD4A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WLW	ANI_SET_XVEL,2000h,AM_FACE_REL

	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH

	WL	4,U4JD4A+FR6
	WL	3,U4JD4A+FR7
	WL	3,U4JD4A+FR8

	WL	ANI_CODE,#set_z

	;climb through
	.word	ANI_OFFSET,7,0,0	;*****
	WL	3,U3CR3B+FR1
	.word	ANI_OFFSET,7,0,0	;*****
	WL	3,U3CR3B+FR2
	.word	ANI_BENDROPE,5
	.word	ANI_OFFSET,7,0,0	;*****
	WL	3,U3CR3B+FR3
	.word	ANI_OFFSET,7,0,0	;*****
	WL	3,U3CR3B+FR4
	.word	ANI_OFFSET,7,0,0	;*****
	WL	3,U3CR3B+FR5
	.word	ANI_OFFSET,7,0,0	;*****
	WL	3,U3CR3B+FR6
	.word	ANI_OFFSET,7,0,0	;*****
	WL	3,U3CR3B+FR7
	.word	ANI_OFFSET,7,0,0	;*****
	WL	3,U3CR3B+FR8
	.word	ANI_OFFSET,7,0,0	;*****
	WL	3,U3CR3B+FR9
	.word	ANI_ZEROVELS
	.word	ANI_BENDROPE,-1
	.word	ANI_OFFSET,7,-3,0
	WL	3,U3CR3B+FR10

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
 SUBR	und_climbthru_bot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

;Must rotate toward ropes!
;Do a different sequence

	;lie down
	WL	ANI_CODE,#ckspin

	WL	4,U3GD2A+FR7
	WL	4,U3GD2A+FR6
	WL	4,U3GD2A+FR5
	WL	4,U3GD2A+FR4
	WL	4,U3GD2A+FR3
	WL	4,U3GD2A+FR2
	WL	4,U3GD2A+FR1

	;roll over once
	WLW	ANI_SET_ZVEL,0a8000h,AM_ABS

	WL	3,U3CR3A+FR6	;0
	WL	3,U3CR3A+FR5	;1
	WL	3,U3CR3A+FR4	;2
	WL	3,U3CR3A+FR3	;3
	WL	3,U3CR3A+FR2	;4
	WL	3,U3CP3B+FR1	;5

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP+MODE_NOSHADOW

	;climb through
	.WORD	ANI_XFLIP
	.word	ANI_OFFSET,0,-16,0			;x,y,z
	WL	3,U3DC3A+FR5
	.word	ANI_OFFSET,0,-32,0
	WL	3,U3DC3A+FR4
	WL	3,U3DC3A+FR3
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


#*****************************************************************************

 SUBR	und_climbin_bot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;climb in
	.word	ANI_GRAVITY_OFF
	.WORD	ANI_XFLIP
	WL	3,U3DC3A+FR3
	WL	3,U3DC3A+FR4
	.word	ANI_OFFSET,0,32,0
	WL	3,U3DC3A+FR5
	.WORD	ANI_XFLIP
	.word	ANI_OFFSET,0,24,-60

	;roll
	WLW	ANI_SET_ZVEL,-70000h,AM_ABS
	.word	ANI_FRICTION,3000h
	WL	3,U3CP3B+FR1	;0
	WL	3,U3CR3A+FR2	;1
	WL	3,U3CR3A+FR3	;2
	WL	3,U3CR3A+FR4	;3
	WL	3,U3CR3A+FR5	;4
	WL	3,U3CR3A+FR6	;5
	.word	ANI_ZEROVELS
	.word	ANI_GRAVITY_ON

	;get up

	WL	ANI_CODE,clr_climb
	WL	ANI_CHANGEANIM,und_getup_anim

#*****************************************************************************

 SUBR	und_climbthru_top_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;lie down
	WL	ANI_CODE,#set_zvel1
	WL	ANI_IFSTATUS,#dir4
;Facing #2
	WL	3,U1TT5A+FR2
	WL	3,U1TT5A+FR3
#dir4
	WL	4,U3GD2A+FR7
	WL	4,U3GD2A+FR6
	WL	4,U3GD2A+FR5
	WL	4,U3GD2A+FR4
	WL	4,U3GD2A+FR3
	WL	4,U3GD2A+FR2
	WL	4,U3GD2A+FR1

	;roll over once
	WL	ANI_CODE,#set_zvel2
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP+MODE_NOSHADOW
	WL	3,U3CR3A+FR8	;2
	WL	3,U3CR3A+FR9	;3
	WL	3,U3CR3A+FR10	;4
	WL	3,U3CR3A+FR11	;4
	WL	3,U3CR3A+FR12	;4

	;climb through
	.word	ANI_OFFSET,0,-61,0
	.word	ANI_ZEROVELS
	WL	3,U4JP4C+FR3
	WL	3,U4JP4C+FR2
	WL	3,U4JP4C+FR1

	.word	ANI_ZERO_XZVELS

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
	movi	-5c000h,a0
	move	a0,*a13(OBJ_ZVEL),L
	rets

#*****************************************************************************

 SUBR	und_climbin_top_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;climb in
	WL	3,U4JP4C+FR1
	WL	3,U4JP4C+FR2
	WL	3,U4JP4C+FR3
	.word	ANI_OFFSET,0,61,0

	;roll over
	WL	ANI_CODE,#set_zvel2
	WL	3,U3CR3A+FR11	;0
	WL	3,U3CR3A+FR10	;1
	WL	3,U3CR3A+FR9	;2
	WL	3,U3CR3A+FR8	;3

	.word	ANI_ZEROVELS

	;get up

	WL	ANI_CODE,clr_climb
	WL	ANI_CHANGEANIM,und_getup_anim


#set_zvel2
	movi	52000h,a0
	move	a0,*a13(OBJ_ZVEL),L
	rets


******************************************************************************
	.end
