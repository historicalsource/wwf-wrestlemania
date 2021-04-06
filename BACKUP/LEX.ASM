**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		7/15/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"lex.asm"
	.title	"Lex Luger specific game code"
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
	.ref	do_roll,do_taunt
	.ref	JUMP_ROPES

	;from CROWD.ASM
	.ref	crowd_cheer

	;from DCSSOUND.ASM
	.ref	triple_sound

	;from WRESTLE.ASM
	.ref	calc_line_x
	.ref	face_each_other
	.ref	lineup_grapple

	
******************************************************************************
* ANIMATION SEQUENCES

	.ref	wres_slave_anim
	.ref	lex_zip_anim
	.ref	start_run_anim

	.ref	lex_2_block_anim,lex_4_block_anim
	.ref	lex_2_hitblock_anim,lex_4_hitblock_anim

	.ref	lex_stand2_anim,lex_stand8_anim
	.ref	lex_stand4_anim,lex_stand6_anim
	.ref	lex_torso2_anim,lex_torso8_anim
	.ref	lex_torso4_anim,lex_torso6_anim

	.ref	lex_2_to_4_turn_anim,lex_8_to_6_turn_anim	;stand
	.ref	lex_4_to_2_turn_anim,lex_6_to_8_turn_anim
	.ref	lex_4_to_6_turn_anim,lex_6_to_4_turn_anim
	.ref	lex_2_to_8_turn_anim,lex_8_to_2_turn_anim
	.ref	lex_4_to_8_turn_anim,lex_6_to_2_turn_anim
	.ref	lex_2_to_6_turn_anim,lex_8_to_4_turn_anim

	.ref	lex_2_to_4_turn2_anim,lex_8_to_6_turn2_anim	;torso
	.ref	lex_4_to_2_turn2_anim,lex_6_to_8_turn2_anim
	.ref	lex_4_to_6_turn2_anim,lex_6_to_4_turn2_anim
	.ref	lex_2_to_8_turn2_anim,lex_8_to_2_turn2_anim
	.ref	lex_4_to_8_turn2_anim,lex_6_to_2_turn2_anim
	.ref	lex_2_to_6_turn2_anim,lex_8_to_4_turn2_anim

	.ref	lex_walk1_f2_anim,lex_walk2_f2_anim,lex_walk4_f2_anim
	.ref	lex_walk5_f2_anim,lex_walk6_f2_anim,lex_walk8_f2_anim

	.ref	lex_walk1_f4_anim,lex_walk2_f4_anim,lex_walk4_f4_anim
	.ref	lex_walk5_f4_anim,lex_walk6_f4_anim,lex_walk8_f4_anim

	.ref	lex_run2_anim

	.ref	lex_2_punch_anim,lex_4_punch_anim
	.ref	lex_2_kick_anim,lex_4_kick_anim

	.ref	lex_2_head_hit_anim,lex_4_head_hit_anim
	.ref	lex_2_head_hit2_anim,lex_4_head_hit2_anim
	.ref	lex_2_body_hit_anim,lex_4_body_hit_anim
	.ref	lex_hitonground_anim

	.ref	lex_2_butt_anim,lex_4_butt_anim
	.ref	lex_2_knee_anim,lex_4_knee_anim

	.ref	lex_head_hit_dizzy_anim
	.ref	lex_2_stomp_anim,lex_4_stomp_anim

	.ref	lex_2_push_anim,lex_4_push_anim
	.ref	lex_4_losebal_anim

	.ref	lex_4_grabfling_anim

	.ref	lex_fall_back_anim

	.ref	lex_summon_anim,lex_summon2_anim
	.ref	lex_faceup_getup_anim
	.ref	lex_4_graboh_anim,lex_heldoh_anim

