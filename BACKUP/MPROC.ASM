**************************************************************
* GSP MULTI-PROCESSING SYSTEM
*
* Software:	Eugene P Jarvis, Shawn Liptak
* Initiated:	1988?
*
* Modified:	Shawn Liptak, 7/?/91	-New KILL stuff (Total carnage)
* 		Shawn Liptak, 8/12/91	-KOP code
* 		Shawn Liptak, 10/27/91	-Shawn.hdr
* 		Shawn Liptak, 2/18/92	-Basketball (cleanup)
* 		Shawn Liptak, 7/1/92	-Slowmotion
*		Jason Skiles, 2/23/94	-Super-procs
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 2/23/94 11:45
**************************************************************
	.file	"mproc.asm"
	.title	"GSP multi-processing system"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"gsp.equ"
	.include	"sys.equ"
	.include	"mproc.equ"
	.include	"display.equ"
	.include	"macros.h"


******************************************************************************
* EXTERNAL REFERENCES

	.ref	obj_yzsort
	.ref	dirqtimer
	.ref	L_TIMER

******************************************************************************


	.bss	PRCSTR	,NPROC*PRCSIZ	;Process data blocks

; Note: A super-proc is spotted by comparing its address to SPRCSTR.
;       Make SURE that SPRCSTR always rests higher in RAM than PRCSTR.
;	It would be A Bad Thing were this test to become unreliable.

	.bss	SPRCSTR	,SNPROC*SPRCSIZ	;Super-process data blocks

;Who coded this pus-oozing clusterfuck piece of shit?  G-R-E-A-T fucking
; idea, you chowderhead.  With a simple pair of .bss directives, you've
; wasted an enormous amount of precious scratch ram.  It's a wonder 
; ANYTHING works in this stupid game.  HEL-LO! *bonk* *bonk* *bonk*
; Allocate it in unused image RAM instead.  It saves space, and we've
; plenty of room there.  By the time it's all used up, we'll be shipping,
; so it'll be ROM instead of RAM and you won't be able to overwrite the
; image data.
; Some programmers around here are just SO fucking clueless...
; USE YOUR HEADS, YOU FUCKWITS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	.sect	"FIXED"
ACTIVE	.long	0
FREE	.long	0
SFREE	.long	0


	.text


********************************
* Process list initialize
* >A13=*Process active list
* Trashes scratch

 SUBR	process_init

	movi	ACTIVE,a13	;Init A13
	clr	a0
	move	a0,*a13,L	;Empty list

	movi	PRCSTR,a1
	move	a1,@FREE,L	;Full free list

	movi	NPROC,b0	;# of processes
#lp	move	a1,a14
	addi	PRCSIZ,a1
	move	a1,*a14,L	;Set link
	dsj	b0,#lp

	move	a0,*a14,L	;Null last link

	;initialize the super-proc list
	movi	SPRCSTR,a1
	move	a1,@SFREE,L

	movi	SNPROC,b0	;# of processes
#slp	move	a1,a14
	addi	SPRCSIZ,a1
	move	a1,*a14,L	;Set link
	dsj	b0,#slp

	move	a0,*a14,L	;Null last link

	rets


#*******************************
* Process dispatch

 SUBR	process_dispatch


 .if	0

	movi	31*32,a0		;Proc usage
	move	a0,@ERASELOC

#dmawt	move	b13,b13
	jrge	#dmawt
	movk	6,a0			;DMA usage
	move	a0,@ERASELOC
#noline
 .endif

 .if DEBUG
	.ref	slowmotion
	move	@slowmotion,a0
#smlp	move	@dirqtimer,a1
	cmp	a1,a0
	jrge	#smlp
 .endif

	movi	ACTIVE,a13		;*Proc list
	clr	a0
	move	a0,@dirqtimer		;Tell DIRQ to flip and draw

#lp	calla	obj_yzsort		;Sort display list
	move	@dirqtimer,a0
	jrz	#lp			;Wait?

	calla	L_TIMER			;Linky timer (FIX so BOG time is OK!)

	jruc	prcd1

********************************
* Process sleep
* Stack=*Wakeup
* A0=Sleep time

PRCSLP
	PULL	a7			;Get *Wakeup

PRCLSP	move	a13,a1
	addi	PDATA,a1
	mmtm	a1,a7,a8,a9,a10,a11,a12 ;*Wakeup, regs, *stack
	move	a0,-*a1			;sleep


;D3PTS	.equ	>120		;UHL *Points array (Cnt, XYZ,XYZ..)
;
;	PUSH	a0,a1			;DEBUG
;	movi	d3vis_p,a1
;	move	*a1,a0,L
;	jrz	#dx
;#debug	move	a1,a0
;	move	*a0,a1,L
;	jrnz	#debug
;	move	*a0(D3PTS),a1,L
;	jrz	$			;ERROR!!!
;#dx	PULL	a0,a1



	.if	DEBUG
	move	a13,a0
	cmpi	SPRCSTR,a13		;is it a superproc?
	jrge	#super_stkchk

	addi	PSDATA,a0
	cmp	a0,a12
	jrlt	$			;stick on stack overflow
	addi	PRCSIZ-PSDATA,a0
	cmp	a0,a12
	jrgt	$			;stick on stack underflow
	jruc	prcd1
