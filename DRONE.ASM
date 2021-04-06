 ;Yoko tb on out of ring opp
 ;UT pin bug
 ;Atk sometimes instead of blk
;Chk dnk buzz blk
 ;No leap head grab
;Don't have drones do power moves unless human has.
;Yoko should take advantage of salt throw
 ;Drones wait in your face for too long.
 ;DL blk for hiptoss
 ;Harder
 ;Atk down opp
 ;Anti run code, esp out of ctrl
 ;Fling and chase
 ;Short repeat atks
 ;Do more head holds from in close - thru block
 ;Seek on a blocker, do headhold
 ;Make multi drones easier...
 ;Too many runs
 ;Break out of runs more...
;Climb TB after a toss out
 ;Sometimes, drone won't move from top of TB
 ;Don't let go charge moves if opp is blocking
 ;In multi-wrestler matches, delay longer on power moves from headhold or revs
;Yoko can run right into drone and knock him down.
;Get smart on big boots, missed/blocked buzzers, etc.
 ;Ignore pushes from opponent, try an attack
;Specific combo paths
 ;Pin fast
 ;Multi wres spacing
 ;Get in ring
 ;Check blocking
;Fix seek_dirdist out of ring
 ;Slide htoss on flying opp
**************************************************************
*
* Software:		Shawn Liptak
* Initiated:		11/21/94
*
* Modified:		Shawn Liptak, 11/21/94	-Started wrestling
*
* COPYRIGHT (C) 1994 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 6/29/95 15:42
**************************************************************
	.file	"drone.asm"
	.title	"wrestling drone code"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"macros.h"
	.include	"mproc.equ"
	.include	"display.equ"
	.include	"gsp.equ"
	.include	"sys.equ"
	.include	"audit.equ"
	.include	"game.equ"
	.include	"anim.equ"
	.include	"plyr.equ"
	.include	"ring.equ"
	.include	"damage.equ"


;sounds external


;symbols externally defined

	.ref	process_ptrs,PSTATUS
	.ref	PCNT,round_tickcount

	.ref	CHECK_COMBO_GO

	.ref	GET_ADJ
	.ref	p1winstreakd,p1rounds,current_round
	.ref	LADDER,CURRENT_LADDER

	.ref	change_anim1a
	.ref	hrt_4_taunt_anim,rzr_4_taunt_anim,und_4_taunt_anim
	.ref	yok_4_taunt_anim,shn_4_taunt_anim,bam_4_taunt_anim
	.ref	dnk_4_taunt_anim,lex_4_taunt_anim


;symbols defined in this file


;uninitialized ram definitions

	BSSX	droneoff	,16		;!0=Drone code off
	.bss	atkcnt_t,AT_NUM*NUM_WRES*16	;# times hit by each atk


;equates for this file

BLKTEST	.equ	0

U_M	.equ	MOVE_UP<<5
D_M	.equ	MOVE_DOWN<<5
L_M	.equ	MOVE_LEFT<<5
R_M	.equ	MOVE_RIGHT<<5

P_M	.equ	PLAYER_PUNCH_VAL
B_M	.equ	PLAYER_BLOCK_VAL
SP_M	.equ	PLAYER_SPUNCH_VAL
K_M	.equ	PLAYER_KICK_VAL
SK_M	.equ	PLAYER_SKICK_VAL

	.if	MODE_NORMAL!=0
	.emsg	"FIX code!"
	.endif


	.text

#***************************************************************
* Main drone logic
* A13 = *Plyr process
* Trashes scratch, A2-A10, B2-B7

 SUBR	drone_main

	.if	DEBUG
	move	@droneoff,a0
	jrnz	#xx
	.endif


	move	*a13(DRN_BUT),a6	;A6=Old buts
	move	*a13(DRN_JOY),a7	;A7=Old joy

	move	*a13(CLOSEST_NUM),a14
	X32	a14
	addi	process_ptrs,a14
	move	*a14,a8,L		;A8=*Closest's proc

;	callr	drone_getcurskillo
;	move	a0,a10
	move	*a13(DRN_SKILL),a10
	X16	a10			;A10=Skill for indexing (*16)

	move	*a13(PLYRMODE),a0
	move	a0,b6			;B6=My pmode
	move	*a8(PLYRMODE),a0
	move	a0,b7			;B7=Opp pmode

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Find friendly wrestlers

	movi	process_ptrs,a2
	movk	NUM_WRES,b0
	clr	b2			;B2=Team dist ranking (0-2)
	clr	b3			;B3=# alive on my team (0-3)
#fflp
	move	*a2+,a3,L
	jrz	#ffnxt

	move	*a13(PLYR_SIDE),a0
	move	*a3(PLYR_SIDE),a1
	cmp	a0,a1
	jrne	#ffnxt			;Not on my team?

	move	*a3(PLYRMODE),a0
	subk	MODE_DEAD,a0
	jreq	#ffnxt

	addk	1,b3

	move	*a13(CLOSEST_NUM),a0
	move	*a3(CLOSEST_NUM),a1
	cmp	a0,a1
	jrne	#ffnxt			;Diff opponents?

	move	*a13(CLOSEST_DIST),a0
	move	*a3(CLOSEST_DIST),a1
	cmp	a1,a0
	jrle	#ffnxt			;I'm closer?

	addk	1,b2
#ffnxt
	dsj	b0,#fflp

#ffdn
	move	b2,b2
	jrz	#ffdoit			;I'm closest?

	move	*a13(DRN_ACT_p),a9,L
	jrnz	#ffx			;Script running?

	move	*a13(DRN_MODE),a0
	movi	-3,a1
	move	a1,*a13(DRN_MODE)	;Set mode
	addk	3,a0
	jrne	#newmdm3		;Init hang back?
	jruc	#ffx

#ffdoit
	move	*a13(DRN_MODE),a0
	addk	3,a0
	jreq	#newmd			;Set new mode if in hang back?

#ffx
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Random mode changes

	move	@PCNT,a0
	sll	32-5,a0
	jrnz	#nomdchk

	movk	3,a0
	callr	rnd
	jrnz	#nomdchk

	move	*a13(DRN_MODE),a0
	addk	3,a0
	jrle	#mcnosc			;Hang back?
#newmd
	movk	1,a0			;No aggressive
	move	@CURRENT_LADDER,a1,L	;* to position
	cmpi	LADDER,a1
	jreq	#mdeasy			;1st ladder?

	movk	3,a0			;Range
	cmpi	13*16,a10
	jrle	#mdeasy
	addk	1,a0			;More aggressive
#mdeasy
	callr	rndrng0
	subk	2,a0
	move	a0,*a13(DRN_MODE)	;-2 to 2

	move	*a13(DRN_ACT_p),a9,L
	jrnz	#mcnosc			;Script running?
	clr	a0
	move	a0,*a13(DRN_JOY)	;So we don't walk into ropes
#mcnosc
#newmdm3
	movk	4,a2			;Rgt side
	move	*a13(OBJ_XPOSINT),a0
	move	*a8(OBJ_XPOSINT),a1
	sub	a1,a0
	jrge	#metorgt
	movk	12,a2			;Left side
#metorgt
	move	a2,*a13(DRN_SEEKDIR)

	movk	4,a0
	callr	rndrng0

	move	*a13(DRN_MODE),a1
	addk	3,a1
	jrne	#nodhb			;!Hang back?
	ANDK	1,a0			;Make 3-4 or 4-5
	addk	2,a0
	move	b2,a14
	add	a14,a0
#nodhb
	move	a0,*a13(DRN_SEEKDIST)

#nomdchk
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Passive mode movement

	.if	BLKTEST
	jruc	#skmv
	.endif

	move	*a13(DRN_MODE),a0
	jrge	#skmv			;Aggressive?

	move	b6,b6
	jrnz	#skmv			;!MODE_NORMAL?

	move	*a13(DRN_ACT_p),a9,L
	jrnz	#skmv			;Script running?

	callr	drone_seekdirdist
#skmv

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Dec charge delay

	move	*a13(DRN_BUTCHRG),a0
	jrz	#nochrgn

	move	*a13(DRN_BUTCHRGDLY),a0
	subk	1,a0
	move	a0,*a13(DRN_BUTCHRGDLY)
#nochrgn

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Handle getup time

	move	*a13(GETUP_TIME),a2
	jrle	#nogt

	movi	99,a0
	callr	rndrng0
	move	a10,a1
	addi	#getup_t,a1
	move	*a1,a1
	cmp	a1,a0
	jrge	#dsabt

	subk	5,a2
	jrge	#gtok
	clr	a2
#gtok	move	a2,*a13(GETUP_TIME)
	jruc	#dsabt
#nogt
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	move	*a13(DRN_DELAY),a0
	subk	1,a0
	jrle	#newact
	move	a0,*a13(DRN_DELAY)
	jruc	#x
#newact
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Block detection

	move	*a8(ATTACK_TIME),a4
	move	@round_tickcount,a5
	sub	a5,a4			;-=Attack passed, +=Ticks till atk
	jrlt	#noblk

	movi	50,a1			;Closer Z allowed
	move	*a8(ATTACK_TYPE),a2
	cmpi	AT_PUSH,a2
	jreq	#noblk
	cmpi	AT_MSL,a2
	jreq	#msla			;Missile atk?

	move	*a13(CLOSEST_XDIST),a0
	cmpi	180,a0
	jrgt	#noblk			;Too far?
	movi	100,a1
#msla
	move	*a13(CLOSEST_ZDIST),a0
	cmp	a1,a0
	jrgt	#noblk			;Too far?

	move	*a8(GETUP_TIME),a14
	jrgt	#noblk			;Out of control?

	cmpi	MODE_INAIR2,b7
	jreq	#noblk			;Jumping on me?

	btst	PLAYER_BLOCK_BIT,a6
	jrnz	#x			;Trying to blk?

	move	*a8(ATTACK_TYPE),a2
	move	*a13(PLYRNUM),a0
	movi	AT_NUM,a3
	mpys	a0,a3
	add	a2,a3
	X16	a3
	addi	atkcnt_t,a3

	move	*a3,a2			;# missed blks
	cmpi	10,a2
	jrlo	#acok
	movk	9,a2
#acok
	X16	a2
	addi	#blkatk_t,a2
	move	*a2,a2			;Get %

	move	b3,a14			;# on team
	subk	1,a14
	X32	a14
	sub	a14,a2			;Decrease per extra bud

	.if	BLKTEST
	movi	100,a2
	.endif

	movi	99,a0
	callr	rndrng0
	move	a10,a1
	addi	#blkbase_t,a1
	move	*a1,a1			;Base %
	add	a2,a1
	cmp	a1,a0
	jrge	#missb

	cmpi	15,a4
	jrge	#minbtok		;Min time OK?
	movk	15,a4
#minbtok

	move	*a8(ATTACK_TYPE),a2
	cmpi	AT_LEAPING,a2
	jrne	#sblk			;!Leaping?

;	LOCKUP

	move	a10,a0
	srl	4+2,a0			;Skill/4
	callr	rndrng0
	move	a0,a0
	jrz	#sblk			;Skip?

	move	a5,*a8(ATTACK_TIME)	;Cancel

	movi	slhtoss,a9		;Flip opp
	jruc	#newsc

#sblk
	move	a4,*a13(DRN_DELAY)

	movk	B_M,a0			;Block it
	move	a0,*a13(DRN_BUT)

	cmpi	AT_PUPPET,a2
	jrne	#dsabt			;!Hip toss?

	movi	B_M+L_M+D_M,a0		;Special block
	move	a4,a3			;Dly
	clr	a9
	jruc	#setbx

