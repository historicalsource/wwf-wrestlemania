**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		4/16/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"ref.asm"
	.title	"referee specific game code"
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

	.include	"fontsimg.glo"


******************************************************************************
* EXTERNAL REFERENCES

	.ref	wres_get_but_val_up,wres_get_but_val_down,wres_get_but_val_cur
	.ref	wres_get_stick_val_cur
	.ref	get_punch_dtime

	.ref	change_anim1,change_anim1a
	.ref	change_anim2,change_anim2a
	.ref	set_wrestler_xflip
	.ref	process_ptrs
	.ref	keep_attached
	.ref	get_opp_plyrmode
	.ref	wres_collis_off
	.ref	convert_facing
	.ref	check_secret_moves
	.ref	change_walk_anim
	.ref	set_rotate_anim
	.ref	execute_walk
	.ref	start_run,bounce_off_ropes
	.ref	inc_burnout
	.ref	PCNT

	;from DCSSOUND.ASM
	.ref	triple_sound

	;from DISPLAY.ASM
	.ref	BEGINOBJ_TBL

	;from HSTD.ASM
	.ref	BINBCD

	;from ROBO.ASM
	.ref	civanic

	;from SQUARE.ASM
	.ref	square_root

	;from WRESTLE.ASM
	.ref	get_rope_x,calc_line_pt
	.ref	set_turbo_status

;animation sequence

	.ref	ref_stand2_anim,ref_stand4_anim
	.ref	ref_torso2_anim,ref_torso4_anim

	.ref	ref_zip_anim

	.ref	ref_walk1_f2_anim,ref_walk2_f2_anim,ref_walk4_f2_anim
	.ref	ref_walk5_f2_anim,ref_walk6_f2_anim,ref_walk8_f2_anim

	.ref	ref_walk1_f4_anim,ref_walk2_f4_anim,ref_walk4_f4_anim
	.ref	ref_walk5_f4_anim,ref_walk6_f4_anim,ref_walk8_f4_anim

	.ref	ref_2_to_4_turn_anim,ref_8_to_6_turn_anim	;stand
	.ref	ref_4_to_2_turn_anim,ref_6_to_8_turn_anim
	.ref	ref_4_to_6_turn_anim,ref_6_to_4_turn_anim
	.ref	ref_2_to_8_turn_anim,ref_8_to_2_turn_anim
	.ref	ref_4_to_8_turn_anim,ref_6_to_2_turn_anim
	.ref	ref_8_to_4_turn_anim,ref_2_to_6_turn_anim

	.ref	ref_2_to_4_turn2_anim,ref_4_to_2_turn2_anim	;torso
	.ref	ref_4_to_6_turn2_anim,ref_6_to_4_turn2_anim
	.ref	ref_2_to_8_turn2_anim,ref_8_to_2_turn2_anim

	.ref	ref_2_head_hit_anim,ref_4_head_hit_anim,ref_head_hit2_anim
	.ref	ref_2_body_hit_anim,ref_4_body_hit_anim

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

	.bss	uhgrid,9*20h

	.bss	grid_index,10h

	BSSX	refmove_dir,10h

	BSSX	motion_threshhold,10h
	BSSX	ref_unhap,20h
	BSSX	last_move,10h
	BSSX	last_holdstill,10h

******************************************************************************
* EQUATES FOR THIS FILE

MAX_UNHAPPINESS	equ	7FFFFFFFh
UHGRID_X	equ	4
UHGRID_Z	equ	4

GRID_UNHAP	equ	0
GRID_D1		equ	1
GRID_D2		equ	2

REF_DEBUG	equ	0

BRAIN_FREQ	equ	3	;update move grid every X ticks

 .if REF_DEBUG
	BSSX	grid_mode,10h
 .endif

#*****************************************************************************

 SUBR	ref_ani_init

 .if REF_DEBUG
	movi	GRID_UNHAP,a14
	move	a14,@grid_mode

	CREATE0	grid_display
 .endif

	move	a13,a8
	CREATE0	ref_brain

	movi	ref_stand2_anim,a0
	calla	change_anim1a

	movi	ref_torso2_anim,a0
	calla	change_anim2a

	rets