;	.ref	lex_2_turbopunch_anim,lex_4_turbopunch_anim

	.ref	lex_flip_anim

	.ref	lex_flying_kick_anim

	.ref	lex_2_ground_punch_anim,lex_4_ground_punch_anim
	.ref	lex_flying_ground_punch_anim,lex_climb_down_anim
	.ref	lex_buckle_leap_anim,lex_climb_up_anim
	.ref	lex_grab2overhead_anim
	.ref	lex_backbreaker_anim
	.ref	lex_ohslam_anim

	.ref	lex_vsuplex_anim
	.ref	lex_grab2elbow_anim
	.ref	lex_hiptoss_anim
;RJR START
	.ref	lex_slamdown_anim
	.ref	lex_grabslam_anim
;RJR END

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************

lex_secret_moves
	.long	#button_hold	;must have this one
	.long	#neck_grab
	.long	#grab_fling
;	.long	#2nd_wind1
;	.long	#2nd_wind2

	.long	0

	.ref	lex_2_grabfling_anim
	.ref	lex_4_grabfling_anim

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

	.ref	lex_3_head_hold_anim
	movi	lex_3_head_hold_anim,a0
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


	FACE24	lex,grabfling_anim
	calla	change_anim1a

	WRSND	W_LUGER,GRABFLING_T1,GRABFLING_T2

#out
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

;;;	movi	lex_2ndwind_anim,a0
	calla	change_anim1a
#no_scrt_2ndwind
	rets


#*****************************************************************************

 SUBR	lex_ani_init

	move	*a13(FACING_DIR),a0
	btst	PLAYER_RIGHT_BIT,a0
	jrnz	#p1
;Plyr 2
	movi	lex_stand4_anim,a0
	calla	change_anim1a

	movi	lex_torso4_anim,a0
	calla	change_anim2a

	PUSH	a10
	move	a13,a10
	CREATE0	do_taunt
	PULL	a10

	rets

#p1
	movi	lex_stand2_anim,a0
	calla	change_anim1a

	movi	lex_torso2_anim,a0
	calla	change_anim2a

	rets


#*****************************************************************************
*
* LEX CONTROL CODE
*
* a13 = * Lex process

 SUBR	move_lex


;	movi	100h,a0			;temp fix!
;	move	a0,*a13(ANI_SPEED)

	movi	lex_secret_moves,a11
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

	.ref	lex_2_pin_anim
	.ref	lex_4_pin_anim
	.ref	ADD_IF_SILENT,CLIMB_ROPES

	FACE24	lex,pin_anim
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
#z
	rets

#graboh		;8
;This is both super buttons at the same time
	rets


************
#punch		;1
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal	<  56  95	headbutt
* normal	>		normal punch
*
* onground	< 120  120	elbow drop
* onground	>		normal punch
*
* running |
* bouncing			normal punch
*
* onturnbkl	<  60  60	punch
* onturnbkl	>		normal punch
*
* climbturnbkl	<  60  60	punch
* climbturnbkl	>		normal punch
*

	JJXM_INIT
	JJXM	NORMAL,		 50, 95,#punch_hdbutt,#punch_punch
	JJXM	BLOCK,		 50, 95,#punch_hdbutt,#punch_punch
	JJXM	DIZZY,		 50, 95,#punch_hdbutt,#punch_punch
	JJXM	ONGROUND,	120,120,#punch_lbdrop,#punch_punch
	JJXM	RUNNING,	 	#punch_punch
	JJXM	BOUNCING,		#punch_punch
	JJXM	ONTURNBKL,	 	#punch_punch
	JJXM	CLIMBTURNBKL,	 	#punch_punch
	JJXM	INAIR,		 50, 95,#punch_hdbutt,#punch_punch
	JJXM	ATTACHED,	 50, 95,#punch_hdbutt,#punch_punch
	JJXM	DEAD,		 50, 95,#punch_hdbutt,#punch_punch
	JJXM	OPPOVERHEAD,	 50, 95,#punch_hdbutt,#punch_punch
	JJXM	WAITANIM,	 50, 95,#punch_hdbutt,#punch_punch
	JJXM	GRAPPLE,	 50, 95,#punch_hdbutt,#punch_punch
	JJXM	MASTER,		 50, 95,#punch_hdbutt,#punch_punch
	JJXM	SLAVE,		 50, 95,#punch_hdbutt,#punch_punch
	JJXM	HEADHOLD,	 50, 95,#punch_hdbutt,#punch_punch
	JJXM	HEADHELD,	 50, 95,#punch_hdbutt,#punch_punch
	JJXM	PUPPET,		 50, 95,#punch_hdbutt,#punch_punch
	JJXM	INAIR2,		 50, 95,#punch_hdbutt,#punch_punch
	JJXM_END

