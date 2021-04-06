**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		2/1/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"rzrseq2.asm"
	.title	"Razor Ramon animation sequences"
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
	.include	"ring.equ"

	.include	"razorimg.h"
	.include	"damage.equ"


******************************************************************************
* EXTERNAL REFERENCES
  
	;BRET
	.ref	H3RN3A,H4YR3A

	;BAM BAM
	.ref	B3RN3A,B4YR3A

	;DOINK
	.ref	D3RN3B,D4YR3B

	;LEX
	.ref	L3RN3B,L4YR3B

	;RAZOR
	.ref	rzr_facedown_getup_anim,rzr_faceup_getup_anim
	.ref	rzr_faceup_getup2_anim

	;SHAWN
	.ref	S3RN3A,S4YR3A

	;TAKER
	.ref	U3RN3A,U4YR3B

	;YOKO
	.ref	Y3RN3C,Y4YR3A

	;MISC
	.ref	start_run_anim,SET_DIR_FACE,start_run_flung,CALL_MISSES
	.ref	ckzpos,ck_dizzy,HIT_THE_MAT,SMALL_BOUNCE,win_announce
	.ref	grnd_hit,no_bk_xvel,check_xvel

	.ref	HIT_THE_MAT
	.REF	DO_CROWD_CHEER
	.ref	tbukl_flip

;XXX Start
#*****************************************************************************
*
* NORMAL #2 PUNCH

 SUBR	rzr_2_punch_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	3,R2PU3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_PUNCH,6

	WL	3,R2PU3A+FR2
	WL	3,R2PU3A+FR3

	.word	ANI_ATTACK_ON,AMODE_PUNCH,23,95,56,11 ;mode,x,y,w,h
	WL	3,R2PU3A+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-48000h,#no_hit
	WL	ANI_SET_YVEL,38000h
#no_hit

	WL	3,R2PU3A+FR4
	WL	3,R2PU3A+FR5
	WL	3,R2PU3A+FR6
	WL	3,R2PU3A+FR7

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,R2PU3A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* NORMAL #4 PUNCH

 SUBR	rzr_4_punch_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	3,R4PU3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_PUNCH,6
	WL	3,R4PU3A+FR2
	WL	3,R4PU3A+FR3

	.word	ANI_ATTACK_ON,AMODE_PUNCH,23,95,56,11 ;mode,x,y,w,h
	WL	3,R4PU3A+FR4
	.word	ANI_ATTACK_OFF


	WWL	ANI_SLIDE_BACK,30h,-48000h,#no_hit
	WL	ANI_SET_YVEL,38000h
#no_hit

	WL	3,R4PU3A+FR4
	WL	3,R4PU3A+FR5
	WL	3,R4PU3A+FR6
	WL	3,R4PU3A+FR7

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,R4PU3A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #3 BLADE SLASH

 SUBR	rzr_3_slash_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS

	WL	3,R3RZ3S+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_PUNCH,6
	WL	3,R3RZ3S+FR3
	WL	3,R3RZ3S+FR4

	.word	ANI_ATTACK_ON,AMODE_PUNCH,42,50,57,101
	WL	3,R3RZ3S+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-48000h,#no_hit
	WL	ANI_SET_YVEL,38000h
#no_hit

	WL	3,R3RZ3S+FR7
	WL	3,R3RZ3S+FR8
	WL	3,R3RZ3S+FR9

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,R3RZ3S+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

;XXX End
#*****************************************************************************
*
* #2 UPPERCUT

 SUBR	rzr_2_uprcut_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_STARTATTACK,AT_UPRCUT,6
	WL	2,R2UP3A+FR5
	WL	2,R2UP3A+FR6
	WL	2,R2UP3A+FR7

	.word	ANI_ATTACK_ON,AMODE_UPRCUT,30,77,42,65
	WL	7,R2UP3A+FR8
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-48000h,#no_hit
	WL	ANI_SET_YVEL,38000h
#no_hit

	WL	5,R2UP3A+FR9
	WL	5,R2UP3A+FR10
	WL	4,R2UP3A+FR11
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #4 UPPERCUT

 SUBR	rzr_4_uprcut_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_STARTATTACK,AT_UPRCUT,6
	WL	2,R4UP3C+FR1
	WL	2,R4UP3C+FR2
	WL	2,R4UP3C+FR3

	.word	ANI_ATTACK_ON,AMODE_UPRCUT,30,77,42,65
	WL	7,R4UP3C+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-48000h,#no_hit
	WL	ANI_SET_YVEL,38000h
#no_hit

	WL	4,R4UP3C+FR5
	WL	4,R4UP3C+FR6
	WL	3,R4UP3C+FR7
	WL	3,R4UP3C+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

;XXX Start
#*****************************************************************************
*
* #2 HEADBUTT

 SUBR	rzr_2_butt_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	2,R2BC3B+FR1
	WL	2,R2BC3B+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_HDBUTT,4
	WL	2,R2BC3B+FR3
	WL	2,R2BC3B+FR4

	.word	ANI_ATTACK_ON,AMODE_HDBUTT,19,87,23,22
	WL	3,R2BC3B+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-48000h,#no_hit
	WL	ANI_SET_YVEL,38000h
