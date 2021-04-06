**************************************************************
*
* Software:	Jamie Rivett, Mark Turmell, Jason Skiles
* Initiated:	12/7/93
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
	.include	"sound.equ"
	.include	"damage.equ"

	.include	"newfont.tbl"
	.include	"imgtbl.glo"
	.include	"fontsimg.glo"
	.include	"bgndtbl.glo"
	.include	"miscimg.glo"

; .if DEBUG
;	.include	"dirdebug.tbl"
;
;ARROWS:
;	.word	  4
;	.word	00H,015H,07FFFH,02B5H
; .endif

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

	.if	DEBUG
	.ref	instant_death
	.endif

	.ref	ADD_VOICE,ARE_WE_IN_RING,AUD,AUD1,BAKMODS,BGND_UD1
	.ref	CLEAR_SPEECH_REPEAT,CREATE_TEXT_LINE,CR_CONTP,CR_STRTP
	.ref	CURRENT_LADDER,D2ST2B03,DAM_MULT,DBV,DIAG,DONE_HOWARD
	.ref	DO_CROWD_CHEER,FIND_AND_KILL_ENDLESS,GAME_BEATEN
	.ref	GET_ADJ,GET_AUD,combo_audit_done,FINAL_PTR
	.ref	INIT_LADDER_TABLE,INIT_SKIRTS,INIT_TAB,IRQSKYE,KILL_AUD
	.ref	LCOIN,MATCH_TIMERS,NUM_OPPS,OPEN_PROGRESS_SCREEN
	.ref	POWERCMOS,POWERTST,P_CONT,P_START,RCOIN,READ_DIP
	.ref	RESETUP_PROGRESS,SERVICE,SET_LOWER_VOL,SHIFT_BARS_IN_Z
	.ref	SLAM_SW,SORT_OUT_WRESTLER_NUM,SPECIAL_WIPEOUT,STORE_AUDIT
	.ref	THIS_GAME_IS_BEATEN,VOLBTN_PRESS,WALK_SOUND,do_game_over
	.ref	WDOGRAM,rewire_monitor,XCOIN,DUMRETS,WHICH_SCREEN
	.ref	ZFLIP_POS_VAR,CREATE_TIMEOUT,CCOIN,CHANGE_SKIRTS,CKDIAG
	.ref	set_volume,KILL_ALL_CHANNELS,RESET_VOICE_QUEUE
	.ref	FINAL_BATTLE_LINEUP,RNDRNG0,change_wrestler,match_timer
	.ref	animate_wrestler,are_we_waiting_f,attract_mode
	.ref	bam_ani_init,bret_ani_init,change_anim1,change_anim1a
	.ref	change_anim2,check_collisions,ck_climb_in_bot,keep_onscreen
	.ref	ck_climb_in_side,ck_climb_in_top,ck_climb_out_bot
	.ref	ck_climb_out_side,ck_climb_out_top
	.ref	crowd_anim,dirqtimer,dma_meter,doink_ani_init,buyin_select
	.ref	dpageflip,drone_main,entered_inits,getup_meter
	.ref	index1,index2,init_all,init_life_data,init_special_objlist
	.ref	lex_ani_init,meters,move_bam,move_bret,move_doink,move_lex
	.ref	move_razor,move_shawn,move_taker,move_yoko,adjust_health
	.ref	overlap_collision,pal_getf,pin_speed_in_case,pregame_show
	.ref	print_string_C2,process_dispatch,razor_ani_init,choose_pal
	.ref	read_switches,rope,rope_command,select_screen,init_smoves
	.ref	set_collision_boxes,set_images,setup_message
	.ref	shawn_ani_init,snd_update,square_root,taker_ani_init
	.ref	triple_sound,wgsf24_ascii,wres_get_but_val_down
	.ref	wres_get_stick_val_down,wres_get_stick_val_up
	.ref	wrestler_audits,yoko_ani_init,mess_objid,pal_clean
	.ref	wrestler_veladd,announce_rnd_winner,scroll_world
	.ref	drone_change_back,is_final_match,audit_ud_flag
	.ref	ditch_getup_meter,message_flag,init_rnd_life_data
	.ref	p1rnd_award,p2rnd_award,p1mtch_award,p2mtch_award
	.ref	p1ws_award,p2ws_award,rst_awards,rst_winstreak_awards
	.ref	PERFECT_WINS,MUSIC_HAP,THIS_GAME_TIME,WINS_OBJ
	.ref	arm_winstreak_award,reset_dufus_msgs,clear_icon_total
	.ref	MESSAGE_FLAGS,FLASH_FLAG,royal_rumble,choose_buddies
	.ref	do_show_options,show_options,IKIL1C,is_a14_behind
	.ref	maybe_do_flashes,COMBO_FLASH_FLAG,loser_snd
	.ref	in_finish_move,buddy_mode_on,buddy_mode_checked
	.ref	copy_rom_string,concat_rom_string,setup_message
	.ref	copy_string,dec_to_asc,concat_string,message_buffer
	.ref	osgmd8_ascii,get_all_buttons_cur,_serial_number,_man_date
	.ref	InitPIC,RemapIO,SecFuncCheck
	.ref	rr_loss,postgame_audits
	.ref	wrestler_counter
	.ref	is_8_on_1,bncoff_gate,fall_back_tbl
	.ref	show_wrestler_end_story,do_fireworks
	.ref	p1pins,p2pins,finish_completed


******************************************************************************
* SYMBOLS DEFINED IN THIS FILE


	.def	obj_look,ani_init,mainlp,PCMOSRET,ring_mod

	BSSX	_coin_addr,32
	BSSX	_switch_addr,32
	BSSX	_switch2_addr,32
	BSSX	_watchdog_addr,32
	BSSX	_dipswitch_addr,32
	BSSX	_sound_addr,32
	BSSX	_soundirq_addr,32
	BSSX	_coin_counter_addr,32

;uninitialized ram definitions
	BSSX	no_pin_check,16
	BSSX	belt_ask	,16
	BSSX	belt_type	,16

	BSSX	PSTATUS		,16	;Player in game bits (0-3)
	BSSX	OLD_PSTATUS	,16	;Previous games PSTATUS
	BSSX	PSTARTS		,16	;Not documented.  Pbltltlt.

	.if	DEBUG
	BSSX	SLDEBUG		,16	;Shawn's debug
	BSSX	slowmotion	,16	;!0=Frames of delay for slow motion
	.endif

	BSSX	slowmo		,16	;!0=Frames of delay for slow motion

	;I changed PCNT to a 32-bit value instead of 16 'cuz I'm tired of
	; coding checks for the wraparound case, which happens every ten
	; minutes or so.  Since it's always treated as an unsigned value
	; anyway, it's perfectly safe to continue using it as a word. - JS
	.even
	BSSX	PCNT		,32	;Main loop cnt

	BSSX	swstack_p	,32	;*Stack position
	BSSX	swstackbot	,16*64	;Bottom of stack
	BSSX	swstacktop	,0	;Top of stack

	BSSX	COLRTEMP	,16*16	;RAM COPY OF CYCLING COLORS

	BSSX	GAMSTATE	,16	;Game state: See game.equ

	BSSX	HALT		,16	;FREEZE ALL OBJECTS (NO VEL UPDATE)
	BSSX	NO_START	,16	;FLAG 0=OKAY, 1=NOT RIGHT NOW.

	BSSX	WSPEED		,16
	BSSX	WFLG		,16	;0=NOT ON, 1=YES IT IS ON
	.bss	WNDWFLG		,16	;0=WINDOW SHOULD CLOSE, 1=NO WINDOW
	.even
	BSSX	OBJPTR		,32	;PNTR FOR WINDOW OBJECT


	.bss	PALTMP		,13*16*2 ;ALLOCATE 2 X COLOR AREA IN RAM

	BSSX	match_cnt,	16

	BSSX	debug_collis,	16

	.even
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

	.bss	fudge_x,	32		;wrestler_x[-20h]
	BSSX	wrestler_x,	32*NUM_WRES	;long * number wrestlers
	.bss	fudge_y,	32		;wrestler_y[-20h]
	BSSX	wrestler_y,	32*NUM_WRES	;long *		"
	.bss	fudge_z,	32		;wrestler_z[-20h]
	BSSX	wrestler_z,	32*NUM_WRES	;long *		"

	;This is the game clock at the top of the screen.  It runs at various
	; speeds in the different modes, and can be adjusted by the operator.
	; It's not any kind of real time clock and shouldn't be used for
	; ANYTHING except displaying those two digits.
	BSSX	match_time,	16*3		;frac, 1's, 10's

	BSSX	match_over,	16		;0=not over, !0=over

	;This used to be incremented on the fly.  Bogus, since we lose bog
	; frames that way and end up with an artificially low time.  Instead,
	; compute this based on current PCNT and match_start_time at the
	; end of the match.
	BSSX	match_realtime,	16		;actual seconds elapsed

	BSSX	match_winner,	16		;just like PSTATUS

	BSSX	fight_debug,	16

	BSSX	p1winstreak,	16		;player 1 winning streak
	BSSX	p2winstreak,	16		;player 2 winning streak
	BSSX	p1winstreakd,	16		;player 1 vs drones
	BSSX	p2winstreakd,	16		;player 2 vs drones

	;copy pXwinstreak to pXoldwinstreak immediately after any battle
	; ends, then clear pXwinstreak.
	BSSX	p1oldwinstreak,	16		;player 1 dead winning streak
	BSSX	p2oldwinstreak,	16		;player 2 dead winning streak

	BSSX	current_round,	16		;current round in match (1+)
	BSSX	p1rounds,	16		;player 1 rounds won
	BSSX	p2rounds,	16		;player 2 rounds won

	;keep these in order and adjacent
	.even
	BSSX	front_rproc,	32		;front ropes proc
	BSSX	back_rproc,	32		;back ropes proc
	BSSX	left_rproc,	32		;left ropes proc
	BSSX	right_rproc,	32		;right ropes proc

	BSSX	total_matches,	16		;matches since attract mode
	BSSX	no_debris,	16		;Don't allow debris - it bogs
	BSSX	reduce_bog,	16
	BSSX	allow_offscrn,16		;Allow players offscrn on toss outs

	.bss	bgnd_cntr,16
	BSSX	any_hits,16
	BSSX	robo_icon_trigger,16

	.if DEBUG
	BSSX	stay_down,	16		;flag - don't dec GETUP_TIME
	.endif

	;these three data are only for use in pin times.  They don't count
	; time not spent actually fighting, and so we can't use them for
	; the game time audit.
	BSSX	round_start_time,32		;PCNT at start of round
	BSSX	round_end_time,32		;PCNT at end of round
	
	;Set this at the beginning of a match, and subtract it from PCNT
	; at the end of the match.  THIS is the clock we use for the game
	; time audits.  It won't lose bog frames, and it isn't tied to that
	; silly game clock.
	BSSX	match_start_time,32		;PCNT at start of match
	.text

	.bss	plyr_dmg_given,2*16
	BSSX	wrestler_count,16
	BSSX	wrestler_count_proc,32
	BSSX	temp_music,16

	BSSX	annc_rnd_winner_done,16
	
vln_right_rope_r
	.WORD	RING_TOP_RIGHT,RING_TOP,RING_BOT_RIGHT,RING_BOT
	.WORD	RING_DEPTH,RING_RIGHT_WIDTH
vln_left_rope_r
	.WORD	RING_TOP_LEFT,RING_TOP,RING_BOT_LEFT,RING_BOT
	.WORD	RING_DEPTH,RING_LEFT_WIDTH
vln_right_matedge_r
	.WORD	MAT_TOP_RIGHT,MAT_TOP,MAT_BOT_RIGHT,MAT_BOT
	.WORD	MAT_DEPTH,MAT_RIGHT_WIDTH
vln_left_matedge_r
	.WORD	MAT_TOP_LEFT,MAT_TOP,MAT_BOT_LEFT,MAT_BOT
	.WORD	MAT_DEPTH,MAT_LEFT_WIDTH
vln_right_matedge2_r
	.WORD	MAT2_TOP_RIGHT,MAT2_TOP,MAT2_BOT_RIGHT,MAT2_BOT
	.WORD	MAT2_DEPTH,MAT2_RIGHT_WIDTH
vln_left_matedge2_r
	.WORD	MAT2_TOP_LEFT,MAT2_TOP,MAT2_BOT_LEFT,MAT2_BOT
	.WORD	MAT2_DEPTH,MAT2_LEFT_WIDTH
vln_right_fence_r
	.WORD	ARENA_TOP_RIGHT,ARENA_TOP,ARENA_BOT_RIGHT,ARENA_BOT
	.WORD	ARENA_DEPTH,ARENA_RIGHT_WIDTH
