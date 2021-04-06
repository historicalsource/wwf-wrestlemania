**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		5/18/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"shawn.asm"
	.title	"Shawn Michaels-specific game code"
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
	.include	"lifebar.h"
	.include	"jjxm.h"
	.include	"damage.equ"


******************************************************************************
* EXTERNAL REFERENCES

	.ref	change_anim1a,change_anim2a,do_taunt
	.ref	shn_2_hair_pickup_anim,bounce_off_ropes
	.ref	check_secret_moves,ck_teammate_pin,raisearm_check
	.ref	master_keep_attached,round_award,set_raisearm_bit
	.ref	ck_ignore,climb_turnbuckle,execute_walk,get_opp_plyrmode
	.ref	get_punch_dtime,get_opp_process,std_taunt,std_walk_fast
	.ref	process_ptrs,form_button_value,keep_attached,change_anim1
	.ref	change_anim2,halve_combo_meter,HALT
	.ref	mode_inair2,mode_choking,mode_puppet
	.ref	JUMP_ROPES,DO_REVERSAL,DO_REVERSAL_MESS
	.ref	CHECK_COMBO_GO,FIND_AND_KILL_ENDLESS
	.ref	CLIMB_ROPES,ADD_IF_SILENT,PCNT
	.ref	get_powerk_dtime,drone_change_back

	.ref	BONUS_MESS,can_pin
	.ref	blocking_off
	.ref	hyper_speed_on
	.ref	in_finish_move
	.ref	p1rounds,p2rounds
	.if NUM_SHAWN_FINISHES
	.ref	shn_finish1_move
	.if NUM_SHAWN_FINISHES > 1
	.ref	shn_finish2_move
	.endif
	.endif

******************************************************************************
* ANIMATION SEQUENCES

	.ref	shn_rpt_hdbutts_anim
	.ref	shn_3_head_hold2_anim
	.ref	shn_3_head_hold_anim
	.ref	start_run_anim

	;stands
	.ref	shn_stand2_anim,shn_stand8_anim
	.ref	shn_stand4_anim,shn_stand6_anim
	.ref	shn_torso2_anim,shn_torso8_anim
	.ref	shn_torso4_anim,shn_torso6_anim
	.ref	shn_3_head_held_stand_anim

	;turns
	.ref	shn_2_to_4_turn_anim,shn_8_to_6_turn_anim	;stand
	.ref	shn_4_to_2_turn_anim,shn_6_to_8_turn_anim
	.ref	shn_4_to_6_turn_anim,shn_6_to_4_turn_anim
	.ref	shn_2_to_8_turn_anim,shn_8_to_2_turn_anim
	.ref	shn_4_to_8_turn_anim,shn_6_to_2_turn_anim
	.ref	shn_2_to_6_turn_anim,shn_8_to_4_turn_anim

	.ref	shn_2_to_4_turn2_anim,shn_8_to_6_turn2_anim	;torso
	.ref	shn_4_to_2_turn2_anim,shn_6_to_8_turn2_anim
	.ref	shn_4_to_6_turn2_anim,shn_6_to_4_turn2_anim
	.ref	shn_2_to_8_turn2_anim,shn_8_to_2_turn2_anim
	.ref	shn_4_to_8_turn2_anim,shn_6_to_2_turn2_anim
	.ref	shn_2_to_6_turn2_anim,shn_8_to_4_turn2_anim

	;walks
	.ref	shn_walk1_f2_anim,shn_walk2_f2_anim,shn_walk4_f2_anim
	.ref	shn_walk5_f2_anim,shn_walk6_f2_anim,shn_walk8_f2_anim
	.ref	shn_walk1_f4_anim,shn_walk2_f4_anim,shn_walk4_f4_anim
	.ref	shn_walk5_f4_anim,shn_walk6_f4_anim,shn_walk8_f4_anim

	.ref	shn_run2_anim,shn_climb_down_anim,shn_climb_up_anim

	;mundane attacks
	.ref	shn_2_punch_anim,shn_4_punch_anim
	.ref	shn_2_kick_anim,shn_4_kick_anim
	.ref	shn_4_push_anim
	.ref	shn_2_butt_anim,shn_4_butt_anim
	.ref	shn_2_knee_anim,shn_4_knee_anim
	.ref	shn_2_stomp_anim,shn_4_stomp_anim
	.ref	shn_2_falling_punch_anim,shn_4_falling_punch_anim
	.ref	shn_bstomp_anim,shn_belbow_anim
	.ref	shn_flipslam_anim

	;special attacks
	.ref	shn_4_hair_pickup_anim
	.ref	shn_spinkick_anim,shn_flying_kick_anim
	.ref	shn_gsuplex_anim,shn_run_stomp_anim
	.ref	shn_2_raise_arm_anim,shn_4_raise_arm_anim
	.ref	shn_super_speedkick_anim
	.ref	shn_fstein_anim
	.ref	shn_2_pin_anim,shn_4_pin_anim
	.ref	shn_2_hiptoss_anim
	.ref	shn_4_hiptoss_anim
	.ref	shn_2_hiptoss2_anim
	.ref	shn_4_hiptoss2_anim
	.ref	shn_speed_spinkick_anim,shn_knee_fstein_anim
	.ref	shn_sliding_kicktoss_anim,shn_break_arm_anim
	.ref	shn_4_jump_kick_anim
	.ref	shn_gsuplex_run_anim

;	.ref	shn_pkup_chair_anim
	.ref	shn_2_slap_anim,shn_4_slap_anim
	.ref	shn_4_pummel_anim,shn_2_pummel_anim

	;reactions
	.ref	shn_dizzy_anim,shn_fall_back_anim
	.ref	shn_2_grabfling_anim,shn_4_grabfling_anim

	;blocks
	.ref	shn_4_block_anim

	;combos
	.ref	shn_combo_kick_anim,shn_combo_punch_anim
	.ref	BLOCK_WOOSH

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* special moves
*

shn_secret_moves
	.long	#charge_flying_kick	;must have this one
	.long	#grab_fling
	.long	#hip_toss
	.long	#grab_fling2
	.long	#hip_toss2
	.long	#neck_grab
	.long	#frankensteiner
	.long	#jump_kick
	.long	0

*****************************************************************************
*
* SPECIAL MOVE PROCESSES
*

 SUBR	shn_smove_table
	.long	shn_hdhold_combo2
	.long	shn_hdhold_combo1
	.long	shn_charge_suplex
	.long	shn_swirl_speedkick
	.long	shn_sliding_kicktoss
	.long	shn_hdhold_suplex
	.long	shn_hdhold_frank
	.long	shn_hdhold_kicktoss
	.long	shn_hdhold_butts
	.long	shn_flipslam		;Can do from headhold also
	.long	shn_grab_toss_air
;	.long	std_hdhold_anti_combo
	.long	std_walk_fast
	.long	std_taunt

	.if NUM_SHAWN_FINISHES
	.long	shn_finish_move1
	.endif
	.if NUM_SHAWN_FINISHES > 1
	.long	shn_finish_move2
	.endif
	.long	0

*******************************************************************************

#jump_kick
	.word	B_SKICK,		J_ALL
	.word	J_AWAY,			J_REAL_LR | J_UP | J_DOWN
	.word	J_AWAY,			J_REAL_LR | J_UP | J_DOWN
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

	movi	shn_4_jump_kick_anim,a0
	calla	change_anim1a

	WRSND	W_SHAWN,FLYKICK_T1,FLYKICK_T2

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
;	cmpi	MODE_BLOCK,a0
;	jrz	#out
	cmpi	MODE_DEAD,a0
	jrz	#out
	cmpi	MODE_HEADHELD,a0
	jrz	#out
	cmpi	MODE_INAIR,a0
	jrz	#doit
	cmpi	MODE_INAIR2,a0
	jrz	#doit

	move	*a13(CLOSEST_DIST),a0
	cmpi	70h,a0
	jrgt	#out

#doit
	FACE24	shn,hiptoss_anim
	calla	change_anim1a

	WRSND	W_SHAWN,HIPTOSS_T1,PUNCH_T2
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
	FACE24	shn,hiptoss_anim
	calla	change_anim1a

	WRSND	W_SHAWN,GRABFLING_T1,PUNCH_T2
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

