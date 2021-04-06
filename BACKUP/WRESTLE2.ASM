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
	.include	"ring.equ"

	.include	"imgtbl.glo"
	.include	"fontsimg.glo"
	.include	"bgndtbl.glo"
	.include	"miscimg.glo"


******************************************************************************
* EXTERNAL REFERENCES

;MJT Start
	.ref	triple_sound
;MJT End
	.ref	change_anim1a
	.ref	set_rotate_anim
	.ref	wres_get_stick_val_cur
	.ref	get_rope_x
	.ref	round_tickcount
	.ref	get_process_ptr

	.ref	calc_line_x
	.ref	dnk_climbthru_side_anim,dnk_climbthru_bot_anim
	.ref	dnk_climbthru_top_anim,dnk_climbin_bot_anim
	.ref	dnk_climbin_top_anim,dnk_climbin_side_anim
	.ref	get_opp_process

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

	.ref	wres_get_but_val_cur,wres_get_but_val_down

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
	cmpi	RING_TOP,a0
	jrgt	#not_top


	move	*a13(OBJ_XPOSINT),a0
	cmpi	RING_X_CENTER,a0
	jrgt	#right
;#left
	calla	get_rope_x
	move	*a13(OBJ_COLLX1),a1
	cmp	a0,a1			;a1-a0
	jrgt	#no_climb

	movi	MOVE_UP_LEFT,a3		;face top left turnbuckle
	cmp	a3,a4			;Make sure UP/LEFT is pressed
	jreq	#climbit
	jruc	#no_climb

#right
	calla	get_rope_x
	move	*a13(OBJ_COLLX2),a1
	cmp	a0,a1			;a1-a0
	jrlt	#no_climb

	movi	MOVE_UP_RIGHT,a3	;face top right turnbuckle
	cmp	a3,a4			;Make sure UP/RIGHT is pressed
	jrne	#no_climb


#climbit

;If anybody is already on turnbuckles, ignore this
	.ref	process_ptrs
	movi	process_ptrs,a4
	movi	NUM_WRES,a5
#already
	move	*a4+,a0,L
	jrz	#inactive
	move	*a0(PLYRMODE),a0
	cmpi	MODE_ONTURNBKL,a0
	jrz	#no_climb
#inactive
	dsj	a5,#already



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

 .if 0
#*****************************************************************************
* Climbthru special move
*

 SUBR	climb_thru_side_ropes
	.word	J_LEFT,			J_FLIPPED_LR
	.word	J_LEFT,			J_FLIPPED_LR
	.word	8000h | 16		;max
	.long	scrt_climbthru_side

 SUBR	climb_thru_side_ropes2
	.word	J_RIGHT,		J_FLIPPED_LR
	.word	J_RIGHT,		J_FLIPPED_LR
	.word	8000h | 16		;max
	.long	scrt_climbthru_side

 SUBR	climb_thru_bottom_ropes
	.word	J_DOWN,			0
	.word	J_DOWN,			0
	.word	8000h | 16		;max
	.long	scrt_climbthru_bot

 SUBR	climb_thru_top_ropes
	.word	J_UP,			0
	.word	J_UP,			0
	.word	8000h | 16		;max
	.long	scrt_climbthru_top
 .endif

#********
 SUBR	ck_climb_out_bot

	move	*a13(PLYRMODE),a14
	cmpi	MODE_ATTACHED,a14
	jreq	#no_climbthru

	calla	get_opp_process
	move	*a0(INRING),a0
	jrz	#no_climbthru

;scrt_climbthru_bot

	move	*a13(OBJ_XPOSINT),a0
	subi	RING_X_CENTER,a0
	abs	a0
;Far enough away from posts?
	cmpi	0a8h,a0
	jrgt	#no_climbthru

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0

	jrnz	#no_climbthru



	;make sure we're at the bottom edge of the ring.
	move	*a13(OBJ_ZPOS),a0,L
	cmpi	[RING_BOT,0],a0
	jrne	#no_climbthru

	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	climbthru_bot_anims,a0
	move	*a0,a0,L
	calla	change_anim1a
	jruc	#done

 SUBR	ck_climb_in_top
	move	*a13(PLYRMODE),a14
	cmpi	MODE_ATTACHED,a14
	jreq	#no_climbthru

