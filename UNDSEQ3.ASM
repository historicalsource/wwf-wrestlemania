**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		5/17/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"undseq3.asm"
	.title	"Undertaker animation sequences"
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

	.include	"bretimg.h"
	.include	"razorimg.h"
	.include	"takerimg.h"
	.include	"yokoimg.h"
	.include	"shawnimg.h"
	.include	"bamimg.h"
	.include	"doinkimg.h"
	.include	"leximg.h"
	.include	"miscimg.glo"

	.include	"damage.equ"

******************************************************************************
* EXTERNAL REFERENCES

	.ref	MOVE_NAME_ANNC,am_I_dead,ckzpos,make_norm
;	.ref	CHAIR_SWING
	.ref	no_bk_xvel,punch_dtime1,set_my_pal,set_position,face_inside
	.ref	set_skeleton_pal,set_xdrift,start_smoke,UNDNEG_P
	.ref	CALL_NASTY_MOVE,CALL_OTHER_AVERAGE,CALL_THROWN_OUT
	.ref	DO_CHOKE,MAKE_HIM_SCREAM,CALL_ANI_AVERAGE_MOVE,CALL_SETUP
	.ref	CALL_SPECIAL_MOVE,HIT_THE_MAT,SMALL_BOUNCE,clear_opp_counts
	.ref	DO_COMBO_MESS,D4SK4A,und_getup_anim,CALL_MISSES,DO_NONO
	.ref	DO_OTHERNONO,FIND_AND_KILL_ENDLESS,slaveanim_tbl,make_white
	.ref	und_faceup_getup_anim,tgt_tbukl,tbukl_flip,DO_GRUNT

	.ref	und_combo_flying_butt_drop_anim,und_flyout_anim
	.ref	und_combo_uppercut_anim,und_stand4_anim,und_tombbits
	.ref	und_fall_back_anim,und_tombbits2

	.ref	bam_3_head_held_anim,bam_3_head_held_brk_anim
	.ref	bam_break_face2_anim,bam_break_face_anim
	.ref	bam_break_neck2_anim,bam_flyout_anim

	.ref	dnk_3_head_held_anim,dnk_3_head_held_brk_anim
	.ref	dnk_break_face2_anim,dnk_break_face_anim
	.ref	dnk_break_neck2_anim,dnk_flyout_anim

	.ref	hrt_3_head_held_anim,hrt_3_head_held_brk_anim
	.ref	hrt_break_face2_anim,hrt_break_face_anim
	.ref	hrt_break_neck2_anim,hrt_flyout_anim

	.ref	lex_3_head_held_anim,lex_3_head_held_brk_anim
	.ref	lex_break_face2_anim,lex_break_face_anim
	.ref	lex_break_neck2_anim,lex_flyout_anim

	.ref	rzr_3_head_held_anim,rzr_3_head_held_brk_anim
	.ref	rzr_break_face2_anim,rzr_break_face_anim
	.ref	rzr_break_neck2_anim,rzr_flyout_anim

	.ref	shn_3_head_held_anim,shn_3_head_held_brk_anim
	.ref	shn_break_face2_anim,shn_break_face_anim
	.ref	shn_break_neck2_anim,shn_flyout_anim

	.ref	yok_3_head_held_anim,yok_3_head_held_brk_anim
	.ref	yok_break_face2_anim,yok_break_face_anim
	.ref	yok_break_neck2_anim,yok_flyout_anim

	.ref	hrt_slamnobounce_anim,rzr_slamnobounce_anim
	.ref	und_slamnobounce_anim,yok_slamnobounce_anim
	.ref	shn_slamnobounce_anim,bam_slamnobounce_anim
	.ref	dnk_slamnobounce_anim,lex_slamnobounce_anim

	.ref	hrt_slambounce_anim
	.ref	rzr_slambounce_anim
	.ref	und_slambounce_anim
	.ref	yok_slambounce_anim
	.ref	shn_slambounce_anim
	.ref	bam_slambounce_anim
	.ref	dnk_slambounce_anim
	.ref	lex_slambounce_anim

	.ref	hrt_slambounce2_anim
	.ref	rzr_slambounce2_anim
	.ref	und_slambounce2_anim
	.ref	yok_slambounce2_anim
	.ref	shn_slambounce2_anim
	.ref	bam_slambounce2_anim
	.ref	dnk_slambounce2_anim
	.ref	lex_slambounce2_anim

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* HELD OVERHEAD ANIMATION

 SUBR	und_heldoh_anim

	.word	ANI_SETPLYRMODE,MODE_ATTACHED
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_SETSPEED,100h

	.word	ANI_SETWORD,USR_VAR1,0		;loop count
	WL	ANI_CODE,DO_OTHERNONO

#loop
	WL	4,U4PM3C+FR1
	WL	4,U4PM3C+FR2
	WL	4,U4PM3C+FR3
	WL	4,U4PM3C+FR4
	WL	4,U4PM3C+FR5
	WL	4,U4PM3C+FR6
	WL	4,U4PM3C+FR7

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

	WL	5,U4PM3C+FR6
	.word	ANI_OFFSET,-20,-50,0			;x,y,z
	WL	4,U3MS3Z+FR5
	WL	4,U3MS3Z+FR4
	WL	4,U3MS3Z+FR3
	WL	4,U3MS3Z+FR2
	WL	4,U3MS3Z+FR1
	WL	4,U4GH3C+FR10
	.word	ANI_WAITHITGND
	WL	4,U2ST2C+FR1

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
* TOMBSTONE SMASH ATTACK

 SUBR	und_tombstone_smash_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SET_RPTCOUNT,4	;repeat max 3 times

#cont
	.word	ANI_SOUND,0D0H			;morph snd

	WL	1,U3TBSM+FR1

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR1,1 ;image, zoff (priority)
	WL	1,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR2,1 ;image, zoff (priority)
	WL	1,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR3,1 ;image, zoff (priority)
	WL	1,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR4,1 ;image, zoff (priority)
	WL	1,U3TBSM+FR2
;	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR5,1 ;image, zoff (priority)
;	WL	1,U3TBSM+FR2
	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE

	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2
#rpt_loop
	.word	ANI_CLR_BUTCOUNT

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR6,-1 ;image, zoff (priority)
	WL	1,U3TBSM+FR3

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR7,-1 ;image, zoff (priority)
	WL	1,U3TBSM+FR4

	.word	ANI_STARTATTACK,AT_LEAPING,9

	WWL	ANI_SETLONG,OBJ_GRAVITY,0c000h
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,999,80,50,90000h,TGT_HEAD,80,102,-10
	WL	ANI_CODE,no_bk_xvel

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR8,-1 ;image, zoff (priority)
	WL	3,U3TBSM+FR5

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR9,-1 ;image, zoff (priority)
	WL	3,U3TBSM+FR6

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR10,-1 ;image, zoff (priority)
	WL	3,U3TBSM+FR7

	.word	ANI_ATTACK_ON, AMODE_TOMB,54,95,50,31 ;mode,x,y,w,h
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR11,-1 ;image, zoff (priority)
	WL	3,U3TBSM+FR8

	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

	WL	ANI_IFNOTSTATUS,#missed_nancy_boy
	WL	ANI_IFBLOCKED,#missed_nancy_boy

	.word	ANI_SOUND,0D1H			;Hit snd
;got him
	.word	ANI_SHAKER,25

	WLWWWW	ANI_CREATEPROC,und_tombbits,00h,0,0,0	;addr,ID,w1,w2,w3
	WL	ANI_CODE,MAKE_HIM_SCREAM
	WL	ANI_CODE,CALL_NASTY_MOVE

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#last_hit
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IFNOT_RPTCOUNT,#last_hit

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR15,-1 ;image, zoff (priority)
	WL	1,U3TBSM+FR11
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT

	WL	5,U3TBSM+FR11

	WL	ANI_GOTO,#rpt_loop

#last_hit
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR15,-1 ;image, zoff (priority)
	WL	1,U3TBSM+FR11
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	WL	5,U3TBSM+FR11

	.word	ANI_OFFSET,0,0,15			;x,y,z

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR5,1 ;image, zoff (priority)
	WL	2,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR4,1 ;image, zoff (priority)
	WL	2,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR3,1 ;image, zoff (priority)
	WL	2,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR2,1 ;image, zoff (priority)
	WL	2,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR1,1 ;image, zoff (priority)
	WL	2,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,0,0
	WL	2,U3TBSM+FR1


	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed_nancy_boy
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT

	WL	ANI_CODE,CALL_MISSES
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR12,-1 ;image, zoff (priority)
	WL	2,U3TBSM+FR9
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR16,-1 ;image, zoff (priority)

	;we missed before - one last chance
	.word	ANI_ATTACK_ON, AMODE_TOMB,54,5,50,31 ;mode,x,y,w,h
	WL	1,U3TBSM+FR9
	.word	ANI_ATTACK_OFF

	.word	ANI_SHAKER,25

	WLWWWW	ANI_CREATEPROC,und_tombbits2,00h,0,0,0	;addr,ID,w1,w2,w3

	WL	2,U3TBSM+FR9
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR17,-1 ;image, zoff (priority)
	WL	10,U3TBSM+FR9

	WLW	ANI_ATTCHIMAGE,0,0
	WL	1,U3TBSM+FR9

	WL	3,U3TBSM+FR10
	WL	3,U3TBSM+FR11

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#gothim	;once
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR11,-1 ;image, zoff (priority)
	WL	3,U3TBSM+FR6

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR12,-1 ;image, zoff (priority)
	WL	15,U3TBSM+FR7
	WLW	ANI_ATTCHIMAGE,0,0

	WL	2,U3TBSM+FR8
	WL	2,U3TBSM+FR9
	WL	2,U3TBSM+FR10

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#TOMBSTONE
	.long	0		;0
	.long	TOMBFORM01	;1
	.long	TOMBFORM02	;2
	.long	TOMBFORM03	;3
	.long	TOMBFORM04	;4
	.long	TOMBSTN01	;5
	.long	TOMBSTN02	;6
	.long	TOMBSTN03	;7
	.long	TOMBSTN04	;8
	.long	TOMBSTN05	;9
	.long	TOMBSTN06	;10
	.long	TOMBSTN07	;11
	.long	TOMBSTN08	;12
	.long	TOMBSTN09	;13
	.long	TOMBSTN010	;14
	.long	TOMBSTN011	;15
	.long	TOMBSTN012	;16
	.long	TOMBSTN013	;17


 SUBR	und_combo_tombstone_smash_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
;	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	2,U3TBSM+FR1
	WL	1,U3TBSM+FR2

	.word	ANI_SOUND,0D0H

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR1,1 ;image, zoff (priority)
	WL	1,U3TBSM+FR2
	WLW	ANI_SET_XVEL,0h,AM_FACE_REL
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR2,1 ;image, zoff (priority)
	WL	1,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR3,1 ;image, zoff (priority)
	WL	1,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR4,1 ;image, zoff (priority)
	WL	1,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR5,1 ;image, zoff (priority)
	WL	1,U3TBSM+FR2
	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE

	.word	ANI_SET_RPTCOUNT,4	;repeat max 3 times
#rpt_loop_c
	.word	ANI_CLR_BUTCOUNT

	WLW	ANI_SET_XVEL,10000h,AM_FACE_REL

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR6,-1 ;image, zoff (priority)
	WL	1,U3TBSM+FR3

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR7,-1 ;image, zoff (priority)
	WL	1,U3TBSM+FR4

	WWL	ANI_SETLONG,OBJ_GRAVITY,0c000h

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR8,-1 ;image, zoff (priority)
	WL	2,U3TBSM+FR5

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR9,-1 ;image, zoff (priority)
	WL	2,U3TBSM+FR6

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR10,-1 ;image, zoff (priority)
	WL	2,U3TBSM+FR7
	.word	ANI_ZERO_XZVELS

	.word	ANI_ATTACK_ON, AMODE_TOMB,34,45,60,51 ;mode,x,y,w,h
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR11,-1 ;image, zoff (priority)
	WL	2,U3TBSM+FR8

	.word	ANI_ATTACK_OFF
	.word	ANI_ZERO_XZVELS

	WL	ANI_IFNOTSTATUS,#missed_combo
	WL	ANI_IFBLOCKED,#missed_combo
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,000H,000h,0h		;x,y,z vels
	.WORD	ANI_INC_COMBO

;got him
	.word	ANI_SOUND,0D1H

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#last_hit_c
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IFNOT_RPTCOUNT,#last_hit_c

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR15,-1 ;image, zoff (priority)
	WL	1,U3TBSM+FR11
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT

	WL	3,U3TBSM+FR11

	WL	ANI_GOTO,#rpt_loop_c

