**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		1/20/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"razor.asm"
	.title	"Razor Ramon specific game code"
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
	.include	"ring.equ"
	.include	"lifebar.h"


******************************************************************************
* EXTERNAL REFERENCES

	.ref	change_anim1a,change_anim2a,do_taunt,bounce_off_ropes
	.ref	check_secret_moves,wres_get_but_val_cur,master_keep_attached
	.ref	climb_turnbuckle,execute_walk,get_opp_plyrmode,mode_inair2
	.ref	wres_get_stick_val_cur,process_ptrs,keep_attached
	.ref	change_anim1,start_run,JUMP_ROPES,clear_damage_log
	.ref	wres_get_but_val_down,wres_get_stick_rel_new
	.ref	DO_REVERSAL,DO_REVERSAL_MESS

;animation sequences

	.ref	rzr_run2_anim

	.ref	rzr_3_head_hold_anim

	.ref	rzr_stand2_anim,rzr_stand8_anim
	.ref	rzr_stand4_anim,rzr_stand6_anim
	.ref	rzr_torso2_anim,rzr_torso8_anim
	.ref	rzr_torso4_anim,rzr_torso6_anim

	.ref	rzr_2_to_4_turn_anim,rzr_8_to_6_turn_anim	;stand
	.ref	rzr_4_to_2_turn_anim,rzr_6_to_8_turn_anim
	.ref	rzr_4_to_6_turn_anim,rzr_6_to_4_turn_anim
	.ref	rzr_2_to_8_turn_anim,rzr_8_to_2_turn_anim
	.ref	rzr_4_to_8_turn_anim,rzr_6_to_2_turn_anim
	.ref	rzr_2_to_6_turn_anim,rzr_8_to_4_turn_anim

	.ref	rzr_2_to_4_turn2_anim,rzr_8_to_6_turn2_anim	;torso
	.ref	rzr_4_to_2_turn2_anim,rzr_6_to_8_turn2_anim
	.ref	rzr_4_to_6_turn2_anim,rzr_6_to_4_turn2_anim
	.ref	rzr_2_to_8_turn2_anim,rzr_8_to_2_turn2_anim
	.ref	rzr_4_to_8_turn2_anim,rzr_6_to_2_turn2_anim
	.ref	rzr_2_to_6_turn2_anim,rzr_8_to_4_turn2_anim

	.ref	rzr_walk1_f2_anim,rzr_walk2_f2_anim,rzr_walk4_f2_anim
	.ref	rzr_walk5_f2_anim,rzr_walk6_f2_anim,rzr_walk8_f2_anim

	.ref	rzr_walk1_f4_anim,rzr_walk2_f4_anim,rzr_walk4_f4_anim
	.ref	rzr_3_head_held_stand_anim
	.ref	rzr_walk5_f4_anim,rzr_walk6_f4_anim,rzr_walk8_f4_anim

	.ref	rzr_2_punch_anim,rzr_4_punch_anim
	.ref	rzr_2_pin_anim,rzr_4_pin_anim
	.ref	rzr_2_uprcut_anim,rzr_4_uprcut_anim
	.ref	rzr_2_butt_anim,rzr_4_butt_anim
	.ref	rzr_2_kick_anim,rzr_4_kick_anim
	.ref	rzr_2_knee_anim,rzr_4_knee_anim
	.ref	rzr_flying_kick_anim
	.ref	rzr_2_ground_punch_anim,rzr_4_ground_punch_anim
	.ref	rzr_2_stomp_anim,rzr_4_stomp_anim
	.ref	rzr_2_grabfling_anim,rzr_4_grabfling_anim
	.ref	rzr_2_hair_pickup_anim,rzr_4_hair_pickup_anim

	.ref	rzr_2_push_anim,rzr_4_push_anim
	.ref	rzr_4_bigboot_anim
	.ref	rzr_climb_down_anim,rzr_climb_up_anim

	.ref	rzr_2_block_anim,rzr_4_block_anim
	.ref	rzr_2_hiptoss_anim,rzr_4_hiptoss_anim
	.ref	rzr_flying_elbow_anim,rzr_3_slash_anim
	.ref	rzr_2_rugshake_anim,rzr_4_rugshake_anim
	.ref	rzr_tbukl_elbow_anim,rzr_3_pile_driver_anim

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************

