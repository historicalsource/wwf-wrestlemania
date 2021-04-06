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
* Initiated:		5/26/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"shnseq2.asm"
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
	.include	"shawnimg.h"
	.include	"display.equ"
	.include	"ring.equ"
	.include	"damage.equ"


******************************************************************************
* EXTERNAL REFERENCES

	;BAM BAM
	.ref	B4YR3A,B3RN3A

	;DOINK
	.ref	D4YR3B,D3RN3B

	;BRET
	.ref	H4YR3A,H3RN3A

	;LEX
	.ref	L4YR3B,L3RN3B

	;RAZOR
	.ref	R4YR3A,R3RN3D

	;SHAWN
	.ref	shn_faceup_getup_anim,shn_faceup_getup2_anim
	.ref	S4YR3A,S3RN3A

	;TAKER
	.ref	U4YR3B,U3RN3A

	;YOKO
	.ref	Y4YR3A,Y3RN3C

	;MISC
	.ref	HIT_THE_MAT,CALL_MISSES,get_opp_process,get_leap
	.ref	set_target_offsets,start_run_anim,SMALL_BOUNCE
	.ref	start_run_flung,ckzpos,ck_dizzy,choose_2or4
	.ref	no_bk_xvel,win_announce,grnd_hit,SET_DIR_FACE
	.ref	DO_CROWD_CHEER,check_xvel,tgt_ground

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* #2 NORMAL PUNCH

 SUBR	shn_2_punch_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	3,S2PU3C+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_PUNCH,3
	WL	3,S2PU3C+FR2
	.word	ANI_ATTACK_ON, AMODE_PUNCH,52,91,28,8
	WL	5,S2PU3C+FR3
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-30000h,#no_hit
	WL	ANI_SET_YVEL,30000h
	WL	3,S2PU3C+FR3
#no_hit
	WL	1,S2PU3C+FR3

	;one more tick if blocked, three more if hit, none if missed.
	.word	ANI_HMBWAIT,3,0,1

	WL	3,S2PU3C+FR4
	WL	3,S2PU3C+FR5
	WL	3,S2PU3C+FR7
	WL	3,S2PU3C+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 NORMAL PUNCH

 SUBR	shn_4_punch_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	3,S4PU3D+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_PUNCH,3
	WL	3,S4PU3D+FR3
	.word	ANI_ATTACK_ON, AMODE_PUNCH,49,85,26,10
	WL	5,S4PU3D+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-30000h,#no_hit

	WL	ANI_SET_YVEL,30000h
	WL	3,S4PU3D+FR4
	
#no_hit
	WL	1,S4PU3D+FR4

	.word	ANI_HMBWAIT,3,0,1

	WL	3,S4PU3D+FR5
	WL	3,S4PU3D+FR6
	WL	3,S4PU3D+FR7
	WL	3,S4PU3D+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 PUSH

 SUBR	shn_2_push_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_STARTATTACK,AT_PUSH,9
	WL	3,S2PS3A+FR1
	WL	3,S2PS3A+FR2
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	WL	3,S2PS3A+FR3
	.word	ANI_ATTACK_ON, AMODE_PUSH,33,85,53,17 ;mode,x,y,w,h


	WL	6,S2PS3A+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,40h,-40000h,#no_hit	;range,vel,addr
	WL	15,S2PS3A+FR4
#no_hit

	.word	ANI_HMBWAIT,6,0,3
	WL	4,S2PS3A+FR2
	WL	4,S2PS3A+FR1

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 PUSH

 SUBR	shn_4_push_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_STARTATTACK,AT_PUSH,9
	WL	3,S4PS3A+FR1
	WL	3,S4PS3A+FR2
	WL	3,S4PS3A+FR3
	.word	ANI_ATTACK_ON, AMODE_PUSH,33,85,44,17 ;mode,x,y,w,h
	WL	6,S4PS3A+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,40h,-40000h,#no_hit	;range,vel,addr
	WL	15,S4PS3A+FR4
#no_hit

	.word	ANI_HMBWAIT,6,0,3
	WL	4,S4PS3A+FR2
	WL	4,S4PS3A+FR1

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 HEADBUTT

 SUBR	shn_2_butt_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	3,S2BC3B+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_HDBUTT,6
	WL	3,S2BC3B+FR4
	WL	3,S2BC3B+FR5
	.word	ANI_ATTACK_ON, AMODE_HDBUTT,40,81,10,12	;mode,x,y,w,h
	WL	3,S2BC3B+FR6
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-48000h,#no_hit

	WL	ANI_SET_YVEL,38000h
	WL	6,S2BC3B+FR6
#no_hit

	.word	ANI_HMBWAIT,3,0,1
	WL	3,S2BC3B+FR7
	WL	3,S2BC3B+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 HEADBUTT

 SUBR	shn_4_butt_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	3,S4BC3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_HDBUTT,6
	WL	3,S4BC3A+FR4
	WL	3,S4BC3A+FR5
	.word	ANI_ATTACK_ON, AMODE_HDBUTT,32,91,12,15	;mode,x,y,w,h
	WL	3,S4BC3A+FR6
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-48000h,#no_hit

	WL	ANI_SET_YVEL,38000h
	WL	6,S4BC3A+FR6
#no_hit

	.word	ANI_HMBWAIT,3,0,1
	WL	3,S4BC3A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 KICK

 SUBR	shn_2_kick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	3,S2KM3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KICK,5
	WL	2,S2KM3A+FR2
	WL	2,S2KM3A+FR3
	WL	1,S2KM3A+FR4

	WL	ANI_SET_YVEL,20000h

	.word	ANI_ATTACK_ON, AMODE_KICK,27,59,68,20	;mode,x,y,w,h
