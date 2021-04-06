**************************************************************
*
* Software:	Jason Skiles
* Initiated:	28 Apr 94
*
* COPYRIGHT (C) 1993 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 4/28/94 22:12
**************************************************************

	.file	"crowd.asm"
	.title	"crowd stuff"
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

	.INCLUDE	"SOUND.EQU"
	.include	"crowdimg.tbl"
	.include	"crowdimg.glo"
	.include	"bgndtbl.glo"
	.include	"imgtbl.glo"

#*****************************************************************************

	.ref	BAKLST,RNDRNG0,RNDPER,START_FLASHES,no_debris,reduce_bog

#*****************************************************************************

DEF_ANISPD	equ	8
SPD_FOREVER	equ	7FFFh

CROWD_OBJS	equ	0h
CROWD_NORMANIM	equ	20h
CROWD_CHEERANIM	equ	40h

CANI_GOTO	equ	0 + 8000h
CANI_RNDWAIT	equ	1 + 8000h
CANI_END		equ	2 + 8000H
CANI_CODE	EQU	3 + 8000H
CANI_REPEAT	EQU	4 + 8000H
CANI_SHOULD_REPEAT EQU	5 + 8000H

*STRUCT BOBJANIM
SCPTR	.set	000	;UHL script pointer (next instruction)
TIME	.set	020h	;UHW time to hold
FRAME	.set	030h	;UHL current obj
CHEER1	.set	050h	;UHL cheer1 jump point
CHEER2	.set	070h	;UHL cheer2 jump point
REPEAT_P .SET	090H	;UHL REPEAT POINT TO JUMP BACK TO
REPEAT_N .SET	0B0H	;UHW REPEAT THIS NUMBER OF TIMES
*ENDSTRUCT
BSIZE		equ	REPEAT_N+10h

NUMCROWD	equ	30

HICROWDZ	equ	58/2		;high z (after shift)

	BSSX	CROWDDATA,(NUMCROWD+1)*BSIZE

	BSSX	crowd_process,32

#*****************************************************************************
* Main crowd control process
*

;NOTE:  The background stuff is doing SOMETHING with ODXOFF and ODYOFF, so
;       I'm storing anim points in OXVEL and OYVEL instead.  Those seem safe.

 SUBR	crowd_anim

	move	a13,@crowd_process,L

	;initialize
	movi	NUMCROWD,a0
	movi	CROWD_ANIMS,a1
	movi	CROWDDATA,a2
#initloop
	move	*a1+,a3,L
	move	*a3+,a14,W
	move	a14,*a2(TIME),W
	move	*a3+,a14,L
	move	a14,*a2(FRAME),L
	move	a3,*a2(SCPTR),L
	move	*a1+,a14,L
	move	a14,*a2(CHEER1),L
	move	*a1+,a14,L
	move	a14,*a2(CHEER2),L
	CLR	A14
	MOVE	A14,*A2(REPEAT_P),L
	MOVE	A14,*A2(REPEAT_N)
	addi	BSIZE,a2
	dsj	a0,#initloop

	clr	a14
	move	a14,*a2(SCPTR),L

#main_loop
	;if we're in reduce_bog mode, sleep until someone wakes us up.
	movk	1,a0
	move	@reduce_bog,a14
	jrz	#slp
	movi	7FFFh,a0
#slp	SLEEPR	a0

	;update CROWDDATA
	movi	CROWDDATA-BSIZE,a4
#cd_loop
	addi	BSIZE,a4
	move	*a4(SCPTR),a14,L
	jrz	#cd_done
	callr	animate_back
	jruc	#cd_loop


 SUBR	animate_back
	move	*a4(TIME),a14,W
	dec	a14
	jrz	#next_command
	move	a14,*a4(TIME),W
	MOVK	1,A14
	rets


#next_command
	move	*a4(SCPTR),a5,L
#next_in_the_QUEUE
	move	*a5+,a14,W
	jrn	#cani_command
	move	a14,*a4(TIME),W
	move	*a5+,a14,L
	move	a14,*a4(FRAME),L
	move	a5,*a4(SCPTR),L

	;You think a simple CLR would do the job here?  Try it.  I dare you.
	MOVK	1,A14
	DEC	A14
	rets

#cani_command
	andi	7FFFh,a14
	X32	a14
	addi	#cani_commands,a14
	move	*a14,a14,L
	jump	a14

#cani_commands
	.long	#_goto
	.long	#_rndwait
	.LONG	#_END_ANIM
	.LONG	#_CODE
	.LONG	#_RANDOM_REPEAT
	.LONG	#_SHOULD_WE_WE_REPEAT

**********
#_CODE
	MOVE	*A5+,A0,L
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14
	CALL	A0
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14
	jruc	#next_in_the_QUEUE


#_END_ANIM
	MOVI	-1,A14
	RETS

#_goto
	move	*a5+,a5,L
	move	a5,*a4(SCPTR),L
	jruc	#next_command

**********
#_rndwait
	move	*a5+,a0,W
	calla	RNDRNG0
	move	a0,*a4(TIME),W
	move	a5,*a4(SCPTR),L
	rets

