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
;	.ref	inc_burnout
	.ref	block_hit
	.ref	face_each_other
	.ref	set_getup_time
	.ref	fall_back_tbl
	.ref	triple_sound,CALL_AVERAGE_MOVE
	.ref	CALL_NASTY_MOVE
	.ref	block_hit_flail

******************************************************************************
* EXTERNAL ANIM SEQUENCES


;BAM BAM
	.ref	bam_heldoh_anim
;	.ref	bam_ocrun_anim
	.ref	bam_4_losebal_anim

;DOINK
	.ref	dnk_heldoh_anim
;	.ref	dnk_ocrun_anim
	.ref	dnk_fall_back_anim
	.ref	dnk_4_losebal_anim
	.ref	dnk_knockdwn_anim

;BRET
	.ref	hrt_4_losebal_anim,hrt_fall_back_anim

;LEX
	.ref	lex_4_losebal_anim
	.ref	lex_heldoh_anim
;	.ref	lex_ocrun_anim

;RAZOR
	.ref	rzr_4_losebal_anim
;	.ref	rzr_ocrun_anim
	.ref	rzr_heldoh_anim
	.ref	rzr_fall_back_anim

;SHAWN
	.ref	shn_4_losebal_anim
	.ref	shn_heldoh_anim
;	.ref	shn_ocrun_anim

;TAKER
	.ref	und_heldoh_anim
;	.ref	und_ocrun_anim
	.ref	und_4_losebal_anim

;YOKO
	.ref	yok_4_losebal_anim

;MISC
	.ref	hit_damage_pending,hitonground_tbl
	.ref	ck_live_teammates


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

	calla	block_hit_flail
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
       
	.ref	flash_white
	calla	flash_white

	clr	a0
	move	a0,*a13(ROLL_POS)
	calla	set_getup_time


	;silly temp
	movi	[15,0],a0
	move	*a10(WRESTLERNUM),a14
	cmpi	3,a14
	jrz	#norm
	movi	[13,0],a0
	cmpi	2,a14
	jrnz	#norm
	
	move	a13,a0
	calla	ck_live_teammates
	movi	[11,0],a0
	jrc	#norm

	;no live teammates -- send them up into the air
;	.ref	reduce_bog
;	move	@reduce_bog,a14
;	jrnz	#norm

	movi	[18,0],a0
#norm
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
;AMODE_UPRCUT2	39
 SUBR	hit_combo_uprcut

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

	.ref	flash_white
	calla	flash_white

	clr	a0
	move	a0,*a13(ROLL_POS)
	calla	set_getup_time

	MOVI	MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP,A0
	MOVE	A0,*A13(ANIMODE)


	move	*a13(WHOHITME),A1,L
	movi	[7,0],a0
	MOVE	*A1(RPT_COUNT),A2
	DEC	A2
	JRZ	SET_YVEL
	movi	[3,0],a0
SET_YVEL
	move	a0,*a13(OBJ_YVEL),L

	movi	[1,8000H],a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;offx - defx
	jrgt	#fall_right		;attacker on left
	NEG	A2
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
	jrz	#ignore
	cmpi	MODE_BLOCK,a0
	jrz	#ignore

	WRSNDX	LBOWDROP_L1,LBOWDROP_L2
	movi	33h,a0
	calla	triple_sound

	calla	wres_collis_off

	FACETBL hitonground_tbl
	calla	change_anim1a
	calla	wres_collis_off
	rets

#ignore	clr	a14
	move	a14,@hit_damage_pending
	calla	wres_collis_off
	rets


#*****************************************************************************
;AMODE_BLBOWDROP	25
 SUBR	hit_blbowdrop

	.ref	DO_SCREAM
	calla	DO_SCREAM

	WRSNDX	FLYKICK_L1,FLYKICK_L2
	WRSNDX	LBOWDROP_L1,LBOWDROP_L2