#missb
	move	a5,*a8(ATTACK_TIME)	;Cancel

	move	*a3,a0			;Cnt+1
	addk	1,a0
	move	a0,*a3

#noblk
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>New script selection

	move	*a13(DRN_ACT_p),a9,L	;A9=*Script
	jrnz	#cact			;Continue script?


	clr	a2

	cmpi	MODE_BLOCK,b6
	jrne	#nps			;!Blking?
	btst	PLAYER_PUNCH_BIT,a6
	jrnz	#nps			;Already pushed?

	.if	BLKTEST
	jruc	#nps
	.endif

	movk	7,a0
	callr	rndrng0
	move	a0,a0
	jrnz	#nps			;Skip 88%?

	move	*a13(CLOSEST_XDIST),a0
	cmpi	110,a0
	jrgt	#nps			;Too far?
	move	*a13(CLOSEST_ZDIST),a0
	cmpi	40,a0
	jrgt	#nps			;Too far?
	movk	P_M+B_M,a2		;Push
	move	a2,*a13(DRN_BUT)
	jruc	#x
#nps
	move	a2,*a13(DRN_BUT)

	.if	BLKTEST
	jruc	#x
	.endif


	move	b6,b6
	jrnz	#doact			;!MODE_NORMAL?


	move	*a13(INRING),a0
	jrz	#ringok			;In ring?

	move	*a8(INRING),a0
	jrnz	#ringok			;Opp out?

	movi	drn_enterring,a9
	jruc	#newsc
#ringok

	move	*a13(DRN_MODE),a3
	cmpi	-3,a3
	jrle	#pass			;Hang back?

	cmpi	MODE_ONGROUND,b7
	jreq	#doact			;Atk?

	cmpi	MODE_INAIR2,b7
	jrne	#onia
	movi	drn_opinair,a9		;Avoid jump
	jruc	#newsc
#onia
	cmpi	MODE_RUNNING,b7
	jrne	#onrun
	move	*a13(CLOSEST_XDIST),a0
	cmpi	80,a0
	jrle	#onrun			;Too close?
	movi	drn_oprun,a9		;Anti run
	jruc	#newsc
#onrun

	move	*a8(ATTACK_TIME),a0
	move	@round_tickcount,a1
	sub	a1,a0			;-=Attack passed, +=Ticks till atk
	addk	15,a0
	jrge	#doact			;Get him after his atk (or no blk)?


	move	a3,a3
	jrlt	#pass			;Passive?

	movk	1fh,a0			;.6 sec
	cmpi	22*16,a10
	jrle	#cat
	movk	7,a0			;.15 sec
#cat
	callr	rnd
	jrz	#doactpup		;Atk?


#pass
	move	@PCNT,a0		;Chk every 16
	addk	1,a0
	sll	32-4,a0
	jrnz	#x

	move	*a13(CLOSEST_XDIST),a1
	move	*a13(CLOSEST_ZDIST),a14
	cmp	a1,a14
	jrge	#big
	move	a1,a14
#big
	cmpi	70,a14
	jrlt	#doactpup		;Opp in my face? Attack!

	move	*a13(DRN_MODE),a0
	addk	3,a0
	jrle	#x			;Hang back?

	move	@CURRENT_LADDER,a1,L	;* to position
	cmpi	LADDER,a1
	jreq	#nratk			;1st ladder?

	movk	0fh,a0			;Avg 4.8 sec
	callr	rnd
	jrz	#doactpup		;Random attack?
#nratk
	move	b7,b7
	jrz	#x			;Opp MODE_NORMAL? Be passive
#doactpup
	move	b7,a0
	subk	MODE_PUPPET2,a0
	jreq	#x
	subk	MODE_PUPPET-MODE_PUPPET2,a0
	jreq	#x
	cmpi	MODE_HEADHELD,b7
	jreq	#x
	cmpi	MODE_HEADHOLD,b7
	jreq	#x
	cmpi	MODE_ATTACHED,b7
	jreq	#x


#doact
	cmpi	MODE_HEADHELD,b6
	jreq	#slctscrpt

	cmpi	MODE_ONGROUND,b6
	jrne	#nognd
	movi	drn_roll,a9
	jruc	#newsc
#nognd
	cmpi	MODE_INAIR2,b6
	jrne	#nin2
	movi	drn_inair,a9
	jruc	#newsc
#nin2
	cmpi	MODE_ONTURNBKL,b6
	jrne	#notb
	movi	drn_ontb,a9
	jruc	#newsc
#notb
	cmpi	MODE_DEAD,b6
	jrne	#ndead
	movk	7,a0
	callr	rnd
	jruc	#butx
#ndead
	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#unint			;Wait?

	cmpi	MODE_RUNNING,b6
	jrne	#nrun
	movi	drn_run,a9
	jruc	#newsc
#nrun

	cmpi	MODE_HEADHOLD,b6
	jrne	#nhh

	clr	a0
	move	a0,*a13(DRN_BUTCHRG)	;Clr it

;	movk	1,a0			;50%
;	callr	rnd
;	jrnz	#nhh			;Don't combo?

	move	a8,a3
	move	a13,a8
	calla	CHECK_COMBO_GO
	jrlt	#ncmb			;Can't combo?
	move	a3,a8
	movi	drn_combo,a9
	jruc	#newsc
#ncmb
	move	a3,a8
#nhh

	move	*a13(DRN_BUTCHRG),a0
	jrz	#nochrg

	move	*a13(DRN_BUTCHRGDLY),a0
	jrgt	#nochrg

	cmpi	MODE_BLOCK,b7
	jreq	#nochrg			;Opp blking?

	move	*a13(DRN_BUTCHRG_p),a9,L ;Fire charge
	jruc	#newsc
#nochrg

	move	*a13(CLOSEST_DIST),a14
	cmpi	200,a14
	jrgt	#opnb

	cmpi	MODE_BLOCK,b7
	jrne	#opnb			;!Blking?

	move	*a13(CLOSEST_ZDIST),a14
	cmpi	40,a14
	jrgt	#bsk

	move	*a13(CLOSEST_XDIST),a14
	cmpi	60,a14
	jrgt	#bsk

	move	*a8(STICK_REL_CUR),a14
	cmpi	MOVE_DOWN_LEFT,a14
	jreq	#bht			;Hip toss blocked?

	movi	M_shrtblkr,a9		;Attack
	jruc	#getscrpt
#bht
	movi	M_shrtblkrdl,a9		;Attack
	jruc	#getscrpt
;	movi	hgrab,a9
;	jruc	#newsc
#bsk
	movi	drn_seekclose,a9
	jruc	#newsc
#opnb

	cmpi	MODE_DEAD,b7
	jrne	#opnd

	movi	drn_oppdead,a9
	jruc	#newsc
#opnd

#slctscrpt

	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	#wnshort_t,a0

	move	*a13(CLOSEST_XDIST),a1
	move	*a13(CLOSEST_ZDIST),a14
	X2	a14			;Z*2
	cmp	a1,a14
	jrge	#havebig
	move	a1,a14
#havebig
	cmpi	100,a14
	jrlt	#shrt
	addi	#wnmed_t-#wnshort_t,a0

	cmpi	180,a14
	jrlt	#med
	addi	#wnlong_t-#wnmed_t,a0
#shrt
#med
	move	*a0,a9,L		;Get * mode list
	move	b6,a2
	move	b7,a3
#mdlp
	movb	*a9,a0			;My mode #
	addk	8,a9
	movb	*a9,a14			;His mode #
	addk	8,a9
	move	*a9+,a1,L		;* script * table

	move	a0,a0
	jrn	#inochk			;Don't chk?
	cmp	a2,a0
	jrne	#mdlp			;Not in mode?
#inochk
	move	a14,a14
	jrn	#def			;Don't chk?
	cmp	a3,a14
	jrne	#mdlp			;Not in mode?
#def
	move	a1,a9
#getscrpt
	move	*a9+,a0			;# entries
	jrge	#neok			;!Headhold?
	abs	a0
	cmpi	26*16,a10
	jrle	#neok			;!Hard?
	movk	1,a0			;Only do first two
#neok
	callr	rndrng0
	X32	a0
	add	a0,a9
	move	*a9,a9,L		;* new script

#newsc
	move	b6,a0
	move	a0,*a13(DRN_SPMODE)


	cmpi	MODE_HEADHOLD,b6
	jrne	#nhh2

	movk	1,a3
	cmpi	2,b3
	jrlt	#hhd1			;1 opp?
	movk	22,a3
#hhd1
	movi	sklhhdly_t,a0
	add	a10,a0			;+Offset
	move	*a0,a0
	callr	rndrng0
	add	a0,a3			;Increase per extra bud

	move	@PCNT,a0
	sll	32-1,a0
	jrz	#hhdok			;Skip half of checks?

	cmpi	65,a3
	jrle	#hhdok
	movi	65,a3			;Max delay
#hhdok
	clr	a0
	jruc	#setbx
#nhh2

	cmpi	MODE_HEADHELD,b6
	jrne	#nhhe

	clr	a0
	move	a0,*a13(DRN_BUTCHRG)	;Clr it

	move	b3,a3			;# on team
	movk	7,a0
	callr	rnd
	jrz	#hrskmp			;12% skip multiplyr delay?
	subk	1,a3
	X16	a3
#hrskmp
	movi	sklhrdly_t,a0
	add	a10,a0			;+Offset
	move	*a0,a0
	callr	rndrng0
	addk	1,a0
	add	a0,a3			;Increase per extra bud

	move	@PCNT,a0
	sll	32-1,a0
	jrz	#hrdok			;Skip half of checks?

	cmpi	70,a3
	jrle	#hrdok
	movi	70,a3			;Max delay
#hrdok
	clr	a0
	jruc	#setbx
#nhhe


#cact
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Chk script for mode change

	move	b6,a0
	jrz	#mdsame			;MODE_NORMAL?
	subk	MODE_BLOCK,a0
	jreq	#mdsame			;Treat as normal?
	move	*a13(DRN_SPMODE),a0
	move	b6,a1
	cmp	a1,a0
	.if	DEBUG
	jreq	#dsok
	jruc	#dsabt			;For breakpoint
#dsok
	.endif
	jrne	#dsabt

#mdsame

	.if	DEBUG
	move	a9,a9			;Chk script *
	jrz	#a9ok
	cmpi	0ff000000h,a9
	jrhs	#a9ok
	LOCKUP
#a9ok
	.endif

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Read script command
#scplp
	move	*a9+,a0
	jrge	#nocd			;No command?

	sll	32-14,a0
	jrc	#dsdone			;Done? (Bit 14)

	srl	32-14,a0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Seek until 0

	subk	1,a0			;#1
	jrne	#nseekt0

	callr	drone_seek
	jrz	#scplp

	subk	16,a9
	jruc	#dsdone
#nseekt0
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Random skill lvl abort

	subk	1,a0			;#2
	jrne	#nrnda

	cmpi	MODE_BLOCK,b7
	jreq	#dsabt			;Blking?

	move	*a9+,a3,L		;*Skill table

;	clr	a2
;	cmpi	sklrev_t,a3
;	jrne	#nsr
;	move	b3,a2			;# on team
;	subk	1,a2
;	X16	a2
;#nsr
	movi	99,a0
	callr	rndrng0
	add	a10,a3			;+Offset
	move	*a3,a1
