;Tap thru every fucking delay
;Into ring easier
;Drain from my meter into his on squeeze move
;Fix immobilize - doesn't allow stands from head hold or fire punch angle swaps
;Blood from broken arm
;Revive after death
;Fix all action_tables to read dual buttons!  We miss button hits...
;Make alt arena pals come up rarely, or button combo!
;Lex club somebody down from in close super punch
;Fix end of round/game pin/move time/stuff
;Fix convulse on all pins
;Out of ring slide backs
;Fix shawn run/stomp
;Penalize missed ghosts
;Do some 5x damage moves, etc.
;Flash player on powerups!
;Stop near rope pile driver zeroing of y vel
;Fix flying kicks in place, looks stupid, be successful...
;Buyin count - repeated ladder position - Jake!
;Fix shawn flip toss
;Fix head hold speeds/look
;Don't knock me down with 1 pixel, and am blocking
;Blocks slide velocity
;Two bozo modes on aggressor head hold - 2 presses of supers does kick
;Flying kick start rules / like clothesline
;Add smoke whisps
;fire moves
;make flykick not miss on bounce!
;Damage bug from combo
;Wrong guy awarded victory
;Fix all at_types, including at_leaping
;Whack on buttons bozo mode
;Fix frankensteiner into blocker
;Clothesline stick on blocker
;Flykick off of blocker up into air
;Get out of overhead
;Get out of chokehold
;Kick toss out of ring
;Wrong person wins
;HIGHER YVEL ON TURNBUCKLE STUFF
;RING ENTRANCE EASIER
;Urn in takers hand at end
;Do our own auto pin
;Z on pin
;Buckle drop after being hit!
;Immobilize bugs
;Shawn dead, but still in puppet mode
;Make tombstone smash work on ground opponent
;reverse piledriver/neckbrkr for und
;Tombstone smash sound
;Killed in midst of head held hits - for everyone!
;Frankensteiner reversal doesn't jump up high!  Yes it does!
;Reversals don't work!
;Show fast victory time
;Put in new artwork
;Whack out of fast victory - it selected razor
;Make spirits code/art cooler
;Redo head grabs
;Eyes tumble from head on eye gouge
;Fix pal options - button combo at start - Blue curtain is good
;Fling guy into wrong direction
;Fix razor knee into gut from head hold
;Doink pin toss
;Flash screen white
;Sliding choke move - faster?
;Fix taker smash snd
;Fix taker clobber snd
;Fix big boots, read kick & skick buttons
;Debris from broken arm
;Place specific speech calls where needed!  (Ex. Arm break "Here it comes")
;High scream when shawn nabs you on charge suplex

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


******************************************************************************
* EXTERNAL REFERENCES


	.ref	DO_REVERSAL,DO_REVERSAL_MESS,FIND_AND_KILL_ENDLESS
	.ref	ADD_IF_SILENT,JUMP_ROPES,CLIMB_ROPES
	.ref	check_dizzy
	.ref	create_damage_points

	.ref	set_getup_time
	.ref	get_punch_dtime
	.ref	get_rope_x
	.ref	tally_damage,clear_damage_log
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

	;from CROWD.ASM
	.ref	crowd_cheer

	;from DCSSOUND.ASM
	.ref	triple_sound

	;from WRESTLE.ASM
	.ref	calc_line_x
	.ref	face_each_other
	.ref	slide_offscr
	.ref	BONUS_MESS

;animation sequence

	.ref	dnk_3_pile_driver_anim
	.ref	dnk_2_push2_anim
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
;	.ref	dnk_4_bjump_anim

 	.ref	dnk_2_lbowdrop_anim,dnk_4_lbowdrop_anim
	.ref	dnk_2_grabfling_anim
	.ref	dnk_4_grabfling_anim

	.ref	dnk_heldoh_anim

	.ref	dnk_diveofftb_anim

	.ref	dnk_fly_cline_anim
	.ref	dnk_flying_kick_anim
