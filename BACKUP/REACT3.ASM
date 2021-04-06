**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		8/8/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"react3.asm"
	.title	"wrester reactions to hits"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"macros.h"
	.include	"mproc.equ"		;Mproc equates
	.include	"display.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"sys.equ"
	.include	"game.equ"
	.include	"plyr.equ"
	.include	"anim.equ"
	.include	"audit.equ"
	.include	"sound.h"
	.include 	"ring.equ"
	.include	"lifebar.h"


******************************************************************************
* EXTERNAL REFERENCES
*
	.REF	CALL_MID_HIT

	.REF	CALL_DROP_KICK
	.ref	change_anim1a
	.ref	wres_collis_off
;MJT Start
;	.ref	inc_burnout
;MJT End
	.ref	block_hit
	.ref	face_each_other
	.ref	wres_slave_anim
	.ref	set_getup_time
	.ref	check_dizzy

******************************************************************************
* EXTERNAL ANIM SEQUENCES


;BAM BAM
	.ref	bam_2_body_hit_anim,bam_4_body_hit_anim
	.ref	bam_fall_back_anim

;DOINK
	.ref	dnk_fall_back_anim

;BRET
	.ref	hrt_fall_back_anim
;LEX
	.ref	lex_2_body_hit_anim,lex_4_body_hit_anim
	.ref	lex_fall_back_anim

;RAZOR
	.ref	rzr_2_body_hit_anim,rzr_4_body_hit_anim
	.ref	rzr_fall_back_anim

;SHAWN
	.ref	shn_2_body_hit_anim,shn_4_body_hit_anim
	.ref	shn_fall_back_anim

;TAKER
	.ref	und_2_body_hit_anim,und_4_body_hit_anim
	.ref	und_fall_back_anim
	.ref	und_2_knee_hit_anim,und_4_knee_hit_anim

;YOKO
	.ref	yok_fall_back_anim


******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************

;MJT Start
;#*****************************************************************************
;;AMODE_HIPTOSS	10
; SUBR	hit_hiptoss
;
;
;;
;;this will change to a puppet move
;;
;;Fix debug mode death bug....
;
;	GETLIFE
;	jrz	#isdead
;
;	calla	face_each_other
;
;	move	a10,*a13(ATTACH_PROC),L		;proc attached to
;	move	a13,*a10(ATTACH_PROC),L
;
;	movi	MODE_MASTER,a0
;	move	a0,*a10(PLYRMODE)
;	movi	MODE_SLAVE,a0
;	move	a0,*a13(PLYRMODE)
;
;	WRSNDX	HIPTOSS_L1,HIPTOSS_L2
;
;	clr	a0
;	move	a0,*a13(ROLL_POS)
;	calla	set_getup_time
;
;;Any hit mode which does a fall back sequence onto the ground
;;will not check dizzy at the start.
;;The check dizzy happens in the sequence.
;
;;;;	movi	dnk_hiptossfall_anim,a0
;
;	movi	wres_slave_anim,a0
;	calla	change_anim1a
;
;	calla	wres_collis_off
;#isdead
;	rets


#*****************************************************************************
;AMODE_BIGBOOT	11
 SUBR	hit_bigboot

	move	*a13(PLYRMODE),a1
	cmpi	MODE_RUNNING,a1
;No hit if not running
	jrz	#cont
	cmpi	MODE_INAIR,a1
	jrz	#cont

	CALLA	CALL_FACE_HIT

	GETLIFE
	jrz	#isdead

	WRSNDX	HDBUTT_L1,HDBUTT_L2

	SETMODE	NORMAL

	.ref	head_hit2_tbl
	FACE24TBL head_hit2_tbl
	calla	change_anim1a

#isdead
	calla	wres_collis_off
	rets

#cont
	CALLA	CALL_DROP_KICK

	WRSNDX	LBOWDROP_L1,LBOWDROP_L2
	GETLIFE
	jrz	#skip

;Any hit mode which does a fall back sequence onto the ground
;will not check dizzy at the start.
;The check dizzy happens in the sequence.


;	calla	inc_burnout

	SETMODE	NORMAL
#skip
	clr	a0
	move	a0,*a13(ROLL_POS)
	calla	set_getup_time

	.ref	fall_back_tbl
	FACETBL	fall_back_tbl
	calla	change_anim1a

	movi	[3,0],a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;offx - defx
	jrgt	#fall_right		;attacker on left
	movi	[-3,0],a2
