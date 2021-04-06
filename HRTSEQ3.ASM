**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		5/17/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"hrtseq3.asm"
	.title	"lockup stuff and special attacks"
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

	.include	"damage.equ"


******************************************************************************
* EXTERNAL REFERENCES

	;BAM BAM
	.ref	bam_3_head_held_anim,bam_break_neck2_anim
	.ref	bam_break_face_anim,bam_tossed_anim
	.ref	bam_head_hit2_anim
	.ref	B3GU4A,B3BF3C

	;DOINK
	.ref	dnk_3_head_held_anim,dnk_break_neck2_anim
	.ref	dnk_break_face_anim,dnk_tossed_anim
	.ref	dnk_head_hit2_anim
	.ref	D3HT3Z,D3BF3A

	;BRET
	.ref	hrt_hitonground_facedown_anim,hrt_stand4_anim
	.ref	hrt_flyout2_anim,hrt_faceup_getup_anim
	.ref	hrt_tossed_anim,hrt_break_neck2_anim
	.ref	hrt_4_head_hit2_anim
	.ref	H3GU4A,H3DU3A,H3BF3A

	;LEX
	.ref	lex_3_head_held_anim,lex_break_neck2_anim
	.ref	lex_break_face_anim,lex_tossed_anim
	.ref	lex_4_head_hit2_anim
	.ref	L3DU3A,L3BF3B

	;RAZOR
	.ref	rzr_3_head_held_anim,rzr_break_neck2_anim
	.ref	rzr_break_face_anim,rzr_tossed_anim
	.ref	rzr_4_head_hit2_anim
	.ref	R3GU4A,R3DU3B,R3BF3A

	;SHAWN
	.ref	shn_3_head_held_anim,shn_break_neck2_anim
	.ref	shn_break_face_anim,shn_tossed_anim
	.ref	shn_4_head_hit2_anim
	.ref	S3GU4A,S3BF3A

	;TAKER
	.ref	und_3_head_held_anim,und_break_neck2_anim
	.ref	und_break_face_anim,und_tossed_anim
	.ref	und_head_hit2_anim
	.ref	U3DU3B,U4BF3Z

	;YOKO
	.ref	yok_3_head_held_anim,yok_break_neck2_anim
	.ref	yok_break_face_anim,yok_tossed_anim
	.ref	yok_4_head_hit2_anim
	.ref	Y3GU2A,Y3BF3A

	;MISC
	.ref	CALL_MISSES,SMALL_BOUNCE,set_xdrift
	.ref	tgt_tbukl,tbukl_flip,HIT_THE_MAT,slaveanim_tbl,no_bk_xvel
	.ref	CALL_SPECIAL_MOVE,rope_command
	.ref	CALL_SETUP,rope_command,MAKE_HIM_SCREAM,GOUGE_SOUND
	.ref	triple_sound,get_opp_process,DO_GRUNT,MOVE_NAME_ANNC
	.ref	DO_NONO,DO_OTHERNONO,FIND_AND_KILL_ENDLESS
	.ref	CALL_NASTY_MOVE,CALL_ANI_AVERAGE_MOVE
	.ref	CALL_OTHER_AVERAGE
	.ref	CALL_THROWN_OUT,face_inside
	.ref	DO_COMBO_MESS,clear_opp_counts
	.ref	hrt_combo_knee_fall_anim
	.ref	hrt_combo_flying_kick_anim
	.REF	DO_EYES

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE


#*****************************************************************************
*
* HELD OVERHEAD ANIMATION

 SUBR	hrt_heldoh_anim

	.word	ANI_SETPLYRMODE,MODE_ATTACHED
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_SETSPEED,100h

	.word	ANI_SETWORD,USR_VAR1,0		;loop count

	WL	ANI_CODE,DO_OTHERNONO
#loop
	WL	3,H4MF4B+FR1
	WL	3,H4MF4B+FR2
	WL	3,H4MF4B+FR3
	WL	3,H4MF4B+FR4
	WL	3,H4MF4B+FR5
	WL	3,H4MF4B+FR6
	WL	3,H4MF4B+FR7
	WL	3,H4MF4B+FR8
	WL	3,H4MF4B+FR9

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

	WL	5,H4MF4B+FR1
	.word	ANI_OFFSET,-20,-50,0			;x,y,z
	WL	4,H3MS3Z+FR4
	WL	4,H3MS3Z+FR3
	WL	4,H3MS3Z+FR2
	WL	4,H3MS3Z+FR1
	.word	ANI_WAITHITGND
	WL	4,H2ST2A+FR1

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
* END OF NECK BROKEN SEQ.

 SUBR	hrt_neckbroken_anim

	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim

#*****************************************************************************
*
* POGO STICK HEAD CRUNCHER

 SUBR	hrt_pogo_anim

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* CLIMB UP TURNBUCKLES

#yoff	equ	20

 SUBR	hrt_climb_up_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SCROLL_CTRL,HRT_TBUKLY
	WL	3,H4HU4B+FR1
	WL	3,H4HU4B+FR2
	WL	ANI_CODE,tgt_tbukl
	.word	ANI_LEAPATPOS,20,200,8,-3,0	;#ticks,dist,xoff,yoff,zoff
	WL	20,H4HU4B+FR3

	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONTURNBKL
	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOGRAVITY|MODE_UNINT|MODE_OVERLAP
	.word	ANI_SHAKECORNER

	.word	ANI_SCROLL_CTRL,SC_RESTORE
	.word	ANI_OFFSET,0,#yoff,0
	WL	3,H4HU4B+FR4
	WL	3,H4HU4B+FR7

#repeat
	WL	4,H4SB4B+FR1
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR2
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR3
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR4
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR5
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR6
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR7
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR6
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR5
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR4
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR3
	WL	ANI_CODE,tbukl_flip
	WL	4,H4SB4B+FR2
	WL	ANI_CODE,tbukl_flip
	WL	ANI_GOTO,#repeat


#*****************************************************************************
*
* CLIMB DOWN TURNBUCKLES

 SUBR	hrt_climb_down_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SCROLL_CTRL,SC_RESTORE

	WL	ANI_CODE,face_inside

	.word	ANI_SHAKECORNER

	WL	3,H4HU4B+FR2

	WLW	ANI_SET_XVEL,10000h,AM_FACE_REL
	WLW	ANI_SET_ZVEL,-10000h,AM_FACE_REL
	WL	ANI_SET_YVEL,20000h

	WL	1,H4HU4B+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,H4HU4B+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* HIPTOSS
*
 SUBR	hrt_combo_hiptoss_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCONFINE
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,8

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,48,0,2
	WL	ANI_SET_YVEL,0

	.word	ANI_SET_RPTCOUNT,3	;5 times
#hiptoss_loop
	.word	ANI_CLR_BUTCOUNT
	WL	3,H3HT3X+FR1
	WL	3,H3HT3X+FR2

	.word	ANI_ATTACK_ON,AMODE_PUPPET,19,59,70,38
	WWL	ANI_WAITHITOPP,4,H3HT3X+FR3
	.word	ANI_ZERO_XZVELS
	WWL	ANI_WAITHITOPP,3,H3HT3X+FR3
	.word	ANI_ATTACK_OFF

	WL	ANI_IFBLOCKED,#missedbc
	WL	ANI_IFNOTSTATUS,#missedc

	WL	ANI_CODE,DO_GRUNT

	.word	ANI_ATTACHZ,0,0,2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.WORD	ANI_INC_COMBO

	WWLLW	ANI_SUPERSLAVE2,3,H3HT3X+FR3,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,H3HT3X+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,H3HT3X+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,H3HT3X+FR6,#puppet_tbl,3
	WWWL	ANI_IFROPE,RC_BACK,XTOSSDIST_CLOSE,#throw_him_outc
	WWLLW	ANI_SUPERSLAVE2,3,H3HT3X+FR7,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,H3HT3X+FR8,#puppet_tbl,5

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_DAMAGEOPP,D_HIPTOSS,RD_HIPTOSS

	WWLLW	ANI_SUPERSLAVE2,3,H3HT3X+FR9,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,3,H3HT3X+FR10,#puppet_tbl,7

;	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,SLAM_HIM
;	.WORD	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,090000h,0000h		;x,y,z vels
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_DETACH
	.word	ANI_FACE,MOVE_LEFT|MOVE_UP
	.word	ANI_XFLIP
	.word	ANI_ZEROVELS
	WL	3,H3HT3X+FR12

	WL	2,H3GU2A+FR7
	WL	3,H3GU2A+FR8
	WL	2,H3GU2A+FR9
	WL	3,H3GU2A+FR10

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IFNOT_RPTCOUNT,#check_exit
	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#exit_move
	WL	ANI_GOTO,#hiptoss_loop
#check_exit
	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#exit_move
	WL	ANI_CHANGEANIM,hrt_combo_pile_driver_anim
#exit_move
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#throw_him_outc

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_GOTO,#throw_him_out

#missedbc
	WL	10,H3HT3X+FR3
#missedc
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WL	15,H3HT3X+FR3

	WL	6,H3HT3X+FR2
	WL	6,H3HT3X+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

	.ref	hrt_slamnobounce_anim	;bret
	.ref	rzr_slamnobounce_anim	;razor
	.ref	und_slamnobounce_anim	;taker
	.ref	yok_slamnobounce_anim	;yoko
	.ref	shn_slamnobounce_anim	;shawn
	.ref	bam_slamnobounce_anim	;bam
	.ref	dnk_slamnobounce_anim	;doink
	.ref	und_slamnobounce_anim	;spare
	.ref	lex_slamnobounce_anim	;lex
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


 SUBR	hrt_hiptoss2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCONFINE
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,4

	WL	2,H3HT3X+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,60,55,40,90000h,TGT_CHEST,48,0,2
	WL	ANI_SET_YVEL,0

	WL	2,H3HT3X+FR2

	.word	ANI_ATTACK_ON,AMODE_PUPPET_TOSS,19,59,70,38
	WWL	ANI_WAITHITOPP,8,H3HT3X+FR3
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACK_OFF
	WL	ANI_GOTO,#cont

 SUBR	hrt_hiptoss_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCONFINE
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,4

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,48,0,2
	WL	ANI_SET_YVEL,0

	WL	2,H3HT3X+FR1
	WL	2,H3HT3X+FR2

	.word	ANI_ATTACK_ON,AMODE_PUPPET_TOSS,19,59,70,38
	WWL	ANI_WAITHITOPP,4,H3HT3X+FR3
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACK_OFF
	WL	4,H3HT3X+FR3
