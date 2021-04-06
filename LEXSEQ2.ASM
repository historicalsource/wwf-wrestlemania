**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		7/15/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"lexseq2.asm"
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
	.include	"leximg.h"
	.include	"damage.equ"

	.INCLUDE	"SWEAT.EQU"

******************************************************************************
* EXTERNAL REFERENCES

	.ref	DO_CROWD_CHEER,set_tbukl_confine,grnd_hit,check_raisearm_bit
	.ref	SET_DIR_FACE,no_bk_xvel,start_run_anim,CALL_MISSES
	.ref	am_I_dead,lex_faceup_getup_anim,lex_dizzy_anim
	.ref	check_xvel,DO_GRUNT,HIT_THE_MAT,SMALL_BOUNCE
	.ref	CALL_ANI_AVERAGE_MOVE,set_tbukl_airmode
	.ref	DO_COMBO_MESS,hit_nearest
	.ref	lex_combo_sliding_elbow_anim
	.ref	lex_combo_hiptoss_anim
	.ref	lex_combo_backbreak_anim
	.REF	CALL_BONE_BREAK

#*****************************************************************************
*
* #2 COMBO PUNCH

 SUBR	lex_combo_punch_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	.WORD	ANI_CLEAR_COMBO

	WL	2,L2PU2B+FR1
	.word	ANI_STARTATTACK,AT_PUNCH,6
	WL	2,L2PU2B+FR2
	WL	2,L2PU2B+FR3
	.WORD	ANI_INC_COMBO
	.word	ANI_ATTACK_ON,AMODE_PUNCH,28,52,44,44
	WL	2,L2PU2B+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_hit2
	.WORD	ANI_INC_COMBO

	WL	ANI_SET_YVEL,30000h
	WL	2,L2PU2B+FR4
	WL	2,L2PU2B+FR5
	WL	2,L2PU2B+FR7
	WL	2,L2PU2B+FR8
	WL	2,L2PU2B+FR9
	WL	2,L4PU3B+FR1
	.word	ANI_STARTATTACK,AT_PUNCH,6
	WL	2,L4PU3B+FR2
	WL	2,L4PU3B+FR3

	.word	ANI_ATTACK_ON,AMODE_PUNCH,28,52,44,44
	WL	2,L4PU3B+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_hit4
	.WORD	ANI_INC_COMBO
	WL	ANI_SET_YVEL,30000h
	WL	2,L4PU3B+FR4
	WL	2,L4PU3B+FR5
	WL	2,L4PU3B+FR6
	WL	2,L4PU3B+FR8
	WL	2,L4PU3B+FR9

	.word	ANI_SET_RPTCOUNT,2	;3 times
#punch_loop
	.word	ANI_CLR_BUTCOUNT
	WL	1,L2PU2B+FR1
	WL	1,L2PU2B+FR2
	WL	1,L2PU2B+FR3
	.word	ANI_ATTACK_ON,AMODE_PUNCH,28,82,44,24
	WL	2,L2PU2B+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_hit2
	.WORD	ANI_INC_COMBO

	WL	ANI_SET_YVEL,18000h
	WL	1,L2PU2B+FR4
	WL	2,L2PU2B+FR5
	WL	1,L2PU2B+FR7
	WL	1,L2PU2B+FR8
	WL	1,L2PU2B+FR9

	WL	1,L4PU3B+FR1
	.word	ANI_STARTATTACK,AT_PUNCH,6
	WL	2,L4PU3B+FR2
	WL	1,L4PU3B+FR3

	.word	ANI_ATTACK_ON,AMODE_PUNCH,28,82,44,24
	WL	2,L4PU3B+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_hit4
	.WORD	ANI_INC_COMBO
	WL	ANI_SET_YVEL,18000h
	WL	1,L4PU3B+FR4
	
	WL	2,L4PU3B+FR5
	WL	1,L4PU3B+FR6
	WL	1,L4PU3B+FR8
	WL	1,L4PU3B+FR9
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#punch_loop

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#no_clobber
	WL	ANI_CHANGEANIM,lex_combo_clobber_anim
#no_clobber
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#no_knee
	WL	ANI_CHANGEANIM,lex_combo_knee_fall_anim
#no_knee
	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#exit
	WL	ANI_CHANGEANIM,lex_combo_butt_anim
#exit
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#no_hit4
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	3,L4PU3B+FR5
	WL	3,L4PU3B+FR6
	WL	3,L4PU3B+FR8
	WL	3,L4PU3B+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#no_hit2
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	3,L2PU2B+FR5
	WL	3,L2PU2B+FR7
	WL	3,L2PU2B+FR8
	WL	3,L2PU2B+FR9
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 NORMAL PUNCH

 SUBR	lex_2_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L2PU2B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L2PU2B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L2PU2B+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_PUNCH,6
	WL	1,L2PU2B+FR2
	WL	2,L2PU2B+FR3
	.word	ANI_ATTACK_ON,AMODE_PUNCH,28,82,44,24
	WL	3,L2PU2B+FR4
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit

	WL	ANI_SET_YVEL,30000h
	WL	3,L2PU2B+FR4
#no_hit
	WL	3,L2PU2B+FR5
	WL	2,L2PU2B+FR7
	WL	3,L2PU2B+FR8
	WL	2,L2PU2B+FR9


	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 NORMAL PUNCH

 SUBR	lex_4_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L4PU3B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L4PU3B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L4PU3B+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_PUNCH,6
	WL	1,L4PU3B+FR2
	WL	2,L4PU3B+FR3

	.word	ANI_ATTACK_ON,AMODE_PUNCH,28,82,44,24
	WL	3,L4PU3B+FR4
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2
	WL	ANI_SET_YVEL,30000h
	WL	3,L4PU3B+FR4
	
#no_hit2
	WL	3,L4PU3B+FR5
	WL	2,L4PU3B+FR6
	WL	3,L4PU3B+FR8
	WL	2,L4PU3B+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 PUSH

 SUBR	lex_4_push_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WL	ANI_SETFLAG,M_PUSH
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUSH,9
	WL	3,L4PS3A+FR1
	WL	3,L4PS3A+FR2
	WL	3,L4PS3A+FR3
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ATTACK_ON, AMODE_PUSH,11,47,91,50 ;mode,x,y,w,h
	WL	3,L4PS3A+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,40h,-70000h,#no_hit	;range,vel,addr
	WL	15,L4PS3A+FR4
#no_hit
	WL	3,L4PS3A+FR4

	WL	ANI_IFSTATUS,#hit
;If missed on push, hold a little longer
	WL	5,L4PS3A+FR4
#hit
	WL	3,L4PS3A+FR3
	WL	3,L4PS3A+FR2
	WL	3,L4PS3A+FR1

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************
*
* #4 LOSE BALANCE

 SUBR	lex_4_losebal_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_FRICTION,3000h
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WLW	ANI_SET_XVEL,-60000h,AM_HIT_REL
  
	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,L3PB3A+FR3
	WL	3,L3PB3A+FR4
	.REF	DO_LEX_PUSH
	WL	ANI_CODE,DO_LEX_PUSH
	WL	3,L3PB3A+FR5
	WL	3,L3PB3A+FR6
	WL	3,L3PB3A+FR7
	WL	3,L3PB3A+FR8
	WL	3,L3PB3A+FR9

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 combo FALLEN OPPONENT

 SUBR	lex_combo_ground_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	3,L2PT2B+FR1
	WL	3,L2PT2B+FR2

	;if we're going to miss, do a leapat
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,-4,-6,-40,37,36,50
	WL	1,L2PT2B+FR2
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#leapat_stomp

	WL	ANI_SET_YVEL,80000h

	.word	ANI_SET_RPTCOUNT,3	;5 times
