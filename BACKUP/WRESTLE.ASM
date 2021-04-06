************************************************************** 
*
* Software:		Jamie Rivett, Mark Turmell, Jason Skiles
* Initiated:		12/7/93
*
* Modified:
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"wrestle.asm"
	.title	"wrestling game program"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"macros.h"
	.include	"mproc.equ"		;Mproc equates
	.include	"display.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"sys.equ"
	.include	"wwfsec.equ"
	.include	"game.equ"
	.include	"audit.equ"
	.include	"plyr.equ"
	.include	"anim.equ"
	.include	"sound.h"
	.include	"ring.equ"
	.INCLUDE	"SOUND.EQU"

	.INCLUDE	"NEWFONT.TBL"
	.include	"imgtbl.glo"
	.include	"fontsimg.glo"
	.include	"bgndtbl.glo"
	.include	"miscimg.glo"


 .if DEBUG

SCRT_DEBUG	equ	0
DIR_DEBUG	equ	0
COL_DEBUG	equ	1

 .else

SCRT_DEBUG	equ	0
DIR_DEBUG	equ	0
COL_DEBUG	equ	0

 .endif

******************************************************************************
* EXTERNAL REFERENCES

	.REF	CREATE_TEXT_LINE
	.REF	HAVE_WE_AUDITED_THIS_GAME

	.REF	MATCH_TIMERS
	.REF	KILL_AUD
	.REF	CLEAR_COUNTERS
	.def	update_timer

	.REF	WHICH_NAME
	.ref	SHIFT_BARS_IN_Z

	.REF	SET_LOWER_VOL

	.REF	CLEAR_SPEECH_REPEAT

	.ref	WALK_SOUND
	.ref	pin_speed_in_case
	.ref	entered_inits, ADD_VOICE
	.ref	RESETUP_PROGRESS
	.ref	SPECIAL_WIPEOUT
	.ref	SORT_OUT_WRESTLER_NUM
	.ref	CURRENT_LADDER,NUM_OPPS
	.ref	OPEN_PROGRESS_SCREEN
	.ref	INIT_LADDER_TABLE
	.ref	DONE_HOWARD
	.ref	SNDSND,init_special_objlist
	.REF	TEMP_LADDER,GAME_BEATEN
	.REF	THIS_GAME_IS_BEATEN

	.ref	square_root
	.ref	clear_damage_log
	.ref	getup_meter

	.ref	move_bret
	.ref	move_bam,move_doink,move_razor
	.ref	move_taker,move_yoko,move_shawn,move_lex


	.ref	bret_ani_init
	.ref	doink_ani_init,razor_ani_init,shawn_ani_init
	.ref	bam_ani_init,taker_ani_init,yoko_ani_init
	.ref	lex_ani_init

	;from ANIM.ASM
	.ref	set_images,animate_wrestler
	.ref	change_anim1,change_anim1a,change_anim2
	.ref	change_anim_anim

	;from ATTRACT.ASM
	.ref	attract_mode

	;from AUDIT.ASM
	.ref	AUD,AUD1,STORE_AUDIT,CR_STRTP,CR_CONTP,P_START,P_CONT
	.ref	GET_AUD,GET_ADJ,LCOIN,CCOIN,RCOIN,XCOIN,SLAM_SW,SERVICE
	.REF	DBV

	;from BAKGND.ASM
	.ref	BGND_UD1,BAKMODS

	;from COLLIS.ASM
	.ref	overlap_collision
	.ref	check_collisions,set_collision_boxes

	;from CROWD.ASM
	.ref	crowd_anim

	;from DCSSOUND.ASM
	.ref	snd_update,VOLBTN_PRESS,triple_sound

	;from DIAG.ASM
	.ref	POWERTST,POWERCMOS,READ_DIP

	;from DRONE.ASM
	.ref	drone_main

	;from HSTD.ASM
	.ref	INIT_TAB

	;from LIFEBAR.ASM
	.ref	meters,init_life_data,get_health

	;from MAIN.ASM
	.ref	dpageflip,IRQSKYE,dirqtimer,WDOGRAM,init_all

	;from MPROC.ASM
	.ref	process_dispatch

	;from PAL.ASM
	.ref	pal_getf,PALFRAM

	;from ROBO.ASM
	.ref	robo_check

	;from ROPES.ASM
	.ref	rope,rope_command

	;from SELECT.ASM
	.ref	select_screen,index1,index2,wrestler_audits
	.ref	pregame_show

	;from STRING.ASM
	.ref	setup_message,print_string_C2

	;from TEST.ASM
	.ref	DIAG,CKDIAG

	;from UTIL.ASM
	.ref	get_stick_val_cur,get_stick_val_up,get_stick_val_down

	.ref	get_but_val_cur,get_but_val_down,get_but_val_up

	.ref	ck_climb_out_side
	.ref	ck_climb_out_top
	.ref	ck_climb_out_bot
	.ref	ck_climb_in_bot
	.ref	ck_climb_in_top
	.ref	ck_climb_in_side

	.ref	dma_bog,dma_meter,QDMAN

	.ref	D2ST2B03

	.REF	DAM_MULT,CHECK_COMBO_GO
	.REF	DO_CROWD_CHEER

	.ref	are_we_waiting_f
******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

	.DEF	CLEAR_PROCESSES

	.def	COLRPRC,obj_look,wrestler_veladd,set_process_ptr,ani_init
	.def	mainlp, swstacktop, swstack_p,PCMOSRET

	;for TODDVIEW
	.def	punch_dtime1,powerp_dtime1,kick_dtime1,block_dtime1
	.def	powerk_dtime1

	.def	powerk_dtime1


	;for ROPES.ASM
	.def	ring_mod

	.ref	_serial_number
	.ref	_man_date
	.ref	InitPIC
	.ref	RemapIO
	.ref	SecFuncCheck

	.def	_coin_addr
	.def	_switch_addr
	.def	_switch2_addr
	.def	_watchdog_addr
	.def	_dipswitch_addr
	.def	_sound_addr
	.def	_soundirq_addr
	.def	_coin_counter_addr


	.globl	_coin_addr
	.globl	_switch_addr
	.globl	_switch2_addr
	.globl	_watchdog_addr
	.globl	_dipswitch_addr
	.globl	_sound_addr
	.globl	_soundirq_addr
	.globl	_coin_counter_addr


	.bss	_coin_addr,32
	.bss	_switch_addr,32
	.bss	_switch2_addr,32
	.bss	_watchdog_addr,32
	.bss	_dipswitch_addr,32
	.bss	_sound_addr,32
	.bss	_soundirq_addr,32
	.bss	_coin_counter_addr,32

;uninitialized ram definitions
	BSSX	no_pin_check,16

	BSSX	PSTATUS		,16	;Player in game bits (0-3)
	BSSX	OLD_PSTATUS	,16	;Previous games PSTATUS

	.if	DEBUG
	BSSX	SLDEBUG		,16	;Shawn's debug
	BSSX	slowmotion	,16	;!0=Frames of delay for slow motion
	BSSX	slowmo		,16	;!0=Frames of delay for slow motion
	.endif

	BSSX	PCNT		,16	;Main loop cnt

	BSSX	swstack_p	,32	;*Stack position
	BSSX	swstackbot	,16*64	;Bottom of stack
	.bss	swstacktop	,0	;Top of stack

	BSSX	COLRTEMP	,16*16	;RAM COPY OF CYCLING COLORS

	BSSX	GAMSTATE	,16	;Game state: See game.equ

	BSSX	HALT		,16	;FREEZE ALL OBJECTS (NO VEL UPDATE)
	BSSX	NO_START	,16	;FLAG 0=OKAY, 1=NOT RIGHT NOW.

	BSSX	WSPEED		,16
	BSSX	WFLG		,16	;0=NOT ON, 1=YES IT IS ON
	.bss	WNDWFLG		,16	;0=WINDOW SHOULD CLOSE, 1=NO WINDOW
	BSSX	OBJPTR		,32	;PNTR FOR WINDOW OBJECT


	.bss	PALTMP		,13*16*2 ;ALLOCATE 2 X COLOR AREA IN RAM

	BSSX	match_cnt,	16

	BSSX	debug_collis,	16

	BSSX	DIAG0,		32
	BSSX	DIAG1,		32

	BSSX	process_ptrs,	32*NUM_WRES	;long * number wrestlers
p2_process	.equ	process_ptrs+32
	.def	p2_process

	.bss	wres0_objs,	32*MAX_PIECES
	.bss	wres1_objs,	32*MAX_PIECES
	.bss	wres2_objs,	32*MAX_PIECES
	.bss	wres3_objs,	32*MAX_PIECES
	.bss	wres4_objs,	32*MAX_PIECES
	.bss	wres5_objs,	32*MAX_PIECES
	.bss	wres6_objs,	32*MAX_PIECES
	.bss	wres7_objs,	32*MAX_PIECES

	BSSX	round_tickcount,16


	BSSX	wrest_joystat,	32*16*NUM_WRES	;16 bit joyval: 16 bit count

	BSSX	wrestler_x,	32*NUM_WRES	;long * number wrestlers
	BSSX	wrestler_y,	32*NUM_WRES	;long *		"
	BSSX	wrestler_z,	32*NUM_WRES	;long *		"

	BSSX	match_time,	16*3		;frac, 1's, 10's

	BSSX	match_over,	16		;0=not over, !0=over
	BSSX	match_realtime,	16		;actual seconds elapsed
	BSSX	match_winner,	16		;just like PSTATUS

	BSSX	secret_damage,	16		;0=none,1=plyr 1,2=plyr 2
	BSSX	fight_debug,	16

	BSSX	p1winstreak,	16		;player 1 winning streak
	BSSX	p2winstreak,	16		;player 2 winning streak

	BSSX	current_round,	16		;current round in match (1+)
	BSSX	p1rounds,	16		;player 1 rounds won
	BSSX	p2rounds,	16		;player 2 rounds won

	BSSX	p1cpu_ladder,	16		;1 player game matchup #.  Used
	BSSX	p2cpu_ladder,	16		;for ladder of progression

	;keep these in order and adjacent
	BSSX	front_rproc,	32		;front ropes proc
	BSSX	back_rproc,	32		;back ropes proc
	BSSX	left_rproc,	32		;left ropes proc
	BSSX	right_rproc,	32		;right ropes proc

	BSSX	total_matches,	16		;matches since attract mode
;MJT Start
	BSSX	no_debris,	16		;Don't allow debris - it bogs
;MJT End

	.if DEBUG
	BSSX	stay_down,	16		;flag - don't dec GETUP_TIME
	.endif

	.text


******************************************************************************
 SUBR  InitAddresses
	movi	COINS,a0
	move	a0,@_coin_addr,L
	movi	SWITCH,a0
	move	a0,@_switch_addr,L
	movi	SWITCH2,a0
	move	a0,@_switch2_addr,L
	movi	WATCHDOG,a0
	move	a0,@_watchdog_addr,L
	movi	DIPSWITCH,a0
	move	a0,@_dipswitch_addr,L
	movi	SOUND,a0
	move	a0,@_sound_addr,L
	movi	SOUNDIRQ,a0
	move	a0,@_soundirq_addr,L
	movi	COIN_COUNTERS,a0
	move	a0,@_coin_counter_addr,L
	movi	VMUX_INITMODE,a0
	move	a0,@VMUX_CONTROL
	rets

******************************************************************************
 SUBR  AddressSet1
	movi	COINS_M1,a0
	move	a0,@_coin_addr,L
	movi	SWITCH_M1,a0
	move	a0,@_switch_addr,L
	movi	SWITCH2_M1,a0
	move	a0,@_switch2_addr,L
	movi	WATCHDOG_M1,a0
	move	a0,@_watchdog_addr,L
	movi	DIPSWITCH_M1,a0
	move	a0,@_dipswitch_addr,L
	movi	SOUND_M1,a0
	move	a0,@_sound_addr,L
	movi	SOUNDIRQ_M1,a0
	move	a0,@_soundirq_addr,L
	movi	COIN_COUNTERS_M1,a0
	move	a0,@_coin_counter_addr,L
	movi	(VMUX_INITMODE|VMUX_MODE1),a0
	move	a0,@VMUX_CONTROL
	rets

******************************************************************************
 SUBR  AddressSet2
	movi	COINS_M2,a0
	move	a0,@_coin_addr,L
	movi	SWITCH_M2,a0
	move	a0,@_switch_addr,L
	movi	SWITCH2_M2,a0
	move	a0,@_switch2_addr,L
	movi	WATCHDOG_M2,a0
	move	a0,@_watchdog_addr,L
	movi	DIPSWITCH_M2,a0
	move	a0,@_dipswitch_addr,L
	movi	SOUND_M2,a0
	move	a0,@_sound_addr,L
	movi	SOUNDIRQ_M2,a0
	move	a0,@_soundirq_addr,L
	movi	COIN_COUNTERS_M2,a0
	move	a0,@_coin_counter_addr,L
	movi	(VMUX_INITMODE|VMUX_MODE2),a0
	move	a0,@VMUX_CONTROL
	rets

******************************************************************************
 SUBR  AddressSet3
	movi	COINS_M3,a0
	move	a0,@_coin_addr,L
	movi	SWITCH_M3,a0
	move	a0,@_switch_addr,L
	movi	SWITCH2_M3,a0
	move	a0,@_switch2_addr,L
	movi	WATCHDOG_M3,a0
	move	a0,@_watchdog_addr,L
	movi	DIPSWITCH_M3,a0
	move	a0,@_dipswitch_addr,L
	movi	SOUND_M3,a0
	move	a0,@_sound_addr,L
	movi	SOUNDIRQ_M3,a0
	move	a0,@_soundirq_addr,L
	movi	COIN_COUNTERS_M3,a0
	move	a0,@_coin_counter_addr,L
	movi	(VMUX_INITMODE|VMUX_MODE3),a0
	move	a0,@VMUX_CONTROL
	rets

******************************************************************************
 SUBR  AddressSet4
	movi	COINS_M4,a0
	move	a0,@_coin_addr,L
	movi	SWITCH_M4,a0
	move	a0,@_switch_addr,L
	movi	SWITCH2_M4,a0
	move	a0,@_switch2_addr,L
	movi	WATCHDOG_M4,a0
	move	a0,@_watchdog_addr,L
	movi	DIPSWITCH_M4,a0
	move	a0,@_dipswitch_addr,L
	movi	SOUND_M4,a0
	move	a0,@_sound_addr,L
	movi	SOUNDIRQ_M4,a0
	move	a0,@_soundirq_addr,L
	movi	COIN_COUNTERS_M4,a0
	move	a0,@_coin_counter_addr,L
	movi	(VMUX_INITMODE|VMUX_MODE4),a0
	move	a0,@VMUX_CONTROL
	rets

AddressTable	.long	InitAddresses, AddressSet1, AddressSet2
		.long	AddressSet3, AddressSet4

******************************************************************************
; A0 = Address Set to install (0-4)
	.globl	SetAddresses
 SUBR  SetAddresses
	move	a0,a0
	jrn	_invalid
	cmpi	4,a0
	jrgt	_invalid
	sll	5,a0
	addi	AddressTable,a0
	move	*a0,a0,L
	pushst
	dint
	call	a0
	popst
_invalid
	rets

****************************************************************
* Reset entry point

 SUBR	init_prog

	dint
	setf	16,1,0			;Field0 = Word sign extend
	setf	32,0,1			;Field1 = Long word
	movi	STCKST,sp		;Top of stack

	calla	InitPIC

;	.if	DEBUG
;	move	a0,@>1e00000		;Clr FPGA rom protect
;	.endif

					;>Manual sound board reset
; Moved to PU DIAGS
;	movi	0fe00h,a0  		;Hit reset bit
;	move	a0,@SOUND
;      	movi	100,a0			;Wait for it to catch
;	dsj	a0,$
;	movi	0ff00h,a0		;Let it go
;	move	a0,@SOUND

	move	@WDOGRAM,a0,L
	cmpi	WDOGNUM,a0
	jrne	initp50			;Powerup?

	move	@dirqtimer,a0
	cmpi	400,a0
	jrhs	#lockup			;Main loop died?


	.if	TUNIT
	move	@TALKPORT,a0		;Check if watchdog was real
	btst	B_WDOG,a0		;Bit should be low if dog fired
	jrnz	initp50			;No watchdog?
	.endif

	movk	AUD_LOCKUP,a0		;watchdog
	calla	AUD1
	jruc	#cont

#lockup

	movi	AUD_LOCKUP,a0		;main loop lockup
	calla	AUD1

#cont
	.if	DEBUG
	.else
	CALLERR	11,0			;Watch dog
	.endif


	movk	AUDSTAT,a0
	calla	GET_AUD			;0=AMode, 1=Game
	move	a1,a1
	jrz	WARMSET			;Attract mode glitch?

initp50
	calla	READ_DIP		;skip if UJ2 bit 6 set
	btst	6,a0
	jrnz	#skip_powerst
	jauc	POWERTST		;board test etc...
#skip_powerst


******************************************************************************

 SUBR	WARMSET

	dint
	setf	16,1,0			;Field0 = Word sign extend
	setf	32,0,1			;Field1 = Long word
	movi	STCKST,sp		;Top of stack

	calla	InitPIC

	jauc	POWERCMOS
PCMOSRET

	calla	init_all		;Initialize hardware
; These are stored in these reggies to protect them
	move	b5,@_serial_number,L
	move	b6,@_man_date,L
	calla	SecFuncCheck		;Check to make sure security functions
					;have not been mucked with
	calla	INIT_TAB		;Reset todays high score table

	calla	CKDIAG
	jrz	main_go			;No diag switches closed?

	CREATE	DIAG_PID,DIAG		;Fire off the diag process
	jruc	mainlp
main_go
	CREATE	AMODE_PID,attract_mode	;Start the attract mode

	;fall through

********************************
* Main loop


	clr	a14
	move	a14,@fight_debug

mainlp
	calla	process_dispatch

	move	a13,a13
	jrz	mainpok

	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	10,0
	.endif

mainpok

	move	@RAND,a1,L		;>Randomize
	rl	a1,a1
	move	@HCOUNT,a14
	rl	a14,a1
	add	sp,a1
	move	a1,@RAND,L

 .if DEBUG
	move	@dma_meter,a14
	jrz	#no_dmaline
	calla	draw_dma_meter
#no_dmaline
 .endif


;isn't there a less obvious place
;that we can remap the IO ???

	btst	5,a1
	jrz	_no_remap
	calla	RemapIO
_no_remap

	callr	switch_unstack
	calla	snd_update		;Update the sound calls

	.if	DEBUG
	callr	cputime_calcfree
	.endif

	move	@PCNT,a0
	addk	1,a0
	move	a0,@PCNT

	jruc	mainlp


#***************************************************************
* Unstack switch queue


 SUBRP	switch_unstack


#lp	move	@swstack_p,a3,L
	cmpi	swstacktop,a3		;Stack at start?
	jreq	#x			;Empty?
	move	@FREE,a0,L
	jrz	#x			;No processes left?

	move	*a3+,a0			;Get entry
	move	a3,@swstack_p,L		;Update stack
	sll	32-5,a0			;Max switch # 31
	srl	32-5-4,a0		;*16
	move	a0,a2
	add	a0,a2
	add	a0,a2			;*3
	addi	switch_t,a2
	move	*a2+,a1
	jrz	#lp			;No PID?
	move	*a2+,a7,L		;*Code
	movi	ACTIVE,a13		;*Proc list
	calla	GETPRC
	jruc	#lp

#x	rets


switch_t	;(Process ID or 0, *Routine)	;Put in audit??


	.if	TUNIT
	WL	0,0			;S0
	WL	0,0			;S1
	WL	0,0			;S2
	WL	0,0			;S3
	WL	0,0			;S4
	WL	0,0			;S5
	WL	0,0			;S6
	WL	0,0			;S7
	WL	0,0			;S8
	WL	0,0			;S9
	WL	0,0			;S10
	WL	0,0			;S11
	WL	0,0			;S12
	WL	0,0			;S13
	WL	0,0			;S14
	WL	0,0			;S15

	WL	LC_PID,LCOIN		;S16 - LEFT COIN (1)
	WL	RC_PID,RCOIN		;S17 - RIGHT COIN (2)
	WL	PSWPID,plyr_strtb1	;S18 - START 1
	WL	SLAM_PID,SLAM_SW	;S19 - SLAM TILT
	WL	DIAG_PID,DIAG		;S20 - TEST
	WL	PSWPID,plyr_strtb2	;S21 - START 2
	WL	DIAG_PID,SERVICE	;S22 - SERVICE CREDIT
	WL	CC_PID,CCOIN		;S23 - CENTER COIN (3)
	WL	CC_PID,XCOIN		;S24 - COIN 4
	WL	0,0			;S25 - START 3
	WL	0,0			;S26 - START 4
	WL	VOLBTN_PID,VOLBTN_PRESS	;S27 - VOLUME DOWN
	WL	VOLBTN_PID,VOLBTN_PRESS	;S28 - VOLUME UP
	WL	0,0			;S29
	WL	0,0			;S30
	WL	CC_PID,DBV			;S31

	.else

	WL	PSWPID,plyr_strtb4	;S7 IO20 - START 4
	WL	0,0			;S1
	WL	0,0			;S2
	WL	0,0			;S3
	WL	0,0			;S4
	WL	0,0			;S5
	WL	0,0			;S6
	WL	PSWPID,plyr_strtb3	;S7 - START 3
	WL	0,0			;S8
	WL	0,0			;S9
	WL	0,0			;S10
	WL	0,0			;S11
	WL	0,0			;S12
	WL	0,0			;S13
	WL	0,0			;S14
	WL	CC_PID,XCOIN		;S15 - COIN 4

	WL	LC_PID,LCOIN		;S16 - LEFT COIN (1)
	WL	RC_PID,RCOIN		;S17 - RIGHT COIN (2)
	WL	PSWPID,plyr_strtb1	;S18 - START 1
	WL	SLAM_PID,SLAM_SW	;S19 - SLAM TILT
	WL	DIAG_PID,DIAG		;S20 - TEST
	WL	PSWPID,plyr_strtb2	;S21 - START 2
	WL	DIAG_PID,SERVICE	;S22 - SERVICE CREDIT
	WL	CC_PID,CCOIN		;S23 - CENTER COIN (3)
	WL	0,0			;S24
	WL	0,0			;S25
	WL	0,0			;S26
	WL	0,0			;S27
	WL	0,0			;S28
	WL	0,0			;S29
	WL	0,0			;S30 - Snd IRQ
	WL	0,0			;S31
	.endif

are_we_waiting_for_inits
	move	a8,a0
	addi	HI_INPUT_PID,a0
	clr	a1
	not	a1
	jauc	EXISTP

#***************************************************************
* plyr_strtbx - Process player start button (Process)

 SUBR	plyr_strtb1
	clr	a8			;A8=Player #
	jruc	#go

 SUBR	plyr_strtb2
	movk	1,a8

#go

	move	@GAMSTATE,a0
	jrn	#die			;In diagnostics?

	cmpi	INPARTY,a0
	jreq	#die			;don't interrupt the win sequence

	move	@PSTATUS,a14
	btst	a8,a14
	jrnz	#die			;Player already started?

