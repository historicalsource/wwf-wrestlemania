***************************************************************
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
	.include	"crowdimg.glo"
	.include	"miscimg.glo"
	.INCLUDE	"LOGO.GLO"

	.ref	WHICH_SKIRT_PAL,RNDPER,start_credbox,triple_sound
	.ref	CLEAR_PROCESSES,SPECIAL_WIPEOUT
	.ref	DUMRETS,HRT3,RZR3,UND3,YOK3,SHN3,BAM3,DNK3,LEX3
	.ref	RNDRNG0,HALT,dtype,dpageflip,IRQSKYE,WORLDTLX,WORLDTLY
	.ref	BAKMODS,BGND_UD1,set_process_ptr,animate_wrestler
	.ref	animate_wrestler1,animate_wrestler2,wrestler_veladd
	.ref	ani_init,PSTATUS,pal_getf,PCNT,index1,index2,obj_look
	.ref	set_images,change_anim1a,change_anim2a,match_time
	.ref	process_ptrs,reduce_bog
	.ref	hrt_run2_anim,rzr_run2_anim,und_run2_anim,yok_run2_anim
	.ref	shn_run2_anim,bam_run2_anim,dnk_run2_anim,lex_run2_anim
	.ref	hrt_torso4_anim,rzr_torso4_anim,und_torso4_anim
	.ref	yok_torso4_anim,shn_torso4_anim,bam_torso4_anim
	.ref	dnk_torso4_anim,lex_torso4_anim,hrt_stand4_anim
	.ref	rzr_stand4_anim,und_stand4_anim,yok_stand4_anim
	.ref	shn_stand4_anim,bam_stand4_anim,dnk_stand4_anim
	.ref	lex_stand4_anim,hrt_dizzy_anim,rzr_dizzy_anim
	.ref	und_dizzy_anim,yok_dizzy_anim,shn_dizzy_anim
	.ref	bam_dizzy_anim,dnk_dizzy_anim,lex_dizzy_anim
	.ref	get_all_buttons_cur2,MAKE_UP_LOGO,GAMSTATE,animate_back
	.ref	dirqcnt,SNDSND,VINCE_START_GAME,WHICH_SCREEN,TOP_LEFT
	.ref	BOT_RIGHT,dma_it_out,SHAKER,OPEN_SCREEN_LINE,D2ST2B03
	.REF	LBAR_GENB
	.ref	win_ascii,MUSIC_HAP
	.ref	HRTPNK_P,UNDBLK_P

	.ref	 message_palette
	.ref	 dec_to_asc
	.ref	 match_cnt
	.ref	 mess_space_width
	.ref	 print_string_R
	.ref	 print_string
	.ref	 print_string_C
	.ref	 message_ascii
	.ref	 mess_spacing
	.ref	 mess_cursx
	.ref	 mess_cursy
	.ref	 copy_string
	.ref	p1winstreak
	.ref	p2winstreak
	.ref	mess_z
	.ref	print_string_with_z
	.ref	RC_BYTEI
	.ref	message_buffer
	.REF	wsf14_ascii
	.ref	show_progress_bicons
	.ref	del_progress_icon
	.REF	print_string_Z2

	.ref	print_string2
	.ref	setup_message
	.ref	mess_objid
	.ref	font9_ascii
	.ref	belt_ask,belt_type
	.ref	AUD1
	.ref	hscore_colcyc
	.ref	osgemd_ascii
	.ref	JUDDER_SHADOW
	.ref	shadow
	.REF	H4ST4A02
	.ref	powerup_check
	.ref	KIL1C
	.ref	_switch_addr
	.ref	WSF14_1,WSF14_2
	.ref	BEGINOBJ_TBL
	.ref	get_stick_val_cur
	.ref	get_but_val_cur
	.ref	pal_clean

	.def	tonites_matchup
	.def	tonites_str
	.DEF	DO_FLASH,DO_JASON_CROWD,DO_TONY_CROWD
	.DEF	DO_VOGEL_CROWD
	.DEF	OPEN_PROGRESS_SCREEN
	.DEF	SORT_OUT_WRESTLER_NUM
	.DEF	RESETUP_PROGRESS
	.DEF	CLOSE_PROGRESS_SCREEN
	.DEF	INIT_LADDER_TABLE
	.DEF	IGNORE_SPECIAL,IGNORE_THIS_PAL
	.DEF	START_FLASHES

	.DEF	ANIM_CROWD
	.DEF	setup_back_anim

NUM_LADDER_ENTRIES	equ	15

	.even
	.bss	TEMP_SPEED,32
	BSSX	CURRENT_LADDER,32
	.bss	a_big_useless_hole,32
	BSSX	LADDER,NUM_LADDER_ENTRIES*32
	BSSX	TEMP_LADDER,8*8
	.bss	TEMP_LADDER_END,0

	BSSX	FINAL_BATTLE_LINEUP,10*8

	BSSX	FLASH_FLAG,16
	BSSX	question_type,16
	BSSX	royal_rumble,16

	BSSX	FINAL_PTR,32
	.bss	SCREEN_SHAKE,32
	BSSX	NUM_OPPS,16
	.bss	NUM_OLD_OPPS,16
	.bss	TOP_LEFT_2,32
	.bss	BOT_RIGHT_2,32
	.bss	FUJI_OBJ,32
	.bss	WHICH_PAL,16*9
	.bss	IGNORE_SPECIAL,16

	BSSX	YES_ITS_FINAL,16
	.bss	pcurs_obj,4*32
	.bss	p1sel,16
	.bss	p2sel,16

INTER_DEFAULT		.set	1


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
NUM_PAL_BLOC		.EQU	26

	.BSS	PAL_BLOC_START,P_SIZE*NUM_PAL_BLOC
;	.BSS	PAL_PNTR,32
	BSSX	WHAT_SPEED,16
	.BSS	WHAT_DELAY,16

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
	MMTM	SP,A1,A3,A4
	MOVI	NUM_PAL_BLOC,A3
	MOVI	PAL_BLOC_START,A4
CHECK_NEXT_PAL_BLOC
	MOVE	*A4(P_WHICH_PAL),A1,L
	JRZ	WE_HIT_THE_END
	CMP	A0,A1
	JREQ	NO_NEED_TO_RESTORE
	ADDI	P_SIZE,A4
	DSJS	A3,CHECK_NEXT_PAL_BLOC
	JRUC	EMERG_EXIT
WE_HIT_THE_END
	MOVE	A0,*A4(P_WHICH_PAL),L
	calla	pal_getf
	MOVE	A0,*A4(P_DMA_PAL_VAL)
NO_NEED_TO_RESTORE
	MOVE	A4,A0
EMERG_EXIT
	MMFM	SP,A1,A3,A4
	RETS

RESETUP_PROGRESS
	MOVI	BLAST_OUT_PROGRESS_TRANS,A0
	MOVE	A0,@WHICH_SCREEN,L
	RETS

OPEN_PROGRESS_SCREEN

	movk	16,a0
	calla	triple_sound

	MOVE	@WHAT_SPEED,A9
	MOVE	@WHAT_DELAY,A8

;	MOVI	P_DELAY,A8
;	MOVI	200/P_DELAY,A9

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

	CREATE0	LOOK_FOR_PALS
	CREATE	PU_CHECK_PID,powerup_check

	CLR	A0
	MOVE	A0,@SCREEN_SHAKE,L

	MOVI	BLAST_OUT_PROGRESS_TRANS,A0
	MOVE	A0,@WHICH_SCREEN,L

	MOVI	PAL_BLOC_START,A0
	MOVI	NUM_PAL_BLOC,A4
	CLR	A1
CLEAR_OUT_PAL_BLOC
	MOVE	A1,*A0(P_WHICH_PAL),L
	ADDI	P_SIZE,A0
	DSJS	A4,CLEAR_OUT_PAL_BLOC

	MOVK	1,A0
	MOVE	A0,@IGNORE_SPECIAL

	CALLR	INIT_BLOC

	CALLR	SETUP_LOGOS

;	movk	16,a0
	movi	35h,a0		;special hi-priority version
	calla	triple_sound

	MOVI	P_DELAY,A8
	MOVI	200/P_DELAY,A9

	calla	get_all_buttons_cur2

	JRZ	SPEED_POWER_SET
	SWAP	A8,A9

SPEED_POWER_SET
	MOVE	A8,@WHAT_DELAY
	MOVE	A9,@WHAT_SPEED

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

	movi	0a5h,a0
	calla	triple_sound

	MOVE	@WHAT_DELAY,A0
	CMPI	200/P_DELAY,A0
	JREQ	JUST_LOOK_FOR_POWERS

	CALLR	CREATE_BITS
	CREATE0	SHAKE_MY_WORLD

	SLEEP	35+24

JUST_LOOK_FOR_POWERS
	SLEEPK	10
	RETP

SHAKE_MY_WORLD
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
	DIE

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

 SUBR   NEXT_IN_LADDER
	MMTM	SP,A2,A3,A4,A14
	ADDI	32,A10

	;Whoa!  If this is the first battle, arrange the table such that
	; the human's wrestler is last.
	cmpi	LADDER,a10
	jrne	#lad_ok
