*旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
*�									�
*� File		:	display.asm					�
*� Contents	:	DMA object handler				�
*� Project	:	WWF Wrestlemania				�
*� Programmer	:							�
*�									�
*� COPYRIGHT (C) 1993 WILLIAMS ELECTRONICS GAMES, INC.			�
*�									�
*읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
*************************************************************************

	.file	"display.asm"
	.title	"DMA object handler"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"gsp.equ"
	.include	"sys.equ"
	.include	"mproc.equ"
	.include	"display.equ"
	.include	"macros.h"
	.include	"fontsimg.glo"
	.INCLUDE	"PLYR.EQU"

******************************************************************************
* EXTERNAL REFERENCES

	.REF	process_ptrs
	.ref	special_screen
	.REF	DUMRETS,WHICH_SCREEN
	.REF	TOP_LEFT,BOT_RIGHT
	.def	clear_objs
	.ref	FRANIMQ
	.ref	HALT
	.ref	SYSCOPY
	.ref	pal_getf
	.ref	IRQSKYE

	.DEF	SPECIAL_DISPLAY_INIT

******************************************************************************

;global variables

	.sect	"OFIXED"

OBJLST		.long	0	;*Active object list
OFREE		.long	0	;*Free object block
BAKLST		.long	0	;*Background list



GND_Y		.equ	116-40
GNDI_Y		.equ	116
GNDI_W		.equ	1277
GNDI_H		.equ	138
GND_H		.equ	GNDI_H+40
GZBASE		.equ	894


	.bss	present_pos,16
	BSSX	page_addr,32

	.bss	SCROLLX		,32	;X scroll value
	.bss	SCROLLY		,32	;Y scroll value
					;/ Must stay in order
	.bss	WORLDTLX	,32	;Left X screen coord (16:16)
	.bss	WORLDTLY	,32	;Top Y screen coord (16:16)
	.bss	WORLDTL		,32	;Top left world Y:X

	.bss	SCRNTL		,32	;TOP LEFT [Y,X] SCREEN (SCRN COORD.)
	.bss	SCRNLR		,32	;LOWER RIGHT [Y,X] SCREEN (SCRN COORD.)

	.bss	dpage		,16	;Display page; 0=Page0, -1=Page1
	.bss	dtype		,16	;Display type; 0=2D, 1=3D, -=Special
	.bss	dcode_p		,32	;!0=*Special code (^ must = neg)
	.bss	DMAQCUR		,32	;Misc DMAQ position

	.bss	OBJSTR,NOBJ*OBSIZ	;Object structure mem

QSIZE	.set	(NOBJ+GNDI_H)*BQCELL
QMSIZE	.set	NOBJ*BQCELL
	.bss	dmaq0		,QSIZE	;Main DMA queue
	BSSX	DMAQ		,QMSIZE	;Misc DMA queue

	BSSX	gndstat		,16	;!0=Show ground
	BSSX	gndpos_t	,16*GND_H
	BSSX	gndx		,32
	.bss	DISPLAYON	,16	;!0=Do display processing
;	BSSX	QDMAFLG		,16	;!0=Misc DMAQ being updated

	BSSX	_3dstat		,16	;!0=Show polygons


	.text


******************************************************************************
* NO CODE BEFORE DMA INT!!! (Cache aligned)
*
#*****************************************************************************
* DMA interrupt
* B12=*End of DMA regs
* B13=DMAQ count-1 or Neg
* B14=*Next DMAQ fetch

 SUBR	dma_irq

	move	-*b14,-*b12,L		;[Y SCALE : X SCALE]
	move	-*b14,-*b12,L		;[COLOR CONST : PAL REGISTER]
	move	-*b14,-*b12,L		;[HEIGHT : WIDTH]
	move	-*b14,-*b12,L		;[DEST Y : DEST X]
	move	-*b14,-*b12,L		;[SOURCE ADDRESS]
	move	-*b14,-*b12,L		;[CNTRL REG-DMA go! : OFFSET/CLIP]

	addi	0c0h,b12		;DMAREGS (End of DMA)
	subk	1,b13
	jrn	#done			;Queue empty?
	RETI

	push	b11
	move	@present_pos,b11
	cmp	b11,b13
	jreq	do_shadows
	pull	b11
	reti

#done
	setf	1,0,0			;Disable dma interrupt
	move	b12,@INTENB+1		;Clr X1E
	clr	b13			;For safety!
	subk	1,b13			;-1
	reti

do_shadows
	pull	b11
	pushst
	dint
	callr	PLACE_SHADOWS
	popst
	reti


#*****************************************************************************
* Load DMA Q from obj list (2D type)
* A0=*Obj list
* A4=*DMAQ next free spot
* A13=Screen BR, A14=Screen TL
* B2=Y offset for top of page : XPad offset
* B4=World Y:X
* B5=OFLAGS offset
* B6=World center scrn X * 64K
* B11=*DMACTRL

dma_objlst2d
;	movi	[100h,100h],a5		;A5=Y:X scale
	jruc	#nxt

	.align

#lp
	MOVE	*A0(OFLAGS),A1
	BTST	B_NODISP,A1
	JRNZ	#nxt
	move	*a0(OSCALE),a5,L

	move	b5,a3
	add	a0,a3
	move	*a3+,a1			;Get OFLAGS
	mmfm	a3,a12,a11,a9,a8

	move	*a0(OYVAL),a10,L	;Get int Y

	move	*a0(OXPOS),a2		;X
	movx	a2,a10			;A10=Obj Y:X
	btst	B_SCRNREL,a1
	jrnz	#noscl			;Screen relative XY?
	move	b4,a6			;A6=World TL Y:X
	subxy	a6,a10			;-world coord to get screen coord
#noscl
					;A8=Const:PAL
					;A9=HEIGHT:WIDTH
					;A10=Dest Y:X
					;A11=*SAG
					;A12=Offset:Ctrl

	btst	B_BOBJ,a1
	jrnz	#is_bgnd_obj

	move	*a0(ODOFF),a3,L		;display offset Y:X

	btst	B_FLIPH,a12
	jrz	#no_x_flip0

	movx	a3,a2
	neg	a2
	dec	a2		; -1
	addxy	a9,a2		;- image width (gets added later)
	movx	a2,a3

#no_x_flip0

	btst	B_FLIPV,a12
	jrz	#no_y_flip0

	move	a3,a2
	srl	16,a2
	neg	a2
	dec	a2		; -1
	sll	16,a2
	addxy	a9,a2		;- image height (gets added later)
	movy	a2,a3

#no_y_flip0

	subxy	a3,a10


#is_bgnd_obj



;Check for flipping, clipping, adjust offset, sag

				;Calc top,bot,left,right clips
				;a2 = BR clip size
	clr	a3		;a3 = TL clip size
	move	a10,a2		;Dest Y:X
	addxy	a9,a2		; + HEIGHT:WIDTH = BR Y:X
	subxy	a13,a2		;A2=BR clip size
	JRYGE	#clip_bot
	movy	a3,a2		;no bot clip if y neg
#clip_bot
	JRXGE	#clip_right
	movx	a3,a2		;no right clip if x neg
#clip_right

	move	a14,a7		;screen TL
	subxy	a10,a7		; - DEST Y:X = TL clip size
	JRYLT	#no_top_clip
	movy	a7,a3		;Top clip size
	btst	7,a12		;zero compression on?
	jrnz	#no_top_clip	;can't clip if it is
	movy	a14,a10		;Y start = window top edge

#no_top_clip
	JRXLT	#no_left_clip
	movx	a7,a3		;Left clip size
	btst	7,a12
	jrnz	#no_left_clip	;Zero compression on?
	movx	a14,a10		;X start = window left edge

#no_left_clip
	move	a2,b0		;Save BR clip
	add	a3,a2		;TL clip + BR clip
	;no need to use addxy as no signs + this sets Z for both

	jrz	#noclip		;Zero clip?


	move	a9,a6		;Save HEIGHT:WIDTH

	subxy	a2,a9		;Get clipped size
	JRXLE	#nxt		;Totally clipped?
	JRYLE	#nxt

	btst	7,a12
	jrz	#nozc		;Zero compression off?
	move	a6,a9		;Restore v:h size
	jruc	#noclip

#nozc
	clr	a1
	movx	a2,a1		;x clip total
	move	a1,a1
	jrz	#no_x_clip
	movx	a9,a1		;image width
	subk	8,a1
	jrle	#nxt		;<=8 wide? Skip so DMA doesn't lockup

#no_x_clip
	movx	a6,a9		;Restore hsize

	movx	a3,a1		;A1=Left clip


	btst	B_FLIPH,a12
	jrz	#no_x_flip

	subxy	a1,a10		;Original X

	move	b0,a1		;LClip=RClip
	zext	a1,W		;clear Y portion
	subxy	a1,a10		;X-RClip


#no_x_flip
	btst	B_FLIPV,a12
	jrz	#no_y_flip

	move	b0,a3		;Bot clip

#no_y_flip
	srl	16,a3		;A3=Top or bot clip
	jrz	#t0
	zext	a6,W		;clear Y portion
	mpyu	a6,a3		;T or B clip * width


#t0
	add	a1,a3		;Add x clip + y clip * width
	move	a12,a1
	sll	32-15,a1	;Get bits 12-14	(PIXEL SIZE)
	srl	32-15+12,a1
	jrnz	#not8
	movk	8,a1
#not8	mpys	a1,a3		;# of bits to skip
	add	a3,a11		;Add to SAG
	sll	16,a2
	addxy	a2,a12		;Add clip offset to offset


#noclip

;if image is flipped, dma plots from opposite end

	btst	B_FLIPH,a12
	jrz	#300
	movx	a9,a1			;image WIDTH
	subk	1,a1
	zext	a1
	addxy	a1,a10			;+ WIDTH-1

#300
	btst	B_FLIPV,a12
	jrz	#400
	move	a9,a1			;image HEIGHT
	srl	16,a1
	subk	1,a1
	sll	16,a1
	addxy	a1,a10			;+ HEIGHT-1
#400


	move	b2,a1
	addxy	a1,a10			;Add the page y offset : XPad
	rl	16,a12			;Flip ctrl & offset
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
	move	*a0,a0,L		;Get next link
	jrnz	#lp			;More?
	rets


#*****************************************************************************
* Load DMA Q from obj list (3D type)
* A0=*Obj list
* A4=*DMAQ next free spot
* A13=Screen BR, A14=Screen TL
* B2=Y offset for top of page : XPad offset
* B4=World Y:X
* B5=OFLAGS offset
* B6=World center scrn X * 64K
* B11=*DMACTRL

dma_objlst3d
	movi	[100h,100h],a5		;A5=Y:X scale
	jruc	#nxt

	.align

#lp
	move	b5,a3
	add	a0,a3
	move	*a3+,a1			;Get OFLAGS
	mmfm	a3,a12,a11,a9,a8

	move	*a0(OYVAL),a10,L	;Get int Y

	move	*a0(OXPOS),a2		;X
	movx	a2,a10			;A10=Obj Y:X
	btst	B_SCRNREL,a1
	jrnz	#noscl			;Screen relative XY?
	move	b4,a6			;A6=World TL Y:X
	subxy	a6,a10			;-world coord to get screen coord
