**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		9/3/93
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"doink.asm"
	.title	"doink specific game code"
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

	;temp! - 314
	.include	"tmpdebug.h"


******************************************************************************
* EXTERNAL REFERENCES


	.ref	BLOCK_WOOSH,get_opp_process,calc_line_x,can_pin
	.ref	PSTATUS,is_final_match,FINAL_PTR
	.ref	DO_REVERSAL,DO_REVERSAL_MESS,FIND_AND_KILL_ENDLESS
	.ref	ADD_IF_SILENT,JUMP_ROPES,CLIMB_ROPES
	.ref	get_powerk_dtime

	.ref	set_getup_time,set_raisearm_bit
	.ref	get_punch_dtime
	.ref	get_rope_x,ck_teammate_pin,raisearm_check
	.ref	inc_getup_time

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
	.ref	ADD_VOICE,round_award
	.ref	HALT,clear_combo_meter
	.ref	mode_choking
	.ref	master_keep_attached
	.ref	PCNT,init_reduce_bog
	.ref	RNDPER,is_8_on_1
	.ref	current_round,change_wrestler
	.ref	p1rounds,p2rounds,hitonground_tbl,arw_bwait

	;from DCSSOUND.ASM
	.ref	triple_sound

	;from WRESTLE.ASM
	.ref	drone_change_back
	.ref	read_switches
	.ref	BONUS_MESS
	.ref	blocking_off
	.ref	hyper_speed_on
	.ref	in_finish_move,royal_rumble
	.ref	p1rounds,p2rounds
	.if NUM_DOINK_FINISHES
	.ref	dnk_finish1_move
	.if NUM_DOINK_FINISHES > 1
	.ref	dnk_finish2_move
	.endif
	.endif
	.ref	in_finish_move,finish_completed

;animation sequence

	.ref	dnk_3_pile_driver_anim
	.ref	start_run_anim

	.ref	dnk_4_earslap_anim
	.ref	dnk_2_earslap_anim
	.ref	dnk_4_slap_anim
	.ref	dnk_2_slap_anim
;	.ref	dnk_4_slap2_anim
;	.ref	dnk_2_slap2_anim
	.ref	dnk_head_hit_dizzy_anim
	.ref	dnk_knockdwn_anim
	.ref	dnk_4_hammer_anim

	.ref	wres_slave_anim
	.ref	dnk_zip_anim

	.ref	dnk_2_raise_arm_anim,dnk_4_raise_arm_anim
	.ref	dnk_stand2_anim,dnk_stand8_anim
	.ref	dnk_stand4_anim,dnk_stand6_anim
	.ref	dnk_torso2_anim,dnk_torso8_anim
	.ref	dnk_torso4_anim,dnk_torso6_anim

	.ref	dnk_2_to_4_turn_anim,dnk_8_to_6_turn_anim	;stand
	.ref	dnk_4_to_2_turn_anim,dnk_6_to_8_turn_anim
	.ref	dnk_4_to_6_turn_anim,dnk_6_to_4_turn_anim
	.ref	dnk_2_to_8_turn_anim,dnk_8_to_2_turn_anim
	.ref	dnk_4_to_8_turn_anim,dnk_6_to_2_turn_anim
	.ref	dnk_2_to_6_turn_anim,dnk_8_to_4_turn_anim

	.ref	dnk_2_to_4_turn2_anim,dnk_8_to_6_turn2_anim	;torso
	.ref	dnk_4_to_2_turn2_anim,dnk_6_to_8_turn2_anim
	.ref	dnk_4_to_6_turn2_anim,dnk_6_to_4_turn2_anim
	.ref	dnk_2_to_8_turn2_anim,dnk_8_to_2_turn2_anim
	.ref	dnk_4_to_8_turn2_anim,dnk_6_to_2_turn2_anim
	.ref	dnk_2_to_6_turn2_anim,dnk_8_to_4_turn2_anim

	.ref	dnk_walk1_f2_anim,dnk_walk2_f2_anim,dnk_walk4_f2_anim
	.ref	dnk_walk5_f2_anim,dnk_walk6_f2_anim,dnk_walk8_f2_anim

	.ref	dnk_walk1_f4_anim,dnk_walk2_f4_anim,dnk_walk4_f4_anim
	.ref	dnk_walk5_f4_anim,dnk_walk6_f4_anim,dnk_walk8_f4_anim

	.ref	dnk_2_punch_anim,dnk_4_punch_anim
	.ref	dnk_2_buzz_anim,dnk_4_buzz_anim
	.ref	dnk_2_buzz2_anim,dnk_4_buzz2_anim
	.ref	dnk_2_butt_anim,dnk_4_butt_anim
	.REF	dnk_combo_uppercut_to_head_anim
	.ref	dnk_4_combo_kick_anim
	.REF	CHECK_COMBO_GO

	.ref	dnk_2_kick_anim,dnk_4_kick_anim
	.ref	dnk_2_spin_kick_anim,dnk_4_spin_kick_anim
	.ref	dnk_2_knee_anim,dnk_4_knee_anim

	.ref	dnk_2_box_anim,dnk_4_box_anim

	.ref	dnk_run_anim,dnk_run2_anim

	.ref	dnk_4_blbowdrop_anim

	.ref	dnk_2_hair_pickup_anim,dnk_4_hair_pickup_anim

 	.ref	dnk_2_lbowdrop_anim,dnk_4_lbowdrop_anim
	.ref	dnk_2_grabfling_anim
	.ref	dnk_4_grabfling_anim

	.ref	dnk_heldoh_anim

	.ref	dnk_diveofftb_anim

	.ref	dnk_fly_cline_anim
	.ref	dnk_flying_kick_anim

	.ref	dnk_4_head_hit_anim,dnk_head_hit3_anim
	.ref	dnk_2_head_hit_anim,dnk_head_hit2_anim
	.ref	dnk_fall_back_anim
	.ref	dnk_4_losebal_dizzy_anim

	.ref	dnk_hitonground_anim
	.ref	dnk_4_stomp_anim,dnk_2_stomp_anim
	.ref	dnk_4_bstomp_anim

	.ref	dnk_climb_up_anim,dnk_climb_down_anim
	.ref	dnk_4_block_anim
	.ref	dnk_2_hiptoss_anim,dnk_4_hiptoss_anim
	.ref	dnk_2_hiptoss2_anim,dnk_4_hiptoss2_anim
	.ref	dnk_4_push_anim
	.ref	dnk_4_bigboot_anim,dnk_2_bigboot_anim
	.ref	dnk_4_losebal_anim
	.ref	dnk_dizzy_anim
	.ref	dnk_2_pin_anim
	.ref	dnk_4_pin_anim

	.ref	dnk_belly_anim
	.ref	ck_ignore  		;Ignore button press?

;	.ref 	dnk_pkup_chair_anim

	.ref	dnk_3_knee_to_head_anim
	.ref	dnk_3_knees_to_head_anim
	.ref	dnk_uppercut_to_head_anim
	.ref	dnk_uppercuts_to_head_anim
	.ref	dnk_get_buzz_anim

	.ref	dnk_3_head_hold2_anim
	.ref	dnk_3_head_hold_anim

	.ref	dnk_2_butts_anim,dnk_4_butts_anim
	.ref	dnk_3_head_held_stand_anim
	.ref	dnk_3_head_slam_anim
	.ref	dnk_4_knee_fall_anim

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************

doink_secret_moves

;These secret moves are triggered only after a move list seq has ended!  You
;can't hold on the last button press and have it trigger!

;Button held down moves need to be first entry
	.long	#charge_buzz
	.long	#grab_fling
	.long	#hip_toss
	.long	#grab_fling2
	.long	#hip_toss2
	.long	#earslap
	.long	#hammer
	.long	#neck_grab
	.long	#boxing_pnch
;	.long	#charge_flying_kick
	.long	0


******************************************************************************
*
* SPECIAL MOVE PROCESSES - Secret moves
*
;a8=process of wrestler

 SUBR	dnk_smove_table
	.long	dnk_charge_flykick
	.long	dnk_hdhold_slam
	.long	dnk_hdhold_combo1
	.long	dnk_hdhold_pile
	.long	dnk_hdhold_combo2
	.long	dnk_hdhold_buzz
;	.long	dnk_hdhold_anti_combo
	.long	dnk_grab_toss_air
	.long	std_walk_fast
	.long	std_taunt
	.if NUM_DOINK_FINISHES
	.long	dnk_finish_move1
	.endif
	.if NUM_DOINK_FINISHES > 1
	.long	dnk_finish_move2
	.endif
	.long	0


*******************************************************************************
#charge_buzz
	move	*a13(BUT_VAL_UP),a0
	btst	PLAYER_PUNCH_BIT,a0
	jrz	#no_punch

;FIX!!  Give some jumping velocity

;	move	*a13(PLYRMODE),a0
;	cmpi	MODE_ONTURNBKL,a0
;	jrz	#no_punch

	move	*a13(PLYRNUM),a0
	calla	get_punch_dtime
	cmpi	100,a0			;> min?
	jrlt	#no_punch

	callr	#scrt_buzz
	setc
	rets

#no_punch
	clrc
	rets


#scrt_buzz

	move	*a13(PLYRMODE),a0
	cmpi	MODE_HEADHELD,a0
	jrz	#out
	cmpi	MODE_HEADHOLD,a0
	jrz	#out

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#out

;Don't do it when he is on ground
	calla	get_opp_plyrmode
;	cmpi	MODE_ONGROUND,a0
;	jrz	#out
	cmpi	MODE_DEAD,a0
	jrz	#out

	move	*a13(PLYRMODE),a0
	cmpi	MODE_RUNNING,a0
	jrz	#leapbuzz

;If stick is toward opponent, then do sliding/leaping buzzer
	move	*a13(STICK_VAL_CUR),a0
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrnz	#norm

#leapbuzz
;missing noise for a reason !
	WRSND	W_DOINK,HDBUTT_T1
	FACE24	dnk,buzz2_anim
	calla	change_anim1a
	rets
#norm
;missing noise for a reason !
	WRSND	W_DOINK,HDBUTT_T1
	FACE24	dnk,buzz_anim
	calla	change_anim1a
	rets

