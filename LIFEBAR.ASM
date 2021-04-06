**************************************************************
*
* Software:	Jason Skiles
* Initiated:	29 Oct 93
*
* COPYRIGHT (C) 1993 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 5/5/95 14:54
**************************************************************

	.file	"lifebar.asm"
	.title	"meters, names, messages, and scores"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"macros.h"
	.include	"mproc.equ"		;Mproc equates
	.include	"display.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"game.equ"
	.include	"plyr.equ"
	.include	"sys.equ"
	.include	"link.equ"
	.include	"sound.h"
	.include	"ring.equ"

	.include	"miscimg.glo"
	.include	"fontsimg.glo"
	.include	"sound.equ"
	.include	"imgtbl.glo"
	.include	"jjxm.h"

	;temp! - 314
	.if DEBUG
	.include	"tmpdebug.h"
	.endif

#*****************************************************************************

	.ref	reset_for_round,init_scroller,BGND_UD1
	.ref	reset_for_round2,no_debris,flash_red
	.ref	calc_match_time_2,ck_any_teammates

	.ref	change_anim1a,triple_sound,HALT,CLOSE_VERT_SCREEN_LINE
	.ref	civanic,CR_STRTP,get_process_ptr,wres_collis_off
	.ref	GET_ADJ,p2winstreak,ANIM_CROWD,update_timer,GAMSTATE
	.ref	fight_debug,RNDRNG0,pal_getf,ring_bell,BEGINOBJ_TBL
	.ref	PSTATUS,match_over,p1rounds,is_8_on_1
	.ref	OPEN_VERT_SCREEN_LINE,process_ptrs,SET_LOWER_VOL
	.ref	GET_CREDITS,BINBCD,get_all_buttons_cur2,LINES_VERT
	.ref	current_round,p1winstreak,CLEAR_SPEECH_REPEAT,p2rounds
	.ref	VINCE_START_ROUND2_3,WHICH_SCREEN,do_game_over
	.ref	CALL_MATCH_OVER,AUD1,setup_back_anim,DUMRETS
	.ref	calc_match_time_1,match_time
	.ref	ROLLING_COUNT,match_winner,PCNT,NUM_OPPS,is_final_match
	.ref	ADD_VOICE,KILL_ALL_CHANNELS,END_MATCH_SPEECH
	.ref	accumulate_awards,annc_rnd_winner_done
	.ref	round_award,royal_rumble,buddy_mode_on
	.ref	match_award,reduce_bog,get_live_bits
	.ref	create_end_rnd_awards
	.ref	award_ok_to_die
	.ref	is_it_a_really_quick_win,increment_wincount
	.ref	give_award_if_opponent_is_human
	.ref	arm_comeback_award
	.ref	check_for_award_for_big_comeback
	.ref	check_for_award_for_winstreak
	.ref	show_dufus_messages
	.ref	CHANGE_SKIRTS2,INIT_SKIRTS
	.ref	pal_clean,round_start_time,round_end_time
	.ref	dboxes_on,do_fireworks
	.ref	instant_combos_on,p1powerup_request
	.ref	show_mk3_tip,MAYBE_HIGH_RISK
	.ref	match_cnt,WGFS_W_P
	.ref	temp_music
	.ref	finish_completed

#*****************************************************************************

;player life/turbo data struct
PLT_LIFE 	equ	0		;UHW	life pixels (164 max)
PLT_CLIFE	equ	PLT_LIFE+10h	;UHW	displayed life (164 max)
PLT_TURBO	equ	PLT_CLIFE+10h	;UHW	turbo val (5400h max)
PLT_COMBO_SIZE	equ	PLT_TURBO+10h	;UHW	combo bar size
PLT_SIZE	equ	PLT_COMBO_SIZE+010h

;NOTE that PLT_SIZE is 40h, so anytime we might otherwise use a multiply,
; we do a X64 instead.  DO NOT change the size of this struct unless
; you're prepared to do some cleanup.

;meter data struct
MD_LINK		equ	0		;UHW	PLYRNUM for this meter
MD_LIFE		equ	MD_LINK+10h	;UHL	life bar *obj
MD_LBAK		equ	MD_LIFE+20h	;UHL	turbo bar *obj
MD_NAME		equ	MD_LBAK+20h	;UHL	name *obj
MD_COMBO	equ	MD_NAME+20h	;UHL	combo bar *obj
MD_SIZE		equ	MD_COMBO+20H


	.bss	life_data,	NUM_WRES*PLT_SIZE
	.bss	meter_data,	2*MD_SIZE
	.bss	damage_imgs,	4*32
	.bss	ram_lst,	32*40		;For announce_match
	BSSX	DAM_MULT,16
	.BSS	LAST_FLIP,16
	BSSX	combo_audit_done,16
	BSSX	message_flag,32*2		;Message already displayed bit
	BSSX	ZFLIP_POS_VAR,32
	BSSX	MUSIC_HAP,16
	BSSX	PERFECT_WINS,16
	BSSX	WINS_OBJ,32*3

	BSSX	fence1,4*32

	BSSX	MESSAGE_FLAGS,32

	BSSX	fence2,4*32

	BSSX	COMBO_FLASH_FLAG,32
	BSSX	in_finish_move,16
	BSSX	speed_adjustment,32		;game speed damage adjustment

	;temp! - 314
	.if DEBUG
	BSSX	event_data,EVENTSIZ*NUM_EVENTS
	BSSX	event_ptr,32
	.endif

#*****************************************************************************
*
* Life/Turbo meter sizes and positions.
*

LIFE_MAX	.equ	163		;green pixels in life bar
TURBO_MAX	.equ	84<<8		;max turbo value

#*****************************************************************************
*
* Called at the beginning of the first round of a match.
*

 SUBR	init_life_data

	;temp! - 314
	.if DEBUG
	movi	event_data,a14
	move	a14,@event_ptr,L

	clr	a14
	movi	event_data,a0
	movi	EVENTSIZ*NUM_EVENTS/16,a1
#clp	move	a14,*a0+,W
	dsj	a1,#clp

	.endif

	;initialize speed_adjustment
	movk	ADJSPEED,a0		;game timer speed (1-5)
	calla	GET_ADJ
	BADCHK	a0,1,5,3		;reg,lo,hi,val
	X32	a0			;x 16 bits
	addi	#timer_table-20h,a0
	move	*a0,a1,L
	move	a1,@speed_adjustment,L

	;initialize life data
	movi	NUM_WRES,a0
	movi	life_data,a1
	movi	LIFE_MAX,a2
	movi	TURBO_MAX,a3
	clr	a4
#init_loop
	move	a2,*a1(PLT_LIFE)
	move	a3,*a1(PLT_TURBO)
	move	a4,*a1(PLT_CLIFE)
	move	a4,*a1(PLT_COMBO_SIZE)
	addi	PLT_SIZE,a1
	dsj	a0,#init_loop

	rets

#timer_table
	.long		10000h*4/5	;80% damage (slowest)
	.long		10000h*9/10	;90%
	.long		10000h*1	;normal damage (default)
	.long		10000h*11/10	;110%
	.long		10000h*6/5	;120% damage (fastest)

#*****************************************************************************
*
* Resets life/turbo/combo data for wrestler in a13.  Used by change_wrestler.
* Updates name display too, if either display is aimed at our guy.
*
* Since this only happens for dead guys, we don't check to see if it's a
* player, and we don't check special royal rumble mode cases.
*

 SUBR	init_wres_life_data

	;initialize life data
	move	*a13(PLYRNUM),a1
	X64	a1		;mult by PLT_SIZE
	addi	life_data,a1

	movi	LIFE_MAX,a2
	movi	TURBO_MAX,a3
	clr	a4
	move	a2,*a1(PLT_LIFE)
	move	a3,*a1(PLT_TURBO)
	move	a2,*a1(PLT_CLIFE)
	move	a4,*a1(PLT_COMBO_SIZE)

	;check names
	move	*a13(PLYRNUM),a1
	movi	meter_data,a5
	move	*a5(MD_LINK),a14
	cmp	a1,a14
	jreq	#chgnm
	addi	MD_SIZE,a5
	move	*a5(MD_LINK),a14
	cmp	a1,a14
	jrne	#done

#chgnm	X32	a1
	addi	name_tbl,a1
	move	*a1,a0,L
	move	*a5(MD_NAME),a8,L
	calla	civanic

#done	rets

#*****************************************************************************
*
* Called at the start of the second and later rounds of a match.
*

 SUBR	init_rnd_life_data

	;reset life data
	movi	NUM_WRES,a0
	movi	life_data,a1
	movi	LIFE_MAX,a2
#init_loop
	move	a2,*a1(PLT_LIFE)
	move	a2,*a1(PLT_CLIFE)
	addi	PLT_SIZE,a1
	dsj	a0,#init_loop

	;set lifebar pals.
	movi	FYL2RD_P,a0
	calla	pal_getf

	movi	meter_data,a1
	move	@p2rounds,a14
	jrz	#ok1

	;set left lifebar red
	move	*a1(MD_LIFE),a8,L
	move	a0,*a8(OPAL)

#ok1	addi	MD_SIZE,a1
	move	@p1rounds,a14
	jrz	#ok2

	;set right lifebar red
	move	*a1(MD_LIFE),a8,L
	move	a0,*a8(OPAL)

#ok2	rets


#*****************************************************************************
*
* >a8 = PLYRNUM for left meter
* >a9 = PLYRNUM for right meter

P1CNTR	.equ	PDATA
P2CNTR	.equ	PDATA+16
P1STATE	.equ	PDATA+32
P2STATE	.equ	PDATA+48

 SUBR	meters

	PUSH	a8,a9

 	;Start the credits message
	calla	start_credbox

	;initialize meter data
	movi	meter_data,a1
	TBL_OBJ	lhlth1
	move	a8,*a1(MD_LIFE),L

	TBL_OBJ	lname
	move	a8,*a1(MD_NAME),L

	TBL_OBJ	lframec
	move	a8,*a1(MD_LBAK),L

	TBL_OBJ	lcombo
	move	a8,*a1(MD_COMBO),L

	addi	MD_SIZE,a1

	TBL_OBJ	rhlth1
	move	a8,*a1(MD_LIFE),L

	TBL_OBJ	rname
	move	a8,*a1(MD_NAME),L

	TBL_OBJ	rframec
	move	a8,*a1(MD_LBAK),L

	TBL_OBJ	rcombo
	move	a8,*a1(MD_COMBO),L

	;create the static (no-handle) objects
	TBL_OBJ	lframe
	TBL_OBJ	lframeb

	TBL_OBJ	rframe
	TBL_OBJ	rframeb

	callr	do_win_streaks

	PULL	a8,a9

	;wire up the meters
	clr	a0
	move	a8,a1
	callr	rewire_meter
	movk	1,a0
	move	a9,a1
	callr	rewire_meter

	CREATE	ANNC_PID,announce_match

	movk	1,a0
	move	a0,*a13(P1CNTR)
	move	a0,*a13(P2CNTR)
	clr	a0
	move	a0,*a13(P1STATE)
	move	a0,*a13(P2STATE)

#main_loop
;Update all the life data
	clr	a0

#maint_loop
	MOVE	@WHICH_SCREEN,A1,L
	CMPI	DUMRETS,A1
	JRNE	JUST_DISPLAY_THEM
	callr	inc_life
	inc	a0
	cmpi	NUM_WRES,a0
	jrne	#maint_loop

JUST_DISPLAY_THEM
;Update the meters
	clr	a0
	callr	update_meter
	movk	1,a0
	callr	update_meter

;Blink CPU controlled name with insert coins/press start
	movi	meter_data,a1
	move	@PSTATUS,a0
	btst	0,a0
	jrnz	#p2
;Plyr 1 is drone
	move	*a13(P1CNTR),a0
	dec	a0
	move	a0,*a13(P1CNTR)
	jrnz	#p2
	move	*a13(P1STATE),a0
	xori	1,a0	
	move	a0,*a13(P1STATE)
	jrz	#doname

;Do correct coin message

	movi	TSEC,a0			;one second of PRESS/INSERT...
	move	@NUM_OPPS,a14		;(two if one-on-one mode)
	dec	a14
	jrnz	#tset1a
	sla	1,a0
#tset1a	move	a0,*a13(P1CNTR)

	move	*a1(MD_NAME),a8,L
	movi	WF_START,a0
;Display the insert coin/press start message
	calla	CR_STRTP
	jrhs	#enough_money
	movi	WF_INSERT,a0
#enough_money
	calla	civanic
	jruc	#p2
#doname	
	movi	TSEC*4,a0		;and four seconds of names
	move	@NUM_OPPS,a14		;(two if one-on-one mode)
	dec	a14
	jrnz	#tset1b
	sra	1,a0
#tset1b	move	a0,*a13(P1CNTR)

	move	*a1(MD_LINK),a0
	X32	a0
	addi	process_ptrs,a0
	move	*a0,a0,L
	move	*a0(WRESTLERNUM),a0

	X32	a0
	addi	name_tbl,a0
	move	*a0,a0,L
;Change the name
	move	*a1(MD_NAME),a8,L
	calla	civanic
#p2
	movi	meter_data,a1
	addi	MD_SIZE,a1
	move	@PSTATUS,a0
	btst	1,a0
	jrnz	#ok

;Plyr 2 is drone
	move	*a13(P2CNTR),a0
	dec	a0
	move	a0,*a13(P2CNTR)
	jrnz	#ok
	move	*a13(P2STATE),a0
	xori	1,a0	
	move	a0,*a13(P2STATE)
	jrz	#doname2

;Do correct coin message

	movi	TSEC,a0			;one second of PRESS/INSERT...
	move	@NUM_OPPS,a14		;(two if one-on-one mode)
	dec	a14
	jrnz	#tsetsa
	sla	1,a0
#tsetsa	move	a0,*a13(P1CNTR)

	move	*a1(MD_NAME),a8,L
	movi	WF_START,a0
;Display the insert coin/press start message
	calla	CR_STRTP
	jrhs	#enough_money
	movi	WF_INSERT,a0
#enough_money2
	calla	civanic
	jruc	#ok
#doname2
	movi	TSEC*4,a0		;and four seconds of names
	move	@NUM_OPPS,a14		;(two if one-on-one mode)
	dec	a14
	jrnz	#tset2b
	sra	1,a0
#tset2b	move	a0,*a13(P1CNTR)

	move	*a1(MD_LINK),a0
	X32	a0
	addi	process_ptrs,a0
	move	*a0,a0,L
	move	*a0(WRESTLERNUM),a0

	X32	a0
	addi	name_tbl,a0
	move	*a0,a0,L
;Change the name
	move	*a1(MD_NAME),a8,L
	calla	civanic

#ok
	SLEEPK	1
	jruc	#main_loop

#********
*
* Meter objects and their positions
*


lbar_x		.equ	11
rbar_x		.equ	390

lcombo_x    	.equ	181-45
rcombo_x    	.equ	220+45

lname_x		.equ	97
rname_x		.equ	303

bar_y		.equ	20
combo_y		.equ	bar_y+18

name_y		.equ	13

bak_z		.equ	200
bar_z		.equ	202
frame_z		.equ	201
name_z		.equ	203


lcombo	.word	lcombo_x,combo_y,name_z			;X, Y, Z
	.long	SUPER_0
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT|SUBMFRAME		;OID
	.long	0,0					;XVEL, YVEL
	.even

rcombo	.word	rcombo_x,combo_y,name_z			;X, Y, Z
	.long	SUPER_0
	.word	DMAWNZ|M_FLIPH|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT|SUBMFRAME		;OID
	.long	0,0					;XVEL, YVEL
	.even

lframe	.word	lbar_x,bar_y,frame_z			;X, Y, Z
	.long	PWREMPTY
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT|SUBMFRAME		;OID
	.long	0,0					;XVEL, YVEL
	.even


rframe	.word	rbar_x,bar_y,frame_z			;X, Y, Z
	.long	PWREMPTY
	.word	DMAWNZ|M_3D|M_SCRNREL|M_FLIPH		;CTRL
	.word	CLSNEUT|TYPNEUT|SUBMFRAME		;OID
	.long	0,0					;XVEL, YVEL
	.even


lframeb	.word	lbar_x,bar_y,frame_z			;X, Y, Z
	.long	LBAR_GENB				;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT|SUBMFRAME		;OID
	.long	0,0					;XVEL, YVEL
	.even

rframeb	.word	rbar_x,bar_y,frame_z			;X, Y, Z
	.long	RBAR_GENB				;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL|M_FLIPH		;CTRL
	.word	CLSNEUT|TYPNEUT|SUBMFRAME		;OID
	.long	0,0					;XVEL, YVEL
	.even


lframec	.word	lbar_x,bar_y,bak_z			;X, Y, Z
	.long	LBAR_GENC				;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT|SUBMFRAME		;OID
	.long	0,0					;XVEL, YVEL
	.even

rframec	.word	rbar_x,bar_y,bak_z			;X, Y, Z
	.long	LBAR_GENC				;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL|M_FLIPH		;CTRL
	.word	CLSNEUT|TYPNEUT|SUBMFRAME		;OID
	.long	0,0					;XVEL, YVEL
	.even

lwin	.word	11,22h,name_z			;X, Y, Z
	.long	BWINBOX					;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL		;CTRL
	.word	CLSNEUT|TYPNEUT|SUBMFRAME		;OID
	.long	0,0					;XVEL, YVEL
	.even

rwin	.word	391,22h,name_z			;X, Y, Z
	.long	RWINBOX					;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT|SUBMFRAME		;OID
	.long	0,0					;XVEL, YVEL
	.even


lhlth1	.word	lbar_x,bar_y,bar_z			;X, Y, Z
	.long	FGRN2YEL
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT|SUBLBAR			;OID
	.long	0,0					;XVEL, YVEL
	.even

rhlth1	.word	rbar_x,bar_y,bar_z			;X, Y, Z
	.long	FGRN2YEL
	.word	DMAWNZ|M_3D|M_SCRNREL|M_FLIPH		;CTRL
	.word	CLSNEUT|TYPNEUT|SUBLBAR			;OID
	.long	0,0					;XVEL, YVEL
	.even

*
* name data
*

lname	.word	lname_x,name_y,name_z			;X, Y, Z
	.long	NAM_BRT					;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT|SUBLBAR			;OID
	.long	0,0					;XVEL, YVEL
	.even

rname	.word	rname_x,name_y,name_z			;X, Y, Z
	.long	NAM_RZR					;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT|SUBLBAR			;OID
	.long	0,0					;XVEL, YVEL
	.even

***************************************

 SUBRP	replace_wins
	move	@match_winner,a1
	MOVE	@PSTATUS,A0
	AND	A1,A0
	JRZ	#EXIT

	move	@WINS_OBJ,A0,L
	JRZ	NO_WINS_1
	CALLA	DELOBJ
NO_WINS_1
	move	@WINS_OBJ+020H,A0,L
	JRZ	NO_WINS_2
	CALLA	DELOBJ
NO_WINS_2
	move	@WINS_OBJ+040H,A0,L
	JRZ	NO_WINS_3
	CALLA	DELOBJ