;	movi	500,a0
;	.ref	RNDPER
;	calla	RNDPER
;	jrls	#isdead
;	calla	inc_burnout

	calla	wres_collis_off

	move	*a13(PLYRMODE),a0
	cmpi	MODE_ONGROUND,a0
	jrz	#on_grnd
	cmpi	MODE_DEAD,a0
	jrz	#on_grnd
;Knock standing opponent onto ground

	SETMODE	NORMAL
	move	*a13(OBJ_YPOSINT),a14
	move	*a13(GROUND_Y),a0
	sub	a0,a14
	cmpi	20,a14
	jrge	#fall_back

	calla	set_getup_time

	FACETBL #knockdwn
	calla	change_anim1a
	calla	wres_collis_off
	rets

#fall_back
	movi	43h,a0
	calla	triple_sound
	FACETBL	fall_back_tbl

	calla	change_anim1a
	calla	wres_collis_off

	movi	[3,0],a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;offx - defx
	jrgt	#fall_right		;attacker on left
	neg	a2
#fall_right
	move	a2,*a13(OBJ_XVEL),L

	movi	-30000h,a0
	move	a0,*a13(OBJ_YVEL),L
	rets

#on_grnd
	FACETBL hitonground_tbl
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


#*****************************************************************************
;AMODE_GRABHOLD	7
 SUBR	hit_grabhold
; 
;	GETLIFE
;	jrz	#isdead
;
;	WRSNDX	GRABHOLD_L1,GRABHOLD_L2
;
;	SETMODE	ATTACHED
;
;	move	a10,*a13(ATTACH_PROC),L		;proc attached to
;	move	a13,*a10(ATTACH_PROC),L
;
;	FACETBL	#heldoh
;	calla	change_anim1a
;
;#isdead
;	calla	wres_collis_off
;	rets
;
;#heldoh
;	.long	dnk_heldoh_anim			;0 Bret Hart
;	.long	rzr_heldoh_anim			;1 Razor Ramon
;	.long	und_heldoh_anim			;2 Undertaker
;	.long	dnk_heldoh_anim			;3 Yokozuna
;	.long	shn_heldoh_anim			;4 Shawn Michaels
;	.long	bam_heldoh_anim			;5 Bam Bam
;	.long	dnk_heldoh_anim			;6 Doink
;	.long	dnk_heldoh_anim			;7 spare
;	.long	lex_heldoh_anim			;8 Lex Luger
;	.long	dnk_heldoh_anim			;9 Referee
;

;Blank amode here....
 SUBR	hit_grabfling
	rets

#*****************************************************************************
;AMODE_GUTPUSH	47
 SUBR	hit_gutpush

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#hit_push2

	clr	a0
	move	a0,*a13(OBJ_XVEL),L

	calla	block_hit_flail
	rets

#hit_push2

	SETMODE	NORMAL

	clr	a0
	move	a0,*a10(OBJ_XVEL),L	;clr attacker's x-vel

	FACETBL #losebal
	calla	change_anim1a

	movi	[8,0],a2
	jruc	#tag

;AMODE_PUSH	9
 SUBR	hit_push

;Lessen power of a push
;	move	*a10(PLYRMODE),a0
;	cmpi	MODE_INAIR,a0
;	jrz	#norm


	SETMODE	NORMAL

	clr	a0
	move	a0,*a10(OBJ_XVEL),L	;clr attacker's x-vel

	FACETBL #losebal
	calla	change_anim1a

	movi	[8,0],a2

#tag
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;offx - defx
	jrgt	#fall_right		;attacker on left
	neg	a2
#fall_right
	move	a2,*a13(OBJ_XVEL),L

	WRSNDX	PUSH_L1,PUSH_L2

	move	*a13(PLYRNUM),a1
	.ref	get_health
	calla	get_health
	subk	1,a0
	jrnz	#norm
	clr	a0
	move	a0,@hit_damage_pending
#norm
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