;New start.  kill the player's score and win count

	PUSH	a0
	MOVI	process_ptrs,A2
	movi	p1winstreak,a0
	movi	entered_inits,a1
	movi	MATCH_TIMERS,a3
	move	a8,a8
	jrz	#rstp1scor
	MOVI	process_ptrs+020H,A2
	movi	p2winstreak,a0
	movi	entered_inits+020h,a1
	movi	MATCH_TIMERS+020H,a3
#rstp1scor
	clr	a14
	move	a14,*a0,W		;wins
	MOVE	A14,*A1,L
	MOVE	A14,*A2,L
	MOVE	A14,*A3,L

	PULL	a0

	move	@OLD_PSTATUS,a14
	btst	a8,a14
	jrz	#reg			;Player on buyin screen?
;On the buyin screen.
	cmpi	INSELECT,a0
	jreq	#start_from_waitcont
	LOCKUP

#reg

;	cmpi	INWAITCONT,a0
;	jreq	#start_from_waitcont

	calla	CR_STRTP		;not a continue.  die on insuff $$
	jalo	#die

	move	@GAMSTATE,a0
	cmpi	INAMODE,a0
	jreq	#start_from_amode	;New start from amode?

	cmpi	INGAMEOVER,a0
	jreq	#start_from_gameover	;just like attract mode, really

	cmpi	INSELECT,a0
	jreq	#start_from_select

	cmpi	INPREGAME,a0
	jreq	#start_from_pregame

	cmpi	INGAME,a0
	jreq	#start_from_midgame

	LOCKUP

	jruc	#die			;cases we forgot...

#start_from_midgame

	movi	AUD_TOTSTARTS,a0	;inc total starts audit
	calla	AUD1

	calla	P_START			;eat the creds

	CREATE0	game_interrupt		;create the game proc

	jruc	#set_pstatus_and_die

#start_from_waitcont

	callr	are_we_waiting_for_inits
	jrnz	#die

	calla	CR_CONTP		;enuff creds?
	jalo	#die
	calla	P_CONT			;eat the creds

	movi	AUD_CONTTAKN,a0		;inc continues taken audit
	calla	AUD1


	jruc	#set_pstatus_and_die	;waitcont watches for PSTATUS
					; changes, so we don't need to

#start_from_amode

	clr	a0

	move	a0,@are_we_waiting_f
	move	a0,@OLD_PSTATUS
	CALLA	INIT_LADDER_TABLE

#start_from_gameover

	movk	1,a0
	move	a0,@no_pin_check

	movi	AUD_PRESTARTS,a0	;inc attract mode starts audit
	calla	AUD1

	movi	AUD_TOTSTARTS,a0	;inc total starts audit
	calla	AUD1

	calla	P_START			;eat the creds


;If any button is pressed at the same time as the start button,
;then skip all select stuff.  Otherwise, game acts as it will on location

	clr	a0
	move	a0,@match_cnt


 .if DEBUG
	move	a0,@skip_select
	move	a0,@fight_debug

	.ref	get_all_buttons_cur2
	calla	get_all_buttons_cur2
	jrz	#nobutn

	movk	1,a0
	move	a0,@skip_select
	move	a0,@fight_debug

	.ref	get_all_sticks_cur2
	calla	get_all_sticks_cur2
	jrz	#nobutn

	movi	-1,a0
	move	a0,@skip_select

#nobutn
 .endif


	CREATE0	game_loop		;create the game proc
	jruc	#set_pstatus_and_die


#start_from_select
	callr	are_we_waiting_for_inits
	jrnz	#die

	movi	AUD_TOTSTARTS,a0	;creds have already been checked,
	calla	AUD1			; so we know we have enough.
	calla	P_START
	jruc	#set_pstatus_and_die


#start_from_pregame
	movi	AUD_TOTSTARTS,a0	;total starts
	calla	AUD1
	calla	P_START			;eat creds
	CREATE0	game_loop		;make a new game loop.  This will
	clr	a0
	move	a0,@are_we_waiting_f
	jruc	#set_pstatus_and_die	;kill the old one and drop back
					;into the select screen.

#set_pstatus_and_die
	movk	1,a0			;set the player bit in PSTATUS
	sll	a8,a0
	move	@PSTATUS,a14
	or	a0,a14
	move	a14,@PSTATUS
	movi	49h,a0
	calla	triple_sound

	clr	a0
	MOVE	A0,@IRQSKYE

	movi	AUD_WINSTREAK,A0
	calla	KILL_AUD
	movi	AUD_PINSPEED,A0
	calla	KILL_AUD
	movi	AUD_BEATEN,A0
	calla	KILL_AUD

#die
	DIE


#*****************************************************************************
* game loop
*

	STRUCTPD
	LONG	BLINK_PROC

 SUBRP	game_interrupt

;Someone has bought in during gameplay of a one player game!
;Print challenger comes message

	movk	1,a0
	move	a0,@HALT

;If a player buys in during a one player game.  We must decrement pxcpu_ladder
;because we haven't defeated that cpu opponent yet!

	MOVE	@CURRENT_LADDER,A0,L
	SUBI	020H,A0
	MOVE	A0,@CURRENT_LADDER,L

;If match/rnd winner anouncement is on screen, kill it
	movi	ANNC_PID,a0
	clr	a1
	not	a1
	calla	EXISTP
	jrz	#nope
	move	a0,a7

	move	*a0(BLINK_PROC),a0,L
	jrz	#no_blink_proc
	calla	KILL
#no_blink_proc
	move	a7,a0
	calla	KILL

	movi	CLSNEUT|TYPTEXT|SUBTXT,a0
	calla	obj_del1c		;delete text/plates

	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
	calla	obj_del1c		;delete text/plates

#nope

	movi	LN1b_setup,a2
	calla	setup_message
	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
	move	a0,@mess_objid		;OBJ ID's for text
	movi	#str_game,a4
	calla	print_string_C2

	movi	LN2b_setup,a2
	calla	setup_message
	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
	move	a0,@mess_objid		;OBJ ID's for text
	movi	#str_over,a4
	calla	print_string_C2

	.ref	fade_down_half
	movi	#no_fade,a10
	CREATE0	fade_down_half

	SLEEP	120

	movk	1,a0
	move	a0,@no_pin_check

 SUBRP	game_loop

 .if DEBUG

	movk	3,a0		;2 humans
	.ref	skip_select
	move	@skip_select,a14
	jrz	#noskp
	jrp	#nodrn
	movk	2,a0		;1 human 1 drone
#nodrn
	move	a0,@PSTATUS
#noskp
 .endif

	JSRP	robo_check
	JSRP	select_screen
	clr	a0
	move	a0,@no_pin_check

do_pregame
	movi	INPREGAME,a14		;set GAMSTATE
	move	a14,@GAMSTATE
	movi	PREGAME_PID,a14		;set our PID
	move	a14,*a13(PROCID)

	move	@match_cnt,a0
	inc	a0
	move	a0,@match_cnt

	move	@PSTATUS,A0
	CMPI	3,A0
	JREQ	NOT_FINISHED_GAME

	MOVE	@CURRENT_LADDER,A0,L
	.REF	TEMP_LADDER
;	CMPI	LADDER+020H,A0
	CMPI	TEMP_LADDER-020H,A0
	JRNE	NOT_FINISHED_GAME
	JSRP	GAME_BEATEN
	JSRP	CREATE_TEXT_LINE
	JAUC	THIS_GAME_IS_BEATEN

NOT_FINISHED_GAME
	JSRP	pregame_show

#game
	movi	INGAME,a14		;set GAMSTATE
	move	a14,@GAMSTATE
	movi	GAME_PID,a14		;set our PID
	move	a14,*a13(PROCID)

	clr	a0
	move	a0,@p1rounds
	move	a0,@p2rounds

	movk	1,a0
	move	a0,@current_round
;#new_round

	JSRP	start_match

;The only time we return from start_match, is when 2 rounds have been
;won and the game must goto:

;1.  Buy-in screen for 1 or 2 player games
;2.  Ladder screen for the next matchup
;3.  Finale screens

;clear out howard speech flag so he can say it again on new select screen
	CLR	A0
	MOVE	A0,@DONE_HOWARD

	movi	60,a0
	move	a0,@are_we_waiting_f

;Increment his win count
	callr	increment_wincount

;Did a human player lose?
	move	@PSTATUS,a0
	move	@match_winner,a1
	andn	a1,a0
	jrnz	#go_buyin

;Check to see if he has beaten the game.
;jrnz	#party				;Entire game beaten!

;This player will keep on playing.
;Display ladder of progreesion which shows his next opponent.

	move	@match_winner,a10
	dec	a10
	jsrp	pin_speed_in_case
	jruc	do_pregame

#go_buyin
;Display 2 player buyin screen.
;Turn on appropriate messages for each player
;One guy lost, check if he achieved a high score.  (Most wins)
;If so, allow him to enter initials just on his panel.

	MOVE	@PSTATUS,A1
	CMPI	3,A1
	JRNE	NO_NEW_WINNER
	move	@match_winner,a1
	NOT	A1
	ANDI	3,A1
	DEC	A1
	SLL	4,A1
	ADDI	p1winstreak,A1
	MOVE	*A1,A1
	JRZ	NO_NEW_WINNER
	MOVI	CONGRATULATIONS,A0
	MOVE	@HCOUNT,A1
	SRL	1,A1
	JRNC	DO_THE_VOICE
	MOVI	SOMEHOW_I_DONT_THINK,A0
DO_THE_VOICE
	CALLA	ADD_VOICE
NO_NEW_WINNER


	move	@PSTATUS,a0
	move	a0,@OLD_PSTATUS

	move	@PSTATUS,a0
	move	@match_winner,a1
	and	a1,a0
	jrnz	#notcpuwin
;The cpu won
	clr	a0
	move	a0,@match_winner

	MOVE	@CURRENT_LADDER,A0,L
	SUBI	020H,A0
	MOVE	A0,@CURRENT_LADDER,L

#notcpuwin
	move	@match_winner,a0
	move	a0,@PSTATUS

	.ref	buyin_select
	JSRP	buyin_select

;Clear the loser's wincount
	movi	p1winstreak,a1
	move	@match_winner,a0
	CMPI	4,A0
	JREQ	NO_CLEAR_WINSTREAK
	cmpi	1,a0
	jrnz	#notp1
	movi	p2winstreak,a1

#notp1	clr	a14
	move	a14,*a1
NO_CLEAR_WINSTREAK

	movi	INWAITCONT,a14		;set GAMSTATE
	move	a14,@GAMSTATE
	movi	WAITCONT_PID,a14	;set our PID
	move	a14,*a13(PROCID)

	jruc	do_pregame

#buyin_mod
	.long	wwfselbkBMOD
	.word	-40,0
	.long	0

#no_fade
	.long	LGMDBLU,scorep,0
LN1b_setup
	JAM_STR	lgmd_ascii,12,2,200,128-10-61+5,LGMDBLU,0
	.ref	lgmd_ascii
LN2b_setup
	JAM_STR	lgmd_ascii,6,2,200,128+12,LGMDBLU,0
#str_game
	.byte	"CHALLENGER",0
#str_over
	.byte	"FOUND!",0
	.even

#str_text
	.string	"SINGLE PLAYER GAME",0
#str_text2
	.string	"LADDER OF PROGRESSION",0
	.even

#*****************************************************************************

 SUBRP	increment_wincount

;This will not increment if it is a CPU player

	move	@PSTATUS,a0
	move	@match_winner,a1
	and	a1,a0
	jrz	#done

	movi	p1winstreak,a1
	cmpi	1,a0
	jreq	#p1
	movi	p2winstreak,a1

#p1
	move	*a1,a14,W
	inc	a14
	move	a14,*a1,W

#done
	rets

#*****************************************************************************
* Get random # with mask
* A0=Mask
* >A0=Rnd # (Pass CC)
* Trashes scratch

 SUBRP	rnd

	move	@RAND,a1,L
	rl	a1,a1
	move	@HCOUNT,a14
	rl	a14,a1
	add	sp,a1
	move	a1,@RAND,L

	and	a1,a0
	rets



#*****************************************************************************

COLRPRC
	movi	COLRPID,a0
	calla	KIL1C		;KILL ALL COLOR UPDATE PROCESSES
	clr	a0
	move	a0,@PALFRAM,L
;	movi	scorep,a0	;Score area palette
	jauc	pal_getf


#*****************************************************************************


 SUBRP	start_match

;	calla	display_blank
;	calla	WIPEOUT			;CLEAN SYSTEM OUT

	move	@total_matches,a14,W
	inc	a14
	move	a14,@total_matches,W
	CALLA	SPECIAL_WIPEOUT

 SUBR	start_match2


	.ref	pal_clean
	calla	pal_clean


	movk	1,a0			;page flipping on
	move	a0,@dpageflip
	move	a0,@HALT

	movi	[339h,0],a0
	move	a0,@WORLDTLX,L

	movi	[0ffd6h,0],a0
	move	a0,@WORLDTLY,L

	movi	ring_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	CALLA	CLEAR_COUNTERS

	CREATE	CROWD_PID,crowd_anim
	CREATE	TIMER_PID,match_timer
	CREATE	RTCLOCK_PID,realtime_clock
	CREATE0	SHIFT_BARS_IN_Z

 .if DIR_DEBUG
	CREATE0	dir_debug
 .endif

 .if SCRT_DEBUG
	CREATE0	scrt_debug
 .endif

	movi	ROPE_FRONT,a11
	CREATE	ROPE_PID,rope
	move	a0,@front_rproc,L

	movi	ROPE_BACK,a11
	CREATE	ROPE_PID,rope
	move	a0,@back_rproc,L

	movi	ROPE_LEFT,a11
	CREATE	ROPE_PID,rope
	move	a0,@left_rproc,L

	movi	ROPE_RIGHT,a11
	CREATE	ROPE_PID,rope
	move	a0,@right_rproc,L

	clr	a0			;clear the winner bits
	move	a0,@match_winner
	MOVE	A0,@DAM_MULT
	MOVE	A0,@HAVE_WE_AUDITED_THIS_GAME
;MJT Start
	move	a0,@no_debris
;MJT End

	movi	AUD_VSHUMS,a0		;increment the battles started bit
	move	@PSTATUS,a14
	cmpi	03h,a14
	jreq	#aud_vshumf
	movi	AUD_VSCPUS,a0
#aud_vshumf
	calla	AUD1
	
	callr	CLEAR_PROCESSES

	calla	init_life_data

	MOVE	@PSTATUS,A0
	JRZ	NORMAL_INIT	;IN ATTRACT MODE
	CMPI	3,A0
	JREQ	NORMAL_INIT
	CLR	A10
	movi	PSIDE_PLYR1,a9			;side on
	move	@index1,a11			;wrestler
	SRL	1,A0
	JRC	WE_PLAYING_PLAYER_1
	movi	PSIDE_PLYR2,a9			;side on
	move	@index2,a11			;wrestler
	INC	A10
WE_PLAYING_PLAYER_1
	movi	PTYPE_PLAYER,a8			;player type
	SCREATE	WMAIN_PID,wrestler_main		;player 1
	MOVE	A10,A9
	CREATE	GETUP_PID,getup_meter

	MOVE	@NUM_OPPS,A3
	CMPI	1,A3
	JREQ	NO_START_WHICH_NAME
	CREATE0	WHICH_NAME
NO_START_WHICH_NAME
	MOVE	@CURRENT_LADDER,A4,L
	MOVE	*A4,A4,L
	MOVK	2,A10
CREATE_NEXT_WRESTLER
	CALLA	SORT_OUT_WRESTLER_NUM
*jakeeee if you want a specific wrestler, put his number in A11 here !
	
	movi	PTYPE_DRONE,a8			;player type
	movi	PSIDE_NONE,a9			;side on

 .if DEBUG
	move	@skip_select,a0
	jrge	#skp
	movk	6,a11	;make him a doink
#skp
 .endif
	SCREATE	WMAIN_PID,wrestler_main		;player 1
	SRL	8,A4
	INC	A10
	DEC	A3
	JRNZ	CREATE_NEXT_WRESTLER
	JRUC	BEGIN_BATTLE

NORMAL_INIT
	movi	PTYPE_PLAYER,a8			;player type
	move	@PSTATUS,a0
	btst	0,a0
	jrnz	#ok
	movi	PTYPE_DRONE,a8			;player type
#ok	movi	PSIDE_PLYR1,a9			;side on
	clr	a10				;wres num
	move	@index1,a11			;wrestler
	SCREATE	WMAIN_PID,wrestler_main		;player 1
	MOVE	A10,A9
	CREATE	GETUP_PID,getup_meter

	movi	PTYPE_PLAYER,a8			;player type
	move	@PSTATUS,a0
	btst	1,a0
	jrnz	#ok1
	movi	PTYPE_DRONE,a8			;player type
#ok1	movi	PSIDE_PLYR2,a9			;side on
	movk	1,a10				;wres num
	move	@index2,a11			;wrestler
	SCREATE	WMAIN_PID,wrestler_main		;player 2
	MOVE	A10,A9
	CREATE	GETUP_PID,getup_meter

BEGIN_BATTLE
	;play the battle music

	movi	40,a3
	move	@skip_select,a14
	jrnz	#marked_snd
	movi	25,a3
	calla	SNDSND
	CLR	A1
	MOVI	175,A0
	CALLA	SET_LOWER_VOL
#marked_snd

	;SET CROWD VOLUME TO 100% OF MASTER VOLUME
	MOVI	55ABH+5,A3
	CALLA	SNDSND
	MOVI	0FF00H,A3
	CALLA	SNDSND
	;and the crowd
	movi	2065,a3
	calla	SNDSND

	CALLA	CLEAR_SPEECH_REPEAT

	callr	init_joystat
	callr	init_joy_dtime

	calla	init_special_objlist

	clr	a0
	move	a0,@match_over

	CALLA	RESETUP_PROGRESS

	SLEEPK	1

	calla	BGND_UD1
	SLEEPK	1

	;if this is the first match after attract mode, cue vince.
	move	@total_matches,a14
	dec	a14
	jrnz	#no_vince_intro
	move	@PSTATUS,A0
	CMPI	3,A0
	JRNE	#no_vince_intro

	movi	0E0h,a0
	calla	ADD_VOICE
	MOVI	R_OH_YEAH,A0
	calla	ADD_VOICE

#no_vince_intro

	calla	BGND_UD1
	SLEEPK	2
	calla	BGND_UD1

	clr	a8				;left meter for player 0
	movk	1,a9				;right meter for player 1
	move	@PSTATUS,a0
	jrz	meter_pointers_set
	cmpi	3,a0
	jreq	meter_pointers_set

	movk	2,a9
	srl	1,a0
	jrz	meter_pointers_set
	movk	1,a9
	movk	2,a8
meter_pointers_set
	CREATE	METER_PID,meters		;life/turbo/names

	movk	1,a0
	move	a0,@DISPLAYON

	clr	a0
	move	a0,@IRQSKYE

	CREATE0 DO_SET_IMAGES
	PUSHP	A0
	movk	20,a8
	movk	6,a9
	JSRP	OPEN_PROGRESS_SCREEN
	PULLP	A0
	CALLA	KILL

	clr	a1
	callr	get_process_ptr
	clr	a14
	move	a14,*a0(DELAY_METER)

	movk	1,a1
	callr	get_process_ptr
	clr	a14
	move	a14,*a0(DELAY_METER)

#loop
	calla	check_collisions
	calla	set_images

	move	@PCNT,a0
	ANDK	15,a0

	jrnz	#no

	calla	BGND_UD1
#no

	SLEEPK	1

	move	@match_over,a0
	jrz	#not_over

	callr	postgame_audits

	RETP

DO_SET_IMAGES
	CALLA	set_images
	SLOOP	1,DO_SET_IMAGES

#not_over

	callr	scroll_world

	move	@round_tickcount,a0
	inc	a0
	move	a0,@round_tickcount

	move	@match_time,a0,L	;10's & 1's
	jrnz	#loop

	.if	DEBUG
	move	@fight_debug,a14
	jrz	#norm
#wraparound
	movi	00090009h,a14
	move	a14,@match_time,L
	jruc	#not_over
	.endif

#norm
	movk	1,a0
	move	a0,@HALT

*!fix!
	clr	a1
	callr	get_process_ptr

	move	a1,*a0(OBJ_XVEL),L
	move	a1,*a0(OBJ_YVEL),L
	move	a1,*a0(OBJ_ZVEL),L
	movi	-1,a1
	move	a1,@MATCH_TIMERS,L      

	movk	1,a1
	callr	get_process_ptr

	clr	a1
	move	a1,*a0(OBJ_XVEL),L
	move	a1,*a0(OBJ_YVEL),L
	move	a1,*a0(OBJ_ZVEL),L
	movi	-1,a1
	move	a1,@MATCH_TIMERS+32,L      

;Timer on the round expired

	calla	DO_CROWD_CHEER

	movi	#message_setup,a2
	calla	setup_message

	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
	.ref	mess_objid
	move	a0,@mess_objid

	movi	#message_string,a4
	calla	print_string_C2

	PUSH	a8
	movi	FNT9RED_P,a8
	movi	FNT9WHT_P,a9
	CREATE0	blink_pals
	move	a0,a11
	PULL	a8

;Time's up.  pick a winner.
;For now, random winner in case of tie - FIX!!!??

	movi	70,a9
#wait	SLEEPK	1
	PUSH	a9,a11
	calla	set_images		;Make shadows shift...
	PULL	a9,a11
	dsjs	a9,#wait

;	callr	set_winner
;	X32	a3
;	addi	process_ptrs,a3
;	move	*a3,a10,L

	.ref	announce_rnd_winner
	CREATE	ANNC_PID,announce_rnd_winner

	movi	28,a9
#wait1	SLEEPK	1
	PUSH	a9,a11
	calla	set_images		;Make shadows shift...
	PULL	a9,a11
	dsjs	a9,#wait1

	move	a11,a0
	calla	KILL

	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
	calla	obj_del1c		;delete text/plates

#wait2	SLEEPK	1
	calla	set_images		;Make shadows shift...
	move	@HALT,a0
	jrnz	#wait2

	move	@p1rounds,a0
	cmpi	2,a0
	jrz	#end
	move	@p2rounds,a0
	cmpi	2,a0
	jrnz	#not_end

#end
;Match is over.
	move	a0,@match_over
#not_end
	jruc	#loop
CLEAR_PROCESSES
	clr	a0
	movi	wres0_objs,a1
	movi	NUM_WRES*MAX_PIECES,a2
#clr_lp
	move	a0,*a1+,L
	dsj	a2,#clr_lp

	movi	process_ptrs,a1
	movi	NUM_WRES,a2
#clr_ptr
	move	a0,*a1+,L
	dsj	a2,#clr_ptr
	rets

 SUBR	set_winner
;Returns winner (0,1 OR 2) in a3

	PUSH	A4
	move	@PSTATUS,A3
	CMPI	3,A3
	JREQ	NORMAL_CHECK
	clr	a1
	srl	1,a3
	jrc	health1_set
	inc	a1
health1_set
	PUSH	A1
	calla	get_health
	move	a0,a2
	movk	2,a1
	jruc	renter_normal

NORMAL_CHECK
	clr	a1
	PUSH	A1
	calla	get_health
	move	a0,a2
	movk	1,a1
