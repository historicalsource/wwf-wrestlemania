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

	.file	"hrtseq2.asm"
	.title	"routine punches and kicks"
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

	.include	"bretimg.h"
	.include	"bamimg.h"
	.include	"takerimg.h"	;<---temp!!!
	.include	"doinkimg.h"	;<---temp!!!
	.include	"damage.equ"


******************************************************************************
* EXTERNAL REFERENCES

	.ref	SET_DIR_FACE

	.ref	D4YR3B,D3RN3B
	.ref	H4YR3A,H3RN3A
	.ref	R4YR3A,R3RN3D
	.ref	U4YR3B,U3RN3A
	.ref	Y4YR3A,Y3RN3C
	.ref	S4YR3A,S3RN3A
	.ref	B4YR3A,B3RN3A
	.ref	L4YR3B,L3RN3B

	.ref	start_run_anim,CALL_MISSES,start_run_flung
	.ref	no_bk_xvel,hrt_4_faceup_getup2_anim,check_xvel
	.REF	DO_CROWD_CHEER


******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* #2 NORMAL PUNCH

 SUBR	hrt_2_punch_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	3,H2PL3B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_PUNCH,6

	WL	3,H2PL3B+FR2
	WL	3,H2PL3B+FR3

;	.word	ANI_ATTACK_ON_Z, AMODE_PUNCH,30,91,-45,50,15,45	;mode,x,y,z,w,h,d
;Temp knock down to test hair pickup
;But it is cool to knock somebody down with a punch, figure a way it makes
;sense....
	.word	ANI_ATTACK_ON_Z, AMODE_FLYKICK,30,91,-45,50,15,45	;mode,x,y,z,w,h,d
	WL	3,H2PL3B+FR4
	.word	ANI_ATTACK_OFF
	WL	3,H2PL3B+FR4

;	WL	ANI_IFNOHITBLOCK,#noblock
;	WL	10,H2PL3B+FR4
;#noblock

	WL	3,H2PL3B+FR5
	WL	3,H2PL3B+FR6
	WL	3,H2PL3B+FR7
	WL	3,H2PL3B+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 NORMAL PUNCH

 SUBR	hrt_4_punch_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	3,H4PL3X+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_PUNCH,6
	WL	3,H4PL3X+FR2
	WL	3,H4PL3X+FR3

	.word	ANI_ATTACK_ON_Z, AMODE_PUNCH,30,91,0,50,15,45 ;mode,x,y,z,w,h,d
	WL	3,H4PL3X+FR4
	.word	ANI_ATTACK_OFF
	WL	3,H4PL3X+FR4

;	WL	ANI_IFNOHITBLOCK,#noblock
;	WL	10,H4PL3X+FR4
;#noblock

	WL	3,H4PL3X+FR5
	WL	3,H4PL3X+FR6
	WL	3,H4PL3X+FR7
	WL	3,H4PL3X+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 PUSH

 SUBR	hrt_2_push2_anim		;From head held
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,H3HB3A+FR1
	WLW	ANI_SET_ZVEL,10000h,AM_ABS
	WL	ANI_GOTO,#tag


 SUBR	hrt_2_push_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
#tag
	.word	ANI_STARTATTACK,AT_PUSH,12
	WL	4,H2PS3A+FR1
	WL	4,H2PS3A+FR2
	WL	4,H2PS3A+FR3
	.word	ANI_ATTACK_ON, AMODE_PUSH,11,83,70,20 ;mode,x,y,w,h
	WL	4,H2PS3A+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,40h,-60000h,#no_hit	;range,vel,addr
	WL	15,H2PS3A+FR4
#no_hit
	WL	4,H2PS3A+FR5
	WL	4,H2PS3A+FR6
	WL	4,H2PS3A+FR7
	WL	4,H2PS3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 PUSH

 SUBR	hrt_4_push_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUSH,12
	WL	4,H4PS3A+FR1
	WL	4,H4PS3A+FR2
	WL	4,H4PS3A+FR3
	.word	ANI_ATTACK_ON, AMODE_PUSH,11,83,70,20 ;mode,x,y,w,h
	WL	4,H4PS3A+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,40h,-60000h,#no_hit	;range,vel,addr
	WL	15,H4PS3A+FR4
#no_hit

	WL	4,H4PS3A+FR5
	WL	4,H4PS3A+FR6
	WL	4,H4PS3A+FR7
	WL	4,H4PS3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 PUNCH FALLEN OPPONENT

 SUBR	hrt_2_ground_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_LBDROP,14
	WL	4,H2PF2B+FR1
	WL	3,H2PF2B+FR2

	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,5-10,-8,-40,32,32,50
	WL	1,H2PF2B+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#leapat

	WL	4,H2PF2B+FR3
	WL	3,H2PF2B+FR4
	.word	ANI_ATTACK_ON_Z,AMODE_LBOWDROP,5,-8,-40,32,32,50
	WL	3,H2PF2B+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_GOTO,#common

