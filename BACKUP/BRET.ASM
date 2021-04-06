**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		8/24/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"bret.asm"
	.title	"Bret Hart specific game code"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"macros.h"
	.include	"jjxm.h"
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

	.ref	set_getup_time,inc_getup_time
	.ref	wres_get_but_val_up,wres_get_but_val_down,wres_get_but_val_cur
	.ref	wres_get_stick_val_cur
	.ref	get_punch_dtime
	.ref	get_rope_x
	.ref	clear_damage_log
	.ref	check_dizzy

	.ref	change_anim1,change_anim1a
	.ref	change_anim2,change_anim2a
	.ref	process_ptrs
	.ref	keep_attached
	.ref	get_opp_plyrmode
	.ref	wres_collis_off
	.ref	convert_facing
	.ref	check_secret_moves
	.ref	change_walk_anim
	.ref	set_rotate_anim
	.ref	execute_walk
	.ref	bounce_off_ropes
	.ref	climb_turnbuckle
	.ref	do_roll,JUMP_ROPES

	;from DCSSOUND.ASM
	.ref	triple_sound

	;from WRESTLE.ASM
	.ref	lineup_grapple

******************************************************************************
* ANIMATION SEQUENCES

	.ref	wres_slave_anim
	.ref	hrt_zip_anim
	.ref	start_run_anim

	.ref	hrt_2_block_anim,hrt_4_block_anim

	.ref	hrt_stand2_anim,hrt_stand8_anim
	.ref	hrt_stand4_anim,hrt_stand6_anim
	.ref	hrt_torso2_anim,hrt_torso8_anim
	.ref	hrt_torso4_anim,hrt_torso6_anim

	.ref	hrt_2_to_4_turn_anim,hrt_8_to_6_turn_anim	;stand
	.ref	hrt_4_to_2_turn_anim,hrt_6_to_8_turn_anim
	.ref	hrt_4_to_6_turn_anim,hrt_6_to_4_turn_anim
	.ref	hrt_2_to_8_turn_anim,hrt_8_to_2_turn_anim
	.ref	hrt_4_to_8_turn_anim,hrt_6_to_2_turn_anim
	.ref	hrt_2_to_6_turn_anim,hrt_8_to_4_turn_anim

	.ref	hrt_2_to_4_turn2_anim,hrt_8_to_6_turn2_anim	;torso
	.ref	hrt_4_to_2_turn2_anim,hrt_6_to_8_turn2_anim
	.ref	hrt_4_to_6_turn2_anim,hrt_6_to_4_turn2_anim
	.ref	hrt_2_to_8_turn2_anim,hrt_8_to_2_turn2_anim
	.ref	hrt_4_to_8_turn2_anim,hrt_6_to_2_turn2_anim
	.ref	hrt_2_to_6_turn2_anim,hrt_8_to_4_turn2_anim

	.ref	hrt_walk1_f2_anim,hrt_walk2_f2_anim,hrt_walk4_f2_anim
	.ref	hrt_walk5_f2_anim,hrt_walk6_f2_anim,hrt_walk8_f2_anim

	.ref	hrt_walk1_f4_anim,hrt_walk2_f4_anim,hrt_walk4_f4_anim
	.ref	hrt_walk5_f4_anim,hrt_walk6_f4_anim,hrt_walk8_f4_anim

	.ref	hrt_run2_anim
;,hrt_ocrun_anim

	.ref	hrt_2_punch_anim,hrt_4_punch_anim
	.ref	hrt_2_kick_anim,hrt_4_kick_anim
	.ref	hrt_flying_kick_anim

	.ref	hrt_hitonground_anim,hrt_hitonground_facedown_anim

	.ref	hrt_2_butt_anim,hrt_4_butt_anim
	.ref	hrt_2_knee_anim,hrt_4_knee_anim
	.ref	hrt_2_bigboot_anim
	.ref	hrt_4_bigboot_anim

	.ref	hrt_2_stomp_anim,hrt_4_stomp_anim

	.ref	hrt_2_push_anim,hrt_4_push_anim

	.ref	hrt_4_grabfling_anim,hrt_hipslam_anim

	.ref	hrt_2_grabfling_anim

	.ref	hrt_faceup_getup_anim,hrt_facedown_getup_anim

	.ref	hrt_4_jumpkick_anim

	.ref	hrt_heldoh_anim

	.ref	hrt_backbreaker_anim
	.ref	hrt_neckbreaker_anim
	.ref	hrt_pogo_anim

	.ref	hrt_2_ground_punch_anim,hrt_4_ground_punch_anim
	.ref	hrt_running_ground_punch_anim
	.ref	hrt_climb_down_anim,hrt_tbukl_leap_anim
	.ref	hrt_climb_up_anim

	.ref	hrt_hh_2_ddt_anim
	.ref	hrt_running_ddt_anim


******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************

bret_secret_moves
	.long	#button_hold	;must have this one

	.long	#neck_grab
	.long	#grab_fling

	.long	0

#neck_grab
	.word	B_SPUNCH,		J_ALL
	.word	J_TOWARD,		J_REAL_LR | J_UP | J_DOWN
	.word	J_TOWARD,		J_REAL_LR | J_UP | J_DOWN
	.word	8000h | 30		;max
	.long	#scrt_neck

#scrt_neck
	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#out

;Don't do it when he is on ground
	calla	get_opp_plyrmode
	cmpi	MODE_ONGROUND,a0
	jrz	#out
	cmpi	MODE_DEAD,a0
	jrz	#out
	cmpi	MODE_HEADHELD,a0
	jrz	#out

	.ref	hrt_3_head_hold_anim
	movi	hrt_3_head_hold_anim,a0
	calla	change_anim1a
	rets

#grab_fling
	.word	B_SPUNCH | J_AWAY,	J_REAL_LR | J_UP | J_DOWN
	.word	8000h | 10		;max
	.long	scrt_grabfling

scrt_grabfling

;Make this miss, rotate to missed opponent,
;and stay rotated to flung opponent, also make
;this work from both angles!

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#out

