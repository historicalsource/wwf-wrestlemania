**************************************************************
*
* Software:	Jason Skiles
* Initiated:	29 Oct 93
*
* COPYRIGHT (C) 1993 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 4/12/94 15:30
**************************************************************

	.file	"lifebar.asm"
	.title	"meters, names, messages, and scores"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"macros.h"
	.include	"mproc.equ"		;Mproc equates
	.include	"display.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"game.equ"
	.include	"plyr.equ"
	.include	"sys.equ"
	.include	"link.equ"
	.include	"sound.h"

	.include	"miscimg.glo"
	.include	"fontsimg.glo"
	.INCLUDE	"SOUND.EQU"

#*****************************************************************************

	.REF	ANIM_CROWD
	.REF	setup_back_anim
	.REF	RNDRNG0

	.ref	update_timer
	.DEF	DO_HEAD_MESS,DO_GERM_MESS
	.DEF	DO_FRANK_MESS,DO_BACK_MESS
	.DEF	DO_BODY_MESS,DO_SNAP_MESS
	.DEF	CLEAR_COUNTERS

	.DEF	DO_PILE_MESS
	.ref	LINES
	.DEF	WHICH_NAME, KILL_REWIRE_DUMMY
	.REF	get_process_ptr
	.REF	WHICH_SCREEN
	.REF	DUMRETS
	.ref	match_over

	.def	SHIFT_BARS_IN_Z
	.DEF	DO_REVERSAL_MESS
	.REF	SET_LOWER_VOL

	.if	rounds_on
	.ref	reset_for_round
	.ref	reset_for_round2
	.ref	calc_match_time_2
	.endif

	.REF	CLEAR_SPEECH_REPEAT

	.ref	calc_match_time_1
	.REF	VINCE_START_ROUND2_3

	;from ADJUST.ASM
	.ref	BINBCD

	;from AUDIT.ASM
	.ref	CR_STRTP,GET_ADJ,GET_CREDITS

	;from DCSSOUND.ASM
	.ref	triple_sound

	;from DISPLAY.ASM
	.ref	BEGINOBJ_TBL

	;from PAL.ASM
	.ref	pal_getf

	;from ROBO.ASM
	.ref	civanic

	;from STRING.ASM
	.ref	setup_message,print_string_C2,mess_objid

	.ref	sgmd8_ascii,osgemd_ascii

	;from WRESTLE.ASM
	.ref	set_winner
	.ref	PSTATUS,process_ptrs,p1winstreak,p2winstreak,current_round
	.ref	secret_damage,fight_debug,p1rounds,p2rounds

	.ref	log_damage

	.ref	GAMSTATE

	.ref	HALT
	.ref	dnk_head_dead_dizzy_anim
	.ref	dnk_fall_back_anim
	.ref	wres_collis_off
	.ref	change_anim1a
	.ref	ring_bell

	.REF	CALL_MATCH_OVER

	;from UTIL.ASM
	.ref	get_all_buttons_cur2
	.DEF	BONUS_MESS
	.DEF	DO_COMBO_MESS
	.ref	CLOSE_VERT_SCREEN_LINE,OPEN_VERT_SCREEN_LINE
	.REF	LINES_VERT
;RJR (REMOVE LINE)	.REF	anibobj
	.REF	ANIM_CROWD
	.REF	AUD1


#*****************************************************************************

;player life/turbo data struct
PLT_LIFE 	equ	0		;UHW	life pixels (164 max)
PLT_CLIFE	equ	PLT_LIFE+10h	;UHW	displayed life (164 max)
PLT_TURBO	equ	PLT_CLIFE+10h	;UHW	turbo val (5400h max)
PLT_ON_SECOND	EQU	PLT_TURBO+10h
PLT_PAL	        EQU	PLT_ON_SECOND+010H
PLT_SIZE	        equ	PLT_PAL+10h

;meter data struct
MD_LINK		equ	0		;UHW	PLYRNUM for this meter
MD_LIFE		equ	MD_LINK+10h	;UHL	life bar *obj
MD_LBAK		equ	MD_LIFE+20h	;UHL	turbo bar *obj
MD_NAME		equ	MD_LBAK+20h	;UHL	name *obj
MD_COMBO		equ	MD_NAME+20h
MD_COMBO_SIZE	equ	MD_COMBO+20h
MD_SIZE		equ	MD_COMBO_SIZE+10H


	.bss	life_data,	NUM_WRES*PLT_SIZE

	.bss	meter_data,	2*MD_SIZE

	.bss	damage_imgs,	4*32

	.bss	ram_lst,	32*40		;For announce_match

	BSSX	DAM_MULT,16

	.BSS	LAST_FLIP,16
	.BSS	PILE_COUNT,16
	.BSS	BODY_COUNT,16
	.BSS	FRANK_COUNT,16
	.BSS	GERM_COUNT,16
	.BSS	BACK_COUNT,16
	.BSS	HEAD_COUNT,16
	.BSS	SNAP_COUNT,16
	BSSX	HAVE_WE_AUDITED_THIS_GAME,16

;MJT Start
PILE_LIMIT	.EQU	0
FRANK_LIMIT	.EQU	0
BODY_LIMIT	.EQU	0
GERM_LIMIT	.EQU	0
BACK_LIMIT	.EQU	0
HEAD_LIMIT	.EQU	0
SNAP_LIMIT	.EQU	0
;MJT End
NUM_OF_COUNTERS	.EQU	7

#*****************************************************************************
*
* Life/Turbo meter sizes and positions.
*

LIFE_MAX	.equ	164		;green pixels in life bar
TURBO_MAX	.equ	84<<8		;max turbo value


#*****************************************************************************
*
* >a8 = PLYRNUM for left meter
* >a9 = PLYRNUM for right meter

 SUBR	init_life_data

 	;initialize life data
	MOVI	FGR2YL_P,A0
	CALLA	pal_getf
	MOVE	A0,A5
	movi	NUM_WRES,a0
	movi	life_data,a1
	movi	LIFE_MAX,a2
	movi	TURBO_MAX,a3
	clr	a4
#init_loop
	move	a2,*a1(PLT_LIFE)
	move	a3,*a1(PLT_TURBO)
	move	a4,*a1(PLT_CLIFE)
	move	a4,*a1(PLT_ON_SECOND)
	MOVE	A5,*A1(PLT_PAL)
	addi	PLT_SIZE,a1
	dsj	a0,#init_loop

	rets

CLEAR_COUNTERS
	MOVK	NUM_OF_COUNTERS,A0
	CLR	A1
	MOVI	PILE_COUNT,A2
CLEAR_NEXT_COUNTER
	MOVE	A1,*A2+
	DSJS	A0,CLEAR_NEXT_COUNTER
	RETS

#*****************************************************************************
*
* >a8 = PLYRNUM for left meter
* >a9 = PLYRNUM for right meter

 SUBR	init_rnd_life_data

	;initialize life data
	movi	NUM_WRES,a0
	movi	life_data,a1
	movi	LIFE_MAX,a2
#init_loop
	move	a2,*a1(PLT_LIFE)
	move	a2,*a1(PLT_CLIFE)
	addi	PLT_SIZE,a1
	dsj	a0,#init_loop

	rets

P1CNTR	.equ	PDATA
P2CNTR	.equ	PDATA+16
P1STATE	.equ	PDATA+32
P2STATE	.equ	PDATA+48

 SUBR	meters

	PUSH	a8,a9

 	;Start the credits message
	calla	start_credbox

	callr	display_damage

	;initialize meter data
	movi	meter_data,a1
	TBL_OBJ	lhlth1
	move	a8,*a1(MD_LIFE),L

	TBL_OBJ	lname
	move	a8,*a1(MD_NAME),L

	TBL_OBJ	lframec
	move	a8,*a1(MD_LBAK),L

	TBL_OBJ	lcombo
	move	a8,*a1(MD_COMBO),L
	clr	a8				;initialize the combo meter
	move	a8,*a1(MD_COMBO_SIZE)

	addi	MD_SIZE,a1

	TBL_OBJ	rhlth1
	move	a8,*a1(MD_LIFE),L

	TBL_OBJ	rname
	move	a8,*a1(MD_NAME),L

	TBL_OBJ	rframec
	move	a8,*a1(MD_LBAK),L

	TBL_OBJ	rcombo
	move	a8,*a1(MD_COMBO),L
	clr	a8				;initialize the combo meter
	move	a8,*a1(MD_COMBO_SIZE)

	;create the static (no-handle) objects
	TBL_OBJ	lframe
	TBL_OBJ	lframeb

	TBL_OBJ	rframe
	TBL_OBJ	rframeb

	callr	do_win_streaks

	PULL	a8,a9

	;wire up the meters
	clr	a0
	move	a8,a1
	callr	rewire_meter
	movk	1,a0
	move	a9,a1
	callr	rewire_meter

	CREATE	ANNC_PID,announce_match

	movk	1,a0
	move	a0,*a13(P1CNTR)
	move	a0,*a13(P2CNTR)
	clr	a0
	move	a0,*a13(P1STATE)
	move	a0,*a13(P2STATE)

#main_loop
;Update all the life data
	clr	a0

#maint_loop
	MOVE	@WHICH_SCREEN,A1,L
	CMPI	DUMRETS,A1
	JRNE	JUST_DISPLAY_THEM
	callr	inc_life
	inc	a0
	cmpi	NUM_WRES,a0
	jrne	#maint_loop

JUST_DISPLAY_THEM
;Update the meters
	clr	a0
	callr	update_meter
	movk	1,a0
	callr	update_meter

;Blink CPU controlled name with insert coins/press start
	movi	meter_data,a1
	move	@PSTATUS,a0
	btst	0,a0
	jrnz	#p2
;Plyr 1 is drone
	move	*a13(P1CNTR),a0
	dec	a0
	move	a0,*a13(P1CNTR)
	jrnz	#p2
	move	*a13(P1STATE),a0
	xori	1,a0	
	move	a0,*a13(P1STATE)
	jrz	#doname

;Do correct coin message

	movi	120,a0
	move	a0,*a13(P1CNTR)

	move	*a1(MD_NAME),a8,L
	movi	WF_START,a0
;Display the insert coin/press start message
	calla	CR_STRTP
	jrhs	#enough_money
	movi	WF_INSERT,a0
#enough_money
	calla	civanic
	jruc	#p2
#doname	
	movi	60,a0
	move	a0,*a13(P1CNTR)

	move	*a1(MD_LINK),a0
	X32	a0
	addi	process_ptrs,a0
	move	*a0,a0,L
	move	*a0(WRESTLERNUM),a0

	X32	a0
	addi	name_tbl,a0
	move	*a0,a0,L
;Change the name
	move	*a1(MD_NAME),a8,L
	calla	civanic

#p2
	movi	meter_data,a1
	addi	MD_SIZE,a1
	move	@PSTATUS,a0
	btst	1,a0
	jrnz	#ok

;Plyr 2 is drone
	move	*a13(P2CNTR),a0
	dec	a0
	move	a0,*a13(P2CNTR)
	jrnz	#ok
	move	*a13(P2STATE),a0
	xori	1,a0	
	move	a0,*a13(P2STATE)
	jrz	#doname2

;Do correct coin message

	movi	120,a0
	move	a0,*a13(P2CNTR)

	move	*a1(MD_NAME),a8,L
	movi	WF_START,a0
;Display the insert coin/press start message
	calla	CR_STRTP
	jrhs	#enough_money
	movi	WF_INSERT,a0
#enough_money2
	calla	civanic
	jruc	#ok
#doname2
	movi	60,a0
	move	a0,*a13(P2CNTR)

	move	*a1(MD_LINK),a0
	X32	a0
	addi	process_ptrs,a0
	move	*a0,a0,L
	move	*a0(WRESTLERNUM),a0

	X32	a0
	addi	name_tbl,a0
	move	*a0,a0,L
;Change the name
	move	*a1(MD_NAME),a8,L
	calla	civanic

#ok
	SLEEPK	1
	jruc	#main_loop

#********
*
* Meter objects and their positions
*


lbar_x		.equ	11
rbar_x		.equ	390

lcombo_x		.equ	181-45
rcombo_x		.equ	220+45

lname_x		.equ	97
rname_x		.equ	303

bar_y		.equ	20
combo_y		.equ	bar_y+18

