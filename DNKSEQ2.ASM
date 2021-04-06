************************************************************** 
*
* Software:		Jamie Rivett
* Initiated:		10/12/93
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"dnkseq2.asm"
	.title	"Krusty the Clown animation sequences"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"macros.h"
	.include	"mproc.equ"		;Mproc equates
	.include	"sys.equ"
	.include	"display.equ"
	.include	"game.equ"
	.include	"plyr.equ"
	.include	"anim.equ"
	.include	"sound.h"
	.include	"ring.equ"

	.include	"doinkimg.h"
	.include	"miscimg.glo"
	.include	"damage.equ"
	.INCLUDE	"SWEAT.EQU"
	.include	"miscimg.glo"



******************************************************************************
* EXTERNAL REFERENCES

	.ref	MOVE_NAME_ANNC,face_inside,set_tbukl_airmode
	.ref	setup_freetoss,free_toss_check
	.ref	CALL_ANI_AVERAGE_MOVE,CALL_NASTY_MOVE
	.ref	CALL_THROWN_OUT,DO_BLOCKED
	.ref	DO_OTHERNONO,FIND_AND_KILL_ENDLESS
	.ref	DO_CROWD_CHEER,HIT_THE_MAT,SMALL_BOUNCE
	.ref	CALL_MISSES,CALL_SETUP,CALL_SPECIAL_MOVE
 	.ref	am_I_dead,start_run_anim,PSTATUS,royal_rumble,NUM_OPPS

	.ref	set_target_offsets,check_raisearm_bit
	.ref	get_opp_process,set_tbukl_confine
	.ref	get_leap
	.ref	shake_all_ropes,tbukl_flip

	.ref	DO_GRUNT,KILL_PIN_HIM
	.ref	calc_line_x
	.ref	choose_2or4
	.ref	tgt_ground,process_ptrs

	.ref	hrt_hitonground_anim
	.ref	rzr_hitonground_anim
	.ref	und_hitonground_anim
	.ref	yok_hitonground_anim
	.ref	shn_hitonground_anim
	.ref	bam_hitonground_anim
	.ref	lex_hitonground_anim

	.ref	dnk_4_combo_earslap_anim,hit_nearest
	.ref	DO_COMBO_MESS,tbukl_flip,change_anim1a
	.ref	DO_DOINK_PUSH,announce_rnd_winner
	.ref	create_impact_salt,PCNT,dnk_3_head_held_anim
	.ref	no_bk_xvel,lex_tossed_anim,impact_sound
	.ref	start_run_flung

D4PN5L
	.long	0
	.long	0
	.long	0
	.long	0
	.long	D4PN5L04
	.long	D4PN5L05


******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

TSEC 	equ	53

#*****************************************************************************
*
* NORMAL #2 PUNCH

 SUBR	dnk_2_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D2PU3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D2PU3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D2PU3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_PUNCH,5 ;type, #ticks 'til attack on

	WL	1,D2PU3A+FR2
	WL	2,D2PU3A+FR3
	WL	1,D2PU3A+FR4

;	WLWWWW	ANI_SNOT,doink_pie,0,0,0,0

	.word	ANI_ATTACK_ON, AMODE_PUNCH,22,86,55,9	;mode,x,y,w,h
	WL	1,D2PU3A+FR4
	WL	2,D2PU3A+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit

	WL	ANI_SET_YVEL,30000h
	WL	3,D2PU3A+FR5
#no_hit
	WL	2,D2PU3A+FR6
	WL	3,D2PU3A+FR7	;4
	WL	2,D2PU3A+FR8	;4
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* NORMAL #4 PUNCH

 SUBR	dnk_4_punch_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D4PU3C+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D4PU3C+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D4PU3C+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_PUNCH,5 ;type, #ticks 'til attack on

	WL	1,D4PU3C+FR2
	WL	2,D4PU3C+FR3
	WL	1,D4PU3C+FR4

;	WLWWWW	ANI_SNOT,doink_pie,0,0,0,0

	.word	ANI_ATTACK_ON, AMODE_PUNCH,22,86,55,9	;mode,x,y,w,h
	WL	1,D4PU3C+FR4
	WL	2,D4PU3C+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2

	WL	ANI_SET_YVEL,30000h
	WL	3,D4PU3C+FR5
	
#no_hit2
	WL	2,D4PU3C+FR6
	WL	3,D4PU3C+FR7
	WL	2,D4PU3C+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* BOXING GLOVE #2 PUNCH

 SUBR	dnk_2_box_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_BOXPUNCH,15
	WL	3,D2RG3B+FR6
	WL	3,D2RG3B+FR7
	WL	3,D2RG3B+FR8
	WL	3,D2RG3B+FR9
	WL	3,D2RG3B+FR10

	.word	ANI_ATTACK_ON, AMODE_BOXPUNCH,37,84,66,15	;mode,x,y,w,h
	WL	4,D2RG3B+FR11
	.word	ANI_ATTACK_OFF

	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE
;	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit	;range,vel,addr
;#no_hit
	WL	10,D2RG3B+FR11

	WL	2,D2PU3A+FR6
	WL	3,D2PU3A+FR7
	WL	2,D2PU3A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WL	8,D2RG3B+FR11

#missed
	WL	3,D2RG3B+FR11

	WL	2,D2PU3A+FR6
	WL	3,D2PU3A+FR7
	WL	2,D2PU3A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#* BOXING GLOVE #4 PUNCH

 SUBR	dnk_4_box_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_BOXPUNCH,15
	WL	3,D4RG3A+FR6
	WL	3,D4RG3A+FR7
	WL	3,D4RG3A+FR9
	WL	3,D4RG3A+FR10
	WL	3,D4RG3A+FR11

	.word	ANI_ATTACK_ON, AMODE_BOXPUNCH,37,84,66,15	;mode,x,y,w,h
	WL	4,D4RG3A+FR12
	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker
 
	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE
;	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2	;range,vel,addr
;#no_hit2
	WL	10,D4RG3A+FR12

	WL	2,D4PU3C+FR6
	WL	3,D4PU3C+FR7
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WL	8,D4RG3A+FR12
#missed
	WL	3,D4RG3A+FR12

	WL	2,D4PU3C+FR6
	WL	3,D4PU3C+FR7
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


 SUBR	dnk_combo_box_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_BOXPUNCH,15
	WL	3,D4RG3A+FR6
	WL	3,D4RG3A+FR7
	WL	3,D4RG3A+FR9
	WL	3,D4RG3A+FR10
	WL	3,D4RG3A+FR11

	.word	ANI_ATTACK_ON, AMODE_BOXPUNCH,37,84,66,15	;mode,x,y,w,h
	WL	4,D4RG3A+FR12
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missedc
	WL	ANI_IFBLOCKED,#missedbc		;Yes, I hit blocker
 
	.WORD	ANI_INC_COMBO
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit3	;range,vel,addr
#no_hit3
	WL	10,D4RG3A+FR12

	WL	2,D4PU3C+FR6
	WL	3,D4PU3C+FR7
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedbc
	WL	15,D4RG3A+FR12
#missedc
	WL	5,D4RG3A+FR12
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO

	WL	2,D4PU3C+FR6
	WL	3,D4PU3C+FR7
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #2 HEADBUTT

 SUBR	dnk_2_butt_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D2BC3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_HDBUTT,5
	WL	1,D2BC3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D2BC3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	WL	1,D2BC3A+FR2
	WL	2,D2BC3A+FR3

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,21,79,27,24	;mode,x,y,w,h
	WL	3,D2BC3A+FR4
	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit

	WL	ANI_SET_YVEL,38000h
	WL	6,D2BC3A+FR5
#no_hit
	WL	4,D2BC3A+FR5
	WL	4,D2BC3A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 HEADBUTT

 SUBR	dnk_4_butt_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D4BC3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	.word	ANI_STARTATTACK,AT_HDBUTT,5
	WL	1,D4BC3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D4BC3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	WL	1,D4BC3A+FR2
	WL	2,D4BC3A+FR3

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,21,79,27,24	;mode,x,y,w,h
	WL	3,D4BC3A+FR4
	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2

	WL	ANI_SET_YVEL,38000h
	WL	6,D4BC3A+FR5
#no_hit2
	WL	4,D4BC3A+FR5
	WL	4,D4BC3A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 HEADBUTTS - In close

 SUBR	dnk_2_butts_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SET_RPTCOUNT,3	;5 times
	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2
#rpt
	.word	ANI_CLR_BUTCOUNT

	.word	ANI_STARTATTACK,AT_HDBUTT,6
	WL	2,D2BC3A+FR1
	WL	2,D2BC3A+FR2
	WL	2,D2BC3A+FR3

	.word	ANI_ATTACK_ON, AMODE_HDBUTT_STAY,21,79,27,24	;mode,x,y,w,h
	WL	2,D2BC3A+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit
	WL	ANI_SET_YVEL,38000h
	WL	6,D2BC3A+FR5
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

	WL	3,D2BC3A+FR5
	WL	3,D2BC3A+FR6

	WL	ANI_IF_RPTCOUNT,#rpt

	WL	ANI_CHANGEANIM,dnk_2_butt_anim

#ex
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,40000h,38000h,0h		;x,y,z vels

	WL	3,D2BC3A+FR5
	WL	3,D2BC3A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WLLL	ANI_SETOPPVELS,50000h,18000h,0h		;x,y,z vels
;	WL	4,D2BC3A+FR5
#missed
	WL	2,D2BC3A+FR5
	WL	2,D2BC3A+FR6

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#* #4 HEADBUTT

 SUBR	dnk_4_butts_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SET_RPTCOUNT,3	;5 times
	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2
#rpt
	.word	ANI_CLR_BUTCOUNT

	.word	ANI_STARTATTACK,AT_HDBUTT,6
	WL	2,D4BC3A+FR1
	WL	2,D4BC3A+FR2
	WL	2,D4BC3A+FR3

	.word	ANI_ATTACK_ON, AMODE_HDBUTT_STAY,21,79,27,24	;mode,x,y,w,h
	WL	2,D4BC3A+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2

	WL	ANI_SET_YVEL,38000h
	WL	6,D4BC3A+FR5
#no_hit2
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

	WL	3,D4BC3A+FR5
	WL	3,D4BC3A+FR6

	WL	ANI_IF_RPTCOUNT,#rpt

	WL	ANI_CHANGEANIM,dnk_4_butt_anim
#ex
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,40000h,38000h,0h		;x,y,z vels

	WL	3,D4BC3A+FR5
	WL	3,D4BC3A+FR6
   
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WLLL	ANI_SETOPPVELS,50000h,18000h,0h		;x,y,z vels
;	WL	4,D4BC3A+FR5
#missed
	WL	2,D4BC3A+FR5
	WL	2,D4BC3A+FR6

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
* #4 COMBO HEADBUTT

 SUBR	dnk_4_combo_butt_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,10000h
	.word	ANI_STARTATTACK,AT_HDBUTT,5
	WL	2,D4BC3A+FR1
	WL	2,D4BC3A+FR2
	WL	1,D4BC3A+FR3

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,21,39,67,44	;mode,x,y,w,h
	WL	2,D4BC3A+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#miss
	.WORD	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,28000h,0h		;x,y,z vels

	.word	ANI_STARTATTACK,AT_HDBUTT,9

	WL	2,D4BC3A+FR5
	WL	2,D4BC3A+FR6

	WL	ANI_SET_YVEL,10000h
	WL	2,D4BC3A+FR1
	WL	2,D4BC3A+FR2
	WL	1,D4BC3A+FR3

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,21,39,67,44	;mode,x,y,w,h
	WL	2,D4BC3A+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#miss
	.WORD	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,28000h,0h		;x,y,z vels

	.word	ANI_STARTATTACK,AT_HDBUTT,9

	WL	2,D4BC3A+FR5
	WL	2,D4BC3A+FR6

	WL	ANI_SET_YVEL,10000h
	WL	2,D4BC3A+FR1
	WL	2,D4BC3A+FR2
	WL	1,D4BC3A+FR3

	.word	ANI_CLR_BUTCOUNT

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,21,39,67,44	;mode,x,y,w,h
	WL	2,D4BC3A+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#miss
	.WORD	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,28000h,0h		;x,y,z vels

	.word	ANI_STARTATTACK,AT_HDBUTT,9
	WL	2,D4BC3A+FR5
	WL	2,D4BC3A+FR6

	WL	ANI_SET_YVEL,10000h
	WL	2,D4BC3A+FR1
	WL	2,D4BC3A+FR2
	WL	1,D4BC3A+FR3

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,21,39,67,44	;mode,x,y,w,h
	WL	2,D4BC3A+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#miss
	.WORD	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,28000h,0h		;x,y,z vels

	WL	2,D4BC3A+FR5
	WL	2,D4BC3A+FR6

	.word	ANI_DETACH

	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#NEXT_CHECK_3
	WL	ANI_CHANGEANIM,dnk_combo_box_anim

#NEXT_CHECK_3
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#NEXT_CHECK_2
	WL	ANI_CHANGEANIM,dnk_combo_knee_fall_anim

#NEXT_CHECK_2									
	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#NEXT_CHECK
	WL	ANI_CHANGEANIM,dnk_4_combo_hiptoss_anim

#NEXT_CHECK
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#miss
	WL	ANI_CHANGEANIM,dnk_4_combo_earslap_anim

#miss
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO

	WL	2,D4BC3A+FR5
	WL	2,D4BC3A+FR6

	.word	ANI_DETACH

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* NORMAL #2 KICK

 SUBR	dnk_2_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D2KM3B+FR1	;4
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D2KM3B+FR1	;4
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D2KM3B+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_KICK,5
	WL	1,D2KM3B+FR2
	WL	2,D2KM3B+FR3

	WL	2,D2KM3B+FR4	;4

	.word	ANI_ATTACK_ON, AMODE_KICK,20,62,68,16	;mode,x,y,w,h
	WL	1,D2KM3B+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit
	WL	ANI_SET_YVEL,30000h
	WL	2,D2KM3B+FR4
	
#no_hit
	WL	ANI_IFNOTSTATUS,#nopause
	WL	2,D2KM3B+FR4
#nopause

	WL	2,D2KM3B+FR4
	WL	3,D2KM3B+FR5
	WL	2,D2KM3B+FR6
	WL	3,D2KM3B+FR7
	WL	2,D2KM3B+FR8
	WL	3,D2KM3B+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* NORMAL #4 KICK

 SUBR	dnk_4_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D4KM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D4KM3A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D4KM3A+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_KICK,5
	WL	1,D4KM3A+FR3
	WL	2,D4KM3A+FR4

	WL	2,D4KM3A+FR5

	.word	ANI_ATTACK_ON, AMODE_KICK,20,62,68,16	;mode,x,y,w,h
	WL	1,D4KM3A+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2
	WL	ANI_SET_YVEL,30000h
	WL	2,D4KM3A+FR5

#no_hit2
	WL	ANI_IFNOTSTATUS,#nopause2
	WL	2,D4KM3A+FR5
#nopause2

	WL	2,D4KM3A+FR5
	WL	3,D4KM3A+FR6
	WL	2,D4KM3A+FR7
	WL	3,D4KM3A+FR8
 	WL	2,D4KM3A+FR9
	WL	3,D4KM3A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	dnk_4_combo_kick_anim

	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS

	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_KICK,7
	WL	2,D4KM3A+FR2
	WL	1,D4KM3A+FR3
	WL	2,D4KM3A+FR4

	WL	2,D4KM3A+FR5

	.WORD	ANI_INC_COMBO
	.word	ANI_ATTACK_ON, AMODE_KICK,20,16,68,66	;mode,x,y,w,h
	WL	1,D4KM3A+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#miss
	.WORD	ANI_INC_COMBO
	WLLL	ANI_SETOPPVELS,0,28000h,0h		;x,y,z vels

	.word	ANI_CLR_BUTCOUNT
	WL	ANI_SET_YVEL,30000h

	.word	ANI_STARTATTACK,AT_KICK,13
	WL	2,D4KM3A+FR5
	WL	1,D4KM3A+FR6
	WL	1,D4KM3A+FR8
 	WL	2,D4KM3A+FR9
	WL	1,D4KM3A+FR10

	WL	1,D4KM3A+FR2
	WL	1,D4KM3A+FR3
	WL	2,D4KM3A+FR4

	WL	2,D4KM3A+FR5

	.word	ANI_ATTACK_ON, AMODE_KICK,20,16,68,66	;mode,x,y,w,h
	WL	1,D4KM3A+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#miss
	.WORD	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,28000h,0h		;x,y,z vels

	WL	ANI_SET_YVEL,30000h
	.word	ANI_STARTATTACK,AT_KICK,11
	WL	1,D4KM3A+FR5

	WL	1,D4KM3A+FR6
	WL	1,D4KM3A+FR8
 	WL	2,D4KM3A+FR9
	WL	1,D4KM3A+FR10


	WL	1,D4KM3A+FR2
	WL	1,D4KM3A+FR3
	WL	1,D4KM3A+FR4

	WL	2,D4KM3A+FR5

	.word	ANI_ATTACK_ON, AMODE_KICK,20,16,68,66	;mode,x,y,w,h
	WL	1,D4KM3A+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#miss
	.WORD	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,28000h,0h		;x,y,z vels

	.word	ANI_DETACH

	WL	ANI_SET_YVEL,30000h
	.word	ANI_STARTATTACK,AT_KICK,11
	WL	1,D4KM3A+FR5

	WL	1,D4KM3A+FR8
 	WL	2,D4KM3A+FR9
	WL	1,D4KM3A+FR10


	WL	1,D4KM3A+FR2
	WL	1,D4KM3A+FR3
	WL	1,D4KM3A+FR4

	WL	2,D4KM3A+FR5

	.word	ANI_ATTACK_ON, AMODE_KICK,20,16,68,66	;mode,x,y,w,h
	WL	1,D4KM3A+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#miss
	.WORD	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,28000h,0h		;x,y,z vels

	.word	ANI_DETACH

	WL	ANI_SET_YVEL,30000h
	WL	1,D4KM3A+FR5

	WL	1,D4KM3A+FR8
 	WL	2,D4KM3A+FR9
	WL	1,D4KM3A+FR10

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#NEXT_CHECK_2
	WL	ANI_CHANGEANIM,dnk_combo_box_anim

