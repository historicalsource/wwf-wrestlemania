**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		5/20/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"wrestle2.asm"
	.title	"wrestling game program cont..."
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"macros.h"
	.include	"mproc.equ"		;Mproc equates
	.include	"display.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"sys.equ"
	.include	"game.equ"
	.include	"audit.equ"
	.include	"plyr.equ"
	.include	"anim.equ"
	.include	"sound.h"
	.include	"sound.equ"
	.include	"ring.equ"

	.include	"imgtbl.glo"
	.include	"fontsimg.glo"
	.include	"bgndtbl.glo"
	.include	"miscimg.glo"
	.include	"jjxm.h"

	;temp! - 314
	.if DEBUG
	.include	"tmpdebug.h"
	.endif

******************************************************************************
* EXTERNAL REFERENCES

	.ref	PSTATUS,triple_sound,change_anim1a,set_rotate_anim
	.ref	get_rope_x,round_tickcount,get_process_ptr,NUM_OPPS
	.ref	PALFRAM,HALT,dma_bog,GAMSTATE,pal_getf,process_ptrs
	.ref	change_anim2a,announce_rnd_winner,GET_ADJ,pin_prompt
	.ref	change_image,match_time,is_final_match,is_8_on_1
	.ref	ADD_VOICE,p1oldwinstreak,match_winner,RNDRNG0

	.ref	calc_line_x,PCNT,drone_meters_on,FINAL_PTR
	.ref	dnk_climbthru_side_anim,dnk_climbthru_bot_anim
	.ref	dnk_climbthru_top_anim,dnk_climbin_bot_anim
	.ref	dnk_climbin_top_anim,dnk_climbin_side_anim
	.ref	get_opp_process,adjust_health,init_wres_life_data
	.ref	HRTPNK_P,HRTBLU_P,UNDBLK_P,DNKPRP_P,YOKPRP_P
	.ref	LEXPRP_P,RZRPRP_P,BAMYLW_P,SHNPRP_P

	.ref	wrestler_x,wrestler_y,wrestler_z,index1,index2

	.ref	dnk_climb_up_anim,shn_climb_up_anim,bam_climb_up_anim
	.ref	hrt_climb_up_anim,lex_climb_up_anim,und_climb_up_anim
	.ref	yok_climb_up_anim,rzr_climb_up_anim

	.ref	bam_climbin_side_anim,bam_climbthru_side_anim
	.ref	bam_climbin_top_anim,bam_climbthru_top_anim
	.ref	bam_climbin_bot_anim,bam_climbthru_bot_anim
	.ref	und_climbin_side_anim,und_climbthru_side_anim
	.ref	und_climbin_top_anim,und_climbthru_top_anim
	.ref	und_climbin_bot_anim,und_climbthru_bot_anim
	.ref	rzr_climbin_side_anim,rzr_climbthru_side_anim
	.ref	rzr_climbin_top_anim,rzr_climbthru_top_anim
	.ref	rzr_climbin_bot_anim,rzr_climbthru_bot_anim
	.ref	hrt_climbin_side_anim,hrt_climbthru_side_anim
	.ref	hrt_climbin_top_anim,hrt_climbthru_top_anim
	.ref	hrt_climbin_bot_anim,hrt_climbthru_bot_anim
	.ref	yok_climbin_side_anim,yok_climbthru_side_anim
	.ref	yok_climbin_top_anim,yok_climbthru_top_anim
	.ref	yok_climbin_bot_anim,yok_climbthru_bot_anim
	.ref	lex_climbin_side_anim,lex_climbthru_side_anim
	.ref	lex_climbin_top_anim,lex_climbthru_top_anim
	.ref	lex_climbin_bot_anim,lex_climbthru_bot_anim
	.ref	shn_climbin_side_anim,shn_climbthru_side_anim
	.ref	shn_climbin_top_anim,shn_climbthru_top_anim
	.ref	shn_climbin_bot_anim,shn_climbthru_bot_anim
	.ref	switches_cur,switches_down,switches_up
	.ref	dufus_msg_off,get_rnd_wrestler,royal_rumble
	.ref	START_HI_FLASHES,wrestler_count,buddy_mode_on
	.ref	reduce_bog,player_pal_pref,crowd_process
	.ref	wrestler_count,wrestler_count_proc,get_opp_plyrmode
	.ref	THIS_GAME_TIME,STORE_AUDIT,GET_AUD,CURRENT_LADDER
	.ref	AUD,match_start_time,PSTARTS,match_realtime
	.ref	wrestler_audits,current_round,AUD1

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

#******************************************************************************
*
* a13 = * wrestler process
* a0  = stick_val_cur

 SUBR	climb_turnbuckle

	move	a0,a4

	btst	MOVE_UP_BIT,a4		;check if player should climb
	jrz	#not_top		;up the turnbuckle

	move	*a13(INRING),a0
	jrnz	#no_climb

	move	*a13(OBJ_ZPOSINT),a0
	cmpi	RING_TOP+5,a0		;give 'em 5 pixels of leeway
	jrgt	#not_top


	move	*a13(OBJ_XPOSINT),a0
	cmpi	RING_X_CENTER,a0
	jrgt	#right
;#left
	calla	get_rope_x
	move	*a13(OBJ_COLLX1),a1
	subk	5,a1			;give 'em 5
	cmp	a0,a1			;a1-a0
	jrgt	#no_climb

	movk	MOVE_UP_LEFT,a3		;face top left turnbuckle
	cmp	a3,a4			;Make sure UP/LEFT is pressed
	jreq	#climbit
	jruc	#no_climb

#right
	calla	get_rope_x
	move	*a13(OBJ_COLLX2),a1
	addk	5,a1			;give 'em 5
	cmp	a0,a1			;a1-a0
	jrlt	#no_climb

	movk	MOVE_UP_RIGHT,a3	;face top right turnbuckle
	cmp	a3,a4			;Make sure UP/RIGHT is pressed
	jrne	#no_climb


#climbit

;If anybody is already on turnbuckles, ignore this
	movi	process_ptrs,a4
	movi	NUM_WRES,a5

#loop	move	*a4+,a0,L
	jrz	#nxt			;skip inactive

	move	*a0(PLYRMODE),a14
	cmpi	MODE_ONTURNBKL,a14
	jrz	#found_climber
	cmpi	MODE_CLIMBTURNBKL,a14
	jrz	#found_climber
	jruc	#nxt

#found_climber
	;check to see if we're trying to climb the one he's on
	move	*a13(OBJ_XPOSINT),a14
	move	*a0(OBJ_XPOSINT),a10
	cmpi	RING_X_CENTER,a14
	jrgt	#ck_rt

	;left tbukl
	cmpi	RING_X_CENTER,a10
	jrlt	#no_climb
	jruc	#nxt

#ck_rt	;right tbukl
	cmpi	RING_X_CENTER,a10
	jrgt	#no_climb

#nxt	dsj	a5,#loop


	;we're going to climb - because we allow 'near misses' to climb,
	; we may have to glitch the guy to the corner.  do it here.
	movi	RING_TOP,a14
	move	a14,*a13(OBJ_ZPOSINT)

	move	*a13(WRESTLERNUM),a0
	X16	a0
	addi	#face_turnbuckle,a0
	move	*a0,a0				;flip facing?
	jrz	#no_flip
	xori	MOVE_UP|MOVE_DOWN|MOVE_LEFT|MOVE_RIGHT,a3	;opposite
#no_flip
	move	a3,*a13(NEW_FACING_DIR)
	move	*a13(FACING_DIR),a0
	cmp	a0,a3
	jreq	#climb
	calla	set_rotate_anim
	calla	change_anim1a

	movi	#climb,a0			;this routine gets executed
	move	a0,*a13(CODE_ADDR),L		;when the rotate anim
	SETMODE	WAITANIM			;finishes

	setc
	rets

#climb
	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	#climb_anims,a0
	move	*a0,a0,L
	calla	change_anim1a

	SETMODE	CLIMBTURNBKL

	setc
	rets

#not_top
#no_climb
	clrc
	rets

;0 = face turnbuckle before climb
;1 = back to turnbuckle
#face_turnbuckle
	.word	1	;0 Bret Hart
	.word	1	;1 Razor Ramon
	.word	1	;2 Undertaker
	.word	0	;3 Yokozuna
	.word	0	;4 Shawn Michaels
	.word	1	;5 Bam Bam
	.word	0	;6 Doink
	.word	0	;7 Adam Bomb
	.word	1	;8 Lex Luger
	.word	0	;9 Referee


#climb_anims
	.long	hrt_climb_up_anim	;0 Bret Hart
	.long	rzr_climb_up_anim	;1 Razor Ramon
	.long	und_climb_up_anim	;2 Undertaker
	.long	yok_climb_up_anim	;3 Yokozuna
	.long	shn_climb_up_anim	;4 Shawn Michaels
	.long	bam_climb_up_anim	;5 Bam Bam
	.long	dnk_climb_up_anim	;6 Doink
	.long	dnk_climb_up_anim	;7 Adam Bomb
	.long	lex_climb_up_anim	;8 Lex Luger
	.long	dnk_climb_up_anim	;9 Referee

#*****************************************************************************
*
* CLIMB-INS/OUTS
*

 SUBR	ck_climb_out_bot

	move	*a13(PLYRMODE),a14
	cmpi	MODE_ATTACHED,a14
	jreq	#done
	cmpi	MODE_RUNNING,a14
	jreq	#done
	cmpi	MODE_OPPOVERHEAD,a14
	jreq	#done

;	calla	get_opp_process
;	move	*a0(INRING),a0
;	jrz	#done
	callr	any_opp_outside
	jrnc	#done

	;Far enough away from posts?
	move	*a13(OBJ_XPOSINT),a0
	subi	RING_X_CENTER,a0
	abs	a0
	cmpi	10Dh,a0
	jrgt	#done

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#done

	;make sure we're at the bottom edge of the ring.
	move	*a13(OBJ_ZPOS),a0,L
	cmpi	[RING_BOT,0],a0
	jrne	#done

	;dummy check
	callr	idiot_check
	jrc	#climb

	;button press
	move	*a13(BUT_VAL_CUR),a0
	move	a0,a0
	jrz	#done

#climb	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	climbthru_bot_anims,a0
	move	*a0,a0,L
	calla	change_anim1a
	movk	2,a0
	move	a0,*a13(CLIMBING_THRU)

#done	rets


#********
 SUBR	ck_climb_in_top

	move	*a13(PLYRMODE),a14
	cmpi	MODE_ATTACHED,a14
	jreq	#done
	cmpi	MODE_DEAD,a14
	jreq	#done
	cmpi	MODE_RUNNING,a14
	jreq	#done
	cmpi	MODE_INAIR,a14
	jreq	#done
	cmpi	MODE_INAIR2,a14
	jreq	#done
	cmpi	MODE_OPPOVERHEAD,a14
	jreq	#done

	move	*a13(CLIMBING_THRU),a0		;1=Climbing thru ropes flag
	jrnz	#done

	move	*a13(OBJ_XPOSINT),a0
	subi	RING_X_CENTER,a0
	abs	a0
;Far enough away from posts?
	cmpi	0C0h,a0		;48h
	jrgt	#done

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#done

	;make sure we're at the top edge of the mat.
	move	*a13(OBJ_ZPOS),a0,L
	cmpi	[MAT_TOP-5,0],a0
	jrne	#done
	move	*a13(MOVE_DIR),a0
	btst	MOVE_DOWN_BIT,a0
	jrz	#done

	callr	idiot_check
	jrc	#climb

	move	*a13(BUT_VAL_CUR),a0
	move	a0,a0
	jrz	#done

#climb	

	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	climbin_top_anims,a0
	move	*a0,a0,L
	calla	change_anim1a
	movk	2,a0
	move	a0,*a13(CLIMBING_THRU)

#done	rets


#********
 SUBR	ck_climb_out_top

	;roll right on through if we're a zombie.
	move	*a13(STATUS_FLAGS),a14
	btst	B_ZOMBIE,a14
	jrnz	#zombie

	move	*a13(PLYRMODE),a14
	cmpi	MODE_ATTACHED,a14
	jreq	#done
	cmpi	MODE_RUNNING,a14
	jreq	#done
	cmpi	MODE_OPPOVERHEAD,a14
	jreq	#done

;	calla	get_opp_process
;	move	*a0(INRING),a0
;	jrz	#done
	callr	any_opp_outside
	jrnc	#done

	;Far enough away from posts?
	move	*a13(OBJ_XPOSINT),a0
	subi	RING_X_CENTER,a0
	abs	a0
	cmpi	0C0h,a0
	jrgt	#done

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#done

	;make sure we're at the top edge of the ring.
	move	*a13(OBJ_ZPOS),a0,L
	cmpi	[RING_TOP,0],a0
	jrne	#done

	;dummy check
	callr	idiot_check
	jrc	#climb

	;button press
	move	*a13(BUT_VAL_CUR),a0
	move	a0,a0
	jrz	#done

#climb	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	climbthru_top_anims,a0
	move	*a0,a0,L
	calla	change_anim1a
	movk	2,a0
	move	a0,*a13(CLIMBING_THRU)

#done	rets

#zombie	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	rollthru_top_anims,a0
	move	*a0,a0,L

	move	*a13(ANIBASE),a14,L
	cmp	a0,a14
	jreq	#skp			;skip if we're already doing it.
	calla	change_anim1a
	movk	2,a0
	move	a0,*a13(CLIMBING_THRU)
#skp	rets


#********
 SUBR	ck_climb_in_bot

	move	*a13(PLYRMODE),a14
	cmpi	MODE_ATTACHED,a14
	jreq	#done
	cmpi	MODE_DEAD,a14
	jreq	#done
	cmpi	MODE_RUNNING,a14
	jreq	#done
	cmpi	MODE_INAIR,a14
	jreq	#done
	cmpi	MODE_INAIR2,a14
	jreq	#done
	cmpi	MODE_OPPOVERHEAD,a14
	jreq	#done

	move	*a13(CLIMBING_THRU),a0		;1=Climbing thru ropes flag
	jrnz	#done

	;Far enough away from posts?
	move	*a13(OBJ_XPOSINT),a0
	subi	RING_X_CENTER,a0
	abs	a0
	cmpi	10Dh,a0
	jrgt	#done

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#done

	;make sure we're up against the bottom of the ring
	move	*a13(OBJ_ZPOS),a0,L
	cmpi	[MAT_BOT+5,0],a0
	jrne	#done

	move	*a13(MOVE_DIR),a0
	btst	MOVE_UP_BIT,a0
	jrz	#done

	;dummy check
	callr	idiot_check
	jrc	#climb

	;button press
	move	*a13(BUT_VAL_CUR),a0
	move	a0,a0
	jrz	#done

#climb  

	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	climbin_bot_anims,a0
	move	*a0,a0,L
	calla	change_anim1a
	movk	2,a0
	move	a0,*a13(CLIMBING_THRU)

#done	rets

#********
 SUBR	ck_climb_out_side

	move	*a13(PLYRMODE),a14
	cmpi	MODE_ATTACHED,a14
	jreq	#done
	cmpi	MODE_RUNNING,a14
	jreq	#done
	cmpi	MODE_OPPOVERHEAD,a14
	jreq	#done

;	calla	get_opp_process
;	move	*a0(INRING),a1
;	jrz	#done
	callr	any_opp_outside
	jrnc	#done
	move	*a0(CLIMBING_THRU),a0
	CMPI	1,A0
	JREQ	#done

	;Far enough away from posts?
	move	*a13(OBJ_ZPOSINT),a0
	subi	RING_Z_CENTER,a0
	abs	a0
	cmpi	48h,a0
	jrgt	#done

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#done

	;make sure we're up against one of the sides
	calla	get_rope_x
	move	a0,a4
	cmpi	RING_X_CENTER,a0
	jrgt	#rt

#lf	move	*a13(STICK_VAL_CUR),a0
	btst	MOVE_LEFT_BIT,a0
	jrz	#done

	move	a4,a0
	move	*a13(OBJ_COLLX1),a1
	cmp	a0,a1
	jrle	#out_lf
	jruc	#done

#rt	move	*a13(STICK_VAL_CUR),a0
	btst	MOVE_RIGHT_BIT,a0
	jrz	#done

	move	a4,a0
	move	*a13(OBJ_COLLX2),a1
	cmp	a0,a1
	jrge	#out_rt
	jruc	#done

#out_lf	movk	MOVE_DOWN_LEFT,a2
	jruc	#dummy

#out_rt	movk	MOVE_DOWN_RIGHT,a2

#dummy	;dummy check
	callr	idiot_check
	jrc	#special_face

	;button press
	move	*a13(BUT_VAL_CUR),a0
	move	a0,a0
	jrz	#done

#face	move	*a13(FACING_DIR),a1
	cmp	a2,a1
	jreq	#climb

	move	a2,*a13(NEW_FACING_DIR)
	calla	set_rotate_anim
	calla	change_anim1a

	movi	#climb,a0
	move	a0,*a13(CODE_ADDR),L
	SETMODE	WAITANIM
	movk	1,a0
	move	a0,*a13(CLIMBING_THRU)
	rets

#climb	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	climbthru_side_anims,a0
	move	*a0,a0,L
	calla	change_anim1a

	SETMODE	NORMAL

	movk	1,a0
	move	a0,*a13(CLIMBING_THRU)
#done	rets

