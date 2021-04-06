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
	.ref	start_run_flung,ckzpos,choose_2or4
	.ref	no_bk_xvel,win_announce,grnd_hit,SET_DIR_FACE
	.ref	DO_CROWD_CHEER,check_xvel,tgt_ground,set_tbukl_confine
	.ref	free_toss_check,setup_freetoss
	.ref	hit_nearest,set_tbukl_airmode,shn_2_hiptoss_anim
	.ref	check_raisearm_bit
	.ref	shn_combo_sliding_kicktoss_anim,DO_COMBO_MESS
	.ref	shn_combo_spinkick_anim,shn_4combo_bslam_anim
	.ref	CALL_ANI_AVERAGE_MOVE
	.REF	MOVE_NAME_ANNC

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* #2 NORMAL PUNCH

 SUBR	shn_2_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP


	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S2PU3C+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S2PU3C+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S2PU3C+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_PUNCH,3
	WL	1,S2PU3C+FR2
	.word	ANI_ATTACK_ON, AMODE_PUNCH,52,91,28,8
	WL	3,S2PU3C+FR3
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit
	WL	ANI_SET_YVEL,30000h
	WL	3,S2PU3C+FR3
#no_hit
	WL	1,S2PU3C+FR3

	;one more tick if blocked, three more if hit, none if missed.
	.word	ANI_HMBWAIT,3,0,1

	WL	2,S2PU3C+FR4
	WL	2,S2PU3C+FR5
	WL	2,S2PU3C+FR7
	WL	2,S2PU3C+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 NORMAL PUNCH

 SUBR	shn_4_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S4PU3D+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S4PU3D+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S4PU3D+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_PUNCH,3
	WL	1,S4PU3D+FR3
	.word	ANI_ATTACK_ON, AMODE_PUNCH,49,85,26,10
	WL	3,S4PU3D+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit

	WL	ANI_SET_YVEL,30000h
	WL	3,S4PU3D+FR4
	
#no_hit
	WL	1,S4PU3D+FR4

	.word	ANI_HMBWAIT,3,0,1

	WL	2,S4PU3D+FR5
	WL	2,S4PU3D+FR6
	WL	2,S4PU3D+FR7
	WL	2,S4PU3D+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

*************
*
* COMBO PUNCH

 SUBR	shn_combo_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.WORD	ANI_CLEAR_COMBO

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_LEAPING,15
	.word	ANI_SET_RPTCOUNT,3	;rpt 2 times

	WLW	ANI_SET_XVEL,50000h,AM_FACE_REL
	
	WL	2,S4PU3D+FR2
	.word	ANI_INC_COMBO
#rpt
	.word	ANI_CLR_BUTCOUNT
	.word	ANI_ATTACK_ON, AMODE_PUNCH2,21,40,62,34	;mode,x,y,w,h
	WL	1,S4MK3A+FR1
	WLW	ANI_SET_XVEL,0000h,AM_FACE_REL
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missedc
	.word	ANI_INC_COMBO
	WLLL	ANI_SETOPPVELS,0,8000h,0h		;x,y,z vels
	WL	1,S4MK3A+FR1
	WL	2,S4MK3A+FR2
	WL	2,S4MK3A+FR3
	.word	ANI_ATTACK_ON, AMODE_PUNCH2,21,40,62,34	;mode,x,y,w,h
	WL	1,S4MK3A+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missedc
	.word	ANI_INC_COMBO
	WLLL	ANI_SETOPPVELS,0,8000h,0h		;x,y,z vels
	WL	1,S4MK3A+FR4
	WL	2,S4MK3A+FR5

	WL	ANI_IFNOTSTATUS,#missedc
	WL	ANI_IFBLOCKED,#missedbc		;Yes, I hit blocker

	WL	2,S4MK3A+FR7

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#rpt


	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#NO_FLYING
	WL	ANI_CHANGEANIM,shn_combo_flying_kick_anim

#NO_FLYING
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#NO_SPIN
	WL	ANI_CHANGEANIM,shn_combo_knee_anim

#NO_SPIN
	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#EXIT_PUNCH
	WL	ANI_CHANGEANIM,shn_combo_spinkick_anim

#EXIT_PUNCH

	.word	ANI_DETACH
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedc
	WL	3,S4MK3A+FR6
	WL	3,S4MK3A+FR6
#missedbc
	WL	3,S4MK3A+FR7

	.word	ANI_DETACH
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	3,S4MK3A+FR7

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 PUSH

 SUBR	shn_4_push_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WL	ANI_SETFLAG,M_PUSH
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUSH,9
	WL	3,S4PS3A+FR1
	WL	3,S4PS3A+FR2
	WL	3,S4PS3A+FR3
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ATTACK_ON, AMODE_PUSH,33,85,44,17 ;mode,x,y,w,h
	WL	3,S4PS3A+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,40h,-70000h,#no_hit	;range,vel,addr
	WL	15,S4PS3A+FR4
#no_hit
	WL	3,S4PS3A+FR4

	WL	ANI_IFSTATUS,#hit
;If missed on push, hold a little longer
	WL	5,S4PS3A+FR4
