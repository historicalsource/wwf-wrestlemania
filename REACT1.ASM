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
	.include	"special.equ"
	.include	"jjxm.h"


******************************************************************************
* EXTERNAL REFERENCES

	.ref	change_anim1a,PCNT,flash_white,round_award,any_hits
	.ref	wres_collis_off,slide_offscr
	.ref	set_getup_time
	.ref	good_run_hit,MOVE_NAME_ANNC
	.ref	CALL_FACE_HIT,CALL_MID_HIT,DO_BLOCK_SND,DO_SCREAM
	.ref	CALL_DROP_KICK,ADD_IF_SILENT,BONUS_MESS,DAM_MULT
	.ref	FIRSTATT_MESS
	.ref	delete_special_objlist
	.ref	sp_change_anim


******************************************************************************
* EXTERNAL ANIM SEQUENCES

;BAM BAM
	.ref	bam_2_head_hit_anim,bam_4_head_hit_anim
	.ref	bam_2_body_hit_anim,bam_4_body_hit_anim
	.ref	bam_head_hit2_anim,bam_4_body_hit_dizzy_anim
	.ref	bam_head_hit_dizzy_anim,bam_hitonground_anim
	.ref	bam_fall_back_anim,bam_fall_back_tbukl_anim
	.ref	bam_4_hitblock_anim

;DOINK
	.ref	dnk_2_head_hit_anim,dnk_4_head_hit_anim
	.ref	dnk_head_hit2_anim,dnk_hitonground_anim
	.ref	dnk_head_hit_dizzy_anim
	.ref	dnk_4_hitblock_anim
	.ref	dnk_fall_back_anim,dnk_fall_back_tbukl_anim
	.ref	dnk_4_body_hit_anim
	.ref	dnk_4_body_hit_dizzy_anim

;BRET
	.ref	hrt_4_hitblock_anim,hrt_hitonground_anim
	.ref	hrt_2_head_hit_anim,hrt_4_head_hit_anim
	.ref	hrt_4_head_hit_dizzy_anim
	.ref	hrt_2_head_hit2_anim,hrt_4_head_hit2_anim
	.ref	hrt_2_body_hit_anim,hrt_4_body_hit_anim
	.ref	hrt_4_body_hit_dizzy_anim
	.ref	hrt_fall_back_anim,hrt_fall_back_tbukl_anim

;LEX
	.ref	lex_2_head_hit_anim,lex_4_head_hit_anim
	.ref	lex_2_body_hit_anim,lex_4_body_hit_anim
	.ref	lex_4_hitblock_anim
	.ref	lex_head_hit_dizzy_anim,lex_hitonground_anim
	.ref	lex_2_head_hit2_anim,lex_4_head_hit2_anim
	.ref	lex_4_body_hit_dizzy_anim
	.ref	lex_fall_back_anim,lex_fall_back_tbukl_anim
	.ref	lex_flying_kick_anim,lex_super_kick_anim

;RAZOR
	.ref	rzr_4_head_hit_dizzy_anim
	.ref	rzr_2_head_hit_anim,rzr_4_head_hit_anim
	.ref	rzr_2_body_hit_anim,rzr_4_body_hit_anim
	.ref	rzr_4_hitblock_anim
	.ref	rzr_2_head_hit2_anim,rzr_4_head_hit2_anim
	.ref	rzr_fall_back_anim,rzr_fall_back_tbukl_anim
	.ref	rzr_4_body_hit_dizzy_anim,rzr_hitonground_anim

;SHAWN
	.ref	shn_4_head_hit_dizzy_anim
	.ref	shn_2_head_hit_anim,shn_4_head_hit_anim
	.ref	shn_2_head_hit2_anim,shn_4_head_hit2_anim
	.ref	shn_2_body_hit_anim,shn_4_body_hit_anim
	.ref	shn_4_body_hit_dizzy_anim,shn_hitonground_anim
	.ref	shn_fall_back_anim,shn_fall_back_tbukl_anim
	.ref	shn_4_hitblock_anim

;TAKER
	.ref	und_2_head_hit_anim,und_4_head_hit_anim
	.ref	und_2_body_hit_anim,und_4_body_hit_anim
	.ref	und_head_hit_dizzy_anim
	.ref	und_head_hit2_anim,und_hitonground_anim
	.ref	und_4_body_hit_dizzy_anim
	.ref	und_fall_back_anim,und_fall_back_tbukl_anim
	.ref	und_4_hitblock_anim

;YOKO
	.ref	yok_4_head_hit_dizzy_anim
	.ref	yok_2_head_hit_anim,yok_4_head_hit_anim
	.ref	yok_2_head_hit2_anim,yok_4_head_hit2_anim
	.ref	yok_2_body_hit_anim,yok_4_body_hit_anim
	.ref	yok_4_hitblock_anim
	.ref	yok_4_body_hit_dizzy_anim
	.ref	yok_fall_back_anim,yok_hitonground_anim


******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

	.def	hit_flykick

