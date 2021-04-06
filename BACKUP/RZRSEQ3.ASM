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
	.include	"razorimg.h"

	.include	"miscimg.glo"	;temp!!!

******************************************************************************
* EXTERNAL REFERENCES

	;BRET
	.ref	hrt_hitonground_anim,hrt_3_head_held_anim
	.ref	hrt_flyout_anim,hrt_break_neck2_anim
	.ref	H2AH3A,H2AM3A,H2CP3A,H3BF3A,H3DU3A,H3FR3A,H3GU4A
	.ref	H3HB3A,H3RR3Z,H3PP3X

	;BAM BAM
	.ref	bam_hitonground_xflip_anim,bam_break_neck2_anim
	.ref	bam_flyout_anim,bam_3_head_held_anim
	.ref	bam_hitonground_anim
	.ref	B3BF3C,B3DU3A,B3GU4A,B3RR3Z,B4TD3B,B4BF3A,B3HB3A
	.ref	B3FD3C,B3PP3Q

	;DOINK
	.ref	dnk_hitonground_anim,dnk_break_neck2_anim
	.ref	dnk_flyout_anim,dnk_3_head_held_anim
	.ref	D3AE3B,D3BF3A,D3DU3A,D3FD3E,D3GU4A,D3HT3Z,D3OS3A
	.ref	D3PM4C,D3RR3Z,D3SA3A,D3UC3A,D4SK4A,D3AK3A,D3PD3Z

	;LEX
	.ref	lex_hitonground_anim,lex_flyout_anim
	.ref	lex_3_head_held_anim,lex_break_neck2_anim
	.ref	L3BF3B,L3CP3X,L3DU3A,L3FH3A,L4AM4B,L3BF3A,L4AH4B
	.ref	L3RR3Z,L3FD3B,L3GP3Z

	;RAZOR
	.ref	rzr_hitonground_anim,rzr_flyout_anim
	.ref	rzr_facedown_getup_anim,rzr_break_neck2_anim
	.ref	rzr_dizzy_anim,rzr_faceup_getup_anim,rzr_stand4_anim
	.ref	rzr_faceup_getup2_anim

	;SHAWN
	.ref	shn_hitonground_anim,shn_flyout_anim
	.ref	shn_3_head_held_anim,shn_break_neck2_anim
	.ref	S3BF3A,S3DU3A,S3GU4A,S3OS3X,S4BF3A,S4AH3D,S3RR3Z
	.ref	S3FD3X,S3GP3X

	;TAKER
	.ref	und_hitonground_anim,und_flyout_anim,und_3_head_held_anim
	.ref	und_break_neck2_anim
	.ref	U3AE4A,U3CP3B,U3DU3B,U3FH3A,U4AM4C,U4BF3Z,U4BF3A
	.ref	U3RR3Z,U3PP3X,U3GP3X

	;YOKO
	.ref	yok_hitonground_anim,yok_break_neck2_anim
	.ref	yok_3_head_held_anim
	.ref	Y3BF3A,Y3GU2A,Y3LB3A,Y3FL3W,Y3FD3A,Y3RL1A,Y3RR3Z
	.ref	Y3FD3N,Y3PP3Q

	;MISC
	.ref	CALL_MISSES,am_I_dizzy,make_norm,make_white,tbukl_flip
	.ref	set_my_pal,set_position,set_skeleton_pal,DO_SNAP_MESS
	.ref	start_smoke,SMALL_BOUNCE,CALL_SETUP,halve_bk_xvel
	.ref	set_xdrift,DO_PILE_MESS,B4CD3A,HIT_THE_MAT
	.ref	CALL_SPECIAL_MOVE

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

TSEC 	equ	53