;Don't fling when he is on ground
	calla	get_opp_plyrmode
	cmpi	MODE_ONGROUND,a0
	jrz	#out
	cmpi	MODE_DEAD,a0
	jrz	#out



	FACE24	hrt,grabfling_anim
	calla	change_anim1a

	WRSND	W_BRET,GRABFLING_T1,GRABFLING_T2

	rets


#button_hold

	move	a13,a0
	calla	wres_get_but_val_up
	btst	PLAYER_PUNCH_BIT,a0
	jrz	#no_punch

	move	*a13(PLYRNUM),a0
	calla	get_punch_dtime
	cmpi	100,a0			;> min?
	jrlt	#no_punch
	cmpi	100+60,a0		;< max?
	jrgt	#no_punch

	callr	scrt_2ndwind
	setc
	rets

#no_punch
	clrc
	rets


;		BITS			MASK



#hdheld_push
	.word	B_PUNCH,		J_ALL
	.word	B_PUNCH,		J_ALL
	.word	B_PUNCH,		J_ALL
	.word	J_AWAY,			J_REAL_LR
	.word	J_TOWARD,		J_REAL_LR
	.word	8000h | 50 		;max
	.long	scrt_hdpush

scrt_hdpush
	move	*a13(PLYRMODE),a0
	cmpi	MODE_HEADHELD,a0
	jrnz	#out

	.ref	hrt_2_push2_anim
	movi	hrt_2_push2_anim,a0
	calla	change_anim1a

#out
	rets



#2nd_wind1
	.word	J_UP,			J_REAL_LR
	.word	J_UP_AWAY,		J_REAL_LR
	.word	J_AWAY,			J_REAL_LR
	.word	J_DOWN_AWAY,		J_REAL_LR
	.word	J_DOWN,			J_REAL_LR
	.word	J_DOWN_TOWARD,		J_REAL_LR
	.word	J_TOWARD,		J_REAL_LR
	.word	J_UP_TOWARD,		J_REAL_LR
	.word	J_UP,			J_REAL_LR
	.word	8000h | 50 		;max
	.long	scrt_2ndwind

#2nd_wind2
	.word	J_UP,			J_REAL_LR
	.word	J_UP_TOWARD,		J_REAL_LR
	.word	J_TOWARD,		J_REAL_LR
	.word	J_DOWN_TOWARD,		J_REAL_LR
	.word	J_DOWN,			J_REAL_LR
	.word	J_DOWN_AWAY,		J_REAL_LR
	.word	J_AWAY,			J_REAL_LR
	.word	J_UP_AWAY,		J_REAL_LR
	.word	J_UP,			J_REAL_LR
	.word	8000h | 50 		;max
	.long	scrt_2ndwind

scrt_2ndwind
	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_scrt_2ndwind

;;;	movi	hrt_2ndwind_anim,a0
	calla	change_anim1a
#no_scrt_2ndwind
	rets


#*****************************************************************************

 SUBR	bret_ani_init

	move	*a13(FACING_DIR),a0
	btst	PLAYER_RIGHT_BIT,a0
	jrnz	#p1
;Plyr 2
	movi	hrt_stand4_anim,a0
	calla	change_anim1a

	movi	hrt_torso4_anim,a0
	calla	change_anim2a

	PUSH	a10
	move	a13,a10
	.ref	do_taunt
	CREATE0	do_taunt
	PULL	a10

	rets

#p1
	movi	hrt_stand2_anim,a0
	calla	change_anim1a

	movi	hrt_torso2_anim,a0
	calla	change_anim2a

	rets


#*****************************************************************************
*
* BRET HART CONTROL CODE
*
* a13 = * bret process

 SUBR	move_bret


	movi	bret_secret_moves,a11
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
	.long	mode_normal	;17
	.long	mode_normal	;18
	.long	mode_headheld		;19
	.long	mode_puppet		;20
	.ref	mode_inair2
	.long	mode_inair2		;21
	.long	mode_normal	;22
	.long	mode_normal	;23
	.long	mode_chokehold		;24
	.ref	mode_choking
	.long	mode_choking		;25

#*****************************************************************************

mode_normal


	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_interrupt

;Perhaps we need to interrupt any sequence when a wrestler has won?

	calla	get_opp_plyrmode
	cmpi	MODE_DEAD,a0
	jrne	#opp_not_dead

;Any button causes a pin
	move	a13,a0
	calla	wres_get_but_val_cur
	move	a0,a0
	jrz	#opp_not_dead

;Make sure opponent is on the ground!
;First, see if opponent is on the ground.
	move	*a13(CLOSEST_DIST),a0
	cmpi	70h,a0
	jrgt	#opp_not_dead

	move	*a13(CLOSEST_NUM),a0
	X32	a0
	addi	process_ptrs,a0
	move	*a0,a1,L

	move	*a1(OBJ_YPOS),a0,L
	move	*a1(GROUND_Y),a14
	sll	16,a14
	cmp	a14,a0
	jrgt	#opp_notgnd

;Opponent is on ground.
;Now check to see if I'm attached to him in puppet mode!
	move	*a13(ATTACH_PROC),a1,L
	jrz	#done
	move	*a1(ATTACH_PROC),a2,L
	cmp	a2,a13
;If I'm attached to him, let the move finish!
	jrz	#opp_not_dead
#done

	.ref	hrt_2_pin_anim
	.ref	hrt_4_pin_anim

	FACE24	hrt,pin_anim
	calla	change_anim1a

	rets

#opp_notgnd
#opp_not_dead

;MJT Start
	move	*a13(IMMOBILIZE_TIME),a0
	jrnz	#no_climb
;MJT End

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
	move	*a13(WRESTLERNUM),A5
	.ref	CLIMB_ROPES,ADD_IF_SILENT
	MOVI	CLIMB_ROPES,A2
	MOVI	1000,A0
	CALLA	ADD_IF_SILENT
	rets
#no_climb

	calla	execute_walk

#no_interrupt
	rets