;climbin_top
	move	*a13(CLIMBING_THRU),a0		;1=Climbing thru ropes flag
	jrnz	#done

	move	*a13(OBJ_XPOSINT),a0
	subi	RING_X_CENTER,a0
	abs	a0
;Far enough away from posts?
	cmpi	98h,a0
	jrgt	#no_climbthru

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_climbthru

	;make sure we're at the top edge of the mat.
	move	*a13(OBJ_ZPOS),a0,L
	cmpi	[MAT_TOP-5,0],a0
	jrne	#no_climbthru

	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	climbin_top_anims,a0
	move	*a0,a0,L
	calla	change_anim1a

#no_climbthru
#done
	rets

#********
 SUBR	ck_climb_out_top

	move	*a13(PLYRMODE),a14
	cmpi	MODE_ATTACHED,a14
	jreq	#no_climbthru

	calla	get_opp_process
	move	*a0(INRING),a0

	jrz	#no_climbthru


	move	*a13(OBJ_XPOSINT),a0
	subi	RING_X_CENTER,a0
	abs	a0
;Far enough away from posts?
	cmpi	98h,a0
	jrgt	#no_climbthru
;scrt_climbthru_top

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_climbthru

	;make sure we're at the top edge of the ring.
	move	*a13(OBJ_ZPOS),a0,L
	cmpi	[RING_TOP,0],a0
	jrne	#no_climbthru

	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	climbthru_top_anims,a0
	move	*a0,a0,L
	calla	change_anim1a
	jruc	#done

 SUBR	ck_climb_in_bot

	move	*a13(PLYRMODE),a14
	cmpi	MODE_ATTACHED,a14
	jreq	#no_climbthru

;climbin_bot
	move	*a13(CLIMBING_THRU),a0		;1=Climbing thru ropes flag
	jrnz	#done

	move	*a13(OBJ_XPOSINT),a0
	subi	RING_X_CENTER,a0
	abs	a0
;Far enough away from posts?
	cmpi	0c8h,a0
	jrgt	#no_climbthru

	;make sure we're up against the bottom of the ring
	move	*a13(OBJ_ZPOS),a0,L
	cmpi	[MAT_BOT+5,0],a0
	jrne	#no_climbthru

	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	climbin_bot_anims,a0
	move	*a0,a0,L
	calla	change_anim1a

#no_climbthru
#done
	rets

#********

 SUBR	ck_climb_out_side

	move	*a13(PLYRMODE),a14
	cmpi	MODE_ATTACHED,a14
	jreq	#no_climbthru

	calla	get_opp_process
	move	*a0(INRING),a0

	jrz	#no_climbthru
	
	move	*a13(OBJ_ZPOSINT),a0
	subi	RING_Z_CENTER,a0
	abs	a0
;Far enough away from posts?
	cmpi	48h,a0
	jrgt	#no_climbthru

;scrt_climbthru_side

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_climbthru

	;make sure we're up against one of the sides
	calla	get_rope_x
	move	a0,a4
	cmpi	RING_X_CENTER,a0
	jrgt	#rt
;lf
	move	a13,a0
	calla	wres_get_stick_val_cur
	btst	MOVE_LEFT_BIT,a0
	jrz	#no_climbthru

	move	a4,a0
	move	*a13(OBJ_COLLX1),a1
	cmp	a0,a1
	jrle	#out_left
	jruc	#no_climbthru
#rt
	move	a13,a0
	calla	wres_get_stick_val_cur
	btst	MOVE_RIGHT_BIT,a0
	jrz	#no_climbthru

	move	a4,a0
	move	*a13(OBJ_COLLX2),a1
	cmp	a0,a1
	jrge	#out_right
	jruc	#no_climbthru

#out_left
	movi	MOVE_DOWN_LEFT,a2
	jruc	#face
#out_right
	movi	MOVE_DOWN_RIGHT,a2

#face
	move	*a13(FACING_DIR),a1
	cmp	a2,a1
	jreq	#climb

	move	a2,*a13(NEW_FACING_DIR)
	calla	set_rotate_anim
	calla	change_anim1a

	movi	#climb,a0
	move	a0,*a13(CODE_ADDR),L
	SETMODE	WAITANIM
	rets