#no_hit
	WL	3,R2BC3B+FR6
	WL	3,R2BC3B+FR7

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,R2BC3B+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 HEADBUTT

 SUBR	rzr_4_butt_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	2,R4BC3A+FR1
	WL	2,R4BC3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_HDBUTT,4
	WL	2,R4BC3A+FR3
	WL	2,R4BC3A+FR4

	.word	ANI_ATTACK_ON,AMODE_HDBUTT,29,93,23,19
	WL	3,R4BC3A+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-48000h,#no_hit
	WL	ANI_SET_YVEL,38000h
#no_hit
	WL	3,R4BC3A+FR6
	WL	3,R4BC3A+FR7

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,R4BC3A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* NORMAL #2 KICK

 SUBR	rzr_2_kick_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	WL	2,R4KM3A+FR1
	WL	2,R4KM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KICK,4
	WL	2,R4KM3A+FR3
	WL	2,R4KM3A+FR4

	.word	ANI_ATTACK_ON,AMODE_KICK,8,15,75,75	;mode,x,y,w,h
	WL	2,R4KM3A+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-50000h,#no_slide
	WL	ANI_SET_YVEL,30000h
#no_slide
	WL	6,R4KM3A+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,R4KM3A+FR6
	WL	3,R4KM3A+FR7
	WL	3,R4KM3A+FR8
	WL	3,R2KM3X+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* NORMAL #4 KICK

 SUBR	rzr_4_kick_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	WL	2,R4KM3A+FR1
	WL	2,R4KM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KICK,4
	WL	2,R4KM3A+FR3
	WL	2,R4KM3A+FR4

	.word	ANI_ATTACK_ON,AMODE_KICK,8,15,75,75	;mode,x,y,w,h
	WL	2,R4KM3A+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-50000h,#no_slide
	WL	ANI_SET_YVEL,30000h
#no_slide
	WL	6,R4KM3A+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,R4KM3A+FR6
	WL	3,R4KM3A+FR7
	WL	3,R4KM3A+FR8
	WL	3,R4KM3A+FR9
	WL	3,R4KM3A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


;XXX End
#*****************************************************************************
*
* #2 KNEE

 SUBR	rzr_2_knee_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	WL	2,R2NM3A+FR1
	WL	2,R2NM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KNEE,6
	WL	2,R2NM3A+FR3
	WL	2,R2NM3A+FR4
	WL	2,R2NM3A+FR5

	.word	ANI_ATTACK_ON,AMODE_KNEE,22,55,38,27	;mode,x,y,w,h
	WL	3,R2NM3A+FR6
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-50000h,#no_slide
	WL	ANI_SET_YVEL,30000h
#no_slide

	WL	6,R2NM3A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,R2NM3A+FR7
	WL	3,R2NM3A+FR8
	WL	3,R2NM3A+FR9
	WL	3,R2NM3A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #4 KNEE

 SUBR	rzr_4_knee_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	WL	2,R4NM3C+FR1
	WL	2,R4NM3C+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KNEE,6
	WL	2,R4NM3C+FR3
	WL	2,R4NM3C+FR4
	WL	2,R4NM3C+FR5

	.word	ANI_ATTACK_ON,AMODE_KNEE,22,55,38,27	;mode,x,y,w,h
	WL	3,R4NM3C+FR6
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-50000h,#no_slide
	WL	ANI_SET_YVEL,30000h
#no_slide

	WL	6,R4NM3C+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,R4NM3C+FR7
	WL	3,R4NM3C+FR8
	WL	3,R4NM3C+FR9
	WL	3,R4NM3C+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


;XXX Start
#*****************************************************************************
*
* #2 PUNCH FALLEN OPPONENT

 SUBR	rzr_2_ground_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,R2PF2B+FR2

	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,8,0,-40,16,43,50
	WL	1,R2PF2B+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#no_leapat

	;leapat...
	.word	ANI_TARGET,TGT_KNEES,TGT_CHEST,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 12,999,112,96,90000h,TGT_USER,19,0,-40
	WL	ANI_CODE,no_bk_xvel
	.word	ANI_STARTATTACK,AT_LBDROP,12

	WL	4,R2PF2B+FR3
	WL	4,R2PF2B+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,SMALL_BOUNCE
	WL	ANI_GOTO,#common

#no_leapat
	.word	ANI_STARTATTACK,AT_LBDROP,14
	WL	4,R2PF2B+FR3
	WL	4,R2PF2B+FR5
#common
	WL	3,R2PF2B+FR6
	WL	3,R2PF2B+FR7
	.word	ANI_ATTACK_ON_Z,AMODE_LBOWDROP,8,0,-50,16,43,60
	WL	7,R2PF2B+FR8
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_SHAKER,15
	.word	ANI_SHAKEALL,1

	WL	3,R2PF2B+FR9
	WL	3,R2PF2B+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
	WL	3,R2PF2B+FR9
	WL	3,R2PF2B+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 PUNCH FALLEN OPPONENT

 SUBR	rzr_4_ground_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	4,R4PF4B+FR2

	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,0,-1,-10,22,30,50
	WL	1,R4PF4B+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#no_leapat

	;leapat...
	.word	ANI_TARGET,TGT_KNEES,TGT_CHEST,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 12,999,112,96,90000h,TGT_USER,13,0,40
	WL	ANI_CODE,no_bk_xvel
	.word	ANI_STARTATTACK,AT_LBDROP,12

	WL	4,R4PF4B+FR3
	WL	4,R4PF4B+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,SMALL_BOUNCE
	WL	ANI_GOTO,#common