;	WL	5,S2KM3A+FR5
	WL	3,S2KM3A+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-50000h,#no_slide
	WL	ANI_SET_YVEL,30000h
#no_slide
	.word	ANI_HMBWAIT,4,0,2

;	WWL	ANI_SLIDE_BACK,10h,-40000h,#no_hit
;	WL	ANI_SET_YVEL,30000h
;	WL	2,S2KM3A+FR5
;
;#no_hit
;	WL	ANI_IFNOTSTATUS,#nopause
;	WL	2,S2KM3A+FR5
;#nopause

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	2,S2KM3A+FR5
	WL	4-1,S2KM3A+FR6
	WL	4-1,S2KM3A+FR7
	WL	4-1,S2KM3A+FR8
	WL	3,S2KM3A+FR9
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 KICK

 SUBR	shn_4_kick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	3,S4KM3C+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KICK,4
	WL	2,S4KM3C+FR3
	WL	2,S4KM3C+FR4
	WL	ANI_SET_YVEL,20000h
	.word	ANI_ATTACK_ON, AMODE_KICK,27,59,68,20	;mode,x,y,w,h
;	WL	5,S4KM3C+FR5
	WL	3,S4KM3C+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-50000h,#no_slide
	WL	ANI_SET_YVEL,30000h
#no_slide
	.word	ANI_HMBWAIT,4,0,2

;	WWL	ANI_SLIDE_BACK,10h,-40000h,#no_hit
;	WL	ANI_SET_YVEL,30000h
;	WL	2,S4KM3C+FR5
;	
;#no_hit
;	WL	ANI_IFNOTSTATUS,#nopause
;	WL	2,S4KM3C+FR5
;#nopause
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	4-1,S4KM3C+FR6
	WL	4-1,S4KM3C+FR7
	WL	4-1,S4KM3C+FR8
	WL	3,S4KM3C+FR9
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #3 BACKFLIP KICK

;FIX!!!  MAKE THIS A COOL MOVE 1/12/95

 SUBR	shn_backflip_kick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_KICK,12
	WL	3,S3KF3B+FR1
	WL	3,S3KF3B+FR2
	WL	1,S3KF3B+FR3
	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL
	WL	ANI_SET_YVEL,5c000h
	WL	2,S3KF3B+FR3
	.word	ANI_OFFSET,-24,4,0
	WL	3,S3KF3B+FR4
	.word	ANI_ATTACK_ON,AMODE_SHNBFKIK,17,40,47,62
	WL	3,S3KF3B+FR5
	.word	ANI_ATTACK_OFF
	WL	3,S3KF3B+FR6
	WL	3,S3KF3B+FR7
	WL	3,S3KF3B+FR8
	WL	3,S3KF3B+FR9
	WL	3,S3KF3B+FR10
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,S3KF3B+FR11
	WL	3,S3KF3B+FR12
	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 STOMP ON FALLEN OPPONENT

 SUBR	shn_2_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,S2MP2A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_STOMP,10

	;if we're not going to hit, do a LEAPAT
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,0,0,-30,5,5,40
	WL	1,S2MP2A+FR3
	.word	ANI_ATTACK_OFF

	WL	ANI_SET_YVEL,30000h

	WL	ANI_IFSTATUS,#no_leapat

	.word	ANI_TARGET,TGT_CHEST,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 12,999,112,96,90000h,TGT_USER,28,0,-50
	.word	ANI_STARTATTACK,AT_STOMP,12
	WL	ANI_CODE,no_bk_xvel

#no_leapat
	WL	3,S2MP2A+FR3
	WL	3,S2MP2A+FR4

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,26

	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,16,-8,-50,27,33,60
	WL	3,S2MP2A+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#no_miss

	WL	ANI_CODE,CALL_MISSES

#no_miss
	WL	4,S2MP2A+FR6
	WL	4,S2MP2A+FR7
	WL	4,S2MP2A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #4 STOMP ON FALLEN OPPONENT

 SUBR	shn_4_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,S4MP4C+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	;if we're not going to hit, do a LEAPAT
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,0,0,-10,5,5,60
	WL	1,S4MP4C+FR3
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#no_leapat

	.word	ANI_TARGET,TGT_CHEST,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 12,999,112,96,90000h,TGT_USER,12,0,45
	.word	ANI_STARTATTACK,AT_STOMP,12
	WL	ANI_CODE,no_bk_xvel

#no_leapat
	.word	ANI_STARTATTACK,AT_STOMP,6
	WL	3,S4MP4C+FR3
	WL	3,S4MP4C+FR4

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,26

	.word	ANI_ATTACK_ON_Z, AMODE_STOMP,-3,-13,-10,44,35,60
	WL	3,S4MP4C+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#no_miss

	WL	ANI_CODE,CALL_MISSES

#no_miss
	WL	4,S4MP4C+FR6
	WL	4,S4MP4C+FR7
	WL	4,S4MP4C+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* TURNBUCKLE STOMP

 SUBR	shn_bstomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCONFINE|MODE_NOCOLLIS|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	4,S4MP4C+FR2

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 35,190,190,190,90000h,TGT_GROIN,30,6,40
	.word	ANI_STARTATTACK,AT_LEAPING,35
	.word	ANI_SETPLYRMODE,MODE_INAIR2
	.word	ANI_GRAVITY_ON
	.word	ANI_SHAKECORNER

	WL	ANI_CODE,check_xvel

	WL	4,S4MP4C+FR3

	;attack box dimensions (that means size) depends on opp mode
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-27,0,-10,61,26,70
	WWL	ANI_IFOPPMODE,MODE_ONGROUND,#opp_onground
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-27,40,-10,61,26,70

