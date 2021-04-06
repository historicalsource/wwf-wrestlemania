**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		5/12/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"rzrseq3.asm"
	.title	"Razor Ramon animation sequences"
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

	.include	"display.equ"
	.include	"damage.equ"

	.include	"bamimg.h"
	.include	"bretimg.h"
	.include	"razorimg.h"
	.include	"takerimg.h"
	.include	"yokoimg.h"
	.include	"shawnimg.h"
	.include	"doinkimg.h"
	.include	"leximg.h"

	.include	"miscimg.glo"	;temp!!!

******************************************************************************
* EXTERNAL REFERENCES

	.ref	MOVE_NAME_ANNC

	;BRET
	.ref	hrt_hitonground_anim,hrt_3_head_held_anim
	.ref	hrt_flyout_anim,hrt_break_neck2_anim
	.ref	H2AH3A,H2AM3A,H2CP3A,H3BF3A,H3DU3A,H3FR3A,H3GU4A
	.ref	H3HB3A,H3RR3Z,H3PP3X,H3UC3X

	;BAM BAM
	.ref	bam_hitonground_xflip_anim,bam_break_neck2_anim
	.ref	bam_flyout_anim,bam_3_head_held_anim
	.ref	bam_hitonground_anim
	.ref	B3BF3C,B3GU4A,B3RR3Z,B4TD3B,B4BF3A,B3HB3A
	.ref	B3FD3C,B3PP3Q,B4UC3B,B2AH2A

	;DOINK
	.ref	dnk_hitonground_anim,dnk_break_neck2_anim
	.ref	dnk_flyout_anim,dnk_3_head_held_anim
	.ref	D3AE3B,D3BF3A,D3FD3E,D3GU4A,D3HT3Z,D3OS3A
	.ref	D3PM4C,D3RR3Z,D3SA3A,D3UC3A,D4SK4A,D3AK3A,D3PD3Z

	;LEX
	.ref	lex_hitonground_anim,lex_flyout_anim
	.ref	lex_3_head_held_anim,lex_break_neck2_anim
	.ref	L3BF3B,L3CP3X,L3DU3A,L3FH3A,L4AM4B,L3BF3A,L4AH4B
	.ref	L3RR3Z,L3FD3B,L3GP3Z,L3UC3X

	;RAZOR
	.ref	rzr_hitonground_anim,rzr_flyout_anim
	.ref	rzr_facedown_getup_anim,rzr_break_neck2_anim
	.ref	rzr_dizzy_anim,rzr_faceup_getup_anim,rzr_stand4_anim
	.ref	rzr_faceup_getup2_anim,rzr_flying_kick_anim
	.ref	rzr_combo_uppercut_anim

	;SHAWN
	.ref	shn_hitonground_anim,shn_flyout_anim
	.ref	shn_3_head_held_anim,shn_break_neck2_anim
	.ref	S3BF3A,S3GU4A,S3OS3X,S4BF3A,S4AH3D,S3RR3Z
	.ref	S3FD3X,S3GP3X,S3UC3X

	;TAKER
	.ref	und_hitonground_anim,und_flyout_anim,und_3_head_held_anim
	.ref	und_break_neck2_anim
	.ref	U3AE4A,U3CP3B,U3DU3B,U3FH3A,U4AM4C,U4BF3Z,U4BF3A
	.ref	U3RR3Z,U3PP3X,U3GP3X,U2AH3A,U3FD3X

	;YOKO
	.ref	yok_hitonground_anim,yok_break_neck2_anim
	.ref	yok_3_head_held_anim,yok_flyout_anim
	.ref	Y3BF3A,Y3GU2A,Y3LB3A,Y3FL3W,Y3FD3A,Y3RL1A,Y3RR3Z
	.ref	Y3FD3N,Y3PP3Q,Y3BF3A

	;MISC
	.ref	CALL_MISSES,am_I_dizzy,make_norm,make_white,tbukl_flip
	.ref	set_my_pal,set_position,set_skeleton_pal,face_inside
	.ref	set_my_pal,set_position,set_skeleton_pal
	.ref	start_smoke,SMALL_BOUNCE,CALL_SETUP,halve_bk_xvel
	.ref	set_xdrift,B4CD3A,HIT_THE_MAT,DO_GRUNT
	.ref	CALL_SPECIAL_MOVE,process_ptrs,DO_COMBO_MESS
	.ref	DO_RAZOR_RUG_SPEECH,DO_NONO,FIND_AND_KILL_ENDLESS
	.ref	CALL_THROWN_OUT,clear_opp_counts


#*****************************************************************************
*
* RUG SHAKE
 SUBR	rzr_combo_rugshake_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_STARTATTACK,AT_PUPPET,16

	WL	3,R3RG3B+FR1
	WL	3,R3RG3B+FR2
	WL	3,R3RG3B+FR3
	WL	3,R3RG3B+FR4

	.word	ANI_ATTACK_ON, AMODE_PUPPET,38,2,400,38
	WL	4,R3RG3B+FR5
	.word	ANI_ATTACK_OFF

;check if we hit
	WL	ANI_IFNOTSTATUS,#missedcx

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_KEEPATTACHED
	.word	ANI_ATTACHZ,0,0,-4

	.word	ANI_SET_RPTCOUNT,4
#loopcx
	.word	ANI_CLR_BUTCOUNT

	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR6,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR7,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR8,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR9,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR10,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR11,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR12,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR13,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR14,#puppet_tbl,8
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR15,#puppet_tbl,9

	WL	ANI_CODE,DO_RAZOR_RUG_SPEECH

	.word	ANI_DEBRISAT,100,1,0,8,0	;%chance,tbl index,x,y,z off
	.word	ANI_SHAKER,30
	.WORD	ANI_INC_COMBO
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	WL	ANI_CODE,impact_sound
	.word	ANI_DAMAGEOPP,D_RUGSLAM,RD_RUGSLAM

	WWLLW	ANI_SUPERSLAVE2,4,R3RG3B+FR16,#puppet_tbl,10

	.word	ANI_DEC_RPTCOUNT
	;limit of 5 hits
	WL	ANI_IFNOT_RPTCOUNT,#donecx

	;must hit super punch between hits to continue
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#donecx

	WL	ANI_GOTO,#loopcx

#donecx
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_SLAVEANIM,#release_tbl
	.word	ANI_DETACH
	WL	15,R3RG3B+FR16
	.word	ANI_OFFSET,0,0,-15			;x,y,z
	WL	4,R3RG3B+FR4
	.word	ANI_SETFACING
	.word	ANI_FACEDOWN
	WL	4,R3RG3B+FR3
	WL	4,R3RG3B+FR2
	WL	4,R3RG3B+FR1

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedcx
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_CODE,CALL_MISSES
	WL	4,R3RG3B+FR4
	WL	4,R3RG3B+FR3
	WL	4,R3RG3B+FR2
	WL	4,R3RG3B+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

*****************************************************************************

 SUBR	rzr_rugshake_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_STARTATTACK,AT_PUPPET,16

	WL	3,R3RG3B+FR1
	WL	3,R3RG3B+FR2
	WL	3,R3RG3B+FR3
	WL	3,R3RG3B+FR4

	.word	ANI_ATTACK_ON, AMODE_PUPPET,38,2,40,38
	WL	3,R3RG3B+FR5
	.word	ANI_ATTACK_OFF

;check if we hit
	.WORD	ANI_ADD_MOVE,MOVE_C_6,2,2
	WL	ANI_IFNOTSTATUS,missed_rug
pickup
	.word	ANI_DRAW_NAME,3
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_KEEPATTACHED
	.word	ANI_ATTACHZ,0,0,-4

	.word	ANI_SET_RPTCOUNT,4
;	.word	ANI_SETOPPMODE,MODE_NOSHADOW
#loop
rpt_slam
	.word	ANI_CLR_BUTCOUNT

	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR6,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR7,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR8,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR9,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR10,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR11,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR12,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR13,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR14,#puppet_tbl,8
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR15,#puppet_tbl,9

	WL	ANI_CODE,DO_RAZOR_RUG_SPEECH

	.word	ANI_DEBRISAT,100,1,0,8,0	;%chance,tbl index,x,y,z off
	.word	ANI_SHAKER,30
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	WL	ANI_CODE,impact_sound
	.word	ANI_DAMAGEOPP,D_RUGSLAM,RD_RUGSLAM

	WWLLW	ANI_SUPERSLAVE2,4,R3RG3B+FR16,#puppet_tbl,10

	.word	ANI_DEC_RPTCOUNT
	
	;first two are free
	WWL	ANI_IF_RPTCOUNT_GE,4,#loop

	;limit of 5 hits
	WL	ANI_IFNOT_RPTCOUNT,#done

	;must hit super punch three times between hits to continue
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,2,#done0
	WL	ANI_GOTO,#loop

#done0	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,2,#done
	WL	ANI_GOTO,#loop

#done
;	WL	ANI_CODE,CALL_SPECIAL_MOVE
	WL	ANI_SLAVEANIM,#release_tbl
;	.word	ANI_CLROPPMODE,MODE_NOSHADOW
	.word	ANI_DETACH
	WL	15,R3RG3B+FR16
	.word	ANI_OFFSET,0,0,-15			;x,y,z
	WL	4,R3RG3B+FR4
	.word	ANI_SETFACING
	.word	ANI_FACEDOWN
	WL	4,R3RG3B+FR3
	WL	4,R3RG3B+FR2
	WL	4,R3RG3B+FR1

;	.word	ANI_OFFSET,0,0,-15			;x,y,z
;	.word	ANI_FACEDOWN
;	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

missed_rug
	WL	ANI_CODE,CALL_MISSES
	WL	12,R3RG3B+FR6
	WL	4,R3RG3B+FR5
	WL	4,R3RG3B+FR4
	WL	4,R3RG3B+FR3
	WL	4,R3RG3B+FR2
	WL	4,R3RG3B+FR1
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


 SUBRP	impact_sound

	move	*a13(ATTACH_PROC),a0,L
	jrz	#x
	WRSNDX	a0,RUGSLAM_YELL,RUGSLAM_IMPACT
#x	rets


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
 LWWW H2CP3A+FR8,38,-50,1
 LWWW H3RR3Z+FR2,33,-29,1
 LWWW H3RR3Z+FR3,44,-35,1
 LWWW H3RR3Z+FR4,16,-7,1
 LWWW H3RR3Z+FR5,8,10,1
 LWWW H3RR3Z+FR6,-1,96,1
 LWWW H3RR3Z+FR7,-2,107,1
 LWWW H3RR3Z+FR7,9,102,1
 LWWW H3RR3Z+FR9,32,79,1
 LWWW H3RR3Z+FR9,61,68,1
 LWWW H2CP3A+FR8,40,-50,1
 .long 0
#Razor
 LWWW R3RR3Z+FR2,35,-48,1
 LWWW R3RR3Z+FR3,33,-36,1
 LWWW R3RR3Z+FR4,32,-43,1
 LWWW R3RR3Z+FR5,19,-11,1
 LWWW R3RR3Z+FR6,0,34,1
 LWWW R3RR3Z+FR7,-5,93,1
 LWWW R3RR3Z+FR8,-5,121,1
 LWWW R3RR3Z+FR8,9,119,1
 LWWW R3RR3Z+FR9,32,83,1
 LWWW R3RR3Z+FR9,57,72,1
 LWWW R3RR3Z+FR2,37,-48,1
 .long 0
