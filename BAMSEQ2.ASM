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
	.INCLUDE	"SWEAT.EQU"


******************************************************************************
* EXTERNAL REFERENCES

	.ref	MOVE_NAME_ANNC,hit_nearest,WORLDTLX,set_tbukl_airmode
	.ref	free_toss_check,setup_freetoss
	.ref	DO_WAIL,CALL_ANI_AVERAGE_MOVE,DO_BLOCKED
	.ref	create_impact,create_impact2,create_impact_salt
	.ref	SET_DIR_FACE,start_run_anim,HIT_THE_MAT,SMALL_BOUNCE
	.ref	choose_2or4,no_bk_xvel,CALL_MISSES,CALL_NASTY_MOVE
	.ref	DO_CROWD_CHEER,check_xvel,BAMBLU_P,pal_getf
	.ref	am_I_dead,win_announce,create_impact3
	.ref	bam_pogo_anim,bam_3_pile_driver_anim,DO_GRUNT
	.ref	bam_3_head_held_anim,set_tbukl_confine
	.ref	bam_combo_pogo_anim,grnd_hit,fix_bnc_flip
	.ref	bam_fireball,CALL_SPECIAL_MOVE,ckzpos
	.ref	bam_4_graboh_anim,DO_COMBO_MESS,bam_combo_graboh_anim
	.ref	hit_puppet_even_if_dead,check_raisearm_bit
	.ref	skick_delay,spunch_delay,bam_combo_pile_driver_anim
	.ref	DO_FLAME_HIT_SND,create_impact_flykick,CALL_SETUP
	.ref	set_buckoff_vels,hiptoss_delay,lex_tossed2_anim
	.ref	fling_delay,DO_FLAME_SND,impact_sound,start_run_flung

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************

 SUBR	bam_2_fpunch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
;	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
;	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_DETACH
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_SET_RPTCOUNT,2	;1 times

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
#loop
	.word	ANI_CLR_BUTCOUNT

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 08h,999,54h,45,90000h,TGT_HEAD,50,105,10
	LEAPATOPP 08h,999,54h,45,90000h,TGT_HEAD,30,105,10
	WL	ANI_CODE,no_bk_xvel

	.word	ANI_STARTATTACK,AT_PUNCH,10

	WL	2,B2FH3Z+FR1
	WL	3,B2FH3Z+FR2
	WL	3,B2FH3Z+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,B2FH3Z+FR4
	.word	ANI_ATTACK_ON, AMODE_FIRE_PUNCH,7,44,59,68	;mode,x,y,w,h
	WL	3,B2FH3Z+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFBLOCKED,#blocked
	WL	ANI_IFSTATUS,#gotim
;missed
	WL	3,B2FH3Z+FR6
	WL	20,B2FH3Z+FR7

	WL	ANI_CODE,CALL_MISSES

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#gotim
	.word	ANI_IMMOBILIZE,20
#blocked
	WL	ANI_CODE,DO_FLAME_HIT_SND
	WL	ANI_CODE,CALL_NASTY_MOVE
	.word	ANI_STARTATTACK,AT_PUNCH,6

	WL	ANI_CODE,#set_opp_xy

	WL	2,B2FH3Z+FR6
	WL	3,B2FH3Z+FR7

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 08h,999,54h,45,90000h,TGT_HEAD,40,105,-10
	LEAPATOPP 08h,999,54h,45,90000h,TGT_HEAD,20,105,-10

	.word	ANI_STARTATTACK,AT_PUNCH,10

	WL	2,B4FH3Z+FR1
	WL	3,B4FH3Z+FR2
	WL	3,B4FH3Z+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,B4FH3Z+FR4
	.word	ANI_ATTACK_ON, AMODE_FIRE_PUNCH,7,44,59,68	;mode,x,y,w,h
	WL	3,B4FH3Z+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFBLOCKED,#blocked2
	WL	ANI_IFSTATUS,#gotim2
;missed
	WL	3,B4FH3Z+FR6
	WL	20,B4FH3Z+FR7

	WL	ANI_CODE,CALL_MISSES

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#gotim2
	.word	ANI_IMMOBILIZE,20
#blocked2
	WL	ANI_CODE,#set_opp_xy

	WL	2,B4FH3Z+FR6
	WL	3,B4FH3Z+FR7

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,4,#fail
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#loop

	.word	ANI_DRAW_NAME,15

#fail

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_4_fpunch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
;	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
;	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_DETACH

	.word	ANI_SET_RPTCOUNT,2	;3 times

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
#loop2
	.word	ANI_STARTATTACK,AT_PUNCH,10
	.word	ANI_CLR_BUTCOUNT

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 08h,999,54h,45,90000h,TGT_HEAD,50,105,-10
	LEAPATOPP 08h,999,54h,45,90000h,TGT_HEAD,30,105,-10
	WL	ANI_CODE,no_bk_xvel

	WL	2,B4FH3Z+FR1
	WL	3,B4FH3Z+FR2
	WL	3,B4FH3Z+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,B4FH3Z+FR4
	.word	ANI_ATTACK_ON, AMODE_FIRE_PUNCH,7,44,59,68	;mode,x,y,w,h
	WL	3,B4FH3Z+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFBLOCKED,#blocked2a
	WL	ANI_IFSTATUS,#gotim2a
;missed
	WL	3,B4FH3Z+FR6
	WL	20,B4FH3Z+FR7

	WL	ANI_CODE,CALL_MISSES

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#gotim2a
	.word	ANI_IMMOBILIZE,20
#blocked2a
	WL	ANI_CODE,DO_FLAME_HIT_SND
	.word	ANI_STARTATTACK,AT_PUNCH,15
	WL	ANI_CODE,CALL_NASTY_MOVE

	WL	ANI_CODE,#set_opp_xy

	WL	2,B4FH3Z+FR6
	WL	3,B4FH3Z+FR7

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 08h,999,54h,45,90000h,TGT_HEAD,40,105,10
	LEAPATOPP 08h,999,54h,45,90000h,TGT_HEAD,20,105,10

	WL	2,B2FH3Z+FR1
	WL	3,B2FH3Z+FR2
	WL	3,B2FH3Z+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,B2FH3Z+FR4
	.word	ANI_ATTACK_ON, AMODE_FIRE_PUNCH,7,44,59,68	;mode,x,y,w,h
	WL	3,B2FH3Z+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFBLOCKED,#blockeda
	WL	ANI_IFSTATUS,#gotima
;missed
	WL	3,B2FH3Z+FR6
	WL	20,B2FH3Z+FR7

	WL	ANI_CODE,CALL_MISSES

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#gotima
	.word	ANI_IMMOBILIZE,20
#blockeda
	WL	ANI_CODE,#set_opp_xy

	WL	2,B2FH3Z+FR6
	WL	3,B2FH3Z+FR7

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,4,#fail2
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#loop
	.word	ANI_DRAW_NAME,15
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
 
	calla	create_impact3
	rets

 SUBR    bam_combo_fpunch

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_DETACH
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_SET_RPTCOUNT,2	;3 times
	WLW	ANI_SET_XVEL,30000h,AM_FACE_REL


	.word	ANI_STARTATTACK,AT_PUNCH,8

	WL	ANI_CODE,DO_FLAME_SND

	WL	2,B2FH3Z+FR1
	WL	2,B2FH3Z+FR2
	WL	2,B2FH3Z+FR3
	WL	2,B2FH3Z+FR4
	WLW	ANI_SET_XVEL,0h,AM_FACE_REL
	.word	ANI_ATTACK_ON, AMODE_FIRE_PUNCH,7,44,79,68	;mode,x,y,w,h
	WL	2,B2FH3Z+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#MISSED_2
	WL	ANI_CODE,DO_FLAME_HIT_SND
	WL	ANI_CODE,create_impact
	.WORD	ANI_INC_COMBO
	.word	ANI_STARTATTACK,AT_PUNCH,12
	WL	ANI_SET_YVEL,18000h
	.word	ANI_SET_ATTACH

	WWWL	ANI_IFROPE,RC_FRONT,100,#AVOID_VELSB

	WLLL	ANI_SETOPPVELS,10000H,10000h,0h		;x,y,z vels
	WLW	ANI_SET_XVEL,10000h,AM_FACE_REL
#AVOID_VELSB

	WL	2,B2FH3Z+FR6
	WL	2,B2FH3Z+FR7

	WL	2,B4FH3Z+FR1
	WL	2,B4FH3Z+FR2
	WL	2,B4FH3Z+FR3
	WL	2,B4FH3Z+FR4
	.word	ANI_CLR_STATUS
	.word	ANI_ATTACK_ON, AMODE_FIRE_PUNCH,7,44,79,68	;mode,x,y,w,h
	WL	2,B4FH3Z+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#MISSED_4
	WWWL	ANI_IFROPE,RC_FRONT,100,#AVOID_VELS2B

	WLLL	ANI_SETOPPVELS,10000H,10000h,0h		;x,y,z vels
	WLW	ANI_SET_XVEL,10000h,AM_FACE_REL
#AVOID_VELS2B
	WL	ANI_CODE,create_impact
	.WORD	ANI_INC_COMBO
	WL	ANI_SET_YVEL,18000h

	WL	2,B4FH3Z+FR6
	WL	2,B4FH3Z+FR7

#loop_c
	.word	ANI_CLR_BUTCOUNT

	.word	ANI_STARTATTACK,AT_PUNCH,8
	WL	ANI_CODE,DO_FLAME_SND

	WL	2,B2FH3Z+FR1
	WL	2,B2FH3Z+FR2
	WL	2,B2FH3Z+FR3
	WL	2,B2FH3Z+FR4
	WLW	ANI_SET_XVEL,0h,AM_FACE_REL
	.word	ANI_ATTACK_ON, AMODE_FIRE_PUNCH,7,44,79,68	;mode,x,y,w,h
	WL	2,B2FH3Z+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#MISSED_2
	WL	ANI_CODE,DO_FLAME_HIT_SND
	WL	ANI_CODE,create_impact
	.WORD	ANI_INC_COMBO
	.word	ANI_STARTATTACK,AT_PUNCH,12
	WL	ANI_SET_YVEL,18000h
	.word	ANI_SET_ATTACH

	WWWL	ANI_IFROPE,RC_FRONT,100,#AVOID_VELS

	WLLL	ANI_SETOPPVELS,10000H,10000h,0h		;x,y,z vels
	WLW	ANI_SET_XVEL,10000h,AM_FACE_REL
#AVOID_VELS

	WL	2,B2FH3Z+FR6
	WL	2,B2FH3Z+FR7

	WL	2,B4FH3Z+FR1
	WL	2,B4FH3Z+FR2
	WL	2,B4FH3Z+FR3
	WL	2,B4FH3Z+FR4
	.word	ANI_CLR_STATUS
	.word	ANI_ATTACK_ON, AMODE_FIRE_PUNCH,7,44,79,68	;mode,x,y,w,h
	WL	2,B4FH3Z+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#MISSED_4

	WWWL	ANI_IFROPE,RC_FRONT,100,#AVOID_VELS2

	WLLL	ANI_SETOPPVELS,10000H,10000h,0h		;x,y,z vels
	WLW	ANI_SET_XVEL,10000h,AM_FACE_REL
#AVOID_VELS2

	WL	ANI_CODE,create_impact
	.WORD	ANI_INC_COMBO
	WL	ANI_SET_YVEL,18000h

	WL	2,B4FH3Z+FR6
	WL	2,B4FH3Z+FR7

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#loop_c

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#CHECK_ANOTHER_2
	.word	ANI_DETACH
	WL	ANI_CHANGEANIM,bam_combo_hiptoss_anim

#CHECK_ANOTHER_2
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#CHECK_ANOTHER
	.word	ANI_DETACH
	WL	ANI_CHANGEANIM,bam_flying_kick_no_xvel

