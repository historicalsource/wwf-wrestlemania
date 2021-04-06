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
	.include	"damage.equ"


******************************************************************************
* EXTERNAL REFERENCES

	;DOINK
	.ref	D4YR3B,D3RN3B

	;BRET
	.ref	hrt_facedown_getup_anim,hrt_4_faceup_getup2_anim
	.ref	hrt_combo_rake_face_anim,hrt_hitonground_facedown_anim

	;RAZOR
	.ref	R4YR3A,R3RN3D

	;TAKER
	.ref	U4YR3B,U3RN3A

	;YOKO
	.ref	Y4YR3A,Y3RN3C

	;SHAWN
	.ref	hrt_3_pile_driver_anim
	.ref	S4YR3A,S3RN3A

	;BAM BAM
	.ref	B4YR3A,B3RN3A

	;LEX
	.ref	L4YR3B,L3RN3B

	;MISC
	.ref	start_run_anim,CALL_MISSES,start_run_flung,process_ptrs
	.ref	no_bk_xvel,check_xvel,DO_CROWD_CHEER,hit_nearest
	.ref	SET_DIR_FACE,DO_GRUNT,check_raisearm_bit
	.ref	CALL_SPECIAL_MOVE,CALL_ANI_AVERAGE_MOVE
	.ref	CALL_OTHER_AVERAGE,ckzpos,set_tbukl_confine
	.ref	HIT_THE_MAT,SMALL_BOUNCE,hrt_faceup_getup_anim
	.ref	DO_COMBO_MESS,hrt_combo_hiptoss_anim
	.ref	hrt_combo_roll_uppercut_anim
	.ref	set_tbukl_airmode


******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* #2 COMBO PUNCH
 SUBR	hrt_combo_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS
	.WORD	ANI_CLEAR_COMBO

	WL	2,H4PL3X+FR1
	.word	ANI_STARTATTACK,AT_PUNCH,6
	WL	2,H4PL3X+FR2
	WL	2,H4PL3X+FR3

	.word	ANI_CLR_STATUS
	.word	ANI_ATTACK_ON_Z, AMODE_PUNCH,30,51,0,80,45,45 ;mode,x,y,z,w,h,d
	WL	2,H4PL3X+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFBLOCKED,#missed
	WL	ANI_IFNOTSTATUS,#missed
	.word	ANI_INC_COMBO

	WL	1,H4PL3X+FR4
	WL	2,H4PL3X+FR5
	WL	2,H4PL3X+FR6
	WL	2,H4PL3X+FR7
	WL	2,H4PL3X+FR8

	WL	2,H4PL3X+FR1
	.word	ANI_STARTATTACK,AT_PUNCH,6
	WL	2,H4PL3X+FR2
	WL	2,H4PL3X+FR3

	.word	ANI_CLR_STATUS
	.word	ANI_INC_COMBO
	.word	ANI_ATTACK_ON_Z, AMODE_PUNCH,30,51,0,80,45,45 ;mode,x,y,z,w,h,d
	WL	2,H4PL3X+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFBLOCKED,#missed
	WL	ANI_IFNOTSTATUS,#missed
	.word	ANI_INC_COMBO

	WL	1,H4PL3X+FR4
	WL	2,H4PL3X+FR5
	WL	2,H4PL3X+FR6
	WL	2,H4PL3X+FR7
	WL	2,H4PL3X+FR8

	.word	ANI_SET_RPTCOUNT,3	;1 times
#punch_loop
	.word	ANI_CLR_BUTCOUNT
	WL	1,H4PL3X+FR1
	.word	ANI_STARTATTACK,AT_PUNCH,6
	WL	1,H4PL3X+FR2
	WL	1,H4PL3X+FR3

	.word	ANI_ATTACK_ON_Z, AMODE_PUNCH,30,51,0,80,45,45 ;mode,x,y,z,w,h,d
	WL	2,H4PL3X+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFBLOCKED,#missed
	WL	ANI_IFNOTSTATUS,#missed
	.word	ANI_INC_COMBO

	WL	1,H4PL3X+FR4
	WL	2,H4PL3X+FR5
	WL	2,H4PL3X+FR6
	WL	1,H4PL3X+FR7

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#punch_loop

	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#no_dropkick
	WL	ANI_CHANGEANIM,hrt_combo_flying_kick_anim
#no_dropkick
	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#no_knee
	WL	ANI_CHANGEANIM,hrt_combo_knee_fall_anim
#no_knee

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#exit_move
	WL	ANI_CHANGEANIM,hrt_combo_rake_face_anim

#exit_move
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_CODE,CALL_MISSES
	WL	1,H4PL3X+FR4
	WL	2,H4PL3X+FR5
	WL	2,H4PL3X+FR6
	WL	2,H4PL3X+FR7
	WL	2,H4PL3X+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 NORMAL PUNCH

 SUBR	hrt_2_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H2PL3B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H2PL3B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H2PL3B+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_PUNCH,5

	WL	1,H2PL3B+FR2
	WL	2,H2PL3B+FR3

	.word	ANI_ATTACK_ON_Z, AMODE_PUNCH,30,91,-45,50,15,45	;mode,x,y,z,w,h,d
	WL	3,H2PL3B+FR4
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit

	WL	ANI_SET_YVEL,30000h
	WL	3,H2PL3B+FR4
#no_hit

	WL	2,H2PL3B+FR5
	WL	2,H2PL3B+FR6
	WL	2,H2PL3B+FR7
	WL	2,H2PL3B+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************

 SUBR	hrt_4_super_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
  
	.word	ANI_STARTATTACK,AT_UPRCUT,12

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 0ch,999,52h,55,90000h,TGT_CHEST,10,101,10
	WL	ANI_CODE,no_bk_xvel
	WL	ANI_SET_YVEL,30000h

	WL	2,H4UP3C+FR1
	WL	6,H4UP3C+FR2

	WL	2,H4UP3C+FR3
	WL	2,H4UP3C+FR4
	WL	2,H4UP3C+FR5

	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACK_ON,AMODE_UPRCUT,-6,40,64,90
	WL	3,H4UP3C+FR6
	.word	ANI_ATTACK_OFF

	.word	ANI_ADD_MOVE,MOVE_C_2,2,2
	WL	ANI_IFBLOCKED,#blocked
	WL	ANI_IFNOTSTATUS,#missed

	.ref	impact_sound
	WL	ANI_CODE,impact_sound
  
	.ref	MAKE_HIM_SCREAM
	WL	ANI_CODE,MAKE_HIM_SCREAM

	WL	ANI_CODE,CALL_OTHER_AVERAGE
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_slide
	WL	ANI_SET_YVEL,40000h

	WL	12,H4UP3C+FR7
	WL	3,H4UP3C+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,H4UP3C+FR9
	WL	3,H4UP3C+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#blocked
#no_slide
	WL	12,H4UP3C+FR7
	WL	3,H4UP3C+FR8
	WL	3,H4UP3C+FR9
	WL	3,H4UP3C+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	12,H4UP3C+FR7
	WL	3,H4UP3C+FR8
	WL	3,H4UP3C+FR9
	WL	3,H4UP3C+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 NORMAL PUNCH

 SUBR	hrt_4_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H4PL3X+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H4PL3X+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H4PL3X+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_PUNCH,5
	WL	1,H4PL3X+FR2
	WL	2,H4PL3X+FR3

	.word	ANI_ATTACK_ON_Z, AMODE_PUNCH,30,91,0,50,15,45 ;mode,x,y,z,w,h,d
	WL	3,H4PL3X+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2

	WL	ANI_SET_YVEL,30000h
	WL	3,H4PL3X+FR4
	