#_RANDOM_REPEAT
	MOVE	*A5+,A0
	MOVE	A5,*A4(REPEAT_P),L
	CALLA	RNDRNG0
	MOVE	A0,*A4(REPEAT_N)
	jruc	#next_in_the_QUEUE

#_SHOULD_WE_WE_REPEAT
	MOVE	*A4(REPEAT_N),A0
	DEC	A0
	MOVE	A0,*A4(REPEAT_N)
	JRZ	REACHED_LAST_LOOP
	JRN	REACHED_LAST_LOOP
	MOVE	*A4(REPEAT_P),*A4(SCPTR),L
	MOVE	*A4(REPEAT_P),A5,L
	jruc	#next_in_the_QUEUE
REACHED_LAST_LOOP
	CLR	A0
	MOVE	A0,*A4(REPEAT_N)
	jruc	#next_in_the_QUEUE



#cd_done
	.ref	PCNT
	move	@PCNT,a14
	btst	0,a14
	jrz	#main_loop


	;update BAKLST
	move	@BAKLST,a8,L

#bakloop
	move	*a8(OZPOS),a0,W
	srl	1,a0
	jrc	#bakskip
	cmpi	HICROWDZ,a0
	jrgt	#bakskip

	move	a0,a1
	X64	a1
	X128	a0
	add	a1,a0

	addi	CROWDDATA,a0
	move	*a0(FRAME),a0,L
	move	*a8(OIMG),a1,L
	cmp	a0,a1
	jreq	#bakskip

;	callr	anibobj
	move	*a8(OCTRL),a1,W

	move	*a8(OXPOS),a2,W
	move	*a8(OXVEL),a3,W
	move	*a0(IANIOFFX),a4,W
	clr	a5
	btst	B_FLIPH,a1
	jrz	#noflip

	;obj is horz-flipped.  negate the Xanim point and adjust X pos
	; by XSZold-XSZnew
	neg	a4
	move	*a8(OSIZEX),a5,W
	move	*a0(ISIZEX),a14,W
	sub	a14,a5
#noflip
	add	a3,a2
	sub	a4,a2
	add	a5,a2
	move	a2,*a8(OXPOS),W
	move	a4,*a8(OXVEL),W


	move	*a8(OYPOS),a2,W
	move	*a8(OYVEL),a3,W
	move	*a0(IANIOFFY),a4,W
	add	a3,a2
	sub	a4,a2
	move	a2,*a8(OYPOS),W
	move	a4,*a8(OYVEL),W

	move	a0,a2
	move	a1,a3

	move	a2,*a8(OIMG),L
	move	*a2(0),*a8(OSIZE),L
	move	*a2(ISAG),*a8(OSAG),L

	setf	5,0,0
	move	*a2(ICTRL+7),*a8(OCTRL+7) ;Write 5 z comp bits
;	setf	6,0,0
;	move	a3,*a8(OCTRL)		;Write 6 low bits
	setf	16,1,0
#bakskip
	move	*a8,a8,L
 	jrnz	#bakloop


	jruc	#main_loop


;crowd anim starting points
CROWD_ANIMS
	.long	#jasoncrd_norm, #jasoncrd_cheer1,#jasoncrd_cheer2
	.long	#tonycrd_norm,  #tonycrd_cheer1 ,#tonycrd_cheer1
	.long	#vogel_norm,    #vogel_cheer1	 ,#vogel_cheer2
	.long	#tobias_norm,   #tobias_cheer1	 ,#tobias_cheer2
	.long	#alex_norm,     #alex_cheer1	 ,#alex_cheer2

	.long	#marine_norm,   #marine_cheer1	 ,#marine_cheer2
	.long	#jake_norm,     #jake_cheer1	 ,#jake_cheer2
	.long	#johnc_norm,    #johnc_cheer1	 ,#johnc_cheer2
	.long	#dewey_norm,    #dewey_cheer1	 ,#dewey_cheer2
	.long	#jason_norm,    #jason_cheer1	 ,#jason_cheer2

	.long	#jamie_norm,    #jamie_cheer1	 ,#jamie_cheer2
	.long	#sheridan_norm, #sheridan_cheer1,#sheridan_cheer2
	.long	#sal_norm,      #sal_cheer1	 ,#sal_cheer2
	.long	#josh_norm,     #josh_cheer1	 ,#josh_cheer2
	.long	#mark_norm,     #mark_cheer1	 ,#mark_cheer1

	.long	#tony_norm,     #tony_cheer1	 ,#tony_cheer2
	.long	#carlos_norm,   #carlos_cheer1	 ,#carlos_cheer2
	.long	#newc_norm,     #newc_cheer1	 ,#newc_cheer2
	.long	#joy_norm,      #joy_cheer1	 ,#joy_cheer1
	.long	#side1_norm,    #side1_cheer1	 ,#side1_cheer1

	.long	#side2_norm,    #side2_cheer1	 ,#side2_cheer1
	.long	#side3_norm,    #side3_cheer1	 ,#side3_cheer1
	.long	#george_norm,   #george_cheer1	 ,#george_cheer1
	.long	#dave_norm,     #dave_cheer1	 ,#dave_cheer1
	.long	#sophia_norm,   #sophia_cheer1	 ,#sophia_cheer2

	.long	#mancow_norm,   #mancow_cheer1	 ,#mancow_cheer2
	.long	#jak2_norm,	#jak2_cheer1	 ,#jak2_cheer2
	.long	#eugene_norm,	#eugene_cheer1	 ,#eugene_cheer2
	.long	#penacho_norm,	#penacho_cheer1 ,#penacho_cheer2
	.long	#jenni_norm,	#jenni_cheer1 	 ,#jenni_cheer2