#NEXT_CHECK_2
	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#NEXT_CHECK
	WL	ANI_CHANGEANIM,dnk_combo_knee_fall_anim

#NEXT_CHECK
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#miss
	WL	ANI_CHANGEANIM,dnk_4_combo_spin_kick_anim

#miss
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_DETACH
	WL	3,D4KM3A+FR5
	WL	3,D4KM3A+FR6
	WL	3,D4KM3A+FR7
	WL	3,D4KM3A+FR8
 	WL	3,D4KM3A+FR9
	WL	3,D4KM3A+FR10
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #2 SPIN KICK

 SUBR	dnk_2_spin_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_SPINKIK,15
	WL	3,D2KB3A+FR9
	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 11,999,50,50,90000h,TGT_HEAD,79,87,-30
	WL	2,D2KB3A+FR8
	WL	3,D2KB3A+FR7
	WL	3,D2KB3A+FR6
	WL	3,D2KB3A+FR5

;	.word	ANI_ATTACK_ON, AMODE_SPINKICK,59,87,21,20	;mode,x,y,w,h
	.word	ANI_ATTACK_ON, AMODE_SPINKICK,46,76,42,42	;mode,x,y,w,h

	WL	4,D2KB3A+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit
	WL	ANI_SET_YVEL,50000h
	WL	ANI_GOTO,#nopause
#no_hit
	WL	ANI_IFNOTSTATUS,#nopause
	.word	ANI_ZEROVELS
	WL	ANI_SET_YVEL,30000h
	WLW	ANI_SET_XVEL,30000h,AM_HIT_REL
#nopause
	WL	1,D2KB3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

;	WL	ANI_CODE,skick_delay
;	WL	ANI_IFNOTSTATUS,#none
;	WL	15,D2KB3A+FR4
;#none

	WL	4,D2KB3A+FR3
	WL	4,D2KB3A+FR2

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	skick_delay

	move	@royal_rumble,a0
	jrnz	#ok




;	move	@PSTATUS,a0
;	subk	3,a0
;	jrz	#cont
;	move	@NUM_OPPS,a0
;	subk	1,a0
;	jrnz	#ok
;#cont







	move	*a13(LAST_SKICK),a14,L
	move	@PCNT,a0,L			;use 32-bit PCNT!
	move	a0,*a13(LAST_SKICK),L
	sub	a14,a0
	cmpi	2*60,a0
	jrge	#ok

;This blocked fling attempt is too close (in terms of time) to most recent grab
	move	*a13(ANIMODE),a1
	ori	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets

#ok	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets

#*****************************************************************************
*
* #2 SPIN KICK - Against TB attacks

 SUBR	dnk_2_spin_kick_TB_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETPLYRMODE,MODE_INAIR2
	.word	ANI_STARTATTACK,AT_LEAPING,15
	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2
	WL	2,D2KB3A+FR9
	WL	ANI_SET_YVEL,70000h
	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL
	WL	2,D2KB3A+FR8
	WL	2,D2KB3A+FR7
	.word	ANI_ATTACK_ON, AMODE_SPINKICK,8,19,68,60	;mode,x,y,w,h
	WL	2,D2KB3A+FR6
	WL	2,D2KB3A+FR5
	WL	8,D2KB3A+FR4
	.word	ANI_ATTACK_OFF
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	4,D2KB3A+FR3
	WL	4,D2KB3A+FR2

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 SPIN KICK

 SUBR	dnk_4_spin_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2
	.word	ANI_STARTATTACK,AT_SPINKIK,15
	WL	3,D4KB3A+FR9
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff

	LEAPATOPP 11,999,50,50,90000h,TGT_HEAD,81,90,30
	WL	2,D4KB3A+FR8
	WL	3,D4KB3A+FR7
	WL	3,D4KB3A+FR6
	WL	3,D4KB3A+FR5

;	.word	ANI_ATTACK_ON, AMODE_SPINKICK,59,82,26,13	;mode,x,y,w,h
	.word	ANI_ATTACK_ON, AMODE_SPINKICK,50,70,50,28	;mode,x,y,w,h
	WL	4,D4KB3A+FR5
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2
	WL	ANI_SET_YVEL,50000h
	WL	ANI_GOTO,#nopause2
#no_hit2
	WL	ANI_IFNOTSTATUS,#nopause2
	.word	ANI_ZEROVELS
	WL	ANI_SET_YVEL,30000h
	WLW	ANI_SET_XVEL,30000h,AM_HIT_REL
#nopause2
	WL	1,D4KB3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

;	WL	ANI_CODE,skick_delay
;	WL	ANI_IFNOTSTATUS,#none
;	WL	15,D4KB3A+FR5
;#none

	WL	4,D4KB3A+FR4
	WL	4,D4KB3A+FR3
	WL	4,D4KB3A+FR2

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*
* #4 SPIN KICK

 SUBR	dnk_4_spin_kick_TB_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2
	.word	ANI_SETPLYRMODE,MODE_INAIR2
	.word	ANI_STARTATTACK,AT_SPINKIK,15
	WL	2,D4KB3A+FR9
	WL	ANI_SET_YVEL,70000h
	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL
	WL	2,D4KB3A+FR8
	WL	2,D4KB3A+FR7
	.word	ANI_ATTACK_ON, AMODE_SPINKICK,59,82,26,13	;mode,x,y,w,h
	WL	2,D4KB3A+FR6
	WL	2,D4KB3A+FR5
	WL	8,D4KB3A+FR5
	.word	ANI_ATTACK_OFF
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	3,D4KB3A+FR4
	WL	3,D4KB3A+FR3
	WL	3,D4KB3A+FR2

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	dnk_4_combo_spin_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	.word	ANI_SETSPEED,100h
	.word	ANI_STARTATTACK,AT_SPINKIK,9
	WL	2,D2KB3A+FR9

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,999,45,50,90000h,TGT_HEAD,79,87,-30
	WL	2,D2KB3A+FR8
	WL	2,D2KB3A+FR7
	WL	2,D2KB3A+FR6
	WL	1,D2KB3A+FR5

	.word	ANI_ATTACK_ON, AMODE_SPINKICK,59,37,41,70	;mode,x,y,w,h
	WL	2,D2KB3A+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#miss_combo_spin2
	.WORD	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,28000h,0h		;x,y,z vels
	WLW	ANI_SET_ZVEL,40000h,AM_FACE_REL
	WLW	ANI_SET_XVEL,0h,AM_FACE_REL

	.word	ANI_CLR_BUTCOUNT
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_STARTATTACK,AT_SPINKIK,16
	WL	2,D2KB3A+FR3
	WL	2,D2KB3A+FR2
	WL	2,D4KB3A+FR9

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff

	WL	2,D4KB3A+FR9

	LEAPATOPP 8,999,45,50,90000h,TGT_HEAD,81,90,30
	WL	2,D4KB3A+FR8
	WL	2,D4KB3A+FR7
	WL	1,D4KB3A+FR6
	WL	2,D4KB3A+FR5

	.word	ANI_ATTACK_ON, AMODE_SPINKICK,59,37,41,70	;mode,x,y,w,h
	WL	1,D4KB3A+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#miss_combo_spin4
	.WORD	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,28000h,0h		;x,y,z vels
	WLW	ANI_SET_ZVEL,40000h,AM_FACE_REL
	WLW	ANI_SET_XVEL,0h,AM_ABS

	WL	2,D4KB3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_STARTATTACK,AT_SPINKIK,14
	WL	2,D4KB3A+FR4
	WL	1,D4KB3A+FR3
	WL	2,D4KB3A+FR2

;end kick 4

	WL	1,D2KB3A+FR9

	.word	ANI_CLR_BUTCOUNT
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,999,45,50,90000h,TGT_HEAD,79,87,-30
	WL	1,D2KB3A+FR8
	WL	1,D2KB3A+FR7
	WL	1,D2KB3A+FR6
	WL	1,D2KB3A+FR5

	.word	ANI_ATTACK_ON, AMODE_SPINKICK,59,37,41,70	;mode,x,y,w,h
	WL	2,D2KB3A+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#miss_combo_spin2
	.WORD	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,18000h,0h		;x,y,z vels
	WLW	ANI_SET_ZVEL,10000h,AM_FACE_REL
	WLW	ANI_SET_XVEL,0h,AM_ABS

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_STARTATTACK,AT_SPINKIK,12
	WL	1,D2KB3A+FR3
	WL	2,D2KB3A+FR2
	WL	1,D4KB3A+FR9

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff

	LEAPATOPP 8,999,45,50,90000h,TGT_HEAD,81,90,30
	WL	1,D4KB3A+FR8
	WL	2,D4KB3A+FR7
	WL	1,D4KB3A+FR6
	WL	1,D4KB3A+FR5

	.word	ANI_ATTACK_ON, AMODE_SPINKICK,59,37,41,70	;mode,x,y,w,h
	WL	1,D4KB3A+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#miss_combo_spin4
	.WORD	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,18000h,0h		;x,y,z vels
	WLW	ANI_SET_ZVEL,10000h,AM_FACE_REL
	WLW	ANI_SET_XVEL,0h,AM_ABS

	WL	1,D4KB3A+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	1,D4KB3A+FR4
	WL	2,D4KB3A+FR3
	WL	1,D4KB3A+FR2

;end kick 4

	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#NEXT_CHECK_3
	WL	ANI_CHANGEANIM,dnk_combo_box_anim

#NEXT_CHECK_3
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#NEXT_CHECK_2
	WL	ANI_CHANGEANIM,dnk_combo_knee_fall_anim

#NEXT_CHECK_2
	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#NEXT_CHECK
	WL	ANI_CHANGEANIM,dnk_4_combo_hiptoss_anim
#NEXT_CHECK
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#miss_combo_spin4
	WL	ANI_CHANGEANIM,dnk_4_combo_earslap_anim

#miss_combo_spin2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO

	WL	2,D2KB3A+FR3
	WL	2,D2KB3A+FR2
	WL	2,D4KB3A+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#miss_combo_spin4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO

	WL	2,D4KB3A+FR4
	WL	2,D4KB3A+FR3
	WL	2,D4KB3A+FR2


	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #2 KNEE

 SUBR	dnk_2_knee_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_KNEE,6

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D2KM3D+FR1				;D2NM3A+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D2KM3D+FR1				;D2NM3A+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D2KM3D+FR1				;D2NM3A+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	WL	2,D2KM3D+FR1				;D2NM3A+FR3

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 21,999,36,30,90000h,TGT_CHEST,46,74,0

	.word	ANI_ATTACK_ON, AMODE_KNEE,5,41,48,36	;mode,x,y,w,h
	WL	3,D2NM3A+FR4
	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit
	WL	ANI_SET_YVEL,60000h
	WLW	ANI_SET_ZVEL,10000h,AM_ABS
	WL	1,D2NM3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#cont
#no_hit
;	WL	ANI_IFNOTSTATUS,#nodrft
;	WLW	ANI_SET_ZVEL,0C000h,AM_ABS
;#nodrft
	WL	8,D2NM3A+FR4
;	.word	ANI_ZERO_XZVELS
;	WL	14,D2NM3A+FR4	;8
;	WL	1,D2NM3A+FR4	;8
#cont
	WL	3,D2NM3A+FR5
	WL	3,D2NM3A+FR6
	WL	3,D2NM3A+FR7
	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 KNEE

;For when knee knocks you on your butt

 SUBR	dnk_4_knee_fall_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2
	.word	ANI_STARTATTACK,AT_BIGKNEE,6
	WL	3,D4NM3B+FR3
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 21,999,36,20,90000h,TGT_CHEST,46,74,0
;	LEAPATOPP 15,999,86,20,90000h,TGT_CHEST,26,74,0

;This knee will knock the guy down!
	WL	1,D4NM3B+FR4
	.word	ANI_ATTACK_ON, AMODE_BIGKNEE,-5,41,70,36	;mode,x,y,w,h
	WL	3,D4NM3B+FR4
	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2

;	WLW	ANI_SET_ZVEL,-10000h,AM_ABS
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit3
	WL	ANI_SET_YVEL,60000h
;	WLW	ANI_SET_ZVEL,-4000h,AM_ABS
	WL	1,D4NM3B+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#cont2
#no_hit3
	WL	8,D4NM3B+FR4
;	WL	15h,D4NM3B+FR4
;	.word	ANI_ZERO_XZVELS
;	WL	3,D4NM3B+FR4	;8
;	.word	ANI_WAITHITGND
;	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#cont2

 SUBR	dnk_combo_knee_fall_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_BIGKNEE,19
	WL	4,D4NM3B+FR3
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 15,999,86,20,90000h,TGT_CHEST,26,74,0

;This knee will knock the guy down!
	.word	ANI_ATTACK_ON, AMODE_BIGKNEE,-5,41,90,36	;mode,x,y,w,h
	WL	3,D4NM3B+FR4
	.word	ANI_ATTACK_OFF

	.WORD	ANI_INC_COMBO
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO

	WLW	ANI_SET_ZVEL,-20000h,AM_ABS
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit4
	WL	ANI_SET_YVEL,60000h
	WL	1,D4NM3B+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#cont2
#no_hit4
	WL	1ah,D4NM3B+FR4
	.word	ANI_ZERO_XZVELS
	WL	3,D4NM3B+FR4	;8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#cont2


 SUBR	dnk_4_knee_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_KNEE,6
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D4NM3B+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D4NM3B+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D4NM3B+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	WL	2,D4NM3B+FR3
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 21,999,36,20,90000h,TGT_CHEST,46,74,0

	.word	ANI_ATTACK_ON, AMODE_KNEE,5,41,40,36	;mode,x,y,w,h
	WL	3,D4NM3B+FR4
	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2
	WL	ANI_SET_YVEL,60000h
	WLW	ANI_SET_ZVEL,-4000h,AM_ABS
	WL	1,D4NM3B+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#cont2
#no_hit2
	WL	8,D4NM3B+FR4
;	WL	12h,D4NM3B+FR4
;	.word	ANI_ZERO_XZVELS
;	WL	14,D4NM3B+FR4	;8
;	.word	ANI_WAITHITGND
;	.word	ANI_ZEROVELS
#cont2
	WL	3,D4NM3B+FR5
	WL	3,D4NM3B+FR6
	WL	3,D4NM3B+FR7

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #3 FLYING KICK

#yoff1	equ	40

 SUBR	dnk_combo_flying_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h

	WL	3,D3DC3C+FR1

;	WL	ANI_CODE,get_leap
;	WL	ANI_IFSTATUS,#no_xvelc

;#normc
;	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 19,999,150,65,90000h,TGT_HEAD,30,100,0
	.word	ANI_STARTATTACK,AT_LEAPING,21

;	WL	ANI_GOTO,#contc
;
;#no_xvelc
;	.word	ANI_ZERO_XZVELS
;	WL	ANI_SET_YVEL,64000h
;#contc
	WL	3,D3DC3C+FR2

	.word	ANI_OFFSET,0,#yoff1,0			;x,y,z
	WL	3,D3DC3C+FR3
	WL	6,D3DC3C+FR4

	.word	ANI_CLR_STATUS

	.word	ANI_ATTACK_ON, AMODE_FLYKICK,53,23,27,29 ;mode,x,y,w,h
	WL	3,D3DC3C+FR5
	.word	ANI_ATTACK_OFF
	WL	4,D3DC3C+FR6

	WL	3,D3DC3C+FR7
	WL	3,D3DC3C+FR8

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT

	WL	ANI_IFSTATUS,#gotc
;Missed him
	WL	4,D3DC3C+FR9
	.word	ANI_BOUNCE,3
	WL	4,D3DC3C+FR9
	.word	ANI_WAITHITGND
	WL	ANI_CODE,CALL_MISSES
	WL	ANI_CODE,SMALL_BOUNCE
	WL	2,D3DC3C+FR9
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	
#gotc
	.WORD	ANI_INC_COMBO
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	2,D3DC3C+FR9
	WL	2,D3DC3C+FR9
	WL	4,D3DC3C+FR9
	WL	4,D3DC3C+FR10

	.word	ANI_XFLIP
	.word	ANI_OFFSET,5,0,0			;x,y,z

;Getting up, set no_collis
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS|MODE_NOAUTOFLIP	;uninterruptable

	WL	3,D2GD2A+FR4
	WL	3,D2GD2A+FR6
	WL	3,D2GD2A+FR7
;Check for a flip here
	WL	2,D2GD2A+FR9
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	1,D2GD2A+FR9
	WL	3,D2GD2A+FR10

	.word	ANI_SAFE_TIME,30
	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,37,88,63,9
	WL	1,D2GD2A+FR10
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,dnk_4_push_anim
#no_freetoss

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


 SUBR	dnk_flying_kick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	3,D3DC3C+FR1

;If opponent is on ground, just jump in place
	WL	ANI_CODE,#ckongrnd
	WL	ANI_IFNOTSTATUS,#norm
	WL	ANI_CHANGEANIM,dnk_belly_anim
