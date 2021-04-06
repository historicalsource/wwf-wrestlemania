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

	.include	"fontsimg.glo"
	.include	"mainimg.glo"
	.include	"bgndtbl.glo"
	.include	"imgtbl.glo"

#*****************************************************************************

	;from AUDIT.ASM
	.ref	GET_ADJ,CR_STRTP

	;from BAKGND.ASM
	.ref	BAKMODS,BGND_UD1

	;from DCSSOUND.ASM
	.ref	triple_sound,wmania_tune

	;from DISPLAY.ASM
	.ref	BEGINOBJ_TBL

	;from HSTD.ASM
	.ref	RC_BYTE

	;from MAIN.ASM
	.ref	dpageflip,IRQSKYE

	;from ROBO.ASM
	.ref	civanic

	;from UTIL.ASM
	.ref	WIPEOUT,get_all_buttons_down,get_stick_val_down
	.ref	get_but_val_down,RNDRNG0,get_start_cur,get_stick_val_cur
	.ref	CYCLE_TABLE

	;from WRESTLE.ASM
	.ref	HALT,PSTATUS,PCNT
	.ref	change_image

	;for LIFEBAR.ASM
	.def	num_wrestlers
	.ref	start_credbox

	;for ATTRACT.ASM
	.def	wrestler_mugs,wrestler_attributes,attbars

	;for WRESTLE.ASM
	.def	wrestler_audits


#*****************************************************************************

	BSSX	index1,		16 	;player 1 cursor position
	BSSX	index2,		16 	;player 2 cursor position
	.bss	time_out,	16	;time out flag
	.bss	active_flag,	16	;0:player 1 active, 1:player 2 active

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
	.word	AUD_ABOMB,AUD_ABOMBHW,AUD_ABOMBC,AUD_ABOMBCW
	.word	AUD_LLUGE,AUD_LLUGEHW,AUD_LLUGEC,AUD_LLUGECW
wrestler_auditsX

SKIP_SELECT	equ	0

#*****************************************************************************

 SUBR	select_screen

;Temp, stuff @index1,2 for testing wrestlers.

 .if SKIP_SELECT
;0	(Bret) 
;1	(Razor)
;2	(Taker)
;3	(Yoko)
;4	(Shawn)
;5	(Bam Bam)
;6	(Doink)
;7	(Adam)
;8	(Lex)

	movk	6,a0
	move	a0,@index1
	movk	6,a0
	move	a0,@index2

	RETP
 .endif

;MJT - Start

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movi	#plyrsel_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1		;create objects for background

	;play wrestlemania tune
	.if MUSIC_ON
	CREATE0	wmania_tune
	.endif

	;draw the croutons and their associated pix
	movi	crouton_pos_table,a9
	movi	#crouton_pic_table,a10
	move	*a9+,a0
#crouton_loop
	move	*a9+,a1


	movi	CRUTPLT_G,a2
	movi	#crutplt_z,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7
	sll	16,a0
	sll	16,a1
	PUSH	a0,a1,a6,a7

	.if 0
	calla	BEGINOBJW

	.endif


	PULL	a0,a1,a6,a7
	move	*a10+,a2,L
	movi	#crutpic_z,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	calla	BEGINOBJW

	move	*a9+,a0
	jrnz	#crouton_loop

	calla	start_credbox

	CREATE0	select_clock
	move	a0,a10
	CREATE0	clock_digits


	;initialize flags
	move	@PSTATUS,a14
	move	a14,@active_flag

	clr	a14
	move	a14,@time_out

	;create the player cursors
	clr	a10
	CREATE	SELECT_PID,player_cursor
	movk	1,a10
	CREATE	SELECT_PID,player_cursor

	;wait for them to finish up


	SLEEPK	1

	movk	1,a0
	move	a0,@DISPLAYON
	calla	display_unblank

;MJT - End

#waitloop
	SLEEPK	1
	move	@active_flag,a14
	jrnz	#waitloop

	;players have chosen their guys.  wait a sec, then bail
	movi	TSEC,a8
#final_waitloop
	SLEEPK	1

	move	@active_flag,a14	;don't quit if someone jumps in here
	jrnz	#waitloop

	dsj	a8,#final_waitloop

	RETP


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
;MJT
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
#rnd_wander	equ	18		;rnd moves before home-in begins

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