renter_normal
	PUSH	A1
	calla	get_health
	move	a0,a4

	PULL	A3
	PULL	A1
	SUB	A2,A4
	JRNE	#NORMAL_SET
	MOVE	@HCOUNT,A4
	SRL	1,A4
	JRNC	#WINNER_SET
	JRUC	#SWAP_WINNER
#NORMAL_SET
	JRGE	#WINNER_SET
#SWAP_WINNER
	MOVE	A1,A3
#WINNER_SET

	movi	p1rounds,a1
	move	a3,a3
	jrz	#p1winsround

	movi	p2rounds,a1
	cmpi	1,a3
	jreq	#p1winsround

	move	@PSTATUS,a0
	srl	1,a0
	jrc	#p1winsround
	movi	p1rounds,a1

#p1winsround
	move	*a1,a0
	inc	a0
	move	a0,*a1

;If he's won two rounds, call him the winner.
;	cmpi	2,a0
;	jrlt	#go_match

	move	a3,a0
	inc	a0
	CMPI	3,A0
	JRNE	NO_NEED_TO_INC
	INC	A0
NO_NEED_TO_INC
	move	a0,@match_winner

#go_match
;Go another round
	PULL	A4
	rets

	.ref	font9_ascii

#message_setup
	JAM_STR	font9_ascii,3,0,200,58,FNT9WHT_P,0

#message_string
	.string "TIME IS UP!",0
	.even



 SUBR	blink_pals
;a8=FNT9RED_P
;a9=FNT9WHT_P

	move	a8,a0
	calla	pal_getf
	move	a0,*a13(PDATA)

	move	a9,a0
	calla	pal_getf
	move	a0,*a13(PDATA+16)

	SLEEPK	2

#top	
	move	*a13(PDATA),a9

;	movi	FNT9RED_P,a0
;	calla	pal_getf
;	move	a0,a9

	move	*a13(PDATA+16),a0

;	movi	FNT9WHT_P,a0
;	calla	pal_getf

	movi	OBJLST,a14
#lp
	move	*a14,a14,L
	jrz	#x
	move	*a14(OPAL),a2
	cmp	a0,a2
	jrne	#lp
	move	a9,*a14(OPAL)
  	jruc	#lp

#x	SLEEPK	4

	move	*a13(PDATA),a9
;	movi	FNT9RED_P,a0
;	calla	pal_getf
;	move	a0,a9

	move	*a13(PDATA+16),a0

;	movi	FNT9WHT_P,a0
;	calla	pal_getf

	movi	OBJLST,a14
#lp2
	move	*a14,a14,L
	jrz	#x2
	move	*a14(OPAL),a2
	cmp	a9,a2
	jrne	#lp2
	move	a0,*a14(OPAL)
  	jruc	#lp2

#x2	SLEEPK	7

	jruc	#top


ring_mod
	.long	ringBMOD	;wrestling ring
	.word	105,-450	;x,y
	.long	0

#*****************************************************************************
*
* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
* can probably get rid of this crap once scroller is finished
* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

 SUBRP	update_positions

	move	*a13(PLYRNUM),a0
	X32	a0

	move	a0,a1
	addi	wrestler_x,a1
	move	*a13(OBJ_XPOS),a14,L
	move	a14,*a1,L

	move	a0,a1
	addi	wrestler_y,a1
;;;;	move	*a13(OBJ_YPOS),a14,L
	move	*a13(GROUND_Y),a14
	sll	16,a14

	jrnn	#ok

	clr	a14
#ok	move	a14,*a1,L

	move	a0,a1
	addi	wrestler_z,a1
	move	*a13(OBJ_ZPOS),a14,L
	move	a14,*a1,L
	rets

#*****************************************************************************

BUFFER	equ	[20,0]
#BUFFER	equ	[20,0]

LIMITXL	.EQU	[12FH,0]
LIMITXR	.EQU	[5E8H,0]
LIMITYT	.EQU	[200H,0]
LIMITYB	.EQU	[97h,0]

 SUBRP	scroll_world

	MMTM	SP,A8,A9,A10,A11

	move	@HALT,a0
	jrnz	#x

	move	@PSTATUS,A3
	JRZ	NORMAL_SCROLLER
	CMPI	3,A3
	JREQ	NORMAL_SCROLLER
	MOVI	wrestler_z+040h,a9
	movI	wrestler_y+040H,a11
	move	@wrestler_x+040h,a1,L

	movI	wrestler_z,a8
	move	@wrestler_x,a0,L
	movI	wrestler_y,a10
	SRL	1,A3
	JRC	SCROLLER_ON
	movI	wrestler_z+020h,a8
	move	@wrestler_x+020h,a0,L
	movI	wrestler_y+020H,a10

	JRUC	SCROLLER_ON

NORMAL_SCROLLER
	movI	wrestler_z,a8
	movI	wrestler_z+20h,a9
	movI	wrestler_y,a10
	movI	wrestler_y+020H,a11
	move	@wrestler_x,a0,L
	move	@wrestler_x+20h,a1,L
SCROLLER_ON

	add	a0,a1
	srl	1,a1
	subi	[200,0],a1		;middle of screen

	move	@WORLDTLX,a2,L
	sub	a2,a1
	jrp	#pos

	addi	#BUFFER,a1
	jrp	#wide
	jruc	#cont
#pos
	subi	#BUFFER,a1
	jrn	#wide

#cont
	sra	3,a1
	add	a1,a2

	cmpi	[12fh,0],a2
	jrlt	#wide
	cmpi	[5e8h,0],a2
	jrgt	#wide

	move	a2,@WORLDTLX,L
#wide

;	move	@wrestler_z,a0,L
;	move	@wrestler_z+20h,a1,L

	move	*A8,a0,L
	move	*A9,a1,L
	add	a0,a1
	srl	1+16,a1
	movi	Y_SCALE_MULTIPLIER,a0
	mpys	a0,a1
	move	a1,a2

;	move	@wrestler_y,a0,L
;	move	@wrestler_y+20h,a1,L

	move	*A10,a0,L
	move	*A11,a1,L
	add	a0,a1
	srl	1,a1
	sub	a1,a2
	subi	[220+6,0],a2		;middle of screen

	move	@WORLDTLY,a1,L
	sub	a1,a2
	sra	3,a2
	add	a2,a1
;Don't allow scroller to go past front fence
	cmpi	[97h,0],a1
	jrgt	#low
	move	a1,@WORLDTLY,L
#low
#x
	MMFM	SP,A8,A9,A10,A11
	rets

LIMITXL	.EQU	[12FH,0]
LIMITXR	.EQU	[5E8H,0]
LIMITYT	.EQU	[200H,0]
LIMITYB	.EQU	[97h,0]
; SUBRP	scroll_world
; 
;	RETS
;
;	MOVE	@WORLDTLY,A0
;	ADD	A2,A1
;
;	MOVE	@WORLDTLX,A1
;	ADD	A3,A1
;
;	MOVI	LIMITYT,A2
;	CMP	A2,A0
;	JRLT	NOT_AT_TOP
;	MOVE	A2,A0
;	JRUC	NOT_AT_BOT
;NOT_AT_TOP
;	MOVI	LIMITYB,A1
;	CMP	A2,A0
;	JRGT	NOT_AT_BOT
;	MOVE	A2,A0
;NOT_AT_BOT
;	MOVI	LIMITXR,A2
;	CMP	A2,A1
;	JRLT	NOT_AT_RIGHT
;	MOVE	A2,A1
;	JRUC	NOT_AT_LEFT
;NOT_AT_RIGHT
;	MOVI	LIMITXL,A2
;	CMP	A2,A1
;	JRGT	NOT_AT_LEFT
;	MOVE	A2,A1
;NOT_AT_LEFT
;	MOVE	A0,@WORLDTLY,L
;	MOVE	A1,@WORLDTLX,L
;	rets

#*****************************************************************************
*
* a8 	= player type (PLAYER, DRONE, REFEREE)
* a9 	= player side (PLYR1, PLYR2, NONE)
* a10	= player number
* a11	= wrestler number


 SUBRP	wrestler_main

	move	a8,*a13(PLYR_TYPE)
	move	a9,*a13(PLYR_SIDE)
	move	a10,*a13(PLYRNUM)
	move	a11,*a13(WRESTLERNUM)

	MOVE	A10,A0
	CMPI	2,A0
	JRGE	NO_POINT_ITS_A_DRONE
	CLR	A1
	SLL	5,A0
	ADDI	MATCH_TIMERS,A0
	MOVE	A1,*A0,L
NO_POINT_ITS_A_DRONE

	movi	112,a0
	move	a0,*a13(OBJ_PRIORITY)

	move	a10,a1
	callr	set_process_ptr

	callr	reset_start

	clr	a1			;y pos
	movi	D2ST2B03,a2		;* image
	movi	110,a3			;z pos
	movi	DMAWNZ|M_3D,a4		;DMA flags
;Pixel packing DEBUG!!
;	movi	DMAWAL|M_3D,a4		;DMA flags	;write z & nz
	move	a4,*a13(OBJ_CONTROL)
	movi	CLSPLYR | TYPPLYR,a5	;object ID
	clr	a6			;x vel
	clr	a7			;y vel

	move	a13,b0
	move	*b0(WRESTLERNUM),b0
	X32	b0

	movk	MAX_PIECES,a9

	move	*a13(PLYRNUM),a14
	jrz	#nopal_chng
	move	@PSTATUS,a3
	jrz	#normal_pal_check
	cmpi	3,a3
	jreq	#normal_pal_check
	cmpi	1,a14
	JRLE	#nopal_chng
	move	@index1,a8
	srl	1,a3
	jrc	#compare_index
	move	@index2,a8
#compare_index
	move	*a13(WRESTLERNUM),a14
	CMP	A8,A14
	JRNE	#nopal_chng
	JRUC	#alt_pal

#normal_pal_check
	move	@index2,a14
	move	@index1,a8
	cmp	a8,a14
	jrnz	#nopal_chng
;Yes, we must change player 2 to the alternate pal for this wrestler
#alt_pal
	addi	#wrestler_pal_alt,b0
	move	*b0,b0,L		;* palette
	jruc	#nxt_obj

#nopal_chng
	addi	#wrestler_pal,b0
	move	*b0,b0,L		;* palette

#nxt_obj
	PUSH	b0
	calla	BEGINOBJP
	PULL	b0
	move	a8,-*a10,L
	dsj	a9,#nxt_obj

	calla	BEGINOBJP
	move	a8,*a13(ATTIMG_IMG),L
	clr	a0
	move	a0,*a13(ATTIMG_CUR_FRAME),L
	move	a0,*a13(ATTIMG_LAST_FRAME),L
	move	a0,*a13(GETUP_TIME)

	move	*a8(OPAL),a0
	move	a0,*a13(OBJ_PAL)

;;	movi	DNKBLU_P,a0
	movi	shadow_p,a0
	calla	pal_getf
	move	*a13(OBJ_BASE),a8,L
	move	*a8,a8,L		;1st object
	move	a0,*a8(OPAL)		;set palette for shadow

	movi	MAT_Y,a0
	move	a0,*a13(GROUND_Y)

	clr	a0
	move	a0,*a13(ATTACK_TIME)
;MJT Start
;	move	a0,*a13(BURNOUT_COUNT)
;MJT End
	move	a0,*a13(INRING)
	MOVE	A0,*A13(COMBO_START)
	MOVE	A0,*A13(COMBO_COUNT)

	move	a0,*a13(OBJ_XVEL),L
	move	a0,*a13(OBJ_YVEL),L
	move	a0,*a13(OBJ_ZVEL),L
	move	a0,*a13(SHADTRAIL_PROC),L
;MJT Start
	move	a0,*a13(I_WILL_DIE)
;MJT End


	calla	clear_damage_log
	callr	ani_init		;start default animation

	move	@PCNT,a14
	move	a14,*a13(FOOT_PCNT),W	;init foot timer

 .if COL_DEBUG
	move	a13,a10
	CREATE	CDEBUG_PID,collis_debug
	move	a13,a10
	CREATE	CDEBUG_PID,collis_debug2
 .endif

	callr	init_smoves
	calla	set_collision_boxes


;#wait	MOVE	@VCOUNT,a0
; andi	7,a0
; jrnz	#wait
; TINTON
; move	@VCOUNT,a0
; PUSH	a0


; move	@VCOUNT,a0
; PULL	a1
; sub	a1,a0
; TINTOFF

	SLEEPK	1

	callr	calc_closest


#loop
;----->	calla	animate_wrestler

	calla	set_collision_boxes

	callr	confine_wrestler

	callr	update_newfacing

	callr	update_positions	;used by scroller (temp!)

;	TINTOFF
	SLEEPK	1
;	TINTON


	move	*a13(PLYR_TYPE),a0
	jrz	#hmn			;Human?
	calla	drone_main
#hmn
	MOVE	*A13(RISK),A0
	JRZ	NO_DECREMENT
	DEC	A0
	MOVE	A0,*A13(RISK)
NO_DECREMENT

	callr	update_joystat
	callr	count_button_presses

	callr	wrestler_veladd		;<-------
	callr	wrestler_friction	;<-------

	calla	animate_wrestler	;<-------
	calla	set_collision_boxes	;<-------

	callr	confine_wrestler	;<--- temp fix!

;RJR START
	callr	calc_closest2
;RJR END

	callr	move_wrestler

;---->	callr	wrestler_veladd
;---->	callr	wrestler_friction

	callr	update_links

	calla	set_collision_boxes
	calla	overlap_collision


	move	*a13(ANIMODE),a0
	btst	MODE_KEEPATTACHED_BIT,a0
	jrz	#no_attach
	callr	master_keep_attached
#no_attach


	move	*a13(ANIMODE),a0
	btst	MODE_NOAUTOFLIP_BIT,a0
	jrnz	#no_flip
	move	a13,a0
	callr	set_wrestler_xflip
#no_flip

	callr	update_joy_dtime

;	move	*a13(BURNOUT_COUNT),a0
;	jrz	#skp
;	dec	a0
;	move	a0,*a13(BURNOUT_COUNT)
;#skp
;This is for delaying the reading of buttons just after regaining
;control from being flung.  This will stop inadvertant moves from happening
;while the player is still whacking on his buttons

	move	*a13(DELAY_BUTNS),a0
	jrz	#skp2
	dec	a0
	move	a0,*a13(DELAY_BUTNS)
#skp2
;This is for delaying collisions when a player gets up

	move	*a13(SAFE_TIME),a0
	jrz	#skp3
	dec	a0
	move	a0,*a13(SAFE_TIME)
#skp3
;This is for delaying the reappearance of a getup meter

	move	*a13(DELAY_METER),a0
	jrz	#skp4
	dec	a0
	move	a0,*a13(DELAY_METER)
#skp4
;This is for delaying the reappearance of a getup meter

	move	*a13(IMMOBILIZE_TIME),a0
	jrz	#skp5
	dec	a0
	move	a0,*a13(IMMOBILIZE_TIME)
#skp5
;MJT Start
;This is for walking fast powerup

	move	*a13(WALK_FAST),a0
	jrz	#skp6
	dec	a0
	move	a0,*a13(WALK_FAST)
#skp6
;MJT End


	move	*a13(GETUP_TIME),a0
	jrz	#loop
	move	*a13(DELAY_METER),a14
	jrz	#reg
;Don't want to allow getup time to be set this close to last time!
	;allow the meter to come right back if stay_down is set
	.if DEBUG
	move	@stay_down,a14
	jrnz	#reg
	.endif
	clr	a0
	move	a0,*a13(GETUP_TIME)
	jrz	#loop
#reg	

;Refill up meter half as fast
;	move	@PCNT,a14
;	btst	0,a14
;	jrz	#skip

	.if DEBUG
;If stay_down flag is set, don't decrement
	move	@stay_down,a14
	jrz	#dec
	inc	a0
#dec
	.endif
	dec	a0

	move	a0,*a13(GETUP_TIME)
	jrz	#clr_dizzy

#skip

;NOTE:
;Drones will have to fill up their meter
;at a faster pace!

;Allow players to whack buttons to speed
;up their recovery from getup_time.
;Remember, the wrestler's meter doesn't have to be visible for hime
;to still have a getup time set!
;As long as getup_time has a value, he is stuck.

	move	@PCNT,a14
	btst	0,a14
	jrz	#loop

	move	a13,a0
	calla	wres_get_but_val_down	;whack on buttons to speed up
	move	a0,a0
	jrz	#loop

	move	*a13(GETUP_TIME),a0
	subk	10,a0
	jrp	#ok
	clr	a0
#ok
	move	a0,*a13(GETUP_TIME)
	move	a0,a0
	jrnz	#loop

#clr_dizzy
	clr	a0
	move	a0,*a13(PLYR_DIZZY)
	move	a0,*a13(STARS_FLAG)	;Gets rid of them...

;Delay button reads
	movi	40,a0
	move	a0,*a13(DELAY_BUTNS)

	jruc	#loop

	.if	rounds_on
	.def	reset_for_round
	.def	reset_for_round2
 SUBR	reset_for_round

;Reset world and both wrestlers for the start
;of a new round - Called from lifebar.


	PUSH	a13

	clr	a1
	callr	reset_wrestle

	movk	1,a1
	callr	reset_wrestle

	movk	2,a1
	callr	reset_wrestle

	movk	3,a1
	callr	reset_wrestle

	movk	4,a1
	callr	reset_wrestle

	PULL	a13

	move	@current_round,a0
	inc	a0
	move	a0,@current_round

	.ref	init_rnd_life_data
	calla	init_rnd_life_data

	movi	9,a0
	move	a0,@match_time		;10's
	movi	9,a0
	move	a0,@match_time+10h	;1's
	clr	a0
	move	a0,@match_time+20h	;fractional

;Temp
;	clr	a0
;	move	a0,@p1rounds
;	move	a0,@p2rounds

nobody_home
	rets

reset_wrestle
	callr	get_process_ptr
	move	a0,a13
	jrz	nobody_home

	clr	a0
	move	a0,*a13(PLYR_DIZZY_CNT)

	move	*a13(PLYRNUM),a10

reset_start

	MOVI	#start_xz,a0
	MOVE	@PSTATUS,A2
	CMPI	2,A2
	JRNE	START_TABLE_DEFFED
	MOVI	#start_xz2,a0

START_TABLE_DEFFED
	move	a10,a9
	X64	a9
	ADD	A0,A9
	move	*a9+,a0
	sll	16,a0			;x val
	move	a0,*a13(OBJ_XPOS),L
	move	*a9+,a0
	sll	16,a0			;z val
	move	a0,*a13(OBJ_ZPOS),L

	clr	a0
	move	a0,*a13(OBJ_YPOS),L

	movi	MAT_Y,a0
	move	a0,*a13(GROUND_Y)

;From veladd
	move	*a13(GROUND_Y),a2
	sll	16,a2
	move	*a13(OBJ_YPOS),a0,L
	sub	a2,a0			;- GROUND_Y
	move	*a13(OBJ_YVEL),a1,L
	add	a1,a0
	jrnn	#yok

	clr	a0
	move	a0,*a13(OBJ_YVEL),L
#yok
	add	a2,a0			;+ GROUND_Y
	move	a0,*a13(OBJ_YPOS),L

	move	a10,a0
	X32	a0
	addi	obj_look,a0
	move	*a0,a0,L		;* start of objects
	move	a0,*a13(OBJ_BASE),L
	move	a0,a10
	addi	32*MAX_PIECES,a10	;start at end to reverse priorities

	move	*a9+,a0
;	movk	9,a0
;	move	*a13(PLYRNUM),a14
;	jrz	#lft
;	movk	6,a0
;#lft

	move	a0,*a13(NEW_FACING_DIR)
	move	a0,*a13(FACING_DIR)

	clr	a0			;x pos
	move	a0,*a13(PLYRMODE)
	move	a0,*a13(PLYR_DIZZY)
	move	a0,*a13(ANIMODE)
	move	a0,*a13(ANIMODE2)

;	movi	MAT_Y,a0
;	move	a0,*a13(GROUND_Y)

	clr	a0
;MJT Start
;	move	a0,*a13(BURNOUT_COUNT)
;MJT End
	move	a0,*a13(INRING)

	move	a0,*a13(OBJ_XVEL),L
	move	a0,*a13(OBJ_YVEL),L
	move	a0,*a13(OBJ_ZVEL),L

	calla	clear_damage_log
	callr	ani_init		;start default animation

	move	@PCNT,a14
	move	a14,*a13(FOOT_PCNT),W	;init foot timer

	rets

 SUBR	reset_for_round2

	PUSH	a13

	clr	a1
	callr	reset_wrestle2

	movk	1,a1
	callr	reset_wrestle2

	movk	2,a1
	callr	reset_wrestle2

	movk	3,a1
	callr	reset_wrestle2

	movk	4,a1
	callr	reset_wrestle2

	PULL	a13

	rets

reset_wrestle2
	callr	get_process_ptr
	move	a0,a13
	jrz	nobody_home

	clr	a0
	move	a0,*a13(PLYR_DIZZY_CNT)

	move	*a13(PLYRNUM),a10

reset_start2
	callr	calc_closest

	calla	set_collision_boxes

	callr	confine_wrestler

;	callr	update_newfacing

	callr	update_positions	;used by scroller (temp!)

	callr	update_joystat
	callr	count_button_presses

	callr	wrestler_veladd		;<-------
	callr	wrestler_friction	;<-------

;	calla	animate_wrestler	;<-------
	calla	set_collision_boxes	;<-------

	callr	confine_wrestler	;<--- temp fix!

	callr	calc_closest

	callr	move_wrestler

	callr	update_links

	calla	set_collision_boxes
	calla	overlap_collision

	move	a13,a0
	callr	set_wrestler_xflip

	callr	update_joy_dtime

	rets
	.endif

#wrestler_pal

;These are the normal pals.  If both wrestlers are the same, player 2 will
;use the alternate pal.

	.long	HRTPNK_P	;0	(Bret)
	.long	RZRGRN_P	;1	(Razor)
	.long	UNDPRP_P	;2	(Taker)
	.long	YOKRED_P	;3	(Yoko)
	.long	SHNRED_P	;4	(Shawn)
	.long	BAMBLU_P	;5	(Bam Bam)
	.long	DNKBLU_P	;6	(Doink)
	.long	DNKBLU_P	;7	(spare)
	.long	LEXWHT_P	;8	(Lex)
	.long	0		;9	(Referee)

#wrestler_pal_alt
;These are the alternate pals.

	.long	HRTBLU_P	;0	(Bret)
	.long	RZRPRP_P	;1	(Razor)
	.long	UNDBLK_P	;2	(Taker)
	.long	YOKPRP_P	;3	(Yoko)
	.long	SHNPRP_P	;4	(Shawn)

;Get new BAM BAM alternate pal
	.long	BAMYLW_P	;5	(Bam Bam)

	.long	DNKPRP_P	;6	(Doink)
	.long	DNKPRP_P	;7	(spare)
	.long	LEXYEL_P	;8	(Lex)
	.long	0		;9	(Referee)