#last_hit_c
	WLWWWW	ANI_CREATEPROC,und_tombbits,00h,0,0,0	;addr,ID,w1,w2,w3
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR15,-1 ;image, zoff (priority)
	WL	1,U3TBSM+FR11
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	WL	6,U3TBSM+FR11

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR5,1 ;image, zoff (priority)
	WL	3,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR4,1 ;image, zoff (priority)
	WL	3,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR3,1 ;image, zoff (priority)
	WL	3,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR2,1 ;image, zoff (priority)
	WL	3,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR1,1 ;image, zoff (priority)
	WL	3,U3TBSM+FR2
	WLW	ANI_ATTCHIMAGE,0,0
	WL	1,U3TBSM+FR2
	WL	3,U3TBSM+FR1

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL

	WL	ANI_IF_RPTCOUNT,#EXIT_TOO_SOON

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#NEXT_CHECK
	WL	ANI_CHANGEANIM,und_combo_tombstone_anim

#NEXT_CHECK
	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#EXIT_TOO_SOON
	WL	ANI_CHANGEANIM,und_combo_uppercut_anim

#EXIT_TOO_SOON

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SHADOWTRAIL,0	;off
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_END

#missed_combo
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SHADOWTRAIL,0	;off
	WL	ANI_CODE,CALL_MISSES

	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR12,-1 ;image, zoff (priority)
	WL	2,U3TBSM+FR9
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR16,-1 ;image, zoff (priority)

	WL	1,U3TBSM+FR9

	WLWWWW	ANI_CREATEPROC,und_tombbits2,00h,0,0,0	;addr,ID,w1,w2,w3

	WL	2,U3TBSM+FR9
	WLW	ANI_ATTCHIMAGE,#TOMBSTONE+FR17,-1 ;image, zoff (priority)
	WL	10,U3TBSM+FR9

	WLW	ANI_ATTCHIMAGE,0,0
	WL	20,U3TBSM+FR9

	WL	4,U3TBSM+FR10
	WL	4,U3TBSM+FR11

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* SLIDING CHOKE ATTACK

 SUBR	und_combo_sliding_choke_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WLWW	ANI_SHADOWTRAIL,UNDNEG_P,4,7	;pal,rate,lifespan
	.WORD	ANI_SOUND,0D2H

	WL	4,U2LN2A+FR1

	WL	1,U2LN2A+FR2
	.word	ANI_ATTACK_ON, AMODE_PUPPET,7,83,55,24 ;mode,x,y,w,h

	;max ticks,velocity,max z,tgt,xoff,yoff,zoff
	WWLWWWWW ANI_SLIDEATOPP,30,060000h,80,TGT_HEAD,69,99,0

	WWL	ANI_WAITHITOPP,30,U2LN2A+FR2

	WL	ANI_IFSTATUS,#gothimc

;missed - punish him!

	WL	ANI_CODE,CALL_MISSES
	.word	ANI_FRICTION,4000h
	WWL	ANI_WAITHITOPP,10,U2LN2A+FR2
	WL	ANI_IFSTATUS,#gothimc	;2nd chance to hit
	WWL	ANI_WAITHITOPP,25,U2LN2A+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#gothimc	;2nd chance to hit
	.word	ANI_SHADOWTRAIL,0	;off
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	25,U2LN2A+FR2
	WL	4,U2LN2A+FR1
	.word	ANI_FACE,MOVE_RIGHT|MOVE_UP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#gothimc
	.word	ANI_INC_COMBO
;	WL	ANI_CODE,CALL_SETUP
	.word	ANI_SETPLYRMODE,MODE_CHOKEHOLD
	.word	ANI_ATTACK_OFF
	.word	ANI_ATTACHZ,0,0,-2		;put opp behind attacker

	.word	ANI_SETOPPMODE,MODE_GHOST	;can go through ground
;	.word	ANI_OPP_GETUP,-140		;(neg means always set)

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_FRICTION,4000h

; attacker sequence
	WWLLW	ANI_SUPERSLAVE2,18,U2LN2A+FR2,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,U2LN2A+FR3,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,U2LN2A+FR4,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,U2LN2A+FR5,#puppet_tbl,3

	WWLLW	ANI_SUPERSLAVE2,1,U2LN2A+FR6,#puppet_tbl,4

	.word	ANI_SETOPPFACING

	WL	ANI_SLAVEANIM,#chokeanim_tbl

	.word	ANI_FACE,MOVE_UP|MOVE_RIGHT
	.word	ANI_SETMODE,MODE_NORMAL|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

;start slam
	WL	ANI_SET_YVEL,48000h
	.word	ANI_SET_RPTCOUNT,4	;5 times

#slam_loop
	.word	ANI_CLR_BUTCOUNT

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_ATTACHZ,0,0,-2		;put opp behind attacker
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	WL	ANI_SLAVEANIM,slaveanim_tbl
	WWLLW	ANI_SUPERSLAVE2,4,U2NS3X+FR1,puppet_tbls,0
	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker
	WWLLW	ANI_SUPERSLAVE2,4,U2NS3X+FR2,puppet_tbls,1
	WLW	ANI_SET_ZVEL,-60000h,AM_ABS
	WL	ANI_SET_YVEL,20000h
	.word	ANI_OFFSET,0,10,0			;x,y,z
	WWLLW	ANI_SUPERSLAVE2,4,U2NS3X+FR3,puppet_tbls,2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT

	WWLLW	ANI_SUPERSLAVE2,4,U2NS3X+FR4,puppet_tbls,3
	WWLLW	ANI_SUPERSLAVE2,4,U2NS3X+FR5,puppet_tbls,4
	WWLLW	ANI_SUPERSLAVE2,4,U2NS3X+FR6,puppet_tbls,5
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_ATTACHZ,0,0,50		;put opp in front of attacker
	WWLLW	ANI_SUPERSLAVE2,3,U2NS3X+FR7,puppet_tbls,6

	WL	ANI_XFLIP_TBL,xflip_tbls

	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#NO_MORE
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IFNOT_RPTCOUNT,#NO_MORE

	WL	ANI_SLAVEANIM,SLAM_HIM
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word 	ANI_INC_COMBO

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_DAMAGEOPP,D_NECKSLAM,RD_NECKSLAM

;	.WORD	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,0a0000h,0000h		;x,y,z vels

	WL	14,U2NS3X+FR7
	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP

	WL	4,U2NS3X+FR8
	WL	4,U2NS3X+FR9
	WL	4,U2NS3X+FR10

	WL	ANI_GOTO,#slam_loop
#NO_MORE
	.word	ANI_SHADOWTRAIL,0	;off
	WL	ANI_SLAVEANIM,slambounce_tbls
	WLLL	ANI_SETOPPVELS,0,40000h,30000h		;x,y,z vels

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_NECKSLAM,RD_NECKSLAM

	WL	22,U2NS3X+FR7
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	4,U2NS3X+FR8
	WL	4,U2NS3X+FR9
	WL	4,U2NS3X+FR10

	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

SLAM_HIM
	.long	hrt_slamnobounce_anim	;bret
	.long	rzr_slamnobounce_anim	;razor
	.long	und_slamnobounce_anim	;taker
	.long	yok_slamnobounce_anim	;yoko
	.long	shn_slamnobounce_anim	;shawn
	.long	bam_slamnobounce_anim	;bam
	.long	dnk_slamnobounce_anim	;doink
	.long	und_slamnobounce_anim	;spare
	.long	lex_slamnobounce_anim	;lex


 SUBR	und_sliding_choke_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	2,U2LN2A+FR1

	WLWW	ANI_SHADOWTRAIL,UNDNEG_P,3,12	;pal,rate,lifespan
	.WORD	ANI_SOUND,0D2H

	.word	ANI_STARTATTACK,AT_PUPPET,32
	WL	5,U2LN2A+FR2
	.word	ANI_ATTACK_ON, AMODE_PUPPET,7,83,48,24 ;mode,x,y,w,h

	;max ticks,velocity,max z,tgt,xoff,yoff,zoff
	WWLWWWWW ANI_SLIDEATOPP,27,06a000h,80,TGT_HEAD,69,99,0
	WWL	ANI_WAITHITOPP,27,U2LN2A+FR2
	.word	ANI_STARTATTACK,AT_PUPPET,0
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker
	WL	ANI_IFSTATUS,#gothim

;missed - punish him!

	WL	ANI_CODE,CALL_MISSES
	.word	ANI_FRICTION,4000h
	WWL	ANI_WAITHITOPP,10,U2LN2A+FR2
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker
	WL	ANI_IFSTATUS,#gothim	;2nd chance to hit
	.word	ANI_SHADOWTRAIL,0	;off
	WWL	ANI_WAITHITOPP,25,U2LN2A+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker
	WL	ANI_IFSTATUS,#gothim	;2nd chance to hit
	WL	20,U2LN2A+FR2
	WL	3,U2LN2A+FR1
	.word	ANI_FACE,MOVE_RIGHT|MOVE_UP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2
	.word	ANI_ATTACK_OFF
	.word	ANI_SHADOWTRAIL,0	;off
	.word	ANI_ZEROVELS
	WL	30,U2LN2A+FR2
	WL	3,U2LN2A+FR1
	.word	ANI_FACE,MOVE_RIGHT|MOVE_UP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	.word	ANI_END


#gothim
	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2
	WL	ANI_CODE,CALL_SETUP
	.word	ANI_SETWORD,USR_VAR2,0

	.word	ANI_CLR_BUTCOUNT
	WL	ANI_CODE,head_grab_time

;	.word	ANI_SETPLYRMODE,MODE_CHOKEHOLD
;	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	.word	ANI_ATTACK_OFF
	.word	ANI_ATTACHZ,0,0,-2		;put opp behind attacker

	.word	ANI_SETOPPMODE,MODE_GHOST	;can go through ground

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_FRICTION,4000h

; attacker sequence
	WL	ANI_CODE,#set
	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	.word	ANI_SETOPP_PLYRMODE,MODE_HEADHELD

	WWLLW	ANI_SUPERSLAVE2,15,U2LN2A+FR2,#puppet_tbl,0
	.word	ANI_SHADOWTRAIL,0	;off
	WWLLW	ANI_SUPERSLAVE2,3,U2LN2A+FR3,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,U2LN2A+FR4,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,U2LN2A+FR5,#puppet_tbl,3

	WWLLW	ANI_SUPERSLAVE2,1,U2LN2A+FR6,#puppet_tbl,4

	.word	ANI_SETOPPFACING

;	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#chokeanim_tbl
	.word	ANI_ZEROVELS

	.word	ANI_FACE,MOVE_UP|MOVE_RIGHT
	.word	ANI_SETMODE,MODE_NORMAL|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
;	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	.word	ANI_END

#set
	move	*a13(WHOIHIT),a14,L
	movi	8*60,a0
	move	a0,*a14(DELAY_METER)
	rets


#chokeanim_tbl
	.long	hrt_choking_anim	;bret
	.long	rzr_choking_anim	;razor
	.long	und_choking_anim	;taker
	.long	yok_choking_anim	;yoko
	.long	shn_choking_anim	;shawn
	.long	bam_choking_anim	;bam
	.long	dnk_choking_anim	;doink
	.long	und_choking_anim	;spare
	.long	lex_choking_anim	;lex



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
 LWWW H4TN4X+FR1,74,-4,0
 LWWW H4TN4X+FR2,62,3,0
 LWWW H4TN4X+FR3,48,11,0
 LWWW H4TN4X+FR4,38,14,0
 LWWW H4TN4X+FR5,31,13,0
 .long 0
#Razor
 LWWW R3TN3X+FR1,62,-2,0
 LWWW R3TN3X+FR2,44,6,0
 LWWW R3TN3X+FR3,49,12,0
 LWWW R3TN3X+FR4,42,14,0
 LWWW R3TN3X+FR5,36,12,0
 .long 0
#Taker
 LWWW U3TN3B+FR2,33,6,0
 LWWW U3TN3B+FR3,35,10,0
 LWWW U3TN3B+FR4,57,16,0
 LWWW U3TN3B+FR5,49,19,0
 LWWW U3TN3B+FR6,45,18,0
 .long 0
#Yokozuna
 LWWW Y3TN3Z+FR1,44,-8,0
 LWWW Y3TN3Z+FR2,42,-1,0
 LWWW Y3TN3Z+FR3,43,10,0
 LWWW Y3TN3Z+FR4,45,15,0
 LWWW Y3TN3Z+FR5,41,15,0
 .long 0
#Shawn
 LWWW S3TN3X+FR1,64,-3,0
 LWWW S3TN3X+FR2,60,3,0
 LWWW S3TN3X+FR3,50,10,0
 LWWW S3TN3X+FR4,40,14,0
 LWWW S3TN3X+FR5,30,11,0
 .long 0
#BamBam
 LWWW B4TN4X+FR1,63,-4,0
 LWWW B4TN4X+FR2,49,4,0
 LWWW B4TN4X+FR3,46,9,0
 LWWW B4TN4X+FR4,40,13,0
 LWWW B4TN4X+FR5,34,13,0
 .long 0