;	sub	a2,a1			;Decrease per extra bud
	cmp	a1,a0
	jrlt	#scplp			;Cont?

	movk	10,a0
	move	a0,*a13(DRN_DELAY)

	jruc	#dsabt
#nrnda
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Wait till interruptable

	subk	1,a0			;#3
	jrne	#nwtint

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrz	#scplp			;Off?

	subk	16,a9
	jruc	#dsdone
#nwtint
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Abort if opponent blocking

	subk	1,a0			;#4
	jrne	#naib

	cmpi	MODE_BLOCK,b7
	jrne	#scplp			;!Blocked?

	jruc	#dsabt
#naib
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Call code

	subk	1,a0			;#5
	jrne	#ncall

	move	*a9+,a0,L
	call	a0

	jruc	#scplp
#ncall
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Rnd jump

	subk	1,a0			;#6
	jrne	#nrj

	movi	99,a0
	callr	rndrng0
	move	*a9+,a1			;Percent to jmp
	move	*a9+,a2,L
	cmp	a1,a0
	jrge	#scplp

	move	a2,a9			;New addr
	jruc	#scplp
#nrj
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Jump

	subk	1,a0			;#7
	jrne	#njmp

	move	*a9+,a9,L
	jruc	#scplp
#njmp
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Call function

	exgpc	a9
	jruc	#scplp
#nocd
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Joy & button bits

	move	*a9+,a3			;Get delay
#setbx
	move	a0,a1
	sll	32-5,a0
	srl	32-5,a0
	move	a0,*a13(DRN_BUT)

	srl	5,a1
	move	*a13(FACING_DIR),a14
	btst	PLAYER_RIGHT_BIT,a14
	jrnz	#rgt			;Facing rgt?

	move	a1,a0			;>Flip L&R bits
	move	a1,a14
	sll	32-2,a1
	srl	3,a0			;Bit0=Rgt
	sll	32-3,a14
	srl	31,a14
	sll	1,a14			;Bit1=Left
	or	a0,a1
	or	a14,a1
	rl	2,a1
#rgt
	move	a1,*a13(DRN_JOY)

	move	a3,*a13(DRN_DELAY)
	move	a3,a3
	jrgt	#dsdone
#dsabt
	clr	a9
#dsdone
	move	a9,*a13(DRN_ACT_p),L

#unint

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Calc ctrl bit transitions
#x
	move	*a13(DRN_BUT),a0
#butx
	move	*a13(DRN_BUTCHRG),a14
	or	a14,a0
	move	a0,*a13(DRN_BUT)
	xor	a0,a6
	move	a6,a1
	and	a0,a6
	move	a6,*a13(DRN_BUTDT)
	andn	a0,a1
	move	a1,*a13(DRN_BUTUT)

	move	*a13(DRN_JOY),a0
	xor	a0,a7
	move	a7,a1
	and	a0,a7
	move	a7,*a13(DRN_JOYDT)
	andn	a0,a1
	move	a1,*a13(DRN_JOYUT)

#xx
	rets


SKLM	.macro	w,ad
	.word	:w:,:w:+:ad:,:w:+:ad:*2,:w:+:ad:*3,:w:+:ad:*4
	.endm

#getup_t				;% to bump getup time
	SKLM	10,2
	SKLM	20,2
	SKLM	30,2
	SKLM	40,2
	SKLM	50,2
	SKLM	60,10
#blkbase_t				;Base % to block
	SKLM	10,2
	SKLM	20,2
	SKLM	30,1
	SKLM	35,1
	SKLM	40,1
	SKLM	47,7
#blkatk_t				;% to block per attack
	.word	0,10,20,30,40
	.word	50,50,50,50,50
sklhhdly_t				;Max delay on hh
	SKLM	150,-6
	SKLM	120,-6
	SKLM	90,-6
	SKLM	60,-6
	SKLM	28,-3
	SKLM	13,-2
sklhrdly_t				;Max delay on hh rev
	SKLM	150,-6
	SKLM	120,-6
	SKLM	90,-6
	SKLM	60,-6
	SKLM	28,-3
	SKLM	13,-2
sklrep_t				;% to repeat
	SKLM	20,4
	SKLM	45,2
	SKLM	55,4
	SKLM	75,2
	SKLM	85,2
	SKLM	90,3


;#getup_t				;% to bump getup time
;	SKLM	5,2
;	SKLM	15,1
;	SKLM	20,2
;	SKLM	30,2
;	SKLM	40,4
;	SKLM	60,10
;#blkbase_t				;Base % to block
;	SKLM	5,1
;	SKLM	10,2
;	SKLM	20,2
;	SKLM	30,1
;	SKLM	35,2
;	SKLM	45,7
;#blkatk_t				;% to block per attack
;	.word	0,10,20,30,40
;	.word	50,50,50,50,50
;sklhhdly_t				;Max delay on hh
;	SKLM	200,-10
;	SKLM	150,-6
;	SKLM	120,-9
;	SKLM	70,-8
;	SKLM	35,-4
;	SKLM	15,-2
;sklhrdly_t				;Max delay on hh rev
;	SKLM	200,-10
;	SKLM	150,-6
;	SKLM	120,-8
;	SKLM	70,-4
;	SKLM	50,-7
;	SKLM	15,-2
;sklrep_t				;% to repeat
;	SKLM	6,3
;	SKLM	20,4
;	SKLM	40,2
;	SKLM	50,4
;	SKLM	70,4
;	SKLM	90,3
;

#wnshort_t
	.long	bret_s_t,raz_s_t,utak_s_t,yoko_s_t
	.long	shawn_s_t,bam_s_t,doink_s_t,doink_s_t,lex_s_t
#wnmed_t
	.long	bret_m_t,raz_m_t,utak_m_t,yoko_m_t
	.long	shawn_m_t,bam_m_t,doink_m_t,doink_m_t,lex_m_t
#wnlong_t
	.long	bret_l_t,raz_l_t,utak_l_t,yoko_l_t
	.long	shawn_l_t,bam_l_t,doink_l_t,doink_l_t,lex_l_t


#*******************************
* Drone script commands

BBL	.macro	w,w2,l
	.byte	:w:,:w2:
	.long	:l:
	.endm

DS_CODE	.macro
	.word	8000h+0
	.endm
DS_CODEEND	.macro
	exgpc	a9
	.endm
DS_SEEKTIL0	.macro
	.word	8000h+1
	.endm
DS_RNDA	.macro	l
	.word	8000h+2
	.long	:l:
	.endm
DS_WTINT	.macro
	.word	8000h+3
	.endm
DS_ABIFBLK	.macro
	.word	8000h+4
	.endm
DS_CALL	.macro	a
	.word	8000h+5
	.long	:a:
	.endm
DS_RJMP	.macro	p,a
	.word	8000h+6,:p:
	.long	:a:
	.endm
DS_JMP	.macro	a
	.word	8000h+7
	.long	:a:
	.endm
DS_SLP1	.macro
	.word	0c000h+0
	.endm
DS_END	.macro
	.word	0,0
	.endm

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		>Bam bam scripts

bam_s_t
	BBL	MODE_HEADHOLD,-1,baM_hh
	BBL	MODE_HEADHELD,-1,baM_hhr
	BBL	MODE_OPPOVERHEAD,-1,baM_ooh
	BBL	-1,MODE_ONGROUND,M_og
	BBL	-1,MODE_ONTURNBKL,M_opptbkl
	BBL	-1,MODE_CLIMBTURNBKL,M_opptbkl
	WL	-1,baM_n
bam_m_t
	BBL	MODE_HEADHOLD,-1,baM_hh
	BBL	MODE_HEADHELD,-1,baM_hhr
	BBL	MODE_OPPOVERHEAD,-1,baM_ooh
	BBL	-1,MODE_ONGROUND,Mm_og
	BBL	-1,MODE_ONTURNBKL,M_opptbkl
	BBL	-1,MODE_CLIMBTURNBKL,M_opptbkl
	WL	-1,baMm_n

baM_n	;Normal
	.word	(baM_n_-$)/32-1
	.long	#run
	.long	#p,#sp,#k,#sk
	.long	#spx
	.long	#hgrab,#hgrab,#hgrab
	.long	#flng
	.long	#htoss,#htoss
	.long	#llsk		;Karate kick
	.long	#spsk		;Pickup
baM_n_
baMm_n
	.word	(baMm_n_-$)/32-1
	.long	drn_seek
	.long	drn_retreat
	.long	#run
	.long	#sp
	.long	#sk
;	.long	#hgrab,#hgrab,#hgrab
	.long	#flng
	.long	#llsk		;Karate kick
	.long	#spsk		;Pickup
	.long	#fast		;Hyper
	.long	#chrg
baMm_n_
baM_hh	;Holding head
;	.word	1-1
;	.long	#bahh
	.word	-(7-1)
	.long	#bahhpg		;Pogo
	.long	#lrrsp		;Pile drvr
	.long	#jk		;Pickup
	.long	#bahhrsk	;Knees (3 way)
	.long	#bahhrsk
	.long	#bahhrsk
	.long	#spsk2		;Neck brkr

baM_hhr ;Head held reversals
	.word	4-1
	.long	#k
	.long	#bahhpg		;Pogo
	.long	#lrrsp		;Pile drvr
	.long	#spsk2		;Neck brkr

baM_ooh ;Holding opp over head
	.word	2-1
	.long	#k		;Slam
	.long	#dsk		;Back brkr

#bahhrsk ;Knees
	.word	R_M+SK_M,2
	.word	0,5
;FIX! - chk timing
	.word	SK_M,4, 0,4, SK_M,4, 0,4, SK_M,4, 0,4
	DS_RNDA	sklrep_t
	.word	SK_M,4, 0,4, SK_M,4, 0,4, SK_M,4, 0,4
	DS_RJMP	33,#k		;Hip toss
	DS_RJMP	33,#sp		;Pickup
	.word	D_M+SP_M,0	;Pile drvr
#bahhpg
	.word	U_M,2, D_M,2, 0,2, D_M,2, SK_M,50
	DS_RNDA	sklrep_t
	.word	SP_M,2, 0,2, SP_M,2, 0,2, SP_M,2, 0,15	;Repeat
	DS_RNDA	sklrep_t
	.word	SP_M,2, 0,2, SP_M,2, 0,2, SP_M,2, 0,15
	.word	SP_M,2, 0,2, SP_M,2, 0,2, SP_M,0


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		>Undertaker scripts

utak_s_t
	BBL	MODE_HEADHOLD,-1,utM_hh
	BBL	MODE_HEADHELD,-1,M_hhr
	BBL	MODE_CHOKEHOLD,-1,utM_chold
	BBL	-1,MODE_ONGROUND,M_og
	BBL	-1,MODE_ONTURNBKL,M_opptbkl
	BBL	-1,MODE_CLIMBTURNBKL,M_opptbkl
	WL	-1,utM_n
utak_m_t
	BBL	MODE_HEADHOLD,-1,utM_hh
	BBL	MODE_HEADHELD,-1,M_hhr
	BBL	MODE_CHOKEHOLD,-1,utM_chold
	BBL	-1,MODE_ONGROUND,Mm_og
	BBL	-1,MODE_ONTURNBKL,M_opptbkl
	BBL	-1,MODE_CLIMBTURNBKL,M_opptbkl
	WL	-1,utMm_n