#opp_onground
	WL	1,S4MP4C+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_OFF

	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,1
	WL	ANI_CODE,HIT_THE_MAT

	WL	ANI_IFSTATUS,#hit

	;missed
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_BOUNCE,4
	WL	ANI_GOTO,#common

#hit
	;hit.  bounce off.
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_ZVEL,-20000h,AM_ABS
	WLW	ANI_SET_XVEL,20000h,AM_FACE_REL

#common
	WL	2,S4MP4C+FR5
	WL	3,S4MP4C+FR6
	WL	4,S4MP4C+FR7
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,SMALL_BOUNCE

	WL	4,S4MP4C+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* TURNBUCKLE ELBOW DROP

#yoff	equ	33

 SUBR	shn_belbow_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCONFINE|MODE_NOCOLLIS|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING

	WL	3,S4PJ3E+FR4

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 31,190,190,190,90000h,TGT_GROIN,22,11+#yoff,50
	.word	ANI_STARTATTACK,AT_LEAPING,31
	.word	ANI_SETPLYRMODE,MODE_INAIR2
	.word	ANI_GRAVITY_ON
	.word	ANI_SHAKECORNER

;Check x vel to make sure we aren't going to land on ropes!
	WL	ANI_CODE,check_xvel

	.word	ANI_OFFSET,0,#yoff,0
	WL	3,S4PJ3E+FR5
	WL	3,S4PJ3E+FR6

	;attack box dimensions (that means size) depends on opp mode
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,19,1,-10,40,18,70
	WWL	ANI_IFOPPMODE,MODE_ONGROUND,#opp_onground
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,3,31,-10,37,49,70

#opp_onground
	WL	1,S4PJ3E+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_OFF

	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,1
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	ANI_IFSTATUS,#hit

	;missed
	WL	ANI_CODE,CALL_MISSES

#hit
	.word	ANI_BOUNCE,5
	.word	ANI_SETPLYRMODE,MODE_INAIR
	WL	2,S4PJ3E+FR8
	WL	4,S4PJ3E+FR9
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,SMALL_BOUNCE

	WL	ANI_CHANGEANIM,shn_faceup_getup2_anim

#*****************************************************************************
*
* #2 FALLING PUNCH

 SUBR	shn_2_falling_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,S2PJ3D+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	3,S2PJ3D+FR2
	WL	3,S2PJ3D+FR3
	.word	ANI_OFFSET,0,64,0
	WL	ANI_CODE,elbow_tgt2
	WL	ANI_CODE,tgt_ground
	LEAPATOPP 20,999,112,96,90000h,TGT_USER,-10,0,-50
	
	.word	ANI_STARTATTACK,AT_LBDROP,10
	WL	3,S2PJ3D+FR4
	WL	3,S2PJ3D+FR5
	
	.word	ANI_ATTACK_ON_Z,AMODE_LBOWDROP,-24,0,-40,26,56,50
	WL	1,S2PJ3D+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_OFF
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,8

	WL	ANI_IFSTATUS,#hit2

	;missed
	WL	ANI_CODE,SMALL_BOUNCE
	WL	ANI_CODE,CALL_MISSES
	WL	ANI_GOTO,#cont2

#hit2
	WL	ANI_CODE,HIT_THE_MAT
#cont2
	.word	ANI_BOUNCE,4
	WL	4,S2PJ3D+FR7
	WL	4,S2PJ3D+FR8
	.word	ANI_XFLIP
	WL	1,S3RL3A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,SMALL_BOUNCE
	WL	4,S3RL3A+FR6

	WL	ANI_CHANGEANIM,shn_faceup_getup_anim

#*************************
*
* #4 FALLING PUNCH

 SUBR	shn_4_falling_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,S4PJ3F+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	3,S4PJ3F+FR2
	.word	ANI_OFFSET,0,71,0
	WL	ANI_CODE,#set_target
	WL	ANI_CODE,tgt_ground
	LEAPATOPP 20,999,72,48h,90000h,TGT_USER,19,0,30
	WL	ANI_CODE,#zero_x_4

	WL	3,S4PJ3F+FR3
	WL	3,S4PJ3F+FR4
	WL	3,S4PJ3F+FR5
	
	.word	ANI_ATTACK_ON_Z,AMODE_LBOWDROP,8,2,-10,23,56,50
	WL	1,S4PJ3F+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_OFF
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,8

	WL	ANI_IFSTATUS,#hit4

	;missed
	WL	ANI_CODE,SMALL_BOUNCE
	WL	ANI_CODE,CALL_MISSES
	WL	ANI_GOTO,#cont4

#hit4
	WL	ANI_CODE,HIT_THE_MAT
#cont4
	.word	ANI_BOUNCE,4
	WL	4,S4PJ3F+FR7
	WL	1,S4PJ3F+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,SMALL_BOUNCE
	WL	4,S4PJ3F+FR8

	WL	ANI_CHANGEANIM,shn_faceup_getup_anim


#set_target

	calla	get_opp_process
	move	a0,a11

	move	*a13(CLOSEST_XDIST),a0
	cmpi	>40,a0
	jrlt	#drop

;We are to side of fallen opponent, we must float toward
;his head or his knees

;Take into account my flip as well as my opponents flip!
	move	*a13(OBJ_CONTROL),a14
	andi	M_FLIPH,a14
	move	*a11(OBJ_CONTROL),a0
	andi	M_FLIPH,a0
	cmp	a0,a14
	jrnz	#head

	movi	TGT_KNEES,a0
	calla	set_target_offsets
	rets

#head
	movi	TGT_HEAD,a0
	calla	set_target_offsets
	rets