#hit
	WL	4,S4PS3A+FR2
	WL	4,S4PS3A+FR1

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 HEADBUTT

 SUBR	shn_2_butt_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP


	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S2BC3B+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S2BC3B+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S2BC3B+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_HDBUTT,6
	WL	3,S2BC3B+FR4
	WL	3,S2BC3B+FR5
	.word	ANI_ATTACK_ON, AMODE_HDBUTT,40,81,10,12	;mode,x,y,w,h
	WL	3,S2BC3B+FR6
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit

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

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S4BC3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S4BC3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S4BC3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_HDBUTT,6
	WL	3,S4BC3A+FR4
	WL	3,S4BC3A+FR5
	.word	ANI_ATTACK_ON, AMODE_HDBUTT,32,91,12,15	;mode,x,y,w,h
	WL	3,S4BC3A+FR6
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit

	WL	ANI_SET_YVEL,38000h
	WL	6,S4BC3A+FR6
#no_hit

	.word	ANI_HMBWAIT,3,0,1
	WL	3,S4BC3A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* COMBO HEADBUTT

 SUBR	shn_combo_butt_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SET_RPTCOUNT,4	;5 times
	WLW	ANI_SET_XVEL,28000h,AM_FACE_REL
#butt_loop
	.word	ANI_CLR_BUTCOUNT
	WL	2,S4BC3A+FR2
	.word	ANI_STARTATTACK,AT_HDBUTT,6
	WL	2,S4BC3A+FR4
	WL	2,S4BC3A+FR5

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,32,71,42,35	;mode,x,y,w,h
	WL	1,S4BC3A+FR6
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#no_hit_c
	.word	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,18000h,0h		;x,y,z vels

	WL	ANI_SET_YVEL,18000h
	WL	2,S4BC3A+FR6
	WLW	ANI_SET_XVEL,09000h,AM_FACE_REL
	WL	3,S4BC3A+FR6
	WL	2,S4BC3A+FR8
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#butt_loop
	.word	ANI_DETACH

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#NO_BODYSLAM
	WL	ANI_CHANGEANIM,shn_4combo_bslam_anim

#NO_BODYSLAM
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#NO_SLIDING
	WL	ANI_CHANGEANIM,shn_combo_flying_kick_anim

#NO_SLIDING
	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#MISSED_IT
	WL	ANI_CHANGEANIM,shn_combo_sliding_kicktoss_anim

#MISSED_IT
	.word	ANI_DETACH
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END
#no_hit_c

	.word	ANI_DETACH
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	3,S4BC3A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 KICK

 SUBR	shn_2_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S2KM3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S2KM3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S2KM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_KICK,5
	WL	1,S2KM3A+FR2
	WL	2,S2KM3A+FR3
	WL	1,S2KM3A+FR4

	WL	ANI_SET_YVEL,20000h

	.word	ANI_ATTACK_ON, AMODE_KICK,27,59,68,20	;mode,x,y,w,h
	WL	3,S2KM3A+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_slide
	WL	ANI_SET_YVEL,30000h
#no_slide
	.word	ANI_HMBWAIT,4,0,2

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	2,S2KM3A+FR5
	WL	3,S2KM3A+FR6
	WL	2,S2KM3A+FR7
	WL	3,S2KM3A+FR8
	WL	2,S2KM3A+FR9
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 KICK

 SUBR	shn_4_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S4KM3C+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S4KM3C+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S4KM3C+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_KICK,4
	WL	1,S4KM3C+FR3
	WL	2,S4KM3C+FR4
	WL	ANI_SET_YVEL,20000h
	.word	ANI_ATTACK_ON, AMODE_KICK,27,59,68,20	;mode,x,y,w,h
	WL	3,S4KM3C+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_slide
	WL	ANI_SET_YVEL,30000h
#no_slide
	.word	ANI_HMBWAIT,4,0,2

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,S4KM3C+FR6
	WL	3,S4KM3C+FR7
	WL	2,S4KM3C+FR8
	WL	3,S4KM3C+FR9
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 Jump kick

 SUBR	shn_4_jump_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_LEAPING,12
	WL	3,S4KI3I+FR1
	WL	3,S4KI3I+FR2
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 10,999,95,50,90000h,TGT_HEAD,70,100,10
	WL	4,S4KI3I+FR3
	WL	3,S4KI3I+FR4
	WL	3,S4KI3I+FR5
	.word	ANI_ATTACK_ON, AMODE_FLYKICK,20,69,46,53	;mode,x,y,w,h
	WL	3,S4KI3I+FR6
	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_slide
	WL	ANI_SET_YVEL,30000h
#no_slide

	WL	ANI_IFNOTSTATUS,#missed
	.WORD	ANI_ADD_MOVE,MOVE_C_2,2,2
	WL	ANI_IFBLOCKED,#missedb

	.word	ANI_SHAKER,35

	WL	3,S4KI3I+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_IFBLOCKED,#missedb
	WL	ANI_IFNOTSTATUS,#missed
	.word	ANI_DRAW_NAME,17
	WL	ANI_GOTO,#hit

#missedb
;	WL	3,S4KI3I+FR7
	;fall through
#missed
	WL	3,S4KI3I+FR7
	;fall through
#hit
	WL	3,S4KI3I+FR8
	WL	3,S4KI3I+FR9
	.word	ANI_OFFSET,-10,3,0
	WL	3,S4KM3C+FR8
	WL	3,S4KM3C+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

