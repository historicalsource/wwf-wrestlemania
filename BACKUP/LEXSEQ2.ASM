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
* Initiated:		7/15/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"lexseq2.asm"
	.title	"Lex Luger animation sequences"
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

	.include	"leximg.h"
	.include	"takerimg.h"		;<-- temp!
	.include	"damage.equ"


******************************************************************************
* EXTERNAL REFERENCES

	.REF	DO_CROWD_CHEER
	.ref	SET_DIR_FACE,no_bk_xvel,start_run_anim,CALL_MISSES
	.ref	ckzpos,ck_dizzy
	.ref	check_xvel

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* #2 BLOCK & HITBLOCK

 SUBR	lex_2_block_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_FRICTION,3000h
	WLW	ANI_SET_ZVEL,0,AM_ABS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
;Rotate toward opponent if needed!

	.word	ANI_SETPLYRMODE,MODE_BLOCK
	WL	4,L2BK3A+FR1
	WL	4,L2BK3A+FR2
	WL	10,L2BK3A+FR5
#2block
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	WL	1,L2BK3A+FR5
	.word	ANI_ZERO_XZVELS
	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	WL	4,L2BK3A+FR2
	WL	4,L2BK3A+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_2_hitblock_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	WL	4,L2BK3B+FR2
	WL	4,L2BK3B+FR1
	WL	ANI_GOTO,#2block

#************
*
* #4 BLOCK & HITBLOCK

 SUBR	lex_4_block_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_FRICTION,3000h
	WLW	ANI_SET_ZVEL,0,AM_ABS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
;Rotate toward opponent if needed!

	.word	ANI_SETPLYRMODE,MODE_BLOCK
	WL	4,L4BK3B+FR1
	WL	4,L4BK3B+FR3
	WL	10,L4BK3B+FR5
#4block
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	WL	1,L4BK3B+FR5
	.word	ANI_ZERO_XZVELS
	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	WL	4,L4BK3B+FR3
	WL	4,L4BK3B+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_4_hitblock_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	WL	4,L4BK3C+FR2
	WL	4,L4BK3C+FR1
	WL	ANI_GOTO,#4block


#*****************************************************************************
*
* #2 NORMAL PUNCH

 SUBR	lex_2_punch_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	3,L2PU2B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_PUNCH,6
	WL	3,L2PU2B+FR2
	WL	3,L2PU2B+FR3
	.word	ANI_ATTACK_ON, AMODE_PUNCH,20,81,54,19	;mode,x,y,w,h
	WL	3,L2PU2B+FR4
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-30000h,#no_hit

	WL	ANI_SET_YVEL,30000h
	WL	3,L2PU2B+FR4
#no_hit
	WL	3,L2PU2B+FR5
	WL	3,L2PU2B+FR6
	WL	3,L2PU2B+FR7
	WL	2,L2PU2B+FR8
	WL	2,L2PU2B+FR9


	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 NORMAL PUNCH

 SUBR	lex_4_punch_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	3,L4PU3B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_PUNCH,6
	WL	3,L4PU3B+FR2
	WL	3,L4PU3B+FR3
	.word	ANI_ATTACK_ON, AMODE_PUNCH,20,81,54,19	;mode,x,y,w,h
	WL	3,L4PU3B+FR4
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-30000h,#no_hit2
	WL	ANI_SET_YVEL,30000h
	WL	3,L4PU3B+FR4
	
#no_hit2
	WL	3,L4PU3B+FR5
	WL	3,L4PU3B+FR6
	WL	3,L4PU3B+FR7
	WL	2,L4PU3B+FR8
	WL	2,L4PU3B+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

;#*****************************************************************************
;*
;* #2 TURBO PUNCH
;
;; SUBR	lex_2_turbopunch_anim
;
;	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
;	.word	ANI_SETSPEED,100h
;	.word	ANI_ZEROVELS
;
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END
;
;#************
;*
;* #4 TURBO PUNCH
;
; SUBR	lex_2_turbopunch_anim
; SUBR	lex_4_turbopunch_anim
;
;	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
;	.word	ANI_SETSPEED,100h
;	.word	ANI_ZEROVELS
;
;	WL	5,L4BZ3C+FR1
;	WL	5,L4BZ3C+FR2
;	WL	5,L4BZ3C+FR3
;
;	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 15-1,999,80,20,90000h,TGT_HEAD,77,0,10
;	WL	ANI_SET_YVEL,0
;
;	WL	5,L4BZ3C+FR4
;	WL	5,L4BZ3C+FR5
;	WL	5,L4BZ3C+FR6
;
;	.word	ANI_ZERO_XZVELS
;
;	WL	15,L4BZ3C+FR6
;
;	WL	5,L4BZ3C+FR7
;	WL	5,L4BZ3C+FR8
;	WL	5,L4BZ3C+FR9
;	WL	5,L4BZ3C+FR10
;
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END

#*****************************************************************************
*
* #2 PUSH

 SUBR	lex_2_push_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUSH,9
	WL	3,L2PS3A+FR2
	WL	3,L2PS3A+FR3
	WL	3,L2PS3A+FR4
	.word	ANI_ATTACK_ON, AMODE_PUSH,41,77,61,20 ;mode,x,y,w,h
	WL	3,L2PS3A+FR6
	.word	ANI_ATTACK_OFF

;	WL	ANI_IFNOTSTATUS,#missed
;	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

	WWL	ANI_SLIDE_BACK,40h,-60000h,#no_hit	;range,vel,addr
	WL	15,L2PS3A+FR6
#no_hit
	WL	3,L2PS3A+FR6
	WL	3,L2PS3A+FR7
	WL	3,L2PS3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 PUSH

 SUBR	lex_4_push_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUSH,9
	WL	3,L4PS3A+FR1
	WL	3,L4PS3A+FR2
	WL	3,L4PS3A+FR3
	.word	ANI_ATTACK_ON, AMODE_PUSH,41,77,61,20 ;mode,x,y,w,h
	WL	3,L4PS3A+FR4
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,40h,-60000h,#no_hit	;range,vel,addr
	WL	15,L4PS3A+FR4