#drop
;Just drop straight down
	movi	TGT_CHEST,a0
	calla	set_target_offsets
	rets


;#zero_x_2
;	move	*a13(CLOSEST_XDIST),a0
;	cmpi	32,a0
;	jrgt	#ok2			;Is he to the side?
;
;;Don't float if dropping straight down
;	clr	a0
;	move	a0,*a13(OBJ_XVEL),L
;#ok2	rets


	;other scripts in this file use this one, thus the file-scope label
zero_x
#zero_x_4
	move	*a13(CLOSEST_XDIST),a0
	cmpi	64,a0
	jrgt	#ok4			;Is he to the side?

;Don't float if dropping straight down
	clr	a0
	move	a0,*a13(OBJ_XVEL),L

#ok4	rets

#*****************************************************************************
*
* #2 KNEE

 SUBR	shn_2_knee_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,S2NM3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	3,S2NM3A+FR2

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 21,999,32,20,90000h,TGT_CHEST,50,70,0
	WL	3,S2NM3A+FR3

	.word	ANI_ATTACK_ON,AMODE_KNEE,36,28,38,49	;mode,x,y,w,h
	WL	3,S2NM3A+FR4
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,28h,-40000h,#no_hit

#no_hit
	WL	13,S2NM3A+FR5
	.word	ANI_ZERO_XZVELS
	WL	3,S2NM3A+FR6
	WL	3,S2NM3A+FR7
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 KNEE

 SUBR	shn_4_knee_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,S4NM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	3,S4NM3A+FR3

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 21,999,32,20,90000h,TGT_CHEST,45,78,0

	.word	ANI_ATTACK_ON,AMODE_KNEE,11,22,58,60	;mode,x,y,w,h
	WL	3,S4NM3A+FR4
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,28h,-40000h,#no_hit

#no_hit
	WL	13,S4NM3A+FR4
	WL	3,S4NM3A+FR5
	WL	3,S4NM3A+FR6
	WL	3,S4NM3A+FR7
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* GRAB & FLING OPPONENT (INTO A RUN)

 SUBR	shn_2_grabfling_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	3,S1TT5Z+FR2
	WL	3,S1TT5Z+FR3
	WL	ANI_GOTO,#cont

 SUBR	shn_4_grabfling_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

#cont
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,40,0,25
	WL	ANI_SET_YVEL,0000h
	WL	4,S4GF3B+FR1

	.word	ANI_ATTACK_ON, AMODE_PUPPET,33,56,44,18 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,S4GF3B+FR2
;	WL	4,S4GF3B+FR2
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
	WWLLW	ANI_SUPERSLAVE2,10,S4GF3B+FR2,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,6,S4GF3B+FR3,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,S4GF3B+FR4,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,S4GF3B+FR5,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,S4GF3B+FR6,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,S4GF3B+FR7,#puppet_tbl,5

	WL	ANI_SLAVEANIM,#strt_run_tbl

	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_DETACH
	WL	10,S4GF3B+FR8
	WL	4,S4GF3B+FR10
	.word	ANI_OFFSET,-4,0,0			;x,y,z

	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#missedb
	WL	25,S4GF3B+FR3	;10
#missed
	WL	ANI_CODE,CALL_MISSES
	WL	8,S4GF3B+FR3
	WL	4,S4GF3B+FR2
	WL	4,S4GF3B+FR1

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
 LWWW H4YR3A+FR1,53,7,1
 LWWW H4YR3A+FR2,49,9,1
 LWWW H4YR3A+FR3,48,9,1
 LWWW H4YR3A+FR5,43,11,1
 LWWW H3RN3A+FR1,8,5,0
 LWWW H3RN3A+FR2,-25,8,0

#Razor
 LWWW R4YR3A+FR1,32,17,0
 LWWW R4YR3A+FR2,21,20,0
 LWWW R4YR3A+FR3,1,11,0
 LWWW R4YR3A+FR4,4,15,0
 LWWW R3RN3D+FR10,1,16,0
 LWWW R3RN3D+FR11,-20,16,0

#Taker
 LWWW U4YR3B+FR2,34,18,0
 LWWW U4YR3B+FR3,37,16,0
 LWWW U4YR3B+FR4,29,24,0
 LWWW U4YR3B+FR5,27,24,0
 LWWW U3RN3A+FR2,-11,15,0
 LWWW U3RN3A+FR2,-25,14,0

#Yokozuna
 LWWW Y4YR3A+FR1,59,11,1
 LWWW Y4YR3A+FR4,37,13,1
 LWWW Y4YR3A+FR5,32,11,1
 LWWW Y4YR3A+FR7,5,3,1
 LWWW Y3RN3C+FR7,10,13,0
 LWWW Y3RN3C+FR8,-10,12,0

#Shawn
 LWWW S4YR3A+FR2,38,5,1
 LWWW S4YR3A+FR3,52,-3,1
 LWWW S4YR3A+FR5,21,11,1
 LWWW S4YR3A+FR6,19,10,1
 LWWW S3RN3A+FR2,8,11,0
 LWWW S3RN3A+FR3,-20,11,0

#BamBam
 LWWW B4YR3A+FR3,37,10,0
 LWWW B4YR3A+FR4,39,8,0
 LWWW B4YR3A+FR5,42,7,0
 LWWW B4YR3A+FR7,-1,6,0
 LWWW B3RN3A+FR1,-14,22,0
 LWWW B3RN3A+FR2,-36,22,0

#Doink
 LWWW D4YR3B+FR1,64,16,1
 LWWW D4YR3B+FR2,60,20,1
 LWWW D4YR3B+FR3,47,19,1
 LWWW D4YR3B+FR4,38,20,1
 LWWW D3RN3B+FR3,16,20,0
 LWWW D3RN3B+FR4,-15,18,0