;	.ref	dnk_sflying_kick_anim

	.ref	dnk_4_head_hit2_anim

	.ref	dnk_2_head_hit2_anim
	.ref	dnk_4_head_hit_anim,dnk_head_hit3_anim
	.ref	dnk_2_head_hit_anim,dnk_head_hit2_anim
	.ref	dnk_fall_back_anim
	.ref	dnk_2_faceup_getup_anim
	.ref	dnk_4_faceup_getup_anim

	.ref	dnk_4_losebal_dizzy_anim

	.ref	dnk_hitonground_anim
	.ref	dnk_4_stomp_anim,dnk_2_stomp_anim
	.ref	dnk_4_bstomp_anim

	.ref	dnk_climb_up_anim,dnk_climb_down_anim
	.ref	dnk_4_block_anim,dnk_2_block_anim
	.ref	dnk_2_hitblock_anim,dnk_4_hitblock_anim
	.ref	dnk_2_hiptoss_anim,dnk_4_hiptoss_anim
	.ref	dnk_2_hiptoss2_anim,dnk_4_hiptoss2_anim
	.ref	dnk_4_push_anim,dnk_2_push_anim
	.ref	dnk_4_bigboot_anim,dnk_2_bigboot_anim
	.ref	dnk_4_losebal_anim
	.ref	dnk_dizzy_anim
	.ref	dnk_2_pin_anim
	.ref	dnk_4_pin_anim
;	.ref	dnk_2_lockup_anim,dnk_4_lockup_anim
	.ref	dnk_climbthru_side_anim,dnk_climbthru_bot_anim
	.ref	dnk_climbthru_top_anim,dnk_climbin_bot_anim
	.ref	dnk_climbin_top_anim,dnk_climbin_side_anim

	.ref	dnk_belly_anim
	.ref	ck_ignore  		;Ignore button press?

	.ref 	dnk_pkup_chair_anim

	.ref	dnk_3_knee_to_head_anim
	.ref	dnk_3_knees_to_head_anim
	.ref	dnk_uppercut_to_head_anim
	.ref	dnk_uppercuts_to_head_anim
	.ref	dnk_get_buzz_anim

	.ref	dnk_3_head_hold2_anim
	.ref	dnk_3_head_hold_anim

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
	.long	#earslap
	.long	#grab_fling
	.long	#hammer
	.long	#hip_toss
	.long	#neck_grab
	.long	#boxing_pnch
	.long	0


******************************************************************************
*
* SPECIAL MOVE PROCESSES - Secret moves
*
;a8=process of wrestler

 SUBR	dnk_smove_table
;	.long	dnk_charge_flykick
	.long	dnk_hdhold_slam
	.long	dnk_hdhold_pile
	.long	dnk_hdhold_combo1
	.long	dnk_hdhold_combo2
	.long	dnk_hdhold_buzz
	.long	dnk_hdhold_anti_combo
	.long	dnk_grab_toss_air
	.long	dnk_walk_fast
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
;	jrz	#ok

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
	FACE24	dnk,buzz2_anim
	calla	change_anim1a
	rets
#norm
	FACE24	dnk,buzz_anim
	calla	change_anim1a
	rets
#ok
	movi	dnk_4_buzz_anim,a0
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

;Don't do it when he is on ground
	calla	get_opp_plyrmode
	cmpi	MODE_ONGROUND,a0
	jrz	#out
	cmpi	MODE_DEAD,a0
	jrz	#out
	cmpi	MODE_HEADHELD,a0
	jrz	#out

	movi	dnk_4_earslap_anim,a0
	calla	change_anim1a
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

	move	*a13(CLOSEST_XDIST),a1
	cmpi	70,a1
	jrgt	#std_grab

	movi	dnk_3_head_hold2_anim,a0
	calla	change_anim1a
	rets

#std_grab
	movi	dnk_3_head_hold_anim,a0
	calla	change_anim1a
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

	FACE24	dnk,grabfling_anim
	calla	change_anim1a

	WRSND	W_DOINK,GRABFLING_T1,PUNCH_T2
	rets

*******************************************************************************

#hip_toss
	.word	B_PUNCH | J_AWAY,	J_REAL_LR | J_UP | J_DOWN
	.word	8000h | 10		;max
	.long	#scrt_hiptoss