**************
*
* COMBO KICK

 SUBR	shn_combo_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.WORD	ANI_CLEAR_COMBO

	WL	4,S4KM3C+FR2
	.word	ANI_STARTATTACK,AT_KICK,4
	WL	3,S4KM3C+FR3
	WL	3,S4KM3C+FR4
	WL	ANI_SET_YVEL,20000h
	.word	ANI_CLR_STATUS
	.WORD	ANI_INC_COMBO
	.word	ANI_ATTACK_ON, AMODE_KICK,27,59,68,20	;mode,x,y,w,h
	WL	3,S4KM3C+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed_c
	WLLL	ANI_SETOPPVELS,0,10000h,0h		;x,y,z vels
	.WORD	ANI_INC_COMBO
	WL	3,S4KM3C+FR5

	.word	ANI_SET_RPTCOUNT,3	;5 times
#kick_loop
	.word	ANI_CLR_BUTCOUNT

	WL	2,S4KM3C+FR2
	.word	ANI_STARTATTACK,AT_KICK,4
	WL	1,S4KM3C+FR3
	WL	2,S4KM3C+FR4
	WL	ANI_SET_YVEL,20000h
	.word	ANI_CLR_STATUS
	.word	ANI_ATTACK_ON, AMODE_KICK,27,59,68,20	;mode,x,y,w,h
	WL	1,S4KM3C+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed_c
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,10000h,0h		;x,y,z vels
	.WORD	ANI_INC_COMBO
	WL	2,S4KM3C+FR5
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#kick_loop

	WLW	ANI_SET_XVEL,18000h,AM_FACE_REL
	.word	ANI_CLR_BUTCOUNT

	WL	2,S4KM3C+FR2
	.word	ANI_STARTATTACK,AT_KICK,4
	WL	1,S4KM3C+FR3
	WL	2,S4KM3C+FR4
	WL	ANI_SET_YVEL,20000h
	.word	ANI_CLR_STATUS
	.word	ANI_ATTACK_ON, AMODE_KICK,27,59,68,20	;mode,x,y,w,h
	WL	1,S4KM3C+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed_c
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,10000h,0h		;x,y,z vels
	.WORD	ANI_INC_COMBO
	WL	2,S4KM3C+FR5

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#NO_SLAMS
	WL	ANI_CHANGEANIM,shn_4combo_bslam_anim

#NO_SLAMS
	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#NO_BUTTS
	WL	ANI_CHANGEANIM,shn_combo_flying_kick_anim

#NO_BUTTS
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#missed_c
	WL	ANI_CHANGEANIM,shn_combo_butt_anim

#missed_c

	.word	ANI_DETACH
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	4-1,S4KM3C+FR6
	WL	4-1,S4KM3C+FR7
	WL	4-1,S4KM3C+FR8
	WL	3,S4KM3C+FR9
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

;#************
;*
;* #3 BACKFLIP KICK
;
;;FIX!!!  MAKE THIS A COOL MOVE 1/12/95
;
; SUBR	shn_backflip_kick_anim
;
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_ZEROVELS
;	.word	ANI_SETSPEED,100h
;
;	.word	ANI_STARTATTACK,AT_KICK,12
;	WL	3,S3KF3B+FR1
;	WL	3,S3KF3B+FR2
;	WL	1,S3KF3B+FR3
;	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL
;	WL	ANI_SET_YVEL,5c000h
;	WL	2,S3KF3B+FR3
;	.word	ANI_OFFSET,-24,4,0
;	WL	3,S3KF3B+FR4
;	.word	ANI_ATTACK_ON,AMODE_SHNBFKIK,17,40,47,62
;	WL	3,S3KF3B+FR5
;	.word	ANI_ATTACK_OFF
;	WL	3,S3KF3B+FR6
;	WL	3,S3KF3B+FR7
;	WL	3,S3KF3B+FR8
;	WL	3,S3KF3B+FR9
;	WL	3,S3KF3B+FR10
;	.word	ANI_WAITHITGND
;	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2
;	.word	ANI_ZEROVELS
;	WL	3,S3KF3B+FR11
;	WL	3,S3KF3B+FR12
;	.word	ANI_FACEDOWN
;
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END

#*****************************************************************************
*
* #2 STOMP ON FALLEN OPPONENT

 SUBR	shn_2_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S2MP2A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S2MP2A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S2MP2A+FR2
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
	LEAPATOPP 12,999,160,140,90000h,TGT_USER,28,0,-50
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

	.WORD	ANI_ADD_MOVE,MOVE_C_2,2,2
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

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S4MP4C+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S4MP4C+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S4MP4C+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	;if we're not going to hit, do a LEAPAT
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,0,0,-10,5,5,60
	WL	1,S4MP4C+FR3
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#no_leapat

	.word	ANI_TARGET,TGT_CHEST,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 12,999,112,96,90000h,TGT_USER,12,0,45
	LEAPATOPP 12,999,160,140,90000h,TGT_USER,12,0,45
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

	.WORD	ANI_ADD_MOVE,MOVE_C_2,2,2
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

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCONFINE|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING
	.word	ANI_SET_WRESTLER_XFLIP
	.word	ANI_SCROLL_CTRL,SC_RESTORE

	WL	4,S4MP4C+FR2

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 35,190,190,190,90000h,TGT_CHEST,30,6,40
	.word	ANI_STARTATTACK,AT_LEAPING,35