name_y		.equ	13

bak_z		.equ	200
bar_z		.equ	202
frame_z		.equ	201
name_z		.equ	203


lcombo	.word	lcombo_x,combo_y,name_z			;X, Y, Z
	.long	SUPER_0
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT|SUBMFRAME		;OID
	.long	0,0					;XVEL, YVEL
	.even

rcombo	.word	rcombo_x,combo_y,name_z			;X, Y, Z
	.long	SUPER_0
	.word	DMAWNZ|M_FLIPH|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT|SUBMFRAME		;OID
	.long	0,0					;XVEL, YVEL
	.even

lframe	.word	lbar_x,bar_y,frame_z			;X, Y, Z
	.long	PWREMPTY
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT|SUBMFRAME		;OID
	.long	0,0					;XVEL, YVEL
	.even


rframe	.word	rbar_x,bar_y,frame_z			;X, Y, Z
	.long	PWREMPTY
	.word	DMAWNZ|M_3D|M_SCRNREL|M_FLIPH		;CTRL
	.word	CLSNEUT|TYPNEUT|SUBMFRAME		;OID
	.long	0,0					;XVEL, YVEL
	.even


lframeb	.word	lbar_x,bar_y,frame_z			;X, Y, Z
	.long	LBAR_GENB				;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT|SUBMFRAME		;OID
	.long	0,0					;XVEL, YVEL
	.even

rframeb	.word	rbar_x,bar_y,frame_z			;X, Y, Z
	.long	RBAR_GENB				;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL|M_FLIPH		;CTRL
	.word	CLSNEUT|TYPNEUT|SUBMFRAME		;OID
	.long	0,0					;XVEL, YVEL
	.even


lframec	.word	lbar_x,bar_y,bak_z			;X, Y, Z
	.long	LBAR_GENC				;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT|SUBMFRAME		;OID
	.long	0,0					;XVEL, YVEL
	.even

rframec	.word	rbar_x,bar_y,bak_z			;X, Y, Z
	.long	LBAR_GENC				;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL|M_FLIPH		;CTRL
	.word	CLSNEUT|TYPNEUT|SUBMFRAME		;OID
	.long	0,0					;XVEL, YVEL
	.even

lwin	.word	11,22h,name_z			;X, Y, Z
	.long	BWINBOX					;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL		;CTRL
	.word	CLSNEUT|TYPNEUT|SUBMFRAME		;OID
	.long	0,0					;XVEL, YVEL
	.even

rwin	.word	391,22h,name_z			;X, Y, Z
	.long	RWINBOX					;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT|SUBMFRAME		;OID
	.long	0,0					;XVEL, YVEL
	.even


lhlth1	.word	lbar_x,bar_y,bar_z			;X, Y, Z
	.long	FGRN2YEL
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT|SUBLBAR			;OID
	.long	0,0					;XVEL, YVEL
	.even

rhlth1	.word	rbar_x,bar_y,bar_z			;X, Y, Z
	.long	FGRN2YEL
	.word	DMAWNZ|M_3D|M_SCRNREL|M_FLIPH		;CTRL
	.word	CLSNEUT|TYPNEUT|SUBLBAR			;OID
	.long	0,0					;XVEL, YVEL
	.even

*
* name data
*

lname	.word	lname_x,name_y,name_z			;X, Y, Z
	.long	NAM_BRT					;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT|SUBLBAR			;OID
	.long	0,0					;XVEL, YVEL
	.even

rname	.word	rname_x,name_y,name_z			;X, Y, Z
	.long	NAM_RZR					;IMG
	.word	DMAWNZ|M_3D|M_SCRNREL			;CTRL
	.word	CLSNEUT|TYPNEUT|SUBLBAR			;OID
	.long	0,0					;XVEL, YVEL
	.even

;; A0 = PLAYER
; SUBR    REWIRE_COMBO_METER
;	MOVE	*A13(PLYRNUM),A0
;	CMPI	2,A0
;	JRLT	WE_SET_RIGHT_PLYRNUM
;	MOVE	@PSTATUS,A0
;	DEC	A0
;	NOT	A0
;	ANDI	1,A0
;WE_SET_RIGHT_PLYRNUM
;	PUSH	A0
;	ADDI 	FLASH_COMBO_PID,A0
;	MOVI	-1,A1
;	CALLA	KILALL
;	PULL	A0
;	movi	MD_SIZE,a1
;	mpyu	a0,a1
;	addi	meter_data,a1
;	CLR	A14
;	MOVE	A14,*A1(MD_COMBO_SIZE)
;	MOVE	*A1(MD_COMBO),A8,L
;	MOVE	A0,A0
;	JRZ	NO_NEED_TO_SET_XFLIP
;	MOVI	M_FLIPH,A14
;NO_NEED_TO_SET_XFLIP
;	MOVI	SUPER_P,A0
;	CALLA	pal_getf
;	MOVE	A0,*A8(OPAL)
;
;	MOVI	SUPER_0,A0
;	MOVE	*A0(ICTRL),A1
;	OR	A14,A1
;	ORI	8000H|DMAWNZ,A1
;	MOVE	A1,*A8(OCTRL)
;	move	*a0(IANIOFF),*A8(ODOFF),L
;	move	*a0(ISAG),*a8(OSAG),L
;	move	*a0(0),*a8(OSIZE),L
;	RETS

FLASH_COMBO
	CREATE0	DO_COMBO_SOUND

	MOVI	COMBO_P,A0
	CALLA	pal_getf
	MOVE	A0,*A8(OPAL)
	MOVE	*A8(OCTRL),A1
	ANDNI	M_FLIPH,A1
	MOVE	A1,*A8(OCTRL)
DO_COMBO_FLASH_AGAIN
	MOVI	COMBO_FLASH_ANIM,A1
	callr	setup_back_anim
	JSRP	ANIM_CROWD
	SLEEP	10
	JRUC	DO_COMBO_FLASH_AGAIN

DO_COMBO_SOUND
	SLEEP	25
	MOVI	3,A0
	CALLA	triple_sound
	DIE

CANI_END		equ	2 + 8000H

COMBO_FLASH_ANIM
	WL	2,COMBO_01
	WL	2,COMBO_02
	WL	2,COMBO_03
	WL	2,COMBO_04
	WL	2,COMBO_05
	WL	2,COMBO_06
	WL	2,COMBO_07
	WL	2,COMBO_08
	WL	2,COMBO_09
	WL	2,COMBO_10
	.WORD	CANI_END

 SUBR	CHECK_COMBO_GO
	MOVE	*A8(PLYRNUM),A14
	CMPI	2,A14
	JRLT	WE_SET_NUMBER_RIGHT
	MOVE	@PSTATUS,A14
	DEC	A14
	NOT	A14
	ANDI	1,A14
WE_SET_NUMBER_RIGHT
	movi	MD_SIZE,a1
	mpyu	a14,a1
	addi	meter_data,a1
	MOVE	*A1(MD_COMBO_SIZE),a14
	cmpi	16,a14
	rets


;A7 = BIT TO SET IN PLAYER HISTORY
;A5 = FIRST TIME FOR MOVE
;A6 = MOVE REPEAT
 SUBR    ADD_TO_COMBO_COUNT
	MOVE	A7,A2
	MOVE	A6,A3
	MOVE	*a13(COMBO_START),A1
	AND 	A1,A2
	JRNZ	ALREADY_ADDED_ONCE
	MOVE	A5,A3
	MOVE	*a13(COMBO_START),A1
	OR	A7,A1
	MOVE	A1,*A13(COMBO_START)
ALREADY_ADDED_ONCE
	MOVE	*A13(PLYRNUM),A1
	CMPI	2,A1
	JRLT	WE_SET_ON_PLAYER_NUMBER
	MOVE	@PSTATUS,A1
	DEC	A1
	NOT	A1
	ANDI	1,A1
WE_SET_ON_PLAYER_NUMBER
	movi	MD_SIZE,a9
	mpyu	a1,a9
	addi	meter_data,a9
	MOVE	*A9(MD_COMBO),A8,L
	MOVE	*A9(MD_COMBO_SIZE),A2
	ADD	A3,A2
	MOVE	A2,*A9(MD_COMBO_SIZE)
	CMPI	16,A2
	JRGE	SET_FLASHING_COMBO_GOING
	SLL	5,A2
	ADDI	WHICH_SIZE_BAR,A2
	MOVE	*A2,A0,L
	move	*a0(IANIOFF),*A8(ODOFF),L
	move	*a0(ISAG),*a8(OSAG),L
	RETS
SET_FLASHING_COMBO_GOING
	PUSH	A1
	ADDI	FLASH_COMBO_PID,A1
	MOVE	A1,A0
	MOVI	-1,A1
	CALLA	EXISTP
	JRNZ	COMBO_ALREADY_STARTED
	PULL	A0
	MOVI	FLASH_COMBO_PID,A1
	ADD	A0,A1
	MOVI	FLASH_COMBO,A7
	CALLA	GETPRC
	RETS
COMBO_ALREADY_STARTED
	PULL	A0
	RETS

WHICH_SIZE_BAR
	.LONG	SUPER_0
	.LONG	SUPER_1
	.LONG	SUPER_2
	.LONG	SUPER_3
	.LONG	SUPER_4
	.LONG	SUPER_5
	.LONG	SUPER_6
	.LONG	SUPER_7
	.LONG	SUPER_8
	.LONG	SUPER_9
	.LONG	SUPER_10
	.LONG	SUPER_11
	.LONG	SUPER_12
	.LONG	SUPER_13
	.LONG	SUPER_14
	.LONG	SUPER_15
	.LONG	SUPER_16




WHICH_NAME
	MOVE	A9,A10
	NOT	A9
	ANDI	1,A9
	MOVE	A10,A1
	CALLA	get_process_ptr
	MOVE	*A0(CLOSEST_NUM),A11
WHICH_NAME_DIS
	MOVI	REWIRE_PID,A0
	MOVI	-1,A1
	CALLA	EXISTP
	JRNZ	NO_REWIRE
	MOVE	A10,A1
	CALLA	get_process_ptr
	MOVE	*A0(CLOSEST_NUM),A1
	CMP	A11,A1
	JREQ	NO_REWIRE
	MOVE	A1,A11
	MOVE	A9,A0
	CALLR	rewire_meter
	CREATE	REWIRE_PID,WAIT_ON_REWIRE
NO_REWIRE
	SLOOP	1,WHICH_NAME_DIS

WAIT_ON_REWIRE
	SLEEP	20
	DIE

KILL_REWIRE_DUMMY
	MMTM	SP,A0,A1,A7
	MOVI	REWIRE_PID,A0
	MOVI	-1,A1
	CALLA	KILALL
	MMFM	SP,A0,A1,A7
	RETS

#*****************************************************************************
* 'rewires' a meter display for a different wrestler
* >a0 = display(0 or 1), >a1= playernum (0 to NUM_WRES-1)

 SUBR	rewire_meter

	;set the pointers
	;point a5 at the MD_???? block for the display
	movi	MD_SIZE,a5
	mpyu	a0,a5
	addi	meter_data,a5

	;point a6 at the PLT_???? block for PLYRNUM
	movi	PLT_SIZE,a3
	mpyu	a1,a3
	movi	life_data,a6
	add	a3,a6

	;set MD_LINK
	move	a1,*a5(MD_LINK)

	;point a7 at PLYRNUM's process
	move	a1,a7
	X32	a7
	addi	process_ptrs,a7
	move	*a7,a7,L

	;change the name
	MOVE	*A6(PLT_PAL),A2
	MOVE	*A5(MD_LIFE),A8,L
	MOVE	A2,*A8(OPAL),L
	move	*a5(MD_NAME),a8,L
	move	*a7(WRESTLERNUM),a1
	X32	a1
	addi	name_tbl,a1
	move	*a1,a0,L
	calla	civanic

	rets

name_tbl
	.long	NAM_BRT,NAM_RZR,NAM_UND,NAM_YOK,NAM_SHN
	.long	NAM_BAM,NAM_DNK,NAM_DNK,NAM_LEX,NAM_LEX

