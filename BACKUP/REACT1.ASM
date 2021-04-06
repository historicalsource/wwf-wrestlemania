************************************************************** 
*
* Software:		Jamie Rivett
* Initiated:		8/8/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"react1.asm"
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
;MJT Start
	.include	"special.equ"
;MJT End


******************************************************************************
* EXTERNAL REFERENCES

	.REF	KILL_REWIRE_DUMMY
	.ref	change_anim1a
	.ref	wres_collis_off
;MJT Start
;	.ref	inc_burnout
;MJT End
	.ref	create_damage_points
	.ref	slide_offscr
	.ref	set_getup_time
	.ref	check_dizzy

	.REF	CALL_FACE_HIT,CALL_MID_HIT

	.REF	CALL_DROP_KICK
	.REF	ADD_IF_SILENT

	.REF	BONUS_MESS
	.ref	DAM_MULT

******************************************************************************
* EXTERNAL ANIM SEQUENCES

	.ref	bam_head_hit_dizzy_anim,rzr_4_head_hit_dizzy_anim
	.ref	und_head_hit_dizzy_anim,yok_4_head_hit_dizzy_anim

;BAM BAM
	.ref	bam_2_head_hit_anim,bam_4_head_hit_anim
	.ref	bam_2_body_hit_anim,bam_4_body_hit_anim
	.ref	bam_head_hit2_anim,bam_4_body_hit_dizzy_anim
	.ref	bam_head_hit_dizzy_anim
	.ref	bam_fall_back_anim,bam_fall_back_tbukl_anim
	.ref	bam_2_hitblock_anim,bam_4_hitblock_anim

;DOINK
	.ref	dnk_2_head_hit_anim,dnk_4_head_hit_anim
	.ref	dnk_head_hit2_anim
	.ref	dnk_head_hit_dizzy_anim
	.ref	dnk_2_hitblock_anim,dnk_4_hitblock_anim
	.ref	dnk_fall_back_anim,dnk_fall_back_tbukl_anim
	.ref	dnk_4_body_hit_anim
	.ref	dnk_4_body_hit_dizzy_anim

;BRET
	.ref	hrt_2_hitblock_anim,hrt_4_hitblock_anim
	.ref	hrt_2_head_hit_anim,hrt_4_head_hit_anim
	.ref	hrt_4_head_hit_dizzy_anim
	.ref	hrt_2_head_hit2_anim,hrt_4_head_hit2_anim
	.ref	hrt_2_body_hit_anim,hrt_4_body_hit_anim
	.ref	hrt_4_body_hit_dizzy_anim
	.ref	hrt_fall_back_anim,hrt_fall_back_tbukl_anim

;LEX
	.ref	lex_2_head_hit_anim,lex_4_head_hit_anim
	.ref	lex_2_body_hit_anim,lex_4_body_hit_anim
	.ref	lex_2_hitblock_anim,lex_4_hitblock_anim
	.ref	lex_head_hit_dizzy_anim
	.ref	lex_2_head_hit2_anim,lex_4_head_hit2_anim
	.ref	lex_4_body_hit_dizzy_anim
	.ref	lex_fall_back_anim,lex_fall_back_tbukl_anim

;RAZOR
	.ref	rzr_4_head_hit_dizzy_anim
	.ref	rzr_2_head_hit_anim,rzr_4_head_hit_anim
	.ref	rzr_2_body_hit_anim,rzr_4_body_hit_anim
	.ref	rzr_2_hitblock_anim,rzr_4_hitblock_anim
	.ref	rzr_2_head_hit2_anim,rzr_4_head_hit2_anim
	.ref	rzr_fall_back_anim,rzr_fall_back_tbukl_anim
	.ref	rzr_4_body_hit_dizzy_anim

;SHAWN
	.ref	shn_4_head_hit_dizzy_anim
	.ref	shn_2_head_hit_anim,shn_4_head_hit_anim
	.ref	shn_2_head_hit2_anim,shn_4_head_hit2_anim
	.ref	shn_2_body_hit_anim,shn_4_body_hit_anim
	.ref	shn_4_body_hit_dizzy_anim
	.ref	shn_fall_back_anim,shn_fall_back_tbukl_anim
	.ref	shn_2_hitblock_anim,shn_4_hitblock_anim