#Taker
 LWWW U3CP3B+FR1,32,-45,1
 LWWW U3RR3Z+FR2,36,-22,1
 LWWW U3RR3Z+FR3,40,-18,1
 LWWW U3RR3Z+FR4,6,-6,1
 LWWW U3RR3Z+FR5,2,15,1
 LWWW U3RR3Z+FR6,4,88,1
 LWWW U3RR3Z+FR7,-36,113,1
 LWWW U3RR3Z+FR7,-24,112,1
 LWWW U3RR3Z+FR7,4,104,1
 LWWW U3RR3Z+FR9,45,81,1
 LWWW U3CP3B+FR1,34,-45,1
 .long 0
#Yokozuna
 LWWW Y3RL1A+FR1,32,-37,1
 LWWW Y3RR3Z+FR2,43,-26,1
 LWWW Y3RR3Z+FR3,28,-35,1
 LWWW Y3RR3Z+FR4,6,-3,1
 LWWW Y3RR3Z+FR5,-1,18,1
 LWWW Y3RR3Z+FR6,0,95,1
 LWWW Y3RR3Z+FR7,-8,111,1
 LWWW Y3RR3Z+FR7,7,111,1
 LWWW Y3RR3Z+FR9,31,82,1
 LWWW Y3RR3Z+FR9,53,74,1
 LWWW Y3RL1A+FR1,34,-37,1
 .long 0
#Shawn
 LWWW S3RR3Z+FR2,30,-47,1
 LWWW S3RR3Z+FR3,30,-32,1
 LWWW S3RR3Z+FR4,33,-30,1
 LWWW S3RR3Z+FR5,12,-7,1
 LWWW S3RR3Z+FR6,3,19,1
 LWWW S3RR3Z+FR7,6,88,1
 LWWW S3RR3Z+FR8,-25,114,1
 LWWW S3RR3Z+FR9,-36,89,1
 LWWW S3RR3Z+FR9,-6,83,1
 LWWW S3RR3Z+FR10,54,65,1
 LWWW S3RR3Z+FR2,32,-47,1
 .long 0
#BamBam
 LWWW B3RR3Z+FR2,40,-40,1
 LWWW B3RR3Z+FR3,28,-43,1
 LWWW B3RR3Z+FR4,47,-14,1
 LWWW B3RR3Z+FR5,13,-6,1
 LWWW B3RR3Z+FR6,0,25,1
 LWWW B3RR3Z+FR7,-10,119,1
 LWWW B3RR3Z+FR8,-14,135,1
 LWWW B3RR3Z+FR9,-14,102,1
 LWWW B3RR3Z+FR9,12,93,1
 LWWW B3RR3Z+FR10,62,60,1
 LWWW B3RR3Z+FR2,42,-40,1
 .long 0
#Doink
 LWWW D3GU4A+FR1,39,-47,1
 LWWW D3RR3Z+FR1,39,-40,1
 LWWW D3RR3Z+FR2,45,-28,1
 LWWW D3RR3Z+FR3,22,1,1
 LWWW D3RR3Z+FR4,11,35,1
 LWWW D3RR3Z+FR5,-1,94,1
 LWWW D3RR3Z+FR6,-2,103,1
 LWWW D3RR3Z+FR6,14,89,1
 LWWW D3RR3Z+FR7,35,74,1
 LWWW D3RR3Z+FR7,59,68,1
 LWWW D3GU4A+FR1,41,-47,1
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3RR3Z+FR1,37,-46,1
 LWWW L3RR3Z+FR2,34,-36,1
 LWWW L3RR3Z+FR3,25,-50,1
 LWWW L3RR3Z+FR4,11,-15,1
 LWWW L3RR3Z+FR5,6,2,1
 LWWW L3RR3Z+FR6,1,66,1
 LWWW L3RR3Z+FR7,-5,100,1
 LWWW L3RR3Z+FR8,-2,82,1
 LWWW L3RR3Z+FR8,25,76,1
 LWWW L3RR3Z+FR9,46,46,1
 LWWW L3RR3Z+FR1,39,-46,1
 .long 0

#release_tbl
	.long	hrt_hitonground_anim,rzr_hitonground_anim
	.long	und_hitonground_anim,yok_hitonground_anim
	.long	shn_hitonground_anim,bam_hitonground_anim
	.long	dnk_hitonground_anim,0,lex_hitonground_anim


#*****************************************************************************
*
* SLIDING RUG SHAKE

 SUBR	rzr_sliding_rug_anim

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETSPEED,100h
	.word	ANI_STARTATTACK,AT_PUPPET,15

	LEAPATOPP 15,999,150,90,90000h,TGT_FEET,0,0,10
	WL	ANI_SET_YVEL,20000h
	.ref	no_bk_xvel
	WL	ANI_CODE,no_bk_xvel

	.word	ANI_FRICTION,4000h

	WL	3,R3RC3R+FR1
	WL	3,R3RC3R+FR2
	WL	3,R3RC3R+FR3

	.word	ANI_ADD_MOVE,MOVE_C_6,2,2
	.word	ANI_ATTACK_ON, AMODE_PUPPET,28,2,34,38
	WWL	ANI_IFOPPMODE,MODE_ONGROUND,#pickup0
	WWL	ANI_WAITHITOPP,10,R3RC3R+FR4
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_OFF

;check if we hit
	WL	ANI_IFNOTSTATUS,missed_rug1
	WL	ANI_IFBLOCKED,missed_rug2
	WWL	ANI_IFOPPMODE,MODE_DEAD,missed_rug1
	.word	ANI_DRAW_NAME,3
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_KEEPATTACHED
	.word	ANI_ATTACHZ,0,0,-4

	WL	ANI_GOTO,#go

#pickup0
	WWL	ANI_WAITHITOPP,10,R3RC3R+FR4
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_OFF

;check if we hit
	WL	ANI_IFNOTSTATUS,missed_rug1
	WL	ANI_IFBLOCKED,missed_rug1
	WWL	ANI_IFOPPMODE,MODE_DEAD,missed_rug1

	WL	ANI_GOTO,pickup

missed_rug2
	WL	8,R3RC3R+FR4
missed_rug1
	WL	ANI_CODE,CALL_MISSES
	WL	14,R3RC3R+FR4
	WL	3,R3RC3R+FR3
	WL	3,R3RC3R+FR2
	WL	3,R3RC3R+FR1

;	WL	4,R3RG3B+FR5
;	WL	4,R3RG3B+FR4
;	WL	4,R3RG3B+FR3
;	WL	4,R3RG3B+FR2
;	WL	4,R3RG3B+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

*****************************************************************************
*
* RUG SHAKE FROM HEADHOLD

 SUBR	rzr_rugshake2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_STARTATTACK,AT_PUPPET,16

	.word	ANI_ATTACK_ON, AMODE_PUPPET,38,2,40,38
	WL	1,R3RG3B+FR3
	.word	ANI_ATTACK_OFF

;check if we hit
	.WORD	ANI_ADD_MOVE,MOVE_C_6,2,2
	WL	ANI_IFNOTSTATUS,missed_rug
	WL	ANI_IFBLOCKED,missed_rug

	.word	ANI_DRAW_NAME,3
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_KEEPATTACHED
	.word	ANI_ATTACHZ,0,0,-4


	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR3,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR4,#puppet_tbl,1
#go	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR5,#puppet_tbl,2
	.word	ANI_SET_RPTCOUNT,4

#loop
	.word	ANI_CLR_BUTCOUNT

	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR6,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR7,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR8,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR9,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR10,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR11,#puppet_tbl,8
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR12,#puppet_tbl,9
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR13,#puppet_tbl,10
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR14,#puppet_tbl,11
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR15,#puppet_tbl,12

	WL	ANI_CODE,DO_RAZOR_RUG_SPEECH

	.word	ANI_DEBRISAT,100,1,0,8,0	;%chance,tbl index,x,y,z off
	.word	ANI_SHAKER,30
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	WL	ANI_CODE,impact_sound
	.word	ANI_DAMAGEOPP,D_RUGSLAM,RD_RUGSLAM

	WWLLW	ANI_SUPERSLAVE2,4,R3RG3B+FR16,#puppet_tbl,13
	.word	ANI_SET_RPTCOUNT,3

	WL	ANI_GOTO,rpt_slam
;#missed
;	WL	ANI_CODE,CALL_MISSES
;	WL	12,R3RG3B+FR6
;	WL	4,R3RG3B+FR5
;	WL	4,R3RG3B+FR4
;	WL	4,R3RG3B+FR3
;	WL	4,R3RG3B+FR2
;	WL	4,R3RG3B+FR1
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END

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
 LWWW H3HB3A+FR1,40,-31,0
 LWWW H3HB3A+FR2,48,10,0
 LWWW H3HB3A+FR3,56,36,0
 LWWW H3UC3X+FR1,44,45,0
 LWWW H3UC3X+FR3,10,26,0
 LWWW H3UC3X+FR5,32,2,0
 LWWW H3RR3Z+FR4,16,-7,1
 LWWW H3RR3Z+FR5,8,10,1
 LWWW H3RR3Z+FR6,-1,96,1
 LWWW H3RR3Z+FR7,-2,107,1
 LWWW H3RR3Z+FR7,10,102,1
 LWWW H3RR3Z+FR9,32,79,1
 LWWW H3RR3Z+FR9,61,68,1
 LWWW H2CP3A+FR8,40,-50,1
 .long 0
#Razor
 LWWW R3HB3A+FR2,57,-13,0
 LWWW R3HB3A+FR3,58,13,0
 LWWW R2AH2D+FR6,67,46,0
 LWWW R3FD3B+FR2,36,47,0
 LWWW R3FD3B+FR3,28,33,0
 LWWW R3FD3B+FR5,26,-7,0
 LWWW R3RR3Z+FR5,19,1,1
 LWWW R3RR3Z+FR6,0,34,1
 LWWW R3RR3Z+FR7,-5,93,1
 LWWW R3RR3Z+FR8,-5,121,1
 LWWW R3RR3Z+FR8,9,119,1
 LWWW R3RR3Z+FR9,32,83,1
 LWWW R3RR3Z+FR9,57,72,1
 LWWW R3RR3Z+FR2,37,-48,1
 .long 0
#Taker
 LWWW U4BF3A+FR3,22,-2,0
 LWWW U4BF3A+FR2,46,28,0
 LWWW U4AH3A+FR2,55,55,0
 LWWW U3FD3X+FR2,53,54,1
 LWWW U3FD3X+FR3,44,38,1
 LWWW U3FD3X+FR4,31,-2,1
 LWWW U3RR3Z+FR4,6,-6,1
 LWWW U3RR3Z+FR5,3,15,1
 LWWW U3RR3Z+FR6,4,88,1
 LWWW U3RR3Z+FR7,-35,113,1
 LWWW U3RR3Z+FR7,-24,112,1
 LWWW U3RR3Z+FR7,4,104,1
 LWWW U3RR3Z+FR9,45,81,1
 LWWW U3CP3B+FR1,34,-46,1
 .long 0