vln_left_fence_r
	.WORD	ARENA_TOP_LEFT,ARENA_TOP,ARENA_BOT_LEFT,ARENA_BOT
	.WORD	ARENA_DEPTH,ARENA_LEFT_WIDTH

	bssx	vln_right_rope,((RING_DEPTH+10)*16)+64
	bssx	vln_left_rope,((RING_DEPTH+10)*16)+64
	bssx	vln_right_matedge,((MAT_DEPTH+10)*16)+64
	bssx	vln_left_matedge,((MAT_DEPTH+10)*16)+64
	bssx	vln_right_matedge2,((MAT2_DEPTH+10)*16)+64
	bssx	vln_left_matedge2,((MAT2_DEPTH+10)*16)+64
	bssx	vln_right_fence,((ARENA_DEPTH+10)*16)+64
	bssx	vln_left_fence,((ARENA_DEPTH+10)*16)+64

	.even
box_matedge
	.long	vln_left_matedge
	.long	vln_right_matedge

box_matedge2
	.long	vln_left_matedge2
	.long	vln_right_matedge2


****************************************************************
* Reset entry point

 SUBR	init_prog

	.if 0
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

	.else
	dint				; Interrupts OFF
	setf	16,1,0			; word sign extend
	setf	32,1,1			; long word sign extend
	movi	STCKST,sp		; Setup the stack pointer

	clr 	a0			; initial mode for VMUX chip
	move	a0,@VMUX_CONTROL,W	; initialize VMUX chip

	movi	00030h,a0		; hit sound reset bit
	move	a0,@COIN_COUNTERS	; this is where reset bit is
	movi	100,a0			; wait for it to catch
	dsjs	a0,$	
	movi	00020h,a0		; let it go
	move	a0,@COIN_COUNTERS


	move	@SOUNDIRQ,a0		; read watchdog status
	btst	8,a0			; Is this reset from a watchdog ?
	jrnz	initp50			; br = no

#lockup

	movk	AUD_LOCKUP,a0		; watchdog audit
	calla	AUD1

;04/01/95 - NOTE:  It may look a little dumb to have two calls to InitPIC
;here instead of one above before the read for the watchdog status and it may
;be tempting to move the InitPIC call to before the watchdog status read BUT
;don't do it!!!  The watchdog status MUST be read BEFORE the PIC is initialized
;or the status of the watchdog will be reset.

initp50
	calla	InitPIC			; Initialize the PIC and the I/O system
	move	a0,@WATCHDOG		; Kill the dog fer yucks
	calla	READ_DIP		; Read the dipswitches
	btst	6,a0			; Is the power test bypass switch on?
	jrnz	#skip_powerst		; br = yes
	jauc	POWERTST		; Go off and run the power up tests
#skip_powerst
	calla	InitPIC			; Reinitialize the PIC and I/O system
	.endif


******************************************************************************

 SUBR	WARMSET

	dint
	setf	16,1,0			;Field0 = Word sign extend
	setf	32,0,1			;Field1 = Long word
	movi	STCKST,sp		;Top of stack

	calla	InitPIC

;This takes all day to run.  leave it out until we ship.
	.if DEBUG
	.else
	jauc	POWERCMOS
	.endif
PCMOSRET

	calla	init_all		;Initialize hardware
; These are stored in these reggies to protect them
	move	b5,@_serial_number,L
	move	b6,@_man_date,L
	calla	SecFuncCheck		;Check to make sure security functions
					;have not been mucked with
	calla	INIT_TAB		;Reset todays high score table

	.if DEBUG
	clr	a14
	move	a14,@fight_debug
	move	@_soundirq_addr,a14,L
	move	*a14,a14
	btst	8,a14
	jrnz	#no_dog
	LOCKUP
#no_dog
	.endif

	calla	CKDIAG
	jrz	main_go			;No diag switches closed?

	CREATE	DIAG_PID,DIAG		;Fire off the diag process
	jruc	mainlp
main_go
	CREATE	AMODE_PID,attract_mode	;Start the attract mode

	;fall through

********************************
* Main loop

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
	.ref	draw_dma_meter
	calla	draw_dma_meter
#no_dmaline
 .endif


;isn't there a less obvious place
;that we can remap the IO ???
;	btst	5,a1
;	jrz	_no_remap
;	calla	RemapIO
;_no_remap

	callr	switch_unstack
	calla	snd_update		;Update the sound calls

	.if	DEBUG
	calla	cputime_calcfree
	.endif

	;update all 32 bits of PCNT
	move	@PCNT,a0,L
	addk	1,a0
	move	a0,@PCNT,L

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
	movi	p1winstreakd,a4
	movi	entered_inits,a1
	movi	MATCH_TIMERS,a3
	movi	p1ws_award,a14
	move	a8,a8
	jrz	#rstp1scor
	MOVI	process_ptrs+020H,A2
	movi	p2winstreak,a0
	movi	p2winstreakd,a4
	movi	entered_inits+030h,a1
	movi	MATCH_TIMERS+020H,a3
	movi	p2ws_award,a14
#rstp1scor
	calla	rst_winstreak_awards	;reset player winstreak awards
	PUSH	a0
	clr	a0
	move	a8,a8
	jrz	#do_dmsg_rst
	movk	1,a0
#do_dmsg_rst
	calla	reset_dufus_msgs
	move	a8,a0
	calla	clear_icon_total
	move	a0,a8
	PULL	a0
;	calla	dufus_msgs_on
	clr	a14
;	move	a14,@belt_ask
	move	a14,*a0,W		;wins
	MOVE	A14,*A1,L		;entered_inits
	MOVE	A14,*A2,L		;process_ptrs
	MOVE	A14,*A3,L		;MATCH_TIMERS

	move	*a4,a0
	jrn	#a4ok
	move	a14,*a4,W		;wins vs drones
#a4ok

	PULL	a0

	move	@OLD_PSTATUS,a14
	btst	a8,a14
	jrz	#reg			;Player on buyin screen?
;On the buyin screen.
	cmpi	INSELECT,a0
	jreq	#start_from_waitcont
	LOCKUP

#reg

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

	cmpi	INPREGAME2,a0
	jreq	#start_from_midgame

	cmpi	INGAME,a0
	jreq	#start_from_midgame

	LOCKUP

	jruc	#die			;cases we forgot...

#start_from_midgame

	movi	AUD_TOTSTARTS,a0	;inc total starts audit
	calla	AUD1

	calla	P_START			;eat the creds

	CREATE	NO_PID,game_interrupt		;create the game proc

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
	movk	25,a0
	move	a0,@robo_icon_trigger

	movk	1,a0
	move	a0,@no_pin_check
	move	a0,@belt_ask

	movi	AUD_PRESTARTS,a0	;inc attract mode starts audit
	calla	AUD1

	movi	AUD_TOTSTARTS,a0	;inc total starts audit
	calla	AUD1

	calla	P_START			;eat the creds

	;Reset the volume levels here
	calla	KILL_ALL_CHANNELS
	calla	RESET_VOICE_QUEUE

	movi	ADJVOLUME,a0
	calla	GET_ADJ
	BADCHK	a0,0,255,28		;reg, lo, hi, val if bad
	calla	set_volume

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


	CREATE	NO_PID,game_loop		;create the game proc
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
	CREATE	NO_PID,game_loop		;make a new game loop.  This will

	clr	a3
	calla	SNDSND

	calla	KILL_ALL_CHANNELS
	calla	RESET_VOICE_QUEUE

	movk	11,a3			;Little rap ditty
	calla	SNDSND

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
	MOVE	@PSTARTS,A14
	or	a0,a14
	move	a14,@PSTARTS
	CLR	A0
	MOVE	A0,@THIS_GAME_TIME
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

#die	DIE


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

	;...but if the player has already lost, go ahead and dec.
	MOVE	@match_winner,a0
	jrz	#decldr

	;someone has won--figure out if it's our player.  We can't look at
	; PSTATUS because the other player has now bought in and it's gonna
	; be 3.  Instead, look at the process_ptrs.  There'll be a non-zero
	; value one of the first two, and that's our player.
	move	@process_ptrs,a14,L
	jrz	#op2
#op1	;p1 is the human.  test bit 0 of match_winner
	btst	0,a0
	jrnz	#nodecldr

	;p1 lost.  kill his PSTATUS bit.
	movi	2,a14
	move	a14,@PSTATUS

	jruc	#decldr
#op2	;p2 is the human.
	btst	1,a0
	jrnz	#nodecldr

	;p2 lost.  kill his PSTATUS bit.
	movi	1,a14
	move	a14,@PSTATUS

#decldr	MOVE	@CURRENT_LADDER,A0,L
	SUBI	020H,A0
	MOVE	A0,@CURRENT_LADDER,L
#nodecldr

;If match/rnd winner anouncement is on screen, kill it
	movi	ANNC_PID,a0
	clr	a1
	not	a1
	calla	KILALL

	movi	CYCPID,a0
	clr	a1
	not	a1
	calla	KILALL

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

	calla	pal_clean




	movi	ACTIVE,a3,L

#lp	move	*a3,a3,L	;Get next
	jrz	#x		;End?
	move	*a3(PWAKE),a0,L
	move	*a3(PTIME),a14	;Add sleep
	addi	3*60,a14
	move	a14,*a3(PTIME)
	jruc	#lp
#x

	CREATE	SET_IMAGES_PID,DO_SET_IMAGES
	.ref	fade_down_half
	movi	#no_fade,a10
	CREATE	FADE_PID,fade_down_half

	SLEEP	120

	calla	KILL_ALL_CHANNELS
	calla	RESET_VOICE_QUEUE

	movi	ADJVOLUME,a0
	calla	GET_ADJ
	BADCHK	a0,0,255,28		;reg, lo, hi, val if bad
	calla	set_volume

	movk	1,a0
	move	a0,@no_pin_check
	movk	11,a3			;Little rap ditty
	calla	SNDSND


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

;	.if DEBUG
;	;don't allow this out in the field yet.
;	JSRP	robo_check
;	.endif

	movk	1,a0
	move	a0,@NUM_OPPS

	JSRP	select_screen
	clr	a0
	move	a0,@no_pin_check

do_pregame

	;clear match_winner
	clr	a14
	move	a14,@match_winner

;	.ref	robo_check
;
;	JSRP	robo_check		; RETURNS ONLY
	movk	INPREGAME,a14		;set GAMSTATE
	move	a14,@GAMSTATE
	movi	PREGAME_PID,a14		;set our PID
	move	a14,*a13(PROCID)

	move	@match_cnt,a0
	inc	a0
	move	a0,@match_cnt

	move	@PSTATUS,A0
	CMPI	3,A0
	JREQ	NOT_FINISHED_GAME

	calla	is_final_match
	jrc	finished_game

NOT_FINISHED_GAME
	movk	1,a14
	move	a14,@do_show_options
	JSRP	pregame_show
	
#game
	movi	INGAME,a14		;set GAMSTATE
	move	a14,@GAMSTATE
	movi	GAME_PID,a14		;set our PID
	move	a14,*a13(PROCID)

	clr	a0
	move	a0,@p1rounds
	move	a0,@p2rounds
	move	a0,@in_finish_move

	movk	1,a0
	move	a0,@current_round

	;set match_start_time
	move	@PCNT,a14,L
	move	a14,@match_start_time,L

	;do the match
	JSRP	start_match

	;inc the TOTAL GAMES audit
	movi	AUD_TOTALGAMES,A0
	CALLA	AUD1

;The only time we return from start_match is when the match is over
;and the game must goto:

;1.  Buy-in screen for 1 or 2 player games
;2.  Ladder screen for the next matchup
;3.  Finale screens

	;clear out howard speech flag so he can say it again on
	; new select screen.
	CLR	A0
	MOVE	A0,@DONE_HOWARD

	;set delay before allowing player to select a wrestler
	movi	60,a0
	move	a0,@are_we_waiting_f

	;If that was a royal rumble, branch right now.  The following code
	; assumes that PLYRNUMs match PLYR_SIDEs for human players.
	move	@royal_rumble,a14
	jrnz	#finished_rumble

	;Did a human player lose?
	move	@PSTATUS,a0
	move	@match_winner,a1
	andn	a1,a0
	jrnz	#go_buyin

;This player will keep on playing.
;Display ladder of progreesion which shows his next opponent.

	move	@match_winner,a10
	dec	a10
	JSRP	pin_speed_in_case
	jruc	do_pregame

#go_buyin
;Display 2 player buyin screen.
;Turn on appropriate messages for each player
;One guy lost, check if he achieved a high score.  (Most wins)
;If so, allow him to enter initials just on his panel.

	;if the loser had a win streak, do a random sound call.
	calla	loser_snd

	;save old PSTATUS
	move	@PSTATUS,a0
	move	a0,@OLD_PSTATUS

	;did a human win?  Check by ANDing match_winner with PSTATUS.
	move	@PSTATUS,a0
	move	@match_winner,a1
	and	a1,a0
	jrnz	#human_won

	;The cpu won
	clr	a0
	move	a0,@match_winner

	;decrement CURRENT_LADDER, because NEXT_IN_LADDER automatically
	; increments it.
	move	@CURRENT_LADDER,A0,L
	subi	20h,a0
	move	a0,@CURRENT_LADDER,L