razor_secret_moves

	.long	#button_hold	;must have this one
	.long	#neck_grab
	.long	#grab_fling
	.long	#hip_toss
	.long	0

******************************************************************************
*
* SPECIAL MOVE PROCESSES - Secret moves
*
;a8=process of wrestler

 SUBR	rzr_smove_table
	.long	rzr_hdhold_pile
	.long	0


******************************************************************************
#button_hold
	clrc
	rets

******************************************************************************
#neck_grab
	.word	B_SPUNCH,		J_REAL_LR | J_TOWARD | J_AWAY | J_UP
	.word	J_TOWARD,		J_REAL_LR | J_UP | J_DOWN
	.word	J_TOWARD,		J_REAL_LR | J_UP | J_DOWN
	.word	8000h | 30		;max
	.long	#scrt_neck

 SUBRP	#scrt_neck
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

	movi	rzr_3_head_hold_anim,a0
	calla	change_anim1a
	rets

******************************************************************************
#grab_fling
	.word	B_SPUNCH | J_AWAY,	J_REAL_LR | J_UP | J_DOWN
	.word	8000h | 10		;max
	.long	#scrt_grabfling

 SUBRP	#scrt_grabfling

;Make this miss, rotate to missed opponent,
;and stay rotated to flung opponent, also make
;this work from both angles!

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#out

;If opponent is running, do a hip toss
	calla	get_opp_plyrmode
	cmpi	MODE_BOUNCING,a0
	jrz	#yes
	cmpi	MODE_RUNNING,a0
	jrnz	#nope
#yes
	FACE24	rzr,hiptoss_anim
	calla	change_anim1a

	WRSND	W_RAZOR,GRABFLING_T1,GRABFLING_T2
	rets
#nope

	FACE24	rzr,grabfling_anim
	calla	change_anim1a

	WRSND	W_RAZOR,GRABFLING_T1,GRABFLING_T2

#out	rets


******************************************************************************
#hip_toss
	.word	B_PUNCH | J_AWAY,	J_REAL_LR | J_UP | J_DOWN
	.word	8000h | 10		;max
	.long	#scrt_hiptoss

 SUBRP	#scrt_hiptoss
	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#out

;Don't do it when he is on ground
	calla	get_opp_plyrmode
	cmpi	MODE_ONGROUND,a0
	jrz	#out
	cmpi	MODE_DEAD,a0
	jrz	#out

	move	*a13(CLOSEST_DIST),a0
	cmpi	70h,a0
	jrgt	#out

	FACE24	rzr,hiptoss_anim
	calla	change_anim1a

	WRSND	W_RAZOR,GRABFLING_T1,GRABFLING_T2
	rets

#*****************************************************************************
rzr_hdhold_pile

#TIMEOUT	.equ	60

#lp0
	SLEEPK	1
#lp
	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrz	#cont
	cmpi	MODE_HEADHELD,a0
	jrnz	#lp0
#cont
	clr	a11

	WAITSWITCH_DWN	J_AWAY,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_TOWARD,0,#lp
	WAITSWITCH_DWN	J_TOWARD,0,#lp
	WAITSWITCH_DWN	B_SPUNCH,0,#lp
	
	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrz	#slam
	cmpi	MODE_HEADHELD,a0
	jrnz	#lp0

	PUSH	a13
	move	a8,a13
	calla	DO_REVERSAL
	calla	DO_REVERSAL_MESS
	PULL	a13

;Make sure the reversal works!
	movk	10,a0
	move	a0,*a8(SAFE_TIME)

	move	*a8(OBJ_ZPOS),a0,L
	addi	[5,0],a0
	move	a0,*a8(OBJ_ZPOS),L

#slam
	movi	rzr_3_pile_driver_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEP	60

	jruc	#lp

#*****************************************************************************

 SUBR	razor_ani_init

	move	*a13(FACING_DIR),a0
	btst	PLAYER_RIGHT_BIT,a0
	jrnz	#p1
;Plyr 2
	movi	rzr_stand4_anim,a0
	calla	change_anim1a

	movi	rzr_torso4_anim,a0
	calla	change_anim2a

	PUSH	a10
	move	a13,a10
	CREATE0	do_taunt
	PULL	a10

	rets

#p1
	movi	rzr_stand2_anim,a0
	calla	change_anim1a

	movi	rzr_torso2_anim,a0
	calla	change_anim2a

	rets