*****	
#punch_punch

std_punch

	FACE24	lex,punch_anim
	calla	change_anim1a

	WRSND	W_LUGER,PUNCH_T1,PUNCH_T2

	rets

*****
#punch_hdbutt

	FACE24	lex,butt_anim
	calla	change_anim1a

	WRSND	W_LUGER,HDBUTT_T1,HDBUTT_T2
	rets

*****
#punch_lbdrop

	FACE24	lex,ground_punch_anim
	calla	change_anim1a

	WRSND	W_LUGER,LBOWDROP_T1,LBOWDROP_T2
	rets


************
#block		;2

	clr	a0
	move	a0,*a13(OBJ_XVEL),L

std_block
	FACE24	lex,block_anim
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
	JJXM	NORMAL,		 50, 92,#spunch_special,#spunch_slap	;0
	JJXM	RUNNING,	 50, 92,#spunch_special,#spunch_slap	;1
	JJXM	INAIR,		 50, 92,#spunch_special,#spunch_slap	;2
	JJXM	ATTACHED,	 50, 92,#spunch_special,#spunch_slap	;3
	JJXM	ONGROUND,	 126,112,#spunch_lbowdrop,std_punch	;4
	JJXM	BOUNCING,		#spunch_rets			;5
	JJXM	ONTURNBKL,	 	#spunch_slap			;6
	JJXM	BLOCK,		 50, 92,#spunch_special,#spunch_slap	;7
	JJXM	DIZZY,		 50, 92,#spunch_special,#spunch_slap	;8
	JJXM	DEAD,		 96,112,#spunch_lbowdrop,std_punch	;9
	JJXM	OPPOVERHEAD,	 50, 92,#spunch_special,#spunch_slap	;10
	JJXM	CLIMBTURNBKL,		std_punch			;11
	JJXM	WAITANIM,	 50, 92,#spunch_special,#spunch_slap	;12
	JJXM	GRAPPLE,	 50, 92,#spunch_special,#spunch_slap	;13
	JJXM	MASTER,		 50, 92,#spunch_special,#spunch_slap	;14
	JJXM	SLAVE, 		 50, 92,#spunch_special,#spunch_slap	;15
	JJXM	HEADHOLD,	 50, 92,#spunch_special,#spunch_slap	;16
	JJXM	HEADHELD,	 50, 92,#spunch_special,#spunch_slap	;19
	JJXM	PUPPET,		 50, 92,#spunch_special,#spunch_slap	;20
	JJXM	INAIR2,		 50, 92,#spunch_special,#spunch_slap	;21
	JJXM_END

#spunch_rets
	rets

*****
#spunch_slap

;RJR START
	movi	lex_grab2elbow_anim,a0
	movi	lex_hiptoss_anim,a0

	movi	lex_grab2overhead_anim,a0
	movi	lex_grabslam_anim,a0
;RJR END
	calla	change_anim1a

	WRSND	W_LUGER,PUNCH_T1,PUNCH_T2

	rets

*****
#spunch_special

;	movi	dnk_3_pile_driver_anim,a0
;	FACE24	dnk,butt_anim
	FACE24	lex,butt_anim
	calla	change_anim1

	WRSND	W_LUGER,HDBUTT_T1,HDBUTT_T2

	rets