#Doink
 LWWW D3TN3A+FR2,61,-8,0
 LWWW D3TN3A+FR3,54,0,0
 LWWW D3TN3A+FR4,39,8,0
 LWWW D3TN3A+FR5,30,13,0
 LWWW D3TN3A+FR6,32,11,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3TN3X+FR1,67,-4,0
 LWWW L3TN3X+FR2,64,2,0
 LWWW L3TN3X+FR3,57,10,0
 LWWW L3TN3X+FR4,45,13,0
 LWWW L3TN3X+FR5,38,12,0
 .long 0


#*
hrt_choking_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
;	.word	ANI_SETPLYRMODE,MODE_CHOKING
	.word	ANI_SETPLYRMODE,MODE_HEADHELD
	.word	ANI_SETWORD,USR_VAR1,0		;loop count
	WL	ANI_CODE,DO_CHOKE
#loop
	WL	4, H4TN4X+FR4
	WL	4, H4TN4X+FR3
	WL	3, H4TN4X+FR4
	WL	7,H4TN4X+FR5
	WL	4, H4TN4X+FR4
	WL	8,H4TN4X+FR3
	WL	3, H4TN4X+FR4
	WL	3, H4TN4X+FR5
	WL	7,H4TN4X+FR4
	WL	5,H4TN4X+FR5
	WL	ANI_CODE,inc_loop
	WL	ANI_IFNOTSTATUS,#loop
	WL	ANI_CODE,FIND_AND_KILL_ENDLESS
	WL	ANI_CHANGEANIM,hrt_3_head_held_brk_anim
#*
rzr_choking_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_SETPLYRMODE,MODE_HEADHELD
	.word	ANI_SETWORD,USR_VAR1,0		;loop count
	WL	ANI_CODE,DO_CHOKE
#loop
	WL	4, R3TN3X+FR4
	WL	4, R3TN3X+FR5
	WL	4, R3TN3X+FR4
	WL	7,R3TN3X+FR3
	WL	4, R3TN3X+FR4
	WL	6,R3TN3X+FR5
	WL	4, R3TN3X+FR4
	WL	5,R3TN3X+FR5
	WL	5,R3TN3X+FR4
	WL	5,R3TN3X+FR5
	WL	ANI_CODE,inc_loop
	WL	ANI_IFNOTSTATUS,#loop
	WL	ANI_CODE,FIND_AND_KILL_ENDLESS
	WL	ANI_CHANGEANIM,rzr_3_head_held_brk_anim
#*
und_choking_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_SETPLYRMODE,MODE_HEADHELD
	.word	ANI_SETWORD,USR_VAR1,0		;loop count
	WL	ANI_CODE,DO_CHOKE
#loop
	WL	4, U3TN3B+FR5
	WL	3, U3TN3B+FR3
	WL	7,U3TN3B+FR2
	WL	3, U3TN3B+FR3
	WL	4, U3TN3B+FR5
	WL	6,U3TN3B+FR6
	WL	3, U3TN3B+FR5
	WL	4, U3TN3B+FR3
	WL	4,U3TN3B+FR2
	WL	3, U3TN3B+FR3
	WL	4, U3TN3B+FR5
	WL	3,U3TN3B+FR6
	WL	ANI_CODE,inc_loop
	WL	ANI_IFNOTSTATUS,#loop
	WL	ANI_CODE,FIND_AND_KILL_ENDLESS
	WL	ANI_CHANGEANIM,und_3_head_held_brk_anim
#*
yok_choking_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_SETPLYRMODE,MODE_HEADHELD
	.word	ANI_SETWORD,USR_VAR1,0		;loop count
	WL	ANI_CODE,DO_CHOKE
#loop
	WL	5, Y3TN3Z+FR5
	WL	5, Y3TN3Z+FR4
	WL	5, Y3TN3Z+FR3
	WL	5, Y3TN3Z+FR2
	WL	8,Y3TN3Z+FR1
	WL	5, Y3TN3Z+FR2
	WL	5, Y3TN3Z+FR3
	WL	5, Y3TN3Z+FR4
	WL	5,Y3TN3Z+FR5

	WL	ANI_CODE,inc_loop
	WL	ANI_IFNOTSTATUS,#loop
	WL	ANI_CODE,FIND_AND_KILL_ENDLESS
	WL	ANI_CHANGEANIM,yok_3_head_held_brk_anim
#*
shn_choking_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_SETPLYRMODE,MODE_HEADHELD
	.word	ANI_SETWORD,USR_VAR1,0		;loop count
	WL	ANI_CODE,DO_CHOKE
#loop
	WL	4, S3TN3X+FR4
	WL	4, S3TN3X+FR3
	WL	4, S3TN3X+FR2
	WL	4, S3TN3X+FR3
	WL	8,S3TN3X+FR4
	WL	4, S3TN3X+FR3
	WL	8,S3TN3X+FR2
	WL	4, S3TN3X+FR3
	WL	8,S3TN3X+FR4
	WL	ANI_CODE,inc_loop
	WL	ANI_IFNOTSTATUS,#loop
	WL	ANI_CODE,FIND_AND_KILL_ENDLESS
	WL	ANI_CHANGEANIM,shn_3_head_held_brk_anim
#*
bam_choking_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_SETPLYRMODE,MODE_HEADHELD
	.word	ANI_SETWORD,USR_VAR1,0		;loop count
	WL	ANI_CODE,DO_CHOKE
#loop
	WL	4, B4TN4X+FR4
	WL	4, B4TN4X+FR5
	WL	8, B4TN4X+FR4
	WL	8, B4TN4X+FR5
	WL	10,B4TN4X+FR4
	WL	14,B4TN4X+FR5
	WL	ANI_CODE,inc_loop
	WL	ANI_IFNOTSTATUS,#loop
	WL	ANI_CODE,FIND_AND_KILL_ENDLESS
	WL	ANI_CHANGEANIM,bam_3_head_held_brk_anim
#*
dnk_choking_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_SETPLYRMODE,MODE_HEADHELD
	.word	ANI_SETWORD,USR_VAR1,0		;loop count
	WL	ANI_CODE,DO_CHOKE
#loop
	WL	4, D3TN3A+FR2
	WL	4, D3TN3A+FR3
	WL	4, D3TN3A+FR4
	WL	4, D3TN3A+FR6

	WL	4, D3TN3A+FR2
	WL	4, D3TN3A+FR3
	WL	4, D3TN3A+FR4
	WL	4, D3TN3A+FR6

	WL	4, D3TN3A+FR2
	WL	4, D3TN3A+FR3
	WL	4, D3TN3A+FR4
	WL	4, D3TN3A+FR6

	WL	ANI_CODE,inc_loop
	WL	ANI_IFNOTSTATUS,#loop
	WL	ANI_CODE,FIND_AND_KILL_ENDLESS
	WL	ANI_CHANGEANIM,dnk_3_head_held_brk_anim
#*
lex_choking_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_SETPLYRMODE,MODE_HEADHELD
	.word	ANI_SETWORD,USR_VAR1,0		;loop count
	WL	ANI_CODE,DO_CHOKE
#loop
	WL	4, L3TN3X+FR4
	WL	5, L3TN3X+FR3
	WL	5, L3TN3X+FR4
	WL	4, L3TN3X+FR5
	WL	4, L3TN3X+FR4
	WL	8,L3TN3X+FR3
	WL	6, L3TN3X+FR4
	WL	12,L3TN3X+FR5
	WL	ANI_CODE,inc_loop
	WL	ANI_IFNOTSTATUS,#loop
	WL	ANI_CODE,FIND_AND_KILL_ENDLESS
	WL	ANI_CHANGEANIM,lex_3_head_held_brk_anim

;Loop 4 times, then break out!
inc_loop
	move	*a13(USR_VAR1),a0
	inc	a0
	move	a0,*a13(USR_VAR1)
	cmpi	2,a0
	jrgt	#breakout
;He may have let me go by hitting his block butn!
;Handled in mode_headheld!
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
* SLAM DOWN FROM CHOKE HOLD (U_NKSL)

 SUBR	und_chokeslam_anim

	.ref	BAMFRE_P
	WLWW	ANI_SHADOWTRAIL,BAMFRE_P,3,12	;pal,rate,lifespan
	WL	ANI_SET_YVEL,0b8000h

	.word	ANI_DRAW_NAME,29

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_SCROLL_CTRL,230
	.word	ANI_ATTACHZ,0,0,-2		;put opp behind attacker
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	WL	ANI_SLAVEANIM,slaveanim_tbl
	WWLLW	ANI_SUPERSLAVE2,4,U2NS3X+FR1,puppet_tbls,0
	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker
	WWLLW	ANI_SUPERSLAVE2,4,U2NS3X+FR2,puppet_tbls,1
;	WLW	ANI_SET_ZVEL,-60000h,AM_ABS
	WLW	ANI_SET_ZVEL,10000h,AM_ABS
	WWLLW	ANI_SUPERSLAVE2,4,U2NS3X+FR3,puppet_tbls,2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT

	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2

	WWLLW	ANI_SUPERSLAVE2,3,U2NS3X+FR4,puppet_tbls,3
	WWLLW	ANI_SUPERSLAVE2,3,U2NS3X+FR5,puppet_tbls,4
	WWLLW	ANI_SUPERSLAVE2,3,U2NS3X+FR6,puppet_tbls,5

	WL	ANI_CODE,CALL_SPECIAL_MOVE

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_ATTACHZ,0,0,50		;put opp in front of attacker
	WWLLW	ANI_SUPERSLAVE2,2,U2NS3X+FR7,puppet_tbls,6

	WL	ANI_XFLIP_TBL,xflip_tbls
	WL	ANI_SLAVEANIM,slambounce_tbls
	WLLL	ANI_SETOPPVELS,0,40000h,30000h		;x,y,z vels

	.word	ANI_DAMAGEOPP,D_NECKSLAM,RD_NECKSLAM

	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40

	.word	ANI_SHADOWTRAIL,0	;off

	WL	22,U2NS3X+FR7
	WL	4,U2NS3X+FR8
	WL	4,U2NS3X+FR9
	WL	4,U2NS3X+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

xflip_tbls
	.word	0 ;bret
	.word	0 ;razor
	.word	0 ;taker
	.word	0 ;yoko
	.word	0 ;shawn
	.word	0 ;bam
	.word	0 ;doink
	.word	0 ;spare
	.word	1 ;lex

slambounce_tbls
	.long	hrt_slambounce_anim	;bret
	.long	rzr_slambounce_anim	;razor
	.long	und_slambounce_anim	;taker
	.long	yok_slambounce_anim	;yoko
	.long	shn_slambounce_anim	;shawn
	.long	bam_slambounce_anim	;bam
	.long	dnk_slambounce_anim	;doink
	.long	und_slambounce_anim	;spare
	.long	lex_slambounce_anim	;lex



puppet_tbls
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
 LWWW H3UC3X+FR1,37,18,1
 LWWW H3UC3X+FR2,20,27,1
 LWWW H3UC3X+FR3,13,23,1
 LWWW H3UC3X+FR4,9,33,1
 LWWW H3UC3X+FR5,18,40,1
 LWWW H3UC3X+FR5,28,11,1
 LWWW H2CP3A+FR8,19,-57,0
 .long 0
#Razor
 LWWW R3FD3B+FR1,35,18,1
 LWWW R3FD3B+FR2,25,22,1
 LWWW R3FD3B+FR3,23,23,1
 LWWW R3FD3B+FR4,16,31,1
 LWWW R3FD3B+FR5,17,29,1
 LWWW R3FD3B+FR5,28,-4,1
 LWWW R3GU2A+FR1,30,-52,0
 .long 0
#Taker
 LWWW U3FD3X+FR1,30,16,0
 LWWW U3FD3X+FR2,24,18,0
 LWWW U3FD3X+FR3,15,16,0
 LWWW U3FD3X+FR4,-2,32,0
 LWWW U3FD3X+FR5,4,50,0
 LWWW U3FD3X+FR5,13,17,0
 LWWW U3CP3B+FR1,13,-48,0
 .long 0
#Yokozuna
 LWWW Y3BO3C+FR4,19,18,0
 LWWW Y3FD3A+FR2,18,38,1
 LWWW Y3FD3A+FR3,21,28,1
 LWWW Y3FD3A+FR4,18,35,1
 LWWW Y3FD3A+FR5,22,38,1
 LWWW Y3FD3A+FR5,36,12,1
 LWWW Y3FD3A+FR7,32,-31,1
 .long 0
#Shawn
 LWWW S4LB3A+FR7,34,21,1
 LWWW S3UC3X+FR2,11,25,1
 LWWW S3UC3X+FR3,19,17,1
 LWWW S3UC3X+FR4,15,19,1
 LWWW S3UC3X+FR5,16,32,1
 LWWW S3UC3X+FR6,32,21,1
 LWWW S3OS3X+FR10,32,-49,0
 .long 0