;	callr	put_human_last
#lad_ok	MOVE	*A10,A1,L
	MOVE	A1,A2
	SRL	24,A2
	SLL	24,A2
	CMPI	01000000H,A2
	JREQ	NO_SORT_OPPS

	;it's a multiple-wrestler fight.  Scramble the current entry.
	callr	scramble_table_entry

	;sort so that shawn ends up in the third slot: >03040x0x
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


 SUBR	NUM_OF_OPPS
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


#*****************************************************
*
 SUBRP	#do_rr_vs
	move	@index1,a1
	movi	-200,a6
	callr	FIND_LOGO_IMAGE
	callr	INIT_BLOC_STUFF
	move	*a1(ISIZEY),a3
	movi	128,a5
	sub	a3,a5
	srl	1,a5
	sll	16,a5
	callr	SETUP_THIS_LOGO_DAG

	move	@index2,a1
	movi	-200,a6
	callr	FIND_LOGO_IMAGE
	callr	INIT_BLOC_STUFF
	move	*a1(ISIZEY),a3
	movi	128,a5
	sub	a3,a5
	srl	1,a5
	addi	128,a5
	sll	16,a5
	callr	SETUP_THIS_LOGO_DAG

	movk	9,a1
	movi	400,a6
	callr	FIND_LOGO_IMAGE
	callr	INIT_BLOC_STUFF
	move	*a1(ISIZEY),a3
	movi	255,a5
	sub	a3,a5
	srl	1,a5
	sll	16,a5
	callr	SETUP_THIS_LOGO_DAG

	rets

SETUP_LOGOS
	move	@royal_rumble,a1
	jrz	#head_to_head
	move	@PSTATUS,a1
	cmpi	3,a1
	jrz	#do_rr_vs
#head_to_head


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
;	JRZ	WE_HAVE_COMPANY
	CMPI	3,A0
	JREQ	WE_HAVE_COMPANY

	CMPI	400,A6
	JREQ	SET_A6_TO_MINUS_200
	MOVI	400,A6
	JRUC	A6_SET

SET_A6_TO_MINUS_200
	MOVI	-200,A6
A6_SET

	PUSHP	A2
	MOVE	@NUM_OPPS,A7
	MOVE	@CURRENT_LADDER,A10,L
	MOVE	*A10,A10,L
	CALLR	is_8_on_1
	PUSHST
	JRNC	SLAP_UP_NEXT_LOGO
	MOVK	1,A7
	MOVI	9,A10

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
	POPST
	PUSHST
	JRNC	SLAP_UP_NEXT_LOGO_DAG_Y
	MOVK	1,A7
	MOVI	9,A10

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

	PULLP	A2

	MOVI	255,A11
	SUB	A5,A11
	SRL	1,A11

	MOVE	@NUM_OPPS,A7
	MOVE	@CURRENT_LADDER,A10,L
	MOVE	*A10,A10,L
	POPST
	JRNC	SLAP_UP_NEXT_LOGO_DAG
	MOVK	1,A7
	MOVI	9,A10

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
	.long	WWFCHAL
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
	MOVE	@FLASH_FLAG,A0
	JRNZ	ALREADY_FLASHING
	move	@reduce_bog,a14
	jrnz	ALREADY_FLASHING

;	MOVI	FLASH_PID,A0
;	movi	-1,a1
;	CALLA	EXISTP
;	JRNZ	ALREADY_FLASHING

	MOVE	@WORLDTLY,A0,L
	cmpi	19C000H,a0
	jrgt	ALREADY_FLASHING

	MOVI	18,A8
	MOVI	500,A9
	CREATE	FLASH_PID,SET_GAME_FLASHES
	MOVK	1,A0
	MOVE	A0,@FLASH_FLAG
ALREADY_FLASHING
	RETS

 SUBR	START_HI_FLASHES
	MOVE	@FLASH_FLAG,A0
	JRNZ	ALREADY_FLASHING
	move	@reduce_bog,a14
	jrnz	ALREADY_FLASHING

	MOVI	40,A8
	MOVI	1000,A9
	CREATE	FLASH_PID,SET_GAME_FLASHES
	MOVK	1,A0
	MOVE	A0,@FLASH_FLAG
	RETS

SET_GAME_FLASHES
	MOVE	@PSTATUS,A0
	CMPI	3,A0
	JREQ	ALWAYS_DO_FLASH
	MOVE	@NUM_OPPS,A0
	CMPI	2,A0
	JRGE	NO_CREATE_ANY_FLASH
ALWAYS_DO_FLASH
	MOVE	A9,A0
	CALLA	RNDPER
	JRLS	NO_CREATE_ANY_FLASH
SET_GAME_FLASHES2
	CMPI	1000,A9
	JREQ	ALWAYS_FLASH
	MOVE	@HCOUNT,A0
	SRL	1,A0
	JRNC	NO_CREATE_RANDOM_G
ALWAYS_FLASH
	CREATE0	RANDOM_GAME_FLASHES
NO_CREATE_RANDOM_G
	SLEEP	2
	DSJS	A8,SET_GAME_FLASHES2
NO_CREATE_ANY_FLASH
	CLR	A0
	MOVE	A0,@FLASH_FLAG
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
	move	a1,a1
	jrn	dont_bother
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
dont_bother
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
	move	@reduce_bog,a14
	jrnz	#rets
	MMTM	SP,A0,A1,A7,A8
	MOVE	@GAMSTATE,A8
	CMPI	INPREGAME2,A8
	JRNE	NO_DO_THIS
	MOVE	A0,A8
	CREATE0	DO_CROWD_FLASH
NO_DO_THIS
	MMFM	SP,A0,A1,A7,A8
#rets	RETS

**********************************

DO_CROWD_FLASH	;process

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

**********************************

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
	CMPI	INPREGAME2,A8
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
	CMPI	INPREGAME2,A8
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
	CMPI	INPREGAME2,A8
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
LADDER_TABLE_ICONT		;intercontinental belt table

	.word	4,1
	.word	2,2
	.word	1,3
	.word	-1

LADDER_TABLE_WCHAMP		;world championship belt table
	.word	4,2
	.word	2,3		;final battle
	.word	1,3
	.word	-1

FINAL_BATTLE	equ	7	;14th battle is last one. (keep up-to-date)

#*********
*
* returns carry set if the current battle is the last one on our ladder.

 SUBR	is_final_match

	move	@CURRENT_LADDER,a14,L
	cmpi	LADDER+((FINAL_BATTLE-1)*20h),a14
	jrne	#no
	setc
	rets

#no	clrc
	rets

#*********
*
* returns carry set if the current battle is an 8-on-1.

 SUBR	is_8_on_1

	;no 8-on-1 in intercontinental belt table.
	move	@belt_type,a14
	jrz	#no

	move	@CURRENT_LADDER,a14,L
	cmpi	LADDER+((FINAL_BATTLE-1)*20h),a14
	jrne	#no
	setc
	rets

#no	clrc
	rets

#*********
*
* generates a lineup for a royal rumble match

 SUBR	get_royal_lineup

	callr	get_final_lineup

	move	@index1,a1
	move	@index2,a2

	move	@FINAL_BATTLE_LINEUP,a3,L
	move	@FINAL_BATTLE_LINEUP+20h,a4,L

	;if either index matches either of the first two entries in a3,
	; swap a3 and a4.  Then look at a3 again, and if one still matches,
	; rotate it 16 bits.
	move	a3,a5
	andi	>00FF,a5
	move	a3,a6
	andi	>FF00,a6
	srl	8,a6

	cmp	a1,a5
	jreq	#swap
	cmp	a2,a5
	jreq	#swap
	cmp	a1,a6
	jreq	#swap
	cmp	a2,a6
	jreq	#swap
	jruc	#ok

#swap	SWAP	a3,a4

	move	a3,a5
	andi	>00FF,a5
	move	a3,a6
	andi	>FF00,a6
	srl	8,a6

	cmp	a1,a5
	jreq	#rot
	cmp	a2,a5
	jreq	#rot
	cmp	a1,a6
	jreq	#rot
	cmp	a2,a6
	jreq	#rot
	jruc	#ok

#rot	rl	16,a3

#ok	move	a3,@FINAL_BATTLE_LINEUP,L
	move	a4,@FINAL_BATTLE_LINEUP+20h,L

	rets

#*********
*
* generates a new final battle lineup

 SUBR	get_final_lineup

	callr	INIT_TEMP_TABLE
	callr	RANDOMIZE_ORDER

	;now just copy 8 bytes from TEMP_LADDER to FINAL_BATTLE_LINEUP
	movi	TEMP_LADDER,a0
	movi	FINAL_BATTLE_LINEUP,a1
	move	*a0+,*a1+,L		;first four
	move	*a0+,*a1+,L		;last four

	;set the end-of-battle marker
	movi	-1,a14
	move	a14,*a1,W
	rets

;**************************************************************************
;*									  *
;* Each entry in the ladder table is in the format of a long		  *
;* word, OP4|OP3|OP2|OP1. OP1 is the wrestler number for 		  *
;* opponent 1, OP2 would be the second byte and would be 		  *
;* the wrestler number for opponent 2. If zero, it will stop		  *
;* producing opponents. The table is generated randomly for		  *
;* each NEW game started from the ATTRACT MODE. When it is		  *
;* generated, it will randomly place the 8 wrestlers in order and then	  *
;* distribute them through the list.					  *
;*									  *
;**************************************************************************