#no_hit
	WL	4,L4PS3A+FR4
	WL	3,L4PS3A+FR3
	WL	3,L4PS3A+FR2
	WL	3,L4PS3A+FR1

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************
*
* #4 LOSE BALANCE

 SUBR	lex_4_losebal_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_FRICTION,3000h
	.word	ANI_SETSPEED,100h
	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL
  
	WL	4,L3PB3A+FR3
	WL	4,L3PB3A+FR4
	WL	4,L3PB3A+FR5
	WL	4,L3PB3A+FR6
	WL	4,L3PB3A+FR7
	WL	4,L3PB3A+FR8
	WL	4,L3PB3A+FR9

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 PUNCH FALLEN OPPONENT

 SUBR	lex_2_ground_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	3,L2PT2B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_LBDROP,11
	WL	3,L2PT2B+FR2

	;if we're going to miss, do a leapat
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,-4,-6,-40,37,36,50
	WL	1,L2PT2B+FR2
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#leapat_stomp

	WL	ANI_SET_YVEL,20000h

	WL	3,L2PT2B+FR3
	WL	3,L2PT2B+FR4
	WL	1,L2PT2B+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,L2PT2B+FR6
	WL	3,L2PT2B+FR7

	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,-4,-6,-40,37,36,50
	WL	1,L2PT2B+FR8
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#hit
	WL	ANI_GOTO,#missed

#leapat_stomp
	;too far.  leap at the chest.
	.word	ANI_TARGET,TGT_CHEST,TGT_KNEES,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,112,96,90000h,TGT_USER,13,0,-40
	WL	ANI_CODE,no_bk_xvel
	.word	ANI_STARTATTACK,AT_LBDROP,16
	
	WL	3,L2PT2B+FR3
	WL	3,L2PT2B+FR4
	WL	1,L2PT2B+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	2,L2PT2B+FR6
	WL	2,L2PT2B+FR7
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,-4,-6,-40,37,36,50
	WL	1,L2PT2B+FR8
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#hit
	WL	ANI_GOTO,#missed

#hit
	.word	ANI_SHAKER,18
	.word	ANI_SHAKEALL,1
	WL	7,L2PT2B+FR8
	WL	3,L2PT2B+FR9
	WL	3,L2PT2B+FR10
	WL	3,L2PT2B+FR11

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES

	WL	7,L2PT2B+FR8
	WL	3,L2PT2B+FR9
	WL	3,L2PT2B+FR10
	WL	3,L2PT2B+FR11

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #4 PUNCH FALLEN OPPONENT

 SUBR	lex_4_ground_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	3,L4PT4B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_STOMP,18
	WL	3,L4PT4B+FR2
	WL	2,L4PT4B+FR3

	;if we're going to miss, do a leapat
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,-3,-1,-10,29,28,50
	WL	1,L4PT4B+FR3
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#leapat_stomp

	WL	ANI_SET_YVEL,20000h

	WL	3,L4PT4B+FR4
	WL	3,L4PT4B+FR5
	.word	ANI_WAITHITGND		;just in case OFFSET left us in air
	WL	3,L4PT4B+FR6
	WL	3,L4PT4B+FR7
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,-3,-1,-10,29,28,50
	WL	1,L4PT4B+FR8
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#hit
	WL	ANI_GOTO,#missed

#leapat_stomp

	.word	ANI_TARGET,TGT_CHEST,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,112,96,90000h,TGT_USER,15,0,50
	WL	ANI_CODE,no_bk_xvel
	.word	ANI_STARTATTACK,AT_STOMP,16

	WL	3,L4PT4B+FR4
	WL	3,L4PT4B+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,L4PT4B+FR6
	WL	2,L4PT4B+FR7
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,-3,-1,-10,29,28,50
	WL	1,L4PT4B+FR8
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#hit
	WL	ANI_GOTO,#missed

#hit
	.word	ANI_SHAKER,18
	.word	ANI_SHAKEALL,1

	WL	7,L4PT4B+FR8
	WL	4,L4PT4B+FR9
	WL	4,L4PT4B+FR10
	WL	4,L4PT4B+FR11

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES

	WL	7,L4PT4B+FR8
	WL	4,L4PT4B+FR9
	WL	4,L4PT4B+FR10
	WL	4,L4PT4B+FR11

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #2 HEADBUTT

 SUBR	lex_2_butt_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,L2BC3E+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_HDBUTT,6
	WL	3,L2BC3E+FR3
	WL	3,L2BC3E+FR4
	.word	ANI_ATTACK_ON, AMODE_HDBUTT,8,85,30,18	;mode,x,y,w,h
	WL	3,L2BC3E+FR5
	.word	ANI_ATTACK_OFF
	WL	3,L2BC3E+FR5
	WL	3,L2BC3E+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 HEADBUTT

 SUBR	lex_4_butt_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,L4BC3D+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_HDBUTT,6
	WL	3,L4BC3D+FR3
	WL	3,L4BC3D+FR4
	.word	ANI_ATTACK_ON, AMODE_HDBUTT,8,85,30,18	;mode,x,y,w,h
	WL	3,L4BC3D+FR5
	.word	ANI_ATTACK_OFF
	WL	3,L4BC3D+FR5
	WL	3,L4BC3D+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 KICK

 SUBR	lex_2_kick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h


	WL	2,L2KM3A+FR1
	WL	1,L2KM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KICK,6
	WL	2,L2KM3A+FR2
	WL	2,L2KM3A+FR3
	WL	2,L2KM3A+FR4
	.word	ANI_ATTACK_ON, AMODE_KICK,27,59,68,20	;mode,x,y,w,h
	WL	3,L2KM3A+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-40000h,#no_hit
	WL	ANI_SET_YVEL,30000h
	WL	3,L2KM3A+FR5
	
#no_hit
	WL	3,L2KM3A+FR5
	WL	2,L2KM3A+FR6
	WL	2,L2KM3A+FR7
	WL	3,L2KM3A+FR8
	WL	3,L2KM3A+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 KICK

 SUBR	lex_4_kick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	WL	2,L4KM3B+FR1
	WL	1,L4KM3B+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_KICK,6
	WL	2,L4KM3B+FR2
	WL	2,L4KM3B+FR3
	WL	2,L4KM3B+FR4
	.word	ANI_ATTACK_ON, AMODE_KICK,27,59,68,20	;mode,x,y,w,h
	WL	3,L4KM3B+FR5
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-40000h,#no_hit2
	WL	ANI_SET_YVEL,30000h
	WL	3,L4KM3B+FR5
#no_hit2
	WL	3,L4KM3B+FR5
	WL	2,L4KM3B+FR6
	WL	2,L4KM3B+FR7
	WL	3,L4KM3B+FR8
	WL	3,L4KM3B+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #3 FLYING KICK (FLYING ELBOW)


 SUBR	lex_flying_kick_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	.word	ANI_ZEROVELS

	WL	3,L3DC3B+FR1
	WL	3,L3DC3B+FR2
	WL	3,L3DC3B+FR3

	WLW	ANI_SET_XVEL,50000h,AM_FACE_REL
	WL	ANI_SET_YVEL,60000h
	.word	ANI_OFFSET,24,44,0			;x,y,z

	WL	8,L3DC3B+FR5
	WL	4,L3DC3B+FR6

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	10,L3DC3B+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 STOMP ON FALLEN OPPONENT

 SUBR	lex_2_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	4,L2MP2A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	3,L2MP2A+FR2

	;if we're going to miss, do a leapat
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,7,-2,-40,23,32,50
	WL	1,L2MP2A+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#leapat_stomp

	.word	ANI_STARTATTACK,AT_STOMP,12
	WL	4,L2MP2A+FR3
	WL	4,L2MP2A+FR5
	WL	4,L2MP2A+FR6
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,3,-6,-40,31,40,50
	WL	3,L2MP2A+FR7
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#hit
	WL	ANI_CODE,CALL_MISSES