#cont

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb

#got_him
	.WORD	ANI_ADD_MOVE,MOVE_C_6,2,2
	.word	ANI_ATTACK_OFF
	.word	ANI_DRAW_NAME,10
	WL	ANI_CODE,CALL_SPECIAL_MOVE
	WL	ANI_CODE,DO_GRUNT

	.word	ANI_ATTACHZ,0,0,2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,3,H3HT3X+FR3,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,H3HT3X+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,H3HT3X+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,H3HT3X+FR6,#puppet_tbl,3
	WWWL	ANI_IFROPE,RC_BACK,XTOSSDIST_CLOSE,#throw_him_out
	WWLLW	ANI_SUPERSLAVE2,3,H3HT3X+FR7,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,H3HT3X+FR8,#puppet_tbl,5

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_DAMAGEOPP,D_HIPTOSS,RD_HIPTOSS

	WWLLW	ANI_SUPERSLAVE2,3,H3HT3X+FR9,#puppet_tbl,6


	WWLLW	ANI_SUPERSLAVE2,3,H3HT3X+FR10,#puppet_tbl,7

;	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#rollout_tbl
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_DETACH
	.word	ANI_FACE,MOVE_LEFT|MOVE_UP
	.word	ANI_XFLIP
	WL	ANI_SET_YVEL,30000h
	WL	1,H3HT3X+FR11
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,H3HT3X+FR12
	WL	3,H3GU2A+FR7
	WL	3,H3GU2A+FR8
	WL	3,H3GU2A+FR9
	WL	3,H3GU2A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#throw_him_out
	WL	ANI_CODE,CALL_THROWN_OUT
	WLLL	ANI_ATTACHVEL,-0A0000h,80000h,0h		;x,y,z
	WL	ANI_SLAVEANIM,#flyout_tbl
	WL	ANI_OPPOFFSET,#release_table
	.word	ANI_DETACH
	WL	4,H3HT3X+FR6
	WL	4,H3HT3X+FR7
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,15
	WL	4,H3HT3X+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,10

	WL	3,H3HT3X+FR9
	WL	3,H3HT3X+FR10
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	WL	2,H3HT3X+FR11
	WL	3,H3HT3X+FR12
	WL	3,H3GU2A+FR7
	WL	3,H3GU2A+FR8
	WL	3,H3GU2A+FR9
	WL	3,H3GU2A+FR10

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedb
;	.ref	ck_hiptoss
;	WL	ANI_CODE,ck_hiptoss
;	WL	ANI_IFNOTSTATUS,#got_him

	WL	10,H3HT3X+FR3
;Delay longer if 2nd hiptoss in quick succession!
	.ref	hiptoss_delay
	WL	ANI_CODE,hiptoss_delay
	WL	ANI_IFNOTSTATUS,#missed
	WL	24,H3HT3X+FR3
#missed
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WL	4,H3HT3X+FR3
	WL	2,H3HT3X+FR2
	WL	2,H3HT3X+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


;#xflip_tbl
;	.word	0 ;bret
;	.word	0 ;razor
;	.word	0 ;taker
;	.word	0 ;yoko
;	.word	0 ;shawn
;	.word	0 ;bam
;	.word	0 ;doink
;	.word	0 ;spare
;	.word	0 ;lex

#rollout_tbl
	.long	hrt_tossed_anim,rzr_tossed_anim
	.long	und_tossed_anim
	.long	yok_tossed_anim
	.long	shn_tossed_anim,bam_tossed_anim
	.long	dnk_tossed_anim,0,lex_tossed_anim


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
 LWWW H2AH3A+FR5,55,11,0
 LWWW H2AM3A+FR1,42,16,0
 LWWW H2AM3A+FR7,25,1,0
 LWWW H3FR3A+FR2,2,32,0
 LWWW H3FR3A+FR3,-17,62,0
 LWWW H3FR3A+FR4,-40,49,0
 LWWW H3FR3A+FR5,-69,4,0
 LWWW H2CP3A+FR8,-142,-30,1
 .long 0
#Razor
 LWWW R4AH4C+FR3,65,18,0
 LWWW R3TD3A+FR1,40,16,0
 LWWW R3TD3A+FR3,13,1,0
 LWWW R3TD3A+FR4,-4,22,0
 LWWW R3TD3A+FR5,-8,38,0
 LWWW R3TD3A+FR6,-30,37,0
 LWWW R3TD3A+FR7,-65,16,0
 LWWW R3GU2A+FR1,-159,-28,1
 .long 0
#Taker
 LWWW U3AE4A+FR1,69,24,0
 LWWW U4AM4C+FR4,41,13,0
 LWWW U3FH3A+FR1,28,7,1
 LWWW U3FH3A+FR2,2,36,1
 LWWW U3FH3A+FR3,-14,48,1
 LWWW U3FH3A+FR4,-45,48,1
 LWWW U3FH3A+FR5,-80,24,1
 LWWW U3CP3B+FR1,-161,-25,1
 .long 0
#Yokozuna
 LWWW Y4AE4A+FR1,66,12,0
 LWWW Y3FL3W+FR2,31,6,0
 LWWW Y3FL3W+FR3,5,8,0
 LWWW Y3FL3W+FR4,8,45,0
 LWWW Y3FL3W+FR5,-3,64,0
 LWWW Y3FL3W+FR6,-43,62,0
 LWWW Y3FL3W+FR7,-84,18,0
 LWWW Y3FD3A+FR7,-127,-3,0
 .long 0
#Shawn
 LWWW S3OS3X+FR2,43,9,1
 LWWW S3OS3X+FR4,9,8,1
 LWWW S3OS3X+FR5,-16,6,1
 LWWW S3OS3X+FR6,-14,54,1
 LWWW S3OS3X+FR7,-13,71,1
 LWWW S3OS3X+FR8,-27,61,1
 LWWW S3OS3X+FR9,-88,33,1
 LWWW S3OS3X+FR10,-136,-20,1
 .long 0
#BamBam
 LWWW B4AH4A+FR1,56,13,0
 LWWW B4TD3B+FR2,25,13,0
 LWWW B4TD3B+FR3,2,8,0
 LWWW B4TD3B+FR4,2,25,0
 LWWW B4TD3B+FR5,-17,59,0
 LWWW B4TD3B+FR6,-45,57,0
 LWWW B4TD3B+FR7,-79,29,0
 LWWW B4TD3B+FR9,-130,-10,0
 .long 0
#Doink
 LWWW D3AE3B+FR8,63,13,0
 LWWW D3PM4C+FR2,21,18,0
 LWWW D3OS3A+FR2,3,10,0
 LWWW D3OS3A+FR4,-17,34,0
 LWWW D3OS3A+FR5,-22,42,0
 LWWW D3OS3A+FR6,-42,36,0
 LWWW D3FD3E+FR2,-79,-6,0
 LWWW D3SA3A+FR2,-144,-21,1
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3FH3A+FR1,44,-8,0
 LWWW L3FH3A+FR2,39,-16,0
 LWWW L3FH3A+FR3,21,5,0
 LWWW L3FH3A+FR4,10,35,0
 LWWW L3FH3A+FR5,-11,46,0
 LWWW L3FH3A+FR6,-39,45,0
 LWWW L3FH3A+FR6,-63,14,0
 LWWW L3CP3B+FR1,-150,-23,1
 .long 0


#release_table
	;	X Y
	.word	0,0		;Bret
	.word	0,20		;Razor
	.word	0,0		;Taker
	.word	0,0		;Yokozuna
	.word	0,20		;Shawn
	.word	0,50		;BamBam
	.word	0,0		;Doink
	.word	0,0		;Adam
	.word	0,20		;Lex

#flyout_tbl
	.ref	hrt_flyout_anim
	.ref	rzr_flyout_anim
	.ref	und_flyout_anim
	.ref	shn_flyout_anim
	.ref	bam_flyout_anim
	.ref	dnk_flyout_anim
	.ref	lex_flyout_anim
	.ref	yok_flyout_anim

	.long	hrt_flyout_anim
	.long	rzr_flyout_anim
	.long	und_flyout_anim
	.long	yok_flyout_anim
	.long	shn_flyout_anim
	.long	bam_flyout_anim
	.long	dnk_flyout_anim
	.long	0
	.long	lex_flyout_anim

#*****************************************************************************

 SUBR	hrt_3_head_held_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_HEADHELD
	.word	ANI_SETFACING
	.word	ANI_SETWORD,USR_VAR1,0		;loop count

#loop
	WL	4,H3BF3A+FR1
	WL	4,H3BF3A+FR2
	WL	4,H3BF3A+FR3
	WL	4,H3BF3A+FR4
	WL	4,H3BF3A+FR5
	WL	4,H3BF3A+FR6
	WL	ANI_CODE,#inc_loop
	WL	ANI_IFNOTSTATUS,#loop

;Continue into break...

 SUBR	hrt_3_head_held_brk_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	ANI_CODE,FIND_AND_KILL_ENDLESS
	WLW	ANI_SET_XVEL,-38000h,AM_NEWFACE_REL
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	WL	4,H3HB3A+FR2
	.word	ANI_DETACH

;Standard #2 head hit from spin kick
	WL	3,H2AH3A+FR1
	WL	3,H2AH3A+FR2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,H2AH3A+FR3
	WL	3,H2AH3A+FR4
	WL	3,H2AH3A+FR5
	WL	3,H2AH3A+FR6

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

 SUBR	hrt_3_head_held_stand_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	3,H3HB3A+FR3
	WL	3,H1TL5A+FR3	;2.5
	.word	ANI_DETACH

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#******************************************************************************

 SUBR	hrt_4_taunt_anim

	.word	ANI_SETMODE,MODE_UNINT
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	4,H4SL4C+FR1
	WL	4,H4SL4C+FR2
	WL	4,H4SL4C+FR3
	WL	4,H4SL4C+FR4
	WL	4,H4SL4C+FR5
	WL	4,H4SL4C+FR6
	WL	4,H4SL4C+FR5
	WL	4,H4SL4C+FR4
	WL	4,H4SL4C+FR7
	WL	4,H4SL4C+FR8
	WL	4,H4SL4C+FR9
	WL	4,H4SL4C+FR8
	WL	4,H4SL4C+FR7

	WL	3,H4SL4C+FR4
	WL	3,H4SL4C+FR5
	WL	3,H4SL4C+FR6
	WL	3,H4SL4C+FR5
	WL	3,H4SL4C+FR4
	WL	3,H4SL4C+FR7
	WL	3,H4SL4C+FR3
	WL	3,H4SL4C+FR2
	WL	3,H4SL4C+FR1