#Yokozuna
 LWWW Y3LB3A+FR9,43,-13,0
 LWWW Y2AM2C+FR3,57,9,0
 LWWW Y2AM2C+FR1,66,35,0
 LWWW Y3FD3A+FR1,59,44,0
 LWWW Y3FD3A+FR2,24,60,0
 LWWW Y3FD3A+FR4,23,10,0
 LWWW Y3RR3Z+FR4,6,-4,1
 LWWW Y3RR3Z+FR5,-1,17,1
 LWWW Y3RR3Z+FR6,1,93,1
 LWWW Y3RR3Z+FR7,-8,109,1
 LWWW Y3RR3Z+FR7,7,108,1
 LWWW Y3RR3Z+FR9,31,79,1
 LWWW Y3RR3Z+FR9,53,72,1
 LWWW Y3RL1A+FR1,34,-37,1
 .long 0
#Shawn
 LWWW S4BF3A+FR3,20,-21,0
 LWWW S4BF3A+FR2,52,5,0
 LWWW S4AH3D+FR5,72,38,0
 LWWW S3UC3X+FR2,45,44,0
 LWWW S3UC3X+FR4,32,21,0
 LWWW S3UC3X+FR5,34,-3,0
 LWWW S3RR3Z+FR5,12,-10,1
 LWWW S3RR3Z+FR6,3,16,1
 LWWW S3RR3Z+FR7,6,84,1
 LWWW S3RR3Z+FR8,-25,110,1
 LWWW S3RR3Z+FR9,-36,84,1
 LWWW S3RR3Z+FR9,-6,75,1
 LWWW S3RR3Z+FR10,54,61,1
 LWWW S3RR3Z+FR2,32,-49,1
 .long 0
#BamBam
 LWWW B3HB3A+FR2,54,-22,0
 LWWW B4AM4A+FR8,55,3,0
 LWWW B4AH4A+FR6,48,36,0
 LWWW B4UC3B+FR2,44,27,0
 LWWW B4UC3B+FR3,25,0,0
 LWWW B4UC3B+FR5,25,-8,0
 LWWW B3RR3Z+FR5,10,4,1
 LWWW B3RR3Z+FR6,0,22,1
 LWWW B3RR3Z+FR7,-5,115,1
 LWWW B3RR3Z+FR8,-10,131,1
 LWWW B3RR3Z+FR9,-17,97,1
 LWWW B3RR3Z+FR9,12,89,1
 LWWW B3RR3Z+FR10,57,56,1
 LWWW B3RR3Z+FR2,42,-42,1
 .long 0
#Doink
 LWWW D3PP3A+FR2,43,-20,0
 LWWW D3PP3A+FR1,53,13,0
 LWWW D3AK3A+FR3,35,49,0
 LWWW D3UC3A+FR2,52,52,0
 LWWW D3UC3A+FR4,20,35,0
 LWWW D3UC3A+FR6,28,-16,0
 LWWW D3RR3Z+FR3,22,1,1
 LWWW D3RR3Z+FR4,6,35,1
 LWWW D3RR3Z+FR5,-6,94,1
 LWWW D3RR3Z+FR6,-4,103,1
 LWWW D3RR3Z+FR6,12,92,1
 LWWW D3RR3Z+FR7,35,74,1
 LWWW D3RR3Z+FR7,59,68,1
 LWWW D3GU4A+FR1,41,-49,1
 .long 0
#Adam
 .long 0
#Lex
 LWWW L4WS4B+FR2,53,-5,0
 LWWW L4WS4B+FR1,61,23,0
 LWWW L3UC3X+FR1,53,41,0
 LWWW L3UC3X+FR2,52,35,0
 LWWW L3UC3X+FR3,28,17,0
 LWWW L3UC3X+FR4,22,-8,0
 LWWW L3RR3Z+FR4,6,-15,1
 LWWW L3RR3Z+FR5,1,2,1
 LWWW L3RR3Z+FR6,1,66,1
 LWWW L3RR3Z+FR7,-5,100,1
 LWWW L3RR3Z+FR8,-2,82,1
 LWWW L3RR3Z+FR8,21,80,1
 LWWW L3RR3Z+FR9,46,46,1
 LWWW L3RR3Z+FR1,39,-46,1
 .long 0

#release_tbl
	.long	hrt_hitonground_anim,rzr_hitonground_anim
	.long	und_hitonground_anim,yok_hitonground_anim
	.long	shn_hitonground_anim,bam_hitonground_anim
	.long	dnk_hitonground_anim,0,lex_hitonground_anim

#*****************************************************************************
*
* GET BUZZED FROM DOINK

 SUBR	rzr_get_buzz_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;	.word	ANI_XFLIP
	.word	ANI_GRAVITY_OFF

	WL	ANI_CODE,set_position

	WL	ANI_CODE,set_skeleton_pal
	WL	2,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,R4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	ANI_CODE,make_white
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_norm
	WL	ANI_CODE,set_my_pal
	WL	3,R4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,R4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_white
	WL	3,R4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,R4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,set_my_pal
	WL	3,R4BZ4A+FR1

	WL	ANI_CODE,set_skeleton_pal
	WL	ANI_CODE,make_white
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_norm
	WL	ANI_CODE,set_my_pal
	WL	3,R4BZ4A+FR1

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
	WL	3,R4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,R4BZ4A+FR1
	WL	ANI_CODE,#make_black
	WL	3,R4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,R4BZ4A+FR1
	WL	ANI_CODE,#make_black
	WL	3,R4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,R4BZ4A+FR1

	.word	ANI_WAITHITGND
	.word	ANI_XFLIP
	.word	ANI_FACEDOWN
	.word	ANI_OFFSET,-20,0,0			;x,y,z


	WL	1,R4ST4G+FR1
	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	.ref	rzr_fall_back_anim

	WL	ANI_CHANGEANIM,rzr_fall_back_anim
;	.word	ANI_END

#nodead

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#make_black

;This is a black color within the wrestler's pal.  It is different for each
;wrestler.
	movi	0d0dh,a14

	move	a14,*a13(OBJ_CONST)
	move	*a13(OBJ_CONTROL),a14
	andni	01111b,a14
	ori	M_CONNON,a14
	move	a14,*a13(OBJ_CONTROL)
	rets


#*****************************************************************************

 SUBR	rzr_3_head_held_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_HEADHELD
	.word	ANI_SETFACING
	.word	ANI_SETWORD,USR_VAR1,0		;loop count

#loop
	WL	4,R3BF3A+FR1
	WL	4,R3BF3A+FR2

	WL	4,R3BF3A+FR4

	WL	4,R3BF3A+FR5
	WL	4,R3BF3A+FR6
	WL	4,R3BF3A+FR7
	WL	4,R3BF3A+FR9
	WL	4,R3BF3A+FR10

	WL	ANI_CODE,#inc_loop
	WL	ANI_IFNOTSTATUS,#loop

;Continue into break...

 SUBR	rzr_3_head_held_brk_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	ANI_CODE,FIND_AND_KILL_ENDLESS

	WLW	ANI_SET_XVEL,-38000h,AM_NEWFACE_REL
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	WL	4,R3HB3A+FR2
	.word	ANI_DETACH

;Standard #2 head hit from spin kick
	WL	3,R2AH2D+FR3
	WL	3,R2AH2D+FR5
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,R2AH2D+FR6
	WL	3,R2AH2D+FR7

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

 SUBR	rzr_3_head_held_stand_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	3,R3HB3A+FR2
	WL	3,R1TT5Z+FR2	;2.5
	.word	ANI_DETACH

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* HIP TOSS

 SUBR	rzr_combo_hiptoss_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,10
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,60,55,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_SET_YVEL,0000h

	.word	ANI_ATTACK_ON, AMODE_PUPPET,19,61,44,16
	WWL	ANI_WAITHITOPP,10,R4FT3A+FR2
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missedc
	WL	ANI_IFBLOCKED,#missedbc

	;got him
	WL	ANI_CODE,DO_GRUNT

	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,6,R4FT3A+FR2,#puppet_tbl,0

	.word	ANI_SET_RPTCOUNT,4	;5 times
#hiptoss_loop
	.word	ANI_CLR_BUTCOUNT

	WL	ANI_SET_YVEL,10000h

	.WORD	ANI_INC_COMBO
	WWLLW	ANI_SUPERSLAVE2,5,R4FT3A+FR3,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,R4FT3A+FR4,#puppet_tbl,2
	WWWL	ANI_IFROPE,RC_BACK,XTOSSDIST_CLOSE,#throw_him_outc
	WWLLW	ANI_SUPERSLAVE2,3,R4FT3A+FR5,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,R4FT3A+FR6,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,R4FT3A+FR7,#puppet_tbl,5

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_BSLAM,RD_BSLAM

	WWLLW	ANI_SUPERSLAVE2,2,R4FT3A+FR8,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,3,R4FT3A+FR9,#puppet_tbl,7

	WL	ANI_OPPOFFSET,#release_offsets
	WL	ANI_XFLIP_TBL,#xflip_tbl

	WL	ANI_SLAVEANIM,SLAM_HIM
	WLLL	ANI_SETOPPVELS,0,0a0000h,0000h		;x,y,z vels
	.WORD	ANI_XFLIP
	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN

	.word	ANI_DETACH

	.word	ANI_OFFSET,40,0,0

	.WORD	ANI_XFLIP
	WL	3,R3DC3C+FR10
	.WORD	ANI_XFLIP
	WL	3,R3GU4A+FR6
	WL	3,R3GU4A+FR7
	WL	3,R3GU4A+FR8
	WL	3,R3GU4A+FR9

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IFNOT_RPTCOUNT,#DO_END_MOVE
	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#EXIT_MOVE

	.WORD	ANI_SET_ATTACH
	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	WL	ANI_GOTO,#hiptoss_loop
#DO_END_MOVE

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#NO_EDGE
	WL	ANI_CHANGEANIM,rzr_combo_razors_edge_anim
#NO_EDGE

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#EXIT_MOVE
	WL	ANI_CHANGEANIM,rzr_combo_uppercut_anim

#EXIT_MOVE

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_DETACH
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedbc
	WL	10,R4FT3A+FR2
#missedc
	WL	20,R4FT3A+FR2

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_DETACH
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#throw_him_outc
	WL	ANI_CODE,CALL_THROWN_OUT
	WLLL	ANI_ATTACHVEL,-98000h,0b0000h,0h		;x,y,z
	WL	ANI_SLAVEANIM,flyout_tbl
	WL	ANI_OPPOFFSET,release_table
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_DETACH

	WL	4,R4FT3A+FR5
	WL	4,R4FT3A+FR6
	WL	4,R4FT3A+FR7

	.word	ANI_ZEROVELS
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,10

	WL	4,R4FT3A+FR8
	WL	4,R4FT3A+FR9

	.word	ANI_OFFSET,-40,0,0
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,rzr_facedown_getup_anim



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