;TAKER
	.ref	und_2_head_hit_anim,und_4_head_hit_anim
	.ref	und_2_body_hit_anim,und_4_body_hit_anim
	.ref	und_head_hit_dizzy_anim
	.ref	und_head_hit2_anim
	.ref	und_4_body_hit_dizzy_anim
	.ref	und_fall_back_anim,und_fall_back_tbukl_anim
	.ref	und_2_hitblock_anim,und_4_hitblock_anim			;2 Undertaker

;YOKO
	.ref	yok_4_head_hit_dizzy_anim
	.ref	yok_2_head_hit_anim,yok_4_head_hit_anim
	.ref	yok_2_head_hit2_anim,yok_4_head_hit2_anim
	.ref	yok_2_body_hit_anim,yok_4_body_hit_anim
	.ref	yok_2_hitblock_anim,yok_4_hitblock_anim
	.ref	yok_4_body_hit_dizzy_anim
	.ref	yok_fall_back_anim


******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

	.def	hit_flykick

******************************************************************************
* EQUATES FOR THIS FILE

;MJT Start
#*****************************************************************************
* A WRESTLER HAS JUST HIT/BEEN HIT (BY A PROJECTILE/SPECIAL OBJECT)
*
* a10 = * projectile process
* a13 = * victim process

 SUBR	wrestler_hit_special

	.ref	delete_special_objlist
	.ref	firesplat_anim
	.ref	piesplat_anim
	.ref	sp_change_anim
	.ref	spiritsplat_anim

	callr	hit_stuff

	movi	-1,a0
	move	*a13(PLYRMODE),a14
	cmpi	MODE_BLOCK,a14
	jrz	#in_block

	move	*a10(SP_ID),a14
	jrnz	#dmg
;Pull in spirits do no damage until Taker
;whacks him at end!
	movi	120,a0
	move	a0,*a13(IMMOBILIZE_TIME)
	jruc	#in_block
#dmg
;Reaper projectiles do 2 damage hits
	movi	-2,a0
	move	*a13(PLYRNUM),a1
	calla	adjust_health

#in_block

	PUSH	a13
	move	a10,a13
	move	a13,a0
	calla	delete_special_objlist

;	movi	firesplat_anim,a0
;	movi	piesplat_anim,a0
	movi	spiritsplat_anim,a0
;MJT Start
	move	*a13(SP_ID),a14
	jrz	#reg
	.ref	reapersplat_anim
	movi	reapersplat_anim,a0
#reg
;MJT End

	calla	sp_change_anim
	PULL	a13

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	move	*a13(FACING_DIR),a0		;check for hit
	move	*a13(NEW_FACING_DIR),a1		;from behind
	and	a0,a1
	andi	MOVE_LEFT|MOVE_RIGHT,a1
	jrz	#noblock

	callr	block_hit
	rets

#noblock

	GETLIFE
	jrz	#isdead

	calla	create_damage_points

	SETMODE	NORMAL

	WRSNDX	KICK_L1,KICK_L2

;If opponent is in air, do fall back!

;	FACE24TBL head_hit2_tbl
;	FACETBL #losebal

	FACE24TBL body_hit_tbl
	calla	change_anim1a

	movi	[4,0],a0
	move	*a10(SP_ID),a14
	jrz	#push_away
;Pull toward
	movi	-[4,0],a0
#push_away

	move	*a13(FACING_DIR),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#abs			;right
	neg	a0			;left
#abs
	move	a0,*a13(OBJ_XVEL),L
	movi	[4,0],a0
	move	a0,*a13(OBJ_YVEL),L
	clr	a0
	move	a0,*a13(OBJ_ZVEL),L

#isdead
	calla	wres_collis_off
	rets


#*****************************************************************************
* A WRESTLER HAS JUST BEEN HIT
* a10 = * attacking wrestler proc
* a13 = * victim process

 SUBR	wrestler_hit


