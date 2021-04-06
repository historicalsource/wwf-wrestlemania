****************************************************************
*
* Software:	JAKE SIMPSON
* Initiated:	10/17/94
*
* Modified:	
*
* COPYRIGHT (C) 1994 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 
****************************************************************
	.file	"progress.asm"
	.title	"progression screen"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"
	.include	"display.equ"
	.include	"sys.equ"
	.include	"gsp.equ"
	.include	"macros.h"
	.include	"game.equ"
	.include	"anim.equ"
	.include	"audit.equ"
	.include	"link.equ"
	.include	"imgtbl.glo"
	.include	"bgndtbl.glo"
	.include	"plyr.equ"
	.include	"ring.equ"
	.include	"ladder.tbl"
	.include	"crowdimg.tbl"
	.include	"miscimg.glo"

	.REF	RNDPER
	.REF	start_credbox
	.ref	triple_sound
	.REF	CLEAR_PROCESSES
	.ref	SPECIAL_WIPEOUT
	.REF	announcer_sound
	.REF	DUMRETS
	.ref	HRT3,RZR3,UND3,YOK3,SHN3,BAM3,DNK3,LEX3
	.REF	RNDRNG0
	.REF	HALT, dtype, dpageflip 
	.REF	IRQSKYE, WORLDTLX, WORLDTLY
	.REF	BAKMODS, BGND_UD1
	.REF	set_process_ptr
	.REF	animate_wrestler
	.REF	animate_wrestler1
	.REF	animate_wrestler2
	.REF	wrestler_veladd
	.REF	ani_init
	.REF	PSTATUS
	.REF	pal_getf
	.REF	PCNT
	.REF	index1, index2
	.ref	obj_look
	.ref	set_images
	.ref	change_anim1a
	.ref	change_anim2a
	.ref	match_time
	.ref	process_ptrs
	.ref	hrt_run2_anim	
	.ref	rzr_run2_anim	
	.ref  	und_run2_anim	
         .ref 	yok_run2_anim	
	.ref	shn_run2_anim	
	.ref	bam_run2_anim	
	.ref	dnk_run2_anim	
	.ref	lex_run2_anim	
	.ref	hrt_torso4_anim
	.ref	rzr_torso4_anim
	.ref	und_torso4_anim
	.ref	yok_torso4_anim
	.ref	shn_torso4_anim
	.ref	bam_torso4_anim
	.ref	dnk_torso4_anim
	.ref	lex_torso4_anim
	.ref	hrt_stand4_anim
	.ref	rzr_stand4_anim
	.ref	und_stand4_anim
	.ref	yok_stand4_anim
	.ref	shn_stand4_anim
	.ref	bam_stand4_anim
	.ref	dnk_stand4_anim
	.ref	lex_stand4_anim
	.ref	hrt_dizzy_anim
	.ref	rzr_dizzy_anim
	.ref	und_dizzy_anim
	.ref	yok_dizzy_anim
	.ref	shn_dizzy_anim
	.ref	bam_dizzy_anim
	.ref	dnk_dizzy_anim
	.ref	lex_dizzy_anim
	.REF	get_all_buttons_cur2
	.ref	MAKE_UP_LOGO
	.REF	GAMSTATE
	.ref	animate_back
	.REF	dirqcnt
	.REF	SNDSND
	.REF	VINCE_START_GAME

	.REF	WHICH_SCREEN,TOP_LEFT,BOT_RIGHT,dma_it_out
	.REF	SHAKER
	.REF	OPEN_SCREEN_LINE

	.ref	D2ST2B03




	.DEF	PUT_UP_PROGRESS
	.DEF	DO_FLASH,DO_JASON_CROWD,DO_TONY_CROWD
	.DEF	DO_VOGEL_CROWD
	.DEF	OPEN_PROGRESS_SCREEN
	.DEF	SORT_OUT_WRESTLER_NUM
	.DEF	CURRENT_LADDER,NUM_OPPS
	.DEF	RESETUP_PROGRESS
	.DEF	CLOSE_PROGRESS_SCREEN
	.DEF	INIT_LADDER_TABLE
	.DEF	IGNORE_SPECIAL,IGNORE_THIS_PAL
	.DEF	START_FLASHES
	.DEF	TEMP_LADDER
	.DEF	LADDER

	.DEF	ANIM_CROWD
	.DEF	setup_back_anim

	.BSS	TEMP_SPEED,32
	.bss	CURRENT_LADDER,32
	.BSS	LADDER,100*32
	.bss	TEMP_LADDER,8*8
	.BSS	TEMP_LADDER_END,0
	.BSS	SCREEN_SHAKE,32
	.BSS	NUM_OPPS,16
	.BSS	NUM_OLD_OPPS,16
	.BSS	TOP_LEFT_2,32
	.BSS	BOT_RIGHT_2,32
	.BSS	FUJI_OBJ,32
	.BSS	WHICH_PAL,16*9
	.BSS	IGNORE_SPECIAL,16


RUN_SPEED	.EQU	[4,0]

SCPTR	.set	000	;UHL script pointer (next instruction)
TIME	.set	020h	;UHW time to hold
FRAME	.set	030h	;UHL current obj
CHEER	.set	050h	;UHL cheer jump point
UNUSED	.set	070h	;UHW unused

CANI_GOTO	equ	0 + 8000h
CANI_RNDWAIT	equ	1 + 8000h
CANI_END		equ	2 + 8000H
CANI_CODE	EQU	3 + 8000H

;BLOC_STRUCTURE
B_CTRL	.EQU	0
B_SAG	.EQU	020H
B_DAG	.EQU	040H
B_SIZE	.EQU	060H
B_PAL	.EQU	080H
B_REAL_SAG	.EQU	0A0H
BLOC_SIZE .EQU	0C0H

BLOC_TOTAL	.EQU	14
BITS_TOTAL	.EQU	40
P_DELAY	.EQU	20

	.BSS	PROG_BLOC_START,BLOC_SIZE*(BLOC_TOTAL+BITS_TOTAL)
BITS_START	.EQU	PROG_BLOC_START+(BLOC_SIZE*BLOC_TOTAL)

;PALETTE TYPE FOR BLOCKS TABLE
P_WHICH_PAL	.EQU 	0
P_DMA_PAL_VAL	.EQU	020H
P_SIZE		.EQU	040H
NUM_PAL_BLOC		.EQU	8

	.BSS	PAL_BLOC_START,P_SIZE*NUM_PAL_BLOC
	.BSS	PAL_PNTR,32

	.TEXT

IGNORE_THIS_PAL
	MMTM	SP,A8,A10,A14
	MOVI	PAL_BLOC_START,A8
	MOVK	NUM_PAL_BLOC,A10
CHECK_NEXT_PAL
	MOVE	*A8(P_WHICH_PAL),A14,L
	JRZ	DO_NEXT_PAL
	CMP	A0,A14
	JRNE	DO_NEXT_PAL
	MMFM	SP,A8,A10,A14
	SETC
	RETS
DO_NEXT_PAL
	ADDI	P_SIZE,A8
	DSJS	A10,CHECK_NEXT_PAL
	MMFM	SP,A8,A10,A14
	CLRC
	RETS

GET_PAL_BLOC
	MMTM	SP,A1,A4
	MOVE	@PAL_PNTR,A4,L
	MOVE	*A4(P_WHICH_PAL-P_SIZE),A1,L
	CMP	A0,A1
	JREQ	NO_NEED_TO_RESTORE
	MOVE	A0,*A4(P_WHICH_PAL),L
	calla	pal_getf
	MOVE	A0,*A4(P_DMA_PAL_VAL)
	MOVE	A4,A0
	ADDI	P_SIZE,A4
	MOVE	A4,@PAL_PNTR,L
	MMFM	SP,A1,A4
	RETS
NO_NEED_TO_RESTORE
	SUBI	P_SIZE,A4
	MOVE	A4,A0
	MMFM	SP,A1,A4
	RETS

RESETUP_PROGRESS
	MOVI	BLAST_OUT_PROGRESS_TRANS,A0
	MOVE	A0,@WHICH_SCREEN,L
	RETS

OPEN_PROGRESS_SCREEN

	movk	16,a0
	calla	triple_sound

	MOVI	P_DELAY,A8
	MOVI	200/P_DELAY,A9
	NEG	A9

OPEN_ACROSS_MORE
	MOVI	BLOC_TOTAL,A10
	MOVI	PROG_BLOC_START,A2
	CLR	A0
	MOVE	A0,@BOT_RIGHT_2,L
	MOVE	A0,@TOP_LEFT_2,L
OPEN_NEXT_BLOC
	CALLR	MOVE_BLOC
	ADDI	BLOC_SIZE,A2
	DSJS	A10,OPEN_NEXT_BLOC
	MOVE	@BOT_RIGHT_2,@BOT_RIGHT,L
	MOVE	@TOP_LEFT_2,@TOP_LEFT,L
	SLEEPK	1
	DEC	A8
	JRNZ	OPEN_ACROSS_MORE
	SLEEPK	1

	MOVI	DUMRETS,A1
	MOVE	A1,@WHICH_SCREEN,L
	CLR	A0
	MOVE	A0,@TOP_LEFT,L
	MOVE	A0,@BOT_RIGHT,L
	MOVE	A0,@IGNORE_SPECIAL
	RETP

CLOSE_PROGRESS_SCREEN

	CLR	A0
	MOVE	A0,@SCREEN_SHAKE,L

	MOVI	BLAST_OUT_PROGRESS_TRANS,A0
	MOVE	A0,@WHICH_SCREEN,L

	MOVI	PAL_BLOC_START,A0
	MOVE	A0,@PAL_PNTR,L
	MOVK	1,A0
	MOVE	A0,@IGNORE_SPECIAL

	CALLR	INIT_BLOC

	CALLR	SETUP_LOGOS

	movk	16,a0
	calla	triple_sound

	MOVI	P_DELAY,A8
	MOVI	200/P_DELAY,A9

MOVE_ACROSS_MORE
	MOVI	BLOC_TOTAL,A10
	MOVI	PROG_BLOC_START,A2
	MOVE	@BOT_RIGHT,@BOT_RIGHT_2,L
	MOVE	@TOP_LEFT,@TOP_LEFT_2,L
MOVE_NEXT_BLOC
	CALLR	MOVE_BLOC
	ADDI	BLOC_SIZE,A2
	DSJS	A10,MOVE_NEXT_BLOC
	MOVE	@BOT_RIGHT_2,@BOT_RIGHT,L
	MOVE	@TOP_LEFT_2,@TOP_LEFT,L
	SLEEPK	1
	DEC	A8
	JRNZ	MOVE_ACROSS_MORE

	movi	0c1h,a0
	calla	triple_sound

	CALLR	CREATE_BITS

	MOVI	SHAKE_TABLE,A8
SHAKE_IT_BABY
	MOVE	*A8+,A1,L
	JRZ	END_SHAKE
	MOVE	A1,@SCREEN_SHAKE,L
	MOVE	*A8+,A0,L
	CALLA	PRCSLP
	JRUC	SHAKE_IT_BABY
