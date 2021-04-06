**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		8/8/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"react8.asm"
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

	.REF	CALL_NASTY_MOVE

;BAM BAM
	.ref	bam_2_head_hit_anim,bam_4_head_hit_anim
	.ref	bam_head_hit_dizzy_anim

;DOINK
	.ref	dnk_fall_back_anim,dnk_2_head_hit_anim
	.ref	dnk_head_hit_dizzy_anim,dnk_4_head_hit_anim

;BRET
	.ref	hrt_fall_back_anim,hrt_4_head_hit_dizzy_anim
	.ref	hrt_4_head_hit_anim,hrt_2_head_hit_anim

;LEX
	.ref	lex_fall_back_anim,lex_2_head_hit_anim
	.ref	lex_4_head_hit_anim,lex_head_hit_dizzy_anim

;RAZOR
	.ref	rzr_fall_back_anim,rzr_2_head_hit_anim
	.ref	rzr_4_head_hit_dizzy_anim,rzr_4_head_hit_anim

;SHAWN
	.ref	shn_fall_back_anim,shn_4_head_hit_dizzy_anim
	.ref	shn_2_head_hit_anim,shn_4_head_hit_anim

;TAKER
	.ref	und_fall_back_anim,und_head_hit_dizzy_anim
	.ref	und_2_head_hit_anim,und_4_head_hit_anim

;YOKO
	.ref	yok_fall_back_anim,yok_2_head_hit_anim
	.ref	yok_4_head_hit_dizzy_anim,yok_4_head_hit_anim


;MJT Start
	.ref	change_anim1a,wres_collis_off,block_hit
;,inc_burnout
;MJT End
	.ref	create_damage_points,set_getup_time,check_dizzy
	.ref	wres_slave_anim,hit_flykick

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************


#*****************************************************************************
;AMODE_ATT35	35
 SUBR	hit_shnbfkik

	;This has to be a separate attack mode so damage can be different,
	; but the reaction is same as for a flying kick.

	jauc	hit_flykick

#*****************************************************************************
;AMODE_SHNSPDKIK	36	(shawn speedkick)
 SUBR	hit_shnspdkik

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

	GETLIFE
	jrz	#isdead

	calla	create_damage_points

	WRSNDX	KICK_L1,KICK_L2

	move	*a13(PLYR_DIZZY),a0
	jrnz	#diz

	calla	check_dizzy
	jrz	#not_dizzy

	movi	5*TSEC,a0
	move	a0,*a13(GETUP_TIME)

#diz
	FACE24TBL #head_hit_dizzy
	calla	change_anim1a

#isdead
	calla	wres_collis_off

	rets

#not_dizzy

;MJT Start
;	calla	inc_burnout
;MJT End
	SETMODE	NORMAL

#do_hit
	FACE24TBL #head_hit
	calla	change_anim1a
	calla	wres_collis_off
	rets

#head_hit
	.long	hrt_2_head_hit_anim,hrt_4_head_hit_anim			;0 Bret Hart
	.long	rzr_2_head_hit_anim,rzr_4_head_hit_anim			;1 Razor Ramon
	.long	und_2_head_hit_anim,und_4_head_hit_anim			;2 Undertaker
	.long	yok_2_head_hit_anim,yok_4_head_hit_anim			;3 Yokozuna
	.long	shn_2_head_hit_anim,shn_4_head_hit_anim			;4 Shawn Michaels
	.long	bam_2_head_hit_anim,bam_4_head_hit_anim			;5 Bam Bam
	.long	dnk_2_head_hit_anim,dnk_4_head_hit_anim			;6 Doink
	.long	dnk_2_head_hit_anim,dnk_4_head_hit_anim			;7 spare
	.long	lex_2_head_hit_anim,lex_4_head_hit_anim			;8 Lex Luger
	.long	dnk_2_head_hit_anim,dnk_4_head_hit_anim			;9 Referee

#head_hit_dizzy
	.long	hrt_4_head_hit_dizzy_anim,hrt_4_head_hit_dizzy_anim	;0 Bret Hart
	.long	rzr_4_head_hit_dizzy_anim,rzr_4_head_hit_dizzy_anim		;1 Razor Ramon
	.long	und_head_hit_dizzy_anim,und_head_hit_dizzy_anim		;2 Undertaker
	.long	yok_4_head_hit_dizzy_anim,yok_4_head_hit_dizzy_anim		;3 Yokozuna
	.long	shn_4_head_hit_dizzy_anim,shn_4_head_hit_dizzy_anim	;4 Shawn Michaels
	.long	bam_head_hit_dizzy_anim,bam_head_hit_dizzy_anim		;5 Bam Bam
	.long	dnk_head_hit_dizzy_anim,dnk_head_hit_dizzy_anim		;6 Doink
	.long	dnk_head_hit_dizzy_anim,dnk_head_hit_dizzy_anim		;7 spare
	.long	lex_head_hit_dizzy_anim,lex_head_hit_dizzy_anim		;8 Lex Luger
	.long	dnk_head_hit_dizzy_anim,dnk_head_hit_dizzy_anim		;9 Referee

#*****************************************************************************
;AMODE_ATT37	37 (shawn speed kick, third hit)
 SUBR	hit_shnspdkik2

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	calla	block_hit
	rets

#noblock

;Any hit mode which does a fall back sequence onto the ground
;will not check dizzy at the start.
;The check dizzy happens in the sequence.

;MJT Start
	WRSNDX	FLYKICK_L1,FLYKICK_L2
	GETLIFE
	jrz	#skip


;	calla	inc_burnout

	SETMODE	NORMAL
#skip
	clr	a0
	move	a0,*a10(OBJ_ZVEL),L	;Zero zvel after collis

	move	a0,*a13(ROLL_POS)
	calla	set_getup_time

	FACETBL	#fall_back
	calla	change_anim1a


	movi	[4,0],a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;offx - defx
	jrgt	#fall_right		;attacker on left
	neg	a2
#fall_right
	move	a2,*a13(OBJ_XVEL),L

#isdead
	calla	wres_collis_off
	rets

#fall_back
	.long	hrt_fall_back_anim		;0 Bret Hart
	.long	rzr_fall_back_anim		;1 Razor Ramon
	.long	und_fall_back_anim		;2 Undertaker
	.long	yok_fall_back_anim		;3 Yokozuna
	.long	shn_fall_back_anim		;4 Shawn Michaels
	.ref	bam_fall_back_anim
	.long	bam_fall_back_anim		;5 Bam Bam
	.long	dnk_fall_back_anim		;6 Doink
	.long	dnk_fall_back_anim		;7 spare
	.long	lex_fall_back_anim		;8 Lex Luger
	.long	dnk_fall_back_anim		;9 Referee


#*****************************************************************************
;AMODE_ATT38	38
 SUBR	hit_hitcheck
	rets


#*****************************************************************************
;AMODE_ARMBREAK	39
 SUBR	hit_armbreak

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrne	#rets

	SETMODE	PUPPET

	move	a10,*a13(ATTACH_PROC),L		;proc attached to
	move	a13,*a10(ATTACH_PROC),L

	movi	wres_slave_anim,a0
	calla	change_anim1a

	calla	wres_collis_off
	CALLA	CALL_NASTY_MOVE

#rets
	rets

******************************************************************************

	.end

