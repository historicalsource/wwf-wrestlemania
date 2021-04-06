**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		5/18/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"special.asm"
	.title	"general special moves stuff"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"macros.h"
	.include	"mproc.equ"		;Mproc equates
	.include	"display.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"sys.equ"
	.include	"game.equ"
	.include	"plyr.equ"
	.include	"anim.equ"
	.include	"audit.equ"
	.include	"sound.h"
	.include 	"ring.equ"
	.include	"lifebar.h"
	.include	"miscimg.glo"
	.include	"special.equ"

	.include	"fontsimg.glo"
	.include	"bgndtbl.glo"
	.include	"imgtbl.glo"
	.INCLUDE	"SWEAT.EQU"


******************************************************************************
* EXTERNAL REFERENCES

	.ref	BAKMODS,message_palette,triple_sound,HALT,no_debris
	.ref	announce_rnd_winner,pal_set,octopus2,ZERO_BITS,pal_find
	.ref	RNDRNG0,CREATE_DISQUAL,pal_getf,GENERIC_DISPLAY,NUM_OPPS
	.ref	PCNT,RNDPER,print_string_C2,ROLLING_COUNT,RNDRNGS
	.ref	BGND_UD1,process_ptrs,mess_objid,setup_message,osgemd_ascii
	.ref	dufus_msg_on,reduce_bog
	.ref	ring_out_on
	.ref	_switch_addr
	.ref	match_cnt

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

SHOW_DAMAGE_POINTS	equ	0

******************************************************************************
* VARIABLES

	.bss	impact_params	,32*8 * NUM_WRES	;

	BSSX	WHICH_SKIRT_PAL,16

	BSSX	plyr1_objlist,	32	;collideable objects on P1's side
	BSSX	plyr2_objlist,	32	; P2's side
	BSSX	neutral_objlist,32	;neutral collideable
	BSSX	debris_count,	16	;active debris processes

******************************************************************************
* EQUATES FOR THIS FILE

	STRUCTPD
	LONG	ANIM
	LONG	XVAL
	LONG	YVAL
	WORD	ZVAL
	LONG	XVEL
	LONG	YVEL
	WORD	FLAGS
	LONG	PROC
	LONG	PALLET
	LONG	STAR_TBL