#hit
	WL	3,L2MP2A+FR8
	WL	3,L2MP2A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#leapat_stomp

	.word	ANI_TARGET,TGT_GROIN,TGT_CHEST,ATM_CLOSEST
	;too far.  leap at the chest.
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 14,999,112,96,90000h,TGT_USER,17,0,-50
	WL	ANI_CODE,no_bk_xvel
	.word	ANI_STARTATTACK,AT_STOMP,14
	
	WL	3,L2MP2A+FR3
	WL	3,L2MP2A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,L2MP2A+FR6
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,3,-6,-40,31,40,50
	WL	3,L2MP2A+FR7
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#leapat_hit
	WL	ANI_CODE,CALL_MISSES
#leapat_hit
	WL	3,L2MP2A+FR8
	WL	3,L2MP2A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #4 STOMP ON FALLEN OPPONENT

 SUBR	lex_4_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	3,L4MP3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	;if we're going to miss, do a leapat
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,1,-9,-10,31,30,50
	WL	1,L4MP3A+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#leapat_stomp

	.word	ANI_STARTATTACK,AT_STOMP,14
	WL	4,L4MP3A+FR3
	WL	4,L4MP3A+FR4
	WL	4,L4MP3A+FR5
	WL	2,L4MP3A+FR6
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,-3,-13,-10,39,38,50
	WL	4,L4MP3A+FR7
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#hit
	WL	ANI_CODE,CALL_MISSES
#hit
	WL	4,L4MP3A+FR9
	WL	4,L4MP3A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#leapat_stomp

	.word	ANI_TARGET,TGT_KNEES,TGT_CHEST,ATM_CLOSEST
	;too far.  leap at the chest.
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 14,999,112,96,90000h,TGT_USER,13,0,50
	WL	ANI_CODE,no_bk_xvel
	.word	ANI_STARTATTACK,AT_STOMP,14
	WL	3,L4MP3A+FR3
	WL	3,L4MP3A+FR4
	WL	3,L4MP3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,L4MP3A+FR6
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,-3,-13,-10,39,38,50
	WL	4,L4MP3A+FR7
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#leapat_hit
	WL	ANI_CODE,CALL_MISSES
#leapat_hit
	WL	4,L4MP3A+FR9
	WL	4,L4MP3A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #3 FLYING GROUND-PUNCH

#yoff	equ	25

 SUBR	lex_flying_ground_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h

	WL	3,L3PJ3F+FR1

	.word	ANI_TARGET,TGT_CHEST,TGT_GROIN,ATM_FARTHEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 25,200,150,90,90000h,TGT_USER,56,#yoff,50
	.word	ANI_SETPLYRMODE,MODE_INAIR
	WL	ANI_CODE,no_bk_xvel
	.word	ANI_STARTATTACK,AT_BUTTSTOMP,25

	.word	ANI_OFFSET,0,#yoff,0
	WL	3,L3PJ3F+FR3
	WL	3,L3PJ3F+FR4
	WL	3,L3PJ3F+FR5
	WL	4,L3PJ3F+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,L3PJ3F+FR7

	.word	ANI_ATTACK_ON_Z,AMODE_BUTTSTOMP,5,-11,-10,50,34,70
	WL	1,L3PJ3F+FR9
	.word	ANI_ATTACK_OFF

	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,1
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	7,L3PJ3F+FR9
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	4,L3PJ3F+FR10

	WL	4,L3GU4B+FR8
	WL	4,L3GU4B+FR9
	WL	4,L3GU4B+FR10

	.word	ANI_ZEROVELS
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* BUTT-KICKIN' TWO-FISTED OVERHEAD PUNCH TURNBUCKLE LEAP ATTACK SEQUENCE

#yoff	equ	25

 SUBR	lex_buckle_leap_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCONFINE|MODE_NOCOLLIS|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING

	WL	3,L3PJ3F+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 31,190,190,190,90000h,TGT_GROIN,25,11+#yoff,50
	.word	ANI_SETPLYRMODE,MODE_INAIR2
	.word	ANI_GRAVITY_ON
	.word	ANI_SHAKECORNER
	.word	ANI_STARTATTACK,AT_BSTOMP,31

;Check x vel to make sure we aren't going to land on ropes!
	WL	ANI_CODE,check_xvel

	.word	ANI_OFFSET,0,#yoff,0
	WL	3,L3PJ3F+FR3
	WL	3,L3PJ3F+FR4
	WL	3,L3PJ3F+FR5

	;attack box dimensions (that means size) depends on opp mode
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-2,12,-10,31,76,70
	WWL	ANI_IFOPPMODE,MODE_ONGROUND,#opp_onground
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,3,70,-10,39,27,70

#opp_onground
	WL	1,L3PJ3F+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_OFF

	WL	2,L3PJ3F+FR7
	WL	4,L3PJ3F+FR9

	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,1
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	ANI_IFSTATUS,#hit

	;missed
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_BOUNCE,5

#hit
	WL	7,L3PJ3F+FR9
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	4,L3PJ3F+FR10

	WL	4,L3GU4B+FR8
	WL	4,L3GU4B+FR9
	WL	4,L3GU4B+FR10

	.word	ANI_ZEROVELS
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #2 KNEE

 SUBR	lex_2_knee_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,L2NM3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	3,L2NM3A+FR2
	WL	3,L2NM3A+FR3
	WL	3,L2NM3A+FR4
	WL	3,L2NM3A+FR5
	WL	3,L2NM3A+FR6
	WL	3,L2NM3A+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 KNEE

 SUBR	lex_4_knee_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,L4NM3B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	3,L4NM3B+FR2
	WL	3,L4NM3B+FR3
	WL	3,L4NM3B+FR4
	WL	3,L4NM3B+FR5
	WL	3,L4NM3B+FR6
	WL	3,L4NM3B+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* GRAB & FLING OPPONENT (INTO A RUN)

 SUBR	lex_2_grabfling_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_STARTATTACK,AT_PUPPET,14
	WL	3,L1TT5A+FR4
	WL	3,L1TT5A+FR5
	WL	ANI_GOTO,#cont

 SUBR	lex_4_grabfling_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