*****************************************************************************


 SUBR	rzr_2_hiptoss2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,6
;	WL	2,R1TT5Z+FR2
;	WL	2,R1TT5Z+FR3

 SUBR	rzr_4_hiptoss2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	;we need at least 2 ticks before the attack gets turned on!
	.word	ANI_STARTATTACK,AT_PUPPET,2
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,60,55,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_SET_YVEL,0000h

	WL	2,R4FT3A+FR2
	.word	ANI_ATTACK_ON,AMODE_PUPPET_TOSS,19,61,44,16
	WWL	ANI_WAITHITOPP,8,R4FT3A+FR2
	.word	ANI_ZERO_XZVELS
	.word	ANI_ATTACK_OFF

	WL	ANI_GOTO,#cont

 SUBR	rzr_2_hiptoss_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,10
;	WL	2,R1TT5Z+FR2
;	WL	2,R1TT5Z+FR3

 SUBR	rzr_4_hiptoss_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCONFINE
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUPPET,10
;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_SET_YVEL,0000h
	WL	4,R4FT3A+FR2

	.word	ANI_ATTACK_ON,AMODE_PUPPET_TOSS,19,61,44,16
	WWL	ANI_WAITHITOPP,4,R4FT3A+FR2
	.word	ANI_ZERO_XZVELS
	WWL	ANI_WAITHITOPP,4,R4FT3A+FR2
	.word	ANI_ATTACK_OFF

#cont
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb

#got_him
	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	.word	ANI_DRAW_NAME,10
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,6,R4FT3A+FR2,#puppet_tbl,0

	WL	ANI_SET_YVEL,10000h

	WWLLW	ANI_SUPERSLAVE2,4,R4FT3A+FR3,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,R4FT3A+FR4,#puppet_tbl,2
	WWWL	ANI_IFROPE,RC_BACK,XTOSSDIST_CLOSE,#throw_him_out
	WWLLW	ANI_SUPERSLAVE2,3,R4FT3A+FR5,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,R4FT3A+FR6,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,R4FT3A+FR7,#puppet_tbl,5

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_BSLAM,RD_BSLAM
	.word	ANI_OPP_GETUP,300

	WWLLW	ANI_SUPERSLAVE2,2,R4FT3A+FR8,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,3,R4FT3A+FR9,#puppet_tbl,7

	WL	ANI_OPPOFFSET,#release_offsets
	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#recover_tbl
	WLLL	ANI_SETOPPVELS,-20000h,50000h,0h		;x,y,z vels
	.word	ANI_DETACH

	.word	ANI_OFFSET,-40,0,0
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,rzr_facedown_getup_anim

#missedb
;	.ref	ck_hiptoss
;	WL	ANI_CODE,ck_hiptoss
;	WL	ANI_IFNOTSTATUS,#got_him

	WL	10,R4FT3A+FR2
;Delay longer if 2nd hiptoss in quick succession!
	.ref	hiptoss_delay
	WL	ANI_CODE,hiptoss_delay
	WL	ANI_IFNOTSTATUS,#missed
	WL	24,R4FT3A+FR2
#missed
	WL	8,R4FT3A+FR2

	WL	ANI_CODE,CALL_MISSES
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#throw_him_out
	WL	ANI_CODE,CALL_THROWN_OUT
	WLLL	ANI_ATTACHVEL,-98000h,0b0000h,0h		;x,y,z
	WL	ANI_SLAVEANIM,#flyout_tbl
	WL	ANI_OPPOFFSET,release_table
	.word	ANI_DETACH

	WL	3,R4FT3A+FR5
	WL	3,R4FT3A+FR6
	WL	3,R4FT3A+FR7

	.word	ANI_ZEROVELS
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,10

	WL	3,R4FT3A+FR8
	WL	4,R4FT3A+FR9

	.word	ANI_OFFSET,-40,0,0
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,rzr_facedown_getup_anim



release_table
	;	X Y
	.word	0,32		;Bret
	.word	0,0		;Razor
	.word	0,0		;Taker
	.word	0,0		;Yokozuna
	.word	0,0		;Shawn
	.word	32,50		;BamBam
	.word	32,0		;Doink
	.word	0,0		;Adam
	.word	0,0		;Lex


********
* #include "r_hpsl.img"

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
 LWWW H2AH3A+FR5,43,11,0
 LWWW H2AM3A+FR1,25,27,0
 LWWW H2AM3A+FR7,-4,17,0
 LWWW H3FR3A+FR2,-25,24,0
 LWWW H3FR3A+FR3,-22,28,0
 LWWW H3FR3A+FR4,-31,20,0
 LWWW H3FR3A+FR5,-56,26,0
 LWWW H2CP3A+FR8,-130,-17,1
#Razor
 LWWW R3TD3A+FR1,36,7,0
 LWWW R3TD3A+FR3,16,8,0
 LWWW R3TD3A+FR4,-21,18,0
 LWWW R3TD3A+FR5,-17,20,0
 LWWW R3TD3A+FR6,-18,12,0
 LWWW R3TD3A+FR7,-26,28,0
 LWWW R3TD3A+FR8,-59,34,0
 LWWW R3GU2A+FR1,-134,-15,1
#Taker
 LWWW U3AE4A+FR1,41,23,0
 LWWW U4AM4C+FR4,18,15,0
 LWWW U3FH3A+FR1,13,9,1
 LWWW U3FH3A+FR2,-13,36,1
 LWWW U3FH3A+FR3,-26,21,1
 LWWW U3FH3A+FR4,-48,29,1
 LWWW U3FH3A+FR5,-72,50,1
 LWWW U3CP3B+FR1,-138,-11,1
#Yokozuna
 LWWW Y3FL3W+FR1,39,10,0
 LWWW Y3FL3W+FR2,9,17,0
 LWWW Y3FL3W+FR3,-34,25,0
 LWWW Y3FL3W+FR4,-32,38,0
 LWWW Y3FL3W+FR5,-23,32,0
 LWWW Y3FL3W+FR6,-57,36,0
 LWWW Y3FL3W+FR7,-78,36,0
 LWWW Y3FD3A+FR7,-117,9,0
#Shawn
 LWWW S3OS3X+FR2,25,8,1
 LWWW S3OS3X+FR4,1,23,1
 LWWW S3OS3X+FR5,-41,27,1
 LWWW S3OS3X+FR6,-37,57,1
 LWWW S3OS3X+FR7,-25,48,1
 LWWW S3OS3X+FR8,-27,45,1
 LWWW S3OS3X+FR9,-72,50,1
 LWWW S3OS3X+FR10,-113,-7,1
#BamBam
 LWWW B4TD3B+FR1,36,0,0
 LWWW B4TD3B+FR3,16,10,0
 LWWW B4TD3B+FR4,-10,19,0
 LWWW B4TD3B+FR5,-12,50,0
 LWWW B4TD3B+FR6,-12,53,0
 LWWW B4TD3B+FR7,-37,45,0
 LWWW B4TD3B+FR8,-52,47,0
 LWWW B4TD3B+FR9,-101,2,0
#Doink
 LWWW D3AE3B+FR8,52,10,0
 LWWW D3PM4C+FR2,10,16,0
 LWWW D3OS3A+FR1,1,19,0
 LWWW D3OS3A+FR3,-30,27,0
 LWWW D3OS3A+FR4,-27,19,0
 LWWW D3OS3A+FR6,-28,34,0
 LWWW D3FD3E+FR2,-59,16,0
 LWWW D3SA3A+FR2,-118,-10,1
#Adam
 .long 0
#Lex
 LWWW L4AM4B+FR2,51,14,0
 LWWW L3FH3A+FR1,21,20,0
 LWWW L3FH3A+FR2,-8,13,0
 LWWW L3FH3A+FR3,-9,33,0
 LWWW L3FH3A+FR4,-6,25,0
 LWWW L3FH3A+FR5,-16,20,0
 LWWW L3FH3A+FR6,-48,31,0
 LWWW L3CP3X+FR1,-129,-10,1

*
********

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

#xflip_tbl
	.word	0 ;bret
	.word	0 ;razor
	.word	0 ;taker
	.word	1 ;yoko
	.word	0 ;shawn
	.word	0 ;bam
	.word	0 ;doink
	.word	0 ;spare
	.word	0 ;lex

#recover_tbl
	.long	hrt_hitonground_anim,rzr_hitonground_anim
	.long	und_hitonground_anim,yok_hitonground_anim
	.long	shn_hitonground_anim,bam_hitonground_xflip_anim
	.long	dnk_hitonground_anim,0,lex_hitonground_anim

#flyout_tbl
flyout_tbl
	.long	hrt_flyout_anim
	.long	rzr_flyout_anim
	.long	und_flyout_anim
	.long	yok_flyout_anim
	.long	shn_flyout_anim
	.long	bam_flyout_anim
	.long	dnk_flyout_anim
	.long	0
	.long	lex_flyout_anim

#******************************************************************************

 SUBR	rzr_2_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_STARTATTACK,AT_PUPPET,16

	WL	2,R1TT5Z+FR2
	WL	2,R1TT5Z+FR3

 SUBR	rzr_4_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

;Put cool cheers here
;	.word	ANI_RAWSOUND,2055		;big cheer #1
;	.word	ANI_CHEER,3

	.word	ANI_STARTATTACK,AT_PUPPET,12

	WL	3,R3RG3B+FR2

	LEAPATOPP 8,999,80,80,30000h,TGT_HEAD,26,6,-2

	WL	4,R3RG3B+FR3
	WL	4,R3RG3B+FR4
	.word	ANI_ZERO_XZVELS

	.word	ANI_ATTACK_ON, AMODE_PUPPET2,28,0,23,25 ;mode,x,y,w,h
	WL	4,R3RG3B+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;got him
	.word	ANI_CLR_BUTCOUNT
	WL	ANI_CODE,clear_opp_counts
	WL	ANI_CODE,CALL_SETUP

	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	WL	ANI_CODE,DO_NONO
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SOUND,98h			;neck break (5-7 ticks late)

	WWLLW	ANI_SUPERSLAVE2,3,R3RG3B+FR6,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3Z+FR1,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3Z+FR2,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,R3RG3Z+FR3,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,R4GH3A+FR7,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,R4GH3A+FR7,#puppet_tbl,5

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	1,R4GH3A+FR7
	.word	ANI_CLROPPMODE,MODE_GHOST

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
	WL	20,R3RG3B+FR5
	WL	3,R3RG3B+FR4
	WL	3,R3RG3B+FR3
	WL	3,R3RG3B+FR2

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
 LWWW H3GU4A+FR1,25,-35,0
 LWWW H3GU4A+FR2,30,-38,0
 LWWW H3DU3A+FR3,30,-32,1
 LWWW H3DU3A+FR4,37,-30,1
 LWWW H3DU3A+FR5,52,-43,1
 LWWW H3BF3A+FR1,52,-39,0
 .long 0