#CHECK_ANOTHER
	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#CHECK_ANOTHER_BUT2
	WL	ANI_CHANGEANIM,bam_combo_slap_anim

#CHECK_ANOTHER_BUT2
	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#MISSED_4B
	WL	ANI_CHANGEANIM,bam_combo_pogo_anim

#MISSED_4
	WL	3,B4FH3Z+FR6
	WL	3,B4FH3Z+FR7
#MISSED_4B

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_CODE,CALL_MISSES

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#MISSED_2
	WL	3,B2FH3Z+FR6
	WL	3,B2FH3Z+FR7

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_CODE,CALL_MISSES

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 NORMAL PUNCH

 SUBR	bam_2_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B2PU3C+FR4
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B2PU3C+FR4
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B2PU3C+FR5
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_PUNCH,7
	WL	1,B2PU3C+FR5
	WL	2,B2PU3C+FR6

	.word	ANI_ATTACK_ON, AMODE_PUNCH,28,92,56,10	;mode,x,y,w,h
	WL	3,B2PU3C+FR7
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit

	WL	ANI_SET_YVEL,30000h
	WL	3,B2PU3C+FR7
#no_hit

	WL	1,B2PU3C+FR7
	WL	2,B2PU3C+FR8
	WL	2,B2PU3C+FR9
	WL	2,B2PU3C+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 NORMAL PUNCH

 SUBR	bam_4_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B4PU3D+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B4PU3D+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B4PU3D+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_PUNCH,7
	WL	1,B4PU3D+FR3
	WL	2,B4PU3D+FR4

	.word	ANI_ATTACK_ON, AMODE_PUNCH,28,92,56,10	;mode,x,y,w,h
	WL	3,B4PU3D+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit

	WL	ANI_SET_YVEL,30000h
	WL	3,B4PU3D+FR5
#no_hit
	WL	1,B4PU3D+FR5
	WL	2,B4PU3D+FR6
	WL	2,B4PU3D+FR7
	WL	2,B4PU3D+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_combo_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.WORD	ANI_CLEAR_COMBO

	WL	2,B4PU3D+FR2
	.word	ANI_STARTATTACK,AT_PUNCH,7
	WL	2,B4PU3D+FR3
	WL	2,B4PU3D+FR4

	WL	2,B4PU3D+FR5
	.WORD	ANI_INC_COMBO
	.word	ANI_ATTACK_ON, AMODE_PUNCH,28,42,56,60	;mode,x,y,w,h
	WL	2,B4PU3D+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#no_hit4
	.WORD	ANI_INC_COMBO

	WL	ANI_SET_YVEL,18000h
	WL	2,B4PU3D+FR5

	WL	2,B2PU3C+FR4
	.word	ANI_STARTATTACK,AT_PUNCH,7
	WL	2,B2PU3C+FR5
	WL	2,B2PU3C+FR6

	WL	2,B2PU3C+FR7
	.word	ANI_ATTACK_ON, AMODE_PUNCH,28,92,56,10	;mode,x,y,w,h
	WL	2,B2PU3C+FR7
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#no_hit2
	.WORD	ANI_INC_COMBO

	WL	ANI_SET_YVEL,18000h
	WL	2,B2PU3C+FR7

	.word	ANI_SET_RPTCOUNT,3	;3 times
#p_loop
	.word	ANI_CLR_BUTCOUNT

	WL	2,B4PU3D+FR2
	.word	ANI_STARTATTACK,AT_PUNCH,7
	WL	1,B4PU3D+FR3
	WL	2,B4PU3D+FR4

	WL	1,B4PU3D+FR5
	.word	ANI_ATTACK_ON, AMODE_PUNCH,28,42,56,60	;mode,x,y,w,h
	WL	2,B4PU3D+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#no_hit4
	.WORD	ANI_INC_COMBO

	WL	ANI_SET_YVEL,18000h
	WL	1,B4PU3D+FR5

	WL	2,B2PU3C+FR4
	.word	ANI_STARTATTACK,AT_PUNCH,7
	WL	1,B2PU3C+FR5
	WL	2,B2PU3C+FR6

	WL	1,B2PU3C+FR7
	.word	ANI_ATTACK_ON, AMODE_PUNCH,28,92,56,10	;mode,x,y,w,h
	WL	2,B2PU3C+FR7
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#no_hit2
	.WORD	ANI_INC_COMBO

	WL	ANI_SET_YVEL,18000h
	WL	1,B2PU3C+FR7

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#p_loop

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#CHECK_NEXT2
	.word	ANI_DETACH
	WL	ANI_CHANGEANIM,bam_combo_hiptoss_anim

#CHECK_NEXT2
	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#CHECK_NEXT1
	.word	ANI_DETACH
	WL	ANI_CHANGEANIM,bam_flying_kick_no_xvel

#CHECK_NEXT1
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#no_hit2
	WL	ANI_CHANGEANIM,bam_combo_superkick_anim
#no_hit2

	.WORD	ANI_DETACH
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	2,B2PU3C+FR7

	WL	3,B2PU3C+FR8
	WL	2,B2PU3C+FR9
	WL	2,B2PU3C+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#no_hit4
	.WORD	ANI_DETACH
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	2,B4PU3D+FR5

	WL	3,B4PU3D+FR6
	WL	2,B4PU3D+FR7
	WL	2,B4PU3D+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 PUSH

 SUBR	bam_4_push_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WL	ANI_SETFLAG,M_PUSH
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP


	.word	ANI_STARTATTACK,AT_PUSH,9
	WL	3,B4PS3A+FR2
	WL	3,B4PS3A+FR3
	WL	3,B4PS3A+FR4
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ATTACK_ON, AMODE_PUSH,36,85,49,17 ;mode,x,y,w,h
	WL	3,B4PS3A+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,40h,-70000h,#no_hit	;range,vel,addr
	WL	15,B4PS3A+FR5
#no_hit
	WL	3,B4PS3A+FR5
	WL	ANI_IFSTATUS,#hit
	WL	5,B4PS3A+FR5
#hit
	WL	3,B4PS3A+FR4
	WL	3,B4PS3A+FR3
	WL	3,B4PS3A+FR2

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

;#fireball
;	move	a13,a11
;	CREATE0	bam_fireball
;	rets

******************************************************************************
*
* #2 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	bam_2_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
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

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
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

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
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
;	.word	ANI_END


******************************************************************************
*
* #4 LOSE BALANCE

 SUBR	bam_4_losebal_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_FRICTION,3000h
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WLW	ANI_SET_XVEL,-60000h,AM_HIT_REL
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0

	WL	3,B4LB4B+FR1
	WL	3,B4LB4B+FR2
	WL	3,B4LB4B+FR3
	WL	3,B4LB4B+FR4
	WL	3,B4LB4B+FR5
	WL	3,B4LB4B+FR6
	WL	3,B4LB4B+FR7

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
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
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2

	;if we're gonna miss, do a leapat
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,19,-6,-40,33,31,50
	WL	1,B2PJ3A+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#no_leapat

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	.word	ANI_TARGET,TGT_CHEST,TGT_GROIN,ATM_CLOSEST
	LEAPATOPP 20,999,160,140,90000h,TGT_USER,35,0+#yoff,-40
	.word	ANI_SETPLYRMODE,MODE_INAIR
	WL	ANI_CODE,no_bk_xvel

#no_leapat
	WL	3,B2PJ3A+FR5
	WL	3,B2PJ3A+FR6
	.word	ANI_OFFSET,0,#yoff,0
	WL	4,B2PJ3A+FR7
	WL	4,B2PJ3A+FR8
	.word	ANI_WAITHITGND
	.word	ANI_SHAKER,25
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_ATTACK_ON_Z,AMODE_LBOWDROP,19,-6,-40,33,31,50
	WL	1,B2PJ3A+FR9
	.word	ANI_ATTACK_OFF

	.WORD	ANI_ADD_MOVE,MOVE_C_2,2,2
	WL	ANI_IFNOTSTATUS,#missed

	.word	ANI_SHAKEALL,2
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#hit
#missed
	WL	ANI_CODE,CALL_MISSES
#hit
	.word	ANI_DRAW_NAME,18
	WL	3,B2PJ3A+FR9
	WL	4,B2PJ3A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,bam_2_faceup_getup2_anim

#*****************************************************************************
*
* #4 ELBOW DROP

#yoff	equ	40

 SUBR	bam_combo_lbowdrop_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	.word	ANI_STARTATTACK,AT_LBDROP,-1
	WL	3,B3PJ3B+FR3
	WL	3,B3PJ3B+FR4

	;if we're gonna miss, do a leapat
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,19,-6,-40,33,31,50
	WL	1,B3PJ3B+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#no_leapatc

	.word	ANI_TARGET,TGT_CHEST,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 20,999,112,96,90000h,TGT_USER,32,#yoff,40
	WL	ANI_CODE,no_bk_xvel

#no_leapatc
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
	.WORD	ANI_ADD_MOVE,MOVE_C_2,2,2
	WL	ANI_IFNOTSTATUS,#missedc

	.word	ANI_SHAKER,20
	.word	ANI_SHAKEALL,2

	;bounce off the guy
	.WORD	ANI_INC_COMBO
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_ZVEL,-18000h,AM_ABS
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#hitc

#missedc
	WL	ANI_CODE,CALL_MISSES
#hitc

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO

	WL	3,B3PJ3B+FR9
	WL	4,B3GU4A+FR4

	.word	ANI_SETMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,bam_4_faceup_getup2_anim


 SUBR	bam_4_lbowdrop_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_LBDROP,-1
	WL	3,B3PJ3B+FR3
	WL	3,B3PJ3B+FR4
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2

	;if we're gonna miss, do a leapat
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,19,-6,-40,33,31,50
	WL	1,B3PJ3B+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#no_leapat

	.word	ANI_TARGET,TGT_CHEST,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 20,999,160,140,90000h,TGT_USER,32,#yoff,40
	WL	ANI_CODE,no_bk_xvel

#no_leapat
	WL	2,B3PJ3B+FR5
	.word	ANI_OFFSET,0,#yoff,0
	WL	3,B3PJ3B+FR6
	WL	3,B3PJ3B+FR7
	WL	3,B3PJ3B+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SHAKER,25
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_ATTACK_ON_Z,AMODE_LBOWDROP,12,-9,-10,42,42,50
	WL	1,B3PJ3B+FR9
	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_2,2,2
	WL	ANI_IFNOTSTATUS,#missed

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
	.word	ANI_DRAW_NAME,18

	WL	3,B3PJ3B+FR9
	WL	3,B3GU4A+FR4

	.word	ANI_SETMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,bam_4_faceup_getup2_anim

#*****************************************************************************
*
* #3 FLYING BUTT-DROP

#yoff	equ	51

 SUBR	bam_combo_butt_drop_anim

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

	WL	ANI_IFNOTSTATUS,#missc

	.WORD	ANI_INC_COMBO
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

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	4,B3JK3A+FR9
	WL	4,B3JK3A+FR10
	.word	ANI_OFFSET,15,9,0
	.word	ANI_FACEUP
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,bam_2_faceup_getup2_anim

#missc	;missed
	WL	ANI_CODE,CALL_MISSES
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	4,B3JK3A+FR9
	WL	4,B3JK3A+FR10
	.word	ANI_OFFSET,15,9,0
	.word	ANI_FACEUP
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,bam_2_faceup_getup2_anim


 SUBR	bam_3_butt_drop_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_INAIR

	.word	ANI_STARTATTACK,AT_BUTTSTOMP,38
	WL	2,B3JK3A+FR4
	WL	2,B3JK3A+FR5

	.word	ANI_TARGET,TGT_CHEST,TGT_CHEST,ATM_FARTHEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 30,999,112,96,90000h,TGT_USER,9,3+#yoff,-20

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
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
	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE
	.word	ANI_DRAW_NAME,14

	WL	3,B3JK3A+FR9
	WL	3,B3JK3A+FR10
	.word	ANI_OFFSET,15,9,0
	.word	ANI_FACEUP
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,bam_2_faceup_getup2_anim