#super_stkchk
	addi	SPSDATA,a0
	cmp	a0,a12
	jrlt	$			;stick on stack overflow
	addi	SPRCSIZ-SPSDATA,a0
	cmp	a0,a12
	jrgt	$			;stick on stack underflow
	jruc	prcd1
	.endif

prcd1
	move	*a13,a13,L
	jrz	prcdx			;End?
	move	*a13(PTIME),a0		;Get count
	subk	1,a0
	move	a0,*a13(PTIME)		;Put it back
	jrgt	prcd1			;Not ready?


	move	a13,a1			;>Dispatch
	addi	>40,a1
	mmfm	a1,a7,a8,a9,a10,a11,a12	;*Wake, regs, *stack
	jump	a7			;Do process


prcdx	rets


********************************
* Process kills itself

SUCIDE
	movi	ACTIVE,a1
suclp	move	a1,a2		;save previous
	move	*a1,a1,L
	jrz	sucerr

	cmp	a1,a13
	jrne	suclp		;!Us

	move	*a1,*a2,L	;Unlink

	cmpi	SPRCSTR,a1
	jrge	#suclink_sproc

	move	@FREE,*a1+,L	;Link into free list at start
	subk	32,a1
	move	a1,@FREE,L

	move	a2,a13		;Set current process to previous
	jruc	prcd1		;Continue with dispatch

#suclink_sproc
	move	@SFREE,*a1+,L	;Link into super-proc free list at start
	subk	32,a1
	move	a1,@SFREE,L
	move	a2,a13		;Continue with dispatch
	jruc	prcd1

sucerr
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	5,0
	.endif
	movi	ACTIVE,a13	;*Proc list
	jruc	prcd1