END_SHAKE
	CLR	A1
	MOVE	A1,@SCREEN_SHAKE,L

	SLEEP	45

	RETP

SHAKE_TABLE
	.LONG	[-1,-1],2
	.LONG	[2,1],2
	.LONG	[-2,0],2
	.LONG	[-3,1],2
	.LONG	[2,3],2
	.LONG	[0,-2],2
	.LONG	[-1,-1],2
	.LONG	[2,1],2
	.LONG	[-2,0],2
	.LONG	[-3,1],2
	.LONG	[2,3],2
	.LONG	[0,-2],2
	.LONG	0

BITS_ADDR	.EQU	PDATA+020H
BITS_ANIM	.EQU	PDATA+040H
BITS_DELAY	.EQU	PDATA+060H
BITS_D		.EQU	2

CREATE_BITS
	MOVI	BITS_TOTAL,A10
	MOVI	BITS_START,A2
	MOVI	080020000H,A3
	MOVI	200,A5
	MOVI	40,B3
CREATE_NEXT_BIT
	MOVE	A10,A1
	ANDI	03,A1
	JRNZ	RE_USE_OLD_YPOS
	MOVE	B3,A0
	ADDI	20,B3
	CALLA	RNDRNG0
	SLL	16,A0
	MOVE	A0,A8
	MOVY	A8,A5
RE_USE_OLD_YPOS
	PUSH	A10
	MOVI	058000H,A0
	CALLA	RNDRNG0
	NEG	A0
	MOVE	A0,A9	;Y-VEL
	MOVI	[200,0],A10	;XPOS (32 BIT)
	MOVI	080000H,A0
	CALLA	RNDRNG0
	SUBI	040000H,A0
	MOVE	A0,A11	;X-VEL
	CREATE0	MOVE_BITS
	MOVE	A2,*A0(BITS_ADDR),L
	PUSH	A0

	MOVE	A5,*A2(B_DAG),L

	MOVI	13,A0
	CALLA	RNDRNG0
	SLL	7,A0
	ADDI	RANDOM_SPARK_TAB,A0
	MOVE	*A0,A1,L

	PUSH	A0
	MOVE	*A0(040H),A0,L
	CALLA	GET_PAL_BLOC
	MOVE	A0,*A2(B_PAL),L
	PULL	A0

	MOVE	*A1(ISAG),*A2(B_SAG),L
	MOVE	*A1(ISIZEX),*A2(B_SIZE),L
	MOVE	*A1(ICTRL),A6

	SLL	16,A6
	OR	A3,A6
	MOVE	A6,*A2(B_CTRL),L

	PULL	A1
	MOVE	*A0(020H),*A1(BITS_ANIM),L
	MOVK	BITS_D,A0
	MOVE	A0,*A1(BITS_DELAY)

	ADDI	BLOC_SIZE,A2

	PULL	A10
	DEC	A10
	JRNZ	CREATE_NEXT_BIT
	RETS

MOVE_BITS
	MOVE	*A13(BITS_ADDR),A2,L
	ADDI	GRAVITY-3000H,A9
	ADD	A9,A8
	CMPI	[255,0],A8
	JRGE	KILL_BIT
	ADD	A11,A10
	MOVE	A10,A1
	SRL	16,A1
	MOVY	A8,A1
	MOVE	A1,*A2(B_DAG),L

	MOVE	*A13(BITS_DELAY),A1
	DEC	A1
	JRZ	WE_ANIM_SPARK
	MOVE	A1,*A13(BITS_DELAY)

	SLOOP	1,MOVE_BITS

WE_ANIM_SPARK
	MOVE	*A13(BITS_ANIM),A1,L
JUMP_BACK
	MOVE	*A1+,A14
	JRN	SPARK_ANIM_JUMP
	MOVE	A14,*A13(BITS_DELAY)
	MOVE	*A1+,A14,L
	MOVE	*A14(ISAG),*A2(B_SAG),L
	MOVE	A1,*A13(BITS_ANIM),L
	SLOOP	1,MOVE_BITS

SPARK_ANIM_JUMP
	MOVE	*A1+,A1,L
	JRUC	JUMP_BACK

KILL_BIT
	CLR	A0
	MOVE	A0,*A2(B_SAG),L
	DIE

RANDOM_SPARK_TAB
	.LONG	CHIP1_01,CHIP1_F,CHIP_B_P,0
	.LONG	CHIP1_01,CHIP1_B,CHIP_B_P,0
	.LONG	CHIP2_01,CHIP2_F,CHIP_B_P,0
	.LONG	CHIP2_01,CHIP2_B,CHIP_B_P,0
	.LONG	CHIP3_01,CHIP3_F,CHIP_B_P,0
	.LONG	CHIP3_01,CHIP3_B,CHIP_B_P,0
	.LONG	CHIP4_01,CHIP4_F,CHIP_B_P,0
	.LONG	CHIP4_01,CHIP4_B,CHIP_B_P,0
	.LONG	CHIP5_01,CHIP5_F,CHIP_B_P,0
	.LONG	CHIP5_01,CHIP5_B,CHIP_B_P,0
	.LONG	SPKD1_09,SPKD1_ANIM,SPKPRP_P,0
	.LONG	SPKD2_09,SPKD2_ANIM,SPKPRP_P,0
	.LONG	SPKD4_09,SPKD4_ANIM,SPKPRP_P,0
	.LONG	SPKR1_09,SPKR1_ANIM,SPKPRP_P,0

BIT_DELAY	.EQU	1

CHIP1_F
	WL	BIT_DELAY,CHIP1_01
	WL	BIT_DELAY,CHIP1_03
	WL	BIT_DELAY,CHIP1_05
	WL	BIT_DELAY,CHIP1_07
	WL	BIT_DELAY,CHIP1_09
	WL	BIT_DELAY,CHIP1_11
	WL	BIT_DELAY,CHIP1_13
	WL	BIT_DELAY,CHIP1_15
	WL	BIT_DELAY,CHIP1_17
	WL	BIT_DELAY,CHIP1_19
	WL	-1,CHIP1_F

CHIP1_B
	WL	BIT_DELAY,CHIP1_19
	WL	BIT_DELAY,CHIP1_17
	WL	BIT_DELAY,CHIP1_15
	WL	BIT_DELAY,CHIP1_13
	WL	BIT_DELAY,CHIP1_11
	WL	BIT_DELAY,CHIP1_09
	WL	BIT_DELAY,CHIP1_07
	WL	BIT_DELAY,CHIP1_05
	WL	BIT_DELAY,CHIP1_03
	WL	BIT_DELAY,CHIP1_01
	WL	-1,CHIP1_B

CHIP2_F
	WL	BIT_DELAY,CHIP2_01
	WL	BIT_DELAY,CHIP2_03
	WL	BIT_DELAY,CHIP2_05
	WL	BIT_DELAY,CHIP2_07
	WL	BIT_DELAY,CHIP2_09
	WL	-1,CHIP2_F

CHIP2_B
	WL	BIT_DELAY,CHIP2_09
	WL	BIT_DELAY,CHIP2_07
	WL	BIT_DELAY,CHIP2_05
	WL	BIT_DELAY,CHIP2_03
	WL	BIT_DELAY,CHIP2_01
	WL	-1,CHIP2_B

CHIP3_F
	WL	BIT_DELAY,CHIP3_01
	WL	BIT_DELAY,CHIP3_03
	WL	BIT_DELAY,CHIP3_05
	WL	BIT_DELAY,CHIP3_07
	WL	BIT_DELAY,CHIP3_09
	WL	BIT_DELAY,CHIP3_11
	WL	BIT_DELAY,CHIP3_13
	WL	BIT_DELAY,CHIP3_15
	WL	BIT_DELAY,CHIP3_17
	WL	BIT_DELAY,CHIP3_19
	WL	-1,CHIP3_F

CHIP3_B
	WL	BIT_DELAY,CHIP3_19
	WL	BIT_DELAY,CHIP3_17
	WL	BIT_DELAY,CHIP3_15
	WL	BIT_DELAY,CHIP3_13
	WL	BIT_DELAY,CHIP3_11
	WL	BIT_DELAY,CHIP3_09
	WL	BIT_DELAY,CHIP3_07
	WL	BIT_DELAY,CHIP3_05
	WL	BIT_DELAY,CHIP3_03
	WL	BIT_DELAY,CHIP3_01
	WL	-1,CHIP3_B

CHIP4_F
	WL	BIT_DELAY,CHIP4_01
	WL	BIT_DELAY,CHIP4_03
	WL	BIT_DELAY,CHIP4_05
	WL	BIT_DELAY,CHIP4_07
	WL	BIT_DELAY,CHIP4_09
	WL	-1,CHIP4_F

CHIP4_B
	WL	BIT_DELAY,CHIP4_09
	WL	BIT_DELAY,CHIP4_07
	WL	BIT_DELAY,CHIP4_05
	WL	BIT_DELAY,CHIP4_03
	WL	BIT_DELAY,CHIP4_01
	WL	-1,CHIP4_B

CHIP5_F
	WL	BIT_DELAY,CHIP5_01
	WL	BIT_DELAY,CHIP5_03
	WL	BIT_DELAY,CHIP5_05
	WL	BIT_DELAY,CHIP5_07
	WL	BIT_DELAY,CHIP5_09
	WL	BIT_DELAY,CHIP5_11
	WL	BIT_DELAY,CHIP5_13
	WL	BIT_DELAY,CHIP5_15
	WL	BIT_DELAY,CHIP5_17
	WL	BIT_DELAY,CHIP5_19
	WL	-1,CHIP5_F

CHIP5_B
	WL	BIT_DELAY,CHIP5_19
	WL	BIT_DELAY,CHIP5_17
	WL	BIT_DELAY,CHIP5_15
	WL	BIT_DELAY,CHIP5_13
	WL	BIT_DELAY,CHIP5_11
	WL	BIT_DELAY,CHIP5_09
	WL	BIT_DELAY,CHIP5_07
	WL	BIT_DELAY,CHIP5_05
	WL	BIT_DELAY,CHIP5_03
	WL	BIT_DELAY,CHIP5_01
	WL	-1,CHIP5_B
SPKD1_ANIM
	WL	100,SPKD1_09
	WL	-1,SPKD1_ANIM
SPKD2_ANIM
	WL	100,SPKD2_09
	WL	-1,SPKD2_ANIM
SPKD4_ANIM
	WL	100,SPKD4_09
	WL	-1,SPKD4_ANIM
SPKR1_ANIM
	WL	100,SPKR1_09
	WL	-1,SPKR1_ANIM

NEXT_IN_LADDER
	MMTM	SP,A2,A3,A4,A14
	ADDI	32,A10
	MOVE	*A10,A1,L
	MOVE	A1,A2
	SRL	24,A2
	SLL	24,A2
	CMPI	01000000H,A2
	JREQ	NO_SORT_OPPS
	CLR	A3
	CLR	A4
	MOVX	A1,A3
	MOVY	A1,A4

	SLL	24,A1
	SRL	24,A1

	SRL	8,A3

	SLL	8,A4
	SRL	24,A4

	CMPI	4,A1
	JRNE	NO_SWAP_SHAWN_A1
	MOVE	A1,A14
	MOVE	A3,A1
	MOVE	A14,A3