#special_face
	move	*a13(PLYRMODE),A1
	CMPI	MODE_WAITANIM,a1
	JREQ	#done
	jruc	#face

#********
 SUBR	ck_climb_in_side

	move	*a13(PLYRMODE),a14
	cmpi	MODE_ATTACHED,a14
	jreq	#done
	cmpi	MODE_DEAD,a14
	jreq	#done
	cmpi	MODE_OPPOVERHEAD,a14
	jreq	#done

	move	*a13(CLIMBING_THRU),a0		;1=Climbing thru ropes flag
	jrnz	#done

;Far enough away from posts?
	move	*a13(OBJ_ZPOSINT),a0
	subi	RING_Z_CENTER,a0
	abs	a0
	cmpi	0D8h,a0
	jrgt	#done

	;is he close enough to the ring?
	move	*a13(OBJ_XPOSINT),a0
	cmpi	RING_X_CENTER,a0
	jrlt	#on_left

	;he's right of center
	movk	MOVE_LEFT_BIT,A2
	movi	vln_right_matedge2,a6
	movk	MOVE_DOWN_LEFT,a7
	move	*a13(OBJ_COLLX1),a14
	jruc	#d_set

#on_left
	;he's left of center
	movk	MOVE_RIGHT_BIT,A2
	movi	vln_left_matedge2,a6
	movk	MOVE_DOWN_RIGHT,a7
	move	*a13(OBJ_COLLX2),a14

#d_set

	move	*a13(PLYRMODE),a0
	cmpi	MODE_RUNNING,a0
	jrne	no_special_check

	move	*a13(GETUP_TIME),a0
	jrnz	#done

	jruc	running_back_in_here

no_special_check
	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#done

	move	*a13(PLYRMODE),a0
	cmpi	MODE_HEADHELD,a0
	jreq	#done
	cmpi	MODE_HEADHOLD,a0
	jreq	#done
	cmpi	MODE_INAIR,a0
	jreq	#done
	cmpi	MODE_INAIR2,a0
	jreq	#done

running_back_in_here
	calla	calc_line_x
	sub	a14,a0
	abs	a0
	cmpi	10,a0
	jrgt	#done

	move	*a13(MOVE_DIR),a0
	btst	A2,a0
	jrz	#done

	;idiot check
	callr	idiot_check
	jrc	#climb

	move	*a13(PLYRMODE),a0
	cmpi	MODE_RUNNING,a0
	jrz	#climb

	;button press
	move	*a13(BUT_VAL_CUR),a0
	move	a0,a0
	jrz	#done

#climb	;he's within five pixels of his mat edge.  face the ring
	move	*a13(FACING_DIR),a1
	cmp	a7,a1
	jreq	#jump_in

	move	a7,*a13(NEW_FACING_DIR)
	calla	set_rotate_anim
	calla	change_anim1a

	movi	#jump_in,a0
	move	a0,*a13(CODE_ADDR),L
	SETMODE	WAITANIM
	movk	1,a0
	move	a0,*a13(CLIMBING_THRU)
	rets

#jump_in
	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	climbin_side_anims,a0
	move	*a0,a0,L
	calla	change_anim1a

	SETMODE	NORMAL
	movk	1,a0
	move	a0,*a13(CLIMBING_THRU)

#done	rets

climbthru_bot_anims
	.long	hrt_climbthru_bot_anim	;0 Bret Hart
	.long	rzr_climbthru_bot_anim	;1 Razor Ramon
	.long	und_climbthru_bot_anim	;2 Undertaker
	.long	yok_climbthru_bot_anim	;3 Yokozuna
	.long	shn_climbthru_bot_anim	;4 Shawn Michaels
	.long	bam_climbthru_bot_anim	;5 Bam Bam
	.long	dnk_climbthru_bot_anim	;6 Doink
	.long	dnk_climbthru_bot_anim	;7 Adam Bomb
	.long	lex_climbthru_bot_anim	;8 Lex Luger
	.long	dnk_climbthru_bot_anim	;9 Referee

climbthru_top_anims
	.long	hrt_climbthru_top_anim	;0 Bret Hart
	.long	rzr_climbthru_top_anim	;1 Razor Ramon
	.long	und_climbthru_top_anim	;2 Undertaker
	.long	yok_climbthru_top_anim	;3 Yokozuna
	.long	shn_climbthru_top_anim	;4 Shawn Michaels
	.long	bam_climbthru_top_anim	;5 Bam Bam
	.long	dnk_climbthru_top_anim	;6 Doink
	.long	dnk_climbthru_top_anim	;7 Adam Bomb
	.long	lex_climbthru_top_anim	;8 Lex Luger
	.long	dnk_climbthru_top_anim	;9 Referee

climbin_bot_anims
	.long	hrt_climbin_bot_anim	;0 Bret Hart
	.long	rzr_climbin_bot_anim	;1 Razor Ramon
	.long	und_climbin_bot_anim	;2 Undertaker
	.long	yok_climbin_bot_anim	;3 Yokozuna
	.long	shn_climbin_bot_anim	;4 Shawn Michaels
	.long	bam_climbin_bot_anim	;5 Bam Bam
	.long	dnk_climbin_bot_anim	;6 Doink
	.long	dnk_climbin_bot_anim	;7 Adam Bomb
	.long	lex_climbin_bot_anim	;8 Lex Luger
	.long	dnk_climbin_bot_anim	;9 Referee

climbin_top_anims
	.long	hrt_climbin_top_anim	;0 Bret Hart
	.long	rzr_climbin_top_anim	;1 Razor Ramon
	.long	und_climbin_top_anim	;2 Undertaker
	.long	yok_climbin_top_anim	;3 Yokozuna
	.long	shn_climbin_top_anim	;4 Shawn Michaels
	.long	bam_climbin_top_anim	;5 Bam Bam
	.long	dnk_climbin_top_anim	;6 Doink
	.long	dnk_climbin_top_anim	;7 Adam Bomb
	.long	lex_climbin_top_anim	;8 Lex Luger
	.long	dnk_climbin_top_anim	;9 Referee

climbthru_side_anims
	.long	hrt_climbthru_side_anim	;0 Bret Hart
	.long	rzr_climbthru_side_anim	;1 Razor Ramon
	.long	und_climbthru_side_anim	;2 Undertaker
	.long	yok_climbthru_side_anim	;3 Yokozuna
	.long	shn_climbthru_side_anim	;4 Shawn Michaels
	.long	bam_climbthru_side_anim	;5 Bam Bam
	.long	dnk_climbthru_side_anim	;6 Doink
	.long	dnk_climbthru_side_anim	;7 Adam Bomb
	.long	lex_climbthru_side_anim	;8 Lex Luger
	.long	dnk_climbthru_side_anim	;9 Referee

climbin_side_anims
	.long	hrt_climbin_side_anim	;0 Bret Hart
	.long	rzr_climbin_side_anim	;1 Razor Ramon
	.long	und_climbin_side_anim	;2 Undertaker
	.long	yok_climbin_side_anim	;3 Yokozuna
	.long	shn_climbin_side_anim	;4 Shawn Michaels
	.long	bam_climbin_side_anim	;5 Bam Bam
	.long	dnk_climbin_side_anim	;6 Doink
	.long	dnk_climbin_side_anim	;7 Adam Bomb
	.long	lex_climbin_side_anim	;8 Lex Luger
	.long	dnk_climbin_side_anim	;9 Referee

rollthru_top_anims
	REFLONG	hrt_rollthru_top_anim	;0 Bret Hart
	REFLONG	rzr_rollthru_top_anim	;1 Razor Ramon
	REFLONG	und_rollthru_top_anim	;2 Undertaker
	REFLONG	yok_rollthru_top_anim	;3 Yokozuna
	REFLONG	shn_rollthru_top_anim	;4 Shawn Michaels
	REFLONG	bam_rollthru_top_anim	;5 Bam Bam
	REFLONG	dnk_rollthru_top_anim	;6 Doink
	.long	0			;7 unused
	REFLONG	lex_rollthru_top_anim	;8 Lex Luger


#*****************************************************************************
*
* Updates CLIMB_START and CLIMB_LAST, and returns carry if it's time to
* climb.  Note that we can't count on idiot_check being called only once
* per tick.  As of this writing (28 Feb) it's at least two, and sometimes
* three.  If CLIMB_LAST == PCNT, quit.  If CLIMB_LAST == PCNT - 1, set
* CLIMB_LAST = PCNT, and compare CLIMB_LAST - CLIMB_START against
* IDIOT_COUNT. On GE, setc and return, else clrc and return.  If CLIMB_LAST
* isn't PCNT or PCNT-1, set it and CLIMB_START to PCNT, clrc, and rets.
*		

#IDIOT_COUNT	.equ	21

 SUBRP	idiot_check

	move	*a13(CLIMB_LAST),a14
	move	@PCNT,a0
	cmp	a0,a14
	jreq	#no

	inc	a14
	cmp	a0,a14
	jreq	#cont

	;new stick.
	move	a0,*a13(CLIMB_START)
	move	a0,*a13(CLIMB_LAST)
#no	clrc
	rets

#cont	move	a0,*a13(CLIMB_LAST)
	move	*a13(CLIMB_START),a14
	sub	a14,a0
	cmpi	#IDIOT_COUNT,a0
	jrlt	#no

	;climb!
	setc
	rets

;#*****************************************************************************
;*
;* a13 = wrestler process
;
; SUBR	clear_damage_log
;
;	move	a13,a2
;	addi	DAMAGE_HIST,a2		;start of damage stucture
;
;	clr	a0
;	movk	20,a1			;8 longs
;#clr_loop
;	move	a0,*a2+,L
;	dsj	a1,#clr_loop
;
;	rets
;
;
;#*****************************************************************************
;*
;* a13 = wrestler process
;* a0  = damage amount (only if negative)
;
; SUBR	log_damage
;
;	move	a0,a0
;	jrnn	#not_damage
;
;	PUSH	a1,a2,a3
;
;	move	a13,a1
;	move	a13,a2
;
;	addi	DAMAGE_HIST+19*32,a1	;start at end of structure and
;	addi	DAMAGE_HIST+20*32,a2	;move everything down 1 long
;
;	movk	19,a3
;#lp	move	-*a1,-*a2,L
;	dsjs	a3,#lp
;
;	move	a0,a1			;damage amount
;	neg	a1
;	sll	16,a1
;	move	@round_tickcount,a2	;ticks since match started
;	andi	0ffffh,a2
;	or	a1,a2
;	move	a2,*a13(DAMAGE_HIST),L
;
;	PULL	a1,a2,a3
;
;#not_damage
;	rets
;
;
;#*****************************************************************************
;*
;* ARGS:		a13 = wrestler process
;*		 a0 = timespan (in ticks)
;*
;* RETURNS:	 a0 = damage total
;*
;* TRASHES:	a1-a6,a14
;*
;
; SUBR	tally_damage
;
;	move	@round_tickcount,a4	;ticks since match started
;	clr	a5			;damage tally
;
;	move	a13,a1
;	addi	DAMAGE_HIST,a1		;start of damage stucture
;
;	movk	20,a6
;#loop
;	move	*a1+,a2			;tick count
;	jrz	#exit			;can't have a 0 tick count
;	move	*a1+,a3			;damage
;
;	move	a4,a14
;	sub	a2,a14
;	cmp	a0,a14			;> timespan?
;	jrgt	#exit
;
;	add	a3,a5
;	dsj	a6,#loop
;
;#exit
;	move	a5,a0
;	rets
;
#*****************************************************************************
*
* a10 = player number (0 to NUM_WRES-1)

GETUP_SIZE	equ	80 ;102	;174	;99
MAX_TIME	equ	6*TSEC
INV_MULT	equ	256*GETUP_SIZE/MAX_TIME
ONSCR_X		equ	173
OFFSCR_X	equ	221

	STRUCTPD
	LONG	IPTR_FRAME
	LONG	IPTR_GREEN
	WORD	DISPLAY_VAL

 SUBR	getup_meter

	;HACK ALERT: In royal rumble mode, player 1 is on PLAYER 0's TEAM,
	; so this code is gonna want to put his getup meter on the left.
	; To get it over on the right where it belongs, we temporarily put
	; him on the other team.  This shouldn't break anything.

	move	@royal_rumble,a14
	jrz	#norum
	cmpi	1,a10		;(plyrnum)
	jrne	#norum
	movk	1,a9		;act like plyr 1 is on team 1.
#norum

	move	a10,a11			;a11 is PLYRNUM
	move	a10,a1
	calla	get_process_ptr
	move	a0,a10			;a10 is our wrestler process

	SLEEPK	2

	;first off, figure out if this guy is even allowed to have a getup
	; meter.  Humans always get them.  A drone teammate of a human
	; doesn't get one.  Otherwise, drones only get them if the GETUP
	; powerup is set and they're the only drone on their team.

	move	*a10(PLYR_TYPE),a14
	cmpi	PTYPE_PLAYER,a14
	jreq	#yes		;humans get getup meters

	movk	NUM_WRES,a0
	movi	process_ptrs,a1
	move	*a10(PLYR_SIDE),a2	;we'll need that later anyway.
#lp0	move	*a1+,a3,L
	jrz	#nxt0		;skip inactive
	cmp	a3,a10
	jreq	#nxt0		;skip self
	move	*a3(PLYR_SIDE),a14
	cmp	a14,a2
	jrne	#nxt0		;skip other team
	move	*a3(PLYR_TYPE),a14
	cmpi	PTYPE_PLAYER,a14
	jreq	#die		;we have a human teammate so we don't get one
	jruc	#nxt0

#die	clr	a14
	move	a14,*a10(METER_PROC),L
	DIE			;multi-drone team--no meters

#nxt0	dsjs	a0,#lp0

	;we got through the loop and found no teammates, so we're a lone
	; drone and we get a meter only if GETUP_POWER is set.
;	move	@GETUP_POWER,a14
	move	@drone_meters_on,a14
	jrz	#die		;no GETUP_POWER--no meter

	move	@NUM_OPPS,a1
	cmpi	2,a1	   
	jrge	#die


#yes	clr	a0
	move	a0,*a13(DISPLAY_VAL)

	;set our x-position based on PLYR_SIDE
	movi	[OFFSCR_X,0],a10
	move	a9,a9
	jrnz	#p2

	dec	a10
	neg	a10
#p2

	movi	RECVRBLK,a2			;* image (green bar)
	movi	[109,0],a1			;y pos
	movi	1801h,a3			;z pos
	callr	#begin_obj
	move	a8,*a13(IPTR_GREEN),L
	movi	RECVR_R,a2			;* image (frame)
	move	a9,a9
	jrnz	#p2_meter
	movi	RECVR_L,a2			;* image (frame)
#p2_meter
	movi	[189,0],a1			;y pos
	movi	1800h,a3			;z pos
	callr	#begin_obj
	move	a8,*a13(IPTR_FRAME),L

	move	a11,a1
	calla	get_process_ptr
	move	a0,a10

	move	a13,*a10(METER_PROC),L

 SUBR 	slide_offscr

;Don't allow a meter to come out for awhile (unless flung)
	movi	18*60,a0	;13
	move	a0,*a10(DELAY_METER)

	movk	10,a11
#offscr_loop
	move	a11,a11
	jrz	#update
	dec	a11
	jruc	#cont
