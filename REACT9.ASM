**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		8/8/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"react9.asm"
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

	.ref	fall_back_tbl,head_hit_dizzy_tbl,head_hit_tbl,head_hit2_tbl
	.ref	block_hit_flail,triple_sound,hit_damage_pending
	.ref	change_anim1a,wres_collis_off,block_hit
	.ref	CALL_FACE_HIT,hitonground_tbl
	.ref	knee_hit_tbl,burn_tbl

******************************************************************************
* EXTERNAL ANIM SEQUENCES

;BAM BAM
;DOINK
;BRET
;LEX
;RAZOR
;SHAWN
;TAKER
;YOKO


******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE


#*****************************************************************************
;AMODE_RSLASH	40
 SUBR	hit_rslash

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

;	move	*a13(FACING_DIR),a0		;check for hit
;	move	*a13(NEW_FACING_DIR),a1		;from behind
;	and	a0,a1
;	andi	MOVE_LEFT|MOVE_RIGHT,a1
;	jrz	#noblock

	calla	block_hit_flail
	rets

#noblock

;All of the damage amounts need to be in lookup tables linked to the wrestler
;who actually struck the blow.

	CALLA	CALL_FACE_HIT

	GETLIFE
	jrz	#isdead

;	calla	create_damage_points

	WRSNDX	RSLASH_L1,RSLASH_L2

;	move	*a13(PLYR_DIZZY),a0
;	jrnz	#diz
;
;	calla	check_dizzy
;	jrz	#not_dizzy
;
;	movi	5*TSEC,a0
;	move	a0,*a13(GETUP_TIME)
;
;#diz
;	FACE24TBL head_hit_dizzy_tbl
;	calla	change_anim1a
;
;
;#not_dizzy
;
;	calla	inc_burnout

	SETMODE	NORMAL

#do_hit
	move	*a13(OBJ_YPOSINT),a14
	move	*a13(GROUND_Y),a0
	sub	a0,a14
	cmpi	20,a14
	jrge	#fall_back

	;normal punch
	FACE24TBL head_hit2_tbl
	calla	change_anim1a
#isdead
	calla	wres_collis_off
	rets

#fall_back
	FACETBL fall_back_tbl

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

	rets

#*****************************************************************************
;AMODE_HEADDSLASH	41

 SUBR	hit_headdslash

	WRSNDX	RSLASH_L1,RSLASH_L2

	GETLIFE
	jrz	#isdead


	FACE24TBL knee_hit_tbl
	calla	change_anim1a

	movi	2C000h,a0
	move	a0,*a13(OBJ_YVEL),L
	clr	a0
	move	a0,*a13(OBJ_XVEL),L

	;move a little bit toward the attacker
	movk	5,a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1
	jrle	#ok
   	neg	a2
#ok
	add	a2,a1
	move	a1,*a13(OBJ_XPOSINT)

	calla	wres_collis_off
	rets

#isdead

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

	calla	wres_collis_off
	rets

#*****************************************************************************
;AMODE_HEADUSLASH	42

 SUBR	hit_headuslash

	WRSNDX	RSLASH_L1,RSLASH_L2

	GETLIFE
	jrz	#isdead

	FACE24TBL knee_hit_tbl
	calla	change_anim1a

	movi	40000h,a0
	move	a0,*a13(OBJ_YVEL),L
	clr	a0
	move	a0,*a13(OBJ_XVEL),L

	calla	wres_collis_off
	rets

#isdead

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

	calla	wres_collis_off
	rets

#*****************************************************************************
;AMODE_NAPALM	55

 SUBR	hit_napalm

	;if we're standing, ignore this
	move	*a13(PLYRMODE),a0
	cmpi	MODE_NORMAL,a0

	jreq	#mode_normal

	cmpi	MODE_BLOCK,a0
	jreq	#mode_normal

	calla	wres_collis_off

	move	*a13(PLYRMODE),a0
	cmpi	MODE_ONGROUND,a0
	jrz	#on_grnd
	cmpi	MODE_DEAD,a0
	jrnz	#isdead

#on_grnd
	FACETBL burn_tbl
	calla	change_anim1a

	;set the DEAD_ANIM bit - if this hit kills us, we don't want to
	; go through a normal convulse.
	move	*a13(STATUS_FLAGS),a14,L
	ori	M_DEAD_ANIM,a14
	move	a14,*a13(STATUS_FLAGS),L

	WRSNDX	LBOWDROP_L1,LBOWDROP_L2
	movi	43h,a0
	calla	triple_sound

#isdead	calla	wres_collis_off
	rets

#mode_normal
	;OOPS!  Don't do any damage.
	clr	a14
	move	a14,@hit_damage_pending
	jruc	#isdead


******************************************************************************

	.end