#climb
	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	climbthru_side_anims,a0
	move	*a0,a0,L
	calla	change_anim1a

	SETMODE	NORMAL
	jruc	#done


 SUBR	ck_climb_in_side

	move	*a13(PLYRMODE),a14
	cmpi	MODE_ATTACHED,a14
	jreq	#no_climbthru

	move	*a13(CLIMBING_THRU),a0		;1=Climbing thru ropes flag
	jrnz	#done


	move	*a13(OBJ_ZPOSINT),a0
	subi	RING_Z_CENTER,a0
	abs	a0
;Far enough away from posts?

	cmpi	58h,a0		;48h
	jrgt	#done

;#climb_in
	;is he close enough to the ring?
	move	*a13(OBJ_XPOSINT),a0
	cmpi	RING_X_CENTER,a0
	jrlt	#on_left

	;he's right of center
	movi	vln_right_matedge2,a6
	movi	MOVE_DOWN_LEFT,a7
	move	*a13(OBJ_COLLX1),a14
	jruc	climbin_dir_set

#on_left
	;he's left of center
	movi	vln_left_matedge2,a6
	movi	MOVE_DOWN_RIGHT,a7
	move	*a13(OBJ_COLLX2),a14

climbin_dir_set
	calla	calc_line_x
	sub	a14,a0
	abs	a0
	cmpi	5,a0
	jrgt	#no_climbthru

	;he's within five pixels of his mat edge.  face the ring
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
	movk	1,a0
	move	a0,*a13(CLIMBING_THRU)

	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	climbin_side_anims,a0
	move	*a0,a0,L
	calla	change_anim1a

	SETMODE	NORMAL

#no_climbthru
#done
	rets


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


#*****************************************************************************
*
* a13 = wrestler process

 SUBR	clear_damage_log

	move	a13,a2
	addi	DAMAGE_HIST,a2		;start of damage stucture

	clr	a0
	movk	20,a1			;8 longs
#clr_loop
	move	a0,*a2+,L
	dsj	a1,#clr_loop

	rets


#*****************************************************************************
*
* a13 = wrestler process
* a0  = damage amount (only if negative)

 SUBR	log_damage

	move	a0,a0
	jrnn	#not_damage

	PUSH	a1,a2,a3

	move	a13,a1
	move	a13,a2

	addi	DAMAGE_HIST+19*32,a1	;start at end of structure and
	addi	DAMAGE_HIST+20*32,a2	;move everything down 1 long

	movk	19,a3
#lp	move	-*a1,-*a2,L
	dsjs	a3,#lp

	move	a0,a1			;damage amount
	neg	a1
	sll	16,a1
	move	@round_tickcount,a2	;ticks since match started
	andi	0ffffh,a2
	or	a1,a2
	move	a2,*a13(DAMAGE_HIST),L

	PULL	a1,a2,a3

#not_damage
	rets


#*****************************************************************************
*
* ARGS:		a13 = wrestler process
*		 a0 = timespan (in ticks)
*
* RETURNS:	 a0 = damage total
*
* TRASHES:	a1-a6,a14
*

 SUBR	tally_damage

	move	@round_tickcount,a4	;ticks since match started
	clr	a5			;damage tally

	move	a13,a1
	addi	DAMAGE_HIST,a1		;start of damage stucture

	movk	20,a6
#loop
	move	*a1+,a2			;tick count
	jrz	#exit			;can't have a 0 tick count
	move	*a1+,a3			;damage

	move	a4,a14
	sub	a2,a14
	cmp	a0,a14			;> timespan?
	jrgt	#exit

	add	a3,a5
	dsj	a6,#loop

#exit
	move	a5,a0
	rets

#*****************************************************************************
*
* a9 = player number (0-1)

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

	SLEEPK	2

	clr	a0
	move	a0,*a13(DISPLAY_VAL)

	movi	[OFFSCR_X,0],a10
	move	a9,a9
	jrnz	#p2

	dec	a10
	neg	a10
#p2

	movi	RECVRBLK,a2			;* image (green bar)
	movi	[109,0],a1			;y pos
	movi	1801H,a3				;z pos
	callr	#begin_obj
	move	a8,*a13(IPTR_GREEN),L
 
	movi	RECVR_R,a2			;* image (frame)
	move	a9,a9
	jrnz	#p2_meter
	movi	RECVR_L,a2			;* image (frame)
