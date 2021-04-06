**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		8/8/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"react2.asm"
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

	.ref	change_anim1a
	.ref	wres_collis_off
;MJT Start
;	.ref	inc_burnout
;MJT End
	.ref	block_hit
	.ref	face_each_other
	.ref	set_getup_time
	.ref	fall_back_tbl
	.ref	triple_sound,CALL_AVERAGE_MOVE
	.REF	CALL_NASTY_MOVE

******************************************************************************
* EXTERNAL ANIM SEQUENCES


;BAM BAM
	.ref	bam_heldoh_anim
;	.ref	bam_ocrun_anim
	.ref	bam_hitonground_anim
	.ref	bam_4_losebal_anim

;DOINK
	.ref	dnk_hitonground_anim
	.ref	dnk_heldoh_anim
;	.ref	dnk_ocrun_anim
	.ref	dnk_fall_back_anim
	.ref	dnk_4_losebal_anim
	.ref	dnk_knockdwn_anim

;BRET
	.ref	hrt_4_losebal_anim,hrt_fall_back_anim
	.ref	hrt_hitonground_anim

;LEX
	.ref	lex_4_losebal_anim
	.ref	lex_heldoh_anim
	.ref	lex_hitonground_anim
;	.ref	lex_ocrun_anim

;RAZOR
	.ref	rzr_4_losebal_anim
;	.ref	rzr_ocrun_anim
	.ref	rzr_heldoh_anim
	.ref	rzr_fall_back_anim
	.ref	rzr_hitonground_anim

;SHAWN
	.ref	shn_4_losebal_anim
	.ref	shn_hitonground_anim
	.ref	shn_heldoh_anim
;	.ref	shn_ocrun_anim

;TAKER
	.ref	und_hitonground_anim
	.ref	und_heldoh_anim
;	.ref	und_ocrun_anim
	.ref	und_4_losebal_anim

;YOKO
	.ref	yok_4_losebal_anim
	.ref	yok_hitonground_anim


******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************

#*****************************************************************************
;AMODE_UPRCUT	5
 SUBR	hit_uprcut


	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	calla	block_hit
	rets

#noblock

	GETLIFE
	jrz	#skip

;Any hit mode which does a fall back sequence onto the ground
;will not check dizzy at the start.
;The check dizzy happens in the sequence.


	SETMODE	NORMAL

#skip
;	calla	inc_burnout

	WRSNDX	UPRCUT_L1,UPRCUT_L2

	FACETBL fall_back_tbl
	calla	change_anim1a

	clr	a0
	move	a0,*a13(ROLL_POS)
	calla	set_getup_time


	movi	[11,0],a0
	move	a0,*a13(OBJ_YVEL),L

	movi	[2,0],a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;offx - defx
	jrgt	#fall_right		;attacker on left
	movi	[-2,0],a2
#fall_right
	move	a2,*a13(OBJ_XVEL),L

#isdead
	calla	wres_collis_off
	rets

#*****************************************************************************
;AMODE_LBOWDROP	6

 SUBR	hit_lbowdrop

	;if we're standing, ignore this
	move	*a13(PLYRMODE),a0
	cmpi	MODE_NORMAL,a0
	jrz	#isdead
	cmpi	MODE_BLOCK,a0
	jrz	#isdead

	GETLIFE
	jrz	#isdead

	WRSNDX	LBOWDROP_L1,LBOWDROP_L2

;MJT Start
;	calla	inc_burnout
;MJT End

	calla	wres_collis_off

;	move	*a13(PLYRMODE),a0
;	cmpi	MODE_ONGROUND,a0

	FACETBL hitonground
	calla	change_anim1a
#isdead
	calla	wres_collis_off
	rets

hitonground
	.long	hrt_hitonground_anim		;0 Bret Hart
	.long	rzr_hitonground_anim		;1 Razor Ramon
	.long	und_hitonground_anim		;2 Undertaker
	.long	yok_hitonground_anim		;3 Yokozuna
	.long	shn_hitonground_anim		;4 Shawn Michaels
	.long	bam_hitonground_anim		;5 Bam Bam
	.long	dnk_hitonground_anim		;6 Doink
	.long	0				;7 spare
	.long	lex_hitonground_anim		;8 Lex Luger
	.long	0				;9 Referee


