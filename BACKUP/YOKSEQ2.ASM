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

	.file	"yokseq2.asm"
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
	.include	"yokoimg.h"
	.include	"ring.equ"

	.include	"display.equ"
	.include	"ring.equ"
	.include	"damage.equ"

******************************************************************************
* EXTERNAL REFERENCES

	;BAM BAM
	.ref	B3RN3A,B4YR3A

	;DOINK
	.ref	D3RN3B,D4YR3B

	;BRET
	.ref	H3RN3A,H4YR3A

	;LEX
	.ref	L3RN3B,L4YR3B

	;RAZOR
	.ref	R3RN3D,R4YR3A

	;SHAWN
	.ref	S3RN3A,S4YR3A

	;TAKER
	.ref	U3RN3A

	;YOKO
	.ref	yok_faceup_getup2_anim
	.ref	U4YR3B

	;MISC
	.ref	get_opp_process,start_run_anim,CALL_MISSES,start_run_flung
	.ref	SET_DIR_FACE,HIT_THE_MAT,no_bk_xvel

	.ref	SET_DIR_FACE,HIT_THE_MAT,no_bk_xvel,check_xvel
	.REF	DO_CROWD_CHEER

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* NORMAL #2 PUNCH

 SUBR	yok_2_punch_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	3,Y2PU2A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_PUNCH,9
	WL	3,Y2PU2A+FR2
	WL	3,Y2PU2A+FR3
	WL	3,Y2PU2A+FR4

;Knock him down from a punch for testing hair pickup
;Jason, this is cool to knock opponents down with just a punch!
;The little hop he does upon contact is also cool!
;We need to allow this from Yoko under some circumstances!
;Perhaps randomize between the two attack modes??
;	.word	ANI_ATTACK_ON,AMODE_PUNCH,50,90,42,12
	.word	ANI_ATTACK_ON,AMODE_FLYKICK,50,90,42,12


	WL	3,Y2PU2A+FR5
	.word	ANI_ATTACK_OFF

	WL	3,Y2PU2A+FR6
	WL	3,Y2PU2A+FR7
	WL	3,Y2PU2A+FR8
	WL	3,Y2PU2A+FR9
	WL	3,Y2PU2A+FR10
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* NORMAL #4 PUNCH

 SUBR	yok_4_punch_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	3,Y4PU4B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_PUNCH,9
	WL	3,Y4PU4B+FR2
	WL	3,Y4PU4B+FR3
	WL	3,Y4PU4B+FR4

	.word	ANI_ATTACK_ON,AMODE_PUNCH,42,77,36,19
	WL	3,Y4PU4B+FR5
	.word	ANI_ATTACK_OFF

	WL	3,Y4PU4B+FR6
	WL	3,Y4PU4B+FR7
	WL	3,Y4PU4B+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 PUSH

 SUBR	yok_2_push_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUSH,12
	WL	3,Y2PS3A+FR2
	WL	3,Y2PS3A+FR3
	WL	3,Y2PS3A+FR4
	WL	3,Y2PS3A+FR5
	.word	ANI_ATTACK_ON, AMODE_PUSH,38,81,49,16
	WL	3,Y2PS3A+FR6
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,40h,-50000h,#no_hit	;range,vel,addr
	WL	15,Y2PS3A+FR6
#no_hit
	WL	15,Y2PS3A+FR6
	WL	3,Y2PS3A+FR7
	WL	3,Y2PS3A+FR8
	WL	3,Y2PS3A+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #4 PUSH

 SUBR	yok_4_push_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUSH,12
	WL	3,Y4PS3A+FR2
	WL	3,Y4PS3A+FR3
	WL	3,Y4PS3A+FR4
	WL	3,Y4PS3A+FR5
	.word	ANI_ATTACK_ON, AMODE_PUSH,36,86,45,16
	WL	3,Y4PS3A+FR6
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,40h,-50000h,#no_hit	;range,vel,addr
	WL	15,Y4PS3A+FR6
#no_hit
	WL	15,Y4PS3A+FR6
	WL	3,Y4PS3A+FR7
	WL	3,Y4PS3A+FR8
	WL	3,Y4PS3A+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #2 ELBOW DROP

#yoff	equ	37

 SUBR	yok_2_lbowdrop_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	3,Y2PF2A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_LBDROP,7
	WL	4,Y2PF2A+FR2
	WL	3,Y2PF2A+FR3

	;skip the leap if simply falling down will do.
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,4,4,-40,34,31,50
	WL	1,Y2PF2A+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#skip_leapat

	.word	ANI_TARGET,TGT_CHEST,TGT_CHEST,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 20,999,112,96,90000h,TGT_USER,21,0+#yoff,-30
	WL	ANI_GOTO,#do_leapat

#skip_leapat
	WL	ANI_SET_YVEL,30000h
#do_leapat
	WL	4,Y2PF2A+FR4
	.word	ANI_OFFSET,0,#yoff,0
	WL	4,Y2PF2A+FR5
	WL	4,Y2PF2A+FR6
	WL	4,Y2PF2A+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_SHAKER,40
	.word	ANI_SHAKEALL,2
	.word	ANI_ATTACK_ON_Z, AMODE_LBOWDROP,0,0,-40,42,39,50
	WL	4,Y2PF2A+FR8
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#hit

	WL	ANI_CODE,CALL_MISSES