#action_table
;This table accounts for 2 buttons being hit simultaneously.

	.long	#z					;0
	.long	#punch					;1
	.long	#block					;2
	.long	#z					;3
	.long	#super_punch				;4
	.long	#super_punch,#z,#z			;5-7
	.long	#kick					;8
	.long	#punchkick,#z,#z,#kick,#z,#z,#z		;9-15
	.long	#super_kick				;16
	.long	#z,#z,#z,#graboh,#z,#z,#z		;17-23
	.long	#kick,#z,#z,#z,#z,#z,#z,#z		;24-31

************
#graboh
	rets

#z		;0

	rets


************
#punch		;1
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal	<  62   92	headbutt
* dizzy			"		"
* normal	>		normal punch
* dizzy			"		"
*
* onground	< 120  120	elbow drop
* onground	>		normal punch
*
* running			hiptoss
* bouncing			hiptoss
*
* onturnbkl	<  60   96	yank down
* onturnbkl	>		normal punch
* climbturnbkl			normal punch
*
	JJXM_INIT
	JJXM	NORMAL,		 62, 92,#punch_hdbutt,#punch_punch
	JJXM	BLOCK,		 62, 92,#punch_hdbutt,#punch_punch
	JJXM	DIZZY,		 62, 92,#punch_hdbutt,#punch_punch
	JJXM	ONGROUND,	120,120,#punch_lbowdrop,#punch_punch
	JJXM	RUNNING,		#punch_hiptoss
	JJXM	BOUNCING,		#punch_hiptoss
	JJXM	ONTURNBKL,	 60, 96,#punch_yankdown,#punch_punch
	JJXM	CLIMBTURNBKL,		#punch_punch
	JJXM	INAIR,		 62, 92,#punch_hdbutt,#punch_punch
	JJXM	ATTACHED,	 62, 92,#punch_hdbutt,#punch_punch
	JJXM	DEAD,		 62, 92,#punch_hdbutt,#punch_punch
	JJXM	OPPOVERHEAD,	 62, 92,#punch_hdbutt,#punch_punch
	JJXM	WAITANIM,	 62, 92,#punch_hdbutt,#punch_punch
	JJXM	GRAPPLE,	 62, 92,#punch_hdbutt,#punch_punch
	JJXM	MASTER,		 62, 92,#punch_hdbutt,#punch_punch
	JJXM	SLAVE,		 62, 92,#punch_hdbutt,#punch_punch
	JJXM	HEADHOLD,	 62, 92,#punch_hdbutt,#punch_punch
	JJXM	HEADHELD,	 62, 92,#punch_hdbutt,#punch_punch
	JJXM	PUPPET,		 62, 92,#punch_hdbutt,#punch_punch
	JJXM	INAIR2,		 62, 92,#punch_hdbutt,#punch_punch
	JJXM_END

#punch_rets
	rets

*****
#punch_punch
std_punch

	FACE24	hrt,punch_anim
	calla	change_anim1a

	WRSND	W_BRET,PUNCH_T1,PUNCH_T2
	rets

*****
#punch_hdbutt

	FACE24	hrt,butt_anim
	calla	change_anim1a

	WRSND	W_BRET,HDBUTT_T1,HDBUTT_T2
	rets

*****
#punch_lbowdrop

	FACE24	hrt,ground_punch_anim
	calla	change_anim1a

	WRSND	W_BRET,LBOWDROP_T1,LBOWDROP_T2
	rets

*****
#punch_yankdown
std_yankdown
	rets

*****
#punch_hiptoss
std_hiptoss

	movi	hrt_hipslam_anim,a0
	calla	change_anim1a

	WRSND	W_BRET,HIPTOSS_T1,HIPTOSS_T2
	rets


************
#block		;2

	clr	a0
	move	a0,*a13(OBJ_XVEL),L

std_block

	move	*a13(NEW_FACING_DIR),a0
	move	a0,*a13(FACING_DIR)

	FACE24	hrt,block_anim
	calla	change_anim1
	rets


************
#super_punch	;4
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal	<  50   92	close in super move
* dizzy			"		"
* normal	>		jumping punch move
* dizzy			"		"
*
* onground	< 120  120	super elbow drop
* onground	>		normal punch
*
* running			hip toss
* bouncing			nothing
*
* onturnbkl	<  60   96	yank down
* onturnbkl	>		normal punch
* climbturnbkl			normal punch
*
	JJXM_INIT
	JJXM	NORMAL,		 50, 92,#spunch_special,#spunch_jump
	JJXM	BLOCK,		 50, 92,#spunch_special,#spunch_jump
	JJXM	DIZZY,		 50, 92,#spunch_special,#spunch_jump
	JJXM	ONGROUND,	120,120,#spunch_lbowdrop,std_punch
	JJXM	RUNNING,	 	std_hiptoss
	JJXM	BOUNCING,		std_hiptoss
	JJXM	ONTURNBKL,	 60, 96,std_yankdown,std_punch
	JJXM	CLIMBTURNBKL,		std_punch
	JJXM	INAIR,		 50, 92,#spunch_special,#spunch_jump
	JJXM	ATTACHED,   	 50, 92,#spunch_special,#spunch_jump
	JJXM	DEAD,		 50, 92,#spunch_special,#spunch_jump
	JJXM	WAITANIM,  	 50, 92,#spunch_special,#spunch_jump
	JJXM	GRAPPLE,   	 50, 92,#spunch_special,#spunch_jump
	JJXM	MASTER,		 50, 92,#spunch_special,#spunch_jump
	JJXM	SLAVE,		 50, 92,#spunch_special,#spunch_jump
	JJXM	HEADHOLD,  	 50, 92,#spunch_special,#spunch_jump
	JJXM	HEADHELD,  	 50, 92,#spunch_special,#spunch_jump
	JJXM	PUPPET,		 50, 92,#spunch_special,#spunch_jump
	JJXM	INAIR2,		 50, 92,#spunch_special,#spunch_jump
	JJXM	OPPOVERHEAD,	 50, 92,#spunch_special,#spunch_jump
	JJXM_END

*****
#spunch_jump	;jumping punch attack