#norm
;	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 19,999,155,65,90000h,TGT_HEAD,30,100,0
	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2
	.word	ANI_STARTATTACK,AT_LEAPING,11
	WL	ANI_CODE,no_bk_xvel

	WL	3,D3DC3C+FR2
	.word	ANI_OFFSET,0,#yoff1,0			;x,y,z
	WL	3,D3DC3C+FR3
	WL	6,D3DC3C+FR4

	.word	ANI_ATTACK_ON, AMODE_FLYKICK,53,23,27,29 ;mode,x,y,w,h
	WL	3,D3DC3C+FR5
	.word	ANI_ATTACK_OFF
	WL	4,D3DC3C+FR6
	WL	3,D3DC3C+FR7
	WL	3,D3DC3C+FR8

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT

	WL	ANI_IFSTATUS,#got
;Missed him
	WL	4,D3DC3C+FR9
	.word	ANI_BOUNCE,3
	WL	4,D3DC3C+FR9
	.word	ANI_WAITHITGND
	WL	ANI_CODE,CALL_MISSES
	WL	ANI_CODE,SMALL_BOUNCE
	WL	2,D3DC3C+FR9
	
#got
	WL	2,D3DC3C+FR9
#cont2
	WL	2,D3DC3C+FR9
	WL	3,D3DC3C+FR9
	WL	3,D3DC3C+FR10

	.word	ANI_XFLIP
	.word	ANI_OFFSET,5,0,0			;x,y,z

;Getting up, set no_collis
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS|MODE_NOAUTOFLIP	;uninterruptable

	WL	3,D2GD2A+FR4
	WL	3,D2GD2A+FR6
	WL	3,D2GD2A+FR7
;Check for a flip here
	WL	2,D2GD2A+FR9
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,D2GD2A+FR9
	WL	3,D2GD2A+FR10

	.word	ANI_SAFE_TIME,30
	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss1
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,37,88,63,9
	WL	1,D2GD2A+FR10
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss1

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,dnk_4_push_anim
#no_freetoss1

	.word	ANI_FACEUP
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


#*****************************************************************************
*
* BODY HIT

 SUBR	dnk_4_body_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_DEBRIS,100,0,6,72,0	;%chance, tbl index, x,y,z off

	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WL	ANI_CODE,ckzpos
	WL	4,D3AM3A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	4,D3AM3A+FR2
	WL	4,D3AM3A+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	WL	3,D3AM3A+FR4
	WL	3,D3AM3A+FR5
	WL	3,D3AM3A+FR6
	WL	2,D3AM3A+FR7
	WL	2,D3AM3A+FR8
	
	.word	ANI_CHECKWORD,USR_VAR1
	WL	ANI_IFNOTSTATUS,#reg

	WL	6,D4SW4C+FR1
	WL	6,D4SW4C+FR2
	WL	6,D4SW4C+FR3
	WL	6,D4SW4C+FR4
	WL	6,D4SW4C+FR5
	WL	6,D4SW4C+FR6
	WL	6,D4SW4C+FR5
	WL	6,D4SW4C+FR4
	WL	6,D4SW4C+FR3
	WL	6,D4SW4C+FR2

#reg	
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	dnk_4_body_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL

	.word	ANI_DEBRIS,100,0,6,72,0	;%chance, tbl index, x,y,z off

	WL	4,D3AM3A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	4,D3AM3A+FR2
	WL	6,D3AM3A+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	WL	4,D3AM3A+FR4
	WL	6,D3AM3A+FR5
	WL	3,D3AM3A+FR6
	WL	3,D3AM3A+FR7
	WL	3,D3AM3A+FR8
	.word	ANI_OFFSET,0,-1,0			;x,y,z
	WL	1,D4SW4C+FR1

	WL	ANI_CHANGEANIM,dnk_dizzy_anim

;Hit by a knee!
 SUBR	dnk_2_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,8000h,AM_ABS

	WL	ANI_CODE,ckzpos
	.word	ANI_DEBRIS,100,0,6,72,0	;%chance, tbl index, x,y,z off

	WL	4,D3AM3A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	4,D3AM3A+FR2
	WL	4,D3AM3A+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	WL	3,D3AM3A+FR4
	WL	3,D3AM3A+FR5
	WL	3,D3AM3A+FR6
	WL	2,D3AM3A+FR7
	WL	2,D3AM3A+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	dnk_4_knee_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	ANI_SET_YVEL,78000h
	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL

	WL	ANI_CODE,ckzpos
	.word	ANI_DEBRIS,100,0,6,72,0	;%chance, tbl index, x,y,z off

	WL	4,D3AM3A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	4,D3AM3A+FR2
	WL	14,D3AM3A+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	WL	4,D3AM3A+FR4
	WL	6,D3AM3A+FR5
	WL	3,D3AM3A+FR6
	WL	3,D3AM3A+FR7
	WL	3,D3AM3A+FR8
;	.word	ANI_OFFSET,-9,-1,0			;x,y,z
	.word	ANI_OFFSET,0,-1,0			;x,y,z
	WL	1,D4SW4C+FR1

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,dnk_dizzy_anim

;Being held by head, hit by a quick knee!
 SUBR	dnk_quick_knee_hit_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h

	.word	ANI_OFFSET,0,0,2			;x,y,z
	WL	4,D3HP3A+FR1
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,COUGH_SWEAT,SWEAT_PER,0
	WL	4,D3HP3A+FR2
	WL	4,D3HP3A+FR3
	WL	4,D3HP3A+FR4
	WL	4,D3HP3A+FR5
	.word	ANI_WAITHITGND

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,dnk_fall_back_anim

#nodead
	WL	ANI_CHANGEANIM,dnk_3_head_held_anim


#*****************************************************************************
*
* FALL BACK

 SUBR	dnk_fall_back_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZERO_XZVELS
	WL	ANI_MIN_YVEL,70000h
	WLW	ANI_SET_ZVEL,10000h,AM_FACE_REL

	.word	ANI_SCROLL_CTRL,DNK_TBUKLY-60

	WL	ANI_CODE,ckzpos

	WWL	ANI_SETLONG,DEBRIS_X,[96,-09]	;Y,X of head
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYC_SWEAT,SWEAT_PER,0
	WL	3,D3UC3A+FR1
	WWL	ANI_SETLONG,DEBRIS_X,[95,-32]	;Y,X of head
	WL	3,D3UC3A+FR2
	WWL	ANI_SETLONG,DEBRIS_X,[91,-41]	;Y,X of head
	WL	3,D3UC3A+FR3
	.word	ANI_OFFSET,0,50,0			;x,y,z

	WWL	ANI_SETLONG,DEBRIS_X,[36,-45]	;Y,X of head
	WL	3,D3UC3A+FR4
	WWL	ANI_SETLONG,DEBRIS_X,[29,-48]	;Y,X of head
	WL	2,D3UC3A+FR5
	WWL	ANI_SETLONG,DEBRIS_X,[19,-48]	;Y,X of head
	WL	2,D3UC3A+FR6
	.word	ANI_WAITHITGND

	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,25
	.word	ANI_FRICTION,3000h
	WWL	ANI_SETLONG,DEBRIS_X,[05,-47]	;Y,X of head
	WL	2,D3UC3A+FR8
	.word	ANI_BOUNCE,5
	WL	1,D3UC3A+FR8
	WWL	ANI_SETLONG,DEBRIS_X,[09,-41]	;Y,X of head
	WL	5,D3UC3A+FR9
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WWL	ANI_SETLONG,DEBRIS_X,[07,-48]	;Y,X of head
	WL	3,D3UC3A+FR10
	WWL	ANI_SETLONG,DEBRIS_X,0		;Y,X of head
	WL	3,D3UC3A+FR11

	.word	ANI_XFLIP
	WL	1,D3SA3A+FR9

	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

;Stay on ground for awhile...  Maybe this will be table driven
	WL	6,D3SA3A+FR9
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,dnk_faceup_getup_anim

 SUBR	ckzpos

;If falling near the front or rear ropes, slide toward middle
;of the ring to allow opponent to walk around him.
	move	*a13(OBJ_ZPOSINT),a0
	cmpi	510h,a0
	jrgt	#slideup
	cmpi	442h,a0
	jrgt	#ok

;slide down scrn
	movi	24000h,a0
	move	a0,*a13(OBJ_ZVEL),L
	rets
#slideup
	movi	-24000h,a0
	move	a0,*a13(OBJ_ZVEL),L
#ok
	rets

#* FALL BACK

 SUBR	dnk_fall_back2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,20000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS
	WL	ANI_CODE,ckzpos

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYC_SWEAT,SWEAT_PER,0
	WL	3,D3UC3A+FR1
	WL	3,D3UC3A+FR2
	WL	3,D3UC3A+FR3
	.word	ANI_OFFSET,0,50,0			;x,y,z

	WL	3,D3UC3A+FR4
	WL	2,D3UC3A+FR5
	WL	2,D3UC3A+FR6
;	WL	2,D3UC3A+FR7
	.word	ANI_WAITHITGND

	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,25
	.word	ANI_ZEROVELS		
	WLW	ANI_SET_ZVEL,18000h,AM_ABS
	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL

	.word	ANI_OFFSET,-25,0,0			;x,y,z
	WL	3,D3FD3E+FR2
	WL	3,D3FD3E+FR3
	WL	3,D3FD3E+FR4
	WL	3,D3FD3E+FR5
	WL	3,D3FD3E+FR6
	WL	3,D3FD3E+FR7
	WL	3,D3FD3E+FR8
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_OFFSET,-22,0,0			;x,y,z

	WL	4,D3GS3X+FR8
	WL	4,D3GS3X+FR9
	WL	4,D3GS3X+FR10
;Stay on ground for awhile...  Maybe this will be table driven
	WL	20,D3GS3X+FR8		;Face down
;	WL	3,D3SA3A+FR9
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,dnk_faceup_getup_anim

#*****************************************************************************
*
* FALL FROM TURNBUCKLE

 SUBR	dnk_fall_back_tbukl_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETSPEED,100h
	.word	ANI_SCROLL_CTRL,SC_RESTORE

	WL	3,D3UC3A+FR1
	WL	3,D3UC3A+FR2
	WL	3,D3UC3A+FR3
	.word	ANI_OFFSET,0,50,0			;x,y,z

	WL	3,D3UC3A+FR4
	WL	2,D3UC3A+FR5
	WL	2,D3UC3A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_DAMAGE,D_HITCONCRETE

	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,40
;	.word	ANI_FRICTION,3000h
	WL	2,D3UC3A+FR8
	.word	ANI_BOUNCE,3
	WL	1,D3UC3A+FR8
	WL	5,D3UC3A+FR9
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,D3UC3A+FR10
	WL	3,D3UC3A+FR11

	.word	ANI_XFLIP
	WL	1,D3SA3A+FR9

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	3,D3SA3A+FR9
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,dnk_faceup_getup_anim


#*****************************************************************************

;chooses 2 or 4 right away

 SUBR	dnk_faceup_getup_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim

	WL	ANI_CODE,choose_2or4
	WL	ANI_IFNOTSTATUS,dnk_2_faceup_getup_anim
	WL	ANI_CHANGEANIM,dnk_4_faceup_getup_anim

 SUBR	dnk_4_faceup_getup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;	.word	ANI_CLR_STARS
;	.word	ANI_CLR_DAMAGE

	WL	1,D3SA3A+FR9
	WL	2,D3GU4A+FR2
	WL	3,D3GU4A+FR3
	WL	2,D3GU4A+FR4
	WL	3,D3GU4A+FR5
	WL	2,D3GU4A+FR6
;Check for a flip here
	WL	1,D3GU4A+FR7
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,D3GU4A+FR7
	WL	2,D3GU4A+FR8
	WL	3,D3GU4A+FR9

	.word	ANI_SAFE_TIME,50

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss2
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,37,88,63,9
	WL	1,D3GU4A+FR9
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss2

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,dnk_4_push_anim
#no_freetoss2

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	dnk_2_faceup_getup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;	.word	ANI_CLR_STARS
;	.word	ANI_CLR_DAMAGE


;	WL	1,D3SA3A+FR9
	WL	2,D3RL1B+FR2
	WL	2,D3RL1B+FR3
	WL	2,D3RL1B+FR4
	WL	2,D3RL1B+FR5
	WL	2,D3RL1B+FR6

	WL	3,D2GD2A+FR4
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	WL	2,D2GD2A+FR6
	WL	3,D2GD2A+FR7
;Check for a flip here
	WL	2,D2GD2A+FR9
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	1,D2GD2A+FR9
	WL	3,D2GD2A+FR10

	.word	ANI_SAFE_TIME,50
	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss3
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,37,88,63,9
	WL	1,D2GD2A+FR10
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss3

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,dnk_4_push_anim
#no_freetoss3

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #4 HEAD HIT
                             
 SUBR	dnk_4_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

;	WL	ANI_CODE,#tryblood
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0

	WL	3,D3AH3B+FR1
	WL	3,D3AH3B+FR2
	WL	2,D3AH3B+FR3
	WL	2,D3AH3B+FR5

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

;#tryblood
;	move	a13,a11
;	CREATE0	react_bloodnguts_gen
;	rets

#* #2 HEAD HIT

 SUBR	dnk_2_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0

	WL	3,D2AH2A+FR1
	WL	3,D2AH2A+FR2
	WL	3,D2AH2A+FR3

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#* #4 HEAD HIT - From spin kick & backhand slap

 SUBR	dnk_4_head_hit2_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,-20000h,AM_ABS
	WL	ANI_SET_YVEL,40000h

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	3,D3AH3B+FR1
	.word	ANI_DEBRIS,200,2,-23,102,0	;%chance, tbl index, x,y,z off
	WL	3,D3AH3B+FR2
	.word	ANI_WAITHITGND
	WL	3,D3AH3B+FR3
	.word	ANI_ZEROVELS
	WL	3,D3AH3B+FR5

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	dnk_4_head_hit4_anim
;From earslap

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	ANI_SET_YVEL,50000h

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	4,D3AH3B+FR2
	WL	4,D3AH3B+FR3
	WL	4,D3AH3B+FR5
	.word	ANI_WAITHITGND

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#* #2 HEAD HIT - From spin kick & backhand slap

 SUBR	dnk_2_head_hit2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WLW	ANI_SET_XVEL,-28000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,20000h,AM_ABS
	WL	ANI_SET_YVEL,40000h

	WL	3,D2AH2A+FR1
	.word	ANI_DEBRIS,200,2,-23,102,0	;%chance, tbl index, x,y,z off
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	WL	4,D2AH2A+FR2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,D2AH2A+FR3

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* HEAD HIT2 (HANDS ON FACE)

 SUBR	dnk_head_hit2_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WLW	ANI_SET_XVEL,-40000h,AM_HIT_REL
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off

	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0
	.word	ANI_FRICTION,3000h
	WL	3,D3AE3B+FR1
	WL	3,D3AE3B+FR2
	WL	3,D3AE3B+FR3
	WL	3,D3AE3B+FR4
	WL	2,D3AE3B+FR5
	WL	2,D3AE3B+FR6
	WL	2,D3AE3B+FR7
	WL	2,D3AE3B+FR8

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,dnk_fall_back_anim

#nodead
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	dnk_head_hit2s_anim
;Salt hits me in face
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

;	WL	4,D3AE3B+FR1
	WL	ANI_CODE,create_impact_salt
	WL	4,D3AE3B+FR2
	WL	4,D3AE3B+FR3
	WL	4,D3AE3B+FR4
	.word	ANI_WAITHITGND
	.word	ANI_FRICTION,4000h
	WL	50,D3AE3B+FR4
	.word	ANI_ZEROVELS
	WL	3,D3AE3B+FR5
	WL	3,D3AE3B+FR6
	WL	3,D3AE3B+FR7
	WL	3,D3AE3B+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END
#*

 SUBR	dnk_head_hit3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WLW	ANI_SET_XVEL,-30000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,28000h,AM_HIT_REL
	WL	ANI_SET_YVEL,50000h
	.word	ANI_FRICTION,3000h
;	WL	4,D3AE3B+FR1
	WL	4,D3AE3B+FR2
	WL	4,D3AE3B+FR3
	WL	18,D3AE3B+FR4
	WL	2,D3AE3B+FR5
	.word	ANI_ZEROVELS
	WL	2,D3AE3B+FR5
	WL	3,D3AE3B+FR6
	WL	3,D3AE3B+FR7
	WL	3,D3AE3B+FR8

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


* HEAD HIT2 (ENDS IN DIZZY)

 SUBR	dnk_head_dead_dizzy_anim
;This is a head hit dizzy seq which causes the player to fall down after a time
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_DIZZY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WLW	ANI_SET_XVEL,-40000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h

	WL	4,D3AE3B+FR1
	WL	4,D3AE3B+FR2
	WL	4,D3AE3B+FR3
	WL	4,D3AE3B+FR4
	WL	4,D3AE3B+FR5
	WL	4,D3AE3B+FR6
	WL	4,D3AE3B+FR7
	WL	4,D3AE3B+FR8

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,dnk_dizzy_anim

* HEAD HIT2 (ENDS IN DIZZY)

 SUBR	dnk_head_hit_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WLW	ANI_SET_XVEL,-60000h,AM_HIT_REL
	.word	ANI_FRICTION,3000h

	WL	4,D3AE3B+FR1
	WL	4,D3AE3B+FR2
	WL	4,D3AE3B+FR3
	WL	4,D3AE3B+FR4
	WL	4,D3AE3B+FR5
	WL	4,D3AE3B+FR6
	WL	4,D3AE3B+FR7
	WL	4,D3AE3B+FR8

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,dnk_dizzy_anim