#hit
	WL	12,Y2PF2A+FR9
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,yok_faceup_getup2_anim

#*****************************************************************************
*
* #4 ELBOW DROP

#yoff	equ	34

 SUBR	yok_4_lbowdrop_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	3,Y3PF3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_LBDROP,7
	WL	4,Y3PF3A+FR3
	WL	3,Y3PF3A+FR4

	;skip the leap if it's not needed.
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,14,4,-10,32,30,50
	WL	1,Y3PF3A+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#skip_leapat

	.word	ANI_TARGET,TGT_CHEST,TGT_CHEST,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 20,999,112,96,90000h,TGT_USER,33,0+#yoff,30
	WL	ANI_GOTO,#do_leapat

#skip_leapat
	WL	ANI_SET_YVEL,30000h
#do_leapat
	.word	ANI_OFFSET,0,#yoff,0
	WL	4,Y3PF3A+FR5
	WL	4,Y3PF3A+FR6
	WL	4,Y3PF3A+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKER,40
	.word	ANI_SHAKEALL,2
	.word	ANI_ATTACK_ON_Z,AMODE_LBOWDROP,10,0,-10,40,38,50
	WL	4,Y3PF3A+FR8
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#hit

	WL	ANI_CODE,CALL_MISSES
#hit
	WL	12,Y3PF3A+FR9
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,yok_faceup_getup_anim

#*****************************************************************************
*
* #2 HEAD BUTT

