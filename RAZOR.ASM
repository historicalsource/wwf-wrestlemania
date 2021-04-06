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
	.include	"damage.equ"


******************************************************************************
* EXTERNAL REFERENCES

	.ref	change_anim1a,change_anim2a,do_taunt,bounce_off_ropes
	.ref	check_secret_moves,master_keep_attached,ck_ignore
	.ref	climb_turnbuckle,execute_walk,get_opp_plyrmode,mode_inair2
	.ref	process_ptrs,keep_attached,FIND_AND_KILL_ENDLESS
	.ref	change_anim1,JUMP_ROPES,PCNT
	.ref	DO_REVERSAL,DO_REVERSAL_MESS,CHECK_COMBO_GO
	.ref	ADD_IF_SILENT,CLIMB_ROPES,can_pin
	.ref	get_opp_process,round_award,set_raisearm_bit
	.ref	BONUS_MESS,ck_teammate_pin,raisearm_check
	.ref	BLOCK_WOOSH,drone_change_back
	.ref	blocking_off,std_taunt,std_walk_fast
	.ref	hyper_speed_on
	.ref	in_finish_move
	.ref	p1rounds,p2rounds
	.if NUM_RAZOR_FINISHES
	.ref	rzr_finish1_move
	.if NUM_RAZOR_FINISHES > 1
	.ref	rzr_finish2_move
	.endif
	.endif

;animation sequences

	.ref	rzr_run2_anim

	.ref	start_run_anim

	.ref	rzr_3_head_hold2_anim
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
	.ref	rzr_4_uprcut_anim
	.ref	rzr_2_butt_anim,rzr_4_butt_anim
	.ref	rzr_2_kick_anim,rzr_4_kick_anim
	.ref	rzr_2_super_kick_anim,rzr_4_super_kick_anim
	.ref	rzr_2_knee_anim,rzr_4_knee_anim
	.ref	rzr_flying_kick_anim
	.ref	rzr_2_ground_punch_anim,rzr_4_ground_punch_anim
	.ref	rzr_2_stomp_anim,rzr_4_stomp_anim
	.ref	rzr_2_grabfling_anim,rzr_4_grabfling_anim
	.ref	rzr_2_hair_pickup_anim,rzr_4_hair_pickup_anim

	.ref	rzr_4_push_anim
	.ref	rzr_4_bigboot_anim
	.ref	rzr_climb_down_anim,rzr_climb_up_anim

	.ref	rzr_2_block_anim,rzr_4_block_anim
	.ref	rzr_2_hiptoss_anim,rzr_4_hiptoss_anim
	.ref	rzr_2_hiptoss2_anim,rzr_4_hiptoss2_anim
	.ref	rzr_flying_elbow_anim
	.ref	rzr_3_uslash_anim,rzr_3_dslash_anim
	.ref	rzr_dslashes_to_head_anim,rzr_dslash_to_head_anim
	.ref	rzr_uslashes_to_head_anim,rzr_uslash_to_head_anim
	.ref	rzr_rugshake_anim
	.ref	rzr_tbukl_elbow_anim,rzr_3_pile_driver_anim
	.ref	rzr_repeat_slash_anim
	.ref	rzr_4_knee_fall_anim

	.ref	rzr_combo_punch_anim,rzr_combo_kick_anim

	.ref	rzr_2_raise_arm_anim,rzr_4_raise_arm_anim

;	.ref	rzr_pkup_chair_anim
	.ref	rzr_rugshake2_anim
	.ref	rzr_fall_back_anim,rzr_razors_edge_anim

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************

razor_secret_moves

	.long	#charge_flying_kick	;must have this one
	.long	#neck_grab
	.long	#grab_fling
	.long	#hip_toss
	.long	#grab_fling2
	.long	#hip_toss2
	.long	#down_slash
	.long	0

******************************************************************************
*
* SPECIAL MOVE PROCESSES - Secret moves
*
;a8=process of wrestler

 SUBR	rzr_smove_table
	.long	rzr_charge_slashes
	.long	rzr_hdhold_pile
	.long	rzr_hdhold_combo1
	.long	rzr_hdhold_edge
	.long	rzr_hdhold_rug
	.long	rzr_grab_toss_air
	.long	rzr_hdhold_combo2
;	REFLONG	std_hdhold_anti_combo
	.long	std_walk_fast
	.long	std_taunt
	.long	rzr_sliding_rug

	.if NUM_RAZOR_FINISHES
	.long	rzr_finish_move1
	.endif
	.if NUM_RAZOR_FINISHES > 1
	.long	rzr_finish_move2
	.endif
	.long	0


