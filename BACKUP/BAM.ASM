;Add smoke whisps
;fire moves
;pain grunts, etc
;put in opponent running flykick
;make flykick not miss on bounce!
;sound at razor hand clap at pin

**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		5/17/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"bam.asm"
	.title	"Bam Bam Bigelo specific game code"
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

	.ref	wres_get_but_val_up,wres_get_but_val_down
	.ref	wres_get_stick_val_cur
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
	.ref	JUMP_ROPES,ADD_IF_SILENT

	;from WRESTLE.ASM
	.ref	lineup_grapple
;	.ref	break_lockup
	.REF	DO_REVERSAL
	.REF	DO_REVERSAL_MESS

******************************************************************************
* ANIMATION SEQUENCES

	.ref	wres_slave_anim
	.ref	bam_zip_anim
	.ref	start_run_anim

	.ref	bam_stand2_anim,bam_stand8_anim
	.ref	bam_stand4_anim,bam_stand6_anim
	.ref	bam_torso2_anim,bam_torso8_anim
	.ref	bam_torso4_anim,bam_torso6_anim
	.ref	bam_pogo_anim
	.ref	bam_3_hiptoss_anim

	.ref	bam_2_to_4_turn_anim,bam_8_to_6_turn_anim	;stand
	.ref	bam_4_to_2_turn_anim,bam_6_to_8_turn_anim
	.ref	bam_4_to_6_turn_anim,bam_6_to_4_turn_anim
	.ref	bam_2_to_8_turn_anim,bam_8_to_2_turn_anim
	.ref	bam_4_to_8_turn_anim,bam_6_to_2_turn_anim
	.ref	bam_2_to_6_turn_anim,bam_8_to_4_turn_anim

	.ref	bam_2_to_4_turn2_anim,bam_8_to_6_turn2_anim	;torso
	.ref	bam_4_to_2_turn2_anim,bam_6_to_8_turn2_anim
	.ref	bam_4_to_6_turn2_anim,bam_6_to_4_turn2_anim
	.ref	bam_2_to_8_turn2_anim,bam_8_to_2_turn2_anim
	.ref	bam_4_to_8_turn2_anim,bam_6_to_2_turn2_anim
	.ref	bam_2_to_6_turn2_anim,bam_8_to_4_turn2_anim

	.ref	bam_walk1_f2_anim,bam_walk2_f2_anim,bam_walk4_f2_anim
	.ref	bam_walk5_f2_anim,bam_walk6_f2_anim,bam_walk8_f2_anim

	.ref	bam_walk1_f4_anim,bam_walk2_f4_anim,bam_walk4_f4_anim
	.ref	bam_walk5_f4_anim,bam_walk6_f4_anim,bam_walk8_f4_anim

	.ref	bam_4_fpunch_anim
	.ref	bam_2_fpunch_anim
;	.ref	bam_2_lockup_anim,bam_4_lockup_anim

	.ref	bam_run2_anim

	.ref	bam_2_head_hit_anim,bam_4_head_hit_anim
	.ref	bam_2_head_hit2_anim,bam_4_head_hit2_anim
	.ref	bam_2_body_hit_anim,bam_4_body_hit_anim

	.ref	bam_2_punch_anim,bam_4_punch_anim
	.ref	bam_2_kick_anim,bam_4_kick_anim
	.ref	bam_flying_kick_anim

	.ref	bam_2_body_hit_anim,bam_4_body_hit_anim
	.ref	bam_hitonground_anim

	.ref	bam_2_butt_anim,bam_4_butt_anim
	.ref	bam_2_knee_anim,bam_4_knee_anim
	.ref	bam_4_bigboot_anim

	.ref	bam_head_hit2_anim,bam_head_hit_dizzy_anim
	.ref	bam_2_stomp_anim,bam_4_stomp_anim

	.ref	bam_2_push_anim,bam_4_push_anim
	.ref	bam_4_losebal_anim

	.ref	bam_2_grabfling_anim
	.ref	bam_4_grabfling_anim

	.ref	bam_fall_back_anim

	.ref	bam_2_faceup_getup_anim
	.ref	bam_4_faceup_getup_anim

	.ref	bam_2_lbowdrop_anim,bam_4_lbowdrop_anim

	.ref	bam_4_jumpkick_anim

;	.ref	bam_running_headbutt
	.ref	bam_3_pile_driver_anim

	.ref	bam_4_graboh_anim,bam_heldoh_anim
	.ref	bam_2_graboh_anim
	.ref	bam_holdoh_anim
	.ref	bam_stndholdoh_anim

	.ref	bam_backbreaker_anim

	.ref	mode_inair2
	.ref	wres_get_but_val_cur
	.ref	bam_2_pin_anim
	.ref	bam_4_pin_anim

	.ref	bam_3_butt_drop_anim

	.ref	bam_climb_up_anim,bam_climb_down_anim,bam_bellyflop_anim

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************

