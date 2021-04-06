**************************************************************
*
* Software:		Gilbert the Wonder Hamster
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
	.include	"damage.equ"


******************************************************************************
* EXTERNAL REFERENCES

	.ref	change_anim1a,change_anim2a,master_keep_attached
	.ref	do_taunt,CLIMB_ROPES,bounce_off_ropes,mode_inair2
	.ref	check_secret_moves,mode_choking,DO_REVERSAL_MESS
	.ref	ck_ignore,climb_turnbuckle,execute_walk,PCNT
	.ref	get_opp_plyrmode,ADD_IF_SILENT,DO_REVERSAL,mode_puppet
	.ref	process_ptrs,keep_attached,change_anim1,JUMP_ROPES
	.ref	FIND_AND_KILL_ENDLESS,BONUS_MESS
	.ref	CHECK_COMBO_GO,ck_teammate_pin,raisearm_check
	.ref	BLOCK_WOOSH,drone_change_back,mode_dead,get_opp_process
	.ref	lex_combo_punch_anim,can_pin,round_award
	.ref	lex_combo_kick_anim,set_raisearm_bit
	.ref	blocking_off,std_taunt,std_walk_fast
	.ref	hyper_speed_on
	.ref	in_finish_move
	.ref	p1rounds,p2rounds
	.if NUM_LEX_FINISHES
	.ref	lex_finish1_move
	.if NUM_LEX_FINISHES > 1
	.ref	lex_finish2_move
	.endif
	.endif

******************************************************************************
* ANIMATION SEQUENCES

	.ref	start_run_anim

	.ref	lex_4_block_anim

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

	.ref	lex_run2_anim,lex_hiptoss2_anim

	.ref	lex_2_punch_anim,lex_4_punch_anim
	.ref	lex_2_kick_anim,lex_4_kick_anim

	.ref	lex_2_butt_anim,lex_4_butt_anim
	.ref	lex_4_knee_anim
	.ref	lex_2_stomp_anim,lex_4_stomp_anim

	.ref	lex_2_raise_arm_anim,lex_4_raise_arm_anim

	.ref	lex_3_clobber_anim

	.ref	lex_4_push_anim

	.ref	lex_4_grabfling_anim

	.ref	lex_fall_back_anim

	.ref	lex_flying_kick_anim

	.ref	lex_2_ground_punch_anim,lex_4_ground_punch_anim
	.ref	lex_flying_ground_punch_anim,lex_climb_down_anim
	.ref	lex_buckle_leap_anim,lex_climb_up_anim
	.ref	lex_backbreaker_anim,lex_ohslam_anim

	.ref	lex_3_head_held_stand_anim,lex_2_hair_pickup_anim
	.ref	lex_3_knee_to_head_anim
	.ref	lex_4_hair_pickup_anim,lex_2_grabfling_anim
	.ref	lex_3_head_hold2_anim
	.ref	lex_3_head_hold_anim

	.ref	lex_vsuplex_anim,lex_super_kick_anim
	.ref	lex_4_knee_fall_anim,lex_4_graboh_anim
	.ref	lex_hiptoss_anim,lex_4_bigboot_anim
	.ref	lex_slamdown_anim

	.ref	lex_2_pin_anim,lex_4_pin_anim
	.ref	lex_2_clobber_anim,lex_4_clobber_anim

;	.ref	lex_pkup_chair_anim
	.ref	lex_sliding_elbow_anim
	.ref	lex_knees_to_head_anim
	.ref	lex_grab2elbow_anim

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* SPECIAL MOVES - History checks

lex_secret_moves
	.long	#charge_clobber
	.long	#neck_grab
	.long	#grab_fling
	.long	#hip_toss
	.long	#grab_fling2
	.long	#hip_toss2
	.long	#sliding_elbow
	.long	#hammer
	.long	0

