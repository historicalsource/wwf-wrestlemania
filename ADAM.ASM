**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		9/3/93
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"adam.asm"
	.title	"adam bomb specific game code"
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
	.include	"ring.equ"
	.include	"lifebar.h"


******************************************************************************
* EXTERNAL REFERENCES

	.ref	wres_get_but_val_down,wres_get_but_val_cur
	.ref	wres_get_stick_val_cur

	.ref	change_anim1,change_anim1a
	.ref	change_anim2
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
	.ref	face_each_other
	.ref	lineup_grapple
	.ref	break_lockup
	.ref	climb_turnbuckle

	;from DCSSOUND.ASM
	.ref	triple_sound

	;from PAL.ASM
	.ref	pal_find,pal_set

;animation sequence

	.ref	wres_slave_anim
	.ref	adm_zip_anim

	.ref	adm_stand2_anim,adm_stand8_anim
	.ref	adm_stand4_anim,adm_stand6_anim
	.ref	adm_torso2_anim,adm_torso8_anim
	.ref	adm_torso4_anim,adm_torso6_anim

	.ref	adm_2_to_4_turn_anim,adm_8_to_6_turn_anim	;stand
	.ref	adm_4_to_2_turn_anim,adm_6_to_8_turn_anim
	.ref	adm_4_to_6_turn_anim,adm_6_to_4_turn_anim
	.ref	adm_2_to_8_turn_anim,adm_8_to_2_turn_anim
	.ref	adm_4_to_8_turn_anim,adm_6_to_2_turn_anim
	.ref	adm_2_to_6_turn_anim,adm_8_to_4_turn_anim

	.ref	adm_2_to_4_turn2_anim,adm_8_to_6_turn2_anim	;torso
	.ref	adm_4_to_2_turn2_anim,adm_6_to_8_turn2_anim
	.ref	adm_4_to_6_turn2_anim,adm_6_to_4_turn2_anim
	.ref	adm_2_to_8_turn2_anim,adm_8_to_2_turn2_anim
	.ref	adm_4_to_8_turn2_anim,adm_6_to_2_turn2_anim
	.ref	adm_2_to_6_turn2_anim,adm_8_to_4_turn2_anim

	.ref	adm_roll_frames

	.ref	adm_walk1_f2_anim,adm_walk2_f2_anim,adm_walk4_f2_anim
	.ref	adm_walk5_f2_anim,adm_walk6_f2_anim,adm_walk8_f2_anim

	.ref	adm_walk1_f4_anim,adm_walk2_f4_anim,adm_walk4_f4_anim
	.ref	adm_walk5_f4_anim,adm_walk6_f4_anim,adm_walk8_f4_anim

	.ref	adm_2_punch_anim,adm_4_punch_anim

	.ref	adm_2_butt_anim,adm_4_butt_anim

	.ref	adm_2_kick_anim,adm_4_kick_anim

	.ref	adm_2_uprcut_anim,adm_4_uprcut_anim

	.ref	adm_run_anim,adm_run2_anim,adm_ocrun_anim,adm_run_anim,adm_bounce_anim

 	.ref	adm_2_lbowdrop_anim,adm_4_lbowdrop_anim

	.ref	adm_grab_throw_anim
	.ref	adm_2_grabfling_anim
	.ref	adm_4_grabfling_anim

	.ref	adm_2_graboh_anim,adm_heldoh_anim
	.ref	adm_4_graboh_anim

	.ref	adm_2_fly_cline_anim,adm_4_fly_cline_anim
	.ref	adm_flying_kick_anim

	.ref	adm_4_head_hit_anim
	.ref	adm_2_face_hit_anim,adm_4_face_hit_anim
	.ref	adm_2_head_hit_anim
	.ref	adm_2_body_hit_anim,adm_4_body_hit_anim
	.ref	adm_fall_back_anim
	.ref	adm_faceup_getup_anim
	.ref	adm_hitonground_anim
	.ref	adm_4_stomp_anim,adm_2_stomp_anim
	.ref	adm_2ndwind_anim
	.ref	adm_climb_up_anim,adm_climb_down_anim
	.ref	adm_2_hitblock_anim,adm_4_hitblock_anim
	.ref	adm_hiptoss_anim,adm_hiptossfall_anim
	.ref	adm_4_push_anim,adm_2_push_anim
	.ref	adm_4_bigboot_anim,adm_2_bigboot_anim
	.ref	adm_4_block_anim,adm_2_block_anim
	.ref	adm_4_losebal_anim,adm_2_losebal_anim
	.ref	adm_dizzy_anim
	.ref	adm_raisearm_anim
	.ref	adm_ohthrow1_anim

	.ref	adm_2_lockup_anim,adm_4_lockup_anim


******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************

adam_secret_moves
	.long	#button_hold	;must have this one

	.long	#grab_fling
;;	.long	#turbo_run
	.long	#2nd_wind1
	.long	#2nd_wind2
	.long	0

#button_hold
	rets

;		BITS			MASK

#grab_fling
	.word	B_GRAB | J_AWAY,	J_UP | J_DOWN
	.word	8000h | 10		;max
	.long	scrt_grabfling

#turbo_run
	.word	B_TURBO,		J_ALL
	.word	B_TURBO,		J_ALL
	.word	8000h | 16 		;max
	.long	scrt_run

