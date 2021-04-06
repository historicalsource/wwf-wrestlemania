**************************************************************
*
* Software:
* Initiated:
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

*CLICK AN AUDIT COUNTER
AUDIT	.macro	P1
	MOVI	:P1:,A0	
	CALLA	AUD1
	.endm

*AUDIT A WORD LONG RAM LOCATION
*P1 = AUDIT
*P2 = RAM LOCATION
AUDITCNT .macro	P1,P2
	MOVE	@:P2:,A1
	MOVI	:P1:,A0
	CALLA	AUD
	.endm

*Get a game adjustment value in A0
ADJUST	.macro	P1
	MOVI	:P1:,A0
	CALLA	GET_ADJ
	.endm

*FCALL - Function call without using the system stack
FCALL	.macro	n,b
	movi	:n:,:b:,L
	exgpc	:b:
	.endm

*FRET - Function return without using the system stack
FRET	.macro	b
	exgpc	:b:
	.endm


******************************************************************************

REFLONG	.macro	label
	.globl	label
	.long	label
	.endm


FACE24		.macro	NAME,MOVE,REG
	.if $isreg(REG)
	move	*:REG:(FACING_DIR),a14
	.else
	move	*a13(FACING_DIR),a14
	.endif
	movi	:NAME:_2_:MOVE:,a0
	btst	MOVE_UP_BIT,a14
	jrnz	DONE?
	movi	:NAME:_4_:MOVE:,a0
DONE?
		.endm


FACE24TBL	.macro	TBL,REG

	.if ($symcmp(TBL,"a0") = 0) | ($symcmp(TBL,"a14") = 0)
	.emsg	"ERROR! - Can't use a0 or a14 with FACE24TBL"
	.mexit
	.endif

	.if $isreg(REG)
	move	*:REG:(WRESTLERNUM),a0
	.else
	move	*a13(WRESTLERNUM),a0
	.endif
	X64	a0

	.if $isreg(REG)
	move	*:REG:(FACING_DIR),a14
	.else
	move	*a13(FACING_DIR),a14
	.endif

	btst	MOVE_UP_BIT,a14
	jrnz	DONE?

	addi	32,a0

DONE?
	.if $isreg(TBL)
	add	:TBL:,a0
	.else
	addi	:TBL:,a0
	.endif

	move	*a0,a0,L

	.endm


FACETBL	.macro	TBL,REG

	.if $symcmp(TBL,"a0") = 0)
	.emsg	"ERROR! - Can't use a0 with FACETBL"
	.mexit
	.endif

	.if $isreg(REG)
	move	*:REG:(WRESTLERNUM),a0
	.else
	move	*a13(WRESTLERNUM),a0
	.endif
	X32	a0

	.if $isreg(TBL)
	add	:TBL:,a0
	.else
	addi	:TBL:,a0
	.endif

	move	*a0,a0,L

	.endm