******************************************************************************
*
* SPECIAL MOVE PROCESSES - Secret moves
*
;a8=process of wrestler

 SUBR	lex_smove_table
	.long	lex_hdhold_pile
	.long	lex_hdhold_elbow_face
	.long	lex_hdhold_graboh
	.long	lex_grab_toss_air
	.long	lex_hdhold_combo1
	.long	lex_hdhold_combo2
;	.long	lex_hdhold_anti_combo
	.long	std_walk_fast
	.long	std_taunt

	.if NUM_LEX_FINISHES
	.long	lex_finish_move1
	.endif
	.if NUM_LEX_FINISHES > 1
	.long	lex_finish_move2
	.endif
	.long	0

*******************************************************************************
#charge_clobber
	move	*a13(BUT_VAL_UP),a0
	btst	PLAYER_PUNCH_BIT,a0
	jrz	#no_punch

;	move	*a13(PLYRMODE),a0
;	cmpi	MODE_ONTURNBKL,a0
;	jrz	#no_punch

	move	*a13(PLYRNUM),a0
	.ref	get_punch_dtime
	calla	get_punch_dtime
	cmpi	100,a0			;> min?
	jrlt	#no_punch

	callr	#scrt_clbr
	setc
	rets

#no_punch
	clrc
	rets


#scrt_clbr

	move	*a13(PLYRMODE),a0
	cmpi	MODE_HEADHELD,a0
	jrz	#out
	cmpi	MODE_HEADHOLD,a0
	jrz	#out

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#out

;Don't do it when he is on ground
;	calla	get_opp_plyrmode
;	cmpi	MODE_ONGROUND,a0
;	jrz	#out
;	cmpi	MODE_DEAD,a0
;	jrz	#out
;	move	*a13(PLYRMODE),a0
;	cmpi	MODE_RUNNING,a0
;	jrz	#leapclbr
;
;;If stick is toward opponent, then do sliding/leaping buzzer
;	move	*a13(STICK_VAL_CUR),a0
;	move	*a13(NEW_FACING_DIR),a1
;	andi	0ch,a1
;	cmp	a0,a1
;	jrnz	#norm
;
;#leapclbr
;;missing noise for a reason !
;	WRSND	W_LUGER,HDBUTT_T1,HDBUTT_T2
;	FACE24	lex,clobber2_anim
;	calla	change_anim1
;	rets
;#norm

	WRSND	W_LUGER,HDBUTT_T1,HDBUTT_T2
	FACE24	lex,clobber_anim
	calla	change_anim1

	rets

*******************************************************************************
#hammer
	.word	B_SKICK,			J_ALL
	.word	J_TOWARD,		J_REAL_LR
	.word	J_TOWARD,		J_REAL_LR
	.word	8000h | 32 		;max
	.long	scrt_hammer

scrt_hammer
	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#out

	move	*a13(PLYRMODE),a0
	cmpi	MODE_ONTURNBKL,a0
	jrz	#out
	cmpi	MODE_OPPOVERHEAD,a0
	jreq	#out

	.ref	lex_hammer_anim
	movi	lex_hammer_anim,a0
	calla	change_anim1a

;missing noise for a reason !
	WRSND	W_LUGER,HIPTOSS_T1,PUNCH_T2

	rets

******************************************************************************
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
;Mode held overhead!
	cmpi	MODE_ATTACHED,a0
	jrz	#out

	move	*a13(LAST_HEADHOLD),a14,L
	move	@PCNT,a0,L
	sub	a14,a0
	cmpi	2*60,a0
	jrge	#ok2

;This head grab is too close (in terms of time) to most recent grab
	.ref	lex_3_fake_hold_anim
	movi	lex_3_fake_hold_anim,a0
	calla	change_anim1a
	rets

#ok2
	move	*a13(CLOSEST_XDIST),a1
	cmpi	90,a1
	jrgt	#std_grab

	movi	lex_3_head_hold2_anim,a0
	calla	change_anim1a