#scrt_hiptoss
	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#out

;Don't do it when he is on ground
	calla	get_opp_plyrmode
	cmpi	MODE_ONGROUND,a0
	jrz	#out
	cmpi	MODE_BLOCK,a0
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
	FACE24	dnk,hiptoss_anim
	calla	change_anim1a

	WRSND	W_DOINK,HIPTOSS_T1,PUNCH_T2

#out	rets

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

;Do reversal unless I have been immobilized!
;If not, set immobilize time for opponent and reverse

	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

	CALLA	DO_REVERSAL
	CALLA	DO_REVERSAL_MESS
	jruc	#is_reversal

#slam
	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

	movk	1,a10
	CREATE0	BONUS_MESS

#is_reversal
	move	*a8(ATTACH_PROC),a14,L
	movk	15,a0
	move	a0,*a14(IMMOBILIZE_TIME)

	CALLA	FIND_AND_KILL_ENDLESS

	.ref	dnk_3_head_slam_anim
	movi	dnk_3_head_slam_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEP	60

	jruc	#lp

*******************************************************************************
#*
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

	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

	CALLA	DO_REVERSAL
	CALLA	DO_REVERSAL_MESS
	jruc	#is_reversal

#slam
	move	*a8(IMMOBILIZE_TIME),a14
	jrnz	#lp0				;ignore

	movk	6,A10			;Pile driver
	CREATE0	BONUS_MESS

#is_reversal
	move	*a8(ATTACH_PROC),a14,L
	movk	15,a0
	move	a0,*a14(IMMOBILIZE_TIME)

	CALLA	FIND_AND_KILL_ENDLESS
	movi	dnk_3_pile_driver_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEP	60

	jruc	#lp

*******************************************************************************
#*
dnk_hdhold_anti_combo
#TIMEOUT	.equ	80

#lp0
	SLEEPK	1
#lp
;Is my opponent in combo mode?
;	move	*a8(IMMOBILIZE_TIME),a14
;	jrz	#lp0
;	move	*a8(CLOSEST_NUM),a0
;	X32	a0
;	addi	process_ptrs,a0
;	move	*a0,a0,L
;	move	*a0(COMBO_COUNT),a0
;	jrz	#lp0

	clr	a11

	WAITSWITCH_DWN	J_UP,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_UP_TOWARD,0,#lp
	WAITSWITCH_DWN	J_TOWARD,0,#lp
	WAITSWITCH_DWN	J_DOWN_TOWARD,0,#lp
	WAITSWITCH_DWN	J_DOWN,0,#lp
	WAITSWITCH_DWN	J_DOWN_AWAY,0,#lp
	WAITSWITCH_DWN	J_AWAY,0,#lp
	WAITSWITCH_DWN	J_UP_AWAY,0,#lp
	WAITSWITCH_DWN	J_UP,0,#lp
	WAITSWITCH_DWN	B_SPUNCH,0,#lp

;Is my opponent in combo mode?
	move	*a8(CLOSEST_NUM),a0
	X32	a0
	addi	process_ptrs,a0
	move	*a0,a0,L
	move	*a0(COMBO_COUNT),a0
	jrz	#lp0

	move	*a8(ANTI_COMBO_TIME),a0		;Time stamp
	.ref	PCNT
	move	@PCNT,a14
	sub	a0,a14
	abs	a14
	cmpi	80,a14
	jrge	#lp0

;Combo breaker message!
	CALLA	DO_REVERSAL
	CALLA	DO_REVERSAL_MESS

	clr	a0
	move	a0,*a8(IMMOBILIZE_TIME)

	move	*a8(ATTACH_PROC),a14,L
	movk	15,a0
	move	a0,*a14(IMMOBILIZE_TIME)

	CALLA	FIND_AND_KILL_ENDLESS

	movi	dnk_3_pile_driver_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEP	60

	jruc	#lp

*******************************************************************************