*****
#spunch_lbowdrop
	.ref	lex_2_hair_pickup_anim
	.ref	lex_4_hair_pickup_anim
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

	FACE24	lex,hair_pickup_anim
	calla	change_anim1

	WRSND	W_LUGER,LBOWDROP_T1,LBOWDROP_T2
    
	rets

#no
	FACE24	lex,ground_punch_anim
	calla	change_anim1

	WRSND	W_LUGER,LBOWDROP_T1,LBOWDROP_T2

	rets


;	FACE24	lex,turbopunch_anim
;
;
;	movi	lex_flip_anim,a0
;	calla	change_anim1a
;
;	WRSND	W_LUGER,PUNCH_T1,PUNCH_T2
;
;	rets

************
#kick		;8
#super_kick	;16
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal	<  60   50	knee
*		>		normal kick
*
* onground	< 128  128	stomp
* onground	>		normal kick
*
* running |
* bouncing			big boot
*
* onturnbkl |
* climbturnbkl			normal kick
*


	JJXM_INIT
	JJXM	NORMAL,		 60, 50,#kick_knee,#kick_kick
	JJXM	BLOCK,		 60, 50,#kick_knee,#kick_kick
	JJXM	DIZZY,		 60, 50,#kick_knee,#kick_kick
	JJXM	ONGROUND,	128,128,#kick_stomp,#kick_kick
	JJXM	RUNNING,	 	#kick_bigboot
	JJXM	BOUNCING,	 	#kick_bigboot
	JJXM	ONTURNBKL,	 	#kick_kick
	JJXM	CLIMBTURNBKL,	 	#kick_kick
	JJXM	INAIR,		 60, 50,#kick_knee,#kick_kick
	JJXM	ATTACHED,	 60, 50,#kick_knee,#kick_kick
	JJXM	DEAD,		 60, 50,#kick_knee,#kick_kick
	JJXM	OPPOVERHEAD,	 60, 50,#kick_knee,#kick_kick
	JJXM	WAITANIM,	 60, 50,#kick_knee,#kick_kick
	JJXM	GRAPPLE,	 60, 50,#kick_knee,#kick_kick
	JJXM	MASTER,		 60, 50,#kick_knee,#kick_kick
	JJXM	SLAVE,		 60, 50,#kick_knee,#kick_kick
	JJXM	HEADHOLD,	 60, 50,#kick_knee,#kick_kick
	JJXM	HEADHELD,	 60, 50,#kick_knee,#kick_kick
	JJXM	PUPPET,		 60, 50,#kick_knee,#kick_kick
	JJXM	INAIR2,		 60, 50,#kick_knee,#kick_kick
	JJXM_END

*****
#kick_kick

	FACE24	lex,kick_anim
	calla	change_anim1a

	WRSND	W_LUGER,KICK_T1,KICK_T2
	rets

*****
#kick_knee

	FACE24	lex,knee_anim
	calla	change_anim1a

	WRSND	W_LUGER,KICK_T1,KICK_T2
	rets

*****
#kick_stomp
attack_stomp

	FACE24	lex,stomp_anim
	calla	change_anim1a

	WRSND	W_LUGER,KICK_T1,KICK_T2

	rets

*****
#kick_bigboot

	FACE24	lex,kick_anim
	calla	change_anim1a

	WRSND	W_LUGER,KICK_T1,KICK_T2
	rets


************
#punchkick	;9

	movi	start_run_anim,a0
	calla	change_anim1a

	rets


#*****************************************************************************
*
* RUNNING (if GETUP_TIME > 0 then player is out of control)
*

#XRUN_VAL	equ	60000h		;50000h
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
* onground	< 176 176	flying ground punch
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

#punch_rets
	rets

*****
#punch_clothesline

	rets