;	.word	ANI_SETPLYRMODE,MODE_INAIR2
	WL	ANI_CODE,set_tbukl_airmode
	.word	ANI_GRAVITY_ON
	.word	ANI_SHAKECORNER

	WL	ANI_CODE,check_xvel

	WL	4,S4MP4C+FR3

	;attack box dimensions depends on opp mode
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-26,0,-10,82,40,70
	WWL	ANI_IFOPPMODE,MODE_ONGROUND,#opp_onground
	WWL	ANI_IFOPPMODE,MODE_DEAD,#opp_onground
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-26,50,-10,82,40,70

#opp_onground
	WL	12,S4MP4C+FR4
	WL	ANI_CODE,set_tbukl_confine
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_OFF

	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,1
	WL	ANI_CODE,HIT_THE_MAT

	.WORD	ANI_ADD_MOVE,MOVE_C_2,2,2
	WL	ANI_IFSTATUS,#hit

	;missed
	WL	ANI_CODE,CALL_MISSES
;	WL	ANI_CODE,tbukl_miss_damage
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

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCONFINE|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING
	.word	ANI_SET_WRESTLER_XFLIP
	.word	ANI_SCROLL_CTRL,SC_RESTORE

	WL	3,S4PJ3E+FR4

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 31,190,190,190,90000h,TGT_CHEST,22,11+#yoff,50
	.word	ANI_STARTATTACK,AT_LEAPING,31
;	.word	ANI_SETPLYRMODE,MODE_INAIR2
	WL	ANI_CODE,set_tbukl_airmode
	.word	ANI_GRAVITY_ON
	.word	ANI_SHAKECORNER

;Check x vel to make sure we aren't going to land on ropes!
	WL	ANI_CODE,check_xvel

	.word	ANI_OFFSET,0,#yoff,0
	WL	3,S4PJ3E+FR5
	WL	3,S4PJ3E+FR6

	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-26,0,-10,82,40,70
	WWL	ANI_IFOPPMODE,MODE_ONGROUND,#opp_onground
	WWL	ANI_IFOPPMODE,MODE_DEAD,#opp_onground
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-26,40,-10,82,40,70

#opp_onground
	WL	6,S4PJ3E+FR7
	WL	ANI_CODE,set_tbukl_confine
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_OFF

	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,1
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.WORD	ANI_ADD_MOVE,MOVE_C_2,2,2
	WL	ANI_IFSTATUS,#hit

	;missed
	WL	ANI_CODE,CALL_MISSES
;	WL	ANI_CODE,tbukl_miss_damage
	WL	ANI_GOTO,#AVOID_HIT_CALL

#hit
	.word	ANI_DRAW_NAME,18
	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE
#AVOID_HIT_CALL
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

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S2PJ3D+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S2PJ3D+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S2PJ3D+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	WL	3,S2PJ3D+FR2
	WL	3,S2PJ3D+FR3
	.word	ANI_OFFSET,0,64,0
	WL	ANI_CODE,elbow_tgt2
	WL	ANI_CODE,tgt_ground
;	LEAPATOPP 20,999,112,96,90000h,TGT_USER,-10,0,-50
	LEAPATOPP 20,999,160,140,90000h,TGT_USER,-10,0,-50
	
	.word	ANI_STARTATTACK,AT_LBDROP,10
	WL	3,S2PJ3D+FR4
	WL	3,S2PJ3D+FR5
	
	.word	ANI_ATTACK_ON_Z,AMODE_LBOWDROP,-24,0,-40,26,56,50
	WL	1,S2PJ3D+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_OFF
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,25

	.WORD	ANI_ADD_MOVE,MOVE_C_2,2,2
	WL	ANI_IFSTATUS,#hit2

	;missed
	WL	ANI_CODE,SMALL_BOUNCE
	WL	ANI_CODE,CALL_MISSES
	WL	ANI_GOTO,#cont2

#hit2
	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE
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

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S4PJ3F+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S4PJ3F+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S4PJ3F+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	WL	3,S4PJ3F+FR2
	.word	ANI_OFFSET,0,71,0
	WL	ANI_CODE,#set_target
	WL	ANI_CODE,tgt_ground
;	LEAPATOPP 20,999,72,48h,90000h,TGT_USER,19,0,30
	LEAPATOPP 20,999,160,140,90000h,TGT_USER,19,0,30
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
	.word	ANI_SHAKER,25

	.WORD	ANI_ADD_MOVE,MOVE_C_2,2,2
	WL	ANI_IFSTATUS,#hit4

	;missed
	WL	ANI_CODE,SMALL_BOUNCE
	WL	ANI_CODE,CALL_MISSES
	WL	ANI_GOTO,#cont4