;#*****************************************************************************
;
; SUBR	rzr_flip_fall_anim
;
;	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
;	.word	ANI_ZEROVELS
;	.word	ANI_SETSPEED,100h
;
;; attacker sequence
;	.word	ANI_ATTACK_ON, AMODE_PUPPET,41,96,37,12 ;mode,x,y,w,h
;	WL	6,R4FG3B+FR1
;	.word	ANI_ATTACK_OFF
;
;;check if we hit
;	WL	6,R4FG3B+FR2
;	WL	6,R4FG3B+FR3
;	WL	6,R4FG3B+FR4
;	WL	6,R3KT3A+FR1
;
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_KEEPATTACHED
;	.word	ANI_ATTACHZ,0,0,-4
;
;	WLW	ANI_SUPERSLAVE,#puppet_tbl,0
;	WL	6,R3KT3A+FR2
;	WLW	ANI_SUPERSLAVE,#puppet_tbl,1
;	WL	6,R3KT3A+FR3
;	WLW	ANI_SUPERSLAVE,#puppet_tbl,2
;	WL	6,R3KT3A+FR5
;	WLW	ANI_SUPERSLAVE,#puppet_tbl,3
;	WL	6,R3KT3A+FR6
;	WLW	ANI_SUPERSLAVE,#puppet_tbl,4
;	WL	6,R3KT3A+FR8
;	WLW	ANI_SUPERSLAVE,#puppet_tbl,5
;	WL	6,R3KT3A+FR9
;	WLW	ANI_SUPERSLAVE,#puppet_tbl,6
;	WL	6,R3KT3A+FR10
;	WLW	ANI_SUPERSLAVE,#puppet_tbl,7
;	WL	6,R3KT3A+FR11
;	WL	6,R3KT3A+FR12
;	WL	6,R3GU4A+FR3
;	WL	6,R3GU4A+FR4
;	WL	6,R3GU4A+FR5
;	WL	6,R3GU4A+FR6
;	WL	6,R3GU4A+FR7
;	WL	6,R3GU4A+FR8
;	WL	6,R3GU4A+FR9
;
;	WL	ANI_CODE,#create_img
;
;	WL	6,R3GU4A+FR10
;
;;;;	WL	ANI_SLAVEANIM,#slaveanim_tbl
;
;	.word	ANI_SETMODE,MODE_NORMAL
;	.word	ANI_END
;
;
;#puppet_tbl
; .long #Bret
; .long #Razor
; .long #Taker
; .long #Yokozuna
; .long #Shawn
; .long #BamBam
; .long #Doink
; .long #Adam
; .long #Lex
;#Bret
; .long 0
;#Razor
; LWWW R3TD3A+FR1,79,7,0
; LWWW R3TD3A+FR2,90,9,0
; LWWW R3TD3A+FR3,56,2,0
; LWWW R3TD3A+FR5,13,-7,0
; LWWW R3TD3A+FR6,-29,5,0
; LWWW R3TD3A+FR8,-91,18,0
; LWWW R3TD3A+FR9,-140,2,0
;; LWWW R3TD3A+FR10,-152,1,1
;#Taker
; .long 0
;#Yokozuna
; .long 0
;#Shawn
; .long 0
;#BamBam
; .long 0
;#Doink
; .long 0
;#Adam
; .long 0
;#Lex
; .long 0
;
;
;
;#create_img
;
;	rets
;; .if 0
;;	move	*a13(ATTACH_IMG1),a8,L
;;	jrz	#ok
;;
;;	calla	DELOBJA8
;;
;;#ok
;;
;;	move	*a13(OBJ_XPOS),a0,L	;x val
;;	movi	Y_SCALE_MULTIPLIER,a14
;;	move	*a13(OBJ_ZPOSINT),a1
;;	mpyu	a14,a1			;y val
;;;	move	*a13(OBJ_YPOS),a14,L
;;;	sub	a14,a1
;;
;;	movi	WWFlogo,a2		;* image
;;	move	*a13(OBJ_PRIORITY),a3	;make shadow 1 less
;;	movi	DMAWNZ,a4		;DMA flags
;;	clr	a5			;OID
;;	clr	a6			;x vel
;;	clr	a7			;y vel
;;	calla	BEGINOBJ
;;	move	a8,*a13(ATTACH_IMG1),L
;;
;;	move	*a13(OBJ_YPOSINT),a11	;y offset
;;	move	*a8(OIMG),a0,L
;;	move	*a0(IANIOFFY),a1
;;	add	a11,a1			;add in Y pos & ani-offset
;;	move	a1,*a8(ODYOFF)		;display y offset
;; .endif
;
;	rets
;