*******************************************************************************

#charge_flying_kick
	move	*a13(BUT_VAL_UP),a0
	btst	PLAYER_SKICK_BIT,a0
	jrz	#no_kick

	move	*a13(PLYRNUM),a0
	.ref	get_powerk_dtime
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
	move	*a13(GETUP_TIME),a0
	jrnz	#out
	cmpi	MODE_ONGROUND,a0
	jrz	#out
	cmpi	MODE_DEAD,a0
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

	SETMODE	INAIR

	movk	1,a0			;Ensure leap at
	move	a0,*a8(OBJ_XVEL),L

	movi	rzr_flying_kick_anim,a0
	calla	change_anim1a

	WRSND	W_RAZOR,FLYKICK_T1,FLYKICK_T2

	rets


******************************************************************************
#neck_grab
	.word	B_SPUNCH,		J_REAL_LR | J_TOWARD | J_AWAY | J_UP
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
	.ref	rzr_3_fake_hold_anim
	movi	rzr_3_fake_hold_anim,a0
	calla	change_anim1a
	rets

#ok2
	move	*a13(CLOSEST_XDIST),a1
	cmpi	85,a1
	jrgt	#std_grab

	movi	rzr_3_head_hold2_anim,a0
	calla	change_anim1a
	rets

#std_grab
	movi	rzr_3_head_hold_anim,a0
	calla	change_anim1a
	rets

******************************************************************************
#down_slash
	.word	B_PUNCH,		J_ALL
	.word	J_TOWARD,		J_REAL_LR
	.word	J_DOWN|J_TOWARD,	J_REAL_LR
	.word	J_DOWN,			J_REAL_LR
	.word	8000h | 50		;max
	.long	#dslash

#dslash
	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#out

	;check opp mode
	calla	get_opp_plyrmode
	cmpi	MODE_DEAD,a0
	jreq	#out

	;don't do it unless you're in mode_normal, running, or headhold
	move	*a13(PLYRMODE),a0
	cmpi	MODE_NORMAL,a0
	jreq	#slash
	cmpi	MODE_RUNNING,a0
	jreq	#runslash
	cmpi	MODE_HEADHOLD,a0
	jreq	#slash
	jruc	#z

#runslash
	;don't interrupt an OCRUN
	move	*a13(GETUP_TIME),a14
	jrnz	#z
#slash
	WRSND	W_RAZOR,KICK_T2
	movi	rzr_3_dslash_anim,a0
	calla	change_anim1a
#z	rets

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

******************************************************************************
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
	FACE24	rzr,hiptoss_anim
	calla	change_anim1a

	WRSND	W_RAZOR,GRABFLING_T1,PUNCH_T2
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
;	jrge	#ok2a
;
;;This head grab is too close (in terms of time) to most recent grab
;	movi	rzr_3_uslash_anim,a0
;	calla	change_anim1a
;
;	WRSND	W_RAZOR,SPUNCH_T1,SPUNCH_T2
;	rets
;
;#ok2a
;	move	@PCNT,a14,L			;use 32-bit PCNT!
;	move	a14,*a13(LAST_FLING_ATTEMPT),L

	FACE24	rzr,grabfling_anim
	calla	change_anim1a

	WRSND	W_RAZOR,GRABFLING_T1,PUNCH_T2
#out	rets

******************************************************************************

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
	FACE24	rzr,hiptoss_anim
	calla	change_anim1a

	WRSND	W_RAZOR,GRABFLING_T1,PUNCH_T2
	rets

	.if NUM_RAZOR_FINISHES
#******************************************************************************
 SUBRP	rzr_finish_move1

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

	movi		rzr_finish1_move,a0
	move		a0,*a8(SPECIAL_MOVE_ADDR),L
	DIE
	.endif
	

	.if NUM_RAZOR_FINISHES > 1
#******************************************************************************
 SUBRP	rzr_finish_move2

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

	movi		rzr_finish2_move,a0
	move		a0,*a8(SPECIAL_MOVE_ADDR),L
	DIE
	.endif


#*****************************************************************************

;	STRUCTPD
;	WORD		#CHARGE_TIME	;UDW
#CHARGE_TIME	.equ	SM_USRW1

rzr_charge_slashes

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