#Adam
 .long 0

#Lex
 LWWW L4YR3B+FR1,66,16,1
 LWWW L4YR3B+FR2,54,10,1
 LWWW L4YR3B+FR3,38,13,1
 LWWW L4YR3B+FR4,13,11,1
 LWWW L3RN3B+FR2,-5,19,0
 LWWW L3RN3B+FR3,0,13,0

#strt_run_tbl
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung


#*****************************************************************************
*
* CLIMB UP TURNBUCKLES

 SUBR	shn_climb_up_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	5,S2CT2A+FR4
	WL	ANI_CODE,tgt_tbukl
	.word	ANI_LEAPATPOS,24,200,-12,12,0	;#ticks,dist,xoff,yoff,zoff
	.word	ANI_SETPLYRMODE,MODE_INAIR
	WL	6,S2CT2A+FR5
	WL	5,S2CT2A+FR6
	WL	5,S2CT2A+FR7
	WL	4,S2CT2A+FR8
	WL	4,S2CT2A+FR9

	.word	ANI_ZEROVELS
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOGRAVITY
	.word	ANI_SETPLYRMODE,MODE_ONTURNBKL
	.word	ANI_SETFACING
	.word	ANI_SHAKECORNER

	.word	ANI_OFFSET,2,0,0			;x,y,z
	WL	ANI_CODE,tbukl_flip
#repeat
	WL	5,S4SB4B+FR1
	WL	ANI_CODE,tbukl_flip
	WL	5,S4SB4B+FR2
	WL	ANI_CODE,tbukl_flip
	WL	5,S4SB4B+FR3
	WL	ANI_CODE,tbukl_flip
	WL	5,S4SB4B+FR4
	WL	ANI_CODE,tbukl_flip
	WL	5,S4SB4B+FR5
	WL	ANI_CODE,tbukl_flip
	WL	5,S4SB4B+FR6
	WL	ANI_CODE,tbukl_flip
	WL	5,S4SB4B+FR7
	WL	ANI_CODE,tbukl_flip
	WL	5,S4SB4B+FR8
	WL	ANI_CODE,tbukl_flip
	WL	ANI_GOTO,#repeat


#*****************************************************************************
*
* CLIMB DOWN TURNBUCKLES

 SUBR	shn_climb_down_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE | MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SHAKECORNER
	WL	5,S4MP4D+FR1
	.word	ANI_OFFSET,0,15,0
	WL	5,S4MP4D+FR2

	WLW	ANI_SET_XVEL,10000h,AM_FACE_REL
	WLW	ANI_SET_ZVEL,10000h,AM_ABS
	WL	ANI_SET_YVEL,20000h

	.word	ANI_GRAVITY_ON
	WL	8,S4MP4D+FR3
	WL	1,S4MP4D+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,S4MP4D+FR6
	WL	3,S4MP4D+FR7
	WL	3,S4MP4D+FR8

	.word	ANI_FACEDOWN

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


 SUBR	tbukl_flip

;Check to see if opponent is getting in/out of ring, and turn accordingly!
	calla	get_opp_process		;closest opponent process
	move	*a0(INRING),a0		;0 = in ring, 1 = outside

	move	*a13(OBJ_XPOSINT),a14
	cmpi	RING_X_CENTER,a14
	jrlt	#onlft

;On right turnbuckle
	move	a0,a0
	jrnz	#noflip
#yesflip	
	move	*a13(OBJ_CONTROL),a14
	ori	M_FLIPH,a14
	move	a14,*a13(OBJ_CONTROL)
	rets

#noflip
	move	*a13(OBJ_CONTROL),a14
	andni	M_FLIPH,a14
	move	a14,*a13(OBJ_CONTROL)
	rets
#onlft
;On left turnbuckle
	move	a0,a0
	jrnz	#yesflip
	jruc	#noflip

#*****************************************************************************
*
* #3 FLYING KICK

;#yoff1	equ	60

 SUBR	shn_flying_kick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h

	WL	3,S3DC3A+FR3

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	WL	ANI_CODE,get_leap
	WL	ANI_IFSTATUS,#no_xvel

;;If opponent is on ground, just jump in place
;	WL	ANI_CODE,#ckongrnd
;	WL	ANI_IFNOTSTATUS,#norm
;	.ref	dnk_belly_anim
;	WL	ANI_CHANGEANIM,dnk_belly_anim
;#norm
;	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 19,999,150,65,90000h,TGT_HEAD,30,100,0

	WL	ANI_GOTO,#cont

#no_xvel
	.word	ANI_ZERO_XZVELS
	WL	ANI_SET_YVEL,64000h
#cont
;	WL	ANI_CODE,no_bk_xvel
	WL	2,S3DC3A+FR4
	.word	ANI_OFFSET,0,47h,0
	WL	3,S3DC3A+FR5
	WL	7,S3DC3A+FR6

	.word	ANI_CLR_STATUS

	.word	ANI_ATTACK_ON, AMODE_FLYKICK,23,-22,59,40
	WL	3,S3DC3A+FR7
	.word	ANI_ATTACK_OFF

	WL	3,S3DC3A+FR8
	WL	3,S3DC3A+FR9
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKER,15
	WL	5,S3DC3A+FR10
	.word	ANI_XFLIP

	;and now get up

;Getting up, set no_collis
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS+MODE_NOAUTOFLIP	;uninterruptable

	WL	ANI_CODE,choose_2or4
	WL	ANI_IFSTATUS,#getup_in_4