#human_won
	;use match_winner as our new PSTATUS.
	move	@match_winner,a0
	move	a0,@PSTATUS

	calla	is_final_match
	jrc	finished_game

	JSRP	buyin_select

;Clear the loser's wincount
	movi	p1winstreak,a1
	move	@match_winner,a0

	cmpi	1,a0
	jrnz	#notp1
	movi	p2winstreak,a1

#notp1	clr	a14
	move	a14,*a1

	jruc	do_pregame

****

#finished_rumble

	;save old PSTATUS
;	move	@PSTATUS,a14
;	move	a14,@OLD_PSTATUS

	;...no, DON'T save the old PSTATUS.  For whatever reason, the
	;buyin/select stuff won't work with a PSTATUS of 0 and an
	;OLD_PSTATUS of 3.  Evidently two people losing is too traumatic
	;an event for this rickety code to deal with.  So we just pretend.
	;Maybe we fix this before we ship, maybe we don't.  It works.

	;create a set_images process to keep us animating while this
	; stuff is going on.
	CREATE	SET_IMAGES_PID,DO_SET_IMAGES
	PUSHP	a0		;store set_images proc address
	JSRP	show_most_damage

	movk	1,a14
	move	a14,@OLD_PSTATUS

	;did the humans win?
	move	@p1winstreak,a0
	clr	a14
	move	a14,@p1winstreak
	move	a14,@p2winstreak
	move	a14,@p1oldwinstreak
	move	a14,@p2oldwinstreak
	TEST	a0
	jrz	#rr_cpuwon

	;create a set_images process to keep us animating while this
	; stuff is going on.

	;set GAMSTATE to INPARTY--disallows buyins
	movk	INPARTY,a14
	move	a14,@GAMSTATE

	JSRP	do_fireworks

	PULLP	a0		;restore set_images proc address
	calla	KILL

	;inc the 'human wins in rumble' audit
	movi	AUD_RRWINS,a0
	calla	AUD1

	JSRP	GAME_BEATEN

	.if	RR_AWARD = 1

	;zero entered_inits
	clr	a14
	move	a14,@entered_inits,L
	move	a14,@entered_inits+20h,L
	move	a14,@entered_inits+40h,L
	
	jruc	do_pregame
	.endif

#rr_cpuwon

	clr	a14
	move	a14,@PSTATUS
	movk	3,a14
	move	a14,@OLD_PSTATUS
	move	a14,@rr_loss
	JSRP	buyin_select

	;clear royal_rumble
	clr	a14
	move	a14,@rr_loss
	move	a14,@royal_rumble

	move	@PSTATUS,a14
	jrnz	do_pregame

	;nobody bought in.  drop to game over
	jauc	do_game_over
****

finished_game
	;player has won the entire game.

	;set GAMSTATE to INPARTY--disallows buyins
	movk	INPARTY,a14
	move	a14,@GAMSTATE

;Audit total time for a 1 credit game
	MOVI	AUD_CREDLEN,A0
	MOVE	@THIS_GAME_TIME,A1
	CALLA	AUD
	MOVI	AUD_CREDLENNUM,A0
	CALLA	AUD1
	CLR	A0
	MOVE	A0,@THIS_GAME_TIME
	MOVE	A0,@PSTARTS


	;create a set_images process to keep us animating while this
	; stuff is going on.
	CREATE	SET_IMAGES_PID,DO_SET_IMAGES
	PUSHP	a0
	JSRP	do_fireworks
	PULLP	a0
	calla	KILL
	calla	is_8_on_1
	jrnc	#no_stories
	JSRP	show_wrestler_end_story
#no_stories
	JSRP	GAME_BEATEN
	JSRP	CREATE_TEXT_LINE
	JAUC	THIS_GAME_IS_BEATEN

#buyin_mod
	.long	wwfselbkBMOD
	.word	-40,0
	.long	0

#no_fade
	.long	WGSF_Y_P,scorep,0
LN1b_setup
	JAM_STR	wgsf24_ascii,12,0,200,77,WGSF_Y_P,0
LN2b_setup
	JAM_STR	wgsf24_ascii,6,0,200,120,WGSF_Y_P,0
#str_game
	.byte	"CHALLENGER",0
#str_over
	.byte	"FOUND!",0
	.even


pprompt
	.string	"PLAYER ",0
	.even
ydid_prompt
	.string	" INFLICTED",0
	.even
pct_damage
	.string	"% OF THE TOTAL DAMAGE!!!",0
	.even
pprompt_setup
	.ref	osgemd_ascii
;	JAM_STR	osgmd8_ascii,10,0,200,140,SGMD8YEL,print_string_C2
	JAM_STR	osgemd_ascii,10,0,200,140,BLUE,print_string_C2
	.even
pct_damage_setup
;	JAM_STR	osgmd8_ascii,10,0,200,155,SGMD8YEL,print_string_C2
	JAM_STR	osgemd_ascii,10,0,200,163,BLUE,print_string_C2
	.even
	.bss	dmg_ram,16*64

#*************************************************************************
*
 SUBRP	show_most_damage
	PUSHP	a0,a1,a2,a4
	PUSHP	a8,a9,a10,a11

	clr	a11			; Clear out plyr damage totals
	clr	a1			; Clear total damage done
	move	a11,@plyr_dmg_given,L

	movi	process_ptrs,a8		; Get process pointers
#find_damage_lp
	move	*a8+,a9,L		; Get player process pointer
	jrz	#find_done		; are we done ? - br = yes
	move	*a9(PLYR_TYPE),a10	; Get the player type
	jrnz	#find_damage_lp		; Is this a drone - br = yes
	move	*a9(DAMAGE_GIVEN),a11	; Get damage this player did
	add	a11,a1			; Total the damage
	move	*a9(PLYRNUM),a10	; Which player is this
	sll	4,a10			; Point to temp storage for this player
	addi	plyr_dmg_given,a10
	move	a11,*a10		; Store his damage
	jruc	#find_damage_lp		; Keep going
#find_done
	movk	1,a11			; Set player 1
	move	@plyr_dmg_given,a8	; Get player 1 damage
	move	@plyr_dmg_given+10h,a9	; Get player 2 damage
	cmp	a8,a9			; Player 1 did more damage ?
	jrlt	#p1_most		; br = yes
	movk	2,a11			; Set player 2
	move	a9,a8			; Set damage done
#p1_most
	move	a8,a9			; Set up for conversion to %
	movi	100,a10			; Mult damage done by 100
	mpyu	a10,a9
	divu	a1,a9			; Divide by total damage done

	movi	pprompt_setup,a2	; Show which player did most damage
	calla	setup_message
	movi	CLSDEAD,a4
	move	a4,@mess_objid
	move	a11,a0
	movk	2,a1
	calla	dec_to_asc
	movi	pprompt,a4
	calla	copy_rom_string
	calla	concat_string
	movi	ydid_prompt,a4
	calla	concat_rom_string
	movi	message_buffer,a4
	calla	print_string_C2
	
	movi	pct_damage_setup,a2	; Show how much damage he/she did
	calla	setup_message
	movi	CLSDEAD,a4
	move	a4,@mess_objid
	move	a9,a0
	movi	100,a1
	calla	dec_to_asc
	calla	copy_string
	movi	pct_damage,a4
	calla	concat_rom_string
	movi	message_buffer,a4
	calla	print_string_C2
	.ref	hscore_colcyc

	calla	hscore_colcyc
	move	a0,a8
	SLEEP	TSEC			; Show for 1 second minimum

	movi	TSEC*2,a9		; Allow upto 2 more seconds
#wait_lp
	SLEEPK	1
	calla	get_all_buttons_cur
	jrnz	#sd_exit
	dsjs	a9,#wait_lp
#sd_exit
	move	a8,a0
	calla	KILL
	PULLP	a8,a9,a10,a11
	PULLP	a0,a1,a2,a4
	RETP


#*****************************************************************************
;Copy pXwinstreaks to pXoldwinstreaks, then
;increment winner's winstreak and clear loser's.

 SUBR	increment_wincount

	;save old streaks
	move	@p1winstreak,a14
	move	a14,@p1oldwinstreak
	move	@p2winstreak,a14
	move	a14,@p2oldwinstreak

	move	@match_winner,a0
	move	@PSTATUS,a14
	and	a14,a0

	;inc/clear p1winstreak
	move	@p1winstreak,a1
	inc	a1
	btst	0,a0
	jrnz	#p1ok
	clr	a1

#p1ok	PUSHP	a2
	clr	a2
	calla	arm_winstreak_award
	PULLP	a2

	move	a1,@p1winstreak
	move	a1,a1
	jrnz	#no_clr_p1_ws_awards
	movi	p1ws_award,a14
	calla	rst_winstreak_awards
#no_clr_p1_ws_awards

;	;inc/clear p1winstreakd (clear if lost, inc if won vs drones)
;	btst	0,a0
;	jrz	#clrp1d			;clr if we lost
;	move	@p1winstreakd,a1
;	move	@PSTATUS,a14
;	btst	1,a14
;	jrz	#incp1d			;inc if vs drone
;	jruc	#p1dset			;else no increment
;
;#incp1d	inc	a1
;	jruc	#p1dset
;#clrp1d	clr	a1
;#p1dset	move	a1,@p1winstreakd

	;inc/clear p2winstreak
	move	@p2winstreak,a1
	inc	a1
	btst	1,a0
	jrnz	#p2ok
	clr	a1
#p2ok	PUSHP	a2
	movk	1,a2
	calla	arm_winstreak_award
	PULLP	a2
	move	a1,@p2winstreak
	move	a1,a1
	jrnz	#no_clr_p2_ws_awards
	movi	p2ws_award,a14
	calla	rst_winstreak_awards
#no_clr_p2_ws_awards