#noscl
					;A8=Const:PAL
					;A9=HEIGHT:WIDTH
					;A10=Dest Y:X
					;A11=*SAG
					;A12=Offset:Ctrl

	btst	B_BOBJ,a1
	jrnz	#is_bgnd_obj

	move	*a0(ODOFF),a3,L		;display offset Y:X

	btst	B_FLIPH,a12
	jrz	#no_x_flip0

	movx	a3,a2
	neg	a2
	dec	a2		; -1
	addxy	a9,a2		;- image width (gets added later)
	movx	a2,a3

#no_x_flip0

	btst	B_FLIPV,a12
	jrz	#no_y_flip0

	move	a3,a2
	srl	16,a2
	neg	a2
	dec	a2		; -1
	sll	16,a2
	addxy	a9,a2		;- image height (gets added later)
	movy	a2,a3

#no_y_flip0

	subxy	a3,a10


#is_bgnd_obj



;Check for flipping, clipping, adjust offset, sag

				;Calc top,bot,left,right clips
				;a2 = BR clip size
	clr	a3		;a3 = TL clip size
	move	a10,a2		;Dest Y:X
	addxy	a9,a2		; + HEIGHT:WIDTH = BR Y:X
	subxy	a13,a2		;A2=BR clip size
	JRYGE	#clip_bot
	movy	a3,a2		;no bot clip if y neg
#clip_bot
	JRXGE	#clip_right
	movx	a3,a2		;no right clip if x neg
#clip_right

	move	a14,a7		;screen TL
	subxy	a10,a7		; - DEST Y:X = TL clip size
	JRYLT	#no_top_clip
	movy	a7,a3		;Top clip size
	btst	7,a12		;zero compression on?
	jrnz	#no_top_clip	;can't clip if it is
	movy	a14,a10		;Y start = window top edge

#no_top_clip
	JRXLT	#no_left_clip
	movx	a7,a3		;Left clip size
	btst	7,a12
	jrnz	#no_left_clip	;Zero compression on?
	movx	a14,a10		;X start = window left edge

#no_left_clip
	move	a2,b0		;Save BR clip
	add	a3,a2		;TL clip + BR clip
	;no need to use addxy as no signs + this sets Z for both

	jrz	#noclip		;Zero clip?


	move	a9,a6		;Save HEIGHT:WIDTH

	subxy	a2,a9		;Get clipped size
	JRXLE	#nxt		;Totally clipped?
	JRYLE	#nxt

	btst	7,a12
	jrz	#nozc		;Zero compression off?
	move	a6,a9		;Restore v:h size
	jruc	#noclip

#nozc
	clr	a1
	movx	a2,a1		;x clip total
	move	a1,a1
	jrz	#no_x_clip
	movx	a9,a1		;image width
	subk	8,a1
	jrle	#nxt		;<=8 wide? Skip so DMA doesn't lockup

#no_x_clip
	movx	a6,a9		;Restore hsize

	movx	a3,a1		;A1=Left clip


	btst	B_FLIPH,a12
	jrz	#no_x_flip

	subxy	a1,a10		;Original X

	move	b0,a1		;LClip=RClip
	zext	a1,W		;clear Y portion
	subxy	a1,a10		;X-RClip


#no_x_flip
	btst	B_FLIPV,a12
	jrz	#no_y_flip

	move	b0,a3		;Bot clip

#no_y_flip
	srl	16,a3		;A3=Top or bot clip
	jrz	#t0
	zext	a6,W		;clear Y portion
	mpyu	a6,a3		;T or B clip * width


#t0
	add	a1,a3		;Add x clip + y clip * width
	move	a12,a1
	sll	32-15,a1	;Get bits 12-14	(PIXEL SIZE)
	srl	32-15+12,a1
	jrnz	#not8
	movk	8,a1
#not8	mpys	a1,a3		;# of bits to skip
	add	a3,a11		;Add to SAG
	sll	16,a2
	addxy	a2,a12		;Add clip offset to offset


#noclip

;if image is flipped, dma plots from opposite end

	btst	B_FLIPH,a12
	jrz	#300
	movx	a9,a1			;image WIDTH
	subk	1,a1
	zext	a1
	addxy	a1,a10			;+ WIDTH-1

#300
	btst	B_FLIPV,a12
	jrz	#400
	move	a9,a1			;image HEIGHT
	srl	16,a1
	subk	1,a1
	sll	16,a1
	addxy	a1,a10			;+ HEIGHT-1
#400


	move	b2,a1
	addxy	a1,a10			;Add the page y offset : XPad
	rl	16,a12			;Flip ctrl & offset
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
	move	*a0,a0,L		;Get next link
	jrnz	#lp			;More?
	rets


#*****************************************************************************
* Load DMA Q from obj list
* A0=*Obj list
* A4=*DMAQ next free spot
* A13=Screen BR, A14=Screen TL
* B2=Y offset for top of page : XPad offset
* B4=World Y:X
* B5=OFLAGS offset
* B6=World center scrn X * 64K
* B11=*DMACTRL

dma_background

	movi	[100h,100h],a5		;A5=Y:X scale
	jruc	#nxt

	.align

#lp
	move	b5,a3
	add	a0,a3
	move	*a3+,a1			;Get OFLAGS
	mmfm	a3,a12,a11,a9,a8

	move	*a0(OYVAL),a10,L	;Get int Y

	move	*a0(OXPOS),a2		;X
	movx	a2,a10			;A10=Obj Y:X
	btst	B_SCRNREL,a1
	jrnz	#noscl			;Screen relative XY?
	move	b4,a6			;A6=World TL Y:X
	subxy	a6,a10			;-world coord to get screen coord
#noscl
					;A8=Const:PAL
					;A9=HEIGHT:WIDTH
					;A10=Dest Y:X
					;A11=*SAG
					;A12=Offset:Ctrl

;Check for flipping, clipping, adjust offset, sag

				;Calc top,bot,left,right clips
	clr	a3		;A3=TL clip size
	move	a10,a2		;Dest Y:X
	addxy	a9,a2		; + HEIGHT:WIDTH = BR Y:X
	subxy	a13,a2		;A2=BR clip size
	JRYGE	#clip_bot
	movy	a3,a2		;no bot clip if y neg
#clip_bot
	JRXGE	#clip_right
	movx	a3,a2		;no right clip if x neg
#clip_right

	move	a14,a7		;screen TL
	subxy	a10,a7		; - DEST Y:X = TL clip size
	JRYLT	#no_top_clip
	movy	a7,a3		;Top clip size
	btst	7,a12		;zero compression on?
	jrnz	#no_top_clip	;can't clip if it is
	movy	a14,a10		;Y start = window top edge

#no_top_clip
	JRXLT	#no_left_clip
	movx	a7,a3		;Left clip size
	btst	7,a12
	jrnz	#no_left_clip	;Zero compression on?
	movx	a14,a10		;X start = window left edge

#no_left_clip
	move	a2,b0		;Save
	add	a3,a2		;TL clip+BR clip
	jrz	#noclip		;Zero clip?


	move	a9,a6		;Save HEIGHT:WIDTH

	subxy	a2,a9		;Get clipped size
	JRXLE	#nxt		;Totally clipped?
	JRYLE	#nxt

	btst	7,a12
	jrz	#nozc		;Zero compression off?
	move	a6,a9		;Restore v:h size
	jruc	#noclip

#nozc
	clr	a1
	movx	a2,a1		;x clip total
	move	a1,a1
	jrz	#no_x_clip
	movx	a9,a1		;image width
	subk	8,a1
	jrle	#nxt		;<=8 wide? Skip so DMA doesn't lockup

#no_x_clip
	movx	a6,a9		;Restore hsize

	movx	a3,a1		;A1=Left clip


	btst	B_FLIPH,a12
	jrz	#no_x_flip

	subxy	a1,a10		;Original X

	move	b0,a1		;LClip=RClip
	zext	a1
	subxy	a1,a10		;X-RClip


#no_x_flip
	btst	B_FLIPV,a12
	jrz	#no_y_flip

	move	b0,a3		;Bot clip

#no_y_flip
	srl	16,a3		;A3=Top or bot clip
	jrz	#t0
	zext	a6
	mpyu	a6,a3		;T or B clip * total hsize


#t0
	add	a1,a3		;Add left clip + tc*ths
	move	a12,a1
	sll	32-15,a1	;Get bits 12-14	(PIXEL SIZE)
	srl	32-15+12,a1
	jrnz	#not8
	movk	8,a1
#not8	mpys	a1,a3		;# of bits to skip
	add	a3,a11		;Add to SAG
	sll	16,a2
	addxy	a2,a12		;Add clip offset to offset


#noclip

	btst	B_FLIPH,a12		;if flipped, keep block
	jrz	#300			;in same position
	movx	a9,a1			;image WIDTH
	subk	1,a1
	zext	a1
	addxy	a1,a10
#300	btst	B_FLIPV,a12
	jrz	#400
	move	a9,a1			;image HEIGHT
	srl	16,a1
	subk	1,a1
	sll	16,a1
	addxy	a1,a10
#400


	move	b2,a1
	addxy	a1,a10			;Add the page y offset : XPad
	rl	16,a12			;Flip ctrl & offset
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
	move	*a0,a0,L		;Get next link
	jrnz	#lp			;More?
	rets


#*****************************************************************************
* Display object lists, called by DIRQ

DISPLAY
	move	@DISPLAYON,a0
	jrz	#novel

	movi	DMACTRL,b11		;B11=*DMACTRL


;this is for use on the pixel wash screen transition
	movi	[PAGE1YO,SCRNXP],b2
	movi	[509,256],b3		;dma window [ bottom : top ]
	move	@special_screen,a1
	jrnz	#p1

	movi	SCRNXP,b2		;B2=Page y offset : XPad offset
	movi	[253,0],b3		;dma window [ bottom : top ]

	move	@dpage,a1
	jrnz	#p1
	movi	[PAGE1YO,SCRNXP],b2
	movi	[509,256],b3		;dma window [ bottom : top ]

#p1
	move	b2,@page_addr,L
	movi	dmaq0+QSIZE,a4		;A4=*DMAQ for new data (Top)
	clr	b13			;Kill DMA
	move	b13,*b11
	move	b13,*b11

	movi	DMAREGS,b12		;B12=*DMAREGS
	subk	1,b13			;B13=Q count (-1)
	move	a4,b14			;B14=*DMAQ for next fetch (Top)

;------> SHAWN WAS SETTING DSZ (BIT6) ALSO  ???????????????

	movi	BIT5,b0			;DMAWIN (1 = BOTTOM:TOP)
	move	b0,*b12(30h)		;DMACONF (Top/Bottom)
	move	b3,*b12,L		;DMAWINDOW