#getup_in_2
	WL	3,S3RL3A+FR6
	WL	3,S3RL3A+FR7
	WL	3,S3RL3A+FR8

	WL	4,S3GU2A+FR2
	WL	4,S3GU2A+FR3
	WL	4,S3GU2A+FR4
	WL	4,S3GU2A+FR5
	WL	4,S3GU2A+FR6
	WL	4,S3GU2A+FR7

	WL	2,S3GU2A+FR8
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,S3GU2A+FR8

	WL	4,S3GU2A+FR9
	.word	ANI_FACEUP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#getup_in_4
	WL	3,S3RL3A+FR4
	WL	3,S3RL3A+FR3
	WL	3,S3RL3A+FR2

	WL	4,S3GU4A+FR2
	WL	4,S3GU4A+FR3
	WL	4,S3GU4A+FR4
	WL	4,S3GU4A+FR5
	WL	4,S3GU4A+FR6
	WL	4,S3GU4A+FR7

	WL	2,S3GU4A+FR8
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,S3GU4A+FR8

	WL	4,S3GU4A+FR9
	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#ckongrnd
	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)

	calla	get_opp_process		;closest opponent process
	move	*a0(PLYRMODE),a0
	cmpi	MODE_ONGROUND,a0
	jrz	#inplace
	rets

#inplace
	move	*a13(ANIMODE),a1
	ori	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets

******************************************************************************
*
* SPECIAL FUNCTIONS

#**********
* If our facings match, go for the knees.  If they differ, go for the chest.
* (jump across the centerline)

elbow_tgt1

	calla	get_opp_process
	move	a0,a11

	move	*a13(FACING_DIR),a0
	move	*a11(FACING_DIR),a1
	andi	MOVE_RIGHT|MOVE_LEFT,a0
	andi	MOVE_RIGHT|MOVE_LEFT,a1
	cmp	a0,a1
	jrne	#head

	movi	TGT_KNEES,a0
	calla	set_target_offsets
	rets

#head
	movi	TGT_CHEST,a0
	calla	set_target_offsets
	rets


#**********
* just like elbow_tgt1, only backwards (stay on one side of the centerline)
*

elbow_tgt2

	calla	get_opp_process
	move	a0,a11

	move	*a13(FACING_DIR),a0
	move	*a11(FACING_DIR),a1
	andi	MOVE_RIGHT|MOVE_LEFT,a0
	andi	MOVE_RIGHT|MOVE_LEFT,a1
	cmp	a0,a1
	jreq	#head

	movi	TGT_GROIN,a0
	calla	set_target_offsets
	rets

#head
	movi	TGT_CHEST,a0
	calla	set_target_offsets
	rets

#*****************************************************************************

 SUBR	shn_roll_frames

	.word	7		;speed
	.long	50000h		;z velocity
	.long	10000h*9/255	;inv multiply (0-255 -> 0-11)

	.long	S3RL3A+FR10	;0
	.long	S3RL3A+FR1	;1
	.long	S3RL3A+FR2	;2
	.long	S3RL3A+FR3	;3
	.long	S3RL3A+FR4	;4
	.long	S3RL3A+FR5	;5
	.long	S3RL3A+FR6	;6
	.long	S3RL3A+FR7	;7
	.long	S3RL3A+FR8	;8
	.long	S3RL3A+FR9	;9
	.long	0,0,0,0,0,0,0

;FIX!!  Make throw out of ring if close to ropes
#*****************************************************************************
*
* FLIP/FALL FROM HIPTOSS

 SUBR	shn_tossed_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,ckzpos

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_GETUP,300
	WL	ANI_CODE,HIT_THE_MAT
	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,50000h
	.word	ANI_OFFSET,15,0,0	;x,y,z

	WL	4,S3CP3B+FR1
	WL	4,S3CP3B+FR2
	WL	4,S3CP3B+FR3
	WL	4,S3CP3B+FR4
	WL	4,S3CP3B+FR5
	WL	4,S3CP3B+FR6

	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	4,S3CP3B+FR7

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,shn_faceup_getup_anim
	.word	ANI_END

;FIX!!  Make throw out of ring if close to ropes
#*****************************************************************************
*
* FLIP/FALL FROM BAM BAM DUCK TOSS

 SUBR	shn_tossed2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,ckzpos

	WLW	ANI_SET_XVEL,60000h,AM_HIT_REL
	WL	ANI_SET_YVEL,30000h
	.word	ANI_OFFSET,20,20,0			;x,y,z
	WL	4,S3OS3X+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_GETUP,300
	.word	ANI_DAMAGE,D_HIPTOSS

	WL	4,S3OS3X+FR9
	WL	4,S3OS3X+FR10

	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,50000h
	.word	ANI_OFFSET,15,0,0	;x,y,z

	WL	4,S3CP3B+FR1
	WL	4,S3CP3B+FR2
	WL	4,S3CP3B+FR3
	WL	4,S3CP3B+FR4
	WL	4,S3CP3B+FR5
	WL	4,S3CP3B+FR6

	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	4,S3CP3B+FR7

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,shn_faceup_getup_anim
	.word	ANI_END

#*****************************************************************************
*

 SUBR	shn_knockdwn_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h
	.word	ANI_XFLIP
 

	WL	2,S3GU4A+FR9
	WL	2,S3GU4A+FR6
	WL	2,S3GU4A+FR4
	WL	ANI_SET_YVEL,39000h

	WL	3,S3CP3B+FR2
	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off
	WL	3,S3CP3B+FR3
	WL	3,S3CP3B+FR4
	WL	3,S3CP3B+FR5
	WL	3,S3CP3B+FR6
	WL	6,S3CP3B+FR7

	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	.word	ANI_SETPLYRMODE,MODE_DEAD
	.word	ANI_END