#update
	movi	[OFFSCR_X,0],a0
	callr	#set_x

	move	*a10(WHOHITME),A0,L
	move	*a0(COMBO_COUNT),A14
	jrnz	#cont
	move	*a10(DELAY_METER),a14
	jrnz	#cont
	move	*a10(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jrz	#cont
;If health meter is down low, don't have getup meter come out.
;Unless it was a fling!
	move	*a10(PLYRNUM),a1
	.ref	get_health
	calla	get_health
	cmpi	20,a0
	jrgt	#norm
	move	*a10(GETUP_TIME),a14
	cmpi	FLUNG_TIME,a14
	jrz	#onscr

#norm
	move	*a10(GETUP_TIME),a14
	jrnz	#onscr

#cont
	SLEEPK	1
	jruc	#offscr_loop


#onscr
	move	a14,a11

	movi	GETUP_SIZE,a0
	move	a0,*a13(DISPLAY_VAL)

	MOVI	0BDH,A0			;Meter announce sound
	CALLA	triple_sound

	movi	120,a6
	move	*a10(GETUP_TIME),a5

#onscr_loop

	movi	[ONSCR_X,0],a0
	callr	#set_x

	move	*a10(GETUP_TIME),a7

	;if a7 (current getup) is greater than a11 (starting getup), our
	; scale will be messed up.  In this case, just move a7 into a11.
	cmp	a11,a7
	jrle	#rescale
	move	a7,a11

#rescale
	movi	GETUP_SIZE,a0
	mpyu	a0,a7			;* GETUP_SIZE
	divu	a11,a7			;/ INITIAL GETUP TIME

	move	*a13(DISPLAY_VAL),a0
	cmp	a0,a7			;has getup been incremented?
	jrle	#ok1

	move	a7,a11
	movi	GETUP_SIZE,a0
	mpyu	a0,a7			;* GETUP_SIZE
	divu	a11,a7			;/ INITIAL GETUP TIME
#ok1
	.ref	dufus_msg_on

	subk	1,a6
	jrnz	#dont_bother
	move	*a10(GETUP_TIME),a0
	sub	a0,a5
	cmpi	175,a5
	jrgt	#dont_bother
	PUSH	a2,a7,a9
	movk	2,a9
	CREATE	4000h|AWARD_PID,dufus_msg_on
	PULL	a2,a7,a9
#dont_bother

	PUSH	a5,a6
	callr	#update_meter
	PULL	a5,a6

	move	a7,a7
	jrz	slide_offscr

	move	*a10(PLYRMODE),a0
	cmpi	MODE_DEAD,a0
	jrz	slide_offscr

	PUSHP	a5,a6
	SLEEPK	1
	PULLP	a5,a6
	jruc	#onscr_loop


**********
 SUBRP	#set_x

	move	a9,a9
	jrnz	#p22
	neg	a0
#p22
	addi	[200-1,0],a0			;center of screen
	move	a13,a14
	addi	IPTR_FRAME,a14
	move	*a14,a8,L
	move	*a8(OXVAL),a1,L
	sub	a1,a0
	sra	2,a0
	movk	3-1,a1
#lp	move	*a14+,a8,L
	move	*a8(OXVAL),a2,L
	add	a0,a2
	move	a2,*a8(OXVAL),L
	dsj	a1,#lp
	rets


**********
 SUBRP	#begin_obj

	movi	[200-1,0],a0			;x pos
	add	a10,a0

	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ
	rets


**********
 SUBRP	#update_meter

	move	*a13(DISPLAY_VAL),a0
	add	a0,a7
	srl	1,a7
	move	a7,*a13(DISPLAY_VAL)
	move	a7,a1

	neg	a1
	addi	GETUP_SIZE,a1
	jrp	#ok
	clr	a1
#ok	movi	GETUP_SIZE,a0
	cmp	a0,a1				;meter can't be taller
	jrle	#ok2				;than GETUP_SIZE pixels
	move	a0,a1
#ok2	move	*a13(IPTR_GREEN),a8,L

	MOVI	GETUP_SIZE,A2
	SUB	A1,A2
	MOVE	A2,*A8(OSIZEY)
	MOVI	RECVRBLK,A0
	MOVE	*A0(ICTRL),A5
	SRL	12,A5
	MOVE	A1,A3
	MPYU	A5,A3
	MOVE	*A0(ISIZEX),A5
	MPYU	A5,A3
	MOVE	*A0(ISAG),A0,L
	ADD	A3,A0
	MOVE	A0,*A8(OSAG),L

	rets

#*****************************************************************************
*
* makes your getup meter go away if you've got one out.

 SUBR	ditch_getup_meter_a9
	PUSH	a13
	move	a9,a13
	callr	ditch_getup_meter
	PULL	a13
	rets

 SUBR	ditch_getup_meter

	move	*a13(GETUP_TIME),a0
	jrz	#cont
	move	*a13(PLYR_DIZZY),a0
	jrnz	#cont

;This guy has a getup meter on screen and is running out of control!
;Cause getup meter to slide off screen.

	move	*a13(METER_PROC),a0,L
	jrz	#cont		;skip if we don't have a meter.
	PUSH	a8,a9,a10
	move	*a0(PA8),a8,L
	move	*a0(PA9),a9,L
	move	*a0(PA10),a10,L
	movi	GETUP_PID,a1
	movi	slide_offscr,a7
	calla	XFERPROC
	PULL	a8,a9,a10

#cont	rets

#*****************************************************************************
*
*	a0  = # ticks to add
*	a13 = * wrestler process

 SUBR	inc_getup_time

	PUSH	a14
	move	*a13(GETUP_TIME),a14
	cmpi	20,a14
	jrlt	#exit
	add	a0,a14
	move	a14,*a13(GETUP_TIME)
#exit
	PULL	a14
	rets

#*****************************************************************************
*
* do rolls for any wrestler
*
* args : a13 = * wrestler process
*
* returns : Z=1 if didn't roll

 SUBR	do_roll

	move	*a13(OBJ_ZPOSINT),a0
	move	*a13(Z_BOUND),a14
	jrz	#reg

	sub	a0,a14
	abs	a14		;<-new!
	cmpi	6,a14
	jrle	#no_roll
#reg
	move	*a13(STICK_VAL_CUR),a0
	andi	MOVE_UP|MOVE_DOWN,a0
	jrz	#no_roll

	move	*a13(WRESTLERNUM),a14
	X32	a14
	addi	#roll_table,a14
	move	*a14,a14,L

	move	*a14+,a1		;roll speed
	move	*a14+,a2,L		;z velocity

	btst	MOVE_DOWN_BIT,a0
	jrnz	#down
	neg	a1			;must be up
	neg	a2
#down
	move	a2,*a13(OBJ_ZVEL),L

	move	*a13(ROLL_POS),a0
	add	a0,a1
	andi	0ffh,a1
	move	a1,*a13(ROLL_POS)
	move	*a14+,a0,L		;inv multiplier
	mpyu	a0,a1
	srl	16,a1			;/65536
	X32	a1
	add	a1,a14
	move	*a14,a0,L
 .if DEBUG
	jrnz	#ok
 	LOCKUP
#ok
 .endif

	move	*a0,a0,L
 .if DEBUG
	jrnz	#ok2
 	LOCKUP
#ok2
 .endif

	move	a0,*a13(CUR_FRAME),L
	rets


#no_roll
	clr	a0
	move	a0,*a13(OBJ_ZVEL),L
	rets


#roll_table
	REFLONG	hrt_roll_frames	;0 Bret Hart
	REFLONG	rzr_roll_frames	;1 Razor Ramon
	REFLONG	und_roll_frames	;2 Undertaker
	REFLONG	yok_roll_frames	;3 Yokozuna
	REFLONG	shn_roll_frames	;4 Shawn Michaels
	REFLONG	bam_roll_frames	;5 Bam Bam
	REFLONG	dnk_roll_frames	;6 Doink
	.long	0		;7 unused
	REFLONG	lex_roll_frames	;8 Lex Luger


;
;#*****************************************************************************
;
; SUBR	check_dizzy
;
;	movi	4*TSEC,a0
;	calla	tally_damage
;
;;Is this the right way to causes dizzies?
;;If one move is super powerful, we will tend to get dizzies when we don't want
;;them.  Maybe it should be based on hits over time, not damage.
;
;;A combination of the two is needed here! 10/5/94
;
;;We need less resolution on the damage that is recorded!
;;Perhaps 1-3?
;
;;We should allow this to happen only once per round!
;
;	cmpi	65,a0
;
;	jrlt	#no_dizzy
;
;	jruc	#no_dizzy
;
;
;	calla	clear_damage_log
;
;;Don't allow dizzies if your health meter is real low!
;;Killer Instinct sucks....
;	move	*a13(PLYRNUM),a1
;	.ref	get_health
;	calla	get_health
;	cmpi	30,a0
;	jrlt	#no_dizzy
;
;;Too many dizzies this round?
;	move	*a13(PLYR_DIZZY_CNT),a0
;	cmpi	1,a0				;Max dizzies per round
;	jrge	#no_dizzy
;
;	inc	a0
;	move	a0,*a13(PLYR_DIZZY_CNT)
;
;
;	movk	1,a0	;return TRUE
;	move	a0,*a13(PLYR_DIZZY)
;	rets
;
;#no_dizzy
;	clr	a0	;return FALSE
;	rets

#*****************************************************************************

 SUBR	form_button_value

	;Combine the val_cur of the block bit with the val_down of the rest.

	move	*a13(BUT_VAL_CUR),a0
	andi	PLAYER_BLOCK_VAL,a0
	move	a0,a1
	move	*a13(BUT_VAL_DOWN),a0
	or	a1,a0
	rets

;
;#*****************************************************************************
;
; SUBR	start_whack
;
;;a10=plyr proc
;;Turn on whack button graphic, animate it for a bit
;
;frame_z		.equ	202
;
;	movk	1,a0
;	move	a0,*a10(WHACK_CNT)
;
;	movi	[0f6h,0],a1
;	movi	[44h,0],a0
;	move	*a10(PLYRNUM),a2
;	jrz	#ok
;	movi	[401-44h,0],a0
;#ok
;	movi	WHAK0001,a2
;	movi	frame_z+2,a3			;Z
;	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
;	movi	OVRHED_PID,a5
;	clr	a6
;	clr	a7
;	calla	BEGINOBJ
;	move	a8,a11
;
;	movi	[0f6h,0],a1
;	movi	[44h,0],a0
;	move	*a10(PLYRNUM),a2
;	jrz	#ok2
;	movi	[401-44h,0],a0
;#ok2
;	movi	WKBUTT01,a2
;	movi	frame_z+3,a3			;Z
;	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
;	movi	OVRHED_PID,a5
;	clr	a6
;	clr	a7
;	calla	BEGINOBJ
;
;#start
;	movi	butn_l,a9
;
;#lp	move	*a10(GETUP_TIME),a0
;	jrz	#die
;
;	move	*a9+,a0,L
;	jrz	#start
;	move	*a8(OCTRL),a1
;	calla	obj_aniq
;#noani
;	SLEEPK	3
;	jruc	#lp			;Going up?
;
;#die
;	SLEEPK	10
;
;	move	a11,a0
;	calla	DELOBJ
;	jauc	DELOBJDIE
;
;
;butn_l
;	.long	WKBUTT01
;	.long	WKBUTT02
;	.long	WKBUTT03
;	.long	WKBUTT02
;     ;	.long	0
#*****************************************************************************
*
* Gets the animation point of a multipart object.  Find the highest x and y
* offset values among all the pieces.
*
* >a0 = object table pointer
* <a0 = [Yoff,Xoff]

 SUBR	get_mpart_offsets
	PUSH	a1,a2,a9

	;reg use
	; a1 = current hi xoff
	; a2 = current hi yoff
	; a9 = loop counter

	move	*a0(IPCOUNT),a9

	.if DEBUG
	jrle	#bad
	cmpi	5,a9
	jrgt	#bad
	jruc	#ok
#bad	LOCKUP
#ok
	.endif

	move	*a0(IANIOFFX),a1
	move	*a0(IANIOFFY),a2
	addi	ICBZ,a0
	dec	a9
	jrle	#done

#loop
	move	*a0(IANIOFFX),a14
	cmp	a1,a14
	jrle	#xc
	move	a14,a1			;new hi x

#xc
	move	*a0(IANIOFFY),a14
	cmp	a2,a14
	jrle	#yc
	move	a14,a2			;new hi y

#yc
	addi	ICPBZ,a0
	dsj	a9,#loop

#done
	sla	16,a2
	move	a2,a0
	zext	a1			;clear out sign
	or	a1,a0
	PULL	a1,a2,a9
	rets

#*****************************************************************************
*
* Gets the combined X size of a multi-part object.  The correct answer is
* (hi anipt) + hi (size - anipt)
*
* >a0 = object table pointer
* <a0 = Xsize

 SUBR	get_mpart_xsize
	PUSH	a1,a2,a3,a9

	;reg use
	; a1 = current hi anipt
	; a2 = current hi size - anipt
	; a9 = loop counter

	move	*a0(IPCOUNT),a9

	move	*a0(IANIOFFX),a1
	move	*a0(ISIZEX),a2
	sub	a1,a2
	addi	ICBZ,a0
	dec	a9
	jrz	#done

#loop
	move	*a0(IANIOFFX),a14
	cmp	a1,a14
	jrle	#ac
	move	a14,a1			;new hi x

#ac
	move	*a0(ISIZEX),a14
	move	*a0(IANIOFFX),a3
	sub	a3,a14
	cmp	a2,a14
	jrle	#sac
	move	a14,a2			;new hi y

#sac
	addi	ICPBZ,a0
	dsj	a9,#loop

#done
	move	a2,a0
	add	a1,a0
	PULL	a1,a2,a3,a9
	rets

#*****************************************************************************
*
* Zero yer TGT_YOFF.  Do this anytime you target an opponent who's on the
* ground.

 SUBR	tgt_ground

	clr	a14
	move	a14,*a13(TGT_YOFF)
	rets

#*****************************************************************************
*
* Halves wrestler's X-velocity if he's moving backwards.

 SUBR	halve_bk_xvel

	move	*a13(OBJ_XVEL),a0,L
	move	*a13(FACING_DIR),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#abs
	neg	a0
#abs
	move	a0,a0
	jrnn	#ok

	move	*a13(OBJ_XVEL),a0,L
	sra	1,a0
	move	a0,*a13(OBJ_XVEL),L
#ok
	rets


#*****************************************************************************
*
* scroll_world moves the screen based on the midpoint of a segment connecting
* two wrestlers.  Rules:
*
* - If there are two and only two active wrestlers, track on them.
* - If there are more than two active wrestlers and two are human, track
*   on the humans.
* - If there are more than two active wrestlers, but only one is human,
*   count his live opponents:
*	0: track on only the human player
*	1: track on human and his one live opponent
*	2: track on the human and the mean position of the two live ones.
*	3: track on the human and the mean position of the three live ones,
*	   with the closest counted twice.
* - If there are more than two active wrestlers, and NONE of them are
*   human, look for a live one.  If none are alive, track on the first
*   dead one and his closest opponent.  If one or more is alive, track
*   on the first live one and his closest opponent.
* - Don't let any human players off the top of the screen.
* - In royal rumble mode, just track on the average position of all live
*   wrestlers.  If this results in everyone being offscreen, so be it.
* - And finally, on top of everything else, if there's only one human
*   player, under no circumstances will the scroller let him off-screen.
*   He'll remain entirely on the screen regardless of whatever else might
*   be going on. (as yet unimplemented.  coming soon...)
*


#BUFFER	equ	[20,0]

#XMINUSX	.equ	0
#YMINUSX	.equ	#XMINUSX+32*(NUM_WRES+1)
#ZMINUSX	.equ	#YMINUSX+32*(NUM_WRES+1)

LIMITXL	.EQU	[12FH,0]
LIMITXR	.EQU	[5E8H,0]
LIMITYT	.EQU	[200H,0]
LIMITYB	.EQU	[97h,0]


 SUBR	scroll_world

	MMTM	SP,A8,A9,A10,A11

	.ref	in_finish_move

	move	@in_finish_move,a0
	jrnz	#x

	move	@HALT,a0
	jrnz	#x

	;first, check for a royal rumble
	move	@royal_rumble,a14
	jrnz	#rumble

	;check for two human players
	move	@PSTATUS,a0
	jrz	#no_humans
	cmpi	3,a0
	jrne	#one_human

	;two humans.  track on them.
	clr	a2
	movk	1,a3
	jruc	#indices_set

#one_human
	;okay, we have only one player.  If this is one-on-one, track on
	; him and the drone.  (also, get the human's process ptr in a8)
	move	a0,a8
	dec	a8
	X32	a8
	addi	process_ptrs,a8
	move	*a8,a8,L

	move	@NUM_OPPS,a14
	dec	a14
	jrnz	#one_v_many

	;plyr v. one drone
	move	*a8(PLYRNUM),a2
	movk	2,a3
	jruc	#indices_set

#one_v_many
	;count live opponents.  If there is one, track the human and his
	; closest opponent, which should be the live drone. If there are
	; none or more than one, track only on the human.
	;NOTE: Don't count opponents who are live but have different INRING
	; values.
	movk	NUM_WRES-2,a0
	movi	process_ptrs+40h,a1
	move	*a8(PLYR_SIDE),a2
	move	*a8(INRING),a5
	clr	a4		;live enemy counter
#lp0	move	*a1+,a3,L
	jrz	#done0		;quit at first inactive since we're only
				;looking at drones
	move	*a3(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#nxt0		;skip dead

	move	*a3(PLYR_SIDE),a14
	cmp	a2,a14
	jreq	#nxt0		;skip teammates

	move	*a3(INRING),a14
	cmp	a5,a14
	jrne	#nxt0		;skip bad INRINGS

	inc	a4
#nxt0	dsj	a0,#lp0

#done0	dec	a4
	jrn	#track_human_only	;0 live opponents
	jrz	#1opp			;1 live opponent
	dec	a4
	jrz	#2ops			;2 live opponents
	jruc	#3ops			;3 live opponents


	;for the three cases (#2ops, #3ops, #rumble) where we're tracking on
	; a mean position rather than an actual wrestler, we store the mean
	; position in the long word immediately before wrestler_[xyz].
	; There's extra space allocated there.

	;reggies:
	;	a5 = x accumulator
	;	a6 = y accumulator
	;	a7 = z accumulator


#rumble	;There are anywhere from 1 to 4 live wrestlers.  Track on the live
	; ones.  If there's three, double-weight the one with the dead
	; teammate.  Since we've only got space for one artificial set
	; of coordinates, if we get all four alive, compute the average
	; position of all four, put that in the artificial slot, and track
	; on it twice.

	;first, count live wrestlers (drone and human)
	movi	process_ptrs,a0
	movk	4,a1		;only interested in plyrnum's 0-3
	clr	a3		;live count
	clr	a4		;PLYRNUMS
	clr	a5		; of
	clr	a6		;  live
	clr	a7		;   wrestlers
#lp3	move	*a0+,a2,L
	move	*a2(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#nxt3
	move	*a2(I_WILL_DIE),a14
	jrnz	#nxt3
	inc	a3
	move	a6,a7
	move	a5,a6
	move	a4,a5
	move	*a2(PLYRNUM),a4
#nxt3	dsj	a1,#lp3

	;okay, branch based on the live count
	dec	a3
	jrn	#rr0liv		;none alive?  shouldn't happen.
	jrz	#rr1liv
	subk	2,a3
	jrn	#rr2liv
	jrz	#rr3liv
	jruc	#rr4liv

#rr0liv	;none alive(!?)  Track on the humans
	clr	a2
	movk	1,a3
	jruc	#indices_set

#rr1liv	;one alive.  Track on him.
	move	a4,a2
	move	a4,a3
	jruc	#indices_set

#rr2liv	;two alive.  Track on them.
	move	a4,a2
	move	a5,a3
	jruc	#indices_set

#rr3liv	;three alive.  Since one human CAN'T be dead, the dead one must
	; be a drone.  Track on the drone and the average position of the
	; wrestlers. (a5 and a6 must be the humans, a4 the drone)

	;#0 (human)
	movi	wrestler_x,a0
	move	*a0(#XMINUSX),a5,L
	move	*a0(#YMINUSX),a6,L
	move	*a0(#ZMINUSX),a7,L

	;#1 (human)
	movi	wrestler_x+20h,a0
	move	*a0(#XMINUSX),a14,L
	add	a14,a5
	move	*a0(#YMINUSX),a14,L
	add	a14,a6
	move	*a0(#ZMINUSX),a14,L
	add	a14,a7

	;divide
	sra	1,a5
	sra	1,a6
	sra	1,a7

	;store
	movi	wrestler_x-20h,a0
	move	a5,*a0(#XMINUSX),L
	move	a6,*a0(#YMINUSX),L
	move	a7,*a0(#ZMINUSX),L

	;go
	movi	-1,a2
	move	a4,a3
	jruc	#indices_set


#rr4liv	;four alive.  Track on all of 'em.

	;#0
	movi	wrestler_x,a0
	move	*a0(#XMINUSX),a5,L
	move	*a0(#YMINUSX),a6,L
	move	*a0(#ZMINUSX),a7,L

	;#1
	movi	wrestler_x+20h,a0
	move	*a0(#XMINUSX),a14,L
	add	a14,a5
	move	*a0(#YMINUSX),a14,L
	add	a14,a6
	move	*a0(#ZMINUSX),a14,L
	add	a14,a7

	;#2
	movi	wrestler_x+40h,a0
	move	*a0(#XMINUSX),a14,L
	add	a14,a5
	move	*a0(#YMINUSX),a14,L
	add	a14,a6
	move	*a0(#ZMINUSX),a14,L
	add	a14,a7

	;#3
	movi	wrestler_x+60h,a0
	move	*a0(#XMINUSX),a14,L
	add	a14,a5
	move	*a0(#YMINUSX),a14,L
	add	a14,a6
	move	*a0(#ZMINUSX),a14,L
	add	a14,a7

	;divide
	sra	2,a5
	sra	2,a6
	sra	2,a7

	;store
	movi	wrestler_x-20h,a0
	move	a5,*a0(#XMINUSX),L
	move	a6,*a0(#YMINUSX),L
	move	a7,*a0(#ZMINUSX),L

	;go
	movi	-1,a2
	movi	-1,a3
	jruc	#indices_set


#3ops	;opponents must be plyrnum's 2, 3, and 4.

	;closest
	move	*a8(CLOSEST_NUM),a0
	X32	a0
	addi	wrestler_x,a0
	move	*a0(#XMINUSX),a5,L
	move	*a0(#YMINUSX),a6,L
	move	*a0(#ZMINUSX),a7,L

	;#2
	movi	wrestler_x+40h,a0
	move	*a0(#XMINUSX),a14,L
	add	a14,a5
	move	*a0(#YMINUSX),a14,L
	add	a14,a6
	move	*a0(#ZMINUSX),a14,L
	add	a14,a7

	;#3
	movi	wrestler_x+60h,a0
	move	*a0(#XMINUSX),a14,L
	add	a14,a5
	move	*a0(#YMINUSX),a14,L
	add	a14,a6
	move	*a0(#ZMINUSX),a14,L
	add	a14,a7

	;#4
	movi	wrestler_x+80h,a0
	move	*a0(#XMINUSX),a14,L
	add	a14,a5
	move	*a0(#YMINUSX),a14,L
	add	a14,a6
	move	*a0(#ZMINUSX),a14,L
	add	a14,a7

	;divide
	sra	2,a5
	sra	2,a6
	sra	2,a7

	;store
	movi	wrestler_x-20h,a0
	move	a5,*a0(#XMINUSX),L
	move	a6,*a0(#YMINUSX),L
	move	a7,*a0(#ZMINUSX),L

	;go
	move	*a8(PLYRNUM),a2
	movi	-1,a3
	jruc	#indices_set

#2ops	;opponents could have 2, 3, or 4.  loop.
	clr	a5
	clr	a6
	clr	a7
	movk	NUM_WRES-2,a9		;only check drones
	movi	process_ptrs+40h,a1
	move	*a8(PLYR_SIDE),a2
	move	*a8(INRING),a11
#lp2	move	*a1+,a0,L
	jrz	#done2		;quit at first inactive--only checking drones

	move	*a0(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#nxt2		;skip dead

	move	*a0(PLYR_SIDE),a14
	cmp	a14,a2
	jreq	#nxt2		;skip teammates

	move	*a0(INRING),a14
	cmp	a14,a11
	jrne	#nxt2		;skip bad INRINGs

	move	*a0(OBJ_XPOS),a14,L
	add	a14,a5
	move	*a0(OBJ_YPOS),a14,L
	add	a14,a6
	move	*a0(OBJ_ZPOS),a14,L
	add	a14,a7

#nxt2	dsj	a9,#lp2

#done2	;divide
	sra	1,a5
	sra	1,a6
	sra	1,a7

	;store
	movi	wrestler_x-20h,a0
	move	a5,*a0(#XMINUSX),L
	move	a6,*a0(#YMINUSX),L
	move	a7,*a0(#ZMINUSX),L

	;go
	move	*a8(PLYRNUM),a2
	movi	-1,a3
	jruc	#indices_set


#1opp	move	*a8(PLYRNUM),a2
	move	*a8(CLOSEST_NUM),a3
	jruc	#indices_set

#track_human_only
	move	*a8(PLYRNUM),a2
	move	a2,a3
	jruc	#indices_set

#no_humans
	;attract mode play.  track on first live drone and his closest
	; opponent.
	movk	NUM_WRES,a0
	movi	process_ptrs,a1
#lp1	move	*a1+,a2,L
	jrz	#nxt1		;skip inactive
	move	*a2(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#nxt1		;skip dead (shouldn't happen)

	;found a live drone.  track on him and his closest opp
	move	*a2(CLOSEST_NUM),a3
	move	*a2(PLYRNUM),a2
	jruc	#indices_set

#nxt1	dsj	a0,#lp1

	;bizarre.  everyone's dead in the attract mode.  Just track on
	; first two drones.
	movk	2,a2
	movk	3,a3
	;fall through to #indices_set

#indices_set
	;a2 and a3 are PLYRNUM's of wrestlers to track on.  They MAY be
	; the same.
	move	a2,a0
	move	a2,a10
	move	a2,a8
	X32	a0
	X32	a10
	X32	a8
	addi	wrestler_x,a0
	addi	wrestler_y,a10
	addi	wrestler_z,a8

	move	a3,a1
	move	a3,a11
	move	a3,a9
	X32	a1
	X32	a11
	X32	a9
	addi	wrestler_x,a1
	addi	wrestler_y,a11
	addi	wrestler_z,a9

	;wrestler1 (*x,*y,*z) = (a0,a10,a8)
	;wrestler2 (*x,*y,*z) = (a1,a11,a9)

#values_set
	move	*a0,a0,L
	move	*a1,a1,L
	add	a0,a1
	sra	1,a1
	subi	[200,0],a1		;middle of screen

	move	@WORLDTLX,a2,L
	sub	a2,a1
	jrp	#pos

	addi	#BUFFER,a1
	jrp	#wide
	jruc	#cont

#pos	subi	#BUFFER,a1
	jrn	#wide

#cont	sra	3,a1
	add	a1,a2

	cmpi	[12fh,0],a2
	jrlt	#wide
	cmpi	[648h,0],a2
	jrgt	#wide

	move	a2,@WORLDTLX,L

#wide	move	*a8,a0,L
	move	*a9,a1,L
	add	a0,a1
	sra	1+16,a1
	movi	Y_SCALE_MULTIPLIER,a0
	mpys	a0,a1
	move	a1,a2

	move	*a10,a0,L
	move	*a11,a1,L
	add	a0,a1
	sra	1,a1
	sub	a1,a2
	subi	[0d8h,0],a2		;middle of screen

	;Check for SCROLL_CTRL bits on active wrestlers.
	movi	process_ptrs,a0
	movk	NUM_WRES,a9
#lp4	move	*a0+,a3,L
	jrz	#nxt4		;skip inactive

	move	*a3(STATUS_FLAGS),a14
	btst	B_SCROLL_CTRL,a14
	jrz	#nxt4

	;control found.  On screen in X?
	move	*a3(OBJ_XPOS),a1,L
	move	@WORLDTLX,a14,L
	subi	[60,0],a14
	cmp	a14,a1
	jrlt	#nxt4
	addi	[400+120,0],a14
	cmp	a14,a1
	jrgt	#nxt4

	;calc hi pt
	move	*a3(OBJ_ZPOSINT),a1
	movi	Y_SCALE_MULTIPLIER,a14
	mpys	a14,a1
	move	*a3(OBJ_YPOS),a14,L
	sub	a14,a1
	move	*a3(SCROLL_Y),a14
	sla	16,a14
	sub	a14,a1

	cmp	a2,a1
	jrge	#nxt4
	
#top_ok	move	a1,a2

#nxt4	dsj	a9,#lp4



#sc_done
	move	@WORLDTLY,a1,L
	sub	a1,a2
	sra	2,a2
	add	a2,a1

	;Don't allow scroller to go past front fence
	cmpi	[97h,0],a1
	jrgt	#low
	move	a1,@WORLDTLY,L
#low
#x	MMFM	SP,A8,A9,A10,A11
	rets

#*****************************************************************************
*
* this is called before the velocity add and
* it's goal is to keep either wrestler from moving
* offscreen if one or both are outside the ring

#BUFF1	equ	185
#BUFF2	equ	185	;140

 SUBR	keep_onscreen

	;confine only in two-player game.
	move	@PSTATUS,a14
	cmpi	3,a14			;is it a 2-player game?
	jrne	#no_2_player

	move	@WORLDTLX+16,a0		;world x int
	addi	200,a0			;center of screen

	move	a0,a1

	cmpi	RING_X_CENTER,a0
	jrgt	#right_side

#left_side
	subi	#BUFF2,a0	;left edge
	addi	#BUFF1,a1	;right edge
	jruc	#cont

#right_side
	subi	#BUFF1,a0
	addi	#BUFF2,a1
#cont
	move	@process_ptrs,a10,L	;player 1
	move	@process_ptrs+20h,a11,L	;player 2

;	move	*a10(DEC_DELAY),a14
;	jrnz	#inring
;	move	*a11(DEC_DELAY),a14
;	jrnz	#inring

	.ref	allow_offscrn

	move	@allow_offscrn,a14
	jrz	#ok
	dec	a14
	move	a14,@allow_offscrn
	jrnz	#inring
#ok
	move	*a10(INRING),a14
	jrnz	#outside

	move	*a11(INRING),a14
	jrz	#inring


#outside	;at least 1 player outside the ring

	move	a10,a9
	callr	#do_check
	move	a11,a9
	callr	#do_check

#inring
#no_2_player
	rets

#do_check
	move	*a9(OBJ_XPOSINT),a14
	cmp	a0,a14
	jrgt	#ok1

;past left edge
	move	*a9(OBJ_XVEL),a14,L
	jrz	#done
	jrn	#clrx
	rets
#ok1
	cmp	a1,a14
	jrlt	#ok2

;past right edge
	move	*a9(OBJ_XVEL),a14,L
	jrz	#done
	jrn	#done
#clrx
	move	*a9(CLIMBING_THRU),a14	;1=Climbing thru ropes flag
	jrnz	#done

	clr	a14
	move	a14,*a9(OBJ_XVEL),L

	move	*a9(PLYRMODE),a14
	cmpi	MODE_RUNNING,a14
	jrne	#done

	movi	MODE_NORMAL,a14
	move	a14,*a9(PLYRMODE)
	move	a14,*a9(ANIMODE)

	callr	ditch_getup_meter_a9

#ok2
#done
	rets


#*****************************************************************************

MAX_YVEL	equ	-1000000h	;-40000h

 SUBR	wrestler_veladd

	move	@HALT,a0
	jrnz	#x

	move	*a13(OBJ_XPOS),a0,L
	move	*a13(OBJ_XVEL),a1,L
	add	a1,a0
	move	a0,*a13(OBJ_XPOS),L

	move	*a13(GROUND_Y),a2
	sll	16,a2
	move	*a13(OBJ_YPOS),a0,L
	sub	a2,a0			;- GROUND_Y
	move	*a13(OBJ_YVEL),a1,L
	add	a1,a0
	jrnn	#yok

	;under ground.  clr Yvel unless we're attached and MODE_GHOST
	move	*a13(ATTACH_PROC),a14,L
	jrz	#set_yvel
	move	*a14(ATTACH_PROC),a14,L
	cmp	a13,a14			;valid link?
	jrne	#set_yvel
	move	*a13(ANIMODE),a14,L
	btst	MODE_GHOST_BIT,a14
	jrnz	#yok
	move	a1,a1			;if yvel is positive then keep
	jrn	#set_yvel		;velocity & put at ground level
	clr	a0
	jruc	#yok

#set_yvel
	;we've hit the ground -- if our WAITHITOPP bit is set, stuff
	; a 1 in ANICNT.
	move	*a13(ANIMODE),a14
	btst	MODE_WAITHITOPP_BIT,a14
	jrz	#nwho
	movk	1,a14
	move	a14,*a13(ANICNT)

#nwho	clr	a0
	move	a0,*a13(OBJ_YVEL),L
#yok
	add	a2,a0			;+ GROUND_Y
	move	a0,*a13(OBJ_YPOS),L



	calla	calc_ground_y

	move	*a13(OBJ_YPOS),a0,L

	move	*a13(GROUND_Y),a2
	sll	16,a2
	cmp	a0,a2			;a2-a0
	jrlt	#ok
	;we're under ground...  Unless we're attached and set MODE_GHOST,
	; stay above.
	move	*a13(ATTACH_PROC),a14,L
	jrz	#set_ground_y
	move	*a14(ATTACH_PROC),a14,L
	jrz	#set_ground_y
	move	*a13(ANIMODE),a14,L
	btst	MODE_GHOST_BIT,a14
	jrnz	#ok

#set_ground_y
	move	a2,a0
#ok
	move	a0,*a13(OBJ_YPOS),L

	move	*a13(OBJ_ZPOS),a0,L
	move	*a13(OBJ_ZVEL),a1,L
	add	a1,a0
	move	a0,*a13(OBJ_ZPOS),L

	move	*a13(ANIMODE),a0
	btst	MODE_NOGRAVITY_BIT,a0
	jrnz	#no_gravity

	move	*a13(GROUND_Y),a0
	sll	16,a0
	move	*a13(OBJ_YPOS),a1,L
	cmp	a0,a1
	jreq	#no_gravity

	move	*a13(OBJ_YVEL),a0,L
	move	*a13(OBJ_GRAVITY),a14,L
	sub	a14,a0
	cmpi	MAX_YVEL,a0
	jrge	#grav_ok
	movi	MAX_YVEL,a0
#grav_ok
	move	a0,*a13(OBJ_YVEL),L
#no_gravity

#x
	rets


#*****************************************************************************

 SUBRP	calc_ground_y

	move	*a13(INRING),a0
	jrz	#inring

	movi	117,a1
	move	*a13(OBJ_ZPOSINT),a0
	cmpi	05bdh,a0
	jrgt	#setit

	movi	103,a1
	jruc	#setit

#inring
	movi	112,a1

#setit
	move	a1,*a13(OBJ_PRIORITY)

	movi	vln_right_matedge,a6
	calla	calc_line_x
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;a1-a0
	jrge	#outside

	movi	vln_left_matedge,a6
	calla	calc_line_x
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;a1-a0
	jrle	#outside


	;an unsuccessful attempt to fix throw-into-ring bug
	;-we fucked up climbins from behind
	;trying again - climbin top and bottom weren't setting this flag!
	move	*a13(CLIMBING_THRU),a14
	jrz	#skip

	movi	MAT_Y,a0
	move	a0,*a13(GROUND_Y)

	clr	a0
	move	a0,*a13(INRING)
	rets

#outside
	clr	a0
	move	a0,*a13(GROUND_Y)
	MOVE	@GAMSTATE,A0
	CMPI	INPREGAME2,A0
	jreq	#skip

	movk	1,a0
	move	a0,*a13(INRING)
#skip
	rets


#*****************************************************************************
 .if 0

PATCH FOR SCROLLER

#MAX_DIST	equ	380

	move	@PSTATUS,a14
	cmpi	3,a14			;is it a 2-player game?
	jrne	#no_2_player

	move	@process_ptrs,a10,L	;player 1
	move	@process_ptrs+20h,a11,L	;player 2

	move	*a10(OBJ_XPOSINT),a0	;p1 x
	move	*a11(OBJ_XPOSINT),a1	;p2 x

	sub	a0,a1			;a1-a0
	abs	a1
	cmpi	#MAX_DIST,a1
	jrlt	#ok

;the 2 human wrestlers are too far apart
;now bias towards the guy in the ring -
;(since the only way this should be able to happen is when
;both guys are outside the ring, and 1 jumps back in - ignoring
;the keep_onscreen code).


#ok
#no_2_player


 .endif

#*****************************************************************************
*
* a0 = * wrestler process
*

 SUBR	wres_get_but_val_down

	move	*a0(PLYR_TYPE),a14
	jrnz	#drndt
	move	*a0(PLYRNUM),a0
	callr	get_but_val_down
	rets

#drndt
	move	*a0(DRN_BUTDT),a0
	rets

#*****************************************************************************

 SUBR	wres_get_but_val_cur

	move	*a0(PLYR_TYPE),a14
	jrnz	#drndt
	move	*a0(PLYRNUM),a0
	callr	get_but_val_cur
	rets

#drndt
	move	*a0(DRN_BUT),a0
	rets

#*****************************************************************************

 SUBR	wres_get_but_val_up

	move	*a0(PLYR_TYPE),a14
	jrnz	#drnut
	move	*a0(PLYRNUM),a0
	callr	get_but_val_up
	rets

#drnut
	move	*a0(DRN_BUTUT),a0
	rets

#*****************************************************************************

 SUBR	wres_get_stick_val_cur

	move	*a0(PLYR_TYPE),a14
	jrnz	drn_joy
	move	*a0(PLYRNUM),a0
	callr	get_stick_val_cur
	rets

drn_joy
	move	*a0(DRN_JOY),a0
	rets


#*****************************************************************************

  SUBR	wres_get_stick_rel_cur


	move	*a0(PLYR_TYPE),a14
	jrnz	drn_joy
	move	*a0(OBJ_CONTROL),a14
	move	*a0(PLYRNUM),a0
	callr	get_stick_val_cur
	btst	B_FLIPH,a14
	jrz	#done

	X16	a0
	addi	#xflip_table,a0
	move	*a0,a0
#done
	rets



;returns a value only if stick val
;has changed (but not zero)

  SUBR	wres_get_stick_rel_new


	move	*a0(PLYR_TYPE),a14
	jrnz	#not_human2

;shawn - this needs patching too...

	push	a1,a10

	move	a0,a10
	move	*a10(PLYRNUM),a0
	callr	get_stick_val_up
	push	a0

	move	*a10(PLYRNUM),a0
	callr	get_stick_val_down
	pull	a1
	or	a1,a0
	jrz	#done2		;no stick

	move	*a10(OBJ_CONTROL),a14
	move	*a10(PLYRNUM),a0
	callr	get_stick_val_cur
	btst	B_FLIPH,a14
	jrz	#done2

	X16	a0
	addi	#xflip_table,a0
	move	*a0,a0
#done2
	pull	a1,a10
	rets


#not_human2
	move	a0,a14
	move	*a14(DRN_JOYDT),a0
	move	*a14(DRN_JOYUT),a1
	or	a1,a0
	jrz	#dx
	move	*a14(DRN_JOY),a0
	move	*a14(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#dx

	X16	a0
	addi	#xflip_table,a0
	move	*a0,a0
#dx
	rets


#xflip_table	;convert to forward / away  if facing left
	.word	0000b	;0
	.word	0001b	;1
	.word	0010b	;2
	.word	0011b	;3
	.word	1000b	;4
	.word	1001b	;5
	.word	1010b	;6
	.word	1011b	;7
	.word	0100b	;8
	.word	0101b	;9
	.word	0110b	;10
	.word	0111b	;11
	.word	1100b	;12
	.word	1101b	;13
	.word	1110b	;14
	.word	1111b	;15

#*****************************************************************************

 SUBR	wres_get_stick_val_down

	move	*a0(PLYR_TYPE),a14
	jrnz	#drnjoy
	move	*a0(PLYRNUM),a0
	callr	get_stick_val_down
	rets

#drnjoy
	move	*a0(DRN_JOYDT),a0
	rets

#*****************************************************************************

 SUBR	wres_get_stick_val_up

	move	*a0(PLYR_TYPE),a14
	jrnz	#not_human
	move	*a0(PLYRNUM),a0
	callr	get_stick_val_up
	rets

#not_human
	move	*a0(DRN_JOYUT),a0
	rets

#*****************************************************************************
*
* INPUT:	a0 = player number (0-1)
*-----------------------------------------------------------------------------
*
* RETURN:	a0 = button bits
*-----------------------------------------------------------------------------

 SUBR	get_but_val_cur


	PUSH	a1
	move	a0,a1
	sll	4,a1			;x 16 bits
	addi	but_offs2,a1
	move	*a1,a1
	addi	switches_cur,a1
	move	*a1,a1
	andi	011000b,a1

	sll	4,a0			;x 16 bits
	addi	but_offs,a0
	move	*a0,a0
	addi	switches_cur,a0
	move	*a0,a0
	andi	0111b,a0
	or	a1,a0
	PULL	a1

	rets

#*****************************************************************************
*
* INPUT:	a0 = player number (0-3)
*-----------------------------------------------------------------------------
*
* RETURN:	a0 = joy switch bits
*-----------------------------------------------------------------------------

  SUBR	get_stick_val_cur


	sll	4,a0			;x 16 bits
	addi	joy_offs,a0
	move	*a0,a0
	addi	switches_cur,a0
	move	*a0,a0
	andi	01111b,a0
	rets

******************************************************************************
*
* INPUT:	a0 = player number (0-3)
*-----------------------------------------------------------------------------
*
* RETURN:	a0 = joy switch bits
*-----------------------------------------------------------------------------

  SUBR	get_stick_val_down

	sll	4,a0			;x 16 bits
	addi	joy_offs,a0
	move	*a0,a0
	addi	switches_down,a0
	move	*a0,a0
	andi	01111b,a0
	rets

******************************************************************************
*
* INPUT:	a0 = player number (0-3)
*-----------------------------------------------------------------------------
*
* RETURN:	a0 = joy switch bits
*-----------------------------------------------------------------------------

  SUBR	get_stick_val_up

	sll	4,a0			;x 16 bits
	addi	joy_offs,a0
	move	*a0,a0
	addi	switches_up,a0
	move	*a0,a0
	andi	01111b,a0
	rets

joy_offs	.word	00h,08h,20h,28h

******************************************************************************
*
* INPUT:	a0 = player number (0-1)
*-----------------------------------------------------------------------------
*
* RETURN:	a0 = button bits
*-----------------------------------------------------------------------------

 SUBR	get_but_val_down

	PUSH	a1
	move	a0,a1
	sll	4,a1			;x 16 bits
	addi	but_offs2,a1
	move	*a1,a1
	addi	switches_down,a1
	move	*a1,a1
	andi	011000b,a1

	sll	4,a0			;x 16 bits
	addi	but_offs,a0
	move	*a0,a0
	addi	switches_down,a0
	move	*a0,a0
	andi	0111b,a0
	or	a1,a0
	PULL	a1

	rets


******************************************************************************
*
* INPUT:	a0 = player number (0-1)
*-----------------------------------------------------------------------------
*
* RETURN:	a0 = button bits
*-----------------------------------------------------------------------------

 SUBR	get_but_val_up

	PUSH	a1
	move	a0,a1
	sll	4,a1			;x 16 bits
	addi	but_offs2,a1
	move	*a1,a1
	addi	switches_up,a1
	move	*a1,a1
	andi	011000b,a1

	sll	4,a0			;x 16 bits
	addi	but_offs,a0
	move	*a0,a0
	addi	switches_up,a0
	move	*a0,a0
	andi	0111b,a0
	or	a1,a0
	PULL	a1

	rets

but_offs	.word	04h,0ch,24h,2ch
but_offs2	.word	20h-3,24h-3

#*****************************************************************************
*
* sacrifice clarity for speed
* this reads all switch transitions once
* and stuffs them into the PDATA area


 SUBR	read_switches

;#wait
;	move	@vcount,a0
;	andi	31,a0
;	jrnz	#wait
;	TINTON

	movi	process_ptrs,a9
	movk	NUM_WRES,a11
#next
	move	*a9+,a10,L
	jrz	#skip

	;ignore all switches if wrestler is immobilized
	move	*a10(IMMOBILIZE_TIME),a14
	jrp	#immob

	move	*a10(PLYR_TYPE),a14
	jrz	#no_drone

#drone
	move	*a10(DRN_BUT),*a10(BUT_VAL_CUR)
	move	*a10(DRN_BUTDT),*a10(BUT_VAL_DOWN)
	move	*a10(DRN_BUTUT),*a10(BUT_VAL_UP)

	move	*a10(DRN_JOY),*a10(STICK_VAL_CUR)
	move	*a10(DRN_JOYDT),*a10(STICK_VAL_DOWN)
	move	*a10(DRN_JOYUT),*a10(STICK_VAL_UP)
	jruc	#cont

#immob	clr	a14
	move	a14,*a10(BUT_VAL_CUR)
	move	a14,*a10(BUT_VAL_DOWN)
	move	a14,*a10(BUT_VAL_UP)
	move	a14,*a10(STICK_VAL_CUR)
	move	a14,*a10(STICK_VAL_DOWN)
	move	a14,*a10(STICK_VAL_UP)
	move	a14,*a10(STICK_REL_CUR)
	move	a14,*a10(STICK_REL_NEW)
	jruc	#skip

#no_drone
	move	*a10(PLYRNUM),a8

	move	a8,a1
	X16	a1
	move	a1,a0
	addi	joy_offs,a0
	move	*a0,a5		;joy offset

	move	a1,a0
	addi	but_offs,a0
	move	*a0,a6		;switch offset1

	move	a1,a0
	addi	but_offs2,a0
	move	*a0,a7		;switch offset2

;wres_get_but_val_cur

	move	a7,a1		;switch offset2
	addi	switches_cur,a1
	move	*a1,a1
	andi	011000b,a1

	move	a6,a0		;switch offset1
	addi	switches_cur,a0
	move	*a0,a0
	andi	0111b,a0
	or	a1,a0
	move	a0,*a10(BUT_VAL_CUR)


;wres_get_but_val_down

	move	a7,a1		;switch offset2
	addi	switches_down,a1
	move	*a1,a1
	andi	011000b,a1

	move	a6,a0		;switch offset1
	addi	switches_down,a0
	move	*a0,a0
	andi	0111b,a0
	or	a1,a0
	move	a0,*a10(BUT_VAL_DOWN)


;wres_get_but_val_up

	move	a7,a1		;switch offset2
	addi	switches_up,a1
	move	*a1,a1
	andi	011000b,a1

	move	a6,a0		;switch offset1
	addi	switches_up,a0
	move	*a0,a0
	andi	0111b,a0
	or	a1,a0
	move	a0,*a10(BUT_VAL_UP)


;wres_get_stick_val_cur
	move	a5,a0		;joy offset
	addi	switches_cur,a0
	move	*a0,a0
	andi	01111b,a0
	move	a0,*a10(STICK_VAL_CUR)


;wres_get_stick_val_down
	move	a5,a0		;joy offset
	addi	switches_down,a0
	move	*a0,a0
	andi	01111b,a0
	move	a0,*a10(STICK_VAL_DOWN)


;wres_get_stick_val_up
	move	a5,a0		;joy offset
	addi	switches_up,a0
	move	*a0,a0
	andi	01111b,a0
	move	a0,*a10(STICK_VAL_UP)

#cont
;wres_get_stick_rel_cur
;facing reletive joystick value

	move	*a10(STICK_VAL_CUR),a0
	move	*a10(FACING_DIR),a14
	btst	PLAYER_RIGHT_BIT,a14
	jrnz	#no_flip
	X16	a0
	addi	#xflip_table,a0
	move	*a0,a0
#no_flip
	move	a0,*a10(STICK_REL_CUR)


;wres_get_stick_rel_new
;returns a value only if stick val
;has changed (but not zero)

	move	*a10(STICK_VAL_UP),a0
	move	*a10(STICK_VAL_DOWN),a1
	or	a1,a0
	jrz	#no_stick
	move	*a10(STICK_VAL_CUR),a0
	move	*a10(FACING_DIR),a14
	btst	PLAYER_RIGHT_BIT,a14
	jrnz	#no_flip2
	X16	a0
	addi	#xflip_table,a0
	move	*a0,a0
#no_flip2
#no_stick
	move	a0,*a10(STICK_REL_NEW)


#skip
	dsj	a11,#next
; TINTOFF

	rets



#xflip_table	;convert to forward / away  if facing left
	.word	0000b	;0
	.word	0001b	;1
	.word	0010b	;2
	.word	0011b	;3
	.word	1000b	;4
	.word	1001b	;5
	.word	1010b	;6
	.word	1011b	;7
	.word	0100b	;8
	.word	0101b	;9
	.word	0110b	;10
	.word	0111b	;11
	.word	1100b	;12
	.word	1101b	;13
	.word	1110b	;14
	.word	1111b	;15


;#*****************************************************************************
;*
;* puts you in mode_blocking if your safe_time is set. (or if you're a drone)
;* called from anim scripts with an ANI_CODE.
;
; SUBR	block_if_safe
;
;	move	*a13(PLYR_TYPE),a14
;	cmpi	PTYPE_DRONE,a14
;	jreq	#safe
;
;	move	*a13(SAFE_TIME),a14
;	jrz	#not_safe
;
;#safe	movk	MODE_BLOCK,a14
;	move	a14,*a13(PLYRMODE)
;
;#not_safe
;	rets

#*****************************************************************************
*
* Call at the beginning of any turnbuckle attack.  This sets the NOCONFINE
* bit if any live opponents are outside the ring, or clears it otherwise.
*
* HOWEVER, if everyone is dead, it checks simply for active wrestlers outside,
* not just live ones.
*
* ...except for yoko.  He can't jump out.
*

 SUBR	set_tbukl_confine

	move	*a13(WRESTLERNUM),a14
	cmpi	W_YOKO,a14
	jreq	#clear_noconfine

	;a3 is the 'everyone is dead' flag.
	clr	a3
	move	*a13(CLOSEST_NUM),a1
	calla	get_process_ptr
	move	*a0(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jrne	#dfset

	inc	a3		;entire other team is dead.

#dfset	movi	process_ptrs,a0,L
	movk	NUM_WRES,a10
	move	*a13(PLYR_SIDE),a2
#loop
	move	*a0+,a1,L
	jrz	#nxt		;skip inactive

	cmp	a1,a13
	jreq	#nxt		;skip self

	move	*a1(PLYR_SIDE),a14
	cmp	a14,a2
	jreq	#nxt		;skip teammates

	;skip the dead check if everyone on enemy side is dead
	TEST	a3
	jrnz	#nsd

	move	*a1(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#nxt		;skip dead

#nsd	move	*a1(INRING),a14
	jrnz	#set_noconfine

#nxt	dsj	a10,#loop
	;fall through
#clear_noconfine

	;he might have drifted out already, so we gotta yank 'em back in.
	move	*a13(INRING),a14
	jrz	#in

	;rats.  he's out.  fix it.
	clr	a14
	move	a14,*a13(INRING)
	movi	MAT_Y,a14
	move	a14,*a13(GROUND_Y)
	move	*a13(OBJ_ZPOSINT),a14
	cmpi	RING_TOP,a14
	jrge	#zok
	movi	RING_TOP,a14
	move	a14,*a13(OBJ_ZPOSINT)
#zok	move	*a13(OBJ_XPOSINT),a2
	cmpi	RING_X_CENTER,a2
	jrgt	#rt

	;on left
	movi	vln_left_rope,a6
	calla	calc_line_x
	jrz	#xok		;bad news.  leave it alone.
	cmp	a0,a2
	jrge	#xok
	move	a0,*a13(OBJ_XPOSINT)
	jruc	#xok

#rt	;on right
	movi	vln_right_rope,a6
	calla	calc_line_x
	jrz	#xok		;bad news.  leave it alone.
	cmp	a0,a2
	jrle	#xok
	move	a0,*a13(OBJ_XPOSINT)

#xok
#in	move	*a13(ANIMODE),a14
	andni	MODE_NOCONFINE,a14
	jruc	#cont

#set_noconfine
	move	*a13(ANIMODE),a14
	ori	MODE_NOCONFINE,a14
#cont
	move	a14,*a13(ANIMODE)
	rets


;#*****************************************************************************
;*
;* Call with ANI_CODE when a turnbuckle attack misses.  This does four pixels
;* of damage, or health-1, whichever is less.
;
; SUBR	tbukl_miss_damage
;
;	move	*a13(PLYRNUM),a1
;	calla	get_health
;	dec	a0
;	jrle	#done
;	movk	4,a14
;	cmp	a14,a0
;	jrle	#ok
;	move	a14,a0
;#ok	neg	a0
;	clr	a10
;	calla	adjust_health
;#done	rets


	.if DEBUG
#*****************************************************************************
	.ref	CPUAVG

 SUBR	draw_dma_meter

	movi	DIAGP,a0
	calla	pal_getf
	move	a0,a1
	ori	>0E0E0000,a1
	movi	[1,400],a2
	move	@dma_bog,a3
	sll	16,a3
	clr	a4
	movi	DMACAL,a5
	calla	QDMAN
	rets

#*****************************************************************************

 SUBR	draw_cpu_meter

	movi	DIAGP,a0
	calla	pal_getf
	move	a0,a1
	ori	>0D0D0000,a1
	movi	[1,400],a2
	move	@CPUAVG,a3
	sll	14,a3
	clr	a4
	movi	DMACAL,a5
	calla	QDMAN
	rets

	.endif

#*****************************************************************************

 SUBR	COLRPRC
	movi	COLRPID,a0
	calla	KIL1C		;KILL ALL COLOR UPDATE PROCESSES
	clr	a0
	move	a0,@PALFRAM,L
;	movi	scorep,a0	;Score area palette
	jauc	pal_getf


#*****************************************************************************
*
* call this at the top of any anim sequence that requires that you be
* attached before you get there, like any of the pile-drivers, vertical
* suplexes, and so forth.  This checks for a good link, and bitches up
* a storm if it doesn't find one.

 SUBR	link_check

	.if DEBUG
	move	*a13(ATTACH_PROC),a14,L
	jrnz	#ok1

	LOCKUP	;I'm not attached!
	nop

#ok1	move	*a14(ATTACH_PROC),a14,L
	jrnz	#ok2
	LOCKUP	;I'm attached, but he's not attached to me!
	nop

#ok2	cmp	a14,a13
	jreq	#ok3
	LOCKUP	;We're both attached, but not to each other!
	nop

	.endif
#ok3	rets

#*****************************************************************************
*
* clears CLIMBING_THRU flag and sets SAFE_TIME to 1, which won't do you
* any good unless you're holding block.  Call this at the end of any
* rope climb-through anim.

 SUBR	clr_climb

	clr	a0
	move	a0,*a13(CLIMBING_THRU)		;1=Climbing thru ropes flag

	inc	a0
	move	a0,*a13(SAFE_TIME)

	rets


#*****************************************************************************
*
* returns carry set if one of a13's teammates has done a pin this round.
*
* trashes scratch

 SUBR	ck_teammate_pin

	PUSH	a2,a3

	movk	NUM_WRES,a0
	movi	process_ptrs,a1
	move	*a13(PLYR_SIDE),a2

#lp	move	*a1+,a3,L
	jrz	#nxt		;skip inactive

	cmp	a3,a13
	jreq	#nxt		;skip self

	move	*a3(PLYR_SIDE),a14
	cmp	a14,a2
	jrne	#nxt		;skip enemies

	move	*a3(STATUS_FLAGS),a14
	btst	B_DID_PIN,a14
	jrz	#nxt		;skip guys who didn't pin

	;got a pinning teammate
	PULL	a2,a3
	setc
	rets

#nxt	dsj	a0,#lp

	;no pinning teammates
	PULL	a2,a3
	clrc
	rets

#*****************************************************************************
*
* rummage through process_ptrs and decide which pal this wrestler should
* get.  return pal ptr in b0
*
* trashes a0,a1,a2,a3, and a14.

 SUBR	choose_pal

	;assign pals in PLYRNUM order.  There's four in the table for
	; each wrestler.

	.if 1
	; First check to see if there are 2 human players and they are
	; playing the same wrestler
	move	@PSTATUS,a14		; Get status
	cmpi	3,a14			; Do we have 2 humans playing ?
	jrnz	#pp_go			; br = no

	;if buddy mode, choose special pals
	move	@buddy_mode_on,a14
	jrnz	#buddy_mode

	clr	a2
	clr	a14
	neg	a14
	movi	process_ptrs,a0
#f_loop
	move	*a0+,a3,L
	jrz	#f_done
	move	*a3(PLYRNUM),a4
	jrnz	#not_p1
	move	*a3(WRESTLERNUM),a2
#not_p1
	cmpi	1,a4
	jrnz	#not_p2
	move	*a3(WRESTLERNUM),a14
#not_p2
	jruc	#f_loop
#f_done
	move	a14,a14			; Does player 2 exist ?
	jrn	#pp_go			; br = no
	cmp	a2,a14			; Are player 1 and 2 same wrestler ?
	jrnz	#pp_go			; br = no (no need to adjust pals)
	move	@player_pal_pref,a0	; Get player 1 palette preference
	cmpi	7,a0			; Is it last palette ?
	jrnz	#set_pal		; br = no
	movk	2,a0			; force a palette above what'll be used by drones
#set_pal
	move	a0,@player_pal_pref+10h	; Set player 2 palette
#pp_go
	.endif

	;count identical wrestlers with lower PLYRNUMs.
	movi	process_ptrs,a0
	clr	a4			; match count
	move	*a13(PLYRNUM),a2	; Get player number
	cmpi	2,a2			; Are we human ?
	jrge	#not_player		; br = no
	X16	a2			; Get playre palette preference
	addi	player_pal_pref,a2
	move	*a2,a4			; Init the counter to preference
#not_player
	move	*a13(WRESTLERNUM),a1

	;loop from 0 to our PLYRNUM looking for matches, UNLESS we're a
	; drone doink, in which case we just check 0 and 1.
	move	*a13(PLYRNUM),a2
	jrz	#end0
	cmpi	2,a2		;first drone is okay too.
	jrle	#lp0
	cmpi	W_DOINK,a1
	jrne	#lp0
	movk	2,a2
#lp0	move	*a0+,a3,L
	jrz	#nxt0		;skip inactive
	move	*a3(WRESTLERNUM),a14
	cmp	a1,a14
	jrne	#nxt0
	inc	a4		;got a match--inc count
#nxt0	dsj	a2,#lp0
#end0	andi	7,a4
	X32	a4
	X256	a1
	add	a1,a4
	addi	#wrestler_pal_table,a4
	move	*a4,a14,L	
	move	a14,b0
	rets

#buddy_mode
	move	*a13(WRESTLERNUM),a0
	X64	a0
	move	*a13(PLYR_SIDE),a14
	X32	a14
	add	a14,a0
	addi	#buddy_mode_pals,a0
	move	*a0,a14,L
	move	a14,b0
	rets

#wrestler_pal_table
	;                                            pnch     ppnch    kick     pkick
	REFLONG	HRTPNK_P,HRTBLU_P,HRTORG_P,HRTYEL_P,HRTRED_P,HRTGRN_P,HRTPRP_P,HRTGRY_P	;(Bret)
	REFLONG	RZRGRN_P,RZRPRP_P,RZRYEL_P,RZRORG_P,RZRPNK_P,RZRBLU_P,RZRRED_P,RZRGRY_P	;(Razor)
	REFLONG	UNDPRP_P,UNDBLK_P,UNDGRN_P,UNDORG_P,UNDPNK_P,UNDBLU_P,UNDYEL_P,UNDRED_P	;(Taker)
	REFLONG	YOKRED_P,YOKPRP_P,YOKYEL_P,YOKORG_P,YOKPNK_P,YOKBLU_P,YOKGRN_P,YOKGRY_P	;(Yoko)
	REFLONG	SHNRED_P,SHNPRP_P,SHNORG_P,SHNGRN_P,SHNPNK_P,SHNBLU_P,SHNYEL_P,SHNGRY_P	;(Shawn)
	REFLONG	BAMBLU_P,BAMYLW_P,BAMPRP_P,BAMORG_P,BAMPNK_P,BAMRED_P,BAMGRN_P,BAMGRY_P	;(Bam Bam)
	REFLONG	DNKBLU_P,DNKPRP_P,DNKORG_P,DNKRED_P,DNKPNK_P,DNKGRN_P,DNKYEL_P,DNKGRY_P	;(Doink)
	.long	0,0,0,0,0,0,0,0
	REFLONG	LEXWHT_P,LEXPRP_P,LEXRED_P,LEXYEL_P,LEXGRN_P,LEXPNK_P,LEXORG_P,LEXGRY_P	;(Lex)

#buddy_mode_pals
	.long	HRTBLU_P,HRTRED_P
	.long	RZRBLU_P,RZRRED_P
	.long	UNDBLU_P,UNDRED_P
	.long	YOKBLU_P,YOKRED_P
	.long	SHNBLU_P,SHNRED_P
	.long	BAMBLU_P,BAMRED_P
	.long	DNKBLU_P,DNKRED_P
	.long	0,0
	.long	LEXPRP_P,LEXRED_P

#*****************************************************************************
* Sets PLYR_TYPE to PTYPE_PLAYER if PLYRNUM < 2.
*
* >a13 = process *

 SUBR	drone_change_back

	move	*a13(PLYRNUM),a14
	cmpi	2,a14
	jrge	#done			;don't check real drones

	;don't bother checking if they're a drone or not.  In either case,
	; turning them human again won't hurt.
	movi	PTYPE_PLAYER,a14
	move	a14,*a13(PLYR_TYPE)
#done	rets


#*****************************************************************************
* (called by animation system)
*

 SUBR	start_run_flung

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETFACING		;so the offset works properly
	WL	ANI_CODE,#x_flip
	.word	ANI_OFFSET,20,0,0
	WL	ANI_CODE,#ok2
	.word	ANI_GETUP,FLUNG_TIME			;Flung time
	.word	ANI_END

 SUBR	start_run_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
;Is this a good idea?
	.word	ANI_DETACH
	WL	ANI_CODE,#setup_run
	.word	ANI_END

#setup_run
;	move	a13,a0
;	calla	wres_get_stick_val_cur
	PUSH	a1
;	movk	4,a1
	movk	1,a1
	calla	dufus_msg_off
	PULL	a1
	move	*a13(STICK_VAL_CUR),a0
	andi	MOVE_LEFT+MOVE_RIGHT,a0
	jrnz	#use_joy1

	move	*a13(FACING_DIR),a0	;use facing
	andi	MOVE_LEFT+MOVE_RIGHT,a0
#use_joy1
	move	*a13(FACING_DIR),a1
	andi	MOVE_LEFT+MOVE_RIGHT,a1
	cmp	a0,a1
	jrz	#ok1

;He wants to run in the opposite direction than he is facing
;Rotate him around first.

	move	*a13(FACING_DIR),a1
	andi	MOVE_UP+MOVE_DOWN,a1
	or	a1,a0
	move	a0,*a13(NEW_FACING_DIR)
	move	a0,*a13(FACING_DIR)

;	callr	set_rotate_anim
;	move	a13,a2				;a2 = * process
;	calla	change_anim_anim

#ok1
;	movi	#dorun,a0			;this routine gets executed
	jruc	#dorun
	jruc	#contx
#ok2
;Whenever you fling someone, a meter can & will appear
	clr	a0
	move	a0,*a13(DELAY_METER)
	movi	#dorun_flung,a0			;this routine gets executed
#contx
	move	a0,*a13(CODE_ADDR),L		;when the rotate anim
	SETMODE	WAITANIM			;finishes

	move	*a13(OBJ_XVEL),a0,L
	sra	1,a0
	move	a0,*a13(OBJ_XVEL),L
	clr	a0
	move	a0,*a13(OBJ_ZVEL),L

	rets

#x_flip
	move	*a13(FACING_DIR),a14
	xori	>0C,a14
	move	a14,*a13(FACING_DIR)
	rets

#dorun
	clr	a0
	move	a0,*a13(GETUP_TIME)	;in control

#dorun_flung
	clr	a0
	move	a0,*a13(USR_VAR1)	;with x-xel
	move	a0,*a13(RUN_TIME)


;Bogosity..
	move	*a13(FACING_DIR),a0	;use facing
;;	move	*a13(NEW_FACING_DIR),a0	;use facing

;	move	*a13(WHOHITME),a14,L
;	move	*a14(FACING_DIR),a0
;	andi	MOVE_LEFT+MOVE_RIGHT,a0
;	xori	0ch,a0

#ok
	move	a0,*a13(MOVE_DIR)

	move	*a13(NEW_FACING_DIR),a1
	andi	MOVE_UP+MOVE_DOWN,a1
	or	a0,a1			;LEFT or RIGHT
	move	a1,*a13(FACING_DIR)	;face same dir as run

	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	#run_anims,a0
	move	*a0,a0,L		;run anim
	calla	change_anim1a

	SETMODE	RUNNING

	movk	1,a0
	move	a0,*a13(DELAY_BUTNS)

	rets

	.ref	bam_run_anim
	.ref	dnk_run_anim
	.ref	hrt_run_anim
	.ref	lex_run_anim
	.ref	rzr_run_anim
	.ref	shn_run_anim
	.ref	und_run_anim
	.ref	yok_run_anim

#run_anims
	.long	hrt_run_anim	;0 Bret Hart
	.long	rzr_run_anim	;1 Razor Ramon
	.long	und_run_anim	;2 Undertaker
	.long	yok_run_anim	;3 Yokozuna
	.long	shn_run_anim	;4 Shawn Michaels
	.long	bam_run_anim	;5 Bam Bam
	.long	dnk_run_anim	;6 Doink
	.long	dnk_run_anim	;7 spare
	.long	lex_run_anim	;8 Lex Luger
	.long	dnk_run_anim	;9 Referee


#*****************************************************************************

 SUBR	flash_white

	movi	[1111h,0000h],a1	;[color,pal]
	movi	[256,400],a2		;[Ysz,Xsz]
	clr	a3			;[Ypos,Xpos]
	clr	a4			;SAG
	movi	DMACAL,a5		;[offset,ctrl]
	calla	QDMAN
	rets

 SUBR	flash_red

	movi	[1b1bh,0000h],a1	;[color,pal]
	movi	[256,400],a2		;[Ysz,Xsz]
	clr	a3			;[Ypos,Xpos]
	clr	a4			;SAG
	movi	DMACAL,a5		;[offset,ctrl]
	calla	QDMAN
	rets

#*****************************************************************************
*
* return carry set if wrestler a0 has any living teammates. (excluding self)
*
* trashes scratch

 SUBR	ck_live_teammates

	PUSH	a2,a3,a4

	move	*a0(PLYR_SIDE),a1
	movi	process_ptrs,a2
	movk	NUM_WRES,a3
#lp	move	*a2+,a4,L
	jrz	#nxt		;skip inactive
	cmp	a4,a0
	jreq	#nxt		;skip self
	move	*a4(PLYR_SIDE),a14
	cmp	a14,a1
	jrne	#nxt		;skip other team
	move	*a4(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#nxt		;skip dead

	;found live teammate.
	PULL	a2,a3,a4
	setc
	rets

#nxt	dsj	a3,#lp
	PULL	a2,a3,a4
	clrc
	rets
	
	

#*****************************************************************************
*
* return carry set if wrestler a0 has any teammates, living or dead.
*
* trashes scratch

 SUBR	ck_any_teammates

	PUSH	a2,a3,a4

	move	*a0(PLYR_SIDE),a1
	movi	process_ptrs,a2
	movk	NUM_WRES,a3
#lp	move	*a2+,a4,L
	jrz	#nxt		;skip inactive
	cmp	a4,a0
	jreq	#nxt		;skip self
	move	*a4(PLYR_SIDE),a14
	cmp	a14,a1
	jrne	#nxt		;skip other team

	;found a teammate.
	PULL	a2,a3,a4
	setc
	rets

#nxt	dsj	a3,#lp
	PULL	a2,a3,a4
	clrc
	rets
	
	

#*****************************************************************************
*
* set smart_attack bit and set smart_target to *a13(WHOIHIT).
*

 SUBR	target_whoihit

	move	*a13(STATUS_FLAGS),a14
	ori	M_SMART_ATTACK,a14
	move	a14,*a13(STATUS_FLAGS)

	move	*a13(WHOIHIT),*a13(SMART_TARGET),L
	rets

#*****************************************************************************
*
* If all of a13's opponents are dead and !zombie, and a13 is either outside
* or all his opponents are outside, setc and rets.  else clrc and rets.

 SUBR	raisearm_check

	;if a13 is human and this is a royal rumble, make sure @FINAL_PTR is
	;FFh.  If it isn't, don't raise arm.
	move	@royal_rumble,a14
	jrz	#hack_done
	move	*a13(PLYR_TYPE),a14
	jrnz	#hack_done		;PLAYER=0
	move	@FINAL_PTR,a14,L
	move	*a14,a14
	jrn	#hack_done
	jruc	#clrc			;no good
#hack_done

	move	*a13(PLYR_SIDE),a0

	movk	NUM_WRES,a1
	movi	process_ptrs,a2
	clr	a4		;'is any opponent inside' flag.

#lp	move	*a2+,a3,L
	jrz	#nxt		;skip inactive

	move	*a3(PLYR_SIDE),a14
	cmp	a14,a0
	jreq	#nxt		;skip a13 and teammates

	move	*a3(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jrne	#clrc		;opp dead?

	move	*a3(STATUS_FLAGS),a14,L
	btst	B_ZOMBIE,a14
	jrnz	#clrc		;zombie?

	move	*a3(INRING),a3
	jrnz	#nxt

	;dead !zombie bad guy is inside.  set a4
	inc	a4
#nxt	dsj	a1,#lp

	;okay, all our opponents are dead and staying that way.  now check
	; the inside/outside stuff.
	move	*a13(INRING),a14
	jrnz	#setc		;am I outside?

	TEST	a4
	jrnz	#clrc		;is any opponent inside?

#setc	setc
	rets

#clrc	clrc
	rets

#*****************************************************************************
*
* Set WHOIHIT to closest opponent.  Call this after you do a LEAPAT in your
* pin.  Since pins don't actually attack, we need to do this so that WHOIHIT
* is correct when we call grnd_hit.  We can't use CLOSEST in grnd_hit, since
* it's possible to land closer to someone else than the guy you meant to pin.
* ONLY USE THIS IN PINS!!!!!!!!!!!!!! Cuz it also sets the PINNED bit.
*

 SUBR	hit_nearest

	;set WHOIHIT and victim WHOPINNEDME
	move	*a13(CLOSEST_NUM),a0
	X32	a0
	addi	process_ptrs,a0
	move	*a0,a0,L
	move	a0,*a13(WHOIHIT),L
	move	a13,*a0(WHOPINNEDME),L

	;set victim's PINNED bit.
	move	*a0(STATUS_FLAGS),a14
	ori	M_PINNED,a14
	move	a14,*a0(STATUS_FLAGS)

	rets

#*****************************************************************************
*
* Change into another wrestler and re-enter the battle.  This should probably
* only be used in the king of the ring match.
*
* >a13 = pointer to process to change
*

 SUBR	change_wrestler

****	;change wrestlernum
	move	*a13(NEW_WRESTLERNUM),*a13(WRESTLERNUM)

****	;make the new special move processes
	callr	init_smoves

****	;change palette
	calla	choose_pal
	move	b0,a0
	calla	pal_getf

	move	a0,*a13(OBJ_PAL)
	move	a0,*a13(MY_PAL)
	movk	MAX_PIECES-1,a9
	move	*a13(OBJ_BASE),a1,L
	addk	20h,a1			;skip shadow
#nxt	move	*a1+,a8,L
	move	a0,*a8(OPAL)
	dsj	a9,#nxt

****	;re-initialize animation
	movi	MODE_NORMAL,a14
	move	a14,*a13(PLYRMODE)
	move	*a13(WRESTLERNUM),a9
	X64	a9
	addi	#init_anims,a9
	move	*a9+,a0,L
	calla	change_anim1a
	move	*a9,a0,L
	calla	change_anim2a

****	;reset STATUS_FLAGS
	clr	a14
	move	a14,*a13(STATUS_FLAGS),L

****	;reset life and combo data
	calla	init_wres_life_data

****	;clear I_WILL_DIE
	clr	a14
	move	a14,*a13(I_WILL_DIE)

****	;set new position
	movi	#init_positions,a0
#lp1	move	*a0(#NXT),a14,W
	jrn	#usea0		;if last entry, use by default.

	;use current entry if:
	; X <= WORLDTLX-30 or
	; X >= WORLDTLX+400+30

	move	*a0(#XPOS),a1
	move	@WORLDTLX,a14,L
	sra	16,a14
	subk	30,a14
	cmp	a14,a1
	jrle	#usea0
	addi	460,a14
	cmp	a14,a1
	jrge	#usea0


#nxt1	addi	#SIZE,a0
	jruc	#lp1

#usea0	move	*a0(#XPOS),*a13(OBJ_XPOSINT)
	move	*a0(#ZPOS),*a13(OBJ_ZPOSINT)
	move	*a0(#YPOS),*a13(OBJ_YPOSINT)
	move	*a0(#YPOS),*a13(GROUND_Y)
	move	*a0(#INRING),*a13(INRING)

****	;clear old velocities
	clr	a14
	move	a14,*a13(OBJ_XVEL),L
	move	a14,*a13(OBJ_YVEL),L
	move	a14,*a13(OBJ_ZVEL),L

	rets


#init_anims
	REFLONG	hrt_stand4_anim,hrt_torso4_anim
	REFLONG	rzr_stand4_anim,rzr_torso4_anim
	REFLONG	und_stand4_anim,und_torso4_anim
	REFLONG	yok_stand4_anim,yok_torso4_anim
	REFLONG	shn_stand4_anim,shn_torso4_anim
	REFLONG	bam_stand4_anim,bam_torso4_anim
	REFLONG	dnk_stand4_anim,dnk_torso4_anim
	.long	0,0
	REFLONG	lex_stand4_anim,lex_torso4_anim


	;possible starting positions.  hunt until you find one that's
	; offscreen, then use it.  If none of them are offscreen (should
	; never happen,) use the last entry in the table.

	STRUCT	0
	WORD	#XPOS
	WORD	#ZPOS
	WORD	#YPOS
	WORD	#INRING
	LABEL	#SIZE
	WORD	#NXT	;first element of NEXT entry. check for -1.

	;XPOSINT, ZPOSINT, YPOSINT/GROUND_Y, INRING
#init_positions
	.word	RING_X_CENTER,RING_Z_CENTER,MAT_Y,0	;center
	.word	RING_TOP_LEFT,RING_Z_CENTER,MAT_Y,0	;center left
	.word	RING_TOP_RIGHT,RING_Z_CENTER,MAT_Y,0	;center right
	.word	RING_BOT_LEFT,RING_BOT,MAT_Y,0		;bottom left
	.word	RING_BOT_RIGHT,RING_BOT,MAT_Y,0		;bottom right
	.word	024Fh,060Eh,0,1				;outside left
	.word	060Eh,04ABh,0,1				;outside right
	.word	-1

#*****************************************************************************
*
* Kill all my special move processes.
*

 SUBR	kill_smove_procs

	PUSH	a2,a3

	;loop through the processes. Anything with a PID of SMOVE_PID, and
	; a PA8 that matches our a13 must go.
	move	@ACTIVE,a3,L
#lp0	move	a3,a2		;a2 = p->this
	jrz	#done0
	move	*a2,a3,L	;a3 = p->next
	move	*a2(PROCID),a14
	cmpi	SMOVE_PID,a14
	jrne	#lp0
	move	*a2(PA8),a14,L
	cmp	a14,a13
	jrne	#lp0

	;match.  kill this one
	move	a2,a0
	calla	KILL
	jruc	#lp0

#done0	PULL	a2,a3
	rets

#*****************************************************************************
*
* Check to make sure your opponent is at rest and staying that way.  Check
* to see if he's in the xxx_dead_anim.  And make sure he's in range.
* Oh, and make sure there aren't any zombies either.
*

 SUBR	can_pin

	;no pin if there are any zombies or live wrestler on other team
	movi	process_ptrs,a0
	movk	NUM_WRES,a1
	move	*a13(PLYR_SIDE),a3
#lp0	move	*a0+,a2,L
	jrz	#nxt0			;skip inactive
	move	*a2(PLYR_SIDE),a14
	cmp	a14,a3
	jreq	#nxt0			;skip teammates
	move	*a2(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jrne	#clrc
	move	*a2(STATUS_FLAGS),a14
	btst	B_ZOMBIE,a14
	jrnz	#clrc
#nxt0	dsjs	a1,#lp0

	;check range
	move	*a13(CLOSEST_DIST),a0
	cmpi	70h,a0
	jrgt	#clrc
	move	*a13(CLOSEST_ZDIST),a0
	cmpi	50h,a0
	jrgt	#clrc

	calla	get_opp_process

	move	*a0(STATUS_FLAGS),a14
	btst	B_PINABLE,a14
	jrz	#clrc

#setc	;just to be safe, set the PINNED bit on the guy
	move	*a0(STATUS_FLAGS),a14
	ori	M_PINNED,a14
	move	a14,*a0(STATUS_FLAGS)

	;and set his WHOPINNEDME
	move	a13,*a0(WHOPINNEDME),L

	;and zero his velocities
	clr	a14
	move	a14,*a0(OBJ_XVEL),L
	move	a14,*a0(OBJ_YVEL),L
	move	a14,*a0(OBJ_ZVEL),L

	;and set his PTIME to one and clear his KOD bit, 'cuz he's probably
	; been KO'd if he's a drone.
	movk	1,a14
	move	a14,*a0(PTIME)
	move	*a0(STATUS_FLAGS),a14
	andni	M_KOD,a14
	move	a14,*a0(STATUS_FLAGS)

	setc
	rets

#clrc	clrc
	rets

#*****************************************************************************
*
* Dead wrestlers sit here.

 SUBR	xxx_dead_anim

	.word	ANI_SETMODE,MODE_NOAUTOFLIP|MODE_UNINT
	.word	ANI_SETPLYRMODE,MODE_DEAD

	WL	ANI_CODE,#set_pinable_bit

	WL	ANI_CODE,#ko_if_drone

	.word	ANI_ROT		;just sit and do nothing



*****
* KO my process if I'm a drone.

 SUBRP	#ko_if_drone

	;don't go to sleep if this is an 8-on-1 or 8-on-2 match, UNLESS
	; wrestler_count is 0, which means there's no hope of becoming
	; a zombie.
	move	@royal_rumble,a14
	jrnz	#is8
	calla	is_8_on_1
	jrnc	#not8
#is8	move	@wrestler_count,a14
	jrnz	#rets
#not8

	move	*a13(PLYR_TYPE),a14
	cmpi	PTYPE_DRONE,a14
	jrne	#rets

	;don't KO if I've been pinned
	move	*a13(STATUS_FLAGS),a14
	btst	B_PINNED,a14
	jrnz	#rets

	;don't KO if our NO_KO bit is set.
	btst	B_NO_KO,a14
	jrnz	#rets

	ori	M_KOD,a14
	move	a14,*a13(STATUS_FLAGS)

#rets	rets

*****
* set the PINABLE bit in STATUS_FLAGS

 SUBRP	#set_pinable_bit

	move	*a13(STATUS_FLAGS),a14
	ori	M_PINABLE,a14
	move	a14,*a13(STATUS_FLAGS)
	rets

#*****************************************************************************
*
* This gets called once each MATCH for every wrestler, not each round.
* It creates the set of 'watchdog' processes that look out for special
* moves that the usual method can't handle; specifically, stuff that
* involves charging up with a stick, detailed control over timing, or
* proximity to the bad guy.
*

 SUBR	init_smoves

	move	*a13(WRESTLERNUM),a2,W
	X32	a2
	addi	#special_moves,a2
	move	*a2,a2,L
	jrz	#done

#loop
	move	*a2+,a7,L
	jrz	#done
	movi	SMOVE_PID,a1
	move	a13,a8
	calla	GETPRC_INSERT

	;store reset address
	move	*a0(PWAKE),*a0(SM_RESET_ADDRESS),L
	jruc	#loop

#done
	rets


#special_moves
	REFLONG	hrt_smove_table		;Bret
	REFLONG	rzr_smove_table		;Razor
	REFLONG	und_smove_table		;Taker
	REFLONG	yok_smove_table		;Yoko
	REFLONG	shn_smove_table		;Shawn
	REFLONG	bam_smove_table		;Bam Bam
	REFLONG	dnk_smove_table		;Doink
	.long	0			;spare
	REFLONG	lex_smove_table		;Lex

#*****************************************************************************

	.bss	#pin_timeout,16		;pin idiot check cntdown
	.bss	#last_dead,16		;PCNT last time we had a one-team
					; dead condition.	

 SUBR	match_timer

	movk	9,a0
	move	a0,@match_time		;10's
	move	a0,@match_time+10h	;1's
	clr	a0
	move	a0,@match_time+20h	;fractional

	callr	#create_timer

	SLEEP	TSEC*2

	movk	ADJSPEED,a0		;game timer speed (1-5)
	calla	GET_ADJ
	BADCHK	a0,1,5,3		;reg,lo,hi,val
	X16	a0			;x 16 bits
	addi	timer_table-10h,a0
	move	*a0,a1

	;slow the clock to 1/3 speed if this is the royal rumble
	move	@royal_rumble,a14
	jrnz	#isrum

	;slow the clock (2/3 speed) if it's 1v3.
	move	@PSTATUS,a14
	jrz	#nfin
	cmpi	3,a14
	jreq	#nfin

	move	@NUM_OPPS,a14
	cmpi	3,a14
	jrne	#nfin

#isrum	movi	>AAAA,a14
	mpyu	a14,a1
	srl	16,a1

	;slow it yet again (down to 1/3 speed) if this is the final battle,
	calla	is_final_match
	jrc	#isfin
	move	@royal_rumble,a14
	jrz	#nfin
#isfin	sra	1,a1

#nfin	move	a1,a10

	;initialize #last_dead
	clr	a14
	move	a14,@#last_dead

	;initialize #pin_timeout - we need to do this because one time in
	; 2^16, when we hit our first all-dead condition, PCNT will be 1,
	; and the code will think that this isn't a new condition and it
	; won't reset this value.  Hey, it could happen.
	movi	4*TSEC,a14
	move	a14,@#pin_timeout

#loop
	SLEEPK	1

	move	@HALT,a0
	jrnz	#loop

	move	@match_time,a0,L
	jrz	#loop

	;call #dec_timer and update_timer only if there's a live member
	; of every team. (for this purpose, zombies count as live members)

	callr	get_live_bits
	move	a0,a3

	cmpi	3,a3
	jrne	#1tmded		;a team is completely dead

	callr	#dec_timer
	callr	update_timer

	jruc	#loop

#1tmded	;one team is completely dead - wait five seconds, and if there's
	; no pin by then, award the round to the team that's sitting on
	; it's silly drone ass instead of pinning.

	;check #last_dead to see if this is a new all-dead condition or
	; an old one.  if it's a new one, we need to reset #pin_timeout.
	move	@PCNT,a14
	move	@#last_dead,a0
	sub	a0,a14
	dec	a14
	jrz	#old

	;new dead condition.  reset #pin_timeout.
	;temp! - 314
	.if DEBUG
	DBEVENT	BDE_ALL_DEAD,a13,L,a13,L,a13,L
	.endif

	movi	5*TSEC,a14
	move	a14,@#pin_timeout

	;clear reduce_bog.  if we're in 8-on-1 or 8-on-2 mode, clear this
	; only if the human team is dead, or the drones are dead and no
	; more are coming.
	move	@royal_rumble,a14
	jrnz	#ck8_2
	calla	is_8_on_1
	jrnc	#crb

#ck8_1	;check the 8-on-1 case
	move	@PSTATUS,a14
	and	a3,a14		;a3 is bit of live team
	jrz	#crb		;on z, human team is dead
	jruc	#dtd		;else dead team is drones

#ck8_2	;check the 8-on-2 case
	btst	0,a3		;team 0 is always humans in 8 on 2
	jrz	#crb		;on z, human team is dead

#dtd	;dead team is drones
	move	@wrestler_count,a14
	cmpi	1,a14
	jrge	#ncrb

#crb	clr	a14
	move	a14,@reduce_bog

	;wake the crowd
	move	@crowd_process,a0,L
	movk	1,a14
	move	a14,*a0(PTIME)


#ncrb	;create the PIN HIM message process.
	move	a3,a9
	xori	3,a9
	srl	1,a9		;a8 is dead team (0 or 1)
	CREATE	PINHIM_ANIM_PID,pin_prompt

#old	;update #last_dead
	move	@PCNT,a14
	move	a14,@#last_dead

	;dec pin_timeout and call the round if time's up.
	move	@#pin_timeout,a14
	jrz	#loop			;we've already called this round
	dec	a14
	jrz	#end			;time's up - do it.
	move	a14,@#pin_timeout
	jruc	#loop

#end
	CREATE	ANNC_PID,announce_rnd_winner
	.if DEBUG
	move	a13,*a0(PDATA),L	;#CREATOR (pdata)
	movi	$,a14
	move	a14,*a0(PDATA+20h),L	;#ORIGIN
	.endif

	;stuff a 0 in #pin_timeout so we'll know that there's no further
	; action to be taken on this all-dead condition.
	clr	a14
	move	a14,@#pin_timeout
	jruc	#loop


********************

#create_timer

	;set pal
	movi	WGFS_W_P,b0
	calla	is_8_on_1
	jrnc	#nfin2
	movi	WGSF_Y_P,b0

#nfin2	movi	[186,0],a0			;x pos
	movi	[21,0],a1			;y pos
	movi	WGSF20_9,a2
	movi	200,a3			;z pos
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	movi	TYPTIMERDIGIT,a5
	clr	a6				;x vel
	clr	a7				;y vel
	PUSH	b0
	calla	BEGINOBJP
	PULL	b0
	move	a8,*a13(PDATA+20h),L		;10's image pointer

	movi	[200+2,0],a0			;x pos
	movi	[21,0],a1			;y pos
	movi	WGSF20_9,a2
	calla	BEGINOBJP
	move	a8,*a13(PDATA),L		;1's image pointer

	rets

********************

#dec_timer
	move	@match_time,a0,L
	cmpi	090009h,a0
	jrne	#no_reset_pal
	movi	WGFS_W_P,a0
	calla	is_8_on_1
	jrnc	#nfin3
	movi	WGSF_Y_P,a0

#nfin3	calla	pal_getf
	move	*a13(PDATA+20h),a8,L	;10's image pointer
	move	a0,*a8(OPAL)
	move	*a13(PDATA),a8,L	;10's image pointer
	move	a0,*a8(OPAL)

#no_reset_pal

	move	@match_time+20h,a0	;fractional
	sub	a10,a0

	move	a0,@match_time+20h
	jrnc	#no_change

	move	@match_time+10h,a0	;1's
	dec	a0
	move	a0,@match_time+10h
	jrnc	#no_borrow

	movk	9,a0
	move	a0,@match_time+10h

	move	@match_time,a0		;10's
	dec	a0
	move	a0,@match_time

	cmpi	0,a0

	jrne	#no_borrow
	movi	WGSF_R_P,a0
	calla	pal_getf
	move	*a13(PDATA+20h),a8,L	;10's image pointer
	move	a0,*a8(OPAL)
	move	*a13(PDATA),a8,L	;10's image pointer
	move	a0,*a8(OPAL)

#no_borrow
	;if time is less than 15, make noise
	move	@match_time,a0,L
	move	a0,a1
	sra	16,a0
	andi	0Fh,a1
	sla	4,a1
	or	a1,a0
	cmpi	10h,a0
	jrgt	#no_change
	movk	10,a0			;Time warning sound
	calla	triple_sound

#no_change
	rets

timer_table
	.asg	1500,BASETM	;2100	;16

	.word	BASETM-BASETM*30/100	;1 (slowest)	;76.6 seconds/round
	.word	BASETM-BASETM*15/100	;2 (slower)
	.word	BASETM			;3 (default)	;53.6 seconds/round
	.word	BASETM+BASETM*15/100	;4 (faster)
	.word	BASETM+BASETM*30/100	;5 (fastest)	;41.2 seconds/round


********************

 SUBR	update_timer

	move	@match_time,a0		;10's
	.if DEBUG
	cmpi	10,a0
	jrlt	#ok1

	;clock digit out of range!
	LOCKUP
#ok1
	.endif

	X32	a0
	addi	digit_tbl,a0
	move	*a0,a0,L		;* image
	move	*a13(PDATA+20h),a8,L	;10's image pointer
	move	*a8(OCTRL),a1		;DMA flags
	calla	change_image

	move	@match_time+10h,a0	;1's
	.if DEBUG
	cmpi	10,a0
	jrlt	#ok2

	;clock digit out of range!
	LOCKUP
	.endif
#ok2

	X32	a0
	addi	digit_tbl,a0
	move	*a0,a0,L		;* image
	move	*a13(PDATA),a8,L	;1's image pointer
	move	*a8(OCTRL),a1		;DMA flags
	calla	change_image

	rets

#**********************************************
*
*

 SUBR	wrestler_counter

	movk	8,a9			; Initial wrestler count
	move	a9,@wrestler_count	; Initialize the count

;Turn on remaining word
	movi	[126h,0],a0
	clr	a11
	move	@PSTATUS,a14
	cmpi	3,a14
	jrz	#no_adj
	btst	1,a14
	jrz	#no_adj
	movi	[11ah,0],a11
#no_adj
	sub	a11,a0
	movi	[32h,0],a1
	movi	remaining,a2
name_z		equ	9
	movi	name_z,a3		;Z
	movi	DMAWNZ|M_SCRNREL,a4	;DMA flags
	movi	TYPWCCOUNT,a5		;Delete the last string
	clr	a6
	clr	a7
	movi	WSF_Y_P,b0
	calla	BEGINOBJP
	move	a8,a10

	movi	[17eh,0],a0
	sub	a11,a0
	movi	[32h,0],a1
	movi	WSF10_8,a2
	movi	name_z,a3		;Z
	movi	DMAWNZ|M_SCRNREL,a4	;DMA flags
	movi	TYPWCCOUNT,a5		;Delete the last string
	clr	a6
	clr	a7
	movi	WSF_Y_P,b0
	calla	BEGINOBJP

#wc_loop
	SLEEP	07fffh			; Sleep until woken up

	move	@wrestler_count,a14	; Get current count
	jrz	#wc_exit		; Is it 0 ? - br = yes
	cmp	a9,a14			; Has it changed from last time ?
	jrz	#wc_loop
	move	a14,a9			; Save for reprint

	move	@wrestler_count,a0	; Get current count
	X32	a0
	addi	#digit10_tbl,a0
	move	*a0,a0,L		;* image
	move	*a8(OCTRL),a1		;DMA flags
	calla	change_image
	
	jruc	#wc_loop		; Go redo it

#wc_exit
	clr	a0
	move	a0,@wrestler_count_proc,L

	calla	DELOBJA8
	move	a10,a8
	jauc	DELOBJDIE


#digit10_tbl
	.long	WSF10_0
	.long	WSF10_1
	.long	WSF10_2
	.long	WSF10_3
	.long	WSF10_4
	.long	WSF10_5
	.long	WSF10_6
	.long	WSF10_7
	.long	WSF10_8
	.long	WSF10_9


digit_tbl
	.long	WGSF20_0,WGSF20_1,WGSF20_2,WGSF20_3,WGSF20_4
	.long	WGSF20_5,WGSF20_6,WGSF20_7,WGSF20_8,WGSF20_9

#*****************************************************************************

 SUBR	maybe_do_flashes
#top	SLEEPK	5
	move	@reduce_bog,a1
	jrnz	#die
	MOVE	@WORLDTLY,A0,L
	CMPI	[>ff97,0],A0
	JRGT	#top
	CALLA	START_HI_FLASHES
	SLEEPK	30
	JRUC	#top
#die	DIE

#*****************************************************************************
*
* sets our DID_RAISEARM bit.

 SUBR	set_raisearm_bit

	move	*a13(STATUS_FLAGS),a14,L
	ori	M_DID_RAISEARM,a14
	move	a14,*a13(STATUS_FLAGS),L

	rets


#*****************************************************************************
*
* check our DID_RAISEARM bit--set MODE_STATUS bit if it's clear (ANI_CODE)

 SUBR	check_raisearm_bit

	move	*a13(STATUS_FLAGS),a14,L
	btst	B_DID_RAISEARM,a14
	jrz	#set

#clr	move	*a13(ANIMODE),a14
	andni	MODE_STATUS,a14
	move	a14,*a13(ANIMODE)
	rets

#set	move	*a13(ANIMODE),a14
	ori	MODE_STATUS,a14
	move	a14,*a13(ANIMODE)
	rets


#*****************************************************************************
*
* choose buddies for buddy mode.  return the wrestlernums in a0 and a1.

 SUBR	choose_buddies

	;prepare an exclusion mask
	clr	a7
	movk	1,a0
	move	@index1,a14
	sll	a14,a0
	or	a0,a7

	movk	1,a0
	move	@index2,a14
	sll	a14,a0
	or	a0,a7

	;count excluded wrestlers
	move	a7,a14
	clr	a8
	movk	8,a0
#lp1	srl	1,a14
	jrnc	#nxt1
	inc	a8
#nxt1	dsj	a0,#lp1

	;get the first one
	calla	get_rnd_wrestler
	PUSH	a0		;store first WRESTLERNUM

	;now exclude him and get another one.
	inc	a8		;inc exclusion count
	movk	1,a14
	sll	a0,a14
	or	a14,a7
	calla	get_rnd_wrestler
	PULL	a1		;retrieve first WRESTLERNUM

	rets

#*****************************************************************************
*
* Return carry set if wrestler *a14 is behind wrestler *a13, clear otherwise.
*
* trashes a14 (isn't allowed to trash a0 or a1!)

 SUBR	is_a14_behind

	PUSH	a1

	move	*a14(OBJ_XPOSINT),a1
	move	*a13(OBJ_XPOSINT),a14
	sub	a1,a14
	jrn	#onrt

#onlt	;opponent on my left
	move	*a13(FACING_DIR),a14
	btst	MOVE_LEFT_BIT,a14
	jrz	#behind
;	jruc	#ahead

#ahead	PULL	a1
	clrc
	rets

#onrt	;opponent on my right
	move	*a13(FACING_DIR),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#ahead
;	jruc	#behind

#behind	PULL	a1
	setc
	rets

#*****************************************************************************
*
* Call this when a match has just ended.  Does an appropriate sound if
* someone's winning streak has just ended.

 SUBR	loser_snd

	move	@PSTATUS,a14
	cmpi	3,a14
	jrne	#rets

	move	@match_winner,a1
	NOT	A1
	ANDI	3,A1
	DEC	A1
	X16	A1

	ADDI	p1oldwinstreak,A1
	MOVE	*A1,A1
	jrz	#rets
	MOVK	2,A0
	CALLA	RNDRNG0
	SLL	4,A0
	ADDI	#speech,A0
	MOVE	*A0,A0
	CALLA	ADD_VOICE
#rets	rets

#speech	;.word	CONGRATULATIONS
	.word	SOMEHOW_I_DONT_THINK
;	.word	L_CONGRATS
	.word	L_BACK_TO_SANDBOX
	.word	ARE_YOU_TOUGH_ENOUGH

;	.WORD	L_SIGN_YOUR_NAME
;	.WORD	THIS_IS_FOR_ALL
;	.WORD	SIGN_HERE_PLEASE


#*****************************************************************************
*

 SUBR	postgame_audits

	;battle over accounting.

	;compute match_realtime
	move	@match_start_time,a14,L
	move	@PCNT,a1,L
	sub	a14,a1
	movi	55,a14
	divu	a14,a1
	move	a1,@match_realtime

	;skip all this crap after a royal_rumble
	move	@royal_rumble,a14
	jrnz	#rets

	;increment AUD_VSHUMF or AUD_VSCPUF (and AUD_CPUWIN)
	movi	AUD_VSHUMF,a0
	move	@PSTATUS,a14
	cmpi	03h,a14
	jreq	#vshum
	movi	AUD_VSCPUF,a0
#vshum	calla	AUD1

	;add to AUD_2PBTIME, AUD_CPUWINTIME, or AUD_CPULOSETIME
	move	@PSTATUS,a14
	cmpi	03h,a14
	jreq	#2pbtime

	move	@match_winner,a0
	and	a0,a14
	jrnz	#cpulosetime
	jruc	#cpuwintime

#2pbtime
	movi	AUD_2PBTIME,a0
	jruc	#addtime

#cpuwintime
	MOVE	@PSTARTS,A0
	JRZ	NO_UPDATE_ANYTHING

	MOVI	AUD_CREDLEN,A0
	MOVE	@THIS_GAME_TIME,A1
	CALLA	AUD
	MOVI	AUD_CREDLENNUM,A0
	CALLA	AUD1
	CLR	A0
	MOVE	A0,@THIS_GAME_TIME
	MOVE	A0,@PSTARTS

NO_UPDATE_ANYTHING
	movi	AUD_CPUWIN,a0
	calla	AUD1
	movi	AUD_CPUWINTIME,a0
	jruc	#addtime
#cpulosetime
	movi	AUD_CPULOSETIME,a0
	jruc	#addtime

#addtime
	move	@match_realtime,a1
	calla	AUD

	;update record speeds
	move	@PSTATUS,a14
	cmpi	03h,a14
	jreq	#fast_2p

	move	@match_winner,a0
	and	a0,a14
	jrnz	#fast_cpulose
	jruc	#fast_cpuwin

#fast_2p
	movi	AUD_FASTHDH,a0
	calla	GET_AUD
	jrz	#no_prior_hdh
	move	@match_realtime,a2
	cmp	a1,a2
	jrge	#recordspeed_done
#no_prior_hdh
	movi	AUD_FASTHDH,a0
	move	@match_realtime,a1
	calla	STORE_AUDIT
	jruc	#recordspeed_done

#fast_cpulose
	movi	AUD_FASTHDC,a0
	calla	GET_AUD
	jrz	#no_prior_hdc
	move	@match_realtime,a2
	cmp	a1,a2
	jrge	#recordspeed_done
#no_prior_hdc
	movi	AUD_FASTHDC,a0
	move	@match_realtime,a1
	calla	STORE_AUDIT
	jruc	#recordspeed_done

#fast_cpuwin
	movi	AUD_FASTCDH,a0
	calla	GET_AUD
	jrz	#no_prior_cdh
	move	@match_realtime,a2
	cmp	a1,a2
	jrge	#recordspeed_done
#no_prior_cdh
	movi	AUD_FASTCDH,a0
	move	@match_realtime,a1
	calla	STORE_AUDIT

#recordspeed_done
;No speedy victories in 3 rnd matches!
	move	@current_round,a0
	cmpi	3,a0
	jrz	#rets


	;increment the proper wrestler use thingies

	MOVE	@PSTATUS,A0
	CMPI	3,A0
	JREQ	#2pmatch

	;it's a one-player match.
	move	@index1,a2
	CLR	A1
	SRL	1,A0
	JRC	AUDIT_THE_HUMAN
	move	@index2,a2
	MOVK	1,A1

AUDIT_THE_HUMAN
	CALLR	#audit_wrestler

	move	@NUM_OPPS,a14
	cmpi	1,a14
	jrne	#rets		;don't audit 1-vs-many matches

	;audit the computer
	move	@CURRENT_LADDER,a0,L
	move	*a0,a2,L
	sll	24,a2
	srl	24,a2		;CPU wrestlernum in a2

	;convert 7 to 8.
	cmpi	7,a2
	jrne	#vok0
	inc	a2
#vok0

	move	@PSTATUS,a1
	xori	3,a1
	srl	1,a1		;CPU side in a3 (!PSTATUS >> 1)

	callr	#audit_wrestler

	rets
	

;human vs. human match
#2pmatch
	;player 1
	move	@index1,a2
	CLR	A1
	CALLR	#audit_wrestler

	;player 2
	move	@index2,a2
	MOVK	1,A1
	CALLR	#audit_wrestler

#rets	RETS

******************
* a2 = WRESTLERNUM
* a1 = PLYR_SIDE

 SUBRP	#audit_wrestler

	TEST	a2
	jrnn	#ok
	.if DEBUG
	LOCKUP
	.endif
	rets
#ok
	X64	a2			;x 4 words
	addi	wrestler_audits,a2

	move	@PSTATUS,a0
	btst	A1,a0
	jrnz	#p1hum
	addi	20h,a2			;skip 2 words
#p1hum
	move	*a2+,a0,W		;increment uses
	calla	AUD1

	move	@match_winner,a0
	btst	A1,a0
	jrz	#p1_audited
	move	*a2+,a0,W		;increment wins
	calla	AUD1

#p1_audited
	RETS


#****************************************************************************
*
* Returns bits of teams with live members in a0.
*

 SUBR	get_live_bits

	PUSH	a1,a2,a3

	movk	NUM_WRES,a0
	movi	process_ptrs,a1
	clr	a3

#lp1	move	*a1+,a2,L
	jrz	#nxt1		;skip inactive

	move	*a2(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jrne	#live

	move	*a2(STATUS_FLAGS),a14
	btst	B_ZOMBIE,a14
	jrz	#nxt1		;skip dead &! zombie

#live	;live wrestler.  flag his team
	move	*a2(PLYR_SIDE),a14
	jrnz	#t2

	;member of team 1
	ori	01h,a3	
	jruc	#nxt1

#t2	;member of team 2
	ori	02h,a3

#nxt1	dsj	a0,#lp1
	move	a3,a0
	PULL	a1,a2,a3

	rets

#*****************************************************************************
*
* Returns carry set if any of a13's live opponents are outside the ring.
* Trashes a0, a1, a14
*

 SUBRP	any_opp_outside

	PUSH	a3

	movi	process_ptrs,a0
	movi	NUM_WRES,a1
	move	*a13(PLYR_SIDE),a2
#lp0	move	*a0+,a3,L
	jrz	#nxt0			;skip inactive
	move	*a3(PLYR_SIDE),a14
	cmp	a14,a2
	jreq	#nxt0			;skip teammates
	move	*a3(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#nxt0			;skip dead guys
	move	*a3(INRING),a14
	jrnz	#setc			;is outside?
#nxt0	dsj	a1,#lp0

	PULL	a3
	clrc
	rets

#setc	PULL	a3
	setc
	rets

#*****************************************************************************
*
* Sets a13's PLYRMODE to INAIR2 if his nearest opponent is dead, INAIR
* otherwise.
*

 SUBR	set_tbukl_airmode

	calla	get_opp_plyrmode
	cmpi	MODE_DEAD,a0
	jreq	#dead
	movi	MODE_INAIR2,a0
	jruc	#go

#dead	movi	MODE_INAIR,a0
#go	move	a0,*a13(PLYRMODE)
	rets
	
#*****************************************************************************
*
* set MODE_STATUS bit if switches are AWAY & PUNCH.

 SUBR	free_toss_check

	move	*a13(ANIMODE),a0
	ori	MODE_STATUS,a0

	move	*a13(CLOSEST_NUM),a14
	X32	a14
	addi	process_ptrs,a14
	move	*a14,a14,L

	move	*a14(OBJ_ZPOS),a14,L
	move	*a13(OBJ_ZPOS),a1,L
	sub	a1,a14
	abs	a14
	srl	16,a14
	cmpi	15,a14
	jrlt	#set


;	move	*a13(STICK_REL_CUR),a14
;	btst	MOVE_AWAY_BIT,a14
;	jrz	#clr

	move	*a13(BUT_VAL_CUR),a14
	cmpi	PLAYER_BLOCK_VAL,a14
	jreq	#set
;#clr
	andni	MODE_STATUS,a0
#set
	move	a0,*a13(ANIMODE)
	rets

#*****************************************************************************
*
* We're gonna do a free hiptoss.  Do all the neccesary setup here.  Set our
* PLYRMODE to normal, IMMOBILIZE the bad guy, clear velocities, etc.

 SUBR	setup_freetoss

	;mode normal
	SETMODE	NORMAL

	;immobilize bad guy
	move	*a13(WHOIHIT),a0,L
	movk	20,a14
	move	a14,*a0(IMMOBILIZE_TIME)

	;smart-target bad guy
	SMRTTGT	a13,WHOIHIT

	rets

******************************************************************************

	.end