#no_leapat
	.word	ANI_STARTATTACK,AT_LBDROP,14
	WL	4,R4PF4B+FR3
	WL	4,R4PF4B+FR4
#common
	WL	3,R4PF4B+FR5
	WL	3,R4PF4B+FR7
	.word	ANI_ATTACK_ON_Z,AMODE_LBOWDROP,0,-1,-10,22,30,60
	WL	1,R4PF4B+FR8
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_SHAKER,15
	.word	ANI_SHAKEALL,1
	WL	6,R4PF4B+FR8
	WL	4,R4PF4B+FR9
	WL	4,R4PF4B+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
	WL	6,R4PF4B+FR8
	WL	4,R4PF4B+FR9
	WL	4,R4PF4B+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #3 FLYING KICK

#yoff	equ	52

 SUBR	rzr_flying_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_FLYKICK,25
	WL	3,R3DC3C+FR1
	WL	3,R3DC3C+FR2
	WL	3,R3DC3C+FR3

	.word	ANI_OFFSET,0,#yoff,0

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,145,65,90000h,TGT_HEAD,65,30,0
	WL	ANI_CODE,no_bk_xvel

	.word	ANI_SETPLYRMODE,MODE_INAIR

	WL	8,R3DC3C+FR4
	WL	8,R3DC3C+FR5
	.word	ANI_ATTACK_ON,AMODE_FLYKICK,30,11,56,39
	WL	2,R3DC3C+FR6
	WL	6,R3DC3C+FR7
	.word	ANI_ATTACK_OFF
	WL	4,R3DC3C+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	WL	3,R3DC3C+FR9
	WL	3,R3DC3C+FR10
	.word	ANI_XFLIP
	WL	3,R3RL1B+FR6
	WL	ANI_CHANGEANIM,rzr_facedown_getup_anim


;XXX End
#*****************************************************************************
*
* GRAB & THROW

 SUBR	rzr_grab_throw_anim

	.word	ANI_END

#*****************************************************************************
*
* #2 STOMP ON FALLEN OPPONENT

 SUBR	rzr_2_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	3,R2MP2A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_STOMP,15
	WL	3,R2MP2A+FR2
	WL	2,R2MP2A+FR3

	;if we're going to miss, do a leapat
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,0,-1,-40,17,32,50
	WL	1,R2MP2A+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#leapat_stomp

	WL	3,R2MP2A+FR4
	WL	3,R2MP2A+FR5
	WL	3,R2MP2A+FR6
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,-4,-5,-40,25,40,50
	WL	3,R2MP2A+FR7
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#hit
	WL	ANI_CODE,CALL_MISSES
#hit
	WL	3,R2MP2A+FR8
	WL	3,R2MP2A+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#leapat_stomp

	.word	ANI_TARGET,TGT_GROIN,TGT_CHEST,ATM_CLOSEST
	;too far.  leap at the chest.
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 14,999,112,96,90000h,TGT_USER,12,0,-40
	WL	ANI_CODE,no_bk_xvel
	.word	ANI_STARTATTACK,AT_STOMP,14
	
	WL	3,R2MP2A+FR4
	WL	3,R2MP2A+FR5
	WL	3,R2MP2A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,-4,-5,-40,25,40,50
	WL	3,R2MP2A+FR7
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#leapat_hit
	WL	ANI_CODE,CALL_MISSES
#leapat_hit
	WL	3,R2MP2A+FR8
	WL	3,R2MP2A+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #4 STOMP ON FALLEN OPPONENT

 SUBR	rzr_4_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	4,R4MP4D+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_STOMP,20
	WL	3,R4MP4D+FR2

	;if we're going to miss, do a leapat
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,9,-11,-10,19,36,50
	WL	1,R4MP4D+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#leapat_stomp

	WL	4,R4MP4D+FR3
	WL	4,R4MP4D+FR4
	WL	4,R4MP4D+FR5
	WL	4,R4MP4D+FR6
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,5,-15,-10,27,44,50
	WL	4,R4MP4D+FR7
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#hit
	WL	ANI_CODE,CALL_MISSES
#hit
	WL	4,R4MP4D+FR8
	WL	4,R4MP4D+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#leapat_stomp

	.word	ANI_TARGET,TGT_GROIN,TGT_CHEST,ATM_CLOSEST
	;too far.  leap at the chest.
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 14,999,112,96,90000h,TGT_USER,16,0,40
	WL	ANI_CODE,no_bk_xvel
	.word	ANI_STARTATTACK,AT_STOMP,14

	WL	3,R4MP4D+FR3
	WL	3,R4MP4D+FR4
	WL	3,R4MP4D+FR5
	WL	3,R4MP4D+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,5,-15,-10,27,44,50
	WL	4,R4MP4D+FR7
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#leapat_hit
	WL	ANI_CODE,CALL_MISSES
#leapat_hit
	WL	4,R4MP4D+FR8
	WL	4,R4MP4D+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #3 RUNNING ELBOW DROP

