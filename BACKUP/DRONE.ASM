**************************************************************
*
* Software:		Shawn Liptak
* Initiated:		11/21/94
*
* Modified:		Shawn Liptak, 11/21/94	-Started wrestling
*
* COPYRIGHT (C) 1994 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 1/12/95 19:35
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


;sounds external


;symbols externally defined

	.ref	process_ptrs
	.ref	round_tickcount


;symbols defined in this file


;uninitialized ram definitions

	BSSX	droneoff	,16	;!0=Drone code off


;equates for this file


U_M	.equ	MOVE_UP<<5
D_M	.equ	MOVE_DOWN<<5
L_M	.equ	MOVE_LEFT<<5
R_M	.equ	MOVE_RIGHT<<5

P_M	.equ	PLAYER_PUNCH_VAL
B_M	.equ	PLAYER_BLOCK_VAL
SP_M	.equ	PLAYER_SPUNCH_VAL
K_M	.equ	PLAYER_KICK_VAL
SK_M	.equ	PLAYER_SKICK_VAL

	.text

#***************************************************************
* Main drone logic
* A8  = *Obj
* A13 = *Plyr process
* Trashes scratch, A2-A7

 SUBR	drone_main

	.if	DEBUG
	move	@droneoff,a0
	jrnz	#xx
	.endif


	move	*a13(DRN_BUT),a6
	move	*a13(DRN_JOY),a7

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

;	move	*a13(DRN_MODE),a0
;
;	move	*a13(CLOSEST_XDIST),a1
;	cmpi	100,a1
;	jrlt	#ret
;	cmpi	130,a1
;	jrgt	#skdn
;
;	callr	drone_seek
;	jruc	#skdn
;#ret
;	callr	drone_retreat
;#skdn

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Handle getup time

	move	*a13(GETUP_TIME),a0
	jrle	#nogt
	subk	10,a0
	jrge	#gtok
	clr	a0
#gtok	move	a0,*a13(GETUP_TIME)
	jruc	#dsabt
#nogt
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	move	*a13(DRN_DELAY),a0
	subk	1,a0
	jrle	#newact
	move	a0,*a13(DRN_DELAY)
	jruc	#x

#newact
	move	*a13(CLOSEST_XDIST),a0
	cmpi	200,a0
	jrgt	#noatk			;Too far?
	move	*a13(CLOSEST_NUM),a14
	X32	a14
	addi	process_ptrs,a14
	move	*a14,a14,L

	move	*a14(ATTACK_TIME),a0
	move	@round_tickcount,a1
;	move	*a14(DRN_ATKSTRTTIME),a0
;	move	@PCNT,a1
	sub	a1,a0
	jrlt	#noatk

	cmpi	500,a0
	jrge	#noatk			;Overflow?

	move	*a14(GETUP_TIME),a0
	jrgt	#noatk			;Out of control?

	movi	B_M,a0			;Block it
	move	a0,*a13(DRN_BUT)
	jruc	#x
#noatk

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	move	*a13(DRN_ACT_p),a5,L
	jrnz	#cact

	clr	a0
	move	a0,*a13(DRN_BUT)

;DEBUG
;	jruc	#x

	move	*a13(PLYRMODE),a2	;A2=My mode
	cmpi	MODE_HEADHELD,a2
	jreq	#hh

	move	*a13(ANIMODE),a0
	btst	MODE_UNINT_BIT,a0
	jrnz	#unint			;Wait?
#hh
	move	*a13(WRESTLERNUM),a0
	X32	a0
	addi	#wnshort_t,a0

	move	*a13(CLOSEST_XDIST),a1
	move	*a13(CLOSEST_ZDIST),a14
	cmp	a1,a14
	jrge	#havebig
	move	a1,a14
#havebig
	cmpi	90,a14
	jrlt	#shrt
	addi	#wnmed_t-#wnshort_t,a0
	cmpi	180,a14
	jrlt	#med
	addi	#wnlong_t-#wnmed_t,a0