**********
* SOPHIA

#SOPHIA_SPD	equ	7

#sophia_norm
	WL	SPD_FOREVER,SOFI1
	WL	CANI_GOTO,#sophia_norm

#sophia_cheer1
	WL	#SOPHIA_SPD,SOFI2
	WL	#SOPHIA_SPD,SOFI3
	WL	#SOPHIA_SPD,SOFI4
	WL	#SOPHIA_SPD,SOFI3
	WL	#SOPHIA_SPD,SOFI2
	WL	CANI_GOTO,#sophia_norm

#sophia_cheer2
	WL	#SOPHIA_SPD,SOFI2
	.WORD	CANI_REPEAT,4
	WL	#SOPHIA_SPD,SOFI3
	WL	#SOPHIA_SPD,SOFI4
	.WORD	CANI_SHOULD_REPEAT
	WL	#SOPHIA_SPD,SOFI3
	WL	#SOPHIA_SPD,SOFI2
	WL	CANI_GOTO,#sophia_norm

**********
* MANCOW

#MANCOW_SPD	equ	6

#mancow_norm
	WL	SPD_FOREVER,MANC1
	WL	CANI_GOTO,#mancow_norm

#mancow_cheer1
	WL	#MANCOW_SPD,MANC2
	WL	#MANCOW_SPD,MANC3
	WL	#MANCOW_SPD,MANC4
	WL	#MANCOW_SPD,MANC5
	WL	#MANCOW_SPD,MANC4
	WL	#MANCOW_SPD,MANC3
	WL	#MANCOW_SPD,MANC2
	WL	CANI_GOTO,#mancow_norm

#mancow_cheer2
	WL	#MANCOW_SPD,MANC2
	.WORD	CANI_REPEAT,6
	WL	#MANCOW_SPD,MANC3
	WL	#MANCOW_SPD,MANC4
	WL	#MANCOW_SPD,MANC5
	WL	#MANCOW_SPD,MANC4
	.WORD	CANI_SHOULD_REPEAT
	WL	#MANCOW_SPD,MANC3
	WL	#MANCOW_SPD,MANC2
	WL	CANI_GOTO,#mancow_norm

**********
* JAK

#JAK_SPD	equ	7

#jak2_norm
	WL	SPD_FOREVER,JAK1
	WL	CANI_GOTO,#jak2_norm

#jak2_cheer1
	WL	#JAK_SPD,JAK2
	WL	#JAK_SPD,JAK3
	WL	#JAK_SPD,JAK4
	WL	#JAK_SPD+3,JAK5
	WL	#JAK_SPD,JAK4
	WL	#JAK_SPD,JAK3
	WL	#JAK_SPD,JAK2
	WL	CANI_GOTO,#jak2_norm

#jak2_cheer2
	WL	#JAK_SPD,JAK2
	.WORD	CANI_REPEAT,7
	WL	#JAK_SPD,JAK3
	WL	#JAK_SPD,JAK4
	WL	#JAK_SPD+3,JAK5
	WL	#JAK_SPD,JAK4
	.WORD	CANI_SHOULD_REPEAT
	WL	#JAK_SPD,JAK3
	WL	#JAK_SPD,JAK2
	WL	CANI_GOTO,#jak2_norm


**********
* EUGENE

#EUGENE_SPD	equ	7

#eugene_norm
	WL	SPD_FOREVER,EUG1
	WL	CANI_GOTO,#eugene_norm

#eugene_cheer1
	WL	#EUGENE_SPD,EUG2
	WL	#EUGENE_SPD,EUG3
	WL	#EUGENE_SPD,EUG4
	WL	#EUGENE_SPD,EUG3
	WL	#EUGENE_SPD,EUG2
	WL	CANI_GOTO,#eugene_norm

#eugene_cheer2
	WL	#EUGENE_SPD,EUG2
	.WORD	CANI_REPEAT,3
	WL	#EUGENE_SPD,EUG3
	WL	#EUGENE_SPD,EUG4
	.WORD	CANI_SHOULD_REPEAT
	WL	#EUGENE_SPD,EUG3
	WL	#EUGENE_SPD,EUG2
	WL	CANI_GOTO,#eugene_norm

**********
* JENNI

#JENNI_SPD	equ	7

#jenni_norm
	WL	SPD_FOREVER,JENI1
	WL	CANI_GOTO,#jenni_norm

#jenni_cheer1
	WL	#JENNI_SPD,JENI2
	WL	#JENNI_SPD,JENI3
	WL	#JENNI_SPD,JENI4
	WL	#JENNI_SPD,JENI3
	WL	#JENNI_SPD,JENI2
	WL	CANI_GOTO,#jenni_norm

#jenni_cheer2
	WL	#JENNI_SPD,JENI2
	.WORD	CANI_REPEAT,3
	WL	#JENNI_SPD,JENI3
	WL	#JENNI_SPD,JENI4
	.WORD	CANI_SHOULD_REPEAT
	WL	#JENNI_SPD,JENI3
	WL	#JENNI_SPD,JENI2
	WL	CANI_GOTO,#jenni_norm