#BamBam
 LWWW B4UC3B+FR1,22,21,1
 LWWW B4UC3B+FR2,22,20,1
 LWWW B4UC3B+FR3,22,10,1
 LWWW B4UC3B+FR4,18,20,1
 LWWW B4UC3B+FR5,20,33,1
 LWWW B4UC3B+FR5,31,3,1
 LWWW B3RL1A+FR1,30,-47,0
 .long 0
#Doink
 LWWW D3UC3A+FR1,30,16,1
 LWWW D3UC3A+FR3,13,37,1
 LWWW D3UC3A+FR4,14,29,1
 LWWW D3UC3A+FR5,9,33,1
 LWWW D3UC3A+FR6,15,20,1
 LWWW D3UC3A+FR7,23,14,1
 LWWW D3SA3A+FR9,17,-53,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3TN3X+FR5,38,12,1
 LWWW L3UC3X+FR1,17,19,1
 LWWW L3UC3X+FR2,24,15,1
 LWWW L3UC3X+FR3,23,6,1
 LWWW L3UC3X+FR4,19,39,1
 LWWW L3UC3X+FR5,23,59,1
 LWWW L3UC3X+FR5,36,19,1
 LWWW L3CP3X+FR1,34,-51,1
 .long 0

#*****************************************************************************
*
* SLAM DOWN FROM CHOKE HOLD (U_NKSL)

 SUBR	und_choke_face_slam_anim

	WL	ANI_SET_YVEL,48000h

	.word	ANI_DRAW_NAME,20
	.word	ANI_SOUND,82h			;Effort grunt

	.word	ANI_SET_RPTCOUNT,4		;3 times
	.word	ANI_CLR_BUTCOUNT

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_ATTACHZ,0,0,-2		;put opp behind attacker
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	WL	ANI_SLAVEANIM,slaveanim_tbl
	WWLLW	ANI_SUPERSLAVE2,4,U2NS3X+FR1,#puppet_tbl,0
	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker
	WWLLW	ANI_SUPERSLAVE2,4,U2NS3X+FR2,#puppet_tbl,1
	WLW	ANI_SET_ZVEL,-60000h,AM_ABS

	WWLLW	ANI_SUPERSLAVE2,4,U2NS3X+FR3,#puppet_tbl,2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,HIT_THE_MAT


	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2

	WWLLW	ANI_SUPERSLAVE2,3,U2NS3X+FR4,#puppet_tbl,3
	WLWW	ANI_SHADOWTRAIL,UNDNEG_P,3,12	;pal,rate,lifespan
	WWLLW	ANI_SUPERSLAVE2,3,U2NS3X+FR5,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,U2NS3X+FR6,#puppet_tbl,5

	WL	ANI_CODE,CALL_SPECIAL_MOVE

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_ATTACHZ,0,0,10		;put opp in front of attacker
	WWLLW	ANI_SUPERSLAVE2,2,U2NS3X+FR7,#puppet_tbl,6

;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_FACESLAM1,RD_FACESLAM1

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,3,#norepeat
	.word	ANI_DEC_RPTCOUNT
 	WL	ANI_IF_RPTCOUNT,#slam_again
	WL	ANI_GOTO,#norepeat

#slam_again
	.word	ANI_CLR_BUTCOUNT

;Slam him again using detach/reattach if button pressed again!
	WL	ANI_SLAVEANIM,#faced2_tbl
	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WL	3,U2NS3X+FR7
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,0a0000h,0h		;x,y,z vels
	WL	1,U2NS3X+FR7
	WL	4,U2NS3X+FR8

;	WL	6,U2NS3X+FR6
;	WL	6,U2NS3X+FR5

	WL	6,U2NS3X+FR9
	WL	6,U2NS3X+FR10

;	WL	10,U2NS3X+FR3

;Reattach me to who I'm slamming
	WL	ANI_CODE,#reattach

;	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_ATTACHZ,0,0,10		;put opp in front of attacker
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_ZEROVELS

;	WWLLW	ANI_SUPERSLAVE2,4,U2NS3X+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,7,U2NS3X+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,U2NS3X+FR5,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,U2NS3X+FR6,#puppet_tbl,5

;	WL	ANI_CODE,CALL_SPECIAL_MOVE

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_ATTACHZ,0,0,50		;put opp in front of attacker
	WWLLW	ANI_SUPERSLAVE2,2,U2NS3X+FR7,#puppet_tbl,6

;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_FACESLAM2,RD_FACESLAM2

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,3,#norepeat
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#slam_again

#norepeat
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	WL	ANI_SLAVEANIM,#faced_tbl
	.word	ANI_DETACH

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

;	WLW	ANI_SET_ZVEL,-10000h,AM_ABS
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS|MODE_NOAUTOFLIP|MODE_OVERLAP	;uninterruptable

	WL	3,U2NS3X+FR7
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,40000h,0h		;x,y,z vels
	WL	10,U2NS3X+FR7
	WL	4,U2NS3X+FR8
	WL	4,U2NS3X+FR9
	WL	4,U2NS3X+FR10
	.word	ANI_SHADOWTRAIL,0	;off

	.word	ANI_DETACH
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#reattach
	move	*a13(WHOIHIT),a0,L
	move	a0,*a13(ATTACH_PROC),L
	move	a13,*a0(ATTACH_PROC),L
	rets

#faced2_tbl
	.long	hrt_break_face2_anim,rzr_break_face2_anim
	.long	und_break_face2_anim
	.long	yok_break_face2_anim
	.long	shn_break_face2_anim,bam_break_face2_anim
	.long	dnk_break_face2_anim,0,lex_break_face2_anim

#faced_tbl
	.long	hrt_break_face_anim,rzr_break_face_anim
	.long	und_break_face_anim
	.long	yok_break_face_anim
	.long	shn_break_face_anim,bam_break_face_anim
	.long	dnk_break_face_anim,0,lex_break_face_anim


;#xflip_tbls
;	.word	0 ;bret
;	.word	0 ;razor
;	.word	0 ;taker
;	.word	0 ;yoko
;	.word	0 ;shawn
;	.word	0 ;bam
;	.word	0 ;doink
;	.word	0 ;spare
;	.word	1 ;lex



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
 LWWW H3FR3A+FR1,13,13,0
 LWWW H3MS3Z+FR2,12,16,0
 LWWW H3MS3Z+FR3,21,2,0
 LWWW H3MS3Z+FR4,11,9,0
 LWWW H3MS3Z+FR5,16,9,0
 LWWW H3MS3Z+FR5,24,-29,0
 LWWW H3MS3Z+FR6,16,-21,0
 .long 0
#Razor
 LWWW R3MS3Z+FR1,19,12,0
 LWWW R3MS3Z+FR2,20,15,0
 LWWW R3MS3Z+FR3,21,-3,0
 LWWW R3MS3Z+FR4,17,6,0
 LWWW R3MS3Z+FR5,24,4,0
 LWWW R3MS3Z+FR5,33,-40,0
 LWWW R3MS3Z+FR6,34,-40,0
 .long 0
#Taker
 LWWW U4AM4C+FR2,5,19,0
 LWWW U3MS3Z+FR1,9,32,0
 LWWW U3MS3Z+FR2,-5,19,0
 LWWW U3MS3Z+FR3,-13,10,0
 LWWW U3MS3Z+FR4,-2,10,0
 LWWW U3MS3Z+FR5,10,-33,0
 LWWW U3MS3Z+FR6,6,-25,0
 .long 0
#Yokozuna
 LWWW Y3MS3Z+FR1,22,15,0
 LWWW Y3MS3Z+FR2,21,30,0
 LWWW Y3MS3Z+FR3,14,11,0
 LWWW Y3MS3Z+FR4,3,14,0
 LWWW Y3MS3Z+FR5,7,9,0
 LWWW Y3MS3Z+FR5,14,-31,0
 LWWW Y3MS3Z+FR6,13,-36,0
 .long 0
#Shawn
 LWWW S3MS3Z+FR1,1,10,0
 LWWW S3MS3Z+FR2,0,18,0
 LWWW S3MS3Z+FR3,2,6,0
 LWWW S3MS3Z+FR4,2,12,0
 LWWW S3MS3Z+FR5,11,10,0
 LWWW S3MS3Z+FR5,24,-34,0
 LWWW S3MS3Z+FR6,34,-53,0
 .long 0
#BamBam
 LWWW B3MS3Z+FR1,14,15,0
 LWWW B3MS3Z+FR2,20,12,0
 LWWW B3MS3Z+FR3,22,-5,0
 LWWW B3MS3Z+FR4,18,9,0
 LWWW B3MS3Z+FR5,27,27,0
 LWWW B3MS3Z+FR6,40,-1,0
 LWWW B3RL1A+FR7,36,-49,0
 .long 0
#Doink
 LWWW D3GS3X+FR1,19,12,0
 LWWW D3GS3X+FR3,11,16,0
 LWWW D3GS3X+FR4,12,4,0
 LWWW D3GS3X+FR5,8,0,0
 LWWW D3GS3X+FR7,14,5,0
 LWWW D3GS3X+FR7,26,-35,0
 LWWW D3GS3X+FR8,23,-53,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3MS3Z+FR1,19,11,0
 LWWW L3MS3Z+FR2,11,15,0
 LWWW L3MS3Z+FR3,7,1,0
 LWWW L3MS3Z+FR4,3,2,0
 LWWW L3MS3Z+FR5,7,4,0
 LWWW L3MS3Z+FR6,19,-33,0
 LWWW L3TF3X+FR1,11,-51,0
 .long 0


#*****************************************************************************
*
* TOMBSTONE (FROM HEAD HOLD)  (U_TOMB)

 SUBR	und_combo_tombstone_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_ATTACK_ON, AMODE_PUPPET,32,15,45,41 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,U3PG3A+FR7
	.word	ANI_ATTACK_OFF

	.word	ANI_CLR_BUTCOUNT

;Check to see if I have tried to pile drive Yokozuna!

	.word	ANI_SOUND,82h			;Effort grunt

;FIX!! Yoko check
;	WL	ANI_CODE,is_this_yoko
;	WL	ANI_IFSTATUS,#yoko_miss

;got him
	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WL	ANI_SET_YVEL,28000h

	WL	ANI_SLAVEANIM,slaveanim_tbl

	WWLLW	ANI_SUPERSLAVE2,5,U3PG3A+FR7,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,5,U3PG3A+FR8,#puppet_tbl,1
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	WWLLW	ANI_SUPERSLAVE2,4,U3ZT3A+FR1,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,U3ZT3A+FR2,#puppet_tbl,3
	WWL	ANI_SETLONG,OBJ_GRAVITY,09800h
	WL	ANI_SET_YVEL,0a0000h
;Float toward the center of ring!
	WL	ANI_CODE,set_xdrift
	WWLLW	ANI_SUPERSLAVE2,4,U3ZT3A+FR3,#puppet_tbl,4
	.word	ANI_OFFSET,0,32,0			;x,y,z
	WWLLW	ANI_SUPERSLAVE2,4,U3ZT3A+FR4,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,10,U3ZT3A+FR5,#puppet_tbl,6

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_PILEDRIVER,RD_PILEDRIVER

	WWLLW	ANI_SUPERSLAVE2,4,U3ZT3A+FR7,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,4,U3ZT3A+FR8,#puppet_tbl,8

	WL	ANI_CODE,CALL_SPECIAL_MOVE

	WL	ANI_XFLIP_TBL,#xflip_tbl
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	WL	ANI_SLAVEANIM,#breakneck_tbl
	WLLL	ANI_SETOPPVELS,30000h,60000h,0	;x,y,z vels

	.word	ANI_DETACH

	.word	ANI_IMMOBILIZE,80

	.WORD	ANI_OPP_GETUP,-100

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	WL	12,U3ZT3A+FR8

	WL	6,U3GD2A+FR5
	WL	6,U3GD2A+FR6
	WL	6,U3GD4A+FR7
	WL	6,U3GD4A+FR8

	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETMODE,MODE_NORMAL

	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#NO_BUTT_DROP
	.WORD	ANI_INC_COMBO
	WL	ANI_CHANGEANIM,und_combo_flying_butt_drop_anim

#NO_BUTT_DROP
	.WORD	ANI_OPP_GETUP,10
	.WORD	ANI_INC_COMBO
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SHADOWTRAIL,0	;off
	.word	ANI_END

 SUBR	und_pile_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SCROLL_CTRL,UND_TBUKLY

	.word	ANI_ATTACK_ON, AMODE_PUPPET,32,15,65,61 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,U3PG3A+FR7
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;Check to see if I have tried to pile drive Yokozuna!

	.word	ANI_SOUND,82h			;Effort grunt

;FIX!! Yoko check
;	WL	ANI_CODE,is_this_yoko
;	WL	ANI_IFSTATUS,#yoko_miss

;got him
	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_ADD_MOVE,MOVE_C_6,2,2

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_SCROLL_CTRL,SC_RESTORE

	WL	ANI_SET_YVEL,28000h