utM_n	;Normal
;	.word	1-1
;	.long	#ut
	.word	(utM_n_-$)/32-1
	.long	#run
	.long	#spx
	.long	#p,#sp,#k,#sk
	.long	#hgrab,#hgrab,#hgrab
	.long	#flng
	.long	#htoss,#htoss
	.long	#ucut
	.long	#utshootps	;Fire push ghosts
	.long	#utshootpl	;Fire pull ghosts
	.long	#uttombhit	;Smash with tombstone
	.long	#jp		;Slide choke
utM_n_
utMm_n
;	.word	1-1
;	.long	#utshootpl
	.word	(utMm_n_-$)/32-1
	.long	drn_seek
	.long	drn_retreat
	.long	#run
	.long	#sp
	.long	#sk
;	.long	#hgrab,#hgrab,#hgrab
	.long	#flng
	.long	#utshootps	;Fire push ghosts
	.long	#utshootpl	;Fire pull ghosts
	.long	#uttombhit	;Smash with tombstone
	.long	#jp		;Slide choke
	.long	#fast		;Hyper
	.long	#chrg
utMm_n_
utM_hh	;Holding head
	.word	-(6-1)
	.long	#uddsk		;Pile drv
	.long	#lrrsp		;Neck brkr
	.long	#uthhrp
	.long	#ucut
	.long	#uttombhit	;Smash with tombstone
	.long	#utdk		;Face slam

utM_chold ;Choke holding opp by neck
	.word	7-1
	.long	#p
	.long	#k
	.long	#htoss
	.long	#ucut
	.long	#utchup
	.long	#utdk		;Face slam
	.long	#dsk		;Slam

#utshootps
	.word	R_M,2, 0,2, R_M,2, K_M,2, 0,2
	DS_WTINT
	DS_ABIFBLK
	.word	P_M+K_M,0
#utshootpl
	.word	L_M,2, 0,2, L_M,2, K_M,2, 0,2
	DS_WTINT
	DS_ABIFBLK
	.word	D_M+SP_M,0
#uttombhit
	.word	R_M,2, 0,2, R_M,2, SK_M,5
	DS_RNDA	sklrep_t
	.word	K_M,4, 0,4, K_M,4, 0,4, K_M,4, 0,4	;Repeat
	DS_ABIFBLK
	DS_RNDA	sklrep_t
	.word	K_M,4, 0,4, K_M,4, 0,4, K_M,4, 0,4
	.word	K_M,4, 0,4, K_M,4, 0,4, K_M,0

#uthhrp ;Knee & hdbuts
	.word	R_M+P_M,2
	.word	0,5
;FIX! - chk timing
	.word	P_M,4, 0,4, P_M,4, 0,4, P_M,4, 0,4
	DS_RNDA	sklrep_t
	.word	P_M,4, 0,4, P_M,4, 0,4, P_M,4, 0,4
	DS_RJMP	50,#sp		;Fly kick
	.word	K_M,0		;Neck brkr

#utchup ;Knee & hdbuts
	.word	U_M+P_M,2
	.word	0,5
	.word	P_M,4, 0,4, P_M,4, 0,4, P_M,4, 0,4
	DS_RNDA	sklrep_t
	.word	P_M,4, 0,4, P_M,4, 0,4, P_M,4, 0,4
	DS_RJMP	50,#sp		;Fly kick
	.word	K_M,0		;Neck brkr

#utdk	;Face slam
	.word	D_M,2, 0,2, D_M+K_M,2
	DS_RNDA	sklrep_t
	.word	0,5
	.word	P_M,4, 0,4, P_M,4, 0,4, P_M,4, 0,4	;Repeat
	.word	P_M,4, 0,4, P_M,4, 0,4, P_M,4, 0,4
	DS_RNDA	sklrep_t
	.word	P_M,4, 0,4, P_M,4, 0,4, P_M,0


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		>Doink scripts

doink_s_t
	BBL	MODE_HEADHOLD,-1,doM_hh
	BBL	MODE_HEADHELD,-1,doM_hhr
	BBL	-1,MODE_ONGROUND,M_og
	BBL	-1,MODE_ONTURNBKL,M_opptbkl
	BBL	-1,MODE_CLIMBTURNBKL,M_opptbkl
	WL	-1,doM_n
doink_m_t
	BBL	MODE_HEADHOLD,-1,doM_hh
	BBL	MODE_HEADHELD,-1,doM_hhr
	BBL	-1,MODE_ONGROUND,Mm_og
	BBL	-1,MODE_ONTURNBKL,M_opptbkl
	BBL	-1,MODE_CLIMBTURNBKL,M_opptbkl
	WL	-1,doMm_n

doM_n	;Normal
;	.word	1-1
;	.long	#eslap
	.word	(doM_n_-$)/32-1
	.long	#run
	.long	#spx
	.long	#p,#sp,#k,#sk
	.long	#hgrab,#hgrab,#hgrab
	.long	#flng
	.long	#htoss,#htoss
	.long	#ucut
	.long	#doham		;Hammer
	.long	#doeslap	;Ear slap
	.long	#dopbig		;Boxing punch
doM_n_
doMm_n
;	.word	1-1
;	.long	#doeslap
	.word	(doMm_n_-$)/32-1
	.long	drn_seek
	.long	drn_retreat
	.long	#run
	.long	#sp
	.long	#sk
;	.long	#hgrab,#hgrab,#hgrab
	.long	#flng
	.long	#doham		;Hammer
	.long	#doeslap	;Ear slap
	.long	#fast		;Hyper
	.long	#chrg
doMm_n_
doM_hh	;Holding head
	.word	-(8-1)
	.long	#uddskk		;Face slam
	.long	#lrrsp		;Pile drv
	.long	#doham
	.long	#j2p		;Buzz
	.long	#hhp3k		;P & fly kick
	.long	#hhp4
	.long	#hhp3pd		;P & pdrv
	.long	#hhsk3pd	;K & pdrv

doM_hhr ;Head held reversals
	.word	3-1
	.long	#k
	.long	#uddskk		;Face slam
	.long	#lrrsp		;Pile drv

#doham	.word	R_M,2, 0,2, R_M,2, SK_M,10
	DS_RNDA	sklrep_t
	.word	K_M,4, 0,4, K_M,4, 0,4, K_M,4, 0,4	;Repeat
	DS_RNDA	sklrep_t
	.word	K_M,4, 0,4, K_M,4, 0,4, K_M,4, 0,4
	.word	K_M,4, 0,4, K_M,4, 0,4, K_M,0

#doeslap
	.word	D_M,2, D_M+R_M,2, R_M,2, P_M,2
	DS_RNDA	sklrep_t
	.word	0,5, P_M,5, 0,5, P_M,5			;Repeat
	DS_RNDA	sklrep_t
	.word	0,5, P_M,5, 0,5, P_M,5
	.word	0,5, P_M,5, 0,5, P_M,0

#dopbig	.word	P_M,2, 0,2, P_M,2, 0,2, P_M,2, 0,2, P_M,2, 0,2
	.word	P_M,2, 0,2, P_M,2, 0,2, P_M,0


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		>Yoko scripts

yoko_s_t
	BBL	MODE_HEADHOLD,-1,yoM_hh
	BBL	MODE_HEADHELD,-1,M_hhr
	BBL	MODE_OPPOVERHEAD,-1,yoM_ooh
	BBL	-1,MODE_ONGROUND,M_og
	BBL	-1,MODE_ONTURNBKL,M_opptbkl
	BBL	-1,MODE_CLIMBTURNBKL,M_opptbkl
	WL	-1,yoM_n
yoko_m_t
	BBL	MODE_HEADHOLD,-1,yoM_hh
	BBL	MODE_HEADHELD,-1,M_hhr
	BBL	MODE_OPPOVERHEAD,-1,yoM_ooh
	BBL	-1,MODE_ONGROUND,Mm_og
	BBL	-1,MODE_ONTURNBKL,M_opptbkl
	BBL	-1,MODE_CLIMBTURNBKL,M_opptbkl
	WL	-1,yoMm_n

yoM_n	;Normal
;	.word	1-1
;	.long	#eslap
	.word	(yoM_n_-$)/32-1
	.long	#run
	.long	#spx
	.long	#p,#sp,#k,#sk
	.long	#hgrab,#hgrab,#hgrab
	.long	#flng
	.long	#htoss,#htoss
	.long	#jp		;Speed jab
	.long	#rrsk		;Scissor squish
	.long	#rrp		;Gut push
	.long	#spsk		;Pickup
yoM_n_
yoMm_n
;	.word	1-1
;	.long	#doeslap
	.word	(yoMm_n_-$)/32-1
	.long	drn_seek
	.long	drn_retreat
	.long	#run
	.long	#sp
	.long	#sk
;	.long	#hgrab,#hgrab,#hgrab
	.long	#flng
	.long	#jp		;Speed jab
	.long	#rrsk		;Scissor squish
	.long	#spsk		;Pickup
	.long	#fast		;Hyper
	.long	#chrg
yoMm_n_
yoM_hh	;Holding head
	.word	-(4-1)
	.long	#uddsk		;Vert suplex
	.long	#lrrsp		;Scissor squish
	.long	#j2p		;Salt
	.long	#ucut

yoM_ooh ;Holding opp over head
	.word	2-1
	.long	#k		;Slam
	.long	#dsk		;Spinning slam


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		>Shawn scripts

shawn_s_t
	BBL	MODE_HEADHOLD,-1,shM_hh
	BBL	MODE_HEADHELD,-1,shM_hhr
	BBL	-1,MODE_ONGROUND,M_og
	BBL	-1,MODE_ONTURNBKL,M_opptbkl
	BBL	-1,MODE_CLIMBTURNBKL,M_opptbkl
	WL	-1,shM_n
shawn_m_t
	BBL	MODE_HEADHOLD,-1,shM_hh
	BBL	MODE_HEADHELD,-1,shM_hhr
	BBL	-1,MODE_ONGROUND,Mm_og
	BBL	-1,MODE_ONTURNBKL,M_opptbkl
	BBL	-1,MODE_CLIMBTURNBKL,M_opptbkl
	WL	-1,shMm_n

shM_n	;Normal
;	.word	1-1
;	.long	#eslap
	.word	(shM_n_-$)/32-1
	.long	#run
	.long	#spx
	.long	#p,#sp,#k,#sk
	.long	#hgrab,#hgrab,#hgrab
	.long	#flng
	.long	#htoss,#htoss
	.long	#llsk		;Karate kick
	.long	#jkk		;Speed kick
	.long	#rrsk		;Frankensteiner
	.long	#rrk		;Sliding kick toss
	.long	#jisp		;Flipslam
shM_n_
shMm_n
;	.word	1-1
;	.long	#doeslap
	.word	(shMm_n_-$)/32-1
	.long	drn_seek
	.long	drn_retreat
	.long	#run
	.long	#sp
	.long	#sk
;	.long	#hgrab,#hgrab,#hgrab
	.long	#flng
	.long	#llsk		;Karate kick
	.long	#jkk		;Speed kick
	.long	#rrsk		;Frankensteiner
	.long	#rrk		;Sliding kick toss
	.long	#jisp		;Flipslam
	.long	#fast		;Hyper
	.long	#chrg
shMm_n_
shM_hh	;Holding head
	.word	-(8-1)
	.long	#uddsk		;German suplex
	.long	#lrrsp		;Frankensteiner
	.long	#rsk4k		;Quick knees
	.long	#jkk		;Speed kick
	.long	#rp		;Arm break
	.long	#rsp4		;Jmp head butt
	.long	#rk4		;Speed kick
	.long	#lrrk		;Kick toss