#2nd_wind1
	.word	J_UP,			0
	.word	J_UP_AWAY,		0
	.word	J_AWAY,			0
	.word	J_DOWN_AWAY,		0
	.word	J_DOWN,			0
	.word	J_DOWN_TOWARD,		0
	.word	J_TOWARD,		0
	.word	J_UP_TOWARD,		0
	.word	J_UP,			0
	.word	8000h | 50		;max
	.long	scrt_2ndwind

#2nd_wind2
	.word	J_UP,			0
	.word	J_UP_TOWARD,		0
	.word	J_TOWARD,		0
	.word	J_DOWN_TOWARD,		0
	.word	J_DOWN,			0
	.word	J_DOWN_AWAY,		0
	.word	J_AWAY,			0
	.word	J_UP_AWAY,		0
	.word	J_UP,			0
	.word	8000h | 50 		;max
	.long	scrt_2ndwind


 .if 0
	J_UP
	J_UP_TOWARD
	J_TOWARD
	J_DOWN_TOWARD
	J_DOWN
	J_DOWN_AWAY
	J_AWAY
	J_UP_AWAY

	B_PUNCH
	B_KICK
	B_BLOCK
	B_GRAB
	B_TURBO
	B_RUN

 .endif


scrt_grabfling

;Make this miss, rotate to missed opponent,
;and stay rotated to flung opponent, also make
;this work from both angles!


	movi	adm_2_grabfling_anim,a0

	move	*a13(FACING_DIR),a1
	btst	MOVE_UP_BIT,a1
	jrnz	#2_grb
	movi	adm_4_grabfling_anim,a0
#2_grb
	calla	change_anim1a

	WRSND	W_ADAM,GRABFLING_T1,GRABFLING_T2

	rets

scrt_run

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_scrt_run
	move	*a13(PLYRMODE),a0

	move	*a13(PLYRMODE),a0
	cmpi	MODE_RUNNING,a0
	jreq	#no_scrt_run
	cmpi	MODE_BOUNCING,a0
	jreq	#no_scrt_run
	calla	start_run

#no_scrt_run
	rets

scrt_2ndwind
	movi	adm_2ndwind_anim,a0
	calla	change_anim1a
	rets

#*****************************************************************************

 SUBR	adam_ani_init

	movi	adm_stand2_anim,a0
	calla	change_anim1

	movi	adm_torso2_anim,a0
	calla	change_anim2

	rets


#*****************************************************************************
*
* ADAMS CONTROL CODE
*
* a13 = * adam process

 SUBR	move_adam

	movi	100h,a0			;temp fix!
	move	a0,*a13(ANI_SPEED)

	movi	adam_secret_moves,a11
	calla	check_secret_moves

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
	.long	mode_grapple		;13
	.long	mode_master		;14
	.long	mode_slave		;15
	.long	mode_headhold		;16

#*****************************************************************************

mode_normal


	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_interrupt

 .if 1
	calla	get_opp_plyrmode
	cmpi	MODE_DEAD,a0
	jrne	#opp_not_dead

	movi	adm_raisearm_anim,a0
	calla	change_anim1a
	rets

#opp_not_dead

	GETLIFE
	jruc	#not_dizzy
	jrnz	#not_dizzy

	SETMODE	DIZZY
	movi	adm_dizzy_anim,a0
	calla	change_anim1a
	rets

 .endif
#not_dizzy


	move	a13,a0
	calla	wres_get_but_val_cur
	btst	PLAYER_BLOCK_BIT,a0	;maybe have to action tables?
	jrz	#nblk			;1 for down transitions
	callr	#block			;& 1 for current buttons
#nblk
	move	a13,a0
	calla	wres_get_but_val_down
	andi	011111b,a0
	X32	a0
	addi	#action_table,a0
	move	*a0,a0,L
	call	a0

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_interrupt

	move	a13,a0
	calla	wres_get_stick_val_cur
	move	a0,*a13(MOVE_DIR)
	calla	climb_turnbuckle
	jrnc	#no_climb
	rets
#no_climb

	calla	execute_walk

#no_interrupt
	rets

#action_table
	.long	#z			;0
	.long	#punch			;1
	.long	#block			;2
	.long	#z			;3
	.long	#super_punch		;4
	.long	#z,#z,#z		;5-7
	.long	#kick			;8
	.long	#z,#z,#z,#z,#z,#z,#z	;9-15
	.long	#super_kick		;16
	.long	#z,#z,#z,#z,#z,#z,#z	;17-23
	.long	#z,#z,#z,#z,#z,#z,#z,#z	;24-31

************
#z
	rets

************
#punch		;1
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal	<  60  92	headbutt
* dizzy			"		"
* normal	>		normal punch
* dizzy			"		"
*
* onground	<  96 112	elbow drop
* onground	>		normal punch
*
* running |	< 100  60	hip toss 
* bouncing	>		normal punch
*
* onturnbkl			normal punch
* climbturnbkl			normal punch
*

	JJXM_INIT
	JJXM	NORMAL,		 60, 92,#punch_hdbutt,#punch_punch
	JJXM	DIZZY,		 60, 92,#punch_hdbutt,#punch_punch
	JJXM	ONGROUND,	 96,112,#punch_lbdrop,#punch_punch
	JJXM	RUNNING,	100, 60,#punch_hiptoss,#punch_punch
	JJXM	BOUNCING,	100, 60,#punch_hiptoss,#punch_punch
	JJXM	ONTURNBKL,		#punch_punch
	JJXM	CLIMBTURNBKL,		#punch_punch

 .if DEBUG
	LOCKUP
	rets
 .endif