bam_secret_moves
;Button held down moves need to be first entry
	.long	#firepnch	;must have this one

	.long	#neck_grab
	.long	#grab_fling
	.long	#grab_toss
	.long	#flykick
	.long	0

******************************************************************************
*
* SPECIAL MOVE PROCESSES - Secret moves
*
;a8=process of wrestler

 SUBR	bam_smove_table
	.long	bam_graboh
	.long	bam_hdhold_pile
	.long	bam_hdhold_pogo
	.long	bam_hdhold_pogo2
	.long	0

	.ref	wres_get_stick_rel_new

*******************************************************************************

#flykick
	.word	B_SKICK,		J_ALL
	.word	J_TOWARD,		J_REAL_LR | J_UP | J_DOWN
	.word	J_TOWARD,		J_REAL_LR | J_UP | J_DOWN
	.word	8000h | 32		;max
	.long	#scrt_flykick

#scrt_flykick
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
	cmpi	MODE_ATTACHED,a0
	jrz	#out

	movi	bam_4_jumpkick_anim,a0
	calla	change_anim1a

	WRSND	W_BAMBAM,FLYKICK_T1,FLYKICK_T2

	rets

*******************************************************************************

#neck_grab
	.word	B_SPUNCH,		J_ALL
	.word	J_TOWARD,		J_REAL_LR | J_UP | J_DOWN
	.word	J_TOWARD,		J_REAL_LR | J_UP | J_DOWN
	.word	8000h | 32		;max
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
;Mode held overhead!
	cmpi	MODE_ATTACHED,a0
	jrz	#out

	.ref	bam_3_head_hold_anim
	movi	bam_3_head_hold_anim,a0
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

	move	*a13(CLOSEST_DIST),a0
	cmpi	80h,a0
	jrgt	#out

	movi	bam_3_hiptoss_anim,a0
	calla	change_anim1a

	WRSND	W_BAMBAM,HIPTOSS_T1,HIPTOSS_T2

	rets

*******************************************************************************

#grab_fling
	.word	B_SPUNCH | J_AWAY,	J_REAL_LR | J_UP | J_DOWN
	.word	8000h | 10		;max
	.long	#scrt_grabfling

#scrt_grabfling

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
	movi	bam_3_hiptoss_anim,a0
	calla	change_anim1a

	WRSND	W_BAMBAM,HIPTOSS_T1,HIPTOSS_T2

	rets
#nope
;Don't fling when he is on ground
	calla	get_opp_plyrmode
	cmpi	MODE_DEAD,a0
	jrz	#out
	cmpi	MODE_HEADHELD,a0
	jrz	#out
	cmpi	MODE_ONGROUND,a0
	jrz	#out
;Mode held overhead!
	cmpi	MODE_ATTACHED,a0
	jrz	#out

	FACE24	bam,grabfling_anim
	calla	change_anim1a

	WRSND	W_BAMBAM,GRABFLING_T1,GRABFLING_T2

	rets


*******************************************************************************

#firepnch

	move	a13,a0
	calla	wres_get_but_val_up
	btst	PLAYER_SPUNCH_BIT,a0
	jrz	#no_punch

	move	*a13(PLYRNUM),a0
	.ref	get_powerp_dtime
	calla	get_powerp_dtime
	cmpi	85,a0			;> min?
	jrlt	#no_punch
;	cmpi	100+60,a0		;< max?
;	jrgt	#no_punch

	callr	#scrt_firepnch
	setc
	rets

#no_punch
	clrc
	rets


#scrt_firepnch

	move	*a13(PLYRMODE),a0
	cmpi	MODE_HEADHELD,a0
	jrz	#ok

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#out

;Don't do it when he is on ground
	calla	get_opp_plyrmode
;	cmpi	MODE_ONGROUND,a0
;	jrz	#out
	cmpi	MODE_DEAD,a0
	jrz	#out
;	cmpi	MODE_HEADHELD,a0
;	jrz	#out
;Mode held overhead!
	cmpi	MODE_ATTACHED,a0
	jrz	#out

#ok
	FACE24	bam,fpunch_anim
	calla	change_anim1a
#out
	rets

#*****************************************************************************

bam_hdhold_pogo

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

	CALLA	DO_REVERSAL
	CALLA	DO_REVERSAL_MESS

;Make sure the reversal works!
	movk	10,a0
	move	a0,*a8(SAFE_TIME)

#slam
	movi	bam_pogo_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEP	60

	jruc	#lp

#*****************************************************************************
bam_hdhold_pogo2

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

	WAITSWITCH_DWN	B_SKICK,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	B_KICK,0,#lp
	WAITSWITCH_DWN	B_PUNCH,0,#lp
	WAITSWITCH_DWN	B_SPUNCH,0,#lp

	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHELD,a0
	jrnz	#lp0


	CALLA	DO_REVERSAL
	CALLA	DO_REVERSAL_MESS


;Make sure the reversal works!
	movk	10,a0
	move	a0,*a8(SAFE_TIME)

#slam
	movi	bam_pogo_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEP	60

	jruc	#lp

#*
bam_graboh