#*****************************************************************************
*
* #2,4 FLYING CLOTHESLINE

 SUBR	dnk_fly_cline_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_OVERLAP|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h
	.word	ANI_STARTATTACK,AT_LEAPING,3

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	3,D3RC3A+FR1
	.word	ANI_OFFSET,5,0,0			;x,y,z
	WL	3,D3RC3A+FR2
	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2

	WL	ANI_SET_YVEL,64000h
	WLW	ANI_SET_XVEL,5c000h,AM_FACE_REL	;64
	.word	ANI_OFFSET,9,45,0			;x,y,z
	WL	3,D3RC3A+FR3
	.word	ANI_ATTACK_ON, AMODE_CLINE,25,6,23,37 ;mode,x,y,w,h ;31
	WL	3,D3RC3A+FR4
	WL	3,D3RC3A+FR5
	WL	3,D3RC3A+FR6
	WL	3,D3RC3A+FR7
	WL	4,D3RC3A+FR8
	.word	ANI_ATTACK_OFF
	WL	5,D3RC3A+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WLW	ANI_SET_XVEL,50000h,AM_FACE_REL
	.word	ANI_FRICTION,3000h
	.word	ANI_BOUNCE,4

	WL	ANI_CODE,HIT_THE_MAT
	WL	3,D3RC3A+FR8
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	WL	10,D3RC3A+FR9

	WL	ANI_IFSTATUS,#gothim
;He missed, have him stay on ground for awhile!
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

;Do a little damage when missing!
;	.word	ANI_DAMAGE,2		;Damage myself 
;	WL	30,D3RC3A+FR9
	WL	3,D3RC3A+FR9
;#done
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,dnk_faceup_getup_anim
#gothim
	.word	ANI_DRAW_NAME,24
	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE

	WL	2,D3RL1B+FR7
	WL	2,D3RL1B+FR9
	WL	2,D3RL1B+FR11

;Perhaps we should turn off collisions when getting up!?
;Getting up, set no_collis
	.word	ANI_SETMODE,MODE_UNINT|MODE_OVERLAP|MODE_NOAUTOFLIP|MODE_NOCOLLIS

	WL	2,D3GU4A+FR2
	WL	2,D3GU4A+FR3
	WL	2,D3GU4A+FR4
	WL	2,D3GU4A+FR5
	WL	2,D3GU4A+FR6

;Check for a flip here
	WL	1,D3GU4A+FR7
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	2,D3GU4A+FR7
	WL	2,D3GU4A+FR8
	WL	3,D3GU4A+FR9

	.word	ANI_SAFE_TIME,30

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss4
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,37,88,63,9
	WL	1,D3GU4A+FR9
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss4

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,dnk_4_push_anim
#no_freetoss4

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

; SUBR	ck_dizzy
;
;	calla	check_dizzy
;	jrz	#not_dizzy
;	move	*a13(ANIMODE),a1
;	ori	MODE_STATUS,a1
;	move	a1,*a13(ANIMODE)
;	rets
;
;#not_dizzy
;	move	*a13(ANIMODE),a1
;	andni	MODE_STATUS,a1
;	move	a1,*a13(ANIMODE)
;	rets


#*****************************************************************************
*
* #2,4 BELLY FLOP FROM RUNNING MODE ONTO FALLEN OPPONENT

 SUBR	dnk_belly_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_OVERLAP|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

	.WORD	ANI_ADD_MOVE,MOVE_C_4,2,2
	WL	ANI_CODE,get_leap
	WL	ANI_IFNOTSTATUS,#normal

	WL	ANI_CODE,#close
	WL	ANI_IFSTATUS,#no_xvel

#normal
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 30,200,100,90,90000h,TGT_GROIN,0,0,-10
	.word	ANI_STARTATTACK,AT_LEAPING,30
;	.word	ANI_STARTATTACK,AT_BUTTSTOMP,30

	WL	ANI_GOTO,#cont

#no_xvel
	.word	ANI_ZERO_XZVELS
	WL	ANI_SET_YVEL,74000h

	WL	5,D4JD4A+FR4
	.word	ANI_OFFSET,0,45,0		;x,y,z
	WL	5,D4FM4A+FR5

	.word	ANI_ATTACK_ON, AMODE_BUTTSTOMP,-18,4,50,23 ;mode,x,y,w,h
	WL	1,D4FM4A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_OFF

#miss	WL	ANI_CODE,shake_all_ropes
	.word	ANI_BOUNCE,5

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKER,15
	WL	5,D4FM4A+FR7

	WL	1,D4FM4A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,SMALL_BOUNCE

	WL	ANI_GOTO,#cont4

#cont	WL	5,D4JD4A+FR4
	.word	ANI_OFFSET,0,45,0		;x,y,z
	WL	5,D4FM4A+FR5

	.word	ANI_ATTACK_ON, AMODE_BUTTSTOMP,-18,4,50,23 ;mode,x,y,w,h
	WL	1,D4FM4A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#miss

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKER,15


	WL	5,D4FM4A+FR7

#cont4	WL	8,D4FM4A+FR9

	.word	ANI_XFLIP
	.word	ANI_FACEDOWN

;Getting up, set no_collis
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS|MODE_NOAUTOFLIP	;uninterruptable

	WL	3,D3GU4A+FR3
	WL	3,D3GU4A+FR4
	WL	3,D3GU4A+FR5
	WL	3,D3GU4A+FR6

;Check for a flip here
	WL	1,D3GU4A+FR7
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,D3GU4A+FR7

	WL	3,D3GU4A+FR8
	WL	3,D3GU4A+FR9

	.word	ANI_SAFE_TIME,50

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss5
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,37,88,63,9
	WL	1,D3GU4A+FR9
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss5

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,dnk_4_push_anim
#no_freetoss5

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#close
	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)

	calla	get_opp_process		;closest opponent process
	move	*a0(OBJ_XPOSINT),a0
	MOVE	*a13(OBJ_XPOSINT),a14
	sub	a0,a14
	abs	a14
	cmpi	30h,a14
	jrgt	#inplace
	rets

#inplace
	move	*a13(ANIMODE),a1
	ori	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets

#*****************************************************************************
*
* #2 ELBOW DROP

 SUBR	dnk_2_lbowdrop_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D2PJ2A+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D2PJ2A+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D2PJ2A+FR3
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_LBDROP,19
	WL	3,D2PJ2A+FR4

	.word	ANI_OFFSET,0,50,0			;x,y,z

	WL	ANI_CODE,#set_target
	WL	ANI_CODE,tgt_ground
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,160,140,90000h,TGT_USER,-3,0,-30
	WL	ANI_CODE,#zero_x

	WL	3,D2PJ2A+FR6
	WL	3,D2PJ2A+FR8
	WL	10,D2PJ2A+FR10
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_ZERO_XZVELS
;Perhaps even shake ropes
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,18

;	.word	ANI_ATTACK_ON_Z, AMODE_LBOWDROP,-15,7,10,30,21,40 ;mode,x,y,z,w,h,d
	.word	ANI_ATTACK_ON, AMODE_LBOWDROP,-15,7,30,21 ;mode,x,y,z,w,h,d

	WL	2,D2PJ2A+FR11
	WL	2,D2PJ2A+FR12
	.word	ANI_ATTACK_OFF

	.WORD	ANI_ADD_MOVE,MOVE_C_4,2,2
	WL	ANI_IFSTATUS,#gothim2
	.word	ANI_BOUNCE,3
	WL	ANI_CODE,HIT_THE_MAT
;	WL	ANI_CODE,SMALL_BOUNCE
	WL	ANI_CODE,CALL_MISSES

;He missed, have him stay on ground for awhile!
	WL	40,D2PJ2A+FR12
	.word	ANI_WAITHITGND
	WL	ANI_GOTO,#cont
#gothim2
	.word	ANI_DRAW_NAME,18
	.word	ANI_BOUNCE,4
	WL	ANI_CODE,HIT_THE_MAT
	WL	15,D2PJ2A+FR12

#cont	WL	3,D5GD3A+FR5

	WL	3,D5GD3A+FR6
	WL	3,D5GD3A+FR7
	WL	3,D5GD3A+FR8
	WL	3,D5GD3A+FR9
	WL	3,D5GD3A+FR10
	.word	ANI_FACEUP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


* #4 ELBOW DROP

 SUBR	dnk_4_lbowdrop_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D4PJ4A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D4PJ4A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D4PJ4A+FR2
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_LBDROP,19
	WL	3,D4PJ4A+FR3

	.word	ANI_OFFSET,0,31h,0			;x,y,z

	WL	ANI_CODE,#set_target
	WL	ANI_CODE,tgt_ground
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16,999,160,140,90000h,TGT_USER,-3,0,30

	WL	ANI_CODE,#zero_x

	WL	3,D4PJ4A+FR4
	WL	3,D4PJ4A+FR6
	WL	10,D4PJ4A+FR7
	.word	ANI_WAITHITGND
#land
	.WORD	ANI_ADD_MOVE,MOVE_C_4,2,2
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_ZERO_XZVELS
;Perhaps even shake ropes
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,18

;	.word	ANI_ATTACK_ON_Z, AMODE_LBOWDROP,-6,22,16,25,27,30 ;mode,x,y,z,w,h,d
	.word	ANI_ATTACK_ON, AMODE_LBOWDROP,-6,0,25,27 ;mode,x,y,z,w,h,d

	WL	1,D4PJ4A+FR10
	.word	ANI_WAITHITGND
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#gothim4
	.word	ANI_BOUNCE,3
	WL	ANI_CODE,HIT_THE_MAT

;He missed, have him stay on ground for awhile!

	WL	ANI_CODE,CALL_MISSES
	WL	40,D4PJ4A+FR10
	.word	ANI_WAITHITGND
	WL	ANI_GOTO,#land2

#gothim4
	.word	ANI_DRAW_NAME,18
	.word	ANI_BOUNCE,4
	WL	ANI_CODE,HIT_THE_MAT
	WL	15,D4PJ4A+FR10
#land2

	.word	ANI_WAITHITGND
	.word	ANI_XFLIP
	.word	ANI_OFFSET,10,0,0			;x,y,z

;Getting up, set no_collis
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS|MODE_NOAUTOFLIP	;uninterruptable

	WL	4,D3GU4A+FR3
	WL	3,D3GU4A+FR4
	WL	3,D3GU4A+FR5
	WL	3,D3GU4A+FR6

;Check for a flip here
	WL	1,D3GU4A+FR7
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,D3GU4A+FR7

	WL	3,D3GU4A+FR8
	WL	3,D3GU4A+FR9

	.word	ANI_SAFE_TIME,50

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss6
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,37,88,63,9
	WL	1,D3GU4A+FR9
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss6

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,dnk_4_push_anim
#no_freetoss6

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

;Elbow drop #4 from turnbuckle
 SUBR	dnk_4_blbowdrop_anim

;If jumping toward an in ring opponent & near the edge of ring, turn on
;the confine bit!

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCONFINE|MODE_NOGRAVITY
	.word	ANI_SCROLL_CTRL,SC_RESTORE
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim

	.word	ANI_OFFSET,11,4,0			;x,y,z

	WL	2,D4PJ4A+FR2
	WL	2,D4PJ4A+FR3

	.word	ANI_OFFSET,0,31h,0			;x,y,z

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 38,190,190,190,90000h,TGT_CHEST,-3,-3,50
	.word	ANI_GRAVITY_ON
;	.word	ANI_SETPLYRMODE,MODE_INAIR2
	WL	ANI_CODE,set_tbukl_airmode
	.word	ANI_STARTATTACK,AT_LEAPING,25

	.word	ANI_SHAKECORNER		;Shake corner ropes

	.WORD	ANI_ADD_MOVE,MOVE_C_4,2,2

	WL	3,D4PJ4A+FR4
	WL	3,D4PJ4A+FR6

	WL	6,D4PJ4A+FR7
 	WL	ANI_CODE,set_tbukl_confine
	WL	4,D4PJ4A+FR7
	.word	ANI_ATTACK_ON_Z,AMODE_BLBOWDROP,-46,0,16,92,34,30
	WWL	ANI_IFOPPMODE,MODE_ONGROUND,#opp_onground
	WWL	ANI_IFOPPMODE,MODE_DEAD,#opp_onground
	.word	ANI_ATTACK_ON_Z,AMODE_BLBOWDROP,-46,28,16,92,34,30
#opp_onground
	WL	1,D4PJ4A+FR7

	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_ZERO_XZVELS
;Perhaps even shake ropes
	.word	ANI_SHAKEALL,1
	.word	ANI_SHAKER,25
	WL	ANI_CODE,HIT_THE_MAT

	WL	1,D4PJ4A+FR10
	.word	ANI_ATTACK_OFF

	.WORD	ANI_ADD_MOVE,MOVE_C_9,2,2
	WL	ANI_IFSTATUS,#gothimb
	.word	ANI_BOUNCE,4	 		;Bigger bounce
	WL	ANI_CODE,HIT_THE_MAT
;	WL	ANI_CODE,SMALL_BOUNCE

;He missed, have him stay on ground for awhile!

;	WL	ANI_CODE,tbukl_miss_damage
	WL	ANI_CODE,CALL_MISSES
	WL	25,D4PJ4A+FR10
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_GOTO,#tag
	

#gothimb
	.word	ANI_DRAW_NAME,18
	.word	ANI_BOUNCE,4
	WL	ANI_CODE,HIT_THE_MAT
	WL	15,D4PJ4A+FR10
	.word	ANI_WAITHITGND
#tag	.word	ANI_XFLIP
	.word	ANI_OFFSET,-10,0,0			;x,y,z

;Getting up, set no_collis
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS|MODE_NOAUTOFLIP	;uninterruptable

	WL	4,D3GU4A+FR3
	WL	3,D3GU4A+FR4
	WL	3,D3GU4A+FR5
	WL	3,D3GU4A+FR6

;Check for a flip here
	WL	1,D3GU4A+FR7
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,D3GU4A+FR7

	WL	3,D3GU4A+FR8
	WL	3,D3GU4A+FR9

	.word	ANI_SAFE_TIME,50

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss7
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,37,88,63,9
	WL	1,D3GU4A+FR9
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss7

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,dnk_4_push_anim
#no_freetoss7

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


* #4 HAMMER POUND OF FALLEN OPPONENT

 SUBR	dnk_4_hammer_anim
;Fix attack boxes!  No z

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_CLR_BUTCOUNT
	.word	ANI_STARTATTACK,AT_HAMMER1,12
	WL	3,D4HM4A+FR1
	WL	3,D4HM4A+FR2

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 6,190,90,50,90000h,TGT_GROIN,95,82,13h	;13

	.word	ANI_SET_RPTCOUNT,4	;5 times

	WL	6,D4HM4A+FR3	;16
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,D4HM4A+FR4
	WL	3,D4HM4A+FR5
	WL	2,D4HM4A+FR6
	.word	ANI_ATTACK_ON, AMODE_HAMMER,31,3,88,73 ;mode,x,y,w,h
	WL	3,D4HM4A+FR7
	.word	ANI_ATTACK_OFF

	.WORD	ANI_ADD_MOVE,MOVE_C_2,2,2
	WL	ANI_IFNOTSTATUS,#tagmiss
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker
;He got him, shake screen
	.word	ANI_DAMAGEOPP,D_HAMMER1,RD_HAMMER1
	.word	ANI_DRAW_NAME,25

;Immobilize player for 30 ticks without meter on!
	.word	ANI_IMMOBILIZE,30
	.word	ANI_SHAKER,25

	WL	ANI_CODE,CALL_NASTY_MOVE
	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#missedb
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#dnk_quick_hammer

#missedb
#tagmiss

	WL	3,D4HM4A+FR8
	WL	3,D4HM4A+FR9
	WL	3,D4HM4A+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#dnk_quick_hammer
	.word	ANI_CLR_BUTCOUNT
	.word	ANI_STARTATTACK,AT_HAMMER1,27
   	WL	3,D4HM4A+FR8
	WL	3,D4HM4A+FR9
	WL	3,D4HM4A+FR10
	WL	3,D4HM4A+FR1
	WL	3,D4HM4A+FR2
	WL	3,D4HM4A+FR3
	WL	3,D4HM4A+FR4
	WL	3,D4HM4A+FR5
	WL	3,D4HM4A+FR6
	.word	ANI_ATTACK_ON, AMODE_HAMMER,31,3,88,73 ;mode,x,y,w,h
	WL	3,D4HM4A+FR7
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#tagmiss
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

;Immobilize player for 30 ticks without meter on!
	.word	ANI_IMMOBILIZE,30

	.word	ANI_SHAKER,25

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,2,#failed
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#dnk_quick_hammer
	WL	20,D4HM4A+FR7
#failed

	WL	3,D4HM4A+FR8
	WL	3,D4HM4A+FR9
	WL	3,D4HM4A+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


dnk_combo_hammer_anim
	.word	ANI_SET_RPTCOUNT,3	;5 times
	.word	ANI_IMMOBILIZE,30
;	.word	ANI_STARTATTACK,AT_HAMMER1,23
	WL	4,D4HM4A+FR1
	WL	4,D4HM4A+FR2
	WL	4,D4HM4A+FR3	;16
	WL	3,D4HM4A+FR4
	WL	4,D4HM4A+FR5
	WL	4,D4HM4A+FR6
	.word	ANI_ATTACK_ON, AMODE_HAMMER,31,3,88,73 ;mode,x,y,w,h
	WL	4,D4HM4A+FR7
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed2
	.WORD	ANI_INC_COMBO
	.word	ANI_IMMOBILIZE,30
	.word	ANI_SHAKER,25

dnk_repeat_combo_hammer_anim
	.word	ANI_CLR_BUTCOUNT