#*****************************************************************************
*
* RAZORS CONTROL CODE
*
* a13 = * razor process

 SUBR	move_razor


	movi	razor_secret_moves,a11
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
	.long	mode_inair2		;21
	.long	mode_normal	;22
	.long	mode_normal	;23
	.long	mode_chokehold		;24
	.ref	mode_choking
	.long	mode_choking		;25

#*****************************************************************************

mode_normal	;0


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

	FACE24	rzr,pin_anim
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
	.ref	ADD_IF_SILENT,CLIMB_ROPES
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
;This is both super buttons at the same time
	rets

#z
	rets


************
#punch		;1
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal	<  62  95	headbutt
* normal	>		normal punch
*
* onground	< 120  120	elbow drop
* onground	>		normal punch
*
* running |
* bouncing			hip toss
*
* onturnbkl |
* climbturnbkl			normal punch
*

	JJXM_INIT
	JJXM	NORMAL,		 62, 95,#punch_hdbutt,#punch_punch
	JJXM	DIZZY,		 62, 95,#punch_hdbutt,#punch_punch
	JJXM	BLOCK,		 62, 95,#punch_hdbutt,#punch_punch
	JJXM	ONGROUND,	120,120,#punch_lbdrop,#punch_punch
	JJXM	RUNNING,		#punch_hiptoss
	JJXM	BOUNCING,		#punch_hiptoss
	JJXM	ONTURNBKL,		#punch_punch
	JJXM	CLIMBTURNBKL,		#punch_punch
	JJXM	INAIR,		 62, 95,#punch_hdbutt,#punch_punch
	JJXM	ATTACHED,	 62, 95,#punch_hdbutt,#punch_punch
	JJXM	DEAD,		 62, 95,#punch_hdbutt,#punch_punch
	JJXM	OPPOVERHEAD,	 62, 95,#punch_hdbutt,#punch_punch
	JJXM	WAITANIM,	 62, 95,#punch_hdbutt,#punch_punch
	JJXM	GRAPPLE,	 62, 95,#punch_hdbutt,#punch_punch
	JJXM	MASTER,		 62, 95,#punch_hdbutt,#punch_punch
	JJXM	SLAVE,		 62, 95,#punch_hdbutt,#punch_punch
	JJXM	HEADHOLD,	 62, 95,#punch_hdbutt,#punch_punch
	JJXM	HEADHELD,	 62, 95,#punch_hdbutt,#punch_punch
	JJXM	PUPPET,		 62, 95,#punch_hdbutt,#punch_punch
	JJXM	INAIR2,		 62, 95,#punch_hdbutt,#punch_punch
	JJXM_END

*****
#punch_punch
std_punch

	FACE24	rzr,punch_anim
	calla	change_anim1a

	WRSND	W_RAZOR,PUNCH_T1,PUNCH_T2

	rets

*****
#punch_hdbutt

	FACE24	rzr,butt_anim
	calla	change_anim1a

	WRSND	W_RAZOR,HDBUTT_T1,HDBUTT_T2
	rets

*****
#punch_lbdrop

	FACE24	rzr,ground_punch_anim
	calla	change_anim1a

	WRSND	W_RAZOR,LBOWDROP_T1,LBOWDROP_T2
	rets

*****
#punch_hiptoss

	FACE24	rzr,hiptoss_anim
	calla	change_anim1a

	WRSND	W_RAZOR,HIPTOSS_T1,HIPTOSS_T2
	rets


************
#block		;2

std_block
	FACE24	rzr,block_anim
	calla	change_anim1a

	rets