;	;inc/clear p2winstreakd (clear if lost, inc if won vs drones or
;	; value < 2.
;	btst	1,a0
;	jrz	#clrp2d			;clr if we lost
;	move	@p2winstreakd,a1
;	move	@PSTATUS,a14
;	btst	0,a14
;	jrz	#incp2d			;inc if vs drone
;	jruc	#p2dset			;else no increment
;
;#incp2d	inc	a1
;	jruc	#p2dset
;#clrp2d	clr	a1
;#p2dset	move	a1,@p2winstreakd

	;adjust p1&p2winstreakd. three possibilities:
	; 1. 2p match.  do nothing
	; 2. 1p match, player wins.  inc his winstreak.
	; 3. 1p match, player loses.  set both winstreaks to -1, unless
	;     they're already negative, in which case we dec both.

	move	@PSTATUS,a14
	cmpi	3,a14
	jreq	#do_nothing

	move	@match_winner,a0
	cmp	a0,a14
	jrne	#dec_both
;	jruc	#inc_one

#inc_one
	dec	a0
	X16	a0
	addi	p1winstreakd,a0
	move	*a0,a14
	jrnn	#ib_ok
	clr	a14
#ib_ok	inc	a14
	move	a14,*a0
	jruc	#do_nothing

#dec_both
	move	@p1winstreakd,a14
	jrn	#db_ok
	clr	a14
#db_ok	dec	a14
	move	a14,@p1winstreakd
	move	a14,@p2winstreakd
;	jruc	#do_nothing

#do_nothing

	rets

#*****************************************************************************
*
* This is the master fight process.  It's created once, and it doesn't end
* until the entire match is over.  Between rounds, it's just suspended--
* it doesn't actually die and get re-created.
*

 SUBR	start_match

	;skip some of this if we're in attract mode
	move	@PSTATUS,a14
	jrz	#amode_battle

	move	@total_matches,a14,W
	inc	a14
	move	a14,@total_matches,W
	CALLA	SPECIAL_WIPEOUT
	clr	a14			; Clear out stuff for finishing moves
	move	a14,@p1pins
	move	a14,@p2pins
	move	a14,@finish_completed

	movi	p1mtch_award,a14	; Reset the per match awards
	calla	rst_awards
	movi	p1rnd_award,a14		; Reset the per round awards
	calla	rst_awards

#amode_battle

	calla	pal_clean

****	;routine display initialization
	movk	1,a0
	move	a0,@dpageflip
	move	a0,@HALT

****	;position the scroller
	callr	init_scroller

****	;If this is the final match, initialize FINAL_PTR.  We can't do
	; it in NEXT_IN_LADDER because if we're speeding through the
	; rounds, that can happen while wrestler processes from the
	; previous round are still active and DEAD, so they gobble up
	; the first three slots and we end up with a 1v5 match.
	calla	is_final_match
	jrnc	#do_zf
	movi	FINAL_BATTLE_LINEUP+24,a14
	move	a14,@FINAL_PTR,L

****	;World Y-position at which power bars toggle in z
#do_zf	movi	ZFLIP_POS,a0
	move	a0,@ZFLIP_POS_VAR,L

****	;set up the ring.
	movi	ring_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

****	;init message_flag - clears 'already done' bits for move names
	clr	a0
	move	a0,@message_flag,L
	move	a0,@MESSAGE_FLAGS,L	;clear which side has a message out
	MOVE	A0,@FLASH_FLAG		;clear out the 'doing flashes' flag
	MOVE	A0,@COMBO_FLASH_FLAG,L ;clear out combo flashing message

****	;kill off any perpetual yells that might be going on.
	CALLA	FIND_AND_KILL_ENDLESS

****	;create misc stuff like crowd, clocks, a wipe, and some debug stuff.
	CREATE	CROWD_PID,crowd_anim
	CREATE	TIMER_PID,match_timer
	CREATE	ZSHIFT_PID,SHIFT_BARS_IN_Z
	CREATE	FLASH_PID,maybe_do_flashes
	clr	a14
	move	a14,@wrestler_count_proc,L
	move	@royal_rumble,a14
	jrnz	#create_wcounter
	calla	is_8_on_1
	jrnc	#no_wcounter
#create_wcounter
	CREATE	WCOUNT_PID,wrestler_counter
	move	a0,@wrestler_count_proc,L
#no_wcounter

 .if DIR_DEBUG
	CREATE	DIR_DEBUG_PID,dir_debug
 .endif

 .if SCRT_DEBUG
	CREATE	SCRT_DEBUG_PID,scrt_debug
 .endif

****	;create ropes

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

****	;initialize various other crap
	clr	a0
	move	a0,@match_winner
	MOVE	A0,@DAM_MULT
	MOVE	A0,@combo_audit_done
	move	a0,@no_debris
	move	a0,@any_hits
	MOVE	A0,@PERFECT_WINS
	MOVE	A0,@MUSIC_HAP
	MOVE	A0,@WINS_OBJ,L 
	MOVE	A0,@WINS_OBJ+20H,L 
	MOVE	A0,@WINS_OBJ+40H,L 

	.if	DEBUG
	move	a0,@instant_death
	.endif

****	;increment the battles started audit
	movi	AUD_VSHUMS,a0
	move	@PSTATUS,a14
	JRZ	NO_BATLES_AT_ALL
	cmpi	03h,a14
	jreq	#aud_vshumf
	movi	AUD_VSCPUS,a0
#aud_vshumf
	calla	AUD1
NO_BATLES_AT_ALL

	;clear out the process_ptrs data
	callr	CLEAR_PROCESSES

****	;initialize the life and combo bars.
	calla	init_life_data

****	;create wrestler processes

	;figure out if it's a 0-, 1-, or 2-player game, and branch.
	MOVE	@PSTATUS,A0
	jrz	#0plyr
	CMPI	3,A0
	JREQ	#2plyr

#1plyr	;1-player game

	;create player process
	movi	PSIDE_PLYR1,a9		;side on
	clr	a10			;plyrnum
	move	@index1,a11		;wrestlernum

	btst	0,A0
	jrnz	#set

	movi	PSIDE_PLYR2,a9		;side on
	movk	1,a10			;plyrnum
	move	@index2,a11		;wrestlernum

#set	movi	PTYPE_PLAYER,a8		;player type
	SCREATE	WMAIN_PID,wrestler_main
	callr	set_process_ptr2
	CREATE	GETUP_PID,getup_meter


#ndrone	;create the drone processes
	;get the lineup for the coming battle
	MOVE	@CURRENT_LADDER,A4,L
	MOVE	*A4,A4,L		;battle lineup

	;drone PLYRNUM's start at 2
	MOVK	2,A10
	move	@NUM_OPPS,a3

#nxtdrn	CALLA	SORT_OUT_WRESTLER_NUM

*jakeeee if you want a specific wrestler, put his number in A11 here !

	movi	PTYPE_DRONE,a8		;player type

	;set PLYR_SIDE for ENEMY drones--All these drones are bad guys.
	;In a 2v2 match, we can't use this code.
	movi	PSIDE_PLYR2,a9
	move	@PSTATUS,a14
	btst	0,a14			;plyr 1 human?
	jrnz	#pside_set
	movi	PSIDE_PLYR1,a9
#pside_set

 .if DEBUG
	move	@skip_select,a0
	jrge	#skp
	movk	6,a11	;make him a doink
#skp
 .endif

	SCREATE	WMAIN_PID,wrestler_main
	callr	set_process_ptr2
	CREATE	GETUP_PID,getup_meter
	SRL	8,A4				;shift battle lineup
	INC	A10				;inc PLYRNUM
	dsj	a3,#nxtdrn

	JRUC	#wrestlers_created

*****

#0plyr	;0-player (attract mode) game
	movi	PTYPE_DRONE,a8			;player type
	movi	PSIDE_PLYR1,a9			;side on
	movk	2,a10				;wres num
	move	@index1,a11			;wrestler
	SCREATE	WMAIN_PID,wrestler_main		;player 1
	callr	set_process_ptr2
	CREATE	GETUP_PID,getup_meter

	move	@CURRENT_LADDER,a4,L
	move	*a4,a4,L
	move	@NUM_OPPS,a3
	movi	PTYPE_DRONE,a8
	movi	PSIDE_PLYR2,a9
#nxt	calla	SORT_OUT_WRESTLER_NUM
	srl	8,a4				;shift battle lineup
	inc	a10				;inc PLYRNUM
	SCREATE	WMAIN_PID,wrestler_main
	callr	set_process_ptr2
	CREATE	GETUP_PID,getup_meter
#ngup	dsj	a3,#nxt

	jruc	#wrestlers_created
     
*****
	
#2plyr	;2-player game

	movi	PTYPE_PLAYER,a8			;player type
	move	@PSTATUS,a0
	btst	0,a0
	jrnz	#ok
	movi	PTYPE_DRONE,a8			;player type
#ok	movi	PSIDE_PLYR1,a9			;side on
	clr	a10				;wres num
	move	@index1,a11			;wrestler
	SCREATE	WMAIN_PID,wrestler_main		;player 1
	callr	set_process_ptr2
	CREATE	GETUP_PID,getup_meter

	movi	PTYPE_PLAYER,a8			;player type
	move	@PSTATUS,a0
	btst	1,a0
	jrnz	#ok1
	movi	PTYPE_DRONE,a8			;player type
#ok1	movi	PSIDE_PLYR2,a9			;side on

	;if we're in royal rumble mode, second guy is on first team
	move	@royal_rumble,a14
	sub	a14,a9

	movk	1,a10				;wres num
	move	@index2,a11			;wrestler
	SCREATE	WMAIN_PID,wrestler_main		;player 2
	callr	set_process_ptr2
	CREATE	GETUP_PID,getup_meter

	;set the 'too late now to choose buddy mode' flag
	movk	1,a14
	move	a14,@buddy_mode_checked

	;If they selected buddy mode, add a pair of drones.
	;WE HAVE TO COMPUTE buddy_mode_on OURSELVES, because
	; the code that normally does that kind of thing hasn't
	; gone off yet.
	.ref	p1powerup_request
	.ref	p2powerup_request
	move	@p1powerup_request,a8,L
	move	@p2powerup_request,a9,L
	and	a9,a8
	andi	BUDDY_MODE,a8
	move	a8,@buddy_mode_on
	jrz	#no_buddies

	calla	choose_buddies
	PUSH	a0,a1		;store the two wrestlernums
	
	movk	PTYPE_DRONE,a8
	movi	PSIDE_PLYR1,a9
	movk	2,a10
	PULL	a11		;get the first buddy
	SCREATE	WMAIN_PID,wrestler_main
	callr	set_process_ptr2

	movk	PTYPE_DRONE,a8
	movk	PSIDE_PLYR2,a9
	movk	3,a10
	PULL	a11		;get the second buddy
	SCREATE	WMAIN_PID,wrestler_main
	callr	set_process_ptr2

	jruc	#wrestlers_created

#no_buddies

	;if we're in royal rumble mode, create the starting bad guys.
	move	@royal_rumble,a14
	jrz	#wrestlers_created

	;you never hit the progress screen in royal_rumble mode, so we've
	; got to set up some stuff by hand.

	.ref	get_royal_lineup

	calla	get_royal_lineup
	movi	FINAL_BATTLE_LINEUP,a0
	move	*a0,a1,L
	andi	0000FFFFh,a1
	ori	02000000h,a1

	move	@CURRENT_LADDER,a14,L
	move	a1,*a14,L
	movk	2,a14
	move	a14,@NUM_OPPS

	;set FINAL_PTR to the next guy to fight.
	addi	2*8,a0
	move	a0,@FINAL_PTR,L

	jruc	#ndrone

#wrestlers_created

****	;create the rewire monitor - this has to be done AFTER all the
	; set_process_ptr2's have been called
	CREATE	REWIRE_PID,rewire_monitor

	;play the battle music

 .if	DEBUG
	movi	40,a3
	move	@skip_select,a14
	jrnz	#marked_snd
 .endif

	movk	16,a3
	move	@royal_rumble,a14
	jrnz	music_selected
	calla	is_8_on_1
	jrc	music_selected
	movk	25,a3
	move	@hcount,a14
	srl	1,a14
	jrnc	music_selected
	movk	15,a3
music_selected
	move	a3,@temp_music

	calla	SNDSND

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

	callr	init_reduce_bog

	calla	init_special_objlist

	clr	a0
	move	a0,@match_over

	CALLA	RESETUP_PROGRESS
	calla	INIT_SKIRTS

	SLEEPK	1

	calla	BGND_UD1
	SLEEPK	1

;	CREATE	SKIRT_PID,CHANGE_SKIRTS

	;if this is the first match after attract mode, cue vince.
	move	@total_matches,a14
	dec	a14
	jrnz	#no_vince_intro
	CREATE	SKIRT_PID,CHANGE_SKIRTS
	move	@PSTATUS,A0
	CMPI	3,A0
	JRNE	#no_vince_intro

	movi	0E0h,a0
	calla	ADD_VOICE
	MOVI	01FAH,A0
	calla	ADD_VOICE
	JRUC	INTRO_DONE

#no_vince_intro
	MOVK	5,A0
	CALLA	RNDRNG0
	JRNZ	INTRO_DONE
	MOVI	THIS_IS_FOR_THE_MARBLES,A0
	CALLA	ADD_VOICE
INTRO_DONE

	calla	BGND_UD1
	SLEEPK	2
	calla	BGND_UD1

	clr	a8				;left meter for player 0
	movk	1,a9				;right meter for player 1
	move	@PSTATUS,a0
	jrz	drone_pointers

	move	@royal_rumble,a14
	jrnz	#rumble_pointers

	cmpi	3,a0
	jreq	meter_pointers_set

	movk	2,a9
	srl	1,a0
	jrz	meter_pointers_set
	movk	1,a9
	movk	2,a8
	jruc	meter_pointers_set

#rumble_pointers
	movk	2,a9
	jruc	meter_pointers_set

drone_pointers
	movk	2,a8
	movk	3,a9
meter_pointers_set
	CREATE	METER_PID,meters		;life/turbo/names

	movk	1,a0
	move	a0,@DISPLAYON

	clr	a0
	move	a0,@IRQSKYE

	.if DEBUG
;FIX THAT DAM ANNOYING START UP DMA GLITCH !!!!!!!
	move	@skip_select,a0
	JRNZ	DONT_OPEN_ANYTHING
	.endif

	CREATE	SET_IMAGES_PID,DO_SET_IMAGES

	PUSHP	A0
	movk	18,a8	;20
	movk	4,a9	;6
	JSRP	OPEN_PROGRESS_SCREEN
;	movi	PU_CHECK_PID,a0
;	calla	IKIL1C
	PULLP	A0

	CALLA	KILL
DONT_OPEN_ANYTHING
	MOVI	DUMRETS,A0
	MOVE	A0,@WHICH_SCREEN,L

	clr	a1
	callr	get_process_ptr
;	clr	a14
;Don't allow meters for the first x seconds of round
	movi	10*60,a14
	move	a14,*a0(DELAY_METER)

	movk	1,a1
	callr	get_process_ptr
;Don't allow meters for the first x seconds of round
	movi	14*60,a14
	move	a14,*a0(DELAY_METER)

	;initialize the bgnd_cntr
	movk	1,a14
	move	a14,@bgnd_cntr

	;initialize annc_rnd_winner_done
	clr	a14
	move	a14,@annc_rnd_winner_done

;	CREATE0	show_options

#loop	calla	check_collisions
	callr	final_confine
	calla	set_images

	;BGND_UD1 every eight ticks.
	move	@bgnd_cntr,a2
	dsjs	a2,#no_bg

	;time to do it - but if there's a AUDIT_UD_PID process going, wait
	; until it dies.  This could lead to a delay of up to three ticks.
	inc	a2		;...so that if we skip, we try next tick.

	;check this flag instead of using the extremely slow EXISTP
	move	@audit_ud_flag,a14
	jrnz	#no_bg
	
	calla	BGND_UD1
	movk	8,a2
#no_bg	move	a2,@bgnd_cntr

	SLEEPK	1

	calla	read_switches

	move	@match_over,a0
	jrz	#not_over

	calla	postgame_audits

	RETP

#not_over

	calla	scroll_world

	move	@round_tickcount,a0
	inc	a0
	move	a0,@round_tickcount

	move	@match_time,a0,L	;10's & 1's
	jrnz	#loop

	.if	DEBUG
	;if we're in fight_debug mode, roll the clock around
	move	@fight_debug,a14
	jrnz	#wraparound
	.endif

	;if we're in attract mode, roll the clock around
	move	@PSTATUS,a14
	jrnz	#norm

#wraparound
	movi	00090009h,a14
	move	a14,@match_time,L
	jruc	#not_over

#norm
	movk	1,a0
	move	a0,@HALT


;Timer on the round expired

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

	calla	DO_CROWD_CHEER

	CREATE	CYCPID,CREATE_TIMEOUT

	movi	55,a9
#wait	SLEEPK	1
	PUSH	a9,a11
	calla	set_images		;Make shadows shift...
	PULL	a9,a11
	dsjs	a9,#wait

	CREATE	ANNC_PID,announce_rnd_winner
	.if DEBUG
	move	a13,*a0(PDATA),L	;#CREATOR (pdata)
	movi	$,a14
	move	a14,*a0(PDATA+20h),L	;#ORIGIN
	.endif

	movk	28,a9
#wait1	SLEEPK	1
	PUSH	a9,a11
	calla	set_images		;Make shadows shift...
	PULL	a9,a11
	dsjs	a9,#wait1

;	move	a11,a0
;	calla	KILL

	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
	calla	obj_del1c		;delete text/plates

#wait2	SLEEPK	1
	calla	set_images		;Make shadows shift...
;	move	@HALT,a0
	movi	ANNC_PID,a0
	clr	a1
	not	a1
	calla	EXISTP
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

;Move match winning players match awards to winning players winstread awards,
;annunciate match awards for winning player, then clear get out

#not_end
	jruc	#loop

**********
;Is this duplicated effort?  Jason, look into this...
 SUBR	DO_SET_IMAGES
	CALLA	set_images
	SLOOP	1,DO_SET_IMAGES

**********

 SUBR	CLEAR_PROCESSES

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

	callr	reset_start

	calla	choose_pal		;sets b0
	clr	a1			;y pos
	movi	D2ST2B03,a2		;* image
	movi	110,a3			;z pos
	movi	DMAWNZ|M_3D,a4		;DMA flags
	move	a4,*a13(OBJ_CONTROL)
	movi	CLSPLYR | TYPPLYR,a5	;object ID
	clr	a6			;x vel
	clr	a7			;y vel

	movk	MAX_PIECES,a9
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
	move	a0,*a13(COMBO_COUNT)
	move	a0,*a13(COMBO_START)
	move	a0,*a13(OUTSIDE_ALONE)
	move	a0,*a13(SPECIAL_MOVE_ADDR),L

	move	a0,*a13(LAST_HIT_TIME),L
	move	a0,*a13(LAST_FLING_ATTEMPT),L
	move	a0,*a13(HIT_GATE_TIME),L
	move	a0,*a13(LAST_HEADHOLD),L
	move	a0,*a13(LAST_FLING),L
	move	a0,*a13(LAST_SPUNCH),L
	move	a0,*a13(LAST_SKICK),L
	move	a0,*a13(CONSECUTIVE_HITS)
	move	a0,*a13(LAST_DAMAGE),L
	move	a0,*a13(DAMAGE_GIVEN)
	movi	8*60,a0
	move	a0,*a13(DELAY_METER)

	move	*a8(OPAL),a0
	move	a0,*a13(OBJ_PAL)
	move	a0,*a13(MY_PAL)

	movi	shadow_p,a0
	calla	pal_getf
	move	*a13(OBJ_BASE),a8,L
	move	*a8,a8,L		;1st object
	move	a0,*a8(OPAL)		;set palette for shadow

	movi	MAT_Y,a0
	move	a0,*a13(GROUND_Y)

	clr	a0
	move	a0,*a13(ATTACK_TIME)
	move	a0,*a13(INRING)
	MOVE	A0,*A13(COMBO_START)
	MOVE	A0,*A13(COMBO_COUNT)

	move	a0,*a13(OBJ_XVEL),L
	move	a0,*a13(OBJ_YVEL),L
	move	a0,*a13(OBJ_ZVEL),L
	move	a0,*a13(SHADTRAIL_PROC),L
	move	a0,*a13(I_WILL_DIE)
	move	a0,*a13(STATUS_FLAGS),L

	move	a0,*a13(BUT_VAL_CUR)
	move	a0,*a13(BUT_VAL_DOWN)
	move	a0,*a13(BUT_VAL_UP)
	move	a0,*a13(STICK_VAL_CUR)
	move	a0,*a13(STICK_VAL_DOWN)
	move	a0,*a13(STICK_VAL_UP)
	move	a0,*a13(STICK_REL_CUR)
	move	a0,*a13(STICK_REL_NEW)


;	calla	clear_damage_log
	callr	ani_init		;start default animation

	move	@PCNT,a14
	move	a14,*a13(FOOT_PCNT),W	;init foot timer

 .if COL_DEBUG
	move	a13,a10
	CREATE	CDEBUG_PID,collis_debug
	move	a13,a10
	CREATE	CDEBUG_PID,collis_debug2
 .endif

	calla	init_smoves
	calla	set_collision_boxes

	.ref	drone_calcskill
	calla	drone_calcskill

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

	calla	ARE_WE_IN_RING

	calla	set_collision_boxes

	callr	confine_wrestler
	callr	confine_wrestler_fix2

	callr	update_newfacing

	callr	update_positions	;used by scroller (temp!)

	move	*a13(PLYR_TYPE),a0
	jrz	#hmn			;Human?
	move	*a13(STATUS_FLAGS),a14
	btst	B_ZOMBIE,a14
	jrnz	#zmb			;Zombie?
	calla	drone_main
#zmb
#hmn

;	TINTOFF
	movk	1,a0
	move	*a13(STATUS_FLAGS),a14
	btst	B_KOD,a14
	jrz	#slp
	movi	>7fff,a0
#slp	SLEEPR	a0
;	TINTON

	MOVE	*A13(RISK),A0
	JRZ	NO_DECREMENT
	DEC	A0
	MOVE	A0,*A13(RISK)

	andi	7fffh,a0
	jrnz	NO_DECREMENT
;Turn off taunt high risk move bonus
	move	a0,*a13(RISK)

NO_DECREMENT

	callr	update_joystat
	callr	count_button_presses

	calla	keep_onscreen

	calla	wrestler_veladd		;<-------
	callr	wrestler_friction	;<-------

	calla	animate_wrestler	;<-------
	calla	set_collision_boxes	;<-------

	callr	confine_wrestler	;<--- temp fix!
	callr	confine_wrestler_fix1

	callr	calc_closest2

	callr	move_wrestler

;---->	calla	wrestler_veladd
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
;This is for disallowing movement by wrestler

	move	*a13(IMMOBILIZE_TIME),a0
	jrz	#skp5
	dec	a0
	move	a0,*a13(IMMOBILIZE_TIME)
#skp5
;This is for walking fast powerup

	move	*a13(WALK_FAST),a0
	jrz	#skp6
	jrn	#skp6
	dec	a0
	move	a0,*a13(WALK_FAST)
#skp6
	move	*a13(GETUP_TIME),a0
	jrz	#loop

	move	@match_time,a14,L
	jrnz	#notend
;Match timer ran out...
	clr	a0
	move	a0,*a13(GETUP_TIME)
	jruc	#loop
#notend
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
;Remember, the wrestler's meter doesn't have to be visible for him
;to still have a getup time set!
;As long as getup_time has a value, he is stuck.

	;get data on this and last ticks
	move	a13,a0
	calla	wres_get_but_val_down
	move	a0,a2
	move	a13,a0
	calla	wres_get_stick_val_down
	or	a2,a0
	move	*a13(STATUS_FLAGS),a1

	move	a1,a14
	andni	M_PRESS_LAST,a14
	TEST	a0
	jrz	#set_flag
	ori	M_PRESS_LAST,a14
#set_flag
	move	a14,*a13(STATUS_FLAGS)

	TEST	a0
	jrnz	#deduct_three
	BTST	B_PRESS_LAST,a1
	jrz	#loop

#deduct_three
	move	*a13(GETUP_TIME),a14
	subk	3,a14
	jrnn	#ok
	clr	a14
#ok
	move	a14,*a13(GETUP_TIME)
	jrp	#loop


#clr_dizzy
	clr	a0
	move	a0,*a13(PLYR_DIZZY)
	move	a0,*a13(STARS_FLAG)	;Gets rid of them...

;Delay button reads
	movi	40,a0
	move	a0,*a13(DELAY_BUTNS)

	jruc	#loop

#*****************************************************************************

 SUBR	reset_for_round

;Reset world and both wrestlers for the start
;of a new round - Called from lifebar.

	PUSH	a13

	clr	a1
#lp0	PUSH	a1
	callr	reset_wrestle
	PULL	a1
	inc	a1
	cmpi	NUM_WRES,a1
	jrlt	#lp0

	PULL	a13

	move	@current_round,a0
	inc	a0
	move	a0,@current_round

	;reset life data
	calla	init_rnd_life_data

	;reset special move processes
	callr	reset_smoves

	;reset match_time
	movk	9,a0
	move	a0,@match_time		;10's
	movk	9,a0
	move	a0,@match_time+10h	;1's
	clr	a0
	move	a0,@match_time+20h	;fractional

	;reset various other crap
	clr	a0
	move	a0,@any_hits

	callr	init_reduce_bog

nobody_home
	rets

#*****************************************************************************

reset_wrestle
	callr	get_process_ptr
	move	a0,a13
	jrz	nobody_home

	calla	drone_change_back

	clr	a0
	move	a0,*a13(PLYR_DIZZY_CNT)
;Don't allow meters for the first x seconds of round
	movi	14*60,a0
	move	a0,*a13(DELAY_METER)

	move	*a13(PLYRNUM),a10

reset_start

	;choose starting position - our index into the #teamX_starts table
	; is the number of teammates with PLYRNUM's lower than ours. (0-2)
	move	*a13(PLYR_SIDE),a0
	movi	process_ptrs,a1
	clr	a2

#loop0	move	*a1+,a14,L
	jrz	#loop0		;skip inactive
	cmp	a13,a14
	jreq	#set0		;hit self -> we're done
	move	*a14(PLYR_SIDE),a14
	cmp	a14,a0
	jrne	#loop0
	inc	a2		;lower PSTATUS, same PLYR_SIDE, so inc index
	jruc	#loop0
	
#set0	;a2 is index.
	X64	a2
	movi	#team1_starts,a9
	TEST	a0		;team == 0?
	jrz	#add
	movi	#team2_starts,a9
#add	add	a2,a9

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
;	move	a0,*a13(BURNOUT_COUNT)
	move	a0,*a13(INRING)

	move	a0,*a13(OBJ_XVEL),L
	move	a0,*a13(OBJ_YVEL),L
	move	a0,*a13(OBJ_ZVEL),L

;	calla	clear_damage_log
	callr	ani_init		;start default animation

	move	@PCNT,a14
	move	a14,*a13(FOOT_PCNT),W	;init foot timer

	rets

	;X,Z,face_dir,unused for team 0
#team1_starts
	.word	RING_X_CENTER-85,1127+93,9,0	;first player on team
	.word	RING_X_CENTER-150,1127+170,9,0	;second
	.word	RING_X_CENTER-20,1127+16,10,0	;third

	;X,Z,face_dir,unused for team 1
#team2_starts
	.word	RING_X_CENTER+85,1103+93,6,0	;first player on team
	.word	RING_X_CENTER+150,1103+170,5,0	;second
	.word	RING_X_CENTER+20,1103+16,6,0	;third


#*****************************************************************************

 SUBR	reset_for_round2

	PUSH	a13

	clr	a14
	move	a14,@annc_rnd_winner_done

;un-canned for NUM_WRES wrestlers

	clr	a1
#lp1	PUSH	a1
	callr	reset_wrestle2
	PULL	a1
	inc	a1
	cmpi	NUM_WRES,a1
	jrlt	#lp1

	PULL	a13
	rets

reset_wrestle2
	callr	get_process_ptr
	move	a0,a13
	jrz	nobody_home

	calla	drone_change_back

	movk	30,a0
	move	a0,*a13(IMMOBILIZE_TIME)

	;Re-initialize these variables between rounds
	clr	a0
	move	a0,*a13(PLYR_DIZZY_CNT)
	move	a0,*a13(GETUP_TIME)
	move	a0,*a13(AUTO_PIN_CNTDOWN)
	move	a0,*a13(SPECIAL_MOVE_ADDR),L
	move	a0,*a13(LAST_HIT_TIME),L
	move	a0,*a13(LAST_FLING_ATTEMPT),L
	move	a0,*a13(HIT_GATE_TIME),L
	move	a0,*a13(LAST_HEADHOLD),L
	move	a0,*a13(LAST_SPUNCH),L
	move	a0,*a13(LAST_SKICK),L
	move	a0,*a13(CONSECUTIVE_HITS)
	move	a0,*a13(LAST_FLING),L
	move	a0,*a13(LAST_HIPTOSS),L
	move	a0,*a13(LAST_DAMAGE),L

	;clear STATUS_FLAGS, except for bits in SF_RESET_MASK,
	; which should be preserved between rounds.
	move	*a13(STATUS_FLAGS),a14,L
	andi	SF_RESET_MASK,a14
	move	a14,*a13(STATUS_FLAGS),L

	;set PTIME to 1, just in case they were KO'd last round.
	movk	1,a14
	move	a14,*a13(PTIME)

	move	*a13(PLYRNUM),a10

reset_start2
	callr	calc_closest
	calla	set_collision_boxes
	callr	confine_wrestler
	callr	update_positions	;used by scroller (temp!)
	callr	update_joystat
	callr	count_button_presses
	calla	wrestler_veladd		;<-------
	callr	wrestler_friction	;<-------
	calla	set_collision_boxes	;<-------
	callr	confine_wrestler	;<--- temp fix!
	callr	calc_closest
	callr	move_wrestler
	callr	ani_init
	callr	update_links
	calla	set_collision_boxes
	calla	overlap_collision

	move	a13,a0
	callr	set_wrestler_xflip
	callr	update_joy_dtime
	calla	drone_calcskill
 
	rets


#*****************************************************************************
*
* wrestler object blocks

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

 SUBR	ani_init


	movi	100h,a0
	move	a0,*a13(ANI_SPEED)	;normal speed animations

	clr	a0
	move	a0,*a13(I_WILL_DIE)
	.ref	hyper_speed_on

	move	@hyper_speed_on,a14
	move	a14,*a13(WALK_FAST)
;	move	a0,*a13(WALK_FAST)

	move	a0,*a13(ATTIMG_CUR_FRAME),L

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

;old version - used by PROGRESS.ASM

 SUBR	set_process_ptr

 	PUSH	a1
	X32	a1
	addi	process_ptrs,a1
	move	a13,*a1,L
	PULL	a1
	rets

#*****************************************************************************
* a0 = ptr to process
* a9 = side (0 or 1)
* a10 = player/drone number 0-?
* a11 = WRESTLERNUM

;new version - used here in WRESTLE.ASM because the new pal selector routine
; requires that process_ptrs are all set up before any of the wrestler
; processes actually wake up.  set_process_ptr2 is called by the code that
; creates wrestler_main procs, not by wrestler_main itself.

;it also sets PLYRNUM and WRESTLERNUM, 'cuz the pal thing needs those
; too.  What a pain, eh? (And now PLYR_SIDE, too)

 SUBRP	set_process_ptr2

 	PUSH	a10
	X32	a10
	addi	process_ptrs,a10
	move	a0,*a10,L
	PULL	a10

	move	a9,*a0(PLYR_SIDE)
	move	a10,*a0(PLYRNUM)
	move	a11,*a0(WRESTLERNUM)

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
#exit	rets

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

#right	movi	MOVE_DOWN,a1
	move	*a13(OBJ_ZPOS),a2,L
	move	*a10(OBJ_ZPOS),a3,L
	cmp	a2,a3		;a3-a2
	jrgt	#down
	movi	MOVE_UP,a1

#down	or	a1,a0
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

#right	move	*a0(OBJ_CONTROL),a14
	andni	M_FLIPH,a14
	move	a14,*a0(OBJ_CONTROL)

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

#no_u	;just inside - don't adjust, but don't go any further.
	ori	MOVE_UP,a7		;can't move up
	jruc	#check_x

#zu_ok	;Check aginst bottom ropes
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

#no_d	;just inside - don't adjust, but don't go any further.
	ori	MOVE_DOWN,a7		;can't move down
	jruc	#check_x

#zd_ok	;no z problems.  zero Z_BOUND
	clr	a14
	move	a14,*a13(Z_BOUND)

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
	;Wait!  Don't muck with the Y vels if they're already above 30000h.
	move	*a13(OBJ_YVEL),a14,L
	cmpi	30000h,a14
	jrgt	#nyv1
	move	*a5(OBJ_YVEL),a14,L
	cmpi	30000h,a14
	jrgt	#nyv1
	movi	[3,0],a14
	move	a14,*a13(OBJ_YVEL),L
	move	a14,*a5(OBJ_YVEL),L

#nyv1	;...and wobble the ropes
	PUSH	a0,a5
	movi	ROPE_LEFT,a0
	movk	1,a2
	movi	ROPE_BOUNCEIO,a1
	calla	rope_command

	movi	3ch,a0
	calla	triple_sound

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

	movi	3ch,a0
	calla	triple_sound

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
	;Wait!  Don't muck with the Y vels if they're already above 30000h.
	move	*a13(OBJ_YVEL),a14,L
	cmpi	30000h,a14
	jrgt	#nyv2
	move	*a5(OBJ_YVEL),a14,L
	cmpi	30000h,a14
	jrgt	#nyv2
	movi	[3,0],a14
	move	a14,*a13(OBJ_YVEL),L
	move	a14,*a5(OBJ_YVEL),L
#nyv2
	;...and wobble the ropes
	PUSH	a0,a5
	movi	ROPE_RIGHT,a0
	movk	1,a2
	movi	ROPE_BOUNCEIO,a1
	calla	rope_command

	movi	3ch,a0
	calla	triple_sound

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

	movi	3ch,a0
	calla	triple_sound

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
	;we need to move a8 pixels to the left.  if we're attached, move both
	; of us.
	sub	a8,a5
	move	a5,*a13(X_BOUND)
	sll	16,a5
	move	a5,*a13(OBJ_XPOS),L
	ori	MOVE_RIGHT,a7		;can't move right

	move	*a13(ATTACH_PROC),a0,L
	jrz	#no_r3_att
	move	*a0(OBJ_XPOSINT),a14
	sub	a8,a14
	move	a14,*a0(OBJ_XPOSINT)
#no_r3_att

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
	;we need to move a8 pixels to the right. if we're attached, move both
	; of us.
	add	a8,a5
	move	a5,*a13(X_BOUND)
	sll	16,a5
	move	a5,*a13(OBJ_XPOS),L
	ori	MOVE_LEFT,a7		;can't move down

	move	*a13(ATTACH_PROC),a0,L
	jrz	#no_l3_att
	move	*a0(OBJ_XPOSINT),a14
	add	a8,a14
	move	a14,*a0(OBJ_XPOSINT)
#no_l3_att

	calla	ck_climb_in_side

#done2
	move	a7,*a13(CAN_MOVE_DIR)
	move	*a13(PLYRMODE),a0
	cmpi	MODE_DEAD,a0
	jreq	#dead
	cmpi	MODE_RUNNING,a0
	jrne	just_ignore_me

	movi	[3,0],a2
	btst	MOVE_LEFT_BIT,a7
	jrnz	we_going_left
	neg	a2
	btst	MOVE_RIGHT_BIT,a7
	jrz	just_ignore_me
we_going_left

	;we've hit a gate, and we're running.  It's possible, however, that
	; we're right up against a gate and have just started running in the
	; opposite direction, in which case we shouldn't crash or anything.
	; blow this off if we're running AWAY from the gate we've hit
	move	*a13(CAN_MOVE_DIR),a0
	move	*a13(FACING_DIR),a14
	and	a14,a0
	andi	MOVE_LEFT|MOVE_RIGHT,a0
	jrz	just_ignore_me

	move	a2,*a13(OBJ_XVEL),L
	SETMODE	NORMAL
	movi	[3,0],a0
	move	a0,*a13(OBJ_YVEL),L
	clr	a0
	move	a0,*a13(RUN_TIME)

	;if we've hit the gate in the last three seconds, fall back instead.
	move	@PCNT,a14,L
	move	*a13(HIT_GATE_TIME),a0,L
	sub	a0,a14
	cmpi	TSEC*3,a14
	jrge	#bnc
	FACETBL fall_back_tbl
	jruc	#bcanim

#bnc	FACE24TBL bncoff_gate
#bcanim	calla	change_anim1a

	;crash sound
	movi	0c5h,a0
	calla	triple_sound

	;set HIT_GATE_TIME
	move	@PCNT,a14,L
	move	a14,*a13(HIT_GATE_TIME),L

	;take some damage
	move	*a13(PLYRNUM),a1
	movi	-D_GATE_CRASH,a0
	clr	a10
	calla	adjust_health

	calla	ditch_getup_meter

just_ignore_me
	rets

#dead	;if we're a zombie, hitting the edge is our cue to transform
	andi	MOVE_LEFT|MOVE_RIGHT,a7
	jrz	just_ignore_me
	move	*a13(STATUS_FLAGS),a14
	btst	B_ZOMBIE,a14
	jrz	just_ignore_me
	btst	B_CAN_XFORM,a14
	jrz	just_ignore_me

#zombie_transform
	movk	1,a0
	calla	change_wrestler
	rets

#*****************************************************************************
*
* for whatever reason, confine_wrestler happens twice per tick.  The problem
* is that if you bump into the ropes, the first time we execute c_w, your
* CAN_MOVE_DIR bits are set.  But the second time, they're cleared since you
* aren't hitting the ropes anymore.  This ugly little hack gets around this
* by saving your CAN_MOVE_DIR bits after the first call, and then ORing them
* with your CAN_MOVE_DIR bits after the second.

 SUBRP	confine_wrestler_fix1

	move	*a13(CAN_MOVE_DIR),*a13(CAN_MOVE_TEMP)
	rets

 SUBRP	confine_wrestler_fix2
	move	*a13(CAN_MOVE_DIR),a0
	move	*a13(CAN_MOVE_TEMP),a1
	or	a0,a1
	move	a1,*a13(CAN_MOVE_DIR)
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
	jrnz	#rets

	;check to see if a special move watchdog proc has queued up an anim.
	; If one has, do that instead of calling move_xxx.
	move	*a13(SPECIAL_MOVE_ADDR),a0,L
	jrz	#no_special

	;a special has been queued up.  do it.
	calla	change_anim1a
	clr	a14
	move	a14,*a13(SPECIAL_MOVE_ADDR),L
	jruc	#rets

#no_special

	;turn into a drone if it's time to auto-pin.
	callr	auto_pin_check

	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	#code_addr,a0
	move	*a0,a0,L
	call	a0

#rets	rets

#code_addr
	.long	move_bret	;0 Bret Hart
	.long	move_razor	;1 Razor Ramon
	.long	move_taker	;2 Undertaker
	.long	move_yoko	;3 Yokozuna
	.long	move_shawn	;4 Shawn Michaels
	.long	move_bam	;5 Bam Bam
	.long	move_doink	;6 Doink
	.long	0		;7 spare
	.long	move_lex	;8 Lex Luger


#*****************************************************************************
*
* if all opponents are dead, wait four seconds, then wait for the
* unint bit to clear, then turn into a drone.
*

 SUBR	auto_pin_check
	move	@in_finish_move,a14	; Are we in a finishing move ?
	jrnz	#rets			; br = yes
	move	@finish_completed,a14	; Did we do a finishing move ?
	jrnz	#rets			; br = yes

	move	@royal_rumble,a14
	jrnz	#rets

	calla	get_opp_plyrmode
	cmpi	MODE_DEAD,a0
	jrne	#alive

	;skip it if we've already pinned
	move	*a13(STATUS_FLAGS),a14
	btst	B_DID_PIN,a14
	jrnz	#rets

	callr	get_opp_process
	move	*a0(STATUS_FLAGS),a14
	btst	B_ZOMBIE,a14
	jrnz	#alive

	.ref	anyone_bucking
	calla	anyone_bucking
	jrnz	#rets

	;all opponents are dead.  increment AUTO_PIN_CNTDOWN and turn into
	; a drone if the total is >= TSEC*4.
	move	*a13(AUTO_PIN_CNTDOWN),a14
	inc	a14
	move	a14,*a13(AUTO_PIN_CNTDOWN)
	cmpi	TSEC*3,a14
	jrlt	#rets

	move	*a13(ANIMODE),a14
	btst	MODE_UNINT_BIT,a14
	jrnz	#rets

	;become a drone
	movi	PTYPE_DRONE,a14
	move	a14,*a13(PLYR_TYPE)
	jruc	#rets

#alive	;Reset AUTO_PIN_CNTDOWN
	clr	a14
	move	a14,*a13(AUTO_PIN_CNTDOWN)
#rets	rets

#*****************************************************************************

; SUBRP	realtime_clock
;
;	clr	a8
;	move	a8,@match_realtime
;
;#loop	SLEEP	TSEC
;	inc	a8
;	move	a8,@match_realtime
;	jruc	#loop

******************************************************************************

						;!KEEP THIS ORDER!
	BSSX	up_dtime1,	16*NUM_WRES	;number of ticks stick held down
	BSSX	down_dtime1,	16*NUM_WRES
	BSSX	left_dtime1,	16*NUM_WRES
	BSSX	right_dtime1,	16*NUM_WRES
	BSSX	punch_dtime1,	16*NUM_WRES
	BSSX	block_dtime1,	16*NUM_WRES	;number of ticks button held down
	BSSX	powerp_dtime1,	16*NUM_WRES
	BSSX	kick_dtime1,	16*NUM_WRES
	BSSX	powerk_dtime1,	16*NUM_WRES

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
;	move	a13,a0
;	calla	wres_get_stick_val_cur
	move	*a13(STICK_VAL_CUR),a0
	X16	a2
	addi	up_dtime1,a2

	movk	4,a3
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
	move	*a13(BUT_VAL_CUR),a0
	X16	a2
	addi	punch_dtime1,a2

	movk	5,a3
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
*
* Well, not really the closest.  We bias it lots of ways:
*
* ---> Will always choose live targets over dead ones.
* ---> Will always choose normal dead over zombies.
* ---> Biased distance (used for comparison but never stored) is doubled
*      for targets in MODE_ONGROUND.
* ---> 25% reduction in biased distance for WHOIHIT
* ---> Biased distance tripled for targets with different INRING values.
* ---> Add double the Z difference to biased range (favors targets in
*      your Z-lane.
* ---> 25% reduction in biased distance for previous closest
* ---> Will always pick live targets in front of a runner over targets behind
*      him, IF they have the same INRING value.
* ---> If in combo mode, will always face WHOIHIT, unless WHOIHIT is dead.
*


	;biased distance to current champ.
	.bss	#biased_range,16

; first calculate the distance on the X-Z plane
;  dxz = sqroot ( (x1-x2)^2 + (z1-z2)^2 )
; total dist = sqroot ( DXZ^2 + (y1-y2)^2 )


 SUBRP	calc_closest2

	;Always recalculate if our current closest is dead.
	move	*a13(CLOSEST_NUM),a14
	X32	a14
	addi	process_ptrs,a14
	move	*a14,a14,L
	move	*a14(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#go

	;Only proceed on every fourth tick.
	move	*a13(PLYRNUM),a0
	andi	3,a0
	move	@PCNT,a1
	andi	3,a1
	cmp	a0,a1
	jrnz	#x


 SUBRP	calc_closest

	;a11 is a flag.  when set, this indicates that a live player
	; is the current closest.  Any live player will be chosen over
	; a dead one.
	;a11 is the status of the closest guy.  a positive value means the
	; current closest is alive.  Zero means he's dead, and a negative
	; value means there isn't one or it's a zombie.

#go	move	*a13(PLYR_TYPE),a0

	move	*a13(OBJ_XPOSINT),a4
	move	*a13(OBJ_ZPOSINT),a5
	move	*a13(OBJ_YPOSINT),a6

	movi	7FFFh,a3		;closest distance
	move	a3,@#biased_range
	clr	a11
	dec	a11			;initialize to none/zombie
	movi	process_ptrs,a2
	movi	NUM_WRES,a1

#loop	move	*a2+,a10,L
	jrz	#inactive
	cmp	a13,a10
	jreq	#skip_nopull		;skip self

	move	*a13(PLYR_SIDE),a7
	move	*a10(PLYR_SIDE),a8
	cmp	a7,a8
	jreq	#skip_nopull		;skip friendly

	PUSH	a4,a6
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

	;a0 is dist.  compute biased dist in a4
	move	a0,a4

	;ONGROUND penalty
	move	*a10(PLYRMODE),a14
	cmpi	MODE_ONGROUND,a14
	jrne	#bc1
	sll	1,a4		;double it

#bc1	;WHOIHIT bonus
	move	*a13(WHOIHIT),a14,L
	cmp	a14,a10
	jrne	#bc2
	move	a4,a14
	srl	2,a14
	sub	a14,a4		;sub 25%

#bc2	;INRING penalty
	move	*a10(INRING),a14
	move	*a13(INRING),a6
	cmp	a6,a14
	jreq	#bc3
	move	a4,a14
	sll	1,a4
	add	a14,a4		;triple it

#bc3	;previous closest bonus
	move	*a13(CLOSEST_NUM),a14
	move	*a10(PLYRNUM),a6
	cmp	a14,a6
	jrne	#bc4
	move	a4,a14
	srl	2,a14
	sub	a14,a4		;sub 25%

#bc4	;zero biased dist to combo target
	move	*a13(COMBO_COUNT),a14
	jrz	#bc5
	move	*a13(WHOIHIT),a14,L
	cmp	a14,a10
	jrne	#bc5
	clr	a4		;zero dist

#bc5	;Z penalty
	move	a8,a14		;delta Z
	sll	1,a14
	add	a14,a4		;add double the Z dist


	;skip this guy if:
	; a) we're running,
	; b) he's behind us,
	; c) our current closest is ahead of us, and
	; d) our current closest is inside the ring.

	;we running?
	move	*a13(PLYRMODE),a14
	cmpi	MODE_RUNNING,a14
	jrne	#ab_ok

	;have a useful current closest?
	TEST	a11
	jrn	#ab_ok

	;is this guy behind us?
	move	a10,a14
	calla	is_a14_behind
	jrnc	#ab_ok

	;is closest ahead of us?
	move	*a13(CLOSEST_NUM),a14
	X32	a14
	addi	process_ptrs,a14
	move	*a14,a14,L
	calla	is_a14_behind
	jrc	#ab_ok

	;is closest inside the ring?
	move	*a13(CLOSEST_NUM),a14
	X32	a14
	addi	process_ptrs,a14
	move	*a14,a14,L
	move	*a14(INRING),a14
	jrnz	#ab_ok

	;we're running, this guy is behind us, and our current closest is
	; both inside the ring and ahead of us.  Ignore this guy.
	jruc	#skip