;Need to clear STARS_FLAG to get rid of stars!
	callr	hit_stuff


	movi	-1,a0
	move	*a13(PLYRMODE),a14
	cmpi	MODE_BLOCK,a14
	jrz	#in_block



	;get base damage val
	move	*a10(ATTACK_MODE),a0
	X16	a0
	addi	damage_values,a0
	move	*a0,a1

	;add attacker mod
	move	*a10(WRESTLERNUM),a0
	X16	a0
	addi	offense_mods,a0
	move	*a0,a0
	addi	100h,a0
	mpyu	a0,a1

	;add defender mod

	move	*a13(WRESTLERNUM),a0
	X16	a0
	addi	defense_mods,a0
	move	*a0,a0
	addi	100h,a0
	mpyu	a0,a1
	move	a1,a0
	sra	16,a0
	neg	a0


	CLR	A1
	MOVE	A0,A0
	JRZ	JUST_CLEAR_OPP

	MOVE	*A10(RISK),A1
	JRZ	#in_block

	MOVK	2,A1
	MOVE	A1,@DAM_MULT
	MMTM	SP,A0,A10
	CALLA	BONUS_MESS
	MMFM	SP,A0,A10

#in_block
	CLR	A1
	MOVE	A1,*A10(RISK)
JUST_CLEAR_OPP
	MOVE	A1,*A13(RISK)

	move	*a13(PLYRNUM),a1
	calla	adjust_health

	;if victim is on the turnbuckle, go to the special tbukl reaction
	move	*a13(PLYRMODE),a14
	cmpi	MODE_ONTURNBKL,a14
	jrne	#not_onbukl

	;if the attack mode is some kind of puppet, don't do this
	move	*a10(ATTACK_MODE),a14

	cmpi	AMODE_PUPPET,a14
	jreq	#not_onbukl
	cmpi	AMODE_PUPPET2,a14
	jreq	#not_onbukl
	cmpi	AMODE_PUPPET3,a14
	jreq	#not_onbukl

	movi	hit_ontbukl,a1
	jruc	#continue
	
#not_onbukl

	move	*a10(ATTACK_MODE),a0	;type of attack that hit doink
	move	a0,a1
	sll	5,a1			;x 32
	addi	#hit_table,a1
	move	*a1,a1,L		;appropriate routine
#continue
	call	a1

	CALLA	KILL_REWIRE_DUMMY

	rets



hit_stuff
;Stuff to do to the wrestler who got hit by another wrestler or by a
;projectile.

	clr	a0
	move	a0,*a13(STARS_FLAG)	;Gets rid of them...
	move	a0,*a13(DEBRIS_X),L	;Gets rid of them...

	move	a0,*a13(SHADTRAIL_PROC),L	;proc is toast
	move	a0,*a13(ATTIMG_CUR_FRAME),L


	move	*a13(ATTACH_PROC),a1,L
	jrz	#done
	clr	a0
	move	a0,*a13(ATTACH_PROC),L		;not attached to anything

	move	*a1(ATTACH_PROC),a2,L
	cmp	a2,a13
	jrne	#done

	move	a0,*a1(ATTACH_PROC),L		;not attached to anything
#done

;If a wrestler is running out of control, and gets hit, we need to make the
;GETUP meter go away.

	move	*a13(PLYRMODE),a0
	cmpi	MODE_BOUNCING,a0
	jrz	#yes
	cmpi	MODE_RUNNING,a0
	jrnz	#cont
#yes	move	*a13(GETUP_TIME),a0
	jrz	#cont
	move	*a13(PLYR_DIZZY),a0
	jrnz	#cont

	move	*a13(PLYRNUM),a0
	cmpi	2,a0
	jrge	#cont
;Drones do not have getup meters!

;This guy has a getup meter on screen and is running out of control!
;Get rid of meter.

	PUSH	a8,a9,a10