*****
#punch_rets
	rets

*****	
#punch_punch

	FACE24	adm,punch_anim
	calla	change_anim1a

	WRSND	W_ADAM,PUNCH_T1,PUNCH_T2

	rets

*****
#punch_hdbutt

	FACE24	adm,butt_anim
	calla	change_anim1a

	WRSND	W_ADAM,PUNCH_T1,PUNCH_T2

	rets

*****
#punch_lbdrop

	FACE24	adm,lbowdrop_anim
	calla	change_anim1a

	WRSND	W_ADAM,PUNCH_T1,PUNCH_T2

	rets

*****
#punch_hiptoss

	movi	adm_hiptoss_anim,a0
	calla	change_anim1a

	WRSND	W_ADAM,PUNCH_T1,PUNCH_T2

	rets

************
#block		;2
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* all				nothing.  Ha.	
*

	rets

************
#super_punch	;4
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* all				uppercut
*

	FACE24	adm,uprcut_anim
	calla	change_anim1a

	WRSND	W_ADAM,PUNCH_T1,PUNCH_T2

	rets

************
#kick		;8
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal			normal kick
*
* onground	<  96 112	stomp
* onground	>		normal kick
*
* running |
* bouncing 			big boot
*
* onturnbkl			knee
*

	JJXM_INIT
	JJXM	NORMAL,			#kick_kick
	JJXM	DIZZY,			#kick_kick
	JJXM	ONGROUND,	 96,112,#kick_stomp,#kick_kick
	JJXM	RUNNING,		#kick_bigboot
	JJXM	BOUNCING,		#kick_bigboot
	JJXM	ONTURNBKL,		#kick_kick
	JJXM	CLIMBTURNBKL,		#kick_kick

 .if DEBUG
	LOCKUP
	rets
 .endif

*****
#kick_kick

	FACE24	adm,kick_anim
	calla	change_anim1

	WRSND	W_ADAM,KICK_T1,KICK_T2
	rets

*****
#kick_stomp
	FACE24	adm,stomp_anim
	calla	change_anim1

	WRSND	W_ADAM,KICK_T1,KICK_T2
	rets

*****
#kick_bigboot
	FACE24	adm,bigboot_anim
	calla	change_anim1

	WRSND	W_ADAM,KICK_T1,KICK_T2
	rets

************
#super_kick	;16
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal			normal kick
*
* onground	<  96 112	stomp
* onground	>		normal kick
*
* running |
* bouncing 			big boot
*
* onturnbkl			normal kick
*

	JJXM_INIT
	JJXM	NORMAL,			#skick_kick
	JJXM	DIZZY,			#skick_kick
	JJXM	ONGROUND,	 96,112,#skick_stomp,#skick_kick
	JJXM	RUNNING,		#skick_bigboot
	JJXM	BOUNCING,		#skick_bigboot
	JJXM	ONTURNBKL,		#skick_kick
	JJXM	CLIMBTURNBKL,		#skick_kick

 .if DEBUG
	LOCKUP
	rets
 .endif

*****
#skick_kick

	FACE24	adm,kick_anim
	calla	change_anim1

	WRSND	W_ADAM,KICK_T1,KICK_T2
	rets

*****
#skick_stomp
	FACE24	adm,stomp_anim
	calla	change_anim1

	WRSND	W_ADAM,KICK_T1,KICK_T2
	rets

*****
#skick_bigboot
	FACE24	adm,bigboot_anim
	calla	change_anim1

	WRSND	W_ADAM,KICK_T1,KICK_T2
	rets

#*****************************************************************************
*
* RUNNING (if GETUP_TIME > 0 then player is out of control)
*

#XRUN_VAL	equ	60000h		;50000h
#ZDRIFT_VAL	equ	20000h		;18000h

mode_running

	move	*a13(GETUP_TIME),a0		;delay b4 gaining control
	jrz	#not_octrl

	calla	keep_attached			;if still being flung
	jrnz	#out_of_control			;(Z=0 - still attached)

;not_attached

#not_octrl

	calla	bounce_off_ropes

	move	*a13(MOVE_DIR),a0

	movi	#XRUN_VAL,a1
	btst	PLAYER_RIGHT_BIT,a0
	jrnz	#setxvel

	movi	-#XRUN_VAL,a1
#setxvel
	move	a1,*a13(OBJ_XVEL),L


	move	*a13(GETUP_TIME),a0		;delay b4 gaining control
	jrnz	#out_of_control

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_interrupt

	move	a13,a0
	calla	wres_get_but_val_cur
	btst	PLAYER_TURBO_BIT,a0		;turbo down?
	jrnz	#run_down

	;has released turbo - go back to walk mode

	SETMODE	NORMAL

#run_down
#no_interrupt

	move	a13,a0
	calla	wres_get_stick_val_cur
	clr	a1

	movi	-#ZDRIFT_VAL,a1
	btst	PLAYER_UP_BIT,a0
	jrnz	#setvel

	movi	#ZDRIFT_VAL,a1
	btst	PLAYER_DOWN_BIT,a0
	jrnz	#setvel

	clr	a1
