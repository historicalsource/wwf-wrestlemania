**************************************************************
*
* Software:		Jake Simpson
* Initiated:		10/11/94
*
* Modified:
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"screen.asm"
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
	.INCLUDE	"SCREEN.TBL"
	.include	"imgtbl.glo"


	.ref	triple_sound
	.ref	FADERAM, RNDRNG0
	.ref	ZERO_BITS
	.ref	HALT
	.ref	dpageflip
	.REF	dpageflip_off
	.ref	clear_objs
	.ref	IRQSKYE
	.ref	BGND_UD1
	.ref	BAKMODS
	.ref	pal_getf
	.ref	SYSCOPY
	.REF	pal_clean
	.REF	WHAT_SPEED
	.REF	GAMSTATE
	.REF	get_all_buttons_cur2

;	.GLOBAL	CLOSE_SCREEN_BOX, OPEN_SCREEN_BOX 
;	.GLOBAL	CLOSE_SCREEN_BOX_CENTER, OPEN_SCREEN_BOX_CENTER 
	.GLOBAL	CLOSE_SCREEN_LINE, OPEN_SCREEN_LINE
	.GLOBAL	BLOW_0_TO_1,RESET_FROM_PIXEL_WIPE
	.GLOBAL	SET_UP_PIXEL_WIPE
	.DEF	DUMRETS
	.def	special_screen
	.DEF	RESETUP_LINES
	.DEF	dma_it_out
	.def	LINES

	.DEF	CLOSE_VERT_SCREEN_LINE
	.DEF	OPEN_VERT_SCREEN_LINE
	.DEF	LINES_VERT

	.def	HORZTRN1,HORZTRN2

	BSSX	WHICH_SCREEN,32
	BSSX	TOP_LEFT,32
	BSSX	BOT_RIGHT,32
	.BSS	LINE_1,64*8
	.bss	LINE_START,32
	.BSS	WHICH_WAY,16
	.bss	special_screen,16
	.bss	which_pal,16

;array size = 2560*32
;ARRAYS	.equ	FADERAM
	.bss	ARRAYS,256*16*80

	.text

GROW_SCREEN
	RETP

;**************************************************************************
;*											      *
;* DO NOT call WIPEOUT or any of that stuff before calling this routine ! *
;* In order to use the pixel wipes, you must call this routine before doing *
;* anything else. It will do ALL screen setting up for you. Don't mess around *
;* with that BLANK or UNBLANK thing. Call this routine with A0 set to the *
;* background module you want to display. Once this routine is done, create *
;* the objects you want to display etc and then do a sleep of 1. Then 	 *
;* JSRP BLOW_0_TO_1 or BLOW_0_TO_1 and then when returned, call 		 *
;* RESET_FROM_PIXEL_WIPE and resume normal processing.				 *
;*											      *
;**************************************************************************
SET_UP_PIXEL_WIPE
	PUSH	A0
	clr	a0
	move	a0,@HALT
	move	a0,@dtype		;2d mode
	move	a0,@IRQSKYE
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	inc	a0
	move	a0,@special_screen

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0

	CALLA	dpageflip_off
	calla	clear_objs
	calla	ZERO_BITS

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	PULL	A0
	move	a0,@BAKMODS,L
	JAUC	BGND_UD1		;create objects for background

RESET_FROM_PIXEL_WIPE
	clr	a0
	move	a0,@special_screen
	movk	1,a0			;page flipping on
	move	a0,@dpageflip
	RETS

ARRAY_SIZE	.EQU	256*32

ARRAYA	.EQU	ARRAY_SIZE*0

ARRAYB	.EQU	ARRAY_SIZE*5

BLOW_0_TO_1
	CALLR	INIT_TABLES
	SLEEP	1
	MOVI	ARRAYA+ARRAYS,A3
	CALLR	RANDOMIZE_TABLES
	SLEEP	1
	MOVI	ARRAYB+ARRAYS,A3
	CALLR	RANDOMIZE_TABLES
	SLEEP	1

	CLR	A0
	MOVE	A0,@DISPLAYON
	SLEEP	1

	MOVI	1C0H,A9

	MOVK	10,A10