#out	rets

#std_grab
	movi	lex_3_head_hold_anim,a0
	calla	change_anim1a
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
	movi	lex_hiptoss_anim,a0
	calla	change_anim1a

	WRSND	W_LUGER,HIPTOSS_T1,PUNCH_T2
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
;Mode held overhead!
	cmpi	MODE_ATTACHED,a0
	jrz	#out

;	move	*a13(LAST_FLING_ATTEMPT),a14,L
;	move	@PCNT,a0,L
;	sub	a14,a0
;	cmpi	3*60,a0
;	jrge	#ok2a
;
;;This head grab is too close (in terms of time) to most recent grab
;	movi	lex_3_clobber_anim,a0
;;	FACE24	lex,punch_anim
;	calla	change_anim1a
;
;	WRSND	W_LUGER,HIPTOSS_T1,PUNCH_T2
;	rets
;
;#ok2a
;	move	@PCNT,a14,L			;use 32-bit PCNT!
;	move	a14,*a13(LAST_FLING_ATTEMPT),L

	FACE24	lex,grabfling_anim
	calla	change_anim1a

	WRSND	W_LUGER,GRABFLING_T1,PUNCH_T2
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
;Mode held overhead!
	cmpi	MODE_ATTACHED,a0
	jrz	#out

	move	*a13(CLOSEST_DIST),a0
	cmpi	70h,a0
	jrgt	#out

#doit
 	movi	lex_hiptoss_anim,a0
	calla	change_anim1a

	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	SETMODE	NORMAL

	WRSND	W_LUGER,GRABFLING_T1,PUNCH_T2

	rets

*******************************************************************************
#sliding_elbow
	.word	B_PUNCH,		J_ALL
	.word	J_TOWARD,		J_REAL_LR
	.word	J_TOWARD,		J_REAL_LR
	.word	8000h | 30		;max
	.long	#scrt_elbow

#scrt_elbow
	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#out

	move	*a13(PLYRMODE),a0
	cmpi	MODE_OPPOVERHEAD,a0
	jreq	#out

;Don't do it when he is on ground
	calla	get_opp_plyrmode
	cmpi	MODE_ONGROUND,a0
	jrz	#out
	cmpi	MODE_DEAD,a0
	jrz	#out

	;we can do this from a headhold, so...
	calla	FIND_AND_KILL_ENDLESS

 	movi	lex_sliding_elbow_anim,a0
	calla	change_anim1a

	clr	a0
	move	a0,*a13(ATTACH_PROC),L

	SETMODE	NORMAL

	WRSND	W_LUGER,UPRCUT_T1,UPRCUT_T2

	rets

	.if NUM_LEX_FINISHES
#******************************************************************************
 SUBRP	lex_finish_move1

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

	movi		lex_finish1_move,a0
	move		a0,*a8(SPECIAL_MOVE_ADDR),L
	DIE
	.endif
	

	.if NUM_LEX_FINISHES > 1
#******************************************************************************
 SUBRP	lex_finish_move2

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

	movi		lex_finish2_move,a0
	move		a0,*a8(SPECIAL_MOVE_ADDR),L
	DIE
	.endif


#*****************************************************************************
 SUBRP	lex_hdhold_pile

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

	movi	42,a10
	CREATE	MESSAGE_PID,BONUS_MESS

	;target WHOIHIT -- don't hit anyone else
	SMRTTGT	a8,WHOIHIT

	;immobilize WHOIHIT
	move	*a8(WHOIHIT),a0,L

#is_reversal
	movk	15,a14
	move	a14,*a0(IMMOBILIZE_TIME)

	CALLA	FIND_AND_KILL_ENDLESS

	movi	lex_vsuplex_anim,a0
	move	a0,*a8(SPECIAL_MOVE_ADDR),L
	WRSND	W_LUGER,FLYKICK_T1,FLYKICK_T2

	SLEEPK	20

	jruc	#lp