**********
* PENACHO

#PENACHO_SPD	equ	7

#penacho_norm
	WL	SPD_FOREVER,PENA1
	WL	CANI_GOTO,#penacho_norm

#penacho_cheer1
	WL	#PENACHO_SPD,PENA2
	WL	#PENACHO_SPD,PENA3
	WL	#PENACHO_SPD,PENA4
	WL	#PENACHO_SPD,PENA3
	WL	#PENACHO_SPD,PENA2
	WL	CANI_GOTO,#penacho_norm

#penacho_cheer2
	.WORD	CANI_REPEAT,4
	WL	#PENACHO_SPD,PENA2
	WL	#PENACHO_SPD,PENA3
	WL	#PENACHO_SPD,PENA4
	WL	#PENACHO_SPD,PENA3
	.WORD	CANI_SHOULD_REPEAT
	WL	#PENACHO_SPD,PENA2
	WL	CANI_GOTO,#penacho_norm




**********
* Alex

#ALEX_SPD	equ	6

#alex_norm
	WL	SPD_FOREVER,ALEX1
	WL	CANI_GOTO,#alex_norm

#alex_cheer1
	WL	#ALEX_SPD,ALEX2
	WL	#ALEX_SPD,ALEX3
	WL	#ALEX_SPD,ALEX4
	WL	#ALEX_SPD,ALEX2
	WL	CANI_GOTO,#alex_norm
#alex_cheer2
	WL	#ALEX_SPD,ALEX2
	WL	#ALEX_SPD,ALEX3
	.WORD	CANI_REPEAT,7
	WL	#ALEX_SPD,ALEX4
	WL	#ALEX_SPD,ALEX3
	.WORD	CANI_SHOULD_REPEAT
	WL	#ALEX_SPD,ALEX2
	WL	CANI_GOTO,#alex_norm

**********
* Carlos

#CARLOS_SPD	equ	7

#carlos_norm
	WL	SPD_FOREVER,CARLO1
	WL	CANI_GOTO,#carlos_norm

#carlos_cheer1
	WL	#CARLOS_SPD,CARLO2
	WL	#CARLOS_SPD,CARLO3
	WL	#CARLOS_SPD,CARLO4
	WL	#CARLOS_SPD,CARLO2
	WL	CANI_GOTO,#carlos_norm

#carlos_cheer2
	WL	#CARLOS_SPD,CARLO2
	WL	#CARLOS_SPD,CARLO3
	WL	#CARLOS_SPD,CARLO4
	.WORD	CANI_REPEAT,7
	WL	#CARLOS_SPD,CARLO3
	WL	#CARLOS_SPD,CARLO4
	.WORD	CANI_SHOULD_REPEAT
	WL	#CARLOS_SPD,CARLO2
	WL	CANI_GOTO,#carlos_norm

**********
* Dave

#DAVE_SPD	equ	8

#dave_norm
	WL	SPD_FOREVER,DAVEMSK1
	WL	CANI_GOTO,#dave_norm

#dave_cheer1
	WL	#DAVE_SPD,DAVEMSK2
	WL	#DAVE_SPD,DAVEMSK3
	WL	#DAVE_SPD,DAVEMSK4
	WL	#DAVE_SPD,DAVEMSK3
	WL	#DAVE_SPD,DAVEMSK2
	WL	CANI_GOTO,#dave_norm

#dave_cheer2
	.WORD	CANI_REPEAT,7
	WL	#DAVE_SPD,DAVEMSK2
	WL	#DAVE_SPD,DAVEMSK3
	.WORD	CANI_SHOULD_REPEAT
	WL	#DAVE_SPD,DAVEMSK4
	WL	#DAVE_SPD,DAVEMSK3
	WL	#DAVE_SPD,DAVEMSK2
	WL	CANI_GOTO,#dave_norm

**********
* Dewey

#DEWEY_SPD	equ	7

#dewey_norm
	WL	#DEWEY_SPD,DEWY1
	.word	CANI_RNDWAIT,TSEC*10
	WL	#DEWEY_SPD,DEWY2
	WL	#DEWEY_SPD,DEWY3
	WL	#DEWEY_SPD,DEWY4
	WL	#DEWEY_SPD,DEWY3
	WL	#DEWEY_SPD,DEWY2
	WL	CANI_GOTO,#dewey_norm

#dewey_cheer1
	WL	#DEWEY_SPD,DEWY1
	WL	#DEWEY_SPD,DEWY2
	WL	#DEWEY_SPD,DEWY3
	WL	#DEWEY_SPD,DEWY4
	WL	#DEWEY_SPD,DEWY3
	WL	#DEWEY_SPD,DEWY2
	WL	CANI_GOTO,#dewey_norm

#dewey_cheer2
	WL	#DEWEY_SPD,DEWY1
	.WORD	CANI_REPEAT,7
	WL	#DEWEY_SPD,DEWY2
	WL	#DEWEY_SPD,DEWY3
	WL	#DEWEY_SPD,DEWY4
	WL	#DEWEY_SPD,DEWY3
	WL	#DEWEY_SPD,DEWY2
	WL	#DEWEY_SPD,DEWY3
	WL	#DEWEY_SPD,DEWY4
	WL	#DEWEY_SPD,DEWY3
	.WORD	CANI_SHOULD_REPEAT
	WL	#DEWEY_SPD,DEWY2
	WL	CANI_GOTO,#dewey_norm

