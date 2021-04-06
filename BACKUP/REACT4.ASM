**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		8/8/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"react4.asm"
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
	.REF	CALL_NASTY_MOVE
	.ref	set_getup_time
	.ref	check_dizzy
	.ref	fall_back_tbl
	.ref	triple_sound
	.ref	ADD_IF_SILENT
	.REF	CALL_DROP_KICK,CALL_AVERAGE_MOVE

******************************************************************************
* EXTERNAL ANIM SEQUENCES


;BAM BAM
	.ref	bam_2_head_hit2_anim,bam_4_head_hit2_anim
	.ref	bam_hitonground_anim
	.ref	bam_3_butt_drop_anim

;DOINK
	.ref	dnk_2_head_hit2_anim,dnk_4_head_hit2_anim
	.ref	dnk_knockdwn_anim
;	.ref	dnk_knockdwn_dizzy_anim
	.ref	dnk_fall_back_anim
	.ref	dnk_head_hit_dizzy_anim
	.ref	dnk_hitonground_anim
	.ref	dnk_3_head_held_anim
	.ref	dnk_belly_anim

;BRET
	.ref	hrt_2_head_hit2_anim,hrt_4_head_hit2_anim
	.ref	hrt_hitonground_anim,hrt_fall_back_anim
	.ref	hrt_4_head_hit_dizzy_anim
	.ref	hrt_running_ground_punch_anim

;LEX
	.ref	lex_4_head_hit2_anim
	.ref	lex_fall_back_anim
	.ref	lex_head_hit_dizzy_anim
	.ref	lex_2_head_hit2_anim
	.ref	lex_hitonground_anim
	.ref	lex_flying_ground_punch_anim

;RAZOR
	.ref	rzr_2_head_hit2_anim,rzr_4_head_hit2_anim
	.ref	rzr_2_head_hit3_anim,rzr_4_head_hit3_anim

	.ref	rzr_fall_back_anim
	.ref	rzr_hitonground_anim

;SHAWN
	.ref	shn_2_head_hit3_anim,shn_4_head_hit3_anim
	.ref	shn_4_head_hit_dizzy_anim
	.ref	shn_hitonground_anim
	.ref	shn_fall_back_anim

;TAKER
	.ref	und_2_head_hit2_anim,und_4_head_hit2_anim
	.ref	und_fall_back_anim
	.ref	und_hitonground_anim		;2 Undertaker
	.ref	und_flying_butt_drop_anim

;YOKO
	.ref	yok_2_head_hit2_anim,yok_4_head_hit2_anim
	.ref	yok_2_head_hit3_anim,yok_4_head_hit3_anim
	.ref	yok_fall_back_anim
	.ref	yok_hitonground_anim


******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
;AMODE_STOMP	15
;AMODE_BUTTSTOMP 30
 SUBR	hit_stomp
 SUBR	hit_buttstomp

	;if we're standing, ignore this
	move	*a13(PLYRMODE),a0
	cmpi	MODE_NORMAL,a0
	jrz	#isdead
	cmpi	MODE_BLOCK,a0
	jrz	#isdead

	WRSNDX	LBOWDROP_L1,LBOWDROP_L2

;MJT Start
;	calla	inc_burnout
;MJT End

;;;	SETMODE	NORMAL

	calla	wres_collis_off

	move	*a13(PLYRMODE),a0
	cmpi	MODE_ONGROUND,a0
	jrz	#on_grnd
	cmpi	MODE_DEAD,a0
	jrnz	#isdead

#on_grnd
	FACETBL hitonground
	calla	change_anim1a

	move	*a10(ANIBASE),a0,L

	cmpi	dnk_belly_anim,a0
	jreq	#bounce

	cmpi	und_flying_butt_drop_anim,a0
	jreq	#bounce

	cmpi	lex_flying_ground_punch_anim,a0
	jreq	#bounce3

;	cmpi	hrt_running_ground_punch_anim,a0
;	jreq	#bounce2

	jruc	#isdead