#hit4
	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE
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

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP


	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S2NM3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S2NM3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S2NM3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_KNEE,6
	WL	3,S2NM3A+FR2

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 21,999,32,20,90000h,TGT_CHEST,50,80,0
	WL	3,S2NM3A+FR3

	.word	ANI_ATTACK_ON,AMODE_KNEE,36,28,38,49	;mode,x,y,w,h
	WL	3,S2NM3A+FR4
	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_2,2,2
	WWL	ANI_SLIDE_BACK,28h,-70000h,#no_hit

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

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S4NM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S4NM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,S4NM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_KNEE,6
	WL	3,S4NM3A+FR3

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 21,999,32,20,90000h,TGT_CHEST,45,80,0

	.word	ANI_ATTACK_ON,AMODE_KNEE,11,22,58,60	;mode,x,y,w,h
	WL	3,S4NM3A+FR4
	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_2,2,2
	WWL	ANI_SLIDE_BACK,28h,-70000h,#no_hit

#no_hit
	WL	13,S4NM3A+FR4
	WL	3,S4NM3A+FR5
	WL	3,S4NM3A+FR6
	WL	3,S4NM3A+FR7
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


 SUBR	shn_combo_knee_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,S4NM3A+FR2
	WL	3,S4NM3A+FR3

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 21,999,32,20,90000h,TGT_CHEST,45,78,0

	.word	ANI_ATTACK_ON,AMODE_BIGKNEE,11,22,58,60	;mode,x,y,w,h
	WL	3,S4NM3A+FR4
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,28h,-70000h,#no_hit_c
	.WORD	ANI_INC_COMBO

#no_hit_c
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
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

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,10
	WL	2,S1TT5Z+FR2
	WL	2,S1TT5Z+FR3
	WL	ANI_GOTO,#cont

 SUBR	shn_4_grabfling_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	.word	ANI_STARTATTACK,AT_PUPPET,8

#cont
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,50,20,40,90000h,TGT_CHEST,40,0,25
	WL	ANI_SET_YVEL,0000h
	WL	5,S4GF3B+FR1

	.word	ANI_ATTACK_ON, AMODE_PUPPET_NOFLAIL,33,56,44,18 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,6,S4GF3B+FR2
	.word	ANI_ZERO_XZVELS
	WWL	ANI_WAITHITOPP,2,S4GF3B+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missedb
	WL	ANI_IFBLOCKED,#missedb

;got him
	.WORD	ANI_ADD_MOVE,MOVE_C_2,2,2
	WL	ANI_CODE,DO_GRUNT
	.ref	CALL_SETUP
	WL	ANI_CODE,CALL_SETUP
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
	WL	6,S4GF3B+FR8
	WL	4,S4GF3B+FR10
	.word	ANI_OFFSET,-4,0,0			;x,y,z

	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#missedb
	.ref	fling_delay
	WL	ANI_CODE,fling_delay
	WL	ANI_IFNOTSTATUS,#missed
	WL	25,S4GF3B+FR3

#missed
	WL	ANI_CODE,CALL_MISSES
	WL	6,S4GF3B+FR3
	WL	3,S4GF3B+FR2
	WL	3,S4GF3B+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


 SUBR	DO_GRUNT
	WRSNDX	GRABFLING_T1,GRABFLING_T2
	RETS

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
	.word	ANI_SCROLL_CTRL,SHN_TBUKLY
	WL	3,S2CT2A+FR4
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
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOGRAVITY
	.word	ANI_SCROLL_CTRL,SC_RESTORE
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
	.word	ANI_SCROLL_CTRL,SC_RESTORE

	WL	ANI_CODE,face_inside

	.word	ANI_SHAKECORNER
	WL	3,S4MP4D+FR1
	.word	ANI_OFFSET,0,15,0
	WL	3,S4MP4D+FR2

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


******************************************************************************
* Check to see if opponent is getting in/out of ring, and turn accordingly!
*
* Rules: If your opponent is inside, always face inside.  If he's outside,
*	face in 4 or 6, depending on opp position.

 SUBR	tbukl_flip

	calla	get_opp_process		;closest opponent process
	move	*a0(INRING),a0		;0 = in ring, 1 = outside
	jruc	#cont

**********
* Always face inside

 SUBR	face_inside
	clr	a0

#cont	move	*a13(OBJ_XPOSINT),a14
	cmpi	RING_X_CENTER,a14
	jrge	#onrt

#onlft	;On left turnbuckle
	move	a0,a0
	jrz	#no
	jruc	#out

#onrt	;On right turnbuckle
	move	a0,a0
	jrz	#yes

#out	;opponent is outside
	move	*a13(NEW_FACING_DIR),a14
	btst	MOVE_LEFT_BIT,a14
	jrnz	#yes
	;fall	#no

#no	;doink is the opposite...
	move	*a13(WRESTLERNUM),a14
	cmpi	W_DOINK,a14
	jreq	#yfx

	;so is yoko.
	cmpi	W_YOKO,a14
	jreq	#yfx

#nfx	move	*a13(OBJ_CONTROL),a14
	andni	M_FLIPH,a14
	move	a14,*a13(OBJ_CONTROL)
	rets

#yes	;doink is the opposite...
	move	*a13(WRESTLERNUM),a14
	cmpi	W_DOINK,a14
	jreq	#nfx
	
	;so is yoko.
	cmpi	W_YOKO,a14
	jreq	#nfx

#yfx	move	*a13(OBJ_CONTROL),a14
	ori	M_FLIPH,a14
	move	a14,*a13(OBJ_CONTROL)
	rets