;RJR START
	movi	hrt_hipslam_anim,a0
	calla	change_anim1a
;RJR END
	rets

*****
#spunch_special

;RJR START
;	movi	hrt_pogo_anim,a0
	movi	hrt_hipslam_anim,a0
	calla	change_anim1a
;RJR END
	WRSND	W_BRET,PUNCH_T1,PUNCH_T2

	rets

*****
#spunch_lbowdrop

	.ref	hrt_2_hair_pickup_anim
	.ref	hrt_4_hair_pickup_anim
;If near opponents head, and facing down, do the hair grab!
;Allow hair grab from below!

;	move	*a13(FACING_DIR),a14
;	btst	MOVE_DOWN_BIT,a14
;	jrz	#no

	move	*a13(CLOSEST_NUM),a14
	X32	a14
	addi	process_ptrs,a14
	move	*a14,a14,L
	move	*a13(OBJ_XPOS),a1,L 
	move	*a14(OBJ_XPOS),a2,L
	sub	a2,a1
	abs	a1
	srl	16,a1
	cmpi	20h,a1	;28
 	jrlt	#no

;At head or feet!

	move	*a14(OBJ_CONTROL),a14
	andi	M_FLIPH,a14
	move	*a13(OBJ_CONTROL),a0
	andi	M_FLIPH,a0
	cmp	a0,a14
	jrz	#no

;At head!  Do hair pickup.

	FACE24	hrt,hair_pickup_anim
	calla	change_anim1

	WRSND	W_BRET,LBOWDROP_T1,LBOWDROP_T2
    
	rets

#no
	FACE24	hrt,ground_punch_anim
	calla	change_anim1

	WRSND	W_BRET,LBOWDROP_T1,LBOWDROP_T2

	rets


************
#kick		;8
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal	<  56   92	knee
* block			"		"
* dizzy			"		"
* normal	>		normal kick
* block			"		"
* dizzy			"		"
*
* onground	< 120  120	stomp
* onground	>		normal kick
*
* running			normal kick
* bouncing			normal kick
*
* onturnbkl			normal kick
* climbturnbkl			normal kick
*
	JJXM_INIT
	JJXM	NORMAL,		 56, 92,#kick_knee,#kick_kick
	JJXM	BLOCK,		 56, 92,#kick_knee,#kick_kick
	JJXM	DIZZY,		 56, 92,#kick_knee,#kick_kick
	JJXM	ONGROUND,	120,120,#kick_stomp,#kick_kick
	JJXM	RUNNING,	 	#kick_kick
	JJXM	BOUNCING,	 	#kick_kick
	JJXM	ONTURNBKL,	 	#kick_kick
	JJXM	CLIMBTURNBKL,	 	#kick_kick
	JJXM	INAIR,		 56, 92,#kick_knee,#kick_kick
	JJXM	ATTACHED,	 56, 92,#kick_knee,#kick_kick
	JJXM	DEAD,		 56, 92,#kick_knee,#kick_kick
	JJXM	OPPOVERHEAD,	 56, 92,#kick_knee,#kick_kick
	JJXM	WAITANIM,	 56, 92,#kick_knee,#kick_kick
	JJXM	GRAPPLE,	 56, 92,#kick_knee,#kick_kick
	JJXM	MASTER,		 56, 92,#kick_knee,#kick_kick
	JJXM	SLAVE,		 56, 92,#kick_knee,#kick_kick
	JJXM	HEADHOLD,	 56, 92,#kick_knee,#kick_kick
	JJXM	HEADHELD,	 56, 92,#kick_knee,#kick_kick
	JJXM	PUPPET,		 56, 92,#kick_knee,#kick_kick
	JJXM	INAIR2,		 56, 92,#kick_knee,#kick_kick
	JJXM_END

*****
#kick_kick
std_kick

	FACE24	hrt,kick_anim
	calla	change_anim1a

	WRSND	W_BRET,KICK_T1,KICK_T2
	rets

*****
#kick_knee

	FACE24	hrt,knee_anim
	calla	change_anim1a

	WRSND	W_BRET,KICK_T1,KICK_T2
	rets

*****
#kick_stomp
attack_stomp

	FACE24	hrt,stomp_anim
	calla	change_anim1a

	WRSND	W_BRET,KICK_T1,KICK_T2

	rets


************
#punchkick	;9

	movi	start_run_anim,a0
	calla	change_anim1a

	rets

************
#super_kick	;16
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal	<  60   60	close in super move
* dizzy			"		"
* normal	>		jumping kick move
* dizzy			"		"
*
* onground	< 120  120	super stomp
* onground	>		normal kick
*
* running			big boot
* bouncing			big boot
*
* onturnbkl	<  60   96	jumping kick move
* climbturnbkl		"		"
* onturnbkl	>		normal kick
* climbturnbkl		"		"
*
	JJXM_INIT
	JJXM	NORMAL,		 60, 60,#skick_special,#skick_kick
	JJXM	BLOCK,		 60, 60,#skick_special,#skick_kick
	JJXM	DIZZY,		 60, 60,#skick_special,#skick_kick
	JJXM	ONGROUND,	120,120,attack_stomp,std_kick
	JJXM	RUNNING,	 	#skick_bigboot
	JJXM	BOUNCING,	 	#skick_bigboot
	JJXM	ONTURNBKL,	 60, 96,#skick_kick,std_kick
	JJXM	CLIMBTURNBKL,	 60, 96,#skick_kick,std_kick
	JJXM	INAIR,		 60, 60,#skick_special,#skick_kick
	JJXM	ATTACHED,	 60, 60,#skick_special,#skick_kick
	JJXM	DEAD,		 60, 60,#skick_special,#skick_kick
	JJXM	OPPOVERHEAD,	 60, 60,#skick_special,#skick_kick
	JJXM	WAITANIM,	 60, 60,#skick_special,#skick_kick
	JJXM	GRAPPLE,	 60, 60,#skick_special,#skick_kick
	JJXM	MASTER,		 60, 60,#skick_special,#skick_kick
	JJXM	SLAVE,		 60, 60,#skick_special,#skick_kick
	JJXM	HEADHOLD,	 60, 60,#skick_special,#skick_kick
	JJXM	HEADHELD,	 60, 60,#skick_special,#skick_kick
	JJXM	PUPPET,		 60, 60,#skick_special,#skick_kick
	JJXM	INAIR2,		 60, 60,#skick_special,#skick_kick
	JJXM_END