;	move	@DISPLAYON,a0
;	jrz	#doff			;Stop DMA of objects except for score?

	movi	WORLDTLX,b0		;Left X screen coord (16:16)
	move	*b0+,b3,L		;left x	[16:16]
	move	*b0+,b4,L		;top y [16:16]
	srl	16,b3			;int left x
	movx	b3,b4
	move	b4,*b0,L		;top left world  [Y:X] (WORLDTL)

	movi	OFLAGS,b5		;B5=Obj data offset
	move	b4,b6
	addi	200,b6
	sll	16,b6			;B6=World center scrn X * 64K
	move	@SCRNLR,a13,L		;A13=Screen BR
	move	@SCRNTL,a14,L		;A14=Screen TL

	move	@TOP_LEFT,A0,L
	ADDXY	A0,A14
	MOVE	@BOT_RIGHT,A0,L
	ADDXY	A0,A13

	movi	BAKLST,a0
	callr	dma_background

	move	b13,@present_pos

	movi	OBJLST,a0
	callr	dma_objlst2d

	MOVE	@WHICH_SCREEN,A0,L
	CALL	A0

#doff
	move	@DMAQCUR,a2,L
	movi	DMAQ+QMSIZE,a1
	cmp	a1,a2
	jrhs	#noman			;Empty?
	move	a1,@DMAQCUR,L		;Reset top of queue

	move	b2,a5

#lp	move	-*a1,-*a4,L		;>Copy manual DMAQ to end of Q
	move	-*a1,-*a4,L
	move	-*a1,-*a4,L
	move	-*a1,a0,L
	addxy	a5,a0			;+Y
	move	a0,-*a4,L
	move	-*a1,-*a4,L
	move	-*a1,-*a4,L
	addk	1,b13
	cmp	a2,a1
	jrhi	#lp


	move	*b11,b0
	jrn	#noman			;DMA busy?

	move	b13,b13
	jrn	#noman			;DMA int done?

	setf	1,0,0			;>Enable DMA int
	movk	1,a1
	move	a1,@INTENB+1		;X1E
	setf	16,1,0

	trap	1			;Cause DMA int

#noman

	move	@HALT,a0
	jrnz	#novel			;Skip vel update?
	movi	OBJLST,a0
	callr	vel_add
#novel
#x
	rets


;Null dma data
nulldma	.long	>80000000,IROM,0,>00010001,0,>1000100


#*****************************************************************************
* Velocity add loop
* A0=*Obj list
* Trashes A0-A7
	.align
#lp	move	a0,a1
	addk	OXVEL,a1

	mmfm	a1,a2,a3,a4,a5,a6,a7	;A7=XV, A6=YV, A5=ZV, A4=X, A3=Y, A2=Z

	add	a5,a2			;Add ZVEL to Z
	move	a2,-*a1,L
	add	a6,a3			;Add YVEL to Y (Uses hidden cycle!)
	move	a3,-*a1,L
	add	a7,a4			;Add XVEL to X ^
	move	a4,-*a1,L

vel_add	move	*a0,a0,L
	jrnz	#lp			;!End?
	rets



#*****************************************************************************
* Manual DMA
* A1=Constant color:Palette
* A2=height:width
* A3=Dest Y:X
* A4=SAG
* A5=Offset:Control
* Trashes A0,A14

QDMAN
;	movk	1,a0
;	move	a0,@QDMAFLG		;Q being modified

	move	@DMAQCUR,a14,L
	cmpi	DMAQ,a14
	jrls	#x			;Q full?

	movi	[100h,100h],a0		;No scale
	rl	16,a5			;Flip DMA & offset
	mmtm	a14,a0,a1,a2,a3,a4,a5
	rl	16,a5			;Flip DMA & offset
	move	a14,@DMAQCUR,L

#x
;	clr	a0
;	move	a0,@QDMAFLG
	rets

	.if	0

#*******************************
* Turn on the 2d with scaling display mode
* Trashes scratch

 SUBRP	display_2dsclmodeon

	movi	#drawcode,a0
	move	a0,@dcode_p,L
	movi	-1,a0
	move	a0,@dtype

	rets

#drawcode
	movi	BAKLST,a0
	callr	dma_objlst2d

	movi	OBJLST,a0
;;;;	jruc	dma_objlst2dscl


#*******************************
* Turn on the 2d, with scaling and stars, display mode
* Trashes scratch

	.asg	SCRATCH+8*128*1024,STARBUF
NSTARS	.equ	900
STARSIZE .equ	32*6+16

 SUBRP	display_2dsclstarmodeon

	movi	NSTARS,b0		;>Init star array
	movi	STARBUF,a1
	movi	-1,a0
#silp	move	a0,*a1,L		;X
	addi	STARSIZE,a1
	dsj	b0,#silp

	movi	#drawcode,a0
	move	a0,@dcode_p,L
	movi	-1,a0
	move	a0,@dtype

	rets

********************************
* B2=Y offset for top of page : XPad offset
* Trashes A0-A3,A5-A12,B0-B3

CFRAC	.equ	2

	.bss	starcolor	,16

#drawcode
	PUSH	a13,a14
	PUSH	b4

	movk	3,a0
	callr	rnd
	move	@starcolor,a6
	add	a0,a6
	move	a6,@starcolor
	sll	32-3-6,a6
	srl	32-3,a6			;Remove fraction
	sll	5+CFRAC,a6


	movi	NSTARS,a5		;>Find a free star
	movi	STARBUF,a2
	movk	3,a3
#flp	move	*a2,a0,L		;X
	jrn	#found
	addi	STARSIZE,a2
#fnxt	dsj	a5,#flp
	jruc	#nofree

#found	movi	[200,0],a0		;>Create star
	move	a0,*a2+,L		;X
	movi	[252,0],a0
	move	a0,*a2+,L		;Y

	clr	a0
	move	a0,*a2+,L		;XV
	movi	->3e000,a0
	move	a0,*a2+,L		;YV

	movi	>7ff,a0
	callr	rnd
	subi	>3ff,a0
	move	a0,*a2+,L		;XA
	movi	>3ff,a0
	callr	rnd
	addi	>7ff,a0
	move	a0,*a2+,L		;YA

	move	a6,*a2+			;Color type
	dsj	a3,#fnxt
#nofree

	movi	#star_p,a0		;>Update stars
	calla	pal_getf
	move	a0,@DMACMAP

	movi	512*8,b3
	lmo	b3,b0
	move	b0,@CONVDP
	clr	b4

	movi	1<<(32-5-CFRAC),a11
	movi	[400,0],a13		;A13=X max+1
	movi	[254,0],a14		;A14=Y max+1
	move	b2,a12
	movi	NSTARS,b0
	movi	STARBUF,a8
#lp
;	move	*a8+,a2,L		;X
;	move	*a8+,a3,L		;Y
;	move	*a8+,a5,L		;XV
;	move	*a8+,a6,L		;YV
;	move	*a8+,a9,L		;XA
;	move	*a8+,a10,L		;YA
	mmfm	a8,a2,a3,a5,a6,a9,a10	;YA,XA,YV,XV,Y,X
	move	*a8+,a1			;Color
	move	a10,a10
	jrn	#nxt

	add	a2,a5
	add	a3,a6
	add	a5,a9
	add	a6,a10
	cmp	a13,a10
	jrhs	#offscr			;X off screen?
	cmp	a14,a9
	jrlo	#plot			;Y on screen?
#offscr
	movi	-1,a0
	move	a0,*a8(-STARSIZE),L
	jruc	#nxt
#plot
	move	a10,*a8(-STARSIZE),L
	move	a9,*a8(-STARSIZE+32),L
	move	a6,*a8(-STARSIZE+32*2),L
	move	a5,*a8(-STARSIZE+32*3),L

	move	a1,a0
	sll	32-5-CFRAC,a0
	add	a11,a0
	jrc	#maxc			;Overflow?
;	cmpi	32*4,a1
;	jrge	#offscr
	addk	1,a1
	move	a1,*a8(-16)
#maxc	srl	CFRAC,a1		;Remove fraction
	srl	16,a10
	movx	a10,a9
	addxy	a12,a9
	pixt	a1,*a9.XY
#nxt
	dsj	b0,#lp

	PULL	b4
	PULL	a13,a14

	movi	BAKLST,a0
	callr	dma_objlst2d

	movi	OBJLST,a0
;;;	jruc	dma_objlst2dscl

#star_p
	.word	256
	COLORW	01,01,01, 02,02,02, 03,03,03, 04,04,04	;Grey
	COLORW	05,05,05, 06,06,06, 07,07,07, 08,08,08
	COLORW	09,09,09, 10,10,10, 11,11,11, 12,12,12
	COLORW	13,13,13, 14,14,14, 15,15,15, 16,16,16
	COLORW	17,17,17, 18,18,18, 19,19,19, 20,20,20
	COLORW	21,21,21, 22,22,22, 23,23,23, 24,24,24
	COLORW	25,25,25, 26,26,26, 27,27,27, 28,28,28
	COLORW	29,29,29, 30,30,30, 31,31,31, 31,31,31
	COLORW	01,01,00, 02,02,00, 03,03,00, 04,04,00	;Yellow
	COLORW	05,05,00, 06,06,00, 07,07,00, 08,08,00
	COLORW	09,09,00, 10,10,00, 11,11,00, 12,12,00
	COLORW	13,13,00, 14,14,00, 15,15,00, 16,16,00
	COLORW	17,17,00, 18,18,00, 19,19,00, 20,20,00
	COLORW	21,21,00, 22,22,00, 23,23,00, 24,24,00
	COLORW	25,25,00, 26,26,00, 27,27,00, 28,28,00
	COLORW	29,29,00, 30,30,00, 31,31,00, 31,31,00
	COLORW	01,00,00, 02,00,00, 03,00,00, 04,00,00	;Red
	COLORW	05,00,00, 06,00,00, 07,00,00, 08,00,00
	COLORW	09,00,00, 10,00,00, 11,00,00, 12,00,00
	COLORW	13,00,00, 14,00,00, 15,00,00, 16,00,00
	COLORW	17,00,00, 18,00,00, 19,00,00, 20,00,00
	COLORW	21,00,00, 22,00,00, 23,00,00, 24,00,00
	COLORW	25,00,00, 26,00,00, 27,00,00, 28,00,00
	COLORW	29,00,00, 30,00,00, 31,00,00, 31,00,00
	COLORW	00,01,00, 00,02,00, 00,03,00, 00,04,00	;Green
	COLORW	00,05,00, 00,06,00, 00,07,00, 00,08,00
	COLORW	00,09,00, 00,10,00, 00,11,00, 00,12,00
	COLORW	00,13,00, 00,14,00, 00,15,00, 00,16,00
	COLORW	00,17,00, 00,18,00, 00,19,00, 00,20,00
	COLORW	00,21,00, 00,22,00, 00,23,00, 00,24,00
	COLORW	00,25,00, 00,26,00, 00,27,00, 00,28,00
	COLORW	00,29,00, 00,30,00, 00,31,00, 00,31,00
	COLORW	00,00,01, 00,00,02, 00,00,03, 00,00,04	;Blue
	COLORW	00,00,05, 00,00,06, 00,00,07, 00,00,08
	COLORW	00,00,09, 00,00,10, 00,00,11, 00,00,12
	COLORW	00,00,13, 00,00,14, 00,00,15, 00,00,16
	COLORW	00,00,17, 00,00,18, 00,00,19, 00,00,20
	COLORW	00,00,21, 00,00,22, 00,00,23, 00,00,24
	COLORW	00,00,25, 00,00,26, 00,00,27, 00,00,28
	COLORW	00,00,29, 00,00,30, 00,00,31, 00,00,31
	COLORW	00,00,01, 00,00,02, 00,00,03, 00,00,04	;Lt blue
	COLORW	00,00,05, 00,00,06, 00,00,07, 00,00,08
	COLORW	00,00,09, 01,01,10, 02,02,11, 03,03,12
	COLORW	04,04,13, 05,05,14, 06,06,15, 07,07,16
	COLORW	08,08,17, 09,09,18, 10,10,19, 11,11,20
	COLORW	12,12,21, 14,14,22, 16,16,23, 18,18,24
	COLORW	20,20,25, 22,22,26, 24,24,27, 26,26,28
	COLORW	28,28,29, 30,30,30, 30,30,31, 31,31,31
	COLORW	01,00,01, 02,00,02, 03,00,03, 04,00,04	;Purple
	COLORW	05,00,05, 06,00,06, 07,00,07, 08,00,08
	COLORW	09,00,09, 10,00,10, 11,00,11, 12,00,12
	COLORW	13,00,13, 14,00,14, 15,00,15, 16,00,16
	COLORW	17,00,17, 18,00,18, 19,00,19, 20,00,20
	COLORW	21,00,21, 22,00,22, 23,00,23, 24,00,24
	COLORW	25,00,25, 26,00,26, 27,00,27, 28,00,28
	COLORW	29,00,29, 30,00,30, 31,00,31, 31,00,31
	COLORW	00,01,01, 00,02,02, 00,03,03, 00,04,04	;Cyan
	COLORW	00,05,05, 00,06,06, 00,07,07, 00,08,08
	COLORW	00,09,09, 00,10,10, 00,11,11, 00,12,12
	COLORW	00,13,13, 00,14,14, 00,15,15, 00,16,16
	COLORW	00,17,17, 00,18,18, 00,19,19, 00,20,20
	COLORW	00,21,21, 00,22,22, 00,23,23, 00,24,24
	COLORW	00,25,25, 00,26,26, 00,27,27, 00,28,28
	COLORW	00,29,29, 00,30,30, 00,31,31, 00,31,31

	.endif

