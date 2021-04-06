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

	.ref	get_punch_dtime,ck_teammate_pin,raisearm_check
	.ref	process_ptrs,can_pin
	.ref	change_anim1,change_anim1a,set_raisearm_bit,hit_nearest
	.ref	change_anim2,change_anim2a,std_taunt,std_walk_fast
	.ref	keep_attached,master_keep_attached
	.ref	get_opp_plyrmode,mode_dead,get_opp_process
	.ref	check_secret_moves,round_award
	.ref	mode_inair2,mode_puppet
	.ref	execute_walk,do_taunt
	.ref	bounce_off_ropes
	.ref	climb_turnbuckle
	.ref	ck_ignore,PCNT
	.ref	CLIMB_ROPES,ADD_IF_SILENT,JUMP_ROPES
	.ref	CHECK_COMBO_GO,FIND_AND_KILL_ENDLESS

	.ref	BONUS_MESS,DO_REVERSAL,DO_REVERSAL_MESS
	.ref	BLOCK_WOOSH,drone_change_back
	.ref	blocking_off
	.ref	hyper_speed_on
	.ref	in_finish_move
	.ref	p1rounds,p2rounds
	.if NUM_TAKER_FINISHES
	.if NUM_TAKER_FINISHES > 1
	.ref	und_finish2_move
	.endif
	.endif
	.ref	finish_completed
	.ref	p1pins,p2pins
	.ref	und_coffin_up
	.ref	close_the_door
	.ref	wres_mv_done
	.ref	dead_wrestler
	.ref	und_2_raise_dead_anim
	.ref	guy_up,guy_in
	.ref	BGND_UD1
	.ref	KIL1C
	.ref	RNDRNG0

******************************************************************************
* ANIMATION SEQUENCES

	.ref	und_4_block_anim
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

	.ref	und_2_butt_anim,und_4_butt_anim
	.ref	und_2_butts_anim,und_4_butts_anim
	.ref	und_2_knee_anim,und_4_knee_anim
	.ref	und_4_bigboot_anim

	.ref	und_head_hit2_anim,und_head_hit_dizzy_anim
	.ref	und_2_stomp_anim,und_4_stomp_anim

	.ref	und_4_push_anim
	.ref	und_4_losebal_anim
	.ref	und_2_slap_anim,und_4_slap_anim

	.ref	und_2_grabfling_anim,und_4_grabfling_anim

	.ref	und_2_uppercut_anim,und_4_uppercut_anim
	.ref	und_2_hair_pickup_anim,und_4_hair_pickup_anim

	.ref	und_4_pin2_anim,und_2_raise_arm_anim
	.ref	und_4_raise_arm_anim
;	.ref	und_ocrun_anim
	.ref	und_fall_back_anim

;	.ref	und_summon_anim,und_summon2_anim
	.ref	und_getup_anim
;	.ref	und_4_graboh_anim
	.ref	und_heldoh_anim

	.ref	und_2_super_kick_anim,und_4_super_kick_anim
	.ref	und_4_knee_fall_anim
	.ref	und_flying_kick_anim

	.ref	und_2_lbowdrop_anim,und_4_lbowdrop_anim
	.ref	und_flying_butt_drop_anim,und_tbukl_butt_drop_anim

	.ref	und_sliding_choke_anim
	.ref	und_tombstone_smash_anim
	.ref	und_chokeslam_anim
	.ref	und_pile_anim
	.ref	und_neckbreaker_anim
	.ref	und_2_snapmirror_anim,und_4_snapmirror_anim
	.ref	und_2_snapmirror2_anim,und_4_snapmirror2_anim
	.ref	und_climb_down_anim,und_climb_up_anim
	.ref	und_spirit_push_anim,und_spirit_pull_anim
	.ref	und_combo_kick_anim,und_combo_punch_anim
	.ref	und_3_head_hold2_anim
	.ref	und_3_head_hold_anim
	.ref	und_neckbreaker2_anim,und_neckbreaker3_anim
	.ref	und_4_knee_butts_anim
	.ref	und_3_head_held_stand_anim
	.ref	und_2_uppercut_anim,und_4_uppercut_anim
	.ref	und_choke_face_slam_anim

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
	.long	#hip_toss
	.long	#grab_fling2
	.long	#hip_toss2
	.long	#neck_grab
	.long	#tomb_smash
	.long	0

*****************************************************************************
*
* SPECIAL MOVE PROCESSES
*

 SUBR	und_smove_table

	.long	und_hdhold_neckbrk
	.long	und_hdhold_faceslam
	.long	und_hdhold_pile		;(tombstone)
	.long	und_spirit_pull
	.long	und_spirit_push
	.long	und_grab_toss_air
	.long	und_hdhold_combo1
	.long	und_hdhold_combo2
;	.long	und_hdhold_anti_combo
	.long	und_choke_slide
	.long	std_walk_fast
	.long	std_taunt

	.if NUM_TAKER_FINISHES
	.long	und_finish_move1
	.endif
	.if NUM_TAKER_FINISHES > 1
	.long	und_finish_move2
	.endif
	.long	0

*******************************************************************************

#tomb_smash
	.word	B_SKICK,		J_ALL
	.word	J_TOWARD,		J_REAL_LR
	.word	J_TOWARD,		J_REAL_LR
	.word	8000h | 32 		;max
	.long	#scrt_tomb

#scrt_tomb
	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#out

;	calla	get_opp_plyrmode
;	cmpi	MODE_DEAD,a0
;	jrz	#out

	move	*a13(PLYRMODE),a0
	cmpi	MODE_ONTURNBKL,a0
	jrz	#out

	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	SETMODE	NORMAL

	CALLA	FIND_AND_KILL_ENDLESS
	movi	und_tombstone_smash_anim,a0
	calla	change_anim1a

	WRSND	W_TAKER,GRABHOLD_T1,GRABHOLD_T2

	rets

*******************************************************************************

#hip_toss
;	.word	B_PUNCH | J_AWAY,	J_REAL_LR | J_UP | J_DOWN
;	.word	8000h | 10		;max
;	.long	#scrt_hiptoss

	.word	B_PUNCH,		J_ALL
	.word	J_AWAY,		J_REAL_LR
	.word	J_AWAY,		J_REAL_LR
	.word	8000h | 32		;max
	.long	#scrt_hiptoss

#scrt_hiptoss
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
	jrz	#ck1
	cmpi	MODE_INAIR,a0
	jrz	#doit
	cmpi	MODE_INAIR2,a0
	jrz	#doit

	move	*a13(CLOSEST_DIST),a0
	cmpi	70h,a0
	jrgt	#out

#doit
 	FACE24	und,snapmirror_anim
	calla	change_anim1a

	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	SETMODE	NORMAL

	WRSND	W_TAKER,GRABFLING_T1,PUNCH_T2

	rets
#ck1
	move	*a13(CLOSEST_NUM),a0
	X32	a0
	addi	process_ptrs,a0
	move	*a0,a0,L
	move	*a0(ANIMODE),a0
	btst	MODE_NOGRAVITY_BIT,a0
	jrnz	#doit
	rets

*******************************************************************************

#neck_grab
	.word	B_SPUNCH,		J_ALL
	.word	J_TOWARD,		J_REAL_LR
	.word	J_TOWARD,		J_REAL_LR
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

	move	*a13(LAST_HEADHOLD),a14,L
	move	@PCNT,a0,L
	sub	a14,a0
	cmpi	2*60,a0
	jrge	#ok2

;This head grab is too close (in terms of time) to most recent grab
	.ref	und_3_fake_hold_anim
	movi	und_3_fake_hold_anim,a0
	calla	change_anim1a
	rets

#ok2
	move	*a13(CLOSEST_XDIST),a1
	cmpi	85,a1
	jrgt	#std_grab

	movi	und_3_head_hold2_anim,a0
	calla	change_anim1a
	rets