#no_hit2
	WL	2,H4PL3X+FR5
	WL	2,H4PL3X+FR6
	WL	2,H4PL3X+FR7
	WL	2,H4PL3X+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* UPPERCUT

 SUBR	hrt_2_uppercut_anim
 SUBR	hrt_4_uppercut_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
  
	.word	ANI_STARTATTACK,AT_UPRCUT,10

	WL	1,H4UP3C+FR1
	WL	1,H4UP3C+FR2
	WL	2,H4UP3C+FR3
	WL	1,H4UP3C+FR4
	WL	2,H4UP3C+FR5

	.word	ANI_ATTACK_ON,AMODE_UPRCUT,-6,22,64,100
	WL	3,H4UP3C+FR6
	.word	ANI_ATTACK_OFF

	.word	ANI_ADD_MOVE,MOVE_C_2,2,2
	WL	ANI_IFBLOCKED,#blocked
	WL	ANI_IFNOTSTATUS,#missed

  
	WL	ANI_CODE,MAKE_HIM_SCREAM
	.ref	impact_sound
	WL	ANI_CODE,impact_sound

	WL	ANI_CODE,CALL_OTHER_AVERAGE
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_slide
	WL	ANI_SET_YVEL,40000h

	WL	12,H4UP3C+FR7
	WL	3,H4UP3C+FR8
	WL	3,H4UP3C+FR9
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,H4UP3C+FR10
	WL	3,H4UP3C+FR11

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#blocked
#missed
#no_slide
	WL	12,H4UP3C+FR7
	WL	4,H4UP3C+FR8
	WL	3,H4UP3C+FR9
	WL	3,H4UP3C+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 PUSH

 SUBR	hrt_4_push_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WL	ANI_SETFLAG,M_PUSH
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUSH,9
	WL	3,H4PS3A+FR1
	WL	3,H4PS3A+FR2
	WL	3,H4PS3A+FR3
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ATTACK_ON, AMODE_PUSH,11,83,70,20 ;mode,x,y,w,h
	WL	3,H4PS3A+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,40h,-70000h,#no_hit	;range,vel,addr
	WL	15,H4PS3A+FR4
#no_hit
	WL	3,H4PS3A+FR4

	WL	ANI_IFSTATUS,#hit
;If missed on push, hold a little longer
	WL	5,H4PS3A+FR4
#hit
	WL	3,H4PS3A+FR5
	WL	3,H4PS3A+FR6
	WL	3,H4PS3A+FR7
	WL	3,H4PS3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 PUNCH FALLEN OPPONENT

 SUBR	hrt_2_ground_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_LBDROP,6
	WL	2,H2PF2B+FR1
	WL	2,H2PF2B+FR2

	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,5-10,-8,-40,32,32,50
	WL	1,H2PF2B+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#leapat

	WL	2,H2PF2B+FR3
	WL	3,H2PF2B+FR4
	.word	ANI_ATTACK_ON_Z,AMODE_LBOWDROP2,5,-8,-40,32,32,50
	WL	4,H2PF2B+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_GOTO,#common

#leapat
	.word	ANI_TARGET,TGT_HEAD,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,160,140,40000h,TGT_USER,13,0,-30
	WL	ANI_CODE,no_bk_xvel

	.word	ANI_STARTATTACK,AT_LBDROP,14
	WL	10,H2PF2B+FR3

	WL	4,H2PF2B+FR4
	.word	ANI_ATTACK_ON_Z,AMODE_LBOWDROP2,5,-8,-40,32,32,50
	WL	1,H2PF2B+FR5
	.word	ANI_ATTACK_OFF
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
#common
	.WORD	ANI_ADD_MOVE,MOVE_C_1,2,2
	WL	ANI_IFNOTSTATUS,#missed
	.word	ANI_SHAKER,15
	.word	ANI_SHAKEALL,1
	WL	ANI_GOTO,#hit
#missed
	WL	ANI_CODE,CALL_MISSES
#hit
	WL	2,H2PF2B+FR5
	WL	3,H2PF2B+FR6
	WL	2,H2PF2B+FR7
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

	.word	ANI_STARTATTACK,AT_LBDROP,6
	WL	2,H4PF4B+FR1
	WL	2,H4PF4B+FR2

	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,5,-6,-10,36,30,50
	WL	1,H4PF4B+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#leapat

	WL	2,H4PF4B+FR3
	WL	3,H4PF4B+FR4
	.word	ANI_ATTACK_ON_Z,AMODE_LBOWDROP2,5,-6,-10,36,30,50
	WL	4,H4PF4B+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_GOTO,#common

#leapat
	.word	ANI_TARGET,TGT_HEAD,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,160,140,40000h,TGT_USER,0,0,30
	WL	ANI_CODE,no_bk_xvel
	.word	ANI_STARTATTACK,AT_LBDROP,14

	WL	1,H4PF4B+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,H4PF4B+FR4
	.word	ANI_ATTACK_ON_Z,AMODE_LBOWDROP2,5,-6,-10,36,30,50
	WL	2,H4PF4B+FR5
	.word	ANI_ATTACK_OFF
#common
	.WORD	ANI_ADD_MOVE,MOVE_C_1,2,2
	WL	ANI_IFNOTSTATUS,#missed
	.word	ANI_SHAKER,15
	.word	ANI_SHAKEALL,1
	WL	ANI_GOTO,#hit
#missed
	WL	ANI_CODE,CALL_MISSES
#hit
	WL	2,H4PF4B+FR5
	WL	3,H4PF4B+FR6
	WL	2,H4PF4B+FR7
	WL	3,H4PF4B+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 HEADBUTT

 SUBR	hrt_2_butt_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H2BC3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H2BC3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H2BC3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_HDBUTT,3
	WL	2,H2BC3A+FR2
	WL	2,H2BC3A+FR3

	.word	ANI_ATTACK_ON,AMODE_HDBUTT,19,75,35,24	;mode,x,y,w,h
	WL	3,H2BC3A+FR4
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

	.word	ANI_SET_ATTACH
	.word	ANI_DEBRISAT,200,2,0,100,0	;%chance, tbl index, x,y,z off
	.ref	impact_sound
	WL	ANI_CODE,impact_sound
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,25
	.word	ANI_DETACH

#missedb
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit
	WL	ANI_SET_YVEL,38000h
	WL	6,H2BC3A+FR5
#missed
#no_hit
	WL	2,H2BC3A+FR5
	WL	2,H2BC3A+FR6
	WL	2,H2BC3A+FR7
	WL	2,H2BC3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #2 SUPER PUNCH/HEAD BUTT

 SUBR	hrt_2_super_punch2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	3,H2BC3A+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 11,999,4eh,50,90000h,TGT_HEAD,40,101,-10

	.word	ANI_STARTATTACK,AT_HDBUTT,3
	WL	3,H2BC3A+FR2
	WL	8,H2BC3A+FR3

	.word	ANI_ATTACK_ON,AMODE_URN,19,75,35,24	;mode,x,y,w,h
	WL	3,H2BC3A+FR4
	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

	WL	ANI_IFNOTSTATUS,#missed
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

	.word	ANI_SET_ATTACH
	.word	ANI_DEBRISAT,200,2,0,100,0	;%chance, tbl index, x,y,z off
	.ref	impact_sound
	WL	ANI_CODE,impact_sound
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,25
	.word	ANI_DETACH

#missedb
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit
	WL	ANI_SET_YVEL,38000h
	WL	6,H2BC3A+FR5
#missed
#no_hit

	.ref	spunch_delay
	WL	ANI_CODE,spunch_delay
	WL	ANI_IFNOTSTATUS,#none
	WL	20,H2BC3A+FR5
#none

	WL	2,H2BC3A+FR5
	WL	2,H2BC3A+FR6
	WL	2,H2BC3A+FR7
	WL	2,H2BC3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 SUPER PUNCH/HEAD BUTT

 SUBR	hrt_4_super_punch2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	3,H4BC3A+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 11,999,4eh,50,90000h,TGT_HEAD,40,101,10

	.word	ANI_STARTATTACK,AT_HDBUTT,3
	WL	9,H4BC3A+FR2
	WL	2,H4BC3A+FR3

	.word	ANI_ATTACK_ON, AMODE_URN,19,75,35,24	;mode,x,y,w,h
	WL	3,H4BC3A+FR4
	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

	WL	ANI_IFNOTSTATUS,#missed
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

	.word	ANI_SET_ATTACH
	.word	ANI_DEBRISAT,200,2,0,100,0	;%chance, tbl index, x,y,z off
	.ref	impact_sound
	WL	ANI_CODE,impact_sound
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,25
	.word	ANI_DETACH

#missedb
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2
	WL	ANI_SET_YVEL,38000h
	WL	6,H4BC3A+FR5
#missed
#no_hit2

	WL	ANI_CODE,spunch_delay
	WL	ANI_IFNOTSTATUS,#none
	WL	20,H4BC3A+FR5
#none

	WL	2,H4BC3A+FR5
	WL	2,H4BC3A+FR6
	WL	2,H4BC3A+FR7
	WL	2,H4BC3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 HEADBUTT

 SUBR	hrt_4_butt_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H4BC3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H4BC3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H4BC3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	.word	ANI_STARTATTACK,AT_HDBUTT,3
	WL	2,H4BC3A+FR2
	WL	2,H4BC3A+FR3

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,19,75,35,24	;mode,x,y,w,h
	WL	3,H4BC3A+FR4
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

	.word	ANI_SET_ATTACH
	.word	ANI_DEBRISAT,200,2,0,100,0	;%chance, tbl index, x,y,z off
	.ref	impact_sound
	WL	ANI_CODE,impact_sound
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,25
	.word	ANI_DETACH