;	.ref	set_taunt_bit
;	WL	ANI_CODE,set_taunt_bit

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,hrt_stand4_anim
	.word	ANI_END

#******************************************************************************

 SUBR	hrt_2_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_STARTATTACK,AT_PUPPET,15
	WL	1,H1TL5A+FR3	;2.5
	WL	1,H1TL5A+FR4	;3.5

 SUBR	hrt_4_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_STARTATTACK,AT_PUPPET,11
	WL	3,H4GH3Z+FR1

	LEAPATOPP 7,999,90,90,40000h,TGT_HEAD,10,6,-2

	WL	3,H4GH3Z+FR2
	WL	3,H4GH3Z+FR3

	.word	ANI_ATTACK_ON, AMODE_PUPPET2,18,0,25,18 ;mode,x,y,w,h
	WL	2,H4GH3Z+FR3
	.word	ANI_ZERO_XZVELS
	WL	3,H4GH3Z+FR3
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;got him
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	.word	ANI_CLR_BUTCOUNT
	WL	ANI_CODE,clear_opp_counts
	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	WL	ANI_CODE,DO_NONO
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SOUND,9bh			;neck break (5-7 ticks late)

	WWLLW	ANI_SUPERSLAVE2,3,H4GH3Z+FR4,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,H4GH3Z+FR5,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,H4GH3Z+FR6,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,H4GH3Z+FR7,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,H4GH3Z+FR8,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,H4GH3Z+FR8,#puppet_tbl,5

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	1,H4GH3Z+FR8
	.word	ANI_CLROPPMODE,MODE_GHOST

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	20,H4GH3Z+FR3
	WL	3,H4GH3Z+FR2
	WL	3,H4GH3Z+FR1

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
 LWWW H3GU4A+FR1,30,-27,0
 LWWW H3GU4A+FR3,52,-23,0
 LWWW H3DU3A+FR3,43,-22,1
 LWWW H3DU3A+FR4,48,-19,1
 LWWW H3DU3A+FR5,46,-29,1
 LWWW H3BF3A+FR1,49,-40,0
 .long 0
#Razor
 LWWW R3GU2A+FR3,37,-18,0
 LWWW R3GU4A+FR3,50,-17,0
 LWWW R3GU4A+FR5,52,-25,0
 LWWW R3DU3B+FR2,51,-33,1
 LWWW R3DU3B+FR4,53,-29,1
 LWWW R3BF3A+FR1,52,-42,0
 .long 0
#Taker
 LWWW U3DU3B+FR2,30,-19,1
 LWWW U3DU3B+FR5,48,-13,1
 LWWW U3DU3B+FR6,52,-20,1
 LWWW U3DU3B+FR8,42,-23,1
 LWWW U3DU3B+FR10,48,-22,1
 LWWW U4BF3Z+FR5,48,-21,0
 .long 0
#Yokozuna
 LWWW Y3GU2A+FR1,35,-13,0
 LWWW Y3GU2A+FR3,55,-4,0
 LWWW Y3GU2A+FR6,34,-20,0
 LWWW Y3GU2A+FR8,47,-32,0
 LWWW Y3GU2A+FR11,52,-33,0
 LWWW Y3BF3A+FR1,48,-30,0
 .long 0
#Shawn
 LWWW S3GU2A+FR1,38,-21,0
 LWWW S3GU4A+FR2,45,-15,0
 LWWW S3GU4A+FR4,51,-27,0
 LWWW S3GU4A+FR5,51,-32,0
 LWWW S3GU4A+FR7,51,-33,0
 LWWW S3BF3A+FR1,35,-41,0
 .long 0
#BamBam
 LWWW B3GU4A+FR3,36,-17,0
 LWWW B3GU4A+FR5,55,-14,0
 LWWW B3GU4A+FR6,46,-18,0
 LWWW B3GU4A+FR7,45,-32,0
 LWWW B3GU4A+FR9,48,-28,0
 LWWW B3BF3C+FR5,54,-34,0
 .long 0
#Doink
 LWWW D3GU4A+FR2,33,-24,0
 LWWW D3GU4A+FR4,40,-24,0
 LWWW D3GU4A+FR5,36,-18,0
 LWWW D3GU4A+FR6,43,-27,0
 LWWW D3GU4A+FR7,53,-39,0
 LWWW D3BF3A+FR2,52,-40,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3GU4A+FR1,38,-21,0
 LWWW L3DU3A+FR4,30,-11,1
 LWWW L3DU3A+FR6,33,-22,1
 LWWW L3DU3A+FR7,43,-23,1
 LWWW L3DU3A+FR9,49,-31,1
 LWWW L3BF3B+FR5,48,-38,0
 .long 0

#*****************************************************************************
*
* Head slams into mat
;From head slam - repeated head slam

 SUBR	hrt_break_face2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS

	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off

	WL	2,H3MS3X+FR5		;Face down
	WL	ANI_SET_YVEL,80000h
	WL	3,H3MS3X+FR2
	WL	3,H3MS3X+FR3
	WL	3,H3MS3X+FR4
	WL	3,H3MS3X+FR5
	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	.word	ANI_WAITROLL
	WL	3,H3MS3X+FR5		;Face down
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim
	

 SUBR	hrt_break_face3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS

	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off
	WL	3,H3MS3Z+FR4
	WL	ANI_SET_YVEL,078000h
	WL	100,H3MS3Z+FR4
	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim
	

* Head slams into mat
;From head slam

 SUBR	hrt_break_face_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS

	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off

	WL	2,H3MS3X+FR5		;Face down
	WL	ANI_SET_YVEL,40000h
	WL	3,H3MS3X+FR2
	WL	3,H3MS3X+FR3
	WL	3,H3MS3X+FR4
	WL	3,H3MS3X+FR5
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,H3MS3X+FR2
	WL	3,H3MS3X+FR3
	WL	3,H3MS3X+FR4
	WL	3,H3MS3X+FR5

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	3,H3MS3X+FR5
	.word	ANI_WAITROLL

	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim

#*****************************************************************************

	.bss	#opp_xvel,32

 SUBR	hrt_3_fake_hold_anim
;Head hold when standing next to player
;No collisions possible
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold

	.word	ANI_STARTATTACK,AT_PUPPET,6
	WL	3,H4GH3C+FR1
	WL	3,H4GH3C+FR2
	WL	3,H4GH3C+FR3
	WL	ANI_GOTO,#missed

 SUBR	hrt_3_head_hold2_anim
;Head hold when standing next to player
;No collisions possible
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold

	.word	ANI_STARTATTACK,AT_PUPPET,6
	WL	3,H4GH3C+FR1
	WL	3,H4GH3C+FR2
	.word	ANI_ATTACK_ON, AMODE_PUPPET_HDGRAB,40-20,80,37+20,23 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,3,H4GH3C+FR3
	WWL	ANI_WAITHITOPP,4,H4GH3C+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb
	WL	ANI_GOTO,#gothim

 SUBR	hrt_3_head_hold_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold

	.word	ANI_STARTATTACK,AT_PUPPET,6
	WL	3,H4GH3C+FR1
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 6,999,65,45,90000h,TGT_HEAD,56,93,0
	LEAPATOPP 9,999,40,45,90000h,TGT_HEAD,56,93,0
	WL	3,H4GH3C+FR2

	.word	ANI_ATTACK_ON, AMODE_PUPPET,40-20,80,37+20,23 ;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,3,H4GH3C+FR3
	WWL	ANI_WAITHITOPP,3,H4GH3C+FR5

	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb

#gothim
	.word	ANI_SETWORD,USR_VAR2,0

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	.word	ANI_CLR_BUTCOUNT
	.ref	head_grab_time
	WL	ANI_CODE,head_grab_time

	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	WL	ANI_CODE,DO_NONO
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,1,H4GH3C+FR5,#puppet_tbl,0

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WWLLW	ANI_SUPERSLAVE2,4,H4GH3C+FR5,#puppet_tbl,0

	WWLLW	ANI_SUPERSLAVE2,4,H4GH3C+FR6,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,H4GH3C+FR7,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,H4GH3Z+FR8,#puppet_tbl,3

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	1,H4GH3Z+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	.word	ANI_ZEROVELS
	WL	ANI_SET_YVEL,30000h

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,H4GH3C+FR3
	WL	3,H4GH3C+FR2
	WL	3,H4GH3C+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END
#missed
	WL	ANI_CODE,CALL_MISSES

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,H4GH3C+FR3
	WL	3,H4GH3C+FR2
	WL	3,H4GH3C+FR1

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
 LWWW H4AH3A+FR1,76,17,0
 LWWW H3HB3A+FR3,81,-1,0
 LWWW H3HB3A+FR2,71,-11,0
 LWWW H3BF3A+FR1,45,-40,0
 .long 0
#Razor
 LWWW R4AH4C+FR3,77,15,0
 LWWW R3HB3A+FR3,79,-2,0
 LWWW R3HB3A+FR2,76,-21,0
 LWWW R3BF3A+FR1,49,-42,0
 .long 0
#Taker
 LWWW U4AH3A+FR2,70,25,0
 LWWW U4BF3A+FR2,71,11,0
 LWWW U4BF3A+FR3,46,-8,0
 LWWW U4BF3Z+FR5,51,-21,0
 .long 0
#Yokozuna
 LWWW Y4AE4A+FR2,91,6,0
 LWWW Y4AM4A+FR1,90,-1,0
 LWWW Y4AM4A+FR2,80,-11,0
 LWWW Y3BF3A+FR1,49,-30,0
 .long 0