#yoff	equ	40

 SUBR	rzr_flying_elbow_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_STOMP,36

	WL	3,R4PJ4B+FR1
	WL	3,R4PJ4B+FR2

	.word	ANI_TARGET,TGT_GROIN,TGT_HEAD,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 30,999,112,96,90000h,TGT_USER,-39,0,30
	WL	ANI_CODE,no_bk_xvel

	.word	ANI_SETPLYRMODE,MODE_INAIR

	.word	ANI_OFFSET,0,#yoff,0
	WL	3,R4PJ4B+FR3
	WL	3,R4PJ4B+FR4
	WL	3,R4PJ4B+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,-49,-7,-10,46,31,50
	WL	1,R4PJ4B+FR6
	.word	ANI_ATTACK_OFF

	WL	ANI_SET_YVEL,40000h
	.word	ANI_SHAKER,45
	.word	ANI_SHAKEROPES,2

	WL	ANI_IFSTATUS,#hit

	WL	ANI_CODE,CALL_MISSES

#hit
	WL	7,R4PJ4B+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_XFLIP
	WL	4,R3GU4A+FR3
	WL	ANI_CHANGEANIM,rzr_faceup_getup2_anim

#*****************************************************************************
*
* TURNBUCKLE ELBOW

#yoff	equ	40

 SUBR	rzr_tbukl_elbow_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCONFINE|MODE_NOCOLLIS|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING

	.word	ANI_STARTATTACK,AT_BSTOMP,39

	WL	3,R4PJ4B+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 36,190,190,190,90000h,TGT_GROIN,-15,#yoff,40
	WL	ANI_CODE,check_xvel

	.word	ANI_SETPLYRMODE,MODE_INAIR2
	.word	ANI_GRAVITY_ON
	.word	ANI_SHAKECORNER

	WL	3,R4PJ4B+FR2
	.word	ANI_OFFSET,0,#yoff,0
	WL	3,R4PJ4B+FR3
	WL	3,R4PJ4B+FR4
	WL	1,R4PJ4B+FR5

	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-64,27,-10,44,38,70
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SOUND,0C1h			;plywood crash #3

	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#hit

	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,1
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_BOUNCE,5
	WL	7,R4PJ4B+FR6
	.word	ANI_WAITHITGND
	.word	ANI_XFLIP
	.word	ANI_FACEDOWN
	WL	4,R3GU4A+FR3
	WL	ANI_CHANGEANIM,rzr_faceup_getup2_anim

#hit
	WL	ANI_SET_YVEL,50000h
	WLW	ANI_SET_ZVEL,-10000h,AM_ABS
	.word	ANI_SETMODE,MODE_INAIR

	.word	ANI_SHAKER,45
	.word	ANI_SHAKEALL,2
	WL	1,R4PJ4B+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SOUND,0C1h			;plywood crash #3
	WL	4,R4PJ4B+FR6
	.word	ANI_XFLIP
	.word	ANI_FACEDOWN
	WL	4,R3GU4A+FR3
	WL	ANI_CHANGEANIM,rzr_faceup_getup2_anim

#*****************************************************************************
*
* SECOND WIND

 SUBR	rzr_2ndwind_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	WL	3,R4SW4Z+FR1
	WL	3,R4SW4Z+FR2
	WL	3,R4SW4Z+FR3
	WL	3,R4SW4Z+FR4

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* GRAB & FLING OPPONENT (INTO A RUN)

 SUBR	rzr_2_grabfling_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_STARTATTACK,AT_PUPPET,14
	WL	3,R1TT5Z+FR2
	WL	3,R1TT5Z+FR3
	WL	ANI_GOTO,#cont

 SUBR	rzr_4_grabfling_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,8
#cont
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,40,0,25
	WL	ANI_SET_YVEL,0000h
	WL	4,R4GF3B+FR1

	.word	ANI_ATTACK_ON,AMODE_PUPPET,31h,56,44,18 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,R4GF3B+FR2
;	WL	4,R4GF3B+FR2
	.word	ANI_ZERO_XZVELS
	WWL	ANI_WAITHITOPP,4,R4GF3B+FR3
;	WL	4,R4GF3B+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	WL	ANI_IFBLOCKED,#missedb

;got him


;	out of control time for fling?

	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

; attacker sequence
	WWLLW	ANI_SUPERSLAVE2,10,R4GF3B+FR3,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,7,R4GF3B+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,5,R4GF3B+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,5,R4GF3B+FR6,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,5,R4GF3B+FR7,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,5,R4GF3B+FR8,#puppet_tbl,5

	WL	ANI_SLAVEANIM,#strt_run_tbl

	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_DETACH
	WL	12,R4GF3B+FR9
	WL	4,R4GF3B+FR10
	.word	ANI_OFFSET,-10,0,0			;x,y,z

	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WL	25,R4GF3B+FR3
#missed
	WL	ANI_CODE,CALL_MISSES


	WL	8,R4GF3B+FR3
	WL	4,R4GF3B+FR2
	WL	4,R4GF3B+FR1

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
 LWWW H4YR3A+FR1,68,7,1
 LWWW H4YR3A+FR2,60,5,1
 LWWW H4YR3A+FR3,52,-1,1
 LWWW H4YR3A+FR5,27,1,1
 LWWW H3RN3A+FR1,3,-2,0
 LWWW H3RN3A+FR2,-1,-2,0
#Razor
 LWWW R4YR3A+FR1,53,17,0
 LWWW R4YR3A+FR2,34,14,0
 LWWW R4YR3A+FR3,14,3,0
 LWWW R4YR3A+FR4,-10,0,0
 LWWW R3RN3D+FR11,-7,11,0
 LWWW R3RN3D+FR12,-6,9,0