************
#super_punch	;4
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal	<  65   45	headbutt or uppercut
*		>		blade slash	
*
* onground	< 120  120	elbow drop (or rug shake or hair pickup)
* onground	>		normal punch
*
* running |
* bouncing			hip toss
*
* onturnbkl |
* climbturnbkl			normal punch
*

	JJXM_INIT
	JJXM	NORMAL,		 65, 45,#spunch_close,#spunch_far
	JJXM	DIZZY,		 65, 45,#spunch_close,#spunch_far
	JJXM	BLOCK,		 65, 45,#spunch_close,#spunch_far
	JJXM	ONGROUND,	120,120,#spunch_lbowdrop,std_punch
	JJXM	RUNNING,		#spunch_hiptoss
	JJXM	BOUNCING,		#spunch_hiptoss
	JJXM	ONTURNBKL,	 65, 45,#spunch_close,#spunch_far
	JJXM	CLIMBTURNBKL,	 65, 45,#spunch_close,#spunch_far
	JJXM	INAIR,		 65, 45,#spunch_close,#spunch_far
	JJXM	ATTACHED,	 65, 45,#spunch_close,#spunch_far
	JJXM	BLOCK,		 65, 45,#spunch_close,#spunch_far
	JJXM	OPPOVERHEAD,	 65, 45,#spunch_close,#spunch_far
	JJXM	WAITANIM,	 65, 45,#spunch_close,#spunch_far
	JJXM	GRAPPLE,	 65, 45,#spunch_close,#spunch_far
	JJXM	MASTER,		 65, 45,#spunch_close,#spunch_far
	JJXM	SLAVE,		 65, 45,#spunch_close,#spunch_far
	JJXM	HEADHOLD,	 65, 45,#spunch_close,#spunch_far
	JJXM	HEADHELD,	 65, 45,#spunch_close,#spunch_far
	JJXM	PUPPET,		 65, 45,#spunch_close,#spunch_far
	JJXM	INAIR2,		 65, 45,#spunch_close,#spunch_far
	JJXM_END


#spunch_lbowdrop

;If near opponents head, and facing down, do the hair grab!
;If near feet, go for the rugshake

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

	FACE24	rzr,hair_pickup_anim
	calla	change_anim1
	WRSND	W_RAZOR,LBOWDROP_T1,LBOWDROP_T2
	rets

#no
	FACE24	rzr,rugshake_anim
	calla	change_anim1a

	rets


*****
#spunch_close

	;uppercut if stick is down, headbutt otherwise
	move	a13,a0
	calla	wres_get_stick_val_cur
	move	a0,a14
	FACE24	rzr,uprcut_anim
	btst	MOVE_DOWN_BIT,a14
	jrnz	#ok
	FACE24	rzr,butt_anim
#ok
	calla	change_anim1a
	WRSND	W_RAZOR,UPRCUT_T1,UPRCUT_T2
	rets

*****
#spunch_far

	movi	rzr_3_slash_anim,a0
	calla	change_anim1a

	rets

*****
#spunch_hiptoss
	FACE24	rzr,hiptoss_anim,a0
	calla	change_anim1a
	WRSND	W_RAZOR,SPUNCH_T1,SPUNCH_T2
	rets

************
#kick		;8
#super_kick	;16
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal	<  60   50	knee
*		>		normal kick
*
* onground	< 120  120	stomp
* onground	>		normal kick
*
* running |
* bouncing			big boot
*
* onturnbkl |			normal kick
* climbturnbkl			normal kick
*

	JJXM_INIT
	JJXM	NORMAL,		 60, 50,#kick_knee,#kick_kick
	JJXM	DIZZY,		 60, 50,#kick_knee,#kick_kick
	JJXM	BLOCK,		 60, 50,#kick_knee,#kick_kick
	JJXM	ONGROUND,	120,120,#kick_stomp,#kick_kick
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

	FACE24	rzr,kick_anim
	calla	change_anim1a

	WRSND	W_RAZOR,KICK_T1,KICK_T2
	rets

*****
#kick_knee

	FACE24	rzr,knee_anim
	calla	change_anim1a

	WRSND	W_RAZOR,KICK_T1,KICK_T2
	rets

*****
#kick_stomp

	FACE24	rzr,stomp_anim
	calla	change_anim1a

	WRSND	W_RAZOR,KICK_T1,KICK_T2
	rets

*****
#kick_bigboot

	movi	rzr_4_bigboot_anim,a0
	calla	change_anim1a

	WRSND	W_RAZOR,KICK_T1,KICK_T2
	rets


************
#punchkick	;9

;	FACE24	rzr,push_anim
;	calla	change_anim1a
;
;	WRSND	W_RAZOR,PUSH_T1,PUSH_T2

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#rets
	move	*a13(PLYRMODE),a0

	move	*a13(PLYRMODE),a0
	cmpi	MODE_RUNNING,a0
	jreq	#rets
	cmpi	MODE_BOUNCING,a0
	jreq	#rets
	calla	start_run

#rets
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
	.long	#punch			;1 punch
	.long	#block			;2
	.long	#z			;3
	.long	#super_punch		;4 super punch
	.long	#z,#z,#z		;5-7
	.long	#kick			;8 kick
	.long	#z,#z,#z,#z,#z,#z,#z	;9-15
	.long	#super_kick		;16 super kick
	.long	#z,#z,#z,#z,#z,#z,#z	;17-23
	.long	#z,#z,#z,#z,#z,#z,#z,#z	;24-31