#leapat
	.word	ANI_TARGET,TGT_HEAD,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,112,96,40000h,TGT_USER,13,0,-30
	WL	ANI_CODE,no_bk_xvel

	.word	ANI_STARTATTACK,AT_LBDROP,14
	WL	10,H2PF2B+FR3

	WL	4,H2PF2B+FR4
	.word	ANI_ATTACK_ON_Z,AMODE_LBOWDROP,5,-8,-40,32,32,50
	WL	1,H2PF2B+FR5
	.word	ANI_ATTACK_OFF
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
#common
	WL	ANI_IFNOTSTATUS,#missed
	.word	ANI_SHAKER,15
	.word	ANI_SHAKEALL,1
	WL	ANI_GOTO,#hit
#missed
	WL	ANI_CODE,CALL_MISSES
#hit
	WL	3,H2PF2B+FR5
	WL	3,H2PF2B+FR6
	WL	3,H2PF2B+FR7
	WL	3,H2PF2B+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 PUNCH FALLEN OPPONENT

 SUBR	hrt_4_ground_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	4,H4PF4B+FR1
	WL	3,H4PF4B+FR2

	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,5,-6,-10,36,30,50
	WL	1,H4PF4B+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#leapat

	.word	ANI_STARTATTACK,AT_LBDROP,7
	WL	4,H4PF4B+FR3
	WL	3,H4PF4B+FR4
	.word	ANI_ATTACK_ON_Z,AMODE_LBOWDROP,5,-6,-10,36,30,50
	WL	3,H4PF4B+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_GOTO,#common

#leapat
	.word	ANI_TARGET,TGT_HEAD,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,112,96,40000h,TGT_USER,0,0,30
	WL	ANI_CODE,no_bk_xvel
	.word	ANI_STARTATTACK,AT_LBDROP,14

	WL	1,H4PF4B+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,H4PF4B+FR4
	.word	ANI_ATTACK_ON_Z,AMODE_LBOWDROP,5,-6,-10,36,30,50
	WL	1,H4PF4B+FR5
	.word	ANI_ATTACK_OFF
#common
	WL	ANI_IFNOTSTATUS,#missed
	.word	ANI_SHAKER,15
	.word	ANI_SHAKEALL,1
	WL	ANI_GOTO,#hit
#missed
	WL	ANI_CODE,CALL_MISSES
#hit
	WL	3,H4PF4B+FR5
	WL	3,H4PF4B+FR6
	WL	3,H4PF4B+FR7
	WL	3,H4PF4B+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 HEADBUTT

 SUBR	hrt_2_butt_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,H2BC3A+FR1
	WL	3,H2BC3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_HDBUTT,3
	WL	3,H2BC3A+FR3

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,19,75,35,24	;mode,x,y,w,h
	WL	3,H2BC3A+FR4
	.word	ANI_ATTACK_OFF
	WL	6,H2BC3A+FR4

	WL	ANI_IFNOHITBLOCK,#noblock
	WL	10,H2BC3A+FR4
#noblock

	WL	3,H2BC3A+FR5
	WL	3,H2BC3A+FR6
	WL	3,H2BC3A+FR7
	WL	3,H2BC3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 HEADBUTT

 SUBR	hrt_4_butt_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,H4BC3A+FR1
	WL	3,H4BC3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_HDBUTT,3
	WL	3,H4BC3A+FR3

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,19,75,35,24	;mode,x,y,w,h
	WL	3,H4BC3A+FR4
	.word	ANI_ATTACK_OFF
	WL	6,H4BC3A+FR4

	WL	ANI_IFNOHITBLOCK,#noblock
	WL	10,H4BC3A+FR4
#noblock

	WL	3,H4BC3A+FR5
	WL	3,H4BC3A+FR6
	WL	3,H4BC3A+FR7
	WL	3,H4BC3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 KICK

 SUBR	hrt_2_kick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	3,H2KM3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KICK,6
	WL	3,H2KM3A+FR2
	WL	3,H2KM3A+FR3
	WL	3,H2KM3A+FR4

	.word	ANI_ATTACK_ON, AMODE_KICK,23,73,50,17	;mode,x,y,w,h
	WL	3,H2KM3A+FR5
	.word	ANI_ATTACK_OFF
	WL	6,H2KM3A+FR5

	WL	3,H2KM3A+FR6
	WL	3,H2KM3A+FR7
	WL	3,H2KM3A+FR8
	WL	3,H2KM3A+FR9
	WL	3,H2KM3A+FR10
	WL	3,H2KM3A+FR11

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 KICK

 SUBR	hrt_4_kick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	3,H4KM3B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KICK,9
	WL	3,H4KM3B+FR2
	WL	3,H4KM3B+FR3
	WL	3,H4KM3B+FR4

	.word	ANI_ATTACK_ON, AMODE_KICK,23,73,50,17	;mode,x,y,w,h
	WL	3,H4KM3B+FR5
	.word	ANI_ATTACK_OFF
	WL	6,H4KM3B+FR5

	WL	3,H4KM3B+FR6
	WL	3,H4KM3B+FR7
	WL	3,H4KM3B+FR8
	WL	3,H4KM3B+FR9
	WL	3,H4KM3B+FR10
	WL	3,H4KM3B+FR11

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 & #4 TURBO KICK

 SUBR	hrt_4_jumpkick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #3 FLYING KICK


 SUBR	hrt_flying_kick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_FLYKICK,16
	WL	4,H3DC3A+FR1
	WL	4,H3DC3A+FR2

	.word	ANI_OFFSET,0,57,0			;x,y,z

	LEAPATOPP 8,100,32,16,080000h,TGT_HEAD,-51,-38,0

	WL	4,H3DC3A+FR3
	WL	4,H3DC3A+FR4

	.word	ANI_ATTACK_ON, AMODE_FLYKICK,-3,26,61,21 ;mode,x,y,w,h
	WL	3,H3DC3A+FR5
	.word	ANI_ATTACK_OFF
	WL	5,H3DC3A+FR5

	WL	1,H3DC3A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	8,H3DC3A+FR8
	WL	8,H3DC3A+FR9
	WL	8,H3DC3A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #2 STOMP ON FALLEN OPPONENT

 SUBR	hrt_2_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	4,H2MP2B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	3,H2MP2B+FR2
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,7,-10,-40,28,31,50
	WL	1,H2MP2B+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#no_leapat

	.word	ANI_TARGET,TGT_CHEST,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,112,96,40000h,TGT_USER,22,0,-30
	WL	ANI_CODE,no_bk_xvel