#Taker
 LWWW U4YR3B+FR2,48,18,0
 LWWW U4YR3B+FR3,44,11,0
 LWWW U4YR3B+FR4,21,10,0
 LWWW U4YR3B+FR5,5,10,0
 LWWW U3RN3A+FR2,-13,10,0
 LWWW U3RN3A+FR2,-15,7,0
#Yokozuna
 LWWW Y4YR3A+FR1,68,11,1
 LWWW Y4YR3A+FR4,40,9,1
 LWWW Y4YR3A+FR5,24,1,1
 LWWW Y4YR3A+FR7,-8,-9,1
 LWWW Y3RN3C+FR7,19,8,0
 LWWW Y3RN3C+FR8,20,4,0
#Shawn
 LWWW S4YR3A+FR2,41,5,1
 LWWW S4YR3A+FR3,52,-7,1
 LWWW S4YR3A+FR5,15,0,1
 LWWW S4YR3A+FR6,6,-4,1
 LWWW S3RN3A+FR2,19,5,0
 LWWW S3RN3A+FR3,0,4,0
#BamBam
 LWWW B4YR3A+FR3,36,13,0
 LWWW B4YR3A+FR4,46,5,0
 LWWW B4YR3A+FR5,46,0,0
 LWWW B4YR3A+FR7,-3,-7,0
 LWWW B3RN3A+FR1,16,8,0
 LWWW B3RN3A+FR2,17,7,0
#Doink
 LWWW D4YR3B+FR1,74,13,1
 LWWW D4YR3B+FR2,62,13,1
 LWWW D4YR3B+FR3,43,6,1
 LWWW D4YR3B+FR4,19,5,1
 LWWW D3RN3B+FR3,19,12,0
 LWWW D3RN3B+FR4,-8,8,0
#Adam
 .long 0
#Lex
 LWWW L4YR3B+FR1,67,11,1
 LWWW L4YR3B+FR2,47,2,1
 LWWW L4YR3B+FR3,27,-2,1
 LWWW L4YR3B+FR4,-31,-4,1
 LWWW L3RN3B+FR2,-2,10,0
 LWWW L3RN3B+FR3,8,3,0

#strt_run_tbl
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung

#*****************************************************************************
*
* HELD OVERHEAD ANIMATION

 SUBR	rzr_heldoh_anim

	.word	ANI_SETPLYRMODE,MODE_ATTACHED
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_SETSPEED,100h

	.word	ANI_SETWORD,USR_VAR1,0		;loop count

#loop
	WL	3,R4MF4B+FR1
	WL	3,R4MF4B+FR2
	WL	3,R4MF4B+FR3
	WL	3,R4MF4B+FR4
	WL	3,R4MF4B+FR5
	WL	3,R4MF4B+FR6
	WL	3,R4MF4B+FR7
	WL	3,R4MF4B+FR8
	WL	3,R4MF4B+FR9

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

	WL	2,R4MF4B+FR6
	.word	ANI_OFFSET,-20,-50,0			;x,y,z
	WL	4,R3MS3Z+FR4
	WL	4,R3MS3Z+FR3
	WL	4,R3MS3Z+FR2
	WL	4,R3MS3Z+FR1
	.word	ANI_WAITHITGND
	WL	2,R2ST2C+FR3

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
* #2 PUSH

 SUBR	rzr_2_push_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUSH,15
	WL	3,R2PS3A+FR1
	WL	3,R2PS3A+FR2
	WL	3,R2PS3A+FR3
	WL	3,R2PS3A+FR4
	WL	3,R2PS3A+FR5
	.word	ANI_ATTACK_ON, AMODE_PUSH,31,94,46,15
	WL	3,R2PS3A+FR6
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,40h,-60000h,#no_hit	;range,vel,addr
	WL	15,R2PS3A+FR6
#no_hit
	WL	4,R2PS3A+FR6
	WL	4,R2PS3A+FR7
	WL	4,R2PS3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #4 PUSH

 SUBR	rzr_4_push_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h


	.word	ANI_STARTATTACK,AT_PUSH,18
	WL	3,R4PS3A+FR1
	WL	3,R4PS3A+FR2
	WL	3,R4PS3A+FR3
	WL	3,R4PS3A+FR4
	WL	3,R4PS3A+FR5
	WL	3,R4PS3A+FR6
	.word	ANI_ATTACK_ON, AMODE_PUSH,45,98,48,14
	WL	3,R4PS3A+FR7
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,40h,-60000h,#no_hit	;range,vel,addr
	WL	15,R4PS3A+FR7
#no_hit
	WL	4,R4PS3A+FR7
	WL	4,R4PS3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

;XXX Start
#*****************************************************************************
*
* #4 BIG BOOT

 SUBR	rzr_4_bigboot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	.word	ANI_STARTATTACK,AT_BIGBOOT,13
	WL	3,R4BG3A+FR1
	WL	3,R4BG3A+FR2
	WL	3,R4BG3A+FR3
	WL	2,R4BG3A+FR4
	WL	2,R4BG3A+FR5

	.word	ANI_ATTACK_ON,AMODE_BIGBOOT,59,77,32,20 ;mode,x,y,w,h
	WL	4,R4BG3A+FR6
	.word	ANI_WAITRELEASE,PLAYER_KICK_BIT
	.word	ANI_ATTACK_OFF

	WL	4,R4BG3A+FR7
	WL	4,R4BG3A+FR8
	WL	4,R4BG3A+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