#*****************************************************************************
*
* REF CONTROL CODE
*
* a13 = * ref process

 SUBR	move_ref

;	movi	100h,a0			;temp fix!
;	move	a0,*a13(ANI_SPEED)

	clr	a0
	move	a0,*a13(MOVE_DIR)

	move	*a13(PLYRMODE),a0
	sll	5,a0			;x 32
	addi	#mode_table,a0
	move	*a0,a0,L
	call	a0
	rets

#mode_table
	.long	mode_normal		;0
	.long	mode_running		;1
	.long	mode_inair		;2
	.long	mode_attached		;3
	.long	mode_onground		;4
	.long	mode_bouncing		;5
	.long	mode_onturnbkl		;6
	.long	mode_block		;7
	.long	mode_dizzy		;8
	.long	mode_dead		;9
	.long	mode_oppoverhead	;10
	.long	mode_climbturnbkl	;11
	.long	mode_waitanim		;12
	.long	mode_x6			;13
	.long	mode_x7			;14
	.long	mode_x8			;15
	.long	mode_x9			;16

#*****************************************************************************
*

mode_normal	;0


	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_interrupt

	callr	calc_walk_dir

	calla	execute_walk

#no_interrupt
	rets


 SUBRP	calc_walk_dir

	move	@refmove_dir,a14
	move	a14,*a13(MOVE_DIR)
	rets