********************************
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


********************************
* Zeros velocities for all objects on OBJLST

STOPOBJS
	clr	a0
	movi	OBJLST,a1
	jruc	so20

so10	move	a0,*a1(OXVEL),L
	move	a0,*a1(OYVEL),L
	move	a0,*a1(OZVEL),L
so20	move	*a1,a1,L
	jrnz	so10

	rets


********************************
* Sort object list in Z:Y priority
* Trashes A0-A7

	.align

 SUBR	obj_yzsort

	movi	OBJLST,a0
	movk	1,a1			;Lowest Z
	sll	31,a1			;Make >80000000
	jruc	yzlp

yz0
	move	*a2(OZPOS),a6		;Get Z
	move	*a2(OYPOS),a7		;Get Y

	cmp	a1,a6
	jrgt	priok			;Next Z > Current Z?
	jrlt	priswap

	cmp	a5,a7
	jrge	priok			;Next Y > Current Y?

priswap	dint				;>Make current after next
	move	a2,*a4,L		;Point last to next
	move	*a2,*a0,L		;Point current to block after next
	move	a0,*a2,L		;Point next to current
	eint
	move	a2,a4
	jruc	yzlp			;Continue sort of current obj

priok	move	a0,a4			;A4=*Last obj
	move	a2,a0			;A0=*Current obj
	move	a6,a1			;A1=Current Z
	move	a7,a5			;A5=Current Y

yzlp	move	*a0,a2,L		;A2=*Next obj
	jrnz	yz0

	rets


**************************************************************************
* TEST IF OBJECT ON SCREEN
* A8=OBJECT
* RETURNS Z IF ON SCREEN

*ENTER HERE AND PROVIDE YOUR OWN SCREEN BOUNDRIES
SCRTSTG
	mmtm	sp,a1,a2,a3
	jruc	scrtst1

*NORMAL SCREEN BOUNDRIES
SCRTST
	mmtm	sp,a1,a2,a3
	move	@SCRNTL,a2,L		;Get screen top left
	move	@SCRNLR,a3,L		;Get screen lower rgt

scrtst1	move	*a8(OYPOS),a0
	move	*a8(OXPOS),a1
	sll	16,a0
	movx	a1,a0			;get top left of object
	move	@WORLDTL,a1,L
	subxy	a1,a0			;subtract out world base
	move	*a8(OSIZE),a1,L
	addxy	a0,a1			;get lower rt of object

	cmpxy	a3,a0			;is it lower than lower rt?
	JRYGE	scrtf_d			;lower
	JRXGE	scrtf_r			;to the right

	cmpxy	a2,a1
	JRYLE	scrtf_u			;above...
	JRXLE	scrtf_l			;to the left..

	mmfm	sp,a1,a2,a3
	clr	a0			;On screen Z
	rets
scrtf_l	movi	1,a0			;Pass NZ
	mmfm	sp,a1,a2,a3
	rets

scrtf_r	movi	2,a0
	mmfm	sp,a1,a2,a3
	rets

scrtf_u	movi	3,a0
	mmfm	sp,a1,a2,a3
	rets

scrtf_d	movi	4,a0
	mmfm	sp,a1,a2,a3
	rets


#*******************************
* Initialize display system
* Trashes scratch

 SUBR	SPECIAL_DISPLAY_INIT

	pushst
	dint
	movi	DIE+X2E,a0
	move	a0,@INTENB		;Display int on, DMA int off

	clr	a0
	move	a0,@DMACTRL		;Init DMA
	move	a0,@DMACTRL
	move	a0,@CMAPSEL		;Clear color map select
	move	a0,@DMATEST
	move	a0,@DMACONF
	movi	[511,0],a1		;RIGHT:LEFT (full width to fix glitch)
	move	a1,@DMAWINDOW,L
	movi	30h,a1		;<--------------------check this!!!!!!!!!!!
	move	a1,@DMACONF		;BOTTOM:TOP
	movi	[509,0],a1
	move	a1,@DMAWINDOW,L
	movi	[100h,100h],a1
	move	a1,@DMASCALEX,L

	movi	-1,b13			;DMAQ cnt

	MOVI	DUMRETS,A1
	MOVE	A1,@WHICH_SCREEN,L
	CLR	A0
	MOVE	A0,@TOP_LEFT,L
	MOVE	A0,@BOT_RIGHT,L
	move	a0,@special_screen
	callr	clear_objs
	popst

	rets


#*******************************
* Initialize display system
* Trashes scratch

 SUBR	display_init

	pushst
	dint
	movi	DIE+X2E,a0
	move	a0,@INTENB		;Display int on, DMA int off

	clr	a0
	move	a0,@DMACTRL		;Init DMA
	move	a0,@DMACTRL
	move	a0,@CMAPSEL		;Clear color map select
	move	a0,@DMATEST
	move	a0,@DMACONF
	movi	[511,0],a1		;RIGHT:LEFT (full width to fix glitch)
	move	a1,@DMAWINDOW,L
	movi	30h,a1		;<--------------------check this!!!!!!!!!!!
	move	a1,@DMACONF		;BOTTOM:TOP
	movi	[509,0],a1
	move	a1,@DMAWINDOW,L
	movi	[100h,100h],a1
	move	a1,@DMASCALEX,L

	movi	-1,b13			;DMAQ cnt

	clr	a1			;>Clr video mem
	movi	(SCRNE-512*8*2)/64,b0
#clp	move	a0,*a1+,L
	move	a0,*a1+,L
	dsj	b0,#clp
					;>Set autoerase lines
	movi	510*512*8,a1		;Store to last 2 lines of bitmap
	movi	ERASECOL,a14		;Color pair
	movi	512*8*2/16,b0
#lp	move	a14,*a1+
	dsj	b0,#lp



	MOVI	DUMRETS,A1
	MOVE	A1,@WHICH_SCREEN,L
	CLR	A0
	MOVE	A0,@TOP_LEFT,L
	MOVE	A0,@BOT_RIGHT,L
	move	a0,@special_screen
	callr	clear_objs
	popst

	rets

clear_objs
	CLR	A0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L
	move	a0,@WORLDTL,L
	move	a0,@SCROLLX,L
	move	a0,@SCROLLY,L

	move	a0,@BAKLST,L		;Null backgnd object list
	move	a0,@OBJLST,L		;Null object list

	move	a0,@dcode_p,L

	movi	SCRNST,a1		;Screen top left [Y,X]
	move	a1,@SCRNTL,L
	movi	SCRNEND,a1		;Screen lower right [Y,X]
	move	a1,@SCRNLR,L

	movi	DMAQ+QMSIZE,a1
	move	a1,@DMAQCUR,L		;Init misc DMA queue

	movi	OBJSTR,a1,L		;>Init free list
	move	a1,@OFREE,L
	movi	NOBJ,b0			;# of object blocks

#olp	move	a1,a14
	addi	OBSIZ,a1
	move	a1,*a14,L		;link em up
	dsj	b0,#olp

	move	a0,*a14,L		;Null end
	rets


********************************
* Get a free object block
* Trashes scratch
* >A0=*Object or 0 (Z)

GETOBJ
	move	@OFREE,a0,L
	jrz	nonelft			;None free?

	move	*a0,a1,L
	move	a1,@OFREE,L		;Unlink
	clr	a1
	move	a1,*a0(OPLINK),L
	move	a1,*a0(ODATA_p),L
getox
	move	a0,a0
	rets

nonelft
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	3,0
	.endif
	jruc	getox


