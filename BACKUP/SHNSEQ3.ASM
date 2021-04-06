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
* Initiated:		5/26/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"shnseq3.asm"
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
	.include	"ring.equ"
	.include	"shawnimg.h"
	.include	"damage.equ"

******************************************************************************
* EXTERNAL REFERENCES

	;BRET
	.ref	hrt_hitonground_anim,hrt_break_neck_anim
	.ref	hrt_flyout_anim,hrt_3_head_held_anim
	.ref	H2AH3A,H2AM3A,H2CP3A,H3BF3A,H3DU3A,H3FR3A,H3GU4A,H3UC3X
	.ref	H3UC3Z,H3HB3A

	;BAM BAM
	.ref	bam_hitonground_xflip_anim,bam_3_head_held_anim
	.ref	bam_flyout_anim,bam_break_neck_anim
	.ref	bam_break_neck4_anim
	.ref	B3BF3C,B3DU3A,B3FD3C,B3GU4A,B4AH4A,B4TD3B,B4UC3B
	.ref	B4BF3A,B3HB3A,B3DR3B

	;DOINK
	.ref	dnk_hitonground_anim,dnk_hitonground_xflip_anim
	.ref	dnk_break_neck_anim,dnk_flyout_anim,dnk_3_head_held_anim
	.ref	D3AE3B,D3BF3A,D3DU3A,D3FD3E,D3HT3Z,D3OS3A,D3PM4C,D3SA3A
	.ref	D3UC3A,D3AK3A

	;LEX
	.ref	lex_hitonground_anim,lex_flyout_anim
	.ref	lex_break_neck_anim,lex_3_head_held_anim
	.ref	lex_break_neck4_anim
	.ref	L3BF3B,L3CP3B,L3DU3A,L3FD3B,L3FH3A,L3UC3X,L4AM4B,L3BF3A
	.ref	L2AH2A,L3CP3X,L4GH3B

	;RAZOR
	.ref	rzr_hitonground_anim,rzr_flyout_anim
	.ref	rzr_break_neck_anim,rzr_3_head_held_anim
	.ref	rzr_break_neck4_anim
	.ref	R3BF3A,R3DU3B,R3FD3B,R3GU2A,R3GU4A,R3HG3B,R3TD3A,R4AH4C
	.ref	R3HB3A

	;SHAWN
	.ref	shn_break_neck_anim,shn_stand4_anim,shn_3_head_held_anim
	.ref	shn_hitonground_anim,shn_flyout_anim
	.ref	shn_faceup_getup_anim,shn_arm_broken_anim
	.ref	shn_fall_back3_anim
	.ref	S4TD3F

	;TAKER
	.ref	und_hitonground_anim,und_flyout_anim
	.ref	und_break_neck_anim,und_3_head_held_anim
	.ref	und_break_neck_anim
	.ref	U3AE4A,U3CP3B,U3DU3B,U3FD3X,U3FH3A,U3GP3X,U4AH3A,U4AM4C
	.ref	U4BF3Z,U4BF3A,U3TBSM

	;YOKO
	.ref	yok_hitonground_anim,yok_frnk_backfire_anim
	.ref	yok_3_head_held_anim,yok_break_neck_anim
	.ref	yok_hitonground_xflip_anim
	.ref	Y3BF3A,Y3GU2A,Y3FD3A,Y3FD3N,Y3LB3A,Y4AM4A

	.ref	ckzpos

	;from WRESTLE.ASM
	.ref	process_ptrs

	;MISC
	.ref	store_opp_xvel,merge_xvels,announce_rnd_winner,SMALL_BOUNCE
	.ref	HIT_THE_MAT,CALL_SPECIAL_MOVE,CALL_MISSES,CALL_SETUP
	.ref	CALL_MISS_YOKO,choose_2or4

	.REF	CALL_THROWN_OUT
	.REF	CALL_ANI_AVERAGE_MOVE

	.REF	DO_FRANK_MESS
	.REF	DO_GERM_MESS
	.REF	DO_BODY_MESS

	.REF	CALL_OTHER_AVERAGE

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* GERMAN SUPLEX


 SUBR	shn_gsuplex_run_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WWL	ANI_IFOPPMODE,MODE_HEADHELD,#front_grab0
	WWL	ANI_IFOPPMODE,MODE_HEADHOLD,#front_grab0
	WWL	ANI_IFOPPMODE,MODE_ONGROUND,#front_grab0
	WWWL	ANI_IFNOTROPE,RC_FRONT,200,#back_grab0

#front_grab0
	.word	ANI_STARTATTACK,AT_LEAPING,6
	.word	ANI_XFLIP
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,70,70,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_SET_YVEL,0000h
	WL	ANI_GOTO,#common

#back_grab0

	;check for a likely hit.  If not, abort and do a front grab instead.
	.word	ANI_CLR_STATUS
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,12,47,49+8,23
	.word	ANI_PAUSE,1
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#front_grab0

	.word	ANI_OFFSET,5,0,0
	WL	3,S3BH3A+FR1
	.word	ANI_OFFSET,7+10,0,0
	WL	3,S3BH3A+FR2
	.word	ANI_OFFSET,3+10,0,0
	WL	3,S3BH3A+FR3
	.word	ANI_OFFSET,6+10,0,0
	WL	3,S3BH3A+FR4
	.word	ANI_OFFSET,2+10,0,0
	WL	3,S3BH3A+FR5
	.word	ANI_OFFSET,1+10,0,0
	WL	3,S3BH3A+FR6
	.word	ANI_OFFSET,3+10,0,0
	.word	ANI_FACE,MOVE_DOWN|MOVE_LEFT
	WL	ANI_GOTO,#common

 SUBR	shn_gsuplex_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WWL	ANI_IFOPPMODE,MODE_HEADHELD,#front_grab
	WWL	ANI_IFOPPMODE,MODE_HEADHOLD,#front_grab
	WWL	ANI_IFOPPMODE,MODE_ONGROUND,#front_grab
	WWWL	ANI_IFNOTROPE,RC_FRONT,200,#back_grab

#front_grab
	.word	ANI_XFLIP
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_SET_YVEL,0000h
	WL	ANI_GOTO,#common

#back_grab

	;check for a likely hit.  If not, abort and do a front grab instead.
	.word	ANI_CLR_STATUS
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,12,47,49+8,23
	.word	ANI_PAUSE,1
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#front_grab

	.word	ANI_OFFSET,5,0,0
	WL	3,S3BH3A+FR1
	.word	ANI_OFFSET,7+10,0,0
	WL	3,S3BH3A+FR2
	.word	ANI_OFFSET,3+10,0,0
	WL	3,S3BH3A+FR3
	.word	ANI_OFFSET,6+10,0,0
	WL	3,S3BH3A+FR4
	.word	ANI_OFFSET,2+10,0,0
	WL	3,S3BH3A+FR5
	.word	ANI_OFFSET,1+10,0,0
	WL	3,S3BH3A+FR6
	.word	ANI_OFFSET,3+10,0,0
	.word	ANI_FACE,MOVE_DOWN|MOVE_LEFT
#common

	.word	ANI_CLR_STATUS

	.word	ANI_ATTACK_ON, AMODE_PUPPET,-68,47,49,23
	WWL	ANI_WAITHITOPP,12,S3BH3A+FR7
	.word	ANI_ZERO_XZVELS
	WL	5,S3BH3A+FR7
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missed

;got him

	WL	ANI_CODE,DO_GERM_MESS

	WL	ANI_CODE,CALL_SPECIAL_MOVE
	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,5,S3SG3A+FR2,#puppet_tbl,0

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WWLLW	ANI_SUPERSLAVE2,4,S3SG3A+FR3,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,S3SG3A+FR4,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,S3SG3A+FR5,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,S3SG3A+FR6,#puppet_tbl,4

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_GSUPLEX

	WL	2,S3SG3A+FR6
	WWLLW	ANI_SUPERSLAVE2,3,S3SG3A+FR7,#puppet_tbl,5
	.word	ANI_SOUND,33h			;neck break (5-7 ticks late)
	WWLLW	ANI_SUPERSLAVE2,3,S3SG3A+FR8,#puppet_tbl,6
	WL	ANI_SLAVEANIM,#rollout_tbl
	.word	ANI_DETACH
	.word	ANI_OFFSET,-34,0,0

	WL	6,S3CP3B+FR7

	WL	ANI_CODE,#zero_butn

	WL	ANI_CHANGEANIM,shn_faceup_getup_anim

;#tgt_yoko
;	WL	ANI_CODE,CALL_MISS_YOKO
;	WL	8,S3BH3A+FR7
;	WL	4,S3BH3A+FR8
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
	WL	9,S3BH3A+FR7
	WL	4,S3BH3A+FR8
	.word	ANI_XFLIP
	WL	ANI_CODE,choose_2or4
	WL	ANI_IFSTATUS,#4
	WL	1,S2ST2C+FR1
	.word	ANI_FACEUP
	WL	ANI_GOTO,#2

#4	
	WL	1,S4ST4C+FR1
	.word	ANI_FACEDOWN
#2

	WL	ANI_CODE,#zero_butn

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#zero_butn
;Force player to start holding his button down starting at the end
;of the current buzz sequence.

	move	*a13(PLYRNUM),a0
	X16	a0
	.ref	punch_dtime1
	addi	punch_dtime1,a0
	clr	a14
	move	a14,*a0
	rets