#*****************************************************************************
 SUBRP	lex_hdhold_elbow_face

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

	.ref	lex_grab2elbow_rev_anim

	movi	lex_grab2elbow_rev_anim,a1
	jruc	#is_reversal

#slam
	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

;fix !!! wrong name - jake
	movk	6,a10
	CREATE	MESSAGE_PID,BONUS_MESS

	;target WHOIHIT -- don't hit anyone else
	SMRTTGT	a8,WHOIHIT

	;immobilize WHOIHIT
	move	*a8(WHOIHIT),a0,L

;This stops Lex from going for foot, then changing his mind!
;	movk	15,a14
;	move	a14,*a8(IMMOBILIZE_TIME)

	movi	lex_grab2elbow_anim,a1
#is_reversal
	movk	15,a14
	move	a14,*a0(IMMOBILIZE_TIME)

	move	a1,*a8(SPECIAL_MOVE_ADDR),L
	CALLA	FIND_AND_KILL_ENDLESS

	WRSND	W_LUGER,FLYKICK_T1,FLYKICK_T2

	SLEEPK	20
	jruc	#lp

#******************************************************************************
lex_grab_toss_air

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
	cmpi	6ch,a0
	jrgt	#lp

;	FACE24	lex,hiptoss_anim
	movi	lex_hiptoss_anim,a0
	move	a0,*a8(SPECIAL_MOVE_ADDR),L

	WRSND	W_LUGER,GRABFLING_T1,PUNCH_T2

	SLEEPK	20
	jruc	#lp

#doit2
;	FACE24	lex,hiptoss2_anim
	movi	lex_hiptoss2_anim,a0
	move	a0,*a8(SPECIAL_MOVE_ADDR),L

	WRSND	W_LUGER,GRABFLING_T1,PUNCH_T2

	SLEEPK	20

	jruc	#lp

#*****************************************************************************
lex_hdhold_graboh

#TIMEOUT	.equ	60

#lp0
	SLEEPK	1
#lp
	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrz	#cont0
	cmpi	MODE_HEADHELD,a0
	jrnz	#lp0
#cont0
	clr	a11

	WAITSWITCH_DWN	J_DOWN,0,#lp

	movi	#TIMEOUT,a11

;	WAITSWITCH_DWN	J_DOWN_TOWARD,0,#lp
	WAITSWITCH_DWN	J_TOWARD,J_DOWN|J_UP,#lp
	WAITSWITCH_DWN	B_KICK,J_ALL,#lp

	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrz	#dograb
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

#dograb
	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

;	movk	6,a10
;	CREATE	MESSAGE_PID,BONUS_MESS

	;target WHOIHIT -- don't hit anyone else
	SMRTTGT	a8,WHOIHIT

	;immobilize WHOIHIT
	move	*a8(WHOIHIT),a0,L

#is_reversal
	movk	15,a14
	move	a14,*a0(IMMOBILIZE_TIME)

	CALLA	FIND_AND_KILL_ENDLESS

	movi	lex_4_graboh_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	WRSND	W_LUGER,GRABHOLD_T1,GRABHOLD_T2

	SLEEPK	20

	jruc	#lp

*******************************************************************************
#*
lex_hdhold_combo1

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
	movi	lex_combo_punch_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	WRSND	W_LUGER,UPRCUT_T1,UPRCUT_T2

	SLEEPK	20

	jruc	#lp

*******************************************************************************
#*
lex_hdhold_combo2

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
	movi	lex_combo_kick_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	WRSND	W_LUGER,UPRCUT_T1,UPRCUT_T2

	SLEEPK	20

	jruc	#lp