INIT_LADDER_TABLE

	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14
	CALLR	INIT_LADDER
	MOVI	LADDER-20h,A6		;init to ladder-20 because the
	MOVE	A6,@CURRENT_LADDER,L	; it's pre-incremented later on.
	addk	20h,a6
	CALLR	INIT_TEMP_TABLE
	CALLR	RANDOMIZE_ORDER

	MOVI	LADDER_TABLE_ICONT,A7
	move	@belt_type,a14
	jrz	#ldset
	movi	LADDER_TABLE_WCHAMP,a7
#ldset

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
	MOVI	NUM_LADDER_ENTRIES,A1
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
	PUSH	a10
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
	PULL	a10
	RETS



SELBOX_HEIGHT	.equ	80
SELBOX_WIDTH	.equ	200

SELOUTLINE_H	.equ	86
SELOUTLINE_W	.equ	204

selbox
	.word	SELBOX_WIDTH,SELBOX_HEIGHT,0,0
	.long	02000000h
	.word	05000h
	.even

selbox_outline
	.word	SELBOX_WIDTH+6,SELBOX_HEIGHT+4,3,2
	.long	02000000h
	.word	05000h
	.even

	.ref	get_all_sticks_cur
	.ref	get_all_buttons_cur
	.ref	GENERIC_DISPLAY
	.ref	FLASHME
	.ref	print_message
	.ref	ogmd10_ascii
	.ref	SGMD8GLD
	.ref	print_string_C2
	.ref	COLCYC
	.ref	SNDSND
	.ref	mess_objid
	.ref	hstd_mod
	.ref	WIPEOUT

	.bss	sel_objects,32*12

sel_obj_tbl_t
	.long	CHOGLOT_A
	.long	CHOGLOT_B
	.long	CHSHDT_A
	.long	CHSHDT_B
sel_obj_tbl_b
	.long	CHOGLOB_A
	.long	CHOGLOB_B
	.long	CHSHDB_A
	.long	CHSHDB_B
sel_obj_tbl_t1
	.long	CHOICBK
	.if INTER_DEFAULT
	.long	INTER
	.else
	.long	WORLD
	.endif
sel_obj_tbl_b1
	.long	CHOICBK
	.if INTER_DEFAULT
	.long	WORLD
	.else
	.long	INTER
	.endif

sel_obj_tbl_t2
	.long	CHOICBK
	.long	HEAD
sel_obj_tbl_b2
	.long	CHOICBK
	.long	COOP



; SUBRP	scrn_rel_off
 SUBR	scrn_rel_off
	movi	OBJLST,a14
#sro_loop
	move	*a14,a14,L
	jrz	#sro_exit
	move	*a14(OID),a3
	cmpi	CREDITID|CLSDEAD,a3
	jrz	#sro_loop
	move	*a14(OFLAGS),a3,W
	andni	M_SCRNREL,a3
	move	a3,*a14(OFLAGS),W
	jruc	#sro_loop
#sro_exit
	rets
	
 SUBRP	hilight
	PUSH	a0,a9,a10,a11
	movi	sel_objects,a10

	move	*a10+,a11,L
	move	*a11(OCTRL),a14
	move	a9,a9
	jrnz	#tha_off
	ori	2,a14
	jruc	#tha_set
#tha_off
	andni	2,a14
#tha_set
	move	a14,*a11(OCTRL)

	move	*a10+,a11,L
	move	*a11(OCTRL),a14
	move	a9,a9
	jrnz	#thb_off
	ori	2,a14
	jruc	#thb_set
#thb_off
	andni	2,a14
#thb_set
	move	a14,*a11(OCTRL)

	move	*a10+,a11,L
	move	*a11(OCTRL),a14
	move	a9,a9
	jrz	#tsa_on
	ori	2,a14
	jruc	#tsa_set
#tsa_on
	andni	2,a14
#tsa_set
	move	a14,*a11(OCTRL)

	move	*a10+,a11,L
	move	*a11(OCTRL),a14
	move	a9,a9
	jrz	#tsb_on
	ori	2,a14
	jruc	#tsb_set
#tsb_on
	andni	2,a14
#tsb_set
	move	a14,*a11(OCTRL)

	move	*a10+,a11,L
	move	*a11(OCTRL),a14
	move	a9,a9
	jrz	#bha_off
	ori	2,a14
	jruc	#bha_set
#bha_off
	andni	2,a14
#bha_set
	move	a14,*a11(OCTRL)

	move	*a10+,a11,L
	move	*a11(OCTRL),a14
	move	a9,a9
	jrz	#bhb_off
	ori	2,a14
	jruc	#bhb_set
#bhb_off
	andni	2,a14
#bhb_set
	move	a14,*a11(OCTRL)

	move	*a10+,a11,L
	move	*a11(OCTRL),a14
	move	a9,a9
	jrnz	#bsa_on
	ori	2,a14
	jruc	#bsa_set
#bsa_on
	andni	2,a14
#bsa_set
	move	a14,*a11(OCTRL)

	move	*a10+,a11,L
	move	*a11(OCTRL),a14
	move	a9,a9
	jrnz	#bsb_on
	ori	2,a14
	jruc	#bsb_set
#bsb_on
	andni	2,a14
#bsb_set
	move	a14,*a11(OCTRL)

	move	a9,a9
	jrz	#tp_on
	movi	DPLT_W_P,a0
	jruc	#tp_set
#tp_on
	movi	DPLT_P2P,a0
#tp_set
	calla	pal_getf
	move	*a10+,a11,L
	move	a0,*a11(OPAL)

	move	a9,a9
	jrz	#tpt_on
	movi	WSF_W_P,a0
	jruc	#tpt_set
#tpt_on
	movi	WSF_Y_P,a0
#tpt_set
	calla	pal_getf
	move	*a10+,a11,L
	move	a0,*a11(OPAL)


	move	a9,a9
	jrnz	#bp_on
	movi	DPLT_W_P,a0
	jruc	#bp_set
#bp_on
	movi	DPLT_P2P,a0
#bp_set
	calla	pal_getf
	move	*a10+,a11,L
	move	a0,*a11(OPAL)

	move	a9,a9
	jrnz	#bpt_on
	movi	WSF_W_P,a0
	jruc	#bpt_set
#bpt_on
	movi	WSF_Y_P,a0
#bpt_set
	calla	pal_getf
	move	*a10+,a11,L
	move	a0,*a11(OPAL)
	PULL	a0,a9,a10,a11
	rets


 SUBRP	flash_it
	movi	sel_objects,a10
	move	a9,a9
	jrz	#flash_p1
	addi	(10*32),a10
	jruc	#do_flash_it
#flash_p1
	addi	(8*32),a10
#do_flash_it
	PUSHP	a9
	move	*a10,a8,L
	movi	1f1fh,a9
	move	a9,*a8(OCONST)
	movk	3,a11
#flash_it_loop
	move	*a8(OCTRL),a9
	ori	8,a9
	andni	2,a9
	move	a9,*a8(OCTRL)
	SLEEPK	3
	move	*a8(OCTRL),a9
	andni	8,a9
	ori	2,a9
	move	a9,*a8(OCTRL)
	SLEEPK	3
	dsjs	a11,#flash_it_loop
	PULLP	a9
	RETP

belt_prompt_setup
;	JAM_STR	osgemd_ascii,8,0,200,18+256,GOLD,0
	JAM_STR	osgemd_ascii,8,0,200,18+256,BLUE,0	;TURQUSE:
belt_prompt_string
	.string	"SELECT YOUR TITLE:",0
	.even
rr_prompt_string
	.string	"SELECT PLAY MODE:",0
	.even


TopPalette
	.long	CHGLWT_P
	.long	CHGLWT1P
	.long	CHGLWT2P
	.long	CHGLWT3P
	.long	CHGLWT4P
	.long	CHGLWT5P
	.long	CHGLWT6P
	.long	CHGLWT7P
	.long	CHGLWT8P
	.long	CHGLWT9P
	.long	0
BottomPalette
	.long	CHGLWB_P
	.long	CHGLWB1P
	.long	CHGLWB2P
	.long	CHGLWB3P
	.long	CHGLWB4P
	.long	CHGLWB5P
	.long	CHGLWB6P
	.long	CHGLWB7P
	.long	CHGLWB8P
	.long	CHGLWB9P
	.long	0


;a8 = *palette table
;a9 = *object array

 SUBRP	palette_cycle
	move	a8,a10
	move	a9,a11
#pc_loop
	move	*a10+,a0,L
	jrz	palette_cycle
	calla	pal_getf
	move	*a11,a14,L
	move	a0,*a14(OPAL)
	move	*a11(32),a14,L
	move	a0,*a14(OPAL)
	SLEEPK	4
	jruc	#pc_loop
	DIE


 SUBR	ask_belt_question
	PUSHP	a2,a3

	clr	a9
	movi	belt_type,a2
	move	@question_type,a3
	jrz	#rst_type
	movi	royal_rumble,a2