#start_xz
	.word	3abh,4ach,9,0		;0 player 1
	.word	457h,494h,6,0		;1 player 2
	.word	457h,494h,6,0		;1 player 2

	.word	1024-150,1103+170,9,0	;3 drone
	.word	1024+150,1103+170,6,0	;4 drone
	.word	1024,1103,0,0		;5
	.word	1024,1103,0,0		;6
	.word	1024,1103,0,0		;7
#start_xz2
	.word	3abh,4ach,9,0		;0 player 1
	.word	457h,494h,6,0		;1 player 2
	.word	3abh,4ach,9,0		;0 player 1

	.word	1024-150,1103+170,9,0	;3 drone
	.word	1024+150,1103+170,6,0	;4 drone
	.word	1024,1103,0,0		;5
	.word	1024,1103,0,0		;6
	.word	1024,1103,0,0		;7

obj_look
	.long	wres0_objs	;0
	.long	wres1_objs	;1
	.long	wres2_objs	;2
	.long	wres3_objs	;3
	.long	wres4_objs	;4
	.long	wres5_objs	;5
	.long	wres6_objs	;6
	.long	wres7_objs	;7


#*****************************************************************************
*
* initializes animations for each wrestler
*
* a13 = * wrestler process

 SUBRP	ani_init


	movi	100h,a0
	move	a0,*a13(ANI_SPEED)	;normal speed animations

;MJT Start
	clr	a0
	move	a0,*a13(I_WILL_DIE)
	move	a0,*a13(WALK_FAST)
;MJT End

	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	#init_addr,a0
	move	*a0,a0,L
	call	a0
	rets

#init_addr
	.long	bret_ani_init	;0 Bret Hart
	.long	razor_ani_init	;1 Razor Ramon
	.long	taker_ani_init	;2 Undertaker
	.long	yoko_ani_init	;3 Yokozuna
	.long	shawn_ani_init	;4 Shawn Michaels
	.long	bam_ani_init	;5 Bam Bam
	.long	doink_ani_init	;6 Doink
	.long	doink_ani_init	;7 spare
	.long	lex_ani_init	;8 Lex Luger
	.long	0		;9 Referee


#*****************************************************************************
* a13 = ptr to process
* a1 = player/drone number 0-?

 SUBRP	set_process_ptr

 	PUSH	a1
	X32	a1
	addi	process_ptrs,a1
	move	a13,*a1,L
	PULL	a1
	rets

#*****************************************************************************
* a1 = player/drone number 0-?
* returns ptr in a0

 SUBR	get_process_ptr

 	PUSH	a1
	X32	a1
	addi	process_ptrs,a1
	move	*a1,a0,L
	PULL	a1
	rets

#*****************************************************************************
*
* a13 = * to wrestler process
*
* breaks links if both wrestlers not attached to each other
*

 SUBRP	update_links

	move	*a13(ATTACH_PROC),a1,L		;proc attached to
	jrz	#exit				;not attached
	move	*a1(ATTACH_PROC),a0,L
	cmp	a0,a13				;pointing to each other?
	jreq	#exit				;ok

	clr	a0
	move	a0,*a13(ATTACH_PROC),L
#exit
	rets


#*****************************************************************************
*

 SUBRP	update_newfacing


	callr	get_opp_process		;closest opponent process
	move	a0,a10

	movi	MOVE_RIGHT,a0
	move	*a13(OBJ_XPOS),a2,L
	move	*a10(OBJ_XPOS),a3,L
	cmp	a2,a3		;a3-a2
	jrgt	#right
	movi	MOVE_LEFT,a0
#right
	movi	MOVE_DOWN,a1
	move	*a13(OBJ_ZPOS),a2,L
	move	*a10(OBJ_ZPOS),a3,L
	cmp	a2,a3		;a3-a2
	jrgt	#down
	movi	MOVE_UP,a1
#down
	or	a1,a0
	move	a0,*a13(NEW_FACING_DIR)

	rets

#*****************************************************************************
*
* sets x-flip based on facing direction
*
* a0 = * wrestler process


 SUBR	set_wrestler_xflip

	move	*a0(FACING_DIR),a14
	btst	PLAYER_RIGHT_BIT,a14
	jrnz	#right

	move	*a0(OBJ_CONTROL),a14
	ori	M_FLIPH,a14
	move	a14,*a0(OBJ_CONTROL)

	rets

#right
	move	*a0(OBJ_CONTROL),a14
	andni	M_FLIPH,a14
	move	a14,*a0(OBJ_CONTROL)

	rets

#*****************************************************************************

MAX_YVEL	equ	-1000000h	;-40000h

 SUBRP	wrestler_veladd

	move	@HALT,a0
	jrnz	#x

	move	*a13(OBJ_XPOS),a0,L
	move	*a13(OBJ_XVEL),a1,L
	add	a1,a0
	move	a0,*a13(OBJ_XPOS),L

	move	*a13(GROUND_Y),a2
	sll	16,a2
	move	*a13(OBJ_YPOS),a0,L
	sub	a2,a0			;- GROUND_Y
	move	*a13(OBJ_YVEL),a1,L
	add	a1,a0
	jrnn	#yok
;RJR START
	;under ground.  clr Yvel unless we're attached and MODE_GHOST
	move	*a13(ATTACH_PROC),a14,L
	jrz	#set_yvel
	move	*a14(ATTACH_PROC),a14,L
	cmp	a13,a14			;valid link?
	jrne	#set_yvel
	move	*a13(ANIMODE),a14,L
	btst	MODE_GHOST_BIT,a14
	jrnz	#yok
	move	a1,a1			;if yvel is positive then keep
	jrn	#set_yvel		;velocity & put at ground level
	clr	a0
	jruc	#yok
;RJR END
	
#set_yvel
	clr	a0
	move	a0,*a13(OBJ_YVEL),L
#yok
	add	a2,a0			;+ GROUND_Y
	move	a0,*a13(OBJ_YPOS),L



	callr	calc_ground_y

	move	*a13(OBJ_YPOS),a0,L

	move	*a13(GROUND_Y),a2
	sll	16,a2
	cmp	a0,a2			;a2-a0
	jrlt	#ok
	;we're under ground...  Unless we're attached and set MODE_GHOST,
	; stay above.
	move	*a13(ATTACH_PROC),a14,L
	jrz	#set_ground_y
	move	*a14(ATTACH_PROC),a14,L
	jrz	#set_ground_y
	move	*a13(ANIMODE),a14,L
	btst	MODE_GHOST_BIT,a14
	jrnz	#ok
	
#set_ground_y
	move	a2,a0
#ok
	move	a0,*a13(OBJ_YPOS),L

	move	*a13(OBJ_ZPOS),a0,L
	move	*a13(OBJ_ZVEL),a1,L
	add	a1,a0
	move	a0,*a13(OBJ_ZPOS),L

	move	*a13(ANIMODE),a0
	btst	MODE_NOGRAVITY_BIT,a0
	jrnz	#no_gravity

	move	*a13(GROUND_Y),a0
	sll	16,a0
	move	*a13(OBJ_YPOS),a1,L
	cmp	a0,a1
	jreq	#no_gravity

	move	*a13(OBJ_YVEL),a0,L
	move	*a13(OBJ_GRAVITY),a14,L
	sub	a14,a0
	cmpi	MAX_YVEL,a0
	jrge	#grav_ok
	movi	MAX_YVEL,a0
#grav_ok
	move	a0,*a13(OBJ_YVEL),L
#no_gravity

#x
	rets


#*****************************************************************************
*
* confines wrestler in/out of ring
* and sets CAN_MOVE_DIR bits
*

 SUBRP	confine_wrestler


	clr	a7			;can move in all directions

	move	*a13(ANIMODE),a0
	btst	MODE_NOCONFINE_BIT,a0
	jrnz	#no_confine

	move	*a13(PLYRMODE),a0
	cmpi	MODE_ATTACHED,a0
	jreq	#no_confine

;	cmpi	MODE_PUPPET,a0
;	jreq	#no_confine


	move	*a13(INRING),a0
	jrnz	#outring


	;We're inside the ring
	;Check against the top ropes.
	movi	RING_TOP,a0
	move	*a13(OBJ_ZPOSINT),a5
	cmp	a0,a5			;zpos - top
	jrgt	#zu_ok
	jreq	#no_u

	;set Z to top of ring
	move	a0,*a13(Z_BOUND)
	sll	16,a0
	move	a0,*a13(OBJ_ZPOS),L

	;climb out if allowed
	calla	ck_climb_out_top

#no_u
	;just inside - don't adjust, but don't go any further.
	ori	MOVE_UP,a7		;can't move up
	jruc	#check_x

#zu_ok
	;Check aginst bottom ropes
	movi	RING_BOT,a0		;zpos - bot
	cmp	a0,a5
	jrlt	#zd_ok
	jreq	#no_d

	;set Z to bottom of ring
	move	a0,*a13(Z_BOUND)
	sll	16,a0
	move	a0,*a13(OBJ_ZPOS),L

	;climb out if allowed
	calla	ck_climb_out_bot

#no_d
	;just inside - don't adjust, but don't go any further.
	ori	MOVE_DOWN,a7		;can't move down
#zd_ok

#check_x
	;Check left edge of collision box against left rope
	move	*a13(OBJ_COLLX1),a5

	;first see if we're even in the ballpark.
	movi	vln_left_rope,a6
	move	*a6,a0			;x1
	cmp	a0,a5			;xpos - x2
	jrgt	#xl_ok

	;close enough for a more careful check...
	callr	calc_line_x
	cmp	a0,a5			;xpos - a0
	jrgt	#xl_ok
	jreq	#no_l


	;we're past the left rope.  see if we're attached
	move	*a13(ATTACH_PROC),a14,L
	jrz	#not

	;I'm attached, which means both me and my opponent are gonna get
	; moved.  Figure the right amount, apply it to both of us, then
	; wobble the ropes and bounce both of us away.

	;a0 is rope X, a5 is left edge of our collbox.  Move us and our
	; opponent right (a0 - a5) pixels.
	sub	a5,a0
	move	*a13(OBJ_XPOSINT),a14
	add	a0,a14
	move	a14,*a13(OBJ_XPOSINT)

	move	*a13(ATTACH_PROC),a5,L
	move	*a5(OBJ_XPOSINT),a14
	add	a0,a14
	move	a14,*a5(OBJ_XPOSINT)

	;If either I or my opponent has a nonzero X velocity other than
	; 40000h, give us both Xvel 40000h, Yvel 30000h.

	;Skip the velocity crap if I'm on the ground.
	move	*a13(GROUND_Y),a0
	move	*a13(OBJ_YPOSINT),a1
	cmp	a0,a1
	jreq	#no_l

	move	*a13(OBJ_XVEL),a14,L
	jrz	#lr_check_opp
	cmpi	[4,0],a14
	jrne	#lr_check_opp
	jruc	#lr_set_vels

#lr_check_opp
	move	*a5(OBJ_XVEL),a14,L
	jrz	#no_l
	cmpi	[4,0],a14
	jrne	#lr_set_vels
	jruc	#no_l

#lr_set_vels
	;X vel
	movi	[4,0],a14
	move	a14,*a13(OBJ_XVEL),L
	move	a14,*a5(OBJ_XVEL),L

	;Y vel
	movi	[3,0],a14
	move	a14,*a13(OBJ_YVEL),L
	move	a14,*a5(OBJ_YVEL),L

	;...and wobble the ropes
	PUSH	a0,a5
	movi	ROPE_LEFT,a0
	movk	1,a2
	movi	ROPE_BOUNCEIO,a1
	calla	rope_command
	PULL	a0,a5

	jruc	#no_l

#not	
	;we're not attached
	;line me up flush against the left rope
	move	*a13(OBJ_XPOSINT),a14
	sub	a5,a14
	add	a14,a0
	move	a0,*a13(X_BOUND)
	sll	16,a0
	move	a0,*a13(OBJ_XPOS),L

	move	*a13(INRING),a0
	jrnz	#no_l				;Am outside.
	;climb out the side if allowed
	calla	ck_climb_out_side

;Has hit left rope
;Wobble ropes and bounce off of them upon first hit.
	move	*a13(MOVE_DIR),a0
	jrnz	#no_l

	move	*a13(OBJ_XVEL),a0,L
	jrz	#no_l

	;Skip the velocity crap if I'm on the ground.
	move	*a13(GROUND_Y),a0
	move	*a13(OBJ_YPOSINT),a1
	cmp	a0,a1
	jreq	#no_l

;We also should check YPOS also.  Ropes shouldn't wobble if
;not hit.

	move	*a13(OBJ_XVEL),a0,L
	movi	[3,0001],a7
	move	a7,*a13(OBJ_XVEL),L
	andi	>ffff,a0
	cmpi	1,a0
	jrz	#no_l

;This is the first time we have collided with ropes.
;Wobble them.

	movi	ROPE_LEFT,a0
	movk	1,a2
	movi	ROPE_BOUNCEIO,a1
	calla	rope_command


#no_l
	ori	MOVE_LEFT,a7		;can't move left
	jruc	#done

#xl_ok
	;Check right edge of collision box against right ropes
	move	*a13(OBJ_COLLX2),a5

	;first see if we're even in the ballpark.
	movi	vln_right_rope,a6
	move	*a6,a0			;x1
	cmp	a0,a5			;xpos - x1
	jrlt	#xr_ok

	;close enough for a more careful check...
	callr	calc_line_x
	cmp	a0,a5			;xpos - a0
	jrlt	#xr_ok
	jreq	#no_r

;Jamie, when someone does a neck grab up against the right ropes,
;the wrestler will glitch through the ropes for 1 tick before he gets
;reset away from the ropes.  I couldn't find a bug....  Try it.


	;we're past the right rope.  see if we're attached
	move	*a13(ATTACH_PROC),a14,L
	jrz	#not2

	;I'm attached, which means both me and my opponent are gonna get
	; moved.  Figure the right amount, apply it to both of us, then
	; wobble the ropes and bounce both of us away.

	;a0 is rope X, a5 is right edge of our collbox.  Move us and our
	; opponent left (a5 - a0) pixels.
	sub	a0,a5
	move	*a13(OBJ_XPOSINT),a14
	sub	a5,a14
	move	a14,*a13(OBJ_XPOSINT)

	move	*a13(ATTACH_PROC),a0,L
	move	*a0(OBJ_XPOSINT),a14
	sub	a5,a14
	move	a14,*a0(OBJ_XPOSINT)

	;If either I or my opponent has a nonzero X velocity other than
	; -40000h, give us both Xvel -40000h, Yvel 30000h.

	;Skip the velocity crap if I'm on the ground.
	move	*a13(GROUND_Y),a0
	move	*a13(OBJ_YPOSINT),a1
	cmp	a0,a1
	jreq	#no_r

	move	*a13(OBJ_XVEL),a14,L
	jrz	#rr_check_opp
	cmpi	[-4,0],a14
	jrne	#rr_check_opp
	jruc	#rr_set_vels

#rr_check_opp
	move	*a13(ATTACH_PROC),a5,L
	move	*a5(OBJ_XVEL),a14,L
	jrz	#no_r
	cmpi	[-4,0],a14
	jrne	#rr_set_vels
	jruc	#no_r

#rr_set_vels
	;X vel
	movi	[-4,0],a14
	move	a14,*a13(OBJ_XVEL),L
	move	*a13(ATTACH_PROC),a5,L
	move	a14,*a5(OBJ_XVEL),L

	;Y vel
	movi	[3,0],a14
	move	a14,*a13(OBJ_YVEL),L
	move	a14,*a5(OBJ_YVEL),L

	;...and wobble the ropes
	PUSH	a0,a5
	movi	ROPE_RIGHT,a0
	movk	1,a2
	movi	ROPE_BOUNCEIO,a1
	calla	rope_command
	PULL	a0,a5

	jruc	#no_r

#not2

	move	*a13(OBJ_XPOSINT),a14
	sub	a14,a5
	sub	a5,a0

	move	a0,*a13(X_BOUND)
	sll	16,a0
	move	a0,*a13(OBJ_XPOS),L

	move	*a13(INRING),a0
	jrnz	#no_r				;Am outside.

	calla	ck_climb_out_side

;Has hit right rope
;Wobble ropes and bounce off of them upon first hit.
	move	*a13(MOVE_DIR),a0
	jrnz	#no_r

	move	*a13(OBJ_XVEL),a0,L
	jrz	#no_r

	;Skip the velocity crap if I'm on the ground.
	move	*a13(GROUND_Y),a0
	move	*a13(OBJ_YPOSINT),a1
	cmp	a0,a1
	jreq	#no_r

;We also should check YPOS also.  Ropes shouldn't wobble if
;not hit.

	move	*a13(OBJ_XVEL),a0,L
	movi	[-3,0001],a7
	move	a7,*a13(OBJ_XVEL),L
	andi	>ffff,a0
	cmpi	1,a0
	jrz	#no_r

;This is the first time we have collided with ropes.
;Wobble them.

	movi	ROPE_RIGHT,a0
	movk	1,a2
	movi	ROPE_BOUNCEIO,a1
	calla	rope_command


#no_r
	ori	MOVE_RIGHT,a7		;can't move right
#xr_ok
#done
#no_confine
	move	a7,*a13(CAN_MOVE_DIR)
	rets



	;We're outside the ring
#outring
	movi	ARENA_TOP,a0
	move	*a13(OBJ_ZPOSINT),a5
	cmp	a0,a5			;zpos - top
	jrgt	#zu_ok2
	jreq	#no_u2

	move	a0,*a13(Z_BOUND)
	sll	16,a0
	move	a0,*a13(OBJ_ZPOS),L
#no_u2
	ori	MOVE_UP,a7		;can't move up
	jruc	#check_x2

#zu_ok2
	movi	ARENA_BOT,a0		;zpos - bot
	cmp	a0,a5
	jrlt	#zd_ok2
	jreq	#no_d2

	move	a0,*a13(Z_BOUND)
	sll	16,a0
	move	a0,*a13(OBJ_ZPOS),L
#no_d2
	ori	MOVE_DOWN,a7		;can't move down
#zd_ok2

#check_x2
	move	*a13(OBJ_COLLX1),a5
	movi	vln_left_fence,a6
	move	*a6,a0			;x1
	cmp	a0,a5			;xpos - x2
	jrgt	#xl_ok2
	callr	calc_line_x
	cmp	a0,a5			;xpos - a0
	jrgt	#xl_ok2
	jreq	#no_l2

	;must move right (a0-a5) pixels.  If we're attached, move our
	; opponent too.
	move	a0,a1
	sub	a5,a0

	move	*a13(OBJ_XPOSINT),a14
	add	a0,a14
	move	a14,*a13(OBJ_XPOSINT)
	move	a1,*a13(X_BOUND)

	move	*a13(ATTACH_PROC),a5,L
	jrz	#no_l2

	move	*a5(OBJ_XPOSINT),a14
	add	a0,a14
	move	a14,*a5(OBJ_XPOSINT)
	move	a1,*a5(X_BOUND)
#no_l2
	ori	MOVE_LEFT,a7		;can't move left
	jruc	#cont_x

#xl_ok2
	move	*a13(OBJ_COLLX2),a5
	movi	vln_right_fence,a6
	move	*a6,a0			;x1
	cmp	a0,a5			;xpos - x1
	jrlt	#xr_ok2
	callr	calc_line_x
	cmp	a0,a5			;xpos - a0
	jrlt	#xr_ok2
	jreq	#no_r2

	;must move left (a5-a0) pixels.  If we're attached, move our
	; opponent too.
	sub	a0,a5

	move	*a13(OBJ_XPOSINT),a14
	sub	a5,a14
	move	a14,*a13(OBJ_XPOSINT)
	move	a0,*a13(X_BOUND)

	move	*a13(ATTACH_PROC),a1,L
	jrz	#no_r2
	move	*a1(OBJ_XPOSINT),a14
	sub	a5,a14
	move	a14,*a1(OBJ_XPOSINT)
	move	a0,*a1(X_BOUND)
#no_r2
	ori	MOVE_RIGHT,a7		;can't move right
#xr_ok2



;now check for the mat/ring

#cont_x
	move	*a13(OBJ_XPOSINT),a5
	cmpi	RING_X_CENTER,a5
	jrgt	#right_side
;left side
	movi	vln_left_matedge2,a6
	callr	calc_line_x
	jrz	#done2			;out of range
	move	*a13(OBJ_COLLX2),a8
	sub	a0,a8			;xpos - a0 =(xov)
	jrn	#done2

	move	*a13(OBJ_ZPOSINT),a4
	cmpi	RING_Z_CENTER,a4
	jrgt	#bot_left
;top left
	move	*a6(10h),a0
;;;	dec	a4
	move	a4,a9
	sub	a0,a9			;zpos - z1 =(zov)
	cmp	a8,a9			;zov - xov
	jrgt	#no_r3

	sub	a9,a4
	move	a4,*a13(Z_BOUND)
	sll	16,a4
	move	a4,*a13(OBJ_ZPOS),L
	ori	MOVE_DOWN,a7		;can't move down

	calla	ck_climb_in_top

	jruc	#done2

#bot_left
	move	*a6(30h),a9
;;;	inc	a4
	sub	a4,a9			;z2 - zpos =(zov)
	cmp	a8,a9			;zov - xov
	jrgt	#no_r3
	add	a9,a4
	move	a4,*a13(Z_BOUND)
	sll	16,a4
	move	a4,*a13(OBJ_ZPOS),L
	ori	MOVE_UP,a7		;can't move up

	calla	ck_climb_in_bot

	jruc	#done2

#no_r3
	sub	a8,a5
	move	a5,*a13(X_BOUND)
	sll	16,a5
	move	a5,*a13(OBJ_XPOS),L
	ori	MOVE_RIGHT,a7		;can't move right

	calla	ck_climb_in_side

	jruc	#done2


#right_side
	movi	vln_right_matedge2,a6
	callr	calc_line_x
	jrz	#done2			;out of range
	move	a0,a8
	move	*a13(OBJ_COLLX1),a0
	sub	a0,a8			;a8 - xpos =(xov)
	jrn	#done2

	move	*a13(OBJ_ZPOSINT),a4
	cmpi	RING_Z_CENTER,a4
	jrgt	#bot_right
;top right
	move	*a6(10h),a0
;;;	dec	a4
	move	a4,a9
	sub	a0,a9			;zpos - z1 =(zov)
	cmp	a8,a9			;zov - xov
	jrgt	#no_l3
	sub	a9,a4
	move	a4,*a13(Z_BOUND)
	sll	16,a4
	move	a4,*a13(OBJ_ZPOS),L
	ori	MOVE_DOWN,a7		;can't move down

	calla	ck_climb_in_top

	jruc	#done2


#bot_right
	move	*a6(30h),a9
;;;	inc	a4
	sub	a4,a9			;z2 - zpos =(zov)
	cmp	a8,a9			;zov - xov
	jrgt	#no_l3
	add	a9,a4
	move	a4,*a13(Z_BOUND)
	sll	16,a4
	move	a4,*a13(OBJ_ZPOS),L
	ori	MOVE_UP,a7		;can't move up

	calla	ck_climb_in_bot

	jruc	#done2


#no_l3
	add	a8,a5
	move	a5,*a13(X_BOUND)
	sll	16,a5
	move	a5,*a13(OBJ_XPOS),L
	ori	MOVE_LEFT,a7		;can't move down

	calla	ck_climb_in_side