NO_SWAP_SHAWN_A1
	CMPI	02000000H,A2
	JREQ	STUFF_SWAPPED
	CMPI	4,A3
	JRNE	STUFF_SWAPPED
	MOVE	A3,A14
	MOVE	A4,A3
	MOVE	A14,A4

STUFF_SWAPPED
	SLL	8,A3
	SLL	16,A4
	OR	A3,A1
	OR	A4,A1
	OR	A2,A1
	MOVE	A1,*A10,L
NO_SORT_OPPS
	MOVE	A10,@CURRENT_LADDER,L
	MMFM	SP,A2,A3,A4,A14
	RETS


NUM_OF_OPPS
	MOVE	A1,A3
	SRL	24,A3
	MOVE	A3,@NUM_OPPS
	RETS

WE_HAVE_COMPANY
	CALLR	FIND_LOGO_IMAGE
	CALLR	INIT_BLOC_STUFF
	MOVE	*A1(ISIZEY),A3
	MOVI	255,A5
	SUB	A3,A5
	SRL	1,A5
	SLL	16,A5
	MOVI	400,A6
	CALLR	SETUP_THIS_LOGO_DAG
	RETS

SETUP_LOGOS

	MOVE	@index1,a1
	MOVI	-200,A6
	MOVE	@PSTATUS,A0
	JRZ	INDEX_SET_1
	SRL	1,A0
	JRC	INDEX_SET_1
	MOVE	@index2,a1
	MOVI	400,A6
INDEX_SET_1
	CALLR	FIND_LOGO_IMAGE
	CALLR	INIT_BLOC_STUFF
	MOVE	*A1(ISIZEY),A3
	MOVI	255,A5
	SUB	A3,A5
	SRL	1,A5
	SLL	16,A5
	CALLR	SETUP_THIS_LOGO_DAG

	MOVE	@index2,a1
	MOVE	@PSTATUS,A0
	JRZ	WE_HAVE_COMPANY
	CMPI	3,A0
	JREQ	WE_HAVE_COMPANY

	CMPI	400,A6
	JREQ	SET_A6_TO_MINUS_200
	MOVI	400,A6
	JRUC	A6_SET

SET_A6_TO_MINUS_200
	MOVI	-200,A6
A6_SET

	PUSH	A2
	MOVE	@NUM_OPPS,A7
	MOVE	@CURRENT_LADDER,A10,L
	MOVE	*A10,A10,L
SLAP_UP_NEXT_LOGO
	MOVE	A10,A1
	SLL	24,A1
	SRL	24,A1
	CALLR	FIND_LOGO_IMAGE
	CALLR	INIT_BLOC_STUFF
	CLR	A5
	CALLR	SETUP_THIS_LOGO_DAG
	SRL	8,A10
	DSJS	A7,SLAP_UP_NEXT_LOGO

	MOVI	-15,A5
	MOVE	@NUM_OPPS,A7
	MOVE	@CURRENT_LADDER,A10,L
	MOVE	*A10,A10,L
SLAP_UP_NEXT_LOGO_DAG_Y
	MOVE	A10,A1
	SLL	24,A1
	SRL	24,A1
	CALLR	FIND_LOGO_IMAGE
	MOVE	*A1(ISIZEY),A9
	ADD	A9,A5
	ADDI	15,A5
	SRL	8,A10
	DSJS	A7,SLAP_UP_NEXT_LOGO_DAG_Y

	PULL	A2

	MOVI	255,A11
	SUB	A5,A11
	SRL	1,A11

	MOVE	@NUM_OPPS,A7
	MOVE	@CURRENT_LADDER,A10,L
	MOVE	*A10,A10,L
SLAP_UP_NEXT_LOGO_DAG
	MOVE	A11,*A2(B_DAG+010H)
	MOVE	A10,A1
	SLL	24,A1
	SRL	24,A1
	CALLR	FIND_LOGO_IMAGE
	MOVE	*A1(ISIZEY),A9
	ADD	A9,A11
	ADDI	15,A11
	SRL	8,A10
	ADDI	BLOC_SIZE,A2
	DSJS	A7,SLAP_UP_NEXT_LOGO_DAG

	RETS

SETUP_THIS_LOGO_DAG
	MOVE	*A1(ISIZEX),A3
	MOVI	200,A4
	SUB	A3,A4
	SRL	1,A4
	ADD	A6,A4
	MOVY	A5,A4
	MOVE	A4,*A2(B_DAG),L
	ADDI	BLOC_SIZE,A2
	RETS

FIND_LOGO_IMAGE
	SLL	5,A1
	ADDI	LOGO_IMAGE_TABLE,A1
	MOVE	*A1,A1,L
	RETS

LOGO_IMAGE_TABLE
	.LONG	HRT3
	.long	RZR3
	.long	UND3
	.long	YOK3
	.long	SHN3
	.long	BAM3
	.long	DNK3
	.long	LEX3
	.long	LEX3
MOVE_BLOC
	MOVE	*A2(B_SAG),A0,L
	JRZ	NO_BLOC_TO_MOVE
	MOVE	*A2(B_DAG),A0
	CMPI	200,A0
	JRLT	BLOC_ON_LEFT
	NEG	A9
	ADD	A9,A0
	NEG	A9
	MOVE	A0,*A2(B_DAG)
	MOVI	400,A3
	SUB	A0,A3
	NEG	A3
	MOVE	@BOT_RIGHT_2,A1
	CMP	A3,A1
	JRLE	NO_NEW_BOT_RIGHT
	MOVE	A3,@BOT_RIGHT_2
NO_NEW_BOT_RIGHT
	CLR	A1
	MOVE	*A2(B_SIZE),A3
	ADD	A0,A3
	SUBI	400,A3
	JRN	NO_SPECIAL_BCTRL
	MOVE	A3,A1
NO_SPECIAL_BCTRL
	MOVE	A1,*A2(B_CTRL)
	CMPI	399,A0
	JRGT	NOT_OF_LEFT_SCREEN
	MOVE	*A2(B_CTRL),A1,L
	ORI	080000000H,A1
	MOVE	A1,*A2(B_CTRL),L
	RETS
BLOC_ON_LEFT
	MOVE	*A2(B_CTRL),A1
	SUB	A1,A0
	ADD	A9,A0
	MOVE	A0,A11
	MOVE	*A2(B_SIZE),A1
	ADD	A0,A1
	MOVE	@TOP_LEFT_2,A3
	CMP	A1,A3
	JRGE	NO_NEW_TOP_LEFT
	MOVE	A1,@TOP_LEFT_2
NO_NEW_TOP_LEFT
	MOVE	*A2(B_REAL_SAG),A3,L
	CLR	A1
	MOVE	A0,A0
	JRNN	NO_SPECIAL_BCTRL2
	NEG	A0
	MOVE	A0,A1
	MOVE	*A2(B_CTRL+010H),A5
	ANDI	7000H,A5
	SRL	12,A5
	MPYU	A1,A5
	ADD	A5,A3
NO_SPECIAL_BCTRL2
	ADD	A1,A11
	MOVE	A11,*A2(B_DAG)
	MOVE	A1,*A2(B_CTRL)
	MOVE	*A2(B_SIZE),A4
	CMP	A4,A1
	JRGE	NOT_OF_LEFT_SCREEN
	MOVE	A3,*A2(B_SAG),L
	MOVE	*A2(B_CTRL),A1,L
	ORI	080000000H,A1
	MOVE	A1,*A2(B_CTRL),L
	RETS
NOT_OF_LEFT_SCREEN
	MOVE	*A2(B_CTRL),A1,L
	SLL	1,A1
	SRL	1,A1
	MOVE	A1,*A2(B_CTRL),L
NO_BLOC_TO_MOVE
	RETS

INIT_BLOC
	MOVI	PROG_BLOC_START,A2
	MOVI	INIT_BLOC_TAB,A3
	MOVK	10,A4
INIT_NEXT_BLOC
	MOVE	*A3+,A1,L
	CALLR	INIT_BLOC_STUFF

	MOVE	*A3+,A0,L
	MOVE	A0,*A2(B_DAG),L
	ADDI	BLOC_SIZE,A2

	DSJS	A4,INIT_NEXT_BLOC

	MOVI	44,A4
	CLR	A0
INIT_NEXT_BLOC2
	MOVE	A0,*A2(B_SAG),L
	MOVE	A0,*A2(B_CTRL),L
	ADDI	BLOC_SIZE,A2

	DSJS	A4,INIT_NEXT_BLOC2
	SUBI	44*BLOC_SIZE,A2

	RETS

INIT_BLOC_STUFF
	MOVE	*A1(ISAG),*A2(B_SAG),L
	MOVE	*A1(ISAG),*A2(B_REAL_SAG),L
	MOVE	*A1(ISIZEX),*A2(B_SIZE),L
	MOVE	*A1(ICTRL),A0,L
	SLL	16,A0
	ORI	80020000H,A0
	MOVE	A0,*A2(B_CTRL),L
	MOVE	*A1(ICMAP),A0,L
	PUSH	A1
	calla	GET_PAL_BLOC
	PULL	A1
	MOVE	A0,*A2(B_PAL),L
	RETS

INIT_BLOC_TAB
	.LONG	CSELBK_A,[0,-204]
	.LONG	CSELBK_C,[133,-204]
	.LONG	CSELBK_E,[252,-204]
	.LONG	CSELBK_B,[0,404]
	.LONG	CSELBK_D,[133,404]
	.LONG	CSELBK_F,[252,404]
	.LONG	CSELBV_A,[0,-4]
	.LONG	CSELBV_C,[133,-4]
	.LONG	CSELBV_B,[0,400]
	.LONG	CSELBV_D,[133,400]

BLAST_OUT_PROGRESS_TRANS
	MOVI	BLOC_TOTAL+BITS_TOTAL,A0
	MOVI	01000100H,A5
	MOVI	PROG_BLOC_START,A2
BLAST_NEXT_BLOC
	MMFM	A2,A8,A9,A10,A11,A12
	ADDI	020H,A2		;AVOID REAL SAG
	MOVE	A11,A11
	JRZ	IGNORE_BLOCK
	MOVE	A12,A12
	JRNN	IGNORE_BLOCK
	MOVE	@SCREEN_SHAKE,A1,L
	ADD	A1,A10
	MOVE	*A8(P_DMA_PAL_VAL),A8
	CALLA	dma_it_out
IGNORE_BLOCK
	DSJS	A0,BLAST_NEXT_BLOC
	RETS

**************************************

SET_IMAGE_AND_FLASH
	calla	set_images
	MOVE	@HCOUNT,A0
	ANDI	3,A0
	JRNZ	NO_CREATE_RANDOM
	CREATE0	RANDOM_FLASHES
NO_CREATE_RANDOM
	RETS

START_FLASHES
	MOVI	FLASH_PID,A0
	movi	-1,a1
	CALLA	EXISTP
	JRNZ	ALREADY_FLASHING
	MOVI	18,A8
	CREATE	FLASH_PID,SET_GAME_FLASHES