#*****************************************************************************
*
* #3 FLYING KICK (combo version)

 SUBR	shn_combo_flying_kick_anim
	.word	ANI_ZERO_XZVELS
	WL	ANI_SET_YVEL,44000h
	WL	2,S3DC3A+FR4
	.word	ANI_OFFSET,0,47h,0
	WL	3,S3DC3A+FR5
	WL	7,S3DC3A+FR6

	.word	ANI_CLR_STATUS

	.word	ANI_ATTACK_ON, AMODE_FLYKICK,23,-42,59,60
	WL	3,S3DC3A+FR7
	.word	ANI_ATTACK_OFF

	.WORD	ANI_INC_COMBO
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO

	WL	3,S3DC3A+FR8
	WL	3,S3DC3A+FR9
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKER,20
	WL	5,S3DC3A+FR10
	.word	ANI_XFLIP

	;and now get up

;Getting up, set no_collis
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS|MODE_NOAUTOFLIP	;uninterruptable

	WL	ANI_CODE,choose_2or4
	WL	ANI_IFSTATUS,getup_in_4
	WL	ANI_GOTO,getup_in_2


#*****************************************************************************
*
* #3 FLYING KICK

 SUBR	shn_flying_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	3,S3DC3A+FR3
 
	;first, if we're holding his head, let him go.
	WWL	ANI_IFOPPMODE,~MODE_HEADHELD,#no_hdrel2
	.word	ANI_DETACH
#no_hdrel2

	.word	ANI_STARTATTACK,AT_LEAPING,19
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 18,999,160,65,90000h,TGT_HEAD,30,100,0
	WL	ANI_CODE,no_bk_xvel

	WL	2,S3DC3A+FR4
	.word	ANI_OFFSET,0,47h,0
	WL	3,S3DC3A+FR5
	WL	6,S3DC3A+FR6

	.word	ANI_ATTACK_ON, AMODE_FLYKICK,23,-22,49,40
	WL	5,S3DC3A+FR7
	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_1,2,2

	WL	3,S3DC3A+FR8
	WL	3,S3DC3A+FR9
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKER,20
	WL	5,S3DC3A+FR10
	.word	ANI_XFLIP

	;and now get up

;Getting up, set no_collis
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS|MODE_NOAUTOFLIP	;uninterruptable

	WL	ANI_CODE,choose_2or4
	WL	ANI_IFSTATUS,getup_in_4

getup_in_2
	WL	3,S3RL3A+FR6
	WL	3,S3RL3A+FR7
	WL	3,S3RL3A+FR8

	WL	3,S3GU2A+FR2
	WL	3,S3GU2A+FR3
	WL	3,S3GU2A+FR4
	WL	3,S3GU2A+FR5
	WL	3,S3GU2A+FR6
	WL	3,S3GU2A+FR7

	WL	2,S3GU2A+FR8
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,S3GU2A+FR8
	WL	4,S3GU2A+FR9

	.word	ANI_SAFE_TIME,20
 
	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,33,85,44,17
	WL	1,S3GU2A+FR9
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,shn_4_push_anim
#no_freetoss

	.word	ANI_FACEUP
 	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


getup_in_4
	WL	3,S3RL3A+FR4
	WL	3,S3RL3A+FR3
	WL	3,S3RL3A+FR2

	WL	3,S3GU4A+FR2
	WL	3,S3GU4A+FR3
	WL	3,S3GU4A+FR4
	WL	3,S3GU4A+FR5
	WL	3,S3GU4A+FR6
	WL	3,S3GU4A+FR7

	WL	2,S3GU4A+FR8
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,S3GU4A+FR8
	WL	4,S3GU4A+FR9

	.word	ANI_SAFE_TIME,20

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss2
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,33,85,44,17
	WL	1,S3GU4A+FR9
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss2

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,shn_4_push_anim
#no_freetoss2

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

	.word	ANI_GETUP,STAY_TIME
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
;	.word	ANI_END

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
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_GETUP,STAY_TIME
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
;	.word	ANI_END

#*****************************************************************************
*

 SUBR	shn_knockdwn_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h
	.word	ANI_XFLIP
 

	WL	2,S3GU4A+FR9
	WL	2,S3GU4A+FR6
	WL	2,S3GU4A+FR4
	WL	ANI_SET_YVEL,39000h

	WL	3,S3CP3B+FR2
	.word	ANI_DEBRIS,100,1,0,8,0		;%chance, tbl index, x,y,z off
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

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE | MODE_NOGRAVITY|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	ANI_CODE,SET_DIR_FACE
	.word	ANI_SETFACING
	.WORD	ANI_SET_WRESTLER_XFLIP

	WL	3,S3CR3A+FR1
	.word	ANI_OFFSET,0,10,0	;*****
	WL	3,S3CR3A+FR2
	.word	ANI_OFFSET,5,16,0	;*****
	WL	3,S3CR3A+FR3
	.word	ANI_OFFSET,5,16,0	;*****

	.word	ANI_SET_IDIOT
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOCOLLIS 
	;now jump off...
	WL	ANI_SET_YVEL,40000h
	WWL	ANI_SETLONG,OBJ_GRAVITY,0E000h

	WLW	ANI_SET_XVEL,54000h,AM_FACE_REL
	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH

	.word	ANI_BENDROPE,2
	.word	ANI_BENDROPE,-1

	WL	3,S3CR3A+FR4
	.word	ANI_WAITHITGND
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

	.word	ANI_ROPE_Z,R_TOP,RZ_NORM
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM

;	.WORD	ANI_XFLIP
	.word	ANI_ZEROVELS

	.word	ANI_OFFSET,5,0,0	;*****
	
	WL	3,S4MP4D+FR6
	WL	3,S4MP4D+FR8

;	WL	3,S2CT2A+FR8
;	.WORD	ANI_XFLIP

;	WL	3,S2CT2A+FR9
;	WL	3,S2CT2A+FR10
;	WL	3,S2CT2A+FR11
;	WL	3,S2CT2A+FR12

	.word	ANI_FACEDOWN

	.word	ANI_CLEAR_CLIMB
	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	shn_climbin_side_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	ANI_CODE,SET_DIR_FACE
	.word	ANI_SETFACING
	.WORD	ANI_SET_WRESTLER_XFLIP

	;jump in
	WL	1,S4MP4D+FR1

	WWL	ANI_SETLONG,OBJ_GRAVITY,0E000h
	WL	ANI_CODE,#set_trgt
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	.word	ANI_LEAPATPOS,14h,200,0,0,0	;#ticks,dist,xoff,yoff,zoff
	WL	20,S4MP4D+FR1
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY
;	WL	2,S4MP4D+FR2
;	WL	2,S4MP4D+FR3
;	WL	2,S4MP4D+FR4
;	WL	2,S4MP4D+FR5

	WL	3,S4MP4D+FR6
;	WL	2,S4MP4D+FR7
	WL	3,S4MP4D+FR8

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE | MODE_NOGRAVITY|MODE_NOCOLLIS
	WL	2,S3CR3A+FR1
	.word	ANI_OFFSET,0,10,0	;*****
	WL	2,S3CR3A+FR2
	.word	ANI_OFFSET,5,16,0	;*****
	WL	2,S3CR3A+FR3
	.word	ANI_OFFSET,5,16,0	;*****
	WL	2,S3CR3A+FR4

	.word	ANI_BENDROPE,2
	.word	ANI_BENDROPE,-1

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOCOLLIS 
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

;	WL	ANI_CODE,clr_climb
	.word	ANI_CLEAR_CLIMB

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


#*****************************************************************************

 SUBR	shn_climbthru_bot_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
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
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOSHADOW|MODE_NOCOLLIS

	.word	ANI_SET_IDIOT
	;climb through
	.WORD	ANI_XFLIP
	WL	ANI_CODE,NOT_IN_RING
	.word	ANI_OFFSET,20,-37h,0			;x,y,z
	WL	3,S4KI3Q+FR5
	WL	3,S4KI3Q+FR4
	WL	3,S4KI3Q+FR3
	.WORD	ANI_XFLIP

	.word	ANI_FACEUP
	.word	ANI_CLEAR_CLIMB
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

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
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
	.word	ANI_XFLIP
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

;	WL	ANI_CODE,clr_climb
	.word	ANI_CLEAR_CLIMB

	.WORD	ANI_FACEDOWN
	.word	ANI_ZEROVELS
	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	shn_climbthru_top_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
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
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOSHADOW|MODE_NOCOLLIS
	WL	3,S3RL3A+FR8
	WL	3,S3RL3A+FR7
	WL	3,S3RL3A+FR6

	.word	ANI_SET_IDIOT
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
	.word	ANI_CLEAR_CLIMB
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
;Zombies use this to roll through the top without standing back up.

 SUBR	shn_rollthru_top_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOSHADOW|MODE_NOCOLLIS

	;roll over once
	WLW	ANI_SET_ZVEL,-50000h,AM_ABS
	WL	3,S3RL3A+FR10
	WL	3,S3RL3A+FR9

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOSHADOW|MODE_NOCOLLIS
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

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************

 SUBR	shn_climbin_top_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
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

;	WL	ANI_CODE,clr_climb
	.word	ANI_CLEAR_CLIMB

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

 SUBR	shn_4_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 25,999,80h,50h,90000h,TGT_CHEST|TGT_GROUND,0,57,-15
	WL	ANI_CODE,hit_nearest

	WL	3,S3PN5C+FR1
	.word	ANI_OFFSET,0,31,0			;x,y,z
	WL	18,S3PN5C+FR2
	WL	4,S3PN5C+FR3
;	.word	ANI_WAITHITGND
;	.word	ANI_ATTACK_ON_Z, AMODE_STOMP,-40,-8,0,76,20,30 ;mode,x,y,z,w,h,d
	.word	ANI_ZEROVELS

	WL	3,S3PN5C+FR7
	WL	ANI_CODE,DO_CROWD_CHEER

;	.word	ANI_ATTACK_OFF
	WL	ANI_CODE,grnd_hit
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_BOUNCE,4
	WL	3,S3PN5C+FR7
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE

	WL	4,S3PN5C+FR7
	WL	ANI_CODE,win_announce
;	.word	ANI_SET_ATTACH
;	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
	WL	40,S3PN5C+FR7

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