#rst_type
	move	a9,*a2

	movi	[10,0],a0
	movi	[30+256,0],a1
	movi	MVEBAR_R,a2
	movi	2000h,a3
	movi	DMAWNZ|M_3D,a4
	clr	a5
	clr	a6
	clr	a7
	movi	DPLT_P_P,b0
	calla	BEGINOBJP


	MOVI	[13,0],A0
	MOVI	[39+256,0],A1
	movi	SHADOW01,a2
	movi	1fffH,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	CLR	A6
	CLR	A7
	calla	BEGINOBJ
	CREATE	FLASH_PID,JUDDER_SHADOW

	.ref	hscore_colcyc
	calla	hscore_colcyc

	movi	belt_prompt_setup,a2
	calla	setup_message
	movi	TYPTEXT|SUBOVRHED,a0
	move	a0,@mess_objid
	movi	belt_prompt_string,a4
	move	@question_type,a0
	jrz	#bp1
	movi	rr_prompt_string,a4
#bp1
	calla	print_string_C2

	movi	sel_objects,a10
	movi	8,a11
	movi	sel_obj_tbl_t,a9
	movi	1800h,a3
#do_next_obj
	PUSH	a3
	movi	[93+256,0],a1
	movi	[200,0],a0
	cmpi	5,a11
	jrge	#top
	movi	[184+256,0],a1
	movi	[201,0],a0
#top
	move	*a9+,a2,L
	movi	DMAWNZ|M_3D,a4
	clr	a5
	clr	a6
	clr	a7
	calla	BEGINOBJ
	move	a8,*a10+,L
	PULL	a3
	addi	10h,a3
	dsjs	a11,#do_next_obj
	
	movi	sel_obj_tbl_t1,a9
	move	@question_type,a11
	jrz	#belt_obj
	movi	sel_obj_tbl_t2,a9
#belt_obj
	movi	4,a11
#do_next_obj1
	PUSH	a3
	movi	[256+93,0],a1
	movi	[200,0],a0
	cmpi	3,a11
	jrge	#top1
	movi	[184+256,0],a1
	movi	[201,0],a0
#top1
	move	*a9+,a2,L
	movi	DMAWNZ|M_3D,a4
	clr	a5
	clr	a6
	clr	a7
	movi	WSF_W_P,b0
	calla	BEGINOBJP
	move	a8,*a10+,L
	PULL	a3
	addi	10h,a3
	dsj	a11,#do_next_obj1

	movi	sel_objects,a10

	move	*a10(64),a2,L
	move	*a2(OCTRL),a3
	andni	2,a3
	move	a3,*a2(OCTRL)

	move	*a10(96),a2,L
	move	*a2(OCTRL),a3
	andni	2,a3
	move	a3,*a2(OCTRL)
	
	move	*a10(128),a2,L
	move	*a2(OCTRL),a3
	andni	2,a3
	move	a3,*a2(OCTRL)

	move	*a10(160),a2,L
	move	*a2(OCTRL),a3
	andni	2,a3
	move	a3,*a2(OCTRL)

	movi	DPLT_P2P,a0
	calla	pal_getf
	move	*a10(256),a2,L
	move	a0,*a2(OPAL)

	movi	WSF_Y_P,a0
	calla	pal_getf
	move	*a10(288),a2,L
	move	a0,*a2(OPAL)

	movi	DPLT_W_P,a0
	calla	pal_getf
	move	*a10(320),a2,L
	move	a0,*a2(OPAL)

	movi	WSF_W_P,a0
	calla	pal_getf
	move	*a10(352),a2,L
	move	a0,*a2(OPAL)

	movi	TopPalette,a8
	move	a10,a9
	CREATE	PCYC_PID,palette_cycle
	movi	BottomPalette,a8
	addi	(4*32),a9
	CREATE	PCYC_PID,palette_cycle
	SLEEPK	2

	move	@question_type,a9
	jrz	#no_pcurs
	callr	mk_pcurs
#no_pcurs

	clr	a9	;cusor pos
	move	a9,a10

	callr	scrn_rel_off

	movi	18,a0
	calla	triple_sound

;	PUSHP	a8,a9,a10,a11
#move_on_loop
	move	@WORLDTLY,a0,L
	addi	[18h,0],a0
	move	a0,@WORLDTLY,L
	cmpi	[252,0],a0
	jrge	#move_done
	calla	BGND_UD1
	SLEEPK	1
	jruc	#move_on_loop
#move_done
	movi	[255,0],a0
	move	a0,@WORLDTLY,L
	calla	BGND_UD1
	SLEEPK	1

	move	@question_type,a14
	jrz	#norm
	JSRP	ind_select
	jruc	#sel_done
#norm

	movi	TSEC*4,a11
#sel_box_wait
	cmp	a9,a10
	jrz	#no_change
	movi	0c7h,a0
	calla	triple_sound
	move	a9,a10
	callr	hilight
#no_change
	SLEEPK	1
	calla	get_all_buttons_cur
	jrnz	#sel_done
	calla	get_all_sticks_cur
	jrnz	#do_stick
	dsj	a11,#sel_box_wait
	jruc	#sel_done
#do_stick
	btst	0,a0
	jrz	#no_sel_up
	andni	1,a9
	jruc	#sel_box_wait
#no_sel_up
	btst	1,a0
	jrz	#sel_box_wait
	ori	1,a9
	jruc	#sel_box_wait
#sel_done
	.if INTER_DEFAULT
	.else
	xori	1,a9
	.endif

	move	@question_type,a0
	jrz	#set_belt
	move	a9,@royal_rumble
	jruc	#is_set
#set_belt
	move	a9,@belt_type


	move	a9,a9
	jrnz	#sel_medium
	movi	AUD_INTERCON,a0
	calla	AUD1
	movi	0cbh,a0
	calla	triple_sound
	jruc	#sel_exit
#sel_medium
	movi	AUD_WWF,a0
	calla	AUD1
	movi	0cbh,a0
	calla	triple_sound
#sel_exit
	.if INTER_DEFAULT
	.else
	xori	1,a9
	.endif
	jruc	#rr_aud_bypass
#is_set
	move	a9,a9
	jrz	#aud_hdhd
	movi	AUD_ROYALRUM,a0
	calla	AUD1
	movi	0cbh,a0
	calla	triple_sound
	jruc	#rr_aud_bypass
#aud_hdhd
	movi	AUD_HEADTOHEAD,a0
	calla	AUD1
	movi	0cbh,a0
	calla	triple_sound
#rr_aud_bypass
	JSRP	flash_it

	movi	sel_objects,a9
	move	*a9+,a0,L
	calla	DELOBJ
	move	*a9,a0,L
	calla	DELOBJ
	addi	96,a9
	move	*a9+,a0,L
	calla	DELOBJ
	move	*a9,a0,L
	calla	DELOBJ

	SLEEPK	15

	clr	a2
	move	a2,@mess_objid

	movi	CYCPID,a0
	calla	KIL1C

	PULLP	a2,a3
	RETP


p1curs
	.word	50-107,93+256,1800h
	.long	CHOICBK
	.word	DMAWNZ|M_3D
	.word	CLSNEUT
	.long	0,0

p1curs_num
	.word	15-(6/2),(93+256)-(16/2),1810h
	.long	WSF14_1
	.word	DMAWNZ|M_3D
	.word	CLSNEUT
	.long	0,0

p2curs
	.word	399+(107-50),93+256,1800h
	.long	CHOICBK
	.word	DMAWNZ|M_3D|M_FLIPH
	.word	CLSNEUT
	.long	0,0

p2curs_num
	.word	(399-15)-(11/2),(93+256)-(16/2),1810h
	.long	WSF14_2
	.word	DMAWNZ|M_3D
	.word	CLSNEUT
	.long	0,0


pcurs_tbl
	.long	p1curs
	.long	p1curs_num
	.long	p2curs
	.long	p2curs_num
	.long	0


 SUBR	mk_pcurs
	PUSH	a8,a9,a10,a11
	movi	pcurs_obj,a9
	movi	pcurs_tbl,a10
#cpc_loop
	move	*a10+,a0,L
	jrz	#cpc_done
	calla	BEGINOBJ_TBL
	move	a8,*a9+,L
	jruc	#cpc_loop
#cpc_done
	movi	pcurs_obj,a9

	movi	DPLT_B_P,a0
	calla	pal_getf
	move	*a9+,a10,L
	move	a0,*a10(OPAL),L

	movi	WSF_W_P,a0
	calla	pal_getf
	move	*a9,a10,L
	move	a0,*a10(OPAL),L
	move	*a9(64),a10,L
	move	a0,*a10(OPAL),L

	movi	DPLT_R_P,a0
	calla	pal_getf
	move	*a9(32),a10,L
	move	a0,*a10(OPAL),L

	PULL	a8,a9,a10,a11
	rets

#************************************************
*

 SUBRP	ind_select
	PUSHP	a8,a10

	clr	a9			; Clear out player select flags
	move	a9,@p1sel
	move	a9,@p2sel

	movi	TSEC*5,a11		; Max time before selection timeout
#sel_wait

	; First check to see which players have made their selections
	move	@p1sel,a0		; Get p1 select flag
	move	@p2sel,a1		; Get p2 select flag
	sll	1,a1			; Combine them
	or	a1,a0

	; If nobody has made a selection just set cursor positions
	jrz	#set_curs		; No selections - just set cursors

	; If both have selected then we are done
	cmpi	3,a0			; Have both selected ?
	jrz	#both_selected		; br = yes

	; If player 1 has selected "HEAD TO HEAD" then we are done
	btst	0,a0			; Has player 1 made a selection
	jrz	#no_p1_sel		; br = no
	btst	0,a9			; Has player 1 selected "HEAD TO HEAD" ?
	jrz	#both_selected		; br = yes

	; If player 2 has selected "HEAD TO HEAD" then we are done