*****
#skick_kick

	movi	hrt_4_jumpkick_anim,a0
	calla	change_anim1a

	WRSND	W_BRET,FLYKICK_T1,FLYKICK_T2

	rets

*****
#skick_special

	movi	hrt_neckbreaker_anim,a0
	calla	change_anim1a
	rets

;*****
;#skick_stomp
;
;	rets

*****
#skick_bigboot

	FACE24	hrt,bigboot_anim
	calla	change_anim1a

	WRSND	W_BRET,FLYKICK_T1,FLYKICK_T2

	rets


#*****************************************************************************
*
* RUNNING (if GETUP_TIME > 0 then player is out of control)
*

#XRUN_VAL	equ	60000h		;50000h
;#XACC_VAL	equ	04000h
#ZDRIFT_VAL	equ	20000h		;18000h

mode_running

	move	*a13(RUN_TIME),a0		;Used for flying kick
	addk	1,a0
	move	a0,*a13(RUN_TIME)

	move	*a13(USR_VAR1),a0
	jrnz	#no_vel

	calla	bounce_off_ropes

	movi	#XRUN_VAL,a0
	move	*a13(MOVE_DIR),a14
	btst	PLAYER_RIGHT_BIT,a14
	jrnz	#pos
	neg	a0
#pos
	move	a0,*a13(OBJ_XVEL),L

#no_vel

	move	*a13(GETUP_TIME),a0		;delay b4 gaining control
	jrnz	#out_of_control

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_interrupt

	move	a13,a0
	calla	wres_get_stick_val_cur
	move	*a13(MOVE_DIR),a1
	or	a0,a1
	andi	MOVE_LEFT|MOVE_RIGHT,a1
	cmpi	MOVE_LEFT|MOVE_RIGHT,a1
	jrne	#continue_run

	;braking with stick.  abort run.

	SETMODE	NORMAL

#continue_run
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
#super_punch	;4
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal			flying clothesline
* dizzy					"
*
* onground	< 176  176	belly flop
* onground	>		nothing
*
* running			flying clothesline
* bouncing			flying clothesline
*
* onturnbkl			flying clothesline
* climbturnbkl			flying clothesline
*
	JJXM_INIT
	JJXM	NORMAL,			#punch_clothesline
	JJXM	BLOCK,			#punch_clothesline
	JJXM	DIZZY,			#punch_clothesline
	JJXM	ONGROUND,	176,176,#punch_bellyflop,#punch_rets
	JJXM	RUNNING,		#punch_clothesline
	JJXM	BOUNCING,		#punch_clothesline
	JJXM	ONTURNBKL,		#punch_clothesline
	JJXM	CLIMBTURNBKL,		#punch_clothesline
	JJXM	INAIR,			#punch_clothesline
	JJXM	ATTACHED,		#punch_clothesline
	JJXM	DEAD,			#punch_clothesline
	JJXM	OPPOVERHEAD,		#punch_clothesline
	JJXM	WAITANIM,		#punch_clothesline
	JJXM	GRAPPLE,		#punch_clothesline
	JJXM	MASTER,			#punch_clothesline
	JJXM	SLAVE,			#punch_clothesline
	JJXM	HEADHOLD,		#punch_clothesline
	JJXM	HEADHELD,		#punch_clothesline
	JJXM	PUPPET,			#punch_clothesline
	JJXM	INAIR2,			#punch_clothesline
	JJXM_END


*****
#punch_rets
	rets

*****
#punch_clothesline


	movi	hrt_running_ddt_anim,a0
	calla	change_anim1a

	WRSND	W_BRET,FLYKICK_T1,FLYKICK_T2

	rets

*****
#punch_bellyflop
attack_bellyflop

	movi	hrt_running_ground_punch_anim,a0
	calla	change_anim1a

	WRSND	W_BRET,FLYKICK_T1,FLYKICK_T2

	rets

************
#block		;2

	move	*a13(OBJ_XVEL),a0,L
	sra	1,a0
	move	a0,*a13(OBJ_XVEL),L
	SETMODE	NORMAL
	jruc	std_block

************
#kick		;8
#super_kick	;16
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal			flying kick
* dizzy					"
*
* onground	< 176  176	running stomp
* onground	>		nothing
*
* running			flying kick
* bouncing			flying kick
*
* onturnbkl			flying kick
* climbturnbkl			flying kick
*
	JJXM_INIT
	JJXM	NORMAL,			#kick_flyingkick
	JJXM	BLOCK,			#kick_flyingkick
	JJXM	DIZZY,			#kick_flyingkick
	JJXM	ONGROUND,	176,176,attack_bellyflop,#kick_rets
	JJXM	RUNNING,		#kick_flyingkick
	JJXM	BOUNCING,		#kick_flyingkick
	JJXM	ONTURNBKL,		#kick_flyingkick
	JJXM	CLIMBTURNBKL,		#kick_flyingkick
	JJXM	INAIR,			#kick_flyingkick
	JJXM	ATTACHED,		#kick_flyingkick
	JJXM	DEAD,			#kick_flyingkick
	JJXM	OPPOVERHEAD,		#kick_flyingkick
	JJXM	WAITANIM,		#kick_flyingkick
	JJXM	GRAPPLE,		#kick_flyingkick
	JJXM	MASTER,			#kick_flyingkick
	JJXM	SLAVE,			#kick_flyingkick
	JJXM	HEADHOLD,		#kick_flyingkick
	JJXM	HEADHELD,		#kick_flyingkick
	JJXM	PUPPET,			#kick_flyingkick
	JJXM	INAIR2,			#kick_flyingkick
	JJXM_END

#kick_rets
	rets