;Cause getup meter to slide off screen.
	move	*a13(METER_PROC),a0,L
	move	*a0(PA8),a8,L
	move	*a0(PA9),a9,L
	move	*a0(PA10),a10,L
	movi	GETUP_PID,a1
	movi	slide_offscr,a7
	calla	XFERPROC
	PULL	a8,a9,a10

#cont
	clr	a0
	move	a0,*a13(RUN_TIME)

	rets

;MJT End



#hit_table
	.long	hit_punch	;0	(this file)
	.long	hit_hdbutt	;1
	.long	hit_kick	;2
	.long	hit_flykick	;3
	.long	hit_grabthrow	;4

	REFLONG	hit_uprcut	;5	(react2.asm)
	REFLONG	hit_lbowdrop	;6
	REFLONG	hit_grabhold	;7
	REFLONG	hit_grabfling	;8
	REFLONG	hit_push	;9

;MJT Start 2
	.long	hit_urn		;10	(This file)
	REFLONG	hit_bigboot	;11	(react3.asm)
	REFLONG	hit_knee	;12
	.long	hit_hdbutt2	;13
;MJT End 2
	REFLONG	hit_boxpunch	;14

	REFLONG	hit_stomp	;15	(react4.asm)
	REFLONG	hit_spinkick	;16
	REFLONG	hit_cline	;17
	REFLONG	hit_headhold	;18
	REFLONG	hit_jumpkick	;19

	REFLONG	hit_run		;20	(react5.asm)
	REFLONG	hit_puppet	;21
	REFLONG	hit_backhand	;22
	REFLONG	hit_buzz	;23
	REFLONG	hit_haymaker	;24

	REFLONG	hit_blbowdrop	;25	(react2.asm)
	REFLONG	hit_bstomp	;26	(react4.asm)
	REFLONG	hit_headknees	;27	(react3.asm)

	REFLONG	hit_earslap	;28	(react5.asm) - MARK
	REFLONG	hit_hammer	;29	(react4.asm)

	REFLONG	hit_buttstomp	;30	(react4.asm)
	REFLONG	hit_puppet2	;31	(react5.asm) - MARK
	REFLONG	hit_puppet3	;32
	.long	hit_tomb	;33	(This file)
	.long	hit_bigknee	;34

	REFLONG	hit_shnbfkik	;35	(react8.asm) - JASON
	REFLONG	hit_shnspdkik	;36
	REFLONG	hit_shnspdkik2	;37
	REFLONG	hit_hitcheck	;38
	REFLONG	hit_armbreak	;39

	REFLONG	hit_buttdrop	;40	(react9.asm) - JASON
	REFLONG	hit_att41	;41
	REFLONG	hit_att42	;42
	REFLONG	hit_att43	;43
	.long	hit_hdbutt_stay	;44	(This file)


#*****************************************************************************
;All hit routine use this block code
;Perhaps the DAMAGE amount should be table driven
;Perhaps we push him away after x blocks?


 SUBR	block_hit

;Slide opponent away from attacker
	movi	[2,0],a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;offx - defx
	jrgt	#fall_right		;attacker on left
	neg	a2
#fall_right
	move	a2,*a13(OBJ_XVEL),L

;FIX!!
;We need to put in grunts or something... This doesn't work!
;	WRSNDX	PUNCH_L1,PUNCH_L2

	FACE24TBL #hitblock
	calla	change_anim1a

#isdead
	calla	wres_collis_off
	rets

#hitblock
	.long	hrt_2_hitblock_anim,hrt_4_hitblock_anim	;0 Bret Hart
	.long	rzr_2_hitblock_anim,rzr_4_hitblock_anim	;1 Razor Ramon
	.long	und_2_hitblock_anim,und_4_hitblock_anim	;2 Undertaker
	.long	yok_2_hitblock_anim,yok_4_hitblock_anim	;3 Yokozuna
	.long	shn_2_hitblock_anim,shn_4_hitblock_anim	;4 Shawn Michaels
	.long	bam_2_hitblock_anim,bam_4_hitblock_anim	;5 Bam Bam
	.long	dnk_2_hitblock_anim,dnk_4_hitblock_anim	;6 Doink
	.long	0,0					;7 spare
	.long	lex_2_hitblock_anim,lex_4_hitblock_anim	;8 Lex Luger
	.long	0,0					;9 Referee