#*****************************************************************************
;AMODE_BLBOWDROP	25
 SUBR	hit_blbowdrop
	WRSNDX	LBOWDROP_L1,LBOWDROP_L2
;SOUNDS_DONE
	GETLIFE
	jrz	#isdead

;MJT Start
;	calla	inc_burnout
;MJT End

	calla	wres_collis_off

	move	*a13(PLYRMODE),a0
	cmpi	MODE_ONGROUND,a0
	jrz	#on_grnd
	cmpi	MODE_DEAD,a0
	jrz	#on_grnd
;Knock standing opponent onto ground

;	move	*a13(PLYR_DIZZY),a0
;	jrz	#nodiz
;
;	FACETBL #knockdwn_dizzy
;	calla	change_anim1a
;	calla	wres_collis_off
;	rets
;#nodiz
	calla	set_getup_time

	FACETBL #knockdwn
	calla	change_anim1a
	calla	wres_collis_off
	rets

#on_grnd
	FACETBL hitonground
	calla	change_anim1a
#isdead
	calla	wres_collis_off
	rets

#knockdwn
	.ref	hrt_knockdwn_anim
	.ref	rzr_knockdwn_anim
	.ref	und_knockdwn_anim
	.ref	yok_knockdwn_anim
	.ref	shn_knockdwn_anim
	.ref	bam_knockdwn_anim
	.ref	dnk_knockdwn_anim
	.ref	lex_knockdwn_anim

	.long	hrt_knockdwn_anim		;0 Bret Hart
	.long	rzr_knockdwn_anim		;1 Razor Ramon
	.long	und_knockdwn_anim		;2 Undertaker
	.long	yok_knockdwn_anim		;3 Yokozuna
	.long	shn_knockdwn_anim		;4 Shawn Michaels
	.long	bam_knockdwn_anim		;5 Bam Bam
	.long	dnk_knockdwn_anim		;6 Doink
	.long	0				;7 spare
	.long	lex_knockdwn_anim		;8 Lex Luger
	.long	0				;9 Referee

;#knockdwn_dizzy
;	.long	dnk_knockdwn_dizzy_anim		;0 Bret Hart
;	.long	dnk_knockdwn_dizzy_anim		;1 Razor Ramon
;	.long	dnk_knockdwn_dizzy_anim		;2 Undertaker
;	.long	dnk_knockdwn_dizzy_anim		;3 Yokozuna
;	.long	dnk_knockdwn_dizzy_anim		;4 Shawn Michaels
;	.long	dnk_knockdwn_dizzy_anim		;5 Bam Bam
;	.long	dnk_knockdwn_dizzy_anim		;6 Doink
;	.long	dnk_knockdwn_dizzy_anim		;7 spare
;	.long	dnk_knockdwn_dizzy_anim		;8 Lex Luger
;	.long	dnk_knockdwn_dizzy_anim		;9 Referee


#*****************************************************************************
;AMODE_GRABHOLD	7
 SUBR	hit_grabhold
 
	GETLIFE
	jrz	#isdead

	WRSNDX	GRABHOLD_L1,GRABHOLD_L2

	SETMODE	ATTACHED

	move	a10,*a13(ATTACH_PROC),L		;proc attached to
	move	a13,*a10(ATTACH_PROC),L

	FACETBL	#heldoh
	calla	change_anim1a

#isdead
	calla	wres_collis_off
	rets

#heldoh
	.long	dnk_heldoh_anim			;0 Bret Hart
	.long	rzr_heldoh_anim			;1 Razor Ramon
	.long	und_heldoh_anim			;2 Undertaker
	.long	dnk_heldoh_anim			;3 Yokozuna
	.long	shn_heldoh_anim			;4 Shawn Michaels
	.long	bam_heldoh_anim			;5 Bam Bam
	.long	dnk_heldoh_anim			;6 Doink
	.long	dnk_heldoh_anim			;7 spare
	.long	lex_heldoh_anim			;8 Lex Luger
	.long	dnk_heldoh_anim			;9 Referee