**********
* George

#GEORGE_SPD	equ	8

#george_norm
	WL	#GEORGE_SPD,GEORGE1
	.word	CANI_RNDWAIT,TSEC*4
	WL	#GEORGE_SPD,GEORGE2
	WL	#GEORGE_SPD,GEORGE3
	WL	#GEORGE_SPD,GEORGE4
	WL	#GEORGE_SPD,GEORGE3
	WL	#GEORGE_SPD,GEORGE2
	WL	CANI_GOTO,#george_norm

#george_cheer1
	.WORD	CANI_REPEAT,2
	WL	#GEORGE_SPD,GEORGE1
	WL	#GEORGE_SPD,GEORGE2
	WL	#GEORGE_SPD,GEORGE3
	WL	#GEORGE_SPD,GEORGE4
	WL	#GEORGE_SPD,GEORGE3
	WL	#GEORGE_SPD,GEORGE2
	.WORD	CANI_SHOULD_REPEAT
	WL	CANI_GOTO,#george_norm

**********
* Jake

#JAKE_SPD	equ	8

#jake_norm
	WL	SPD_FOREVER,JAKE1
	WL	CANI_GOTO,#jake_norm

#jake_cheer1
	WL	#JAKE_SPD,JAKE2
	WL	#JAKE_SPD,JAKE3
	WL	#JAKE_SPD,JAKE4
	WL	#JAKE_SPD,JAKE2
	WL	CANI_GOTO,#jake_norm

#jake_cheer2
	WL	#JAKE_SPD,JAKE2
	.WORD	CANI_REPEAT,4
	WL	#JAKE_SPD,JAKE3
	WL	#JAKE_SPD,JAKE4
	.WORD	CANI_SHOULD_REPEAT
	WL	#JAKE_SPD,JAKE2
	WL	CANI_GOTO,#jake_norm

**********
* Jamie

#JAMIE_SPD	equ	5

#jamie_norm
	WL	SPD_FOREVER,JAMIE1
	WL	CANI_GOTO,#jamie_norm

#jamie_cheer1
	WL	#JAMIE_SPD,JAMIE2
	WL	#JAMIE_SPD,JAMIE3
	WL	#JAMIE_SPD,JAMIE4
	WL	#JAMIE_SPD,JAMIE5
	WL	#JAMIE_SPD,JAMIE6
	WL	CANI_GOTO,#jamie_norm

#jamie_cheer2
	.WORD	CANI_REPEAT,7
	WL	#JAMIE_SPD,JAMIE2
	WL	#JAMIE_SPD,JAMIE3
	.WORD	CANI_SHOULD_REPEAT
	WL	#JAMIE_SPD,JAMIE4
	WL	#JAMIE_SPD,JAMIE5
	WL	#JAMIE_SPD,JAMIE6
	WL	CANI_GOTO,#jamie_norm

**********
* Jason

#JASON_SPD	equ	6

#jason_norm
	WL	SPD_FOREVER,SERG1
	WL	CANI_GOTO,#jason_norm

#jason_cheer1
	WL	#JASON_SPD,SERG2
	WL	#JASON_SPD,SERG3
	WL	#JASON_SPD,SERG4
	WL	#JASON_SPD,SERG5
	WL	#JASON_SPD,SERG4
	WL	#JASON_SPD,SERG3
	WL	#JASON_SPD,SERG2
	WL	CANI_GOTO,#jason_norm

#jason_cheer2
	WL	#JASON_SPD,SERG2
	WL	#JASON_SPD,SERG3
	.WORD	CANI_REPEAT,7
	WL	#JASON_SPD,SERG4
	WL	#JASON_SPD,SERG5
	WL	#JASON_SPD,SERG4
	WL	#JASON_SPD,SERG3
	.WORD	CANI_SHOULD_REPEAT
	WL	#JASON_SPD,SERG2
	WL	CANI_GOTO,#jason_norm


**********
* Jason crowd

#JCROWD_SPD	equ	8

#jasoncrd_norm
	WL	SPD_FOREVER,JASONCRD1
	WL	CANI_GOTO,#jasoncrd_norm

#jasoncrd_cheer1
	WL	#JCROWD_SPD,JASONCRD2
	WL	#JCROWD_SPD,JASONCRD3
	WL	#JCROWD_SPD,JASONCRD4
	WL	#JCROWD_SPD,JASONCRD5
	WL	CANI_GOTO,#jasoncrd_norm

#jasoncrd_cheer2
	WL	#JCROWD_SPD,JASONCRD2
	WL	#JCROWD_SPD,JASONCRD3
	.WORD	CANI_REPEAT,7
	WL	#JCROWD_SPD,JASONCRD4
	WL	#JCROWD_SPD,JASONCRD5
	.WORD	CANI_SHOULD_REPEAT
	WL	CANI_GOTO,#jasoncrd_norm


**********
* JohnC

#JOHNC_SPD	equ	8

