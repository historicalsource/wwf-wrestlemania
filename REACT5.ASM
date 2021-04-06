**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		8/8/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"react5.asm"
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
	.include	"damage.equ"


******************************************************************************
* EXTERNAL REFERENCES

	.ref	change_anim1a
	.ref	wres_collis_off
;	.ref	inc_burnout
	.ref	block_hit_flail
	.ref	block_hit
;	.ref	create_damage_points
	.ref	slide_offscr
;	.ref	check_dizzy
	.ref	wres_slave_anim
	.ref	triple_sound,CALL_AVERAGE_MOVE
	.ref	CALL_NASTY_MOVE,PCNT


******************************************************************************
* EXTERNAL ANIM SEQUENCES


;BAM BAM
	.ref	bam_2_head_hit2_anim
	.ref	bam_4_head_hit2_anim
	.ref	bam_4_losebal_anim
	.ref	bam_fall_back_anim
	.ref	bam_get_buzz_anim

;DOINK
	.ref	dnk_2_bncoff_anim
	.ref	dnk_4_bncoff_dizzy_anim
	.ref	dnk_4_bncoff_anim
	.ref	dnk_4_losebal_anim
	.ref	dnk_4_losebal_dizzy_anim
	.ref	dnk_get_buzz_anim
	.ref	dnk_head_hit2_anim
	.ref	dnk_head_hit_dizzy_anim
	.ref	dnk_2_head_hit2_anim,dnk_4_head_hit2_anim
	.ref	dnk_fall_back_anim

;BRET
	.ref	hrt_fall_back_anim,hrt_4_losebal_dizzy_anim
	.ref	hrt_2_head_hit2_anim,hrt_4_head_hit2_anim
	.ref	hrt_4_head_hit_dizzy_anim
	.ref	hrt_get_buzz_anim,hrt_4_losebal_anim

;LEX
	.ref	lex_2_head_hit2_anim,lex_4_head_hit2_anim
	.ref	lex_head_hit_dizzy_anim
	.ref	lex_4_losebal_anim
	.ref	lex_fall_back_anim
	.ref	lex_get_buzz_anim

;RAZOR
	.ref	rzr_2_head_hit2_anim,rzr_4_head_hit2_anim
	.ref	rzr_4_losebal_anim
	.ref	rzr_fall_back_anim
	.ref	rzr_get_buzz_anim

;SHAWN
	.ref	shn_4_head_hit_dizzy_anim
	.ref	shn_2_head_hit3_anim,shn_4_head_hit3_anim
	.ref	shn_fall_back_anim
	.ref	shn_4_losebal_anim
	.ref	shn_get_buzz_anim

;TAKER
	.ref	und_fall_back_anim
	.ref	und_get_buzz_anim
	.ref	und_2_head_hit2_anim,und_4_head_hit2_anim
	.ref	und_head_hit_dizzy_anim
	.ref	und_4_losebal_dizzy_anim
	.ref	und_4_losebal_anim
	.ref	und_4_bncoff_dizzy_anim
	.ref	und_2_bncoff_anim,und_4_bncoff_anim

;YOKO
	.ref	yok_fall_back_anim
	.ref	yok_get_buzz_anim
	.ref	yok_4_losebal_anim


******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************

#*****************************************************************************
;AMODE_RUN	20

;Return carry set if the run hit is good and will count, clear if it's going
; to be discarded anyway.

 SUBR	good_run_hit

;Ignore most running collisions
	move	*a13(OBJ_ZPOS),a0,L
	move	*a10(OBJ_ZPOS),a1,L
	sub	a0,a1
	abs	a1
	srl	16,a1
;FIXX!!  Unless it is Yoko!
	move	*a10(WRESTLERNUM),a0
	cmpi	3,a0
	jrnz	#notyok
;Yoko


;This fixes YOKO gut hitting you after he is flung
	move	*a10(GETUP_TIME),a0		;delay b4 gaining control
	jrnz	#bad




	cmpi	5,a1		;if yoko	;15
	jrlt	#good
#notyok	
	cmpi	2,a1		;6
	jrgt	#bad

#good	setc
	rets
#bad	clrc
	rets

 SUBR	hit_run

;Tell running wrestler to stop running, and push other guy out of the way.
	callr	good_run_hit
	jrnc	#skip

	move	*a13(PLYRMODE),a1

	cmpi	MODE_INAIR,a1
	jrz	#isdead
	cmpi	MODE_INAIR2,a1
	jrz	#isdead

	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