#shrt
#med
	move	*a0,a5,L		;Get * mode list

	move	*a13(CLOSEST_NUM),a14
	X32	a14
	addi	process_ptrs,a14
	move	*a14,a14,L
	move	*a14(PLYRMODE),a3
#mdlp
	movb	*a5,a0			;My mode #
	addk	8,a5
	movb	*a5,a14			;His mode #
	addk	8,a5
	move	*a5+,a1,L		;* script * table

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
	move	a1,a5
	move	*a5+,a0			;# entries
	callr	rndrng0
	X32	a0
	add	a0,a5
	move	*a5,a5,L
#cact
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Read script command
#scplp
	move	*a5+,a0
	jrge	#nocd			;No command?

	sll	32-14,a0
	jrc	#dsdone			;Done? (Bit 14)

	srl	32-14,a0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Seek until 0

	subk	1,a0			;#1
	jrne	#nseekt0

	callr	drone_seek
	jrz	#scplp

	subk	16,a5
	jruc	#dsdone
#nseekt0
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	exgpc	a5			;Call function
	jruc	#scplp
#nocd
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Joy & button bits

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

	move	*a5+,a0			;Get delay
	move	a0,*a13(DRN_DELAY)
	jrgt	#dsdone
#dsabt
	clr	a5
#dsdone
	move	a5,*a13(DRN_ACT_p),L

#unint

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Calc ctrl bit transitions
#x
	move	*a13(DRN_BUT),a0
	xor	a0,a6
	move	a6,a1
	and	a0,a6
	move	a6,*a13(DRN_BUTDT)
	andn	a0,a1
	move	a1,*a13(DRN_BUTUT)

	move	*a13(DRN_JOY),a0
	xor	a0,a7
	and	a0,a7
	move	a7,*a13(DRN_JOYDT)

#xx
	rets


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
DS_SLP1	.macro
	.word	0c000h+0
	.endm
DS_SEEKTIL0	.macro
	.word	8000h+1
	.endm
DS_END	.macro
	.word	0,0
	.endm

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

bam_s_t
	BBL	MODE_RUNNING,-1,mdrun
	BBL	MODE_HEADHOLD,-1,#ba_mdhh
	BBL	MODE_HEADHELD,-1,#ba_mdhhe
	BBL	MODE_OPPOVERHEAD,-1,#ba_mdooh
	BBL	-1,MODE_ONGROUND,#mdog
	WL	-1,#ba_mdn
#ba_mdn	;Normal
;	.word	1-1
;	.long	#ba_pkup
	.word	16-1
	.long	retreat
	.long	#blk,#blk
	.long	#blkp,#blkp
	.long	#p,#sp,#k,#sk
	.long	#hg,#hg
	.long	#flng
	.long	#htoss
	.long	#ham		;Karate kick
	.long	#firep		;Fire punch
	.long	#ba_pkup

#firep	.word	SP_M,90, 0,10, SP_M,10, 0,10, SP_M,0
#ba_pkup
	.word	D_M,2, 0,2, D_M,2, K_M,2, 0,0

#ba_mdhh ;Holding head
	.word	2-1
	.long	#hgpogo
	.long	#hgpd

#ba_mdhhe ;Head held
	.word	2-1
	.long	#hgpogo
	.long	#hgpd

#hgpogo	.word	U_M,2, D_M,2, 0,2, D_M,2, SK_M,0

#ba_mdooh ;Holding opp over head
	.word	2-1
	.long	#oohsd
	.long	#oohbb

#oohsd	.word	D_M+P_M,0	;Slam down
#oohbb	.word	D_M+SK_M,0	;Back breaker

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

