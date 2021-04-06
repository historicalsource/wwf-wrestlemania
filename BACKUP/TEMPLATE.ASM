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

	.ref	set_getup_time
	.ref	wres_get_but_val_up,wres_get_but_val_down,wres_get_but_val_cur
	.ref	wres_get_stick_val_cur
	.ref	get_punch_dtime
	.ref	get_rope_x

	.ref	change_anim1,change_anim1a
	.ref	change_anim2,change_anim2a
	.ref	process_ptrs
	.ref	keep_attached
	.ref	get_opp_plyrmode
	.ref	count_hits
	.ref	wres_collis_off
	.ref	convert_facing
	.ref	check_secret_moves
	.ref	change_walk_anim
	.ref	set_rotate_anim
	.ref	execute_walk
	.ref	start_run,bounce_off_ropes
	.ref	inc_burnout

	;from CROWD.ASM
	.ref	crowd_cheer

	;from DCSSOUND.ASM
	.ref	triple_sound

	;from WRESTLE.ASM
	.ref	set_turbo_status
	.ref	calc_line_x
	.ref	face_each_other
	.ref	lineup_grapple
	.ref	break_lockup

******************************************************************************
* ANIMATION SEQUENCES



******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************

bam_secret_moves
	.long	#button_hold	;must have this one

	.long	#turbo_run
	.long	#2nd_wind1
	.long	#2nd_wind2
	.long	0



#button_hold

	move	a13,a0
	calla	wres_get_but_val_up
	btst	PLAYER_PUNCH_BIT,a0
	jrz	#no_punch

	move	*a13(PLYRNUM),a0
	calla	get_punch_dtime
	cmpi	100,a0			;> min?
	jrlt	#no_punch
	cmpi	100+60,a0		;< max?
	jrgt	#no_punch

	callr	scrt_2ndwind
	setc
	rets

#no_punch
	clrc
	rets


;		BITS			MASK


#turbo_run
	.word	B_TURBO,		J_ALL
	.word	B_TURBO,		J_ALL
	.word	8000h | 16		;max
	.long	scrt_run

#2nd_wind1
	.word	J_UP,			J_REAL_LR
	.word	J_UP_AWAY,		J_REAL_LR
	.word	J_AWAY,			J_REAL_LR
	.word	J_DOWN_AWAY,		J_REAL_LR
	.word	J_DOWN,			J_REAL_LR
	.word	J_DOWN_TOWARD,		J_REAL_LR
	.word	J_TOWARD,		J_REAL_LR
	.word	J_UP_TOWARD,		J_REAL_LR
	.word	J_UP,			J_REAL_LR
	.word	8000h | 50 		;max
	.long	scrt_2ndwind

#2nd_wind2
	.word	J_UP,			J_REAL_LR
	.word	J_UP_TOWARD,		J_REAL_LR
	.word	J_TOWARD,		J_REAL_LR
	.word	J_DOWN_TOWARD,		J_REAL_LR
	.word	J_DOWN,			J_REAL_LR
	.word	J_DOWN_AWAY,		J_REAL_LR
	.word	J_AWAY,			J_REAL_LR
	.word	J_UP_AWAY,		J_REAL_LR
	.word	J_UP,			J_REAL_LR
	.word	8000h | 50 		;max
	.long	scrt_2ndwind


scrt_run

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_scrt_run
	move	*a13(PLYRMODE),a0

	move	*a13(PLYRMODE),a0
	cmpi	MODE_RUNNING,a0
	jreq	#no_scrt_run
	cmpi	MODE_BOUNCING,a0
	jreq	#no_scrt_run
	calla	start_run

#no_scrt_run
	rets

scrt_2ndwind
	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_scrt_2ndwind

	movi	dnk_2ndwind_anim,a0
	calla	change_anim1a
#no_scrt_2ndwind
	rets


#*****************************************************************************

 SUBR	bam_ani_init

	movi	bam_stand2_anim,a0
	calla	change_anim1a

	movi	bam_torso2_anim,a0
	calla	change_anim2a

	rets