#Razor
 LWWW R3GU2A+FR3,28,-26,0
 LWWW R3GU4A+FR3,33,-32,0
 LWWW R3GU4A+FR5,43,-35,0
 LWWW R3DU3B+FR2,40,-44,1
 LWWW R3DU3B+FR4,55,-42,1
 LWWW R3BF3A+FR1,59,-41,0
 .long 0
#Taker
 LWWW U3DU3B+FR2,29,-27,1
 LWWW U3DU3B+FR5,30,-28,1
 LWWW U3DU3B+FR6,37,-30,1
 LWWW U3DU3B+FR8,32,-34,1
 LWWW U3DU3B+FR10,54,-35,1
 LWWW U4BF3Z+FR5,58,-20,0
 .long 0
#Yokozuna
 LWWW Y3GU2A+FR1,33,-21,0
 LWWW Y3GU2A+FR2,36,-22,0
 LWWW Y3GU2A+FR6,29,-33,0
 LWWW Y3GU2A+FR8,32,-43,0
 LWWW Y3GU2A+FR11,50,-41,0
 LWWW Y3BF3A+FR1,58,-29,0
 .long 0
#Shawn
 LWWW S3GU2A+FR1,37,-29,0
 LWWW S3GU4A+FR2,38,-30,0
 LWWW S3GU4A+FR4,41,-34,0
 LWWW S3GU4A+FR5,39,-39,0
 LWWW S3GU4A+FR7,52,-46,0
 LWWW S3BF3A+FR1,42,-40,0
 .long 0
#BamBam
 LWWW B3GU4A+FR3,32,-25,0
 LWWW B3GU4A+FR5,44,-29,0
 LWWW B3GU4A+FR7,40,-29,0
 LWWW B3GU4A+FR8,35,-33,0
 LWWW B3GU4A+FR10,47,-42,0
 LWWW B3BF3C+FR5,60,-33,0
 .long 0
#Doink
 LWWW D3GU4A+FR2,33,-32,0
 LWWW D3GU4A+FR3,32,-36,0
 LWWW D3GU4A+FR5,33,-28,0
 LWWW D3GU4A+FR7,47,-38,0
 LWWW D3GU4A+FR8,49,-38,0
 LWWW D3BF3A+FR2,54,-39,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3GU4A+FR1,31,-29,0
 LWWW L3GU4A+FR2,42,-28,0
 LWWW L3DU3A+FR4,13,-27,1
 LWWW L3DU3A+FR6,19,-44,1
 LWWW L3DU3A+FR7,35,-50,1
 LWWW L3BF3B+FR5,54,-37,0
 .long 0

#*****************************************************************************
*
* CLIMB UP TURNBUCKLES

 SUBR	rzr_climb_up_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOGRAVITY|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SCROLL_CTRL,RZR_TBUKLY

	.word	ANI_SHAKECORNER

	.word	ANI_OFFSET,-2,7,-4	;-10,17,-16, distributed over 5 frames
	WL	2,R2CT2E+FR1
	.word	ANI_OFFSET,-2,5+3,-4
	WL	2,R2CT2E+FR2
	.word	ANI_OFFSET,-2,5+3,-4
	WL	2,R2CT2E+FR3
	.word	ANI_OFFSET,-2,-1+3,-4
	WL	2,R2CT2E+FR4
	.word	ANI_OFFSET,-2,6+3,0
	WL	2,R2CT2E+FR5
	.word	ANI_SHAKECORNER
	.word	ANI_OFFSET,0,12,0
	WL	2,R2CT2E+FR6
	.word	ANI_OFFSET,0,3,0
	WL	2,R2CT2E+FR7
	.word	ANI_OFFSET,0,1,0
	WL	2,R2CT2E+FR8
	.word	ANI_OFFSET,0,-1,0
	WL	2,R2CT2E+FR9
	.word	ANI_OFFSET,0,8,0
	WL	2,R2CT2E+FR10
	.word	ANI_OFFSET,0,12,0
	WL	2,R2CT2E+FR11
	.word	ANI_SHAKECORNER
	.word	ANI_OFFSET,0,1,0
	WL	2,R2CT2E+FR2
	.word	ANI_OFFSET,0,2,0
	WL	2,R2CT2E+FR3
	.word	ANI_OFFSET,0,6,0
	WL	2,R2CT2E+FR4
	.word	ANI_OFFSET,0,7,0
	WL	2,R2CT2E+FR5
	.word	ANI_OFFSET,0,9,0
	WL	2,R2CT2E+FR6

	.word	ANI_OFFSET,-4,-2,0
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONTURNBKL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOGRAVITY|MODE_OVERLAP
	.word	ANI_SCROLL_CTRL,SC_RESTORE

#repeat
	WL	5,R4SB4A+FR1
	WL	ANI_CODE,tbukl_flip
	WL	5,R4SB4A+FR2
	WL	ANI_CODE,tbukl_flip
	WL	5,R4SB4A+FR3
	WL	ANI_CODE,tbukl_flip
	WL	5,R4SB4A+FR4
	WL	ANI_CODE,tbukl_flip
	WL	5,R4SB4A+FR5
	WL	ANI_CODE,tbukl_flip
	WL	5,R4SB4A+FR6
	WL	ANI_CODE,tbukl_flip
	WL	5,R4SB4A+FR7
	WL	ANI_CODE,tbukl_flip
	WL	5,R4SB4A+FR8
	WL	ANI_CODE,tbukl_flip
	WL	5,R4SB4A+FR9
	WL	ANI_CODE,tbukl_flip
	WL	5,R4SB4A+FR10
	WL	ANI_CODE,tbukl_flip
	WL	ANI_GOTO,#repeat

#*****************************************************************************
*
* CLIMB DOWN TURNBUCKLES

 SUBR	rzr_climb_down_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SCROLL_CTRL,SC_RESTORE

	WL	ANI_CODE,face_inside

	.word	ANI_SHAKECORNER
	.word	ANI_OFFSET,4,2,0
	WL	2,R2CT2E+FR6
	.word	ANI_OFFSET,0,-9,0
	WL	2,R2CT2E+FR5
	.word	ANI_OFFSET,0,-7,0
	WL	2,R2CT2E+FR4
	.word	ANI_OFFSET,0,-6,0
	WL	2,R2CT2E+FR3
	.word	ANI_OFFSET,0,-2,0
	WL	2,R2CT2E+FR2
	.word	ANI_SHAKECORNER
	.word	ANI_OFFSET,0,-1,0
	WL	2,R2CT2E+FR11
	.word	ANI_OFFSET,0,-12,0
	WL	2,R2CT2E+FR10
	.word	ANI_OFFSET,0,-8,0
	WL	2,R2CT2E+FR9
	.word	ANI_OFFSET,0,1,0
	WL	2,R2CT2E+FR8
	.word	ANI_OFFSET,0,-1,0
	WL	2,R2CT2E+FR7
	.word	ANI_OFFSET,0,-3,0
	.word	ANI_SHAKECORNER
	WL	2,R2CT2E+FR6
	.word	ANI_OFFSET,0,-12,0
	WL	2,R2CT2E+FR5
	.word	ANI_OFFSET,2,-9,0
	WL	2,R2CT2E+FR4
	.word	ANI_OFFSET,2,-2,4
	WL	2,R2CT2E+FR3
	.word	ANI_OFFSET,2,-8,4
	WL	2,R2CT2E+FR2
	.word	ANI_OFFSET,2,-8,4
	WL	2,R2CT2E+FR1
	.word	ANI_OFFSET,2,-7,4

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#******************************************************************************

 SUBR	rzr_4_taunt_anim

	.word	ANI_SETMODE,MODE_UNINT
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	3,R4CO4A+FR1
	WL	3,R4CO4A+FR2
	WL	3,R4CO4A+FR3
	WL	3,R4CO4A+FR4
	WL	15,R4CO4A+FR5
	WL	3,R4CO4A+FR6
	WL	3,R4CO4A+FR7
	WL	3,R4CO4A+FR8
	WL	3,R4CO4A+FR7
	WL	3,R4CO4A+FR6
	WL	3,R4CO4A+FR5
	WL	3,R4CO4A+FR6
	WL	3,R4CO4A+FR7
	WL	3,R4CO4A+FR8
	WL	3,R4CO4A+FR7
	WL	2,R4CO4A+FR6
	WL	12,R4CO4A+FR5
	WL	2,R4CO4A+FR4
	WL	2,R4CO4A+FR3
	WL	2,R4CO4A+FR2
	WL	2,R4CO4A+FR1

;	.ref	set_taunt_bit
;	WL	ANI_CODE,set_taunt_bit

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,rzr_stand4_anim
;	.word	ANI_END

#*****************************************************************************
*
* Head slams into mat
;From head slam - repeated head slam

 SUBR	rzr_break_face2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	.word	ANI_ZEROVELS

	WL	2,R3MS3Q+FR1
	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off
	WL	ANI_SET_YVEL,80000h
	WL	3,R3MS3Q+FR2
	WL	3,R3MS3Q+FR3
	WL	3,R3MS3Q+FR4
	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	.word	ANI_WAITROLL
	WL	3,R3MS3Q+FR1
	WL	ANI_CHANGEANIM,rzr_faceup_getup_anim

 SUBR	rzr_break_face3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS

	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off
	WL	3,R3MS3Z+FR3
	WL	ANI_SET_YVEL,078000h
	WL	100,R3MS3Z+FR3
	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,rzr_faceup_getup_anim
	
* Head slams into mat
;From head slam

 SUBR	rzr_break_face_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS

	WL	2,R3MS3Q+FR1
	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off
	WL	ANI_SET_YVEL,40000h
	WL	3,R3MS3Q+FR2
	WL	3,R3MS3Q+FR3
	WL	3,R3MS3Q+FR4
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	3,R3MS3Q+FR2
	WL	3,R3MS3Q+FR3
	WL	3,R3MS3Q+FR4

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	2,R3RL1B+FR6		;Face down
	.word	ANI_WAITROLL

	WL	ANI_CHANGEANIM,rzr_faceup_getup_anim

#*****************************************************************************
*
* uslash - uslash - uslash - uslash - flykick

 SUBR	rzr_uslashes_to_head_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SET_RPTCOUNT,2	;2 times

	.word	ANI_STARTATTACK,AT_HDKNEES,10
	WL	2,R3RZ3S+FR2
#rpt
	.word	ANI_CLR_BUTCOUNT

	WL	1,R3RZ3S+FR2
	WL	2,R3RZ3S+FR3
	WL	1,R3RZ3S+FR4

	.word	ANI_ATTACK_ON,AMODE_HEADUSLASH,35,29,67,121
	WL	2,R3RZ3S+FR5
	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	WL	ANI_IFNOTSTATUS,#missed

	WL	1,R3RZ3S+FR6
	WL	2,R3RZ3S+FR7
	WL	1,R3RZ3S+FR8

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#exit
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#rpt

	.word	ANI_CLR_BUTCOUNT

	WL	2,R3RZ3S+FR2
	WL	1,R3RZ3S+FR3
	WL	2,R3RZ3S+FR4

	.word	ANI_ATTACK_ON,AMODE_HEADUSLASH,35,29,67,121
	WL	1,R3RZ3S+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	WL	ANI_CODE,#go_high

	WWWL	ANI_IF_BUTCOUNT_GE,KICKB_COUNT,1,#do_flykick