bret_s_t
raz_s_t
utak_s_t
yoko_s_t
shawn_s_t
doink_s_t
lex_s_t
	BBL	MODE_RUNNING,-1,mdrun
	BBL	MODE_HEADHOLD,-1,#mdhh
	BBL	MODE_HEADHELD,-1,#mdhhe
	BBL	-1,MODE_ONGROUND,#mdog
	WL	-1,#mdn
#mdn	;Normal
	.word	1-1
	.long	#eslap
	.word	16-1
	.long	retreat
	.long	#blk,#blk
	.long	#blkp,#blkp
	.long	#p,#sp,#k,#sk
	.long	#hg,#hg
	.long	#flng
	.long	#htoss
	.long	#ham,#buz
	.long	#eslap,#pbig
	.long	#pkup
#mdog	;Opp on gnd
	.word	7-1
	.long	retreat
	.long	#p,#sp,#k,#sk
	.long	#oghg,#oghg

#mdhh	;Holding head
	.word	5-1
	.long	#hgfs
	.long	#hgpd
	.long	#hgpppk
	.long	#hgp4
	.long	#hgkkkpd
#mdhhe	;Head held
	.word	5-1
	.long	#hgfs
	.long	#hgpd
	.long	#hgpppk
	.long	#hgp4
	.long	#hgkkkpd

mdrun	;Running
	.word	1-1
	.long	drn_run

#blk	.word	B_M,30, 0,0
#blkp	.word	B_M,30, B_M+P_M,0
#p	.word	P_M,0
#sp	.word	SP_M,0
#k	.word	K_M,0
#sk	.word	SK_M,0

#flng	.word	L_M+SP_M,0
#htoss	.word	L_M+P_M,0
#ham	.word	R_M,2, 0,2, R_M,2, SK_M,2, K_M,2
	DS_END
#buz	.word	P_M,20, P_M+K_M,20, P_M,20, P_M+K_M,20, P_M,10, 0,0
#eslap	.word	D_M,2, D_M+R_M,2, R_M,2, P_M,2, 0,10, P_M,10, 0,10, P_M,0
#pbig	.word	P_M,2, 0,2, P_M,2, 0,2, P_M,2, 0,2, P_M,2, 0,2
	.word	P_M,2, 0,2, P_M,2, 0,2, P_M,2, 0,0
#pkup	.word	SP_M+SK_M,0
#hg
	.word	R_M,2, 0,2, R_M,2, 0,2, SP_M,0, R_M,40
	DS_END

#oghg	;Head grab
	.word	D_M,2, SP_M,0

#hgfs	;Face slam
	.word	U_M,2, D_M,2, 0,2, D_M,2, SK_M,2
	.word	0,30
	.word	K_M,2	;Repeat
	DS_END
#hgpd	;Piledriver
	.word	L_M,2, R_M,2, 0,2, R_M,2, SP_M,2
	.word	0,30
	DS_END
#hgpppk	;Punch*3, kick
	.asg	6,T
	.word	R_M+P_M,T, R_M,T, R_M+P_M,T, R_M,T
	.word	R_M+P_M,T, R_M,T, R_M+P_M,T, R_M,T
	.word	R_M+K_M,2
	.word	0,30
	DS_END
#hgp4	;Punch*4
	.asg	6,T
	.word	R_M+P_M,T, R_M,T, R_M+P_M,T, R_M,T
	.word	R_M+P_M,T, R_M,T, R_M+P_M,T, R_M,T
	.word	R_M+P_M,T, R_M,T, R_M+P_M,2
	.word	0,30
	DS_END
#hgkkkpd ;Knee*3, piledriver
	.asg	6,T
	.word	R_M+SK_M,T, R_M,T, R_M+SK_M,T, R_M,T
	.word	R_M+SK_M,T, R_M,T, R_M+SK_M,T, R_M,T
	.word	SP_M,2
	.word	0,30
	DS_END


#*******************************

bret_m_t
raz_m_t
utak_m_t
yoko_m_t
shawn_m_t
bam_m_t
doink_m_t
lex_m_t
	BBL	MODE_RUNNING,-1,mdrun
	BBL	-1,MODE_ONGROUND,#mdog
	WL	-1,#mdn