#no_p1_sel
	btst	1,a0			; Has player 2 made a selection
	jrz	#set_curs		; br = no
	btst	1,a9			; Has player 1 selected "HEAD TO HEAD" ?
	jrz	#both_selected		; br = yes

#set_curs
	
	callr	set_pcurs_pos		; set player cursor positions
	move	a9,a10			; Save a9
	cmpi	3,a9			; Are both on "COOP" ?
	jrz	#coop			; br = yes
	clr	a9			; Set "HEAD"
	jruc	#do_hi			; Go hilight "Head to Head"
#coop
	movk	1,a9			; Set "COOP"
#do_hi
	callr	hilight			; hilight the right one
	move	a10,a9			; Restore a9

	SLEEPK	1			; Wait a bit

	move	@p1sel,a0		; Has p1 selected ?
	jrnz	#ck_p2			; br = yes
	clr	a0			; get p1 buttons
	calla	get_but_val_cur
	move	a0,a0
	jrz	#no_p1
	movk	1,a0
#no_p1
	move	a0,@p1sel		; save p1 buttons
	PUSH	a10,a11			; Flash p1 cursor
	clr	a11
	move	a0,a10
	CREATE0	flash_pcurs
	PULL	a10,a11
	clr	a0
	calla	get_stick_val_cur	; get p1 stick
	move	a0,a0			; any on ?
	jrnz	#dop1_stick		; br = yes
#ck_p2
	move	@p2sel,a0		; Has p2 selected ?
	jrnz	#p2_done		; br = yes
	movk	1,a0			; Get p2 buttons
	calla	get_but_val_cur
	move	a0,a0
	jrz	#no_p2
	movk	1,a0
#no_p2
	move	a0,@p2sel		; Save p2 buttons
	PUSH	a10,a11			; Flash p2 cursor
	movk	1,a11
	move	a0,a10
	CREATE0	flash_pcurs
	PULL	a10,a11
	movk	1,a0			; Get p2 stick
	calla	get_stick_val_cur
	move	a0,a0			; Any Set ?
	jrnz	#dop2_stick		; br = yes
#p2_done
	dsj	a11,#sel_wait		; Timeout ?
	jruc	#both_selected		; br = yes

#dop1_stick
	btst	0,a0			; p1 up on?
	jrz	#no_p1_up		; br = no
	andni	1,a9			; set p1 curs pos top
	jruc	#ck_p2			; go check on p2
#no_p1_up
	btst	1,a0			; p2 down on?
	jrz	#ck_p2			; br = no
	ori	1,a9			; set p1 curs pos bottom
	jruc	#ck_p2			; go check on p2

#dop2_stick
	btst	0,a0			; p2 up on?
	jrz	#no_p2_up		; br = no
	andni	2,a9			; set p2 curs pos top
	jruc	#sel_wait		; go update
#no_p2_up
	btst	1,a0			; p2 down on?
	jrz	#sel_wait		; br = no
	ori	2,a9			; set p2 curs pos bottom
	jruc	#sel_wait		; go update

#both_selected
	cmpi	3,a9			; have both selected "COOP" ?
	jrnz	#ret_hd			; br = no
	movk	1,a9			; set "COOP" mode
	jruc	#mode_selected
#ret_hd
	clr	a9			; set "HEAD TO HEAD" mode
#mode_selected
	PULLP	a8,a10
	RETP


;a10 - flag 0 = no flash
;a11 - pnum
 SUBRP	flash_pcurs
	move	a10,a10		; Should I flash it ?
	jrz	#fp_exit	; br = no
	movi	pcurs_obj,a10	; Object array
	move	a11,a11		; Is this player 1 ?
	jrz	#not_p2		; br = yes
	addi	64,a10		; Adjust pointer for p2 objects
#not_p2
	movi	0cbh,a0		; Make a sound
	calla	triple_sound

	move	*a10,a9,L	; Set const color to white
	movi	0101h,a14
	move	a14,*a9(OCONST)
	movk	3,a11		; Number of times to flash it
#fp_loop
	move	*a9(OCTRL),a8	; Turn it white
	ori	8,a8		; Turn on Write const on non-zero
	andni	2,a8		; Turn off write non-zeros bit
	move	a8,*a9(OCTRL)	; Write back to control
	SLEEPK	3
	andni	8,a8		; Turn off write const on non-zero
	ori	2,a8		; Turn on non-zeros bit
	move	a8,*a9(OCTRL)	; Write back to control
	SLEEPK	3
	dsjs	a11,#fp_loop	; Done ? - br = no
#fp_exit
	DIE


 SUBRP	set_pcurs_pos
	movi	pcurs_obj,a8	; Get pointer to player cursor object table
	move	*a8+,a0,L	; pointer to p1 cursor


	movi	93+256,a1	; Set top ypos
	btst	0,a9		; p1 curs position bottom ?
	jrz	#p1c_set	; br = no
	movi	184+256,a1	; bottom ypos
#p1c_set
	move	*a0(OYPOS),a2	; Get current position
	cmp	a1,a2		; Same as requested ?
	jrz	#no_p1_change	; br = yes
	PUSH	a0,a1		; make a sound
	movi	0c7h,a0
	calla	triple_sound
	PULL	a0,a1
#no_p1_change
	move	a1,*a0(OYPOS)	; Set p1 cursor ypos
	move	*a8+,a0,L	; Get p1 digit object pointer
	subi	8,a1		; adjust ypos
	move	a1,*a0(OYPOS)	; Set p1 cursor digit ypos


	movi	93+256,a1	; Set top ypos
	btst	1,a9		; p2 curs position bottom ?
	jrz	#p2c_set	; br = no
	movi	184+256,a1	; Set bottom ypos
#p2c_set
	move	*a8+,a0,L	; Get pointer to p2 cursor object
	move	*a0(OYPOS),a2	; Get current position
	cmp	a1,a2		; Same as requested position ?
	jrz	#no_p2_change	; br = yes
	PUSH	a0,a1		; Make a sound
	movi	0c7h,a0
	calla	triple_sound
	PULL	a0,a1
#no_p2_change
	move	a1,*a0(OYPOS)	; Set p2 cursor ypos
	move	*a8+,a0,L	; Get p2 digit object pointer
	subi	8,a1		; adjust ypos
	move	a1,*a0(OYPOS)	; Set p2 cursor digit ypos
	rets



******************************************************************************

DO_SET_IMAGE_AND_FLASH
	CALLA	BGND_UD1
	CALLA	SET_IMAGE_AND_FLASH
	SLOOP	1,DO_SET_IMAGE_AND_FLASH

******************************************************************************

 SUBR	PUT_UP_PROGRESS
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
	move	a0,@FLASH_FLAG

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	movi	#PROGRESS_BMOD,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1		;create objects for background

	calla	show_progress_bicons

	movi	tonites_matchup,a2
	calla	setup_message
	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a0
	move	a0,@mess_objid
	movi	tonites_str,a4
	calla	print_string2

	calla	start_credbox

	movi	tonites_matchup,a2
	calla	setup_message
	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a0
	move	a0,@mess_objid
	movi	tonites_str,a4
	calla	print_string2

	movi	type_setup,a2
	calla	setup_message
	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a0
	move	a0,@mess_objid
	movi	wwf_belt_str,a4
	move	@belt_type,a14
	jrnz	#wwf_belt
	movi	inter_belt_str,a4
#wwf_belt
	calla	print_string_C2

	calla	start_credbox

	movi	belt_setup,a2
	calla	setup_message
	movi	CLSNEUT|TYPTEXT|SUBOVRHED,a0
	move	a0,@mess_objid
	movi	belt_str,a4
	calla	print_string_C2

	movk	10,a0
	move	a0,@match_time

	MOVE	@CURRENT_LADDER,A10,L

	CMPI	LADDER,A10
	jrlt	NO_DEAD_BODIES

	MOVE	*A10,A1,L
	CALLR	NUM_OF_OPPS
	MOVE	A3,@NUM_OLD_OPPS

	MOVE	*A10,A4,L
	MOVK	4,A10
CREATE_NEXT_DEAD_GUY
	CALLR	SORT_OUT_WRESTLER_NUM
	movi	PTYPE_DRONE,a8			;player type
	movi	PSIDE_PLYR1,a9			;side on
	SCREATE	WMAINT_PID,CREATE_TEMP_WRESTLER
	SRL	8,A4
	INC	A10
	DEC	A3
	JRNZ	CREATE_NEXT_DEAD_GUY

	MOVE	@CURRENT_LADDER,A10,L

NO_DEAD_BODIES
	CALLR	NEXT_IN_LADDER

	movk	INPREGAME2,a14		;set GAMSTATE
	move	a14,@GAMSTATE

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
	SCREATE	WMAINT_PID,CREATE_TEMP_WRESTLER
	PULL	A11

	MOVE	@MUSIC_HAP,A0
	JRNZ	MUSIC_ALREADY_GOING

	SLL	4,A11
	ADDI	WHICH_MUSIC,A11
	MOVE	*A11,A3
	calla	SNDSND

MUSIC_ALREADY_GOING

	MOVE	@NUM_OPPS,A3
	MOVE	@CURRENT_LADDER,A10,L
	MOVE	*A10,A4,L
	MOVK	1,A10