#missedb
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2
	WL	ANI_SET_YVEL,38000h
	WL	6,H4BC3A+FR5
#missed
#no_hit2
	WL	2,H4BC3A+FR5
	WL	2,H4BC3A+FR6
	WL	2,H4BC3A+FR7
	WL	2,H4BC3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 HEADBUTTS - In close

 SUBR	hrt_2_butts_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	.word	ANI_SET_RPTCOUNT,3	;5 times
#rpt
	.word	ANI_CLR_BUTCOUNT

	.word	ANI_STARTATTACK,AT_HDBUTT,6
	WL	2,H2BC3A+FR1
	WL	2,H2BC3A+FR2
	WL	2,H2BC3A+FR3

	.word	ANI_ATTACK_ON,AMODE_HDBUTT_STAY,19,75,35,24	;mode,x,y,w,h
	WL	2,H2BC3A+FR4
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit

	WL	ANI_SET_YVEL,38000h
	WL	6,H2BC3A+FR5
#no_hit
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

	.word	ANI_SET_ATTACH
	.word	ANI_DEBRISAT,200,2,0,100,0	;%chance, tbl index, x,y,z off
	.ref	impact_sound
	WL	ANI_CODE,impact_sound
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,25
	.word	ANI_DETACH

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#ex
	.word	ANI_DEC_RPTCOUNT

	WL	2,H2BC3A+FR5
	WL	2,H2BC3A+FR6
	WL	2,H2BC3A+FR7

	WL	ANI_IF_RPTCOUNT,#rpt
	WL	ANI_CHANGEANIM,hrt_4_uppercut_anim
#ex
	WLLL	ANI_SETOPPVELS,40000h,38000h,0h		;x,y,z vels

	WL	2,H2BC3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WLLL	ANI_SETOPPVELS,50000h,18000h,0h		;x,y,z vels
;	WL	4,H2BC3A+FR5
#missed
	WL	2,H2BC3A+FR5
	WL	2,H2BC3A+FR6
	WL	2,H2BC3A+FR7
	WL	2,H2BC3A+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#* #4 HEADBUTT

 SUBR	hrt_4_butts_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	.word	ANI_SET_RPTCOUNT,3	;5 times
#rpt
	.word	ANI_CLR_BUTCOUNT

	.word	ANI_STARTATTACK,AT_HDBUTT,6
	WL	2,H4BC3A+FR1
	WL	2,H4BC3A+FR2
	WL	2,H4BC3A+FR3

	.word	ANI_ATTACK_ON, AMODE_HDBUTT_STAY,19,75,35,24	;mode,x,y,w,h
	WL	2,H4BC3A+FR4
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2

	WL	ANI_SET_YVEL,38000h
	WL	6,H4BC3A+FR5
#no_hit2
	WL	ANI_IFNOTSTATUS,#missed
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

	.word	ANI_SET_ATTACH
	.word	ANI_DEBRISAT,200,2,0,100,0	;%chance, tbl index, x,y,z off
	WL	ANI_CODE,impact_sound
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,25
	.word	ANI_DETACH

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#ex
	.word	ANI_DEC_RPTCOUNT

	WL	2,H4BC3A+FR5
	WL	2,H4BC3A+FR6
	WL	2,H4BC3A+FR7

	WL	ANI_IF_RPTCOUNT,#rpt

	WL	ANI_CHANGEANIM,hrt_4_uppercut_anim
#ex
	WLLL	ANI_SETOPPVELS,40000h,38000h,0h		;x,y,z vels

	WL	2,H4BC3A+FR8
   
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WLLL	ANI_SETOPPVELS,50000h,18000h,0h		;x,y,z vels
;	WL	4,H4BC3A+FR5
#missed
	WL	2,H4BC3A+FR5
	WL	2,H4BC3A+FR6
	WL	2,H4BC3A+FR7
	WL	2,H4BC3A+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* COMBO HEADBUTT

 SUBR	hrt_combo_butt_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,20000h,AM_FACE_REL

	WL	2,H4BC3A+FR1
	.word	ANI_STARTATTACK,AT_HDBUTT,3
	WL	2,H4BC3A+FR2
	WL	2,H4BC3A+FR3

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,19,55,55,34	;mode,x,y,w,h
	WL	1,H4BC3A+FR4
	.word	ANI_ATTACK_OFF
	.word	ANI_ZEROVELS
	WL	ANI_IFBLOCKED,#missed
	WL	ANI_IFNOTSTATUS,#missed
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,28000h,0h		;x,y,z vels
	.word	ANI_INC_COMBO

	WL	ANI_SET_YVEL,18000h
	WL	2,H4BC3A+FR4
	WL	4,H4BC3A+FR5
	WL	2,H4BC3A+FR5
	WL	3,H4BC3A+FR6
	WL	2,H4BC3A+FR7
	WL	3,H4BC3A+FR8

	.word	ANI_STARTATTACK,AT_HDBUTT,3
	WL	2,H4BC3A+FR2
	WL	2,H4BC3A+FR3

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,19,55,55,34	;mode,x,y,w,h
	WL	1,H4BC3A+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFBLOCKED,#missed
	WL	ANI_IFNOTSTATUS,#missed
	.word	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,28000h,0h		;x,y,z vels

	WL	ANI_SET_YVEL,18000h
	WL	2,H4BC3A+FR4
	WL	3,H4BC3A+FR5
	WL	2,H4BC3A+FR5
	WL	2,H4BC3A+FR6
	WL	2,H4BC3A+FR7
	WL	2,H4BC3A+FR8

	.word	ANI_SET_RPTCOUNT,3	;1 times
#butt_loop
	.word	ANI_CLR_BUTCOUNT
	WLW	ANI_SET_XVEL,0e000h,AM_FACE_REL
	.word	ANI_STARTATTACK,AT_HDBUTT,3
	WL	1,H4BC3A+FR2
	WL	1,H4BC3A+FR3

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,19,55,55,34	;mode,x,y,w,h
	WL	1,H4BC3A+FR4
	.word	ANI_ATTACK_OFF
	.word	ANI_ZEROVELS
	WL	ANI_IFBLOCKED,#missed
	WL	ANI_IFNOTSTATUS,#missed
	.word	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,28000h,0h		;x,y,z vels

	WL	ANI_SET_YVEL,18000h
	WL	1,H4BC3A+FR4
	WL	2,H4BC3A+FR5
	WL	1,H4BC3A+FR5
	WL	2,H4BC3A+FR6
	WL	1,H4BC3A+FR7
	WL	1,H4BC3A+FR8

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#butt_loop

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#no_dropkick
	WL	ANI_CHANGEANIM,hrt_combo_flying_kick_anim
#no_dropkick
	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#no_knee
	WL	ANI_CHANGEANIM,hrt_combo_knee_fall_anim
#no_knee
	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#last_check
	WL	ANI_CHANGEANIM,hrt_combo_roll_uppercut_anim
#last_check
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#exit_move
	WL	ANI_CHANGEANIM,hrt_combo_hiptoss_anim

#exit_move
	.WORD	ANI_DETACH
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	.WORD	ANI_DETACH
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_CODE,CALL_MISSES
	WL	2,H4BC3A+FR5
	WL	2,H4BC3A+FR6
	WL	2,H4BC3A+FR7
	WL	2,H4BC3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 KICK

 SUBR	hrt_2_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H2KM3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H2KM3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H2KM3A+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_KICK,5
	WL	2,H2KM3A+FR3
	WL	2,H2KM3A+FR4

	.word	ANI_ATTACK_ON,AMODE_KICK,23,73,50,17	;mode,x,y,w,h
	WL	3,H2KM3A+FR5
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit
	WL	ANI_SET_YVEL,30000h
	WL	2,H2KM3A+FR5
	