#done2
	move	a7,*a13(CAN_MOVE_DIR)
	rets

#*****************************************************************************
*
 SUBRP	wrestler_friction

	move	*a13(ANIMODE),a0
	btst	MODE_FRICTION_BIT,a0
	jrz	#no_friction

	move	*a13(OBJ_FRICTION),a0

	move	*a13(OBJ_XVEL),a1,L
	jrz	#no_friction
	jrn	#add

	sub	a0,a1
	jrp	#ok1
	clr	a1
#ok1
	move	a1,*a13(OBJ_XVEL),L
	rets

#add
	add	a0,a1
	jrn	#ok2
	clr	a1
#ok2
	move	a1,*a13(OBJ_XVEL),L


#no_friction
	rets

#*****************************************************************************
* Change an objects image
* A0=*New image
* A1=New flip flags & const
* A8=*Obj
* Trashes scratch

 SUBR	change_image


	PUSH	a2,a3

	cmpi	ROM,a0
	jrlo	#anierr

	move	a0,a2
	move	a1,a3

	move	a2,*a8(OIMG),L
	move	*a2(0),*a8(OSIZE),L
	move	*a2(ISAG),*a8(OSAG),L


	move	*a2(IANIOFFX),*a8(ODXOFF)	;display x offset
	move	*a2(IANIOFFY),*a8(ODYOFF)	;display y offset


	setf	5,0,0
	move	*a2(ICTRL+7),*a8(OCTRL+7)	;Write 5 z comp bits
	setf	6,0,0
	move	a3,*a8(OCTRL)			;Write 6 low bits
	setf	16,1,0

#x	PULL	a2,a3
	rets

#anierr 
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	2,2
	.endif
	jruc	#x


#*****************************************************************************
*
* calls movement code base on wrestler number
*
* a13 = * wrestler process

 SUBRP	move_wrestler

	move	@HALT,a0
	jrnz	#x

;MJT Start
;	move	*a13(IMMOBILIZE_TIME),a0
;	jrnz	#x
; .if 0
;;Check health
;;Fall back unless in opponent in combo
; 	move	*a13(PLYRMODE),a0
;	cmpi	MODE_DEAD,a0
;	jrz	#ok
;	cmpi	MODE_NORMAL,a0
;	jrnz	#ok
;
;	move	*a13(PLYRNUM),a1
;	calla	get_health
;	jrnz	#ok
;	move	*a13(WHOHITME),a8,L
;	calla	CHECK_COMBO_GO
;	jrlt	#ok
;;Am I in the middle of a combo?
;	move	*a8(COMBO_COUNT),a0
;	jrnz	#ok
;
;;At end of combo, fall down
;
;	SETMODE	DEAD
;
;;FIX!!!
;;Add dizzy sequence here for finish move.
;
;	.ref	fall_back_tbl
;
;	FACETBL fall_back_tbl
;	calla	change_anim1a
;
;	move	*a13(WHOHITME),a4,L
;	movi	[3,0],a2
;	move	*a4(OBJ_XPOSINT),a0
;	move	*a13(OBJ_XPOSINT),a1
;	cmp	a0,a1			;offx - defx
;	jrgt	#fall_right		;attacker on left
;	movi	[-3,0],a2
;#fall_right
;	move	a2,*a13(OBJ_XVEL),L
;	movi	[5,0],a2
;	move	a2,*a13(OBJ_YVEL),L
;
;	rets
;#ok
; .endif

;MJT End



	;check to see if a special move watchdog proc has queued up an anim.
	; If one has, do that instead of calling move_xxx.
	move	*a13(SPECIAL_MOVE_ADDR),a0,L
	jrz	#no_special

	;a special has been queued up.  do it.
	calla	change_anim1a
	clr	a14
	move	a14,*a13(SPECIAL_MOVE_ADDR),L
	jruc	#x

#no_special

	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	#code_addr,a0
	move	*a0,a0,L
	call	a0
#x
	rets


#code_addr
	.long	move_bret	;0 Bret Hart
	.long	move_razor	;1 Razor Ramon
	.long	move_taker	;2 Undertaker
	.long	move_yoko	;3 Yokozuna
	.long	move_shawn	;4 Shawn Michaels
	.long	move_bam	;5 Bam Bam
	.long	move_doink	;6 Doink
	.long	move_doink	;7 spare
	.long	move_lex	;8 Lex Luger
	.long	0		;9 Referee


#*****************************************************************************

 SUBR	tint_on

	PUSH	a0,a1
	movi	07fffh,a0	;all bits on (5 bits RGB (white))
	movi	COLRAM,a1	;base address of colour ram
	move	a0,*a1		;restore colour
	PULL	a0,a1
	rets

#*****************************************************************************

 SUBR	tint_off

	PUSH	a0,a1
	clr	a0		;all bits off (black)
	movi	8<<10+8<<5+8,a0	;grey
	movi	COLRAM,a1	;base address of colour ram
	move	a0,*a1		;restore colour
	PULL	a0,a1
	rets

#*****************************************************************************

 SUBRP	realtime_clock

	clr	a8
	move	a8,@match_realtime

#loop	SLEEP	TSEC
	inc	a8
	move	a8,@match_realtime
	jruc	#loop

#*****************************************************************************

 SUBRP	match_timer

	movi	9,a0
	move	a0,@match_time		;10's
	move	a0,@match_time+10h	;1's
	clr	a0
	move	a0,@match_time+20h	;fractional

	callr	#create_timer

	SLEEP	TSEC*2

	movi	ADJSPEED,a0		;game timer speed (1-5)
	calla	GET_ADJ
	sll	4,a0			;x 16 bits
	addi	timer_table-10h,a0
	move	*a0,a10

#loop
	SLEEPK	1
	
	move	@HALT,a0
	jrnz	#loop

	movi	NUM_WRES,a1
next_1
	callr	are_we_dead
	jrc	#loop
	dec	a1
	jrnn	next_1

	callr	#dec_timer
	callr	update_timer

	jruc	#loop

are_we_dead
	callr	get_process_ptr
	move	a0,a0
	jrz	no_we_arent
	move	*a0(PLYRMODE),a0
	cmpi	MODE_DEAD,a0
	jrne	no_we_arent
	setc
	rets
no_we_arent
	clrc
	rets


********************

#create_timer

	movi	[186,0],a0			;x pos
	movi	[21,0],a1			;y pos
	movi	WGSF20_9,a2
	movi	200,a3			;z pos
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ
	move	a8,*a13(PDATA+20h),L		;10's image pointer

	movi	[200+2,0],a0			;x pos
	movi	[21,0],a1			;y pos
	movi	WGSF20_9,a2
	calla	BEGINOBJ
	move	a8,*a13(PDATA),L		;1's image pointer

	rets

********************

#dec_timer
	move	@match_time,a0,L
	cmpi	090009h,a0
	jrne	#no_reset_pal
	movi	WGFS_W_P,a0
	calla	pal_getf
	move	*a13(PDATA+20h),a8,L	;10's image pointer
	move	a0,*a8(OPAL)
	move	*a13(PDATA),a8,L	;10's image pointer
	move	a0,*a8(OPAL)

#no_reset_pal

	move	@match_time+20h,a0	;fractional
	sub	a10,a0

	move	a0,@match_time+20h
	jrnc	#no_change

	move	@match_time+10h,a0	;1's
	dec	a0
	move	a0,@match_time+10h
	jrnc	#no_borrow

	movi	9,a0
	move	a0,@match_time+10h

	move	@match_time,a0		;10's
	dec	a0
	move	a0,@match_time

	cmpi	0,a0

	jrne	#no_borrow
	movi	WGSF_R_P,a0
	calla	pal_getf
	move	*a13(PDATA+20h),a8,L	;10's image pointer
	move	a0,*a8(OPAL)
	move	*a13(PDATA),a8,L	;10's image pointer
	move	a0,*a8(OPAL)

#no_borrow
	;if time is less than 15, make noise
	move	@match_time,a0,L
	move	a0,a1
	sra	16,a0
	andi	0Fh,a1
	sla	4,a1
	or	a1,a0
	cmpi	10h,a0
	jrgt	#no_change
	movi	10,a0			;Time warning sound
	calla	triple_sound

#no_change
	rets

timer_table
	.asg	1500,BASETM

	.word	BASETM-BASETM*30/100	;1 (slowest)	;Approx 2.5 minutes
	.word	BASETM-BASETM*15/100	;2 (slower)
	.word	BASETM			;3 (default)	;Approx 2 minutes
	.word	BASETM+BASETM*15/100	;4 (faster)
	.word	BASETM+BASETM*30/100	;5 (fastest)	;Approx 1.5 minutes


********************

update_timer

	move	@match_time,a0		;10's
	.if DEBUG
	cmpi	10,a0
	jrlt	#ok1

	;clock digit out of range!
	LOCKUP
#ok1
	.endif

	X32	a0
	addi	digit_tbl,a0
	move	*a0,a0,L		;* image
	move	*a13(PDATA+20h),a8,L	;10's image pointer
	move	*a8(OCTRL),a1		;DMA flags
	calla	change_image

	move	@match_time+10h,a0	;1's
	.if DEBUG
	cmpi	10,a0
	jrlt	#ok2

	;clock digit out of range!
	LOCKUP
	.endif
#ok2

	X32	a0
	addi	digit_tbl,a0
	move	*a0,a0,L		;* image
	move	*a13(PDATA),a8,L	;1's image pointer
	move	*a8(OCTRL),a1		;DMA flags
	calla	change_image

	rets


******************************************************************************

						;!KEEP THIS ORDER!
	.bss	up_dtime1,	16*NUM_WRES	;number of ticks stick held down
	.bss	down_dtime1,	16*NUM_WRES
	.bss	left_dtime1,	16*NUM_WRES
	.bss	right_dtime1,	16*NUM_WRES
	.bss	punch_dtime1,	16*NUM_WRES
	.bss	block_dtime1,	16*NUM_WRES	;number of ticks button held down
	.bss	powerp_dtime1,	16*NUM_WRES
	.bss	kick_dtime1,	16*NUM_WRES
	.bss	powerk_dtime1,	16*NUM_WRES


******************************************************************************

;;Plyr 1
;	.bss	up_dtime1,	16	;number of ticks stick held down
;;Plyr 2
;	.bss	up_dtime2,	16	;!!!! KEEP THIS ORDER!
;	.bss	down_dtime1,	16
;	.bss	down_dtime2,	16
;	.bss	left_dtime1,	16
;	.bss	left_dtime2,	16
;	.bss	right_dtime1,	16
;	.bss	right_dtime2,	16
;
;	.bss	punch_dtime1,	16
;	.bss	punch_dtime2,	16
;	.bss	block_dtime1,	16	;number of ticks button held down
;	.bss	block_dtime2,	16	;!!!! KEEP THIS ORDER!
;	.bss	powerp_dtime1,	16
;	.bss	powerp_dtime2,	16
;	.bss	kick_dtime1,	16
;	.bss	kick_dtime2,	16
;	.bss	powerk_dtime1,	16
;	.bss	powerk_dtime2,	16


#*****************************************************************************



 SUBRP	init_joy_dtime

	clr	a0

	movi	up_dtime1,a1
	movi	9*NUM_WRES,a2
#lp1
	move	a0,*a1+
	dsj	a2,#lp1

	rets

#*****************************************************************************

 SUBR	get_block_dtime

	X16	a0
	addi	block_dtime1,a0
	move	*a0,a0
	rets

#*****************************************************************************

 SUBR	get_powerp_dtime

	X16	a0
	addi	powerp_dtime1,a0
	move	*a0,a0
	rets

#*****************************************************************************

 SUBR	get_punch_dtime

	X16	a0
	addi	punch_dtime1,a0
	move	*a0,a0
	rets

#*****************************************************************************

 SUBR	get_kick_dtime

	X16	a0
	addi	kick_dtime1,a0
	move	*a0,a0
	rets

#*****************************************************************************

 SUBR	get_powerk_dtime

	X16	a0
	addi	powerk_dtime1,a0
	move	*a0,a0
	rets


#*****************************************************************************


 SUBRP	update_joy_dtime

	move	*a13(PLYRNUM),a2
	callr	#update_but
	move	*a13(PLYRNUM),a2
	callr	#update_stick

	rets

#update_stick
	move	a13,a0
	callr	wres_get_stick_val_cur
	X16	a2
	addi	up_dtime1,a2

	movi	4,a3
#loop1
	clr	a1

	srl	1,a0
	jrnc	#clr1

	move	*a2,a1
	inc	a1
#clr1
	move	a1,*a2

	addi	16*NUM_WRES,a2
	dsj	a3,#loop1

	rets

#update_but
	move	a13,a0
	callr	wres_get_but_val_cur
	X16	a2
	addi	punch_dtime1,a2

	movi	5,a3
#loop2
	clr	a1

	srl	1,a0
	jrnc	#clr2

	move	*a2,a1
	inc	a1
#clr2
	move	a1,*a2

	addi	16*NUM_WRES,a2
	dsj	a3,#loop2

	rets

#*****************************************************************************
* a13 = * current process
* calculates closest opponent and distances to him


; first calculate the distance on the X-Z plane
;  dxz = sqroot ( (x1-x2)^2 + (z1-z2)^2 )
; total dist = sqroot ( DXZ^2 + (y1-y2)^2 )


;RJR START
 SUBRP	calc_closest2

	move	*a13(PLYRNUM),a0
	andi	3,a0
	move	@PCNT,a1
	andi	3,a1
	cmp	a0,a1
	jrnz	#x

;RJR END

 SUBRP	calc_closest

	move	*a13(PLYR_TYPE),a0
;	cmpi	PTYPE_REFEREE,a0
;	jreq	#ref_calc_closest

	move	*a13(OBJ_XPOSINT),a4
	move	*a13(OBJ_ZPOSINT),a5
	move	*a13(OBJ_YPOSINT),a6

	movi	8000h,a3		;closest distance
	movi	process_ptrs,a2
	movi	NUM_WRES,a1
#loop
	move	*a2+,a10,L
	jrz	#inactive
	cmp	a13,a10
	jreq	#skip			;skip self

	move	*a13(PLYR_SIDE),a7
	move	*a10(PLYR_SIDE),a8
	cmp	a7,a8
	jreq	#skip			;skip friendly

	PUSH	a1

	move	*a10(OBJ_XPOSINT),a7
	move	*a10(OBJ_ZPOSINT),a8
	move	*a10(OBJ_YPOSINT),a9

	sub	a4,a7			;abs(delta x)
	abs	a7
	move	a7,a1
	mpyu	a1,a1			;^2
	move	a1,a0

	sub	a5,a8			;abs(delta z)
	abs	a8
	move	a8,a1
	mpyu	a1,a1			;^2
	add	a1,a0

	sub	a6,a9			;abs(delta y)
	abs	a9
	move	a9,a1
	mpyu	a1,a1			;^2
	add	a1,a0
	calla	square_root		;sqroot of dxz^2 + dy^2

	PULL	a1

	cmp	a3,a0			;a0-a3
	jrgt	#not_closest

	move	a0,a3
	move	a3,*a13(CLOSEST_DIST)
	move	a7,*a13(CLOSEST_XDIST)
	move	a8,*a13(CLOSEST_ZDIST)
	move	a9,*a13(CLOSEST_YDIST)

	movi	NUM_WRES,a0
	sub	a1,a0
	move	a0,*a13(CLOSEST_NUM)

#inactive
#skip
#not_closest
	dsj	a1,#loop

;RJR START
#x
;RJR END
	rets

#*****************************************************************************
*
* if attached, updates position based on player attached to
* wrestler proc = *a13
* 
* RETURNS:	Z=1	-	not attached to anything
*		Z=0	-	attached and updated
*
* TRASHES:	a0,a1,a2

 SUBR	master_keep_attached


	move	*a13(ATTACH_PROC),a10,L		;proc attached to me
	jrz	#not_attached
	move	*a10(ATTACH_PROC),a0,L
	jrz	#not_attached

#still_attached
	;first, see if opponent is on the ground.
	move	*a10(OBJ_YPOS),a0,L
	move	*a10(GROUND_Y),a14
	sll	16,a14
	cmp	a14,a0
	jrgt	#opp_notgnd

	;opponent is on ground.  first, make sure he's not in MODE_GHOST
	move	*a10(ANIMODE),a14
	btst	MODE_GHOST_BIT,a14
	jrnz	#opp_notgnd

	;calc new 'floor'
	move	*a10(OBJ_YPOS),a0,L
	move	*a13(ATTACH_YOFF),a14
	sll	16,a14
	sub	a14,a0

	;a0 is our new floor.  stay at or above
	move	*a13(OBJ_YPOS),a14,L
	cmp	a14,a0
	jrle	#above_newfloor

	;too low.  climb
	move	a0,*a13(OBJ_YPOS),L

#above_newfloor
#opp_notgnd
	
	clr	a0
	move	a0,*a10(OBJ_YVEL),L

	move	*a13(OBJ_ZPOS),a0,L
	move	*a13(ATTACH_ZOFF),a1
	sll	16,a1
	add	a1,a0
	move	a0,*a10(OBJ_ZPOS),L

	move	*a13(OBJ_YPOS),a0,L
	move	*a13(ATTACH_YOFF),a1
	sll	16,a1
	add	a1,a0
	move	a0,*a10(OBJ_YPOS),L

	move	*a13(OBJ_XPOS),a0,L
	move	*a13(ATTACH_XOFF),a1
	sll	16,a1

	move	*a13(FACING_DIR),a2
	btst	MOVE_RIGHT_BIT,a2
	jrnz	#add
	neg	a1
#add
	add	a1,a0
	move	a0,*a10(OBJ_XPOS),L

	movk	1,a0			;Z=0

#not_attached
	rets


#*****************************************************************************
*
* if attached, updates position based on player attached to
* wrestler proc = *a13
* 
* RETURNS:	Z=1	-	not attached to anything
*		Z=0	-	attached and updated
*
* TRASHES:	a0,a1,a2


 SUBR	keep_attached


	move	*a13(ATTACH_PROC),a2,L		;proc attached to
	jrz	#not_attached
	move	*a2(ATTACH_PROC),a0,L
	jrz	#not_attached

#still_attached
	clr	a0
	move	a0,*a13(OBJ_YVEL),L

	move	*a2(OBJ_ZPOS),a0,L
	move	*a2(ATTACH_ZOFF),a1
	sll	16,a1
	add	a1,a0
	move	a0,*a13(OBJ_ZPOS),L

	move	*a2(OBJ_YPOS),a0,L
	move	*a2(ATTACH_YOFF),a1
	sll	16,a1
	add	a1,a0
	move	a0,*a13(OBJ_YPOS),L


	move	*a2(OBJ_XPOS),a0,L
	move	*a2(ATTACH_XOFF),a1
	sll	16,a1

	move	*a2(FACING_DIR),a2
	btst	MOVE_RIGHT_BIT,a2
	jrnz	#add
	neg	a1
#add
	add	a1,a0
	move	a0,*a13(OBJ_XPOS),L

	movk	1,a0			;Z=0

#not_attached
	rets


#*****************************************************************************
*
* RETURNS:	a0 = * closest opponent process
*
* TRASHES:	a0

 SUBR	get_opp_process

	move	*a13(CLOSEST_NUM),a0
	X32	a0
	addi	process_ptrs,a0
	move	*a0,a0,L

	rets

#*****************************************************************************
*
* RETURNS:	a0 = PLYRMODE of the closest opponent
*
* TRASHES:	a0

 SUBR	get_opp_plyrmode

	move	*a13(CLOSEST_NUM),a0
	X32	a0
	addi	process_ptrs,a0
	move	*a0,a0,L
	move	*a0(PLYRMODE),a0

	rets

#*****************************************************************************
*
* ARGS:		a0 = facing value (in binary form - 0,1,2,4,8)
*
* RETURNS:	a0 = facing value (in linear form - 0,1,2,3 - 8)
*

 SUBR	convert_facing

	X16	a0
	addi	#convert_table,a0
	move	*a0,a0
	rets

#convert_table
	.word	0	;0 zip
	.word	0	;1 up
	.word	4	;2 down
	.word	0	;3 zip
	.word	6	;4 left
	.word	7	;5 up_left
	.word	5	;6 down_left
	.word	0	;7 zip
	.word	2	;8 right
	.word	1	;9 up_right
	.word	3	;10 down_right
	.word	0	;11 zip
	.word	0	;12 zip
	.word	0	;13 zip
	.word	0	;14 zip
	.word	0	;15 zip

digit_tbl
	.long	WGSF20_0,WGSF20_1,WGSF20_2,WGSF20_3,WGSF20_4
	.long	WGSF20_5,WGSF20_6,WGSF20_7,WGSF20_8,WGSF20_9

#*****************************************************************************
*

 SUBRP	postgame_audits

	;battle over accounting.

	;increment AUD_VSHUMF or AUD_VSCPUF (and AUD_CPUWIN)
	movi	AUD_VSHUMF,a0
	move	@PSTATUS,a14
	cmpi	03h,a14
	jreq	#vshum
	movi	AUD_VSCPUF,a0
#vshum
	calla	AUD1

	;add to AUD_2PBTIME, AUD_CPUWINTIME, or AUD_CPULOSETIME
	move	@PSTATUS,a14
	cmpi	03h,a14
	jreq	#2pbtime

	move	@match_winner,a0
	and	a0,a14
	jrnz	#cpulosetime
	jruc	#cpuwintime

#2pbtime
	movi	AUD_2PBTIME,a0
	jruc	#addtime

#cpuwintime
	movi	AUD_CPUWIN,a0
	calla	AUD1
	movi	AUD_CPUWINTIME,a0
	jruc	#addtime
#cpulosetime
	movi	AUD_CPULOSETIME,a0
	jruc	#addtime

#addtime
	move	@match_realtime,a1
	calla	AUD

	;update record speeds
	move	@PSTATUS,a14
	cmpi	03h,a14
	jreq	#fast_2p

	move	@match_winner,a0
	and	a0,a14
	jrnz	#fast_cpulose
	jruc	#fast_cpuwin

#fast_2p
	movi	AUD_FASTHDH,a0
	calla	GET_AUD
	jrz	#no_prior_hdh
	move	@match_realtime,a2
	cmp	a1,a2
	jrge	#recordspeed_done
#no_prior_hdh
	movi	AUD_FASTHDH,a0
	move	@match_realtime,a1
	calla	STORE_AUDIT
	jruc	#recordspeed_done

#fast_cpulose
	movi	AUD_FASTHDC,a0
	calla	GET_AUD
	jrz	#no_prior_hdc
	move	@match_realtime,a2
	cmp	a1,a2
	jrge	#recordspeed_done
#no_prior_hdc
	movi	AUD_FASTHDC,a0
	move	@match_realtime,a1
	calla	STORE_AUDIT
	jruc	#recordspeed_done

#fast_cpuwin
	movi	AUD_FASTCDH,a0
	calla	GET_AUD
	jrz	#no_prior_cdh
	move	@match_realtime,a2
	cmp	a1,a2
	jrge	#recordspeed_done
#no_prior_cdh
	movi	AUD_FASTCDH,a0
	move	@match_realtime,a1
	calla	STORE_AUDIT