#*****************************************************************************
*
* RUG SHAKE

 SUBR	rzr_2_rugshake_anim
 SUBR	rzr_4_rugshake_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,16

	WL	4,R3RG3B+FR1
	WL	4,R3RG3B+FR2
	WL	4,R3RG3B+FR3
	WL	4,R3RG3B+FR4

	.word	ANI_ATTACK_ON, AMODE_PUPPET,38,2,400,38
	WL	4,R3RG3B+FR5
	.word	ANI_ATTACK_OFF

;check if we hit
	WL	ANI_IFNOTSTATUS,#missed

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_KEEPATTACHED
	.word	ANI_ATTACHZ,0,0,-4

	.word	ANI_SET_RPTCOUNT,5
	.word	ANI_SETOPPMODE,MODE_NOSHADOW
#loop
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

	.word	ANI_DEBRISAT,200,1,0,8,0	;%chance,tbl index,x,y,z off
	.word	ANI_SHAKER,30
	.word	ANI_SHAKEALL,2
	WL	ANI_CODE,#impact_sound
	.word	ANI_DAMAGEOPP,D_RUGSLAM

	WWLLW	ANI_SUPERSLAVE2,4,R3RG3B+FR16,#puppet_tbl,10

	.word	ANI_DEC_RPTCOUNT
	
	;first two are free
	WWL	ANI_IF_RPTCOUNT_GE,4,#loop

	;limit of 5 hits
	WL	ANI_IFNOT_RPTCOUNT,#done

	;must hit super punch three times between hits to continue
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,3,#done

	WL	ANI_GOTO,#loop

#done
	WL	ANI_CODE,CALL_SPECIAL_MOVE
	WL	ANI_SLAVEANIM,#release_tbl
	.word	ANI_CLROPPMODE,MODE_NOSHADOW
	.word	ANI_DETACH
	WL	4,R3RG3B+FR4
	WL	4,R3RG3B+FR3
	WL	4,R3RG3B+FR2
	WL	4,R3RG3B+FR1

	.word	ANI_SETFACING
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
	WL	4,R3RG3B+FR4
	WL	4,R3RG3B+FR3
	WL	4,R3RG3B+FR2
	WL	4,R3RG3B+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


 SUBRP	#impact_sound

	move	*a13(ATTACH_PROC),a0,L
	jrz	#done
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
 LWWW H2CP3A+FR8,31,-50,1
 LWWW H3RR3Z+FR2,32,-30,1
 LWWW H3RR3Z+FR3,50,-31,1
 LWWW H3RR3Z+FR4,46,2,1
 LWWW H3RR3Z+FR5,16,23,1
 LWWW H3RR3Z+FR6,3,101,1
 LWWW H3RR3Z+FR7,7,110,1
 LWWW H3RR3Z+FR8,-21,97,1
 LWWW H3RR3Z+FR9,47,86,1
 LWWW H3RR3Z+FR10,60,-13,1
 LWWW H2CP3A+FR8,32,-50,1
#Razor
 LWWW R3RR3Z+FR2,29,-49,1
 LWWW R3RR3Z+FR3,32,-37,1
 LWWW R3RR3Z+FR4,43,-38,1
 LWWW R3RR3Z+FR5,40,-2,1
 LWWW R3RR3Z+FR6,22,53,1
 LWWW R3RR3Z+FR7,6,104,1
 LWWW R3RR3Z+FR8,7,130,1
 LWWW R3RR3Z+FR8,31,127,1
 LWWW R3RR3Z+FR9,49,92,1
 LWWW R3RR3Z+FR1,59,7,1
 LWWW R3RR3Z+FR2,30,-49,1