;Blank amode here....
 SUBR	hit_grabfling
	rets
	.if	0

#*****************************************************************************
;AMODE_GRABFLING 8
 SUBR	hit_grabfling

	move	*a13(PLYRMODE),a0
	cmpi	MODE_RUNNING,a0
	jrnz	#cont
	move	*a13(GETUP_TIME),a0		;delay b4 gaining control
	jrnz	#out

#cont
	calla	face_each_other

	SETMODE	RUNNING

	move	*a13(PLYR_DIZZY),a0
	jrnz	#diz

	calla	set_getup_time
#diz

	move	*a13(FACING_DIR),a0	;use facing
	andi	PLAYER_LEFT_VAL|PLAYER_RIGHT_VAL,a0
	move	a0,*a13(MOVE_DIR)

	move	a10,*a13(ATTACH_PROC),L		;proc attached to
	move	a13,*a10(ATTACH_PROC),L

	FACETBL	#ocrun
	calla	change_anim1a

	calla	wres_collis_off
#out	rets

#ocrun
	.long	dnk_ocrun_anim			;0 Bret Hart
	.long	rzr_ocrun_anim			;1 Razor Ramon
	.long	und_ocrun_anim			;2 Undertaker
	.long	dnk_ocrun_anim			;3 Yokozuna
	.long	shn_ocrun_anim			;4 Shawn Michaels
	.long	bam_ocrun_anim			;5 Bam Bam
	.long	dnk_ocrun_anim			;6 Doink
	.long	dnk_ocrun_anim			;7 spare
	.long	lex_ocrun_anim			;8 Lex Luger
	.long	dnk_ocrun_anim			;9 Referee

 .if 0
	THIS WAS IN SHAWN.ASM & TAKER.ASM

	move	*a13(FACING_DIR),a0	;use facing
	andi	PLAYER_LEFT_VAL|PLAYER_RIGHT_VAL,a0
	move	a0,*a13(MOVE_DIR)

	move	*a10(OBJ_XPOSINT),a0
	movi	96,a1
	move	*a10(FACING_DIR),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#pos
	neg	a1
#pos
	add	a1,a0
	move	a0,*a13(OBJ_XPOSINT)

 	move	*a10(OBJ_ZPOS),a0,L
	addi	10000h,a0
 	move	a0,*a13(OBJ_ZPOS),L		;in front of attacker
	subi	20000h,a0
 	move	a0,*a10(OBJ_ZPOS),L
 .endif

	 .endif

#*****************************************************************************
;AMODE_PUSH	9
 SUBR	hit_push

;	move	*a13(PLYRMODE),a1
;	cmpi	MODE_BLOCK,a1
;	jrnz	#noblock
;
;	calla	block_hit
;	rets
;
;#noblock

	WRSNDX	LBOWDROP_L1,LBOWDROP_L2

;MJT Start
;	calla	inc_burnout
;MJT End

	SETMODE	NORMAL

	clr	a0
	move	a0,*a10(OBJ_XVEL),L	;clr attacker's x-vel

	FACETBL #losebal
	calla	change_anim1a

	movi	[6,0],a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;offx - defx
	jrgt	#fall_right		;attacker on left
	neg	a2
#fall_right
	move	a2,*a13(OBJ_XVEL),L

	calla	wres_collis_off
	rets

#losebal

	.long	hrt_4_losebal_anim	;0 Bret Hart
	.long	rzr_4_losebal_anim	;1 Razor Ramon
	.long	und_4_losebal_anim	;2 Undertaker
	.long	yok_4_losebal_anim	;3 Yokozuna
	.long	shn_4_losebal_anim	;4 Shawn Michaels
	.long	bam_4_losebal_anim	;5 Bam Bam
	.long	dnk_4_losebal_anim	;6 Doink
	.long	dnk_4_losebal_anim	;7 spare
	.long	lex_4_losebal_anim	;8 Lex Luger
	.long	dnk_4_losebal_anim	;9 Referee

******************************************************************************

	.end