#TIMEOUT	.equ	60

#lp0
	SLEEPK	1
#lp
;	move	*a8(PLYRMODE),a0
;	cmpi	MODE_HEADHOLD,a0
;	jrz	#cont0
;	cmpi	MODE_HEADHELD,a0
;	jrnz	#lp0
;#cont0
	clr	a11

	WAITSWITCH_DWN	J_DOWN,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_DOWN,0,#lp
	WAITSWITCH_DWN	B_KICK,J_DOWN_AWAY|J_DOWN_TOWARD,#lp

	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrz	#dograb
	cmpi	MODE_HEADHELD,a0
	jrz	#cont

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#lp0
	calla	get_opp_plyrmode
	cmpi	MODE_ONGROUND,a0
	jrz	#lp0
	cmpi	MODE_DEAD,a0
	jrz	#lp0
	cmpi	MODE_ATTACHED,a0
	jrz	#lp0

	jruc	#dograb

#cont


	CALLA	DO_REVERSAL
	CALLA	DO_REVERSAL_MESS

;Make sure the reversal works!
	movk	10,a0
	move	a0,*a8(SAFE_TIME)

	move	*a8(OBJ_ZPOS),a0,L
	addi	[5,0],a0
	move	a0,*a8(OBJ_ZPOS),L

#dograb
	movi	bam_4_graboh_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	WRSND	W_BAMBAM,GRABHOLD_T1,GRABHOLD_T2

	SLEEP	60

	jruc	#lp

#*
bam_hdhold_pile

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

	CALLA	DO_REVERSAL
	CALLA	DO_REVERSAL_MESS

;Make sure the reversal works!
	movk	10,a0
	move	a0,*a8(SAFE_TIME)

	move	*a8(OBJ_ZPOS),a0,L
	addi	[5,0],a0
	move	a0,*a8(OBJ_ZPOS),L

#slam
	movi	bam_3_pile_driver_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEP	60

	jruc	#lp


;	WAITSWITCH_DWN	J_AWAY,J_UP|J_DOWN,#lp
;	WAITSWITCH_DWN	J_TOWARD,J_UP|J_DOWN,#lp
;	WAITSWITCH_DWN	J_TOWARD,J_UP|J_DOWN,#lp
;	WAITSWITCH_DWN	J_DOWN_AWAY,0,#lp
;	WAITSWITCH_DWN	J_DOWN,0,#lp
;	WAITSWITCH_DWN	J_DOWN_TOWARD,0,#lp
;	WAITSWITCH_DWN	J_TOWARD,0,#lp



#*****************************************************************************

 SUBR	bam_ani_init

	move	*a13(FACING_DIR),a0
	btst	PLAYER_RIGHT_BIT,a0
	jrnz	#p1
;Plyr 2
	movi	bam_stand4_anim,a0
	calla	change_anim1a

	movi	bam_torso4_anim,a0
	calla	change_anim2a

	PUSH	a10
	move	a13,a10
	.ref	do_taunt
	CREATE0	do_taunt
	PULL	a10

	rets

#p1
	movi	bam_stand2_anim,a0
	calla	change_anim1a

	movi	bam_torso2_anim,a0
	calla	change_anim2a

	rets


#*****************************************************************************
*
* BAM BAM CONTROL CODE
*
* a13 = * bam process

 SUBR	move_bam

	movi	bam_secret_moves,a11
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

	FACE24	bam,pin_anim
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
	rets
#no_climb

	calla	execute_walk

#no_interrupt
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
#z		;0

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
	JJXM	NORMAL,		 50, 45,#punch_hdbutt,#punch_punch
	JJXM	DIZZY,		 50, 45,#punch_hdbutt,#punch_punch
	JJXM	BLOCK,		 50, 45,#punch_hdbutt,#punch_punch
	JJXM	ONGROUND,	120,120,#punch_lbowdrop,#punch_punch
	JJXM	RUNNING,		#punch_hiptoss
	JJXM	BOUNCING,		#punch_rets
	JJXM	ONTURNBKL,	 50, 96,#punch_yankdown,#punch_punch
	JJXM	CLIMBTURNBKL,		#punch_punch
	JJXM	INAIR,		 50, 45,#punch_hdbutt,#punch_punch
	JJXM	ATTACHED,	 50, 45,#punch_hdbutt,#punch_punch
	JJXM	DEAD,		 50, 45,#punch_hdbutt,#punch_punch
	JJXM	OPPOVERHEAD,	 50, 45,#punch_hdbutt,#punch_punch
	JJXM	WAITANIM,	 50, 45,#punch_hdbutt,#punch_punch
	JJXM	GRAPPLE,	 50, 45,#punch_hdbutt,#punch_punch
	JJXM	MASTER,		 50, 45,#punch_hdbutt,#punch_punch
	JJXM	SLAVE,		 50, 45,#punch_hdbutt,#punch_punch
	JJXM	HEADHOLD,	 50, 45,#punch_hdbutt,#punch_punch
	JJXM	HEADHELD,	 50, 45,#punch_hdbutt,#punch_punch
	JJXM	PUPPET,		 50, 45,#punch_hdbutt,#punch_punch
	JJXM	INAIR2,		 50, 45,#punch_hdbutt,#punch_punch
	JJXM_END