******************************************************************************
;Under no circumstances should MODE_DEAD ever be changed to anything else.
; (well, except for the come-back-to-life thing at the end, and that's
; a very special case that'll be handled separately.)

SETMODE	.macro	MODE

	move	a0,-*sp,1
	move	*a13(PLYRMODE),a0
	cmpi	MODE_DEAD,a0
	jreq	done?
	movi	MODE_:MODE:,a0
	move	a0,*a13(PLYRMODE)
done?	move	*sp+,a0,1
	.endm

******************************************************************************

JAM_STR	.macro	FONT,SPACING,CSPACE,X,Y,PALETTE,PR_METHOD
	.long	:FONT:
	.word   :SPACING:
	.word	:CSPACE:
	.word	:X:
	.word	:Y:
	.long   :PALETTE:
	.long   :PR_METHOD:
	.endm

******************************************************************************

OPPDIST	.macro	DX,DZ
	move	*a13(CLOSEST_XDIST),a14
	cmpi	DX,a14
	jrgt	FOO?
	move	*a13(CLOSEST_ZDIST),a14
	cmpi	DZ,a14
FOO?
	.endm

******************************************************************************

TBL_OBJ	.macro	OBJ
	movi	OBJ,a0
	calla	BEGINOBJ_TBL
	.endm

******************************************************************************

X2		.macro	a
	sll	1,:a:
	.endm

******************************************************************************

X4		.macro	a
	sll	2,:a:
	.endm

******************************************************************************

X8		.macro	a
	sll	3,:a:
	.endm

******************************************************************************

X16		.macro	a
	sll	4,:a:
	.endm

******************************************************************************

X32		.macro	a
	sll	5,:a:
	.endm

******************************************************************************

X64		.macro	a
	sll	6,:a:
	.endm

******************************************************************************

X128		.macro	a
	sll	7,:a:
	.endm

******************************************************************************

X256		.macro	a
	sll	8,:a:
	.endm

******************************************************************************

TINTON	.macro

	.global	tint_on
	calla	tint_on
	.endm


TINTOFF	.macro

	.global	tint_off
	calla	tint_off
	.endm

********************************
* Macro defines, include after mproc.equ
* 11 June 91 SPL
*.Last mod - 1/31/93 1:00


BSSX	.macro	n,s
	.def	:n:
	.bss	:n:,:s:
	.endm

SUBR	.macro	p1
	.def	:p1:
	.even
:p1:
	.endm

SUBRP	.macro	p1
	.even
:p1:
	.endm

STRUCT	.macro	o
	.asg	:o:,SOFF
	.endm
STRUCTPD .macro
	.asg	PDATA,SOFF
	.endm
STRUC	.macro	n,s
:n:	.set	SOFF
	.eval	SOFF+:s:,SOFF
	.endm
WORD	.macro	n
:n:	.set	SOFF
	.eval	SOFF+16,SOFF
	.endm
LONG	.macro	n
:n:	.set	SOFF
	.eval	SOFF+32,SOFF
	.endm
APTR	.macro	n
:n:	.set	SOFF
	.eval	SOFF+32,SOFF
	.endm
LABEL	.macro	n
:n:	.set	SOFF
	.endm

FLAG	.macro	n
:n:_B	.equ	SOFF
:n:_M	.equ	1<<SOFF
	.eval	SOFF+1,SOFF
	.endm

W0	.macro
	.word	0
	.endm
WWL	.macro	w,w2,l
	.word	:w:,:w2:
	.long	:l:
	.endm
WL	.macro	w,l
	.word	:w:
	.long	:l:
	.endm
WLW	.macro	w,l,w2
	.word	:w:
	.long	:l:
	.word	:w2:
	.endm

WLWW	.macro	w,l,w2,w3
	.word	:w:
	.long	:l:
	.word	:w2:,:w3:
	.endm

WWLWWWWW	.macro	w1,w2,l,w3,w4,w5,w6,w7
	.word	:w1:,:w2:
	.long	:l:
	.word	:w3:,:w4:,:w5:,:w6:,:w7:
	.endm

WLWWWW	.macro	w,l,w2,w3,w4,w5
	.word	:w:
	.long	:l:
	.word	:w2:,:w3:,:w4:,:w5:
	.endm
WLWWW	.macro	w,l,w2,w3,w4
	.word	:w:
	.long	:l:
	.word	:w2:,:w3:,:w4:
	.endm
WLL	.macro	w,l,l2
	.word	:w:
	.long	:l:,:l2:
	.endm
WLLL	.macro	w,l,l2,l3
	.word	:w:
	.long	:l:,:l2:,:l3:
	.endm
WLLLL	.macro	w,l,l2,l3,l4
	.word	:w:
	.long	:l:,:l2:,:l3:,:l4:
	.endm
WLLW	.macro	w,l,l2,w2
	.word	:w:
	.long	:l:,:l2:
	.word	:w2:
	.endm
LW	.macro	l,w
	.long	:l:
	.word	:w:
	.endm
LWW	.macro	l,w,w2
	.long	:l:
	.word	:w:,:w2:
	.endm
LWWW	.macro	l,w,w2,w3
	.long	:l:
	.word	:w:,:w2:,:w3:
	.endm
LWWWW	.macro	l,w,w2,w3,w4
	.long	:l:
	.word	:w:,:w2:,:w3:,:w4:
	.endm
WWWWL	.macro	w,w2,w3,w4,l
	.word	:w:,:w2:,:w3:,:w4:
	.long	:l:
	.endm
LWWWWW	.macro	l,w,w2,w3,w4,w5
	.long	:l:
	.word	:w:,:w2:,:w3:,:w4:,:w5:
	.endm
LWWWWWW	.macro	l,w,w2,w3,w4,w5,w6
	.long	:l:
	.word	:w:,:w2:,:w3:,:w4:,:w5:,:w6:
	.endm
LWL	.macro	l,w,l2
	.long	:l:
	.word	:w:
	.long	:l2:
	.endm
LWLW	.macro	l,w,l2,w2
	.long	:l:
	.word	:w:
	.long	:l2:
	.word	:w2:
	.endm
LWL0	.macro	l,w
	.long	:l:
	.word	:w:
	.long	0
	.endm

WLWLWL	.macro	w0,l0,w1,l1,w2,l2
	.word	:w0:
	.long	:l0:
	.word	:w1:
	.long	:l1:
	.word	:w2:
	.long	:l2:
	.endm

WLWL	.macro	w0,l0,w1,l1
	.word	:w0:
	.long	:l0:
	.word	:w1:
	.long	:l1:
	.endm

WWLW	.macro	w0,w1,l0,w2
	.word	:w0:,:w1:
	.long	:l0:
	.word	:w2:
	.endm

WWWL	.macro	w0,w1,w2,l1
	.word	:w0:,:w1:,:w2:
	.long	:l1:
	.endm

WWLLW	.macro	w1,w2,l1,l2,w3
	.word	:w1:,:w2:
	.long	:l1:,:l2:
	.word	:w3:
	.endm

COLORW	.macro	r1,g1,b1,r2,g2,b2,r3,g3,b3,r4,g4,b4
	.word	:r1:*32*32+:g1:*32+:b1:
	.if	$symlen(r2)
	.word	:r2:*32*32+:g2:*32+:b2:
	.endif
	.if	$symlen(r3)
	.word	:r3:*32*32+:g3:*32+:b3:
	.endif
	.if	$symlen(r4)
	.word	:r4:*32*32+:g4:*32+:b4:
	.endif
	.endm

* Push 1-10 registers onto the stack, overrides mproc.equ version
PUSH	.macro	r1,r2,r3,r4,r5,r6,r7,r8,r9,r10
	.if	$isreg(r10)
	mmtm	sp,:r1:,:r2:,:r3:,:r4:,:r5:,:r6:,:r7:,:r8:,:r9:,:r10:
	.elseif	$isreg(r9)
	mmtm	sp,:r1:,:r2:,:r3:,:r4:,:r5:,:r6:,:r7:,:r8:,:r9:
	.elseif	$isreg(r8)
	mmtm	sp,:r1:,:r2:,:r3:,:r4:,:r5:,:r6:,:r7:,:r8:
	.elseif	$isreg(r7)
	mmtm	sp,:r1:,:r2:,:r3:,:r4:,:r5:,:r6:,:r7:
	.elseif	$isreg(r6)
	mmtm	sp,:r1:,:r2:,:r3:,:r4:,:r5:,:r6:
	.elseif	$isreg(r5)
	mmtm	sp,:r1:,:r2:,:r3:,:r4:,:r5:
	.elseif	$isreg(r4)
	mmtm	sp,:r1:,:r2:,:r3:,:r4:
	.elseif	$isreg(r3)
	mmtm	sp,:r1:,:r2:,:r3:
	.elseif	$isreg(r2)
	move	:r1:,-*sp,1
	move	:r2:,-*sp,1
	.else
	move	:r1:,-*sp,1
	.endif
	.endm

* Pull registers off of the stack, ^
PULL	.macro	r1,r2,r3,r4,r5,r6,r7,r8,r9,r10
	.if	$isreg(r10)
	mmfm	sp,:r1:,:r2:,:r3:,:r4:,:r5:,:r6:,:r7:,:r8:,:r9:,:r10:
	.elseif	$isreg(r9)
	mmfm	sp,:r1:,:r2:,:r3:,:r4:,:r5:,:r6:,:r7:,:r8:,:r9:
	.elseif	$isreg(r8)
	mmfm	sp,:r1:,:r2:,:r3:,:r4:,:r5:,:r6:,:r7:,:r8:
	.elseif	$isreg(r7)
	mmfm	sp,:r1:,:r2:,:r3:,:r4:,:r5:,:r6:,:r7:
	.elseif	$isreg(r6)
	mmfm	sp,:r1:,:r2:,:r3:,:r4:,:r5:,:r6:
	.elseif	$isreg(r5)
	mmfm	sp,:r1:,:r2:,:r3:,:r4:,:r5:
	.elseif	$isreg(r4)
	mmfm	sp,:r1:,:r2:,:r3:,:r4:
	.elseif	$isreg(r3)
	mmfm	sp,:r1:,:r2:,:r3:
	.elseif	$isreg(r2)
	move	*sp+,:r2:,1
	move	*sp+,:r1:,1
	.else
	move	*sp+,:r1:,1
	.endif
	.endm

* Push low word of register on to stack, ^
PUSHW	.macro	r1,r2,r3
	.if	:r3:
	ERROR:PUSHW
	.else
	.if	:r2:
	move	:r1:,-*sp,0
	move	:r2:,-*sp,0
	.else
	move	:r1:,-*sp,0
	.endif
	.endif
	.endm

* Pull low word of register off of stack, ^
PULLW	.macro	r1,r2,r3
	.if	:r3:
	ERROR:PULLW
	.else
	.if	:r2:
	move	*sp+,:r2:,0
	move	*sp+,:r1:,0
	.else
	move	*sp+,:r1:,0
	.endif
	.endif
	.endm

* Push 1-5 registers onto the process stack, overrides mproc.equ version
PUSHP	.macro	r1,r2,r3,r4,r5
	.if	$isreg(r5)
	mmtm	a12,:r1:,:r2:,:r3:,:r4:,:r5:
	.elseif	$isreg(r4)
	mmtm	a12,:r1:,:r2:,:r3:,:r4:
	.elseif	$isreg(r3)
	mmtm	a12,:r1:,:r2:,:r3:
	.elseif	$isreg(r2)
	move	:r1:,-*a12,1
	move	:r2:,-*a12,1
	.else
	move	:r1:,-*a12,1
	.endif
	.endm
* Pull 1-5 registers off the process stack, overrides mproc.equ version
PULLP	.macro	r1,r2,r3,r4,r5
	.if	$isreg(r5)
	mmfm	a12,:r1:,:r2:,:r3:,:r4:,:r5:
	.elseif	$isreg(r4)
	mmfm	a12,:r1:,:r2:,:r3:,:r4:
	.elseif	$isreg(r3)
	mmfm	a12,:r1:,:r2:,:r3:
	.elseif	$isreg(r2)
	move	*a12+,:r2:,1
	move	*a12+,:r1:,1
	.else
	move	*a12+,:r1:,1
	.endif
	.endm

* And 1-32 to register. Trashes A14
ANDK	.macro	r1,r2
	movk	:r1:,a14
	and	a14,:r2:
	.endm

* Or 1-32 to register. Trashes A14
ORK	.macro	r1,r2
	movk	:r1:,a14
	or	a14,:r2:
	.endm

* Xor 1-32 to register. Trashes A14
XORK	.macro	r1,r2
	movk	:r1:,a14
	xor	a14,:r2:
	.endm

XYTXT	.macro	f,x,y,c,s
	.word	:f:,:x:,:y:,:c:
	.byte	":s:",0
	.endm
XYNUM	.macro	f,x,y,c,p
	.word	:f:,:x:,:y:,:c:
	.long	:p:
	.endm
XYOBJ	.macro	f,x,y,z,i
	.word	:f:,:x:,:y:,:z:
	.long	:i:
	.endm

	.asg	.if	0,NOTINUSE

* Prt_xy

PRTF15	.equ	1			;Font15
PRTF8		.equ	2			;Font8 MultiColor
PRTDEC	.equ	4			;Decimal
PRTBCD	.equ	8			;BCD (Long)
PRTL		.equ	16			;Long data
PRTOBJ	.equ	32			;Object format
PRTE		.equ	8000h		;Stop on this header

PRTF15B	.equ	0
PRTF8B	.equ	1
PRTDECB	.equ	2
PRTBCDB	.equ	3
PRTLB	.equ	4
PRTOBJB	.equ	5


********************************
* Non dupe macros from macros.hdr

*Defs for symbols referenced from macros
	.globl	ERRORLOG

* Swap contents of two registers that reside in same file
SWAP	.macro R1,R2
	xor    :R1.S:,:R2.S:
	xor    :R2.S:,:R1.S:
	xor    :R1.S:,:R2.S:
	.endm

* Test a register for zero
TEST	.macro R1
	MOVE	:R1.S:,:R1.S:
	.endm

*EQUATES FOR XY COMPARES(MOTOLORA STYLE)
JRXEQ	.macro	P1
	JRXZ	P1.S
	.endm
JRXNE	.macro	P1
	JRXNZ	P1.S
	.endm
JRXGE	.macro	P1
	JRXNN	P1.S
	.endm
JRXLT	.macro	P1
	JRXN	P1.S
	.endm
JRYEQ	.macro	P1
	JRYZ	P1.S
	.endm
JRYNE	.macro	P1
	JRYNZ	P1.S
	.endm
JRYGE	.macro	P1
	JRYNN	P1.S
	.endm
JRYLT	.macro	P1
	JRYN	P1.S
	.endm

*CALLERR - CALL THE ERROR LOG MACRO
*REGS = # OF REGISTERS PUSHED ON THE STACK BY THIS SUBROUTINE
CALLERR	.macro	NUM,REGS
	mmtm	sp,a1,a2
	move	*sp((:REGS:+2)*20H),a1,L
	movi	:NUM:,a2
	calla	ERRORLOG	
	mmfm	sp,a1,a2
	.endm

WAITSWITCH_DWN	.macro	SWITCHES,MASK,FAILADDR

lp?
	SLEEPK	1
	dec	a11
	jrz	:FAILADDR:
	move	*a8(SPECIAL_MOVE_ADDR),a0,L
	jrnz	:FAILADDR:
	move	*a8(BUT_VAL_DOWN),a0
	sll	4,a0
	move	*a8(STICK_REL_NEW),a1
	or	a1,a0
	andni	:MASK:,a0
	jrz	lp?
	;subk doesn't work -- some out-of-range values in doink.
	cmpi	:SWITCHES:,a0
	jrne	:FAILADDR:

	.endm

BADCHK	.macro	reg,lo,hi,val
	cmpi	:lo:,reg
	jrlt	bad?
	cmpi	:hi:,reg
	jrgt	bad?
	jruc	ok?
bad?
	movi	:val:,:reg:
ok?
	.endm

*******************************************************************************

	.globl	wres_get_stick_rel_new,wres_get_but_val_down

WAITSWITCH_DWN2	.macro	SWITCHES,MASK,FAILADDR

lp?
	SLEEPK	1
	dec	a11
	jrz	:FAILADDR:
	move	*a8(SPECIAL_MOVE_ADDR),a0,L
	jrnz	:FAILADDR:
;	move	*a8(BUT_VAL_DOWN),a0
	move	a8,a0
	calla	wres_get_but_val_down
	sll	4,a0
	move	a0,a1
;	move	*a8(STICK_REL_NEW),a1
	move	a8,a0
	calla	wres_get_stick_rel_new
	or	a1,a0
	andni	:MASK:,a0
	jrz	lp?
	;subk doesn't work -- some out-of-range values in doink.
	cmpi	:SWITCHES:,a0
	jrne	:FAILADDR:

	.endm

******************************************************************************

SPCDMG	.macro	DAMAGE,TIME
	move	@PCNT,a14,L
	addi	:TIME:,a14
	move	a14,*a13(SPECIAL_DAMAGE_TIME),L
	movi	:DAMAGE:,a14
	move	a14,*a13(NEXT_DAMAGE)
	.endm

******************************************************************************