#std_grab
	movi	und_3_head_hold_anim,a0
	calla	change_anim1a
	rets

*******************************************************************************

#button_hold

	move	*a13(BUT_VAL_UP),a0
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
	jrz	#out
	cmpi	MODE_HEADHOLD,a0
	jrz	#out
;	cmpi	MODE_RUNNING,a0
;	jrz	#out

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#out

;Don't do it when he is on ground
	calla	get_opp_plyrmode
	cmpi	MODE_ONGROUND,a0
	jrz	#out
;	cmpi	MODE_DEAD,a0
;	jrz	#out

	move	*a13(PLYRMODE),a0
	cmpi	MODE_RUNNING,a0
	jrz	#leapbrk

	movi	und_neckbreaker2_anim,a0
	calla	change_anim1a

	WRSND	W_TAKER,GRABHOLD_T1,GRABHOLD_T2

	rets

#leapbrk
;Sliding neck breaker
	movi	und_neckbreaker3_anim,a0
	calla	change_anim1a

	WRSND	W_TAKER,GRABHOLD_T1,GRABHOLD_T2

	rets


*******************************************************************************

#grab_fling2
	.word	B_SPUNCH | J_AWAY,	J_REAL_LR | J_UP | J_DOWN
	.word	8000h | 10		;max
	.long	#scrt_grabfling2

#hip_toss2
	.word	B_PUNCH | J_AWAY,	J_REAL_LR | J_UP | J_DOWN
	.word	8000h | 10		;max
	.long	#scrt_grabfling2

#scrt_grabfling2
	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#out

;If opponent is running, do a hip toss
	calla	get_opp_plyrmode
	cmpi	MODE_BOUNCING,a0
	jrz	#yes
	cmpi	MODE_RUNNING,a0
	jrz	#yes
	rets

*******************************************************************************

#grab_fling
;	.word	B_SPUNCH | J_AWAY,	J_REAL_LR | J_UP | J_DOWN
;	.word	8000h | 10		;max
;	.long	#scrt_grabfling

	.word	B_SPUNCH,		J_ALL
	.word	J_AWAY,		J_REAL_LR
	.word	J_AWAY,		J_REAL_LR
	.word	8000h | 32		;max
	.long	#scrt_grabfling

#scrt_grabfling
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

	WRSND	W_TAKER,GRABFLING_T1,PUNCH_T2
	rets

#nope
;Don't fling when he is on ground
	calla	get_opp_plyrmode
	cmpi	MODE_HEADHELD,a0
	jrz	#ck2
	cmpi	MODE_ONGROUND,a0
	jrz	#out
	cmpi	MODE_DEAD,a0
	jrz	#out
#doit0
	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	SETMODE	NORMAL

;	move	*a13(LAST_FLING_ATTEMPT),a14,L
;	move	@PCNT,a0,L
;	sub	a14,a0
;	cmpi	3*60,a0
;	jrge	#ok2a
;
;;This head grab is too close (in terms of time) to most recent grab
;	FACE24	und,slap_anim
;	calla	change_anim1a
;
;	WRSND	W_TAKER,SPUNCH_T1,SPUNCH_T2
;	rets
;
;#ok2a
;	move	@PCNT,a14,L			;use 32-bit PCNT!
;	move	a14,*a13(LAST_FLING_ATTEMPT),L

	FACE24	und,grabfling_anim
	calla	change_anim1a

	WRSND	W_TAKER,GRABFLING_T1,PUNCH_T2
#out
	rets
#ck2
	move	*a13(CLOSEST_NUM),a0
	X32	a0
	addi	process_ptrs,a0
	move	*a0,a0,L
	move	*a0(ANIMODE),a0
	btst	MODE_NOGRAVITY_BIT,a0
	jrnz	#doit0
	rets
	
	.if NUM_TAKER_FINISHES

#******************************************************************************
*
* Shake world - shakes the world around for takers finish move
*
 SUBRP	shake_world
	move	@WORLDTLX,a8,L
	move	@WORLDTLY,a9,L
#sw_loop
	movk	4,a0
	calla	RNDRNG0
	movk	2,a11
	sub	a0,a11
	sll	16,a11
	move	a8,a10
	add	a11,a10
	move	a10,@WORLDTLX,L

	movk	4,a0
	calla	RNDRNG0
	movk	2,a11
	sub	a0,a11
	sll	16,a11
	move	a9,a10
	add	a11,a10
	move	a10,@WORLDTLY,L

	calla	BGND_UD1

	SLEEPK	3
	jruc	#sw_loop
	
	DIE

#******************************************************************************
*
* Adjusts the view to midpoint between taker and the coffin
*
 SUBRP	adjust_view
	move	@WORLDTLX,a14,L

	; If we are positioned within 100 pixels to the left of the right
	; edge of the ring don't bother scrolling any further.
	move	a14,a0
	srl	16,a0
	cmpi	1322-100,a0
	jrge	#av_exit

	; Get the midpoint between taker and the right edge of ring
	move	*a8(OBJ_XPOS),a14,L
	addi	[1200,0],a14
	srl	1,a14

	; Get the difference between taker and the midpoint
	move	*a8(OBJ_XPOS),a0,L
	sub	a0,a14

	; Divide by 32
	sra	5,a14

	; Do the move
	movi	32,a9
#mv_loop
	move	@WORLDTLX,a0,L
	add	a14,a0
	move	a0,@WORLDTLX,L
	PUSHP	a14
	SLEEPK	1
	calla	BGND_UD1
	PULLP	a14
	dsjs	a9,#mv_loop

#av_exit
	; Now start the world shakin' around
	CREATE	FIREWRK_PID,shake_world

	RETP


#******************************************************************************
 SUBRP	und_finish_move1

#TIMEOUT	.equ	TSEC

	; Set up the globals used to syncronize everythins
	clr		a14
	move		a14,@in_finish_move
	move		a14,@close_the_door
	move		a14,@guy_up
	move		a14,@guy_in

	; Now wait on the correct buttons -n- sticks
#reset
	clr		a11
	SLEEPK		1
	WAITSWITCH_DWN	J_UP,0,#reset
	movi		#TIMEOUT,a11
	WAITSWITCH_DWN	J_DOWN,0,#reset
	WAITSWITCH_DWN	B_PUNCH,J_ALL,#reset


	; Make sure the guy we are doin' this on is dead
	PUSH		a13
	move		a8,a13
	calla		get_opp_plyrmode
	PULL		a13
	cmpi		MODE_DEAD,a0
	jrnz		#reset

	; Check to make sure this is my 2nd pin attempt
	move		@p1pins,a0
	move		*a8(PLYR_SIDE),a14
	jrz		#is_p1
	move		@p2pins,a0
#is_p1
	cmpi		2,a0
	jrlt		#reset

	; Don't allow the move if I've been turned into a drone
	; by the autopin goop
	move		*a8(PLYR_TYPE),a14
	jrnz		#fi1_exit

	; Don't allow the move if I'm outside the ring
	move		*a8(RING_TIME),a14
	jrn		#fi1_exit

	; Don't allow the move if I've already pinned the guy
	move		*a8(STATUS_FLAGS),a14
	btst		B_DID_PIN,a14
	jrnz		#fi1_exit

	; Set up globals used for this animation
	move		*a8(WHOIHIT),a14,L
	move		a14,@dead_wrestler,L

	; Don't allow move if dead guy is to right of center ring + 100 pix
	move		*a14(OBJ_XPOSINT),a14
	cmpi		RING_X_CENTER+100,a14
	jrgt		#fi1_exit

	; Don't allow move if taker is to right of center ring + 100 pix
	move		*a8(OBJ_XPOSINT),a14
	cmpi		RING_X_CENTER+100,a14
	jrgt		#fi1_exit

	; OK - we made it - tell all who care we are going to
	; do a finishing move.  This also shuts down the scroller.
	movk		1,a14
	move		a14,@in_finish_move

	; clear victim's DO_BUCKOFF bit and set his NO_BUCKOFF bit
	move		@dead_wrestler,a0,L
	move		*a0(STATUS_FLAGS),a14,L
	andni		M_DO_BUCKOFF,a14
	ori		M_NO_BUCKOFF,a14
	move		a14,*a0(STATUS_FLAGS),L

	; Move the view to 1/2 way between taker and the coffin
	JSRP		adjust_view

	; Let the dust settle before we start our animation
	SLEEPK		15

	; Start the animation for the finish move
	movi		und_2_raise_dead_anim,a14
	move		a14,*a8(SPECIAL_MOVE_ADDR),L

	; Wait here until finish move is complete
