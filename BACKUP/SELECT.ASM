**************************************************************
*
* Software:	Jason Skiles
* Initiated:	1066, shortly after the Battle of Hastings
*
* COPYRIGHT (C) 1993 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 11/22/93 14:24
**************************************************************

	.file	"select.asm"
	.title	"wrestling selection screens"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"		;Mproc equates
	.include	"display.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"sys.equ"
	.include	"game.equ"
	.include	"audit.equ"
	.include	"macros.h"
	.include	"link.equ"
	.include	"sound.h"
	.include	"plyr.equ"

	.include	"fontsimg.glo"
	.include	"bgndtbl.glo"
	.include	"imgtbl.glo"
	.include	"miscimg.glo"
	.include	"ropeimg.glo"

#*****************************************************************************

	.DEF	GAME_BEATEN
	.REF	DO_BEATEN_GAME
	.DEF	THIS_GAME_IS_BEATEN

	.def	howard_wins,digits_tbl,calc_match_time_1
	.def	num_wrestlers,pin_speed_in_case,wrestler_mugs
	.def	wrestler_attributes,attbars,wrestler_mugs2,wrestler_audits

	.ref	ADD_VOICE,BAKMODS,BCDBIN,BEGINOBJ_TBL,BGND_UD1
	.ref	BINBCD,change_image,CHECK_SCORE,civanic
	.ref	CLOSE_PROGRESS_SCREEN,CLOSE_SCREEN_LINE,CR_STRTP
	.ref	CURRENT_ANN_QUEUE,DONE_HOWARD,do_that_cycle,dpageflip
	.ref	entered_inits,FADE_MASTER_VOL,FIND_LOW_TABLE_LEVEL
	.ref	GET_ADJ,get_but_val_down,get_process_ptr,get_start_cur
	.ref	get_stick_val_cur,get_stick_val_down,match_time
	.ref	NEXT_ANN_QUEUE,no_pin_check,PCNT,pin_speed_check
	.ref	PIN_SPEED_TAB,PSTATUS,PUT_UP_PROGRESS,RNDPER,RNDRNG0
	.ref	SPECIAL_WIPEOUT,start_credbox,stay_down,total_matches
	.ref	triple_sound,winstreak_check,WIPEOUT,wmania_tune
	.REF	print_beaten
	.ref	GET_AUD

#*****************************************************************************

	BSSX	MATCH_TIMERS,64
	bssx	which_player,32

	BSSX	index1,		16 	;player 1 cursor position
	BSSX	index2,		16 	;player 2 cursor position
	.bss	time_out,	16	;time out flag
	.bss	active_flag,	16	;0:player 1 active, 1:player 2 active

	.bss	kp_p1cursor,	32
	.bss	blow_out,	16	;Flag for not delaying after no buyin
	.BSS	SPEECH_STARTED,	16

	bssx	match_time_bcd,32

	bssx	are_we_waiting_f,16

#*****************************************************************************

num_wrestlers	EQU	9

	.word	AUD_SNDERR4,AUD_SNDERR4,AUD_SNDERR4,AUD_SNDERR4
wrestler_audits
	.word	AUD_BHART,AUD_BHARTHW,AUD_BHARTC,AUD_BHARTCW
	.word	AUD_RRAMO,AUD_RRAMOHW,AUD_RRAMOC,AUD_RRAMOCW
	.word	AUD_UNDER,AUD_UNDERHW,AUD_UNDERC,AUD_UNDERCW
	.word	AUD_YOKO,AUD_YOKOHW,AUD_YOKOC,AUD_YOKOCW
	.word	AUD_SMICH,AUD_SMICHHW,AUD_SMICHC,AUD_SMICHCW
	.word	AUD_BBBIG,AUD_BBBIGHW,AUD_BBBIGC,AUD_BBBIGCW
	.word	AUD_DCLOW,AUD_DCLOWHW,AUD_DCLOWC,AUD_DCLOWCW
	.word	0,0,0,0
	.word	AUD_LLUGE,AUD_LLUGEHW,AUD_LLUGEC,AUD_LLUGECW
wrestler_auditsX


#*****************************************************************************

	.ref	OLD_PSTATUS
	.ref	CR_CONTP
	.ref	GAMSTATE
	.ref	secret_damage

#*******************************

	STRUCTPD
	LONG	#cursorimg		;UHL cursor *img
	LONG	#hiliteimg		;UHL hilite letter *img
	WORD	#stick			;UHW stick to read
	LONG	#which_tab
	LONG	#which_entry
	LONG	#which_level

GAME_BEATEN
	MOVI	998,A3
	CALLA	SNDSND
	movi	2,a0
	calla	RNDRNG0
	move	a0,a3
	addk	0fh,a3
	calla	SNDSND

	MOVK	5,A11
	MOVI	32,A8
	CREATE0	FADE_MASTER_VOL

	calla	WIPEOUT
	movk	1,a0			;page flipping on
	move	a0,@dpageflip
	calla	start_credbox
	movi	#plyrsel_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1		;create objects for background
	clr	a14
	move	a14,@time_out

	CREATE0	display_croutons

	move	@PSTATUS,A10
	srl	1,a10
	move	a10,a8

	MOVE	a8,a1
	sll	5,a1
	move	a8,a2
	sll	4,a2
	add	a2,a1
	addi	entered_inits,a1
	clr	a2
	move	a2,*a1+,L
	move	a2,*a1

	push	a10
	clr	a1
	move	a10,a10
	jrnz	which_playr_set
	movk	1,a1
which_playr_set
	move	a1,a10
	CREATE	SELECT_PID,player_cursor

	pull	a10
	push	a10

	JSRP	DO_BEATEN_GAME
	pull	a10

are_we_waiting4
	move	a10,a0
	addi	HI_INPUT_PID,a0
	movi	-1,a1
	calla	EXISTP
	JRZ	no_need_for_inputb
	sleep	1
	movi	CYCPID,a0
	movi	-1,a1
	calla	EXISTP
	jrnz	are_we_waiting4
	move	a10,a0
	addi	HI_INPUT_PID,a0
	movi	-1,a1
	calla	EXISTP
	JRZ	no_need_for_inputb
	mmtm	sp,a10,a9,a8
	calla	do_that_cycle
	mmfm	sp,a10,a9,a8
	jruc	are_we_waiting4

no_need_for_inputb

	CALLA	WIPEOUT
	movk	1,a0			;page flipping on
	move	a0,@dpageflip
	movi	#hstd_mod,a0
	move	a0,@BAKMODS,L
	CALLA	BGND_UD1		;create objects for background

	movi	AUD_BEATEN,A0
	calla	GET_AUD
	SUBI	2,A1
	CMPI	1,A1
	JRGE	NO_PROBLEM
	MOVK	1,A1
NO_PROBLEM
	CMPI	48,A1
	JRLE	NO_PROBLEM2
	MOVI	48,A1
NO_PROBLEM2
	MOVE	A1,A5

	JSRP	print_beaten
	SLEEP	TSEC*7
	retp

#hstd_mod
	.long	slateBMOD
	.word	0,0
	.long	0