#*****************************************************************************
*
* DOINKS CONTROL CODE
*
* a13 = * doink process

 SUBR	move_bam


;	movi	100h,a0			;temp fix!
;	move	a0,*a13(ANI_SPEED)

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

#*****************************************************************************

mode_normal


	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_interrupt

 .if 0
	calla	get_opp_plyrmode
	cmpi	MODE_DEAD,a0
	jrne	#opp_not_dead

	movi	bam_raisearm_anim,a0
	calla	change_anim1a
	rets

#opp_not_dead

	GETLIFE
	jruc	#not_dizzy
	jrnz	#not_dizzy

	SETMODE	DIZZY
	movi	dnk_dizzy_anim,a0
	calla	change_anim1a
	rets

 .endif
#not_dizzy

	calla	set_turbo_status

	move	a13,a0
	calla	wres_get_but_val_cur
	btst	PLAYER_BLOCK_BIT,a0	;maybe have to action tables?
	jrz	#nblk			;1 for down transitions
	callr	#block			;& 1 for current buttons
#nblk
	move	a13,a0
	calla	wres_get_but_val_down
	andi	01111b,a0		;mask out turbo button
	sll	5,a0			;x 32
	addi	#action_table,a0
	move	*a0,a0,L
	call	a0

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_interrupt



	move	a13,a0
	calla	wres_get_stick_val_cur
	move	a0,*a13(MOVE_DIR)
	move	a0,a4

	btst	MOVE_UP_BIT,a4		;check if player should climb
	jrz	#not_top		;up the turnbuckle

	move	*a13(INRING),a0
	jrnz	#no_climb

	move	*a13(OBJ_ZPOSINT),a0
	cmpi	RING_TOP,a0
	jrgt	#not_top


	move	*a13(OBJ_XPOSINT),a0
	cmpi	RING_X_CENTER,a0
	jrgt	#right
;#left
	calla	get_rope_x
	move	*a13(OBJ_COLLX1),a1
	cmp	a0,a1			;a1-a0
	jrgt	#no_climb

	movi	MOVE_UP_LEFT,a3		;face top left turnbuckle
	cmp	a3,a4			;Make sure UP/LEFT is pressed
	jreq	#climbit
	jruc	#no_climb

#right
	calla	get_rope_x
	move	*a13(OBJ_COLLX2),a1
	cmp	a0,a1			;a1-a0
	jrlt	#no_climb

	movi	MOVE_UP_RIGHT,a3	;face top right turnbuckle
	cmp	a3,a4			;Make sure UP/RIGHT is pressed
	jrne	#no_climb


#climbit
	move	a3,*a13(NEW_FACING_DIR)
	move	*a13(FACING_DIR),a0
	cmp	a0,a3
	jreq	#climb
	calla	set_rotate_anim

	movi	#climb,a0			;this routine gets executed
	move	a0,*a13(CODE_ADDR),L		;when the rotate anim
	SETMODE	WAITANIM			;finishes
	rets

#climb
	movi	dnk_climb_up_anim,a0
	calla	change_anim1a

	SETMODE	CLIMBTURNBKL

	rets

#not_top
#no_climb

	calla	execute_walk

#no_interrupt
	rets

#action_table
	.long	#zip_action	;0
	.long	#block		;1
	.long	#grab		;2
	.long	#zip_action	;3
	.long	#punch		;4
	.long	#zip_action	;5
	.long	#zip_action	;6
	.long	#zip_action	;7
	.long	#kick		;8
	.long	#zip_action	;9
	.long	#zip_action	;10
	.long	#zip_action	;11
	.long	#zip_action	;12
	.long	#zip_action	;13
	.long	#zip_action	;14
	.long	#zip_action	;15


************
#zip_action	;0


	rets

************
#punch		;1

	rets

************
#block		;2

	rets

************
#kick		;4

	rets

************

#grab		;8

	rets


#*****************************************************************************
*
* RUNNING (if GETUP_TIME > 0 then player is out of control)
*

#XRUN_VAL	equ	60000h		;50000h
#ZDRIFT_VAL	equ	20000h		;18000h