#Shawn
 LWWW S4AH3D+FR5,77,8,0
 LWWW S4AH3D+FR1,74,6,0
 LWWW S4BF3A+FR2,69,-11,0
 LWWW S3BF3A+FR1,35,-41,0
 .long 0
#BamBam
 LWWW B4AH4A+FR1,72,10,0
 LWWW B4BF3A+FR1,85,9,0
 LWWW B3HB3A+FR2,74,-25,0
 LWWW B3BF3C+FR5,52,-34,0
 .long 0
#Doink
 LWWW D3AH3B+FR1,65,12,0
 LWWW D3AK3A+FR3,68,9,0
 LWWW D3AK3A+FR2,77,-11,0
 LWWW D3BF3A+FR2,47,-40,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L4AH4B+FR3,70,9,0
 LWWW L3BF3A+FR1,81,4,1
 LWWW L3BF3A+FR2,77,-16,1
 LWWW L3BF3B+FR5,46,-38,0
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

#*****************************************************************************
*
* DDT (FROM HEAD HOLD) - and standing - no xvel

 SUBR	hrt_hh_2_ddt_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,8

	WL	2,H1TL5A+FR5

	.word	ANI_ATTACK_ON, AMODE_PUPPET,32,15,45,41 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,H1TL5A+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	.word	ANI_SOUND,82h			;Effort grunt

;got him
	.word	ANI_ATTACHZ,0,0,2		;put opp in front of attacker

	WL	ANI_SLAVEANIM,slaveanim_tbl
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,3,H1TL5A+FR5,#puppet_tbl,0
	.word	ANI_XFLIP
	WWLLW	ANI_SUPERSLAVE2,3,H1TL5A+FR6,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,H1TL5A+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,10,H3DD3Z+FR1,#puppet_tbl,3

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	WL	ANI_CODE,draw_ddt_name

	WWL	ANI_SETLONG,OBJ_GRAVITY,0a000h
	WL	ANI_SET_YVEL,70000h

	WWLLW	ANI_SUPERSLAVE2,4,H3DD3Z+FR2,#puppet_tbl,4
	.word	ANI_OFFSET,0,53,0	;x,y,z
	WWLLW	ANI_SUPERSLAVE2,4,H3DD3Z+FR3,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,4,H3DD3Z+FR4,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,4,H3DD3Z+FR5,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,1,H3DD3Z+FR6,#puppet_tbl,8

	.word	ANI_WAITHITGND
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_HIPTOSS,RD_HIPTOSS

	WWLLW	ANI_SUPERSLAVE2,4,H3DD3Z+FR7,#puppet_tbl,9
;	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#break_face_tbl

	.word	ANI_SETOPP_PLYRMODE,MODE_ONGROUND
	.word	ANI_DETACH

	WL	5,H3UC3X+FR9
	WL	5,H3UC3X+FR10

	.word	ANI_XFLIP
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim

#missed
	.word	ANI_XFLIP
	WL	4,H1TL5A+FR6
	WL	4,H1TL5A+FR5
	WL	4,H3DD3Z+FR1

	WWL	ANI_SETLONG,OBJ_GRAVITY,0a000h
	WL	ANI_SET_YVEL,30000h

	WL	4,H3DD3Z+FR2
	.word	ANI_OFFSET,0,53,0	;x,y,z
	WL	4,H3DD3Z+FR3
	WL	4,H3DD3Z+FR4
	WL	4,H3DD3Z+FR5
	WL	1,H3DD3Z+FR6

	.word	ANI_WAITHITGND
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY

;impact
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,20

	WL	4,H3DD3Z+FR7
	WL	4,H3UC3X+FR9
	WL	4,H3UC3X+FR10

	.word	ANI_XFLIP

	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim
	.word	ANI_END

#break_face_tbl
	.long	hrt_break_face_anim,rzr_break_face_anim
	.long	und_break_face_anim
	.long	yok_break_face_anim
	.long	shn_break_face_anim,bam_break_face_anim
	.long	dnk_break_face_anim,0,lex_break_face_anim

draw_ddt_name
;Draw hip toss message
	CREATE	MESSAGE_PID,MOVE_NAME_ANNC
	move	a13,*a0(PA8),L
	movk	16,a14
	move	a14,*a0(PA10),L
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
#Bret
 LWWW H3GU4A+FR10,43,-24,0

 LWWW H4AM3A+FR3,-45,-37,0
 LWWW H4AM3A+FR5,-45,-41,0
 LWWW H4AM3A+FR6,-43,-33,0
 LWWW H3MS3Z+FR1,-73,-16,0
 LWWW H3MS3Z+FR2,-84,-19,0
 LWWW H3MS3Z+FR3,-85,-20,0
 LWWW H3MS3Z+FR4,-85,-20,0
 LWWW H3MS3Z+FR5,-93,-17,0
 LWWW H3MS3Z+FR6,-65,-21,0
 .long 0
#Razor
 LWWW R4AM3X+FR2,46-10,-9,0

 LWWW R4AM3X+FR4,-47,-24,0
 LWWW R4AM3X+FR5,-48,-20,0
 LWWW R4AM3X+FR6,-47,-14,0
 LWWW R3MS3Z+FR1,-53,-15,0
 LWWW R3MS3Z+FR2,-67,-16,0
 LWWW R3MS3Z+FR3,-85,-22,0
 LWWW R3MS3Z+FR4,-96,-21,0
 LWWW R3MS3Z+FR5,-98,-25,0
 LWWW R3MS3Z+FR6,-92,-42,0
 .long 0
#Taker
 LWWW U3GD2A+FR8,50-13,-19,0

 LWWW U4BF3Z+FR2,-56,-32,0
 LWWW U4BF3Z+FR1,-59,-34,0
 LWWW U4BF3A+FR3,-60,-12,0
 LWWW U3MS3Z+FR1,-70,-3,0
 LWWW U3MS3Z+FR2,-85,-7,0
 LWWW U3MS3Z+FR3,-97,-25,0
 LWWW U3MS3Z+FR4,-99,-25,0
 LWWW U3MS3Z+FR5,-106,-26,0
 LWWW U3MS3Z+FR6,-96,-31,0
 .long 0
#Yokozuna
 LWWW Y4AM4A+FR7,44-12,-20,0

 LWWW Y4AM4A+FR5,-54,-24,0
 LWWW Y4AM4A+FR4,-58,-26,0
 LWWW Y4AM4A+FR3,-56,-25,0
 LWWW Y3MS3Z+FR1,-57,-24,0
 LWWW Y3MS3Z+FR2,-73,-4,0
 LWWW Y3MS3Z+FR3,-94,-10,0
 LWWW Y3MS3Z+FR4,-93,-13,0
 LWWW Y3MS3Z+FR5,-94,-21,0
 LWWW Y3MS3Z+FR6,-94,-41,0
 .long 0
#Shawn
 LWWW S4AM3A+FR5,44-17,-41,0

 LWWW S4AM3A+FR6,-48,-46,0
 LWWW S4AM3A+FR7,-48,-39,0
 LWWW S4AM3A+FR8,-46,-21,0
 LWWW S3MS3Z+FR1,-55,-22,0
 LWWW S3MS3Z+FR2,-76,-18,0
 LWWW S3MS3Z+FR3,-84,-18,0
 LWWW S3MS3Z+FR4,-87,-19,0
 LWWW S3MS3Z+FR5,-93,-22,0
 LWWW S3MS3Z+FR6,-97,-54,0
 .long 0
#BamBam
 LWWW B4AM4A+FR2,50-16,-21,0

 LWWW B4AM4A+FR3,-47,-29,0
 LWWW B4AM4A+FR6,-50,-31,0
 LWWW B4AM4A+FR7,-50,-25,0
 LWWW B3MS3Z+FR1,-69,-11,0
 LWWW B3MS3Z+FR2,-91,-18,0
 LWWW B3MS3Z+FR3,-104,-25,0
 LWWW B3MS3Z+FR4,-106,-14,0
 LWWW B3MS3Z+FR5,-103,-2,0
 LWWW B3MS3Z+FR6,-92,-13,0
 .long 0
#Doink
 LWWW D3AM3A+FR4,53-17,-21,0

 LWWW D3AM3A+FR5,-49,-34,0
 LWWW D3PP3A+FR3,-55,-40,0
 LWWW D3PP3A+FR2,-55,-24,0
 LWWW D3GS3X+FR1,-49,-22,0
 LWWW D3GS3X+FR3,-58,-19,0
 LWWW D3GS3X+FR4,-70,-19,0
 LWWW D3GS3X+FR5,-68,-23,0
 LWWW D3GS3X+FR7,-76,-25,0
 LWWW D3GS3X+FR8,-103,-53,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3BF3A+FR2,60-23,-18,1

 LWWW L3BF3A+FR3,-61,-34,1
 LWWW L4GH3B+FR2,-52,-34,0
 LWWW L4GH3B+FR3,-52,-25,0
 LWWW L3MS3Z+FR1,-65,-15,0
 LWWW L3MS3Z+FR2,-65,-15,0
 LWWW L3MS3Z+FR3,-74,-22,0
 LWWW L3MS3Z+FR4,-82,-26,0
 LWWW L3MS3Z+FR5,-94,-29,0
 LWWW L3MS3Z+FR6,-96,-46,0
 .long 0


#*****************************************************************************
*
* RUNNING DDT
 SUBR	hrt_combo_running_ddt_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,8

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 7,120,120,40,90000h,TGT_HEAD,-10,38+53,0
	WL	ANI_CODE,no_bk_xvel

	WL	3,H3DD3Z+FR1
	WL	4,H3DD3Z+FR2

	.word	ANI_OFFSET,0,53,0	;x,y,z

	.word	ANI_ATTACK_ON, AMODE_PUPPET,-27,26,38,49 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,H3DD3Z+FR3
	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	WL	ANI_IFNOTSTATUS,#missedc
	WL	ANI_IFBLOCKED,#missedbc
	.WORD	ANI_INC_COMBO

	WL	ANI_CODE,#half_vels

	.word	ANI_ATTACHZ,0,0,2	;opp in front
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,3,H3DD3Z+FR3,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,H3DD3Z+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,H3DD3Z+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,H3DD3Z+FR6,#puppet_tbl,3

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	;impact
	WL	ANI_CODE,CALL_SPECIAL_MOVE
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_DAMAGEOPP,D_HIPTOSS,RD_HIPTOSS


	WWLLW	ANI_SUPERSLAVE2,4,H3DD3Z+FR7,#puppet_tbl,4
	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#break_face_tbl
	WLLL	ANI_SETOPPVELS,-10000h,40000h,0	;x,y,z vels
	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WL	8,H3UC3X+FR9
	WL	8,H3UC3X+FR10

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim

#missedbc
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_XVEL,-20000h,AM_FACE_REL
#missedc
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_CODE,CALL_MISSES
	WL	4,H3DD3Z+FR3
	WL	4,H3DD3Z+FR4
	WL	4,H3DD3Z+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WL	1,H3DD3Z+FR6
	WL	2,H3DD3Z+FR7
	WL	4,H3UC3X+FR9
	WL	4,H3UC3X+FR10

	.word	ANI_XFLIP
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim


 SUBR	hrt_running_ddt_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_LEAPING,12

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 12,999,120,45,90000h,TGT_HEAD,-10,91,0
	WL	ANI_CODE,no_bk_xvel

	WL	6,H3DD3Z+FR1
	WL	6,H3DD3Z+FR2

	.word	ANI_OFFSET,0,53,0	;x,y,z

	.word	ANI_ATTACK_ON, AMODE_PUPPET,-27,26,58,49 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,H3DD3Z+FR3
	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb

	WL	ANI_CODE,#half_vels

	.word	ANI_ATTACHZ,0,0,2	;opp in front
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,3,H3DD3Z+FR3,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,H3DD3Z+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,H3DD3Z+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,H3DD3Z+FR6,#puppet_tbl,3

	WL	ANI_CODE,draw_ddt_name

	.word	ANI_WAITHITGND
	.word	ANI_ZERO_XZVELS

	;impact
	WL	ANI_CODE,CALL_SPECIAL_MOVE
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_HIPTOSS,RD_HIPTOSS

	WWLLW	ANI_SUPERSLAVE2,4,H3DD3Z+FR7,#puppet_tbl,4
	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#break_face_tbl
	WLLL	ANI_SETOPPVELS,-10000h,40000h,0	;x,y,z vels
	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZERO_XZVELS

	WL	6,H3UC3X+FR9
	WL	6,H3UC3X+FR10

	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim

#missedb
	WLW	ANI_SET_ZVEL,0,AM_ABS
	WL	ANI_SET_YVEL,20000h
	WLW	ANI_SET_XVEL,-30000h,AM_FACE_REL
	WLLL	ANI_SETOPPVELS,30000h,20000h,0	;x,y,z vels
#missed
	WL	ANI_CODE,CALL_MISSES
	WL	4,H3DD3Z+FR3
	WL	4,H3DD3Z+FR4
	WL	4,H3DD3Z+FR5
	.word	ANI_WAITHITGND
	.word	ANI_SHAKER,30
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	WL	1,H3DD3Z+FR6
	WL	2,H3DD3Z+FR7
	WL	4,H3UC3X+FR9
	WL	4,H3UC3X+FR10

	.word	ANI_XFLIP
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,hrt_faceup_getup_anim

#half_vels
	move	*a13(OBJ_XVEL),a0,L
	sra	1,a0
	move	a0,*a13(OBJ_XVEL),L

	clr	a0
	movi	[2,0],a0
	move	a0,*a13(OBJ_YVEL),L
	rets

#xflip_tbl
	.word	0 ;bret
	.word	0 ;razor
	.word	0 ;taker
	.word	1 ;yoko
	.word	0 ;shawn
	.word	1 ;bam
	.word	0 ;doink
	.word	0 ;spare
	.word	0 ;lex

#break_face_tbl
	.long	hrt_tossed_anim,rzr_tossed_anim
	.long	und_tossed_anim
	.long	yok_tossed_anim
	.long	shn_tossed_anim,bam_tossed_anim
	.long	dnk_tossed_anim,0,lex_tossed_anim

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
 LWWW H3UC3X+FR1,-28,-9,0
 LWWW H3UC3X+FR2,-62,-2,0
 LWWW H3UC3X+FR3,-70,4,0
 LWWW H3UC3X+FR4,-62,4,0
 LWWW H2CP3A+FR1,-69,-39,1
 .long 0
#Razor
 LWWW R3FD3B+FR1,-36,-4,0
 LWWW R3FD3B+FR2,-62,1,0
 LWWW R3FD3B+FR4,-80,14,0
 LWWW R3FD3B+FR5,-70,15,0
 LWWW R3AM3D+FR2,-89,-42,1
 .long 0
#Taker
 LWWW U3FD3X+FR1,-30,-5,1
 LWWW U3FD3X+FR2,-43,-2,1
 LWWW U3FD3X+FR3,-50,4,1
 LWWW U3FD3X+FR4,-61,8,1
 LWWW U3CP3B+FR3,-95,-28,1
 .long 0
#Yokozuna
 LWWW Y3FD3A+FR1,-34,-11,0
 LWWW Y3FD3A+FR2,-69,16,0
 LWWW Y3FD3A+FR3,-62,17,0
 LWWW Y3FD3A+FR4,-67,11,0
 LWWW Y3CP3B+FR1,-74,-38,1
 .long 0
#Shawn
 LWWW S3UC3X+FR1,-40,-3,0
 LWWW S3UC3X+FR2,-58,-3,0
 LWWW S3UC3X+FR4,-69,-4,0
 LWWW S3UC3X+FR5,-58,9,0
 LWWW S3CP3B+FR2,-83,-37,1
 .long 0
#BamBam
 LWWW B4UC3B+FR1,-43,4,0
 LWWW B4UC3B+FR2,-58,-1,0
 LWWW B4UC3B+FR3,-76,-1,0
 LWWW B4UC3B+FR4,-82,-4,0
 LWWW B3CP3B+FR2,-84,-7,1
 .long 0
#Doink
 LWWW D3UC3A+FR2,-47,-2,0
 LWWW D3UC3A+FR3,-57,6,0
 LWWW D3UC3A+FR4,-75,8,0
 LWWW D3UC3A+FR5,-75,3,0
 LWWW D3SA3A+FR4,-79,-42,1
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3UC3X+FR2,-47,-14,0
 LWWW L3UC3X+FR3,-76,-10,0
 LWWW L3CP3X+FR2,-81,-4,1
 LWWW L3CP3X+FR3,-73,8,1
 LWWW L3CP3X+FR1,-90,-52,1
 .long 0

#*****************************************************************************
*
* PILEDRIVER

 SUBR	hrt_combo_pile_driver_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_ATTACK_ON,AMODE_PUPPET,-12,44,90,66	;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,4,H3PG3A+FR1
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missedc

	.word	ANI_SET_RPTCOUNT,3	;5 times
;got him
	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SOUND,82h			;Effort grunt

	WWLLW	ANI_SUPERSLAVE2,4,H3PG3A+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,H3PG3A+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,10,H3PG3A+FR3,#puppet_tbl,2

	WWLLW	ANI_SUPERSLAVE2,4,H3PG3A+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,H3ZZ3T+FR1,#puppet_tbl,4

#pile_loop
	.word	ANI_CLR_BUTCOUNT
	WL	ANI_SET_YVEL,70000h
	WL	ANI_CODE,set_xdrift
	WWLLW	ANI_SUPERSLAVE2,4,H3ZZ3T+FR2,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,4,H3ZZ3T+FR3,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,4,H3ZZ3T+FR4,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,4,H3ZZ3T+FR5,#puppet_tbl,8

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_PILEDRIVER,RD_PILEDRIVER

	WWLLW	ANI_SUPERSLAVE2,2,H3ZZ3T+FR6,#puppet_tbl,9
	WWLLW	ANI_SUPERSLAVE2,4,H3ZZ3T+FR7,#puppet_tbl,10
	.word	ANI_SOUND,9Bh			;neck break (5-7 ticks late)
	WWLLW	ANI_SUPERSLAVE2,4,H3ZZ3T+FR8,#puppet_tbl,11

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#pile_loop

#exit_move
	WL	ANI_CODE,#set_opp_xflip

	WL	ANI_SLAVEANIM,#rollout_tbl
	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_DETACH

	WL	4,H3ZZ3T+FR9
	WL	4,H3ZZ3T+FR10
	WL	4,H3PG3A+FR1

	.WORD	ANI_INC_COMBO
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedc
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

****************************************

 SUBR	hrt_3_pile_driver_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_ATTACK_ON,AMODE_PUPPET,-12,44,80,36	;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,4,H3PG3A+FR1
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;got him

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SOUND,82h			;Effort grunt

	WWLLW	ANI_SUPERSLAVE2,4,H3PG3A+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,H3PG3A+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,10,H3PG3A+FR3,#puppet_tbl,2

	WWLLW	ANI_SUPERSLAVE2,4,H3PG3A+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,H3ZZ3T+FR1,#puppet_tbl,4

	WL	ANI_SET_YVEL,70000h
	WL	ANI_CODE,set_xdrift
	WWLLW	ANI_SUPERSLAVE2,4,H3ZZ3T+FR2,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,4,H3ZZ3T+FR3,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,4,H3ZZ3T+FR4,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,4,H3ZZ3T+FR5,#puppet_tbl,8

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.WORD	ANI_DRAW_NAME,35
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_PILEDRIVER,RD_PILEDRIVER
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	.word	ANI_ATTACHZ,0,0,2		;x & y don't matter.

	WWLLW	ANI_SUPERSLAVE2,2,H3ZZ3T+FR6,#puppet_tbl,9
	WWLLW	ANI_SUPERSLAVE2,4,H3ZZ3T+FR7,#puppet_tbl,10
	.word	ANI_SOUND,9Bh			;neck break (5-7 ticks late)
	WWLLW	ANI_SUPERSLAVE2,8,H3ZZ3T+FR8,#puppet_tbl,11

	WL	ANI_CODE,#set_opp_xflip

	WL	ANI_SLAVEANIM,#rollout_tbl
	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_DETACH

	WL	12,H3ZZ3T+FR8
	WL	3,H3ZZ3T+FR9
	WL	3,H3ZZ3T+FR10
	WL	3,H3PG3A+FR1

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#set_opp_xflip
	move	*a13(ATTACH_PROC),a0,L
	move	*a0(OBJ_CONTROL),a14
	xori	M_FLIPH,a14
	move	a14,*a0(OBJ_CONTROL)

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