ALREADY_FLASHING
	RETS

SET_GAME_FLASHES
	MOVE	@PSTATUS,A0
	CMPI	3,A0
	JREQ	ALWAYS_DO_FLASH
	MOVE	@NUM_OPPS,A0
	CMPI	2,A0
	JRGE	NO_CREATE_ANY_FLASH
ALWAYS_DO_FLASH
	MOVI	500,A0
	CALLA	RNDPER
	JRLS	NO_CREATE_ANY_FLASH
SET_GAME_FLASHES2
	MOVE	@HCOUNT,A0
	SRL	1,A0
	JRNC	NO_CREATE_RANDOM_G
	CREATE0	RANDOM_GAME_FLASHES
NO_CREATE_RANDOM_G
	SLEEP	2
	DSJS	A8,SET_GAME_FLASHES2
NO_CREATE_ANY_FLASH
	DIE

RANDOM_GAME_FLASHES
	MOVE	@WORLDTLY,A0,L
	SRA	16,A0
	NEG	A0
	ADDI	30,A0
	CALLA	RNDRNG0
	PUSH	A0
	MOVI	400,A0
	CALLA	RNDRNG0
	MOVE	@WORLDTLX+010H,A1
	ADD	A0,A1
	CMPI	3E8H,A1
	JRLT	RANDOM_2
	CMPI	440H,A1
	JRGT	RANDOM_2
	MOVI	58H,A1
	MOVE	@HCOUNT,A2
	ORI	2,A2
	JRZ	NOW_SHIFT_FLASH
	NEG	A1
NOW_SHIFT_FLASH
	ADD	A1,A0
	JRUC	RANDOM_2

RANDOM_FLASHES
	MOVI	200,A0
	CALLA	RNDRNG0
	PUSH	A0
	MOVI	400,A0
	CALLA	RNDRNG0
RANDOM_2
	PULL	A1
	SLL	16,A0
	SLL	16,A1
	MOVI	flash1,A2
	MOVI	89,A3
	movi	DMAWNZ,a4		;DMA flags
	CLR	A5
	CLR	A6
	CLR	A7
	CALLA	BEGINOBJW

	MOVE	@GAMSTATE,A0
	CMPI	INGAME,A0
	JREQ	NO_SOUNDS
	MOVI	500,A0
	CALLA	RNDPER
	JRLS	NO_SOUNDS
	MOVI	2,A0
	CALLA	RNDRNG0
	ADDI	4AH,A0
	MOVE	A0,A3
	CALLA	triple_sound
NO_SOUNDS

	MOVI	FLASH_TYPE_1,A1
	move	@HCOUNT,a0
	btst	0,a0
	jrz	#1
	MOVI	FLASH_TYPE_2,A1
#1	callr	setup_back_anim
	JSRP	ANIM_CROWD
	CALLA	DELOBJA8
	DIE

FLASH_TYPE_1
	WL	2,flash1
	WL	2,flash2
	WL	2,flash3
	WL	2,flash3a
	WL	2,flash3
	WL	2,flash2
	WL	2,flash1

	.WORD	CANI_END

FLASH_TYPE_2
	WL	2,flash1
	WL	2,flash4
	WL	1,flash5
	WL	1,flash6
	WL	1,flash5
	WL	2,flash4

	.WORD	CANI_END

setup_back_anim
	MOVE	A13,A4
	ADDI	PDATA,A4
	MOVE	A1,*A4(SCPTR),L
	MOVK	1,A1
	MOVE	A1,*A4(TIME)
	CALLA	animate_back
	MOVE	*A4(FRAME),A0,L
	JRUC	ANIBOBJ_B

DO_FLASH
	MMTM	SP,A0,A1,A7,A8
	MOVE	@GAMSTATE,A8
	CMPI	INPREGAME,A8
	JRNE	NO_DO_THIS
	MOVE	A0,A8
	CREATE0	DO_CROWD_FLASH
NO_DO_THIS
	MMFM	SP,A0,A1,A7,A8
	RETS

DO_CROWD_FLASH

	MOVE	*A8(OYPOS),A0
	SUBI	250,A0
	MOVE	A0,*A8(OYPOS)
	MOVI	80,A0
	CALLA	RNDRNG0
	INC	A0
	CALLA	PRCSLP

	MOVI	CROWD_FLASH_ANIM,A1
	callr	setup_back_anim

	MOVE	*A8(OYPOS),A0
	ADDI	250,A0
	MOVE	A0,*A8(OYPOS)
	JSRP	ANIM_CROWD
	JAUC	DO_CROWD_FLASH

ANIM_CROWD
	SLEEPK	1
	MOVE	A13,A4
	ADDI	PDATA,A4
	CALLA	animate_back
	JRN	EXIT_ANIM_CROWD
	JRNZ	ANIM_CROWD
	MOVE	*A4(FRAME),A0,L
	MOVE	A0,A10
	CALLA	ANIBOBJ_B
	JRUC	ANIM_CROWD
EXIT_ANIM_CROWD
	RETP

ANIBOBJ_B
	MOVE	*A8(OFLAGS),A1
	ANDI	0FFFFH-M_BOBJ,A1
	MOVE	A1,*A8(OFLAGS)

	move	*a8(OCTRL),a1,W

	PUSH	a2,a3,a4,a5

	cmpi	ROM,a0
	jrlo	#anierr

	move	*a0(IANIOFFX),a4,W
	move	A4,*a8(ODXOFF),W

	move	*a0(IANIOFFY),a4,W
	move	A4,*a8(ODYOFF),W

	move	a0,a2
	move	a1,a3

	move	a2,*a8(OIMG),L
	move	*a2(0),*a8(OSIZE),L
	move	*a2(ISAG),*a8(OSAG),L

	movb	*a2(ICTRL+7),*a8(OCTRL+7) ;Write z comp & bpp bits

	setf	6,0,0
	move	a3,*a8(OCTRL)		;Write 6 low bits
	setf	16,1,0

#x	PULL	a2,a3,a4,a5
	rets

#anierr 
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	2,2
	.endif
	jruc	#x


CROWD_FLASH_ANIM
	WL	1,FLASH2
	WL	2,FLASH1
	WL	1,FLASH2
	.WORD	CANI_END

DO_JASON_CROWD
	MMTM	SP,A0,A1,A7,A8
	MOVE	@GAMSTATE,A8
	CMPI	INPREGAME,A8
	JRNE	JASON_NO_DO_THIS
	MOVE	A0,A8
	CREATE0	DO_JASON_CROWD_MOVE
JASON_NO_DO_THIS
	MMFM	SP,A0,A1,A7,A8
	RETS

DO_JASON_CROWD_MOVE
	MOVI	80,A0
	CALLA	RNDRNG0
	INC	A0
	CALLA	PRCSLP

	MOVI	JASON_CROWD_ANIM1,A1
	MOVE	@dirqcnt,A0
	SRL	1,A0
	JRNC	JASON_CROWD_SET
	MOVI	JASON_CROWD_ANIM2,A1

JASON_CROWD_SET
	callr	setup_back_anim

	JSRP	ANIM_CROWD
	JAUC	DO_JASON_CROWD_MOVE

JASON_CROWD_ANIM1
	WL	5,JASONCRD1
	WL	5,JASONCRD2
	WL	5,JASONCRD3
	WL	6,JASONCRD4
	WL	10,JASONCRD5
	WL	5,JASONCRD1
	.WORD	CANI_END

JASON_CROWD_ANIM2
	WL	5,JASONCRD1
	WL	5,JASONCRD2
	WL	5,JASONCRD3
	WL	6,JASONCRD4
	WL	10,JASONCRD5
	WL	6,JASONCRD4
	WL	6,JASONCRD3
	WL	6,JASONCRD4
	WL	10,JASONCRD5
	WL	5,JASONCRD1
	.WORD	CANI_END


DO_TONY_CROWD
	MMTM	SP,A0,A1,A7,A8
	MOVE	@GAMSTATE,A8
	CMPI	INPREGAME,A8
	JRNE	TONY_NO_DO_THIS
	MOVE	A0,A8
	CREATE0	DO_TONY_CROWD_MOVE
TONY_NO_DO_THIS
	MMFM	SP,A0,A1,A7,A8
	RETS

DO_TONY_CROWD_MOVE
	MOVI	80,A0
	CALLA	RNDRNG0
	INC	A0
	CALLA	PRCSLP

	MOVI	TONY_CROWD_ANIM1,A1
	MOVE	@dirqcnt,A0
	SRL	1,A0
	JRNC	TONY_CROWD_SET
	MOVI	TONY_CROWD_ANIM2,A1

TONY_CROWD_SET
	callr	setup_back_anim

	JSRP	ANIM_CROWD
	JAUC	DO_TONY_CROWD_MOVE

TONY_CROWD_ANIM1
	WL	5,TONYCRD1
	WL	5,TONYCRD2
	WL	5,TONYCRD3
	WL	6,TONYCRD4
	WL	10,TONYCRD5
	WL	6,TONYCRD2
	WL	5,TONYCRD1
	.WORD	CANI_END

TONY_CROWD_ANIM2
	WL	5,TONYCRD1
	WL	5,TONYCRD2
	WL	5,TONYCRD3
	WL	6,TONYCRD4
	WL	10,TONYCRD5
	WL	6,TONYCRD4
	WL	6,TONYCRD3
	WL	6,TONYCRD4
	WL	10,TONYCRD5
	WL	6,TONYCRD2
	WL	5,TONYCRD1
	.WORD	CANI_END

DO_VOGEL_CROWD
	MMTM	SP,A0,A1,A7,A8
	MOVE	@GAMSTATE,A8
	CMPI	INPREGAME,A8
	JRNE	VOGEL_NO_DO_THIS
	MOVE	A0,A8
	CREATE0	DO_VOGEL_CROWD_MOVE
VOGEL_NO_DO_THIS
	MMFM	SP,A0,A1,A7,A8
	RETS

DO_VOGEL_CROWD_MOVE
	MOVI	80,A0
	CALLA	RNDRNG0
	INC	A0
	CALLA	PRCSLP

	MOVI	VOGEL_CROWD_ANIM1,A1
	MOVE	@dirqcnt,A0
	SRL	1,A0
	JRNC	VOGEL_CROWD_SET
	MOVI	VOGEL_CROWD_ANIM2,A1

VOGEL_CROWD_SET
	callr	setup_back_anim

	JSRP	ANIM_CROWD
	JAUC	DO_VOGEL_CROWD_MOVE

VOGEL_CROWD_ANIM1
	WL	5,VOGEL1
	WL	5,VOGEL2
	WL	5,VOGEL3
	WL	10,VOGEL4
	WL	6,VOGEL2
	WL	5,VOGEL1
	.WORD	CANI_END

VOGEL_CROWD_ANIM2
	WL	5,VOGEL1
	WL	5,VOGEL2
	WL	6,VOGEL3
	WL	10,VOGEL4
	WL	6,VOGEL3
	WL	6,VOGEL2
	WL	6,VOGEL3
	WL	10,VOGEL4
	WL	6,VOGEL3
	WL	5,VOGEL2
	WL	5,VOGEL1
	.WORD	CANI_END



