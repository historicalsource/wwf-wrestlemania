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


******************************************************************************
* EXTERNAL REFERENCES

	.REF	PSTATUS

	.ref	pal_getf
	.ref	RNDPER,RNDRNG0,RNDRNGS
	.ref	PCNT

	;from STRING.ASM
	.ref	osgemd_ascii,message_ascii,mess_space_width,mess_spacing
	.ref	mess_cursx,mess_cursy,message_palette,print_string_R
	.ref	dec_to_asc,copy_string,message_buffer,print_string
	.ref	print_message,print_string_C2,mess_objid,setup_message
	.ref	ogmd10_ascii
	.ref	mess_line_spacing,print_string2
	.ref	print_string_R2
	.ref	font9_ascii

	.REF	BAKMODS
	.REF	BGND_UD1
	.REF	GENERIC_DISPLAY
	.REF	ZERO_BITS

	.DEF	CREATE_TEXT_LINE

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

SHOW_DAMAGE_POINTS	equ	0

******************************************************************************
* VARIABLES

	.bss	impact_params	,32*8 * NUM_WRES	;


	BSSX	plyr1_objlist,	32	;collideable objects on P1's side
	BSSX	plyr2_objlist,	32	; P2's side
	BSSX	neutral_objlist,32	;neutral collideable

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

 SUBR	create_damage_points

	.if SHOW_DAMAGE_POINTS

	CREATE0	impact_proc
	move	a0,a9

	movi	sp_d200_anim,a0
	move	a0,*a9(ANIM),L		;animation

	movi	DMAWNZ|M_3D,a4		;DMA flags

	movi	11,a1			;<--- get from table
	move	*a13(OBJ_XPOSINT),a0

	move	*a13(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#no_flip
	neg	a1
;;;	ori	M_FLIPH,a4		;flip image
#no_flip
	add	a1,a0
	sll	16,a0
	move	a0,*a9(XVAL),L

	move	a4,*a9(FLAGS)		;DMA flags


	movi	Y_SCALE_MULTIPLIER,a0
	move	*a13(OBJ_ZPOSINT),a1
	mpyu	a0,a1
	move	*a13(OBJ_YPOSINT),a0
	addi	104,a0			;<--- get from table
	sll	16,a0
	sub	a0,a1
	move	a1,*a9(YVAL),L

	move	*a13(OBJ_PRIORITY),a0
	inc	a0
	move	a0,*a9(ZVAL)

	clr	a0
	move	a0,*a9(XVEL),L

	movi	[-1,0],a0
	move	a0,*a9(YVEL),L

	.endif

	rets


XYSEEK

;;Seek x-y coordinate
;a8=object seeking
;a5=x coord to seek
;a6=y coord to seek
;a7=multiplier of velocity

;RETURNS
;a5=x vel
;a6=y vel

	move	*a8(OXPOS),a3,0
	move	*a8(OYPOS),a4,0

	sub	a3,a5		;find difference
	sub	a4,a6
	move	a6,a3		;
	move	a5,a1
	abs	a5
	abs	a6
	add	a5,a6		;calc sum abs(dx+dy)
	sll	16,a1		;shift to accomodate fractional velocity
	sll	16,a3
	divs	a6,a1		;generate speed ratios
	divs	a6,a3
;	movi	60h,a5		;multiply by velocity factor
	move	a7,a5
	mpys	a5,a3
	mpys	a1,a5		;final x vel
	sra	4,a3
	sra	4,a5
	move	a3,a6		;final y vel

	rets

;MJT Start

;MJT End
#*****************************************************************************

;For Bam fire head butt
;For Taker club to head
 SUBR	create_impact

	PUSH	a1,a4,a7,a10,a11
	move	*a13(WHOIHIT),a10,L
	move	*a10(WRESTLERNUM),a0
	sll	5,a0
	addi	#offset_t,a0
	move	*a0,a11,L
	CREATE0	#explosions
	CREATE0	#explosions2
	PULL	a1,a4,a7,a10,a11

	rets

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

	PUSH	a1,a4,a7,a10,a11
	move	*a13(WHOIHIT),a10,L
	movi	[38h,13h],a11
	CREATE0	#explosions
	CREATE0	#explosions2
	PULL	a1,a4,a7,a10,a11

	rets

;MJT Start
;For Taker explosion for pin
 SUBR	create_impact5

	PUSH	a1,a4,a7,a10,a11
	move	*a13(WHOIHIT),a10,L
	movi	[10,1h],a11
	CREATE0	#explosions
	CREATE0	#explosions2
	CREATE0	#explosions2
	PULL	a1,a4,a7,a10,a11

	rets
;MJT End

;For Bam fire punches to head
 SUBR	create_impact3

	PUSH	a1,a4,a7,a10,a11
	move	*a13(WHOIHIT),a10,L
	movi	[58h,0],a11
	CREATE0	#explosions
	PULL	a1,a4,a7,a10,a11

	rets

;For Taker uppercut
 SUBR	create_impact4

	PUSH	a1,a4,a7,a10,a11
	move	*a13(WHOIHIT),a10,L
	movi	[58h,0],a11
	CREATE0	#head_fountain
;MJT Start
;Don't allow other debris to come out and bog us down!
	movk	1,a0
	move	a0,@no_debris
;MJT End
	PULL	a1,a4,a7,a10,a11

	rets

#head_fountain
;For Taker uppercut fountain
	move	*a10(DEBRIS_X),a1
;MJT Start
	jrnz	#cont
	.ref	no_debris
	move	a0,@no_debris
	DIE

#cont
;MJT End
	CREATE0	impact_proc2
	move	a0,a9

	movk	11,a0
	calla	RNDRNG0
	sll	5,a0
	addi	#exp_tbl,a0
	move	*a0,a0,L

	move	a0,*a9(ANIM),L		;animation

	movi	BLUEEX_P,a0
	move	a0,*a9(PALLET),L

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

	SLEEPK	2

	jruc	#head_fountain

*****************************************************************************

#explosions2
	SLEEPK	1
#explosions

	movx	a11,a0
	move	a0,*a13(PDATA)		;x
	movy	a11,a0
	srl	16,a0
	move	a0,*a13(PDATA+16)	;y

	movk	4,a11
#lp
	CREATE0	impact_proc
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

	DIE

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
;MJT START
	move	*a2(SP_NEXT),a2,L	;cur
;MJT END
	jrz	#empty

	cmp	a2,a0
	jrne	#no_match

	move	*a2(SP_NEXT),*a1(SP_NEXT),L	;unlink

	rets

#empty
	.if DEBUG
	LOCKUP
	.endif
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

#die

	move	a13,a0
	callr	delete_special_objlist

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


#die

	move	a13,a0
	callr	delete_special_objlist

	move	*a13(SP_OBJ),a0,L
	calla	DELOBJ

	move	*a13(SP_SHADOW_OBJ),a0,L
	calla	DELOBJ

	DIE

;Fix!!  I don't want shadows on this spirit
#*****************************************************************************

;MJT Start
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
;	callr	sp_create_shadow

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

;MJT End

#*****************************************************************************

 SUBR	react_bloodnguts_gen

	move	a11,*a13(SP_WRESPROC),L

#asdf
	movi	3,a8
#loop
	movi	2,a9
#loop2
	CREATE0	react_blood
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

	movi	turkey_anim,a0
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
;;;	movi	firesplat_anim,a0
;	movi	piesplat_anim,a0
	movi	spiritsplat_anim,a0
;MJT Start
	move	*a13(SP_ID),a14
	jrz	#reg
	movi	reapersplat_anim,a0
#reg
;MJT End
	callr	sp_change_anim


	PULL	a13

	move	a13,a0
	callr	delete_special_objlist
;;;	movi	firesplat_anim,a0

;	movi	piesplat_anim,a0
	movi	spiritsplat_anim,a0
	callr	sp_change_anim


 .if 0
	PUSH	a8
	move	a6,a13
	movi	firesplat_anim,a0
	callr	sp_change_anim
	move	a13,a0
	callr	delete_special_objlist

	PULL	a13
	movi	firesplat_anim,a0
	callr	sp_change_anim
	move	a13,a0
	callr	delete_special_objlist
 .endif

	PULL	a13
	rets


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


#*****************************************************************************


 SUBR	sp_change_anim

	move	a0,*a13(SP_ANIBASE),L
	move	a0,*a13(SP_ANIPC),L
	movk	1,a0
	move	a0,*a13(SP_ANICNT)
	move	*a13(SP_OBJ),a8,L
	callr	sp_animate
	rets



sp_animate
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

	movk	1,a0
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
	.long	turkey_anim
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

turkey_anim
	WL	8,FLAMEA01
	WL	8,FLAMEA02
	WL	8,FLAMEA03
	WL	8,FLAMEA04
	WL	8,FLAMEA05
	WL	8,FLAMEA06
	WL	8,FLAMEA07
	.word	ASP_REPEAT


	WL	3,TURKEY1
	WL	3,TURKEY2
	WL	3,TURKEY3
	WL	3,TURKEY4
	WL	3,TURKEY5
	WL	3,TURKEY6
	WL	3,TURKEY7
	WL	3,TURKEY8
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

;MJT Start
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

;MJT End
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

;MJT Start
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
;MJT End


 SUBR	firesplat_anim

	.word	ASP_ZEROVELS
	WL	4,CLOBHIT01
	WL	4,CLOBHIT02
	WL	4,CLOBHIT03
	WL	4,CLOBHIT04
	.word	ASP_DIE

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
	jrls	#exit

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
;MJT Start
	cmpi	2,a14
	jrnz	#not_und
	move	*a11(ANIBASE),a1,L
;MJT Start 2
	.ref	und_4_pin2_anim
	cmpi	und_4_pin2_anim,a1
;MJT End 2
	jrnz	#not_und
	movi	8*32,a0

#not_und
;MJT End
	X32	a14
	addi	debris_anims,a14
	move	*a14,a14,L
	add	a14,a0
	move	*a0(0),*a13(#ANIM),L

	CREATE0	react_debris2

	move	*a13(#ANIM),*a0(SP_ANIMPTR),L	;&anim
	PULL	a0
	dsj	a0,#lp2

	move	*a10(DB_SLEEP),a0	;sleep cnt
	jrz	#skp
	calla	PRCSLP
#skp
	dsj	a9,#lp1

#exit
	DIE



#debris_table
	.long	#db0
	.long	#db1
	.long	#db2
	.long	#db3
	.long	#db4
	.long	#db5
	.long	#db6
;MJT Start
	.long	#db7
;MJT End


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

;MJT Start
#db7	;onground - Taker pins me with hand
	.word	8,2,4				;loop count, # per loop, sleep cnt
	.word	15,0,0				;random +/- x,y,z pos offs
	.long	000000h, 040000h, 000000h	;initial x,y,z vel
	.long	020000h, 020000h, 020000h	;random +/- x,y,z vel
	.long	GRAVITY				;gravity value
	.word	70,5				;lifespan, +/- rand
;MJT End


#*****************************************************************************
; a8 = * x,y,z off
; a10 = * debris table
; a11 = * wrestler proc

 SUBR	react_debris2

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
	.long	heart_anim	;1
	.long	heart_anim	;2
	.long	heart_anim	;3
	.long	heart_anim	;4
	.long	heart_anim	;5
	.long	heart_anim	;6
	.long	heart_anim	;7
***
#razor_debris_anims
	.long	blade_anim	;0
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
;MJT Start
;Special bats only for a pin
	.long	bat_anim	;8
;MJT End
***
#yoko_debris_anims
	.long	lamb_anim	;0
	.long	fish1_anim	;1
	.long	fish2_anim	;2
	.long	lamb_anim	;3
	.long	fish1_anim	;4
	.long	fish2_anim	;5
	.long	lamb_anim	;6
	.long	fish1_anim	;7
***
#shawn_debris_anims
***
#bam_debris_anims

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

;MJT Start
	movk	4,a0
;MJT End
#lp2
	PUSHP	a0
	movi	#tmb_debris2,a10
	movi	#xyz_off2,a8
	CREATE0	react_debris2
	movi	tombbit_anim,a14
	move	a14,*a0(SP_ANIMPTR),L	;&anim

	movi	#tmb_debris2,a10
	movi	#xyz_off2,a8
	CREATE0	react_debris2
	movi	tombbit_anim,a14
	move	a14,*a0(SP_ANIMPTR),L	;&anim

	SLEEPK	1
	PULLP	a0
	dsj	a0,#lp2

	DIE


 SUBR	und_tombbits

;MJT Start
	movk	3,a0
;MJT End
#lp
	PUSHP	a0
	movi	#tmb_debris,a10
	movi	#xyz_off,a8
	CREATE0	react_debris2
	movi	tombbit_anim,a14
	move	a14,*a0(SP_ANIMPTR),L	;&anim

	SLEEPK	1
	PULLP	a0
	dsj	a0,#lp

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

	WLLW	0,0,0,NEXT
TEXT_LIST
	WLLW	TYPTEXT+1,#LINE1,0,BELOW
	WLLW	TYPTEXT+2,#LINE2,0,NEXT
	WLLW	TYPTEXT+3,#LINE3,0,BELOW
	WLLW	TYPTEXT+4,#LINE4,0,NEXT
	WLLW	TYPTEXT+5,#LINE5,0,BELOW
	WLLW	TYPTEXT+6,#LINE6,0,BELOW
	WLLW	TYPTEXT+7,#LINE7,0,BELOW
	WLLW	TYPTEXT+8,#LINE8,0,NEXT
	WLLW	TYPTEXT+9,#LINE9,0,BELOW
	WLLW	TYPTEXT+10,#LINE10,0,BELOW
	WLLW	TYPTEXT+11,#LINE10a,0,BELOW
	WLLW	TYPTEXT+12,#LINE11,0,NEXT
	WLLW	TYPTEXT+13,#LINE12,0,BELOW
	WLLW	TYPTEXT+14,#LINE13,0,NEXT
	WLLW	TYPTEXT+15,#LINE14,0,BELOW
	WLLW	TYPTEXT+16,#LINE15,0,BELOW
	WLLW	TYPTEXT+17,#LINE16,0,BELOW
	WLLW	TYPTEXT+18,#LINE17,0,180*2
	.WORD	-1

#SETUP_LINE
	JAM_STR	osgemd_ascii,10,0,200,-30,RUBYPAL,print_string_C2

#LINE1
	.byte	"HEAD HONCHO",0,0
	.even
#LINE2
	.byte	"MARK TURMELL",0,0
	.even
#LINE3
	.byte	"HEAD ARTIST AND MONKEY",0,0
	.even
#LINE4
	.byte	"SAL DIVITA",0,0
	.even
#LINE5
	.byte	"TALENTED CHIMPS",0,0
	.even
#LINE6
	.byte	"JAMIE RIVETT",0,0
	.even
#LINE7
	.byte	"JASON SKILES",0,0
	.even
#LINE8
	.byte	"JAKE SIMPSON",0,0
	.even
#LINE9
	.byte	"ART GRUNTS",0,0
	.even
#LINE10
	.byte	"JOSH TSUI",0,0
	.even
#LINE10a
	.byte	"EUGENE GREER",0,0
	.even
#LINE11
	.byte	"TONY GOSKIE",0,0
	.even
#LINE12
	.byte	"DRUM BANGER",0,0
	.even
#LINE13
	.byte	"CHRIS GRANNER",0,0
	.even
#LINE14
	.byte	"THANKS FOR THE PRESSURE",0,0
	.even
#LINE15
	.byte	"NEIL NICASTRO",0,0
	.even
#LINE16
	.byte	"KEN FEDESNA",0,0
	.even
#LINE17
	.byte	"PAUL DUSSAULT",0,0
	.even

#hstd_mod
	.long	slateBMOD
	.word	0,0
	.long	0

#title_mod
	.long	LAVAPGBMOD
	.word	0,0
	.long	0

#LIST_START	.equ PDATA+20H

CREATE_TEXT_LINE
	JSRP	GENERIC_DISPLAY
	MOVI	TEXT_LIST,A8

	MOVI	#SETUP_LINE,A2
	CALLA	setup_message
small_loop
	MOVE	*A8+,A2
	JRN	LAST_ONE
	MOVE	A2,@mess_objid		;OBJ ID's for text
	MOVI	GOLD,A4
	MOVE	*A8(-020H),A0
	CMPI	NEXT,A0
	JRNE	PAL_IS_SET
	MOVI	RUBYPAL,A4
PAL_IS_SET
	MOVE	A4,@message_palette,L
	MOVE	*A8+,A4,L
	CALLA	print_string_C2
	MOVI	179,A9
	CREATE0	MAKE_TEXT_MOVE

	MOVE	*A8+,A5,L
	JRZ	NO_NEW_BACK
	CALLA	CLEAR_BAKGROUND_OBJ
NO_NEW_BACK
	MOVE	*A8+,A0
	CALLA   PRCSLP
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
	MOVE	@mess_objid,A10
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
	MOVI	18H,A7
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


******************************************************************************


	.end