#Bret
 LWWW H4AM3A+FR5,51,-35,0
 LWWW H3BF3A+FR3,18,-29,0
 LWWW H3PP3X+FR1,13,-25,0
 LWWW H3PP3X+FR2,2,13,0
 LWWW H3PP3X+FR3,1,36,0
 LWWW H3PP3X+FR4,5,42,0
 LWWW H3PP3X+FR5,12,51,0
 LWWW H3PP3X+FR6,14,56,0
 LWWW H3PP3X+FR6,28,58,0
 LWWW H3PP3X+FR6,37,55,0
 LWWW H3PP3X+FR7,37,27,0
 LWWW H3PP3X+FR8,32,2,0
#Razor
 LWWW R4AM4B+FR5,40,-31,0
 LWWW R3BF3A+FR9,12,-29,0
 LWWW R3GP3Z+FR1,8,-19,0
 LWWW R3GP3Z+FR2,9,-12,0
 LWWW R3GP3Z+FR3,7,27,0
 LWWW R3GP3Z+FR4,18,45,0
 LWWW R3GP3Z+FR5,22,53,0
 LWWW R3GP3Z+FR6,29,54,0
 LWWW R3GP3Z+FR6,42,52,0
 LWWW R3GP3Z+FR6,51,51,0
 LWWW R3GP3Z+FR7,36,42,0
 LWWW R3GP3Z+FR8,30,-3,0
#Taker
 LWWW U4MP4A+FR6,40,-9,0
 LWWW U4BF3Z+FR1,16,-21,0
 LWWW U3PP3X+FR1,15,-16,1
 LWWW U3PP3X+FR2,13,-8,1
 LWWW U3PP3X+FR3,4,-4,1
 LWWW U3PP3X+FR4,0,11,1
 LWWW U3PP3X+FR5,14,40,1
 LWWW U3PP3X+FR6,26,66,1
 LWWW U3PP3X+FR6,40,67,1
 LWWW U3PP3X+FR6,49,66,1
 LWWW U3GP3X+FR1,38,20,1
 LWWW U3GP3X+FR2,41,-10,1
#Yokozuna
 LWWW Y4AM4A+FR4,52,-25,0
 LWWW Y3BF3A+FR11,12,-21,0
 LWWW Y3PP3Q+FR1,12,-15,0
 LWWW Y3PP3Q+FR2,11,-11,0
 LWWW Y3PP3Q+FR3,14,-6,0
 LWWW Y3PP3Q+FR4,20,2,0
 LWWW Y3PP3Q+FR6,14,19,0
 LWWW Y3PP3Q+FR7,22,23,0
 LWWW Y3PP3Q+FR7,36,25,0
 LWWW Y3PP3Q+FR7,45,23,0
 LWWW Y3FD3N+FR3,37,14,0
 LWWW Y3FD3N+FR4,39,25,0
#Shawn
 LWWW S4BF3A+FR5,32,-39,0
 LWWW S3BF3A+FR5,0,-33,0
 LWWW S3GP3X+FR1,10,-24,0
 LWWW S3GP3X+FR2,8,-15,0
 LWWW S3GP3X+FR3,13,4,0
 LWWW S3GP3X+FR4,18,43,0
 LWWW S3GP3X+FR5,20,46,0
 LWWW S3OS3X+FR8,29,39,1
 LWWW S3OS3X+FR8,43,40,1
 LWWW S3OS3X+FR8,52,40,1
 LWWW S3FD3X+FR2,44,31,0
 LWWW S3GP3X+FR6,40,0,0
#BamBam
 LWWW B3BF3C+FR5,42,-28,0
 LWWW B4AM4A+FR5,15,-24,0
 LWWW B3PP3Q+FR1,10,-23,0
 LWWW B3PP3Q+FR2,10,-7,0
 LWWW B3PP3Q+FR3,14,15,0
 LWWW B3PP3Q+FR4,19,39,0
 LWWW B3PP3Q+FR5,19,48,0
 LWWW B3PP3Q+FR6,20,52,0
 LWWW B3PP3Q+FR6,34,55,0
 LWWW B3PP3Q+FR6,43,59,0
 LWWW B3PP3Q+FR7,35,34,0
 LWWW B3FD3C+FR1,27,7,0
#Doink
 LWWW D3HT3Z+FR1,32,-34,1
 LWWW D3BF3A+FR1,9,-27,0
 LWWW D3PD3Z+FR1,9,-29,1
 LWWW D3PD3Z+FR2,11,-12,1
 LWWW D3PD3Z+FR3,9,11,1
 LWWW D3PD3Z+FR4,11,50,1
 LWWW D3PD3Z+FR5,8,54,1
 LWWW D3PD3Z+FR6,27,46,1
 LWWW D3PD3Z+FR6,41,46,1
 LWWW D3PD3Z+FR6,50,41,1
 LWWW D3PD3Z+FR8,41,17,1
 LWWW D3PD3Z+FR9,43,-7,1
#Adam
 .long 0
#Lex
 LWWW L4AM4B+FR6,44,-39,0
 LWWW L3BF3B+FR1,10,-33,0
 LWWW L3GP3Z+FR1,8,-19,0
 LWWW L3GP3Z+FR2,10,-8,0
 LWWW L3GP3Z+FR3,11,3,0
 LWWW L3GP3Z+FR4,12,23,0
 LWWW L3GP3Z+FR5,18,30,0
 LWWW L3GP3Z+FR6,27,44,0
 LWWW L3GP3Z+FR6,41,44,0
 LWWW L3GP3Z+FR6,50,40,0
 LWWW L3FH3A+FR6,38,29,0
 LWWW L3FD3B+FR1,39,-1,0

#rollout_tbl
	.long	hrt_break_neck2_anim,rzr_break_neck2_anim
	.long	und_break_neck2_anim,yok_break_neck2_anim
	.long	shn_break_neck2_anim,bam_break_neck2_anim
	.long	dnk_break_neck2_anim,0,lex_break_neck2_anim

#****************************************

 SUBR	hrt_3_face_driver2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_ATTACK_ON,AMODE_PUPPET,-12,44,80,36	;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,4,H3PG3A+FR1
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;got him
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	.word	ANI_SET_RPTCOUNT,4	;2 times
	.word	ANI_CLR_BUTCOUNT

	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SOUND,82h			;Effort grunt

	WWLLW	ANI_SUPERSLAVE2,3,H3ZZ3T+FR1,#puppet_tbl,0

	WL	ANI_SET_YVEL,50000h

	.word	ANI_SETOPPMODE,MODE_GHOST

	WWLLW	ANI_SUPERSLAVE2,3,H3ZZ3T+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,H3ZZ3T+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,H3ZZ3T+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,H3ZZ3T+FR5,#puppet_tbl,4

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_SHAKEALL,2
	.word	ANI_DAMAGEOPP,D_FACEDRIVER,RD_FACEDRIVER
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	.word	ANI_ATTACHZ,0,0,2		;x & y don't matter.

	WWLLW	ANI_SUPERSLAVE2,3,H3ZZ3T+FR6,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,3,H3ZZ3T+FR7,#puppet_tbl,6

	.word	ANI_SHAKER,30
	WL	ANI_CODE,#flsh_wht
	WL	ANI_CODE,HIT_THE_MAT
	WWLLW	ANI_SUPERSLAVE2,3,H3ZZ3T+FR8,#puppet_tbl,7

;Check for a repeat
;If not, release as normal
#try_rpt

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,2,#norepeat
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#slam_again
	WL	ANI_GOTO,#norepeat

#slam_again
	.word	ANI_CLR_BUTCOUNT

;Slam him again using detach/reattach if button pressed again!
	WL	ANI_SLAVEANIM,#faced2_tbl
	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WL	5,H3ZZ3T+FR8
	WL	2,H3ZZ3T+FR7
	WL	2,H3ZZ3T+FR6
	WL	2,H3ZZ3T+FR5
	WL	4,H3ZZ3T+FR4

;Reattach me to who I'm slamming
	WL	ANI_CODE,#reattach

	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SETOPPMODE,MODE_GHOST

	WWLLW	ANI_SUPERSLAVE2,4,H3ZZ3T+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,H3ZZ3T+FR5,#puppet_tbl,4
 
	.word	ANI_SHAKEALL,2
	.word	ANI_DAMAGEOPP,D_FACESLAM2,RD_FACESLAM2
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	.word	ANI_ATTACHZ,0,0,2		;x & y don't matter.

	WWLLW	ANI_SUPERSLAVE2,4,H3ZZ3T+FR6,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,4,H3ZZ3T+FR7,#puppet_tbl,6

	.word	ANI_SHAKER,30
	WL	ANI_CODE,#flsh_wht
	WL	ANI_CODE,HIT_THE_MAT

	WWLLW	ANI_SUPERSLAVE2,4,H3ZZ3T+FR8,#puppet_tbl,7
	WL	ANI_GOTO,#try_rpt

;Didn't repeat - fall back as normal
#norepeat
	WWLLW	ANI_SUPERSLAVE2,2,H3ZZ3T+FR8,#puppet_tbl,7
	WL	ANI_CODE,CALL_SPECIAL_MOVE
	.word	ANI_DRAW_NAME,35
;	WL	ANI_CODE,#flsh_wht

	.ref	fall_back_tbl
	WL	ANI_SLAVEANIM,fall_back_tbl
	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_CLROPPMODE,MODE_GHOST

	WL	ANI_OPPOFFSET,#release_table
	WLLL	ANI_SETOPPVELS,020000H,070000h,0000h		;x,y,z vels
	.word	ANI_DETACH

	WL	1,H3ZZ3T+FR8
	WLLL	ANI_SETOPPVELS,020000H,070000h,0000h		;x,y,z vels
	WL	12,H3ZZ3T+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,H3ZZ3T+FR9
	WL	3,H3ZZ3T+FR10
	WL	4,H3PG3A+FR1

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#flsh_wht
	.ref	flash_white
	calla	flash_white
	rets

#reattach
	move	*a13(WHOIHIT),a0,L
	move	a0,*a13(ATTACH_PROC),L
	move	a13,*a0(ATTACH_PROC),L
	rets