#Taker
 LWWW U3CP3B+FR1,26,-46,1
 LWWW U3RR3Z+FR2,33,-25,1
 LWWW U3RR3Z+FR3,32,-17,1
 LWWW U3RR3Z+FR4,38,-3,1
 LWWW U3RR3Z+FR5,15,27,1
 LWWW U3RR3Z+FR6,4,100,1
 LWWW U3RR3Z+FR7,-33,119,1
 LWWW U3RR3Z+FR8,-50,94,1
 LWWW U3RR3Z+FR9,47,106,1
 LWWW U3RR3Z+FR10,62,-1,1
 LWWW U3CP3B+FR1,27,-46,1
#Yokozuna
 LWWW Y3RL1A+FR1,25,-36,1
 LWWW Y3RR3Z+FR2,39,-30,1
 LWWW Y3RR3Z+FR3,40,-30,1
 LWWW Y3RR3Z+FR4,39,13,1
 LWWW Y3RR3Z+FR5,10,27,1
 LWWW Y3RR3Z+FR6,1,105,1
 LWWW Y3RR3Z+FR7,1,116,1
 LWWW Y3RR3Z+FR8,-32,77,1
 LWWW Y3RR3Z+FR9,45,84,1
 LWWW Y3RR3Z+FR10,51,11,1
 LWWW Y3RL1A+FR1,26,-36,1
#Shawn
 LWWW S3RR3Z+FR2,23,-48,1
 LWWW S3RR3Z+FR3,30,-36,1
 LWWW S3RR3Z+FR4,49,-34,1
 LWWW S3RR3Z+FR5,45,0,1
 LWWW S3RR3Z+FR6,19,30,1
 LWWW S3RR3Z+FR7,7,92,1
 LWWW S3RR3Z+FR8,-13,110,1
 LWWW S3RR3Z+FR9,-22,97,1
 LWWW S3RR3Z+FR10,39,82,1
 LWWW S3RR3Z+FR10,66,61,1
 LWWW S3RR3Z+FR2,24,-48,1
#BamBam
 LWWW B3RR3Z+FR2,34,-42,1
 LWWW B3RR3Z+FR3,29,-45,1
 LWWW B3RR3Z+FR4,45,-24,1
 LWWW B3RR3Z+FR5,42,4,1
 LWWW B3RR3Z+FR6,25,22,1
 LWWW B3RR3Z+FR7,0,120,1
 LWWW B3RR3Z+FR8,-5,134,1
 LWWW B3RR3Z+FR9,-4,99,1
 LWWW B3RR3Z+FR10,53,76,1
 LWWW B3RR3Z+FR1,61,-14,1
 LWWW B3RR3Z+FR2,35,-42,1
#Doink
 LWWW D3GU4A+FR1,36,-50,1
 LWWW D3RR3Z+FR1,33,-37,1
 LWWW D3RR3Z+FR2,49,-35,1
 LWWW D3RR3Z+FR3,49,1,1
 LWWW D3RR3Z+FR4,22,48,1
 LWWW D3RR3Z+FR5,4,99,1
 LWWW D3RR3Z+FR6,1,107,1
 LWWW D3RR3Z+FR6,26,104,1
 LWWW D3RR3Z+FR7,45,93,1
 LWWW D3UC3A+FR5,68,12,0
 LWWW D3GU4A+FR1,37,-50,1
#Adam
 .long 0
#Lex
 LWWW L3RR3Z+FR1,31,-51,1
 LWWW L3RR3Z+FR2,29,-39,1
 LWWW L3RR3Z+FR3,44,-35,1
 LWWW L3RR3Z+FR4,47,-1,1
 LWWW L3RR3Z+FR5,19,18,1
 LWWW L3RR3Z+FR6,4,72,1
 LWWW L3RR3Z+FR7,-1,105,1
 LWWW L3RR3Z+FR8,11,92,1
 LWWW L3RR3Z+FR9,48,59,1
 LWWW L3RR3Z+FR9,63,39,1
 LWWW L3RR3Z+FR10,40,-40,1