#johnc_norm
	WL	SPD_FOREVER,JOHNC1
	WL	CANI_GOTO,#johnc_norm

#johnc_cheer1
	WL	#JOHNC_SPD,JOHNC2
	WL	#JOHNC_SPD,JOHNC3
	WL	#JOHNC_SPD*3,JOHNC4
	WL	#JOHNC_SPD,JOHNC3
	WL	#JOHNC_SPD,JOHNC2
	WL	CANI_GOTO,#johnc_norm

#johnc_cheer2
	WL	#JOHNC_SPD,JOHNC2
	WL	#JOHNC_SPD,JOHNC3
	WL	#JOHNC_SPD,JOHNC4
	WL	#JOHNC_SPD,JOHNC3
	WL	#JOHNC_SPD*3,JOHNC4
	WL	#JOHNC_SPD,JOHNC3
	WL	#JOHNC_SPD,JOHNC2
	WL	CANI_GOTO,#johnc_norm

**********
* Josh

#JOSH_SPD	equ	7

#josh_norm
	WL	SPD_FOREVER,JOSH1
	WL	CANI_GOTO,#josh_norm

#josh_cheer1
	WL	#JOSH_SPD,JOSH2
	WL	#JOSH_SPD,JOSH3
	WL	#JOSH_SPD,JOSH4
	WL	#JOSH_SPD,JOSH3
	WL	#JOSH_SPD,JOSH4
	WL	#JOSH_SPD,JOSH2
	WL	CANI_GOTO,#josh_norm

#josh_cheer2
	WL	#JOSH_SPD,JOSH2
	WL	#JOSH_SPD,JOSH3
	WL	#JOSH_SPD,JOSH4
	.WORD	CANI_REPEAT,6
	WL	#JOSH_SPD,JOSH3
	WL	#JOSH_SPD,JOSH4
	.WORD	CANI_SHOULD_REPEAT
	WL	#JOSH_SPD,JOSH2
	WL	CANI_GOTO,#josh_norm


**********
* Joy (side crowd)

#JOY_SPD	equ	8

#joy_norm
	WL	SPD_FOREVER,JOY1
	WL	CANI_GOTO,#joy_norm
#joy_cheer1
	WL	#JOY_SPD,JOY1
	WL	#JOY_SPD,JOY2
	WL	#JOY_SPD,JOY3
	WL	#JOY_SPD,JOY4
	WL	#JOY_SPD,JOY5
	WL	#JOY_SPD,JOY4
	WL	#JOY_SPD,JOY3
	WL	CANI_GOTO,#joy_norm

**********
* Marine

#MARINE_SPD	equ	8

#marine_norm
	WL	SPD_FOREVER,MARINE1
	WL	CANI_GOTO,#marine_norm

#marine_cheer1
	WL	#MARINE_SPD,MARINE2
	WL	#MARINE_SPD,MARINE3
	WL	#MARINE_SPD,MARINE4
	WL	#MARINE_SPD,MARINE2
	WL	CANI_GOTO,#marine_norm

#marine_cheer2
	WL	#MARINE_SPD,MARINE2
	.WORD	CANI_REPEAT,6
	WL	#MARINE_SPD,MARINE3
	WL	#MARINE_SPD,MARINE4
	.WORD	CANI_SHOULD_REPEAT
	WL	#MARINE_SPD,MARINE3
	WL	#MARINE_SPD,MARINE2
	WL	CANI_GOTO,#marine_norm

**********
* Mark

#MARK_SPD	equ	8

#mark_norm
	WL	SPD_FOREVER,TURMEL1
	WL	CANI_GOTO,#mark_norm

#mark_cheer1
	WL	#MARK_SPD,TURMEL2
	WL	#MARK_SPD,TURMEL3
	WL	20,TURMEL4
	WL	#MARK_SPD,TURMEL3
	WL	#MARK_SPD,TURMEL2
	WL	CANI_GOTO,#mark_norm

**********
* Newc

#NEWC_SPD	equ	9

#newc_norm
	WL	SPD_FOREVER,NEWCOM1
	WL	CANI_GOTO,#newc_norm

#newc_cheer1
	WL	#NEWC_SPD,NEWCOM2
	WL	#NEWC_SPD,NEWCOM3
	WL	#NEWC_SPD,NEWCOM4
	WL	#NEWC_SPD,NEWCOM3
	WL	#NEWC_SPD,NEWCOM4
	WL	#NEWC_SPD,NEWCOM3
	WL	#NEWC_SPD,NEWCOM2
	WL	CANI_GOTO,#newc_norm

#newc_cheer2
	WL	#NEWC_SPD,NEWCOM2
	.WORD	CANI_REPEAT,6
	WL	#NEWC_SPD,NEWCOM3
	WL	#NEWC_SPD,NEWCOM4
	.WORD	CANI_SHOULD_REPEAT
	WL	#NEWC_SPD,NEWCOM2
	WL	CANI_GOTO,#newc_norm

**********
* Sal

#SAL_SPD	equ	8

#sal_norm
	WL	SPD_FOREVER,SAL1
	WL	CANI_GOTO,#sal_norm