#nodead

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,shn_faceup_getup_anim

*
 SUBR	shn_climbthru_side_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE | MODE_NOGRAVITY
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS


	WL	3,S3CR3A+FR1
	.word	ANI_OFFSET,0,10,0	;*****
	WL	3,S3CR3A+FR2
	.word	ANI_OFFSET,5,16,0	;*****
	WL	3,S3CR3A+FR3
	.word	ANI_OFFSET,5,16,0	;*****

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE 
	;now jump off...
	WL	ANI_SET_YVEL,40000h

	WLW	ANI_SET_XVEL,48000h,AM_FACE_REL
	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH

	.word	ANI_BENDROPE,2
	.word	ANI_BENDROPE,-1

	WL	3,S3CR3A+FR4
	.word	ANI_WAITHITGND

	.word	ANI_ROPE_Z,R_TOP,RZ_NORM
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM

	.WORD	ANI_XFLIP
	.word	ANI_ZEROVELS

	.word	ANI_OFFSET,5,0,0	;*****
	
	WL	3,S2CT2A+FR8
;	WL	3,S2CT2A+FR9
;	WL	3,S2CT2A+FR10
;	WL	3,S2CT2A+FR11
;	WL	3,S2CT2A+FR12

	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	shn_climbin_side_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	ANI_CODE,SET_DIR_FACE
	.word	ANI_SETFACING

	;jump in
	WL	3,S4MP4D+FR1
	WL	3,S4MP4D+FR2
	WL	3,S4MP4D+FR3
	WL	3,S4MP4D+FR4

	WL	ANI_CODE,#set_trgt
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	.word	ANI_LEAPATPOS,1ch,200,0,0,0	;#ticks,dist,xoff,yoff,zoff

	WL	3,S4MP4D+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,S4MP4D+FR6
	WL	3,S4MP4D+FR7
	WL	3,S4MP4D+FR8

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE | MODE_NOGRAVITY
	WL	3,S3CR3A+FR1
	.word	ANI_OFFSET,0,10,0	;*****
	WL	3,S3CR3A+FR2
	.word	ANI_OFFSET,5,16,0	;*****
	WL	3,S3CR3A+FR3
	.word	ANI_OFFSET,5,16,0	;*****
	WL	3,S3CR3A+FR4

	.word	ANI_BENDROPE,2
	.word	ANI_BENDROPE,-1

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE 
	WLW	ANI_SET_XVEL,50000h,AM_FACE_REL
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.WORD	ANI_XFLIP
	WL	3,S2CT2A+FR8
;	WL	3,S2CT2A+FR9
;	WL	3,S2CT2A+FR10
;	WL	3,S2CT2A+FR11
;	WL	3,S2CT2A+FR12
	.WORD	ANI_XFLIP

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

 SUBR	shn_climbthru_bot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

;Must rotate toward ropes!
;Do a different sequence

	;lie down
	WL	ANI_CODE,#ckspin
	WL	3,S3GU2A+FR9
	WL	3,S3GU2A+FR8
	WL	3,S3GU2A+FR7
	WL	3,S3GU2A+FR6
	WL	3,S3GU2A+FR5
	WL	3,S3GU2A+FR4
	WL	3,S3GU2A+FR2

	;roll over once
	WLW	ANI_SET_ZVEL,0A8000h,AM_ABS

	WL	3,S3RL3A+FR1
	WL	3,S3RL3A+FR2
	WL	3,S3RL3A+FR3
	WL	3,S3RL3A+FR4
	WL	3,S3RL3A+FR5
	WL	3,S3RL3A+FR6
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP+MODE_NOSHADOW

	;climb through
	.WORD	ANI_XFLIP
	WL	ANI_CODE,NOT_IN_RING
	.word	ANI_OFFSET,20,-37h,0			;x,y,z
	WL	3,S4KI3Q+FR5
	WL	3,S4KI3Q+FR4
	WL	3,S4KI3Q+FR3
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

 SUBR	shn_climbin_bot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;climb in
	.word	ANI_GRAVITY_OFF
	.WORD	ANI_XFLIP
	WL	3,S4KI3Q+FR3
	WL	3,S4KI3Q+FR4
	WL	3,S4KI3Q+FR5
	.word	ANI_OFFSET,-20,37h,-60

	;roll
	WLW	ANI_SET_ZVEL,-70000h,AM_ABS
	.word	ANI_FRICTION,3000h
	WL	3,S3RL3A+FR6
	WL	3,S3RL3A+FR5
	WL	3,S3RL3A+FR4
	WL	3,S3RL3A+FR3
	WL	3,S3RL3A+FR2
	WL	3,S3RL3A+FR1
	.word	ANI_ZEROVELS
	.word	ANI_GRAVITY_ON

	;get up
	WL	3,S3GU2A+FR2
	WL	3,S3GU2A+FR3
	WL	3,S3GU2A+FR4
	WL	3,S3GU2A+FR5
	WL	3,S3GU2A+FR6
	WL	3,S3GU2A+FR7
	WL	3,S3GU2A+FR8
	WL	3,S3GU2A+FR9

	WL	ANI_CODE,clr_climb

	.WORD	ANI_FACEDOWN
	.word	ANI_ZEROVELS
	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	shn_climbthru_top_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;lie down
	WL	ANI_CODE,#set_zvel1
	WL	ANI_IFSTATUS,#dir4
;Facing #2
	WL	3,S1TT5Z+FR2
	WL	3,S1TT5Z+FR3
	