#p2_meter
	movi	[194-5,0],a1			;y pos
	movi	1800H,a3				;z pos
	callr	#begin_obj
	move	a8,*a13(IPTR_FRAME),L

	move	a9,a1
	calla	get_process_ptr
	move	a0,a10

	move	a13,*a10(METER_PROC),L

 SUBR 	slide_offscr

;Don't allow a meter to come out for awhile (unless flung)
;MJT Start
	movi	15*60,a0	;13
;MJT End
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

;No meters unless dizzy or flung out of control & getup_time has a value!
;	move	*a10(RUN_TIME),a14
;	jrnz	#ckgetup
;
;	move	*a10(PLYR_DIZZY),a14
;	jrz	#cont
;#ckgetup
	move	*a10(WHOHITME),A0,L
	move	*a0(COMBO_COUNT),A14
	jrnz	#cont
	move	*a10(DELAY_METER),a14
	jrnz	#cont
	move	*a10(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jrz	#cont
	move	*a10(GETUP_TIME),a14
	jrnz	#onscr

#cont
	SLEEPK	1
	jruc	#offscr_loop


#onscr
	move	a14,a11

	movi	GETUP_SIZE,a0
	move	a0,*a13(DISPLAY_VAL)

;;	sll	16,a11
;;	divu	a0,a11				;divisor


;Turn on whack butns message first time only
;	move	*a10(WHACK_CNT),a0
;	jrnz	#skip
;
;Get rid of "whack button" graphic for now.
;	jruc	#skip
;
;	CREATE0	start_whack
;#skip

;MJT Start
	MOVI	0BBH,A0			;Meter announce sound
	CALLA	triple_sound
;MJT End

#onscr_loop

	movi	[ONSCR_X,0],a0
	callr	#set_x

	move	*a10(GETUP_TIME),a7

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
	callr	#update_meter

	move	a7,a7
	jrz	slide_offscr

;MJT Start
	move	*a10(PLYRMODE),a0
	cmpi	MODE_DEAD,a0
	jrz	slide_offscr
;MJT End

	SLEEPK	1
	jruc	#onscr_loop


#set_x
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
#lp
	move	*a14+,a8,L
	move	a0,*a8(OXVEL),L
	dsj	a1,#lp
	rets


#begin_obj
	movi	[200-1,0],a0			;x pos
	add	a10,a0

	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ
	rets


#update_meter
	move	*a13(DISPLAY_VAL),a0
	add	a0,a7
	srl	1,a7
	move	a7,*a13(DISPLAY_VAL)
	move	a7,a1

	neg	a1
	addi	GETUP_SIZE,a1
	jrp	#ok
	clr	a1
#ok
	movi	GETUP_SIZE,a0
	cmp	a0,a1				;meter can't be taller
	jrle	#ok2				;than GETUP_SIZE pixels
	move	a0,a1
#ok2
	move	*a13(IPTR_GREEN),a8,L

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

;MJT Start
	move	*a13(OBJ_ZPOS+16),a0
	move	*a13(Z_BOUND),a14
	jrz	#reg
	sub	a0,a14
	cmpi	6,a14
	jrle	#no_roll
#reg
;MJT End
	move	a13,a0
	calla	wres_get_stick_val_cur
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


	.ref	bam_roll_frames
	.ref	dnk_roll_frames
	.ref	hrt_roll_frames
	.ref	lex_roll_frames
	.ref	rzr_roll_frames
	.ref	shn_roll_frames
	.ref	und_roll_frames

	.ref	yok_roll_frames
#roll_table
	.long	hrt_roll_frames	;0 Bret Hart
	.long	rzr_roll_frames	;1 Razor Ramon
	.long	und_roll_frames	;2 Undertaker
	.long	yok_roll_frames	;3 Yokozuna
	.long	shn_roll_frames	;4 Shawn Michaels
	.long	bam_roll_frames	;5 Bam Bam
	.long	dnk_roll_frames	;6 Doink
	.long	0		;7 ->SPARE<-
	.long	lex_roll_frames	;8 Lex Luger
	.long	0		;9 Referee


#*****************************************************************************

 SUBR	lineup_grapple

	move	*a13(ATTACH_PROC),a10,L
	jrz	#exit
	move	*a10(ATTACH_PROC),a0,L
	cmp	a13,a0
	jrne	#exit


	move	*a13(OBJ_ZPOS),a0,L
	move	*a10(OBJ_ZPOS),a1,L
	add	a1,a0
	srl	1,a0

	movi	[1,0],a1
	move	*a13(FACING_DIR),a14
	btst	MOVE_UP_BIT,a14
	jrnz	#2_lock
	movi	[-1,0],a1
#2_lock
	add	a1,a0
	move	a0,*a13(OBJ_ZPOS),L


	move	*a13(WRESTLERNUM),a0
	movi	10*16,a1
	mpyu	a0,a1			;calc row
	move	*a10(WRESTLERNUM),a0
	X16	a0
	add	a0,a1			;+ column
	addi	#grapple_x_dists,a1
	move	*a1,a3			;distance to keep apart

	move	*a13(OBJ_XPOSINT),a0
	move	*a10(OBJ_XPOSINT),a1
	cmp	a1,a0
	jrgt	#to_right
	neg	a3
#to_right
	add	a1,a0
	srl	1,a0
	add	a3,a0
	sll	16,a0
	move	a0,*a13(OBJ_XPOS),L
#exit
	rets



#grapple_x_dists
;                           B
;	    R   T       S   A   D
;	H   A   A   Y   H   M   O   A
;	A   Z   K   O   A   B   I   D   L
;	R   O   E   K   W   A   N   A   E
;	T   R   R   O   N   M   K   M   X
;
;	0   1   2   3   4   5   6   7   8   9

 .word	00, 00, 00, 00, 00, 00, 00, 00, 00, 00	;0 HART

 .word	00, 30, 00, 00, 00, 00, 20, 26, 00, 00	;1 RAZOR

 .word	00, 00, 35, 00, 00, 00, 00, 00, 00, 00	;2 TAKER

 .word	00, 00, 00, 30, 00, 00, 00, 00, 00, 00	;3 YOKO

 .word	00, 00, 00, 00, 30, 00, 00, 00, 00, 00	;4 SHAWN

 .word	00, 00, 00, 00, 00, 37, 00, 00, 00, 00	;5 BAMBAM

 .word	00, 20, 00, 00, 00, 00, 32, 20, 00, 00	;6 DOINK

 .word	00, 26, 00, 00, 00, 00, 20, 25, 00, 00	;7 ADAM

 .word	00, 00, 00, 00, 00, 00, 00, 00, 00, 00	;8 LEX

 .word	00, 00, 00, 00, 00, 00, 00, 00, 00, 00	;9


#*****************************************************************************

 SUBR	lineup_headhold

	move	*a13(ATTACH_PROC),a10,L
	jrz	#exit
	move	*a10(ATTACH_PROC),a0,L
	cmp	a13,a0
	jrne	#exit


	move	*a13(OBJ_ZPOS),a0,L
	move	*a10(OBJ_ZPOS),a1,L
	add	a1,a0
	srl	1,a0

	movi	[1,0],a1
	move	*a13(FACING_DIR),a14
	btst	MOVE_UP_BIT,a14
	jrnz	#2_lock
	movi	[-1,0],a1
#2_lock
	add	a1,a0
	move	a0,*a13(OBJ_ZPOS),L


	move	*a13(WRESTLERNUM),a0
	movi	10*16,a1
	mpyu	a0,a1			;calc row
	move	*a10(WRESTLERNUM),a0
	X16	a0
	add	a0,a1			;+ column
	addi	#grapple_x_dists,a1
	move	*a1,a3			;distance to keep apart

	move	*a13(OBJ_XPOSINT),a0
	move	*a10(OBJ_XPOSINT),a1
	cmp	a1,a0
	jrgt	#to_right
	neg	a3
#to_right
	add	a1,a0
	srl	1,a0
	add	a3,a0
	sll	16,a0
	move	a0,*a13(OBJ_XPOS),L
#exit
	rets



#grapple_x_dists
;                           B
;	    R   T       S   A   D
;	H   A   A   Y   H   M   O   A
;	A   Z   K   O   A   B   I   D   L
;	R   O   E   K   W   A   N   A   E
;	T   R   R   O   N   M   K   M   X
;
;	0   1   2   3   4   5   6   7   8   9

 .word	00, 00, 00, 00, 00, 00, 00, 00, 00, 00	;0 HART

 .word	00, 30, 00, 00, 00, 00, 20, 26, 00, 00	;1 RAZOR

 .word	00, 00, 35, 00, 00, 00, 00, 00, 00, 00	;2 TAKER

 .word	00, 00, 00, 30, 00, 00, 00, 00, 00, 00	;3 YOKO

 .word	00, 00, 00, 00, 00, 00, 00, 00, 00, 00	;4 SHAWN

 .word	00, 00, 00, 00, 00, 37, 00, 00, 00, 00	;5 BAMBAM

 .word	00, 20, 00, 00, 00, 00, 39, 20, 00, 00	;6 DOINK

 .word	00, 26, 00, 00, 00, 00, 20, 25, 00, 00	;7 ADAM

 .word	00, 00, 00, 00, 00, 00, 00, 00, 00, 00	;8 LEX

 .word	00, 00, 00, 00, 00, 00, 00, 00, 00, 00	;9


#*****************************************************************************

 SUBR	check_dizzy

	movi	4*TSEC,a0
	calla	tally_damage

;Is this the right way to causes dizzies?
;If one move is super powerful, we will tend to get dizzies when we don't want
;them.  Maybe it should be based on hits over time, not damage.

;A combination of the two is needed here! 10/5/94

;We need less resolution on the damage that is recorded!
;Perhaps 1-3?

;We should allow this to happen only once per round!

	cmpi	65,a0

	jrlt	#no_dizzy

	jruc	#no_dizzy


	calla	clear_damage_log

;Don't allow dizzies if your health meter is real low!
;Killer Instinct sucks....
	move	*a13(PLYRNUM),a1
	.ref	get_health
	calla	get_health
	cmpi	30,a0
	jrlt	#no_dizzy

;Too many dizzies this round?
	move	*a13(PLYR_DIZZY_CNT),a0
	cmpi	1,a0				;Max dizzies per round
	jrge	#no_dizzy

	inc	a0
	move	a0,*a13(PLYR_DIZZY_CNT)


	movi	1,a0	;return TRUE
	move	a0,*a13(PLYR_DIZZY)
	rets

#no_dizzy
	clr	a0	;return FALSE
	rets

#*****************************************************************************

 SUBR	form_button_value

	;Combine the val_cur of the block bit with the val_down of the rest.

	move	a13,a0
	calla	wres_get_but_val_cur
	andi	PLAYER_BLOCK_VAL,a0
	move	a0,a1
	move	a13,a0
	calla	wres_get_but_val_down
	or	a1,a0
	rets

#*****************************************************************************

 SUBR	start_whack

;a10=plyr proc
;Turn on whack button graphic, animate it for a bit

frame_z		.equ	202

	movk	1,a0
	move	a0,*a10(WHACK_CNT)
	
	movi	[0f6h,0],a1
	movi	[44h,0],a0
	move	*a10(PLYRNUM),a2
	jrz	#ok
	movi	[401-44h,0],a0
#ok
	movi	WHAK0001,a2
	movi	frame_z+2,a3			;Z
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	movi	OVRHED_PID,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ
	move	a8,a11

	movi	[0f6h,0],a1
	movi	[44h,0],a0
	move	*a10(PLYRNUM),a2
	jrz	#ok2
	movi	[401-44h,0],a0
#ok2
	movi	WKBUTT01,a2
	movi	frame_z+3,a3			;Z
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	movi	OVRHED_PID,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ

#start
	movi	butn_l,a9

#lp	move	*a10(GETUP_TIME),a0
	jrz	#die

	move	*a9+,a0,L
	jrz	#start
	move	*a8(OCTRL),a1
	calla	obj_aniq
#noani
	SLEEPK	3
	jruc	#lp			;Going up?

#die
	SLEEPK	10

	move	a11,a0
	calla	DELOBJ
	jauc	DELOBJDIE


butn_l
	.long	WKBUTT01
	.long	WKBUTT02
	.long	WKBUTT03
	.long	WKBUTT02
      
	.long	0

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

	move	*a0(IANIOFFX),a1
	move	*a0(IANIOFFY),a2
	addi	ICBZ,a0
	dec	a9
	jrz	#done

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
	andi	0ffffh,a1	;clear out sign
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


******************************************************************************

	.end