;XXX End
#*****************************************************************************
*
* RAISE ARM IN VICTORY

 SUBR	rzr_raisearm_anim

	.word	ANI_SETMODE,MODE_UNINT		;uninterruptable
	.word	ANI_ZEROVELS

	.word	ANI_ENDMATCH
	.word	ANI_REPEAT


#*****************************************************************************

 SUBR	rzr_roll_frames

	.word	7		;speed
	.long	50000h		;z velocity
	.long	10000h*10/255	;inv multiply (0-255 -> 0-10)

	.long	R3RL1B+FR1	;0
	.long	R3RL1B+FR2	;1
	.long	R3RL1B+FR3	;2
	.long	R3RL1B+FR4	;3
	.long	R3RL1B+FR5	;4
	.long	R3RL1B+FR6	;5
	.long	R3RL1B+FR7	;6
	.long	R3RL1B+FR8	;7
	.long	R3RL1B+FR9	;8
	.long	R3RL1B+FR10	;9
	.long	R3RL1B+FR11	;10
	.long	0,0,0,0,0,0


;FIX!!  Make throw out of ring if close to ropes
#*****************************************************************************
*
* FLIP/FALL FROM HIPTOSS

 SUBR	rzr_tossed_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

;	.word	ANI_XFLIP

	WL	ANI_CODE,ckzpos

;MJT Start
	.word	ANI_GETUP,300
;MJT End
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	ANI_CODE,HIT_THE_MAT
	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,50000h

	WL	4,R3AM3D+FR2
	WL	4,R3AM3D+FR3
	WL	4,R3AM3D+FR4
	WL	4,R3AM3D+FR5
	WL	4,R3AM3D+FR6
	WL	4,R3AM3D+FR7

	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,R3AM3D+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,rzr_faceup_getup_anim
	.word	ANI_END

;FIX!!  Make throw out of ring if close to ropes
#*****************************************************************************
*
* FLIP/FALL FROM BAM BAM DUCK TOSS

 SUBR	rzr_tossed2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,ckzpos

	WLW	ANI_SET_XVEL,60000h,AM_HIT_REL
	WL	ANI_SET_YVEL,30000h
	.word	ANI_OFFSET,20,20,0			;x,y,z
	WL	4,R3TD3A+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_GETUP,300
	.word	ANI_DAMAGE,D_HIPTOSS

	WL	4,R3TD3A+FR8
	.WORD	ANI_XFLIP
	WL	3,R3GU2A+FR1

	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,50000h

	WL	4,R3AM3D+FR2
	WL	4,R3AM3D+FR3
	WL	4,R3AM3D+FR4
	WL	4,R3AM3D+FR5
	WL	4,R3AM3D+FR6
	WL	4,R3AM3D+FR7

	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,R3AM3D+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,rzr_faceup_getup_anim
	.word	ANI_END