#recordspeed_done

	;increment the proper wrestler use thingies

	MOVE	@PSTATUS,A0
	CMPI	3,A0
	JREQ	NORMAL_PLAYER_AUDITS
	move	@index1,a2
	CLR	A1
	SRL	1,A0
	JRC	AUDIT_THE_HUMAN
	move	@index2,a2
	MOVK	1,A1

AUDIT_THE_HUMAN
	CALLR	AUDIT_SPECIFIC_WRESTLE

	MOVE	@NUM_OPPS,A3
	MOVK	2,A1
	MOVE	@CURRENT_LADDER,A10,L
	MOVE	*A10,A4,L

AUDIT_NEXT_COMP
	MOVE	A4,A2
	SLL	24,A2
	SRL	24,A2
	X64	a2			;x 4 words
	addi	wrestler_audits,a2
	addi	20h,a2			;skip 2 words
	move	*a2+,a0,W		;increment uses
	calla	AUD1
	move	@match_winner,a0
	CMPI	2,A0
	JRNZ	CPU_NOT_WIN
	move	*a2+,a0,W		;increment uses
	calla	AUD1
CPU_NOT_WIN
	SRL	8,A4
	DSJS	A3,AUDIT_NEXT_COMP

	RETS

NORMAL_PLAYER_AUDITS
	;player 1
	move	@index1,a2
	CLR	A1
	CALLR	AUDIT_SPECIFIC_WRESTLE

	;player 2
	move	@index2,a2
	MOVK	1,A1
	CALLR	AUDIT_SPECIFIC_WRESTLE

	RETS

AUDIT_SPECIFIC_WRESTLE
	X64	a2			;x 4 words
	addi	wrestler_audits,a2

	move	@PSTATUS,a0
	btst	A1,a0
	jrnz	#p1hum
	addi	20h,a2			;skip 2 words
#p1hum
	move	*a2+,a0,W		;increment uses
	calla	AUD1

	move	@match_winner,a0
	btst	A1,a0
	jrz	#p1_audited
	move	*a2+,a0,W		;increment wins
	calla	AUD1

#p1_audited
	RETS

#*****************************************************************************
*
* a0 = * wrestler process
*

 SUBR	wres_get_but_val_down

	move	*a0(PLYR_TYPE),a14
	jrnz	#drndt
	move	*a0(PLYRNUM),a0
	calla	get_but_val_down
	rets

#drndt
	move	*a0(DRN_BUTDT),a0
	rets

#*****************************************************************************

 SUBR	wres_get_but_val_cur

	move	*a0(PLYR_TYPE),a14
	jrnz	#drndt
	move	*a0(PLYRNUM),a0
	calla	get_but_val_cur
	rets

#drndt
	move	*a0(DRN_BUT),a0
	rets

#*****************************************************************************

 SUBR	wres_get_but_val_up

	move	*a0(PLYR_TYPE),a14
	jrnz	#drnut
	move	*a0(PLYRNUM),a0
	calla	get_but_val_up
	rets

#drnut
	move	*a0(DRN_BUTUT),a0
	rets

#*****************************************************************************

 SUBR	wres_get_stick_val_cur

	move	*a0(PLYR_TYPE),a14
	jrnz	drn_joy
	move	*a0(PLYRNUM),a0
	calla	get_stick_val_cur
	rets

drn_joy
	move	*a0(DRN_JOY),a0
	rets


#*****************************************************************************

  SUBR	wres_get_stick_rel_cur


	move	*a0(PLYR_TYPE),a14
	jrnz	drn_joy
	move	*a0(OBJ_CONTROL),a14
	move	*a0(PLYRNUM),a0
	calla	get_stick_val_cur
	btst	B_FLIPH,a14
	jrz	#done

	X16	a0
	addi	#xflip_table,a0
	move	*a0,a0
#done
	rets



;returns a value only if stick val
;has changed (but not zero)

  SUBR	wres_get_stick_rel_new


	move	*a0(PLYR_TYPE),a14
	jrnz	#not_human2

;shawn - this needs patching too...

	push	a10

	move	a0,a10
	move	*a10(PLYRNUM),a0
	calla	get_stick_val_up
	push	a0

	move	*a10(PLYRNUM),a0
	calla	get_stick_val_down
	pull	a1
	or	a1,a0
	jrz	#done2		;no stick

	move	*a10(OBJ_CONTROL),a14
	move	*a10(PLYRNUM),a0
	calla	get_stick_val_cur
	btst	B_FLIPH,a14
	jrz	#done2

	X16	a0
	addi	#xflip_table,a0
	move	*a0,a0
#done2
	pull	a10
	rets


#not_human2
	move	a0,a14
	move	*a14(DRN_JOYDT),a0
	move	*a14(DRN_JOYUT),a1
	or	a1,a0
	jrz	#dx
	move	*a14(DRN_JOY),a0
#dx
	rets


#xflip_table	;convert to forward / away  if facing left
	.word	0000b	;0
	.word	0001b	;1
	.word	0010b	;2
	.word	0011b	;3
	.word	1000b	;4
	.word	1001b	;5
	.word	1010b	;6
	.word	1011b	;7
	.word	0100b	;8
	.word	0101b	;9
	.word	0110b	;10
	.word	0111b	;11
	.word	1100b	;12
	.word	1101b	;13
	.word	1110b	;14
	.word	1111b	;15

#*****************************************************************************

 SUBR	wres_get_stick_val_down

	move	*a0(PLYR_TYPE),a14
	jrnz	#drnjoy
	move	*a0(PLYRNUM),a0
	calla	get_stick_val_down
	rets

#drnjoy
	move	*a0(DRN_JOYDT),a0
	rets

#*****************************************************************************

 SUBR	wres_get_stick_val_up

	move	*a0(PLYR_TYPE),a14
	jrnz	#not_human
	move	*a0(PLYRNUM),a0
	calla	get_stick_val_up
	rets

#not_human
	clr	a0
	rets

#*****************************************************************************

 SUBRP	init_joystat

	clr	a0

	move	a0,@round_tickcount

	movi	wrest_joystat,a1
	movi	16*NUM_WRES,a2
#clr_loop
	move	a0,*a1+,L
	dsj	a2,#clr_loop

	rets

#*****************************************************************************

 SUBRP	update_joystat

;	move	*a13(PLYR_TYPE),a0
;	jrnz	#exit			;skip non-human players

	move	@HALT,a0
	jrnz	#exit

	move	a13,a0
	callr	wres_get_stick_val_cur
	move	a0,a8
	andi	01100b,a8		;mask out left & right
	sll	10-2,a8			;shift to bit 10 & 11

	move	*a13(FACING_DIR),a14
	btst	MOVE_LEFT_BIT,a14
	jrz	#no_flip
	X16	a0
	addi	#xflip_table,a0
	move	*a0,a0			;flipped based on facing
#no_flip
	or	a0,a8			;real L/R | flipped joy dirs


	move	a13,a0
	callr	wres_get_stick_val_up
	PUSH	a0
	move	a13,a0
	callr	wres_get_stick_val_down
	PULL	a1
	or	a1,a0
	jrz	#no_stick

	move	a8,a4			;cur (flipped) stick vals
	jrz	#no_stick

	callr	#insert

#no_stick

	move	a13,a0
	callr	wres_get_but_val_down
	move	a0,a6
	jrz	#no_button
	X16	a6

	movi	5,a5			;5 button bits
	movi	010000b,a7		;1st bit << 4 (to skip 4 joy bits)
#bit_loop
	move	a6,a0
	and	a7,a0			;button down?
	jrz	#skip
	move	a0,a4
	or	a8,a4			;+ cur (flipped) stick vals
	callr	#insert			;only 1 button per entry
#skip
	sll	1,a7
	dsj	a5,#bit_loop

#no_button

#exit
	rets

#insert
	move	@round_tickcount,a0
	sll	16,a0
	or	a0,a4

	move	*a13(PLYRNUM),a3
	sll	5+4,a3				;PLYRNUM x32 x16

	move	a3,a0				;start offset
	addi	wrest_joystat + 32*15,a0	;2nd last entry (after pre-dec)
	move	a3,a1
	addi	wrest_joystat + 32*16,a1	;last entry (after pre-dec)

	movi	15,a2				;# entries - 1
#move_loop
	move	-*a0,-*a1,L			;move each entry down
	dsj	a2,#move_loop			;1 position

	move	a3,a0
	addi	wrest_joystat,a0
	move	a4,*a0,L			;time stamp : joy & buttons
	rets


#xflip_table	;convert to forward / away  if facing left
	.word	0		;0
	.word	J_UP		;1
	.word	J_DOWN		;2
	.word	0		;3
	.word	J_TOWARD	;4
	.word	J_UP_TOWARD	;5
	.word	J_DOWN_TOWARD	;6
	.word	0		;7
	.word	J_AWAY		;8
	.word	J_UP_AWAY	;9
	.word	J_DOWN_AWAY	;10
	.word	0,0,0,0,0	;11-15


#*****************************************************************************

 SUBR	clear_button_presses

	movk	5,a1		;5 buttons
	move	a13,a2
	addi	PUNCHB_COUNT,a2
	clr	a0
#loop
	move	a0,*a2+
	dsj	a1,#loop

	rets

#*****************************************************************************

 SUBR	count_button_presses

	move	a13,a0
	callr	wres_get_but_val_down
	move	a0,a0
	jrz	#exit

	movk	5,a1		;5 bits
	move	a13,a2
	addi	PUNCHB_COUNT,a2
#loop
	srl	1,a0		;button-->Carry
	jrnc	#no_but

	move	*a2,a14
	inc	a14
	move	a14,*a2

#no_but
	addi	16,a2
	dsj	a1,#loop

#exit
	rets

;	WORD	PUNCHB_COUNT	;0 <------
;	WORD	BLOCKB_COUNT	;1 keep	  |
;	WORD	SPUNCHB_COUN	;2 ordered|
;	WORD	KICK_COUNT  	;3	  |
;	WORD	SKICK_COUNT	;4 <------

#*****************************************************************************

 SUBR	direction_test

 .if 0
 	;can put this in a mode
	.ref	direction_test

	move	*a13(PLYRNUM),a8
	move	*a13(CLOSEST_NUM),a9

	CREATE0	direction_test		;temp!!!!!!!!!!!

	movi	424000h,a0
	move	a0,*a13(OBJ_YVEL),L

	SETMODE	INAIR
	rets
 .endif


;a8 = PLYRNUM
;a9 = CLOSEST_NUM

	move	a8,*a13(PLYRNUM)
	move	a9,*a13(CLOSEST_NUM)

	X32	a8
	addi	process_ptrs,a8
	move	*a8,a10,L

	X32	a9
	addi	process_ptrs,a9
	move	*a9,a11,L

	move	*a10(OBJ_XPOS),*a13(OBJ_XPOS),L
	move	*a10(OBJ_YPOS),*a13(OBJ_YPOS),L
	move	*a10(OBJ_ZPOS),*a13(OBJ_ZPOS),L



	move	*a10(OBJ_XPOS),a0,L
	move	*a11(OBJ_XPOS),a1,L
	sub	a0,a1
	movi	TSEC,a0
	divs	a0,a1			;a1 / a0
	move	a1,*a13(OBJ_XVEL),L


	move	*a10(OBJ_ZPOS),a0,L
	move	*a11(OBJ_ZPOS),a1,L
	sub	a0,a1
	movi	TSEC,a0
	divs	a0,a1			;a1 / a0
	move	a1,*a13(OBJ_ZVEL),L



	clr	a0
	move	a0,*a13(OBJ_YVEL),L

;	move	a0,*a13(OBJ_XVEL),L
;	move	a0,*a13(OBJ_ZVEL),L






	clr	a0			;x pos
	clr	a1			;y pos
	movi	D2ST2B03,a2		;* image
	movi	20,a3			;z pos
	movi	DMAWNZ|M_3D,a4		;DMA flags
	move	a4,*a13(OBJ_CONTROL)
	clr	a5			;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ

	movi	TSEC,a0
#loop
	PUSHP	a0

;velocity add
	move	*a13(OBJ_XPOS),a0,L
	move	*a13(OBJ_XVEL),a1,L
	add	a1,a0
	move	a0,*a13(OBJ_XPOS),L

	move	*a13(OBJ_YPOS),a0,L
	move	*a13(OBJ_YVEL),a1,L
	add	a1,a0
	jrnn	#yok
	clr	a0
#yok
	move	a0,*a13(OBJ_YPOS),L

	move	*a13(OBJ_ZPOS),a0,L
	move	*a13(OBJ_ZVEL),a1,L
	add	a1,a0
	move	a0,*a13(OBJ_ZPOS),L





;image plot
	move	*a13(OBJ_XPOS),a5,L	;x val

	movi	Y_SCALE_MULTIPLIER,a0
	move	*a13(OBJ_ZPOSINT),a1
	mpys	a0,a1
	move	a1,a6			;y val

	move	*a13(OBJ_CONTROL),a7	;flip bits & pixel ops

	move	a6,*a8(OYVAL),L		;keep updating YVAL to keep priorities

	move	a5,*a8(OXVAL),L
	move	a6,*a8(OYVAL),L

	movi	[20,0],a1			;z pos
	move	a1,*a8(OZVAL),L

	setf	6,0,0
	move	a7,*a8(OCTRL)			;Write 6 low bits
	setf	16,1,0


	SLEEPK	1

	PULLP	a0
	dsj	a0,#loop

	calla	DELOBJA8

	DIE

#*****************************************************************************
*
* a11 = * secret move table
* a13 = * wrestler process

 SUBR	check_secret_moves

;Jamie - drone code secret moves are not allowed here!
;	move	*a13(PLYR_TYPE),a14
;	jrnz	#done			;not human

	move	*a13(PLYRMODE),a14
	cmpi	MODE_DIZZY,a14
	jreq	#done

;No secret moves if getup time is set - out of control runs, etc.
	move	*a13(GETUP_TIME),a14
	jrnz	#done

	move	*a11+,a0,L		;button hold test code
	call	a0
	jrc	#done

	move	*a13(PLYRNUM),a10
	sll	5+4,a10			;PLYRNUM x32 x16
	addi	wrest_joystat,a10

	;only check if newest entry in queue is fresh
	move	*a10(10h),a0		;time stamp
	move	@round_tickcount,a1
	cmp	a0,a1
	jrne	#done


#next_table
;RJR START
	.align
;RJR END
	move	*a11+,a2,L
	jrz	#done
	move	a10,a9

	movk	8,a3			;only skip 8 masked entries

	;the first entry in the queue requires a special check...
	move	*a2,a0			;value
	move	*a2(10h),a1		;mask
	move	*a9,a14,L
	andi	0ffffh,a14		;queue head
	andn	a1,a14			;apply mask

	;if the mask leaves nothing behind, then there's noise since the
	; final (trigger) move, so blow it off.
	jrz	#next_table

#loop
	move	*a2+,a0
	jrn	#match
	move	*a2+,a1			;mask
#skip

	;check for end of table (16 entries)

	move	*a9+,a7,L
	move	a7,a8
	srl	16,a7			;round tick count
	andi	0ffffh,a8		;joy+buttons
	andn	a1,a8
	dsjeq	a3,#skip

	cmp	a0,a8
	jreq	#loop

#failed
	jruc	#next_table

#done
	rets

#match
	andi	07fffh,a0		;clear out sign bit
	move	@round_tickcount,a1
	andi	0ffffh,a1		;clear out sign extend
	sub	a7,a1
	cmp	a0,a1			;below count?
	jrgt	#failed

	move	*a2,a0,L		;code to execute
	jump	a0

#*****************************************************************************
*
* sets animations for legs & torso based on facing & move direction
*

 SUBR	change_walk_anim

;Fix walking speeds!
	clr	a0
	move	a0,*A13(RISK)

;MJT Start
	move	*a13(WALK_FAST),a0
	jrnz	#fast
;MJT End

	callr	get_opp_process
	move	*a0(PLYRMODE),a0	;don't slow down if backing
	cmpi	MODE_ONGROUND,a0	;away from a downed opponent
	jrnz	#notgrnd
;MJT Start
#fast
;MJT End
	movi	0cdh,a0			;fast legs
	jruc	#go_spd

#notgrnd
	movi	100h,a0			;normal speed

#go_spd
	move	a0,*a13(ANI_SPEED)
	move	*a13(ANIMODE2),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#no_interrupt

	move	*a13(FACING_DIR),a0
	callr	convert_facing		;(0-7)
	srl	1,a0			;only uses diagonals (0-3)
	X4	a0
	move	a0,a1

	move	*a13(NEW_FACING_DIR),a0
	callr	convert_facing		;(0-7)
	srl	1,a0			;only uses diagonals (0-3)
	add	a1,a0
	X32	a0

	move	*a13(WRESTLERNUM),a14
	X32	a14
	addi	#wres_torso_anims,a14
	move	*a14,a14,L		;* torso anim table
	add	a14,a0

	move	*a0,a0,L
	calla	change_anim2		;torso

#no_interrupt

	move	*a13(MOVE_DIR),a0
	callr	convert_facing		;(0-7)
	X8	a0
	move	a0,a1

	move	*a13(FACING_DIR),a0
	callr	convert_facing		;(0-7)
	add	a1,a0
	X32	a0

	move	*a13(WRESTLERNUM),a14
	X32	a14
	addi	#wres_leg_anims,a14
	move	*a14,a14,L		;* leg anim table
	add	a14,a0

	move	*a0,a0,L		;* new animation
	calla	change_anim1		;legs

	rets


	.ref	bam_torso_anims_table,bam_leg_anims_table
	.ref	dnk_torso_anims_table,dnk_leg_anims_table
	.ref	hrt_torso_anims_table,hrt_leg_anims_table
	.ref	lex_torso_anims_table,lex_leg_anims_table
	.ref	rzr_torso_anims_table,rzr_leg_anims_table
	.ref	shn_torso_anims_table,shn_leg_anims_table
	.ref	und_torso_anims_table,und_leg_anims_table
	.ref	yok_torso_anims_table,yok_leg_anims_table

#wres_torso_anims
	.long	hrt_torso_anims_table	;0 Bret Hart
	.long	rzr_torso_anims_table	;1 Razor Ramon
	.long	und_torso_anims_table	;2 Undertaker
	.long	yok_torso_anims_table	;3 Yokozuna
	.long	shn_torso_anims_table	;4 Shawn Michaels
	.long	bam_torso_anims_table	;5 Bam Bam
	.long	dnk_torso_anims_table	;6 Doink
	.long	dnk_torso_anims_table	;7 spare
	.long	lex_torso_anims_table	;8 Lex Luger
	.long	0			;9 Referee

#wres_leg_anims
	.long	hrt_leg_anims_table	;0 Bret Hart
	.long	rzr_leg_anims_table	;1 Razor Ramon
	.long	und_leg_anims_table	;2 Undertaker
	.long	yok_leg_anims_table	;3 Yokozuna
	.long	shn_leg_anims_table	;4 Shawn Michaels
	.long	bam_leg_anims_table	;5 Bam Bam
	.long	dnk_leg_anims_table	;6 Doink
	.long	dnk_leg_anims_table	;7 spare
	.long	lex_leg_anims_table	;8 Lex Luger
	.long	0			;9 Referee


#*****************************************************************************
*
* returns: A0 = rotation anim based on NEW_FACING_DIR & FACING_DIR
*
* goes into stance anim if already facing if NEW_FACING = FACING

 SUBR	set_rotate_anim

	move	*a13(FACING_DIR),a0
	calla	convert_facing			;(0-7)
	srl	1,a0				;only uses diagonals (0-3)
	X4	a0
	move	a0,a1

	move	*a13(NEW_FACING_DIR),a0
	calla	convert_facing			;(0-7)
	srl	1,a0				;only uses diagonals (0-3)
	add	a1,a0
	X32	a0

	move	*a13(WRESTLERNUM),a14
	X32	a14
	addi	#wres_rotate_anims,a14
	move	*a14,a14,L			;* rotate anim table
	add	a14,a0

	move	*a13(NEW_FACING_DIR),a14
	move	a14,*a13(FACING_DIR)

	move	*a0,a0,L
;;;	calla	change_anim1

	rets


	.ref	bam_rotate_anims_table
	.ref	dnk_rotate_anims_table
	.ref	hrt_rotate_anims_table
	.ref	lex_rotate_anims_table
	.ref	rzr_rotate_anims_table
	.ref	shn_rotate_anims_table
	.ref	und_rotate_anims_table
	.ref	yok_rotate_anims_table

#wres_rotate_anims
	.long	hrt_rotate_anims_table	;0 Bret Hart
	.long	rzr_rotate_anims_table	;1 Razor Ramon
	.long	und_rotate_anims_table	;2 Undertaker
	.long	yok_rotate_anims_table	;3 Yokozuna
	.long	shn_rotate_anims_table	;4 Shawn Michaels
	.long	bam_rotate_anims_table	;5 Bam Bam
	.long	dnk_rotate_anims_table	;6 Doink
	.long	dnk_rotate_anims_table	;7 spare
	.long	lex_rotate_anims_table	;8 Lex Luger
	.long	0			;9 Referee


#*****************************************************************************

 SUBR	bounce_off_ropes

;Skiles, running into opponent up against the ropes still causes the
;ropes to bend.  There also is a glitch when you are up against a rope and
;then try to run into it.

	move	*a13(INRING),a0
	jrnz	#outside

	move	*a13(WRESTLERNUM),a14
	X16	a14
	addi	#bounce_xoffsets,a14
	move	*a14,a14


	move	*a13(MOVE_DIR),a0
	btst	PLAYER_RIGHT_BIT,a0
	jrnz	#right
;#left
	movi	vln_left_rope,a6
	callr	calc_line_x
	sub	a14,a0
	move	*a13(OBJ_COLLX1),a1
	cmp	a0,a1			;a0-a1
	jrle	#bounce
	rets

#right
	movi	vln_right_rope,a6
	callr	calc_line_x
	add	a14,a0
	move	*a13(OBJ_COLLX2),a1
	cmp	a0,a1			;a0-a1
	jrle	#no_bounce

#bounce
;;;	move	a0,*a13(OBJ_XPOSINT)


	MOVE	*A13(GETUP_TIME),A0
	JRNZ	ALREADY_DONE_RISK_MESS

	move	*a13(RISK),A0
	JRNZ	ALREADY_DONE_RISK_MESS

;Time to execute high-risk move!
	MOVI	40,A0
	MOVE	A0,*A13(RISK)

ALREADY_DONE_RISK_MESS

	move	*a13(WRESTLERNUM),a14
	X32	a14
	addi	#bounce_anims,a14
	move	*a14,a0,L			;* bounce anim
	calla	change_anim1a
	SETMODE	BOUNCING

#no_bounce
#outside
	rets


	.ref	bam_bounce_anim
	.ref	dnk_bounce_anim
	.ref	hrt_bounce_anim
	.ref	lex_bounce_anim
	.ref	rzr_bounce_anim
	.ref	shn_bounce_anim
	.ref	und_bounce_anim
	.ref	yok_bounce_anim

#bounce_xoffsets
	.word	-20	;0 Bret Hart
	.word	-20	;1 Razor Ramon
	.word	-20	;2 Undertaker
	.word	-20	;3 Yokozuna
	.word	0	;4 Shawn Michaels
	.word	-30	;5 Bam Bam
	.word	-20	;6 Doink
	.word	-20	;7 spare
	.word	-20	;8 Lex Luger
	.word	0	;9 Referee