;**************************************************************************
;*											      *
;* This table is set up to determine where two or three player			 *
;* matches take place in the game. It is in the format of				 *
;* 	.word x,y										 *
;* where x=number of places in the table to put y(where y is			 *
;* the number of opponents to fight). For example					 *
;* 	.word 10,2										 *
;* would set the next ten consecutive places in the table to			 *
;* have two opponents										 *
;*											      *
;**************************************************************************
LADDER_TABLE
	.word	5,1
	.word	3,2
	.word	2,3
	.word	5,1
	.word	2,2
	.word	5,1
	.word	2,2
	.word	5,1
	.word	2,2
	.word	5,1
	.word	2,2
	.word	5,1
	.word	2,2
	.word	5,1
	.word	2,2
	.word	5,1
	.word	2,2
	.word	5,1
	.word	2,2
	.word	5,1
	.word	2,2
	.word	5,1
	.word	2,2
	.WORD	-1

;**************************************************************************
;*											      *
;* Each entry in the ladder table is in the format of a long			 *
;* word, OP4|OP3|OP2|OP1. OP1 is the wrestler number for 				 *
;* opponent 1, OP2 would be the second nybble	and would be 			 *
;* the wrestler number for opponent 2. If zero, it will stop			 *
;* producing opponents. The table is generated randomly for			 *
;* each NEW game started from the ATTRACT MODE. When it is			 *
;* generated, it will randomly place the 8 wrestlers in order and then	 *
;* distribute them through the list.								 *
;*											      *
;**************************************************************************
INIT_LADDER_TABLE
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14
	CALLR	INIT_LADDER
	MOVI	LADDER,A6
	MOVE	A6,@CURRENT_LADDER,L
	CALLR	INIT_TEMP_TABLE
	CALLR	RANDOMIZE_ORDER
	MOVI	LADDER_TABLE,A7
NEXT_BIT_OF_TABLE
	MOVE	*A7+,A8
	JRN	WE_DONE_ALL_TABLE
	MOVE	*A7+,A9
DO_ALL_THESE_PARTS
	MOVE	A9,A10
	MOVB	A10,*A6(24)

	CALLR	FETCH_NEXT_OPPONENT
	MOVB	A11,*A6
	DEC	A10
	JRZ	DONE_THIS_ENTRY

	CALLR	FETCH_NEXT_OPPONENT
	MOVB	A11,*A6(8)
	DEC	A10
	JRZ	DONE_THIS_ENTRY

	CALLR	FETCH_NEXT_OPPONENT
	MOVB	A11,*A6(16)

DONE_THIS_ENTRY

	ADDI	32,A6
	DSJS	A8,DO_ALL_THESE_PARTS
	JRUC	NEXT_BIT_OF_TABLE

WE_DONE_ALL_TABLE
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14
	RETS

FETCH_NEXT_OPPONENT
	MOVB	*A2,A11
	ADDI	8,A2
	CMPI	TEMP_LADDER_END,A2
	JREQ	RANDOMIZE_ORDER
	RETS

INIT_LADDER
	MOVI	100,A1
	MOVI	LADDER,A6
	CLR	A2
CLEAR_ALL_TABLE
	MOVE	A2,*A6+,L
	DSJS	A1,CLEAR_ALL_TABLE
	RETS

INIT_TEMP_TABLE
	MOVK	8,A1
	MOVI	TEMP_LADDER,A2
INIT_NEXT_TEMP_TABLE
	DEC	A1
	MOVB	A1,*A2
	INC	A1
	ADDI	8,A2
	DSJS	A1,INIT_NEXT_TEMP_TABLE
	RETS

RANDOMIZE_ORDER
	MOVI	TEMP_LADDER,A2
	MOVK	7,A10
RANDOMIZE_NEXT_ENTRY
	MOVE	A10,A0
	CALLA	RNDRNG0
	MOVE	A0,A3
	SLL	3,A3
	ADD	A2,A3
	MOVB	*A2,A14
	MOVB	*A3,*A2
	MOVB	A14,*A3
	ADDI	8,A2
	DEC	A10
	JRNN	RANDOMIZE_NEXT_ENTRY
	MOVI	TEMP_LADDER,A2
	RETS


DO_SET_IMAGE_AND_FLASH
	CALLA	BGND_UD1
	CALLA	SET_IMAGE_AND_FLASH
	SLOOP	1,DO_SET_IMAGE_AND_FLASH

PUT_UP_PROGRESS

	calla	SPECIAL_WIPEOUT
	CALLA	CLEAR_PROCESSES

	movi	2056,a3
	calla	SNDSND

	CREATE0	VINCE_START_GAME

	clr	a0
	move	a0,@HALT

	move	a0,@dtype		;2d mode
	move	a0,@IRQSKYE
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	movi	#PROGRESS_BMOD,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1		;create objects for background

	calla	start_credbox

	movk	10,a0
	move	a0,@match_time

	MOVE	@CURRENT_LADDER,A10,L

	CMPI	LADDER,A10
	JRLE	NO_DEAD_BODIES

	MOVE	*A10,A1,L
	CALLR	NUM_OF_OPPS
	MOVE	A3,@NUM_OLD_OPPS

	MOVE	*A10,A4,L
	MOVK	4,A10
CREATE_NEXT_DEAD_GUY
	CALLR	SORT_OUT_WRESTLER_NUM
	movi	PTYPE_DRONE,a8			;player type
	movi	PSIDE_PLYR1,a9			;side on
	SCREATE	WMAIN_PID,CREATE_TEMP_WRESTLER
	SRL	8,A4
	INC	A10
	DEC	A3
	JRNZ	CREATE_NEXT_DEAD_GUY

	MOVE	@CURRENT_LADDER,A10,L

NO_DEAD_BODIES
	CALLR	NEXT_IN_LADDER
	CALLR	NUM_OF_OPPS

	movi	PTYPE_DRONE,a8			;player type
	movi	PSIDE_PLYR1,a9			;side on
	clr	a10
	move	@index1,a11			;wrestler
	MOVE	@PSTATUS,A0
	SRL	1,A0
	JRC	INDEX_SET
	move	@index2,a11			;wrestler
INDEX_SET
	PUSH	A11
	SCREATE	WMAIN_PID,CREATE_TEMP_WRESTLER
	PULL	A11

	SLL	4,A11
	ADDI	WHICH_MUSIC,A11
	MOVE	*A11,A3
	calla	SNDSND

	MOVE	@NUM_OPPS,A3
	MOVE	@CURRENT_LADDER,A10,L
	MOVE	*A10,A4,L
	MOVK	1,A10
CREATE_NEXT_NEW_GUY
	CALLR	SORT_OUT_WRESTLER_NUM
	movi	PTYPE_DRONE,a8			;player type
	movi	PSIDE_PLYR1,a9			;side on
	SCREATE	WMAIN_PID,CREATE_TEMP_WRESTLER
	SRL	8,A4
	INC	A10
	DEC	A3
	JRNZ	CREATE_NEXT_NEW_GUY

	CALLR	SET_IMAGE_AND_FLASH

	CREATE0	DO_SET_IMAGE_AND_FLASH
	PUSHP	A0
	movk	15,a8
	movk	4,a9
	NEG	A9
	JSRP	OPEN_SCREEN_LINE
	PULLP	A0
	CALLA	KILL

	MOVI	RUN_SPEED,A0
	MOVE	A0,@TEMP_SPEED,L

	PUSH	A13
	MOVE	@process_ptrs,a13,L
	movi	running_addr,a2
	callr	start_them_doing_stuff
	PULL	A13

	MOVI	RUN_SPEED,A9
	MOVI	100,A8
MOVE_PROGRESS
	calla	BGND_UD1		;create objects for background
	pushp	a8,A9
	CALLR	SET_IMAGE_AND_FLASH
	pullp	a8,A9
	CALLR	SET_SCROLL_SPEED
	SLEEPK	1
	DEC	A8
	JRNN	MOVE_PROGRESS

	PUSH	A13

	MOVE	@process_ptrs+020h,a13,L
	movi	clever_addr,a2
	callr	start_them_doing_stuff

	MOVE	@process_ptrs+040h,a13,L
	jrz	no_other_players
	movi	clever_addr,a2
	callr	start_them_doing_stuff

	MOVE	@process_ptrs+060h,a13,L
	jrz	no_other_players
	movi	clever_addr,a2
	callr	start_them_doing_stuff
no_other_players

	PULL	A13

	MOVI	120,A8
STILL_PROGRESS
	SLEEPK	1
	pushp	a8
	CALLR	SET_IMAGE_AND_FLASH
	pullp	a8
	CALLA	get_all_buttons_cur2
	JRNZ	EXIT_PROGRESS
	CMPI	100,A8
	JRNE	NO_START_TAUNTS
	PUSH	A13
	MOVE	@process_ptrs,a13,L
	movi	taunting_addr,a2
	callr	start_them_doing_stuff
	PULL	A13
NO_START_TAUNTS
	DEC	A8
	JRNN	STILL_PROGRESS

EXIT_PROGRESS

	CREATE0	DO_SET_IMAGE_AND_FLASH
	PUSHP	A0
	JSRP	CLOSE_PROGRESS_SCREEN
	PULLP	A0
	CALLA	KILL

	RETP

WHICH_MUSIC
	.word	5,2,1,7,6,4,8,0,3

SORT_OUT_WRESTLER_NUM
	MOVE	A4,A11
	SLL	24,A11
	SRL	24,A11
	CMPI	7,A11
	JRNE	NO_AVOID_UNUSED_WRESTLER
	INC	A11
NO_AVOID_UNUSED_WRESTLER
	RETS

SET_SCROLL_SPEED
	MOVE	A8,A0
	CMPI	16,A0
	JRGT	NO_CHANGE_SCROLL_SPEED
	ABS	A0
	SUBI	16,A0
	NEG	A0
	SRL	2,A0
	SLL	15,A0
	MOVI	RUN_SPEED,A9
	SUB	A0,A9
	clr	a0
	MOVE	A0,@TEMP_SPEED,L
	PUSH	A13
	MOVE	@process_ptrs,a13,L
	movi	standing_addr,a2
	callr	start_them_doing_stuff
	PULL	A13
NO_CHANGE_SCROLL_SPEED
	MOVE	A9,A5
	CALLA	get_all_buttons_cur2
	JRZ	NO_BUTTONS2
	SLL	1,A5
	DEC	A8
NO_BUTTONS2
	MOVE	@WORLDTLX,A4,L
	ADD	A5,A4
	move	a4,@WORLDTLX,L
	RETS

#PROGRESS_BMOD
	.long	LADDERBMOD
	.word	-60,-45
	.long	0