#exit
#missed
	.word	ANI_DETACH
	WL	2,R3RZ3S+FR6
	WL	2,R3RZ3S+FR7
	WL	2,R3RZ3S+FR8
	WL	2,R3RZ3S+FR9
	WL	2,R3RZ3S+FR10
	WL	2,R3RZ3S+FR12

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#do_flykick

	WL	ANI_CODE,CALL_SPECIAL_MOVE
	WL	2,R3RZ3S+FR6
	WL	2,R3RZ3S+FR7
;	WL	2,R3RZ3S+FR8
;	WL	2,R3RZ3S+FR9
;	WL	2,R3RZ3S+FR10

	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,rzr_flying_kick_anim

#go_high
	move	*a13(CLOSEST_NUM),a14
	X32	a14
	addi	process_ptrs,a14
	move	*a14,a14,L

	move	*a14(WRESTLERNUM),a0
	cmpi	3,a0				;Yoko too fat
	jrz	#x

	movi	40000h,a0			;Go higher for last hit!
	move	a0,*a14(OBJ_YVEL),L
#x	rets


#*****************************************************************************
*
* dslash - dslash - dslash - dslash - piledriver

 SUBR	rzr_dslashes_to_head_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SET_RPTCOUNT,3	;2 times

	.word	ANI_STARTATTACK,AT_HDKNEES,8
	WL	1,R3RD3D+FR1
#rpt
;	WL	ANI_SET_YVEL,30000h
	.word	ANI_CLR_BUTCOUNT

	WL	2,R3RD3D+FR2
	WL	1,R3RD3D+FR3
	WL	2,R3RD3D+FR4
	WL	1,R3RD3D+FR5
	WL	1,R3RD3D+FR6

	.word	ANI_ATTACK_ON,AMODE_HEADDSLASH,33,33,80,121
	WL	2,R3RD3D+FR7
	.word	ANI_ATTACK_OFF
	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	WL	ANI_IFNOTSTATUS,#missed

	WL	1,R3RD3D+FR8

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#exit
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#rpt

	.word	ANI_CLR_BUTCOUNT

	WL	2,R3RD3D+FR2
	WL	1,R3RD3D+FR3
	WL	2,R3RD3D+FR4
	WL	1,R3RD3D+FR5
	WL	1,R3RD3D+FR6

	.word	ANI_ATTACK_ON,AMODE_HEADDSLASH,33,33,80,121
	WL	2,R3RD3D+FR7
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	WWWL	ANI_IF_BUTCOUNT_GE,SPUNCHB_COUNT,1,#do_pile

#exit
#missed
	.word	ANI_DETACH
	WL	2,R3RD3D+FR8
	WL	2,R3RD3D+FR9
	WL	2,R3RD3D+FR11

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#do_pile

	WL	3,R3RD3D+FR8
	WL	3,R3RD3D+FR9
	WL	3,R3RD3D+FR11

	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,rzr_3_pile_driver2_anim


#*****************************************************************************

	.bss	#opp_xvel,32

 SUBR	rzr_3_fake_hold_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,6

	WL	3,R4GH3A+FR1
	WL	3,R4GH3A+FR2

	WL	6,R4GH3A+FR3
	WL	ANI_GOTO,#missed

 SUBR	rzr_3_head_hold2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,6

	WL	3,R4GH3A+FR1
	WL	3,R4GH3A+FR2

	.word	ANI_ATTACK_ON,AMODE_PUPPET_HDGRAB,20,70,57,43 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,6,R4GH3A+FR3
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2

	WL	ANI_GOTO,#gothim

 SUBR	rzr_3_head_hold_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,6

	WL	2,R4GH3A+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 6,999,65,45,90000h,TGT_HEAD,56,100,0
	LEAPATOPP 9,999,40,45,90000h,TGT_HEAD,56,100,0
	WL	ANI_CODE,halve_bk_xvel

	WL	3,R4GH3A+FR2

	.word	ANI_ATTACK_ON,AMODE_PUPPET,20,70,57,43 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,6,R4GH3A+FR3
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb

#gothim
	.word	ANI_SETWORD,USR_VAR2,0
	.word	ANI_CLR_BUTCOUNT
	.ref	head_grab_time
	WL	ANI_CODE,head_grab_time

	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	WL	ANI_CODE,DO_NONO
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,1,R4GH3A+FR3,#puppet_tbl,0

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WWLLW	ANI_SUPERSLAVE2,4,R4GH3A+FR3,#puppet_tbl,0

	WWLLW	ANI_SUPERSLAVE2,4,R4GH3A+FR5,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,R4GH3A+FR6,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,R4GH3A+FR7,#puppet_tbl,3

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	1,R4GH3A+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,R4GH3A+FR3
	WL	3,R4GH3A+FR2
	WL	3,R4GH3A+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	WL	2,R4GH3A+FR3
	.word	ANI_ZEROVELS
	WL	ANI_SET_YVEL,30000h

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	3,R4GH3A+FR3
	WL	3,R4GH3A+FR2
	WL	3,R4GH3A+FR1

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
 LWWW H4AH3A+FR1,70,2,0
 LWWW H3HB3A+FR3,66,-13,0
 LWWW H3HB3A+FR2,56,-18,0
 LWWW H3HB3A+FR1,50,-40,0
 .long 0
#Razor
 LWWW R4AH4C+FR3,77,2,0
 LWWW R3HB3A+FR3,76,-15,0
 LWWW R3HB3A+FR2,73,-29,0
 LWWW R3BF3A+FR1,65,-41,0
 .long 0
#Taker
 LWWW U4AH3A+FR2,67,12,0
 LWWW U4BF3A+FR2,60,-1,0
 LWWW U4BF3A+FR3,30,-15,0
 LWWW U4BF3Z+FR3,55,-28,0
 .long 0
#Yokozuna
 LWWW Y4AE4A+FR2,84,-7,0
 LWWW Y4AM4A+FR1,78,-11,0
 LWWW Y4AM4A+FR2,68,-17,0
 LWWW Y3BF3A+FR1,56,-29,0
 .long 0
#Shawn
 LWWW S4AH3D+FR5,72,-8,0
 LWWW S4AH3D+FR1,59,-8,0
 LWWW S4BF3A+FR2,56,-20,0
 LWWW S4BF3A+FR3,36,-27,0
 .long 0
#BamBam
 LWWW B4AH4A+FR1,57,-3,0
 LWWW B4BF3A+FR1,64,-2,0
 LWWW B3HB3A+FR2,53,-31,0
 LWWW B3BF3C+FR5,61,-33,0
 .long 0
#Doink
 LWWW D3AH3B+FR1,60,-1,0
 LWWW D3AK3A+FR3,54,-3,0
 LWWW D3AK3A+FR2,67,-18,0
 LWWW D3BF3A+FR1,55,-38,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L4AH4B+FR3,61,-5,0
 LWWW L3BF3A+FR1,63,-6,1
 LWWW L3BF3A+FR2,60,-21,1
 LWWW L3BF3B+FR5,51,-36,0
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
* #3 PILEDRIVER

#yoff	equ	50
 SUBR	rzr_combo_pile_driver_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_ATTACK_ON,AMODE_PUPPET,32,25,66,21	;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,4,R3PG3B+FR1
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missedcx

	;got him
	.WORD	ANI_INC_COMBO

	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SOUND,82h			;Effort grunt

	WWLLW	ANI_SUPERSLAVE2,10,R3PG3B+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR4,#puppet_tbl,3

	.word	ANI_OFFSET,0,#yoff,0
	WL	ANI_SET_YVEL,70000h
	WL	ANI_CODE,set_xdrift

	WWLLW	ANI_SUPERSLAVE2,5,R3PG3B+FR5,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR6,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR7,#puppet_tbl,6

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_PILEDRIVER,RD_PILEDRIVER

	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR8,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR9,#puppet_tbl,8

	WL	ANI_CODE,#set_opp_xflip

	WL	ANI_SLAVEANIM,#rollout_tbl
	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_DETACH
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO

	.word	ANI_BOUNCE,4

	WL	1,R3PG3B+FR9
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS

	WL	12,R3PG3B+FR9
	WL	3,R3PG3B+FR10

	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,rzr_faceup_getup2_anim

#missedcx
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_DETACH
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO

	WL	4,R3PG3B+FR1
	WL	4,R3PG3B+FR2
	WL	4,R3PG3B+FR3
	WL	4,R3PG3B+FR4

	WL	ANI_SET_YVEL,30000h
	WL	3,R3PG3B+FR5
	WL	3,R3PG3B+FR6
	WL	3,R3PG3B+FR7

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30

	WL	3,R3PG3B+FR8
	WL	3,R3PG3B+FR9
	WL	3,R3PG3B+FR10

	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,rzr_faceup_getup2_anim

*****************************************************************************

 SUBRP	rzr_3_pile_driver2_anim	;from head hold combo

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_ATTACK_ON,AMODE_PUPPET,32,25,66,21	;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,4,R3PG3B+FR1
	.word	ANI_ATTACK_OFF

	.WORD	ANI_ADD_MOVE,MOVE_C_9,2,2
	WL	ANI_IFNOTSTATUS,#missed

	;got him

	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SOUND,82h			;Effort grunt

	WWLLW	ANI_SUPERSLAVE2,10,R3PG3B+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR4,#puppet_tbl,3

	.word	ANI_OFFSET,0,#yoff,0
	.ref	BAMFRE_P
	WLWW	ANI_SHADOWTRAIL,BAMFRE_P,3,12	;pal,rate,lifespan
	WL	ANI_SET_YVEL,0e8000h
	.word	ANI_SCROLL_CTRL,190
	WL	ANI_CODE,#reduce_dmg
	WL	ANI_GOTO,#in

#reduce_dmg
	.ref	PCNT
	SPCDMG	RD_PILEDRIVER,80
	rets

 SUBR	rzr_3_pile_driver_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_ATTACK_ON,AMODE_PUPPET,32,25,66,21	;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,4,R3PG3B+FR1
	.word	ANI_ATTACK_OFF

	.WORD	ANI_ADD_MOVE,MOVE_C_9,2,2
	WL	ANI_IFNOTSTATUS,#missed

	;got him

	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SOUND,82h			;Effort grunt

	WWLLW	ANI_SUPERSLAVE2,10,R3PG3B+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR4,#puppet_tbl,3

	.word	ANI_OFFSET,0,#yoff,0
	WL	ANI_SET_YVEL,70000h

#in
	WL	ANI_CODE,set_xdrift

	WWLLW	ANI_SUPERSLAVE2,5,R3PG3B+FR5,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR6,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR7,#puppet_tbl,6

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_PILEDRIVER,RD_PILEDRIVER
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR8,#puppet_tbl,7
	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR9,#puppet_tbl,8

	WL	ANI_CODE,#set_opp_xflip

	WL	ANI_SLAVEANIM,#rollout_tbl
	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_DETACH

	.word	ANI_BOUNCE,4

	WL	1,R3PG3B+FR9
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS

	WL	12,R3PG3B+FR9
	WL	3,R3PG3B+FR10

	.word	ANI_XFLIP
	.word	ANI_SHADOWTRAIL,0	;off
	WL	ANI_CHANGEANIM,rzr_faceup_getup2_anim