;	move	*a13(LAST_FLING_ATTEMPT),a14,L
;	move	@PCNT,a0,L
;	sub	a14,a0
;	cmpi	3*60,a0
;	jrge	#ok2
;
;	FACE24	shn,slap_anim
;	calla	change_anim1a
;
;	WRSND	W_SHAWN,SPUNCH_T1,SPUNCH_T2
;	rets
;
;#ok2
;	move	@PCNT,a14,L			;use 32-bit PCNT!
;	move	a14,*a13(LAST_FLING_ATTEMPT),L

	FACE24	shn,grabfling_anim
	calla	change_anim1a

	WRSND	W_SHAWN,GRABFLING_T1,PUNCH_T2
	rets

*******************************************************************************

#neck_grab
	.word	B_SPUNCH,		J_ALL
	.word	J_TOWARD,		J_REAL_LR
	.word	J_TOWARD,		J_REAL_LR
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

	move	*a13(LAST_HEADHOLD),a14,L
	move	@PCNT,a0,L
	sub	a14,a0
	cmpi	2*60,a0
	jrge	#ok2a

;This head grab is too close (in terms of time) to most recent grab
	.ref	shn_3_fake_hold_anim
	movi	shn_3_fake_hold_anim,a0
	calla	change_anim1a
	rets

#ok2a
	move	*a13(CLOSEST_XDIST),a1
	cmpi	90,a1
	jrgt	#std_grab

	movi	shn_3_head_hold2_anim,a0
	calla	change_anim1a
#out	rets

#std_grab
	movi	shn_3_head_hold_anim,a0
	calla	change_anim1a
	rets

*******************************************************************************

#charge_flying_kick
	move	*a13(BUT_VAL_UP),a0
	btst	PLAYER_SKICK_BIT,a0
	jrz	#no_kick

	move	*a13(PLYRNUM),a0
	calla	get_powerk_dtime
	cmpi	85,a0			;> min?
	jrlt	#no_kick

	callr	#scrt_kick
	setc
	rets

#no_kick
	clrc
	rets

#scrt_kick

	move	*a13(PLYRMODE),a0
	cmpi	MODE_HEADHELD,a0
	jrz	#out
	cmpi	MODE_HEADHOLD,a0
	jrz	#out

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#out

	.ref	ck_ignore
	calla	ck_ignore
	jrc	#out

;Don't do it when he is on ground
	calla	get_opp_plyrmode
	cmpi	MODE_ONGROUND,a0
	jrz	#out
	cmpi	MODE_DEAD,a0
	jrz	#out

#ok

	SETMODE	INAIR

	movk	1,a0			;Ensure leap at
	move	a0,*a8(OBJ_XVEL),L

	movi	shn_flying_kick_anim,a0
	calla	change_anim1a


	WRSND	W_SHAWN,FLYKICK_T1,FLYKICK_T2

	rets

*******************************************************************************

#frankensteiner
	.word	B_SKICK,		J_ALL
	.word	J_TOWARD,		J_REAL_LR
	.word	J_TOWARD,		J_REAL_LR
	.word	8000h | 32 		;max
	.long	#scrt_fstein

#scrt_fstein
	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#rets
	move	*a13(PLYRMODE),a0
	CMPI	MODE_HEADHOLD,a0
	jrz	#rets

;no frankensteiner if opponent is on the ground
	calla	get_opp_plyrmode
	cmpi	MODE_ONGROUND,a0
	jreq	#rets
	cmpi	MODE_DEAD,a0
	jreq	#rets

	;don't do it if opponent is behind you
	calla	ck_ignore
	jrc	#rets
	
	CALLA	FIND_AND_KILL_ENDLESS
	movi	shn_fstein_anim,a0
	calla	change_anim1a
	WRSND	W_SHAWN,KICK_T1,KICK_T2
#rets	rets

	.if NUM_SHAWN_FINISHES
#******************************************************************************
 SUBRP	shn_finish_move1

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
	WAITSWITCH_DWN	J_DOWN,0,#reset
	WAITSWITCH_DWN	J_TOWARD,J_DOWN|J_UP,#reset
	WAITSWITCH_DWN	J_TOWARD,J_DOWN|J_UP,#reset
	WAITSWITCH_DWN	B_PUNCH,J_ALL,#reset

	movi		shn_finish1_move,a0
	move		a0,*a8(SPECIAL_MOVE_ADDR),L
	DIE
	.endif
	

	.if NUM_SHAWN_FINISHES > 1
#******************************************************************************
 SUBRP	shn_finish_move2

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

	movi		shn_finish2_move,a0
	move		a0,*a8(SPECIAL_MOVE_ADDR),L
	DIE
	.endif


#*******************************************************************************
shn_swirl_speedkick

#TIMEOUT	.equ	60

#lp0
	SLEEPK	1
#lp
	move	*a8(GETUP_TIME),a0
	jrnz	#lp0
	clr	a11

	WAITSWITCH_DWN	J_DOWN,0,#lp

	movi	#TIMEOUT,a11