;	.word	ANI_STARTATTACK,AT_HAMMER1,15
   	WL	2,D4HM4A+FR8
	WL	1,D4HM4A+FR9
	WL	2,D4HM4A+FR10
	WL	2,D4HM4A+FR1
	WL	1,D4HM4A+FR2
	WL	2,D4HM4A+FR3
	WL	2,D4HM4A+FR4
	WL	1,D4HM4A+FR5
	WL	2,D4HM4A+FR6
	.word	ANI_ATTACK_ON, AMODE_HAMMER,31,3,88,73 ;mode,x,y,w,h
	WL	2,D4HM4A+FR7
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed2
	.WORD	ANI_INC_COMBO

;Immobilize player for 30 ticks without meter on!
	.word	ANI_IMMOBILIZE,30

	.word	ANI_SHAKER,25

	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,2,#missed2
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,dnk_repeat_combo_hammer_anim

#missed2
	WL	ANI_CODE,DO_COMBO_MESS
	WL	3,D4HM4A+FR8
	WL	3,D4HM4A+FR9
	WL	3,D4HM4A+FR10
	.WORD	ANI_CLEAR_COMBO

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END



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

#zero_x
	move	*a13(CLOSEST_XDIST),a0
	cmpi	>40,a0
	jrgt	#ok			;Is he to the side?

;Don't float if dropping straight down
	clr	a0
	move	a0,*a13(OBJ_XVEL),L
#ok	rets

#get_off
;Get off from fallen opponent
	movi	[3,0],a0
	move	a0,*a13(OBJ_ZVEL),L
	movi	[2,0],a0
	move	a0,*a13(OBJ_YVEL),L
	rets

#*****************************************************************************
*
* #2 STOMP ON FALLEN OPPONENT

 SUBR	dnk_2_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D3MP3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D3MP3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D3MP3A+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	.word	ANI_STARTATTACK,AT_STOMP,15
	WL	ANI_CODE,#set_target
	WL	ANI_CODE,tgt_ground
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 13,999,160,140,90000h,TGT_USER,20,0,-30

	WL	3,D3MP3A+FR2
	WL	2,D3MP3A+FR3
	WL	3,D3MP3A+FR4
	WL	2,D3MP3A+FR5
	WL	3,D3MP3A+FR6

	.word	ANI_ATTACK_ON_Z, AMODE_STOMP,7,7,-20,20,33,30 ;mode,x,y,z,w,h,d
	.word	ANI_ZERO_XZVELS

	WL	3+4,D3MP3A+FR7
	.word	ANI_ATTACK_OFF
;	WL	ANI_CODE,SMALL_BOUNCE

	.WORD	ANI_ADD_MOVE,MOVE_C_4,2,2
	WL	ANI_IFSTATUS,#gothim
	WL	3,D3MP3A+FR8
	.word	ANI_WAITHITGND
	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#gothim
	WL	ANI_CODE,#get_off
	WL	2,D3MP3A+FR8
	.word	ANI_WAITHITGND
	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


* #4 STOMP ON FALLEN OPPONENT

 SUBR	dnk_4_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
    
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D4MP4D+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D4MP4D+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim
	WL	1,D4MP4D+FR1
	WWL	ANI_IFBUTTONS,PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,start_run_anim

	WL	ANI_CODE,#set_target
	WL	ANI_CODE,tgt_ground
	.word	ANI_STARTATTACK,AT_STOMP,15
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 13,999,160,140,90000h,TGT_USER,32,0,30

	WL	3,D4MP4D+FR2
	WL	3,D4MP4D+FR3
	WL	7,D4MP4D+FR4

;#cont4
;	WL	3,D4MP4D+FR5

;	.word	ANI_ATTACK_ON_Z, AMODE_STOMP,2,1,40,19,27,30 ;mode,x,y,z,w,h,d
	.word	ANI_ATTACK_ON_Z, AMODE_STOMP,22,8,40,35,22,30 ;mode,x,y,z,w,h,d

	.word	ANI_ZERO_XZVELS

	WL	7,D4MP4D+FR6
	.word	ANI_ATTACK_OFF

;	WL	ANI_CODE,SMALL_BOUNCE

	.WORD	ANI_ADD_MOVE,MOVE_C_4,2,2
	WL	ANI_IFSTATUS,#gothim4
	WL	3,D4MP4D+FR7
	.word	ANI_WAITHITGND
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END
#gothim4
	WL	ANI_CODE,#get_off4
	WL	2,D4MP4D+FR7
	.word	ANI_WAITHITGND
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


;Stomp #4 from top of turnbuckle
 SUBR	dnk_4_bstomp_anim

;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOCOLLIS|MODE_NOGRAVITY|MODE_OVERLAP
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOGRAVITY|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_XFLIP		;make an ANI_FACEOUT and ANI_FACEIN
	.word	ANI_SCROLL_CTRL,SC_RESTORE
    
	WL	3,D4JD4A+FR1
	WL	3,D4JD4A+FR2

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 16+20,190,190,190,90000h,TGT_CHEST,39+8,7+4,20
	.word	ANI_GRAVITY_ON
;	.word	ANI_SETPLYRMODE,MODE_INAIR2
	WL	ANI_CODE,set_tbukl_airmode

	.word	ANI_STARTATTACK,AT_LEAPING,36

	.word	ANI_SHAKECORNER		;Shake corner ropes

;Check x vel to make sure we aren't going to land on ropes!
;	WL	ANI_CODE,check_xvel

	.word	ANI_OFFSET,8,4,0		;x,y,z
	WL	ANI_IFNOTSTATUS,#nooff
	.word	ANI_OFFSET,-16,0,0		;x,y,z

#nooff
	WL	3,D4MP4D+FR2
	WL	3,D4MP4D+FR3

	WL	6,D4MP4D+FR4
	WL	ANI_CODE,set_tbukl_confine
	WL	9,D4MP4D+FR4

	WL	1eh-15,D4MP4D+FR4
 	
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-46,0,0,92,34,30
	WWL	ANI_IFOPPMODE,MODE_ONGROUND,#opp_onground
	WWL	ANI_IFOPPMODE,MODE_DEAD,#opp_onground
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-46,28,0,72,34,30
#opp_onground
	WL	3,D4MP4D+FR6

	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_ZERO_XZVELS

	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,1
	WL	ANI_CODE,shake_all_ropes

;	WL	1,D4MP4D+FR7

	.word	ANI_BOUNCE,6

	WL	ANI_CODE,HIT_THE_MAT

	WL	6,D4MP4D+FR6
	.word	ANI_ATTACK_OFF

	WL	9,D4MP4D+FR7

	.WORD	ANI_ADD_MOVE,MOVE_C_9,2,2
	WL	ANI_IFSTATUS,#gothimb4
	WL	3,D4MP4D+FR7
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
;	WL	ANI_CODE,tbukl_miss_damage

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


 SUBR	check_xvel

	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)

	;don't mess with anything if opponent is ouside the ring
	move	*a13(CLOSEST_NUM),a0
	X32	a0
	addi	process_ptrs,a0
	move	*a0,a0,L
	move	*a0(INRING),a0,W
	jrnz	#ok

	move	*a13(OBJ_XPOSINT),a0
	cmpi	RING_X_MID,a0
	jrgt	#onrgt

;Check to make sure opponent is in ring!
	move	*a13(OBJ_XVEL),a0,L
	jrnn	#ok
;	cmpi	[0,8000h],a0
;	jrge	#ok
;Will land on ropes
	movi	[1,8000h],a0
	move	a0,*a13(OBJ_XVEL),L

	move	*a13(ANIMODE),a1
	ori	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets
#onrgt
;Check to make sure opponent is in ring!
	move	*a13(OBJ_XVEL),a0,L
	jrn	#ok
;	cmpi	-[0,8000h],a0
;	jrle	#ok
;Will land on ropes
	movi	-[1,8000h],a0
	move	a0,*a13(OBJ_XVEL),L

	move	*a13(ANIMODE),a1
	ori	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
#ok
	rets

#gothimb4
	WLW	ANI_SET_ZVEL,-50000h,AM_ABS
;	WL	ANI_CODE,#getoff4

	WL	5,D4MP4D+FR7
	.word	ANI_WAITHITGND

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#set_target

	calla	get_opp_process
	move	a0,a11

	move	*a13(STICK_VAL_CUR),a0
	btst	MOVE_LEFT_BIT,a0
	jrnz	#lft
	btst	MOVE_RIGHT_BIT,a0
	jrnz	#rgt
;No stick
;Randomize between head/chest/groin/knees
;	movk	3,a0
;	calla	RNDRNG0
;	X16	a0
;	addi	#targets,a0
;	move	*a0,a0

	movi	TGT_CHEST,a0

	calla	set_target_offsets
	rets