#release_tbl
	.long	hrt_hitonground_anim,rzr_hitonground_anim
	.long	und_hitonground_anim,yok_hitonground_anim
	.long	shn_hitonground_anim,bam_hitonground_anim
	.long	dnk_hitonground_anim,0,lex_hitonground_anim

#*****************************************************************************
*
* GET BUZZED FROM DOINK

 SUBR	rzr_get_buzz_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
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

;MJT Start

	WL	1,R4ST4G+FR1
	.ref	am_I_dead
	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	.ref	rzr_fall_back_anim

	WL	ANI_CHANGEANIM,rzr_fall_back_anim
	.word	ANI_END

#nodead
;MJT End

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


******************************************************************************


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

 SUBR	rzr_2_hiptoss_anim
 SUBR	rzr_4_hiptoss_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_NOCONFINE
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 8,40,40,40,90000h,TGT_CHEST,40,0,0
	WL	ANI_SET_YVEL,0000h
	.word	ANI_STARTATTACK,AT_PUPPET,8

	.word	ANI_ATTACK_ON, AMODE_PUPPET,19,61,39,16
	WWL	ANI_WAITHITOPP,6,R4FT3A+FR2
	.word	ANI_ZERO_XZVELS
	WWL	ANI_WAITHITOPP,2,R4FT3A+FR2
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missed

	;got him
	WL	ANI_CODE,DO_SNAP_MESS
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	.word	ANI_ATTACHZ,0,0,10		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,6,R4FT3A+FR2,#puppet_tbl,0

	WL	ANI_SET_YVEL,50000h

	WWLLW	ANI_SUPERSLAVE2,5,R4FT3A+FR3,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,R4FT3A+FR4,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,R4FT3A+FR5,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,R4FT3A+FR6,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,R4FT3A+FR7,#puppet_tbl,5

	;impact
	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,60
	.word	ANI_DAMAGEOPP,D_BSLAM

	WWLLW	ANI_SUPERSLAVE2,2,R4FT3A+FR8,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,3,R4FT3A+FR9,#puppet_tbl,7

	WL	ANI_OPPOFFSET,#release_offsets
	WL	ANI_XFLIP_TBL,#xflip_tbl
	WL	ANI_SLAVEANIM,#recover_tbl
	.word	ANI_DETACH

	.word	ANI_OFFSET,-40,0,0
	.word	ANI_XFLIP
	WL	ANI_CHANGEANIM,rzr_facedown_getup_anim


#missed
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


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
	.long	hrt_flyout_anim,rzr_flyout_anim
	.long	und_flyout_anim,0
	.long	shn_flyout_anim,bam_flyout_anim
	.long	dnk_flyout_anim,0,lex_flyout_anim

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

	WL	4,R3RG3B+FR2

	LEAPATOPP 8,999,80,80,30000h,TGT_HEAD,26,6,-2

	WL	4,R3RG3B+FR3
	WL	4,R3RG3B+FR4
	.word	ANI_ZERO_XZVELS

	.word	ANI_ATTACK_ON, AMODE_PUPPET,28,0,23,25 ;mode,x,y,w,h
	WL	4,R3RG3B+FR5
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;got him
	WL	ANI_CODE,CALL_SETUP

	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SOUND,33h			;neck break (5-7 ticks late)
	.word	ANI_DAMAGEOPP,D_HAIR_PICKUP

	WWLLW	ANI_SUPERSLAVE2,4,R3RG3B+FR6,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,4,R3RG3Z+FR1,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,R3RG3Z+FR2,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,R3RG3Z+FR3,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,4,R4GH3A+FR7,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,4,R4GH3A+FR7,#puppet_tbl,5

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	3,R4GH3A+FR7
	.word	ANI_CLROPPMODE,MODE_GHOST

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
	WL	20,R3RG3B+FR5
	WL	4,R3RG3B+FR4
	WL	4,R3RG3B+FR3
	WL	4,R3RG3B+FR2

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
 LWWW H3GU4A+FR1,21,-36,0
 LWWW H3GU4A+FR3,35,-40,0
 LWWW H3DU3A+FR3,31,-31,1
 LWWW H3DU3A+FR4,34,-30,1
 LWWW H3DU3A+FR5,55,-42,1
 LWWW H3BF3A+FR1,65,-41,0
 .long 0