;#******************************************************************************
;
;;Could start this process only when opponent is in combo mode!
;
;lex_hdhold_anti_combo
;
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
;
;	WRSND	W_LUGER,GRABHOLD_T1,GRABHOLD_T2
;	movi	lex_vsuplex_anim,a14
;	move	a14,*a8(SPECIAL_MOVE_ADDR),L
;
;	SLEEPK	20
;
;	jruc	#lp
;
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
	CREATE	TAUNT_PID,do_taunt
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
	.long	mode_puppet2		;17
	.long	mode_normal		;18
	.long	mode_headheld		;19
	.long	mode_puppet		;20
	.long	mode_inair2		;21
	.long	mode_normal		;22
	.long	mode_normal		;23
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
	movi	lex_fall_back_anim,a0
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
	FACE24	lex,pin_anim
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
	FACE24	lex,raise_arm_anim
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
* normal	<  40  45	headbutt
* normal	>		normal punch
*
* onground	< 120 120	elbow drop
* onground	>		normal punch
*
* running |
* bouncing			normal punch
*
* onturnbkl	<  40  45	hdbutt
* onturnbkl	>		normal punch
*
* climbturnbkl			punch
*

	JJXM_INIT
	JJXM	NORMAL,		 40, 45,#punch_hdbutt,#punch_punch	;0
	JJXM	RUNNING,	 40, 45,#punch_hdbutt,#punch_punch	;1
	JJXM	INAIR,		 40, 45,#punch_hdbutt,#punch_punch	;2
	JJXM	ATTACHED,	 40, 45,#punch_hdbutt,#punch_punch	;3
	JJXM	ONGROUND,	160,140,#punch_lbowdrop,#punch_punch	;4
	JJXM	BOUNCING,	 40, 45,#punch_hdbutt,#punch_punch	;1
	JJXM	ONTURNBKL,	 40, 45,#punch_hdbutt,#punch_punch	;6
	JJXM	BLOCK,		 40, 45,#punch_hdbutt,#punch_punch	;7
	JJXM	DIZZY,		 40, 45,#punch_hdbutt,#punch_punch	;8
	JJXM	DEAD,		160,140,#punch_lbowdrop,#punch_punch	;9
	JJXM	OPPOVERHEAD,	 40, 45,#punch_hdbutt,#punch_punch	;10
	JJXM	CLIMBTURNBKL,		#punch_punch			;11
	JJXM	WAITANIM,	 40, 45,#punch_hdbutt,#punch_punch	;12
	JJXM	GRAPPLE,	 40, 45,#punch_hdbutt,#punch_punch	;13
	JJXM	MASTER,		 40, 45,#punch_hdbutt,#punch_punch	;14
	JJXM	SLAVE, 		 40, 45,#punch_hdbutt,#punch_punch	;15
	JJXM	HEADHOLD,	 40, 45,#punch_hdbutt,#punch_punch	;16
	JJXM	HEADHELD,	 40, 45,#punch_hdbutt,#punch_punch	;19
	JJXM	CHOKEHOLD,	 40, 45,#punch_hdbutt,#punch_punch	;16
	JJXM	PUPPET,		 40, 45,#punch_hdbutt,#punch_punch	;20
	JJXM	PUPPET2,	 40, 45,#punch_hdbutt,#punch_punch	;20
	JJXM	INAIR2,		 40, 45,#punch_hdbutt,#punch_punch	;21
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
#punch_lbowdrop
	FACE24	lex,ground_punch_anim
	calla	change_anim1a
	WRSND	W_LUGER,LBOWDROP_T1,LBOWDROP_T2
	rets