#mdog
	.word	3-1
	.long	seek
	.long	#seeksp
	.long	#seeksk

#seeksp
	DS_SEEKTIL0
	.word	SP_M,0
#seeksk
	DS_SEEKTIL0
	.word	SK_M,0

#mdn	;Normal
	.word	6-1
	.long	seek
	.long	retreat
	.long	#sp
	.long	#sk
	.long	#ham
	.long	#run

#sp	.word	SP_M,0
#sk	.word	SK_M,0
#ham	.word	R_M,2, 0,2, R_M,2, SK_M,30, K_M,2

#run	.word	P_M+K_M,0



#*******************************

bret_l_t
raz_l_t
utak_l_t
yoko_l_t
shawn_l_t
bam_l_t
doink_l_t
lex_l_t
	BBL	MODE_RUNNING,-1,mdrun
	BBL	-1,MODE_ONGROUND,#mdog
	WL	-1,#mdn
#mdog
	.word	1-1
	.long	seek
#mdn
	.word	2-1
	.long	seek
	.long	#run

#run	.word	P_M+K_M,0

********************************

#sk2	exgpc	a5
	DS_SLP1
seek
	DS_CODE
	movi	3fh,a0
	callr	rnd
	jrz	#x
	callr	drone_seek
	jrnz	#sk2
#x	exgpc	a5
	DS_END

#*******************************

#sk2
	exgpc	a5
	DS_SLP1
retreat
	DS_CODE
	movk	1fh,a0
	callr	rnd
	jrz	#x
	callr	drone_retreat
	jrnz	#sk2
#x	exgpc	a5
	DS_END


#*******************************

#rsk
	movk	10,a2
	callr	drone_seek2
	andni	MOVE_LEFT+MOVE_RIGHT,a0		;0 up & dn
	move	a0,*a13(DRN_JOY)
	exgpc	a5
	DS_SLP1
drn_run
	DS_CODE
	move	*a13(PLYRMODE),a0
	cmpi	MODE_RUNNING,a0
	jrne	#abrt

	move	*a13(CLOSEST_NUM),a14
	X32	a14
	addi	process_ptrs,a14
	move	*a14,a14,L
	move	*a14(OBJ_XPOSINT),a0
	move	*a13(OBJ_XPOSINT),a1
	sub	a1,a0
	move	*a13(OBJ_XVEL+16),a1
	xor	a0,a1
	move	a1,a1
	jrn	#rsk			;Sign different so i'm running away?
	abs	a0
	cmpi	180,a0
	jrgt	#rsk			;Too far?

	move	*a14(OBJ_ZPOSINT),a0
	move	*a13(OBJ_ZPOSINT),a1
	sub	a1,a0
	abs	a0
	subk	30,a0
	jrgt	#rsk			;Too far?

	movk	1,a0
	callr	rnd
	jrnz	#k

	exgpc	a5
	DS_SLP1
	.word	P_M,0
#k
	exgpc	a5
	DS_SLP1
	.word	K_M,0
#abrt
	exgpc	a5
	DS_END


#*******************************
* Push stick to move away from opponent
*>A0 = Joy bits set or 0 (Pass CC)
* Trashes scratch, A2

 SUBRP	drone_retreat

	movk	5,a2
	callr	drone_seek
;	jrnz	#sk2

	X16	a0
	addi	#xchg_t,a0
	move	*a0,a0
	move	a0,*a13(DRN_JOY)

	rets

#xchg_t	.word	0,10b,01b,0
	.word	1000b,1010b,1001b,0
	.word	100b,110b,101b,0
	.word	0,0,0,0