******************************************************************************
*
 SUBR	rzr_climbthru_side_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WLW	ANI_SET_XVEL,2000h,AM_FACE_REL

	WL	4,R3CR3A+FR1
	.word	ANI_OFFSET,5,0,0
	WL	4,R3CR3A+FR2
	.word	ANI_BENDROPE,0
	.word	ANI_OFFSET,5,0,0	;*****
	WL	4,R3CR3A+FR3		
	.word	ANI_BENDROPE,2
	.word	ANI_OFFSET,5,0,0	;*****
	WL	4,R3CR3A+FR4

	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH

	.word	ANI_OFFSET,5,0,0	;*****
	WL	4,R3CR3A+FR5

	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH
	.word	ANI_OFFSET,3,0,0	;*****
	WL	4,R3CR3A+FR6
	.word	ANI_BENDROPE,2
	.word	ANI_OFFSET,3,0,0	;*****
	WL	4,R3CR3A+FR7
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM
	.word	ANI_OFFSET,4,0,0	;*****
	WL	4,R3CR3A+FR8
	.word	ANI_BENDROPE,3
	.word	ANI_OFFSET,5,0,0	;*****
	WL	4,R3CR3A+FR9
	.word	ANI_OFFSET,5,0,0	;*****
	WL	4,R3CR3A+FR10
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH
	.word	ANI_BENDROPE,-1
	.word	ANI_OFFSET,10,-3,0
	.word	ANI_ZEROVELS
	WL	4,R3CR3A+FR11
	.word	ANI_OFFSET,2,0,0	;*****
	WL	4,R3CR3A+FR12

	;now jump off...
	WL	4,R4JD4A+FR1		;D4FM4A+FR1
	WL	4,R4JD4A+FR2
	WL	3,R4JD4A+FR3

	WL	ANI_SET_YVEL,60000h

	WLW	ANI_SET_XVEL,30000h,AM_FACE_REL

	WL	3,R4JD4A+FR4
	.word	ANI_WAITHITGND

	.word	ANI_ROPE_Z,R_TOP,RZ_NORM
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM

	.word	ANI_ZEROVELS
	WL	3,R4JD4A+FR6
	WL	3,R4JD4A+FR7
	WL	6,R4JD4A+FR8

	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	rzr_climbin_side_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	ANI_CODE,SET_DIR_FACE
	.word	ANI_SETFACING
	.WORD	ANI_SET_WRESTLER_XFLIP

	;jump in
	WL	4,R4JD4A+FR1
	WL	4,R4JD4A+FR2

	WL	ANI_CODE,#set_trgt
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	.word	ANI_LEAPATPOS,1ch,200,0,0,0	;#ticks,dist,xoff,yoff,zoff

	WL	4,R4JD4A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH

	WL	4,R4JD4A+FR6
	WL	3,R4JD4A+FR7
	.word	ANI_OFFSET,5,0,0	;*****
	WL	3,R4JD4A+FR8
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM

	WL	ANI_CODE,#set_z

	WLW	ANI_SET_XVEL,2000h,AM_FACE_REL

	;climb through
	.word	ANI_BENDROPE,0
	WL	3,R3CR3A+FR1
	.word	ANI_OFFSET,2,0,0	;*****
	WL	3,R3CR3A+FR2
	.word	ANI_OFFSET,2,0,0	;*****
	WL	3,R3CR3A+FR3
	.word	ANI_OFFSET,2,0,0	;*****
	WL	3,R3CR3A+FR4
	.word	ANI_BENDROPE,2
	.word	ANI_OFFSET,2,0,0	;*****
	WL	3,R3CR3A+FR5

	.word	ANI_OFFSET,3,0,0	;*****
	WL	3,R3CR3A+FR6
	.word	ANI_BENDROPE,2
	.word	ANI_OFFSET,4,0,0	;*****
	WL	3,R3CR3A+FR7
	.word	ANI_OFFSET,6,0,0	;*****
	WL	3,R3CR3A+FR8
	.word	ANI_BENDROPE,3
	.word	ANI_OFFSET,8,0,0	;*****
	WL	3,R3CR3A+FR9
	.word	ANI_OFFSET,8,0,0	;*****
	WL	3,R3CR3A+FR10
	.word	ANI_BENDROPE,-1
	.word	ANI_OFFSET,8,0,0
	WL	3,R3CR3A+FR11
	.word	ANI_OFFSET,16,0,0	;*****
	WL	3,R3CR3A+FR12

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
 SUBR	rzr_climbthru_bot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

;Must rotate toward ropes!
;Do a different sequence

	;lie down
	WL	ANI_CODE,#ckspin
	WL	ANI_IFSTATUS,#dir4

;Facing #2, spin first!
	WL	3,R1TT5Z+FR2
	WL	3,R1TT5Z+FR3
#dir4
	WL	3,R3GU4A+FR10
	WL	3,R3GU4A+FR9
	WL	3,R3GU4A+FR8
	WL	3,R3GU4A+FR7
	WL	3,R3GU4A+FR6
	WL	3,R3GU4A+FR5
	WL	3,R3GU4A+FR4

	;roll over once
	WLW	ANI_SET_ZVEL,90000h,AM_ABS

	WL	3,R3RL1B+FR1
	WL	3,R3RL1B+FR2
	WL	3,R3RL1B+FR3
	WL	3,R3RL1B+FR4
	WL	3,R3RL1B+FR5
	WL	3,R3RL1B+FR6
	WL	3,R3RL1B+FR7
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP+MODE_NOSHADOW

	.word	ANI_SETFACING

	;climb through
	.word	ANI_OFFSET,0,-70,0			;x,y,z
	.WORD	ANI_XFLIP
	WL	3,R3DC3C+FR5
	WL	3,R2MP2A+FR7
	WL	3,R2MP2A+FR6
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

 SUBR	rzr_climbin_bot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;climb in
	.word	ANI_GRAVITY_OFF
	WL	3,R2MP2A+FR6
	WL	3,R2MP2A+FR7
	WL	3,R3DC3C+FR5
	.word	ANI_OFFSET,0,70,-60
	.WORD	ANI_XFLIP

	;roll
	WLW	ANI_SET_ZVEL,-70000h,AM_ABS
	.word	ANI_FRICTION,3000h
	WL	3,R3RL1B+FR6
	WL	3,R3RL1B+FR5
	WL	3,R3RL1B+FR4
	WL	3,R3RL1B+FR3
	WL	3,R3RL1B+FR2
	WL	3,R3RL1B+FR1
	.word	ANI_ZEROVELS
	.word	ANI_GRAVITY_ON

	;get up
	WL	3,R3GU4A+FR3
	WL	3,R3GU4A+FR4
	WL	3,R3GU4A+FR5
	WL	3,R3GU4A+FR6
	WL	3,R3GU4A+FR7
	WL	3,R3GU4A+FR8
	WL	3,R3GU4A+FR9
	WL	3,R3GU4A+FR10

	WL	ANI_CODE,clr_climb
	.word	ANI_OFFSET,0,0,0

	.word	ANI_FACEDOWN
	.word	ANI_ZEROVELS
	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	rzr_climbthru_top_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;lie down
	WL	ANI_CODE,#set_zvel1
	WL	ANI_IFSTATUS,#dir4
;Facing #2
	WL	3,R1TT5Z+FR2
	WL	3,R1TT5Z+FR3
	