CREATE_TEMP_WRESTLER

	move	a8,*a13(PLYR_TYPE)
	move	a9,*a13(PLYR_SIDE)
	move	a10,*a13(PLYRNUM)
	move	a11,*a13(WRESTLERNUM)

	movi	112,a0
	move	a0,*a13(OBJ_PRIORITY)

	move	a10,a1
	calla	set_process_ptr

	move	a10,a0
	X32	a0
	addi	obj_look,a0
	move	*a0,a0,L		;* start of objects
	move	a0,*a13(OBJ_BASE),L
	move	a0,a10
	addi	32*MAX_PIECES,a10	;start at end to reverse priorities

	clr	a1			;y pos
	movi	D2ST2B03,a2		;* image
	movi	110,a3			;z pos
	movi	DMAWNZ|M_3D,a4		;DMA flags
	move	a4,*a13(OBJ_CONTROL)
	movi	CLSPLYR | TYPPLYR,a5	;object ID
	clr	a6			;x vel
	clr	a7			;y vel

	move	a13,b0
	move	*b0(WRESTLERNUM),b0
	X32	b0

	movk	MAX_PIECES,a9

#nopal_chng

	addi	#wrestler_pal,b0
	move	*b0,b0,L		;* palette

#nxt_obj
	PUSH	b0
	calla	BEGINOBJP
	PULL	b0
	move	a8,-*a10,L
	dsj	a9,#nxt_obj

	calla	BEGINOBJP
	move	a8,*a13(ATTIMG_IMG),L
	clr	a0
	move	a0,*a13(ATTIMG_CUR_FRAME),L
	move	a0,*a13(ATTIMG_LAST_FRAME),L

	move	*a8(OPAL),a0
	move	a0,*a13(OBJ_PAL)

	movi	shadow_p,a0

	calla	pal_getf
	move	*a13(OBJ_BASE),a8,L
	move	*a8,a8,L		;1st object
	move	a0,*a8(OPAL)		;set palette for shadow

	CLR	A0
	move	a0,*a13(GROUND_Y)

	clr	a0
;MJT Start
;	move	a0,*a13(BURNOUT_COUNT)
;MJT End
	move	a0,*a13(INRING)

	move	a0,*a13(OBJ_XVEL),L
	move	a0,*a13(OBJ_YVEL),L
	move	a0,*a13(OBJ_ZVEL),L

	move	*a13(PLYRNUM),a0
	JRZ	RUNNING_MAN
	CMPI	4,A0
	JRGE	DEAD_BODIES

	MOVI	8,A0
	MOVE	A0,*A13(FACING_DIR)
	MOVE	A0,*A13(NEW_FACING_DIR)

	MOVE	@NUM_OPPS,A0
	SLL	5,A0
	ADDI	WHICH_ZPOS_TABLE-020H,A0
	MOVE	*A0,A0,L
	move	*a13(PLYRNUM),A1
	DEC	A1
	SLL	6,A1
	ADD	A0,A1
	MOVE	*A1,A0,L
	MOVE	A0,*A13(OBJ_ZPOS),L
	MOVE	*A1(020H),A0,L
	ADDI	[375,0],A0
	MOVE	A0,*A13(OBJ_XPOS),L
	movi	100,a0
	move	a0,*A13(OBJ_YPOS),L

	movi	waiting_addr,a2
	callr	start_them_doing_stuff

	move	@PCNT,a14
	move	a14,*a13(FOOT_PCNT),W	;init foot timer

#loop1
	calla	wrestler_veladd		

	calla	animate_wrestler	

	SLOOP	1,#loop1

WHICH_ZPOS_TABLE
	.LONG	ONLY_ONE_OPP
	.LONG	TWO_OPPS
	.LONG	THREE_OPPS

ONLY_ONE_OPP
	.LONG	[470H,0],[300,0]
TWO_OPPS
	.LONG	[490H,0],[330,0]
	.LONG	[450H,0],[280,0]
THREE_OPPS
	.LONG	[4A0H,0],[345,0]
	.LONG	[470H,0],[300,0]
	.LONG	[440H,0],[255,0]

WHICH_ZPOS_TABLE_D
	.LONG	ONLY_ONE_OPP_D
	.LONG	TWO_OPPS_D
	.LONG	THREE_OPPS_D

ONLY_ONE_OPP_D
	.LONG	[450H,0],[300,0]
TWO_OPPS_D
	.LONG	[490H,0],[330,0]
	.LONG	[450H,0],[280,0]
THREE_OPPS_D
	.LONG	[4B0H,0],[345,0]
	.LONG	[490H,0],[300,0]
	.LONG	[440H,0],[255,0]

DEAD_BODIES
	MOVI	8,A0
	MOVE	A0,*A13(FACING_DIR)
	MOVE	A0,*A13(NEW_FACING_DIR)

	CLR	A0
	MOVE	A0,*A13(STARS_FLAG)

	movi	100,a0
	move	a0,*A13(OBJ_YPOS),L

	MOVE	@NUM_OLD_OPPS,A0
	SLL	5,A0
	ADDI	WHICH_ZPOS_TABLE_D-020H,A0
	MOVE	*A0,A0,L
	move	*a13(PLYRNUM),A1
	SUBI	4,A1
	SLL	6,A1
	ADD	A0,A1
	MOVE	*A1,A0,L
	MOVE	A0,*A13(OBJ_ZPOS),L
	MOVE	*A1(020H),A0,L
	MOVE	A0,*A13(OBJ_XPOS),L

	movi	dead_addr,a2
	callr	start_them_doing_stuff

	move	@PCNT,a14
	move	a14,*a13(FOOT_PCNT),W	;init foot timer
#loop2
	calla	animate_wrestler	

	SLOOP	1,#loop2

RUNNING_MAN
	MOVI	4,A0
	MOVE	A0,*A13(FACING_DIR)
	MOVE	A0,*A13(NEW_FACING_DIR)

	movi	standing_addr,a2
	callr	start_them_doing_stuff

	move	@PCNT,a14
	move	a14,*a13(FOOT_PCNT),W	;init foot timer

	movi	100,a0
	move	a0,*A13(OBJ_YPOS),L
	MOVI	[470h,0],A0
	MOVE	A0,*A13(OBJ_ZPOS),L
	MOVI	[140,0],A0
	MOVE	A0,*A13(OBJ_XPOS),L
	CLR	A0
	MOVE	A0,@TEMP_SPEED,L

#loop
	MOVE	@TEMP_SPEED,A3,L
	CALLA	get_all_buttons_cur2
	JRZ	#NO_BUTTONS
	SLL	1,A3
#NO_BUTTONS
	move	a3,*a13(OBJ_XVEL),L

	calla	wrestler_veladd		

	calla	animate_wrestler	

	SLOOP	1,#loop

#wrestler_pal
	.long	HRTPNK_P	;0	(Bret)
	.long	RZRGRN_P	;1	(Razor)
	.long	UNDBLK_P	;2	(Taker)
	.long	YOKRED_P	;3	(Yoko)
	.long	SHNRED_P	;4	(Shawn)
	.long	BAMBLU_P	;5	(Bam Bam)
	.long	DNKBLU_P	;6	(Doink)
	.long	DNKBLU_P	;7	(spare)
	.long	LEXWHT_P	;8	(Lex)
	.long	0		;9	(Referee)

start_them_doing_stuff
	movi	100h,a0
	move	a0,*a13(ANI_SPEED)	;normal speed animations

	move	*a13(WRESTLERNUM),a1
	SLL	6,a1
	add	a2,a1
	move	*a1+,a0,L
	push	a1
	calla	change_anim1a
	pull	a1
	move	*a1+,a0,L
	calla	change_anim2a
	rets

taunting_addr
	.long	hrt_taunt4_anim
	.long	hrt_torso4_anim
	.long	rzr_taunt4_anim
	.long	rzr_torso4_anim
	.long  	und_taunt4_anim
	.long	und_torso4_anim
         .long 	yok_taunt4_anim
	.long	yok_torso4_anim
	.long	shn_taunt4_anim
	.long	shn_torso4_anim
	.long	bam_taunt4_anim
	.long	bam_torso4_anim
	.long	dnk_taunt4_anim
	.long	dnk_torso4_anim
	.long	0,0		;7 spare
	.long	lex_taunt4_anim
	.long	lex_torso4_anim
	.long	0,0		;9 Referee

standing_addr
	.long	hrt_stand4_anim
	.long	hrt_torso4_anim
	.long	rzr_stand4_anim
	.long	rzr_torso4_anim
	.long  	und_stand4_anim
	.long	und_torso4_anim
         .long 	yok_stand4_anim
	.long	yok_torso4_anim
	.long	shn_stand4_anim
	.long	shn_torso4_anim
	.long	bam_stand4_anim
	.long	bam_torso4_anim
	.long	dnk_stand4_anim
	.long	dnk_torso4_anim
	.long	0,0		;7 spare
	.long	lex_stand4_anim
	.long	lex_torso4_anim
	.long	0,0		;9 Referee

dead_addr
	.long	hrt_dizzy_anim
	.long	hrt_torso4_anim
	.long	rzr_dizzy_anim
	.long	rzr_torso4_anim
	.long  	und_dizzy_anim
	.long	und_torso4_anim
         .long 	yok_dizzy_anim
	.long	yok_torso4_anim
	.long	shn_dizzy_anim
	.long	shn_torso4_anim
	.long	bam_dizzy_anim
	.long	bam_torso4_anim
	.long	dnk_dizzy_anim
	.long	dnk_torso4_anim
	.long	0,0		;7 spare
	.long	lex_dizzy_anim
	.long	lex_torso4_anim
	.long	0,0		;9 Referee

running_addr
	.long	hrt_run2_anim	;0 Bret Hart
	.long	hrt_torso4_anim
	.long	rzr_run2_anim	;1 Razor Ramon
	.long	rzr_torso4_anim
	.long  	und_run2_anim	;2 Undertaker
	.long	und_torso4_anim
         .long 	yok_run2_anim	;3 Yokozuna
	.long	yok_torso4_anim
	.long	shn_run2_anim	;4 Shawn Michaels
	.long	shn_torso4_anim
	.long	bam_run2_anim	;5 Bam Bam
	.long	bam_torso4_anim
	.long	dnk_run2_anim	;6 Doink
	.long	dnk_torso4_anim
	.long	0,0		;7 spare
	.long	lex_run2_anim	;8 Lex Luger
	.long	lex_torso4_anim
	.long	0,0		;9 Referee

clever_addr
	.long	hrt_clever_anim	;0 Bret Hart
	.long	hrt_torso4_anim
	.long	rzr_clever_anim	;1 Razor Ramon
	.long	rzr_torso4_anim
	.long  	und_clever_anim	;2 Undertaker
	.long	und_torso4_anim
         .long 	yok_clever_anim	;3 Yokozuna
	.long	yok_torso4_anim
	.long	shn_clever_anim	;4 Shawn Michaels
	.long	shn_torso4_anim
	.long	bam_clever_anim	;5 Bam Bam
	.long	bam_torso4_anim
	.long	dnk_clever_anim	;6 Doink
	.long	dnk_torso4_anim
	.long	0,0		;7 spare
	.long	lex_clever_anim	;8 Lex Luger
	.long	lex_torso4_anim
	.long	0,0		;9 Referee

