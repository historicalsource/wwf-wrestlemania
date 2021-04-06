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


******************************************************************************
* EXTERNAL REFERENCES

	.ref	change_anim1a,change_anim2a,do_taunt
	.ref	shn_2_hair_pickup_anim,bounce_off_ropes
;,break_lockup
	.ref	check_secret_moves,wres_get_but_val_cur
	.ref	master_keep_attached,lineup_grapple
	.ref	ck_ignore,climb_turnbuckle,execute_walk,get_opp_plyrmode
	.ref	get_punch_dtime,wres_get_stick_val_cur
	.ref	process_ptrs,form_button_value,keep_attached,change_anim1
	.ref	change_anim2,clear_damage_log,wres_get_stick_rel_cur
	.ref	wres_get_but_val_down,mode_inair2,wres_get_but_val_up
	.ref	wres_get_stick_rel_new,JUMP_ROPES
	.REF	DO_REVERSAL
	.REF	DO_REVERSAL_MESS

******************************************************************************
* ANIMATION SEQUENCES

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
	.ref	shn_2_push_anim,shn_4_push_anim
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
	.ref	shn_super_speedkick_anim
	.ref	shn_fstein_anim,shn_backflip_kick_anim
	.ref	shn_2_pin_anim,shn_4_pin_anim
	.ref	shn_2_bslam_anim
	.ref	shn_4_bslam_anim
	.ref	shn_speed_spinkick_anim,shn_knee_fstein_anim
	.ref	shn_sliding_kicktoss_anim,shn_break_arm_anim

	;reactions
	.ref	shn_dizzy_anim
	.ref	shn_2_grabfling_anim,shn_4_grabfling_anim

	;blocks
	.ref	shn_2_block_anim,shn_4_block_anim

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* special moves
*
* away-away-super kick		-	backflip kick
* toward-toward-super kick	-	frankensteiner
* toward-toward-super punch	-	german suplex
* charge away-super kick	-	super speedkick
* roll away-down-fwd super kick	-	sliding kicktoss
*

shn_secret_moves
	.long	#speed_kicks	;must have this one
	.long	#grab_fling
	.long	#grab_toss
	.long	#neck_grab
	.long	#frankensteiner

;	.long	#german_suplex
;	.long	#armbreaker
;	.long	#backflip_kick
;	.long	#sliding_kicktoss

	.long	0

*****************************************************************************
*
* SPECIAL MOVE PROCESSES
*

 SUBR	shn_smove_table
	.long	sm_super_speedkick
	.long	sm_super_speedkick2
	.long	sm_sliding_kicktoss
	.long	sm_hdhold_suplex
	.long	sm_hdhold_frank
	.long	sm_super_suplex
	.long	sm_hdhold_kicktoss
	.long	sm_hdhold_flipslam
	.long	0

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
	cmpi	70h,a0
	jrgt	#out

	FACE24	shn,bslam_anim
	calla	change_anim1a

	WRSND	W_SHAWN,GRABFLING_T1,GRABFLING_T2
	rets

*******************************************************************************

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

;If opponent is running, do a hip toss
	calla	get_opp_plyrmode
	cmpi	MODE_BOUNCING,a0
	jrz	#yes
	cmpi	MODE_RUNNING,a0
	jrnz	#nope
#yes
	FACE24	shn,bslam_anim
	calla	change_anim1a

	WRSND	W_SHAWN,GRABFLING_T1,GRABFLING_T2
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

	FACE24	shn,grabfling_anim
	calla	change_anim1a

	WRSND	W_SHAWN,GRABFLING_T1,GRABFLING_T2
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

	.ref	shn_3_head_hold_anim
	movi	shn_3_head_hold_anim,a0
	calla	change_anim1a
#out	rets

*******************************************************************************

#speed_kicks
	move	a13,a0
	calla	wres_get_but_val_up
	btst	PLAYER_SKICK_BIT,a0
	jrz	#no_kick

	move	*a13(PLYRNUM),a0
	.ref	get_powerk_dtime
	calla	get_powerk_dtime
	cmpi	85,a0			;> min?
	jrlt	#no_kick