shM_hhr ;Head held reversals
	.word	5-1
	.long	#k
	.long	#uddsk		;German suplex
	.long	#lrrsp		;Frankensteiner
	.long	#lrrk		;Kick toss
	.long	#jkk		;Speed kick


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		>Bret scripts

bret_s_t
	BBL	MODE_HEADHOLD,-1,brM_hh
	BBL	MODE_HEADHELD,-1,brM_hhr
	BBL	-1,MODE_ONGROUND,M_og
	BBL	-1,MODE_ONTURNBKL,M_opptbkl
	BBL	-1,MODE_CLIMBTURNBKL,M_opptbkl
	WL	-1,brM_n
bret_m_t
	BBL	MODE_HEADHOLD,-1,brM_hh
	BBL	MODE_HEADHELD,-1,brM_hhr
	BBL	-1,MODE_ONGROUND,Mm_og
	BBL	-1,MODE_ONTURNBKL,M_opptbkl
	BBL	-1,MODE_CLIMBTURNBKL,M_opptbkl
	WL	-1,brMm_n

brM_n	;Normal
;	.word	1-1
;	.long	#eslap
	.word	(brM_n_-$)/32-1
	.long	#run
	.long	#p,#sp,#k,#sk
	.long	#spx
	.long	#hgrab,#hgrab,#hgrab
	.long	#flng
	.long	#htoss,#htoss
	.long	#ucut
	.long	#ddp		;Leap ucut
	.long	#jp		;Face rake
	.long	#j2sp		;Rolling ucut
	.long	#llsk		;Fast kick
brM_n_
brMm_n
;	.word	1-1
;	.long	#doeslap
	.word	(brMm_n_-$)/32-1
	.long	drn_seek
	.long	drn_retreat
	.long	#run
	.long	#sp
	.long	#sk
;	.long	#hgrab,#hgrab,#hgrab
	.long	#flng
	.long	#ddp		;Leap ucut
	.long	#jp		;Face rake
	.long	#j2sp		;Rolling ucut
	.long	#llsk		;Fast kick
	.long	#fast		;Hyper
	.long	#chrg
brMm_n_
brM_hh	;Holding head
	.word	-(7-1)
	.long	#uddsk		;Neck DDT
	.long	#lrrsp		;Pile drvr
	.long	#ucut
	.long	#jpx		;Face drvr
;FIX! - broke
	.long	#rp		;Arm break
	.long	#rsp		;Head to knee
;FIX! - broke
	.long	#lrrp		;Knee to face

brM_hhr ;Head held reversals
	.word	4-1
	.long	#k
	.long	#uddsk		;Neck DDT
	.long	#lrrsp		;Pile drvr
	.long	#lrrp		;Kick toss
;	.long	#jk		;


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		>Razor scripts

raz_s_t
	BBL	MODE_HEADHOLD,-1,rzM_hh
	BBL	MODE_HEADHELD,-1,rzM_hhr
	BBL	-1,MODE_ONGROUND,M_og
	BBL	-1,MODE_ONTURNBKL,M_opptbkl
	BBL	-1,MODE_CLIMBTURNBKL,M_opptbkl
	WL	-1,rzM_n
raz_m_t
	BBL	MODE_HEADHOLD,-1,rzM_hh
	BBL	MODE_HEADHELD,-1,rzM_hhr
	BBL	-1,MODE_ONGROUND,Mm_og
	BBL	-1,MODE_ONTURNBKL,M_opptbkl
	BBL	-1,MODE_CLIMBTURNBKL,M_opptbkl
	WL	-1,rzMm_n

rzM_n	;Normal
;	.word	1-1
;	.long	#eslap
	.word	(rzM_n_-$)/32-1
	.long	#run
	.long	#p,#sp,#k,#sk
	.long	#spx
	.long	#hgrab,#hgrab,#hgrab
	.long	#flng
	.long	#htoss,#htoss
	.long	#ucut
	.long	#jp		;Down slash
	.long	#rrk		;Rug slam
rzM_n_
rzMm_n
;	.word	1-1
;	.long	#doeslap
	.word	(rzMm_n_-$)/32-1
	.long	drn_seek
	.long	drn_retreat
	.long	#run
	.long	#sp
	.long	#sk
;	.long	#hgrab,#hgrab,#hgrab
	.long	#flng
	.long	#jp		;Down slash
	.long	#fast		;Hyper
	.long	#chrg
rzMm_n_
rzM_hh	;Holding head
	.word	-(6-1)
	.long	#uddsk		;P drvr
	.long	#lrrsp		;Razors edge
	.long	#rzup4		;Slashes up
	.long	#rzdp4		;Slashes dn
	.long	#ucut
	.long	#rzuddksp	;Rug shake

rzM_hhr ;Head held reversals
	.word	4-1
	.long	#k
	.long	#uddsk		;P drvr
	.long	#lrrsp		;Razors edge
	.long	#rzuddksp	;Rug shake

#rzup4	.word	U_M+P_M,5, 0,5, P_M,5, 0,5, P_M,5, 0,5, P_M,0
#rzdp4	.word	D_M+P_M,5, 0,5, P_M,5, 0,5, P_M,5, 0,5, P_M,0

#rzuddksp
	.word	U_M,2, D_M,2, 0,2, D_M,2, K_M,2
	DS_RNDA	sklrep_t
	.word	0,20
	.word	SP_M,6, 0,6, SP_M,6, 0,6, SP_M,6, 0,6	;Repeat
	DS_RNDA	sklrep_t
	.word	SP_M,6, 0,6, SP_M,6, 0,6, SP_M,0


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		>Lex scripts

lex_s_t
	BBL	MODE_HEADHOLD,-1,lxM_hh
	BBL	MODE_HEADHELD,-1,lxM_hhr
	BBL	MODE_OPPOVERHEAD,-1,lxM_ooh
	BBL	-1,MODE_ONGROUND,M_og
	BBL	-1,MODE_ONTURNBKL,M_opptbkl
	BBL	-1,MODE_CLIMBTURNBKL,M_opptbkl
	WL	-1,lxM_n
lex_m_t
	BBL	MODE_HEADHOLD,-1,lxM_hh
	BBL	MODE_HEADHELD,-1,lxM_hhr
	BBL	MODE_OPPOVERHEAD,-1,lxM_ooh
	BBL	-1,MODE_ONGROUND,Mm_og
	BBL	-1,MODE_ONTURNBKL,M_opptbkl
	BBL	-1,MODE_CLIMBTURNBKL,M_opptbkl
	WL	-1,lxMm_n

lxM_n	;Normal
;	.word	1-1
;	.long	#eslap
	.word	(lxM_n_-$)/32-1
	.long	#run
	.long	#p,#sp,#k,#sk
	.long	#spx
	.long	#hgrab,#hgrab,#hgrab
	.long	#flng
	.long	#htoss,#htoss
	.long	#rrp		;Elbow to gut
	.long	#spsk		;Pickup
lxM_n_
lxMm_n
;	.word	1-1
;	.long	#doeslap
	.word	(lxMm_n_-$)/32-1
	.long	drn_seek
	.long	drn_retreat
	.long	#run
	.long	#sp
	.long	#sk
;	.long	#hgrab,#hgrab,#hgrab
	.long	#flng
	.long	#rrp		;Elbow to gut
	.long	#spsk		;Pickup
	.long	#fast		;Hyper
	.long	#chrg
lxMm_n_
lxM_hh	;Holding head
	.word	-(4-1)
	.long	#uddsk		;Neck DDT
	.long	#lrrsp		;Vert suplex
	.long	#rsk4k		;Quick knees & v suplex
	.long	#jk		;Pickup

lxM_hhr ;Head held reversals
	.word	4-1
	.long	#k
	.long	#uddsk		;Neck DDT
	.long	#lrrsp		;V suplex
	.long	#jk		;Pickup

lxM_ooh ;Holding opp over head
	.word	3-1
	.long	#p		;Slam
	.long	#usp		;Head slam
	.long	#usk		;Back brkr


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		>Generic scripts

M_og	;Opp on gnd
	.word	6-1
;	.long	drn_retreat
	.long	#p,#sp,#k,#sk
	.long	#oghg,#oghg
Mm_og
	.word	3-1
	.long	drn_seek
;FIX! - Rzr rug shake
	.long	#seeksp
	.long	#seeksk

M_opptbkl ;Opp on turnbkl
	.word	1-1
	.long	#run

M_hhr	;Head held reversals
	.word	3-1
	.long	#k
	.long	#uddsk
	.long	#lrrsp

M_shrtblkr
	.word	2-1
	.long	#hgrab
	.long	#htoss
M_shrtblkrdl
	.word	2-1
	.long	#hgrab
	.long	#spx
;	.long	drn_climbtb

#spx	.word	SP_M,2, 0,2, SP_M,2, 0,2, SP_M,2
	.word	SP_M,2, 0,2, SP_M,2, 0,2, SP_M,0

#p	.word	P_M,0
#sp	.word	SP_M,0
#k	.word	K_M,0
#sk	.word	SK_M,0
#spsk	.word	SP_M+SK_M,0
#rp	.word	R_M+P_M,0
#rsp	.word	R_M+SP_M,0
#rsp4	.word	R_M+SP_M,4, 0,4, SP_M,4, 0,4, SP_M,4, 0,4, SP_M,0
#rk4	.word	R_M+K_M,4, 0,4, K_M,4, 0,4, K_M,4, 0,4, K_M,0
#rsk	.word	R_M+SK_M,0
#rsk4k	.word	R_M+SK_M,4, 0,4, SK_M,4, 0,4, SK_M,4, 0,4, SK_M,4, K_M,0
#rrp	.word	R_M,2, 0,2, R_M,2, P_M,0
#rrk	.word	R_M,2, 0,2, R_M,2, K_M,0
#rrsk	.word	R_M,2, 0,2, R_M,2, SK_M,0
#llsk	.word	L_M,2, 0,2, L_M,2, SK_M,0
#dp	.word	D_M+P_M,0
#dk	.word	D_M+K_M,0
#dsk	.word	D_M+SK_M,0
#ddp	.word	D_M,2, 0,2, D_M,2, P_M,0
#usp	.word	U_M+SP_M,0
#usk	.word	U_M+SK_M,0

#run
	DS_CALL	drone_chkrun
	.word	P_M+K_M,0	;Skipped if bad
	DS_END
hgrab
#hgrab	.word	R_M,2, 0,2, R_M,2, SP_M,0
#flng	.word	L_M,2, 0,2, L_M+SP_M,0		;Grab fling
slhtoss	.word	L_M,2, 0,2, L_M,2, P_M,0	;Hip toss
#htoss	.word	L_M,2, 0,2, L_M+P_M,0		;Hip toss
#ucut	.word	D_M+SP_M,0			;Uppercut

#seeksp
	DS_SEEKTIL0
	.word	SP_M,0
#seeksk
	DS_SEEKTIL0
	.word	SK_M,0
#chrg
	DS_CALL	drone_chrg
	DS_END

#oghg	;Opp on gnd head grab
	.word	D_M,2, SP_M,0

#fast	;Works once
	.word	L_M,2, L_M+D_M,2, D_M,2, D_M+R_M,2
	.word	R_M,2, R_M+U_M,2, U_M,2, U_M+L_M,0