;	WWL	ANI_SETLONG,OBJ_GRAVITY,0c000h
;	WL	ANI_SET_YVEL,080000h

	WL	ANI_SLAVEANIM,slaveanim_tbl

	WWLLW	ANI_SUPERSLAVE2,5,U3PG3A+FR7,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,5,U3PG3A+FR8,#puppet_tbl,1
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	WWLLW	ANI_SUPERSLAVE2,4,U3ZT3A+FR1,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,U3ZT3A+FR2,#puppet_tbl,3
	WWL	ANI_SETLONG,OBJ_GRAVITY,09800h
	WL	ANI_SET_YVEL,0a0000h
;Float toward the center of ring!
	WL	ANI_CODE,set_xdrift
	WWLLW	ANI_SUPERSLAVE2,4,U3ZT3A+FR3,#puppet_tbl,4
	.word	ANI_OFFSET,0,32,0			;x,y,z
	WWLLW	ANI_SUPERSLAVE2,4,U3ZT3A+FR4,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,10,U3ZT3A+FR5,#puppet_tbl,6

;do message
	.word	ANI_DRAW_NAME,40

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_PILEDRIVER,RD_PILEDRIVER

	WWLLW	ANI_SUPERSLAVE2,4,U3ZT3A+FR7,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,4,U3ZT3A+FR8,#puppet_tbl,8

	WL	ANI_CODE,CALL_SPECIAL_MOVE

	WL	ANI_XFLIP_TBL,#xflip_tbl
	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
	WL	ANI_SLAVEANIM,#breakneck_tbl
	WLLL	ANI_SETOPPVELS,30000h,60000h,0	;x,y,z vels

	.word	ANI_DETACH

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	WL	12,U3ZT3A+FR8

	WL	6,U3GD2A+FR5
	WL	6,U3GD2A+FR6
	WL	6,U3GD4A+FR7
	WL	6,U3GD4A+FR8
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	12,U3PG3A+FR7
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#xflip_tbl
	.word	1 ;bret
	.word	1 ;razor
	.word	1 ;taker
	.word	1 ;yoko
	.word	1 ;shawn
	.word	1 ;bam
	.word	1 ;doink
	.word	1 ;spare
	.word	1 ;lex

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
 LWWW H3PP3X+FR1,21,-42,0
 LWWW H3PP3X+FR2,16,10,0
 LWWW H3PP3X+FR3,8,29,0
 LWWW H3PP3X+FR4,12,28,0
 LWWW H3PP3X+FR5,32,47,0
 LWWW H3PP3X+FR6,36,49,0
 LWWW H3PP3X+FR6,41,49,0
 LWWW H3PP3X+FR7,51,14,0
 LWWW H3PP3X+FR8,71,-3,0
 .long 0
#Razor
 LWWW R3GP3Z+FR1,20,-41,0
 LWWW R3GP3Z+FR2,24,-19,0
 LWWW R3GP3Z+FR3,16,14,0
 LWWW R3GP3Z+FR4,31,30,0
 LWWW R3GP3Z+FR5,41,45,0
 LWWW R3GP3Z+FR6,49,47,0
 LWWW R3GP3Z+FR6,54,47,0
 LWWW R3GP3Z+FR7,51,32,0
 LWWW R3GP3Z+FR8,70,-6,0
 .long 0
#Taker
 LWWW U3PP3X+FR1,19,-37,1
 LWWW U3PP3X+FR2,25,-16,1
 LWWW U3PP3X+FR3,11,-14,1
 LWWW U3PP3X+FR4,12,-3,1
 LWWW U3PP3X+FR5,35,33,1
 LWWW U3PP3X+FR6,44,56,1
 LWWW U3PP3X+FR6,49,56,1
 LWWW U3GP3X+FR1,54,8,1
 LWWW U3GP3X+FR2,81,-12,1
 .long 0
#Yokozuna
 LWWW Y3PP3Q+FR1,17,-37,0
 LWWW Y3PP3Q+FR2,22,-21,0
 LWWW Y3PP3Q+FR3,20,-17,0
 LWWW Y3PP3Q+FR4,29,-14,0
 LWWW Y3PP3Q+FR6,33,11,0
 LWWW Y3PP3Q+FR7,39,18,0
 LWWW Y3PP3Q+FR7,44,18,0
 LWWW Y3FD3N+FR2,50,13,0
 LWWW Y3FD3N+FR3,72,16,0
 .long 0
#Shawn
 LWWW S3GP3X+FR1,25,-41,0
 LWWW S3GP3X+FR2,24,-18,0
 LWWW S3GP3X+FR3,20,-5,0
 LWWW S3GP3X+FR4,26,23,0
 LWWW S3GP3X+FR5,38,35,0
 LWWW S3OS3X+FR8,50,29,1
 LWWW S3OS3X+FR8,55,29,1
 LWWW S3FD3X+FR2,60,21,0
 LWWW S3GP3X+FR6,79,-3,0
 .long 0
#BamBam
 LWWW B3PP3Q+FR1,19,-44,0
 LWWW B3PP3Q+FR2,25,-12,0
 LWWW B3PP3Q+FR3,24,5,0
 LWWW B3PP3Q+FR4,31,21,0
 LWWW B3PP3Q+FR5,43,39,0
 LWWW B3PP3Q+FR6,41,47,0
 LWWW B3PP3Q+FR6,46,47,0
 LWWW B3PP3Q+FR7,54,22,0
 LWWW B3FD3C+FR1,69,2,0
 .long 0
#Doink
 LWWW D3PD3Z+FR1,20,-49,1
 LWWW D3PD3Z+FR2,25,-17,1
 LWWW D3PD3Z+FR3,18,2,1
 LWWW D3PD3Z+FR4,20,31,1
 LWWW D3PD3Z+FR5,32,44,1
 LWWW D3PD3Z+FR6,51,36,1
 LWWW D3PD3Z+FR6,56,36,1
 LWWW D3PD3Z+FR8,60,4,1
 LWWW D3PD3Z+FR9,85,-12,1
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3GP3Z+FR1,17,-42,0
 LWWW L3GP3Z+FR2,26,-20,0
 LWWW L3GP3Z+FR3,22,-13,0
 LWWW L3GP3Z+FR4,24,3,0
 LWWW L3GP3Z+FR5,38,18,0
 LWWW L3GP3Z+FR6,47,34,0
 LWWW L3GP3Z+FR6,52,34,0
 LWWW L3FH3A+FR6,51,17,0
 LWWW L3FD3B+FR1,75,-4,0
 .long 0


#breakneck_tbl
	.long	hrt_break_neck2_anim	;0
	.long	rzr_break_neck2_anim	;1
	.long	und_break_neck2_anim	;2
	.long	yok_break_neck2_anim	;3
	.long	shn_break_neck2_anim	;4
	.long	bam_break_neck2_anim	;5
	.long	dnk_break_neck2_anim	;6
	.long	lex_break_neck2_anim	;7
	.long	lex_break_neck2_anim	;8


#*****************************************************************************
*
* NECKBREAKER

 SUBR	und_combo_neckbreaker_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WLWW	ANI_SHADOWTRAIL,UNDNEG_P,4,7	;pal,rate,lifespan

;Do this to setup attach_proc
;Also allow misses!

	.word	ANI_OFFSET,15,0,0	;x,y,z
	.word	ANI_ATTACK_ON, AMODE_PUPPET,32,15,45,41 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,U3DD3A+FR1
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missedcx
	WL	ANI_IFBLOCKED,#missedcx

;Check to see if I have tried to pile drive Yokozuna!
	.word	ANI_SOUND,82h			;Effort grunt

	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST	;can go through ground
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_ADD_MOVE,MOVE_C_7,2,2

	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL

	WL	ANI_SLAVEANIM,slaveanim_tbl

	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR5,#puppet_tbl,4

	WWL	ANI_SETLONG,OBJ_GRAVITY,0c000h
	WL	ANI_SET_YVEL,80000h

	WWLLW	ANI_SUPERSLAVE2,6,U3DD3A+FR6,#puppet_tbl,5
	.word	ANI_OFFSET,-5,45,0	;x,y,z

	WWLLW	ANI_SUPERSLAVE2,1,U3DD3A+FR7,#puppet_tbl,6
	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_NECKBRKR,RD_NECKBRKR
;	WL	ANI_CODE,CALL_SPECIAL_MOVE

	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR9,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR10,#puppet_tbl,8

	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#slambounce_tbl
	WLLL	ANI_SETOPPVELS,0,60000h,0	;x,y,z vels

	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP

	WL	8,U3SU3A+FR2
 	WL	ANI_CODE,#zero_butn

	.word	ANI_SHADOWTRAIL,0	;off

	.WORD	ANI_INC_COMBO
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_CHANGEANIM,und_faceup_getup_anim

#missedcx
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO

	.word	ANI_SHADOWTRAIL,0	;off
	WL	ANI_CODE,#zero_butn

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


 SUBR	und_neckbreaker2_anim
;Button charge
;Standing no vel

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,5
	WL	2,U4GH3C+FR11
	.word	ANI_ATTACK_ON, AMODE_PUPPET,0,20,50,36 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,22,U4GH3C+FR11
	WL	4,U4GH3C+FR11
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb

	.word	ANI_OFFSET,15,0,0	;x,y,z
	WL	ANI_GOTO,#gothim

 SUBR	und_neckbreaker3_anim
;Button charge released while running
;Sliding neck breaker

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
 	WLWW	ANI_SHADOWTRAIL,UNDNEG_P,3,12	;pal,rate,lifespan

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,70,70,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_CODE,no_bk_xvel
	WL	ANI_SET_YVEL,0000h

	.word	ANI_STARTATTACK,AT_PUPPET,5

	WL	2,U4GH3C+FR11
	.word	ANI_ATTACK_ON, AMODE_PUPPET,0,15,50,41 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,12,U4GH3C+FR11
	.word	ANI_ZERO_XZVELS
	WL	4,U4GH3C+FR11
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missed

	.word	ANI_OFFSET,15,0,0	;x,y,z
	WL	ANI_GOTO,#gothim

 SUBR	und_neckbreaker_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h


;Do this to setup attach_proc
;Also allow misses!

	.word	ANI_OFFSET,15,0,0	;x,y,z
	.word	ANI_ATTACK_ON, AMODE_PUPPET,32,15,45,41 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,U3DD3A+FR1
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missed

;Check to see if I have tried to pile drive Yokozuna!
#gothim
	.ref	MAKE_HIM_SCREAM
	WL	ANI_CODE,MAKE_HIM_SCREAM
	.word	ANI_SOUND,82h			;Effort grunt

	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST	;can go through ground
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_ADD_MOVE,MOVE_C_7,2,2

	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL

	WL	ANI_SLAVEANIM,slaveanim_tbl

	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR5,#puppet_tbl,4

	WWL	ANI_SETLONG,OBJ_GRAVITY,0c000h
	WL	ANI_SET_YVEL,80000h

;do message

	WWLLW	ANI_SUPERSLAVE2,6,U3DD3A+FR6,#puppet_tbl,5
	.word	ANI_OFFSET,-5,45,0	;x,y,z

	WWLLW	ANI_SUPERSLAVE2,1,U3DD3A+FR7,#puppet_tbl,6
	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_NECKBRKR,RD_NECKBRKR
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR9,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,4,U3DD3A+FR10,#puppet_tbl,8

	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#slambounce_tbl
	WLLL	ANI_SETOPPVELS,0,60000h,0	;x,y,z vels

	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	WL	8,U3SU3A+FR2
	WL	ANI_CODE,#zero_butn
	.word	ANI_SHADOWTRAIL,0	;off
	WL	ANI_CHANGEANIM,und_faceup_getup_anim

#missedb
	.word	ANI_SHADOWTRAIL,0	;off
	WL	15,U4GH3C+FR11
;	WL	15,U3DD3A+FR1
#missed
	.word	ANI_SHADOWTRAIL,0	;off
	WL	15,U4GH3C+FR11
;	WL	15,U3DD3A+FR1
	WL	ANI_CODE,#zero_butn

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#zero_butn
;Force player to start holding his button down starting at the end
;of the current buzz sequence.

	move	*a13(PLYRNUM),a0
	X16	a0
	addi	punch_dtime1,a0
	clr	a14
 	move	a14,*a0
	rets

#xflip_tbl
	.word	0 ;bret
	.word	0 ;razor
	.word	0 ;taker
	.word	1 ;yoko
	.word	0 ;shawn
	.word	0 ;bam
	.word	0 ;doink
	.word	1 ;spare
	.word	0 ;lex