;Success!  Check for the UNINT bit, then queue it up.
	move	*a8(ANIMODE),a14
	btst	MODE_UNINT_BIT,a14
	jrnz	#start_over

	move	*a8(GETUP_TIME),a0
	jrnz	#start_over

	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHELD,a0
	jrz	#start_over
	cmpi	MODE_HEADHOLD,a0
	jrz	#start_over
	cmpi	MODE_ONGROUND,a0
	jrz	#start_over
	cmpi	MODE_DEAD,a0
	jrz	#start_over

	movi	rzr_repeat_slash_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L
	WRSND	W_RAZOR,KICK_T2

	jruc	#start_over

#*******************************************************************************

rzr_sliding_rug

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
;	cmpi	MODE_ONGROUND,a0
;	jrz	#lp
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

	WRSND	W_RAZOR,GRABHOLD_T1,GRABHOLD_T2
	.ref	rzr_sliding_rug_anim
	movi	rzr_sliding_rug_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEPK	20

	jruc	#lp

#*****************************************************************************
rzr_hdhold_edge

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
	
	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrz	#slam
	cmpi	MODE_HEADHELD,a0
	jrnz	#lp0
	move	*a8(I_WILL_DIE),A14
	jrnz	#lp0

	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

	calla	DO_REVERSAL
	calla	DO_REVERSAL_MESS

	;target WHOHITME -- don't hit anyone else
	SMRTTGT	a8,WHOHITME

	;immobilize WHOHITME
	move	*a8(WHOHITME),a0,L
	jruc	#is_reversal

#slam
	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

	movi	33,a10
	CREATE	MESSAGE_PID,BONUS_MESS

	;target WHOIHIT -- don't hit anyone else
	SMRTTGT	a8,WHOIHIT

	;immobilize WHOIHIT
	move	*a8(WHOIHIT),a0,L

#is_reversal
	movk	15,a14
	move	a14,*a0(IMMOBILIZE_TIME)

	CALLA	FIND_AND_KILL_ENDLESS

	movi	rzr_razors_edge_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L
	WRSND	W_RAZOR,GRABHOLD_T1,GRABHOLD_T2

	SLEEPK	20

	jruc	#lp

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

;	WAITSWITCH_DWN	J_UP,0,#lp
	WAITSWITCH_DWN	J_DOWN,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_DOWN,0,#lp
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

	calla	DO_REVERSAL
	calla	DO_REVERSAL_MESS

	;target WHOHITME -- don't hit anyone else
	SMRTTGT	a8,WHOHITME

	;immobilize WHOHITME
	move	*a8(WHOHITME),a0,L
	jruc	#is_reversal

#slam
	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

	movk	7,a10
	CREATE	MESSAGE_PID,BONUS_MESS

	;target WHOIHIT -- don't hit anyone else
	SMRTTGT	a8,WHOIHIT

	;immobilize WHOIHIT
	move	*a8(WHOIHIT),a0,L

#is_reversal
	movk	15,a14
	move	a14,*a0(IMMOBILIZE_TIME)

	CALLA	FIND_AND_KILL_ENDLESS
	movi	rzr_3_pile_driver_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L
	WRSND	W_RAZOR,GRABHOLD_T1,GRABHOLD_T2

	SLEEPK	20

	jruc	#lp

#*****************************************************************************
rzr_hdhold_rug

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

	calla	DO_REVERSAL
	calla	DO_REVERSAL_MESS

	;target WHOHITME -- don't hit anyone else
	SMRTTGT	a8,WHOHITME

	;immobilize WHOHITME
	move	*a8(WHOHITME),a0,L
	jruc	#is_reversal

#slam
	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

	movk	6,a10
	CREATE	MESSAGE_PID,BONUS_MESS

	;target WHOIHIT -- don't hit anyone else
	SMRTTGT	a8,WHOIHIT

	;immobilize WHOIHIT
	move	*a8(WHOIHIT),a0,L

#is_reversal
	movk	15,a14
	move	a14,*a0(IMMOBILIZE_TIME)

	CALLA	FIND_AND_KILL_ENDLESS

	movi	rzr_rugshake2_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEPK	20

	jruc	#lp

#*****************************************************************************
rzr_hdhold_combo1

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
	WAITSWITCH_DWN	B_SPUNCH,J_ALL,#lp

	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrz	#slam
	cmpi	MODE_HEADHELD,a0
	jrnz	#lp0

#slam
	CALLA	FIND_AND_KILL_ENDLESS
	movi	rzr_combo_punch_anim,a14
 	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEPK	20

	jruc	#lp

*******************************************************************************