#ab_ok	;ahead/behind ok.

	;three cases.  zombie, dead, or alive.
	move	*a10(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jrne	#alive
	move	*a10(STATUS_FLAGS),a14
	btst	B_ZOMBIE,a14
	jrz	#dead
	;fall through to zombie

#zombie	;Only test this guy if a11 is negative.
	TEST	a11
	jrnn	#skip
	jruc	#compare

#dead	;If a11 is negative, take this guy.  If it's zero, compare
	TEST	a11
	jrz	#compare
	jrnn	#skip
	clr	a11		;set a11 to dead
	jruc	#accept

#alive	;If a11 is positive, compare, otherwise just take him.
	TEST	a11
	jrp	#compare
	movk	1,a11		;set a11 to alive
	jruc	#accept

#compare
	move	@#biased_range,a14
	cmp	a14,a4
	jrle	#accept

	;too far.
	jruc	#skip

#accept	;use the guy in a10

	move	a4,@#biased_range
	move	a0,a3
	move	a3,*a13(CLOSEST_DIST)
	move	a7,*a13(CLOSEST_XDIST)
	move	a8,*a13(CLOSEST_ZDIST)
	move	a9,*a13(CLOSEST_YDIST)

	move	*a10(PLYRNUM),a14
	move	a14,*a13(CLOSEST_NUM)

#skip
	PULL	a4,a6
#inactive
#skip_nopull
	dsj	a1,#loop

#x	rets

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
*
* count active wrestler processes.  Clear reduce_bog if there's two, set if
* there's more

 SUBR	init_reduce_bog

	movi	process_ptrs,a0
	movi	NUM_WRES,a1
	clr	a2
#lp	move	*a0+,a14,L
	jrz	#nxt
	inc	a2			;got one.
#nxt	dsj	a1,#lp

	;a2 is active wrestlers.  sub 2 and stick it in reduce_bog
	subk	2,a2
	move	a2,@reduce_bog
	rets

#*****************************************************************************

 SUBRP	update_joystat

	move	@HALT,a0
	jrnz	#exit

;	move	a13,a0
;	calla	wres_get_stick_val_cur
	move	*a13(STICK_VAL_CUR),a0
	movk	1100b,a8		;mask out left & right
	and	a0,a8
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
	calla	wres_get_stick_val_up
	move	a0,a4
	move	a13,a0
	calla	wres_get_stick_val_down
	or	a4,a0
	jrz	#no_stick

	move	a8,a4			;cur (flipped) stick vals
	jrz	#no_stick

	callr	#insert

#no_stick

	move	a13,a0
	calla	wres_get_but_val_down
	move	a0,a6
	jrz	#no_button
	X16	a6

	movk	5,a5			;5 button bits
	movk	10000b,a7		;1st bit << 4 (to skip 4 joy bits)
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

	move	*a13(PLYRNUM),a0
	sll	5+4,a0				;PLYRNUM x32 x16

	addi	wrest_joystat + 32*15,a0	;2nd last entry (after pre-dec)
	move	a0,a1
	addk	32,a1				;last entry (after pre-dec)

	movk	15,a2				;# entries - 1
#move_loop
	move	-*a0,-*a1,L			;move each entry down
	dsj	a2,#move_loop			;1 position

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
	calla	wres_get_but_val_down
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

	CREATE	0,direction_test		;temp!!!!!!!!!!!

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
	movk	20,a3			;z pos
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

	move	*a13(IMMOBILIZE_TIME),a14
	jrnz	#done

	move	*a13(PLYRMODE),a14
	cmpi	MODE_DIZZY,a14
	jreq	#done
	cmpi	MODE_WAITANIM,a14
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
	.align
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
	;skip it if we're a zombie
	move	*a13(STATUS_FLAGS),a14
	btst	B_ZOMBIE,a14
	jrnz	#done

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

	clr	a0
	move	a0,*a13(CONSECUTIVE_HITS)
;Fix walking speeds!
;Did I do a taunt to achieve high risk move bonus?
	move	*a13(RISK),a14
	btst	15,a14
	jrnz	#taunted
	clr	a0
	move	a0,*A13(RISK)
#taunted
	move	*a13(WALK_FAST),a0
	jrnz	#fast

	callr	get_opp_process
	move	*a0(PLYRMODE),a0	;don't slow down if backing
	cmpi	MODE_ONGROUND,a0	;away from a downed opponent
	jrnz	#notgrnd
#fast
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

#rets	rets


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
	MOVI	60,A0
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

 SUBR	execute_walk

	;Do a step sound every 32 ticks if we're walking. (whether or not
	; INTURN bit is set)
	move	*a13(MOVE_DIR),a0
	JRZ	NO_SOUND_CALL
	MOVE	@PCNT,A0
	ANDI	31,A0
	JRNZ	NO_SOUND_CALL
	CALLA	WALK_SOUND