#cont
	.word	ANI_STARTATTACK,AT_PUPPET,8
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,40,0,25
	WL	ANI_SET_YVEL,0000h
	WL	4,L4GF3B+FR1

	.word	ANI_ATTACK_ON, AMODE_PUPPET,33,56,54,18 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,L4GF3B+FR2
;	WL	4,L4GF3B+FR2
	.word	ANI_ZERO_XZVELS
	WWL	ANI_WAITHITOPP,4,L4GF3B+FR3
;	WL	4,L4GF3B+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

;got him
	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

; attacker sequence
	WWLLW	ANI_SUPERSLAVE2,10,L4GF3B+FR3,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,6,L4GF3B+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,L4GF3B+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,L4GF3B+FR6,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,L4GF3B+FR7,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,L4GF3B+FR8,#puppet_tbl,5

	WL	ANI_SLAVEANIM,#strt_run_tbl

	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_DETACH
	WL	16,L4GF3B+FR8
	.word	ANI_OFFSET,-3,0,0			;x,y,z

	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#missedb
	WL	25,L4GF3B+FR3
#missed
	WL	ANI_CODE,CALL_MISSES


	WL	8,L4GF3B+FR3
	WL	4,L4GF3B+FR2
	WL	4,L4GF3B+FR1

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
	.ref	L4YR3B,L3RN3B
	.ref	D4YR3B,D3RN3B

#Bret
 LWWW H4YR3A+FR1,56,8,1
 LWWW H4YR3A+FR2,48,9,1
 LWWW H4YR3A+FR3,40,4,1
 LWWW H4YR3A+FR5,19,4,1
 LWWW H3RN3A+FR1,-4,-5,0
 LWWW H3RN3A+FR2,-21,-5,0
#Razor
 LWWW R4YR3A+FR1,36,20,0
 LWWW R4YR3A+FR2,22,22,0
 LWWW R4YR3A+FR3,2,6,0
 LWWW R4YR3A+FR4,-15,4,0
 LWWW R3RN3D+FR10,-15,4,0
 LWWW R3RN3D+FR11,-21,7,0
#Taker
 LWWW U4YR3B+FR2,42,19,0
 LWWW U4YR3B+FR3,43,16,0
 LWWW U4YR3B+FR4,22,17,0
 LWWW U4YR3B+FR5,5,13,0
 LWWW U3RN3A+FR2,-14,5,0
 LWWW U3RN3A+FR2,-36,4,0
#Yokozuna
 LWWW Y4YR3A+FR1,56,15,1
 LWWW Y4YR3A+FR4,30,17,1
 LWWW Y4YR3A+FR5,16,11,1
 LWWW Y4YR3A+FR7,-26,-4,1
 LWWW Y3RN3C+FR7,8,4,0
 LWWW Y3RN3C+FR8,7,2,0
#Shawn
 LWWW S4YR3A+FR2,50,5,1
 LWWW S4YR3A+FR3,61,-4,1
 LWWW S4YR3A+FR5,15,3,1
 LWWW S4YR3A+FR6,-12,-1,1
 LWWW S3RN3A+FR1,-3,-5,0
 LWWW S3RN3A+FR2,-32,-6,0
#BamBam
 LWWW B4YR3A+FR3,33,13,0
 LWWW B4YR3A+FR4,43,8,0
 LWWW B4YR3A+FR5,41,4,0
 LWWW B4YR3A+FR7,-6,-2,0
 LWWW B3RN3A+FR1,10,5,0
 LWWW B3RN3A+FR2,-8,6,0
#Doink
 LWWW D4YR3B+FR1,69,16,1
 LWWW D4YR3B+FR2,58,20,1
 LWWW D4YR3B+FR3,39,14,1
 LWWW D4YR3B+FR4,16,12,1
 LWWW D3RN3B+FR3,5,9,0
 LWWW D3RN3B+FR4,-16,8,0
#Adam
 .long 0
#Lex
 LWWW L4YR3B+FR1,63,16,1
 LWWW L4YR3B+FR2,43,9,1
 LWWW L4YR3B+FR3,18,7,1
 LWWW L4YR3B+FR4,-25,0,1
 LWWW L3RN3B+FR2,-8,7,0
 LWWW L3RN3B+FR3,-14,1,0


#strt_run_tbl
	.ref	start_run_flung

	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung


#*****************************************************************************
*
* #2 HEAD HIT

 SUBR	lex_2_head_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

	WL	3,L2AH2A+FR3
	WL	3,L2AH2A+FR4
	WL	3,L2AH2A+FR5
	WL	3,L2AH2A+FR6
	WL	3,L2AH2A+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

;From spin kick
 SUBR	lex_2_head_hit3_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,40000h

	WL	3,L2AH2A+FR3
	.word	ANI_DEBRIS,300,2,-23,102,0	;%chance, tbl index, x,y,z off
	WL	4,L2AH2A+FR4
	WL	4,L2AH2A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	4,L2AH2A+FR6
	WL	4,L2AH2A+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 HEAD HIT

 SUBR	lex_4_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,L4AH4A+FR1
	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off
	WL	3,L4AH4A+FR2
	WL	3,L4AH4A+FR3
	WL	3,L4AH4A+FR4
	WL	3,L4AH4A+FR5
	WL	3,L4AH4A+FR6
	WL	3,L4AH4A+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

;From spin kick
 SUBR	lex_4_head_hit3_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-20000h,AM_ABS
	WL	ANI_SET_YVEL,40000h

	WL	3,L4AH4A+FR1
	WL	3,L4AH4A+FR2
	WL	3,L4AH4A+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,L4AH4A+FR4
	WL	3,L4AH4A+FR5
	WL	3,L4AH4A+FR6
	WL	3,L4AH4A+FR7

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_4_head_hit4_anim
;From earslap

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,40000h

	WL	4,L4AH4A+FR3
	WL	4,L4AH4A+FR4
	WL	4,L4AH4A+FR5
	WL	4,L4AH4A+FR6
	WL	4,L4AH4A+FR7

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************
*
* #2 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	lex_2_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

	WL	3,L2AH2A+FR3
	WL	15,L2AH2A+FR4
	WL	4,L2AH2A+FR5

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	lex_4_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

	WL	3,L4AH4A+FR1
	WL	3,L4AH4A+FR2
	WL	14,L4AH4A+FR3
	WL	2,L4AH4A+FR4

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


* #4 RUNNING BOUNCE OFF OF OPPONENT

;Bounce off but stay dizzy!

 SUBR	lex_4_bncoff_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	3,L4AH4A+FR1
	WL	3,L4AH4A+FR2
	WL	14,L4AH4A+FR3
	WL	2,L4AH4A+FR4

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,lex_dizzy_anim
	.word	ANI_END