#no_leapat
	.word	ANI_STARTATTACK,AT_STOMP,5
	WL	4,H2MP2B+FR3
	WL	1,H2MP2B+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,7,-10,-40,28,31,50
	WL	1,H2MP2B+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	.word	ANI_SHAKER,20
	.word	ANI_SHAKEALL,1
	WL	ANI_GOTO,#hit
#missed
	WL	ANI_CODE,CALL_MISSES
#hit

	WL	3,H2MP2B+FR5
	WL	4,H2MP2B+FR6
	WL	4,H2MP2B+FR7
	WL	4,H2MP2B+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 STOMP ON FALLEN OPPONENT

 SUBR	hrt_4_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	4,H4MP4A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	3,H4MP4A+FR2
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,7,-12,-10,29,35,50
	WL	1,H4MP4A+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#no_leapat

	.word	ANI_TARGET,TGT_CHEST,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,112,96,40000h,TGT_USER,21,0,30
	WL	ANI_CODE,no_bk_xvel

#no_leapat
	.word	ANI_STARTATTACK,AT_STOMP,5
	WL	4,H4MP4A+FR3
	WL	1,H4MP4A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,7,-12,-10,29,35,50
	WL	1,H4MP4A+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	.word	ANI_SHAKER,20
	.word	ANI_SHAKEALL,1
	WL	ANI_GOTO,#hit
#missed
	WL	ANI_CODE,CALL_MISSES
#hit

	WL	3,H4MP4A+FR5
	WL	4,H4MP4A+FR6
	WL	4,H4MP4A+FR7
	WL	4,H4MP4A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* RUNNING GROUND PUNCH

#yoff	equ	50

 SUBR	hrt_running_ground_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h

	WL	3,H4JK4C+FR1
	WL	3,H4JK4C+FR2

	.word	ANI_TARGET,TGT_HEAD,TGT_CHEST,ATM_FARTHEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 26,200,100,90,90000h,TGT_USER,-22,#yoff,30
	.word	ANI_STARTATTACK,AT_STOMP,26

	.word	ANI_SETPLYRMODE,MODE_INAIR

	WL	ANI_CODE,no_bk_xvel
	.word	ANI_OFFSET,0,#yoff,0
	WL	3,H4JK4C+FR3
	WL	3,H4JK4C+FR4
	WL	3,H4JK4C+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_ATTACK_ON,AMODE_BUTTSTOMP,-50,-6,36,23
	WL	2,H4JK4C+FR6
	.word	ANI_ATTACK_OFF
	WL	8,H4JK4C+FR7

	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,1
	WL	ANI_CODE,HIT_THE_MAT

	WL	ANI_IFSTATUS,#hit

	WL	ANI_CODE,CALL_MISSES

#hit
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	4,H4JK4C+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,hrt_4_faceup_getup2_anim


#*****************************************************************************
*
* TURNBUCKLE ELBOW SLAM

#xoff	equ	19
#yoff	equ	37

 SUBR	hrt_tbukl_leap_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCONFINE|MODE_NOCOLLIS|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING

	WL	3,H4JP4C+FR1
	WL	3,H4JP4C+FR2
	.word	ANI_OFFSET,#xoff,#yoff,0

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 36,190,190,190,90000h,TGT_GROIN,22,-9,20
	.word	ANI_STARTATTACK,AT_BSTOMP,36
	.word	ANI_SETPLYRMODE,MODE_INAIR2
	.word	ANI_GRAVITY_ON
	.word	ANI_SHAKECORNER

	WL	ANI_CODE,check_xvel

	WL	3,H4JP4C+FR3
	WL	3,H4JP4C+FR4

	;attack box dimensions (that means size) depends on opp mode
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,0,-1+5,-10,36,52,70
	WWL	ANI_IFOPPMODE,MODE_ONGROUND,#opp_onground
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,0,-1+15,-10,36,52,70