;MJT - start
	clr	a0
	move	a0,*a13(#CNTR)

	;create the name text
	move	*a9(#PI_STARTNAME),a0,L
	calla	BEGINOBJ_TBL
	move	a8,*a13(#NAME),L

	;active?
	move	@PSTATUS,a14
	btst	a10,a14
	jrnz	#begin_select

	;inactive.  wait for buyin
	;create the insert coin/press start message
	calla	CR_STRTP
	jrhs	#enough_money

#no_money
	;no creds.  flash 'insert coin' message while waiting for cash
#cred_waitloop
	SLEEPK	1

	callr	#blink

	calla	CR_STRTP
	jrhs	#enough_money
	jruc	#cred_waitloop

#enough_money

	;there's enough money.  flash 'press start' message and wait
	move	*a13(#NAME),a8,L
	movi	WF_START,a0
	calla	civanic

#start_waitloop
	SLEEPK	1

	callr	#blink

	move	@PSTATUS,a14
	btst	a10,a14
	jrz	#start_waitloop

	move	*a8(OXPOS),a0
	andi	1ffh,a0
	move	a0,*a8(OXPOS)

#begin_select
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

;MJT Start
;	;create our attrib text
;	move	*a9(#PI_ATTTXT),a0,L
;	calla	BEGINOBJ_TBL
;	move	*a8(OXVAL),a0,L
;	move	*a8(OYVAL),a1,L
;
;	;create the att bars
;	addi	[63,0],a0
;	addi	[12,0],a1
;	movi	ATTMTR_0,a2
;	movi	atttxt_z,a3
;	movi	DMAWNZ,a4
;	movi	CLSNEUT,a5
;	clr	a6
;	clr	a7
;
;	PUSH	a10,a11
;
;	movi	4,a10			;bar count
;	move	a13,a11
;	addi	#ATT1,a11
;
;#abc_loop
;	PUSH	a0,a1,a2,a3,a4,a5,a6,a7
;	calla	BEGINOBJ
;	PULL	a0,a1,a2,a3,a4,a5,a6,a7
;	move	a8,*a11+,L
;	addi	[8,0],a1
;	dsj	a10,#abc_loop
;
;	PULL	a10,a11
;MJT End

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
	jrp	#norm
	movk	8,a14
	move	a14,*a13(#CNTR)

	PUSH	a6,a7,a9
	movi	0202h,a9
	CREATE0	FLASHME
	.ref	FLASHME
	PULL	a6,a7,a9
#norm

;MJT - End
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
	;button checks
	move	a10,a0
	calla	get_but_val_down
	TEST	a0
	jrnz	#but_hit

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
	movi	7,a0
	calla	RNDRNG0
	move	a0,*a13(#RND_DEST)
	movi	#rnd_movespeed,a6
	movi	#rnd_wander,a7
	jruc	#waitloop

#but_hit
	;they hit a button.  Stick 'em with the current guy.
	move	*a9(#PI_INDEX),a0,L
	;rewire kludge
	X16	a11
	addi	scramble_table,a11
	move	*a11,a11,W
	move	a11,*a0

	;make a joyful noise unto the player			    
	move	*a9(#PI_SELSOUND),a0
	calla	triple_sound

	;clear our bit in the active flag
	move	@active_flag,a0
	inc	a10
	andn	a10,a0
	move	a0,@active_flag

	;flash over the crouton
	;synch!  begin flashing on an even PCNT
	move	@PCNT,a14
	btst	0,a14
	jrnz	#synch
	SLEEPK	1

#synch
	move	*a13(#HILITE),a8,L
;MJT
;	movi	0202h,a14
;	move	a14,*a8(OCONST)

	movi	TSEC/2,a11
#flashloop
	movi	0202h,a14
	move	a14,*a8(OCONST)
	move	*a8(OCTRL),a14
	xori	M_CONZER,a14
	move	a14,*a8(OCTRL)
	SLEEPK	1
	dsj	a11,#flashloop

	move	*a8(OCTRL),a14
	andni	M_CONZER,a14
	move	a14,*a8(OCTRL)

	movi	hilite_z,a14
	move	a14,*a8(OZPOS)

	move	*a13(#HIPLATE),a8,L
	movi	hiplate_z,a14
	move	a14,*a8(OZPOS)
	
	DIE

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

	move	a2,*a7(OXPOS)
	move	a2,*a8(OXPOS)
	move	a3,*a7(OYPOS)
	move	a3,*a8(OYPOS)

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


;MJT Start
;********
;* updates the attribute bars
;
; SUBRP	#update_attbars
;
;	PUSH	a7,a10,a11
;
;
;	;rewiring kludge
;	X16	a11
;	addi	scramble_table,a11
;	move	*a11,a11,W
;
;	move	a11,a10
;	X64	a10
;	addi	wrestler_attributes,a10
;	move	a13,a11
;	addi	#ATT1,a11
;
;	movi	4,a7
;#ualoop
;	move	*a10+,a0,W
;	X32	a0
;	addi	attbars,a0
;	move	*a0,a0,L
;	move	*a11+,a8,L
;	calla	civanic
;	dsj	a7,#ualoop
;
;	PULL	a7,a10,a11
;	rets
;
;wrestler_attributes
;	.word	0,1,2,3
;	.word	4,5,6,7
;	.word	8,9,0,1
;	.word	2,3,4,5
;	.word	6,7,8,9
;	.word	0,1,2,3
;	.word	4,5,6,7
;	.word	8,9,0,1
;	.word	9,9,9,9

;MJT End

scramble_table	;swap bret and doink on the select page
	.word	6
	.word	1,2,3,4,5
	.word	0
	.word	8		;put lex in place of adam

;attbars
;	.long	ATTMTR_0,ATTMTR_1,ATTMTR_2,ATTMTR_3,ATTMTR_4
;	.long	ATTMTR_5,ATTMTR_6,ATTMTR_7,ATTMTR_8,ATTMTR_9

#info
	.long	#p1info,#p2info

#p1info
	.long	#hi_b,#plt_b			;hilite, crouton
	.word	0				;start index
	.word	0+18+2,175			;mug position
	.word	DMAWNZ|M_3D|M_SCRNREL		;mug octrl
	.long	#p1name,latttxt			;start name,att text
	.long	index1				;report choice to
	.word	18h,35h				;cursor/select sounds

#p2info
	.long	#hi_r,#plt_r			;hilite, crouton
	.word	1				;start index
	.word	400-18,175			;mug position
	.word	DMAWNZ|M_3D|M_SCRNREL|M_FLIPH	;mug octrl
	.long	#p2name,ratttxt			;start name,att text
	.long	index2				;report choice to
	.word	19h,55h				;cursor/select sounds



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
	.long	ADAMMUG
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
ADAMMUG
	.long	ADMUG_A,ADMUG_B,ADMUG_C,ADMUG_D
	.long	ADMUG_E,ADMUG_F,ADMUG_G,ADMUG_H,0
LUGERMUG
	.long	LXMUG_A,LXMUG_B,LXMUG_C,LXMUG_D
	.long	LXMUG_E,LXMUG_F,LXMUG_G,LXMUG_H,0

name_tbl
	.long	NAM_BRT,NAM_RZR,NAM_UND,NAM_YOK
	.long	NAM_SHN2,NAM_BAM2,NAM_DNK,NAM_ADM,NAM_LEX

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
	move	*a10(PA9),a0
	srl	6,a0
	cmp	a0,a11
	jrz	#loop
	cmpi	6,a0
	jrge	#loop0

;New digit time	
	move	a0,a11
	sll	5,a0
	addi	#digits_tbl,a0
	move	*a0,a0,L		;* image

	move	*a8(OCTRL),a1		;DMA flags
	calla	change_image
	callr	obj_on

	movi	clock_snd,a0
	calla	triple_sound
	jruc	#loop

#digits_tbl
	.long	FNT9_0,FNT9_1,FNT9_2,FNT9_3,FNT9_4
	.long	FNT9_5,FNT9_6,FNT9_7,FNT9_8,FNT9_9


#*****************************************************************************
* "Tonight's Matchup"-type stuff.
*

 SUBR	pregame_show

;This will be the ladder type screen, showing the 1 player
;game progression.  Chooses the CPU opponent.
	
	move	@index1,a0
	jrnn	#ok

;Chooses CPU controlled player 1
	movk	6,a0				;Doink
	move	a0,@index1

#ok
	move	@index2,a0
	jrnn	#ok2

;Chooses CPU controlled player 2
	movk	6,a0				;Doink
	move	a0,@index2

#ok2
	RETP

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
	.end