********
* #include "s_gsup.seq"
*
* NOTE: Because of some funny flipping in the attack sequence, all X offsets
*	in victim sequences must be sign-reversed.


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
 LWWW H3UC3X+FR1,-18,14,1
 LWWW H3UC3X+FR2,-39,30,1
 LWWW H3UC3X+FR4,-13,32,1
 LWWW H3UC3X+FR5,37,57,1
 LWWW H3UC3X+FR6,90,17,1
 LWWW H3UC3Z+FR1,116,21,1
 LWWW H3UC3Z+FR2,152,25,1
#Razor
 LWWW R3FD3B+FR1,-20,12,1
 LWWW R3FD3B+FR2,-42,29,1
 LWWW R3FD3B+FR4,-23,37,1
 LWWW R3FD3B+FR5,24,43,1
 LWWW R3FD3B+FR6,89,5,1
 LWWW R3HG3B+FR1,118,23,1
 LWWW R3HG3B+FR2,146,31,1
#Taker
 LWWW U3FD3X+FR1,-25,24,0
 LWWW U3FD3X+FR3,-27,34,0
 LWWW U3FD3X+FR5,27,54,0
 LWWW U3FD3X+FR6,72,60,0
 LWWW U3GP3X+FR1,89,16,0
 LWWW U3GP3X+FR2,118,-12,0
 LWWW U3GP3X+FR3,149,6,0
#Yokozuna
 LWWW Y3FD3A+FR1,-26,4,1
 LWWW Y3FD3A+FR2,-58,40,1
 LWWW Y3FD3A+FR4,-29,41,1
 LWWW Y3FD3A+FR5,17,58,1
 LWWW Y3FD3N+FR1,64,36,1
 LWWW Y3FD3N+FR3,89,18,1
 LWWW Y3FD3N+FR4,118,35,1
#Shawn
 LWWW S3UC3X+FR1,-16,16,1
 LWWW S3UC3X+FR3,-40,25,1
 LWWW S3UC3X+FR5,2,34,1
 LWWW S3UC3X+FR6,62,55,1
 LWWW S3FD3X+FR1,76,16,1
 LWWW S3FD3X+FR2,107,35,1
 LWWW S3FD3X+FR3,140,60,1
#BamBam
 LWWW B4UC3B+FR1,-24,28,1
 LWWW B4UC3B+FR3,-48,27,1
 LWWW B4UC3B+FR5,0,51,1
 LWWW B4UC3B+FR6,69,61,1
 LWWW B3FD3C+FR1,88,2,1
 LWWW B3FD3C+FR2,115,31,1
 LWWW B3FD3C+FR3,139,51,1
#Doink
 LWWW D3UC3A+FR2,-21,22,1
 LWWW D3UC3A+FR3,-25,34,1
 LWWW D3UC3A+FR5,-15,32,1
 LWWW D3UC3A+FR7,45,58,1
 LWWW D3FD3E+FR2,98,10,1
 LWWW D3FD3E+FR3,133,1,1
 LWWW D3FD3E+FR4,162,25,1
#Adam
 .long 0
#Lex
 LWWW L3UC3X+FR2,-21,10,1
 LWWW L3UC3X+FR3,-44,20,1
 LWWW L3UC3X+FR4,-15,34,1
 LWWW L3UC3X+FR5,71,63,1
 LWWW L3UC3X+FR6,94,3,1
 LWWW L3FD3B+FR1,131,-3,1
 LWWW L3FD3B+FR2,159,6,1

#rollout_tbl
	.long	hrt_break_neck_anim,rzr_break_neck_anim
	.long	und_break_neck_anim,yok_break_neck_anim
	.long	shn_break_neck_anim,bam_break_neck_anim
	.long	dnk_break_neck_anim,0,lex_break_neck_anim

*
********

#*****************************************************************************
*
* FRANKENSTEINER

	.bss	#opp_xvel,32

 SUBR	shn_fstein2_anim
;From head hold combo move

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h

	;first, if we're holding his head, let him go.
	WWL	ANI_IFOPPMODE,~MODE_HEADHELD,#no_hdrel2
	.word	ANI_DETACH
#no_hdrel2
	.word	ANI_STARTATTACK,AT_LEAPING,12

	WL	4,S3FL3X+FR1
	WL	4,S3FL3X+FR2
	.word	ANI_OFFSET,0,45,0
	WL	1,S3ZI3A+FR1
	LEAPATOPP 10,999,120,55,90000h,TGT_HEAD,17-20,35,-20
	WL	4,S3ZI3A+FR1

	.word	ANI_ATTACK_ON,AMODE_PUPPET,10-36,-20,56,33 ;mode,x,y,w,h
	WL	ANI_GOTO,#cont

 SUBR	shn_fstein_anim
 SUBR	shn_standing_fstein_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h

	;first, if we're holding his head, let him go.
	WWL	ANI_IFOPPMODE,~MODE_HEADHELD,#no_hdrel
	.word	ANI_DETACH
#no_hdrel
	.word	ANI_STARTATTACK,AT_LEAPING,12

	WL	4,S3FL3X+FR1
	WL	4,S3FL3X+FR2
	.word	ANI_OFFSET,0,45,0
	WL	1,S3ZI3A+FR1
	LEAPATOPP 10,999,120,55,90000h,TGT_HEAD,17-20,35,-20
	WL	4,S3ZI3A+FR1

	.word	ANI_ATTACK_ON,AMODE_PUPPET,10-36,0,36,33 ;mode,x,y,w,h

#cont
	WL	ANI_CODE,#store_opp_xvel
	WWL	ANI_WAITHITOPP,10,S3ZI3A+FR2
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb

;	.word	ANI_IFOPP,W_YOKO,-1
;	WL	ANI_IFSTATUS,#tgt_yoko
	.word	ANI_CLR_STATUS

	;hit
	WL	ANI_CODE,#merge_xvels
	WL	ANI_CODE,DO_FRANK_MESS
	.word	ANI_ATTACHZ,0,0,-10		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	WWLLW	ANI_SUPERSLAVE2,4,S3ZI3A+FR3,#puppet_tbl,0
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_OFFSET,0,-65,0

	WWLLW	ANI_SUPERSLAVE2,4,S3ZI3A+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,S3ZI3A+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,S3ZI3A+FR6,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,S3ZI3A+FR7,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,S3ZI3A+FR8,#puppet_tbl,5

	WWWL	ANI_IFROPE,RC_BACK,160,#throw_him_out

	WWLLW	ANI_SUPERSLAVE2,4,S3ZI3A+FR9,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,4,S3ZI3A+FR10,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,4,S3ZI3A+FR11,#puppet_tbl,8

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_FSTEIN
	.word	ANI_OPP_GETUP,300

	WWLLW	ANI_SUPERSLAVE2,4,S3ZI3A+FR11,#puppet_tbl,9
	WL	ANI_OPPOFFSET,#release_offsets
	WL	ANI_CODE,CALL_SPECIAL_MOVE
	WL	ANI_SLAVEANIM,#recover_tbl
	.word	ANI_DETACH
	.word	ANI_OFFSET,-41,0,0
	WL	4,S2PJ3C+FR9
	.word	ANI_OFFSET,41,0,0
	WL	4,S3GU2A+FR5
	WL	4,S3GU2A+FR6
	WL	4,S3GU2A+FR7
	WL	4,S3GU2A+FR8
	WL	4,S3GU2A+FR9
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#throw_him_out
	WLLL	ANI_ATTACHVEL,-70000h,70000h,0h		;x,y,z
	WL	ANI_SLAVEANIM,#flyout_tbl
	.word	ANI_DETACH
	WL	3,S3ZI3A+FR8
	WL	4,S3ZI3A+FR9
	WL	4,S3ZI3A+FR10
	WL	4,S3ZI3A+FR11

	;impact
;	.word	ANI_OPP_GETUP,30

	WL	4,S3ZI3A+FR11
	.word	ANI_OFFSET,-41,0,0
	WL	4,S2PJ3C+FR9
	.word	ANI_OFFSET,41,0,0
	WL	4,S3GU2A+FR5
	WL	4,S3GU2A+FR6
	WL	4,S3GU2A+FR7
	WL	4,S3GU2A+FR8
	WL	4,S3GU2A+FR9
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#tgt_yoko
	;we've hit yoko.  mistake.
	;this will turn yoko into the attacker, so it doesn't much matter
	; what we do from here, as he'll be calling the shots.
	
	.word	ANI_ZERO_XZVELS
	WL	ANI_CODE,#set_attach
	WL	ANI_CODE,CALL_MISS_YOKO
	WL	ANI_SLAVEANIM,#backfire_tbl
	WL	999,S3ZI3A+FR3
	.word	ANI_END

#set_attach
	move	*a13(WHOIHIT),a0,L
	move	a0,*a13(ATTACH_PROC),L
	move	a13,*a0(ATTACH_PROC),L
	rets

#missedb
	.word	ANI_IFOPP,W_YOKO,-1
	WL	ANI_IFSTATUS,#tgt_yoko
;we've hit a blocker.  mistake.

	;uh, for now just abort.
	WL	ANI_CODE,#set_attach
	WLLL	ANI_SETOPPVELS,60000h,40000h,0	;x,y,z vels