#missed
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WL	4,R3PG3B+FR1
	WL	4,R3PG3B+FR2
	WL	4,R3PG3B+FR3
	WL	4,R3PG3B+FR4

	WL	ANI_SET_YVEL,30000h
	WL	3,R3PG3B+FR5
	WL	3,R3PG3B+FR6
	WL	3,R3PG3B+FR7

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30

	WL	3,R3PG3B+FR8
	WL	3,R3PG3B+FR9
	WL	3,R3PG3B+FR10

	.word	ANI_XFLIP
	.word	ANI_SHADOWTRAIL,0	;off
	WL	ANI_CHANGEANIM,rzr_faceup_getup2_anim

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
 LWWW H3PP3X+FR1,13,-38,0
 LWWW H3PP3X+FR2,2,2,0
 LWWW H3PP3X+FR3,2,27,0
 LWWW H3PP3X+FR4,5,28,0
 LWWW H3PP3X+FR5,14,44,0
 LWWW H3PP3X+FR6,10,52,0
 LWWW H3PP3X+FR6,10,53,0
 LWWW H3PP3X+FR7,15,13,0
 LWWW H3PP3X+FR8,21,-7,0
#Razor
 LWWW R3GP3Z+FR1,9,-31,0
 LWWW R3GP3Z+FR2,9,-20,0
 LWWW R3GP3Z+FR3,13,21,0
 LWWW R3GP3Z+FR4,20,42,0
 LWWW R3GP3Z+FR5,22,51,0
 LWWW R3GP3Z+FR6,26,56,0
 LWWW R3GP3Z+FR6,26,54,0
 LWWW R3GP3Z+FR7,23,31,0
 LWWW R3GP3Z+FR8,38,-8,0
#Taker
 LWWW U3PP3X+FR1,16,-38,1
 LWWW U3PP3X+FR2,16,-21,1
 LWWW U3PP3X+FR3,9,-12,1
 LWWW U3PP3X+FR4,2,4,1
 LWWW U3PP3X+FR5,15,37,1
 LWWW U3PP3X+FR6,21,64,1
 LWWW U3PP3X+FR6,22,63,1
 LWWW U3GP3X+FR1,18,7,1
 LWWW U3GP3X+FR2,31,-16+5,1
#Yokozuna
 LWWW Y3PP3Q+FR1,16,-30,0
 LWWW Y3PP3Q+FR2,12,-22,0
 LWWW Y3PP3Q+FR3,16,-15,0
 LWWW Y3PP3Q+FR4,19,-7,0
 LWWW Y3PP3Q+FR6,13,17,0
 LWWW Y3PP3Q+FR7,12,27,0
 LWWW Y3PP3Q+FR7,13,27,0
 LWWW Y3FD3N+FR2,15,16,0
 LWWW Y3FD3N+FR3,24,14,0
#Shawn
 LWWW S3GP3X+FR1,19,-43,0
 LWWW S3GP3X+FR2,12,-27,0
 LWWW S3GP3X+FR3,15,-8,0
 LWWW S3GP3X+FR4,16,30,0
 LWWW S3GP3X+FR5,20,41,0
 LWWW S3OS3X+FR8,24,36,1
 LWWW S3OS3X+FR8,24,34,1
 LWWW S3FD3X+FR2,22,21,0
 LWWW S3GP3X+FR6,28,-6,0
#BamBam
 LWWW B3PP3Q+FR1,10,-34,0
 LWWW B3PP3Q+FR2,14,-12,0
 LWWW B3PP3Q+FR3,17,9,0
 LWWW B3PP3Q+FR4,19,28,0
 LWWW B3PP3Q+FR5,23,43,0
 LWWW B3PP3Q+FR6,16,52,0
 LWWW B3PP3Q+FR6,16,50,0
 LWWW B3PP3Q+FR7,17,25,0
 LWWW B3FD3C+FR1,22,2,0
#Doink
 LWWW D3PD3Z+FR1,14,-43,1
 LWWW D3PD3Z+FR2,13,-23,1
 LWWW D3PD3Z+FR3,13,0,1
 LWWW D3PD3Z+FR4,12,35,1
 LWWW D3PD3Z+FR5,10,47,1
 LWWW D3PD3Z+FR6,24,41,1
 LWWW D3PD3Z+FR7,24,39,1
 LWWW D3PD3Z+FR8,24,4,1
 LWWW D3PD3Z+FR9,34,-15,1
#Adam
 .long 0
#Lex
 LWWW L3GP3Z+FR1,12,-31,0
 LWWW L3GP3Z+FR2,13,-20,0
 LWWW L3GP3Z+FR3,16,-10,0
 LWWW L3GP3Z+FR4,12,7,0
 LWWW L3GP3Z+FR5,18,21,0
 LWWW L3GP3Z+FR6,22,38,0
 LWWW L3GP3Z+FR6,23,37,0
 LWWW L3FH3A+FR6,14,16,0
 LWWW L3FD3B+FR1,26,-8,0

#rollout_tbl
	.long	hrt_break_neck2_anim,rzr_break_neck2_anim
	.long	und_break_neck2_anim,yok_break_neck2_anim
	.long	shn_break_neck2_anim,bam_break_neck2_anim
	.long	dnk_break_neck2_anim,0,lex_break_neck2_anim

#*****************************************************************************
*
* RAZOR'S EDGE

#yoff	equ	50

 SUBR	rzr_combo_razors_edge_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_OFFSET,10,0,0

	.word	ANI_ATTACK_ON,AMODE_PUPPET,32,5,86,100	;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,8,R3PG3B+FR1
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missedcx

	;got him
	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SOUND,82h			;Effort grunt

	WWLLW	ANI_SUPERSLAVE2,10,R3PG3B+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR2,#puppet_tbl,1
	WL	ANI_SET_YVEL,50000h
	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,R3ZR3B+FR1,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,R3ZR3B+FR2,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,R3ZR3B+FR3,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,4,R3ZR3C+FR1,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,4,R3ZR3C+FR2,#puppet_tbl,7

	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2

	WWLLW	ANI_SUPERSLAVE2,12,R3ZR3C+FR3,#puppet_tbl,8
	WWLLW	ANI_SUPERSLAVE2,3,R3ZR3C+FR4,#puppet_tbl,9
	WWLLW	ANI_SUPERSLAVE2,3,R3ZR3C+FR5,#puppet_tbl,10
	WWLLW	ANI_SUPERSLAVE2,3,R3ZR3C+FR6,#puppet_tbl,11
	WWLLW	ANI_SUPERSLAVE2,3,R3ZR3C+FR7,#puppet_tbl,12

	WL	ANI_CODE,HIT_THE_MAT
	.WORD	ANI_INC_COMBO
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,50
	.word	ANI_DAMAGEOPP,D_PILEDRIVER,RD_PILEDRIVER

	WL	ANI_CODE,#set_opp_xflip

	WL	ANI_SLAVEANIM,#rollout_tbl
	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_DETACH

	WL	3,R3ZR3C+FR7
	WL	ANI_CODE,HIT_THE_MAT
	WL	12,R3ZR3C+FR7

	.word	ANI_OFFSET,30,0,0
	WLW	ANI_SET_ZVEL,-20000h,AM_ABS

	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	3,R3GU4A+FR6
	WL	3,R3GU4A+FR7
	WL	3,R3GU4A+FR8
	WL	3,R3GU4A+FR9
	WL	3,R3GU4A+FR10

	.word	ANI_FACEDOWN
	.word	ANI_ZEROVELS
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#missedcx
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WL	ANI_SET_YVEL,50000h

	WL	4,R3PG3B+FR1
	WL	4,R3PG3B+FR2
	WL	4,R3PG3B+FR3
	WL	4,R3PG3B+FR4

	WL	3,R3PG3B+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30

	WLW	ANI_SET_ZVEL,-10000h,AM_ABS

	WL	3,R3PG3B+FR9
	WL	3,R3PG3B+FR10

	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,rzr_faceup_getup2_anim

*****************************************************************************

 SUBR	rzr_razors_edge_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_OFFSET,10,0,0

	.word	ANI_ATTACK_ON,AMODE_PUPPET,32,25,66,21	;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,4,R3PG3B+FR1
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

	;got him
	.WORD	ANI_ADD_MOVE,MOVE_C_6,2,2

	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SOUND,82h			;Effort grunt

	WWLLW	ANI_SUPERSLAVE2,10,R3PG3B+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR2,#puppet_tbl,1
	WL	ANI_SET_YVEL,50000h
	WWLLW	ANI_SUPERSLAVE2,4,R3PG3B+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,R3ZR3B+FR1,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,R3ZR3B+FR2,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,R3ZR3B+FR3,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,4,R3ZR3C+FR1,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,4,R3ZR3C+FR2,#puppet_tbl,7

	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2

	.word	ANI_DRAW_NAME,33

	WWLLW	ANI_SUPERSLAVE2,12,R3ZR3C+FR3,#puppet_tbl,8
	WWLLW	ANI_SUPERSLAVE2,3,R3ZR3C+FR4,#puppet_tbl,9
	WWLLW	ANI_SUPERSLAVE2,3,R3ZR3C+FR5,#puppet_tbl,10
	WWLLW	ANI_SUPERSLAVE2,3,R3ZR3C+FR6,#puppet_tbl,11
	WWLLW	ANI_SUPERSLAVE2,3,R3ZR3C+FR7,#puppet_tbl,12

	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,50
	.word	ANI_DAMAGEOPP,D_PILEDRIVER,RD_PILEDRIVER
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	WL	ANI_CODE,#set_opp_xflip

	WL	ANI_SLAVEANIM,#rollout_tbl
	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_DETACH

	WL	3,R3ZR3C+FR7
	WL	ANI_CODE,HIT_THE_MAT
	WL	12,R3ZR3C+FR7

	.word	ANI_OFFSET,30,0,0
	WLW	ANI_SET_ZVEL,-20000h,AM_ABS

	WL	3,R3GU4A+FR6
	WL	3,R3GU4A+FR7
	WL	3,R3GU4A+FR8
	WL	3,R3GU4A+FR9
	WL	3,R3GU4A+FR10

	.word	ANI_FACEDOWN
	.word	ANI_ZEROVELS
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#missed
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WL	ANI_SET_YVEL,50000h
	WL	4,R3PG3B+FR1
	WL	4,R3PG3B+FR2
	WL	4,R3PG3B+FR3
	WL	4,R3PG3B+FR4

	WL	3,R3PG3B+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30

	WLW	ANI_SET_ZVEL,-10000h,AM_ABS

	WL	3,R3PG3B+FR9
	WL	3,R3PG3B+FR10

	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,rzr_faceup_getup2_anim


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
 LWWW H3PP3X+FR1,13,-38,0
 LWWW H3PP3X+FR2,3,7,0
 LWWW H3PP3X+FR3,6,36,0
 LWWW H3PP3X+FR6,14,54,0
 LWWW H3FR3A+FR6,-19,37,0
 LWWW H3UC3X+FR4,-59,24,0
 LWWW H3UC3X+FR3,-70,21,0
 LWWW H3UC3X+FR2,-57,22,0
 LWWW H3UC3X+FR1,-18,17,0
 LWWW H3UC3X+FR2,-32,20,0
 LWWW H3UC3X+FR5,10,46,0
 LWWW H3PP3X+FR7,102,26,0
 LWWW H3PP3X+FR8,107,6,0
 .long 0