DO_NEXT_BLOCK
	MOVI	ARRAYA+ARRAYS,A8
	SLEEP	3
	CREATE0	DISPLAY_ARRAY
	ADDI	0A0H,A9
	MOVI	ARRAYB+ARRAYS,A8
	SLEEP	3
	CREATE0	DISPLAY_ARRAY
	ADDI	0A0H,A9
	DEC	A10
	JRNZ	DO_NEXT_BLOCK

	SLEEP	25

	MOVK	1,A0
	MOVE	A0,@DISPLAYON
	RETP

DISPLAY_ARRAY
	MOVI	100000H,A10

	callr	PAL_RAM_OFF

	movi	5,a0
next_copy
	pushp	a0
	CALLR	COPY_ARRAY
;	SUBI	256*32,A8
;	CALLR	PAL_RAM_ON
;	CALLR	COPY_ARRAY
	callr	PAL_RAM_OFF
	sleep	1
	pullp	a0
	dsjs	a0,next_copy
	DIE

COPY_ARRAY
	pushst
	dint
	movi	DMACMAP,a7
	MOVI	256,A2
	movi	SYSCINIT,a11
	move	a11,a5
	ANDi	0FFFFH-PALENB,a5
	.ALIGN
COPY_NEXT
	MOVE	*A8+,A3,L
	ADD	A9,A3
	MOVE	A3,A0
	ADD	A10,A0
	move	a5,@SYSCTRL
	MOVE	*A0,*A7
	move	a11,@SYSCTRL
	MOVE	*A0,*A3
	move	a5,@SYSCTRL
	move	*a0(1000h),*a7(0)
	move	a11,@SYSCTRL
	MOVE	*A0(1000H),*A3(1000H)
	DSJS	A2,COPY_NEXT
	popst
	RETS

PAL_RAM_ON
	movi	SYSCINIT,a11
	ANDi	0FFFFH-PALENB,a11
	move	a11,@SYSCOPY
	move	a11,@SYSCTRL
	rets

PAL_RAM_OFF
	movi	SYSCINIT,a11
	move	a11,@SYSCTRL
	move	a11,@SYSCOPY
	RETS

RANDOMIZE_TABLES
	MOVI	1279,A2
RAND_NEXT_POINT
	MOVE	A2,A0
	CALLA	RNDRNG0
	SLL	5,A0
	ADD	A3,A0
	MOVE	A2,A4
	SLL	5,A4
	ADD	A3,A4
	MOVE	*A0,A14,L
	MOVE	*A4,*A0,L
	MOVE	A14,*A4,L
	DSJS	A2,RAND_NEXT_POINT
	RETS

INIT_TABLES
	MOVI	010H,A4
	MOVI	2000H-(10*10H),A5
	MOVI	ARRAYA+ARRAYS,A1
	CALLR	INIT_ARRAY
	MOVI	ARRAYB+ARRAYS,A1

INIT_ARRAY
	MOVI	128,A3
	CLR	A0
NEXT_DOWN
	MOVI	10,A2
NEXT_ACROSS
	MOVE	A0,*A1+,L
	ADD	A4,A0
	DSJS	A2,NEXT_ACROSS
	ADD	A5,A0
	DSJS	A3,NEXT_DOWN
	RETS

** NOTE !!!! ALL SCREEN CLEAR AND OPENS MUST BE CALLED WITH A JSRP ****

;**************************************************************************
;*											      *
;* For close/open screen box, send the y:x coor you want to close		 *
;* to in a9. Send the duration of close in a8						 *
;*											      *
;**************************************************************************

	.IF	0

OPEN_SCREEN_BOX_CENTER
	MOVI	[127,200],A9
	MOVI	25,A8
OPEN_SCREEN_BOX
	MOVI	DRAW_BOXES,A0
	MOVE	A0,@WHICH_SCREEN,L
	CALLR	CALC_INCREMENTS

	NEG	A0
	NEG	A1
	NEG	A2
	NEG	A3

	MOVY	A9,A6
	MOVY	A9,A7
	SLL	16,A9
	MOVE	A9,A4
	MOVE	A9,A5
	JRUC	PUT_UP_BOX

CLOSE_SCREEN_BOX_CENTER
	MOVI	[127,200],A9
	MOVK	25,A8