#Razor
 LWWW R3GU4A+FR2,27,-39,1
 LWWW R3GU4A+FR3,27,-35,0
 LWWW R3GU4A+FR5,37,-39,0
 LWWW R3DU3B+FR2,31,-40,1
 LWWW R3DU3B+FR4,59,-38,1
 LWWW R3BF3A+FR4,70,-40,0
 .long 0
#Taker
 LWWW U3DU3B+FR2,26,-32,1
 LWWW U3DU3B+FR5,24,-33,1
 LWWW U3DU3B+FR6,28,-33,1
 LWWW U3DU3B+FR8,34,-30,1
 LWWW U3DU3B+FR10,75,-32,1
 LWWW U4BF3Z+FR5,65,-20,0
 .long 0
#Yokozuna
 LWWW Y3GU2A+FR1,23,-27,0
 LWWW Y3GU2A+FR3,30,-25,0
 LWWW Y3GU2A+FR6,15,-35,0
 LWWW Y3GU2A+FR9,36,-37,0
 LWWW Y3GU2A+FR12,68,-31,0
 LWWW Y3BF3A+FR1,72,-29,0
 .long 0
#Shawn
 LWWW S3GU4A+FR1,23,-38,1
 LWWW S3GU4A+FR2,26,-33,0
 LWWW S3GU4A+FR4,37,-32,0
 LWWW S3GU4A+FR5,34,-36,0
 LWWW S3DU3A+FR2,63,-45,1
 LWWW S3BF3A+FR1,56,-40,0
 .long 0
#BamBam
 LWWW B3GU4A+FR3,29,-25,0
 LWWW B3GU4A+FR4,35,-32,0
 LWWW B3GU4A+FR6,26,-28,0
 LWWW B3GU4A+FR7,25,-41,0
 LWWW B3DU3A+FR2,64,-38,1
 LWWW B3BF3C+FR5,74,-32,0
 .long 0
#Doink
 LWWW D3DU3A+FR2,25,-31,1
 LWWW D3DU3A+FR3,36,-34,1
 LWWW D3DU3A+FR5,30,-30,1
 LWWW D3DU3A+FR8,34,-39,1
 LWWW D3HT3Z+FR1,61,-39,1
 LWWW D3BF3A+FR2,74,-39,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3DU3A+FR2,30,-35,1
 LWWW L3DU3A+FR4,14,-26,1
 LWWW L3DU3A+FR6,20,-33,1
 LWWW L3DU3A+FR7,27,-27,1
 LWWW L3DU3A+FR9,68,-42,1
 LWWW L3BF3B+FR2,69,-43,0
 .long 0