;	move	*a13(FACING_DIR),a0		;check for hit
;	move	*a13(NEW_FACING_DIR),a1		;from behind
;	and	a0,a1
;	andi	MOVE_LEFT|MOVE_RIGHT,a1
;	jrz	#noblock

	calla	block_hit_flail

	movi	[3,0],a0
	move	a0,*a13(OBJ_YVEL),L

	jruc	#gotblk

#noblock
;If player is on ground, ignore running collisions!
	move	*a13(PLYRMODE),a0
	cmpi	MODE_ONGROUND,a0
	jrz	#isdead

	GETLIFE
	jrz	#isdead

	WRSNDX	LBOWDROP_L1,LBOWDROP_L2

	SETMODE	NORMAL

	FACETBL	#losebal

	move	*a10(WRESTLERNUM),a1
	cmpi	3,a1
	jrnz	#notyok2
;Yoko ran into me!
	.ref	fall_back_tbl
	FACETBL fall_back_tbl
	calla	change_anim1a


	.ref	hit_damage_pending
	movi	-D_GUTPUSH,a0
	move	a0,@hit_damage_pending


	movi	[3,0],a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;offx - defx
	jrgt	#fall_right		;attacker on left
	movi	[-3,0],a2
#fall_right
	move	a2,*a13(OBJ_XVEL),L

	jruc	#gotblk

;	move	*a13(PLYR_DIZZY),a1
;	jrz	#notdiz
;;Guy is dizzy, need to stay in dizzy after losing balance
;	FACETBL	#losebal_dizzy
;
;#notdiz

#notyok2
	calla	change_anim1a

#gotblk
	calla	wres_collis_off

;This is what happens to running wrestler.

	movi	[3,0],a0
	move	a0,*a10(OBJ_YVEL),L

	movi	MODE_NORMAL,a0
	move	a0,*a10(PLYRMODE)

	move	*a10(PLYR_DIZZY),a0
	jrz	#notdiz0

;Running guy is in dizzy mode, bounce off and stay dizzy!
	clr	a0
	move	a0,*a10(RUN_TIME)
	SWAP	a10,a13

	FACETBL	#bncoff_dizzy
	jruc	#cnt

#notdiz0
	move	*a10(GETUP_TIME),a0
	jrz	#skipm


;Cause getup meter to slide off screen.
	move	*a10(METER_PROC),a0,L
	jrz	#skipm			;skip if we don't have a getup meter
	PUSH	a8,a9,a10
	move	*a0(PA8),a8,L
	move	*a0(PA9),a9,L
	move	*a0(PA10),a10,L
	movi	GETUP_PID,a1
	movi	slide_offscr,a7
	calla	XFERPROC
	PULL	a8,a9,a10

#skipm	clr	a0
	move	a0,*a10(RUN_TIME)
	move	a0,*a13(RUN_TIME)
	move	a0,*a10(GETUP_TIME)


	SWAP	a10,a13

	FACE24TBL bncoff
#cnt
	calla	change_anim1a
	SWAP	a10,a13

	movi	[3,0],a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;offx - defx
	jrlt	#right
	neg	a2
#right
	move	a2,*a10(OBJ_XVEL),L

#isdead
	calla	wres_collis_off
	rets
#skip	move	*a13(MOVE_DIR),a14
	.ref	new_victim_movedir
	move	a14,@new_victim_movedir
	calla	wres_collis_off
	rets

#losebal
	.long	hrt_4_losebal_anim		;0 Bret Hart
	.long	rzr_4_losebal_anim		;1 Razor Ramon
	.long	und_4_losebal_anim		;2 Undertaker
	.long	yok_4_losebal_anim		;3 Yokozuna
	.long	shn_4_losebal_anim		;4 Shawn Michaels
	.long	bam_4_losebal_anim		;5 Bam Bam
	.long	dnk_4_losebal_anim		;6 Doink
	.long	dnk_4_losebal_anim		;7 spare
	.long	lex_4_losebal_anim		;8 Lex Luger
	.long	dnk_4_losebal_anim		;9 Referee