#*****************************************************************************
*
* #2 HEAD HIT2 (HANDS ON FACE)

 SUBR	lex_2_head_hit2_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,-40000h,AM_HIT_REL
	WL	ANI_SET_YVEL,30000h
	.word	ANI_FRICTION,3000h

	WL	3,L2AE2A+FR1
	WL	3,L2AE2A+FR2
	WL	3,L2AE2A+FR3
	WL	3,L2AE2A+FR4
	WL	3,L2AE2A+FR5
	WL	3,L2AE2A+FR6
	WL	3,L2AE2A+FR7
	WL	3,L2AE2A+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 HEAD HIT2 (HANDS ON FACE)

 SUBR	lex_4_head_hit2_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,-40000h,AM_HIT_REL
	WL	ANI_SET_YVEL,30000h
	.word	ANI_FRICTION,3000h

	WL	4,L4AE4A+FR1
	WL	4,L4AE4A+FR2
	WL	4,L4AE4A+FR3
	WL	4,L4AE4A+FR4
	WL	4,L4AE4A+FR5

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* HEAD HIT2 (ENDS IN DIZZY)

 SUBR	lex_head_hit_dizzy_anim


	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,-40000h,AM_HIT_REL
	WL	ANI_SET_YVEL,20000h
	.word	ANI_FRICTION,3000h
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	4,L4AE4A+FR1
	WL	4,L4AE4A+FR2
	WL	4,L4AE4A+FR3
	WL	4,L4AE4A+FR4
	WL	4,L4AE4A+FR5

	.word	ANI_FACEDOWN

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,lex_dizzy_anim

	.word	ANI_END


#*****************************************************************************
*
* #2 BODY HIT

 SUBR	lex_2_body_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL

	WL	3,L2AM2B+FR2
	.word	ANI_DEBRIS,100,0,6,72,0	;%chance, tbl index, x,y,z off
	WL	3,L2AM2B+FR3
	WL	3,L2AM2B+FR4
	WL	3,L2AM2B+FR5
	WL	3,L2AM2B+FR6
	WL	3,L2AM2B+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,L2AM2B+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_2_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,78000h

	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,4000h,AM_ABS

	WL	3,L2AM2B+FR2
	.word	ANI_DEBRIS,100,0,6,72,0	;%chance, tbl index, x,y,z off
	WL	3,L2AM2B+FR3
	WL	3,L2AM2B+FR4
	WL	3,L2AM2B+FR5
	WL	3,L2AM2B+FR6
	WL	3,L2AM2B+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,L2AM2B+FR8

	.word	ANI_FACEUP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 BODY HIT

 SUBR	lex_4_body_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL

	WL	3,L4AM4B+FR2
	.word	ANI_DEBRIS,100,0,6,72,0	;%chance, tbl index, x,y,z off
	WL	3,L4AM4B+FR3
	WL	3,L4AM4B+FR4
	WL	3,L4AM4B+FR5
	WL	3,L4AM4B+FR6
	WL	3,L4AM4B+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,L4AM4B+FR8

	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_4_body_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	3,L4AM4B+FR2
	.word	ANI_DEBRIS,100,0,6,72,0	;%chance, tbl index, x,y,z off
	WL	3,L4AM4B+FR3
	WL	3,L4AM4B+FR4
	WL	3,L4AM4B+FR5
	WL	3,L4AM4B+FR6
	WL	3,L4AM4B+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,L4AM4B+FR8

	.word	ANI_FACEDOWN

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,lex_dizzy_anim
	.word	ANI_END

 SUBR	lex_4_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,78000h

	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-4000h,AM_ABS

	WL	3,L4AM4B+FR2
	.word	ANI_DEBRIS,100,0,6,72,0	;%chance, tbl index, x,y,z off
	WL	3,L4AM4B+FR3
	WL	3,L4AM4B+FR4
	WL	3,L4AM4B+FR5
	WL	3,L4AM4B+FR6
	WL	3,L4AM4B+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,L4AM4B+FR8

	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	lex_quick_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h

	WL	3,L4AM4B+FR2
	WL	3,L4AM4B+FR3
	WL	3,L4AM4B+FR4
	WL	3,L4AM4B+FR5
	WL	3,L4AM4B+FR6
	WL	3,L4AM4B+FR7
	WL	3,L4AM4B+FR8
	.word	ANI_WAITHITGND

	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,lex_fall_back_anim
	.word	ANI_END

#nodead

	.ref	lex_3_head_held_anim
	WL	ANI_CHANGEANIM,lex_3_head_held_anim
	.word	ANI_END

 SUBR	lex_4_knee_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,78000h

	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-4000h,AM_ABS

	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	4,L4AM4B+FR2
	WL	4,L4AM4B+FR3
	WL	4,L4AM4B+FR4
	WL	4,L4AM4B+FR5
	WL	4,L4AM4B+FR6
	WL	4,L4AM4B+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	4,L4AM4B+FR8

	.word	ANI_FACEDOWN

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,lex_dizzy_anim
	.word	ANI_END

#*****************************************************************************
*
* HITS ON GROUND

 SUBR	lex_hitonground_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h

	WL	1,L3CP3X+FR2
	WL	ANI_SET_YVEL,39000h
	.word	ANI_DEBRIS,50,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	2,L3CP3X+FR2
	WL	3,L3CP3X+FR3
	WL	3,L3CP3X+FR4
	WL	3,L3CP3X+FR5
	WL	3,L3CP3X+FR6
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_ZEROVELS
	WL	3,L3CP3X+FR7
	WL	3,L3CP3X+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim

;MJT Start
#*****************************************************************************
*
* FALL BACK

 SUBR	lex_fall_back_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,70000h

	WL	ANI_CODE,ckzpos

	WWL	ANI_SETLONG,DEBRIS_X,[102,13]	;Y,X of head
	WL	4,L3UC3A+FR1
	WWL	ANI_SETLONG,DEBRIS_X,[107,-2]	;Y,X of head
	WL	4,L3UC3A+FR2

;Need more frames here to make smoother!

	.word	ANI_OFFSET,0,47,0			;x,y,z

	WWL	ANI_SETLONG,DEBRIS_X,[39,-50]	;Y,X of head
	WL	4,L3UC3A+FR3
	WWL	ANI_SETLONG,DEBRIS_X,[28,-54]	;Y,X of head
	WL	4,L3UC3A+FR4
	WWL	ANI_SETLONG,DEBRIS_X,[13,-59]	;Y,X of head
	WL	4,L3UC3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP

	.word	ANI_DEBRIS,100,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,35

	.word	ANI_FRICTION,3000h

	WWL	ANI_SETLONG,DEBRIS_X,0		;Y,X of head
	.word	ANI_XFLIP
	WL	2,L3CP3X+FR2
	.word	ANI_BOUNCE,5

	WL	ANI_CHANGEANIM,lex_hitonground_anim