CREATE_NEXT_NEW_GUY
	CALLR	SORT_OUT_WRESTLER_NUM
	movi	PTYPE_DRONE,a8			;player type
	movi	PSIDE_PLYR1,a9			;side on
	SCREATE	WMAINT_PID,CREATE_TEMP_WRESTLER
	SRL	8,A4
	INC	A10
	DEC	A3
	JRNZ	CREATE_NEXT_NEW_GUY

*****************
	CALLR	is_8_on_1
	JRNC	NO_IT_IS_NOT_8_ON_1
	CALLR	INIT_TEMP_TABLE
	MOVE	@CURRENT_LADDER,A10,L
	MOVE	*A10,A4,L
	MOVK	3,A1
	MOVK	9,A2
CLEAR_NEXT_POSITION
	MOVE	A4,A0
	SLL	24,A0
	SRL	24,A0
	MOVK	7,A14
	SUB	A0,A14
	SLL	3,A14
	ADDI	TEMP_LADDER,A14
	MOVB	A2,*A14
	SRL	8,A4
	DSJS	A1,CLEAR_NEXT_POSITION

	MOVI	TEMP_LADDER,A10
	CLR	A11
CREATE_NEXT_BODY
	CMPI	TEMP_LADDER+(8*8),A10
	JREQ	NO_IT_IS_NOT_8_ON_1
	MOVB	*A10,A2
	ADDK	8,A10
	CMPI	9,A2
	JREQ	CREATE_NEXT_BODY
	CALLR	CREATE_OTHER_BODIES
	INC	A11
	JRUC	CREATE_NEXT_BODY

NO_IT_IS_NOT_8_ON_1
*****************

	CALLR	SET_IMAGE_AND_FLASH

	CALLR	DO_LADDER_BITS

	CREATE0	DO_SET_IMAGE_AND_FLASH
	PUSHP	A0

;	movk	15,a8
;	movk	4,a9
	movk	10,a8
	movk	2,a9


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
	CALLA	get_all_buttons_cur2
	JRNZ	EXIT_PROGRESS
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

	MOVI	90,A8
STILL_PROGRESS
	SLEEPK	1
	pushp	a8
	CALLR	SET_IMAGE_AND_FLASH
	pullp	a8
	CALLA	get_all_buttons_cur2
	JRNZ	EXIT_PROGRESS
	CMPI	80,A8
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

;Get rid of flashes under wipe
;	CREATE0	DO_SET_IMAGE_AND_FLASH
;	PUSHP	A0
	JSRP	CLOSE_PROGRESS_SCREEN
;	PULLP	A0
;	CALLA	KILL

	calla	del_progress_icon

	RETP

WHICH_MUSIC
	.word	5,2,1,7,6,4,8,0,3

****************
CREATE_OTHER_BODIES
	MMTM	SP,A0,A1,A2,A4,A5,A6,A7,A8,A9,A10,A11,A14
	PUSH	b0


	MOVE	A2,A3
	cmpi	7,a3		; Is this Lex ?
	jrnz	wnum_ok		; br = no
	addk	1,a3		; Yes - adjust for palette table
wnum_ok
	SLL	5,A3
	move	a3,b0
	addi	#wrestler_pal,b0
	move	*b0,b0,L
	ADDI	WHICH_WRESTLER_IMAGE,A3
	MOVE	*A3+,A4,L
	PUSH	A4
	PUSH	b0

	MOVE	A11,A4
	SLL	7,A4
	ADDI	WHERE_TEMP_WRESTLER,A4

	MOVE	*A4+,A0,L
	PUSH	A0

	MOVE	*A4+,A3,L
	PUSH	A3
	ORI	1000H,A3

	MOVE	*A4,A1,L
	PUSH	A1

	MOVI	shadow,A2
	MOVI	DMAWNZ,A4
	CLR	A5
	CLR	A6
	CLR	A7
	CALLA	BEGINOBJ

	PULL	A1
	PULL	A3
	DEC	A3
	ORI	1000H,A3
	PULL	A0

	PULL	b0
	PULL	A2

	movi	DMAWNZ|M_FLIPH,a4	;DMA flags
	CLR	A5
	CLR	A6
	CLR	A7
;	CALLA	BEGINOBJ
	calla	BEGINOBJP
	PULL	b0
	MMFM	SP,A0,A1,A2,A4,A5,A6,A7,A8,A9,A10,A11,A14
	RETS

WHICH_WRESTLER_IMAGE
	.LONG	H4ST4A02
	.LONG	RAZOR_STAND
	.LONG	TAKER_STAND
	.LONG	YOKO_STAND
	.LONG	SHAWN_STAND
	.LONG	BAM_STAND
	.LONG	DOINK_STAND
	.LONG	LEX_STAND
	.LONG	LEX_STAND

WHERE_TEMP_WRESTLER
	.LONG	[725,0],470H,[233,0],0
	.LONG	[760,0],420H,[223,0],0
	.LONG	[720,0],420H,[219,0],0
	.LONG	[690,0],420H,[219,0],0
	.LONG	[650,0],420H,[219,0],0

****************

*********************
*
* Low byte of a4 is a wrestler num between 0-7.  7, of course, is an unused
* slot so we promote a 7 to 8, then store the result in a11.
*

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
	movi	1000h|110,a3		;z pos
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
;	move	a0,*a13(BURNOUT_COUNT)
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
;	WL	ANI_CODE,BAM_TAUNT_SOUND
bam_taunt4_anim_no_fx
	WL	4,B4SW4B+FR3
	WL	4,B4SW4B+FR4
	WL	4,B4SW4B+FR5
	WL	4,B4SW4B+FR6
	WL	4,B4SW4B+FR7
	WL	4,B4SW4B+FR8
	WL	ANI_GOTO,bam_taunt4_anim_no_fx

;BAM_TAUNT_SOUND
;	movi	42h,a0
;	CALLA	triple_sound
;	RETS

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

 SUBR	CREATE_URN2
	MMTM	SP,A0,A1,A2,A4,A5,A6,A7,A8,A9,A10,A11,A14
	MOVE	*A13(OBJ_XPOS),A0,L
	MOVI	[026H,0],A1
	MOVE	*A13(OBJ_CONTROL),A3
	ANDI	M_FLIPH,A3
	JRNZ	NO_NEG_X_OFF
	NEG	A1
NO_NEG_X_OFF
	ADD	A1,A0
	movi	Y_SCALE_MULTIPLIER,a3
	move	*a13(OBJ_ZPOSINT),a1
	mpyu	a3,a1
	SUBI	[0C0H,0],A1
	JRUC	RE_ENTER_URN_CREATE

 SUBRP	CREATE_URN
	MMTM	SP,A0,A1,A2,A4,A5,A6,A7,A8,A9,A10,A11,A14
	MOVE	*A13(OBJ_XPOS),A0,L
	movi	Y_SCALE_MULTIPLIER,a3
	move	*a13(OBJ_ZPOSINT),a1
	mpyu	a3,a1
	SUBI	[5aH,0],A1
RE_ENTER_URN_CREATE
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

	.if 0
;JOY1 DOWN + PUNCH + BLOCK + SUPER PUNCH
GETUP_METER_POWER1	.EQU	0008DH  
;JOY2 DOWN + PUNCH + BLOCK + SUPER PUNCH
GETUP_METER_POWER2	.EQU	08D00H  
;JOY1 UP + PUNCH + BLOCK + SUPER PUNCH
NAMES_POWER1_B		.EQU	0008EH  
;JOY2 UP + PUNCH + BLOCK + SUPER PUNCH
NAMES_POWER2_B		.EQU	08E00H  
;JOY1 LEFT + PUNCH + BLOCK + JOY2 LEFT + PUNCH + BLOCK
BONUS_POWER_B		.EQU	0CBCBH  

LOOK_FOR_POWERUPS
	CLR	A2
	MOVE	A2,@NAMES_POWER1
	MOVE	A2,@NAMES_POWER2

	.if DEBUG
	movk	1,a2
	.endif
	MOVE	A2,@GETUP_POWER

	MOVK	16,A2
	MOVE	A2,@BONUS_POWER

	MOVE	@SWITCH,A0
	MOVE	A0,A1
	ANDI	0FFH,A1
	CMPI	GETUP_METER_POWER1,A1
	JRNE	NO_GETUP_P1
	MOVK	1,A2
	MOVE	A2,@GETUP_POWER
NO_GETUP_P1
	MOVE	A0,A1
	ANDI	0FF00H,A1
	CMPI	GETUP_METER_POWER2,A1
	JRNE	NO_GETUP_P2
	MOVK	1,A2
	MOVE	A2,@GETUP_POWER
NO_GETUP_P2
	MOVE	A0,A1
	ANDI	0FFH,A1
	CMPI	NAMES_POWER1_B,A1
	JRNE	NO_NAMES_P1
	MOVK	1,A2
	MOVE	A2,@NAMES_POWER1
NO_NAMES_P1
	MOVE	A0,A1
	ANDI	0FF00H,A1
	CMPI	NAMES_POWER2_B,A1
	JRNE	NO_NAMES_P2
	MOVK	1,A2
	MOVE	A2,@NAMES_POWER2