;	WLW	ANI_SET_OPP_XVEL,-20000h,AM_FACE_REL
;	.word	ANI_DETACH
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_SOUND,018h			;Hard hit
	.word	ANI_ZERO_XZVELS
	WL	3,S3UC3X+FR4
	WL	3,S3UC3X+FR5
	WL	3,S3UC3X+FR6
	.word	ANI_WAITHITGND
	WLLL	ANI_SETOPPVELS,0000h,0000h,0	;x,y,z vels
	.word	ANI_DETACH
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,35
	.word	ANI_SOUND,0BFh
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,shn_hitonground_anim


#missed
	;uh, for now just abort.
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_WAITHITGND
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,35
	.word	ANI_SOUND,0BFh
	.word	ANI_SOUND,0C1h			;plywood crash #3
;	WL	3,S3UC3X+FR4
;	WL	3,S3UC3X+FR5
;	WL	3,S3UC3X+FR6
	.word	ANI_XFLIP
;	.word	ANI_GETUP,30
	WL	ANI_CHANGEANIM,shn_hitonground_anim

;new xvel is (attacker xvel + defender xvel)/4
#merge_xvels

	move	@#opp_xvel,a0,L
	move	*a13(OBJ_XVEL),a1,L
	add	a1,a0
	sra	2,a0
	move	a0,*a13(OBJ_XVEL),L
#rets
	rets

;save opponent's x-velocity
#store_opp_xvel
	move	*a13(CLOSEST_NUM),a0
	X32	a0
	addi	process_ptrs,a0
	move	*a0,a0,L
	move	*a0(OBJ_XVEL),a0,L
	move	a0,@#opp_xvel,L
	rets

********
* #include "s_frnk.seq"

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
 LWWW H2AH3A+FR5,6,-31,0
 LWWW H2AH3A+FR6,11,-30,0
 LWWW H2AM3A+FR1,57,-17,0
 LWWW H2AM3A+FR7,77,-25,0
 LWWW H3FR3A+FR2,77,21,0
 LWWW H3FR3A+FR3,49,57,0
 LWWW H3FR3A+FR4,-7,59,0
 LWWW H3FR3A+FR5,-46,41,0
 LWWW H3FR3A+FR6,-43,52,0
 LWWW H2CP3A+FR8,-115,-14,1
#Razor
 LWWW R4AH4C+FR3,9,-27,0
 LWWW R4AH4C+FR8,6,-27,0
 LWWW R3TD3A+FR1,41,-21,0
 LWWW R3TD3A+FR2,69,-27,0
 LWWW R3TD3A+FR4,72,29,0
 LWWW R3TD3A+FR5,46,44,0
 LWWW R3TD3A+FR6,-8,50,0
 LWWW R3TD3A+FR7,-43,52,0
 LWWW R3TD3A+FR8,-33,72,0
 LWWW R3GU2A+FR1,-142,-11,1
#Taker
 LWWW U4AH3A+FR2,-5,-19,0
 LWWW U3AE4A+FR1,3,-22,0
 LWWW U4AM4C+FR4,44,-16,0
 LWWW U3FH3A+FR1,65,-11,1
 LWWW U3FH3A+FR2,60,35,1
 LWWW U3FH3A+FR3,35,41,1
 LWWW U3FH3A+FR4,-21,47,1
 LWWW U3FH3A+FR5,-51,56,1
 LWWW U3FH3A+FR5,-30,81,1
 LWWW U3CP3B+FR1,-136,-7,1
#Yokozuna
 LWWW Y4AE4A+FR1,11,-33,0
	.ref	Y2AM2C
 LWWW Y2AM2C+FR1,18,-41,0
 LWWW Y3FL3W+FR1,53,-13,0
 LWWW Y3FL3W+FR2,61,-17,0
 LWWW Y3FL3W+FR3,67,23,0
 LWWW Y3FL3W+FR4,54,47,0
 LWWW Y3FL3W+FR5,8,56,0
 LWWW Y3FL3W+FR6,-39,58,0
 LWWW Y3FL3W+FR7,-42,56,0
 LWWW Y3FD3A+FR7,-89,13,0
 .long 0
#Shawn
 LWWW S3OS3X+FR1,8,-28,1
 LWWW S3OS3X+FR2,-12,-31,1
 LWWW S3OS3X+FR3,33,-12,1
 LWWW S3OS3X+FR4,38,-17,1
 LWWW S3OS3X+FR5,57,5,1
 LWWW S3OS3X+FR6,47,50,1
 LWWW S3OS3X+FR7,22,65,1
 LWWW S3OS3X+FR8,4,68,1
 LWWW S3OS3X+FR9,-61,71,1
 LWWW S3OS3X+FR10,-124,-6,1
#BamBam
 LWWW B4AH4A+FR1,-4,-33,0
 LWWW B4TD3B+FR1,-9,-35,0
 LWWW B4TD3B+FR2,33,-25,0
 LWWW B4TD3B+FR3,56,-30,0
 LWWW B4TD3B+FR4,79,7,0
 LWWW B4TD3B+FR5,57,45,0
 LWWW B4TD3B+FR6,14,75,0
 LWWW B4TD3B+FR7,-29,71,0
 LWWW B4TD3B+FR8,-40,81,0
 LWWW B4TD3B+FR9,-98,5,0
#Doink
 LWWW D3AE3B+FR7,1,-25,0
 LWWW D3AE3B+FR8,2,-28,0
 LWWW D3PM4C+FR2,26,-18,0
 LWWW D3OS3A+FR1,73,-27,0
 LWWW D3OS3A+FR2,82,2,0
 LWWW D3OS3A+FR3,57,12,0
 LWWW D3OS3A+FR5,31,41,0
 LWWW D3OS3A+FR6,-17,49,0
 LWWW D3FD3E+FR2,-47,57,0
 LWWW D3SA3A+FR8,-133,-6,1
#Adam
 .long 0
#Lex
 LWWW L4AM4B+FR2,4,-31,0
 LWWW L4AM4B+FR3,-6,-34,0
 LWWW L3FH3A+FR1,43,-21,0
 LWWW L3FH3A+FR2,74,-16,0
 LWWW L3FH3A+FR3,79,39,0
 LWWW L3FH3A+FR4,50,43,0
 LWWW L3FH3A+FR5,5,42,0
 LWWW L3FH3A+FR6,-35,50,0
 LWWW L3FH3A+FR6,-24,68,0
 LWWW L3CP3B+FR1,-130,-7,1

*
********

#recover_tbl
	.long	hrt_hitonground_anim
	.long	rzr_hitonground_anim
	.long	und_hitonground_anim
;	.long	yok_frnk_backfire_anim
	.long	yok_hitonground_xflip_anim
	.long	shn_hitonground_anim
	.long	bam_hitonground_xflip_anim
	.long	dnk_hitonground_anim
	.long	0
	.long	lex_hitonground_anim

#backfire_tbl
	.long	yok_frnk_backfire_anim
	.long	yok_frnk_backfire_anim
	.long	yok_frnk_backfire_anim
	.long	yok_frnk_backfire_anim
	.long	yok_frnk_backfire_anim
	.long	yok_frnk_backfire_anim
	.long	yok_frnk_backfire_anim
	.long	yok_frnk_backfire_anim
	.long	yok_frnk_backfire_anim


#flyout_tbl
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

#release_offsets
	;	X Y
	.word	0,0		;Bret
	.word	0,0		;Razor
	.word	0,0		;Taker
	.word	0,0		;Yokozuna
	.word	0,0		;Shawn
	.word	20,0		;BamBam
	.word	0,0		;Doink
	.word	0,0		;Adam
	.word	0,0		;Lex

#*****************************************************************************
*
* SPIN KICK

;TODO(JS) - deal with the CALL_MISSES thing
 SUBR	shn_spinkick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_LEAPING,12

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 11,999,50,50,90000h,TGT_HEAD,10,78,0

	;jump
	WL	2,S4SK3Y+FR3
	WL	2,S4SK3Y+FR4
	WL	2,S4SK3Y+FR5
	WL	2,S4SK3Y+FR6
	WL	3,S4SK3Y+FR7

	.word	ANI_ATTACK_ON,AMODE_SPINKICK,22,91-24,47,19
	WWL	ANI_WAITHITOPP,6,S4SK3Y+FR8
	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-58000h,#no_slide

	;-hit, slide
	WL	ANI_SET_YVEL,50000h
	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE
	WL	ANI_GOTO,#cont

#no_slide
	WL	ANI_IFNOTSTATUS,#missed

	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE

	;-hit, no slide
	WL	ANI_SET_YVEL,30000h
	WL	ANI_CODE,#reverse_xvel
	WL	ANI_GOTO,#cont

#missed
	;-missed
	WL	ANI_CODE,CALL_MISSES
#cont
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,S4SK3Y+FR9
	WL	3,S4SK3Y+FR10
	WL	3,S4SK3Y+FR11
;	WL	3,S4SK3Y+FR12
	WL	3,S3GU2A+FR9

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#reverse_xvel
	move	*a13(OBJ_XVEL),a14,L
	neg	a14
	sra	2,a14
	move	a14,*a13(OBJ_XVEL),L
	rets