************
#block		;2
std_block
	move	@blocking_off,a0
	jrnz	#no_blocking

	RND_AWARD	a13,BLOCKS_AWD

	movi	lex_4_block_anim,a0
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
* normal	< 110   75	close in super move
* dizzy			"		"
* normal	>		jumping punch move
* dizzy			"		"
*
* onground	< 136  112	super elbow drop
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
	JJXM	NORMAL,		 70, 45,#spunch_special,#spunch_slap	;0
	JJXM	RUNNING,	 40, 45,#spunch_special,#spunch_slap	;1
	JJXM	INAIR,		 40, 45,#spunch_special,#spunch_slap	;2
	JJXM	ATTACHED,	 40, 45,#spunch_special,#spunch_slap	;3
	JJXM	ONGROUND,	160,140,#spunch_lbowdrop,std_punch	;4
	JJXM	BOUNCING,	110, 45,#spunch_special,#spunch_slap	;5
	JJXM	ONTURNBKL,	 	#spunch_slap			;6
	JJXM	BLOCK,		 70, 45,#spunch_special,#spunch_slap	;7
	JJXM	DIZZY,		 40, 45,#spunch_special,#spunch_slap	;8
	JJXM	DEAD,		160,140,#spunch_lbowdrop,std_punch	;9
	JJXM	OPPOVERHEAD,	110, 35,#spunch_special,#spunch_slap	;10
	JJXM	CLIMBTURNBKL,		std_punch			;11
	JJXM	WAITANIM,	 40, 45,#spunch_special,#spunch_slap	;12
	JJXM	GRAPPLE,	 40, 45,#spunch_special,#spunch_slap	;13
	JJXM	MASTER,		 40, 45,#spunch_special,#spunch_slap	;14
	JJXM	SLAVE, 		 40, 45,#spunch_special,#spunch_slap	;15
	JJXM	HEADHOLD,	 40, 45,#spunch_special,#spunch_slap	;16
	JJXM	HEADHELD,	 40, 45,#spunch_special,#spunch_slap	;19
	JJXM	CHOKEHOLD,	 40, 45,#spunch_special,#spunch_slap	;16
	JJXM	PUPPET,		 40, 45,#spunch_special,#spunch_slap	;20
	JJXM	PUPPET2,	 40, 45,#spunch_special,#spunch_slap	;20
	JJXM	INAIR2,		 40, 45,#spunch_special,#spunch_slap	;21
	JJXM_END

#spunch_rets
	rets

*****
#spunch_slap
	movi	lex_3_clobber_anim,a0
	calla	change_anim1a

	WRSND	W_LUGER,PUNCH_T1,PUNCH_T2
	rets

*****
#spunch_special
;	move	*a13(CLOSEST_XDIST),a1
;	cmpi	65,a1
;	jrgt	#spunch_slap

	move	*a13(CLOSEST_XDIST),a1
	cmpi	55,a1
	jrgt	std_punch

	.ref	lex_2_butts_anim
	.ref	lex_4_butts_anim

	FACE24	lex,butts_anim
	calla	change_anim1

	WRSND	W_LUGER,HDBUTT_T1,HDBUTT_T2

	rets

*****
#spunch_lbowdrop

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

	FACE24	lex,hair_pickup_anim
	calla	change_anim1
	WRSND	W_LUGER,LBOWDROP_T1,LBOWDROP_T2
	rets

#no
	FACE24	lex,ground_punch_anim
	calla	change_anim1
	WRSND	W_LUGER,LBOWDROP_T1,LBOWDROP_T2
	rets


************
#kick		;8
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
	JJXM	ONGROUND,	160,140,#kick_stomp,#kick_kick
	JJXM	RUNNING, 	 60, 50,#kick_knee,#kick_kick
	JJXM	BOUNCING, 	 60, 50,#kick_knee,#kick_kick
	JJXM	ONTURNBKL,	 	#kick_kick
	JJXM	CLIMBTURNBKL,	 	#kick_kick
	JJXM	INAIR,		 60, 50,#kick_knee,#kick_kick
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
	JJXM	PUPPET,		 60, 50,#kick_knee,#kick_kick
	JJXM	PUPPET2,	 60, 50,#kick_knee,#kick_kick
	JJXM	INAIR2,		 	#kick_TB
	JJXM_END