#*******************************
* Push stick to move drone towards his seek position

 SUBRP	drone_seek

	movi	70,a2

 SUBRP	drone_seek2

	move	*a13(CLOSEST_NUM),a14
	X32	a14
	addi	process_ptrs,a14
	move	*a14,a14,L
	move	*a14(OBJ_XPOSINT),a0
	move	*a14(OBJ_ZPOSINT),a1

#*******************************
* Push stick to move drone towards an XZ location
* A0 = X to seek
* A1 = Z
* A2 = Range to stop
* A8 = *Obj
*>A0 = Joy bits set or 0 (Pass CC)
* Trashes scratch

 SUBRP	drone_seekxy

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
* Drone code - defence
* A8=*Obj
* A9=*Plyr secondary data
* A11=*Ctrl bits
* A13=*Plyr process

	NOTINUSE

 SUBRP	drone_defence

	PUSH	a7,a10


	move	@ballpnum,a5
	sll	5,a5
	addi	plyrproc_t,a5
	move	*a5,a5,L		;A5=*Proc of opponent with ball


	calla	drone_getcurskillo
	move	a0,a7			;A7=Ptsdn+skill for indexing (*16)


	clr	a0
	move	a0,*a13(plyr_d_cflgs)

	move	*a13(plyr_d_mode),a14
	jrn	#inmd			;Already in mode?

	subk	1,a0			;-1
	move	a0,*a13(plyr_d_mode)

	move	a7,a14
	addi	#mdsk_t,a14
	move	*a14,a0
	move	a0,a2
	srl	2,a2			;/4

	callr	rndrng0
	addk	1,a0
	add	a2,a0
	move	a0,*a13(plyr_d_seekcnt)

	clr	a0
	move	a0,*a9(pld_d_nastycnt)
#inmd


	movk	2,a10			;>Update nasty mode
	move	@game_time,a14,L

	cmpi	>800,a14
	jrlt	#nasty			;Less than 8 secs?

	move	@gmqrtr,a2
	subk	3,a2
	jrlt	#chkst
	move	*a13(plyr_ptsdown),a1
	addk	3,a1
	jrle	#chkst			;Winning by 3 or more?
	cmpi	>30000,a14
	jrlt	#nasty			;Less than 30 secs?

#chkst	move	@shotimer+16,a14	;Tens
	jrnz	#scok
	move	@shotimer,a14		;Ones
	subk	5,a14
	jrlt	#nasty			;Less than 5 secs?

#scok	move	*a9(pld_d_nastycnt),a10
	jrgt	#naston

	movi	999,a0
	callr	rndrng0

	move	a7,a14
	addi	#nast_t,a14
	move	*a14,a1
	cmp	a1,a0
	jrge	#nonast			;No nasty?

	movi	TSEC,a10

#naston	subk	1,a10
#nasty	move	a10,*a9(pld_d_nastycnt)
#nonast


	move	*a13(plyr_d_seekcnt),a0
	subk	1,a0
	jrgt	#seek

	move	*a13(plyr_num),a2
	XORK	2,a2
	move	a2,a4
	sll	5,a4			;*32
	addi	plyrproc_t,a4
	move	*a4,a4,L
	cmp	a5,a4
	jreq	#guard			;I'm on guy with ball?

	move	*a5(plyr_ohpdist),a0
	cmpi	300,a0
	jrgt	#guard			;Too far to worry about?

	move	*a5(plyr_seqflgs),a0
	btst	DUNK_B,a0
	jrnz	#gbc			;He's dunking?

	move	*a13(plyr_tmproc_p),a3,L
	move	*a3(plyr_seq),a0
	subi	STAGGER_SEQ,a0
	jrls	#tmok
	subk	FLYBACKWB2_SEQ-STAGGER_SEQ,a0
	jrls	#gbc			;Teammates staggered?
#tmok
	move	*a3(plyr_o1dist),a14
	move	*a3(plyr_o1dir),a1
	btst	0,a2
	jrnz	#p1
	move	*a3(plyr_o2dist),a14
	move	*a3(plyr_o2dir),a1