;#lrrspp	;Pile drvr/Neck brkr
;	.word	L_M,2, R_M,2, 0,2, R_M,2, SP_M,2
;	DS_RNDA	sklrep_t
;	.word	0,5
;	.word	P_M,4, 0,4, P_M,4, 0,4, P_M,4, 0,4	;Repeat
;	DS_RNDA	sklrep_t
;	.word	P_M,4, 0,4, P_M,4, 0,4, P_M,4, 0,4
;	.word	P_M,4, 0,4, P_M,4, 0,4, P_M,0

#hhp3k	;Punch*3, kick
	.asg	6,T
	.word	R_M+P_M,T, R_M,T, R_M+P_M,T, R_M,T
	.word	R_M+P_M,T, R_M,T, R_M+P_M,T, R_M,T
	.word	R_M+K_M,2
	.word	0,10
	DS_END

#hhp4	;Punch*4
	.asg	6,T
	.word	R_M+P_M,T, R_M,T, R_M+P_M,T, R_M,T
	.word	R_M+P_M,T, R_M,T, R_M+P_M,T, R_M,T
	.word	R_M+P_M,T, R_M,T, R_M+P_M,2
	.word	0,10
	DS_END

#hhp3pd	;Punch*3, piledriver
	.asg	6,T
	.word	R_M+P_M,T, R_M,T, R_M+P_M,T, R_M,T
	.word	R_M+P_M,T, R_M,T, R_M+P_M,T, R_M,T+5
	.word	D_M+SP_M,2
	.word	0,10
	DS_END

#hhsk3pd ;Knee*3, piledriver
	.asg	6,T
	.word	R_M+SK_M,T, R_M,T, R_M+SK_M,T, R_M,T
	.word	R_M+SK_M,T, R_M,T, R_M+SK_M,T, R_M,T
	.word	SP_M,2
	.word	0,10
	DS_END

#j2p	.word	L_M+D_M,2
#jp	.word	D_M,2, D_M+R_M,2, R_M,2, P_M,0
#j2sp	.word	L_M+D_M,2
#jsp	.word	D_M,2, D_M+R_M,2, R_M,2, SP_M,0
#jk	.word	D_M,2, D_M+R_M,2, R_M,2, K_M,0
#jkk	.word	D_M,2, D_M+R_M,2, R_M,2, K_M,4
	.word	0,4, K_M,4, 0,4, K_M,4
	.word	0,4, K_M,4, 0,4, K_M,0
#jisp	.word	U_M,2, U_M+R_M,2, R_M,2, SP_M,0

#jpx	.word	D_M,2, D_M+R_M,2, R_M,2, P_M,0
	DS_RNDA	sklrep_t
;FIX - chk
	.word	P_M,4, 0,4, P_M,4, 0,4, P_M,0

	;Reversals

#uddsk
	.word	U_M,2, D_M,2, 0,2, D_M,2, SK_M,0

#uddskk	;Face slam/Pile drv
	.word	U_M,2, D_M,2, 0,2, D_M,2, SK_M,2
	DS_RNDA	sklrep_t
	.word	0,8
	.word	K_M,4, 0,4, K_M,4, 0,4, K_M,4, 0,4	;Repeat
	DS_RNDA	sklrep_t
	.word	K_M,4, 0,4, K_M,4, 0,4, K_M,4, 0,4
	.word	K_M,4, 0,4, K_M,4, 0,4, K_M,0

#uddsksp ;Repeat SP
	.word	U_M,2, D_M,2, 0,2, D_M,2, SK_M,2
	DS_RNDA	sklrep_t
	.word	SP_M,4, 0,4, SP_M,4, 0,4, SP_M,0
#lrrp
	.word	L_M,2, R_M,2, 0,2, R_M,2, P_M,0
#lrrsp
	.word	L_M,2, R_M,2, 0,2, R_M,2, SP_M,0
#lrrk
	.word	L_M,2, R_M,2, 0,2, R_M,2, K_M,0
#spsk2
	.word	SP_M,2, SK_M,2, SP_M,2, SK_M,0


********************************

bret_l_t
raz_l_t
utak_l_t
yoko_l_t
shawn_l_t
bam_l_t
doink_l_t
lex_l_t
	BBL	-1,MODE_ONGROUND,#mdog
	WL	-1,#mdn
#mdn
;	.word	1-1
;	.long	drn_climbtb
	.word	4-1
	.long	drn_seek
	.long	#run
	.long	drn_climbtb
	.long	drn_taunt
#mdog
	.word	3-1
	.long	drn_seek
	.long	drn_seek
	.long	#run


#*******************************

 SUBRP	drone_chrg

	move	*a13(DRN_BUTCHRG),a14
	jrnz	#x			;Already charging?

	movk	20h,a0
	callr	rnd

	move	*a13(WRESTLERNUM),a1
	X64	a1
	addi	#wres_t,a1
	add	a0,a1
	move	*a1,a1,L		;Get * script

	move	*a1+,a0
	move	a0,*a13(DRN_BUTCHRG)
;FIX!-all same
	move	*a1+,a0
	move	a0,*a13(DRN_BUTCHRGDLY)
	move	a1,*a13(DRN_BUTCHRG_p),L

#x
	rets

#wres_t
	.long	#brt,#brt
	.long	#raz,#raz2
	.long	#ut,#ut2
	.long	#yok,#yok
	.long	#shn,#shn2
	.long	#bam,#bam2
	.long	#dnk,#dnk2
	.long	0,0
	.long	#lex,#lex2

#raz
	.word	SP_M,TSEC*2		;Slashes
	DS_JMP	#run
#ut
	.word	P_M,TSEC*2		;Neck breaker
	DS_JMP	#run
#yok
	.word	P_M,TSEC*2		;Salt throw
	DS_CODE
	movk	1,a0
	move	a0,*a13(DRN_MODE)	;Aggressive
	DS_CODEEND
	DS_JMP	#run
#shn
	.word	P_M,TSEC*2		;Suplex
	DS_JMP	#run
#bam
	.word	P_M,TSEC*2		;Fire punch
	DS_CODE
	clr	a0
	move	a0,*a13(DRN_BUTCHRG)	;Fire it
	DS_CODEEND
	.word	0,4
	.word	P_M,4, 0,4, P_M,4, 0,4, P_M,4, 0,4	;Repeat
	DS_RNDA	sklrep_t
	.word	P_M,4, 0,4, P_M,4, 0,4, P_M,4, 0,4
	DS_RNDA	sklrep_t
	.word	P_M,4, 0,4, P_M,4, 0,4, P_M,4, 0,4
	.word	P_M,4, 0,4, P_M,4, 0,4, P_M,0
#bam2
	.word	SP_M,TSEC*2		;Neck brkr
	DS_JMP	#run
#dnk
	.word	P_M,TSEC*2		;Buzzer
	DS_JMP	#run
#dnk2
	.word	P_M,TSEC*2		;Buzzer (leap)
	.word	R_M,2
	DS_CODE
	clr	a0
	move	a0,*a13(DRN_BUTCHRG)	;Fire it
	DS_CODEEND
	.word	R_M,2			;Need?
	DS_END
#lex
	.word	P_M,TSEC*2		;Smash
	DS_JMP	#run
#lex2
#brt
#raz2
#ut2
#shn2
	.word	SK_M,TSEC*2		;Flying kick
;	DS_JMP	#run

#run
	DS_CALL	drone_chkrun
	.word	P_M+K_M,0		;Run & end
	DS_CODE

	move	*a13(OBJ_XPOSINT),a0
	move	*a8(OBJ_XPOSINT),a14
	sub	a14,a0
	abs	a0
	cmpi	150,a0
	jrge	#rx			;X too far?

	move	*a13(OBJ_ZPOSINT),a1
	move	*a8(OBJ_ZPOSINT),a14
	sub	a14,a1
	abs	a1
	cmpi	40,a1
	jrge	#rx			;Z too far?

	clr	a0
	move	a0,*a13(DRN_BUTCHRG)	;Fire it
#rx
	DS_CODEEND
	DS_END



#*******************************

 SUBRP	drn_combo

	DS_CODE

	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	#wres_t,a0
	move	a9,a1
	move	*a0,a9,L		;Get * script
	jump	a1			;Ret

#wres_t
	.long	#brt,#raz,#ut,#yok
	.long	#shn,#bam,#dnk,#dnk,#lex
#brt
	.word	R_M,2, 0,2, R_M,2, 0,2
	DS_RJMP	50,#brt2
	.word	P_M,2
	DS_JMP	#cstrt
#brt2
	.word	SK_M,2
	DS_JMP	#cstrt

#raz
	.word	R_M,2, 0,2, R_M,2, 0,2
	DS_RJMP	50,#raz2
	.word	SP_M,2
	DS_JMP	#cstrt
#raz2
	.word	K_M,2
	DS_JMP	#cstrt

#ut
	.word	R_M,2, 0,2, R_M,2, 0,2
	DS_RJMP	50,#ut2
	.word	SK_M,2
	DS_JMP	#cstrt
#ut2
	.word	K_M,2
	DS_JMP	#cstrt

#yok
	.word	R_M,2, 0,2, R_M,2, 0,2
	DS_RJMP	50,#yok2
	.word	SP_M,2
	DS_JMP	#cstrt
#yok2
	.word	P_M,2
	DS_JMP	#cstrt

#shn
	.word	R_M,2, 0,2, R_M,2, 0,2
	DS_RJMP	50,#shn2
	.word	P_M,2
	DS_JMP	#cstrt
#shn2
	.word	K_M,2
	DS_JMP	#cstrt

#bam
	.word	R_M,2, 0,2, R_M,2, 0,2
	DS_RJMP	50,#bam2
	.word	SP_M,2
	DS_JMP	#cstrt
#bam2
	.word	P_M,2
	DS_JMP	#cstrt

#dnk
	.word	R_M,2, 0,2, R_M,2, 0,2
	DS_RJMP	50,#dnk2
	.word	SP_M,2
	DS_JMP	#cstrt
#dnk2
	.word	SK_M,2
	DS_JMP	#cstrt

#lex
	.word	R_M,2, 0,2, R_M,2, 0,2
	DS_RJMP	50,#lex2
	.word	SK_M,2
	DS_JMP	#cstrt
#lex2
	.word	K_M,2
	DS_JMP	#cstrt

	.asg	6,T
#cstrt
	.word	0,2
	DS_RJMP	25,#csk
	DS_RJMP	25,#cp
	DS_RJMP	25,#ck
#csp
	.word	SP_M,T, 0,T, SP_M,T, 0,T
	.word	SP_M,T, 0,T, SP_M,T, 0,T
	DS_RNDA	sklrep_t
	DS_JMP	#cstrt
#csk
	.word	SK_M,T, 0,T, SK_M,T, 0,T
	.word	SK_M,T, 0,T, SK_M,T, 0,T
	DS_RNDA	sklrep_t
	DS_JMP	#cstrt
#cp
	.word	P_M,T, 0,T, P_M,T, 0,T
	.word	P_M,T, 0,T, P_M,T, 0,T
	DS_RNDA	sklrep_t
	DS_JMP	#cstrt
#ck
	.word	K_M,T, 0,T, K_M,T, 0,T
	.word	K_M,T, 0,T, K_M,T, 0,T
	DS_RNDA	sklrep_t
	DS_JMP	#cstrt



#*******************************

#lp
	DS_CODEEND
	DS_SLP1

 SUBRP	drn_seek

	DS_CODE

	move	b6,a0
	jrz	#skok
	subk	MODE_BLOCK,a0
	jrne	#x