*****
#punch_rets
	rets

*****
#punch_punch
std_punch

	FACE24	bam,punch_anim
	calla	change_anim1a

	WRSND	W_BAMBAM,PUNCH_T1,PUNCH_T2
	rets

*****
#punch_hdbutt

	FACE24	bam,butt_anim
	calla	change_anim1a

	WRSND	W_BAMBAM,HDBUTT_T1,HDBUTT_T2
	rets

*****
#punch_lbowdrop

	FACE24	bam,lbowdrop_anim
	calla	change_anim1a

	WRSND	W_BAMBAM,LBOWDROP_T1,LBOWDROP_T2
	rets

*****
#punch_yankdown
std_yankdown
	rets

*****
#punch_hiptoss
std_hiptoss
	rets


************
#block		;2

;do_block
	.ref	bam_2_block_anim
	.ref	bam_4_block_anim

std_block
	FACE24	bam,block_anim
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
	JJXM	NORMAL,		 90, 45,#spunch_special,#spunch_jump
	JJXM	DIZZY,		 90, 45,#spunch_special,#spunch_jump
	JJXM	BLOCK,		 90, 45,#spunch_special,#spunch_jump
	JJXM	ONGROUND,	120,120,#spunch_lbowdrop,std_punch
	JJXM	RUNNING,	 90, 92,std_hiptoss,#spunch_jump
	JJXM	BOUNCING,		#spunch_rets
	JJXM	ONTURNBKL,	 60, 96,std_yankdown,std_punch
	JJXM	CLIMBTURNBKL,		std_punch
	JJXM	INAIR,		 85, 45,#spunch_special,#spunch_jump
	JJXM	ATTACHED,	 85, 45,#spunch_special,#spunch_jump
	JJXM	DEAD,		 116,112,#spunch_lbowdrop,std_punch
	JJXM	OPPOVERHEAD,	 85, 45,#spunch_special,#spunch_jump
	JJXM	WAITANIM,	 85, 45,#spunch_special,#spunch_jump
	JJXM	GRAPPLE,	 85, 45,#spunch_special,#spunch_jump
	JJXM	MASTER,		 85, 45,#spunch_special,#spunch_jump
	JJXM	SLAVE,		 85, 45,#spunch_special,#spunch_jump
	JJXM	HEADHOLD,	 85, 45,#spunch_special,#spunch_jump
	JJXM	HEADHELD,		do_pile				;19
	JJXM	PUPPET,		 85, 45,#spunch_special,#spunch_jump
	JJXM	INAIR2,		 85, 45,#spunch_special,#spunch_jump
	JJXM_END

#spunch_rets
	rets

*****
#spunch_jump
;jumping punch attack
	.ref	bam_2_slap_anim
	.ref	bam_4_slap_anim
	FACE24	bam,slap_anim
	calla	change_anim1a

	WRSND	W_BAMBAM,GRABHOLD_T1,GRABHOLD_T2

	rets

*****
#spunch_special
;If stick is toward opponent, then do head hold
	move	a13,a0
	calla	wres_get_stick_val_cur
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1

	jrz	#cont

	move	*a13(CLOSEST_XDIST),a1
	cmpi	50,a1
	jrgt	#spunch_jump
	jruc	#hdbutt
#cont

	.ref	bam_3_head_hold2_anim
	movi	bam_3_head_hold2_anim,a0
	calla	change_anim1a

	WRSND	W_BAMBAM,GRABHOLD_T1,GRABHOLD_T2

	rets
#hdbutt

;Bam Bam special move test
;	FACE24	bam,graboh_anim
;	movi	bam_running_headbutt,a0
;	movi	bam_pogo_anim,a0
;	movi	bam_4_fpunch_anim,a0

	FACE24	bam,butt_anim
	calla	change_anim1a

	WRSND	W_BAMBAM,HDBUTT_T1,HDBUTT_T2
	rets

*****
#spunch_lbowdrop
 
	.ref	bam_2_hair_pickup_anim
	.ref	bam_4_hair_pickup_anim
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

	FACE24	bam,hair_pickup_anim
	calla	change_anim1
	WRSND	W_BAMBAM,KICK_T1,KICK_T2
	rets