#release_table
	;	X Y
	.word	0,0		;Bret
	.word	0,0		;Razor
	.word	0,0		;Taker
	.word	0,0		;Yokozuna
	.word	0,0		;Shawn
	.word	0,0		;BamBam
	.word	0,0		;Doink
	.word	0,0		;Adam
	.word	0,0		;Lex

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
 LWWW H3MS3Z+FR1,25,-9,0
 LWWW H3MS3Z+FR2,25,-3,0
 LWWW H3MS3Z+FR3,25,-11,0
 LWWW H3MS3Z+FR4,22,-6,0
 LWWW H3MS3Z+FR5,31,4,0
 LWWW H3MS3Z+FR5,41,9,0
 LWWW H3MS3Z+FR6,42,2,0
 LWWW H3MS3Z+FR4,55,-3,0
 .long 0
#Razor
 LWWW R3MS3Z+FR2,34,-17,0
 LWWW R3MS3Z+FR3,27,-10,0
 LWWW R3MS3Z+FR4,19,-4,0
 LWWW R3MS3Z+FR5,27,-2,0
 LWWW R3MS3Z+FR5,40,1,0
 LWWW R3MS3Z+FR5,48,-2,0
 LWWW R3MS3Z+FR6,54,-15,0
 LWWW R3MS3Z+FR3,56,-9,0
 .long 0
#Taker
 LWWW U3MS3Z+FR1,30,4,0
 LWWW U3MS3Z+FR2,11,9,0
 LWWW U3MS3Z+FR3,4,-8,0
 LWWW U3MS3Z+FR4,11,-4,0
 LWWW U3MS3Z+FR5,25,6,0
 LWWW U3MS3Z+FR5,33,11,0
 LWWW U3MS3Z+FR6,28,-1,0
 LWWW U3MS3Z+FR3,25,-4,0
 .long 0
#Yokozuna
 LWWW Y3MS3Z+FR1,39,-15,0
 LWWW Y3MS3Z+FR2,29,14,0
 LWWW Y3MS3Z+FR3,17,1,0
 LWWW Y3MS3Z+FR4,16,-2,0
 LWWW Y3MS3Z+FR5,24,1,0
 LWWW Y3MS3Z+FR5,32,6,0
 LWWW Y3MS3Z+FR6,36,-15,0
 LWWW Y3MS3Z+FR4,42,9,0
 .long 0
#Shawn
 LWWW S3MS3Z+FR1,21,-20,0
 LWWW S3MS3Z+FR2,13,-3,0
 LWWW S3MS3Z+FR3,7,2,0
 LWWW S3MS3Z+FR4,15,2,0
 LWWW S3MS3Z+FR5,28,8,0
 LWWW S3MS3Z+FR5,36,13,0
 LWWW S3MS3Z+FR6,52,-28,0
 LWWW S3MS3Z+FR3,41,3,0
 .long 0
#BamBam
 LWWW B3MS3Z+FR1,37,-4,0
 LWWW B3MS3Z+FR2,30,-3,0
 LWWW B3MS3Z+FR3,19,-6,0
 LWWW B3MS3Z+FR4,25,5,0
 LWWW B3MS3Z+FR5,37,26,0
 LWWW B3MS3Z+FR5,48,25,0
 LWWW B3MS3Z+FR6,52,14,0
 LWWW B3MS3Z+FR3,56,-3,0
 .long 0
#Doink
 LWWW D3GS3X+FR1,46,-18,0
 LWWW D3GS3X+FR3,27,1,0
 LWWW D3GS3X+FR4,20,-2,0
 LWWW D3GS3X+FR5,23,-6,0
 LWWW D3GS3X+FR7,34,2,0
 LWWW D3GS3X+FR7,44,4,0
 LWWW D3GS3X+FR8,48,-27,0
 LWWW D3GS3X+FR4,55,5,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3MS3Z+FR1,42,-13,0
 LWWW L3MS3Z+FR2,23,-1,0
 LWWW L3MS3Z+FR3,9,-4,0
 LWWW L3MS3Z+FR4,13,-8,0
 LWWW L3MS3Z+FR5,23,2,0
 LWWW L3MS3Z+FR5,33,4,0
 LWWW L3MS3Z+FR6,40,-21,0
 LWWW L3MS3Z+FR4,39,-13,0
 .long 0

	.ref	rzr_break_face3_anim
	.ref	und_break_face3_anim
	.ref	shn_break_face3_anim,bam_break_face3_anim
	.ref	lex_break_face3_anim
	.ref	yok_break_face3_anim
	.ref	dnk_break_face3_anim

#faced2_tbl
	.long	hrt_break_face3_anim,rzr_break_face3_anim
	.long	und_break_face3_anim
	.long	yok_break_face3_anim
	.long	shn_break_face3_anim,bam_break_face3_anim
	.long	dnk_break_face3_anim,0,lex_break_face3_anim


#*****************************************************************************
*
* FACE-RAKE (combo version)

 SUBR	hrt_combo_rake_face_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	3,H4RF3A+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 7,999,60,40,90000h,TGT_HEAD,56,93,8
	WL	2,H4RF3A+FR1

	.word	ANI_ATTACK_ON,AMODE_PUPPET,10,88,48,26

	WWL	ANI_WAITHITOPP,3,H4RF3A+FR3
	WWL	ANI_WAITHITOPP,6,H4RF3A+FR4

	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missedc
	WL	ANI_IFBLOCKED,#missedbc
	.WORD	ANI_INC_COMBO

	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,1,H4RF3A+FR4,#puppet_tbl,0

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	10,H4RF3A+FR4
	.word	ANI_CLR_BUTCOUNT

	WL	ANI_CODE,DO_EYES
	WL	ANI_CODE,GOUGE_SOUND
	WL	ANI_CODE,MAKE_HIM_SCREAM

	WL	4,H4RF3A+FR5
	WL	4,H4RF3A+FR6

	.word	ANI_DAMAGEOPP,D_FACERAKE,RD_FACERAKE
	WL	ANI_SLAVEANIM,#react_tbl
	.word	ANI_DETACH

	WL	10,H4RF3A+FR7
	WL	8,H4RF3A+FR8

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
	.word	ANI_SETMODE,MODE_NORMAL
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_END

#missedbc
#missedc
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_CODE,CALL_MISSES

	WL	3,H4RF3A+FR3
	WL	3,H4RF3A+FR2
	WL	3,H4RF3A+FR1

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************
*
* FACE-RAKE (sissy way to fight, if you ask me...)
*     Have you ever had your face raked ? It FUCKING hurts !!!! :)

 SUBR	hrt_rake_face_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,6
	WL	3,H4RF3A+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 7,999,75,45,90000h,TGT_HEAD,56,100,0
	WL	2,H4RF3A+FR1
	WL	3,H4RF3A+FR3
	.word	ANI_ATTACK_ON,AMODE_PUPPET,10,88,48,26

	WWL	ANI_WAITHITOPP,14,H4RF3A+FR4

	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb

#gothim
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	WL	ANI_CODE,CALL_NASTY_MOVE

	WWLLW	ANI_SUPERSLAVE2,1,H4RF3A+FR4,#puppet_tbl,0

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	10,H4RF3A+FR4
	.word	ANI_DRAW_NAME,19
	.word	ANI_ZEROVELS

	WL	ANI_CODE,DO_EYES
	WL	ANI_CODE,GOUGE_SOUND
	WL	ANI_CODE,MAKE_HIM_SCREAM

	WL	4,H4RF3A+FR5
	WL	4,H4RF3A+FR6

	.word	ANI_DAMAGEOPP,D_FACERAKE,RD_FACERAKE

	WL	ANI_CODE,#ck_dead_opp
	WL	ANI_IFSTATUS,#dead

	WL	ANI_SLAVEANIM,#react_tbl
	.word	ANI_DETACH

	WL	20,H4RF3A+FR7
	WL	3,H4RF3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#dead
	WL	ANI_SLAVEANIM,#react2_tbl
	.word	ANI_DETACH

	WL	10,H4RF3A+FR7
	WL	3,H4RF3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedb
#missed
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,CALL_MISSES

	WL	3,H4RF3A+FR4
	WL	3,H4RF3A+FR3
	WL	3,H4RF3A+FR2
	WL	3,H4RF3A+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#ck_dead_opp
	move	*a13(ATTACH_PROC),a2,L
	jrnz	#attach_found
	move	*a13(WHOIHIT),a2,L
#attach_found
	move	*a2(PLYRNUM),a1
	MMTM	SP,A10,A13
	MOVE	A13,A10
	MOVE	*A2,A13,L
	.ref	get_health
	calla	get_health
	MMFM	SP,A10,A13
	move	a0,a0
	jrnz	#ok
;Dead
	move	*a13(ANIMODE),a1
	ori	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets
#ok
	move	*a13(ANIMODE),a1
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
 .long 0
 .long #Lex

#Bret
 LWWW H2AH3A+FR1,58,12,0
#Razor
 LWWW R2AH2D+FR6,73,4,0
#Taker
 LWWW U2AH3A+FR3,45,24,0
#Yokozuna
 LWWW Y4AH4A+FR2,53,-1,0
#Shawn
 LWWW S4AH3D+FR5,55,-1,0
#BamBam
 LWWW B2AH2A+FR5,55,0,0
#Doink
 LWWW D3AK3A+FR3,58,7,0
#Lex
 LWWW L2AH2A+FR3,57,2,0

#react_tbl
	.long	xxx_get_face_rake_anim
	.long	xxx_get_face_rake_anim
	.long	xxx_get_face_rake_anim
	.long	xxx_get_face_rake_anim
	.long	xxx_get_face_rake_anim
	.long	xxx_get_face_rake_anim
	.long	xxx_get_face_rake_anim
	.long	0
	.long	xxx_get_face_rake_anim

#react2_tbl
	.long	xxx_get_face_rake2_anim
	.long	xxx_get_face_rake2_anim
	.long	xxx_get_face_rake2_anim
	.long	xxx_get_face_rake2_anim
	.long	xxx_get_face_rake2_anim
	.long	xxx_get_face_rake2_anim
	.long	xxx_get_face_rake2_anim
	.long	0
	.long	xxx_get_face_rake2_anim