********************************
* Add object to free list
* Can trash A0-A1 (currently doesn't)

FREEOBJ
	move	@OFREE,*a0+,L
	subk	32,a0
	move	a0,@OFREE,L
	rets


#*******************************
* Unlink an object from object list
* A0=*Obj
* Trashes scratch

; SUBR	obj_unlink
;
;	movi	OBJLST,a14
;
;#lp	move	a14,a1		;A1=*Prev
;	move	*a14,a14,L	;A14=*Next
;	jrz	#err
;	cmp	a14,a0
;	jrne	#lp
;
;	move	*a0,*a1,L	;Unlink from obj list
;	rets
;
;#err
;	.if	DEBUG
;	LOCKUP
;	eint
;	.endif
;	rets


********************************
* Insert an object block into an object list
* List is sorted by increasing z and increasing y within constant z


#*******************************
* Insert background object
* A0=*Obj
* Trashes scratch

INSBOBJ
	movi	BAKLST,a14
	jruc	#strt

********************************
* Insert foreground object
* A0=*Obj
* Trashes scratch

INSOBJ

	movi	OBJLST,a14

#strt	PUSH	a2,a3,a4

	move	*a0(OZPOS),a1
	move	*a0(OYPOS),a4
#lp
	move	a14,a2			;A2=*prev
	move	*a14,a14,L		;A14=*next
	jrz	#x
	move	*a14(OZPOS),a3
	cmp	a3,a1
	jrgt	#lp
	jrlt	#x

	move	*a14(OYPOS),a3		;Test y position
	cmp	a3,a4
	jrgt	#lp


#x	move	a14,*a0,L		;Put *next in new block
	move	a0,*a2,L		;Put *new in prev block

	PULL	a2,a3,a4
	rets


#*******************************
* Delete background object
* A0=*Obj

DELBOBJ

	movi	BAKLST,a14
	jruc	#lp


********************************
* Delete foreground object
* A8=*Obj

DELOBJA8

	move	a8,a0

********************************
* Delete foreground object
* A0=*Obj
* Trashes scratch

DELOBJ
	movi	OBJLST,a14

#lp	move	a14,a1		;A1=*Prev
	move	*a14,a14,L	;A14=*Next
	jrz	delerr
	cmp	a14,a0
	jrne	#lp

	move	*a0,*a1,L	;Unlink from obj list

	clr	a1
	move	a1,*a0(OXPOS)	;Indicates not in use for collisions

	move	@OFREE,*a0+,L	;Add to free list
	subk	32,a0
	move	a0,@OFREE,L

#x	rets

delerr
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	1,0
	.endif
	jruc	#x



********************************
* FRANIM list an object, delete it and DIE
* A8=*Obj
* A9=*FRANIM list

FRQDELDIE

	JSRP	FRANIMQ

#*******************************
* Delete foreground object and DIE
* A8=*Obj

DELOBJDIE

	movi	OBJLST,a14

#lp	move	a14,a1		;A1=*Prev
	move	*a14,a14,L	;A14=*Next
	jrz	doderr
	cmp	a14,a8
	jrne	#lp

	move	*a8,*a1,L	;Unlink from obj list

	clr	a1
	move	a1,*a8(OXPOS)	;Indicates not in use for collisions

	move	@OFREE,*a8+,L	;Add to free list
	subk	32,a8
	move	a8,@OFREE,L

#x	jauc	SUCIDE

doderr
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	1,0
	.endif
	jruc	#x



#*******************************
* Delete one class from the obj list
* A0=OID
* Trashes scratch

obj_del1c

	clr	a1

********************************
* Delete a class from the obj list
* A0=OID
* A1=!Mask (Bits to remove)
* Trashes scratch

obj_delc
	move	a2,b0
	move	a3,b1

	movi	OBJLST,a14
	sext	a0
	andn	a1,a0		;Form match

#lp	move	a14,a3		;A3=*Prev
	move	*a14,a14,L	;A14=*Next
	jrz	#x
#cmp	move	*a14(OID),a2
	andn	a1,a2		;Mask
	cmp	a0,a2
	jrne	#lp

	move	*a14,*a3,L	;Unlink from obj list

	move	@OFREE,*a14+,L	;Add to free list
	subk	32,a14
	move	a14,@OFREE,L
	move	*a3,a14,L
	jrnz	#cmp

#x
	move	b1,a3
	move	b0,a2
	rets



#*******************************
* Check objlst for an object with a certain OID
* A0=OID
* A1=!Mask (Bits to remove)
* >A0=*Obj or 0 (Z)
* Trashes scratch

EXISTOBJ
	move	a2,b0

	movi	OBJLST,a14
	sext	a0
	andn	a1,a0		;Form match
#lp
	move	*a14,a14,L
	jrz	#x
	move	*a14(OID),a2
	andn	a1,a2		;Mask
	cmp	a0,a2
	jrne	#lp

#x	move	b0,a2
	move	a14,a0
	rets


#*******************************
* Check if object on free list
* A0=*Obj
* >A0=*Obj or 0 (Z)
* Trashes scratch

;ISFREE
;	movi	OFREE,a1
;	jruc	#lp


********************************
* Check if object on OBJLST
* A0=*Obj
* >A0=*Obj or 0 (Z)
* Trashes scratch

ISOBJ
	movi	OBJLST,a1

#lp	move	*a1,a1,L
	jrz	#x		;End?
	cmp	a0,a1
	jrne	#lp		;No match?

	move	a0,a0		;Clr Z
	rets

#x	clr	a0		;Set Z
	rets


********************************
* Add world coordinates to an object
* A0=*Obj
* Trashes scratch, !A0

 SUBR	obj_addworldxy

	move	@WORLDTLX,a14,L
	move	*a0(OXVAL),a1,L
	add	a14,a1
	move	a1,*a0(OXVAL),L

	move	@WORLDTLY,a14,L
	move	*a0(OYVAL),a1,L
	add	a14,a1
	move	a1,*a0(OYVAL),L

	rets


**************************************************************************
*									 *
* ADJNEWTL - ADJUST AN OBJECT TO A NEW SET OF X,Y WORLD COORDINATES	 *
*	   BEFORE THEY ARE STORED(TAKE EFFECT).				 *
* NOTE: CURRENT OBJECT COORDS. MUST BE ABSOLUTE WORLD.			 *
* A0 = PTR TO OBJECT							 *
* A4 = NEW WTLX, 32 BITS						 *
* A5 = NEW WTLY, 32 BITS						 *

ADJNEWTL
	PUSH	a1,a2
	CALLR	GSCRNREL		;SCREEN RELATIVE PLEASE
	ADD	A4,A1
	ADD	A5,A2			;ADJUST
	MOVE	A1,*A0(OXVAL),L
	MOVE	A2,*A0(OYVAL),L		;STORE
	PULL	a1,a2
	RETS


**************************************************************************
*									 *
* GSCRNREL - GET THE SCREEN RELATIVE X,Y COORDINATES OF AN OBJECT	 *
*	   IT IS ASSUMED THAT THE CURRENT X,Y COORDINATES ARE		 *
*	   WORLD ABSOLUTE.						 *
* A0 = PTR TO THE OBJECT BLOCK						 *
* RETURNS								 *
* A1 = X SCREEN RELATIVE, 32 BITS					 *
* A2 = Y SCREEN RELATIVE, 32 BITS					 *

GSCRNREL
	PUSH	a5
	MOVE	@WORLDTLX,A5,L
	MOVE	*A0(OXVAL),A1,L
	SUB	A5,A1
	MOVE	@WORLDTLY,A5,L
	MOVE	*A0(OYVAL),A2,L
	SUB	A5,A2
	PULL	a5
	RETS


**************************************************************************
*									 *
* SCRNRELV - MAKE THE X & Y VELOCITIES OF AN OBJECT RELATIVE TO THE	 *
*	   SCREEN. IN OTHER WORDS, ADJUST THEM SO THAT THE CURRENT	 *
*	   SCROLL RATE DOESN'T AFFECT THEM. 				 *
* A0 = PTR TO OBJECT							 *
*									 *
**************************************************************************

SCRNRELV
	PUSH	a1,a5
	MOVE	@SCROLLX,A5,L
	MOVE	*A0(OXVEL),A1,L
	ADD	A5,A1
	MOVE	A1,*A0(OXVEL),L
	MOVE	@SCROLLY,A5,L
	MOVE	*A0(OYVEL),A1,L
	ADD	A5,A1
	MOVE	A1,*A0(OYVEL),L
	PULL	a1,a5
	RETS


********************************
* Adjust current object image with respect to it's anipt and flip flags
* A0=*Object
* A2=New YVAL
* A3=New XVAL
* A4=New FLAGS (Only DMA bits)
* Trashes A1,A14,B0-B1
* >A2=Adjusted YVAL
* >A3=Adjusted XVAL

GANISAG
	PUSH	a4,a6,a7

	PUSH	a2
	move	*a0(OIMG),a1,L
	move	*a1,a2,L		;ISIZE
	move	a2,*a0(OSIZE),L
	callr	GANIOF
	PULL	a2

	sub	a6,a3
	sub	a7,a2			;adjust upper left corner
	move	a3,*a0(OXVAL),L
	move	a2,*a0(OYVAL),L

	move	*a1(ICTRL),a1		;Get DMA flags
	andi	>803f,a4		;Kill mode bits
	or	a1,a4
	move	a4,*a0(OCTRL),L		;&OFFSET

	PULL	a4,a6,a7
	rets


******************************************************************************
* Begin an object
* A0=XVAL, A1=YVAL, A2=*IMG, A3=ZPOS, A4=FLAGS, A5=OID, A6=XVEL, A7=YVEL
* >A8=*Obj
* Trashes scratch

BEGINOBJW
	move	@WORLDTLX,a8,L		;Adjust for world coord
	add	a8,a0
	btst	B_3D,a4
	jrnz	BEGINOBJ		;No Y add for 3D?
	move	@WORLDTLY,a8,L
	add	a8,a1

BEGINOBJ
	PUSH	a2,a3,a4,a6,a7,a9,a10
	move	a0,a9			;X
	move	a1,a10			;Y

	move	*a2(ICMAP),a0,L		;Get *palette
	.if	DEBUG
	jrnn	bopalerr		;No palette?
	.endif
	calla	pal_getf

bo20	move	@OFREE,a8,L		;Pointer to next available obj block
	jrz	begobjerr		;No objs?
	move	*a8,a1,L
	move	a1,@OFREE,L		;Adjust pointer to free list

	move	a0,*a8(OPAL),L		;Set palette & constant
	clr	a0
	move	a0,*a8(ODATA_p),L	;Clr stuff
	move	a0,*a8(OXANI),L
	move	a0,*a8(OZVEL),L
	move	a0,*a8(OMISC)

	move	a0,*a8(ODOFF),L
	movi	01000100H,a0
	move	a0,*a8(OSCALE),L

	move	a3,*a8(OZPOS)

	move	a5,*a8(OID)
	move	a6,*a8(OXVEL),L
	move	a7,*a8(OYVEL),L

	move	a2,a1			;*Img
	move	*a1,a2,L		;ISIZE
	callr	GANIOF			;Adjust animation offset

;here!!!!!!!!!!!!!!
	move	*a1(IANIOFFX),*a8(ODXOFF) ;display x offset
	move	*a1(IANIOFFY),*a8(ODYOFF) ;display y offset

	move	*a1(ISAG),a3,L		;Get top left sag

;;;	sub	a6,a9			;- x anioff
;;;	sub	a7,a10			;- y anioff
	move	a9,*a8(OXVAL),L
	move	a10,*a8(OYVAL),L

	move	a1,*a8(OIMG),L
	move	a2,*a8(OSIZE),L
	move	a3,*a8(OSAG),L
	move	a4,*a8(OFLAGS)
	move	*a1(ICTRL),a0		;Get DMA flags
	andi	>803f,a4		;Kill mode bits
	or	a0,a4
	move	a4,*a8(OCTRL),L		;&OFSET

	PULL	a2,a3,a4,a6,a7,a9,a10

	move	a13,*a8(OPLINK),L
	move	a8,a0
	jruc	INSOBJ			;Insert object into list


	.if	DEBUG
bopalerr
	LOCKUP				;Object doesn't have pallette!
	eint
	clr	a0
	jruc	bo20
	.endif

begobjerr
	.if	DEBUG
	LOCKUP				;Out of objects!
	eint
	.else
	CALLERR	3,7
	.endif
	move	@OBJLST,a8,L		;Pass 1st obj on list
	PULL	a2,a3,a4,a6,a7,a9,a10
	rets



#*******************************
* Begin an object with specified palette
* A0=XVAL, A1=YVAL, A2=*IMG, A3=ZPOS, A4=FLAGS, A5=OID, A6=XVEL, A7=YVEL
* B0=*Palette
* >A8=*Obj
* Trashes scratch

BEGINOBJWP
	move	@WORLDTLX,a8,L		;Adjust for world coord
	add	a8,a0
	btst	B_3D,a4
	jrnz	BEGINOBJP		;No Y add for 3D?
	move	@WORLDTLY,a8,L
	add	a8,a1

BEGINOBJP
	PUSH	a2,a3,a4,a6,a7,a9,a10
	move	a0,a9			;X
	move	a1,a10			;Y

	move	b0,a0			;Get *palette
	.if	DEBUG
	jrnn	#bopalerr		;No pallette?
	.endif
	calla	pal_getf

#bo20	move	@OFREE,a8,L		;Pointer to next available obj block
	jrz	begobjerr		;No objs?
	move	*a8,a1,L
	move	a1,@OFREE,L		;Adjust pointer to free list

	move	a0,*a8(OPAL),L		;Set pallette & constant
	clr	a0
	move	a0,*a8(ODATA_p),L	;Clr stuff
	move	a0,*a8(OXANI),L
	move	a0,*a8(OZVEL),L
	move	a0,*a8(OMISC)

	move	a0,*a8(ODOFF),L
	movi	01000100H,a0
	move	a0,*a8(OSCALE),L

	move	a3,*a8(OZPOS)

	move	a5,*a8(OID)
	move	a6,*a8(OXVEL),L
	move	a7,*a8(OYVEL),L

	move	a2,a1			;*Img
	move	*a1,a2,L		;ISIZE
	callr	GANIOF			;Adjust animation offset

;here!!!!!!!!!!!!!!
	move	*a1(IANIOFFX),*a8(ODXOFF) ;display x offset
	move	*a1(IANIOFFY),*a8(ODYOFF) ;display y offset

	move	*a1(ISAG),a3,L		;Get top left sag

;;;	sub	a6,a9			;- x anioff
;;;	sub	a7,a10			;- y anioff
	move	a9,*a8(OXVAL),L
	move	a10,*a8(OYVAL),L

	move	a1,*a8(OIMG),L
	move	a2,*a8(OSIZE),L
	move	a3,*a8(OSAG),L
	move	a4,*a8(OFLAGS)
	move	*a1(ICTRL),a0		;Get DMA flags
	andi	>803f,a4		;Kill mode bits
	or	a0,a4
	move	a4,*a8(OCTRL),L		;&OFSET

	PULL	a2,a3,a4,a6,a7,a9,a10

	move	a13,*a8(OPLINK),L
	move	a8,a0
	jruc	INSOBJ			;Insert object into list


	.if	DEBUG
#bopalerr
	LOCKUP				;Object doesn't have pallette!
	eint
	clr	a0
	jruc	#bo20
	.endif


#*******************************
* Set new image for an object
* A1=*Image hdr
* A4=New FLAGS
* A8=*Obj
* Trashes A1,A14

 SUBR	ANI

	PUSH	a0,a2,a3,a4,a5,a6,a7

	cmpi	ROM,a1
	jrlo	anierr

	move	a1,a3
	move	a4,a5
	move	*a8(OIMG),a1,L
	move	*a8(OCTRL),a4
	cmp	a1,a3
	jrne	#1			;Different img?

	sext	a5
	cmp	a4,a5
	jreq	#x			;All the same?

#1	move	*a8(OSIZE),a2,L
	callr	GANIOF			;Get old animation offset
	move	a3,a1			;New OIMG
	srl	6,a4
	sll	6,a4
	or	a5,a4			;Set new OCTRL
	move	a6,a0
	move	a7,a5
	move	*a1(ISAG),a3,L		;Get top left sag
	move	*a1,a2,L		;ISIZE
	callr	GANIOF			;Get new animation offset
	move	a1,*a8(OIMG),L
	sub	a6,a0			;Subtract new from old
	sub	a7,a5
	zext	a4			;Zero offset in A4

	move	a8,a6			;Get push address of octrl,osag,osize
	addi	OCTRL+>60,a6
	mmtm	a6,a2,a3,a4		;Save new data

	subi	OCTRL-OXVAL,a6
	move	*a6,a7,L		;New OXVAL
	add	a0,a7
	move	a7,*a6+,L
	move	*a6,a7,L		;New OYVAL
	add	a5,a7
	move	a7,*a6,L

#x	PULL	a0,a2,a3,a4,a5,a6,a7
	rets

anierr
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	2,7
	.endif
	jruc	#x


#*****************************************************************************
* Change an objects image (Doesn't check VFLIP)
* A0=*New image
* A1=New flip flags & const
* A8=*Obj
* Trashes scratch

 SUBRP	obj_aniq


	PUSH	a2,a3

	cmpi	ROM,a0
	jrlo	#anierr

	move	a0,a2
	move	a1,a3

	callr	anipt_getxy

	move	a2,*a8(OIMG),L
	move	*a2(0),*a8(OSIZE),L
	move	*a2(ISAG),*a8(OSAG),L

	setf	5,0,0
	move	*a2(ICTRL+7),*a8(OCTRL+7) ;Write 5 z comp bits
	setf	6,0,0
	move	a3,*a8(OCTRL)		;Write 6 low bits
	setf	16,1,0

	move	a0,a2
	move	a1,a3
	callr	anipt_getxy

	sub	a0,a2			;Subtract new from old
	sub	a1,a3

	move	a8,a0			;Get base address
	addi	OXVAL,a0
	move	*a0,a14,L		;New OXVAL
	add	a2,a14
	move	a14,*a0+,L
	move	*a0,a14,L		;New OYVAL
	add	a3,a14
	move	a14,*a0,L

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


#*******************************
* Get an objects anipt XY (Doesn't check VFLIP)
* A8=*Obj
* >A0=Scaled Ani X (16:16)
* >A1=Scaled Ani Y
* Trashes scratch

 SUBRP	anipt_getxy

	move	a2,b0

	move	*a8(OIMG),a2,L

	move	*a2(IANIOFFX),a0
	sll	16,a0
	move	*a2(IANIOFFY),a1
	sll	16,a1

	move	*a8(OCTRL),a14
	btst	B_FLIPH,a14
	jrz	#x			;No flip?

	move	*a2,a2			;ISIZEX
	subk	1,a2
	sll	16,a2			;*64K
	neg	a0
	add	a2,a0			;+size


#x	move	b0,a2
	rets



#*******************************
* Change an objects image (doesn't check flip flags)
* A0=*New image
* A1=New OCTRL
* A8=*Obj
* Trashes scratch

 SUBRP	obj_aniq_cnoff

	move	a2,b0

	move	a1,*a8(OCTRL)		;Write new ctrl

	move	*a8(OIMG),a14,L
	move	*a14(IANIOFFX),a2
	move	*a14(IANIOFFY),a14

	move	a0,*a8(OIMG),L
	move	*a0(0),*a8(OSIZE),L
	move	*a0(ISAG),*a8(OSAG),L

	move	*a0(IANIOFFY),a1
	move	*a0(IANIOFFX),a0

	sub	a0,a2			;Subtract new from old
	sub	a1,a14
	sll	16,a2
	sll	16,a14

	move	a8,a0			;Get base address
	addi	OXVAL,a0
	move	*a0,a1,L		;New OXVAL
	add	a2,a1
	move	a1,*a0+,L
	move	*a0,a1,L		;New OYVAL
	add	a14,a1
	move	a1,*a0,L

	move	b0,a2
	rets



#*******************************
* Change an scaled objects image (Doesn't check VFLIP)
* A0=*New image
* A1=New OCTRL (low 8 bits)
* A8=*Obj
* Trashes scratch, A2,A3


 SUBRP	obj_aniq_scld


	cmpi	ROM,a0
	jrlo	#anierr

	move	a0,a2
	move	a1,a3

;;;	calla	anipt_getsclxy

	movb	a3,*a8(OCTRL)

	move	a2,*a8(OIMG),L
	move	*a2(0),*a8(OSIZE),L
	move	*a2(ISAG),*a8(OSAG),L

	move	a0,a2
	move	a1,a3
;;;	calla	anipt_getsclxy

	sub	a0,a2			;Subtract new from old
	sub	a1,a3

	move	a0,*a8(OXANI),L		;Save scaled anipt

	move	a8,a0			;Get base address
	addi	OXVAL,a0
	move	*a0,a14,L		;New OXVAL
	add	a2,a14
	move	a14,*a0+,L
	move	*a0,a14,L		;New OYVAL
	add	a3,a14
	move	a14,*a0,L

#x	rets


#anierr 
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	2,0
	.endif
	jruc	#x



********************************
* Get the x and y positions of an objects animation point
* A8=*Object
* Trashes scratch
* >A2=Ani pt Y 16:16
* >A3=Ani pt X 16:16

GETANIXY
	PUSH	a4,a6,a7
	move	*a8(OIMG),a1,L
	move	*a8(OSIZE),a2,L
	move	*a8(OCTRL),a4
	callr	GANIOF
	move	*a8(OXVAL),a3,L
	move	*a8(OYVAL),a2,L
	add	a6,a3
	add	a7,a2
	PULL	a4,a6,a7
	rets


#********************************
* Get animation offset (Fast!)
* A1=*Image header, A2=H:W, A4=OCTRL
* Trashes A14
*Rets:
* A6=X ani offset * 64K
* A7=Y ani offset * 64K

GANIOF
	move	*a1(IANIOFF),a6,L
	cmpi	IROM,a6
	jrge	#err

#h	clr	a7
	movy	a6,a7
	sll	16,a6		;Move to upper word

	btst	B_FLIPH,a4
	jrz	#v
	move	a2,a14
	subk	1,a14
	sll	16,a14		;Move W to upper word
	neg	a6
	add	a14,a6		;Sub Width-1

#v	btst	B_FLIPV,a4
	jrz	#x
	move	a2,a14
	neg	a7
	srl	16,a14
	subk	1,a14
	sll	16,a14
	add	a14,a7		;Sub Hgt-1

#x	rets

#err	clr	a6
	jruc	#h


#*******************************
* Scale screen out (JSRP)

	.asg	SCRATCH+8*256*1024,SCRNBUF
	.asg	SCRNBUF+8*128*1024,PALBUF

	.bss	scrnscl		,16

 SUBR	scrn_scaleout

	movk	1,a0
	move	a0,@HALT

	move	@dtype,a0
	PUSHP	a0
	move	@gndstat,a0
	PUSHP	a0

	movi	>160,a0
	move	a0,@scrnscl

	movi	#initcode,a0
	move	a0,@dcode_p,L

	movi	-1,a0
	move	a0,@dtype
	clr	a0
	move	a0,@gndstat
	move	a0,@IRQSKYE

#lp	SLEEPK	1

	movi	scrnscl,a14
	move	*a14,a5
	move	a5,a0
	srl	3,a0
	add	a0,a5
	move	a5,*a14
	cmpi	>7000,a5
	jrlt	#lp

	clr	a0
	move	a0,@dcode_p,L

	PULLP	a0
	move	a0,@gndstat
	PULLP	a0
	move	a0,@dtype


	RETP

#initcode
	callr	scrn_copy
	movi	scrn_scale,a0
	move	a0,@dcode_p,L
	jump	a0


#*******************************
* Initialization for scrn_scalein (JSRP)

 SUBR	scrn_scaleininit

	dint
#lp	move	@VCOUNT,a0
	cmpi	EOSINT,a0
	jrlt	#lp
	move	@HSBLNK,a0	;Blank screen
	move	a0,@HEBLNK
	eint
	SLEEPK	2

	RETP

#*******************************
* Scale screen in (JSRP)

 SUBR	scrn_scalein

	PUSHP	a8

	move	@HALT,a0
	PUSHP	a0
	movk	1,a0
	move	a0,@HALT

	move	@dtype,a0
	PUSHP	a0
	move	@gndstat,a0
	PUSHP	a0
	move	@dcode_p,a0,L
	PUSHP	a0

	movi	>7000,a0
	move	a0,@scrnscl

	movi	#initcode,a0
	move	a0,@dcode_p,L
	movi	-1,a0
	move	a0,@dtype
	clr	a0
	move	a0,@gndstat


	.if	DEBUG
;	movi	>1a0,a0
;	move	a0,@scrnscl
;	SLEEP	TSEC*2
	.endif


#lp	SLEEPK	1

	movi	scrnscl,a14
	move	*a14,a5
	move	a5,a0
	srl	2,a0
	sub	a0,a5
	move	a5,*a14
	cmpi	>100,a5
	jrgt	#lp


	PULLP	a0
	move	a0,@dcode_p,L
	PULLP	a0
	move	a0,@gndstat
	PULLP	a0
	move	a0,@dtype

	PULLP	a0
	move	a0,@HALT


	PULLP	a8
	RETP


#initcode
	callr	scrn_copy
	movi	scrn_scaledison,a0
	move	a0,@dcode_p,L
	jruc	scrn_scale


#*******************************
* B2=Y offset for top of page : XPad offset
* Trashes A0-A3,A7

 SUBRP	scrn_copy

	move	b2,a0
	srl	16,a0
	xori	>100,a0			;Flip to the page being shown
	sll	12,a0			;*512*8
	addi	SCRNXP*8,a0		;A0=*Scrn mem
	PUSH	a0

	movi	SCRNBUF,a1
	movi	254,a3
	movi	(512-400)*8,a7
#cslp
	movi	400/16,a2
#cslp2	move	*a0+,*a1+,L
	move	*a0+,*a1+,L
	move	*a0+,*a1+,L
	move	*a0+,*a1+,L
	dsj	a2,#cslp2

	add	a7,a0
	add	a7,a1
	dsj	a3,#cslp


	move	@SYSCOPY,a0
	.if	WWFUNIT
	andni	PALENB,a0
	move	a0,@SYSCOPY
	.if	DEBUG
	andni	LEDON,a0
	ori	WROMINTCLR,a0
	.endif
	.else
	andni	100000b,a0
	move	a0,@SYSCOPY
	.if	DEBUG
	andni	1000000b,a0
	.endif
	.endif
	move	a0,@SYSCTRL


	PULL	a0
	movi	PALBUF,a1
	movi	254,a3
#cplp
	movi	400/16,a2
#cplp2	move	*a0+,*a1+,L
	move	*a0+,*a1+,L
	move	*a0+,*a1+,L
	move	*a0+,*a1+,L
	dsj	a2,#cplp2

	add	a7,a0
	add	a7,a1
	dsj	a3,#cplp

	move	@SYSCOPY,a0


	.if	WWFUNIT
	ori	PALENB,a0
	move	a0,@SYSCOPY
	.if	DEBUG
	andni	LEDON,a0
	ori	WROMINTCLR,a0
	.endif
	.else
	ori	100000b,a0
	move	a0,@SYSCOPY
	.if	DEBUG
	andni	1000000b,a0
	.endif
	.endif
	move	a0,@SYSCTRL


	rets


#*******************************
* Copy screen data (throw out 1 in 5 pixels)
* B2=Y offset for top of page : XPad offset

 SUBRP	scrn_scale140

	PUSH	a4,a14

	movi	>140,a5

	move	b2,a1
	srl	16,a1
	addi	25,a1
	sll	12,a1			;*512*8
	addi	SCRNXP*8+40*8,a1	;A1=*Scrn mem

	movi	DMACMAP,a6
	clr	a7			;Y line 8:8
#lp
	move	a7,a2
	srl	8,a2
	sll	12,a2			;*512*8
	move	a2,a3

	addi	SCRNBUF,a2
	addi	PALBUF,a3
	movi	400/2/5,b0		;Copy 1 line
#cslp
	move	*a3,*a6			;Set pal latch
	addk	16,a3
	move	*a2+,*a1+		;Copy 2 pixels

	move	*a3,*a6
	addk	16,a3
	move	*a2+,*a1+

	move	*a3,*a6
	addk	16,a3
	move	*a2+,*a1+

	move	*a3,*a6
	addk	16,a3
	move	*a2+,*a1+

	addk	16,a3
	addk	16,a2

	dsj	b0,#cslp

	addi	(512-320)*8,a1

	add	a5,a7
	cmpi	254<<8,a7
	jrlt	#lp


#x	PULL	a4,a14
	rets



#*******************************
* Copy screen data (throw out 1 in 3 pixels)
* B2=Y offset for top of page : XPad offset

 SUBRP	scrn_scale180

	PUSH	a4,a14

	movi	>180,a5

	move	b2,a1
	srl	16,a1
	addi	42,a1
	sll	12,a1			;*512*8
	addi	SCRNXP*8+68*8,a1	;A1=*Scrn mem

	movi	DMACMAP,a6
	clr	a7			;Y line 8:8
#lp
	move	a7,a2
	srl	8,a2
	sll	12,a2			;*512*8
	move	a2,a3

	addi	SCRNBUF,a2
	addi	PALBUF,a3
	movi	400/2/3,b0		;Copy 1 line
#cslp
	move	*a3,*a6			;Set pal latch
	addk	16,a3
	move	*a2+,*a1+		;Copy 2 pixels

	move	*a3,*a6
	addk	16,a3
	move	*a2+,*a1+

	addk	16,a3
	addk	16,a2

	dsj	b0,#cslp

	addi	(512-264)*8,a1

	add	a5,a7
	cmpi	254<<8,a7
	jrlt	#lp


#x	PULL	a4,a14
	rets


********************************

 SUBRP	scrn_scaledison

	movi	HEBLNKINIT,a0		;Display on
	move	a0,@HEBLNK
	movi	scrn_scale,a0
	move	a0,@dcode_p,L


#*******************************
* Copy screen data with variable down scaling
* B2=Y offset for top of page : XPad offset

 SUBRP	scrn_scale

	move	@scrnscl,a5
	cmpi	>168,a5
	jrlt	scrn_scale140
	cmpi	>190,a5
	jrlt	scrn_scale180

	PUSH	a4,a14

	move	b2,a9
	srl	16,a9
	movi	127<<8,a3
	divu	a5,a3
	sub	a3,a9
	addi	127,a9
	sll	12,a9			;*512*8

	addi	(SCRNXP+200)*8,a9	;A9=*Scrn mem
	movi	100<<8,a3
	divu	a5,a3
	sll	4,a3			;*16
	sub	a3,a9

	movi	DMACMAP,a6
	clr	a7			;Y line 8:8
	movi	200<<8,a10
#lp
	move	a7,a2
	srl	8,a2
	sll	12,a2			;*512*8
	move	a2,a3

	move	a9,a1
	addi	SCRNBUF,a2
	addi	PALBUF,a3
	clr	a8			;X 8:8
#cslp
	move	*a3,*a6			;Set pal latch
	move	*a2,*a1			;Copy 2 pixels
	addk	16,a1

	move	a8,a0
	add	a5,a8
	sra	8,a0
	move	a8,a14
	sra	8,a14
	sub	a0,a14

#nxtp
	addk	16,a3
	addk	16,a2
	subk	1,a14
	jrgt	#nxtp

	cmp	a10,a8
	jrlt	#cslp


	addi	512*8,a9		;Next line

	add	a5,a7
	cmpi	254<<8,a7
	jrlt	#lp


#x	PULL	a4,a14
	rets


#*****************************************************************************
* Remove an object from OBJLST and move it to BAKLST
* a0=*obj
* Trashes a1,a14

 SUBR	fg2bg

	movi	OBJLST,a1

#loop
	move	a1,a14
	move	*a1,a1,L
	jrz	#not_found
	cmp	a0,a1
	jrne	#loop

	;found it
	move	*a0,*a14,L		;remove from OBJLST
	callr	INSBOBJ			;add to BAKLST

	move	*a0(ODXOFF),a1		;adjust X and Y pos.  BGND objects
	move	*a0(OXPOS),a14		; don't use anim points.
	sub	a1,a14
	move	a14,*a0(OXPOS)
	clr	a14
	move	a14,*a0(ODXOFF)

	move	*a0(ODYOFF),a1
	move	*a0(OYPOS),a14
	sub	a1,a14
	move	a14,*a0(OYPOS)
	clr	a14
	move	a14,*a0(ODYOFF)

#not_found
	rets

#*****************************************************************************
* Create an object from one of jason's special header blocks.
* >a0=*block
* <a8=*obj
* Trashes a14

 SUBR	BEGINOBJ_TBL

	PUSH	a0,a1,a2,a3,a4,a5,a6,a7
	move	a0,a14
	move	*a14+,a0,W		;X
	sll	16,a0
	move	*a14+,a1,W		;Y
	sll	16,a1
	move	*a14+,a3,W		;Z
	move	*a14+,a2,L		;IMG
	move	*a14+,a4,W		;CTRL
	move	*a14+,a5,W		;OID
	move	*a14+,a6,L		;X vel
	move	*a14+,a7,L		;Y vel

	calla	BEGINOBJ

	PULL	a0,a1,a2,a3,a4,a5,a6,a7
	rets

 SUBR	BEGINOBJW_TBL

	PUSH	a0,a1,a2,a3,a4,a5,a6,a7
	move	a0,a14
	move	*a14+,a0,W		;X
	sll	16,a0
	move	*a14+,a1,W		;Y
	sll	16,a1
	move	*a14+,a3,W		;Z
	move	*a14+,a2,L		;IMG
	move	*a14+,a4,W		;CTRL
	move	*a14+,a5,W		;OID
	move	*a14+,a6,L		;X vel
	move	*a14+,a7,L		;Y vel

	calla	BEGINOBJW

	PULL	a0,a1,a2,a3,a4,a5,a6,a7
	rets

******************************************************************************

PLACE_SHADOWS
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14
	mmtm	sp,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14

	move	@process_ptrs,a13,L
	jrz	shad9
	MOVE	A13,A3
	addi	OBJ_BASE,a3
	move	*a3,a3,L
	addi	020h,a3

	movi	DMACTRL,b0
shad_1	move	*b0,b3,W
	jrn	shad_1	 	; wait for dma while busy

	movi	>01000100,a2
	move	a2,@DMASCALEX,L	 	; dma input #1 = scale
;	movi	bpal_black*>10000,a2
*TEMP
	movi	010101010h,a2
;	CLR	A2
*TEMP
	move	a2,@DMACMAP,L	    	; dma input #2 = const:palette
*
* setup dedicated registers
*
*  b0 = dmactrl
*  b1 = worldtly
*  a2 = dma y:x size pointer
*  a3 = dma control:offset
*  a6 = dma y coordinate pointer
* a12 = dma sag pointer
*

	movi	DMAVERT,a6
	movk	1,a8
	move	a8,*a6(020h),W		; y size is always "1"
	movi	DMAOFFST,a2
	clr	a8
	move	a8,*a2+,W     		; offset is always "0"
	movi	DMAHORIZ,b6
	movi	02000000h,a7
	movi	DMASAGL,a12
	move	@page_addr,a5,L

shad0	
	move	*a3+,a9,L
	move	*a9(OXPOS),a0,W
	zext	a0,W
;	sll	16,a13
;	or	a13,a0			; a0 = ani y:x for all pieces (world)

	move	b1,a14			; a14 = worldtly
	CLR	A13
	move	@WORLDTLX+16,a13
	SUBXY	A13,A0

	move	@WORLDTLY+16,A13
	SUBI	10,A13
	SLL	16,A13
	SUBXY	A13,A0

	addxy	a5,a0
	MOVE	A0,B8
	MOVE	B8,*B6,L	;DO XPOS

	MOVE	A0,B4

	.ALIGN
**************************************************************************
*											     *
*  piece by piece loop									     *
*											     *
**************************************************************************
shad2
	move	*a9(OYPOS),a10
	jrn	shad9
	move	*a9(OSAG),a10,L	; a10 = sag of this piece
	jrz	shad9			; sag = 0 ---> we are done

	add	a7,a10

	move	*a9(OSIZEY),a13,W	; a13 = # of lines
	srl	3,a13			; shadows are 1/4 the normal height
	move	a13,b5

	move	*a9(OSIZEX),a11,W
	move	a11,*a6(010h),W		; set a11 = x size for this piece

	move	*a9(ODXOFF),A13
	move	*a9(OCTRL),a14,W
	btst	B_FLIPH,a14		; flip horizontal ?
	jreq	shad1
	NEG	A13

shad1	move	a14,a1
	move	a14,a4
	sll	16+4,a1
	srl	32-2,a1			; a1 = trail multiplier
	sll	16+4+2,a4
	srl	32-2,a4			; a4 = lead multiplier

	ori	DMACNZ,a14

	MOVE	B4,A0
	SUBXY	A13,A0
	move	a0,b8
	move	b8,*b6,W		; set x coordinate here !!
	srl	16,a0
	move	*a9(ODYOFF),A13
	SRL	3,A13
	SUBXY	A13,A0

**************************************************************************
*											     *
*  line by line loop									     *
*											     *
**************************************************************************

shad4
shad3	move	*b0,b3,W
	jrn	shad3 	      	; wait for dma while busy

	sub	A7,a10
	move	a10,*a12,L	; stuff sag
	add	A7,a10

	move	a0,*a6,W      	; set y coordinate
	move	a14,*a2,W     	; set the GO! bit
	dsjs	b5,shad5

**************************************************************************
*											     *
*  do the last line again to fill in "holes"					     *
*											     *
**************************************************************************
	inc	a0
	move	a0,*a6,W	; set y 1 line down
	dec	a0

shad6	move	*b0,b3,W
	jrn	shad6	    	; wait for dma while busy
	move	a14,*a2,W	; set the GO
	move	*a3+,a9,L
	jruc	shad2

*
* skip 4 lines
*
shad5	move	*b0,b3,W
	jrn	shad5	 	; wait for dma while busy
	inc	a0
	movk	8,b3
 	setf	8,0,0	 	; field 0 is 8 bits (zero extend)

shad7	move	*a10+,a8,W	; grab a BYTE !!

	move	a8,a13
	sll	32-4,a13
	srl	32-4,a13	; mask off upper b.s.
	sll	a4,a13		; a13 = lead zeros

	srl	4,a8		
	sll	a1,a8		; a8 = trailing zeros

	add	a8,a13		; a13 = lead + trailing = all compressed zeros
	move	a11,a8		; a8 = x size
	sub	a13,a8		; a8 = uncompressed pixels to skip

	sll	1,a8  		; 2x
	add	a8,a10
	sll	1,a8  		; + 4x = 6 bits per pixel
	add	a8,a10		; a10 ---> sag for next line
	dsjs	b3,shad7

;xx
	setf	16,1,0		; field 0 is back to 16 bits
	jruc	shad4

shad9
	mmfm	sp,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14
	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14
	rets

;******************************************************************************
;
;PLACE_SHADOWS
;	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14
;	mmtm	sp,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14
;
;	move	@process_ptrs,a3,L
;	jrz	shad9
;	addi	OBJ_BASE,a3
;	move	*a3,a3,L
;	addi	020h,a3
;
;	movi	DMACTRL,b0
;shad_1	move	*b0,b3,W
;	jrn	shad_1	 	; wait for dma while busy
;
;	movi	>01000100,a2
;	move	a2,@DMASCALEX,L	 	; dma input #1 = scale
;;	movi	bpal_black*>10000,a2
;*TEMP
;	CLR	A2
;*TEMP
;	move	a2,@DMACMAP,L	    	; dma input #2 = const:palette
;*
;* setup dedicated registers
;*
;*  b0 = dmactrl
;*  b1 = worldtly
;*  a2 = dma y:x size pointer
;*  a3 = dma control:offset
;*  a6 = dma y coordinate pointer
;* a12 = dma sag pointer
;*
;
;	movi	DMAVERT,a6
;	movk	1,a8
;	move	a8,*a6(020h),W		; y size is always "1"
;	movi	DMAOFFST,a2
;	clr	a8
;	move	a8,*a2+,W     		; offset is always "0"
;	movi	DMAHORIZ,b6
;	movi	02000000h,a7
;	movi	DMASAGL,a12
;	move	@page_addr,a5,L
;
;shad0	
;	move	*a3+,a9,L
;	move	*a9(OYPOS),a13,W
;	move	*a9(OXPOS),a0,W
;	zext	a0,W
;	sll	16,a13
;	or	a13,a0			; a0 = ani y:x for all pieces (world)
;
;	move	b1,a14			; a14 = worldtly
;	CLR	A13
;	move	@WORLDTLX+16,a13
;	SUBXY	A13,A0
;
;	move	@WORLDTLY+16,A13
;	SLL	16,A13
;	ADDXY	A13,A0
;
;	addxy	a5,a0
;	MOVE	A0,B8
;	MOVE	B8,*B6,L	;DO XPOS
;
;	MOVE	A0,B4
;
;**************************************************************************
;*											     *
;*  piece by piece loop									     *
;*											     *
;**************************************************************************
;
;shad2	move	*a9(OSAG),a10,L	; a10 = sag of this piece
;	jrz	shad9			; sag = 0 ---> we are done
;
;	add	a7,a10
;
;	move	*a9(OSIZEY),a13,W	; a13 = # of lines
;	srl	2,a13			; shadows are 1/4 the normal height
;	move	a13,b5
;
;	move	*a9(OSIZEX),a11,W
;	move	a11,*a6(010h),W		; set a11 = x size for this piece
;
;	move	*a9(OCTRL),a14,W
;	btst	B_FLIPH,a14		; flip horizontal ?
;	jreq	shad1
;	addxy	a11,a0			; yes, adjust coordinates for flip
;	dec	a0			; and nudge..
;
;shad1	move	a14,a1
;	move	a14,a4
;	sll	16+4,a1
;	srl	32-2,a1			; a1 = trail multiplier
;	sll	16+4+2,a4
;	srl	32-2,a4			; a4 = lead multiplier
;
;	ori	DMACNZ,a14
;
;	MOVE	B4,A0
;	move	a0,b8
;	move	b8,*b6,W		; set x coordinate here !!
;	srl	16,a0
;
;**************************************************************************
;*											     *
;*  line by line loop									     *
;*											     *
;**************************************************************************
;
;shad4
;shad3	move	*b0,b3,W
;	jrn	shad3 	      	; wait for dma while busy
;
;	sub	A7,a10
;	move	a10,*a12,L	; stuff sag
;	add	A7,a10
;
;	move	a0,*a6,W      	; set y coordinate
;	move	a14,*a2,W     	; set the GO! bit
;	dsjs	b5,shad5
;
;**************************************************************************
;*											     *
;*  do the last line again to fill in "holes"					     *
;*											     *
;**************************************************************************
;	inc	a0
;	move	a0,*a6,W	; set y 1 line down
;	dec	a0
;
;shad6	move	*b0,b3,W
;	jrn	shad6	    	; wait for dma while busy
;
;	move	a14,*a2,W	; set the GO
;
;	move	*a3+,a9,L
;
;	jruc	shad2
;
;*
;* skip 4 lines
;*
;shad5	move	*b0,b3,W
;	jrn	shad5	 	; wait for dma while busy
;
;	inc	a0
;
;	movk	4,b3
; 	setf	8,0,0	 	; field 0 is 8 bits (zero extend)
;
;shad7	move	*a10+,a8,W	; grab a BYTE !!
;
;	move	a8,a13
;	sll	32-4,a13
;	srl	32-4,a13	; mask off upper b.s.
;	sll	a4,a13		; a13 = lead zeros
;
;	srl	4,a8		
;	sll	a1,a8		; a8 = trailing zeros
;
;	add	a8,a13		; a13 = lead + trailing = all compressed zeros
;	move	a11,a8		; a8 = x size
;	sub	a13,a8		; a8 = uncompressed pixels to skip
;
;	sll	1,a8  		; 2x
;	add	a8,a10
;	sll	1,a8  		; + 4x = 6 bits per pixel
;	add	a8,a10		; a10 ---> sag for next line
;	dsjs	b3,shad7
;
;;xx
;	setf	16,1,0		; field 0 is back to 16 bits
;	jruc	shad4
;
;shad9
;	mmfm	sp,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14
;	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14
;	rets
;

******************************************************************************
	.end