#fall_right
	move	a2,*a13(OBJ_XVEL),L


	calla	wres_collis_off
;#isdead2
	rets

;MJT End

#*****************************************************************************
;AMODE_KNEE	12
 SUBR	hit_knee


	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	calla	block_hit
	rets

#noblock

	CALLA	CALL_MID_HIT


	GETLIFE
	jrz	#isdead

	WRSNDX	KICK_L1,KICK_L2

	move	*a13(PLYR_DIZZY),a0
	jrnz	#diz

	calla	check_dizzy
	jrz	#not_dizzy

	movi	5*TSEC,a0
	move	a0,*a13(GETUP_TIME)

#diz
 	FACE24TBL #knee_hit_dizzy
	jruc	#cont

#not_dizzy

;MJT Start
;	calla	inc_burnout
;MJT End

	SETMODE	NORMAL

	FACE24TBL #knee_hit
#cont
	calla	change_anim1a

	move	*a10(OBJ_XVEL),a0,L		;slow down doink's
	sra	3,a0				;x_vel after collis
	move	a0,*a10(OBJ_XVEL),L

#isdead
	calla	wres_collis_off
	rets

#knee_hit
	.ref	hrt_2_knee_hit_anim,hrt_4_knee_hit_anim
	.ref	yok_2_knee_hit_anim,yok_4_knee_hit_anim
	.ref	rzr_2_knee_hit_anim,rzr_4_knee_hit_anim
	.ref	und_2_knee_hit_anim,und_4_knee_hit_anim	
	.ref	shn_2_knee_hit_anim,shn_4_knee_hit_anim	
	.ref	bam_2_knee_hit_anim,bam_4_knee_hit_anim	
	.ref	dnk_2_knee_hit_anim
	.ref	lex_2_knee_hit_anim,lex_4_knee_hit_anim	

	.long	hrt_2_knee_hit_anim,hrt_4_knee_hit_anim		;0 Bret Hart
	.long	rzr_2_knee_hit_anim,rzr_4_knee_hit_anim		;1 Razor Ramon
	.long	und_2_knee_hit_anim,und_4_knee_hit_anim		;2 Undertaker
	.long	yok_2_knee_hit_anim,yok_4_knee_hit_anim		;3 Yokozuna
	.long	shn_2_knee_hit_anim,shn_4_knee_hit_anim		;4 Shawn Michaels
	.long	bam_2_knee_hit_anim,bam_4_knee_hit_anim		;5 Bam Bam
	.long	dnk_2_knee_hit_anim,dnk_2_knee_hit_anim		;6 Doink
	.long	0,0						;7 spare
	.long	lex_2_knee_hit_anim,lex_4_knee_hit_anim		;8 Lex Luger
	.long	0,0						;9 Referee

#knee_hit_dizzy
	.ref	hrt_4_knee_hit_dizzy_anim
	.ref	yok_4_knee_hit_dizzy_anim
	.ref	rzr_4_knee_hit_dizzy_anim
	.ref	und_4_knee_hit_dizzy_anim
	.ref	shn_4_knee_hit_dizzy_anim
	.ref	bam_4_knee_hit_dizzy_anim
	.ref	dnk_4_knee_hit_dizzy_anim
	.ref	lex_4_knee_hit_dizzy_anim

	.long	hrt_4_knee_hit_dizzy_anim,hrt_4_knee_hit_dizzy_anim	;0 Bret Hart
	.long	rzr_4_knee_hit_dizzy_anim,rzr_4_knee_hit_dizzy_anim	;1 Razor Ramon
	.long	und_4_knee_hit_dizzy_anim,und_4_knee_hit_dizzy_anim	;4 Undertaker
	.long	yok_4_knee_hit_dizzy_anim,yok_4_knee_hit_dizzy_anim	;3 Yokozuna
	.long	shn_4_knee_hit_dizzy_anim,shn_4_knee_hit_dizzy_anim	;4 Shawn Michaels
	.long	bam_4_knee_hit_dizzy_anim,bam_4_knee_hit_dizzy_anim	;5 Bam Bam
	.long	dnk_4_knee_hit_dizzy_anim,dnk_4_knee_hit_dizzy_anim	;6 Doink
	.long	0,0							;7 spare
	.long	lex_4_knee_hit_dizzy_anim,lex_4_knee_hit_dizzy_anim	;8 Lex Luger
	.long	0,0							;9 Referee