#miss	;missed
	WL	ANI_CODE,CALL_MISSES

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,B3JK3A+FR9
	WL	3,B3JK3A+FR10
	.word	ANI_OFFSET,15,9,0
	.word	ANI_FACEUP
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,bam_2_faceup_getup2_anim

#*****************************************************************************
*
* TURNBUCKLE BELLYFLOP

 SUBR	bam_bellyflop_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCONFINE|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING
	.word	ANI_SET_WRESTLER_XFLIP
	.word	ANI_SCROLL_CTRL,SC_RESTORE

	.ref	BAMFRE_P
	WLWW	ANI_SHADOWTRAIL,BAMFRE_P,3,12	;pal,rate,lifespan
	.word	ANI_STARTATTACK,AT_LEAPING,44
	WL	3,B4FK4B+FR3
	WL	3,B4FK4B+FR4
	.word	ANI_OFFSET,17,40,0

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 36,190,190,190,90000h,TGT_CHEST,18,0,20

;	.word	ANI_SETPLYRMODE,MODE_INAIR2
	WL	ANI_CODE,set_tbukl_airmode
	.word	ANI_GRAVITY_ON
	.word	ANI_SHAKECORNER

	WL	ANI_CODE,check_xvel

	.WORD	ANI_ADD_MOVE,MOVE_C_9,2,2

	WL	4,B4FK4B+FR5
	WL	4,B4FK4B+FR6
	WL	4,B4FK4B+FR7
	WL	ANI_CODE,set_tbukl_confine
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-36,0,-30,110,38,60
	WWL	ANI_IFOPPMODE,MODE_ONGROUND,#opp_onground
	WWL	ANI_IFOPPMODE,MODE_DEAD,#opp_onground
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-36,28,-30,110,38,60
#opp_onground
	WWL	ANI_WAITHITOPP,30,B4FK4B+FR8
	.word	ANI_ATTACK_OFF
	.word	ANI_SETPLYRMODE,MODE_INAIR	;no steering once you hit.
	WL	ANI_IFSTATUS,#hit

	;missed
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SHADOWTRAIL,0	;off
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,CALL_MISSES
;	WL	ANI_CODE,tbukl_miss_damage
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
	.word	ANI_SHADOWTRAIL,0	;off
	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_ZEROVELS
	.word	ANI_SHAKER,20
	.word	ANI_SHAKEALL,3
	.word	ANI_DRAW_NAME,21

;FIX!!!
;Jason will do...  Don't jerk opponent onto grnd if he is up in air
;This should already be working?!?
;Put in belly flop agnst inair guy here...

	WL	ANI_CODE,#attach_victim
	WL	ANI_SLAVEANIM,#release_table
	.word	ANI_SOUND,0A3h
	.word	ANI_DETACH

	.word	ANI_SETMODE,MODE_UNINT|MODE_INVISIBLE|MODE_NOSHADOW|MODE_NOCOLLIS
	.word	ANI_PAUSE,40

	;reappear
	WL	ANI_CODE,#set_new_position
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOSHADOW|MODE_NOCOLLIS|MODE_NOCONFINE

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
	calla	hit_puppet_even_if_dead		;pretend collision
	PULL	a13
	rets

 SUBRP	#set_new_position

	movi	#init_positions,a0