mode_running

	move	*a13(GETUP_TIME),a0		;delay b4 gaining control
	jrz	#not_octrl

	calla	keep_attached			;if still being flung
	jrnz	#out_of_control			;(Z=0 - still attached)

;not_attached

#not_octrl

	calla	bounce_off_ropes

	move	*a13(MOVE_DIR),a0

	movi	#XRUN_VAL,a1
	btst	PLAYER_RIGHT_BIT,a0
	jrnz	#setxvel

	movi	-#XRUN_VAL,a1
#setxvel
	move	a1,*a13(OBJ_XVEL),L


	move	*a13(GETUP_TIME),a0		;delay b4 gaining control
	jrnz	#out_of_control

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_interrupt

	move	a13,a0
	calla	wres_get_but_val_cur
	btst	PLAYER_TURBO_BIT,a0		;turbo down?
	jrnz	#run_down

	;has released turbo - go back to walk mode

	SETMODE	NORMAL

#run_down
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
	andi	01111b,a0		;mask out turbo button
	sll	5,a0			;x 32
	addi	#action_table,a0
	move	*a0,a0,L
	call	a0
#out_of_control
	rets

#action_table
	.long	#zip_action		;0
	.long	#zip_action		;1
	.long	#zip_action		;2
	.long	#zip_action		;3
	.long	#flying_clothesline	;4 punch
	.long	#zip_action		;5
	.long	#zip_action		;6
	.long	#zip_action		;7
	.long	#flying_kick		;8 kick
	.long	#zip_action		;9
	.long	#zip_action		;10
	.long	#zip_action		;11
	.long	#zip_action		;12
	.long	#zip_action		;13
	.long	#zip_action		;14
	.long	#zip_action		;15

************
#zip_action
	rets

************
#flying_clothesline	;1

	rets

************
#flying_kick	;#4

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
#ZROLL_VAL	equ	20000h
#ROLL_SPEED	equ	50h
#ROLL_FRAMES	equ	11

mode_onground	;4

	rets


#*****************************************************************************
*
* bouncing off ropes while running

mode_bouncing	;5

	rets

#*****************************************************************************
*
* STANDING ON TOP OF TURNBUCKLE

mode_onturnbkl	;6

	rets

#*****************************************************************************
* blocking

mode_block	;7
	rets

#*****************************************************************************
* doink with zero health

mode_dizzy	;8

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

	move	*a13(ANIMODE),a0
	btst	MODE_END_BIT,a0
	jrz	#not_ended

	clr	a0
	movi	MODE_NORMAL,a1
	move	a1,*a13(PLYRMODE)

	move	*a13(ATTACH_PROC),a10,L
	jrz	#skp
	move	a1,*a10(PLYRMODE)
	move	a0,*a10(ATTACH_PROC),L
#skp
	move	a0,*a13(ATTACH_PROC),L

#not_ended
	rets


#*****************************************************************************

#VEL	equ	30000h
#DVEL	equ	21f0eh

#VEL2	equ	50000h
#DVEL2	equ	38917h


 SUBR bam_velocity_table

;		X,	Z

	.long	0,	-#VEL	;0 UP
	.long	0,	-#VEL2

	.long	#DVEL,	-#DVEL	;1 UP-RIGHT
	.long	#DVEL2,	-#DVEL2

	.long	#DVEL,	0	;2 RIGHT
	.long	#DVEL2,	0

	.long	#DVEL,	#DVEL	;3 DOWN-RIGHT
	.long	#DVEL2,	#DVEL2

	.long	0,	#VEL	;4 DOWN
	.long	0,	#VEL2

	.long	-#DVEL,	#DVEL	;5 DOWN-LEFT
	.long	-#DVEL2,#DVEL2

	.long	-#DVEL,	0	;6 LEFT
	.long	-#DVEL2,0

	.long	-#DVEL,	-#DVEL	;7 UP-LEFT
	.long	-#DVEL2,-#DVEL2