#setvel
	move	a1,*a13(OBJ_ZVEL),L


	move	a13,a0
	calla	wres_get_but_val_down
	andi	011111b,a0
	X32	a0
	addi	#action_table,a0
	move	*a0,a0,L
	call	a0
#out_of_control
	rets

#action_table
	.long	#z			;0
	.long	#punch			;1 (punch)
	.long	#z			;2 (block)
	.long	#z			;3
	.long	#z			;4 (super punch)
	.long	#z,#z,#z		;5-7
	.long	#kick			;8 kick
	.long	#z,#z,#z,#z,#z,#z,#z	;9-15
	.long	#z			;16 (super kick)
	.long	#z,#z,#z,#z,#z,#z,#z	;17-23
	.long	#z,#z,#z,#z,#z,#z,#z,#z	;24-31

************
#z
	rets

************
#punch		;1
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* all				flying clothesline
*

	FACE24	adm,fly_cline_anim
	calla	change_anim1

	;halve his velocity
	move	*a13(OBJ_XVEL),a0,L
	sra	1,a0
	move	a0,*a13(OBJ_XVEL),L

	WRSND	W_ADAM,FLYKICK_T1,FLYKICK_T2
	rets

************
#kick		;#4
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* all				flying kick
*


*****
	movi	adm_flying_kick_anim,a0
	calla	change_anim1

	SETMODE	INAIR

	move	*a13(OBJ_XVEL),a0,L
	sra	1,a0
	move	a0,*a13(OBJ_XVEL),L

	WRSND	W_ADAM,FLYKICK_T1,FLYKICK_T2

	rets

#*****************************************************************************
*

mode_inair	;2

	rets

#*****************************************************************************
*

mode_attached	;3


	calla	keep_attached
	jrnz	#still_attached

	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	SETMODE	NORMAL

	movi	MODE_NORMAL,a0
	move	a0,*a13(ANIMODE)

#still_attached
	rets

#*****************************************************************************
#ZROLL_VAL	equ	20000h
#ROLL_SPEED	equ	50h
#ROLL_FRAMES	equ	9

mode_onground	;4

;	move	a13,a0
;	calla	wres_get_but_val_cur
;	btst	PLAYER_TURBO_BIT,a0
;	jrz	#no_cheat
;
;	clr	a0
;	move	a0,*a13(GETUP_TIME)
;#no_cheat

	move	*a13(GETUP_TIME),a0
	jrnz	#nomove

	move	a13,a0
	calla	wres_get_stick_val_cur

	movi	-#ROLL_SPEED,a2
	movi	-#ZROLL_VAL,a1
	btst	PLAYER_UP_BIT,a0
	jrnz	#setvel

	movi	#ROLL_SPEED,a2
	movi	#ZROLL_VAL,a1
	btst	PLAYER_DOWN_BIT,a0
	jrnz	#setvel

	clr	a1
	clr	a2

	movi	adm_faceup_getup_anim,a0
	calla	change_anim1

	SETMODE	NORMAL

	rets

#setvel
	move	a1,*a13(OBJ_ZVEL),L

	move	*a13(ROLL_POS),a0
	add	a2,a0
	jrp	#ok1
	addi	#ROLL_FRAMES<<8,a0
#ok1
	cmpi	#ROLL_FRAMES<<8,a0
	jrlt	#ok2

;	subi	#ROLL_FRAMES,a0
	subi	#ROLL_FRAMES<<8,a0
#ok2

	move	a0,*a13(ROLL_POS)

	move	*a13(ROLL_POS),a0
	srl	8,a0
	sll	5,a0
	addi	adm_roll_frames,a0
	move	*a0,a0,L
	move	a0,*a13(CUR_FRAME),L

#nomove
	rets


#*****************************************************************************
*
* bouncing off ropes while running

mode_bouncing	;5

	clr	a0
	move	a0,*a13(OBJ_XVEL),L
	move	a0,*a13(OBJ_ZVEL),L

	move	*a13(ANIMODE),a0
	btst	MODE_END_BIT,a0
	jrz	#not_ended

	move	*a13(MOVE_DIR),a0
	xori	MOVE_LEFT+MOVE_RIGHT,a0	;flip LEFT/RIGHT
	move	a0,*a13(MOVE_DIR)

	move	*a13(NEW_FACING_DIR),a1
	andi	MOVE_UP+MOVE_DOWN,a1
	or	a0,a1			;LEFT or RIGHT
	move	a1,*a13(FACING_DIR)	;face same dir as run

	movi	adm_run2_anim,a0
	calla	change_anim1a

	SETMODE	RUNNING

;	clr	a0
;	move	a0,*a13(GETUP_TIME)	;in control

#not_ended
	rets

#*****************************************************************************
*
* STANDING ON TOP OF TURNBUCKLE

mode_onturnbkl	;6

	move	a13,a0
	calla	wres_get_stick_val_cur
	btst	PLAYER_DOWN_BIT,a0
	jrz	#no_climbdown

	movi	adm_climb_down_anim,a0
	calla	change_anim1

	SETMODE	CLIMBTURNBKL

	rets


#no_climbdown
	move	a13,a0
	calla	wres_get_but_val_down
	andi	01111b,a0		;mask out turbo button
	jrz	#no_exit

	SETMODE	INAIR

	.ref	adm_diveofftb_anim
	movi	adm_diveofftb_anim,a0
	calla	change_anim1

	rets