#*****************************************************************************
*
* FALL BACK

;FIX!!  Add roll over onto neck!
 SUBR	lex_fall_back2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,10000h

	WL	ANI_CODE,ckzpos

;	WL	4,L3UC3A+FR1
	WL	4,L3UC3A+FR2

;Need more frames here to make smoother!

	.word	ANI_OFFSET,0,47,0			;x,y,z

	WL	4,L3UC3A+FR3
	WL	4,L3UC3A+FR4
	WL	4,L3UC3A+FR5
	.word	ANI_WAITHITGND

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,35

	.word	ANI_FRICTION,3000h

	.word	ANI_XFLIP
	WL	2,L3CP3X+FR2
	.word	ANI_BOUNCE,5

	WL	ANI_CHANGEANIM,lex_hitonground_anim


#*****************************************************************************
*
* FALL FROM TURNBUCKLE

 SUBR	lex_fall_back_tbukl_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETSPEED,100h

	WL	4,L3UC3A+FR1
	WL	4,L3UC3A+FR2

	.word	ANI_OFFSET,0,47,0			;x,y,z

	WL	4,L3UC3A+FR3
	WL	4,L3UC3A+FR4
	WL	4,L3UC3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_DAMAGE,D_HITCONCRETE

	.word	ANI_DEBRIS,300,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,35

;	.word	ANI_FRICTION,3000h

	.word	ANI_XFLIP
	WL	2,L3CP3X+FR2
;	.word	ANI_BOUNCE,5

	WL	ANI_CHANGEANIM,lex_hitonground_anim

#*****************************************************************************
*
* THROWN FROM RING (shn_bslm, shn_frnk)

 SUBR	lex_flyout_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETSPEED,100h

	WL	8,L3FH3A+FR4
	WL	8,L3FH3A+FR5
	WL	1,L3FH3A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SOUND,0C2h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,60

	.word	ANI_DAMAGE,D_HIPTOSS
	.word	ANI_SETWORD,DELAY_METER,0
	.word	ANI_GETUP,500

	WL	3,L3UC3X+FR6
	WL	3,L3UC3X+FR7
	WL	3,L3UC3X+FR8
	WL	3,L3UC3X+FR9
	WL	3,L3UC3X+FR10
	.word	ANI_XFLIP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim

#*****************************************************************************
*

 SUBR	lex_faceup_getup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

;	WL	4,L3GU4A+FR1
;	WL	4,L3GU4A+FR2
	.ref	choose_2or4
	WL	ANI_CODE,choose_2or4
	WL	ANI_IFSTATUS,#getup_in_4

;#getup_in_2
	WL	4,L3GU2A+FR1
	WL	4,L3GU2A+FR2
	WL	4,L3GU2A+FR3
	WL	4,L3GU2A+FR4
	WL	4,L3GU2A+FR5
	WL	4,L3GU2A+FR6
	WL	4,L3GU2A+FR7
	WL	4,L3GU2A+FR8
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	4,L3GU2A+FR9
	WL	4,L3GU2A+FR10
	.word	ANI_FACEUP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#getup_in_4
	WL	4,L3GU4A+FR1
	WL	4,L3GU4A+FR2
	WL	4,L3GU4A+FR3
	WL	4,L3GU4A+FR4
	WL	4,L3GU4A+FR5
	WL	4,L3GU4A+FR6
	WL	4,L3GU4A+FR7
	WL	4,L3GU4A+FR8
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	4,L3GU4A+FR9
	WL	4,L3GU4A+FR10
	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* DIZZY

 SUBR	lex_dizzy_anim

	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_START_DIZZY,0	;0=Standing dizzy
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

#loop

	WL	8,L4TI4B+FR5
	WL	8,L4TI4B+FR6
	WL	8,L4TI4B+FR7
	WL	8,L4TI4B+FR8
	WL	8,L4TI4B+FR9
	WL	8,L4TI4B+FR8
	WL	8,L4TI4B+FR7
	WL	8,L4TI4B+FR6

	WL	ANI_GOTO,#loop

#*****************************************************************************

 SUBR	lex_roll_frames

	.word	7		;speed
	.long	50000h		;z velocity
	.long	10000h*10/255	;inv multiply (0-255 -> 0-11)

	.long	L3RL1A+FR11	;0
	.long	L3RL1A+FR10	;1
	.long	L3RL1A+FR9	;2
	.long	L3RL1A+FR8	;3
	.long	L3RL1A+FR7	;4
	.long	L3RL1A+FR6	;5
	.long	L3RL1A+FR5	;6
	.long	L3RL1A+FR4	;7
	.long	L3RL1A+FR3	;8
	.long	L3RL1A+FR2	;9
	.long	L3RL1A+FR1	;10
	.long	0,0,0,0,0,0


	.ref	HIT_THE_MAT,SMALL_BOUNCE

;FIX!!  Make throw out of ring if close to ropes
#*****************************************************************************
*
* FLIP/FALL FROM HIPTOSS

 SUBR	lex_tossed_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

;	.word	ANI_XFLIP

	WL	ANI_CODE,ckzpos

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_GETUP,300
	WL	ANI_CODE,HIT_THE_MAT
	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,50000h
;	.word	ANI_OFFSET,0,0,0	;x,y,z
	WL	3,L3CP3X+FR2
	WL	3,L3CP3X+FR3
	WL	3,L3CP3X+FR4
	WL	3,L3CP3X+FR5

	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS

	WL	3,L3CP3X+FR6
	WL	3,L3CP3X+FR7
	WL	3,L3CP3X+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim

;FIX!!  Make throw out of ring if close to ropes
#*****************************************************************************
*
* FLIP/FALL FROM BAM BAM DUCK TOSS

 SUBR	lex_tossed2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,ckzpos

	WLW	ANI_SET_XVEL,60000h,AM_HIT_REL
	WL	ANI_SET_YVEL,30000h
	.word	ANI_OFFSET,20,20,0			;x,y,z
	WL	4,L3FH3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_GETUP,300
	.word	ANI_DAMAGE,D_HIPTOSS

	WL	4,L3FH3A+FR6
	.word	ANI_XFLIP
	.word	ANI_OFFSET,20,0,0			;x,y,z
	WL	3,L3CP3X+FR1

	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,50000h
	WL	3,L3CP3X+FR2
	WL	3,L3CP3X+FR3
	WL	3,L3CP3X+FR4
	WL	3,L3CP3X+FR5

	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	4,L3CP3X+FR6
	WL	4,L3CP3X+FR7
	WL	4,L3CP3X+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim
	.word	ANI_END