#no
	FACE24	bam,lbowdrop_anim
	calla	change_anim1a

	WRSND	W_BAMBAM,KICK_T1,KICK_T2

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
	JJXM	NORMAL,		 60, 92,#kick_knee,#kick_kick
	JJXM	DIZZY,		 60, 92,#kick_knee,#kick_kick
	JJXM	BLOCK,		 60, 92,#kick_knee,#kick_kick
	JJXM	ONGROUND,	120,120,#kick_stomp,#kick_kick
	JJXM	RUNNING,	 120,92,#kick_kick,#kick_flyingkick
	JJXM	BOUNCING,	 	#kick_kick
	JJXM	ONTURNBKL,	 	#kick_kick
	JJXM	CLIMBTURNBKL,	 	#kick_kick
	JJXM	INAIR,		 60, 92,#kick_knee,#kick_kick
	JJXM	ATTACHED,	 60, 92,#kick_knee,#kick_kick
	JJXM	DEAD,		 60, 92,#kick_knee,#kick_kick
	JJXM	OPPOVERHEAD,	 60, 92,#kick_knee,#kick_kick
	JJXM	WAITANIM,	 60, 92,#kick_knee,#kick_kick
	JJXM	GRAPPLE,	 60, 92,#kick_knee,#kick_kick
	JJXM	MASTER,		 60, 92,#kick_knee,#kick_kick
	JJXM	SLAVE,		 60, 92,#kick_knee,#kick_kick
	JJXM	HEADHOLD,	 60, 92,#kick_knee,#kick_kick
	JJXM	HEADHELD,	 60, 92,#kick_knee,#kick_kick
	JJXM	PUPPET,		 60, 92,#kick_knee,#kick_kick
	JJXM	INAIR2,		 60, 92,#kick_knee,#kick_kick
	JJXM_END

*****
#kick_flyingkick

;	.ref	bam_sflying_kick_anim
	movi	bam_flying_kick_anim,a0
	calla	change_anim1a

	SETMODE	INAIR

	WRSND	W_BAMBAM,FLYKICK_T1,FLYKICK_T2

	rets
*****
#kick_kick
std_kick

	FACE24	bam,kick_anim
	calla	change_anim1a

	WRSND	W_BAMBAM,KICK_T1,KICK_T2
	rets

*****
#kick_knee

	FACE24	bam,knee_anim
	calla	change_anim1a

	WRSND	W_BAMBAM,KICK_T1,KICK_T2
	rets

*****
#kick_stomp
attack_stomp

	FACE24	bam,stomp_anim
	calla	change_anim1a

	WRSND	W_BAMBAM,KICK_T1,KICK_T2

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
	JJXM	DIZZY,		 60, 60,#skick_special,#skick_kick
	JJXM	BLOCK,		 60, 60,#skick_special,#skick_kick
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
#skick_special
#skick_kick

;Jumping karate kick
	.ref	bam_2_superkick_anim
	.ref	bam_4_superkick_anim

	FACE24	bam,superkick_anim
	calla	change_anim1a

	WRSND	W_BAMBAM,FLYKICK_T1,FLYKICK_T2

	rets

*****
#skick_bigboot

	movi	bam_4_bigboot_anim,a0
	calla	change_anim1a

	WRSND	W_BAMBAM,FLYKICK_T1,FLYKICK_T2

	rets


************
#graboh		;8

;Both super buttons at the same time!

	movi	bam_4_graboh_anim,a0
	calla	change_anim1a

	WRSND	W_BAMBAM,GRABHOLD_T1,GRABHOLD_T2

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
* onground	< 176 176 	belly flop
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
	JJXM	DIZZY,			#punch_clothesline
	JJXM	BLOCK,			#punch_clothesline
	JJXM	ONGROUND,	176,176,#punch_bellyflop,#punch_rets
	JJXM	RUNNING,		#punch_clothesline
	JJXM	BOUNCING,		#punch_clothesline
	JJXM	ONTURNBKL,		#punch_clothesline
	JJXM	CLIMBTURNBKL,		#punch_clothesline
	JJXM	INAIR,			#punch_clothesline
	JJXM	ATTACHED,		#punch_clothesline
	JJXM	DEAD,		176,176,#punch_bellyflop,#punch_rets
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
;Only allow clothesline if near center of ring, and running toward opponent
	move	*a13(MOVE_DIR),a1
	btst	MOVE_LEFT_BIT,a1
	jrnz	#lft
;Moving right
	
	move	*a13(OBJ_XPOSINT),a0
	cmpi	RING_X_MID+70h,a0
	jrlt	#ok

;	LOCKUP

	rets

#lft
;Moving left
	
	move	*a13(OBJ_XPOSINT),a0
	cmpi	RING_X_MID-70h,a0
	jrgt	#ok

;	LOCKUP

	rets
#ok
	move	*a13(MOVE_DIR),a1
	move	*a13(NEW_FACING_DIR),a0	;Current facing dir (9,10,6,5 only)
	sll	5,a0
	addi	#mv_tbl,a0
	move	*a0,a0,L
	btst	a0,a1
	jrz	#yes

;	LOCKUP

	rets
#yes

;Will lunge toward opponent
;Is facing opponent - nt running away from him!
	.ref	bam_fly_cline_anim
	movi	bam_fly_cline_anim,a0
	calla	change_anim1a

	SETMODE	INAIR

	clr	a0
	move	a0,*a13(RUN_TIME)

	WRSND	W_BAMBAM,FLYKICK_T1,FLYKICK_T2

	rets