#*****************************************************************************
;AMODE_PUNCH	0
;MJT Start
hit_unused	;13
;MJT End
hit_punch

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	move	*a13(FACING_DIR),a0		;check for hit
	move	*a13(NEW_FACING_DIR),a1		;from behind
	and	a0,a1
	andi	MOVE_LEFT|MOVE_RIGHT,a1
	jrz	#noblock

	callr	block_hit
	rets

#noblock

;All of the damage amounts need to be in lookup tables linked to the wrestler
;who actually struck the blow.

	CALLA	CALL_FACE_HIT

	GETLIFE
	jrz	#isdead

	calla	create_damage_points

	WRSNDX	PUNCH_L1,PUNCH_L2

	move	*a13(PLYR_DIZZY),a0
	jrnz	#diz

	calla	check_dizzy
	jrz	#not_dizzy

	movi	5*TSEC,a0
	move	a0,*a13(GETUP_TIME)

#diz
	FACE24TBL head_hit_dizzy_tbl
	calla	change_anim1a

#isdead
	calla	wres_collis_off

	rets

#not_dizzy

;MJT Start
;	calla	inc_burnout
;MJT End

;Test code
;	cmpi	6,a1			;a1 = consecutive hits
;	jrlt	#ok
;	LOCKUP
;#ok

	SETMODE	NORMAL

#do_hit
	move	*a13(OBJ_YPOSINT),a14
	move	*a13(GROUND_Y),a0
	sub	a0,a14
	cmpi	20,a14
	jrge	#fall_back

	;normal punch
	FACE24TBL head_hit_tbl
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

#*****************************************************************************
;AMODE_HDBUTT	1
hit_hdbutt

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	callr	block_hit
	rets

#noblock

	CALLA	CALL_FACE_HIT

	GETLIFE
	jrz	#isdead

	WRSNDX	HDBUTT_L1,HDBUTT_L2

;MJT Start
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
;#not_dizzy
;	calla	inc_burnout
;MJT End

	SETMODE	NORMAL

	FACE24TBL head_hit2_tbl
	calla	change_anim1a

#isdead
	calla	wres_collis_off

	rets

;MJT Start 2
#*****************************************************************************
;AMODE_HDBUTT2	13
hit_hdbutt2
;From head hold attacks

	CALLA	CALL_FACE_HIT

	WRSNDX	HDBUTT_L1,HDBUTT_L2

	FACE24TBL head_hit2_tbl
	calla	change_anim1a

	movi	10000h,a0
	move	a0,*a13(OBJ_YVEL),L

	clr	a0
	move	a0,*a13(OBJ_XVEL),L

	calla	wres_collis_off

	rets

#*****************************************************************************
;AMODE_URN	10
hit_urn

;From slap type attacks that want a face hit reaction!

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	callr	block_hit
	rets

#noblock

	CALLA	CALL_FACE_HIT

	GETLIFE
	jrz	#isdead

	WRSNDX	HDBUTT_L1,HDBUTT_L2

	SETMODE	NORMAL

	FACE24TBL head_hit2_tbl
	calla	change_anim1a

#isdead
	calla	wres_collis_off

	rets

;MJT End 2

#*****************************************************************************
;AMODE_HDBUTT_STAY	44
;No xvel will happen
hit_hdbutt_stay
	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	callr	block_hit
	rets

#noblock

	CALLA	CALL_FACE_HIT

;MJT Start
;	calla	inc_burnout
;MJT End

	SETMODE	NORMAL

	FACE24TBL head_hit2_tbl

	calla	change_anim1a
	calla	wres_collis_off

	clr	a0
	move	a0,*a13(OBJ_XVEL),L

	rets

#*****************************************************************************
;AMODE_TOMB	33
hit_tomb

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	callr	block_hit
	rets