waiting_addr
	.long	hrt_wait_anim	;0 Bret Hart
	.long	hrt_torso4_anim
	.long	rzr_wait_anim	;1 Razor Ramon
	.long	rzr_torso4_anim
	.long  	und_wait_anim	;2 Undertaker
	.long	und_torso4_anim
         .long 	yok_wait_anim	;3 Yokozuna
	.long	yok_torso4_anim
	.long	shn_wait_anim	;4 Shawn Michaels
	.long	shn_torso4_anim
	.long	bam_wait_anim	;5 Bam Bam
	.long	bam_torso4_anim
	.long	dnk_wait_anim	;6 Doink
	.long	dnk_torso4_anim
	.long	0,0		;7 spare
	.long	lex_wait_anim	;8 Lex Luger
	.long	lex_torso4_anim
	.long	0,0		;9 Referee

	.ref	B4RS4A
	.ref	Y4CO4D,Y4ST4Y
	.ref	D4CO4A
	.ref	U4CO4B
	.ref	S4CO4A
	.ref	R4CO4A
	.ref	L4CO4Z
	.ref	L4ST4A
	.ref	H4SL4C
	.ref	B4SW4B

	.ref	H4LD4A,R4LD4A,U4LD4A,Y4LD4A,S4LD4A
	.ref	B4RS4A,D4SQ4A,L4SW5A

hrt_wait_anim
	.WORD	ANI_XFLIP
	WL	100,H4LD4A+FR1
	.word	ANI_END
rzr_wait_anim
	WL	100,R4LD4A+FR1
	.word	ANI_END
und_wait_anim
	.WORD	ANI_XFLIP
	WL	100,U4LD4A+FR1
	.word	ANI_END
yok_wait_anim
	WL	ANI_CODE,CREATE_FUJI
	.WORD	ANI_XFLIP
	WL	100,Y4ST4Y+FR2
	.word	ANI_END
shn_wait_anim
	WL	100,S4LD4A+FR1
	.word	ANI_END
bam_wait_anim
	.WORD	ANI_OFFSET,-800,0,0
	WL	100,B4RS4A+FR1
	.word	ANI_END
dnk_wait_anim
	WL	100,D4SQ4A+FR1
	.word	ANI_END
lex_wait_anim
	WL	100,L4SW5A+FR2
	.word	ANI_END

hrt_clever_anim
	WL	6,H4LD4A+FR1
	WL	6,H4LD4A+FR2
	WL	6,H4LD4A+FR3
	WL	6,H4LD4A+FR4
	WL	6,H4LD4A+FR5
	WL	6,H4LD4A+FR6
	.word	ANI_END
rzr_clever_anim
	WL	6,R4LD4A+FR1
	WL	6,R4LD4A+FR2
	WL	6,R4LD4A+FR3
	WL	6,R4LD4A+FR4
	WL	6,R4LD4A+FR5
	WL	6,R4LD4A+FR6
	WL	6,R4LD4A+FR7
	WL	6,R4LD4A+FR2
	.word	ANI_END
und_clever_anim
;	.WORD	ANI_XFLIP
	WL	6,U4LD4A+FR1
	WL	6,U4LD4A+FR2
	WL	6,U4LD4A+FR3
	WL	6,U4LD4A+FR4
	WL	6,U4LD4A+FR5
	WL	6,U4LD4A+FR6
	WL	6,U4LD4A+FR7
	WL	6,U4LD4A+FR8
	WL	ANI_CODE,CREATE_URN
	.word	ANI_END
yok_clever_anim
	WL	ANI_CODE,DO_FUJI
	WL	20,Y4ST4Y+FR2
	WL	5,Y4LD4A+FR1
	WL	5,Y4LD4A+FR2
	WL	5,Y4LD4A+FR3
	WL	5,Y4LD4A+FR4
	WL	5,Y4LD4A+FR5
	WL	5,Y4LD4A+FR6
	.word	ANI_END
shn_clever_anim
	WL	6,S4LD4A+FR1
	WL	6,S4LD4A+FR2
	WL	6,S4LD4A+FR3
	WL	6,S4LD4A+FR4
	WL	6,S4LD4A+FR5
	WL	6,S4LD4A+FR6
	WL	45,S4LD4A+FR7
	WL	6,S4LD4A+FR10
	.word	ANI_END

bam_clever_anim
	.WORD	ANI_XFLIP
	.WORD	ANI_OFFSET,800,0,0
	.word	ANI_SETMODE,MODE_NOSHADOW
	WL	ANI_CODE,BAM_RISE_SOUND
	WL	6,B4RS4A+FR1
	WL	6,B4RS4A+FR2
	WL	6,B4RS4A+FR3
	WL	6,B4RS4A+FR4
	.word	ANI_SETMODE,MODE_NORMAL
	WL	6,B4RS4A+FR5
	WL	6,B4RS4A+FR6

;Send smoke puffs off from bam bam!
	WL	ANI_CODE,start_smoke

	WL	4,B4SW4B+FR3
	WL	4,B4SW4B+FR4
	WL	4,B4SW4B+FR5
	WL	4,B4SW4B+FR6
	WL	4,B4SW4B+FR7
	WL	4,B4SW4B+FR8

	WL	4,B4SW4B+FR3
	WL	4,B4SW4B+FR4
	WL	4,B4SW4B+FR5
	WL	4,B4SW4B+FR6
	WL	4,B4SW4B+FR7
	WL	4,B4SW4B+FR8

	WL	4,B4SW4B+FR3
	WL	4,B4SW4B+FR4
	WL	4,B4SW4B+FR5
	WL	4,B4SW4B+FR6
	WL	4,B4SW4B+FR7
	WL	4,B4SW4B+FR8

	WL	ANI_CHANGEANIM,bam_stand4_anim

BAM_RISE_SOUND
	movi	41h,a0
	CALLA	triple_sound
	RETS

start_smoke
;10% of time put smoke on bam bam
	movi	100,a0
	.ref	RNDPER
	calla	RNDPER
	jrls	#out
	move	a13,a10
	CREATE0	body_smoke
#out
	rets

#*******************************
* Smoke trail (Process)
* A10=*wrestler proc

body_smoke

	clr	a11
	movk	3,a11
#lp	CREATE0	smokepuff
;Need an explosion sound
	SLEEPK	3
	inc	a11
	cmpi	17,a11
	jrlt	#lp

	DIE

#*******************************
* Smoke trail puff (Process)
* A10=*wrestler proc

smokepuff

	move	*a10(OBJ_ZPOSINT),a3
	movk	3,a0
	calla	RNDRNG0
;	subk	2,a0
	add	a0,a3			;-2 to 1
;	addk	16,a3
	ori	1000h,a3

	movk	3,a0
	calla	RNDRNG0
	sll	5,a0			;*32
	addi	smoke_t,a0
	move	*a0,a9,L

	movi	30000h,a0
	calla	RNDRNG0
	subi	18000h,a0
	move	a0,a6

;	movi	[1,8000h],a6

	movi	20000h,a0
	calla	RNDRNG0
	addi	6000h,a0
	neg	a0
	move	a0,a7
;	movi	[-2,0],a7

	move	a11,a14