#mv_tbl	.long	0,0,0,0,0,MOVE_RIGHT_BIT,MOVE_RIGHT_BIT
	.long	0,0,MOVE_LEFT_BIT,MOVE_LEFT_BIT


*****
#punch_bellyflop
attack_bellyflop

	movi	bam_3_butt_drop_anim,a0
	calla	change_anim1a
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
	JJXM	NORMAL,			#kick_flyingkick
	JJXM	DIZZY,			#kick_flyingkick
	JJXM	BLOCK,			#kick_flyingkick
	JJXM	ONGROUND,	176,176,attack_bellyflop,#kick_rets
	JJXM	RUNNING,		#kick_flyingkick
	JJXM	BOUNCING,		#kick_flyingkick
	JJXM	ONTURNBKL,		#kick_flyingkick
	JJXM	CLIMBTURNBKL,		#kick_flyingkick
	JJXM	INAIR,			#kick_flyingkick
	JJXM	ATTACHED,		#kick_flyingkick
	JJXM	DEAD,		176,176,attack_bellyflop,#kick_rets
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

	movi	bam_flying_kick_anim,a0
	calla	change_anim1a

	SETMODE	INAIR

	WRSND	W_BAMBAM,FLYKICK_T1,FLYKICK_T2

	rets

;*****
;#kick_runstomp
;
;	rets

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
;	cmpi	bam_2_faceup_getup_anim,a0
;	jrz	#exit
;	cmpi	bam_4_faceup_getup_anim,a0
;	jrz	#exit
;
;	calla	do_roll
;	jrnz	#exit			;did roll
;
;	FACE24	bam,faceup_getup_anim
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

	movi	bam_run2_anim,a0
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
	cmpi	bam_climb_up_anim,a14
	jrne	#no_climbdown

	movi	bam_climb_down_anim,a0
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

	movi	bam_bellyflop_anim,a0
	calla	change_anim1a

	WRSND	W_BAMBAM,FLYKICK_T1,FLYKICK_T2

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

	FACE24  bam,push_anim
	calla	change_anim1a

	WRSND	W_BAMBAM,PUSH_T1,PUSH_T2

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

	move	*a13(ATTACH_PROC),a2,L		;proc attached to
	jrz	#not_attached
	move	*a2(ATTACH_PROC),a0,L
	jrnz	#still_attached

#not_attached

	move	*a13(ANIMODE),a0		;* remove this????
	btst	MODE_UNINT_BIT,a0		;*
	jrnz	#no_interrupt			;*

	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	SETMODE	NORMAL

	movi	MODE_NORMAL,a0
	move	a0,*a13(ANIMODE)

	rets

#still_attached
	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_interrupt

	move	*a13(FACING_DIR),a0
	andni	MOVE_UP,a0
	ori	MOVE_DOWN,a0
	move	a0,*a13(FACING_DIR)
	move	a0,*a13(NEW_FACING_DIR)

	move	a13,a0
	calla	wres_get_stick_val_cur
	jrz	#stand

	move	a0,*a13(MOVE_DIR)
	calla	execute_walk

	movi	bam_holdoh_anim,a0
	calla	change_anim2
 	jruc	#ck_butns
#stand
	clr	a0
	move	a0,*a13(MOVE_DIR)
	move	a0,*a13(OBJ_XVEL),L
	move	a0,*a13(OBJ_ZVEL),L

	movi	bam_stndholdoh_anim,a0
	calla	change_anim1

#ck_butns


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
;FIX!!!
;Get action table from doink for everyone!  The one that reads
;buttons correctly when two buttons are pressed at the same time!

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

	move	a13,a0
	calla	wres_get_stick_val_cur

	btst	PLAYER_DOWN_BIT,a0
	jrz	#z

	.ref	bam_slamdwn_anim
	movi	bam_slamdwn_anim,a0
	calla	change_anim1a

	WRSND	W_BAMBAM,PUNCH_T1,PUNCH_T2

	rets
#block		;2
#super_punch	;4
#kick		;8
	rets

#super_kick	;16

	move	a13,a0
	calla	wres_get_stick_val_cur

	btst	PLAYER_DOWN_BIT,a0
	jrz	#z

	movi	bam_backbreaker_anim,a0
	calla	change_anim1a

	WRSND	W_BAMBAM,HIPTOSS_T1,HIPTOSS_T2

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
;
;	move	*a13(GETUP_TIME),a0
;	jrnz	#still_going
;
;;now get move off
;;if opponents meter almost zero then break apart
;
;	calla	break_lockup
;	rets
;
;
;#still_going
;	calla	lineup_grapple
;	rets


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

#super_punch	;4

	rets

#punch		;1
;If stick is toward opponent, then do quick punches
	move	a13,a0
	calla	wres_get_stick_val_cur
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrnz	#tag
;	movi	dnk_uppercuts_to_head_anim,a0
	movi	bam_4_knee_anim,a0
	calla	change_anim1a
	rets