*****
#punch_bellyflop
attack_bellyflop

	movi	lex_flying_ground_punch_anim,a0
	calla	change_anim1a

	WRSND	W_LUGER,FLYKICK_T1,FLYKICK_T2
	rets


************
#block		;2

	move	*a13(OBJ_XVEL),a0,L
	sra	1,a0
	move	a0,*a13(OBJ_XVEL),L
	SETMODE	NORMAL
	jruc	std_block
	rets

************
#kick		;8
#super_kick	;16
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal			flying kick
* dizzy					"
*
* onground	< 176 176	flying ground punch
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

	movi	lex_flying_kick_anim,a0
	calla	change_anim1a

	WRSND	W_LUGER,FLYKICK_T1,FLYKICK_T2

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

;	move	*a13(GETUP_TIME),a0
;	jrnz	#exit
;
;	move	*a13(ANIBASE),a0,L
;	cmpi	lex_faceup_getup_anim,a0
;	jrz	#exit
;
;	calla	do_roll
;	jrnz	#exit			;did roll
;
;	movi	lex_faceup_getup_anim,a0
;
;	calla	change_anim1a
;
;#exit
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

	movi	lex_run2_anim,a0
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
	cmpi	lex_climb_up_anim,a14
	jrne	#no_climbdown

	movi	lex_climb_down_anim,a0
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
#super_punch	;4
#kick		;8
#super_kick	;16

	movi	lex_buckle_leap_anim,a0
	calla	change_anim1a

	WRSND	W_LUGER,FLYKICK_T1,FLYKICK_T2
	rets

************
#block		;2

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

	FACE24	lex,push_anim
	calla	change_anim1a

	WRSND	W_LUGER,PUSH_T1,PUSH_T2

	rets


#*****************************************************************************
* doink with zero health

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


	move	*a13(ATTACH_PROC),a11,L
	jrz	#not_attached
	move	*a11(ATTACH_PROC),a14,L
	cmp	a13,a14
	jreq	#still_attached

	clr	a0
	move	a0,*a13(ATTACH_PROC),L

#not_attached

	SETMODE	NORMAL

	movi	MODE_NORMAL,a0
	move	a0,*a13(ANIMODE)

	rets


#still_attached

	move	a13,a0
	calla	wres_get_but_val_down
	andi	011111b,a0
	jrz	#x

	X32	a0
	addi	#action_table,a0
	move	*a0,a0,L
	call	a0

#x	rets


#action_table
	.long	#z				;0
	.long	#punch				;1
	.long	#block				;2
	.long	#z				;3
	.long	#super_punch			;4
	.long	#z,#z,#z			;5-7
	.long	#kick				;8
	.long	#punch_kick			;9
	.long	#z,#z,#z,#z,#z,#z		;10-15
	.long	#super_kick			;16
	.long	#z,#z,#z			;17-19
	.long	#spunch_skick			;20
	.long	#z,#z,#z			;21-23
	.long	#z,#z,#z,#z,#z,#z,#z,#z		;24-31

#z		;0
	rets

#punch		;1
#punch_kick	;9
	movi	lex_backbreaker_anim,a0
	calla	change_anim1a
	rets

#block		;2
	rets

#super_punch	;4
#spunch_skick	;20
;RJR START
	movi	lex_backbreaker_anim,a0
	movi	lex_slamdown_anim,a0
;RJR END
	calla	change_anim1a
	rets

#kick		;8
	movi	lex_ohslam_anim,a0
	calla	change_anim1a
	rets

#super_kick	;16
;RJR START
	movi	lex_ohslam_anim,a0
	movi	lex_slamdown_anim,a0
;RJR END
	calla	change_anim1a
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
	movi	lex_4_knee_anim,a0
	calla	change_anim1a
	rets

#tag
;	movi	dnk_uppercut_to_head_anim,a0
	movi	lex_4_knee_anim,a0
	calla	change_anim1a
	rets