#noblock

	CALLA	CALL_FACE_HIT

	GETLIFE
	jrz	#isdead

	WRSNDX	HDBUTT_L1,HDBUTT_L2

	move	*a13(PLYR_DIZZY),a0
	jrnz	#diz

	calla	check_dizzy
	jrz	#not_dizzy

	movi	5*TSEC,a0
	move	a0,*a13(GETUP_TIME)

#diz
	FACE24TBL head_hit_dizzy_tbl
	calla	change_anim1a

#isdead
	calla	wres_collis_off
	rets

#not_dizzy

;MJT Start
;	calla	inc_burnout
;MJT End

	SETMODE	NORMAL

	FACE24TBL head_hit2_tbl
	calla	change_anim1a

	calla	wres_collis_off

	rets

#*****************************************************************************
;AMODE_KICK	2
hit_kick


	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	callr	block_hit
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
	FACE24TBL body_hit_dizzy_tbl
	calla	change_anim1a

#isdead
	calla	wres_collis_off
	rets

#not_dizzy

;MJT Start
;	calla	inc_burnout
;MJT End

	SETMODE	NORMAL

	FACE24TBL body_hit_tbl
	calla	change_anim1a
	calla	wres_collis_off
	rets


#*****************************************************************************
;AMODE_FLYKICK	3
hit_flykick


;Any hit mode which does a fall back sequence onto the ground
;will not check dizzy at the start.
;The check dizzy happens in the sequence.


	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	callr	block_hit
	rets

#noblock
	calla	CALL_DROP_KICK

;MJT Start
	WRSNDX	FLYKICK_L1,FLYKICK_L2

	GETLIFE
	jrz	#skip


;	calla	inc_burnout

	SETMODE	NORMAL

#skip
;MJT End

	move	*a10(OBJ_XVEL),a0,L	;slow down doink's
	sra	1,a0		   	;x_vel after collis
	neg	a0
	move	a0,*a10(OBJ_XVEL),L
	movi	40000h,a0
	move	a0,*a10(OBJ_YVEL),L

	clr	a0
	move	a0,*a13(ROLL_POS)

	move	*a13(PLYR_DIZZY),a0
	jrnz	#diz

	calla	set_getup_time

#diz
	FACETBL fall_back_tbl
	calla	change_anim1a


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
;AMODE_BIGKNEE	34
hit_bigknee


;Any hit mode which does a fall back sequence onto the ground
;will not check dizzy at the start.
;The check dizzy happens in the sequence.


	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	callr	block_hit
	rets

#noblock
	calla	CALL_DROP_KICK
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
;	neg	a0
;	move	a0,*a10(OBJ_XVEL),L
;	movi	40000h,a0
;	move	a0,*a10(OBJ_YVEL),L

	clr	a0
	move	a0,*a13(ROLL_POS)

	move	*a13(PLYR_DIZZY),a0
	jrnz	#diz

	calla	set_getup_time

#diz
	FACETBL fall_back_tbl
	calla	change_anim1a


	movi	[4,0],a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;offx - defx
	jrgt	#fall_right		;attacker on left
	movi	-[4,0],a2
#fall_right
	move	a2,*a13(OBJ_XVEL),L

#isdead
	calla	wres_collis_off
	rets



#*****************************************************************************
;AMODE_GRABTHROW 4
hit_grabthrow

	rets

#*****************************************************************************
; HIT WHILE STANDING ON TURNBUCKLE -- DOESN'T MATTER WHAT THE AMODE WAS
hit_ontbukl


;	GETLIFE
;	jrz	#isdead

	WRSNDX	FLYKICK_L1,FLYKICK_L2

;MJT Start
;	calla	inc_burnout
;MJT End

	FACETBL fall_back_tbukl_tbl
	calla	change_anim1a


	movi	[4,0],a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;offx - defx
	jrgt	#fall_right		;attacker on left
	movi	[-4,0],a2
#fall_right
	move	a2,*a13(OBJ_XVEL),L
	movi	[6,0],a2
	move	a2,*a13(OBJ_YVEL),L

#isdead
	calla	wres_collis_off
	rets


******************************************************************************
*
* DAMAGE SECTION
*