#*
dnk_hdhold_combo1

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
;In combo mode?
	calla	CHECK_COMBO_GO
	jrlt	#lp0


	clr	a11

	WAITSWITCH_DWN	J_TOWARD,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_TOWARD,0,#lp
	WAITSWITCH_DWN	B_SPUNCH,J_DOWN_TOWARD|J_UP_TOWARD,#lp

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

	movi	dnk_combo_uppercut_to_head_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEP	60

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
	jrz	#cont
	cmpi	MODE_HEADHELD,a0
	jrnz	#lp0
#cont
;In combo mode?
	calla	CHECK_COMBO_GO
	jrlt	#lp0


	clr	a11

	WAITSWITCH_DWN	J_TOWARD,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_TOWARD,0,#lp
	WAITSWITCH_DWN	B_SKICK,J_DOWN_TOWARD|J_UP_TOWARD,#lp

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

	movi	dnk_4_combo_kick_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

	SLEEP	60

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
	WAITSWITCH_DWN	B_PUNCH,J_DOWN_AWAY|J_UP_AWAY,#lp

	move	*a8(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#lp

	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jreq	#lp0

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
	cmpi	6ch,a0
	jrgt	#lp

	FACE24	dnk,hiptoss_anim
	move	a0,*a8(SPECIAL_MOVE_ADDR),L

	WRSND	W_DOINK,GRABFLING_T1,PUNCH_T2

	SLEEP	60
	jruc	#lp

#doit2	FACE24	dnk,hiptoss2_anim
	move	a0,*a8(SPECIAL_MOVE_ADDR),L

	WRSND	W_DOINK,GRABFLING_T1,PUNCH_T2

	SLEEP	60

	jruc	#lp


*******************************************************************************

#*
dnk_walk_fast
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

	movi	30000h,a0
	move	a0,*a8(OBJ_YVEL),L

	movi	15*60,a0
	move	a0,*a8(WALK_FAST)

;Doink speech call
;211h
	movi	211h,a0
	.ref	ADD_VOICE
	calla	ADD_VOICE
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
;	PUSH	a13
;	move	a8,a13
;	calla	get_opp_plyrmode
;	PULL	a13
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

	WAITSWITCH_DWN	J_DOWN_AWAY,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	J_DOWN,0,#lp
	WAITSWITCH_DWN	J_DOWN_TOWARD,0,#lp
	WAITSWITCH_DWN	J_TOWARD,0,#lp
	WAITSWITCH_DWN	B_PUNCH,J_UP_TOWARD|J_DOWN_TOWARD,#lp
	
	move	*a8(PLYRMODE),a0
	cmpi	MODE_HEADHOLD,a0
	jrnz	#lp0

;#slam
	CALLA	FIND_AND_KILL_ENDLESS
	movi	dnk_4_buzz_anim,a14
	move	a14,*a8(SPECIAL_MOVE_ADDR),L

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
	CREATE0	do_taunt
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

	SLEEP	60
	.ref	HALT
	move	@HALT,a0
	jaz	SUCIDE

	move	*a10(BUT_VAL_DOWN),a0
	btst	PLAYER_BLOCK_BIT,a0
	jrnz	#tag

	movi	250,a0
	.ref	RNDPER
	calla	RNDPER
	jals	SUCIDE

	.ref	current_round
	move	@current_round,a0
	cmpi	1,a0
	jrz	#tag
;Start of 2 or 3rd round!  Only drones can taunt here!
	move	*a10(PLYRNUM),a0
	cmpi	2,a0
	jalt	SUCIDE
;Drone to taunt
#tag	PUSH	a13
	move	a10,a13
	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	#taunt_t,a0
	move	*a0,a0,L

	calla	change_anim1a
	PULL	a13
 
	DIE

	.ref	hrt_4_taunt_anim,rzr_4_taunt_anim,und_4_taunt_anim
	.ref	yok_4_taunt_anim,shn_4_taunt_anim,bam_4_taunt_anim
	.ref	lex_4_taunt_anim
	.ref	dnk_4_taunt_anim

#taunt_t
	.long	hrt_4_taunt_anim			;0 Bret Hart
	.long	rzr_4_taunt_anim			;1 Razor Ramon
	.long	und_4_taunt_anim			;2 Undertaker
	.long	yok_4_taunt_anim			;3 Yokozuna
	.long	shn_4_taunt_anim			;4 Shawn Michaels
	.long	bam_4_taunt_anim			;5 Bam Bam
	.long	dnk_4_taunt_anim			;6 Doink
	.long	0		  			;7 spare
	.long	lex_4_taunt_anim			;8 Lex Luger
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

	move	*a13(I_WILL_DIE),a0
	jrz	#nope
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

;Any button causes a pin
	move	*a13(BUT_VAL_CUR),a0
	jrz	#opp_not_dead

;Make sure opponent is on the ground!
;First, see if opponent is on the ground.
	move	*a13(CLOSEST_DIST),a0
	cmpi	70h,a0
	jrgt	#opp_not_dead
	move	*a13(CLOSEST_ZDIST),a0
	cmpi	50h,a0
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

;Maybe check all velocities at this point


;Opponent is on ground.
;Now check to see if I'm attached to him in puppet mode!
	move	*a13(ATTACH_PROC),a1,L
	jrz	#done
	move	*a1(ATTACH_PROC),a2,L
	cmp	a2,a13
;If I'm attached to him, let the move finish!
	jrz	#opp_not_dead
#done

	FACE24	dnk,pin_anim
	calla	change_anim1a

	rets

#opp_notgnd
#opp_not_dead

	move	*a13(IMMOBILIZE_TIME),a0
	jrnz	#immobilized

	move	*a13(BUT_VAL_CUR),a0
	btst	PLAYER_BLOCK_BIT,a0	;maybe have to action tables?
	jrz	#nblk			;1 for down transitions
	callr	#block			;& 1 for current buttons
	clr	a0
	move	a0,*a13(ATTACK_TYPE)
#nblk

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
;This table accounts for 2 buttons being hit simultaneously.

	.long	#z					;0
	.long	#punch					;1
	.long	#block					;2
	.long	#z					;3
	.long	#super_punch				;4
	.long	#super_punch,#z,#z			;5-7
	.long	#kick					;8
	.long	punchkick,#z,#z,#kick,#z,#z,#z		;9-15
	.long	#super_kick				;16
	.long	#z,#z,#z,#graboh,#z,#z,#z		;17-23
	.long	#kick,#z,#z,#z,#z,#z,#z,#z		;24-31

;Unmolested list...
;	.long	#z				;0
;	.long	#punch				;1
;	.long	#block				;2
;	.long	#z				;3
;	.long	#super_punch			;4
;	.long	#z,#z,#z			;5-7
;	.long	#kick				;8
;	.long	#z,#z,#z,#z,#z,#z,#z		;9-15
;	.long	#super_kick			;16
;	.long	#z,#z,#z,#z,#z,#z,#z		;17-23
;	.long	#z,#z,#z,#z,#z,#z,#z,#z		;24-31

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
	JJXM	ONGROUND,	120,120,#punch_lbowdrop,#punch_punch	;4
	JJXM	BOUNCING,	 50, 45,#punch_hdbutt,#punch_punch	;1
	JJXM	ONTURNBKL,	 50, 45,#punch_hdbutt,#punch_punch	;6
	JJXM	BLOCK,		 50, 45,#punch_hdbutt,#punch_punch	;7
	JJXM	DIZZY,		 50, 45,#punch_hdbutt,#punch_punch	;8
	JJXM	DEAD,		 96,112,#punch_lbowdrop,#punch_punch	;9
	JJXM	OPPOVERHEAD,	 50, 45,#punch_hdbutt,#punch_punch	;10
	JJXM	CLIMBTURNBKL,		#punch_punch			;11
	JJXM	WAITANIM,	 50, 45,#punch_hdbutt,#punch_punch	;12
	JJXM	GRAPPLE,	 50, 45,#punch_hdbutt,#punch_punch	;13
	JJXM	MASTER,		 50, 45,#punch_hdbutt,#punch_punch	;14
	JJXM	SLAVE, 		 50, 45,#punch_hdbutt,#punch_punch	;15
	JJXM	HEADHOLD,	 50, 45,#punch_hdbutt,#punch_punch	;16
	JJXM	HEADHELD,	 50, 45,#punch_hdbutt,#punch_punch	;19
	JJXM	PUPPET,		 50, 45,#punch_hdbutt,#punch_punch	;20
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
	FACE24	dnk,block_anim
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
	JJXM	ONGROUND,	 136,112,#spunch_lbowdrop,std_punch	;4
	JJXM	BOUNCING,	 85, 55,#spunch_special,#spunch_slap	;1
	JJXM	ONTURNBKL,	 	#spunch_slap			;6
	JJXM	BLOCK,		 85, 55,#spunch_special,#spunch_slap	;7
	JJXM	DIZZY,		 85, 55,#spunch_special,#spunch_slap	;8
	JJXM	DEAD,		 96,112,#spunch_lbowdrop,std_punch	;9
	JJXM	OPPOVERHEAD,	 85, 55,#spunch_special,#spunch_slap	;10
	JJXM	CLIMBTURNBKL,		std_punch			;11
	JJXM	WAITANIM,	 85, 55,#spunch_special,#spunch_slap	;12
	JJXM	GRAPPLE,	 85, 55,#spunch_special,#spunch_slap	;13
	JJXM	MASTER,		 85, 55,#spunch_special,#spunch_slap	;14
	JJXM	SLAVE, 		 85, 55,#spunch_special,#spunch_slap	;15
	JJXM	HEADHOLD,	 85, 55,#spunch_special,#spunch_slap	;16
	JJXM	HEADHELD,		do_pile				;19
	JJXM	PUPPET,		 85, 55,#spunch_special,#spunch_slap	;20
	JJXM	INAIR2,		 85, 55,#spunch_special,#spunch_slap	;21
	JJXM_END

#spunch_rets
	rets

*****
#spunch_slap

;	cmpi	60,a2
;	jrgt	#norm
;	cmpi	6eh,a1
;	jrlt	#close
;
;#norm
	FACE24	dnk,slap_anim
	calla	change_anim1a

	WRSND	W_DOINK,SPUNCH_T1,SPUNCH_T2

	rets

;#close
;	cmpi	70,a1
;	jrlt	#norm
;
;	FACE24	dnk,slap2_anim
;	calla	change_anim1a
;
;	WRSND	W_DOINK,PUNCH_T1,PUNCH_T2
;
;	rets

*****
#spunch_special
;If stick is toward opponent, then do quick punches
;	move	*a13(STICK_VAL_CUR),a0
;	move	*a13(NEW_FACING_DIR),a1
;	andi	0ch,a1
;	cmp	a0,a1
;	jrz	#cont

	move	*a13(CLOSEST_XDIST),a1
	cmpi	50,a1
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

	FACE24	dnk,butt_anim
	calla	change_anim1

	WRSND	W_DOINK,HDBUTT_T1,HDBUTT_T2

	rets

*****
#spunch_lbowdrop
	.ref	dnk_2_hair_pickup_anim
	.ref	dnk_4_hair_pickup_anim
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
	JJXM	RUNNING,	 	#skick_bigboot			;1
	JJXM	INAIR,		 50, 92,#kick_knee,#kick_kick		;2
	JJXM	ATTACHED,	 50, 92,#kick_knee,#kick_kick		;3
	JJXM	ONGROUND,	120,120,#kick_stomp,#kick_kick		;4
	JJXM	BOUNCING,	 	#skick_bigboot			;1
	JJXM	ONTURNBKL,	 	#kick_kick			;6
	JJXM	BLOCK,		 50, 92,#kick_knee,#kick_kick		;7
	JJXM	DIZZY,		 50, 92,#kick_knee,#kick_kick		;8
	JJXM	DEAD,		 96,112,#kick_stomp,#kick_kick		;9
	JJXM	OPPOVERHEAD,	 50, 92,#kick_knee,#kick_kick		;10
	JJXM	CLIMBTURNBKL,	 	#kick_kick			;11
	JJXM	WAITANIM,	 50, 92,#kick_knee,#kick_kick		;12
	JJXM	GRAPPLE,	 50, 92,#kick_knee,#kick_kick		;13
	JJXM	MASTER,		 50, 92,#kick_knee,#kick_kick		;14
	JJXM	SLAVE, 		 50, 92,#kick_knee,#kick_kick		;15
	JJXM	HEADHOLD,	 50, 92,#kick_knee,#kick_kick		;16
	JJXM	HEADHELD,	 50, 92,#kick_knee,#kick_kick		;19
	JJXM	PUPPET,		 50, 92,#kick_knee,#kick_kick		;20
	JJXM	INAIR2,		 50, 92,#kick_knee,#kick_kick		;21
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
punchkick	;9

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

;- correct sounds?
	WRSND	W_DOINK,GRABHOLD_T1,GRABHOLD_T2
	rets

#cont2
	.ref	dnk_4_knee_fall_anim
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


************

#graboh		;8

	rets

#*****************************************************************************
*
* RUNNING (if GETUP_TIME > 0 then player is out of control)
*

#XRUN_VAL	equ	64000h		;50000h
#XRUN2_VAL	equ	88000h
#ZDRIFT_VAL	equ	28000h		;20000h

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
	.long	#z					;0
	.long	#punch					;1
	.long	#block					;2
	.long	#z					;3
	.long	#super_punch				;4
	.long	#super_punch,#z,#z			;5-7
	.long	#kick					;8
	.long	punchkick,#z,#z,#kick,#z,#z,#z		;9-15
	.long	#super_kick				;16
	.long	#z,#z,#z,#graboh,#z,#z,#z		;17-23
	.long	#kick,#z,#z,#z,#z,#z,#z,#z		;24-31

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
#super_punch	;4
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
	JJXM	PUPPET,		 	#punch_clothesline		;20
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
#graboh
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
	JJXM	PUPPET,		 	#kick_flyingkick		;20
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


	move	*a13(STICK_VAL_CUR),a0
	btst	PLAYER_DOWN_BIT,a0
	jrz	#no_climbdown

	;this is so an attack isn't turned into a climbdown
	; in those 5-10 ticks before MODE_INAIR2 is set...
	move	*a13(ANIBASE),a14,L
	cmpi	dnk_climb_up_anim,a14
	jrne	#no_climbdown

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

	MOVE	*A13(PLYRNUM),A5
	movi	JUMP_ROPES,a2
	MOVI	1000,A0
	calla	ADD_IF_SILENT
	movi	IDIOT_COUNT,a2
	move	a2,*a13(JUMPIN_COUNT)
	rets


;For standing on top of turnbuckles

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
#z
	rets

************
#punch		;1
#punchkick	;1
#block		;2

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

     	movi	dnk_diveofftb_anim,a0
	calla	change_anim1a
	rets

************
#kick		;8
#super_kick	;16

	movi	dnk_4_bstomp_anim,a0		;Buckle
	calla	change_anim1a
	rets

#*****************************************************************************
* blocking

mode_block	;7

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

	FACE24  dnk,push_anim
	calla	change_anim1a

	WRSND	W_DOINK,PUSH_T1,PUSH_T2

	rets

#*****************************************************************************
*

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

	move	*a13(BUT_VAL_DOWN),a0
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
	CALLA	FIND_AND_KILL_ENDLESS
;If stick is toward opponent, then do quick punches
	move	*a13(STICK_VAL_CUR),a0
	move	*a13(NEW_FACING_DIR),a1
	andi	0ch,a1
	cmp	a0,a1
	jrnz	#tag
	movi	dnk_uppercuts_to_head_anim,a0
	calla	change_anim1a
	rets

#tag	movi	dnk_uppercut_to_head_anim,a0
	calla	change_anim1a
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

	movi	dnk_3_pile_driver_anim,a0
	calla	change_anim1a
	rets

#punchkick
#graboh
#kick
	CALLA	FIND_AND_KILL_ENDLESS
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
	movi	dnk_3_knees_to_head_anim,a0
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

	.ref	dnk_3_head_held_stand_anim
	movi	dnk_3_head_held_stand_anim,a0
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
*
 SUBR	mode_inair2	;21

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


#VEL	equ	30000h		;38000h	;30000h
#DVEL	equ	21f0eh		;27978h	;21f0eh


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
;

******************************************************************************
	.end