NO_WINS_3
	move	@match_winner,a1
	dec	a1
	jrnz	do_player_2_wins
	move	@p1winstreak,a0
	push	a10
	callr	streak_1
	pull	a10
#EXIT
	rets

do_player_2_wins
	move	@p2winstreak,a0
	push	a10
	callr	streak_2
	pull	a10
	rets


***************************************

FLASH_COMBO

	MOVI	COMBO_P,A0
	CALLA	pal_getf
	MOVE	A0,*A8(OPAL)
	MOVE	*A8(OCTRL),A1
	ANDNI	M_FLIPH,A1
	MOVE	A1,*A8(OCTRL)
DO_COMBO_FLASH_AGAIN
	MOVI	COMBO_FLASH_ANIM,A1
	calla	setup_back_anim
	JSRP	ANIM_CROWD
	SLEEPK	20
	JRUC	DO_COMBO_FLASH_AGAIN

DO_COMBO_SOUND
	SLEEPK	25
	MOVI	3,A0
	CALLA	triple_sound
	DIE

CANI_END		equ	2 + 8000H

COMBO_FLASH_ANIM
	WL	2,COMBO_01
	WL	2,COMBO_02
	WL	2,COMBO_03
	WL	2,COMBO_04
	WL	2,COMBO_05
	WL	2,COMBO_06
	WL	2,COMBO_07
	WL	2,COMBO_08
	WL	2,COMBO_09
	WL	2,COMBO_10
	.WORD	CANI_END

 SUBRP	flash_2ndwind
	MOVE	*A8(OCTRL),A1
	ANDNI	M_FLIPH,A1
	MOVE	A1,*A8(OCTRL)
	movk	3,a9
#flsh	PUSHP	a9
	movi	wind_anim,a1
	calla	setup_back_anim
	JSRP	ANIM_CROWD

	SLEEPK	2

	PULLP	a9
	dsj	a9,#flsh

	DIE

wind_anim
	WL	2,SECWND01
	WL	2,SECWND02
	WL	2,SECWND03
	WL	2,SECWND04
	WL	2,SECWND05
	WL	2,SECWND06
	WL	2,SECWND07
	WL	2,SECWND08
	WL	2,SECWND09
	.WORD	CANI_END

******************************************************************************

 SUBR	CHECK_COMBO_GO
	move	*a8(PLYRNUM),a1

	;if we're in royal rumble, change a 1 to a zero.
	move	@royal_rumble,a14
	jrz	#norum0
	cmpi	1,a1
	jrne	#norum0
	clr	a1
#norum0

	X64	a1		;x by PLT_SIZE
	addi	life_data,a1
	MOVE	*A1(PLT_COMBO_SIZE),a14
;	MOVE	@BONUS_POWER,A1
;	cmp	A1,a14
	move	@instant_combos_on,a1
	jrnz	#auto_combos			; Auto combos on
	movk	16,a1				; Normal combo check
	jruc	#combo_check
#auto_combos
	clr	a1
#combo_check
	cmp	a1,a14
	rets

******************************************************************************

;A7 = BIT TO SET IN PLAYER HISTORY
;A5 = FIRST TIME FOR MOVE
;A6 = MOVE REPEAT

 SUBR	ADD_TO_COMBO_COUNT

;Adds first value each time! [why?]
	MOVE	A7,A2
	movk	1,a5
	movk	1,a3
	MOVE	*a13(COMBO_START),A1
	AND 	A1,A2
	JRNZ	ALREADY_ADDED_ONCE
	MOVE	A5,A3
	MOVE	*a13(COMBO_START),A1
	OR	A7,A1
	MOVE	A1,*A13(COMBO_START)
ALREADY_ADDED_ONCE

	;HACK ALERT:  In royal rumble mode, each player individually tracks
	; which moves he's done and so on, but both share a single combo
	; meter.  Halve the amount to add and give it to player 0 if we're
	; in royal rumble mode and a13 is player 1.

	PUSH	a13
	move	@royal_rumble,a14
	jrz	#norum

	move	*a13(PLYRNUM),a14
	cmpi	1,a14
	jrgt	#norum

	;royal rumble and a13 is a human.  make it the first one.
	clr	a1
	calla	get_process_ptr
	move	a0,a13
#norum

	;WARNING:  a13 isn't neccesarily valid in here! (see above)
	move	*a13(PLYR_SIDE),a1
	move	*a13(PLYRNUM),a11

	PULL	a13
	;OKAY: a13 is safe again.

	movi	MD_SIZE,a9
	mpyu	a1,a9
	addi	meter_data,a9
	MOVE	*A9(MD_COMBO),A8,L
	move	a11,a5
	X64	a5		;x by PLT_SIZE
	ADDI	life_data,A5
	MOVE	*A5(PLT_COMBO_SIZE),A2
	ADD	A3,A2
	MOVE	A2,*A5(PLT_COMBO_SIZE)
	move	@instant_combos_on,a6
	jrz	#norm_combos
	clr	a6
	jruc	#do_check
#norm_combos
	movk	16,a6
#do_check
	cmp	a6,a2
	JRGE	SET_FLASHING_COMBO_GOING
	SLL	5,A2
	ADDI	WHICH_SIZE_BAR,A2
	MOVE	*A2,A0,L
	move	*a0(IANIOFF),*A8(ODOFF),L
	move	*a0(ISAG),*a8(OSAG),L

	RETS

 SUBR	SET_FLASHING

	move	a10,a0
	sll	5,a0
	addi	process_ptrs,a0
	move	*a0,a0,L
	move	*a0(PLYR_SIDE),a1
	movi	MD_SIZE,a9
	mpyu	a1,a9
	addi	meter_data,a9
	MOVE	*A9(MD_COMBO),A8,L

SET_FLASHING_COMBO_GOING
;a1=plyr side
	move	a1,a0
	SLL	4,a0
	ADDI	COMBO_FLASH_FLAG,a0
	MOVE	*a0,a0
	JRNZ	COMBO_ALREADY_STARTED

	MOVE	A1,A7
	SLL	4,A7
	ADDI	COMBO_FLASH_FLAG,A7
	MOVK	1,A0
	MOVE	A0,*A7
	ADDI	FLASH_COMBO_PID,A1
	MOVI	FLASH_COMBO,A7
	CALLA	GETPRC
	CREATE	SOUND_PID,DO_COMBO_SOUND
COMBO_ALREADY_STARTED
	RETS

WHICH_SIZE_BAR
	.LONG	SUPER_0
	.LONG	SUPER_1
	.LONG	SUPER_2
	.LONG	SUPER_3
	.LONG	SUPER_4
	.LONG	SUPER_5
	.LONG	SUPER_6
	.LONG	SUPER_7
	.LONG	SUPER_8
	.LONG	SUPER_9
	.LONG	SUPER_10
	.LONG	SUPER_11
	.LONG	SUPER_12
	.LONG	SUPER_13
	.LONG	SUPER_14
	.LONG	SUPER_15
	.LONG	SUPER_16

#*****************
*
* Use in a 1-player game when there are multiple drones on the other team.
* This process keeps the other lifebar/name/combo meter display up-to-date.
* It won't do a rewire within #LATENCY ticks of the last rewire unless the
* currently displayed wrestler is dead.
*

	.bss	#LAST_REWIRE,32
#LATENCY	.equ	TSEC/2

 SUBR	rewire_monitor

	move	@buddy_mode_on,a14
	jrnz	#buddy
	move	@royal_rumble,a14
	jrnz	#rumble

	;quit if we're a two-player game
	move	@PSTATUS,a14
	cmpi	3,a14
	jreq	#die

	;quit if we're a 1v1 game
	move	@NUM_OPPS,a14
	cmpi	1,a14
	jreq	#die

	;okay, we should run.  figure out which PLYRNUM to key on.  Choose
	; the first active process, since that'll either be the only human
	; or the lone attract mode drone.  (Even if we do decide to show
	; 2v2 battles in attract mode, nobody dies so it's okay to always
	; key on the first drone.)
	;NOTE: The reason we store the PLYRNUM to key on instead of the
	; process pointer is that if we allow 2v2 mode and the human can
	; switch control from one drone to the next, we can't count on
	; PLYRNUM's and process ptrs always matching up!

#run	movi	NUM_WRES,a0
	movi	process_ptrs,a1
#lp0	move	*a1+,a2,L
	jrnz	#found
	dsj	a0,#lp0

	;Hey!  No active processes!  Bitch, then quit.
	.if DEBUG
	LOCKUP
	.endif

#die	DIE

#found	move	*a2(PLYRNUM),a10	;key plyrnum
	move	*a2(CLOSEST_NUM),a11	;previous closest (current disp.)