;Fix!!!
;#losebal_dizzy
;	.long	hrt_4_losebal_dizzy_anim	;0 Bret Hart
;	.long	dnk_4_losebal_dizzy_anim	;1 Razor Ramon
;	.long	und_4_losebal_dizzy_anim	;2 Undertaker
;	.long	dnk_4_losebal_dizzy_anim	;3 Yokozuna
;	.long	dnk_4_losebal_dizzy_anim	;4 Shawn Michaels
;	.long	dnk_4_losebal_dizzy_anim	;5 Bam Bam
;	.long	dnk_4_losebal_dizzy_anim	;6 Doink
;	.long	dnk_4_losebal_dizzy_anim	;7 spare
;	.long	dnk_4_losebal_dizzy_anim	;8 Lex Luger
;	.long	dnk_4_losebal_dizzy_anim	;9 Referee
 SUBR    bncoff
	.ref	rzr_2_bncoff_anim,rzr_4_bncoff_anim
	.ref	hrt_2_bncoff_anim,hrt_4_bncoff_anim
	.ref	bam_2_bncoff_anim,bam_4_bncoff_anim
	.ref	yok_2_bncoff_anim,yok_4_bncoff_anim
	.ref	shn_2_bncoff_anim,shn_4_bncoff_anim
	.ref	lex_2_bncoff_anim,lex_4_bncoff_anim
	.ref	und_2_bncoff_anim,und_4_bncoff_anim

	.long	hrt_2_bncoff_anim,hrt_4_bncoff_anim	;0 Bret Hart
	.long	rzr_2_bncoff_anim,rzr_4_bncoff_anim	;1 Razor Ramon
	.long	und_2_bncoff_anim,und_4_bncoff_anim	;2 Undertaker
	.long	yok_2_bncoff_anim,yok_4_bncoff_anim	;3 Yokozuna
	.long	shn_2_bncoff_anim,shn_4_bncoff_anim	;4 Shawn Michaels
	.long	bam_2_bncoff_anim,bam_4_bncoff_anim	;5 Bam Bam
	.long	dnk_2_bncoff_anim,dnk_4_bncoff_anim	;6 Doink
	.long	dnk_2_bncoff_anim,dnk_4_bncoff_anim	;7 spare
	.long	lex_2_bncoff_anim,lex_4_bncoff_anim	;8 Lex Luger
	.long	dnk_2_bncoff_anim,dnk_4_bncoff_anim	;9 Referee

 SUBR    bncoff_gate

	.ref	yok_2_bncoff_gate_anim,yok_4_bncoff_gate_anim

	.long	hrt_2_bncoff_anim,hrt_4_bncoff_anim	;0 Bret Hart
	.long	rzr_2_bncoff_anim,rzr_4_bncoff_anim	;1 Razor Ramon
	.long	und_2_bncoff_anim,und_4_bncoff_anim	;2 Undertaker
	.long	yok_2_bncoff_gate_anim,yok_4_bncoff_gate_anim	;3 Yokozuna
	.long	shn_2_bncoff_anim,shn_4_bncoff_anim	;4 Shawn Michaels
	.long	bam_2_bncoff_anim,bam_4_bncoff_anim	;5 Bam Bam
	.long	dnk_2_bncoff_anim,dnk_4_bncoff_anim	;6 Doink
	.long	dnk_2_bncoff_anim,dnk_4_bncoff_anim	;7 spare
	.long	lex_2_bncoff_anim,lex_4_bncoff_anim	;8 Lex Luger
	.long	dnk_2_bncoff_anim,dnk_4_bncoff_anim	;9 Referee


#bncoff_dizzy
	.ref	rzr_4_bncoff_dizzy_anim
	.ref	hrt_4_bncoff_dizzy_anim
	.ref	bam_4_bncoff_dizzy_anim
	.ref	yok_4_bncoff_dizzy_anim
	.ref	shn_4_bncoff_dizzy_anim
	.ref	und_4_bncoff_dizzy_anim
	.ref	lex_4_bncoff_dizzy_anim

	.long	hrt_4_bncoff_dizzy_anim		;0 Bret Hart
	.long	rzr_4_bncoff_dizzy_anim		;1 Razor Ramon
	.long	und_4_bncoff_dizzy_anim		;2 Undertaker
	.long	yok_4_bncoff_dizzy_anim		;3 Yokozuna
	.long	shn_4_bncoff_dizzy_anim		;4 Shawn Michaels
	.long	bam_4_bncoff_dizzy_anim		;5 Bam Bam
	.long	dnk_4_bncoff_dizzy_anim		;6 Doink
	.long	dnk_4_bncoff_dizzy_anim		;7 spare
	.long	lex_4_bncoff_dizzy_anim		;8 Lex Luger
	.long	dnk_4_bncoff_dizzy_anim		;9 Referee