#dir4
	WL	3,R3GU4A+FR10
	WL	3,R3GU4A+FR9
	WL	3,R3GU4A+FR8
	WL	3,R3GU4A+FR7
	WL	3,R3GU4A+FR6
	WL	3,R3GU4A+FR5
	WL	3,R3GU4A+FR4
	WL	3,R3GU4A+FR3

	;roll over once
	WL	ANI_CODE,#set_zvel2
	WL	3,R3RL1B+FR11
	WL	3,R3RL1B+FR10
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP+MODE_NOSHADOW
	WL	3,R3RL1B+FR9
	WL	3,R3RL1B+FR8
	WL	3,R3RL1B+FR7

	;climb through
	.word	ANI_OFFSET,0,-61,0
	.word	ANI_ZEROVELS
	WL	3,R4AM4B+FR4
	WL	3,R4AM4B+FR3
	WL	3,R4AM4B+FR2

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
	movi	-50000h,a0
	move	a0,*a13(OBJ_ZVEL),L
	rets

#*****************************************************************************

 SUBR	rzr_climbin_top_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;climb in
	WL	3,R4AM4B+FR2
	WL	3,R4AM4B+FR3
	WL	3,R4AM4B+FR4
	.word	ANI_OFFSET,0,61,0

	;roll over
	WL	ANI_CODE,#set_zvel2
	WL	3,R3RL1B+FR7
	WL	3,R3RL1B+FR8
	WL	3,R3RL1B+FR9
	WL	3,R3RL1B+FR10	

	.word	ANI_ZEROVELS

	;get up
	WL	3,R3GU4A+FR3
	WL	3,R3GU4A+FR4
	WL	3,R3GU4A+FR5
	WL	3,R3GU4A+FR6
	WL	3,R3GU4A+FR7
	WL	3,R3GU4A+FR8
	WL	3,R3GU4A+FR9
	WL	3,R3GU4A+FR10

	WL	ANI_CODE,clr_climb

	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#set_zvel2
	movi	52000h,a0
	move	a0,*a13(OBJ_ZVEL),L
	rets

#*****************************************************************************
*

 SUBR	rzr_knockdwn_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h
	.word	ANI_XFLIP
 

	WL	2,R3GU4A+FR10
	WL	2,R3GU4A+FR8
	WL	2,R3GU4A+FR5
	WL	ANI_SET_YVEL,39000h

	WL	3,R3AM3D+FR3
	WL	3,R3AM3D+FR4
	WL	3,R3AM3D+FR5
	WL	3,R3AM3D+FR6
	WL	3,R3AM3D+FR7
	WL	6,R3AM3D+FR1

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
	WL	ANI_CHANGEANIM,rzr_faceup_getup_anim

#*****************************************************************************
*
* PIN OPPONENT AND RAISE ARM IN VICTORY

;Need to have this guy walk toward fallen opponent so he
;can get closer!

;This pin must be started only when opponent is on the ground!

 SUBR	rzr_2_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;Rotate!
	WL	3,R1TT5Z+FR2
	WL	3,R1TT5Z+FR3
	WL	ANI_GOTO,#cont

 SUBR	rzr_4_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

#cont
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 22,999,80h,50h,90000h,TGT_CHEST,0,57,-15

	WL	3,R3PN5A+FR1
	WL	3,R3PN5A+FR2
	WL	3,R3PN5A+FR3
	.word	ANI_OFFSET,0,45,0			;x,y,z
	WL	13,R3PN5A+FR4
;	.word	ANI_WAITHITGND
	.word	ANI_ATTACK_ON_Z, AMODE_STOMP,-40,-8,0,76,20,30 ;mode,x,y,z,w,h,d
	.word	ANI_ZEROVELS

;	WLW	ANI_ATTCHIMAGE,D4PN5L+FR4,10		;image, zoff (priority)
	WL	3,R3PN5A+FR5

	WL	ANI_CODE,DO_CROWD_CHEER

	.word	ANI_ATTACK_OFF
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_BOUNCE,2
;	WLW	ANI_ATTCHIMAGE,D4PN5L+FR5,10		;image, zoff (priority)
	WL	4,R3PN5A+FR6
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE

	.word	ANI_OFFSET,0,0,20			;x,y,z
	WL	4,R3PN5A+FR5
	WL	ANI_CODE,win_announce
;	WLW	ANI_ATTCHIMAGE,0,0		;Turn it off
	WL	40,R3PN5A+FR5

;???? IS THIS WHERE IT GOES ?
	.word	ANI_LOOP

;Do another ground hit on opponent
	WL	ANI_CODE,grnd_hit

	WL	ANI_SET_YVEL,42000h
	WLW	ANI_SET_ZVEL,22000h,AM_ABS
	WL	4,R5RV5A+FR2
	WL	4,R5RV5A+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	7,R5RV5A+FR4
	WL	7,R5RV5A+FR5
	WL	7,R5RV5A+FR6
	WL	7,R5RV5A+FR7
	WL	7,R5RV5A+FR8
	WL	7,R5RV5A+FR9
	WL	7,R5RV5A+FR10
	WL	7,R5RV5A+FR11
	WL	7,R5RV5A+FR12
	WL	7,R5RV5A+FR13
	WL	7,R5RV5A+FR14
	WL	30,R5RV5A+FR15
	WL	6,R5RV5A+FR16
	WL	6,R5RV5A+FR17
	WL	1000,R5RV5A+FR18

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************
	.end