#sal_cheer1
	WL	#SAL_SPD,SAL2
	WL	#SAL_SPD,SAL3
	WL	#SAL_SPD,SAL4
	WL	#SAL_SPD,SAL3
	WL	#SAL_SPD,SAL4
	WL	#SAL_SPD,SAL3
	WL	#SAL_SPD,SAL2
	WL	CANI_GOTO,#sal_norm

#sal_cheer2
	WL	#SAL_SPD,SAL2
	.WORD	CANI_REPEAT,7
	WL	#SAL_SPD,SAL3
	WL	#SAL_SPD,SAL4
	.WORD	CANI_SHOULD_REPEAT
	WL	#SAL_SPD,SAL2
	WL	CANI_GOTO,#sal_norm

**********
* Sheridan

#SHERIDAN_SPD	equ	8

#sheridan_norm
	WL	1,SHERID1
	.word	CANI_RNDWAIT,TSEC*20
	WL	#SHERIDAN_SPD,SHERID6
	WL	#SHERIDAN_SPD,SHERID7
	WL	#SHERIDAN_SPD*2,SHERID8
	WL	#SHERIDAN_SPD,SHERID7
	WL	#SHERIDAN_SPD,SHERID6
	WL	CANI_GOTO,#sheridan_norm

#sheridan_cheer1
	WL	#SHERIDAN_SPD,SHERID1
	WL	#SHERIDAN_SPD,SHERID2
	WL	#SHERIDAN_SPD,SHERID3
	WL	#SHERIDAN_SPD,SHERID4
	WL	#SHERIDAN_SPD,SHERID5
	WL	#SHERIDAN_SPD,SHERID6
	WL	#SHERIDAN_SPD,SHERID7
	WL	#SHERIDAN_SPD*2,SHERID8
	WL	#SHERIDAN_SPD,SHERID7
	WL	#SHERIDAN_SPD,SHERID6
	WL	CANI_GOTO,#sheridan_norm

#sheridan_cheer2
	WL	#SHERIDAN_SPD,SHERID1
	WL	#SHERIDAN_SPD,SHERID2
	WL	#SHERIDAN_SPD,SHERID3
	.WORD	CANI_REPEAT,3
	WL	#SHERIDAN_SPD,SHERID4
	WL	#SHERIDAN_SPD,SHERID5
	.WORD	CANI_SHOULD_REPEAT
	WL	CANI_GOTO,#sheridan_norm

**********
* Side crowd

#SDCRD_SPD	equ	8

#side1_norm
	WL	SPD_FOREVER,SDCRD1A
	WL	CANI_GOTO,#side1_norm

#side1_cheer1
	WL	#SDCRD_SPD,SDCRD2A
	WL	#SDCRD_SPD,SDCRD3A
	WL	#SDCRD_SPD,SDCRD4A
	WL	#SDCRD_SPD,SDCRD3A
	WL	#SDCRD_SPD,SDCRD2A
	WL	CANI_GOTO,#side1_norm

#side2_norm
	WL	SPD_FOREVER,SDCRD1B
	WL	CANI_GOTO,#side2_norm

#side2_cheer1
	WL	#SDCRD_SPD,SDCRD2B
	WL	#SDCRD_SPD,SDCRD3B
	WL	#SDCRD_SPD,SDCRD4B
	WL	#SDCRD_SPD,SDCRD3B
	WL	#SDCRD_SPD,SDCRD2B
	WL	CANI_GOTO,#side2_norm

#side3_norm
	WL	SPD_FOREVER,SDCRD1C
	WL	CANI_GOTO,#side3_norm

#side3_cheer1
	WL	#SDCRD_SPD,SDCRD2C
	WL	#SDCRD_SPD,SDCRD3C
	WL	#SDCRD_SPD,SDCRD4C
	WL	#SDCRD_SPD,SDCRD3C
	WL	#SDCRD_SPD,SDCRD2C
	WL	CANI_GOTO,#side3_norm

**********
* Tobias

#TOBIAS_SPD	equ	7

#tobias_norm
	WL	SPD_FOREVER,TOBIAS1
	WL	CANI_GOTO,#tobias_norm

#tobias_cheer1
	WL	#TOBIAS_SPD,TOBIAS2
	WL	#TOBIAS_SPD,TOBIAS3
	WL	#TOBIAS_SPD,TOBIAS4
	WL	#TOBIAS_SPD,TOBIAS2
	WL	CANI_GOTO,#tobias_norm

#tobias_cheer2
	WL	#TOBIAS_SPD,TOBIAS2
	.WORD	CANI_REPEAT,7
	WL	#TOBIAS_SPD,TOBIAS3
	WL	#TOBIAS_SPD,TOBIAS4
	.WORD	CANI_SHOULD_REPEAT
	WL	#TOBIAS_SPD,TOBIAS2
	WL	CANI_GOTO,#tobias_norm

**********
* Tony

#TONY_SPD	equ	7

#tony_norm
	WL	SPD_FOREVER,CRAZY1
	WL	CANI_GOTO,#tony_norm

#tony_cheer1
	WL	#TONY_SPD,CRAZY2
	WL	#TONY_SPD,CRAZY3
	WL	#TONY_SPD,CRAZY4
	WL	#TONY_SPD,CRAZY5
	WL	#TONY_SPD,CRAZY4
	WL	#TONY_SPD,CRAZY5
	WL	#TONY_SPD,CRAZY4
	WL	#TONY_SPD,CRAZY3
	WL	#TONY_SPD,CRAZY2
	WL	CANI_GOTO,#tony_norm