#no_hit
	WL	2,H2KM3A+FR5


	;one more tick if blocked, three more if hit, none if missed.
	.word	ANI_HMBWAIT,7,0,0


	WL	3,H2KM3A+FR6
	WL	3,H2KM3A+FR8
	WL	3,H2KM3A+FR9
	WL	3,H2KM3A+FR11

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 KICK

 SUBR	hrt_combo_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_KICK,6
	WL	2,H4KM3B+FR2
	WL	2,H2KM3A+FR3
	WL	2,H2KM3A+FR4

	.word	ANI_CLR_STATUS
	.word	ANI_INC_COMBO
	.word	ANI_ATTACK_ON,AMODE_KICK,23,53,50,27	;mode,x,y,w,h
	WL	2,H2KM3A+FR5
	.word	ANI_ATTACK_OFF
	.word	ANI_ZEROVELS
	WL	ANI_IFBLOCKED,#missed
	WL	ANI_IFNOTSTATUS,#missed
	WLLL	ANI_SETOPPVELS,0,28000h,0h		;x,y,z vels
	.word	ANI_INC_COMBO

	WL	4,H2KM3A+FR5

	WL	2,H2KM3A+FR6
	WL	2,H2KM3A+FR8
	WL	2,H4KM3B+FR9
	WL	2,H4KM3B+FR10

	WLW	ANI_SET_XVEL,0e000h,AM_FACE_REL

	.word	ANI_STARTATTACK,AT_KICK,6
	WL	2,H4KM3B+FR2
	WL	2,H2KM3A+FR3
	WL	2,H2KM3A+FR4

	.word	ANI_CLR_STATUS
	.word	ANI_ATTACK_ON,AMODE_KICK,23,53,50,27	;mode,x,y,w,h
	WL	2,H2KM3A+FR5
	.word	ANI_ATTACK_OFF
	.word	ANI_ZEROVELS
	WL	ANI_IFBLOCKED,#missed
	WL	ANI_IFNOTSTATUS,#missed
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,28000h,0h		;x,y,z vels
	.word	ANI_INC_COMBO

	WL	4,H2KM3A+FR5

	WL	2,H2KM3A+FR6
	WL	2,H2KM3A+FR8
	WL	2,H4KM3B+FR9
	WL	2,H4KM3B+FR10

	.word	ANI_SET_RPTCOUNT,3	;1 times
#kick_loop
	.word	ANI_CLR_BUTCOUNT
	WLW	ANI_SET_XVEL,0e000h,AM_FACE_REL
	.word	ANI_STARTATTACK,AT_KICK,6
	WL	1,H4KM3B+FR2
	WL	2,H2KM3A+FR3
	WL	1,H2KM3A+FR4

	.word	ANI_CLR_STATUS
	.word	ANI_ATTACK_ON,AMODE_KICK,23,53,50,27	;mode,x,y,w,h
	WL	1,H2KM3A+FR5
	.word	ANI_ATTACK_OFF
	.word	ANI_ZEROVELS
	WL	ANI_IFBLOCKED,#missed
	WL	ANI_IFNOTSTATUS,#missed
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,28000h,0h		;x,y,z vels
	.word	ANI_INC_COMBO

	WL	2,H2KM3A+FR5

	WL	1,H2KM3A+FR6
	WL	2,H2KM3A+FR8
	WL	1,H4KM3B+FR9
	WL	2,H4KM3B+FR10

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#kick_loop

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#no_knee
	WL	ANI_CHANGEANIM,hrt_combo_knee_fall_anim
#no_knee
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#no_dropkick
	WL	ANI_CHANGEANIM,hrt_combo_flying_kick_anim
#no_dropkick

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#exit_move
	WL	ANI_CHANGEANIM,hrt_combo_butt_anim
#exit_move
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_CODE,CALL_MISSES
	WL	4,H2KM3A+FR5
	WL	2,H2KM3A+FR6
	WL	2,H2KM3A+FR8
	WL	2,H4KM3B+FR9
	WL	2,H4KM3B+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 KICK

 SUBR	hrt_4_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H4KM3B+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H4KM3B+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H2KM3A+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_KICK,5
	WL	2,H2KM3A+FR3
	WL	2,H2KM3A+FR4

	.word	ANI_ATTACK_ON,AMODE_KICK,23,73,50,17	;mode,x,y,w,h
	WL	3,H2KM3A+FR5
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit
	WL	ANI_SET_YVEL,30000h
	WL	2,H2KM3A+FR5
	
#no_hit
	WL	2,H2KM3A+FR5
	;one more tick if blocked, three more if hit, none if missed.
	.word	ANI_HMBWAIT,7,0,0

	WL	3,H2KM3A+FR6
	WL	3,H2KM3A+FR8
	WL	3,H4KM3B+FR9
	WL	3,H4KM3B+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 Jump kick

 SUBR	hrt_4_jump_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_LEAPING,12
;	.ref	BAMFRE_P
;	WLWW	ANI_SHADOWTRAIL,BAMFRE_P,3,12	;pal,rate,lifespan
	WL	3,H4KM3D+FR1
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 10,999,105,50,90000h,TGT_HEAD,70,90,10
	WL	3,H4KM3D+FR2
	WL	3,H4KM3D+FR3
	WL	4,H4KM3D+FR4

	.word	ANI_ATTACK_ON, AMODE_FLYKICK,15,69,64,38	;mode,x,y,w,h
	WL	3,H4KM3D+FR5
	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_slide
	WL	ANI_SET_YVEL,30000h
#no_slide

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb

	.word	ANI_SHAKER,35

	WL	3,H4KM3D+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,H4KM3D+FR7
	WL	3,H4KM3D+FR8
	WL	3,H4KM3D+FR9
	.word	ANI_SHADOWTRAIL,0	;off

	.word	ANI_FACEUP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WL	3,H4KM3D+FR5
;fall through
#missed
	WL	6,H4KM3D+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,H4KM3D+FR7
	WL	3,H4KM3D+FR8
	WL	3,H4KM3D+FR9

;	.word	ANI_SHADOWTRAIL,0	;off
	.word	ANI_FACEUP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 KICK

 SUBR	hrt_2_super_kick_anim
 SUBR	hrt_4_super_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_STARTATTACK,AT_LEAPING,15
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	2,H4KM3C+FR1

	.word	ANI_OFFSET,5,0,0
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 10,999,80-5,45,90000h,TGT_CHEST,64-10,0,-20
	WL	ANI_SET_YVEL,48000h
	.word	ANI_SETPLYRMODE,MODE_INAIR

	WL	4,H4KM3C+FR1
	WL	4,H4KM3C+FR2
	WL	2,H4KM3C+FR3

	.word	ANI_ATTACK_ON,AMODE_SUPER_KICK,5,54,70,34
	WWL	ANI_WAITHITOPP,3,H4KM3C+FR4
	.word	ANI_ATTACK_OFF

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#blocked
	WWL	ANI_SLIDE_BACK,30h,-70000h,#norm

;hit and slide
	WL	ANI_SET_YVEL,30000h
	WLW	ANI_SET_ZVEL,28000h,AM_ABS
	WL	ANI_GOTO,#missed

#norm
	WLW	ANI_SET_XVEL,-8000h,AM_FACE_REL
	WLW	ANI_SET_ZVEL,28000h,AM_ABS
	WL	ANI_SET_YVEL,20000h
	WL	ANI_GOTO,#missed

;hit + no slide or blocked
#blocked
	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL
	WLW	ANI_SET_ZVEL,28000h,AM_ABS
	WL	ANI_SET_YVEL,20000h
	WWL	ANI_SLIDE_BACK,30h,-70000h,#norm

	;missed
#missed
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.ref	skick_delay
	WL	ANI_CODE,skick_delay
	WL	ANI_IFNOTSTATUS,#none
	WL	20,H4KM3C+FR4
#none

	WL	2,H4KM3C+FR5
	WL	2,H4KM3C+FR6
	WL	2,H4KM3C+FR7
	WL	2,H4KM3C+FR8
	WL	2,H4KM3C+FR9

	.word	ANI_FACEUP

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 KICK - Against TB attacks

 SUBR	hrt_kick_TB_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_STARTATTACK,AT_LEAPING,15
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETPLYRMODE,MODE_INAIR2
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2

	WL	ANI_SET_YVEL,70000h
	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL
	.word	ANI_OFFSET,5,0,0

	WL	3,H4KM3C+FR1
	WL	3,H4KM3C+FR2
	.word	ANI_ATTACK_ON,AMODE_SPINKICK,5,54,70,34
	WL	2,H4KM3C+FR3
	WL	8,H4KM3C+FR4
	.word	ANI_ATTACK_OFF

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	2,H4KM3C+FR5
	WL	2,H4KM3C+FR6
	WL	2,H4KM3C+FR7
	WL	2,H4KM3C+FR8
	WL	2,H4KM3C+FR9

	.word	ANI_FACEUP

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #3 FLYING KICK

#yoff	equ	57

 SUBR	hrt_flying_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_LEAPING,15
	WL	2,H3DC3A+FR1
	WL	2,H3DC3A+FR2

	.word	ANI_OFFSET,0,#yoff,0

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 15,999,160,65,90000h,TGT_HEAD,5,45,0
	WL	ANI_CODE,no_bk_xvel

	WL	7,H3DC3A+FR3
	WL	3,H3DC3A+FR4

	.WORD	ANI_ADD_MOVE,MOVE_C_4,2,2

	.word	ANI_ATTACK_ON,AMODE_FLYKICK,-3,26,61,21 ;mode,x,y,w,h
	WL	3,H3DC3A+FR5
	.word	ANI_ATTACK_OFF