#ground_loop
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
	.word	ANI_INC_COMBO
	.word	ANI_IMMOBILIZE,75
	.word	ANI_SHAKER,18
	.word	ANI_SHAKEALL,1
	WL	5,L2PT2B+FR8
	WL	2,L2PT2B+FR9
	WL	2,L2PT2B+FR10
	WL	2,L2PT2B+FR11

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IFNOT_RPTCOUNT,#exit_ground
	WL	ANI_SET_YVEL,20000h
	WL	ANI_GOTO,#ground_loop

#exit_ground

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_CODE,CALL_MISSES

	WL	7,L2PT2B+FR8
	WL	3,L2PT2B+FR9
	WL	3,L2PT2B+FR10
	WL	3,L2PT2B+FR11

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

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L2PT2B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L2PT2B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L2PT2B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_LBDROP,11
	WL	3,L2PT2B+FR2

	;if we're going to miss, do a leapat
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,-4,-6,-40,37,36,50
	WL	1,L2PT2B+FR2
	.word	ANI_ATTACK_OFF

	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	WL	ANI_IFNOTSTATUS,#leapat_stomp

	WL	ANI_SET_YVEL,20000h

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

#leapat_stomp
	;too far.  leap at the chest.
	.word	ANI_TARGET,TGT_CHEST,TGT_KNEES,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,160,140,90000h,TGT_USER,13,0,-40
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
	.word	ANI_SHAKER,25
	.word	ANI_SHAKEALL,1
	WL	3,L2PT2B+FR8
	WL	3,L2PT2B+FR9
	WL	3,L2PT2B+FR10
	WL	3,L2PT2B+FR11

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES

	WL	3,L2PT2B+FR8
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

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L4PT4B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L4PT4B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L4PT4B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_STOMP,18
	WL	3,L4PT4B+FR2
	WL	2,L4PT4B+FR3

	;if we're going to miss, do a leapat
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,-3,-1,-10,29,28,50
	WL	1,L4PT4B+FR3
	.word	ANI_ATTACK_OFF

	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
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
	LEAPATOPP 16,999,160,140,90000h,TGT_USER,15,0,50
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

	WL	3,L4PT4B+FR8
	WL	3,L4PT4B+FR9
	WL	3,L4PT4B+FR10
	WL	3,L4PT4B+FR11

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES

	WL	3,L4PT4B+FR8
	WL	3,L4PT4B+FR9
	WL	3,L4PT4B+FR10
	WL	3,L4PT4B+FR11

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #3 CLOBBER - Super punch / same as slap

 SUBR	lex_3_clobber_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	.word	ANI_STARTATTACK,AT_PUNCH,18
	WL	3,L4PT3B+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 13,999,50h,50,90000h,TGT_HEAD,75,101,0
	WL	ANI_CODE,no_bk_xvel

	WL	3,L4PT3B+FR2
	WL	9,L4PT3B+FR3
	WL	3,L4PT3B+FR4

	WL	ANI_CODE,#stop_debris
	.word	ANI_ATTACK_ON, AMODE_URN,31,63,56,38	;mode,x,y,w,h
	WL	3,L4PT3B+FR5
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#blocked

	WL	ANI_CODE,#restore_debris
	.ref	create_impact
	WL	ANI_CODE,create_impact
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE

	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,1

	WL	3,L4PT3B+FR6
	WL	ANI_CODE,CALL_BONE_BREAK
;	.word	ANI_SOUND,9Bh			;neck break (5-7 ticks late)
	WL	5,L4PT3B+FR7


	.ref	spunch_delay
	WL	ANI_CODE,spunch_delay
	WL	ANI_IFNOTSTATUS,#none0
	WL	15,L4PT3B+FR7
#none0


	WL	3,L4PT3B+FR8

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
#blocked
	WL	ANI_CODE,#restore_debris
	WL	3,L4PT3B+FR6
	WL	10,L4PT3B+FR7

	WL	ANI_CODE,spunch_delay
	WL	ANI_IFNOTSTATUS,#none
	WL	15,L4PT3B+FR7
#none
	WL	3,L4PT3B+FR8

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


******************************************************************

 SUBR	lex_combo_clobber_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	.word	ANI_STARTATTACK,AT_PUNCH,18
	WL	3,L4PT3B+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 13,999,50h,50,90000h,TGT_HEAD,75,101,0
	WL	ANI_CODE,no_bk_xvel

	WL	3,L4PT3B+FR2
	WL	9,L4PT3B+FR3
	WL	3,L4PT3B+FR4

	WL	ANI_CODE,#stop_debris
	.word	ANI_ATTACK_ON, AMODE_BIGKNEE,31,63,56,38	;mode,x,y,w,h
	WL	3,L4PT3B+FR5
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

	WL	ANI_IFNOTSTATUS,#missedc
	WL	ANI_IFBLOCKED,#blockedc
	.WORD	ANI_INC_COMBO

	WL	ANI_CODE,#restore_debris
	.ref	create_impact
	WL	ANI_CODE,create_impact
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,1

	WL	3,L4PT3B+FR6
	WL	ANI_CODE,CALL_BONE_BREAK
;	.word	ANI_SOUND,9Bh			;neck break (5-7 ticks late)
	WL	5,L4PT3B+FR7
	WL	3,L4PT3B+FR8

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedc
	WL	ANI_CODE,CALL_MISSES
#blockedc
	WL	ANI_CODE,#restore_debris
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	3,L4PT3B+FR6
	WL	10,L4PT3B+FR7
	WL	3,L4PT3B+FR8

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END
******************************************************************

	.bss	#kp_debris,16
	.ref	no_debris

#stop_debris
	move	@no_debris,a0
	move	a0,@#kp_debris
	movk	1,a0
	move	a0,@no_debris
	rets

#restore_debris
	move	@#kp_debris,a0
	move	a0,@no_debris
	rets

#*
* #4 HAMMER POUND OF FALLEN OPPONENT

 SUBR	lex_hammer_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	.word	ANI_CLR_BUTCOUNT
	.word	ANI_STARTATTACK,AT_HAMMER1,12
	.word	ANI_SET_RPTCOUNT,4	;5 times

;	.ref	create_bucket_salt

;	WL	ANI_CODE,create_bucket_salt
;	WWL	ANI_SETLONG,DEBRIS_X,[115,-6]	;Y,X of head
;	WL	3,L4HM3A+FR1
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 7,170,60,50,90000h,TGT_GROIN,95,62,13h	;13

	WL	ANI_SET_YVEL,34000h

;	WWL	ANI_SETLONG,DEBRIS_X,[81,-25]	;Y,X of head
	WL	3,L4HM3A+FR2
;	WWL	ANI_SETLONG,DEBRIS_X,[84,-23]	;Y,X of head
	WL	3,L4HM3A+FR3	;16
;	WWL	ANI_SETLONG,DEBRIS_X,[99,-24]	;Y,X of head
	WL	3,L4HM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
;	WWL	ANI_SETLONG,DEBRIS_X,[143,3]	;Y,X of head
	WL	3,L4HM3A+FR5
;	WWL	ANI_SETLONG,DEBRIS_X,[122,79]	;Y,X of head
	WL	2,L4HM3A+FR6
	.word	ANI_ATTACK_ON,AMODE_HAMMER,32,-8,92,146 ;mode,x,y,w,h
;	WWL	ANI_SETLONG,DEBRIS_X,[64,101]	;Y,X of head
	WL	2,L4HM3A+FR6
;	WWL	ANI_SETLONG,DEBRIS_X,[5,90]	;Y,X of head
	WL	3,L4HM3A+FR7
	.word	ANI_ATTACK_OFF

	.WORD	ANI_ADD_MOVE,MOVE_C_2,2,2
	WL	ANI_IFNOTSTATUS,#tagmiss
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker
;He got him, shake screen
	.word	ANI_DAMAGEOPP,D_HAMMER1,RD_HAMMER1