#Razor
 LWWW R3GP3Z+FR1,9,-31,0
 LWWW R3GP3Z+FR2,12,-15,0
 LWWW R3GP3Z+FR3,15,27,0
 LWWW R3TD3A+FR7,25,38,0
 LWWW R3TD3A+FR8,-3,59,0
 LWWW R3FD3B+FR5,-63,33,0
 LWWW R3FD3B+FR4,-78,29,0
 LWWW R3FD3B+FR2,-56,19,0
 LWWW R3FD3B+FR1,-23,18,0
 LWWW R3FD3B+FR3,-39,29,0
 LWWW R3TD3A+FR8,48,51,0
 LWWW R3GP3Z+FR7,100,38,0
 LWWW R3GP3Z+FR8,104,-4,0
 .long 0
#Taker
 LWWW U3PP3X+FR1,16,-35,1
 LWWW U3PP3X+FR2,17,-17,1
 LWWW U3PP3X+FR3,12,-5,1
 LWWW U3FH3A+FR3,21,1,1
 LWWW U3FH3A+FR4,5,31,1
 LWWW U3FD3X+FR6,-6,48,1
 LWWW U3FD3X+FR4,-54,28,1
 LWWW U3FD3X+FR3,-46,31,1
 LWWW U3FD3X+FR2,-26,28,1
 LWWW U3FD3X+FR4,-26,24,1
 LWWW U3FD3X+FR5,34,54,1
 LWWW U3GP3X+FR1,105,18,1
 LWWW U3GP3X+FR2,115,-6,1
 .long 0
#Yokozuna
 LWWW Y3PP3Q+FR1,15,-27,0
 LWWW Y3PP3Q+FR2,16,-15,0
 LWWW Y3PP3Q+FR4,25,0,0
 LWWW Y3PP3Q+FR6,13,26,0
 LWWW Y3FL3W+FR6,1,39,0
 LWWW Y3FL3W+FR7,-15,46,0
 LWWW Y3FD3A+FR5,-60,41,0
 LWWW Y3FD3A+FR4,-70,40,0
 LWWW Y3FD3A+FR3,-60,37,0
 LWWW Y3FD3A+FR4,-41,31,0
 LWWW Y3FD3A+FR5,-4,47,0
 LWWW Y3FD3N+FR3,96,12,0
 LWWW Y3FD3N+FR4,103,27,0
 .long 0
#Shawn
 LWWW S3GP3X+FR1,19,-36,0
 LWWW S3GP3X+FR2,13,-18,0
 LWWW S3GP3X+FR3,17,1,0
 LWWW S3OS3X+FR8,28,42,1
 LWWW S3UC3X+FR6,-6,46,0
 LWWW S3UC3X+FR5,-50,24,0
 LWWW S3UC3X+FR3,-56,18,0
 LWWW S3UC3X+FR2,-49,20,0
 LWWW S3UC3X+FR1,-20,23,0
 LWWW S3UC3X+FR3,-30,21,0
 LWWW S3UC3X+FR5,16,33,0
 LWWW S3FD3X+FR2,110,32,0
 LWWW S3GP3X+FR6,111,3,0
 .long 0
#BamBam
 LWWW B3PP3Q+FR1,10,-34,0
 LWWW B3PP3Q+FR2,14,-12,0
 LWWW B3PP3Q+FR3,19,15,0
 LWWW B4TD3B+FR7,16,42,0
 LWWW B4TD3B+FR8,3,59,0
 LWWW B4UC3B+FR5,-49,39,0
 LWWW B4UC3B+FR4,-68,11,0
 LWWW B4UC3B+FR3,-67,17,0
 LWWW B4UC3B+FR2,-38,21,0
 LWWW B4UC3B+FR4,-42,11,0
 LWWW B4UC3B+FR7,4,50,0
 LWWW B4TD3B+FR8,98,44,0
 LWWW B3FD3C+FR1,102,9,0
 .long 0
#Doink
 LWWW D3PD3Z+FR1,14,-43,1
 LWWW D3PD3Z+FR2,14,-19,1
 LWWW D3PD3Z+FR3,14,6,1
 LWWW D3FD3E+FR4,25,19,0
 LWWW D3FD3E+FR2,-8,53,0
 LWWW D3UC3A+FR6,-49,23,0
 LWWW D3UC3A+FR4,-68,31,0
 LWWW D3UC3A+FR3,-44,32,0
 LWWW D3UC3A+FR2,-22,27,0
 LWWW D3UC3A+FR4,-42,28,0
 LWWW D3UC3A+FR7,32,47,0
 LWWW D3PD3Z+FR8,107,15,1
 LWWW D3PD3Z+FR9,112,-5,1
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3GP3Z+FR1,12,-31,0
 LWWW L3GP3Z+FR2,14,-14,0
 LWWW L3GP3Z+FR3,18,0,0
 LWWW L3GP3Z+FR5,24,32,0
 LWWW L3FH3A+FR6,7,44,0
 LWWW L3UC3X+FR5,-7,52,0
 LWWW L3UC3X+FR4,-68,26,0
 LWWW L3UC3X+FR3,-67,15,0
 LWWW L3UC3X+FR2,-31,14,0
 LWWW L3UC3X+FR3,-39,12,0
 LWWW L3UC3X+FR4,-7,34,0
 LWWW L3FH3A+FR6,97,29,0
 LWWW L3FD3B+FR1,105,2,0
 .long 0

#rollout_tbl
	.long	hrt_break_neck2_anim,rzr_break_neck2_anim
	.long	und_break_neck2_anim,yok_break_neck2_anim
	.long	shn_break_neck2_anim,bam_break_neck2_anim
	.long	dnk_break_neck2_anim,0,lex_break_neck2_anim

#*****************************************************************************
*
* REPEAT-SLASHES

 SUBR	rzr_repeat_slash_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS

	.word	ANI_STARTATTACK,AT_PUNCH,12

	.word	ANI_CLR_BUTCOUNT
	.word	ANI_SET_RPTCOUNT,3

	.word	ANI_ATTACK_ON,AMODE_HITCHECK,35,29,67,121
	WL	1,R3RZ3S+FR2
	.word	ANI_ATTACK_OFF
	WL	ANI_IFSTATUS,#no_leapat

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 11,999,50,40,90000h,TGT_HEAD,87,100,-20

	WL	6,R3RZ3S+FR2
	WL	2,R3RZ3S+FR3
	.word	ANI_SOUND,013h
	WL	2,R3RZ3S+FR4

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_ON,AMODE_RSLASH,35,29,67,121
	WL	ANI_GOTO,#attack_on

#no_leapat
	WL	6,R3RZ3S+FR2
	WL	2,R3RZ3S+FR3
	.word	ANI_SOUND,013h
	WL	2,R3RZ3S+FR4
	.word	ANI_ATTACK_ON,AMODE_RSLASH,35,29,67,121
	WL	ANI_GOTO,#attack_on

#loop
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 9,999,50,40,90000h,TGT_HEAD,87,100,20

	.word	ANI_STARTATTACK,AT_PUNCH,8

	WL	2,R3RD3D+FR8
	WL	2,R3RZ3S+FR2
	WL	2,R3RZ3S+FR3
	.word	ANI_SOUND,013h
	WL	2,R3RZ3S+FR4

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_ATTACK_ON,AMODE_RSLASH2,35,29,67,121
#attack_on
	WL	3,R3RZ3S+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#done_u
	WL	2,R3RZ3S+FR6
	WL	1,R3RZ3S+FR7
	WL	2,R3RZ3S+FR8

	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#done_u2

	.word	ANI_CLR_BUTCOUNT

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 11,999,50,40,90000h,TGT_HEAD,87,100,20

	WL	2,R3RZ3S+FR9
	WL	2,R3RD3D+FR2
	WL	2,R3RD3D+FR3
	.word	ANI_SOUND,014h
	.word	ANI_STARTATTACK,AT_PUNCH,6
	WL	2,R3RD3D+FR4
	WL	2,R3RD3D+FR5
	WL	1,R3RD3D+FR6
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_ATTACK_ON_Z,AMODE_RSLASH2,-64,28,-30,177,137,60
	WL	2,R3RD3D+FR7
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#done_d
	WL	ANI_IFBLOCKED,#done_d
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,3,#done_d
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#loop

#done_d
	WL	ANI_CODE,CALL_SPECIAL_MOVE
	WL	3,R3RD3D+FR8
	WL	3,R3RD3D+FR9
	WL	3,R3RD3D+FR11

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#done_u
	WL	2,R3RZ3S+FR6
	WL	3,R3RZ3S+FR7
	WL	2,R3RZ3S+FR8
#done_u2
	WL	3,R3RZ3S+FR9
	WL	2,R3RZ3S+FR10
	WL	3,R3RZ3S+FR12

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

;#*****************************************************************************
;*
;* CHAIR STUFF
;
;	.ref	CHAIR_SWING
;
; SUBR	rzr_pkup_chair_anim
;
;	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
;	.word	ANI_ZEROVELS
;	.word	ANI_SETSPEED,100h
;
;#lp
;	WL	4,R4WA4C+FR1
;	WL	4,R4WA4C+FR2
;	WL	4,R4WA4C+FR3
;	WL	4,R4WA4C+FR4
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR1,36,-13,1 ;image, x,y,zoff
;	WL	4,R4WA4C+FR5
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR1,39,18,1 ;image, x,y,zoff
;	WL	4,R4WA4C+FR6
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR2,38,74,1 ;image, x,y,zoff
;	WL	4,R4WA4C+FR7
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR3,27,140,1 ;image, x,y,zoff
;	WL	4,R4WA4C+FR8
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR4,-6,144,1 ;image, x,y,zoff
;	WL	4,R4WA4C+FR9
;
;; .word ANI_SINGLESTEP
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR4,-11,144,1 ;image, x,y,zoff
;	WL	4,R4CS4A+FR1
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR5,-41,103,1 ;image, x,y,zoff
;	WL	4,R4CS4A+FR2
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR6,-34,128,1 ;image, x,y,zoff
;	WL	4,R4CS4A+FR3
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR7,26,143,1 ;image, x,y,zoff
;	WL	4,R4CS4A+FR4
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR9,69,79,1 ;image, x,y,zoff
;	WL	4,R4CS4A+FR5
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR10,43,33,1 ;image, x,y,zoff
;	WL	4,R4CS4A+FR6
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR10,50,34,1 ;image, x,y,zoff
;	WL	4,R4CS4A+FR7
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR9,64,85,1 ;image, x,y,zoff
;	WL	4,R4CS4A+FR8
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