pin_speed_in_case
	move	@total_matches,a14
	jrz	no_need_for_input

	move	a10,a8

	move	a8,A1
	CALLA	get_process_ptr
	MOVE	A8,A0
	SLL	5,A0
	ADDI	MATCH_TIMERS,A0
	move	*a0,A0,L
	movi	FIND_LOW_TABLE_LEVEL,a11
	move	a11,*a13(#which_level),L
	clr	a3
	MOVI	PIN_SPEED_TAB,A8
	calla	CHECK_SCORE

	jrz	no_need_for_input
	move	a10,A1
	sll	5,a1

	MOVE	A10,A2
	SLL	4,A2
	ADD	A2,A1
	addi	entered_inits,a1
	move	*a1,a1,L
	jrnz	no_display_anything


	MOVI	998,A3
	CALLA	SNDSND
	movi	2,a0
	calla	RNDRNG0
	move	a0,a3
	addk	0fh,a3
	calla	SNDSND

	MOVK	5,A11
	MOVI	32,A8
	CREATE0	FADE_MASTER_VOL

	calla	WIPEOUT
	movk	1,a0			;page flipping on
	move	a0,@dpageflip
	calla	start_credbox
	movi	#plyrsel_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1		;create objects for background
	clr	a14
	move	a14,@time_out

	CREATE0	display_croutons

	push	a10
	clr	a1
	move	a10,a10
	jrnz	which_play_set
	movk	1,a1
which_play_set
	move	a1,a10
	CREATE	SELECT_PID,player_cursor

	pull	a10
no_display_anything

	move	a10,a8
	mmtm	sp,a6,a7,a8,a9,a10,a11
	jsrp	pin_speed_check
	mmfm	sp,a6,a7,a8,a9,a10,a11

are_we_waiting3
	move	a10,a0
	addi	HI_INPUT_PID,a0
	movi	-1,a1
	calla	EXISTP
	JRZ	no_need_for_input
	sleep	1
	movi	CYCPID,a0
	movi	-1,a1
	calla	EXISTP
	jrnz	are_we_waiting3
	move	a10,a0
	addi	HI_INPUT_PID,a0
	movi	-1,a1
	calla	EXISTP
	JRZ	no_need_for_input
	mmtm	sp,a10,a9,a8
	calla	do_that_cycle
	mmfm	sp,a10,a9,a8
	jruc	are_we_waiting3

no_need_for_input
	retp

calc_match_time_1
	callr	work_out_match_time
	movi	10000,a1
	sub	a0,a1
	JRUC	STORE_MATCH_TIME

	.def	calc_match_time_2
calc_match_time_2
	callr	work_out_match_time
	movi	10000,a1
	sub	a0,a1
	MOVE	*A10(PLYRNUM),A0
	CMPI	2,A0
	JRGE	NO_POINT_ITS_A_DRONE
	SLL	5,A0
	ADDI	MATCH_TIMERS,A0
	MOVE	*A0,A0,L
	add	a1,a0
	cmpi	10000,a0
	jrge	no_bother_pin_speed_check
	calla	BINBCD
	move	a0,a1
	JRUC	STORE_MATCH_TIME
no_bother_pin_speed_check
	movi	-1,a1
STORE_MATCH_TIME
	MOVE	*A10(PLYRNUM),A0
	CMPI	2,A0
	JRGE	NO_POINT_ITS_A_DRONE
	SLL	5,A0
	ADDI	MATCH_TIMERS,A0
	MOVE	A1,*A0,L
NO_POINT_ITS_A_DRONE
	rets

work_out_match_time
	move	@match_time,a4,L
	move	a4,a1
	srl	8,a4
	sll	24,a1
	srl	12,a1
	or	a1,a4

	move	@match_time+020h,a5
	sll	16,a5
	srl	16,a5
	movi	100,a0
	mpyu	a0,a5
	srl	16,a5
	move	a5,a0
	calla	BINBCD
	or	a4,a0
	calla	BCDBIN
	rets

howard_wins
	MOVE	@SPEECH_STARTED,a0
	CMPI	2,A0
	jreq	NO_SPEECH_COS_HOWRD_TALKIN
	movi	1Feh,a0
	CALLA	ADD_VOICE
	movk	2,a0
	MOVE	a0,@SPEECH_STARTED
	sleep	80
	clr	a0
	MOVE	a0,@SPEECH_STARTED
	die

SPEAK_TO_ME
	SLEEPK	1
	MOVE	@SPEECH_STARTED,A0
	JRNZ	SPEAK_TO_ME
	MOVE	@NEXT_ANN_QUEUE,A1,L
	MOVE	@CURRENT_ANN_QUEUE,A2,L
	CMP	A1,A2
	JRNE	NO_SPEECH_COS_HOWRD_TALKIN
	MOVK	1,A0
	MOVE	A0,@SPEECH_STARTED
	MOVE	*A8,A9
	SLL	5,A9
	ADDI	WHICH_SPEECH,A9
	MOVE	*A9,A0
	CALLA	ADD_VOICE
	MOVE	*A8(010H),A0
	CALLA	PRCSLP
	CLR	A0
	MOVE	A0,@SPEECH_STARTED
NO_SPEECH_COS_HOWRD_TALKIN
	DIE

;Bret
;Razor
;Taker
;Yoko
;Shawn
;Bam Bam
;Doink
;spare
;Lex
WHICH_SPEECH
	.WORD	131H,70
	.WORD	12DH,44
	.WORD	12FH,54
	.WORD	132H,59
	.WORD	12CH,55
	.WORD	12EH,76
	.WORD	12BH,54
	.WORD	0,0
	.WORD	130H,47

 SUBR	buyin_select

;This turns on the player select background, etc.

;If this is a one player game, then display standard challenger needed
;message on the correct side.  Then display a please continue message
;on the other side, along with a buyin timer.

;If this is a two player game, turn on the cursor, etc. for the winning
;player.  Then display a please continue message on the other side, along
;with a buyin timer.

;If a player chooses to let his buyin timer expire, then check to see if
;he had achieved a high score.  If so, display the initials on his side
;and let him pick.  The other player (or none) will stay in limbo.

	movi	INWAITCONT,a14		;set GAMSTATE
	move	a14,@GAMSTATE

 SUBR	select_screen

	calla	display_blank
	clr	a0
	move	a0,@secret_damage
	MOVE	A0,@SPEECH_STARTED

	calla	WIPEOUT			;kill any attract modes or old
					;battles lying around.
	movi	INSELECT,a14		;set GAMSTATE
	move	a14,@GAMSTATE
	movi	SELECT_PID,a14		;set our PID
	move	a14,*a13(PROCID)

 .if DEBUG
;Temp, stuff @index1,2 for testing wrestlers.

	move	@skip_select,a0
	jrz	#noskp

;0	(Bret)
;1	(Razor)
;2	(Taker)
;3	(Yoko)
;4	(Shawn)
;5	(Bam Bam)
;6	(Doink)
;7	spare
;8	(Lex)

	calla	display_unblank
	movi	6,a0
	move	a0,@index1
	movi	2,a0
	move	a0,@index2

	move	@skip_select,a0
	jrp	#skp2

	.ref	NUM_OPPS
	movk	1,a0
	move	a0,@NUM_OPPS

#skp0
	RETP
#skp2
	RETP

	clr	a0
	calla	get_but_val_cur
	btst	PLAYER_BLOCK_BIT,a0
	jrz	#no_block1
	movk	1,a14
	move	a14,@stay_down
	andni	PLAYER_BLOCK_VAL,a0
#no_block1
	X16	a0
	addi	#select_table,a0
	move	*a0,a14
	move	a14,@index1

	movi	1,a0
	calla	get_but_val_cur
	btst	PLAYER_BLOCK_BIT,a0
	jrz	#no_block2
	movk	1,a14
	move	a14,@stay_down
	andni	PLAYER_BLOCK_VAL,a0
#no_block2
	X16	a0
	addi	#select_table,a0
	move	*a0,a14
	move	a14,@index2
	RETP

	;lookup table
#select_table
	.word	1
	.word	3		;1	punch
	.word	1,1
	.word	0		;4	spunch
	.word	8		;5	punch + spunch
	.word	1,1
	.word	1		;8	kick
	.word	6		;9	punch + kick
	.word	1,1,1,1,1,1
	.word	4		;16	skick
	.word	1,1,1
	.word	5		;20	spunch + skick
	.word	1,1,1
	.word	2		;24	kick + skick
	.word	1,1,1,1,1,1,1

	BSSX	skip_select,	16

#noskp
 .endif

	MOVK	5,A11
	MOVI	32,A8
	CREATE0	FADE_MASTER_VOL

	clr	a0
	move	a0,@blow_out

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movi	#plyrsel_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1		;create objects for background

	;play wrestlemania tune
	.if MUSIC_ON
	CREATE0	wmania_tune
	.endif

	CREATE0	display_croutons
	calla	start_credbox

;Initialize flags
	move	@PSTATUS,a14
	move	a14,@active_flag

	clr	a14
	move	a14,@time_out

	;create the player cursors
	clr	a10
	CREATE	SELECT_PID,player_cursor

	move	a0,@kp_p1cursor,L
	CREATE0	blink_rndper

	movk	1,a10
	CREATE	SELECT_PID,player_cursor

	;wait for them to finish up

	SLEEPK	1

	movk	1,a0
	move	a0,@DISPLAYON
	calla	display_unblank

#waitloop
	SLEEPK	1
	move	@are_we_waiting_f,a14
	jrz	no_we_are_not
	dec	a14
	move	a14,@are_we_waiting_f
no_we_are_not
	move	@active_flag,a14
	jrnz	#waitloop

	move	@OLD_PSTATUS,a14
	jrnz	#waitloop


;Players have chosen their guys.  wait a sec, then bail
	movi	TSEC+30,a8
#final_waitloop

	SLEEPK	1

	move	@active_flag,a14	;don't quit if someone jumps in here
	jrnz	#waitloop

	move	@blow_out,a0
	jrnz	#out

	dsj	a8,#final_waitloop

#out
	RETP


 SUBRP	display_croutons
;Draw the croutons and their associated pix

	move	@PSTATUS,a0
;	jrnz	#gocrut
;	SLEEPK	1
;	jruc	display_croutons
;#gocrut

	movi	crouton_pos_table,a9
	movi	#crouton_pic_table,a10
	move	*a9+,a0
#crouton_loop
	move	*a9+,a1

	sll	16,a0
	sll	16,a1
	move	*a10+,a2,L
	movi	#crutpic_z,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7

	calla	BEGINOBJW

	move	*a9+,a0
	jrnz	#crouton_loop

;	CREATE0	select_clock
;	move	a0,a10
;	CREATE0	clock_digits

	DIE


#plyrsel_mod
	.long	wwfselbkBMOD
	.word	-40,0
	.long	0

#crutplt_z	equ	1
hiplate_z	equ	2	;oscillates from 2 to 3
#crutpic_z	equ	4
hilite_z	equ	5

#baseshad_z	equ	1
#hishad_z	equ	2
#attplt_z	equ	3
#sidebar_z	equ	3
#nameshad_z	equ	5
#namebar_z	equ	7
atttxt_z	equ	8

name_z		equ	9

mugshot_z	equ	1

#crouton_pic_table
	.long	CRUT_DK
	.long	CRUT_RR
	.long	CRUT_UN
	.long	CRUT_YK
	.long	CRUT_SM
	.long	CRUT_BM
	.long	CRUT_BH
	.long	CRUT_LX

crouton_pos_table
	.word	164,45
	.word	204,45

	.word	164,90
	.word	204,90

	.word	164,135
	.word	204,135

	.word	164,180
	.word	204,180

	.word	0


#*****************************************************************************
* Process that handles player selection for one player.
* >a10 = player (0 or 1)

	STRUCTPD
	LONG		#HILITE			;UHL *hilite ring

	LONG		#HIPLATE		;UHL *color crouton

	LONG		#NAME			;UHL *name obj (message *obj)
	WORD		#RND_DEST		;UHW target if in random mode

	LONG		#MUG1
	LONG		#MUG2
	LONG		#MUG3
	LONG		#MUG4
	LONG		#MUG5
	LONG		#MUG6
	LONG		#MUG7
	LONG		#MUG8

	LONG		#ATT1
	LONG		#ATT2
	LONG		#ATT3
	LONG		#ATT4
	WORD		#CNTR			;Flashing cursor delay


;player info struct
#PI_HILITE	equ	0		;UHL hilite box TBL_ hdr
#PI_HIPLATE	equ	20h		;UHL hilite plate TBL_ hdr
#PI_STARTPOS	equ	40h		;UHW starting pos (index)
#PI_MUGPOS	equ	50h		;UHL mugshot [y,x]
#PI_MUGXPOS	equ	50h		;UHW mugshot x
#PI_MUGYPOS	equ	60h		;UHW mugshot y
#PI_MUGCTRL	equ	70h		;UHW mugshot OCTRL
#PI_STARTNAME	equ	80h		;UHL starting name TBL_ hdr
#PI_ATTTXT	equ	0A0h		;UHL atttribute text TBL_ hdr
#PI_INDEX	equ	0C0h		;UHL write selection word here
#PI_MOVESOUND	equ	0E0h		;UHW cursor move triple_sound
#PI_SELSOUND	equ	0F0h		;UHW select sound

#rnd_movespeed	equ	5		;ticks between rndsel moves

#rnd_wander	equ	14		;rnd moves before home-in begins

 SUBRP	player_cursor

	;reg use
	;  a6 = ticks until another move is allowed (debounce)
	;  a6 = ticks until next move (random mode)
	;  a7 = moves until home-in (random mode)
	;  a9 = player info struct pointer
	; a10 = player number
	; a11 = position index (0-9)

	;aim a9 at #p?info
	move	a10,a9
	X32	a9
	addi	#info,a9
	move	*a9,a9,L

	;initialize the index word to -1
	movi	-1,a14
	move	*a9(#PI_INDEX),a0,L
	move	a14,*a0,W

	;initialize random dest to -1
	movi	-1,a14
	move	a14,*a13(#RND_DEST)

	clr	a0
	move	a0,*a13(#NAME),L
	movk	30,a0
	move	a0,*a13(#CNTR)
	;active?
	move	@PSTATUS,a14
	btst	a10,a14
	jrnz	#begin_select

	move	@OLD_PSTATUS,a14
	btst	a10,a14
	jrz	#norm

;This guy lost his last match:
;did this guy get a high win streak ? 
	move	a10,a8
	mmtm	sp,a6,a7,a8,a9,a10,a11
	jsrp	winstreak_check
	mmfm	sp,a6,a7,a8,a9,a10,a11

are_we_waiting
	move	a10,a0
	addi	HI_INPUT_PID,a0
	movi	-1,a1
	calla	EXISTP
	JRZ	FINISHED_INPUTTING
	sleep	1
	movi	CYCPID,a0
	movi	-1,a1
	calla	EXISTP
	jrnz	are_we_waiting
	move	a10,a0
	addi	HI_INPUT_PID,a0
	movi	-1,a1
	calla	EXISTP
	JRZ	FINISHED_INPUTTING
	mmtm	sp,a10,a9,a8
	calla	do_that_cycle
	mmfm	sp,a10,a9,a8
	jruc	are_we_waiting

FINISHED_INPUTTING

	;create the name text
	move	*a9(#PI_STARTNAME),a0,L
	calla	BEGINOBJ_TBL
	move	a8,*a13(#NAME),L

;Display please continue message
;Display price to continue
;Turn on continue timer at bottom of screen (Attribute area)

;Wait for him to make a decision
;If he continues, turn on cursor, etc.
;If he does not continue, start the other players time out for
;player selection (If other plyr is present)

	CREATE0	buyin_counter
	callr	buyin_text

;/Inactive.  wait for buyin
;Display the insert coin/press start message

#enough_money1
	calla	CR_CONTP
	jrhs	#enough_money2
;There's not enough money.  flash 'insert coins' message and wait
	move	*a13(#NAME),a8,L
	movi	WF_INSERT,a0
	calla	civanic
	jruc	#start_waitloop1
#enough_money2
;There's enough money.  flash 'press start' message and wait
	move	*a13(#NAME),a8,L
	movi	WF_START,a0
	calla	civanic

#start_waitloop1
	move	@OLD_PSTATUS,a14
	btst	a10,a14
	jrnz	#okz

	move	@PSTATUS,a14
	btst	a10,a14
	jrnz	#okz
;Timer has run out on this player
	move	@PSTATUS,a0
	jrnz	#still

;Goto game over.
THIS_GAME_IS_BEATEN
	CLR	A0
	MOVE	A0,@PSTATUS

	movi	INGAMEOVER,a14		;set GAMSTATE
	move	a14,@GAMSTATE
	movi	GAMEOVER_PID,a14	;set our PID
	move	a14,*a13(PROCID)

	calla	display_blank
	calla	WIPEOUT

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

	SLEEPK	1

	.ref	UNIT_CLR,attract_mode
	.ref	lgmd_ascii

	MOVI	-1,A11
	MOVI	100,A8
	CREATE0	FADE_MASTER_VOL

	calla	display_unblank
	SLEEP	TSEC*4
	calla	UNIT_CLR		;CLEAR THE FACTIONS OF FRACTIONS

	movi	AMODE_PID,a0
	move	a0,*a13(PROCID)
	jauc	attract_mode

LN1b_setup
	JAM_STR	lgmd_ascii,6,0,200,128-10-61,LGMDBLU,0
LN2b_setup
	JAM_STR	lgmd_ascii,6,0,200,128,LGMDBLU,0
#str_game
	.byte	"GAME",0
#str_over
	.byte	"OVER",0
	.even

#still
;Other player is in game
	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a0
	add	a10,a0
	calla	obj_del1c
;If other player has already picked his wrestler, just blow out of here
;otherwise, goto challenger needed screen stuff...
	move	@active_flag,a14	;don't quit if someone jumps in here
	jrnz	#norm
;Tell buyin_select proc to wake up and exit!
	movk	1,a0
	move	a0,@blow_out

	DIE

#okz
	SLEEPK	1

	callr	#blink

	move	@PSTATUS,a14
	btst	a10,a14
	jrz	#enough_money1

;	jrz	#start_waitloop1

	move	*a8(OXPOS),a0
	andi	1ffh,a0
	move	a0,*a8(OXPOS)

	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a0
	add	a10,a0
	calla	obj_del1c

	SLEEPK	1			;Fix pal glitch!

	jruc	#begin_select

#norm

	;create the name text
	move	*a9(#PI_STARTNAME),a0,L
	calla	BEGINOBJ_TBL
	move	a8,*a13(#NAME),L

;Place a message which reads:
;Challenger needed!
;x credits to start
;Unless we are in freeplay!  Then
;just display challenger needed centered
;in the box!

	movk	ADJFREPL,a0		;Are we in free play?
	calla	GET_ADJ
	jrz	#not_freeply

;Print free play
	movi	#ln0_setup,a2
	move	a10,a10
	jrz	#ok2c
	movi	#ln0_setupb,a2
#ok2c	calla	setup_message

	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a0
	add	a10,a0
	move	a0,@mess_objid

	movi	#str_text0,a4
	calla	print_string_C2



;Print centered "challenger needed" message
	movi	#ln1_setup,a2
	move	a10,a10
	jrz	#ok
	movi	#ln1_setupb,a2
#ok	calla	setup_message

	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a0
	add	a10,a0
	move	a0,@mess_objid

	movi	#str_text,a4
	calla	print_string_C2

	movi	#ln2_setup,a2
	move	a10,a10
	jrz	#ok4
	movi	#ln2_setupb,a2
	jruc	#ok4

#not_freeply
;Print how many credits to start
	PUSH	a8
	movk	ADJCSTRT,a0
	calla	GET_ADJ 		;GET NUMBER NEEDED
	move	a0,a3
	cmpi	10,a0
	jrlt	#max
	movk	9,a0
#max
	sll	5,a0
	addi	digits_tbl,a0
	move	*a0,a2,L		;* image

	movi	[050,0],a0			;x pos
	cmpi	1,a3
	jrnz	#not1
	movi	[054,0],a0			;x pos
#not1	move	a10,a10
	jrz	#zp1
	movi	[0122h,0],a0			;x pos
	cmpi	1,a3
	jrnz	#zp1
	movi	[0126h,0],a0			;x pos
#zp1
	movi	[110,0],a1			;y pos
	movi	104+200,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a5
	add	a10,a5				;object ID
	clr	a6				;x vel
	clr	a7	 			;y vel
	movi	FNT9YEL_P,b0
	calla	BEGINOBJP
	PULL	a8

	movi	#ln3_setup,a2
	move	a10,a10
	jrz	#ok2
	movi	#ln3_setupb,a2
#ok2	calla	setup_message

	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a0
	add	a10,a0
	move	a0,@mess_objid

	movi	#str_text3,a4
	movk	ADJCSTRT,a0
	calla	GET_ADJ 		;GET NUMBER NEEDED
	cmpi	1,a0
	jrnz	#not1b
	movi	#str_text3b,a4
#not1b
	calla	print_string_C2

	movi	#ln4_setup,a2
	move	a10,a10
	jrz	#ok2B
	movi	#ln4_setupb,a2
#ok2B	calla	setup_message

	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a0
	add	a10,a0
	move	a0,@mess_objid

	movi	#str_text4,a4
	calla	print_string_C2


;Print "challenger needed" message
	movi	#ln1_setupx,a2
	move	a10,a10
	jrz	#ok3
	movi	#ln1_setupxb,a2
#ok3	calla	setup_message

	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a0
	add	a10,a0
	move	a0,@mess_objid

	movi	#str_text,a4
	calla	print_string_C2

	movi	#ln2_setupx,a2
	move	a10,a10
	jrz	#ok4
	movi	#ln2_setupxb,a2
#ok4	calla	setup_message

	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a0
	add	a10,a0
	move	a0,@mess_objid

	movi	#str_text2,a4
	calla	print_string_C2

;Inactive.  wait for buyin
;Create the insert coin/press start message
  
#enough_money
	calla	CR_STRTP
	jrhs	#enough_money3
;There's not enough money.  flash 'insert coins' message and wait
	move	*a13(#NAME),a8,L
	movi	WF_INSERT,a0
	calla	civanic
	jruc	#start_waitloop
#enough_money3
;There's enough money.  flash 'press start' message and wait
	move	*a13(#NAME),a8,L
	movi	WF_START,a0
	calla	civanic


#start_waitloop
	SLEEPK	1

	callr	#blink

	move	@PSTATUS,a14
	btst	a10,a14
	jrz	#enough_money

;	jrz	#start_waitloop

	move	*a8(OXPOS),a0
	andi	1ffh,a0
	move	a0,*a8(OXPOS)

	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a0
	add	a10,a0
	calla	obj_del1c

	SLEEPK	1			;Fix pal glitch!

	jruc	#begin_select



#ln0_setup
	JAM_STR	font9_ascii,8,0,81,120,FNT9YEL_P,0
#ln0_setupb
	JAM_STR	font9_ascii,8,0,321,120,FNT9YEL_P,0

#ln1_setup
	JAM_STR	font9_ascii,8,0,81,80,FNT9YEL_P,0
#ln1_setupb
	JAM_STR	font9_ascii,8,0,321,80,FNT9YEL_P,0

#ln2_setup
	JAM_STR	font9_ascii,8,0,81,95,FNT9YEL_P,0
#ln2_setupb
	JAM_STR	font9_ascii,8,0,321,95,FNT9YEL_P,0

#ln1_setupx
	JAM_STR	font9_ascii,8,0,81,60,FNT9YEL_P,0
#ln1_setupxb
	JAM_STR	font9_ascii,8,0,321,60,FNT9YEL_P,0

#ln2_setupx
	JAM_STR	font9_ascii,8,0,81,75,FNT9YEL_P,0
#ln2_setupxb
	JAM_STR	font9_ascii,8,0,321,75,FNT9YEL_P,0


#ln3_setup
	JAM_STR	font9_ascii,8,0,81,110,FNT9YEL_P,0
#ln3_setupb
	JAM_STR	font9_ascii,8,0,321,110,FNT9YEL_P,0

#ln4_setup
	JAM_STR	font9_ascii,8,0,81,125,FNT9YEL_P,0
#ln4_setupb
	JAM_STR	font9_ascii,8,0,321,125,FNT9YEL_P,0

#str_text
	.string	"CHALLENGER",0
#str_text0
	.string	"FREE PLAY",0
#str_text2
	.string	"NEEDED!",0
#str_text3
	.string	"  CREDITS",0
#str_text3b
	.string	"  CREDIT",0
#str_text4
	.string	"TO START",0
	.even

#begin_select
	MOVE	@no_pin_check,A0
	JRNZ	are_we_waiting2

	move	a10,a8
	mmtm	sp,a6,a7,a8,a9,a10,a11
	jsrp	pin_speed_check
	mmfm	sp,a6,a7,a8,a9,a10,a11

	move	@PSTATUS,A0
	CMPI	3,A0
	JREQ	are_we_waiting2

	movi	60,a0
	move	a0,@are_we_waiting_f

are_we_waiting2
	move	a10,a0
	addi	HI_INPUT_PID,a0
	movi	-1,a1
	calla	EXISTP
	JRZ	FINISHED_INPUTTING2
	sleep	1
	movi	CYCPID,a0
	movi	-1,a1
	calla	EXISTP
	jrnz	are_we_waiting2
	move	a10,a0
	addi	HI_INPUT_PID,a0
	movi	-1,a1
	calla	EXISTP
	JRZ	FINISHED_INPUTTING2
	mmtm	sp,a10,a9,a8
	calla	do_that_cycle
	mmfm	sp,a10,a9,a8
	jruc	are_we_waiting2

FINISHED_INPUTTING2

	MOVI	CLOCK_PID,A0
	movi	-1,a1
	CALLA	EXISTP
	JRNZ	CLOCK_ALREADY_TICKING

	PUSH	A10
	CREATE	CLOCK_PID,select_clock
	move	a0,a10
	CREATE0	clock_digits
	PULL	A10

CLOCK_ALREADY_TICKING

	move	*a13(#NAME),a8,L
	jrnz	no_need_to_create

	;create the name text
	move	*a9(#PI_STARTNAME),a0,L
	calla	BEGINOBJ_TBL
	move	a8,*a13(#NAME),L
no_need_to_create

	move	@total_matches,a14
	jrnz	HOWARD_ALREADY_GOING
	move	@DONE_HOWARD,a14
	jrnz	HOWARD_HAS_SPOKEN

GOOD_EVENING
	movi	1Fbh,a0
	CALLA	ADD_VOICE
	movi	1Fch,a0
	CALLA	ADD_VOICE
	movi	1Fdh,a0
	CALLA	ADD_VOICE

	movk	1,a0
	move	a0,@DONE_HOWARD
	JRUC	HOWARD_HAS_SPOKEN

HOWARD_ALREADY_GOING
	move	@DONE_HOWARD,a14
	jrnz	HOWARD_HAS_SPOKEN
	MOVI	100,A0
	CALLA	RNDPER
	jrls	HOWARD_HAS_SPOKEN

	SUBI	50,A0
	JRN	GOOD_EVENING
	movi	1Ffh,a0
	CALLA	ADD_VOICE

	movk	1,a0
	move	a0,@DONE_HOWARD
HOWARD_HAS_SPOKEN

	;set our active bit if it's not already set
	move	@active_flag,a14
	move	a10,a0
	inc	a0
	or	a0,a14
	move	a14,@active_flag

	;initialize index
	move	*a9(#PI_STARTPOS),a11

	;initialize #MUG?
	movk	8,a0
	clr	a1
	move	a13,a2
	addi	#MUG1,a2
#initloop
	move	a1,*a2+,L
	dsj	a0,#initloop

	;create our attrib text
	move	*a9(#PI_ATTTXT),a0,L
	calla	BEGINOBJ_TBL
	move	*a8(OXVAL),a0,L
	move	*a8(OYVAL),a1,L

	;create the att bars
	addi	[63,0],a0
	addi	[12,0],a1
	movi	ATTMTR_0,a2
	movi	atttxt_z,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7

	PUSH	a10,a11

	movi	4,a10			;bar count
	move	a13,a11
	addi	#ATT1,a11

#abc_loop
	PUSH	a0,a1,a2,a3,a4,a5,a6,a7
	calla	BEGINOBJ
	PULL	a0,a1,a2,a3,a4,a5,a6,a7
	move	a8,*a11+,L
	addi	[8,0],a1
	dsj	a10,#abc_loop

	PULL	a10,a11

	;create our cursors
	move	*a9(#PI_HILITE),a0,L
	calla	BEGINOBJ_TBL
	move	a8,*a13(#HILITE),L

	move	*a9(#PI_HIPLATE),a0,L
	calla	BEGINOBJ_TBL
	move	a8,*a13(#HIPLATE),L

	jruc	#first_adjust

#blink
	move	*a13(#CNTR),a0
	dec	a0
	move	a0,*a13(#CNTR)
	jrp	#cont
	movk	22,a0
	move	a0,*a13(#CNTR)
	move	*a8(OXPOS),a0
	xori	1000h,a0
	move	a0,*a8(OXPOS)
#cont
	rets


	.if	0

;Color cycle cursors...
;Good example for future cycles....

	PUSH	a8,a9,a10,a11

	move	a10,a10
	jrz	#blue

	movi	[1,1],a8
	movi	CRHI_R_P,a9
	movi	redcyc_tbl,a10
	movk	4,a11
	CREATE	CYCPID,CYCLE_TABLE
	jruc	#out

#blue
	movi	[1,1],a8
	movi	CRHI_B_P,a9
	movi	blucyc_tbl,a10
	movk	4,a11
	CREATE	CYCPID,CYCLE_TABLE

#out	PULL	a8,a9,a10,a11

	jruc	#first_adjust


blucyc_tbl
	.word	0041fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word	0081fh,00c1fh,0101fh,0141fh,0181fh
	.word   01c1fh,0201fh,0241fh,0281fh,02c1fh,0301fh,0341fh,0381fh
	.word   03c1fh,0401fh,0441fh,0481fh,04c1fh,0501fh,0541fh,0581fh
	.word   05c1fh,0601fh,0641fh,0681fh,06c1fh,0701fh
	.word	0741fh,0701fh,06c1fh,0681fh,0641fh,0601fh,05c1fh
	.word   0581fh,0541fh,0501fh,04c1fh,0481fh,0441fh,0401fh,03c1fh
	.word   0381fh,0341fh,0301fh,02c1fh,0281fh,0241fh,0201fh,01c1fh
	.word   0181fh,0141fh,0101fh,00c1fh,0081fh,0041fh

	.word	0041fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word   0001fh
	.word	0081fh,00c1fh,0101fh,0141fh,0181fh
	.word   01c1fh,0201fh,0241fh,0281fh,02c1fh,0301fh,0341fh,0381fh
	.word   03c1fh,0401fh,0441fh,0481fh,04c1fh,0501fh,0541fh,0581fh
	.word   05c1fh,0601fh,0641fh,0681fh,06c1fh,0701fh
	.word	0741fh,0701fh,06c1fh,0681fh,0641fh,0601fh,05c1fh
	.word   0581fh,0541fh,0501fh,04c1fh,0481fh,0441fh,0401fh,03c1fh
	.word   0381fh,0341fh,0301fh,02c1fh,0281fh,0241fh,0201fh,01c1fh
	.word   0181fh,0141fh,0101fh,00c1fh,0081fh,0041fh
	.word	-1

redcyc_tbl
	.word	07c20h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word	07c40h,07c60h,07c80h,07ca0h,07cc0h
	.word   07ce0h,07d00h,07d20h,07d40h,07d60h,07d80h,07da0h,07dc0h
	.word   07de0h,07e00h,07e20h,07e40h,07e60h,07e80h,07ea0h
	.word   07ec0h,07ee0h,07f00h,07f20h,07f40h,07f60h,07f80h
	.word   07fa0h,07f80h,07f60h,07f40h,07f20h,07f00h,07ee0h,07ec0h
	.word   07ea0h,07e80h,07e60h,07e40h,07e20h,07e00h,07de0h
	.word   07dc0h,07da0h,07d80h,07d60h,07d40h,07d20h,07d00h,07ce0h
	.word   07cc0h,07ca0h,07c80h,07c60h,07c40h,07c20h

	.word	07c20h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word   07c00h
	.word	07c40h,07c60h,07c80h,07ca0h,07cc0h
	.word   07ce0h,07d00h,07d20h,07d40h,07d60h,07d80h,07da0h,07dc0h
	.word   07de0h,07e00h,07e20h,07e40h,07e60h,07e80h,07ea0h
	.word   07ec0h,07ee0h,07f00h,07f20h,07f40h,07f60h,07f80h
	.word   07fa0h,07f80h,07f60h,07f40h,07f20h,07f00h,07ee0h,07ec0h
	.word   07ea0h,07e80h,07e60h,07e40h,07e20h,07e00h,07de0h
	.word   07dc0h,07da0h,07d80h,07d60h,07d40h,07d20h,07d00h,07ce0h
	.word   07cc0h,07ca0h,07c80h,07c60h,07c40h,07c20h
	.word	-1

	.endif


#adjust
	move	*a9(#PI_MOVESOUND),a0

	move	*a13(#RND_DEST),a14
	jrn	#move_sound_ok
	movi	18h,a0
#move_sound_ok

	calla	triple_sound
	callr	#erase_mugshot
#first_adjust
	callr	#place_cursor
	callr	#draw_mugshot
	callr	#update_name
	callr	#update_attbars

	;set a6 to debounce value if not rndsel, or to move time if rndsel
	move	*a13(#RND_DEST),a14
	jrnn	#waitloop
	movk	3,a6

	clr	a0
	move	a0,*a8(OCONST)		;Clr color
	move	a0,*a13(#CNTR)

#waitloop

	callr	#place_cursor

	;flash the hilightes
	move	*a13(#HIPLATE),a8,L
	move	*a8(OZPOS),a14
	xori	1,a14
	move	a14,*a8(OZPOS)

	move	*a13(#HILITE),a8,L
	move	*a8(OZPOS),a14
	xori	1,a14
	move	a14,*a8(OZPOS)

	PUSHP	a6,a7
	SLEEPK	1
	PULLP	a6,a7

;Flash cursors white

	move	*a13(#CNTR),a14
	dec	a14
	move	a14,*a13(#CNTR)
	jrp	#normz
	movk	8,a14
	move	a14,*a13(#CNTR)

	PUSH	a6,a7,a9
	movi	0202h,a9
	CREATE0	FLASHME
	.ref	FLASHME
	PULL	a6,a7,a9
#normz

	;are we in random mode?
	move	*a13(#RND_DEST),a14
	jrn	#not_rndsel

	;we're in random select
	dsj	a6,#waitloop

	;time to move again
	movi	#rnd_movespeed,a6	;set time to next move
	dec	a7
	jrp	#move_at_random

	;move toward final destination
	;if we're there, take it
	move	*a13(#RND_DEST),a14
	cmp	a14,a11
	jreq	#but_hit

	;not there.  one time in three, move at random anyway
	movk	3,a0
	calla	RNDRNG0
	TEST	a0
	jrz	#move_at_random

	;if we're in the correct row, move sideways
	move	*a13(#RND_DEST),a14
	xor	a11,a14
	srl	1,a14
	jrz	#rnd_move_sideways

	;okay, move toward the correct row
	move	*a13(#RND_DEST),a14
	cmp	a11,a14
	jrlt	#stick_up
	jruc	#stick_down

#move_at_random
	;move in a random direction, but only in legal directions
	movk	2,a0
	calla	RNDRNG0
	cmpi	2,a0
	jreq	#rnd_move_up
	cmpi	1,a0
	jreq	#rnd_move_down

	;move sideways by toggling bit zero in the index
#rnd_move_sideways
	xori	1,a11
	jruc	#adjust

#rnd_move_up
	cmpi	2,a11
	jrge	#stick_up

	;moving up isn't legal.  move sideways or down
	movi	1,a0
	calla	RNDRNG0
	TEST	a0
	jrz	#rnd_move_sideways
	jruc	#stick_down

#rnd_move_down
	cmpi	5,a11
	jrle	#stick_down

	;moving down isn't legal.  move sideways or up
	movi	1,a0
	calla	RNDRNG0
	TEST	a0
	jrz	#rnd_move_sideways
	jruc	#stick_up

#not_rndsel
	;if time is out, pick whoever we're on.
	move	@time_out,a14
	jrnz	#but_hit

	;begin random select?
	move	a10,a0
	calla	get_start_cur
	jrz	#button_checks

	;start is down.  check stick
	move	a10,a0
	calla	get_stick_val_cur
	btst	JOYUP,a0
	jrz	#button_checks

	;stick is up.  check position
	move	*a9(#PI_STARTPOS),a14
	cmp	a11,a14
	jreq	#begin_random_select

#button_checks
	move	@are_we_waiting_f,a14
	jrnz	no_check_buts_yet

	;button checks
	move	a10,a0
	calla	get_but_val_down
	TEST	a0
	jrnz	#but_hit
no_check_buts_yet

	dec	a6
	jrp	#waitloop
	clr	a6

	;stick checks
	move	a10,a0
	calla	get_stick_val_down
	btst	JOYDN,a0
	jrnz	#stick_down
	btst	JOYUP,a0
	jrnz	#stick_up
	btst	JOYLFT,a0
	jrnz	#stick_left
	btst	JOYRGT,a0
	jrnz	#stick_right
	jruc	#waitloop

#stick_down
	;add 2 unless the index is 6 or 7
	cmpi	6,a11
	jrge	#waitloop
	addi	2,a11
	jruc	#adjust

#stick_up
	;sub 2 unless index is 0 or 1
	cmpi	2,a11
	jrlt	#waitloop
	subi	2,a11
	jruc	#adjust

#stick_left
	;sub 1 unless index is even
	btst	0,a11
	jrz	#waitloop
	dec	a11
	jruc	#adjust

#stick_right
	;add 1 unless index is odd
	btst	0,a11
	jrnz	#waitloop
	inc	a11
	jruc	#adjust

#begin_random_select

;Print text message
	movi	#message_setup,a2
	move	a10,a10
	jrz	#p1m
	movi	#message_setup2,a2
#p1m
	calla	setup_message

	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
	move	a10,a10
	jrz	#p1x
	movi	CLSNEUT|TYPTEXT|SUBMES2,a0
#p1x
	move	a0,@mess_objid

	movi	#message_string,a4
	calla	print_string_C2

	movi	7,a0
	calla	RNDRNG0
	move	a0,*a13(#RND_DEST)
	movi	#rnd_movespeed,a6
	movi	#rnd_wander,a7
	jruc	#waitloop

	.ref	font9_ascii
	.ref	pal_getf,setup_message
	.ref	mess_objid,print_string_C2


blink_rndper

	movi	FNT9RED_P,a0
	calla	pal_getf
	move	a0,a9

	movi	FNT9WHT_P,a0
	calla	pal_getf

	movi	OBJLST,a14
#lpz
	move	*a14,a14,L
	jrz	#x
	move	*a14(OPAL),a2
	cmp	a0,a2
	jrne	#lpz

	move	*a14(OID),a2
	cmpi	CLSNEUT|TYPTEXT|SUBMES1,a2
	jreq	#lpdo
	cmpi	CLSNEUT|TYPTEXT|SUBMES2,a2
	jrne	#lpz
#lpdo
	move	a9,*a14(OPAL)
  	jruc	#lpz

#x	SLEEPK	4

	movi	FNT9RED_P,a0
	calla	pal_getf
	move	a0,a9

	movi	FNT9WHT_P,a0
	calla	pal_getf

	movi	OBJLST,a14
#lp2
	move	*a14,a14,L
	jrz	#x2
	move	*a14(OPAL),a2
	cmp	a9,a2
	jrne	#lp2

	move	*a14(OID),a2
	cmpi	CLSNEUT|TYPTEXT|SUBMES1,a2
	jreq	#lpdo2
	cmpi	CLSNEUT|TYPTEXT|SUBMES2,a2
	jrne	#lp2
#lpdo2
	move	a0,*a14(OPAL)
  	jruc	#lp2

#x2	SLEEPK	7

	jruc	blink_rndper


#message_setup
	JAM_STR	font9_ascii,5,0,79,15,FNT9WHT_P,0

#message_setup2
	JAM_STR	font9_ascii,5,0,321,15,FNT9WHT_P,0

#message_string
	.string "CALLA RNDPER",0

	.even


#but_hit
	;they hit a button.  Stick 'em with the current guy.

;Erase rndper message for this player
	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
	move	a10,a10
	jrz	#p1c
	movi	CLSNEUT|TYPTEXT|SUBMES2,a0
#p1c
	calla	obj_del1c

	move	*a9(#PI_INDEX),a0,L
	;rewire kludge
	move	a11,a14
	X16	a14
	addi	scramble_table,a14
	move	*a14,a14,W
	move	a14,*a0

	move	a10,a1
	sll	4,a1
	addi	which_player,a1
	move	a14,*a1

	MOVI	SEL_SPCH_PID1,A1
	ADD	A10,A1
	MOVE	A0,A8
	MOVI	SPEAK_TO_ME,A7
	CALLA	GETPRC

	;make a joyful noise unto the player
	move	*a9(#PI_SELSOUND),a0
	calla	triple_sound

	;clear our bit in the active flag
	move	@active_flag,a0
	move	a10,a14
	inc	a14
	andn	a14,a0
	move	a0,@active_flag

	;flash over the crouton
	;synch!  begin flashing on an even PCNT
	move	@PCNT,a14
	btst	0,a14
	jrnz	#synch
	SLEEPK	1

#synch
	move	*a13(#HILITE),a8,L
	movi	TSEC/4,a9
#flashloop
	movi	0202h,a14
	move	a14,*a8(OCONST)
	move	*a8(OCTRL),a14
	xori	M_CONZER,a14
	move	a14,*a8(OCTRL)
 	SLEEPK	2
	dsj	a9,#flashloop

	move	*a8(OCTRL),a14
	andni	M_CONZER,a14
	move	a14,*a8(OCTRL)

	movi	hilite_z,a14
	move	a14,*a8(OZPOS)

	move	*a13(#HIPLATE),a8,L
	movi	hiplate_z,a14
	move	a14,*a8(OZPOS)
	
#lp
	SLEEPK	1
	callr	#place_cursor
	jruc	#lp
	

********
* moves cursor to the current index position

 SUBRP	#place_cursor

	PUSH	a2,a3,a7,a8

	move	a11,a1
	X32	a1
	addi	crouton_pos_table,a1
	move	*a1+,a2,W
	move	*a1,a3,W

	move	*a13(#HILITE),a7,L
	move	*a13(#HIPLATE),a8,L

	move	a2,*a8(OXPOS)
	move	a3,*a8(OYPOS)

	move	a10,a10
	jrz	#p1
	move	@kp_p1cursor,a8,L
	move	*a8(PA11),a8
	cmp	a8,a11
	jrnz	#p1
	addk	2,a2
	addk	2,a3
#p1
	move	a2,*a7(OXPOS)
	move	a3,*a7(OYPOS)

	PULL	a2,a3,a7,a8
	rets


********
* updates the name text

 SUBRP	#update_name

	PUSH	a8,a11

	;rewiring kludge
	X16	a11
	addi	scramble_table,a11
	move	*a11,a11,W

	move	a11,a0
	X32	a0
	addi	name_tbl,a0
	move	*a0,a0,L
	move	*a13(#NAME),a8,L
	calla	civanic

	PULL	a8,a11

	rets

********
* erases current mugshot

 SUBRP	#erase_mugshot

	PUSH	a5,a6,a8

	movk	8,a6
	move	a13,a5
	addi	#MUG1,a5
#eraseloop
	move	*a5+,a0,L
	calla	DELOBJ
	dsj	a6,#eraseloop

	PULL	a5,a6,a8

	rets


********
* draws a new mugshot

 SUBRP	#draw_mugshot

	;reg use
	;a10 = PDATA pointer
	;a11 = mug pointer

	PUSH	a6,a7,a8,a10,a11

	;rewiring kludge
	X16	a11
	addi	scramble_table,a11
	move	*a11,a11,W

	X32	a11
	addi	wrestler_mugs,a11
	move	*a11,a11,L

	move	a13,a10
	addi	#MUG1,a10
	move	*a11+,a2,L

#drawloop
	move	*a9(#PI_MUGXPOS),a0
	move	*a9(#PI_MUGYPOS),a1
	sla	16,a0
	sla	16,a1
	movi	mugshot_z,a3
	move	*a9(#PI_MUGCTRL),a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW
	move	a8,*a10+,L
	
	move	*a11+,a2,L
	jrz	#done
	jruc	#drawloop

#done
	PULL	a6,a7,a8,a10,a11
	rets


********
* updates the attribute bars

 SUBRP	#update_attbars

	PUSH	a7,a10,a11


	;rewiring kludge
	X16	a11
	addi	scramble_table,a11
	move	*a11,a11,W

	move	a11,a10
	X64	a10
	addi	wrestler_attributes,a10
	move	a13,a11
	addi	#ATT1,a11

	movi	4,a7
#ualoop
	move	*a10+,a0,W
	X32	a0
	addi	attbars,a0
	move	*a0,a0,L
	move	*a11+,a8,L
	calla	civanic
	dsj	a7,#ualoop

	PULL	a7,a10,a11
	rets

wrestler_attributes
	.word	0,1,2,3
	.word	4,5,6,7
	.word	8,9,0,1
	.word	2,3,4,5
	.word	6,7,8,9
	.word	0,1,2,3
	.word	4,5,6,7
	.word	8,9,0,1
	.word	9,9,9,9

scramble_table	;swap bret and doink on the select page
	.word	6
	.word	1,2,3,4,5
	.word	0
	.word	8		;put lex in place of adam

attbars
	.long	ATTMTR_0,ATTMTR_1,ATTMTR_2,ATTMTR_3,ATTMTR_4
	.long	ATTMTR_5,ATTMTR_6,ATTMTR_7,ATTMTR_8,ATTMTR_9

#info
	.long	#p1info,#p2info

#p1info
	.long	#hi_b,#plt_b			;hilite, crouton
	.word	0				;start index
	.word	0+18+2,175			;mug position
	.word	DMAWNZ|M_3D|M_SCRNREL		;mug octrl
	.long	#p1name,latttxt			;start name,att text
	.long	index1				;report choice to
	.word	0c8h,0cbh			;cursor/select sounds

#p2info
	.long	#hi_r,#plt_r			;hilite, crouton
	.word	1				;start index
	.word	400-18,175			;mug position
	.word	DMAWNZ|M_3D|M_SCRNREL|M_FLIPH	;mug octrl
	.long	#p2name,ratttxt			;start name,att text
	.long	index2				;report choice to
	.word	0c7h,0cch			;cursor/select sounds


#plt_b	.word	0,0,hiplate_z				;X,Y,Z
	.long	CRUTPLT_B				;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT				;OID
	.long	0,0					;XVEL, YVEL

#plt_r	.word	0,0,hiplate_z+1				;X,Y,Z
	.long	CRUTPLT_R				;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT				;OID
	.long	0,0					;XVEL, YVEL

#hi_b	.word	0,0,hilite_z				;X,Y,Z
	.long	CRUTHI_B				;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT				;OID
	.long	0,0					;XVEL, YVEL

#hi_r	.word	0,0,hilite_z+1				;X,Y,Z
	.long	CRUTHI_R				;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT				;OID
	.long	0,0					;XVEL, YVEL

#p1name	.word	>51,184,name_z
	.long	WF_INSERT
	.word	DMAWNZ|M_3D|M_SCRNREL
	.word	CLSNEUT|TYPNEUT
	.long	0,0

#p2name	.word	>142,184,name_z
	.long	WF_INSERT
	.word	DMAWNZ|M_3D|M_SCRNREL
	.word	CLSNEUT|TYPNEUT
	.long	0,0

latttxt	.word	0+18,189,atttxt_z			;X, Y, Z
	.long	ATT_TXT					;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT				;OID
	.long	0,0					;XVEL, YVEL

ratttxt	.word	400-18-124,189,atttxt_z			;X, Y, Z
	.long	ATT_TXT					;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT				;OID
	.long	0,0					;XVEL, YVEL

;Mugshot stuff

wrestler_mugs
	.long	BHARTMUG
	.long	RAZORMUG
	.long	UNDERMUG
	.long	YOKOMUG
	.long	MICHAELMUG
	.long	BAMBAMMUG
	.long	DOINKMUG
	.long	0
	.long	LUGERMUG

wrestler_mugs2
	.long	BHARTMUG
	.long	RAZORMUG
	.long	UNDERMUG
	.long	YOKOMUG
	.long	MICHAELMUG
	.long	BAMBAMMUG
	.long	DOINKMUG
;	.long	ADAMMUG
	.long	LUGERMUG

BHARTMUG
	.long	BHMUG_A,BHMUG_B,BHMUG_C,BHMUG_D
	.long	BHMUG_E,BHMUG_F,BHMUG_G,BHMUG_H,0
RAZORMUG
	.long	RRMUG_A,RRMUG_B,RRMUG_C,RRMUG_D
	.long	RRMUG_E,RRMUG_F,RRMUG_G,RRMUG_H,0
UNDERMUG
	.long	UNMUG_A,UNMUG_B,UNMUG_C,UNMUG_D
	.long	UNMUG_E,UNMUG_F,UNMUG_G,UNMUG_H,0
YOKOMUG
	.long	YKMUG_A,YKMUG_B,YKMUG_C,YKMUG_D
	.long	YKMUG_E,YKMUG_F,YKMUG_G,YKMUG_H,0
MICHAELMUG
	.long	SMMUG_A,SMMUG_B,SMMUG_C,SMMUG_D
	.long	SMMUG_E,SMMUG_F,SMMUG_G,SMMUG_H,0
BAMBAMMUG
	.long	BMMUG_A,BMMUG_B,BMMUG_C,BMMUG_D
	.long	BMMUG_E,BMMUG_F,BMMUG_G,BMMUG_H,0
DOINKMUG
	.long	DKMUG_A,DKMUG_B,DKMUG_C,DKMUG_D
	.long	DKMUG_E,DKMUG_F,DKMUG_G,DKMUG_H,0
LUGERMUG
	.long	LXMUG_A,LXMUG_B,LXMUG_C,LXMUG_D
	.long	LXMUG_E,LXMUG_F,LXMUG_G,LXMUG_H,0

name_tbl
	.long	NAM_BRT,NAM_RZR,NAM_UND,NAM_YOK
	.long	NAM_SHN2,NAM_BAM2,NAM_DNK,0,NAM_LEX

#*****************************************************************************
* Player select clock - sets time_out when it runs out of time
*

 SUBR	select_clock

	;reg use
	; a8 - current pstatus
	; a9 - time remaining

#select_time	equ	TSEC*25

#reset
	movi	#select_time,a9
	move	@PSTATUS,a8

#waitloop
	SLEEPK	1
	move	@PSTATUS,a14
	cmp	a14,a8
	jrne	#reset			;new buyin.  reset

	dsj	a9,#waitloop

;If other player is still thinking about buying in or is
;still entering his initials, then go to #reset

	move	@OLD_PSTATUS,a0
	jrnz	#reset

	movk	1,a14
	move	a14,@time_out

	DIE

clock_digits
;When player select time gets down to 5 seconds, display it...
;a10=select_clock *PROC

	movi	[0cbh,0],a0			;x pos
	movi	[232,0],a1			;y pos
	movi	FNT9_5,a2			;* image
	movi	104+200,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ
	movk	4,a11
#loop0	callr	obj_off

#loop	SLEEPK	1
	move	@time_out,a0
	janz	SUCIDE

	move	@OLD_PSTATUS,a0
	jrnz	#loop0

     	move	*a10(PA9),a0
	srl	6,a0
	cmp	a0,a11
	jrz	#loop
	cmpi	6,a0
	jrge	#loop0

;New digit time	
	move	a0,a11
	sll	5,a0

	addi	digits_tbl,a0
	move	*a0,a0,L		;* image

	move	*a8(OCTRL),a1		;DMA flags
	calla	change_image
	callr	obj_on

	move	a11,a14
	callr	setup_clock_sound
	jruc	#loop

digits_tbl
	.long	FNT9_0,FNT9_1,FNT9_2,FNT9_3,FNT9_4
	.long	FNT9_5,FNT9_6,FNT9_7,FNT9_8,FNT9_9


	.ref	wait_on_butn

#*****************************************************************************
* One player ladder of progression
*

 SUBR	pregame_show


;This will be the ladder type screen, showing the 1 player
;game progression.  Chooses the CPU opponent.

;Show 1 player game ladder of progression
;Scroll horizontally to the next challenger
	
 .if DEBUG
	move	@skip_select,a0
	jrz	#noskp

	RETP
#noskp
 .endif

	move	@PSTATUS,a0
	cmpi	3,a0
	jrnz	#oneplyrgm

	JSRP	CLOSE_PROGRESS_SCREEN

	RETP

;0	(Bret)
;1	(Razor)
;2	(Taker)
;3	(Yoko)
;4	(Shawn)
;5	(Bam Bam)
;6	(Doink)
;7	spare
;8	(Lex)

#oneplyr_opp
	.word	1,6,1,2,3,4,5,8,1,6
	.word	5,6,1,2,3,4,5,8,1,6
	.word	5,6,1,2,3,4,5,8,1,6

#oneplyrgm

	movk	15,a8
	movk	4,a9
	JSRP	CLOSE_SCREEN_LINE

	calla	SPECIAL_WIPEOUT
	JAUC	PUT_UP_PROGRESS
	RETP

	.ref	osgemd_ascii
#ln1_setup
	JAM_STR	osgemd_ascii,8,0,200,80,BLUE,0

#ln2_setup
	JAM_STR	osgemd_ascii,8,0,200,110,BLUE,0

#str_text
	.string	"SINGLE PLAYER GAME",0
#str_text2
	.string	"LADDER OF PROGRESSION",0
	.even

#ladder_mod
	.long	slateBMOD		;wrestler select map
	.word	0,0
	.long	0


#*****************************************************************************
*
* INPUT:	a8 = * object
*-----------------------------------------------------------------------------

 SUBRP	obj_on
 	move	*a8(OYPOS),a0
	andni	400h,a0
	move	a0,*a8(OYPOS)
 	rets


#*****************************************************************************
*
* INPUT:	a8 = * object
*-----------------------------------------------------------------------------

 SUBRP	obj_off
 	move	*a8(OYPOS),a0
	ori	400h,a0
	move	a0,*a8(OYPOS)
 	rets

******************************************************************************

buyin_text

	movk	ADJFREPL,a0		;Are we in free play?
	calla	GET_ADJ
	jrz	#not_freeply

;Print free play
	movi	#ln0_setup,a2
	move	a10,a10
	jrz	#ok2c
	movi	#ln0_setupb,a2
#ok2c	calla	setup_message

	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a0
	add	a10,a0
	move	a0,@mess_objid

	movi	#str_text0,a4
	calla	print_string_C2

;Print centered "PLEASE CONTINUE" message
	movi	#ln1_setup,a2
	move	a10,a10
	jrz	#ok
	movi	#ln1_setupb,a2
#ok	calla	setup_message

	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a0
	add	a10,a0
	move	a0,@mess_objid

	movi	#str_text,a4
	calla	print_string_C2

	movi	#ln2_setup,a2
	move	a10,a10
	jrz	#ok4
	movi	#ln2_setupb,a2
	calla	setup_message

	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a0
	add	a10,a0
	move	a0,@mess_objid

	movi	#str_text2,a4
	calla	print_string_C2

	rets

#not_freeply
;Print how many credits to start
	PUSH	a8
	movk	ADJCCONT,a0
	calla	GET_ADJ 		;GET NUMBER NEEDED
	move	a0,a3
	cmpi	10,a0
	jrlt	#max
	movk	9,a0
#max
	sll	5,a0
	addi	digits_tbl,a0
	move	*a0,a2,L		;* image

	movi	[050,0],a0			;x pos
	cmpi	1,a3
	jrnz	#not1
	movi	[054,0],a0			;x pos
#not1	move	a10,a10
	jrz	#zp1
	movi	[0122h,0],a0			;x pos
	cmpi	1,a3
	jrnz	#zp1
	movi	[0126h,0],a0			;x pos
#zp1
	movi	[110,0],a1			;y pos
	movi	104+200,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a5
	add	a10,a5				;object ID
	clr	a6				;x vel
	clr	a7	 			;y vel
	movi	FNT9YEL_P,b0
	calla	BEGINOBJP
	PULL	a8

	movi	#ln3_setup,a2
	move	a10,a10
	jrz	#ok2
	movi	#ln3_setupb,a2
#ok2	calla	setup_message

	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a0
	add	a10,a0
	move	a0,@mess_objid

	movi	#str_text3,a4
	movk	ADJCCONT,a0
	calla	GET_ADJ 		;GET NUMBER NEEDED
	cmpi	1,a0
	jrnz	#not1b
	movi	#str_text3b,a4
#not1b
	calla	print_string_C2

	movi	#ln4_setup,a2
	move	a10,a10
	jrz	#ok2B
	movi	#ln4_setupb,a2
#ok2B	calla	setup_message

	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a0
	add	a10,a0
	move	a0,@mess_objid

	movi	#str_text4,a4
	calla	print_string_C2


;Print "challenger needed" message
	movi	#ln1_setupx,a2
	move	a10,a10
	jrz	#ok3
	movi	#ln1_setupxb,a2
#ok3	calla	setup_message

	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a0
	add	a10,a0
	move	a0,@mess_objid

	movi	#str_text,a4
	calla	print_string_C2

	movi	#ln2_setupx,a2
	move	a10,a10
	jrz	#ok4
	movi	#ln2_setupxb,a2
#ok4	calla	setup_message

	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a0
	add	a10,a0
	move	a0,@mess_objid

	movi	#str_text2,a4
	calla	print_string_C2

	rets

#ln0_setup
	JAM_STR	font9_ascii,8,0,81,120,FNT9YEL_P,0
#ln0_setupb
	JAM_STR	font9_ascii,8,0,321,120,FNT9YEL_P,0

#ln1_setup
	JAM_STR	font9_ascii,8,0,81,80,FNT9WHT_P,0
#ln1_setupb
	JAM_STR	font9_ascii,8,0,321,80,FNT9WHT_P,0

#ln2_setup
	JAM_STR	font9_ascii,8,0,81,95,FNT9WHT_P,0
#ln2_setupb
	JAM_STR	font9_ascii,8,0,321,95,FNT9WHT_P,0

#ln1_setupx
	JAM_STR	font9_ascii,8,0,81,60,FNT9WHT_P,0
#ln1_setupxb
	JAM_STR	font9_ascii,8,0,321,60,FNT9WHT_P,0

#ln2_setupx
	JAM_STR	font9_ascii,8,0,81,75,FNT9WHT_P,0
#ln2_setupxb
	JAM_STR	font9_ascii,8,0,321,75,FNT9WHT_P,0


#ln3_setup
	JAM_STR	font9_ascii,8,0,81,110,FNT9YEL_P,0
#ln3_setupb
	JAM_STR	font9_ascii,8,0,321,110,FNT9YEL_P,0

#ln4_setup
	JAM_STR	font9_ascii,8,0,81,125,FNT9YEL_P,0
#ln4_setupb
	JAM_STR	font9_ascii,8,0,321,125,FNT9YEL_P,0

#str_text
	.string	"PLEASE",0
#str_text0
	.string	"FREE PLAY",0
#str_text2
	.string	"CONTINUE!",0
#str_text3
	.string	"  CREDITS",0
#str_text3b
	.string	"  CREDIT",0
#str_text4
	.string	"TO CONTINUE",0
	.even


******************************************************************************

	.ref	AUD1
	.ref	GET_CREDITS
	.ref	get_start_down
	.ref	get_but_val_cur

#cont_timer	.equ	9
#resets_allowed	.equ	25		;People whack on button to reset

buyin_counter

	move	a10,*a13(PDATA+16)	;0 or 1

	movi	AUD_CONTOFF,a0		;increment the offered audit
	calla	AUD1

	movi	#resets_allowed,a7

	jruc	#loop_start

#coin_loop_reset
	movi	#resets_allowed,a7

#loop_reset
	calla	DELOBJA8

#loop_start
	calla	GET_CREDITS
	move	a0,a6

	PUSH	a6,a7
	movi	[080,0],a0			;x pos
	move	*a13(PDATA+16),a10
	move	a10,a10
	jrz	#p1
	movi	[0320,0],a0			;x pos
#p1
	movi	[208,0],a1			;y pos
	movi	FNT9_9,a2			;* image
	movi	104+200,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a5
	add	a10,a5
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ
	PULL	a6,a7

	move	@PSTATUS,a9
	movi	TSEC*2,a10
	movi	#cont_timer,a11

#loop
	PUSHP	a6,a7
	SLEEPK	1
	PULLP	a6,a7

;Buyin check
	move	@PSTATUS,a14
	move	*a13(PDATA+16),a0
	btst	a0,a14
	jrne	#buyin

;More credits check
	calla	GET_CREDITS
	cmp	a0,a6
	jrne	#coin_loop_reset

;Start button check
	move	a7,a7
	jrz	#skip_start_check

;Any player who hits his start will reset buyin timer!
	move	*a13(PDATA+16),a0
	calla	get_start_down
	move	a0,a0
	jrnz	#start_hit

	move	*a13(PDATA+16),a0
	xori	1,a0
	calla	get_start_down
	move	a0,a0
	jrnz	#start_hit

#skip_start_check

;Regular button check

;Make these button presses player specific!

	move	*a13(PDATA+16),a0
	calla	get_but_val_down
	move	a0,a0
	jrnz	#new_button_press

	move	*a13(PDATA+16),a0
	calla	get_but_val_cur
	move	a0,a0
	jrnz	#old_button_press

;No buttons down
	dsj	a10,#loop

#sec_elapsed
;A second has elapsed.
	dec	a11
	jrz	#timeout
	movi	TSEC*2,a10

	move	a11,a14
	X32	a14
	addi	digits_tbl,a14
	move	*a14,a0,L
	calla	civanic

	move	a11,a14
	callr	setup_clock_sound

	jruc	#loop

setup_clock_sound
;	x16	a14
;	addi	which_tick_tock,a14
;	move	*a14,a0
	CREATE0	do_next_tick
	movi	0B7H,a0
	calla	triple_sound
	rets

do_next_tick
	SLEEP	12
	MOVI	0B8H,A0
	CALLA	triple_sound
	DIE

;which_tick_tock
;	.word	0b7h,0b8h,0b7h,0b8h
;	.word	0b7h,0b8h,0b7h,0b8h
;	.word	0b7h,0b8h,0b7h,0b8h

#new_button_press
;New press.  skip a digit
	clr	a10
	jruc	#sec_elapsed

#old_button_press
;Button being held.  Run clock at triple rate
	subk	20,a10
	jrp	#loop
	jruc	#sec_elapsed

#start_hit
;A PSTATUS-active player has hit a start button.
	dec	a7
	jruc	#loop_reset

#buyin
;Someone has bought in.
	movi	AUD_CONTTAKN,a0		;inc the conts taken audit
	calla	AUD1
	clr	a0
	move	a0,@OLD_PSTATUS
	move	a0,@blow_out

	DIE

#timeout
;Time ran out!
;If the other player has not bought in, then goto game over
;If the other player is active, and has already chosen his fighter, then
;immediately go into the match
;If he hasn't chosen his fighter, replot the text messages to now read
;Challenger needed, Insert x coins to start (The player blew his opportunity
;to continue the game at the potentially lower price!)
;
	clr	a0
	move	a0,@OLD_PSTATUS

	movk	1,a0
	move	a0,@blow_out

	DIE

******************************************************************************
	.end