************
#super_punch	;4

	move	a13,a0
	calla	wres_get_stick_val_cur

	btst	PLAYER_DOWN_BIT,a0
	jrz	#punch

	movi	lex_vsuplex_anim,a0
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
	movi	lex_4_knee_anim,a0
	calla	change_anim1a
	rets

#knee
;	movi	dnk_3_knee_to_head_anim,a0
	movi	lex_4_knee_anim,a0
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
	movi	lex_4_knee_anim,a0
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

	.ref	lex_3_head_held_stand_anim
	movi	lex_3_head_held_stand_anim,a0
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


 SUBR lex_velocity_table

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

 SUBR lex_rotate_anims_table
; old = up right
	.long	lex_stand2_anim		;new = up right
	.long	lex_2_to_4_turn_anim	;    = down right
	.long	lex_2_to_6_turn_anim	;    = down left
	.long	lex_2_to_8_turn_anim	;    = up left

; old = down right
	.long	lex_4_to_2_turn_anim	;new = up right
	.long	lex_stand4_anim		;    = down right
	.long	lex_4_to_6_turn_anim	;    = down left
	.long	lex_4_to_8_turn_anim	;    = up left

; old = down left
	.long	lex_6_to_2_turn_anim	;new = up right
	.long	lex_6_to_4_turn_anim	;    = down right
	.long	lex_stand6_anim		;    = down left
	.long	lex_6_to_8_turn_anim	;    = up left

; old = up left
	.long	lex_8_to_2_turn_anim	;new = up right
	.long	lex_8_to_4_turn_anim	;    = down right
	.long	lex_8_to_6_turn_anim	;    = down left
	.long	lex_stand8_anim		;    = up left


 SUBR lex_leg_anims_table