#*****************************************************************************
*
* CLIMB UP TURNBUCKLES

 SUBR	rzr_climb_up_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SHAKECORNER

	.word	ANI_OFFSET,-2,7,-4	;-10,17,-16, distributed over 5 frames
	WL	3,R2CT2E+FR1
	.word	ANI_OFFSET,-2,5+3,-4
	WL	3,R2CT2E+FR2
	.word	ANI_OFFSET,-2,5+3,-4
	WL	3,R2CT2E+FR3
	.word	ANI_OFFSET,-2,-1+3,-4
	WL	3,R2CT2E+FR4
	.word	ANI_OFFSET,-2,6+3,0
	WL	3,R2CT2E+FR5
	.word	ANI_SHAKECORNER
	.word	ANI_OFFSET,0,12,0
	WL	3,R2CT2E+FR6
	.word	ANI_OFFSET,0,3,0
	WL	3,R2CT2E+FR7
	.word	ANI_OFFSET,0,1,0
	WL	3,R2CT2E+FR8
	.word	ANI_OFFSET,0,-1,0
	WL	3,R2CT2E+FR9
	.word	ANI_OFFSET,0,8,0
	WL	3,R2CT2E+FR10
	.word	ANI_OFFSET,0,12,0
	WL	3,R2CT2E+FR11
	.word	ANI_SHAKECORNER
	.word	ANI_OFFSET,0,1,0
	WL	3,R2CT2E+FR2
	.word	ANI_OFFSET,0,2,0
	WL	3,R2CT2E+FR3
	.word	ANI_OFFSET,0,6,0
	WL	3,R2CT2E+FR4
	.word	ANI_OFFSET,0,7,0
	WL	3,R2CT2E+FR5
	.word	ANI_OFFSET,0,9,0
	WL	3,R2CT2E+FR6

	.word	ANI_OFFSET,-4,-2,0
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONTURNBKL
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE|MODE_NOGRAVITY

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

	.word	ANI_SHAKECORNER
	.word	ANI_OFFSET,4,2,0
	WL	3,R2CT2E+FR6
	.word	ANI_OFFSET,0,-9,0
	WL	3,R2CT2E+FR5
	.word	ANI_OFFSET,0,-7,0
	WL	3,R2CT2E+FR4
	.word	ANI_OFFSET,0,-6,0
	WL	3,R2CT2E+FR3
	.word	ANI_OFFSET,0,-2,0
	WL	3,R2CT2E+FR2
	.word	ANI_SHAKECORNER
	.word	ANI_OFFSET,0,-1,0
	WL	3,R2CT2E+FR11
	.word	ANI_OFFSET,0,-12,0
	WL	3,R2CT2E+FR10
	.word	ANI_OFFSET,0,-8,0
	WL	3,R2CT2E+FR9
	.word	ANI_OFFSET,0,1,0
	WL	3,R2CT2E+FR8
	.word	ANI_OFFSET,0,-1,0
	WL	3,R2CT2E+FR7
	.word	ANI_OFFSET,0,-3,0
	.word	ANI_SHAKECORNER
	WL	3,R2CT2E+FR6
	.word	ANI_OFFSET,0,-12,0
	WL	3,R2CT2E+FR5
	.word	ANI_OFFSET,2,-9,0
	WL	3,R2CT2E+FR4
	.word	ANI_OFFSET,2,-2,4
	WL	3,R2CT2E+FR3
	.word	ANI_OFFSET,2,-8,4
	WL	3,R2CT2E+FR2
	.word	ANI_OFFSET,2,-8,4
	WL	3,R2CT2E+FR1
	.word	ANI_OFFSET,2,-7,4

	.word	ANI_FACEDOWN
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#******************************************************************************

 SUBR	rzr_4_taunt_anim

	.word	ANI_SETMODE,MODE_UNINT
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	4,R4CO4A+FR1
	WL	4,R4CO4A+FR2
	WL	4,R4CO4A+FR3
	WL	4,R4CO4A+FR4
	WL	15,R4CO4A+FR5
	WL	4,R4CO4A+FR6
	WL	4,R4CO4A+FR7
	WL	4,R4CO4A+FR8
	WL	4,R4CO4A+FR7
	WL	4,R4CO4A+FR6
	WL	4,R4CO4A+FR5
	WL	4,R4CO4A+FR6
	WL	4,R4CO4A+FR7
	WL	4,R4CO4A+FR8
	WL	4,R4CO4A+FR7
	WL	4,R4CO4A+FR6
	WL	15,R4CO4A+FR5
	WL	4,R4CO4A+FR4
	WL	4,R4CO4A+FR3
	WL	4,R4CO4A+FR2
	WL	4,R4CO4A+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,rzr_stand4_anim
	.word	ANI_END

#*****************************************************************************
*
* Head slams into mat
;From head slam - repeated head slam

 SUBR	rzr_break_face2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	.word	ANI_ZEROVELS

	WL	2,R3MS3Q+FR1
	WL	ANI_SET_YVEL,80000h
	WL	3,R3MS3Q+FR2
	WL	3,R3MS3Q+FR3
	WL	3,R3MS3Q+FR4
	.word	ANI_WAITHITGND
	.word	ANI_END
	