;	.word	ANI_DRAW_NAME,25

;Immobilize player for 30 ticks without meter on!
	.word	ANI_IMMOBILIZE,30
	.word	ANI_SHAKER,45

	.ref	CALL_NASTY_MOVE
	WL	ANI_CODE,CALL_NASTY_MOVE
	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#missedb
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#dnk_quick_hammer

#missedb
#tagmiss

;	WWL	ANI_SETLONG,DEBRIS_X,[6,83]	;Y,X of head
	WL	3,L4HM3A+FR8
;	WWL	ANI_SETLONG,DEBRIS_X,[35,74]	;Y,X of head
	WL	3,L4HM3A+FR9
;	WWL	ANI_SETLONG,DEBRIS_X,0		;Y,X of head

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#dnk_quick_hammer
	.word	ANI_CLR_BUTCOUNT
	.word	ANI_STARTATTACK,AT_HAMMER1,27
;	WWL	ANI_SETLONG,DEBRIS_X,[19,28]	;Y,X of head
   	WL	3,L4HM3A+FR8
;	WWL	ANI_SETLONG,DEBRIS_X,[19,28]	;Y,X of head
	WL	3,L4HM3A+FR9
;	WWL	ANI_SETLONG,DEBRIS_X,[19,28]	;Y,X of head
	WL	3,L4PT3B+FR1
;	WWL	ANI_SETLONG,DEBRIS_X,[19,28]	;Y,X of head
;	WL	3,L4HM3A+FR1
;	WWL	ANI_SETLONG,DEBRIS_X,[19,28]	;Y,X of head
	WL	3,L4HM3A+FR2
;	WWL	ANI_SETLONG,DEBRIS_X,[19,28]	;Y,X of head
	WL	3,L4HM3A+FR3
;	WWL	ANI_SETLONG,DEBRIS_X,[19,28]	;Y,X of head
	WL	3,L4HM3A+FR4
;	WWL	ANI_SETLONG,DEBRIS_X,[19,28]	;Y,X of head
	WL	3,L4HM3A+FR5
;	WWL	ANI_SETLONG,DEBRIS_X,[19,28]	;Y,X of head
	WL	1,L4HM3A+FR6
	.word	ANI_ATTACK_ON,AMODE_HAMMER,32,-8,92,73 ;mode,x,y,w,h
	WL	2,L4HM3A+FR6
;	WWL	ANI_SETLONG,DEBRIS_X,[19,28]	;Y,X of head
	WL	3,L4HM3A+FR7
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#tagmiss
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

;Immobilize player for 30 ticks without meter on!
	.word	ANI_IMMOBILIZE,30

	.word	ANI_SHAKER,45

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,2,#failed
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#dnk_quick_hammer
#failed

;	WWL	ANI_SETLONG,DEBRIS_X,[19,28]	;Y,X of head
	WL	3,L4HM3A+FR8
;	WWL	ANI_SETLONG,DEBRIS_X,[19,28]	;Y,X of head
	WL	3,L4HM3A+FR9
;	WWL	ANI_SETLONG,DEBRIS_X,0		;Y,X of head

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#***********************************************

 SUBR	lex_combo_hammer_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	.word	ANI_CLR_BUTCOUNT
	.word	ANI_STARTATTACK,AT_HAMMER1,12
	.word	ANI_SET_RPTCOUNT,4	;5 times

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 7,170,60,30,90000h,TGT_GROIN,95,62,0;13h	;13

	WL	ANI_SET_YVEL,34000h

	WL	3,L4HM3A+FR2
	WL	3,L4HM3A+FR3	;16
	WL	3,L4HM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,L4HM3A+FR5
	WL	2,L4HM3A+FR6
	.word	ANI_ATTACK_ON, AMODE_HAMMER,21,-10,88,73 ;mode,x,y,w,h
	WL	2,L4HM3A+FR6
	WL	3,L4HM3A+FR7
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#tagmiss
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker
;He got him, shake screen
	.WORD	ANI_INC_COMBO
	.word	ANI_DAMAGEOPP,D_HAMMER1,RD_HAMMER1

;Immobilize player for 30 ticks without meter on!
	.word	ANI_IMMOBILIZE,30
	.word	ANI_SHAKER,25

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#missedb
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#dnk_quick_hammer

#missedb
#tagmiss

	WL	3,L4HM3A+FR8
	WL	3,L4HM3A+FR9

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#dnk_quick_hammer
	.word	ANI_CLR_BUTCOUNT
	.word	ANI_STARTATTACK,AT_HAMMER1,27
   	WL	2,L4HM3A+FR8
	WL	2,L4HM3A+FR9
	WL	2,L4PT3B+FR1
	WL	2,L4HM3A+FR2
	WL	2,L4HM3A+FR3
	WL	2,L4HM3A+FR4
	WL	2,L4HM3A+FR5
	WL	1,L4HM3A+FR6
	.word	ANI_ATTACK_ON, AMODE_HAMMER,21,-10,88,73 ;mode,x,y,w,h
	WL	1,L4HM3A+FR6
	WL	2,L4HM3A+FR7
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#tagmiss
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker
	.WORD	ANI_INC_COMBO