#p1
	move	*a3(plyr_hpdir),a0	;Find dir difference
	sub	a1,a0
	abs	a0
	cmpi	>40,a0
	jrle	#dsml
	subi	>80,a0
	abs	a0
#dsml	subk	28,a0
	jrle	#gbc			;TM not between op and hoop?

	cmpi	160,a14
	jrgt	#gbc			;TM not guarding?
;FIX
	jruc	#guard

#gbc	move	a5,a4			;Guard ball carrier
#guard
	move	*a4(PA8),a2,L		;*Obj

	move	*a2(OXPOS),a0
	move	*a2(OXANI+16),a14
	add	a14,a0			;X
	move	*a2(OZPOS),a1		;Z

	move	*a2(OXVEL),a14,L
	sra	16-4,a14		;16 ticks from now
	add	a14,a0
	move	*a2(OZVEL),a14,L
	sra	16-4,a14		;16 ticks from now
	add	a14,a1

	move	a10,a10
	jrgt	#setseek		;Nasty on?

	move	*a5(plyr_seqflgs),a14
	btst	SHOOT_B,a14
	jrnz	#setseek		;Starting a shot?

	move	*a13(plyr_myhoopx),a2	;>Stay near oplyr between my basket
	movi	CZMID,a3

	add	a0,a2
	sll	1,a0
	add	a2,a0
	sra	2,a0			;/4

	add	a1,a3
	sll	1,a1
	add	a3,a1
	sra	2,a1			;/4
#setseek
	move	a0,*a13(plyr_d_seekx)
	move	a1,*a13(plyr_d_seeky)

	movk	25,a0
	move	*a5(plyr_hpdist),a1
	cmpi	320,a1
	jrge	#seek			;Far from my hoop?


	move	a7,a14
	addi	#skt_t,a14
	move	*a14,a0
	move	a0,a2
	srl	2,a2			;/4
	callr	rndrng0
	add	a2,a0

#seek	move	a0,*a13(plyr_d_seekcnt)

	callr	drone_seek
	move	a0,a2



	move	*a13(plyr_num),a14	;>Get opponents proc
	addk	2,a14
	sll	32-2,a14
	srl	32-2-5,a14		;*32
	addi	plyrproc_t,a14
	move	*a14,a0,L
	move	*a0(plyr_ohpdist),a0
	subk	10,a0
	cmpi	300,a0
	jrlt	#long
	subi	80,a0			;Turbo earlier
#long
	move	*a13(plyr_hpdist),a1
	cmp	a0,a1
	jrlt	#icloser
	addi	BUT3_M,a2		;Turbo
#icloser


	move	*a13(plyr_balldist),a1
	cmpi	35,a1
	jrgt	#psrnd			;!In his face?

	move	a10,a10
	jrgt	#ps			;Nasty on?

#psrnd
	move	a7,a14
	addi	#dist_t,a14
	move	*a14,a0
	cmp	a0,a1
	jrgt	#skipsp			;Ball too far?

	movi	999,a0
	callr	rndrng0

	move	a7,a14
	addi	#ps_t,a14
	move	*a14,a1
	cmp	a1,a0
	jrge	#skipsp			;Skip push?
#ps
	sll	32-4,a2
	srl	32-4,a2
	addk	BUT2_M,a2		;Steal

	movk	1,a0
	callr	rnd
	jrnz	#skipsp			;50%?

	addi	BUT2_M<<8|BUT3_M,a2	;Push
#skipsp


	move	*a13(plyr_balldist),a14	;>Chk if I can block ball
	cmpi	65,a14
	jrge	#noblk

	move	*a5(plyr_jmpcnt),a0
	jrnz	#tryblk			;Plyr with ball is in air?

	move	*a5(plyr_seqflgs),a0
	btst	SHOOT_B,a0
	jrz	#noblk			;!Starting a shot?
	movk	11,a0
	callr	rndrng0
	move	a0,a0
	jrnz	#noblk			;94% ignore?
	jruc	#blk