#slambounce_tbl
	.long	hrt_slambounce2_anim	;bret
	.long	rzr_slambounce2_anim	;razor
	.long	und_slambounce2_anim	;taker
	.long	yok_slambounce2_anim	;yoko
	.long	shn_slambounce2_anim	;shawn
	.long	bam_slambounce2_anim	;bam
	.long	dnk_slambounce2_anim	;doink
	.long	und_slambounce2_anim	;spare
	.long	lex_slambounce2_anim	;lex

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
 LWWW H3DD3B+FR1,30,-37,1
 LWWW H3DD3B+FR2,40,-34,1
 LWWW H3DD3B+FR3,44,-21,1
 LWWW H3DD3B+FR4,51,-11,1
 LWWW H3UC3X+FR2,32,7,1
 LWWW H3UC3X+FR3,53,14,1
 LWWW H3UC3X+FR4,75,17,1
 LWWW H2CP3A+FR1,89,-12,0
 LWWW H3UC3Z+FR10,74,-2,1
 .long 0
#Razor
 LWWW R3DD3C+FR1,31,-36,1
 LWWW R3DD3C+FR2,37,-25,1
 LWWW R3DD3C+FR3,52,-13,1
 LWWW R3DD3C+FR6,60,-6,1
 LWWW R3DD3C+FR7,37,-7,1
 LWWW R3FD3B+FR4,62,21,1
 LWWW R3FD3B+FR5,77,29,1
 LWWW R3AM3D+FR2,90,-14,0
 LWWW R3AM3X+FR1,87,-16,1
 .long 0
#Taker
 LWWW U3DD3B+FR1,35,-35,1
 LWWW U3DD3B+FR2,37,-15,1
 LWWW U3DD3B+FR3,37,-9,1
 LWWW U3DD3B+FR4,46,-8,1
 LWWW U3DD3B+FR6,38,-4,1
 LWWW U3DD3B+FR7,61,3,1
 LWWW U3FD3X+FR4,60,18,0
 LWWW U3CP3B+FR3,77,0,0
 LWWW U3DD3X+FR9,79,-6,1
 .long 0
#Yokozuna
 LWWW Y4AM4A+FR4,44,-33,0
 LWWW Y4AM4A+FR3,43,-27,0
 LWWW Y3FD3B+FR2,44,-16,1
 LWWW Y3FD3B+FR3,47,-8,1
 LWWW Y3FD3B+FR4,39,15,1
 LWWW Y3FD3B+FR5,69,33,1
 LWWW Y3FD3A+FR4,78,34,1
 LWWW Y3CP3B+FR1,79,-12,0
 LWWW Y3FD3Z+FR7,80,5,1
 .long 0
#Shawn
 LWWW S3DD3B+FR1,35,-35,1
 LWWW S3DD3B+FR2,37,-23,1
 LWWW S3DD3B+FR3,39,-15,1
 LWWW S3DD3B+FR5,52,-10,1
 LWWW S3UC3X+FR2,32,4,1
 LWWW S3UC3X+FR4,66,9,1
 LWWW S3UC3X+FR5,84,28,1
 LWWW S3CP3B+FR2,87,-11,0
 LWWW S3UC3Z+FR8,90,0,1
 .long 0
#BamBam
 LWWW B3DD3D+FR1,41,-38,1
 LWWW B3DD3D+FR2,42,-23,1
 LWWW B3DD3D+FR3,44,0,1
 LWWW B3DD3D+FR4,51,17,1
 LWWW B3DD3D+FR5,41,31,1
 LWWW B3DD3D+FR6,67,39,1
 LWWW B4UC3B+FR3,82,12,1
 LWWW B3CP3B+FR2,90,19,0
 LWWW B4UC3Z+FR8,88,0,1
 .long 0
#Doink
 LWWW D3DD3C+FR1,38,-37,1
 LWWW D3DD3C+FR2,40,-26,1
 LWWW D3DD3C+FR3,37,1,1
 LWWW D3DD3C+FR4,42,15,1
 LWWW D3DD3C+FR5,31,23,1
 LWWW D3UC3A+FR3,56,21,1
 LWWW D3UC3A+FR5,75,21,1
 LWWW D3SA3A+FR4,78,-16,0
 LWWW D3SA3X+FR2,84,-18,1
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3DD3A+FR1,29,-40,1
 LWWW L3DD3A+FR2,31,-22,1
 LWWW L3DD3A+FR3,29,-21,1
 LWWW L3UC3X+FR2,49,-16,1
 LWWW L3UC3X+FR3,34,-9,1
 LWWW L3CP3X+FR2,64,-1,0
 LWWW L3CP3X+FR3,87,14,0
 LWWW L3CP3X+FR6,82,16,0
 LWWW L3UC3Z+FR10,74,1,1
 .long 0


#*****************************************************************************
*
* SNAP MIRROR (whatever)

 SUBR	und_2_snapmirror2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	1,U1TT5A+FR3
	WL	1,U1TT5A+FR4

 SUBR	und_4_snapmirror2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,2
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,60,60,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_SET_YVEL,0000h

	WL	2,U4FG3A+FR1
	.word	ANI_ATTACK_ON, AMODE_PUPPET,13,26,64,58 ;mode,x,y,w,h
	WL	2,U4FG3A+FR2
	WWL	ANI_WAITHITOPP,5,U4FG3A+FR3
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACK_OFF

	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	WL	ANI_GOTO,#cont



 SUBR	und_combo_snapmirror_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,8
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_SET_YVEL,0000h

	WL	2,U4FG3A+FR1
	WL	2,U4FG3A+FR2
	.word	ANI_ATTACK_ON, AMODE_PUPPET,12,59,73,59 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,3,U4FG3A+FR3
	.word	ANI_ZERO_XZVELS
	WWL	ANI_WAITHITOPP,3,U4FG3A+FR3
	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	WL	ANI_IFNOTSTATUS,#missedcx
	WL	ANI_IFBLOCKED,#missedbcx

;got him
;	WL	ANI_CODE,CALL_SPECIAL_MOVE
	WL	ANI_CODE,DO_GRUNT

	.word	ANI_OFFSET,0,0,-2			;x,y,z
	.word	ANI_ATTACHZ,0,0,-2		;put opp behind attacker
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_FACE,MOVE_LEFT|MOVE_DOWN
	WL	ANI_CODE,SMALL_BOUNCE
	WWLLW	ANI_SUPERSLAVE2,10,U4FT3A+FR3,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,6,U4FT3A+FR4,#puppet_tbl,1
	WWWL	ANI_IFROPE,RC_FRONT,XTOSSDIST_CLOSE,#throw_him_out

	WWLLW	ANI_SUPERSLAVE2,4,U4FT3A+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,U4FT3A+FR6,#puppet_tbl,3

	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker
	WWLLW	ANI_SUPERSLAVE2,4,U4FT3A+FR7,#puppet_tbl,4

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,35
	.word	ANI_DAMAGEOPP,D_HIPTOSS,RD_HIPTOSS

	.WORD	ANI_INC_COMBO
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_OPP_GETUP,300

	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#slambounce_tbl
	.word	ANI_CLROPPMODE,MODE_GHOST
	WLLL	ANI_SETOPPVELS,30000h,40000h,0	;x,y,z vels

	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP

	WL	5,U4FT3A+FR8
	.word	ANI_XFLIP
	WL	5,U4FT3A+FR9
	WL	5,U4FT3A+FR10
	WL	5,U4FT3A+FR11

	.word	ANI_SHADOWTRAIL,0	;off
	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedbcx
#missedcx
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SHADOWTRAIL,0	;off

	WL	16,U4FG3A+FR3
	WL	4,U4FG3A+FR2
	WL	4,U4FG3A+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#throw_him_outcx
	WL	ANI_CODE,CALL_THROWN_OUT
	WLLL	ANI_ATTACHVEL,0A0000h,90000h,0h		;x,y,z
	WL	ANI_SLAVEANIM,#flyout_tbl
	WL	ANI_OPPOFFSET,release_table

	.word	ANI_DETACH
	WL	4,U4FT3A+FR5
	WL	50,U4FT3A+FR6
	WL	4,U4FT3A+FR7

	.WORD	ANI_INC_COMBO
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
;	WL	ANI_CODE,HIT_THE_MAT
;	.word	ANI_SHAKEALL,2
;	.word	ANI_SHAKER,35
	.word	ANI_DAMAGEOPP,D_HIPTOSS,RD_HIPTOSS

	WL	5,U4FT3A+FR8
	.word	ANI_XFLIP
	WL	5,U4FT3A+FR9
	WL	5,U4FT3A+FR10
	WL	5,U4FT3A+FR11

	.word	ANI_SHADOWTRAIL,0	;off
	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


;Hiptoss

 SUBR	und_2_snapmirror_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

;	WL	2,U1TT5A+FR3
;	WL	2,U1TT5A+FR4

 SUBR	und_4_snapmirror_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,10
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_SET_YVEL,0000h

	WL	2,U4FG3A+FR1
	WL	2,U4FG3A+FR2

	.word	ANI_ATTACK_ON, AMODE_PUPPET_TOSS,12,59,73,59 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,U4FG3A+FR3
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACK_OFF
	WL	4,U4FG3A+FR3
#cont
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb

#got_him
	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	.word	ANI_DRAW_NAME,3

	WL	ANI_CODE,CALL_OTHER_AVERAGE
	WL	ANI_CODE,DO_GRUNT

	.word	ANI_OFFSET,0,0,-2			;x,y,z
	.word	ANI_ATTACHZ,0,0,-2		;put opp behind attacker
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_FACE,MOVE_LEFT|MOVE_DOWN
	WL	ANI_CODE,SMALL_BOUNCE
	WWLLW	ANI_SUPERSLAVE2,8,U4FT3A+FR3,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,5,U4FT3A+FR4,#puppet_tbl,1
	WWWL	ANI_IFROPE,RC_FRONT,XTOSSDIST_CLOSE,#throw_him_out

	WWLLW	ANI_SUPERSLAVE2,3,U4FT3A+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,U4FT3A+FR6,#puppet_tbl,3
	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker
	WWLLW	ANI_SUPERSLAVE2,3,U4FT3A+FR7,#puppet_tbl,4

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,35
	.word	ANI_DAMAGEOPP,D_HIPTOSS,RD_HIPTOSS

	.word	ANI_OPP_GETUP,300

	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#slambounce_tbl
	.word	ANI_CLROPPMODE,MODE_GHOST
	WLLL	ANI_SETOPPVELS,30000h,40000h,0	;x,y,z vels

	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP

	WL	4,U4FT3A+FR8
	.word	ANI_XFLIP
	WL	4,U4FT3A+FR9
	WL	4,U4FT3A+FR10
	WL	4,U4FT3A+FR11

	.word	ANI_SHADOWTRAIL,0	;off
	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedb
;	.ref	ck_hiptoss
;	WL	ANI_CODE,ck_hiptoss
;	WL	ANI_IFNOTSTATUS,#got_him

	WL	10,U4FG3A+FR3
;Delay longer if 2nd hiptoss in quick succession!
	.ref	hiptoss_delay
	WL	ANI_CODE,hiptoss_delay
	WL	ANI_IFNOTSTATUS,#missed
	WL	24,U4FG3A+FR3
#missed
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SHADOWTRAIL,0	;off

	WL	2,U4FG3A+FR3
	WL	3,U4FG3A+FR2
	WL	3,U4FG3A+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#throw_him_out
	WL	ANI_CODE,CALL_THROWN_OUT
	WLLL	ANI_ATTACHVEL,0A0000h,90000h,0h		;x,y,z
	WL	ANI_SLAVEANIM,#flyout_tbl
	WL	ANI_OPPOFFSET,release_table
	.word	ANI_DETACH

	WL	4,U4FT3A+FR5
	WL	4,U4FT3A+FR6
	WL	1,U4FT3A+FR7
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,15
	WL	3,U4FT3A+FR7

	WL	3,U4FT3A+FR8
	.word	ANI_XFLIP
	WL	3,U4FT3A+FR9
	WL	3,U4FT3A+FR10
	WL	3,U4FT3A+FR11

	.word	ANI_SHADOWTRAIL,0	;off
	.word	ANI_FACEDOWN
	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

release_table
	;	X Y
	.word	48,0		;Bret
	.word	48,16		;Razor
	.word	32,0		;Taker
	.word	24,0		;Yokozuna
	.word	16,0		;Shawn
	.word	32,16		;BamBam
	.word	32,16		;Doink
	.word	0,0		;Adam
	.word	24,8		;Lex

#flyout_tbl
	.long	hrt_flyout_anim
	.long	rzr_flyout_anim
	.long	und_flyout_anim
	.long	yok_flyout_anim
	.long	shn_flyout_anim
	.long	bam_flyout_anim
	.long	dnk_flyout_anim
	.long	0
	.long	lex_flyout_anim

#xflip_tbl
	.word	0 ;bret
	.word	0 ;razor
	.word	0 ;taker
	.word	0 ;yoko
	.word	0 ;shawn
	.word	1 ;bam
	.word	0 ;doink
	.word	0 ;spare
	.word	0 ;lex