;Base damage values and getup times
damage_values
	.word	D_PUNCH,D_HDBUTT,D_KICK,D_FLYKICK,D_GRABTHROW
	.word	D_UPRCUT,D_LBDROP,D_GRBHOLD,D_GRBFLNG,D_PUSH
;MJT Start 2
	.word	D_BCKHAND,D_BIGBOOT,D_KNEE,D_HDKNEES,D_BOXPUNCH
;MJT End 2
	.word	D_STOMP,D_SPINKIK,D_CLINE,D_HEDHOLD,D_JUMPKICK
	.word	D_RUN,D_PUPPET,D_BCKHAND,D_BUZZ,D_HAYMAKER
	.word	D_BLBDROP,D_BSTOMP,D_HDKNEES,D_EARSLAP2,D_HAMMER2
	.word	D_BUTTSTOMP,D_ATT31,D_ATT32,D_TOMB,D_BIGKNEE
	.word	D_FLPKIK,D_SPDKIK,D_SPDKIK2,D_HITCK,D_ARMBRK
	.word	D_ATT40,D_ATT41,D_ATT42,D_ATT43,D_HDBUTT_STAY


;MJT Start
;Wrestler offensive multipliers
offense_mods
	.word	_45PCT	;Bret
	.word	_45PCT	;Razor
	.word	_45PCT	;Taker
	.word	_45PCT	;Yoko
	.word	_45PCT	;Shawn
	.word	_45PCT	;Bam Bam
	.word	_45PCT	;Doink
	.word	_45PCT	;
	.word	_45PCT	;Lex

;Wrestler defensive multipliers
defense_mods
	.word	0	;Bret
	.word	0	;Razor
	.word	0	;Taker
	.word	0	;Yoko
	.word	0	;Shawn
	.word	0	;Bam Bam
	.word	0	;Doink
	.word	0	;
	.word	0	;Lex
;MJT End

******************************************************************************
*
* STANDARD REACTION TABLES
*

head_hit_tbl
	.long	hrt_2_head_hit_anim,hrt_4_head_hit_anim			;0 Bret Hart
	.long	rzr_2_head_hit_anim,rzr_4_head_hit_anim			;1 Razor Ramon
	.long	und_2_head_hit_anim,und_4_head_hit_anim			;2 Undertaker
	.long	yok_2_head_hit_anim,yok_4_head_hit_anim			;3 Yokozuna
	.long	shn_2_head_hit_anim,shn_4_head_hit_anim			;4 Shawn Michaels
	.long	bam_2_head_hit_anim,bam_4_head_hit_anim			;5 Bam Bam
	.long	dnk_2_head_hit_anim,dnk_4_head_hit_anim			;6 Doink
	.long	0,0							;7 spare
	.long	lex_2_head_hit_anim,lex_4_head_hit_anim			;8 Lex Luger
	.long	0,0							;9 Referee

	.def	head_hit2_tbl
head_hit2_tbl
	.long	hrt_2_head_hit2_anim,hrt_4_head_hit2_anim		;0 Bret Hart
	.long	rzr_2_head_hit2_anim,rzr_4_head_hit2_anim		;1 Razor Ramon
	.long	und_head_hit2_anim,und_head_hit2_anim			;2 Undertaker
	.long	yok_2_head_hit2_anim,yok_4_head_hit2_anim		;3 Yokozuna
	.long	shn_2_head_hit2_anim,shn_4_head_hit2_anim		;4 Shawn Michaels
	.long	bam_head_hit2_anim,bam_head_hit2_anim			;5 Bam Bam
	.long	dnk_head_hit2_anim,dnk_head_hit2_anim			;6 Doink
	.long	0,0							;7 spare
	.long	lex_2_head_hit2_anim,lex_4_head_hit2_anim		;8 Lex Luger
	.long	0,0							;9 Referee