#no_exit
	rets

#*****************************************************************************
* blocking

mode_block	;7

	move	a13,a0
	calla	wres_get_but_val_cur
	btst	PLAYER_BLOCK_BIT,a0
	jrnz	#still_blocking

	SETMODE	NORMAL

#still_blocking
	rets

#*****************************************************************************
* adam with zero health

mode_dizzy	;8

	rets

#*****************************************************************************
mode_dead	;9

	rets

#*****************************************************************************
* opponent held overhead

mode_oppoverhead ;10

	move	*a13(ATTACH_PROC),a2,L		;proc attached to
	jrz	#not_attached
	move	*a2(ATTACH_PROC),a0,L
	jrnz	#still_attached

#not_attached

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_interrupt

	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	SETMODE	NORMAL

	movi	MODE_NORMAL,a0
	move	a0,*a13(ANIMODE)

#no_interrupt
	rets

#still_attached

	move	a13,a0
	calla	wres_get_but_val_down
	andi	011111b,a0
	X32	a0
	addi	#action_table,a0
	move	*a0,a0,L
	call	a0
	rets

#action_table
	.long	#z			;0
	.long	#punch			;1
	.long	#block			;2
	.long	#z			;3
	.long	#super_punch		;4
	.long	#z,#z,#z		;5-7
	.long	#kick			;8
	.long	#z,#z,#z,#z,#z,#z,#z	;9-15
	.long	#super_kick		;16
	.long	#z,#z,#z,#z,#z,#z,#z	;17-23
	.long	#z,#z,#z,#z,#z,#z,#z,#z	;24-31

************
#z
	rets

************
#punch		;1
#block		;2
#super_punch	;4
#kick		;8
#super_kick	;16
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* all				overhead throw
*
	movi	adm_ohthrow1_anim,a0
	calla	change_anim1

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

mode_grapple	;13

	move	*a13(GETUP_TIME),a0
	jrnz	#still_going

;now get move off
;if opponents meter almost zero then break apart

	calla	break_lockup
	rets



;	.ref	dnk_3_pile_driver_anim
;	movi	dnk_3_pile_driver_anim,a0

;	.ref	dnk_3_head_hold_anim
;	movi	dnk_3_head_hold_anim,a0

;	calla	change_anim1a

;	SETMODE	MASTER
	SETMODE	HEADHOLD

	SETMODE	NORMAL	;<---- temp!

	PUSH	a13
	move	*a13(ATTACH_PROC),a13,L
	movi	MODE_SLAVE,a0
	move	a0,*a13(PLYRMODE)
;	movi	wres_slave_anim,a0

;	.ref	dnk_3_head_held_anim
;	movi	dnk_3_head_held_anim,a0
;	calla	change_anim1a
	PULL	a13

	rets


#still_going

	calla	lineup_grapple

	rets


#*****************************************************************************

mode_master	;14

	.ref	master_keep_attached
	calla	master_keep_attached	;keep slave attached to me

	rets

#*****************************************************************************

mode_slave	;15
	rets

#*****************************************************************************

mode_headhold	;16

	move	*a13(ANIMODE),a0
	btst	MODE_END_BIT,a0
	jrz	#not_ended

	clr	a0
	movi	MODE_NORMAL,a1
	move	a1,*a13(PLYRMODE)

	move	*a13(ATTACH_PROC),a10,L
	jrz	#skp
	move	a1,*a10(PLYRMODE)
	move	a0,*a10(ATTACH_PROC),L
#skp
	move	a0,*a13(ATTACH_PROC),L

#not_ended
	rets


#*****************************************************************************

#VEL	equ	30000h
#DVEL	equ	21f0eh


 SUBR adm_velocity_table

;		X,	Z

	.long	0,	-#VEL	;0 UP

	.long	#DVEL,	-#DVEL	;1 UP-RIGHT

	.long	#VEL,	0	;2 RIGHT

	.long	#DVEL,	#DVEL	;3 DOWN-RIGHT

	.long	0,	#VEL	;4 DOWN

	.long	-#DVEL,	#DVEL	;5 DOWN-LEFT

	.long	-#VEL,	0	;6 LEFT

	.long	-#DVEL,	-#DVEL	;7 UP-LEFT


#*****************************************************************************

 SUBR adm_rotate_anims_table
; old = up right
	.long	adm_stand2_anim		;new = up right
	.long	adm_2_to_4_turn_anim	;    = down right
	.long	adm_2_to_6_turn_anim	;    = down left ***
	.long	adm_2_to_8_turn_anim	;    = up left

; old = down right
	.long	adm_4_to_2_turn_anim	;new = up right
	.long	adm_stand4_anim		;    = down right
	.long	adm_4_to_6_turn_anim	;    = down left
	.long	adm_4_to_8_turn_anim	;    = up left ***

; old = down left
	.long	adm_6_to_2_turn_anim	;new = up right ***
	.long	adm_6_to_4_turn_anim	;    = down right
	.long	adm_stand6_anim		;    = down left
	.long	adm_6_to_8_turn_anim	;    = up left

; old = up left
	.long	adm_8_to_2_turn_anim	;new = up right
	.long	adm_8_to_4_turn_anim	;    = down right ***
	.long	adm_8_to_6_turn_anim	;    = down left
	.long	adm_stand8_anim		;    = up left


 SUBR adm_leg_anims_table