#*
rzr_hdhold_combo2

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
	CALLA	FIND_AND_KILL_ENDLESS
	movi	rzr_combo_kick_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEPK	20

	jruc	#lp

*******************************************************************************
#*
rzr_grab_toss_air

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

	CALLA	FIND_AND_KILL_ENDLESS
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

	FACE24	rzr,hiptoss_anim
	move	a0,*a8(SPECIAL_MOVE_ADDR),L

	WRSND	W_RAZOR,GRABFLING_T1,PUNCH_T2

	SLEEPK	20
	jruc	#lp

#doit2
	FACE24	rzr,hiptoss2_anim
	move	a0,*a8(SPECIAL_MOVE_ADDR),L

	WRSND	W_RAZOR,GRABFLING_T1,PUNCH_T2

	SLEEPK	20

	jruc	#lp


;#******************************************************************************
;rzr_hdhold_anti_combo
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
;	movi	rzr_3_pile_driver_anim,a14
;	move	a14,*a8(SPECIAL_MOVE_ADDR),L
;
;	WRSND	W_RAZOR,GRABFLING_T1,PUNCH_T2
;
;	SLEEPK	20
;
;	jruc	#lp
;
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
	CREATE	TAUNT_PID,do_taunt
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
	REFLONG	mode_puppet		;20
	.long	mode_inair2		;21
	.long	mode_normal	;22
	.long	mode_normal	;23
	.long	mode_chokehold		;24
	REFLONG	mode_choking		;25

#*****************************************************************************

mode_normal	;0

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_interrupt

	move	*a13(I_WILL_DIE),a0
	jrz	#nope
	move	*a13(IMMOBILIZE_TIME),a0
	jrnz	#nope
;Player has died amidst a combo...
;Knock me down.
	movi	rzr_fall_back_anim,a0
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
	FACE24	rzr,pin_anim
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
	FACE24	rzr,raise_arm_anim
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
* normal	<  44  45	headbutt
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
	JJXM	NORMAL,		 44, 45,#punch_hdbutt,#punch_punch
	JJXM	DIZZY,		 44, 45,#punch_hdbutt,#punch_punch
	JJXM	BLOCK,		 44, 45,#punch_hdbutt,#punch_punch
	JJXM	ONGROUND,	160,140,#punch_lbdrop,#punch_punch
	JJXM	RUNNING, 	 44, 45,#punch_hdbutt,#punch_punch
	JJXM	BOUNCING,	 44, 45,#punch_hdbutt,#punch_punch
	JJXM	ONTURNBKL,		#punch_punch
	JJXM	CLIMBTURNBKL,		#punch_punch
	JJXM	INAIR,		 44, 45,#punch_hdbutt,#punch_punch
	JJXM	ATTACHED,	 44, 45,#punch_hdbutt,#punch_punch
	JJXM	DEAD,		160,140,#punch_lbdrop,#punch_punch
	JJXM	OPPOVERHEAD,	 44, 45,#punch_hdbutt,#punch_punch
	JJXM	WAITANIM,	 44, 45,#punch_hdbutt,#punch_punch
	JJXM	GRAPPLE,	 44, 45,#punch_hdbutt,#punch_punch
	JJXM	MASTER,		 44, 45,#punch_hdbutt,#punch_punch
	JJXM	SLAVE,		 44, 45,#punch_hdbutt,#punch_punch
	JJXM	HEADHOLD,	 44, 45,#punch_hdbutt,#punch_punch
	JJXM	HEADHELD,	 44, 45,#punch_hdbutt,#punch_punch
	JJXM	CHOKEHOLD,	 44, 45,#punch_hdbutt,#punch_punch
	JJXM	PUPPET,		 44, 45,#punch_hdbutt,#punch_punch
	JJXM	PUPPET2,	 44, 45,#punch_hdbutt,#punch_punch
	JJXM	INAIR2,		 44, 45,#punch_hdbutt,#punch_punch
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


************
#block		;2

