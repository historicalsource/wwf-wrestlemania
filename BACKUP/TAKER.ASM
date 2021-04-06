**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		5/18/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"taker.asm"
	.title	"Undertaker specific game code"
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
	.include	"damage.equ"


******************************************************************************
* EXTERNAL REFERENCES

	.ref	wres_get_but_val_up,wres_get_but_val_down,wres_get_but_val_cur
	.ref	wres_get_stick_val_cur

	.ref	wres_get_stick_rel_cur,wres_get_stick_rel_new
	.ref	wres_get_stick_val_down

	.ref	get_punch_dtime
	.ref	clear_damage_log

	.ref	change_anim1,change_anim1a
	.ref	change_anim2,change_anim2a
	.ref	keep_attached
	.ref	get_opp_plyrmode
	.ref	check_secret_moves
	.ref	execute_walk
	.ref	bounce_off_ropes
	.ref	climb_turnbuckle
	.ref	do_roll
	.ref	CLIMB_ROPES,ADD_IF_SILENT,JUMP_ROPES
	;from WRESTLE.ASM
	.ref	lineup_grapple

******************************************************************************
* ANIMATION SEQUENCES

	.ref	und_2_pin_anim
	.ref	und_4_pin_anim
	.ref	und_4_pin2_anim

	.ref	und_4_block_anim,und_2_block_anim
	.ref	und_2_hitblock_anim,und_4_hitblock_anim
	.ref	start_run_anim

	.ref	wres_slave_anim
	.ref	und_zip_anim

	.ref	und_stand2_anim,und_stand8_anim
	.ref	und_stand4_anim,und_stand6_anim
	.ref	und_torso2_anim,und_torso8_anim
	.ref	und_torso4_anim,und_torso6_anim

	.ref	und_2_to_4_turn_anim,und_8_to_6_turn_anim	;stand
	.ref	und_4_to_2_turn_anim,und_6_to_8_turn_anim
	.ref	und_4_to_6_turn_anim,und_6_to_4_turn_anim
	.ref	und_2_to_8_turn_anim,und_8_to_2_turn_anim
	.ref	und_4_to_8_turn_anim,und_6_to_2_turn_anim
	.ref	und_2_to_6_turn_anim,und_8_to_4_turn_anim

	.ref	und_2_to_4_turn2_anim,und_8_to_6_turn2_anim	;torso
	.ref	und_4_to_2_turn2_anim,und_6_to_8_turn2_anim
	.ref	und_4_to_6_turn2_anim,und_6_to_4_turn2_anim
	.ref	und_2_to_8_turn2_anim,und_8_to_2_turn2_anim
	.ref	und_4_to_8_turn2_anim,und_6_to_2_turn2_anim
	.ref	und_2_to_6_turn2_anim,und_8_to_4_turn2_anim

	.ref	und_walk1_f2_anim,und_walk2_f2_anim,und_walk4_f2_anim
	.ref	und_walk5_f2_anim,und_walk6_f2_anim,und_walk8_f2_anim

	.ref	und_walk1_f4_anim,und_walk2_f4_anim,und_walk4_f4_anim
	.ref	und_walk5_f4_anim,und_walk6_f4_anim,und_walk8_f4_anim

	.ref	und_run2_anim

	.ref	und_2_punch_anim,und_4_punch_anim
	.ref	und_2_kick_anim,und_4_kick_anim

	.ref	und_2_head_hit_anim,und_4_head_hit_anim
	.ref	und_2_head_hit2_anim,und_4_head_hit2_anim
	.ref	und_2_body_hit_anim,und_4_body_hit_anim
	.ref	und_hitonground_anim

	.ref	und_2_butt_anim,und_4_butt_anim
	.ref	und_2_knee_anim,und_4_knee_anim
	.ref	und_4_bigboot_anim

	.ref	und_head_hit2_anim,und_head_hit_dizzy_anim
	.ref	und_2_stomp_anim,und_4_stomp_anim

	.ref	und_2_push_anim,und_4_push_anim
	.ref	und_4_losebal_anim

	.ref	und_4_grabfling_anim
	.ref	und_2_grabfling_anim

;	.ref	und_ocrun_anim
	.ref	und_fall_back_anim

;	.ref	und_summon_anim,und_summon2_anim
	.ref	und_getup_anim
;	.ref	und_4_graboh_anim
	.ref	und_heldoh_anim

	.ref	und_2_lbowdrop_anim,und_4_lbowdrop_anim
	.ref	und_flying_butt_drop_anim,und_tbukl_butt_drop_anim

	.ref	und_sliding_choke_anim
	.ref	und_tombstone_smash_anim
	.ref	und_neckbreaker_anim
	.ref	und_chokeslam_anim
	.ref	und_tombstone_anim
	.ref	und_neckbreaker_anim
	.ref	und_2_snapmirror_anim
	.ref	und_4_snapmirror_anim
	.ref	und_2_snapmirror2_anim
	.ref	und_4_snapmirror2_anim
	.ref	und_climb_down_anim,und_climb_up_anim
	.ref	und_spirit_push_anim
	.ref	und_spirit_pull_anim

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************

und_secret_moves

;These secret moves are triggered only after a move list seq has ended!  You
;can't hold on the last button press and have it trigger!

;Button held down moves need to be first entry
	.long	#button_hold
	.long	#grab_fling
	.long	#grab_toss
	.long	#neck_grab
	.long	#choke_slide
	.long	#tomb_smash
	.long	0

*****************************************************************************
*
* SPECIAL MOVE PROCESSES
*

 SUBR	und_smove_table

	.long	und_hdhold_neckbrk
	.long	und_hdhold_pile		;(tombstone)
	.long	und_spirit_pull
	.long	und_spirit_push
	.long	und_grab_toss_air
	.long	0

*******************************************************************************