*****
#kick_TB

	.ref	lex_kick_TB_anim
	movi	lex_kick_TB_anim,a0
	calla	change_anim1a

	WRSND	W_LUGER,KICK_T1,KICK_T2
	rets
*****
#kick_kick
std_kick

	FACE24	lex,kick_anim
	calla	change_anim1a

	WRSND	W_LUGER,KICK_T1,KICK_T2
	rets

*****
#kick_knee
std_knee

	movi	lex_4_knee_anim,a0
	calla	change_anim1a

	WRSND	W_LUGER,KICK_T1,KICK_T2
	rets

*****
#kick_stomp
std_stomp

	FACE24	lex,stomp_anim
	calla	change_anim1a

	WRSND	W_LUGER,KICK_T1,KICK_T2

	rets

;*****
;#kick_bigboot
;
;	FACE24	lex,kick_anim
;	calla	change_anim1a
;
;	WRSND	W_LUGER,KICK_T1,KICK_T2
;	rets


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
	JJXM	ONGROUND,	160,140,std_stomp,std_kick		;4
	JJXM	BOUNCING,	 	#skick_bigboot			;5
	JJXM	ONTURNBKL,	 60, 96,#skick_kick,std_kick		;6
	JJXM	BLOCK,		 60, 60,#skick_special,#skick_kick	;7
	JJXM	DIZZY,		 60, 60,#skick_special,#skick_kick	;8
	JJXM	DEAD,		160,140,std_stomp,std_kick		;9
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
	movi	lex_super_kick_anim,a0
	calla	change_anim1a

	WRSND	W_LUGER,FLYKICK_T1,FLYKICK_T2
	rets


*****
#skick_special
	move	*a13(STICK_VAL_CUR),a0
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrz	#cont2

	movi	lex_4_knee_anim,a0
	calla	change_anim1a

	WRSND	W_LUGER,KICK_T1,KICK_T2

	rets

#cont2
	movi	lex_4_knee_fall_anim,a0
	calla	change_anim1

	WRSND	W_LUGER,GRABHOLD_T1,GRABHOLD_T2
	rets

*****
#skick_bigboot	;we can probably get away with just a #4 big boot

	movi	lex_4_bigboot_anim,a0		;*****
	calla	change_anim1a

	WRSND	W_LUGER,FLYKICK_T1,FLYKICK_T2

	rets

************
#graboh		;20

	movi	lex_4_graboh_anim,a0
	calla	change_anim1a

	WRSND	W_LUGER,GRABHOLD_T1,GRABHOLD_T2

	rets


#*****************************************************************************
*
* RUNNING (if GETUP_TIME > 0 then player is out of control)
*

#XRUN_VAL	equ	LEX_XRUN
#ZDRIFT_VAL	equ	LEX_ZDRIFT

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
	JJXM	ONGROUND,	176,176,#punch_bellyflop,#punch_rets
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
;TODO - fix this
	;HACK!!!
	jruc	#kick_flyingkick

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
	JJXM	DEAD,		176,176,attack_bellyflop,#kick_rets
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

	SETMODE	INAIR

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

;	;check unint
;	move	*a13(ANIMODE),a14
;	btst	MODE_UNINT_BIT,a14
;	jrnz	#no_interrupt

	move	*a13(STICK_VAL_CUR),a0
	btst	PLAYER_DOWN_BIT,a0
	jrz	#no_climbdown

	movi	lex_climb_down_anim,a0
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
#block
	rets

************
#punch		;1
#super_punch	;4
#punchkick	;5
#kick		;8
#super_kick	;16
#graboh		;20

	SETMODE	INAIR

	movi	lex_buckle_leap_anim,a0
	calla	change_anim1a

	WRSND	W_LUGER,FLYKICK_T1,FLYKICK_T2
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

	movi	lex_4_push_anim,a0
	calla	change_anim1a

	WRSND	W_LUGER,PUSH_T1,PUSH_T2

	rets