;	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker
;	WL	ANI_GOTO,#hit
;#missedb
;	.word	ANI_ZERO_XZVELS
;#hit
	WLW	ANI_SET_ZVEL,0,AM_ABS
	WL	3,H3DC3A+FR5
	WL	1,H3DC3A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKER,25
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	2,H3DC3A+FR8
	WL	2,H3DC3A+FR9

	.word	ANI_XFLIP
	.word	ANI_SETFACING
	WL	ANI_CHANGEANIM,hrt_facedown_getup_anim


#*****************************************************************************
*
* #3 FLYING KICK

#yoff	equ	57

 SUBR	hrt_combo_flying_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_LEAPING,25
	WL	3,H3DC3A+FR1
	WL	3,H3DC3A+FR2

	.word	ANI_OFFSET,0,#yoff,0

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,150,65,90000h,TGT_HEAD,50,32,0
	WL	ANI_CODE,no_bk_xvel

	WL	12,H3DC3A+FR3
	WL	2,H3DC3A+FR4

	.WORD	ANI_ADD_MOVE,MOVE_C_4,2,2

	.word	ANI_ATTACK_ON,AMODE_FLYKICK,-3,26,61,21 ;mode,x,y,w,h
	WL	3,H3DC3A+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFBLOCKED,#missed
	WL	ANI_IFNOTSTATUS,#missed
	.word	ANI_INC_COMBO

#missed
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	5,H3DC3A+FR5

	WL	1,H3DC3A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	3,H3DC3A+FR8
	WL	3,H3DC3A+FR9

	.word	ANI_XFLIP
	.word	ANI_SETFACING
	WL	ANI_CHANGEANIM,hrt_facedown_getup_anim


******************************************************************************
*
* #3 FLYING KICK - headhold uppercut version

 SUBR	hrt_flying_kick2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_LEAPING,25
	WL	3,H3DC3A+FR2

	.word	ANI_OFFSET,0,#yoff,0

	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,10000h,AM_FACE_REL

	WL	9,H3DC3A+FR3
	WL	2,H3DC3A+FR4

	.WORD	ANI_ADD_MOVE,MOVE_C_4,2,2

	.word	ANI_ATTACK_ON,AMODE_FLYKICK,-3,26,61,21 ;mode,x,y,w,h
	WL	3,H3DC3A+FR5
	.word	ANI_ATTACK_OFF
	WL	5,H3DC3A+FR5

	WL	1,H3DC3A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	3,H3DC3A+FR8
	WL	3,H3DC3A+FR9

	.word	ANI_XFLIP
	.word	ANI_SETFACING
	WL	ANI_CHANGEANIM,hrt_facedown_getup_anim


#*****************************************************************************
*
* #2 STOMP ON FALLEN OPPONENT

 SUBR	hrt_2_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H2MP2B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H2MP2B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H2MP2B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	WL	3,H2MP2B+FR2
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,7,-10,-40,28,31,50
	WL	1,H2MP2B+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#no_leapat

	.word	ANI_TARGET,TGT_CHEST,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,160,140,40000h,TGT_USER,22,0,-30
	WL	ANI_CODE,no_bk_xvel

#no_leapat
	.word	ANI_STARTATTACK,AT_STOMP,5
	WL	3,H2MP2B+FR3
	WL	1,H2MP2B+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP2,7,-10,-40,28,31,50
	WL	1,H2MP2B+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	.word	ANI_SHAKER,20
	.word	ANI_SHAKEALL,1
	WL	ANI_GOTO,#hit
#missed
	WL	ANI_CODE,CALL_MISSES
#hit

	WL	3,H2MP2B+FR5
	WL	3,H2MP2B+FR6
	WL	3,H2MP2B+FR7
	WL	3,H2MP2B+FR8

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

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H4MP4A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H4MP4A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H4MP4A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	WL	3,H4MP4A+FR2
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,7,-12,-10,29,35,50
	WL	1,H4MP4A+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#no_leapat

	.word	ANI_TARGET,TGT_CHEST,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,160,140,40000h,TGT_USER,21,0,30
	WL	ANI_CODE,no_bk_xvel

#no_leapat
	.word	ANI_STARTATTACK,AT_STOMP,5
	WL	3,H4MP4A+FR3
	WL	1,H4MP4A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP2,7,-12,-10,29,35,50
	WL	1,H4MP4A+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	.word	ANI_SHAKER,20
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	.word	ANI_SHAKEALL,1
	WL	ANI_GOTO,#hit
#missed
	WL	ANI_CODE,CALL_MISSES
#hit

	WL	3,H4MP4A+FR5
	WL	3,H4MP4A+FR6
	WL	3,H4MP4A+FR7
	WL	3,H4MP4A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* RUNNING GROUND PUNCH

#yoff	equ	50

 SUBR	hrt_running_ground_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	2,H4JK4C+FR1
	WL	2,H4JK4C+FR2

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
	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,1
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_ATTACK_ON,AMODE_BUTTSTOMP,-50,-6,36,23
	WL	2,H4JK4C+FR6
	.word	ANI_ATTACK_OFF
	.word	ANI_BOUNCE,3
	WL	5,H4JK4C+FR7
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE

	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2
	WL	ANI_IFSTATUS,#hit

	WL	ANI_CODE,CALL_MISSES
	WL	ANI_GOTO,#AVOID_HIT_CALL

#hit
	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE
#AVOID_HIT_CALL
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

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCONFINE|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING
	.word	ANI_SET_WRESTLER_XFLIP
	.word	ANI_SCROLL_CTRL,SC_RESTORE

	WL	3,H4JP4C+FR1
	WL	3,H4JP4C+FR2
	.word	ANI_OFFSET,#xoff,#yoff,0

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 36,210,210,210,90000h,TGT_CHEST,22,-9,20
	.word	ANI_STARTATTACK,AT_BSTOMP,36
;	.word	ANI_SETPLYRMODE,MODE_INAIR2
	WL	ANI_CODE,set_tbukl_airmode
	.word	ANI_GRAVITY_ON
	.word	ANI_SHAKECORNER

	WL	ANI_CODE,check_xvel

	WL	3,H4JP4C+FR3
	WL	3,H4JP4C+FR4

	.word	ANI_ADD_MOVE,MOVE_C_6,2,2

	;attack box dimensions (that means size) depends on opp mode
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,0,-1+5,-10,36,52,70
	WWL	ANI_IFOPPMODE,MODE_ONGROUND,#opp_onground
	WWL	ANI_IFOPPMODE,MODE_DEAD,#opp_onground
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,0,-1+15,-10,36,52,70

#opp_onground
	WL	6,H4JP4C+FR5
	WL	ANI_CODE,set_tbukl_confine
	WWL	ANI_WAITHITOPP,24,H4JP4C+FR5
;	.word	ANI_ZERO_XZVELS
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_OFF

	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,1
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	ANI_IFNOTSTATUS,#missed

	;hit
	.word	ANI_DRAW_NAME,18
	.word	ANI_BOUNCE,5
	WL	1,H4JP4C+FR6
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKER,18
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#common

#missed
;	WL	ANI_CODE,tbukl_miss_damage
	WL	ANI_CODE,CALL_MISSES
	WL	ANI_CHANGEANIM,hrt_hitonground_facedown_anim

#common

	WL	4,H4JP4C+FR6

	.word	ANI_FACEDOWN
	.word	ANI_OFFSET,10,0,-5
	WL	ANI_CHANGEANIM,hrt_4_faceup_getup2_anim