#opp_onground
	WWL	ANI_WAITHITOPP,30,H4JP4C+FR5
	.word	ANI_ZERO_XZVELS
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_OFF

	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,1
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	ANI_IFNOTSTATUS,#missed

	;hit
	.word	ANI_BOUNCE,5
	WL	1,H4JP4C+FR6
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKER,18
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#common

#missed
	WL	ANI_CODE,CALL_MISSES
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_BOUNCE,4
	.word	ANI_WAITHITGND

#common

	WL	4,H4JP4C+FR6

	.word	ANI_FACEDOWN
	.word	ANI_OFFSET,10,0,-5
	WL	ANI_CHANGEANIM,hrt_4_faceup_getup2_anim


#*****************************************************************************
*
* #2 BIG BOOT

 SUBR	hrt_2_bigboot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_STARTATTACK,AT_BIGBOOT,12
	WL	3,H2KM3A+FR1
	WL	3,H2KM3A+FR2
	WL	3,H2KM3A+FR3
	WL	ANI_CODE,#clrcnt
	WL	3,H2KM3A+FR4

	.word	ANI_ATTACK_ON, AMODE_BIGBOOT,23,73,50,17 ;mode,x,y,w,h
	WL	2,H2KM3A+FR5
#lp0
	WL	2,H2KM3A+FR5
	WL	ANI_CODE,#holdup
	WL	ANI_IFSTATUS,#lp0

	.word	ANI_ATTACK_OFF
	WL	3,H2KM3A+FR6
	WL	3,H2KM3A+FR7
	WL	3,H2KM3A+FR8
	WL	3,H2KM3A+FR9
	WL	3,H2KM3A+FR10
	WL	3,H2KM3A+FR11

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_4_bigboot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_STARTATTACK,AT_BIGBOOT,12
	WL	3,H4KM3B+FR1
	WL	3,H4KM3B+FR2
	WL	3,H4KM3B+FR3
	WL	ANI_CODE,#clrcnt
	WL	3,H4KM3B+FR4

	.word	ANI_ATTACK_ON, AMODE_BIGBOOT,23,73,50,17 ;mode,x,y,w,h
	WL	2,H4KM3B+FR5
#lp1
	WL	2,H4KM3B+FR5
	WL	ANI_CODE,#holdup
	WL	ANI_IFSTATUS,#lp1

	.word	ANI_ATTACK_OFF
	WL	3,H4KM3B+FR6
	WL	3,H4KM3B+FR7
	WL	3,H4KM3B+FR8
	WL	3,H4KM3B+FR9
	WL	3,H4KM3B+FR10
	WL	3,H4KM3B+FR11

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
* #4 KNEE

 SUBR	hrt_4_knee_anim

;The artwork is labeled wrong...  2=4, It is okay!

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,H2NM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_OFFSET,23,0,0			;x,y,z

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 12h,999,20h,20,90000h,TGT_CHEST,40,20,-10

	.word	ANI_STARTATTACK,AT_KNEE,18
	WL	3,H2NM3A+FR3

	.word	ANI_ATTACK_ON, AMODE_KNEE,11,44,51,49	;mode,x,y,w,h
	WL	3,H2NM3A+FR4
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,28h,-58000h,#no_hit
	WL	ANI_SET_YVEL,50000h
	WLW	ANI_SET_ZVEL,-8000h,AM_ABS
	WL	1,H2NM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#cont
#no_hit
	WL	ANI_IFNOTSTATUS,#nodrft
	WLW	ANI_SET_ZVEL,-4000h,AM_ABS
;	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL
;	WLW	ANI_SET_XVEL,4000h,AM_ABS
#nodrft
;	WL	0ch,H2NM3A+FR4
;	.word	ANI_ZERO_XZVELS
	WL	1,H2NM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

#cont
	WL	3,H2NM3A+FR5
	WL	3,H2NM3A+FR6
;	WL	3,H2NM3A+FR7
;	.word	ANI_OFFSET,26,0,0			;x,y,z

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #2 KNEE

 SUBR	hrt_2_knee_anim

;The artwork is labeled wrong...  2=4, It is okay!

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,H4NM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_OFFSET,23,0,0			;x,y,z

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 21,999,36,20,90000h,TGT_CHEST,46,20,0
	.word	ANI_STARTATTACK,AT_KNEE,21
	WL	3,H4NM3A+FR3

	.word	ANI_ATTACK_ON, AMODE_KNEE,11,44,51,49	;mode,x,y,w,h
	WL	3,H4NM3A+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,28h,-58000h,#no_hit2
	WL	ANI_SET_YVEL,60000h
	WLW	ANI_SET_ZVEL,4000h,AM_ABS
	WL	3,H4NM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#cont2