;  MOVE
;(#1 - UP)				FACING
	.long	lex_walk1_f2_anim	;1 (UP)
	.long	lex_walk1_f2_anim	;2 (UP_RIGHT)
	.long	lex_walk1_f4_anim	;3 (RIGHT)
	.long	lex_walk1_f4_anim	;4 (DOWN_RIGHT)
	.long	lex_walk1_f4_anim	;5 (DOWN)
	.long	lex_walk1_f4_anim	;6 (DOWN_LEFT)
	.long	lex_walk1_f2_anim	;7 (LEFT)
	.long	lex_walk1_f2_anim	;8 (UP-LEFT)

;(#2 - UP-RIGHT)
	.long	lex_walk2_f2_anim	;1 (UP)
	.long	lex_walk2_f2_anim	;2 (UP_RIGHT)
	.long	lex_walk2_f2_anim	;3 (RIGHT)
	.long	lex_walk2_f4_anim	;4 (DOWN_RIGHT)
	.long	lex_walk8_f4_anim	;5 (DOWN)
	.long	lex_walk8_f4_anim	;6 (DOWN_LEFT)
	.long	lex_walk4_f2_anim	;7 (LEFT)
	.long	lex_walk4_f2_anim	;8 (UP-LEFT)

;(#3 - RIGHT)
	.long	lex_walk2_f2_anim	;1 (UP)
	.long	lex_walk2_f2_anim	;2 (UP_RIGHT)
	.long	lex_walk2_f2_anim	;3 (RIGHT)
	.long	lex_walk4_f4_anim	;4 (DOWN_RIGHT)
	.long	lex_walk4_f4_anim	;5 (DOWN)
	.long	lex_walk8_f4_anim	;6 (DOWN_LEFT)
	.long	lex_walk6_f2_anim	;7 (LEFT)
	.long	lex_walk6_f2_anim	;8 (UP-LEFT)


;(#4 - DOWN-RIGHT)
	.long	lex_walk2_f2_anim	;1 (UP)
	.long	lex_walk8_f2_anim	;2 (UP_RIGHT)
	.long	lex_walk4_f4_anim	;3 (RIGHT)
	.long	lex_walk4_f4_anim	;4 (DOWN_RIGHT)
	.long	lex_walk2_f4_anim	;5 (DOWN)
	.long	lex_walk6_f4_anim	;6 (DOWN_LEFT)
	.long	lex_walk2_f2_anim	;7 (LEFT)
	.long	lex_walk6_f2_anim	;8 (UP-LEFT)

;(#5 - DOWN)
	.long	lex_walk5_f2_anim	;1 (UP)
	.long	lex_walk5_f2_anim	;2 (UP_RIGHT)
	.long	lex_walk5_f4_anim	;3 (RIGHT)
	.long	lex_walk5_f4_anim	;4 (DOWN_RIGHT)
	.long	lex_walk5_f4_anim	;5 (DOWN)
	.long	lex_walk5_f4_anim	;6 (DOWN_LEFT)
	.long	lex_walk5_f2_anim	;7 (LEFT)
	.long	lex_walk5_f2_anim	;8 (UP-LEFT)

;(#6 - DOWN-LEFT)
	.long	lex_walk2_f2_anim	;1 (UP)
	.long	lex_walk6_f2_anim	;2 (UP_RIGHT)
	.long	lex_walk2_f2_anim	;3 (RIGHT)
	.long	lex_walk6_f4_anim	;4 (DOWN_RIGHT)
	.long	lex_walk2_f4_anim	;5 (DOWN)
	.long	lex_walk4_f4_anim	;6 (DOWN_LEFT)
	.long	lex_walk2_f2_anim	;7 (LEFT)
	.long	lex_walk8_f2_anim	;8 (UP-LEFT)

;(#7 - LEFT)
	.long	lex_walk2_f2_anim	;1 (UP)
	.long	lex_walk6_f2_anim	;2 (UP_RIGHT)
	.long	lex_walk6_f2_anim	;3 (RIGHT)
	.long	lex_walk8_f4_anim	;4 (DOWN_RIGHT)
	.long	lex_walk4_f4_anim	;5 (DOWN)
	.long	lex_walk4_f4_anim	;6 (DOWN_LEFT)
	.long	lex_walk2_f2_anim	;7 (LEFT)
	.long	lex_walk2_f2_anim	;8 (UP-LEFT)

;(#8 - UP-LEFT)
	.long	lex_walk2_f2_anim	;1 (UP)
	.long	lex_walk4_f2_anim	;2 (UP_RIGHT)
	.long	lex_walk6_f2_anim	;3 (RIGHT)
	.long	lex_walk8_f4_anim	;4 (DOWN_RIGHT)
	.long	lex_walk6_f4_anim	;5 (DOWN)
	.long	lex_walk2_f4_anim	;6 (DOWN_LEFT)
	.long	lex_walk2_f2_anim	;7 (LEFT)
	.long	lex_walk2_f2_anim	;8 (UP-LEFT)


 SUBR lex_torso_anims_table
; old = up right
	.long	lex_torso2_anim		;new = up right
	.long	lex_2_to_4_turn2_anim	;    = down right
	.long	lex_2_to_6_turn2_anim	;    = down left
	.long	lex_2_to_8_turn2_anim	;    = up left

; old = down right
	.long	lex_4_to_2_turn2_anim	;new = up right
	.long	lex_torso4_anim		;    = down right
	.long	lex_4_to_6_turn2_anim	;    = down left
	.long	lex_4_to_8_turn2_anim	;    = up left

; old = down left
	.long	lex_6_to_2_turn2_anim	;new = up right
	.long	lex_6_to_4_turn2_anim	;    = down right
	.long	lex_torso6_anim		;    = down left
	.long	lex_6_to_8_turn2_anim	;    = up left

; old = up left
	.long	lex_8_to_2_turn2_anim	;new = up right
	.long	lex_8_to_4_turn2_anim	;    = down right
	.long	lex_8_to_6_turn2_anim	;    = down left
	.long	lex_torso8_anim		;    = up left


******************************************************************************

	.end