CLOSE_SCREEN_BOX
	MOVI	DRAW_BOXES,A0
	MOVE	A0,@WHICH_SCREEN,L
	CALLR	CALC_INCREMENTS
	MOVI	[400,0],A5
	MOVI	[254,0],A7

PUT_UP_BOX
	CALLR	CALC_BOX
	PUSHP	A0,A1,A2,A3
	PUSHP	A4,A5,A6,A7
	SLEEP	1
	PULLP	A4,A5,A6,A7
	PULLP	A0,A1,A2,A3
	DSJS	A8,PUT_UP_BOX
	MOVI	DUMRETS,A1
	MOVE	A1,@WHICH_SCREEN,L
	CLR	A0
	MOVE	A0,@TOP_LEFT,L
	MOVE	A0,@BOT_RIGHT,L
	RETP

CALC_INCREMENTS
	MOVY	A9,A7
	CLR	A1
	MOVX	A9,A1
	SLL	16,A1
	DIVS	A8,A1
	MOVE	A1,A0
	CLR	A1
	MOVX	A9,A1
	MOVI	400,A5
	SUB	A5,A1
	SLL	16,A1
	DIVS	A8,A1

	CLR	A3
	MOVY	A7,A3
	DIVS	A8,A3
	MOVE	A3,A2
	CLR	A3
	MOVY	A7,A3
	SRL	16,A3
	MOVI	254,A5
	SUB	A5,A3
	SLL	16,A3
	DIVS	A8,A3

	CLR	A4
	CLR	A5
	CLR	A6
	CLR	A7
DUMRETS
	RETS

;A0 32BIT ADD FOR LEFT
;A1 32BIT ADD FOR RIGHT
;A2 32BIT ADD FOR TOP
;A3 32BIT ADD FOR BOTTOM
;A4 32BIT XPOS FOR LEFT
;A5 32BIT XPOS FOR RIGHT
;A6 32BIT YPOS FOR TOP
;A7 32BIT YPOS FOR BOTTOM

CALC_BOX
	ADD	A0,A4
	ADD	A1,A5
	ADD	A2,A6
	ADD	A3,A7
	MOVE	A4,A14
	SRL	16,A14
	MOVY	A6,A14
	MOVE	A14,@TOP_LEFT,L
	MOVE	A5,A14
	SRL	16,A14
	MOVY	A7,A14
	MOVE	A14,@BOT_RIGHT,L
	RETS

DRAW_BOXES
	MOVI	01000100H,A5
	CLR	A8
	MOVI	4a748c9H,A11
	MOVI	900C0000H,A12

	CLR	A10
	MOVI	[255,0],A1
	MOVE	@TOP_LEFT,A9
	jrz	no_draw_anything1
	MOVY	A1,A9

	callr	dma_it_out

no_draw_anything1
	MOVI	400,A1
	MOVE	@BOT_RIGHT,A10
	SUB	A10,A1
	jrz	no_draw_anything2
	jrn	no_draw_anything2
	MOVX	A1,A9
	CLR	A10
	MOVE	@BOT_RIGHT,A10

	callr	dma_it_out

no_draw_anything2
	CLR	A10
	MOVE	@TOP_LEFT,A10

	MOVE	@BOT_RIGHT,A9
	SUB	A10,A9
	JRZ	no_draw_anything4
	JRN	no_draw_anything4
	MOVE	@TOP_LEFT+010H,A14
	JRZ	no_draw_anything3
	JRN	no_draw_anything3
	SLL	16,A14
	MOVY	A14,A9

	callr	dma_it_out

no_draw_anything3

	CLR	A10
	MOVE	@TOP_LEFT,A10
	MOVE	@BOT_RIGHT,A14,L
	MOVY	A14,A10

	MOVI	254,A3
	SRL	16,A14
	SUB	A14,A3
	JRZ	no_draw_anything4
	JRN	no_draw_anything4
	SLL	16,A3
	MOVY	A3,A9

	callr	dma_it_out
no_draw_anything4

	RETS
	.ENDIF