#*****************************************************************************
*
* SPEED KICK

 SUBR	shn_super_speedkick_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_SET_RPTCOUNT,4	;3 times

	.word	ANI_STARTATTACK,AT_KICK,9
	WL	2,S4KI3Q+FR1

	.word	ANI_CLR_BUTCOUNT
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 08h,999,30,40,90000h,TGT_HEAD,75,90,-10

	WL	ANI_SET_YVEL,30000h

	WL	2,S4KI3Q+FR2
	WL	2,S4KI3Q+FR3
	WL	2,S4KI3Q+FR4
	WL	2,S4KI3Q+FR5
	.word	ANI_CLR_STATUS
	.word	ANI_ATTACK_ON,AMODE_SHNSPDKIK,40,76,49,30
	WL	4,S4KI3Q+FR6
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#gothim

;miss
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,S4KI3Q+FR7
	WL	3,S4KI3Q+FR8
	WL	3,S4KI3Q+FR9
	WL	3,S4KI3Q+FR4
	WL	3,S4KI3Q+FR3
	WL	3,S4KI3Q+FR2
	WL	3,S4KI3Q+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#loop
	.word	ANI_CLR_BUTCOUNT
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 05h,999,30,40,90000h,TGT_HEAD,75,105,-10

	WL	ANI_SET_YVEL,30000h

	WL	2,S4KI3Q+FR4
	WL	2,S4KI3Q+FR5
	.word	ANI_CLR_STATUS
	.word	ANI_ATTACK_ON,AMODE_SHNSPDKIK,40,76,49,30
	WL	4,S4KI3Q+FR6
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#gothim

;miss
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,S4KI3Q+FR7
	WL	3,S4KI3Q+FR8
	WL	3,S4KI3Q+FR9
	WL	3,S4KI3Q+FR4
	WL	3,S4KI3Q+FR3
	WL	3,S4KI3Q+FR2
	WL	3,S4KI3Q+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#gothim
	.word	ANI_ZERO_XZVELS
	WL	ANI_CODE,#set_opp_xy

	WL	2,S4KI3Q+FR7
	WL	2,S4KI3Q+FR8
	WL	2,S4KI3Q+FR9

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#fail
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#loop
#fail
	WL	3,S4KI3Q+FR4
	WL	3,S4KI3Q+FR3
	WL	3,S4KI3Q+FR2
	WL	3,S4KI3Q+FR1

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END
#miss
	WL	3,S4KI3Q+FR7
	WL	3,S4KI3Q+FR8
	WL	3,S4KI3Q+FR9
	WL	3,S4KI3Q+FR4
	WL	3,S4KI3Q+FR3
	WL	3,S4KI3Q+FR2
	WL	3,S4KI3Q+FR1

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#set_opp_xy
	move	*a13(WHOIHIT),a0,L

	movi	-[2,0],a14
	move	a14,*a0(OBJ_ZVEL),L

	movi	[3,0],a14
	move	a14,*a0(OBJ_YVEL),L

	move	*a13(INRING),a1
	jrnz	#ok

	move	*a13(OBJ_XPOSINT),a14
	subi	RING_X_MID,a14
	abs	a14
	cmpi	0a0h,a14
	jrlt	#ok

;	rets

#ok
	movi	-[3,0],a1
	move	*a0(NEW_FACING_DIR),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#abs			;right
	neg	a1			;left
#abs
	move	a1,*a0(OBJ_XVEL),L
 
	rets

#*****************************************************************************
*
* BODY SLAM
*
* only difference between standing and normal bodyslam is that the attack
* frame on the standing slam isn't held as long.  Use the normal if opponent
* is running, or the standing otherwise.
*

 SUBR	shn_2_bslam_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,7
	WL	2,S1TT5Z+FR2	;2.5
	WL	2,S1TT5Z+FR3	;3.5

 SUBR	shn_4_bslam_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,4


	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,50,0,0
	WL	ANI_SET_YVEL,0000h


	WL	3,S4GS3C+FR1

	;temp!
	.word	ANI_CLR_STATUS

	.word	ANI_ATTACK_ON, AMODE_PUPPET,62,49,21,39 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,6,S4GS3C+FR2
	.word	ANI_ZERO_XZVELS
	WWL	ANI_WAITHITOPP,4,S4GS3C+FR2
	.word	ANI_ATTACK_OFF

;#common
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missed

	WL	ANI_CODE,DO_BODY_MESS

	WL	ANI_CODE,CALL_OTHER_AVERAGE

	WL	ANI_CODE,CALL_THROWN_OUT

	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,4,S4GS3C+FR2,#puppet_tbl,0
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WWWL	ANI_IFROPE,RC_BACK,100,#throw_him_out

	WWLLW	ANI_SUPERSLAVE2,4,S4GS3C+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,S4GS3C+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,S4GS3C+FR6,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,S4GS3C+FR7,#puppet_tbl,4

	WWLLW	ANI_SUPERSLAVE2,4,S4GS3C+FR8,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,4,S4GS3C+FR9,#puppet_tbl,6

	;impact
	.word	ANI_SOUND,0C1h			;plywood crash #3
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_DAMAGEOPP,D_HIPTOSS
	.word	ANI_OPP_GETUP,300

	WWLLW	ANI_SUPERSLAVE2,4,S4GS3C+FR10,#puppet_tbl,7

	WL	ANI_OPPOFFSET,#release_offsets
	WL	ANI_SLAVEANIM,#recover_tbl
	.word	ANI_DETACH
	.word	ANI_FACE,MOVE_LEFT|MOVE_DOWN
	WL	8,S4GS3C+FR11
	WL	4,S4GS3C+FR12
	.word	ANI_XFLIP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#missedb
	WL	5,S4GS3C+FR2
#missed
	WL	10,S4GS3C+FR2

	.word	ANI_WAITHITGND
	.word	ANI_SETFACING
	.word	ANI_ZEROVELS
	WL	5,S4GS3C+FR2
	WL	5,S4GS3C+FR1
#abort
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#throw_him_out
	;since we're gonna throw him out anyhow, turn off confine.
	.word	ANI_SETOPPMODE,MODE_NOCONFINE
	WWLLW	ANI_SUPERSLAVE2,4,S4GS3C+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,S4GS3C+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,S4GS3C+FR6,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,1,S4GS3C+FR7,#puppet_tbl,4
	WLLL	ANI_ATTACHVEL,-70000h,70000h,0h		;x,y,z
	WL	ANI_SLAVEANIM,#flyout_tbl
	.word	ANI_DETACH

	WL	3,S4GS3C+FR7
	WL	3,S4GS3C+FR8
	WL	4,S4GS3C+FR9
	WL	4,S4GS3C+FR10
	WL	8,S4GS3C+FR11
	WL	4,S4GS3C+FR12
	.word	ANI_FACE,MOVE_LEFT|MOVE_DOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

********
* #include "s_bslm.img"

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
 LWWW H2AH3A+FR5,49,27,0
 LWWW H2AM3A+FR1,39,30,0
 LWWW H2AM3A+FR7,37,6,0
 LWWW H3FR3A+FR2,16,21,0
 LWWW H3FR3A+FR3,0,49,0
 LWWW H3FR3A+FR4,-14,57,0
 LWWW H3FR3A+FR5,-35,38,0
 LWWW H2CP3A+FR8,-150,-69,1
#Razor
 LWWW R4AH4C+FR3,54,31,0
 LWWW R3TD3A+FR1,25,31,0
 LWWW R3TD3A+FR2,36,8,0
 LWWW R3TD3A+FR4,2,22,0
 LWWW R3TD3A+FR5,2,36,0
 LWWW R3TD3A+FR6,-6,47,0
 LWWW R3TD3A+FR7,-32,41,0
 LWWW R3GU2A+FR1,-160,-64,1
#Taker
 LWWW U3AE4A+FR1,50,37,0
 LWWW U4AM4C+FR4,23,35,0
 LWWW U3FH3A+FR1,33,17,1
 LWWW U3FH3A+FR2,5,35,1
 LWWW U3FH3A+FR3,-5,43,1
 LWWW U3FH3A+FR4,-22,54,1
 LWWW U3FH3A+FR5,-46,55,1
 LWWW U3CP3B+FR1,-163,-60,1
#Yokozuna
	.ref	Y4AE4A
 LWWW Y4AE4A+FR1,64,25,0
 LWWW Y3FL3W+FR1,34,32,0
 LWWW Y3FL3W+FR2,28,16,0
 LWWW Y3FL3W+FR3,-1,26,0
 LWWW Y3FL3W+FR4,-10,39,0
 LWWW Y3FL3W+FR5,-24,37,0
 LWWW Y3FL3W+FR6,-38,36,0
 LWWW Y3FD3A+FR7,-131,-42,0
 .long 0
#Shawn
 LWWW S3OS3X+FR2,39,23,1
 LWWW S3OS3X+FR3,19,20,1
 LWWW S3OS3X+FR4,3,11,1
 LWWW S3OS3X+FR5,-21,20,1
 LWWW S3OS3X+FR6,-24,51,1
 LWWW S3OS3X+FR7,-22,47,1
 LWWW S3OS3X+FR9,-50,41,1
 LWWW S3OS3X+FR10,-137,-61,1
#BamBam
 LWWW B4AH4A+FR1,44,26,0
 LWWW B4TD3B+FR2,15,23,0
 LWWW B4TD3B+FR3,13,10,0
 LWWW B4TD3B+FR4,12,17,0
 LWWW B4TD3B+FR5,-5,55,0
 LWWW B4TD3B+FR6,-9,66,0
 LWWW B4TD3B+FR7,-21,61,0
 LWWW B4TD3B+FR9,-136,-47,0