#tomb_smash
	.word	B_SKICK,			J_ALL
	.word	J_TOWARD,		J_REAL_LR
	.word	J_TOWARD,		J_REAL_LR
	.word	8000h | 32 		;max
	.long	#scrt_tomb

#scrt_tomb
	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#out

	move	*a13(PLYRMODE),a0
	cmpi	MODE_ONTURNBKL,a0
	jrz	#out

	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	SETMODE	NORMAL

	movi	und_tombstone_smash_anim,a0
	calla	change_anim1a

	WRSND	W_TAKER,GRABHOLD_T1,GRABHOLD_T2

	rets

*******************************************************************************

#choke_slide
	.word	B_PUNCH,		J_ALL
	.word	J_TOWARD,		J_REAL_LR
	.word	J_DOWN_TOWARD,		J_REAL_LR
	.word	J_DOWN,			J_REAL_LR
	.word	8000h | 50 		;max	 
	.long	#scrt_choke

#scrt_choke
	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#out

	move	*a13(PLYRMODE),a0
	cmpi	MODE_ONTURNBKL,a0
	jrz	#out

;Don't do it when he is on ground
	calla	get_opp_plyrmode
	cmpi	MODE_ONGROUND,a0
	jrz	#out
	cmpi	MODE_DEAD,a0
	jrz	#out
	cmpi	MODE_HEADHELD,a0
	jrz	#out

	movi	und_sliding_choke_anim,a0
	calla	change_anim1a
	rets

*******************************************************************************

#grab_toss
	.word	B_PUNCH | J_AWAY,	J_REAL_LR | J_UP | J_DOWN
	.word	8000h | 10		;max
	.long	scrt_hiptoss

scrt_hiptoss
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
	cmpi	MODE_INAIR,a0
	jrz	#doit
	cmpi	MODE_INAIR2,a0
	jrz	#doit

	move	*a13(CLOSEST_DIST),a0
	cmpi	68h,a0
	jrgt	#out

#doit
 	FACE24	und,snapmirror_anim
	calla	change_anim1a

	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	SETMODE	NORMAL

;	WRSND	W_TAKER,GRABFLING_T1,GRABFLING_T2
	WRSND	W_TAKER,GRABHOLD_T1,GRABHOLD_T2

	rets

*******************************************************************************

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

	.ref	und_3_head_hold_anim
	movi	und_3_head_hold_anim,a0
	calla	change_anim1a
	rets

*******************************************************************************

#button_hold

	move	a13,a0
	calla	wres_get_but_val_up
	btst	PLAYER_PUNCH_BIT,a0
	jrz	#no_punch

	move	*a13(PLYRNUM),a0
	calla	get_punch_dtime
	cmpi	110,a0			;> min?
	jrlt	#no_punch

	callr	scrt_spirit
	setc
	rets

#no_punch
	clrc
	rets

scrt_spirit
	move	*a13(PLYRMODE),a0
	cmpi	MODE_HEADHELD,a0
	jrz	#rev

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#out

;Don't do it when he is on ground
	calla	get_opp_plyrmode
	cmpi	MODE_ONGROUND,a0
	jrz	#out
	cmpi	MODE_DEAD,a0
	jrz	#out

	move	*a13(PLYRMODE),a0
	cmpi	MODE_RUNNING,a0
	jrz	#leapbrk
	jruc	#break

#rev
	CALLA	DO_REVERSAL
	CALLA	DO_REVERSAL_MESS

;Make sure the reversal works!
	movk	10,a0
	move	a0,*a8(SAFE_TIME)

#break
	.ref	und_neckbreaker2_anim
	movi	und_neckbreaker2_anim,a0
	calla	change_anim1a

	WRSND	W_TAKER,GRABHOLD_T1,GRABHOLD_T2

	rets

#leapbrk
;Sliding neck breaker
	.ref	und_neckbreaker3_anim
	movi	und_neckbreaker3_anim,a0
	calla	change_anim1a

	WRSND	W_TAKER,GRABHOLD_T1,GRABHOLD_T2

	rets


*******************************************************************************

#grab_fling
	.word	B_SPUNCH | J_AWAY,	J_REAL_LR | J_UP | J_DOWN
	.word	8000h | 10		;max
	.long	scrt_grabfling

scrt_grabfling

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
	FACE24	und,snapmirror_anim
	calla	change_anim1a

	clr	a0
	move	a0,*a13(ATTACH_PROC),L
	SETMODE	NORMAL

	WRSND	W_TAKER,GRABHOLD_T1,GRABHOLD_T2
	rets

#nope
;Don't fling when he is on ground
	calla	get_opp_plyrmode
	cmpi	MODE_HEADHELD,a0
	jrz	#out
	cmpi	MODE_ONGROUND,a0
	jrz	#out
	cmpi	MODE_DEAD,a0
	jrz	#out

	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	SETMODE	NORMAL

	FACE24	und,grabfling_anim
	calla	change_anim1a

	WRSND	W_TAKER,GRABHOLD_T1,GRABHOLD_T2
#out
	rets

*******************************************************************************
#*
und_hdhold_neckbrk

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

	WAITSWITCH_DWN	J_UP,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_DOWN,0,#lp
	WAITSWITCH_DWN	J_DOWN,0,#lp
	WAITSWITCH_DWN	B_SKICK,J_DOWN_AWAY|J_DOWN_TOWARD,#lp

	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrz	#slam
	cmpi	MODE_HEADHELD,a0
	jrnz	#lp0

	PUSH	a13
	move	a8,a13
	CALLA	DO_REVERSAL
	CALLA	DO_REVERSAL_MESS
	PULL	a13

;Make sure the reversal works!
	movk	10,a0
	move	a0,*a8(SAFE_TIME)

	move	*a8(OBJ_ZPOS),a0,L
	addi	[5,0],a0
	move	a0,*a8(OBJ_ZPOS),L