;	sll	4,a14
;	addi	#x_tbl,a14
;	move	*a14,a1


	movk	30,a0
	calla	RNDRNG0
	subk	15,a0
	move	a0,a1

	move	*a10(OBJ_XPOSINT),a0

	move	*a10(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#no_flip
;	neg	a6
	neg	a1
#no_flip

	add	a1,a0
	sll	16,a0			;X

	move	a11,a14
	sll	4,a14
	addi	#y_tbl,a14
	move	*a14,a14

	movi	Y_SCALE_MULTIPLIER,a2
	move	*a10(OBJ_ZPOSINT),a1
	mpyu	a2,a1
	move	*a10(OBJ_YPOSINT),a2
	sub	a14,a2
	sll	16,a2
	sub	a2,a1

	movi	CLDB1ORNG,a2
	movi	DMAWNZ|M_3D|M_NOCOLL,a4
	movi	CLSDEAD,a5

	calla	BEGINOBJ

	SLEEPK	3

	jauc	FRQDELDIE

	.ref	smoke_t

;#x_tbl	.word	-14,-3,10,25,30,31,30,39,26,-3,17,32,53,54,41,32,45
#y_tbl	.word	-82,-85,-88,-91,-94,-97,-100,-83,-85,-87,-89,-91,-93,-95
	.word	-97,-99,-99

dnk_clever_anim
	.WORD	ANI_XFLIP
	WL	6,D4SQ4A+FR1
	WL	6,D4SQ4A+FR2
	WL	6,D4SQ4A+FR3
	WL	ANI_CODE,CREATE_WATER
	WL	5,D4SQ4A+FR3
	WL	6,D4SQ4A+FR2
	WL	6,D4SQ4A+FR1
	.word	ANI_END

lex_clever_anim
	WL	6,L4SW5A+FR2
	WL	6,L4SW5A+FR3
	WL	6,L4SW5A+FR4
	WL	6,L4SW5A+FR5
	WL	6,L4SW5A+FR6
	WL	6,L4SW5A+FR7
	WL	6,L4SW5A+FR8
	WL	6,L4SW5A+FR9
	WL	6,L4SW5A+FR10
	WL	2,L4SW5A+FR9
	WL	2,L4SW5A+FR10
	WL	2,L4SW5A+FR9
	WL	2,L4SW5A+FR10
	WL	2,L4SW5A+FR9
	WL	2,L4SW5A+FR10
	WL	2,L4SW5A+FR9
	WL	2,L4SW5A+FR10
	WL	2,L4SW5A+FR9
	WL	2,L4SW5A+FR10
	WL	2,L4SW5A+FR9
	WL	2,L4SW5A+FR10
	WL	2,L4SW5A+FR9
	WL	2,L4SW5A+FR10
	WL	2,L4SW5A+FR9
	WL	2,L4SW5A+FR10
	WL	2,L4SW5A+FR9
	WL	2,L4SW5A+FR10
	WL	2,L4SW5A+FR9
	WL	2,L4SW5A+FR10
	WL	2,L4SW5A+FR9
	WL	2,L4SW5A+FR10
	WL	2,L4SW5A+FR9
	WL	2,L4SW5A+FR10
	WL	2,L4SW5A+FR9
	WL	2,L4SW5A+FR10
	WL	2,L4SW5A+FR9
	WL	2,L4SW5A+FR10
	WL	6,L4SW5A+FR9
	WL	6,L4SW5A+FR8
	WL	6,L4SW5A+FR7
	WL	6,L4SW5A+FR6
	WL	6,L4SW5A+FR5
	WL	6,L4SW5A+FR4
	WL	6,L4SW5A+FR3
	WL	6,L4SW5A+FR2

	.word	ANI_END

hrt_taunt4_anim
	WL	5,H4SL4C+FR1
	WL	5,H4SL4C+FR2
	WL	5,H4SL4C+FR3

BRT_TAUNT_LOOP
	WL	5,H4SL4C+FR4
	WL	5,H4SL4C+FR5
	WL	5,H4SL4C+FR6
	WL	5,H4SL4C+FR5
	WL	5,H4SL4C+FR4
	WL	5,H4SL4C+FR7
	WL	5,H4SL4C+FR8
	WL	5,H4SL4C+FR9
	WL	5,H4SL4C+FR8
	WL	5,H4SL4C+FR7

	WL	ANI_GOTO,BRT_TAUNT_LOOP

rzr_taunt4_anim
	WL	4,R4CO4A+FR1
	WL	4,R4CO4A+FR2
	WL	4,R4CO4A+FR3
	WL	4,R4CO4A+FR4
RZR_TAUNT_LOOP
	WL	15,R4CO4A+FR5
	WL	4,R4CO4A+FR6
	WL	4,R4CO4A+FR7
	WL	4,R4CO4A+FR8
	WL	4,R4CO4A+FR7
	WL	4,R4CO4A+FR6
	WL	4,R4CO4A+FR5
	WL	4,R4CO4A+FR6
	WL	4,R4CO4A+FR7
	WL	4,R4CO4A+FR8
	WL	4,R4CO4A+FR7
	WL	4,R4CO4A+FR6

	WL	ANI_GOTO,RZR_TAUNT_LOOP

und_taunt4_anim
	WL	6,U4CO4B+FR1
	WL	6,U4CO4B+FR2
UND_TAUNT_LOOP
	WL	15,U4CO4B+FR3
	WL	6,U4CO4B+FR4
	WL	6,U4CO4B+FR5
	WL	6,U4CO4B+FR6
	WL	6,U4CO4B+FR7
	WL	6,U4CO4B+FR8
	WL	6,U4CO4B+FR7
	WL	6,U4CO4B+FR6
	WL	6,U4CO4B+FR5
	WL	6,U4CO4B+FR4
	WL	ANI_GOTO,UND_TAUNT_LOOP

yok_taunt4_anim
	WL	4,Y4CO4D+FR1
	WL	4,Y4CO4D+FR2
YOK_TAUNT_LOOP
	WL	5,Y4CO4D+FR3
	WL	5,Y4CO4D+FR4
	WL	5,Y4CO4D+FR5
	WL	5,Y4CO4D+FR6
	WL	5,Y4CO4D+FR7
	WL	5,Y4CO4D+FR8
	WL	ANI_GOTO,YOK_TAUNT_LOOP

shn_taunt4_anim
	WL	4,S4CO4A+FR1
	WL	4,S4CO4A+FR2
	WL	4,S4CO4A+FR3
SHN_TAUNT_LOOP
	WL	4,S4CO4A+FR4
	WL	4,S4CO4A+FR5
	WL	4,S4CO4A+FR6
	WL	4,S4CO4A+FR7
	WL	4,S4CO4A+FR8
	WL	4,S4CO4A+FR7
	WL	4,S4CO4A+FR6
	WL	4,S4CO4A+FR5
	WL	4,S4CO4A+FR4
	WL	4,S4CO4A+FR3
	WL	4,S4CO4A+FR2
	WL	4,S4CO4A+FR3
	WL	ANI_GOTO,SHN_TAUNT_LOOP

bam_taunt4_anim
	WL	ANI_CODE,BAM_TAUNT_SOUND
bam_taunt4_anim_no_fx
	WL	4,B4SW4B+FR3
	WL	4,B4SW4B+FR4
	WL	4,B4SW4B+FR5
	WL	4,B4SW4B+FR6
	WL	4,B4SW4B+FR7
	WL	4,B4SW4B+FR8
	WL	ANI_GOTO,bam_taunt4_anim_no_fx

BAM_TAUNT_SOUND
	movi	42h,a0
	CALLA	triple_sound
	RETS

dnk_taunt4_anim
	WL	5,D4CO4A+FR1
	WL	5,D4CO4A+FR2
	WL	5,D4CO4A+FR3
	WL	5,D4CO4A+FR4
	WL	5,D4CO4A+FR5
	WL	5,D4CO4A+FR6
DNK_TAUNT_LOOP
	WL	5,D4CO4A+FR5
	WL	5,D4CO4A+FR4
	WL	5,D4CO4A+FR3
	WL	5,D4CO4A+FR4
	WL	5,D4CO4A+FR5
	WL	5,D4CO4A+FR6
	WL	ANI_GOTO,DNK_TAUNT_LOOP

lex_taunt4_anim
LEX_TAUNT_LOOP
	WL	5,L4CO4Z+FR1
	WL	5,L4CO4Z+FR2
	WL	5,L4CO4Z+FR3
	WL	5,L4CO4Z+FR4
	WL	5,L4CO4Z+FR5
	WL	5,L4CO4Z+FR6
	WL	5,L4CO4Z+FR7
	WL	5,L4CO4Z+FR8
	WL	5,L4CO4Z+FR9

	WL	5,L4CO4Z+FR8
	WL	5,L4CO4Z+FR7
	WL	5,L4CO4Z+FR6
	WL	5,L4CO4Z+FR5
	WL	5,L4CO4Z+FR4
	WL	5,L4CO4Z+FR3
	WL	5,L4CO4Z+FR2
	WL	ANI_GOTO,LEX_TAUNT_LOOP


CREATE_FUJI
	MMTM	SP,A0,A1,A2,A4,A5,A6,A7,A8,A9,A10,A11,A14
	CLR	A8
	MOVE	@NUM_OPPS,A1
	DEC	A1
	JRNZ	NO_CREATE_FUJI

	MOVE	*A13(OBJ_XPOS),A0,L
	ADDI	[30,0],A0
	MOVE	A0,*A13(OBJ_XPOS),L
	SUBI	[80,0],A0
	MOVI	[240,0],A1
	MOVE	*A13(OBJ_ZPOS),A3,L
	SRL	16,A3
	DEC	A3
	ORI	1000H,A3
	.ref	shadow
	MOVI	shadow,A2
	MOVI	DMAWNZ,A4
	CLR	A5
	CLR	A6
	CLR	A7
	CALLA	BEGINOBJ

	MOVE	*A13(OBJ_XPOS),A0,L
	SUBI	[80,0],A0
	MOVI	[240,0],A1
	MOVE	*A13(OBJ_ZPOS),A3,L
	SRL	16,A3
	ORI	1000H,A3

	MOVI	FUJI01,A2

	movi	DMAWNZ,a4	;DMA flags
	CLR	A5
	CLR	A6
	CLR	A7
	CALLA	BEGINOBJ
NO_CREATE_FUJI
	MOVE	A8,@FUJI_OBJ,L
	MMFM	SP,A0,A1,A2,A4,A5,A6,A7,A8,A9,A10,A11,A14
	RETS

DO_FUJI
	MMTM	SP,A1,A7,A8,A9
	MOVE	@FUJI_OBJ,A8,L
	JRZ	MORE_THAN_ONE_OPP
	MOVI	FUJI_ANIM,A9
	CREATE0	ANIMATE_OBJ
MORE_THAN_ONE_OPP
	MMFM	SP,A1,A7,A8,A9
	RETS

ANIMATE_OBJ
	MOVE	A9,A1
	CALLA	setup_back_anim
	JSRP	ANIM_CROWD
	DIE

FUJI_ANIM
	WL	7,FUJI01
	WL	7,FUJI02
	WL	7,FUJI03
	WL	60,FUJI04
	WL	7,FUJI03
	WL	7,FUJI02
	WL	7,FUJI01
	.WORD	CANI_END

CREATE_URN
	MMTM	SP,A0,A1,A2,A4,A5,A6,A7,A8,A9,A10,A11,A14
	MOVE	*A13(OBJ_XPOS),A0,L
	movi	Y_SCALE_MULTIPLIER,a3
	move	*a13(OBJ_ZPOSINT),a1
	mpyu	a3,a1
	SUBI	[5aH,0],A1
	MOVE	*A13(OBJ_ZPOS),A3,L
	SRL	16,A3
	INC	A3
	ORI	1000H,A3
	MOVI	BLUURN01,A2
	MOVI	DMAWNZ,A4
	CLR	A5
	CLR	A6
	CLR	A7
	CALLA	BEGINOBJ
	MOVI	URN_ANIM,A9
	CREATE0	ANIMATE_OBJ
	MMFM	SP,A0,A1,A2,A4,A5,A6,A7,A8,A9,A10,A11,A14
	RETS

URN_SOUND
	movi	40h,a0
	CALLA	triple_sound
	RETS

URN_ANIM
	WL	CANI_CODE,URN_SOUND
	WL	6,BLUURN01
	WL	6,BLUURN02
	WL	6,BLUURN03
	WL	6,BLUURN04
	WL	6,BLUURN05
	.WORD	CANI_END

CREATE_WATER
	MMTM	SP,A0,A1,A2,A4,A5,A6,A7,A8,A9,A10,A11,A14
	MOVE	*A13(OBJ_XPOS),A0,L
	SUBI	[10,0],A0
	movi	Y_SCALE_MULTIPLIER,a3
	move	*a13(OBJ_ZPOSINT),a1
	mpyu	a3,a1
	SUBI	[58H,0],A1

	MOVE	*A13(OBJ_ZPOS),A3,L
	SRL	16,A3
	INC	A3
	ORI	1000H,A3
	MOVI	WATER01,A2
	MOVI	DMAWNZ,A4
	CLR	A5
	CLR	A6
	CLR	A7
	CALLA	BEGINOBJ
	MOVI	WATER_ANIM,A9
	CREATE0	ANIMATE_OBJ
	MOVE	*A13(PLYRNUM),*A0(PDATA+UNUSED)
	MMFM	SP,A0,A1,A2,A4,A5,A6,A7,A8,A9,A10,A11,A14
	RETS

WATER_ANIM
	WL	CANI_CODE,WATER_SOUND
	WL	4,WATER01
	WL	4,WATER02
	WL	CANI_CODE,START_WATER
	WL	15,WATER03
	WL	CANI_CODE,STOP_WATER
	WL	4,WATER04
	WL	4,WATER05
	WL	4,WATER06
	WL	4,WATER07
	WL	CANI_CODE,KILL_WATER
	.WORD	CANI_END

KILL_WATER
	movi	-400,a1
	MOVE	A1,*A8(OXPOS)
	rets

START_WATER
	MOVI	WATER_PID,A1
	MOVE	*A13(PDATA+UNUSED),A2
	DEC	A2
	ADD	A2,A1
	MOVI	MOVE_WATER,A7
	MOVE	*A8(OXVAL),A9,L
	SUBI	[240H,0],A9
	MOVI	15,A5
	DIVS	A5,A9
	JAUC	GETPRC

MOVE_WATER
	MOVE	*A8(OXVAL),A1,L
	SUB	A9,A1
	MOVE	A1,*A8(OXVAL),L
	SLOOP	1,MOVE_WATER

STOP_WATER
	MOVI	WATER_PID,A0
	MOVE	*A13(PDATA+UNUSED),A2
	DEC	A2
	ADD	A2,A0
	MOVE	A0,A1
	CALLA	KILALL
	RETS

WATER_SOUND
	movi	3fh,a0
	CALLA	triple_sound
	RETS

	.end