*******************************************************************************
;		BITS			MASK
#boxing_pnch
	.word	B_PUNCH,		J_ALL
	.word	B_PUNCH,		J_ALL
	.word	B_PUNCH,		J_ALL
	.word	B_PUNCH,		J_ALL
	.word	B_PUNCH,		J_ALL
	.word	B_PUNCH,		J_ALL
	.word	B_PUNCH,		J_ALL
	.word	8000h | 60		;max
	.long	scrt_glove

scrt_glove
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

	MOVE	*A13(COMBO_COUNT),A0
	JRNZ	#out

	FACE24	dnk,box_anim
	calla	change_anim1a
	WRSND	W_DOINK,SPUNCH_T1,SPUNCH_T2

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

	movi	dnk_4_hammer_anim,a0
	calla	change_anim1a

;missing noise for a reason !
	WRSND	W_DOINK,HDBUTT_T2

	rets

*******************************************************************************

#earslap
	.word	B_PUNCH,		J_ALL
	.word	J_TOWARD,		J_REAL_LR
	.word	J_DOWN_TOWARD,		J_REAL_LR
	.word	J_DOWN,			J_REAL_LR
	.word	8000h | 50 		;max
	.long	#scrt_earslap

#scrt_earslap
	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#out

	move	*a13(PLYRMODE),a0
	cmpi	MODE_ONTURNBKL,a0
	jrz	#out

;Don't do it when he is dead or held
	calla	get_opp_plyrmode
;	cmpi	MODE_ONGROUND,a0
;	jrz	#out
	cmpi	MODE_DEAD,a0
	jrz	#out
	cmpi	MODE_HEADHELD,a0
	jrz	#out

	movi	dnk_4_earslap_anim,a0
	calla	change_anim1a

	WRSND	W_DOINK,FLYKICK_T1,FLYKICK_T2

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
	jrge	#ok2

;This head grab is too close (in terms of time) to most recent grab
	.ref	dnk_3_fake_hold_anim
	movi	dnk_3_fake_hold_anim,a0
	calla	change_anim1a
	rets

#ok2
	WRSND	W_DOINK,GRABFLING_T1,PUNCH_T2

	move	*a13(CLOSEST_XDIST),a1
	cmpi	90,a1
	jrgt	#std_grab

	movi	dnk_3_head_hold2_anim,a0
	calla	change_anim1a
	rets

#std_grab
	movi	dnk_3_head_hold_anim,a0
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
	cmpi	MODE_HEADHELD,a0
	jrz	#ck2
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
	FACE24	dnk,hiptoss_anim
	calla	change_anim1a

	WRSND	W_DOINK,HIPTOSS_T1,PUNCH_T2
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
;	FACE24	dnk,slap_anim
;	calla	change_anim1a
;
;	WRSND	W_DOINK,SPUNCH_T1,SPUNCH_T2
;	rets
;
;#ok2a
;	move	@PCNT,a14,L			;use 32-bit PCNT!
;	move	a14,*a13(LAST_FLING_ATTEMPT),L

	FACE24	dnk,grabfling_anim
	calla	change_anim1a

	WRSND	W_DOINK,GRABFLING_T1,PUNCH_T2
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
	jrz	#ck2
	cmpi	MODE_INAIR,a0
	jrz	#doit
	cmpi	MODE_INAIR2,a0
	jrz	#doit

	move	*a13(CLOSEST_DIST),a0
	cmpi	70h,a0
	jrgt	#out

#doit
	FACE24	dnk,hiptoss_anim
	calla	change_anim1a

	WRSND	W_DOINK,HIPTOSS_T1,PUNCH_T2

#out	rets

#ck2
	move	*a13(USR_VAR2),a0
	jrnz	#doit
	rets	

	.if NUM_DOINK_FINISHES
#******************************************************************************
 SUBRP	dnk_finish_move1

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

	movi		dnk_finish1_move,a0
	move		a0,*a8(SPECIAL_MOVE_ADDR),L
	DIE
	.endif
	

	.if NUM_DOINK_FINISHES > 1
#******************************************************************************
 SUBRP	dnk_finish_move2

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

	movi		dnk_finish2_move,a0
	move		a0,*a8(SPECIAL_MOVE_ADDR),L
	DIE
	.endif


#*******************************************************************************
dnk_hdhold_slam

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
#contz
	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrz	#slam
	cmpi	MODE_HEADHELD,a0
	jrnz	#lp0
	move	*a8(I_WILL_DIE),A14
	jrnz	#lp0

;Do reversal unless I have been immobilized!
;If not, set immobilize time for opponent and reverse

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
	WRSND	W_DOINK,FLYKICK_T1,FLYKICK_T2

	movi	dnk_3_head_slam_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEPK	20

	jruc	#lp

#*****************************************************************************
dnk_hdhold_pile

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

	movk	7,A10			;Pile driver
	CREATE	MESSAGE_PID,BONUS_MESS

	;target WHOIHIT -- don't hit anyone else
	SMRTTGT	a8,WHOIHIT

	;immobilize WHOIHIT
	move	*a8(WHOIHIT),a0,L

#is_reversal
	movk	15,a14
	move	a14,*a0(IMMOBILIZE_TIME)

	CALLA	FIND_AND_KILL_ENDLESS
	WRSND	W_DOINK,FLYKICK_T1,FLYKICK_T2
	movi	dnk_3_pile_driver_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEPK	20

	jruc	#lp

;#******************************************************************************
;
;;Could start this process only when opponent is in combo mode!
;
;dnk_hdhold_anti_combo
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
;	WRSND	W_DOINK,FLYKICK_T1,FLYKICK_T2
;	movi	dnk_3_pile_driver_anim,a14
;	move	a14,*a8(SPECIAL_MOVE_ADDR),L
;
;	SLEEPK	20
;
;	jruc	#lp
;
*******************************************************************************

#*
dnk_hdhold_combo1

#TIMEOUT	.equ	60

#lp0
	SLEEPK	1
#lp
	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrnz	#lp0
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
	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

;Start combo rules here
;	move	*a8(ATTACH_PROC),a14,L
;	movk	15,a0
;	move	a0,*a14(IMMOBILIZE_TIME)

	;target WHOIHIT
	SMRTTGT	a8,WHOIHIT

	CALLA	FIND_AND_KILL_ENDLESS

	movi	dnk_combo_uppercut_to_head_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEPK	20

	jruc	#lp

*******************************************************************************

#*
dnk_hdhold_combo2

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
	CALLA	FIND_AND_KILL_ENDLESS

	;target WHOIHIT
	SMRTTGT	a8,WHOIHIT

	movi	dnk_4_combo_kick_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEPK	20

	jruc	#lp

*******************************************************************************
#*

dnk_grab_toss_air

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

	FACE24	dnk,hiptoss_anim
	move	a0,*a8(SPECIAL_MOVE_ADDR),L

	WRSND	W_DOINK,GRABFLING_T1,PUNCH_T2

	SLEEPK	20
	jruc	#lp

#doit2	FACE24	dnk,hiptoss2_anim
	move	a0,*a8(SPECIAL_MOVE_ADDR),L

	WRSND	W_DOINK,GRABFLING_T1,PUNCH_T2

	SLEEPK	20

	jruc	#lp


*******************************************************************************
#*
 SUBR	std_walk_fast
;One time per match

#TIMEOUT	.equ	61

#lp0
	SLEEPK	1
#lp
	move	*a8(WALK_FAST),a0
	jrnz	#lp0
	move	*a8(PLYRMODE),a0
	cmpi	MODE_NORMAL,a0
	jrnz	#lp0

	clr	a11

	WAITSWITCH_DWN	J_AWAY,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_DOWN_AWAY,0,#lp
	WAITSWITCH_DWN	J_DOWN,0,#lp
	WAITSWITCH_DWN	J_DOWN_TOWARD,0,#lp
	WAITSWITCH_DWN	J_TOWARD,0,#lp
	WAITSWITCH_DWN	J_UP_TOWARD,0,#lp
	WAITSWITCH_DWN	J_UP,0,#lp
	WAITSWITCH_DWN	J_UP_AWAY,0,#lp


	move	*a8(PLYRMODE),a0
	cmpi	MODE_NORMAL,a0
	jrnz	#lp0

	movi	15*60,a0
	move	a0,*a8(WALK_FAST)

	move	*a8(WRESTLERNUM),a0
	subk	6,a0
	jrnz	#not_dnk
;Doink
	movi	30000h,a0
	move	a0,*a8(OBJ_YVEL),L

;Doink speech call
;211h
	movi	211h,a0
	jruc	#go

#not_dnk
	movi	17eh,a0
#go	calla	ADD_VOICE
;	calla	IF_SILENT_ADD_VOICE

	movi	0101h,a14
	move	a14,*a8(OBJ_CONST)
	move	*a8(OBJ_CONTROL),a14
	andni	01111b,a14
	ori	M_CONNON,a14
	move	a14,*a8(OBJ_CONTROL)

	SLEEPK	3
 
	move	*a8(OBJ_CONTROL),a14
	andni	01111b,a14
	ori	DMAWNZ,a14
	move	a14,*a8(OBJ_CONTROL)

	SLEEPK	3

	movi	0101h,a14
	move	a14,*a8(OBJ_CONST)
	move	*a8(OBJ_CONTROL),a14
	andni	01111b,a14
	ori	M_CONNON,a14
	move	a14,*a8(OBJ_CONTROL)

	SLEEPK	3

	move	*a8(OBJ_CONTROL),a14
	andni	01111b,a14
	ori	DMAWNZ,a14
	move	a14,*a8(OBJ_CONTROL)

	SLEEP	30

	move	*a8(WRESTLERNUM),a0
	subk	6,a0
	jrnz	#tag

	movi	0b2h,a0			;Honk
	calla	triple_sound

	SLEEPK	18

	movi	0b2h,a0			;Honk
	calla	triple_sound

	SLEEPK	18

	movi	0b2h,a0			;Honk
	calla	triple_sound

#tag	SLEEPK	5
	move	*a8(WALK_FAST),a0
	jrnz	#tag

	movi	0101h,a14
	move	a14,*a8(OBJ_CONST)
	move	*a8(OBJ_CONTROL),a14
	andni	01111b,a14
	ori	M_CONNON,a14
	move	a14,*a8(OBJ_CONTROL)

	SLEEPK	3

	move	*a8(OBJ_CONTROL),a14
	andni	01111b,a14
	ori	DMAWNZ,a14
	move	a14,*a8(OBJ_CONTROL)

	DIE