;  MOVE
;(#1 - UP)				FACING
	.long	adm_walk1_f2_anim	;1 (UP)
	.long	adm_walk1_f2_anim	;2 (UP_RIGHT)
	.long	adm_walk1_f4_anim	;3 (RIGHT)
	.long	adm_walk1_f4_anim	;4 (DOWN_RIGHT)
	.long	adm_walk1_f4_anim	;5 (DOWN)
	.long	adm_walk1_f4_anim	;6 (DOWN_LEFT)
	.long	adm_walk1_f2_anim	;7 (LEFT)
	.long	adm_walk1_f2_anim	;8 (UP-LEFT)

;(#2 - UP-RIGHT)
	.long	adm_walk2_f2_anim	;1 (UP)
	.long	adm_walk2_f2_anim	;2 (UP_RIGHT)
	.long	adm_walk2_f2_anim	;3 (RIGHT)
	.long	adm_walk2_f4_anim	;4 (DOWN_RIGHT)
	.long	adm_walk8_f4_anim	;5 (DOWN)
	.long	adm_walk8_f4_anim	;6 (DOWN_LEFT)
	.long	adm_walk4_f2_anim	;7 (LEFT)
	.long	adm_walk4_f2_anim	;8 (UP-LEFT)

;(#3 - RIGHT)
	.long	adm_walk2_f2_anim	;1 (UP)
	.long	adm_walk2_f2_anim	;2 (UP_RIGHT)
	.long	adm_walk2_f2_anim	;3 (RIGHT)
	.long	adm_walk4_f4_anim	;4 (DOWN_RIGHT)
	.long	adm_walk4_f4_anim	;5 (DOWN)
	.long	adm_walk8_f4_anim	;6 (DOWN_LEFT)
	.long	adm_walk6_f2_anim	;7 (LEFT)
	.long	adm_walk6_f2_anim	;8 (UP-LEFT)


;(#4 - DOWN-RIGHT)
	.long	adm_walk2_f2_anim	;1 (UP)
	.long	adm_walk8_f2_anim	;2 (UP_RIGHT)
	.long	adm_walk4_f4_anim	;3 (RIGHT)
	.long	adm_walk4_f4_anim	;4 (DOWN_RIGHT)
	.long	adm_walk2_f4_anim	;5 (DOWN)
	.long	adm_walk6_f4_anim	;6 (DOWN_LEFT)
	.long	adm_walk2_f2_anim	;7 (LEFT)
	.long	adm_walk6_f2_anim	;8 (UP-LEFT)

;(#5 - DOWN)
	.long	adm_walk5_f2_anim	;1 (UP)
	.long	adm_walk5_f2_anim	;2 (UP_RIGHT)
	.long	adm_walk5_f4_anim	;3 (RIGHT)
	.long	adm_walk5_f4_anim	;4 (DOWN_RIGHT)
	.long	adm_walk5_f4_anim	;5 (DOWN)
	.long	adm_walk5_f4_anim	;6 (DOWN_LEFT)
	.long	adm_walk5_f2_anim	;7 (LEFT)
	.long	adm_walk5_f2_anim	;8 (UP-LEFT)

;(#6 - DOWN-LEFT)
	.long	adm_walk2_f2_anim	;1 (UP)
	.long	adm_walk6_f2_anim	;2 (UP_RIGHT)
	.long	adm_walk2_f2_anim	;3 (RIGHT)
	.long	adm_walk6_f4_anim	;4 (DOWN_RIGHT)
	.long	adm_walk2_f4_anim	;5 (DOWN)
	.long	adm_walk4_f4_anim	;6 (DOWN_LEFT)
	.long	adm_walk2_f2_anim	;7 (LEFT)
	.long	adm_walk8_f2_anim	;8 (UP-LEFT)

;(#7 - LEFT)
	.long	adm_walk2_f2_anim	;1 (UP)
	.long	adm_walk6_f2_anim	;2 (UP_RIGHT)
	.long	adm_walk6_f2_anim	;3 (RIGHT)
	.long	adm_walk8_f4_anim	;4 (DOWN_RIGHT)
	.long	adm_walk4_f4_anim	;5 (DOWN)
	.long	adm_walk4_f4_anim	;6 (DOWN_LEFT)
	.long	adm_walk2_f2_anim	;7 (LEFT)
	.long	adm_walk2_f2_anim	;8 (UP-LEFT)

;(#8 - UP-LEFT)
	.long	adm_walk2_f2_anim	;1 (UP)
	.long	adm_walk4_f2_anim	;2 (UP_RIGHT)
	.long	adm_walk6_f2_anim	;3 (RIGHT)
	.long	adm_walk8_f4_anim	;4 (DOWN_RIGHT)
	.long	adm_walk6_f4_anim	;5 (DOWN)
	.long	adm_walk2_f4_anim	;6 (DOWN_LEFT)
	.long	adm_walk2_f2_anim	;7 (LEFT)
	.long	adm_walk2_f2_anim	;8 (UP-LEFT)


 SUBR adm_torso_anims_table
; old = up right
	.long	adm_torso2_anim		;new = up right
	.long	adm_2_to_4_turn2_anim	;    = down right
	.long	adm_2_to_6_turn2_anim	;    = down left ***
	.long	adm_2_to_8_turn2_anim	;    = up left

; old = down right
	.long	adm_4_to_2_turn2_anim	;new = up right
	.long	adm_torso4_anim		;    = down right
	.long	adm_4_to_6_turn2_anim	;    = down left
	.long	adm_4_to_8_turn2_anim	;    = up left ***

; old = down left
	.long	adm_6_to_2_turn2_anim	;new = up right ***
	.long	adm_6_to_4_turn2_anim	;    = down right
	.long	adm_torso6_anim		;    = down left
	.long	adm_6_to_8_turn2_anim	;    = up left

; old = up left
	.long	adm_8_to_2_turn2_anim	;new = up right
	.long	adm_8_to_4_turn2_anim	;    = down right ***
	.long	adm_8_to_6_turn2_anim	;    = down left
	.long	adm_torso8_anim		;    = up left


#*****************************************************************************
* adam HAS JUST BEEN HIT
* a10 = * offensive process
* a13 = * defensive process (adam)

 SUBR	adam_hit

	move	*a10(ATTACK_MODE),a0	;type of attack that hit adam
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
	.long	_grapple	;13
	.long	_boxpunch	;14
	.long	_stomp		;15
	.long	_spinkick	;16
	.long	_cline		;17
	.long	_headhold	;18
	.long	_jumpkick	;19
	.long	_run		;20
	.long	_puppet		;21
	.long	_backhand	;22
	.long	_buzz		;23


#************************
;AMODE_PUNCH	0
_punch


;;	cmpi	6,a1			;a1 = consecutive hits
;;	jrlt	#ok
;;	LOCKUP
;;#ok


	WRSND	W_ADAM,PUNCH_L1,PUNCH_L2

	GETLIFE
	jrnz	#not_dizzy

	movi	adm_fall_back_anim,a0
	calla	change_anim1

	SETMODE	DEAD
	rets

#not_dizzy

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jreq	#block

	DAMAGE	1

	SETMODE	NORMAL			;don't change if blocking

	movi	adm_2_head_hit_anim,a0
	move	*a13(FACING_DIR),a1
	btst	MOVE_UP_BIT,a1
	jrnz	#2_hit
	movi	adm_4_head_hit_anim,a0
#2_hit
	calla	change_anim1a
	calla	wres_collis_off
	rets

#block
	DAMAGE	1

	movi	adm_2_hitblock_anim,a0
	move	*a13(FACING_DIR),a1
	btst	MOVE_UP_BIT,a1
	jrnz	#2_blk
	movi	adm_4_hitblock_anim,a0
#2_blk
	calla	change_anim1a

	movi	[2,0],a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1		;offx - defx
	jrgt	#slide_right	;attacker on left
	neg	a2
#slide_right
	move	a2,*a13(OBJ_XVEL),L

	calla	wres_collis_off
	rets


#************************
;AMODE_HDBUTT	1
_hdbutt

	DAMAGE	10

	WRSND	W_ADAM,HDBUTT_L1,HDBUTT_L2

	movi	adm_2_hitblock_anim,a0
	move	*a13(FACING_DIR),a1
	btst	MOVE_UP_BIT,a1
	jrnz	#2_blk
	movi	adm_4_hitblock_anim,a0
#2_blk

	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jreq	#block1

	SETMODE	NORMAL

	movi	adm_2_face_hit_anim,a0
	move	*a13(FACING_DIR),a1
	btst	MOVE_UP_BIT,a1
	jrnz	#2_noblk
	movi	adm_4_face_hit_anim,a0
#2_noblk
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

#block1
	calla	change_anim1a

	calla	wres_collis_off
	rets

#************************
;AMODE_KICK	2
_kick

	DAMAGE	10

	WRSND	W_ADAM,KICK_L1,KICK_L2

	movi	adm_2_hitblock_anim,a0
	move	*a13(FACING_DIR),a1
	btst	MOVE_UP_BIT,a1
	jrnz	#2_blk
	movi	adm_4_hitblock_anim,a0
#2_blk
	move	*a13(PLYRMODE),a1
	cmpi	MODE_BLOCK,a1
	jreq	#anim

	SETMODE	NORMAL

	movi	adm_2_body_hit_anim,a0
	move	*a13(FACING_DIR),a1
	btst	MOVE_UP_BIT,a1
	jrnz	#anim
	movi	adm_4_body_hit_anim,a0

#anim
	calla	change_anim1a

	calla	wres_collis_off
	rets

#************************
;AMODE_FLYKICK	3
_flykick

	DAMAGE	10

	WRSND	W_ADAM,FLYKICK_L1,FLYKICK_L2
*
	clr	a0
	move	a0,*a13(ROLL_POS)
	movi	TSEC*2,a0
	move	a0,*a13(GETUP_TIME)

	movi	adm_fall_back_anim,a0
	calla	change_anim1
	movi	[4,0],a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1		;offx - defx
	jrgt	#fall_right	;attacker on left
	movi	[-4,0],a2
#fall_right
	move	a2,*a13(OBJ_XVEL),L

	SETMODE	NORMAL

	calla	wres_collis_off
	rets

#************************
;AMODE_GRABTHROW 4
_grabthrow

	DAMAGE	10

	SETMODE	ATTACHED

	move	a10,*a13(ATTACH_PROC),L		;proc attached to
	move	a13,*a10(ATTACH_PROC),L

	movi	adm_heldoh_anim,a0
	calla	change_anim1

	calla	wres_collis_off
	rets

#************************
;AMODE_UPRCUT	5
_uprcut

	DAMAGE	10

	WRSND	W_ADAM,UPRCUT_L1,UPRCUT_L2

	movi	adm_fall_back_anim,a0
	calla	change_anim1

	clr	a0
	move	a0,*a13(ROLL_POS)
	movi	TSEC*2,a0
	move	a0,*a13(GETUP_TIME)


	movi	[10,0],a0
	move	a0,*a13(OBJ_YVEL),L

	movi	[2,0],a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1		;offx - defx
	jrgt	#fall_right2	;attacker on left
	movi	[-2,0],a2
#fall_right2
	move	a2,*a13(OBJ_XVEL),L

	calla	wres_collis_off
	rets

#************************
;AMODE_LBOWDROP	6
_lbowdrop

	DAMAGE	10

	WRSND	W_ADAM,LBOWDROP_L1,LBOWDROP_L2

	movi	adm_hitonground_anim,a0
	calla	change_anim1a

	calla	wres_collis_off
	rets
	
#************************
;AMODE_GRABHOLD	7
_grabhold

	DAMAGE	10

	WRSND	W_ADAM,GRABHOLD_L1,GRABHOLD_L2

	SETMODE	ATTACHED

	move	a10,*a13(ATTACH_PROC),L		;proc attached to
	move	a13,*a10(ATTACH_PROC),L

	movi	adm_heldoh_anim,a0
	calla	change_anim1

	calla	wres_collis_off
	rets

#************************
;AMODE_GRABFLING 8
_grabfling

	DAMAGE	10

	SETMODE	RUNNING

	movi	TSEC*2,a0
	move	a0,*a13(GETUP_TIME)		;delay b4 gaining control

	move	*a13(FACING_DIR),a0	;use facing
	andi	PLAYER_LEFT_VAL|PLAYER_RIGHT_VAL,a0
	move	a0,*a13(MOVE_DIR)

	move	a10,*a13(ATTACH_PROC),L		;proc attached to
	move	a13,*a10(ATTACH_PROC),L

	movi	adm_ocrun_anim,a0
	calla	change_anim1

	calla	wres_collis_off
	rets

#************************
;AMODE_PUSH	9
_push

	DAMAGE	10

	WRSND	W_ADAM,LBOWDROP_L1,LBOWDROP_L2

	SETMODE	NORMAL

	movi	adm_2_losebal_anim,a0
	move	*a13(FACING_DIR),a1
	btst	MOVE_UP_BIT,a1
	jrnz	#2_loseb
	movi	adm_4_losebal_anim,a0
#2_loseb
	calla	change_anim1

	movi	[5,0],a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1		;offx - defx
	jrgt	#fall_rightlb	;attacker on left
	neg	a2
#fall_rightlb
	move	a2,*a13(OBJ_XVEL),L

	calla	wres_collis_off
	rets

#************************
;AMODE_HIPTOSS	10
_hiptoss

	DAMAGE	10

	WRSND	W_ADAM,HIPTOSS_L1,HIPTOSS_L2

	clr	a0
	move	a0,*a13(ROLL_POS)
	movi	TSEC*2,a0
	move	a0,*a13(GETUP_TIME)

	movi	adm_hiptossfall_anim,a0
	calla	change_anim1

	calla	wres_collis_off
	rets

#************************
;AMODE_BIGBOOT	11
_bigboot

	DAMAGE	10

	WRSND	W_ADAM,LBOWDROP_L1,LBOWDROP_L2

	clr	a0
	move	a0,*a13(ROLL_POS)
	movi	TSEC*2,a0
	move	a0,*a13(GETUP_TIME)

	movi	adm_fall_back_anim,a0
	calla	change_anim1
	movi	[4,0],a2
	move	*a10(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1		;offx - defx
	jrgt	#fall_rightz	;attacker on left
	movi	[-4,0],a2
#fall_rightz
	move	a2,*a13(OBJ_XVEL),L

	SETMODE	NORMAL

	calla	wres_collis_off
	rets

#************************
;AMODE_KNEE	12
_knee
	calla	wres_collis_off
	rets

#************************

_grapple		;13


	calla	face_each_other

	move	a10,*a13(ATTACH_PROC),L		;proc attached to
	move	a13,*a10(ATTACH_PROC),L

 	move	*a13(OBJ_ZPOSINT),a0
 	move	*a10(OBJ_ZPOSINT),a1
	add	a1,a0
	srl	1,a0
	sll	16,a0
 	move	a0,*a13(OBJ_ZPOS),L
 	move	a0,*a10(OBJ_ZPOS),L


	movi	MODE_GRAPPLE,a0
	move	a0,*a13(PLYRMODE)		;slave
	move	a0,*a10(PLYRMODE)		;master

	movi	20*3,a0				;20 button presses
	movi	1*3,a0				;1 button press !!! temp !!!
	move	a0,*a13(GETUP_TIME)
	move	a0,*a10(GETUP_TIME)

	movi	wres_slave_anim,a0
	calla	change_anim1a

	calla	wres_collis_off
	rets

#************************

_boxpunch	;14
_stomp		;15
_spinkick	;16
_cline		;17
_headhold	;18
_jumpkick	;19
_run		;20
_puppet		;21
_backhand	;22
_buzz		;23
	rets

******************************************************************************
	.end