NO_SOUND_CALL

	;if our INTURN bit is set, we're doing a turn and we shouldn't do
	; anything here -- treat it like UNINT.

	move	*a13(ANIMODE),a14
	btst	MODE_INTURN_BIT,a14
	jrnz	#inturn

	move	*a13(ANIMODE2),a14
	btst	MODE_INTURN_BIT,a14
	jrnz	#inturn

	clr	a0
	move	a0,*a13(ATTACK_TYPE)

	move	*a13(MOVE_DIR),a0

	X32	a0
	addi	#walk_table,a0
	move	*a0,a0,L
	call	a0

#rets	rets

#inturn	move	*a13(MOVE_DIR),a0
	jrnz	#rets

	;stick at rest - clear any velocity we might have lying around
	move	a0,*a13(OBJ_XVEL),L
	move	a0,*a13(OBJ_ZVEL),L

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


;All these routines set MOVE_DIR.  However, the above code chooses the
; routine to execute based on MOVE_DIR, so they just end up stuffing the
; same value that's already there.  Wuzzup wit' that? - JS

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

	movk	MOVE_UP,a0
	move	a0,*a13(MOVE_DIR)

	callr	set_velocities
	callr	change_walk_anim

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

	movk	MOVE_UP_RIGHT,a0
	move	a0,*a13(MOVE_DIR)

	callr	set_velocities
	callr	change_walk_anim
	rets