#*****************************************************************************
;AMODE_KNEE	27
 SUBR	hit_headknees

	WRSNDX	KICK_L1,KICK_L2

;MJT Start
;	GETLIFE
;	jrz	#isdead
;MJT End

	movi	40000h,a0
	move	a0,*a13(OBJ_YVEL),L

	FACETBL #knee_hit
	calla	change_anim1a

	calla	wres_collis_off
	rets

;#isdead

;MJT Start
;	FACETBL	fall_back_tbl
;	calla	change_anim1a
;
;	movi	[4,0],a2
;	move	*a10(OBJ_XPOSINT),a0
;	move	*a13(OBJ_XPOSINT),a1
;	cmp	a0,a1			;offx - defx
;	jrgt	#go_rgt			;attacker on left
;	neg	a2
;#go_rgt
;	move	a2,*a13(OBJ_XVEL),L

;MJT End
	calla	wres_collis_off
	rets

#knee_hit
;FIX!!
;NOTE:  Meter will come out if dizzy achieved, yet this reaction does
;not end in a dizzy!

	.ref	dnk_quick_knee_hit_anim
	.ref	hrt_quick_knee_hit_anim
	.ref	yok_quick_knee_hit_anim
	.ref	bam_quick_knee_hit_anim
	.ref	und_quick_knee_hit_anim
	.ref	rzr_quick_knee_hit_anim
	.ref	shn_quick_knee_hit_anim
	.ref	lex_quick_knee_hit_anim

	.long	hrt_quick_knee_hit_anim	;0 Bret Hart
	.long	rzr_quick_knee_hit_anim	;1 Razor Ramon
	.long	und_quick_knee_hit_anim	;2 Undertaker
	.long	yok_quick_knee_hit_anim	;3 Yokozuna
	.long	shn_quick_knee_hit_anim	;4 Shawn Michaels
	.long	bam_quick_knee_hit_anim	;5 Bam Bam
	.long	dnk_quick_knee_hit_anim	;6 Doink
	.long	0		       	;7 spare
	.long	lex_quick_knee_hit_anim	;8 Lex Luger
	.long	0						;9 Referee


;MJT Start
;AMODE_GRAPPLE	13
;MJT End

#*****************************************************************************
;AMODE_BOXPUNCH 14
 SUBR	hit_boxpunch

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	move	*a13(FACING_DIR),a0		;check for hit
	move	*a13(NEW_FACING_DIR),a1		;from behind
	and	a0,a1
	andi	MOVE_LEFT|MOVE_RIGHT,a1
	jrz	#noblock

	calla	block_hit
	rets

#noblock

;All of the damage amounts need to be in lookup tables linked to the wrestler
;who actually struck the blow.

	.ref	CALL_FACE_HIT
	CALLA	CALL_FACE_HIT

;Any hit mode which does a fall back sequence onto the ground
;will not check dizzy at the start.
;The check dizzy happens in the sequence.

;MJT Start
	WRSNDX	FLYKICK_L1,FLYKICK_L2
	GETLIFE
	jrz	#skip


	SETMODE	NORMAL
#skip
;MJT End
	movi	5*TSEC,a0
	move	a0,*a13(GETUP_TIME)

	FACETBL	fall_back_tbl
	calla	change_anim1a

	movi	[4,0],a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;offx - defx
	jrgt	#go_rgt			;attacker on left
	neg	a2
#go_rgt
	move	a2,*a13(OBJ_XVEL),L

#isdead
	calla	wres_collis_off
	rets

;#fall_back
;	.long	hrt_fall_back_anim		;0 Bret Hart
;	.long	rzr_fall_back_anim		;1 Razor Ramon
;	.long	und_fall_back_anim		;2 Undertaker
;	.long	yok_fall_back_anim		;3 Yokozuna
;	.long	shn_fall_back_anim		;4 Shawn Michaels
;	.long	bam_fall_back_anim		;5 Bam Bam
;	.long	dnk_fall_back_anim		;6 Doink
;	.long	0				;7 spare
;	.long	lex_fall_back_anim		;8 Lex Luger
;	.long	0				;9 Referee

******************************************************************************
	.end