*******************************************************************************
#*
 SUBR	std_taunt

	move	*a8(PLYR_TYPE),a14
	janz	SUCIDE

#TIMEOUT	.equ	61

#lp0
	SLEEPK	1
#lp
	move	*a8(PLYRMODE),a0
	cmpi	MODE_BLOCK,a0
	jrnz	#lp0

	clr	a11

	WAITSWITCH_DWN	J_UP,B_BLOCK,#lp

	move	*a8(BUT_VAL_CUR),a14
	btst	PLAYER_BLOCK_BIT,a14
	jrz	#lp0

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_UP_TOWARD,B_BLOCK,#lp
	WAITSWITCH_DWN	J_TOWARD,B_BLOCK,#lp
	WAITSWITCH_DWN	J_DOWN_TOWARD,B_BLOCK,#lp
	WAITSWITCH_DWN	J_DOWN,B_BLOCK,#lp
	WAITSWITCH_DWN	J_DOWN_AWAY,B_BLOCK,#lp
	WAITSWITCH_DWN	J_AWAY,B_BLOCK,#lp
	WAITSWITCH_DWN	J_UP_AWAY,B_BLOCK,#lp

	move	*a8(BUT_VAL_CUR),a14
	btst	PLAYER_BLOCK_BIT,a14
	jrz	#lp0

	move	*a8(PLYRMODE),a0
	cmpi	MODE_BLOCK,a0
	jrne	#lp0

	;no taunts if all opponents are dead.
	SWAP	a8,a13
	calla	get_opp_plyrmode
	SWAP	a8,a13
	cmpi	MODE_DEAD,a0
	jreq	#lp0

	SWAP	a8,a13
	FACETBL	#taunt_tbl
	calla	change_anim1a
	SWAP	a8,a13

;Time to execute high-risk move!
	movi	8000h+12*60,a0
	move	a0,*a8(RISK)

	DIE

;	SLEEP	10*60
;	jruc	#lp0

#taunt_tbl
	REFLONG	hrt_4_taunt_anim	;0 Bret Hart
	REFLONG	rzr_4_taunt_anim	;1 Razor Ramon
	REFLONG	und_4_taunt_anim	;2 Undertaker
	REFLONG	yok_4_taunt_anim	;3 Yokozuna
	REFLONG	shn_4_taunt_anim	;4 Shawn Michaels
	REFLONG	bam_4_taunt_anim	;5 Bam Bam
	REFLONG	dnk_4_taunt_anim	;6 Doink
	.long	0		   	;7 spare
	REFLONG	lex_4_taunt_anim	;8 Lex Luger

;*******************************************************************************
;
;#charge_flying_kick
;	move	*a13(BUT_VAL_UP),a0
;	btst	PLAYER_SKICK_BIT,a0
;	jrz	#no_kick
;
;	move	*a13(PLYRNUM),a0
;	calla	get_powerk_dtime
;	cmpi	85,a0			;> min?
;	jrlt	#no_kick
;
;	callr	#scrt_kick
;	setc
;	rets
;
;#no_kick
;	clrc
;	rets
;
;#scrt_kick
;
;	move	*a13(PLYRMODE),a0
;	cmpi	MODE_HEADHELD,a0
;	jrz	#out
;	cmpi	MODE_HEADHOLD,a0
;	jrz	#out
;
;	move	*a13(ANIMODE),a0
;	btst	MODE_UNINT_BIT,a0
;	jrnz	#out
;
;;Don't do it when he is on ground
;	calla	get_opp_plyrmode
;	cmpi	MODE_ONGROUND,a0
;	jrz	#out
;	cmpi	MODE_DEAD,a0
;	jrz	#out
;
;#ok
;	SETMODE	INAIR
;
;	movk	1,a0			;Ensure leap at
;	move	a0,*a13(OBJ_XVEL),L
;
;	movi	dnk_flying_kick_anim,a0
;	calla	change_anim1a
;
;	WRSND	W_DOINK,FLYKICK_T1,FLYKICK_T2
;
;#out	rets
;
#*******************************************************************************

;	STRUCTPD
;	WORD		#CHARGE_TIME	;UDW
#CHARGE_TIME	.equ	SM_USRW1	;

dnk_charge_flykick