#skok
	movi	3fh,a0
	callr	rnd
	jrz	#x
	callr	drone_seek
	jrnz	#lp
#x
	DS_CODEEND
	DS_END


#*******************************
* Get real close

#lp
	DS_CODEEND
	DS_SLP1

 SUBRP	drn_seekclose

	DS_CODE

	move	b6,a0
	jrz	#skok
	subk	MODE_BLOCK,a0
	jrne	#x
#skok
	movi	3fh,a0
	callr	rnd
	jrz	#x

	move	*a13(OBJ_XPOSINT),a14
	movk	32,a2
	move	*a8(OBJ_XPOSINT),a0
	cmp	a0,a14
	jrge	#torgt
	neg	a2
#torgt
	add	a2,a0

	move	*a8(OBJ_ZPOSINT),a1
	movk	23,a2
	callr	drone_seekxz
	jrnz	#lp
#x
	DS_CODEEND
	DS_END


#*******************************

 SUBRP	drn_retreat

	DS_CODE
	movk	4,a0			;Far
	move	a0,*a13(DRN_SEEKDIST)
#lp
	callr	drone_seekdirdist
	DS_CODEEND
	DS_SLP1
	DS_CODE
	movk	1fh,a0
	callr	rnd
	jrnz	#lp

	DS_CODEEND
	DS_END


#*******************************
* Check if running would be OK
* A9+32 if bad

 SUBRP	drone_chkrun

	move	*a13(OBJ_XPOSINT),a0
	move	*a13(OBJ_ZPOSINT),a1

	move	*a13(FACING_DIR),a2

	move	*a13(INRING),a14
	jrnz	#out			;Out of ring?

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	cmpi	MODE_ONGROUND,b7
	jreq	#x
;	subk	MODE_INAIR2,a14
;	jreq	#x			;Jumping on me?

	move	*a13(CLOSEST_ZDIST),a1
	cmpi	70,a1
	jrge	#x			;Z far enough?

	subk	30,a1
	jrle	#x			;Z close enough?

	move	*a13(CLOSEST_XDIST),a0
	cmpi	150,a0
	jrge	#x			;X far enough?

;	btst	PLAYER_RIGHT_BIT,a2
;	jrz	#l			;Facing left?

	jruc	#bad

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

#out
	btst	PLAYER_RIGHT_BIT,a2
	jrz	#ol			;Facing left?

	cmpi	RING_X_CENTER+500,a0
	jrge	#bad			;Hit rgt crowd?

	cmpi	RING_TOP-10,a1
	jrlt	#rrok
	cmpi	RING_BOT+10,a1
	jrgt	#rrok
	cmpi	RING_X_CENTER,a0
	jrge	#rrok
	cmpi	RING_X_CENTER-300,a0
	jrge	#bad			;Hit rgt ring?
#rrok
	jruc	#x
#ol
	cmpi	RING_X_CENTER-500,a0
	jrle	#bad			;Hit lft crowd?

	cmpi	RING_TOP-10,a1
	jrlt	#lrok
	cmpi	RING_BOT+10,a1
	jrgt	#lrok
	cmpi	RING_X_CENTER,a0
	jrle	#lrok
	cmpi	RING_X_CENTER+300,a0
	jrle	#bad			;Hit lft ring?
#lrok
;FIX!
	jruc	#x

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

#bad
	addk	32,a9			;Skip script run buttons

#x
	rets


#*******************************
* Control runner

#rsk
	movk	10,a2
	callr	drone_seek2
	andni	MOVE_LEFT+MOVE_RIGHT,a0		;0 lft & rgt
	move	a0,*a13(DRN_JOY)
	DS_CODEEND
	DS_SLP1

 SUBRP	drn_run

	DS_CODE
	move	b6,a0
	subk	MODE_RUNNING,a0
	jreq	#mdok
	subk	MODE_BOUNCING-MODE_RUNNING,a0
	jrne	#abrt
#mdok
	movi	01ffh,a0		;9.6 sec
	callr	rnd
	jrz	#brkrun			;Breakout?

	move	*a13(OBJ_XVEL+16),a4
	sll	3,a4			;*8
	move	*a8(OBJ_XVEL+16),a1
	sll	5,a1			;*32

	move	*a8(OBJ_XPOSINT),a0
	add	a1,a0
	move	*a13(OBJ_XPOSINT),a1
	add	a4,a1
	move	a1,a3
	sub	a1,a0
	move	a4,a1
	xor	a0,a1
	abs	a0

	move	*a13(CLOSEST_ZDIST),a2

	move	*a13(INRING),a14
	jrz	#inr			;In ring?

	cmpi	300,a0
	jrgt	#ering			;Too far?

	move	a1,a1
	jrn	#brkrun			;Running away?

	subk	30,a2
	jrgt	#brkseek		;Too far?

	jruc	#cont

#inr
	move	a4,a4
	jrn	#lrp			;Towards L rope?

	cmpi	RING_X_CENTER+210,a3
	jrlt	#rpok			;Won't hit R rope?
	jruc	#chkopp
#lrp
	cmpi	RING_X_CENTER-210,a3
	jrgt	#rpok			;Won't hit L rope?
#chkopp
	move	*a8(GETUP_TIME),a14
	jrgt	#rpok			;Out of control?

	cmpi	MODE_ONGROUND,b7
	jreq	#rpok

	cmpi	300,a0
	jrgt	#rpok			;Opp X far?

	cmpi	MODE_RUNNING,b7
	jreq	#oprun

	cmpi	180,a0
	jrgt	#rpok			;Opp X far?
#oprun
	cmpi	90,a2
	jrlt	#brkrun			;Opp Z close?

#rpok

	move	a1,a1
	jrn	#rsk			;Running away?
#cont
	cmpi	MODE_INAIR2,b7
	jreq	#brkrun


	subk	30,a2
	jrgt	#rsk			;Z too far?

	cmpi	250,a0
	jrgt	#rsk			;X too far?

	move	a0,a2

	movi	120,a0
	callr	rndrng0
	addi	130,a0

	cmp	a0,a2
	jrgt	#rsk			;X too far?


;	movk	3,a0
;	callr	rnd
;	jrz	#igpup			;25% ignore?

	move	b7,a0
	subk	MODE_PUPPET2,a0
	jreq	#brkrun
	subk	MODE_PUPPET-MODE_PUPPET2,a0
	jreq	#brkrun
	cmpi	MODE_HEADHELD,b7
	jreq	#brkrun
	cmpi	MODE_HEADHOLD,b7
	jreq	#brkrun
	cmpi	MODE_ATTACHED,b7
	jreq	#brkrun
;#igpup

	move	*a13(DRN_BUTCHRG),a0
	jrz	#nchrg
	move	*a13(DRN_BUTCHRGDLY),a0
	jrgt	#nchrg
	clr	a0
	move	a0,*a13(DRN_BUTCHRG)	;Fire it
	jruc	#abrt
#nchrg
	DS_CODEEND
	DS_RJMP	33,#k
	DS_RJMP	33,#sk
	.word	SP_M,0
#k	.word	K_M,0
#sk	.word	SK_M,0

#abrt
	DS_CODEEND
	DS_END

#brkrun
	DS_CODEEND
	.word	L_M,0

#ering
	DS_CODEEND
	.word	L_M,2
	DS_JMP	drn_enterring

#brkseek
	DS_CODEEND
	.word	L_M,2
	DS_JMP	drn_seek