;when a hit is scored, the damage is computed, then stuck in 'ere.  It won't
; be applied until AFTER the appropriate hit routine is called, so you have
; a chance to change the value in special mode-dependent cases. (A stomp
; which shouldn't hurt someone in MODE_NORMAL, for example...)

	BSSX	hit_damage_pending,16

;In general, we want to clear a victim's MOVE_DIR when we hit him.  This
; value is set to 0 before the hit routine is called.  If, for whatever
; reason, we don't want a particular attack mode to clear the victim's
; MOVE_DIR, just stuff it in here.  new_victim_movedir is stuffed into
; victim's MOVE_DIR right after the amode routine returns.

	BSSX	new_victim_movedir,16

	.if DEBUG
	BSSX	instant_death,16		;debug thing
	.endif

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
* A WRESTLER HAS JUST HIT/BEEN HIT (BY A PROJECTILE/SPECIAL OBJECT)
*
* a10 = * projectile process
* a13 = * victim process

 SUBR	wrestler_hit_special

	;update LAST_HIT_TIME on attacker
	move	@PCNT,a14,L			;use 32-bit PCNT!
	move	*a10(SP_WRESPROC),a0,L
	move	a14,*a0(LAST_HIT_TIME),L

	callr	hit_stuff

	move	*a10(SP_ID),a14
	cmpi	2,a14
	jrnz	#not_salt

;Salt hits player
	move	*a13(PLYRMODE),a14
	cmpi	MODE_BLOCK,a14
	jrnz	#tag
	move	*a10(SP_WRESPROC),a0,L
	movk	1,a14
	move	a4,*a0(USR_VAR2)		;Tell Yoko his salt was failed!
	jruc	#in_block0
#tag
;	cmpi	MODE_INAIR,a14
;	jrz	#in_block0

;Salt projectiles do damage
	calla	DO_SCREAM
	movi	-D_SALT,a0
	move	*a13(PLYRNUM),a1
	calla	adjust_health

#in_block0
	PUSH	a13
	move	a10,a13
	movi	saltsplat_anim,a0
	calla	sp_change_anim
	PULL	a13

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock0

;	move	*a13(FACING_DIR),a0		;check for hit
;	move	*a13(NEW_FACING_DIR),a1		;from behind
;	and	a0,a1
;	andi	MOVE_LEFT|MOVE_RIGHT,a1
;	jrz	#noblock0

;Block_hit
;Slide opponent away from attacker
	movi	[3,0],a2
	move	*a10(SP_OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;offx - defx
	jrgt	#fall_right0		;attacker on left
	neg	a2
#fall_right0
	move	a2,*a13(OBJ_XVEL),L

	CALLA	DO_BLOCK_SND

	FACETBL hitblock_tbl
	calla	change_anim1a

	rets

#noblock0

;Salt will pick off in air opponent!
;	move	*a13(PLYRMODE),a14
;	cmpi	MODE_INAIR,a14
;	jrz	#isdead

	GETLIFE
	jrz	#isdead


	SETMODE	NORMAL

	move	*a10(SP_WRESPROC),a0,L

	move	*a0(OBJ_ZPOS),a0,L
	subi	[1,0],a0
	move	a0,*a13(OBJ_ZPOS),L

;If opponent is in air, do fall back!
	FACETBL head_hit2_sand_tbl
	calla	change_anim1a

	clr	a0
	move	a0,*a13(USR_VAR1)

	movi	8*60,a14
	move	a14,*a13(DELAY_METER)


	movi	-[1,0h],a0
;	movi	-[3,8000h],a0
	move	*a13(FACING_DIR),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#abs0			;right
	neg	a0			;left
#abs0
	move	a0,*a13(OBJ_XVEL),L
;	movi	[5,0],a0
	movi	[3,0],a0
	move	a0,*a13(OBJ_YVEL),L
	movi	7000h,a0
	move	a0,*a13(OBJ_ZVEL),L
	move	a0,*a10(SP_OBJ_ZVEL),L

	move	*a10(SP_OBJ_XVEL),a0,L
	sra	1,a0
	move	a0,*a10(SP_OBJ_XVEL),L

	rets

#not_salt
	move	*a13(PLYRMODE),a14
	cmpi	MODE_BLOCK,a14
	jrz	#in_block
;	cmpi	MODE_INAIR,a14
;	jrz	#in_block

	move	*a10(SP_ID),a14
	jrnz	#dmg
;Pull in spirits do no damage until Taker
;whacks him at end!
	movi	60,a0
	move	a0,*a13(IMMOBILIZE_TIME)
	jruc	#in_block
#dmg
;Reaper projectiles do 2 damage hits
	movi	-3,a0
	move	*a13(PLYRNUM),a1
	calla	adjust_health

#in_block

	PUSH	a13
	move	a10,a13
	move	a13,a0
	calla	delete_special_objlist

	move	*a13(SP_ID),a14
	sll	5,a14
	addi	#splat_tbl,a14

	;range check
	cmpi	#splat_tbl_end,a14
	jrlt	#stok
	movi	#splat_tbl,a14
	.if DEBUG
	LOCKUP
	.endif

#stok	move	*a14,a0,L
#reg
	calla	sp_change_anim
	PULL	a13

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

;	move	*a13(FACING_DIR),a0		;check for hit
;	move	*a13(NEW_FACING_DIR),a1		;from behind
;	and	a0,a1
;	andi	MOVE_LEFT|MOVE_RIGHT,a1
;	jrz	#noblock

;Block_hit
;Slide opponent away from attacker
	movi	[2,0],a2
	move	*a10(SP_OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;offx - defx
	jrgt	#fall_right		;attacker on left
	neg	a2
#fall_right
	move	a2,*a13(OBJ_XVEL),L

	CALLA	DO_BLOCK_SND

	FACETBL hitblock_tbl
	calla	change_anim1a

	rets

#noblock
	move	*a13(PLYRMODE),a14
	cmpi	MODE_INAIR,a14
	jrz	#isdead
	GETLIFE
	jrz	#isdead

	SETMODE	NORMAL

	move	*a10(SP_WRESPROC),a0,L

	move	*a0(OBJ_ZPOS),a0,L
	subi	[1,0],a0
	move	a0,*a13(OBJ_ZPOS),L

;If opponent is in air, do fall back!
	FACETBL body_hit2_tbl
	calla	change_anim1a

	clr	a0
	move	a0,*a13(USR_VAR1)

	movi	-[3,0],a0
	move	*a10(SP_ID),a14
	jrnz	#push_away
;Pull toward
;Send body hit into dizzy state at the end.
	movk	1,a0
	move	a0,*a13(USR_VAR1)

	movi	10*60,a14
	move	a14,*a13(DELAY_METER)

;Get Taker's xpos
;Don't allow the wrestler to get real close to Taker
;Try to set him up for an uppercut!
	move	*a10(SP_WRESPROC),a0,L
	move	*a0(OBJ_XPOSINT),a14
	move	*a13(OBJ_XPOSINT),a0
	sub	a0,a14
	abs	a14
	clr	a0
	cmpi	5ch,a14
	jrlt	#abs
	movi	[4,0],a0
#push_away

	move	*a13(FACING_DIR),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#abs			;right
	neg	a0			;left
#abs
	move	a0,*a13(OBJ_XVEL),L
	movi	[3,0],a0
	move	a0,*a13(OBJ_YVEL),L
	clr	a0
	move	a0,*a13(OBJ_ZVEL),L

	calla	DO_SCREAM

#isdead
	rets

#splat_tbl
	REFLONG	spiritsplat_anim
	REFLONG	reapersplat_anim
	REFLONG	saltsplat_anim
#splat_tbl_end

#*****************************************************************************
* A WRESTLER HAS JUST BEEN HIT
* a10 = * attacking wrestler proc
* a13 = * victim process

 SUBR	wrestler_hit

	;If the attack is a run, we have to check and see first if it's
	; going to be ignored, in which case we skip ALL this crap.

	move	*a10(ATTACK_MODE),a14
	cmpi	AMODE_RUN,a14
	jrne	#good_hit
	calla	good_run_hit
	jrc	#good_hit

	;crummy hit.  forget it.
	rets

#good_hit
	;set WHOIHIT and WHOHITME HERE, not in COLLIS, because we don't
	; want bogus run hits to change them.  (Otherwise reversals will
	; start hitting innocent bystanders who run by.)
	move	a10,*a13(WHOHITME),L
	move	a13,*a10(WHOIHIT),L

;Need to clear STARS_FLAG to get rid of stars!
	callr	hit_stuff

	;update LAST_HIT_TIME on attacker
	move	@PCNT,a14,L
	move	a14,*a10(LAST_HIT_TIME),L	;use 32-bit PCNT!

	;set up the new victim move_dir thingie
	clr	a14
	move	a14,@new_victim_movedir

	;get base damage val
	move	*a10(ATTACK_MODE),a0
	X32	a0
	addi	damage_values,a0

	;if we've taken damage in the last 50 ticks, use the second value
	; in the damage table.
	move	*a13(LAST_DAMAGE),a14
	jrz	#dmset
	move	@PCNT,a1
	sub	a14,a1
	cmpi	50,a1	;20
	jrgt	#dmset
	addk	10h,a0
#dmset	move	*a0,a1

	;ooh, wait.  if the attacker has a NEXT_DAMAGE set, use that instead.
	; Exceptions:  If this hit does zero damage, don't mess with it,
	; AND leave NEXT_DAMAGE value in place.  If this hit does more than
	; zero damage, but LESS THAN NEXT_DAMAGE, leave the value alone,
	; and clear NEXT_DAMAGE.
	TEST	a1
	jrz	#nnd		;not a damaging hit - don't check.
	move	*a10(NEXT_DAMAGE),a14
	jrz	#nnd		;no NEXT_DAMAGE set.  move on.
	move	*a10(SPECIAL_DAMAGE_TIME),a14,L
	move	@PCNT,a0,L
	cmp	a14,a0
	jrgt	#clrnd		;too late.  clear NEXT_DAMAGE

	move	*a10(NEXT_DAMAGE),a14
	cmp	a1,a14
	jrgt	#clrnd		;if NEXT_DAMAGE is more than we were gonna
				; do anyway, use the original damage.
	move	a14,a1		;use NEXT_DAMAGE
#clrnd	clr	a14
	move	a14,*a10(NEXT_DAMAGE)

#nnd	;add attacker mod
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

	;block check
	move	*a13(PLYRMODE),a14
	cmpi	MODE_BLOCK,a14
	jrnz	#no_block

	;Hey!  If the attack mode is BSTOMP or BSTOMP2, don't reduce the
	; damage!
	move	*a10(ATTACK_MODE),a14
	cmpi	AMODE_BSTOMP,a14
	jreq	#no_block
;	cmpi	AMODE_BSTOMP2,a14	;bstomp2 is NOT a turnbuckle attack!
;	jreq	#no_block
	cmpi	AMODE_BLBOWDROP,a14
	jreq	#no_block

	;we're blocking.  if damage isn't zero, reduce it to one.
	TEST	a0
	jrz	#no_mult
	movi	-1,a0
	jruc	#no_mult
#no_block
	CLR	A1
	MOVE	A0,A0
	JRZ	JUST_CLEAR_OPP

	MOVE	*A10(RISK),A1
	JRZ	#no_mult

;Is there a real good reason why this is a CREATE0 instead of a CREATE?
	PUSH	a0,a8,a10
	move	a10,a8
	clr	a10
	btst	15,a1
	jrz	#reg
;Taunt style high risk move - give 3x dmg
	movi	-1,a10
	movk	4,a14
	move	a14,@DAM_MULT
#reg
	movk	1,a0
	move	a0,@any_hits
	CREATE0	BONUS_MESS
	PULL	a0,a8,a10
#no_mult
	CLR	A1
	MOVE	A1,*A10(RISK)
JUST_CLEAR_OPP
	MOVE	A1,*A13(RISK)

	;store the damage value where hit functions can get at it
	move	a0,@hit_damage_pending

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
	cmpi	AMODE_PUPPET_HDGRAB,a14
	jreq	#not_onbukl
	cmpi	AMODE_HITCHECK,a14
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

	;now apply the damage, unless it's zero.
	move	@hit_damage_pending,a0

	.if DEBUG
	move	@instant_death,a14
	jrz	#nid
	movi	-200,a0
#nid	TEST	a0
	.endif

	jrz	#skip_adjust

	;If this is the first unblocked hit this round and it did at least
	; 2 pixels of damage, give an award

	PUSH	a0

	cmpi	-2,a0
	jrgt	#n1uh

	move	@any_hits,a14
	jrnz	#n1uh			;skip if there's already been one

	move	*a13(PLYRMODE),a14
	cmpi	MODE_BLOCK,a14
	jreq	#n1uh			;skip if it was blocked

	RND_AWARD a10,FIRST_HIT_AWD

	PUSH	a10
	CREATE	MESSAGE_PID,FIRSTATT_MESS
	PULL	a10

	movk	2,a14
	move	a14,@DAM_MULT

	movk	1,a14
	move	a14,@any_hits
#n1uh	PULL	a0

	move	*a13(PLYRNUM),a1
	calla	adjust_health
#skip_adjust
	move	@new_victim_movedir,a0
	move	a0,*a13(MOVE_DIR)


	rets

**********
* Stuff to do to the wrestler who got hit by another wrestler or by a
* projectile.

 SUBRP	hit_stuff

	;don't do ANY of this stuff if the attack mode is AMODE_HITCHECK
	move	*a10(ATTACK_MODE),a14
	cmpi	AMODE_HITCHECK,a14
	jreq	#rets

	;if our victim is KO'd, wake him up and set his NO_KO bit.
	move	*a13(STATUS_FLAGS),a14
	btst	B_KOD,a14
	jrz	#nko

	ori	M_NO_KO,a14
	andni	M_KOD,a14
	move	a14,*a13(STATUS_FLAGS)

	movk	1,a14
	move	a14,*a13(PTIME)
#nko

	;routine cleanup
	clr	a0
	move	a0,*a13(STARS_FLAG)	;Gets rid of them...
	move	a0,*a13(DEBRIS_X),L	;Gets rid of them...
	MOVE	A0,*A13(COMBO_COUNT)

	move	a0,*a13(SHADTRAIL_PROC),L	;proc is toast
	move	a0,*a13(ATTIMG_CUR_FRAME),L
	move	*a13(MY_PAL),*a13(OBJ_PAL)
	move	*a13(OBJ_CONTROL),a14
	andni	01111b,a14
	ori	DMAWNZ,a14
	move	a14,*a13(OBJ_CONTROL)

	;attach cleanup
	move	*a13(ATTACH_PROC),a1,L
	jrz	#done_attch

	clr	a0
	move	a0,*a13(ATTACH_PROC),L	;not attached to anything

	move	*a1(ATTACH_PROC),a2,L
	cmp	a2,a13
	jrne	#mismatch

	cmp	a1,a10
	jreq	#done_attch	;ignore if victim is attached to attacker

	move	a0,*a1(ATTACH_PROC),L
	move	a0,*a1(SHADTRAIL_PROC),L	;proc is toast
	move	a0,*a1(ATTIMG_CUR_FRAME),L
	move	a0,*a1(STARS_FLAG)	;Gets rid of them...
	move	a0,*a1(DEBRIS_X),L	;Gets rid of them...
	move	*a1(MY_PAL),*a1(OBJ_PAL)
	move	*a1(OBJ_CONTROL),a14
	andni	01111b,a14
	ori	DMAWNZ,a14
	move	a14,*a1(OBJ_CONTROL)

	;victim was attached to someone.  Depending on their mode, break
	; 'em out of it.
	move	*a1(PLYRMODE),a14
	cmpi	MODE_PUPPET,a14
	jreq	#goto_stand_anim
	cmpi	MODE_ONGROUND,a14
	jreq	#abort_att_anim
	cmpi	MODE_ATTACHED,a14
	jreq	#abort_att_anim
	cmpi	MODE_INAIR,a14
	jreq	#abort_att_anim
	cmpi	MODE_INAIR2,a14
	jreq	#abort_att_anim
	cmpi	MODE_DEAD,a14
	jreq	#abort_att_anim
	cmpi	MODE_PUPPET2,a14
	jreq	#goto_stand_anim
	cmpi	MODE_NORMAL,a14
	jreq	#goto_stand_anim
	cmpi	MODE_RUNNING,a14
	jreq	#goto_stand_anim
	cmpi	MODE_HEADHELD,a14
	jreq	#goto_stand_anim
	cmpi	MODE_HEADHOLD,a14
	jreq	#goto_stand_anim
	cmpi	MODE_CHOKEHOLD,a14
	jreq	#goto_stand_anim
	cmpi	MODE_OPPOVERHEAD,a14
	jreq	#goto_stand_anim

	.if DEBUG
	LOCKUP	;bizarre mode - don't know how to fix it.
	.endif
	jruc	#done_attch

#mismatch
	.if DEBUG
	LOCKUP	;I've been hit, but the guy I'm attached to isn't attached
		; to me, so I don't know if I should break him out of what
		; he's doing or not...
	.endif
	jruc	#done_attch

#goto_stand_anim
	PUSH	a13
	move	a1,a13
	movi	xxx_goto_stand_anim,a0
	calla	change_anim1a
	PULL	a13
	jruc	#done_attch

#abort_att_anim
	PUSH	a13
	move	a1,a13
	movi	xxx_aborted_attach_anim,a0
	calla	change_anim1a
	PULL	a13

#done_attch

;	;If our TEMP_PAL bit is set, restore the original, since we'll be
;	; aborting the sequence that would otherwise have restored it.
	;Do this above, whether or not the bit is set, and for anyone
	; we're attached to too.
;	move	*a13(STATUS_FLAGS),a0
;	btst	B_TEMP_PAL,a0
;	jrz	#done_pal
;
;	;clear the bit
;	andni	M_TEMP_PAL,a0
;	move	a0,*a13(STATUS_FLAGS)
;
;	;restore the pal
;	move	*a13(MY_PAL),*a13(OBJ_PAL)
;
;#done_pal

	;if we're in SMART_ATTACK mode, clear it.
	clr	a14
	move	a14,*a13(SMART_TARGET),L
	move	*a13(STATUS_FLAGS),a14
	andni	M_SMART_ATTACK,a14
	move	a14,*a13(STATUS_FLAGS)

;If a wrestler is running out of control, and gets hit, we need to make the
;GETUP meter go away.

	move	*a13(PLYRMODE),a0
	cmpi	MODE_BOUNCING,a0
	jrz	#yes
	cmpi	MODE_RUNNING,a0
	jrnz	#cont

#yes
	.ref	ditch_getup_meter
	calla	ditch_getup_meter

#cont
	clr	a0
	move	a0,*a13(RUN_TIME)

;If he's attached to someone, detach both of them.  (Note that we're not
; checking the blocking case here.  you've no business being in mode_block
; if you're attached.  Pbltltlt.)

	.if DEBUG
	move	*a13(PLYRMODE),a14
	cmpi	MODE_BLOCK,a14
	jrne	#x0
	move	*a13(ATTACH_PROC),a14,L
	jrz	#x0

	LOCKUP	;HEY!  No blocking when attached.  Bogus.
#x0
	.endif

	move	*a13(ATTACH_PROC),a0,L
	jrnz	#attach_check_done

	;attached.  zero attach_procs both ways, and set other guy to NORMAL.
	clr	a14
	move	a14,*a13(ATTACH_PROC),L
	move	a14,*a0(ATTACH_PROC),L
	movi	MODE_NORMAL,a14
	move	a14,*a0(PLYRMODE)

#attach_check_done
#rets	rets


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

	.long	hit_urn		;10	(This file)
	REFLONG	hit_bigboot	;11	(react3.asm)
	REFLONG	hit_knee	;12
	.long	hit_hdbutt2	;13
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
	REFLONG	hit_puppet_hdgrab	;32
	.long	hit_tomb	;33	(This file)
	.long	hit_bigknee	;34

	REFLONG	hit_shnbfkik	;35	(react8.asm) - JASON
	REFLONG	hit_shnspdkik	;36
	REFLONG	hit_shnspdkik2	;37
	REFLONG	hit_hitcheck	;38
	REFLONG	hit_combo_uprcut	;39     (react2.asm) - why was this taken out ????

	REFLONG	hit_rslash	;40	(react9.asm) - JASON
	REFLONG	hit_headdslash	;41
	REFLONG	hit_headuslash	;42
	REFLONG	hit_rslash	;43	(same rxn, diff damage)
	.long	hit_hdbutt_stay	;44	(This file)

	.long	hit_fire_punch	;45
	REFLONG	hit_bstomp2	;46	(react4.asm)
	REFLONG	hit_gutpush	;47	(react2.asm)
	.long	hit_super_kick	;48
	.long	hit_punch	;49	(AMODE_PUNCH2)
	.long	hit_urn		;50	(AMODE_HDBUTT3)
	REFLONG	hit_lbowdrop	;51	(AMODE_LBOWDROP2)
	REFLONG	hit_stomp	;52	(AMODE_STOMP2 - react4.asm)

	REFLONG	hit_puppet_noflail ;53	(react5.asm)
	REFLONG	hit_puppet_toss	;54	(react5.asm)
	REFLONG	hit_napalm	;55	(react9.asm)

#*****************************************************************************
;All hit routine use this block code
;Perhaps the DAMAGE amount should be table driven
;Perhaps we push him away after x blocks?


 SUBR	block_hit

;Slide opponent away from attacker
	movi	[4,8000h],a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;offx - defx
	jrgt	#fall_right		;attacker on left
	neg	a2
#fall_right
	move	a2,*a13(OBJ_XVEL),L

;FIX!!
;We need to put in grunts or something... This doesn't work!
	CALLA	DO_BLOCK_SND

	FACETBL hitblock_tbl
	calla	change_anim1a

#isdead
	calla	wres_collis_off
	rets

#*****************************************************************************
;All hit routine use this block code
;Perhaps the DAMAGE amount should be table driven
;Perhaps we push him away after x blocks?


 SUBR	block_hit_flail

;Slide opponent away from attacker
	movi	[6,8000h],a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;offx - defx
	jrgt	#fall_right		;attacker on left
	neg	a2
#fall_right
	move	a2,*a13(OBJ_XVEL),L

;FIX!!
;We need to put in grunts or something... This doesn't work!
	CALLA	DO_BLOCK_SND

;	FACETBL hitblock_tbl
	FACETBL hitblock_flail_tbl
	calla	change_anim1a

#isdead
	calla	wres_collis_off
	rets
;
;
;
;
;
;	CALLA	DO_BLOCK_SND
;
;	FACETBL hitblock_flail_tbl
;	calla	change_anim1a
;
;#isdead
;	calla	wres_collis_off
;	rets

#*****************************************************************************
;AMODE_PUNCH	0
hit_unused	;13
hit_punch
hit_fire_punch

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

;	move	*a13(FACING_DIR),a0		;check for hit
;	move	*a13(NEW_FACING_DIR),a1		;from behind
;	and	a0,a1
;	andi	MOVE_LEFT|MOVE_RIGHT,a1
;	jrz	#noblock

	callr	block_hit
	rets

#noblock

;All of the damage amounts need to be in lookup tables linked to the wrestler
;who actually struck the blow.

	CALLA	CALL_FACE_HIT

	GETLIFE
	jrz	#isdead

;	calla	create_damage_points

	WRSNDX	PUNCH_L1,PUNCH_L2

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
;#isdead
;	calla	wres_collis_off
;
;	rets
;
;#not_dizzy
;
;;	calla	inc_burnout
;
;;Test code
;;	cmpi	6,a1			;a1 = consecutive hits
;;	jrlt	#ok
;;	LOCKUP
;;#ok
;
	SETMODE	NORMAL

;#do_hit
	move	*a13(OBJ_YPOSINT),a14
	move	*a13(GROUND_Y),a0
	sub	a0,a14
	cmpi	20,a14
	jrge	#fall_back

	move	*a13(CONSECUTIVE_HITS),a0
	inc	a0
	move	a0,*a13(CONSECUTIVE_HITS)
	subk	6,a0
	jrnz	#ok

	clr	a0
	move	a0,*a13(CONSECUTIVE_HITS)
;Consecutive hits without blocking/walking
;Do push away

	;go to #ok if opp is in combo mode
	move	*a13(WHOHITME),a14,L
	move	*a14(COMBO_COUNT),a14
	jrnz	#ok

	FACETBL #losebal
	calla	change_anim1a

;	movi	[5,0],a2
;
;	move	*a10(OBJ_XPOSINT),a0
;	move	*a13(OBJ_XPOSINT),a1
;	cmp	a0,a1			;offx - defx
;	jrgt	#fall_right		;attacker on left
;	neg	a2
;#fall_right
;	move	a2,*a13(OBJ_XVEL),L

	jruc	#isdead

#ok

	;normal punch
	FACE24TBL head_hit_tbl
	calla	change_anim1a

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
	jrgt	#fall_right1		;attacker on left
	neg	a2
#fall_right1
	move	a2,*a13(OBJ_XVEL),L

	rets

#losebal
	REFLONG	hrt_4_losebal_anim	;0 Bret Hart
	REFLONG	rzr_4_losebal_anim	;1 Razor Ramon
	REFLONG	und_4_losebal_anim	;2 Undertaker
	REFLONG	yok_4_losebal_anim	;3 Yokozuna
	REFLONG	shn_4_losebal_anim	;4 Shawn Michaels
	REFLONG	bam_4_losebal_anim	;5 Bam Bam
	REFLONG	dnk_4_losebal_anim	;6 Doink
	REFLONG	dnk_4_losebal_anim	;7 spare
	REFLONG	lex_4_losebal_anim	;8 Lex Luger

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

	SETMODE	NORMAL

	FACE24TBL head_hit2_tbl
	calla	change_anim1a

#isdead
	calla	wres_collis_off

	rets

#*****************************************************************************
;AMODE_HDBUTT2	13
hit_hdbutt2
;From head hold attacks

	CALLA	CALL_FACE_HIT

	WRSNDX	HDBUTT_L1,HDBUTT_L2

	FACE24TBL head_hit2_tbl
	calla	change_anim1a

	movi	3C000h,a0
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

	callr	block_hit_flail
	rets

#noblock

	CALLA	CALL_FACE_HIT

	GETLIFE
	jrz	#isdead

	WRSNDX	HDBUTT_L1,HDBUTT_L2

	SETMODE	NORMAL
	move	*a13(OBJ_YPOSINT),a14
	move	*a13(GROUND_Y),a0
	sub	a0,a14
	cmpi	20,a14
	jrge	#fall_back


	FACE24TBL head_hit2_tbl
	calla	change_anim1a
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



#*****************************************************************************
;AMODE_HDBUTT_STAY	44
;No xvel will happen
hit_hdbutt_stay
	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	callr	block_hit_flail
	rets

#noblock

	CALLA	CALL_FACE_HIT

;	calla	inc_burnout

	SETMODE	NORMAL

	WRSNDX	HDBUTT_L1,HDBUTT_L2

	FACE24TBL head_hit2_tbl
	calla	change_anim1a

	calla	wres_collis_off

	movi	6*60,a14
	move	a14,*a13(DELAY_METER)

	clr	a0
	move	a0,*a13(OBJ_XVEL),L

	rets

#*****************************************************************************
;AMODE_TOMB	33
hit_tomb

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	callr	block_hit_flail
	rets

#noblock

	CALLA	CALL_FACE_HIT

	GETLIFE
	jrz	#isdead

	calla	DO_SCREAM


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
;#isdead
;	calla	wres_collis_off
;	rets
;
;#not_dizzy

	move	*a13(PLYRMODE),a14
	cmpi	MODE_ONGROUND,a14
	jreq	#ongnd
	cmpi	MODE_DEAD,a14
	jreq	#ongnd



	SETMODE	NORMAL
	move	*a13(OBJ_YPOSINT),a14
	move	*a13(GROUND_Y),a0
	sub	a0,a14
	cmpi	20,a14
	jrge	#fall_back

	FACE24TBL head_hit2_tbl
	jruc	#anim

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


#ongnd	FACETBL	hitonground_tbl
#anim	calla	change_anim1a

#isdead
	calla	wres_collis_off

	rets

#*****************************************************************************
;AMODE_SUPER_KICK	48
hit_super_kick

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	callr	block_hit_flail
	rets

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
;	FACE24TBL body_hit_dizzy_tbl
;	calla	change_anim1a
;
;#isdead
;	calla	wres_collis_off
;	rets
;
;#not_dizzy
;
;	calla	inc_burnout

	SETMODE	NORMAL

	clr	a0
	move	a0,*a13(USR_VAR1)

	FACE24TBL body_hit_tbl
	calla	change_anim1a
#isdead
	calla	wres_collis_off
	rets


#*****************************************************************************
;AMODE_FLYKICK	3
 SUBR	hit_flykick


;Any hit mode which does a fall back sequence onto the ground
;will not check dizzy at the start.
;The check dizzy happens in the sequence.

	move	*a10(OBJ_XVEL),a0,L	;slow down doink's
	sra	1,a0		   	;x_vel after collis
	abs	a0
	cmpi	20000h,a0
	jrlt	#okv
	movi	40000h,a0
#okv
	move	*a10(OBJ_XVEL),a14,L
	jrn	#okv2
	neg	a0
#okv2
	move	a0,*a10(OBJ_XVEL),L
	movi	40000h,a0
	move	a0,*a10(OBJ_YVEL),L

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jrnz	#noblock

	callr	block_hit_flail
	setc				;return aborted
	rets

#noblock
	;HACK! - Lex's flying kicks don't knock you down.  Use CALL_MID_HIT.
	move	*a10(ANIBASE),a14,L
	cmpi	lex_flying_kick_anim,a14
	jreq	#midhit
	cmpi	lex_super_kick_anim,a14
	jreq	#midhit

	calla	CALL_DROP_KICK
	jruc	#snd_done
#midhit	calla	CALL_MID_HIT

#snd_done
	WRSNDX	FLYKICK_L1,FLYKICK_L2

	GETLIFE
	jrz	#skip


;	calla	inc_burnout

	SETMODE	NORMAL

#skip

;	move	*a10(OBJ_XVEL),a0,L	;slow down doink's
;	sra	1,a0		   	;x_vel after collis
;	abs	a0
;	cmpi	28000h,a0
;	jrlt	#okv
;	movi	28000h,a0
;#okv
;	move	*a10(OBJ_XVEL),a14,L
;	jrn	#okv2
;	neg	a0
;#okv2
;	move	a0,*a10(OBJ_XVEL),L
;	movi	40000h,a0
;	move	a0,*a10(OBJ_YVEL),L

	clr	a0
	move	a0,*a13(ROLL_POS)

;	move	*a13(PLYR_DIZZY),a0
;	jrnz	#diz

	calla	set_getup_time


;#diz
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
	clrc				;return okay
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

	callr	block_hit_flail
	rets

#noblock
	calla	CALL_DROP_KICK
	WRSNDX	FLYKICK_L1,FLYKICK_L2

	GETLIFE
	jrz	#skip


;	calla	inc_burnout

	SETMODE	NORMAL

#skip
;	move	*a10(OBJ_XVEL),a0,L	;slow down doink's
;	sra	1,a0		   	;x_vel after collis
;	neg	a0
;	move	a0,*a10(OBJ_XVEL),L
;	movi	40000h,a0
;	move	a0,*a10(OBJ_YVEL),L

	clr	a0
	move	a0,*a13(ROLL_POS)

;	move	*a13(PLYR_DIZZY),a0
;	jrnz	#diz

	calla	set_getup_time

;#diz
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


	WRSNDX	FLYKICK_L1,FLYKICK_L2

	FACETBL fall_back_tbukl_tbl
	calla	change_anim1a

	SETMODE	INAIR

	;set the DEAD_ANIM bit so that if this hit killed us, we won't
	; get the normal fall_back_anim instead.
	move	*a13(STATUS_FLAGS),a14
	ori	M_DEAD_ANIM,a14
	move	a14,*a13(STATUS_FLAGS)

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
	.word	D_PUNCH,	RD_PUNCH	;AMODE_PUNCH	
	.word	D_HDBUTT,	RD_HDBUTT	;AMODE_HDBUTT	
	.word	D_KICK,		RD_KICK		;AMODE_KICK	
	.word	D_FLYKICK,	RD_FLYKICK	;AMODE_FLYKICK	
	.word	D_GRABTHROW,	RD_GRABTHROW	;AMODE_GRABTHROW	

	.word	D_UPRCUT,	RD_UPRCUT	;AMODE_UPRCUT	
	.word	D_LBDROP,	RD_LBDROP	;AMODE_LBOWDROP	
	.word	D_GRBHOLD,	RD_GRBHOLD	;AMODE_GRABHOLD	
	.word	D_GRBFLNG,	RD_GRBFLNG	;AMODE_GRABFLING	
	.word	D_PUSH,		RD_PUSH		;AMODE_PUSH	

	.word	D_BCKHAND,	RD_BCKHAND	;AMODE_URN	
	.word	D_BIGBOOT,	RD_BIGBOOT	;AMODE_BIGBOOT	
	.word	D_KNEE,		RD_KNEE		;AMODE_KNEE	
	.word	D_HDKNEES,	RD_HDKNEES	;AMODE_HDBUTT2	
	.word	D_BOXPUNCH,	RD_BOXPUNCH	;AMODE_BOXPUNCH	

	.word	D_STOMP,	RD_STOMP	;AMODE_STOMP	
	.word	D_SPINKIK,	RD_SPINKIK	;AMODE_SPINKICK	
	.word	D_CLINE,	RD_CLINE	;AMODE_CLINE	
	.word	D_HEDHOLD,	RD_HEDHOLD	;AMODE_HEADHOLD	
	.word	D_JUMPKICK,	RD_JUMPKICK	;AMODE_JUMPKICK	

	.word	D_RUN,		RD_RUN		;AMODE_RUN	
	.word	D_PUPPET,	RD_PUPPET	;AMODE_PUPPET	
	.word	D_BCKHAND,	RD_BCKHAND	;AMODE_BACKHAND	
	.word	D_BUZZ,		RD_BUZZ		;AMODE_BUZZ	
	.word	D_HAYMAKER,	RD_HAYMAKER	;AMODE_HAYMAKER	

	.word	D_BLBDROP,	RD_BLBDROP	;AMODE_BLBOWDROP	
	.word	D_BSTOMP,	RD_BSTOMP	;AMODE_BSTOMP	
	.word	D_HDKNEES,	RD_HDKNEES	;AMODE_HEADKNEES	
	.word	D_EARSLAP2,	RD_EARSLAP2	;AMODE_EARSLAP	
	.word	D_HAMMER2,	RD_HAMMER2	;AMODE_HAMMER	

	.word	D_BUTTSTOMP,	RD_BUTTSTOMP	;AMODE_BUTTSTOMP	
	.word	D_ATT31,	RD_ATT31	;AMODE_PUPPET2	
	.word	D_ATT32,	RD_ATT32	;AMODE_HDGRAB
	.word	D_TOMB,		RD_TOMB		;AMODE_TOMB	
	.word	D_BIGKNEE,	RD_BIGKNEE	;AMODE_BIGKNEE	

	.word	D_FLPKIK,	RD_FLPKIK	;AMODE_SHNBFKIK	
	.word	D_SPDKIK,	RD_SPDKIK	;AMODE_SHNSPDKIK	
	.word	D_SPDKIK2,	RD_SPDKIK2	;AMODE_SHNSPDKIK2
	.word	D_HITCK,	RD_HITCK	;AMODE_HITCHECK	
	.word	D_ARMBRK,	RD_ARMBRK	;AMODE_ARMBREAK	

	.word	D_RSLASH,	RD_RSLASH	;AMODE_RSLASH	
	.word	D_HEADDSLASH,	RD_HEADDSLASH	;AMODE_HEADDSLASH
	.word	D_HEADUSLASH,	RD_HEADUSLASH	;AMODE_HEADUSLASH
	.word	D_RSLASH2,	RD_RSLASH2	;AMODE_RSLASH2	
	.word	D_HDBUTT_STAY,	RD_HDBUTT_STAY	;AMODE_HDBUTT_STAY

	.word	D_FIRE_PUNCH,	RD_FIRE_PUNCH	;AMODE_FIRE_PUNCH
	.word	D_BSTOMP2,	RD_BSTOMP2	;AMODE_BSTOMP2
	.word	D_GUTPUSH,	RD_GUTPUSH	;AMODE_GUTPUSH
	.word	D_SPINKIK,	RD_SPINKIK	;AMODE_SUPER_KICK
	.word	D_PUNCH2,	RD_PUNCH2	;AMODE_PUNCH2

	.word	D_BCKHAND,	RD_BCKHAND	;AMODE_HDBUTT3
	.word	D_LBDROP2,	RD_LBDROP2	;AMODE_LBOWDROP2
	.word	D_STOMP2,	RD_STOMP2	;AMODE_STOMP2
	.word	0,		0		;AMODE_NOFLAIL
	.word	0,		0		;AMODE_TOSS
	.word	D_NAPALM,	RD_NAPALM	;AMODE_NAPALM

;Wrestler offensive multipliers
offense_mods
	.word	_35PCT	;Bret
	.word	_35PCT	;Razor
	.word	_35PCT	;Taker
	.word	_35PCT	;Yoko
	.word	_35PCT	;Shawn
	.word	_35PCT	;Bam Bam
	.word	_35PCT	;Doink
	.word	_35PCT	;
	.word	_35PCT	;Lex

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

******************************************************************************
*
* STANDARD REACTION TABLES
*

 SUBR	head_hit_tbl
	.long	hrt_2_head_hit_anim,hrt_4_head_hit_anim			;0 Bret Hart
	.long	rzr_2_head_hit_anim,rzr_4_head_hit_anim			;1 Razor Ramon
	.long	und_2_head_hit_anim,und_4_head_hit_anim			;2 Undertaker
	.long	yok_2_head_hit_anim,yok_4_head_hit_anim			;3 Yokozuna
	.long	shn_2_head_hit_anim,shn_4_head_hit_anim			;4 Shawn Michaels
	.long	bam_2_head_hit_anim,bam_4_head_hit_anim			;5 Bam Bam
	.long	dnk_2_head_hit_anim,dnk_4_head_hit_anim			;6 Doink
	.long	0,0							;7 spare
	.long	lex_2_head_hit_anim,lex_4_head_hit_anim			;8 Lex Luger


 SUBR	head_hit2_tbl
	.long	hrt_2_head_hit2_anim,hrt_4_head_hit2_anim		;0 Bret Hart
	.long	rzr_2_head_hit2_anim,rzr_4_head_hit2_anim		;1 Razor Ramon
	.long	und_head_hit2_anim,und_head_hit2_anim			;2 Undertaker
	.long	yok_2_head_hit2_anim,yok_4_head_hit2_anim		;3 Yokozuna
	.long	shn_2_head_hit2_anim,shn_4_head_hit2_anim		;4 Shawn Michaels
	.long	bam_head_hit2_anim,bam_head_hit2_anim			;5 Bam Bam
	.long	dnk_head_hit2_anim,dnk_head_hit2_anim			;6 Doink
	.long	0,0							;7 spare
	.long	lex_2_head_hit2_anim,lex_4_head_hit2_anim		;8 Lex Luger

 SUBR	head_hit2_sand_tbl
	REFLONG	hrt_4_head_hit2s_anim
	REFLONG	rzr_4_head_hit2s_anim
	REFLONG	und_head_hit2s_anim  
	REFLONG	yok_4_head_hit2s_anim
	REFLONG	shn_4_head_hit2s_anim
	REFLONG	bam_head_hit2s_anim  
	REFLONG	dnk_head_hit2s_anim  
	.long	0
	REFLONG	lex_4_head_hit2s_anim

 SUBR	head_hit_dizzy_tbl
	.long	hrt_4_head_hit_dizzy_anim,hrt_4_head_hit_dizzy_anim	;0 Bret Hart
	.long	rzr_4_head_hit_dizzy_anim,rzr_4_head_hit_dizzy_anim	;1 Razor Ramon
	.long	und_head_hit_dizzy_anim,und_head_hit_dizzy_anim		;2 Undertaker
	.long	yok_4_head_hit_dizzy_anim,yok_4_head_hit_dizzy_anim	;3 Yokozuna
	.long	shn_4_head_hit_dizzy_anim,shn_4_head_hit_dizzy_anim	;4 Shawn Michaels
	.long	bam_head_hit_dizzy_anim,bam_head_hit_dizzy_anim		;5 Bam Bam
	.long	dnk_head_hit_dizzy_anim,dnk_head_hit_dizzy_anim		;6 Doink
	.long	0,0							;7 spare
	.long	lex_head_hit_dizzy_anim,lex_head_hit_dizzy_anim		;8 Lex Luger

 SUBR	body_hit_tbl
	.long	hrt_2_body_hit_anim,hrt_4_body_hit_anim			;0 Bret Hart
	.long	rzr_2_body_hit_anim,rzr_4_body_hit_anim			;1 Razor Ramon
	.long	und_2_body_hit_anim,und_4_body_hit_anim			;2 Undertaker
	.long	yok_2_body_hit_anim,yok_4_body_hit_anim			;3 Yokozuna
	.long	shn_2_body_hit_anim,shn_4_body_hit_anim			;4 Shawn Michaels
	.long	bam_2_body_hit_anim,bam_4_body_hit_anim			;5 Bam Bam
	.long	dnk_4_body_hit_anim,dnk_4_body_hit_anim			;6 Doink
	.long	0,0							;7 spare
	.long	lex_2_body_hit_anim,lex_4_body_hit_anim			;8 Lex Luger

 SUBR	body_hit2_tbl
	.long	hrt_4_body_hit_anim			;0 Bret Hart
	.long	rzr_4_body_hit_anim			;1 Razor Ramon
	.long	und_4_body_hit_anim			;2 Undertaker
	.long	yok_4_body_hit_anim			;3 Yokozuna
	.long	shn_4_body_hit_anim			;4 Shawn Michaels
	.long	bam_4_body_hit_anim			;5 Bam Bam
	.long	dnk_4_body_hit_anim			;6 Doink
	.long	0							;7 spare
	.long	lex_4_body_hit_anim			;8 Lex Luger

 SUBR	body_hit_dizzy_tbl
	.long	hrt_4_body_hit_dizzy_anim,hrt_4_body_hit_dizzy_anim	;0 Bret Hart
	.long	rzr_4_body_hit_dizzy_anim,rzr_4_body_hit_dizzy_anim	;1 Razor Ramon
	.long	und_4_body_hit_dizzy_anim,und_4_body_hit_dizzy_anim	;2 Undertaker
	.long	yok_4_body_hit_dizzy_anim,yok_4_body_hit_dizzy_anim	;3 Yokozuna
	.long	shn_4_body_hit_dizzy_anim,shn_4_body_hit_dizzy_anim	;4 Shawn Michaels
	.long	bam_4_body_hit_dizzy_anim,bam_4_body_hit_dizzy_anim	;5 Bam Bam
	.long	dnk_4_body_hit_dizzy_anim,dnk_4_body_hit_dizzy_anim	;6 Doink
	.long	0,0							;7 spare
	.long	lex_4_body_hit_dizzy_anim,lex_4_body_hit_dizzy_anim	;8 Lex Luger

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

hitblock_tbl
	.long	hrt_4_hitblock_anim	;0 Bret Hart
	.long	rzr_4_hitblock_anim	;1 Razor Ramon
	.long	und_4_hitblock_anim	;2 Undertaker
	.long	yok_4_hitblock_anim	;3 Yokozuna
	.long	shn_4_hitblock_anim	;4 Shawn Michaels
	.long	bam_4_hitblock_anim	;5 Bam Bam
	.long	dnk_4_hitblock_anim	;6 Doink
	.long	0		   	;7 spare
	.long	lex_4_hitblock_anim	;8 Lex Luger

hitblock_flail_tbl
	REFLONG	hrt_4_hitblock2_anim	;0 Bret Hart
	REFLONG	rzr_4_hitblock2_anim	;1 Razor Ramon
	REFLONG	und_4_hitblock2_anim	;2 Undertaker
	REFLONG	yok_4_hitblock2_anim	;3 Yokozuna
	REFLONG	shn_4_hitblock2_anim	;4 Shawn Michaels
	REFLONG	bam_4_hitblock2_anim	;5 Bam Bam
	REFLONG	dnk_4_hitblock2_anim	;6 Doink
	.long	0		   	;7 spare
	REFLONG	lex_4_hitblock2_anim	;8 Lex Luger

;	.long	hrt_4_losebal_anim	;0 Bret Hart
;	.long	rzr_4_losebal_anim	;1 Razor Ramon
;	.long	und_4_losebal_anim	;2 Undertaker
;	.long	yok_4_losebal_anim	;3 Yokozuna
;	.long	shn_4_losebal_anim	;4 Shawn Michaels
;	.long	bam_4_losebal_anim	;5 Bam Bam
;	.long	dnk_4_losebal_anim	;6 Doink
;	.long	dnk_4_losebal_anim	;7 spare
;	.long	lex_4_losebal_anim	;8 Lex Luger
;	.long	dnk_4_losebal_anim	;9 Referee

 SUBR	hitonground_tbl
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
*
* Script for a wrestler who was the victim of a puppet sequence that got
* interrupted by the attacker being smacked.

 SUBR	xxx_aborted_attach_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETSPEED,100h

	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_SETMODE,MODE_NORMAL

	;WAIT!  If I'm dead, just do a hitonground instead.
	WL	ANI_CODE,#dead_or_dying
	WL	ANI_IFSTATUS,#dead
	WL	ANI_CHANGEANIM_TBL,#getup_tbl
#dead	WL	ANI_CHANGEANIM_TBL,hitonground_tbl

#getup_tbl
	REFLONG	hrt_faceup_getup_anim
	REFLONG	rzr_faceup_getup_anim
	REFLONG	und_faceup_getup_anim
	REFLONG	yok_faceup_getup_anim
	REFLONG	shn_faceup_getup_anim
	REFLONG	bam_faceup_getup_anim
	REFLONG	dnk_faceup_getup_anim
	.long	0
	REFLONG	lex_faceup_getup_anim


 SUBRP	#dead_or_dying

	;set status if I'm dead or my I_WILL_DIE flag is set.
	move	*a13(ANIMODE),a14
	andni	MODE_STATUS,a14
	move	a14,*a13(ANIMODE)

	move	*a13(I_WILL_DIE),a14
	jrnz	#die

	move	*a13(PLYRNUM),a1
	calla	get_health
	jrnz	#ok

#die	move	*a13(ANIMODE),a14
	ori	MODE_STATUS,a14
	move	a14,*a13(ANIMODE)

#ok	rets

#*****************************************************************************
*
* Script for a wrestler who was the victim of a puppet sequence that got
* interrupted by the attacker being smacked.  - go to stand instead of
* falling.

 SUBR	xxx_goto_stand_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETSPEED,100h

	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

******************************************************************************

	.end