#bounce2
	;REALLY NASTY HACK!  Watch out if you modify this in any way.
	callr	#bounce
	movi	-10000h,a0
	move	a0,*a10(OBJ_ZVEL),L
	rets

#bounce3
	;REALLY NASTY HACK!  Watch out if you modify this in any way.
	callr	#bounce
	movi	40000h,a0
	move	a0,*a10(OBJ_YVEL),L
	rets

#bounce
;Bounce doink up off from opponents chest before he hits the ground!
	movi	50000h,a0
	move	a0,*a10(OBJ_YVEL),L
	movi	10000h,a0
	move	a0,*a10(OBJ_ZVEL),L
	clr	a0
	move	a0,*a10(OBJ_XVEL),L

	.ref	shake_all_ropes
	calla	shake_all_ropes
	PUSH	a10
	movi	8,a10
	.ref	SHAKER2
	calla	SHAKER2
	PULL	a10

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
;AMODE_BSTOMP	26
 SUBR	hit_bstomp

	WRSNDX	LBOWDROP_L1,LBOWDROP_L2

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
;   	rets
;
;#nodiz
	calla	set_getup_time

	FACETBL knockdwn
	calla	change_anim1a
	calla	wres_collis_off
	rets

#on_grnd
	FACETBL hitonground
	calla	change_anim1a
#isdead
	calla	wres_collis_off
	rets

knockdwn
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
;AMODE_hammer	29
 SUBR	hit_hammer

	movi	45h,a0
	calla	triple_sound
	calla	CALL_NASTY_MOVE

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	calla	block_hit
	rets

#noblock

	WRSNDX	LBOWDROP_L1,LBOWDROP_L2

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
;   	rets
;
;#nodiz
	calla	set_getup_time

	FACETBL knockdwn
	calla	change_anim1a
	calla	wres_collis_off
	rets

#on_grnd
	FACETBL hitonground
	calla	change_anim1a
#isdead
	calla	wres_collis_off
	rets


#*****************************************************************************
;AMODE_SPINKICK	16
 SUBR	hit_spinkick


	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	calla	block_hit
	rets

#noblock
	movi	43h,a0
	calla	triple_sound
	calla	CALL_AVERAGE_MOVE

	GETLIFE
	jrz	#isdead

;	WRSNDX	KICK_L1,KICK_L2

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
	move	*a13(OBJ_YPOSINT),a14
	move	*a13(GROUND_Y),a0
	sub	a0,a14
	cmpi	20,a14
	jrge	#fall_back


	FACE24TBL #head_hit2
	calla	change_anim1a
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
	.ref	lex_2_head_hit3_anim,lex_4_head_hit3_anim
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

#head_hit_dizzy
	.ref	bam_head_hit_dizzy_anim,rzr_4_head_hit_dizzy_anim
	.ref	und_head_hit_dizzy_anim,yok_4_head_hit_dizzy_anim

	.long	hrt_4_head_hit_dizzy_anim,hrt_4_head_hit_dizzy_anim	;0 Bret Hart
	.long	rzr_4_head_hit_dizzy_anim,rzr_4_head_hit_dizzy_anim	;1 Razor Ramon
	.long	und_head_hit_dizzy_anim,und_head_hit_dizzy_anim		;2 Undertaker
	.long	yok_4_head_hit_dizzy_anim,yok_4_head_hit_dizzy_anim	;3 Yokozuna
	.long	shn_4_head_hit_dizzy_anim,shn_4_head_hit_dizzy_anim	;4 Shawn Michaels
	.long	bam_head_hit_dizzy_anim,bam_head_hit_dizzy_anim		;5 Bam Bam
	.long	dnk_head_hit_dizzy_anim,dnk_head_hit_dizzy_anim		;6 Doink
	.long	0,0							;7 spare
	.long	lex_head_hit_dizzy_anim,lex_head_hit_dizzy_anim		;8 Lex Luger
	.long	0,0							;9 Referee