#fdone_wait
	SLEEPK		5
	move		@finish_completed,a14
	jrz		#fdone_wait

	; Tell everbody that cares that the finish move is done
	clr		a14
	move		a14,@in_finish_move

	; Kill off shaker process
	movi		FIREWRK_PID,a0
	calla		KIL1C

#fi1_exit
	DIE
	.endif
	

	.if NUM_TAKER_FINISHES > 1
#******************************************************************************
 SUBRP	und_finish_move2

#TIMEOUT	.equ	TSEC

#end_wait
	SLEEP		TSEC/4
	move		@p1rounds,a0			; Get player 1 rounds
	move		@p2rounds,a1			; Get player 2 rounds
	or		a1,a0				; Put em together
	cmpi		2,a0				; Anybody got 2?
	jrlt		#end_wait			; br = no

#reset
	clr		a11
	move		a11,@in_finish_move
	SLEEPK		1
	WAITSWITCH_DWN	J_UP,0,#reset
	movi		#TIMEOUT,a11
	move		a11,@in_finish_move
	WAITSWITCH_DWN	J_UP,0,#reset
	WAITSWITCH_DWN	J_RIGHT,J_UP,#reset
	WAITSWITCH_DWN	J_RIGHT,J_UP,#reset
	WAITSWITCH_DWN	B_SPUNCH,J_ALL,#reset

	movi		und_finish2_move,a0
	move		a0,*a8(SPECIAL_MOVE_ADDR),L
	DIE
	.endif

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

;	WAITSWITCH_DWN	J_AWAY,0,#lp
	WAITSWITCH_DWN	J_TOWARD,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_TOWARD,0,#lp
	WAITSWITCH_DWN	B_SPUNCH,J_ALL,#lp

;	move	*a8(ANIBASE),a0,L
;	cmpi	und_sliding_choke_anim,a0
;	jrz	#lp0

	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrz	#slam
	cmpi	MODE_HEADHELD,a0
	jrnz	#lp0
	move	*a8(I_WILL_DIE),A14
	jrnz	#lp0

	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

	CALLA	DO_REVERSAL
	CALLA	DO_REVERSAL_MESS

	;target WHOHITME -- don't hit anyone else
	SMRTTGT	a8,WHOHITME

	;immobilize WHOHITME
	move	*a8(WHOHITME),a0,L
	jruc	#is_reversal

#slam
	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

	movk	1,a10
	CREATE	MESSAGE_PID,BONUS_MESS

	;target WHOIHIT -- don't hit anyone else
	SMRTTGT	a8,WHOIHIT

	;immobilize WHOIHIT
	move	*a8(WHOIHIT),a0,L

#is_reversal
	movk	15,a14
	move	a14,*a0(IMMOBILIZE_TIME)

	CALLA	FIND_AND_KILL_ENDLESS

	movi	und_neckbreaker_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

;Use this bam grunt
	WRSND	W_BAMBAM,GRABHOLD_T1,GRABHOLD_T2

	SLEEPK	20

	jruc	#lp

*******************************************************************************
#*
und_hdhold_faceslam

#TIMEOUT	.equ	60

#lp0
	SLEEPK	1
#lp
	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrz	#cont
	cmpi	MODE_CHOKEHOLD,a0
	jrz	#cont
	cmpi	MODE_HEADHELD,a0
	jrnz	#lp0
#cont
	clr	a11

	WAITSWITCH_DWN	J_DOWN,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_DOWN,0,#lp
	WAITSWITCH_DWN	B_KICK,J_ALL,#lp

	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrz	#slam
	cmpi	MODE_CHOKEHOLD,a0
	jrz	#slam
	cmpi	MODE_HEADHELD,a0
	jrnz	#lp0
	move	*a8(I_WILL_DIE),A14
	jrnz	#lp0

	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

	CALLA	DO_REVERSAL
	CALLA	DO_REVERSAL_MESS

	;target WHOHITME -- don't hit anyone else
	SMRTTGT	a8,WHOHITME

	;immobilize WHOHITME
	move	*a8(WHOHITME),a0,L
	jruc	#is_reversal

#slam
	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

	movk	1,a10
	CREATE	MESSAGE_PID,BONUS_MESS

	;target WHOIHIT -- don't hit anyone else
	SMRTTGT	a8,WHOIHIT

	;immobilize WHOIHIT
	move	*a8(WHOIHIT),a0,L

#is_reversal
	movk	15,a14
	move	a14,*a0(IMMOBILIZE_TIME)

	CALLA	FIND_AND_KILL_ENDLESS

;	movi	und_neckbreaker_anim,a14
	movi	und_choke_face_slam_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

;Use this bam grunt
	WRSND	W_BAMBAM,GRABHOLD_T1,GRABHOLD_T2

	SLEEPK	20

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

;	WAITSWITCH_DWN	J_UP,0,#lp
	WAITSWITCH_DWN	J_DOWN,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_DOWN,0,#lp
	WAITSWITCH_DWN	B_SKICK,J_ALL,#lp

;	move	*a8(ANIBASE),a0,L
;	cmpi	und_sliding_choke_anim,a0
;	jrz	#lp0

	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrz	#slam
	cmpi	MODE_HEADHELD,a0
	jrnz	#lp0
	move	*a8(I_WILL_DIE),A14
	jrnz	#lp0

	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

	CALLA	DO_REVERSAL
	CALLA	DO_REVERSAL_MESS

	;target WHOHITME -- don't hit anyone else
	SMRTTGT	a8,WHOHITME

	;target WHOHITME
	move	*a8(WHOHITME),a0,L
	jruc	#is_reversal

#slam
	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

	movk	29,a10
	CREATE	MESSAGE_PID,BONUS_MESS

	;target WHOIHIT -- don't hit anyone else
	SMRTTGT	a8,WHOIHIT

	;target WHOIHIT
	move	*a8(WHOIHIT),a0,L

#is_reversal
	movk	15,a14
	move	a14,*a0(IMMOBILIZE_TIME)

	CALLA	FIND_AND_KILL_ENDLESS
	movi	und_pile_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

;Use this bam grunt
	WRSND	W_BAMBAM,GRABHOLD_T1,GRABHOLD_T2

	SLEEPK	20

	jruc	#lp

*******************************************************************************
#*
und_choke_slide

#TIMEOUT	.equ	60

#lp0
	SLEEPK	1
#lp
	clr	a11

	WAITSWITCH_DWN	J_DOWN,0,#lp

	movi	#TIMEOUT,a11