#*******************************
* Kill process (won't kill self)
* A0=*Process to kill
* Trashes scratch

KILL
	cmp	a0,a13
	jreq	#x		;Killing self?

	movi	ACTIVE,a1

#lp	move	a1,a14		;Save previous
	move	*a1,a1,L
	jrz	killerr		;Can't find?
	cmp	a1,a0
	jrne	#lp		;Not the one?

	move	*a0,*a14,L	;Unlink from active

	cmpi	SPRCSTR,a0
	jrge	#kill_super
	move	@FREE,*a0+,L	;Link into free list at start
	subk	32,a0
	move	a0,@FREE,L
	jruc	#x

#kill_super
	move	@SFREE,*a0+,L	;Link into free list at start
	subk	32,a0
	move	a0,@SFREE,L
	jruc	#x

#x	rets

killerr
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	6,0
	.endif
	jruc	#x


********************************
* Create a process
* A1=PID, A7=PC, A8,A9,A10,A11 Passed parameters
* A13=*Current process
* >A0=*Created process (Flags invalid!)
* Trashes A14,B0-B1

GETPRC
	move	a12,b0

	move	@FREE,a0,L
	jrz	nonelft		;No more?
	move	*a0,a14,L
	move	a14,@FREE,L	;Unlink from free list
	move	*a13,*a0,L	;Link into active list after current process
	move	a0,*a13,L
	jruc	xferprc0

nonelft
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	4,2
	.endif
	jruc	getpx

********************************
*
* Identical to GETPRC, except that the created process is placed in the
* process list immediately BEFORE the parent process, not after.
*
* A1=PID, A7=PC, A8,A9,A10,A11 Passed parameters
* A13=*Current process
* >A0=*Created process (Flags invalid!)
* Trashes A14,B0-B1

GETPRC_INSERT
	move	a12,b0

	move	@FREE,a0,L
	jrz	nonelft		;No more?
	move	*a0,a14,L
	move	a14,@FREE,L	;Unlink from free list


	;find the process that's immediately before the parent.
	PUSH	a1,a2
	movi	ACTIVE,a1
	move	*a1,a2,L
#search
	cmp	a13,a2
	jreq	#found
	move	a2,a1
	move	*a1,a2,L
	jrnz	#search

	;We've been called by a nonexistent process.  How odd.
	.if DEBUG
	LOCKUP
	.endif
	PULL	a1,a2
	jruc	getpx

#found
	;a2 is parent proc, a1 is before that.  slip in between.
	move	a0,*a1,L
	move	a2,*a0,L
	PULL	a1,a2
	jruc	xferprc0
	
	
	
;	move	*a13,*a0,L	;Link into active list after current process
;	move	a0,*a13,L
;	jruc	xferprc0

********************************
* Create a super-process
* A1=PID, A7=PC, A8,A9,A10,A11 Passed parameters
* A13=*Current process
* >A0=*Created process (Flags invalid!)
* Trashes A14,B0-B1

 SUBR	GETSPRC
	move	a12,b0

	move	@SFREE,a0,L
	jrz	nonelft		;No more?
	move	*a0,a14,L
	move	a14,@SFREE,L	;Unlink from free list
	move	*a13,*a0,L	;Link into active list after current process
	move	a0,*a13,L
	jruc	xferprc0


********************************
* Transfer control of an existing process
* A0=*Process to be xfer'd
* A1=New PID
* A7=*Wake address
* A8-A11=Passed to the xfer'd proc
* Trashes A14,B0-B1

XFERPROC
	move	a12,b0
xferprc0
	cmpi	ROM,a7
	jrlo	procwakeerr		;Error?

	move	a0,a14
	addi	PDATA,a14
	move	a0,a12			;Reset process stack pointer
	addi	SPRCSIZ,a12
	cmpi	SPRCSTR,a0
	jrge	#superproc

	addi	PRCSIZ-SPRCSIZ,a12
#superproc
	mmtm	a14,a7,a8,a9,a10,a11,a12 ;Stuff wake, regs, p stack ptr
	movk	1,a12
	move	a12,-*a14		;Wakeup next time
	move	a1,-*a14		;ID

getpx	move	b0,a12
	rets				;Flags are trashed!!!

procwakeerr
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	7,0
	.endif
	jruc	getpx


********************************
* Kill a class of processes except for self
* A0=PID
* A1=Mask (bits to keep)
* Trashes scratch

KILALL
	not	a1
	jruc	KILALLN


********************************
* Kill one class of processes
* A0=PID
* Trashes scratch

KIL1C
	clr	a1

#*******************************
* Kill a class of processes
* A0=PID
* A1=!Mask (bits to remove)
* Trashes scratch

KILALLN
	move	a2,b0
	move	a3,b1

	zext	a1		;Won't kill PIDS >8000+
	andn	a1,a0		;Form match
	movi	ACTIVE,a2

#lp	move	a2,a3		;Save previous
	move	*a2,a2,L
	jrz	#x		;Done?
	move	*a2(PROCID),a14
	JRN	#lp		;ALLOW INDESTRUCTABLES (ANYTHING 8000h+)

;	jrnn	#ok
;	LOCKUP
;#ok
	andn	a1,a14		;Apply mask
	cmp	a0,a14
	jrne	#lp		;No match?

	cmp	a2,a13
	jreq	#lp		;Current proecess?

	move	*a2,*a3,L	;Unlink
	cmpi	SPRCSTR,a2
	jrge	#spr
	move	@FREE,a14,L	;Link into free list at start
	move	a14,*a2,L
	move	a2,@FREE,L
	move	a3,a2
	jruc	#lp

#spr
	move	@SFREE,a14,L	;Link into super-proc free list at start
	move	a14,*a2,L
	move	a2,@SFREE,L
	move	a3,a2
	jruc	#lp

#x	move	b0,a2
	move	b1,a3
	rets


********************************
* Knock out one class of processes
* A0=PID, A2=Time to add
* Trashes scratch

KOP_1C
	clr	a1

#*******************************
* Knock out a class of processes
* A0=PID, A1=!Mask (Bits to remove), A2=Time to add
* Trashes scratch

KOP_ALL
	move	a3,b0
	andn	a1,a0		;Form match
	movi	ACTIVE,a3,L

#lp	move	*a3,a3,L	;Get next
	jrz	#x		;End?
	move	*a3(PROCID),a14
	andn	a1,a14		;Mask
	cmp	a0,a14
	jrnz	#lp		;No match?

	move	*a3(PTIME),a14	;Add sleep
	add	a2,a14
	move	a14,*a3(PTIME)
	jruc	#lp

#x	move	b0,a3
	rets


#*******************************
* Check to see if process exists
* A0=*Process
* Rets: Z=Not found, NZ=Found
* Trashes scratch

process_exist
	movi	ACTIVE,a1

#lp	move	*a1,a1,L
	jrz	#x		;End?
	cmp	a0,a1
	jrne	#lp		;!Match?
	move	a0,a0		;Clr Z

#x	rets


#*******************************
* Find if at least one process, other than calling process, exists
* A0=PROCID
* A1=Mask
* Rets: A0=*Process or 0 (Z)

EXISTP
	PUSH	a1,a2,a4

	sext	a0
	and	a1,a0		;form match
	movi	ACTIVE,a2

#lp	move	*a2,a2,L
	jrz	#x		;End?
	move	*a2(PROCID),a4
	and	a1,a4
	cmp	a0,a4
	jrne	#lp		;!Match?

	cmp	a2,a13
	jreq	#lp		;Self?

#x	move	a2,a0

	PULL	a1,a2,a4
	rets





	.end