#tryblk
	move	a10,a10
	jrgt	#blk			;Nasty on?

	movi	99,a0
	callr	rndrng0
	move	a7,a14
	addi	#blk_t,a14
	move	*a14,a1
	cmp	a1,a0
	jrge	#noblk

#blk
	sll	32-4,a2
	srl	32-4,a2
	addk	BUT1_M,a2		;Block
#noblk

	move	a2,*a11

	PULL	a7,a10
	rets


#mdsk_t					;Mode switch max seek time
	.word	50,50,50,50,50		;Up 15-11
	.word	50,50,45,45,40		;10-6
	.word	33,25,22,18,16		;5-1
	.word	14			;Even score
	.word	10,8,6,4,4		;Dn 1-5
	.word	4,3,3,3,2		;6-10
	.word	2,2,2,2,1		;11-15

#nast_t					;% to become nasty
	.word	0,0,0,0,0
	.word	1,1,2,2,2
	.word	3,3,3,4,6
	.word	8
	.word	10,11,12,13,14
	.word	15,17,20,25,26
	.word	27,28,29,30,35
#skt_t					;Max seek time
	.word	60,60,58,55,52
	.word	48,44,40,36,32
	.word	28,24,22,18,16
	.word	15			;Even score
	.word	15,15,14,14,14
	.word	14,14,14,13,13
	.word	13,13,13,12,12

#dist_t					;Max dist to try push/steal
	.word	110,100,100,100,100
	.word	90,90,80,80,80,80
	.word	70,70,60,60,60
	.word	50
	.word	50,50,50,50,50
	.word	50,50,50,50,50
	.word	50,50,50,50,50
#ps_t					;% to push/steal
	.word	1,2,2,2,2
	.word	3,3,3,3,3
	.word	4,4,4,5,5
	.word	6
	.word	6,6,8,10,13
	.word	15,17,18,20,30
	.word	40,60,80,150,250
#blk_t					;% to block
	.word	1,1,2,3,3
	.word	3,3,4,4,5
	.word	6,7,8,10,12
	.word	14
	.word	16,18,20,25,30
	.word	35,40,45,50,50
	.word	50,50,50,50,50

	.endif



#*******************************
* Get the current skill offset
* >A0=Offset (0-30) *16
* Trashes scratch

; SUBRP	drone_getcurskillo
;
;	move	*a13(plyr_ptsdown),a0
;	move	*a13(plyr_d_skill),a14
;	add	a14,a0
;	cmpi	15,a0
;	jrle	#mxdnok
;	movk	15,a0
;#mxdnok	addk	15,a0
;	jrge	#dnok
;	clr	a0
;#dnok	sll	4,a0			;A7=Ptsdn+skill for indexing (*16)
;
;	rets



#*******************************
* Adjust all drone abilities (at every minute dec of game clock)
* A0=Game clock minute count before dec (0-2)
* Trashes scratch