************
#right		;(#3)

	move	*a13(OBJ_CONTROL),a0
	andni	M_FLIPH,a0
	move	a0,*a13(OBJ_CONTROL)

	movk	MOVE_RIGHT,a0
	move	a0,*a13(MOVE_DIR)

	callr	set_velocities
	callr	change_walk_anim
	rets


************
#down_right	;(#4)

	move	*a13(OBJ_CONTROL),a0
	andni	M_FLIPH,a0
	move	a0,*a13(OBJ_CONTROL)

	move	*a13(CAN_MOVE_DIR),a0
	btst	MOVE_DOWN_BIT,a0
	jrnz	#right

	movk	MOVE_DOWN_RIGHT,a0
	move	a0,*a13(MOVE_DIR)

	callr	set_velocities
	callr	change_walk_anim
	rets


************
#down		;(#5)

	movk	MOVE_DOWN,a0
	move	a0,*a13(MOVE_DIR)

	callr	set_velocities
	callr	change_walk_anim
	rets


************
#down_left	;(#6)

	move	*a13(OBJ_CONTROL),a0
	ori	M_FLIPH,a0
	move	a0,*a13(OBJ_CONTROL)

	move	*a13(CAN_MOVE_DIR),a0
	btst	MOVE_DOWN_BIT,a0
	jrnz	#left

	movk	MOVE_DOWN_LEFT,a0
	move	a0,*a13(MOVE_DIR)

	callr	set_velocities
	callr	change_walk_anim
	rets