#Doink
 LWWW D3AE3B+FR8,47,26,0
 LWWW D3PM4C+FR2,8,25,0
 LWWW D3OS3A+FR1,25,10,0
 LWWW D3OS3A+FR2,-10,17,0
 LWWW D3OS3A+FR3,-23,22,0
 LWWW D3OS3A+FR4,-21,29,0
 LWWW D3OS3A+FR6,-26,34,0
 LWWW D3FD3E+FR2,-83,-26,0
#Adam
 .long 0
#Lex
 LWWW L4AM4B+FR2,51,28,0
 LWWW L3FH3A+FR1,24,18,0
 LWWW L3FH3A+FR2,27,2,0
 LWWW L3FH3A+FR3,10,28,0
 LWWW L3FH3A+FR4,6,37,0
 LWWW L3FH3A+FR5,-5,39,0
 LWWW L3FH3A+FR6,-23,48,0
 LWWW L3CP3B+FR1,-143,-59,1
*
********

#recover_tbl
	.long	hrt_hitonground_anim,rzr_hitonground_anim
	.long	und_hitonground_anim,yok_hitonground_xflip_anim
	.long	shn_hitonground_anim,bam_hitonground_xflip_anim
	.long	dnk_hitonground_xflip_anim,0,lex_hitonground_anim

#flyout_tbl
	.long	hrt_flyout_anim,rzr_flyout_anim,und_flyout_anim
	.long	yok_flyout_anim
	.long	shn_flyout_anim,bam_flyout_anim,dnk_flyout_anim
	.long	0,lex_flyout_anim

#release_offsets
	;	X Y
	.word	0,0		;Bret
	.word	0,0		;Razor
	.word	0,0		;Taker
	.word	0,0		;Yokozuna
	.word	0,0		;Shawn
	.word	20,0		;BamBam
	.word	30,0		;Doink
	.word	0,0		;Adam
	.word	0,0		;Lex

#******************************************************************************

 SUBR	shn_2_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	2,S1TT5Z+FR2	;2.5
	WL	2,S1TT5Z+FR3	;3.5

 SUBR	shn_4_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

;Put cool cheers here
;	.word	ANI_RAWSOUND,2055		;big cheer #1
;	.word	ANI_CHEER,3

	WL	3,S4GH3A+FR1

	LEAPATOPP 8,999,80,80,30000h,TGT_HEAD,46-10,6,-2

	WL	4,S4GH3A+FR2
	WL	4,S4GH3A+FR3
	.word	ANI_ZERO_XZVELS

	.word	ANI_ATTACK_ON, AMODE_PUPPET,21,1,31,18 ;mode,x,y,w,h
	WL	5,S4GH3A+FR4
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;got him

	WL	ANI_CODE,CALL_SETUP
	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SOUND,33h			;neck break (5-7 ticks late)
	.word	ANI_DAMAGEOPP,D_HAIR_PICKUP

	WWLLW	ANI_SUPERSLAVE2,4,S4GH3A+FR6,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,S4GH3A+FR7,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,S4GH3A+FR8,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,S4GH3A+FR9,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,S4GH3C+FR8,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,S4GH3C+FR8,#puppet_tbl,5

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	4,S4GH3C+FR8
	.word	ANI_CLROPPMODE,MODE_GHOST

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
	WL	20,S4GH3A+FR4
	WL	3,S4GH3A+FR3
	WL	3,S4GH3A+FR2
	WL	3,S4GH3A+FR1

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
 LWWW H3GU4A+FR1,25,-34,0
 LWWW H3GU4A+FR3,26,-41,0
 LWWW H3DU3A+FR3,33,-43,1
 LWWW H3DU3A+FR4,50,-33,1
 LWWW H3DU3A+FR5,55,-30,1
 LWWW H3BF3A+FR1,52,-35,0
 .long 0
#Razor
 LWWW R3GU4A+FR2,35,-34,1
 LWWW R3GU4A+FR3,29,-37,0
 LWWW R3GU4A+FR5,41,-48,0
 LWWW R3DU3B+FR2,49,-44,1
 LWWW R3DU3B+FR4,55,-28,1
 LWWW R3BF3A+FR4,56,-34,0
 .long 0
#Taker
 LWWW U3DU3B+FR2,27,-26,1
 LWWW U3DU3B+FR5,16,-34,1
 LWWW U3DU3B+FR6,20,-44,1
 LWWW U3DU3B+FR8,33,-37,1
 LWWW U3DU3B+FR10,49,-23,1
 LWWW U4BF3Z+FR5,53,-14,0
 .long 0
#Yokozuna
 LWWW Y3GU2A+FR1,29,-22,0
 LWWW Y3GU2A+FR3,36,-26,0
 LWWW Y3GU2A+FR6,16,-42,0
 LWWW Y3GU2A+FR9,53,-36,0
 LWWW Y3GU2A+FR12,60,-20,0
 LWWW Y3BF3A+FR1,50,-23,0
 .long 0
#Shawn
 LWWW S3GU4A+FR1,30,-33,1
 LWWW S3GU4A+FR2,26,-34,0
 LWWW S3GU4A+FR4,42,-45,0
 LWWW S3GU4A+FR5,43,-39,0
 LWWW S3DU3A+FR2,65,-36,1
 LWWW S3BF3A+FR1,49,-33,0
 .long 0
#BamBam
 LWWW B3GU4A+FR3,33,-22,0
 LWWW B3GU4A+FR4,25,-33,0
 LWWW B3GU4A+FR6,32,-40,0
 LWWW B3GU4A+FR7,32,-42,0
 LWWW B3DU3A+FR2,56,-27,1
 LWWW B3BF3C+FR5,58,-26,0
 .long 0
#Doink
 LWWW D3DU3A+FR2,29,-26,1
 LWWW D3DU3A+FR3,31,-35,1
 LWWW D3DU3A+FR5,28,-39,1
 LWWW D3DU3A+FR8,35,-44,1
 LWWW D3HT3Z+FR1,45,-26,1
 LWWW D3BF3A+FR2,38h,-32,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3DU3A+FR2,38,-36,1
 LWWW L3DU3A+FR4,9,-31,1
 LWWW L3DU3A+FR6,24,-45,1
 LWWW L3DU3A+FR7,33,-35,1
 LWWW L3DU3A+FR9,51,-29,1
 LWWW L3BF3B+FR2,60,-35,0
 .long 0


#*****************************************************************************

 SUBR	shn_speed_spinkick_anim
;From head hold

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_SET_RPTCOUNT,3	;2 times
#rpt_loop
	.word	ANI_CLR_BUTCOUNT

	WL	2,S4KI3Q+FR1
	WL	2,S4KI3Q+FR2
	WL	2,S4KI3Q+FR3
	WL	2,S4KI3Q+FR4
	WL	2,S4KI3Q+FR5
	.word	ANI_ATTACK_ON,AMODE_HEADKNEES,50,56,49,50
	WL	4,S4KI3Q+FR6
	.word	ANI_ATTACK_OFF

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#missed2
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#rpt_loop
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#missed2

	;do a spin kick
	.word	ANI_DETACH
	WL	ANI_SET_YVEL,60000h

	;jump
	WL	2,S4SK3Y+FR3
	WL	2,S4SK3Y+FR4
	WL	2,S4SK3Y+FR5
	WL	2,S4SK3Y+FR6
	WL	2,S4SK3Y+FR7

	.word	ANI_ATTACK_ON,AMODE_SPINKICK,22,91-24-20,47,19+20
	WL	6,S4SK3Y+FR8
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missed
	.word	ANI_ZERO_XZVELS
	WLW	ANI_SET_ZVEL,20000h,AM_ABS
#missed
	WL	4,S4SK3Y+FR9
	WL	4,S4SK3Y+FR10
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	4,S4SK3Y+FR11
	WL	4,S3GU2A+FR9

	.word	ANI_FACEUP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed2
	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#missed3
	.ref	shn_flying_kick_anim
	WL	ANI_CHANGEANIM,shn_flying_kick_anim
	.word	ANI_END
#missed3
	WL	3,S4KI3Q+FR8
	WL	3,S4KI3Q+FR9
	WL	3,S4KI3Q+FR4
	WL	3,S4KI3Q+FR3
	WL	3,S4KI3Q+FR2
	WL	3,S4KI3Q+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#exit
	.word	ANI_DETACH
	WL	4,S4KI3Q+FR7
	WL	4,S4KI3Q+FR8
	WL	4,S4KI3Q+FR9
	WL	4,S4KI3Q+FR4

	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************

 SUBR	shn_knee_fstein_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_SET_RPTCOUNT,4	;3 times
#rpt_loop
	.word	ANI_CLR_BUTCOUNT

;kick
	WL	2,S4KM3C+FR2
	WL	2,S4KM3C+FR3
	WL	2,S4KM3C+FR4
	WL	ANI_SET_YVEL,20000h
	.word	ANI_ATTACK_ON, AMODE_HEADKNEES,27,59,68,20	;mode,x,y,w,h
	WL	2,S4KM3C+FR5
	.word	ANI_ATTACK_OFF
	WL	2,S4KM3C+FR6
	WL	2,S4KM3C+FR7
	WL	2,S4KM3C+FR8

	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#exit
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#rpt_loop
	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#exit

;fstein
	WLW	ANI_SET_XVEL,68000h,AM_FACE_REL
	WL	ANI_SET_YVEL,50000h
	WL	ANI_CHANGEANIM,shn_fstein2_anim