#no_hit2
	WL	ANI_IFNOTSTATUS,#nodrft2
	WLW	ANI_SET_ZVEL,4000h,AM_ABS
;	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL
#nodrft2
;	WL	12h,H4NM3A+FR4
;	.word	ANI_ZERO_XZVELS
	WL	6,H4NM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
#cont2
	WL	3,H4NM3A+FR5
	WL	3,H4NM3A+FR6
	WL	3,H4NM3A+FR7
;If Bret should be facing #2, just exit to a faceup
;	WL	3,H4NM3A+FR8
;	.word	ANI_OFFSET,26,0,0			;x,y,z

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* GRAB & FLING OPPONENT (INTO A RUN)

 SUBR	hrt_2_grabfling_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	3,H1TL5A+FR3
	WL	3,H1TL5A+FR4
	WL	ANI_GOTO,#cont

 SUBR	hrt_4_grabfling_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

#cont
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,40,0,25
	.word	ANI_STARTATTACK,AT_PUPPET,8
	WL	ANI_SET_YVEL,0000h
	WL	4,H3HT3X+FR1

	.word	ANI_ATTACK_ON, AMODE_PUPPET,31h,56,44,18 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,H3GF7B+FR2
;	WL	4,H3GF7B+FR2
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb

;got him


;	out of control time for fling?

	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

; attacker sequence
	WWLLW	ANI_SUPERSLAVE2,8,H3GF7B+FR2,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,6,H3GF7B+FR3,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,H3GF7B+FR4,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,H3GF7B+FR5,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,H3GF7B+FR6,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,H3GF7B+FR7,#puppet_tbl,5

	WL	ANI_SLAVEANIM,#strt_run_tbl

	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_DETACH
	WL	10,H3GF7B+FR8
	WL	4,H3GF7B+FR9
	.word	ANI_OFFSET,-10,0,0			;x,y,z

	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#missedb
	WL	25,H3GF7B+FR2
#missed
	WL	ANI_CODE,CALL_MISSES
	WL	8,H3GF7B+FR2
	WL	4,H3HT3X+FR1

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

#Bret
 LWWW H4YR3A+FR1,48,11,1
 LWWW H4YR3A+FR2,39,6,1
 LWWW H4YR3A+FR3,31,7,1
 LWWW H4YR3A+FR5,14,15,1
 LWWW H3RN3A+FR1,9,18,0
 LWWW H3RN3A+FR2,-18,20,0
#Razor
 LWWW R4YR3A+FR1,41,16,0
 LWWW R4YR3A+FR2,30,9,0
 LWWW R4YR3A+FR3,1,4,0
 LWWW R4YR3A+FR4,-23,11,0
 LWWW R3RN3D+FR10,14,25,0
 LWWW R3RN3D+FR11,-18,27,0
#Taker
 LWWW U4YR3B+FR2,25,18,0
 LWWW U4YR3B+FR3,27,8,0
 LWWW U4YR3B+FR4,15,14,0
 LWWW U4YR3B+FR5,0,18,0
 LWWW U3RN3A+FR2,-12,29,0
 LWWW U3RN3A+FR2,-52,29,0
#Yokozuna
 LWWW Y4YR3A+FR1,45,13,1
 LWWW Y4YR3A+FR4,20,8,1
 LWWW Y4YR3A+FR5,9,8,1
 LWWW Y4YR3A+FR7,-17,4,1
 LWWW Y3RN3C+FR7,28,26,0
 LWWW Y3RN3C+FR8,5,26,0
#Shawn
 LWWW S4YR3A+FR2,28,4,1
 LWWW S4YR3A+FR3,42,-11,1
 LWWW S4YR3A+FR5,9,4,1
 LWWW S4YR3A+FR6,2,7,1
 LWWW S3RN3A+FR2,11,22,0
 LWWW S3RN3A+FR3,-18,25,0
#BamBam
 LWWW B4YR3A+FR3,38,12,0
 LWWW B4YR3A+FR4,45,1,0
 LWWW B4YR3A+FR5,49,3,0
 LWWW B4YR3A+FR7,-15,5,0
 LWWW B3RN3A+FR1,26,28,0
 LWWW B3RN3A+FR2,-7,30,0
#Doink
 LWWW D4YR3B+FR1,50,13,1
 LWWW D4YR3B+FR2,46,10,1
 LWWW D4YR3B+FR3,28,10,1
 LWWW D4YR3B+FR4,13,16,1
 LWWW D3RN3B+FR3,19,29,0
 LWWW D3RN3B+FR4,-20,30,0
#Adam
 .long 0
#Lex
 LWWW L4YR3B+FR1,56,12,1
 LWWW L4YR3B+FR2,41,0,1
 LWWW L4YR3B+FR3,13,6,1
 LWWW L4YR3B+FR4,-21,8,1
 LWWW L3RN3B+FR2,11,31,0
 LWWW L3RN3B+FR3,-4,28,0

#strt_run_tbl

	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung

#*****************************************************************************

 SUBR	hrt_roll_frames

	.word	8		;speed
	.long	30000h		;z velocity
	.long	10000h*12/255	;inv multiply (0-255 -> 0-12)

	.long	H3RL1A+FR1	;0
	.long	H3RL1A+FR13	;1
	.long	H3RL1A+FR12	;2
	.long	H3RL1A+FR11	;3
	.long	H3RL1A+FR10	;4
	.long	H3RL1A+FR9	;5
	.long	H3RL1A+FR8	;6
	.long	H3RL1A+FR7	;7
	.long	H3RL1A+FR6	;8
	.long	H3RL1A+FR5	;9
	.long	H3RL1A+FR4	;10
	.long	H3RL1A+FR3	;11
	.long	H3RL1A+FR2	;12

	.long	0,0,0,0,0,0


#*****************************************************************************

 SUBR	hrt_leap_test

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

	.ref	HIT_THE_MAT,SMALL_BOUNCE,hrt_faceup_getup_anim
	.ref	ck_dizzy,ckzpos


;FIX!!  Make throw out of ring if close to ropes
#*****************************************************************************
*
* FLIP/FALL FROM HIPTOSS

 SUBR	hrt_tossed_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,ckzpos

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_GETUP,300
	WL	ANI_CODE,HIT_THE_MAT
	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,50000h
	WL	4,H2CP3A+FR1
	WL	4,H2CP3A+FR2
	WL	4,H2CP3A+FR3
	WL	4,H2CP3A+FR4
	WL	4,H2CP3A+FR5
	WL	4,H2CP3A+FR6
	WL	4,H2CP3A+FR7

	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,H2CP3A+FR8
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim
	.word	ANI_END

;FIX!!  Make throw out of ring if close to ropes
#*****************************************************************************
*
* FLIP/FALL FROM BAM BAM DUCK TOSS

 SUBR	hrt_tossed2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,ckzpos

	WLW	ANI_SET_XVEL,60000h,AM_HIT_REL
	WL	ANI_SET_YVEL,30000h
	.word	ANI_OFFSET,20,20,0			;x,y,z
	WL	4,H3FR3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_GETUP,300
	.word	ANI_DAMAGE,D_HIPTOSS

	WL	4,H3FR3A+FR5
	.word	ANI_XFLIP
	.word	ANI_OFFSET,15,0,0			;x,y,z
	WL	3,H2CP3A+FR8

	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,50000h
	WL	4,H2CP3A+FR1
	WL	4,H2CP3A+FR2
	WL	4,H2CP3A+FR3
	WL	4,H2CP3A+FR4
	WL	4,H2CP3A+FR5
	WL	4,H2CP3A+FR6
	WL	4,H2CP3A+FR7

	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,H2CP3A+FR8
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim
	.word	ANI_END

#*****************************************************************************
*

 SUBR	hrt_knockdwn_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h
	.word	ANI_XFLIP
 

	WL	2,H3GU4A+FR10
	WL	2,H3GU4A+FR8
	WL	2,H3GU4A+FR3
	WL	ANI_SET_YVEL,39000h

	WL	3,H2CP3A+FR1
	.word	ANI_DEBRIS,400,1,0,8,0		;%chance, tbl index, x,y,z off
	WL	3,H2CP3A+FR2
	WL	3,H2CP3A+FR3
	WL	3,H2CP3A+FR4
	WL	3,H2CP3A+FR5
	WL	3,H2CP3A+FR6
	WL	3,H2CP3A+FR7
	WL	3,H2CP3A+FR8

;MJT Start
	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	.word	ANI_SETPLYRMODE,MODE_DEAD
	.word	ANI_END

#nodead
;MJT End

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim

#*****************************************************************************
 SUBR	hrt_climbthru_side_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WLW	ANI_SET_XVEL,2000h,AM_FACE_REL

	.word	ANI_OFFSET,16,0,0
	WL	4,H4CR3D+FR1
	WL	4,H4CR3D+FR2
	.word	ANI_BENDROPE,0
	.word	ANI_OFFSET,3,0,0	;*****
	WL	4,H4CR3D+FR3		
	WL	4,H4CR3D+FR4

	.word	ANI_BENDROPE,2
	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH

	.word	ANI_OFFSET,5,0,0	;*****
	WL	4,H4CR3D+FR5

	.word	ANI_BENDROPE,2

	.word	ANI_OFFSET,4+6,0,0	;*****
	WL	4,H4CR3D+FR8

	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_BENDROPE,3
	.word	ANI_OFFSET,10,0,0	;*****
	WL	4,H4CR3D+FR9
	.word	ANI_ZEROVELS
	.word	ANI_BENDROPE,-1
	.word	ANI_OFFSET,5,0,0	;*****
	WL	4,H4CR3D+FR10
	.word	ANI_OFFSET,10,-3,0
	WL	4,H4CR3D+FR11
	.word	ANI_OFFSET,2,0,0	;*****
	WL	4,H4CR3D+FR12
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH

	;now jump off...
	WL	4,H4JD4B+FR1 
	WL	4,H4JD4B+FR2
	WL	3,H4JD4B+FR3
	WL	3,H4JD4B+FR4
	WL	3,H4JD4B+FR5
	WL	3,H4JD4B+FR6

	WL	ANI_SET_YVEL,60000h

	WLW	ANI_SET_XVEL,30000h,AM_FACE_REL

	WL	3,H4JD4B+FR7
	.word	ANI_WAITHITGND

	.word	ANI_ROPE_Z,R_TOP,RZ_NORM
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM

	.word	ANI_ZEROVELS
	WL	6,H4JD4B+FR8
	WL	3,H4JD4B+FR9
	WL	3,H4JD4B+FR10
	WL	3,H4JD4B+FR11

	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	hrt_climbin_side_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	ANI_CODE,SET_DIR_FACE
	.word	ANI_SETFACING
	.WORD	ANI_SET_WRESTLER_XFLIP

	;jump in
	WL	4,H4JD4B+FR1
	WL	4,H4JD4B+FR2
	WL	4,H4JD4B+FR3
	WL	4,H4JD4B+FR4
	WL	4,H4JD4B+FR5
	WL	4,H4JD4B+FR6

	WL	ANI_CODE,#set_trgt
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	.word	ANI_LEAPATPOS,1ch,200,0,0,0	;#ticks,dist,xoff,yoff,zoff

	WL	4,H4JD4B+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH

	.word	ANI_OFFSET,13,0,0	;*****
	WL	3,H4JD4B+FR8
	WL	3,H4JD4B+FR9
	WL	3,H4JD4B+FR10
	WL	3,H4JD4B+FR11

	WL	ANI_CODE,#set_z
	WLW	ANI_SET_XVEL,2000h,AM_FACE_REL

	;climb through
	WL	3,H4CR3D+FR1
	.word	ANI_OFFSET,3,0,0	;*****
	WL	3,H4CR3D+FR2
	.word	ANI_BENDROPE,0
	.word	ANI_OFFSET,3,0,0	;*****
	WL	3,H4CR3D+FR3
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM
	.word	ANI_OFFSET,3,0,0	;*****
	WL	3,H4CR3D+FR4
	.word	ANI_OFFSET,3,0,0	;*****
	WL	3,H4CR3D+FR5

	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH
	.word	ANI_BENDROPE,2
	.word	ANI_OFFSET,5+8,0,0	;*****
	WL	3,H4CR3D+FR8
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM
	.word	ANI_OFFSET,5,0,0	;*****
	WL	3,H4CR3D+FR9
	.word	ANI_OFFSET,5,0,0	;*****
	WL	3,H4CR3D+FR10
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_BENDROPE,-1
	.word	ANI_OFFSET,10,-3,0
	WL	3,H4CR3D+FR11
	WL	3,H4CR3D+FR12
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

 SUBR	hrt_climbthru_bot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

;Must rotate toward ropes!
;Do a different sequence

	;lie down
	WL	ANI_CODE,#ckspin
	WL	3,H3GU4A+FR10
	WL	3,H3GU4A+FR9
	WL	3,H3GU4A+FR8
	WL	3,H3GU4A+FR7
	WL	3,H3GU4A+FR6
	WL	3,H3GU4A+FR5
	WL	3,H3GU4A+FR4
	WL	3,H3GU4A+FR2
	WL	3,H3GU4A+FR1

	;roll over once
	WLW	ANI_SET_ZVEL,80000h,AM_ABS

	WL	3,H3RL1A+FR13
	WL	3,H3RL1A+FR12
	WL	3,H3RL1A+FR11
	WL	3,H3RL1A+FR10
	WL	3,H3RL1A+FR9
	WL	3,H3RL1A+FR8
	WL	3,H3RL1A+FR7
	WL	3,H3RL1A+FR6
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP+MODE_NOSHADOW

	;climb through

	.WORD	ANI_XFLIP
	WL	ANI_CODE,NOT_IN_RING
	.word	ANI_OFFSET,0,-37h,0			;x,y,z
	WL	3,H4KM3B+FR7
	WL	3,H4KM3B+FR8
	WL	3,H4KM3B+FR9
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

 SUBR	hrt_climbin_bot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;climb in
	.word	ANI_GRAVITY_OFF
	.WORD	ANI_XFLIP
	WL	3,H4KM3B+FR9
	WL	3,H4KM3B+FR8
	WL	3,H4KM3B+FR7
	.word	ANI_OFFSET,0,37h,-60
	.WORD	ANI_XFLIP

	;roll
	WLW	ANI_SET_ZVEL,-70000h,AM_ABS
	.word	ANI_FRICTION,3000h
	WL	3,H3RL1A+FR6
	WL	3,H3RL1A+FR7
	WL	3,H3RL1A+FR8
	WL	3,H3RL1A+FR9
	WL	3,H3RL1A+FR10
	WL	3,H3RL1A+FR11
	.word	ANI_ZEROVELS
	.word	ANI_GRAVITY_ON

	;get up
	WL	3,H3GU4A+FR1
	WL	3,H3GU4A+FR2
	WL	3,H3GU4A+FR3
	WL	3,H3GU4A+FR4
	WL	3,H3GU4A+FR5
	WL	3,H3GU4A+FR6
	WL	3,H3GU4A+FR7
	WL	3,H3GU4A+FR8
	WL	3,H3GU4A+FR9
	WL	3,H3GU4A+FR10

	WL	ANI_CODE,clr_climb

	.word	ANI_FACEDOWN
	.word	ANI_ZEROVELS
	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	hrt_climbthru_top_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;lie down
	WL	ANI_CODE,#set_zvel1
	WL	ANI_IFSTATUS,#dir4