#bounce_anims
	.long	hrt_bounce_anim	;0 Bret Hart
	.long	rzr_bounce_anim	;1 Razor Ramon
	.long	und_bounce_anim	;2 Undertaker
	.long	yok_bounce_anim	;3 Yokozuna
	.long	shn_bounce_anim	;4 Shawn Michaels
	.long	bam_bounce_anim	;5 Bam Bam
	.long	dnk_bounce_anim	;6 Doink
	.long	dnk_bounce_anim	;7 spare
	.long	lex_bounce_anim	;8 Lex Luger
	.long	dnk_bounce_anim	;9 Referee

#*****************************************************************************

 SUBRP	calc_ground_y

	
	move	*a13(INRING),a0
	jrz	#inring


	movi	117,a1
	move	*a13(OBJ_ZPOSINT),a0
	cmpi	05bdh,a0
	jrgt	#setit


	movi	103,a1
	jruc	#setit


#inring
	movi	112,a1

#setit
	move	a1,*a13(OBJ_PRIORITY)

	movi	vln_right_matedge,a6
	callr	calc_line_x
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;a1-a0
	jrge	#outside

	movi	vln_left_matedge,a6
	callr	calc_line_x
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;a1-a0
	jrle	#outside

	movi	MAT_Y,a0
	move	a0,*a13(GROUND_Y)

	clr	a0
	move	a0,*a13(INRING)
	rets

#outside
	clr	a0
	move	a0,*a13(GROUND_Y)
	MOVE	@GAMSTATE,A0
	CMPI	INPREGAME,A0
	JREQ	#skip

	movk	1,a0
	move	a0,*a13(INRING)
#skip
	rets


#*****************************************************************************

 SUBR	execute_walk

;MJT Start
;FIX!!!
;Is this wise?
	clr	a0
	move	a0,*a13(ATTACK_TYPE)
;MJT End

	move	*a13(MOVE_DIR),a0
	X32	a0
	PUSH	A0
	addi	#walk_table,a0
	move	*a0,a0,L
	call	a0
	PULL	A0
	JRZ	NO_SOUND_CALL
	MOVE	@PCNT,A0
	ANDI	31,A0
	JRNZ	NO_SOUND_CALL
	CALLA	WALK_SOUND
NO_SOUND_CALL
	rets

#walk_table
	.long	#zip		;0
	.long	#up		;1
	.long	#down		;2
	.long	#zip		;3
	.long	#left		;4
	.long	#up_left	;5
	.long	#down_left	;6
	.long	#zip		;7
	.long	#right		;8
	.long	#up_right	;9
	.long	#down_right	;10
	.long	#zip		;11
	.long	#zip		;12
	.long	#zip		;13
	.long	#zip		;14
	.long	#zip		;15


************
#zip		;(#0)
#do_stance

	clr	a0
	move	a0,*a13(MOVE_DIR)
	move	a0,*a13(OBJ_XVEL),L
	move	a0,*a13(OBJ_ZVEL),L

	callr	set_rotate_anim		;or stance
	calla	change_anim1
	rets

************
#up		;(#1)

	movi	MOVE_UP,a0
	move	a0,*a13(MOVE_DIR)

	callr	set_velocities
	calla	change_walk_anim

	rets


************
#up_right	;(#2)

	move	*a13(OBJ_CONTROL),a0
	andni	M_FLIPH,a0
	move	a0,*a13(OBJ_CONTROL)

;	move	*a13(CAN_MOVE_DIR),a0
;	btst	MOVE_RIGHT_BIT,a0
;	jrnz	#up
;	btst	MOVE_UP_BIT,a0
;	jrnz	#right

	movi	MOVE_UP_RIGHT,a0
	move	a0,*a13(MOVE_DIR)

	callr	set_velocities
	calla	change_walk_anim
	rets


************
#right		;(#3)

	move	*a13(OBJ_CONTROL),a0
	andni	M_FLIPH,a0
	move	a0,*a13(OBJ_CONTROL)

	movi	MOVE_RIGHT,a0
	move	a0,*a13(MOVE_DIR)

	callr	set_velocities
	calla	change_walk_anim
	rets


************
#down_right	;(#4)

	move	*a13(OBJ_CONTROL),a0
	andni	M_FLIPH,a0
	move	a0,*a13(OBJ_CONTROL)

	move	*a13(CAN_MOVE_DIR),a0
	btst	MOVE_DOWN_BIT,a0
	jrnz	#right

	movi	MOVE_DOWN_RIGHT,a0
	move	a0,*a13(MOVE_DIR)

	callr	set_velocities
	calla	change_walk_anim
	rets


************
#down		;(#5)

	movi	MOVE_DOWN,a0
	move	a0,*a13(MOVE_DIR)

	callr	set_velocities
	calla	change_walk_anim
	rets


************
#down_left	;(#6)

	move	*a13(OBJ_CONTROL),a0
	ori	M_FLIPH,a0
	move	a0,*a13(OBJ_CONTROL)

	move	*a13(CAN_MOVE_DIR),a0
	btst	MOVE_DOWN_BIT,a0
	jrnz	#left

	movi	MOVE_DOWN_LEFT,a0
	move	a0,*a13(MOVE_DIR)

	callr	set_velocities
	calla	change_walk_anim
	rets


************
#left		;(#7)

	move	*a13(OBJ_CONTROL),a0
	ori	M_FLIPH,a0
	move	a0,*a13(OBJ_CONTROL)

	movi	MOVE_LEFT,a0
	move	a0,*a13(MOVE_DIR)

	callr	set_velocities
	calla	change_walk_anim
	rets


************
#up_left	;(#8)

	move	*a13(OBJ_CONTROL),a0
	ori	M_FLIPH,a0
	move	a0,*a13(OBJ_CONTROL)

;	move	*a13(CAN_MOVE_DIR),a0
;	btst	MOVE_LEFT_BIT,a0
;	jrnz	#up
;	btst	MOVE_UP_BIT,a0
;	jrnz	#left

	movi	MOVE_UP_LEFT,a0
	move	a0,*a13(MOVE_DIR)

	callr	set_velocities
	calla	change_walk_anim
	rets

#*****************************************************************************
*
* sets X & Z velocites based on MOVE_DIR
*

;MULT	equ	256*75/100		;25% reduction when moving backward


;MULT	equ	256*100/100		;0% reduction when moving backward
MULT	equ	256*90/100		;10% reduction when moving backward
GRND_MULT	equ	256*150/100	;50% addition when opponent is on ground


 SUBRP	set_velocities


	move	*a13(MOVE_DIR),a0
	callr	convert_facing
	X64	a0

	move	*a13(WRESTLERNUM),a2
	X32	a2
	addi	#wres_velocity_tables,a2

	move	*a2,a2,L		;* velocity table
	add	a0,a2
	move	*a2+,a1,L

;MJT Start
	move	*a13(WALK_FAST),a0
	jrnz	#ongrnd
;MJT End

	callr	get_opp_process
	move	*a0(PLYRMODE),a0	;don't slow down if backing
	cmpi	MODE_ONGROUND,a0	;away from a downed opponent
	jreq	#ongrnd

	cmpi	MODE_DEAD,a0		;away from a dead opponent
	jreq	#ongrnd

	move	*a13(MOVE_DIR),a3
	move	*a13(FACING_DIR),a4

	move	a3,a14
	or	a4,a14
	andi	MOVE_LEFT|MOVE_RIGHT,a14
	cmpi	MOVE_LEFT|MOVE_RIGHT,a14	;move opposite to facing?
	jrne	#not_back_x

	movi	MULT,a0
	mpys	a0,a1
	sra	8,a1
	jruc	#not_back_x
#ongrnd
	movi	GRND_MULT,a0
	mpys	a0,a1
	sra	8,a1

#not_back_x
	move	a1,*a13(OBJ_XVEL),L


	move	*a2,a1,L
	move	a3,a14			;move_dir
	or	a4,a14			;facing dir
	andi	MOVE_UP|MOVE_DOWN,a14
	cmpi	MOVE_UP|MOVE_DOWN,a14	;move opposite to facing?
	jrne	#not_back_y

	movi	MULT,a0
	mpys	a0,a1
	sra	8,a1

#not_back_y
	move	a1,*a13(OBJ_ZVEL),L

	rets


	.ref	bam_velocity_table
	.ref	dnk_velocity_table
	.ref	hrt_velocity_table
	.ref	lex_velocity_table
	.ref	rzr_velocity_table
	.ref	shn_velocity_table
	.ref	und_velocity_table
	.ref	yok_velocity_table

#wres_velocity_tables
	.long	hrt_velocity_table	;0 Bret Hart
	.long	rzr_velocity_table	;1 Razor Ramon
	.long	und_velocity_table	;2 Undertaker
	.long	yok_velocity_table	;3 Yokozuna
	.long	shn_velocity_table	;4 Shawn Michaels
	.long	bam_velocity_table	;5 Bam Bam
	.long	dnk_velocity_table	;6 Doink
	.long	dnk_velocity_table	;7 spare
	.long	lex_velocity_table	;8 Lex Luger
	.long	0			;9 referee


#*****************************************************************************
* (called by animation system)
*

 SUBR	start_run_flung

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_OFFSET,20,0,0
	WL	ANI_CODE,#ok2
	.word	ANI_GETUP,200			;Flung time
	.word	ANI_END

 SUBR	start_run_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	WL	ANI_CODE,#setup_run
	.word	ANI_END

#setup_run
	move	a13,a0
	calla	wres_get_stick_val_cur
	andi	MOVE_LEFT+MOVE_RIGHT,a0
	jrnz	#use_joy1

	move	*a13(FACING_DIR),a0	;use facing
	andi	MOVE_LEFT+MOVE_RIGHT,a0
#use_joy1
	move	*a13(FACING_DIR),a1
	andi	MOVE_LEFT+MOVE_RIGHT,a1
	cmp	a0,a1
	jrz	#ok1

;He wants to run in the opposite direction than he is facing
;Rotate him around first.

	move	*a13(FACING_DIR),a1
	andi	MOVE_UP+MOVE_DOWN,a1
	or	a1,a0
	move	a0,*a13(NEW_FACING_DIR)

	callr	set_rotate_anim
	move	a13,a2				;a2 = * process
	calla	change_anim_anim

#ok1
	movi	#dorun,a0			;this routine gets executed
	jruc	#contx
#ok2
;Whenever you fling someone, a meter can & will appear
	clr	a0
	move	a0,*a13(DELAY_METER)
	movi	#dorun_flung,a0			;this routine gets executed
#contx
	move	a0,*a13(CODE_ADDR),L		;when the rotate anim
	SETMODE	WAITANIM			;finishes

	move	*a13(OBJ_XVEL),a0,L
	sra	1,a0
	move	a0,*a13(OBJ_XVEL),L
	clr	a0
	move	a0,*a13(OBJ_ZVEL),L

	rets


******************************************************************************
* (called by code)
* set move direction based on joystick or facing direction
* and go into run sequence & mode

 SUBR	start_run

	move	a13,a0
	calla	wres_get_stick_val_cur
	andi	MOVE_LEFT+MOVE_RIGHT,a0
	jrnz	#use_joy

	move	*a13(FACING_DIR),a0	;use facing
	andi	MOVE_LEFT+MOVE_RIGHT,a0
#use_joy
	move	*a13(FACING_DIR),a1
	andi	MOVE_LEFT+MOVE_RIGHT,a1
	cmp	a0,a1
	jrz	#ok

;He wants to run in the opposite direction than he is facing
;Rotate him around first.

	move	*a13(FACING_DIR),a1
	andi	MOVE_UP+MOVE_DOWN,a1
	or	a1,a0
	move	a0,*a13(NEW_FACING_DIR)

	callr	set_rotate_anim
	calla	change_anim1

	movi	#dorun,a0			;this routine gets executed
	move	a0,*a13(CODE_ADDR),L		;when the rotate anim
	SETMODE	WAITANIM			;finishes

	move	*a13(OBJ_XVEL),a0,L
	sra	1,a0
	move	a0,*a13(OBJ_XVEL),L
	clr	a0
	move	a0,*a13(OBJ_ZVEL),L

	rets

#dorun
	clr	a0
	move	a0,*a13(GETUP_TIME)	;in control

#dorun_flung
	clr	a0
	move	a0,*a13(USR_VAR1)	;with x-xel
	move	a0,*a13(RUN_TIME)


;Bogosity..
	move	*a13(FACING_DIR),a0	;use facing
;	move	*a13(NEW_FACING_DIR),a0	;use facing
	andi	MOVE_LEFT+MOVE_RIGHT,a0
#ok

;	movk	8,a1
;	cmpi	4,a0
;	jrz	#ok0
;	movk	4,a1
;#ok0
;	move	a1,*a13(MOVE_DIR)

	move	a0,*a13(MOVE_DIR)




	move	*a13(NEW_FACING_DIR),a1
	andi	MOVE_UP+MOVE_DOWN,a1
	or	a0,a1			;LEFT or RIGHT
	move	a1,*a13(FACING_DIR)	;face same dir as run

	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	#run_anims,a0
	move	*a0,a0,L		;run anim
	calla	change_anim1a

	SETMODE	RUNNING


	rets

	.ref	bam_run_anim
	.ref	dnk_run_anim
	.ref	hrt_run_anim
	.ref	lex_run_anim
	.ref	rzr_run_anim
	.ref	shn_run_anim
	.ref	und_run_anim
	.ref	yok_run_anim

#run_anims
	.long	hrt_run_anim	;0 Bret Hart
	.long	rzr_run_anim	;1 Razor Ramon
	.long	und_run_anim	;2 Undertaker
	.long	yok_run_anim	;3 Yokozuna
	.long	shn_run_anim	;4 Shawn Michaels
	.long	bam_run_anim	;5 Bam Bam
	.long	dnk_run_anim	;6 Doink
	.long	dnk_run_anim	;7 spare
	.long	lex_run_anim	;8 Lex Luger
	.long	dnk_run_anim	;9 Referee

;MJT Start
;
;#*****************************************************************************
;*
;* a10 = * wrestler process
;
;#MAX_BURNOUT	equ	180h
;
; SUBR	inc_burnout
;
;	rets
;
; .if 0
;	move	*a10(ATTACK_MODE),a0	;type of attack
;	X32	a0
;	addi	#attack_table,a0
;	move	*a0,a0,L
;	move	*a10(WRESTLERNUM),a1
;	X16	a1
;	add	a1,a0
;	move	*a0,a0			;burnout value
;
;	move	*a10(BURNOUT_COUNT),a1	;put this in a table
;	add	a0,a1
;	cmpi	#MAX_BURNOUT,a1
;	jrlt	#ok
;	movi	#MAX_BURNOUT,a1
;#ok
;	move	a1,*a10(BURNOUT_COUNT)
;
;	rets
;
;
;
;#attack_table
;	.long	_punch		;0
;	.long	_hdbutt		;1
;	.long	_kick		;2
;	.long	_flykick	;3
;	.long	_grabthrow	;4
;	.long	_uprcut		;5
;	.long	_lbowdrop	;6
;	.long	_grabhold	;7
;	.long	_grabfling	;8
;	.long	_push		;9
;	.long	_hiptoss	;10
;	.long	_bigboot	;11
;	.long	_knee		;12
;	.long	_13		;13
;	.long	_14		;14
;	.long	_15		;15
;	.long	_16		;16
;
;
;_punch		;0
;	.word	0	;0 Bret Hart
;	.word	0	;1 Razor Ramon
;	.word	0	;2 Undertaker
;	.word	0	;3 Yokozuna
;	.word	0	;4 Shawn Michaels
;	.word	0	;5 Bam Bam
;	.word	40	;6 Doink
;	.word	0	;7 spare
;	.word	0	;8 Lex Luger
;	.word	0	;9 Referee
;
;_hdbutt		;1
;	.word	0	;0 Bret Hart
;	.word	0	;1 Razor Ramon
;	.word	0	;2 Undertaker
;	.word	0	;3 Yokozuna
;	.word	0	;4 Shawn Michaels
;	.word	0	;5 Bam Bam
;	.word	40	;6 Doink
;	.word	0	;7 spare
;	.word	0	;8 Lex Luger
;	.word	0	;9 Referee
;
;_kick		;2
;	.word	0	;0 Bret Hart
;	.word	0	;1 Razor Ramon
;	.word	0	;2 Undertaker
;	.word	0	;3 Yokozuna
;	.word	0	;4 Shawn Michaels
;	.word	0	;5 Bam Bam
;	.word	0	;6 Doink
;	.word	0	;7 spare
;	.word	0	;8 Lex Luger
;	.word	0	;9 Referee
;
;_flykick	;3
;	.word	0	;0 Bret Hart
;	.word	0	;1 Razor Ramon
;	.word	0	;2 Undertaker
;	.word	0	;3 Yokozuna
;	.word	0	;4 Shawn Michaels
;	.word	0	;5 Bam Bam
;	.word	0	;6 Doink
;	.word	0	;7 spare
;	.word	0	;8 Lex Luger
;	.word	0	;9 Referee
;
;_grabthrow	;4
;	.word	0	;0 Bret Hart
;	.word	0	;1 Razor Ramon
;	.word	0	;2 Undertaker
;	.word	0	;3 Yokozuna
;	.word	0	;4 Shawn Michaels
;	.word	0	;5 Bam Bam
;	.word	0	;6 Doink
;	.word	0	;7 spare
;	.word	0	;8 Lex Luger
;	.word	0	;9 Referee
;
;_uprcut		;5
;	.word	0	;0 Bret Hart
;	.word	0	;1 Razor Ramon
;	.word	0	;2 Undertaker
;	.word	0	;3 Yokozuna
;	.word	0	;4 Shawn Michaels
;	.word	0	;5 Bam Bam
;	.word	0	;6 Doink
;	.word	0	;7 spare
;	.word	0	;8 Lex Luger
;	.word	0	;9 Referee
;
;_lbowdrop	;6
;	.word	0	;0 Bret Hart
;	.word	0	;1 Razor Ramon
;	.word	0	;2 Undertaker
;	.word	0	;3 Yokozuna
;	.word	0	;4 Shawn Michaels
;	.word	0	;5 Bam Bam
;	.word	0	;6 Doink
;	.word	0	;7 spare
;	.word	0	;8 Lex Luger
;	.word	0	;9 Referee
;
;_grabhold	;7
;	.word	0	;0 Bret Hart
;	.word	0	;1 Razor Ramon
;	.word	0	;2 Undertaker
;	.word	0	;3 Yokozuna
;	.word	0	;4 Shawn Michaels
;	.word	0	;5 Bam Bam
;	.word	0	;6 Doink
;	.word	0	;7 spare
;	.word	0	;8 Lex Luger
;	.word	0	;9 Referee
;
;_grabfling	;8
;	.word	0	;0 Bret Hart
;	.word	0	;1 Razor Ramon
;	.word	0	;2 Undertaker
;	.word	0	;3 Yokozuna
;	.word	0	;4 Shawn Michaels
;	.word	0	;5 Bam Bam
;	.word	0	;6 Doink
;	.word	0	;7 spare
;	.word	0	;8 Lex Luger
;	.word	0	;9 Referee
;
;_push		;9
;	.word	0	;0 Bret Hart
;	.word	0	;1 Razor Ramon
;	.word	0	;2 Undertaker
;	.word	0	;3 Yokozuna
;	.word	0	;4 Shawn Michaels
;	.word	0	;5 Bam Bam
;	.word	0	;6 Doink
;	.word	0	;7 spare
;	.word	0	;8 Lex Luger
;	.word	0	;9 Referee
;
;_hiptoss	;10
;	.word	0	;0 Bret Hart
;	.word	0	;1 Razor Ramon
;	.word	0	;2 Undertaker
;	.word	0	;3 Yokozuna
;	.word	0	;4 Shawn Michaels
;	.word	0	;5 Bam Bam
;	.word	0	;6 Doink
;	.word	0	;7 spare
;	.word	0	;8 Lex Luger
;	.word	0	;9 Referee
;
;_bigboot	;11
;	.word	0	;0 Bret Hart
;	.word	0	;1 Razor Ramon
;	.word	0	;2 Undertaker
;	.word	0	;3 Yokozuna
;	.word	0	;4 Shawn Michaels
;	.word	0	;5 Bam Bam
;	.word	0	;6 Doink
;	.word	0	;7 spare
;	.word	0	;8 Lex Luger
;	.word	0	;9 Referee
;
;_knee		;12
;	.word	0	;0 Bret Hart
;	.word	0	;1 Razor Ramon
;	.word	0	;2 Undertaker
;	.word	0	;3 Yokozuna
;	.word	0	;4 Shawn Michaels
;	.word	0	;5 Bam Bam
;	.word	0	;6 Doink
;	.word	0	;7 spare
;	.word	0	;8 Lex Luger
;	.word	0	;9 Referee
;
;_13		;13
;_14		;14
;_15		;15
;_16		;16
;	.word	0	;0 Bret Hart
;	.word	0	;1 Razor Ramon
;	.word	0	;2 Undertaker
;	.word	0	;3 Yokozuna
;	.word	0	;4 Shawn Michaels
;	.word	0	;5 Bam Bam
;	.word	0	;6 Doink
;	.word	0	;7 spare
;	.word	0	;8 Lex Luger
;	.word	0	;9 Referee
;
; .endif

;MJT End

#*****************************************************************************
*
* RETURNS:	a0 = boundary
*
 SUBRP	check_move_up

	move	*a13(INRING),a0
	jrnz	#outring

	movi	RING_TOP,a0
	move	*a13(OBJ_ZPOSINT),a1
	cmp	a0,a1
	jrle	#fail
	clrc
	rets

#outring
	movi	ARENA_TOP,a0
	move	*a13(OBJ_ZPOSINT),a1
	cmp	a0,a1
	jrle	#fail

	movi	box_matedge2,a10
	callr	get_box_overlap
	move	a1,a1			;z overlap
	jrp	#fail2

	clrc
	rets

#fail2
	move	*a13(OBJ_ZPOSINT),a0
	dec	a1
	add	a1,a0

#fail
	setc
	rets

#*****************************************************************************
*
* RETURNS:	a0 = boundary
*
 SUBRP	check_move_down

	move	*a13(INRING),a0
	jrnz	#outring

	movi	RING_BOT,a0
	move	*a13(OBJ_ZPOSINT),a1
	cmp	a0,a1
	jrge	#fail
	clrc
	rets

#outring
	movi	ARENA_BOT,a0
	move	*a13(OBJ_ZPOSINT),a1
	cmp	a0,a1
	jrge	#fail

	movi	box_matedge2,a10
	callr	get_box_overlap
	move	a1,a1			;z overlap
	jrn	#fail2

	clrc
	rets

#fail2
	move	*a13(OBJ_ZPOSINT),a0
	inc	a1
	add	a1,a0
#fail
	setc
	rets

#*****************************************************************************
*
* RETURNS:	a0 = boundary
*
 SUBRP	check_move_left

	move	*a13(INRING),a0
	jrnz	#outring

	move	*a13(OBJ_XPOSINT),a5
	movi	vln_left_rope,a6
	move	*a6,a0			;x1
	cmp	a0,a5			;xpos - x1
	jrge	#ok
	callr	calc_line_x
	cmp	a0,a5			;xpos - a0
	jrle	#fail