#*****************************************************************************
 SUBR	lex_climbthru_side_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_OFFSET,16,0,0
	WL	4,L4CR3B+FR1
	.word	ANI_BENDROPE,2
	.word	ANI_OFFSET,4,0,0	;*****
	WL	4,L4CR3B+FR2
	.word	ANI_OFFSET,4,0,0	;*****
	WL	4,L4CR3B+FR3		
	.word	ANI_OFFSET,4,0,0	;*****
	WL	4,L4CR3B+FR4

	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH

	.word	ANI_OFFSET,5,0,0	;*****
	WL	4,L4CR3B+FR5

	.word	ANI_OFFSET,4,0,0	;*****
	WL	4,L4CR3B+FR6
	.word	ANI_BENDROPE,2
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH
	.word	ANI_OFFSET,6,0,0	;*****
	WL	4,L4CR3B+FR7
	.word	ANI_OFFSET,4,0,0	;*****
	WL	4,L4CR3B+FR8
	.word	ANI_OFFSET,9,0,0	;*****
	WL	4,L4CR3B+FR9
	.word	ANI_BENDROPE,-1
	.word	ANI_OFFSET,7,0,0	;*****
	WL	4,L4CR3B+FR10
	.word	ANI_OFFSET,8,-3,0
	WL	4,L4CR3B+FR11

	;now jump off...
	WL	4,L4JD4A+FR1		;D4FM4A+FR1
	WL	4,L4JD4A+FR2

	WL	ANI_SET_YVEL,60000h

	WLW	ANI_SET_XVEL,30000h,AM_FACE_REL

	WL	3,L4JD4A+FR3
	.word	ANI_WAITHITGND

	.word	ANI_ROPE_Z,R_TOP,RZ_NORM
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM

	.word	ANI_ZEROVELS
	WL	3,L4JD4A+FR4
	WL	3,L4JD4A+FR6
	WL	3,L4JD4A+FR7
	WL	6,L4JD4A+FR8

	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	lex_climbin_side_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	ANI_CODE,SET_DIR_FACE
	.word	ANI_SETFACING
	.WORD	ANI_SET_WRESTLER_XFLIP

	;jump in
	WL	4,L4JD4A+FR1
	WL	4,L4JD4A+FR2

	WL	ANI_CODE,#set_trgt
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	.word	ANI_LEAPATPOS,1ch,200,0,0,0	;#ticks,dist,xoff,yoff,zoff

	WL	4,L4JD4A+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH

	WL	4,L4JD4A+FR4
	WL	4,L4JD4A+FR6
	WL	3,L4JD4A+FR7
	WL	3,L4JD4A+FR8
	WL	ANI_CODE,#set_z

	.word	ANI_OFFSET,10,0,0	;*****
	;climb through
	WL	3,L4CR3B+FR1
	.word	ANI_BENDROPE,0
	.word	ANI_OFFSET,4,0,0	;*****
	WL	3,L4CR3B+FR2
	.word	ANI_BENDROPE,2
	.word	ANI_OFFSET,4,0,0	;*****
	WL	3,L4CR3B+FR3
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM
	.word	ANI_OFFSET,4,0,0	;*****
	WL	3,L4CR3B+FR4

	.word	ANI_OFFSET,6,0,0	;*****
	WL	3,L4CR3B+FR5

	.word	ANI_OFFSET,6,0,0	;*****
	WL	3,L4CR3B+FR6
	.word	ANI_OFFSET,6,0,0	;*****
	WL	3,L4CR3B+FR7
	.word	ANI_OFFSET,6,0,0	;*****
	WL	3,L4CR3B+FR8
	.word	ANI_BENDROPE,3
	.word	ANI_OFFSET,6,0,0	;*****
	WL	3,L4CR3B+FR9
	.word	ANI_OFFSET,5,0,0	;*****
	WL	3,L4CR3B+FR10
	.word	ANI_BENDROPE,-1
	.word	ANI_OFFSET,5,-3,0
	WL	3,L4CR3B+FR11

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

 SUBR	lex_climbthru_bot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

;Must rotate toward ropes!
;Do a different sequence

	;lie down
	WL	ANI_CODE,#ckspin
	WL	ANI_IFSTATUS,#dir4

;Facing #2, spin first!
	WL	3,L1TT5A+FR2
	WL	3,L1TT5A+FR4
#dir4
	WL	3,L3GU4A+FR10
	WL	3,L3GU4A+FR9
	WL	3,L3GU4A+FR8
	WL	3,L3GU4A+FR7
	WL	3,L3GU4A+FR6
	WL	3,L3GU4A+FR5
	WL	3,L3GU4A+FR4
	WL	3,L3GU4A+FR2
	WL	3,L3GU4A+FR1

	;roll over once
	WLW	ANI_SET_ZVEL,90000h,AM_ABS

	WL	3,L3RL1A+FR11
	WL	3,L3RL1A+FR10
	WL	3,L3RL1A+FR9
	WL	3,L3RL1A+FR8
	WL	3,L3RL1A+FR7
	WL	3,L3RL1A+FR6
	WL	3,L3RL1A+FR5
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP+MODE_NOSHADOW

	;climb through

	WL	ANI_CODE,NOT_IN_RING
	.word	ANI_OFFSET,0,-37h,0			;x,y,z
	WL	3,L2PJ3C+FR5
	WL	3,L2PJ3C+FR3
	WL	3,L2PJ3C+FR2

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
#faceup
	rets

NOT_IN_RING
	MOVK	1,A0
	MOVE	A0,*A13(INRING)
	RETS

#*****************************************************************************

 SUBR	lex_climbin_bot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;climb in
	.word	ANI_GRAVITY_OFF
	WL	3,L2PJ3C+FR2
	WL	3,L2PJ3C+FR3
	WL	3,L2PJ3C+FR5
	.word	ANI_OFFSET,0,37h,-60

	;roll
	WLW	ANI_SET_ZVEL,-70000h,AM_ABS
	.word	ANI_FRICTION,3000h
	WL	3,L3RL1A+FR6
	WL	3,L3RL1A+FR7
	WL	3,L3RL1A+FR8
	WL	3,L3RL1A+FR9
	WL	3,L3RL1A+FR10
	WL	3,L3RL1A+FR11
	.word	ANI_ZEROVELS
	.word	ANI_GRAVITY_ON

	;get up
	WL	3,L3GU4A+FR1
	WL	3,L3GU4A+FR2
	WL	3,L3GU4A+FR3
	WL	3,L3GU4A+FR4
	WL	3,L3GU4A+FR5
	WL	3,L3GU4A+FR6
	WL	3,L3GU4A+FR7
	WL	3,L3GU4A+FR8
	WL	3,L3GU4A+FR9
	WL	3,L3GU4A+FR10

	WL	ANI_CODE,clr_climb

	.word	ANI_FACEDOWN
	.word	ANI_ZEROVELS
	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	lex_climbthru_top_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;lie down
	WL	ANI_CODE,#set_zvel1
	WL	ANI_IFSTATUS,#dir4