#exit
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#exit2
	.word	ANI_DETACH
	WL	ANI_CHANGEANIM,shn_4_bslam_anim
	.word	ANI_END
#exit2
	.word	ANI_DETACH
	WL	3,S4NM3A+FR5
	WL	3,S4NM3A+FR6
	WL	3,S4NM3A+FR7

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#******************************************************************************

 SUBR	shn_4_taunt_anim

	.word	ANI_SETMODE,MODE_UNINT
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	4,S4CO4A+FR1
	WL	4,S4CO4A+FR2
	WL	4,S4CO4A+FR3
	WL	4,S4CO4A+FR4
	WL	4,S4CO4A+FR5
	WL	4,S4CO4A+FR6
	WL	4,S4CO4A+FR7
	WL	4,S4CO4A+FR8
	WL	4,S4CO4A+FR7
	WL	4,S4CO4A+FR6
	WL	4,S4CO4A+FR5
	WL	4,S4CO4A+FR4
	WL	4,S4CO4A+FR3
	WL	4,S4CO4A+FR2
	WL	4,S4CO4A+FR3
	WL	4,S4CO4A+FR4
	WL	4,S4CO4A+FR5
	WL	4,S4CO4A+FR6
	WL	4,S4CO4A+FR7
	WL	4,S4CO4A+FR8
	WL	4,S4CO4A+FR7
	WL	4,S4CO4A+FR6
	WL	4,S4CO4A+FR5
	WL	4,S4CO4A+FR4
	WL	4,S4CO4A+FR3
	WL	4,S4CO4A+FR2
	WL	4,S4CO4A+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,shn_stand4_anim
	.word	ANI_END

#*****************************************************************************
*
* REALLY BITCHIN' #3 TWO-FOOTED RUNNING STOMP
*

#yoff	equ	15

 SUBR	shn_run_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETSPEED,100h

	.word	ANI_CLR_BUTCOUNT
	.word	ANI_SET_RPTCOUNT,4

	WL	4,S4MP4D+FR1
	.word	ANI_OFFSET,0,#yoff,0

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 20,999,100,60,90000h,TGT_GROIN,19,9,0
	WL	ANI_CODE,no_bk_xvel

	WL	4,S4MP4D+FR2
	WL	4,S4MP4D+FR3
	WL	4,S4MP4D+FR4
	WL	ANI_SET_YVEL,-20000h
	WL	ANI_GOTO,#attack

#attack_loop
	.word	ANI_CLR_BUTCOUNT
	WWL	ANI_SETLONG,OBJ_GRAVITY,0a000h
	WL	ANI_SET_YVEL,60000h

	WL	2,S4MP4D+FR6
	WL	2,S4MP4D+FR7
	WL	2,S4MP4D+FR8
	WL	2,S4MP4D+FR1
	.word	ANI_OFFSET,0,#yoff,0
	WL	2,S4MP4D+FR2
	WL	2,S4MP4D+FR2
	WL	4,S4MP4D+FR3
	WL	4,S4MP4D+FR4

#attack
	.word	ANI_ATTACK_ON,AMODE_STOMP,-18,3-12,56,43+12
	WWL	ANI_WAITHITOPP,12,S4MP4D+FR5
	.word	ANI_ZEROVELS
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY
#atk_on
	.word	ANI_ATTACK_OFF

	;check for a good hit
	WL	ANI_IFNOTSTATUS,#missed
	WWL	ANI_IFOPPMODE,~MODE_ONGROUND,#missed

	;hit.  shake ring & ropes
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IFNOT_RPTCOUNT,#done

	;any button will do
	WWWL	ANI_IF_BUTCOUNT_GE,KICKB_COUNT,2,#attack_loop
	WWWL	ANI_IF_BUTCOUNT_GE,SKICKB_COUNT,2,#attack_loop
	WWWL	ANI_IF_BUTCOUNT_GE,PUNCHB_COUNT,2,#attack_loop
	WWWL	ANI_IF_BUTCOUNT_GE,SPUNCHB_COUNT,2,#attack_loop

	;no presses.  bounce off.

#done
	WL	ANI_SET_YVEL,48000h
	WLW	ANI_SET_XVEL,28000h,AM_FACE_REL
	WLW	ANI_SET_ZVEL,18000h,AM_ABS
	WL	4,S4MP4D+FR2
	WL	1,S4MP4D+FR3
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	2,S4MP4D+FR6
	WL	2,S4MP4D+FR7
	WL	2,S4MP4D+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* Head slams into mat
;From head slam - repeated head slam

 SUBR	shn_break_face2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	.word	ANI_ZEROVELS

	WL	2,S3CF3Z+FR1
	WL	ANI_SET_YVEL,80000h
	WL	3,S3CF3Z+FR2
	WL	3,S3CF3Z+FR3
	WL	3,S3CF3Z+FR4
	WL	3,S3CF3Z+FR5
	WL	3,S3CF3Z+FR6
	.word	ANI_WAITHITGND
	.word	ANI_END
	

* Head slams into mat
;From head slam

 SUBR	shn_break_face_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	.word	ANI_ZEROVELS

	WL	3,S3CF3Z+FR1
	WL	ANI_SET_YVEL,40000h
	WL	3,S3CF3Z+FR2
	WL	3,S3CF3Z+FR3
	WL	3,S3CF3Z+FR4
	WL	3,S3CF3Z+FR5
	WL	3,S3CF3Z+FR6
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,S3CF3Z+FR1
	WL	3,S3CF3Z+FR2
	WL	3,S3CF3Z+FR3
	WL	3,S3CF3Z+FR4
	WL	3,S3CF3Z+FR5
	WL	3,S3CF3Z+FR6

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	3,S3CF3Z+FR1
	.word	ANI_WAITROLL

	WL	ANI_CHANGEANIM,shn_faceup_getup_anim
	.word	ANI_END
	

#*****************************************************************************
*
* SLIDING KICKTOSS
*

 SUBR	shn_sliding_kicktoss_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

;	.word	ANI_IFOPP,W_SHAWN,-1
;	WL	ANI_IFNOTSTATUS,#missed

	.word	ANI_STARTATTACK,AT_PUPPET,15

	WL	3,S3SK3A+FR1
	WL	3,S3SK3A+FR2

	LEAPATOPP 16,999,180,100,90000h,TGT_FEET,0,0,0
	WL	ANI_SET_YVEL,0

	.word	ANI_FRICTION,4000h

	WL	3,S3SK3A+FR3
	WL	3,S3SK3A+FR4
	WL	3,S3SK3A+FR5

	.word	ANI_CLR_STATUS
	.word	ANI_ATTACK_ON,AMODE_PUPPET,-72,0,72,15
	.word	ANI_XFLIP
	WWL	ANI_WAITHITOPP,10,S3SK3A+FR6
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#blocked

	;hit.  toss him over.
	WL	ANI_CODE,CALL_ANI_AVERAGE_MOVE

	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_ATTACHZ,0,0,-4
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	.word	ANI_FRICTION,05000h
	WWLLW	ANI_SUPERSLAVE2,10,S3SK3A+FR6,#puppet_tbl,0
	WL	ANI_CODE,#grunt
	.word	ANI_XFLIP
	WWLLW	ANI_SUPERSLAVE2,4,S3KT3A+FR2,#puppet_tbl,1
	.word	ANI_ZEROVELS
	WWLLW	ANI_SUPERSLAVE2,4,S3KT3A+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,S3KT3A+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,S3KT3A+FR5,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,2,S3KT3A+FR6,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,2,S3KT3A+FR7,#puppet_tbl,6

	;let go
	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_XFLIP_OPP		;106
	WL	ANI_SLAVEANIM,#release_tbl
	WL	ANI_OPPOFFSET,#release_offsets
	WLW	ANI_SET_OPP_XVEL,-20000h,AM_FACE_REL
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,35
	.word	ANI_DAMAGEOPP,D_KICKTOSS
	.word	ANI_SOUND,0BFh
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_DETACH

	;and immediately get up
	WL	4,S3KT3A+FR8
	.word	ANI_OFFSET,-9,2,0
	WL	4,S3FD3X+FR1
	WL	4,S3UC3X+FR6
	WL	4,S3KF3C+FR1
	WL	4,S3KF3C+FR2
	WL	4,S3KF3C+FR3
	.word	ANI_WAITHITGND
	WL	4,S3KF3C+FR4
	WL	4,S3KF3C+FR5

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#blocked
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	10,S3SK3A+FR6
	.word	ANI_ZEROVELS
	WL	50,S3SK3A+FR6
#missed
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	10,S3SK3A+FR6
	.word	ANI_ZEROVELS
	WL	50,S3SK3A+FR6
	.word	ANI_WAITROLL

	WL	ANI_CHANGEANIM,shn_faceup_getup_anim
	.word	ANI_END

#abort
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#grunt	WRSND	W_SHAWN,GRABFLING_T1,GRABFLING_T2
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
	.ref	H2AM3A,H3FR3A
 LWWW H2AM3A+FR1,-20,58,0
 LWWW H2AM3A+FR7,58,40,0
 LWWW H3FR3A+FR2,40,38,0
 LWWW H3FR3A+FR3,26,45,0
 LWWW H3FR3A+FR4,14,59,0
 LWWW H3FR3A+FR4,-30,55,0
 LWWW H3FR3A+FR6,-70,7,0
 .long 0