*****
#kick_flyingkick

	movi	hrt_flying_kick_anim,a0
	calla	change_anim1a

	WRSND	W_BRET,FLYKICK_T1,FLYKICK_T2

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

mode_onground	;4

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

	movi	hrt_run2_anim,a0
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

	;this is so an attack isn't turned into a climbdown
	; in those 5-10 ticks before MODE_INAIR2 is set...
	move	*a13(ANIBASE),a14,L
	cmpi	hrt_climb_up_anim,a14
	jrne	#no_climbdown

	movi	hrt_climb_down_anim,a0
	calla	change_anim1a

	SETMODE	CLIMBTURNBKL

	rets

#no_climbdown
	move	a13,a0
	calla	wres_get_but_val_down
	andi	011111b,a0
	jrz	#z

	X32	a0
	addi	#action_table,a0
	move	*a0,a0,L
	call	a0

	move	*a13(PLYRNUM),a5
	movi	JUMP_ROPES,a2
	movi	1000,a0
	calla	ADD_IF_SILENT

	rets


;For standing on top of turnbuckles

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

	movi	hrt_tbukl_leap_anim,a0
	calla	change_anim1a

	WRSND	W_BRET,FLYKICK_T1,FLYKICK_T2

	rets

#*****************************************************************************
* blocking

mode_block	;7

	move	a13,a0
	calla	wres_get_but_val_down
	andi	011111b,a0
	jrz	#no_interrupt

	X32	a0
	addi	#action_table,a0
	move	*a0,a0,L
	call	a0

#no_interrupt
	rets

#action_table
	.long	#z,#punchblock,#z	;0-2
	.long	#punchblock		;3
	.long	#z,#z,#z,#z,#z,#z,#z	;4-10
	.long	#z,#z,#z,#z,#z,#z,#z	;11-17
	.long	#z,#z,#z,#z,#z,#z,#z	;18-24
	.long	#z,#z,#z,#z,#z,#z,#z	;25-31

;	.long	#z					;0
;	.long	#punch					;1
;	.long	#block					;2
;	.long	#punchblock				;3
;	.long	#super_punch				;4
;	.long	#super_punch,#z,#z			;5-7
;	.long	#kick					;8
;	.long	#punchkick,#z,#z,#kick,#z,#z,#z		;9-15
;	.long	#super_kick				;16
;	.long	#z,#z,#z,#graboh,#z,#z,#z		;17-23
;	.long	#kick,#z,#z,#z,#z,#z,#z,#z		;24-31


************
#z
	rets

************
#punchblock	;3
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* all				push
*

;This push has no collisions set!

	SETMODE	NORMAL

	FACE24	hrt,push_anim
	calla	change_anim1a

	WRSND	W_BRET,PUSH_T1,PUSH_T2

	rets


#*****************************************************************************
* BRET with zero health

mode_dizzy	;8

	move	*a13(GETUP_TIME),a0
	jrnz	#still_going

	calla	clear_damage_log

	clr	a0
	move	a0,*a13(STARS_FLAG)

	SETMODE	NORMAL

#still_going
	rets

#*****************************************************************************
mode_dead	;9

	rets

#*****************************************************************************
* opponent held overhead

mode_oppoverhead ;10
;
;	move	*a13(ATTACH_PROC),a2,L		;proc attached to
;	jrz	#not_attached
;	move	*a2(ATTACH_PROC),a0,L
;	jrnz	#still_attached
;
;#not_attached
;
;	move	*a13(ANIMODE),a0		;* remove this????
;	btst	MODE_UNINT_BIT,a0		;*
;	jrnz	#no_interrupt			;*
;
;	clr	a0
;	move	a0,*a13(ATTACH_PROC),L
;
;	SETMODE	NORMAL
;
;	movi	MODE_NORMAL,a0
;	move	a0,*a13(ANIMODE)
;
;	rets
;
;#still_attached
;	move	*a13(ANIMODE),a0
;	btst	MODE_UNINT_BIT,a0
;	jrnz	#no_interrupt
;
;	move	*a13(FACING_DIR),a0
;	andni	MOVE_UP,a0
;	ori	MOVE_DOWN,a0
;	move	a0,*a13(FACING_DIR)
;	move	a0,*a13(NEW_FACING_DIR)
;
;	move	a13,a0
;	calla	wres_get_stick_val_cur
;	jrz	#stand
;
;	move	a0,*a13(MOVE_DIR)
;	calla	execute_walk
;
;	movi	hrt_holdoh_anim,a0
;	calla	change_anim2
; 	jruc	#ck_butns
;#stand
;	clr	a0
;	move	a0,*a13(MOVE_DIR)
;	move	a0,*a13(OBJ_XVEL),L
;	move	a0,*a13(OBJ_ZVEL),L
;
;	movi	hrt_stndholdoh_anim,a0
;	calla	change_anim1
;
;#ck_butns
;
;
;	move	a13,a0
;	calla	wres_get_but_val_down
;	andi	011111b,a0
;	X32	a0
;	addi	#action_table,a0
;	move	*a0,a0,L
;	call	a0
;
;#no_interrupt
;	rets
;
;#action_table
;	.long	#z			;0
;	.long	#punch			;1
;	.long	#block			;2
;	.long	#z			;3
;	.long	#super_punch		;4
;	.long	#z,#z,#z		;5-7
;	.long	#kick			;8
;	.long	#z,#z,#z,#z,#z,#z,#z	;9-15
;	.long	#super_kick		;16
;	.long	#z,#z,#z,#z,#z,#z,#z	;17-23
;	.long	#z,#z,#z,#z,#z,#z,#z,#z	;24-31
;
;************
;#z
;	rets
;
;************
;#punch		;1
;#block		;2
;#super_punch	;4
;#kick		;8
;#super_kick	;16
;
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

	move	*a13(ATTACH_PROC),a10,L
	jrz	#exit

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_interrupt