************
#left		;(#7)

	move	*a13(OBJ_CONTROL),a0
	ori	M_FLIPH,a0
	move	a0,*a13(OBJ_CONTROL)

	movk	MOVE_LEFT,a0
	move	a0,*a13(MOVE_DIR)

	callr	set_velocities
	callr	change_walk_anim
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

	movk	MOVE_UP_LEFT,a0
	move	a0,*a13(MOVE_DIR)

	callr	set_velocities
	callr	change_walk_anim
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

	move	*a13(WALK_FAST),a0
	jrnz	#ongrnd

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


;#*****************************************************************************
;*
;* RETURNS:	a0 = boundary
;*
; SUBRP	check_move_up
;
;	move	*a13(INRING),a0
;	jrnz	#outring
;
;	movi	RING_TOP,a0
;	move	*a13(OBJ_ZPOSINT),a1
;	cmp	a0,a1
;	jrle	#fail
;	clrc
;	rets
;
;#outring
;	movi	ARENA_TOP,a0
;	move	*a13(OBJ_ZPOSINT),a1
;	cmp	a0,a1
;	jrle	#fail
;
;	movi	box_matedge2,a10
;	callr	get_box_overlap
;	move	a1,a1			;z overlap
;	jrp	#fail2
;
;	clrc
;	rets
;
;#fail2
;	move	*a13(OBJ_ZPOSINT),a0
;	dec	a1
;	add	a1,a0
;
;#fail
;	setc
;	rets
;
;#*****************************************************************************
;*
;* RETURNS:	a0 = boundary
;*
; SUBRP	check_move_down
;
;	move	*a13(INRING),a0
;	jrnz	#outring
;
;	movi	RING_BOT,a0
;	move	*a13(OBJ_ZPOSINT),a1
;	cmp	a0,a1
;	jrge	#fail
;	clrc
;	rets
;
;#outring
;	movi	ARENA_BOT,a0
;	move	*a13(OBJ_ZPOSINT),a1
;	cmp	a0,a1
;	jrge	#fail
;
;	movi	box_matedge2,a10
;	callr	get_box_overlap
;	move	a1,a1			;z overlap
;	jrn	#fail2
;
;	clrc
;	rets
;
;#fail2
;	move	*a13(OBJ_ZPOSINT),a0
;	inc	a1
;	add	a1,a0
;#fail
;	setc
;	rets
;
;#*****************************************************************************
;*
;* RETURNS:	a0 = boundary
;*
; SUBRP	check_move_left
;
;	move	*a13(INRING),a0
;	jrnz	#outring
;
;	move	*a13(OBJ_XPOSINT),a5
;	movi	vln_left_rope,a6
;	move	*a6,a0			;x1
;	cmp	a0,a5			;xpos - x1
;	jrge	#ok
;	callr	calc_line_x
;	cmp	a0,a5			;xpos - a0
;	jrle	#fail
;#ok
;	clrc
;	rets
;
;#outring
;	move	*a13(OBJ_XPOSINT),a5
;	movi	vln_left_fence,a6
;	move	*a6,a0			;x1
;	cmp	a0,a5			;xpos - x1
;	jrge	#ok2
;	callr	calc_line_x
;	jrz	#outrange
;	cmp	a0,a5			;xpos - a0
;	jrle	#fail
;#outrange
;#ok2
;	movi	box_matedge2,a10
;	callr	get_box_overlap
;	move	a0,a0			;x overlap
;	jrp	#fail2
;
;	clrc
;	rets
;
;#fail2
;	move	*a13(OBJ_XPOSINT),a1
;	dec	a0
;	add	a1,a0
;#fail
;	setc
;	rets
;
;#*****************************************************************************
;*
;* RETURNS:	a0 = boundary
;*
; SUBRP	check_move_right
;
;	move	*a13(INRING),a0
;	jrnz	#outring
;
;	move	*a13(OBJ_XPOSINT),a5
;	movi	vln_right_rope,a6
;	move	*a6,a0			;x1
;	cmp	a0,a5			;xpos - x1
;	jrle	#ok
;	callr	calc_line_x
;	cmp	a0,a5			;xpos - a0
;	jrge	#fail
;#ok
;	clrc
;	rets
;
;#outring
;	move	*a13(OBJ_XPOSINT),a5
;	movi	vln_right_fence,a6
;	move	*a6,a0			;x1
;	cmp	a0,a5			;xpos - x1
;	jrle	#ok2
;	callr	calc_line_x
;	jrz	#outrange
;	cmp	a0,a5			;xpos - a0
;	jrge	#fail
;#ok2
;#outrange
;	movi	box_matedge2,a10
;	callr	get_box_overlap
;	move	a0,a0			;x overlap
;	jrn	#fail2
;
;	clrc
;	rets
;
;#fail2
;	move	*a13(OBJ_XPOSINT),a1
;	inc	a0
;	add	a1,a0
;#fail
;	setc
;	rets

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

 SUBR    set_up_line_tables
	movi	vln_right_rope_r,a1
	movi	vln_right_rope,a0
	callr	setup_each_right_table
	movi	vln_left_rope_r,a1
	movi	vln_left_rope,a0
	callr	setup_each_left_table
	movi	vln_right_matedge_r,a1
	movi	vln_right_matedge,a0
	callr	setup_each_right_table
	movi	vln_left_matedge_r,a1
	movi	vln_left_matedge,a0
	callr	setup_each_left_table
	movi	vln_right_matedge2_r,a1
	movi	vln_right_matedge2,a0
	callr	setup_each_right_table
	movi	vln_left_matedge2_r,a1
	movi	vln_left_matedge2,a0
	callr	setup_each_left_table
	movi	vln_right_fence_r,a1
	movi	vln_right_fence,a0
	callr	setup_each_right_table
	movi	vln_left_fence_r,a1
	movi	vln_left_fence,a0

setup_each_left_table
	move	*a1(0),*a0+,L
	move	*a1(020h),*a0+,L
	move	*a1(040h),a2
	inc	a2
	move	*a1(050h),a3
	move	*a1(0h),a4
	sll	16,a4
	move	a2,a7
	sll	16,a3
	divs	a7,a3
#write_next_val_l
	sub	a3,a4
	move	a4,a6
	srl	16,a6
	move	a6,*a0+
	dsjs	a2,#write_next_val_l

	rets

setup_each_right_table
	move	*a1(0),*a0+,L
	move	*a1(020h),*a0+,L
	move	*a1(040h),a2
	inc	a2
	move	*a1(050h),a3
	move	*a1(0h),a4
	sll	16,a3
	sll	16,a4
	move	a2,a7
	divs	a7,a3
#write_next_val
	add	a3,a4
	move	a4,a6
	srl	16,a6
	move	a6,*a0+
	dsjs	a2,#write_next_val

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
	movk	ROPE_RIGHT,a2
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;a1-a0
	jrge	#wobble
	jruc	#exit

#lft
	movi	vln_left_rope,a6
	callr	calc_line_x
	movk	ROPE_LEFT,a2
	move	*a13(OBJ_XPOSINT),a1
	cmp	a0,a1			;a1-a0
	jrle	#wobble
	jruc	#exit

#wobble

;Wrestler has been knocked back into ropes
;Wobble them!
	move	a2,a0
	movk	1,a2
	movk	ROPE_BOUNCEIO,a1
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
	addi	mv_tbl,a0
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
	addi	mv_tbl,a0
	move	*a0,a0,L
	btst	a0,a1
	jrnz	#novel2

;Will allow button press
	clrc
	rets

#novel2	setc
	rets

mv_tbl	.long	0,0,0,0,0,MOVE_RIGHT_BIT,MOVE_RIGHT_BIT
	.long	0,0,MOVE_LEFT_BIT,MOVE_LEFT_BIT

#*****************************************************************************
* 
* If player is moving away from opponent, or standing still, tell the 
* calling routine to ignore button press
*

 SUBR	ck_ignore_a8

;Is wrestler going away from opponent?

	move	*a8(MOVE_DIR),a1
	move	*a8(NEW_FACING_DIR),a0	;Current facing dir (9,10,6,5 only)
	sll	5,a0
	addi	mv_tbl,a0
	move	*a0,a0,L
	btst	a0,a1
	jrnz	#novel2

;Will allow button press
	clrc
	rets

#novel2	setc
	rets


#*****************************************************************************
* 
* When we want all ropes to wobble (Butt drops, etc.)
* This routine is used by all wrestlers.

 SUBR	shake_all_ropes

;	move	@NUM_OPPS,A1
;	CMPI	2,A1
;	JRGE	NO_SHAKING

	movi	ROPE_BOUNCEUD,a1
	movk	2,a2

	movi	ROPE_FRONT,a0
	calla	rope_command

	movk	ROPE_BACK,a0
	calla	rope_command

	movk	ROPE_LEFT,a0
	calla	rope_command

	movk	ROPE_RIGHT,a0
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

	movk	MOVE_RIGHT,a0
	move	*a13(OBJ_XPOS),a2,L
	move	*a10(OBJ_XPOS),a3,L
	cmp	a2,a3		;a3-a2
	jrgt	#right
	movk	MOVE_LEFT,a0
#right
	movk	MOVE_DOWN,a1
	move	*a13(OBJ_ZPOS),a2,L
	move	*a10(OBJ_ZPOS),a3,L
	cmp	a2,a3		;a3-a2
	jrgt	#down
	movk	MOVE_UP,a1
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
*
* Resets all special move processes by writing their SM_RESET_ADDRESSes
* to their PWAKEs, and setting their PTIMEs to 1.

 SUBR	reset_smoves

	movi	ACTIVE,a0
	movk	1,a1
#lp0	move	*a0,a0,L
	jrz	#done
	move	*a0(PROCID),a14
	cmpi	SMOVE_PID,a14
	jrne	#lp0

	move	*a0(SM_RESET_ADDRESS),*a0(PWAKE),L
	move	a1,*a0(PTIME)
	jruc	#lp0

#done	rets

#*****************************************************************************
*
* This is a final pass at confining the wrestlers and it's just about the
* last thing that happens every frame, certain to run after both wrestler
* processes.  It calls confine_wrestler once for each attached wrestler.
*

 SUBRP	final_confine

	movi	NUM_WRES,a1
	movi	process_ptrs,a2
	PUSH	a13
#loop
	move	*a2+,a13,L
	jrz	#inactive

	move	*a13(ATTACH_PROC),a0,L
	jrz	#no_attach

	PUSH	a1,a2
	calla	set_collision_boxes
	calla	confine_wrestler
	PULL	a1,a2

#no_attach
#inactive
	dsj	a1,#loop

	PULL	a13
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

 SUBR	collis_debug


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

	movk	16,a0
	move	a0,*a8(OSIZEX)
	move	a0,*a8(OSIZEY)

	jruc	#loop


#on
	movk	30,a0
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

	movk	16,a0
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
*
* Initializes the scroller position

 SUBR	init_scroller

	movi	[RING_X_CENTER-200,0],a0
	move	a0,@WORLDTLX,L

	;use [ffe5,0] in 1v1 or 1v3, [ffe9,0] for 1v2
	movi	[0ffe5h,0],a0
	move	@NUM_OPPS,a14
	cmpi	2,a14
	jrne	#sety
	movi	[0ffe9h,0],a0
#sety	move	a0,@WORLDTLY,L

	rets

******************************************************************************

	.end