************
#z
	rets

************
#block		;2
	move	*a13(OBJ_XVEL),a0,L
	sra	1,a0
	move	a0,*a13(OBJ_XVEL),L
	SETMODE	NORMAL
	jruc	std_block

************
#punch		;1
#super_punch	;4
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
*
* onground	< 176 176	running stomp
* onground	>		nothing
*
* all else			flying kick
*

	JJXM_INIT
	JJXM	NORMAL,			attack_flykick
	JJXM	BLOCK,			attack_flykick
	JJXM	DIZZY,			attack_flykick
	JJXM	ONGROUND,	176,176,#punch_flyelbow,#punch_rets
	JJXM	RUNNING,		attack_flykick
	JJXM	BOUNCING,		attack_flykick
	JJXM	ONTURNBKL,		attack_flykick
	JJXM	CLIMBTURNBKL,		attack_flykick
	JJXM	INAIR,			attack_flykick
	JJXM	ATTACHED,		attack_flykick
	JJXM	DEAD,			attack_flykick
	JJXM	OPPOVERHEAD,		attack_flykick
	JJXM	WAITANIM,		attack_flykick
	JJXM	GRAPPLE,		attack_flykick
	JJXM	MASTER,			attack_flykick
	JJXM	SLAVE,			attack_flykick
	JJXM	HEADHOLD,		attack_flykick
	JJXM	HEADHELD,		attack_flykick
	JJXM	PUPPET,			attack_flykick
	JJXM	INAIR2,			attack_flykick
	JJXM_END

#punch_flyelbow
attack_flyelbow
	movi	rzr_flying_elbow_anim,a0
	calla	change_anim1a

	move	*a13(OBJ_XVEL),a0,L
	sra	1,a0
	move	a0,*a13(OBJ_XVEL),L

	WRSND	W_RAZOR,FLYKICK_T1,FLYKICK_T2

	rets

#punch_rets
	rets

************
#kick		;4
#super_kick	;16
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal			flying kick
* dizzy					"
*
* onground	< 176 176	running stomp
* onground	>		nothing
*
* running			flying kick
* bouncing			flying kick
*
* onturnbkl			flying kick
* climbturnbkl			flying kick
*
	JJXM_INIT
	JJXM	NORMAL,			#kick_flykick
	JJXM	BLOCK,			#kick_flykick
	JJXM	DIZZY,			#kick_flykick
	JJXM	ONGROUND,	176,176,attack_flyelbow,#kick_rets
	JJXM	RUNNING,		#kick_flykick
	JJXM	BOUNCING,		#kick_flykick
	JJXM	ONTURNBKL,		#kick_flykick
	JJXM	CLIMBTURNBKL,		#kick_flykick
	JJXM	INAIR,			#kick_flykick
	JJXM	ATTACHED,		#kick_flykick
	JJXM	DEAD,			#kick_flykick
	JJXM	OPPOVERHEAD,		#kick_flykick
	JJXM	WAITANIM,		#kick_flykick
	JJXM	GRAPPLE,		#kick_flykick
	JJXM	MASTER,			#kick_flykick
	JJXM	SLAVE,			#kick_flykick
	JJXM	HEADHOLD,		#kick_flykick
	JJXM	HEADHELD,		#kick_flykick
	JJXM	PUPPET,			#kick_flykick
	JJXM	INAIR2,			#kick_flykick
	JJXM_END

#kick_flykick
attack_flykick
	movi	rzr_flying_kick_anim,a0
	calla	change_anim1a

	move	*a13(OBJ_XVEL),a0,L
	sra	1,a0
	move	a0,*a13(OBJ_XVEL),L

	WRSND	W_RAZOR,FLYKICK_T1,FLYKICK_T2

	SETMODE	INAIR

	rets

#kick_rets
	rets

#*****************************************************************************
mode_inair	;2

	rets

#*****************************************************************************
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

	movi	rzr_run2_anim,a0
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
	cmpi	rzr_climb_up_anim,a14
	jrne	#no_climbdown

	movi	rzr_climb_down_anim,a0
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

	movi	rzr_tbukl_elbow_anim,a0
	calla	change_anim1a

	WRSND	W_TAKER,FLYKICK_T1,FLYKICK_T2

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

	SETMODE	NORMAL

	FACE24	rzr,push_anim
	calla	change_anim1a

	WRSND	W_RAZOR,PUSH_T1,PUSH_T2

	rets