;Should we allow you to break from head hold into a block?
;I think not right now...
;	move	a13,a0
;	calla	wres_get_but_val_cur
;	btst	PLAYER_BLOCK_BIT,a0	;maybe have to action tables?
;	jrz	#nblk			;1 for down transitions
;	callr	do_block			;& 1 for current buttons
;
;;Do an ANI_DETACH
;	move	*a13(ATTACH_PROC),a1,L
;	jrz	#done
;	clr	a0
;	move	a0,*a13(ATTACH_PROC),L		;not attached to anything
;
;	move	*a1(ATTACH_PROC),a2,L
;	cmp	a2,a13
;	jrne	#done
;
;	move	a0,*a1(ATTACH_PROC),L		;not attached to anything
;#done
;
;#nblk

	move	a13,a0
	calla	wres_get_but_val_down
	andi	011111b,a0
	X32	a0
	addi	#action_table,a0
	move	*a0,a0,L
	call	a0

#no_interrupt
	rets

#exit
	movk	MOVE_DOWN_RIGHT,a1
	move	*a13(OBJ_CONTROL),a0
	btst	B_FLIPH,a0
	jrz	#right
	movk	MOVE_DOWN_LEFT,a1
#right	move	a1,*a13(FACING_DIR)
	move	a1,*a13(NEW_FACING_DIR)

	SETMODE	NORMAL

	rets

#action_table
	.long	#z					;0
	.long	#punch					;1
	.long	#block					;2
	.long	#z					;3
	.long	#super_punch				;4
	.long	#super_punch,#z,#z			;5-7
	.long	#kick					;8
	.long	#punchkick,#z,#z,#kick,#z,#z,#z		;9-15
	.long	#super_kick				;16
	.long	#z,#z,#z,#graboh,#z,#z,#z		;17-23
	.long	#kick,#z,#z,#z,#z,#z,#z,#z		;24-31


************
#block
#z		;0
	rets

************

#punch		;1
;If stick is toward opponent, then do quick punches
	move	a13,a0
	calla	wres_get_stick_val_cur
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrnz	#tag
;	movi	dnk_uppercuts_to_head_anim,a0
	movi	hrt_4_knee_anim,a0
	calla	change_anim1a
	rets

#tag
;	movi	dnk_uppercut_to_head_anim,a0
	movi	hrt_4_knee_anim,a0
	calla	change_anim1a
	rets

************
#super_punch	;4

	move	a13,a0
	calla	wres_get_stick_val_cur

	btst	PLAYER_DOWN_BIT,a0
	jrz	#punch

	movi	hrt_hh_2_ddt_anim,a0
	calla	change_anim1a
	rets

#punchkick
#graboh
#kick
	move	a13,a0
	calla	wres_get_stick_val_cur

	btst	PLAYER_DOWN_BIT,a0
	jrz	#knee

;	.ref	dnk_3_head_slam_anim

;	movi	dnk_3_head_slam_anim,a0
	movi	hrt_4_knee_anim,a0
	calla	change_anim1a
	rets

#knee
;	movi	dnk_3_knee_to_head_anim,a0
	movi	hrt_4_knee_anim,a0
	calla	change_anim1a
	rets

#super_kick	;16
;If stick is toward opponent, then do quick knees
	move	a13,a0
	calla	wres_get_stick_val_cur
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrnz	#kick

;Quick knees
;	movi	dnk_3_knees_to_head_anim,a0
	movi	hrt_4_knee_anim,a0
	calla	change_anim1a
	rets

#*****************************************************************************
mode_headheld	;19

;He may have let me go by hitting his block butn!
	move	*a13(ATTACH_PROC),a0,L
	jrnz	#no_luck

;Make sure this guy is on ground
	move	*a13(OBJ_YPOSINT),a0
	move	*a13(GROUND_Y),a1
	cmp	a1,a0			;a0-a1
	jrgt	#no_luck

;hit_gnd

	.ref	hrt_3_head_held_stand_anim
	movi	hrt_3_head_held_stand_anim,a0
	calla	change_anim1a

#no_luck
	rets

#*****************************************************************************
mode_puppet	;20
	rets

#*****************************************************************************
mode_chokehold	;24
	rets

#*****************************************************************************

#VEL	equ	30000h
#DVEL	equ	21f0eh


 SUBR hrt_velocity_table

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

 SUBR hrt_rotate_anims_table
; old = up right
	.long	hrt_stand2_anim		;new = up right
	.long	hrt_2_to_4_turn_anim	;    = down right
	.long	hrt_2_to_6_turn_anim	;    = down left ***
	.long	hrt_2_to_8_turn_anim	;    = up left

; old = down right
	.long	hrt_4_to_2_turn_anim	;new = up right
	.long	hrt_stand4_anim		;    = down right
	.long	hrt_4_to_6_turn_anim	;    = down left
	.long	hrt_4_to_8_turn_anim	;    = up left ***

; old = down left
	.long	hrt_6_to_2_turn_anim	;new = up right ***
	.long	hrt_6_to_4_turn_anim	;    = down right
	.long	hrt_stand6_anim		;    = down left
	.long	hrt_6_to_8_turn_anim	;    = up left

; old = up left
	.long	hrt_8_to_2_turn_anim	;new = up right
	.long	hrt_8_to_4_turn_anim	;    = down right ***
	.long	hrt_8_to_6_turn_anim	;    = down left
	.long	hrt_stand8_anim		;    = up left


 SUBR hrt_leg_anims_table