****
* Generic wrapper for the rake reactions.  Sets plyrmode to normal, then
* goes to face rake.

 SUBR	xxx_get_face_rake_anim
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM_TBL,#face_hit2_tbl

#face_hit2_tbl
	.long	hrt_4_head_hit2_anim
	.long	rzr_4_head_hit2_anim
	.long	und_head_hit2_anim
	.long	yok_4_head_hit2_anim
	.long	shn_4_head_hit2_anim
	.long	bam_head_hit2_anim
	.long	dnk_head_hit2_anim
	.long	0
	.long	lex_4_head_hit2_anim


 SUBR	xxx_get_face_rake2_anim
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM_TBL,fall_back_tbl

	.ref	fall_back_tbl

#*****************************************************************************
*
* ROLL - UPPERCUT
 SUBR	hrt_combo_roll_uppercut_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_INAIR2
	WLW	ANI_SET_XVEL,70000h,AM_FACE_REL
	WL	ANI_CODE,#set_zvel

	;dive.
	WL	3,H3FR3A+FR1
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,-30,-4,62,54
#loopc
	WL	2,H3FR3A+FR2
	WL	ANI_CODE,#rope_check
	WL	ANI_IFSTATUS,#do_uppercutc
	WL	3,H3FR3A+FR3
	WL	ANI_CODE,#rope_check
	WL	ANI_IFSTATUS,#do_uppercutc
	WL	2,H3FR3A+FR4
	WL	ANI_CODE,#rope_check
	WL	ANI_IFSTATUS,#do_uppercutc
	WL	3,H3FR3A+FR5
	WL	ANI_CODE,#rope_check
	WL	ANI_IFSTATUS,#do_uppercutc
	WL	2,H3FR3A+FR6
	WL	ANI_CODE,#rope_check
	WL	ANI_IFSTATUS,#do_uppercutc
	WL	3,H3FR3A+FR7
	WL	ANI_CODE,#rope_check
	WL	ANI_IFSTATUS,#do_uppercutc
	WL	2,H3FR3A+FR8
	WL	ANI_CODE,#rope_check
	WL	ANI_IFSTATUS,#do_uppercutc
	WL	3,H3FR3A+FR9
	WL	ANI_CODE,#rope_check
	WL	ANI_IFSTATUS,#do_uppercutc
	WL	ANI_GOTO,#loopc

#standc
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_ATTACK_OFF
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	2,H3FR3A+FR10
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#do_uppercutc
	.word	ANI_SET_RPTCOUNT,3	;1 times

	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_OFF
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_CLR_BUTCOUNT

#upper_loop
	WL	2,H4UP3C+FR3
	WL	2,H4UP3C+FR4
	WL	1,H4UP3C+FR5

	.word	ANI_ATTACK_ON,AMODE_UPRCUT2,-6,22+10,100,100
	WL	2,H4UP3C+FR6
	.word	ANI_ATTACK_OFF
	WL	ANI_SET_YVEL,40000h

	WL	ANI_IFNOTSTATUS,#no_hitc
	WL	ANI_IFBLOCKED,#blockedc
	.word	ANI_INC_COMBO

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_slidec
#no_slidec
	WL	3,H4UP3C+FR6

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#upper_next_part

	WL	11,H4UP3C+FR7
	WL	2,H4UP3C+FR8

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,H4UP3C+FR9
	WL	2,H4UP3C+FR10

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#exit_move
	WL	ANI_CHANGEANIM,hrt_combo_running_ddt_anim

#exit_move
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#upper_next_part
	WL	2,H4UP3C+FR7
	WL	2,H4UP3C+FR8
	WL	ANI_GOTO,#upper_loop

#no_hitc
#blockedc
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_CODE,CALL_MISSES
	WL	17,H4UP3C+FR7
	WL	4,H4UP3C+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,H4UP3C+FR9
	WL	3,H4UP3C+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	hrt_roll_uppercut_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_INAIR2
	WLW	ANI_SET_XVEL,78000h,AM_FACE_REL
	WL	ANI_CODE,#set_zvel

	.word	ANI_STARTATTACK,AT_PUNCH,8

	;dive.
	WL	2,H3FR3A+FR1
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,-30,-4,62,54
#loop
	.word	ANI_STARTATTACK,AT_PUNCH,20
	WL	2,H3FR3A+FR2
	WL	ANI_CODE,#rope_check
	WL	ANI_IFSTATUS,#do_uppercut
	WL	3,H3FR3A+FR3
	WL	ANI_CODE,#rope_check
	WL	ANI_IFSTATUS,#do_uppercut
	WL	2,H3FR3A+FR4
	WL	ANI_CODE,#rope_check
	WL	ANI_IFSTATUS,#do_uppercut
	WL	3,H3FR3A+FR5
	WL	ANI_CODE,#rope_check
	WL	ANI_IFSTATUS,#do_uppercut
	WL	2,H3FR3A+FR6
	WL	ANI_CODE,#rope_check
	WL	ANI_IFSTATUS,#do_uppercut
	WL	3,H3FR3A+FR7
	WL	ANI_CODE,#rope_check
	WL	ANI_IFSTATUS,#do_uppercut
	WL	2,H3FR3A+FR8
	WL	ANI_CODE,#rope_check
	WL	ANI_IFSTATUS,#do_uppercut
	WL	3,H3FR3A+FR9
	WL	ANI_CODE,#rope_check
	WL	ANI_IFSTATUS,#do_uppercut
	WL	ANI_GOTO,#loop

#stand
	.word	ANI_ATTACK_OFF
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	2,H3FR3A+FR10
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#do_uppercut
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_OFF
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_STARTATTACK,AT_PUNCH,8
	WL	1,H4UP3C+FR3
	WL	1,H4UP3C+FR4
	WL	1,H4UP3C+FR5

	.word	ANI_ATTACK_ON,AMODE_UPRCUT,-6,22+10,64,100
	WL	3,H4UP3C+FR6
	.word	ANI_ATTACK_OFF

	.word	ANI_ADD_MOVE,MOVE_C_2,2,2
	WL	ANI_IFBLOCKED,#blocked
	WL	ANI_IFNOTSTATUS,#no_hit

	.ref	MAKE_HIM_SCREAM
	WL	ANI_CODE,MAKE_HIM_SCREAM
	.ref	impact_sound
	WL	ANI_CODE,impact_sound

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_slide
	WL	ANI_SET_YVEL,40000h
	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE

	WL	10,H4UP3C+FR7
	WL	3,H4UP3C+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	2,H4UP3C+FR9
	WL	2,H4UP3C+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#no_hit
#blocked
#no_slide
	WL	ANI_CODE,CALL_MISSES
	WL	12,H4UP3C+FR7
	WL	3,H4UP3C+FR8
	WL	3,H4UP3C+FR9
	WL	3,H4UP3C+FR10

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

;Set initial Z velocity so that we'll hit our opponent if he doesn't move.
; We don't pay any attention to his velocities, so this is approximate at
; best.
 SUBRP	#set_zvel

	calla	get_opp_process
	move	*a13(OBJ_XPOSINT),a1
	move	*a0(OBJ_XPOSINT),a14
	sub	a14,a1
	abs	a1			;X dist (ABS)
	movi	10000h/7,a14		;divide by 7
	mpyu	a14,a1
	srl	16,a1			;a1 = ticks

	move	*a0(OBJ_ZPOSINT),a3
	move	*a13(OBJ_ZPOSINT),a14
	sub	a14,a3			;Z dist
	divs	a1,a3

	sll	16,a3
	move	a3,*a13(OBJ_ZVEL),L

	rets

;Rope check.  Set status if I'm up against a side rope.
 SUBRP	#rope_check

	move	*a13(CAN_MOVE_DIR),a1
	andi	MOVE_LEFT|MOVE_RIGHT,a1
	jrz	#rets

	;up against rope.  get up.
	movi	#stand,a14
	move	a14,*a13(ANIPC),L

	;wobble the ropes
	movk	ROPE_RIGHT,a0
	btst	MOVE_RIGHT_BIT,a1
	jrnz	#ok0
	movk	ROPE_LEFT,a0
#ok0
	movk	ROPE_BOUNCEIO,a1
	calla	rope_command
	movi	03Ch,a0
	calla	triple_sound

#rets	rets

;#*****************************************************************************
;*
;* CHAIR STUFF
;
;	.ref	CHAIR_SWING
;
; SUBR	hrt_pkup_chair_anim
;
;	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
;	.word	ANI_ZEROVELS
;	.word	ANI_SETSPEED,100h
;
;#lp
;	WL	4,H4WA4A+FR1
;	WL	4,H4WA4A+FR2
;	WL	4,H4WA4A+FR3
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR1,46,-12,1 ;image, x,y,zoff
;	WL	4,H4WA4A+FR4
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR1,53,10,1 ;image, x,y,zoff
;	WL	4,H4WA4A+FR5
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR2,56,54,1 ;image, x,y,zoff
;	WL	4,H4WA4A+FR6
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR3,50,104,1 ;image, x,y,zoff
;	WL	4,H4WA4A+FR7
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR4,17,124,1 ;image, x,y,zoff
;	WL	4,H4WA4A+FR8
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR4,-5,133,1 ;image, x,y,zoff
;	WL	4,H4WA4A+FR9
;
;; .word ANI_SINGLESTEP
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR5,-34,102,1 ;image, x,y,zoff
;	WL	4,H4CS3A+FR2
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR6,-39,126,1 ;image, x,y,zoff
;	WL	4,H4CS3A+FR3
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR7,28,134,1 ;image, x,y,zoff
;	WL	4,H4CS3A+FR4
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR9,72,62,1 ;image, x,y,zoff
;	WL	4,H4CS3A+FR5
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR10,35,9,1 ;image, x,y,zoff
;	WL	4,H4CS3A+FR6
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR9,55,34,1 ;image, x,y,zoff
;	WL	4,H4CS3A+FR7
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR8,65,91,1 ;image, x,y,zoff
;	WL	4,H4CS3A+FR8
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR7,31,115,1 ;image, x,y,zoff
;	WL	4,H4CS3A+FR9
;
;; .word ANI_SINGLESTEP
;	WLW	ANI_ATTCHIMAGE,0,0
;
;	WL	ANI_GOTO,#lp
;
;

******************************************************************************

	.end