NO_NAMES_P2
	MOVE	@PSTATUS,A2
	CMPI	3,A2
	JRNE	NO_ALLOW_BONUS_POWER
	MOVE	A0,A1
	SLL	16,A1
	SRL	16,A1
	CMPI	BONUS_POWER_B,A1
	JRNE	NO_ALLOW_BONUS_POWER
	MOVK	1,A2
	MOVE	A2,@BONUS_POWER
NO_ALLOW_BONUS_POWER
	RETS

	.endif


BLOCK_BUTT	.EQU	20H

LOOK_FOR_PALS
	CLR	A10
	MOVE	A10,@WHICH_SKIRT_PAL
	MOVI	P_DELAY+10,A8
	move	@_switch_addr,a0,L
	move	*a0,a0
	ANDI	BLOCK_BUTT,A0
	JRZ	CHECK_BUT_UP

CHECK_BUT_DOWN
	SLEEPK	1
	DEC	A8
	move	@_switch_addr,a0,L
	move	*a0,a0
	ANDI	BLOCK_BUTT,A0
	JRZ	CHECK_BUT_UP_ADD
	MOVE	A8,A8
	JRP	CHECK_BUT_DOWN
	JRUC	EXIT_LOOK_FOR_PALS

CHECK_BUT_UP_ADD
	INC	A10
CHECK_BUT_UP
	SLEEPK	1
	DEC	A8
	move	@_switch_addr,a0,L
	move	*a0,a0
	ANDI	BLOCK_BUTT,A0
	JRNZ	CHECK_BUT_DOWN
	MOVE	A8,A8
	JRP	CHECK_BUT_UP
EXIT_LOOK_FOR_PALS
	ANDI	7,A10
	SLL	4,A10
	ADDI	WHICH_SKIRT_PALLETE,A10
	MOVE	*A10,A0
	MOVE	A0,@WHICH_SKIRT_PAL
	DIE

WHICH_SKIRT_PALLETE
	.WORD	0,0,0
	.WORD	5,7,2,5,1


#*****************************************************************************
*
* a1 is a progression table entry.  scramble it.
* a10 is the pointer to the current table entry, which should be held in a1.
*
* Rules:
* - On the first 1v2 match, don't choose a drone that matches player.
* - Ditto for first 1v3 match. (exception:  the 1 in 32 doinks can
*   happen even if the human is doink.)
* - On any 1v2+ match, don't choose any drone that was used as a drone in
*   the previous fight.
* - On the final battle, generate a unique lineup, and put the first three
*   guys in as starters.  Then initialize all the special data for that match.
*

 SUBR	scramble_table_entry

	PUSH	a0,a2,a3,a4,a5,a6,a7,a8

	;figure out who our human is, and put his wrestlernum in a6
	;if we're in attract mode (PSTATUS==0), look in index1.
	move	@PSTATUS,a14
	move	@index2,a6
	btst	1,a14
	jrnz	#pset
	move	@index1,a6