;#*****************************************************************************
;*
;* #2 BIG BOOT
;
; SUBR	hrt_2_bigboot_anim
;
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_SETSPEED,100h
;	.word	ANI_ZEROVELS
;
;	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
;	.word	ANI_SET_WRESTLER_XFLIP
;
;	WL	3,H2KM3A+FR1
;	.word	ANI_STARTATTACK,AT_BIGBOOT,12
;	WL	3,H2KM3A+FR3
;	WL	ANI_CODE,#clrcnt
;	WL	3,H2KM3A+FR4
;
;	.word	ANI_ATTACK_ON, AMODE_BIGBOOT,23,73,50,17 ;mode,x,y,w,h
;	WWL	ANI_WAITHITOPP,15,H2KM3A+FR5
;#lp0
;	.word	ANI_STARTATTACK,AT_BIGBOOT,5
;	WL	2,H2KM3A+FR5
;	WL	ANI_CODE,#holdup
;	WL	ANI_IFSTATUS,#lp0
;
;	.word	ANI_ATTACK_OFF
;	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
;	WL	ANI_IFNOTSTATUS,#miss
;	.word	ANI_DRAW_NAME,27
;#miss
;	WL	3,H2KM3A+FR6
;	WL	3,H2KM3A+FR8
;	WL	3,H2KM3A+FR9
;	WL	3,H2KM3A+FR11
;
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END
;
; SUBR	hrt_4_bigboot_anim
;
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_SETSPEED,100h
;	.word	ANI_ZEROVELS
;
;	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
;	.word	ANI_SET_WRESTLER_XFLIP
;
;	.word	ANI_STARTATTACK,AT_BIGBOOT,12
;	WL	3,H4KM3B+FR2
;	WL	3,H2KM3A+FR3
;	WL	ANI_CODE,#clrcnt
;	WL	3,H2KM3A+FR4
;
;	.word	ANI_ATTACK_ON, AMODE_BIGBOOT,23,73,50,17 ;mode,x,y,w,h
;	WWL	ANI_WAITHITOPP,15,H2KM3A+FR5
;#lp1
;	WL	2,H2KM3A+FR5
;	WL	ANI_CODE,#holdup
;	WL	ANI_IFSTATUS,#lp1
;
;	.word	ANI_ATTACK_OFF
;	WL	ANI_IFNOTSTATUS,#missz
;	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
;	.word	ANI_DRAW_NAME,27
;#missz
;	WL	3,H2KM3A+FR6
;	WL	3,H2KM3A+FR8
;	WL	3,H4KM3B+FR9
;	WL	3,H4KM3B+FR10
;
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END
;
;#clrcnt
;;We are re-using BUT_COUNT in the player process
;	clr	a0
;	move	a0,*a13(BUT_COUNT)
;
;	rets
;
;#holdup
;	move	*a13(BUT_COUNT),a0
;	inc	a0
;	move	a0,*a13(BUT_COUNT)
;
;;Max time to hold up in air (*2 ticks)
;	cmpi	25,a0
;	jrgt	#button_up
;
;	move	*a13(BUT_VAL_CUR),a0
;	btst	PLAYER_SKICK_BIT,a0		;still down?
;	jrz	#button_up
;
;;Still holding...
;
;	move	*a13(ANIMODE),a1
;	ori	MODE_STATUS,a1
;	move	a1,*a13(ANIMODE)
;	rets
;
;#button_up
;	move	*a13(ANIMODE),a1
;	andni	MODE_STATUS,a1
;	move	a1,*a13(ANIMODE)
;	rets

#*****************************************************************************
*
* #2 KNEE

 SUBR	hrt_2_knee_anim

;The artwork is labeled wrong...  2=4, It is okay!

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_KNEE,5

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H4NM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H4NM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H4NM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_OFFSET,23,0,0			;x,y,z

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 21,999,36,30,90000h,TGT_CHEST,46,100,0
	WL	2,H4NM3A+FR3

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2

	.word	ANI_ATTACK_ON, AMODE_KNEE,11,44,51,49	;mode,x,y,w,h
	WL	2,H4NM3A+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit
	WL	ANI_SET_YVEL,50000h
	WLW	ANI_SET_ZVEL,4000h,AM_ABS
	WL	3,H4NM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#cont
#no_hit
;	WL	ANI_IFNOTSTATUS,#nodrft
;	WLW	ANI_SET_ZVEL,4000h,AM_ABS
;#nodrft
	WL	6,H4NM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
#cont
	WL	3,H4NM3A+FR5
	WL	3,H4NM3A+FR6
	WL	3,H4NM3A+FR7

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #4 KNEE

 SUBR	hrt_4_knee_to_head_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	2,H2NM3A+FR2
	.word	ANI_OFFSET,23,0,0			;x,y,z

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 21,999,36,30,90000h,TGT_CHEST,46,100,-10

	WL	ANI_GOTO,#skip_run_check

 SUBR	hrt_4_knee_anim

;The artwork is labeled wrong...  2=4, It is okay!

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_KNEE,5

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H2NM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H2NM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,H2NM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_OFFSET,23,0,0			;x,y,z

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 21,999,36,30,90000h,TGT_CHEST,46,100,-10

#skip_run_check

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2

	.word	ANI_STARTATTACK,AT_KNEE,3
	WL	2,H2NM3A+FR3

	.word	ANI_ATTACK_ON, AMODE_KNEE,11,44,51,49	;mode,x,y,w,h
	WL	3,H2NM3A+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit
	WL	ANI_SET_YVEL,50000h
	WLW	ANI_SET_ZVEL,-8000h,AM_ABS
	WL	1,H2NM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#cont
#no_hit
;	WL	ANI_IFNOTSTATUS,#nodrft
;	WLW	ANI_SET_ZVEL,-4000h,AM_ABS
;#nodrft
	WL	6,H2NM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

#cont
	WL	10,H2NM3A+FR4
	WL	3,H2NM3A+FR5
	WL	3,H2NM3A+FR6

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #4 KNEE FALL

 SUBR	hrt_combo_knee_fall_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	3,H2NM3A+FR2
	.word	ANI_OFFSET,23,0,0			;x,y,z

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 10,999,20h,20,90000h,TGT_CHEST,40,20,-10

	.word	ANI_STARTATTACK,AT_KNEE,18
	WL	3,H2NM3A+FR3

	.word	ANI_ATTACK_ON,AMODE_BIGKNEE,11,30,80,49	;mode,x,y,w,h
	WL	3,H2NM3A+FR4
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit
	WL	ANI_SET_YVEL,50000h
	WLW	ANI_SET_ZVEL,-8000h,AM_ABS
	WL	1,H2NM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#cont
#no_hit
	WL	ANI_IFNOTSTATUS,#nodrft
	.word	ANI_INC_COMBO
	WLW	ANI_SET_ZVEL,-4000h,AM_ABS
#nodrft
	WL	1,H2NM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

#cont
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	3,H4NM3A+FR5
	WL	3,H4NM3A+FR6
	WL	3,H4NM3A+FR7

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #4 KNEE FALL

 SUBR	hrt_4_knee_fall_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	3,H2NM3A+FR2
	.word	ANI_OFFSET,23,0,0			;x,y,z

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 15,999,20h,20,90000h,TGT_CHEST,40,74,-10

	.word	ANI_STARTATTACK,AT_KNEE,3
	WL	3,H2NM3A+FR3

	.word	ANI_ATTACK_ON,AMODE_BIGKNEE,11,44,51,49	;mode,x,y,w,h
	WL	3,H2NM3A+FR4
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit
	WL	ANI_SET_YVEL,50000h
	WLW	ANI_SET_ZVEL,-8000h,AM_ABS
	WL	1,H2NM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#cont
#no_hit
	WL	ANI_IFNOTSTATUS,#nodrft
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	WLW	ANI_SET_ZVEL,-4000h,AM_ABS
#nodrft
	WL	1,H2NM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

#cont
	WL	3,H4NM3A+FR5
	WL	3,H4NM3A+FR6
	WL	3,H4NM3A+FR7

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* knee - knee - knee - piledriver

 SUBR	hrt_knees_to_head_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SET_RPTCOUNT,3	;2 times
	.word	ANI_STARTATTACK,AT_HDKNEES,8
	WL	2,H4KM3C+FR1
#rpt
	WL	ANI_SET_YVEL,30000h
	.word	ANI_CLR_BUTCOUNT

	WL	3,H4KM3C+FR2
	WL	2,H4KM3C+FR3

	.word	ANI_ATTACK_ON,AMODE_HEADKNEES,4,34,70,54
	WL	4,H4KM3C+FR4
	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	WL	ANI_IFNOTSTATUS,#missed

	WL	3,H4KM3C+FR6
	WL	3,H4KM3C+FR7

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#exit
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#rpt

	.word	ANI_CLR_BUTCOUNT

	WL	3,H4KM3C+FR2
	WL	2,H4KM3C+FR3

	.word	ANI_ATTACK_ON,AMODE_HEADKNEES,4,54,70,34
	WL	3,H4KM3C+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	WWWL	ANI_IF_BUTCOUNT_GE,SKICKB_COUNT,1,#do_pile

#exit
#missed
	.word	ANI_DETACH
	WL	3,H4KM3C+FR6
	WL	3,H4KM3C+FR7
	WL	3,H4KM3C+FR8
	WL	3,H4KM3C+FR9

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#do_pile
	WL	3,H4KM3C+FR6
	WL	3,H4KM3C+FR7
	WL	3,H4KM3C+FR8
	WL	3,H4KM3C+FR9

	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,hrt_3_pile_driver_anim