;A5 SCALE
;A8 PAL|CONST
;A9 YSIZE|XSIZE
;A10 DAG
;A11 SAG
;A12 OCTRL|OFFSET
dma_it_out
	move	b2,a1
	addxy	a1,a10			;Add the page y offset : XPad
	mmtm	a4,a5,a8,a9,a10,a11,a12	;Save the dma regs
	addk	1,b13			;+1 Q cnt
	jrgt	#nxt			;DMA going?

	dint

	setf	1,0,0			;>Enable DMA int
	movk	1,a1
	move	a1,@INTENB+1		;X1E
	setf	16,1,0

	move	*b11,b0
	jrn	#dmaok			;DMA busy?

	move	b13,b13
	jrn	#dmaok			;DMA int done?

	trap	1			;Cause DMA int

#dmaok	eint
#nxt
DUMRETS
	rets

;#**************************************************************************
;*											      *
;* ENTRY A8=SPEED OF ONE LINE, A9=DELAY BETWEEN EACH LINE (IF NEG START A *
;* at the top, otherwise start at the bottom						 *
;*											      *
;**************************************************************************
OPEN_VERT_SCREEN_LINE

	move	@WHAT_SPEED,A8

	MOVI	HORZTRN1P,A0
	CALLA	pal_getf
	move	a0,@which_pal

	MOVI	[0,400],A1
	MOVE	A1,@TOP_LEFT,L
	CLR	A1
	MOVE	A1,@BOT_RIGHT,L

	MOVI	[256,0],A0
	CLR	A1
	CLR	A3
	CALLR	SET_INITIAL_LINES

	MOVI	LINES_VERT,A1
	MOVE	A1,@WHICH_SCREEN,L

	MOVI	[255,0],A11
	DIVS	A8,A11
	NEG	A11

	MOVK	7,A10
#NEXT_LINE2B
	movk	18,a0
	calla	triple_sound
	CREATE0	MOVE_LINE_VERT
	MOVE	A9,A0
	CALLA	PRCSLP
	DEC	A10
	JRNN	#NEXT_LINE2B

	MOVE	A8,A0
	SUB	A9,A0
	ADDK	2,A0
	CALLA	PRCSLP
	MOVI	DUMRETS,A1
	MOVE	A1,@WHICH_SCREEN,L
	CLR	A1
	MOVE	A1,@TOP_LEFT,L
	MOVE	A1,@BOT_RIGHT,L
;	CALLA	pal_clean
	RETP

;#**************************************************************************
;*											      *
;* ENTRY A8=SPEED OF ONE LINE, A9=DELAY BETWEEN EACH LINE                 *
;* IF DELAY IS NEGATIVE (IE TWOS COMPLEMENT) THEN GO FROM TOP DOWN        *
;*											      *
;**************************************************************************
CLOSE_VERT_SCREEN_LINE

	calla	get_all_buttons_cur2
	jrz	#reg_spd
	srl	1,a8
#reg_spd
	move	a8,@WHAT_SPEED
	MOVI	HORZTRN1P,A0
	CALLA	pal_getf
	move	a0,@which_pal

	CLR	A1
	MOVE	A1,@TOP_LEFT,L
	MOVE	A1,@BOT_RIGHT,L

	CLR	A0
	CLR	A3
	MOVI	[256,0],A1
	CALLR	SET_INITIAL_LINES

	MOVI	LINES_VERT,A1
	MOVE	A1,@WHICH_SCREEN,L

	MOVI	[255,0],A11
	DIVS	A8,A11

	MOVK	7,A10
#NEXT_LINE2A
	movk	18,a0
	calla	triple_sound
	CREATE0	MOVE_LINE_VERT
	MOVE	A9,A0
	CALLA	PRCSLP
	DEC	A10
	JRNN	#NEXT_LINE2A

	MOVE	A8,A0
	SUB	A9,A0
	ADDK	2,A0
	CALLA	PRCSLP
	MOVI	DUMRETS,A1
	MOVE	A1,@WHICH_SCREEN,L
	CLR	A1
	MOVE	A1,@TOP_LEFT,L
	MOVE	A1,@BOT_RIGHT,L
;	CALLA	pal_clean
	RETP

MOVE_LINE_VERT
	MOVE	A11,A11
	JRNN	NO_NEED_TO_RESET_NOW

	MOVE	A10,A1
	MOVI	50,A3
	MPYU	A3,A1
	MOVE	A1,@TOP_LEFT

NO_NEED_TO_RESET_NOW

	MOVE	A10,A9
	SLL	6,A9
	ADDI	LINE_1,A9
ADD_NEXT_BIT_TO_LINE
	MOVE	A10,A0
	SRL	1,A0
	JRNC	YOU_STAY_HERE
	MOVE	*A9,A0,L
	SUB	A11,A0
	MOVE	A0,*A9,L
YOU_STAY_HERE
	MOVE	*A9(020H),A0,L
	ADD	A11,A0
	MOVE	A0,*A9(020H),L
	SLEEPK	1
	DSJS	A8,ADD_NEXT_BIT_TO_LINE
	MOVE	A11,A11
	JRN	WE_OPENING
	MOVI	[100H,0],A0
	MOVE	A0,*A9(020H),L
	CLR	A0
	MOVE	A0,*A9,L

	MOVI	9,A1
	SUB	A10,A1
	MOVI	50,A3
	MPYU	A3,A1
	NEG	A1
	MOVE	A1,@BOT_RIGHT
	DIE

WE_OPENING
	CLR	A0
	MOVE	A0,*A9(020H),L
	MOVI	[100H,0],A0
	MOVE	A0,*A9,L
	DIE

LINES_VERT
	MOVI	01000100H,A5
	CLR	A8
	MOVI	[256,50],A9
	move	@which_pal,a8
	MOVI	0d0020000H,A12

	CLR	A14
	MOVI	LINE_1,A3,L
	MOVK	8,A2
DO_NEXT_VERT_LINE
	CALLR	DISPLAY_VERT_LINE
	DSJS	A2,DO_NEXT_VERT_LINE
	RETS

DISPLAY_VERT_LINE
	MOVE	@VERTTRN1+040H,A11,L
	MOVE	A2,A0
	SRL	1,A0
	JRNC	GOT_TOP_BAR
	MOVE	@VERTTRN2+040H,A11,L
GOT_TOP_BAR

	MOVE	A14,A10
	SRL	16,A10
	MOVE	*A3+,A0,L	;POSITION
	MOVY	A0,A10
	MOVE	*A3+,A0,L	;SIZE
 	SRA	16,A0
	JRZ	NO_DISPLAY_VERT_LINE
	JRN	NO_DISPLAY_VERT_LINE
	MOVE	A0,A1
	SLL	16,A0
	MOVY	A0,A9

	MOVE	A2,A6
	SRL	1,A6
	JRC	NO_SHIFT_SAG
	MOVI	256,A6
	SUB	A1,A6
	MOVI	50,A1
	MPYU	A6,A1
	MOVE	A1,A6
	SLL	2,A1
	ADD	A6,A1
	ADD	A1,A11
NO_SHIFT_SAG

	CALLR	dma_it_out
NO_DISPLAY_VERT_LINE
	ADDI	[50,0],A14
	RETS


;#**************************************************************************
;*											      *
;* ENTRY A8=SPEED OF ONE LINE, A9=DELAY BETWEEN EACH LINE (IF NEG START A *
;* at the top, otherwise start at the bottom						 *
;*											      *
;**************************************************************************
OPEN_SCREEN_LINE
	move	@WHAT_SPEED,A8
	MOVI	HORZTRN1P,A0
	CALLA	pal_getf
	move	a0,@which_pal

	MOVI	LINE_1+040H,A0
	MOVE	A0,@LINE_START,L
	CLR	A1
	CLR	A3
	MOVI	[400,0],A0
	CALLR	SET_INITIAL_LINES
	MOVI	[400,0],A11
	DIVS	A8,A11
	NEG	A11
	MOVE	A9,A9
	JRN	#SET_BOT_RIGHT
	MOVI	[254,0],A10
	MOVE	A10,@TOP_LEFT,L
	JRUC	DO_LINES
#SET_BOT_RIGHT
	MOVI	[254,0],A10
	NEG	A10
	MOVE	A10,@BOT_RIGHT,L
	JRUC	DO_LINES

;#**************************************************************************
;*											      *
;* ENTRY A8=SPEED OF ONE LINE, A9=DELAY BETWEEN EACH LINE                 *
;* IF DELAY IS NEGATIVE (IE TWOS COMPLEMENT) THEN GO FROM TOP DOWN        *
;*											      *
;**************************************************************************
CLOSE_SCREEN_LINE
	MOVE	@GAMSTATE,A14
	CMPI	INAMODE,A14
	JREQ	MAKE_IT_FAST

	calla	get_all_buttons_cur2
	jrz	#reg_spd2
MAKE_IT_FAST
	srl	1,a8
#reg_spd2
	move	a8,@WHAT_SPEED

	MOVI	HORZTRN1P,A0
;	MOVE	@GAMSTATE,A14
;	CMPI	INAMODE,A14
;	JRNE	NORMAL_COLOURS
;	MOVI	DRKTRPLTP,A0
;NORMAL_COLOURS
	CALLA	pal_getf
	move	a0,@which_pal

	MOVI	LINE_1,A0
	MOVE	A0,@LINE_START,L
	CLR	A0
	CLR	A3
	MOVI	[400,0],A1
	CALLR	SET_INITIAL_LINES

	MOVI	[400,0],A11
	DIVS	A8,A11
DO_LINES
	MOVE	A9,@WHICH_WAY
	MOVE	A9,A9
	JRNN	#BOTTOM_UP
	NEG	A9

;TOP DOWN
	MOVK	1,A10
#NEXT_LINE1

	MOVE	@GAMSTATE,A0
	CMPI	INAMODE,A0
	JREQ	NO_SOUNDS
	movk	18,a0
	calla	triple_sound
NO_SOUNDS
	CREATE0	MOVE_LINE
	MOVE	A9,A0
	JRZ	#NO_SLEEP_BETWEEN1
	CALLA	PRCSLP
#NO_SLEEP_BETWEEN1
	INC	A10
	CMPI	7,A10
	JRNE	#NEXT_LINE1
	JRUC	EXIT_CLOSE_LINE

#BOTTOM_UP
	MOVK	6,A10
#NEXT_LINE2
	MOVE	@GAMSTATE,A0
	CMPI	INAMODE,A0
	JREQ	NO_SOUNDS2
	movk	18,a0
	calla	triple_sound
NO_SOUNDS2
	CREATE0	MOVE_LINE
	MOVE	A9,A0
	JRZ	#NO_SLEEP_BETWEEN2
	CALLA	PRCSLP
#NO_SLEEP_BETWEEN2
	DSJS	A10,#NEXT_LINE2
EXIT_CLOSE_LINE
	MOVE	A8,A0
	SUB	A9,A0
	ADDK	2,A0
	CALLA	PRCSLP
	MOVI	DUMRETS,A1
	MOVE	A1,@WHICH_SCREEN,L
	CLR	A1
	MOVE	A1,@TOP_LEFT,L
	MOVE	A1,@BOT_RIGHT,L
	MOVE	@LINE_START,A1,L

	CMPI	LINE_1,A1
	JREQ	NO_CLEAR_OUT_PALS
	CALLA	pal_clean
NO_CLEAR_OUT_PALS
	RETP

SET_INITIAL_LINES
	MOVI	LINE_1,A2
	MOVE	A3,*A2+,L
	MOVE	A0,*A2+,L
	MOVE	A1,*A2+,L
	MOVE	A0,*A2+,L

	MOVE	A3,*A2+,L
	MOVE	A0,*A2+,L
	MOVE	A1,*A2+,L
	MOVE	A0,*A2+,L

	MOVE	A3,*A2+,L
	MOVE	A0,*A2+,L
	MOVE	A1,*A2+,L
	MOVE	A0,*A2+,L

	MOVE	A3,*A2+,L
	MOVE	A0,*A2+,L
	MOVE	A1,*A2+,L
	MOVE	A0,*A2+,L

	MOVI	LINES,A1
	MOVE	A1,@WHICH_SCREEN,L

	RETS

MOVE_LINE
	MOVE	A11,A11
	JRN	NO_DEC_A10
	DEC	A10
	JRUC	A10_POINTS_AT_START_LINE
NO_DEC_A10
	MOVI	43,A7
	DEC	A10
	MPYS	A10,A7
	INC	A10

	MOVE	@WHICH_WAY,A0
	JRNN	LINES_OPEN_DOWN

LINES_OPEN_UP
	ADDI	43,A7
	MOVI	254,A0
	SUB	A7,A0
	SLL	16,A0
	NEG	A0
	MOVE	A0,@BOT_RIGHT,L
	JRUC	A10_POINTS_AT_START_LINE

LINES_OPEN_DOWN
	SLL	16,A7
	MOVE	A7,@TOP_LEFT,L

A10_POINTS_AT_START_LINE
	MOVE	A10,A9
	SLL	6,A9
	ADDI	LINE_1,A9
EXPAND_LINE
	MOVE	A10,A0
	SRL	1,A0
	JRNC	NO_MOVE_LINE_X
	MOVE	*A9,A0,L
	SUB	A11,A0
	MOVE	A0,*A9,L
NO_MOVE_LINE_X
	MOVE	*A9(020H),A0,L
	ADD	A11,A0
	MOVE	A0,*A9(020H),L
	SLEEPK	1
	DSJS	A8,EXPAND_LINE
	MOVE	A11,A11
	JRNN	SET_LINES_SOLID
	CLR	A0
	MOVE	A0,*A9(020H),L
	DIE

SET_LINES_SOLID
	CLR	A0
	MOVE	A0,*A9,L
	MOVI	[400,0],A0
	MOVE	A0,*A9(020H),L

	MOVI	43,A7
	MPYS	A10,A7

	MOVE	@WHICH_WAY,A0
	JRN	LINES_CLOSE_DOWN

LINES_CLOSE_UP
	MOVI	254,A0
	SUB	A7,A0
	SLL	16,A0
	NEG	A0
	MOVE	A0,@BOT_RIGHT,L
	DIE

LINES_CLOSE_DOWN
	ADDI	43,A7
	SLL	16,A7
	MOVE	A7,@TOP_LEFT,L
	DIE

LINES
	MOVI	01000100H,A5
	CLR	A8
	move	@which_pal,a8
	MOVI	[43,400],A9
	MOVI	0d0020000H,A12

	CLR	A14
	MOVE	@LINE_START,A3,L
	MOVK	6,A2
DO_NEXT_LINE
	CALLR	DISPLAY_LINE
	DSJS	A2,DO_NEXT_LINE
	RETS

DISPLAY_LINE
	MOVE	@HORZTRN1+040H,A11,L
	MOVE	A2,A0
	SRL	1,A0
	JRNC	GOT_RIGHT_BAR
	MOVE	@HORZTRN2+040H,A11,L
GOT_RIGHT_BAR

	MOVE	*A3+,A0,L	;POSITION
	SRL	16,A0
	MOVX	A0,A10
	MOVY	A14,A10
	MOVE	*A3+,A0,L	;SIZE
	SRA	16,A0
	JRZ	NO_DISPLAY_LINE
	JRN	NO_DISPLAY_LINE

	MOVI	400,A1
	SUB	A0,A1
	MOVX	A1,A12

	MOVE	A2,A6
	MOVE	@LINE_START,A0,L
	CMPI	LINE_1,A0
	JREQ	WHICH_SIDE_CLIP
	DEC	A6
WHICH_SIDE_CLIP
	SRL	1,A6
	JRC	NO_SHIFT_CLIP
	MOVE	A1,A6
	SLL	2,A1
	ADD	A1,A6
	ADD	A6,A11
NO_SHIFT_CLIP

	CALLR	dma_it_out
NO_DISPLAY_LINE
	ADDI	[43,0],A14
	RETS

RESETUP_LINES
	MOVI	LINES,A0
	MOVE	A0,@WHICH_SCREEN,L
	MOVI	HORZTRN1P,A0
	CALLA	pal_getf
	move	a0,@which_pal
	rets

 SUBR    DRKTRPLTP
   .word   31 
   .word   00000h,00407h,00407h,00808h,00809h,00c09h,00809h,0100ah
   .word   0100ah,01009h,0100bh,00808h,00408h,00007h,00408h,01c0bh
   .word   0140ah,01409h,0180ah,01809h,01c0ah,0180ah,00c08h,00006h
   .word   0140dh,02410h,00004h,00003h,00001h,0344dh,05ef7h

******************************************************************************

	.end