; SUBR	drone2_adjskill
;
;	PUSH	a2,a3,a4,a5,a6
;
;	move	a0,a5
;	subk	2,a5
;	abs	a5
;	move	@gmqrtr,a1
;	cmpi	3,a1
;	jrls	#qok
;	movk	3,a1			;Overtime
;#qok	movk	3,a0
;	mpyu	a0,a1
;	add	a1,a5			;A5=Quarter+minute index (0-11)
;
;
;	movk	ADJDIFF,a0		;Get difficulty level
;	calla	GET_ADJ			;Drone v2 is level 4 & 5
;	subk	4,a0			;-2 to 2
;	move	a0,a6
;	sll	1,a0			;*2
;	add	a0,a6			;A6=Difficulty adj (0 or 3)
;
;	movi	plyrproc_t,a4
;	movk	4,b0
;#lp
;	move	*a4+,a3,L
;
;	move	*a3(plyr_d_skill),a2
;
;	move	*a3(plyr_ptsdown),a14
;	cmpi	15,a14
;	jrle	#mxdnok
;	movk	15,a14
;#mxdnok	addk	15,a14
;	jrge	#dnok
;	clr	a14
;#dnok	sll	4,a14
;	addi	#adj_t,a14
;	move	*a14,a14
;	add	a14,a2
;
;	move	a5,a14			;>Chk quarter minimum
;	sll	3,a14
;	addi	#min_t,a14
;	movb	*a14,a14
;	add	a6,a14
;	cmp	a14,a2
;	jrge	#minok
;	move	a14,a2
;#minok
;	move	*a3(plyr_num),a1
;	XORK	1,a1
;	move	@PSTATUS,a14
;	btst	a1,a14
;	jrnz	#tminok			;Teammate is human?
;
;	move	@team1,a1		;>Chk team minimum
;	cmpi	3,b0
;	jrge	#t1
;	move	@team2,a1
;#t1	movk	12,a0
;	mpyu	a0,a1
;
;	add	a5,a1
;	sll	3,a1			;*8
;	addi	#tdmin_t,a1
;	movb	*a1,a14
;	add	a6,a14
;	cmp	a14,a2
;	jrge	#tminok
;	move	a14,a2
;#tminok
;	move	a2,*a3(plyr_d_skill)
;
;	dsj	b0,#lp
;
;	PULL	a2,a3,a4,a5,a6
;	rets
;
;
;#adj_t	.word	-5,-5,-5,-5,-5
;	.word	-5,-5,-5,-4,-3
;	.word	-2,-1,0,0,0
;	.word	0
;	.word	1,1,2,2,3
;	.word	3,4,4,5,5
;	.word	5,6,6,6,7
;
;#min_t	.byte	-15,-12,-10, -8,-7,-6, -5,-4,-4, -3,-2,-3
;
;TMDIFF	.macro
;	.byte	-10,-9,-8, -7,-6,-5, -4,-4,-3, -2,0,-2
;	.endm
;#tdmin_t
;	TMDIFF						;ATL
;	TMDIFF						;BOST
;	TMDIFF						;CHAR
;	.byte	6,7,8, 9,10,11, 12,12,13, 14,15,14	;CHI (1)
;	.byte	-6,-5,-5, -4,-3,-3, -2,-2,-2, -1,0,-1	;CLEV (10)
;	TMDIFF						;DAL
;	TMDIFF						;DEN
;	.byte	-5,-4,-4, -3,-2,-2, -1,-1,-1, 0,1,0	;DET (9)
;	TMDIFF						;GOLD
;	.byte	-4,-3,-3, -2,-1,-1, 0,0,0, 1,2,1	;HOU (8)
;	.byte	-3,-2,-2, -1,0,0, 1,1,1, 2,3,2		;IND (7)
;	TMDIFF						;LAC
;	.byte	-1,-1,0, 1,1,1, 2,2,2, 3,4,3		;LAL (6)
;	TMDIFF						;MIAMI
;	TMDIFF						;MILW
;	TMDIFF						;MINN
;	TMDIFF						;NJ
;	.byte	1,1,2, 3,3,3, 4,4,4, 5,6,5		;NY (4)
;	TMDIFF						;ORL
;	TMDIFF						;PHIL
;	.byte	4,4,5, 6,6,6, 7,7,7, 8,9,8		;PHX (2)
;	.byte	2,2,3, 4,4,4, 5,5,5, 6,7,6		;PORT (3)
;	TMDIFF						;SAC
;	TMDIFF						;SANANT
;	TMDIFF						;SEA
;	.byte	0,0,1, 2,2,2, 3,3,3, 4,5,4		;UTAH (5)
;	TMDIFF						;WASH
;	.even


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
* Quickly produce a random # in range 0-X
* A0=X
* >A0=Random # (0 to A0) (No CC)
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




	.end