#lp1	move	*a0(#NXT),a14,W
	jrn	#usea0		;if last entry, use by default.

	;use current entry if:
	; X >= WORLDTLX+25 and
	; X <= WORLDTLX+400-25

	move	*a0(#XPOS),a1
	move	@WORLDTLX,a14,L
	sra	16,a14
	addk	25,a14
	cmp	a14,a1
	jrlt	#nxt1
	addi	350,a14
	cmp	a14,a1
	jrle	#usea0


#nxt1	addi	#SIZE,a0
	jruc	#lp1

#usea0	move	*a0(#XPOS),*a13(OBJ_XPOSINT)
	move	*a0(#ZPOS),*a13(OBJ_ZPOSINT)
	move	*a0(#YPOS),*a13(OBJ_YPOSINT)
	move	*a0(#YPOS),*a13(GROUND_Y)
	move	*a0(#INRING),*a13(INRING)

	rets


	;possible reappear positions.  hunt until you find one that's
	; onscreen, then use it.  If none of them are onscreen (should
	; never happen,) use the last entry in the table.

	STRUCT	0
	WORD	#XPOS
	WORD	#ZPOS
	WORD	#YPOS
	WORD	#INRING
	LABEL	#SIZE
	WORD	#NXT	;first element of NEXT entry. check for -1.

	;XPOSINT, ZPOSINT, YPOSINT/GROUND_Y, INRING
#init_positions
	.word	RING_X_CENTER,RING_Z_CENTER,MAT_Y,0	;center
	.word	RING_TOP_LEFT,RING_Z_CENTER,MAT_Y,0	;center left
	.word	RING_TOP_RIGHT,RING_Z_CENTER,MAT_Y,0	;center right
	.word	RING_BOT_LEFT,RING_BOT,MAT_Y,0		;bottom left
	.word	RING_BOT_RIGHT,RING_BOT,MAT_Y,0		;bottom right

	;various outside points.
	.word	675,1184,0,1,	1475,921,0,1
	.word	965,683,0,1,	1253,656,0,1
	.word	814,1648,0,1,	1415,1608,0,1
	.word	1097,1648,0,1,	659,696,0,1
	.word	528,1657,0,1,	1652,1615,0,1
	.word	1709,699,0,1,	1791,1174,0,1
	.word	1874,1548,0,1

	.word	RING_X_CENTER,RING_Z_CENTER,MAT_Y,0	;center
	.word	-1


 SUBR	burn_tbl
 SUBRP	#release_table
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

	WL	ANI_CODE,#hit_ground
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

	;done looping
	WL	ANI_CODE,#restore_pal

	WL	ANI_CODE,am_I_dead
	WL	ANI_IFNOTSTATUS,#nodead
	WL	ANI_CHANGEANIM_TBL,#convulse

#nodead
	WL	ANI_CHANGEANIM_TBL,#liedown_table


;Immediately snap to ground when the burn begins.
 SUBRP	#hit_ground
	move	*a13(GROUND_Y),*a13(OBJ_YPOSINT)
	rets

 SUBRP	#set_pal
	movi	BAMBLU_P,a0
	calla	pal_getf
	move	*a13(OBJ_PAL),*a13(MY_PAL),W
	move	a0,*a13(OBJ_PAL),W

	;set the TEMP_PAL bit
	move	*a13(STATUS_FLAGS),a14
	ori	M_TEMP_PAL,a14
	move	a14,*a13(STATUS_FLAGS)

	rets

 SUBRP	#restore_pal
	move	*a13(MY_PAL),*a13(OBJ_PAL),W

	;clear TEMP_PAL bit
	move	*a13(STATUS_FLAGS),a14
	andni	M_TEMP_PAL,a14
	move	a14,*a13(STATUS_FLAGS)

	rets


#liedown_table
	REFLONG	hrt_liedown_anim		;0 Bret Hart
	REFLONG	rzr_liedown_anim		;1 Razor Ramon
	REFLONG	und_liedown_anim		;2 Undertaker
	REFLONG	yok_liedown_anim		;3 Yokozuna
	REFLONG	shn_liedown_anim		;4 Shawn Michaels
	REFLONG	bam_liedown_anim		;5 Bam Bam
	REFLONG	dnk_liedown_anim		;6 Doink
	.long	0
	REFLONG	lex_liedown_anim		;8 Lex Luger

#convulse
	REFLONG	hrt_hitonground_anim		;0 Bret Hart
	REFLONG	rzr_hitonground_anim		;1 Razor Ramon
	REFLONG	und_hitonground_anim		;2 Undertaker
	REFLONG	yok_hitonground_anim		;3 Yokozuna
	REFLONG	shn_hitonground_anim		;4 Shawn Michaels
	REFLONG	bam_hitonground_anim		;5 Bam Bam
	REFLONG	dnk_hitonground_anim		;6 Doink
	.long	0				;7 spare
	REFLONG	lex_hitonground_anim		;8 Lex Luger

#*****************************************************************************
*
* #2 HEADBUTT

 SUBR	bam_2_butt_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP


	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B2BC3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B2BC3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B2BC3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	.word	ANI_STARTATTACK,AT_HDBUTT,12
	WL	3,B2BC3A+FR3
	WL	3,B2BC3A+FR4
	WL	3,B2BC3A+FR5
	WL	3,B2BC3A+FR6

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,5,79,40,19	;mode,x,y,w,h
	WL	3,B2BC3A+FR7
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit

	WL	ANI_SET_YVEL,38000h
	WL	6,B2BC3A+FR7
#no_hit
	WL	5,B2BC3A+FR7
	WL	3,B2BC3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 HEADBUTT

 SUBR	bam_4_butt_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B4BC3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B4BC3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B4BC3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	.word	ANI_STARTATTACK,AT_HDBUTT,12
	WL	3,B4BC3A+FR2
	WL	3,B4BC3A+FR3
	WL	3,B4BC3A+FR4
	WL	3,B4BC3A+FR5

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,5,79,40,19	;mode,x,y,w,h
	WL	3,B4BC3A+FR6
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2

	WL	ANI_SET_YVEL,38000h
	WL	6,B4BC3A+FR6
#no_hit2
	WL	5,B4BC3A+FR6
	WL	3,B4BC3A+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 HEADBUTTS - In close

 SUBR	bam_2_butts_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	.word	ANI_SET_RPTCOUNT,3	;5 times
#rpt
	.word	ANI_CLR_BUTCOUNT

	.word	ANI_STARTATTACK,AT_HDBUTT,6
	WL	2,B2BC3A+FR2
	WL	1,B2BC3A+FR3
	WL	2,B2BC3A+FR4
	WL	1,B2BC3A+FR5
	WL	2,B2BC3A+FR6

	.word	ANI_ATTACK_ON, AMODE_HDBUTT_STAY,5,79,40,19	;mode,x,y,w,h
	WL	2,B2BC3A+FR7
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit
	WL	ANI_SET_YVEL,38000h
	WL	6,B2BC3A+FR7
#no_hit
	WL	ANI_IFNOTSTATUS,#missed
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

	.word	ANI_SET_ATTACH
	.word	ANI_DEBRISAT,200,2,0,100,0	;%chance, tbl index, x,y,z off
	WL	ANI_CODE,create_impact
	WL	ANI_CODE,impact_sound
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,25
	.word	ANI_DETACH

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#ex
	.word	ANI_DEC_RPTCOUNT

	WL	2,B2BC3A+FR7
	WL	2,B2BC3A+FR8

	WL	ANI_IF_RPTCOUNT,#rpt
	WL	ANI_CHANGEANIM,bam_2_knee_anim

#ex
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,40000h,38000h,0h		;x,y,z vels

	WL	3,B2BC3A+FR7
	WL	3,B2BC3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WLLL	ANI_SETOPPVELS,50000h,18000h,0h		;x,y,z vels
;	WL	3,B2BC3A+FR7
#missed
	WL	2,B2BC3A+FR7
	WL	2,B2BC3A+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#* #4 HEADBUTT

 SUBR	bam_4_butts_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	.word	ANI_SET_RPTCOUNT,3	;5 times
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
#rpt
	.word	ANI_CLR_BUTCOUNT
	.word	ANI_STARTATTACK,AT_HDBUTT,6
	WL	2,B4BC3A+FR1
	WL	1,B4BC3A+FR2
	WL	2,B4BC3A+FR3
	WL	1,B4BC3A+FR4
	WL	2,B4BC3A+FR5
	.word	ANI_ATTACK_ON, AMODE_HDBUTT_STAY,5,79,40,19	;mode,x,y,w,h
	WL	2,B4BC3A+FR6
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

	WL	ANI_CODE,create_impact

	.word	ANI_SET_ATTACH
	.word	ANI_DEBRISAT,100,2,0,100,0	;%chance, tbl index, x,y,z off
	WL	ANI_CODE,impact_sound
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,25
	.word	ANI_DETACH

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2

	WL	ANI_SET_YVEL,38000h
	WL	6,B4BC3A+FR6
#no_hit2

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#ex
	.word	ANI_DEC_RPTCOUNT

	WL	2,B4BC3A+FR6
	WL	2,B4BC3A+FR7

	WL	ANI_IF_RPTCOUNT,#rpt
	WL	ANI_CHANGEANIM,bam_4_knee_anim
#ex
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,40000h,38000h,0h		;x,y,z vels

	WL	3,B4BC3A+FR6
	WL	3,B4BC3A+FR7
   
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WLLL	ANI_SETOPPVELS,50000h,18000h,0h		;x,y,z vels
;	WL	3,B4BC3A+FR6
#missed
	WL	2,B4BC3A+FR6
	WL	2,B4BC3A+FR7
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 KICK - Against TB attacks

 SUBR	bam_kick_TB_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETPLYRMODE,MODE_INAIR2
	.word	ANI_STARTATTACK,AT_LEAPING,12

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	WL	3,B2KM3B+FR2
	WL	ANI_SET_YVEL,70000h
	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL
	WL	2,B2KM3B+FR2
	WL	2,B2KM3B+FR3
	WL	2,B2KM3B+FR4
	.word	ANI_ATTACK_ON, AMODE_SPINKICK,35,65,66,43	;mode,x,y,w,h
	WL	10,B2KM3B+FR5
	.word	ANI_ATTACK_OFF
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	3,B2KM3B+FR6
	WL	2,B2KM3B+FR7
	WL	3,B2KM3B+FR8
	WL	2,B2KM3B+FR9
	WL	3,B2KM3B+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 KICK

 SUBR	bam_2_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP


	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B2KM3B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B2KM3B+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
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

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2
	WL	ANI_SET_YVEL,30000h
	WL	6,B2KM3B+FR5

#no_hit2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,B2KM3B+FR6
	WL	2,B2KM3B+FR7
	WL	3,B2KM3B+FR8
	WL	2,B2KM3B+FR9
	WL	3,B2KM3B+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #4 KICK

 SUBR	bam_4_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP


	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B4KM3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B4KM3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
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

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2
	WL	ANI_SET_YVEL,30000h
	WL	6,B4KM3A+FR5

#no_hit2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,B4KM3A+FR6
	WL	2,B4KM3A+FR7
	WL	3,B4KM3A+FR8
	WL	2,B4KM3A+FR9
	WL	3,B4KM3A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#************
*
* #2 SUPER KARATE KICK

 SUBR	bam_2_superkick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	3,B2BG3A+FR1

* #4 SUPER KARATE KICK

 SUBR	bam_4_superkick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_LEAPING,10
	WL	2,B4KM3E+FR1

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,999,65-5,40,90000h,TGT_HEAD,64,82,10
;	WLW	ANI_SET_ZVEL,0h,AM_ABS
	WL	ANI_SET_YVEL,30000h
	.word	ANI_FRICTION,4000h
	WL	4,B4KM3E+FR2
	WL	3,B4KM3E+FR3
	.word	ANI_ATTACK_ON, AMODE_SUPER_KICK,12,58,60,40	;mode,x,y,w,h
	WL	2,B4KM3E+FR5
	WLW	ANI_SET_ZVEL,0h,AM_ABS
	WL	5,B4KM3E+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

;hit
	WL	ANI_CODE,create_impact2
	WL	ANI_CODE,DO_FLAME_HIT_SND
	WL	ANI_CODE,CALL_NASTY_MOVE

	.word	ANI_ZEROVELS
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2
	WL	ANI_SET_YVEL,30000h
	WL	7,B4KM3E+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

#no_hit2

	WL	ANI_CODE,CALL_MISSES
	.word	ANI_WAITHITGND
	WL	3,B4KM3E+FR5


	WL	ANI_CODE,skick_delay
	WL	ANI_IFNOTSTATUS,#none
	WL	20,B4KM3E+FR5
#none

	WL	2,B4KM3E+FR6
	WL	3,B4KM3E+FR7
	WL	2,B4KM3E+FR7
	WL	3,B4KM3E+FR8
	WL	2,B4KM3E+FR9
	WL	3,B4KM3E+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#missedb
	WWL	ANI_SLIDE_BACK,30h,-70000h,#missed
	WL	ANI_SET_YVEL,30000h
	WL	7,B4KM3E+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

#missed
	WL	ANI_CODE,CALL_MISSES
	WL	3,B4KM3E+FR5
	.word	ANI_WAITHITGND
	WL	ANI_CODE,skick_delay
	WL	ANI_IFNOTSTATUS,#none2
	WL	20,B4KM3E+FR5
#none2
	WL	3,B4KM3E+FR6
	WL	2,B4KM3E+FR7
	WL	3,B4KM3E+FR8
	WL	2,B4KM3E+FR9
	WL	3,B4KM3E+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


 SUBR	bam_combo_superkick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_STARTATTACK,AT_KICK,10
	WLW	ANI_SET_XVEL,10000h,AM_FACE_REL
	WL	ANI_CODE,DO_FLAME_SND
	WL	2,B4KM3E+FR1

	WL	2,B4KM3E+FR2
	WL	2,B4KM3E+FR3
	.word	ANI_ATTACK_ON, AMODE_KICK,12,28,60,60	;mode,x,y,w,h
	WL	1,B4KM3E+FR5
	WLW	ANI_SET_XVEL,0000h,AM_ABS
	WLW	ANI_SET_ZVEL,0h,AM_FACE_REL
	WL	2,B4KM3E+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missedc
	WL	ANI_IFBLOCKED,#missedc		;Yes, I hit blocker
	WL	ANI_CODE,DO_FLAME_HIT_SND
	.WORD	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,20000h,0h		;x,y,z vels

	WL	ANI_CODE,create_impact2

	WL	2,B4KM3E+FR5
	WL	2,B4KM3E+FR6
	WL	2,B4KM3E+FR7
	WL	2,B4KM3E+FR8
	WL	2,B4KM3E+FR9
	WL	2,B4KM3E+FR10
	.word	ANI_SET_RPTCOUNT,3	;3 times
#k_loop
	.word	ANI_CLR_BUTCOUNT
	.word	ANI_STARTATTACK,AT_KICK,10
	WLW	ANI_SET_XVEL,10000h,AM_FACE_REL
	WL	ANI_CODE,DO_FLAME_SND
	WL	1,B4KM3E+FR1

	WL	1,B4KM3E+FR2
	WL	2,B4KM3E+FR3
	.word	ANI_ATTACK_ON, AMODE_KICK,12,28,60,60	;mode,x,y,w,h
	WL	1,B4KM3E+FR5
	WLW	ANI_SET_XVEL,0000h,AM_ABS
	WLW	ANI_SET_ZVEL,0h,AM_FACE_REL
	WL	1,B4KM3E+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missedc
	WL	ANI_IFBLOCKED,#missedc		;Yes, I hit blocker
	WL	ANI_CODE,DO_FLAME_HIT_SND
	.WORD	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,20000h,0h		;x,y,z vels

	WL	ANI_CODE,create_impact2

	WL	1,B4KM3E+FR5
	WL	1,B4KM3E+FR6
	WL	1,B4KM3E+FR7
	WL	1,B4KM3E+FR8
	WL	1,B4KM3E+FR9
	WL	1,B4KM3E+FR10

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#k_loop

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#CHECK_NEXT2
	.word	ANI_DETACH
	WL	ANI_CHANGEANIM,bam_combo_hiptoss_anim

#CHECK_NEXT2
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#CHECK_NEXT1A
	.word	ANI_DETACH
	WL	ANI_CHANGEANIM,bam_flying_kick_no_xvel

#CHECK_NEXT1A
	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#CHECK_NEXT1
	WL	ANI_CHANGEANIM,bam_combo_pogo_anim

#CHECK_NEXT1
	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#NOT_HIT_AT_ALL
	WLW	ANI_SET_XVEL,8000h,AM_FACE_REL
	WL	ANI_CHANGEANIM,bam_combo_slap_anim_no_vel

#NOT_HIT_AT_ALL
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_DETACH
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedc
	WL	ANI_CODE,CALL_MISSES
	WL	3,B4KM3E+FR5
	.word	ANI_WAITHITGND
	WL	3,B4KM3E+FR6
	WL	3,B4KM3E+FR7
	WL	3,B4KM3E+FR8
	WL	3,B4KM3E+FR9
	WL	3,B4KM3E+FR10

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_DETACH
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #2 & #4 TURBO KICK

 SUBR	bam_4_jumpkick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

;;;	.word	ANI_SLOWMO,2
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_LEAPING,19
	WL	3,B4KM3H+FR2
	WL	3,B4KM3H+FR3
	WL	3,B4KM3H+FR4

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 10,999,100,54,90000h,TGT_HEAD,70,100,20
	WL	ANI_CODE,no_bk_xvel

	WL	4,B4KM3H+FR5
	WL	3,B4KM3H+FR6
	WL	3,B4KM3H+FR7


	.word	ANI_ATTACK_ON, AMODE_JUMPKICK,49,87,34,20	;mode,x,y,w,h
	WL	3,B4KM3H+FR9
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_slide
	WL	ANI_SET_YVEL,30000h
#no_slide

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb

	.word	ANI_SHAKER,35

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

#missedb
	WL	6,B4KM3H+FR9
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
#missed
	WL	6,B4KM3H+FR9
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

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

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2

	.word	ANI_STARTATTACK,AT_LEAPING,20
	WL	3,B3DC3B+FR4

;	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 14,999,145,65,90000h,TGT_HEAD,57,75,0
	WL	ANI_CODE,no_bk_xvel

	WL	4,B3DC3B+FR5
	WL	5,B3DC3B+FR6
	.word	ANI_OFFSET,0,50,0			;x,y,z
	WL	3,B3DC3B+FR7


;	.word	ANI_ATTACK_ON, AMODE_FLYKICK,53,-10,27,49 ;mode,x,y,w,h
	.word	ANI_ATTACK_ON,AMODE_FLYKICK,-34,16,110,36
	WL	3,B3DC3B+FR8
	.word	ANI_ATTACK_OFF

	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker
	WL	ANI_IFNOTSTATUS,#hit
;A hit
	WL	ANI_CODE,create_impact_flykick
	WL	ANI_GOTO,#hit
#missedb
;	.word	ANI_ZERO_XZVELS
	WLW	ANI_SET_ZVEL,0,AM_ABS
#hit

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
	WL	2,B3GU2A+FR6
	WL	3,B3GU2A+FR7
	WL	2,B3GU2A+FR8
	WL	3,B3GU2A+FR9

;Check for a flip here
	WL	1,B3GU2A+FR10
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	1,B3GU2A+FR10

	WL	2,B3GU2A+FR10
	WL	3,B3GU2A+FR11
	WL	2,B3GU2A+FR12
	WL	3,B3GU2A+FR13

	.word	ANI_SAFE_TIME,30

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,36,85,49,17
	WL	1,B3GU2A+FR13
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,bam_4_push_anim
#no_freetoss

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBRP	bam_flying_kick_no_xvel

	.word	ANI_STARTATTACK,AT_LEAPING,20
	WLW	ANI_SET_XVEL,20000h,AM_FACE_REL
	WL	ANI_SET_YVEL,44000h
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	WL	4,B3DC3B+FR5
	WL	7,B3DC3B+FR6
	.word	ANI_OFFSET,0,50,0			;x,y,z
	WL	3,B3DC3B+FR7

	.word	ANI_CLR_STATUS

	.word	ANI_ATTACK_ON, AMODE_FLYKICK,53,-10,27,49 ;mode,x,y,w,h
	WL	3,B3DC3B+FR8
	.word	ANI_ATTACK_OFF
	.WORD	ANI_INC_COMBO
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	3,B3DC3B+FR9
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_BOUNCE,3

	WL	3,B3DC3B+FR11
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT

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

	.word	ANI_SAFE_TIME,30

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss1
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,36,85,49,17
	WL	1,B3GU2A+FR13
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss1

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,bam_4_push_anim
#no_freetoss1

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #2 STOMP ON FALLEN OPPONENT

 SUBR	bam_2_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B2MP2A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B2MP2A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B2MP2A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	.word	ANI_STARTATTACK,AT_STOMP,12
	WL	2,B2MP2A+FR2

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,13,0,-40,22,28,50
	WL	1,B2MP2A+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#leapat_stomp

	WL	3,B2MP2A+FR3
	WL	3,B2MP2A+FR4
	WL	3,B2MP2A+FR5
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
	WL	3,B2MP2A+FR6
	WL	3,B2MP2A+FR7
	WL	3,B2MP2A+FR8
	WL	3,B2MP2A+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END



#leapat_stomp
	.word	ANI_TARGET,TGT_CHEST,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,160,140,40000h,TGT_USER,24,0,-30
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
	WL	3,B2MP2A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,B2MP2A+FR7
	WL	3,B2MP2A+FR8
	WL	3,B2MP2A+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 STOMP ON FALLEN OPPONENT

 SUBR	bam_4_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B4MP4A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B4MP4A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B4MP4A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	WL	2,B4MP4A+FR2
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2

	.word	ANI_ATTACK_ON_Z,AMODE_HITCHECK,-3,-5,-10,46,35,50
	WL	1,B4MP4A+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#leapat

	.word	ANI_STARTATTACK,AT_STOMP,8
	WL	3,B4MP4A+FR3
	WL	3,B4MP4A+FR4
	WL	2,B4MP4A+FR5
	.word	ANI_ATTACK_ON_Z,AMODE_STOMP,-3,-5,-10,46,35,50
	WL	1,B4MP4A+FR6
	.word	ANI_ATTACK_OFF
	WL	ANI_GOTO,#common

#leapat
	.word	ANI_TARGET,TGT_CHEST,TGT_GROIN,ATM_CLOSEST
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,160,140,40000h,TGT_USER,12,0,30
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
	.word	ANI_SHAKER,25
	.word	ANI_SHAKEALL,1
	WL	ANI_GOTO,#hit
#missed
	WL	ANI_CODE,CALL_MISSES
#hit
	WL	3,B4MP4A+FR6
	WL	3,B4MP4A+FR7
	WL	3,B4MP4A+FR8
	WL	3,B4MP4A+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

;#*****************************************************************************
;*
;* #2 BIG BOOT
;* #4 BIG BOOT
;
; SUBR	bam_4_bigboot_anim
;
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
;	.word	ANI_SETSPEED,100h
;	.word	ANI_ZEROVELS
;
;	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
;	.word	ANI_SET_WRESTLER_XFLIP
;
;	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
;	.word	ANI_STARTATTACK,AT_BIGBOOT,12
;	WL	2,B4KM3A+FR1
;	WL	2,B4KM3A+FR2
;	WL	2,B4KM3A+FR3
;	WL	2,B4KM3A+FR4
;
;	WL	ANI_CODE,#clrcnt
;	WL	ANI_SET_YVEL,20000h
;	.word	ANI_ATTACK_ON, AMODE_BIGBOOT,37,62,62,35	;mode,x,y,w,h
;	WWL	ANI_WAITHITOPP,10,B4KM3A+FR5
;;	.word	ANI_WAITHITGND
;;	.word	ANI_ZEROVELS
;#lp0
;	.word	ANI_STARTATTACK,AT_BIGBOOT,5
;	WL	2,B4KM3A+FR5
;	WL	ANI_CODE,#holdup
;	WL	ANI_IFSTATUS,#lp0
;	.word	ANI_ATTACK_OFF
;	WL	ANI_IFNOTSTATUS,#missed
;	.word	ANI_DRAW_NAME,27
;#missed
;
;	WL	3,B4KM3A+FR6
;	WL	3,B4KM3A+FR7
;	WL	3,B4KM3A+FR8
;	WL	3,B4KM3A+FR9
;	WL	3,B4KM3A+FR10
;
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END
;
;#clrcnt
;;We are re-using BUT_COUNT in the player process
;	clr	a0
;	move	a0,*a13(BUT_COUNT)
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
;

#*****************************************************************************
*
* #2 KNEE

 SUBR	bam_2_knee_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_KNEE,6

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B2NM3A+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B2NM3A+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B2NM3A+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 21,999,36,30,90000h,TGT_CHEST,56,74+10,0

	WL	3,B2NM3A+FR4

	.word	ANI_ATTACK_ON, AMODE_KNEE,34,31,52,51	;mode,x,y,w,h
	WL	3,B2NM3A+FR5
	.word	ANI_ATTACK_OFF
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit
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

 SUBR	bam_4_knee2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_KNEE,6

	WL	1,B4NM3A+FR2
	WL	ANI_GOTO,#cont2a

 SUBR	bam_4_knee_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_KNEE,6

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B4NM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B4NM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,B4NM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
#cont2a
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 21,999,36,20,90000h,TGT_CHEST,46,74+10,0
	WL	3,B4NM3A+FR3
	WL	3,B4NM3A+FR4

	.word	ANI_ATTACK_ON, AMODE_KNEE,29,32,46,40	;mode,x,y,w,h
	WL	3,B4NM3A+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2
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

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	.word	ANI_STARTATTACK,AT_PUPPET,10

	WL	2,B1TT5Z+FR2
	WL	2,B1TT5Z+FR3
	WL	ANI_GOTO,#cont

 SUBR	bam_4_grabfling_anim

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

	WL	5,B4GF3A+FR1

	.word	ANI_ATTACK_ON, AMODE_PUPPET_NOFLAIL,33,56,44,18 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,6,B4GF3A+FR2
	.word	ANI_ZERO_XZVELS
	WWL	ANI_WAITHITOPP,2,B4GF3A+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missedb
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

;got him
	WL	ANI_CODE,DO_GRUNT
	WL	ANI_CODE,CALL_SETUP
	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

; attacker sequence
	WWLLW	ANI_SUPERSLAVE2,10,B4GF3A+FR4,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,5,B4GF3A+FR5,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,B4GF3A+FR6,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,B4GF3A+FR7,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,B4GF3A+FR8,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,B4GF3A+FR9,#puppet_tbl,5

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	WL	ANI_SLAVEANIM,#strt_run_tbl

	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_DETACH
	WL	6,B4GF3A+FR9
	WL	4,B4GF3A+FR11

	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#missedb
	WL	ANI_CODE,fling_delay
	WL	ANI_IFNOTSTATUS,#missed
	WL	25,B4GF3A+FR3
#missed
	WL	ANI_CODE,CALL_MISSES
	WL	6,B4GF3A+FR3
	WL	3,B4GF3A+FR2
	WL	3,B4GF3A+FR1

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
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung


#*****************************************************************************
*
* #2 HEAD HIT

 SUBR	bam_2_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

	WL	3,B2AH2A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,B2AH2A+FR2
	WL	2,B2AH2A+FR3
	WL	3,B2AH2A+FR4
	WL	2,B2AH2A+FR5
	WL	3,B2AH2A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 HEAD HIT

 SUBR	bam_4_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,B4AH4A+FR1
	WL	2,B4AH4A+FR2
	WL	3,B4AH4A+FR3
	WL	2,B4AH4A+FR4
	WL	3,B4AH4A+FR5
	WL	2,B4AH4A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #2 HEAD HIT - From spin kick

 SUBR	bam_2_head_hit2_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,40000h

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off
	WL	3,B2AH2A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,B2AH2A+FR2
	WL	1,B2AH2A+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,B2AH2A+FR4
	WL	2,B2AH2A+FR5
	WL	2,B2AH2A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* #4 HEAD HIT - From spin kick

 SUBR	bam_4_head_hit2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-20000h,AM_ABS
	WL	ANI_SET_YVEL,40000h

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,B4AH4A+FR1
	WL	3,B4AH4A+FR2
	WL	1,B4AH4A+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,B4AH4A+FR4
	WL	2,B4AH4A+FR5
	WL	2,B4AH4A+FR6


	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_4_head_hit4_anim
;From earslap

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

;	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
;	WLW	ANI_SET_ZVEL,-20000h,AM_ABS
	WL	ANI_SET_YVEL,40000h

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	4,B4AH4A+FR3
;	.word	ANI_WAITHITGND
;	.word	ANI_ZEROVELS
	WL	3,B4AH4A+FR4
	WL	3,B4AH4A+FR5
	WL	3,B4AH4A+FR6

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* HEAD HIT2 (HANDS ON FACE)

 SUBR	bam_head_hit2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WLW	ANI_SET_XVEL,-40000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h
	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

	WL	3,B3AE3A+FR2
	WL	2,B3AE3A+FR3
	WL	3,B3AE3A+FR4
	WL	2,B3AE3A+FR5
	WL	3,B3AE3A+FR6
	WL	2,B3AE3A+FR7
	WL	3,B3AE3A+FR8
	WL	2,B3AE3A+FR9
	WL	3,B3AE3A+FR10
	WL	2,B3AE3A+FR11
	WL	2,B3AE3A+FR12

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,bam_fall_back_anim
;	.word	ANI_END

#nodead
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_head_hit2s_anim
;Salt hits me in face

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	ANI_CODE,create_impact_salt
 
	WL	4,B3AE3A+FR2
	WL	4,B3AE3A+FR3
	WL	4,B3AE3A+FR4
	WL	4,B3AE3A+FR5
	WL	4,B3AE3A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_FRICTION,4000h
	WL	50,B3AE3A+FR6
	.word	ANI_ZEROVELS
	WL	3,B3AE3A+FR7
	WL	3,B3AE3A+FR8
	WL	3,B3AE3A+FR9
	WL	3,B3AE3A+FR10
	WL	3,B3AE3A+FR11
	WL	3,B3AE3A+FR12

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#************
*
* HEAD HIT2 (ENDS IN DIZZY)

 SUBR	bam_head_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

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

;	.word	ANI_END


#*****************************************************************************
*
* #2 BODY HIT

 SUBR	bam_2_body_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL

	WL	ANI_CODE,ckzpos
     
	WL	3,B2AM2A+FR1
	WL	3,B2AM2A+FR2
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	3,B2AM2A+FR3
	WL	1,B2AM2A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,B2AM2A+FR5
	WL	2,B2AM2A+FR6
	WL	2,B2AM2A+FR7
	WL	2,B2AM2A+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 BODY HIT

 SUBR	bam_4_body_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL

	WL	ANI_CODE,ckzpos

	WL	3,B4AM4A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	3,B4AM4A+FR2
	WL	3,B4AM4A+FR3
	WL	1,B4AM4A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,B4AM4A+FR5
	WL	2,B4AM4A+FR6
	WL	2,B4AM4A+FR7
	WL	2,B4AM4A+FR8

	.word	ANI_CHECKWORD,USR_VAR1
	WL	ANI_IFNOTSTATUS,#reg

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

#reg
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


* #4 BODY HIT - DIZZY

 SUBR	bam_4_body_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	ANI_CODE,ckzpos

	WL	3,B4AM4A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
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

;	.word	ANI_END


 SUBR	bam_2_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,8000h,AM_ABS

	WL	ANI_CODE,ckzpos

	WL	3,B2AM2A+FR1
	WL	3,B2AM2A+FR2
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	3,B2AM2A+FR3
	WL	1,B2AM2A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,B2AM2A+FR5
	WL	2,B2AM2A+FR6
	WL	2,B2AM2A+FR7
	WL	2,B2AM2A+FR8

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_4_knee_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-8000h,AM_ABS
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	ANI_CODE,ckzpos

	WL	3,B4AM4A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
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
;	.word	ANI_END

* #4 BODY HIT

 SUBR	bam_4_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-8000h,AM_ABS

	WL	ANI_CODE,ckzpos

	WL	3,B4AM4A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	3,B4AM4A+FR2
	WL	3,B4AM4A+FR3
	WL	1,B4AM4A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,B4AM4A+FR5
	WL	2,B4AM4A+FR6
	WL	2,B4AM4A+FR7
	WL	2,B4AM4A+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_quick_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h

	WL	3,B4AM4A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	3,B4AM4A+FR2
	WL	3,B4AM4A+FR3
	WL	3,B4AM4A+FR4
	WL	3,B4AM4A+FR5
	WL	3,B4AM4A+FR6
	WL	3,B4AM4A+FR7
	WL	3,B4AM4A+FR8

	.word	ANI_FACEDOWN

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,bam_fall_back_anim
;	.word	ANI_END

#nodead
	WL	ANI_CHANGEANIM,bam_3_head_held_anim
;	.word	ANI_END

#*****************************************************************************
*
* HITS ON GROUND

 SUBR	bam_hitonground_xflip_anim
	.word	ANI_XFLIP
	;fall through

 SUBR	bam_hitonground_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h

	WL	1,B3CP3B+FR1
	WL	ANI_SET_YVEL,39000h
	.word	ANI_DEBRIS,50,1,0,8,0		;%chance, tbl index, x,y,z off
	WL	2,B3CP3B+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPITUP_SWEAT,SWEAT_PER,0
	WL	3,B3CP3B+FR2
	WL	3,B3CP3B+FR3
	WL	2,B3CP3B+FR4
	WL	3,B3CP3B+FR5
	WL	2,B3CP3B+FR6
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	2,B3CP3B+FR7
 SUBR	bam_liedown_anim
	WL	1,B3RL1A+FR1		;1st frame of roll

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_faceup_getup_anim
;	.word	ANI_END

 SUBR	bam_up_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.WORD	ANI_XFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h
	WL	10,B4TD3B+FR4
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,B3CP3B+FR7
	WL	2,B3RL1A+FR1		;1st frame of roll

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_faceup_getup_anim
;	.word	ANI_END

#*****************************************************************************
*
* FALL BACK

 SUBR	bam_fall_back_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCOLLIS
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_SETSPEED,100h
	.word	ANI_ZERO_XZVELS
	WL	ANI_MIN_YVEL,68000h
	WLW	ANI_SET_ZVEL,10000h,AM_FACE_REL

	.word	ANI_SCROLL_CTRL,BAM_TBUKLY

	WL	ANI_CODE,ckzpos

	WWL	ANI_SETLONG,DEBRIS_X,[106,-29]	;Y,X of head
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYC_SWEAT,SWEAT_PER,0
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
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WWL	ANI_SETLONG,DEBRIS_X,0		;Y,X of head
	WL	1,B3RL1A+FR1
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_faceup_getup_anim
;	.word	ANI_END

 SUBR	bam_fall_back2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,18000h

	WLW	ANI_SET_ZVEL,18000h,AM_ABS
	WL	ANI_CODE,ckzpos

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYC_SWEAT,SWEAT_PER,0
	WL	4,B4UC3B+FR1
	.word	ANI_OFFSET,0,52,0
	WL	4,B4UC3B+FR2
	WL	4,B4UC3B+FR3
	WL	4,B4UC3B+FR4
	WL	4,B4UC3B+FR5
	.word	ANI_WAITHITGND

	.word	ANI_DEBRIS,100,1,0,8,0		;%chance, tbl index, x,y,z off

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
;	.word	ANI_END

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

	.word	ANI_DEBRIS,100,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,45

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

;	.word	ANI_CLR_STARS
;	.word	ANI_CLR_DAMAGE

	WL	3,B3GU2A+FR1
	WL	ANI_GOTO,#common2

 SUBR	bam_2_faceup_getup2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

;	.word	ANI_CLR_STARS
;	.word	ANI_CLR_DAMAGE

#common2
	WL	3,B3GU2A+FR2
	WL	2,B3GU2A+FR3
	WL	3,B3GU2A+FR4
	WL	2,B3GU2A+FR5
	WL	3,B3GU2A+FR6
	WL	2,B3GU2A+FR7
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WL	3,B3GU2A+FR8
	WL	2,B3GU2A+FR9

;Check for a flip here
	WL	1,B3GU2A+FR10
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,B3GU2A+FR10
	WL	2,B3GU2A+FR11
	WL	3,B3GU2A+FR12

	.word	ANI_SAFE_TIME,50

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss2
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,36,85,49,17
	WL	1,B3GU2A+FR12
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss2

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,bam_4_push_anim
#no_freetoss2

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_4_faceup_getup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

;	.word	ANI_CLR_STARS
;	.word	ANI_CLR_DAMAGE
	WL	3,B3GU4A+FR1
	WL	2,B3GU4A+FR2
	WL	3,B3GU4A+FR3
	WL	ANI_GOTO,#common4

 SUBR	bam_4_faceup_getup2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

;	.word	ANI_CLR_STARS
;	.word	ANI_CLR_DAMAGE

#common4
	WL	2,B3GU4A+FR4
	WL	3,B3GU4A+FR5
	WL	2,B3GU4A+FR6
#frame7
	WL	3,B3GU4A+FR7
	WL	2,B3GU4A+FR8
	WL	3,B3GU4A+FR9

;Check for a flip here
	WL	1,B3GU4A+FR10
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,B3GU4A+FR10
	WL	2,B3GU4A+FR11
	WL	3,B3GU4A+FR12

	.word	ANI_SAFE_TIME,50

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss3
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,36,85,49,17
	WL	1,B3GU4A+FR12
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss3

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,bam_4_push_anim
#no_freetoss3

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


 SUBR	bam_4_faceup_getup3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

;	.word	ANI_CLR_STARS
;	.word	ANI_CLR_DAMAGE
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

#*****************************************************************************
*
* Get tossed out of ring from Shawn's Frankensteiner
*

 SUBR	bam_rxn2_fsteiner_anim

	.word	ANI_END

#*****************************************************************************
*
* #2 BLOCK

; SUBR	bam_2_block_anim
;
;	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
;	.word	ANI_ZERO_XZVELS
;	.word	ANI_SETSPEED,100h
;
;	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
;	.word	ANI_SET_WRESTLER_XFLIP
;;Rotate toward opponent if needed!
;
;	WL	ANI_CODE,block_if_safe
;	WL	3,B2BK3B+FR1
;	.word	ANI_SETPLYRMODE,MODE_BLOCK
;	WL	3,B2BK3B+FR2
;#blk2	WL	3,B2BK3B+FR3
;	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT
;	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
;	.word	ANI_SETMODE,MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_SETFACING
;	WL	3,B2BK3B+FR2
;	WL	3,B2BK3B+FR1
;	.word	ANI_SETPLYRMODE,MODE_NORMAL
;	.word	ANI_END
;
; SUBR	bam_2_hitblock_anim
;
;	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
;	.word	ANI_FRICTION,4000h
;	.word	ANI_SETSPEED,100h
;
;	WL	ANI_CODE,DO_BLOCKED
;	WL	2,B2BK3B+FR4
;	WL	2,B2BK3B+FR5
;	WL	2,B2BK3B+FR4
;	WL	ANI_GOTO,#blk2


* #4 BLOCK

 SUBR	bam_4_block_anim

	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
	.word	ANI_ZERO_XZVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
;Rotate toward opponent if needed!

;	WL	ANI_CODE,block_if_safe
	.word	ANI_SETPLYRMODE,MODE_BLOCK
	WL	2,B4BK3D+FR2
	WL	1,B4BK3D+FR3
;	.word	ANI_SETPLYRMODE,MODE_BLOCK
	WL	1,B4BK3D+FR3
#blk4	WL	2,B4BK3D+FR4
	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT|MODE_FRICTION
;	.word	ANI_ZERO_XZVELS
	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
	.word	ANI_SETMODE,MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETFACING
	WL	2,B4BK3D+FR3
	WL	2,B4BK3D+FR2
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_4_hitblock_anim

	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
	.word	ANI_FRICTION,5000h
	.word	ANI_SETSPEED,100h
	WL	ANI_CODE,DO_BLOCKED
	WL	1,B4BK3D+FR6
	WL	1,B4BK3D+FR7
	WL	1,B4BK3D+FR8
	WL	1,B4BK3D+FR7
	WL	1,B4BK3D+FR6
	WL	ANI_GOTO,#blk4

 SUBR	bam_4_hitblock2_anim

	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
	.word	ANI_FRICTION,4000h
	.word	ANI_SETSPEED,100h
	WL	ANI_CODE,DO_BLOCKED
	WL	ANI_SET_YVEL,38000h
	WL	3,B4BK3D+FR6
	WL	3,B4BK3D+FR7
	WL	3,B4BK3D+FR8
	WL	3,B4BK3D+FR7
	WL	3,B4BK3D+FR6
	WL	3,B4BK3D+FR7
	WL	3,B4BK3D+FR6
	WL	ANI_GOTO,#blk4


#*****************************************************************************
*
* THROWN FROM RING (shn_bslm, shn_frnk, lex_vsup)

 SUBR	bam_flyout_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETSPEED,100h

	.word	ANI_SET_IDIOT
	WWL	ANI_SETLONG,OBJ_GRAVITY,0E000h
	WL	ANI_CODE,DO_WAIL

	WL	7,B4TD3B+FR5
	WL	7,B4TD3B+FR6
	WL	7,B4TD3B+FR7
#cont	WL	1,B4TD3B+FR8
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,60
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

	.word	ANI_DAMAGE,D_HIPTOSS

;	.word	ANI_SETWORD,DELAY_METER,0
;	.word	ANI_GETUP,500

	.word	ANI_OFFSET,10,0,0
	WL	3,B4TD3B+FR9
	WL	ANI_CHANGEANIM,bam_hitonground_xflip_anim


 SUBR	bam_flyout2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETSPEED,100h

	.word	ANI_SET_IDIOT
	WWL	ANI_SETLONG,OBJ_GRAVITY,0E000h
	WL	ANI_CODE,DO_WAIL
	WL	ANI_GOTO,#cont

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

	.word	ANI_GETUP,STAY_TIME
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
;	.word	ANI_END

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
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_GETUP,STAY_TIME
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
;	.word	ANI_END

#*****************************************************************************
*

 SUBR	bam_knockdwn_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
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
;	.word	ANI_END

#*****************************************************************************
 SUBR	bam_climbthru_side_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	ANI_CODE,SET_DIR_FACE
	.word	ANI_SETFACING
	.WORD	ANI_SET_WRESTLER_XFLIP

	WLW	ANI_SET_XVEL,3800h,AM_FACE_REL

	.word	ANI_OFFSET,16,0,0
	WL	2,B4CR7A+FR2
	.word	ANI_BENDROPE,0
	.word	ANI_OFFSET,3,0,0	;*****
	WL	3,B4CR7A+FR3		
	.word	ANI_OFFSET,3,0,0	;*****
	WL	2,B4CR7A+FR4

	.word	ANI_BENDROPE,2
	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH

	.word	ANI_OFFSET,5,0,0	;*****
	WL	3,B4CR7A+FR5

	.word	ANI_OFFSET,3,0,0	;*****
	WL	2,B4CR7A+FR6
	.word	ANI_BENDROPE,2
	.word	ANI_OFFSET,3,0,0	;*****
	WL	3,B4CR7A+FR7
	.word	ANI_OFFSET,4,0,0	;*****
	WL	2,B4CR7A+FR8
	.word	ANI_BENDROPE,3
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH
	.word	ANI_OFFSET,5,0,0	;*****
	WL	3,B4CR7A+FR9
	.word	ANI_OFFSET,5,0,0	;*****
	WL	2,B4CR7A+FR10
	.word	ANI_ZEROVELS
	.word	ANI_BENDROPE,-1
	.word	ANI_OFFSET,10,-3,0
	WL	3,B4CR7A+FR11
	.word	ANI_OFFSET,2,0,0	;*****
	WL	2,B4CR7A+FR12

	.word	ANI_SET_IDIOT
	;now jump off...
;	WL	2,B2JD4A+FR1		;D4FM4A+FR1
	WL	3,B2JD4A+FR2
	WL	3,B2JD4A+FR3

	WL	ANI_SET_YVEL,60000h

	WLW	ANI_SET_XVEL,30000h,AM_FACE_REL
	WWL	ANI_SETLONG,OBJ_GRAVITY,0E000h

	WL	3,B2JD4A+FR4
	.word	ANI_WAITHITGND
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

	.word	ANI_ROPE_Z,R_TOP,RZ_NORM
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM

	.word	ANI_ZEROVELS
	WL	3,B2JD4A+FR6
;	WL	2,B2JD4A+FR7
	WL	3,B2JD4A+FR8
;	WL	2,B2JD4A+FR9

	.word	ANI_FACEDOWN

	.word	ANI_CLEAR_CLIMB
	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	bam_climbin_side_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	ANI_CODE,SET_DIR_FACE
	.word	ANI_SETFACING
	.WORD	ANI_SET_WRESTLER_XFLIP

	;jump in
;	WL	2,B2JD4A+FR1
	WL	3,B2JD4A+FR2
	WL	3,B2JD4A+FR3

	WWL	ANI_SETLONG,OBJ_GRAVITY,0E000h
	WL	ANI_CODE,#set_trgt
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	.word	ANI_LEAPATPOS,14h,200,0,0,0	;#ticks,dist,xoff,yoff,zoff

	WL	2,B2JD4A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH

	WL	3,B2JD4A+FR6
;	WL	2,B2JD4A+FR7
	.word	ANI_OFFSET,13,0,0	;*****
	WL	3,B2JD4A+FR8
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM

	WLW	ANI_SET_XVEL,3000h,AM_FACE_REL

	;climb through
	.word	ANI_OFFSET,3,0,0	;*****
	WL	2,B4CR7A+FR2
	.word	ANI_BENDROPE,0
	.word	ANI_OFFSET,3,0,0	;*****
	WL	3,B4CR7A+FR3
	.word	ANI_OFFSET,3,0,0	;*****
	WL	2,B4CR7A+FR4
	.word	ANI_OFFSET,3,0,0	;*****
	WL	3,B4CR7A+FR5

	.word	ANI_BENDROPE,2

	.word	ANI_OFFSET,3,0,0	;*****
	WL	2,B4CR7A+FR6
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH
	.word	ANI_BENDROPE,2
	.word	ANI_OFFSET,5,0,0	;*****
	WL	3,B4CR7A+FR7
	.word	ANI_OFFSET,5,0,0	;*****
	WL	2,B4CR7A+FR8
	.word	ANI_BENDROPE,3
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM
	.word	ANI_OFFSET,5,0,0	;*****
	WL	3,B4CR7A+FR9
	.word	ANI_OFFSET,5,0,0	;*****
	WL	2,B4CR7A+FR10
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_BENDROPE,-1
	.word	ANI_OFFSET,10,-3,0
	WL	3,B4CR7A+FR11
	WL	2,B4CR7A+FR12
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

 SUBR	bam_climbthru_bot_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
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
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOSHADOW|MODE_NOCOLLIS
	.word	ANI_SET_IDIOT

	;climb through
	.WORD	ANI_XFLIP
	WL	ANI_CODE,NOT_IN_RING
	.word	ANI_OFFSET,20,-37h,0			;x,y,z
	WL	3,B2KM3E+FR6
	WL	3,B2KM3E+FR3
	WL	3,B2KM3E+FR2
	.WORD	ANI_XFLIP

	.word	ANI_CLEAR_CLIMB
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

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
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

;	WL	ANI_CODE,clr_climb
	.word	ANI_CLEAR_CLIMB

	.WORD	ANI_FACEDOWN
	.word	ANI_ZEROVELS
	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	bam_climbthru_top_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
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
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOSHADOW|MODE_NOCOLLIS
	WL	3,B3RL1A+FR9
	WL	3,B3RL1A+FR8
	WL	3,B3RL1A+FR7

	.word	ANI_SET_IDIOT
	;climb through
	.word	ANI_ZEROVELS
	.word	ANI_OFFSET,0,-61,0
	.WORD	ANI_XFLIP
	WL	3,B4KM3E+FR2
	WL	3,B4KM3E+FR1
	.WORD	ANI_XFLIP

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

 SUBR	bam_rollthru_top_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;roll over once
	WLW	ANI_SET_ZVEL,-50000h,AM_ABS
	WL	3,B3RL1A+FR11
	WL	3,B3RL1A+FR10
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOSHADOW|MODE_NOCOLLIS
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

#*****************************************************************************

 SUBR	bam_climbin_top_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
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

 SUBR	bam_2_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;Rotate!
	WL	3,B1TT5Z+FR2	;2.5
	WL	3,B1TT5Z+FR3	;3.5

 SUBR	bam_4_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 25,999,80h,50h,90000h,TGT_CHEST|TGT_GROUND,0,57,-15
	WL	ANI_CODE,hit_nearest

	WL	3,B2PN5A+FR3
	.word	ANI_OFFSET,0,34,0			;x,y,z
	WL	22,B2PN5A+FR4
;	.word	ANI_WAITHITGND
;	.word	ANI_ATTACK_ON_Z, AMODE_STOMP,-40,-8,0,76,20,30 ;mode,x,y,z,w,h,d
	.word	ANI_ZEROVELS

;	WLW	ANI_ATTCHIMAGE,D4PN5L+FR4,10		;image, zoff (priority)
	WL	3,B2PN5A+FR5
	WL	ANI_CODE,DO_CROWD_CHEER

;	.word	ANI_ATTACK_OFF
	WL	ANI_CODE,grnd_hit
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_BOUNCE,4
;	WLW	ANI_ATTCHIMAGE,D4PN5L+FR5,10		;image, zoff (priority)
	WL	3,B2PN5A+FR6
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE

	WL	4,B2PN5A+FR7
	WL	ANI_CODE,win_announce
;	WLW	ANI_ATTCHIMAGE,0,0		;Turn it off
;	WL	40,D4PN5A+FR6
;	.word	ANI_SET_ATTACH
;	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
;	.word	ANI_OFFSET,0,0,20			;x,y,z
	WL	40,B2PN5A+FR5

	.word	ANI_LOOP
;Do another ground hit on opponent
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
#floop	WL	1000,B5RV5A+FR7
	WL	ANI_GOTO,#floop


	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


******************************************************************************
* RAISE ARM IN VICTORY FROM A STANCE

 SUBR	bam_2_raise_arm_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;Rotate!
	WL	ANI_CODE,DO_CROWD_CHEER
	WL	ANI_CODE,win_announce

	WL	3,B1TT5Z+FR2	;2.5
	WL	3,B1TT5Z+FR3	;3.5
	WL	ANI_GOTO,#cont

 SUBR	bam_4_raise_arm_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,DO_CROWD_CHEER
	WL	ANI_CODE,win_announce

#cont	WL	4,B4SW4B+FR3
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

	WL	4,B4SW4B+FR3
	WL	4,B4SW4B+FR4
	WL	4,B4SW4B+FR5
	WL	4,B4SW4B+FR6
	WL	4,B4SW4B+FR7
	WL	4,B4SW4B+FR8

	.word	ANI_SET_RPTCOUNT,-6	;set count to rnd from 0 to 6

#lp	WL	4,B4ST4Z+FR1
	WL	4,B4ST4Z+FR2
	WL	4,B4ST4Z+FR3
	WL	4,B4ST4Z+FR4
	WL	4,B4ST4Z+FR5
	WL	4,B4ST4Z+FR6
	WL	4,B4ST4Z+FR7
	WL	4,B4ST4Z+FR8
	WL	4,B4ST4Z+FR9

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#lp

	WL	ANI_CODE,check_raisearm_bit
	WL	ANI_IFSTATUS,#wakeup

	;don't wake up.
	.word	ANI_SET_RPTCOUNT,1000
	WL	ANI_GOTO,#lp

#wakeup
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_FACEDOWN
	.word	ANI_END


#*****************************************************************************
*
* GET BUCKED OFF A PINNED OPPONENT

 SUBR	bam_buckoff_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	4,B2PN5A+FR5
	WL	ANI_CODE,set_buckoff_vels
	WL	4,B2PN5A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	4,B2PN5A+FR6
	WL	12,B2PN5A+FR7

	;now stand up
	WL	3,B5RV5A+FR1
	WL	3,B5RV5A+FR2
	WL	3,B5RV5A+FR3
	WL	3,B5RV5A+FR4
	WL	3,B5RV5A+FR5

	.word	ANI_FACEDOWN

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* HIP TOSS RUNNING OPPONENT

 SUBR	bam_combo_hiptoss_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,6

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 6,40,40,40,90000h,TGT_CHEST,20,0,0
	WL	ANI_SET_YVEL,0000h

	WL	2,B3DR3B+FR1

	.word	ANI_ATTACK_ON, AMODE_PUPPET,16,40,62,42 ;mode,x,y,w,h
	WL	2,B3DR3B+FR2
	.word	ANI_ZERO_XZVELS
	WWL	ANI_WAITHITOPP,6,B3DR3B+FR2
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missedc
	WL	ANI_IFBLOCKED,#missedbc		;Yes, I hit blocker

;got him
	.WORD	ANI_INC_COMBO
	WL	ANI_CODE,DO_GRUNT

	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

; attacker sequence
	WWLLW	ANI_SUPERSLAVE2,3,B3DR3B+FR3,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,B3DR3B+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,B3DR3B+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,B3DR3B+FR6,#puppet_tbl,3
	WL	ANI_SET_YVEL,20000h
	WWWL	ANI_IFROPE,RC_BACK,XTOSSDIST,#throw_him_out_c
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

#missedbc
	WL	15,B3DR3B+FR3
#missedc
	WL	10,B3DR3B+FR3
	WL	4,B3DR3B+FR2
	WL	4,B3DR3B+FR1

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_CODE,CALL_MISSES

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#throw_him_out_c
	WLLL	ANI_ATTACHVEL,-080000h,0a0000h,0h		;x,y,z
	WL	ANI_SLAVEANIM,#flyout_tbl
	WL	ANI_OPPOFFSET,release_table
	.word	ANI_DETACH
	.WORD	ANI_SOUND,06FH	;GET OUT OF MY RING !

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	5,B3DR3B+FR7
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


 SUBR	bam_3_hiptoss2_anim

;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,10
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,60,55,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_SET_YVEL,0000h

	WL	2,B3DR3B+FR1

	.word	ANI_ATTACK_ON, AMODE_PUPPET_TOSS,16,40,42,42 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,2,B3DR3B+FR2
	WWL	ANI_WAITHITOPP,6,B3DR3B+FR3
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACK_OFF

	WL	ANI_GOTO,#cont

 SUBR	bam_3_hiptoss_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,10

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,20,0,0
	WL	ANI_SET_YVEL,0000h
	WL	3,B3DR3B+FR1
	WL	1,B3DR3B+FR2

	.word	ANI_ATTACK_ON, AMODE_PUPPET_TOSS,16,40,42,42 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,2,B3DR3B+FR2
	WWL	ANI_WAITHITOPP,2,B3DR3B+FR3
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACK_OFF
	WL	4,B3DR3B+FR3
#cont
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

#got_him
	.word	ANI_DRAW_NAME,11
	WL	ANI_CODE,DO_GRUNT

	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

; attacker sequence
	WWLLW	ANI_SUPERSLAVE2,3,B3DR3B+FR3,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,B3DR3B+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,B3DR3B+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,B3DR3B+FR6,#puppet_tbl,3
	WL	ANI_SET_YVEL,20000h
;	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL
	WWWL	ANI_IFROPE,RC_BACK,XTOSSDIST,#throw_him_out
	WWLLW	ANI_SUPERSLAVE2,3,B3DR3B+FR7,#puppet_tbl,4

	WL	ANI_SLAVEANIM,#rollout_tbl

	WL	ANI_CODE,CALL_SPECIAL_MOVE
	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_DETACH

	WL	10,B3DR3B+FR8
	WL	4+2,B3DR3B+FR9

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	4+10,B3DR3B+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedb
;	WL	ANI_CODE,ck_hiptoss
;	WL	ANI_IFNOTSTATUS,#got_him
	WL	10,B3DR3B+FR3
;Delay longer if 2nd hiptoss in quick succession!
	WL	ANI_CODE,hiptoss_delay
	WL	ANI_IFNOTSTATUS,#missed
	WL	24,B3DR3B+FR3
#missed
	WL	2,B3DR3B+FR3
	WL	3,B3DR3B+FR2
	WL	3,B3DR3B+FR1

	WL	ANI_CODE,CALL_MISSES

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#throw_him_out
	WLLL	ANI_ATTACHVEL,-080000h,0a0000h,0h		;x,y,z
	WL	ANI_SLAVEANIM,#flyout_tbl
	WL	ANI_OPPOFFSET,release_table
	.word	ANI_DETACH
	.WORD	ANI_SOUND,06FH	;GET OUT OF MY RING !

	WL	5,B3DR3B+FR7
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

#flyout_tbl
	REFLONG	hrt_flyout_anim
	REFLONG	rzr_flyout_anim
	REFLONG	und_flyout_anim
	REFLONG	yok_flyout_anim
	REFLONG	shn_flyout_anim
	REFLONG	bam_flyout_anim
	REFLONG	dnk_flyout_anim
	.long	0
	REFLONG	lex_flyout_anim

release_table
	;	X Y
	.word	16,16		;Bret
	.word	8,16		;Razor
	.word	0,32		;Taker
	.word	0,16		;Yokozuna
	.word	0,16		;Shawn
	.word	8,16		;BamBam
	.word	4,20		;Doink
	.word	0,0		;Adam
	.word	0,16		;Lex

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
 	.ref	L3FH3A
 LWWW L3FH3A+FR1,22,25,0
 LWWW L3FH3A+FR2,19,10,0
 LWWW L3FH3A+FR3,11,14,0
 LWWW L3FH3A+FR4,12,12,0
 LWWW L3FH3A+FR5,8,7,0
 .long 0

#rollout_tbl
	REFLONG	hrt_tossed2_anim,rzr_tossed2_anim
	REFLONG	und_tossed2_anim
	REFLONG	yok_tossed2_anim
	REFLONG	shn_tossed2_anim,bam_tossed2_anim
	REFLONG	dnk_tossed2_anim
	.long	0
	REFLONG	lex_tossed2_anim

#*****************************************************************************
*
* #2,4 FLYING CLOTHESLINE

 SUBR	bam_fly_cline_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_OVERLAP|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	.word	ANI_STARTATTACK,AT_LEAPING,9
	WL	3,B3RC3A+FR1

	WLW	ANI_SET_XVEL,74000h,AM_FACE_REL
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
	.word	ANI_SHAKER,30
	WL	3,B3RC3A+FR8
	WLW	ANI_SET_XVEL,50000h,AM_FACE_REL
	.word	ANI_FRICTION,3000h
	.word	ANI_BOUNCE,4

	WL	3,B3RC3A+FR8
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	WL	8,B3RC3A+FR8

	WL	ANI_IFSTATUS,#gothim
;He missed, have him stay on ground for awhile!
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	WL	1,B3RC3A+FR8	;30
#gothim
	.word	ANI_DRAW_NAME,24
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,bam_faceup_getup_anim
;	.word	ANI_END

#*****************************************************************************
* #4 SLAP

;Leaping fire head butt

 SUBR	bam_2_slap_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_LEAPING,20

	WL	1,B1TT5Z+FR2	;2.5
	WL	1,B1TT5Z+FR3	;3.5

 SUBR	bam_4_slap_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_LEAPING,16
	WL	2,B3FH3F+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 12,999,4eh,50,90000h,TGT_HEAD,40,101,10

	WL	3,B3FH3F+FR2
	WL	3,B3FH3F+FR3
	WL	2,B3FH3F+FR4
	WL	2,B3FH3F+FR5
	WL	2,B3FH3F+FR6
	WL	1,B3FH3F+FR7

	.word	ANI_ATTACK_ON, AMODE_HDBUTT3,32,47,39,55 ;mode,x,y,w,h
	WL	2,B3FH3F+FR7
	WL	3,B3FH3F+FR8
	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker
;hit
	WL	ANI_CODE,create_impact
	WL	ANI_CODE,DO_FLAME_HIT_SND
	WL	ANI_CODE,CALL_NASTY_MOVE

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2
	WL	ANI_SET_YVEL,40000h
#no_hit2
#missed
#missedb
	WL	3,B3FH3F+FR8
	WL	ANI_CODE,spunch_delay
	WL	ANI_IFNOTSTATUS,#none
	WL	15,B3FH3F+FR9
#none

	WL	2,B3FH3F+FR9
	WL	2,B3FH3F+FR10
	WL	2,B3FH3F+FR11

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_combo_slap_anim

	.word	ANI_ZEROVELS
 SUBR	bam_combo_slap_anim_no_vel

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,DO_FLAME_SND

	WL	2,B3FH3F+FR1

	.word	ANI_CLR_STATUS
	WL	2,B3FH3F+FR2
	WL	2,B3FH3F+FR3
	WL	2,B3FH3F+FR4
	WL	2,B3FH3F+FR5
	WL	2,B3FH3F+FR6
	WL	2,B3FH3F+FR7

	.word	ANI_ATTACK_ON,AMODE_HDBUTT3,32,27,69,75	;mode,x,y,w,h
	WL	1,B3FH3F+FR8
	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

	WL	ANI_IFNOTSTATUS,#missed_c
	WL	ANI_IFBLOCKED,#missed_c		;Yes, I hit blocker
;hit
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,28000h,0h		;x,y,z vels
	WL	ANI_CODE,DO_FLAME_HIT_SND

	WL	ANI_CODE,create_impact
	.WORD	ANI_INC_COMBO

	WLW	ANI_SET_XVEL,0A000h,AM_FACE_REL
	WL	2,B3FH3F+FR8
	WL	2,B3FH3F+FR9
	WL	2,B3FH3F+FR10
	WL	2,B3FH3F+FR11
	WLW	ANI_SET_XVEL,0000h,AM_FACE_REL

	.word	ANI_SET_RPTCOUNT,3	;3 times

#loop_butt
	.word	ANI_STARTATTACK,AT_HDBUTT,16
	.word	ANI_CLR_BUTCOUNT
	WL	ANI_CODE,DO_FLAME_SND

	WL	1,B3FH3F+FR1

	.word	ANI_CLR_STATUS
	WL	1,B3FH3F+FR2
	WL	1,B3FH3F+FR3
	WL	1,B3FH3F+FR4
	WL	1,B3FH3F+FR5
	WL	1,B3FH3F+FR6
	WL	1,B3FH3F+FR7

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,32,47,60,55	;mode,x,y,w,h
	WL	1,B3FH3F+FR8
	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

	WL	ANI_IFNOTSTATUS,#missed_c
	WL	ANI_IFBLOCKED,#missed_c		;Yes, I hit blocker
;hit
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,28000h,0h		;x,y,z vels
	WL	ANI_CODE,DO_FLAME_HIT_SND

	WL	ANI_CODE,create_impact
	.WORD	ANI_INC_COMBO

	WLW	ANI_SET_XVEL,0C000h,AM_FACE_REL
	WL	1,B3FH3F+FR8
	WL	1,B3FH3F+FR9
	WL	1,B3FH3F+FR10
	WL	1,B3FH3F+FR11
	WLW	ANI_SET_XVEL,0000h,AM_FACE_REL

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#loop_butt

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#CHECK_OTHER_BUT
	WL	ANI_CHANGEANIM,bam_combo_pile_driver_anim
#CHECK_OTHER_BUT
	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#missed_d
	WL	ANI_CHANGEANIM,bam_combo_graboh_anim

#missed_c
	WL	3,B3FH3F+FR8
	WL	3,B3FH3F+FR9
	WL	3,B3FH3F+FR10
	WL	3,B3FH3F+FR11
#missed_d
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.WORD	ANI_DETACH

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
;	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_SETWORD,USR_VAR2,0

	WL	2,B4KM3A+FR1
	.word	ANI_SET_RPTCOUNT,3	;3 times
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
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
	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#missed2

	.word	ANI_DETACH
;	WLW	ANI_SET_XVEL,18000h,AM_FACE_REL
	WL	ANI_CHANGEANIM,bam_3_hiptoss_anim
;	.word	ANI_END

#missed2
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#missed3
	WL	ANI_CHANGEANIM,bam_4_graboh_anim
;	.word	ANI_END

#missed3
	WL	3,B4KM3A+FR10

	.word	ANI_DETACH
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	bam_combo_knees_anim
;From head hold mode

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.WORD	ANI_CLEAR_COMBO

	WL	2,B4KM3A+FR1
	.word	ANI_STARTATTACK,AT_KNEE,6

	WL	2,B4KM3A+FR2
	WL	2,B4KM3A+FR3
	WL	2,B4KM3A+FR4
	.WORD	ANI_INC_COMBO
	.word	ANI_ATTACK_ON, AMODE_KICK,37,42,62,35	;mode,x,y,w,h
	WL	2,B4KM3A+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed3c
	.WORD	ANI_INC_COMBO
	WLLL	ANI_SETOPPVELS,0,18000h,0h		;x,y,z vels
	WL	2,B4KM3A+FR6
	WL	2,B4KM3A+FR7
	WL	2,B4KM3A+FR8

	WL	2,B4KM3A+FR1
	.word	ANI_SET_RPTCOUNT,3	;3 times
#kn_loop
	.word	ANI_STARTATTACK,AT_KNEE,6
	.word	ANI_CLR_BUTCOUNT

	WL	1,B4KM3A+FR2
	WL	2,B4KM3A+FR3
	WL	1,B4KM3A+FR4
	.word	ANI_ATTACK_ON, AMODE_KICK,37,42,62,35	;mode,x,y,w,h
	WL	2,B4KM3A+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed3c
	.WORD	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,18000h,0h		;x,y,z vels
	WL	1,B4KM3A+FR6
	WL	2,B4KM3A+FR7
	WL	1,B4KM3A+FR8

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#kn_loop

	.word	ANI_DETACH

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#CHECK_NEXT2
	.word	ANI_DETACH
	WL	ANI_CHANGEANIM,bam_combo_hiptoss_anim

#CHECK_NEXT2
	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#CHECK_NEXT1
	.word	ANI_DETACH
	WL	ANI_CHANGEANIM,bam_flying_kick_no_xvel

#CHECK_NEXT1
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#missed3d
	WL	ANI_CHANGEANIM,bam_combo_fpunch

#missed3c
	WL	2,B4KM3A+FR6
	WL	2,B4KM3A+FR7
	WL	2,B4KM3A+FR8

#missed3d
	WL	3,B4KM3A+FR10

	.word	ANI_DETACH
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************

	.end