#*****************************************************************************
* razor with zero health

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
	.long	#z				;0
	.long	#punch				;1 punch
	.long	#block				;2 block
	.long	#z				;3
	.long	#super_punch			;4 super punch
	.long	#z,#z,#z			;5-7
	.long	#kick				;8 kick
	.long	#punch,#z,#z,#kick,#z,#z,#z	;9-15
	.long	#super_kick			;16 super kick
	.long	#z,#z,#z,#punch,#z,#z,#z	;17-23
	.long	#kick,#z,#z,#z,#z,#z,#z,#z	;24-31


************
#block
#z		;0
	rets

************
#punch		;1
#super_punch	;4
#kick		;8
#super_kick	;16

	movi	rzr_4_kick_anim,a0
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

	movi	rzr_3_head_held_stand_anim,a0
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

#VEL	equ	30000h	;normal vel
#DVEL	equ	21f0eh	;diagonal


 SUBR rzr_velocity_table

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

 SUBR rzr_rotate_anims_table
; old = up right
	.long	rzr_stand2_anim		;new = up right
	.long	rzr_2_to_4_turn_anim	;    = down right
	.long	rzr_2_to_6_turn_anim	;    = down left ***
	.long	rzr_2_to_8_turn_anim	;    = up left

; old = down right
	.long	rzr_4_to_2_turn_anim	;new = up right
	.long	rzr_stand4_anim		;    = down right
	.long	rzr_4_to_6_turn_anim	;    = down left
	.long	rzr_4_to_8_turn_anim	;    = up left ***

; old = down left
	.long	rzr_6_to_2_turn_anim	;new = up right ***
	.long	rzr_6_to_4_turn_anim	;    = down right
	.long	rzr_stand6_anim		;    = down left
	.long	rzr_6_to_8_turn_anim	;    = up left

; old = up left
	.long	rzr_8_to_2_turn_anim	;new = up right
	.long	rzr_8_to_4_turn_anim	;    = down right ***
	.long	rzr_8_to_6_turn_anim	;    = down left
	.long	rzr_stand8_anim		;    = up left


 SUBR rzr_leg_anims_table