#*****************************************************************************
* Updates (resizes) the bars on a meter display.
* >a0 = meter (0 or 1)

 SUBRP	update_meter

	;aim a1 at the MD struct
	movi	MD_SIZE,a1
	mpyu	a0,a1
	addi	meter_data,a1

	;aim a3 at the PLT struct
	move	*a1(MD_LINK),a2
	movi	PLT_SIZE,a3
	mpyu	a2,a3
	addi	life_data,a3

	;set the life bar
	move	*a1(MD_LIFE),a8,L
	move	*a3(PLT_CLIFE),a14
	neg	a14
	addi	LIFE_MAX,a14		;a14 is pixels to hide

	move	a14,*a8(OFSET)

	JRZ	#NOT_TO_WORRY

	MOVE	@WHICH_SCREEN,A1,L
	CMPI	DUMRETS,A1
	JREQ	#NOT_TO_WORRY
	MOVE	*A8(OFLAGS),A1
	ORI	M_NODISP,A1
	MOVE	A1,*A8(OFLAGS)
	RETS

#NOT_TO_WORRY
	MOVE	*A8(OFLAGS),A1
	ANDI	0FFFFH-M_NODISP,A1
	MOVE	A1,*A8(OFLAGS)
	RETS


;	movi	5,a7
;	mpyu	a14,a7
;	move	*a8(OIMG),a14,L
;	move	*a14(ISAG),a14,L
;	add	a14,a7
;	move	a7,*a8(OSAG),L

	rets

#*****************************************************************************
* Returns the remaining health for a player
* >a1 = PLYRNUM
* <a0 = life

 SUBR	get_health

	movi	PLT_SIZE,a14
	mpyu	a14,a1
	addi	life_data,a1
	move	*a1(PLT_LIFE),a0
	rets


#*****************************************************************************
* Adjusts a player's health total
* >a0 = amount to add to player's health total
* >a1 = PLYRNUM
* >a10= attacker's process ptr

 SUBR	adjust_health

	PUSH	a1,a8,a10,a13

	MOVE	A0,A0
	JRZ	NO_MULTIPLIER

	;make sure a10 is valid
	move	*a13(WHOHITME),a14,L
	cmp	a14,a10
	jrne	NO_MULTIPLIER

	MOVE	*A10(COMBO_COUNT),A14
	JRZ	DO_NORMAL_ADJUST_CHECK
	SRA	1,A0
	CLR	A3
	MOVE	A3,@DAM_MULT
	JRUC	NO_MULTIPLIER

DO_NORMAL_ADJUST_CHECK

	MOVE	@DAM_MULT,A14
	JRZ	NO_MULTIPLIER
;THIS CODE IS A BIT OF A HACK, BUT NEVER MIND
;MULT 2= 1.5 x HIT DAMAGE
;MULT 3= 2.0 x HIT DAMAGE
;MULT 4 UPWARDS = 2.5 x HIT DAMAGE
	MOVE	A0,A3
	SLL	1,A3
	CMPI	3,A14
	JREQ	MULT_SET
	MOVE	A0,A10
	SRA	1,A10
	SUB	A10,A3
	CMPI	2,A14
	JREQ	MULT_SET
	ADD	A0,A3
MULT_SET
	MOVE	A3,A0
	CLR	A3
	MOVE	A3,@DAM_MULT