#*******************************
* Opponent running

 SUBRP	drn_oprun

	DS_CODE

	movk	7,a0
	callr	rnd
	jrnz	#abrt			;Skip?

	move	*a8(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
;	move	a1,a3
	sub	a1,a0
	move	*a8(OBJ_XVEL+16),a1
;	move	a1,a4
	xor	a0,a1
	abs	a0

	move	*a13(CLOSEST_ZDIST),a2
	cmp	a0,a2
	jrgt	#abrt			;Z dist > X dist?

	move	a1,a1
	jrn	#run			;Running away?

	move	*a8(GETUP_TIME),a14
	jrgt	#run			;Out of control?

#abrt
	DS_CODEEND
	DS_END

#run
	DS_CODEEND
	.word	P_M+K_M,0	;Run



#*******************************

 SUBRP	drn_roll

	DS_CODE
	callr	drone_chrg

	jruc	#strt

#lp
	DS_CODEEND
	DS_SLP1
	DS_CODE
#strt
	cmpi	MODE_ONGROUND,b6
	jrne	#x

	move	*a13(CLOSEST_XDIST),a0
	cmpi	150,a0
	jrgt	#x			;Safe dist?

	move	*a13(CLOSEST_ZDIST),a0
	cmpi	70,a0
	jrgt	#x			;Safe dist?

	clr	a2
	callr	drone_seek2
	jrz	#x

	movk	3,a1			;Flip up & down
	xor	a1,a0
	move	a0,*a13(DRN_JOY)

	movi	7fh,a0
	callr	rnd
	jrnz	#lp

#x
	DS_CODEEND
	.word	B_M,TSEC-10		;Block while standing
	DS_END


#*******************************
* Climb closest turnbuckle

 SUBRP	drn_climbtb

	DS_CODE
	move	b3,a0
	subk	1,a0
	jrle	#lp			;Only 1 on team?

	movk	1,a0
	callr	rnd
	jrnz	#x			;Skip 50%?

#lp
	DS_CODEEND
	DS_SLP1

 SUBRP	drn_ontb

	DS_CODE

	move	b7,a2

	cmpi	MODE_ONTURNBKL,b6
	jrne	#not

	subk	MODE_ONTURNBKL,a2
	jreq	#dn			;He's up, so get dn?

	jruc	#jmp

#not
	move	*a13(INRING),a0
	jrnz	#ering			;!In ring?

	move	*a13(WRESTLERNUM),a0
	subk	3,a0
	jrne	#ny			;!Yoko?
	move	*a8(INRING),a0
	jrnz	#x			;!In ring?
#ny
	subk	MODE_ONTURNBKL,a2
	jreq	#x
	subk	MODE_INAIR2-MODE_ONTURNBKL,a2
	jreq	#x

	movi	RING_X_CENTER-225,a0
	move	*a13(OBJ_XPOSINT),a1
	cmpi	RING_X_CENTER,a1
	jrle	#lrp
	movi	RING_X_CENTER+225,a0
#lrp
	move	a0,a3
	movi	RING_TOP,a1
	movk	32,a2
	callr	drone_seekxz		;Seek to visinity
	jrnz	#nclose

	move	a3,a0
	movi	RING_TOP-10,a1
	clr	a2
	callr	drone_seekxz		;Push into turnbuckle

#nclose
	move	*a13(CLOSEST_XDIST),a0
	cmpi	120,a0
	jrgt	#lp			;Safe dist?

	move	*a13(CLOSEST_ZDIST),a0
	cmpi	70,a0
	jrgt	#lp			;Safe dist?

#x
	DS_CODEEND
	DS_END

#jmp
	clr	a6			;So we get dn transition
	DS_CODEEND
	.word	K_M,0
#dn
	DS_CODEEND
	.word	D_M,0
#ering
	DS_CODEEND
	DS_JMP	drn_enterring


#*******************************
* I'm in air

#lp
	DS_CODEEND
	DS_SLP1

 SUBRP	drn_inair

	DS_CODE
	clr	a2
	callr	drone_seek2

	cmpi	MODE_INAIR2,b6
	jreq	#lp

	DS_CODEEND
	DS_END


#*******************************
* Opponent in air

 SUBRP	drn_opinair

	DS_CODE

	movk	1,a0
	callr	rnd
	jrnz	#run			;Skip?
#lp
	cmpi	MODE_INAIR2,b7
	jrne	#k

	DS_CODEEND
	DS_SLP1
	DS_CODE

	move	*a13(CLOSEST_XDIST),a1
	move	*a13(CLOSEST_ZDIST),a14
	cmp	a1,a14
	jrge	#big
	move	a1,a14
#big
	cmpi	150,a14
	jrgt	#lp			;Opp far?
#k
	DS_CODEEND
	.word	K_M,0			;Jump up

#run
	DS_CODEEND
	.word	L_M+P_M+K_M,2	;Run away
	DS_END



#*******************************
* Enter ring at closest entry point

#lp
	DS_CODEEND
	DS_SLP1

 SUBRP	drn_enterring

	DS_CODE

	move	*a8(INRING),a0
	jrnz	#x			;Opp out?

	move	*a13(INRING),a0
	jrz	#x			;In ring?

	move	*a13(OBJ_XPOSINT),a14

	movi	RING_Z_CENTER,a1
	movi	RING_X_CENTER-260,a0
	cmp	a0,a14
	jrle	#sk
	movi	RING_X_CENTER+260,a0
	cmp	a0,a14
	jrge	#sk

	move	*a13(OBJ_ZPOSINT),a14

	movi	RING_X_CENTER,a0
	movi	RING_TOP-10,a1
	cmp	a1,a14
	jrle	#sk
	movi	RING_BOT+10,a1
#sk
	movk	10,a2
	callr	drone_seekxz		;Seek to visinity
	jrnz	#lp

	DS_CODEEND
	.word	P_M+SP_M+K_M+SK_M+B_M,0	;Enter

#x
	DS_CODEEND
	DS_END


#*******************************

 SUBRP	drn_taunt

	DS_CODE

	move	*a8(OBJ_ZPOSINT),a0
	move	*a13(OBJ_ZPOSINT),a1
	sub	a1,a0
	cmpi	100,a0
	jrlt	#x

	move	*a8(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	sub	a1,a0
	abs	a0
	cmpi	300,a0
	jrgt	#x

;Time to execute high-risk move!
	movi	8000h+6*60,a0
	move	a0,*a13(RISK)

	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	#taunt_t,a0
	move	*a0,a0,L
	calla	change_anim1a
#x
	DS_CODEEND
	DS_END


#taunt_t
	.long	hrt_4_taunt_anim		;0 Bret Hart
	.long	rzr_4_taunt_anim		;1 Razor Ramon
	.long	und_4_taunt_anim		;2 Undertaker
	.long	yok_4_taunt_anim		;3 Yokozuna
	.long	shn_4_taunt_anim		;4 Shawn Michaels
	.long	bam_4_taunt_anim		;5 Bam Bam
	.long	dnk_4_taunt_anim		;6 Doink
	.long	0		  		;7 spare
	.long	lex_4_taunt_anim		;8 Lex Luger


#*******************************

 SUBRP	drn_oppdead

	DS_CODE
#lp
	clr	a0			;Close
	move	a0,*a13(DRN_SEEKDIR)
	move	a0,*a13(DRN_SEEKDIST)

	callr	drone_seekdirdist
	DS_CODEEND
	DS_SLP1
	DS_CODE

	movk	32,a1
	move	*a13(WRESTLERNUM),a0
	subk	2,a0
	jreq	#ut			;Undertaker?
	movi	90,a1
#ut
	move	*a13(CLOSEST_DIST),a0
	cmp	a1,a0
	jrle	#x
;	jruc	#notut

	move	*a8(ANIMODE),a0		;Let ut walk through dead opps
	ori	MODE_OVERLAP,a0
	move	a0,*a8(ANIMODE)
#notut

	move	*a13(DRN_JOY),a0
	jrnz	#lp
#x
	DS_CODEEND
	.word	P_M,0



#*******************************
* Push stick to move drone towards his opp dir/dist seek position
* A7 = Old joy bits
* A8 = *Closest opp proc
* Trashes scratch, A2-A5

 SUBRP	drone_seekdirdist

	move	*a13(DRN_SEEKDIR),a4	;0-f
	move	*a13(DRN_SEEKDIST),a3	;0-4
	move	a3,a0
	X16	a3
	X4	a0
	add	a0,a3			;*20

	move	a4,a2
	callr	#drn_getxz
	jrnz	#ok

	movk	7,b0
	move	a4,a5
#lp
	addk	1,a4
	sll	32-4,a4
	srl	32-4,a4
	move	a4,a2
	callr	#drn_getxz
	jrnz	#newok

	subk	1,a5
	sll	32-4,a5
	srl	32-4,a5
	move	a5,a2
	callr	#drn_getxz
	jrnz	#new5ok

	dsj	b0,#lp

	clr	a0
	move	a0,*a13(DRN_JOY)

	rets

#new5ok
	move	a5,a4
#newok
	move	a4,*a13(DRN_SEEKDIR)
#ok
	movk	30,a2
	callr	drone_seekxz
	jrnz	#x

	move	*a13(DRN_MODE),a0
	addk	1,a0
	jrge	#x			;Was -1? Skip dir change

	move	a7,*a13(DRN_JOY)	;Restore to lessen glitch

	movk	3,a0			;>Get rnd +-2/3
	callr	rnd
	subk	1,a0
	jrnz	#rnz
	subk	2,a0			;0 into -2
#rnz
	addk	1,a0
	jrgt	#rpos
	subk	2,a0
#rpos

	add	a0,a4
	sll	32-4,a4
	srl	32-4,a4
	move	a4,*a13(DRN_SEEKDIR)

#x
	rets


#drn_getxz
	add	a3,a2
	X16	a2
	addi	#sine_t,a2

	move	*a2(4*16),a14
	move	*a8(OBJ_XPOSINT),a0
	add	a14,a0

	cmpi	RING_X_CENTER-220,a0
	jrlt	#xzbad
	cmpi	RING_X_CENTER+220,a0
	jrgt	#xzbad

	move	*a2,a14
	move	*a8(OBJ_ZPOSINT),a1
	add	a14,a1

	cmpi	RING_TOP,a1
	jrlt	#xzbad
	cmpi	RING_BOT,a1
	jrle	#xzok
#xzbad
	clr	a2			;Set Z
#xzok
	move	a2,a2
	rets

#sine_t
	.word	-50,-46,-35,-19
	.word	0,19,35,46,50,46,35,19
	.word	0,-19,-35,-46,-50,-46,-35,-19

	.word	-100,-92,-71,-38
	.word	0,38,71,92,100,92,71,38
	.word	0,-38,-71,-92,-100,-92,-71,-38

	.word	-150,-139,-106,-57
	.word	0,57,106,139,150,139,106,57
	.word	0,-57,-106,-139,-150,-139,-106,-57

	.word	-200,-185,-141,-76
	.word	0,76,141,185,200,185,141,76
	.word	0,-76,-141,-185,-200,-185,-141,-76

	.word	-250,-231,-177,-95
	.word	0,95,177,231,250,231,177,95
	.word	0,-95,-177,-231,-250,-231,-177,-95

	.word	-300,-277,-212,-115
	.word	0,114,212,277,300,277,212,114
	.word	0,-114,-212,-277,-300,-277,-212,-115


#*******************************
* Push stick to move drone towards closest opp

 SUBRP	drone_seek

	movi	70,a2

 SUBRP	drone_seek2

	move	*a8(OBJ_XPOSINT),a0
	move	*a8(OBJ_ZPOSINT),a1


#*******************************
* Push stick to move drone towards an XZ location
* A0 = X to seek
* A1 = Z
* A2 = Range to stop
* A13= *Plyr proc
*>A0 = Joy bits set or 0 (Pass CC)
* Trashes scratch

 SUBRP	drone_seekxz

	move	a3,b0

	move	*a13(OBJ_XPOSINT),a3
	sub	a0,a3

	clr	a0

	move	a3,a14
	abs	a3
	sub	a2,a3
	jrle	#onx
	move	a14,a14
	jrlt	#nolft
	subk	4,a0			;Left

#nolft	addk	8,a0			;Rgt
#onx
	move	*a13(OBJ_ZPOSINT),a3

	sub	a1,a3
	move	a3,a14
	abs	a3
	sub	a2,a3
	jrle	#onz
	move	a14,a14
	jrlt	#noup
	subk	1,a0			;Up

#noup	addk	2,a0			;Dn
#onz
	move	a0,*a13(DRN_JOY)

	move	b0,a3
	move	a0,a0
	rets


#*******************************
* Adjust drone skill level (called each round)
* 8 is typical starting difficulty
* A13 = *Plyr proc
* Trashes scratch, A2-A5

 SUBR	drone_calcskill

	move	*a13(PLYR_TYPE),a0
	jrz	#x			;Human?

	move	*a13(DRN_SKILLRNDM),a0

	move	@current_round,a3	;1-3
	subk	1,a3
	jrgt	#n1st

	movk	4,a0
	callr	rndrng0
	subk	2,a0
	move	a0,*a13(DRN_SKILLRNDM)
#n1st
	move	@CURRENT_LADDER,a5,L	;* to position
	subi	LADDER,a5
	sra	5,a5			;/32 (Gives 0-6)
	move	a5,a1
	sra	1,a1			;0-3
	add	a1,a5			;A5=0-9
	add	a0,a5			;-2 to 2 randomness

	clr	a4
	move	@PSTATUS,a0
	btst	0,a0
	jrnz	#p1
	movk	16,a4
#p1
	movi	p1winstreakd,a0
	add	a4,a0
	move	*a0,a0
	jrlt	#loser			;Lost? (-2 per match lost)



	X2	a0
;	add	a0,a5			;+1 per match won
;	add	a0,a5			;+1 per match won



	add	a0,a5			;+1 per match won
#loser
	X2	a0
	add	a0,a5			;+2 per match won

;	X2	a0
;	add	a0,a5			;+2 per match won
;#loser
;	X2	a0
;	add	a0,a5			;+4 per match won

	movi	p1rounds,a0
	add	a4,a0
	move	*a0,a0
	add	a0,a5			;+3 per round won
	X2	a0
	add	a0,a5

	X2	a3
	sub	a3,a5			;-2 per round past 1st


	movk	ADJDIFF,a0		;Get difficulty level (1-10)
	calla	GET_ADJ
	subk	2,a0
	X2	a0
	add	a0,a5			;+8 default
	jrge	#minok
	clr	a5
#minok
	cmpi	29,a5
	jrle	#maxok
	movk	29,a5
#maxok
	move	a5,*a13(DRN_SKILL)

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Clr attack count

	clr	a0
	movi	atkcnt_t,a1
	movi	AT_NUM*NUM_WRES,b0
#aclp
	move	a0,*a1+
	dsj	b0,#aclp

#x
	rets



********************************
* Get random # with mask
* A0 = Mask
*>A0 = Rnd # (Pass CC)
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
* Quickly produce a random # in range 0-X
* A0 = X
*>A0 = Random # (0 to A0) (No CC)
* Trashes scratch

 SUBRP	rndrng0

	move	@RAND,a1,L
	rl	a1,a1
	move	@HCOUNT,a14
	rl	a14,a1
	add	sp,a1
	move	a1,@RAND,L

	addk	1,a0
	mpyu	a1,a0		;Condition codes not valid!

	rets






********************************

	.end