#Razor
	.ref	R3TD3A
 LWWW R3TD3A+FR1,-20,65,0
 LWWW R3TD3A+FR2,51,35,0
 LWWW R3TD3A+FR4,28,32,0
 LWWW R3TD3A+FR5,25,31,0
 LWWW R3TD3A+FR6,9,43,0
 LWWW R3TD3A+FR7,-25,59,0
 LWWW R3TD3A+FR8,-63,29,0
 .long 0
#Taker
	.ref	U4AM4C,U3FH3A
 LWWW U4AM4C+FR4,-30,61,0
 LWWW U3FH3A+FR1,51,37,1
 LWWW U3FH3A+FR2,39,42,1
 LWWW U3FH3A+FR3,29,37,1
 LWWW U3FH3A+FR4,3,55,1
 LWWW U3FH3A+FR5,-32,72,1
 LWWW U3FH3A+FR5,-69,36,1
 .long 0
#Yokozuna
	.ref	Y3FL3W
 LWWW Y3FL3W+FR1,-20,64,0
 LWWW Y3FL3W+FR2,29,60,0
 LWWW Y3FL3W+FR3,17,41,0
 LWWW Y3FL3W+FR4,17,32,0
 LWWW Y3FL3W+FR5,13,38,0
 LWWW Y3FL3W+FR6,-23,57,0
 LWWW Y3FL3W+FR7,-62,26,0
 .long 0
#Shawn
 LWWW S3OS3X+FR3,-52,68,1
 LWWW S3OS3X+FR4,8,63,1
 LWWW S3OS3X+FR5,-8,42,1
 LWWW S3OS3X+FR6,1,48,1
 LWWW S3OS3X+FR7,2,60,1
 LWWW S3OS3X+FR8,-16,66,1
 LWWW S3OS3X+FR9,-68,41,1
 .long 0
#BamBam
	.ref	B4TD3B
 LWWW B4TD3B+FR2,-23,52,0
 LWWW B4TD3B+FR3,28,52,0
 LWWW B4TD3B+FR4,34,43,0
 LWWW B4TD3B+FR5,24,51,0
 LWWW B4TD3B+FR6,15,64,0
 LWWW B4TD3B+FR7,-21,65,0
 LWWW B4TD3B+FR8,-53,36,0
 .long 0
#Doink
	.ref	D3OS3A,D3FD3E
 LWWW D3OS3A+FR1,-13,41,0
 LWWW D3OS3A+FR2,14,41,0
 LWWW D3OS3A+FR3,7,38,0
 LWWW D3OS3A+FR4,3,31,0
 LWWW D3OS3A+FR5,4,37,0
 LWWW D3OS3A+FR6,-26,44,0
 LWWW D3FD3E+FR2,-64,5,0
 .long 0
#Adam
 .long 0
#Lex
	.ref	L4AM4B,L3FH3A
; LWWW L4AM4B+FR3,-34,66,0
 LWWW L3FH3A+FR1,-10,49,0
 LWWW L3FH3A+FR1,36,49,0
 LWWW L3FH3A+FR2,45,25,0
 LWWW L3FH3A+FR3,28,32,0
 LWWW L3FH3A+FR4,17,39,0
 LWWW L3FH3A+FR5,-17,39,0
 LWWW L3FH3A+FR6,-56,22,0
 .long 0

#release_tbl
	.ref	hrt_hitonground_anim,rzr_hitonground_anim
	.ref	und_hitonground_xflip_anim
	.ref	shn_hitonground_xflip_anim
	.ref	bam_hitonground_anim,dnk_hitonground_anim
	.ref	lex_hitonground_anim

	.long	hrt_hitonground_anim,rzr_hitonground_anim
	.long	und_hitonground_xflip_anim
	.long	yok_hitonground_anim
	.long	shn_hitonground_xflip_anim
	.long	bam_hitonground_anim,dnk_hitonground_anim
	.long	0,lex_hitonground_anim

#release_offsets
	;	X Y
	.word	40,0		;Bret
	.word	10,0		;Razor
	.word	40,0		;Taker
	.word	20,0		;Yokozuna
	.word	40,0		;Shawn
	.word	40,0		;BamBam
	.word	40,0		;Doink
	.word	40,0		;Adam
	.word	20,0		;Lex

#*****************************************************************************
*
* GRAB OPPONENT'S ARM AND BREAK IT (ouch)
*

 SUBR	shn_break_arm_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS

	WL	4,S4FG3A+FR1
	WL	4,S4FG3A+FR2

	;temp!  Don't throw the attack if we don't know the guy.
	.word	ANI_IFOPP,W_SHAWN,-1
	WL	ANI_IFNOTSTATUS,#missed

	.word	ANI_ATTACK_ON,AMODE_ARMBREAK,31,69,42,32
	WL	4,S4FG3A+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WWL	ANI_IFOPPMODE,~MODE_PUPPET,#missed


	;got him
	.word	ANI_RAWSOUND,2055		;big cheer #1
	.word	ANI_ATTACHZ,0,0,-4
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED
	WWLLW	ANI_SUPERSLAVE2,3,S3GA3A+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,S3GA3A+FR2,#puppet_tbl,1
;	WWLLW	ANI_SUPERSLAVE2,3,S3GA3A+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,S3GA3A+FR4,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,16,S3GA3A+FR5,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,2,S3GA3A+FR6,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,2,S3GA3A+FR7,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,2,S3GA3A+FR8,#puppet_tbl,7

	;snap!
;	.word	ANI_SOUND,1Bh			;smak
	.word	ANI_SOUND,33h			;bone crunch #0
	WL	ANI_CODE,CALL_SPECIAL_MOVE
	WWLLW	ANI_SUPERSLAVE2,1,S3GA3A+FR9,#puppet_tbl,8
	WL	ANI_SLAVEANIM,#react_tbl
	.word	ANI_DETACH

	WL	9,S3GA3A+FR9
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#missed
	WL	4,S4FG3A+FR2
	WL	4,S4FG3A+FR1

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
 .long 0
#Razor
 .long 0
#Taker
 .long 0
#Yokozuna
 .long 0
#Shawn
 LWWW S2PU3C+FR3,33,-5,0
 LWWW S3AB3A+FR1,47,4,0
 LWWW S3AB3A+FR2,36,-2,0
 LWWW S3AB3A+FR3,42,-4,0
 LWWW S3AB3A+FR3,45,-3,0
 LWWW S3AB3A+FR3,45,-2,0
 LWWW S3AB3A+FR3,39,-6,0
 LWWW S3AB3A+FR3,39,-5,0
 LWWW S3AB3A+FR4,33,5,0
#BamBam
 .long 0
#Doink
 .long 0
#Adam
 .long 0
#Lex
 .long 0

#react_tbl
	.long	0,0
	.long	0,0
	.long	shn_arm_broken_anim,0
	.long	0,0,0

#*****************************************************************************
*
* Special functions
*

#*********
;zeros the wrestler's x-velocity if he's flying backwards.  Useful just
; after a LEAPAT.

 SUBR	no_bk_xvel

	move	*a13(OBJ_XVEL),a0,L
	move	*a13(FACING_DIR),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#abs
	neg	a0
#abs

	move	a0,a0
	jrnn	#ok

#clrvel
	clr	a14
	move	a14,*a13(OBJ_XVEL),L
#ok
	rets

#*****************************************************************************

	.bss	#opp_xvel,32

 SUBR	shn_3_head_hold2_anim

;Head hold when standing next to player
;No collisions possible
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold

	WL	2,S4GH3C+FR1
	WL	2,S4GH3C+FR2
	WL	2,S4GH3C+FR3
	.word	ANI_ATTACK_ON, AMODE_PUPPET3,32,60,62,45 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,7,S4GH3C+FR3
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_GOTO,#gothim

 SUBR	shn_3_head_hold_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold
	.word	ANI_STARTATTACK,AT_LEAPING,6

	WL	3,S4GH3C+FR1
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 9,999,60,40,90000h,TGT_HEAD,56,93,8
	WL	3,S4GH3C+FR2

	.word	ANI_ATTACK_ON, AMODE_PUPPET,26,80,49,23 ;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,3,S4GH3C+FR3
	WWL	ANI_WAITHITOPP,6,S4GH3C+FR3

	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	WL	ANI_IFBLOCKED,#missed

#gothim

	WL	ANI_CODE,CALL_SETUP

	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,4,S4GH3C+FR3,#puppet_tbl,0

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WWLLW	ANI_SUPERSLAVE2,4,S4GH3C+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,S4GH3C+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,S4GH3C+FR8,#puppet_tbl,3

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	4,S4GH3C+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	15,S4GH3C+FR3
	WL	3,S4GH3C+FR2
	WL	3,S4GH3C+FR1

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
 LWWW H2AH3A+FR1,37,18,0
 LWWW H3HB3A+FR3,37,5,0
 LWWW H3HB3A+FR2,30,-3,0
 LWWW H3HB3A+FR1,47,-31,0
 .long 0
#Razor
 LWWW R3HB3A+FR3,48,-1,0
 LWWW R3HB3A+FR3,48,3,0
 LWWW R3HB3A+FR2,47,-14,0
 LWWW R3BF3A+FR1,60,-32,0
 .long 0