;head_hit3_tbl
;	.long	hrt_2_head_hit3_anim,hrt_4_head_hit3_anim		;0 Bret Hart
;	.long	rzr_2_head_hit3_anim,rzr_4_head_hit3_anim		;1 Razor Ramon
;	.long	und_head_hit3_anim,und_head_hit3_anim			;2 Undertaker
;	.long	yok_2_head_hit3_anim,yok_4_head_hit3_anim		;3 Yokozuna
;	.long	shn_2_head_hit3_anim,shn_4_head_hit3_anim		;4 Shawn Michaels
;	.long	bam_head_hit3_anim,bam_head_hit3_anim			;5 Bam Bam
;	.long	dnk_head_hit3_anim,dnk_head_hit3_anim			;6 Doink
;	.long	0,0							;7 spare
;	.long	lex_2_head_hit3_anim,lex_4_head_hit3_anim		;8 Lex Luger
;	.long	0,0							;9 Referee

head_hit_dizzy_tbl
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

body_hit_tbl
	.long	hrt_2_body_hit_anim,hrt_4_body_hit_anim			;0 Bret Hart
	.long	rzr_2_body_hit_anim,rzr_4_body_hit_anim			;1 Razor Ramon
	.long	und_2_body_hit_anim,und_4_body_hit_anim			;2 Undertaker
	.long	yok_2_body_hit_anim,yok_4_body_hit_anim			;3 Yokozuna
	.long	shn_2_body_hit_anim,shn_4_body_hit_anim			;4 Shawn Michaels
	.long	bam_2_body_hit_anim,bam_4_body_hit_anim			;5 Bam Bam
	.long	dnk_4_body_hit_anim,dnk_4_body_hit_anim			;6 Doink
	.long	0,0							;7 spare
	.long	lex_2_body_hit_anim,lex_4_body_hit_anim			;8 Lex Luger
	.long	0,0							;9 Referee

body_hit_dizzy_tbl
	.long	hrt_4_body_hit_dizzy_anim,hrt_4_body_hit_dizzy_anim	;0 Bret Hart
	.long	rzr_4_body_hit_dizzy_anim,rzr_4_body_hit_dizzy_anim	;1 Razor Ramon
	.long	und_4_body_hit_dizzy_anim,und_4_body_hit_dizzy_anim	;2 Undertaker
	.long	yok_4_body_hit_dizzy_anim,yok_4_body_hit_dizzy_anim	;3 Yokozuna
	.long	shn_4_body_hit_dizzy_anim,shn_4_body_hit_dizzy_anim	;4 Shawn Michaels
	.long	bam_4_body_hit_dizzy_anim,bam_4_body_hit_dizzy_anim	;5 Bam Bam
	.long	dnk_4_body_hit_dizzy_anim,dnk_4_body_hit_dizzy_anim	;6 Doink
	.long	0,0							;7 spare
	.long	lex_4_body_hit_dizzy_anim,lex_4_body_hit_dizzy_anim	;8 Lex Luger
	.long	0,0							;9 Referee

 SUBR	fall_back_tbl
	.long	hrt_fall_back_anim					;0 Bret Hart
	.long	rzr_fall_back_anim					;1 Razor Ramon
	.long	und_fall_back_anim					;2 Undertaker
	.long	yok_fall_back_anim					;3 Yokozuna
	.long	shn_fall_back_anim					;4 Shawn Michaels
	.long	bam_fall_back_anim					;5 Bam Bam
	.long	dnk_fall_back_anim					;6 Doink
	.long	0		  					;7 spare
	.long	lex_fall_back_anim					;8 Lex Luger
	.long	0		  					;9 Referee

 SUBR	fall_back_tbukl_tbl
	.long	hrt_fall_back_tbukl_anim				;0 Bret Hart
	.long	rzr_fall_back_tbukl_anim				;1 Razor Ramon
	.long	und_fall_back_tbukl_anim				;2 Undertaker
	.long	yok_fall_back_anim					;3 Yokozuna
	.long	shn_fall_back_tbukl_anim				;4 Shawn Michaels
	.long	bam_fall_back_tbukl_anim				;5 Bam Bam
	.long	dnk_fall_back_tbukl_anim				;6 Doink
	.long	0		  					;7 spare
	.long	lex_fall_back_tbukl_anim				;8 Lex Luger

******************************************************************************

	.end