;Go to chest or if opponent is flipped, go to head!
#lft
	move	*a11(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#chest
#head
	movi	TGT_HEAD,a0
	calla	set_target_offsets
	rets

;Go to head or if opponent is flipped, go to chest!
#rgt
	move	*a11(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#head
#chest
	movi	TGT_KNEES,a0
	calla	set_target_offsets
	rets

; or set *a13(TGT_XOFF), *a13(TGT_YOFF) & *a13(TGT_ZOFF) manually

#targets
	.word	TGT_HEAD	;0
	.word	TGT_CHEST	;1
	.word	TGT_GROIN	;2
	.word	TGT_KNEES	;3


#get_off
	movi	[4,0],a0
	move	a0,*a13(OBJ_ZVEL),L
	movi	[2,0],a0
	move	a0,*a13(OBJ_YVEL),L
	rets

#get_off4
	movi	-[2,0],a0
	move	a0,*a13(OBJ_ZVEL),L
	movi	[1,0],a0
	move	a0,*a13(OBJ_YVEL),L
	rets


#*****************************************************************************
*

 SUBR	dnk_knockdwn_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_XFLIP
 
	WL	2,D3GU4A+FR9
	WL	2,D3GU4A+FR7
	WL	2,D3GU4A+FR5
	WL	ANI_SET_YVEL,39000h
	WL	2,D3SA3A+FR2
	.word	ANI_DEBRIS,200,1,0,8,0		;%chance, tbl index, x,y,z off
	WL	3,D3SA3A+FR3
	WL	6,D3SA3A+FR4
	WL	3,D3SA3A+FR5
	WL	3,D3SA3A+FR7
	WL	2,D3SA3A+FR8
	WL	6,D3SA3A+FR9


;FIX!!!  Add to other wrestlers

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	.word	ANI_SETPLYRMODE,MODE_DEAD
	.word	ANI_END

#nodead


;#done
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,dnk_faceup_getup_anim


#*****************************************************************************
*
* HITS ON GROUND

 SUBR	dnk_hitonground_xflip_anim
	.word	ANI_XFLIP
	;fall through

 SUBR	dnk_hitonground_anim

;We need to take stars away on hits...

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h
	WL	ANI_SET_YVEL,39000h

	.word	ANI_DEBRIS,50,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	2,D3SA3A+FR2
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPITUP_SWEAT,SWEAT_PER,0
	WL	3,D3SA3A+FR3
	WL	6,D3SA3A+FR4
	WL	3,D3SA3A+FR5
	WL	3,D3SA3A+FR7
	WL	2,D3SA3A+FR8
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	1,D3SA3A+FR9

 SUBR	dnk_liedown_anim
	WL	1,D3SA3A+FR9

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,dnk_faceup_getup_anim

 SUBR	dnk_up_anim

;We need to take stars away on hits...

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.WORD	ANI_XFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETSPEED,100h

	WL	10,D3OS3A+FR3
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,D3SA3A+FR9

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,dnk_faceup_getup_anim

#*****************************************************************************
*
* CLIMB UP TURNBUCKLES

 SUBR	dnk_climb_up_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE | MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SCROLL_CTRL,DNK_TBUKLY
	WL	ANI_SET_YVEL,4000h	;27000	
	.word	ANI_OFFSET,-8+13,-3+4,-16		;x,y,z
	WL	4,D2CT2A+FR2
	.word	ANI_OFFSET,0,15h,0			;x,y,z
	WL	4,D2CT2A+FR7
	.word	ANI_SHAKEROPES,1
	.word	ANI_OFFSET,4,4,0			;x,y,z
	WL	4,D2CT2A+FR9
	.word	ANI_OFFSET,6,14,0			;x,y,z
	WL	4,D2CT2A+FR12
	.word	ANI_ZEROVELS

	.word	ANI_OFFSET,0,6,0			;x,y,z
	WL	4,D2CT2B+FR2
	.word	ANI_OFFSET,10,18h,0			;x,y,z
	WL	4,D2CT2B+FR4
	.word	ANI_OFFSET,-2,19,0			;x,y,z
	WL	4,D2CT2B+FR6

	.word	ANI_SETPLYRMODE,MODE_ONTURNBKL
	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOGRAVITY|MODE_UNINT|MODE_OVERLAP
	.word	ANI_SCROLL_CTRL,SC_RESTORE

	.WORD	ANI_ADD_MOVE,MOVE_C_4,2,2

	.word	ANI_OFFSET,2,0,0			;x,y,z
	WL	ANI_CODE,tbukl_flip
#repeat	WL	5,D2CT2C+FR1
	WL	ANI_CODE,tbukl_flip
	WL	5,D2CT2C+FR3
	WL	ANI_CODE,tbukl_flip
	WL	5,D2CT2C+FR5
	WL	ANI_CODE,tbukl_flip
	WL	5,D2CT2C+FR7
	WL	ANI_CODE,tbukl_flip
	WL	5,D2CT2C+FR9
	WL	ANI_CODE,tbukl_flip
	WL	5,D2CT2C+FR11
	WL	ANI_CODE,tbukl_flip
	WL	5,D2CT2C+FR13
	WL	ANI_CODE,tbukl_flip
	WL	5,D2CT2C+FR15
	WL	ANI_CODE,tbukl_flip
	WL	5,D2CT2C+FR17
	WL	ANI_CODE,tbukl_flip
	WL	5,D2CT2C+FR19
	WL	ANI_CODE,tbukl_flip
	WL	5,D2CT2C+FR21
	WL	ANI_CODE,tbukl_flip
	WL	ANI_GOTO,#repeat

* CLIMB DOWN TURNBUCKLES

 SUBR	dnk_climb_down_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE | MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,face_inside

	.word	ANI_OFFSET,0,2,0			;x,y,z
	WL	5,D2CT2B+FR6
	.word	ANI_OFFSET,0,-13-3,0			;x,y,z
	WL	5,D2CT2B+FR4

	WL	ANI_SET_YVEL,-4000h

	.word	ANI_OFFSET,-8,-26-3,0			;x,y,z
	WL	4,D2CT2B+FR2
	.word	ANI_OFFSET,0,-5-3,0			;x,y,z
	.word	ANI_SHAKEROPES,1
	WL	4,D2CT2A+FR12
	.word	ANI_OFFSET,0,-10-3,0			;x,y,z
	WL	4,D2CT2A+FR9
	.word	ANI_OFFSET,0,-10-3,0			;x,y,z
	WL	4,D2CT2A+FR7
	.word	ANI_OFFSET,-9,-9-3,0			;x,y,z
	WL	4,D2CT2A+FR2

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_WAITHITGND

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

;#*****************************************************************************
;*
;* SECOND WIND
;
; SUBR	dnk_2ndwind_anim
;
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_ZEROVELS
;	.word	ANI_SETSPEED,100h
;	WL	3,D4SW4B+FR1
;	WL	3,D4SW4B+FR2
;
;	WL	3,D4SW4E+FR1
;	WL	3,D4SW4E+FR2
;	WL	3,D4SW4E+FR3
;	WL	3,D4SW4E+FR4
;	WL	3,D4SW4E+FR5
;
;	WL	3,D4SW4E+FR1
;	WL	3,D4SW4E+FR2
;	WL	3,D4SW4E+FR3
;	WL	3,D4SW4E+FR4
;	WL	3,D4SW4E+FR5
;
;	WL	3,D4SW4F+FR1
;	WL	3,D4SW4F+FR2
;	WL	3,D4SW4F+FR3
;	WL	3,D4SW4F+FR4
;	WL	3,D4SW4F+FR5
;	WL	3,D4SW4F+FR6
;	WL	3,D4SW4F+FR7
;
;	WL	3,D4SW4F+FR1
;	WL	3,D4SW4F+FR2
;	WL	3,D4SW4F+FR3
;	WL	3,D4SW4F+FR4
;	WL	3,D4SW4F+FR5
;	WL	3,D4SW4F+FR6
;	WL	3,D4SW4F+FR7
;
;	.word	ANI_SETMODE,MODE_NORMAL
;

#*****************************************************************************
*
* BUTT DROP FROM TOP OF TURNBUCKLE

 SUBR	dnk_diveofftb_anim

;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS|MODE_NOGRAVITY|MODE_OVERLAP|MODE_NOCONFINE
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY|MODE_OVERLAP|MODE_NOCONFINE
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	.word	ANI_SCROLL_CTRL,SC_RESTORE

	.word	ANI_STARTATTACK,AT_LEAPING,43
	WL	4,D4JD4A+FR1
	WL	4,D4JD4A+FR2		;D4FM4A+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 35,190,190,190,90000h,TGT_CHEST,-15,0,-10

	.word	ANI_GRAVITY_ON
;	.word	ANI_SETPLYRMODE,MODE_INAIR2
	WL	ANI_CODE,set_tbukl_airmode

	.word	ANI_SHAKECORNER		;Shake corner ropes

	WL	3,D4JD4A+FR4

	.word	ANI_OFFSET,0,45,0		;x,y,z

	WL	3,D4FM4A+FR5
	WL	3,D4FM4A+FR6
	WL	ANI_CODE,set_tbukl_confine

	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-24,0,-30,86,34,60 ;mode,x,y,z,w,h,d
	WWL	ANI_IFOPPMODE,MODE_ONGROUND,#opp_onground
	WWL	ANI_IFOPPMODE,MODE_DEAD,#opp_onground
	.word	ANI_ATTACK_ON_Z,AMODE_BSTOMP,-24,28,-30,60,34,60
#opp_onground
	WL	1,D4FM4A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ATTACK_OFF
	.word	ANI_ZEROVELS
	.word	ANI_ADD_MOVE,MOVE_C_9,2,2
	WL	ANI_IFSTATUS,#hit

#missed
;	WL	ANI_CODE,tbukl_miss_damage
	WL	ANI_CODE,CALL_MISSES
	WL	ANI_CODE,shake_all_ropes
	WL	ANI_CHANGEANIM,dnk_hitonground_xflip_anim

#hit	WLW	ANI_SET_ZVEL,20000h,AM_ABS

#cont	WL	ANI_CODE,shake_all_ropes
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	;bounce
	.word	ANI_SHAKER,18
	.word	ANI_BOUNCE,6
	WL	ANI_CODE,HIT_THE_MAT
	WL	5,D4FM4A+FR7

	WL	1,D4FM4A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,SMALL_BOUNCE
	WL	5,D4FM4A+FR7
	WL	8,D4FM4A+FR9

	.word	ANI_XFLIP
	.word	ANI_FACEDOWN

;Getting up, set no_collis
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS|MODE_NOAUTOFLIP	;uninterruptable

	WL	3,D3GU4A+FR3
	WL	3,D3GU4A+FR4
	WL	3,D3GU4A+FR5
	WL	3,D3GU4A+FR6

;Check for a flip here
	WL	1,D3GU4A+FR7
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,D3GU4A+FR7

	WL	3,D3GU4A+FR8
	WL	3,D3GU4A+FR9

	.word	ANI_SAFE_TIME,30

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss8
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,37,88,63,9
	WL	1,D3GU4A+FR9
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss8

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,dnk_4_push_anim
#no_freetoss8

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* GRAB & FLING OPPONENT (INTO A RUN)

 SUBR	dnk_2_grabfling_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,10
	WL	2,D1TT5Z+FR2
	WL	2,D1TT5Z+FR3
	WL	ANI_GOTO,#cont

 SUBR	dnk_4_grabfling_anim

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
	WL	5,D4GF3A+FR1

	.word	ANI_ATTACK_ON, AMODE_PUPPET_NOFLAIL,33,56,44,18 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,6,D4GF3A+FR2
	.word	ANI_ZERO_XZVELS
	WWL	ANI_WAITHITOPP,2,D4GF3A+FR3
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
	.word	ANI_SETOPPFACING
	WWLLW	ANI_SUPERSLAVE2,10,D4GF3A+FR3,#puppet_tbl,0
	.word	ANI_WAITHITGND
	WWLLW	ANI_SUPERSLAVE2,6,D4GF3A+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,D4GF3A+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,D4GF3A+FR6,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,D4GF3A+FR7,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,D4GF3A+FR8,#puppet_tbl,5
	.WORD	ANI_ADD_MOVE,MOVE_C_4,2,2

	WL	ANI_SLAVEANIM,#strt_run_tbl

	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_DETACH
	WL	10,D4GF3A+FR9	;16
	.word	ANI_OFFSET,-10,0,0			;x,y,z

	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#missedb
	WL	ANI_CODE,fling_delay
	WL	ANI_IFNOTSTATUS,#missed
	WL	25,D4GF3A+FR3

#missed
	WL	ANI_CODE,CALL_MISSES
	WL	6,D4GF3A+FR3
	WL	3,D4GF3A+FR2
	WL	3,D4GF3A+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	fling_delay

	move	*a13(LAST_FLING),a14,L
	move	@PCNT,a0,L			;use 32-bit PCNT!
	move	a0,*a13(LAST_FLING),L
	sub	a14,a0
	cmpi	3*60,a0
	jrge	#ok

;This blocked fling attempt is too close (in terms of time) to most recent grab
	move	*a13(ANIMODE),a1
	ori	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets

#ok	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets

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

#Bret
 LWWW H4YR3A+FR1,53,7,1
 LWWW H4YR3A+FR2,49,9,1
 LWWW H4YR3A+FR3,48,9,1
 LWWW H4YR3A+FR5,43,11,1
 LWWW H3RN3A+FR1,15,5,0
 LWWW H3RN3A+FR2,-14,8,0
#Razor
 LWWW R4YR3A+FR1,32,17,0
 LWWW R4YR3A+FR2,21,20,0
 LWWW R4YR3A+FR3,1,11,0
 LWWW R4YR3A+FR4,4,15,0
 LWWW R3RN3D+FR10,9,16,0
 LWWW R3RN3D+FR11,-4,16,0
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
 LWWW Y3RN3C+FR7,18,13,0
 LWWW Y3RN3C+FR8,8,12,0
#Shawn
 LWWW S4YR3A+FR2,38,5,1
 LWWW S4YR3A+FR3,52,-3,1
 LWWW S4YR3A+FR5,21,11,1
 LWWW S4YR3A+FR6,19,10,1
 LWWW S3RN3A+FR2,16,11,0
 LWWW S3RN3A+FR3,4,11,0
#BamBam
 LWWW B4YR3A+FR3,32,15,0
 LWWW B4YR3A+FR4,43,11,0
 LWWW B4YR3A+FR5,53,12,0
 LWWW B4YR3A+FR7,9,9,0
 LWWW B3RN3A+FR1,6,19,0
 LWWW B3RN3A+FR2,3,17,0
#Doink
 LWWW D4YR3B+FR1,64,16,1
 LWWW D4YR3B+FR2,60,20,1
 LWWW D4YR3B+FR3,47,19,1
 LWWW D4YR3B+FR4,38,20,1
 LWWW D3RN3B+FR3,23,20,0
 LWWW D3RN3B+FR4,-8,18,0
#Adam
 .long 0
#Lex
 LWWW L4YR3B+FR1,66,16,1
 LWWW L4YR3B+FR2,54,10,1
 LWWW L4YR3B+FR3,38,13,1
 LWWW L4YR3B+FR4,13,11,1
 LWWW L3RN3B+FR2,0,19,0
 LWWW L3RN3B+FR3,10,13,0

#strt_run_tbl
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung
	.long	start_run_flung,start_run_flung,start_run_flung

#*****************************************************************************
*
* HELD OVERHEAD ANIMATION

 SUBR	dnk_heldoh_anim

	.word	ANI_SETPLYRMODE,MODE_ATTACHED
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_SETSPEED,100h

	.word	ANI_SETWORD,USR_VAR1,0		;loop count

	WL	ANI_CODE,DO_OTHERNONO
#loop
	WL	3,D4MF4A+FR1
	WL	3,D4MF4A+FR2
	WL	3,D4MF4A+FR3
	WL	3,D4MF4A+FR4
	WL	3,D4MF4A+FR5
	WL	3,D4MF4A+FR6
	WL	3,D4MF4A+FR7
	WL	3,D4MF4A+FR8
	WL	3,D4MF4A+FR9

	WL	ANI_CODE,#inc_loop
	WL	ANI_IFNOTSTATUS,#loop

;Fall out of overhead hold by reversing thru pickup frames
	.word	ANI_DETACH

 
	.word	ANI_SETMODE,MODE_NORMAL|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_INAIR

	WL	ANI_CODE,FIND_AND_KILL_ENDLESS

	WL	ANI_SET_YVEL,10000h
	WLW	ANI_SET_XVEL,-40000h,AM_HIT_REL
	WLW	ANI_SET_ZVEL,10000h,AM_ABS
	.word	ANI_FRICTION,3000h

	WL	2,D4MF4A+FR6
	.word	ANI_OFFSET,-20,-50,0			;x,y,z
	WL	4,D3GS3X+FR5
	WL	4,D3GS3X+FR4
	WL	4,D3GS3X+FR3
	WL	4,D3GS3X+FR1
	.word	ANI_WAITHITGND
	WL	2,D2ST2B+FR3

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

;#*****************************************************************************
;*
;* #2 BLOCK
;
; SUBR	dnk_2_block_anim
;
;	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
;	.word	ANI_ZERO_XZVELS
;	.word	ANI_SETSPEED,100h
;	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
;	.word	ANI_SET_WRESTLER_XFLIP
;
;	WL	ANI_CODE,block_if_safe
;	WL	2,D2BK3C+FR1
;	WL	1,D2BK3C+FR2
;	.word	ANI_SETPLYRMODE,MODE_BLOCK
;
;	WL	1,D2BK3C+FR2
;#blk2	WL	2,D2BK3C+FR3
;	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT
;	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
;	.word	ANI_SETMODE,MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_SETFACING
;	WL	2,D2BK3C+FR2
;	WL	2,D2BK3C+FR1
;	.word	ANI_SETPLYRMODE,MODE_NORMAL
;
; SUBR	dnk_2_hitblock_anim
;
;	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
;	.word	ANI_FRICTION,4000h
;	.word	ANI_SETSPEED,100h
;
;	WL	ANI_CODE,DO_BLOCKED
;	WL	4,D2BK3C+FR7
;	WL	4,D2BK3C+FR5
;	WL	ANI_GOTO,#blk2

* #4 BLOCK

 SUBR	dnk_4_block_anim

	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
	.word	ANI_ZERO_XZVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETPLYRMODE,MODE_BLOCK
;	WL	ANI_CODE,block_if_safe
	WL	2,D4BK3A+FR1
	WL	1,D4BK3A+FR2
;	.word	ANI_SETPLYRMODE,MODE_BLOCK
	WL	1,D4BK3A+FR2
#blk4	WL	2,D4BK3A+FR3
	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT|MODE_FRICTION
;	.word	ANI_ZERO_XZVELS
	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
	.word	ANI_SETMODE,MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETFACING
	WL	2,D4BK3A+FR2
	WL	2,D4BK3A+FR1
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	dnk_4_hitblock_anim

	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
	.word	ANI_FRICTION,5000h
	.word	ANI_SETSPEED,100h
	WL	ANI_CODE,DO_BLOCKED
	WL	2,D4BK3A+FR7
	WL	2,D4BK3A+FR6
	WL	ANI_GOTO,#blk4

 SUBR	dnk_4_hitblock2_anim

	.word	ANI_SETMODE,MODE_UNINT			;uninterruptable
	.word	ANI_FRICTION,4000h
	.word	ANI_SETSPEED,100h
	WL	ANI_CODE,DO_BLOCKED
	WL	ANI_SET_YVEL,38000h
	WL	3,D4BK3A+FR6
	WL	3,D4BK3A+FR7
	WL	3,D4BK3A+FR6
	WL	3,D4BK3A+FR7
	WL	3,D4BK3A+FR6
	WL	3,D4BK3A+FR7

	WL	ANI_GOTO,#blk4

#*****************************************************************************
*
* HIP TOSS RUNNING OPPONENT

 SUBR	dnk_2_hiptoss2_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS	;uninterruptable
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,6
;	WL	2,D1TT5Z+FR2
;	WL	2,D1TT5Z+FR3

 SUBR	dnk_4_hiptoss2_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCOLLIS	;uninterruptable
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,2
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,60,55,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_SET_YVEL,0

	WL	2,D3HT3Q+FR1
	.word	ANI_ATTACK_ON, AMODE_PUPPET_TOSS,33,46,44,38 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,8,D3HT3Q+FR1
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACK_OFF

	WL	ANI_GOTO,#cont

 SUBR	dnk_2_hiptoss_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,10
;	WL	2,D1TT5Z+FR2
;	WL	2,D1TT5Z+FR3

 SUBR	dnk_4_hiptoss_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,10
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_SET_YVEL,0000h

	WL	4,D3HT3Q+FR1
	.word	ANI_ATTACK_ON, AMODE_PUPPET_TOSS,33,46,44,38 ;mode,x,y,w,h
 	WWL	ANI_WAITHITOPP,4,D3HT3Q+FR1
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACK_OFF
	WL	4,D3HT3Q+FR1
#cont
	.WORD	ANI_ADD_MOVE,MOVE_C_4,2,2
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker

#got_him
	.ref	MAKE_HIM_SCREAM
	WL	ANI_CODE,MAKE_HIM_SCREAM
	WL	ANI_CODE,DO_GRUNT
	.word	ANI_DRAW_NAME,3
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	.word	ANI_ATTACHZ,0,0,2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

; attacker sequence
	WWLLW	ANI_SUPERSLAVE2,4,D3HT3Q+FR1,#puppet_tbl,0
	WL	ANI_CODE,SMALL_BOUNCE
;	.word	ANI_WAITHITGND
	WWLLW	ANI_SUPERSLAVE2,4,D3HT3Q+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,D3HT3Q+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,D3HT3Q+FR4,#puppet_tbl,3
	.WORD	ANI_ADD_MOVE,MOVE_C_1,2,2
	WWWL	ANI_IFROPE,RC_BACK,XTOSSDIST_CLOSE,#throw_him_out
	WWLLW	ANI_SUPERSLAVE2,4,D3HT3Q+FR5,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,D3HT3Q+FR6,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,4,D3HT3Q+FR7,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,1,D3HT3Q+FR8,#puppet_tbl,7

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_DAMAGEOPP,D_HIPTOSS,RD_HIPTOSS

	WL	ANI_SLAVEANIM,#rollout_tbl

	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_DETACH

	WL	10,D3HT3Q+FR8
	WL	3,D3HT3Q+FR7
	WL	3,D3HT3Q+FR6

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedb
;	WL	ANI_CODE,ck_hiptoss
;	WL	ANI_IFNOTSTATUS,#got_him

	WL	10,D3HT3Q+FR1
;Delay longer if 2nd hiptoss in quick succession!
	WL	ANI_CODE,hiptoss_delay
	WL	ANI_IFNOTSTATUS,#missed
	WL	24,D3HT3Q+FR1
#missed
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable

	WL	8,D3HT3Q+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

; SUBR	ck_hiptoss
;;Check to see if guy I just tried to hip toss has safe time
;;or is pulling down & away
;
;	move	*a13(WHOIHIT),a0,L
;	move	*a0(SAFE_TIME),a14
;	jrnz	#ano
;
;;If stick is down & away - skip toss
;	move	*a0(STICK_VAL_CUR),a14
;	andi	0ch,a14
;	jrz	#ok
;	move	*a0(NEW_FACING_DIR),a1
;	andi	0ch,a1
;	cmp	a14,a1
;	jrz	#ok
;
;	move	*a0(STICK_VAL_CUR),a14
;	cmpi	4,a1
;	jrz	#fclft
;	cmpi	>6,a14
;	jrnz	#ok
;;Pulling down & away!
;;Don't allow hiptoss
;#ano	move	*a13(ANIMODE),a1
;	ori	MODE_STATUS,a1
;	move	a1,*a13(ANIMODE)
;	rets
;
;#fclft	cmpi	>a,a14
;	jrz	#ano
;
;#ok	move	*a13(ANIMODE),a1
;	andni	MODE_STATUS,a1
;	move	a1,*a13(ANIMODE)
;	rets

 SUBR	hiptoss_delay

	move	*a13(LAST_HIPTOSS),a14,L
	move	@PCNT,a0,L			;use 32-bit PCNT!
	move	a0,*a13(LAST_HIPTOSS),L
	sub	a14,a0
	cmpi	3*60,a0
	jrge	#oka

;This blocked fling attempt is too close (in terms of time) to most recent grab
	move	*a13(ANIMODE),a1
	ori	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets

#oka	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets

#throw_him_out
	WLLL	ANI_ATTACHVEL,-0a0000h,90000h,0h		;x,y,z
	WL	ANI_CODE,CALL_THROWN_OUT
	WL	ANI_SLAVEANIM,#flyout_tbl
	WL	ANI_OPPOFFSET,release_table
	.word	ANI_DETACH
	wl	3,D3HT3Q+FR5
	WL	3,D3HT3Q+FR6
	WL	3,D3HT3Q+FR7
	WL	3,D3HT3Q+FR8
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,15

	WL	3,D3HT3Q+FR8
	WL	3,D3HT3Q+FR7
	WL	3,D3HT3Q+FR6

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

release_table
	;	X Y
	.word	40,24		;Bret
	.word	32,8		;Razor
	.word	32,20		;Taker
	.word	32,16		;Yokozuna
	.word	28,12		;Shawn
	.word	16,8		;BamBam
	.word	32,16		;Doink
	.word	0,0		;Adam
	.word	32,16		;Lex

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


 SUBR	dnk_4_combo_hiptoss_anim

	.word	ANI_SET_RPTCOUNT,4	;5 times
re_enter_combo_hiptoss
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,2
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_SET_YVEL,0000h

	WL	2,D3HT3Q+FR1
	.word	ANI_ATTACK_ON, AMODE_PUPPET,33,0,44,60 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,6,D3HT3Q+FR1
	.word	ANI_ZERO_XZVELS
	WWL	ANI_WAITHITOPP,4,D3HT3Q+FR1
	.word	ANI_ATTACK_OFF
	.word	ANI_CLR_BUTCOUNT

	WL	ANI_IFNOTSTATUS,#missedc
	WL	ANI_IFBLOCKED,#missedbc		;Yes, I hit blocker

;got him

	.WORD	ANI_INC_COMBO

	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

; attacker sequence
	WWLLW	ANI_SUPERSLAVE2,3,D3HT3Q+FR1,#puppet_tbl,0
	.word	ANI_WAITHITGND
	WWLLW	ANI_SUPERSLAVE2,3,D3HT3Q+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,D3HT3Q+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,D3HT3Q+FR4,#puppet_tbl,3
	WWWL	ANI_IFROPE,RC_BACK,XTOSSDIST_CLOSE,#throw_him_out_c
	WWLLW	ANI_SUPERSLAVE2,3,D3HT3Q+FR5,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,D3HT3Q+FR6,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,3,D3HT3Q+FR7,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,1,D3HT3Q+FR8,#puppet_tbl,7

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_DAMAGEOPP,D_HIPTOSS,RD_HIPTOSS

	WL	ANI_SLAVEANIM,#rollout_tbl

	.word	ANI_CLROPPMODE,MODE_GHOST

	WLLL	ANI_SETOPPVELS,0,80000h,0h		;x,y,z vels

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_DETACH

;	WL	15,D3HT3Q+FR8
	WL	4,D3HT3Q+FR8
	WL	4,D3HT3Q+FR7
	WL	4,D3HT3Q+FR6

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IFNOT_RPTCOUNT,CHECK_FOR_NEXT
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#NEXT_CHECK
	WL	ANI_GOTO,yes_do_combo_again

CHECK_FOR_NEXT
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#NEXT_CHECK
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,yes_do_combo_again
	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#NEXT_CHECK2A
	.WORD	ANI_INC_COMBO
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_IMMOBILIZE,120
	WL	4,D3HT3Q+FR6
	.WORD	ANI_XFLIP
	WL	ANI_CHANGEANIM,dnk_2_stomp_anim

#NEXT_CHECK2A
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#NEXT_CHECK
	.WORD	ANI_XFLIP
	WL	ANI_CHANGEANIM,dnk_combo_hammer_anim

#NEXT_CHECK
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_NORMAL

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

yes_do_combo_again
	.WORD	ANI_XFLIP
	WL	ANI_CHANGEANIM,re_enter_combo_hiptoss

#missedbc
	WL	10,D3HT3Q+FR1
#missedc
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO

	WL	20,D3HT3Q+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#throw_him_out_c
	WLLL	ANI_ATTACHVEL,-090000h,90000h,0h		;x,y,z
	WL	ANI_CODE,CALL_THROWN_OUT
	WL	ANI_SLAVEANIM,#flyout_tbl
	WL	ANI_OPPOFFSET,release_table
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_DETACH
	wl	3,D3HT3Q+FR5
	WL	4,D3HT3Q+FR6
	WL	4,D3HT3Q+FR7
	WL	4,D3HT3Q+FR8

;	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
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
	.ref	H2AH3A,H3FR3A,H2CP3A,H2AM3A
 LWWW H2AH3A+FR5,72,10,0
 LWWW H2AM3A+FR1,58,17,0
 LWWW H2AM3A+FR7,47,8,0
 LWWW H3FR3A+FR2,29,25,0
 LWWW H3FR3A+FR3,14,59,0
 LWWW H3FR3A+FR4,-26,62,0
 LWWW H3FR3A+FR5,-75,-6,0
 LWWW H2CP3A+FR8,-149,-47,1
 .long 0
#Razor
	.ref	R3TD3A,R3GU2A
 LWWW R3TD3A+FR1,56,6,0
 LWWW R3TD3A+FR3,45,6,0
 LWWW R3TD3A+FR4,37,19,0
 LWWW R3TD3A+FR5,36,47,0
 LWWW R3TD3A+FR6,15,62,0
 LWWW R3TD3A+FR7,-25,65,0
 LWWW R3TD3A+FR8,-73,9,0
 LWWW R3GU2A+FR1,-155,-43,1
 .long 0
#Taker
	.ref	U3AE4A,U4AM4C,U3FH3A,U3CP3B
 LWWW U3AE4A+FR1,73,22,0
 LWWW U4AM4C+FR4,52,18,0	;15
 LWWW U3FH3A+FR1,55,20,1	;15
 LWWW U3FH3A+FR2,32,45,1	;40
 LWWW U3FH3A+FR3,18,60,1	;54
 LWWW U3FH3A+FR4,-30,68,1	;63
 LWWW U3FH3A+FR5,-92,18,1
 LWWW U3CP3B+FR1,-175,-40,1
 .long 0
#Yokozuna
	.ref	Y4AE4A,Y3FL3W,Y3FD3A,Y3MS3Z
 LWWW Y4AE4A+FR1,81,10,0
 LWWW Y3MS3Z+FR2,56,18,0
 LWWW Y3FL3W+FR3,36,24,0
 LWWW Y3FL3W+FR4,37,55,0
 LWWW Y3FL3W+FR5,17,68,0
 LWWW Y3FL3W+FR6,-43,68,0
 LWWW Y3FL3W+FR7,-90,11,0
 LWWW Y3FD3A+FR7,-130,-17,0
 .long 0
#Shawn
	.ref	S3OS3X
 LWWW S3OS3X+FR2,58,7,1
 LWWW S3OS3X+FR4,27,18,1
 LWWW S3OS3X+FR5,22,16,1
 LWWW S3OS3X+FR6,26,64,1
 LWWW S3OS3X+FR7,20,79,1
 LWWW S3OS3X+FR8,-13,78,1
 LWWW S3OS3X+FR9,-98,20,1
 LWWW S3OS3X+FR10,-144,-38,1
 .long 0
#BamBam
	.ref	B4TD3B
 LWWW B4TD3B+FR1,53,2,0
 LWWW B4TD3B+FR3,39,4,0
 LWWW B4TD3B+FR4,42,16,0
 LWWW B4TD3B+FR5,33,59,0
 LWWW B4TD3B+FR6,23,88,0
 LWWW B4TD3B+FR7,-28,73,0
 LWWW B4TD3B+FR8,-68,16,0
 LWWW B4TD3B+FR9,-117,-28,0
 .long 0
#Doink
 LWWW D3AE3B+FR8,69,8,0
 LWWW D3PM4C+FR2,37,7,0
 LWWW D3OS3A+FR1,56,10,0
 LWWW D3OS3A+FR3,37,26,0
 LWWW D3OS3A+FR4,23,41,0
 LWWW D3OS3A+FR6,-23,52,0
 LWWW D3FD3E+FR2,-73,-18,0
 LWWW D3SA3A+FR2,-137,-40,1
 .long 0
#Adam
 .long 0
#Lex
 	.ref	L4AM4B,L3FH3A,L3CP3B
 LWWW L4AM4B+FR3,64,-10,0
 LWWW L3FH3A+FR1,46,14,0
 LWWW L3FH3A+FR2,42,14,0	;8
 LWWW L3FH3A+FR3,31,35,0
 LWWW L3FH3A+FR4,24,46,0
 LWWW L3FH3A+FR5,-15,49,0
 LWWW L3FH3A+FR6,-69,1,0
 LWWW L3CP3B+FR1,-152,-39,1
 .long 0


#rollout_tbl
	.long	hrt_tossed_anim,rzr_tossed_anim
	.long	und_tossed_anim
	.long	yok_tossed_anim
	.long	shn_tossed_anim,bam_tossed_anim
	.long	dnk_tossed_anim,0,lex_tossed_anim

	.ref	hrt_tossed_anim,rzr_tossed_anim
	.ref	und_tossed_anim
	.ref	yok_tossed_anim
	.ref	shn_tossed_anim,bam_tossed_anim
	.ref	lex_tossed_anim

;#rollout_tbl
;	REFLONG	und_tossed_anim
;	REFLONG	yok_tossed_anim
;	REFLONG	shn_tossed_anim,bam_tossed_anim
;	REFLONG	dnk_tossed_anim
;	.long	0
;	REFLONG	lex_tossed_anim

;FIX!!  Make throw out of ring if close to ropes
#*****************************************************************************
*
* FLIP/FALL FROM HIPTOSS

 SUBR	dnk_tossed_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,ckzpos

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	.word	ANI_DEBRIS,100,1,0,8,0		;%chance, tbl index, x,y,z off
	.word	ANI_GETUP,STAY_TIME
	WL	ANI_CODE,HIT_THE_MAT
	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,30000h
 	WL	4,D3SA3A+FR3
;	WL	ANI_SET_YVEL,30000h
; 	WL	3,D3SA3A+FR3
 	WL	4,D3SA3A+FR4
 	WL	4,D3SA3A+FR5
 	WL	4,D3SA3A+FR7
 	WL	4,D3SA3A+FR8
 	WL	1,D3SA3A+FR9
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS

; 	WL	3,D3SA3A+FR3
; 	WL	3,D3SA3A+FR4
; 	WL	3,D3SA3A+FR5
; 	WL	3,D3SA3A+FR7
; 	WL	3,D3SA3A+FR8

 	WL	3,D3SA3A+FR9

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,dnk_faceup_getup_anim

;FIX!!  Make throw out of ring if close to ropes
#*****************************************************************************
*
* FLIP/FALL FROM BAM BAM DUCK TOSS

 SUBR	dnk_tossed2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,ckzpos

	WLW	ANI_SET_XVEL,60000h,AM_HIT_REL
	WL	ANI_SET_YVEL,30000h
	.word	ANI_OFFSET,20,20,0			;x,y,z
	WL	4,D3OS3A+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_GETUP,STAY_TIME
	.word	ANI_DAMAGE,D_HIPTOSS

	WL	3,D3FD3E+FR2
	.word	ANI_XFLIP
	.word	ANI_OFFSET,20,0,0			;x,y,z
	WL	3,D3SA3A+FR9

	WLW	ANI_SET_XVEL,20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,50000h
 	WL	3,D3SA3A+FR3
 	WL	3,D3SA3A+FR4
 	WL	3,D3SA3A+FR5
 	WL	3,D3SA3A+FR7
 	WL	3,D3SA3A+FR8
 	WL	3,D3SA3A+FR9

	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS

	WL	3,D3SA3A+FR9
#done
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,dnk_faceup_getup_anim


#************
*
* #4 PUSH

 SUBR	dnk_4_push_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WL	ANI_SETFLAG,M_PUSH
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUSH,9
	WL	3,D4PS3A+FR1
	WL	3,D4PS3A+FR2
	WL	3,D4PS3A+FR3
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ATTACK_ON, AMODE_PUSH,37,88,63,9 ;mode,x,y,w,h
	WL	3,D4PS3A+FR4
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,40h,-70000h,#no_hit	;range,vel,addr
	WL	15,D4PS3A+FR4
#no_hit
	WL	3,D4PS3A+FR4

	WL	ANI_IFSTATUS,#hit
;If missed on push, hold a little longer
	WL	5,D4PS3A+FR4
#hit
	WL	3,D4PS3A+FR5
	WL	3,D4PS3A+FR6
	WL	3,D4PS3A+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


******************************************************************************
*
* #2 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	dnk_2_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

	WL	3,D2AH2A+FR1
	WL	15,D2AH2A+FR2
	WL	4,D2AH2A+FR3

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 RUNNING BOUNCE OFF OF OPPONENT

 SUBR	dnk_4_bncoff_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h

	WL	3,D3AH3B+FR1
	WL	3,D3AH3B+FR2
	WL	14,D3AH3B+FR3
	WL	2,D3AH3B+FR5

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


* #4 RUNNING BOUNCE OFF OF OPPONENT

;Bounce off but stay dizzy!

 SUBR	dnk_4_bncoff_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_FRICTION,3000h
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WL	3,D3AH3B+FR1
	WL	3,D3AH3B+FR2
	WL	14,D3AH3B+FR3
	WL	2,D3AH3B+FR5

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,dnk_dizzy_anim

******************************************************************************
*
* #4 LOSE BALANCE

 SUBR	dnk_4_losebal_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_FRICTION,3000h
	.word	ANI_SETSPEED,100h

	WLW	ANI_SET_XVEL,-60000h,AM_HIT_REL

	.word	ANI_DEBRIS,150,3,-21,100,0	;%chance, tbl index, x,y,z off
	WLWWWW	ANI_CREATEPROC,CREATE_SWEAT,0,SPRAYA_SWEAT,SWEAT_PER,0

	WL	3,D4LB4A+FR2
	WL	3,D4LB4A+FR3
	WL	3,D4LB4A+FR4
	WL	ANI_CODE,DO_DOINK_PUSH
	WL	3,D4LB4A+FR5
	WL	3,D4LB4B+FR1
	WL	3,D4LB4B+FR2
	WL	3,D4LB4B+FR3

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	dnk_4_losebal_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_FRICTION,3000h
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_DIZZY

	WLW	ANI_SET_XVEL,-50000h,AM_HIT_REL

	WL	3,D4LB4A+FR2
	WL	3,D4LB4A+FR3
	WL	3,D4LB4A+FR4
	WL	3,D4LB4A+FR5
	WL	3,D4LB4B+FR1
	WL	3,D4LB4B+FR2
	WL	3,D4LB4B+FR3

;	.word	ANI_SETPLYRMODE,MODE_DIZZY
	WL	ANI_CHANGEANIM,dnk_dizzy_anim

#*****************************************************************************
*
* #2 BIG BOOT
*

 SUBR	dnk_2_bigboot_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_BIGBOOT,9
	WL	3,D3SK3X+FR1
	WL	3,D3SK3X+FR2
	WL	3,D3SK3X+FR3
	WL	ANI_CODE,#clrcnt

	.word	ANI_ATTACK_ON, AMODE_BIGBOOT,57,66,32,46 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,15,D3SK3X+FR4	;2
#lp0
	.word	ANI_STARTATTACK,AT_BIGBOOT,5
	WL	2,D3SK3X+FR4
	WL	ANI_CODE,#holdup
	WL	ANI_IFSTATUS,#lp0

	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_4,2,2
	WL	ANI_IFNOTSTATUS,#missed1
	.word	ANI_DRAW_NAME,27
#missed1
	WL	3,D3SK3X+FR5
	WL	3,D3SK3X+FR6
	WL	3,D3SK3X+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

* #4 BIG BOOT

 SUBR	dnk_4_bigboot_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_BIGBOOT,9
	WL	3,D3SK3X+FR1
	WL	3,D3SK3X+FR2
	WL	3,D3SK3X+FR3
	WL	ANI_CODE,#clrcnt

	.word	ANI_ATTACK_ON, AMODE_BIGBOOT,34,78,46,25 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,15,D3SK3X+FR4	;2
#lp
	WL	2,D3SK3X+FR4

	WL	ANI_CODE,#holdup
	WL	ANI_IFSTATUS,#lp

;	.word	ANI_WAITRELEASE,PLAYER_KICK_BIT

	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_4,2,2
	WL	ANI_IFNOTSTATUS,#missed2
	.word	ANI_DRAW_NAME,27
#missed2

	WL	3,D3SK3X+FR5
	WL	3,D3SK3X+FR6
	WL	3,D3SK3X+FR7
	WL	3,D3SK3X+FR8
   
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

#*****************************************************************************
*
* DIZZY

 SUBR	dnk_dizzy_anim

	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_START_DIZZY,0	;0=Standing dizzy
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

#loop
	WL	6,D4SW4C+FR1
	WL	6,D4SW4C+FR2
	WL	6,D4SW4C+FR3
	WL	6,D4SW4C+FR4
	WL	6,D4SW4C+FR5
	WL	6,D4SW4C+FR6
	WL	6,D4SW4C+FR5
	WL	6,D4SW4C+FR4
	WL	6,D4SW4C+FR3
	WL	6,D4SW4C+FR2
	WL	ANI_GOTO,#loop


#****************************************************************************
*
* PIN OPPONENT AND RAISE ARM IN VICTORY

;Need to have this guy walk toward fallen opponent so he
;can get closer!

;This pin must be started only when opponent is on the ground!

 SUBR	dnk_2_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;Rotate!
	WL	3,D1TT5Z+FR2
	WL	3,D1TT5Z+FR3

 SUBR	dnk_4_pin_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 25,999,80h,50h,90000h,TGT_CHEST|TGT_GROUND,0,57,-15
	WL	ANI_CODE,hit_nearest

	WL	3,D4PN5A+FR1
	WL	3,D4PN5A+FR2
	.word	ANI_OFFSET,0,57,0			;x,y,z
	WL	21,D4PN5A+FR3	;19
	.word	ANI_ZEROVELS

	WLW	ANI_ATTCHIMAGE,D4PN5L+FR4,10		;image, zoff (priority)
	WL	3,D4PN5A+FR4

	WL	ANI_CODE,grnd_hit
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2

	WL	ANI_CODE,DO_CROWD_CHEER

	.word	ANI_BOUNCE,4
	WLW	ANI_ATTCHIMAGE,D4PN5L+FR5,10		;image, zoff (priority)
	WL	4,D4PN5A+FR5
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE

	WL	4,D4PN5A+FR5
	WL	ANI_CODE,win_announce
	WLW	ANI_ATTCHIMAGE,0,0		;Turn it off

	WL	40,D4PN5A+FR6

	.word	ANI_LOOP
	.word	ANI_DETACH

;Do another ground hit on opponent
	WL	ANI_CODE,grnd_hit

	WL	ANI_SET_YVEL,42000h
	WLW	ANI_SET_ZVEL,22000h,AM_ABS
	WL	4,D5GD4A+FR1
	WL	4,D5GD4A+FR2
	.word	ANI_OFFSET,-10,0,0			;x,y,z
	WL	6,D3GU4A+FR7
	WL	5,D3GU4A+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	5,D3GU4A+FR9

;	WL	8+10,D5WN5B+FR1
	WL	8-2,D5WN5B+FR2
	WL	8-2,D5WN5B+FR3
	WL	8-2,D5WN5B+FR4
	WL	8-2,D5WN5B+FR5

#loop	WL	6,D5WN5Z+FR1
	WL	6,D5WN5Z+FR2
	WL	6,D5WN5Z+FR3
	WL	6,D5WN5B+FR5

;	WL	6,D5WN5Z+FR4
	WL	ANI_GOTO,#loop


******************************************************************************
* RAISE ARM IN VICTORY FROM A STANCE

 SUBR	dnk_2_raise_arm_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,DO_CROWD_CHEER
	WL	ANI_CODE,win_announce

	WL	3,D1TT5Z+FR2
	WL	3,D1TT5Z+FR3
	WL	ANI_GOTO,#cont

 SUBR	dnk_4_raise_arm_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,DO_CROWD_CHEER
	WL	ANI_CODE,win_announce

#cont	WL	6,D5WN5B+FR2
	WL	6,D5WN5B+FR3
	WL	6,D5WN5B+FR4
	WL	6,D5WN5B+FR5

#loop2	WL	6,D5WN5Z+FR1
	WL	6,D5WN5Z+FR2
	WL	6,D5WN5Z+FR3
	WL	6,D5WN5B+FR5

	WL	ANI_CODE,check_raisearm_bit
	WL	ANI_IFSTATUS,#wakeup
	WL	ANI_GOTO,#loop2

#wakeup	;pinned guy did a buckoff - snap out of it.
	.word	ANI_SET_RPTCOUNT,-10	;set count to rnd from 0 to 10
#loop3	WL	6,D5WN5Z+FR1
	WL	6,D5WN5Z+FR2
	WL	6,D5WN5Z+FR3
	WL	6,D5WN5B+FR5
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#loop3
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_FACEDOWN
	.word	ANI_END


 SUBR	win_announce

	PUSH	a10
	move	a13,a10
	CREATE	ANNC_PID,announce_rnd_winner
	.if DEBUG
	move	a13,*a0(PDATA),L	;#CREATOR (pdata)
	movi	$,a14
	move	a14,*a0(PDATA+20h),L	;#ORIGIN
	.endif
	CALLA	KILL_PIN_HIM
	PULL	a10

	rets


***********************
* FOR USE ONLY IN PINS!

 SUBR	grnd_hit

	;use CLOSEST instead of WHOIHIT, since you don't actually attack
	; during the pins.

	;Un! DO use WHOIHIT, as this is set in all the pin_anims before this
	; function is called.

	PUSH	a13
	move	*a13(WHOIHIT),a13,L

;	move	*a13(CLOSEST_NUM),a13
;	X32	a13
;	addi	process_ptrs,a13
;	move	*a13,a13,L

	move	*a13(WRESTLERNUM),a0
	move	a0,a1
	sll	5,a0
	addi	#hit_t,a0
	move	*a0,a0,L
	calla	change_anim1a
	PULL	a13

	;align on target's z, unless we're taker
	move	*a13(WRESTLERNUM),a0
	subk	2,a0
	jrz	#z
	move	*a13(WHOIHIT),a0,L

	;set pinner Z to victim Z+1, then set victim's Z to
	move	*a0(OBJ_ZPOS),a14,L
	addi	[1,0],a14
	move	a14,*a13(OBJ_ZPOS),L
	subi	[2,0],a14
	move	a14,*a0(OBJ_ZPOS),L
#z	rets

#hit_t
	.long	hrt_hitonground_anim		;0 Bret Hart
	.long	rzr_hitonground_anim		;1 Razor Ramon
	.long	und_hitonground_anim		;2 Undertaker
	.long	yok_hitonground_anim		;3 Yokozuna
	.long	shn_hitonground_anim		;4 Shawn Michaels
	.long	bam_hitonground_anim		;5 Bam Bam
	.long	dnk_hitonground_anim		;6 Doink
	.long	0				;7 spare
	.long	lex_hitonground_anim		;8 Lex Luger

#*****************************************************************************
*
* GET BUCKED OFF A PINNED OPPONENT

 SUBR	dnk_buckoff_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WLW	ANI_ATTCHIMAGE,0,0
	WL	4,D4PN5A+FR6
	WL	1,D4PN5A+FR3
	WL	ANI_CODE,set_buckoff_vels
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	4,D4PN5A+FR4
	WL	10,D4PN5A+FR5

	;now stand up
	WL	3,D5GD4A+FR1
	WL	3,D5GD4A+FR2
	WL	3,D3GU4A+FR7
	WL	3,D3GU4A+FR8
	WL	3,D3GU4A+FR9

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

**********
* Jump toward the center.

 SUBR	set_buckoff_vels

	movi	20000h,a0
	move	*a13(OBJ_XPOSINT),a14
	cmpi	RING_X_CENTER,a14
	jrle	#xok
	neg	a0
#xok	move	a0,*a13(OBJ_XVEL),L

	movi	40000h,a0
	move	*a13(OBJ_ZPOSINT),a14
	cmpi	RING_Z_CENTER,a14
	jrle	#zok
	neg	a0
#zok	move	a0,*a13(OBJ_ZVEL),L

	movi	50000h,a0
	move	a0,*a13(OBJ_YVEL),L

	rets

#*****************************************************************************
*
* #3 CLIMB THROUGH ROPES

 SUBR	dnk_climbthru_side_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	ANI_CODE,SET_DIR_FACE
	.word	ANI_SETFACING
	.WORD	ANI_SET_WRESTLER_XFLIP

	WLW	ANI_SET_XVEL,3000h,AM_FACE_REL
	.word	ANI_OFFSET,13,0,0
	WL	3,D3CR3D+FR1
	.word	ANI_BENDROPE,0
	WL	2,D3CR3D+FR2
	WL	3,D3CR3D+FR3
	WL	2,D3CR3D+FR4
	WL	3,D3CR3D+FR5

	.word	ANI_BENDROPE,2
	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH

	WL	2,D3CR3D+FR6
	.word	ANI_BENDROPE,2
	WL	3,D3CR3D+FR7
	WL	2,D3CR3D+FR8
	.word	ANI_BENDROPE,3
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH
	WL	3,D3CR3D+FR9
	WL	2,D3CR3D+FR10
	.word	ANI_ZEROVELS
	.word	ANI_BENDROPE,-1
	.word	ANI_OFFSET,43,-3,0
	WL	3,D3CR3D+FR11

	;now jump off...
	WL	3,D4JD4A+FR1		;D4FM4A+FR1
	WL	3,D4JD4A+FR2

	.word	ANI_SET_IDIOT
	WWL	ANI_SETLONG,OBJ_GRAVITY,0E000h
	WL	ANI_SET_YVEL,60000h

	WLW	ANI_SET_XVEL,30000h,AM_FACE_REL

	WL	3,D4JD4A+FR4
	.word	ANI_WAITHITGND
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

	.word	ANI_ROPE_Z,R_TOP,RZ_NORM
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM

	.word	ANI_ZEROVELS
	WL	2,D4JD4A+FR6
	WL	2,D4JD4A+FR7
	WL	4,D4JD4A+FR8
	WL	2,D4JD4A+FR10
	WL	2,D4JD4A+FR11

	.word	ANI_FACEDOWN
	.word	ANI_CLEAR_CLIMB

	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END

#*****************************************************************************

 SUBR	dnk_climbin_side_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	ANI_CODE,SET_DIR_FACE
	.word	ANI_SETFACING
	.WORD	ANI_SET_WRESTLER_XFLIP

	;jump in
	WL	3,D4JD4A+FR1
	WL	3,D4JD4A+FR2

	WWL	ANI_SETLONG,OBJ_GRAVITY,0E000h
	WL	ANI_CODE,#set_trgt
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	.word	ANI_LEAPATPOS,14h,200,0,0,0	;#ticks,dist,xoff,yoff,zoff

	WL	3,D4JD4A+FR4
	.word	ANI_WAITHITGND
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_ROPE_Z,R_TOP,RZ_HIGH
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_HIGH
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH

	WL	3,D4JD4A+FR6
	WL	2,D4JD4A+FR7
	WL	2,D4JD4A+FR11

	WLW	ANI_SET_XVEL,3000h,AM_FACE_REL

	;climb through
	WL	3,D3CR3D+FR1
	.word	ANI_BENDROPE,0
	WL	2,D3CR3D+FR2
	WL	3,D3CR3D+FR3
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM
	WL	2,D3CR3D+FR4
	WL	3,D3CR3D+FR5

	.word	ANI_BENDROPE,2

	WL	2,D3CR3D+FR6
	.word	ANI_BENDROPE,2
	WL	3,D3CR3D+FR7
	WL	2,D3CR3D+FR8
	.word	ANI_BENDROPE,3
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_HIGH
	WL	3,D3CR3D+FR9
	WL	2,D3CR3D+FR10
	.word	ANI_BENDROPE,-1
	.word	ANI_OFFSET,43,-3,0
	WL	3,D3CR3D+FR11
	.word	ANI_ZEROVELS

	.word	ANI_OFFSET,-5,0,0
;	WL	ANI_CODE,clr_climb
	.word	ANI_CLEAR_CLIMB

	;done

	.word	ANI_ROPE_Z,R_TOP,RZ_NORM
	.word	ANI_ROPE_Z,R_MIDDLE,RZ_NORM
	.word	ANI_ROPE_Z,R_BOTTOM,RZ_NORM

	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END

#set_trgt
	movi	RING_X_CENTER-0f8h-50,a0		;Jump onto left side apron
	move	*a13(OBJ_XPOSINT),a14
	cmpi	RING_X_CENTER,a14
	jrlt	#onlft
;On right side
	movi	RING_X_CENTER+0f8h+50,a0		;Jump onto right side apron
#onlft
	move	a0,*a13(TGT_XOFF)

	movi	RING_Z_CENTER,a0
	move	a0,*a13(TGT_ZOFF)

	movi	MAT_Y,a0
	move	a0,*a13(TGT_YOFF)

	rets

 SUBR	SET_DIR_FACE

	;this is now used for both climbins and climbouts.  If we're outside,
	; use an identical version, but with the a0's switched.
	move	*a13(INRING),a14
	jrz	#method2

	MOVI	10,A0
	move	*a13(OBJ_XPOSINT),a14
	cmpi	RING_X_CENTER,a14
	jrlt	#onlft1
	MOVI	6,A0
#onlft1
	MOVE	A0,*A13(NEW_FACING_DIR)
	RETS

#method2
	MOVI	6,A0
	move	*a13(OBJ_XPOSINT),a14
	cmpi	RING_X_CENTER,a14
	jrlt	#onlft2
	MOVI	10,A0
#onlft2
	MOVE	A0,*A13(NEW_FACING_DIR)
	RETS


#*****************************************************************************

 SUBR	dnk_climbthru_bot_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

;Must rotate toward ropes!
;Do a different sequence

	;lie down
	WL	ANI_CODE,#ckspin
	WL	ANI_IFSTATUS,#dir4

;Facing #2, spin first!
	WL	3,D1TT5Z+FR2
	WL	3,D1TT5Z+FR3
#dir4
	WL	3,D3GU4A+FR9
	WL	3,D3GU4A+FR8
	WL	3,D3GU4A+FR7
	WL	3,D3GU4A+FR6
	WL	3,D3GU4A+FR5
	WL	3,D3GU4A+FR4
	WL	3,D3GU4A+FR2

	;roll over once
	WLW	ANI_SET_ZVEL,70000h,AM_ABS

	WL	3,D3SA3A+FR9
	WL	3,D3RL1B+FR2
	WL	3,D3RL1B+FR3

	WL	3,D3RL1B+FR4
	WL	3,D3RL1B+FR5
	WL	3,D3RL1B+FR6
	WL	3,D3RL1B+FR7
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOSHADOW|MODE_NOCOLLIS

	.word	ANI_SET_IDIOT
	;climb through
	WL	3,D2CR1A+FR3
	WL	3,D2CR1A+FR2
	WL	3,D2CR1A+FR1
	.word	ANI_OFFSET,0,-37h,0			;x,y,z
	WL	1,D2ST2B+FR3

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


#*****************************************************************************

 SUBR	dnk_climbin_bot_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;climb in
	.word	ANI_GRAVITY_OFF
	.word	ANI_OFFSET,0,37h,-60
	WL	3,D2CR1A+FR1
	WL	3,D2CR1A+FR2
	WL	3,D2CR1A+FR3

	;roll
	WLW	ANI_SET_ZVEL,-70000h,AM_ABS
	.word	ANI_FRICTION,3000h
	WL	3,D3RL1B+FR7
	WL	3,D3RL1B+FR6
	WL	3,D3RL1B+FR5
	WL	3,D3RL1B+FR4
	WL	3,D3RL1B+FR3
	WL	3,D3RL1B+FR2
	.word	ANI_ZEROVELS
	.word	ANI_GRAVITY_ON

	;get up
	WL	3,D3GU4A+FR2
	WL	3,D3GU4A+FR3
	WL	3,D3GU4A+FR4
	WL	3,D3GU4A+FR5
	WL	3,D3GU4A+FR6
	WL	3,D3GU4A+FR7
	WL	3,D3GU4A+FR8
	WL	3,D3GU4A+FR9

;	WL	ANI_CODE,clr_climb
	.word	ANI_CLEAR_CLIMB

	.word	ANI_FACEDOWN
	.word	ANI_ZEROVELS
	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#*****************************************************************************

 SUBR	dnk_climbthru_top_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;lie down
	WL	ANI_CODE,#set_zvel1
	WL	ANI_IFSTATUS,#dir4
;Facing #2
	WL	3,D2GD2A+FR9
	WL	3,D2GD2A+FR7
	WL	3,D2GD2A+FR6
	WL	3,D2GD2A+FR4
	WL	ANI_CODE,#set_zvel3
	WL	ANI_GOTO,#cont
	
#dir4
	WL	3,D3GU4A+FR9
	WL	3,D3GU4A+FR8
	WL	3,D3GU4A+FR7
	WL	3,D3GU4A+FR6
	WL	3,D3GU4A+FR5
	WL	3,D3GU4A+FR4
	WL	3,D3GU4A+FR3
	WL	3,D3GU4A+FR2

	;roll over once
	WL	ANI_CODE,#set_zvel2
	WL	3,D3RL1B+FR11
#cont
	WL	3,D3RL1B+FR10
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOSHADOW|MODE_NOCOLLIS
	WL	3,D3RL1B+FR9
	WL	3,D3RL1B+FR8
	WL	3,D3RL1B+FR7

	.word	ANI_SET_IDIOT
	;climb through
	.word	ANI_OFFSET,0,-61,0
	.word	ANI_ZEROVELS
	WL	3,D2CR1A+FR8
	WL	3,D2CR1A+FR9
	WL	3,D2CR1A+FR10
	WL	3,D2CR1A+FR11

	.word	ANI_ZERO_XZVELS

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
	movi	-6c000h,a0
	move	a0,*a13(OBJ_ZVEL),L
	rets

#set_zvel3
	movi	-7c000h,a0
	move	a0,*a13(OBJ_ZVEL),L
	rets

#*****************************************************************************
;Zombies use this to roll through the top without standing back up.

 SUBR	dnk_rollthru_top_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOSHADOW|MODE_NOCOLLIS

	;roll over once
	WLW	ANI_SET_ZVEL,-6C000h,AM_ABS
	WL	3,D3RL1B+FR11
	WL	3,D3RL1B+FR10

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOSHADOW|MODE_NOCOLLIS
	WL	3,D3RL1B+FR9
	WL	3,D3RL1B+FR8
	WL	3,D3RL1B+FR7

	;climb through
	.word	ANI_OFFSET,0,-61,0
	.word	ANI_ZEROVELS
	WL	3,D2CR1A+FR8
	WL	3,D2CR1A+FR9
	WL	3,D2CR1A+FR10
	WL	3,D2CR1A+FR11

	.word	ANI_ZERO_XZVELS

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************

 SUBR	dnk_climbin_top_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_OVERLAP|MODE_NOCOLLIS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	;climb in
	WL	3,D2CR1A+FR11
	WL	3,D2CR1A+FR10
	WL	3,D2CR1A+FR9
	WL	3,D2CR1A+FR8
	.word	ANI_OFFSET,0,61,0

	;roll over
	WL	ANI_CODE,#set_zvel2
	WL	3,D3RL1B+FR8
	WL	3,D3RL1B+FR9
	WL	3,D3RL1B+FR10
	WL	3,D3RL1B+FR11

	WL	3,D3SA3A+FR9

	.word	ANI_ZEROVELS

	;get up
	WL	3,D3GU4A+FR2
	WL	3,D3GU4A+FR3
	WL	3,D3GU4A+FR4
	WL	3,D3GU4A+FR5
	WL	3,D3GU4A+FR6
	WL	3,D3GU4A+FR7
	WL	3,D3GU4A+FR8
	WL	3,D3GU4A+FR9

;	WL	ANI_CODE,clr_climb
	.word	ANI_CLEAR_CLIMB
;	.word	ANI_OFFSET,0,0,100

	.word	ANI_SETMODE,MODE_NOCONFINE
	.word	ANI_END


#set_zvel2
	movi	42000h,a0
	move	a0,*a13(OBJ_ZVEL),L
	rets

#*****************************************************************************

 SUBR	dnk_roll_frames

	.word	7		;speed
	.long	50000h		;z velocity
	.long	10000h*10/255	;inv multiply (0-255 -> 0-10)

	.long	D3SA3A+FR9	;0
	.long	D3RL1B+FR2	;1
	.long	D3RL1B+FR3	;2
	.long	D3RL1B+FR4	;3
	.long	D3RL1B+FR5	;4
	.long	D3RL1B+FR6	;5
	.long	D3RL1B+FR7	;6
	.long	D3RL1B+FR8	;7
	.long	D3RL1B+FR9	;8
	.long	D3RL1B+FR10	;9
	.long	D3RL1B+FR11	;10
	.long	0,0,0,0,0,0


******************************************************************************

	.end