#loop	move	a10,a1
	calla	get_process_ptr
	move	a0,a6			;key process (recomputed every wake)
	move	*a6(CLOSEST_NUM),a1
	cmp	a11,a1
	jreq	#no

	;closest has changed.  only rewire if PCNT >= @#LAST_REWIRE+#LATENCY,
	; or if the old guy is dead.
	move	a11,a1			;old guy...
	calla	get_process_ptr
	move	*a0(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#rewire			;dead?

	move	@PCNT,a0,L
	move	@#LAST_REWIRE,a1,L
	addi	#LATENCY,a1
	cmp	a1,a0
	jrle	#no			;enough time since last chg?

#rewire	move	*a6(CLOSEST_NUM),a1
	calla	get_process_ptr
	move	a0,a7			;new closest proc
	move	*a7(PLYR_SIDE),a0	;side to display
	move	*a7(PLYRNUM),a1		;PLYRNUM to display
	callr	rewire_meter
	move	@PCNT,a14,L
	move	a14,@#LAST_REWIRE,L
	move	*a6(CLOSEST_NUM),a11
#no	SLOOP	10,#loop


****


#rumble	;royal rumble.  Never rewire the left meter.  Toggle the right
	; meter every four seconds between plyrnums 2 and 3.  Don't
	; toggle to or stay on a dead guy.

	movk	3,a9		;pretend we're on PLYRNUM 3...
	jruc	#toggle		;...so that we can just toggle to initialize.

#rloop	;see if we're displaying a dead guy.
	move	a9,a1
	calla	get_process_ptr
	move	*a0(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#toggle

	;still alive.  time to toggle anyway?
	dec	a8
	jrle	#toggle

	;not time yet.
	SLOOP	10,#rloop

#toggle	move	a9,a1

	;is THIS guy dead?
	xori	1,a1		;toggle between 2 and 3
	calla	get_process_ptr
	move	*a0(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#notogl		;new guy is dead.  skip it.

	move	a1,a9
	movk	1,a0
	callr	rewire_meter

	movk	TSEC*4/10,a8
#notogl	SLOOP	10,#rloop


****


#buddy	;buddy mode.  This one is easy:  Show the human, unless he's dead
	; and his drone teammate is alive.  Don't assume, once the human
	; is dead, that he'll stay that way.  Buckoffs and all.

	clr	a8		;displayed player on team 0
	movk	1,a9		;displayed player on team 1

#bloop	clr	a1
	calla	get_process_ptr
	move	*a0(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jrne	#p1liv

#p1ded	;plyr 1 is dead--check his drone.
	movk	2,a1
	calla	get_process_ptr
	move	*a0(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#p1liv		;show the human anyway

	;p1 is dead and his drone is alive.  show the drone.
	cmpi	2,a8
	jreq	#ckp2		;already showing the drone.  skip it.

	clr	a0
	movk	2,a1
	move	a1,a8
	callr	rewire_meter
	jruc	#ckp2

#p1liv	;plyr 1 is alive (or his drone is dead). show him.

	TEST	a8
	jrz	#ckp2		;already showing the human.  skip it.

	clr	a0
	clr	a1
	move	a1,a8
	callr	rewire_meter

#ckp2	movk	1,a1
	calla	get_process_ptr
	move	*a0(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jrne	#p2liv

#p2ded	;plyr 2 is dead--check his drone.
	movk	3,a1
	calla	get_process_ptr
	move	*a0(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#p2liv		;show the human anyway

	;p2 is dead and his drone is alive.  show the drone.
	cmpi	3,a9
	jreq	#bnap		;already showing the drone.  skip it.

	movk	1,a0
	movk	3,a1
	move	a1,a9
	callr	rewire_meter
	jruc	#bnap

#p2liv	;plyr 2 is alive (or his drone is dead). show him.

	cmpi	1,a9
	jrz	#bnap		;already showing the human.  skip it.

	movk	1,a0
	movk	1,a1
	move	a1,a9
	callr	rewire_meter

#bnap	SLOOP	10,#bloop


#*****************************************************************************
* 'rewires' a meter display for a different wrestler
* >a0 = display(0 or 1), >a1= playernum (0 to NUM_WRES-1)

 SUBR	rewire_meter

	PUSH	a2,a3,a4,a5,a6,a7,a8,a9,a10,a11

	;set the pointers
	;point a5 at the MD_???? block for the display
	movi	MD_SIZE,a5
	mpyu	a0,a5
	addi	meter_data,a5

	;point a6 at the PLT_???? block for PLYRNUM
	move	a1,a3
	X64	a3		;x by PLT_SIZE
	movi	life_data,a6
	add	a3,a6

	;set MD_LINK
	move	a1,*a5(MD_LINK)

	;point a7 at PLYRNUM's process
	move	a1,a7
	X32	a7
	addi	process_ptrs,a7
	move	*a7,a7,L

	;change the combo bar
	PUSH	A0
	MOVE	*A6(PLT_COMBO_SIZE),A2
;	MOVE	@BONUS_POWER,A14
;	CMP	A14,A2
	move	@instant_combos_on,a14
	jrz	#norm_combos
	clr	a14
	jruc	#do_check
#norm_combos
	movk	16,a14
#do_check
	cmp	a14,a2
;	CMPI	16,A2
	JRGE	WE_ARE_IN_COMBO_MODE
	
	MOVE	A0,A1
	SLL	4,A1
	ADDI	COMBO_FLASH_FLAG,A1
	MOVE	*A1,A8
	JRZ	NO_NEED_TO_KILL_COMBO_PROC
	CLR	A8
	MOVE	A8,*A1
	ADDI 	FLASH_COMBO_PID,A0
	MOVI	-1,A1
	CALLA	KILALL
NO_NEED_TO_KILL_COMBO_PROC
	PULL	A0
	MOVE	*A5(MD_COMBO),A8,L
	CLR	A14
	MOVE	A0,A0
	JRZ	NO_NEED_TO_SET_XFLIP
	MOVI	M_FLIPH,A14
NO_NEED_TO_SET_XFLIP
	MOVI	SUPER_P,A0
	CALLA	pal_getf
	MOVE	A0,*A8(OPAL)

	MOVE	*A6(PLT_COMBO_SIZE),A0
	SLL	5,A0
	ADDI	WHICH_SIZE_BAR,A0
	MOVE	*A0,A0,L

	MOVE	*A0(ICTRL),A1
	OR	A14,A1
	ORI	8000H|DMAWNZ,A1
	MOVE	A1,*A8(OCTRL)
	move	*a0(IANIOFF),*A8(ODOFF),L
	move	*a0(ISAG),*a8(OSAG),L
	move	*a0(0),*a8(OSIZE),L
	JRUC	JUMP_BACK_IN

WE_ARE_IN_COMBO_MODE
;IS THIS NECESSARY!
	SLL	4,A0
	ADDI	COMBO_FLASH_FLAG,A0
	MOVE	*A0,A1

	JRNZ	WE_ARE_ON_RIGHT_SETTING
	MOVK	1,A1
	MOVE	A1,*A0

	PULL	A1
	PUSH	A1
	ADDI	FLASH_COMBO_PID,A1
	PUSH	A7
	MOVI	FLASH_COMBO,A7
	MOVE	*A5(MD_COMBO),A8,L
	CALLA	GETPRC
	PULL	A7

WE_ARE_ON_RIGHT_SETTING
	PULL	A0

JUMP_BACK_IN
	;change the name
	move	*a5(MD_NAME),a8,L
	move	*a7(WRESTLERNUM),a1

	move	@royal_rumble,a14
	jrz	#uname

	move	*a7(PLYRNUM),a14
	jrz	#buddy0
	cmpi	1,a14
	jrgt	#uname
	.if DEBUG
	LOCKUP		;rewire to PLYRNUM 1 in buddy mode!?
	.endif
#buddy0	;It's a royal rumble.  Create the pair of names to go with the slash.
	; This code only executes once for the left meters in rumble mode.

	.ref	index1,index2

	PUSH	a8

	TBL_OBJ	lname
	move	@index1,a0
	X32	a0
	addi	shortname_tbl,a0
	move	*a0,a0,L
	calla	civanic

	move	*a8(OXPOS),a1
	subk	8,a1
	move	*a0(ISIZEX),a14
	sub	a14,a1
	move	*a0(IANIOFFX),a14
	add	a14,a1
	move	a1,*a8(OXPOS)

	TBL_OBJ	lname
	move	@index2,a0
	X32	a0
	addi	shortname_tbl,a0
	move	*a0,a0,L
	calla	civanic

	move	*a8(OXPOS),a1
	addk	8,a1
	move	*a0(ISIZEX),a14
	add	a14,a1
	move	*a0(IANIOFFX),a14
	sub	a14,a1
	move	a1,*a8(OXPOS)
	
	movk	10,a1

	PULL	a8

#uname	X32	a1
	addi	name_tbl,a1
	move	*a1,a0,L
	calla	civanic

#rets	PULL	a2,a3,a4,a5,a6,a7,a8,a9,a10,a11

	rets

name_tbl
	.long	NAM_BRT,NAM_RZR,NAM_UND,NAM_YOK,NAM_SHN
	.long	NAM_BAM,NAM_DNK,NAM_DNK,NAM_LEX,NAM_LEX
	.long	WSF10SLSx

shortname_tbl
	.long	SHORTHRT,SHORTRZR,SHORTUND,SHORTYOK,SHORTSHN
	.long	SHORTBAM,SHORTDNK,SHORTDNK,SHORTLEX,SHORTLEX

#*****************************************************************************
* Updates (resizes) the bars on a meter display.
* >a0 = meter (0 or 1)

 SUBRP	update_meter

	;aim a1 at the MD struct
	movi	MD_SIZE,a1
	mpyu	a0,a1
	addi	meter_data,a1

	;aim a3 at the PLT struct
	move	*a1(MD_LINK),a2
	move	a2,a3
	X64	a3		;x by PLT_SIZE
	addi	life_data,a3

	;set the life bar
	move	*a1(MD_LIFE),a8,L
	move	*a3(PLT_CLIFE),a14
	neg	a14
	addi	LIFE_MAX,a14		;a14 is pixels to hide

	move	a14,*a8(OFSET)
	JRZ	#NOT_TO_WORRY

	cmpi	2,a2
	jrge	we_are_a_drone_ignore
	move	a2,a6
	X32	a6
	addi	process_ptrs,a6
	move	*a6,a6,L
	move	*a6(OUTSIDE_ALONE),a1
	jrz	we_are_a_drone_ignore

	move	@ROLLING_COUNT,A0
	sll	31,a0
	jrnz	ignore_it

	move	*a8(OFLAGS),a1
	xori	M_NODISP,A1
	move	a1,*a8(OFLAGS)
ignore_it
	rets

we_are_a_drone_ignore
	MOVE	@WHICH_SCREEN,A1,L
	CMPI	DUMRETS,A1
	JREQ	#NOT_TO_WORRY
	MOVE	*A8(OFLAGS),A1
	ORI	M_NODISP,A1
	MOVE	A1,*A8(OFLAGS)
	RETS

#NOT_TO_WORRY
	MOVE	*A8(OFLAGS),A1
	ANDI	0FFFFH-M_NODISP,A1
	MOVE	A1,*A8(OFLAGS)
	RETS


;	movi	5,a7
;	mpyu	a14,a7
;	move	*a8(OIMG),a14,L
;	move	*a14(ISAG),a14,L
;	add	a14,a7
;	move	a7,*a8(OSAG),L

	rets

#*****************************************************************************
* Returns the remaining health for a player
* >a1 = PLYRNUM
* <a0 = life (also returns Z bit based on life remaining)


 SUBR	get_health
	PUSH	a1
	X64	a1		;x by PLT_SIZE
	addi	life_data,a1
	move	*a1(PLT_LIFE),a0
	PULL	a1
	TEST	a0		;return Z on remaining life
	rets


#*****************************************************************************
*
* Adjusts a player's health total
* >a0 = amount to add to player's health total
* >a1 = PLYRNUM
* >a10= attacker's process ptr
*
* Returns carry bit set if we're dead at the end of this, even if we
* were dead when the function was called.  Returns carry clear if we're
* alive afterwards.
*
* HACK ALERT:  In royal rumble mode, the two human players share a lifebar.
*  This is implemented by halving all damage done to human players, and
*  then redirecting any damage done to player 1 to player 0 instead.
*  So right away we save the actual PLYRNUM, then change from 1 to 0 in
*  royal rumble mode.  When it comes time to animate, we restore the
*  original.
*

	.bss	#actual_plyrnum,16

	;reg use:
	; a3 = adjusted health
	; a4 = current health
	; a5 = player life meter pointer
	;a13 = our process pointer

 SUBR	adjust_health

	PUSH	a1,a3,a4,a5,a8,a10,a13

	;save the original PLYRNUM
	move	a1,@#actual_plyrnum

	;if we're in royal rumble mode and PLYRNUM is 1, make it zero.
	move	@royal_rumble,a14
	jrz	#pnumok
	cmpi	1,a1
	jrne	#pnumok
	clr	a1
#pnumok

****	;get process pointer
	move	a1,a13
	X32	a13
	addi	process_ptrs,a13
	move	*a13,a13,L

****	;get the meter struct pointer
	move	a1,a5
	X64	a5		;x by PLT_SIZE
	addi	life_data,a5

****	;get health
	move	*a5(PLT_LIFE),a4
	
****	;skip the whole routine if we're dead and taking damage
	TEST	a0
	jrnn	#x0		;not taking damage
	move	*a13(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#already_dead
#x0

****	;skip multiplier if we're getting life back.
	TEST	a0
	jrnn	#no_multiplier

****	;make sure a10 is valid
	move	*a13(WHOHITME),a14,L
	jrz	#no_valid_attacker	;must have this.  WHOHITME is init'd
	cmp	a14,a10			; to 0, and will thus match a cleared
	jrne	#no_valid_attacker	; a10, with unpredictable results.


****	;teammates do 1 pixel damage to each other
	move	*a10(PLYR_SIDE),a3
	move	*a13(PLYR_SIDE),a14
	xor	a3,a14
	jrnz	#norum1

	;in 8-on-1, do half dmg to teammates instead of 1 pixel
	calla	is_8_on_1
	jrnc	#do_1
	sra	1,a0
	jruc	#norum1

#do_1	movi	-1,a0
#norum1

****	;doing a combo?
	move	*a10(COMBO_COUNT),a14
	jrz	DO_NORMAL_ADJUST_CHECK
	move	a14,a0

	;it's a combo.  Clean DAM_MULT and adjust the damage:
	; 0 < hit# < 12:	damage = 15 - hit#
	;     hit# > 11:	damage = 4

	clr	a14
	move	a14,@DAM_MULT

;	subk	12,a0
;	subk	11,a0
	subk	10,a0
	CMPI	-4,A0
	JRLE	#no_multiplier
	MOVI	-4,A0
	JRUC	#no_multiplier

DO_NORMAL_ADJUST_CHECK
	;not a combo.  check for a multiplier.
	move	@DAM_MULT,a9
	jrz	#no_multiplier

	;compute new damage val
	;MULT 2:  damage *= 3/2
	;MULT 3:  damage *= 4/2
	;MULT 4+: damage *= 5/2
	move	a0,a14
#mul_lp	add	a14,a0
	dsj	a9,#mul_lp
	sra	1,a0
	
	;clr DAM_MULT
	clr	a14
	move	a14,@DAM_MULT

#no_valid_attacker
#no_multiplier


****	;Adjust damage based on the number of drones, unless we're adding
	;life.
	TEST	a0
	jrnn	#dc_adj_done

	;count active drones
	; count = 0 in attract mode, 4 in 8-on-1, 5 in buddy mode, 6 in
	; 8-on-2.
	PUSH	a1,a2,a3

	movk	4,a3
	calla	is_8_on_1
	jrc	#adc_set

	movk	5,a3
	move	@buddy_mode_on,a14
	jrnz	#adc_set

	movk	6,a3
	move	@royal_rumble,a14
	jrnz	#adc_set

	clr	a3

	move	@PSTATUS,a14
	jrz	#adc_set

	movi	process_ptrs+40h,a1
	movi	NUM_WRES-2,a2
#lp0	move	*a1+,a14,L
	jrz	#adc_set
	inc	a3
	dsj	a2,#lp0

#adc_set
	X32	a3
	addi	#damage_mod_table,a3

	;add 10h if the target is a player
	move	*a13(PLYR_TYPE),a14
	cmpi	PTYPE_DRONE,a14
	jreq	#adc_drone
	addk	10h,a3
#adc_drone
	move	*a3,a3
	mpyu	a0,a3
	move	a3,a0
	sra	8,a0

	PULL	a1,a2,a3
#dc_adj_done


****	;Adjust damage based on game time adjustment
	move	@speed_adjustment,a14,L
	mpys	a14,a0
	sra	16,a1
	move	a1,a0


****	;Store away dmg this plyr has done for later analysis, but only
	; if we're taking damage and a10 matches WHOHITME.
	TEST	a0
	jrnn	#nostore

	move	*a13(WHOHITME),a14,L
	cmp	a14,a10
	jrne	#nostore

	move	*a10(DAMAGE_GIVEN),a14
	sub	a0,a14		;(damage is negative)
	move	a14,*a10(DAMAGE_GIVEN)
#nostore

	;do range checking on the damage value.  Don't allow a wrestler
	; to have a life value below zero or above LIFE_MAX.
	move	a0,a3
	add	a4,a3			;a3 is new life total
	jrle	#bzero

	cmpi	LIFE_MAX,a3
	jrle	#dmg_ok

	movi	LIFE_MAX,a3
	jruc	#dmg_ok

#bzero	;this hit will kill us.  If it was a 20+ point hit, and it killed
	; us by a margin of 6 pixels or less, fudge it by taking five
	; off the damage

	cmpi	-10,a3
	jrle	#no_fudge	;skip if life is -4 or less

	cmpi	-20,a0
	jrgt	#no_fudge	;skip if the hit wasn't 25 or more

	;fudge it.  Add 5 to the adjusted life to keep us alive
	addk	5,a3
	movk	5,a3
	;and add 5 to the health adjustment (thus subtracting five from
	; the damage done), just to be safe.
;	addk	5,a0
	jruc	#dmg_ok

#no_fudge
	clr	a3

	;if we're in attract mode, don't die!
	move	@PSTATUS,a14
	jrnz	#norm1
	MOVI	LIFE_MAX,a3

#norm1	;if he's out of life and we're in debug mode, fill him up.
	.if DEBUG
	move	@fight_debug,a14
	jrz	#dmg_ok
	movi	LIFE_MAX,a3
	.endif

#dmg_ok
	move	a3,*a5(PLT_LIFE)

	;update LAST_DAMAGE
	move	@PCNT,a14
	move	a14,*a13(LAST_DAMAGE)

	;figure out if we need to flash the lifebar as a warning.
	;if a4 > 30 and a3 <= 30, fire off a danger process.
	; re above:  a4 is current life, a3 is life after this hit.
	cmpi	30,a4
	jrle	#no_danger_proc
	cmpi	30,a3
	jrgt	#no_danger_proc

	;skip this if we have any teammates
	move	a13,a0
	calla	ck_any_teammates
	jrc	#no_danger_proc
	CREATE	FLASH_PID,flash_obj
	move	a13,*a0(PDATA),L

#no_danger_proc

	TEST	a3
	jrnz	#not_dead

	;player IS dead. -- time to restore original PLYRNUM
	move	@#actual_plyrnum,a1
	calla	get_process_ptr
	move	a0,a13

	;set I_WILL_DIE on dead human's teammate if we're in royal rumble
	; mode.
	move	@royal_rumble,a14
	jrz	#norum
	cmpi	2,a1
	jrge	#norum

	xori	1,a1
	calla	get_process_ptr
	movk	1,a14
	move	a14,*a0(I_WILL_DIE)
	xori	1,a1

#norum	;if dying guy is a drone, and we're in 8-on-? mode, decrement
	; wrestler_count and wake up the wrestler_counter process.
	move	@#actual_plyrnum,a1
	cmpi	2,a1
	jrlt	#notd8

	;Set the COUNTED_DEAD bit too.  If it's already set, don't decrement
	; wrestler_count again.
	move	*a13(STATUS_FLAGS),a14,L
	btst	B_COUNTED_DEAD,a14
	jrnz	#notd8
	ori	M_COUNTED_DEAD,a14
	move	a14,*a13(STATUS_FLAGS),L

	move	@wrestler_count_proc,a0,L	; Does the counter proc exist ?
	jrz	#notd8				; br = no
	move	@wrestler_count,a14		; Current count == 0 ?
	jrz	#notd8				; br = yes
	dec	a14				; Decrement it
	move	a14,@wrestler_count		; Write it back
	movk	1,a14				; Make counter proc wakeup on next tick
	move	a14,*a0(PTIME)
#notd8

	;Is combo mode on for this player?
	move	*a13(WHOHITME),a8,L
	callr	CHECK_COMBO_GO
	jrlt	#ok
;Am I in the middle of a combo?
	move	*a8(COMBO_COUNT),a0
	jrz	#ok
;Give him some life back
	movk	1,a14
	move	a14,*a5(PLT_LIFE)
	move	a14,*a13(I_WILL_DIE)
	jruc	#already_dead
#ok

	;temp! - 314
	.if DEBUG
	DBEVENT	BDE_DIES,a13,L,*a13(WRESTLERNUM),W,*a13(PLYRNUM),W
	.endif

	;death sound
	movi	034h,a0
	calla	triple_sound

	clr	a14
	move	a14,*a13(ROLL_POS)

;Lookup table based on wrestler type

	move	*a13(WHOHITME),a10,L	;* wrestler process
	move	*a10(ATTACK_MODE),a0
	cmpi	AMODE_BLBOWDROP,a0
	jrz	#skip0
	cmpi	AMODE_BSTOMP,a0
	jrz	#skip0
	cmpi	AMODE_BUTTSTOMP,a0
	jrz	#skip0

	;if death by buzzer, jump to #skip0 ONLY if it was unblocked.
	cmpi	AMODE_BUZZ,a0
	jrne	#nobuzz
	move	*a13(PLYRMODE),a14
	cmpi	MODE_BLOCK,a14
	jrne	#skip0
#nobuzz

	;if our DEAD_ANIM bit is set, don't animate
	move	*a13(STATUS_FLAGS),a14
	btst	B_DEAD_ANIM,a14
	jrnz	#skip0

	move	*a13(WRESTLERNUM),a0
	X32	a0

	move	*a13(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jrz	#grnd
	cmpi	MODE_ONGROUND,a14
	jrnz	#fall

#grnd	addi	convulse_t,a0
	move	*a0,a0,L

	calla	change_anim1a

#skip0
	SETMODE	DEAD
	calla	wres_collis_off

	calla	flash_red

	PULL	a1,a3,a4,a5,a8,a10,a13

	setc
	rets

#fall
;Check plyr mode, attempt a death fall back
;Otherewise, just set mode dead
	cmpi	MODE_NORMAL,a14
	jrz	#fallbk
	cmpi	MODE_RUNNING,a14
	jrz	#fallbk
	cmpi	MODE_INAIR,a14
	jrz	#fallbk
	cmpi	MODE_INAIR2,a14
	jrz	#fallbk
	cmpi	MODE_BOUNCING,a14
	jrz	#fallbk
	cmpi	MODE_ONTURNBKL,a14
	jrz	#fallbk
	cmpi	MODE_BLOCK,a14
	jrz	#fallbk
	cmpi	MODE_DIZZY,a14
	jrz	#fallbk
	cmpi	MODE_CLIMBTURNBKL,a14
	jrz	#fallbk
	cmpi	MODE_HEADHOLD,a14
	jrz	#fallbk
	cmpi	MODE_HEADHELD,a14
	jrz	#will_die

;Puppet mode?  Others?
;How best to deal with this?


;	LOCKUP

;At least zero vels?
	clr	a0
	move	a0,*a13(OBJ_XVEL),L
	move	a0,*a13(OBJ_ZVEL),L
	move	a0,*a13(OBJ_YVEL),L
     
	SETMODE	DEAD
#skip	calla	wres_collis_off

	calla	flash_red

	PULL	a1,a3,a4,a5,a8,a10,a13

	setc
	rets

#will_die
;	movk	1,a0
;	move	a0,*a13(I_WILL_DIE)
	movi	3*60,a0
	move	a0,*a13(I_WILL_DIE)
	jruc	#skip

#fallbk	addi	#fallbacks_t,a0
	move	*a0,a0,L

	calla	change_anim1a

	move	*a13(OBJ_XVEL),a2,L
	cmpi	[2,0],a2
	jrgt	#okz
	movi	[2,0],a2
	move	*a13(OBJ_XPOSINT),a1
	move	*a13(WHOHITME),a0,L	;* wrestler process

	move	*a0(OBJ_XPOSINT),a0
	cmp	a0,a1			;offx - defx
	jrgt	#fall_right		;attacker on left
	movi	[-2,0],a2


#fall_right
	move	a2,*a13(OBJ_XVEL),L
#okz

	calla	wres_collis_off
     
	SETMODE	DEAD

	calla	flash_red

	PULL	a1,a3,a4,a5,a8,a10,a13

	setc
	rets



#already_dead

	calla	flash_red

	PULL	a1,a3,a4,a5,a8,a10,a13
	setc
	rets

#not_dead
	PULL	a1,a3,a4,a5,a8,a10,a13
	clrc
	rets


;		tgt = drone	tgt = player
#damage_mod_table
	.word	_85PCT,		_85PCT		;0 drones
	.word	_100PCT,	_100PCT		;1 drone
	.word	_110PCT,	_90PCT		;2 drones
	.word	_125PCT,	_75PCT		;3 drones
	.word	_145PCT,	_60PCT		;8-on-1 match
	.word	_110PCT,	_90PCT		;buddy mode match
	.word	_130PCT,	_30PCT		;8-on-2 match


 SUBR	fallbacks_t
#fallbacks_t
#fall_back
	REFLONG	hrt_fall_back_anim		;0 Bret Hart
	REFLONG	rzr_fall_back_anim		;1 Razor Ramon
	REFLONG	und_fall_back_anim		;2 Undertaker
	REFLONG	yok_fall_back_anim		;3 Yokozuna
	REFLONG	shn_fall_back_anim		;4 Shawn Michaels
	REFLONG	bam_fall_back_anim		;5 Bam Bam
	REFLONG	dnk_fall_back_anim		;6 Doink
	.long	0				;7 spare
	REFLONG	lex_fall_back_anim		;8 Lex Luger
 

 SUBR	convulse_t
#hitonground
	REFLONG	hrt_hitonground_anim		;0 Bret Hart
	REFLONG	rzr_hitonground_anim
	REFLONG	und_hitonground_anim		;2 Undertaker
	REFLONG	yok_hitonground_anim		;3 Yokozuna
	REFLONG	shn_hitonground_anim		;4 Shawn Michaels
	REFLONG	bam_hitonground_anim		;5 Bam Bam
	REFLONG	dnk_hitonground_anim		;6 Doink
	.long	0				;7 spare
	REFLONG	lex_hitonground_anim		;8 Lex Luger

#*****************************************************************************
* Create the credits display at the top of the screen
*

 SUBR	start_credbox

	;draw the panel
	TBL_OBJ	#plate

	callr	update_credit_msg
	rets

	
***************************************
* Display credit info - Gets called from coin routines.
*
* Trashes a0-a7

 SUBR	update_credit_msg

	PUSH	a8,a9,a10

;Only turn on these messages if during gameplay, or player select!

	.ref	SHOW_CRD_FLAG
	move	@SHOW_CRD_FLAG,a0
	jrnz	#cont0

	move	@GAMSTATE,a0
	cmpi	INSELECT,a0
	jrz	#cont

	CMPI	INPARTY,A0
	JREQ	#cont
	CMPI	INPREGAME,A0
	JREQ	#cont
	CMPI	INPREGAME2,A0
	JREQ	#cont

	subk	INGAME,a0
	jrne	#x

#cont0

;When coins are entered, and the game is being played, tell the meter
;code to display approproiate coinin message.

;Get meter process info
	movi	METER_PID,a0
	clr	a1
	not	a1
	calla	EXISTP
	jrz	#cont

	movk	1,a1
	move	a1,*a0(P1CNTR)
	move	a1,*a0(P2CNTR)
	clr	a1
	move	a1,*a0(P1STATE)
	move	a1,*a0(P2STATE)

#cont

	movi	CLSDEAD|CREDITID,a0
	calla	obj_del1c		;kill credit/qrtr imgs
 
	TBL_OBJ	#plate

	movi	freeply,a10

	movk	ADJFREPL,a0
	CALLA	GET_ADJ		 	;SEE IF FREEPLAY......(Z BIT CLEAR IF SO!)
	jrnz	#freep

	movi	credit,a10

	calla	GET_CREDITS
	calla	BINBCD
	
	move	a0,a9
	sll	32-4,a0
	srl	32-4-5,a0		;*32
	addi	#numfont,a0
	move	*a0,a2,L

	movi	[216,0],a0
	movi	[6,0],a1
;	movi	1006,a3			;Z
	movi	1901H,a3			;Z
	movi	DMAWNZ|M_SCRNREL,a4
	movi	CLSDEAD|CREDITID,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ
	
	srl	4,a9
	sll	32-4,a9
	srl	32-4-5,a9		;*32
	addi	#numfont,a9
	move	*a9,a2,L

	movi	[211,0],a0
	movi	[6,0],a1
	calla	BEGINOBJ
	
#freep	movi	[179,0],a0
	movi	[6,0],a1
	move	a10,a2
;	movi	1006,a3			;Z
	movi	1901H,a3			;Z
	movi	DMAWNZ|M_SCRNREL,a4
	movi	CLSDEAD|CREDITID,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ

#x	PULL	a8,a9,a10

	rets

***************************************
* config data
*

#plate	.word	176,4,1900H				;X, Y, Z
	.long	crplate					;IMG
	.word	DMAWNZ|M_SCRNREL			;CTRL
	.word	CLSDEAD|CREDITID			;OID
	.long	0,0					;XVEL, YVEL
	.even

#numfont
	.long	font60
	.long	font61
	.long	font62
	.long	font63
	.long	font64
	.long	font65
	.long	font66
	.long	font67
	.long	font68
	.long	font69

#*****************************************************************************
* Moves PLT_CLIFE toward PLT_LIFE if it isn't already there.
* >a0 = PLYRNUM

#lifebar_deltavee	equ	2	;pixels per tick of motion

 SUBRP	inc_life

	;aim a1 at PLT block
	move	a0,a1
	X64	a1		;x by PLT_SIZE
	addi	life_data,a1

	;check the values
	move	*a1(PLT_LIFE),a2
	move	*a1(PLT_CLIFE),a3

	cmp	a2,a3
	jrz	#done

	;CLIFE is lagging.  move it toward LIFE
	jrgt	#shrink

	;CLIFE needs to grow
	addi	#lifebar_deltavee,a3
	cmp	a3,a2
	jruc	#set

#shrink
	subi	#lifebar_deltavee,a3
	cmp	a2,a3
#set
	jrge	#inrange

	;overshot it
	move	a2,a3	    
#inrange
	move	a3,*a1(PLT_CLIFE)

#done
	rets


#*****************************************************************************
* Flash the background of the life meter for the current player.
* >a10 = plyrnum

danger_snd	equ	0b9h

 SUBRP	flash_obj

	;if we're a drone and we have teammates, ignore this.
	cmpi	1,a10
	jrle	#ndie

	move	a10,a1
	calla	get_process_ptr
	move	*a0(PLYR_SIDE),a4
	movi	process_ptrs+40h,a1
	movi	NUM_WRES-2,a2
#lp0	move	*a1+,a3,L
	jrz	#ndie			;done at first inactive
	cmp	a0,a3
	jreq	#nxt0			;skip self
	move	*a3(PLYR_SIDE),a14
	cmp	a4,a14
	jreq	#die			;die--we have a teammate
#nxt0	dsj	a2,#lp0

#ndie
	;find the bar obj
	calla	arm_comeback_award

	movi	danger_snd,a0
	calla	triple_sound

	;danger music - skip if in 8-on-2 mode
	calla	is_8_on_1
	jrc	#die
	move	@royal_rumble,a14
	jrnz	#die

	movi	18,a3
	move	@temp_music,a14
	cmpi	15,a14
	jreq	end_music_set
	movk	26,a3
end_music_set
	calla	SNDSND

	movi	danger,a2
	movi	[85h,0],a0
	move	*a13(PDATA),a1,L
	move	*a1(PLYR_SIDE),a1
	jrz	#p1
	movi	[0e4h,0],a0
#p1	movi	[18h,0],a1
	movi	name_z,a3			;Z
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ

	movk	20,a9
#lp

	move	a10,a0
	X32	a0
	addi	process_ptrs,a0
	move	*a0,a0,L

	move	*a0(CLOSEST_NUM),a14
	X32	a14
	addi	process_ptrs,a14
	move	*a14,a14,L
	move	*a14(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#deldie

	move	*a0(PLYRMODE),a0
	cmpi	MODE_DEAD,a0
	jreq	#deldie

	SLEEPK	7

	movi	WSF_R_P,a0
	calla	pal_getf
	move	a0,*a8(OPAL)

	SLEEPK	4

	movi	WSF_W_P,a0
	calla	pal_getf
	move	a0,*a8(OPAL)

	dsj	a9,#lp

#deldie	calla	DELOBJA8

#die	DIE



******************************************************************************

 SUBRP	do_win_streaks

	move	@p1winstreak,a0
	jrz	#p2

	callr	streak_1

#p2	move	@p2winstreak,a0
	jrz	#x

	callr	streak_2

#x
	rets

streak_1
	cmpi	99,a0
	jrls	#maxok
	movi	99,a0
#maxok
    	calla	BINBCD

	move	a0,a9
	sll	32-4,a0
	srl	32-4-5,a0		;*32
	addi	#f_t,a0
	move	*a0,a2,L

	movi	[3dh,0],a0
	movi	[23h,0],a1
	movi	name_z,a3			;Z
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ
	MOVE	A8,@WINS_OBJ,L

	srl	4,a9
	sll	32-4,a9
	srl	32-4-5,a9		;*32
	addi	#f_t,a9
	move	*a9,a2,L
	movi	[36h,0],a0
	movi	[23h,0],a1
	calla	BEGINOBJ
	MOVE	A8,@WINS_OBJ+20H,L
   
	TBL_OBJ	lwin
	MOVE	A8,@WINS_OBJ+40H,L
	rets

streak_2
	cmpi	99,a0
	jrls	#maxok2
	movi	99,a0
#maxok2
    	calla	BINBCD

	move	a0,a9
	sll	32-4,a0
	srl	32-4-5,a0		;*32
	addi	#f_t,a0
	move	*a0,a2,L

	movi	[175h,0],a0
	movi	[23h,0],a1
	movi	name_z,a3			;Z
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ
	MOVE	A8,@WINS_OBJ,L
	move	a8,a10

	srl	4,a9
	sll	32-4,a9
	srl	32-4-5,a9		;*32
	addi	#f_t,a9
	move	*a9,a2,L
	movi	[16eh,0],a0
	movi	[23h,0],a1
	calla	BEGINOBJ
	MOVE	A8,@WINS_OBJ+20H,L

	TBL_OBJ	rwin
	MOVE	A8,@WINS_OBJ+40H,L
	rets


#f_t
	.long	WFONT_0,WFONT_1,WFONT_2,WFONT_3,WFONT_4
	.long	WFONT_5,WFONT_6,WFONT_7,WFONT_8,WFONT_9


	.ref	match_cnt

#*****************************************************************************
*

	STRUCTPD
	LONG	BLINK_PROC

announce_match


	MOVI	CROWD_CHEER_0,A3
	CALLA	SNDSND

	clr	a0
	move	a0,*a13(BLINK_PROC),L

	move	@PSTATUS,a0
	jrnz	#noamode
	clr	a0
	move	a0,@HALT
	DIE

#noamode

 .if DEBUG
	.ref	skip_select
	move	@skip_select,a0
	jrz	#noskp
	clr	a0
	move	a0,@HALT
	DIE
#noskp
 .endif


;	SLEEP	28h
;	movi	28h,a10
;	JSRP	wait_on_butn

	movi	ram_lst,a11
	clr	a0
	movi	39,a1
#lp	move	a0,*a11+,L
	dsjs	a1,#lp
	movi	ram_lst,a11

	movi	[252h,0],a0			;x pos
	movi	[3eh,0],a1			;y pos
	movi	MTCHPLT,a2
	movi	MPLTPRPP,b0
	movi	1800h,a3				;z pos
	callr	#begin_obj

	movi	[252h,0],a0			;x pos
	movi	[3eh,0],a1			;y pos
	movi	MNMEPLT,a2
	movi	MPLTPRPP,b0
	movi	1800h,a3				;z pos
	callr	#begin_obj

	movi	[574,0],a0			;x pos
	movi	[4Fh,0],a1			;y pos
	movi	MATCH,a2
	movi	WGFS_W_P,b0
	movi	1801h,a3				;z pos
	callr	#begin_obj
	MOVE	A8,B3
	CLR	B4
	CLR	B5
	CLR	B6

	move	@match_cnt,a0

	cmpi	999,a0
	jrls	#maxok
	movi	999,a0
#maxok
    	calla	BINBCD

	move	a0,a9
	move	a0,a10
	sll	32-4,a0
	srl	32-4-5,a0		;*32
	addi	#f_t,a0
	move	*a0,a2,L

	movi	[252h,0],a0			;x pos
	movi	[43h,0],a1			;y pos
	movi	WGFS_W_P,b0
	movi	1802h,a3				;z pos
	callr	#begin_obj
	MOVE	A8,B4

	srl	4,a9
	sll	32-4,a9
	srl	32-4-5,a9		;*32
	move	a9,a9
	jrz	#ok2

	addi	#f_t,a9
	move	*a9,a2,L
	movi	[252h,0],a0			;x pos
	movi	[43h,0],a1			;y pos
	movi	WGFS_W_P,b0
	movi	1802h,a3				;z pos
	callr	#begin_obj
	MOVE	A8,B5

	srl	8,a10
	sll	32-4,a10
	srl	32-4-5,a10		;*32
	move	a10,a10
	jrz	#ok2

	addi	#f_t,a10
	move	*a10,a2,L
	movi	[252h,0],a0			;x pos
	movi	[43h,0],a1			;y pos
	movi	WGFS_W_P,b0
	movi	1802h,a3				;z pos
	callr	#begin_obj
	MOVE	A8,B6

#ok2
	MOVE	*B3(OSIZEX),B7
	ADDI	5,B7
	MOVE	*B4(OSIZEX),B0
	ADD	B0,B7
	ADDK	3,B7
	MOVE	B5,B5
	JRZ	NO_NEED_TO_ADD_TO_X
	SUBK	3,B7
	MOVE	*B5(OSIZEX),B0
	ADD	B0,B7
	MOVE	B6,B6
	JRZ	NO_NEED_TO_ADD_TO_X
	MOVE	*B6(OSIZEX),B0
	ADD	B0,B7

NO_NEED_TO_ADD_TO_X
	SRL	1,B7
	MOVI	252H,B8
	SUB	B7,B8
	MOVE	B8,*B3(OXPOS)
	ADDI	5,B8
	MOVE	B5,B5
	JRNZ	NO_EXTRA_SPACE
	ADDK	3,B8
NO_EXTRA_SPACE

	MOVE	B6,B6
	JRZ	NO_NEED_TO_ADD_TO_X2A
	MOVE	*B3(OSIZEX),B7
	ADD	B7,B8
	MOVE	B8,*B6(OXPOS)
	JRUC	X2A_ADDED

NO_NEED_TO_ADD_TO_X2A
	MOVE	B3,B6
X2A_ADDED
	MOVE	B5,B5
	JRZ	NO_NEED_TO_ADD_TO_X2B
	MOVE	*B6(OSIZEX),B7
	ADD	B7,B8
	MOVE	B8,*B5(OXPOS)
	JRUC	X2B_ADDED

NO_NEED_TO_ADD_TO_X2B
	MOVE	B3,B5
X2B_ADDED
	MOVE	*B5(OSIZEX),B7
	ADD	B7,B8
	MOVE	B8,*B4(OXPOS)

;Print the text on the little plate

;This will be a table lookup which points to match type
;(Ex. Best 2 of 3, Intercontinental Championship, WWF Championship
;Lumberjack match, Tag Team Bout, This contest is for 1 fall!, etc.)

;Make sure we have enough ram set aside for the largest
;message possible.  (ram_lst)

	movi	[253h,0],a0			;x pos
	movi	[68h,0],a1			;y pos

	;set a3 to 1 if this is the final match, 0 otherwise
	clr	a3
	calla	is_final_match
	jrnc	#a3set
	movk	1,a3

#a3set	movi	WHICH_MATCH,a2
	SLL	5,A3
	ADD	A3,A2
	MOVE	*A2,A2,L
	movi	WSF_W_P,b0
	movi	1801h,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	CLSNEUT|TYPTEXT|SUBMES1,a5
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJP


;Place all of the new plates & string characters onto the ram_lst that
;gets scrolled.

	movi	OBJLST,a14
	movi	CLSNEUT|TYPTEXT|SUBTXT,a0
	movi	CLSNEUT|TYPTEXT|SUBMES1,a2
#lp2
	move	*a14,a14,L
	jrz	#x
	move	*a14(OID),a1
	cmp	a2,a1
	jrz	#add
	cmp	a0,a1
	jrne	#lp2
#add	move	a14,*a11+,L
  	jruc	#lp2
#x

;This will blink between red/white
	CREATE	CYCPID,blink_font
	move	a0,*a13(BLINK_PROC),L

;Slide everthing onto screen

	movi	>b6,a0
	calla	triple_sound

	movi	20h,a10	;30

#onscr_loop

	SLEEPK	1

	movi	[200,0],a0
	callr	#set_x

	dsj	a10,#onscr_loop

	calla	is_8_on_1
	jrc	#skip_do_rounds
	;skip this if this is the final match
	CREATE	ANNC_PID,DO_ROUNDS
#skip_do_rounds

;In middle
	CREATE	SOUND_PID,ring_bell

;	SLEEP	20h

	.ref	IKIL1C
	.ref	show_options

	movi	PU_CHECK_PID,a0
	calla	IKIL1C

	CREATE0	show_options

	movi	50h,a10	;80

	.ref	wait_on_butn
	JSRP	wait_on_butn

	movi	>b6,a0
	calla	triple_sound

	movi	16h,a10	;23

#offscr_loop

	SLEEPK	1

	movi	[0feb0h,0],a0
	callr	#set_x

	dsj	a10,#offscr_loop

	move	*a13(BLINK_PROC),a0,L
	calla	KILL

	clr	a0
	move	a0,@HALT

	movi	CLSNEUT|TYPTEXT|SUBTXT,a0
	calla	obj_del1c		;delete text/plates

	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
	calla	obj_del1c		;delete text/plates

	;set round_start_time
	move	@PCNT,a14,L
	move	a14,@round_start_time,L

	DIE

#f_t
	.long	WGSF22_0,WGSF22_1,WGSF22_2,WGSF22_3,WGSF22_4
	.long	WGSF22_5,WGSF22_6,WGSF22_7,WGSF22_8,WGSF22_9

WHICH_MATCH
	.LONG	BESTOF3
	.LONG	ROYRUM
	.LONG 	ELIMMTCH
	.LONG	TAGTEAM
	.LONG	ONEFALL
	.LONG	LUMBMTCH


;#ln0a_setup
;	JAM_STR	osgemd_ascii,6,0,247h,43h,BLUE,0
;
;#ln0b_setup
;	JAM_STR	osgemd_ascii,6,0,23fh,43h,BLUE,0
;
;#ln1_setup
;	JAM_STR	sgmd8_ascii,5,0,252h,80h-10,SGMD8WHT2,0
;
;#ln2_setup
;	JAM_STR	sgmd8_ascii,5,0,252h,8bh-10,SGMD8WHT2,0
;
;#str_rounds
;	.string	"ROUNDS",0
;	.even

blink_font

	SLEEPK	2

	movi	20,a10
#top	
	movi	WSF_R_P,a0
	calla	pal_getf

	movi	ram_lst,a11
#lp3
	move	*a11+,a8,L
	jrz	#x2
	move	*a8(OID),a14
	cmpi	CLSNEUT|TYPTEXT|SUBMES1,a14
	jrnz	#lp3
	move	a0,*a8(OPAL)
  	jruc	#lp3

#x2	SLEEPK	4

	movi	WSF_W_P,a0
	calla	pal_getf

	movi	ram_lst,a11
#lp4
	move	*a11+,a8,L
	jrz	#x3
	move	*a8(OID),a14
	cmpi	CLSNEUT|TYPTEXT|SUBMES1,a14
	jrnz	#lp4
	move	a0,*a8(OPAL)
  	jruc	#lp4

#x3	SLEEPK	7

	dsj	a10,#top

announcing_being_done
	DIE

******************************************************************************

	STRUCTPD
	LONG	#CREATOR	;UHL proc ptr to whoever created us
	LONG	#ORIGIN		;UHL approx address of our create call

	.if DEBUG
	;doesn't execute -- just here for TV viewing
	move	*a13(#CREATOR),a14,L
	move	*a13(#ORIGIN),a14,L
	.endif

 SUBR	announce_rnd_winner	;process

	;temp! - 314
	.if DEBUG
	DBEVENT	BDE_ARW_START,a13,L,*a13(#CREATOR),L,*a13(#ORIGIN),L
	.endif

#fini_wait
	move	@in_finish_move,a14	; Are we doing a finishing move ?
	jrz	#fini_done		; br = no
	SLEEPK	10
	jruc	#fini_wait
#fini_done

	movi	ANNC_PID,a0
	clr	a1
	not	a1
	calla	EXISTP
;	janz	SUCIDE
	jrz	#tmpok

	;temp! - 314
	.if DEBUG
	DBEVENT	BDE_ARW_DEXIST,a13,L,*a13(#CREATOR),L,*a13(#ORIGIN),L
	.endif
	DIE

#tmpok

	move	@annc_rnd_winner_done,a14
	jrz	#arwd_ok
	.if DEBUG
	;temp! - 314
	DBEVENT	BDE_ARW_FLAGDIE,a13,L,*a13(#CREATOR),L,*a13(#ORIGIN),L
	.endif
	DIE
#arwd_ok

	;if anyone is trying to do a buckoff, wait for them to finish up.
#any_b	callr	anyone_bucking
	TEST	a0
	jrz	#nobuck

	;temp! - 314
	.if DEBUG
	DBEVENT	BDE_ARW_ATTEMPT,a13,L,*a13(#CREATOR),L,*a13(#ORIGIN),L
	.endif

	;Someone's trying to do a buckoff.  We'll give them 120 ticks or
	; until someone hits an ANI_LOOP statement, then figure out what
	; to do from there.

	SLEEP	90	;NOTE:  If someone hits an ANI_LOOP command and
			; their DID_PIN bit is set, they'll check and
			; see if we're sleeping at arw_bwait, and if we
			; are, they'll wake us up right away.
 SUBR	arw_bwait

	;temp! - 314
	.if DEBUG
	DBEVENT	BDE_ARW_WAKEUP,a13,L,*a13(#CREATOR),L,*a13(#ORIGIN),L
	.endif

	;check for anyone with their NEW_BUCKOFF bit set.  If we find any,
	; clear that bit on anyone who's got it set.
	movi	process_ptrs,a0
	movi	NUM_WRES,a1
	clr	a3
#lp0	move	*a0+,a2,L
	jrz	#nxt0		;skip inactive
	move	*a2(STATUS_FLAGS),a14,L
	btst	B_NEW_BUCKOFF,a14
	jrz	#nxt0

	;got one
	andni	M_NEW_BUCKOFF,a14
	move	a14,*a2(STATUS_FLAGS),L
	inc	a3

#nxt0	dsj	a1,#lp0

	;now check for an all-dead condition.  If neither team is dead, die.
	calla	get_live_bits
	cmpi	3,a0
	jrne	#1ded

	;temp! - 314
	.if DEBUG
	DBEVENT	BDE_ALL_ALIVE,a13,L,*a13(#CREATOR),L,*a13(#ORIGIN),L
	.endif
	jauc	SUCIDE

#1ded	;1 team is dead.  If nobody did a buckoff during our nap, end the
	; round.  If someone did, jump up to #any_b, which checks to see
	; if there's any more buckoff candidates.
	TEST	a3
	jrnz	#any_b

	;temp! - 314
	.if DEBUG
	DBEVENT	BDE_ARW_NOBUCK,a13,L,*a13(#CREATOR),L,*a13(#ORIGIN),L
	.endif

	;there was at least one wrestler who could have done a buckoff,
	; but was too slow.  For EVERYONE, clear BUCKOFF_COUNT, clear
	; the DO_BUCKOFF flag, and set the NO_BUCKOFF flag.
	movi	process_ptrs,a0
	movi	NUM_WRES,a1
	clr	a3
#lp6	move	*a0+,a2,L
	jrz	#nxt6		;skip inactive
	move	a3,*a2(BUCKOFF_COUNT)
	move	*a2(STATUS_FLAGS),a14,L
	andni	M_DO_BUCKOFF,a14
	ori	M_NO_BUCKOFF,a14
	move	a14,*a2(STATUS_FLAGS),L
#nxt6	dsj	a1,#lp6


#nobuck

	;temp! - 314
	.if DEBUG
	DBEVENT	BDE_ARW_ENDRND,a13,L,*a13(#CREATOR),L,*a13(#ORIGIN),L
	.endif

	;set round_end_time
	move	@PCNT,a0,L
	move	a0,@round_end_time,L

	;set annc_rnd_winner_done
	movk	1,a14
	move	a14,@annc_rnd_winner_done

	;set EVERYONE'S NO_BUCKOFF flags, just to be safe.
	callr	set_all_buckoffs

	MOVI	ZFLIP_FOR_SURE,A0
	MOVE	A0,@ZFLIP_POS_VAR,L

	MOVI	CROWD_VICTORY_LOOP,A3
 	CALLA	SNDSND

	callr	set_winner	;a3 = PLYRNUM of a wrestler on the winning
				; team.  The pinner if there is one.
	jrn	#do_game_over
	X32	a3
	addi	process_ptrs,a3
	move	*a3,a10,L

	move	@p1rounds,a0
	cmpi	2,a0
	jrz	at_end
	move	@p2rounds,a0
	cmpi	2,a0
	jreq	at_end
	calla	calc_match_time_1
	jruc	timer_updated

at_end
;#let_finish_happen
;	move	@in_finish_move,a0		; Did a finish move get started?
;	jrz	#no_finish_move			; br = no
;	SLEEPK	1				; Wait for it to finish
;	jruc	#let_finish_happen
;#no_finish_move
	move	@p1rounds,a0
	move	@p2rounds,a3
	or	a0,a3
	cmpi	2,a3
	jrnz	#no_2_rnd_victory
	calla	is_8_on_1
	jrc	#no_2_rnd_victory
	MATCH_AWARD a10,TWO_RND_AWD
#no_2_rnd_victory
	calla	calc_match_time_2

timer_updated

	callr	is_perfect
	jrnc	#not_perfect
	MATCH_AWARD a10,PERFECT_AWD
	CREATE	ADD_INIT_PID,CREATE_PERFECT
	SLEEP	55+50
#not_perfect
;NOT_PERFECT_MATCH

;a10=*proc of wrestler who just pinned opponent
;-not neccesarily: if the win was by disqualification or timeout, there's
; no pin.
	SLEEPK	30

;Place token on top of winner, then have it float up to the top of the screen

	movi	27,a3
	calla	SNDSND

	move	*a10(PLYR_SIDE),a0
	CALLA	CALL_MATCH_OVER

	SLEEPK	20

	;has anyone won the match?
	move	@p1rounds,a0
	cmpi	2,a0
	jrz	DO_WAIT
	move	@p2rounds,a0
	cmpi	2,a0
	jrnz	#go0

DO_WAIT
	CLR	A0
	MOVE	A0,@MUSIC_HAP

;Increment his win count
	calla	increment_wincount

	;don't draw the text if this is a royal rumble
	move	@royal_rumble,a14
	jrnz	#skip_rw
	callr	replace_wins
#skip_rw

	;wait 1 sec or until a press
	movi	TSEC,a9
#wl0	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#go0
	dsjs	a9,#wl0
#go0

	move	@p1rounds,a9
	cmpi	2,a9
	jreq	#won_match
	move	@p2rounds,a14
	cmpi	2,a14
	jreq	#won_match
	add	a14,a9
	dec	a9
	jruc	#won_fall

#won_match
	movk	2,a9
#won_fall


;	calla	is_8_on_1
;	jrnc	#no_fireworks
;	move	@p1rounds,a0
;	move	@p2rounds,a14
;	or	a0,a14
;	cmpi	2,a14
;	jrlt	#no_fireworks
;	JSRP	do_fireworks
;#no_fireworks

	move	*a10(PLYR_SIDE),a11
	movi	0c4h,a0
	calla	triple_sound
	CREATE	ANNC_PID,CREATE_END_ROUND_TOP
	SLEEPK	15
	CREATE	ANNC_PID,CREATE_END_ROUND_BOT
	SLEEPK	10
	CREATE	ANNC_PID,CREATE_END_ROUND_ICON
	SLEEPK	20

;Move round awards into match awards section and annunciate round awards for
;each human player.  Then clear out round awards.

	calla	is_it_a_really_quick_win
	calla	give_award_if_opponent_is_human
	calla	check_for_award_for_big_comeback


	calla	accumulate_awards	; Accumulate awards for each player

	CALLA	CLEAR_SPEECH_REPEAT

	move	@p1rounds,a0
	cmpi	2,a0
	jrz	#end
	move	@p2rounds,a0
	cmpi	2,a0
	jrnz	#not_end

#end
	calla	check_for_award_for_winstreak
	clr	a0
	move	a0,@award_ok_to_die,L
	CREATE	AWARD_PID,create_end_rnd_awards

	CREATE	SOUND_PID,DO_RIGHT_MUSIC
	move	@royal_rumble,a0
	jrnz	#no_award_wait
#wait_awards_dead
	SLEEPK	1
	move	@award_ok_to_die,a0,L
	cmpi	3,a0
	jrlt	#wait_awards_dead
#no_award_wait



	;wait 1 sec or until a press
	movi	TSEC*3,a9
#wl1	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#go1
	dsjs	a9,#wl1
#go1
	movk	4,a0
	move	a0,@award_ok_to_die,L

	MOVI	ANNC_PID,A0
	CLR	A1
	NOT	A1
	CALLA	KILALL

	movi	25,a0			; Tips every 25 consecutive wins
	move	@p1winstreak,a1		; p1 winstreak ?
	jrnz	#tip_chk		; br = yes
#ck_p2
	move	@p2winstreak,a1		; p2 winstreak ?
	jrz	#ck_mtch_num		; br = no
#tip_chk
	modu	a0,a1			; 25 wins?
	jrz	#do_tip			; br = yes
#ck_mtch_num
	movi	100,a0			; Tips every 100 matches
	move	@match_cnt,a1		; Get match count
	modu	a0,a1			; Time for a tip
	jrnz	#no_tip			; br = no
#do_tip
	CREATE	04000h,show_mk3_tip	; Show a random mk3 tip
	SLEEPK	2
#no_tip

	MOVE	@MUSIC_HAP,A0
	JRNZ	MUSIC_ALREADY_GOING
	CREATE	SOUND_PID,DO_RIGHT_MUSIC2

MUSIC_ALREADY_GOING
	MOVK	2,A0
	move	a0,@match_over
	CALLA	KILL_ALL_CHANNELS
	MOVI	4DH,A0
	CALLA	triple_sound
	clr	a0
	move	a0,@HALT
	DIE

********
* Create game over process and die

 SUBRP	#do_game_over
	CREATE0	do_game_over		;it'll set it's own PROCID
	DIE

********
* Play's a wrestler's music

 SUBRP	DO_RIGHT_MUSIC
	SLEEP	55
 SUBRP	DO_RIGHT_MUSIC2
	MOVK	1,A0
	MOVE	A0,@MUSIC_HAP
	MOVE	*A10(WRESTLERNUM),A11
	SLL	4,A11
	ADDI	#wrestler_tunes,A11
	MOVE	*A11,A3
	calla	SNDSND
	DIE

#wrestler_tunes
	.word	5,2,1,7,6,4,8,0,3

#not_end
	move	@royal_rumble,a14
	jrnz	#no_run_boxes
	JSRP	show_dufus_messages		; Shows run msg (only between rounds)
#no_run_boxes

	;wait 105 ticks or until a press
	movi	105,a9
#wl2	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#go2
	dsjs	a9,#wl2
#go2	;Hey!  REAL programmers don't use go2's!
	;if the dufus msg boxes are on make sure their
	;on for at least 1 second
	move	@dboxes_on,a0,L		; Any dufus msg boxes on?
	jrz	#death_ok		; br = no
	cmpi	50,a9			; Has 1 second passed ?
	jrle	#death_ok		; br = yes
	subi	50,a9			; Give me remainder of 1 second
#dbox_wait
	SLEEPK	1
	dsjs	a9,#dbox_wait
#death_ok
	movk	1,a0
	move	a0,@award_ok_to_die,L

	MOVI	ANNC_PID,A0
	CLR	A1
	NOT	A1
	CALLA	KILALL		;STOP BAR MOTION IF NEED BE

	MOVE	@PSTATUS,A5
	CMPI	3,A5
	JREQ	RESET_HUMAN_VS_HUMAN

	MOVE	*A10(PLYRNUM),A3
	CMPI	2,A3
	JRGE	RESET_HUMAN_VS_HUMAN

	NOT	A5
	SLL	30,A5
	SRL	30,A5
	DEC	A5
	JRUC	WRESTLERS_RESET

HUMAN_WON_IT

RESET_HUMAN_VS_HUMAN
	MOVE	*A10(WHOIHIT),A1,L
	MOVE	*A1(PLYRNUM),A5

WRESTLERS_RESET

;Cause wrestlers to re-appear in the correct spot to start the next round.

	CALLA	CLEAR_SPEECH_REPEAT

	;do new music for the coming round
	MOVE	@current_round,A1
	MOVI	16,A3
	CMPI	2,A1
	JREQ	NOT_THIRD_MATCH
	MOVI	17,A3
NOT_THIRD_MATCH
	CALLA	SNDSND
NO_LOWER
	movk	8,a8
	movk	1,a9
	jsrp	CLOSE_VERT_SCREEN_LINE

	MOVI	LINES_VERT,A1
	MOVE	A1,@WHICH_SCREEN,L

	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
	calla	obj_del1c		;delete text/plates

	movi	ZFLIP_POS,a0
	move	a0,@ZFLIP_POS_VAR,L

	calla	reset_for_round
	calla	reset_for_round2

	movi	TIMER_PID,a0
	movi	-1,a1
	calla	EXISTP
	jrz	dont_update_clock
	pushst
	dint
	push	a13
	move	a0,a13
	calla	update_timer
	movi	WGFS_W_P,a0
	calla	pal_getf
	move	*a13(PDATA+20h),a8,L	;10's image pointer
	move	a0,*a8(OPAL)
	move	*a13(PDATA),a8,L	;10's image pointer
	move	a0,*a8(OPAL)
	pull	a13
	popst
dont_update_clock

;Update the meters
	clr	a0
	MOVE	A0,@DAM_MULT
	callr	update_meter
	movk	1,a0
	callr	update_meter

	;reset the scroller position
	calla	init_scroller

	calla	INIT_SKIRTS

	calla	BGND_UD1

;Now display "round 2" or "round 3"

	CREATE	SOUND_PID,ring_bell

	movk	1,a0
	move	a0,@HALT

	SLEEPK	1
	calla	BGND_UD1
	CREATE	SKIRT_PID,CHANGE_SKIRTS2

	SLEEPK	1
	calla	BGND_UD1
;	CREATE	SKIRT_PID,CHANGE_SKIRTS2

	SLEEPK	1


	movk	8,a8
	movk	1,a9
	jsrp	OPEN_VERT_SCREEN_LINE

	CREATE	ANNC_PID,DO_ROUNDS

	SLEEP	50
	CALLA	VINCE_START_ROUND2_3
	clr	a0
	move	a0,@HALT
	SLEEP	40

	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
	calla	obj_del1c		;delete text/plates

	movi	CLSNEUT|TYPTEXT|SUBTXT,a0
	calla	obj_del1c		;delete text/plates

	clr	a0
	move	a0,@HALT

	;reset round_start_time
	move	@PCNT,a14,L
	move	a14,@round_start_time,L
	

	DIE

******************************************************************************

 SUBRP	DO_ROUNDS
	movi	[200,0],a0			;x pos
	movi	[255,0],a1			;y pos
	movi	RNDPLAT,a2
	movi	RNDPLT_P,b0
	movi	1800h,a3				;z pos
	callr	#begin_obj

	clr	a0
	move	a0,*a8(OID)

	PUSH	A8

	move	@current_round,a0
	MOVI	RNDNUM_1,A2
	DEC	A0
	JRZ	#OKAY
	MOVI	RNDNUM_2,A2
	DEC	A0
	JRZ	#OKAY
	MOVI	RNDNUM_3,A2
	DEC	A0
	JRZ	#OKAY
	MOVI	RNDNUM_4,A2
#OKAY
	movi	[200,0],a0			;x pos
	movi	[255,0],a1			;y pos
	movi	RNDNUM_P,b0
	movi	1801h,a3				;z pos
	callr	#begin_obj

	clr	a0
	move	a0,*a8(OID)

	PULL	A9

	MOVK	20,A10
LOOP_ROUNDS_ON
	MOVI	[190,0],A0
	CALLR	ZIP_ROUNDS_ON
	SLEEPK	1
	DSJS	A10,LOOP_ROUNDS_ON
	movk	20,a10
	JSRP	wait_on_butn
	MOVK	20,A10
LOOP_ROUNDS_OFF
	MOVI	[300,0],A0
	CALLR	ZIP_ROUNDS_ON
	SLEEPK	1
	DSJS	A10,LOOP_ROUNDS_OFF

	calla	DELOBJA8
	move	a9,a0
	calla	DELOBJ
	DIE

ZIP_ROUNDS_ON
	move	*a8(OYVAL),a1,L
	sub	a1,a0
	sra	3,a0
	move	*a8(OYVAL),a2,L
	add	a0,a2
	move	a2,*a8(OYVAL),L
	move	*a9(OYVAL),a2,L
	add	a0,a2
	move	a2,*a9(OYVAL),L
	RETS

#set_x
	movi	ram_lst,a11
	move	*a11,a8,L
	move	*a8(OXVAL),a1,L
	sub	a1,a0
	sra	3,a0
#lp5
	move	*a11+,a8,L
	jrz	#x4
	move	*a8(OXVAL),a2,L
	add	a0,a2
	move	a2,*a8(OXVAL),L

	jruc	#lp5
#x4
	rets

#begin_obj

	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	CLSNEUT|TYPTEXT|SUBTXT,a5
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJP
	rets

blink_text
	SLEEPK	10
#lp1
	movi	SGMD8RED2,a0
	calla	pal_getf
	move	a0,*a8(OPAL)
	SLEEPK	4
	movi	SGMD8WHT2,a0
	calla	pal_getf
	move	a0,*a8(OPAL)
	SLEEPK	7
	jruc	#lp1

*******************************************************************************

 SUBR	FIRSTATT_MESS

	move	a10,a0
	movi	FIRSTATT,a8
	move	*a0(PLYR_SIDE),a9
	clr	a10
	pushp	a10
	movi	1801h,a11
	
	jruc	#common

 SUBR	BONUS_MESS

;Process which displays high risk - 2x damage & possibly move name
;This comes in from Secret button moves
;A8=* plyr proc of who fired off the move
;A10=# of move message
;Messages display the first time only

	clr	a14
	move	a10,a10			;No message
	jrz	#already
	jrnn	#reg

#tag
;Taunt style high risk move - give 3x dmg
	PUSHP	a14

;	movk	3,a1
;	move	a1,@DAM_MULT

	RND_AWARD	a8,HIGH_RISK_AWD	; give award for high risk

	move	*a8(PLYR_SIDE),a9
	MOVI	HIGHRISK,A8
	CLR	A10
	MOVI	1801H,A11

	CREATE0	MAYBE_HIGH_RISK

	callr	is_there_one_already
	jrnz	#exit

	CREATE	MESSAGE_PID,SPECIAL_MESSAGE

	MOVI	0BBH,A0			;Guitar snd
	CALLA	triple_sound

	SLEEP	50

	movk	4,a10
	jruc	#inhere
#reg

	move	*a8(RISK),a1
	btst	15,a1
;Taunt style high risk move - give 3x dmg
	jrnz	#tag



	move	a10,a3
	movi	message_flag,a2
	cmpi	32,a3
	jrlt	normal_thing2
	addi	32,a2
	subi	32,a3
normal_thing2
	move	*a2,a0,L
	btst	a3,a0
	jrnz	#already
;Set the bit which says I've been displayed already!
	movk	1,a1
	sll	a3,a1
	or	a1,a0
	move	a0,*a2,L

	sll	5,a10
	addi	#message_tbl,a10
	move	*a10,a14,L
#already
	PUSHP	a14


;	movk	2,a1
;	move	*a8(RISK),a14
;	btst	15,a14
;	jrz	#reg2
;
;;Taunt style high risk move - give 3x dmg
;	movk	4,a1
;#reg2	move	a1,@DAM_MULT

	movk	2,a1
	move	a1,@DAM_MULT

	RND_AWARD	a8,HIGH_RISK_AWD	; give award for high risk

	move	*a8(PLYR_SIDE),a9
	MOVI	HIGHRISK,A8
	CLR	A10
	MOVI	1801H,A11

	CREATE0	MAYBE_HIGH_RISK

#common	
	callr	is_there_one_already
	jrnz	#exit

	CREATE	MESSAGE_PID,SPECIAL_MESSAGE

	MOVI	0BBH,A0			;Guitar snd
	CALLA	triple_sound

	SLEEP	50

	movk	2,a10
#inhere	MOVI	xDAMAGE,A8
	MOVI	1803H,A11

	CREATE	MESSAGE_PID,SPECIAL_MESSAGE

;Wait for 2x to leave
;Try to print correct move name
	SLEEP	50

;Get back message img addr to display
	PULLP	a8
	jaz	SUCIDE

	callr	DO_THIS_MESS
	DIE

 SUBRP	is_there_one_already
	MOVE	A9,A1
	NOT	A1
	SLL	31,A1
	SRL	31-4,A1
	ADDI	MESSAGE_FLAGS,A1
	MOVE	*A1,A0
	rets

SET_MESS_FLAGS
	MOVE	A9,A1
	NOT	A1
	SLL	31,A1
	SRL	31-4,A1
	ADDI	MESSAGE_FLAGS,A1
	MOVE	A0,*A1
	RETS

*******************************************************************************

 SUBR	MOVE_NAME_ANNC

;Process which displays move name
;This comes in from actual script - like a hip toss announce
;A8=* plyr proc of who fired off the move
;A10=# of move message
;Messages display the first time only

	cmpi	41,a10
	jrz	#skip

	move	@reduce_bog,a14
	jrnz	#exit
#skip
	move	*a8(PLYR_SIDE),a9

	callr	is_there_one_already
	jrnz	#exit

	move	a10,a3
	movi	message_flag,a2
	cmpi	32,a3
	jrlt	normal_thing
	addi	32,a2
	subi	32,a3
	cmpi	9,a3
	jrz	#cont
normal_thing
	move	*a2,a0,L
	btst	a3,a0
	jrnz	#exit
;Set the bit which says I've been displayed already!
	movk	1,a1
	sll	a3,a1
	or	a1,a0
	move	a0,*a2,L
#cont
	sll	5,a10
	addi	#message_tbl,a10
	move	*a10,a8,L

	callr	DO_THIS_MESS

#exit
	DIE

;Add new move img names here:
#message_tbl
	.long	0		;0 = Blank
	.long	HEADSLAM	;1
	.long	0        	;2
	.long	SNAPMIRR	;3
	.long	FRANKEN		;4 *
	.long	BACKBRKR	;5
	.long	BODYSLAM	;6
	.long	PILEDRV		;7
	.long	FIRSTATT	;8  ; saved for Jason
	.long	ARMBREAK	;9	*
	.long	ARMDRAG		;10	*  ;RAZOR & HART HIP TOSS
	.long	BACKDROP	;11	*  ;BAM BAM HIP TOSS
	.long	BACKSUPL	;12	*  ;SHAWN MICHEALS
	.long	BANZAI		;13	*
	.long	BEHMBUTT	;14	*  ;BAM BAM RUNNING BUTT DROP
	.long	CROSFIRE	;15	*
	.long	DDT		;16	*
	.long	DOBLSNAP	;17	*  ;SHAWN KICK
	.long	ELBOWDRP	;18	   ;EVERYBODY MOSTLY
	.long	EYERAKER	;19	*
	.long	FACESLAM	;20	*
	.long	FIRESPL		;21	*  ;BAM BAM OFF TURNBUCKLES
	.long	CLAPPER       	;22	*  ;DOINK
	.long	FLYBUTT		;23	   ?
	.long	FLYCLOTH	;24	*
	.long	HAMMER		;25	*
	.long	HIPTOSS		;26	*  ;LEX YOKO
	.long	BIGBOOT		;27	*  ;EVERYBODY
	.long	JOYBUZZ		;28	*
	.long	MYSTGLVE	;29	;
	.long	NAPALM		;30	;
	.long	POGOPILE	;31	*
	.long	RAPIDRND	;32	*
	.long	RAZOREDG	;33	*
	.long	SCISSOR		;34	*  ;YOKO
	.long	SKULLCRK	;35	*
	.long	SLMONKEY	;36	*
	.long	SPEEDKIK	;37	*
	.long	SPLASH		;38	   ;BAMBAM TURNBUCKLE DROP, EVENTUALLY
	.long	SUNSETFL	;39	*  ;SHAWN FLIP
	.long	TOMBPLDR	;40	*
	.long	SECWND09       	;41	   
	.long	VERTSUPL	;42	*   ;YOKO LEX

*******************************************************************************

DO_THIS_MESS
;a8=*message to print
;a9=0 or 1

	;if this is the second wind message, skip the permission check
	cmpi	SECWND09,a8
	jreq	#skip_perm_check

	;no messages in no-bog mode?
	move	@no_debris,a14
	jrnz	NO_MORE_MESS

	move	a9,a0
	sll	5,a0
	addi	p1powerup_request,a0
	move	*a0,a0,L
	btst	MOVE_NAMES_ON_BIT,a0
	jrz	NO_MORE_MESS
#skip_perm_check

;Don't allow overlaps!
	CLR	A10

	MOVI	1805H,A11		;1801

	CREATE	MESSAGE_PID,SPECIAL_MESSAGE

	MOVI	0BBH,A0			;Move name annc snd
	CALLA	triple_sound

NO_MORE_MESS
	RETS


*******************************************************************************

 SUBR	DO_REVERSAL_MESS
	RND_AWARD a8,REVERSAL_AWD		; give award for reversal
	movi	15Ch,a0
	calla	ADD_VOICE

	move	*a8(PLYR_SIDE),a9
	CREATE	MESSAGE_PID,CREATE_REVERSAL_MESS
	RETS

 SUBRP	CREATE_REVERSAL_MESS	;process

	callr	is_there_one_already
	jrnz	exit_reversal

	MOVI	REVERS,A8
	CLR	A10
	MOVI	1801H,A11

	CREATE	MESSAGE_PID,SPECIAL_MESSAGE

	MOVI	0BBH,A0
	CALLA	triple_sound

exit_reversal
	DIE

#****************************************************************************
* Returns process ptr to first wrestler we can find who's trying a buckoff.

 SUBR	anyone_bucking

	;no buckoffs allowed in royal rumble mode
	move	@royal_rumble,a14
	jrnz	#no

	movi	process_ptrs,a0
	movi	NUM_WRES,a1
#lp	move	*a0+,a2,L
	jrz	#nxt
	move	*a2(STATUS_FLAGS),a14,L
	btst	B_DO_BUCKOFF,a14
	jrz	#nxt
	btst	B_NEW_BUCKOFF,a14
	jrnz	#yes
	btst	B_DID_BUCKOFF,a14
	jrnz	#nxt
#yes	move	a2,a0
	rets

#nxt	dsj	a1,#lp
#no	clr	a0
	rets

#****************************************************************************
* Sets everyone's NO_BUCKOFF flag.

 SUBRP	set_all_buckoffs

	movi	process_ptrs,a0
	movi	NUM_WRES,a1
#lp	move	*a0+,a2,L
	jrz	#nxt
	move	*a2(STATUS_FLAGS),a14
	ori	M_NO_BUCKOFF,a14
	move	a14,*a2(STATUS_FLAGS)
#nxt	dsj	a1,#lp
	rets

#****************************************************************************
*
* Returns carry set if everyone on winning team is unharmed.
* Exception:  Never returns C if final match.
*
* >a10 = proc of a wrestler on the winning team (anyone will do)
*

 SUBRP	is_perfect

	calla	is_8_on_1
	jrc	#final

	PUSH	a2,a3,a4,a5

	move	*a10(PLYR_SIDE),a5
	movi	NUM_WRES,a2
	movi	process_ptrs,a3

#lp	move	*a3+,a4,L
	jrz	#nxt		;skip inactive

	move	*a4(PLYR_SIDE),a14
	cmp	a5,a14
	jrne	#nxt		;skip enemies

	move	*a4(PLYRNUM),a1
	callr	get_health
	cmpi	LIFE_MAX,a0
	jreq	#nxt		;okay - unharmed

	;injured guy found.  return !c
	PULL	a2,a3,a4,a5
#final	clrc
	rets

#nxt	dsj	a2,#lp

	;no injured teammates found.  return c
	PULL	a2,a3,a4,a5
	setc
	rets

#*****************************************************************************

 SUBR	DO_COMBO_MESS

;Combo messages come from the scripts

	MOVE	@combo_audit_done,A0
	JRNZ	YES_WE_HAVE
	movi	AUD_COMBO,A0
	calla	AUD1
	MOVK	1,A0
	MOVE	A0,@combo_audit_done
YES_WE_HAVE

	;if our combo_broken bit is set, blow out of here altogether.
	; We audit it, but we don't adjust the bar or display any kind of
	; message.
	move	*a13(STATUS_FLAGS),a14,L
	btst	B_COMBO_BROKEN,a14
	jrnz	#rets

	MOVE	*A13(PLYRNUM),A9
	MOVI	HITCOMBO,A8
	MOVE	*A13(COMBO_COUNT),A10
	DEC	A10
;We need to announce even the lowly combos
;How can you have a combo of 1 ?????
	CMPI	2,A10
	JRLT	NO_MESSAGE


	cmpi	10,a10
	jrlt	#award_reg_combo
	RND_AWARD	a13,UCOMBOS_AWD
	jruc	#combo_awd_done
#award_reg_combo
	RND_AWARD	a13,COMBOS_AWD	; give award for combo started
#combo_awd_done

	MOVI	0BAH,A0		;0BAH humbug!
	CALLA	triple_sound

	MOVI	01A4H,A0	;INCREDIBLE COMBINATION MOVE !
	CALLA	ADD_VOICE

;Add a couple for a better appearance!
	CMPI	5,A10
	JRLE	NO_MIGHT_BE_OBVIOUS
	addk	2,a10
NO_MIGHT_BE_OBVIOUS

	MOVI	1803H,A11

	move	*a13(PLYR_SIDE),a9

;Don't allow combo message to come out if other message there...
	callr	is_there_one_already
	jrnz	NO_MESSAGE

	CREATE	MESSAGE_PID,SPECIAL_MESSAGE

NO_MESSAGE

	;HACK ALERT:  In royal rumble, the two human players share one combo
	; meter.  This means that if player 1 (on the right) calls this,
	; we clear HIS combo count but we zero his TEAMMATES bar.
	; Confusing, eh?

	CLR	A0
	MOVE	A0,*A13(COMBO_START)

	move	*a13(PLYR_SIDE),a1
	move	*a13(PLYRNUM),a11

	cmpi	1,a11
	jrne	#norum
	move	@royal_rumble,a14
	jrz	#norum

	;pretend we're player 0
	clr	a1		;side
	clr	a11		;PLYRNUM


;clear_combo_meter jumps here!
 SUBRP	zero_combo_meter

#norum	movi	MD_SIZE,a9
	mpyu	a1,a9
	addi	meter_data,a9
	MOVE	*A9(MD_COMBO),A8,L
	move	a11,a5
	X64	a5		;x by PLT_SIZE
	ADDI	life_data,A5
	CLR	A2

;halve_combo_meter jumps here!
 SUBRP	draw_combo_meter

	MOVE	A2,*A5(PLT_COMBO_SIZE)
	SLL	5,A2
	ADDI	WHICH_SIZE_BAR,A2
	MOVE	*A2,A0,L
	move	*a0(IANIOFF),*A8(ODOFF),L
	move	*a0(ISAG),*a8(OSAG),L
	MOVE	*A0(ISIZEX),*A8(OSIZE),L

	PUSH	A0,a1
	MOVE	A1,A0
	SLL	4,A0
	ADDI	COMBO_FLASH_FLAG,A0
	CLR	A2
	MOVE	A2,*A0

	ADDI	FLASH_COMBO_PID,A1
	MOVE	A1,A0
	MOVI	-1,A1
	CALLA	KILALL
	PULL	A0,a1

	;get the flip right
	sll	B_FLIPH,a1
	move	*a0(ICTRL),a14
	or	a1,a14
	ori	8000H|DMAWNZ,a14
	move	a14,*a8(OCTRL)

	MOVI	SUPER_P,A0
	CALLA	pal_getf
	MOVE	A0,*A8(OPAL)

NO_GO_AWAY
#rets	RETS

*******************************************************************************
*

 SUBRP	SPECIAL_MESSAGE

ZIP_SPEED	.EQU	18H
BUFF		.EQU	25

;A8=IMAGE TO PLACE UP
;A9=WHICH SIDE (1 OR 2)
;A10=NUMBER OF BONUS MULTIPLIER 2-5 (IF NECESSARY)
;A11=ZPOS TO PLACE BLOCK (SO DAMAGE x GOES OVER OTHER)

	MOVK	1,A0
	CALLR	SET_MESS_FLAGS
	PUSHP	A9

	NOT	A9
	SLL	31,A9
	SRL	31,A9

	MOVI	10H,A0	    			;Whoosh
	CALLA	triple_sound

	MOVE	A11,B5
	CLR	A11
	MOVE	A8,A2
	MOVE	*A2(ISIZEX),A3
	CMPI	xDAMAGE,A2
	JREQ	SPECIAL_CASE_THIS
	CMPI	HITCOMBO,A2
	JRNE	ONLY_THIS_SIZE
SPECIAL_CASE_THIS
	ADDI	19,A3
	MOVE	A10,A0
	CALLA	BINBCD
	MOVE	A0,A10
	MOVE	A10,A11
	SRL	4,A11
	JRZ	ONLY_THIS_SIZE
	MOVI	HITCOMBO2,A2
	ADDI	21,A3
	CMPI	1,A11
	JRNE	ONLY_THIS_SIZE
	SUBI	4,A3
ONLY_THIS_SIZE
	MOVI	TYPE_MESS2,A5
	ADDI	BUFF*2,A3
	MOVI	410,A0
	MOVE	A0,A7
	SUB	A3,A7
	SLL	16,A7
	DEC	A9
	JRNZ	WE_SET_XPOS
	MOVI	TYPE_MESS1,A5
	MOVE	A3,A0
	NEG	A0
	MOVI	[BUFF,0],A7
	ADDK	BUFF,A0
WE_SET_XPOS
	SLL	16,A0
	MOVE	A0,*A13(PDATA+120H),L
	MOVE	A7,*A13(PDATA+100H),L
	MOVI	[230+4,0],A1
	MOVE	B5,A3
	ADDK	1,A3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags

	CLR	A6
	CLR	A7
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9,A10
	calla	BEGINOBJ


	move	*a8(OIMG),a0,L
	cmpi	SECWND09,a0
	jrnz	#nospec
;We need to animate this second wind message

	CREATE0	flash_2ndwind
#nospec


	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9,A10
	PUSH	A8

	MOVI	WHICH_BONUS_2,A14
	CMPI	xDAMAGE,A2
	JREQ	WE_HAVE_NUMBERS
	CMPI	HITCOMBO,A2
	JREQ	WE_HAVE_NUMBERS
	MOVI	WHICH_BONUS_1,A14
	CMPI	HITCOMBO2,A2
	JRNE	NO_NEED_FOR_THIRD_OBJ
WE_HAVE_NUMBERS
	SLL	32-4,A10
	SRL	32-4-5,A10		;*32
	ADD	A14,A10
	MOVE	*A10,A2,L
	MMTM	SP,A0,A1,A3,A4,A5,A6,A7,A11
	calla	BEGINOBJ
	MMFM	SP,A0,A1,A3,A4,A5,A6,A7,A11
	MOVE	A8,A10

	MOVE	A11,A7
	SLL	32-4,A7
	JRZ	NO_NEED_FOR_THIRD_OBJ
	SRL	32-4-5,A7		;*32
	ADDI	WHICH_BONUS_2,A7
	MOVE	*A7,A2,L
	CLR	A7
	MMTM	SP,A0,A1,A5,A6,A7
	CMPI	1,A11
	JRNE	NO_REPOS_THIS_NUM
	ADDI	[4,0],A0
NO_REPOS_THIS_NUM
	calla	BEGINOBJ
	MMFM	SP,A0,A1,A5,A6,A7
	MOVE	A8,A11
NO_NEED_FOR_THIRD_OBJ

	MOVE	*A8(OSIZEX),A2
	MOVI	395,A3
	SUB	A2,A3
	SUBI	BUFF,A3
	SLL	16,A0
	SUB	A3,A0
	MOVI	MVEBAR_B,A2
	movi	DMAWNZ|M_FLIPH|M_3D|M_SCRNREL,a4	;DMA flags
	MOVE	A9,A9
	JRZ	BAR_SET
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	MOVI	MVEBAR_R,A2
	MOVE	*A8(OXVAL),A0,L
	SUBI	[BUFF,0],A0
BAR_SET
	MOVE	B5,A3
	calla	BEGINOBJ
	MOVE	A8,A9
	PULL	A8

	MOVI	ZIP_SPEED,A3
MOVE_IT_ON
	MOVE	*A13(PDATA+100H),A0,L
	CALLR	MOVE_BARS
	PUSHP	A3
	SLEEPK	1
	PULLP	A3
	DSJS	A3,MOVE_IT_ON

	SLEEP	50

	MOVI	ZIP_SPEED,A3
MOVE_IT_OFF
	MOVE	*A13(PDATA+120H),A0,L
	SLA	1,A0
	CALLR	MOVE_BARS
	PUSHP	A3
	SLEEPK	1
	PULLP	A3
	DSJS	A3,MOVE_IT_OFF

	CALLA	DELOBJA8
	MOVE	A9,A8
	CALLA	DELOBJA8
	MOVE	A10,A8
	JRZ	NO_A10_3
	CALLA	DELOBJA8
NO_A10_3
	MOVE	A11,A8
	JRZ	NO_A11_3
	CALLA	DELOBJA8
NO_A11_3
	PULLP	A9
	CLR	A0
	CALLR	SET_MESS_FLAGS

	DIE

MOVE_BARS
	PUSH	A8
	MOVE	*A8(OXVAL),A1,L
	SUB	A1,A0
	SRA	3,A0

	CALLR	MOVE_THIS_PART
	MOVE	A9,A8
	JRZ	NO_A11_PART
	CALLR	MOVE_THIS_PART
	MOVE	A10,A8
	JRZ	NO_A10_PART
	CALLR	MOVE_THIS_PART
NO_A10_PART
	MOVE	A11,A8
	JRZ	NO_A11_PART
	CALLR	MOVE_THIS_PART
NO_A11_PART
	PULL	A8
	RETS

MOVE_THIS_PART
	MOVE	*A8(OXVAL),A2,L
	ADD	A0,A2
	MOVE	A2,*A8(OXVAL),L
	RETS

WHICH_BONUS_2
	.LONG	X0X,X1X,X2X
	.LONG	X3X,X4X,X5X
	.LONG	X6X,X7X,X8X
	.LONG	X9X

WHICH_BONUS_1
	.LONG	X0X2,X1X2,X2X2
	.LONG	X3X2,X4X2,X5X2
	.LONG	X6X2,X7X2,X8X2
	.LONG	X9X2

Z_FORWARD	.EQU	1800H

 SUBR	SHIFT_BARS_IN_Z
	CLR	A0
	MOVE	A0,@LAST_FLIP
SHIFT_BARS_IN_Z_MOTION
	MOVE	@WORLDTLY,A0,L
	MOVE	@ZFLIP_POS_VAR,A1,L
	CMP	A1,A0
	JRLT	CHECK_IF_WE_ALREADY_FLIPPED_BACK

	MOVE	@LAST_FLIP,A0
	JRNZ	YES_WE_DID
	MOVK	1,A0
	MOVE	A0,@LAST_FLIP
	CALLR	SHIFT_BARS_FORWARD
	SLOOP	4,SHIFT_BARS_IN_Z_MOTION

CHECK_IF_WE_ALREADY_FLIPPED_BACK
	MOVE	@LAST_FLIP,A0
	JRZ	YES_WE_DID
	CLR	A0
	MOVE	A0,@LAST_FLIP
	CALLR	SHIFT_BARS_BACK
YES_WE_DID
	SLOOP	4,SHIFT_BARS_IN_Z_MOTION

SHIFT_BARS_FORWARD
	movi	OBJLST,a8
	movi	bak_z,A2
	movi	name_z,A3
	movi	Z_FORWARD,A4
	JRUC	DONT_SHIFT_IT_FORWARD
STILL_MORE_TO_CHECK
	MOVE	*A8(OZPOS),A1
	CMP	a2,A1
	JRLT	DONT_SHIFT_IT_FORWARD
	CMP	a3,A1
	JRGT	DONT_SHIFT_IT_FORWARD
SHIFT_IT_FORWARD
	ADD	a4,A1
	MOVE	A1,*A8(OZPOS)
DONT_SHIFT_IT_FORWARD
	MOVE	*A8,A8,L
	JRNZ	STILL_MORE_TO_CHECK
	RETS

SHIFT_BARS_BACK
	movi	OBJLST,a8
	movi	bak_z+Z_FORWARD,A2
	movi	name_z+Z_FORWARD,A3
	movi	Z_FORWARD,A4
	JRUC	DONT_SHIFT_IT_BACK
STILL_MORE_TO_CHECK_B
	MOVE	*A8(OZPOS),A1
	CMP	a2,A1
	JRLT	DONT_SHIFT_IT_BACK
	CMP	a3,A1
	JRGT	DONT_SHIFT_IT_BACK
SHIFT_IT_BACK
	SUB	a4,A1
	MOVE	A1,*A8(OZPOS)
DONT_SHIFT_IT_BACK
	MOVE	*A8,A8,L
	JRNZ	STILL_MORE_TO_CHECK_B
	RETS

END_BUFF	.equ	10
END_POS	.EQU	30
END_YPOS	.EQU	80
TURM_OFF	.EQU	4

WHICH_ROUND
	.LONG	FIRSTFAL,SECNDFAL,MATCHFAL

CREATE_END_ROUND_TOP
	SLL	5,A9
	ADDI	WHICH_ROUND,A9
	MOVE	*A9,A2,L

	CLR	A1
	MOVE	A1,*A13(PDATA+140),L

	MOVI	[END_POS+150+TURM_OFF,0],A1
	MOVI	[400+END_BUFF+150+TURM_OFF,0],A0
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	MOVE	A11,A11
	JRNZ	WHICH_TEXT_SET
	MOVI	[400-END_POS-150,0],A1
	MOVI	[0-END_BUFF-150,0],A0
WHICH_TEXT_SET
	MOVE	A1,*A13(PDATA+100H),L
	MOVI	[END_YPOS,0],A1
	MOVI	1803H,A3
	MOVI	CLSNEUT|TYPTEXT|SUBMES1,A5
	CLR	A6
	CLR	A7
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7
	calla	BEGINOBJ
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7
	MOVE	A8,A9

	MOVI	[END_POS+TURM_OFF,0],A1
	MOVI	[400+END_BUFF+TURM_OFF,0],A0
	MOVI	MVEBAR_R,A2
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	MOVE	A11,A11
	JRNZ	WHICH_BAR_SET
	MOVI	[400-END_POS,0],A1
	MOVI	[0-END_BUFF,0],A0
	movi	DMAWNZ|M_FLIPH|M_3D|M_SCRNREL,a4	;DMA flags
	MOVI	MVEBAR_B,A2
WHICH_BAR_SET
	MOVE	A1,*A13(PDATA+120H),L
	MOVI	[END_YPOS,0],A1
	MOVI	1800H,A3
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9
	calla	BEGINOBJ
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9
	CLR	A0
	MOVE	A0,*A13(PDATA+140H),L
	JSRP	ZIP_HIM_ON
	DIE

WHICH_WRESTLE_NAME
	.LONG	BIGHRT
	.LONG	BIGRAZ
	.LONG	BIGUND
	.LONG	BIGYOK
	.LONG	BIGSHN
	.LONG	BIGBAM
	.LONG	BIGDNK
	.LONG	0
	.LONG 	BIGLEX

CREATE_END_ROUND_BOT
	MOVE	*A10(WRESTLERNUM),A2
	SLL	5,A2
	ADDI	WHICH_WRESTLE_NAME,A2
	MOVE	*A2,A2,L

	MOVI	[END_POS+150+TURM_OFF,0],A1
	MOVI	[400+END_BUFF+150+TURM_OFF,0],A0
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	MOVE	A11,A11
	JRNZ	ON_LEFT
	MOVI	[400-END_POS-150,0],A1
	MOVI	[0-END_BUFF-150,0],A0
ON_LEFT
	MOVE	A1,*A13(PDATA+100H),L
	MOVI	[END_YPOS+25,0],A1
	MOVI	1802H,A3
	MOVI	CLSNEUT|TYPTEXT|SUBMES1,A5
	CLR	A6
	CLR	A7
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7
	movi	WGSF_W_P1,b0
;	calla	BEGINOBJ
	calla	BEGINOBJP
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7
	MOVE	A8,A9

	MOVI	[END_POS+TURM_OFF,0],A1
	MOVI	AWDNMPL_R,A2
	MOVI	[400+END_BUFF+TURM_OFF,0],A0
	MOVE	A11,A11
	JRNZ	ON_LEFT2
	MOVI	[400-END_POS,0],A1
	MOVI	[0-END_BUFF,0],A0
	MOVI	AWDNMPL_B,A2
	movi	DMAWNZ|M_FLIPH|M_3D|M_SCRNREL,a4	;DMA flags
ON_LEFT2
	MOVE	A1,*A13(PDATA+120H),L
	MOVE	A1,*A13(PDATA+140H),L
	MOVI	[END_YPOS,0],A1
	DEC	A3
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9
	calla	BEGINOBJ
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9

	PUSH	A8
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	MOVI	DIAGLGO_R,A2
	MOVE	A11,A11
	JRNZ	ON_LEFT3
	MOVI	DIAGLGO_B,A2
ON_LEFT3
	INC	A3
	calla	BEGINOBJ
	MOVE	A8,A10
	PULL	A8
	JSRP	ZIP_HIM_ON
	DIE

ZIP_HIM_ON
	MOVI	ZIP_SPEED,A3
MOVE_END_ON
	MOVE	*A13(PDATA+140H),A0,L
	JRZ	NOTHING_IN_A10
	PUSH	A8
	MOVE	A10,A8
	CALLR	MOVE_THIS
	PULL	A8
NOTHING_IN_A10
	MOVE	*A13(PDATA+100H),A0,L
	JRZ	NOTHING_IN_A9
	PUSH	A8
	MOVE	A9,A8
	CALLR	MOVE_THIS
	PULL	A8
NOTHING_IN_A9
	MOVE	*A13(PDATA+120H),A0,L
	CALLR	MOVE_THIS
	PUSHP	A3
	SLEEPK	1
	PULLP	A3
	DSJS	A3,MOVE_END_ON
	RETP

MOVE_THIS
	MOVE	*A8(OXVAL),A1,L
	SUB	A1,A0
	SRA	3,A0
	JRUC	MOVE_THIS_PART


END_IPOS1	.EQU	332
END_IPOS2	.EQU	292
END_IYPOS	.EQU	54

CREATE_END_ROUND_ICON

	.ref	wrestler_count_proc
	.ref	wrestler_count

	move	@wrestler_count_proc,a0,L	; Does the counter proc exist ?
	jrz	#no_wc_proc			; br = no

;	move	@wrestler_count,a14		; Current count == 0 ?
;	jrz	#no_wc_proc			; br = yes
;	dec	a14				; Decrement it
	clr	a14
	move	a14,@wrestler_count		; Write it back

	movk	1,a14				; Make counter proc wakeup on next tick
	move	a14,*a0(PTIME)
#no_wc_proc



	MOVI	[END_IPOS1+30,0],B4
	MOVI	[400-END_IPOS1-30,0],B5
	MOVI	[END_IPOS1,0],B6
	MOVI	[400-END_IPOS1,0],B7

	MOVE	@p1rounds,a1
	MOVE	A11,A11
	JRZ	GOT_RIGHT_SIDE
	MOVE	@p2rounds,a1
GOT_RIGHT_SIDE
	DEC	A1
	JRZ	DO_THE_RIGHT_ROUND

	MOVI	[END_IPOS2+30,0],B4
	MOVI	[400-END_IPOS2-30,0],B5
	MOVI	[END_IPOS2,0],B6
	MOVI	[400-END_IPOS2,0],B7
DO_THE_RIGHT_ROUND

	CLR	A1
	MOVE	A1,*A13(PDATA+140),L

	MOVI	WWFICON10,A2
	MOVE	B4,A1
	MOVI	[400+END_BUFF+150,0],A0
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	MOVE	A11,A11
	JRNZ	WHICH_ICON_SET
	MOVE	B5,A1
	MOVI	[0-END_BUFF-150,0],A0
WHICH_ICON_SET
	MOVE	A1,*A13(PDATA+100H),L
	MOVI	[END_IYPOS,0],A1
	MOVI	1800h+200,A3
	MOVE	@WORLDTLY,A5,L
	MOVE	@ZFLIP_POS_VAR,A6,L
	CMP	A6,A5
	JRGE	IN_FORWARD_POS
	MOVI	200,A3
IN_FORWARD_POS
	movi	DMAWNZ|M_3D|M_SCRNREL,a4		;DMA flags
	movi	TYPWWFICON,a5
	CLR	A6
	CLR	A7
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9
	calla	BEGINOBJ
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9
	MOVE	A8,A9

	MOVE	B6,A1
	MOVI	[400+END_BUFF,0],A0
	MOVI	MVEBAR_R,A2
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	MOVE	A11,A11
	JRNZ	WHICH_BAR2_SET
	MOVE	B7,A1
	MOVI	[0-END_BUFF,0],A0
	movi	DMAWNZ|M_FLIPH|M_3D|M_SCRNREL,a4	;DMA flags
	MOVI	MVEBAR_B,A2
WHICH_BAR2_SET
	MOVE	A1,*A13(PDATA+120H),L
	MOVE	A0,*A13(PDATA+160H),L
	MOVI	[END_IYPOS,0],A1
	MOVI	1800h+199,A3
	MOVE	@WORLDTLY,A5,L
	MOVE	@ZFLIP_POS_VAR,A6,L
	CMP	A6,A5
	JRGE	IN_FORWARD_POS2
	MOVI	199,A3
IN_FORWARD_POS2
	MOVI	CLSNEUT|TYPTEXT|SUBMES1,A5
	CLR	A6
	CLR	A7
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7
	calla	BEGINOBJ
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7

	JSRP	ZIP_HIM_ON
	SLEEP	20
	MOVI	ICON_PID,A1
	ADD	A11,A1
	CALLA	FIND_ANY_OTHERS
	MOVI	4DH,A0
	CALLA	triple_sound
	MOVI	MAKE_ICON_GLOW,A7
	CALLA	GETPRC
	MOVE	A9,A11
	CLR	A9
	MOVE	A9,*A13(PDATA+100),L
	MOVE	*A13(PDATA+160H),*A13(PDATA+120H),L
	JSRP	ZIP_HIM_ON

	MOVE	A11,A8

	CREATE	FLASH_PID,MAYBE_A_SPARKLE
	DIE

MAKE_ICON_GLOW
	MOVE	A9,A8
	MOVI	WWF_ICON_ANIM,A1
	CALLA	setup_back_anim
	JSRP	ANIM_CROWD
	SLEEP	TSEC*10
	JRUC	MAKE_ICON_GLOW

FIND_ANY_OTHERS
	PUSH	A1
	MOVE	A1,A0
	MOVI	-1,A1
	CALLA	EXISTP
	JRZ	NO_MORE
	MOVK	1,A1
	MOVE	A1,*A0(PTIME)
NO_MORE
	PULL	A1
	RETS

CANI_END		equ	2 + 8000H

WWF_ICON_ANIM
	WL	2,WWFICON01
	WL	2,WWFICON02
	WL	2,WWFICON03
	WL	2,WWFICON04
	WL	2,WWFICON05
	WL	2,WWFICON06
	WL	2,WWFICON07
	WL	2,WWFICON08
	WL	2,WWFICON09
	WL	2,WWFICON10
	.WORD	CANI_END

MAYBE_A_SPARKLE
	MOVI	120,A0
	CALLA	RNDRNG0
	ADDI	50,A0
	CALLA	PRCSLP
	CREATE	FLASH_PID,ICON_SPARKLE
	JRUC	MAYBE_A_SPARKLE

 SUBRP	ICON_SPARKLE

	move	@reduce_bog,a14
	jrnz	#die

	MOVK	6,A0
	CALLA	RNDRNG0
	SLL	5,A0
	ADDI	WHERE_SPARKLE,A0
	MOVE	A0,A2

	MOVE	*A8(OXPOS),A0
	MOVE	*A2,A14
	ADD	A14,A0
	
	MOVE	*A8(OYPOS),A1
	MOVE	*A2(10H),A14
	ADD	A14,A1

	SLL	16,A0
	SLL	16,A1
	MOVI	SPRKLA01,A2
	MOVE	*A8(OZVAL),A3,L
	INC	A3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	movi	TYPWWFICON,a5
	CLR	A6
	CLR	A7
	CALLA	BEGINOBJ

	MOVK	2,A0
	CALLA	RNDRNG0
	SLL	5,A0
	ADDI	WHICH_SPARKLE,A0
	MOVE	*A0,A1,L
	calla	setup_back_anim
	JSRP	ANIM_CROWD
	CALLA	DELOBJA8
#die	DIE


WHICH_SPARKLE
	.LONG	SPARKLE_1
	.LONG	SPARKLE_2
	.LONG	SPARKLE_3
	.LONG	BSPARKLE1
	.LONG	BSPARKLE2


WHERE_SPARKLE
	.LONG	[-8,-14]
	.LONG	[8,-9]
	.LONG	[-1,8]
	.LONG	[0,15]
	.LONG	[-9,19]
	.LONG	[-10,2]
	.LONG	[-1,-6]

SPARKLE_1
	WL	2,SPRKLA01
	WL	2,SPRKLA02
	WL	2,SPRKLA03
	WL	2,SPRKLA04
	WL	2,SPRKLA05
	WL	2,SPRKLA06
	WL	2,SPRKLA07
	WL	2,SPRKLA08
	WL	2,SPRKLA09
	WL	2,SPRKLA10
	WL	2,SPRKLA11
	WL	2,SPRKLA12
	WL	2,SPRKLA13
	.WORD	CANI_END

SPARKLE_2
	WL	2,SPRKLB01
	WL	2,SPRKLB02
	WL	2,SPRKLB03
	WL	2,SPRKLB04
	WL	2,SPRKLB05
	WL	2,SPRKLB06
	WL	2,SPRKLB07
	WL	2,SPRKLB08
	WL	2,SPRKLB09
	WL	2,SPRKLB10
	WL	2,SPRKLB11
	WL	2,SPRKLB12
	WL	2,SPRKLB13
	.WORD	CANI_END

SPARKLE_3
	WL	2,SPRKLC01
	WL	2,SPRKLC02
	WL	2,SPRKLC03
	WL	2,SPRKLC04
	WL	2,SPRKLC05
	WL	2,SPRKLC06
	WL	2,SPRKLC07
	WL	2,SPRKLC08
	WL	2,SPRKLC09
	WL	2,SPRKLC10
	WL	2,SPRKLC11
	WL	2,SPRKLC12
	WL	2,SPRKLC13
	.WORD	CANI_END

BSPARKLE1
	WL	2,BSPRKA01
	WL	2,BSPRKA02
	WL	2,BSPRKA03
	WL	2,BSPRKA04
	WL	2,BSPRKA05
	WL	2,BSPRKA06
	WL	2,BSPRKA07
	WL	2,BSPRKA08
	WL	2,BSPRKA09
	WL	2,BSPRKA10
	WL	2,BSPRKA11
	WL	2,BSPRKA12
	WL	2,BSPRKA13
	WL	2,BSPRKA14
	WL	2,BSPRKA15
	.WORD	CANI_END

BSPARKLE2
	WL	2,BSPRKB01
	WL	2,BSPRKB02
	WL	2,BSPRKB03
	WL	2,BSPRKB04
	WL	2,BSPRKB05
	WL	2,BSPRKB06
	WL	2,BSPRKB07
	WL	2,BSPRKB08
	WL	2,BSPRKB09
	WL	2,BSPRKB10
	WL	2,BSPRKB11
	WL	2,BSPRKB12
	WL	2,BSPRKB13
	WL	2,BSPRKB14
	WL	2,BSPRKB15
	.WORD	CANI_END

YSPEED	.EQU	[4,0]

CREATE_PERFECT

	movi	CYCPID,a0
	CLR	A1
	NOT	A1
	CALLA	EXISTP
	JRNZ	NO_NEED_FOR_PERFECT

	MOVI	0c4h,A0
	CALLA	triple_sound

	MOVI	[200,0],A0
	MOVI	[300,0],A1
	MOVI	PERFCT09,A2
	MOVI	1799H,A3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	movi	TYPPERFECT,a5
	CLR	A6
	CLR	A7
	CALLA	BEGINOBJ
	MOVI	YSPEED,A0
	NEG	A0
	MOVE	A0,*A8(OYVEL),L

	PUSHP	A10
	MOVI	PERFECT_DISSOLVE_ANIM,A9
	MOVI	12,A11
	MOVI	PERFCT09,A10
	CREATE	FX_PID,COPY_OBJ_AND_MOVE_UP

	PULLP	A10


#wait_loop
	SLEEPK	1
	move	*a8(OYPOS),a0
	cmpi	100,a0
	jrge	#wait_loop
	clr	a0
	move	a0,*a8(OYVEL),L
	movi	FX_PID,a0
	clr	a1
	not	a1
	calla	KILALL

	MOVE	*A10(PLYRNUM),A10
	INC	A10
	move	@PERFECT_WINS,A0
	and	a10,A0
	JRZ	NOT_A_DOUBLE
	CREATE	ADD_INIT_PID,CREATE_DOUBLE

NOT_A_DOUBLE

	move	@PERFECT_WINS,A0
	or	a10,A0
	MOVE	A0,@PERFECT_WINS

	MOVI	PERFECT_FLASH_ANIM,A1
	calla	setup_back_anim
	JSRP	ANIM_CROWD

	MOVI	0A8H,A0
	calla	triple_sound

	MOVI	WHERE_PERFECT_SPARKLE,A10
	PUSH	A8
	MOVE	*A8(OXPOS),A9
	MOVE	*A8(OYVAL),A8,L
	MOVX	A9,A8
	MOVK	2,A9
	CREATE	FLASH_PID,SPRINKLE_GLINTS
	PULL	A8
	MOVI	110,A9
	JRUC	LOOK_FOR_IT
NO_NEED_FOR_PERFECT
	DIE

CREATE_DOUBLE
	MOVI	[200,0],A0
	MOVI	[80,0],A1
	MOVI	DOUBLE09,A2
	MOVI	1799H,A3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	movi	TYPPERFECT,a5
	CLR	A6
	CLR	A7
	CALLA	BEGINOBJ

	MOVI	DOUBLE_FLASH_ANIM,A1
	calla	setup_back_anim
	JSRP	ANIM_CROWD
	MOVI	110,A9
	JRUC	LOOK_FOR_IT
	DIE

COPY_OBJ_AND_MOVE_UP
	PUSHP	A10
	MOVE	A8,A10
COPY_OBJ_AND_MOVE_UP2
	MOVE	*A10(OYVAL),A1,L
	MOVI	[200,0],A0
	PULLP	A2
	PUSHP	A2
	MOVI	1799H,A3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	movi	TYPPERFECT,a5
	CLR	A6
	CLR	A7
	CALLA	BEGINOBJ
	CREATE	OVRHED_PID,KILL_THEM_EVENTUALLY_EACH
	SLEEP	3
	JRUC	COPY_OBJ_AND_MOVE_UP2

KILL_THEM_EVENTUALLY_EACH
	MOVK	6,A11
	MOVE	A9,A9
	JRZ	NORMAL_KILL
MOVE_IT_BACK
	MOVE	*A8(OZPOS),A1
	DEC	A1
	MOVE	A1,*A8(OZPOS)
	SLEEP	1
	DSJS	A11,MOVE_IT_BACK
	MOVE	A9,A1
	calla	setup_back_anim
	JSRP	ANIM_CROWD
	CALLA	DELOBJA8
	DIE

NORMAL_KILL
	MOVE	*A8(OZPOS),A1
	DEC	A1
	MOVE	A1,*A8(OZPOS)
	SLEEP	1
	DSJS	A11,NORMAL_KILL
	CALLA	DELOBJA8
	DIE

DOUBLE_FLASH_ANIM
	WL	2,DOUBLE01
	WL	2,DOUBLE02
	WL	2,DOUBLE03
	WL	2,DOUBLE04
	WL	2,DOUBLE05
	WL	2,DOUBLE06
	WL	2,DOUBLE07
	WL	2,DOUBLE08
	WL	2,DOUBLE09
	.WORD	CANI_END

PERFECT_FLASH_ANIM
	WL	2,PERFCT01
	WL	2,PERFCT02
	WL	2,PERFCT03
	WL	2,PERFCT04
	WL	2,PERFCT05
	WL	2,PERFCT06
	WL	2,PERFCT07
	WL	2,PERFCT08
	WL	2,PERFCT09
	.WORD	CANI_END

PERFECT_DISSOLVE_ANIM
	WL	2,PERFDS01
	WL	2,PERFDS02
	WL	2,PERFDS03
	WL	2,PERFDS04
	WL	2,PERFDS05
	WL	2,PERFDS06
	WL	2,PERFDS07
	WL	2,PERFDS08
	.WORD	CANI_END

 SUBR    RANDOM_SPARKLE

	SLEEP	20
	MOVI	FLASH_PID,A0
	MOVI	-1,A1
	CALLA	EXISTP
	JRNZ	RANDOM_SPARKLE

	MOVI	39,A0
	CALLA	RNDRNG0
	MOVE	A0,A9
	MOVI	[102,7],A8
	MOVI	WHERE_WRESTLMANIA_SPARKLES,A10
	MOVE	A9,A11
	SLL	5,A11
	ADD	A10,A11
	MOVK	4,A9
	CREATE	FLASH_PID,START_SPARKLE
	SLOOP	30,RANDOM_SPARKLE

 SUBR	SPRINKLE_GLINTS
	CLR	A6
	PUSHP	A6
NEXT_SPARKLE
	PULLP	A6
	MOVE	A6,A11
	SLL	5,A11
	ADD	A10,A11
	MOVE	*A11,A1,L
	INC	A1
	JRZ	NO_MORE_SPARKLE
	CREATE	FLASH_PID,START_SPARKLE
	INC	A6
	PUSHP	A6
	SLOOP	5,NEXT_SPARKLE
NO_MORE_SPARKLE
	DIE

START_SPARKLE
	MOVE	A8,A0
	MOVE	*A11,A14
	ADD	A14,A0
	MOVE	A8,A1
	SRL	16,A1
	MOVE	*A11(10H),A14
	ADD	A14,A1

	SLL	16,A0
	SLL	16,A1
	MOVI	SPRKLA01,A2
	MOVI	1800H,A3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	CLR	A5
	CLR	A6
	CLR	A7
	CALLA	BEGINOBJ
	MOVE	A9,A0
	CALLA	RNDRNG0
	SLL	5,A0
	ADDI	WHICH_SPARKLE,A0
	MOVE	*A0,A1,L
	calla	setup_back_anim
	JSRP	ANIM_CROWD
	CALLA	DELOBJA8
	DIE

WHERE_PERFECT_SPARKLE
	.LONG	[-6,-71]
	.LONG	[0,-64]
	.LONG	[-7,-49]
	.LONG	[5,-42]
	.LONG	[-2,-35]
	.LONG	[5,-31]
	.LONG	[-7,-18]
	.LONG	[5,-10]
	.LONG	[-2,-1]
	.LONG	[-7,9]
	.LONG	[5,17]
	.LONG	[-7,31]
	.LONG	[2,39]
	.LONG	[-7,49]
	.LONG	[6,59]
	.LONG	[-2,69]
	.LONG	[-7,74]
	.LONG	-1

 SUBR    WHERE_WRESTLMANIA_SPARKLES
	.LONG	[5,8]
	.LONG	[29,22]
	.LONG	[4,43]
	.LONG	[60,50]
	.LONG	[4,65]
	.LONG	[28,76]
	.LONG	[56,80]
	.LONG	[15,87]
	.LONG	[33,94]
	.LONG	[50,105]
	.LONG	[32,110]
	.LONG	[4,114]
	.LONG	[64,121]
	.LONG	[56,125]
	.LONG	[28,129]
	.LONG	[15,158]
	.LONG	[56,159]
	.LONG	[4,177]
	.LONG	[33,186]
	.LONG	[30,200]
	.LONG	[15,203]
	.LONG	[35,220]
	.LONG	[4,225]
	.LONG	[40,236]
	.LONG	[4,257]
	.LONG	[13,260]
	.LONG	[4,271]
	.LONG	[61,273]
	.LONG	[56,277]
	.LONG	[15,286]
	.LONG	[33,291]
	.LONG	[15,309]
	.LONG	[37,320]
	.LONG	[56,334]
	.LONG	[33,338]
	.LONG	[4,345]
	.LONG	[32,359]
	.LONG	[4,370]
	.LONG	[56,373]
	.LONG	[17,383]
	.LONG	-1

******************************************************************************

 SUBR	CREATE_TIMEOUT

	MOVI	0c4h,A0
	CALLA	triple_sound

	MOVI	[200,0],A0
	MOVI	[300,0],A1
	MOVI	TIMEEX09,A2
	MOVI	1799H,A3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	CLR	A5
	CLR	A6
	CLR	A7
	CALLA	BEGINOBJ

	MOVI	YSPEED,A0
	NEG	A0
	MOVE	A0,*A8(OYVEL),L

	MOVI	TIMEOUT_DISSOLVE_ANIM,A9
	MOVI	12,A11
	MOVI	TIMEEX09,A10
	CREATE	FX_PID,COPY_OBJ_AND_MOVE_UP
	CREATE	FX_PID,HAVE_TO_MOVE_IT_TO

	SLEEP	50
	CLR	A0
	MOVE	A0,*A8(OYVEL),L
	MOVI	FX_PID,A0
	CLR	A1
	NOT	A1
	CALLA	KILALL

	SLEEP	10

	MOVK	4,A4
LOOP_TIMEOUT
	PUSHP	A4
	MOVI	TIMEOUT_FLASH_ANIM,A1
	calla	setup_back_anim
	JSRP	ANIM_CROWD

	MOVE	@match_time,A0,L
	CMPI	90009H,A0
	JREQ	JUMP_OUT
	PULLP	A4
	DSJS	A4,LOOP_TIMEOUT

	MOVI	110-(3*18),A9
	JRUC	LOOK_FOR_IT

TIMEOUT_FLASH_ANIM
	WL	2,TIMEEX01
	WL	2,TIMEEX02
	WL	2,TIMEEX03
	WL	2,TIMEEX04
	WL	2,TIMEEX05
	WL	2,TIMEEX06
	WL	2,TIMEEX07
	WL	2,TIMEEX08
	WL	2,TIMEEX09
	.WORD	CANI_END

TIMEOUT_DISSOLVE_ANIM
	WL	2,TIMEDS01
	WL	2,TIMEDS02
	WL	2,TIMEDS03
	WL	2,TIMEDS04
	WL	2,TIMEDS05
	WL	2,TIMEDS06
	WL	2,TIMEDS07
	WL	2,TIMEDS08
	.WORD	CANI_END

 SUBR	CREATE_DISQUAL

	MOVI	0c4h,A0
	CALLA	triple_sound

	MOVI	[200,0],A0
	MOVI	[300,0],A1
	MOVI	DISQUA09,A2
	MOVI	1799H,A3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	CLR	A5
	CLR	A6
	CLR	A7
	CALLA	BEGINOBJ
	MOVI	YSPEED,A0
	NEG	A0
	MOVE	A0,*A8(OYVEL),L

	MOVI	DISQUAL_DISSOLVE_ANIM,A9
	MOVI	12,A11
	MOVI	DISQUA09,A10
	CREATE	FX_PID,COPY_OBJ_AND_MOVE_UP

	SLEEP	50
	CLR	A0
	MOVE	A0,*A8(OYVEL),L
	MOVI	FX_PID,A0
	CLR	A1
	NOT	A1
	CALLA	KILALL

	MOVK	4,A4
LOOP_DISQUAL
	PUSHP	A4

	MOVI	DISQUAL_FLASH_ANIM,A1
	calla	setup_back_anim
	JSRP	ANIM_CROWD

	MOVE	@match_time,A0,L
	CMPI	90009H,A0
	JREQ	JUMP_OUT
	PULLP	A4
	DSJS	A4,LOOP_DISQUAL

	MOVI	110-(3*18),A9
LOOK_FOR_IT
	SLEEP	2
	MOVE	@match_time,A0,L
	CMPI	90009H,A0
	JREQ	JUMP_OUT
	DSJS	A9,LOOK_FOR_IT
JUMP_OUT
	CALLA	DELOBJA8
	DIE

HAVE_TO_MOVE_IT_TO
	MOVE	*A8(OYVEL),A1,L
	MOVE	*A8(OYVAL),A2,L
	ADD	A1,A2
	MOVE	A2,*A8(OYVAL),L
	SLOOP	1,HAVE_TO_MOVE_IT_TO

DISQUAL_FLASH_ANIM
	WL	2,DISQUA01
	WL	2,DISQUA02
	WL	2,DISQUA03
	WL	2,DISQUA04
	WL	2,DISQUA05
	WL	2,DISQUA06
	WL	2,DISQUA07
	WL	2,DISQUA08
	WL	2,DISQUA09
	.WORD	CANI_END

DISQUAL_DISSOLVE_ANIM
	WL	2,DISQDS01
	WL	2,DISQDS02
	WL	2,DISQDS03
	WL	2,DISQDS04
	WL	2,DISQDS05
	WL	2,DISQDS06
	WL	2,DISQDS07
	WL	2,DISQDS08
	.WORD	CANI_END

 SUBR	PIN_FLASH_ANIM

	WL	2,PINHIM01
	WL	2,PINHIM02
	WL	2,PINHIM03
	WL	2,PINHIM04
	WL	2,PINHIM05
	WL	2,PINHIM06
	WL	2,PINHIM07
	WL	2,PINHIM08
	WL	20,PINHIM09
	.WORD	CANI_END

***********
*
* Old:
* returns lowest PLYRNUM on winning side (0 or 1 for plyrs, 2 for drones)
* in a3.  increments p1rounds and p2rounds too.  (actually, it's okay to
* return a 3 or a 4 if we want.  The code that calls this will work fine.
* If this is the final battle, we add 2 instead of 1 to pXrounds.
*
* New:
* returns lowest PLYRNUM on winning side, unless there was a pin, in which
* case it returns the first wrestler on the winning side with his DID_PIN
* flag set.
*

 SUBRP	set_winner

	;first, establish cause of death.  Choices are time running out
	; and loss of all health.
	move	@match_time,a14,L
	jrz	#tmout

	;time didn't run out, so either someone was pinned, which should
	; only happen if everyone on his team is dead, or the last living
	; member of a team died by ring-out.  Search through the wrestlers
	; and award victory to the first live one we find.
	movi	NUM_WRES,a0
	movi	process_ptrs,a1
	clr	a3

#loop0	move	*a1+,a2,L
	jrz	#nxt0		;skip inactive

	move	*a2(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#nxt0		;skip dead

	;got a live one.  if he pinned, use him.  if not, save his pointer
	; in case we find no pinner, but keep looking
	move	*a2(STATUS_FLAGS),a14
	btst	B_DID_PIN,a14
	jrnz	#a2wins

	move	a2,a3

#nxt0	dsj	a0,#loop0

	;okay, nobody pinned.  did we find any live ones at all?
	move	a3,a2
	jrnz	#a2wins		;yes, we saved a non-pinner.

	;trouble.  we didn't find any live wrestlers, and there definitely
	; should have been one.  This is really bad and should never happen,
	; but just in case it does, give the win to the first valid wrestler
	; we can find.
	.if DEBUG
	LOCKUP
	.endif
#bogus	movi	NUM_WRES,a0
	movi	process_ptrs,a1

#loop1	move	*a1+,a2,L
	jrz	#nxt1		;skip inactive

	;got one
	jruc	#a2wins

#nxt1	dsjs	a0,#loop1

	;good heavens!  no actives found at all!  no way is this ever gonna
	; happen.  fuck it.  quit or something.
	jruc	#no_hits

#a2wins	;a2 is process of winner
	;increment pXrounds
	movi	p1rounds,a0
	movi	01h,a1		;match_winner value for p1 side winning
	move	*a2(PLYR_SIDE),a4
	jrz	#rok
	movi	p2rounds,a0
	movi	02h,a1		;match_winner value for p1 side winning
#rok	move	*a0,a4
	inc	a4

	;if this is the final match (or royal rumble), increment it again.
	inc	a4		;increment, then dec if we shouldn't have.
	calla	is_8_on_1
	jrc	#a4ok
	move	@royal_rumble,a14
	jrnz	#a4ok
	dec	a4
#a4ok	move	a4,*a0

	;if pXwins == 2, set match_winner
	cmpi	2,a4
	jrne	#no_mw
	move	a1,@match_winner

#no_mw	move	*a2(PLYRNUM),a3
	rets

#tmout	;clock ran out on the round.  Award victory to the team with the
	; highest average life points remaining.  In case of a tie, winner
	; is the last team to land a hit.  If there have been no hits,
	; we'll wanna drop out and go straight to game over, which I'll
	; deal with later, probably by returning a -1 and letting the
	; caller deal with it.

	;If this was an 8-on-1 or 8-on-2 match, the CPU wins when time
	; runs out.
	move	@process_ptrs+40h,a2,L	;first drone
	calla	is_8_on_1
	jrc	#a2wins
	move	@royal_rumble,a14
	jrnz	#a2wins

	;reggies:
	clr	a4	;team 1 count
	clr	a5	;team 1 total
	clr	a6	;team 2 count
	clr	a7	;team 2 total

	movi	NUM_WRES,a9
	movi	process_ptrs,a8

#loop2	move	*a8+,a10,L
	jrz	#nxt2		;skip inactive

	move	*a10(PLYRNUM),a1
	calla	get_health
	move	*a10(PLYR_SIDE),a14
	jrnz	#t2

	;on team 1
	inc	a4
	add	a0,a5
	jruc	#nxt2

#t2	;on team 2
	inc	a6
	add	a0,a7

#nxt2	dsj	a9,#loop2

	;compute the averages (we could check for the very likely case of
	; the divisor being one, but there's no real need, as this is
	; hardly a performance-critical event.)
	divu	a4,a5
	divu	a6,a7

	cmp	a5,a7
	jrlt	#t1w
	jrgt	#t2w

#tie	;uh-oh.  Tie.  Find wrestler with most recent LAST_HIT_TIME and
	; award the match to his team.  If everyone's LAST_HIT_TIME's are
	; zero, nobody has landed a blow, so just quit to game over.
	; LAST_HIT_TIME holds all 32 bits of PCNT, so we don't need to worry
	; about wraparound.

	movi	NUM_WRES,a9
	movi	process_ptrs,a8
	clr	a0		;current high LAST_HIT_TIME
	clr	a1		;team with current high LAST_HIT_TIME

#loop4	move	*a8+,a10,L
	jrz	#nxt4		;skip inactive

	move	*a10(LAST_HIT_TIME),a14,L
	cmp	a0,a14
	jrle	#nxt4

	;new champ.
	move	a14,a0
	move	*a10(PLYR_SIDE),a1

#nxt4	dsj	a9,#loop4

	TEST	a0
	jrz	#no_hits
	TEST	a1
	jrnz	#t2w
	;fall through to #t1w

#t1w	;team 1 wins
	clr	a4
	jruc	#fw

#t2w	;team 2 wins
	movk	1,a4

#fw	;award win to first live wrestler with PLYR_SIDE equal to a4

	movk	NUM_WRES,a0
	movi	process_ptrs,a1

#loop3	move	*a1+,a2,L
	jrz	#nxt3		;skip inactive

	move	*a2(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#nxt3		;skip dead

	move	*a2(PLYR_SIDE),a14
	cmp	a14,a4
	jrne	#nxt3		;skip losers

	;got one
	move	*a2(PLYRNUM),a3
	jruc	#a2wins

#nxt3	dsj	a0,#loop3

	;good heavens.  we didn't find ANYONE from that team.  This is
	; a major error that should never happen.  Deal with it as in
	; the 'no live wrestlers found' case above.
	.if DEBUG
	LOCKUP
	.endif
	jruc	#bogus

#no_hits
	;battle ended in a tie with neither side landing a blow.  drop
	; out to game over.
	movi	-1,a2
	rets

#*****************************************************************************
*
* Clears a combo meter.
* >a13 = process of victim

 SUBR	clear_combo_meter

	move	*a13(PLYR_SIDE),a1
	move	*a13(PLYRNUM),a11
	jruc	zero_combo_meter

#*****************************************************************************
*
* Sets a combo meter to half-size.
* >a13 = process of victim

 SUBR	halve_combo_meter

	move	*a13(PLYR_SIDE),a1
	move	*a13(PLYRNUM),a11
	movi	MD_SIZE,a9
	mpyu	a1,a9
	addi	meter_data,a9
	move	*a9(MD_COMBO),a8,L
	move	a11,a5
	X64	a5		;x by PLT_SIZE
	addi	life_data,a5
	movk	10,a2
	jruc	draw_combo_meter

#*****************************************************************************
*
* Clears a life bar.
* >a13 = process of victim

 SUBR	clear_lifebar

	move	*a13(PLYRNUM),a0
	X64	a0
	addi	life_data,a0
	clr	a14
	move	a14,*a0(PLT_LIFE)

	move	*a13(PLYR_SIDE),a0
	callr	update_meter

	rets

******************************************************************************

	.end