#*****************************************************************************
*
* uppercut - uppercut - uppercut - flying kick

 SUBR	hrt_uppercuts_to_head_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.WORD	ANI_ADD_MOVE,MOVE_C_4,2,2

	.word	ANI_SET_RPTCOUNT,3	;2 times
	.word	ANI_CLR_BUTCOUNT

	.word	ANI_OFFSET,5,0,0
	WL	2,H4UP3C+FR1
	.word	ANI_OFFSET,5,0,0
	WL	2,H4UP3C+FR2
	.word	ANI_OFFSET,5,0,0

	WL	2,H4UP3C+FR3
	WL	2,H4UP3C+FR4
	WL	2,H4UP3C+FR5

	.word	ANI_SOUND,43h
	.word	ANI_ATTACK_ON,AMODE_HEADKNEES,-6,22,64,100
	WWL	ANI_WAITHITOPP,3,H4UP3C+FR6
	.word	ANI_ATTACK_OFF
	.word	ANI_ADD_MOVE,MOVE_C_8,2,2
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_CODE,impact_sound
	.word	ANI_SET_ATTACH
	WL	ANI_OPPOFFSET,#release_offsets
	WLLL	ANI_SETOPPVELS,0,38000h,0h		;x,y,z vels
	.word	ANI_DEBRISAT,400,1,10,50,0	;%chance, tbl index, x,y,z off
	.word	ANI_DETACH

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#exit
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#rpt

	WL	ANI_GOTO,#cont

#rpt
	.word	ANI_CLR_BUTCOUNT
	.word	ANI_OFFSET,4,0,0
	WL	2,H4UP3C+FR7
	.word	ANI_OFFSET,4,0,0
	WL	2,H4UP3C+FR8
	.word	ANI_OFFSET,4,0,0
	WL	2,H4UP3C+FR9
	.word	ANI_OFFSET,4,0,0
	WL	2,H4UP3C+FR3
	WL	2,H4UP3C+FR4
	WL	2,H4UP3C+FR5

	.word	ANI_SOUND,43h
	.word	ANI_ATTACK_ON,AMODE_HEADKNEES,-6,22,64,100
	WWL	ANI_WAITHITOPP,3,H4UP3C+FR6
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_CODE,impact_sound
	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,38000h,0h		;x,y,z vels
	.word	ANI_DEBRISAT,250,1,10,50,0	;%chance, tbl index, x,y,z off
;	.word	ANI_DETACH

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#exit
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#rpt

;Completed multiple uppercuts, allow flings, etc.
	.word	ANI_SET_ATTACH
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	.word	ANI_DETACH

#cont
	.word	ANI_CLR_BUTCOUNT
	.word	ANI_STARTATTACK,AT_HDKNEES,10
	WL	2,H4UP3C+FR7
	WL	2,H4UP3C+FR8
	WL	2,H4UP3C+FR9
	WL	2,H4UP3C+FR3
	WL	2,H4UP3C+FR4
	WL	2,H4UP3C+FR5

	.word	ANI_SOUND,43h
	.word	ANI_ATTACK_ON,AMODE_HEADKNEES,6,48,64,64
	WL	2,H4UP3C+FR6
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_CODE,impact_sound
	WL	ANI_CODE,#go_high

	WWWL	ANI_IF_BUTCOUNT_GE,SPUNCHB_COUNT,1,#do_flykick

#missed
#exit
	.word	ANI_DETACH
	WL	2,H4UP3C+FR7
	WL	2,H4UP3C+FR8
	WL	2,H4UP3C+FR9
	WL	2,H4UP3C+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#release_offsets
	;	X Y
	.word	0,30		;Bret
	.word	0,30		;Razor
	.word	0,30		;Taker
	.word	0,30		;Yokozuna
	.word	0,30		;Shawn
	.word	0,30		;BamBam
	.word	0,30		;Doink
	.word	0,30		;Adam
	.word	0,30		;Lex

#do_flykick
	WL	ANI_CODE,CALL_SPECIAL_MOVE
	WL	2,H4UP3C+FR7
	WL	2,H4UP3C+FR8
	WL	2,H4UP3C+FR9
	WL	2,H4UP3C+FR10

	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,hrt_flying_kick2_anim

#go_high
	move	*a13(CLOSEST_NUM),a14
	X32	a14
	addi	process_ptrs,a14
	move	*a14,a14,L

	move	*a14(WRESTLERNUM),a0
	cmpi	3,a0				;Yoko too fat
	jrz	#x

	movi	50000h,a0			;Go higher for last hit!
	move	a0,*a14(OBJ_YVEL),L
#x	rets

#*****************************************************************************
*
* GRAB & FLING OPPONENT (INTO A RUN)

 SUBR	hrt_2_grabfling_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	.word	ANI_STARTATTACK,AT_PUPPET,10
	WL	2,H1TL5A+FR3
	WL	2,H1TL5A+FR4
	WL	ANI_GOTO,#cont

 SUBR	hrt_4_grabfling_anim

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
	WL	5,H3HT3X+FR1

	.word	ANI_ATTACK_ON, AMODE_PUPPET_NOFLAIL,31h,56,44,18 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,6,H3GF7B+FR2
	.word	ANI_ZERO_XZVELS
	WWL	ANI_WAITHITOPP,2,H3GF7B+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missedb
	WL	ANI_IFBLOCKED,#missedb

;got him
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2

	WL	ANI_CODE,DO_GRUNT
	.ref	CALL_SETUP
	WL	ANI_CODE,CALL_SETUP
	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

; attacker sequence
	WWLLW	ANI_SUPERSLAVE2,10,H3GF7B+FR2,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,6,H3GF7B+FR3,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,H3GF7B+FR4,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,H3GF7B+FR5,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,H3GF7B+FR6,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,H3GF7B+FR7,#puppet_tbl,5

	WL	ANI_SLAVEANIM,#strt_run_tbl

	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_DETACH
	WL	6,H3GF7B+FR8
	WL	4,H3GF7B+FR9
	.word	ANI_OFFSET,-10,0,0			;x,y,z

	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#missedb
	.ref	fling_delay
	WL	ANI_CODE,fling_delay
	WL	ANI_IFNOTSTATUS,#missed
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

	.word	7		;speed
	.long	50000h		;z velocity
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


;#*****************************************************************************
;
; SUBR	hrt_leap_test
;
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END



;FIX!!  Make throw out of ring if close to ropes
#*****************************************************************************
*
* FLIP/FALL FROM HIPTOSS

 SUBR	hrt_tossed_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,ckzpos

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_GETUP,STAY_TIME
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
;	.word	ANI_END

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
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_GETUP,STAY_TIME
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
	WL	1,H2CP3A+FR8
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim
;	.word	ANI_END

#*****************************************************************************
*

 SUBR	hrt_knockdwn_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
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

	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	.word	ANI_SETPLYRMODE,MODE_DEAD
	.word	ANI_END

#nodead

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim

#*****************************************************************************
 SUBR	hrt_climbthru_side_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	ANI_CODE,SET_DIR_FACE
	.word	ANI_SETFACING
	.WORD	ANI_SET_WRESTLER_XFLIP

	WLW	ANI_SET_XVEL,3000h,AM_FACE_REL

	.word	ANI_OFFSET,16,0,0
	WL	3,H4CR3D+FR1
	WL	3,H4CR3D+FR2
	.word	ANI_BENDROPE,0
	.word	ANI_OFFSET,3,0,0	;*****
	WL	3,H4CR3D+FR3		
	WL	3,H4CR3D+FR4

	.word	ANI_BENDROPE,2
	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH

	.word	ANI_OFFSET,5,0,0	;*****
	WL	3,H4CR3D+FR5

	.word	ANI_BENDROPE,2

	.word	ANI_OFFSET,4+6,0,0	;*****
	WL	3,H4CR3D+FR8

	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_BENDROPE,3
	.word	ANI_OFFSET,10,0,0	;*****
	WL	3,H4CR3D+FR9
	.word	ANI_ZEROVELS
	.word	ANI_BENDROPE,-1
	.word	ANI_OFFSET,5,0,0	;*****
	WL	3,H4CR3D+FR10
	.word	ANI_OFFSET,10,-3,0
	WL	3,H4CR3D+FR11
	.word	ANI_OFFSET,2,0,0	;*****
	WL	3,H4CR3D+FR12
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH

	;now jump off...