#slam
	movi	und_neckbreaker_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEP	60

	jruc	#lp

*******************************************************************************
#*
und_hdhold_pile

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
	.ref	DO_REVERSAL
	.ref	DO_REVERSAL_MESS
	CALLA	DO_REVERSAL
	CALLA	DO_REVERSAL_MESS
	PULL	a13

;Make sure the reversal works!
	movk	10,a0
	move	a0,*a8(SAFE_TIME)

	move	*a8(OBJ_ZPOS),a0,L
	addi	[5,0],a0
	move	a0,*a8(OBJ_ZPOS),L

#slam
	movi	und_tombstone_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEP	60

	jruc	#lp

*******************************************************************************
#*
und_spirit_push

#TIMEOUT	.equ	60

#lp0
	SLEEPK	1
#lp
	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrz	#lp0
	cmpi	MODE_HEADHELD,a0
	jrz	#lp0

	clr	a11

;	WAITSWITCH_DWN	J_TOWARD,J_UP|J_DOWN,#lp
	WAITSWITCH_DWN	J_TOWARD,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_TOWARD,0,#lp
	WAITSWITCH_DWN	B_KICK,0,#lp

	move	*a8(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#lp0

	PUSH	a13
	move	a8,a13
	calla	get_opp_plyrmode
	PULL	a13
	cmpi	MODE_DEAD,a0
	jrz	#lp
	cmpi	MODE_ONGROUND,a0
	jrz	#lp

	movi	und_spirit_push_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEP	60

	jruc	#lp

*******************************************************************************
#*
und_spirit_pull

#TIMEOUT	.equ	60

#lp0
	SLEEPK	1
#lp
	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrz	#lp0
	cmpi	MODE_HEADHELD,a0
	jrz	#lp0

	clr	a11

;	WAITSWITCH_DWN	J_AWAY,J_UP|J_DOWN,#lp
	WAITSWITCH_DWN	J_AWAY,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_AWAY,0,#lp
	WAITSWITCH_DWN	B_KICK,0,#lp

	move	*a8(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#lp0

	PUSH	a13
	move	a8,a13
	calla	get_opp_plyrmode
	PULL	a13
	cmpi	MODE_DEAD,a0
	jrz	#lp
	cmpi	MODE_ONGROUND,a0
	jrz	#lp

	movi	und_spirit_pull_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEP	60

	jruc	#lp

*******************************************************************************
#*
und_grab_toss_air

#TIMEOUT	.equ	40

#lp0
	SLEEPK	1
#lp
	clr	a11

	WAITSWITCH_DWN	J_AWAY,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_AWAY,0,#lp
	WAITSWITCH_DWN	B_PUNCH,J_DOWN_AWAY|J_UP_AWAY,#lp

	move	*a8(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#lp

;Don't do it when he is on ground
	PUSH	a13
	move	a8,a13
	calla	get_opp_plyrmode
	PULL	a13
;Don't do it when he is on ground
	cmpi	MODE_ONGROUND,a0
	jrz	#lp
	cmpi	MODE_DEAD,a0
	jrz	#lp
	cmpi	MODE_INAIR,a0
	jrz	#doit2
	cmpi	MODE_INAIR2,a0
	jrz	#doit2

	move	*a8(CLOSEST_NUM),a0
	X32	a0
	addi	process_ptrs,a0
	move	*a0,a0,L
	move	*a0(ATTACK_TYPE),a0
	cmpi	AT_LEAPING,a0
	jrz	#doit2

	move	*a8(CLOSEST_DIST),a0
	cmpi	68h,a0
	jrgt	#lp

	FACE24	und,snapmirror_anim
	jruc	#cont

#doit2	FACE24	und,snapmirror2_anim
#cont	move	a0,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	WRSND	W_TAKER,GRABHOLD_T1,GRABHOLD_T2

	clr	a0
	move	a0,*a8(ATTACH_PROC),L

	SETMODE	NORMAL

	SLEEP	60

	jruc	#lp

*******************************************************************************
;;	WAITSWITCH_DWN	J_TOWARD,J_UP|J_DOWN,#lp
;;	WAITSWITCH_DWN	J_AWAY,J_UP|J_DOWN,#lp
;;	WAITSWITCH_DWN	J_TOWARD,J_UP|J_DOWN,#lp
;;	WAITSWITCH_DWN	B_SKICK,0,#lp
;;	WAITSWITCH_DWN	J_AWAY|J_DOWN,0,#lp
;;	WAITSWITCH_DWN	J_DOWN,0,#lp
;;	WAITSWITCH_DWN	J_TOWARD|J_DOWN,0,#lp
;;	WAITSWITCH_DWN	J_TOWARD,0,#lp
;;	WAITSWITCH_DWN	B_SKICK,0,#lp
;
;
;#lp
;	clr	a11
;	WAITSWITCH_DWN	J_UP,J_LEFT|J_RIGHT,#lp
;
;	movi	#TIMEOUT,a11
;	WAITSWITCH_DWN	J_DOWN,J_UP|J_LEFT|J_RIGHT,#lp
;
;	nop
;
;	WAITSWITCH_DWN	J_AWAY,J_UP|J_DOWN,#lp
;
;	nop
;
;	WAITSWITCH_DWN	J_TOWARD,J_UP|J_DOWN,#lp
;
;	nop
;
;	WAITSWITCH_DWN	B_SPUNCH,0,#lp
;
;	movi	und_sliding_choke_anim,a14
;	move	a14,*a8(SPECIAL_MOVE_ADDR),L
;
;	jruc	#lp


#*****************************************************************************

 SUBR	taker_ani_init

	clr	a0
	move	a0,*a13(ATTIMG_CUR_FRAME),L

	move	*a13(FACING_DIR),a0
	btst	PLAYER_RIGHT_BIT,a0
	jrnz	#p1
;Plyr 2
	movi	und_stand4_anim,a0
	calla	change_anim1a

	movi	und_torso4_anim,a0
	calla	change_anim2a

	PUSH	a10
	move	a13,a10
	.ref	do_taunt
	CREATE0	do_taunt
	PULL	a10

	rets

#p1
	movi	und_stand2_anim,a0
	calla	change_anim1a

	movi	und_torso2_anim,a0
	calla	change_anim2a

	rets


#*****************************************************************************
*
* UNDERTAKER CONTROL CODE
*
* a13 = * taker process

 SUBR	move_taker


;	movi	100h,a0			;temp fix!
;	move	a0,*a13(ANI_SPEED)

	movi	und_secret_moves,a11	SANS
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
	.long	mode_choking		;25


#*****************************************************************************

mode_normal

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_interrupt

;Perhaps we need to interrupt any sequence when a wrstler has won?

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
	move	*a13(NEW_FACING_DIR),a0
	btst	MOVE_DOWN_BIT,a0
	jrz	#reg

	move	*a13(CLOSEST_ZDIST),a0
	cmpi	40h,a0
	jrge	#reg
	
	move	*a13(CLOSEST_XDIST),a0
	cmpi	35,a0
	jrge	#reg

	movi	und_4_pin2_anim,a0
	calla	change_anim1a

	rets
#reg
	FACE24	und,pin_anim
	calla	change_anim1a

	rets

#opp_notgnd
#opp_not_dead
	move	*a13(IMMOBILIZE_TIME),a0
	jrnz	#no_climb

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
	.long	#punchkick				;9
	.long	#z,#z,#kick,#z,#z,#z			;10-15
	.long	#super_kick				;16
	.long	#z,#z,#z,#graboh,#z,#z,#z		;17-23
	.long	#kick,#z,#z,#z,#z,#z,#z,#z		;24-31


************
#z


	rets

#graboh		;8

	rets

************
#punch		;1
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal	<  50   92	headbutt
* dizzy			"		"
* normal	>		normal punch
* dizzy			"		"
*
* onground	< 120  120	elbow drop
* onground	>		normal punch
*
* running			hiptoss
* bouncing			nothing
*
* onturnbkl	<  60   96	yank down
* onturnbkl	>		normal punch
* climbturnbkl			normal punch
*
	JJXM_INIT
	JJXM	NORMAL,		 75, 45,#punch_hdbutt,#punch_punch
	JJXM	RUNNING,	 75, 45,#punch_hdbutt,#punch_punch
	JJXM	BLOCK,		 75, 45,#punch_hdbutt,#punch_punch
	JJXM	DIZZY,		 75, 45,#punch_hdbutt,#punch_punch
	JJXM	ONGROUND,	120,120,#punch_lbowdrop,#punch_punch
	JJXM	BOUNCING,	 75, 45,#punch_hdbutt,#punch_punch
;	JJXM	BOUNCING,		#punch_rets
	JJXM	ONTURNBKL,	 75, 96,#punch_yankdown,#punch_punch
	JJXM	CLIMBTURNBKL,		#punch_punch
	JJXM	INAIR,		 75, 45,#punch_hdbutt,#punch_punch
	JJXM	ATTACHED,	 75, 45,#punch_hdbutt,#punch_punch
	JJXM	DEAD,		120,120,#punch_lbowdrop,#punch_punch
	JJXM	OPPOVERHEAD,	 75, 45,#punch_hdbutt,#punch_punch
	JJXM	WAITANIM,	 75, 45,#punch_hdbutt,#punch_punch
	JJXM	GRAPPLE,	 75, 45,#punch_hdbutt,#punch_punch
	JJXM	MASTER,		 75, 45,#punch_hdbutt,#punch_punch
	JJXM	SLAVE,		 75, 45,#punch_hdbutt,#punch_punch
	JJXM	HEADHOLD,	 75, 45,#punch_hdbutt,#punch_punch
	JJXM	HEADHELD,	 75, 45,#punch_hdbutt,#punch_punch
	JJXM	PUPPET,		 75, 45,#punch_hdbutt,#punch_punch
	JJXM	INAIR2,		 75, 45,#punch_hdbutt,#punch_punch
	JJXM_END

#punch_rets
	rets

*****
#punch_punch
std_punch

	FACE24	und,punch_anim
;	movi	und_spirit_push_anim,a0
	calla	change_anim1a

	WRSND	W_TAKER,PUNCH_T1,PUNCH_T2

	rets

*****
#punch_hdbutt

	FACE24	und,butt_anim
	calla	change_anim1a

	WRSND	W_TAKER,HDBUTT_T1,HDBUTT_T2

	rets

*****
#punch_lbowdrop

	FACE24	und,lbowdrop_anim
	calla	change_anim1a

	WRSND	W_TAKER,LBOWDROP_T1,LBOWDROP_T2

	rets

*****
#punch_yankdown
std_yankdown

	move	*a13(INRING),a0
;	jrnz	std_punch		;outside of ring
;
	rets

*****
#punch_hiptoss
;std_hiptoss

	rets


************
#block		;2

std_block
	FACE24	und,block_anim
;	movi	und_spirit_pull_anim,a0
	calla	change_anim1

	rets
       	
;	.if	0
;
;;TEMP!!
;	movi	und_2_stomp_anim,a0
;	move	*a13(FACING_DIR),a14
;	btst	MOVE_UP_BIT,a14
;	jrnz	#2_jmp
;	movi	und_4_stomp_anim,a0
;#2_jmp
;
;	movi	und_summon_anim,a0
;;	movi	und_summon2_anim,a0
;;	movi	und_4_lbowdrop_anim,a0
;
;	movi	und_neckbreaker_anim,a0
;	calla	change_anim1a
;
;	rets
;
;	.endif

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
	JJXM	NORMAL,		 95, 35,#spunch_special,#spunch_slap	;0
	JJXM	RUNNING,	 95, 35,#spunch_special,#spunch_slap	;1
	JJXM	INAIR,		 95, 35,#spunch_special,#spunch_slap	;2
	JJXM	ATTACHED,	 95, 35,#spunch_special,#spunch_slap	;3
	JJXM	ONGROUND,	 136,112,#spunch_lbowdrop,std_punch	;4
	JJXM	BOUNCING,	 95, 35,#spunch_special,#spunch_slap	;1
;	JJXM	BOUNCING,		#spunch_rets			;5
	JJXM	ONTURNBKL,	 	#spunch_slap			;6
	JJXM	BLOCK,		 95, 35,#spunch_special,#spunch_slap	;7
	JJXM	DIZZY,		 95, 35,#spunch_special,#spunch_slap	;8
	JJXM	DEAD,		 96,112,#spunch_lbowdrop,std_punch	;9
	JJXM	OPPOVERHEAD,	 95, 35,#spunch_special,#spunch_slap	;10
	JJXM	CLIMBTURNBKL,		std_punch			;11
	JJXM	WAITANIM,	 95, 35,#spunch_special,#spunch_slap	;12
	JJXM	GRAPPLE,	 95, 35,#spunch_special,#spunch_slap	;13
	JJXM	MASTER,		 95, 35,#spunch_special,#spunch_slap	;14
	JJXM	SLAVE, 		 95, 35,#spunch_special,#spunch_slap	;15
	JJXM	HEADHOLD,	 95, 35,#spunch_special,#spunch_slap	;16
	JJXM	HEADHELD,		do_pile				;19
	JJXM	PUPPET,		 95, 35,#spunch_special,#spunch_slap	;20
	JJXM	INAIR2,		 95, 35,#spunch_special,#spunch_slap	;21
	JJXM_END

#spunch_rets
	rets

#spunch_slap
;jumping punch attack
	.ref	und_2_slap_anim
	.ref	und_4_slap_anim
	FACE24	und,slap_anim
	calla	change_anim1a

	WRSND	W_TAKER,GRABHOLD_T1,GRABHOLD_T2

	rets

*****
#spunch_special
;If stick is toward opponent, then do quick head hold
	move	a13,a0
	calla	wres_get_stick_val_cur
	btst	MOVE_DOWN_BIT,a0
	jrnz	#ck_up
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrz	#cont

	move	*a13(CLOSEST_XDIST),a1
	cmpi	70,a1
;	jrgt	std_punch
	jrgt	#spunch_slap
	jruc	#hdbutt
#cont
	.ref	und_3_head_hold2_anim
	movi	und_3_head_hold2_anim,a0
	calla	change_anim1a

	WRSND	W_TAKER,GRABHOLD_T1,GRABHOLD_T2
	rets

#ck_up
;Check for uppercut
	.ref	und_2_uppercut_anim
	.ref	und_4_uppercut_anim
	FACE24	und,uppercut_anim
	calla	change_anim1

	WRSND	W_TAKER,HDBUTT_T1,HDBUTT_T2
	rets

#hdbutt

	FACE24	und,butt_anim
	calla	change_anim1

	WRSND	W_TAKER,HDBUTT_T1,HDBUTT_T2

	rets

*****
#spunch_lbowdrop
	.ref	und_2_hair_pickup_anim
	.ref	und_4_hair_pickup_anim
;If near opponents head, and facing down, do the hair grab!
;Allow hair grab from below!

;	move	*a13(FACING_DIR),a14
;	btst	MOVE_DOWN_BIT,a14
;	jrz	#no

	move	*a13(CLOSEST_NUM),a14
	X32	a14

	.ref	process_ptrs

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

	FACE24	und,hair_pickup_anim
	calla	change_anim1
	WRSND	W_TAKER,LBOWDROP_T1,LBOWDROP_T2
	rets

#no	FACE24	und,lbowdrop_anim
	calla	change_anim1
	WRSND	W_TAKER,LBOWDROP_T1,LBOWDROP_T2
	rets


************
#kick		;8
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal	<  50   92	knee
* dizzy			"		"
* normal	>		normal kick
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
	JJXM	NORMAL,		 65, 92,#kick_knee,#kick_kick
	JJXM	RUNNING,	 120,92,#kick_kick,#kick_flyingkick	;1
	JJXM	INAIR,		 65, 92,#kick_knee,#kick_kick
	JJXM	ATTACHED,	 65, 92,#kick_knee,#kick_kick
	JJXM	ONGROUND,	120,120,#kick_stomp,#kick_kick
	JJXM	BOUNCING,	 120,92,#kick_kick,#kick_flyingkick	;5
	JJXM	ONTURNBKL,	 	#kick_kick
	JJXM	BLOCK,		 65, 92,#kick_knee,#kick_kick
	JJXM	DIZZY,		 65, 92,#kick_knee,#kick_kick
	JJXM	DEAD,		 120,120,#kick_stomp,#kick_kick
	JJXM	OPPOVERHEAD,	 65, 92,#kick_knee,#kick_kick
	JJXM	CLIMBTURNBKL,	 	#kick_kick
	JJXM	WAITANIM,   	 65, 92,#kick_knee,#kick_kick
	JJXM	GRAPPLE,    	 65, 92,#kick_knee,#kick_kick
	JJXM	MASTER,		 65, 92,#kick_knee,#kick_kick
	JJXM	SLAVE,	    	 65, 92,#kick_knee,#kick_kick
	JJXM	HEADHOLD,	 65, 92,#kick_knee,#kick_kick
	JJXM	HEADHELD,	 65, 92,#kick_knee,#kick_kick
	JJXM	PUPPET,		 65, 92,#kick_knee,#kick_kick
	JJXM	INAIR2,		 65, 92,#kick_knee,#kick_kick
	JJXM_END

*****
#kick_kick
std_kick

	FACE24	und,kick_anim
	calla	change_anim1a

	WRSND	W_TAKER,KICK_T1,KICK_T2

	rets

*****
#kick_flyingkick

	movi	und_flying_kick_anim,a0
	calla	change_anim1a

	SETMODE	INAIR

	WRSND	W_TAKER,FLYKICK_T1,FLYKICK_T2

	rets

*****
#kick_knee

	FACE24	und,knee_anim
	calla	change_anim1a

	WRSND	W_TAKER,KICK_T1,KICK_T2

	rets

*****
#kick_stomp
attack_stomp

	FACE24	und,stomp_anim
	calla	change_anim1a

	WRSND	W_TAKER,KICK_T1,KICK_T2

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
	JJXM	NORMAL,		 60, 60,#skick_special,#skick_kick	;0
	JJXM	RUNNING,	 	#skick_bigboot			;1
	JJXM	INAIR,		 60, 60,#skick_special,#skick_kick	;2
	JJXM	ATTACHED,	 60, 60,#skick_special,#skick_kick	;3
	JJXM	ONGROUND,	144,160,#skick_stomp,std_kick		;4
	JJXM	BOUNCING,	 	#skick_bigboot			;5
	JJXM	ONTURNBKL,	 60, 96,#skick_kick,std_kick		;6
	JJXM	BLOCK,		 60, 60,#skick_special,#skick_kick	;7
	JJXM	DIZZY,		 60, 60,#skick_special,#skick_kick	;8
	JJXM	DEAD,		144,160,#skick_stomp,std_kick		;9
	JJXM	OPPOVERHEAD,	 60, 60,#skick_special,#skick_kick	;10
	JJXM	CLIMBTURNBKL,	 60, 96,#skick_kick,std_kick		;11
	JJXM	WAITANIM,	 60, 62,#skick_special,#skick_kick	;12
	JJXM	GRAPPLE,	 60, 62,#skick_special,#skick_kick	;13
	JJXM	MASTER,		 60, 62,#skick_special,#skick_kick	;14
	JJXM	SLAVE, 		 60, 62,#skick_special,#skick_kick	;15
	JJXM	HEADHOLD,	 60, 62,#skick_special,#skick_kick	;16
	JJXM	HEADHELD,	 	std_kick
	JJXM	PUPPET,		 60, 62,#skick_special,#skick_kick	;20
	JJXM	INAIR2,		 60, 60,#skick_special,#skick_kick	;21
	JJXM_END

*****
#skick_kick
	.ref	und_2_super_kick_anim
	.ref	und_4_super_kick_anim
	FACE24	und,super_kick_anim
	calla	change_anim1a

	WRSND	W_DOINK,FLYKICK_T1,FLYKICK_T2
	rets


*****
#skick_special
;If stick is toward opponent, then do quick punches
	move	a13,a0
	calla	wres_get_stick_val_cur
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrz	#cont2

	FACE24	und,knee_anim
	calla	change_anim1a

	WRSND	W_TAKER,KICK_T1,KICK_T2

	rets

#cont2
	.ref	und_4_knee_fall_anim
	movi	und_4_knee_fall_anim,a0
	calla	change_anim1

	WRSND	W_TAKER,GRABHOLD_T1,GRABHOLD_T2
	rets

#skick_stomp

	FACE24	und,stomp_anim
	calla	change_anim1a

	WRSND	W_TAKER,KICK_T1,KICK_T2

	rets

*****
#skick_bigboot	;we can probably get away with just a #4 big boot

	movi	und_4_bigboot_anim,a0		;*****
	calla	change_anim1a

	WRSND	W_TAKER,FLYKICK_T1,FLYKICK_T2

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
* onground	< 176 176	butt-drop
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
	JJXM	DEAD,			attack_bellyflop
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
	clr	a0
	move	a0,*a13(RUN_TIME)

	SETMODE	NORMAL

	move	*a13(CLOSEST_XDIST),a1
	cmpi	70,a1
	jrlt	#hdbutt

	FACE24	und,slap_anim
	calla	change_anim1a

	WRSND	W_TAKER,GRABHOLD_T1,GRABHOLD_T2

	rets

#hdbutt

	FACE24	und,butt_anim
	calla	change_anim1

	WRSND	W_TAKER,HDBUTT_T1,HDBUTT_T2

	rets

*****
#punch_bellyflop
attack_bellyflop

	movi	und_flying_butt_drop_anim,a0
	calla	change_anim1a

	WRSND	W_TAKER,FLYKICK_T1,FLYKICK_T2

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
* onground	< 176 176	butt-drop
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
	JJXM	ONGROUND,		attack_bellyflop
	JJXM	RUNNING,		#kick_flyingkick
	JJXM	BOUNCING,		#kick_flyingkick
	JJXM	ONTURNBKL,		#kick_flyingkick
	JJXM	CLIMBTURNBKL,		#kick_flyingkick
	JJXM	INAIR,			#kick_flyingkick
	JJXM	ATTACHED,		#kick_flyingkick
	JJXM	DEAD,			attack_bellyflop
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

	.ref	und_flying_kick_anim

	movi	und_flying_kick_anim,a0
	calla	change_anim1a

	SETMODE	INAIR

	WRSND	W_TAKER,FLYKICK_T1,FLYKICK_T2

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

	movi	und_run2_anim,a0
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
	cmpi	und_climb_up_anim,a14
	jrne	#no_climbdown

	movi	und_climb_down_anim,a0
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

	movi	und_tbukl_butt_drop_anim,a0
	calla	change_anim1a

	WRSND	W_TAKER,FLYKICK_T1,FLYKICK_T2

	rets

#*****************************************************************************
* blocking

mode_block	;7
	;check unint
;	move	*a13(ANIMODE),a0
;	btst	MODE_UNINT_BIT,a0
;	jrnz	#no_interrupt

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

	FACE24  und,push_anim
	calla	change_anim1a

	WRSND	W_TAKER,PUSH_T1,PUSH_T2

	rets


#*****************************************************************************
* taker with zero health

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
	.ref	und_4_knee_butts_anim
	movi	und_4_knee_butts_anim,a0
	calla	change_anim1a
	rets

#tag
;	movi	dnk_uppercut_to_head_anim,a0
	movi	und_4_knee_anim,a0
	calla	change_anim1a
	rets

************
#super_punch	;4
do_pile
;This flag is only set if doink has done repeated uppercuts!
	move	*a13(USR_VAR2),a0
	jrz	#upper
;Announce combo move here!

	movi	und_tombstone_anim,a0
	calla	change_anim1a
	rets

#upper
	move	a13,a0
	calla	wres_get_stick_val_cur

	btst	PLAYER_DOWN_BIT,a0
	jrz	#z

	FACE24	und,uppercut_anim
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
	movi	und_4_knee_anim,a0
	calla	change_anim1a
	rets

#knee
;	movi	dnk_3_knee_to_head_anim,a0
	movi	und_4_knee_anim,a0
	calla	change_anim1a
	rets

#super_kick	;16
;If stick is toward opponent, then do quick knees
;	move	a13,a0
;	calla	wres_get_stick_val_cur
;	move	*a13(NEW_FACING_DIR),a1
;	andi	0ch,a1
;	cmp	a0,a1
;	jrnz	#kick
;
;;Quick knees
;;	movi	dnk_3_knees_to_head_anim,a0
;	movi	und_4_knee_anim,a0
;	calla	change_anim1a

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

	.ref	und_3_head_held_stand_anim
	movi	und_3_head_held_stand_anim,a0
	calla	change_anim1a

#no_luck
	rets


#*****************************************************************************
mode_puppet	;20
	rets


#*****************************************************************************
mode_chokehold	;24

	move	*a13(ATTACH_PROC),a0,L
	jrz	#lost_him
	move	*a0(ATTACH_PROC),a0,L
	cmp	a13,a0
	jrne	#lost_him

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
#z		;0
#block		;2
	rets

************
#punch		;1
	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	SETMODE	NORMAL

	move	a13,a0
	calla	wres_get_stick_val_cur
	btst	MOVE_UP_BIT,a0
	jrz	#reg

	movi	und_4_knee_butts_anim,a0
	calla	change_anim1a
	WRSND	W_TAKER,HDBUTT_T1,HDBUTT_T2

	rets
#reg
	movi	und_2_butt_anim,a0
	calla	change_anim1a
	WRSND	W_TAKER,HDBUTT_T1,HDBUTT_T2

	rets
#super_punch	;4
;Check for uppercut
	move	a13,a0
	calla	wres_get_stick_val_cur
	btst	MOVE_DOWN_BIT,a0
	jrz	#punch

	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	SETMODE	NORMAL

	.ref	und_2_uppercut_anim
	.ref	und_4_uppercut_anim
	FACE24	und,uppercut_anim
	calla	change_anim1

	WRSND	W_TAKER,HDBUTT_T1,HDBUTT_T2
	rets

#super_kick	;16
;If stick is toward opponent, then do quick punches
	move	a13,a0
	calla	wres_get_stick_val_cur
	btst	PLAYER_DOWN_BIT,a0
	jrnz	#tag

#kick		;8
	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	SETMODE	NORMAL

	movi	und_2_knee_anim,a0
	calla	change_anim1a
	rets

#tag
	SETMODE	NORMAL

	movi	und_chokeslam_anim,a0
	calla	change_anim1a

	WRSND	W_TAKER,KICK_T1,KICK_T2

	rets

************

#lost_him
	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	SETMODE	NORMAL
	movi	MODE_NORMAL,a0
	move	a0,*a13(ANIMODE)

	rets


#*****************************************************************************
 SUBR	mode_choking	;25

	move	*a13(ATTACH_PROC),a0,L
	jrz	#fall_out
	move	*a0(ATTACH_PROC),a0,L
	cmp	a13,a0
	jrne	#fall_out

	move	*a13(GETUP_TIME),a0
	jrz	#fall_out
	rets


#fall_out
	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	SETMODE	NORMAL
	movi	MODE_NORMAL,a0
	move	a0,*a13(ANIMODE)

	rets


#*****************************************************************************

#VEL	equ	30000h
#DVEL	equ	21f0eh


 SUBR und_velocity_table

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

 SUBR und_rotate_anims_table
; old = up right
	.long	und_stand2_anim		;new = up right
	.long	und_2_to_4_turn_anim	;    = down right
	.long	und_2_to_6_turn_anim	;    = down left
	.long	und_2_to_8_turn_anim	;    = up left

; old = down right
	.long	und_4_to_2_turn_anim	;new = up right
	.long	und_stand4_anim		;    = down right
	.long	und_4_to_6_turn_anim	;    = down left
	.long	und_4_to_8_turn_anim	;    = up left

; old = down left
	.long	und_6_to_2_turn_anim	;new = up right
	.long	und_6_to_4_turn_anim	;    = down right
	.long	und_stand6_anim		;    = down left
	.long	und_6_to_8_turn_anim	;    = up left

; old = up left
	.long	und_8_to_2_turn_anim	;new = up right
	.long	und_8_to_4_turn_anim	;    = down right
	.long	und_8_to_6_turn_anim	;    = down left
	.long	und_stand8_anim		;    = up left


 SUBR und_leg_anims_table
;  MOVE
;(#1 - UP)				FACING
	.long	und_walk1_f2_anim	;1 (UP)
	.long	und_walk1_f2_anim	;2 (UP_RIGHT)
	.long	und_walk1_f4_anim	;3 (RIGHT)
	.long	und_walk1_f4_anim	;4 (DOWN_RIGHT)
	.long	und_walk1_f4_anim	;5 (DOWN)
	.long	und_walk1_f4_anim	;6 (DOWN_LEFT)
	.long	und_walk1_f2_anim	;7 (LEFT)
	.long	und_walk1_f2_anim	;8 (UP-LEFT)

;(#2 - UP-RIGHT)
	.long	und_walk2_f2_anim	;1 (UP)
	.long	und_walk2_f2_anim	;2 (UP_RIGHT)
	.long	und_walk2_f2_anim	;3 (RIGHT)
	.long	und_walk2_f4_anim	;4 (DOWN_RIGHT)
	.long	und_walk8_f4_anim	;5 (DOWN)
	.long	und_walk8_f4_anim	;6 (DOWN_LEFT)
	.long	und_walk4_f2_anim	;7 (LEFT)
	.long	und_walk4_f2_anim	;8 (UP-LEFT)

;(#3 - RIGHT)
	.long	und_walk2_f2_anim	;1 (UP)
	.long	und_walk2_f2_anim	;2 (UP_RIGHT)
	.long	und_walk2_f2_anim	;3 (RIGHT)
	.long	und_walk4_f4_anim	;4 (DOWN_RIGHT)
	.long	und_walk4_f4_anim	;5 (DOWN)
	.long	und_walk8_f4_anim	;6 (DOWN_LEFT)
	.long	und_walk6_f2_anim	;7 (LEFT)
	.long	und_walk6_f2_anim	;8 (UP-LEFT)


;(#4 - DOWN-RIGHT)
	.long	und_walk2_f2_anim	;1 (UP)
	.long	und_walk8_f2_anim	;2 (UP_RIGHT)
	.long	und_walk4_f4_anim	;3 (RIGHT)
	.long	und_walk4_f4_anim	;4 (DOWN_RIGHT)
	.long	und_walk2_f4_anim	;5 (DOWN)
	.long	und_walk6_f4_anim	;6 (DOWN_LEFT)
	.long	und_walk2_f2_anim	;7 (LEFT)
	.long	und_walk6_f2_anim	;8 (UP-LEFT)

;(#5 - DOWN)
	.long	und_walk5_f2_anim	;1 (UP)
	.long	und_walk5_f2_anim	;2 (UP_RIGHT)
	.long	und_walk5_f4_anim	;3 (RIGHT)
	.long	und_walk5_f4_anim	;4 (DOWN_RIGHT)
	.long	und_walk5_f4_anim	;5 (DOWN)
	.long	und_walk5_f4_anim	;6 (DOWN_LEFT)
	.long	und_walk5_f2_anim	;7 (LEFT)
	.long	und_walk5_f2_anim	;8 (UP-LEFT)

;(#6 - DOWN-LEFT)
	.long	und_walk2_f2_anim	;1 (UP)
	.long	und_walk6_f2_anim	;2 (UP_RIGHT)
	.long	und_walk2_f2_anim	;3 (RIGHT)
	.long	und_walk6_f4_anim	;4 (DOWN_RIGHT)
	.long	und_walk2_f4_anim	;5 (DOWN)
	.long	und_walk4_f4_anim	;6 (DOWN_LEFT)
	.long	und_walk2_f2_anim	;7 (LEFT)
	.long	und_walk8_f2_anim	;8 (UP-LEFT)

;(#7 - LEFT)
	.long	und_walk2_f2_anim	;1 (UP)
	.long	und_walk6_f2_anim	;2 (UP_RIGHT)
	.long	und_walk6_f2_anim	;3 (RIGHT)
	.long	und_walk8_f4_anim	;4 (DOWN_RIGHT)
	.long	und_walk4_f4_anim	;5 (DOWN)
	.long	und_walk4_f4_anim	;6 (DOWN_LEFT)
	.long	und_walk2_f2_anim	;7 (LEFT)
	.long	und_walk2_f2_anim	;8 (UP-LEFT)

;(#8 - UP-LEFT)
	.long	und_walk2_f2_anim	;1 (UP)
	.long	und_walk4_f2_anim	;2 (UP_RIGHT)
	.long	und_walk6_f2_anim	;3 (RIGHT)
	.long	und_walk8_f4_anim	;4 (DOWN_RIGHT)
	.long	und_walk6_f4_anim	;5 (DOWN)
	.long	und_walk2_f4_anim	;6 (DOWN_LEFT)
	.long	und_walk2_f2_anim	;7 (LEFT)
	.long	und_walk2_f2_anim	;8 (UP-LEFT)


 SUBR und_torso_anims_table
; old = up right
	.long	und_torso2_anim		;new = up right
	.long	und_2_to_4_turn2_anim	;    = down right
	.long	und_2_to_6_turn2_anim	;    = down left
	.long	und_2_to_8_turn2_anim	;    = up left

; old = down right
	.long	und_4_to_2_turn2_anim	;new = up right
	.long	und_torso4_anim		;    = down right
	.long	und_4_to_6_turn2_anim	;    = down left
	.long	und_4_to_8_turn2_anim	;    = up left

; old = down left
	.long	und_6_to_2_turn2_anim	;new = up right
	.long	und_6_to_4_turn2_anim	;    = down right
	.long	und_torso6_anim		;    = down left
	.long	und_6_to_8_turn2_anim	;    = up left

; old = up left
	.long	und_8_to_2_turn2_anim	;new = up right
	.long	und_8_to_4_turn2_anim	;    = down right
	.long	und_8_to_6_turn2_anim	;    = down left
	.long	und_torso8_anim		;    = up left


******************************************************************************

	.end