* Head slams into mat
;From head slam

 SUBR	rzr_break_face_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	.word	ANI_ZEROVELS

	WL	2,R3MS3Q+FR1
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
	.word	ANI_END
	
#*****************************************************************************

	.bss	#opp_xvel,32

 SUBR	rzr_3_head_hold_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold

	.word	ANI_STARTATTACK,AT_PUPPET,12
	WL	3,R4GH3A+FR1
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 9,999,60,40,90000h,TGT_HEAD,56,93,8
	WL	ANI_CODE,halve_bk_xvel
	WL	3,R4GH3A+FR2

	.word	ANI_ATTACK_ON, AMODE_PUPPET,40,80,37,23 ;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,6,R4GH3A+FR3

	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	WL	ANI_IFBLOCKED,#missed

;got him

	WL	ANI_CODE,CALL_SETUP

	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,4,R4GH3A+FR3,#puppet_tbl,0

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WWLLW	ANI_SUPERSLAVE2,4,R4GH3A+FR5,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,R4GH3A+FR6,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,R4GH3A+FR7,#puppet_tbl,3

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	4,R4GH3A+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	25,R4GH3A+FR3
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
 LWWW H2AH3A+FR1,53,7,0
 LWWW H3HB3A+FR3,68,-7,0
 LWWW H3HB3A+FR2,59,-14,0
 LWWW H3HB3A+FR1,63,-39,0
 .long 0
#Razor
 LWWW R3HB3A+FR3,71,-10,0
 LWWW R3HB3A+FR3,71,-4,0
 LWWW R3HB3A+FR2,72,-24,0
 LWWW R3BF3A+FR1,68,-41,0
 .long 0
#Taker
 LWWW U4AM4C+FR2,57,-3,0
 LWWW U4BF3A+FR2,66,-1,0
 LWWW U4BF3A+FR3,44,-14,0
 LWWW U4BF3Z+FR3,68,-28,0
 .long 0
#Yokozuna
 LWWW Y3LB3A+FR2,74,-6,0
 LWWW Y3LB3A+FR2,74,0,0
 LWWW Y3LB3A+FR9,60,-24,0
 LWWW Y3BF3A+FR1,72,-29,0
 .long 0
#Shawn
 LWWW S4AH3D+FR5,54,-7,0
 LWWW S4AH3D+FR5,54,-1,0
 LWWW S4BF3A+FR2,63,-16,0
 LWWW S4BF3A+FR3,49,-27,0
 .long 0
#BamBam
 LWWW B4BF3A+FR1,79,-6,0
 LWWW B4BF3A+FR1,79,0,0
 LWWW B3HB3A+FR2,71,-30,0
 LWWW B3BF3C+FR5,69,-33,0
 .long 0
#Doink
 LWWW D3AK3A+FR3,51,5,0
 LWWW D3AK3A+FR3,52,10,0
 LWWW D3AK3A+FR2,62,-10,0
 LWWW D3BF3A+FR1,67,-39,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L4AH4B+FR3,49,-6,0
 LWWW L3BF3A+FR1,72,-4,1
 LWWW L3BF3A+FR2,69,-19,1
 LWWW L3BF3B+FR5,65,-36,0
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

 SUBR	rzr_3_pile_driver_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_ATTACK_ON,AMODE_PUPPET,32,25,66,21	;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,4,R3PG3B+FR1
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

	;got him
	WL	ANI_CODE,DO_PILE_MESS

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

	.word	ANI_SOUND,0C1h			;plywood crash #3
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_PILEDRIVER
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

	WL	4,B4CD3A+FR3
	WL	4,B4CD3A+FR4
	WL	4,B4CD3A+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30

	WL	4,B4CD3A+FR6

	WL	4,B4CD3A+FR6

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

******************************************************************************

	.end