#pset

	;put the count in a2
	move	a1,a2
	srl	24,a2
	cmpi	3,a2
	jrne	#begin

	;it's three guys.  is it the final match?
	; (we can't use is_final_match because CURRENT_LADDER
	; hasn't been incremented yet.)
	move	@belt_type,a14
	jrz	#notfin

	move	@CURRENT_LADDER,a14,L
	cmpi	LADDER+((FINAL_BATTLE-2)*20h),a14
	jreq	#final_match

#notfin	;no.  one time in 32, make it three doinks.
	move	@PCNT,a14
	sll	32-5,a14
	srl	32-5,a14
	jrnz	#begin

	movi	03060606h,a1
	jruc	#done

#begin	;first, figure out which wrestlers are excluded.  Use the low byte
	;of a7 for this.  Set the bits corresponding to excluded wrestlers.
	clr	a7

	;first, exclude the human if this is the first 1v2 or 1v3
	movk	1,a14
	sll	a6,a14
	or	a14,a7

	;now exclude the guys from the last match
	; but not if this is the first match!
	cmpi	LADDER,a10
	jreq	#count
	move	*a10(-20h),a0,L	;previous lineup
	move	a0,a1
	srl	24,a1		;wrestler count
#lp0	movk	1,a14
	rl	a0,a14		;note that rl only looks at low 5 bits...
	or	a14,a7
	srl	8,a0
	dsj	a1,#lp0

	;now count excluded wrestlers.  We couldn't do this before because
	; we weren't checking for redundant exclusions.  now just count
	; set bits in a7.  Store the count in a8
#count	move	a7,a14
	clr	a8
	movk	8,a0
#lp1	srl	1,a14
	jrnc	#nxt1
	inc	a8
#nxt1	dsj	a0,#lp1

	;commence scramble - begin by getting three random guys
	; Since a8 wrestlers are excluded, we're choosing from a field of
	; 8 - a8 wrestlers.

	;to make repeats less likely, 'toss back' the first match on any
	; previous wrestlers.

	;first
	callr	get_rnd_wrestler
	move	a0,a3

	;second
	callr	get_rnd_wrestler
	move	a0,a4
	cmp	a4,a3
	jrne	#ok2
	callr	get_rnd_wrestler
	move	a0,a4

#ok2	;third
	callr	get_rnd_wrestler
	move	a0,a5
	cmp	a3,a5
	jreq	#repick
	cmp	a4,a5
	jrne	#ok3
#repick	callr	get_rnd_wrestler
	move	a0,a5
#ok3

	;lump it all together

	sll	24,a2
	sll	16,a3
	sll	8,a4

	move	a2,a1
	or	a3,a1
	or	a4,a1
	or	a5,a1

	;leave the third guy in there even if there's only supposed to be
	; two.  It can't matter since 0 is a valid WRESTLERNUM anyway.

#done	PULL	a0,a2,a3,a4,a5,a6,a7,a8
	rets

#final_match
	;first, generate a new lineup
	callr	get_final_lineup

	;now construct our starting lineupt from the first three guys.
	movi	FINAL_BATTLE_LINEUP,a0
	move	*a0,a1,L
	andi	00FFFFFFh,a1		;clear fourth guy
	ori	03000000h,a1		;set count

	;set FINAL_PTR to the next guy to fight.
	addi	3*8,a0
	move	a0,@FINAL_PTR,L

	jruc	#done

**********
* Get a random wrestler among those available.
* >a7 = excluded wrestler mask  >a8 = excluded wrestler count
* <a0 = choice among those available

 SUBR	get_rnd_wrestler

	;first, get a random number between 0 and 7-(num excluded)
	movk	7,a0
	sub	a8,a0
	calla	RNDRNG0

	;now translate.  a value of '0' means 'first available wrestler.'
	;'3' means 'fourth available wrestler,' and so forth.
	inc	a0
	movi	-1,a14
#lp2	inc	a14
	btst	a14,a7
	jrnz	#lp2	;not available.  keep looking
	dsj	a0,#lp2

	;found the n'th open spot, and a14 is the correct wrestlernum.
	move	a14,a0
	rets


#*****************
STATY	.EQU	30
STATX	.EQU	5

DO_LADDER_BITS
	MOVI	CHAMP_BITS_LIST,A9
	MOVE	@belt_type,A1
	JRNZ	CORRECT_BITS_TABLE
	MOVI	INTER_BITS_LIST,A9
CORRECT_BITS_TABLE

	CALLR	MAKE_NEXT_BIT

	MOVI	CHAMP_FLASH_BITS,A9
	MOVE	@belt_type,A1
	JRNZ	CORRECT_FLASH_BITS_TABLE
	MOVI	INTER_FLASH_BITS,A9
CORRECT_FLASH_BITS_TABLE

	MOVE	@CURRENT_LADDER,A10,L
	SUBI	LADDER-20h,A10
	SRL	5,A10
NEXT_FLASH_BIT
	MOVE	*A9+,A2,L
	CALLR	CREATE_PART
	DSJS	A10,NEXT_FLASH_BIT
	CREATE	ZSHIFT_PID,FLASH_THIS_BIT

	move	@match_cnt,a0
	cmpi	999,a0
	jrls	#maxok
	movi	999,a0
#maxok
	movi	9999999,a1
	calla	dec_to_asc		;convert to ASCII
	movk	2,a0
	move	a0,@mess_spacing
	CALLA	copy_string

	movi	win_ascii,a0
	move	a0,@message_ascii,L
	movi	3,a0
	move	a0,@mess_space_width
	MOVI	STATX+76,A0
	move	a0,@mess_cursx
	MOVI	STATY+19+3+2,A0
	move	a0,@mess_cursy
	MOVI	WINFONT,A11
	move	a11,@message_palette,L
	calla	print_string

	move	@p1winstreak,a0
	jrnz	win_streak_set
	move	@p2winstreak,a0
win_streak_set
	movi	9999999,a1
	calla	dec_to_asc		;convert to ASCII
	movk	2,a0
	move	a0,@mess_spacing
	CALLA	copy_string
	MOVI	STATX+7+50,A0
	move	a0,@mess_cursx
	MOVI	STATY+19+4+12+3,A0
	move	a0,@mess_cursy
	calla	print_string

	movi	BEATEN_TAB_ORIGIN+HS_SIZE,a7
	MOVE	@belt_type,A1
	JRNZ	CORRECT_TABLE
	movi	INTER_TAB_ORIGIN+HS_SIZE,a7
CORRECT_TABLE

	movi	message_buffer,a1
	addi	HS_INITS,a7
	movi	5,a2
#initloop
	calla	RC_BYTEI
	movb	a0,*a1
	addk	8,a1
	dsj	a2,#initloop
	clr	a0			;null-terminate it
	movb	a0,*a1

	movi	wsf14_ascii,a0
	move	a0,@message_ascii,L
	MOVI	15fh,A0
	move	a0,@mess_cursx
	MOVI	STATY+19+12+3,A0
	move	a0,@mess_cursy
	movi	1901h,a0
	move	a0,@mess_z,L
	MOVI	WSF_Y_P,A11
	move	a11,@message_palette,L
	calla	print_string_Z2

	RETS

FLASH_THIS_BIT
	MOVI	FLASH_BIT_ANIM,A1
	callr	setup_back_anim
	JSRP	ANIM_CROWD
	JRUC	FLASH_THIS_BIT

MAKE_NEXT_BIT
	MOVE	*A9+,A2,L
	JRZ	LAST_BIT
	CALLR	CREATE_PART
	JRUC	MAKE_NEXT_BIT
LAST_BIT
	RETS

CREATE_PART
	MOVE	*A9+,A0,L
	MOVE	*A9+,A1,L
	MOVE	*A9+,A3,L
	MOVE	*A9+,A4,L
	MOVE	A4,B0
	movi	DMAWNZ|M_SCRNREL,a4
	CMPI	LBAR_GENB,A2
	JRNE	DMA_SET_OKAY
	movi	M_FLIPH|DMAWNZ|M_SCRNREL,a4
DMA_SET_OKAY
	movi	CLSNEUT,a5
	CLR	A6
	CLR	A7
	CALLA	BEGINOBJP
	RETS

FLASH_BIT_ANIM
	WL	2,FLASH01
	WL	2,FLASH02
	WL	2,FLASH03
	WL	2,FLASH04
	WL	2,FLASH05
	WL	2,FLASH04
	WL	2,FLASH03
	WL	2,FLASH02
	WL	CANI_GOTO,FLASH_BIT_ANIM


INTER_BITS_LIST
	.LONG	STATBAR,[STATX,0],[STATY,0],1900H,DPLT_R_P
	.LONG	BLUESH,[STATX+50,0],[STATY+19,0],1900H,BARB_P
	.LONG	TXTBAR1,[STATX+60,0],[STATY+19+2+5,0],1900H,DPLT_R_P
	.LONG	WINS_IMG,[STATX+20,0],[STATY+19+4+12+3,0],1901H,WINFONT
	.LONG	BLUESH,[STATX+36,0],[STATY+19+2+12,0],1900H,BARB_P
	.LONG	TXTBAR1,[STATX+46,0],[STATY+19+4+12+5,0],1900H,DPLT_R_P
	.LONG	MATCH_IMG,[STATX+29,0],[STATY+19+2+3,0],1901H,WINFONT
	.LONG	BLUESH,[STATX+23,0],[STATY+19+4+24,0],1900H,BARB_P

	.LONG	TXTBAR1,[STATX+230,0],[STATY+19+4+12+5,0],18FFH,DPLT_R_P
	.LONG	TXTBAR1,[STATX+297,0],[STATY+19+4+12+5,0],18FFH,DPLT_R_P
	.LONG	TXTBAR1,[STATX+360,0],[STATY+19+4+12+5,0],18FFH,DPLT_R_P
	.LONG	TXTPCE, [STATX+260,0],[STATY+19+4+12+5,0],1900H,DPLT_R_P
	.LONG	TXTPCE, [STATX+335,0],[STATY+19+4+12+5,0],1900H,DPLT_R_P

	.LONG	RCHAMP,[STATX+235-36,0],[STATY+19+2+12+5,0],1901H,WINFONT

	.LONG	SWWFBLT,[STATX+345,0],[STATY+9,0],1901H,SWWFBW_P
	.LONG	LBAR_GENB,[STATX+111,0],[STATY,0],1900H,BARB_P
	.LONG	LBAR_GENB,[STATX+64,0],[STATY+19+24+8,0],18ffH,BARB_P
	.LONG	0


CHAMP_BITS_LIST
	.LONG	STATBAR,[STATX,0],[STATY,0],1900H,DPLT_P_P
	.LONG	BLUESH,[STATX+50,0],[STATY+19,0],1900H,BARB_P
	.LONG	TXTBAR1,[STATX+60,0],[STATY+19+2+5,0],1900H,DPLT_P_P
	.LONG	WINS_IMG,[STATX+20,0],[STATY+19+4+12+3,0],1901H,WINFONT
	.LONG	BLUESH,[STATX+36,0],[STATY+19+2+12,0],1900H,BARB_P
	.LONG	TXTBAR1,[STATX+46,0],[STATY+19+4+12+5,0],1900H,DPLT_P_P
	.LONG	MATCH_IMG,[STATX+29,0],[STATY+19+2+3,0],1901H,WINFONT
	.LONG	BLUESH,[STATX+23,0],[STATY+19+4+24,0],1900H,BARB_P

	.LONG	TXTBAR1,[STATX+230,0],[STATY+19+4+12+5,0],18FFH,DPLT_P_P
	.LONG	TXTBAR1,[STATX+297,0],[STATY+19+4+12+5,0],18FFH,DPLT_P_P
	.LONG	TXTBAR1,[STATX+360,0],[STATY+19+4+12+5,0],18FFH,DPLT_P_P
	.LONG	TXTPCE, [STATX+260,0],[STATY+19+4+12+5,0],1900H,DPLT_P_P
	.LONG	TXTPCE, [STATX+335,0],[STATY+19+4+12+5,0],1900H,DPLT_P_P

	.LONG	RCHAMP,[STATX+235-36,0],[STATY+19+2+12+5,0],1901H,WINFONT

	.LONG	SWWFBLT,[STATX+345,0],[STATY+9,0],1901H,SWWFBB_P
	.LONG	LBAR_GENB,[STATX+111,0],[STATY,0],1900H,BARB_P
	.LONG	LBAR_GENB,[STATX+64,0],[STATY+19+24+8,0],18ffH,BARB_P
	.LONG	0

CHAMP_FLASH_BITS
	.LONG	FLASH05,[STATX-5+31,0],[STATY+5+4,0],1901H,FLASHP_P
	.LONG	FLASH05,[STATX-5+47,0],[STATY+5+4,0],1901H,FLASHP_P
	.LONG	FLASH05,[STATX-5+63,0],[STATY+5+4,0],1901H,FLASHP_P
	.LONG	FLASH05,[STATX-5+79,0],[STATY+5+4,0],1901H,FLASHP_P

	.LONG	FLASH05,[STATX-5+95+13H,0],[STATY+5+4,0],1901H,FLASHP_P
	.LONG	FLASH05,[STATX-5+111+13H,0],[STATY+5+4,0],1901H,FLASHP_P
	.LONG	FLASH05,[STATX-5+127+26H,0],[STATY+5+4,0],1901H,FLASHP_P

INTER_FLASH_BITS
	.LONG	FLASH05,[STATX-5+31,0],[STATY+5+4,0],1901H,FLASHR_P
	.LONG	FLASH05,[STATX-5+47,0],[STATY+5+4,0],1901H,FLASHR_P
	.LONG	FLASH05,[STATX-5+63,0],[STATY+5+4,0],1901H,FLASHR_P
	.LONG	FLASH05,[STATX-5+79,0],[STATY+5+4,0],1901H,FLASHR_P
	.LONG	FLASH05,[STATX-5+95+13H,0],[STATY+5+4,0],1901H,FLASHR_P
	.LONG	FLASH05,[STATX-5+111+13H,0],[STATY+5+4,0],1901H,FLASHR_P
	.LONG	FLASH05,[STATX-5+127+26H,0],[STATY+5+4,0],1901H,FLASHR_P

SWWFBW_P
   .word   32 
   .word   00000h,07b8ah,07b73h,07b2fh,07ae9h,06eefh,062aeh,06e8bh
   .word   06e65h,05e4ah,06226h,059e4h,041e8h,05961h,04d21h,04164h
   .word   03947h,03944h,04101h,02905h,030c2h,020a1h,05ef7h,05294h
   .word   04a52h,04210h,035adh,02d6bh,02529h,018c6h,01084h,002c2h


DPLT_P_P
   .word   31 
   .word   00000h,06f7ch,06f3ch,06efch,06ebch,06e7ch,06e3ch,06dfch
   .word   06dbch,06d7ch,06d5ch,06d1ch,06cbch,06c9ch,06c3ch,06c1ch
   .word   06c1ch,0681bh,06019h,05c18h,05416h,04c14h,04412h,03c10h
   .word   0380fh,0300dh,0280bh,0240ah,01807h,01406h,01005h

tonites_matchup
	JAM_STR	font9_ascii,8,0,22,13,FNT9YEL_P,0

tonites_str
	.string	"TONIGHT'S PROGRAM",0

type_setup
	JAM_STR	font9_ascii,8,0,241,28,FNT9YEL_P,0
	.even
belt_setup
	JAM_STR	font9_ascii,8,0,241,41,FNT9YEL_P,0
	.even
wwf_belt_str
	.string	"WWF CHAMPIONSHIP",0
	.even
inter_belt_str
	.string	"INTERCONTINENTAL",0
	.even
belt_str
	.string	"TITLE",0
	.even
******************************************************************************

	.end