;	cmpi	100+60,a0		;< max?
;	jrgt	#no_kick

	callr	scrt_kick
	setc
	rets

#no_kick
	clrc
	rets

scrt_kick

	move	*a13(PLYRMODE),a0
	cmpi	MODE_HEADHELD,a0
	jrz	#ok

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#out

;Don't do it when he is on ground
	calla	get_opp_plyrmode
	cmpi	MODE_ONGROUND,a0
	jrz	#out
	cmpi	MODE_DEAD,a0
	jrz	#out

#ok

	SETMODE	INAIR

	movk	1,a0			;Ensure leap at
	move	a0,*a13(OBJ_XVEL),L

	movi	shn_flying_kick_anim,a0
	calla	change_anim1a


	WRSND	W_SHAWN,FLYKICK_T1,FLYKICK_T2

	rets

*******************************************************************************


;		BITS			MASK

;#backflip_kick
;	.word	B_SKICK,		J_ALL
;	.word	J_AWAY,			J_REAL_LR
;	.word	J_AWAY,			J_REAL_LR
;	.word	8000h | 50 		;max
;	.long	#scrt_backflip_kick
;
;#scrt_backflip_kick
;	move	*a13(ANIMODE),a0
;	btst	MODE_UNINT_BIT,a0
;	jrnz	#rets
;	movi	shn_backflip_kick_anim,a0
;	calla	change_anim1a
;	WRSND	W_SHAWN,KICK_T1,KICK_T2
;	rets

*******************************************************************************

;#armbreaker
;	.word	B_PUNCH,		J_ALL
;	.word	J_TOWARD,		J_REAL_LR
;	.word	J_TOWARD,		J_REAL_LR
;	.word	8000h | 50 		;max
;	.long	#scrt_armbreaker
;
;#scrt_armbreaker
;	move	*a13(ANIMODE),a0
;	btst	MODE_UNINT_BIT,a0
;	jrnz	#rets
;
;	;only do this if target is blocking
;	move	*a13(CLOSEST_NUM),a14
;	X32	a14
;	addi	process_ptrs,a14
;	move	*a14,a14,L
;	move	*a14(PLYRMODE),a14
;	cmpi	MODE_BLOCK,a14
;	jrne	#rets
;
;	movi	shn_break_arm_anim,a0
;	calla	change_anim1a
;	WRSND	W_SHAWN,PUNCH_T1,PUNCH_T2
;	rets

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
	
	movi	shn_fstein_anim,a0
	calla	change_anim1a
	WRSND	W_SHAWN,KICK_T1,KICK_T2
#rets	rets

*******************************************************************************

 .if 0

	STRUCTPD
	WORD		#CHARGE_TIME	;UDW
	WORD		#TIMEOUT	;UDW

	;in:
	; a8 = wrestler process address

 SUBRP	sm_super_speedkick