#tony_cheer2
	WL	#TONY_SPD,CRAZY2
	WL	#TONY_SPD,CRAZY3
	.WORD	CANI_REPEAT,4
	WL	#TONY_SPD,CRAZY4
	WL	#TONY_SPD,CRAZY5
	WL	#TONY_SPD,CRAZY4
	WL	#TONY_SPD,CRAZY3
	WL	#TONY_SPD,CRAZY4
	WL	#TONY_SPD,CRAZY5
	.WORD	CANI_SHOULD_REPEAT
	WL	#TONY_SPD,CRAZY4
	WL	#TONY_SPD,CRAZY3
	WL	#TONY_SPD,CRAZY2
	WL	CANI_GOTO,#tony_norm


**********
* Tony crowd

#TONYC_SPD	equ	8

#tonycrd_norm
	WL	SPD_FOREVER,TONYCRD1
	WL	CANI_GOTO,#tonycrd_norm

#tonycrd_cheer1
	WL	#TONYC_SPD,TONYCRD2
	WL	#TONYC_SPD,TONYCRD3
	WL	#TONYC_SPD,TONYCRD4
	WL	#TONYC_SPD,TONYCRD5
	WL	CANI_GOTO,#tonycrd_norm

**********
* Vogel

#VOGEL_SPD	equ	8

#vogel_norm
	WL	SPD_FOREVER,VOGEL1
	WL	CANI_GOTO,#vogel_norm

#vogel_cheer1
	WL	#VOGEL_SPD,VOGEL2
	WL	#VOGEL_SPD,VOGEL3
	WL	#VOGEL_SPD,VOGEL4
	WL	#VOGEL_SPD,VOGEL3
	WL	#VOGEL_SPD,VOGEL2
	WL	CANI_GOTO,#vogel_norm

#vogel_cheer2
	WL	#VOGEL_SPD,VOGEL2
	.WORD	CANI_REPEAT,7
	WL	#VOGEL_SPD,VOGEL3
	WL	#VOGEL_SPD,VOGEL4
	.WORD	CANI_SHOULD_REPEAT
	WL	#VOGEL_SPD,VOGEL2
	WL	CANI_GOTO,#vogel_norm

 SUBR	DO_CROWD_CHEER
	MOVK	C_OVERIDE|C_LONG,A3
	CLR	A4

*****************************************************************************
* Causes the crowd to cheer.

;INPUT A3 = BIT 0 1=LONG OR 0=SHORT TYPE OF ANIMATION
;           BIT 1 1=OVERRIDE WHAT IS ALREADY GOING ON OR NOT
;      	   BIT 2 1=DO RANDOM NUMBER OF PEOPLE IN AUDIENCE 
;      A4 = RNDPER VALUE IF BIT 2 SET IN A3
 SUBR	crowd_cheer
		   
	CLR	A7
	BTST	B_RANDOM,A3
	JRZ	NO_RANDOMNESS
	MOVE	A4,A7
NO_RANDOMNESS
	movi	CROWDDATA,a4
	movi	NUMCROWD,a5
	movk	1,a6
#loop
	MOVE	*A4(CHEER1),A1,L
	CMPI	#side2_cheer1,A1
	JREQ	DO_NEXT_PERSON
	CMPI	#side3_cheer1,A1
	JREQ	DO_NEXT_PERSON
	CMPI	#dave_cheer1,A1
	JREQ	DO_NEXT_PERSON
	MOVE	A7,A0
	JRZ	DO_THEM_ALL
	CALLA	RNDPER
	JRLS	DO_NEXT_PERSON
DO_THEM_ALL
	BTST	B_OVERRIDE,A3
	JRNZ	JUST_DO_IT_ANYWAY
	MOVE	*A4(CHEER1),A8,L
	MOVE	*A4(SCPTR),A9,L
	CMP	A8,A9
	JRGE	DO_NEXT_PERSON
JUST_DO_IT_ANYWAY
	move	*a4(CHEER1),*a4(SCPTR),L
	BTST	B_L_OR_S,A3
	JRZ	OKAY_DO_SHORT
	move	*a4(CHEER2),*a4(SCPTR),L
OKAY_DO_SHORT
	move	a6,*a4(TIME),W

;MAKE SURE WE DO ALL THE SIDE CROWD AT ONCE
	move	*a4(CHEER1),A1,L
	CMPI	#side1_cheer1,A1
	JRNE	DO_NEXT_PERSON
	addi	BSIZE,a4
	move	*a4(CHEER1),*a4(SCPTR),L
	move	a6,*a4(TIME),W
	addi	BSIZE,a4
	move	*a4(CHEER1),*a4(SCPTR),L
	move	a6,*a4(TIME),W
	addi	BSIZE*2,a4
	move	*a4(CHEER1),*a4(SCPTR),L
	move	a6,*a4(TIME),W

	;a5 is the loop counter...gotta dec it any time we add to a4.
	subk	4,a5
DO_NEXT_PERSON
	addi	BSIZE,a4
	dsj	a5,#loop
	
	CALLA	START_FLASHES

	rets


******************************************************************************

	.end