#slambounce_tbl
	.long	hrt_slambounce_anim	;bret
	.long	rzr_slambounce_anim	;razor
	.long	und_slambounce_anim	;taker
	.long	yok_slambounce_anim	;yoko
	.long	shn_slambounce_anim	;shawn
	.long	bam_slambounce_anim	;bam
	.long	dnk_slambounce_anim	;doink
	.long	und_slambounce_anim	;spare
	.long	lex_slambounce_anim	;lex

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
 LWWW H2AM3A+FR1,63,-7,1
 LWWW H3FR3A+FR2,32,34,1
 LWWW H3FR3A+FR4,-32,41,1
 LWWW H3FR3A+FR5,-59,6,1
 LWWW H2CP3A+FR8,-147,-56,0
 .long 0
#Razor
 LWWW R3TD3A+FR1,52,-1,1
 LWWW R3TD3A+FR4,33,31,1
 LWWW R3TD3A+FR6,-17,39,1
 LWWW R3TD3A+FR8,-51,19,1
 LWWW R3GU2A+FR1,-143,-53,0
 .long 0
#Taker
 LWWW U4AM4C+FR4,55,-9,1
 LWWW U3FH3A+FR2,32,38,0
 LWWW U3FH3A+FR4,-34,49,0
 LWWW U3FH3A+FR5,-59,28,0
 LWWW U3CP3B+FR1,-152,-49,0
 .long 0
#Yokozuna
 LWWW Y3MS3Z+FR2,63,0,1
 LWWW Y3FL3W+FR4,39,53,1
 LWWW Y3FL3W+FR6,-36,61,1
 LWWW Y3FL3W+FR7,-58,22,1
 LWWW Y3FD3A+FR7,-117,-32,1
 .long 0
#Shawn
 LWWW S3OS3X+FR4,28,-4,0
 LWWW S3OS3X+FR6,23,66,0
 LWWW S3OS3X+FR8,-12,71,0
 LWWW S3OS3X+FR9,-58,34,0
 LWWW S3OS3X+FR10,-115,-44,0
 .long 0
#BamBam
 LWWW B4TD3B+FR3,41,-17,1
 LWWW B4TD3B+FR5,44,54,1
 LWWW B4TD3B+FR7,-29,67,1
 LWWW B4TD3B+FR8,-51,26,1
 LWWW B4TD3B+FR9,-111,-43,1
 .long 0
#Doink
 LWWW D3PM4C+FR2,45,-4,1
 LWWW D3OS3A+FR3,32,27,1
 LWWW D3OS3A+FR6,-21,42,1
 LWWW D3FD3E+FR2,-62,-8,1
 LWWW D3SA3A+FR2,-140,-53,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L4AM4B+FR2,66,-10,1
 LWWW L3FH3A+FR3,41,44,1
 LWWW L3FH3A+FR5,-22,34,1
 LWWW L3FH3A+FR6,-45,14,1
 LWWW L3CP3X+FR1,-146,-47,0
 .long 0


#*****************************************************************************
*
* END OF NECK BROKEN SEQ.

 SUBR	und_neckbroken_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	WL	1,U3CR3A+FR1
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,und_getup_anim


#*****************************************************************************
*
* CLIMB UP TURNBUCKLES

 SUBR	und_climb_up_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SCROLL_CTRL,UND_TBUKLY

	WL	3,U2CT2C+FR5
	WL	3,U2CT2C+FR6
	WL	3,U2CT2C+FR7
	WL	3,U2CT2C+FR8

	WL	ANI_CODE,tgt_tbukl
	.word	ANI_LEAPATPOS,25,200,10,6,0	;#ticks,dist,xoff,yoff,zoff

	WL	25,U2CT2C+FR9

	.word	ANI_SETPLYRMODE,MODE_ONTURNBKL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOGRAVITY|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SHAKECORNER
	.word	ANI_SCROLL_CTRL,SC_RESTORE


#lp
	WL	5,U4SB4A+FR8
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR7
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR6
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR5
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR4
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR3
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR2
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR1
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR2
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR3
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR4
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR5
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR6
	WL	ANI_CODE,tbukl_flip
	WL	5,U4SB4A+FR7
	WL	ANI_CODE,tbukl_flip
	WL	ANI_GOTO,#lp

#*****************************************************************************
*
* CLIMB DOWN TURNBUCKLES

 SUBR	und_climb_down_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SCROLL_CTRL,SC_RESTORE

	WL	ANI_CODE,face_inside

	.word	ANI_SHAKECORNER

	WL	3,U2CT2C+FR8

	WLW	ANI_SET_XVEL,10000h,AM_FACE_REL
	WLW	ANI_SET_ZVEL,-10000h,AM_FACE_REL
	WL	ANI_SET_YVEL,20000h

	WL	1,U2CT2C+FR9
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,U2CT2C+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* GET BUZZED FROM DOINK

 SUBR	und_get_buzz_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;	.word	ANI_XFLIP
	.word	ANI_GRAVITY_OFF

	WL	ANI_CODE,set_position

	WL	ANI_CODE,set_skeleton_pal
	WL	2,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,U4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	ANI_CODE,make_white
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_norm
	WL	ANI_CODE,set_my_pal
	WL	3,U4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,U4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_white
	WL	3,U4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,U4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,U4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	ANI_CODE,make_white
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_norm
	WL	ANI_CODE,set_my_pal
	WL	3,U4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	ANI_CODE,start_smoke

	.word	ANI_DETACH
	.word	ANI_GRAVITY_ON
	WL	ANI_SET_YVEL,60000h
	WLW	ANI_SET_XVEL,-30000h,AM_FACE_REL
	WLW	ANI_SET_ZVEL,20000h,AM_ABS
	WL	ANI_CODE,#make_black
	WL	3,U4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,U4BZ4A+FR1
	WL	ANI_CODE,#make_black
	WL	3,U4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,U4BZ4A+FR1
	WL	ANI_CODE,#make_black
	WL	3,U4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,U4BZ4A+FR1

	.word	ANI_WAITHITGND
	.word	ANI_XFLIP
	.word	ANI_FACEDOWN
	.word	ANI_OFFSET,-20,0,0			;x,y,z

	WL	1,U4ST4D+FR5

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,und_fall_back_anim
	.word	ANI_END

#nodead
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#make_black

;This is a black color within the wrestler's pal.  It is different for each
;wrestler.
;	movi	1e1eh,a14
	movi	3f3fh,a14

	move	a14,*a13(OBJ_CONST)
	move	*a13(OBJ_CONTROL),a14
	andni	01111b,a14
	ori	M_CONNON,a14
	move	a14,*a13(OBJ_CONTROL)
	rets

#*****************************************************************************

 SUBR	und_3_head_held_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_HEADHELD
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim

	.word	ANI_SETWORD,USR_VAR1,0		;loop count

#loop
	WL	4,U4BF3Z+FR5
	WL	4,U4BF3Z+FR7
	WL	4,U4BF3Z+FR9
	WL	4,U4BF3Z+FR10
	WL	4,U4BF3Z+FR1
	WL	4,U4BF3Z+FR2
	WL	4,U4BF3Z+FR3
	WL	ANI_CODE,#inc_loop
	WL	ANI_IFNOTSTATUS,#loop

;Continue into break...

 SUBR	und_3_head_held_brk_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	ANI_CODE,FIND_AND_KILL_ENDLESS

	WLW	ANI_SET_XVEL,-38000h,AM_NEWFACE_REL
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	WL	4,U4BF3A+FR2
	.word	ANI_DETACH

;Standard #2 head hit from spin kick
	WL	3,U2AH3A+FR3
	WL	3,U2AH3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,U2AH3A+FR5
	WL	3,U2AH3A+FR6
	WL	3,U2AH3A+FR7

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


;Loop 4 times, then break out!
#inc_loop
	move	*a13(USR_VAR1),a0
	inc	a0
	move	a0,*a13(USR_VAR1)
	cmpi	2,a0
	jrgt	#breakout
;He may have let me go by hitting his block butn!
;Handled in mode_headheld!
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

 SUBR	und_3_head_held_stand_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	3,U4BF3Z+FR3
	WL	3,U1TT5A+FR2	;2.5
	.word	ANI_DETACH

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* ROLL OVER AND BREAK YER STINKIN' NECK

 SUBR	und_break_neck_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_ONGROUND

	WL	3,U3GP3X+FR3
	.word	ANI_OFFSET,-5,0,0
	WL	4,U3GP3X+FR4
	.word	ANI_OFFSET,-8,0,0
	WL	4,U3GP3X+FR5
	.word	ANI_OFFSET,-27,0,0
	WL	4,U3GP3X+FR6

	.word	ANI_XFLIP

	.word	ANI_OFFSET,-22,0,0			;x,y,z

	.word	ANI_ZEROVELS
	WL	4,U3CR3A+FR7	;10

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,und_getup_anim

 SUBR	und_break_neck2_anim
	.word	ANI_SETSPEED,100h

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,60000h
	WL	ANI_CODE,ckzpos
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim

	.word	ANI_XFLIP
	WL	5,U3GP3X+FR3
	WL	5,U3GP3X+FR4
	WL	5,U3GP3X+FR5
	WL	5,U3GP3X+FR6
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
;	.word	ANI_SOUND,bounce_l1
	.word	ANI_ZEROVELS
	.word	ANI_XFLIP
	.word	ANI_OFFSET,-22,0,0			;x,y,z

	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	WL	10,U3CR3A+FR7
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,und_getup_anim

 SUBR	und_break_neck3_anim
	.word	ANI_SETSPEED,100h

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,58000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	WL	ANI_CODE,ckzpos

	.word	ANI_DEBRIS,300,5,0,-5,0	;%chance, tbl index, x,y,z off

	WL 	15,U4POGO+FR4
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim

;	.word	ANI_XFLIP
	WL	4,U3GP3X+FR1
	WL	4,U3GP3X+FR2
	WL	4,U3GP3X+FR3
	WL	4,U3GP3X+FR4
	WL	4,U3GP3X+FR5
	WL	4,U3GP3X+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_XFLIP
	.word	ANI_OFFSET,-22,0,0			;x,y,z

	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	WL	10,U3CR3A+FR7
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,und_getup_anim

******************************************************************************

 SUBR	und_2_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

;Too many turns here!
;Fix!!
;	WL	1,U1TT5A+FR2
	WL	1,U1TT5A+FR3
	WL	1,U1TT5A+FR4

 SUBR	und_4_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	3,U4GH3C+FR1

	LEAPATOPP 7,999,80,80,30000h,TGT_HEAD,0,6,0
	WL	4,U4GH3C+FR2
	WL	3,U4GH3C+FR3
	.word	ANI_ZERO_XZVELS
	WL	3,U4GH3C+FR4
	WL	3,U4GH3C+FR5

	.word	ANI_ATTACK_ON, AMODE_PUPPET2,19,5,22,25 ;mode,x,y,w,h
	WL	4,U4GH3C+FR6
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2

;got him
	.word	ANI_CLR_BUTCOUNT
	WL	ANI_CODE,clear_opp_counts
	WL	ANI_CODE,CALL_SETUP
	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	WL	ANI_CODE,DO_NONO
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SOUND,98h			;neck break (5-7 ticks late)
	WL	ANI_CODE,CALL_SETUP

	WWLLW	ANI_SUPERSLAVE2,3,U4GH3C+FR7,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,U4GH3C+FR8,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,U4GH3C+FR9,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,U4GH3C+FR10,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,U4GH3C+FR11,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,U4GH3C+FR11,#puppet_tbl,5

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	1,U4GH3C+FR11
	.word	ANI_CLROPPMODE,MODE_GHOST

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
	WL	20,U4GH3C+FR6
	WL	2,U4GH3C+FR5
	WL	2,U4GH3C+FR4
	WL	2,U4GH3C+FR3
	WL	2,U4GH3C+FR2
	WL	2,U4GH3C+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#headheld_tbl
	.long	hrt_3_head_held_anim
	.long	rzr_3_head_held_anim
	.long	und_3_head_held_anim
	.long	yok_3_head_held_anim
	.long	shn_3_head_held_anim
	.long	bam_3_head_held_anim
	.long	dnk_3_head_held_anim
	.long	0
	.long	lex_3_head_held_anim

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
 LWWW H3GU4A+FR1,39,-42,0
 LWWW H3GU4A+FR2,48,-52,0
 LWWW H3GU4A+FR3,57,-51,0
 LWWW H3DU3A+FR3,50,-43,1
 LWWW H3DU3A+FR4,51,-36,1
 LWWW H3BF3A+FR1,50,-42,0
 .long 0
#Razor
 LWWW R3GU2A+FR3,43,-33,0
 LWWW R3GU4A+FR3,53,-50,0
 LWWW R3GU4A+FR5,58,-53,0
 LWWW R3DU3B+FR2,55,-47,1
 LWWW R3DU3B+FR4,54,-36,1
 LWWW R3BF3A+FR1,53,-44,0
 .long 0