std_block
	move	@blocking_off,a0
	jrnz	#no_blocking

	RND_AWARD	a13,BLOCKS_AWD

	FACE24	rzr,block_anim
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
#graboh
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal	<  85   45	headbutt or uppercut
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
	JJXM	NORMAL,		 85, 45,#spunch_close,#spunch_far
	JJXM	DIZZY,		 85, 45,#spunch_close,#spunch_far
	JJXM	BLOCK,		 85, 45,#spunch_close,#spunch_far
	JJXM	ONGROUND,	160,140,#spunch_lbowdrop,std_punch
	JJXM	DEAD,		160,140,#spunch_lbowdrop,std_punch
	JJXM	RUNNING,	 	#spunch_downslash
	JJXM	BOUNCING,	 	#spunch_downslash
	JJXM	ONTURNBKL,	 85, 45,#spunch_close,#spunch_far
	JJXM	CLIMBTURNBKL,	 85, 45,#spunch_close,#spunch_far
	JJXM	INAIR,		 	#spunch_downslash
	JJXM	ATTACHED,	 85, 45,#spunch_close,#spunch_far
	JJXM	OPPOVERHEAD,	 85, 45,#spunch_close,#spunch_far
	JJXM	WAITANIM,	 85, 45,#spunch_close,#spunch_far
	JJXM	GRAPPLE,	 85, 45,#spunch_close,#spunch_far
	JJXM	MASTER,		 85, 45,#spunch_close,#spunch_far
	JJXM	SLAVE,		 85, 45,#spunch_close,#spunch_far
	JJXM	HEADHOLD,	 85, 45,#spunch_close,#spunch_far
	JJXM	HEADHELD,	 85, 45,#spunch_close,#spunch_far
	JJXM	CHOKEHOLD,	 85, 45,#spunch_close,#spunch_far
	JJXM	PUPPET,		 85, 45,#spunch_close,#spunch_far
	JJXM	PUPPET2,	 85, 45,#spunch_close,#spunch_far
	JJXM	INAIR2,		 	#spunch_downslash
	JJXM_END


#spunch_lbowdrop

;If near opponents head, and facing down, do the hair grab!
;If near feet, go for the rugshake

	move	*a13(CLOSEST_NUM),a3
	X32	a3

	addi	process_ptrs,a3
	move	*a3,a3,L
	move	*a3(PLYRMODE),a2
	cmpi	MODE_DEAD,a2
	jrz	#no
	move	*a13(OBJ_XPOS),a1,L 
	move	*a3(OBJ_XPOS),a2,L
	sub	a2,a1
	abs	a1
	srl	16,a1
	cmpi	30h,a1	;28
 	jrlt	#no

;At head or feet!

	move	*a3(OBJ_CONTROL),a14
	andi	M_FLIPH,a14
	move	*a13(OBJ_CONTROL),a0
	andi	M_FLIPH,a0
	cmp	a0,a14
	jrz	#feet

;At head!  Do hair pickup.

	FACE24	rzr,hair_pickup_anim
	calla	change_anim1
	WRSND	W_RAZOR,LBOWDROP_T1,LBOWDROP_T2
	rets

#feet
	cmpi	40h,a1	;28
 	jrlt	#no

	;smart-target the intended victim
	move	*a13(STATUS_FLAGS),a14
	ori	M_SMART_ATTACK,a14
	move	a14,*a13(STATUS_FLAGS)
	move	a3,*a13(SMART_TARGET),L

	movi	rzr_rugshake_anim,a0
	calla	change_anim1a
	rets

#no
	FACE24	rzr,ground_punch_anim
	calla	change_anim1a

	WRSND	W_RAZOR,LBOWDROP_T1,LBOWDROP_T2
	rets

*****
#spunch_close
	move	*a13(STICK_VAL_CUR),a0
	btst	MOVE_DOWN_BIT,a0
	jrnz	#ck_up
;	move	*a13(NEW_FACING_DIR),a1
;	andi	0Ch,a1
;	cmp	a0,a1
;	jrz	#grab

	move	*a13(CLOSEST_XDIST),a1
	cmpi	65,a1
	jrgt	std_punch
;	jruc	#hdbutt
;#grab
;	movi	rzr_3_head_hold2_anim,a0
;	calla	change_anim1a
;	WRSND	W_RAZOR,GRABHOLD_T1,GRABHOLD_T2
;	rets
;
;#hdbutt
	.ref	rzr_2_pummel_anim
	.ref	rzr_4_pummel_anim

	FACE24	rzr,pummel_anim
	calla	change_anim1
	WRSND	W_RAZOR,HDBUTT_T1,HDBUTT_T2
	rets

#ck_up
;Do uppercut
	movi	rzr_4_uprcut_anim,a0
	calla	change_anim1a
	WRSND	W_RAZOR,UPRCUT_T1,UPRCUT_T2
	rets

*****
#spunch_far
	WRSND	W_RAZOR,UPRCUT_T1,UPRCUT_T2
	movi	rzr_3_uslash_anim,a0
	calla	change_anim1a
	rets