;	WAITSWITCH_DWN	J_DOWN_TOWARD,0,#lp

	WAITSWITCH_DWN	J_TOWARD,J_UP|J_DOWN,#lp
	WAITSWITCH_DWN	B_PUNCH,J_ALL,#lp

	move	*a8(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#lp0

	move	*a8(PLYRMODE),a0
	cmpi	MODE_ONTURNBKL,a0
	jrz	#lp0
	cmpi	MODE_RUNNING,a0
	jrz	#lp0
	move	*a8(I_WILL_DIE),A14
	jrnz	#lp0

;Don't do it when he is on ground
	SWAP	a8,a13
	calla	get_opp_plyrmode
	SWAP	a8,a13
	cmpi	MODE_ONGROUND,a0
	jrz	#lp0
	cmpi	MODE_DEAD,a0
	jrz	#lp0
	cmpi	MODE_HEADHELD,a0
	jrz	#lp0
	cmpi	MODE_CHOKING,a0
	jrz	#lp0

	movi	und_sliding_choke_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEPK	20

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

	WAITSWITCH_DWN	J_DOWN,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_TOWARD,J_UP|J_DOWN,#lp
	WAITSWITCH_DWN	B_KICK,J_ALL,#lp

	move	*a8(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#lp0

	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore
    
	SWAP	a8,a13
	calla	get_opp_plyrmode
	SWAP	a8,a13
;	cmpi	MODE_DEAD,a0
;	jrz	#lp
	cmpi	MODE_CHOKING,a0
	jrz	#lp
	cmpi	MODE_HEADHELD,a0
	jrz	#lp
;	cmpi	MODE_ONGROUND,a0
;	jrz	#lp

	movi	und_spirit_push_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	clr	a0
	move	a0,*a8(RUN_TIME)

	SETMODE	NORMAL

	SLEEP	3*60

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

	WAITSWITCH_DWN	J_DOWN,0,#lp

	movi	#TIMEOUT,a11

;	WAITSWITCH_DWN	J_DOWN_TOWARD,0,#lp

	WAITSWITCH_DWN	J_AWAY,J_UP|J_DOWN,#lp
	WAITSWITCH_DWN	B_KICK,J_ALL,#lp

	move	*a8(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#lp0

	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

	SWAP	a8,a13
	calla	get_opp_plyrmode
	SWAP	a8,a13
;	cmpi	MODE_DEAD,a0
;	jrz	#lp
	cmpi	MODE_CHOKING,a0
	jrz	#lp
	cmpi	MODE_HEADHELD,a0
	jrz	#lp
;	cmpi	MODE_ONGROUND,a0
;	jrz	#lp

	movi	und_spirit_pull_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	clr	a0
	move	a0,*a8(RUN_TIME)

	SETMODE	NORMAL

	SLEEP	3*60

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
	WAITSWITCH_DWN	B_PUNCH,J_ALL,#lp

	move	*a8(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#lp

	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jreq	#lp0

;Don't do it when he is on ground
	SWAP	a8,a13
	calla	get_opp_plyrmode
	SWAP	a8,a13
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
#cont
	move	a0,*a8(SPECIAL_MOVE_ADDR),L

	WRSND	W_TAKER,HIPTOSS_T1,HIPTOSS_T2

	clr	a0
	move	a0,*a8(ATTACH_PROC),L

	SETMODE	NORMAL

	SLEEPK	20

	jruc	#lp

*******************************************************************************
#*
und_hdhold_combo1

#TIMEOUT	.equ	60

#lp0
	SLEEPK	1
#lp
	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrnz	#lp0
;	jrz	#cont
;	cmpi	MODE_HEADHELD,a0
;	jrnz	#lp0
;#cont
;In combo mode?
	calla	CHECK_COMBO_GO
	jrlt	#lp0


	clr	a11

	WAITSWITCH_DWN	J_TOWARD,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_TOWARD,0,#lp
	WAITSWITCH_DWN	B_SKICK,J_ALL,#lp

	move	*a8(ANIBASE),a0,L
	cmpi	und_sliding_choke_anim,a0
	jrz	#lp0

	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrz	#slam
	cmpi	MODE_HEADHELD,a0
	jrnz	#lp0


#slam
	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

;Start combo rules here
;	move	*a8(ATTACH_PROC),a14,L
;	movk	15,a0
;	move	a0,*a14(IMMOBILIZE_TIME)

	;target WHOIHIT
	SMRTTGT	a8,WHOIHIT

	CALLA	FIND_AND_KILL_ENDLESS
	movi	und_combo_punch_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEPK	20

	jruc	#lp

*******************************************************************************
#*
und_hdhold_combo2

#TIMEOUT	.equ	60

#lp0
	SLEEPK	1
#lp
	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrnz	#lp0
;	jrz	#cont
;	cmpi	MODE_HEADHELD,a0
;	jrnz	#lp0
;#cont
;In combo mode?
	calla	CHECK_COMBO_GO
	jrlt	#lp0


	clr	a11

	WAITSWITCH_DWN	J_TOWARD,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_TOWARD,0,#lp
	WAITSWITCH_DWN	B_KICK,J_ALL,#lp

	move	*a8(ANIBASE),a0,L
	cmpi	und_sliding_choke_anim,a0
	jrz	#lp0

	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrz	#slam
	cmpi	MODE_HEADHELD,a0
	jrnz	#lp0


#slam
	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

;Start combo rules here
;	move	*a8(ATTACH_PROC),a14,L
;	movk	15,a0
;	move	a0,*a14(IMMOBILIZE_TIME)

	;target WHOIHIT
	SMRTTGT	a8,WHOIHIT

	CALLA	FIND_AND_KILL_ENDLESS
	movi	und_combo_kick_anim,A14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEPK	20

	jruc	#lp

#******************************************************************************
;und_hdhold_anti_combo
;
;#TIMEOUT	.equ	80
;
;#lp0
;	SLEEPK	1
;#lp
;;Is my opponent in combo mode?
;;	move	*a8(IMMOBILIZE_TIME),a14
;;	jrz	#lp0
;;	move	*a8(CLOSEST_NUM),a0
;;	X32	a0
;;	addi	process_ptrs,a0
;;	move	*a0,a0,L
;;	move	*a0(COMBO_COUNT),a0
;;	jrz	#lp0
;
;	clr	a11
;
;	WAITSWITCH_DWN	B_SPUNCH,J_ALL,#lp
;
;	movi	#TIMEOUT,a11
;
;	WAITSWITCH_DWN	B_SPUNCH,J_ALL,#lp
;	WAITSWITCH_DWN	B_SPUNCH,J_ALL,#lp
;
;;Is my opponent in combo mode?
;	move	*a8(CLOSEST_NUM),a0
;	X32	a0
;	addi	process_ptrs,a0
;	move	*a0,a0,L
;	move	*a0(COMBO_COUNT),a0
;	jrz	#lp0
;
;	move	*a8(ANTI_COMBO_TIME),a0		;Time stamp
;	move	@PCNT,a14
;	sub	a0,a14
;	abs	a14
;	cmpi	80,a14
;	jrge	#lp0
;	move	*a8(I_WILL_DIE),A14
;	jrnz	#lp0
;
;;Combo breaker message!
;	CALLA	DO_REVERSAL
;	CALLA	DO_REVERSAL_MESS
;
;	clr	a0
;	move	a0,*a8(IMMOBILIZE_TIME)
;
;	move	*a8(WHOHITME),a14,L
;	movk	15,a0
;	move	a0,*a14(IMMOBILIZE_TIME)
;
;	;target WHOHITME
;	SMRTTGT	a8,WHOHITME
;
;	CALLA	FIND_AND_KILL_ENDLESS
;	movi	und_pile_anim,a14
;	move	a14,*a8(SPECIAL_MOVE_ADDR),L
;
;	WRSND	W_BAMBAM,GRABHOLD_T1,GRABHOLD_T2
;
;	SLEEPK	20
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
	CREATE	TAUNT_PID,do_taunt
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

	movi	und_secret_moves,a11
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
	.long	mode_puppet2		;17
	.long	mode_normal	;18
	.long	mode_headheld		;19
	.long	mode_puppet		;20
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

	move	*a13(I_WILL_DIE),a0
	jrz	#nope
	move	*a13(IMMOBILIZE_TIME),a0
	jrnz	#nope
;Player has died amidst a combo...
;Knock me down.
	movi	und_fall_back_anim,a0
	calla	change_anim1a

;Zero health bar
	movi	-10,a0
	move	*a13(PLYRNUM),a1
	calla	adjust_health

	SETMODE	DEAD

	clr	a0
	move	a0,*a13(I_WILL_DIE)

	rets

#nope
;Perhaps we need to interrupt any sequence when a wrstler has won?

	calla	get_opp_plyrmode
	cmpi	MODE_DEAD,a0
	jrne	#opp_not_dead

	;if closest is a zombie, skip pin section.
	calla	get_opp_process
	move	*a0(STATUS_FLAGS),a14
	btst	B_ZOMBIE,a14
	jrnz	#opp_not_dead
	
	;all opponents are dead.  Check for pins/raisearms

	;if we're attached to someone, don't interrupt it.
	move	*a13(ATTACH_PROC),a1,L
	jrz	#no_attch
	move	*a1(ATTACH_PROC),a2,L
	cmp	a2,a13
	jreq	#no_pin_yet
#no_attch

	;if a teammate has pinned, raise yer arm.
	calla	ck_teammate_pin	
	jrc	#raisearm

	;nobody has pinned.  if we're outside or all our opponents are
	; outside, do a raisearm.
	calla	raisearm_check
	jrc	#raisearm

	;we're inside with a pinnable opponent.  any button pins.
	move	*a13(BUT_VAL_CUR),a0
	jrz	#no_pin_yet

	;we have a press -- make sure opponent is on the ground
	calla	can_pin
	jrnc	#opp_notgnd

	;opponent is on the ground and close enough for anyone else
	; to pin.  Taker is funny, tho, and if you're not real close
	; and BEHIND the guy in Z, he just does a raise arm instead.

	;But he STILL sets the 'I did a pin flag' anyway.
	move	*a13(STATUS_FLAGS),a14
	ori	M_DID_PIN,a14
	move	a14,*a13(STATUS_FLAGS)

	;And we also set all the PINNED/WHOIPINNED/WHOPINNED me stuff
	calla	hit_nearest

	move	*a13(NEW_FACING_DIR),a0
	btst	MOVE_DOWN_BIT,a0
	jrz	#raisearm

	move	*a13(CLOSEST_ZDIST),a0
	cmpi	40h,a0
	jrge	#raisearm
	
	move	*a13(CLOSEST_XDIST),a0
	cmpi	35,a0
	jrge	#raisearm

	movi	und_4_pin2_anim,a0
	calla	change_anim1a

	;if we're a temp drone for auto-pin purposes, turn back into
	; a normal player here.
	calla	drone_change_back

	rets

#raisearm
	FACE24	und,raise_arm_anim
	calla	change_anim1a
	calla	set_raisearm_bit

	;if we're a temp drone for auto-pin purposes, turn back into
	; a normal player here.
	calla	drone_change_back

	rets

#too_far_to_pin
#opp_notgnd
#opp_not_dead
#no_pin_yet

	move	*a13(IMMOBILIZE_TIME),a0
	jrnz	#immobilized

	move	*a13(BUT_VAL_CUR),a0
	btst	PLAYER_BLOCK_BIT,a0	;maybe have to action tables?
	jrz	#nblk			;1 for down transitions
	callr	#block			;& 1 for current buttons
	jrc	#nblk
	clr	a0
	move	a0,*a13(ATTACK_TYPE)
	rets
#nblk
	move	*a13(BUT_VAL_CUR),a0
	andi	011111b,a0
	cmpi	PLAYER_PUNCH_VAL|PLAYER_KICK_VAL,a0
	jrz	#punchkick

	move	*a13(BUT_VAL_DOWN),a0
	andi	011111b,a0
	X32	a0
	addi	#action_table,a0
	move	*a0,a0,L
	call	a0

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_interrupt


	move	*a13(STICK_VAL_CUR),a0
	move	a0,*a13(MOVE_DIR)
	calla	climb_turnbuckle
	jrnc	#no_climb
	move	*a13(WRESTLERNUM),A5
	MOVI	CLIMB_ROPES,A2
	MOVI	1000,A0
	CALLA	ADD_IF_SILENT
	rets

#immobilized
	clr	a14
	move	a14,*a13(MOVE_DIR)
#no_climb
	calla	execute_walk

#no_interrupt
	rets

#action_table
	.long	#z,#punch,#block,#block			;0-3
	.long	#super_punch,#super_punch,#block,#block	;4-7
	.long	#kick,#punchkick,#block,#block		;8-11
	.long	#super_punch,#punchkick,#block,#block	;12-15
	.long	#super_kick,#super_kick,#block,#block	;16-19
	.long	#graboh,#graboh,#block,#block		;20-23
	.long	#super_kick,#punchkick,#block,#block	;24-27
	.long	#graboh,#graboh,#block,#block		;28-31


************
#z


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
	JJXM	ONGROUND,	160,140,#punch_lbowdrop,#punch_punch
	JJXM	BOUNCING,	 75, 45,#punch_hdbutt,#punch_punch
	JJXM	ONTURNBKL,	 75, 45,#punch_hdbutt,#punch_punch
	JJXM	CLIMBTURNBKL,		#punch_punch
	JJXM	INAIR,		 75, 45,#punch_hdbutt,#punch_punch
	JJXM	ATTACHED,	 75, 45,#punch_hdbutt,#punch_punch
	JJXM	DEAD,		160,140,#punch_lbowdrop,#punch_punch
	JJXM	OPPOVERHEAD,	 75, 45,#punch_hdbutt,#punch_punch
	JJXM	WAITANIM,	 75, 45,#punch_hdbutt,#punch_punch
	JJXM	GRAPPLE,	 75, 45,#punch_hdbutt,#punch_punch
	JJXM	MASTER,		 75, 45,#punch_hdbutt,#punch_punch
	JJXM	SLAVE,		 75, 45,#punch_hdbutt,#punch_punch
	JJXM	HEADHOLD,	 75, 45,#punch_hdbutt,#punch_punch
	JJXM	HEADHELD,	 75, 45,#punch_hdbutt,#punch_punch
	JJXM	CHOKEHOLD,	 75, 45,#punch_hdbutt,#punch_punch
	JJXM	PUPPET,		 75, 45,#punch_hdbutt,#punch_punch
	JJXM	PUPPET2,	 75, 45,#punch_hdbutt,#punch_punch
	JJXM	INAIR2,		 75, 45,#punch_hdbutt,#punch_punch
	JJXM_END

#punch_rets
	rets

*****
#punch_punch
std_punch

	FACE24	und,punch_anim
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
#punch_hiptoss
;std_hiptoss

	rets


************
#block		;2

std_block
	move	@blocking_off,a0
	jrnz	#no_blocking

	RND_AWARD	a13,BLOCKS_AWD

	movi	und_4_block_anim,a0
	calla	change_anim1

	calla	BLOCK_WOOSH

	clr	a0
	move	a0,*a13(BLOCK_TIME)
	clrc
	rets

#no_blocking
	setc
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
	JJXM	NORMAL,		 95, 35,#spunch_special,#spunch_slap	;0
	JJXM	RUNNING,	 95, 35,#spunch_special,#spunch_slap	;1
	JJXM	INAIR,		 95, 35,#spunch_special,#spunch_slap	;2
	JJXM	ATTACHED,	 95, 35,#spunch_special,#spunch_slap	;3
	JJXM	ONGROUND,	160,140,#spunch_lbowdrop,std_punch	;4
	JJXM	BOUNCING,	 95, 35,#spunch_special,#spunch_slap	;1
	JJXM	ONTURNBKL,	 	#spunch_slap			;6
	JJXM	BLOCK,		 95, 35,#spunch_special,#spunch_slap	;7
	JJXM	DIZZY,		 95, 35,#spunch_special,#spunch_slap	;8
	JJXM	DEAD,		160,140,#spunch_lbowdrop,std_punch	;9
	JJXM	OPPOVERHEAD,	 95, 35,#spunch_special,#spunch_slap	;10
	JJXM	CLIMBTURNBKL,		std_punch			;11
	JJXM	WAITANIM,	 95, 35,#spunch_special,#spunch_slap	;12
	JJXM	GRAPPLE,	 95, 35,#spunch_special,#spunch_slap	;13
	JJXM	MASTER,		 95, 35,#spunch_special,#spunch_slap	;14
	JJXM	SLAVE, 		 95, 35,#spunch_special,#spunch_slap	;15
	JJXM	HEADHOLD,	 95, 35,#spunch_special,#spunch_slap	;16

	JJXM	HEADHELD,	 	do_pile
;PILE
	JJXM	CHOKEHOLD,	 95, 35,#spunch_special,#spunch_slap	;16
	JJXM	PUPPET,		 95, 35,#spunch_special,#spunch_slap	;20
	JJXM	PUPPET2,	 95, 35,#spunch_special,#spunch_slap	;20
	JJXM	INAIR2,		 95, 35,#spunch_special,#spunch_slap	;21
	JJXM_END

#spunch_rets
	rets

#graboh		;8
#spunch_slap
;jumping punch attack
	FACE24	und,slap_anim
	calla	change_anim1a

	WRSND	W_TAKER,GRABHOLD_T1,GRABHOLD_T2

	rets

*****
#spunch_special
;If stick is toward opponent, then do quick head hold
	move	*a13(STICK_VAL_CUR),a0
	btst	MOVE_DOWN_BIT,a0
	jrnz	#ck_up
;	move	*a13(NEW_FACING_DIR),a1
;	andi	0ch,a1
;	cmp	a0,a1
;	jrz	#cont

	move	*a13(CLOSEST_XDIST),a1
	cmpi	70,a1
	jrgt	#spunch_slap

;#cont
;	movi	und_3_head_hold2_anim,a0
;	calla	change_anim1a
;
;	WRSND	W_TAKER,GRABHOLD_T1,GRABHOLD_T2
;	rets
;#hdbutt

	FACE24	und,butts_anim
	calla	change_anim1

	WRSND	W_TAKER,HDBUTT_T1,HDBUTT_T2

	rets
#ck_up
;Do uppercut
	FACE24	und,uppercut_anim
	calla	change_anim1

	WRSND	W_TAKER,HDBUTT_T1,HDBUTT_T2
	rets


*****
#spunch_lbowdrop
;If near opponents head, and facing down, do the hair grab!
;Allow hair grab from below!

;	move	*a13(FACING_DIR),a14
;	btst	MOVE_DOWN_BIT,a14
;	jrz	#no

	move	*a13(CLOSEST_NUM),a14
	X32	a14

	addi	process_ptrs,a14
	move	*a14,a14,L
	move	*a14(PLYRMODE),a2
	cmpi	MODE_DEAD,a2
	jrz	#no
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
	JJXM	RUNNING,	 65, 92,#kick_knee,#kick_kick
	JJXM	INAIR,		 65, 92,#kick_knee,#kick_kick
	JJXM	ATTACHED,	 65, 92,#kick_knee,#kick_kick
	JJXM	ONGROUND,	160,140,#kick_stomp,#kick_kick
	JJXM	BOUNCING,	 65, 92,#kick_knee,#kick_kick
	JJXM	ONTURNBKL,	 	#kick_kick
	JJXM	BLOCK,		 65, 92,#kick_knee,#kick_kick
	JJXM	DIZZY,		 65, 92,#kick_knee,#kick_kick
	JJXM	DEAD,		160,140,#kick_stomp,#kick_kick
	JJXM	OPPOVERHEAD,	 65, 92,#kick_knee,#kick_kick
	JJXM	CLIMBTURNBKL,	 	#kick_kick
	JJXM	WAITANIM,   	 65, 92,#kick_knee,#kick_kick
	JJXM	GRAPPLE,    	 65, 92,#kick_knee,#kick_kick
	JJXM	MASTER,		 65, 92,#kick_knee,#kick_kick
	JJXM	SLAVE,	    	 65, 92,#kick_knee,#kick_kick
	JJXM	HEADHOLD,	 65, 92,#kick_knee,#kick_kick
	JJXM	HEADHELD,	 65, 92,#kick_knee,#kick_kick
	JJXM	CHOKEHOLD,	 65, 92,#kick_knee,#kick_kick
	JJXM	PUPPET,		 65, 92,#kick_knee,#kick_kick
	JJXM	PUPPET2,	 65, 92,#kick_knee,#kick_kick
	JJXM	INAIR2,		 	#kick_TB
	JJXM_END

*****
#kick_TB

	.ref	und_kick_TB_anim
	movi	und_kick_TB_anim,a0
	calla	change_anim1a

	WRSND	W_TAKER,KICK_T1,KICK_T2

	rets

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
std_knee

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
	JJXM	ONGROUND,	160,140,#skick_stomp,std_kick		;4
	JJXM	BOUNCING,	 	#skick_bigboot			;5
	JJXM	ONTURNBKL,	 60, 96,#skick_kick,std_kick		;6
	JJXM	BLOCK,		 60, 60,#skick_special,#skick_kick	;7
	JJXM	DIZZY,		 60, 60,#skick_special,#skick_kick	;8
	JJXM	DEAD,		160,140,#skick_stomp,std_kick		;9
	JJXM	OPPOVERHEAD,	 60, 60,#skick_special,#skick_kick	;10
	JJXM	CLIMBTURNBKL,	 60, 96,#skick_kick,std_kick		;11
	JJXM	WAITANIM,	 60, 62,#skick_special,#skick_kick	;12
	JJXM	GRAPPLE,	 60, 62,#skick_special,#skick_kick	;13
	JJXM	MASTER,		 60, 62,#skick_special,#skick_kick	;14
	JJXM	SLAVE, 		 60, 62,#skick_special,#skick_kick	;15
	JJXM	HEADHOLD,	 60, 62,#skick_special,#skick_kick	;16
	JJXM	HEADHELD,	 	std_kick
	JJXM	CHOKEHOLD,	 60, 62,#skick_special,#skick_kick	;16
	JJXM	PUPPET,		 60, 62,#skick_special,#skick_kick	;20
	JJXM	PUPPET2,	 60, 62,#skick_special,#skick_kick	;20
	JJXM	INAIR2,		 	#kick_TB
	JJXM_END

*****
#skick_kick
	FACE24	und,super_kick_anim
	calla	change_anim1a

	WRSND	W_TAKER,FLYKICK_T1,FLYKICK_T2
	rets


*****
#skick_special
;If stick is toward opponent, then do quick punches
	move	*a13(STICK_VAL_CUR),a0
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrz	#cont2

	FACE24	und,knee_anim
	calla	change_anim1a

	WRSND	W_TAKER,KICK_T1,KICK_T2

	rets

#cont2
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

#XRUN_VAL	equ	UND_XRUN
#ZDRIFT_VAL	equ	UND_ZDRIFT

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
	move	@hyper_speed_on,a14
	sll	a14,a0
	move	a0,*a13(OBJ_XVEL),L

#no_vel

	move	*a13(GETUP_TIME),a0		;delay b4 gaining control
	jrnz	#out_of_control

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_interrupt

	move	*a13(STICK_VAL_CUR),a0
	move	*a13(MOVE_DIR),a1
	or	a0,a1
	andi	MOVE_LEFT|MOVE_RIGHT,a1
	cmpi	MOVE_LEFT|MOVE_RIGHT,a1
	jrne	#continue_run

	;braking with stick.  abort run.

	SETMODE	NORMAL

#continue_run
#no_interrupt

	move	*a13(STICK_VAL_CUR),a0
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

;Delay reading buttons after just getting out of an out of control run
;so a mistaken move isn't fired off
	move	*a13(DELAY_BUTNS),a0
	jrnz	#out_of_control


	move	*a13(BUT_VAL_DOWN),a0
	andi	011111b,a0
	X32	a0
	addi	#action_table,a0
	move	*a0,a0,L
	call	a0
#out_of_control
	rets

#action_table
	.long	#z,#punch,#block,#block			;0-3
	.long	#super_punch,#super_punch,#block,#block	;4-7
	.long	#kick,#punchkick,#block,#block		;8-11
	.long	#super_punch,#punchkick,#block,#block	;12-15
	.long	#super_kick,#super_kick,#block,#block	;16-19
	.long	#graboh,#graboh,#block,#block		;20-23
	.long	#super_kick,#punchkick,#block,#block	;24-27
	.long	#graboh,#graboh,#block,#block		;28-31


************
#z
	rets

************
#punch		;1
#super_punch	;4
#punchkick
#graboh
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
	JJXM	CHOKEHOLD,		#punch_clothesline
	JJXM	PUPPET,			#punch_clothesline
	JJXM	PUPPET2,		#punch_clothesline
	JJXM	INAIR2,			#punch_clothesline
	JJXM_END

#punch_rets
	rets

*****
#punch_clothesline

	;don't do it if you're running away from your opponent.
	move	*a13(FACING_DIR),a0
	move	*a13(NEW_FACING_DIR),a1
	and	a0,a1
	andi	MOVE_LEFT|MOVE_RIGHT,a1
	jrz	#z

	clr	a0
	move	a0,*a13(RUN_TIME)

	SETMODE	NORMAL

	move	*a13(CLOSEST_XDIST),a1
	cmpi	70,a1
	jrlt	#hdbutt

	.ref	und_2_run_slap_anim
	.ref	und_4_run_slap_anim
	FACE24	und,run_slap_anim
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
	JJXM	CHOKEHOLD,		#kick_flyingkick
	JJXM	PUPPET,			#kick_flyingkick
	JJXM	PUPPET2,		#kick_flyingkick
	JJXM	INAIR2,			#kick_flyingkick
	JJXM_END

#kick_rets
	rets

*****
#kick_flyingkick

	calla	ck_ignore
	jrc	#z

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

;	;check unint
;	move	*a13(ANIMODE),a14
;	btst	MODE_UNINT_BIT,a14
;	jrnz	#no_interrupt

	move	*a13(STICK_VAL_CUR),a0
	btst	PLAYER_DOWN_BIT,a0
	jrz	#no_climbdown

	movi	und_climb_down_anim,a0
	calla	change_anim1a

	SETMODE	CLIMBTURNBKL

#no_interrupt
	rets

#no_climbdown
	move	*a13(BUT_VAL_DOWN),a0
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
	.long	#z,#punch,#block,#block			;0-3
	.long	#super_punch,#super_punch,#block,#block	;4-7
	.long	#kick,#punchkick,#block,#block		;8-11
	.long	#super_punch,#punchkick,#block,#block	;12-15
	.long	#super_kick,#super_kick,#block,#block	;16-19
	.long	#graboh,#graboh,#block,#block		;20-23
	.long	#super_kick,#punchkick,#block,#block	;24-27
	.long	#graboh,#graboh,#block,#block		;28-31

************
#z
	rets

************
#punch		;1
#block		;2
#super_punch	;4
#kick		;8
#super_kick	;16
#graboh
#punchkick

	SETMODE	INAIR

	movi	und_tbukl_butt_drop_anim,a0
	calla	change_anim1a

	WRSND	W_TAKER,FLYKICK_T1,FLYKICK_T2

	rets

#*****************************************************************************
* blocking

mode_block	;7

	move	*a13(BLOCK_TIME),a0
	inc	a0
	move	a0,*a13(BLOCK_TIME)
	cmpi	160,a0
	jrlt	#no

	calla	get_opp_plyrmode
	cmpi	MODE_BLOCK,a0
	jrnz	#no
	move	*a13(CLOSEST_XDIST),a0
	cmpi	61h,a0
	jrge	#no
	cmpi	45,a0
	jrlt	#no
	move	*a13(CLOSEST_ZDIST),a0
	cmpi	30,a0
	jrlt	#punchblock

#no
	move	*a13(BUT_VAL_DOWN),a0
	andi	011111b,a0
	jrz	#no_interrupt

	;press.  if block isn't down, let mode_normal handle it
	move	a0,a2			;save a0 from ...val_down
	move	*a13(BUT_VAL_CUR),a0
	btst	PLAYER_BLOCK_BIT,a0
	jrz	#set_mode_normal
	move	a2,a0			;restore a0 from ...val_down

	X32	a0
	addi	#action_table,a0
	move	*a0,a0,L
	call	a0

#no_interrupt
	rets

#set_mode_normal
	SETMODE	NORMAL
	jruc	mode_normal

#action_table
	.long	#z,#punchblock,#z	;0-2
	.long	#punchblock		;3
	.long	#z,#z,#z,#z,#z,#z,#z	;4-10
	.long	#z,#z,#z,#z,#z,#z,#z	;11-17
	.long	#z,#z,#z,#z,#z,#z,#z	;18-24
	.long	#z,#z,#z,#z,#z,#z,#z	;25-31

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

	movi	und_4_push_anim,a0
	calla	change_anim1a

	WRSND	W_TAKER,PUSH_T1,PUSH_T2

	rets


#*****************************************************************************
* taker with zero health

mode_dizzy	;8

;	move	*a13(GETUP_TIME),a0
;	jrnz	#still_going
;
;	calla	clear_damage_log
;
;	clr	a0
;	move	a0,*a13(STARS_FLAG)
;
;	SETMODE	NORMAL
;
;#still_going
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
	move	*a13(ANIBASE),a0,L
	cmpi	und_sliding_choke_anim,a0
	jrnz	#norm
	move	*a13(CUR_FRAME),a0,L
	.ref	U2LN2A
	movi	U2LN2A+FR6,a1
	move	*a1,a1,L
	cmp	a1,a0
	jrz	mode_chokehold
	rets
#norm
;Bozo power move
	.ref	bozo_check
	calla	bozo_check
	jrnc	#fail

	WRSND	W_BAMBAM,GRABHOLD_T1,GRABHOLD_T2

	movi	und_neckbreaker_anim,a0
	move	@PCNT,a14
	btst	0,a14
	jrz	#tag
	movi	und_pile_anim,a0
#tag	calla	change_anim1a

	rets

#fail
	move	*a13(WHOIHIT),a0,L
	move	*a0(PLYRMODE),a0
	cmpi	MODE_HEADHELD,a0
	jrnz	#exit

;	move	*a13(ATTACH_PROC),a10,L
;	jrz	#exit

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_interrupt

	move	*a13(BUT_VAL_DOWN),a0
	andi	011111b,a0
	X32	a0
	addi	#action_table,a0
	move	*a0,a0,L
	call	a0

#no_interrupt
	rets

#exit
	move	*a13(OBJ_ZPOS),a14,L
	subi	[6,0],a14
	move	a14,*a13(OBJ_ZPOS),L

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
	.long	#z,#punch,#block,#block			;0-3
	.long	#super_punch,#super_punch,#block,#block	;4-7
	.long	#kick,#punchkick,#block,#block		;8-11
	.long	#super_punch,#punchkick,#block,#block	;12-15
	.long	#super_kick,#super_kick,#block,#block	;16-19
	.long	#graboh,#graboh,#block,#block		;20-23
	.long	#super_kick,#punchkick,#block,#block	;24-27
	.long	#graboh,#graboh,#block,#block		;28-31


************
#block
#graboh
#z		;0
	rets

************

#punch		;1
;If stick is toward opponent, then do quick punches
	CALLA	FIND_AND_KILL_ENDLESS
	move	*a13(STICK_VAL_CUR),a0
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrnz	#tag2
	movi	und_4_knee_butts_anim,a0
	calla	change_anim1a
	rets

#tag2
	.ref	und_4_knee2_anim
	movi	und_4_knee2_anim,a0
	calla	change_anim1a
	rets

************
#super_punch	;4
do_pile
;This flag is only set if taker has done repeated uppercuts!

	move	*a13(USR_VAR2),a0
	jrz	#upper

	CALLA	FIND_AND_KILL_ENDLESS

	move	*a13(STICK_VAL_CUR),a0
	btst	PLAYER_DOWN_BIT,a0
	jrz	#z

	movi	und_pile_anim,a0
	calla	change_anim1a
	rets

#upper
	move	*a13(STICK_VAL_CUR),a0
	btst	PLAYER_DOWN_BIT,a0
	jrz	#z

;	SPCDMG	D_UPRCUT/2,15

	CALLA	FIND_AND_KILL_ENDLESS
	FACE24	und,uppercut_anim
	calla	change_anim1a
	rets


#punchkick
#kick
	CALLA	FIND_AND_KILL_ENDLESS
	move	*a13(STICK_VAL_CUR),a0
	btst	PLAYER_DOWN_BIT,a0
	jrz	#knee

	movi	und_4_knee2_anim,a0
	calla	change_anim1a
	rets

#knee
	movi	und_4_knee2_anim,a0
	calla	change_anim1a
	rets

#super_kick	;16
;If stick is toward opponent, then do quick knees
;	move	*a13(STICK_VAL_CUR),a0
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
mode_puppet2	;17

;	;check for the head-grab breaker
;	move	*a13(BUT_VAL_DOWN),a0
;	btst	PLAYER_KICK_BIT,a0
;	jrz	#out
;
;	;check the time - must do it within 20 ticks
;	move	*a13(HEAD_GRAB_TIME),a14
;	move	@PCNT,a0
;	sub	a14,a0
;	cmpi	KICK_OUT,a0
;	jrgt	#out
;
;	move	*a13(PLYR_TYPE),a14
;	cmpi	PTYPE_DRONE,a14
;	jrz	#out
;
;	;okay, waste 'im. - detach, setmode, immobilize, and launch the knee
;	move	*a13(ATTACH_PROC),a0,L
;	clr	a14
;	move	a14,*a13(ATTACH_PROC),L
;	move	a14,*a0(ATTACH_PROC),L
;	movi	15,a14
;	move	a14,*a0(IMMOBILIZE_TIME)
;	SETMODE	NORMAL
;	jruc	std_knee
;
;#out
	rets

#*****************************************************************************
mode_headheld	;19
	move	*a13(ANIMODE),a0
	btst	MODE_NOGRAVITY_BIT,a0
	janz	mode_choking


;Bozo reversal
	calla	bozo_check
	jrnc	#fail

	PUSH	a8
	move	a13,a8
	CALLA	DO_REVERSAL
	CALLA	DO_REVERSAL_MESS
	PULL	a8

	WRSND	W_BAMBAM,GRABHOLD_T1,GRABHOLD_T2

	movi	und_neckbreaker_anim,a0
	move	@PCNT,a14
	btst	0,a14
	jrz	#tag
	movi	und_pile_anim,a0
#tag	calla	change_anim1a

	rets
#fail

;He may have let me go by hitting his block butn!
	move	*a13(ATTACH_PROC),a0,L
	jrnz	#no_luck

;Make sure this guy is on ground
	move	*a13(OBJ_YPOSINT),a0
	move	*a13(GROUND_Y),a1
	cmp	a1,a0			;a0-a1
	jrgt	#no_luck

;hit_gnd

	movi	und_3_head_held_stand_anim,a0
	calla	change_anim1a

#no_luck
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

	move	*a13(BUT_VAL_DOWN),a0
	andi	011111b,a0
	jrz	#no_interrupt

	move	*a13(ATTACH_PROC),a1,L
	movk	30,a14
	move	a14,*a1(IMMOBILIZE_TIME)

	X32	a0
	addi	#action_table,a0
	move	*a0,a0,L
	call	a0

#no_interrupt
	rets

#action_table
	.long	#z,#punch,#block,#block			;0-3
	.long	#super_punch,#super_punch,#block,#block	;4-7
	.long	#kick,#punchkick,#block,#block		;8-11
	.long	#super_punch,#punchkick,#block,#block	;12-15
	.long	#super_kick,#super_kick,#block,#block	;16-19
	.long	#graboh,#graboh,#block,#block		;20-23
	.long	#super_kick,#punchkick,#block,#block	;24-27
	.long	#graboh,#graboh,#block,#block		;28-31

************
#z		;0
#block		;2
	rets

************
#punch		;1
#punchkick

	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	SETMODE	NORMAL

	move	*a13(STICK_VAL_CUR),a0
	btst	MOVE_UP_BIT,a0
	jrz	#reg

	CALLA	FIND_AND_KILL_ENDLESS

	SETMODE	HEADHOLD

	move	*a13(WHOIHIT),a0,L
	movi	MODE_HEADHELD,a14
	move	a14,*a0(PLYRMODE)

;Make sure victim knows he is not in chokehold anymore
	move	*a0(ANIMODE),a14
	andni	MODE_NOGRAVITY,a14
	move	a14,*a0(ANIMODE)

	movi	und_4_knee_butts_anim,a0
	calla	change_anim1a
	WRSND	W_TAKER,HDBUTT_T1,HDBUTT_T2

	rets
#reg
	CALLA	FIND_AND_KILL_ENDLESS
	movi	und_2_butt_anim,a0
	calla	change_anim1a
	WRSND	W_TAKER,HDBUTT_T1,HDBUTT_T2

	rets

************
#super_punch	;4
#graboh

;Check for uppercut
	move	*a13(STICK_VAL_CUR),a0
	btst	MOVE_DOWN_BIT,a0
	jrz	#punch

	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	SETMODE	NORMAL

	CALLA	FIND_AND_KILL_ENDLESS
	FACE24	und,uppercut_anim
	calla	change_anim1

	WRSND	W_TAKER,HDBUTT_T1,HDBUTT_T2
	rets

#super_kick	;16
;If stick is toward opponent, then do quick punches
	move	*a13(STICK_VAL_CUR),a0
	btst	PLAYER_DOWN_BIT,a0
	jrnz	#tag
	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	SETMODE	NORMAL

	CALLA	FIND_AND_KILL_ENDLESS
	movi	und_2_knee_anim,a0
	calla	change_anim1a
	rets

#kick		;8
;	move	*a13(STICK_VAL_CUR),a0
;	btst	PLAYER_DOWN_BIT,a0
;	jrnz	#tag0

	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	SETMODE	NORMAL

	CALLA	FIND_AND_KILL_ENDLESS
	movi	und_2_knee_anim,a0
	calla	change_anim1a
	rets

;#tag0
;	SETMODE	NORMAL
;
;	CALLA	FIND_AND_KILL_ENDLESS
;
;	movi	und_choke_face_slam_anim,a0
;	calla	change_anim1a
;
;	WRSND	W_TAKER,KICK_T1,KICK_T2
;
;	rets
#tag
	SETMODE	NORMAL

	CALLA	FIND_AND_KILL_ENDLESS
	movi	und_chokeslam_anim,a0
	calla	change_anim1a

	WRSND	W_TAKER,KICK_T1,KICK_T2

	rets

************

#lost_him
	CALLA	FIND_AND_KILL_ENDLESS
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

;	move	*a13(GETUP_TIME),a0
;	jrz	#fall_out
	rets


#fall_out
	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	CALLA	FIND_AND_KILL_ENDLESS
	SETMODE	NORMAL
	movi	MODE_NORMAL,a0
	move	a0,*a13(ANIMODE)

	rets


#*****************************************************************************

;#VEL	equ	30000h		;38000h	;30000h
;#DVEL	equ	21f0eh		;27978h	;21f0eh
;#VEL	equ	38000h		;38000h	;30000h
;#DVEL	equ	30000h		;27978h	;21f0eh
#VEL	equ	3a000h		;38000h	;30000h
#DVEL	equ	31000h		;27978h	;21f0eh


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