#Taker
 LWWW U4AM4C+FR2,38,7,0
 LWWW U4BF3A+FR2,36,15,0
 LWWW U4BF3A+FR3,6,0,0
 LWWW U4BF3Z+FR3,54,-19,0
 .long 0
#Yokozuna
 LWWW Y3LB3A+FR2,42,9,0
 LWWW Y3LB3A+FR2,42,13,0
 LWWW Y3LB3A+FR9,34,-12,0
 LWWW Y3BF3A+FR1,58,-20,0
 .long 0
#Shawn
 LWWW S4AH3D+FR5,51,5,0
 LWWW S4BF3A+FR2,40,-5,0
 LWWW S4BF3A+FR3,18,-19,0
 LWWW S3BF3A+FR1,40,-34,0
 .long 0
#BamBam
 LWWW B4BF3A+FR1,44,12,0
 LWWW B4BF3A+FR1,44,16,0
 LWWW B3HB3A+FR2,39,-20,0
 LWWW B3BF3C+FR5,63,-24,0
 .long 0
#Doink
 LWWW D3AK3A+FR3,27,10,0
 LWWW D3AK3A+FR3,27,14,0
 LWWW D3AK3A+FR2,45,-3,0
 LWWW D3BF3A+FR1,56,-30,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L2AH2A+FR3,27,3,0
 LWWW L3BF3A+FR1,46,6,1
 LWWW L3BF3A+FR2,41,-11,1
 LWWW L3BF3B+FR2,49,-36,0
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
* FLIP-SLAM

 SUBR	shn_flipslam_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETSPEED,100h

	;first, if we're holding his head, let him go.
	WWL	ANI_IFOPPMODE,~MODE_HEADHELD,#no_hdrel
	.word	ANI_DETACH
#no_hdrel
	.word	ANI_STARTATTACK,AT_LEAPING,11

	WL	3,S4TD3F+FR1
	LEAPATOPP 10,999,90,60,90000h,TGT_CHEST,8,68,-10
	WL	ANI_CODE,#check_xvel
	.word	ANI_SETPLYRMODE,MODE_INAIR
	WL	4,S4TD3F+FR2
	WL	4,S4TD3F+FR3
	.word	ANI_ATTACK_ON,AMODE_PUPPET,-13,56,28,39 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,S4TD3F+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb

	;got him.
	WLW	ANI_SET_XVEL,40000h,AM_FACE_REL
	WL	ANI_SET_YVEL,58000h	;Y
	WL	ANI_CODE,ckzpos		;Z
	WWL	ANI_SETLONG,OBJ_GRAVITY,0B000h

	.word	ANI_ATTACHZ,0,0,-10		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,6,S4TD3F+FR4,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,S4TD3F+FR5,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,S4TD3F+FR6,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,S4TD3F+FR7,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,2,S4TD3F+FR8,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,2,S4TD3F+FR9,#puppet_tbl,6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_DAMAGEOPP,D_FLIPSLAM
	.word	ANI_SHAKER,40
	.word	ANI_SHAKEALL,2
	WWLLW	ANI_SUPERSLAVE2,4,S3OS3Z+FR10,#puppet_tbl,7

	WL	ANI_SLAVEANIM,#release_tbl
	WL	ANI_CODE,#set_opp_facing
	.word	ANI_DETACH
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,shn_hitonground_anim

#missedb
	;blocked.  bounce off.
	WL	ANI_CODE,#reverse_xvel

#missed
	WL	ANI_CODE,CALL_MISSES
	WL	3,S4TD3F+FR5
	WL	3,S4TD3F+FR6
	WL	3,S4TD3F+FR7
	WL	3,S4TD3F+FR8
	WL	3,S4TD3F+FR9
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_SHAKER,35
	.word	ANI_SHAKEALL,1
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,shn_hitonground_anim



**********
;halve and reverse xvel

 SUBRP	#reverse_xvel

	move	*a13(OBJ_XVEL),a14,L
	neg	a14
	sra	1,a14
	move	a14,*a13(OBJ_XVEL),L
	rets

**********
;Don't leap backwards.  If the player tries it, give him a small
; forward velocity instead.  Sucker.  (and clear his Z too)

 SUBRP	#check_xvel

	move	*a13(FACING_DIR),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#facing_right

;facing_left
	move	*a13(OBJ_XVEL),a0,L
	jrn	#done0

	movi	[-2,0],a0
	jruc	#set

#facing_right
	move	*a13(OBJ_XVEL),a0,L
	jrp	#done0
	movi	[2,0],a0
#set
	move	a0,*a13(OBJ_XVEL),L
	clr	a0
	move	a0,*a13(OBJ_ZVEL),L
#done0
	rets

**********
;for whatever reason, we need to reverse the victim's X-facing before
; we let him go or else the roll-over won't work properly.  Voodoo...

 SUBRP	#set_opp_facing

	move	*a13(ATTACH_PROC),a10,L
	jrz	#done1
	move	*a10(FACING_DIR),a4
	xori	MOVE_LEFT|MOVE_RIGHT,a4
	move	a4,*a10(FACING_DIR)
#done1
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
 LWWW H3HB3A+FR2,5,9,0
 LWWW H3HB3A+FR3,10,9,0
 LWWW H3UC3X+FR1,-3,15,0
 LWWW H3UC3X+FR2,-29,3,0
 LWWW H3UC3X+FR3,-48,-5,0
 LWWW H3UC3X+FR4,-38,4,0
 LWWW H3UC3X+FR5,1,42,0
 LWWW H3UC3X+FR6,59,38,0
#Razor
 LWWW R3HB3A+FR2,7,0,0
 LWWW R3HB3A+FR3,2,7,0
 LWWW R3FD3B+FR1,-3,25,0
 LWWW R3FD3B+FR2,-25,8,0
 LWWW R3FD3B+FR3,-42,3,0
 LWWW R3FD3B+FR4,-48,10,0
 LWWW R3FD3B+FR5,-23,35,0
 LWWW R3HG3B+FR1,54,42,0
#Taker
 LWWW U3TBSM+FR9,-3,11,1
 LWWW U3FD3X+FR1,-4,17,1
 LWWW U3FD3X+FR2,-10,15,1
 LWWW U3FD3X+FR3,-11,9,1
 LWWW U3FD3X+FR4,-18,-5,1
 LWWW U3FD3X+FR5,6,24,1
 LWWW U3FD3X+FR6,28,50,1
 LWWW U3GP3X+FR1,65,40,1
#Yokozuna
 LWWW Y4AM4A+FR3,1,-1,0
 LWWW Y4AM4A+FR1,8,10,0
 LWWW Y3FD3A+FR1,-1,13,0
 LWWW Y3FD3A+FR2,-35,25,0
 LWWW Y3FD3A+FR3,-42,14,0
 LWWW Y3FD3A+FR4,-41,19,0
 LWWW Y3FD3A+FR5,-17,44,0
 LWWW Y3FD3N+FR1,46,57,0
#Shawn
 LWWW S4BF3A+FR2,8,12,0
 LWWW S2AH3A+FR1,6,14,0
 LWWW S3UC3X+FR1,4,20,0
 LWWW S3UC3X+FR2,-17,3,0
 LWWW S3UC3X+FR4,-34,-14,0
 LWWW S3UC3X+FR5,-21,4,0
 LWWW S3UC3X+FR6,21,42,0
 LWWW S3FD3X+FR1,51,38,0
#BamBam
 LWWW B3DR3B+FR5,15,8,0
 LWWW B4AH4A+FR6,-3,15,0
 LWWW B4UC3B+FR1,-3,27,0
 LWWW B4UC3B+FR2,-10,3,0
 LWWW B4UC3B+FR3,-35,-16,0
 LWWW B4UC3B+FR4,-34,-15,0
 LWWW B4UC3B+FR5,-11,38,0
 LWWW B4UC3B+FR6,54,45,0
#Doink
 LWWW D3AK3A+FR2,8,8,0
 LWWW D3UC3A+FR1,1,10,0
 LWWW D3UC3A+FR2,-1,21,0
 LWWW D3UC3A+FR3,-11,11,0
 LWWW D3UC3A+FR5,-37,-5,0
 LWWW D3UC3A+FR6,-24,-1,0
 LWWW D3UC3A+FR7,13,40,0
 LWWW D3UC3A+FR9,63,38,0
#Adam
 .long 0
#Lex
 LWWW L4GH3B+FR4,-19,6,0
 LWWW L3UC3X+FR1,-4,12,0
 LWWW L3UC3X+FR2,-6,7,0
 LWWW L3UC3X+FR3,-27,-8,0
 LWWW L3CP3X+FR2,-48,-19,1
 LWWW L3CP3X+FR3,-42,9,1
 LWWW L3CP3X+FR4,-13,42,1
 LWWW L3UC3X+FR8,62,48,0

#release_offsets
	;	X Y
	.word	0,0		;Bret
	.word	0,0		;Razor
	.word	0,0		;Taker
	.word	0,0		;Yokozuna
	.word	0,0		;Shawn
	.word	0,0		;BamBam
	.word	25,0		;Doink
	.word	0,0		;Adam
	.word	0,0		;Lex

#release_tbl
	.long	hrt_break_neck_anim,rzr_break_neck4_anim
	.long	und_break_neck_anim,yok_break_neck_anim
	.long	shn_fall_back3_anim,bam_break_neck4_anim
	.long	dnk_break_neck_anim,0,lex_break_neck4_anim
******************************************************************************

	.end