#start_over
	;charge on stick away
	clr	a14
	move	a14,*a13(#CHARGE_TIME),W
#loop1
	SLEEPK	1

	move	*a13(#CHARGE_TIME),a14,W
	inc	a14
	move	a14,*a13(#CHARGE_TIME),W

	move	a8,a0
	calla	wres_get_stick_val_cur

	;arbitrarily define TOWARD to be RIGHT.  So if the opponent is to
	; our left, flip the L|R direction bits...

	;...however, if the stick isn't pointed left or right, don't do
	;anything.
	move	a0,a14
	andi	MOVE_LEFT|MOVE_RIGHT,a14
	jrz	#no_flip

	move	*a8(NEW_FACING_DIR),a14
	btst	MOVE_LEFT_BIT,a14
	jrz	#no_flip
	xori	MOVE_LEFT|MOVE_RIGHT,a0
#no_flip

	;if we're still holding away, jump back to #loop1
	btst	MOVE_LEFT_BIT,a0
	jrnz	#loop1

	;no longer holding away...
	move	*a13(#CHARGE_TIME),a14
	cmpi	TSEC*2,a14
	jrlt	#start_over

	;okay, they released after holding away for 2 seconds.  Give them
	; half a second to push forward + super_kick

	movi	TSEC/2,a14
	move	a14,*a13(#TIMEOUT)
#loop2
	SLEEPK	1

	move	a8,a0
	calla	wres_get_but_val_down
	move	a0,a0
	jrnz	#press

	move	*a13(#TIMEOUT),a14
	dec	a14
	jrz	#start_over
	move	a14,*a13(#TIMEOUT)
	jruc	#loop2

#press
	;we have a button press.  Is is super kick?
	btst	PLAYER_SKICK_BIT,a0

	jrz	#start_over	;wrong button.  No good.

	
	;Check for a towards on the stick.
	move	a8,a0
	calla	wres_get_stick_val_cur
	move	a0,a0
	jrz	#start_over	;no stick at all.  No good.

	move	*a8(NEW_FACING_DIR),a14
	btst	MOVE_LEFT_BIT,a14
	jrz	#no_flip2
	xori	MOVE_LEFT|MOVE_RIGHT,a0
#no_flip2
	btst	MOVE_RIGHT_BIT,a0
	jrz	#start_over	;pooched it

	;success!  Check for the UNINT bit, then queue it up.
	move	*a8(ANIMODE),a14
	btst	MODE_UNINT_BIT,a14
	jrnz	#start_over
	movi	shn_super_speedkick_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L
	jruc	#start_over
	
 .endif

#*******************************************************************************
sm_super_speedkick

#TIMEOUT	.equ	60

#lp0
	SLEEPK	1
#lp
	move	*a8(GETUP_TIME),a0
	jrnz	#lp0
	clr	a11

	WAITSWITCH_DWN	J_AWAY,0,#lp

	movi	#TIMEOUT,a11
	WAITSWITCH_DWN	J_UP_AWAY,0,#lp
	WAITSWITCH_DWN	J_UP,0,#lp
	WAITSWITCH_DWN	J_UP_TOWARD,0,#lp
	WAITSWITCH_DWN	J_TOWARD,0,#lp
	WAITSWITCH_DWN	B_KICK,J_DOWN_TOWARD,#lp

	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHELD,a0
	jrnz	#slam

	CALLA	DO_REVERSAL
	CALLA	DO_REVERSAL_MESS

;Make sure the reversal works!
	movk	10,a0
	move	a0,*a8(SAFE_TIME)

#slam
	movi	shn_super_speedkick_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L
	WRSND	W_SHAWN,KICK_T1,KICK_T2

	SLEEPK	1

	jruc	#lp


#*******************************************************************************

	STRUCTPD
	WORD		#CHARGE_TIME	;UDW

sm_super_speedkick2

#start_over
	clr	a14
	move	a14,*a13(#CHARGE_TIME),W
#loop1
	SLEEPK	1

	move	*a13(#CHARGE_TIME),a14,W
	inc	a14
	move	a14,*a13(#CHARGE_TIME),W

	move	a8,a0
	calla	wres_get_but_val_cur
	btst	PLAYER_KICK_BIT,a0
	jrz	#p1

	jruc	#loop1

#p1

;no longer holding button
	move	*a13(#CHARGE_TIME),a14
	cmpi	90,a14
	jrlt	#start_over

;success!  Check for the UNINT bit, then queue it up.
	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHELD,a0
	jrnz	#slam

;Keep these commented out for now... 
;	move	*a8(ANIMODE),a14
;	btst	MODE_UNINT_BIT,a14
;	jrnz	#start_over

;    	jruc	#slam

;#rev
	CALLA	DO_REVERSAL
	CALLA	DO_REVERSAL_MESS

;Make sure the reversal works!
	movk	10,a0
	move	a0,*a8(SAFE_TIME)

	move	*a8(OBJ_ZPOS),a0,L
	addi	[5,0],a0
	move	a0,*a8(OBJ_ZPOS),L

#slam
	movi	shn_super_speedkick_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	WRSND	W_SHAWN,KICK_T1,KICK_T2

	jruc	#start_over
	

#*******************************************************************************
sm_hdhold_flipslam

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

	WAITSWITCH_DWN	J_TOWARD,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_AWAY,0,#lp
	WAITSWITCH_DWN	B_SPUNCH,J_DOWN_AWAY|J_DOWN_TOWARD,#lp

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
	movi	shn_flipslam_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L
	WRSND	W_SHAWN,KICK_T1,KICK_T2

	SLEEP	60

	jruc	#lp

#*******************************************************************************
sm_hdhold_suplex

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
	movi	shn_gsuplex_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L
	WRSND	W_SHAWN,KICK_T1,KICK_T2

	SLEEP	60

	jruc	#lp

#*******************************************************************************
sm_hdhold_kicktoss

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

	WAITSWITCH_DWN	J_AWAY,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_TOWARD,0,#lp
	WAITSWITCH_DWN	J_TOWARD,0,#lp
	WAITSWITCH_DWN	B_KICK,J_UP_TOWARD|J_DOWN_TOWARD,#lp
	
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
	WRSND	W_SHAWN,KICK_T1,KICK_T2
	movi	shn_sliding_kicktoss_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEP	60

	jruc	#lp

#*******************************************************************************
sm_hdhold_frank

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
	movi	shn_fstein_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L
	WRSND	W_SHAWN,KICK_T1,KICK_T2

	SLEEP	60

	jruc	#lp

#*******************************************************************************

	STRUCTPD
	WORD		#CHARGE_TIME	;UDW

 SUBRP	sm_super_suplex

;Try to spin around and suplex

#start_over
	clr	a14
	move	a14,*a13(#CHARGE_TIME),W
#loop1
	SLEEPK	1

	move	*a13(#CHARGE_TIME),a14,W
	inc	a14
	move	a14,*a13(#CHARGE_TIME),W

	move	a8,a0
	calla	wres_get_but_val_cur
	btst	PLAYER_PUNCH_BIT,a0
	jrz	#p1

	jruc	#loop1

#p1

;no longer holding button
	move	*a13(#CHARGE_TIME),a14
	cmpi	100,a14
	jrlt	#start_over

;success!  Check for the UNINT bit, then queue it up.
	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHELD,a0
	jrz	#rev

	move	*a8(GETUP_TIME),a0
	jrnz	#start_over
	move	*a8(PLYRMODE),a0
	cmpi	MODE_ONGROUND,a0
	jrz	#start_over
	cmpi	MODE_DEAD,a0
	jrz	#start_over

;Keep these commented out for now...
;	move	*a8(ANIMODE),a14
;	btst	MODE_UNINT_BIT,a14
;	jrnz	#start_over

    	jruc	#slam

#rev
	CALLA	DO_REVERSAL
	CALLA	DO_REVERSAL_MESS

;Make sure the reversal works!
	movk	10,a0
	move	a0,*a8(SAFE_TIME)

	move	*a8(OBJ_ZPOS),a0,L
	addi	[5,0],a0
	move	a0,*a8(OBJ_ZPOS),L

#slam
	movi	shn_gsuplex_anim,a14

	move	*a8(PLYRMODE),a0
	cmpi	MODE_RUNNING,a0
	jrnz	#cont

	.ref	shn_gsuplex_run_anim
	movi	shn_gsuplex_run_anim,a14

#cont
	move	a14,*a8(SPECIAL_MOVE_ADDR),L
	WRSND	W_SHAWN,KICK_T1,KICK_T2

	jruc	#start_over
	

#*******************************************************************************

 SUBRP	sm_sliding_kicktoss

#TIMEOUT	.equ	60

#lp0
	SLEEPK	1
#lp
	clr	a11

;	WAITSWITCH_DWN	J_AWAY,0,#lp
	WAITSWITCH_DWN	J_TOWARD,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_TOWARD,0,#lp
	WAITSWITCH_DWN	B_KICK,0,#lp

	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHELD,a0
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
	PUSH	a13
	move	a8,a13
	calla	get_opp_plyrmode
	PULL	a13
	cmpi	MODE_ONGROUND,a0
	jrz	#lp
	cmpi	MODE_DEAD,a0
	jrz	#lp

;Don't do it if opponent is behind you
	calla	ck_ignore
	jrc	#lp

	WRSND	W_SHAWN,KICK_T1,KICK_T2
	movi	shn_sliding_kicktoss_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEP	60

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
	CREATE0	do_taunt
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

	FACE24	shn,pin_anim
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
	JJXM	NORMAL,		 58, 45,#punch_hdbutt,#punch_punch
	JJXM	BLOCK,		 75, 85,#punch_armbrk,#punch_punch
	JJXM	DIZZY,		 52, 85,#punch_hdbutt,#punch_punch
	JJXM	ONGROUND,	120,120,#punch_lbdrop,#punch_punch
	JJXM	RUNNING,	 	#punch_punch
	JJXM	BOUNCING,		#punch_punch
	JJXM	ONTURNBKL,	 	#punch_punch
	JJXM	CLIMBTURNBKL,	 	#punch_punch
	JJXM	PUPPET,			#punch_punch
	JJXM	INAIR,			#punch_punch
	JJXM	ATTACHED,	 58, 45,#punch_hdbutt,#punch_punch
	JJXM	DEAD,		 58, 45,#punch_hdbutt,#punch_punch
	JJXM	OPPOVERHEAD,	 58, 45,#punch_hdbutt,#punch_punch
	JJXM	WAITANIM,	 58, 45,#punch_hdbutt,#punch_punch
	JJXM	GRAPPLE,	 58, 45,#punch_hdbutt,#punch_punch
	JJXM	MASTER,		 58, 45,#punch_hdbutt,#punch_punch
	JJXM	SLAVE,		 58, 45,#punch_hdbutt,#punch_punch
	JJXM	HEADHOLD,	 58, 45,#punch_hdbutt,#punch_punch
	JJXM	HEADHELD,	 58, 45,#punch_hdbutt,#punch_punch
	JJXM	INAIR2,		 58, 45,#punch_hdbutt,#punch_punch
	JJXM_END

*****	
#punch_armbrk
;If stick is toward opponent, then do quick punches
	move	a13,a0
	calla	wres_get_stick_val_cur
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrnz	#punch_hdbutt

	movi	shn_break_arm_anim,a0
	calla	change_anim1a

	WRSND	W_SHAWN,GRABHOLD_T1,GRABHOLD_T2

	rets

*****	
#punch_punch
std_punch
	FACE24	shn,punch_anim
	calla	change_anim1a

	WRSND	W_SHAWN,PUNCH_T1,PUNCH_T2

	rets

*****
#punch_hdbutt

	FACE24	shn,butt_anim
	calla	change_anim1a

	WRSND	W_SHAWN,HDBUTT_T1,HDBUTT_T2
	rets

*****
#punch_lbdrop

	FACE24	shn,falling_punch_anim
	calla	change_anim1a

	WRSND	W_SHAWN,LBOWDROP_T1,LBOWDROP_T2
	rets

************
#block		;2

;	clr	a0
;	move	a0,*a13(OBJ_XVEL),L

std_block
	FACE24	shn,block_anim
	calla	change_anim1a

	rets

************
#super_punch	;4

	JJXM_INIT
	JJXM	NORMAL,		 85, 45,#spunch_special,#spunch_slap	;0
	JJXM	RUNNING,	 85, 45,#spunch_special,#spunch_slap	;1
	JJXM	INAIR,		 85, 45,#spunch_special,#spunch_slap	;2
	JJXM	ATTACHED,	 85, 45,#spunch_special,#spunch_slap	;3
	JJXM	ONGROUND,	120,120,#spunch_lbowdrop,std_punch	;4
	JJXM	BOUNCING,		#spunch_rets			;5
	JJXM	ONTURNBKL,	 	#spunch_slap			;6
	JJXM	BLOCK,		 85, 45,#spunch_special,#spunch_slap	;7
	JJXM	DIZZY,		 85, 45,#spunch_special,#spunch_slap	;8
	JJXM	DEAD,		 96,112,#spunch_lbowdrop,std_punch	;9
	JJXM	OPPOVERHEAD,	 85, 45,#spunch_special,#spunch_slap	;10
	JJXM	CLIMBTURNBKL,		std_punch			;11
	JJXM	WAITANIM,	 85, 45,#spunch_special,#spunch_slap	;12
	JJXM	GRAPPLE,	 85, 45,#spunch_special,#spunch_slap	;13
	JJXM	MASTER,		 85, 45,#spunch_special,#spunch_slap	;14
	JJXM	SLAVE, 		 85, 45,#spunch_special,#spunch_slap	;15
	JJXM	HEADHOLD,	 85, 45,#spunch_special,#spunch_slap	;16
	JJXM	HEADHELD,	 85, 45,#spunch_special,#spunch_slap	;17
	JJXM	PUPPET,		 85, 45,#spunch_special,#spunch_slap	;20
	JJXM	INAIR2,		 85, 45,#spunch_special,#spunch_slap	;21
	JJXM_END

#spunch_rets
	rets

*****
#spunch_slap

	.ref	shn_4_slap_anim
	.ref	shn_2_slap_anim

	FACE24	shn,slap_anim
	calla	change_anim1a

	WRSND	W_SHAWN,SPUNCH_T1,SPUNCH_T2

	rets

*****
#spunch_special
;If stick is toward opponent, then do quick punches
	move	a13,a0
	calla	wres_get_stick_val_cur
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrz	#cont

	move	*a13(CLOSEST_XDIST),a1
	cmpi	50,a1
	jrgt	std_punch
	jruc	#hdbutt
#cont

	.ref	shn_3_head_hold2_anim
	movi	shn_3_head_hold2_anim,a0
	calla	change_anim1a

	WRSND	W_SHAWN,GRABHOLD_T1,GRABHOLD_T2

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


;*****
;#spunch_slamfling
;	move	a13,a0
;	calla	wres_get_stick_rel_cur
;	btst	MOVE_AWAY_BIT,a0
;	jrnz	att_grabfling
;	jruc	att_bodyslam
;
;att_grabfling
;	FACE24	shn,grabfling_anim
;	calla	change_anim1a
;	WRSND	W_SHAWN,GRABFLING_T1,GRABFLING_T2
;	rets
;
;att_bodyslam
;	calla	get_opp_plyrmode
;	move	a0,a1
;	movi	shn_bslam_anim,a0
;	cmpi	MODE_RUNNING,a1
;	jreq	#runslam
;	cmpi	MODE_BOUNCING,a1
;	jreq	#runslam
;	movi	shn_standing_bslam_anim,a0
;#runslam
;	calla	change_anim1a
;	WRSND	W_SHAWN,SPUNCH_T1,SPUNCH_T2
;	rets


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
	JJXM	ONGROUND,	120,120,#kick_stomp,#kick_kick
	JJXM	RUNNING,	 120,92,#kick_kick,#kick_flyingkick	;1
	JJXM	BOUNCING,	 120,92,#kick_kick,#kick_flyingkick	;1
	JJXM	ONTURNBKL,	 	#kick_kick
	JJXM	CLIMBTURNBKL,	 	#kick_kick
	JJXM	PUPPET,			#kick_kick
	JJXM	INAIR,			#kick_kick
	JJXM	ATTACHED,	 60, 50,#kick_knee,#kick_kick
	JJXM	DEAD,		120,120,#kick_stomp,#kick_kick
	JJXM	OPPOVERHEAD,	 60, 50,#kick_knee,#kick_kick
	JJXM	WAITANIM,	 60, 50,#kick_knee,#kick_kick
	JJXM	GRAPPLE,	 60, 50,#kick_knee,#kick_kick
	JJXM	MASTER,		 60, 50,#kick_knee,#kick_kick
	JJXM	SLAVE,		 60, 50,#kick_knee,#kick_kick
	JJXM	HEADHOLD,	 60, 50,#kick_knee,#kick_kick
	JJXM	HEADHELD,	 60, 50,#kick_knee,#kick_kick
	JJXM	INAIR2,		 60, 50,#kick_knee,#kick_kick
	JJXM_END

*****
#kick_kick
attack_kick

	FACE24	shn,kick_anim
	calla	change_anim1a

	WRSND	W_SHAWN,KICK_T1,KICK_T2
	rets

*****
#kick_knee

	FACE24	shn,knee_anim
	calla	change_anim1a

	WRSND	W_SHAWN,KICK_T1,KICK_T2
	rets

*****
#kick_stomp

	FACE24	shn,stomp_anim
	calla	change_anim1a

	WRSND	W_SHAWN,KICK_T1,KICK_T2
	rets

*****
#kick_flyingkick
	movi	shn_flying_kick_anim,a0
	calla	change_anim1a

	SETMODE	INAIR

	WRSND	W_SHAWN,FLYKICK_T1,FLYKICK_T2

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
	JJXM	ONGROUND,	120,120,#skick_stomp,attack_kick
	JJXM	RUNNING,		#skick_frank
	JJXM	BOUNCING,		#skick_frank
	JJXM	ONTURNBKL,	 	#skick_kick
	JJXM	CLIMBTURNBKL,	 	#skick_kick
	JJXM	PUPPET,		 	#skick_kick
	JJXM	INAIR,		 	#skick_kick
	JJXM	ATTACHED,	 	#skick_kick
	JJXM	DEAD,		120,120,#skick_stomp,attack_kick
	JJXM	OPPOVERHEAD,	 	#skick_kick
	JJXM	WAITANIM,	 	#skick_kick
	JJXM	GRAPPLE,	 	#skick_kick
	JJXM	MASTER,		 	#skick_kick
	JJXM	SLAVE,		 	#skick_kick
	JJXM	HEADHOLD,	 	#skick_kick
	JJXM	HEADHELD,	 	#skick_kick
	JJXM	INAIR2,		 	#skick_kick
	JJXM_END

*****
#skick_frank
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

	;don't do it if the bad guy is on the ground
	calla	get_opp_plyrmode
	cmpi	MODE_ONGROUND,a0
	jreq	#rets
	cmpi	MODE_DEAD,a0
	jreq	#rets

	SETMODE	INAIR

;	clr	a0
;	move	a0,*a13(RUN_TIME)


	movi	shn_flying_kick_anim,a0
	calla	change_anim1a

	WRSND	W_SHAWN,FLYKICK_T1,FLYKICK_T2
	rets

*****
#skick_fstein
attack_fstein

	;don't do it if opponent is behind you
	calla	ck_ignore
	jrc	#rets

	movi	shn_fstein_anim,a0
	calla	change_anim1a

	SETMODE	INAIR

	WRSND	W_SHAWN,GRABHOLD_T1,GRABHOLD_T2
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

;Delay reading buttons after just getting out of an out of control run
;so a mistaken move isn't fired off
	move	*a13(DELAY_BUTNS),a0
	jrnz	#out_of_control

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
	.long	#punch			;1 (punch)
	.long	#block			;2 (block)
	.long	#z			;3
	.long	#super_punch		;4 (super punch)
	.long	#z,#z,#z		;5-7
	.long	#kick			;8 kick
	.long	#z,#z,#z,#z,#z,#z,#z	;9-15
	.long	#super_kick		;16 (super kick)
	.long	#z,#z,#z,#z,#z,#z,#z	;17-23
	.long	#z,#z,#z,#z,#z,#z,#z,#z	;24-31

************
#z		;0

	rets


************
#punch		;1
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
	JJXM	INAIR2,			#spunch_rets
	JJXM_END

#spunch_rets
	rets


************
#punch_flipslam

       movi    shn_flipslam_anim,a0
       calla   change_anim1a

       WRSND   W_SHAWN,GRABFLING_T1,GRABFLING_T2
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
	JJXM	NORMAL,		 	attack_fstein
	JJXM	DIZZY,		 	attack_fstein
	JJXM	BLOCK,		 	attack_fstein
	JJXM	ONGROUND,		attack_runstomp
	JJXM	RUNNING,	 	attack_fstein
	JJXM	BOUNCING,		attack_fstein
	JJXM	ONTURNBKL,	 	attack_flykick
	JJXM	CLIMBTURNBKL,	 	attack_flykick
	JJXM	INAIR,			attack_flykick
	JJXM	PUPPET,			attack_flykick
	JJXM	ATTACHED,		attack_fstein
	JJXM	DEAD,		 	attack_runstomp
	JJXM	OPPOVERHEAD,		attack_fstein
	JJXM	WAITANIM,		attack_fstein
	JJXM	GRAPPLE,		attack_fstein
	JJXM	MASTER,			attack_fstein
	JJXM	SLAVE,			attack_fstein
	JJXM	HEADHOLD,		attack_fstein
	JJXM	HEADHELD,		attack_fstein
	JJXM	INAIR2,			attack_fstein
	JJXM_END
	

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

	move	a13,a0
	calla	wres_get_stick_val_cur
	btst	PLAYER_DOWN_BIT,a0
	jrz	#no_climbdown

	;this is so an attack isn't turned into a climbdown
	; in those 5-10 ticks before MODE_INAIR2 is set...
	move	*a13(ANIBASE),a14,L
	cmpi	shn_climb_up_anim,a14
	jrne	#no_climbdown

	movi	shn_climb_down_anim,a0
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

     	movi	shn_belbow_anim,a0
	calla	change_anim1a
	rets

************
#kick		;8
#super_kick	;16

     	movi	shn_bstomp_anim,a0
	calla	change_anim1a
	rets


#*****************************************************************************
* blocking

mode_block	;7

	;check unint
	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_interrupt

	calla	form_button_value

	X32	a0
	addi	#action_table,a0
	move	*a0,a0,L
	call	a0

#no_interrupt
	rets

#action_table
	.long	#z,#z,#z		;0-2
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

	FACE24  shn,push_anim
	calla	change_anim1a

	WRSND	W_SHAWN,PUSH_T1,PUSH_T2

	rets


#*****************************************************************************
* shawn with zero health

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
	movi	shn_4_knee_anim,a0
	calla	change_anim1a
	rets

#tag
	movi	shn_4_knee_anim,a0
	calla	change_anim1a
	rets

************
#super_punch	;4

	rets

************
#punchkick
#graboh
#kick
	move	a13,a0
	calla	wres_get_stick_rel_cur

	btst	MOVE_TOWARD_BIT,a0
	jrz	#knee

	;speed kick - speed kick - speed kick - spin kick
	movi	shn_speed_spinkick_anim,a0
	calla	change_anim1a
	rets

#knee
	movi	shn_4_knee_anim,a0
	calla	change_anim1a
	rets

************
#super_kick	;16
;If stick is toward opponent, then do quick knees
	move	a13,a0
	calla	wres_get_stick_val_cur
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrnz	#z

	;knee - knee - knee - frankensteiner
	movi	shn_knee_fstein_anim,a0
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

	movi	shn_3_head_held_stand_anim,a0
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

 SUBR shn_rotate_anims_table
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


 SUBR shn_leg_anims_table
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


 SUBR shn_torso_anims_table
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