#tag
;	movi	dnk_uppercut_to_head_anim,a0
	movi	bam_4_knee_anim,a0
	calla	change_anim1a
	rets

************
;#super_punch	;4

do_pile
;This flag is only set if bam bam has done repeated kicks!
	move	*a13(USR_VAR2),a0
	jrz	#z

	move	a13,a0
	calla	wres_get_stick_val_cur

	btst	PLAYER_DOWN_BIT,a0
	jrz	#punch

	movi	bam_3_pile_driver_anim,a0
	calla	change_anim1a
	rets

#punchkick
#graboh
#kick

;	move	a13,a0
;	calla	wres_get_stick_val_cur
;
;	btst	PLAYER_DOWN_BIT,a0
;	jrz	#knee
;
;	move	a13,a0
;	.ref	wres_get_stick_rel_cur
;	calla	wres_get_stick_rel_cur
;
;	btst	MOVE_TOWARD_BIT,a0
;	jrz	#knee
;
;	.ref	bam_hdbutts_anim
;	movi	bam_hdbutts_anim,a0
;	calla	change_anim1a
;	rets
;
;#knee
	movi	bam_4_knee_anim,a0
	calla	change_anim1a
	rets

#super_kick	;16
;If stick is toward opponent, then do quick knees
	move	a13,a0
	calla	wres_get_stick_val_cur
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrnz	#z

;Quick knees
	.ref	bam_knees_anim
	movi	bam_knees_anim,a0
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

	.ref	bam_3_head_held_stand_anim
	movi	bam_3_head_held_stand_anim,a0
	calla	change_anim1a

#no_luck
	rets

;;If stick is toward opponent, then do reversal
;	move	a13,a0
;	calla	wres_get_stick_val_cur
;	move	*a13(NEW_FACING_DIR),a1
;	andi	0ch,a1
;	cmp	a0,a1
;	jrnz	#out
;
;	move	a13,a0
;	calla	wres_get_but_val_down
;	btst	PLAYER_SPUNCH_BIT,a0
;	jrz	#out
;
;	.ref	DO_REVERSAL
;	.ref	DO_REVERSAL_MESS
;
;	CALLA	DO_REVERSAL
;	CALLA	DO_REVERSAL_MESS
;    
;;Successful reversal pile drive
;	move	*a13(OBJ_ZPOS),a0,L
;	addi	[5,0],a0
;	move	a0,*a13(OBJ_ZPOS),L
;
;	movi	bam_3_pile_driver_anim,a0
;	calla	change_anim1a
;
;#out
;	rets

#*****************************************************************************
mode_puppet	;20
	rets

#*****************************************************************************
mode_chokehold	;24
	rets

#*****************************************************************************

#VEL	equ	30000h
#DVEL	equ	21f0eh


 SUBR bam_velocity_table

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

 SUBR bam_rotate_anims_table
; old = up right
	.long	bam_stand2_anim		;new = up right
	.long	bam_2_to_4_turn_anim	;    = down right
	.long	bam_2_to_6_turn_anim	;    = down left ***
	.long	bam_2_to_8_turn_anim	;    = up left

; old = down right
	.long	bam_4_to_2_turn_anim	;new = up right
	.long	bam_stand4_anim		;    = down right
	.long	bam_4_to_6_turn_anim	;    = down left
	.long	bam_4_to_8_turn_anim	;    = up left ***

; old = down left
	.long	bam_6_to_2_turn_anim	;new = up right ***
	.long	bam_6_to_4_turn_anim	;    = down right
	.long	bam_stand6_anim		;    = down left
	.long	bam_6_to_8_turn_anim	;    = up left

; old = up left
	.long	bam_8_to_2_turn_anim	;new = up right
	.long	bam_8_to_4_turn_anim	;    = down right ***
	.long	bam_8_to_6_turn_anim	;    = down left
	.long	bam_stand8_anim		;    = up left


 SUBR bam_leg_anims_table