;Facing #2
	WL	3,L1TT5A+FR2
	WL	3,L1TT5A+FR4
	
#dir4
	WL	3,L3GU4A+FR10
	WL	3,L3GU4A+FR9
	WL	3,L3GU4A+FR8
	WL	3,L3GU4A+FR7
	WL	3,L3GU4A+FR6
	WL	3,L3GU4A+FR5
	WL	3,L3GU4A+FR4
	WL	3,L3GU4A+FR3
	WL	3,L3GU4A+FR2
	WL	3,L3GU4A+FR1

	;roll over once
	WL	ANI_CODE,#set_zvel2
	WL	3,L3RL1A+FR11
#cont
	WL	3,L3RL1A+FR1
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP+MODE_NOSHADOW
	WL	3,L3RL1A+FR2
	WL	3,L3RL1A+FR3
	WL	3,L3RL1A+FR4

	;climb through
	.word	ANI_OFFSET,0,-61,0
	.word	ANI_ZEROVELS
	WL	3,L3DC3B+FR3
	WL	3,L3DC3B+FR2
	WL	3,L3DC3B+FR1

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

 SUBR	lex_climbin_top_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOCONFINE+MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;climb in
	WL	3,L3DC3B+FR1
	WL	3,L3DC3B+FR2
	WL	3,L3DC3B+FR3
	.word	ANI_OFFSET,0,61,0

	;roll over
	WL	ANI_CODE,#set_zvel2
	WL	3,L3RL1A+FR3
	WL	3,L3RL1A+FR2
	WL	3,L3RL1A+FR1
	WL	3,L3RL1A+FR11	

	.word	ANI_ZEROVELS

	;get up
	WL	3,L3GU4A+FR1
	WL	3,L3GU4A+FR2
	WL	3,L3GU4A+FR3
	WL	3,L3GU4A+FR4
	WL	3,L3GU4A+FR5
	WL	3,L3GU4A+FR6
	WL	3,L3GU4A+FR7
	WL	3,L3GU4A+FR8
	WL	3,L3GU4A+FR9
	WL	3,L3GU4A+FR10

	WL	ANI_CODE,clr_climb

	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END

#set_zvel2
	movi	52000h,a0
	move	a0,*a13(OBJ_ZVEL),L
	rets

#*****************************************************************************
*

 SUBR	lex_knockdwn_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h
	.word	ANI_XFLIP
 

	WL	2,L3GU4A+FR10
	WL	2,L3GU4A+FR7
	WL	2,L3GU4A+FR5
	WL	ANI_SET_YVEL,39000h

	WL	3,L3CP3X+FR2
	WL	3,L3CP3X+FR3
	WL	3,L3CP3X+FR4
	WL	3,L3CP3X+FR5
	WL	3,L3CP3X+FR6
	WL	3,L3CP3X+FR7
	WL	3,L3CP3X+FR1

;MJT Start
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	.word	ANI_SETPLYRMODE,MODE_DEAD
	.word	ANI_END

#nodead
;MJT End

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim

;MJT Start 2
#****************************************************************************
*
* PIN OPPONENT AND RAISE ARM IN VICTORY

;Need to have this guy walk toward fallen opponent so he
;can get closer!

;This pin must be started only when opponent is on the ground!

 SUBR	lex_2_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;Rotate!
	WL	2,L1TT5A+FR4
	WL	2,L1TT5A+FR5
	WL	2,L1TT5A+FR6
	WL	ANI_GOTO,#cont

 SUBR	lex_4_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

#cont
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 25,999,80h,50h,90000h,TGT_CHEST,0,57,-15

	WL	3,L3PN5B+FR2
	.word	ANI_OFFSET,0,20,0			;x,y,z
	WL	19,L3PN5B+FR5
	.word	ANI_ATTACK_ON_Z, AMODE_STOMP,-40,-8,0,76,20,30 ;mode,x,y,z,w,h,d
	.word	ANI_ZEROVELS

	WL	3,L3PN5B+FR9
	WL	3,L3PN5B+FR8

	WL	ANI_CODE,DO_CROWD_CHEER

	.word	ANI_ATTACK_OFF
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_BOUNCE,2
;	WLW	ANI_ATTCHIMAGE,D4PN5L+FR5,10		;image, zoff (priority)
	WL	3,L3PN5B+FR8
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE

	.word	ANI_OFFSET,0,0,20			;x,y,z

	WL	3,L3PN5B+FR9
	.ref	win_announce
	WL	ANI_CODE,win_announce
;	WLW	ANI_ATTCHIMAGE,0,0		;Turn it off
	WL	40,L3PN5B+FR10

;MJT Start
	.word	ANI_LOOP
;MJT End

;Do another ground hit on opponent
	.ref	grnd_hit
	WL	ANI_CODE,grnd_hit

	WL	ANI_SET_YVEL,42000h
	WLW	ANI_SET_ZVEL,22000h,AM_ABS
	WL	4,L3PN5D+FR1
	WL	4,L3PN5D+FR2
	WL	4,L3PN5D+FR3
	WL	4,L3PN5D+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	4,L3PN5D+FR5
	WL	4,L3PN5D+FR6

	WL	5,L4FX5B+FR1
	WL	5,L4FX5B+FR2
	WL	5,L4FX5B+FR3
	WL	5,L4FX5B+FR4
	WL	5,L4FX5B+FR5
	WL	5,L4FX5B+FR6
	WL	5,L4FX5B+FR7
	WL	5,L4FX5B+FR8
	WL	5,L4FX5B+FR9
	WL	5,L4FX5B+FR10
	WL	5,L4FX5B+FR11

	WL	5,L4FX5B+FR10
	WL	5,L4FX5B+FR9
	WL	5,L4FX5B+FR8


	WL	5,L4FX5B+FR7
	WL	5,L4FX5B+FR6
	WL	5,L4FX5B+FR5
	WL	5,L4FX5B+FR4
	WL	5,L4FX5B+FR5
	WL	5,L4FX5B+FR6
	WL	5,L4FX5B+FR7
	WL	5,L4FX5B+FR8
	WL	5,L4FX5B+FR9
	WL	5,L4FX5B+FR10
	WL	5,L4FX5B+FR11

;MJT Start
#lp	WL	4,L4FX5B+FR10
	WL	4,L4FX5B+FR9
	WL	4,L4FX5B+FR8
	WL	4,L4FX5B+FR9
	WL	4,L4FX5B+FR10
	WL	4,L4FX5B+FR11
	WL	ANI_GOTO,#lp

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************
;MJT End 2
	.end