NO_MULTIPLIER

	move	a1,a14
	X32	a14
	addi	process_ptrs,a14
	move	*a14,a13,L

	move	*a13(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jrnz	#norm

;Opponent already dead

	jruc	#notdead

#norm

	move	a1,a10

	calla	log_damage

	callr	update_secret_display

	movi	PLT_SIZE,a14
	mpyu	a14,a1
	addi	life_data,a1
	move	*a1(PLT_LIFE),a14

	;if a14 > 20 and a14+a0 <= 20, fire off a danger process.
	PUSH	a0,a1,a14
	cmpi	30,a14
	jrle	#no_danger
	move	a14,a1
	add	a0,a1
	cmpi	30,a1
	jrgt	#no_danger

	CREATE0	flash_obj

#no_danger
	PULL	a0,a1,a14
	add	a14,a0
	jrn	#toolow
	jrz	#toolow

	cmpi	LIFE_MAX,a0
	jrle	#done

	movi	LIFE_MAX,a0
	jruc	#done

#toolow
	clr	a0
	
;MJT Start
	.if	DEBUG

	;if he's out of life and we're in debug mode, fill him up.
	move	@fight_debug,a14
	jrz	#done
	movi	LIFE_MAX,a0
	.endif
;MJT End

#done
	move	a0,*a1(PLT_LIFE)

;	PULL	a1,a10

	move	a10,a1

	callr	get_health


;Temp...  Take this jrnz out and one blow kills opponent!
	jrnz	#notdead


;Is combo mode on for this player?
	move	*a13(WHOHITME),a8,L
	callr	CHECK_COMBO_GO
	jrlt	#ok
;Am I in the middle of a combo?
	move	*a8(COMBO_COUNT),a0
;MJT Start
	jrz	#ok
;Give him some life back
	move	*a13(PLYRNUM),a1
	movi	PLT_SIZE,a14
	mpyu	a14,a1
	addi	life_data,a1
	movk	1,a14
	move	a14,*a1(PLT_LIFE)
	movk	1,a0
	move	a0,*a13(I_WILL_DIE)
	jruc	#notdead
#ok


;If this is the match winning blow, then keep opponent standing in finish him
;mode.  Otherwise, knock him down to the ground and move onto the next round.

;Finish this someday!
;We need to decide what to do in finish him situations.


;Player has just lost his first round, knock him down onto
;his butt.






;Add speech call "Pin him!"

;MJT Start
;	WRSND	W_DOINK,FLYKICK_L1,FLYKICK_L2
;MJT End






	clr	a0
	move	a0,*a13(ROLL_POS)

;Lookup table based on wrestler type

	move	*a13(WHOHITME),a10,L	;* wrestler process
	move	*a10(ATTACK_MODE),a0
	cmpi	AMODE_BLBOWDROP,a0
	jrz	#skip0
	cmpi	AMODE_BSTOMP,a0
	jrz	#skip0
	cmpi	AMODE_BUTTSTOMP,a0
	jrz	#skip0

	move	*a13(WRESTLERNUM),a0
	sll	5,a0

	move	*a13(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jrz	#grnd
	cmpi	MODE_ONGROUND,a14
	jrnz	#fall

#grnd	addi	#convulse_t,a0
	move	*a0,a0,L

	calla	change_anim1a

	SETMODE	DEAD
#skip0
	calla	wres_collis_off

	PULL	a1,a8,a10,a13

	setc
	rets

#fall
;Check plyr mode, attempt a death fall back
;Otherewise, just set mode dead
	cmpi	MODE_NORMAL,a14
	jrz	#fallbk
	cmpi	MODE_RUNNING,a14
	jrz	#fallbk
	cmpi	MODE_INAIR,a14
	jrz	#fallbk
	cmpi	MODE_INAIR2,a14
	jrz	#fallbk
	cmpi	MODE_BOUNCING,a14
	jrz	#fallbk
	cmpi	MODE_ONTURNBKL,a14
	jrz	#fallbk
	cmpi	MODE_BLOCK,a14
	jrz	#fallbk
	cmpi	MODE_DIZZY,a14
	jrz	#fallbk
	cmpi	MODE_CLIMBTURNBKL,a14
	jrz	#fallbk
	cmpi	MODE_HEADHOLD,a14
	jrz	#fallbk
	cmpi	MODE_HEADHELD,a14
	jrz	#skip

;Puppet mode?  Others?
;How best to deal with this?

     
	SETMODE	DEAD
#skip	calla	wres_collis_off
;MJT End

	PULL	a1,a8,a10,a13

	setc
	rets


#fallbk	addi	#fallbacks_t,a0
	move	*a0,a0,L

	calla	change_anim1a

	movi	[2,0],a2
	move	*a13(OBJ_XPOSINT),a1
	move	*a13(WHOHITME),a0,L	;* wrestler process

;MJT Start
;	move	*a0(OBJ_XVEL),a14,L
;	sra	1,a14		   	;x_vel after collis
;	neg	a14
;	move	a14,*a0(OBJ_XVEL),L
;	movi	60000h,a14	;4
;	move	a14,*a0(OBJ_YVEL),L
;MJT End


	move	*a0(OBJ_XPOSINT),a0
	cmp	a0,a1			;offx - defx
	jrgt	#fall_right		;attacker on left
	movi	[-2,0],a2


#fall_right
	move	a2,*a13(OBJ_XVEL),L

	calla	wres_collis_off
     
	SETMODE	DEAD

	PULL	a1,a8,a10,a13

	setc
	rets


;#finishhim
;
;	move	*a13(WRESTLERNUM),a0
;	sll	5,a0
;	addi	#dizzydead_t,a0
;	move	*a0,a0,L
;
;	calla	change_anim1a
;
;	PULL	a1,a10,a13
;
;	setc
;	rets

#notdead
	PULL	a1,a8,a10,a13

	clrc
	rets

#fallbacks_t
#fall_back
	.ref	hrt_fall_back_anim		;0 Bret Hart
	.ref	rzr_fall_back_anim		;1 Razor Ramon
	.ref	und_fall_back_anim		;2 Undertaker
	.ref	yok_fall_back_anim		;3 Yokozuna
	.ref	shn_fall_back_anim		;4 Shawn Michaels
	.ref	bam_fall_back_anim		;5 Bam Bam
	.ref	dnk_fall_back_anim		;6 Doink
	.ref	lex_fall_back_anim		;8 Lex Luger

	.long	hrt_fall_back_anim		;0 Bret Hart
	.long	rzr_fall_back_anim		;1 Razor Ramon
	.long	und_fall_back_anim		;2 Undertaker
	.long	yok_fall_back_anim		;3 Yokozuna
	.long	shn_fall_back_anim		;4 Shawn Michaels
	.long	bam_fall_back_anim		;5 Bam Bam
	.long	dnk_fall_back_anim		;6 Doink
	.long	0				;7 spare
	.long	lex_fall_back_anim		;8 Lex Luger
	.long	0				;9 Referee
 

	.ref	dnk_hitonground_anim
#convulse_t
#hitonground
	.ref	hrt_hitonground_anim		;0 Bret Hart
	.ref	rzr_hitonground_anim		;1 Razor Ramon
	.ref	und_hitonground_anim		;2 Undertaker
	.ref	yok_hitonground_anim		;3 Yokozuna
	.ref	shn_hitonground_anim		;4 Shawn Michaels
	.ref	bam_hitonground_anim		;5 Bam Bam
	.ref	dnk_hitonground_anim		;6 Doink
	.ref	lex_hitonground_anim		;8 Lex Luger

	.long	hrt_hitonground_anim		;0 Bret Hart
	.long	rzr_hitonground_anim		;1 Razor Ramon
	.long	und_hitonground_anim		;2 Undertaker
	.long	yok_hitonground_anim		;3 Yokozuna
	.long	shn_hitonground_anim		;4 Shawn Michaels
	.long	bam_hitonground_anim		;5 Bam Bam
	.long	dnk_hitonground_anim		;6 Doink
	.long	0				;7 spare
	.long	lex_hitonground_anim		;8 Lex Luger
	.long	0				;9 Referee

;Fix this some day
;MJT Start
;#dizzydead_t
;	.long	dnk_head_dead_dizzy_anim	;0 Bret Hart
;	.long	dnk_head_dead_dizzy_anim	;1 Razor Ramon
;	.long	dnk_head_dead_dizzy_anim	;2 Undertaker
;	.long	dnk_head_dead_dizzy_anim	;3 Yokozuna
;	.long	dnk_head_dead_dizzy_anim	;4 Shawn Michaels
;	.long	dnk_head_dead_dizzy_anim	;5 Bam Bam
;	.long	dnk_head_dead_dizzy_anim	;6 Doink
;	.long	dnk_head_dead_dizzy_anim	;7 Adam Bomb
;	.long	dnk_head_dead_dizzy_anim	;8 Lex Luger
;	.long	dnk_head_dead_dizzy_anim	;9 Referee

;MJT End

#*****************************************************************************
* Create the credits display at the top of the screen
*

 SUBR	start_credbox

	;draw the panel
	TBL_OBJ	#plate

	callr	update_credit_msg
	rets

	
***************************************
* Display credit info - Gets called from coin routines.
*
* Trashes a0-a7

 SUBR	update_credit_msg

	PUSH	a8,a9,a10

;Only turn on these messages if during gameplay, or player select!

	.ref	SHOW_CRD_FLAG
	move	@SHOW_CRD_FLAG,a0
	jrnz	#cont0

	move	@GAMSTATE,a0
	cmpi	INSELECT,a0
	jrz	#cont

	CMPI	INPREGAME,A0
	JREQ	#cont

	subk	INGAME,a0
	jrne	#x

#cont0

;When coins are entered, and the game is being played, tell the meter
;code to display approproiate coinin message.

;Get meter process info
	movi	METER_PID,a0
	clr	a1
	not	a1
	calla	EXISTP
	jrz	#cont

	movk	1,a1
	move	a1,*a0(P1CNTR)
	move	a1,*a0(P2CNTR)
	clr	a1
	move	a1,*a0(P1STATE)
	move	a1,*a0(P2STATE)

#cont

	movi	CLSDEAD|CREDITID,a0
	calla	obj_del1c		;kill credit/qrtr imgs
 
	movi	freeply,a10

	movk	ADJFREPL,a0
	CALLA	GET_ADJ		 	;SEE IF FREEPLAY......(Z BIT CLEAR IF SO!)
	jrnz	#freep

	movi	credit,a10

	calla	GET_CREDITS
	calla	BINBCD
	
	move	a0,a9
	sll	32-4,a0
	srl	32-4-5,a0		;*32
	addi	#numfont,a0
	move	*a0,a2,L

	movi	[216,0],a0
	movi	[6,0],a1
;	movi	1006,a3			;Z
	movi	201,a3			;Z
	movi	DMAWNZ|M_SCRNREL,a4
	movi	CLSDEAD|CREDITID,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ
	
	srl	4,a9
	sll	32-4,a9
	srl	32-4-5,a9		;*32
	addi	#numfont,a9
	move	*a9,a2,L

	movi	[211,0],a0
	movi	[6,0],a1
	calla	BEGINOBJ
	
#freep	movi	[179,0],a0
	movi	[6,0],a1
	move	a10,a2
;	movi	1006,a3			;Z
	movi	201,a3			;Z
	movi	DMAWNZ|M_SCRNREL,a4
	movi	CLSDEAD|CREDITID,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ

#x	PULL	a8,a9,a10

	rets

***************************************
* config data
*

#plate	.word	176,4,200				;X, Y, Z
;#plate	.word	176,4,1006				;X, Y, Z
	.long	crplate					;IMG
	.word	DMAWNZ|M_SCRNREL			;CTRL
	.word	CLSDEAD					;OID
	.long	0,0					;XVEL, YVEL
	.even

#numfont
	.long	font60
	.long	font61
	.long	font62
	.long	font63
	.long	font64
	.long	font65
	.long	font66
	.long	font67
	.long	font68
	.long	font69

#*****************************************************************************
* Moves PLT_CLIFE toward PLT_LIFE if it isn't already there.
* >a0 = PLYRNUM

#lifebar_deltavee	equ	2	;pixels per tick of motion

 SUBRP	inc_life

	;aim a1 at PLT block
	movi	PLT_SIZE,a1
	mpyu	a0,a1
	addi	life_data,a1

	;check the values
	move	*a1(PLT_LIFE),a2
	move	*a1(PLT_CLIFE),a3

	cmp	a2,a3
	jrz	#done

	;CLIFE is lagging.  move it toward LIFE
	jrgt	#shrink

	;CLIFE needs to grow
	addi	#lifebar_deltavee,a3
	cmp	a3,a2
	jruc	#set

#shrink
	subi	#lifebar_deltavee,a3
	cmp	a2,a3
#set
	jrge	#inrange

	;overshot it
	move	a2,a3	    
#inrange
	move	a3,*a1(PLT_CLIFE)

#done
	rets

#*****************************************************************************
* Secret display of damage amount
*

 SUBR	display_damage

	PUSH	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	move	@secret_damage,a2
	jrz	#out


	cmpi	2,a2
	jrz	#p2

;Display P1 damage meter
	
	movi	damage_imgs,a9

	movi	[0bh,0],a0
	movi	[0e8h,0],a1		;21h
	movi	damage,a2
	movi	1006,a3			;Z
	movi	DMAWNZ|M_SCRNREL,a4
	movi	CLSNEUT|TYPNEUT|SUBMES1,a5
	clr	a6
	clr	a7
	movi	DMG_P,b0
	calla	BEGINOBJP


;Now draw both digits for player 1

	movi	[4fh,0],a0
	movi	[0ech,0],a1
	movi	SGMD8_0,a2
	movi	1007,a3			;Z
	movi	SGMD8YEL2,b0
	calla	BEGINOBJP
	move	a8,*a9+,L

	movi	[48h,0],a0
	movi	[0ech,0],a1
	movi	SGMD8_0,a2
	movi	1007,a3			;Z
	movi	SGMD8YEL2,b0
	calla	BEGINOBJP
	move	a8,*a9+,L

	move	@secret_damage,a2
	cmpi	1,a2
	jrz	#out

;Also do p2

#p2

;Display p2 damage meter

	movi	[135h,0],a0
	movi	[0e8h,0],a1
	movi	damage,a2
	movi	1006,a3			;Z
	movi	DMAWNZ|M_SCRNREL,a4
	movi	CLSNEUT|TYPNEUT|SUBMES1,a5
	clr	a6
	clr	a7
	movi	DMG_P,b0
	calla	BEGINOBJP

;Now draw both digits for player 2

	movi	[178h,0],a0
	movi	[0ech,0],a1
	movi	SGMD8_0,a2
	movi	1007,a3			;Z
	movi	SGMD8YEL2,b0
	calla	BEGINOBJP
	move	a8,*a9+,L

	movi	[171h,0],a0
	movi	[0ech,0],a1
	movi	SGMD8_0,a2
	movi	1007,a3			;Z
	movi	SGMD8YEL2,b0
	calla	BEGINOBJP
	move	a8,*a9+,L

#out
	PULL	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9

	rets

#*****************************************************************************
* Update secret display of damage amount
* >a0 = amount to display
* >a1 = PLYRNUM

 SUBRP	update_secret_display
	
	PUSH	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	move	@secret_damage,a2
	jrz	#out

	neg	a0

	move	a1,a1
	jrz	#p2
;Plyr 1

	btst	0,a2
	jrz	#out


	calla	BINBCD
	
	move	a0,a9
	sll	32-4,a0
	srl	32-4-5,a0		;*32
	addi	#numfont,a0
	move	*a0,a1,L
	move	@damage_imgs,a8,L
	move	*a8(OCTRL),a4
	calla	ANI

	srl	4,a9
	sll	32-4,a9
	srl	32-4-5,a9		;*32
	addi	#numfont,a9
	move	*a9,a1,L
	move	@damage_imgs+32,a8,L
	move	*a8(OCTRL),a4
	calla	ANI
	jruc	#out

#p2

	btst	1,a2
	jrz	#out

	calla	BINBCD
	
	move	a0,a9
	sll	32-4,a0
	srl	32-4-5,a0		;*32
	addi	#numfont,a0
	move	*a0,a1,L
	move	@damage_imgs+64,a8,L
	move	*a8(OCTRL),a4
	calla	ANI

	srl	4,a9
	sll	32-4,a9
	srl	32-4-5,a9		;*32
	addi	#numfont,a9
	move	*a9,a1,L
	move	@damage_imgs+96,a8,L
	move	*a8(OCTRL),a4
	calla	ANI
#out
	PULL	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9

	rets
	

#numfont
	.long	SGMD8_0
	.long	SGMD8_1
	.long	SGMD8_2
	.long	SGMD8_3
	.long	SGMD8_4
	.long	SGMD8_5
	.long	SGMD8_6
	.long	SGMD8_7
	.long	SGMD8_8
	.long	SGMD8_9

#*****************************************************************************
* Flash the background of the life meter for the current player.
* >a10 = plyrnum

danger_snd	equ	0b9h

 SUBRP	flash_obj

	;find the bar obj
	movi	meter_data,a1
	move	*a1(MD_LINK),a2
	cmp	a10,a2
	jreq	#found
	addi	MD_SIZE,a1
	move	*a1(MD_LINK),a2
	cmp	a10,a2
	jrne	#not_displayed
#found
	move	*a1(MD_LBAK),a8,L

	movi	danger_snd,a0
	calla	triple_sound

	movi	26,a3
	calla	SNDSND
	CLR	A1
	MOVI	225,A0
	CALLA	SET_LOWER_VOL

	movi	TSEC&0FFFEh,a10		;make sure it's an even number
	movi	0808h,a0
	move	a0,*a8(OCONST),W
#loop
	move	*a8(OCTRL),a0,W
	xori	M_CONST|M_WRNONZ,a0
	move	a0,*a8(OCTRL),W
	SLEEPK	1
	dsj	a10,#loop

#not_displayed
	DIE



******************************************************************************

do_win_streaks

	move	@p1winstreak,a0
	jrz	#p2

	cmpi	99,a0
	jrls	#maxok
	movi	99,a0
#maxok
    	calla	BINBCD

	move	a0,a9
	sll	32-4,a0
	srl	32-4-5,a0		;*32
	addi	#f_t,a0
	move	*a0,a2,L

	movi	[3dh,0],a0
	movi	[23h,0],a1
	movi	1000h|name_z,a3			;Z
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ

;	move	a8,a10

	srl	4,a9
	sll	32-4,a9
	srl	32-4-5,a9		;*32
	addi	#f_t,a9
	move	*a9,a2,L
	movi	[36h,0],a0
	movi	[23h,0],a1
	calla	BEGINOBJ
   
	TBL_OBJ	lwin

#p2	move	@p2winstreak,a0
	jrz	#x

	cmpi	99,a0
	jrls	#maxok2
	movi	99,a0
#maxok2
    	calla	BINBCD

	move	a0,a9
	sll	32-4,a0
	srl	32-4-5,a0		;*32
	addi	#f_t,a0
	move	*a0,a2,L

	movi	[175h,0],a0
	movi	[23h,0],a1
	movi	1000h|name_z,a3			;Z
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ
	move	a8,a10

	srl	4,a9
	sll	32-4,a9
	srl	32-4-5,a9		;*32
	addi	#f_t,a9
	move	*a9,a2,L
	movi	[16eh,0],a0
	movi	[23h,0],a1
	calla	BEGINOBJ

	TBL_OBJ	rwin

#x
	rets

#f_t
	.long	WFONT_0,WFONT_1,WFONT_2,WFONT_3,WFONT_4
	.long	WFONT_5,WFONT_6,WFONT_7,WFONT_8,WFONT_9


	.ref	match_cnt

#*****************************************************************************
*

	STRUCTPD
	LONG	BLINK_PROC

announce_match


	MOVI	CROWD_CHEER_0,A3
	CALLA	SNDSND

	clr	a0
	move	a0,*a13(BLINK_PROC),L

	move	@PSTATUS,a0
	jrnz	#noamode
	clr	a0
	move	a0,@HALT
	DIE

#noamode

 .if DEBUG
	.ref	skip_select
	move	@skip_select,a0
	jrz	#noskp
	clr	a0
	move	a0,@HALT
	DIE
#noskp
 .endif


	SLEEP	28h

	movi	ram_lst,a11
	clr	a0
	movi	39,a1
#lp	move	a0,*a11+,L
	dsjs	a1,#lp
	movi	ram_lst,a11

	movi	[252h,0],a0			;x pos
	movi	[3eh,0],a1			;y pos
	movi	MTCHPLT,a2
	movi	MPLTPRPP,b0
	movi	1800h,a3				;z pos
	callr	#begin_obj

	movi	[252h,0],a0			;x pos
	movi	[3eh,0],a1			;y pos
	movi	MNMEPLT,a2
	movi	MPLTPRPP,b0
	movi	1800h,a3				;z pos
	callr	#begin_obj

	movi	[574,0],a0			;x pos
	movi	[4Fh,0],a1			;y pos
	movi	MATCH,a2
	movi	WGFS_W_P,b0
	movi	1801h,a3				;z pos
	callr	#begin_obj
	MOVE	A8,B3
	CLR	B4
	CLR	B5
	CLR	B6

	move	@match_cnt,a0

	cmpi	999,a0
	jrls	#maxok
	movi	999,a0
#maxok
    	calla	BINBCD

	move	a0,a9
	move	a0,a10
	sll	32-4,a0
	srl	32-4-5,a0		;*32
	addi	#f_t,a0
	move	*a0,a2,L

	movi	[252h,0],a0			;x pos
	movi	[43h,0],a1			;y pos
	movi	WGFS_W_P,b0
	movi	1802h,a3				;z pos
	callr	#begin_obj
	MOVE	A8,B4

	srl	4,a9
	sll	32-4,a9
	srl	32-4-5,a9		;*32
	move	a9,a9
	jrz	#ok2

	addi	#f_t,a9
	move	*a9,a2,L
	movi	[252h,0],a0			;x pos
	movi	[43h,0],a1			;y pos
	movi	WGFS_W_P,b0
	movi	1802h,a3				;z pos
	callr	#begin_obj
	MOVE	A8,B5

	srl	8,a10
	sll	32-4,a10
	srl	32-4-5,a10		;*32
	move	a10,a10
	jrz	#ok2

	addi	#f_t,a10
	move	*a10,a2,L
	movi	[252h,0],a0			;x pos
	movi	[43h,0],a1			;y pos
	movi	WGFS_W_P,b0
	movi	1802h,a3				;z pos
	callr	#begin_obj
	MOVE	A8,B6

#ok2
	MOVE	*B3(OSIZEX),B7
	ADDI	5,B7
	MOVE	*B4(OSIZEX),B0
	ADD	B0,B7
	ADDK	3,B7
	MOVE	B5,B5
	JRZ	NO_NEED_TO_ADD_TO_X
	SUBK	3,B7
	MOVE	*B5(OSIZEX),B0
	ADD	B0,B7
	MOVE	B6,B6
	JRZ	NO_NEED_TO_ADD_TO_X
	MOVE	*B6(OSIZEX),B0
	ADD	B0,B7

NO_NEED_TO_ADD_TO_X
	SRL	1,B7
	MOVI	252H,B8
	SUB	B7,B8
	MOVE	B8,*B3(OXPOS)
	ADDI	5,B8
	MOVE	B5,B5
	JRNZ	NO_EXTRA_SPACE
	ADDK	3,B8
NO_EXTRA_SPACE

	MOVE	B6,B6
	JRZ	NO_NEED_TO_ADD_TO_X2A
	MOVE	*B3(OSIZEX),B7
	ADD	B7,B8
	MOVE	B8,*B6(OXPOS)
	JRUC	X2A_ADDED

NO_NEED_TO_ADD_TO_X2A
	MOVE	B3,B6
X2A_ADDED
	MOVE	B5,B5
	JRZ	NO_NEED_TO_ADD_TO_X2B
	MOVE	*B6(OSIZEX),B7
	ADD	B7,B8
	MOVE	B8,*B5(OXPOS)
	JRUC	X2B_ADDED

NO_NEED_TO_ADD_TO_X2B
	MOVE	B3,B5
X2B_ADDED
	MOVE	*B5(OSIZEX),B7
	ADD	B7,B8
	MOVE	B8,*B4(OXPOS)

;Print the text on the little plate

;This will be a table lookup which points to match type
;(Ex. Best 2 of 3, Intercontinental Championship, WWF Championship
;Lumberjack match, Tag Team Bout, This contest is for 1 fall!, etc.)

;Make sure we have enough ram set aside for the largest
;message possible.  (ram_lst)

	movi	[253h,0],a0			;x pos
	movi	[68h,0],a1			;y pos
	CLR	A3
	movi	WHICH_MATCH,a2
	SLL	5,A3
	ADD	A3,A2
	MOVE	*A2,A2,L
	movi	WSF_W_P,b0
	movi	1801h,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	CLSNEUT|TYPTEXT|SUBMES1,a5
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJP


;Place all of the new plates & string characters onto the ram_lst that
;gets scrolled.

	movi	OBJLST,a14
	movi	CLSNEUT|TYPTEXT|SUBTXT,a0
	movi	CLSNEUT|TYPTEXT|SUBMES1,a2
#lp2
	move	*a14,a14,L
	jrz	#x
	move	*a14(OID),a1
	cmp	a2,a1
	jrz	#add
	cmp	a0,a1
	jrne	#lp2
#add	move	a14,*a11+,L
  	jruc	#lp2
#x

;This will blink between red/white
	CREATE0	blink_font
	move	a0,*a13(BLINK_PROC),L

;Slide everthing onto screen

	movi	>b6,a0
	calla	triple_sound

	movi	30h,a10
#onscr_loop

	SLEEPK	1

	movi	[200,0],a0
	callr	#set_x

	dsj	a10,#onscr_loop

	CREATE0	DO_ROUNDS

;In middle
	CREATE0	ring_bell

	SLEEP	20h

	movi	60h,a10
	.ref	wait_on_butn
	JSRP	wait_on_butn

	movi	>b6,a0
	calla	triple_sound

	movi	23h,a10

#offscr_loop

	SLEEPK	1

	movi	[0feb0h,0],a0
	callr	#set_x

	dsj	a10,#offscr_loop

	move	*a13(BLINK_PROC),a0,L
	calla	KILL

	clr	a0
	move	a0,@HALT

	movi	CLSNEUT|TYPTEXT|SUBTXT,a0
	calla	obj_del1c		;delete text/plates

	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
	calla	obj_del1c		;delete text/plates

	DIE

#f_t
	.long	WGSF22_0,WGSF22_1,WGSF22_2,WGSF22_3,WGSF22_4
	.long	WGSF22_5,WGSF22_6,WGSF22_7,WGSF22_8,WGSF22_9

WHICH_MATCH
	.LONG	BESTOF3
	.LONG	ROYRUM
	.LONG 	ELIMMTCH
	.LONG	TAGTEAM
	.LONG	ONEFALL
	.LONG	LUMBMTCH



#ln0a_setup
	JAM_STR	osgemd_ascii,6,0,247h,43h,BLUE,0

#ln0b_setup
	JAM_STR	osgemd_ascii,6,0,23fh,43h,BLUE,0

#ln1_setup
	JAM_STR	sgmd8_ascii,5,0,252h,80h-10,SGMD8WHT2,0

#ln2_setup
	JAM_STR	sgmd8_ascii,5,0,252h,8bh-10,SGMD8WHT2,0

#str_rounds
	.string	"ROUNDS",0
	.even

blink_font

	SLEEPK	2

	movi	20,a10
#top	
	movi	WSF_R_P,a0
	calla	pal_getf

	movi	ram_lst,a11
#lp3
	move	*a11+,a8,L
	jrz	#x2
	move	*a8(OID),a14
	cmpi	CLSNEUT|TYPTEXT|SUBMES1,a14
	jrnz	#lp3
	move	a0,*a8(OPAL)
  	jruc	#lp3

#x2	SLEEPK	4

	movi	WSF_W_P,a0
	calla	pal_getf

	movi	ram_lst,a11
#lp4
	move	*a11+,a8,L
	jrz	#x3
	move	*a8(OID),a14
	cmpi	CLSNEUT|TYPTEXT|SUBMES1,a14
	jrnz	#lp4
	move	a0,*a8(OPAL)
  	jruc	#lp4

#x3	SLEEPK	7

	dsj	a10,#top

announcing_being_done
	DIE


 SUBR	announce_rnd_winner

	movi	ANNC_PID,a0
	clr	a1
	not	a1
	calla	EXISTP
	jrnz	announcing_being_done

	MOVI	CROWD_VICTORY_LOOP,A3
 	CALLA	SNDSND

	calla	set_winner
	X32	a3
	addi	process_ptrs,a3
	move	*a3,a10,L

	move	@p1rounds,a0
	cmpi	2,a0
	jrz	at_end
	move	@p2rounds,a0
	cmpi	2,a0
	jreq	at_end
	calla	calc_match_time_1
	jruc	timer_updated

at_end
	calla	calc_match_time_2

timer_updated

;a10=*proc of wrestler who just pinned opponent
;
	SLEEP	30

;Place token on top of winner, then have it float up to the top of the screen

	movi	27,a3
	calla	SNDSND
	CLR	A1
	MOVI	255,A0
	CALLA	SET_LOWER_VOL

;	movi	[200,0],a0			;x pos
;	movi	[2fh,0],a1			;y pos
;	movi	MTCHPLT,a2
;	movi	MPLTPRPP,b0
;	movi	1800h,a3				;z pos
;	callr	#begin_obj
;
;	movi	#ln_nm1_setup,a2
;	calla	setup_message
;
;	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
;	move	a0,@mess_objid
;
;	move	*a10(WRESTLERNUM),a0
;	sll	5,a0
;	addi	#ln1_t,a0
;	move	*a0,a4,L
;	calla	print_string_C2
;
;	movi	#ln_nm2_setup,a2
;	calla	setup_message
;      
;	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
;	move	a0,@mess_objid
;
;;Display who won & what round was won
; 	movi	#rnd1,a4
;	move	@current_round,a0
;	cmpi	1,a0
;	jrz	#ok0
;	movi	#rnd2,a4
;	cmpi	2,a0
;	jrnz	#okz
;;This may be a match winner!
;	move	@p1rounds,a0
;	jrz	#okz
;	cmpi	2,a0
;	jrnz	#ok0
;#okz
;;Match winner
;	movi	#rnd3,a4
;#ok0	calla	print_string_C2
;
;;This will blink between red/white
;	SLEEPK	4
;
;	PUSH	a8,a9
;	movi	SGMD8RED2,a8
;	movi	SGMD8WHT2,a9
	.ref	blink_pals
;	CREATE0	blink_pals
;	PULL	a8,a9
;	move	a0,*a13(BLINK_PROC),L
;
;	SLEEP	60

	CALLA	CALL_MATCH_OVER

	SLEEP	20

	move	@p1rounds,a0
	cmpi	2,a0
	jrz	DO_WAIT
	move	@p2rounds,a0
	cmpi	2,a0
	jrnz	WE_CAN_EXIT

DO_WAIT
	MOVI	2*TSEC,a9
WAIT_HERE
	SLEEPK	1
	calla	get_all_buttons_cur2
	JRNZ	WE_CAN_EXIT
	DSJS	A9,WAIT_HERE

WE_CAN_EXIT
	move	@current_round,a9
	CMPI	1,A9
	JREQ	SET_WHICH_ROUND
	CMPI	3,A9
	JREQ	SET_WHICH_ROUND
	INC	A9
	move	@p1rounds,a0
	JRZ	SET_WHICH_ROUND
	CMPI	2,A0
	JREQ	SET_WHICH_ROUND
	DEC	A9
SET_WHICH_ROUND
	DEC	A9

	MOVE	*A10(PLYRNUM),A11
	CMPI	2,A11
	JRLT	NO_PROBLEMS_HERE
	CLR	A11
	MOVE	@PSTATUS,A0
	SRL	1,A0
	JRNC	NO_PROBLEMS_HERE
	INC	A11
NO_PROBLEMS_HERE
	CREATE0	CREATE_END_ROUND_TOP
	SLEEP	15
	CREATE0	CREATE_END_ROUND_BOT
	SLEEP	40
	CREATE0	CREATE_END_ROUND_ICON

	CALLA	CLEAR_SPEECH_REPEAT

	move	@p1rounds,a0
	cmpi	2,a0
	jrz	#end
	move	@p2rounds,a0
	cmpi	2,a0
	jrnz	#not_end

#end
	clr	a0
	move	a0,@HALT

	MOVI	260,a9
WAIT_HERE2
	SLEEPK	1
	calla	get_all_buttons_cur2
	JRNZ	WE_CAN_EXIT2
	DSJS	A9,WAIT_HERE2
WE_CAN_EXIT2
	MOVK	2,A0
	move	a0,@match_over
	MOVI	4DH,A0
	CALLA	triple_sound
	DIE

#not_end

	SLEEP	85
	CLR	A1
	MOVE	*A2(PLYRNUM),A3
	JRZ	WHICH_ONE_SORTED
	INC	A1
	DEC	A3
	JRZ	WHICH_ONE_SORTED
	MOVE	*A10(PLYRNUM),A3
	JRZ	WHICH_ONE_SORTED
	DEC	A1
WHICH_ONE_SORTED
	MOVE	A1,A5
	MOVI	PLT_SIZE,A3
	MPYU	A3,A1
	ADDI	life_data,A1
	MOVI	LIFE_MAX,A14
	move	a14,*a1(PLT_LIFE)

	MOVI	MD_SIZE,A3
	MPYU	A3,A5
	ADDI	meter_data,A5
	MOVE	*A5(MD_LIFE),A8,L

	MOVI	FYL2RD_P,A0
	CALLA	pal_getf
	MOVE	A0,*A8(OPAL)

;Cause wrestlers to re-appear in the correct spot to start the next round.

	CALLA	CLEAR_SPEECH_REPEAT

	MOVE	@current_round,A1
	MOVI	16,A3
	CMPI	2,A1
	JREQ	NOT_THIRD_MATCH
	MOVI	17,A3
NOT_THIRD_MATCH
	CALLA	SNDSND
	CLR	A1
	MOVI	175,A0
	CALLA	SET_LOWER_VOL
NO_LOWER
	movk	16,a8
	movk	1,a9
	jsrp	CLOSE_VERT_SCREEN_LINE

	MOVI	LINES_VERT,A1
	MOVE	A1,@WHICH_SCREEN,L

	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
	calla	obj_del1c		;delete text/plates

	calla	reset_for_round
	calla	reset_for_round2

	movi	TIMER_PID,a0
	movi	-1,a1
	calla	EXISTP
	jrz	dont_update_clock
	pushst
	dint
	push	a13
	move	a0,a13
	calla	update_timer
	movi	WGFS_W_P,a0
	calla	pal_getf
	move	*a13(PDATA+20h),a8,L	;10's image pointer
	move	a0,*a8(OPAL)
	move	*a13(PDATA),a8,L	;10's image pointer
	move	a0,*a8(OPAL)
	pull	a13
	popst
dont_update_clock

;Update the meters
	clr	a0
	MOVE	A0,@DAM_MULT
	callr	update_meter
	movk	1,a0
	callr	update_meter

	movi	[339h,0],a0
	move	a0,@WORLDTLX,L

	movi	[0ffd6h,0],a0
	move	a0,@WORLDTLY,L

         .ref	BGND_UD1
	calla	BGND_UD1

;Now display "round 2" or "round 3"

	CREATE0	ring_bell


	movk	1,a0
	move	a0,@HALT

	SLEEPK	1
	calla	BGND_UD1
	SLEEPK	1
	calla	BGND_UD1

	movk	16,a8
	movk	1,a9
	jsrp	OPEN_VERT_SCREEN_LINE

	CREATE0	DO_ROUNDS

	SLEEP	60
	CALLA	VINCE_START_ROUND2_3
	sleep	40

	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
	calla	obj_del1c		;delete text/plates

	movi	CLSNEUT|TYPTEXT|SUBTXT,a0
	calla	obj_del1c		;delete text/plates

	clr	a0
	move	a0,@HALT
	

	DIE


DO_ROUNDS
	movi	[200,0],a0			;x pos
	movi	[255,0],a1			;y pos
	movi	RNDPLAT,a2
	movi	RNDPLT_P,b0
	movi	1800h,a3				;z pos
	callr	#begin_obj
	PUSH	A8

	move	@current_round,a0
	MOVI	RNDNUM_1,A2
	DEC	A0
	JRZ	#OKAY
	MOVI	RNDNUM_2,A2
	DEC	A0
	JRZ	#OKAY
	MOVI	RNDNUM_3,A2
	DEC	A0
	JRZ	#OKAY
	MOVI	RNDNUM_4,A2
#OKAY
	movi	[200,0],a0			;x pos
	movi	[255,0],a1			;y pos
	movi	RNDNUM_P,b0
	movi	1801h,a3				;z pos
	callr	#begin_obj
	PULL	A9

	MOVK	20,A10
LOOP_ROUNDS_ON
	MOVI	[190,0],A0
	CALLR	ZIP_ROUNDS_ON
	SLEEP	1
	DSJS	A10,LOOP_ROUNDS_ON
	SLEEP	40
	MOVK	20,A10
LOOP_ROUNDS_OFF
	MOVI	[300,0],A0
	CALLR	ZIP_ROUNDS_ON
	SLEEP	1
	DSJS	A10,LOOP_ROUNDS_OFF
	DIE

ZIP_ROUNDS_ON
	move	*a8(OYVAL),a1,L
	sub	a1,a0
	sra	3,a0
	move	*a8(OYVAL),a2,L
	add	a0,a2
	move	a2,*a8(OYVAL),L
	move	*a9(OYVAL),a2,L
	add	a0,a2
	move	a2,*a9(OYVAL),L
	RETS

#ln_nm1_setup
	JAM_STR	sgmd8_ascii,5,0,200,40h-10,SGMD8WHT2,0

#ln_nm2_setup
	JAM_STR	sgmd8_ascii,5,0,200,4bh-10,SGMD8WHT2,0

#ln_rnd_setup
	.ref	font9_ascii
	JAM_STR	font9_ascii,5,0,200,43h-10,FNT9WHT_P,0

#ln1_t	.long	#bh_ln1,#rr_ln1,#un_ln1,#yo_ln1
	.long	#sm_ln1,#bb_ln1,#do_ln1,#ll_ln1
	.long	#ll_ln1
#ln2_t	.long	#bh_ln1,#rr_ln1,#un_ln1,#yo_ln1
	.long	#sm_ln1,#bb_ln1,#do_ln1,#ll_ln1
	.long	#ll_ln1

#bh_ln1	.string	"BRET HART",0
#rr_ln1	.string	"RAZOR RAMON",0
#un_ln1	.string	"THE UNDERTAKER",0
#yo_ln1	.string	"YOKOZUNA",0
#sm_ln1	.string	"SHAWN MICHAELS",0
#bb_ln1	.string	"BAM BAM BIGELOW",0
#do_ln1	.string	"DOINK THE CLOWN",0
#ll_ln1	.string	"LEX LUGER",0

#rnd1	.string	"WINS ROUND ONE",0
#rnd2	.string	"WINS ROUND TWO",0
#rnd3	.string	"WINS THE MATCH",0

#rnd_2	.string	"ROUND   2",0
#rnd_3	.string	"ROUND   3",0

	.even


announce_winner
	
	.if	0

	SLEEP	90

	movi	[252h,0],a0			;x pos
	movi	[2Eh,0],a1			;y pos
	movi	MTCHPLT,a2
	movi	MPLTPRPP,b0
	movi	1200,a3				;z pos
	callr	#begin_obj
	move	a8,*a13(IPTR_PLATE),L

	xori	1,a10
	X32	a10
	addi	process_ptrs,a10
	move	*a10,a10,L
	move	*a10(WRESTLERNUM),a10
	X32	a10
	movi	name_tbl,a2
	add	a10,a2
	move	*a2,a2,L

	movi	[252h,0],a0			;x pos
	movi	[46h,0],a1			;y pos
	movi	TEXT_P,b0
	movi	1202,a3				;z pos
	callr	#begin_obj
	move	a8,*a13(IPTR_TEXT),L

	movi	[252h,0],a0			;x pos
	movi	[54h,0],a1			;y pos
	movi	wins_txt,a2
	movi	TEXT_P,b0
	movi	1202,a3				;z pos
	callr	#begin_obj
	move	a8,*a13(IPTR_TEXT2),L

	movi	>b6,a0
	calla	triple_sound

	movi	30h,a10
#onscr_loop2

	SLEEPK	1

	movi	[200,0],a0
	movk	3,a11
	callr	#set_x

	dsj	a10,#onscr_loop2

;In middle

;Wait for wrestlers to scramble into position
	SLEEP	3*60

	movi	>b6,a0
	calla	triple_sound

	movi	23h,a10

#offscr_loop2

	SLEEPK	1

	movi	[0fec0h,0],a0
	movk	3,a11
	callr	#set_x

	dsj	a10,#offscr_loop2

	move	*a13(IPTR_PLATE),a0,L
	calla	DELOBJ
	move	*a13(IPTR_TEXT),a0,L
	calla	DELOBJ
	move	*a13(IPTR_TEXT2),a0,L
	calla	DELOBJ

	clr	a0
	move	a0,@HALT
	.endif

	DIE

#set_x
	movi	ram_lst,a11
	move	*a11,a8,L
	move	*a8(OXVAL),a1,L
	sub	a1,a0
	sra	3,a0
#lp5
	move	*a11+,a8,L
	jrz	#x4
;	move	a0,*a8(OXVEL),L
	move	*a8(OXVAL),a2,L
	add	a0,a2
	move	a2,*a8(OXVAL),L

	jruc	#lp5
#x4
	rets

#begin_obj

	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	CLSNEUT|TYPTEXT|SUBTXT,a5
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJP
	rets

blink_text
	SLEEPK	10
#lp1
	movi	SGMD8RED2,a0
	calla	pal_getf
	move	a0,*a8(OPAL)
	SLEEPK	4
	movi	SGMD8WHT2,a0
	calla	pal_getf
	move	a0,*a8(OPAL)
	SLEEPK	7
	jruc	#lp1


DO_SNAP_MESS
	MOVE	@SNAP_COUNT,A0
	INC	A0
	MOVE	A0,@SNAP_COUNT
	CMPI	SNAP_LIMIT,A0
	JRGE	NO_NORE_MESS
	MOVI	SNAPMIRR,A8

DO_THIS_MESS
	MOVE	*A13(PLYRNUM),A9
	CALLA	MAKE_PLAYER_NUMBER_RIGHT
	MOVI	MESSAGES_PID,A0
	ADD	A9,A0
	MOVI	-1,A1
	CALLA	EXISTP
	JRNZ	NO_NORE_MESS
	INC	A9
	CLR	A10
	MOVI	1801H,A11

	MOVI	MESSAGES_PID,A1
	ADD	A9,A1
	MOVI	SPECIAL_MESSAGE,A7
	CALLA	GETPRC

	MOVI	0BBH,A0
	CALLA	triple_sound
NO_NORE_MESS
	RETS

DO_HEAD_MESS
	MOVE	@HEAD_COUNT,A0
	INC	A0
	MOVE	A0,@HEAD_COUNT
	CMPI	HEAD_LIMIT,A0
	JRGE	NO_NORE_MESS
	MOVI	HEADSLAM,A8
	JRUC	DO_THIS_MESS

DO_GERM_MESS
	MOVE	@GERM_COUNT,A0
	INC	A0
	MOVE	A0,@GERM_COUNT
	CMPI	GERM_LIMIT,A0
	JRGE	NO_NORE_MESS
	MOVI	GERMSUPL,A8
	JRUC	DO_THIS_MESS

DO_FRANK_MESS
	MOVE	@FRANK_COUNT,A0
	INC	A0
	MOVE	A0,@FRANK_COUNT
	CMPI	FRANK_LIMIT,A0
	JRGE	NO_NORE_MESS
	MOVI	FRANKEN,A8
	JRUC	DO_THIS_MESS

DO_BACK_MESS
	MOVE	@BACK_COUNT,A0
	INC	A0
	MOVE	A0,@BACK_COUNT
	CMPI	BACK_LIMIT,A0
	JRGE	NO_NORE_MESS
	MOVI	BACKBRKR,A8
	JRUC	DO_THIS_MESS

DO_BODY_MESS
	MOVE	@BODY_COUNT,A0
	INC	A0
	MOVE	A0,@BODY_COUNT
	CMPI	BODY_LIMIT,A0
	JRGE	NO_NORE_MESS
	MOVI	BODYSLAM,A8
	JRUC	DO_THIS_MESS

DO_PILE_MESS
	MOVE	@PILE_COUNT,A0
	INC	A0
	MOVE	A0,@PILE_COUNT
	CMPI	PILE_LIMIT,A0
	JRGE	NO_NORE_MESS
	MOVI	PILEDRV,A8
	JRUC	DO_THIS_MESS

DO_REVERSAL_MESS
	MOVE	*A10(PLYRNUM),A9
	CALLA	MAKE_PLAYER_NUMBER_RIGHT
	CREATE0	CREATE_REVERSAL_MESS
	RETS

CREATE_REVERSAL_MESS
	MOVK	2,A0
	MOVE	A0,@DAM_MULT

	MOVI	REVERS,A8
	CLR	A10
	MOVI	1801H,A11

	MOVI	MESSAGES_PID,A1
	ADD	A9,A1
	MOVI	SPECIAL_MESSAGE,A7
	INC	A9
	CALLA	GETPRC

	MOVI	0BBH,A0
	CALLA	triple_sound

	SLEEP	50

	MOVI	xDAMAGE,A8
	MOVI	2,A10
	MOVI	1803H,A11

	DEC	A9
	MOVI	MESSAGES_PID,A1
	ADD	A9,A1
	MOVI	SPECIAL_MESSAGE,A7
	INC	A9
	CALLA	GETPRC

	DIE

BONUS_MESS
	CREATE0	DO_BONUS_MESS
	RETS

DO_BONUS_MESS
	MOVE	*A10(PLYRNUM),A9
	CALLA	MAKE_PLAYER_NUMBER_RIGHT
	MOVI	HIGHRISK,A8
	CLR	A10
	MOVI	1801H,A11

	MOVI	MESSAGES_PID,A1
	ADD	A9,A1
	MOVI	SPECIAL_MESSAGE,A7
	INC	A9
	CALLA	GETPRC

	MOVI	0BBH,A0
	CALLA	triple_sound

	SLEEP	50

	MOVI	xDAMAGE,A8
	MOVI	2,A10
	MOVI	1803H,A11

	DEC	A9
	MOVI	MESSAGES_PID,A1
	ADD	A9,A1
	MOVI	SPECIAL_MESSAGE,A7
	INC	A9
	CALLA	GETPRC

	DIE

DO_COMBO_MESS
	MOVE	@HAVE_WE_AUDITED_THIS_GAME,A0
	JRNZ	YES_WE_HAVE
	movi	AUD_COMBO,A0
	calla	AUD1
	MOVK	1,A0
	MOVE	A0,@HAVE_WE_AUDITED_THIS_GAME
YES_WE_HAVE
	MOVI	0BAH,A0
	CALLA	triple_sound

	MOVE	*A13(PLYRNUM),A9
	MOVI	HITCOMBO,A8
	MOVE	*A13(COMBO_COUNT),A10
	CMPI	2,A10
	JRLT	NO_MESSAGE

;Add a couple for a better appearance!
	addk	2,a10

	MOVI	1803H,A11

	CALLA	MAKE_PLAYER_NUMBER_RIGHT

	MOVI	MESSAGES_PID,A1
	ADD	A9,A1
	MOVI	SPECIAL_MESSAGE,A7
	INC	A9
	CALLA	GETPRC
NO_MESSAGE
	RETS


MAKE_PLAYER_NUMBER_RIGHT
	CMPI	2,A9
	JRLT	WE_ARE_ALREADY_CORRECT
	MOVE	@PSTATUS,A9
	DEC	A9
	NOT	A9
	ANDI	1,A9
WE_ARE_ALREADY_CORRECT
	RETS

ZIP_SPEED	.EQU	18H
BUFF		.EQU	25
;A8=IMAGE TO PLACE UP
;A9=WHICH SIDE (1 OR 2)
;A10=NUMBER OF BONUS MULTIPLIER 2-5 (IF NECESSARY)
;A11=ZPOS TO PLACE BLOCK (SO DAMAGE x GOES OVER OTHER)
SPECIAL_MESSAGE
	MOVI	10H,A0
	CALLA	triple_sound
	MOVE	A11,B5
	CLR	A11
	MOVE	A8,A2
	MOVE	*A2(ISIZEX),A3
	CMPI	xDAMAGE,A2
	JREQ	SPECIAL_CASE_THIS
	CMPI	HITCOMBO,A2
	JRNE	ONLY_THIS_SIZE
SPECIAL_CASE_THIS
	ADDI	19,A3
	MOVE	A10,A0
	CALLA	BINBCD
	MOVE	A0,A10
	MOVE	A10,A11
	SRL	4,A11
	JRZ	ONLY_THIS_SIZE
	MOVI	HITCOMBO2,A2
	ADDI	21,A3
	CMPI	1,A11
	JRNE	ONLY_THIS_SIZE
	SUBI	4,A3
ONLY_THIS_SIZE
	MOVI	TYPE_MESS2,A5
	ADDI	BUFF*2,A3
	MOVI	410,A0
	MOVE	A0,A7
	SUB	A3,A7
	SLL	16,A7
	DEC	A9
	JRNZ	WE_SET_XPOS
	MOVI	TYPE_MESS1,A5
	MOVE	A3,A0
	NEG	A0
	MOVI	[BUFF,0],A7
	ADDK	BUFF,A0
WE_SET_XPOS
	SLL	16,A0
	MOVE	A0,*A13(PDATA+120H),L
	MOVE	A7,*A13(PDATA+100H),L
	MOVI	[230,0],A1
	MOVE	B5,A3
	ADDK	1,A3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags

	CLR	A6
	CLR	A7
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9,A10
	calla	BEGINOBJ
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9,A10
	PUSH	A8

	MOVI	WHICH_BONUS_2,A14
	CMPI	xDAMAGE,A2
	JREQ	WE_HAVE_NUMBERS
	CMPI	HITCOMBO,A2
	JREQ	WE_HAVE_NUMBERS
	MOVI	WHICH_BONUS_1,A14
	CMPI	HITCOMBO2,A2
	JRNE	NO_NEED_FOR_THIRD_OBJ
WE_HAVE_NUMBERS
	SLL	32-4,A10
	SRL	32-4-5,A10		;*32
	ADD	A14,A10
	MOVE	*A10,A2,L
	MMTM	SP,A0,A1,A3,A4,A5,A6,A7,A11
	calla	BEGINOBJ
	MMFM	SP,A0,A1,A3,A4,A5,A6,A7,A11
	MOVE	A8,A10

	MOVE	A11,A7
	SLL	32-4,A7
	JRZ	NO_NEED_FOR_THIRD_OBJ
	SRL	32-4-5,A7		;*32
	ADDI	WHICH_BONUS_2,A7
	MOVE	*A7,A2,L
	CLR	A7
	MMTM	SP,A0,A1,A5,A6,A7
	CMPI	1,A11
	JRNE	NO_REPOS_THIS_NUM
	ADDI	[4,0],A0
NO_REPOS_THIS_NUM
	calla	BEGINOBJ
	MMFM	SP,A0,A1,A5,A6,A7
	MOVE	A8,A11
NO_NEED_FOR_THIRD_OBJ

	MOVE	*A8(OSIZEX),A2
	MOVI	395,A3
	SUB	A2,A3
	SUBI	BUFF,A3
	SLL	16,A0
	SUB	A3,A0
	MOVI	MVEBAR_B,A2
	movi	DMAWNZ|M_FLIPH|M_3D|M_SCRNREL,a4	;DMA flags
	MOVE	A9,A9
	JRZ	BAR_SET
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	MOVI	MVEBAR_R,A2
	MOVE	*A8(OXVAL),A0,L
	SUBI	[BUFF,0],A0
BAR_SET
	MOVE	B5,A3
	calla	BEGINOBJ
	MOVE	A8,A9
	PULL	A8

	MOVI	ZIP_SPEED,A3
MOVE_IT_ON
	MOVE	*A13(PDATA+100H),A0,L
	CALLR	MOVE_BARS
	PUSHP	A3
	SLEEPK	1
	PULLP	A3
	DSJS	A3,MOVE_IT_ON

	SLEEP	50

	MOVI	ZIP_SPEED,A3
MOVE_IT_OFF
	MOVE	*A13(PDATA+120H),A0,L
	SLA	1,A0
	CALLR	MOVE_BARS
	PUSHP	A3
	SLEEPK	1
	PULLP	A3
	DSJS	A3,MOVE_IT_OFF

	CALLA	DELOBJA8
	MOVE	A9,A8
	CALLA	DELOBJA8
	MOVE	A10,A8
	JRZ	NO_A10_3
	CALLA	DELOBJA8
NO_A10_3
	MOVE	A11,A8
	JRZ	NO_A11_3
	CALLA	DELOBJA8
NO_A11_3
	DIE

MOVE_BARS
	PUSH	A8
	MOVE	*A8(OXVAL),A1,L
	SUB	A1,A0
	SRA	3,A0

	CALLR	MOVE_THIS_PART
	MOVE	A9,A8
	JRZ	NO_A11_PART
	CALLR	MOVE_THIS_PART
	MOVE	A10,A8
	JRZ	NO_A10_PART
	CALLR	MOVE_THIS_PART
NO_A10_PART
	MOVE	A11,A8
	JRZ	NO_A11_PART
	CALLR	MOVE_THIS_PART
NO_A11_PART
	PULL	A8
	RETS

MOVE_THIS_PART
	MOVE	*A8(OXVAL),A2,L
	ADD	A0,A2
	MOVE	A2,*A8(OXVAL),L
	RETS

WHICH_BONUS_2
	.LONG	X0X,X1X,X2X
	.LONG	X3X,X4X,X5X
	.LONG	X6X,X7X,X8X
	.LONG	X9X

WHICH_BONUS_1
	.LONG	X0X2,X1X2,X2X2
	.LONG	X3X2,X4X2,X5X2
	.LONG	X6X2,X7X2,X8X2
	.LONG	X9X2

Z_FORWARD	.EQU	1800H
ZFLIP_POS	.EQU	0D8000H

SHIFT_BARS_IN_Z
	CLR	A0
	MOVE	A0,@LAST_FLIP
SHIFT_BARS_IN_Z_MOTION
	MOVE	@WORLDTLY,A0,L
	CMPI	ZFLIP_POS,A0
	JRLT	CHECK_IF_WE_ALREADY_FLIPPED_BACK

	MOVE	@LAST_FLIP,A0
	JRNZ	YES_WE_DID
	MOVK	1,A0
	MOVE	A0,@LAST_FLIP
	CALLR	SHIFT_BARS_FORWARD
	SLOOP	4,SHIFT_BARS_IN_Z_MOTION

CHECK_IF_WE_ALREADY_FLIPPED_BACK
	MOVE	@LAST_FLIP,A0
	JRZ	YES_WE_DID
	CLR	A0
	MOVE	A0,@LAST_FLIP
	CALLR	SHIFT_BARS_BACK
YES_WE_DID
	SLOOP	4,SHIFT_BARS_IN_Z_MOTION

SHIFT_BARS_FORWARD
	movi	OBJLST,a8
	JRUC	DONT_SHIFT_IT_FORWARD
STILL_MORE_TO_CHECK
	MOVE	*A8(OZPOS),A1
	CMPI	bak_z,A1
	JREQ	SHIFT_IT_FORWARD
	CMPI	bar_z,A1
	JREQ	SHIFT_IT_FORWARD
	CMPI	frame_z,A1
	JREQ	SHIFT_IT_FORWARD
	CMPI	name_z,A1
	JRNE	DONT_SHIFT_IT_FORWARD
SHIFT_IT_FORWARD
	ADDI	Z_FORWARD,A1
	MOVE	A1,*A8(OZPOS)
DONT_SHIFT_IT_FORWARD
	MOVE	*A8,A8,L
	JRNZ	STILL_MORE_TO_CHECK
	RETS

SHIFT_BARS_BACK
	movi	OBJLST,a8
	JRUC	DONT_SHIFT_IT_BACK
STILL_MORE_TO_CHECK_B
	MOVE	*A8(OZPOS),A1
	CMPI	bak_z+Z_FORWARD,A1
	JREQ	SHIFT_IT_BACK
	CMPI	bar_z+Z_FORWARD,A1
	JREQ	SHIFT_IT_BACK
	CMPI	frame_z+Z_FORWARD,A1
	JREQ	SHIFT_IT_BACK
	CMPI	name_z+Z_FORWARD,A1
	JRNE	DONT_SHIFT_IT_BACK
SHIFT_IT_BACK
	SUBI	Z_FORWARD,A1
	MOVE	A1,*A8(OZPOS)
DONT_SHIFT_IT_BACK
	MOVE	*A8,A8,L
	JRNZ	STILL_MORE_TO_CHECK_B
	RETS


END_BUFF	.equ	10
END_POS	.EQU	30
END_YPOS	.EQU	80
TURM_OFF	.EQU	4

WHICH_ROUND
	.LONG	FIRSTFAL,SECNDFAL,MATCHFAL

CREATE_END_ROUND_TOP
	SLL	5,A9
	ADDI	WHICH_ROUND,A9
	MOVE	*A9,A2,L

	CLR	A1
	MOVE	A1,*A13(PDATA+140),L

	MOVI	[END_POS+150+TURM_OFF,0],A1
	MOVI	[400+END_BUFF+150+TURM_OFF,0],A0
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	MOVE	A11,A11
	JRNZ	WHICH_TEXT_SET
	MOVI	[400-END_POS-150,0],A1
	MOVI	[0-END_BUFF-150,0],A0
WHICH_TEXT_SET
	MOVE	A1,*A13(PDATA+100H),L
	MOVI	[END_YPOS,0],A1
	MOVI	1803H,A3
	MOVI	CLSNEUT|TYPTEXT|SUBMES1,A5
	CLR	A6
	CLR	A7
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7
	calla	BEGINOBJ
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7
	MOVE	A8,A9

	MOVI	[END_POS+TURM_OFF,0],A1
	MOVI	[400+END_BUFF+TURM_OFF,0],A0
	MOVI	MVEBAR_R,A2
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	MOVE	A11,A11
	JRNZ	WHICH_BAR_SET
	MOVI	[400-END_POS,0],A1
	MOVI	[0-END_BUFF,0],A0
	movi	DMAWNZ|M_FLIPH|M_3D|M_SCRNREL,a4	;DMA flags
	MOVI	MVEBAR_B,A2
WHICH_BAR_SET
	MOVE	A1,*A13(PDATA+120H),L
	MOVI	[END_YPOS,0],A1
	MOVI	1800H,A3
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9
	calla	BEGINOBJ
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9
	CLR	A0
	MOVE	A0,*A13(PDATA+140H),L
	JSRP	ZIP_HIM_ON
	DIE

WHICH_WRESTLE_NAME
	.LONG	BIGHRT
	.LONG	BIGRAZ
	.LONG	BIGUND
	.LONG	BIGYOK
	.LONG	BIGSHN
	.LONG	BIGBAM
	.LONG	BIGDNK
	.LONG	0
	.LONG 	BIGLEX

CREATE_END_ROUND_BOT
	MOVE	*A10(WRESTLERNUM),A2
	SLL	5,A2
	ADDI	WHICH_WRESTLE_NAME,A2
	MOVE	*A2,A2,L

	MOVI	[END_POS+150+TURM_OFF,0],A1
	MOVI	[400+END_BUFF+150+TURM_OFF,0],A0
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	MOVE	A11,A11
	JRNZ	ON_LEFT
	MOVI	[400-END_POS-150,0],A1
	MOVI	[0-END_BUFF-150,0],A0
ON_LEFT
	MOVE	A1,*A13(PDATA+100H),L
	MOVI	[END_YPOS+25,0],A1
	MOVI	1802H,A3
	MOVI	CLSNEUT|TYPTEXT|SUBMES1,A5
	CLR	A6
	CLR	A7
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7
	calla	BEGINOBJ
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7
	MOVE	A8,A9

	MOVI	[END_POS+TURM_OFF,0],A1
	MOVI	AWDNMPL_R,A2
	MOVI	[400+END_BUFF+TURM_OFF,0],A0
	MOVE	A11,A11
	JRNZ	ON_LEFT2
	MOVI	[400-END_POS,0],A1
	MOVI	[0-END_BUFF,0],A0
	MOVI	AWDNMPL_B,A2
	movi	DMAWNZ|M_FLIPH|M_3D|M_SCRNREL,a4	;DMA flags
ON_LEFT2
	MOVE	A1,*A13(PDATA+120H),L
	MOVE	A1,*A13(PDATA+140H),L
	MOVI	[END_YPOS,0],A1
	DEC	A3
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9
	calla	BEGINOBJ
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9

	PUSH	A8
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	MOVI	DIAGLGO_R,A2
	MOVE	A11,A11
	JRNZ	ON_LEFT3
	MOVI	DIAGLGO_B,A2
ON_LEFT3
	INC	A3
	calla	BEGINOBJ
	MOVE	A8,A10
	PULL	A8
	JSRP	ZIP_HIM_ON
	DIE

ZIP_HIM_ON
	MOVI	ZIP_SPEED,A3
MOVE_END_ON
	MOVE	*A13(PDATA+140H),A0,L
	JRZ	NOTHING_IN_A10
	PUSH	A8
	MOVE	A10,A8
	CALLR	MOVE_THIS
	PULL	A8
NOTHING_IN_A10
	MOVE	*A13(PDATA+100H),A0,L
	JRZ	NOTHING_IN_A9
	PUSH	A8
	MOVE	A9,A8
	CALLR	MOVE_THIS
	PULL	A8
NOTHING_IN_A9
	MOVE	*A13(PDATA+120H),A0,L
	CALLR	MOVE_THIS
	PUSHP	A3
	SLEEPK	1
	PULLP	A3
	DSJS	A3,MOVE_END_ON
	RETP

MOVE_THIS
	MOVE	*A8(OXVAL),A1,L
	SUB	A1,A0
	SRA	3,A0
	JRUC	MOVE_THIS_PART


END_IPOS1	.EQU	332
END_IPOS2	.EQU	292
END_IYPOS	.EQU	54

CREATE_END_ROUND_ICON

	MOVI	[END_IPOS1+30,0],B4
	MOVI	[400-END_IPOS1-30,0],B5
	MOVI	[END_IPOS1,0],B6
	MOVI	[400-END_IPOS1,0],B7

	MOVE	@p1rounds,a1
	MOVE	A11,A11
	JRZ	GOT_RIGHT_SIDE
	MOVE	@p2rounds,a1
GOT_RIGHT_SIDE
	DEC	A1
	JRZ	DO_THE_RIGHT_ROUND

	MOVI	[END_IPOS2+30,0],B4
	MOVI	[400-END_IPOS2-30,0],B5
	MOVI	[END_IPOS2,0],B6
	MOVI	[400-END_IPOS2,0],B7
DO_THE_RIGHT_ROUND

	CLR	A1
	MOVE	A1,*A13(PDATA+140),L

	MOVI	WWFICON10,A2
	MOVE	B4,A1
	MOVI	[400+END_BUFF+150,0],A0
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	MOVE	A11,A11
	JRNZ	WHICH_ICON_SET
	MOVE	B5,A1
	MOVI	[0-END_BUFF-150,0],A0
WHICH_ICON_SET
	MOVE	A1,*A13(PDATA+100H),L
	MOVI	[END_IYPOS,0],A1
	MOVI	1801H,A3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4		;DMA flags
	CLR	A5
	CLR	A6
	CLR	A7
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9
	calla	BEGINOBJ
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9
	MOVE	A8,A9

	MOVE	B6,A1
	MOVI	[400+END_BUFF,0],A0
	MOVI	MVEBAR_R,A2
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	MOVE	A11,A11
	JRNZ	WHICH_BAR2_SET
	MOVE	B7,A1
	MOVI	[0-END_BUFF,0],A0
	movi	DMAWNZ|M_FLIPH|M_3D|M_SCRNREL,a4	;DMA flags
	MOVI	MVEBAR_B,A2
WHICH_BAR2_SET
	MOVE	A1,*A13(PDATA+120H),L
	MOVE	A0,*A13(PDATA+160H),L
	MOVI	[END_IYPOS,0],A1
	MOVI	1800H,A3
	MOVI	CLSNEUT|TYPTEXT|SUBMES1,A5
	CLR	A6
	CLR	A7
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7
	calla	BEGINOBJ
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7

	JSRP	ZIP_HIM_ON
	SLEEP	20
	MOVI	ICON_PID,A1
	ADD	A11,A1
	CALLA	FIND_ANY_OTHERS
	MOVI	4DH,A0
	CALLA	triple_sound
	MOVI	MAKE_ICON_GLOW,A7
	CALLA	GETPRC
	MOVE	A9,A11
	CLR	A9
	MOVE	A9,*A13(PDATA+100),L
	MOVE	*A13(PDATA+160H),*A13(PDATA+120H),L
	JSRP	ZIP_HIM_ON

	MOVE	A11,A8

	CREATE0	MAYBE_A_SPARKLE
	DIE

MAKE_ICON_GLOW
	MOVE	A9,A8
	MOVI	WWF_ICON_ANIM,A1
	CALLA	setup_back_anim
	JSRP	ANIM_CROWD
	SLEEP	TSEC*10
	JRUC	MAKE_ICON_GLOW

FIND_ANY_OTHERS
	PUSH	A1
	MOVE	A1,A0
	MOVI	-1,A1
	CALLA	EXISTP
	JRZ	NO_MORE
	MOVK	1,A1
	MOVE	A1,*A0(PTIME)
NO_MORE
	PULL	A1
	RETS

CANI_END		equ	2 + 8000H

WWF_ICON_ANIM
	WL	2,WWFICON01
	WL	2,WWFICON02
	WL	2,WWFICON03
	WL	2,WWFICON04
	WL	2,WWFICON05
	WL	2,WWFICON06
	WL	2,WWFICON07
	WL	2,WWFICON08
	WL	2,WWFICON09
	WL	2,WWFICON10
	.WORD	CANI_END

MAYBE_A_SPARKLE
	MOVI	120,A0
	CALLA	RNDRNG0
	ADDI	50,A0
	CALLA	PRCSLP
	CREATE0	ICON_SPARKLE
	JRUC	MAYBE_A_SPARKLE

ICON_SPARKLE

	MOVK	6,A0
	CALLA	RNDRNG0
	SLL	5,A0
	ADDI	WHERE_SPARKLE,A0
	MOVE	A0,A2

	MOVE	*A8(OXPOS),A0
	MOVE	*A2,A14
	ADD	A14,A0
	
	MOVE	*A8(OYPOS),A1
	MOVE	*A2(10H),A14
	ADD	A14,A1

	SLL	16,A0
	SLL	16,A1
	MOVI	SPRKLA01,A2
	MOVI	1802H,A3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	;DMA flags
	CLR	A5
	CLR	A6
	CLR	A7
	CALLA	BEGINOBJ

	MOVK	2,A0
	CALLA	RNDRNG0
	SLL	5,A0
	ADDI	WHICH_SPARKLE,A0
	MOVE	*A0,A1,L
	calla	setup_back_anim
	JSRP	ANIM_CROWD
	CALLA	DELOBJA8
	DIE


WHICH_SPARKLE
	.LONG	SPARKLE_1
	.LONG	SPARKLE_2
	.LONG	SPARKLE_3

WHERE_SPARKLE
	.LONG	[-8,-14]
	.LONG	[8,-9]
	.LONG	[-1,8]
	.LONG	[0,15]
	.LONG	[-9,19]
	.LONG	[-10,2]
	.LONG	[-1,-6]

SPARKLE_1
	WL	2,SPRKLA01
	WL	2,SPRKLA02
	WL	2,SPRKLA03
	WL	2,SPRKLA04
	WL	2,SPRKLA05
	WL	2,SPRKLA06
	WL	2,SPRKLA07
	WL	2,SPRKLA08
	WL	2,SPRKLA09
	WL	2,SPRKLA10
	WL	2,SPRKLA11
	WL	2,SPRKLA12
	WL	2,SPRKLA13
	.WORD	CANI_END

SPARKLE_2
	WL	2,SPRKLB01
	WL	2,SPRKLB02
	WL	2,SPRKLB03
	WL	2,SPRKLB04
	WL	2,SPRKLB05
	WL	2,SPRKLB06
	WL	2,SPRKLB07
	WL	2,SPRKLB08
	WL	2,SPRKLB09
	WL	2,SPRKLB10
	WL	2,SPRKLB11
	WL	2,SPRKLB12
	WL	2,SPRKLB13
	.WORD	CANI_END

SPARKLE_3
	WL	2,SPRKLC01
	WL	2,SPRKLC02
	WL	2,SPRKLC03
	WL	2,SPRKLC04
	WL	2,SPRKLC05
	WL	2,SPRKLC06
	WL	2,SPRKLC07
	WL	2,SPRKLC08
	WL	2,SPRKLC09
	WL	2,SPRKLC10
	WL	2,SPRKLC11
	WL	2,SPRKLC12
	WL	2,SPRKLC13
	.WORD	CANI_END


******************************************************************************
	.end