#start_over
	clr	a14
	move	a14,*a13(#CHARGE_TIME),W
#loop1
	SLEEPK	1

	move	*a13(#CHARGE_TIME),a14,W
	inc	a14
	move	a14,*a13(#CHARGE_TIME),W

	move	*a8(BUT_VAL_CUR),a0
	btst	PLAYER_SKICK_BIT,a0
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
	cmpi	MODE_HEADHOLD,a0
	jrz	#start_over
	cmpi	MODE_ONGROUND,a0
	jrz	#start_over
	cmpi	MODE_DEAD,a0
	jrz	#start_over

	move	*a8(CLOSEST_NUM),a0
	X32	a0
	addi	process_ptrs,a0
	move	*a0,a0,L
	move	*a0(PLYRMODE),a0
	cmpi	MODE_ONGROUND,a0
	jrz	#start_over
	cmpi	MODE_DEAD,a0
	jrz	#start_over

;Success!  Check for the UNINT bit, then queue it up.
	move	*a8(ANIMODE),a14
	btst	MODE_UNINT_BIT,a14
	jrnz	#start_over

	.ref	ck_ignore_a8
	calla	ck_ignore_a8
	jrc	#start_over

	movi	dnk_flying_kick_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L
	WRSND	W_DOINK,FLYKICK_T1,FLYKICK_T2

	SETMODE	INAIR

	jruc	#start_over
	

#*******************************************************************************
;
;	STRUCTPD
;	WORD		#CHARGE_TIME	;UDW
;	WORD		#TIMEOUT	;UDW
;
;	;in:
;	; a8 = wrestler process address
;
;dnk_charge_flykick
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
;
;	move	*a8(STICK_VAL_CUR),a0
;
;	;arbitrarily define TOWARD to be RIGHT.  So if the opponent is to
;	; our left, flip the L|R direction bits...
;
;	;...however, if the stick isn't pointed left or right, don't do
;	;anything.
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
;	;if we're still holding away, jump back to #loop1
;	btst	MOVE_LEFT_BIT,a0
;	jrnz	#loop1
;
;	;no longer holding away...
;	move	*a13(#CHARGE_TIME),a14
;	cmpi	20,a14
;	jrlt	#start_over
;
;	;okay, they released after holding away for 2 seconds.  Give them
;	; half a second to push forward + super_kick
;
;	movi	TSEC/2,a14
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
;	;we have a button press.  Is is super kick?
;	btst	PLAYER_KICK_BIT,a0
;
;	jrz	#start_over	;wrong button.  No good.
;
;	
;	;Check for a towards on the stick.
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
;
;;success!  Check for the UNINT bit, then queue it up.
;	move	*a8(ANIMODE),a14
;	btst	MODE_UNINT_BIT,a14
;	jrnz	#start_over
;
;	movi	dnk_flying_kick_anim,a14
;	move	a14,*a8(SPECIAL_MOVE_ADDR),L
;
;	SETMODE	INAIR
;
;	movi	1000h,a0
;	move	a0,*a13(OBJ_XVEL),L
;
;	WRSND	W_DOINK,FLYKICK_T1,FLYKICK_T2
;
;	jruc	#start_over

#*******************************************************************************
dnk_hdhold_buzz

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

	WAITSWITCH_DWN	J_DOWN,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_TOWARD,J_DOWN|J_UP,#lp
;	WAITSWITCH_DWN	J_DOWN_TOWARD,0,#lp
	WAITSWITCH_DWN	B_PUNCH,J_ALL,#lp
	
	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrnz	#lp0

;#slam
	CALLA	FIND_AND_KILL_ENDLESS
	movi	dnk_4_buzz_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

;missing noise for a reason !
	WRSND	W_DOINK,HDBUTT_T1

	SLEEP	120

	jruc	#lp

#*****************************************************************************

 SUBR	doink_ani_init

	move	*a13(FACING_DIR),a0
	btst	PLAYER_RIGHT_BIT,a0
	jrnz	#p1
;Plyr 2
	movi	dnk_stand4_anim,a0
	calla	change_anim1a

	movi	dnk_torso4_anim,a0
	calla	change_anim2a

	PUSH	a10
	move	a13,a10
	CREATE	TAUNT_PID,do_taunt
	PULL	a10

	rets

#p1
	movi	dnk_stand2_anim,a0
	calla	change_anim1a

	movi	dnk_torso2_anim,a0
	calla	change_anim2a

	rets

 SUBR	do_taunt
;a10=*wrestler proc
;Do a taunt at start of rounds

;	SLEEP	60
	move	@HALT,a0
	jaz	SUCIDE

	PUSH	a10
	calla	read_switches
	PULL	a10

	move	*a13(PLYR_TYPE),a0
	jrnz	#drone
;Human chooses to taunt?
	move	*a10(STICK_VAL_CUR),a0
	btst	MOVE_UP_BIT,a0
	jaz	SUCIDE
	move	*a10(BUT_VAL_CUR),a0
	btst	PLAYER_BLOCK_BIT,a0
	jaz	SUCIDE

#do_taunt
	PUSH	a13
	move	a10,a13
	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	#taunt_t,a0
	move	*a0,a0,L

	calla	change_anim1a
	PULL	a13

	DIE

#drone
	movi	250,a0
	calla	RNDPER
	jrhi	#do_taunt

      	DIE

#taunt_t
	REFLONG	hrt_4_taunt_anim			;0 Bret Hart
	REFLONG	rzr_4_taunt_anim			;1 Razor Ramon
	REFLONG	und_4_taunt_anim			;2 Undertaker
	REFLONG	yok_4_taunt_anim			;3 Yokozuna
	REFLONG	shn_4_taunt_anim			;4 Shawn Michaels
	REFLONG	bam_4_taunt_anim			;5 Bam Bam
	REFLONG	dnk_4_taunt_anim			;6 Doink
	.long	0		  			;7 spare
	REFLONG	lex_4_taunt_anim			;8 Lex Luger
	.long	0		  			;9 Referee

#*****************************************************************************
*
* DOINKS CONTROL CODE
*
* a13 = * doink process

 SUBR	move_doink

;	movi	100h,a0			;temp fix!
;	move	a0,*a13(ANI_SPEED)

	movi	doink_secret_moves,a11
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
	.long	mode_puppet2
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
	movi	dnk_fall_back_anim,a0
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
	FACE24	dnk,pin_anim
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
	FACE24	dnk,raise_arm_anim
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
	JJXM	NORMAL,		 50, 45,#punch_hdbutt,#punch_punch	;0
	JJXM	RUNNING,	 50, 45,#punch_hdbutt,#punch_punch	;1
	JJXM	INAIR,		 50, 45,#punch_hdbutt,#punch_punch	;2
	JJXM	ATTACHED,	 50, 45,#punch_hdbutt,#punch_punch	;3
	JJXM	ONGROUND,	160,140,#punch_lbowdrop,#punch_punch	;4
	JJXM	BOUNCING,	 50, 45,#punch_hdbutt,#punch_punch	;1
	JJXM	ONTURNBKL,	 50, 45,#punch_hdbutt,#punch_punch	;6
	JJXM	BLOCK,		 50, 45,#punch_hdbutt,#punch_punch	;7
	JJXM	DIZZY,		 50, 45,#punch_hdbutt,#punch_punch	;8
	JJXM	DEAD,		160,140,#punch_lbowdrop,#punch_punch	;9
	JJXM	OPPOVERHEAD,	 50, 45,#punch_hdbutt,#punch_punch	;10
	JJXM	CLIMBTURNBKL,		#punch_punch			;11
	JJXM	WAITANIM,	 50, 45,#punch_hdbutt,#punch_punch	;12
	JJXM	GRAPPLE,	 50, 45,#punch_hdbutt,#punch_punch	;13
	JJXM	MASTER,		 50, 45,#punch_hdbutt,#punch_punch	;14
	JJXM	SLAVE, 		 50, 45,#punch_hdbutt,#punch_punch	;15
	JJXM	HEADHOLD,	 50, 45,#punch_hdbutt,#punch_punch	;16
	JJXM	HEADHELD,	 50, 45,#punch_hdbutt,#punch_punch	;19
	JJXM	CHOKEHOLD,	 50, 45,#punch_hdbutt,#punch_punch	;16
	JJXM	PUPPET,		 50, 45,#punch_hdbutt,#punch_punch	;20
	JJXM	PUPPET2,	 50, 45,#punch_hdbutt,#punch_punch	;20
	JJXM	INAIR2,		 50, 45,#punch_hdbutt,#punch_punch	;21
	JJXM_END

#punch_rets
	rets

*****
#punch_punch
std_punch

	FACE24	dnk,punch_anim
	calla	change_anim1a

	WRSND	W_DOINK,PUNCH_T1,PUNCH_T2

	rets

*****
#punch_hdbutt

	FACE24	dnk,butt_anim
	calla	change_anim1a

	WRSND	W_DOINK,HDBUTT_T1,HDBUTT_T2

	rets

*****
#punch_lbowdrop

	FACE24	dnk,lbowdrop_anim
	calla	change_anim1a

	WRSND	W_DOINK,LBOWDROP_T1,LBOWDROP_T2

	rets

************
#block		;2
std_block
	move	@blocking_off,a0
	jrnz	#no_blocking

	RND_AWARD	a13,BLOCKS_AWD

	movi	dnk_4_block_anim,a0
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
* onground	< 144  160	super elbow drop
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
	JJXM	NORMAL,		 85, 55,#spunch_special,#spunch_slap	;0
	JJXM	RUNNING,	 85, 55,#spunch_special,#spunch_slap	;1
	JJXM	INAIR,		 85, 55,#spunch_special,#spunch_slap	;2
	JJXM	ATTACHED,	 85, 55,#spunch_special,#spunch_slap	;3
	JJXM	ONGROUND,	160,140,#spunch_lbowdrop,std_punch	;4
	JJXM	BOUNCING,	 85, 55,#spunch_special,#spunch_slap	;1
	JJXM	ONTURNBKL,	 	#spunch_slap			;6
	JJXM	BLOCK,		 85, 55,#spunch_special,#spunch_slap	;7
	JJXM	DIZZY,		 85, 55,#spunch_special,#spunch_slap	;8
	JJXM	DEAD,		160,140,#spunch_lbowdrop,std_punch	;9
	JJXM	OPPOVERHEAD,	 85, 55,#spunch_special,#spunch_slap	;10
	JJXM	CLIMBTURNBKL,		std_punch			;11
	JJXM	WAITANIM,	 85, 55,#spunch_special,#spunch_slap	;12
	JJXM	GRAPPLE,	 85, 55,#spunch_special,#spunch_slap	;13
	JJXM	MASTER,		 85, 55,#spunch_special,#spunch_slap	;14
	JJXM	SLAVE, 		 85, 55,#spunch_special,#spunch_slap	;15
	JJXM	HEADHOLD,	 85, 55,#spunch_special,#spunch_slap	;16
	JJXM	HEADHELD,		do_pile				;19
	JJXM	CHOKEHOLD,	 85, 55,#spunch_special,#spunch_slap	;16
	JJXM	PUPPET,		 85, 55,#spunch_special,#spunch_slap	;20
	JJXM	PUPPET2,	 85, 55,#spunch_special,#spunch_slap	;20
	JJXM	INAIR2,		 85, 55,#spunch_special,#spunch_slap	;21
	JJXM_END

#spunch_rets
	rets

*****
#spunch_slap
	FACE24	dnk,slap_anim
	calla	change_anim1a

	WRSND	W_DOINK,SPUNCH_T1,SPUNCH_T2

	rets

*****
#spunch_special
;If stick is toward opponent, then do quick punches

	move	*a13(STICK_VAL_CUR),a0
	btst	MOVE_DOWN_BIT,a0
	jrnz	#ck_up


;	move	*a13(STICK_VAL_CUR),a0
;	move	*a13(NEW_FACING_DIR),a1
;	andi	0ch,a1
;	cmp	a0,a1
;	jrz	#cont

	move	*a13(CLOSEST_XDIST),a1
	cmpi	60,a1
	jrgt	std_punch

;	jruc	#hdbutt
;#cont
;	.ref	dnk_3_head_hold2_anim
;	movi	dnk_3_head_hold2_anim,a0
;	calla	change_anim1a
;
;	WRSND	W_DOINK,GRABHOLD_T1,GRABHOLD_T2
;
;	rets
;#hdbutt

	FACE24	dnk,butts_anim
	calla	change_anim1

	WRSND	W_DOINK,HDBUTT_T1,HDBUTT_T2

	rets

#ck_up
;Check for uppercut
	.ref	dnk_4_uppercut_anim
	movi	dnk_4_uppercut_anim,a0
	calla	change_anim1

	WRSND	W_DOINK,SPUNCH_T1,SPUNCH_T2
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

	FACE24	dnk,hair_pickup_anim
	calla	change_anim1
	WRSND	W_DOINK,LBOWDROP_T1,LBOWDROP_T2
	rets

#no	FACE24	dnk,lbowdrop_anim
	calla	change_anim1
	WRSND	W_DOINK,LBOWDROP_T1,LBOWDROP_T2
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
	JJXM	NORMAL,		 50, 92,#kick_knee,#kick_kick		;0
	JJXM	RUNNING,		 50, 92,#kick_knee,#kick_kick		;0
	JJXM	INAIR,		 50, 92,#kick_knee,#kick_kick		;2
	JJXM	ATTACHED,	 50, 92,#kick_knee,#kick_kick		;3
	JJXM	ONGROUND,	160,140,#kick_stomp,#kick_kick		;4
	JJXM	BOUNCING,	 50, 92,#kick_knee,#kick_kick		;0
	JJXM	ONTURNBKL,	 	#kick_kick			;6
	JJXM	BLOCK,		 50, 92,#kick_knee,#kick_kick		;7
	JJXM	DIZZY,		 50, 92,#kick_knee,#kick_kick		;8
	JJXM	DEAD,		160,140,#kick_stomp,#kick_kick		;9
	JJXM	OPPOVERHEAD,	 50, 92,#kick_knee,#kick_kick		;10
	JJXM	CLIMBTURNBKL,	 	#kick_kick			;11
	JJXM	WAITANIM,	 50, 92,#kick_knee,#kick_kick		;12
	JJXM	GRAPPLE,	 50, 92,#kick_knee,#kick_kick		;13
	JJXM	MASTER,		 50, 92,#kick_knee,#kick_kick		;14
	JJXM	SLAVE, 		 50, 92,#kick_knee,#kick_kick		;15
	JJXM	HEADHOLD,	 50, 92,#kick_knee,#kick_kick		;16
	JJXM	HEADHELD,	 50, 92,#kick_knee,#kick_kick		;19
	JJXM	CHOKEHOLD,	 50, 92,#kick_knee,#kick_kick		;16
	JJXM	PUPPET,		 50, 92,#kick_knee,#kick_kick		;20
	JJXM	PUPPET2,	 50, 92,#kick_knee,#kick_kick		;20
	JJXM	INAIR2,		 	#skick_TB			;21
	JJXM_END

;*****
;#kick_flyingkick
;
;	movi	dnk_flying_kick_anim,a0
;	calla	change_anim1a
;
;	SETMODE	INAIR
;
;	WRSND	W_DOINK,FLYKICK_T1,FLYKICK_T2
;
;	rets

*****
#kick_kick
std_kick

	FACE24	dnk,kick_anim
	calla	change_anim1a

	WRSND	W_DOINK,KICK_T1,KICK_T2

	rets

*****
#kick_knee
std_knee
	FACE24	dnk,knee_anim
	calla	change_anim1a

	WRSND	W_DOINK,KICK_T1,KICK_T2

	rets

*****
#kick_stomp

	FACE24	dnk,stomp_anim
	calla	change_anim1a

	WRSND	W_DOINK,KICK_T1,KICK_T2

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
* onground	< 144  160	super stomp
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
	JJXM	INAIR2,		 	#skick_TB			;21
	JJXM_END

*****
#skick_TB
	.ref	dnk_2_spin_kick_TB_anim
	.ref	dnk_4_spin_kick_TB_anim
	FACE24	dnk,spin_kick_TB_anim
	calla	change_anim1a

	WRSND	W_DOINK,FLYKICK_T1,FLYKICK_T2
	rets

*****
#skick_kick
#graboh

	FACE24	dnk,spin_kick_anim
	calla	change_anim1a

	WRSND	W_DOINK,FLYKICK_T1,FLYKICK_T2
	rets

*****
#skick_special
;If stick is toward opponent, then do quick punches
	move	*a13(STICK_VAL_CUR),a0
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrz	#cont2

	FACE24	dnk,knee_anim
	calla	change_anim1

;	WRSND	W_DOINK,GRABHOLD_T1,GRABHOLD_T2
;no, lets try..... 
	WRSND	W_DOINK,FLYKICK_T1,FLYKICK_T2
	rets

#cont2
	movi	dnk_4_knee_fall_anim,a0
	calla	change_anim1

	WRSND	W_DOINK,GRABHOLD_T1,GRABHOLD_T2
	rets


*****
#skick_stomp

	FACE24	dnk,stomp_anim
	calla	change_anim1a

	WRSND	W_DOINK,KICK_T1,KICK_T2

	rets

*****
#skick_bigboot	;we can probably get away with just a #4 big boot

	FACE24	dnk,bigboot_anim
	calla	change_anim1a

	WRSND	W_DOINK,FLYKICK_T1,FLYKICK_T2

	rets

#*****************************************************************************
*
* RUNNING (if GETUP_TIME > 0 then player is out of control)
*

#XRUN_VAL	equ	DNK_XRUN
#XRUN2_VAL	equ	DNK_XRUN2
#ZDRIFT_VAL	equ	DNK_ZDRIFT

mode_running

	move	*a13(RUN_TIME),a0		;Used for flying kick
	addk	1,a0
	move	a0,*a13(RUN_TIME)

	move	*a13(USR_VAR1),a0
	jrnz	#no_vel

	calla	bounce_off_ropes

	movi	#XRUN_VAL,a0

	move	*a13(WALK_FAST),a14
	jrz	#no
	movi	#XRUN2_VAL,a0
#no
	move	@hyper_speed_on,a14
	sll	a14,a0

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
	JJXM	NORMAL,			#punch_clothesline		;0
	JJXM	RUNNING,		#punch_clothesline		;1
	JJXM	INAIR,			#punch_clothesline		;2
	JJXM	ATTACHED,		#punch_clothesline		;3
	JJXM	ONGROUND,	176,176,#punch_bellyflop,#punch_lbowdrop ;4
	JJXM	BOUNCING,		#punch_clothesline		;5	
	JJXM	ONTURNBKL,		#punch_clothesline		;6
	JJXM	BLOCK,			#punch_clothesline		;7
	JJXM	DIZZY,			#punch_clothesline		;8
	JJXM	DEAD,		176,176,#punch_bellyflop,#punch_lbowdrop ;9
	JJXM	OPPOVERHEAD,		#punch_clothesline		;10
	JJXM	CLIMBTURNBKL,		#punch_clothesline		;11
	JJXM	WAITANIM,	 	#punch_clothesline		;12
	JJXM	GRAPPLE,	 	#punch_clothesline		;13
	JJXM	MASTER,		 	#punch_clothesline		;14
	JJXM	SLAVE, 		 	#punch_clothesline		;15
	JJXM	HEADHOLD,	 	#punch_clothesline		;16
	JJXM	HEADHELD,	 	#punch_clothesline		;19
	JJXM	CHOKEHOLD,	 	#punch_clothesline		;16
	JJXM	PUPPET,		 	#punch_clothesline		;20
	JJXM	PUPPET2,	 	#punch_clothesline		;20
	JJXM	INAIR2,			#punch_clothesline		;21
	JJXM_END


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
	movi	dnk_fly_cline_anim,a0
	calla	change_anim1a

	SETMODE	INAIR

	clr	a0
	move	a0,*a13(RUN_TIME)

	WRSND	W_DOINK,FLYKICK_T1,FLYKICK_T2

	rets

#mv_tbl	.long	0,0,0,0,0,MOVE_RIGHT_BIT,MOVE_RIGHT_BIT
	.long	0,0,MOVE_LEFT_BIT,MOVE_LEFT_BIT

*****
#punch_lbowdrop
#punch_bellyflop

	movi	dnk_belly_anim,a0
	calla	change_anim1a

	SETMODE	INAIR

	clr	a0
	move	a0,*a13(RUN_TIME)

	WRSND	W_DOINK,FLYKICK_T1,FLYKICK_T2

	rets

*****
;#punch_lbowdrop
;
;	FACE24	dnk,lbowdrop_anim
;	calla	change_anim1a
;
;	WRSND	W_DOINK,LBOWDROP_T1,LBOWDROP_T2
;
;	rets

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
	JJXM	NORMAL,			#kick_flyingkick		;0
	JJXM	RUNNING,		#kick_flyingkick		;1
	JJXM	INAIR,			#kick_flyingkick		;2
	JJXM	ATTACHED,		#kick_flyingkick		;3
	JJXM	ONGROUND,	176,176,#kick_runstomp,#kick_runstomp	;4
	JJXM	BOUNCING,		#kick_flyingkick		;5
	JJXM	ONTURNBKL,		#kick_flyingkick		;6
	JJXM	BLOCK,			#kick_flyingkick		;7
	JJXM	DIZZY,			#kick_flyingkick		;8
	JJXM	DEAD,		176,176,#kick_runstomp,#kick_runstomp	;9
	JJXM	OPPOVERHEAD,		#kick_flyingkick		;10
	JJXM	CLIMBTURNBKL,		#kick_flyingkick		;11
	JJXM	WAITANIM,	 	#kick_flyingkick		;12
	JJXM	GRAPPLE,	 	#kick_flyingkick		;13
	JJXM	MASTER,		 	#kick_flyingkick		;14
	JJXM	SLAVE, 		 	#kick_flyingkick		;15
	JJXM	HEADHOLD,	 	#kick_flyingkick		;16
	JJXM	HEADHELD,	 	#kick_flyingkick		;19
	JJXM	CHOKEHOLD,	 	#kick_flyingkick		;16
	JJXM	PUPPET,		 	#kick_flyingkick		;20
	JJXM	PUPPET2,	 	#kick_flyingkick		;20
	JJXM	INAIR2,			#kick_flyingkick		;21
	JJXM_END

*****
#kick_flyingkick

	calla	ck_ignore
	jrc	#z


	movi	dnk_flying_kick_anim,a0
	calla	change_anim1a

	SETMODE	INAIR

	WRSND	W_DOINK,FLYKICK_T1,FLYKICK_T2

	rets

*****
#kick_runstomp
	movi	dnk_belly_anim,a0
	calla	change_anim1a

	SETMODE	INAIR

	clr	a0
	move	a0,*a13(RUN_TIME)

	WRSND	W_DOINK,FLYKICK_T1,FLYKICK_T2

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

	movi	dnk_run2_anim,a0
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

	movi	dnk_climb_down_anim,a0
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
#punchkick	;1
#block		;2

	SETMODE	INAIR
	WRSND	W_DOINK,GRABFLING_T1,GRABFLING_T2

	movi	dnk_4_blbowdrop_anim,a0		;Buckle
	calla	change_anim1a
	rets

************

;	movi	dnk_4_bjump_anim,a0		;Buckle
;	calla	change_anim1a
;	rets

************
#super_punch	;4
;If stick is toward opponent, then do hammer pound move
;	move	*a13(STICK_VAL_CUR),a0
;	move	*a13(NEW_FACING_DIR),a1
;	andi	0ch,a1
;	cmp	a0,a1

;	xor	a0,a1
;	andi	MOVE_LEFT|MOVE_RIGHT,a1
;	cmpi	MOVE_LEFT|MOVE_RIGHT,a1

;	jrnz	#graboh				;Br=regular
;
;;Do hammer pound
; 	movi	dnk_4_bhammer_anim,a0
;	calla	change_anim1a
;	rets
;
;
#graboh		;1

	SETMODE	INAIR
	WRSND	W_DOINK,GRABFLING_T1,GRABFLING_T2

     	movi	dnk_diveofftb_anim,a0
	calla	change_anim1a
	rets

************
#kick		;8
#super_kick	;16

	SETMODE	INAIR
	WRSND	W_DOINK,GRABFLING_T1,GRABFLING_T2

	movi	dnk_4_bstomp_anim,a0		;Buckle
	calla	change_anim1a
	rets

#*****************************************************************************
* blocking

mode_block	;7

	clr	a0
	move	a0,*a13(CONSECUTIVE_HITS)

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

	movi	dnk_4_push_anim,a0
	calla	change_anim1a

	WRSND	W_DOINK,PUSH_T1,PUSH_T2

	rets

#*****************************************************************************
*

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

 SUBR	mode_dead	;9

	;if our zombie bit is set, move
	move	*a13(STATUS_FLAGS),a14
	btst	B_ZOMBIE,a14		;are we already a zombie?
	jrnz	#zmb

	btst	B_DID_BUCKOFF,a14
	jrnz	#done			;have we already done one this match?

	btst	B_NO_BUCKOFF,a14
	jrnz	#done			;have we already checked this round?

	btst	B_DO_BUCKOFF,a14
	jrnz	#count_btns		;are we already counting?

	move	@royal_rumble,a14
	jrnz	#done			;are we in royal rumble mode?

	;We may have to fire up a come back to life process:
	; IF this is the second round we've lost,
	; AND IF our combo meter is flashing,
	; AND IF the hit that killed us was wimpy and our WEAK_HIT bit is set,
	; AND IF we haven't already done a buckoff this match,
	; AND IF we're inside the ring,
	; THEN start counting button presses.

	;Is this the second round we've lost?
	;(skip this test if we're in the 8-on-1 match)
	calla	is_8_on_1
	jrc	#ck81
	move	@p1rounds,a0
	move	*a13(PLYR_SIDE),a14
	jrnz	#rndok
	move	@p2rounds,a0
#rndok	TEST	a0
	jrz	#nobuck
	jruc	#tcombo

#ck81	;it's 8-on-1.  only the player is allowed to buckoff.
	move	*a13(PLYRNUM),a14
	cmpi	2,a14
	jrge	#nobuck

#tcombo	;is our combo meter lit?
	move	a13,a8
	calla	CHECK_COMBO_GO
	jrlt	#nobuck

	;are we inside the ring?
	move	*a13(INRING),a14
	jrnz	#nobuck

	;Buckoff is NOT allowed if undertaker started his finish move or
	;has completed his finish move!!!!
	move	@in_finish_move,a14
	jrnz	#nobuck
	move	@finish_completed,a14
	jrnz	#nobuck

	;temp! - 314
	.if DEBUG
	DBEVENT	BDE_MAYBE_BUCK,a13,L,*a13(WRESTLERNUM),W,*a13(PLYRNUM),W
	.endif

	;possible buckoff.  Zero BUCKOFF_COUNT and set DO_BUCKOFF bit
	clr	a14
	move	a14,*a13(BUCKOFF_COUNT)
	move	*a13(STATUS_FLAGS),a14
	ori	M_DO_BUCKOFF,a14
	move	a14,*a13(STATUS_FLAGS)
	jruc	#count_btns

#nobuck	;no buckoff.  set NO_BUCKOFF bit
	move	*a13(STATUS_FLAGS),a14
	ori	M_NO_BUCKOFF,a14
	move	a14,*a13(STATUS_FLAGS)
	jruc	#done

#zmb	;we're a zombie.  WAITROLL is going to automatically roll us up
	; until we can't roll anymore, and then our anim should make us
	; stand up.  (There should always be a getup after a waitroll.)
	; So all we do is wait for the MODE_END bit to get set, which tells
	; us that we're standing up, outside, with a clear lane to either
	; side.  At that point we begin running toward whichever side of
	; the arena is farther from the camera.  We don't want to be seen
	; vanishing when we hit the edge.

	;Update ZOMBIE_TIME.  If we've been a zombie for ten seconds,
	; something has probably gone wrong with our trip to the side
	; of the arena, so we'll just transform now.
	move	*a13(ZOMBIE_TIME),a14
	inc	a14
	move	a14,*a13(ZOMBIE_TIME)
	cmpi	TSEC*10,a14
	jrlt	#zmb_ok

#change	;timeout!
	calla	change_wrestler
	jruc	#done
#zmb_ok

	move	*a13(ANIMODE),a14
	btst	MODE_END_BIT,a14
	jrz	#done

#run	;begin running left if WORLDTLX > RING_X_CENTER-200, right otherwise.

	;set CAN_XFORM bit so we can transform
	move	*a13(STATUS_FLAGS),a14
	ori	M_CAN_XFORM,a14
	move	a14,*a13(STATUS_FLAGS)

	move	@WORLDTLX,a14,L
	sra	16,a14
	cmpi	RING_X_CENTER-200,a14
	jrge	#run_left

#run_right
	movk	MOVE_RIGHT,a14
	move	a14,*a13(STICK_VAL_CUR)
	movi	start_run_anim,a0
	calla	change_anim1a

	move	*a13(WRESTLERNUM),a14
	X32	a14
	addi	#run_speeds,a14
	move	*a14,a14,L
	move	a14,*a13(OBJ_XVEL),L
	jruc	#done

#run_left
	movk	MOVE_LEFT,a14
	move	a14,*a13(STICK_VAL_CUR)
	movi	start_run_anim,a0
	calla	change_anim1a

	move	*a13(WRESTLERNUM),a14
	X32	a14
	addi	#run_speeds,a14
	move	*a14,a14,L
	neg	a14
	move	a14,*a13(OBJ_XVEL),L


#done	rets

#count_btns
	;count new presses this tick and add to BUCKOFF_COUNT
	move	*a13(BUT_VAL_DOWN),a0
	clr	a1
#lp0	lmo	a0,a14
	jrz	#end0
	rl	a14,a0
	sla	1,a0
	inc	a1
	jruc	#lp0
#end0	move	*a13(BUCKOFF_COUNT),a0

	add	a1,a0
	move	a0,*a13(BUCKOFF_COUNT)

	cmpi	50,a0
	jrge	#dobuck

	.ref	obj_del1c,dec_to_asc,concat_rom_string,mess_spacing
	.ref	ogmd10_ascii,message_ascii,mess_cursx,mess_cursy
	.ref	message_palette,print_string,BINBCD,SGMD8GLD,mess_objid
	.ref	copy_string

	rets

#dobuck	;SUCCESS!  Do the buckoff.

	;temp! - 314
	.if DEBUG
	DBEVENT	BDE_DONE_BUCK,a13,L,*a13(WRESTLERNUM),W,*a13(PLYRNUM),W
	.endif

	;clear my combo meter
	calla	clear_combo_meter

;	;If we've been pinned, send the pinner to his buckoff anim.
;	move	*a13(STATUS_FLAGS),a14
;	btst	B_PINNED,a14
;	jrz	#me_not_pinned
;
;	move	*a13(WHOPINNEDME),a0,L

	;If any opponent has pinned, send him to his buckoff anim.
	movi	NUM_WRES,a0
	movi	process_ptrs,a1
#lp2	move	*a1+,a2,L
	jrz	#nxt2
	move	*a2(STATUS_FLAGS),a14,L
	btst	B_DID_PIN,a14
	jrz	#nxt2
	move	a2,a0
	jruc	#done2
#nxt2	dsj	a0,#lp2
#done2

	;clear his pinned bit
	move	*a0(STATUS_FLAGS),a14
	andni	M_DID_PIN,a14
	move	a14,*a0(STATUS_FLAGS)

	;if his DID_RAISEARM bit is set, then it was probably taker and he's
	; no longer on top of us, so skip the buckoff and just let him get
	; his raisearm anim shut off along with the other drones.
	move	*a0(STATUS_FLAGS),a14
	btst	B_DID_RAISEARM,a14
	jrnz	#me_not_pinned

	;do his bucked off anim (stick it into special_move_addr?)
	move	a0,a8
	FACETBL	#buckoff_tbl,a8
	move	a0,*a8(SPECIAL_MOVE_ADDR),L

#me_not_pinned
	;back to life...
	movi	MODE_ONGROUND,a14
	move	a14,*a13(PLYRMODE)

	;get two pixels back
	movk	2,a0
	move	*a13(PLYRNUM),a1
	calla	adjust_health

	;no getup meter
	clr	a14
	move	a14,*a13(GETUP_TIME)
	move	a14,*a13(DELAY_METER)

;If died in a combo, allow buckoff to continue
	clr	a0
	move	a0,*a13(I_WILL_DIE)

	;reset my pal, just in case.
	move	*a13(MY_PAL),*a13(OBJ_PAL)

;Slide out 2nd wind message
	move	a13,a8
	movi	41,a10
	.ref	MOVE_NAME_ANNC
	CREATE	MESSAGE_PID,MOVE_NAME_ANNC

	;clear DO_BUCKOFF|PINABLE|PINNED, and set DID_BUCKOFF|NEW_BUCKOFF
	move	*a13(STATUS_FLAGS),a14,L
	ori	M_DID_BUCKOFF|M_NEW_BUCKOFF,a14
	andni	M_DO_BUCKOFF|M_PINNED|M_PINABLE,a14
	move	a14,*a13(STATUS_FLAGS),L

	;convulse
	FACETBL	hitonground_tbl
	calla	change_anim1a

	;set nocollis bit
	move	*a13(ANIMODE),a14
	ori	MODE_NOCOLLIS,a14
	move	a14,*a13(ANIMODE)

	;if anyone has done a raisearm, put 'em back in a stand.
	movi	process_ptrs,a0
	movi	NUM_WRES,a1
#lp1	move	*a0+,a2,L
	jrz	#nxt1
	move	*a2(STATUS_FLAGS),a14,L
	btst	B_DID_RAISEARM,a14
	jrz	#nxt1

	;just clear the DID_RAISEARM bit.  Anim scripts will do the rest.
	andni	M_DID_RAISEARM,a14
	move	a14,*a2(STATUS_FLAGS),L


#nxt1	dsj	a1,#lp1

	;If anyone has turned into a drone, turn 'em back.
	clr	a14
	move	@process_ptrs,a0,L
	jrz	#adc1
	move	a14,*a0(PLYR_TYPE)
#adc1	move	@process_ptrs+20h,a0,L
	jrz	#adc2
	move	a14,*a0(PLYR_TYPE)
#adc2

	;call init_reduce_bog, because match_timer clears it when it
	; sees one team dead.
	calla	init_reduce_bog

	;if there's an ANNOUNCE_RND_WINNER process waiting,
	; wake it up so it'll see us alive and die.
	movi	ANNC_PID,a0
	clr	a1
	not	a1
	calla	EXISTP
	jrz	#rets

	move	*a0(PWAKE),a14,L
	cmpi	arw_bwait,a14
	jrne	#uh_oh

	movk	1,a14
	move	a14,*a0(PTIME)
	jruc	#rets

#uh_oh
	.if DEBUG	
	LOCKUP	;announce_rnd_winner ISN'T at arw_bwait!
	.endif
#rets	rets


#buckoff_tbl
	REFLONG	hrt_buckoff_anim	;Bret
	REFLONG	rzr_buckoff_anim	;Razor
	REFLONG	und_buckoff_anim	;Taker
	REFLONG	yok_buckoff_anim	;Yoko
	REFLONG	shn_buckoff_anim	;Shawn
	REFLONG	bam_buckoff_anim	;Bam Bam
	REFLONG	dnk_buckoff_anim	;Doink
	.long	0
	REFLONG	lex_buckoff_anim	;Lex


#run_speeds
	.long	HRT_XRUN
	.long	RZR_XRUN
	.long	UND_XRUN
	.long	YOK_XRUN
	.long	SHN_XRUN
	.long	BAM_XRUN
	.long	DNK_XRUN
	.long	0
	.long	LEX_XRUN


 SUBRP	ani_end_anim
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END	

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



 SUBR	bozo_check

;Bozo check
	move	*a13(SPUNCHB_COUNT),a0
	move	*a13(SKICKB_COUNT),a1
	move	*a13(BLOCKB_COUNT),a2
	add	a0,a1
	add	a1,a2
	cmpi	18,a2
	jrlt	#no_bozo
;Lots of super buttons and blocks have been hit!
;Reverse out
;Do reversal unless I have been immobilized!
;If not, set immobilize time for opponent and reverse

	move	*a13(IMMOBILIZE_TIME),a14
	jrnz	#no_bozo				;ignore

	;target WHOHITME -- don't hit anyone else
	SMRTTGT	a13,WHOHITME

	;immobilize WHOHITME
	move	*a13(WHOHITME),a0,L
	movk	32,a14
	move	a14,*a0(IMMOBILIZE_TIME)

	CALLA	FIND_AND_KILL_ENDLESS
	
	setc
	rets

#no_bozo
	clrc
	rets

#*****************************************************************************

mode_headhold	;16

;Bozo power move
	callr	bozo_check
	jrnc	#fail

	WRSND	W_DOINK,FLYKICK_T1,FLYKICK_T2

	movi	dnk_3_head_slam_anim,a0
	move	@PCNT,a14
	btst	0,a14
	jrz	#tag
	movi	dnk_3_pile_driver_anim,a0
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

	WRSND	W_DOINK,UPRCUT_T1,UPRCUT_T2
	movi	dnk_uppercuts_to_head_anim,a0
	calla	change_anim1a
	rets

#tag2	movi	dnk_uppercut_to_head_anim,a0
	calla	change_anim1a
	WRSND	W_DOINK,UPRCUT_T1,UPRCUT_T2
	rets

************
#super_punch	;4

do_pile
;This flag is only set if doink has done repeated uppercuts!
	move	*a13(USR_VAR2),a0
	jrz	#z

	CALLA	FIND_AND_KILL_ENDLESS
	move	*a13(STICK_VAL_CUR),a0
	btst	PLAYER_DOWN_BIT,a0
	jrz	#punch

	WRSND	W_DOINK,UPRCUT_T1,UPRCUT_T2
	movi	dnk_3_pile_driver_anim,a0
	calla	change_anim1a
	rets

#kick
#punchkick
	CALLA	FIND_AND_KILL_ENDLESS
	WRSND	W_DOINK,KICK_T1,KICK_T2

	movi	dnk_3_knee_to_head_anim,a0
	calla	change_anim1a
	rets

#super_kick	;16
;If stick is toward opponent, then do quick knees
	move	*a13(STICK_VAL_CUR),a0
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrnz	#z

;Quick knees
	CALLA	FIND_AND_KILL_ENDLESS
	WRSND	W_DOINK,KICK_T1,KICK_T2
	movi	dnk_3_knees_to_head_anim,a0
	calla	change_anim1a
	rets


#*****************************************************************************
mode_puppet2	;17

	.if DEBUG
	LOCKUP		;should never be in this mode anymore.
	.endif

	rets

#*****************************************************************************

mode_headheld	;19
	move	*a13(ANIMODE),a0
	btst	MODE_NOGRAVITY_BIT,a0
	janz	mode_choking

;Bozo reversal
	callr	bozo_check
	jrnc	#fail

	PUSH	a8
	move	a13,a8
	CALLA	DO_REVERSAL
	CALLA	DO_REVERSAL_MESS
	PULL	a8

	WRSND	W_DOINK,FLYKICK_T1,FLYKICK_T2

	movi	dnk_3_head_slam_anim,a0
	move	@PCNT,a14
	btst	0,a14
	jrz	#tag
	movi	dnk_3_pile_driver_anim,a0
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

	WRSND	W_DOINK,PUSH_T2
	movi	dnk_3_head_held_stand_anim,a0
	calla	change_anim1a

#no_luck
	rets

#*****************************************************************************
 SUBR	mode_puppet	;20	(used by everyone)

#timeout_val	.equ	TSEC*2

	;if we're attached, don't check anything.
	move	*a13(ATTACH_PROC),a0,L
	jrz	#check
	move	*a0(ATTACH_PROC),a1,L
	cmp	a1,a13
	jreq	#done

#check	;figure out if we're newly in mode_puppet or if we've been
	; here awhile.
	move	*a13(PUPPET_TIME),a14	;last time we were in mode_puppet
	move	@PCNT,a0		;this tick
	move	a0,*a13(PUPPET_TIME)	;in either case, update PUPPET_TIME

	sub	a14,a0
	cmpi	1,a0
	jrne	#new_arrival

	;been here awhile
	move	*a13(PUPPET_TICKS),a0
	inc	a0
	move	a0,*a13(PUPPET_TICKS)

	cmpi	#timeout_val,a0
	jrlt	#done

	;bark!  Been here too long.  glitch to a stand or something.
	.if DEBUG
	LOCKUP
	.endif
	SETMODE	NORMAL
	FACE24TBL #stand_tbl
	calla	change_anim1a
	jruc	#done

#new_arrival
	movk	1,a14
	move	a14,*a13(PUPPET_TICKS)

#done	rets

#stand_tbl
	REFLONG	hrt_stand2_anim,hrt_stand4_anim		;0 Bret Hart
	REFLONG	rzr_stand2_anim,rzr_stand4_anim		;1 Razor Ramon
	REFLONG	und_stand2_anim,und_stand4_anim		;2 Undertaker
	REFLONG	yok_stand2_anim,yok_stand4_anim		;3 Yokozuna
	REFLONG	shn_stand2_anim,shn_stand4_anim		;4 Shawn Michaels
	REFLONG	bam_stand2_anim,bam_stand4_anim		;5 Bam Bam
	REFLONG	dnk_stand2_anim,dnk_stand4_anim		;6 Doink
	.long	0,0					;7 spare
	REFLONG	lex_stand2_anim,lex_stand4_anim		;8 Lex Luger

#*****************************************************************************
mode_chokehold	;24
	rets

#*****************************************************************************
*
 SUBR	mode_inair2	;21

;All wrestlers use this mode_inair2 code, and only for turnbuckle stuff.

;Read joystick for floating off from turnbuckle moves

;Perhaps each wrestler will have a different drift value
#ZDRIFT2_VAL	equ	58000h
#XDRIFT_VAL	equ	30000h

	move	*a13(STICK_VAL_CUR),a0
	clr	a1

	movi	-#ZDRIFT2_VAL,a1
	btst	PLAYER_UP_BIT,a0
	jrnz	#setvel

	movi	#ZDRIFT2_VAL,a1
	btst	PLAYER_DOWN_BIT,a0
	jrnz	#setvel

	clr	a1
#setvel
;	move	*a13(OBJ_ZVEL),a14,L
;	add	a1,a14
;	move	a14,*a13(OBJ_ZVEL),L

	move	*a13(OBJ_ZPOS),a14,L
	add	a1,a14
	move	a14,*a13(OBJ_ZPOS),L


	clr	a1

	movi	-#XDRIFT_VAL,a1
	btst	PLAYER_LEFT_BIT,a0
	jrnz	#setvel2

	movi	#XDRIFT_VAL,a1
	btst	PLAYER_RIGHT_BIT,a0
	jrnz	#setvel2

	clr	a1
#setvel2
;	move	*a13(OBJ_XVEL),a14,L
;	add	a1,a14
;	move	a14,*a13(OBJ_XVEL),L

	move	*a13(OBJ_XPOS),a14,L
	add	a1,a14
	move	a14,*a13(OBJ_XPOS),L

	rets

#*****************************************************************************


;#VEL	equ	30000h		;38000h	;30000h
;#DVEL	equ	21f0eh		;27978h	;21f0eh
;#VEL	equ	38000h		;38000h	;30000h
;#DVEL	equ	30000h		;27978h	;21f0eh
#VEL	equ	3a000h		;38000h	;30000h
#DVEL	equ	31000h		;27978h	;21f0eh


 SUBR dnk_velocity_table

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

 SUBR dnk_rotate_anims_table
; old = up right
	.long	dnk_stand2_anim		;new = up right
	.long	dnk_2_to_4_turn_anim	;    = down right
	.long	dnk_2_to_6_turn_anim	;    = down left ***
	.long	dnk_2_to_8_turn_anim	;    = up left

; old = down right
	.long	dnk_4_to_2_turn_anim	;new = up right
	.long	dnk_stand4_anim		;    = down right
	.long	dnk_4_to_6_turn_anim	;    = down left
	.long	dnk_4_to_8_turn_anim	;    = up left ***

; old = down left
	.long	dnk_6_to_2_turn_anim	;new = up right ***
	.long	dnk_6_to_4_turn_anim	;    = down right
	.long	dnk_stand6_anim		;    = down left
	.long	dnk_6_to_8_turn_anim	;    = up left

; old = up left
	.long	dnk_8_to_2_turn_anim	;new = up right
	.long	dnk_8_to_4_turn_anim	;    = down right ***
	.long	dnk_8_to_6_turn_anim	;    = down left
	.long	dnk_stand8_anim		;    = up left


 SUBR dnk_leg_anims_table
;  MOVE
;(#1 - UP)				FACING
	.long	dnk_walk1_f2_anim	;1 (UP)
	.long	dnk_walk1_f2_anim	;2 (UP_RIGHT)
	.long	dnk_walk1_f4_anim	;3 (RIGHT)
	.long	dnk_walk1_f4_anim	;4 (DOWN_RIGHT)
	.long	dnk_walk1_f4_anim	;5 (DOWN)
	.long	dnk_walk1_f4_anim	;6 (DOWN_LEFT)
	.long	dnk_walk1_f2_anim	;7 (LEFT)
	.long	dnk_walk1_f2_anim	;8 (UP-LEFT)

;(#2 - UP-RIGHT)
	.long	dnk_walk2_f2_anim	;1 (UP)
	.long	dnk_walk2_f2_anim	;2 (UP_RIGHT)
	.long	dnk_walk2_f2_anim	;3 (RIGHT)
	.long	dnk_walk2_f4_anim	;4 (DOWN_RIGHT)
	.long	dnk_walk8_f4_anim	;5 (DOWN)
	.long	dnk_walk8_f4_anim	;6 (DOWN_LEFT)
	.long	dnk_walk4_f2_anim	;7 (LEFT)
	.long	dnk_walk4_f2_anim	;8 (UP-LEFT)

;(#3 - RIGHT)
	.long	dnk_walk2_f2_anim	;1 (UP)
	.long	dnk_walk2_f2_anim	;2 (UP_RIGHT)
	.long	dnk_walk2_f2_anim	;3 (RIGHT)
	.long	dnk_walk4_f4_anim	;4 (DOWN_RIGHT)
	.long	dnk_walk4_f4_anim	;5 (DOWN)
	.long	dnk_walk8_f4_anim	;6 (DOWN_LEFT)
	.long	dnk_walk6_f2_anim	;7 (LEFT)
	.long	dnk_walk6_f2_anim	;8 (UP-LEFT)


;(#4 - DOWN-RIGHT)
	.long	dnk_walk2_f2_anim	;1 (UP)
	.long	dnk_walk8_f2_anim	;2 (UP_RIGHT)
	.long	dnk_walk4_f4_anim	;3 (RIGHT)
	.long	dnk_walk4_f4_anim	;4 (DOWN_RIGHT)
	.long	dnk_walk2_f4_anim	;5 (DOWN)
	.long	dnk_walk6_f4_anim	;6 (DOWN_LEFT)
	.long	dnk_walk2_f2_anim	;7 (LEFT)
	.long	dnk_walk6_f2_anim	;8 (UP-LEFT)

;(#5 - DOWN)
	.long	dnk_walk5_f2_anim	;1 (UP)
	.long	dnk_walk5_f2_anim	;2 (UP_RIGHT)
	.long	dnk_walk5_f4_anim	;3 (RIGHT)
	.long	dnk_walk5_f4_anim	;4 (DOWN_RIGHT)
	.long	dnk_walk5_f4_anim	;5 (DOWN)
	.long	dnk_walk5_f4_anim	;6 (DOWN_LEFT)
	.long	dnk_walk5_f2_anim	;7 (LEFT)
	.long	dnk_walk5_f2_anim	;8 (UP-LEFT)

;(#6 - DOWN-LEFT)
	.long	dnk_walk2_f2_anim	;1 (UP)
	.long	dnk_walk6_f2_anim	;2 (UP_RIGHT)
	.long	dnk_walk2_f2_anim	;3 (RIGHT)
	.long	dnk_walk6_f4_anim	;4 (DOWN_RIGHT)
	.long	dnk_walk2_f4_anim	;5 (DOWN)
	.long	dnk_walk4_f4_anim	;6 (DOWN_LEFT)
	.long	dnk_walk2_f2_anim	;7 (LEFT)
	.long	dnk_walk8_f2_anim	;8 (UP-LEFT)

;(#7 - LEFT)
	.long	dnk_walk2_f2_anim	;1 (UP)
	.long	dnk_walk6_f2_anim	;2 (UP_RIGHT)
	.long	dnk_walk6_f2_anim	;3 (RIGHT)
	.long	dnk_walk8_f4_anim	;4 (DOWN_RIGHT)
	.long	dnk_walk4_f4_anim	;5 (DOWN)
	.long	dnk_walk4_f4_anim	;6 (DOWN_LEFT)
	.long	dnk_walk2_f2_anim	;7 (LEFT)
	.long	dnk_walk2_f2_anim	;8 (UP-LEFT)

;(#8 - UP-LEFT)
	.long	dnk_walk2_f2_anim	;1 (UP)
	.long	dnk_walk4_f2_anim	;2 (UP_RIGHT)
	.long	dnk_walk6_f2_anim	;3 (RIGHT)
	.long	dnk_walk8_f4_anim	;4 (DOWN_RIGHT)
	.long	dnk_walk6_f4_anim	;5 (DOWN)
	.long	dnk_walk2_f4_anim	;6 (DOWN_LEFT)
	.long	dnk_walk2_f2_anim	;7 (LEFT)
	.long	dnk_walk2_f2_anim	;8 (UP-LEFT)


 SUBR dnk_torso_anims_table
; old = up right
	.long	dnk_torso2_anim		;new = up right
	.long	dnk_2_to_4_turn2_anim	;    = down right
	.long	dnk_2_to_6_turn2_anim	;    = down left ***
	.long	dnk_2_to_8_turn2_anim	;    = up left

; old = down right
	.long	dnk_4_to_2_turn2_anim	;new = up right
	.long	dnk_torso4_anim		;    = down right
	.long	dnk_4_to_6_turn2_anim	;    = down left
	.long	dnk_4_to_8_turn2_anim	;    = up left ***

; old = down left
	.long	dnk_6_to_2_turn2_anim	;new = up right ***
	.long	dnk_6_to_4_turn2_anim	;    = down right
	.long	dnk_torso6_anim		;    = down left
	.long	dnk_6_to_8_turn2_anim	;    = up left

; old = up left
	.long	dnk_8_to_2_turn2_anim	;new = up right
	.long	dnk_8_to_4_turn2_anim	;    = down right ***
	.long	dnk_8_to_6_turn2_anim	;    = down left
	.long	dnk_torso8_anim		;    = up left


;	STRUCTPD
;	WORD		#CHARGE_TIME	;UDW
;	WORD		#TIMEOUT	;UDW
;
;
; SUBRP	dnk_hammer_mv
;
;;in:
;;a8 = wrestler process address
;
;;Hammer pound opponent
;;Charge away for 30 ticks
;;Toward & Super punch
;
;#start_over
;	;charge on stick away
;	clr	a14
;	move	a14,*a13(#CHARGE_TIME),W
;#loop1
;	SLEEPK	1
;
;;Disallow these type of moves if out of control
;	move	*a8(GETUP_TIME),a0
;	jrnz	#loop1
;
;	move	*a13(#CHARGE_TIME),a14,W
;	inc	a14
;	move	a14,*a13(#CHARGE_TIME),W
;
;	move	*a8(STICK_VAL_CUR),a0
;
;	;arbitrarily define TOWARD to be RIGHT.  So if the opponent is to
;	; our left, flip the L|R direction bits...
;
;	;...however, if the stick isn't pointed left or right, don't do
;	;anything.
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
;	;if we're still holding away, jump back to #loop1
;	btst	MOVE_LEFT_BIT,a0
;	jrnz	#loop1
;
;	;no longer holding away...
;	move	*a13(#CHARGE_TIME),a14
;
;;x seconds held stick is away
;
;	cmpi	15,a14
;	jrlt	#start_over
;
;	;okay, they released after holding away for 2 seconds.  Give them
;	;half a second to push forward + super_punch
;
;;	movi	TSEC/2,a14
;	movk	20,a14
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
;	;we have a button press.  Is it super punch?
;	btst	PLAYER_PUNCH_BIT,a0
;	jrz	#start_over	;wrong button.  No good.
;	
;	;Check for a towards on the stick.
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
;;success!  Check for the UNINT bit, then queue it up.
;	move	*a8(ANIMODE),a14
;	btst	MODE_UNINT_BIT,a14
;	jrnz	#start_over
;
; 	movi	dnk_4_hammer_anim,a14
;
;	move	*a13(PLYRMODE),a0
;	cmpi	MODE_ONTURNBKL,a0
;	jrz	#start_over
;
;;	move	*a13(PLYRMODE),a0
;;	cmpi	MODE_ONTURNBKL,a0
;;	jrnz	#do
;; 	movi	dnk_4_bhammer_anim,a14
;;#do
;	move	a14,*a8(SPECIAL_MOVE_ADDR),L
;	jruc	#start_over
;
;;	.endif
;
;#*
;
; SUBRP	dnk_earslap_mv
;
;	STRUCTPD
;	WORD		#CHARGE_TIME	;UDW
;	WORD		#TIMEOUT	;UDW
;
;
;;in:
;;a8 = wrestler process address
;
;;Ear slap opponent
;;Charge away for 30 ticks
;;Toward & Super punch
;
;#start_over
;	;charge on stick away
;	clr	a14
;	move	a14,*a13(#CHARGE_TIME),W
;#loop1
;	SLEEPK	1
;
;;Disallow these type of moves if out of control
;	move	*a8(GETUP_TIME),a0
;	jrnz	#loop1
;	calla	get_opp_plyrmode
;	cmpi	MODE_ONGROUND,a0
;	jrz	#loop1
;	cmpi	MODE_DEAD,a0
;	jrz	#loop1
;
;	move	*a13(#CHARGE_TIME),a14,W
;	inc	a14
;	move	a14,*a13(#CHARGE_TIME),W
;
;	move	*a8(STICK_VAL_CUR),a0
;
;	;arbitrarily define TOWARD to be RIGHT.  So if the opponent is to
;	; our left, flip the L|R direction bits...
;
;	;...however, if the stick isn't pointed left or right, don't do
;	;anything.
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
;	;if we're still holding away, jump back to #loop1
;	btst	MOVE_LEFT_BIT,a0
;	jrnz	#loop1
;
;	;no longer holding away...
;	move	*a13(#CHARGE_TIME),a14
;
;;x seconds held stick is away
;
;	cmpi	20,a14
;	jrlt	#start_over
;
;	;okay, they released after holding away for 2 seconds.  Give them
;	;half a second to push forward + super_punch
;
;;	movi	TSEC/2,a14
;	movk	15,a14
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
;	;we have a button press.  Is it super punch?
;	btst	PLAYER_SPUNCH_BIT,a0
;;	jrz	#start_over	;wrong button.  No good.
;	jrz	#loop2
;	btst	PLAYER_PUNCH_BIT,a0
;	jrz	#loop2
;	
;	;Check for a towards on the stick.
;	move	*a8(STICK_VAL_CUR),a0
;;	jrz	#start_over	;no stick at all.  No good.
;	jrz	#loop2
;
;	move	*a8(NEW_FACING_DIR),a14
;	btst	MOVE_LEFT_BIT,a14
;	jrz	#no_flip2
;	xori	MOVE_LEFT|MOVE_RIGHT,a0
;#no_flip2
;	btst	MOVE_RIGHT_BIT,a0
;;	jrz	#start_over	;pooched it
;	jrz	#loop2
;
;;success!  Check for the UNINT bit, then queue it up.
;	move	*a8(ANIMODE),a14
;	btst	MODE_UNINT_BIT,a14
;	jrnz	#start_over
;
; 	movi	dnk_4_earslap_anim,a14
;
;	move	*a13(PLYRMODE),a0
;	cmpi	MODE_ONTURNBKL,a0
;	jrz	#start_over
;
;	move	a14,*a8(SPECIAL_MOVE_ADDR),L
;	jruc	#start_over


******************************************************************************

	.end