;	WL	3,H4JD4B+FR1 
;	WL	2,H4JD4B+FR2
;	WL	3,H4JD4B+FR3
	WL	2,H4JD4B+FR4
	WL	3,H4JD4B+FR5
	WL	2,H4JD4B+FR6

	.word	ANI_SET_IDIOT

	WWL	ANI_SETLONG,OBJ_GRAVITY,0f000h
	WL	ANI_SET_YVEL,50000h

	WLW	ANI_SET_XVEL,30000h,AM_FACE_REL

	WL	3,H4JD4B+FR7
	.word	ANI_WAITHITGND
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

	.word	ANI_ROPE_Z,R_TOP,RZ_NORM
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM

	.word	ANI_ZEROVELS
	WL	3,H4JD4B+FR8
	WL	2,H4JD4B+FR9
;	WL	2,H4JD4B+FR10
	WL	2,H4JD4B+FR11

	.word	ANI_FACEDOWN
	.word	ANI_CLEAR_CLIMB

	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	hrt_climbin_side_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	ANI_CODE,SET_DIR_FACE
	.word	ANI_SETFACING
	.WORD	ANI_SET_WRESTLER_XFLIP

	;jump in
;	WL	3,H4JD4B+FR1
;	WL	2,H4JD4B+FR2
;	WL	3,H4JD4B+FR3
	WL	2,H4JD4B+FR4
	WL	3,H4JD4B+FR5
	WL	2,H4JD4B+FR6

	WWL	ANI_SETLONG,OBJ_GRAVITY,0f000h
	WL	ANI_CODE,#set_trgt
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	.word	ANI_LEAPATPOS,14h,200,0,0,0	;#ticks,dist,xoff,yoff,zoff

	WL	4,H4JD4B+FR7
	.word	ANI_WAITHITGND
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY
	.word	ANI_ZEROVELS

	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH

	.word	ANI_OFFSET,13,0,0	;*****
	WL	2,H4JD4B+FR8
	WL	2,H4JD4B+FR9
;	WL	2,H4JD4B+FR10
	WL	2,H4JD4B+FR11

	WLW	ANI_SET_XVEL,3000h,AM_FACE_REL

	;climb through
	WL	2,H4CR3D+FR1
	.word	ANI_OFFSET,3,0,0	;*****
	WL	2,H4CR3D+FR2
	.word	ANI_BENDROPE,0
	.word	ANI_OFFSET,3,0,0	;*****
	WL	2,H4CR3D+FR3
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM
	.word	ANI_OFFSET,3,0,0	;*****
	WL	2,H4CR3D+FR4
	.word	ANI_OFFSET,3,0,0	;*****
	WL	2,H4CR3D+FR5

	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH
	.word	ANI_BENDROPE,2
	.word	ANI_OFFSET,5+8,0,0	;*****
	WL	2,H4CR3D+FR8
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM
	.word	ANI_OFFSET,5,0,0	;*****
	WL	2,H4CR3D+FR9
	.word	ANI_OFFSET,5,0,0	;*****
	WL	2,H4CR3D+FR10
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_BENDROPE,-1
	.word	ANI_OFFSET,10,-3,0
	WL	2,H4CR3D+FR11
	WL	2,H4CR3D+FR12
	.word	ANI_ZEROVELS

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

 SUBR	hrt_climbthru_bot_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
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
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOSHADOW|MODE_NOCOLLIS

	.word	ANI_SET_IDIOT

	;climb through
	.WORD	ANI_XFLIP
	WL	ANI_CODE,NOT_IN_RING
	.word	ANI_OFFSET,0,-37h,0			;x,y,z
	WL	3,H4KM3B+FR7
	WL	3,H4KM3B+FR8
	WL	3,H4KM3B+FR9
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

 SUBR	hrt_climbin_bot_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
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

;	WL	ANI_CODE,clr_climb
	.word	ANI_CLEAR_CLIMB

	.word	ANI_FACEDOWN
	.word	ANI_ZEROVELS
	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	hrt_climbthru_top_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
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
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOSHADOW|MODE_NOCOLLIS
	WL	3,H3RL1A+FR1
	WL	3,H3RL1A+FR2
	WL	3,H3RL1A+FR3
	WL	3,H3RL1A+FR4

	.word	ANI_SET_IDIOT

	;climb through
	.word	ANI_OFFSET,0,-61,0
	.word	ANI_ZEROVELS
	WL	3,H3MS3Z+FR4
	WL	3,H3MS3Z+FR3
	WL	3,H3MS3Z+FR2

	.word	ANI_ZERO_XZVELS

	.word	ANI_CLEAR_CLIMB
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

 SUBR	hrt_rollthru_top_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;roll over once
	WLW	ANI_SET_ZVEL,-50000h,AM_ABS
	WL	3,H3RL1A+FR13
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOSHADOW|MODE_NOCOLLIS
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

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END

#*****************************************************************************

 SUBR	hrt_climbin_top_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
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

;	WL	ANI_CODE,clr_climb
	.word	ANI_CLEAR_CLIMB

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

 SUBR	hrt_4_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 29,999,80h,50h,90000h,TGT_CHEST|TGT_GROUND,0,57,-15
	WL	ANI_CODE,hit_nearest

	WL	3,H3PN5A+FR1
	WL	4,H3PN5A+FR2
	WL	4,H3PN5A+FR3
	.word	ANI_OFFSET,0,48,0			;x,y,z
	WL	18,H3PN5A+FR4
;	.word	ANI_WAITHITGND
;	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,-40,-8,0,76,20,30 ;mode,x,y,z,w,h,d
	.word	ANI_ZEROVELS

	WL	5,H3PN5A+FR7

	WL	ANI_CODE,DO_CROWD_CHEER
;	.word	ANI_ATTACK_OFF
	WL	ANI_CODE,grnd_hit
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_BOUNCE,4
	WL	4,H3PN5A+FR8
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE

	WL	4,H3PN5A+FR8
	.ref	win_announce
	WL	ANI_CODE,win_announce
;	.word	ANI_SET_ATTACH
;	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
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

	.word	ANI_SET_RPTCOUNT,3
#lp0	WL	5,H4SL4C+FR4
	WL	5,H4SL4C+FR5
	WL	5,H4SL4C+FR6
	WL	5,H4SL4C+FR5
	WL	5,H4SL4C+FR4
	WL	5,H4SL4C+FR7
	WL	5,H4SL4C+FR8
	WL	5,H4SL4C+FR9
	WL	5,H4SL4C+FR8
	WL	5,H4SL4C+FR7
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#lp0

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
* RAISE ARM IN VICTORY FROM A STANCE

 SUBR	hrt_2_raise_arm_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,DO_CROWD_CHEER
	WL	ANI_CODE,win_announce

	WL	3,H1TL5A+FR3	;2.5
	WL	3,H1TL5A+FR4	;3.5
	WL	ANI_GOTO,#cont

 SUBR	hrt_4_raise_arm_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,DO_CROWD_CHEER
	WL	ANI_CODE,win_announce

#cont	WL	5,H4SL4C+FR1
	WL	5,H4SL4C+FR2
	WL	5,H4SL4C+FR3

	.word	ANI_SET_RPTCOUNT,-4
#lp1	WL	5,H4SL4C+FR4
	WL	5,H4SL4C+FR5
	WL	5,H4SL4C+FR6
	WL	5,H4SL4C+FR5
	WL	5,H4SL4C+FR4
	WL	5,H4SL4C+FR7
	WL	5,H4SL4C+FR8
	WL	5,H4SL4C+FR9
	WL	5,H4SL4C+FR8
	WL	5,H4SL4C+FR7
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#lp1

	WL	ANI_CODE,check_raisearm_bit
	WL	ANI_IFSTATUS,#wakeup

	.word	ANI_SET_RPTCOUNT,1000
	WL	ANI_GOTO,#lp1

#wakeup	WL	5,H4SL4C+FR3
	WL	5,H4SL4C+FR2
	WL	5,H4SL4C+FR1

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_FACEDOWN
	.word	ANI_END


#*****************************************************************************
*
* GET BUCKED OFF A PINNED OPPONENT

 SUBR	hrt_buckoff_anim

	.ref	set_buckoff_vels

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	4,H3PN5A+FR8
	WL	1,H3PN5A+FR4
	WL	ANI_CODE,set_buckoff_vels
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	12,H3PN5A+FR7

	;now stand up
	WL	ANI_SET_YVEL,42000h
	WLW	ANI_SET_ZVEL,22000h,AM_ABS

	WL	3,H3GU4A+FR6
	WL	3,H3GU4A+FR7
	WL	3,H3GU4A+FR8
	WL	3,H3GU4A+FR9
	WL	3,H3GU4A+FR10

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS


	.word	ANI_FACEDOWN

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************

	.end