#Taker
 LWWW U3DU3B+FR2,44,-34,1
 LWWW U3DU3B+FR5,51,-43,1
 LWWW U3DU3B+FR6,53,-44,1
 LWWW U3DU3B+FR8,48,-35,1
 LWWW U3DU3B+FR10,50,-28,1
 LWWW U4BF3Z+FR5,51,-23,0
 .long 0
#Yokozuna
 LWWW Y3GU2A+FR1,40,-28,0
 LWWW Y3GU2A+FR3,60,-36,0
 LWWW Y3GU2A+FR4,31,-48,0
 LWWW Y3GU2A+FR6,39,-53,0
 LWWW Y3GU2A+FR11,49,-37,0
 LWWW Y3BF3A+FR1,50,-32,0
 .long 0
#Shawn
 LWWW S3GU2A+FR1,39,-36,0
 LWWW S3GU4A+FR2,44,-48,0
 LWWW S3GU4A+FR4,51,-54,0
 LWWW S3GU4A+FR5,52,-44,0
 LWWW S3GU4A+FR7,47,-35,0
 LWWW S3BF3A+FR1,36,-43,0
 .long 0
#BamBam
 LWWW B3GU4A+FR3,47,-32,0
 LWWW B3GU4A+FR5,57,-48,0
 LWWW B3GU4A+FR7,53,-52,0
 LWWW B3GU4A+FR8,53,-48,0
 LWWW B3GU4A+FR10,53,-42,0
 LWWW B3BF3C+FR5,54,-35,0
 .long 0
#Doink
 LWWW D3GU4A+FR2,48,-37,0
 LWWW D3GU4A+FR4,51,-53,0
 LWWW D3GU4A+FR5,52,-42,0
 LWWW D3GU4A+FR6,50,-36,0
 LWWW D3GU4A+FR7,54,-39,0
 LWWW D3BF3A+FR2,50,-41,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3GU4A+FR1,43,-36,0
 LWWW L3GU4A+FR2,59,-44,0
 LWWW L3DU3A+FR4,31,-48,1
 LWWW L3DU3A+FR6,35,-48,1
 LWWW L3DU3A+FR9,45,-38,1
 LWWW L3BF3B+FR5,47,-39,0
 .long 0

#******************************************************************************

 SUBR	und_4_taunt_anim

	.word	ANI_SETMODE,MODE_UNINT
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	4,U4CO4B+FR1
	WL	4,U4CO4B+FR2
	WL	15,U4CO4B+FR3
	WL	4,U4CO4B+FR4
	WL	4,U4CO4B+FR5
	WL	4,U4CO4B+FR6
	WL	4,U4CO4B+FR7
	WL	4,U4CO4B+FR8
	WL	4,U4CO4B+FR7
	WL	4,U4CO4B+FR6
	WL	4,U4CO4B+FR5
	WL	4,U4CO4B+FR4
	WL	15,U4CO4B+FR3

	WL	4,U4CO4B+FR2
	WL	4,U4CO4B+FR1

;	WL	4,U4CO4B+FR4
;	WL	4,U4CO4B+FR5
;	WL	4,U4CO4B+FR6
;	WL	4,U4CO4B+FR7
;	WL	4,U4CO4B+FR8
;	WL	4,U4CO4B+FR7
;	WL	4,U4CO4B+FR6
;	WL	4,U4CO4B+FR5
;	WL	4,U4CO4B+FR4
;	WL	4,U4CO4B+FR3
;	WL	4,U4CO4B+FR2
;	WL	4,U4CO4B+FR1

;	.ref	set_taunt_bit
;	WL	ANI_CODE,set_taunt_bit

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,und_stand4_anim
	.word	ANI_END

#*****************************************************************************
*
* Head slams into mat
;From head slam - repeated head slam

 SUBR	und_break_face2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	2,U3CF3Q+FR1
	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off
	WL	ANI_SET_YVEL,80000h
	WL	4,U3CF3Q+FR2
	WL	4,U3CF3Q+FR3
	WL	4,U3CF3Q+FR4
	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	.word	ANI_WAITROLL
	WL	3,U3CF3Q+FR1
	WL	ANI_CHANGEANIM,und_getup_anim

 SUBR	und_break_face3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS

	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off
	WL	3,U3MS3Z+FR3
	WL	ANI_SET_YVEL,078000h
	WL	100,U3MS3Z+FR3
	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,und_getup_anim


* Head slams into mat
;From head slam

 SUBR	und_break_face_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	WL	2,U3CF3Q+FR1
	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off
	WL	ANI_SET_YVEL,40000h
	WL	4,U3CF3Q+FR2
	WL	4,U3CF3Q+FR3
	WL	4,U3CF3Q+FR4
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	2,U3CF3Q+FR1
	WL	4,U3CF3Q+FR2
	WL	4,U3CF3Q+FR3
	WL	4,U3CF3Q+FR4

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	2,U3CF3Q+FR1
	.word	ANI_WAITROLL

	WL	ANI_CHANGEANIM,und_getup_anim

#*****************************************************************************
*
* END OF BACK BROKEN SEQ.

 SUBR	und_backbroken_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
;	.word	ANI_DETACH

	.word	ANI_GRAVITY_OFF
	WL	5,U3BR3Z+FR3
	.word	ANI_GRAVITY_ON

	WL	ANI_SET_YVEL,070000h
	WLW	ANI_SET_ZVEL,20000h,AM_ABS

	WL	25,U3BR3Z+FR3

;	WL	4,U3BR3Z+FR4

	.word	ANI_XFLIP
	WL	4,U3CP3B+FR2

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_BOUNCE,2
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT

	WL	2,U3CP3B+FR2
	.word	ANI_DEBRIS,200,1,0,8,0		;%chance, tbl index, x,y,z off
	WL	2,U3CP3B+FR2
	WL	4,U3CP3B+FR3
	WL	4,U3CP3B+FR4
	WL	4,U3CP3B+FR5

	WL	4,U3CP3B+FR1

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

;No stars around head here...

	.word	ANI_DETACH

	WL	3,U3CP3B+FR1

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,und_getup_anim
;	.word	ANI_END

#*****************************************************************************

	.bss	#opp_xvel,32

 SUBR	und_3_fake_hold_anim
;Head hold when standing next to player
;No collisions possible
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold

	.word	ANI_STARTATTACK,AT_PUPPET,6
	WL	3,U4GH3A+FR1
	WL	3,U4GH3A+FR2
	WL	7,U4GH3A+FR3
	WL	ANI_GOTO,#missed

 SUBR	und_3_head_hold2_anim
;Head hold when standing next to player
;No collisions possible
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold

	.word	ANI_STARTATTACK,AT_PUPPET,6
	WL	3,U4GH3A+FR1
	WL	3,U4GH3A+FR2
	.word	ANI_ATTACK_ON, AMODE_PUPPET_HDGRAB,40-15,80,37+15,23 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,7,U4GH3A+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb
	WL	ANI_GOTO,#gothim

 SUBR	und_3_head_hold_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold

	.word	ANI_STARTATTACK,AT_LEAPING,6
	WL	3,U4GH3A+FR1
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 6,999,65,45,90000h,TGT_HEAD,56,105,0
	LEAPATOPP 9,999,40,45,90000h,TGT_HEAD,56,105,0

	WL	3,U4GH3A+FR2
	.word	ANI_ATTACK_ON, AMODE_PUPPET,40-15,80,37+15,23 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,6,U4GH3A+FR3
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb

#gothim
;got him
	.word	ANI_SETWORD,USR_VAR2,0
	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2

	.word	ANI_CLR_BUTCOUNT
	.ref	head_grab_time
	WL	ANI_CODE,head_grab_time

	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	WL	ANI_CODE,DO_NONO
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,1,U4GH3A+FR3,#puppet_tbl,0

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WWLLW	ANI_SUPERSLAVE2,4,U4GH3A+FR3,#puppet_tbl,0

	WWLLW	ANI_SUPERSLAVE2,4,U4GH3A+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,U4GH3A+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,U4GH3C+FR11,#puppet_tbl,3

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	1,U4GH3C+FR11

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WL	2,U4GH3A+FR3
	.word	ANI_ZEROVELS
	WL	ANI_SET_YVEL,30000h

	WL	3,U4GH3A+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,U4GH3A+FR2
	WL	3,U4GH3A+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END
#missed
	WL	ANI_CODE,CALL_MISSES

	WL	5,U4GH3A+FR3
	.word	ANI_ZERO_XZVELS
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,U4GH3A+FR3
	WL	3,U4GH3A+FR2
	WL	3,U4GH3A+FR1

	.word	ANI_FACEDOWN
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
 LWWW H4AH3A+FR1,70,7,0
 LWWW H3HB3A+FR3,78,-4,0
 LWWW H3HB3A+FR2,68,-17,0
 LWWW H3BF3A+FR1,48,-42,0
 .long 0
#Razor
 LWWW R4AH4C+FR3,76,6,0
 LWWW R3HB3A+FR3,77,-5,0
 LWWW R3HB3A+FR2,73,-27,0
 LWWW R3BF3A+FR1,52,-44,0
 .long 0
#Taker
 LWWW U4AH3A+FR2,64,16,0
 LWWW U4BF3A+FR2,66,8,0
 LWWW U4BF3A+FR3,45,-13,0
 LWWW U4BF3Z+FR5,56,-23,0
 .long 0
#Yokozuna
 LWWW Y4AE4A+FR2,82,-3,0
 LWWW Y4AM4A+FR1,88,-3,0
 LWWW Y4AM4A+FR2,79,-17,0
 LWWW Y3BF3A+FR1,55,-32,0
 .long 0
#Shawn
 LWWW S4AH3D+FR5,68,0,0
 LWWW S4AH3D+FR1,70,5,0
 LWWW S4BF3A+FR2,68,-15,0
 LWWW S3BF3A+FR1,36,-43,0
 .long 0
#BamBam
 LWWW B4AH4A+FR1,61,1,0
 LWWW B4BF3A+FR1,80,7,0
 LWWW B3HB3A+FR2,69,-30,0
 LWWW B3BF3C+FR5,51,-36,0
 .long 0
#Doink
 LWWW D3AH3B+FR1,59,3,0
 LWWW D3AK3A+FR3,59,6,0
 LWWW D3AK3A+FR2,72,-16,0
 LWWW D3BF3A+FR2,47,-42,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L4AH4B+FR3,62,-1,0
 LWWW L3BF3A+FR1,76,3,1
 LWWW L3BF3A+FR2,77,-21,1
 LWWW L3BF3B+FR5,53,-40,0
 .long 0

#headheld_tbl
	.long	hrt_3_head_held_anim
	.long	rzr_3_head_held_anim
	.long	und_3_head_held_anim
	.long	yok_3_head_held_anim
	.long	shn_3_head_held_anim
	.long	bam_3_head_held_anim
	.long	dnk_3_head_held_anim
	.long	0
	.long	lex_3_head_held_anim

;#*****************************************************************************
;*
;* CHAIR STUFF
;
; SUBR	und_pkup_chair_anim
;
;	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
;	.word	ANI_ZEROVELS
;	.word	ANI_SETSPEED,100h
;
;#lp
;	WL	4,U4WA4B+FR1
;	WL	4,U4WA4B+FR2
;	WL	4,U4WA4B+FR3
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR1,44,-10,1 ;image, x,y,zoff
;	WL	4,U4WA4B+FR4
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR1,47,15,1 ;image, x,y,zoff
;	WL	4,U4WA4B+FR5
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR2,53,65,1 ;image, x,y,zoff
;	WL	4,U4WA4B+FR6
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR3,45,109,1 ;image, x,y,zoff
;	WL	4,U4WA4B+FR7
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR4,16,139,1 ;image, x,y,zoff
;	WL	4,U4WA4B+FR8
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR4,5,155,1 ;image, x,y,zoff
;	WL	4,U4WA4B+FR9
;
;; .word ANI_SINGLESTEP
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR6,-33,146,1 ;image, x,y,zoff
;	WL	4,U3TBSM+FR3
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR5,-29,123,1 ;image, x,y,zoff
;	WL	4,U3TBSM+FR5
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR6,-22,142,1 ;image, x,y,zoff
;	WL	4,U3TBSM+FR6
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR7,11,151,1 ;image, x,y,zoff
;	WL	4,U3TBSM+FR7
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR9,77,80,1 ;image, x,y,zoff
;	WL	4,U3TBSM+FR8
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR10,63,35,1 ;image, x,y,zoff
;	WL	4,U3TBSM+FR9
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR9,77,62,1 ;image, x,y,zoff
;	WL	4,U3TBSM+FR10
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR8,62,114,1 ;image, x,y,zoff
;	WL	4,U3TBSM+FR11
;
;; .word ANI_SINGLESTEP
;	WLW	ANI_ATTCHIMAGE,0,0
;
;	WL	ANI_GOTO,#lp
;
******************************************************************************

	.end