;  MOVE
;(#1 - UP)				FACING
	.long	bam_walk1_f2_anim	;1 (UP)
	.long	bam_walk1_f2_anim	;2 (UP_RIGHT)
	.long	bam_walk1_f4_anim	;3 (RIGHT)
	.long	bam_walk1_f4_anim	;4 (DOWN_RIGHT)
	.long	bam_walk1_f4_anim	;5 (DOWN)
	.long	bam_walk1_f4_anim	;6 (DOWN_LEFT)
	.long	bam_walk1_f2_anim	;7 (LEFT)
	.long	bam_walk1_f2_anim	;8 (UP-LEFT)

;(#2 - UP-RIGHT)
	.long	bam_walk2_f2_anim	;1 (UP)
	.long	bam_walk2_f2_anim	;2 (UP_RIGHT)
	.long	bam_walk2_f2_anim	;3 (RIGHT)
	.long	bam_walk2_f4_anim	;4 (DOWN_RIGHT)
	.long	bam_walk8_f4_anim	;5 (DOWN)
	.long	bam_walk8_f4_anim	;6 (DOWN_LEFT)
	.long	bam_walk4_f2_anim	;7 (LEFT)
	.long	bam_walk4_f2_anim	;8 (UP-LEFT)

;(#3 - RIGHT)
	.long	bam_walk2_f2_anim	;1 (UP)
	.long	bam_walk2_f2_anim	;2 (UP_RIGHT)
	.long	bam_walk2_f2_anim	;3 (RIGHT)
	.long	bam_walk4_f4_anim	;4 (DOWN_RIGHT)
	.long	bam_walk4_f4_anim	;5 (DOWN)
	.long	bam_walk8_f4_anim	;6 (DOWN_LEFT)
	.long	bam_walk6_f2_anim	;7 (LEFT)
	.long	bam_walk6_f2_anim	;8 (UP-LEFT)


;(#4 - DOWN-RIGHT)
	.long	bam_walk2_f2_anim	;1 (UP)
	.long	bam_walk8_f2_anim	;2 (UP_RIGHT)
	.long	bam_walk4_f4_anim	;3 (RIGHT)
	.long	bam_walk4_f4_anim	;4 (DOWN_RIGHT)
	.long	bam_walk2_f4_anim	;5 (DOWN)
	.long	bam_walk6_f4_anim	;6 (DOWN_LEFT)
	.long	bam_walk2_f2_anim	;7 (LEFT)
	.long	bam_walk6_f2_anim	;8 (UP-LEFT)

;(#5 - DOWN)
	.long	bam_walk5_f2_anim	;1 (UP)
	.long	bam_walk5_f2_anim	;2 (UP_RIGHT)
	.long	bam_walk5_f4_anim	;3 (RIGHT)
	.long	bam_walk5_f4_anim	;4 (DOWN_RIGHT)
	.long	bam_walk5_f4_anim	;5 (DOWN)
	.long	bam_walk5_f4_anim	;6 (DOWN_LEFT)
	.long	bam_walk5_f2_anim	;7 (LEFT)
	.long	bam_walk5_f2_anim	;8 (UP-LEFT)

;(#6 - DOWN-LEFT)
	.long	bam_walk2_f2_anim	;1 (UP)
	.long	bam_walk6_f2_anim	;2 (UP_RIGHT)
	.long	bam_walk2_f2_anim	;3 (RIGHT)
	.long	bam_walk6_f4_anim	;4 (DOWN_RIGHT)
	.long	bam_walk2_f4_anim	;5 (DOWN)
	.long	bam_walk4_f4_anim	;6 (DOWN_LEFT)
	.long	bam_walk2_f2_anim	;7 (LEFT)
	.long	bam_walk8_f2_anim	;8 (UP-LEFT)

;(#7 - LEFT)
	.long	bam_walk2_f2_anim	;1 (UP)
	.long	bam_walk6_f2_anim	;2 (UP_RIGHT)
	.long	bam_walk6_f2_anim	;3 (RIGHT)
	.long	bam_walk8_f4_anim	;4 (DOWN_RIGHT)
	.long	bam_walk4_f4_anim	;5 (DOWN)
	.long	bam_walk4_f4_anim	;6 (DOWN_LEFT)
	.long	bam_walk2_f2_anim	;7 (LEFT)
	.long	bam_walk2_f2_anim	;8 (UP-LEFT)

;(#8 - UP-LEFT)
	.long	bam_walk2_f2_anim	;1 (UP)
	.long	bam_walk4_f2_anim	;2 (UP_RIGHT)
	.long	bam_walk6_f2_anim	;3 (RIGHT)
	.long	bam_walk8_f4_anim	;4 (DOWN_RIGHT)
	.long	bam_walk6_f4_anim	;5 (DOWN)
	.long	bam_walk2_f4_anim	;6 (DOWN_LEFT)
	.long	bam_walk2_f2_anim	;7 (LEFT)
	.long	bam_walk2_f2_anim	;8 (UP-LEFT)


 SUBR bam_torso_anims_table
; old = up right
	.long	bam_torso2_anim		;new = up right
	.long	bam_2_to_4_turn2_anim	;    = down right
	.long	bam_2_to_6_turn2_anim	;    = down left ***
	.long	bam_2_to_8_turn2_anim	;    = up left

; old = down right
	.long	bam_4_to_2_turn2_anim	;new = up right
	.long	bam_torso4_anim		;    = down right
	.long	bam_4_to_6_turn2_anim	;    = down left
	.long	bam_4_to_8_turn2_anim	;    = up left ***

; old = down left
	.long	bam_6_to_2_turn2_anim	;new = up right ***
	.long	bam_6_to_4_turn2_anim	;    = down right
	.long	bam_torso6_anim		;    = down left
	.long	bam_6_to_8_turn2_anim	;    = up left

; old = up left
	.long	bam_8_to_2_turn2_anim	;new = up right
	.long	bam_8_to_4_turn2_anim	;    = down right ***
	.long	bam_8_to_6_turn2_anim	;    = down left
	.long	bam_torso8_anim		;    = up left



******************************************************************************

	.end