#*****************************************************************************

 SUBR bam_rotate_anims_table
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
	.long	dnk_stand4_anim		;    = down left
	.long	dnk_6_to_8_turn_anim	;    = up left

; old = up left
	.long	dnk_8_to_2_turn_anim	;new = up right
	.long	dnk_8_to_4_turn_anim	;    = down right ***
	.long	dnk_8_to_6_turn_anim	;    = down left
	.long	dnk_stand2_anim		;    = up left


 SUBR bam_leg_anims_table
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


 SUBR bam_torso_anims_table
; old = up right
	.long	dnk_torso2_anim		;new = up right
	.long	dnk_2_to_4_turn2_anim	;    = down right
	.long	dnk_2_to_8_turn2_anim	;    = down left ***
	.long	dnk_2_to_8_turn2_anim	;    = up left

; old = down right
	.long	dnk_4_to_2_turn2_anim	;new = up right
	.long	dnk_torso4_anim		;    = down right
	.long	dnk_4_to_6_turn2_anim	;    = down left
	.long	dnk_4_to_6_turn2_anim	;    = up left ***

; old = down left
	.long	dnk_6_to_4_turn2_anim	;new = up right ***
	.long	dnk_6_to_4_turn2_anim	;    = down right
	.long	dnk_torso4_anim		;    = down left
	.long	dnk_4_to_2_turn2_anim	;    = up left

; old = up left
	.long	dnk_8_to_2_turn2_anim	;new = up right
	.long	dnk_8_to_2_turn2_anim	;    = down right ***
	.long	dnk_2_to_4_turn2_anim	;    = down left
	.long	dnk_torso2_anim		;    = up left

; *** should not happen

#*****************************************************************************
* BAM BAM HAS JUST BEEN HIT
* a10 = * offensive process
* a13 = * defensive process (DOINK)

 SUBR	bam_hit

	move	*a10(ATTACK_MODE),a0	;type of attack that hit doink
	move	a0,a1
	sll	5,a1			;x 32
	addi	#hit_table,a1
	move	*a1,a1,L		;appropriate routine
	call	a1

	rets

#hit_table
	.long	_punch		;0
	.long	_hdbutt		;1
	.long	_kick		;2
	.long	_flykick	;3
	.long	_grabthrow	;4
	.long	_uprcut		;5
	.long	_lbowdrop	;6
	.long	_grabhold	;7
	.long	_grabfling	;8
	.long	_push		;9
	.long	_hiptoss	;10
	.long	_bigboot	;11
	.long	_knee		;12
	.long	_grapple	;13
	.long	_14		;14
	.long	_15		;15
	.long	_16		;16

#************************
;AMODE_PUNCH	0
_punch

	calla	wres_collis_off
	rets

#************************
;AMODE_HDBUTT	1
_hdbutt

	calla	wres_collis_off
	rets

#************************
;AMODE_KICK	2
_kick

	calla	wres_collis_off
	rets

#************************
;AMODE_FLYKICK	3
_flykick

	calla	wres_collis_off
	rets

#************************
;AMODE_GRABTHROW 4
_grabthrow

	calla	wres_collis_off
	rets

#************************
;AMODE_UPRCUT	5
_uprcut

	calla	wres_collis_off
	rets

#************************
;AMODE_LBOWDROP	6
_lbowdrop

	calla	wres_collis_off
	rets
	
#************************
;AMODE_GRABHOLD	7
_grabhold

	calla	wres_collis_off
	rets

#************************
;AMODE_GRABFLING 8
_grabfling

	calla	wres_collis_off
	rets

#************************
;AMODE_PUSH	9
_push

	calla	wres_collis_off
	rets

#************************
;AMODE_HIPTOSS	10
_hiptoss

	calla	wres_collis_off
	rets

#************************
;AMODE_BIGBOOT	11
_bigboot

	calla	wres_collis_off
	rets

#************************
;AMODE_KNEE	12
_knee

	calla	wres_collis_off
	rets

#************************

_grapple		;13

	calla	wres_collis_off
	rets

#************************

_14		;14
_15		;15
_16		;16


******************************************************************************

	.end