;Immobilize player for 30 ticks without meter on!
	.word	ANI_IMMOBILIZE,30

	.word	ANI_SHAKER,25

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,2,#failed
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#dnk_quick_hammer
#failed

	WL	3,L4HM3A+FR8
	WL	3,L4HM3A+FR9

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 CLOBBER (same art as #2 punch fallen, except for the puffin)

 SUBR	lex_2_clobber_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	.word	ANI_STARTATTACK,AT_PUNCH,18
	WL	2,L2PT2B+FR1
	WL	2,L2PT2B+FR2

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 11,999,112,96,90000h,TGT_CHEST|TGT_GROUND,28,0,-30
	WL	ANI_CODE,no_bk_xvel

	WL	3,L2PT2B+FR3

	;18 ticks is too long to wait for a hit box, so we check for
	; a hit at 9, and if we get one, we freeze the victim so we'll
	; hit at 18.
;	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,4,12,-40,30,94,50
;	WL	1,L2PT2B+FR4
;	.word	ANI_ATTACK_OFF
;	WL	ANI_IFBLOCKED,#no_freeze
;	WL	ANI_IFNOTSTATUS,#no_freeze
;	.word	ANI_IMMOBILIZE,9
;#no_freeze
	WL	2,L2PT2B+FR4
	WL	2,L2PT2B+FR5
	WL	2,L2PT2B+FR6
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
;	.word	ANI_IMMOBILIZE,55-11-10
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP2,4,12,-40,30,94,50
	WL	1,L2PT2B+FR7
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	WL	ANI_IFBLOCKED,#blocked

	.word	ANI_IMMOBILIZE,55-11-10

	.word	ANI_OFFSET,0,0,10
	.word	ANI_SHAKER,40
	.word	ANI_SHAKEALL,1

	WL	2,L2PT2B+FR7
	WL	ANI_CODE,CALL_BONE_BREAK
;	.word	ANI_SOUND,9Bh			;neck break (5-7 ticks late)
	WL	8,L2PT2B+FR8
	WL	2,L2PT2B+FR9
	WL	2,L2PT2B+FR10
	WL	2,L2PT2B+FR11

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
#blocked
	WL	2,L2PT2B+FR7
	WL	6,L2PT2B+FR8
	WL	2,L2PT2B+FR9
	WL	2,L2PT2B+FR10
	WL	2,L2PT2B+FR11

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #4 CLOBBER (same art as #4 punch fallen)

 SUBR	lex_4_clobber_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUNCH,21
	WL	2,L4PT4B+FR1
	WL	2,L4PT4B+FR2

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 11,999,112,96,90000h,TGT_CHEST|TGT_GROUND,24,0,30
	WL	ANI_CODE,no_bk_xvel

	WL	3,L4PT4B+FR3

	;18 ticks is too long to wait for a hit box, so we check for
	; a hit at 9, and if we get one, we freeze the victim so we'll
	; hit at 18.
;	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,4,12,-10,30,94,50
;	WL	1,L4PT4B+FR4
;	.word	ANI_ATTACK_OFF
;	WL	ANI_IFBLOCKED,#no_freeze
;	WL	ANI_IFNOTSTATUS,#no_freeze
;	.word	ANI_IMMOBILIZE,9
;#no_freeze
	WL	2,L4PT4B+FR4
	WL	2,L4PT4B+FR5
	WL	2,L4PT4B+FR6
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
;	.word	ANI_IMMOBILIZE,55-11-10
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP2,4,12,-10,30,94,50
	WL	1,L4PT4B+FR7
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	WL	ANI_IFBLOCKED,#blocked

	.word	ANI_IMMOBILIZE,55-11-10

	.word	ANI_OFFSET,0,0,-10
	.word	ANI_SHAKER,40
	.word	ANI_SHAKEALL,1

	WL	2,L4PT4B+FR7
	WL	ANI_CODE,CALL_BONE_BREAK
;	.word	ANI_SOUND,9Bh			;neck break (5-7 ticks late)
	WL	8,L4PT4B+FR8
	WL	2,L4PT4B+FR9
	WL	2,L4PT4B+FR10
	WL	2,L4PT4B+FR11

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
#blocked
	WL	2,L4PT4B+FR7
	WL	6,L4PT4B+FR8
	WL	2,L4PT4B+FR9
	WL	2,L4PT4B+FR10
	WL	2,L4PT4B+FR11

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #combo CLOBBER (same art as #4 punch fallen)


 SUBR	lex_combo_ground_clobber_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUNCH,21
	WL	3,L4PT4B+FR1
	WL	3,L4PT4B+FR2

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 12,999,112,96,90000h,TGT_CHEST|TGT_GROUND,24,0,30
	WL	ANI_CODE,no_bk_xvel

	WL	3,L4PT4B+FR3

	;18 ticks is too long to wait for a hit box, so we check for
	; a hit at 9, and if we get one, we freeze the victim so we'll
	; hit at 18.
	.word	ANI_SET_RPTCOUNT,3	;5 times
#ground_clobber_loop
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,4,2,-10,30,100,50
	WL	1,L4PT4B+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFBLOCKED,#no_freeze
	WL	ANI_IFNOTSTATUS,#no_freeze
	.word	ANI_IMMOBILIZE,9
#no_freeze
	WL	2,L4PT4B+FR4
	WL	3,L4PT4B+FR5
	WL	3,L4PT4B+FR6
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_IMMOBILIZE,55-11
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP2,4,2,-10,30,100,50
	WL	1,L4PT4B+FR7
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#blocked
	.word	ANI_INC_COMBO
	.word	ANI_OFFSET,0,0,-10
	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,1

	WL	2,L4PT4B+FR7
	WL	ANI_CODE,CALL_BONE_BREAK
;	.word	ANI_SOUND,9Bh			;neck break (5-7 ticks late)
	WL	8,L4PT4B+FR8
	WL	4,L4PT4B+FR9
	WL	4,L4PT4B+FR10
	WL	4,L4PT4B+FR11
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#ground_clobber_loop

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
#blocked
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	2,L4PT4B+FR7
	WL	8,L4PT4B+FR8
	WL	3,L4PT4B+FR9
	WL	3,L4PT4B+FR10
	WL	3,L4PT4B+FR11

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 HEADBUTT

 SUBR	lex_2_butt_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L2BC3E+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L2BC3E+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L2BC3E+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	WL	1,L2BC3E+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_HDBUTT,2
	WL	2,L2BC3E+FR4
	.word	ANI_ATTACK_ON, AMODE_HDBUTT,8,85,30,18	;mode,x,y,w,h
	WL	3,L2BC3E+FR5
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit

	WL	ANI_SET_YVEL,38000h
	WL	6,L2BC3E+FR5
#no_hit

	WL	3,L2BC3E+FR5
	WL	3,L2BC3E+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 HEADBUTT

 SUBR	lex_2_butts_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SET_RPTCOUNT,3	;5 times
	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
#rpt
	.word	ANI_CLR_BUTCOUNT

	.word	ANI_STARTATTACK,AT_HDBUTT,6
	WL	2,L2BC3E+FR3
	WL	2,L2BC3E+FR4
	.word	ANI_ATTACK_ON, AMODE_HDBUTT_STAY,8,85,35,18	;mode,x,y,w,h
	WL	2,L2BC3E+FR5
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit

	WL	ANI_SET_YVEL,38000h
	WL	6,L2BC3E+FR5
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

	WL	3,L2BC3E+FR5
	WL	3,L2BC3E+FR6

	WL	ANI_IF_RPTCOUNT,#rpt
	WL	ANI_CHANGEANIM,lex_2_butt_anim

#ex
	WLLL	ANI_SETOPPVELS,40000h,38000h,0h		;x,y,z vels
	WL	3,L2BC3E+FR5
	WL	3,L2BC3E+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WLLL	ANI_SETOPPVELS,50000h,18000h,0h		;x,y,z vels
#missed
	WL	2,L2BC3E+FR5
	WL	2,L2BC3E+FR6

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #COMBO HEADBUTT

 SUBR	lex_combo_butt_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WLW	ANI_SET_XVEL,30000h,AM_FACE_REL
	WL	2,L4BC3D+FR1
	WL	1,L4BC3D+FR3
	WL	1,L4BC3D+FR3
	WL	2,L4BC3D+FR4
	.word	ANI_ATTACK_ON, AMODE_HDBUTT,8,55,50,38	;mode,x,y,w,h
	WL	1,L4BC3D+FR5
	WLW	ANI_SET_XVEL,0000h,AM_FACE_REL
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_hit
	.WORD	ANI_INC_COMBO
	WLLL	ANI_SETOPPVELS,0000H,10000h,0h		;x,y,z vels

	WL	ANI_SET_YVEL,20000h
	WL	6,L4BC3D+FR5
	WL	4,L4BC3D+FR5
	WL	4,L4BC3D+FR6

	.word	ANI_SET_RPTCOUNT,3	;3 times
#butt_loop
	.word	ANI_CLR_BUTCOUNT
	WL	1,L4BC3D+FR1
	WL	1,L4BC3D+FR3
	WL	1,L4BC3D+FR3
	WL	1,L4BC3D+FR4
	.word	ANI_ATTACK_ON, AMODE_HDBUTT,8,55,50,38	;mode,x,y,w,h
	WL	1,L4BC3D+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_hit
	.WORD	ANI_INC_COMBO
	WLLL	ANI_SETOPPVELS,0000H,10000h,0h		;x,y,z vels

	WL	ANI_SET_YVEL,20000h
	WL	3,L4BC3D+FR5
	WL	2,L4BC3D+FR5
	WL	2,L4BC3D+FR6
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#butt_loop

	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#no_clobber
	WL	ANI_CHANGEANIM,lex_combo_clobber_anim

#no_clobber
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#no_back
	WL	ANI_CHANGEANIM,lex_combo_backbreak_anim

#no_back
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#exit
	WL	ANI_CHANGEANIM,lex_combo_hiptoss_anim
 
#exit
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#no_hit
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	4,L4BC3D+FR5
	WL	4,L4BC3D+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 HEADBUTT

 SUBR	lex_4_butt_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L4BC3D+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L4BC3D+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L4BC3D+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_HDBUTT,2
	WL	2,L4BC3D+FR4
	.word	ANI_ATTACK_ON, AMODE_HDBUTT,8,85,30,18	;mode,x,y,w,h
	WL	3,L4BC3D+FR5
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit

	WL	ANI_SET_YVEL,38000h
	WL	6,L4BC3D+FR5
#no_hit
	WL	3,L4BC3D+FR5
	WL	3,L4BC3D+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 HEADBUTT

 SUBR	lex_4_butts_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SET_RPTCOUNT,3	;5 times
	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
#rpt
	.word	ANI_CLR_BUTCOUNT

	.word	ANI_STARTATTACK,AT_HDBUTT,6
	WL	2,L4BC3D+FR3
	WL	2,L4BC3D+FR4
	.word	ANI_ATTACK_ON, AMODE_HDBUTT_STAY,8,85,30,18	;mode,x,y,w,h
	WL	2,L4BC3D+FR5
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit

	WL	ANI_SET_YVEL,38000h
	WL	6,L4BC3D+FR5
#no_hit
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

	.word	ANI_SET_ATTACH
	.word	ANI_DEBRISAT,200,2,0,100,0	;%chance, tbl index, x,y,z off
	WL	ANI_CODE,impact_sound
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,25
	.word	ANI_DETACH

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#ex
	.word	ANI_DEC_RPTCOUNT

	WL	3,L4BC3D+FR5
	WL	3,L4BC3D+FR6

	WL	ANI_IF_RPTCOUNT,#rpt

	WL	ANI_CHANGEANIM,lex_4_butt_anim
#ex
	WLLL	ANI_SETOPPVELS,40000h,38000h,0h		;x,y,z vels

	WL	2,L4BC3D+FR5
	WL	2,L4BC3D+FR6
   
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WLLL	ANI_SETOPPVELS,50000h,18000h,0h		;x,y,z vels
#missed
	WL	2,L4BC3D+FR5
	WL	2,L4BC3D+FR6

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #COMBO KICK
 SUBR	lex_combo_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	.WORD	ANI_CLEAR_COMBO

	WL	2,L2KM3A+FR1
	WL	1,L2KM3A+FR2
	WL	2,L2KM3A+FR2
	WL	2,L2KM3A+FR3
	WL	2,L2KM3A+FR4
	.WORD	ANI_INC_COMBO
	.word	ANI_ATTACK_ON, AMODE_KICK,27,39,68,40	;mode,x,y,w,h
	WL	1,L2KM3A+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_hit2
	WLLL	ANI_SETOPPVELS,0000H,10000h,0h		;x,y,z vels

	.WORD	ANI_INC_COMBO
	WL	ANI_SET_YVEL,30000h
	WL	3,L2KM3A+FR5
	
	WL	3,L2KM3A+FR5
	WL	2,L2KM3A+FR6
	WL	2,L2KM3A+FR7
	WL	3,L2KM3A+FR8
	WL	3,L2KM3A+FR9

	WL	2,L4KM3B+FR1
	WL	1,L4KM3B+FR2
	WL	2,L4KM3B+FR2
	WL	2,L4KM3B+FR3
	WL	2,L4KM3B+FR4
	.word	ANI_ATTACK_ON, AMODE_KICK,27,39,68,40	;mode,x,y,w,h
	WL	1,L4KM3B+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_hit4
	WLLL	ANI_SETOPPVELS,0000H,10000h,0h		;x,y,z vels

	.WORD	ANI_INC_COMBO
	WL	ANI_SET_YVEL,30000h
	WL	3,L4KM3B+FR5
	WL	3,L4KM3B+FR5
	WL	2,L4KM3B+FR6
	WL	2,L4KM3B+FR7
	WL	3,L4KM3B+FR8
	WL	3,L4KM3B+FR9

	.word	ANI_SET_RPTCOUNT,2	;3 times
#kick_loop
	.word	ANI_CLR_BUTCOUNT
	WL	1,L2KM3A+FR2
	WL	1,L2KM3A+FR3
	WL	1,L2KM3A+FR4
	.word	ANI_ATTACK_ON, AMODE_KICK,27,39,68,40	;mode,x,y,w,h
	WL	1,L2KM3A+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_hit2
	WLLL	ANI_SETOPPVELS,0000H,30000h,0h		;x,y,z vels

	.WORD	ANI_INC_COMBO
	WL	ANI_SET_YVEL,38000h
	WL	1,L2KM3A+FR5
	
	WL	2,L2KM3A+FR5
	WL	1,L2KM3A+FR6
	WL	1,L2KM3A+FR7
	WL	2,L2KM3A+FR8
	WL	1,L2KM3A+FR9

	WL	1,L4KM3B+FR2
	WL	1,L4KM3B+FR3
	WL	1,L4KM3B+FR4
	.word	ANI_ATTACK_ON, AMODE_KICK,27,39,68,40	;mode,x,y,w,h
	WL	1,L4KM3B+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_hit4
	WLLL	ANI_SETOPPVELS,0000H,30000h,0h		;x,y,z vels

	.WORD	ANI_INC_COMBO
	WL	ANI_SET_YVEL,38000h
	WL	1,L4KM3B+FR5
	WL	2,L4KM3B+FR5
	WL	1,L4KM3B+FR6
	WL	1,L4KM3B+FR7
	WL	2,L4KM3B+FR8
	WL	1,L4KM3B+FR9
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#kick_loop

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#no_clobber
	WL	ANI_CHANGEANIM,lex_combo_clobber_anim
#no_clobber
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#no_knee
	WL	ANI_CHANGEANIM,lex_combo_knee_fall_anim
#no_knee
	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#no_hit4
	WL	ANI_CHANGEANIM,lex_combo_sliding_elbow_anim
#no_hit4
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	3,L4KM3B+FR5
	WL	2,L4KM3B+FR6
	WL	2,L4KM3B+FR7
	WL	3,L4KM3B+FR8
	WL	3,L4KM3B+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#no_hit2
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	3,L2KM3A+FR5
	WL	2,L2KM3A+FR6
	WL	2,L2KM3A+FR7
	WL	3,L2KM3A+FR8
	WL	3,L2KM3A+FR9
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 KICK - Against TB attacks

 SUBR	lex_kick_TB_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETPLYRMODE,MODE_INAIR2
	.word	ANI_STARTATTACK,AT_LEAPING,12

	WL	2,L2KM3A+FR2
	WL	ANI_SET_YVEL,70000h
	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL
	WL	3,L2KM3A+FR3
	WL	3,L2KM3A+FR4
	.word	ANI_ATTACK_ON, AMODE_SPINKICK,27,59,68,20	;mode,x,y,w,h
	WL	10,L2KM3A+FR5
	.word	ANI_ATTACK_OFF
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	2,L2KM3A+FR6
	WL	2,L2KM3A+FR7
	WL	3,L2KM3A+FR8
	WL	3,L2KM3A+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 KICK

 SUBR	lex_2_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L2KM3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L2KM3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L2KM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_KICK,6
	WL	2,L2KM3A+FR2
	WL	2,L2KM3A+FR3
	WL	2,L2KM3A+FR4
	.word	ANI_ATTACK_ON, AMODE_KICK,27,59,68,20	;mode,x,y,w,h
	WL	2,L2KM3A+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit
	WL	ANI_SET_YVEL,30000h
	WL	3,L2KM3A+FR5
	
#no_hit
	WL	2,L2KM3A+FR5
	WL	2,L2KM3A+FR6
	WL	2,L2KM3A+FR7
	WL	2,L2KM3A+FR8
	WL	2,L2KM3A+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 KICK

 SUBR	lex_4_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L4KM3B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L4KM3B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L4KM3B+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_KICK,6
	WL	2,L4KM3B+FR2
	WL	2,L4KM3B+FR3
	WL	2,L4KM3B+FR4
	.word	ANI_ATTACK_ON, AMODE_KICK,27,59,68,20	;mode,x,y,w,h
	WL	2,L4KM3B+FR5
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2
	WL	ANI_SET_YVEL,30000h
	WL	3,L4KM3B+FR5
#no_hit2
	WL	2,L4KM3B+FR5
	WL	2,L4KM3B+FR6
	WL	2,L4KM3B+FR7
	WL	2,L4KM3B+FR8
	WL	2,L4KM3B+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #3 SUPER KICK & FLYING KICK (same art, different leap)

#xoff	equ	10
#yoff	equ	4

 SUBR	lex_flying_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_LEAPING,15
	WL	3,L4KB3C+FR1
	.word	ANI_OFFSET,#xoff,#yoff,0

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,145,65,90000h,TGT_HEAD,66,84,0
	WL	ANI_CODE,no_bk_xvel
	WL	2,L4KB3C+FR2
	WL	7,L4KB3C+FR3
	WL	2,L4KB3C+FR4
	.word	ANI_ATTACK_ON,AMODE_FLYKICK,6,64,74,40
	WWL	ANI_WAITHITOPP,7,L4KB3C+FR5
	WL	ANI_GOTO,#atk_off

 SUBR	lex_super_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_LEAPING,15
	WL	3,L4KB3C+FR1
	.word	ANI_OFFSET,#xoff,#yoff,0

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 10,999,80,45,90000h,TGT_CHEST,66,0,-20
	WL	ANI_SET_YVEL,48000h
	WL	3,L4KB3C+FR2
	WL	5,L4KB3C+FR3
	WL	2,L4KB3C+FR4
	.word	ANI_ATTACK_ON,AMODE_KICK,6,54,76,46
	WL	3,L4KB3C+FR5
#atk_off
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#wait
	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	WL	ANI_IFBLOCKED,#blocked

#hit
	.word	ANI_ZERO_XZVELS
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_slide
	WL	ANI_SET_YVEL,30000h
	WLW	ANI_SET_ZVEL,28000h,AM_ABS
	WL	ANI_GOTO,#wait

#no_slide
#blocked
	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL
	WLW	ANI_SET_ZVEL,20000h,AM_ABS
	WL	ANI_SET_YVEL,28000h
;	WL	ANI_GOTO,#wait

#wait	;land.
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,L4KB3C+FR6
	WL	2,L4KB3C+FR7
	WL	2,L4KB3C+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #2 STOMP ON FALLEN OPPONENT

 SUBR	lex_2_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L2MP2A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L2MP2A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L2MP2A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	WL	3,L2MP2A+FR2

	;if we're going to miss, do a leapat
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,7,-2,-40,23,32,50
	WL	1,L2MP2A+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#leapat_stomp

	.word	ANI_STARTATTACK,AT_STOMP,12
	WL	3,L2MP2A+FR3
	WL	3,L2MP2A+FR5
	WL	3,L2MP2A+FR6
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,3,-6,-40,31,40,50
	WL	3,L2MP2A+FR7
	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
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
	LEAPATOPP 14,999,160,140,90000h,TGT_USER,17,0,-50
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

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L4MP3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L4MP3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L4MP3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	;if we're going to miss, do a leapat
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,1,-9,-10,31,30,50
	WL	1,L4MP3A+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#leapat_stomp

	.word	ANI_STARTATTACK,AT_STOMP,14
	WL	3,L4MP3A+FR3
	WL	3,L4MP3A+FR4
	WL	3,L4MP3A+FR5
	WL	2,L4MP3A+FR6
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,-3,-13,-10,39,38,50
	WL	4,L4MP3A+FR7
	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	WL	ANI_IFSTATUS,#hit
	WL	ANI_CODE,CALL_MISSES
#hit
	WL	3,L4MP3A+FR9
	WL	3,L4MP3A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#leapat_stomp

	.word	ANI_TARGET,TGT_KNEES,TGT_CHEST,ATM_CLOSEST
	;too far.  leap at the chest.
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 14,999,160,140,90000h,TGT_USER,13,0,50
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
	WL	3,L4MP3A+FR9
	WL	3,L4MP3A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #3 FLYING GROUND-PUNCH

#yoff	equ	25

 SUBR	lex_flying_ground_punch_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
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

	.WORD	ANI_ADD_MOVE,MOVE_C_9,2,2
	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,1
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	4,L3PJ3F+FR9
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,L3PJ3F+FR10
	WL	3,L3GU4B+FR8
	WL	3,L3GU4B+FR9
	WL	3,L3GU4B+FR10

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

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCONFINE|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING
	.word	ANI_SET_WRESTLER_XFLIP
	.word	ANI_SCROLL_CTRL,SC_RESTORE

	WL	3,L3PJ3F+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 31,190,190,190,90000h,TGT_GROIN,25,11+#yoff,50
;	.word	ANI_SETPLYRMODE,MODE_INAIR2
	WL	ANI_CODE,set_tbukl_airmode
	.word	ANI_GRAVITY_ON
	.word	ANI_SHAKECORNER
	.word	ANI_STARTATTACK,AT_BSTOMP,31

;Check x vel to make sure we aren't going to land on ropes!
	WL	ANI_CODE,check_xvel

	.word	ANI_OFFSET,0,#yoff,0
	WL	3,L3PJ3F+FR3
	WL	3,L3PJ3F+FR4
	WL	3,L3PJ3F+FR5

	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	;attack box dimensions depends on opp mode
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-28,0,-10,94,42,70
	WWL	ANI_IFOPPMODE,MODE_ONGROUND,#opp_onground
	WWL	ANI_IFOPPMODE,MODE_DEAD,#opp_onground
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-28,58,-10,94,42,70

;opp_standing
	WL	1,L3PJ3F+FR6
	WL	ANI_CODE,set_tbukl_confine
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	WL	2,L3PJ3F+FR7
	WL	2,L3PJ3F+FR9
	WL	ANI_CODE,CALL_BONE_BREAK
;	.word	ANI_SOUND,9Bh			;neck break (5-7 ticks late)
	WL	2,L3PJ3F+FR9
	WL	ANI_GOTO,#common

#opp_onground
	WL	1,L3PJ3F+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_OFF

#missed
;	WL	ANI_CODE,tbukl_miss_damage
	WL	2,L3PJ3F+FR7
	WL	4,L3PJ3F+FR9

#common
	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,1
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	ANI_IFSTATUS,#hit

	;missed
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_BOUNCE,5

	WL	ANI_GOTO,#avoid_hit_call

#hit
	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE
#avoid_hit_call
	WL	4,L3PJ3F+FR9
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,L3PJ3F+FR10
	WL	3,L3GU4B+FR8
	WL	3,L3GU4B+FR9
	WL	3,L3GU4B+FR10

	.word	ANI_ZEROVELS
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #2 KNEE & #3 KNEE TO HEAD
* #4 KNEE & KNEE FALL

 SUBR	lex_combo_knee_fall_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	3,L4NM3B+FR1
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,999,20h,20,90000h,TGT_CHEST,20,50,0
	WL	3,L4NM3B+FR2
	.word	ANI_ATTACK_ON,AMODE_BIGKNEE,14,30,48,54
	WL	3,L4NM3B+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_SET_YVEL,60000h
	WLW	ANI_SET_ZVEL,10000h,AM_ABS
	.word	ANI_INC_COMBO
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	3,L4NM3B+FR4
	WL	3,L4NM3B+FR5
	WL	3,L4NM3B+FR6
	WL	3,L4NM3B+FR7

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 KNEE & KNEE FALL

 SUBR	lex_3_knee_to_head_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	2,L4NM3B+FR1
	WL	2,L4NM3B+FR2
	.word	ANI_ATTACK_ON,AMODE_KNEE,14,30,48,54
	WL	ANI_GOTO,#atk

 SUBR	lex_4_knee_fall_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_KNEE,3
	WL	3,L4NM3B+FR1
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 12h,999,20h,20,90000h,TGT_CHEST,20,50,0
	WL	3,L4NM3B+FR2
	.word	ANI_ATTACK_ON,AMODE_BIGKNEE,14,30,48,54
	WL	ANI_GOTO,#atk

 SUBR	lex_4_knee2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	1,L4NM3B+FR1
	WL	ANI_GOTO,#cont2a

 SUBR	lex_4_knee_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L4NM3B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L4NM3B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,L4NM3B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
#cont2a
	.word	ANI_STARTATTACK,AT_KNEE,3
	WL	3,L4NM3B+FR2
	.word	ANI_ATTACK_ON,AMODE_KNEE,14,30,48,54
#atk	
	WL	ANI_SET_YVEL,30000h
	WL	3,L4NM3B+FR3
	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_slide
	WL	ANI_SET_YVEL,60000h
	WLW	ANI_SET_ZVEL,10000h,AM_ABS
#no_slide
	WL	3,L4NM3B+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	4,L4NM3B+FR4
	WL	3,L4NM3B+FR5
	WL	3,L4NM3B+FR6
	WL	3,L4NM3B+FR7

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* GRAB & FLING OPPONENT (INTO A RUN)

 SUBR	lex_2_grabfling_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	.word	ANI_STARTATTACK,AT_PUPPET,10
	WL	2,L1TT5A+FR4
	WL	2,L1TT5A+FR5
	WL	ANI_GOTO,#cont

 SUBR	lex_4_grabfling_anim

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
	WL	5,L4GF3B+FR1

	.word	ANI_ATTACK_ON, AMODE_PUPPET_NOFLAIL,33,56,54,18 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,6,L4GF3B+FR2
	.word	ANI_ZERO_XZVELS
	WWL	ANI_WAITHITOPP,2,L4GF3B+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missedb

	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

;got him
	WL	ANI_CODE,DO_GRUNT
	.ref	CALL_SETUP
	WL	ANI_CODE,CALL_SETUP
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
	WL	10,L4GF3B+FR8
	.word	ANI_OFFSET,-3,0,0			;x,y,z

	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	.ref	fling_delay
	WL	ANI_CODE,fling_delay
	WL	ANI_IFNOTSTATUS,#missed
	WL	25,L4GF3B+FR3
#missed
	WL	ANI_CODE,CALL_MISSES

	WL	6,L4GF3B+FR3
	WL	3,L4GF3B+FR2
	WL	3,L4GF3B+FR1

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
* #4 BIG BOOT

 SUBR	lex_4_bigboot_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	3,L4KM3B+FR1
	.word	ANI_STARTATTACK,AT_BIGBOOT,13
	WL	3,L4KM3B+FR2
	WL	3,L4KM3B+FR3
	WL	2,L4KM3B+FR4

	WL	ANI_CODE,#clrcnt
	.word	ANI_ATTACK_ON,AMODE_BIGBOOT,18,56,78,48
	WWL	ANI_WAITHITOPP,15,L4KM3B+FR5
#lp
	.word	ANI_STARTATTACK,AT_BIGBOOT,5
	WL	2,L4KM3B+FR5
	WL	ANI_CODE,#holdup
	WL	ANI_IFSTATUS,#lp
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	.word	ANI_DRAW_NAME,27
#missed

	WL	3,L4KM3B+FR6
	WL	3,L4KM3B+FR7
	WL	3,L4KM3B+FR8
	WL	3,L4KM3B+FR9

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

	move	*a13(BUT_VAL_CUR),a0
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

******************************************************************************
*
* #2 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	lex_2_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

	WL	3,L2AH2A+FR3
	WL	15,L2AH2A+FR4
	WL	4,L2AH2A+FR5

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	lex_4_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
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

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	3,L4AH4A+FR1
	WL	3,L4AH4A+FR2
	WL	14,L4AH4A+FR3
	WL	2,L4AH4A+FR4

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,lex_dizzy_anim
;	.word	ANI_END

#*****************************************************************************

 SUBR	lex_climbthru_side_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	ANI_CODE,SET_DIR_FACE
	.word	ANI_SETFACING
	.WORD	ANI_SET_WRESTLER_XFLIP

	.word	ANI_OFFSET,16,0,0
	WL	3,L4CR3B+FR1
	.word	ANI_BENDROPE,2
	.word	ANI_OFFSET,4,0,0	;*****
	WL	2,L4CR3B+FR2
	.word	ANI_OFFSET,4,0,0	;*****
	WL	3,L4CR3B+FR3		
	.word	ANI_OFFSET,4,0,0	;*****
	WL	2,L4CR3B+FR4

	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH

	.word	ANI_OFFSET,5,0,0	;*****
	WL	3,L4CR3B+FR5

	.word	ANI_OFFSET,4,0,0	;*****
	WL	2,L4CR3B+FR6
	.word	ANI_BENDROPE,2
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH
	.word	ANI_OFFSET,6,0,0	;*****
	WL	3,L4CR3B+FR7
	.word	ANI_OFFSET,4,0,0	;*****
	WL	2,L4CR3B+FR8
	.word	ANI_OFFSET,9,0,0	;*****
	WL	3,L4CR3B+FR9
	.word	ANI_BENDROPE,-1
	.word	ANI_OFFSET,7,0,0	;*****
	WL	2,L4CR3B+FR10
	.word	ANI_OFFSET,8,-3,0
	WL	3,L4CR3B+FR11

	;now jump off...
;	WL	3,L4JD4A+FR1		;D4FM4A+FR1
	WL	3,L4JD4A+FR2

	.word	ANI_SET_IDIOT
	WWL	ANI_SETLONG,OBJ_GRAVITY,0E000h
	WL	ANI_SET_YVEL,60000h

	WLW	ANI_SET_XVEL,30000h,AM_FACE_REL

	WL	3,L4JD4A+FR3
	.word	ANI_WAITHITGND
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

	.word	ANI_ROPE_Z,R_TOP,RZ_NORM
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM

	.word	ANI_ZEROVELS
	WL	2,L4JD4A+FR4
	WL	2,L4JD4A+FR6
	WL	2,L4JD4A+FR7
	WL	4,L4JD4A+FR8

	.word	ANI_FACEDOWN
	.word	ANI_CLEAR_CLIMB

	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	lex_climbin_side_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	ANI_CODE,SET_DIR_FACE
	.word	ANI_SETFACING
	.WORD	ANI_SET_WRESTLER_XFLIP

	;jump in
;	WL	3,L4JD4A+FR1
	WL	3,L4JD4A+FR2

	WWL	ANI_SETLONG,OBJ_GRAVITY,0E000h
	WL	ANI_CODE,#set_trgt
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	.word	ANI_LEAPATPOS,14h,200,0,0,0	;#ticks,dist,xoff,yoff,zoff

	WL	3,L4JD4A+FR3
	.word	ANI_WAITHITGND
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY
	.word	ANI_ZEROVELS

	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH

	WL	3,L4JD4A+FR4
	WL	3,L4JD4A+FR6
	WL	2,L4JD4A+FR7
	WL	2,L4JD4A+FR8

	.word	ANI_OFFSET,10,0,0	;*****
	;climb through
	WL	3,L4CR3B+FR1
	.word	ANI_BENDROPE,0
	.word	ANI_OFFSET,4,0,0	;*****
	WL	2,L4CR3B+FR2
	.word	ANI_BENDROPE,2
	.word	ANI_OFFSET,4,0,0	;*****
	WL	3,L4CR3B+FR3
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM
	.word	ANI_OFFSET,4,0,0	;*****
	WL	2,L4CR3B+FR4

	.word	ANI_OFFSET,6,0,0	;*****
	WL	3,L4CR3B+FR5

	.word	ANI_OFFSET,6,0,0	;*****
	WL	2,L4CR3B+FR6
	.word	ANI_OFFSET,6,0,0	;*****
	WL	3,L4CR3B+FR7
	.word	ANI_OFFSET,6,0,0	;*****
	WL	2,L4CR3B+FR8
	.word	ANI_BENDROPE,3
	.word	ANI_OFFSET,6,0,0	;*****
	WL	3,L4CR3B+FR9
	.word	ANI_OFFSET,5,0,0	;*****
	WL	2,L4CR3B+FR10
	.word	ANI_BENDROPE,-1
	.word	ANI_OFFSET,5,-3,0
	WL	3,L4CR3B+FR11

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

**********************************************

 SUBR	lex_climbthru_bot_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
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
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOSHADOW|MODE_NOCOLLIS

	;climb through

	.word	ANI_SET_IDIOT
	WL	ANI_CODE,NOT_IN_RING
	.word	ANI_OFFSET,0,-37h,0			;x,y,z
	WL	3,L2PJ3C+FR5
	WL	3,L2PJ3C+FR3
	WL	3,L2PJ3C+FR2

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_CLEAR_CLIMB
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

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
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

	.word	ANI_CLEAR_CLIMB

	.word	ANI_FACEDOWN
	.word	ANI_ZEROVELS
	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	lex_climbthru_top_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
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
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOSHADOW|MODE_NOCOLLIS
	WL	3,L3RL1A+FR2
	WL	3,L3RL1A+FR3
	WL	3,L3RL1A+FR4

	.word	ANI_SET_IDIOT
	;climb through
	.word	ANI_OFFSET,0,-61,0
	.word	ANI_ZEROVELS
	WL	3,L3DC3B+FR3
	WL	3,L3DC3B+FR2
	WL	3,L3DC3B+FR1

	.word	ANI_ZERO_XZVELS

	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_CLEAR_CLIMB
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

 SUBR	lex_rollthru_top_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;roll over once
	WLW	ANI_SET_ZVEL,-50000h,AM_ABS
	WL	3,L3RL1A+FR11
#cont
	WL	3,L3RL1A+FR1
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOSHADOW|MODE_NOCOLLIS
	WL	3,L3RL1A+FR2
	WL	3,L3RL1A+FR3
	WL	3,L3RL1A+FR4

	.word	ANI_SET_IDIOT
	;climb through
	.word	ANI_OFFSET,0,-61,0
	.word	ANI_ZEROVELS
	WL	3,L3DC3B+FR3
	WL	3,L3DC3B+FR2
	WL	3,L3DC3B+FR1

	.word	ANI_ZERO_XZVELS

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END

#*****************************************************************************

 SUBR	lex_climbin_top_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
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

	.word	ANI_CLEAR_CLIMB

	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END

#set_zvel2
	movi	52000h,a0
	move	a0,*a13(OBJ_ZVEL),L
	rets

#*****************************************************************************
*

 SUBR	lex_knockdwn_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
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

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	.word	ANI_SETPLYRMODE,MODE_DEAD
	.word	ANI_END

#nodead
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,lex_faceup_getup_anim

#****************************************************************************
*
* PIN OPPONENT AND RAISE ARM IN VICTORY

 SUBR	lex_2_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;Rotate!
	WL	2,L1TT5A+FR4
	WL	2,L1TT5A+FR5
	WL	2,L1TT5A+FR6

 SUBR	lex_4_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 25,999,80h,50h,90000h,TGT_CHEST|TGT_GROUND,0,57,-15
	WL	ANI_CODE,hit_nearest

	WL	3,L3PN5B+FR2
	.word	ANI_OFFSET,0,20,0			;x,y,z
	WL	19,L3PN5B+FR5
	.word	ANI_ZEROVELS

	WL	3,L3PN5B+FR9
	WL	3,L3PN5B+FR8

	WL	ANI_CODE,DO_CROWD_CHEER
	WL	ANI_CODE,grnd_hit
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2

	.word	ANI_BOUNCE,2
	WL	3,L3PN5B+FR8
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE

	.word	ANI_OFFSET,0,0,20			;x,y,z

	WL	3,L3PN5B+FR9
	.ref	win_announce
	WL	ANI_CODE,win_announce
	WL	40,L3PN5B+FR10

	.word	ANI_LOOP

;Do another ground hit on opponent
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

#lp	WL	4,L4FX5B+FR10
	WL	4,L4FX5B+FR9
	WL	4,L4FX5B+FR8
	WL	4,L4FX5B+FR9
	WL	4,L4FX5B+FR10
	WL	4,L4FX5B+FR11
	WL	ANI_GOTO,#lp

#*****************************************************************************
*
* #2 RAISE ARM IN VICTORY FROM A STANCE

 SUBR	lex_2_raise_arm_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;Rotate!
	WL	2,L1TT5A+FR4
	WL	2,L1TT5A+FR5
	WL	2,L1TT5A+FR6

	WL	ANI_CODE,DO_CROWD_CHEER
	WL	ANI_CODE,win_announce

	WL	6,L4SW5A+FR2
	WL	6,L4SW5A+FR3
	WL	6,L4SW5A+FR4
	WL	6,L4SW5A+FR5
	WL	6,L4SW5A+FR6
	WL	6,L4SW5A+FR7
	WL	6,L4SW5A+FR8
	WL	6,L4SW5A+FR9
	WL	6,L4SW5A+FR10

	.word	ANI_SET_RPTCOUNT,30
#lp0	WL	2,L4SW5A+FR9
	WL	2,L4SW5A+FR10
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#lp0

	WL	6,L4SW5A+FR9
	WL	6,L4SW5A+FR8
	WL	6,L4SW5A+FR7
	WL	6,L4SW5A+FR6
	WL	6,L4SW5A+FR5
	WL	6,L4SW5A+FR4
	WL	6,L4SW5A+FR3

	.word	ANI_SET_RPTCOUNT,-4	;set count to rnd from 0 to 4
#lp1	WL	55,L4SW5A+FR3
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#lp1

	WL	ANI_CODE,check_raisearm_bit
	WL	ANI_IFSTATUS,#wakeup

	;don't wake up.
#floop	WL	1000,L4SW5A+FR2
	WL	ANI_GOTO,#floop

#wakeup	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_FACEDOWN
	.word	ANI_END

#*****************************************************************************
*
* #4 RAISE ARM

 SUBR	lex_4_raise_arm_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,DO_CROWD_CHEER
	WL	ANI_CODE,win_announce

;	WL	5,L4FX5B+FR1
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

	.word	ANI_SET_RPTCOUNT,-8
#lp0	WL	4,L4FX5B+FR10
	WL	4,L4FX5B+FR9
	WL	4,L4FX5B+FR8
	WL	4,L4FX5B+FR9
	WL	4,L4FX5B+FR10
	WL	4,L4FX5B+FR11
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#lp0

	WL	ANI_CODE,check_raisearm_bit
	WL	ANI_IFSTATUS,#wakeup

	.word	ANI_SET_RPTCOUNT,1000
	WL	ANI_GOTO,#lp0

#wakeup	WL	5,L4FX5B+FR10
	WL	5,L4FX5B+FR9
	WL	5,L4FX5B+FR8
	WL	5,L4FX5B+FR7
	WL	5,L4FX5B+FR6
	WL	5,L4FX5B+FR5
	WL	5,L4FX5B+FR4
	WL	5,L4FX5B+FR3
	WL	5,L4FX5B+FR2

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_FACEDOWN
	.word	ANI_END


#*****************************************************************************
*
* GET BUCKED OFF A PINNED OPPONENT

 SUBR	lex_buckoff_anim

	.ref	set_buckoff_vels

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	4,L3PN5B+FR10
	WL	1,L3PN5B+FR5
	WL	ANI_CODE,set_buckoff_vels
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	4,L3PN5B+FR9
	WL	12,L3PN5B+FR8

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

	.word	ANI_FACEDOWN

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************

	.end