#dir4
	WL	3,S3GU4A+FR9
	WL	3,S3GU4A+FR8
	WL	3,S3GU4A+FR7
	WL	3,S3GU4A+FR6
	WL	3,S3GU4A+FR5
	WL	3,S3GU4A+FR4
	WL	3,S3GU4A+FR3
	WL	3,S3GU4A+FR2

	;roll over once
	WL	ANI_CODE,#set_zvel2
	WL	3,S3RL3A+FR10
	WL	3,S3RL3A+FR9
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP+MODE_NOSHADOW
	WL	3,S3RL3A+FR8
	WL	3,S3RL3A+FR7
	WL	3,S3RL3A+FR6

	;climb through
	.word	ANI_ZEROVELS
	.WORD	ANI_XFLIP
	WL	3,S3DC3A+FR7
	WL	3,S3DC3A+FR6
	WL	3,S3DC3A+FR5
	.word	ANI_OFFSET,0,-61,0
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

 SUBR	shn_climbin_top_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;climb in
	.word	ANI_OFFSET,0,61,0
	WL	3,S3DC3A+FR5
	WL	3,S3DC3A+FR6
	WL	3,S3DC3A+FR7
	.WORD	ANI_XFLIP

	;roll over
	WL	ANI_CODE,#set_zvel2
	WL	3,S3RL3A+FR7	
	WL	3,S3RL3A+FR8
	WL	3,S3RL3A+FR9
	WL	3,S3RL3A+FR10

	.word	ANI_ZEROVELS

	;get up
	WL	3,S3GU4A+FR2
	WL	3,S3GU4A+FR3
	WL	3,S3GU4A+FR4
	WL	3,S3GU4A+FR5
	WL	3,S3GU4A+FR6
	WL	3,S3GU4A+FR7
	WL	3,S3GU4A+FR8
	WL	3,S3GU4A+FR9

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

 SUBR	shn_2_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;Rotate!
	WL	3,S1TT5Z+FR2	;2.5
	WL	3,S1TT5Z+FR3	;3.5
	WL	ANI_GOTO,#cont

 SUBR	shn_4_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

#cont
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 25,999,80h,50h,90000h,TGT_CHEST,0,57,-15

	WL	3,S3PN5C+FR1
	.word	ANI_OFFSET,0,31,0			;x,y,z
	WL	18,S3PN5C+FR2
	WL	4,S3PN5C+FR3
;	.word	ANI_WAITHITGND
	.word	ANI_ATTACK_ON_Z, AMODE_STOMP,-40,-8,0,76,20,30 ;mode,x,y,z,w,h,d
	.word	ANI_ZEROVELS

	WL	3,S3PN5C+FR7
	WL	ANI_CODE,DO_CROWD_CHEER

	.word	ANI_ATTACK_OFF
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_BOUNCE,4
	WL	3,S3PN5C+FR7
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE

	WL	4,S3PN5C+FR7
	WL	ANI_CODE,win_announce
	.word	ANI_OFFSET,0,0,0			;x,y,z
	WL	40,S3PN5C+FR7

;???? IS THIS WHERE IT GOES ?
	.word	ANI_LOOP

;Do another ground hit on opponent
	WL	ANI_CODE,grnd_hit

	WL	ANI_SET_YVEL,42000h
	WLW	ANI_SET_ZVEL,22000h,AM_ABS
	WL	4,S3GU4A+FR4
	WL	4,S3GU4A+FR5
	WL	4,S3GU4A+FR6
	WL	4,S3GU4A+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	4,S3GU4A+FR8
	WL	4,S3GU4A+FR9

	WL	5,S4SW4A+FR1
	WL	5,S4SW4A+FR2
	WL	5,S4SW4A+FR3
	WL	5,S4SW4A+FR4
	WL	5,S4SW4A+FR5
	WL	5,S4SW4A+FR6
	WL	5,S4SW4A+FR7
	WL	5,S4SW4A+FR8
	WL	5,S4SW4A+FR9
	WL	1000,S4SW4A+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************

;Leap up onto nearest turnbuckle.  Call with ANI_CODE to set offsets
; before doing the ANI_LEAPATPOS.

 SUBR	tgt_tbukl

	;figure out which one to climb.
	movi	vln_right_rope,a0
	move	*a13(OBJ_XPOSINT),a14
	cmpi	RING_X_CENTER,a14
	jrgt	#right
	movi	vln_left_rope,a0
#right

	move	*a0+,a1,W		;X
	move	*a0+,a2,W		;Z
	subi	16,a2
	movi	MAT_Y+80,a3		;Y

	move	a1,*a13(TGT_XOFF)
	move	a2,*a13(TGT_ZOFF)
	move	a3,*a13(TGT_YOFF)

	rets

#*****************************************************************************
* #4 SLAP

 SUBR	shn_2_slap_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_LEAPING,17
	WL	2,S1TT5Z+FR2	;2.5
	WL	2,S1TT5Z+FR3	;3.5

 SUBR	shn_4_slap_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_LEAPING,15
	WL	3,S4PT3B+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 0dh,999,4ah,50,90000h,TGT_HEAD,76,110,30

	.word	ANI_CLR_STATUS
	WL	3,S4PT3B+FR2
	WL	4,S4PT3B+FR3
	WL	3,S4PT3B+FR4
	WL	3,S4PT3B+FR5

	.word	ANI_ATTACK_ON, AMODE_BACKHAND,31,44,55,47	;mode,x,y,w,h
	WL	3,S4PT3B+FR6

	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-50000h,#no_hit2

	WL	ANI_SET_YVEL,40000h
	WL	10,S4PT3B+FR6
#no_hit2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS


	WL	8,S4PT3B+FR6
	WL	3,S4PT3B+FR7
	WL	3,S4PT3B+FR8
	WL	3,S4PT3B+FR9

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


******************************************************************************
	.end