#*****************************************************************************
* Brain process.  Continuously updates refmove_dir to show the direction to
* minimize unhappiness.
* >a8 = ref proc

	STRUCTPD
	LONG		#REFPROC		;UHL ref process

 SUBR	ref_brain

	move	a8,*a13(#REFPROC),L

	movi	10,a14
	move	a14,@motion_threshhold
	move	@PCNT,a14
	move	a14,@last_move
	move	a14,@last_holdstill

#main_loop
	SLEEPK	BRAIN_FREQ

	;update the motion threshhold
	;if he's been moving continuously for 20 ticks, increment the
	; threshhold.
	move	@PCNT,a0
	move	@last_holdstill,a1
	sub	a1,a0
	cmpi	20,a0
	jrlt	#no_inc

	move	@motion_threshhold,a14
	inc	a14
	move	a14,@motion_threshhold
	move	@PCNT,a14
	move	a14,@last_holdstill
#no_inc

	;if he's been holding still continuously for 20 ticks, decrement
	; the threshhold.
	move	@PCNT,a0
	move	@last_move,a1
	sub	a1,a0
	cmpi	20,a0
	jrlt	#no_dec

	move	@motion_threshhold,a14
	dsj	a14,#dmt_inrange
	clr	a14
#dmt_inrange
	move	a14,@motion_threshhold
	move	@PCNT,a14
	move	a14,@last_move
#no_dec


	;update move_dir
	;reg use
	; a2 - current low unhappiness value (score)
	; a3 - current low unhappiness index (champ)
	; a4 - current index (0-8)

	movi	MAX_UNHAPPINESS,a2
	movi	4,a3
	movi	8,a4

#search_loop
	move	*a13(#REFPROC),a5,L
	move	*a5(OBJ_XPOSINT),a0
	move	*a5(OBJ_ZPOSINT),a1
	move	a4,a5
	X64	a5
	addi	brain_grid,a5
	move	*a5+,a14,L
	sra	16,a14
	add	a14,a0
	move	*a5+,a14,L
	sra	16,a14
	add	a14,a1
	calla	calc_unhappiness
	cmpi	4,a4
	jrne	#skip_refupdate
	move	a0,@ref_unhap,L
#skip_refupdate
	
 .if REF_DEBUG
	move	@grid_mode,a14
	cmpi	GRID_UNHAP,a14
	jrne	#no_grid_unhap

	move	a4,a14
	X32	a14
	addi	uhgrid,a14
	move	a0,*a14,L
#no_grid_unhap
 .endif

	cmp	a2,a0
	jrge	#too_high

	move	a0,a2
	move	a4,a3

#too_high
	dec	a4
	jrnn	#search_loop

	;all done.  ref_unhap holds unhappiness at ref's current position.
	; a2 holds unhappiness at lowest position.  If the best unhappiness
	; is within motion_thresshold of the current unhap, just hold still.
	move	@ref_unhap,a1,L
	sub	a2,a1
 .if DEBUG
	jrnn	#no_bug
	LOCKUP		;a2 should never be less than ref_unhap
#no_bug
 .endif
	move	@motion_threshhold,a0
	sub	a0,a1
	jrnn	#move_off

	;not enough of a difference to make moving worthwhile
	movk	4,a3

#move_off
	movi	last_holdstill,a0
	cmpi	4,a3
	jreq	#holdstill
	movi	last_move,a0
#holdstill
	move	@PCNT,a14
	move	a14,*a0
	X16	a3
	addi	#move_table,a3
	move	*a3,a3,W
	move	a3,@refmove_dir

	jruc	#main_loop

#no_ref
	DIE

#move_table
	.word	MOVE_UP_LEFT,MOVE_UP,MOVE_UP_RIGHT
	.word	MOVE_LEFT,MOVE_ZIP,MOVE_RIGHT
	.word	MOVE_DOWN_LEFT,MOVE_DOWN,MOVE_DOWN_RIGHT


#*****************************************************************************
*

mode_running	;1
	rets

#*****************************************************************************
*

mode_inair	;2

	rets

#*****************************************************************************
*

mode_attached	;3

	rets

#*****************************************************************************

mode_onground	;4

	rets

#*****************************************************************************
*
* bouncing off ropes while running

mode_bouncing	;5

	rets

#*****************************************************************************
*
* STANDING ON TOP OF TURNBUCKLE

mode_onturnbkl	;6

	rets

#*****************************************************************************
* blocking

mode_block	;7
	rets

#*****************************************************************************
* doink with zero health

mode_dizzy	;8

	rets

#*****************************************************************************
mode_dead	;9

	rets

#*****************************************************************************
* opponent held overhead

mode_oppoverhead ;10

	rets

#*****************************************************************************
*
* CLIMBING UP OR DOWN THE TURNBUCKLE

mode_climbturnbkl	;11

	rets


#*****************************************************************************

mode_waitanim	;12

	move	*a13(ANIMODE),a0
	btst	MODE_END_BIT,a0
	jrz	#not_ended

	move	*a13(CODE_ADDR),a0,L
	call	a0

#not_ended
	rets


#*****************************************************************************

mode_x6		;13
mode_x7		;14
mode_x8		;15
mode_x9		;16
	rets


#*****************************************************************************

#VEL	equ	30000h
#DVEL	equ	21f0eh


 SUBR ref_velocity_table

;		X,	Z

	.long	0,	-#VEL	;0 UP

	.long	#DVEL,	-#DVEL	;1 UP-RIGHT

	.long	#VEL,	0	;2 RIGHT

	.long	#DVEL,	#DVEL	;3 DOWN-RIGHT

	.long	0,	#VEL	;4 DOWN

	.long	-#DVEL,	#DVEL	;5 DOWN-LEFT

	.long	-#VEL,	0	;6 LEFT

	.long	-#DVEL,	-#DVEL	;7 UP-LEFT


 SUBRP	brain_grid
	.long	-#DVEL*BRAIN_FREQ,-#DVEL*BRAIN_FREQ	;up-left
	.long	0,-#VEL*BRAIN_FREQ			;up
	.long	#DVEL*BRAIN_FREQ,-#DVEL*BRAIN_FREQ	;up-right
	.long	-#VEL*BRAIN_FREQ,0			;left
	.long	0,0					;zip
	.long	#VEL*BRAIN_FREQ,0			;right
	.long	-#DVEL*BRAIN_FREQ,#DVEL*BRAIN_FREQ	;down-left
	.long	0,#VEL*BRAIN_FREQ			;down
	.long	#DVEL*BRAIN_FREQ,#DVEL*BRAIN_FREQ	;down-right

#*****************************************************************************

 SUBR ref_rotate_anims_table
; old = up right
	.long	ref_stand2_anim		;new = up right
	.long	ref_2_to_4_turn_anim	;    = down right
	.long	ref_2_to_6_turn_anim	;    = down left ***
	.long	ref_2_to_8_turn_anim	;    = up left

; old = down right
	.long	ref_4_to_2_turn_anim	;new = up right
	.long	ref_stand4_anim		;    = down right
	.long	ref_4_to_6_turn_anim	;    = down left
	.long	ref_4_to_8_turn_anim	;    = up left ***

; old = down left
	.long	ref_6_to_2_turn_anim	;new = up right ***
	.long	ref_6_to_4_turn_anim	;    = down right
	.long	ref_stand4_anim		;    = down left
	.long	ref_6_to_8_turn_anim	;    = up left

; old = up left
	.long	ref_8_to_2_turn_anim	;new = up right
	.long	ref_8_to_4_turn_anim	;    = down right ***
	.long	ref_8_to_6_turn_anim	;    = down left
	.long	ref_stand2_anim		;    = up left


 SUBR ref_leg_anims_table
;  MOVE
;(#1 - UP)				FACING
	.long	ref_walk1_f2_anim	;1 (UP)
	.long	ref_walk1_f2_anim	;2 (UP_RIGHT)
	.long	ref_walk1_f4_anim	;3 (RIGHT)
	.long	ref_walk1_f4_anim	;4 (DOWN_RIGHT)
	.long	ref_walk1_f4_anim	;5 (DOWN)
	.long	ref_walk1_f4_anim	;6 (DOWN_LEFT)
	.long	ref_walk1_f2_anim	;7 (LEFT)
	.long	ref_walk1_f2_anim	;8 (UP-LEFT)

;(#2 - UP-RIGHT)
	.long	ref_walk2_f2_anim	;1 (UP)
	.long	ref_walk2_f2_anim	;2 (UP_RIGHT)
	.long	ref_walk2_f2_anim	;3 (RIGHT)
	.long	ref_walk2_f4_anim	;4 (DOWN_RIGHT)
	.long	ref_walk8_f4_anim	;5 (DOWN)
	.long	ref_walk8_f4_anim	;6 (DOWN_LEFT)
	.long	ref_walk4_f2_anim	;7 (LEFT)
	.long	ref_walk4_f2_anim	;8 (UP-LEFT)

;(#3 - RIGHT)
	.long	ref_walk2_f2_anim	;1 (UP)
	.long	ref_walk2_f2_anim	;2 (UP_RIGHT)
	.long	ref_walk2_f2_anim	;3 (RIGHT)
	.long	ref_walk4_f4_anim	;4 (DOWN_RIGHT)
	.long	ref_walk4_f4_anim	;5 (DOWN)
	.long	ref_walk8_f4_anim	;6 (DOWN_LEFT)
	.long	ref_walk6_f2_anim	;7 (LEFT)
	.long	ref_walk6_f2_anim	;8 (UP-LEFT)


;(#4 - DOWN-RIGHT)
	.long	ref_walk2_f2_anim	;1 (UP)
	.long	ref_walk8_f2_anim	;2 (UP_RIGHT)
	.long	ref_walk4_f4_anim	;3 (RIGHT)
	.long	ref_walk4_f4_anim	;4 (DOWN_RIGHT)
	.long	ref_walk2_f4_anim	;5 (DOWN)
	.long	ref_walk6_f4_anim	;6 (DOWN_LEFT)
	.long	ref_walk2_f2_anim	;7 (LEFT)
	.long	ref_walk6_f2_anim	;8 (UP-LEFT)

;(#5 - DOWN)
	.long	ref_walk5_f2_anim	;1 (UP)
	.long	ref_walk5_f2_anim	;2 (UP_RIGHT)
	.long	ref_walk5_f4_anim	;3 (RIGHT)
	.long	ref_walk5_f4_anim	;4 (DOWN_RIGHT)
	.long	ref_walk5_f4_anim	;5 (DOWN)
	.long	ref_walk5_f4_anim	;6 (DOWN_LEFT)
	.long	ref_walk5_f2_anim	;7 (LEFT)
	.long	ref_walk5_f2_anim	;8 (UP-LEFT)

;(#6 - DOWN-LEFT)
	.long	ref_walk2_f2_anim	;1 (UP)
	.long	ref_walk6_f2_anim	;2 (UP_RIGHT)
	.long	ref_walk2_f2_anim	;3 (RIGHT)
	.long	ref_walk6_f4_anim	;4 (DOWN_RIGHT)
	.long	ref_walk2_f4_anim	;5 (DOWN)
	.long	ref_walk4_f4_anim	;6 (DOWN_LEFT)
	.long	ref_walk2_f2_anim	;7 (LEFT)
	.long	ref_walk8_f2_anim	;8 (UP-LEFT)

;(#7 - LEFT)
	.long	ref_walk2_f2_anim	;1 (UP)
	.long	ref_walk6_f2_anim	;2 (UP_RIGHT)
	.long	ref_walk6_f2_anim	;3 (RIGHT)
	.long	ref_walk8_f4_anim	;4 (DOWN_RIGHT)
	.long	ref_walk4_f4_anim	;5 (DOWN)
	.long	ref_walk4_f4_anim	;6 (DOWN_LEFT)
	.long	ref_walk2_f2_anim	;7 (LEFT)
	.long	ref_walk2_f2_anim	;8 (UP-LEFT)

;(#8 - UP-LEFT)
	.long	ref_walk2_f2_anim	;1 (UP)
	.long	ref_walk4_f2_anim	;2 (UP_RIGHT)
	.long	ref_walk6_f2_anim	;3 (RIGHT)
	.long	ref_walk8_f4_anim	;4 (DOWN_RIGHT)
	.long	ref_walk6_f4_anim	;5 (DOWN)
	.long	ref_walk2_f4_anim	;6 (DOWN_LEFT)
	.long	ref_walk2_f2_anim	;7 (LEFT)
	.long	ref_walk2_f2_anim	;8 (UP-LEFT)


 SUBR ref_torso_anims_table
; old = up right
	.long	ref_torso2_anim		;new = up right
	.long	ref_2_to_4_turn2_anim	;    = down right
	.long	ref_2_to_8_turn2_anim	;    = down left ***
	.long	ref_2_to_8_turn2_anim	;    = up left

; old = down right
	.long	ref_4_to_2_turn2_anim	;new = up right
	.long	ref_torso4_anim		;    = down right
	.long	ref_4_to_6_turn2_anim	;    = down left
	.long	ref_4_to_6_turn2_anim	;    = up left ***

; old = down left
	.long	ref_6_to_4_turn2_anim	;new = up right ***
	.long	ref_6_to_4_turn2_anim	;    = down right
	.long	ref_torso4_anim		;    = down left
	.long	ref_4_to_2_turn2_anim	;    = up left

; old = up left
	.long	ref_8_to_2_turn2_anim	;new = up right
	.long	ref_8_to_2_turn2_anim	;    = down right ***
	.long	ref_2_to_4_turn2_anim	;    = down left
	.long	ref_torso2_anim		;    = up left

; *** should not happen


#*****************************************************************************
* REFEREE HAS JUST BEEN HIT
* a10 = * offensive process
* a13 = * defensive process (REF)

 SUBR	ref_hit

	move	*a10(ATTACK_MODE),a0	;type of attack that hit the ref
	move	a0,a1
	sll	5,a1			;x 32
	addi	#hit_table,a1
	move	*a1,a1,L		;appropriate routine
	call	a1

	rets

#hit_table
	.long	_punch		;0
	.long	_hdbutt		;1
	.long	_kick		;2
	.long	_flykick	;3
	.long	_grabthrow	;4
	.long	_uprcut		;5
	.long	_lbowdrop	;6
	.long	_grabhold	;7
	.long	_grabfling	;8
	.long	_push		;9
	.long	_hiptoss	;10
	.long	_bigboot	;11
	.long	_knee		;12
	.long	_13		;13
	.long	_14		;14
	.long	_15		;15
	.long	_16		;16

#************************
;AMODE_PUNCH	0
_punch

	WRSND	W_REF,PUNCH_L1
	WRSND	W_REF,PUNCH_L2

	SETMODE	NORMAL
	movi	ref_2_head_hit_anim,a0
	move	*a13(FACING_DIR),a1
	btst	MOVE_UP_BIT,a1
	jrnz	#2_hit
	movi	ref_4_head_hit_anim,a0
#2_hit
	calla	change_anim1a
	calla	wres_collis_off

	rets

#************************
;AMODE_HDBUTT	1
_hdbutt
	WRSND	W_REF,HDBUTT_L1
	WRSND	W_REF,HDBUTT_L2

	SETMODE	NORMAL

	movi	ref_head_hit2_anim,a0
	calla	change_anim1a

	movi	[1,0],a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;offx - defx
	jrgt	#go_rgt			;attacker on left
	neg	a2
#go_rgt
	move	a2,*a13(OBJ_XVEL),L

	calla	wres_collis_off

	rets

#************************
;AMODE_KICK	2
_kick

	WRSND	W_REF,KICK_L1
	WRSND	W_REF,KICK_L2

	SETMODE	NORMAL

	movi	ref_2_body_hit_anim,a0
	move	*a13(FACING_DIR),a1
	btst	MOVE_UP_BIT,a1
	jrnz	#2_hit
	movi	ref_4_body_hit_anim,a0
#2_hit
	calla	change_anim1a

;Drift back away from attacker
	movi	20000h,a1
 	move	*a10(OBJ_XPOSINT),a0
 	move	*a13(OBJ_XPOSINT),a14
	cmp	a0,a14
	jrgt	#setxv
	movi	-20000h,a1
#setxv
	move	a1,*a13(OBJ_XVEL),L

	calla	wres_collis_off
	rets

#************************
;AMODE_FLYKICK	3
_flykick
	rets

#************************
;AMODE_GRABTHROW 4
_grabthrow

	rets

#************************
;AMODE_UPRCUT	5
_uprcut
	rets

#************************
;AMODE_LBOWDROP	6
_lbowdrop

	rets
	
#************************
;AMODE_GRABHOLD	7
_grabhold

	rets

#************************
;AMODE_GRABFLING 8
_grabfling

	rets

#************************
;AMODE_PUSH	9
_push

	rets

#************************
;AMODE_HIPTOSS	10
_hiptoss

	rets

#************************
;AMODE_BIGBOOT	11
_bigboot

	rets

#************************
;AMODE_KNEE	12
_knee

	rets

#************************

_13		;13
_14		;14
_15		;15
_16		;16

#*****************************************************************************
* calculates the 2D distance between two points
* >a0=x1 >a1=y1 >a2=x2 >a3=y2
* <a0=distance (a1-a3 left intact)

 SUBR	distance_2D

	PUSH	a1,a2,a3,a5

	move	a0,a5
	sub	a2,a5
	abs	a5
	mpyu	a5,a5
	move	a5,a0

	sub	a1,a3
	abs	a3
	mpyu	a3,a3

	add	a3,a0

	calla	square_root

	PULL	a1,a2,a3,a5

	rets

#*****************************************************************************
* calculates the unhappiness value of a given point in the XZ plane.
* >a0=x >a1=z
* <a0=unhappiness(UHL)

 SUBR	calc_unhappiness

	PUSH	a1,a2,a3,a4,a5,a6,a7,a8

	move	a0,a2			;keep these in a safer place
	move	a1,a3

	;return MAX_UNHAPPINESS if the point lies outside the ring
	cmpi	RING_TOP,a3
	jrlt	#out_of_ring
	cmpi	RING_BOT,a3
	jrgt	#out_of_ring

	cmpi	RING_X_CENTER,a0
	jrlt	#check_left

	movi	vln_right_rope,a6
	move	a3,a1
	calla	calc_line_pt
	jrz	#out_of_ring
	subi	4,a0			;don't get within 4 of rope
	cmp	a0,a2
	jrge	#out_of_ring
	jruc	#in_ring

#check_left
	movi	vln_left_rope,a6
	move	a3,a1
	calla	calc_line_pt
	jrz	#out_of_ring
	addi	4,a0			;don't get within 4 of rope
	cmp	a0,a2
	jrle	#out_of_ring

#in_ring

	;reg use - main
	; a2 = point x
	; a3 = point z
	; a4 = important wrestler 1 x
	; a5 = important wrestler 1 z
	; a6 = important wrestler 2 x
	; a7 = important wrestler 2 z
	; a8 = dist1 (point to w1)
	; a9 = dist2 (point to w2)
	;a10 = dist12 (w1 to w2)
	;a11 = running unhappiness total

	movi	process_ptrs,a0
	move	*a0+,a1,L
	move	*a1(OBJ_XPOSINT),a4
	move	*a1(OBJ_ZPOSINT),a5
	move	*a0,a1,L
	move	*a1(OBJ_XPOSINT),a6
	move	*a1(OBJ_ZPOSINT),a7

	;get dist1
	move	a4,a0
	move	a5,a1
	calla	distance_2D
	move	a0,a8

 .if REF_DEBUG
	move	@grid_mode,a14
	cmpi	GRID_D1,a14
	jrne	#d2
	move	@grid_index,a14
	X32	a14
	addi	uhgrid,a14
	move	a8,*a14,W

#d2	
 .endif
	;get dist2
	move	a6,a0
	move	a7,a1
	calla	distance_2D
	move	a0,a9

 .if REF_DEBUG
	move	@grid_mode,a14
	cmpi	GRID_D2,a14
	jrne	#d12
	move	@grid_index,a14
	X32	a14
	addi	uhgrid,a14
	move	a9,*a14,W

#d12
 .endif
	;get dist12
	PUSH	a2,a3
	move	a4,a0
	move	a5,a1
	move	a6,a2
	move	a7,a3
	calla	distance_2D
	move	a0,a10
	PULL	a2,a3

	;set the total
	clr	a11

	;BETWEEN - No standing in the foreground between the wrestlers.
	; It blocks the camera.

	;first off, is our Z greater than the Z of the line connecting
	; the two wrestlers at X?
	; z(x)=(z2-z1)(x-x1)/(x2-x1)+z1
	move	a7,a1
	sub	a5,a1	;z2-z1

	move	a2,a14
	sub	a4,a14 	;x-x1
	mpys	a14,a1	;(z2-z1)*(x-x1)

	move	a6,a14
	sub	a4,a14	;x2-x1
	divs	a14,a1	;(z2-z1)(x-x1)/(x2-x1)
	add	a7,a1	;(z2-z1)(x-x1)/(x2-x1)+z1

	cmp	a1,a3
	jrlt	#not_between

	move	a4,a14
	add	a6,a14
	sra	1,a14
	move	a14,a1			;a1 = midpoint of x1 and x2

	move	a4,a14
	sub	a6,a14
	abs	a14
	addi	120,a14
	sra	1,a14
	move	a14,a0			;a0 = dist ref wants to be from mdpt

	sub	a2,a1
	abs	a1			;a1 = dist from point to mdpt
	cmp	a0,a1
	jrgt	#not_between

	;in between.  assign some whine points based on how close
	sub	a1,a0
	X32	a0
	addi	100,a0
	add	a0,a11

#not_between
	;EQUIDISTANT - Unhappiness is the difference between d1 and d2.
	move	a9,a1
	sub	a8,a1
	abs	a1

	;hack - don't worry about a difference of less than 200.
	cmpi	200,a1
	jrle	#skip_eq
	X8	a1
	add	a1,a11
#skip_eq

	;ELLIPSE - Unhappiness is the difference between d1+d2 and (d12+160)
	; times 8 if too far or times 32 if too close.
	; if d12+80 < 200, use 200 instead.
	PUSH	a10
	cmpi	200,a10
	jrge	#a10_ok
	movi	160,a10
#a10_ok
	move	a8,a1
	add	a9,a1
	sub	a10,a1
	subi	160,a1
	jrnn	#el_too_far

;	abs	a1			;no unhappiness if too far...
;	X4	a1
;#el_too_far
;	X8	a1
;	add	a1,a11

	abs	a1
	X32	a1
	add	a1,a11
#el_too_far
	PULL	a10

	;DUMMY - And whatever else, do NOT get within 80 pixels of a wrestler.
	cmpi	80,a8
	jrgt	#tc_ok1
	movi	80,a14
	sub	a8,a14
	X16	a14
	add	a14,a11
#tc_ok1
	cmpi	80,a9
	jrgt	#tc_ok2
	movi	80,a14
	sub	a9,a14
	X128	a14
	add	a14,a11
#tc_ok2
	
	move	a11,a0
	jrnn	#done
	LOCKUP		;unhap shouldn't ever be negative!
	clr	a0
	jruc	#done

#out_of_ring
	movi	MAX_UNHAPPINESS,a0
#done
	PULL	a1,a2,a3,a4,a5,a6,a7,a8
	rets

 .if REF_DEBUG
#*****************************************************************************
* displays the unhappiness values
*

	.bss	grid_digit_objects,9*4*20h
	.bss	grid_digit_values,9*4*10h
	.bss	grid_title,20h


GRID_TLX	equ	310
GRID_TLY	equ	200


 SUBR	grid_display

	TBL_OBJ	#ttt_grid
	TBL_OBJ	#grid_title
	move	a8,@grid_title,L

	;reg use
	;a10 - grid_digit_objects

	; b2 - inside loop counter
	; b3 - middle loop counter
	; b4 - outside loop counter

	movi	grid_digit_objects,a10
	movi	GRID_TLY<<16,a1

	movi	font60,a2
	movi	300,a3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4
	movi	CLSNEUT|TYPTEXT,a5
	clr	a6
	clr	a7


	movi	3,b4
#outer_loop

	movi	GRID_TLX<<16,a0
	movi	3,b3
#middle_loop

	movi	4,b2
#inside_loop
	;create the object
	PUSH	a0,a1,a2,a3,a4,a5,a6,a7
	calla	BEGINOBJ
	PULL	a0,a1,a2,a3,a4,a5,a6,a7

	move	a8,*a10+,L

	addi	[5,0],a0
	dsj	b2,#inside_loop

	addi	[6,0],a0
	dsj	b3,#middle_loop

	addi	[9,0],a1
	dsj	b4,#outer_loop
	
#main_loop
	SLEEP	6
	callr	update_grid
	jruc	#main_loop

#ttt_grid
	.word	GRID_TLX-2,GRID_TLY-2,299
	.long	ttt_grid
	.word	DMAWNZ|M_3D|M_SCRNREL
	.word	CLSNEUT|TYPNEUT
	.long	0,0
	
#grid_title
	.word	GRID_TLX+35,GRID_TLY-12,299
	.long	g_unhap
	.word	DMAWNZ|M_3D|M_SCRNREL
	.word	CLSNEUT|TYPNEUT
	.long	0,0
	

#*****************************************************************************

 SUBR	update_grid

	;reg use
	; a9 grid values *
	;a10 grid digit obj *
	;a11 digit values *

	; b2 inner loop counter
	; b3 outer loop counter

	;update the digit values

	movi	uhgrid,a9
	movi	grid_digit_values,a11
	movi	9,b3

#outer_loop

	movi	4,b2
	move	*a9+,a0,L
	calla	BINBCD

#inner_loop
	move	a0,a14
	sla	4,a0
	andi	>F000,a14
	sra	12,a14
	move	a14,*a11+,W
	dsj	b2,#inner_loop

	dsj	b3,#outer_loop


	;update the digit objects

	movi	grid_digit_objects,a10
	movi	grid_digit_values,a11
	movi	9*4,b2

#loop
	move	*a11+,a0,W
	X32	a0
	addi	#digit_table,a0
	move	*a0,a0,L
	move	*a10+,a8,L
	move	*a8(OIMG),a2,L
	cmp	a0,a2
	jreq	#match

	;animate
	calla	civanic

#match
	dsj	b2,#loop
	

	;update the title
	move	@grid_mode,a0
	X32	a0
	addi	#grid_modes,a0
	move	*a0,a0,L
	move	@grid_title,a8,L
	move	*a8(OIMG),a14,L
	cmp	a14,a0
	jreq	#done
	calla	civanic

#done
	rets

#digit_table
	.long	font60,font61,font62,font63,font64
	.long	font65,font66,font67,font68,font69

#grid_modes
	.long	g_unhap,g_d1,g_d2

 .endif
******************************************************************************

	.end