#raise
	WL	5,S4SW4A+FR1
	WL	5,S4SW4A+FR2
	WL	5,S4SW4A+FR3
	WL	5,S4SW4A+FR4
	WL	5,S4SW4A+FR5
	WL	5,S4SW4A+FR6
	WL	5,S4SW4A+FR7
	WL	5,S4SW4A+FR8
	WL	5,S4SW4A+FR9
#floop	WL	1000,S4SW4A+FR10
	WL	ANI_GOTO,#floop

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************
* RAISE ARM IN VICTORY FROM A STANCE

 SUBR	shn_2_raise_arm_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,DO_CROWD_CHEER
	WL	ANI_CODE,win_announce

	WL	3,S1TT5Z+FR2	;2.5
	WL	3,S1TT5Z+FR3	;3.5
	WL	ANI_GOTO,#cont

 SUBR	shn_4_raise_arm_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,DO_CROWD_CHEER
	WL	ANI_CODE,win_announce

#cont	WL	5,S4SW4A+FR1
	WL	5,S4SW4A+FR2
	WL	5,S4SW4A+FR3
	WL	5,S4SW4A+FR4
	WL	5,S4SW4A+FR5
	WL	5,S4SW4A+FR6
	WL	5,S4SW4A+FR7
	WL	5,S4SW4A+FR8
	WL	5,S4SW4A+FR9


	.word	ANI_SET_RPTCOUNT,-4	;set count to rnd from 0 to 4
#lp0	WL	55,S4SW4A+FR10
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#lp0

	WL	ANI_CODE,check_raisearm_bit
	WL	ANI_IFSTATUS,#wakeup

	;don't wake up.
	.word	ANI_SET_RPTCOUNT,1000
	WL	ANI_GOTO,#lp0

	;5,4,2,1 leaves the sequence.
#wakeup	WL	4,S4SW4A+FR5
	WL	4,S4SW4A+FR4
	WL	4,S4SW4A+FR2
	WL	4,S4SW4A+FR1

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_FACEDOWN
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
*
* #4 SLAP

 SUBR	shn_2_slap_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_LEAPING,17
	WL	2,S1TT5Z+FR2	;2.5
	WL	2,S1TT5Z+FR3	;3.5

 SUBR	shn_4_slap_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_LEAPING,15
	WL	3,S4PT3B+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 0eh,999,4ah,50,90000h,TGT_HEAD,76,110,30

	WL	4,S4PT3B+FR2
	WL	4,S4PT3B+FR3
	WL	3,S4PT3B+FR4
	WL	3,S4PT3B+FR5

	.word	ANI_ATTACK_ON, AMODE_BACKHAND,31,44,55,47	;mode,x,y,w,h
	WL	3,S4PT3B+FR6

	.word	ANI_ATTACK_OFF

	.WORD	ANI_ADD_MOVE,MOVE_C_2,2,2
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2

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


#*****************************************************************************
*
* #4 pummel - MK style

 SUBR	shn_2_pummel_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUNCH,5
	WL	1,S1TT5Z+FR2
	WL	1,S1TT5Z+FR3

 SUBR	shn_4_pummel_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUNCH,3
	.word	ANI_SET_RPTCOUNT,3	;rpt 2 times

;	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 05h,999,4ah,50,90000h,TGT_HEAD,65,90,10
;	WL	ANI_SET_YVEL,0h

	WL	3,S4PU3D+FR2
	.WORD	ANI_ADD_MOVE,MOVE_C_2,2,2
#rpt
	.word	ANI_CLR_BUTCOUNT
	.word	ANI_ATTACK_ON, AMODE_PUNCH2,21,80,42,14	;mode,x,y,w,h
	WL	3,S4MK3A+FR1
	.word	ANI_ATTACK_OFF
	WL	3,S4MK3A+FR2
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#ex
	WL	3,S4MK3A+FR3
	.word	ANI_CLR_BUTCOUNT
	.word	ANI_ATTACK_ON, AMODE_PUNCH2,21,80,42,14	;mode,x,y,w,h
	WL	3,S4MK3A+FR4
	.word	ANI_ATTACK_OFF
	WL	3,S4MK3A+FR5
	WL	3,S4MK3A+FR6

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2
	WL	ANI_SET_YVEL,40000h
	WL	3,S4MK3A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#missed
#no_hit2
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

;	.word	ANI_SET_ATTACH
;	WLLL	ANI_SETOPPVELS,18000h,18000h,0h		;x,y,z vels

	WL	3,S4MK3A+FR7

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,2,#ex
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#rpt
	.word	ANI_DRAW_NAME,32

	.ref	shn_4_hiptoss_anim
	WL	ANI_CHANGEANIM,shn_4_hiptoss_anim

#ex
	.word	ANI_OFFSET,15,0,0
	WL	ANI_CHANGEANIM,shn_4_butt_anim

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WLLL	ANI_SETOPPVELS,50000h,18000h,0h		;x,y,z vels
	WL	2,S4MK3A+FR7
#missed

	WL	2,S4MK3A+FR7

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* GET BUCKED OFF A PINNED OPPONENT

 SUBR	shn_buckoff_anim

	.ref	set_buckoff_vels

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	4,S3PN5C+FR7
	WL	1,S3PN5C+FR3
	WL	ANI_CODE,set_buckoff_vels
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	4,S3PN5C+FR7

	;now stand up
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

	.word	ANI_FACEDOWN

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************

	.end