;	WAITSWITCH_DWN	J_DOWN_TOWARD,0,#lp
	WAITSWITCH_DWN	J_TOWARD,J_DOWN|J_UP,#lp
	WAITSWITCH_DWN	B_KICK,J_ALL,#lp

	move	*a8(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#lp0

	move	*a8(PLYRMODE),a0
	cmpi	MODE_DEAD,a0
	jrz	#lp0
	cmpi	MODE_HEADHOLD,a0
	jrz	#knee
	cmpi	MODE_HEADHELD,a0
	jrnz	#slam
	move	*a8(I_WILL_DIE),a14
	jrnz	#lp0

	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

	CALLA	DO_REVERSAL
	CALLA	DO_REVERSAL_MESS

	;target WHOHITME -- don't hit anyone else
	SMRTTGT	a8,WHOHITME

;	;immobilize WHOHITME
;	move	*a8(WHOHITME),a0,L
;	jruc	#is_reversal

#slam
	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

;	movk	6,a10
;	CREATE	MESSAGE_PID,BONUS_MESS

;	;target WHOIHIT -- don't hit anyone else
;	SMRTTGT	a8,WHOIHIT

;	;immobilize WHOIHIT
;	move	*a8(WHOIHIT),a0,L

#is_reversal
;	movk	15,a14
;	move	a14,*a0(IMMOBILIZE_TIME)

	CALLA	FIND_AND_KILL_ENDLESS

	movi	shn_super_speedkick_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L
	WRSND	W_SHAWN,KICK_T1,KICK_T2
	SLEEPK	20
	jruc	#lp

#knee
	CALLA	FIND_AND_KILL_ENDLESS
	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

;	move	*a8(WHOHITME),a14,L
;	movk	15,a0
;	move	a0,*a14(IMMOBILIZE_TIME)


	move	*a8(WHOIHIT),a0,L
	movi	6*60,a14
	move	a14,*a0(DELAY_METER)

	SPCDMG	D_FLYKICK/2,20

	movi	shn_flying_kick_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SETMODE	INAIR

;	movi	1000h,a0
;	move	a0,*a13(OBJ_XVEL),L
;	movi	1000h,a0
;	move	a0,*a8(OBJ_XVEL),L
;	movi	1000h,a0
;	move	a0,*a13(OBJ_XVEL),L

	WRSND	W_SHAWN,FLYKICK_T1,FLYKICK_T2
	SLEEPK	5
	movi	40000h,a0
	move	a0,*a8(OBJ_YVEL),L
	SLEEPK	20
	jruc	#lp

; 
;#*******************************************************************************
;
;	STRUCTPD
;	WORD		#CHARGE_TIME	;UDW
;	WORD		#TIMEOUT	;UDW
;
;shn_charge_speedkick
;
;#start_over
;	;charge on stick away
;	clr	a14
;	move	a14,*a13(#CHARGE_TIME),W
;#loop1
;	SLEEPK	1
;
;	move	*a13(#CHARGE_TIME),a14,W
;	inc	a14
;	move	a14,*a13(#CHARGE_TIME),W
;	move	*a8(STICK_VAL_CUR),a0
;
;;Arbitrarily define TOWARD to be RIGHT.  So if the opponent is to
;;our left, flip the L|R direction bits...
;
;;However, if the stick isn't pointed left or right, don't do
;;anything.
;	move	a0,a14
;	andi	MOVE_LEFT|MOVE_RIGHT,a14
;	jrz	#no_flip
;
;	move	*a8(NEW_FACING_DIR),a14
;	btst	MOVE_LEFT_BIT,a14
;	jrz	#no_flip
;	xori	MOVE_LEFT|MOVE_RIGHT,a0
;#no_flip
;
;;If we're still holding away, jump back to #loop1
;	btst	MOVE_LEFT_BIT,a0
;	jrnz	#loop1
;
;;No longer holding away...
;	move	*a13(#CHARGE_TIME),a14
;	cmpi	45,a14
;	jrlt	#start_over
;
;;Okay, they released after holding away for 2 seconds.  Give them
;;Half a second to push forward + super_kick
;
;	movk	25,a14
;	move	a14,*a13(#TIMEOUT)
;#loop2
;	SLEEPK	1
;
;	move	*a8(BUT_VAL_DOWN),a0
;	jrnz	#press
;
;	move	*a13(#TIMEOUT),a14
;	dec	a14
;	jrz	#start_over
;	move	a14,*a13(#TIMEOUT)
;	jruc	#loop2
;
;#press
;;We have a button press.  Is it kick?
;	btst	PLAYER_KICK_BIT,a0
;	jrz	#start_over	;wrong button.  No good.
;
;;Check for a towards on the stick.
;	move	*a8(STICK_VAL_CUR),a0
;	jrz	#start_over	;no stick at all.  No good.
;
;	move	*a8(NEW_FACING_DIR),a14
;	btst	MOVE_LEFT_BIT,a14
;	jrz	#no_flip2
;	xori	MOVE_LEFT|MOVE_RIGHT,a0
;#no_flip2
;	btst	MOVE_RIGHT_BIT,a0
;	jrz	#start_over	;pooched it
;
;;Don't do it when he is on ground
;	SWAP	a8,a13
;	calla	get_opp_plyrmode
;	SWAP	a8,a13
;;Don't do it when he is on ground
;	cmpi	MODE_ONGROUND,a0
;	jrz	#start_over
;	cmpi	MODE_DEAD,a0
;	jrz	#start_over
;
;;Success!  Check for the UNINT bit, then queue it up.
;	move	*a8(ANIMODE),a14
;	btst	MODE_UNINT_BIT,a14
;	jrnz	#start_over
;
;	movi	shn_super_speedkick_anim,a14
;	move	a14,*a8(SPECIAL_MOVE_ADDR),L
;
;	WRSND	W_SHAWN,KICK_T1,KICK_T2
;
;	jruc	#start_over

#*******************************************************************************
shn_flipslam
;Can do from head hold also!

#TIMEOUT	.equ	30

#lp0
	SLEEPK	1
#lp
	move	*a8(GETUP_TIME),a0
	jrnz	#lp0

	clr	a11

	WAITSWITCH_DWN	J_UP,0,#lp

	movk	#TIMEOUT,a11

;	WAITSWITCH_DWN	J_UP_TOWARD,0,#lp
	WAITSWITCH_DWN	J_TOWARD,0,#lp
	WAITSWITCH_DWN	B_SPUNCH,J_ALL,#lp

	move	*a8(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#lp

	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHELD,a0
	jrnz	#slam
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
	cmpi	MODE_HEADHOLD,a0
	jrnz	#slam2
	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

	movi	39,a10
	CREATE	MESSAGE_PID,BONUS_MESS

	;target WHOIHIT -- don't hit anyone else
	SMRTTGT	a8,WHOIHIT

	;immobilize WHOIHIT
	move	*a8(WHOIHIT),a0,L

#is_reversal
	movk	15,a14
	move	a14,*a0(IMMOBILIZE_TIME)

	CALLA	FIND_AND_KILL_ENDLESS
#slam2
	movi	shn_flipslam_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L
	WRSND	W_SHAWN,KICK_T1,KICK_T2

	SLEEPK	20

	jruc	#lp

*******************************************************************************
#*

shn_grab_toss_air

#TIMEOUT	.equ	40

#lp0
	SLEEPK	1
#lp
	clr	a11

	WAITSWITCH_DWN	J_AWAY,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_AWAY,0,#lp
;	WAITSWITCH_DWN	B_PUNCH,J_DOWN_AWAY|J_UP_AWAY,#lp
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
	cmpi	6ch,a0
	jrgt	#lp

	FACE24	shn,hiptoss_anim
	move	a0,*a8(SPECIAL_MOVE_ADDR),L

	WRSND	W_SHAWN,HIPTOSS_T1,PUNCH_T2

	SLEEPK	20

	jruc	#lp

#doit2	FACE24	shn,hiptoss2_anim
	move	a0,*a8(SPECIAL_MOVE_ADDR),L

	WRSND	W_SHAWN,HIPTOSS_T1,PUNCH_T2

	SLEEPK	20

	jruc	#lp

#*******************************************************************************
shn_hdhold_suplex

#TIMEOUT	.equ	60

#lp0
	SLEEPK	1
#lp
	move	*a8(GETUP_TIME),a0
	jrnz	#lp0

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
#contz
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

;fix ! wrong name - jake
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

	movi	shn_gsuplex_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L
	WRSND	W_SHAWN,KICK_T1,KICK_T2

	SLEEPK	20

	jruc	#lp

#*******************************************************************************
shn_hdhold_kicktoss

#TIMEOUT	.equ	60

#lp0
	SLEEPK	1
#lp
	move	*a8(GETUP_TIME),a0
	jrnz	#lp0
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
	WAITSWITCH_DWN	B_KICK,J_ALL,#lp

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

	movi	36,a10
	CREATE	MESSAGE_PID,BONUS_MESS

	;target WHOIHIT -- don't hit anyone else
	SMRTTGT	a8,WHOIHIT

	;immobilize WHOIHIT
	move	*a8(WHOIHIT),a0,L

#is_reversal
	movk	25,a14
	move	a14,*a0(IMMOBILIZE_TIME)

	CALLA	FIND_AND_KILL_ENDLESS

	WRSND	W_SHAWN,KICK_T1,KICK_T2
	movi	shn_sliding_kicktoss_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEPK	20

	jruc	#lp

#*******************************************************************************
shn_hdhold_frank

#TIMEOUT	.equ	60

#lp0
	SLEEPK	1
#lp
	move	*a8(GETUP_TIME),a0
	jrnz	#lp0
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

	movk	3,a10
	CREATE	MESSAGE_PID,BONUS_MESS

	;target WHOIHIT -- don't hit anyone else
	SMRTTGT	a8,WHOIHIT

	;immobilize WHOIHIT
	move	*a8(WHOIHIT),a0,L

#is_reversal
	movk	32,a14
	move	a14,*a0(IMMOBILIZE_TIME)

	CALLA	FIND_AND_KILL_ENDLESS

	movi	shn_fstein_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L
	WRSND	W_SHAWN,KICK_T1,KICK_T2

	SLEEPK	20

	jruc	#lp

#*******************************************************************************
shn_hdhold_butts

#TIMEOUT	.equ	60

#lp0
	SLEEPK	1
#lp
	move	*a8(GETUP_TIME),a0
	jrnz	#lp0
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
	WAITSWITCH_DWN	B_SKICK,J_ALL,#lp

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

	movk	3,a10
	CREATE	MESSAGE_PID,BONUS_MESS

	;target WHOIHIT -- don't hit anyone else
	SMRTTGT	a8,WHOIHIT

	;immobilize WHOIHIT
	move	*a8(WHOIHIT),a0,L

#is_reversal
	movk	32,a14
	move	a14,*a0(IMMOBILIZE_TIME)

	CALLA	FIND_AND_KILL_ENDLESS

	movi	shn_rpt_hdbutts_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L
;	WRSND	W_SHAWN,KICK_T1,KICK_T2

	SLEEPK	20

	jruc	#lp

#*******************************************************************************

;	STRUCTPD
;	WORD		#CHARGE_TIME	;UDW
#CHARGE_TIME	.equ	SM_USRW1

shn_charge_suplex

;Try to spin around and suplex

#start_over
	clr	a14
	move	a14,*a13(#CHARGE_TIME),W
#loop1
	SLEEPK	1

	move	*a13(#CHARGE_TIME),a14,W
	inc	a14
	move	a14,*a13(#CHARGE_TIME),W

	move	*a8(BUT_VAL_CUR),a0
	btst	PLAYER_PUNCH_BIT,a0
	jrz	#p1

	jruc	#loop1

#p1

;no longer holding button
	move	*a13(#CHARGE_TIME),a14
	cmpi	100,a14
	jrlt	#start_over

	move	*a8(GETUP_TIME),a0
	jrnz	#start_over
	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHELD,a0
	jrz	#start_over
;	jrz	#rev
	cmpi	MODE_HEADHOLD,a0
	jrz	#start_over
	cmpi	MODE_ONGROUND,a0
	jrz	#start_over
	cmpi	MODE_DEAD,a0
	jrz	#start_over

;Success!  Check for the UNINT bit, then queue it up.
	move	*a8(ANIMODE),a14
	btst	MODE_UNINT_BIT,a14
	jrnz	#start_over

	movi	shn_gsuplex_anim,a14

	move	*a8(PLYRMODE),a0
	cmpi	MODE_RUNNING,a0
	jrnz	#cont

	movi	shn_gsuplex_run_anim,a14

#cont
	move	a14,*a8(SPECIAL_MOVE_ADDR),L
	WRSND	W_SHAWN,KICK_T1,KICK_T2

	jruc	#start_over
	

#*******************************************************************************

shn_sliding_kicktoss

#TIMEOUT	.equ	60

#lp0
	SLEEPK	1
#lp
	clr	a11

;	WAITSWITCH_DWN	J_AWAY,0,#lp
	WAITSWITCH_DWN	J_TOWARD,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_TOWARD,0,#lp
	WAITSWITCH_DWN	B_KICK,J_ALL,#lp

	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHELD,a0
	jrz	#lp0
	cmpi	MODE_HEADHOLD,a0
	jrz	#lp0
	cmpi	MODE_ONGROUND,a0
	jrz	#lp0
	cmpi	MODE_DEAD,a0
	jrz	#lp0

	move	*a8(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#lp0

	move	*a8(GETUP_TIME),a0
	jrnz	#lp0


;Don't do it when he is on ground
	SWAP	a8,a13
	calla	get_opp_plyrmode
	SWAP	a8,a13
	cmpi	MODE_ONGROUND,a0
	jrz	#lp
	cmpi	MODE_DEAD,a0
	jrz	#lp

;Don't do it if opponent is behind you
	SWAP	a8,a13
	calla	ck_ignore
	jrnc	#norm
	SWAP	a8,a13
	jruc 	#lp
#norm	
	SWAP	a8,a13

	WRSND	W_SHAWN,KICK_T1,KICK_T2
	movi	shn_sliding_kicktoss_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEPK	20

	jruc	#lp

;#*****************************************************************************
;*
;
;#TIMEOUT	.equ	30
;
; SUBR	std_hdhold_anti_combo
;
;
;#lp0	SLEEPK	1
;#lp	clr	a11
;
;	WAITSWITCH_DWN2	B_PUNCH,J_ALL,#lp
;
;	movk	#TIMEOUT,a11
;
;	WAITSWITCH_DWN2	B_SPUNCH,J_ALL,#lp
;	WAITSWITCH_DWN2	B_PUNCH,J_ALL,#lp
;	WAITSWITCH_DWN2	B_SPUNCH,J_ALL,#lp
;
;	;is my opponent in combo mode?
;	move	*a8(CLOSEST_NUM),a0
;	X32	a0
;	addi	process_ptrs,a0
;	move	*a0,a0,L
;	move	*a0(COMBO_COUNT),a0
;	jrz	#lp0
;
;	;am I already dead?
;	move	*a8(I_WILL_DIE),A14
;	jrnz	#lp0
;
;	;is my combo meter lit?
;	calla	CHECK_COMBO_GO
;	jrlt	#lp0
;
;;Combo breaker message!
;	CALLA	DO_REVERSAL
;	CALLA	DO_REVERSAL_MESS
;
;	;target WHOHITME -- don't hit anyone else
;	SMRTTGT	a8,WHOHITME
;
;	clr	a0
;	move	a0,*a8(IMMOBILIZE_TIME)
;
;	move	*a8(WHOHITME),a14,L
;	movk	30,a0
;	move	a0,*a14(IMMOBILIZE_TIME)
;
;	FACETBL	#breaker_tbl,a8
;	move	a0,*a8(SPECIAL_MOVE_ADDR),L
;;	WRSND	W_SHAWN,KICK_T1,KICK_T2
;
;	;halve both combo meters.
;	push	a8,a13
;
;	move	a8,a13
;	push	a8
;	calla	halve_combo_meter
;	pull	a8
;	move	*a8(WHOHITME),a13,L
;	calla	halve_combo_meter
;
;	pull	a8,a13
;
;	;set opponent's COMBO_BROKEN bit.  That way he won't get a message
;	; or clear his meter.
;	move	*a8(WHOHITME),a0,L
;	move	*a0(STATUS_FLAGS),a14,L
;	ori	M_COMBO_BROKEN,a14
;	move	a14,*a0(STATUS_FLAGS),L
;
;	;sleep while waiting for the hit to land.  Time varies by wrestler
;	move	*a8(WRESTLERNUM),a0
;	X16	a0
;	addi	#wait_tbl,a0
;	move	*a0,a0,W
;	calla	PRCSLP
;
;	movk	1,a14
;	move	a14,@HALT
;	SLEEP	20
;	clr	a14
;	move	a14,@HALT
;
;	jruc	#lp
;
;#breaker_tbl
;	.long	0			;0 Bret Hart
;	REFLONG	rzr_3_uslash_anim	;1 Razor Ramon
;	.long	0			;2 Undertaker
;	.long	0			;3 Yokozuna
;	REFLONG	shn_spinkick_anim	;4 Shawn Michaels
;	.long	0			;5 Bam Bam
;	.long	0			;6 Doink
;	.long	0			;7 spare
;	.long	0			;8 Lex Luger
;
;#wait_tbl
;	.word	0010,9,0010,0010	;hrt,rzr,und,yok
;	.word	13,0010,0010,0,0010	;shn,bam,dnk,0,lex

;*******************************************************************************
;#*
;shn_hdhold_anti_combo
;#TIMEOUT	.equ	30
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
;	movk	#TIMEOUT,a11
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
;	;target WHOHITME -- don't hit anyone else
;	SMRTTGT	a8,WHOHITME
;
;	clr	a0
;	move	a0,*a8(IMMOBILIZE_TIME)
;
;	move	*a8(WHOHITME),a14,L
;	movk	15,a0
;	move	a0,*a14(IMMOBILIZE_TIME)
;
;	movi	shn_fstein_anim,a14
;	move	a14,*a8(SPECIAL_MOVE_ADDR),L
;	WRSND	W_SHAWN,KICK_T1,KICK_T2
;
;	SLEEPK	20
;
;	jruc	#lp
;
#******************************************************************************

shn_hdhold_combo1
;And arm break

#TIMEOUT	.equ	60

#lp0
	SLEEPK	1
#lp
	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
;	jrnz	#lp0
	jrz	#cont
	cmpi	MODE_HEADHELD,a0
	jrnz	#lp0
#cont
;In combo mode?
;	calla	CHECK_COMBO_GO
;	jrlt	#lp0

	clr	a11

	WAITSWITCH_DWN	J_TOWARD,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_TOWARD,0,#lp
	WAITSWITCH_DWN	B_PUNCH,J_ALL,#lp

	calla	CHECK_COMBO_GO
	jrlt	#tryarm

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
	movi	shn_combo_kick_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L
	WRSND	W_SHAWN,KICK_T1,KICK_T2

	SLEEPK	20

	jruc	#lp
#tryarm
	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrz	#slam2
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

#slam2
	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

	movk	9,a10
	CREATE	MESSAGE_PID,BONUS_MESS

	;target WHOIHIT -- don't hit anyone else
	SMRTTGT	a8,WHOIHIT

	;immobilize WHOIHIT
	move	*a8(WHOIHIT),a0,L

#is_reversal
	movk	32,a14
	move	a14,*a0(IMMOBILIZE_TIME)

	CALLA	FIND_AND_KILL_ENDLESS

	movi	shn_break_arm_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L
	WRSND	W_SHAWN,GRABHOLD_T1,GRABHOLD_T2

	SLEEPK	20

	jruc	#lp

#******************************************************************************

shn_hdhold_combo2

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
	movi	shn_combo_punch_anim,A14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L
	WRSND	W_SHAWN,KICK_T1,KICK_T2

	SLEEPK	20

	jruc	#lp

#*****************************************************************************

 SUBR	shawn_ani_init

	move	*a13(FACING_DIR),a0
	btst	PLAYER_RIGHT_BIT,a0
	jrnz	#p1
;Plyr 2
	movi	shn_stand4_anim,a0
	calla	change_anim1a

	movi	shn_torso4_anim,a0
	calla	change_anim2a

	PUSH	a10
	move	a13,a10
	CREATE	TAUNT_PID,do_taunt
	PULL	a10

	rets

#p1
	movi	shn_stand2_anim,a0
	calla	change_anim1a

	movi	shn_torso2_anim,a0
	calla	change_anim2a

	rets


#*****************************************************************************
*
* SHAWNS CONTROL CODE
*
* a13 = * shawn process

 SUBR	move_shawn


	movi	shn_secret_moves,a11
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
	REFLONG	mode_dead		;9
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
	movi	shn_fall_back_anim,a0
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
;Perhaps we need to interrupt any sequence when a wrestler has won?

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

	;opponent is on the ground.  pin him.
	FACE24	shn,pin_anim
	calla	change_anim1a

	;set the 'I did a pin' flag.
	move	*a13(STATUS_FLAGS),a14
	ori	M_DID_PIN,a14
	move	a14,*a13(STATUS_FLAGS)

	;if we're a temp drone for auto-pin purposes, turn back into
	; a normal player here.
	calla	drone_change_back

	rets

#raisearm
	FACE24	shn,raise_arm_anim
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
* normal	<  62  95	headbutt
* normal	>		normal punch
*
* onground	< 120 120	elbow drop
* onground	>		normal punch
*
* running |
* bouncing			normal punch
*
* onturnbkl	<  60  60	punch
* onturnbkl	>		normal punch
*
* puppet|inair			normal punch


	JJXM_INIT
	JJXM	NORMAL,		 50, 45,#punch_hdbutt,#punch_punch
	JJXM	BLOCK,		 50, 45,#punch_hdbutt,#punch_punch
	JJXM	DIZZY,		 50, 45,#punch_hdbutt,#punch_punch
	JJXM	ONGROUND,	160,140,#punch_lbdrop,#punch_punch
	JJXM	RUNNING,	 50, 45,#punch_hdbutt,#punch_punch
	JJXM	BOUNCING,	 50, 45,#punch_hdbutt,#punch_punch
	JJXM	ONTURNBKL,	 	#punch_punch
	JJXM	CLIMBTURNBKL,	 	#punch_punch
	JJXM	PUPPET,		 50, 45,#punch_hdbutt,#punch_punch
	JJXM	PUPPET2,	 50, 45,#punch_hdbutt,#punch_punch
	JJXM	INAIR,		 50, 45,#punch_hdbutt,#punch_punch
	JJXM	ATTACHED,	 50, 45,#punch_hdbutt,#punch_punch
	JJXM	DEAD,		160,140,#punch_lbdrop,#punch_punch
	JJXM	OPPOVERHEAD,	 50, 45,#punch_hdbutt,#punch_punch
	JJXM	WAITANIM,	 50, 45,#punch_hdbutt,#punch_punch
	JJXM	GRAPPLE,	 50, 45,#punch_hdbutt,#punch_punch
	JJXM	MASTER,		 50, 45,#punch_hdbutt,#punch_punch
	JJXM	SLAVE,		 50, 45,#punch_hdbutt,#punch_punch
	JJXM	HEADHOLD,	 50, 45,#punch_hdbutt,#punch_punch
	JJXM	HEADHELD,	 50, 45,#punch_hdbutt,#punch_punch
	JJXM	CHOKEHOLD,	 50, 45,#punch_hdbutt,#punch_punch
	JJXM	INAIR2,		 50, 45,#punch_hdbutt,#punch_punch
	JJXM_END

*****	
#punch_punch
std_punch

	FACE24	shn,punch_anim
	calla	change_anim1a

	WRSND	W_SHAWN,PUNCH_T1,PUNCH_T2

	rets

*****
#punch_hdbutt
	jruc	#hdbutt

*****
#punch_lbdrop

	FACE24	shn,falling_punch_anim
	calla	change_anim1a

	WRSND	W_SHAWN,LBOWDROP_T1,LBOWDROP_T2
	rets

************
#block		;2
std_block
	move	@blocking_off,a0
	jrnz	#no_blocking

	RND_AWARD	a13,BLOCKS_AWD

	movi	shn_4_block_anim,a0
	calla	change_anim1a

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

	JJXM_INIT
	JJXM	NORMAL,		 85, 45,#spunch_special,#spunch_slap	;0
	JJXM	RUNNING,	 85, 45,#spunch_special,#spunch_slap	;1
	JJXM	INAIR,		 85, 45,#spunch_special,#spunch_slap	;2
	JJXM	ATTACHED,	 85, 45,#spunch_special,#spunch_slap	;3
	JJXM	ONGROUND,	160,140,#spunch_lbowdrop,std_punch	;4
	JJXM	BOUNCING,	 85, 45,#spunch_special,#spunch_slap	;1
	JJXM	ONTURNBKL,	 	#spunch_slap			;6
	JJXM	BLOCK,		 85, 45,#spunch_special,#spunch_slap	;7
	JJXM	DIZZY,		 85, 45,#spunch_special,#spunch_slap	;8
	JJXM	DEAD,		160,140,#spunch_lbowdrop,std_punch	;9
	JJXM	OPPOVERHEAD,	 85, 45,#spunch_special,#spunch_slap	;10
	JJXM	CLIMBTURNBKL,		std_punch			;11
	JJXM	WAITANIM,	 85, 45,#spunch_special,#spunch_slap	;12
	JJXM	GRAPPLE,	 85, 45,#spunch_special,#spunch_slap	;13
	JJXM	MASTER,		 85, 45,#spunch_special,#spunch_slap	;14
	JJXM	SLAVE, 		 85, 45,#spunch_special,#spunch_slap	;15
	JJXM	HEADHOLD,	 85, 45,#spunch_special,#spunch_slap	;16
	JJXM	HEADHELD,	 85, 45,#spunch_special,#spunch_slap	;17
	JJXM	CHOKEHOLD,	 85, 45,#spunch_special,#spunch_slap	;16
	JJXM	PUPPET,		 85, 45,#spunch_special,#spunch_slap	;20
	JJXM	PUPPET2,	 85, 45,#spunch_special,#spunch_slap	;20
	JJXM	INAIR2,		 85, 45,#spunch_special,#spunch_slap	;21
	JJXM_END

#spunch_rets
	rets

*****
#graboh
#spunch_slap

	FACE24	shn,slap_anim
	calla	change_anim1a

	WRSND	W_SHAWN,SPUNCH_T1,SPUNCH_T2

	rets

*****
#spunch_special
	move	*a13(CLOSEST_XDIST),a1
	cmpi	64,a1
	jrgt	std_punch

	FACE24	shn,pummel_anim
	calla	change_anim1
	WRSND	W_SHAWN,HDBUTT_T1,HDBUTT_T2

	rets

#hdbutt

	FACE24	shn,butt_anim
	calla	change_anim1

	WRSND	W_SHAWN,HDBUTT_T1,HDBUTT_T2

	rets

*****
#spunch_lbowdrop

;If near opponents head, and facing down, do the hair grab!
;Allow hair grab from below!

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

	FACE24	shn,hair_pickup_anim
	calla	change_anim1
	WRSND	W_SHAWN,LBOWDROP_T1,LBOWDROP_T2
	rets

#no	FACE24	shn,falling_punch_anim
	calla	change_anim1a
	WRSND	W_SHAWN,LBOWDROP_T1,LBOWDROP_T2
	rets


************
#kick		;8
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
* puppet|inair			normal kick
*


	JJXM_INIT
	JJXM	NORMAL,		 60, 50,#kick_knee,#kick_kick
	JJXM	DIZZY,		 60, 50,#kick_knee,#kick_kick
	JJXM	BLOCK,		 60, 50,#kick_knee,#kick_kick
	JJXM	ONGROUND,	160,140,#kick_stomp,#kick_kick
	JJXM	RUNNING,		#kick_kick
	JJXM	BOUNCING,	 	#kick_kick
	JJXM	ONTURNBKL,	 	#kick_kick
	JJXM	CLIMBTURNBKL,	 	#kick_kick
	JJXM	PUPPET,			#kick_kick
	JJXM	PUPPET2,		#kick_kick
	JJXM	INAIR,			#kick_kick
	JJXM	ATTACHED,	 60, 50,#kick_knee,#kick_kick
	JJXM	DEAD,		160,140,#kick_stomp,#kick_kick
	JJXM	OPPOVERHEAD,	 60, 50,#kick_knee,#kick_kick
	JJXM	WAITANIM,	 60, 50,#kick_knee,#kick_kick
	JJXM	GRAPPLE,	 60, 50,#kick_knee,#kick_kick
	JJXM	MASTER,		 60, 50,#kick_knee,#kick_kick
	JJXM	SLAVE,		 60, 50,#kick_knee,#kick_kick
	JJXM	HEADHOLD,	 60, 50,#kick_knee,#kick_kick
	JJXM	HEADHELD,	 60, 50,#kick_knee,#kick_kick
	JJXM	CHOKEHOLD,	 60, 50,#kick_knee,#kick_kick
	JJXM	INAIR2,		 	#kick_TB
	JJXM_END

*****
#kick_TB
	.ref	shn_spinkick_TB_anim
	movi	shn_spinkick_TB_anim,a0
	calla	change_anim1a

	WRSND	W_SHAWN,KICK_T1,KICK_T2
	rets


*****
#kick_kick
std_kick

	FACE24	shn,kick_anim
	calla	change_anim1a

	WRSND	W_SHAWN,KICK_T1,KICK_T2
	rets

*****
#kick_knee
std_knee

	FACE24	shn,knee_anim
	jruc	#knee_set
std_knee_4
	movi	shn_4_knee_anim,a0
#knee_set
	calla	change_anim1a

	WRSND	W_SHAWN,KICK_T1,KICK_T2
	rets

*****
#kick_stomp

	FACE24	shn,stomp_anim
	calla	change_anim1a

	WRSND	W_SHAWN,KICK_T1,KICK_T2
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
* normal			speed kick or spin kick (depends on stick)
*
* onground	< 120  120	stomp
* onground	>		normal kick
*
* running |
* bouncing			flying kick
*
* most others			as MODE_NORMAL
*

	JJXM_INIT
	JJXM	NORMAL,			#skick_kick
	JJXM	DIZZY,			#skick_kick
	JJXM	BLOCK,			#skick_kick
	JJXM	ONGROUND,	160,140,#skick_stomp,std_kick
	JJXM	RUNNING,		#skick_frank
	JJXM	BOUNCING,		#skick_frank
	JJXM	ONTURNBKL,	 	#skick_kick
	JJXM	CLIMBTURNBKL,	 	#skick_kick
	JJXM	PUPPET,		 	#skick_kick
	JJXM	PUPPET2,	 	#skick_kick
	JJXM	INAIR,		 	#skick_kick
	JJXM	ATTACHED,	 	#skick_kick
	JJXM	DEAD,		160,140,#skick_stomp,std_kick
	JJXM	OPPOVERHEAD,	 	#skick_kick
	JJXM	WAITANIM,	 	#skick_kick
	JJXM	GRAPPLE,	 	#skick_kick
	JJXM	MASTER,		 	#skick_kick
	JJXM	SLAVE,		 	#skick_kick
	JJXM	HEADHOLD,	 	#skick_kick
	JJXM	HEADHELD,	 	#skick_kick
	JJXM	CHOKEHOLD,	 	#skick_kick
	JJXM	INAIR2,		 	#kick_TB
	JJXM_END

*****
#skick_frank

;don't do it if opponent is behind you
	calla	ck_ignore
	jrc	#skick_kick

	movi	shn_fstein_anim,a0
	calla	change_anim1a
	WRSND	W_SHAWN,KICK_T1,KICK_T2
	rets

*****
#skick_kick

	movi	shn_spinkick_anim,a0
	calla	change_anim1a

	WRSND	W_SHAWN,FLYKICK_T1,FLYKICK_T2
	rets

*****
#skick_stomp

	FACE24	shn,stomp_anim
	calla	change_anim1a

	WRSND	W_SHAWN,KICK_T1,KICK_T2
	rets

*****
#skick_flykick
attack_flykick

	calla	ck_ignore
	jrc	#z

	;don't do it if the bad guy is on the ground
	calla	get_opp_plyrmode
	cmpi	MODE_ONGROUND,a0
	jreq	#rets
	cmpi	MODE_DEAD,a0
	jreq	#rets

	SETMODE	INAIR

	movi	shn_flying_kick_anim,a0
	calla	change_anim1a

	WRSND	W_SHAWN,FLYKICK_T1,FLYKICK_T2
#rets
	rets

*****
#skick_super_speedkick

	movi	shn_super_speedkick_anim,a0
	calla	change_anim1a

	WRSND	W_SHAWN,KICK_T1,KICK_T2
	rets


#*****************************************************************************
*
* RUNNING (if GETUP_TIME > 0 then player is out of control)
*

#XRUN_VAL	equ	SHN_XRUN
#ZDRIFT_VAL	equ	SHN_ZDRIFT

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
#z		;0

	rets


************
#punch		;1
#punchkick	;9
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal|dizzy			flying kick
*
* onground			running stomp
*
* running |
* bouncing			flying kick
*
* onturnbkl			flying kick
*
* puppet|inair			flying kick
*

	JJXM_INIT
	JJXM	NORMAL,		 	#punch_rets
	JJXM	DIZZY,		 	#punch_rets
	JJXM	BLOCK,		 	#punch_rets
	JJXM	ONGROUND,		attack_runstomp
	JJXM	RUNNING,	 	#punch_rets
	JJXM	BOUNCING,		#punch_rets
	JJXM	ONTURNBKL,	 	#punch_rets
	JJXM	CLIMBTURNBKL,	 	#punch_rets
	JJXM	PUPPET,			#punch_rets
	JJXM	PUPPET2,		#punch_rets
	JJXM	INAIR,			#punch_rets
	JJXM	ATTACHED,		#punch_rets
	JJXM	DEAD,			attack_runstomp
	JJXM	OPPOVERHEAD,		#punch_rets
	JJXM	WAITANIM,		#punch_rets
	JJXM	GRAPPLE,		#punch_rets
	JJXM	MASTER,			#punch_rets
	JJXM	SLAVE,			#punch_rets
	JJXM	HEADHOLD,		#punch_rets
	JJXM	HEADHELD,		#punch_rets
	JJXM	CHOKEHOLD,		#punch_rets
	JJXM	INAIR2,			#punch_rets
	JJXM_END

#punch_rets
	rets


************
#block		;2

	move	*a13(OBJ_XVEL),a0,L
	sra	1,a0
	move	a0,*a13(OBJ_XVEL),L
	SETMODE	NORMAL
	jruc	std_block


************
#super_punch	;4
#graboh		;20
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal|dizzy			flying kick
*
* onground			running stomp
*
* running |
* bouncing			flying kick
*
* onturnbkl			flying kick
*
* puppet|inair			flying kick
*

	JJXM_INIT
        JJXM    NORMAL,                 #punch_flipslam
        JJXM    DIZZY,                  #punch_flipslam
        JJXM    BLOCK,                  #punch_flipslam
        JJXM    ONGROUND,       176,176,attack_runstomp,#spunch_rets
        JJXM    RUNNING,                #punch_flipslam
        JJXM    BOUNCING,               #punch_flipslam
	JJXM	ONTURNBKL,	 	#spunch_rets
	JJXM	CLIMBTURNBKL,	 	#spunch_rets
	JJXM	PUPPET,			#spunch_rets
	JJXM	PUPPET2,		#spunch_rets
	JJXM	INAIR,			#spunch_rets
	JJXM	ATTACHED,		#spunch_rets
        JJXM    DEAD, 	      176,176,attack_runstomp,#spunch_rets
	JJXM	OPPOVERHEAD,		#spunch_rets
	JJXM	WAITANIM,		#spunch_rets
	JJXM	GRAPPLE,		#spunch_rets
	JJXM	MASTER,			#spunch_rets
	JJXM	SLAVE,			#spunch_rets
	JJXM	HEADHOLD,		#spunch_rets
	JJXM	HEADHELD,		#spunch_rets
	JJXM	CHOKEHOLD,		#spunch_rets
	JJXM	INAIR2,			#spunch_rets
	JJXM_END

#spunch_rets
	rets


************
#punch_flipslam

	;don't do it if you're running away from your opponent.
	move	*a13(FACING_DIR),a0
	move	*a13(NEW_FACING_DIR),a1
	and	a0,a1
	andi	MOVE_LEFT|MOVE_RIGHT,a1
	jrz	#z

	movi    shn_flipslam_anim,a0
	calla   change_anim1a

	WRSND   W_SHAWN,HIPTOSS_T1,PUNCH_T2
	rets

************
#kick		;8
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal|dizzy			flying kick
*
* onground			running stomp
*
* running |
* bouncing			flying kick
*
* onturnbkl			flying kick
*
* puppet|inair			flying kick
*

	JJXM_INIT
	JJXM	NORMAL,		 	attack_flykick
	JJXM	DIZZY,		 	attack_flykick
	JJXM	BLOCK,		 	attack_flykick
	JJXM	ONGROUND,		#kick_runstomp
	JJXM	RUNNING,	 	attack_flykick
	JJXM	BOUNCING,		attack_flykick
	JJXM	ONTURNBKL,	 	attack_flykick
	JJXM	CLIMBTURNBKL,	 	attack_flykick
	JJXM	PUPPET,			attack_flykick
	JJXM	PUPPET2,		attack_flykick
	JJXM	INAIR,			attack_flykick
	JJXM	ATTACHED,		attack_flykick
	JJXM	DEAD,			#kick_runstomp
	JJXM	OPPOVERHEAD,		attack_flykick
	JJXM	WAITANIM,		attack_flykick
	JJXM	GRAPPLE,		attack_flykick
	JJXM	MASTER,			attack_flykick
	JJXM	SLAVE,			attack_flykick
	JJXM	HEADHOLD,		attack_flykick
	JJXM	HEADHELD,		attack_flykick
	JJXM	CHOKEHOLD,		attack_flykick
	JJXM	INAIR2,			attack_flykick
	JJXM_END
	

*****
#kick_runstomp
attack_runstomp

	calla	ck_ignore
	jrc	#kick_rets

	movi	shn_run_stomp_anim,a0
	calla	change_anim1a
#kick_rets
	rets



************
#super_kick	;16
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal|dizzy			frankensteiner
*
* onground			flying kick
*
* running			frankensteiner
*
* bouncing			flying kick
*
* onturnbkl			flying kick
*
* inair|puppet			flying kick
*

	JJXM_INIT
	JJXM	NORMAL,		 	#attack_fstein
	JJXM	DIZZY,		 	#attack_fstein
	JJXM	BLOCK,		 	#attack_fstein
	JJXM	ONGROUND,		attack_runstomp
	JJXM	RUNNING,	 	#attack_fstein
	JJXM	BOUNCING,		#attack_fstein
	JJXM	ONTURNBKL,	 	attack_flykick
	JJXM	CLIMBTURNBKL,	 	attack_flykick
	JJXM	INAIR,			attack_flykick
	JJXM	PUPPET,			attack_flykick
	JJXM	PUPPET2,		attack_flykick
	JJXM	ATTACHED,		#attack_fstein
	JJXM	DEAD,		 	attack_runstomp
	JJXM	OPPOVERHEAD,		#attack_fstein
	JJXM	WAITANIM,		#attack_fstein
	JJXM	GRAPPLE,		#attack_fstein
	JJXM	MASTER,			#attack_fstein
	JJXM	SLAVE,			#attack_fstein
	JJXM	HEADHOLD,		#attack_fstein
	JJXM	HEADHELD,		#attack_fstein
	JJXM	CHOKEHOLD,		#attack_fstein
	JJXM	INAIR2,			#attack_fstein
	JJXM_END
	

*****
#attack_fstein

;don't do it if opponent is behind you
	calla	ck_ignore
	jrc	#rets

	movi	shn_fstein_anim,a0
	calla	change_anim1a

	SETMODE	INAIR

	WRSND	W_SHAWN,GRABHOLD_T1,GRABHOLD_T2
#rets

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

	movi	shn_run2_anim,a0
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

	movi	shn_climb_down_anim,a0
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

************
#z
	rets

************
#punch		;1
#block		;2
#super_punch	;4
#punchkick	;5
#graboh		;20

	SETMODE	INAIR

     	movi	shn_belbow_anim,a0
	calla	change_anim1a
	WRSND	W_SHAWN,KICK_T1,KICK_T2
	rets

************
#kick		;8
#super_kick	;16

	SETMODE	INAIR

     	movi	shn_bstomp_anim,a0
	calla	change_anim1a
	WRSND	W_SHAWN,KICK_T1,KICK_T2
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

	SETMODE	NORMAL

	movi	shn_4_push_anim,a0
	calla	change_anim1a

	WRSND	W_SHAWN,PUSH_T1,PUSH_T2

	rets


#*****************************************************************************
* shawn with zero health

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

;Bozo power move
	.ref	bozo_check
	calla	bozo_check
	jrnc	#fail

	WRSND	W_SHAWN,KICK_T1,KICK_T2

	movi	shn_fstein_anim,a0
	move	@PCNT,a14
	btst	0,a14
	jrz	#tag
	movi	shn_sliding_kicktoss_anim,a0
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
	CALLA	FIND_AND_KILL_ENDLESS
;If stick is toward opponent, then do quick punches
;	move	*a13(STICK_VAL_CUR),a0
;	move	*a13(NEW_FACING_DIR),a1
;	andi	0ch,a1
;	cmp	a0,a1
;	jrnz	std_knee_4

	jruc	std_knee_4

;	movi	shn_break_arm_anim,a0
;	calla	change_anim1a
;
;	WRSND	W_SHAWN,GRABHOLD_T1,GRABHOLD_T2
;
;	rets

************
#super_punch	;4
;If stick is toward opponent, then do quick punches
	move	*a13(STICK_VAL_CUR),a0
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrnz	#z

	CALLA	FIND_AND_KILL_ENDLESS
	.ref	shn_rpt_hdbutts2_anim
	movi	shn_rpt_hdbutts2_anim,a0
	calla	change_anim1a

	WRSND	W_SHAWN,GRABHOLD_T1,GRABHOLD_T2

	rets

************
#punchkick
#kick
	CALLA	FIND_AND_KILL_ENDLESS
	move	*a13(STICK_REL_CUR),a0
	btst	MOVE_TOWARD_BIT,a0
	jrz	std_knee_4

	;speed kick - speed kick - speed kick - spin kick
	movi	shn_speed_spinkick_anim,a0
	calla	change_anim1a
	WRSND	W_SHAWN,KICK_T1,KICK_T2
	rets

************
#super_kick	;16
;If stick is toward opponent, then do quick knees
	CALLA	FIND_AND_KILL_ENDLESS
	move	*a13(STICK_VAL_CUR),a0
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrnz	#z

	;knee - knee - knee - frankensteiner
	movi	shn_knee_fstein_anim,a0
	calla	change_anim1a
	WRSND	W_SHAWN,KICK_T1,KICK_T2
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
;	jruc	std_knee_4
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

	WRSND	W_SHAWN,KICK_T1,KICK_T2

	movi	shn_fstein_anim,a0
	move	@PCNT,a14
	btst	0,a14
	jrz	#tag
	movi	shn_sliding_kicktoss_anim,a0
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

	movi	shn_3_head_held_stand_anim,a0
	calla	change_anim1a

#no_luck
	rets

#*****************************************************************************
mode_chokehold	;24
	rets

#*****************************************************************************

;#VEL	equ	30000h		;38000h	;30000h
;#DVEL	equ	21f0eh		;27978h	;21f0eh
;#VEL	equ	38000h		;38000h	;30000h
;#DVEL	equ	30000h		;27978h	;21f0eh
#VEL	equ	3a000h		;38000h	;30000h
#DVEL	equ	31000h		;27978h	;21f0eh


 SUBR shn_velocity_table

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

 SUBR	shn_rotate_anims_table
; old = up right
	.long	shn_stand2_anim		;new = up right
	.long	shn_2_to_4_turn_anim	;    = down right
	.long	shn_2_to_6_turn_anim	;    = down left
	.long	shn_2_to_8_turn_anim	;    = up left

; old = down right
	.long	shn_4_to_2_turn_anim	;new = up right
	.long	shn_stand4_anim		;    = down right
	.long	shn_4_to_6_turn_anim	;    = down left
	.long	shn_4_to_8_turn_anim	;    = up left

; old = down left
	.long	shn_6_to_2_turn_anim	;new = up right
	.long	shn_6_to_4_turn_anim	;    = down right
	.long	shn_stand6_anim		;    = down left
	.long	shn_6_to_8_turn_anim	;    = up left

; old = up left
	.long	shn_8_to_2_turn_anim	;new = up right
	.long	shn_8_to_4_turn_anim	;    = down right
	.long	shn_8_to_6_turn_anim	;    = down left
	.long	shn_stand8_anim		;    = up left


 SUBR	shn_leg_anims_table
;  MOVE
;(#1 - UP)				FACING
	.long	shn_walk1_f2_anim	;1 (UP)
	.long	shn_walk1_f2_anim	;2 (UP_RIGHT)
	.long	shn_walk1_f4_anim	;3 (RIGHT)
	.long	shn_walk1_f4_anim	;4 (DOWN_RIGHT)
	.long	shn_walk1_f4_anim	;5 (DOWN)
	.long	shn_walk1_f4_anim	;6 (DOWN_LEFT)
	.long	shn_walk1_f2_anim	;7 (LEFT)
	.long	shn_walk1_f2_anim	;8 (UP-LEFT)

;(#2 - UP-RIGHT)
	.long	shn_walk2_f2_anim	;1 (UP)
	.long	shn_walk2_f2_anim	;2 (UP_RIGHT)
	.long	shn_walk2_f2_anim	;3 (RIGHT)
	.long	shn_walk2_f4_anim	;4 (DOWN_RIGHT)
	.long	shn_walk8_f4_anim	;5 (DOWN)
	.long	shn_walk8_f4_anim	;6 (DOWN_LEFT)
	.long	shn_walk4_f2_anim	;7 (LEFT)
	.long	shn_walk4_f2_anim	;8 (UP-LEFT)

;(#3 - RIGHT)
	.long	shn_walk2_f2_anim	;1 (UP)
	.long	shn_walk2_f2_anim	;2 (UP_RIGHT)
	.long	shn_walk2_f2_anim	;3 (RIGHT)
	.long	shn_walk4_f4_anim	;4 (DOWN_RIGHT)
	.long	shn_walk4_f4_anim	;5 (DOWN)
	.long	shn_walk8_f4_anim	;6 (DOWN_LEFT)
	.long	shn_walk6_f2_anim	;7 (LEFT)
	.long	shn_walk6_f2_anim	;8 (UP-LEFT)


;(#4 - DOWN-RIGHT)
	.long	shn_walk2_f2_anim	;1 (UP)
	.long	shn_walk8_f2_anim	;2 (UP_RIGHT)
	.long	shn_walk4_f4_anim	;3 (RIGHT)
	.long	shn_walk4_f4_anim	;4 (DOWN_RIGHT)
	.long	shn_walk2_f4_anim	;5 (DOWN)
	.long	shn_walk6_f4_anim	;6 (DOWN_LEFT)
	.long	shn_walk2_f2_anim	;7 (LEFT)
	.long	shn_walk6_f2_anim	;8 (UP-LEFT)

;(#5 - DOWN)
	.long	shn_walk5_f2_anim	;1 (UP)
	.long	shn_walk5_f2_anim	;2 (UP_RIGHT)
	.long	shn_walk5_f4_anim	;3 (RIGHT)
	.long	shn_walk5_f4_anim	;4 (DOWN_RIGHT)
	.long	shn_walk5_f4_anim	;5 (DOWN)
	.long	shn_walk5_f4_anim	;6 (DOWN_LEFT)
	.long	shn_walk5_f2_anim	;7 (LEFT)
	.long	shn_walk5_f2_anim	;8 (UP-LEFT)

;(#6 - DOWN-LEFT)
	.long	shn_walk2_f2_anim	;1 (UP)
	.long	shn_walk6_f2_anim	;2 (UP_RIGHT)
	.long	shn_walk2_f2_anim	;3 (RIGHT)
	.long	shn_walk6_f4_anim	;4 (DOWN_RIGHT)
	.long	shn_walk2_f4_anim	;5 (DOWN)
	.long	shn_walk4_f4_anim	;6 (DOWN_LEFT)
	.long	shn_walk2_f2_anim	;7 (LEFT)
	.long	shn_walk8_f2_anim	;8 (UP-LEFT)

;(#7 - LEFT)
	.long	shn_walk2_f2_anim	;1 (UP)
	.long	shn_walk6_f2_anim	;2 (UP_RIGHT)
	.long	shn_walk6_f2_anim	;3 (RIGHT)
	.long	shn_walk8_f4_anim	;4 (DOWN_RIGHT)
	.long	shn_walk4_f4_anim	;5 (DOWN)
	.long	shn_walk4_f4_anim	;6 (DOWN_LEFT)
	.long	shn_walk2_f2_anim	;7 (LEFT)
	.long	shn_walk2_f2_anim	;8 (UP-LEFT)

;(#8 - UP-LEFT)
	.long	shn_walk2_f2_anim	;1 (UP)
	.long	shn_walk4_f2_anim	;2 (UP_RIGHT)
	.long	shn_walk6_f2_anim	;3 (RIGHT)
	.long	shn_walk8_f4_anim	;4 (DOWN_RIGHT)
	.long	shn_walk6_f4_anim	;5 (DOWN)
	.long	shn_walk2_f4_anim	;6 (DOWN_LEFT)
	.long	shn_walk2_f2_anim	;7 (LEFT)
	.long	shn_walk2_f2_anim	;8 (UP-LEFT)


 SUBR	shn_torso_anims_table
; old = up right
	.long	shn_torso2_anim		;new = up right
	.long	shn_2_to_4_turn2_anim	;    = down right
	.long	shn_2_to_6_turn2_anim	;    = down left
	.long	shn_2_to_8_turn2_anim	;    = up left

; old = down right
	.long	shn_4_to_2_turn2_anim	;new = up right
	.long	shn_torso4_anim		;    = down right
	.long	shn_4_to_6_turn2_anim	;    = down left
	.long	shn_4_to_8_turn2_anim	;    = up left

; old = down left
	.long	shn_6_to_2_turn2_anim	;new = up right
	.long	shn_6_to_4_turn2_anim	;    = down right
	.long	shn_torso6_anim		;    = down left
	.long	shn_6_to_8_turn2_anim	;    = up left

; old = up left
	.long	shn_8_to_2_turn2_anim	;new = up right
	.long	shn_8_to_4_turn2_anim	;    = down right
	.long	shn_8_to_6_turn2_anim	;    = down left
	.long	shn_torso8_anim		;    = up left


******************************************************************************

	.end