;TODO (JS) Put something here! (yoko #2 headbutt)

 SUBR	yok_2_butt_anim

	.word	ANI_END

#*****************************************************************************
*
* #4 HEAD BUTT

;TODO (JS) Put something here! (yoko #4 headbutt)

 SUBR	yok_4_butt_anim

	.word	ANI_END

#*****************************************************************************
*
* NORMAL #2 KICK

 SUBR	yok_2_kick_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	.word	ANI_SETSPEED,100h

	WL	2,Y2KM3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KICK,6
	WL	2,Y4KM3A+FR2
	WL	2,Y4KM3A+FR3
	WL	2,Y4KM3A+FR4
	WWL	ANI_SETLONG,OBJ_GRAVITY,0c000h
	WL	ANI_SET_YVEL,30000h

	.word	ANI_ATTACK_ON, AMODE_KICK,35,62,56,34
	WL	8,Y4KM3A+FR5
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-40000h,#no_hit
	WL	ANI_SET_YVEL,30000h
	WL	10,Y4KM3A+FR5
#no_hit
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY
	.word	ANI_SHAKER,20
	.word	ANI_SHAKEALL,1

	WL	2,Y4KM3A+FR5
	WL	2,Y4KM3A+FR6
	WL	2,Y4KM3A+FR7
	WL	2,Y4KM3A+FR8
	WL	2,Y4KM3A+FR9
	WL	2,Y2KM3A+FR10
	WL	2,Y2KM3A+FR11
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* NORMAL #4 KICK

 SUBR	yok_4_kick_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	2,Y4KM3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KICK,6
	WL	2,Y4KM3A+FR2
	WL	2,Y4KM3A+FR3
	WL	2,Y4KM3A+FR4
	WWL	ANI_SETLONG,OBJ_GRAVITY,0c000h
	WL	ANI_SET_YVEL,30000h

	.word	ANI_ATTACK_ON, AMODE_KICK,35,62,56,34
	WL	8,Y4KM3A+FR5
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-40000h,#no_hit
	WL	ANI_SET_YVEL,30000h
	WL	10,Y4KM3A+FR5

#no_hit
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY
	.word	ANI_SHAKER,20
	.word	ANI_SHAKEALL,1
	WL	2,Y4KM3A+FR5
	WL	2,Y4KM3A+FR6
	WL	2,Y4KM3A+FR7
	WL	2,Y4KM3A+FR8
	WL	2,Y4KM3A+FR9
	WL	2,Y4KM3A+FR10
	WL	2,Y4KM3A+FR11
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 STOMP ON FALLEN OPPONENT

 SUBR	yok_2_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	3,Y2MP2A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_STOMP,3
	WL	3,Y2MP2A+FR2

	;if we're going to miss, do a leapat
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,4,-5,-40,38,43,50
	WL	1,Y2MP2A+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#leapat_stomp

	WL	4,Y2MP2A+FR3
	WL	4,Y2MP2A+FR4
	WL	4,Y2MP2A+FR5
	WL	4,Y2MP2A+FR6
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,4,-5,-40,38,43,50
	WL	4,Y2MP2A+FR7
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#hit
	WL	ANI_CODE,CALL_MISSES
#hit
	.word	ANI_SHAKER,25
	.word	ANI_SHAKEALL,1
	WL	4,Y2MP2A+FR8
	WL	4,Y2MP2A+FR9
	WL	4,Y2MP2A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#leapat_stomp
	.word	ANI_TARGET,TGT_CHEST,TGT_CHEST,ATM_CLOSEST
	;too far.  leap at the chest.
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,112,96,90000h,TGT_USER,21,0,-40
	
	.word	ANI_STARTATTACK,AT_STOMP,15
	WL	3,Y2MP2A+FR3
	WL	3,Y2MP2A+FR4
	WL	3,Y2MP2A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SHAKER,40
	.word	ANI_SHAKEALL,2
	WL	3,Y2MP2A+FR6
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,4,-5,-40,38,43,50
	WL	4,Y2MP2A+FR7
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#leapat_hit
	WL	ANI_CODE,CALL_MISSES
#leapat_hit
	WL	4,Y2MP2A+FR8
	WL	4,Y2MP2A+FR9
	WL	4,Y2MP2A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #4 STOMP ON FALLEN OPPONENT

 SUBR	yok_4_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	3,Y4MP4A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_STOMP,3
	WL	3,Y4MP4A+FR2

	;if we're going to miss, do a leapat
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,15,-7,-10,40,36,50
	WL	1,Y4MP4A+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#leapat_stomp

	WL	4,Y4MP4A+FR3
	WL	4,Y4MP4A+FR4
	WL	4,Y4MP4A+FR5
	WL	4,Y4MP4A+FR6
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,15,-7,-10,40,36,50
	WL	4,Y4MP4A+FR7
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#hit
	WL	ANI_CODE,CALL_MISSES
#hit
	.word	ANI_SHAKER,25
	.word	ANI_SHAKEALL,1
	WL	4,Y4MP4A+FR8
	WL	4,Y4MP4A+FR9
	WL	4,Y4MP4A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#leapat_stomp
	.word	ANI_TARGET,TGT_CHEST,TGT_CHEST,ATM_CLOSEST
	;too far.  leap at the chest.
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,112,96,90000h,TGT_USER,33,0,40

	.word	ANI_STARTATTACK,AT_STOMP,16
	WL	3,Y4MP4A+FR3
	WL	3,Y4MP4A+FR4
	WL	3,Y4MP4A+FR5
	WL	3,Y4MP4A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SHAKER,40
	.word	ANI_SHAKEALL,2
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,15,-7,-10,40,36,50
	WL	4,Y4MP4A+FR7
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#leapat_hit
	WL	ANI_CODE,CALL_MISSES
#leapat_hit
	WL	4,Y4MP4A+FR8
	WL	4,Y4MP4A+FR9
	WL	4,Y4MP4A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #3 FLYING BUTT-DROP (ouch)

#yoff	equ	65

 SUBR	yok_3_butt_drop_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
;	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
;	.word	ANI_ZEROVELS

	WL	3,Y3JK3A+FR1
	WL	3,Y3JK3A+FR2
	WL	3,Y3JK3A+FR3

	;take off
	.word	ANI_TARGET,TGT_CHEST,TGT_CHEST,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 30,999,112,96,90000h,TGT_USER,0,0+#yoff,-10
	WL	ANI_CODE,no_bk_xvel
	.word	ANI_STARTATTACK,AT_STOMP,30

	.word	ANI_SETPLYRMODE,MODE_INAIR

	WL	4,Y3JK3A+FR4
	.word	ANI_OFFSET,0,#yoff,0
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,-22,-10-10,-30,54,36,50
	WWL	ANI_WAITHITOPP,30,Y3JK3A+FR5
	.word	ANI_ATTACK_OFF

	.word	ANI_ZEROVELS
	.word	ANI_SHAKER,40
	.word	ANI_SHAKEALL,2
	WL	ANI_CODE,HIT_THE_MAT

	WL	ANI_IFNOTSTATUS,#miss

#hit
	;bounce off the guy
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_ZVEL,1C000h,AM_ABS

	;this part should take around 12 ticks
	WL	4,Y3JK3A+FR6
	WL	1,Y3JK3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,1
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	
	WL	4,Y3JK3A+FR6
	WL	4,Y3JK3A+FR7
	WL	4,Y3JK3A+FR8
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,yok_faceup_getup2_anim
	
#miss
	WL	ANI_CODE,CALL_MISSES
	WL	16,Y3JK3A+FR6
	.word	ANI_WAITHITGND
	WL	4,Y3JK3A+FR7
	WL	4,Y3JK3A+FR8
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,yok_faceup_getup2_anim

#*****************************************************************************
*
* #2 KNEE

 SUBR	yok_2_knee_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,Y4NM3B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KNEE,6
	WL	3,Y4NM3B+FR2
	WL	3,Y4NM3B+FR3
	.word	ANI_ATTACK_ON, AMODE_KNEE,34,58,26,32
	WL	3,Y4NM3B+FR4
	.word	ANI_ATTACK_OFF
	WL	6,Y4NM3B+FR4
	WL	3,Y4NM3B+FR5
	WL	3,Y4NM3B+FR6
	WL	3,Y2NM3A+FR7

	WL	3,Y2NM3A+FR8
	WL	3,Y2NM3A+FR9
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 KNEE

 SUBR	yok_4_knee_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,Y4NM3B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KNEE,6
	WL	3,Y4NM3B+FR2
	WL	3,Y4NM3B+FR3
	.word	ANI_ATTACK_ON, AMODE_KNEE,34,58,26,32
	WL	3,Y4NM3B+FR4
	.word	ANI_ATTACK_OFF
	WL	6,Y4NM3B+FR4
	WL	3,Y4NM3B+FR5
	WL	3,Y4NM3B+FR6
	WL	3,Y4NM3B+FR7
	WL	3,Y4NM3B+FR8
	WL	3,Y4NM3B+FR9
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


;#*****************************************************************************
;*
;* #3 FLYING KICK
;
;#yoff1	equ	40
;
; SUBR	yok_flying_kick_anim
;
;	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_SETSPEED,100h
;
;	WL	3,D3DC3C+FR1
;
;	WL	ANI_CODE,get_leap
;	WL	ANI_IFSTATUS,#no_xvel
;
;;	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 21,999,140,65,90000h,TGT_HEAD,30,100,0
;
;	WL	ANI_GOTO,#cont
;
;#no_xvel
;	.word	ANI_ZERO_XZVELS
;	WL	ANI_SET_YVEL,64000h
;#cont
;	WL	3,D3DC3C+FR2
;
;	.word	ANI_OFFSET,0,#yoff1,0			;x,y,z
;	WL	4,D3DC3C+FR3
;	WL	7,D3DC3C+FR4
;
;	.word	ANI_CLR_STATUS
;
;	.word	ANI_ATTACK_ON, AMODE_FLYKICK,53,23,27,29 ;mode,x,y,w,h
;	WL	3,D3DC3C+FR5
;	.word	ANI_ATTACK_OFF
;	WL	4,D3DC3C+FR6
;
;	WL	3,D3DC3C+FR7
;	WL	3,D3DC3C+FR8
;
;	.word	ANI_WAITHITGND
;	.word	ANI_ZEROVELS
;
;
;	WL	ANI_IFSTATUS,#got
;;Missed him
;	WL	4,D3DC3C+FR9
;	.word	ANI_BOUNCE,3
;	.word	ANI_SOUND,bounce_l1
;	WL	4,D3DC3C+FR9
;	.word	ANI_WAITHITGND
;	WL	2,D3DC3C+FR9
;	
;#got
;	WL	2,D3DC3C+FR9
;#cont2
;	.word	ANI_SOUND,bounce_l1
;	WL	2,D3DC3C+FR9
;
;	WL	4,D3DC3C+FR9
;	WL	4,D3DC3C+FR10
;
;
;	.word	ANI_XFLIP
;	.word	ANI_OFFSET,5,0,0			;x,y,z
;
;	WL	6,D2GD2A+FR4
;	WL	6,D2GD2A+FR6
;	WL	4,D2GD2A+FR7
;	WL	4,D2GD2A+FR9
;
;	.word	ANI_FACEUP
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_SETPLYRMODE,MODE_NORMAL
;	.word	ANI_END
;


;Keep this around for now... 11/9/94
;#*****************************************************************************
;*
;* #2 KARATE TYPE KICK
;
; SUBR	yok_2_karatekick_anim
;	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_ZEROVELS
;
;	.word	ANI_SETSPEED,100h
;
;	WL	3,Y2KB3A+FR1
;	WL	3,Y2KB3A+FR2
;	WL	3,Y2KB3A+FR3
;	WL	3,Y2KB3A+FR4
;	WL	3,Y2KB3A+FR5
;
;	.word	ANI_ATTACK_ON, AMODE_KICK,11,62,71,19	;mode,x,y,w,h
;	WL	3,Y2KB3A+FR6
;	.word	ANI_ATTACK_OFF
;
;	WL	3,Y2KB3A+FR7
;	WL	3,Y2KB3A+FR8
;	WL	3,Y2KB3A+FR9
;	WL	3,Y2KB3A+FR10
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END
;
;#*****************************************************************************
;*
;* #4 KARATE TYPE KICK
;
; SUBR	yok_4_karatekick_anim
;	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_ZEROVELS
;
;	.word	ANI_SETSPEED,100h
;
;	WL	3,Y4KB3A+FR1
;	WL	3,Y4KB3A+FR2
;	WL	3,Y4KB3A+FR3
;	WL	3,Y4KB3A+FR4
;	WL	3,Y4KB3A+FR5
;
;	.word	ANI_ATTACK_ON, AMODE_KICK,19,62,77,18	;mode,x,y,w,h
;	WL	3,Y4KB3A+FR6
;	.word	ANI_ATTACK_OFF
;
;	WL	3,Y4KB3A+FR7
;	WL	3,Y4KB3A+FR8
;	WL	3,Y4KB3A+FR9
;	WL	3,Y4KB3A+FR10
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END

#*****************************************************************************
*
* #2 GUT PUSH

 SUBR	yok_2_gut_push_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_FRICTION,4000h
	WLW	ANI_SET_XVEL,60000h,1
;	WL	3,Y2PS3B+FR1

	.word	ANI_ATTACK_ON, AMODE_PUSH,-12,31,43,63 ;mode,x,y,w,h
	WL	3,Y2PS3B+FR2
;	WL	3,Y2PS3B+FR3
;	WL	3,Y2PS3B+FR4
;	WL	18,Y2PS3B+FR5
	.word	ANI_ATTACK_OFF

;	WL	3,Y2PS3B+FR6
	WL	3,Y2PS3B+FR7
;	WL	3,Y2PS3B+FR8
	WL	3,Y2PS3B+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #4 GUT PUSH

 SUBR	yok_4_gut_push_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_FRICTION,4000h
	WLW	ANI_SET_XVEL,60000h,1
	WL	3,Y4PS3B+FR1

	.word	ANI_ATTACK_ON, AMODE_PUSH,-12,31,43,63 ;mode,x,y,w,h
	WL	3,Y4PS3B+FR2
	WL	3,Y4PS3B+FR3
	WL	3,Y4PS3B+FR4
	WL	3,Y4PS3B+FR5
	WL	18,Y4PS3B+FR6
	.word	ANI_ATTACK_OFF

	WL	3,Y4PS3B+FR7
	WL	3,Y4PS3B+FR8
	WL	3,Y4PS3B+FR9
	WL	3,Y4PS3B+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* CLIMB UP TURNBUCKLES

 SUBR	yok_climb_up_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SHAKECORNER

	.word	ANI_OFFSET,2,3,0	;6,7,0, spread out over 3
	WL	4,Y2CT2Z+FR1
	.word	ANI_OFFSET,2,2,0
	WL	4,Y2CT2Z+FR2
	.word	ANI_OFFSET,2,2,0
	WL	4,Y2CT2Z+FR3
	WL	4,Y2CT2Z+FR4
	WL	4,Y2CT2Z+FR5
	WL	4,Y2CT2Z+FR6
	WL	4,Y2CT2Z+FR7
	WL	4,Y2CT2Z+FR8

	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONTURNBKL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOGRAVITY

#repeat
	WL	20,Y2CT2Z+FR8
	WL	ANI_GOTO,#repeat


#*****************************************************************************
*
* CLIMB DOWN TURNBUCKLES

 SUBR	yok_climb_down_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SHAKECORNER

	WL	4,Y2CT2Z+FR8
	WL	4,Y2CT2Z+FR7
	WL	4,Y2CT2Z+FR6
	WL	4,Y2CT2Z+FR5
	WL	4,Y2CT2Z+FR4
	WL	4,Y2CT2Z+FR3
	.word	ANI_OFFSET,-2,-2,0
	WL	4,Y2CT2Z+FR2
	.word	ANI_OFFSET,-2,-2,0
	WL	4,Y2CT2Z+FR1
	.word	ANI_OFFSET,-2,-3,0

	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* BIG NASTY BUTT-DROP OFF THE TURNBUCKLE

 SUBR	yok_tbukl_buttdrop_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOGRAVITY|MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_OFFSET,-20,0,0
	WL	4,Y2ZZ2X+FR1
	.word	ANI_OFFSET,0,60,0

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 36,190,190,190,90000h,TGT_GROIN,0,0,-30
	WL	ANI_CODE,check_xvel

	.word	ANI_STARTATTACK,AT_BUTTSTOMP,36
	.word	ANI_SETPLYRMODE,MODE_INAIR2
	.word	ANI_GRAVITY_ON
	.word	ANI_SHAKECORNER

	WL	4,Y2ZZ2X+FR2
	WL	4,Y2ZZ2X+FR3
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-30,15,-30,73,36,80
	WWL	ANI_IFOPPMODE,MODE_ONGROUND,#opp_onground
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-30,25,-30,73,36,80
#opp_onground
	WL	4,Y2ZZ2X+FR4
	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#hit

	;missed
	WL	ANI_CODE,CALL_MISSES
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKER,20
	.word	ANI_SHAKEALL,2
	.word	ANI_BOUNCE,5
	WL	4,Y2ZZ2X+FR5
	.word	ANI_WAITHITGND
	.word	ANI_SHAKER,20
	WL	ANI_CODE,SMALL_BOUNCE
	WL	ANI_GOTO,#common

#hit
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKER,50
	.word	ANI_SHAKEALL,3
	.word	ANI_SOUND,0C1h		;cool plywood crash

#common
	WL	4,Y2ZZ2X+FR5
	WL	4,Y2ZZ2X+FR6
	WL	12,Y2ZZ2X+FR7

	.word	ANI_XFLIP

	WL	4,Y3GU2A+FR3
	WL	ANI_CHANGEANIM,yok_faceup_getup2_anim

#*****************************************************************************
*
* GRAB & FLING OPPONENT (INTO A RUN)

 SUBR	yok_2_grabfling_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	3,Y1TT5Z+FR2
	WL	3,Y1TT5Z+FR3
	WL	ANI_GOTO,#cont

 SUBR	yok_4_grabfling_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

#cont
;	WL	4,Y4GF3B+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,40,0,25
	WL	ANI_SET_YVEL,0000h
	.word	ANI_STARTATTACK,AT_GRBFLNG,5

	WL	4,Y4GF3B+FR2

;	.word	ANI_IFOPP,W_BAMBAM,-1
;	WL	ANI_IFSTATUS,#missed

	.word	ANI_ATTACK_ON, AMODE_PUPPET,33,56,44,18 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,Y4GF3B+FR3
;	WL	4,Y4GF3B+FR3
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
	WWLLW	ANI_SUPERSLAVE2,10,Y4GF3B+FR3,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,6,Y4GF3B+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,5,Y4GF3B+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,5,Y4GF3B+FR6,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,5,Y4GF3B+FR7,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,5,Y4GF3B+FR8,#puppet_tbl,5

	WL	ANI_SLAVEANIM,#strt_run_tbl

	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_DETACH
	WL	16,Y4GF3B+FR9
	WL	4,Y4GF3B+FR9
	.word	ANI_OFFSET,-10,0,0			;x,y,z

	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#missedb
	WL	10,Y4GF3B+FR3
#missed
	WL	ANI_CODE,CALL_MISSES
	WL	6,Y4GF3B+FR3
	WL	4,Y4GF3B+FR2

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
 LWWW H4YR3A+FR1,50,1,1
 LWWW H4YR3A+FR2,51,0,1
 LWWW H4YR3A+FR3,45,-2,1
 LWWW H4YR3A+FR5,33,4,1
 LWWW H3RN3A+FR1,-6,6,0
 LWWW H3RN3A+FR2,6,13,0
#Razor
 LWWW R4YR3A+FR1,38,10,0
 LWWW R4YR3A+FR2,28,10,0
 LWWW R4YR3A+FR3,13,0,0
 LWWW R4YR3A+FR4,-4,4,0
 LWWW R3RN3D+FR10,-8,16,0
 LWWW R3RN3D+FR11,8,22,0
#Taker
 LWWW U4YR3B+FR2,35,11,0
 LWWW U4YR3B+FR3,42,6,0
 LWWW U4YR3B+FR4,32,10,0
 LWWW U4YR3B+FR5,19,14,0
 LWWW U3RN3A+FR2,-12,18,0
 LWWW U3RN3A+FR2,-20,22,0
#Yokozuna
 LWWW Y4YR3A+FR1,54,5,1
 LWWW Y4YR3A+FR4,37,4,1
 LWWW Y4YR3A+FR5,27,1,1
 LWWW Y4YR3A+FR7,-4,-3,1
 LWWW Y3RN3C+FR7,-5,16,0
 LWWW Y3RN3C+FR8,15,19,0
#Shawn
 LWWW S4YR3A+FR2,31,-1,1
 LWWW S4YR3A+FR3,50,-12,1
 LWWW S4YR3A+FR5,14,0,1
 LWWW S4YR3A+FR6,6,2,1
 LWWW S3RN3A+FR2,-6,14,0
 LWWW S3RN3A+FR3,7,19,0
#BamBam
 LWWW B4YR3A+FR3,44,6,0
 LWWW B4YR3A+FR4,50,-1,0
 LWWW B4YR3A+FR5,49,-2,0
 LWWW B4YR3A+FR7,-15,-1,0
 LWWW B3RN3A+FR1,-16,17,0
 LWWW B3RN3A+FR2,-5,23,0
#Doink
 LWWW D4YR3B+FR1,51,6,1
 LWWW D4YR3B+FR2,50,7,1
 LWWW D4YR3B+FR3,34,4,1
 LWWW D4YR3B+FR4,10,9,1
 LWWW D3RN3B+FR3,-1,18,0
 LWWW D3RN3B+FR4,1,23,0
#Adam
 .long 0
#Lex
 LWWW L4YR3B+FR1,53,8,1
 LWWW L4YR3B+FR2,40,0,1
 LWWW L4YR3B+FR3,15,0,1
 LWWW L4YR3B+FR4,-27,1,1
 LWWW L3RN3B+FR2,-4,16,0
 LWWW L3RN3B+FR3,17,18,0


#strt_run_tbl
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung


#*****************************************************************************
*

 SUBR	yok_knockdwn_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h
	.word	ANI_XFLIP
 
	WL	2,Y3GU4A+FR13
	WL	2,Y3GU2A+FR12
	WL	2,Y3GU2A+FR7
	WL	ANI_SET_YVEL,39000h

	WL	4,Y3CP3B+FR1
	WL	4,Y3CP3B+FR2
	WL	4,Y3CP3B+FR3
	WL	4,Y3CP3B+FR4
	WL	4,Y3CP3B+FR5
	WL	4,Y3CP3B+FR6
	WL	4,Y3CP3B+FR7
	WL	4,Y3CP3B+FR8

	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	.word	ANI_SETPLYRMODE,MODE_DEAD
	.word	ANI_END

#nodead

	WL	4,Y3RL1A+FR1
	.word	ANI_WAITROLL
	.ref	yok_faceup_getup_anim
	WL	ANI_CHANGEANIM,yok_faceup_getup_anim

#*****************************************************************************
 SUBR	yok_climbthru_side_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WLW	ANI_SET_XVEL,2000h,AM_FACE_REL

	WL	4,Y4CR3B+FR1
	.word	ANI_OFFSET,5,0,0
	WL	4,Y4CR3B+FR2
	.word	ANI_BENDROPE,2
	.word	ANI_OFFSET,8,0,0	;*****
	WL	4,Y4CR3B+FR3		
	.word	ANI_OFFSET,8,0,0	;*****
	WL	4,Y4CR3B+FR4

	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH

	.word	ANI_OFFSET,5,0,0	;*****
	WL	4,Y4CR3B+FR5
	.word	ANI_OFFSET,7,0,0	;*****
	WL	4,Y4CR3B+FR6
	.word	ANI_OFFSET,12,0,0	;*****
	WL	4,Y4CR3B+FR8
	.word	ANI_BENDROPE,2
	.word	ANI_OFFSET,12,0,0	;*****
	WL	4,Y4CR3B+FR9
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH
	.word	ANI_OFFSET,10,0,0	;*****
	WL	4,Y4CR3B+FR10
	.word	ANI_BENDROPE,-1
	.word	ANI_OFFSET,10,-3,0
	.word	ANI_ZEROVELS
	WL	4,Y4CR3B+FR11
	WL	4,Y4CR3B+FR12

	;now jump off...
	WL	4,Y4JD4A+FR1		;D4FM4A+FR1
	WL	4,Y4JD4A+FR2
	WL	3,Y4JD4A+FR3

	WL	ANI_SET_YVEL,60000h

	WLW	ANI_SET_XVEL,30000h,AM_FACE_REL

	WL	3,Y4JD4A+FR4
	.word	ANI_WAITHITGND

	.word	ANI_ROPE_Z,R_TOP,RZ_NORM
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM

	.word	ANI_ZEROVELS
	WL	3,Y4JD4A+FR6
	WL	3,Y4JD4A+FR7
	WL	6,Y4JD4A+FR8
	WL	3,Y4JD4A+FR9

	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	yok_climbin_side_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	ANI_CODE,SET_DIR_FACE
	.word	ANI_SETFACING
	.WORD	ANI_SET_WRESTLER_XFLIP

	;jump in
	WL	4,Y4JD4A+FR1
	WL	4,Y4JD4A+FR2

	WL	ANI_CODE,#set_trgt
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	.word	ANI_LEAPATPOS,1ch,200,0,0,0	;#ticks,dist,xoff,yoff,zoff

	WL	4,Y4JD4A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH

	WL	4,Y4JD4A+FR6
	WL	3,Y4JD4A+FR7
	WL	3,Y4JD4A+FR8

	WL	ANI_CODE,#set_z
	WLW	ANI_SET_XVEL,4000h,AM_FACE_REL

	;climb through
	WL	3,Y4CR3B+FR1
	.word	ANI_OFFSET,10,0,0	;*****
	WL	3,Y4CR3B+FR2
	.word	ANI_BENDROPE,2
	.word	ANI_OFFSET,10,0,0	;*****
	WL	3,Y4CR3B+FR3
	.word	ANI_OFFSET,10,0,0	;*****
	WL	3,Y4CR3B+FR4
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM


	.word	ANI_OFFSET,0,0,0	;*****
	WL	3,Y4CR3B+FR5
	.word	ANI_OFFSET,0,0,0	;*****
	WL	3,Y4CR3B+FR6
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_OFFSET,10,0,0	;*****
	WL	3,Y4CR3B+FR8
	.word	ANI_BENDROPE,3
	.word	ANI_OFFSET,10,0,0	;*****
	WL	3,Y4CR3B+FR9
	.word	ANI_OFFSET,10,0,0	;*****
	WL	3,Y4CR3B+FR10
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM
	.word	ANI_BENDROPE,-1
	.word	ANI_OFFSET,6,0,0
	WL	3,Y4CR3B+FR11
	.word	ANI_OFFSET,8,0,0
	WL	3,Y4CR3B+FR12
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
 SUBR	yok_climbthru_bot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

;Must rotate toward ropes!
;Do a different sequence

	;lie down
	WL	ANI_CODE,#ckspin
	WL	ANI_IFSTATUS,#dir4

;Facing #2, spin first!
	WL	3,Y1TT5Z+FR2
	WL	3,Y1TT5Z+FR3
#dir4
	WL	4,Y3GU2A+FR14
	WL	4,Y3GU2A+FR13
	WL	4,Y3GU2A+FR12
	WL	4,Y3GU2A+FR11
	WL	4,Y3GU2A+FR10
	WL	4,Y3GU2A+FR9
	WL	4,Y3GU2A+FR8
	WL	4,Y3GU2A+FR7

	;roll over once
	WLW	ANI_SET_ZVEL,90000h,AM_ABS

	WL	3,Y3RL1A+FR6
	WL	3,Y3RL1A+FR7
	WL	3,Y3RL1A+FR8
	WL	3,Y3RL1A+FR9
	WL	3,Y3RL1A+FR10
	WL	3,Y3RL1A+FR1
	WL	3,Y3RL1A+FR2
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP+MODE_NOSHADOW

	;climb through
	.word	ANI_OFFSET,0,-37h,0			;x,y,z
	.WORD	ANI_XFLIP
	WL	3,Y2KB3A+FR7
	WL	3,Y2KB3A+FR6
	WL	3,Y2KB3A+FR5
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

 SUBR	yok_climbin_bot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;climb in
	.word	ANI_GRAVITY_OFF
	.WORD	ANI_XFLIP
	WL	3,Y2KB3A+FR5
	WL	3,Y2KB3A+FR6
	WL	3,Y2KB3A+FR7
	.WORD	ANI_XFLIP
	.word	ANI_OFFSET,0,37h,-60

	;roll
	WLW	ANI_SET_ZVEL,-70000h,AM_ABS
	.word	ANI_FRICTION,3000h
	WL	3,Y3RL1A+FR1
	WL	3,Y3RL1A+FR10
	WL	3,Y3RL1A+FR9
	WL	3,Y3RL1A+FR8
	WL	3,Y3RL1A+FR7
	WL	3,Y3RL1A+FR6
	.word	ANI_ZEROVELS
	.word	ANI_GRAVITY_ON

	;get up
	WL	4,Y3GU2A+FR7
	WL	4,Y3GU2A+FR8
	WL	4,Y3GU2A+FR9
	WL	4,Y3GU2A+FR10
	WL	4,Y3GU2A+FR11
	WL	4,Y3GU2A+FR12
	WL	4,Y3GU2A+FR13
	WL	4,Y3GU2A+FR14

	WL	ANI_CODE,clr_climb

	.word	ANI_FACEDOWN
	.word	ANI_ZEROVELS
	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END

#*****************************************************************************

 SUBR	yok_climbthru_top_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;lie down
	WL	ANI_CODE,#set_zvel1
	WL	ANI_IFSTATUS,#dir4
;Facing #2
	WL	3,Y1TT5Z+FR2
	WL	3,Y1TT5Z+FR3
#dir4
	WL	4,Y3GU2A+FR14
	WL	4,Y3GU2A+FR13
	WL	4,Y3GU2A+FR12
	WL	4,Y3GU2A+FR11
	WL	4,Y3GU2A+FR10
	WL	4,Y3GU2A+FR9
	WL	4,Y3GU2A+FR8
	WL	4,Y3GU2A+FR7

	;roll over once
	WL	ANI_CODE,#set_zvel2
	WL	3,Y3RL1A+FR6
	WL	3,Y3RL1A+FR5
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP+MODE_NOSHADOW
	WL	3,Y3RL1A+FR4
	WL	3,Y3RL1A+FR3
	WL	3,Y3RL1A+FR2

	;climb through
	.word	ANI_OFFSET,0,-61,0
	.word	ANI_ZEROVELS
	.WORD	ANI_XFLIP
	WL	3,Y4KB3A+FR6
	WL	3,Y4KB3A+FR7
	WL	3,Y4KB3A+FR8
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

 SUBR	yok_climbin_top_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;climb in
	.WORD	ANI_XFLIP
	WL	3,Y4KB3A+FR8
	WL	3,Y4KB3A+FR7
	WL	3,Y4KB3A+FR6
	.WORD	ANI_XFLIP
	.word	ANI_OFFSET,0,61,0

	;roll over
	WL	ANI_CODE,#set_zvel2
	WL	3,Y3RL1A+FR3
	WL	3,Y3RL1A+FR4
	WL	3,Y3RL1A+FR5
	WL	3,Y3RL1A+FR6	

	.word	ANI_ZEROVELS

	;get up
	WL	4,Y3GU2A+FR7
	WL	4,Y3GU2A+FR8
	WL	4,Y3GU2A+FR9
	WL	4,Y3GU2A+FR10
	WL	4,Y3GU2A+FR11
	WL	4,Y3GU2A+FR12
	WL	4,Y3GU2A+FR13
	WL	4,Y3GU2A+FR14

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

 SUBR	yok_2_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;Rotate!
	WL	3,Y1TT5Z+FR2
	WL	3,Y1TT5Z+FR3
	WL	ANI_GOTO,#cont

 SUBR	yok_4_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

#cont
	WL	4,Y3PF3C+FR1
	WL	4,Y3PF3C+FR2
	WL	4,Y3PF3C+FR3
	WL	4,Y3PF3C+FR4
	WL	4,Y3PF3C+FR5
	WL	4,Y3PF3C+FR6
	WL	4,Y3PF3C+FR7

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 30,999,80h,50h,90000h,TGT_CHEST,0,57,-15

	WL	4,Y3PF3C+FR8
	.word	ANI_OFFSET,0,34,0			;x,y,z
	WL	22,Y3PF3C+FR9

	.word	ANI_SHAKER,40
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_ATTACK_ON_Z, AMODE_STOMP,-40,-8,0,76,20,30 ;mode,x,y,z,w,h,d
	.word	ANI_ZERO_XZVELS
	WL	4,Y3PF3C+FR10
	WL	4,Y3PF3C+FR11
	WL	4,Y3PF3C+FR12
	.word	ANI_ATTACK_OFF
	WL	ANI_CODE,DO_CROWD_CHEER
	.word	ANI_BOUNCE,3
	WL	4,Y3PF3C+FR12
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ATTACK_ON_Z, AMODE_STOMP,-40,-8,0,76,20,30 ;mode,x,y,z,w,h,d
	WL	1,Y3PF3C+FR12
	.word	ANI_ATTACK_OFF
	WL	ANI_SET_YVEL,30000h

	.ref	HIT_THE_MAT,SMALL_BOUNCE

	.word	ANI_OFFSET,0,0,0			;x,y,z

	WL	4,Y3PF3C+FR12
	.ref	win_announce
	WL	ANI_CODE,win_announce
;	WLW	ANI_ATTCHIMAGE,0,0		;Turn it off
	WL	50,Y3PF3C+FR12

;???? IS THIS WHERE IT GOES ?
	.word	ANI_LOOP
;Do another ground hit on opponent
	.ref	grnd_hit
	WL	ANI_CODE,grnd_hit

	WL	ANI_SET_YVEL,42000h
	WLW	ANI_SET_ZVEL,22000h,AM_ABS
	WL	5,Y5GU4B+FR1
	WL	5,Y5GU4B+FR2
	WL	5,Y5GU4B+FR3
	WL	5,Y5GU4B+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	5,Y5GU4B+FR5
	WL	5,Y5GU4V+FR6
	WL	5,Y5GU4B+FR7
	WL	5,Y5GU4B+FR8

	WL	7,Y5RV5A+FR1
	WL	7,Y5RV5A+FR2
	WL	7,Y5RV5A+FR3
	WL	7,Y5RV5A+FR4
	WL	7,Y5RV5A+FR5
	WL	7,Y5RV5A+FR6
	WL	7,Y5RV5A+FR7
	WL	7,Y5RV5A+FR8
	WL	40,Y5RV5A+FR9
	WL	7,Y5RV5A+FR10
	WL	7,Y5RV5A+FR11
	WL	1000,Y5RV5A+FR12

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************
	.end