#*****************************************************************************
;AMODE_CLINE	17
 SUBR	hit_cline


	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	calla	block_hit
	rets

#noblock

	calla	CALL_DROP_KICK

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
;MJT End
;	move	*a10(OBJ_XVEL),a0,L	;slow down doink's
;	sra	1,a0		   	;x_vel after collis
;	move	a0,*a10(OBJ_XVEL),L

	clr	a0
	move	a0,*a10(OBJ_ZVEL),L	;Zero zvel after collis

	move	a0,*a13(ROLL_POS)
	calla	set_getup_time

	FACETBL	#fall_back2
	calla	change_anim1a


	movi	[3,0],a2
	move	*a10(OBJ_XVEL),a0,L
	jrp	#fall_right
	neg	a2


;	move	*a10(OBJ_XPOSINT),a0
;	move	*a13(OBJ_XPOSINT),a1
;	cmp	a0,a1			;offx - defx
;	jrgt	#fall_right		;attacker on left
;	neg	a2
#fall_right


	move	a2,*a13(OBJ_XVEL),L

#isdead
	calla	wres_collis_off
	rets

#fall_back2
 
	.ref	rzr_fall_back2_anim		;1 Razor Ramon
	.ref	und_fall_back2_anim		;2 Undertaker
	.ref	yok_fall_back2_anim		;3 Yokozuna
	.ref	shn_fall_back2_anim		;4 Shawn Michaels
	.ref	bam_fall_back_anim
	.ref	bam_fall_back2_anim
	.ref	dnk_fall_back2_anim		;6 Doink
	.ref	lex_fall_back2_anim		;8 Lex Luger
	.ref	hrt_fall_back2_anim		;8 Lex Luger
 
	.long	hrt_fall_back2_anim		;0 Bret Hart
	.long	rzr_fall_back2_anim		;1 Razor Ramon
	.long	und_fall_back2_anim		;2 Undertaker
	.long	yok_fall_back2_anim		;3 Yokozuna
	.long	shn_fall_back2_anim		;4 Shawn Michaels
	.long	bam_fall_back2_anim		;5 Bam Bam
	.long	dnk_fall_back2_anim		;6 Doink
	.long	0				;7 spare
	.long	lex_fall_back2_anim		;8 Lex Luger
	.long	0				;9 Referee


#*****************************************************************************
;AMODE_HEADHOLD	18
 SUBR	hit_headhold

	rets

#*****************************************************************************
;AMODE_JUMPKICK	19
 SUBR	hit_jumpkick

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	calla	block_hit
	rets

#noblock

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

	FACE24TBL #head_hit2
	calla	change_anim1a
	calla	wres_collis_off

	rets

#head_hit2
	.long	hrt_2_head_hit2_anim,hrt_4_head_hit2_anim		;0 Bret Hart
	.long	rzr_2_head_hit2_anim,rzr_4_head_hit2_anim		;1 Razor Ramon
	.long	und_2_head_hit2_anim,und_4_head_hit2_anim		;2 Undertaker
	.long	yok_2_head_hit2_anim,yok_4_head_hit2_anim		;3 Yokozuna
	.long	shn_2_head_hit3_anim,shn_4_head_hit3_anim		;4 Shawn Michaels
	.long	bam_2_head_hit2_anim,bam_4_head_hit2_anim		;5 Bam Bam
	.long	dnk_2_head_hit2_anim,dnk_4_head_hit2_anim		;6 Doink
	.long	dnk_2_head_hit2_anim,dnk_4_head_hit2_anim		;7 spare
	.long	lex_2_head_hit2_anim,lex_4_head_hit2_anim		;8 Lex Luger
	.long	dnk_2_head_hit2_anim,dnk_4_head_hit2_anim		;9 Referee

#head_hit_dizzy
	.ref	bam_head_hit_dizzy_anim,rzr_4_head_hit_dizzy_anim
	.ref	und_head_hit_dizzy_anim,yok_4_head_hit_dizzy_anim

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


******************************************************************************

	.end