*****
#spunch_downslash
	WRSND	W_RAZOR,UPRCUT_T1,UPRCUT_T2
	movi	rzr_3_dslash_anim,a0
	calla	change_anim1a
	rets

************
#kick		;8
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal	<  70   50	knee
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
	JJXM	NORMAL,		 70, 50,#kick_knee,#kick_kick
	JJXM	DIZZY,		 70, 50,#kick_knee,#kick_kick
	JJXM	BLOCK,		 70, 50,#kick_knee,#kick_kick
	JJXM	ONGROUND,	160,140,#kick_stomp,#kick_kick
	JJXM	RUNNING,	 70, 50,#kick_knee,#kick_kick
	JJXM	BOUNCING, 	 70, 50,#kick_knee,#kick_kick
	JJXM	ONTURNBKL,	 	#kick_kick
	JJXM	CLIMBTURNBKL,	 	#kick_kick
	JJXM	INAIR,		 70, 50,#kick_knee,#kick_kick
	JJXM	ATTACHED,	 70, 50,#kick_knee,#kick_kick
	JJXM	DEAD,		160,140,#kick_stomp,#kick_kick
	JJXM	OPPOVERHEAD,	 70, 50,#kick_knee,#kick_kick
	JJXM	WAITANIM,	 70, 50,#kick_knee,#kick_kick
	JJXM	GRAPPLE,	 70, 50,#kick_knee,#kick_kick
	JJXM	MASTER,		 70, 50,#kick_knee,#kick_kick
	JJXM	SLAVE,		 70, 50,#kick_knee,#kick_kick
	JJXM	HEADHOLD,	 70, 50,#kick_knee,#kick_kick
	JJXM	HEADHELD,	 70, 50,#kick_knee,#kick_kick
	JJXM	CHOKEHOLD,	 70, 50,#kick_knee,#kick_kick
	JJXM	PUPPET,		 70, 50,#kick_knee,#kick_kick
	JJXM	PUPPET2,	 70, 50,#kick_knee,#kick_kick
	JJXM	INAIR2,		 	#kick_TB
	JJXM_END

*****
#kick_TB
	.ref	rzr_kick_TB_anim
	movi	rzr_kick_TB_anim,a0
	calla	change_anim1a

	WRSND	W_RAZOR,KICK_T1,KICK_T2
	rets

*****
#kick_kick
std_kick

	FACE24	rzr,kick_anim
	calla	change_anim1a

	WRSND	W_RAZOR,KICK_T1,KICK_T2
	rets

*****
#kick_knee
std_knee

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


************
#super_kick	;16
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
* normal	<  70   60	close in super move
* dizzy			"		"
* normal	>		jumping kick move
* dizzy			"		"
*
* onground	< 114  160	super stomp
* onground	>		normal kick
*
* running			big boot
* bouncing			big boot
*
* onturnbkl	<  70   96	jumping kick move
* climbturnbkl		"		"
* onturnbkl	>		normal kick
* climbturnbkl		"		"
*
	JJXM_INIT
	JJXM	NORMAL,		 70, 60,#skick_special,#skick_kick	;0
	JJXM	RUNNING,	 	#skick_bigboot			;1
	JJXM	INAIR,		 70, 60,#skick_special,#skick_kick	;2
	JJXM	ATTACHED,	 70, 60,#skick_special,#skick_kick	;3
	JJXM	ONGROUND,	160,140,#skick_stomp,std_kick		;4
	JJXM	BOUNCING,	 	#skick_bigboot			;5
	JJXM	ONTURNBKL,	 70, 96,#skick_kick,std_kick		;6
	JJXM	BLOCK,		 70, 60,#skick_special,#skick_kick	;7
	JJXM	DIZZY,		 70, 60,#skick_special,#skick_kick	;8
	JJXM	DEAD,		160,140,#skick_stomp,std_kick		;9
	JJXM	OPPOVERHEAD,	 70, 60,#skick_special,#skick_kick	;10
	JJXM	CLIMBTURNBKL,	 70, 96,#skick_kick,std_kick		;11
	JJXM	WAITANIM,	 70, 62,#skick_special,#skick_kick	;12
	JJXM	GRAPPLE,	 70, 62,#skick_special,#skick_kick	;13
	JJXM	MASTER,		 70, 62,#skick_special,#skick_kick	;14
	JJXM	SLAVE, 		 70, 62,#skick_special,#skick_kick	;15
	JJXM	HEADHOLD,	 70, 62,#skick_special,#skick_kick	;16
	JJXM	HEADHELD,	 	std_kick
	JJXM	CHOKEHOLD,	 70, 62,#skick_special,#skick_kick	;16
	JJXM	PUPPET,		 70, 62,#skick_special,#skick_kick	;20
	JJXM	PUPPET2,	 70, 62,#skick_special,#skick_kick	;20
	JJXM	INAIR2,		 	#kick_TB
	JJXM_END