#*****************************************************************************
*
* a10=index into offsets table

 SUBR	create_dizzy_proc

	move	*a13(STARS_FLAG),a0
	jrnz	#x

	CREATE0	dizzy_proc
	move	a0,a9
	move	a13,*a9(PROC),L

	movk	1,a0
	move	a0,*a13(STARS_FLAG)

	move	*a13(WRESTLERNUM),a8
	X128	a8
	addi	#dizzy_offsets,a8
	X32	a10
	add	a10,a8
	move	*a8+,a1			;x offset
	move	*a13(OBJ_XPOSINT),a0

	move	*a13(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#no_flip
	neg	a1
#no_flip
	add	a1,a0
	sll	16,a0
	move	a0,*a9(XVAL),L

	movi	Y_SCALE_MULTIPLIER,a0
	move	*a13(OBJ_ZPOSINT),a1
	mpyu	a0,a1
	move	*a13(OBJ_YPOSINT),a0
	move	*a8,a14			;y offset
	add	a14,a0
	sll	16,a0
	sub	a0,a1
	move	a1,*a9(YVAL),L

;	move	*a13(OBJ_PRIORITY),a0
	move	*a13(OBJ_ZPOSINT),a0
	ori	1000h,a0

;The stars for laying on ground guy, appear in front of other guy also!
;No easy solution for this problem...

	inc	a0
	move	a0,*a9(ZVAL)

#x
	rets


;		stand, lying
#dizzy_offsets
;		stand, on stomach, on back,?,?

	.word	6,6dh, 0,0, 0,0, 0,0			;0 Bret Hart
	.word	2,73h, 0,0, 0,0, 0,0			;1 Razor Ramon
	.word	19h,74h, 0,0, 0,0, 0,0			;2 Undertaker
	.word	10,6dh, 0,0, 0,0, 0,0			;3 Yokozuna
	.word	-5,6bh, 0,0, 0,0, 0,0			;4 Shawn Michaels
	.word	5,116, 0,0, 0,0, 0,0			;5 Bam Bam
	.word	7,116, 2eh,30h, 30h,20h, 0,0		;6 Doink
	.word	7,116, 0,0, 0,0, 0,0			;7 Spare
	.word	7,116, 0,0, 0,0, 0,0			;8 Lex Luger
	.word	7,116, 0,0, 0,0, 0,0			;9 Referee


#*****************************************************************************

 SUBRP	dizzy_proc

	move	*a13(PROC),a0,L
	move	*a0(WRESTLERNUM),a0
	X32	a0
	addi	#star_art,a0
	move	*a0,a10,L
	move	a10,*a13(STAR_TBL),L


	move	*a10+,a11		;tick count
	move	*a10+,a2,L		;* image

	move	*a13(XVAL),a0,L		;x val
	move	*a13(YVAL),a1,L		;y val
	move	*a13(ZVAL),a3		;z val
	movi	DMAWNZ|M_3D,a4		;DMA flags
	clr	a5			;OID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ

	move	*a13(PROC),a9,L
#loop
	SLEEPK	1
	move	*a9(STARS_FLAG),a0
	jrz	#die

;If stars are on for grounded opponent, swap ZPOS based on nearest opponent
	move	*a9(PLYRMODE),a0
	cmpi	MODE_ONGROUND,a0
	jrnz	#nock

	move	*a9(NEW_FACING_DIR),a0
	btst	MOVE_UP_BIT,a0
	jrnz	#front
;Stars should be lower Z than wrestlers
	move	*a13(ZVAL),a0		;z val
	subk	1,a0
	move	a0,*a8(OZPOS)
	jruc	#nock
#front
;Stars should be higher Z than wrestlers
	move	*a13(ZVAL),a0		;z val
	addk	1,a0
	move	a0,*a8(OZPOS)

#nock

	dsj	a11,#loop
#cnt
	move	*a10+,a11
	jrnz	#ok

;	movi	#dizzy_anim,a10		;repeat
	move	*a13(STAR_TBL),a10,L

	jruc	#cnt
#ok
	move	*a10+,a0,L
	callr	change_image_local
	jruc	#loop


#die
	calla	DELOBJA8
	DIE


#star_art
	.long	#hdizzy_anim		;0 Bret Hart
	.long	#rdizzy_anim		;1 Razor Ramon
	.long	#udizzy_anim		;2 Undertaker
	.long	#ydizzy_anim		;3 Yokozuna
	.long	#sdizzy_anim		;4 Shawn Michaels
	.long	#bdizzy_anim		;5 Bam Bam
	.long	#ddizzy_anim		;6 Doink
	.long	0			;7 spare
	.long	#ldizzy_anim		;8 Lex Luger
	.long	0			;9 Referee

#hdizzy_anim
	WL	4,STARS01
	WL	4,STARS02
	WL	4,STARS03
	WL	4,STARS04
	WL	4,STARS05
	WL	4,STARS06
	.word	0

#rdizzy_anim
	WL	5,RAZDIZ201
	WL	5,RAZDIZ202
	WL	5,RAZDIZ203
	WL	5,RAZDIZ204
	WL	5,RAZDIZ205
	WL	5,RAZDIZ206
	WL	5,RAZDIZ207
	WL	5,RAZDIZ208
	WL	5,RAZDIZ209
	WL	5,RAZDIZ210
	.word	0

#udizzy_anim
	WL	5,UNDZ01
	WL	5,UNDZ02
	WL	5,UNDZ03
	WL	5,UNDZ04
	WL	5,UNDZ05
	WL	5,UNDZ06
	.word	0

#ydizzy_anim
	WL	5,YKDZ01
	WL	5,YKDZ02
	WL	5,YKDZ03
	WL	5,YKDZ04
	WL	5,YKDZ05
	WL	5,YKDZ06
	WL	5,YKDZ07
	WL	5,YKDZ08
	WL	5,YKDZ09
	.word	0

#sdizzy_anim
	WL	4,SHNDIZ01
	WL	4,SHNDIZ02
	WL	4,SHNDIZ03
	WL	4,SHNDIZ04
	WL	4,SHNDIZ05
	WL	4,SHNDIZ06
	WL	4,SHNDIZ07
	WL	4,SHNDIZ08
	WL	4,SHNDIZ09
	WL	4,SHNDIZ10
	.word	0

#bdizzy_anim
	WL	5,BMDZ01
	WL	5,BMDZ02
	WL	5,BMDZ03
	WL	5,BMDZ04
	WL	5,BMDZ05
	WL	5,BMDZ06
	.word	0

#ddizzy_anim
	WL	4,STARS01
	WL	4,STARS02
	WL	4,STARS03
	WL	4,STARS04
	WL	4,STARS05
	WL	4,STARS06
	.word	0

#ldizzy_anim
	WL	4,STARS01
	WL	4,STARS02
	WL	4,STARS03
	WL	4,STARS04
	WL	4,STARS05
	WL	4,STARS06
	.word	0


#*****************************************************************************

;For Bam fire head butt
;For Taker club to head
 SUBR	create_impact

	;quit if no_debris is set
	move	@no_debris,a14
	jrnz	#rets
	move	@reduce_bog,a14
	jrnz	#rets

	PUSH	a1,a4,a7,a10,a11
	move	*a13(WHOIHIT),a10,L
	move	*a10(WRESTLERNUM),a0
	sll	5,a0
	addi	#offset_t,a0
	move	*a0,a11,L
	CREATE	DEBRIS_PID,#explosions
	CREATE	DEBRIS_PID,#explosions2
	PULL	a1,a4,a7,a10,a11

#rets	rets

#offset_t
	.long	[100,0]		;0	(Bret)
	.long	[108,0]		;1	(Razor)
	.long	[108,0]		;2	(Taker)
	.long	[105,0]		;3	(Yoko)
	.long	[80,0]		;4	(Shawn)
	.long	[105,0]		;5	(Bam Bam)
	.long	[96,0]		;6	(Doink)
	.long	[105,0]		;7	(spare)
	.long	[90,0]		;8	(Lex)

;For Bam fire super kick
;For Taker fire super kick
 SUBR	create_impact2

	;quit if no_debris is set
	move	@no_debris,a14
	jrnz	#rets
	move	@reduce_bog,a14
	jrnz	#rets

	PUSH	a1,a4,a7,a10,a11
	move	*a13(WHOIHIT),a10,L
	movi	[38h,13h],a11
	CREATE	DEBRIS_PID,#explosions
	CREATE	DEBRIS_PID,#explosions2
	PULL	a1,a4,a7,a10,a11

	rets

;For Taker explosion for pin
 SUBR	create_impact5

	;quit if no_debris is set
	move	@no_debris,a14
	jrnz	#rets
	move	@reduce_bog,a14
	jrnz	#rets

	PUSH	a1,a4,a7,a10,a11
	move	*a13(WHOIHIT),a10,L
	movi	[10,1h],a11
	CREATE	DEBRIS_PID,#explosions
	CREATE	DEBRIS_PID,#explosions2
	CREATE	DEBRIS_PID,#explosions2
	PULL	a1,a4,a7,a10,a11

	rets

;For Bam fire punches to head
 SUBR	create_impact3

	;quit if no_debris is set
	move	@no_debris,a14
	jrnz	#rets
	move	@reduce_bog,a14
	jrnz	#rets

	PUSH	a1,a4,a7,a10,a11
	move	*a13(WHOIHIT),a10,L
	movi	[58h,0],a11
	CREATE	DEBRIS_PID,#explosions
	PULL	a1,a4,a7,a10,a11

	rets

;For Yoko salt to face
 SUBR	create_impact_salt

	PUSH	a1,a4,a7,a10,a11
	move	a13,a10
	movi	[38h,0],a11
	CREATE	DEBRIS_PID,explosions_salt
	PULL	a1,a4,a7,a10,a11

	rets

;For Taker uppercut
 SUBR	create_impact4

	;quit if no_debris is set
	move	@no_debris,a14
	jrnz	#rets
	move	@reduce_bog,a14
	jrnz	#rets

	PUSH	a1,a4,a7,a10,a11
	move	*a13(WHOIHIT),a10,L
	movi	[58h,0],a11
	CREATE	DEBRIS_PID,#head_fountain
;Don't allow other debris to come out and bog us down!
	movk	1,a0
	move	a0,@no_debris
	PULL	a1,a4,a7,a10,a11

	rets

;For Bam flying kick to face
 SUBR	create_impact_flykick

	;quit if no_debris is set
	move	@no_debris,a14
	jrnz	#rets
	move	@reduce_bog,a14
	jrnz	#rets

	PUSH	a1,a4,a7,a10,a11
	move	*a13(WHOIHIT),a10,L
	movi	[58h,0],a11
	CREATE	DEBRIS_PID,#head_fountain_kick
;Don't allow other debris to come out and bog us down!
	movk	1,a0
	move	a0,@no_debris
	PULL	a1,a4,a7,a10,a11

	rets

#head_fountain_kick
;For Taker uppercut fountain
	move	*a10(DEBRIS_X),a1
	jrnz	#cont_k

	clr	a0		;okay, a0 IS always zero after a wakeup,
	move	a0,@no_debris	; but it's bad karma to count on it.
	DIE

#cont_k
	CREATE	DEBRIS_PID,impact_proc2
	move	a0,a9

	movi	XPLODE_P,a0
	move	a0,*a9(PALLET),L

	callr	#stuff_it

	SLEEPK	2
	jruc	#head_fountain_kick

#head_fountain
;For Taker uppercut fountain
	move	*a10(DEBRIS_X),a1
	jrnz	#cont

	clr	a0		;okay, a0 IS always zero after a wakeup,
	move	a0,@no_debris	; but it's bad karma to count on it.
	DIE

#cont
	CREATE	DEBRIS_PID,impact_proc2
	move	a0,a9

	movi	BLUEEX_P,a0
	move	a0,*a9(PALLET),L

	callr	#stuff_it

	SLEEPK	2

	jruc	#head_fountain

#stuff_it
	movk	11,a0

	calla	RNDRNG0
	sll	5,a0
	addi	#exp_tbl,a0
	move	*a0,a0,L

	move	a0,*a9(ANIM),L		;animation

	movi	DMAWNZ|M_3D,a4		;DMA flags

	move	*a10(DEBRIS_X),a1
	move	*a10(OBJ_XPOSINT),a0

	move	*a10(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#no_flip2
	neg	a1
	ori	M_FLIPH,a4		;flip image
#no_flip2
	add	a1,a0
	sll	16,a0
	move	a0,*a9(XVAL),L
	move	a4,*a9(FLAGS)		;DMA flags

	movi	Y_SCALE_MULTIPLIER,a0
	move	*a10(OBJ_ZPOSINT),a3
	mpyu	a0,a3
	move	*a10(OBJ_YPOSINT),a0

	move	*A10(DEBRIS_Y),a14
	add	a14,a0
	sll	16,a0
	sub	a0,a3
	move	a3,*a9(YVAL),L

	move	*a10(OBJ_ZPOSINT),a0
	ori	1000h,a0
	move	*a10(INRING),a14
	jrz	#inring2
	cmpi	[015ach,0],a0
	jrgt	#inring2
	subi	[01e5h,0],a0		;below mat
#inring2
	move	a0,a2
	move	@HCOUNT,a1
	btst	0,a1
	jrz	#ok2
	addi	5h,a2
#ok2
	move	a2,*a9(ZVAL)

	movi	20000h,a0
	calla	RNDRNG0
	subi	10000h,a0
	move	a0,*a9(XVEL),L

	movi	20000h,a0
	calla	RNDRNG0
	subi	10000h,a0
	move	a0,*a9(YVEL),L
	rets


;For Yoko salt bucket
 SUBR	create_bucket_salt

	;quit if no_debris is set
	move	@no_debris,a14
	jrnz	#rets
	move	@reduce_bog,a14
	jrnz	#rets

	PUSH	a1,a4,a7,a10,a11
;	move	*a13(WHOIHIT),a10,L

;	movi	[58h,0],a11

	move	a13,a10
	CREATE	DEBRIS_PID,#salt_from_bucket
;Don't allow other debris to come out and bog us down!
;	movk	1,a0
;	move	a0,@no_debris
	PULL	a1,a4,a7,a10,a11

	rets

#salt_from_bucket
;For Taker uppercut fountain
	move	*a10(DEBRIS_X),a1
	jrnz	#conts

	move	a1,@no_debris

	DIE

#conts
	CREATE	DEBRIS_PID,impact_proc2
	move	a0,a9

	movk	3,a0
	calla	RNDRNG0
	sll	5,a0
	addi	#salt_exp_tbl,a0
	move	*a0,a0,L

	move	a0,*a9(ANIM),L		;animation

	movi	SALTTR_P,a0
	move	a0,*a9(PALLET),L

	movi	DMAWNZ|M_3D,a4		;DMA flags

	move	*a10(DEBRIS_X),a1
	move	*a10(OBJ_XPOSINT),a0

	move	*a10(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#no_flip2s
	neg	a1
	ori	M_FLIPH,a4		;flip image
#no_flip2s
	add	a1,a0
	sll	16,a0
	move	a0,*a9(XVAL),L
	move	a4,*a9(FLAGS)		;DMA flags

	movi	Y_SCALE_MULTIPLIER,a0
	move	*a10(OBJ_ZPOSINT),a3
	mpyu	a0,a3
	move	*a10(OBJ_YPOSINT),a0

	move	*A10(DEBRIS_Y),a14
	add	a14,a0
	sll	16,a0
	sub	a0,a3
	move	a3,*a9(YVAL),L

	move	*a10(OBJ_ZPOSINT),a0
	ori	1000h,a0
	move	*a10(INRING),a14
	jrz	#inring2s
	cmpi	[015ach,0],a0
	jrgt	#inring2s
	subi	[01e5h,0],a0		;below mat
#inring2s
	move	a0,a2
	move	@HCOUNT,a1
	btst	0,a1
	jrz	#ok2s
	addi	5h,a2
#ok2s
	move	a2,*a9(ZVAL)


	movi	20000h,a0
	calla	RNDRNG0
	subi	10000h,a0
	move	a0,*a9(XVEL),L

	movi	20000h,a0
	calla	RNDRNG0
	subi	10000h,a0
	move	a0,*a9(YVEL),L

	SLEEPK	2

	jruc	#salt_from_bucket

*****************************************************************************

#explosions2
	SLEEPK	1
#explosions

	;if there's too much debris already, don't do anything.
	move	@debris_count,a14
	cmpi	DEBRIS_MAX,a14
	jrge	#die

	;increment global debris count
	move	@debris_count,a14
	inc	a14
	move	a14,@debris_count

	movx	a11,a0
	move	a0,*a13(PDATA)		;x
	movy	a11,a0
	srl	16,a0
	move	a0,*a13(PDATA+16)	;y

	movk	4,a11
	move	*a10(WHOHITME),a0,L
	MOVE	*A0(COMBO_COUNT),A0
	JRZ	#lp
	movk	1,a11
#lp
	CREATE	DEBRIS_PID,impact_proc
	move	a0,a9

	movk	11,a0
	calla	RNDRNG0
	sll	5,a0
	addi	#exp_tbl,a0
	move	*a0,a0,L

	move	a0,*a9(ANIM),L		;animation

	move	*a10(WHOHITME),a0,L
	move	*a0(WRESTLERNUM),a0
	sll	5,a0
	addi	#pal_t,a0
	move	*a0,a0,L
	move	a0,*a9(PALLET),L

	movi	DMAWNZ|M_3D,a4		;DMA flags

	move	*a13(PDATA),a1		;x

	move	*a10(OBJ_XPOSINT),a0

	move	*a10(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#no_flip
	neg	a1
	ori	M_FLIPH,a4		;flip image
#no_flip
	add	a1,a0
	move	a0,a2

	movi	30,a0
	calla	RNDRNG0
	subi	15,a0
	add	a0,a2

	sll	16,a2
	move	a2,*a9(XVAL),L

	move	a4,*a9(FLAGS)		;DMA flags

	movi	Y_SCALE_MULTIPLIER,a0
	move	*a10(OBJ_ZPOSINT),a3
	mpyu	a0,a3
	move	*a10(OBJ_YPOSINT),a0
	move	*a13(PDATA+16),a14	;y
	add	a14,a0			;<--- get from table

	move	a0,a2

	movi	20,a0
	calla	RNDRNG0
	subi	10,a0
	add	a0,a2

	sll	16,a2
	sub	a2,a3
	move	a3,*a9(YVAL),L

;	movi	>2480,a0

	move	*a10(OBJ_ZPOSINT),a0
	ori	1000h,a0
	move	*a10(INRING),a14
	jrz	#inring
	cmpi	[015ach,0],a0
	jrgt	#inring
	subi	[01e5h,0],a0		;below mat
#inring
	move	a0,a2
	move	@HCOUNT,a1
	btst	0,a1
	jrz	#ok
	addi	5h,a2
#ok
	move	a2,*a9(ZVAL)


;	movi	8000h,a0
;	calla	RNDRNG0
;	subi	4000h,a0
;
;	move	*a10(OBJ_XVEL),a1,L
;	add	a1,a0

	clr	a0
	move	a0,*a9(XVEL),L

	movi	10000h,a0
	calla	RNDRNG0
	subi	8000h,a0

;	move	*a10(OBJ_YVEL),a1,L
;	add	a1,a0

	clr	a0
	move	a0,*a9(YVEL),L

	SLEEPK	4

   	dsj	a11,#lp

	;decrement global debris count
	move	@debris_count,a14
	dec	a14
	move	a14,@debris_count

#die	DIE

#pal_t	.long	XPLODE_P	;0	(Bret)
	.long	XPLODE_P	;1	(Razor)
	.long	BLUEEX_P	;2	(Taker)
	.long	XPLODE_P	;3	(Yoko)
	.long	XPLODE_P	;4	(Shawn)
	.long	XPLODE_P	;5	(Bam Bam)
	.long	XPLODE_P	;6	(Doink)
	.long	XPLODE_P	;7	spare
	.long	XPLODE_P	;8	(Lex)


****************************************************************************
* a11 = * impact parameters

 SUBR	impact_proc2
	move	a10,a9

	callr	begin_ani
#loop0
	SLEEPK	1

	JSRP	special_ani
	jruc	#loop0

*****************************************************************************
* a11 = * impact parameters

 SUBR	impact_proc
	move	a10,a9

	callr	begin_ani
#loop
	SLEEPK	1
	move	*a9(OBJ_XVEL),a0,L
	move	a0,*a8(OXVEL),L

	JSRP	special_ani
	jruc	#loop



;;;* A1=PID, A7=PC, A8,A9,A10,A11 Passed parameters

;	movi	sp_firehit_anim,a10
;	callr	begin_ani
;
;	SLEEPK	1
;	callr	special_ani


;sp_d200_anim
;;Will be damage point value!
;	WL	30,FIREHIT01
;	.word	0
;
;
;sp_firehit_anim
;	WL	4,FIREHIT01
;	WL	4,FIREHIT02
;	WL	4,FIREHIT03
;	WL	4,FIREHIT04
;	.word	0


#exp_tbl
	.long	#sp_explode_a1_anim
	.long	#sp_explode_a2_anim
	.long	#sp_explode_a3_anim
	.long	#sp_explode_a4_anim
	.long	#sp_explode_b1_anim
	.long	#sp_explode_b2_anim
	.long	#sp_explode_b3_anim
	.long	#sp_explode_b4_anim
	.long	#sp_explode_c1_anim
	.long	#sp_explode_c2_anim
	.long	#sp_explode_c3_anim
	.long	#sp_explode_c4_anim

#salt_exp_tbl
	.long	#sp_salt_exp1_anim
	.long	#sp_salt_exp2_anim
	.long	#sp_salt_exp3_anim
	.long	#sp_salt_exp4_anim

#sp_salt_exp1_anim
	WL	4,SALTA01
	WL	4,SALTA02
	WL	4,SALTA03
	WL	4,SALTA04
	WL	4,SALTA05
	WL	4,SALTA06
	WL	4,SALTA07
	WL	4,SALTA08
	WL	4,SALTA09
	WL	4,SALTA10
	.word	0
#sp_salt_exp2_anim
	WL	4,SALTB01
	WL	4,SALTB02
	WL	4,SALTB03
	WL	4,SALTB04
	WL	4,SALTB05
	WL	4,SALTB06
	WL	4,SALTB07
	WL	4,SALTB08
	WL	4,SALTB09
	WL	4,SALTB10
	WL	4,SALTB11
	.word	0
#sp_salt_exp3_anim
	WL	3,SALTA01
	WL	3,SALTA02
	WL	3,SALTA03
	WL	3,SALTA04
	WL	3,SALTA05
	WL	3,SALTA06
	WL	3,SALTA07
	WL	3,SALTA08
	WL	3,SALTA09
	WL	3,SALTA10
	.word	0
#sp_salt_exp4_anim
	WL	3,SALTB01
	WL	3,SALTB02
	WL	3,SALTB03
	WL	3,SALTB04
	WL	3,SALTB05
	WL	3,SALTB06
	WL	3,SALTB07
	WL	3,SALTB08
	WL	3,SALTB09
	WL	3,SALTB10
	WL	3,SALTB11
	.word	0
#sp_explode_a1_anim
	WL	4,XPLODA01
	WL	4,XPLODA03
	WL	4,XPLODA04
	WL	4,XPLODA05
	WL	4,XPLODA06
	WL	4,XPLODA07
	WL	4,XPLODA08
	WL	4,XPLODA09
	WL	4,XPLODA10
	.word	0
#sp_explode_a2_anim
	WL	2,XPLODA01
	WL	2,XPLODA03
	WL	2,XPLODA04
	WL	2,XPLODA05
	WL	2,XPLODA06
	WL	2,XPLODA07
	WL	2,XPLODA08
	WL	2,XPLODA09
	WL	2,XPLODA10
	.word	0
#sp_explode_a3_anim
#sp_explode_a4_anim
	WL	3,XPLODA01
	WL	3,XPLODA03
	WL	3,XPLODA04
	WL	3,XPLODA05
	WL	3,XPLODA06
	WL	3,XPLODA07
	WL	3,XPLODA08
	WL	3,XPLODA09
	WL	3,XPLODA10
	.word	0


#sp_explode_b1_anim
	WL	4,XPLODB01
	WL	4,XPLODB03
	WL	4,XPLODB04
	WL	4,XPLODB05
	WL	4,XPLODB06
	WL	4,XPLODB07
	WL	4,XPLODB08
	WL	4,XPLODB09
	WL	4,XPLODB10
	.word	0
#sp_explode_b2_anim
	WL	2,XPLODB01
	WL	2,XPLODB03
	WL	2,XPLODB04
	WL	2,XPLODB05
	WL	2,XPLODB06
	WL	2,XPLODB07
	WL	2,XPLODB08
	WL	2,XPLODB09
	WL	2,XPLODB10
	.word	0
#sp_explode_b3_anim
#sp_explode_b4_anim
	WL	3,XPLODB01
	WL	3,XPLODB03
	WL	3,XPLODB04
	WL	3,XPLODB05
	WL	3,XPLODB06
	WL	3,XPLODB07
	WL	3,XPLODB08
	WL	3,XPLODB09
	WL	3,XPLODB10
	.word	0

#sp_explode_c1_anim
	WL	4,XPLODC01
	WL	4,XPLODC03
	WL	4,XPLODC04
	WL	4,XPLODC05
	WL	4,XPLODC06
	WL	4,XPLODC07
	WL	4,XPLODC08
	WL	4,XPLODC09
	WL	4,XPLODC10
	.word	0
#sp_explode_c2_anim
	WL	2,XPLODC01
	WL	2,XPLODC03
	WL	2,XPLODC04
	WL	2,XPLODC05
	WL	2,XPLODC06
	WL	2,XPLODC07
	WL	2,XPLODC08
	WL	2,XPLODC09
	WL	2,XPLODC10
	.word	0

#sp_explode_c3_anim
#sp_explode_c4_anim
	WL	3,XPLODC01
	WL	3,XPLODC03
	WL	3,XPLODC04
	WL	3,XPLODC05
	WL	3,XPLODC06
	WL	3,XPLODC07
	WL	3,XPLODC08
	WL	3,XPLODC09
	WL	3,XPLODC10
	.word	0


#*****************************************************************************

explosions_salt

	SLEEPK	5

	movx	a11,a0
	move	a0,*a13(PDATA)		;x
	movy	a11,a0
	srl	16,a0
	move	a0,*a13(PDATA+16)	;y

	movk	6,a11
#lp
	CREATE	DEBRIS_PID,impact_proc
	move	a0,a9

	movk	3,a0
	calla	RNDRNG0
	sll	5,a0
	addi	#salt_exp_tbl,a0
	move	*a0,a0,L

	move	a0,*a9(ANIM),L		;animation

	movi	SMOKE_P,a0
	move	a0,*a9(PALLET),L
	movi	DMAWNZ|M_3D,a4		;DMA flags
	move	*a13(PDATA),a1		;x
	move	*a10(OBJ_XPOSINT),a0
	move	*a10(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#no_flip
	neg	a1
	ori	M_FLIPH,a4		;flip image
#no_flip
	add	a1,a0
	move	a0,a2

	movi	30,a0
	calla	RNDRNG0
	subi	15,a0
	add	a0,a2

	sll	16,a2
	move	a2,*a9(XVAL),L

	move	a4,*a9(FLAGS)		;DMA flags

	movi	Y_SCALE_MULTIPLIER,a0
	move	*a10(OBJ_ZPOSINT),a3
	mpyu	a0,a3
	move	*a10(OBJ_YPOSINT),a0
	move	*a13(PDATA+16),a14	;y
	add	a14,a0			;<--- get from table

	move	a0,a2

	movi	20,a0
	calla	RNDRNG0
	subi	10,a0
	add	a0,a2

	sll	16,a2
	sub	a2,a3
	move	a3,*a9(YVAL),L

;	movi	>2480,a0

	move	*a10(OBJ_ZPOSINT),a0
	ori	1000h,a0
	move	*a10(INRING),a14
	jrz	#inring
	cmpi	[015ach,0],a0
	jrgt	#inring
	subi	[01e5h,0],a0		;below mat
#inring
	move	a0,a2
	move	@HCOUNT,a1
	btst	0,a1
	jrz	#ok
	addi	5h,a2
#ok
	move	a2,*a9(ZVAL)


;	movi	8000h,a0
;	calla	RNDRNG0
;	subi	4000h,a0
;
;	move	*a10(OBJ_XVEL),a1,L
;	add	a1,a0

	clr	a0
	move	a0,*a9(XVEL),L

	movi	10000h,a0
	calla	RNDRNG0
	subi	8000h,a0

;	move	*a10(OBJ_YVEL),a1,L
;	add	a1,a0

	clr	a0
	move	a0,*a9(YVEL),L

	SLEEPK	3

   	dsj	a11,#lp

	DIE

#salt_exp_tbl
	.long	#salt_exp1_anim
	.long	#salt_exp2_anim
	.long	#salt_exp1_anim
	.long	#salt_exp2_anim

#salt_exp1_anim
	WL	4,SMOKE01
	WL	4,SMOKE03
	WL	4,SMOKE04
	WL	4,SMOKE05
	WL	4,SMOKE06
	WL	4,SMOKE07
	WL	4,SMOKE08
	WL	4,SMOKE09
	WL	4,SMOKE10
	.word	0
#salt_exp2_anim
	WL	4,SMOKEB01
	WL	4,SMOKEB03
	WL	4,SMOKEB04
	WL	4,SMOKEB05
	WL	4,SMOKEB06
	WL	4,SMOKEB07
	WL	4,SMOKEB08
	WL	4,SMOKEB09
	WL	4,SMOKEB10
	.word	0
#*****************************************************************************

 SUBRP	begin_ani


	move	*a13(ANIM),a10,L	;* animation
	move	*a13(PALLET),a0,L	;Obj pal
	move	a0,b0

	move	*a13(XVAL),a0,L		;x val
	move	*a13(YVAL),a1,L		;y val
	move	*a13(ZVAL),a3		;z val
	move	*a13(FLAGS),a4		;DMA flags
	clr	a5			;OID
	move	*a13(XVEL),a6,L		;x vel
	move	*a13(YVEL),a7,L		;y vel

	move	*a10+,a11		;tick count
	move	*a10+,a2,L		;* image

	calla	BEGINOBJP

	rets

#*****************************************************************************

 SUBRP	special_ani

	dec	a11
	jrnz	#cont

	move	*a10+,a11		;tick count
	jrz	#die
	move	*a10+,a0,L		;* image

	move	a0,*a8(OIMG),L
	move	*a0(0),*a8(OSIZE),L
	move	*a0(ISAG),*a8(OSAG),L

	move	*a0(IANIOFFX),a1
;;;	add	a10,a1				;add in X ani-offset (if any)
	move	a1,*a8(ODXOFF)			;display x offset

	move	*a0(IANIOFFY),a1
;;;	add	a11,a1				;add in Y pos & ani-offset
	move	a1,*a8(ODYOFF)			;display y offset

	movb	*a0(ICTRL+7),*a8(OCTRL+7)	;Write 5 z comp bits + bits pp
#cont
	RETP



#die
	calla	DELOBJA8
	DIE

#*****************************************************************************
* a0 = * image
* a8 = * object

 SUBRP	change_image_local

	move	a0,*a8(OIMG),L
	move	*a0(0),*a8(OSIZE),L
	move	*a0(ISAG),*a8(OSAG),L

	move	*a0(IANIOFFX),a1
	move	a1,*a8(ODXOFF)			;display x offset

	move	*a0(IANIOFFY),a1
	move	a1,*a8(ODYOFF)			;display y offset

	movb	*a0(ICTRL+7),*a8(OCTRL+7)	;Write 5 z comp bits + bits pp
	rets



#*****************************************************************************

 SUBR	init_special_objlist

	clr	a0
	move	a0,@plyr1_objlist,L
	move	a0,@plyr2_objlist,L
	move	a0,@neutral_objlist,L

	rets


#*****************************************************************************
;
; a0 = * process

insert_special_objlist

	movi	neutral_objlist,a1
	move	*a13(SP_PLYR_SIDE),a14	;( p1=0, p2=1, neutral=-1 )
	jrn	#ok
	movi	plyr1_objlist,a1
	move	a14,a14
	jrz	#ok
	movi	plyr2_objlist,a1
#ok
	move	*a1(0),*a0(SP_NEXT),L	;update next link
	move	a0,*a1,L		;insert at head of list

	rets


#*****************************************************************************
;
; a0 = * process

 SUBR	delete_special_objlist

	movi	neutral_objlist,a1	;prev
	move	*a0(SP_PLYR_SIDE),a14	;( p1=0, p2=1, neutral=-1 )
	jrn	#ok
	movi	plyr1_objlist,a1	;prev
	move	a14,a14
	jrz	#ok
	movi	plyr2_objlist,a1	;prev
#ok


	move	*a1,a2,L		;cur
	jrz	#empty

	cmp	a2,a0
	jrne	#no_match

	move	*a2(SP_NEXT),*a1(0),L	;unlink
	rets

#no_match

	move	a2,a1			;prev
	move	*a2(SP_NEXT),a2,L	;cur
	jrz	#empty

	cmp	a2,a0
	jrne	#no_match

	move	*a2(SP_NEXT),*a1(SP_NEXT),L	;unlink

	rets

#empty
;	.if DEBUG
;	LOCKUP
;	.endif
	rets


#*****************************************************************************

 SUBR	doink_pie

	move	a11,*a13(SP_WRESPROC),L
	move	*a11(PLYR_SIDE),*a13(SP_PLYR_SIDE)

	move	a13,a0
	callr	insert_special_objlist	;insert into collis list

	callr	sp_create_obj
	callr	sp_create_shadow

	move	*a13(SP_OBJ),a8,L

	movi	[86,0],a1
	movi	[6,0],a2		;x-vel
	move	*a11(OBJ_XPOS),a0,L
	move	*a11(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#no_flip

	move	*a13(SP_OBJCONTROL),a14
	ori	M_FLIPH,a14
	move	a14,*a13(SP_OBJCONTROL)

	neg	a1
	neg	a2
#no_flip
	add	a1,a0
	move	a0,*a13(SP_OBJ_XPOS),L
	move	a2,*a13(SP_OBJ_XVEL),L



	move	*a11(OBJ_ZPOS),*a13(SP_OBJ_ZPOS),L

	move	*a11(OBJ_YPOS),a0,L
	addi	[97,0],a0
	move	a0,*a13(SP_OBJ_YPOS),L

	move	*a11(INRING),*a13(SP_INRING)

	move	*a11(GROUND_Y),a0
	sll	16,a0
	move	a0,*a13(SP_GROUND_Y),L

	clr	a0
	move	a0,*a13(SP_GRAVITY),L
	move	a0,*a13(SP_OBJ_ZVEL),L
	move	a0,*a13(SP_OBJ_YVEL),L
	move	a0,*a13(SP_DIE)

	movi	pie_anim,a0
	callr	sp_change_anim

#lp

	callr	sp_velocity_add
	callr	sp_update_pos

	SLEEPK	1

	callr	sp_animate

	move	*a13(SP_DIE),a0
	jrnz	#die

	move	@WORLDTLX+16,a0		;world x int
	addi	200,a0			;center of screen
	move	*a13(SP_OBJ_XPOSINT),a1
	sub	a1,a0
	abs	a0
	cmpi	256,a0	;off screen by 56 pixels
	jrlt	#lp


	move	a13,a0
	callr	delete_special_objlist

#die
	move	*a13(SP_OBJ),a0,L
	calla	DELOBJ

	move	*a13(SP_SHADOW_OBJ),a0,L
	calla	DELOBJ

	DIE


#*****************************************************************************

 SUBR	bam_fireball

	move	a11,*a13(SP_WRESPROC),L
	move	*a11(PLYR_SIDE),*a13(SP_PLYR_SIDE)

	move	a13,a0
	callr	insert_special_objlist	;insert into collis list

	callr	sp_create_obj
	callr	sp_create_shadow

	move	*a13(SP_OBJ),a8,L

	movi	[86,0],a1
	movi	[6,0],a2		;x-vel
	move	*a11(OBJ_XPOS),a0,L
	move	*a11(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#no_flip

	move	*a13(SP_OBJCONTROL),a14
	ori	M_FLIPH,a14
	move	a14,*a13(SP_OBJCONTROL)

	neg	a1
	neg	a2
#no_flip
	add	a1,a0
	move	a0,*a13(SP_OBJ_XPOS),L
	move	a2,*a13(SP_OBJ_XVEL),L



	move	*a11(OBJ_ZPOS),*a13(SP_OBJ_ZPOS),L

	move	*a11(OBJ_YPOS),a0,L
	addi	[97,0],a0
	move	a0,*a13(SP_OBJ_YPOS),L

	move	*a11(INRING),*a13(SP_INRING)

	move	*a11(GROUND_Y),a0
	sll	16,a0
	move	a0,*a13(SP_GROUND_Y),L

	clr	a0
	move	a0,*a13(SP_GRAVITY),L
	move	a0,*a13(SP_OBJ_ZVEL),L
	move	a0,*a13(SP_OBJ_YVEL),L
	move	a0,*a13(SP_DIE)

	movi	fireball_anim,a0
	callr	sp_change_anim

#lp

	callr	sp_velocity_add
	callr	sp_update_pos

	SLEEPK	1

	callr	sp_animate

	move	*a13(SP_DIE),a0
	jrnz	#die

	move	@WORLDTLX+16,a0		;world x int
	addi	200,a0			;center of screen
	move	*a13(SP_OBJ_XPOSINT),a1
	sub	a1,a0
	abs	a0
	cmpi	256,a0	;off screen by 56 pixels
	jrlt	#lp


	move	a13,a0
	callr	delete_special_objlist

#die
	move	*a13(SP_OBJ),a0,L
	calla	DELOBJ

	move	*a13(SP_SHADOW_OBJ),a0,L
	calla	DELOBJ

	DIE



#*****************************************************************************

 SUBR	und_spirit_pull
;Old spirits
	clr	a0
	jruc	#cont

 SUBR	und_spirit_push
;New reaper
	movk	1,a0
#cont	move	a0,*a13(SP_ID)

	move	a11,*a13(SP_WRESPROC),L
	move	*a11(PLYR_SIDE),*a13(SP_PLYR_SIDE)

	move	a13,a0
	callr	insert_special_objlist	;insert into collis list

	callr	sp_create_obj

	move	*a13(SP_OBJ),a8,L

	move	*a13(SP_ID),a14
	jrnz	#reap
;Old spirit
	movi	[32,0],a1
	movi	[7,0],a2		;x-vel
	movi	[36h,0],a3
	movi	spirit_anim,a4
	movi	spirit_anim,a9
	jruc	#cont2
#reap
;Reaper
	movi	[2,0],a1
	movi	[4,0],a2		;x-vel
	movi	[2eh,0],a3
	movi	reaper_grow,a4
	movi	reaper_anim,a9
#cont2
	move	*a11(OBJ_XPOS),a0,L
	move	*a11(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#no_flip

	move	*a13(SP_OBJCONTROL),a14
	ori	M_FLIPH,a14
	move	a14,*a13(SP_OBJCONTROL)

	neg	a1
	neg	a2
#no_flip
	add	a1,a0
	move	a0,*a13(SP_OBJ_XPOS),L
	move	a2,*a13(SP_OBJ_XVEL),L

	move	*a11(OBJ_ZPOS),*a13(SP_OBJ_ZPOS),L

	move	*a11(OBJ_YPOS),a0,L
	add	a3,a0
	move	a0,*a13(SP_OBJ_YPOS),L

	move	*a11(INRING),*a13(SP_INRING)

	move	*a11(GROUND_Y),a0
	sll	16,a0
	move	a0,*a13(SP_GROUND_Y),L

	clr	a0
	move	a0,*a13(SP_GRAVITY),L
	move	a0,*a13(SP_OBJ_ZVEL),L
	move	a0,*a13(SP_OBJ_YVEL),L
	move	a0,*a13(SP_DIE)

	move	a4,a0
	callr	sp_change_anim

#lp



	callr	sp_velocity_add

;	callr	sp_update_pos
;sp_update_pos

	move	*a13(SP_OBJ),a8,L

	move	*a13(SP_OBJ_ZPOS),a0,L
	ori	[01000h,0],a0
	move	*a13(SP_INRING),a14
	jrz	#inring
	cmpi	[015ach,0],a0
	jrgt	#inring
	subi	[01e5h,0],a0		;below mat
#inring
	move	a0,*a8(OZVAL),L

	move	*a13(SP_OBJ_XPOS),*a8(OXVAL),L	;object

	movi	Y_SCALE_MULTIPLIER,a0
	move	*a13(SP_OBJ_ZPOSINT),a1
	mpyu	a0,a1
	move	a1,a2
	move	*a13(SP_OBJ_YPOS),a0,L
	sub	a0,a1
	move	a1,*a8(OYVAL),L


	move	*a13(SP_OBJCONTROL),a7	;flip bits & pixel ops
	andi	0111111b,a7
	setf	6,0,0
	move	a7,*a8(OCTRL)			;Write 6 low bits
	setf	16,1,0

	SLEEPK	1

	move	a9,a0
	callr	sp_animate

	move	*a13(SP_DIE),a0
	jrnz	#die

	move	@WORLDTLX+16,a0		;world x int
	addi	200,a0			;center of screen
	move	*a13(SP_OBJ_XPOSINT),a1
	sub	a1,a0
	abs	a0
	cmpi	256,a0	;off screen by 56 pixels
	jrlt	#lp

	move	a13,a0
	callr	delete_special_objlist
#die

	move	*a13(SP_OBJ),a0,L
	calla	DELOBJ

;	move	*a13(SP_SHADOW_OBJ),a0,L
;	calla	DELOBJ

	DIE

#*****************************************************************************
* Yoko salt toss
*
 SUBR	yok_salt_spray
 
	movk	2,a0
	move	a0,*a13(SP_ID)

	move	a11,*a13(SP_WRESPROC),L
	move	*a11(PLYR_SIDE),*a13(SP_PLYR_SIDE)

	move	a13,a0
	callr	insert_special_objlist	;insert into collis list

	callr	sp_create_obj

	move	*a13(SP_OBJ),a8,L

;Salt
	movi	[36h,0],a1
	movi	[7,0h],a2		;x-vel
	movi	[5bh,0],a3
	movi	salt_grow,a4
	movi	salt_anim,a9

	move	*a11(OBJ_XPOS),a0,L
	move	*a11(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#no_flip

	move	*a13(SP_OBJCONTROL),a14
	ori	M_FLIPH,a14
	move	a14,*a13(SP_OBJCONTROL)

	neg	a1
	neg	a2
#no_flip
	add	a1,a0
	move	a0,*a13(SP_OBJ_XPOS),L
	move	a2,*a13(SP_OBJ_XVEL),L

	move	*a11(OBJ_ZPOS),*a13(SP_OBJ_ZPOS),L

	move	*a11(OBJ_YPOS),a0,L
	add	a3,a0
	move	a0,*a13(SP_OBJ_YPOS),L

	move	*a11(INRING),*a13(SP_INRING)

	move	*a11(GROUND_Y),a0
	sll	16,a0
	move	a0,*a13(SP_GROUND_Y),L

	movi	4800h,a0
	move	a0,*a13(SP_GRAVITY),L
	movi	30000h,a0
	move	a0,*a13(SP_OBJ_YVEL),L
	clr	a0
	move	a0,*a13(SP_OBJ_ZVEL),L
	move	a0,*a13(SP_DIE)

	move	a4,a0
	callr	sp_change_anim
#lp
	callr	sp_velocity_add

;	callr	sp_update_pos
;sp_update_pos

	move	*a13(SP_OBJ),a8,L

	move	*a13(SP_OBJ_ZPOS),a0,L
	ori	[01000h,0],a0
	move	*a13(SP_INRING),a14
	jrz	#inring
	cmpi	[015ach,0],a0
	jrgt	#inring
	subi	[01e5h,0],a0		;below mat
#inring
	move	a0,*a8(OZVAL),L

	move	*a13(SP_OBJ_XPOS),*a8(OXVAL),L	;object

	movi	Y_SCALE_MULTIPLIER,a0
	move	*a13(SP_OBJ_ZPOSINT),a1
	mpyu	a0,a1
	move	a1,a2
	move	*a13(SP_OBJ_YPOS),a0,L
	sub	a0,a1
	move	a1,*a8(OYVAL),L


	move	*a13(SP_OBJCONTROL),a7	;flip bits & pixel ops
	andi	0111111b,a7
	setf	6,0,0
	move	a7,*a8(OCTRL)			;Write 6 low bits
	setf	16,1,0

	SLEEPK	1

	move	a9,a0
	callr	sp_animate

	move	*a13(SP_DIE),a0
	jrnz	#die

	move	@WORLDTLX+16,a0		;world x int
	addi	200,a0			;center of screen
	move	*a13(SP_OBJ_XPOSINT),a1
	sub	a1,a0
	abs	a0
	cmpi	256,a0	;off screen by 56 pixels
	jrlt	#lp

#die
;	cmpi	2,a0
;;Already taken off list?
;	jrnz	#die2
	move	a13,a0
	callr	delete_special_objlist
;#die2

	move	*a13(SP_OBJ),a0,L
	calla	DELOBJ

	DIE

#*****************************************************************************

 SUBR	react_bloodnguts_gen

	move	a11,*a13(SP_WRESPROC),L

#asdf
	movi	3,a8
#loop
	movi	2,a9
#loop2
	CREATE	DEBRIS_PID,react_blood
	push	a13
	move	a13,a10
	move	a0,a13

	move	a11,*a13(SP_WRESPROC),L

	move	*a11(OBJ_XPOS),*a13(SP_OBJ_XPOS),L
	move	*a11(OBJ_ZPOS),*a13(SP_OBJ_ZPOS),L
	move	*a11(OBJ_YPOS),a0,L
	addi	[90,0],a0
	move	a0,*a13(SP_OBJ_YPOS),L

	move	*a11(INRING),*a13(SP_INRING)

	move	*a11(GROUND_Y),a0
	sll	16,a0
	move	a0,*a13(SP_GROUND_Y),L

	pull	a13

	dsj	a9,#loop2

	SLEEPK	2

	dsj	a8,#loop

	SLEEP	2*60

	DIE


 SUBR	react_blood


	clr	a0
	move	a0,*a13(SP_SHADOW_OBJ),L

	movi	GRAVITY*2,a0
	move	a0,*a13(SP_GRAVITY),L

	movi	DMAWNZ,a0		;DMA flags
 	move	a0,*a13(SP_OBJCONTROL)


	clr	a0				;x pos
	clr	a1				;y pos
	movi	PINSHAD1,a2			;* image
	movi	150,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ
	move	a8,*a13(SP_OBJ),L


;	clr	a0				;x pos
;	clr	a1				;y pos
;	movi	PINSHAD1,a2			;* image
;	movi	149,a3				;z pos
;	movi	DMAWNZ,a4			;DMA flags
;	clr	a5				;object ID
;	clr	a6				;x vel
;	clr	a7				;y vel
;	calla	BEGINOBJ
;	move	a8,*a13(SP_SHADOW_OBJ),L


	movi	[4,0],a0
	calla	RNDRNG0



	move	a0,*a13(SP_OBJ_XVEL),L
	jrp	#no_xflip

	move	*a13(SP_OBJCONTROL),a0
	ori	M_FLIPH,a0
	move	a0,*a13(SP_OBJCONTROL)
#no_xflip


	movi	[2,0],a0
	calla	RNDRNGS
	move	a0,*a13(SP_OBJ_ZVEL),L

	movi	[4,0],a0
	calla	RNDRNGS
	addi	[8,0],a0
	move	a0,*a13(SP_OBJ_YVEL),L



	move	*a13(SP_OBJ),a8,L

	movi	flame_anim,a0
	calla	sp_change_anim

	clr	a0
	move	a0,*a13(SP_DIE)

	movi	60*3,a0
	move	a0,*a13(SP_LIFESPAN)

#lp1
	callr	sp_velocity_add
	callr	sp_update_pos

	SLEEPK	2


	move	*a13(SP_OBJ_XVEL),a0,L
	move	*a13(SP_OBJ_YVEL),a1,L
	callr	calc_veldir

	X32	a0
	addi	flame_table_A,a0
	move	*a0,a2,L

	move	a2,*a8(OIMG),L

	move	*a2(ICMAP),a0,L		;Get *palette
	calla	pal_getf
	move	a0,*a8(OPAL),L		;Set palette & constant

	move	*a2(0),*a8(OSIZE),L
	move	*a2(ISAG),*a8(OSAG),L

	move	*a2(IANIOFFX),*a8(ODXOFF)
	move	*a2(IANIOFFY),*a8(ODYOFF)

	movb	*a2(ICTRL+7),*a8(OCTRL+7)	;Write 5 z comp bits + bits pp


;;	callr	sp_animate

;	move	*a13(SP_LIFESPAN),a0
;	dec	a0
;	jrz	#die
;	move	a0,*a13(SP_LIFESPAN)

;	move	*a13(SP_DIE),a0
;	jrz	#lp1

	move	*a13(SP_OBJ_YPOS),a1,L
	move	*a13(SP_GROUND_Y),a14,L
	cmp	a1,a14
	jrle	#lp1

	move	a14,*a13(SP_OBJ_YPOS),L

	movi	flame_splat_anim,a0
	calla	sp_change_anim
	callr	sp_update_pos

#lp2
;	callr	sp_update_pos

	SLEEPK	2

	callr	sp_animate

	move	*a13(SP_DIE),a0
	jrz	#lp2

#die
	move	*a13(SP_OBJ),a0,L
	calla	DELOBJ

;	move	*a13(SP_SHADOW_OBJ),a0,L
;	calla	DELOBJ

	DIE

#*****************************************************************************

 SUBR	special_hit

	PUSH	a13
	PUSH	a8

	move	a6,a13

	move	a13,a0
	callr	delete_special_objlist
	move	*a13(SP_ID),a14
	sll	5,a14
	addi	#splat_tbl,a14
	move	*a14,a0,L
	callr	sp_change_anim

	PULL	a13

	move	a13,a0
	callr	delete_special_objlist
	move	*a13(SP_ID),a14
	sll	5,a14
	addi	#splat_tbl,a14
	move	*a14,a0,L
	callr	sp_change_anim

	PULL	a13
	rets

#splat_tbl
	.long	spiritsplat_anim
	.long	reapersplat_anim
	.long	saltsplat_anim



#*****************************************************************************

sp_create_obj


	clr	a0				;x pos
	clr	a1				;y pos
	movi	PINSHAD1,a2			;* image
	movi	150,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
 	move	a4,*a13(SP_OBJCONTROL)
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ
	move	a8,*a13(SP_OBJ),L

	rets

#*****************************************************************************

sp_create_shadow

	clr	a0				;x pos
	clr	a1				;y pos
	movi	PINSHAD1,a2			;* image
	movi	149,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ
	move	a8,*a13(SP_SHADOW_OBJ),L

	rets

#*****************************************************************************

sp_velocity_add

	move	*a13(SP_OBJ_XPOS),a1,L
	move	*a13(SP_OBJ_XVEL),a0,L
	add	a0,a1
	move	a1,*a13(SP_OBJ_XPOS),L

	move	*a13(SP_OBJ_YPOS),a1,L
	move	*a13(SP_OBJ_YVEL),a0,L
	move	*a13(SP_GRAVITY),a14,L
	sub	a14,a0
	move	a0,*a13(SP_OBJ_YVEL),L
	add	a0,a1
	move	a1,*a13(SP_OBJ_YPOS),L

	move	*a13(SP_OBJ_ZPOS),a1,L
	move	*a13(SP_OBJ_ZVEL),a0,L
	add	a0,a1
	move	a1,*a13(SP_OBJ_ZPOS),L
	rets


#*****************************************************************************

sp_standard_bounce

	move	*a13(SP_OBJ_YVEL),a0,L
	jrp	#ok

	move	*a13(SP_OBJ_YPOS),a1,L
	move	*a13(SP_GROUND_Y),a14,L

	cmp	a1,a14
	jrle	#ok

	move	a14,*a13(SP_OBJ_YPOS),L

	sra	1,a0
	neg	a0
	move	a0,*a13(SP_OBJ_YVEL),L
#ok
	rets


#*****************************************************************************

sp_update_pos

	move	*a13(SP_OBJ),a8,L
	move	*a13(SP_SHADOW_OBJ),a9,L

	move	*a13(SP_OBJ_ZPOS),a0,L
	ori	[01000h,0],a0
	move	*a13(SP_INRING),a14
	jrz	#inring
	cmpi	[015ach,0],a0
	jrgt	#inring
	subi	[01e5h,0],a0		;below mat
#inring
	move	a0,*a8(OZVAL),L
	move	a0,*a9(OZVAL),L


	move	*a13(SP_OBJ_XPOS),*a8(OXVAL),L	;object
	move	*a13(SP_OBJ_XPOS),*a9(OXVAL),L	;shadow

	movi	Y_SCALE_MULTIPLIER,a0
	move	*a13(SP_OBJ_ZPOSINT),a1
	mpyu	a0,a1
	move	a1,a2
	move	*a13(SP_OBJ_YPOS),a0,L
	sub	a0,a1
	move	a1,*a8(OYVAL),L

	move	*a13(SP_GROUND_Y),a0,L
	sub	a0,a2
	move	a2,*a9(OYVAL),L

	move	*a9(OXPOS),a0
	andni	1,a0
	move	@PCNT,a1
	andi	1,a1
	or	a1,a0
	move	*a9(OYPOS),a1
	andi	1,a1
	xor	a1,a0
	move	a0,*a9(OXPOS)		;shake shadow


	move	*a13(SP_OBJCONTROL),a7	;flip bits & pixel ops
	andi	0111111b,a7
	setf	6,0,0
	move	a7,*a8(OCTRL)			;Write 6 low bits
	setf	16,1,0

	rets


sp_update_pos_single

	move	*a13(SP_OBJ),a8,L

	move	*a13(SP_OBJ_ZPOS),a0,L
	ori	[01000h,0],a0
	move	*a13(SP_INRING),a14
	jrz	#inring2
	cmpi	[015ach,0],a0
	jrgt	#inring2
	subi	[01e5h,0],a0		;below mat
#inring2
	move	a0,*a8(OZVAL),L

	move	*a13(SP_OBJ_XPOS),*a8(OXVAL),L	;object

	movi	Y_SCALE_MULTIPLIER,a0
	move	*a13(SP_OBJ_ZPOSINT),a1
	mpyu	a0,a1
	move	a1,a2
	move	*a13(SP_OBJ_YPOS),a0,L
	sub	a0,a1
	move	a1,*a8(OYVAL),L

	move	*a13(SP_OBJCONTROL),a7	;flip bits & pixel ops
	andi	0111111b,a7
	setf	6,0,0
	move	a7,*a8(OCTRL)			;Write 6 low bits
	setf	16,1,0

	rets

#*****************************************************************************


 SUBR	sp_change_anim

	move	a0,*a13(SP_ANIBASE),L
	move	a0,*a13(SP_ANIPC),L
	movk	1,a0
	move	a0,*a13(SP_ANICNT)
	move	*a13(SP_OBJ),a8,L
	callr	sp_animate
	rets


 SUBRP	sp_animate

	move	*a13(SP_DIE),a0
	jrnz	_exit

	move	*a13(SP_ANICNT),a0
	dec	a0
	move	a0,*a13(SP_ANICNT)
	jrgt	_exit

next_command
	move	*a13(SP_ANIPC),a4,L
	move	*a4+,a0
	jrn	#command

	move	a0,*a13(SP_ANICNT)
	move	*a4+,a2,L

	move	*a8(OIMG),a1,L

	move	*a1(ICMAP),a1,L		;* old palette
	move	a2,*a8(OIMG),L		;new image
	move	*a2(ICMAP),a0,L		;Get *palette
	cmp	a0,a1
	jreq	#no_change

;do this only if palette has changed!!!
	move	*a2(ICMAP),a0,L		;Get *palette
	calla	pal_getf
	move	a0,*a8(OPAL),L		;Set palette & constant

#no_change
	move	*a2(0),*a8(OSIZE),L
	move	*a2(ISAG),*a8(OSAG),L

	move	*a2(IANIOFFX),*a8(ODXOFF)
	move	*a2(IANIOFFY),*a8(ODYOFF)

	movb	*a2(ICTRL+7),*a8(OCTRL+7)	;Write 5 z comp bits + bits pp

;	setf	6,0,0
;	move	a7,*a8(OCTRL)			;Write 6 low bits
;	setf	16,1,0

	move	a4,*a13(SP_ANIPC),L

_exit
	rets

#command
	andi	0ffh,a0

	;TEMP!
	.if DEBUG
	TEST	a0
	jrn	#errlo
	cmpi	14,a0
	jrgt	#errhi
	jruc	#ok0
#errlo	LOCKUP
	nop
#errhi	LOCKUP
	nop
#ok0	.endif
	;!PMET

	X32	a0
	addi	#ani_commands,a0
	move	*a0,a0,L
	jump	a0

#ani_commands
	.long	_asp_zip	;0
	.long	_asp_end	;1
	.long	_asp_die	;2
	.long	_asp_repeat	;3
	.long	_asp_goto	;4
	.long	_asp_collbox	;5
	.long	_asp_zerovels	;6
	.long	_asp_add_yvel	;7
	.long	_asp_setword	;8
	.long	_asp_setlong	;9
	.long	_asp_code	;10
	.long	_asp_waitnegyvel ;11
	.long	_asp_zeroyvel	;12
	.long	_asp_waithitgnd	;13
	.long	_asp_set_grav	;14

#********
_asp_zip	;0

	move	a4,*a13(SP_ANIPC),L
	jruc	next_command

#********
_asp_end	;1

	move	a4,*a13(SP_ANIPC),L
	jruc	next_command

#********
_asp_die	;2

	movk	2,a0
	move	a0,*a13(SP_DIE)
	rets

#********
_asp_repeat	;3

	move	*a13(SP_ANIBASE),*a13(SP_ANIPC),L
	jruc	next_command

#********
_asp_goto	;4

	move	*a4(0),*a13(SP_ANIPC),L
	jruc	next_command

#********
_asp_collbox	;5

	move	a4,a14
	addi	6*10h,a14		;6 words
	move	a14,*a13(SP_ANIPC),L

	move	*a4(0),*a13(SP_XOFF)
	move	*a4(10h),*a13(SP_WIDTH)

	move	*a4(20h),*a13(SP_YOFF)
	move	*a4(30h),*a13(SP_HEIGHT)

	move	*a4(40h),*a13(SP_ZOFF)
	move	*a4(50h),*a13(SP_DEPTH)

	jruc	next_command

#********
_asp_zerovels	;6

	clr	a0
	move	a0,*a13(SP_OBJ_XVEL),L
	move	a0,*a13(SP_OBJ_YVEL),L
	move	a0,*a13(SP_OBJ_ZVEL),L

	move	a4,*a13(SP_ANIPC),L
	jruc	next_command

#********
_asp_add_yvel	;7

	move	*a4+,a0,L
	move	a4,*a13(SP_ANIPC),L

	move	*a13(SP_OBJ_YVEL),a1,L
	add	a0,a1
	move	a1,*a13(SP_OBJ_YVEL),L

	jruc	next_command

#********
_asp_setword	;8

	STRUCT	0
	WORD	#PDOFF
	WORD	#WORD
	LABEL	#SIZE

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a13(SP_ANIPC),L

	move	*a4(#PDOFF),a0
	add	a13,a0
	move	*a4(#WORD),a1
	move	a1,*a0

	jruc	next_command


#********
_asp_setlong	;9

	STRUCT	0
	WORD	#PDOFF
	LONG	#LONG
	LABEL	#SIZE

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a13(SP_ANIPC),L

	move	*a4(#PDOFF),a0
	add	a13,a0
	move	*a4(#LONG),a1,L
	move	a1,*a0,L

	jruc	next_command


#********
_asp_code	;10

	move	*a4+,a0,L
	move	a4,*a13(SP_ANIPC),L
	call	a0
	jruc	next_command

#********
_asp_waitnegyvel ;11

	move	*a13(SP_OBJ_YVEL),a0,L
	jrp	#wait

	clr	a0
	move	a0,*a13(SP_OBJ_YVEL),L

	move	a4,*a13(SP_ANIPC),L
	jruc	next_command

#wait
	movk	1,a0
	move	a0,*a13(SP_ANICNT)	;# ticks to hold cur frame
	rets

#********
_asp_zeroyvel	;12

	clr	a0
	move	a0,*a13(SP_OBJ_YVEL),L

	move	a4,*a13(SP_ANIPC),L
	jruc	next_command

#********
_asp_waithitgnd	;13

	move	*a13(SP_OBJ_YVEL),a0,L	;must have down velocity
	jrp	#no_gnd

	move	*a13(SP_OBJ_YPOSINT),a0
	move	*a13(SP_GROUND_Y+10h),a1
	cmp	a1,a0			;a0-a1
	jrgt	#no_gnd

	sll	16,a1
	move	a1,*a13(SP_OBJ_YPOS),L

	move	a4,*a13(SP_ANIPC),L
	jruc	next_command
#no_gnd
	movk	1,a0
	move	a0,*a13(SP_ANICNT)
	rets

#********
_asp_set_grav	;14

	move	*a4+,a0,L
	move	a4,*a13(SP_ANIPC),L
	move	a0,*a13(SP_GRAVITY),L

	jruc	next_command


#********
blade_anim
	WL	3,BLADE01
	WL	3,BLADE02
	WL	3,BLADE03
	WL	3,BLADE04
	WL	3,BLADE05
	WL	3,BLADE06
	WL	3,BLADE07
	WL	3,BLADE08
	WL	3,BLADE09
	WL	3,BLADE10
	.word	ASP_REPEAT

chain_anim
	WL	4,CHAIN01
	WL	4,CHAIN02
	WL	4,CHAIN03
	WL	4,CHAIN04
	WL	4,CHAIN05
	WL	4,CHAIN06
	.word	ASP_REPEAT

bladeR_anim
	WL	3,BLADE04
	WL	3,BLADE03
	WL	3,BLADE02
	WL	3,BLADE01
	WL	3,BLADE10
	WL	3,BLADE09
	WL	3,BLADE08
	WL	3,BLADE07
	WL	3,BLADE06
	WL	3,BLADE05
	.word	ASP_REPEAT

star_anim
	WL	3,STAR01
	WL	3,STAR02
	WL	3,STAR03
	WL	3,STAR04
	WL	3,STAR05
	WL	3,STAR06
	WL	3,STAR07
	WL	3,STAR08
	WL	3,STAR09
	WL	3,STAR10
	WL	3,STAR11
	WL	3,STAR12
	WL	3,STAR13
	WL	3,STAR14
	.word	ASP_REPEAT

dbell_anim
	WL	3,DBELL01
	WL	3,DBELL02
	WL	3,DBELL03
	WL	3,DBELL04
	WL	3,DBELL05
	WL	3,DBELL06
	WL	3,DBELL07
	WL	3,DBELL08
	WL	3,DBELL09
	WL	3,DBELL10
	WL	3,DBELL11
	WL	3,DBELL12
	WL	3,DBELL13
	WL	3,DBELL14
	WL	3,DBELL15
	.word	ASP_REPEAT

lamb_anim
	WL	3,LAMB01
	WL	3,LAMB02
	WL	3,LAMB03
	WL	3,LAMB04
	WL	3,LAMB05
	WL	3,LAMB06
	WL	3,LAMB07
	WL	3,LAMB08
	WL	3,LAMB09
	WL	3,LAMB10
	WL	3,LAMB11
	WL	3,LAMB12
	WL	3,LAMB13
	WL	3,LAMB14
	WL	3,LAMB15
	.word	ASP_REPEAT

fish1_anim
	WL	2,FISHF01
	WL	2,FISHF02
	WL	2,FISHF03
	WL	2,FISHF04
	WL	2,FISHF05
	WL	2,FISHF04
	WL	2,FISHF03
	WL	2,FISHF02
	.word	ASP_REPEAT

fish2_anim
	WL	3,FISHT01
	WL	3,FISHT02
	WL	3,FISHT03
	WL	3,FISHT04
	WL	3,FISHT05
	WL	3,FISHT06
	WL	3,FISHT07
	WL	3,FISHT08
	WL	3,FISHT09
	WL	3,FISHT10
	WL	3,FISHT11
	WL	3,FISHT12
	WL	3,FISHT13
	WL	3,FISHT14
	WL	3,FISHT15
	.word	ASP_REPEAT

turkey_anim
	WL	4,TURKEY1
	WL	4,TURKEY2
	WL	4,TURKEY3
	WL	4,TURKEY4
	WL	4,TURKEY5
	WL	4,TURKEY6
	WL	4,TURKEY7
	WL	4,TURKEY8
	.word	ASP_REPEAT


#*******
bat_anim
	WWL	ASP_SETLONG,SP_HITGND_CODE,#bat_bounce
	.word	ASP_SETWORD,SP_LIFESPAN,150
	WL	ASP_CODE,#choose_anim

batLR_anim
	WL	ASP_CODE,#fliponx
	WL	1,BATSD01
	.word	ASP_WAITHITGND
	WWL	ASP_SETLONG,SP_GRAVITY,04000h
	WL	ASP_CODE,#set_yvel
#bl1
	WL	2,BATSD01
	WL	7,BATSD02
	WL	2,BATSD03
	WL	2,BATSD04
	WL	2,BATSD05
	.word	ASP_WAITNEGYVEL
	WL	ASP_ADD_YVEL,048000h
	WL	ASP_GOTO,#bl1

#fliponx
	move	*a13(SP_OBJ_XVEL),a0,L
	jrp	#noflip
	move	*a13(SP_OBJCONTROL),a0
	xori	M_FLIPH,a0
	move	a0,*a13(SP_OBJCONTROL)
#noflip
	rets

#choose_anim
	move	*a13(SP_OBJ_YVEL),a0,L
	sra	1,a0
	move	a0,*a13(SP_OBJ_YVEL),L

	move	*a13(SP_OBJ_XVEL),a0,L
	abs	a0
	cmpi	0c000h,a0
	jrgt	#fall_through		;to left/right bat

	movi	batU_anim,a0
	move	a0,*a13(SP_ANIPC),L

#fall_through
	rets




batU_anim
	WL	1,BATBK01
	.word	ASP_WAITHITGND
	WWL	ASP_SETLONG,SP_GRAVITY,04000h
	WL	ASP_CODE,#set_yvel
#bl2
	WL	2,BATBK01
	WL	7,BATBK02
	WL	2,BATBK03
	WL	2,BATBK04
	WL	2,BATBK05
	.word	ASP_WAITNEGYVEL
	WL	ASP_ADD_YVEL,048000h
	WL	ASP_GOTO,#bl2

#set_yvel
	movi	4000h,a0
	calla	RNDRNGS
	addi	048000h,a0
	move	a0,*a13(SP_OBJ_YVEL),L

	rets


#bat_bounce
	move	*a13(SP_OBJ_YVEL),a0,L
	jrp	#ok

	move	*a13(SP_OBJ_YPOS),a1,L
	move	*a13(SP_GROUND_Y),a14,L

	cmp	a1,a14
	jrle	#ok

	move	a14,*a13(SP_OBJ_YPOS),L

	clr	a0
	move	a0,*a13(SP_OBJ_YVEL),L
#ok

	rets



#*******
skull_anim
	WL	3,SKULL01
	WL	3,SKULL02
	WL	3,SKULL03
	WL	3,SKULL04
	WL	3,SKULL05
	WL	3,SKULL06
	WL	3,SKULL07
	WL	3,SKULL08
	WL	3,SKULL09
	WL	3,SKULL10
	WL	3,SKULL11
	WL	3,SKULL12
	WL	3,SKULL13
	.word	ASP_REPEAT

bone_anim
	WL	3,BONE01
	WL	3,BONE02
	WL	3,BONE03
	WL	3,BONE04
	WL	3,BONE05
	WL	3,BONE06
	WL	3,BONE07
	WL	3,BONE08
	WL	3,BONE09
	WL	3,BONE10
	WL	3,BONE11
	WL	3,BONE12
	WL	3,BONE13
	WL	3,BONE14
	WL	3,BONE15
	.word	ASP_REPEAT

bone2_anim
	WL	ASP_CODE,#choose_anim

boneR_anim
	WL	2,BONEB15
	WL	2,BONEB14
	WL	2,BONEB13
	WL	2,BONEB12
	WL	2,BONEB11
	WL	2,BONEB10
	WL	2,BONEB09
	WL	2,BONEB08
	WL	2,BONEB07
	WL	2,BONEB06
	WL	2,BONEB05
	WL	2,BONEB04
	WL	2,BONEB03
	WL	2,BONEB02
	WL	2,BONEB01
	.word	ASP_REPEAT

#choose_anim
	move	*a13(SP_OBJ_XVEL),a0,L
	jrp	#fall_through

	movi	boneL_anim,a0
	move	a0,*a13(SP_ANIPC),L

#fall_through
	rets

boneL_anim
	WL	2,BONEB01
	WL	2,BONEB02
	WL	2,BONEB03
	WL	2,BONEB04
	WL	2,BONEB05
	WL	2,BONEB06
	WL	2,BONEB07
	WL	2,BONEB08
	WL	2,BONEB09
	WL	2,BONEB10
	WL	2,BONEB11
	WL	2,BONEB12
	WL	2,BONEB13
	WL	2,BONEB14
	WL	2,BONEB15
	.word	ASP_REPEAT

#*******

heart_anim
	WL	3,HART01
	WL	3,HART02
	WL	3,HART03
	WL	3,HART04
	WL	3,HART05
	WL	3,HART06
	WL	3,HART07
	WL	3,HART08
	WL	3,HART09
	WL	3,HART10
	WL	3,HART11
	WL	3,HART12
	WL	3,HART13
	WL	3,HART14
	WL	3,HART15
	.word	ASP_REPEAT


glasses_anim
	WL	3,BGLAS01
	WL	3,BGLAS02
	WL	3,BGLAS03
	WL	3,BGLAS04
	WL	3,BGLAS05
	WL	3,BGLAS06
	WL	3,BGLAS07
	WL	3,BGLAS08
	WL	3,BGLAS09
	WL	3,BGLAS10
	WL	3,BGLAS11
	WL	3,BGLAS12
	WL	3,BGLAS13
	WL	3,BGLAS14
	WL	3,BGLAS15
	.word	ASP_REPEAT
glasses1_anim
	WL	4,BGLAS01
	WL	4,BGLAS02
	WL	4,BGLAS03
	WL	4,BGLAS04
	WL	4,BGLAS05
	WL	4,BGLAS06
	WL	4,BGLAS07
	WL	4,BGLAS08
	WL	4,BGLAS09
	WL	4,BGLAS10
	WL	4,BGLAS11
	WL	4,BGLAS12
	WL	4,BGLAS13
	WL	4,BGLAS14
	WL	4,BGLAS15
	.word	ASP_REPEAT

glasses2_anim
	WL	2,BGLAS05
	WL	2,BGLAS06
	WL	2,BGLAS07
	WL	2,BGLAS08
	WL	2,BGLAS09
	WL	2,BGLAS10
	WL	2,BGLAS11
	WL	2,BGLAS12
	WL	2,BGLAS13
	WL	2,BGLAS14
	WL	2,BGLAS15
	WL	2,BGLAS01
	WL	2,BGLAS02
	WL	2,BGLAS03
	WL	2,BGLAS04
	.word	ASP_REPEAT

tombbit_anim
	WL	4,TPIE01
	WL	4,TPIE02
	WL	4,TPIE03
	WL	4,TPIE04
	WL	4,TPIE05
	WL	4,TPIE06
	WL	4,TPIE07
	WL	4,TPIE08
	.word	ASP_REPEAT

flame_splat_anim
	WL	4,BLDHIT1
	WL	4,BLDHIT2
	WL	4,BLDHIT3
	WL	4,BLDHIT4
	.word	ASP_DIE
	WL	8,FLAMEA08
	WL	8,FLAMEA09
	WL	8,FLAMEA10
	.word	ASP_DIE



#misc_anims
	.long	ball_anim
	.long	flame_anim
	.long	fireball_anim

ball_anim
	WL	3,BALL01
	WL	3,BALL02
	WL	3,BALL03
	WL	3,BALL04
	WL	3,BALL05
	WL	3,BALL06
	WL	3,BALL07
	WL	3,BALL08
	WL	3,BALL09
	WL	3,BALL10
	WL	3,BALL11
	WL	3,BALL12
	WL	3,BALL13
	WL	3,BALL14
	WL	3,BALL15
	.word	ASP_REPEAT

ex_anima1	;0
	WL	4,XPLODA01
	WL	4,XPLODA03
	WL	4,XPLODA04
	WL	4,XPLODA05
	WL	4,XPLODA06
	WL	4,XPLODA07
	WL	4,XPLODA08
	WL	4,XPLODA09
	WL	4,XPLODA10
	.word	ASP_DIE

flame_anim
	WL	8,FLAMEA01
	WL	8,FLAMEA02
	WL	8,FLAMEA03
	WL	8,FLAMEA04
	WL	8,FLAMEA05
	WL	8,FLAMEA06
	WL	8,FLAMEA07
	.word	ASP_REPEAT


fireball_anim

	.word	ASP_COLLBOX,-10,20,-8,16,-10,20	;xoff,width,yoff,height,zoff,depth
#lp
	WL	4,FIREBALL1
	WL	4,FIREBALL2
	WL	4,FIREBALL3
	WL	4,FIREBALL4
	WL	4,FIREBALL5
	WL	4,FIREBALL6
	WL	ASP_GOTO,#lp

spirit_anim

	.word	ASP_COLLBOX,0,10,-8,16,-10,20	;xoff,width,yoff,height,zoff,depth
#lp2
	WL	3,GHOST01
	WL	3,GHOST02
	WL	3,GHOST03
	WL	3,GHOST04
	WL	3,GHOST05
	WL	ASP_GOTO,#lp2


salt_grow

	.word	ASP_COLLBOX,0,10,-8,16,-1000,20	;xoff,width,yoff,height,zoff,depth
	WL	1,SALT01
	WL	ASP_CODE,#set_xv
salt_anim
	.word	ASP_COLLBOX,0,10,-8,16,-40,80	;xoff,width,yoff,height,zoff,depth
	WL	20,SALT01
	.word	ASP_ZEROVELS
	WL	ASP_SET_GRAV,0h
;Turn collisions off
	.word	ASP_COLLBOX,0,10,-8,16,-1000,20	;xoff,width,yoff,height,zoff,depth
	WL	4,SALT02
	WL	4,SALT03
	WL	4,SALT04
	WL	4,SALT05
	WL	4,SALT06
	WL	4,SALT07
	WL	4,SALT08
	WL	4,SALT09
	.word	ASP_DIE



reaper_grow

	.word	ASP_COLLBOX,0,10,-8,16,-1000,20	;xoff,width,yoff,height,zoff,depth
	WL	1,RPR01
	WL	1,RPR02
	WL	1,RPR03
	WL	1,RPR04
	WL	1,RPR05
	WL	ASP_CODE,#set_xv
reaper_anim
	WL	3,REPRFL01
	WL	3,REPRFL02
	.word	ASP_COLLBOX,0,10,-8,16,-10,20	;xoff,width,yoff,height,zoff,depth
#lp3
	WL	3,REPRFL03
	WL	3,REPRFL04
	WL	3,REPRFL05
	WL	3,REPRFL06
	WL	3,REPRFL07
	WL	3,REPRFL08
	WL	3,REPRFL01
	WL	3,REPRFL02
	WL	ASP_GOTO,#lp3
#set_xv
	movi	[7,0],a0		;x-vel
	move	*a13(SP_OBJCONTROL),a14
	btst	B_FLIPH,a14
	jrz	#no_flip
	neg	a0
#no_flip
	move	a0,*a13(SP_OBJ_XVEL),L
	rets

 SUBR	spiritsplat_anim

	.word	ASP_ZEROVELS
	WL	3,GHOHIT01
	WL	3,GHOHIT02
	WL	3,GHOHIT03
	WL	3,GHOHIT04
	WL	3,GHOHIT05
	WL	3,GHOHIT06
	WL	3,GHOHIT07
	WL	3,GHOHIT08
	WL	3,GHOHIT09
	WL	3,GHOHIT10
	WL	3,GHOHIT11
	WL	3,GHOHIT12
	WL	3,GHOHIT13
	WL	3,GHOHIT14
	WL	3,GHOHIT15
	WL	3,GHOHIT16
	.word	ASP_DIE

 SUBR	reapersplat_anim

	.word	ASP_ZEROVELS
	WL	3,REPRMS01
	WL	3,REPRMS02
	WL	3,REPRMS03
	WL	3,REPRMS04
	WL	3,REPRMS05
	WL	3,REPRMS06
	WL	3,REPRMS07
	.word	ASP_DIE


 SUBR	firesplat_anim

	.word	ASP_ZEROVELS
	WL	4,CLOBHIT01
	WL	4,CLOBHIT02
	WL	4,CLOBHIT03
	WL	4,CLOBHIT04
	.word	ASP_DIE

 SUBR	saltsplat_anim

;	.word	ASP_ZEROVELS
	WL	ASP_SET_GRAV,0h
;Turn collisions off
	.word	ASP_COLLBOX,0,10,-8,16,-1000,20	;xoff,width,yoff,height,zoff,depth
	WL	4,SALT02
	WL	4,SALT03
	WL	2,SALT04
	WL	ASP_CODE,#adjust_vels
;	.word	ASP_ZEROVELS
;	WL	ASP_ADD_YVEL,-20000h
	WL	2,SALT04
	WL	3,SALT05
	WL	ASP_CODE,#adjust_vels
	WL	ASP_ADD_YVEL,-20000h
	WL	3,SALT06
	WL	3,SALT07
	.word	ASP_ZEROVELS
	WL	ASP_ADD_YVEL,-20000h
	WL	3,SALT08
	WL	3,SALT09
	.word	ASP_DIE

#adjust_vels
	move	*a13(SP_OBJ_XVEL),a0,L
	sra	1,a0
	move	a0,*a13(SP_OBJ_XVEL),L
	movi	-20000h,a0
	move	a0,*a13(SP_OBJ_YVEL),L
	clr	a0
	move	a0,*a13(SP_OBJ_ZVEL),L
	rets


#********

pie_anim

	.word	ASP_COLLBOX,-10,20,-8,16,-10,20	;xoff,width,yoff,height,zoff,depth
#lp
;;;	WL	99,PIE03

	WL	4,BGBAT01
	WL	4,BGBAT02
	WL	4,BGBAT03
	WL	4,BGBAT04
	WL	4,BGBAT05
	WL	ASP_GOTO,#lp


 SUBR	piesplat_anim

	.word	ASP_ZEROVELS
	WL	4,PIE05
	WL	4,PIE06
	WL	4,PIE07
	WL	4,PIE08
	.word	ASP_DIE

#********

pin_animC1
	WL	1,PIN15
	WL	1,PIN14
	WL	1,PIN13
	WL	1,PIN12
	WL	1,PIN11
	WL	1,PIN10
	WL	1,PIN09
	WL	1,PIN08
	WL	1,PIN07
	WL	1,PIN06
	WL	1,PIN05
	WL	1,PIN04
	WL	1,PIN03
	WL	1,PIN02
	WL	1,PIN01
	.word	ASP_REPEAT

pin_animC2
	WL	2,PIN15
	WL	2,PIN14
	WL	2,PIN13
	WL	2,PIN12
	WL	2,PIN11
	WL	2,PIN10
	WL	2,PIN09
	WL	2,PIN08
	WL	2,PIN07
	WL	2,PIN06
	WL	2,PIN05
	WL	2,PIN04
	WL	2,PIN03
	WL	2,PIN02
	WL	2,PIN01
	.word	ASP_REPEAT

pin_animC3
	WL	3,PIN15
	WL	3,PIN14
	WL	3,PIN13
	WL	3,PIN12
	WL	3,PIN11
	WL	3,PIN10
	WL	3,PIN09
	WL	3,PIN08
	WL	3,PIN07
	WL	3,PIN06
	WL	3,PIN05
	WL	3,PIN04
	WL	3,PIN03
	WL	3,PIN02
	WL	3,PIN01
	.word	ASP_REPEAT

pin_animA1
	WL	1,PIN01
	WL	1,PIN02
	WL	1,PIN03
	WL	1,PIN04
	WL	1,PIN05
	WL	1,PIN06
	WL	1,PIN07
	WL	1,PIN08
	WL	1,PIN09
	WL	1,PIN10
	WL	1,PIN11
	WL	1,PIN12
	WL	1,PIN13
	WL	1,PIN14
	WL	1,PIN15
	.word	ASP_REPEAT

pin_animA2
	WL	2,PIN01
	WL	2,PIN02
	WL	2,PIN03
	WL	2,PIN04
	WL	2,PIN05
	WL	2,PIN06
	WL	2,PIN07
	WL	2,PIN08
	WL	2,PIN09
	WL	2,PIN10
	WL	2,PIN11
	WL	2,PIN12
	WL	2,PIN13
	WL	2,PIN14
	WL	2,PIN15
	.word	ASP_REPEAT

pin_animA3
	WL	3,PIN01
	WL	3,PIN02
	WL	3,PIN03
	WL	3,PIN04
	WL	3,PIN05
	WL	3,PIN06
	WL	3,PIN07
	WL	3,PIN08
	WL	3,PIN09
	WL	3,PIN10
	WL	3,PIN11
	WL	3,PIN12
	WL	3,PIN13
	WL	3,PIN14
	WL	3,PIN15
	.word	ASP_REPEAT


#*****************************************************************************
*
* args:
*	a0 = X-VEL (LONG)
*	a1 = Y-VEL (LONG)
*
* ret:
*	a0 = angle 0=0d(U) 9=45d(UR) 18=90d(R) 27=135d(DR) 36=180d(D)
*

 SUBR	calc_veldir

	abs	a0

	move	a1,a14
	abs	a14
	or	a0,a14
	jrz	#done

	movi	#posx_posy,a2

	move	a1,a1		;y-vel
	jrp	#pos_yvel

	movi	#posx_negy,a2

#pos_yvel
	abs	a1

	move	a14,a3		;x+y vel < 8 ?
	srl	16+3,a3
	jrz	#not_max

#ovr
	srl	1,a0
	srl	1,a1
	srl	1,a3
	jrnz	#ovr		;< 8 now?
	jruc	#range_ok

#not_max
	btst	18,a14		;bit 2 of int set (=4) ?
	jrnz	#range_ok

#undr
	sll	1,a0
	sll	1,a1
	sll	1,a14
	btst	18,a14		;bit 2 of int set (=4) ?
	jrz	#undr


#range_ok
;;	addi	08000h,a0	;round up
	srl	16,a0	;x

;;	addi	08000h,a1	;round up
	srl	16,a1	;y

;#again
;	cmpi	8,a0		;do this before losing fractional
;	jrge	#tohi
;	cmpi	8,a1
;	jrlt	#ok1
;
;#tohi
;	srl	1,a0
;	srl	1,a1
;	jruc	#again
;#ok1

	X8	a1	;y*8
	add	a1,a0	;+x
	X16	a0	;16 bit word
	add	a2,a0
	move	*a0,a0

#done
	rets

#posx_posy
;X		0  1  2  3  4  5  6  7

	.word	18,18,18,18,18,18,18,18	;0

	.word	13,09,13,14,15,16,16,16	;1

	.word	09,05,09,11,13,14,14,15	;2

	.word	04,04,07,09,11,12,13,13	;3

	.word	00,03,05,07,09,10,11,12	;4

	.word	00,02,04,06,08,09,10,11	;5

	.word	00,02,04,06,07,08,09,10	;6

	.word	00,02,03,05,06,07,08,09	;7	Y


#posx_negy
;X		0  1  2  3  4  5  6  7

	.word	18,18,18,18,18,18,18,18	; 0

	.word	23,27,23,22,21,20,20,20	;-1

	.word	28,31,27,25,23,22,22,21	;-2

	.word	33,32,29,27,25,24,23,23	;-3

	.word	36,33,31,29,27,26,25,24	;-4

	.word	36,34,32,30,28,27,26,25	;-5

	.word	36,34,32,31,29,28,27,26	;-6

	.word	36,34,33,31,30,29,28,27	;-7	Y


#*****************************************************************************

flame_table_A

	.long	BLOOD01			;0	(  0d UP)
	.long	BLOOD01		;1	(  5d)
	.long	BLOOD01		;2	( 10d)
	.long	BLOOD01		;3	( 15d)
	.long	BLOOD02		;4	( 20d)
	.long	BLOOD02		;5	( 25d)
	.long	BLOOD02		;6	( 30d)
	.long	BLOOD03		;7	( 35d)
	.long	BLOOD03		;8	( 40d)
	.long	BLOOD03		;9	( 45d UP-RIGHT)
	.long	BLOOD03		;10	( 50d)
	.long	BLOOD04		;11	( 55d)
	.long	BLOOD04		;12	( 60d)
	.long	BLOOD04		;13	( 65d)
	.long	BLOOD05		;14	( 70d)
	.long	BLOOD05		;15	( 75d)
	.long	BLOOD05		;16	( 80d)
	.long	BLOOD06		;17	( 85d)
	.long	BLOOD06		;18	( 90d RIGHT)

	.long	BLOOD06		;19	(95d)
	.long	BLOOD06		;20	(100d)
	.long	BLOOD07		;21	(105d)
	.long	BLOOD07		;22	(110d)
	.long	BLOOD07		;23	(115d)
	.long	BLOOD08		;24	(120d)
	.long	BLOOD08		;25	(125d)
	.long	BLOOD08		;26	(130d)
	.long	BLOOD08		;27	(135d DOWN-RIGHT)
	.long	BLOOD09		;28	(140d)
	.long	BLOOD09		;29	(145d)
	.long	BLOOD09		;30	(150d)
	.long	BLOOD10		;31	(155d)
	.long	BLOOD10		;32	(160d)
	.long	BLOOD10		;33	(165d)
	.long	BLOOD11		;34	(170d)
	.long	BLOOD11		;35	(175d)
	.long	BLOOD11		;36	(180d DOWN)

#*****************************************************************************

	STRUCT	0

	WORD	DB_LOOP
	WORD	DB_COUNT
	WORD	DB_SLEEP

	WORD	DB_RXOFF
	WORD	DB_RYOFF
	WORD	DB_RZOFF

	LONG	DB_XVEL
	LONG	DB_YVEL
	LONG	DB_ZVEL

	LONG	DB_RXVEL
	LONG	DB_RYVEL
	LONG	DB_RZVEL

	LONG	DB_GRAVITY

	WORD	DB_LIFESPAN
	WORD	DB_RLIFESPAN


	STRUCTPD
	WORD	#ANIM

; a8 = * arguments
; a11 = * wrestler proc

 SUBR	react_debris


	move	*a8(0),a0		;%chance of generating debris
	calla	RNDPER
	jrls	#die

	;if there's too much debris already, don't do anything.
	move	@debris_count,a14
	cmpi	DEBRIS_MAX,a14
	jrge	#die

	;increment global debris count
	move	@debris_count,a14
	inc	a14
	move	a14,@debris_count

	move	*a11(WRESTLERNUM),a10		;table index
	SLL	5,A10
	ADDI	WHICH_DEBRIS_SOUND,A10,L
	MOVE	*A10,A10,L
	MOVE	*A10+,A0
	JRZ	NO_SOUND_AT_ALL
	CALLA	RNDRNG0
DONT_WORRY_ABOUT_RANDOM
	SLL	4,A0
	ADD	A0,A10
	MOVE	*A10,A0
	JRZ	NO_SOUND_AT_ALL
	CALLA	triple_sound
NO_SOUND_AT_ALL

	move	*a8(010h),a10		;table index
	X32	a10
	addi	#debris_table,a10
	move	*a10,a10,L

	addi	20h,a8			;* x,y,z off

	move	*a10(DB_LOOP),a9	;loop count
#lp1
	move	*a10(DB_COUNT),a0	;# per loop
#lp2

	PUSH	a0
	movi	7,a0
	calla	RNDRNG0
	X32	a0

	move	*a11(WRESTLERNUM),a14
	cmpi	2,a14
	jrnz	#not_und
	move	*a11(ANIBASE),a1,L
	.ref	und_4_pin2_anim
	cmpi	und_4_pin2_anim,a1
	jrnz	#not_und
	mmtm	sp,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a14
	movi	0cfh,a0			;bat sound
	calla	triple_sound
	mmfm	sp,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a14
	movi	8*32,a0

#not_und
	X32	a14
	addi	debris_anims,a14
	move	*a14,a14,L
	add	a14,a0
	move	*a0(0),*a13(#ANIM),L

	CREATE	DEBRIS_PID,react_debris2

	move	*a13(#ANIM),*a0(SP_ANIMPTR),L	;&anim
	PULL	a0
	dsj	a0,#lp2

	move	*a10(DB_SLEEP),a0	;sleep cnt
	jrz	#skp
	calla	PRCSLP
#skp
	dsj	a9,#lp1

#exit
	;decrement global debris count
	move	@debris_count,a14
	dec	a14
	move	a14,@debris_count

#die	DIE

WHICH_DEBRIS_SOUND
	.long	BRET_DEBRIS
	.long	RAZOR_DEBRIS
	.long	TAKER_DEBRIS
	.long	YOKO_DEBRIS
	.long	SHAWN_DEBRIS
	.long	BAM_DEBRIS
	.long	DOINK_DEBRIS
	.long	0
	.long	LEX_DEBRIS

;BRET_DEBRIS
;	.WORD	0
YOKO_DEBRIS
	.WORD	3,0d9h,0dah,0dbh,0dch
BRET_DEBRIS
SHAWN_DEBRIS
	.WORD	1,0d7h,0d8h
BAM_DEBRIS
	.WORD	4,09dh,09eh,09fh,0a0h,0a1h
DOINK_DEBRIS
	.WORD	1,04EH,04FH
TAKER_DEBRIS
	.WORD	4,09dh,09eh,09fh,0a0h,0a1h
LEX_DEBRIS
RAZOR_DEBRIS
	.WORD	1,0cdh,0c6h

#debris_table
	.long	#db0
	.long	#db1
	.long	#db2
	.long	#db3
	.long	#db4
	.long	#db5
	.long	#db6
	.long	#db7


#db0	;standing - hit to body 1
	.word	3,1,2				;loop count, # per loop, sleep cnt
	.word	0,20,0				;random +/- x,y,z pos offs
	.long	-020000h,050000h, 000000h	;initial x,y,z vel
	.long	018000h, 010000h, 010000h	;random +/- x,y,z vel
	.long	GRAVITY				;gravity value
	.word	60,5				;lifespan, +/- rand

#db1	;onground - hit to body 1
	.word	2,2,4				;loop count, # per loop, sleep cnt
	.word	20,0,0				;random +/- x,y,z pos offs
	.long	000000h, 080000h, 000000h	;initial x,y,z vel
	.long	020000h, 020000h, 020000h	;random +/- x,y,z vel
	.long	GRAVITY				;gravity value
	.word	70,5				;lifespan, +/- rand

#db2	;standing - hit to head 1
	.word	2,1,3				;loop count, # per loop, sleep cnt
	.word	0,5,0				;random +/- x,y,z pos offs
	.long	-030000h,050000h, 000000h	;initial x,y,z vel
	.long	018000h, 010000h, 010000h	;random +/- x,y,z vel
	.long	GRAVITY				;gravity value
	.word	60,5				;lifespan, +/- rand

#db3	;standing - hit to head 2
	.word	1,1,0				;loop count, # per loop, sleep cnt
	.word	0,5,0				;random +/- x,y,z pos offs
	.long	-030000h,050000h, 000000h	;initial x,y,z vel
	.long	018000h, 010000h, 010000h	;random +/- x,y,z vel
	.long	GRAVITY				;gravity value
	.word	60,5				;lifespan, +/- rand

#db4	;Doink earslap squish
	.word	2,3,2				;loop count, # per loop, sleep cnt
	.word	20,0,0				;random +/- x,y,z pos offs
	.long	000000h, 080000h, 000000h	;initial x,y,z vel
	.long	020000h, 020000h, 020000h	;random +/- x,y,z vel
	.long	GRAVITY				;gravity value
	.word	70,5				;lifespan, +/- rand

#db5	;BAM POGO head slammed into ground
	.word	2,2,3				;loop count, # per loop, sleep cnt
	.word	10,10,0				;random +/- x,y,z pos offs
	.long	000000h, 080000h, 000000h	;initial x,y,z vel
	.long	020000h, 020000h, 020000h	;random +/- x,y,z vel
	.long	GRAVITY				;gravity value
	.word	70,5				;lifespan, +/- rand

#db6	;BAM BAM fire head butt - Comes from Bam Bam attack sequence!
	.word	2,1,3				;loop count, # per loop, sleep cnt
	.word	0,5,0				;random +/- x,y,z pos offs
	.long	-030000h,050000h, 000000h	;initial x,y,z vel
	.long	018000h, 010000h, 010000h	;random +/- x,y,z vel
	.long	GRAVITY				;gravity value
	.word	60,5				;lifespan, +/- rand

#db7	;onground - Taker pins me with hand
	.word	8,2,4				;loop count, # per loop, sleep cnt
	.word	15,0,0				;random +/- x,y,z pos offs
	.long	000000h, 040000h, 000000h	;initial x,y,z vel
	.long	020000h, 020000h, 020000h	;random +/- x,y,z vel
	.long	GRAVITY				;gravity value
	.word	70,5				;lifespan, +/- rand


#*****************************************************************************
; a8 = * x,y,z off
; a10 = * debris table
; a11 = * wrestler proc

 SUBR	react_debris2

	;if there's too much debris already, don't do anything.
	move	@debris_count,a14
	cmpi	DEBRIS_MAX,a14
	jrge	#die

	;increment global debris count
	move	@debris_count,a14
	inc	a14
	move	a14,@debris_count

	move	a11,*a13(SP_WRESPROC),L
	move	*a11(PLYR_SIDE),*a13(SP_PLYR_SIDE)

	move	*a10(DB_RXOFF),a0		;+/- xoff
	jrz	#skp0
	calla	RNDRNGS
#skp0	move	*a8,a1				;xoff
	add	a0,a1

	move	*a11(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#no_flip1
	neg	a1
#no_flip1
	move	*a11(OBJ_XPOSINT),a0
	add	a1,a0
	sll	16,a0
	move	a0,*a13(SP_OBJ_XPOS),L


	move	*a10(DB_RYOFF),a0		;+/- yoff
	jrz	#skp1
	calla	RNDRNGS
#skp1	move	*a8(010h),a1			;yoff
	add	a0,a1
	move	*a11(OBJ_YPOSINT),a0
	add	a1,a0
	sll	16,a0
	move	a0,*a13(SP_OBJ_YPOS),L


	move	*a10(DB_RZOFF),a0		;+/- zoff
	jrz	#skp2
	calla	RNDRNGS
#skp2	move	*a8(020h),a1			;zoff
	add	a0,a1
	move	*a11(OBJ_ZPOSINT),a0
	add	a1,a0
	sll	16,a0
	move	a0,*a13(SP_OBJ_ZPOS),L


	move	*a11(INRING),*a13(SP_INRING)



	move	*a11(GROUND_Y),a0
	sll	16,a0
	move	a0,*a13(SP_GROUND_Y),L

	clr	a0
	move	a0,*a13(SP_SHADOW_OBJ),L

	move	*a10(DB_GRAVITY),*a13(SP_GRAVITY),L

	callr	sp_create_obj
	callr	sp_create_shadow

	move	*a13(SP_OBJ),a8,L


	move	*a10(DB_RXVEL),a0,L
	jrz	#skp3
	calla	RNDRNGS
#skp3	move	*a10(DB_XVEL),a1,L
	add	a0,a1
	move	*a11(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#no_flip2			;flip relative
	neg	a1
#no_flip2
	move	a1,*a13(SP_OBJ_XVEL),L


	move	*a10(DB_RZVEL),a0,L
	jrz	#skp4
	calla	RNDRNGS
#skp4	move	*a10(DB_ZVEL),a1,L
	add	a0,a1
	move	a1,*a13(SP_OBJ_ZVEL),L


	move	*a10(DB_RYVEL),a0,L
	jrz	#skp5
	calla	RNDRNGS
#skp5	move	*a10(DB_YVEL),a1,L
	add	a0,a1
	move	a1,*a13(SP_OBJ_YVEL),L


	movi	sp_standard_bounce,a0
	move	a0,*a13(SP_HITGND_CODE),L

	move	*a13(SP_OBJ),a8,L

	clr	a0
	move	a0,*a13(SP_DIE)

	move	*a10(DB_RLIFESPAN),a0
	jrz	#skp6
	calla	RNDRNGS
#skp6	move	*a10(DB_LIFESPAN),a1
	add	a0,a1
	move	a1,*a13(SP_LIFESPAN)

	move	*a13(SP_ANIMPTR),a0,L	;& anim
	calla	sp_change_anim

#lp
	callr	sp_velocity_add

	move	*a13(SP_HITGND_CODE),a0,L
	call	a0
	callr	sp_update_pos

	SLEEP	1

	callr	sp_animate

	move	*a13(SP_LIFESPAN),a0
	dec	a0
	jrz	#die
	move	a0,*a13(SP_LIFESPAN)

	move	*a13(SP_DIE),a0
	jrz	#lp

#die
	move	*a13(SP_OBJ),a0,L
	calla	DELOBJ

	move	*a13(SP_SHADOW_OBJ),a0,L
	calla	DELOBJ

	;decrement global debris count
	move	@debris_count,a14
	dec	a14
	move	a14,@debris_count

	DIE


#pin_anims
	.long	pin_animC1	;0
	.long	pin_animC2	;1
	.long	pin_animC2	;2
	.long	pin_animC3	;3
	.long	pin_animC3	;4
	.long	pin_animC2	;5
	.long	pin_animC2	;6
	.long	pin_animC1	;7

	.long	pin_animA1	;0
	.long	pin_animA2	;1
	.long	pin_animA2	;2
	.long	pin_animA3	;3
	.long	pin_animA3	;4
	.long	pin_animA2	;5
	.long	pin_animA2	;6
	.long	pin_animA1	;7




debris_anims
	.long	#bret_debris_anims	;0
	.long	#razor_debris_anims	;1
	.long	#taker_debris_anims	;2
	.long	#yoko_debris_anims	;3
	.long	#shawn_debris_anims	;4
	.long	#bam_debris_anims	;5
	.long	#doink_debris_anims	;6
	.long	#doink_debris_anims	;7
	.long	#lex_debris_anims	;8

***
#bret_debris_anims
	.long	heart_anim	;0
	.long	glasses_anim	;1
	.long	glasses1_anim	;2
	.long	glasses2_anim	;3
	.long	heart_anim	;4
	.long	heart_anim	;5
	.long	heart_anim	;6
	.long	heart_anim	;7
***
#razor_debris_anims
	.long	chain_anim	;0
	.long	bladeR_anim	;1
	.long	blade_anim	;2
	.long	bladeR_anim	;3
	.long	blade_anim	;4
	.long	bladeR_anim	;5
	.long	blade_anim	;6
	.long	bladeR_anim	;7
***
#taker_debris_anims
	.long	bat_anim	;0
	.long	bat_anim	;1
	.long	skull_anim	;2
	.long	bone_anim	;3
	.long	bat_anim	;4
	.long	bat_anim	;5
	.long	skull_anim	;6
	.long	bone2_anim	;7
;Special bats only for a pin
	.long	bat_anim	;8
***
#yoko_debris_anims
	.long	lamb_anim	;0
	.long	fish1_anim	;1
	.long	fish2_anim	;2
	.long	lamb_anim	;3
	.long	fish1_anim	;4
	.long	fish2_anim	;5
	.long	turkey_anim	;6
	.long	fish1_anim	;7
***
#shawn_debris_anims
	.long	heart_anim	;4
	.long	heart_anim	;5
	.long	heart_anim	;6
	.long	heart_anim	;7
	.long	heart_anim	;7
	.long	heart_anim	;7
	.long	heart_anim	;7
	.long	heart_anim	;7
***
#bam_debris_anims
	.long	ex_anima1	;0
	.long	ex_anima1	;0
	.long	ex_anima1	;0
	.long	ex_anima1	;0
	.long	ex_anima1	;0
	.long	ex_anima1	;0
	.long	ex_anima1	;0
	.long	ex_anima1	;0

***
#doink_debris_anims
	.long	pin_animC2	;0
	.long	pin_animA2	;1
	.long	pin_animC3	;2
	.long	ball_anim	;3
	.long	ball_anim	;4
	.long	pin_animA2	;5
	.long	pin_animC3	;6
	.long	pin_animA3	;7
***
#lex_debris_anims
	.long	dbell_anim	;0
	.long	star_anim	;1
	.long	dbell_anim	;2
	.long	star_anim	;3
	.long	dbell_anim	;4
	.long	star_anim	;5
	.long	dbell_anim	;6
	.long	star_anim	;7

#*****************************************************************************

; a8 = * arguments
; a11 = * wrestler proc


 SUBR	und_tombbits2

	move	@no_debris,a14
	jrnz	#no_bab
	move	@reduce_bog,a14
	jrnz	#no_bab

	movk	4,a9
#lp2
	movi	#tmb_debris2,a10
	movi	#xyz_off2,a8
	CREATE	DEBRIS_PID,react_debris2
	movi	tombbit_anim,a14
	move	a14,*a0(SP_ANIMPTR),L	;&anim

	movi	#tmb_debris2,a10
	movi	#xyz_off2,a8
	CREATE	DEBRIS_PID,react_debris2
	movi	tombbit_anim,a14
	move	a14,*a0(SP_ANIMPTR),L	;&anim

	SLEEPK	1
	dsj	a9,#lp2
#no_bab
	DIE


 SUBR	und_tombbits
      
	move	@no_debris,a14
	jrnz	#no_bab
	move	@reduce_bog,a14
	jrnz	#no_bab

	movk	3,a9
#lp
	movi	#tmb_debris,a10
	movi	#xyz_off,a8
	CREATE	DEBRIS_PID,react_debris2
	movi	tombbit_anim,a14
	move	a14,*a0(SP_ANIMPTR),L	;&anim

	SLEEPK	1
	dsj	a9,#lp

	DIE


#xyz_off .word	91,97,0
#xyz_off2 .word	58,8,0

#tmb_debris
	.word	2,3,2				;loop count, # per loop, sleep cnt
	.word	20,0,0				;random +/- x,y,z pos offs
	.long	000000h, 050000h, 000000h	;initial x,y,z vel
	.long	020000h, 020000h, 020000h	;random +/- x,y,z vel
	.long	GRAVITY				;gravity value
	.word	60,5				;lifespan, +/- rand


#tmb_debris2
	.word	3,3,1				;loop count, # per loop, sleep cnt
	.word	20,0,0				;random +/- x,y,z pos offs
	.long	000000h, 050000h, 000000h	;initial x,y,z vel
	.long	010000h, 020000h, 010000h	;random +/- x,y,z vel
	.long	GRAVITY				;gravity value
	.word	30,5				;lifespan, +/- rand


#*****************************************************************************

BELOW	.EQU	16*2
NEXT	.EQU	60*2

	.long	0,0,NEXT
TEXT_LIST
	;software & design
	.long	#LINESD,0,BELOW
	.long	#LINESD1,0,BELOW
	.long	#LINESD2,0,BELOW
	.long	#LINESD3,0,BELOW
	.long	#LINESD4,0,BELOW
	.long	#LINESD5,0,NEXT

	;art & design
	.long	#LINEAD,0,BELOW
	.long	#LINEAD1,0,BELOW
	.long	#LINEAD2,0,BELOW
	.long	#LINEAD3,0,BELOW
	.long	#LINEAD4,0,NEXT

	;music & sound
	.long	#LINEMS,0,BELOW
	.long	#LINEMS1,0,NEXT

	;hardware design
	.long	#LINEHD,0,BELOW
	.long	#LINEHD1,0,BELOW
	.long	#LINEHD2,0,BELOW
	.long	#LINEHD3,0,BELOW
	.long	#LINEHD4,0,BELOW
	.long	#LINEHD5,0,NEXT

	;art tools
	.long	#LINEAT,0,BELOW
	.long	#LINEAT1,0,BELOW
	.long	#LINEAT2,0,BELOW
	.long	#LINEAT3,0,BELOW
	.long	#LINEAT4,0,NEXT

	;hardware support
	.long	#LINEHS,0,BELOW
	.long	#LINEHS1,0,BELOW
	.long	#LINEHS2,0,BELOW
	.long	#LINEHS3,0,BELOW
	.long	#LINEHS4,0,NEXT

	;sound system
	.long	#LINESS,0,BELOW
	.long	#LINESS1,0,BELOW
	.long	#LINESS2,0,NEXT

	;game testers
	.long	#LINEGT,0,BELOW
	.long	#LINEGT1,0,BELOW
	.long	#LINEGT2,0,NEXT

	;special thanks
	.long	#LINEST,0,BELOW
	.long	#LINEST1,0,BELOW
	.long	#LINEST2,0,BELOW
	.long	#LINEST3,0,BELOW
	.long	#LINEST4,0,BELOW
	.long	#LINEST5,0,BELOW
	.long	#LINEST6,0,BELOW
	.long	#LINEST7,0,BELOW
	.long	#LINEST8,0,BELOW
	.long	#LINEST9,0,BELOW
	.long	#LINEST10,0,NEXT

	;more special thanks
	.long	#LINECP,0,BELOW
	.long	#LINECP1,0,BELOW
	.long	#LINECP2,0,BELOW
	.long	#LINECP3,0,BELOW+280

;	.long	#LINECP4,0,BELOW
;	.long	#LINECP5,0,BELOW
;	.long	#LINECP6,0,BELOW
;	.long	#LINECP7,0,BELOW+280
;	.long	#LINECP8,0,BELOW
;	.long	#LINECP9,0,BELOW
;	.long	#LINECP10,0,BELOW+280
	.long	-1

#SETUP_LINE
	JAM_STR	osgemd_ascii,10,0,200,-30,RUBYPAL,print_string_C2

#LINESD
	.byte	"SOFTWARE & DESIGN",0,0
	.even
#LINESD1
	.byte	"MARK TURMELL",0,0
	.even
#LINESD2
	.byte	"JASON SKILES",0,0
	.even
#LINESD3
	.byte	"JAMIE RIVETT",0,0
	.even
#LINESD4
	.byte	"JAKE SIMPSON",0,0
	.even
#LINESD5
	.byte	"SHAWN LIPTAK",0,0
	.even
#LINESD6
	.byte	"MIKE LYNCH",0,0
	.even

#LINEAD
	.byte	"ART & DESIGN",0,0
	.even
#LINEAD1
	.byte	"SAL DIVITA",0,0
	.even
#LINEAD2
	.byte	"JOSH TSUI",0,0
	.even
#LINEAD3
	.byte	"EUGENE GEER",0,0
	.even
#LINEAD4
	.byte	"TONY GOSKIE",0,0
	.even

#LINEMS
	.byte	"MUSIC & SOUND EFFECTS",0,0
	.even
#LINEMS1
	.byte	"CHRIS GRANNER",0,0
	.even

#LINEHD
	.byte	"HARDWARE DESIGN",0,0
	.even
#LINEHD1
	.byte	"MARK LOFFREDO",0,0
	.even
#LINEHD2
	.byte	"CARY MEDNICK",0,0
	.even
#LINEHD3
	.byte	"STEVE CORRELL",0,0
	.even
#LINEHD4
	.byte	"JOE KALINOWSKI",0,0
	.even
#LINEHD5
	.byte	"JOHN LOWES",0,0
	.even


#LINEAT
	.string	"ARTWORK TOOLS",0,0
	.even
#LINEAT1
	.string	"WARREN DAVIS",0,0
	.even
#LINEAT2
	.string "SHAWN LIPTAK",0,0
	.even
#LINEAT3
	.string "TODD ALLEN",0,0
	.even
#LINEAT4
	.string	"ALIAS RESEARCH",0,0
	.even


#LINEHS
	.byte	"HARDWARE SUPPORT",0,0
	.even
#LINEHS1
	.byte	"PAT COX",0,0
	.even
#LINEHS2
	.byte	"SHERIDAN OURSLER",0,0
	.even
#LINEHS3
	.byte	"AL LASKO",0,0
	.even
#LINEHS4
	.byte	"JEFF PETERS",0,0
	.even


#LINESS
	.byte	"DCS SOUND SYSTEM",0,0
	.even
#LINESS1
	.byte	"MATT BOOTY",0,0
	.even
#LINESS2
	.byte	"ED KEENAN",0,0
	.even

#LINEGT
	.byte	"GAME TESTERS",0,0
	.even
#LINEGT1
	.byte	"EDDIE FERRIER",0,0
	.even
#LINEGT2
	.byte	"MIKE VINIKOUR",0,0
	.even

#LINEST
	.byte	"SPECIAL THANKS",0,0
	.even
#LINEST1
	.byte	"JOHN TOBIAS",0,0
	.even
#LINEST2
	.byte	"MARK PENACHO",0,0
	.even
#LINEST3
	.byte	"ED BOON",0,0
	.even
#LINEST4
	.byte	"EUGENE JARVIS",0,0
	.even
#LINEST5
	.byte	"L.E.D.",0,0
	.even
#LINEST6
	.byte	"GEORGE PETRO",0,0
	.even
#LINEST7
	.byte	"JEFF JOHNSON",0,0
	.even
#LINEST8
	.byte	"JOHN NEWCOMER",0,0
	.even
#LINEST9
	.byte	"JON HEY",0,0
	.even
#LINEST10
	.byte	"MIDWAY MANAGEMENT",0,0
	.even

#LINECP
	.byte	"A SPECIAL THANK YOU",0,0
	.even
#LINECP1
	.BYTE	"CATHY SIMPSON",0,0
	.EVEN
#LINECP2
	.BYTE	"CRISTY TSUI",0,0
	.EVEN
#LINECP3
	.BYTE	"WEI LIN GEER",0,0
	.EVEN

;#LINECP8
;	.BYTE	"ZIPPER & KASHA",0,0
;	.EVEN
;#LINECP9
;	.BYTE	"KRALOR   EMP TASS & EVIL",0,0
;	.EVEN
;#LINECP10
;	.BYTE	"AND ALL THE CSERVE GUYS",0,0
;	.EVEN


#hstd_mod
	.long	slateBMOD
	.word	0,0
	.long	0

;#title_mod
;	.long	LAVAPGBMOD
;	.word	0,0
	.long	0

#LIST_START	.equ PDATA+20H

 SUBR	CREATE_TEXT_LINE
	JSRP	GENERIC_DISPLAY
	MOVI	TEXT_LIST,A8

	MOVI	TYPTEXT+1,A10
	CREATE0	ck_octopus2

	MOVI	#SETUP_LINE,A2
	CALLA	setup_message
small_loop
	MOVE	*A8+,A4,L
	INC	A4
	JRZ	LAST_ONE
	DEC	A4
	MOVE	A10,@mess_objid
	MOVI	GOLD,A3
	MOVE	*A8(-040H),A0
	CMPI	NEXT,A0
	JRNE	PAL_IS_SET
	MOVI	RUBYPAL,A3
PAL_IS_SET
	MOVE	A3,@message_palette,L
	CALLA	print_string_C2
	MOVI	179,A9
	CREATE	MESSAGE_PID,MAKE_TEXT_MOVE

	MOVE	*A8+,A5,L
	JRZ	NO_NEW_BACK
	CALLA	CLEAR_BAKGROUND_OBJ
NO_NEW_BACK
	MOVE	*A8+,A0,L
	CALLA   PRCSLP
	INC	A10
	jruc	small_loop
LAST_ONE
	RETP

CLEAR_BAKGROUND_OBJ
	PUSH	A8
	CALLA	ZERO_BITS
	move	@BAKLST,A0,L		;Null backgnd object list
	MOVE	*A0,A0,L
	JRZ	NO_DELETE_IT
MORE_TO_DELETE
	MOVE	*A0,A9,L
	CALLA	DELBOBJ
	MOVE	A9,A0
	JRNZ	MORE_TO_DELETE
NO_DELETE_IT
	MOVE	A5,@BAKMODS,L
	CALLA	BGND_UD1
	PULL	A8
	RETS

MAKE_TEXT_MOVE
;	MOVE	@mess_objid,A10
	CALLR	FIND_ALL_TEXT
ROTATE_TEXT
	SLEEP	2
	CALLR	WORK_OUT_LINE_Y_AND_SCALE
	CALLR	PUT_IN_SCALE_AND_YPOS
	DEC	A9
	JRNN	ROTATE_TEXT
	MOVE	A10,A0
	CALLA	obj_del1c
	DIE

FIND_ALL_TEXT
	MOVI	OBJLST,A14
	MOVE	A13,A2
	ADDI	#LIST_START,A2
	JRUC	PICK_UP_NEXT
CHECK_AGAINST_NEXT
	MOVE	*A14(OID),A1
	CMP	A10,A1
	JRNE	PICK_UP_NEXT
	MOVE	A14,*A2+,L
	MOVE	*A14(OXPOS),A1
	SUBI	200,A1
	MOVE	A1,*A14(OMISC)
PICK_UP_NEXT
	MOVE	*A14,A14,L
	JRNZ	CHECK_AGAINST_NEXT
	MOVE	A14,*A2,L
	RETS

PUT_IN_SCALE_AND_YPOS
	MOVE	A13,A2
	ADDI	#LIST_START,A2
POS_NEXT_OBJ
	MOVE	*A2+,A8,L
	JRZ	REACHED_END_OF_LIST
	MOVE	A1,*A8(OYPOS)
	MOVE	A3,*A8(OSCALE+010H)
	MOVE	A4,*A8(OSCALE)

	MOVE	*A8(OMISC),A7
	MOVI	10000H,A5
	DIVU	A4,A5
	MPYU	A5,A7
	SRL	8,A7

	ADDI	200,A7
	MOVE	A7,*A8(OXPOS)

	JRUC	POS_NEXT_OBJ
REACHED_END_OF_LIST
	RETS


;IN
;A9=ANGLE
;OUT
;A1=Y_COOR
;A3=Y SCALE
;A4=X SCALE

Y_CENTER	.EQU	070H

WORK_OUT_LINE_Y_AND_SCALE
	MOVE	A9,A14
	SLL	4,A14
	ADDI	SIN_TABLE,A14
	MOVE	*A14,A1

	NEG	A1
	SLL	32-8,A1
	SRL	32-8,A1
	MOVE	A1,A5

	MOVI	Y_CENTER,A3
	MPYS	A3,A1
	SRL	8,A1

	CMPI	90,A9
	JRLT	Y_POSITION_CORRECT
	MOVI	Y_CENTER,A0
	SUB	A1,A0
	MOVE	A0,A1
	ADDI	Y_CENTER,A1
Y_POSITION_CORRECT
	ADDI	10,A1

	MOVI	10000H,A3
	DIVU	A5,A3

	CMPI	0B00H,A3
	JRLT	NO_SCALE_PROBLEM
	MOVI	0B00H,A3
NO_SCALE_PROBLEM

	MOVE	A3,A5
	SUBI	100H,A5
	movk	18H,A7
	DIVU	A7,A5
	ADDI	100H,A5
	MOVE	A5,A4

	RETS

;this sin table is in decimal and goes from sin(0) to sin (89). It has been
;multiplyed by 256 in order to get an interger figure for each value. To
;implement, use the angle as an offset into the table and then multiply
;radius by value gained. Then divide result by 256 (ie rotate right 8 bits)
;and you have your value. To use as a cosine table use offset as a negative
;offset (-1) and come in from end of table backwards.O.K.!!!
SIN_TABLE:
	.WORD	255,255,255,255,254,254,253,253,252,252
	.WORD	251,250,249,248,247,246,244,243,242,240
	.WORD	238,237,235,233,232,230,228,226,223,221
	.WORD	219,217,214,212,209,207,204,201,198,196
	.WORD	193,190,187,184,181,177,174,171,167,164
	.WORD	161,157,154,150,146,143,139,135,131,128
	.WORD	124,120,116,112,108,104,100,95,91,87
	.WORD	83,79,74,70,66,61,57,53,48,44
	.WORD	40,35,31,26,22,17,13,8,4,1

	.WORD	4,8,13,17,22,26,31,35,40
	.WORD	44,48,53,57,61,66,70,74,79,83
	.WORD	87,91,95,100,104,108,112,116,120,124
	.WORD	128,131,135,139,143,146,150,154,157,161
	.WORD	164,167,171,174,177,181,184,187,190,193
	.WORD	196,198,201,204,207,209,212,214,217,219
	.WORD	221,223,226,228,230,232,233,235,237,238
	.WORD	240,242,243,244,246,247,248,249,250,251
    	.WORD	252,252,253,253,254,254,255,255,255,255
	.WORD	255


#*******************************
* Look at the buttons, read a sequence table,
* and set octopus2 flag if sequence successful


 SUBR	ck_octopus2

	clr	a10
	movi	butn_lst,a9

#lp	SLEEPK	1

;	move	@SWITCH,a0
	move	@_switch_addr,a0,L
	move	*a0,a0
	zext	a0
	cmpi	>ffff,a0
	jrnz	#tag1
	clr	a11
	jruc	#lp

#tag1	move	a11,a11
	jrnz	#lp

	inc	a11

	move	*a9,a1,W
	zext	a1
	cmp	a0,a1
	jrz	#yes
	movi	butn_lst,a9
	jruc	#lp
#yes	addk	16,a9
	move	*a9,a0
	jrnz	#lp
	movk	1,a0
	move	a0,@octopus2

	DIE

butn_lst

;Buttons required for 2nd octopus:
P1_P	.EQU	0FFEFH
P1_PP	.EQU 	0FFBFH
P1_B	.EQU	0FFDFH
P2_P	.EQU	0EFFFH
P2_PP	.EQU 	0BFFFH
P2_B	.EQU	0DFFFH


	.word	P1_P,P1_P,P1_P,P1_PP,P1_PP,P1_B
	.word	P2_PP,P2_PP,P2_PP,P2_P,P2_P,P2_B,0

******************************************************************************
*
* Called every tick by wrestler_main
*
* Figure out if we should be getting hurt for being out of the ring.  If
* we should, administer the damage and, if we die from it, fire off the
* round end stuff.
*
* Old method:  DEC_TIMER is ticks before you start taking hurts.  When you're
* thrown from the ring, it's set.  Also, when anyone else climbs into the
* ring, it's reset.  If you're out alone and this is zero, you take hurts
* on every eighth tick.
*
* New method:  RING_TIME holds the number of consecutive ticks you've been
* inside the ring.  If you're outside, the count is negative.  If you've been
* outside the ring for #out_time ticks and every member of the other team
* has been inside for #out_time, you take hurts.  Note that this includes
* both live and dead members of the other team.  If someone dies while
* outside the ring, their RING_TIME is set to 1 and increments from there
* as though he was inside the ring, so that when you kill one member of
* a team outside, you don't immediately start taking damage if all his
* teammates are cowering inside the ring.  The clock is ticking, though.
* As before, lose one health point every eight ticks.
*
* Complications:  Sometimes dead drones get their processes KO'd.  This means
* that their RING_TIMEs stop incrementing.  In the loop where we check
* opponent RING_TIMEs, check for sleeping drones and subtract their PTIME
* from 7FFF (the initial KO value) and add this value to their RING_TIME.
*

#out_time	.equ	TSEC*7

 SUBRP	do_ringout_dufus
	move	@ring_out_on,a14
	jrnz	#drd_exit
	cmpi	-(#out_time-(TSEC*3)),a0	; Has he been out for 4 secs?
	jrge	#drd_exit		; br = no
	PUSH	a0,a1,a2,a3,a7,a9,a10

	move	*a13(PLYR_SIDE),a0	; Check to see if opp are out?
	movk	NUM_WRES,a1
	movi	process_ptrs,a2

#loopa	move	*a2+,a3,L
	jrz	#nxta			;skip - inactive

	move	*a3(PLYR_SIDE),a14
	cmp	a14,a0
	jreq	#nxta			;skip - teammate

	move	*a3(RING_TIME),a14
	cmpi	#out_time-(TSEC*3),a14		;In ring > 4 seconds?
	jrle	#drd_done		;no pain - opponent not inside long enough

#nxta
	dsj	a1,#loopa
#do_dufus
;	move	a1,a1
;	jrz	#drd_done

	movk	3,a9			;msg number "Get back in dummy"
	move	a13,a10			;Player process ptr
	CREATE	4000h|AWARD_PID,dufus_msg_on
#drd_done
	PULL	a0,a1,a2,a3,a7,a9,a10
#drd_exit
	rets


;a9 = *player going over ropes
 SUBRP	kill_when_hit_ground
	move	*a9(GROUND_Y),a10
	move	*a9(OBJ_YPOSINT),a11
	cmp	a10,a11
	jrz	#kill_him
	SLEEPK	1
	jruc	kill_when_hit_ground
#kill_him
	movi	-150,a0
	move	*a9(PLYRNUM),a1
	clr	a10
	calla	adjust_health
	DIE


 SUBR	ARE_WE_IN_RING

	;don't do anthing if HALT is set
	move	@HALT,a14
	jrnz	#done

	;first see if we're dead - that uses a special routine
	move	*a13(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#dead

	;see if all our opponents are dead - the short way to do this
	; is to check closest_num, since dead ones will never be picked
	; if there are any live ones.
	move	*a13(CLOSEST_NUM),a14
	X32	a14
	addi	process_ptrs,a14
	move	*a14,a14,L
	move	*a14(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#done

	;adjust RING_TIME
	move	*a13(RING_TIME),a0
	jrn	#p_out

	;we were inside last tick
	inc	a0
	move	*a13(INRING),a14
	jrz	#rt_ok

	;we've moved outside.  init to -1
	movi	-1,a0
	move	@ring_out_on,a14
	jrz	#ring_outs_off
	move	a13,a9
	CREATE0	kill_when_hit_ground
#ring_outs_off
	jruc	#rt_ok

#p_out	;we were outside last tick
	dec	a0
	move	*a13(INRING),a14
	jrnz	#rt_ok

	;we've moved inside.  init to 1
	movk	1,a0
;	jruc	#rt_ok

#rt_ok	;a0 is now set to new RING_TIME.  write it back
	move	a0,*a13(RING_TIME)

	;quit if RING_TIME is greater than (or equal to) #out_time, which
	; means we're either inside our haven't been outside long enough
	; to get hurt.
	callr	do_ringout_dufus

	cmpi	-#out_time,a0
	jrge	#done

	;proceed only on every eighth tick, for a loss rate of around
	; 7 pixels per second.
	move	@PCNT,a14	;check low three bits of PCNT
	sll	32-3,a14
	jrnz	#done

	;uh-oh.  potential pain here.  loop through wrestler procs, and
	; quit if we spot anyone from the other team with a RING_TIME less
	; than or equal to #out_time, means that they're either outside
	; or haven't been inside long enough for us to get hurt.
	move	*a13(PLYR_SIDE),a0
	movk	NUM_WRES,a1
	movi	process_ptrs,a2

#loop0	move	*a2+,a3,L
	jrz	#nxt0		;skip - inactive

	move	*a3(PLYR_SIDE),a14
	cmp	a14,a0
	jreq	#nxt0		;skip - teammate

	move	*a3(RING_TIME),a14

	;if opponent is a sleeping drone, add (7fff-PTIME) to a14.
	move	*a3(PTIME),a4
	cmpi	1,a4
	jreq	#nosleephack
	;sleeping drone
	neg	a4
	addi	>7FFF,a4
	add	a4,a14
#nosleephack

	cmpi	#out_time,a14
	jrle	#done		;no pain - opponent not inside long enough

#nxt0	dsj	a1,#loop0

	;if we've fallen through to here, it's time to take some hurt.
	movi	-1,a0
	move	*a13(PLYRNUM),a1
	clr	a10
	calla	adjust_health
	jrnc	#done		;still alive

	;DEATH BY RING-OUT!
	;do we need to start an animation here or does adjust_health take
	; care of that for us?
#ring_out_death
	SETMODE	DEAD

	;if we have any living teammates, go home right now.  if we're 
	; the only one left, do the disqual stuff.

	;loop through processes looking for a living teammate (or a zombie)
	move	*a13(PLYR_SIDE),a0
	movk	NUM_WRES,a1
	movi	process_ptrs,a2

#loop1	move	*a2+,a3,L
	jrz	#nxt1		;skip - inactive

	cmp	a3,a13
	jreq	#nxt1		;skip - self

	move	*a3(PLYR_SIDE),a14
	cmp	a14,a0
	jrne	#nxt1		;skip - not a teammate

	move	*a3(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jrne	#done		;found a living teammate - skip disqual

	move	*a3(STATUS_FLAGS),a14
	btst	B_ZOMBIE,a14
	jrnz	#done		;found a zombie - skip disqual

#nxt1	dsj	a1,#loop1

	CREATE	CYCPID,CREATE_DISQUAL
	CREATE	ANNC_PID,announce_rnd_winner
	.if DEBUG
	move	a13,*a0(PDATA),L	;#CREATOR (pdata)
	movi	$,a14
	move	a14,*a0(PDATA+20h),L	;#ORIGIN
	.endif
#done	rets


#dead	;oops - we're dead.  If RING_TIME is negative, we've just died
	; outside the ring and we need to set it to 1.  If it's positive,
	; just increment it and go home
	move	*a13(RING_TIME),a0
	jrp	#inc
	clr	a0
#inc	inc	a0
	move	a0,*a13(RING_TIME)
	rets
	
#*****************************************************************************
* Stuff to deal with changed skirt pallettes

 SUBR	INIT_SKIRTS
	MOVI	SKIRTS_DEST,A9
	MOVK	4,A10
INIT_NEXT_SKIRT_PAL
	MOVE	*A9+,A0,L
	CALLA	pal_getf
	DSJS	A10,INIT_NEXT_SKIRT_PAL
	RETS

 SUBR	CHANGE_SKIRTS2
;	move	@match_cnt,a14
;	dec	a14
;	andi	07h,a14
;	janz	SUCIDE
	MOVE	@WHICH_SKIRT_PAL,A0
	JRUC	SKIRT_RENTER

 SUBR	CHANGE_SKIRTS
;	move	@match_cnt,a14
;	dec	a14
;	andi	07h,a14
;	janz	SUCIDE
	MOVE	@WHICH_SKIRT_PAL,A0
	JRZ	RANDOM_SKIRT
	DEC	A0
	JRUC	NO_NEED_TO_RAND_SKIRT

RANDOM_SKIRT
	MOVK	1,A0
	MOVE	A0,@WHICH_SKIRT_PAL

	movi	50,a0
	calla	RNDPER
	jals	SUCIDE

	MOVK	8,A0
	CALLA	RNDRNG0
NO_NEED_TO_RAND_SKIRT
	MOVE	A0,@WHICH_SKIRT_PAL
SKIRT_RENTER
	SLL	7,A0
	ADDI	SKIRTS,A0
	MOVE	A0,A8
	MOVI	SKIRTS_DEST,A9
	MOVI	CHANGE_NUMBERS,A11
	MOVK	4,A10
CHANGE_NEXT_PAL
	MOVE	*A9+,A0,L
	CALLA	pal_find
	SRL	7,A0
	SLL	7,A0
	MOVE	*A11+,A1
	OR	A0,A1
	MOVE	*A8+,A0,L
	ADDI	010H,A0
	MOVE	*A11+,A2
DO_PAL_AGAIN
	CALLA	pal_set
	JRNZ	SETUP_NEXT_ONE
;FOR SOME REASON WE CANT SEEM TO RE-DO THIS PAL
;JUST HIT "GO"
	.IF	DEBUG
	LOCKUP
	.ENDIF
	PUSHP	A0,A1,A2
	SLEEPK	1
	PULLP	A0,A1,A2
	JRUC	DO_PAL_AGAIN

SETUP_NEXT_ONE
	DSJS	A10,CHANGE_NEXT_PAL
	DIE

CHANGE_NUMBERS
	.WORD	0,21
	.WORD	0,32
	.WORD	30,48
	.WORD	0,38

SKIRTS_DEST
	.LONG	matl_P,NUGRND_P,NUGRND_P,DKCUR_P	;purple
SKIRTS
;BLUE_SKIRT
	.LONG	matl_P,NUGRND_P,CURTREDP,DKCURRP ;red
	.LONG	matl_P,NUGRND_P,NUGRND_P+(30*16),DKCUR_P ;purple
;RED_SKIRT
	.LONG	MTRIMRP,RSKIRTRP,CURTBLUP,DKCURBP ;blue
	.LONG	MTRIMRP,RSKIRTRP,NUGRND_P+(30*16),DKCUR_P ;purple
;BLACK_SKIRT
	.LONG	MTRIMWP,RSKIRTWP,CURTBLUP,DKCURBP ;blue
	.LONG	MTRIMWP,RSKIRTWP,NUGRND_P+(30*16),DKCUR_P ;purple
	.LONG	MTRIMWP,RSKIRTWP,CURTREDP,DKCURRP ;red
;PURPLE_SKIRT
	.LONG	MTRIMPP,RSKIRTPP,CURTBLUP,DKCURBP ;blue
	.LONG	MTRIMPP,RSKIRTPP,CURTREDP,DKCURRP ;red

CURTBLUP:
   .word   48 
   .word   00000h,02112h,01d12h,01cf1h,018d1h,018d0h,014d0h,014b0h
   .word   010afh,0108fh,00c8eh,00c6eh,00c6eh,0084dh,0084dh,0084ch
   .word   0042ch,0042ch,0042bh,0042bh,0042bh,0000bh,0000bh,0000ah
   .word   0000ah,0000ah,0000ah,0000ah,0000ah,00009h,00009h,00009h
   .word   00009h,00009h,00008h,00008h,00008h,00007h,00007h,00007h
   .word   00007h,00006h,00006h,00006h,00005h,00005h,00005h,00005h

CURTREDP:
   .word   48 
   .word   00000h,04508h,044e7h,040c6h,040c6h,040a5h,03c84h,03c84h
   .word   03c63h,03863h,03842h,03842h,03421h,03421h,03400h,03000h
   .word   03000h,03000h,02c00h,02c00h,02c00h,02c00h,02c00h,02800h
   .word   02800h,02800h,02800h,02800h,02400h,02400h,02400h,02400h
   .word   02400h,02400h,02000h,02000h,02000h,01c00h,01c00h,01c00h
   .word   01800h,01800h,01800h,01400h,01400h,01400h,01000h,01000h

DKCURBP:
   .word   38 
   .word   00000h,004aah,0048ah,00469h,0048ah,00469h,00449h,00448h
   .word   0044ah,00449h,00427h,00448h,00428h,00427h,00407h,00428h
   .word   00406h,00426h,00406h,00406h,00405h,00407h,00405h,00406h
   .word   00405h,00404h,00406h,00405h,00404h,00405h,00403h,00404h
   .word   00403h,00404h,00402h,00404h,00403h,00403h

DKCURRP:
   .word   38 
   .word   00000h,02400h,02400h,02400h,02400h,02400h,02400h,02400h
   .word   01c00h,01c00h,02400h,01c00h,01c00h,01c00h,01c00h,01c00h
   .word   01c00h,01c00h,01c00h,01c00h,01c00h,01400h,01c00h,01400h
   .word   01c00h,01c00h,01400h,01400h,01400h,01400h,01400h,01400h
   .word   01400h,01400h,01400h,00c00h,00c00h,00c00h

MTRIMPP:
   .word   21 
   .word   00000h,06ebeh,06a5dh,0661ch,061bch,05d7bh,0593ah,054f9h
   .word   054b8h,05078h,05037h,04c16h,03c14h,03811h,0300fh,02c0dh
   .word   0280ch,0240bh,0200ah,01c09h,01c08h

MTRIMRP:
   .word   21 
   .word   00000h,07f39h,07ab5h,07652h,071efh,06d8ch,06929h,064c6h
   .word   06084h,05c21h,05800h,05000h,04800h,04000h,03400h,03000h
   .word   03000h,02c00h,02800h,02800h,02400h

MTRIMWP:
   .word   21 
   .word   00000h,06f7bh,06739h,05ef8h,056b6h,04e74h,04633h,041f1h
   .word   039afh,0318eh,02d4ch,0294bh,0252ah,02509h,02108h,01ce8h
   .word   018c7h,018c6h,014a5h,01084h,00c63h

RSKIRTPP:
   .word   31 
   .word   00000h,06ebeh,06a7dh,0663ch,065fch,061bbh,0619ah,05d5ah
   .word   05d39h,058f8h,054d8h,05497h,05077h,05036h,04c16h,04c15h
   .word   04414h,04012h,03811h,0340fh,0300eh,0280ch,0240bh,01c0ah
   .word   0200ah,01c09h,01408h,01007h,00805h,00804h,00803h

RSKIRTRP:
   .word   31 
   .word   00000h,076b5h,07273h,07231h,06defh,06dadh,0698ch,0694ah
   .word   06529h,064e7h,060c6h,06084h,05c63h,05c42h,05800h,05800h
   .word   05000h,04c00h,04400h,04000h,03c00h,03400h,03000h,02800h
   .word   02400h,02000h,01800h,01400h,00c00h,00800h,00400h

RSKIRTWP:
   .word   31 
   .word   00000h,06b59h,06718h,05ef7h,05ad6h,05294h,04e73h,04a32h
   .word   04611h,03df0h,039cfh,035aeh,0316ch,02d4bh,0292ah,02509h
   .word   02109h,020e8h,01ce7h,01ce7h,01cc6h,018c6h,018c5h,014a5h
   .word   014a4h,01084h,01083h,01083h,00c63h,00c63h,00c63h

#********************************

 SUBR    BROKEN_ARM_BLOOD

	move	@no_debris,a14
	jrnz	#no_bab
	move	@reduce_bog,a14
	jrnz	#no_bab

	MOVE	*A13(WHOIHIT),A11,L
	movk	M_FLIPH,A9
	CREATE	DEBRIS_PID,DO_BLOOD_1

	CLR	A9
	CREATE	DEBRIS_PID,DO_BLOOD_1

	MOVK	2,A0
	CALLA	RNDRNG0
	INC	A0
	INC	A0
	MOVE	A0,A9
DO_ANOTHER_GLOBB
	CREATE	DEBRIS_PID,GLOB_BLOOD
	DSJS	A9,DO_ANOTHER_GLOBB

#no_bab	RETS

DO_BLOOD_1
	PUSH	A9
	CLR	A0
	CLR	A1
	movi	SPITUP01,a2
	CLR	A3
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	CALLA	BEGINOBJ
	move	a8,*a13(SP_OBJ),L

	MOVI	SPITPUS_P,A0
	CALLA	pal_getf
	MOVE	A0,*A8(OPAL)

	move	*a11(WRESTLERNUM),A10
	SLL	6,A10
	MOVI	ARM_TBL,A7
	ADD	A10,A7

	MOVE	*A8(OCTRL),A14
	PULL	A1
	OR	A1,A14
	MOVE	A14,*A8(OCTRL)
 	move	a14,*a13(SP_OBJCONTROL)

	MOVI	[0,8000h],A0
	ANDI	M_FLIPH,A14
	JRZ	IF_WE_NEED_TOB
	NEG	A0
IF_WE_NEED_TOB
	MOVE	A0,*A13(SP_OBJ_XVEL),L

	move	*a11(OBJ_ZPOS),A0,L
	SUBI	2,A0
	move	A0,*A13(SP_OBJ_ZPOS),L

	move	*a11(OBJ_XPOS),a0,L
	MOVE	*A7+,A1,L

	MOVE	*A11(OBJ_CONTROL),A14
	ANDI	M_FLIPH,A14
	JRZ	NO_NEG_XPOS
	NEG	A1
NO_NEG_XPOS
	add	A1,a0
	move	a0,*a13(SP_OBJ_XPOS),L

	MOVE	*a11(OBJ_YPOS),a0,L
	MOVE	*A7+,A1,L
	sub	A1,a0
	move	a0,*a13(SP_OBJ_YPOS),L

	MOVI	40000H,A0
	move	A0,*a13(SP_OBJ_YVEL),L

	MOVI	ARM_BLOOD,A9

	JRUC	RE_ENTER_FOR_BLOOD

 SUBRP	CREATE_SWEAT

	MOVE	@NUM_OPPS,A14
	CMPI	3,A14
	JREQ	NO_DO_SWEAT

	MOVE	*A8(010H),A0
	calla	RNDPER
	JRLS	NO_DO_SWEAT

 SUBRP	AUTOMATIC_SWEAT

	move	@no_debris,a14
	jrnz	NO_DO_SWEAT
	move	@reduce_bog,a14
	jrnz	NO_DO_SWEAT

	movk	2,A0
	CALLA	RNDRNG0
	INC	A0
	MOVE	@NUM_OPPS,A14
	CMPI	2,A14
	JRGT	NOT_SO_MUCH
	INC	A0
NOT_SO_MUCH
	MOVE	A0,A9
DO_ANOTHER_GLOB
	CREATE	DEBRIS_PID,GLOB_SWEAT
	DSJS	A9,DO_ANOTHER_GLOB

	push	a8

	CLR	A0
	CLR	A1
	movi	SPITUP01,a2
	CLR	A3
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	CALLA	BEGINOBJ
	move	a8,*a13(SP_OBJ),L

;	CALLR	WHICH_SWEAT_PAL

	pull	a7
	move	*a7,a9
	move	*a11(WRESTLERNUM),A10
	SLL	6,A10
	addi	WHICH_SWEAT,A9
	MOVE	*A9(020H),A7,L
	ADD	A10,A7

	MOVE	*A9,A0,L
	CMPI	SPRAYB,A0
	JRNE	NORMAL_SWEAT

	MOVE	*A11(OBJ_CONTROL),A14
	XORI	M_FLIPH,A14
	ORI	DMAWNZ,A14
 	move	a14,*a13(SP_OBJCONTROL)
	MOVE	A14,*A8(OCTRL)

	MOVI	[3,0],A0
	ANDI	M_FLIPH,A14
	JRZ	IF_WE_NEED_TO
	NEG	A0
IF_WE_NEED_TO
	MOVE	A0,*A13(SP_OBJ_XVEL),L

	move	*a11(OBJ_ZPOS),A0,L
	SUBI	2,A0
	move	A0,*A13(SP_OBJ_ZPOS),L

	move	*a11(OBJ_XPOS),a0,L
	MOVE	*A7+,A1,L
	MOVE	*A11(OBJ_CONTROL),A14
	ANDI	M_FLIPH,A14
	jrz	NO_FLIP_X_POS
	NEG	A1
NO_FLIP_X_POS
	add	A1,a0
	move	a0,*a13(SP_OBJ_XPOS),L

	MOVE	*a11(OBJ_YPOS),a0,L
	MOVE	*A7+,A1,L
	sub	A1,a0
	move	a0,*a13(SP_OBJ_YPOS),L

	clr	a0
	move	a0,*a13(SP_OBJ_YVEL),L
RE_ENTER_FOR_BLOOD
	clr	a0
	move	a0,*a13(SP_SHADOW_OBJ),L


	MOVI	[2,0],A0
	CALLA	RNDRNG0
	SUBI	[1,0],A0
	MOVE	A0,*A13(SP_OBJ_ZVEL),L

	movi	0200h,a0
	move	a0,*a13(SP_GRAVITY),L

	clr	a0
	move	a0,*a13(SP_DIE)

	movi	60,a0
	move	a0,*a13(SP_LIFESPAN)

	move	*a13(SP_OBJ),a8,L

	MOVE	*A9,A0,L
	calla	sp_change_anim

#lp2

	SLEEPK	2

	CALLR	sp_velocity_add
	CALLR	sp_update_pos_single
	callr	sp_animate

	move	*a13(SP_DIE),a0
	jrz	#lp2

	move	*a13(SP_OBJ),a0,L
	calla	DELOBJ
NO_DO_SWEAT
	DIE

NORMAL_SWEAT

	MOVE	*A11(OBJ_CONTROL),A14
	ANDI	M_FLIPH,A14
	ORI	DMAWNZ,A14
 	move	a14,*a13(SP_OBJCONTROL)
	MOVE	A14,*A8(OCTRL)

	move	*a11(OBJ_ZPOS),A0,L
	SUBI	2,A0
	move	A0,*A13(SP_OBJ_ZPOS),L

	move	*a11(OBJ_XPOS),a0,L
	MOVE	*A7+,A1,L
	MOVE	*A11(OBJ_CONTROL),A14
	ANDI	M_FLIPH,A14
	jrz	NO_FLIP_X_POS4
	NEG	A1
NO_FLIP_X_POS4
	add	A1,a0
	move	a0,*a13(SP_OBJ_XPOS),L

	MOVE	*a11(OBJ_YPOS),a0,L
	MOVE	*A7+,A1,L
	sub	A1,a0
	move	a0,*a13(SP_OBJ_YPOS),L

	clr	a0
	move	a0,*a13(SP_SHADOW_OBJ),L
	move	a0,*a13(SP_OBJ_YVEL),L
	MOVE	A0,*A13(SP_OBJ_XVEL),L

	MOVI	[2,0],A0
	CALLA	RNDRNG0
	SUBI	[1,0],A0
	MOVE	A0,*A13(SP_OBJ_ZVEL),L

	movi	0200h,a0
	move	a0,*a13(SP_GRAVITY),L

	clr	a0
	move	a0,*a13(SP_DIE)

	movi	60,a0
	move	a0,*a13(SP_LIFESPAN)

	move	*a13(SP_OBJ),a8,L

	MOVE	*A9,A0,L

	CMPI	COUGH,A0
	JRNE	NO_RAND_COUGH
	MOVE	@ROLLING_COUNT,A14
	SRL	1,A14
	JRNC	NO_RAND_COUGH
	MOVI	SPITAN,A0
NO_RAND_COUGH
	calla	sp_change_anim

	JRUC	#lp2

WHICH_SWEAT_PAL
	MOVE	*A11(WRESTLERNUM),A0
	CMPI	2,A0
	JREQ	DO_BILE_PAL
	CMPI	5,A0
	JRNE	NO_NEW_SWEAT_PAL
	MOVI	SPITPUS_P,A0
	JRUC	GOT_NEW_PAL
DO_BILE_PAL
	MOVI	SPITBLE_P,A0
GOT_NEW_PAL
	CALLA	pal_getf
	MOVE	A0,*A8(OPAL)
NO_NEW_SWEAT_PAL
	RETS

GLOB_BLOOD

	CLR	A0
	CLR	A1
	movi	SPITUP01,a2
	CLR	A3
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	CALLA	BEGINOBJ
	move	a8,*a13(SP_OBJ),L

	MOVI	SPITPUS_P,A0
	CALLA	pal_getf
	MOVE	A0,*A8(OPAL)

	MOVE	*A11(OBJ_CONTROL),A14
	ANDI	M_FLIPH,A14
	ORI	DMAWNZ,A14
 	move	a14,*a13(SP_OBJCONTROL)
	MOVE	A14,*A8(OCTRL)

	move	*a11(WRESTLERNUM),A10
	SLL	6,A10
	MOVI	ARM_TBL,A7
	ADD	A10,A7

	move	*a11(OBJ_ZPOS),*A13(SP_OBJ_ZPOS),L

	move	*a11(OBJ_XPOS),a0,L
	MOVE	*A7+,A1,L
	MOVE	*A11(OBJ_CONTROL),A14
	ANDI	M_FLIPH,A14
	PUSHST
	jrz	NO_FLIP_X_POS2BB
	NEG	A1
NO_FLIP_X_POS2BB
	add	A1,a0
	move	a0,*a13(SP_OBJ_XPOS),L

	MOVE	*a11(OBJ_YPOS),a0,L
	MOVE	*A7+,A1,L
	sub	A1,a0
	move	a0,*a13(SP_OBJ_YPOS),L

	clr	a0
	move	a0,*a13(SP_SHADOW_OBJ),L

	movi	[4,0],a0
	calla	RNDRNG0
	SUBI	[2,0],A0
	move	a0,*a13(SP_OBJ_XVEL),L

	movi	[2,0],a0
	calla	RNDRNGS
	move	a0,*a13(SP_OBJ_ZVEL),L

	movi	[3,0],a0
	calla	RNDRNGS
	addi	[6,0],a0
	move	a0,*a13(SP_OBJ_YVEL),L

	movi	GRAVITY,a0
	move	a0,*a13(SP_GRAVITY),L

	move	*a11(GROUND_Y),a0
	sll	16,a0
	move	a0,*a13(SP_GROUND_Y),L

	clr	a0
	move	a0,*a13(SP_DIE)

	movi	60,a0
	move	a0,*a13(SP_LIFESPAN)

	move	*a13(SP_OBJ),a8,L
	movk	11,A0
	CALLA	RNDRNG0
	SLL	6,A0
	POPST
	JRN	NO_NEED_TO_USE_RIGHT_ANIMB
	ADDI	020H,A0
NO_NEED_TO_USE_RIGHT_ANIMB
	ADDI	WHICH_GLOB,A0
	MOVE	*A0,A0,L
	calla	sp_change_anim
	jruc	glob_loop

 SUBR	SPIN_SWEAT
	move	@no_debris,a14
	jrnz	NO_DO_SWEAT
	move	@reduce_bog,a14
	jrnz	NO_DO_SWEAT
	MOVE	*A8(010H),A9
	JRZ	NO_DO_SWEAT
ANOTHER_GLOB
	CREATE	DEBRIS_PID,SPECIAL_GLOB_SWEAT
	DSJS	A9,ANOTHER_GLOB
	DIE

 SUBRP	SPECIAL_GLOB_SWEAT	;process

	movi	SPECIAL_GLOB_SWEAT,a14
	move	a14,*a13(PROC_ORIGIN),L

	push	a8

	CLR	A0
	CLR	A1
	movi	SPITUP01,a2
	CLR	A3
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	CALLA	BEGINOBJ
	move	a8,*a13(SP_OBJ),L

 	move	*A8(OCTRL),*a13(SP_OBJCONTROL)

	pull	a7
	move	*a7,a7
	SLL	7,A7
	ADDI	SPIN_SWEAT_ORIG,A7

	MOVE	*A7+,A1,L
	MOVE	*A11(OBJ_CONTROL),A14,L
	ANDI	M_FLIPH,A14
	JRNZ	NO_NEG_XPOS_START
	NEG	A1
NO_NEG_XPOS_START
	move	*a11(OBJ_XPOS),a0,L
	PUSHST
	add	A1,a0
	move	a0,*a13(SP_OBJ_XPOS),L

	MOVE	*a11(OBJ_ZPOS),a0,L
	MOVE	*A7+,A1,L
	ADD	A1,a0
	move	a0,*a13(SP_OBJ_ZPOS),L

	MOVE	*a11(OBJ_YPOS),a0,L
	ADDI	[64,0],A0
	MOVE	A0,*A13(SP_OBJ_YPOS),L

	MOVE	*A7+,A1,L
	MOVE	*A11(OBJ_CONTROL),A14,L
	ANDI	M_FLIPH,A14
	JRNZ	NO_NEG_XVEL_START
	NEG	A1
NO_NEG_XVEL_START
	move	a1,*a13(SP_OBJ_XVEL),L

	MOVE	*A7+,A0,L
	move	a1,*a13(SP_OBJ_ZVEL),L
	JRUC	GLOB_SWEAT_REENTER

SPIN_SWEAT_ORIG
	.LONG	[-120,0],[1,0],[-4,0],[0,0]
	.LONG	[-60,0],[-1,0],[-2,0],[-3,0]
	.LONG	[-30,0],[-1,0],[-1,0],[-6,0]
	.LONG	[0,0],[-1,0],[0,0],[-10,0]
	.LONG	[30,0],[-1,0],[1,0],[-6,0]
	.LONG	[70,0],[-1,0],[2,0],[-3,0]
	.LONG	[120,0],[1,0],[4,0],[0,0]
	.LONG	[70,0],[3,0],[2,0],[3,0]
	.LONG	[30,0],[3,0],[1,0],[6,0]
	.LONG	[0,0],[3,0],[0,0],[10,0]
	.LONG	[-50,0],[3,0],[-2,0],[6,0]

#*****************************************************************************

 SUBRP	GLOB_SWEAT	;process

	movi	GLOB_SWEAT,a14
	move	a14,*a13(PROC_ORIGIN),L

	push	a8

	CLR	A0
	CLR	A1
	movi	SPITUP01,a2
	CLR	A3
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	CALLA	BEGINOBJ
	move	a8,*a13(SP_OBJ),L

;	CALLR	WHICH_SWEAT_PAL

	MOVE	*A11(OBJ_CONTROL),A14
	ANDI	M_FLIPH,A14
	ORI	DMAWNZ,A14
 	move	a14,*a13(SP_OBJCONTROL)
	MOVE	A14,*A8(OCTRL)

	pull	a7
	move	*a7,a9
	move	*a11(WRESTLERNUM),A10
	SLL	6,A10
	addi	WHICH_SWEAT,A9
	MOVE	*A9(020H),A7,L
	ADD	A10,A7

	move	*a11(OBJ_ZPOS),*A13(SP_OBJ_ZPOS),L

	move	*a11(OBJ_XPOS),a0,L
	MOVE	*A7+,A1,L
	MOVE	*A11(OBJ_CONTROL),A14
	ANDI	M_FLIPH,A14
	PUSHST
	jrz	#NO_FLIP_X_POS2
	NEG	A1
#NO_FLIP_X_POS2
	add	A1,a0
	move	a0,*a13(SP_OBJ_XPOS),L

	MOVE	*a11(OBJ_YPOS),a0,L
	MOVE	*A7+,A1,L
	sub	A1,a0
	move	a0,*a13(SP_OBJ_YPOS),L

	movi	[4,0],a0
	calla	RNDRNG0
	ADDI	[1,0],A0
	POPST
	JRNZ	#NO_FLIP_ANIM_XVEL
	NEG	A0
#NO_FLIP_ANIM_XVEL
	MOVE	A0,A0
	move	a0,*a13(SP_OBJ_XVEL),L
	PUSHST

	movi	[2,0],a0
	calla	RNDRNGS
	move	a0,*a13(SP_OBJ_ZVEL),L

GLOB_SWEAT_REENTER
	clr	a0
	move	a0,*a13(SP_SHADOW_OBJ),L

	movi	[3,0],a0
	calla	RNDRNGS
	addi	[6,0],a0
	move	a0,*a13(SP_OBJ_YVEL),L

	movi	GRAVITY,a0
	move	a0,*a13(SP_GRAVITY),L

	move	*a11(GROUND_Y),a0
	sll	16,a0
	move	a0,*a13(SP_GROUND_Y),L

	clr	a0
	move	a0,*a13(SP_DIE)

	movi	60,a0
	move	a0,*a13(SP_LIFESPAN)

	move	*a13(SP_OBJ),a8,L
	movk	11,A0
	CALLA	RNDRNG0
	SLL	6,A0
	POPST
	JRN	#NO_NEED_TO_USE_RIGHT_ANIM
	ADDI	020H,A0
#NO_NEED_TO_USE_RIGHT_ANIM
	ADDI	WHICH_GLOB,A0
	MOVE	*A0,A0,L
	calla	sp_change_anim

glob_loop
	SLEEPK	1

	CALLR	sp_velocity_add

	CALLR	sp_update_pos_single

	callr	sp_animate

	move	*a13(SP_OBJ_YVEL),a0,L	;must have down velocity
	JRZ	#no_gnd

	move	*a13(SP_OBJ_YPOSINT),a0
	move	*a13(SP_GROUND_Y+10h),a1
	cmp	a1,a0			;a0-a1
	jrgt	#no_gnd

	sll	16,a1
	move	a1,*a13(SP_OBJ_YPOS),L

	CLR	A0
	MOVE	A0,*A13(SP_OBJ_YVEL),L
	MOVE	A0,*A13(SP_OBJ_XVEL),L
	MOVE	A0,*A13(SP_OBJ_ZVEL),L
	move	a0,*a13(SP_GRAVITY),L

	MOVI	SPLASH_A,A0
	move	@ROLLING_COUNT,A14
	SRL	1,A14
	JRNC	#GOT_RIGHT_SPLASH_ANIM
	MOVI	SPLASH_B,A0
#GOT_RIGHT_SPLASH_ANIM

	calla	sp_change_anim
#no_gnd
	move	*a13(SP_DIE),a0
	jrz	glob_loop

	move	*a13(SP_OBJ),a0,L
	calla	DELOBJ
	DIE

#*****************************************************************************

WHICH_GLOB
	.LONG	WAD_AL,WAD_AR
	.LONG	WAD_AL,WAD_AR
	.LONG	WAD_AL,WAD_AR
	.LONG	WAD_BL,WAD_BR
	.LONG	WAD_BL,WAD_BR
	.LONG	WAD_CL,WAD_CR
	.LONG	WAD_DL,WAD_DR
	.LONG	WAD_DL,WAD_DR
	.LONG	WAD_EL,WAD_ER
	.LONG	WAD_FL,WAD_FR
	.LONG	WAD_FL,WAD_FR
	.LONG	WAD_FL,WAD_FR

WHICH_SWEAT
	.LONG	SPITUP,SPITUP_TBL
	.LONG	SPRAYB,SPRAYA_TBL
ARM_BLOOD
	.LONG	SPRAYB,SPRAYA_TBL
	.LONG	SPRAYC,SPRAYA_TBL
	.LONG	COUGH,COUGH_TBL
	.LONG	SPRAYC,SPRAYD_TBL

SPITUP
	WL	1,SPITUP01
	WL	1,SPITUP02
	WL	1,SPITUP03
	WL	1,SPITUP04
	WL	1,SPITUP05
	WL	1,SPITUP06
	WL	1,SPITUP07
	WL	1,SPITUP08
	WL	1,SPITUP09
	.WORD	08002h

SPITUP_TBL
	.LONG	[19,0],[-41,0]	;BRET
	.LONG	[37,0],[-35,0]	;RAZOR
	.LONG	[33,0],[-31,0]	;TAKER
	.LONG	[47,0],[-31,0]	;YOKO
	.LONG	[37,0],[-27,0]	;SHAWN
	.LONG	[55,0],[-35,0]	;BAM BAM
	.LONG	[45,0],[-29,0]	;DOINK
	.LONG	0,0	;SPARE
	.LONG	[25,0],[-31,0]	;LEX

SPRAYA_TBL
	.LONG	[-5,0],[-109,0]	;BRET
	.LONG	[0,0],[-109,0]	;RAZOR
	.LONG	[-2,0],[-109,0]	;TAKER
	.LONG	[-7,0],[-97,0]	;YOKO
	.LONG	[-6,0],[-98,0]	;SHAWN
	.LONG	[-3,0],[-109,0]	;BAM BAM
	.LONG	[11,0],[-90,0]	;DOINK
	.LONG	0,0	;SPARE
	.LONG	[-9,0],[-103,0]	;LEX

SPRAYD_TBL
	.LONG	[-60,0],[-40,0]	;BRET
	.LONG	[-50,0],[-80,0]	;RAZOR
	.LONG	[60,0],[-100,0]	;TAKER
	.LONG	[-40,0],[-100,0] ;YOKO
	.LONG	[-60,0],[-40,0]	;SHAWN
	.LONG	[-60,0],[-40,0]	;BAM BAM
	.LONG	[-60,0],[-40,0]	;DOINK
	.LONG	0,0	;SPARE
	.LONG	[-60,0],[-40,0]	;LEX

ARM_TBL
	.LONG	[18,0],[-124,0]	;BRET
	.LONG	[24,0],[-120,0]	;RAZOR
	.LONG	[30,0],[-124,0]	;TAKER
	.LONG	[22,0],[-110,0]	;YOKO
	.LONG	[14,0],[-118,0]	;SHAWN
	.LONG	[20,0],[-120,0]	;BAM BAM
	.LONG	[16,0],[-110,0]	;DOINK
	.LONG	0,0	;SPARE
	.LONG	[16,0],[-128,0]	;LEX

SPRAYB
	WL	1,SPRAYB01
	WL	1,SPRAYB02
	WL	1,SPRAYB03
	WL	1,SPRAYB04
	WL	1,SPRAYB05
	WL	1,SPRAYB06
	WL	1,SPRAYB07
	WL	1,SPRAYB08
	.WORD	08002h

SPRAYC
	WL	1,SPRAYC01
	WL	1,SPRAYC02
	WL	1,SPRAYC03
	WL	1,SPRAYC04
	WL	1,SPRAYC05
	WL	1,SPRAYC06
	WL	1,SPRAYC07
	WL	1,SPRAYC08
	WL	1,SPRAYC09
	WL	1,SPRAYC10
	.WORD	08002h

COUGH
	WL	1,COUGHA01
	WL	1,COUGHA02
	WL	1,COUGHA03
	WL	1,COUGHA04
	WL	1,COUGHA05
	WL	1,COUGHA06
	WL	1,COUGHA07
	WL	1,COUGHA08
	WL	1,COUGHA09
	.WORD	08002h

SPITAN
	WL	1,SPITAN01
	WL	1,SPITAN02
	WL	1,SPITAN03
	WL	1,SPITAN04
	WL	1,SPITAN05
	WL	1,SPITAN06
	WL	1,SPITAN07
	WL	1,SPITAN08
	WL	1,SPITAN09
	.WORD	08002h

COUGH_TBL
	.LONG	[23,0],[-71,0]	;BRET
	.LONG	[33,0],[-81,0]	;RAZOR
	.LONG	[21,0],[-93,0]	;TAKER
	.LONG	[33,0],[-77,0]	;YOKO
	.LONG	[27,0],[-73,0]	;SHAWN
	.LONG	[33,0],[-77,0]	;BAM BAM
	.LONG	[29,0],[-77,0]	;DOINK
	.LONG	0,0	;SPARE
	.LONG	[33,0],[-73,0]	;LEX

WAD_AL
	WL	2,WAD_A_01
	WL	2,WAD_A_02
	WL	2,WAD_A_03
	WL	2,WAD_A_04
	WL	2,WAD_A_05
	WL	2,WAD_A_06
	WL	2,WAD_A_07
	WL	2,WAD_A_08
	WL	2,WAD_A_09
	.word	ASP_REPEAT

WAD_BL
	WL	2,WAD_B_01
	WL	2,WAD_B_02
	WL	2,WAD_B_03
	WL	2,WAD_B_04
	WL	2,WAD_B_05
	WL	2,WAD_B_06
	WL	2,WAD_B_07
	WL	2,WAD_B_08
	WL	2,WAD_B_09
	.word	ASP_REPEAT

WAD_CL
	WL	2,WAD_C_01
	WL	2,WAD_C_02
	WL	2,WAD_C_03
	WL	2,WAD_C_04
	WL	2,WAD_C_05
	WL	2,WAD_C_06
	WL	2,WAD_C_07
	WL	2,WAD_C_08
	WL	2,WAD_C_09
	WL	2,WAD_C_11
	WL	2,WAD_C_12
	.word	ASP_REPEAT

WAD_DL
	WL	2,WAD_D_01
	WL	2,WAD_D_02
	WL	2,WAD_D_03
	WL	2,WAD_D_04
	.word	ASP_REPEAT

WAD_EL
	WL	2,WAD_E_01
	WL	2,WAD_E_02
	WL	2,WAD_E_03
	WL	2,WAD_E_04
	WL	2,WAD_E_05
	WL	2,WAD_E_06
	WL	2,WAD_E_07
	WL	2,WAD_E_08
	WL	2,WAD_E_09
	WL	2,WAD_E_10
	WL	2,WAD_E_11
	.word	ASP_REPEAT

WAD_FL
	WL	2,WAD_F_01
	WL	2,WAD_F_02
	WL	2,WAD_F_03
	WL	2,WAD_F_04
	WL	2,WAD_F_05
	WL	2,WAD_F_06
	WL	2,WAD_F_07
	WL	2,WAD_F_08
	WL	2,WAD_F_09
	.word	ASP_REPEAT


WAD_AR
	WL	2,WAD_A_09
	WL	2,WAD_A_08
	WL	2,WAD_A_07
	WL	2,WAD_A_06
	WL	2,WAD_A_05
	WL	2,WAD_A_04
	WL	2,WAD_A_03
	WL	2,WAD_A_02
	WL	2,WAD_A_01
	.word	ASP_REPEAT

WAD_BR
	WL	2,WAD_B_09
	WL	2,WAD_B_08
	WL	2,WAD_B_07
	WL	2,WAD_B_06
	WL	2,WAD_B_05
	WL	2,WAD_B_04
	WL	2,WAD_B_03
	WL	2,WAD_B_02
	WL	2,WAD_B_01
	.word	ASP_REPEAT

WAD_CR
	WL	2,WAD_C_12
	WL	2,WAD_C_11
	WL	2,WAD_C_09
	WL	2,WAD_C_08
	WL	2,WAD_C_07
	WL	2,WAD_C_06
	WL	2,WAD_C_05
	WL	2,WAD_C_04
	WL	2,WAD_C_03
	WL	2,WAD_C_02
	WL	2,WAD_C_01
	.word	ASP_REPEAT

WAD_DR
	WL	2,WAD_D_04
	WL	2,WAD_D_03
	WL	2,WAD_D_02
	WL	2,WAD_D_01
	.word	ASP_REPEAT

WAD_ER
	WL	2,WAD_E_11
	WL	2,WAD_E_10
	WL	2,WAD_E_09
	WL	2,WAD_E_08
	WL	2,WAD_E_07
	WL	2,WAD_E_06
	WL	2,WAD_E_05
	WL	2,WAD_E_04
	WL	2,WAD_E_03
	WL	2,WAD_E_02
	WL	2,WAD_E_01
	.word	ASP_REPEAT

WAD_FR
	WL	2,WAD_F_09
	WL	2,WAD_F_08
	WL	2,WAD_F_07
	WL	2,WAD_F_06
	WL	2,WAD_F_05
	WL	2,WAD_F_04
	WL	2,WAD_F_03
	WL	2,WAD_F_02
	WL	2,WAD_F_01
	.word	ASP_REPEAT

SPLASH_A
	WL	2,SPLSHA01
	WL	2,SPLSHA02
	WL	2,SPLSHA03
	WL	2,SPLSHA04
	WL	2,SPLSHA05
	WL	2,SPLSHA06
	.WORD	08002h

SPLASH_B
	WL	2,SPLSHB01
	WL	2,SPLSHB02
	WL	2,SPLSHB03
	WL	2,SPLSHB04
	WL	2,SPLSHB05
	WL	2,SPLSHB06
	.WORD	08002h

 SUBR	DO_EYES
	;quit if no_debris is set
;	move	@no_debris,a14
;	jrnz	#rets
;	move	@reduce_bog,a14
;	jrnz	#rets

	MOVE	A13,A11
	movk	3,A0
	CALLA	RNDRNG0
	INC	A0
	INC	A0
	MOVE	A0,A9
DO_ANOTHER_EYE
	CREATE	DEBRIS_PID,CREATE_EYES
	DSJS	A9,DO_ANOTHER_EYE
#rets	RETS

CREATE_EYES
	CLR	A0
	CLR	A1
	movi	SPITUP01,a2
	CLR	A3
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	CALLA	BEGINOBJ
	move	a8,*a13(SP_OBJ),L

	MOVE	*A11(OBJ_CONTROL),A14
	ANDI	M_FLIPH,A14
	ORI	DMAWNZ,A14
 	move	a14,*a13(SP_OBJCONTROL)
	MOVE	A14,*A8(OCTRL)

	move	*a11(OBJ_ZPOS),*A13(SP_OBJ_ZPOS),L

	move	*a11(OBJ_XPOS),a0,L
	MOVI	[30H,0],A1
	MOVE	*A11(OBJ_CONTROL),A14
	BTST	B_FLIPH,A14
	PUSHST
	jrz	NO_FLIP_X_POS2E
	NEG	A1
NO_FLIP_X_POS2E
	add	A1,a0
	move	a0,*a13(SP_OBJ_XPOS),L

	MOVE	*a11(OBJ_YPOS),a0,L
	MOVI	[-100,0],A1
	sub	A1,a0
	move	a0,*a13(SP_OBJ_YPOS),L

	clr	a0
	move	a0,*a13(SP_SHADOW_OBJ),L

	movi	[1,0],a0
	calla	RNDRNG0
	ADDI	[1,0],A0
	POPST
	JRNZ	NO_FLIP_ANIM_XVELE
	NEG	A0
NO_FLIP_ANIM_XVELE
	MOVE	A0,A0
	move	a0,*a13(SP_OBJ_XVEL),L
	PUSHST

	CLR	A0
	move	a0,*a13(SP_OBJ_ZVEL),L

	movi	[3,0],a0
	calla	RNDRNGS
	addi	[6,0],a0
	move	a0,*a13(SP_OBJ_YVEL),L

	movi	GRAVITY,a0
	move	a0,*a13(SP_GRAVITY),L

	move	*a11(GROUND_Y),a0
	sll	16,a0
	move	a0,*a13(SP_GROUND_Y),L

	clr	a0
	move	a0,*a13(SP_DIE)

	movi	120,a0
	move	a0,*a13(SP_LIFESPAN)

	move	*a13(SP_OBJ),a8,L
	movk	1,A0
	CALLA	RNDRNG0
	SLL	6,A0
	POPST
	JRN	NO_NEED_TO_USE_RIGHT_ANIME
	ADDI	020H,A0
NO_NEED_TO_USE_RIGHT_ANIME
	ADDI	WHICH_EYE,A0
	MOVE	*A0,A0,L
	calla	sp_change_anim
#lp4
	SLEEPK	1

	CALLR	sp_velocity_add
	CALLR	sp_update_pos_single
	callr	sp_animate

	move	*a13(SP_OBJ_YPOSINT),a0
	move	*a13(SP_GROUND_Y+10h),a1
	cmp	a1,a0			;a0-a1
	jrgt	#no_gnd2

	MOVE	A1,*A13(SP_OBJ_YPOSINT)
	MOVE	*A13(SP_OBJ_YVEL),A1,L
	MOVE	A1,A0
	SRA	2,A1
	SUB	A1,A0
	NEG	A0
	MOVE	A0,*A13(SP_OBJ_YVEL),L

#no_gnd2
	move	*a13(SP_LIFESPAN),a0
	DEC	A0
	move	A0,*a13(SP_LIFESPAN)
	jrnz	#lp4

	move	*a13(SP_OBJ),a0,L
	calla	DELOBJ
	DIE

WHICH_EYE
	.LONG	SMALL_EYE_L,SMALL_EYE_R
	.LONG	BIG_EYE_L,BIG_EYE_R

SMALL_EYE_L
	WL	2,BIGEYE01
	WL	2,BIGEYE02
	WL	2,BIGEYE03
	WL	2,BIGEYE04
	WL	2,BIGEYE05
	WL	2,BIGEYE06
	WL	2,BIGEYE07
	WL	2,BIGEYE08
	.word	ASP_REPEAT
SMALL_EYE_R
	WL	2,BIGEYE08
	WL	2,BIGEYE07
	WL	2,BIGEYE06
	WL	2,BIGEYE05
	WL	2,BIGEYE04
	WL	2,BIGEYE03
	WL	2,BIGEYE02
	WL	2,BIGEYE01
	.word	ASP_REPEAT
BIG_EYE_L
	WL	2,BIGEYE01
	WL	2,BIGEYE02
	WL	2,BIGEYE03
	WL	2,BIGEYE04
	WL	2,BIGEYE05
	WL	2,BIGEYE06
	WL	2,BIGEYE07
	WL	2,BIGEYE08
	.word	ASP_REPEAT
BIG_EYE_R
	WL	2,BIGEYE08
	WL	2,BIGEYE07
	WL	2,BIGEYE06
	WL	2,BIGEYE05
	WL	2,BIGEYE04
	WL	2,BIGEYE03
	WL	2,BIGEYE02
	WL	2,BIGEYE01
	.word	ASP_REPEAT

******************************************************************************
;we need these

SPITPUS_P:
	.word	 22
	.word	00H,07FD8H,07B95H,07752H,07331H,06F0FH,06AEEH,066CCH
	.word	066CBH,062AAH,05E88H,05A67H,05A66H,05645H,05224H,04E03H
	.word	049E2H,045C2H,041A1H,03D80H,03960H,03940H

SPITBLE_P:
	.word	 22
	.word	00H,06FB5H,06B93H,06371H,05F4FH,05B4DH,0572BH,05309H
	.word	04EE8H,04AC6H,046A5H,04283H,03E62H,03A41H,03640H,03220H
	.word	02E00H,029E0H,025C0H,021A0H,01D80H,01D80H

******************************************************************************

	.end