;  MOVE
;(#1 - UP)				FACING
	.long	hrt_walk1_f2_anim	;1 (UP)
	.long	hrt_walk1_f2_anim	;2 (UP_RIGHT)
	.long	hrt_walk1_f4_anim	;3 (RIGHT)
	.long	hrt_walk1_f4_anim	;4 (DOWN_RIGHT)
	.long	hrt_walk1_f4_anim	;5 (DOWN)
	.long	hrt_walk1_f4_anim	;6 (DOWN_LEFT)
	.long	hrt_walk1_f2_anim	;7 (LEFT)
	.long	hrt_walk1_f2_anim	;8 (UP-LEFT)

;(#2 - UP-RIGHT)
	.long	hrt_walk2_f2_anim	;1 (UP)
	.long	hrt_walk2_f2_anim	;2 (UP_RIGHT)
	.long	hrt_walk2_f2_anim	;3 (RIGHT)
	.long	hrt_walk2_f4_anim	;4 (DOWN_RIGHT)
	.long	hrt_walk8_f4_anim	;5 (DOWN)
	.long	hrt_walk8_f4_anim	;6 (DOWN_LEFT)
	.long	hrt_walk4_f2_anim	;7 (LEFT)
	.long	hrt_walk4_f2_anim	;8 (UP-LEFT)

;(#3 - RIGHT)
	.long	hrt_walk2_f2_anim	;1 (UP)
	.long	hrt_walk2_f2_anim	;2 (UP_RIGHT)
	.long	hrt_walk2_f2_anim	;3 (RIGHT)
	.long	hrt_walk4_f4_anim	;4 (DOWN_RIGHT)
	.long	hrt_walk4_f4_anim	;5 (DOWN)
	.long	hrt_walk8_f4_anim	;6 (DOWN_LEFT)
	.long	hrt_walk6_f2_anim	;7 (LEFT)
	.long	hrt_walk6_f2_anim	;8 (UP-LEFT)


;(#4 - DOWN-RIGHT)
	.long	hrt_walk2_f2_anim	;1 (UP)
	.long	hrt_walk8_f2_anim	;2 (UP_RIGHT)
	.long	hrt_walk4_f4_anim	;3 (RIGHT)
	.long	hrt_walk4_f4_anim	;4 (DOWN_RIGHT)
	.long	hrt_walk2_f4_anim	;5 (DOWN)
	.long	hrt_walk6_f4_anim	;6 (DOWN_LEFT)
	.long	hrt_walk2_f2_anim	;7 (LEFT)
	.long	hrt_walk6_f2_anim	;8 (UP-LEFT)

;(#5 - DOWN)
	.long	hrt_walk5_f2_anim	;1 (UP)
	.long	hrt_walk5_f2_anim	;2 (UP_RIGHT)
	.long	hrt_walk5_f4_anim	;3 (RIGHT)
	.long	hrt_walk5_f4_anim	;4 (DOWN_RIGHT)
	.long	hrt_walk5_f4_anim	;5 (DOWN)
	.long	hrt_walk5_f4_anim	;6 (DOWN_LEFT)
	.long	hrt_walk5_f2_anim	;7 (LEFT)
	.long	hrt_walk5_f2_anim	;8 (UP-LEFT)

;(#6 - DOWN-LEFT)
	.long	hrt_walk2_f2_anim	;1 (UP)
	.long	hrt_walk6_f2_anim	;2 (UP_RIGHT)
	.long	hrt_walk2_f2_anim	;3 (RIGHT)
	.long	hrt_walk6_f4_anim	;4 (DOWN_RIGHT)
	.long	hrt_walk2_f4_anim	;5 (DOWN)
	.long	hrt_walk4_f4_anim	;6 (DOWN_LEFT)
	.long	hrt_walk2_f2_anim	;7 (LEFT)
	.long	hrt_walk8_f2_anim	;8 (UP-LEFT)

;(#7 - LEFT)
	.long	hrt_walk2_f2_anim	;1 (UP)
	.long	hrt_walk6_f2_anim	;2 (UP_RIGHT)
	.long	hrt_walk6_f2_anim	;3 (RIGHT)
	.long	hrt_walk8_f4_anim	;4 (DOWN_RIGHT)
	.long	hrt_walk4_f4_anim	;5 (DOWN)
	.long	hrt_walk4_f4_anim	;6 (DOWN_LEFT)
	.long	hrt_walk2_f2_anim	;7 (LEFT)
	.long	hrt_walk2_f2_anim	;8 (UP-LEFT)

;(#8 - UP-LEFT)
	.long	hrt_walk2_f2_anim	;1 (UP)
	.long	hrt_walk4_f2_anim	;2 (UP_RIGHT)
	.long	hrt_walk6_f2_anim	;3 (RIGHT)
	.long	hrt_walk8_f4_anim	;4 (DOWN_RIGHT)
	.long	hrt_walk6_f4_anim	;5 (DOWN)
	.long	hrt_walk2_f4_anim	;6 (DOWN_LEFT)
	.long	hrt_walk2_f2_anim	;7 (LEFT)
	.long	hrt_walk2_f2_anim	;8 (UP-LEFT)


 SUBR hrt_torso_anims_table
; old = up right
	.long	hrt_torso2_anim		;new = up right
	.long	hrt_2_to_4_turn2_anim	;    = down right
	.long	hrt_2_to_6_turn2_anim	;    = down left ***
	.long	hrt_2_to_8_turn2_anim	;    = up left

; old = down right
	.long	hrt_4_to_2_turn2_anim	;new = up right
	.long	hrt_torso4_anim		;    = down right
	.long	hrt_4_to_6_turn2_anim	;    = down left
	.long	hrt_4_to_8_turn2_anim	;    = up left ***

; old = down left
	.long	hrt_6_to_2_turn2_anim	;new = up right ***
	.long	hrt_6_to_4_turn2_anim	;    = down right
	.long	hrt_torso6_anim		;    = down left
	.long	hrt_6_to_8_turn2_anim	;    = up left

; old = up left
	.long	hrt_8_to_2_turn2_anim	;new = up right
	.long	hrt_8_to_4_turn2_anim	;    = down right ***
	.long	hrt_8_to_6_turn2_anim	;    = down left
	.long	hrt_torso8_anim		;    = up left


#*****************************************************************************
*
* SPECIAL MOVE PROCESSES
*

 SUBR	hrt_smove_table

	.long	sm_sliding_choke
	.long	0

sm_sliding_choke

#lp
	SLEEP	5*TSEC

;	;success!  Check for the UNINT bit, then queue it up.
;	move	*a8(ANIMODE),a14
;	btst	MODE_UNINT_BIT,a14
;	jrnz	#start_over
;	movi	und_sliding_choke_anim,a14
;	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	jruc	#lp


******************************************************************************

	.end