*****
#skick_kick
	FACE24	rzr,super_kick_anim
	calla	change_anim1a

	WRSND	W_RAZOR,FLYKICK_T1,FLYKICK_T2
	rets


*****
#skick_special

	move	*a13(STICK_VAL_CUR),a0
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrz	#super_knee

	FACE24	rzr,knee_anim
	calla	change_anim1a

	WRSND	W_RAZOR,KICK_T1,KICK_T2

	rets

#super_knee
	movi	rzr_4_knee_fall_anim,a0
	calla	change_anim1

	WRSND	W_RAZOR,GRABHOLD_T1,GRABHOLD_T2
	rets

*****
#skick_stomp

	FACE24	rzr,stomp_anim
	calla	change_anim1a

	WRSND	W_RAZOR,KICK_T1,KICK_T2

	rets

*****
#skick_bigboot

	movi	rzr_4_bigboot_anim,a0		;*****
	calla	change_anim1a

	WRSND	W_RAZOR,FLYKICK_T1,FLYKICK_T2

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

#XRUN_VAL	equ	RZR_XRUN
#ZDRIFT_VAL	equ	RZR_ZDRIFT

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

;	.long	#z					;0
;	.long	#punch					;1
;	.long	#block					;2
;	.long	#z					;3
;	.long	#super_punch				;4
;	.long	#super_punch,#z,#z			;5-7
;	.long	#kick					;8
;	.long	punchkick,#z,#z,#kick,#z,#z,#z		;9-15
;	.long	#super_kick				;16
;	.long	#z,#z,#z,#graboh,#z,#z,#z		;17-23
;	.long	#kick,#z,#z,#z,#z,#z,#z,#z		;24-31



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
#punchkick
#graboh
*
* MODE		   DX  DZ	ACTION
* ----------------------------------------------------
*
* onground|dead	< 176 176	running stomp
* onground|dead	>		nothing
*
* all else			flying kick
*

	JJXM_INIT
	JJXM	NORMAL,			#punch_clothesline
	JJXM	BLOCK,			#punch_clothesline
	JJXM	DIZZY,			#punch_clothesline
	JJXM	ONGROUND,	176,176,#punch_flyelbow,#punch_rets
	JJXM	RUNNING,		#punch_clothesline
	JJXM	BOUNCING,		#punch_clothesline
	JJXM	ONTURNBKL,		#punch_clothesline
	JJXM	CLIMBTURNBKL,		#punch_clothesline
	JJXM	INAIR,			#punch_clothesline
	JJXM	ATTACHED,		#punch_clothesline
	JJXM	DEAD,		176,176,#punch_flyelbow,#punch_rets
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

	movi	rzr_3_uslash_anim,a0
	calla	change_anim1a

	WRSND	W_RAZOR,GRABHOLD_T1,GRABHOLD_T2

	rets

#hdbutt

	FACE24	rzr,butt_anim
	calla	change_anim1

	WRSND	W_RAZOR,HDBUTT_T1,HDBUTT_T2

	rets

#punch_flyelbow
std_flyelbow
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
	JJXM	NORMAL,			#kick_flykick
	JJXM	BLOCK,			#kick_flykick
	JJXM	DIZZY,			#kick_flykick
	JJXM	ONGROUND,		std_flyelbow
	JJXM	RUNNING,		#kick_flykick
	JJXM	BOUNCING,		#kick_flykick
	JJXM	ONTURNBKL,		#kick_flykick
	JJXM	CLIMBTURNBKL,		#kick_flykick
	JJXM	INAIR,			#kick_flykick
	JJXM	ATTACHED,		#kick_flykick
	JJXM	DEAD,			std_flyelbow
	JJXM	OPPOVERHEAD,		#kick_flykick
	JJXM	WAITANIM,		#kick_flykick
	JJXM	GRAPPLE,		#kick_flykick
	JJXM	MASTER,			#kick_flykick
	JJXM	SLAVE,			#kick_flykick
	JJXM	HEADHOLD,		#kick_flykick
	JJXM	HEADHELD,		#kick_flykick
	JJXM	CHOKEHOLD,		#kick_flykick
	JJXM	PUPPET,			#kick_flykick
	JJXM	PUPPET2,		#kick_flykick
	JJXM	INAIR2,			#kick_flykick
	JJXM_END