#ok
	clrc
	rets

#outring
	move	*a13(OBJ_XPOSINT),a5
	movi	vln_left_fence,a6
	move	*a6,a0			;x1
	cmp	a0,a5			;xpos - x1
	jrge	#ok2
	callr	calc_line_x
	jrz	#outrange
	cmp	a0,a5			;xpos - a0
	jrle	#fail
#outrange
#ok2
	movi	box_matedge2,a10
	callr	get_box_overlap
	move	a0,a0			;x overlap
	jrp	#fail2

	clrc
	rets

#fail2
	move	*a13(OBJ_XPOSINT),a1
	dec	a0
	add	a1,a0
#fail
	setc
	rets

#*****************************************************************************
*
* RETURNS:	a0 = boundary
*
 SUBRP	check_move_right

	move	*a13(INRING),a0
	jrnz	#outring

	move	*a13(OBJ_XPOSINT),a5
	movi	vln_right_rope,a6
	move	*a6,a0			;x1
	cmp	a0,a5			;xpos - x1
	jrle	#ok
	callr	calc_line_x
	cmp	a0,a5			;xpos - a0
	jrge	#fail
#ok
	clrc
	rets

#outring
	move	*a13(OBJ_XPOSINT),a5
	movi	vln_right_fence,a6
	move	*a6,a0			;x1
	cmp	a0,a5			;xpos - x1
	jrle	#ok2
	callr	calc_line_x
	jrz	#outrange
	cmp	a0,a5			;xpos - a0
	jrge	#fail
#ok2
#outrange
	movi	box_matedge2,a10
	callr	get_box_overlap
	move	a0,a0			;x overlap
	jrn	#fail2

	clrc
	rets

#fail2
	move	*a13(OBJ_XPOSINT),a1
	inc	a0
	add	a1,a0
#fail
	setc
	rets

#*****************************************************************************
*
* ARGS:		a10 = * box
*
* RETURNS:	a0 = signed x offset	(left overlap < 0 < right overlap)
*		a1 = signed z offset	(top overlap < 0 < bot overlap)

 SUBR	get_box_overlap


	move	*a10(20h),a6,L
	callr	calc_line_x
	move	a0,a0
	jrz	#outrange
	PUSH	a0

	move	*a10,a6,L
	callr	calc_line_x
	move	a0,a0			;left
	jrz	#outrange
	PULL	a1			;right

	move	*a13(OBJ_XPOSINT),a4
	sub	a4,a0			;left-xpos
	jrgt	#outside
	neg	a0

	sub	a4,a1			;right-xpos
	jrlt	#outside

	move	*a13(OBJ_ZPOSINT),a2
	move	a2,a3
	move	*a6(10h),a4		;z top
	sub	a4,a2			;zpos-top
	jrlt	#outside

	move	*a6(30h),a4		;z bot
	sub	a4,a3			;zpos-bot
	jrgt	#outside
	neg	a3



	cmp	a0,a1			;right - left
	jrlt	#right_min

;left_min
	cmp	a2,a0			;left - top
	jrgt	#top_min
	cmp	a3,a0			;left - bot
	jrgt	#bot_min

	neg	a0			;xoff
	clr	a1			;zoff
	rets

#right_min
	cmp	a2,a1			;right - top
	jrgt	#top_min
	cmp	a3,a1			;right - bot
	jrgt	#bot_min

	move	a1,a0			;xoff
	clr	a1			;zoff
	rets

#top_min
	cmp	a3,a2			;top - bot
	jrgt	#bot_min

	neg	a2
	move	a2,a1			;zoff
	clr	a0			;xoff
	rets

#bot_min
	cmp	a2,a3			;bot - top
	jrgt	#top_min

	move	a3,a1			;zoff
	clr	a0			;xoff
	rets

#outside
#outrange
	clr	a0
	clr	a1

	rets

#*****************************************************************************

 SUBR	get_rope_x

	PUSH	a6

	movi	vln_right_rope,a6
	move	*a13(OBJ_XPOSINT),a0
	cmpi	RING_X_CENTER,a0
	jrgt	#right
	movi	vln_left_rope,a6
#right
	callr	calc_line_x
	PULL	a6
	rets


#*****************************************************************************
*
* ARGUMENTS:	a6 = * line table
*
* RETURNS:	a0 = x-val of line at player ZPOS
*		a0 = 0 if out of range in Z
*
* TRASHES:	a0,a1


 SUBR	calc_line_x

	move	*a13(OBJ_ZPOSINT),a1

	move	*a6(30h),a0	;z2
	cmp	a0,a1		;zpos - z2
	jrgt	#outrange	;below

	move	*a6(10h),a0	;z1
	sub	a0,a1		;zpos - z1
	jrlt	#outrange	;above

	X16	a1
	add	a6,a1
	move	*a1(40h),a0	;skip 4 word header
	rets
#outrange
	clr	a0
	rets

#*****************************************************************************
*
* ARGUMENTS:	a6 = * line table
*		a1 = ZPOSINT
*
* RETURNS:	a0 = x-val of line at input ZPOS
*		a0 = 0 if out of range in Z
*
* TRASHES:	a0,a1


 SUBR	calc_line_pt

	move	*a6(30h),a0	;z2
	cmp	a0,a1		;zpos - z2
	jrgt	#outrange	;below

	move	*a6(10h),a0	;z1
	sub	a0,a1		;zpos - z1
	jrlt	#outrange	;above

	X16	a1
	add	a6,a1
	move	*a1(40h),a0	;skip 4 word header
	rets
#outrange
	clr	a0
	rets

#*****************************************************************************

 SUBR	wobble_ropes

;Called from wrestler "GETTING HIT" sequences.
;Check to see if I'm up against the ropes.
;If so, wobble them.

	move	*a13(INRING),a0
	jrnz	#exit

	move	*a13(OBJ_XPOSINT),a0
	cmpi	RING_X_CENTER,a0
	jrlt	#lft

	movi	vln_right_rope,a6
	callr	calc_line_x
	movi	ROPE_RIGHT,a2
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;a1-a0
	jrge	#wobble
	jruc	#exit

#lft
	movi	vln_left_rope,a6
	callr	calc_line_x
	movi	ROPE_LEFT,a2
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;a1-a0
	jrle	#wobble
	jruc	#exit

#wobble

;Wrestler has been knocked back into ropes
;Wobble them!
	move	a2,a0
	movk	1,a2
	movi	ROPE_BOUNCEIO,a1
	calla	rope_command
	
#exit	rets

#*****************************************************************************
* 
* If player is moving away from opponent, or standing still, tell the 
* calling SEQUENCE to not leap at the opponent!
*
* This routine is used by all wrestlers.

 SUBR	get_leap

	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)

	move	*a13(OBJ_XVEL),a14,L
	move	*a13(OBJ_ZVEL),a0,L
	or	a14,a0
	jrz	#novel			;Wrestler is standing still!


;Is wrestler backing away from opponent?

	move	*a13(MOVE_DIR),a1
	move	*a13(NEW_FACING_DIR),a0	;Current facing dir (9,10,6,5 only)
	sll	5,a0
	addi	#mv_tbl,a0
	move	*a0,a0,L
	btst	a0,a1
	jrnz	#novel

;Will lunge toward opponent
	rets

#novel
	move	*a13(ANIMODE),a0
	ori	MODE_STATUS,a0
	move	a0,*a13(ANIMODE)

	rets

*****************************************************************************
* 
* If player is moving away from opponent, or standing still, tell the 
* calling routine to ignore button press
*

 SUBR	ck_ignore

;Is wrestler going away from opponent?

	move	*a13(MOVE_DIR),a1
	move	*a13(NEW_FACING_DIR),a0	;Current facing dir (9,10,6,5 only)
	sll	5,a0
	addi	#mv_tbl,a0
	move	*a0,a0,L
	btst	a0,a1
	jrnz	#novel2

;Will allow button press
	clrc	
	rets

#novel2	setc
	rets

#mv_tbl	.long	0,0,0,0,0,MOVE_RIGHT_BIT,MOVE_RIGHT_BIT
	.long	0,0,MOVE_LEFT_BIT,MOVE_LEFT_BIT


#*****************************************************************************
* 
* When we want all ropes to wobble (Butt drops, etc.)
* This routine is used by all wrestlers.

 SUBR	shake_all_ropes

	move	@NUM_OPPS,A1
	CMPI	2,A1
	JRGE	NO_SHAKING

	movi	ROPE_BOUNCEUD,a1
	movk	2,a2

	movi	ROPE_FRONT,a0
	calla	rope_command

	movi	ROPE_BACK,a0
	calla	rope_command

	movi	ROPE_LEFT,a0
	calla	rope_command

	movi	ROPE_RIGHT,a0
	calla	rope_command

NO_SHAKING
	rets

#*****************************************************************************
*
* CALLED FROM WITHIN COLLISION ROUTINES
*
* makes wrestlers face each other & sets x_flip accordingly
*
* a13 = victim process
* a10 = attacker process

 SUBR	face_each_other

	movi	MOVE_RIGHT,a0
	move	*a13(OBJ_XPOS),a2,L
	move	*a10(OBJ_XPOS),a3,L
	cmp	a2,a3		;a3-a2
	jrgt	#right
	movi	MOVE_LEFT,a0
#right
	movi	MOVE_DOWN,a1
	move	*a13(OBJ_ZPOS),a2,L
	move	*a10(OBJ_ZPOS),a3,L
	cmp	a2,a3		;a3-a2
	jrgt	#down
	movi	MOVE_UP,a1
#down
	or	a1,a0
	move	a0,*a13(NEW_FACING_DIR)
	move	a0,*a13(FACING_DIR)

	xori	MOVE_UP|MOVE_DOWN|MOVE_LEFT|MOVE_RIGHT,a0	;opposite

	move	a0,*a10(NEW_FACING_DIR)
	move	a0,*a10(FACING_DIR)

	move	a10,a0
	callr	set_wrestler_xflip

	move	a13,a0
	callr	set_wrestler_xflip

	rets


#*****************************************************************************
* Temp routines

	.if	DEBUG

	BSSX	CPUAVG		,16
	BSSX	CPULEFT		,16


 SUBRP	cputime_calcfree

	move	@dirqtimer,a0
	subk	1,a0
	jrle	nobog
	clr	a0
	jruc	gottime
nobog
	move	@vcount,a0
	subi	EOSINT,a0
	jrnn	skinccnt
	addi	256,a0
skinccnt
	sll	2,a0
	neg	a0
	addi	1024,a0
gottime
	move	a0,@CPULEFT

	srl	4,a0
	move	@CPUAVG,a1
	move	a1,a2
	srl	4,a2			;/16
	sub	a2,a1
	add	a0,a1
	move	a1,@CPUAVG

	rets


	.endif

 .if COL_DEBUG

#*****************************************************************************
* highlights attack box
* a10 is ptr to wrestler process

 SUBRP	collis_debug


	clr	a0				;x pos
	clr	a1				;y pos
	movi	jmeter,a2			;* image
	movi	>1601,a3			;z pos
	movi	DMACAL|M_3D,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ

	clr	a0
	move	a0,*a8(ODXOFF)
	move	a0,*a8(ODYOFF)

	movi	0202h,a0
	move	a0,*a8(OCONST)

#loop
	SLEEPK	1

	movi	7f00h,a0
	move	@debug_collis,a14
	cmpi	2,a14
	jrne	#not_2
	movi	1400h,a0
#not_2
	move	a0,*a8(OZPOS)

	move	@debug_collis,a0
	jrz	#off

	move	*a10(ANIMODE),a0
	btst	MODE_CHECKHIT_BIT,a0
	jrnz	#on

#off
	clr	a0
	move	a0,*a8(OXVAL),L
	move	a0,*a8(OYVAL),L

	move	@slowmo,a0
	move	a0,@slowmotion

	movi	16,a0
	move	a0,*a8(OSIZEX)
	move	a0,*a8(OSIZEY)

	jruc	#loop


#on
	movi	30,a0
	clr	a0

	move	@slowmo,a1
	jrz	#skp
	move	a1,a0
#skp
	move	a0,@slowmotion

	movi	Y_SCALE_MULTIPLIER,a0
	move	*a10(OBJ_ZPOSINT),a1
	mpys	a0,a1
	move	a1,a4			;y val
	srl	16,a4
	move	*a10(OBJ_YPOSINT),a0
	sub	a0,a4

	move	*a10(OBJ_ATTYOFF),a0
	sub	a0,a4
	move	*a10(OBJ_ATTHEIGHT),a0
	sub	a0,a4
	sll	16,a4
	move	a4,*a8(OYVAL),L

	move	*a10(OBJ_ATTWIDTH),a0
	move	a0,*a8(OSIZEX)
	move	*a10(OBJ_ATTHEIGHT),a0
	move	a0,*a8(OSIZEY)

	move	*a10(OBJ_ATTXOFF),a0
	move	*a10(OBJ_XPOSINT),a4

	;check the same way the actual collision code does.
	move	*a10(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#facing_right

;	move	*a10(FACING_DIR),a14
;	btst	PLAYER_RIGHT_BIT,a14
;	jrnz	#facing_right

	neg	a0
	move	*a10(OBJ_ATTWIDTH),a14
	sub	a14,a0

#facing_right

	add	a0,a4
	sll	16,a4
	move	a4,*a8(OXVAL),L



	jruc	#loop

;;;	move	a0,@debug_collis



#*****************************************************************************
* highlights target box
* a10 is ptr to wrestler process

 SUBRP	collis_debug2

	clr	a0				;x pos
	clr	a1				;y pos
	movi	jmeter,a2			;* image
	movi	7f00h,a0	;199
	movi	DMACAL|M_3D,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ

	clr	a0
	move	a0,*a8(ODXOFF)
	move	a0,*a8(ODYOFF)

	movi	0101h,a0
	move	a0,*a8(OCONST)

#loop
	SLEEPK	1

	movi	>1600,a0
	move	@debug_collis,a14
	cmpi	2,a14
	jrne	#not_2
	movi	111,a0
#not_2
	move	a0,*a8(OZPOS)

	move	@debug_collis,a0
	jrnz	#on

	clr	a0
	move	a0,*a8(OXVAL),L
	move	a0,*a8(OYVAL),L

	movi	16,a0
	move	a0,*a8(OSIZEX)
	move	a0,*a8(OSIZEY)

	jruc	#loop

#on
	move	*a10(OBJ_COLLX1),a0
	move	a0,a1
	sll	16,a0
	move	a0,*a8(OXVAL),L

	move	*a10(OBJ_COLLX2),a2
	sub	a1,a2
	move	a2,*a8(OSIZEX)

	movi	Y_SCALE_MULTIPLIER,a0
	move	*a10(OBJ_ZPOSINT),a1
	mpys	a0,a1
	srl	16,a1
	move	*a10(OBJ_COLLY2),a0
	sub	a0,a1
	sll	16,a1
	move	a1,*a8(OYVAL),L

	move	*a10(OBJ_COLLY2),a0
	move	*a10(OBJ_COLLY1),a1
	sub	a1,a0
	move	a0,*a8(OSIZEY)

	jruc	#loop

 .endif

#*****************************************************************************
 .if SCRT_DEBUG

	.bss	imgptrs0,	32*16

 SUBRP	scrt_debug

	movk	16,a1
	movi	imgptrs0,a2
	movi	[10,0],a0			;x pos
#init_loop

	PUSH	a0,a1,a2

	movi	[238,0],a1			;y pos
	movi	d_zip,a2			;* image
	movi	10000,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ

	PULL	a0,a1,a2
	move	a8,*a2+,L
	addi	[16,0],a0
	dsj	a1,#init_loop

#loop


	movi	wrest_joystat,a1
	movi	imgptrs0,a2
	movk	16,a3

#loop2
	move	*a2+,a8,L
	move	*a1+,a5,L
	move	a5,a0

	srl	4,a0
	andi	011111b,a0
	jrz	#cont
	X32	a0
	addi	#button_imgs,a0
	move	*a0,a0,L
	jruc	#cont2

#cont
	move	a5,a0
	andi	01111b,a0
	X32	a0
	addi	#arrow_imgs,a0
	move	*a0,a0,L

#cont2

	PUSH	a1,a2,a3

	callr	#change_image

	PULL	a1,a2,a3
	dsj	a3,#loop2

	SLEEPK	1

	jruc	#loop


#change_image
	move	a0,*a8(OIMG),L
	move	*a0(0),*a8(OSIZE),L
	move	*a0(ISAG),*a8(OSAG),L

	move	*a0(IANIOFFX),a1
	move	a1,*a8(ODXOFF)			;display x offset

	move	*a0(IANIOFFY),a1
	move	a1,*a8(ODYOFF)			;display y offset

	setf	5,0,0
	move	*a0(ICTRL+7),*a8(OCTRL+7) ;Write 5 z comp bits
	setf	16,1,0
	rets

#arrow_imgs
	.long	d_zip		;0
	.long	d_up		;1
	.long	d_down		;2
	.long	d_zip		;3
	.long	d_left		;4
	.long	d_upleft	;5
	.long	d_downleft	;6
	.long	d_zip		;7
	.long	d_right		;8
	.long	d_upright	;9
	.long	d_downright	;10
	.long	d_zip		;11
	.long	d_zip		;12
	.long	d_zip		;13
	.long	d_zip		;14
	.long	d_zip		;15


#button_imgs
	.long	d_zip		;0
	.long	d_block		;1
	.long	d_grab		;2
	.long	d_zip		;3
	.long	d_punch		;4
	.long	d_zip		;5
	.long	d_zip		;6
	.long	d_zip		;7
	.long	d_kick		;8
	.long	d_zip		;9
	.long	d_zip		;10
	.long	d_zip		;11
	.long	d_zip		;12
	.long	d_zip		;13
	.long	d_zip		;14
	.long	d_zip		;15
	.long	d_turbo		;16

 .endif

#*****************************************************************************
 .if DIR_DEBUG

	.bss	imgptrs,	32*3
	.bss	imgptrs2,	32*3

 SUBRP	dir_debug

	movi	[10,0],a0			;x pos
	movi	[25,0],a1			;y pos
	movi	d_zip,a2			;* image
	movi	10000,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ
	move	a8,@imgptrs,L

	movi	[10,0],a0			;x pos
	movi	[25+15,0],a1			;y pos
	calla	BEGINOBJ
	move	a8,@imgptrs+32,L

	movi	[10,0],a0			;x pos
	movi	[25+30,0],a1			;y pos
	calla	BEGINOBJ
	move	a8,@imgptrs+64,L


	movi	[400-24,0],a0			;x pos
	movi	[25,0],a1			;y pos
	calla	BEGINOBJ
	move	a8,@imgptrs2,L

	movi	[400-24,0],a0			;x pos
	movi	[25+15,0],a1			;y pos
	calla	BEGINOBJ
	move	a8,@imgptrs2+32,L

	movi	[400-24,0],a0			;x pos
	movi	[25+30,0],a1			;y pos
	calla	BEGINOBJ
	move	a8,@imgptrs2+64,L



#loop
	clr	a1
	callr	get_process_ptr

	move	a0,a10
	JRZ	NO_ONE_HERE1

	move	*a10(MOVE_DIR),a0
	move	@imgptrs,a8,L
	callr	#ud_arrow

	move	*a10(NEW_FACING_DIR),a0
	move	@imgptrs+32,a8,L
	callr	#ud_arrow

	move	*a10(FACING_DIR),a0
	move	@imgptrs+64,a8,L
	callr	#ud_arrow

NO_ONE_HERE1
	movk	1,a1
	callr	get_process_ptr
	move	a0,a10
	JRZ	NO_ONE_HERE2

	move	*a10(MOVE_DIR),a0
	move	@imgptrs2,a8,L
	callr	#ud_arrow

	move	*a10(NEW_FACING_DIR),a0
	move	@imgptrs2+32,a8,L
	callr	#ud_arrow

	move	*a10(FACING_DIR),a0
	move	@imgptrs2+64,a8,L
	callr	#ud_arrow

NO_ONE_HERE2
	SLEEPK	1
	jruc	#loop


#ud_arrow
	move	a0,a0
	jrnz	#ok
	movi	d_zip,a0
	jruc	#cont
#ok
	callr	convert_facing
	X32	a0
	addi	#arrow_imgs,a0
	move	*a0,a0,L

#cont
	move	a0,*a8(OIMG),L
	move	*a0(0),*a8(OSIZE),L
	move	*a0(ISAG),*a8(OSAG),L

	move	*a0(IANIOFFX),a1
	move	a1,*a8(ODXOFF)			;display x offset

	move	*a0(IANIOFFY),a1
	move	a1,*a8(ODYOFF)			;display y offset

	setf	5,0,0
	move	*a0(ICTRL+7),*a8(OCTRL+7) ;Write 5 z comp bits
	setf	16,1,0
	rets


#arrow_imgs
	.long	d_up
	.long	d_upright
	.long	d_right
	.long	d_downright
	.long	d_down
	.long	d_downleft
	.long	d_left
	.long	d_upleft

	.long	d_punch
	.long	d_kick
	.long	d_block
	.long	d_grab
	.long	d_turbo
	.long	d_zip

 .endif

#*****************************************************************************

 SUBRP	draw_dma_meter

	movi	DIAGP,a0
	calla	pal_getf
	move	a0,a1
	ori	>0E0E0000,a1
	movi	[1,400],a2
	move	@dma_bog,a3
	sll	16,a3
	clr	a4
	movi	DMACAL,a5
	calla	QDMAN
	rets

#*****************************************************************************

 SUBRP	draw_cpu_meter

	movi	DIAGP,a0
	calla	pal_getf
	move	a0,a1
	ori	>0D0D0000,a1
	movi	[1,400],a2
	move	@CPUAVG,a3
	sll	14,a3
	clr	a4
	movi	DMACAL,a5
	calla	QDMAN
	rets

#*****************************************************************************
*
* This gets called once each MATCH for every wrestler, not each round.
* It creates the set of 'watchdog' processes that look out for special
* moves that the usual method can't handle; specifically, stuff that
* involves charging up with a stick, detailed control over timing, or
* proximity to the bad guy.
*

	.ref	bam_smove_table
	.ref	shn_smove_table
	.ref	rzr_smove_table
	.ref	dnk_smove_table
	.ref	hrt_smove_table
	.ref	und_smove_table

 SUBRP	init_smoves

	move	*a13(WRESTLERNUM),a2,W
	X32	a2
	addi	#special_moves,a2
	move	*a2,a2,L
	jrz	#done

#loop
	move	*a2+,a7,L
	jrz	#done
	movi	SMOVE_PID,a1
	move	a13,a8
	calla	GETPRC_INSERT
	jruc	#loop

#done
	rets
	

#special_moves
	.long	hrt_smove_table		;Bret
	.long	rzr_smove_table		;Razor
	.long	und_smove_table		;Taker
	.long	0			;Yoko
	.long	shn_smove_table		;Shawn
	.long	bam_smove_table		;Bam Bam
	.long	dnk_smove_table		;Doink
	.long	0			;spare
	.long	0			;Lex

******************************************************************************
	.end