;  MOVE
;(#1 - UP)				FACING
	.long	rzr_walk1_f2_anim	;1 (UP)
	.long	rzr_walk1_f2_anim	;2 (UP_RIGHT)
	.long	rzr_walk1_f4_anim	;3 (RIGHT)
	.long	rzr_walk1_f4_anim	;4 (DOWN_RIGHT)
	.long	rzr_walk1_f4_anim	;5 (DOWN)
	.long	rzr_walk1_f4_anim	;6 (DOWN_LEFT)
	.long	rzr_walk1_f2_anim	;7 (LEFT)
	.long	rzr_walk1_f2_anim	;8 (UP-LEFT)

;(#2 - UP-RIGHT)
	.long	rzr_walk2_f2_anim	;1 (UP)
	.long	rzr_walk2_f2_anim	;2 (UP_RIGHT)
	.long	rzr_walk2_f2_anim	;3 (RIGHT)
	.long	rzr_walk2_f4_anim	;4 (DOWN_RIGHT)
	.long	rzr_walk8_f4_anim	;5 (DOWN)
	.long	rzr_walk8_f4_anim	;6 (DOWN_LEFT)
	.long	rzr_walk4_f2_anim	;7 (LEFT)
	.long	rzr_walk4_f2_anim	;8 (UP-LEFT)

;(#3 - RIGHT)
	.long	rzr_walk2_f2_anim	;1 (UP)
	.long	rzr_walk2_f2_anim	;2 (UP_RIGHT)
	.long	rzr_walk2_f2_anim	;3 (RIGHT)
	.long	rzr_walk4_f4_anim	;4 (DOWN_RIGHT)
	.long	rzr_walk4_f4_anim	;5 (DOWN)
	.long	rzr_walk8_f4_anim	;6 (DOWN_LEFT)
	.long	rzr_walk6_f2_anim	;7 (LEFT)
	.long	rzr_walk6_f2_anim	;8 (UP-LEFT)


;(#4 - DOWN-RIGHT)
	.long	rzr_walk2_f2_anim	;1 (UP)
	.long	rzr_walk8_f2_anim	;2 (UP_RIGHT)
	.long	rzr_walk4_f4_anim	;3 (RIGHT)
	.long	rzr_walk4_f4_anim	;4 (DOWN_RIGHT)
	.long	rzr_walk2_f4_anim	;5 (DOWN)
	.long	rzr_walk6_f4_anim	;6 (DOWN_LEFT)
	.long	rzr_walk2_f2_anim	;7 (LEFT)
	.long	rzr_walk6_f2_anim	;8 (UP-LEFT)

;(#5 - DOWN)
	.long	rzr_walk5_f2_anim	;1 (UP)
	.long	rzr_walk5_f2_anim	;2 (UP_RIGHT)
	.long	rzr_walk5_f4_anim	;3 (RIGHT)
	.long	rzr_walk5_f4_anim	;4 (DOWN_RIGHT)
	.long	rzr_walk5_f4_anim	;5 (DOWN)
	.long	rzr_walk5_f4_anim	;6 (DOWN_LEFT)
	.long	rzr_walk5_f2_anim	;7 (LEFT)
	.long	rzr_walk5_f2_anim	;8 (UP-LEFT)

;(#6 - DOWN-LEFT)
	.long	rzr_walk2_f2_anim	;1 (UP)
	.long	rzr_walk6_f2_anim	;2 (UP_RIGHT)
	.long	rzr_walk2_f2_anim	;3 (RIGHT)
	.long	rzr_walk6_f4_anim	;4 (DOWN_RIGHT)
	.long	rzr_walk2_f4_anim	;5 (DOWN)
	.long	rzr_walk4_f4_anim	;6 (DOWN_LEFT)
	.long	rzr_walk2_f2_anim	;7 (LEFT)
	.long	rzr_walk8_f2_anim	;8 (UP-LEFT)

;(#7 - LEFT)
	.long	rzr_walk2_f2_anim	;1 (UP)
	.long	rzr_walk6_f2_anim	;2 (UP_RIGHT)
	.long	rzr_walk6_f2_anim	;3 (RIGHT)
	.long	rzr_walk8_f4_anim	;4 (DOWN_RIGHT)
	.long	rzr_walk4_f4_anim	;5 (DOWN)
	.long	rzr_walk4_f4_anim	;6 (DOWN_LEFT)
	.long	rzr_walk2_f2_anim	;7 (LEFT)
	.long	rzr_walk2_f2_anim	;8 (UP-LEFT)

;(#8 - UP-LEFT)
	.long	rzr_walk2_f2_anim	;1 (UP)
	.long	rzr_walk4_f2_anim	;2 (UP_RIGHT)
	.long	rzr_walk6_f2_anim	;3 (RIGHT)
	.long	rzr_walk8_f4_anim	;4 (DOWN_RIGHT)
	.long	rzr_walk6_f4_anim	;5 (DOWN)
	.long	rzr_walk2_f4_anim	;6 (DOWN_LEFT)
	.long	rzr_walk2_f2_anim	;7 (LEFT)
	.long	rzr_walk2_f2_anim	;8 (UP-LEFT)


 SUBR rzr_torso_anims_table
; old = up right
	.long	rzr_torso2_anim		;new = up right
	.long	rzr_2_to_4_turn2_anim	;    = down right
	.long	rzr_2_to_6_turn2_anim	;    = down left ***
	.long	rzr_2_to_8_turn2_anim	;    = up left

; old = down right
	.long	rzr_4_to_2_turn2_anim	;new = up right
	.long	rzr_torso4_anim		;    = down right
	.long	rzr_4_to_6_turn2_anim	;    = down left
	.long	rzr_4_to_8_turn2_anim	;    = up left ***

; old = down left
	.long	rzr_6_to_2_turn2_anim	;new = up right ***
	.long	rzr_6_to_4_turn2_anim	;    = down right
	.long	rzr_torso6_anim		;    = down left
	.long	rzr_6_to_8_turn2_anim	;    = up left

; old = up left
	.long	rzr_8_to_2_turn2_anim	;new = up right
	.long	rzr_8_to_4_turn2_anim	;    = down right ***
	.long	rzr_8_to_6_turn2_anim	;    = down left
	.long	rzr_torso8_anim		;    = up left


******************************************************************************
	.end