#kick_flykick
std_flykick

	calla	ck_ignore
	jrc	#z

	movi	rzr_flying_kick_anim,a0
	calla	change_anim1a

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

;	;check unint
;	move	*a13(ANIMODE),a14
;	btst	MODE_UNINT_BIT,a14
;	jrnz	#no_interrupt

	move	*a13(STICK_VAL_CUR),a0
	btst	PLAYER_DOWN_BIT,a0
	jrz	#no_climbdown

	movi	rzr_climb_down_anim,a0
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

;	.long	#z					;0
;	.long	#punch					;1
;	.long	#block					;2
;	.long	#z					;3
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
#punch		;1
#block		;2
#super_punch	;4
#punchkick	;5
#kick		;8
#super_kick	;16
#graboh		;20

	SETMODE	INAIR

	movi	rzr_tbukl_elbow_anim,a0
	calla	change_anim1a

	WRSND	W_RAZOR,TURNDIVE_T1,TURNDIVE_T2
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

	movi	rzr_4_push_anim,a0
	calla	change_anim1a

	WRSND	W_RAZOR,PUSH_T1,PUSH_T2

	rets


#*****************************************************************************
* razor with zero health

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

	WRSND	W_RAZOR,GRABHOLD_T1,GRABHOLD_T2

	movi	rzr_razors_edge_anim,a0
	move	@PCNT,a14
	btst	0,a14
	jrz	#tag
	movi	rzr_3_pile_driver_anim,a0
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

;	.long	#z					;0
;	.long	#punch					;1
;	.long	#block					;2
;	.long	#z					;3
;	.long	#super_punch				;4
;	.long	#super_punch,#z,#z			;5-7
;	.long	#kick					;8
;	.long	#punchkick,#z,#z,#kick,#z,#z,#z		;9-15
;	.long	#super_kick				;16
;	.long	#z,#z,#z,#graboh,#z,#z,#z		;17-23
;	.long	#kick,#z,#z,#z,#z,#z,#z,#z		;24-31


************
#block
#graboh
#z		;0
	rets

************
#punch		;1
#punchkick

	CALLA	FIND_AND_KILL_ENDLESS
	;if stick is up, do quick upslashes.  If it's down, do quick
	; downslashes.  Otherwise, do a normal upslash.
	move	*a13(STICK_VAL_CUR),a0
	btst	MOVE_UP_BIT,a0
	jrnz	#quick_upslashes
	btst	MOVE_DOWN_BIT,a0
	jrnz	#quick_dnslashes

	.ref	rzr_4_kick2_anim
	movi	rzr_4_kick2_anim,a0
	calla	change_anim1a
	WRSND	W_RAZOR,KICK_T1,KICK_T2
	rets

#quick_upslashes
	movi	rzr_uslashes_to_head_anim,a0
	calla	change_anim1a
	WRSND	W_RAZOR,UPRCUT_T2
	rets

#quick_dnslashes
	movi	rzr_dslashes_to_head_anim,a0
	calla	change_anim1a
	WRSND	W_RAZOR,UPRCUT_T2
	rets

************
#super_punch	;4

	move	*a13(STICK_VAL_CUR),a0
	btst	MOVE_DOWN_BIT,a0
	jrz	#z

	CALLA	FIND_AND_KILL_ENDLESS

	SPCDMG	D_UPRCUT/2,15

	movi	rzr_4_uprcut_anim,a0
	calla	change_anim1a
	WRSND	W_RAZOR,UPRCUT_T1,UPRCUT_T2

	rets

************
#kick		;8

	CALLA	FIND_AND_KILL_ENDLESS
;	FACE24	rzr,kick_anim
	movi	rzr_4_kick2_anim,a0
	calla	change_anim1a
	WRSND	W_RAZOR,KICK_T1,KICK_T2
	rets

************
#super_kick	;16
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

	WRSND	W_RAZOR,GRABHOLD_T1,GRABHOLD_T2

	movi	rzr_razors_edge_anim,a0
	move	@PCNT,a14
	btst	0,a14
	jrz	#tag
	movi	rzr_3_pile_driver_anim,a0
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

	movi	rzr_3_head_held_stand_anim,a0
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