;Facing #2, spin first!
	WL	3,H1TT5A+FR3
	WL	3,H1TT5A+FR4
	
#dir4
	WL	3,H3GU4A+FR10
	WL	3,H3GU4A+FR9
	WL	3,H3GU4A+FR8
	WL	3,H3GU4A+FR7
	WL	3,H3GU4A+FR6
	WL	3,H3GU4A+FR5
	WL	3,H3GU4A+FR4
	WL	3,H3GU4A+FR3
	WL	3,H3GU4A+FR2
	WL	3,H3GU4A+FR1

	;roll over once
	WL	ANI_CODE,#set_zvel2
#cont
	WL	3,H3RL1A+FR13
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP+MODE_NOSHADOW
	WL	3,H3RL1A+FR1
	WL	3,H3RL1A+FR2
	WL	3,H3RL1A+FR3
	WL	3,H3RL1A+FR4

	;climb through
	.word	ANI_OFFSET,0,-61,0
	.word	ANI_ZEROVELS
	WL	3,H3MS3Z+FR4
	WL	3,H3MS3Z+FR3
	WL	3,H3MS3Z+FR2

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

 SUBR	hrt_climbin_top_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;climb in
	WL	3,H3MS3Z+FR2
	WL	3,H3MS3Z+FR3
	WL	3,H3MS3Z+FR4
	.word	ANI_OFFSET,0,61,0

	;roll over
	WL	ANI_CODE,#set_zvel2
	WL	3,H3RL1A+FR3
	WL	3,H3RL1A+FR2
	WL	3,H3RL1A+FR1
	WL	3,H3RL1A+FR13	

	.word	ANI_ZEROVELS

	;get up
	WL	3,H3GU4A+FR1
	WL	3,H3GU4A+FR2
	WL	3,H3GU4A+FR3
	WL	3,H3GU4A+FR4
	WL	3,H3GU4A+FR5
	WL	3,H3GU4A+FR6
	WL	3,H3GU4A+FR7
	WL	3,H3GU4A+FR8
	WL	3,H3GU4A+FR9
	WL	3,H3GU4A+FR10

	WL	ANI_CODE,clr_climb

	.WORD	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END

#set_zvel2
	movi	52000h,a0
	move	a0,*a13(OBJ_ZVEL),L
	rets

#****************************************************************************
*
* PIN OPPONENT AND RAISE ARM IN VICTORY

;Need to have this guy walk toward fallen opponent so he
;can get closer!

;This pin must be started only when opponent is on the ground!

 SUBR	hrt_2_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;Rotate!
	WL	3,H1TL5A+FR3	;2.5
	WL	3,H1TL5A+FR4	;3.5
	WL	ANI_GOTO,#cont

 SUBR	hrt_4_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

#cont
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 29,999,80h,50h,90000h,TGT_CHEST,0,57,-15

	WL	3,H3PN5A+FR1
	WL	4,H3PN5A+FR2
	WL	4,H3PN5A+FR3
	.word	ANI_OFFSET,0,48,0			;x,y,z
	WL	18,H3PN5A+FR4
;	.word	ANI_WAITHITGND
	.word	ANI_ATTACK_ON_Z, AMODE_STOMP,-40,-8,0,76,20,30 ;mode,x,y,z,w,h,d
	.word	ANI_ZEROVELS

	WL	5,H3PN5A+FR7

	WL	ANI_CODE,DO_CROWD_CHEER
	.word	ANI_ATTACK_OFF
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_BOUNCE,4
	WL	4,H3PN5A+FR8
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE

	WL	4,H3PN5A+FR8
	.ref	win_announce
	WL	ANI_CODE,win_announce
	.word	ANI_OFFSET,0,0,0			;x,y,z
	WL	40,H3PN5A+FR8

;???? IS THIS WHERE IT GOES ?
	.word	ANI_LOOP

;Do another ground hit on opponent
	.ref	grnd_hit
	WL	ANI_CODE,grnd_hit

	WL	ANI_SET_YVEL,42000h
	WLW	ANI_SET_ZVEL,22000h,AM_ABS

	WL	3,H3GU4A+FR6
	WL	3,H3GU4A+FR7
	WL	3,H3GU4A+FR8
	WL	3,H3GU4A+FR9
	WL	3,H3GU4A+FR10

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

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


	WL	1000,H4SL4C+FR3

;	WL	5,H4SL4C+FR2
;	WL	1000,H4SL4C+FR1


	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************
* END