#*****************************************************************************
;AMODE_PUPPET	21
 SUBR	hit_puppet

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	calla	block_hit
	rets

#noblock
	;no need for this check now.  AMODE_PUPPET vs. dead guy won't even
	; register a collision now.
;	;don't grab dead guys
;	move	*a13(PLYRMODE),a14
;	cmpi	MODE_DEAD,a14
;	jreq	#done

 SUBR	hit_puppet_even_if_dead
	SETMODE	PUPPET

	move	a10,*a13(ATTACH_PROC),L		;proc attached to
	move	a13,*a10(ATTACH_PROC),L

	movi	wres_slave_anim,a0
	calla	change_anim1a

	clr	a0
	move	a0,*a13(GETUP_TIME)

#done	calla	wres_collis_off
	rets

#*****************************************************************************
;AMODE_PUPPET	53
 SUBR	hit_puppet_noflail
;Used for puppet moves that will not flail opponent
;just cause them to do regular hit block

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	calla	block_hit
	rets

#noblock
	;don't grab dead guys
	move	*a13(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#done

	SETMODE	PUPPET

	move	a10,*a13(ATTACH_PROC),L		;proc attached to
	move	a13,*a10(ATTACH_PROC),L

	movi	wres_slave_anim,a0
	calla	change_anim1a

	clr	a0
	move	a0,*a13(GETUP_TIME)

#done	calla	wres_collis_off
	rets

#*****************************************************************************
;AMODE_PUPPET2	31
 SUBR	hit_puppet2

;A puppet mode for ignoring puppet move if getup time is zero
;Used for hair pickup against a rolling/getting up opponent!

	move	*a13(GETUP_TIME),a0
	jrz	#out

	;don't grab dead guys
	move	*a13(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#done

	SETMODE	PUPPET

	move	a10,*a13(ATTACH_PROC),L		;proc attached to
	move	a13,*a10(ATTACH_PROC),L

	movi	wres_slave_anim,a0
	calla	change_anim1a

	clr	a0
	move	a0,*a13(GETUP_TIME)

	calla	wres_collis_off
	rets
#out
	move	*a10(ANIMODE),a1
	andni	MODE_STATUS,a1
	move	a1,*a10(ANIMODE)

#done	calla	wres_collis_off
	rets


#*****************************************************************************
;AMODE_PUPPET	32
 SUBR	hit_puppet_hdgrab

;This is a special attack mode which ignores blocking opponents!
;UNLESS they've got a safe time set.
	move	*a13(SAFE_TIME),a0
	jrz	#noblock

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrne	#noblock

	calla	block_hit_flail
	rets

#noblock
	;don't grab dead guys
	move	*a13(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#done

	clr	a14
	move	a14,*a10(HITBLOCKER)

	move	@PCNT,a14
	move	a14,*a13(HEAD_GRAB_TIME)

	SETMODE	PUPPET

	move	a10,*a13(ATTACH_PROC),L		;proc attached to
	move	a13,*a10(ATTACH_PROC),L

	movi	wres_slave_anim,a0
	calla	change_anim1a

	clr	a0
	move	a0,*a13(GETUP_TIME)

#done	calla	wres_collis_off
	rets


#*****************************************************************************
;AMODE_PUPPET	54
 SUBR	hit_puppet_toss

;This is a special attack mode which ignores blocking opponents!
	move	*a13(SAFE_TIME),a0
	jrz	#noblock

;If safe time is set, just holding block will suffice
	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock2

	calla	block_hit
	rets

#noblock
	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock2

;If stick is down & away - skip toss
	move	*a13(STICK_VAL_CUR),a14
	andi	0ch,a14
	jrz	#noblock2
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a14,a1
	jrz	#noblock2

	move	*a13(STICK_VAL_CUR),a14
	btst	1,a14
	jrz	#noblock2
;Pulling down & away!
;Don't allow hiptoss

	calla	block_hit
	rets


#noblock2

;;don't grab dead guys
;	move	*a13(PLYRMODE),a14
;	cmpi	MODE_DEAD,a14
;	jreq	#done

	clr	a14
	move	a14,*a10(HITBLOCKER)

;	move	@PCNT,a14
;	move	a14,*a13(HEAD_GRAB_TIME)

	SETMODE	PUPPET

	move	a10,*a13(ATTACH_PROC),L		;proc attached to
	move	a13,*a10(ATTACH_PROC),L

	movi	wres_slave_anim,a0
	calla	change_anim1a

	clr	a0
	move	a0,*a13(GETUP_TIME)

#done	calla	wres_collis_off
	rets

#*****************************************************************************
;AMODE_BACKHAND	22 - SLAP
 SUBR	hit_backhand

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	calla	block_hit_flail
	rets

#noblock

	;if it's shawn, do 33h instead of 43h
	movi	33h,a0
	move	*a10(WRESTLERNUM),a14
	subk	W_SHAWN,a14
	jrz	#snd_ok
	movi	43h,a0
#snd_ok	calla	triple_sound

	calla	CALL_AVERAGE_MOVE

	GETLIFE
	jrz	#isdead

	WRSNDX	UPRCUT_L2

;	WRSNDX	HDBUTT_L1,HDBUTT_L2

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
;	FACE24TBL #head_hit_dizzy
;	calla	change_anim1a
;
;
;#not_dizzy

	SETMODE	NORMAL
	move	*a13(OBJ_YPOSINT),a14
	move	*a13(GROUND_Y),a0
	sub	a0,a14
	cmpi	20,a14
	jrge	#fall_back


	FACE24TBL #head_hit2
	calla	change_anim1a
	calla	wres_collis_off

	rets

#isdead
	calla	wres_collis_off
	rets

#fall_back
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

	rets

#head_hit2
;No z float..
	.ref	lex_2_head_hit3_anim,lex_4_head_hit3_anim
	.ref	rzr_2_head_hit3_anim,rzr_4_head_hit3_anim
	.ref	yok_2_head_hit3_anim,yok_4_head_hit3_anim
	.ref	hrt_2_head_hit3_anim,hrt_4_head_hit3_anim

	.long	hrt_2_head_hit3_anim,hrt_4_head_hit3_anim		;0 Bret Hart
	.long	rzr_2_head_hit3_anim,rzr_4_head_hit3_anim		;1 Razor Ramon
	.long	und_2_head_hit2_anim,und_4_head_hit2_anim		;2 Undertaker
	.long	yok_2_head_hit3_anim,yok_4_head_hit3_anim		;3 Yokozuna
	.long	shn_2_head_hit3_anim,shn_4_head_hit3_anim		;4 Shawn Michaels
	.long	bam_2_head_hit2_anim,bam_4_head_hit2_anim		;5 Bam Bam
	.long	dnk_2_head_hit2_anim,dnk_4_head_hit2_anim		;6 Doink
	.long	0,0							;7 spare
	.long	lex_2_head_hit3_anim,lex_4_head_hit3_anim		;8 Lex Luger
	.long	0,0							;9 Referee

;#head_hit_dizzy
;	.ref	bam_head_hit_dizzy_anim,rzr_4_head_hit_dizzy_anim
;	.ref	und_head_hit_dizzy_anim,yok_4_head_hit_dizzy_anim
;
;	.long	hrt_4_head_hit_dizzy_anim,hrt_4_head_hit_dizzy_anim	;0 Bret Hart
;	.long	rzr_4_head_hit_dizzy_anim,rzr_4_head_hit_dizzy_anim	;1 Razor Ramon
;	.long	und_head_hit_dizzy_anim,und_head_hit_dizzy_anim		;2 Undertaker
;	.long	yok_4_head_hit_dizzy_anim,yok_4_head_hit_dizzy_anim	;3 Yokozuna
;	.long	shn_4_head_hit_dizzy_anim,shn_4_head_hit_dizzy_anim	;4 Shawn Michaels
;	.long	bam_head_hit_dizzy_anim,bam_head_hit_dizzy_anim		;5 Bam Bam
;	.long	dnk_head_hit_dizzy_anim,dnk_head_hit_dizzy_anim		;6 Doink
;	.long	0,0							;7 spare
;	.long	lex_head_hit_dizzy_anim,lex_head_hit_dizzy_anim		;8 Lex Luger
;	.long	0,0							;9 Referee
;

#*****************************************************************************
;AMODE_EARSLAP	28 - SLAP
 SUBR	hit_earslap

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	calla	block_hit
	rets

#noblock

	movi	43h,a0
	calla	triple_sound

	GETLIFE
	jrz	#isdead

	WRSNDX	HDBUTT_L2

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
;	FACETBL #head_hit_dizzy
;	calla	change_anim1a
;
;#isdead
;	calla	wres_collis_off
;	rets
;#not_dizzy

	SETMODE	NORMAL

	FACETBL #head_hit2
	calla	change_anim1a

#isdead
	calla	wres_collis_off
	rets

#head_hit2
;No z float..
	.ref	lex_4_head_hit4_anim
	.ref	rzr_4_head_hit4_anim
	.ref	yok_4_head_hit4_anim
	.ref	hrt_4_head_hit4_anim
	.ref	und_4_head_hit4_anim
	.ref	bam_4_head_hit4_anim
	.ref	dnk_4_head_hit4_anim
	.ref	shn_4_head_hit4_anim

	.long	hrt_4_head_hit4_anim		;0 Bret Hart
	.long	rzr_4_head_hit4_anim		;1 Razor Ramon
	.long	und_4_head_hit4_anim		;2 Undertaker
	.long	yok_4_head_hit4_anim		;3 Yokozuna
	.long	shn_4_head_hit4_anim		;4 Shawn Michaels
	.long	bam_4_head_hit4_anim		;5 Bam Bam
	.long	dnk_4_head_hit4_anim		;6 Doink
	.long	0							;7 spare
	.long	lex_4_head_hit4_anim		;8 Lex Luger
	.long	0							;9 Referee

;#head_hit_dizzy
;
;	.long	hrt_4_head_hit_dizzy_anim
;	.long	rzr_4_head_hit_dizzy_anim
;	.long	und_head_hit_dizzy_anim
;	.long	yok_4_head_hit_dizzy_anim
;	.long	shn_4_head_hit_dizzy_anim
;	.long	bam_head_hit_dizzy_anim
;	.long	dnk_head_hit_dizzy_anim
;	.long	0							;7 spare
;	.long	lex_head_hit_dizzy_anim
;	.long	0							;9 Referee


#*****************************************************************************
;AMODE_BUZZ	23
 SUBR	hit_buzz

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	calla	block_hit
	rets

#noblock

;All of the damage amounts need to be in lookup tables linked to the wrestler
;who actually struck the blow.
;	calla	CALL_NASTY_MOVE


	GETLIFE
;Bug!  We want to see the electrocution!
;FIX!!
	jrz	#isdead

	SETMODE	NORMAL

#isdead
	move	a10,*a13(ATTACH_PROC),L		;proc attached to
	move	a13,*a10(ATTACH_PROC),L

;	movi	wres_slave_anim,a0
;	calla	change_anim1a


;	calla	create_damage_points
;Buzz sound
	WRSNDX	PUNCH_L1,PUNCH_L2

	FACETBL	#get_buzz
	calla	change_anim1a
	calla	wres_collis_off

	rets

#get_buzz
	.long	hrt_get_buzz_anim		;0 Bret Hart
	.long	rzr_get_buzz_anim		;1 Razor Ramon
	.long	und_get_buzz_anim		;2 Undertaker
	.long	yok_get_buzz_anim		;3 Yokozuna
	.long	shn_get_buzz_anim		;4 Shawn Michaels
	.long	bam_get_buzz_anim		;5 Bam Bam
	.long	dnk_get_buzz_anim		;6 Doink
	.long	0				;7 spare
	.long	lex_get_buzz_anim		;8 Lex Luger
	.long	0				;9 Referee

#*****************************************************************************
;AMODE_HAYMAKER	24
 SUBR	hit_haymaker

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	calla	block_hit_flail
	rets

#noblock


;	movi	40,a0
;	calla	inc_getup_time

;Any hit mode which does a fall back sequence onto the ground
;will not check dizzy at the start.
;The check dizzy happens in the sequence.

	WRSNDX	FLYKICK_L1,FLYKICK_L2
	GETLIFE
	jrz	#skip

	SETMODE	NORMAL
#skip
	FACETBL	#fall_back
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

#fall_back
	.long	hrt_fall_back_anim		;0 Bret Hart
	.long	rzr_fall_back_anim		;1 Razor Ramon
	.long	und_fall_back_anim		;2 Undertaker
	.long	yok_fall_back_anim		;3 Yokozuna
	.long	shn_fall_back_anim		;4 Shawn Michaels
	.long	bam_fall_back_anim		;5 Bam Bam
	.long	dnk_fall_back_anim		;6 Doink
	.long	0				;7 spare
	.long	lex_fall_back_anim		;8 Lex Luger
	.long	0				;9 Referee


******************************************************************************

	.end