#*****************************************************************************
* doink with zero health

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

	CALLA	FIND_AND_KILL_ENDLESS
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

	move	*a13(STICK_VAL_CUR),a0
	jrz	#stand

	move	a0,*a13(MOVE_DIR)
	calla	execute_walk

	.ref	lex_holdoh_anim
	movi	lex_holdoh_anim,a0
	.ref	change_anim2
	calla	change_anim2
 	jruc	#ck_butns
#stand
	clr	a0
	move	a0,*a13(MOVE_DIR)
	move	a0,*a13(OBJ_XVEL),L
	move	a0,*a13(OBJ_ZVEL),L

	.ref	lex_stndholdoh_anim
	movi	lex_stndholdoh_anim,a0
	calla	change_anim1

#ck_butns

	move	*a13(BUT_VAL_DOWN),a0
	andi	011111b,a0
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

;three moves from headhold: backbreaker, slamdown, and ohslam.

************
#z
	rets

************
#punch		;1
#punchkick
#block		;2
#kick		;8

;	move	*a13(STICK_VAL_CUR),a0
;	btst	PLAYER_DOWN_BIT,a0
;	jrz	#z

	CALLA	FIND_AND_KILL_ENDLESS
	movi	lex_ohslam_anim,a0
	calla	change_anim1a

	WRSND	W_LUGER,PUNCH_T1,PUNCH_T2

	rets

************
#super_punch	;4
#graboh

	move	*a13(STICK_VAL_CUR),a0
	btst	PLAYER_UP_BIT,a0
	jrz	#punch

	CALLA	FIND_AND_KILL_ENDLESS
	movi	lex_slamdown_anim,a0
	calla	change_anim1a

	WRSND	W_LUGER,PUNCH_T1,PUNCH_T2

	rets

************
#super_kick	;16

	move	*a13(STICK_VAL_CUR),a0
	btst	PLAYER_UP_BIT,a0
	jrz	#punch

	CALLA	FIND_AND_KILL_ENDLESS
	movi	lex_backbreaker_anim,a0
	calla	change_anim1a

	WRSND	W_LUGER,HIPTOSS_T1,PUNCH_T2

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

	WRSND	W_LUGER,FLYKICK_T1,FLYKICK_T2

	movi	lex_vsuplex_anim,a0
	move	@PCNT,a14
	btst	0,a14
	jrz	#tag
	movi	lex_4_graboh_anim,a0
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
	move	*a13(STICK_VAL_CUR),a0
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrnz	#tag2
;TODO - change this to uppercuts_to_head_anim!
	WRSND	W_LUGER,KICK_T1,KICK_T2

	.ref	lex_4_knee2_anim
	movi	lex_4_knee2_anim,a0
	calla	change_anim1a
	rets

#tag2
;TODO - change this to an uppercut
	WRSND	W_LUGER,KICK_T1,KICK_T2
	movi	lex_4_knee2_anim,a0
	calla	change_anim1a
	rets

************
#super_punch	;4
	rets

#punchkick
#kick
	CALLA	FIND_AND_KILL_ENDLESS
	movi	lex_3_knee_to_head_anim,a0
	calla	change_anim1a
	WRSND	W_LUGER,KICK_T1,KICK_T2
	rets

#super_kick	;16
;If stick is toward opponent, then do quick knees
	move	*a13(STICK_VAL_CUR),a0
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrnz	#kick

;Quick knees
	CALLA	FIND_AND_KILL_ENDLESS
	movi	lex_knees_to_head_anim,a0
	calla	change_anim1a
	WRSND	W_LUGER,KICK_T1,KICK_T2
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

	WRSND	W_LUGER,FLYKICK_T1,FLYKICK_T2

	movi	lex_vsuplex_anim,a0
	move	@PCNT,a14
	btst	0,a14
	jrz	#tag
;	movi	lex_4_graboh_anim,a0
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

	movi	lex_3_head_held_stand_anim,a0
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