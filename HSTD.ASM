***************************************************************
*
* Software:	LARRY DeMAR, EUGENE JARVIS
* Modified:	Shawn Liptak 8/6/91 	- Multi color fonts
*		Jason Skiles 12/14/93	- Use STRING.ASM calls
*		Jason Skiles 1/17/94	- Hold most recent index in CMOS
*
* COPYRIGHT (C) 1991 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 1/17/94 11:59
****************************************************************

	.file	"hstd.asm"
	.title	"robo high-score-to-date management"
	.width	132
	.option	b,d,l,t
	.mnolist

	.include	"audit.equ"
	.include	"mproc.equ"
	.include	"display.equ"
	.include	"sys.equ"
	.include	"game.equ"
	.include	"link.equ"
	.include	"macros.h"
	.include	"plyr.equ"
	.include	"gsp.equ"

	.include	"crowdimg.glo"
	.include	"fontsimg.glo"
	.include	"bgndtbl.glo"
	.include	"miscimg.glo"
	.include	"ropeimg.glo"
	.include	"sound.h"

	.TEXT

; - confine cursor to end and del once all inits are in

*	IN THIS MODULE
 

	.DEF	GET_HSCR
	.DEF	RC_BYTEI
	.DEF	RC_BYTE
	.DEF	RC_WORD
	.DEF	RC_LONG
	.DEF	RC_LONGI
	.DEF	WC_BYTE
	.DEF	WC_BYTEI
	.DEF	WC_WORD
	.DEF	WC_WORDI
	.DEF	WC_LONG
	.DEF	WC_LONGI
	.DEF	PT_ENTRY
	.DEF	INIT_TB
	.DEF	INIT_TAB	;GEORGES POWER UP ENTRY
	.DEF	P_FORK
	.DEF	VAL_TAB
	.DEF	ROM_PTRS
	.DEF	BEATEN_TAB_ENTRIES
	.DEF	INTER_TAB_ENTRIES
	.DEF	TAG_TAB_ENTRIES

	.DEF	INTER_TAB
	.DEF	TAG_TAB

	.DEF	STREAK_TAB
	.DEF	BEATEN_TAB
	.DEF	DO_BEATEN_GAME
;	.DEF	ISHSTD,GETINIT,GETINIT1,GETINIT2,INITTIM
	.DEF	SET_PAGE
;	.DEF	A2_CHECK
	.DEF	DEC_HSR,INIT_HSR,GET_HSC
	.def	not_blank

******************************************************************************
* EXTERNAL REFERENCES

	.ref	ADD_VOICE,message_palette,get_but_val_down,dec_to_asc
	.ref	dec_to_asc_new_entry,MATCH_TIMERS,civanic,GET_ADJ
	.ref	which_player,mess_z,ANIM_CROWD,DEF_PAGE,print_message
	.ref	message_buffer,howard_wins,GET_AUD,RNDRNG0,mess_line_spacing
	.ref	pal_getf,AUD,BEGINOBJ_TBL,print_string_C2,SHADOW01
	.ref	SHADOW02,mess_space_width,SPEAR,mess_objid,print_string_R
	.ref	BINBCD,message_ascii,get_stick_val_cur,p1oldwinstreak
	.ref	mess_spacing,mess_cursx,print_string,mess_cursy
	.ref	print_string_with_z,setup_message,KILL_AUD,osgemd_ascii
	.ref	get_stick_val_down,setup_back_anim,font9_ascii,CYCLE_TABLE
	.ref	BCDBIN,copy_string,IGNORE_CHAR_WIDTH,message_buffer2
	.ref	triple_sound,change_image,digits_tbl,wsf14_ascii
	.ref	p2oldwinstreak,print_string2,current_round
	.ref	mess_cursx2,font9A_ascii
	.ref	font18_ascii
	.ref	print_string_C,belt_type
	.if 0
	.ref	prog_specials,are_special_inits
	.endif


******************************************************************************

	 .TEXT

;Sound headers

BEEPSND	 .WORD	>F3FE,>10,>80A2,0		;LOW BEEP


	BSSX	starting_num,16
	BSSX	entered_inits,		(8*6)*2
;	.bss	entered_message,	(16*4)*2
	.bss	last_hscore_ndx,	16
	.bss	last_streak_ndx,	16
	.bss	not_blank,16
	BSSX	auto_init,16

**************************************************************************
*
*	HIGH SCORE TABLE DEFINITIONS
*
**************************************************************************

STREAK_TABLE_VISIBLE	equ	18
PIN_SPEED_TAB_VISIBLE	equ	9
BEATEN_TAB_VISIBLE	equ	30
INTER_TAB_VISIBLE	equ	30
TAG_TAB_VISIBLE		EQU	18

STREAK_TAB
	.LONG	STREAK_TABLE_ORIGIN 	;LOCATION OF TABLE
	.WORD	STREAK_TABLE_ENTRIES-1	;NUMBER IN THE TABLE (DON'T COUNT ZERO FILLER)
	.WORD	STREAK_TABLE_VISIBLE	;unused?
	.WORD	STREAK_TABLE_SELECT 	;BITS TO SELECT IT
	.LONG	STREAK_ROM_TABLE	;ROM IMAGE OF TABLE
	.WORD	STREAK_TABLE_ENTRIES/5	;RESET TABLE IF 1/5 OR MORE BAD

 SUBR	PIN_SPEED_TAB
	.LONG	PIN_SPEED_TAB_ORIGIN	;LOCATION OF TABLE
	.WORD	PIN_SPEED_TAB_ENTRIES-1	;NUMBER IN THE TABLE (DON'T COUNT ZERO FILLER)
	.WORD	PIN_SPEED_TAB_VISIBLE	;unused ?
	.WORD	PIN_SPEED_TAB_SELECT	;BITS TO SELECT IT
	.LONG	PIN_SPEED_TAB_ROM_TABLE	;ROM IMAGE OF TABLE
	.WORD	PIN_SPEED_TAB_ENTRIES/5	;RESET TABLE IF 1/5 OR MORE BAD


BEATEN_TAB
	.LONG	BEATEN_TAB_ORIGIN 	;LOCATION OF TABLE
	.WORD	BEATEN_TAB_ENTRIES-1	;NUMBER IN THE TABLE (DON'T COUNT ZERO FILLER)
	.WORD	BEATEN_TAB_VISIBLE	;unused?
	.WORD	BEATEN_TAB_SELECT 	;BITS TO SELECT IT
	.LONG	BEATEN_ROM_TABLE	;ROM IMAGE OF TABLE
	.WORD	BEATEN_TAB_ENTRIES/5	;RESET TABLE IF 1/5 OR MORE BAD

INTER_TAB
	.LONG	INTER_TAB_ORIGIN 	;LOCATION OF TABLE
	.WORD	INTER_TAB_ENTRIES-1	;NUMBER IN THE TABLE (DON'T COUNT ZERO FILLER)
	.WORD	INTER_TAB_VISIBLE	;unused?
	.WORD	INTER_TAB_SELECT 	;BITS TO SELECT IT
	.LONG	INTER_ROM_TABLE	;ROM IMAGE OF TABLE
	.WORD	INTER_TAB_ENTRIES/5	;RESET TABLE IF 1/5 OR MORE BAD

TAG_TAB
	.LONG	TAG_TAB_ORIGIN 	;LOCATION OF TABLE
	.WORD	TAG_TAB_ENTRIES-1	;NUMBER IN THE TABLE (DON'T COUNT ZERO FILLER)
	.WORD	TAG_TAB_VISIBLE	;unused?
	.WORD	TAG_TAB_SELECT 	;BITS TO SELECT IT
	.LONG	TAG_ROM_TABLE	;ROM IMAGE OF TABLE
	.WORD	TAG_TAB_ENTRIES/5	;RESET TABLE IF 1/5 OR MORE BAD


P_FORK
	MMTM	SP,A1
	MOVE	*A13(PROCID),A1		;PASS OUR ID TO FORKED PROCESS
	CALLA	GETPRC			;MAKE THE PROCESS
	MMFM	SP,A1
	RETS

**************************************************************************
*
*	AUTO HIGH SCORE TABLE RESET HANDLING
*
**************************************************************************
*
*	DEC_HSR
*
*	THIS IS CALLED WITH EACH START OR CONTINUE FOR
*	A PLAYER.  IT REMOVES 1 FROM THE HSTD COUNTER UNLESS
*	ITS ALREADY SITTING AT ZERO.
*
**************************************************************************
DEC_HSR
	MMTM	SP,A0
	CALLR	GET_HSC 	;THIS IS EASY...GET THE COUNTER
	JRZ	DECHX		;ITS ZERO....NO ACTION.
	DEC	A0		;REMOVE A TICK
	CALLR	PUT_HSC 	;PUT IT BACK JAK
DECHX	MMFM	SP,A0
	RETS

**************************************************************************
*
*	DELAY_HSRESET
*
*	THIS IS CALLED WHEN A NEW ENTRY IS MADE IN THE ALL TIME
*	HIGH SCORE TABLE. IF WE'RE CLOSE TO A HIGH SCORE
*	RESET, WE PUT IT OFF AWHILE SO HE CAN SHOW HIS FRIENDS
*	FOR A FEW DAYS.
*
**************************************************************************
HS_MIN	 EQU	 750		 ;ALWAYS 750 PLAYS BEFORE REMOVING A FRESH
*				 ;NAME.
DELAY_HSRESET:
	MMTM	SP,A0
	CALLR	GET_HSC 	;THIS IS EASY...GET THE COUNTER
	CMPI	HS_MIN,A0	;IS IT TOO LOW
	JRHS	DHX		;NOPE...NO ACTION

	MOVI	HS_MIN,A0	;STOP THE RESET!
	CALLR	PUT_HSC 	;THIS MANY PLAYS TILL RESET!
DHX:	
	MMFM	SP,A0
	RETS
	
**************************************************************************
*
*	INIT_HSR
*
*	THIS IS CALLED TO INITIALIZE THE HIGH SCORE RESET
*	COUNTER TO ITS ADJUSTED VALUE.
*
**************************************************************************
INIT_HSR
	MMTM	SP,A0
	MOVI	ADJHSRES,A0
	CALLA	GET_ADJ 	;GET THE ADJUSTED VALUE
	CALLR	PUT_HSC 	;SET IT TO THIS VALUE
	MMFM	SP,A0
	RETS

**************************************************************************
*
*	PUT_HSC
*
*	THIS IS CALLED TO SET THE HIGH SCORE RESET COUNTER
*	TO THE VALUE IN A0.
*
**************************************************************************
PUT_HSC
	MMTM	SP,A7,A0
	CALLR	HSR_PAGE		;HIGH SCORE PAGE

	MOVI	HRESET_COUNTER,A7	;POINT AT
	CALLR	WC_LONGI		;WRITE OUR PARAMETER
	NOT	A0			;NEGATE IT.
	CALLR	WC_LONG 		;AND WRITE IN SUBSEQUENT SPOT.
	CALLA	DEF_PAGE		;FLIP PAGE
	MMFM	SP,A7,A0		;AND RETURN
	RETS

**************************************************************************
*
*	GET_HSC
*
*	THIS IS CALLED TO FETCH THE HIGH SCORE COUNTER IN A0.
*	IF IT IS INVALID, IT WILL IMMEDIATELY BE RESET TO THE
*	ADJUSTED VALUE AND THIS IS WHAT WILL BE RETURNED
*	IN A0. Z set if 0
*
**************************************************************************
GET_HSC
	MMTM	SP,A7,A1
	CALLR	HSR_PAGE		;POINT PAGE AT HSR

	MOVI	HRESET_COUNTER,A7	;POINT AT
	CALLR	RC_LONGI		;READ THE VALUE
	MOVE	A0,A1			;STASH IT
	CALLR	RC_LONG 		;READ VERIFIER
	NOT	A0			;SEE IF ITS VALID
	CMP	A0,A1
	JRZ	GET_HSCX		;IT IS....RETURN IT.

	CALLR	INIT_HSR		;REFRESH IT WITH FACTORY VALUE
*
*	NOW RETURN THE FACTORY VALUE IN CASE IT DIDN'T TAKE
*
	MOVI	ADJHSRES,A0
	CALLA	GET_ADJ 		;GET THE ADJUSTED VALUE

GET_HSCX
	CALLA	DEF_PAGE		;FLIP PAGE AWAY FROM US
	MOVE	A0,A0			;SET Z FLAG BASED ON COUNTER
	MMFM	SP,A7,A1
	RETS

HSR_PAGE
	MMTM	SP,A1
	MOVI	HSR_SELECT,A1
	CALLR	SET_PAGE
	MMFM	SP,A1
	RETS

#*********************************************************************
* Check validity of high score and win streak tables.
*

 SUBR	table_cmos_check

	movi	PIN_SPEED_TAB,a8
	callr	VAL_TAB
	movi	STREAK_TAB,a8
	callr	VAL_TAB

	movi	BEATEN_TAB,a8
	callr	VAL_TAB

	movi	INTER_TAB,a8
	callr	VAL_TAB

	movi	TAG_TAB,a8
	callr	VAL_TAB
	rets

#*********************************************************************
* Display high score table
*

 SUBR	print_inter

	push	a5
	movi	#hscore_mes2,a2
	calla	print_message

	MOVI	[10,0],A0
	MOVI	[21,0],A1

	movi	MVEBAR_R,a2
	movi	1799H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	CLR	A6
	CLR	A7
	calla	BEGINOBJ

	MOVI	[13,0],A0
	MOVI	[21+9,0],A1

	movi	SHADOW01,a2
	movi	1799H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	CLR	A6
	CLR	A7
	calla	BEGINOBJ
	CREATE	FLASH_PID,JUDDER_SHADOW

	pull	a9
	move	a9,@starting_num
	movi	HS_SIZE,a7
	mpyu	a7,a9
	addi	INTER_TAB_ORIGIN,a9
	move	a9,a8

	movi	3,a7			;draw 3

	movi	[51-9,8],a9
	movi	[58+5,10],a10

#loop
	movi	GOLD,a11
	movi	AUD_INTER,A0
	calla	GET_AUD
	MOVE	@starting_num,A5
	cmp	a1,a5
	jrne	#gold
	movi	BLUE,a11
#gold
	PUSH	a3,a7,a8,a9,a10,a11
	movi	INTER_TAB_SELECT,a1	;set the read page
	callr	SET_PAGE
	movi	special_copy,a5
	callr	draw_beaten_table_entry
	PULL	a3,a7,a8,a9,a10,a11

	move	@starting_num,a5
	inc	a5
	move	a5,@starting_num

	dec	a7
	jrz	#done

	addi	HS_SIZE,a8
	addi	[46h,0],a9
	addi	[46h,0],a10
	jruc	#loop
#done
	callr	hscore_colcyc
	callr	hscore_colcyc2
	RETP

#hscore_mes2
	JAM_STR	osgemd_ascii,10,0,200,10,BLUE,print_string_C2
	.byte	"INTERCONTINENTAL CHAMPS",0,0
	.even


#**********************

 SUBR	print_beaten

	push	a5
	movi	#hscore_mes,a2
	calla	print_message

	MOVI	[10,0],A0
	MOVI	[21,0],A1

	movi	MVEBAR_R,a2
	movi	1799H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	CLR	A6
	CLR	A7
	calla	BEGINOBJ

	MOVI	[13,0],A0
	MOVI	[21+9,0],A1

	movi	SHADOW01,a2
	movi	1799H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	CLR	A6
	CLR	A7
	calla	BEGINOBJ
	CREATE	FLASH_PID,JUDDER_SHADOW

	pull	a9
	move	a9,@starting_num
	movi	HS_SIZE,a7
	mpyu	a7,a9
	addi	BEATEN_TAB_ORIGIN,a9
	move	a9,a8

	movi	3,a7			;draw 3

	movi	[51-9,8],a9
	movi	[58+5,10],a10

#loop
	movi	GOLD,a11
	movi	AUD_BEATEN,A0
	calla	GET_AUD
	MOVE	@starting_num,A5
	cmp	a1,a5
	jrne	#gold
	movi	BLUE,a11
#gold
	PUSH	a3,a7,a8,a9,a10,a11
	movi	BEATEN_TAB_SELECT,a1	;set the read page
	callr	SET_PAGE
	movi	special_copy,a5
	callr	draw_beaten_table_entry
	PULL	a3,a7,a8,a9,a10,a11

	move	@starting_num,a5
	inc	a5
	move	a5,@starting_num

	dec	a7
	jrz	#done

	addi	HS_SIZE,a8
	addi	[46h,0],a9
	addi	[46h,0],a10
	jruc	#loop
#done
;	callr	hscore_colcyc
;	callr	hscore_colcyc2
	RETP

 SUBR	JUDDER_SHADOW
	MOVI	SHADOW_ANIM,A1
	calla	setup_back_anim
	JSRP	ANIM_CROWD
	DIE

CANI_GOTO	equ	0 + 8000h

SHADOW_ANIM
	WL	1,SHADOW02
	WL	1,SHADOW01
	WL	CANI_GOTO,SHADOW_ANIM

#hscore_mes
	JAM_STR	osgemd_ascii,10,0,200,10,BLUE,print_string_C2
	.byte	"WORLD CHAMPIONS",0,0
	.even


 SUBR	STOP_ALL_OBJS
	MOVI	OBJLST,A8
	CLR	A1
	JRUC	DO_EACH_OBJ_STOP
STOP_THIS_OBJ
	MOVE	A1,*A8(OYVEL),L
DO_EACH_OBJ_STOP
	MOVE	*A8,A8,L
	JRNZ	STOP_THIS_OBJ
	RETS

 SUBR	MOVE_ALL_OBJS_UP
	MOVI	OBJLST,A8
	MOVI	RUBYPAL,A0
	CALLA	pal_getf
	MOVI	[-2,0],A1
	JRUC	DO_EACH_OBJ
MOVE_THIS_OBJ_UP
	MOVE	*A8(OPAL),A2
	CMP	A2,A0
	JREQ	DO_EACH_OBJ
	MOVE	*A8(OZPOS),A2
	CMPI	1798H,A2
	JRGT	DO_EACH_OBJ
	MOVE	A1,*A8(OYVEL),L
DO_EACH_OBJ
	MOVE	*A8,A8,L
	JRNZ	MOVE_THIS_OBJ_UP
	RETS

 SUBR	DELETE_ANY_OFF_TOP
	MOVI	OBJLST,A8
	MOVI	[-30,0],A3
	JRUC	DO_EACH_OBJ_NEXT
DELETE_OR_NOT
	MOVE	*A8(OYVAL),A2,L
	CMP	A3,A2
	JRGT	DO_EACH_OBJ_NEXT
	MOVE	*A8,A9,L
	CALLA	DELOBJA8
	MOVE	A9,A8
	JRNZ	DELETE_OR_NOT
	RETS
DO_EACH_OBJ_NEXT
	MOVE	*A8,A8,L
	JRNZ	DELETE_OR_NOT
	RETS


#*********************************************************************
* Display high score table
*

 SUBR	print_tag

	movi	tag_mes,a2
	calla	print_message

	MOVI	[10,0],A0
	MOVI	[21,0],A1

	movi	MVEBAR_R,a2
	movi	1799H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	CLR	A6
	CLR	A7
	calla	BEGINOBJ

	MOVI	[13,0],A0
	MOVI	[21+9,0],A1

	movi	SHADOW01,a2
	movi	1799H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	CLR	A6
	CLR	A7
	calla	BEGINOBJ

	movi	FLASH_PID,A0
	CLR	A1
	NOT	A1
	CALLA	KILALL

	CREATE	FLASH_PID,JUDDER_SHADOW

	movi	9,a7			;draw 9
	movk	1,a3

	movi	TAG_TAB_ORIGIN+HS_SIZE,a8
	movi	[40,8],a9
	movi	[38,64+8],a10

#loop
	movi	GOLD,a11
	movi	AUD_TAG,A0
	calla	GET_AUD
	addk	1,a1
	srl	1,a1
	CMP	a1,A3
	jrne	#notblue
	movi	BLUE,a11
#notblue
	PUSH	A3,a7,a8,a9,a10,a11
	movi	TAG_TAB_SELECT,a1	;set the read page
	callr	SET_PAGE
	movi	special_copy,a5
	movi	SEC,a2
	MOVI	[118H,0],a1
	MOVI	0110H,A6
	callr	draw_tag_table_entry
	PULL	A3,a7,a8,a9,a10,a11

	INC	A3
	dec	a7
	jrz	#done

	addi	HS_SIZE*2,a8
	addi	[23,0],a9
	addi	[23,0],a10
	jruc	#loop

#done
	RETP

tag_mes
	JAM_STR	osgemd_ascii,10,0,200,10,BLUE,print_string_C2
	.byte	"TAG TEAM CHAMPIONS",0,0
	.even

#*********************************************************************
* Display high score table
*

 SUBR	print_hscores

	movi	#hscore_mes,a2
	calla	print_message


	MOVI	[10,0],A0
	MOVI	[21,0],A1

	movi	MVEBAR_R,a2
	movi	1799H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	CLR	A6
	CLR	A7
	calla	BEGINOBJ

	MOVI	[13,0],A0
	MOVI	[21+9,0],A1

	movi	SHADOW01,a2
	movi	1799H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	CLR	A6
	CLR	A7
	calla	BEGINOBJ

	movi	FLASH_PID,A0
	CLR	A1
	NOT	A1
	CALLA	KILALL

	CREATE	FLASH_PID,JUDDER_SHADOW


	movi	9,a7			;draw 9
	movk	1,a3

	movi	PIN_SPEED_TAB_ORIGIN+HS_SIZE,a8
	movi	[40,8],a9
	movi	[38,64+8],a10

#loop
	movi	GOLD,a11
	movi	AUD_PINSPEED,A0
	calla	GET_AUD
	CMP	a1,A3
	jrne	#notblue
	movi	BLUE,a11
#notblue
	PUSH	A3,a7,a8,a9,a10,a11
	movi	PIN_SPEED_TAB_SELECT,a1	;set the read page
	callr	SET_PAGE
	movi	special_copy,a5
	movi	SEC,a2
	MOVI	[82H,0],a1
	MOVI	120,A6
	callr	draw_pinspeed_table_entry
	PULL	A3,a7,a8,a9,a10,a11

	INC	A3
	dec	a7
	jrz	#done

	addi	HS_SIZE,a8
	addi	[23,0],a9
	addi	[23,0],a10
	jruc	#loop

#done
	RETP

#hscore_mes
	JAM_STR	osgemd_ascii,10,0,200,10,BLUE,print_string_C2
	.byte	"FASTEST PINDOWN TIMES",0,0
	.even


#*********************************************************************
* Display win streaks table
*

 SUBR	print_winstreaks

	movi	#streak_mes,a2
	calla	print_message

	MOVI	[10,0],A0
	MOVI	[21,0],A1

	movi	MVEBAR_R,a2
	movi	1799H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	CLR	A6
	CLR	A7
	calla	BEGINOBJ

	MOVI	[13,0],A0
	MOVI	[21+9,0],A1

	movi	SHADOW01,a2
	movi	1799H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	CLR	A6
	CLR	A7
	calla	BEGINOBJ

	movi	FLASH_PID,A0
	CLR	A1
	NOT	A1
	CALLA	KILALL

	CREATE	FLASH_PID,JUDDER_SHADOW

	movi	18,a7			;draw 18
	MOVK	1,A3
;	clr	a3

	movi	STREAK_TABLE_ORIGIN+HS_SIZE,a8
	movi	[40,8],a9
	movi	[38,44],a10

#loop
	movi	GOLD,a11
	movi	AUD_WINSTREAK,A0
	calla	GET_AUD
	cmp	a1,a3
	jrne	#gold
	movi	BLUE,a11
#gold
	PUSH	A3,a7,a8,a9,a10,a11
	movi	STREAK_TABLE_SELECT,a1
	callr	SET_PAGE
	movi	copy_string,a5
	MOVI	[6aH,0],a1
	movi	WINS,a2
	MOVI	80,A6
	callr	draw_winstreak_table_entry
	PULL	A3,a7,a8,a9,a10,a11
	INC	A3
	dec	a7
	jrz	#done
	cmpi	9,a7
	jreq	reset_position

	addi	HS_SIZE,a8
	addi	[23,0],a9
	addi	[23,0],a10
	jruc	#loop

reset_position
	addi	HS_SIZE,a8
	movi	[40,208+5],a9
	movi	[38,244+5],a10
	jruc	#loop

#done
	RETP


#streak_mes
	JAM_STR	osgemd_ascii,10,0,200,10,BLUE,print_string_C2
	.byte	"LONGEST WINNING STREAKS",0,0
	.even

special_copy
	movi	message_buffer,a2
	movi	message_buffer2,a3
	move	*a3+,*a2+
	movi	".",a1
	movb	a1,*a2
	addi	8,a2
	movb	*a3,*a2
	addi	8,a2
	addi	16,a3
	clr	a1
	movb	a1,*a2
	MOVK	15,A0
	move	a0,@mess_spacing
	MOVK	1,A0
	MOVE	A0,@IGNORE_CHAR_WIDTH
	rets

	.bss	work_buffer,8*10

#*********************************************
*
 SUBRP	strip_white
	PUSH	a0,a1,a2
	movi	work_buffer,a0		; Pointer to work buffer
	subk	1,a3
	sll	3,a3			; Set pointer to end of buffer
	move	a3,a1
	addi	work_buffer,a1
#ff_loop
	movb	*a0,a2			; Get char
	cmpi	20h,a2			; Is it a space ?
	jrnz	#first_found		; br = no
	move	a2,a2			; Is it 0 ?
	jrz	#first_found		; br = yes
	addk	8,a0			; Increment front pointer
	jruc	#ff_loop		; Go check next char

#first_found
#fl_loop
	movb	*a1,a2			; Get char
	move	a2,a2			; Is it 0 ?
	jrz	#get_prev
	cmpi	20h,a2			; Is it a space ?
	jrnz	#last_found		; br = yes
#get_prev
	cmpi	work_buffer,a1		; Are we at beginning ?
	jrz	#last_found		; br = yes
	subk	8,a1			; Decrement pointer
	jruc	#fl_loop		; Go check previous char

#last_found
	addk	8,a1
	movi	message_buffer,a2	; Where we are gonna put it
	cmp	a0,a1			; back pointer > front pointer ?
	jrgt	#copy_loop		; br = yes
	movi	work_buffer,a0		; reset front pointer
	move	a3,a1
	addi	work_buffer,a1
#copy_loop
	movb	*a0,a14			; Get char
	movb	a14,*a2			; Write to message buffer
	addk	8,a0			; Increment front pointer
	cmp	a0,a1			; front = back ?
	jrz	#copy_done		; br = yes
	addk	8,a2			; Increment dest pointer
	jruc	#copy_loop		; Go do next char

#copy_done
	addk	8,a2			; Increment dest pointer
	clr	a1			; NULL terminate the string
	move	a1,*a2

	PULL	a0,a1,a2
	rets

#*******************************
* Display a table entry (initials and score)
* >a8=*entry, a9=[Y,Xleft] of initials, a10=[Y,Xright] of score, a11=pal
* >a0=draw high score message? (0|1)

 SUBRP   draw_tag_table_entry
	PUSH	A7

	push	a8
	PUSH	A5
	PUSH	A6
	move	a10,a0
	sll	16,a0
	ADD	A1,A0
	move	a10,a1
	srl	16,a1
	sll	16,a1
	addi	[4,0],a1
	movi	1000H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW
	PULL	A6
	PULL	A5
	pull	a8

	move	a8,a7
	callr	RC_LONG			;read the score
	calla	BCDBIN
	callr	val_to_dec_tenths_asc

	movk	2,a0
	move	a0,@mess_spacing
	CLR	A0
	MOVE	A0,@IGNORE_CHAR_WIDTH
	movi	font18_ascii,a0
	move	a0,@message_ascii,L
	movi	10,a0
	move	a0,@mess_space_width
	move	a10,a0
	sll	16,a0
	srl	16,a0
	add	A6,a0
	move	a0,@mess_cursx
	move	a10,a0
	srl	16,a0
	move	a0,@mess_cursy
	movi	WGSF_W_P1,a0
	move	a0,@message_palette,L
	calla	print_string_R

	;initials
	movi	work_buffer,a1
	move	a8,a7
	addi	HS_INITS,a7
	movi	5,a2

#initloop
	callr	RC_BYTEI
	movb	a0,*a1
	addk	8,a1
	dsj	a2,#initloop

	movk	5,a3
	callr	strip_white

	clr	a0			;null-terminate it
	movb	a0,*a1

	movi	osgemd_ascii,a0
	move	a0,@message_ascii,L
	movi	10,a0
	move	a0,@mess_space_width
	clr	a0
	move	a0,@mess_spacing
	MOVE	A0,@IGNORE_CHAR_WIDTH
	move	a10,a0
	sll	16,a0
	srl	16,a0
	addk	30,a0
	move	a0,@mess_cursx
	move	a10,a0
	srl	16,a0
	move	a0,@mess_cursy
	move	a11,@message_palette,L
	calla	print_string_C


	push	a8
	move	a10,a0
	sll	16,a0
	addi	[52h,0],a0

	move	a10,a1
	srl	16,a1
	sll	16,a1

	move	a11,b0
	movi	OSGEMD_AND,a2
	movi	1799H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	CLR	A6
	CLR	A7
	calla	BEGINOBJP
	pull	a8

	;initials second set
	movi	work_buffer,a1
	move	a8,a7
	addi	HS_INITS+HS_SIZE,a7
	movi	5,a2

#initloop2
	callr	RC_BYTEI
	movb	a0,*a1
	addk	8,a1
	dsj	a2,#initloop2

	movk	5,a3
	callr	strip_white

	clr	a0			;null-terminate it
	movb	a0,*a1

	movi	osgemd_ascii,a0
	move	a0,@message_ascii,L
	movi	10,a0
	move	a0,@mess_space_width
	clr	a0
	move	a0,@mess_spacing
	MOVE	A0,@IGNORE_CHAR_WIDTH
	move	a10,a0
	sll	16,a0
	srl	16,a0
	addi	155,a0
	move	a0,@mess_cursx
	move	a10,a0
	srl	16,a0
	move	a0,@mess_cursy
	move	a11,@message_palette,L
	calla	print_string_C

	move	a9,a0
	sll	16,a0
	subi	[8,0],a0
	move	a9,a1
	srl	16,a1
	sll	16,a1
	addi	[2,0],a1
	movi	SPEAR,a2
	movi	1000H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	move	a9,a0
	sll	16,a0
	addi	[13,0],a0
	move	a9,a1
	srl	16,a1
	sll	16,a1
	addi	[2,0],a1
	movi	SPEAR,a2
	movi	1001H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	PULL	A7

	movi	"#",a0
	movb	a0,@message_buffer
	addk	8,a1

	MOVK	10,A0
	SUB	A7,A0
	calla	BINBCD			;dec number in A0
	move	a0,a1
	movi	message_buffer+8,a2
	calla	dec_to_asc_new_entry

	clr	a0
	move	a0,*a2+

	movi	wsf14_ascii,a0
	move	a0,@message_ascii,L
	movi	7,a0
	move	a0,@mess_space_width
	clr	a0
	move	a0,@mess_spacing
	MOVE	A0,@IGNORE_CHAR_WIDTH
	move	a9,a0
	sll	16,a0
	srl	16,a0
	move	a0,@mess_cursx
	move	a9,a0
	srl	16,a0
	move	a0,@mess_cursy
	movi	WSF_W_P,a0
	move	a0,@message_palette,L
	movi	1003h,a0
	move	a0,@mess_z,L
	calla	print_string_with_z

	rets


dot
	.string	".",0
	.even
zero
	.string	"0",0
	.even

; A0 = binary value
	.ref	concat_string
	.ref	concat_rom_string

 SUBRP	val_to_dec_tenths_asc
	PUSH	a1,a2,a3,a4,a5,a6

	movi	10,a3
	move	a0,a1
	divu	a3,a1
	move	a1,a0

	movi	10,a3
	move	a0,a1
	divu	a3,a1

	movi	10,a2
	move	a0,a3
	modu	a2,a3
	
	PUSH	a3
	move	a1,a0
	movi	1000,a1
	calla	dec_to_asc
	calla	copy_string
	movi	dot,a4
	calla	concat_rom_string
	PULL	a3
	move	a3,a0
	jrz	#is_zero
	movi	10,a1
	calla	dec_to_asc
	calla	concat_string
	jruc	#conv_done
#is_zero
	movi	zero,a4
	calla	concat_rom_string
#conv_done

	PULL	a1,a2,a3,a4,a5,a6
	rets


#*******************************
* Display a table entry (initials and score)
* >a8=*entry, a9=[Y,Xleft] of initials, a10=[Y,Xright] of score, a11=pal
* >a0=draw high score message? (0|1)

 SUBRP   draw_pinspeed_table_entry

	PUSH	A7

	push	a8
	PUSH	A5
	PUSH	A6
	move	a10,a0
	sll	16,a0
	ADD	A1,A0
	move	a10,a1
	srl	16,a1
	sll	16,a1
	addi	[4,0],a1
	movi	1000H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW
	PULL	A6
	PULL	A5
	pull	a8

	move	a8,a7
	callr	RC_LONG			;read the score
	calla	BCDBIN
	callr	val_to_dec_tenths_asc

	movk	2,a0
	move	a0,@mess_spacing
	CLR	A0
	MOVE	A0,@IGNORE_CHAR_WIDTH
	movi	font18_ascii,a0
	move	a0,@message_ascii,L
	movi	10,a0
	move	a0,@mess_space_width
	move	a10,a0
	sll	16,a0
	srl	16,a0
	add	A6,a0
	move	a0,@mess_cursx
	move	a10,a0
	srl	16,a0
	move	a0,@mess_cursy
	movi	WGSF_W_P1,a0
	move	a0,@message_palette,L
	calla	print_string_R

	;initials
	movi	message_buffer,a1
	move	a8,a7
	addi	HS_INITS,a7
	movi	3,a2

#initloop
	callr	RC_BYTEI
	movb	a0,*a1
	addk	8,a1
	dsj	a2,#initloop

	callr	RC_BYTEI
	push	a0

	clr	a0			;null-terminate it
	movb	a0,*a1

	movi	osgemd_ascii,a0
	move	a0,@message_ascii,L
	movi	10,a0
	move	a0,@mess_space_width
	clr	a0
	move	a0,@mess_spacing
	MOVE	A0,@IGNORE_CHAR_WIDTH
	move	a10,a0
	sll	16,a0
	srl	16,a0
	addi	17h,a0
	move	a0,@mess_cursx
	move	a10,a0
	srl	16,a0
	move	a0,@mess_cursy
	move	a11,@message_palette,L
	calla	print_string_C

	move	a9,a0
	sll	16,a0
	subi	[8,0],a0
	move	a9,a1
	srl	16,a1
	sll	16,a1
	addi	[2,0],a1
	movi	SPEAR,a2
	movi	1000H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	move	a9,a0
	sll	16,a0
	addi	[13,0],a0
	move	a9,a1
	srl	16,a1
	sll	16,a1
	addi	[2,0],a1
	movi	SPEAR,a2
	movi	1001H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	pull	a0

	SUBI	"A",a0
	sll	5,a0
	addi	WHICH_NAMES,A0
	MOVE	*A0,A2,L

	move	a9,a0
	sll	16,a0
	addi	[302,0],a0
	move	a9,a1
	srl	16,a1
	sll	16,a1
	addi	[7,0],a1
	movi	1001H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	PULL	A7

	movi	"#",a0
	movb	a0,@message_buffer
	addk	8,a1

	MOVK	10,A0
	SUB	A7,A0
	calla	BINBCD			;dec number in A0
	move	a0,a1
	movi	message_buffer+8,a2
	calla	dec_to_asc_new_entry

	clr	a0
	move	a0,*a2+

	movi	wsf14_ascii,a0
	move	a0,@message_ascii,L
	movi	7,a0
	move	a0,@mess_space_width
	clr	a0
	move	a0,@mess_spacing
	MOVE	A0,@IGNORE_CHAR_WIDTH
	move	a9,a0
	sll	16,a0
	srl	16,a0
	move	a0,@mess_cursx
	move	a9,a0
	srl	16,a0
	move	a0,@mess_cursy
	movi	WSF_W_P,a0
	move	a0,@message_palette,L
	movi	1003h,a0
	move	a0,@mess_z,L
	calla	print_string_with_z

	rets

#*******************************
 SUBRP	draw_winstreak_table_entry

	PUSH	A7

	push	a8
	PUSH	A5
	PUSH	A6
	move	a10,a0
	sll	16,a0
	ADD	A1,A0
	move	a10,a1
	srl	16,a1
	sll	16,a1
	addi	[4,0],a1
	movi	1000H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW
	PULL	A6
	PULL	A5
	pull	a8

	move	a8,a7
	callr	RC_LONG			;read the score
	calla	BCDBIN
	movi	9999999,a1
	calla	dec_to_asc		;convert to ASCII
	CLR	A0
	move	a0,@mess_spacing
	call	a5

	clr	a0
	MOVE	A0,@IGNORE_CHAR_WIDTH
	movi	font18_ascii,a0
	move	a0,@message_ascii,L
	movi	10,a0
	move	a0,@mess_space_width
	move	a10,a0
	sll	16,a0
	srl	16,a0
	add	A6,a0
	move	a0,@mess_cursx
	move	a10,a0
	srl	16,a0
	move	a0,@mess_cursy
	movi	WGSF_W_P1,a0
	move	a0,@message_palette,L
	calla	print_string_C

	;initials
;	movi	message_buffer,a1
	movi	work_buffer,a1
	move	a8,a7
	addi	HS_INITS,a7
	movi	3,a2

#initloop
	callr	RC_BYTEI
	movb	a0,*a1
	addk	8,a1
	dsj	a2,#initloop

	movk	3,a3
	callr	strip_white

	clr	a0			;null-terminate it
	movb	a0,*a1

	movi	osgemd_ascii,a0
	move	a0,@message_ascii,L
	movi	10,a0
	move	a0,@mess_space_width
	clr	a0
	move	a0,@mess_spacing
	MOVE	A0,@IGNORE_CHAR_WIDTH
	move	a10,a0
	sll	16,a0
	srl	16,a0
	addi	17h,a0
	move	a0,@mess_cursx
	move	a10,a0
	srl	16,a0
	move	a0,@mess_cursy
	move	a11,@message_palette,L
	calla	print_string_C

	move	a9,a0
	sll	16,a0
	subi	[8,0],a0
	move	a9,a1
	srl	16,a1
	sll	16,a1
	addi	[2,0],a1
	movi	SPEAR,a2
	movi	1000H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	move	a9,a0
	sll	16,a0
	SUBi	[10,0],a0
	move	a9,a1
	srl	16,a1
	sll	16,a1
	addi	[2,0],a1
	movi	BARBUTT,a2
	movi	1001H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7
	MOVI	DPLT_R_P,B0
	calla	BEGINOBJWP
	PULL	A7

;	movi	"#",a0
;	movb	a0,@message_buffer
;	addk	8,a1

	MOVK	19,A0
	SUB	A7,A0
	calla	BINBCD			;dec number in A0
	move	a0,a1
;	movi	message_buffer+8,a2
	movi	message_buffer,a2
	calla	dec_to_asc_new_entry

	clr	a0
	move	a0,*a2+

	movi	wsf14_ascii,a0
	move	a0,@message_ascii,L
	movi	7,a0
	move	a0,@mess_space_width
	clr	a0
	move	a0,@mess_spacing
	MOVE	A0,@IGNORE_CHAR_WIDTH
	move	a9,a0
	sll	16,a0
	srl	16,a0
	subi	4,a0
	move	a0,@mess_cursx
	move	a9,a0
	srl	16,a0
	move	a0,@mess_cursy
	movi	WSF_W_P,a0
	move	a0,@message_palette,L
	movi	1003h,a0
	move	a0,@mess_z,L
	calla	print_string_with_z

	rets

WHICH_NAMES
	.LONG	HART
	.LONG	RAZOR
	.LONG	UNDER
	.LONG	YOKO
	.LONG	SHAWN
	.LONG	BAMBAM
	.LONG	DOINK
	.LONG	0
	.LONG	LEX

which_crouton
	.long	CRUT_BH
	.long	CRUT_RR
	.long	CRUT_UN
	.long	CRUT_YK
	.long	CRUT_SM
	.long	CRUT_BM
	.long	CRUT_DK
	.long	CRUT_LX

 SUBR	draw_each_inter_table_entry

	movi	HS_SIZE,a7
	mpyu	a7,a9
	addi	INTER_TAB_ORIGIN,a9
	move	a9,a8

	movi	[126H,8],a9
	movi	[13BH,10],a10

	movi	GOLD,a11
	movi	AUD_INTER,A0
	calla	GET_AUD
	MOVE	@starting_num,A5
	cmp	a1,a5
	jrne	#gold2
	movi	BLUE,a11
#gold2
	movi	INTER_TAB_SELECT,a1	;set the read page
	callr	SET_PAGE
	movi	special_copy,a5
	JRUC	draw_beaten_table_entry

 SUBR	draw_each_beaten_table_entry

	movi	HS_SIZE,a7
	mpyu	a7,a9
	addi	BEATEN_TAB_ORIGIN,a9
	move	a9,a8

	movi	[126H,8],a9
	movi	[13BH,10],a10

	movi	GOLD,a11
	movi	AUD_BEATEN,A0
	calla	GET_AUD
	MOVE	@starting_num,A5
	cmp	a1,a5
	jrne	#gold
	movi	BLUE,a11
#gold
	movi	BEATEN_TAB_SELECT,a1	;set the read page
	callr	SET_PAGE
	movi	special_copy,a5

#*******************************
* Display a table entry (initials and score)
* >a8=*entry, a9=[Y,Xleft] of initials, a10=[Y,Xright] of score, a11=pal
* >a0=draw high score message? (0|1)

 SUBR	draw_beaten_table_entry

	push	a7
	push	a9,a10
	move	a8,a7
	callr	RC_LONG			;read the score
	move	a0,a9

	jrnz	no_reset_blank
	movk	1,a0
	move	a0,@not_blank
no_reset_blank

	movk	8,a10
	clr	a3
	pull	a1
	push	a1
	move	a1,a0
	sll	16,a0
	clr	b4
	addi	[2,0],a1
next_icon
	srl	1,a9
	jrnc	no_icon
	mmtm	sp,a0,a1,a3,a8,a11
	move	a3,a4
	sll	5,a4
	addi	which_crouton,a4
	move	*a4,a2,L
	movi	1000H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW
	movi	01000100h,a3
	move	a3,*a8(OSCALE),L
	mmfm	sp,a0,a1,a3,a8,a11
	addi	[30h,0],a0
	inc	b4
no_icon
	srl	3,a9
	inc	a3
	dec	a10
	jrnz	next_icon

	mmtm	sp,a0,a1,a3,a8,a11
	movi	8,b5
	sub	b4,b5
;loop will attempt to create 2^32 number of dots!!!!!
;Soooooo - don't do it!!!!
	jrz	#no_dots
	move	b5,a10
	addi	[10,0],a0
next_dot
;	movi	CRUTPLT_G,a2
	movi	OSGEMD_DOT,a2
	movi	1000H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7
	push	a0,a1
	calla	BEGINOBJW
	pull	a0,a1
	addi	[30h,0],a0
	dec	a10
	jrnz	next_dot
#no_dots
	mmfm	sp,a0,a1,a3,a8,a11

	pull	a9,a10

	;initials
do_just_init
	movi	message_buffer,a1
	move	a8,a7
	addi	HS_INITS,a7
	movi	5,a2

#initloop
	callr	RC_BYTEI
	movb	a0,*a1
	addk	8,a1
	dsj	a2,#initloop

	clr	a0			;null-terminate it
	movb	a0,*a1

	movi	osgemd_ascii,a0
	move	a0,@message_ascii,L
	movi	10,a0
	move	a0,@mess_space_width
	clr	a0
	move	a0,@mess_spacing
	MOVE	A0,@IGNORE_CHAR_WIDTH
	move	a9,a0
	sll	16,a0
	srl	16,a0
	addi	50,a0
	move	a0,@mess_cursx
	move	a9,a0
	srl	16,a0
	move	a0,@mess_cursy
	move	a11,@message_palette,L
	movi	1003h,a0
	move	a0,@mess_z,L
	calla	print_string_with_z

	push	a1
	move	a9,a0
	sll	16,a0
	subi	[8,0],a0
	move	a9,a1
	srl	16,a1
	sll	16,a1
	addi	[2,0],a1
	movi	SPEAR,a2
	movi	1000H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	move	a9,a0
	sll	16,a0
	addi	[13,0],a0
	move	a9,a1
	srl	16,a1
	sll	16,a1
	addi	[2,0],a1
	movi	SPEAR,a2
	movi	1001H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW
	pull	a1

	pull	a7

	movi	"#",a0
	movb	a0,@message_buffer
	addk	8,a1
	move	@starting_num,a0

	calla	BINBCD			;dec number in A0
	move	a0,a1
	movi	message_buffer+8,a2
	calla	dec_to_asc_new_entry

	clr	a0
	move	a0,*a2+

	movi	wsf14_ascii,a0
	move	a0,@message_ascii,L
	movi	7,a0
	move	a0,@mess_space_width
	clr	a0
	move	a0,@mess_spacing
	MOVE	A0,@IGNORE_CHAR_WIDTH
	move	a9,a0
	sll	16,a0
	srl	16,a0
	move	a0,@mess_cursx
	move	a9,a0
	srl	16,a0
	move	a0,@mess_cursy
	movi	WSF_W_P,a0
	move	a0,@message_palette,L
	movi	1003h,a0
	move	a0,@mess_z,L
	calla	print_string_with_z

	rets


#*******************************
* high score page color cyclers
*

 SUBR	hscore_colcyc

	movi	[10,7],a8		;START AT COLOR 10, CYCLE 7 COLORS
	movi	BLUE,a9			;PAL NAME
	movi	COLTAB2,a10		;TABLE TO CYCLE WITH
	movk	3,a11			;RATE OF CYCLE IN TICKS
	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE

	rets

COLTAB2
   .word   0033eh,0135fh,02b7fh,03f9fh,053bfh,06bdfh,07fffh
   .word   06bdfh,053bfh,03f9fh,0277fh,0135fh,00f3fh,00b1fh,002ffh
   .word   002dfh,002ffh,002ffh,0031fh,0031fh,0033fh,002fdh,002dch
   .word   0029ah,00259h,00237h,00258h,00259h,0027ah,0029bh,002bch
   .word   0025ah,001f7h,001b5h,00172h,00194h,001d6h,00218h,0065ah
   .word   0069ch,00ebch,01addh,022fdh,02f1eh,0375eh,0437fh,04f9fh
   .word   03b7fh,0275fh,0133fh,0033fh,002feh,002ddh,002bch,0029bh
   .word   0025ah,00239h,00218h,00259h,0027bh,002bch,002feh,0033fh

   .word   0033eh,0135fh,02b7fh,03f9fh,053bfh,06bdfh,07fffh
   .word   06bdfh,053bfh,03f9fh,0277fh,0135fh,00f3fh,00b1fh,002ffh

 SUBR	hscore_colcyc2

	movi	[10,7],a8		;START AT COLOR 10, CYCLE 7 COLORS
	movi	RUBYPAL,a9			;PAL NAME
	movi	COLTAB3,a10		;TABLE TO CYCLE WITH
	movk	3,a11			;RATE OF CYCLE IN TICKS
	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE

	rets

COLTAB3

   .word   07c01h,07c63h,07d08h,07d8ch,07e10h,07eb5h,07f39h
   .word   07e94h,07e10h,07d6bh,07ce7h,07c42h,07421h,06c00h,06400h
   .word   05c00h,06400h,06800h,07000h,07400h,07c00h,07400h,06c00h
   .word   06000h,05800h,05c00h,06000h,06400h,06800h,06c00h,07000h
   .word   06400h,05c00h,05000h,04800h,05000h,05800h,06000h,06c00h
   .word   06c21h,07063h,070c6h,07508h,0754ah,079adh,079efh,07e52h
   .word   07defh,07dadh,0794ah,078e7h,07884h,07842h,07800h,07000h
   .word   06c00h,06400h,06000h,06400h,06c00h,07000h,07800h,07c00h

   .word   07c01h,07c63h,07d08h,07d8ch,07e10h,07eb5h,07f39h
   .word   07e94h,07e10h,07d6bh,07ce7h,07c42h,07421h,06c00h,06400h


#*****************************************************************************
* Checks to see if the expired player made the table, and takes care of all
* the details if he did.
*

	STRUCTPD
	LONG	#cursorimg		;UHL cursor *img
	LONG	#hiliteimg		;UHL hilite letter *img
	WORD	#stick			;UHW stick to read
	LONG	#which_tab
	LONG	#which_entry
	LONG	#which_level
	WORD	#which_aud



WHICH_TO_OR
	.LONG	1H
	.LONG	10H
	.LONG	100H
	.LONG	1000H
	.LONG	10000H
	.LONG	100000H
	.LONG	1000000H
	.LONG	10000000H

DO_BEATEN_GAME
	move	a10,a1
	sll	4,a1
	addi	which_player,a1
	move	*a1,a9
	CMPI	8,A9
	JRNE	AVOID_NUMBER_8
	DEC	A9
AVOID_NUMBER_8
	SLL	5,A9
	ADDI	WHICH_TO_OR,A9
	MOVE	*A9,A9,L

	move	a10,a1		;clear out intials for end game table
	MOVE	a1,a2
	sll	5,a1
	sll	4,a2
	add	a2,a1
	addi	entered_inits,a1
	clr	a11
	move	a11,*a1+,L
	movb	a11,*a1

	movi	FIND_LOW_TABLE_LEVEL,a11
	movi	BEATEN_TAB,a5
	movi	AUD_BEATEN,A3
	MOVE	@belt_type,a1
	jrnz	found_right_table
	movi	INTER_TAB,A5
	movi	AUD_INTER,A3
found_right_table
	movi	enter_initials_beaten,a10
	movi	SPECIAL_ENTRY,a7
	jruc	create_initial_input

 SUBR	DO_TAG_GAME

	move	a10,a1		;clear out intials for end game table
	MOVE	a1,a2
	sll	5,a1
	sll	4,a2
	add	a2,a1
	addi	entered_inits,a1
	clr	a11
	move	a11,*a1+,L
	movb	a11,*a1

	movi	FIND_LOW_TABLE_LEVEL,a11
	movi	TAG_TAB,a5
	movi	AUD_TAG,A3
	movi	enter_initials_beaten,a10
	movi	do_entry_time,a7
	jruc	create_initial_input


 SUBR	pin_speed_check

	;skip this check if I'm a drone.
	move	a8,A0
	CMPI	2,A0
	JRGE	#retp

	;skip this check if the match took three rounds
	move	@current_round,a14
	cmpi	3,a14
	jreq	#retp

	SLL	5,A0
	ADDI	MATCH_TIMERS,A0
	MOVE	*A0,A9,L
	jrle	#retp

	movi	FIND_LOW_TABLE_LEVEL,a11
	movi	PIN_SPEED_TAB,a5
	movi	enter_initials_top_20,a10
	movi	do_entry_time,a7
	movi	AUD_PINSPEED,a3
	jruc	create_initial_input

 SUBR	winstreak_check

	move	a8,a9
	sll	4,a9
	addi	p1oldwinstreak,a9
	move	*a9,a9
	movi	FIND_HIGH_TABLE_LEVEL,a11
	movi	STREAK_TAB,a5
	movi	enter_initials_streak,a10
	movi	do_entry,a7
	movi	AUD_WINSTREAK,a3

create_initial_input
	move	a8,a1
	addi	HI_INPUT_PID,a1
	calla	GETPRC
	move	a5,*a0(#which_tab),L
	move	a8,*a0(#stick)
	move	a10,*a0(#which_entry),L
	move	a11,*a0(#which_level),L
	move	a3,*a0(#which_aud)

#retp	RETP

 SUBR	do_that_cycle
	movi	[02h,1],a8		;cycle color A
	movi	FNT9RED_P,a9		;pal name
	movi	fnt9_red_white,a10	;use the LFLASH table
	movk	6,a11			;cycle speed
	CREATE	CYCPID,CYCLE_TABLE

	movi	[02h,1],a8		;cycle color A
	movi	FNT9WHT2P,a9		;pal name
	movi	fnt9_blue_white,a10	;use the LFLASH table
	movk	6,a11			;cycle speed
	CREATE	CYCPID,CYCLE_TABLE
	callr	hscore_colcyc
	callr	hscore_colcyc2
	rets

do_entry
	;convert score and wins to BCD
	move	a9,a0
	calla	BINBCD
	move	a0,a9
do_entry_time
	move	a9,a0

	clr	a3
	move	*a13(#which_tab),a8,L
	callr	CHECK_SCORE

	jrz	#done_jake_hack

no_we_can_come_back
	;they made one of the tables.  first update AUD_LSCORE
	move	a0,a1
	move	*a13(#which_aud),a0
	calla	KILL_AUD
	calla	AUD

SPECIAL_ENTRY
	movk	1,a14
	move	a14,@auto_init
	MOVE	*A13(#stick),a1
	MOVE	a1,a2
	sll	5,a1
	sll	4,a2
	add	a2,a1
	addi	entered_inits,a1
	move	*a1,a0,L
	JRNZ	NO_NEED_TO_ENTER

	clr	a14
	move	a14,@auto_init

	CREATE0	howard_wins

	PUSHP	a9

	MOVE	*A13(#which_entry),A1,L
	GETPC	A7
	ADDI	040h,A7
	MOVE	A7,-*A12,L	;PUSH RET ADDR
	JUMP	A1

	PULLP	a9

	MOVI	0B8H,A0
	CALLA	triple_sound

	MOVE	*A13(#stick),a1
	MOVE	a1,a2
	sll	5,a1
	sll	4,a2
	add	a2,a1
	addi	entered_inits,a1
NO_NEED_TO_ENTER
	move	a9,a0
	move	*a13(#which_tab),a8,L
	cmpi	BEATEN_TAB,a8
	JREQ	SPECIAL_ADDITION
	CMPI	INTER_TAB,A8
	JREQ	SPECIAL_ADDITION
	CMPI	TAG_TAB,A8
	JRNE	normal_addition
	CALLR	TAG_ENTRY
	jruc	#done
SPECIAL_ADDITION
	callr	SPECIAL_ADD_ENTRY
	CALLR	SORT_BEATEN_TABLE
	jruc	#done

normal_addition
	callr	ADD_ENTRY
#done

	movi	CYCPID,a0
	movi	-1,a1
	calla	KILALL
	DIE

#done_jake_hack
	movi	17,a0
	move	*a13(#which_tab),a8,L
	cmpi	TAG_TAB,a8
	jreq	no_we_can_come_back	

	movi	CYCPID,a0
	movi	-1,a1
	calla	KILALL
	DIE

fnt9_blue_white
	.word	0001fH,07FFFH
	.word	-1

fnt9_red_white
	.word	07C00H,07FFFH
	.word	-1

*****************************************************************************
* proc pointer + #stick = stick (0:1)

; SUBR	enter_message
;	clr	a0
;	movb	a0,@entered_message
;	movb	a0,@entered_message+40h
;	movi	entered_message,a4
;	move	a4,a5
;	movi	entered_message+(15*8),a6
;	PUSHP	a4,a5,a6
;
;	movi	#entermess_mes,a2
;	PUSHP	a2
;	jruc	#go

 SUBR	enter_initials_beaten

	movi	entered_inits,a4
	move	a4,a5
	movi	entered_inits+(5*8),a6
	movi	#enterinita_mess,a3
	movi	#enterinit5_mes,a2
	move	*a13(#stick),a0
	move	a0,a0
	jrz	#enter_mess_set_3
	movi	entered_inits+030h,a4
	move	a4,a5
	movi	entered_inits+(5*8)+030h,a6
	movi	#enterinitb_mess,a3
	movi	#enterinit6_mes,a2
#enter_mess_set_3
	clr	a14
	move	a14,*a4,L	;clear out initials
	move	a14,*a4(018h)	;clear out initials
	PUSHP	a4,a5,a6
	PUSHP	a2
	move	a3,a2
	calla	setup_message

	move	*a13(#stick),a0
	addi	CLSNEUT|TYPTEXT|00A3h,a0
	move	a0,@mess_objid

	move	*a2+,a0,L		;print method
	move	a2,a4			;* text string
	call	a0
	jruc	#go

 SUBR	enter_initials_streak

	CLR	A2
	MOVE	A2,@IGNORE_CHAR_WIDTH

	movi	#enterinit7_mes,a2
	move	*a13(#stick),a0
	jrz	just_add_to_id
	movi	#enterinit8_mes,a2
just_add_to_id
	PUSH	A0
	calla	setup_message
	PULL	A0
	addi	CLSNEUT|TYPTEXT|00A3h,a0
	move	a0,@mess_objid

	move	*a2+,a0,L		;print method
	move	a2,a4			;* text string
	call	a0

	move	@mess_cursx2,a0
	addi	8,a0
	move	a0,@mess_cursx

	movk	2,a0
	move	a0,@mess_spacing

	move	@p1oldwinstreak,a0
	move	*a13(#stick),a2
	jrz	got_right_streak
	move	@p2oldwinstreak,a0
got_right_streak
	movi	9999999,a1
	calla	dec_to_asc		;convert to ASCII
	CALLA	copy_string
	calla	print_string

	movi	entered_inits,a4
	move	a4,a5
	movi	entered_inits+(3*8),a6
	movi	#enterinita_mess,a3
	movi	#enterinit1_mes,a2
	move	*a13(#stick),a0
	move	a0,a0
	jrz	#enter_mess_set_1
	movi	entered_inits+030h,a4
	move	a4,a5
	movi	entered_inits+(3*8)+030h,a6
	movi	#enterinitb_mess,a3
	movi	#enterinit2_mes,a2
#enter_mess_set_1
	clr	a14
	move	a14,*a4,L	;clear out initials
	move	a14,*a4(018h)	;clear out initials
	PUSHP	a4,a5,a6
	PUSHP	a2
	move	a3,a2
	calla	setup_message

	move	*a13(#stick),a0
	addi	CLSNEUT|TYPTEXT|00A3h,a0
	move	a0,@mess_objid

	move	*a2+,a0,L		;print method
	move	a2,a4			;* text string
	call	a0
	jruc	#go

*********************************
 SUBR	enter_initials_top_20

	movi	font9A_ascii,a0
	move	a0,@message_ascii,L

	move	@MATCH_TIMERS,a0,L
	movi	35,a3
	movi	FNT9WHT2P,a11
	move	*a13(#stick),a2
	jrz	got_right_time
	move	@MATCH_TIMERS+32,a0,L
	movi	FNT9RED_P,a11
	movi	270,a3
got_right_time
	addi	CLSNEUT|TYPTEXT|00A3h,a2
	move	a2,@mess_objid
	move	a11,@message_palette,L
	movi	16,a2
	move	a2,@mess_cursy
	move	a3,@mess_cursx
	calla	BCDBIN
	callr	val_to_dec_tenths_asc
	clr	a0
	move	A0,@IGNORE_CHAR_WIDTH
	move	a0,@mess_spacing
	calla	print_string

	move	@mess_cursx2,a0
	addi	6,a0
	move	a0,@mess_cursx

	movi	#enterinit9_mes,a4
	calla	print_string2

	movi	entered_inits,a4
	move	a4,a5
	movi	entered_inits+(3*8),a6
	movi	#enterinita_mess,a3
	movi	#enterinit3_mes,a2
	move	*a13(#stick),a0
	move	a0,a0
	jrz	#enter_mess_set
	movi	entered_inits+030h,a4
	move	a4,a5
	movi	entered_inits+(3*8)+030h,a6
	movi	#enterinitb_mess,a3
	movi	#enterinit4_mes,a2
#enter_mess_set
	clr	a14
	move	a14,*a4,L	;clear out initials
	move	a14,*a4(018h)	;clear out initials
	PUSHP	a4,a5,a6
	PUSHP	a2
	move	a3,a2

	calla	setup_message

	move	*a13(#stick),a0
	addi	CLSNEUT|TYPTEXT|00A3h,a0
	move	a0,@mess_objid

	move	*a2+,a0,L		;print method
	move	a2,a4			;* text string
	call	a0
#go

	PULLP	a2
	movk	13,a0
	move	a0,@mess_line_spacing

	calla	setup_message

	move	*a13(#stick),a0
	addi	CLSNEUT|TYPTEXT|00A3h,a0
	move	a0,@mess_objid

	move	*a2+,a0,L		;print method
	move	a2,a4			;* text string
	call	a0

	callr	draw_letter_grid	;draw the letter grid

	move	*a13(#stick),a1
	jrnz	#right_type
	TBL_OBJ	#cursor			;create cursor
	jruc	#cursor_type_set
#right_type
	TBL_OBJ	#cursor2			;create cursor
#cursor_type_set
	clr	a0
	move	a0,*a8(ODOFF),L
	movi	0101h,a0
	move	a0,*a8(OCONST)
	movi	#block_size,a0
	move	a0,*a8(OSIZEX)
	move	a0,*a8(OSIZEY)
	move	a8,*a13(#cursorimg),L

	move	*a13(#stick),a1
	jrnz	#right_hilite
	TBL_OBJ	#hilite1			;create hilite letter
	jruc	#hilite_set
#right_hilite
	TBL_OBJ	#hilite2			;create hilite letter
#hilite_set

	move	a8,*a13(#hiliteimg),L

	clr	a9
	callr	new_cursor_pos		;place them & set char img/pal


	;reg use (loop)
	; a4 *first initial ram
	; a5 *next initial ram
	; a6 *last initial ram
	; a8 scratch
	; a9 cursor position (0-29)
	;a10 hold count for repeat motion
	;a11 debounce timer

	PULLP	a4,a5,a6

	movi	65,a11
	move	a11,*a4

	callr	print_init_string

	clr	a11
	MOVI	700H,B5
	clr	b3

#loop
;this timer is done the hard way cos its 1:30 in the morning and I dont
;have the energy to be clever
	movk	1,b1
	cmpi	150*5,b5
	jrgt	no_need_for_timer
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10
	move	b5,b7
	movi	150,b1
	divs	b1,b7
	move	b3,b3
	jrnz	we_already_have_it
	movi	[83+40,0],a0
	move	*a13(#stick),a1
	jrz	which_edge_set
	movi	[322+40,0],a0
which_edge_set
	movi	[16,0],a1			;y pos
	movi	FNT9_5,a2
	movi	104+200,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	move	*a13(#stick),a5
	addi	CLSNEUT|TYPTEXT|00A3h,a5	;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	movi	FNT9WHT_P,b0
	calla	BEGINOBJWP
	move	a8,b3

	push	b3,b5
;	CREATE0	do_next_tick
;	movi	0B7H,a0
	MOVI	0AH,A0
	calla	triple_sound
	pull	b3,b5
we_already_have_it
	move	b3,a8
	move	b7,a0
	sll	5,a0
	addi	digits_tbl,a0
	move	*a0,a0,L		;* image
	move	*a8(OIMG),a1,L
	cmp	a0,a1
	jreq	no_change
	move	*a8(OCTRL),a1
	calla	change_image
	push	b3,b5
;	create0	do_next_tick
;	movi	0B7H,a0
	MOVI	0AH,A0
	calla	triple_sound
	pull	b3,b5
no_change

	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10
no_need_for_timer

	DEC	B5		;have a limit we'll wait
	JRZ	#done2
	move	b3,a2
	MOVE	B5,A0
	PUSHP	A0,a2,a4,a5,a6
	SLEEPK	1
	PULLP	A0,a2,a4,a5,a6
	MOVE	A0,B5
	move	a2,b3

	;button check
	move	*a13(#stick),a0
	calla	get_but_val_down
	move	a0,a0
	jrz	#stick_check

	;new press.  add a letter.
	move	a9,a0
	cmpi	28,a0
	jreq	#deletechar		;backspace?

	cmpi	29,a0
	jreq	#done2			;EOL?

	cmp	a5,a6
	jreq	#stick_check		;room for another char?

	sla	3,a0			;x8
	addi	#init_table2,a0
	movb	*a0,*a5
	addk	8,a5
	clr	a0
	movb	a0,*a5			;always keep a terminator in there.
	jruc	#added

#deletechar
	cmp	a4,a5
	jreq	#stick_check		;no chars to delete!
	subk	8,a5
	clr	a0
	movb	a0,*a5
	callr	print_init_string
	jruc	#stick_check

#added
	movi	0b1h,a0
	push	b3,b5
	calla	triple_sound
	pull	b3,b5

	;character added.
	callr	print_init_string

	;if that was the last character, move the cursor to the END char.
	cmp	a5,a6
	jrne	#stick_check

	movi	29,a9
	callr	new_cursor_pos

#stick_check
	dec	a11			;debounce check
	jrp	#loop			;too soon?

	move	*a13(#stick),a0
	calla	get_stick_val_down
	move	a0,a0
	jrz	#no_new_stick

	movi	#tstatic-#debounce_time,a10
	movi	#debounce_time,a11
	jruc	#adjust

#no_new_stick
	dec	a10
	jrnz	#loop			;holding and waiting

	;whee!  time to repeat-move
	move	*a13(#stick),a0
	calla	get_stick_val_cur
	movi	#tmoving,a10
#adjust
	X16	a0
	addi	#joytab,a0
	move	*a0,a0

	add	a0,a9
	jrn	#too_low
	cmpi	30,a9
	jrge	#too_high
	jruc	#just_right

#too_low
	addi	30,a9
	jruc	#just_right
#too_high
	subi	30,a9
	jruc	#just_right

#just_right
	;adjust cursor and character position
	move	a0,a0
	jrz	no_motion_sound
	movi	0c7h,a0
	move	*a13(#stick),a1
	jrz	motion_sound_set
	inc	a0
motion_sound_set
	push	b3,b5
	calla	triple_sound
	pull	b3,b5
no_motion_sound
	callr	new_cursor_pos
	move	a9,a0

	cmpi	28,a0
	jreq	#space_it

	cmpi	29,a0
	jreq	#space_it

	cmp	a6,a5
	jreq	#loop

	sla	3,a0 
	addi	#init_table2,a0
	movb	*a0,*a5
	clr	a0
	movb	a0,*a5(8)			;always keep a terminator in there.
	callr	print_init_string
	jruc	#loop

#backspace_it
	sla	3,a0 
	addi	#init_table2,a0
	subk	8,a5
	movb	*a0,*a5
	addk	8,a5

	clr	a0
	movb	a0,*a5  			;always keep a terminator in there.
	callr	print_init_string
	jruc	#loop

#space_it
	clr	a0
	movb	a0,*a5  			;always keep a terminator in there.
	callr	print_init_string
	jruc	#loop

#done2
	callr	are_inits_dirty
	jrnz	replace_dirty_inits
;	jrz	#not_dirty
;	move	a4,a5
;	clr	a0
;	movb	a0,*a5
;	callr	print_init_string
;	movi	28,a9
;	callr	new_cursor_pos
;	jruc	#stick_check
;#not_dirty
	.if 0
	calla	are_special_inits
	jrnz	#not_special_inits
	JSRP	prog_specials
#not_special_inits
	.endif

	MOVI	0cbh,A0
	MOVE	*A13(#stick),a1
	jrz	select_set
	inc	a0
select_set
	push	b3,b5
	CALLA	triple_sound
	pull	b3,b5

	pushp	a4
	PUSHP	A6
	sleep	30
	PULLP	A6
	pullp	a4

;;	move	*a13(#stick),a0
;	addi	CLSNEUT|TYPTEXT|00A5h,a0
;	calla	obj_del1c
;
;	move	*a13(#stick),a0
;	addi	CLSNEUT|TYPTEXT|00A3h,a0
;	calla	obj_del1c

	move	*a4,a0,L
	jrnz	#initials_have_content
replace_dirty_inits
	movk	6,a0
	calla	RNDRNG0
	sll	5,a0
	addi	#random_initials,a0
	move	*a0,A0,L
	move	a0,*a4,L
	CLR	A1
	MOVB	A1,*A4(020H)

#initials_have_content
	PUSH	a0
	move	*a13(#stick),a0
	addi	CLSNEUT|TYPTEXT|00A5h,a0
	calla	obj_del1c

	move	*a13(#stick),a0
	addi	CLSNEUT|TYPTEXT|00A3h,a0
	calla	obj_del1c
	PULL	a0

	CMPI	"TJM",a0
	jrne	no_worry_about_disaster

	push	a0
	movi	129h,a0
	move	@HCOUNT,a1
	srl	1,a1
	jrnc	we_now_which
	inc	a0
we_now_which
	CALLA	ADD_VOICE
	pull	a0
no_worry_about_disaster

	CMPI	"SMJ",a0
	jrne	no_worry_about_yes_indeedly
	push	a0
	movi	214h,a0
	CALLA	ADD_VOICE
	pull	a0

no_worry_about_yes_indeedly
	PUSH	A6
	SUB	A4,A6
	CMPI	18H,A6
	JRNE	A_FIVE_INITIALER

	MOVE	*A13(#stick),a1
	sll	4,a1
	addi	which_player,a1
	move	*a1,a9
	ADDI	"A",A9
	MOVB	A9,*A4(18H)

A_FIVE_INITIALER
	PULL	A6

	RETP

;do_next_tick
;	SLEEP	12
;	MOVI	0B8H,A0
;	CALLA	triple_sound
;	DIE

#random_initials
	.byte	"MJT",0
	.byte	"JYT",0
	.byte	"SAL",0
	.byte	"JMS",0
	.byte	"JAZ",0
	.byte	"RJR",0
	.byte	"MJL",0

#dw_table
	.long	00001ab1h		; FUQ
	.long	00001aa3h		; FUC
	.long	00001aabh		; FUK
	.long	000822b1h		; PHUQ
	.long	000822abh		; PHUK
	.long	000822a3h		; PHUC
	.long	010ace79h		; PUSSY
	.long	0102b933h		; PENIS
	.long	0024d068h		; BITCH
	.long	0009b2b4h		; SLUT
	.long	0009a134h		; SHIT
	.long	0001d5d4h		; CUNT
	.long	0001b134h		; CLIT
	.long	0001bc6bh		; COCK
	.long	000994e1h		; SEGA
	.long	0

; A4 = *beginning of string
; A0 = character to add
;
; Returns
;   Z  - Not dirty word
;   NZ - Dirty word
;
 SUBR	are_inits_dirty
	PUSH	a0,a1,a2,a4,a5,a6
	move	a4,a6
	subk	8,a6
#recheck
	addk	8,a6
	move	a6,a4
	movb	*a6,a2
	jrz	#not_dirty_word
	clr	a1
#get_inits_loop
	movb	*a4,a2
;	jrz	#gi_done
	jrz	#recheck
	cmpi	20h,a2
	jrz	#not_alpha
	cmpi	21h,a2
	jrz	#not_alpha
	cmpi	19h,a2
	jrz	#not_alpha
	sll	5,a1
	subi	40h,a2
	andi	1fh,a2
	or	a2,a1
	callr	#check_it
#not_alpha
	addk	8,a4
	jruc	#get_inits_loop
#gi_done

#check_it
	PUSH	a4
	movi	#dw_table,a4
	clr	a0
#check_dw_loop
	move	*a4+,a5,L
;	jrz	#not_dirty_word
	jrz	#check_done
	cmp	a1,a5
	jrz	#is_dirty
	jruc	#check_dw_loop
#check_done
	PULL	a4
	rets

#is_dirty
	PULL	a4,a14			; This sucks don't change this
	movk	1,a0			; or it will break
	jruc	#aid_exit
#not_dirty_word
	clr	a0
#aid_exit
	move	a0,a0
	PULL	a0,a1,a2,a4,a5,a6
	rets



****************************************
* moves the cursor and hilite char to their new positions.

 SUBRP	new_cursor_pos

	;x pos = #grid_x + #block_size * (index mod 6)
	move	a9,a1
	movk	5,a0
	modu	a0,a1
	movi	#block_size,a0
	mpyu	a0,a1
	move	*a13(#stick),a3
	SLL	6,A3
	ADDI	WHERE_BLOCK,A3
	MOVE	*A3(010h),A14
	add	a14,a1
	move	*a13(#cursorimg),a8,L
	move	a1,*a8(OXPOS)
	move	*a13(#hiliteimg),a8,L
	move	a1,*a8(OXPOS)

	;y pos = #grid_y + #block_size * (index / 6)
	move	a9,a1
	movk	5,a2
	divu	a2,a1
	movi	#block_size,a0
	mpyu	a0,a1
	move	*a3(030h),a14
	add	a14,a1
	move	*a13(#cursorimg),a8,L
	move	a1,*a8(OYPOS)
	move	*a13(#hiliteimg),a8,L
	move	a1,*a8(OYPOS)

	;adjust the character image
	move	a9,a0
	sla	3,a0		;x8
	addi	#init_table1,a0
	movb	*a0,a0
	X32	a0
	addi	font9_ascii,a0
	move	*a0,a0,L
	jrnz	#good_image
	movi	OSGEMD_DOT,a0
#good_image
	move	*a13(#hiliteimg),a8,L
	calla	civanic
	movi	FNT9YEL_P,a0
	calla	pal_getf
	move	a0,*a8(OPAL)
	move	*a8(OSIZEX),a14		;center it
	subi	#block_size,a14
	sra	1,a14
	move	a14,*a8(ODXOFF)
	move	*a8(OSIZEY),a14
	subi	#block_size,a14
	sra	1,a14
	move	a14,*a8(ODYOFF)

	rets


****************************************
* deletes the old displayed init string (if any) and makes a new one.

 SUBRP	print_init_string

	push	b5,b3
	PUSH	a0,a1,a2,a3,a4,a5,a6,a7,a8
	PUSH	a4
	move	*a13(#stick),a0
	addi	CLSNEUT|TYPTEXT|00A5h,a0
	calla	obj_del1c

	movi	#currentinit1_mes,a2
	move	*a13(#stick),a3
	jrz	#current_mess_set
	movi	#currentinit2_mes,a2
#current_mess_set

	calla	setup_message

	move	*a13(#stick),a0
	addi	CLSNEUT|TYPTEXT|00A5h,a0
	move	a0,@mess_objid

	PULL	a4
	calla	print_string_C2

	PULL	a0,a1,a2,a3,a4,a5,a6,a7,a8
	pull	b5,b3
	
	rets

****************************************
* draw the letter grid

 SUBRP	draw_letter_grid

	movi	FNT9YEL_P,a0
	calla	pal_getf
	move	a0,a11

	move	*a13(#stick),A1
	SLL	6,A1
	ADDI	WHERE_BLOCK,A1
	MOVE	*A1+,A0,L
	MOVE	*A1,A1,L
	MOVE	A0,B2
	SUBI	[#block_size,0],B2

	movi	#init_table1,a9
	movi	30,a10
	jruc	#draw_loop

#draw_incy
	MOVE	B2,A0
	addi	[#block_size,0],a1
#draw_incx
	addi	[#block_size,0],a0

#draw_loop
	movb	*a9,a2
	addk	8,a9
	X32	a2
	addi	font9_ascii,a2
	move	*a2,a2,L
	jrnz	#draw_okimg

	;bad image
	movi	OSGEMD_DOT,a2

#draw_okimg
	clr	a3
	movi	DMAWNZ,a4
	move	*a13(#stick),a5
	addi	CLSNEUT|TYPTEXT|00A3h,a5
	clr	a6
	clr	a7
	PUSH	a0,a1
	movi	FNT9YEL_P,b0
	calla	BEGINOBJP
	PULL	a0,a1
	move	a11,*a8(OPAL)			;set the palette

	;center the image in its' box
	move	*a8(OSIZEX),a14
	subi	#block_size,a14
	sra	1,a14
	move	a14,*a8(ODXOFF)

	move	*a8(OSIZEY),a14
	subi	#block_size,a14
	sra	1,a14
	move	a14,*a8(ODYOFF)

	dec	a10
	jrz	#draw_done

	move	a10,a6
	movi	5,a7
	modu	a7,a6
	jrz	#draw_incy
	jruc	#draw_incx

#draw_done
	rets

****************************************
* enter inits config stuff
crap_off		.equ	5
WHERE_BLOCK
	.LONG	[32+crap_off,0]	;X
	.LONG	[59,0]	;Y

	.LONG	[273+crap_off,0]	;X
	.LONG	[59,0]	;Y

#init_table1	.STRING	"ABCDEFGHIJKLMNOPQRSTUVWXYZ!",>10,>11,>12
#init_table2	.STRING	"ABCDEFGHIJKLMNOPQRSTUVWXYZ!",>20,>11,>12

#grid_x		equ	200		;x position of letter grid
#grid_y		equ	100		;y position of letter grid
#block_size	equ	18		;x & y spacing of letter grid

#tstatic	equ	30		;ticks before repeat motion begins
#tmoving	equ	10		;ticks between repeat motions
#debounce_time	equ	8		;min ticks between stick changes

#enterinit_mod
	.long	wwfselbkBMOD		;wrestler select map
	.word	-44,0
	.long	0

#currentinit1_mes
	JAM_STR	osgemd_ascii,10,1,77+crap_off,204,BLUE,print_string_C2
	.byte	"A",0
	.even

#currentinit2_mes
	JAM_STR	osgemd_ascii,10,1,315+crap_off,204,RUBYPAL,print_string_C2
	.byte	"A",0
	.even

#enterinita_mess
	JAM_STR	font9_ascii,8,0,76+crap_off,179,FNT9WHT2P,print_string_C2
	.byte	"ENTER INITIALS",0,0
	.even

#enterinitb_mess
	JAM_STR	font9_ascii,8,0,286+crap_off+29,179,FNT9RED_P,print_string_C2
	.byte	"ENTER INITIALS",0,0
	.even

#enterinit1_mes
	JAM_STR	font9_ascii,4,0,77+crap_off,38,FNT9WHT2P,print_string_C2
	.byte	"WIN STREAK !",0,0
	.even	   

#enterinit2_mes
	JAM_STR	font9_ascii,4,0,317+crap_off,38,FNT9RED_P,print_string_C2
	.byte	"WIN STREAK !",0,0
	.even

#enterinit3_mes
	JAM_STR	font9_ascii,4,0,77+crap_off,38,FNT9WHT2P,print_string_C2
	.byte	"FAST VICTORY",0,0
	.even

#enterinit4_mes
	JAM_STR	font9_ascii,4,0,317+crap_off,38,FNT9RED_P,print_string_C2
	.byte	"FAST VICTORY",0,0
	.even

#enterinit5_mes
	JAM_STR	font9_ascii,4,0,77+crap_off,38,FNT9WHT2P,print_string_C2
	.byte	"BEATEN GAME",0,0
	.even

#enterinit6_mes
	JAM_STR	font9_ascii,4,0,317+crap_off,38,FNT9RED_P,print_string_C2
	.byte	"BEATEN GAME",0,0
	.even

#enterinit7_mes
	JAM_STR	font9_ascii,4,0,45+crap_off,16,FNT9WHT2P,print_string_C2
	.byte	"WINS : ",0,0
	.even

#enterinit8_mes
	JAM_STR	font9_ascii,4,0,285+crap_off,16,FNT9RED_P,print_string_C2
	.byte	"WINS : ",0,0
	.even

#enterinit9_mes
	.byte	"SEC.",0,0
	.even

#entermess_mes
	JAM_STR	osgemd_ascii,10,0,200+crap_off,10,BLUE,print_string_C2
	.byte	"ENTER A MESSAGE",0,0
	.even

#cursor	.word	0,0,10					;X, Y, Z
	.long	jmeter					;IMG
	.word	DMACAL					;CTRL
	.word	CLSNEUT|TYPTEXT|00A3h
	.long	0,0					;XVEL, YVEL
	.even

#cursor2	.word	0,0,10					;X, Y, Z
	.long	#jmeter2					;IMG
	.word	DMACAL					;CTRL
	.word	CLSNEUT|TYPTEXT|00A4h
	.long	0,0					;XVEL, YVEL
	.even

#jmeter2
	.word   175,13,2,2
	.long   040427fcH
	.word   02000H
	.long   #jmeter2_p

#jmeter2_p
	.word	  5
	.word	00H,7d00H,07F60H,01E0H,00H

#hilite1	.word	0,0,20					;X, Y, Z
	.long	FNT9_A
	.word	DMAWNZ					;CTRL
	.word	CLSNEUT|TYPTEXT|00A3h
	.long	0,0					;XVEL, YVEL
	.even

#hilite2	.word	0,0,20					;X, Y, Z
	.long	FNT9_A
	.word	DMAWNZ					;CTRL
	.word	CLSNEUT|TYPTEXT|00A4h
	.long	0,0					;XVEL, YVEL
	.even

#joytab				;RLDU
	.word	0		;0000
	.word	-5		;0001
	.word	5		;0010
	.word	0		;0011
	.word	-1		;0100
	.word	-6		;0101
	.word	4		;0110
	.word	-1		;0111
	.word	1		;1000
	.word	-4		;1001
	.word	6		;1010
	.word	1		;1011
	.word	0		;1100
	.word	-5		;1101
	.word	5		;1110
	.word	0		;1111

********************************
*INITIAL ENTRY JOYSTICK TABLE
	
*INITIAL MATRIX


**************************************************************************
*
*	CHECK_INITS
*
*	A1 POINTS AT A SET OF INITIALS ENTERED. RETURN .EQ.
*	IF THEY'RE ALL SPACES (OR ZERO).
*
**************************************************************************
CHECK_INITS:
	MMTM	SP,A0,A1,A2
	MOVI	NUM_INITS,A2
CHECK_NEXT:
	MOVB	*A1,A0			;GET AN INITIAL
	JRZ	SPACE_FOUND		;NULL IS A SPACE
	CMPI	SPACE,A0		;IS IT A REAL SPACE?
	JRNZ	LET_FOUND
SPACE_FOUND:
	ADDI	BYTE_SIZE,A1
	DSJS	A2,CHECK_NEXT
	CLR	A2			;SET Z BIT ON FALL THROUGH

LET_FOUND:
	MMFM	SP,A0,A1,A2
	RETS

**************************************************************************
*
*	CHECK_SCORE
*
*	THIS IS CALLED WITH A SCORE IN A0 TO SEE IF IT
*	IS HIGH ENOUGH TO MAKE THE TABLE.
*
*	THE OTHER PLAYER'S SCORE IS PASSED IN A2. IF
*	THE PLAYER MAKES THE LAST POSITION OF THE TABLE,
*	THEN HIS SCORE IS COMPARED AGAINST THE OTHER SCORE
*	IT MUST BE HIGHER THAN THE OTHER SCORE, OTHERWISE
*	HE WILL ENTER HIS INITIALS, BUT THERE WILL BE NO
*	PLACE TO PUT THEM WHEN HIS BUDDY IS DONE ENTERING HIS!
*
*	THIS ROUTINE CALLS FIND_TABLE_LEVEL WHICH RETURNS
*	THE POINT IN THE TABLE THAT THE PASSED SCORE WOULD
*	LAND.   THIS VALUE MUST BE LESS THAN OR EQUAL TO
*	THE "TB_VISIBLE" VALUE FOR THE TABLE.  THIS WOULD
*	MEAN THAT WE WANT TO GET THE PLAYER'S INITIALS.
*
*	A8 CONTAINS ROM POINTER FOR TABLE TO CHECK.
*	RETURN A0 = 0 (AND .EQ.) IF SCORE ISN'T HIGH ENOUGH
*	AND A0 = POSITION IN TABLE IF SCORE MAKES IT.
*
**************************************************************************
 SUBR	CHECK_SCORE
	MMTM	SP,A1,A3,A9,A10
	MOVE	A0,A3			;STASH SCORE IN A3
	move	*a13(#which_level),a10,L
	call	a10

;	CALLR	FIND_TABLE_LEVEL	;SEE WHERE WE LAND IN THIS TABLE

	JRZ	ANSWER_IN_A0		;ZERO.....GUY DIDN'T MAKE IT
	MOVE	*A8(TB_VISIBLE),A1,W	;GET THE NUMBER "ENTERED"
	CMP	A1,A0			;A0 MUST BE LESS OR EQUAL
	JRLO	ANSWER_IN_A0		;NOT LAST ENTRY...RETURN SUCCESS

;	JRHI	DIDNT_MAKE_HSTD
*
*	GUY IS GOING FOR LAST POSITION.....SEE IF HIS BUDDY IS
*	GOING TO NOSE HIM OUT:
*
*	^^^^^^^^^^ not anymore !! ^^^^^^^
;	CMP	A2,A3			;HI MUST BE HIGHER THAN BUDDY
;	JRHI	ANSWER_IN_A0
;
;DIDNT_MAKE_HSTD:
	CLR	A0			;RETURN FAILURE
ANSWER_IN_A0:
	MOVE	A0,A0			;SET EQ BIT ACCORDINGLY
	MMFM	SP,A1,A3,A9,A10
	RETS

SORT_BEATEN_TABLE
	PUSH	A1
	MOVE	*A13(#which_tab),A8,L
;	MOVI	BEATEN_TAB,A8
	CALLR	ROM_PTRS
	MOVE	*A13(#which_aud),A0
;	MOVI	AUD_BEATEN,A0
	CALLA	GET_AUD
	MOVE	A1,A0
	PULL	A1
	MOVE	A0,A6
	CALLR	TEST_NUM_ICON
	MOVE	A3,A5

	MOVK	1,A0
	MOVI	BEATEN_TAB_ENTRIES,A10
TEST_NEXT_BEATEN_ENTRY
	CALLR	TEST_NUM_ICON
	CMP	A3,A5
	JRGE	THIS_IS_IT
	INC	A0
	DSJS	A10,TEST_NEXT_BEATEN_ENTRY
NO_MOVEMENT
	RETS

THIS_IS_IT
	CMP	A0,A6
	JREQ	NO_MOVEMENT
	MOVE	A6,A10
	MOVE	A10,A3

	MOVE	*A13(#which_tab),A8,L
	CALLR	ROM_PTRS
	PUSH	A0,A1
	MOVE	*A13(#which_aud),A0
	CALLA	GET_AUD
	MOVE	A1,A0
	CALLR	GET_HSCR
	MOVE	A1,A4
	PULL	A0,A1
	PUSH	A0,A1
	MOVE	A0,A1
	MOVE	*A13(#which_aud),A0
	calla	KILL_AUD
	calla	AUD
	PULL	A0,A1
	MMTM	SP,A0,A1,A2,A3,A4,A7,A9,A10
	JRUC	COPY_DOWN_LOOP

TEST_NUM_ICON
	PUSH	A1
	CALLR	GET_HSCR
	CLR	A3
	MOVK	8,A4
TEST_NEXT_NYBBLE
	SRL	1,A1
	JRNC	NO_IN_A3
	INC	A3
NO_IN_A3
	SRL	3,A1
	DSJS	A4,TEST_NEXT_NYBBLE
	PULL	A1
	RETS

COMPARE_INITIALS
	MOVK	1,A0			;START AT 1 AND WORK UP.
	CALLR	VAL_TAB 		;FIX THE TABLE IN CASE ITS BROKEN.
	JRC	#NOT_MATCHED
COMPARE_NEXT
	CALLR	COMPARE_INITS
	JRNC	MATCHED
	INC	A0
	CMP	A10,A0
	JRNE	COMPARE_NEXT
	CLR	A0
MATCHED
	MOVE	A0,A0
	RETS
#NOT_MATCHED
	MOVI	-1,A0
	RETS

COMPARE_INITS
	PUSH	A0
	MOVE	A1,A6
	CALLA	PT_ENTRY
	ADDI	HS_INITS,A7		;POINT AT FIRST INITIAL
	MOVI	NUM_INITS,A2		;THIS IS NUMBER OF INITIALS
#INIT_COPY_LOOP
	CALLR	RC_BYTEI
	MOVE	A0,A5
	JRNZ	#NOT_BLANK
	MOVI	SPACE,A5		;REPLACE BLANKS WITH SPACES
#NOT_BLANK:
	MOVB	*A6,A11
	JRNZ	#NOT_A_SPACE
	MOVI	SPACE,A11		;REPLACE BLANKS WITH SPACES
	MOVB	A11,*A6
#NOT_A_SPACE
	CMP	A5,A11
	JRNE	NOT_MATCHED
	ADDK	8,A6
	DSJ	A2,#INIT_COPY_LOOP
	PULL	A0
	CALLR	GET_HSCR
	OR	A1,A4
	CLRC
	RETS
NOT_MATCHED
	PULL	A0
	SETC
	RETS

SPECIAL_ADD_ENTRY
	MMTM	SP,A0,A1,A2,A3,A4,A7,A9,A10
	CALLR	ROM_PTRS		;SETUP FOR THIS TABLE
	MOVE	A0,A4
	PUSH	A1
	CALLR   COMPARE_INITIALS
	JRNZ	INSERT_HERE
	JRN	DIDNT_MAKE_IT
	MOVE	A10,A0

INSERT_HERE
	PUSH	A0
	MOVE	A0,A1
	MOVE	*A13(#which_aud),A0
	calla	KILL_AUD
	calla	AUD
	PULL	A0
	PULL	A1
	MOVE	A10,A3
	SETC
	JRUC	COPY_DONE

TAG_ENTRY:
	MMTM	SP,A0,A1,A2,A3,A4,A7,A9,A10
	CALLR	ROM_PTRS		;SETUP FOR THIS TABLE
	MOVE	A0,A4			;STASH THE SCORE A SEC.
	CLR	A2			;DONT WORRY ABOUT OTHER GUY AT THIS POINT
	CALLR	CHECK_SCORE		;DOES THE REQUEST MAKE IT?
	SETC				;ANTICIPATE FAILURE
	JRZ	SPECIAL_DIDNT_MAKE_IT		;DON'T KNOW WHY I GOT THESE INITS.
	MOVE	A10,A3			;LAST GUY IN TABLE IS DESTINATION
   	JRUC	COPY_DOWN_LOOP
SPECIAL_DIDNT_MAKE_IT
	MOVK	17,A0
	MOVE	A10,A3			;LAST GUY IN TABLE IS DESTINATION
   	JRUC	COPY_DOWN_LOOP

**************************************************************************
*
*	ADD_ENTRY
*
*	THIS IS CALLED AFTER "ENTER YOUR INITIALS" TO
*	ADD AN ENTRY TO THE TABLE. A0 CONTAINS THE
*	SCORE OF THE PLAYER. A1 CONTAINS A POINTER
*	TO THE FETCHED INITIALS. THE INITIALS ARE
*	STORED AS CONSECUTIVE BYTES IN CONVENTIONAL
*	(1 BYTE TAKES 1 BYTE SPACE) RAM.
*
*	A8 contains a the table to store the entry in.
*
*	RETURN CARRY SET IF IT DIDN'T MAKE IT INTO REQUESTED TABLE
*
**************************************************************************
ADD_ENTRY:
	MMTM	SP,A0,A1,A2,A3,A4,A7,A9,A10
	CALLR	ROM_PTRS		;SETUP FOR THIS TABLE
	MOVE	A0,A4			;STASH THE SCORE A SEC.
	CLR	A2			;DONT WORRY ABOUT OTHER GUY AT THIS POINT
	CALLR	CHECK_SCORE		;DOES THE REQUEST MAKE IT?
	SETC				;ANTICIPATE FAILURE
	JRZ	DIDNT_MAKE_IT		;DON'T KNOW WHY I GOT THESE INITS.
*
*	A0 NOW HAS THE PLACE FOR THE NEW GUY.
*	MOVE THE ENTIRE TABLE DOWN 1 UNIT.
*
	MOVE	A10,A3			;LAST GUY IN TABLE IS DESTINATION

COPY_DOWN_LOOP:
	MOVE	A3,A2			;GUY BEFORE HIM IS SOURCE
	DEC	A2			;A2 NOW HAS SOURCE
	CMP	A0,A2			;IS SOURCE LOWER THAN OUR SLOT?
	JRLO	COPY_DONE		;IT IS...DON'T MOVE HIM.

	CALLR	COPY_ENTRY		;COPY A2 ENTRY TO A3
	DEC	A3			;MOVE DOWN TO ONE BEFORE
	JRUC	COPY_DOWN_LOOP

COPY_DONE:
	CALLR	PUT_SCORE_FOR_ENTRY	;SCORE IN A4 WRITTEN TO ENTRY A0
*
*	INITAIAL POINTER IS IN A1
*	TABLE OFFSET IN A0
*
	CALLR	PT_ENTRY		;GET ENTRY POINTER IN A7
	ADDI	HS_INITS,A7		;POINT AT FIRST INITIAL
	MOVI	NUM_INITS,A2		;THIS IS NUMBER OF INITIALS
	MMTM	SP,A0			;SAVE A0

INIT_COPY_LOOP:
	MOVB	*A1,A0			;GET AN INITIAL
	JRNZ	NOT_BLANK
	MOVI	SPACE,A0		;REPLACE BLANKS WITH SPACES
NOT_BLANK:
	CALLR	WC_BYTEI		;WRITE THE BYTE AND INCREMENT
	ADDI	BYTE_SIZE,A1		;A1 TO NEXT BYTE PLEASE
	DSJ	A2,INIT_COPY_LOOP

	MMFM	SP,A0			;GET BACK ENTRY NUMBER
	CALLR	FORM_HS_CKSUM_AND_STORE	;FOR CHECKSUM FOR THIS ENTRY AND STORE!
	CLRC				;RETURN SUCCESS!

DIDNT_MAKE_IT
	MMFM	SP,A0,A1,A2,A3,A4,A7,A9,A10
	RETS

#**************************************************************************
*
*	FIND_TABLE_LEVEL
*
*	THIS IS CALLED TO COMPARE THE SCORE IN A0 TO
*	THE TABLE POINTED TO BY A8.
*
*	RETURN PHYSICALLY WHERE IT FITS IN A0, AND
*	SET THE Z FLAG ACCORDINGLY
*
**************************************************************************
FIND_HIGH_TABLE_LEVEL
	MMTM	SP,A1,A2,A3
	CALLR	ROM_PTRS		;SETUP FOR THIS TABLE
	CALLR	VAL_TAB 		;FIX THE TABLE IN CASE ITS BROKEN.
	JRC	#FTL_FAIL		;CAN'T VALIDATE..SAY SCORE DIDN'T MAKE IT

	MOVE	A0,A2			;KEEP SCORE IN A2
	MOVK	1,A0			;START AT 1 AND WORK UP.

#CHECK_NEXT_SCORE:
	CALLR	GET_HSCR		;FETCH A0 ENTRY'S SCORE IN A1
	CMP	A1,A2			;HOW DO WE FARE AGAINST A1?
	JRGE	#FOUND_THE_SPOT		;WE FOUND THE SPOT
	INC	A0			;KEEP MOVING DOWN TILL WE FIT
	CMP	A10,A0			;ARE WE LOOKING AT THE LAST ONE?
	JRLS	#CHECK_NEXT_SCORE

#FTL_FAIL:
	CLR	A0			;WE'RE NOT HIGH ENOUGH RETURN FAILURE

#FOUND_THE_SPOT:
	MOVE	A0,A0			;MAKE SURE YOU SET THE FLAGS
	MMFM	SP,A1,A2,A3
	RETS

#**************************************************************************
*
*	FIND_TABLE_LEVEL
*
*	THIS IS CALLED TO COMPARE THE SCORE IN A0 TO
*	THE TABLE POINTED TO BY A8.
*
*	RETURN PHYSICALLY WHERE IT FITS IN A0, AND
*	SET THE Z FLAG ACCORDINGLY
*
**************************************************************************
 SUBR	FIND_LOW_TABLE_LEVEL
	MMTM	SP,A1,A2,A3
	CALLR	ROM_PTRS		;SETUP FOR THIS TABLE
	CALLR	VAL_TAB 		;FIX THE TABLE IN CASE ITS BROKEN.
	JRC	#FTL_FAIL		;CAN'T VALIDATE..SAY SCORE DIDN'T MAKE IT

	MOVE	A0,A2			;KEEP SCORE IN A2
	MOVK	1,A0			;START AT 1 AND WORK UP.

#CHECK_NEXT_SCORE:
	CALLR	GET_HSCR		;FETCH A0 ENTRY'S SCORE IN A1
	CMP	A1,A2			;HOW DO WE FARE AGAINST A1?
	JRLO	#FOUND_THE_SPOT
;	JRHI	#FOUND_THE_SPOT		;WE FOUND THE SPOT
	INC	A0			;KEEP MOVING DOWN TILL WE FIT
	CMP	A10,A0			;ARE WE LOOKING AT THE LAST ONE?
	JRLS	#CHECK_NEXT_SCORE

#FTL_FAIL:
	CLR	A0			;WE'RE NOT HIGH ENOUGH RETURN FAILURE

#FOUND_THE_SPOT:
	MOVE	A0,A0			;MAKE SURE YOU SET THE FLAGS
	MMFM	SP,A1,A2,A3
	RETS


**************************************************************************
*
*	GET_HSCR
*
*	THIS IS CALLED TO FETCH THE SCORE FROM CMOS FOR
*	A GIVEN ENTRY.
*
*	ENTRY NUMBER PASSED IN A0.
*	SCORE RETURNED IN A1.
*
**************************************************************************
GET_HSCR
	MMTM	SP,A7,A0
	CALLR	PT_ENTRY		;POINT A7 AT ENTRY
	ADDI	HS_SCORE,A7		;INDEX SCORE PART.
	CALLR	RC_LONG 		;FETCH THE LONG WORD INTO A0
	MOVE	A0,A1			;MOVE TO A1
	MMFM	SP,A7,A0
	RETS

**************************************************************************
*
*	PUT_SCORE_FOR_ENTRY
*
*	THIS IS CALLED TO WRITE OUT THE SCORE FOR A GIVEN ENTRY.
*	ENTRY SPECIFIED BY A0.
*	SCORE PASSED IN A4.
*
**************************************************************************
PUT_SCORE_FOR_ENTRY
	MMTM	SP,A7,A0
	CALLR	PT_ENTRY		;POINT A7 AT ENTRY
	ADDI	HS_SCORE,A7		;INDEX SCORE PART.
	MOVE	A4,A0			;MOVE SCORE TO A0
	CALLR	WC_LONG 		;WRITE OUT THE LONG WORD
	MMFM	SP,A7,A0
	RETS

**************************************************************************
*
*	LOW LEVEL HSTD PROCESSING
*
**************************************************************************
*
*	 FOR HIGH SCORE ROUTINES
*
*	 A8  = ROM POINTER FOR A GIVEN TABLE STATS
*	 A9  = RAM POINTER FOR CMOS DATA
*	 A10 = NUMBER OF ENTRIES IN THE TABLE
*
*	 A0  = PARTICULAR ENTRY TO DEAL WITH
*		 0 = FILL ENTRY (POINTER ROUTINES POINT HERE IF ERROR)
*		 1 = HIGHEST SCORE IN TABLE
*		 N = NTH SCORE
*
*	 A1  = OUTPUT OF CHECKSUM ROUTINE (BYTE)
*
*	 A7  = POINTER TO CURRENT ENTRY
*
*	 A4,A5,A6 SCRATCH
*
**************************************************************************
*
*	FORM_HS_CKSUM
*
*	THIS IS CALLED TO FORM THE CHECKSUM FOR THE SCORE
*	NUMBER IN A0. (RAM POINTER ASSUMED IN A9).
*	CHECKSUM IS RETURNED IN A1.	 THIS IS A *BYTE*.
*
*	CHECKSUM IS COMPUTED AS THE COMPLEMENT OF THE SIMPLE SUM
*	OF THE BYTES IN THE ENTRY.
*
*	THIS ROUTINE RETURNS WITH THE Z BIT SET (.EQ.) IF THE
*	CHECKSUM FOR THIS ENTRY MATCHES.
*
**************************************************************************
FORM_HS_CKSUM:
	MMTM	SP,A0,A4,A6,A7
	CALLR	PT_ENTRY		;A7 = POINTER TO CURRENT ENTRY
	MMTM	SP,A7			;SAVE POINTER TO ENTRY
	MOVI	HS_BYTES_TO_CHECK,A4	;COUNT DOWN THE BYTES
	CLR	A1			;KEEP SUM IN A1
ADD_A_BYTE:
	CALLR	RC_BYTEI		;GET A BYTE INTO A0
	ADD	A0,A1			;ADD TO SUM
	DSJ	A4,ADD_A_BYTE		;ONE MORE ADDED
	NOT	A1			;CHECKSUM IS NOW IN LOW BYTE
	ANDI	BYTE_MASK,A1		;MASK SO ITS COOL
	MMFM	SP,A7			;GET POINTER BACK
	ADDI	HS_CKBYTE,A7		;POINT AT CHECKBYTE
	CALLR	RC_BYTE 		;READ IN THE BYTE
	CMP	A0,A1			;COMPARE WHAT'S THERE TO WHAT WE GOT
	MMFM	SP,A0,A4,A6,A7		;Z BIT RETURNS COMPARE
	RETS				;A1 RETURNS CKSUM

**************************************************************************
*
*	FORM_HS_CKSUM_AND_STORE
*
*	THIS IS USED TO SET THE CHECKSUM FOR THE CURRENT
*	ENTRY (A0) TO THE CORRECT VALUE.
*
**************************************************************************
FORM_HS_CKSUM_AND_STORE:
	MMTM	SP,A0,A7
	CALLR	FORM_HS_CKSUM		;GET THE CKSUM IN A1, POINTER IN A7
	CALLR	PT_ENTRY		;POINT AT THE VALUE
	ADDI	HS_CKBYTE,A7		;POINT AT CHECKBYTE
	MOVE	A1,A0			;GET CHECKBYTE TO A0
	CALLR	WC_BYTE 		;WRITE OUT THE BYTE
	MMFM	SP,A0,A7
	RETS

**************************************************************************
*
*	PT_ENTRY
*
*	THIS IS CALLED TO POINT AT A GIVEN ENTRY OF
*	THE HIGH SCORE TABLE.  THIS ROUTINE BASES
*	ACTIVITY ON ROM POINTER IN A8.  IT FETCHES
*	FRESH COPIES OF THE A9 RAM POINTER AND THE
*	A10 ENTRY COUNTER.  IT RETURNS THE ENTRY
*	POINTER IN A7.
*
*	A0 SPECIFIES WHICH ENTRY TO POINT AT
*	A8,A9,A10 AND SYSCTRL ASSUMED SET PROPERLY
*	A7 RETURNED POINTING TO THAT ENTRY
*
**************************************************************************
PT_ENTRY:
	CMP	A10,A0			;A10 IS MAX VALUE
	JRLS	POINTER_IN_RANGE

	.IF DEBUG
	LOCKUP
	.ENDIF

	MOVE	A9,A7			;RETURN ZERO OFFSET IN FIELD
	RETS

POINTER_IN_RANGE:
	MOVI	HS_SIZE,A7		;SIZE OF ENTRY
	MPYU	A0,A7			;OFFSET OF ENTRY
	ADD	A9,A7			;ADD IN THE BASE
	RETS

**************************************************************************
*
*	ROM_PTRS
*
*	THIS IS CALLED TO LOAD UP THE ROM STRUCTURE
*	DATA INTO REGISTERS.
*
*	THIS ALSO SETS UP STATUS WORD TO SELECT THE CMOS
*	BANK SELECT FOR WHERE THE PARTICULAR TABLE RESIDES.
*
*	INPUT A8=HSTD STRUCTURE ROM POINTER.
*
*	OUTPUT A9 = CMOS RAM POINTER TO BASE OF TABLE
*	OUTPUT A10= LAST ENTRY IN TABLE. TABLE WILL
*			HAVE A10+1 ENTRIES SINCE ENTRY
*			0 IS A FILLER.
*
**************************************************************************
ROM_PTRS:
	MMTM	SP,A0,A1		;SCRATCH REGGIES
	MOVE	*A8(TB_POINTER),A9,L	;GET CMOS POINTER
	MOVE	*A8(TB_COUNT),A10,W	;GET NUMBER OF ENTRIES
	MOVE	*A8(TB_PAGE_BITS),A1	;GET OUR CMOS PAGE BITS

	CALLR	SET_PAGE

	MMFM	SP,A0,A1		;SCRATCH REGGIES
	RETS

**************************************************************************
*
*	SET_PAGE
*
*	This is called to set the CMOS page to the bits
*	contained in A1.
*
**************************************************************************
SET_PAGE
;	MMTM	SP,A0,A1
;	ANDI	CMOS_PAGE_SELECT_BITS,A1	;KILL SIGN EXTEND..SAVE BITS
;	PUSHST					;SAVE INTERRUPT STATUS
;	DINT					;STOP INTERRUPTS
;	MOVE	@SYSCOPY,A0,W			;GET THE RAM COPY
;	ANDNI	CMOS_PAGE_SELECT_BITS,A0	;REMOVE THE CURRENT PAGE SELECT
;	OR	A1,A0				;ADD IN OUR BITS
;	MOVE	A0,@SYSCOPY,W			;PUT THEM BACK IN THE RAM COPY
;;	MOVE	A0,@SYSCTRL,W			;NOW THE HARDWARE
;	POPST					;OK TO RE-START INTS
;	MMFM	SP,A0,A1
	RETS

**************************************************************************
*
*	INIT_TAB
*
*	This entrypoint is called at power up to
*	clear out "today's" high score table. We do
*	this job, and then we do the job on the
*	all time table for high score reset if
*	necessary.
*
**************************************************************************
INIT_TAB
	RETS

#*************************************************************************
*
*	INIT_HSTRING
*
*	Initializes the special name of the top scorer on the table.

 SUBR	INIT_HSTRING
	MOVI	AUD_WINSTREAK,A0
	CALLA	KILL_AUD
	MOVI	AUD_PINSPEED,A0
	CALLA	KILL_AUD
	MOVI	AUD_BEATEN,A0
	CALLA	KILL_AUD
	MOVI	AUD_TAG,A0
	CALLA	KILL_AUD
	rets


#*************************************************************************
*
*	INIT_TB
*
*	THIS IS CALLED TO SETUP A HIGH SCORE TABLE WITH
*	FACTORY ENTRIES.
*
*	A8 = ROM TABLE POINTER
*
**************************************************************************
 SUBR	INIT_TB

	MMTM	SP,A5,A6,A7,A0
	CALLR	ROM_PTRS		;STUFF TABLE DATA
	MOVE	*A8(TB_FACTORY),A6,L 	;GET THE FACTORY TABLE
	MOVE	A10,A5			;NUMBER OF VALID ENTRIES
	INC	A5			;1 MORE TO HOLD ZERO ENTRY
	MOVI	HS_SIZE_IN_BYTES,A1	;SIZE OF 1 ENTRY
	MPYU	A1,A5			;A7 HAS NUMBER OF WORDS TO MOVE
	MOVE	A9,A7			;CMOS POINTER IN A7

INIT_TB_1
	MOVB	*A6,A0			;GET A BYTE FROM ROM
	ADDI	BYTE_SIZE,A6		;KICK ROM POINTER
	CALLR	WC_BYTEI		;WRITE THE BYTE AND INCREMENT
	DSJS	A5,INIT_TB_1		;UNTIL THEY'RE ALL THERE.

	MOVE	A10,A0			;POINT AT LAST ENTRY
INIT_TB_2
	CALLR	FORM_HS_CKSUM_AND_STORE	;SET ITS CHECKSUM
	DEC	A0			;MOVE DOWN
	JRNN	INIT_TB_2		;SET EACH ONE INCLUDING ZERO
	MMFM	SP,A5,A6,A7,A0

	RETS

#*************************************************************************
*
*	COPY_ENTRY
*
*	THIS IS CALLED TO COPY 1 ENTRY OF THE TABLE TO A
*	DIFFERENT LOCATION IN THE TABLE.
*
*	A8,A9,A10,SYSCTRL ASSUMED TO BE SETUP ALREADY
*	A2 = SOURCE ENTRY (NUMBER)
*	A3 = DESTINATION ENTRY (NUMBER)
*
**************************************************************************
COPY_ENTRY:
	MMTM	SP,A0,A4,A5,A6,A7
	MOVI	HS_SIZE_IN_BYTES,A4	;ENTRY SIZE IN BYTES
	MOVE	A2,A0			;FIRST POINT FOR A0
	CALLR	PT_ENTRY	
	MOVE	A7,A6			;A6 = SOURCE POINTER
	MOVE	A3,A0
	CALLR	PT_ENTRY		;A5 = DESTINATION
	MOVE	A7,A5
COPY_LOOP:
*
*	 IN THIS LOOP WE MOVE A BYTE AT A TIME.
*	 SINCE THE WORD AND LONG DO THE SHIFTING AND
*	 MASKING AND CALL MULTIPLE ROUTINES, THIS IS
*	 THE MOST EFFICIENT MODE OF OPERATION.
*
	MOVE	A6,A7			;SOURCE IN CMOS REGGIE
	CALLR	RC_BYTEI		;FETCH A WORD
	MOVE	A7,A6
	MOVE	A5,A7			;DESTINATION
	CALLR	WC_BYTEI		;WRITE IT
	MOVE	A7,A5			;BACK TO DEST REGGIE
	DSJ	A4,COPY_LOOP		;UNTIL ALL WORDS ARE COPIED
	MMFM	SP,A0,A4,A5,A6,A7
	RETS

**************************************************************************
*
*	VAL_TAB
*
*	THIS ROUTINE IS CALLED WHEN WE ARE INTERESTED IN
*	THE HSTD TABLE DATA. A8 CONTAINS THE ROM POINTER
*	FOR THE TABLE. FOR ANY ENTRIES THAT WE THROW
*	OUT, WE MOVE THE REST OF THE TABLE UP, AND CREATE
*	A NEW ENTRY AT THE END OF THE TABLE.
*
*	A2 = 0 ON OUTSIDE CALL.
*	A2 = 1 ON RECURSIVE CALL (THE CHECK AFTER RE-INIT)
*
*	THERE ARE 3 CHECKS MADE FOR EACH ENTRY:
*
*	1)	IS CHECKSUM CORRECT.
*	2)	IS SCORE ALL NUMERIC
*	3)	ARE INITIALS ALL VALID ENTRIES.
*
*	 OUTPUT CC = TABLE OK
*		CS = PROBLEM THAT CAN'T BE RECTIFIED
*			(PROBABLY BAD RAM)
*
*		A2 = 0 ...table ok, or cleaned up
*		A2 otherwise meanes table initialized
*
**************************************************************************
VAL_TAB
	CLR	A2		;indicate first call in
	CALLR	DO_VALIDATE	;validate
	RETS

DO_VALIDATE
	MMTM	SP,A0,A1,A3,A4,A5,A6,A7
	CALLR	ROM_PTRS		;SETUP FOR TABLE
	MOVI	1,A0			;ITERATE THROUGH THE ENTRIES
	CLR	A1			;COUNT ERRORS

CHECK_A0_ENTRY:
	CALLR	CHECK_ENTRY		;IS THE ENTRY OK?
	JRNC	VT_1			;YEP.

	CALLR	REMOVE_ENTRY		;REMOVE THIS ENTRY
	INC	A1
	MOVE	*A8(TB_ERROR_COUNT),A3	;GET THRESHOLD
	CMP	A3,A1			;ARE WE THERE?
	JRLO	CHECK_A0_ENTRY		;NOPE...CHECK MOVE UP ENTRY AT A0
*
*	TABLE IS MESSED UP....RE-INITIALIZE IT PLEASE
*
	MOVE	A2,A2			;IS THIS RECURSIVE CHECK AFTER INIT?
	JRNZ	CANT_VALIDATE		;THEN RETURN FAILURE

	CALLR	INIT_TB 		;INIT THIS TABLE PLEASE
	CALLR	INIT_HSTRING
	MOVK	1,A2			;INDICATE RECURSIVE CALL
	CALLR	DO_VALIDATE		;IS IT ALRIGHT NOW?
	MMFM	SP,A0,A1,A3,A4,A5,A6,A7
	RETS
*
*	 LAST ENTRY WAS VALID...MOVE TO NEXT
*
VT_1:	
	INC	A0			;KICK IT
	CMP	A10,A0			;STILL IN TABLE?
	JRLS	CHECK_A0_ENTRY		;YEP....CHECK THIS ENTRY

	CLRC				;RETURN VALID!
	MMFM	SP,A0,A1,A3,A4,A5,A6,A7
	RETS

CANT_VALIDATE:
	SETC				;RETURN FAILURE!
	MMFM	SP,A0,A1,A3,A4,A5,A6,A7
	RETS

**************************************************************************
*
*	CHECK_ENTRY
*
*	THIS IS CALLED TO CHECK THE ENTRY INDICATED BY A0.
*
*	CC = OK
*	CS = ENTRY BAD
*
**************************************************************************
CHECK_ENTRY
	MMTM	SP,A0,A1,A2,A3,A7
	CALLR	FORM_HS_CKSUM		;CHECK OUT CKSUM FIRST
	JRNZ	CHECK_FAIL		;BAD CHECKSUM....ITS BAD
*
*	CHECKSUM OK...CHECK SCORE
*
	CALLR	GET_HSCR		;SCORE IN A1
	MOVE	A1,A3			;SAVE COPY OF SCORE

CHECK_DIGIT:
	MOVE	A1,A2			;COPY FOR NEXT NIBBLE
	ANDI	0FH,A2			;MASK THE NIBBLE
	CMPI	9,A2
	JRHI	CHECK_FAIL		;NIBBLE TOO HIGH
	SRL	4,A1			;SHIFT DOWN TO NEXT NIBBLE
	JRNZ	CHECK_DIGIT

	DEC	A0			;MAKE SURE WE ARE LOWER THAN PREVIOUS SCORE!
	JREQ	FIRST_ENT		;WE'RE THE 1ST IN THE TABLE

	CALLR	GET_HSCR		;GET THE SCORE FOR THE GUY BEFORE US
;	CMP	A1,A3			;OURS MUST BE LOWER OR SAME
;	JRHI	CHECK_FAIL		;OURS IS BIGGER....REMOVE US

FIRST_ENT:
	INC	A0			;RESTORE THE ENTRY NUMBER
*
*	SCORE OK...CHECK INITIALS
*
	CALLR	PT_ENTRY		;POINT A7 AT ENTRY
	ADDI	HS_INITS,A7		;POINT AT FIRST INITIAL
	MOVI	NUM_INITS,A2		;THIS IS NUMBER OF INITIALS

NEXT_LETTER:
	CALLR	RC_BYTEI		;FETCH A BYTE

	CALLR	VERIFY_LETTER		;SEE IF ITS VALID.
	JRC	CHECK_FAIL		;NOT A LETTER...BYTE

	DSJ	A2,NEXT_LETTER

	CLRC				;RETURN PASS
	MMFM	SP,A0,A1,A2,A3,A7
	RETS

CHECK_FAIL:
	SETC
	MMFM	SP,A0,A1,A2,A3,A7
	RETS


**************************************************************************
*
*	VERIFY_LETTER
*
*	THIS IS CALLED FOR EACH INITIAL LETTER TO SEE
*	IF ITS VALID.
*
*	CC = VALID
*	CS = NOT VALID
*
**************************************************************************

VERIFY_LETTER:
	ANDI	BYTE_MASK,A0		;KEEP JUST THE BYTE

	CMPI	'.',A0			;SPACE?
	JREQ	VERIFY_PASS		;ITS OK.

	CMPI	'!',A0			;SPACE?
	JREQ	VERIFY_PASS		;ITS OK.

	CMPI	'%',A0			;SPACE?
	JREQ	VERIFY_PASS		;ITS OK.

	CMPI	'?',A0			;SPACE?
	JREQ	VERIFY_PASS		;ITS OK.

	CMPI	SPACE,A0		;SPACE?
	JREQ	VERIFY_PASS		;ITS OK.

	CMPI	LET_A,A0		;BETWEEN A-Z?
	JRLO	VERIFY_FAIL

	CMPI	LET_Z,A0
	JRHI	VERIFY_FAIL

VERIFY_PASS:
	CLRC
	RETS

VERIFY_FAIL:
	SETC
	RETS

**************************************************************************
*
*	REMOVE_ENTRY
*
*	THIS IS CALLED TO REMOVE A BAD ENTRY FROM THE TABLE.
*	IT DELETES THE ENTRY INDICATED BY A0.
*
*	IT BUBBLES THE REST OF THE TABLE UP 1 UNIT.
*
*	IT THEN PUTS THE LOWEST SCORE FROM THE ROM TABLE
*	WITH INITIALS IN THAT ENTRY.
*
**************************************************************************
REMOVE_ENTRY:
	MMTM	SP,A0,A1,A2,A6,A7
	MOVE	A0,A3			;THIS IS DEST
	MOVE	A3,A2			;SOURCE IS 1 BELOW

BUBBLE_ANOTHER:
	INC	A2			;NOW WE'RE SET FOR A COPY...

	CMP	A10,A2			;IS SOURCE OUT OF RANGE?
	JRHI	BUBBLE_DONE		;YEP....WE'RE AT THE BOTTOM (A3)

	CALLR	COPY_ENTRY
	INC	A3
	JRUC	BUBBLE_ANOTHER

BUBBLE_DONE:
	MOVE	A3,A0			;THIS IS BOTTOM OF TABLE
	CALLR	PT_ENTRY		;A7 POINTS AT CMOS BLOCK

	MOVE	*A8(TB_FACTORY),A6,L	;GET FACTORY TABLE
	MOVI	HS_ROM_SIZE,A1		;SIZE OF ENTRY
	MPYU	A10,A1			;TIMES NUMBER OF VALID ENTRIES..POINTS AT LAST.
	ADD	A1,A6			;NOW WE POINT AT END OF ROM TABLE
	MOVI	HS_SIZE_IN_BYTES,A2	;SIZE OF ENTRY

REPLACE_LOOP:
	MOVB	*A6,A0			;MOVE A ROM BYTE TO A0
	ADDI	BYTE_SIZE,A6
	CALLR	WC_BYTEI		;WRITE THE WORD AND INCREMENT
	DSJ	A2,REPLACE_LOOP		;UNTIL THEY'RE ALL THERE.

	MOVE	A10,A0			;POINT AT "LAST" ENTRY
	CALLR	FORM_HS_CKSUM_AND_STORE	;STORE THE CHECKBYTE
	MMFM	SP,A0,A1,A2,A6,A7	;AND RETURN
	RETS

**************************************************************************
*
*	CMOS UTILITIES
*
**************************************************************************

**************************************************************************
*
*	FOR ALL OF THESE CMOS ROUTINES.
*
*		A7 = POINTER TO MEMORY
*		A0 = DATA TO/FROM MEMORY
*
**************************************************************************
*
*	**** IMPORTANT NOTE ON WORD AND LONG WORD PACKING ****
*
*	NOTE THAT REQUESTS FOR WORDS RETURN THE 2 BYTES PACKED
*	INTO A WORD AS <1ST BYTE><2ND BYTE>.	THIS IS NOT
*	THE SAME WAY THAT THE GSP HANDLES A WORD POINTED AT
*	WITH A POINTER.
*
*	LONG WORDS WORK SIMILARLY:
*
*	MSB 					LSB
*	<1ST BYTE> <2ND BYTE> <3RD BYTE> <4TH BYTE>
*
*	TOUGH LUCK INTEL HACKERS!
*
*
*	RC_BYTE
*	WC_BYTE
*
*	These 2 routines are the only routines that ever touch
*	CMOS ram. This is done to localize the effect of
*	changes in the architecture. All efforts to deal with
*	CMOS should come through these routines. Locking
*	hardware will be easily added in the future (as well
*	as different memory mapping).



RC_BYTE
;	move	@SYSCOPY,a0
;	sll	32-2,a0
;	srl	32-2,a0
;	sll	15,a0		;Page offset
;	add	a7,a0
	movb	*a7,a0
	sll	32-8,a0
	srl	32-8,a0
	rets

WC_BYTE
;	MOVE	A1,-*SP,L
;	move	@SYSCOPY,a1
;	sll	32-2,a1
;	srl	32-2,a1
;	sll	15,a1		;Page offset
;	add	a7,a1
;	move	a7,a1
	move	a0,@CMOSWE
	movb	a0,*a7
;	MMFM	SP,A1
	rets


**************************************************************************
*
*	RC_BYTEI
*
*	READ BYTE POINTED TO BY A7...INCREMENT POINTER TO
*	"NEXT" BYTE.
*
**************************************************************************
RC_BYTEI:
	CALLR	RC_BYTE
	ADDI	C_BYTE_SIZE,A7	;WORDS SEPARATE CMOS BYTES.
	MOVE	A0,A0		;RETURN FLAGS ACCORDINGLY
	RETS

RC_WORD:
	MMTM	SP,A1,A7	;USE A1 TO COMBINE BYTES
	CALLR	RC_BYTEI	;GET A BYTE
	MOVE	A0,A1		;SAVE IN A1
	ANDI	BYTE_MASK,A1	;MASK ONLY BYTE
	SLL	8,A1		;SHIFT TO HIGH BYTE
	CALLR	RC_BYTE		;GET THE 2ND BYTE
	ANDI	BYTE_MASK,A0
	OR	A1,A0		;A0 HAS THE WORD
	MMFM	SP,A1,A7	
	RETS

RC_WORDI:
	CALLR	RC_WORD
	ADDI	C_WORD_SIZE,A7	;LONG SEPARATE CMOS WORDS.
	MOVE	A0,A0		;RETURN FLAGS ACCORDINGLY
	RETS

RC_LONG:
	MMTM	SP,A1,A7	;USE A1 TO COMBINE BYTES
	CALLR	RC_WORDI	;GET A WORD
	MOVE	A0,A1		;SAVE IN A1
	ANDI	WORD_MASK,A1	;MASK ONLY WORD
	SLL	16,A1		;SHIFT TO HIGH WORD
	CALLR	RC_WORD		;GET THE 2ND WORD
	ANDI	WORD_MASK,A0
	OR	A1,A0		;A0 HAS THE LONG WORD
	MMFM	SP,A1,A7	
	RETS

RC_LONGI:
	CALLR	RC_LONG
	ADDI	C_LONG_SIZE,A7	;DOUBLE THE DISTANCE FOR BRAIN DAMIJ
	MOVE	A0,A0		;RETURN FLAGS ACCORDINGLY
	RETS

WC_BYTEI:
	CALLR	WC_BYTE
	ADDI	C_BYTE_SIZE,A7
	RETS

WC_WORD:
	MMTM	SP,A0,A1,A7
	MOVE	A0,A1		;MAKE COPY OF WORD
	SRL	8,A0		;GET HIGH BYTE IN A0
	CALLR	WC_BYTEI	;WRITE THE HIGH BYTE
	MOVE	A1,A0		;NOW GET THE LOW BYTE BACK
	CALLR	WC_BYTE ;WRITE IT
	MMFM	SP,A0,A1,A7	;AND RESTORE ALL WE TOUCHED
	RETS

WC_WORDI:
	CALLR	WC_WORD
	ADDI	C_WORD_SIZE,A7
	RETS

WC_LONG:
	MMTM	SP,A0,A1,A7
	MOVE	A0,A1		;MAKE COPY OF LONG
	SRL	16,A0		;GET HIGH WORD IN A0
	CALLR	WC_WORDI	;WRITE THE HIGH WORD
	MOVE	A1,A0		;NOW GET THE LOW WORD BACK
	CALLR	WC_WORD ;WRITE IT
	MMFM	SP,A0,A1,A7	;AND RESTORE ALL WE TOUCHED
	RETS

WC_LONGI:
	CALLR	WC_LONG
	ADDI	C_LONG_SIZE,A7
	RETS

*****************************************************************************
*****************************************************************************
*****
*****	 DEFAULT ROM HSTD TABLES AND TABLE DEFINITIONS
*****
*****************************************************************************
*****************************************************************************

TB_POINTER	 EQU	 0			;LONG-POINTER TO BEGINNING OF TABLE
TB_COUNT	 EQU	 TB_POINTER+LONG_SIZE	;WORD....# IN THE TABLE.
TB_VISIBLE	 EQU	 TB_COUNT+WORD_SIZE	;WORD....NUMBER DISPLAYED
TB_PAGE_BITS	 EQU	 TB_VISIBLE+WORD_SIZE	;WORD....STATUS WORD FOR CMOS PAGE
TB_FACTORY	 EQU	 TB_PAGE_BITS+WORD_SIZE	;LONG....ROM STARTUP TABLE
TB_ERROR_COUNT	 EQU	 TB_FACTORY+LONG_SIZE	;WORD....NUM ERRORS TO RE-INIT


;SCRM	.MACRO	a,b
SCRM	.MACRO	a
	.byte	:a:/>1000000,:a:/>10000&>ff,:a:/>100&>ff,:a:&>ff
;	.byte	":b:",0
	.ENDM

STREAK_ROM_TABLE
	SCRM	>22122145		;****ZERO ENTRY...NOT SEEN!
	.BYTE	"EPJA.",0
ROM_ENTRY_SIZE	EQU	$-STREAK_ROM_TABLE
	SCRM	>11
	.BYTE	"MJTA.",0
	SCRM	>10
	.BYTE	"SALB.",0
	SCRM	>9
	.BYTE	"JMSC.",0
	SCRM	>9
	.BYTE	"JYTD.",0
	SCRM	>8
	.BYTE	"MJLE.",0
	SCRM	>8
	.BYTE	"JAKF.",0
	SCRM	>7
	.BYTE	"OEGA.",0
	SCRM	>7
	.BYTE	"SL A.",0
	SCRM	>7
	.BYTE	"MDPA.",0

	SCRM	>6
	.BYTE	"GBSA.",0
	SCRM	>6
	.BYTE	"DJTA.",0
	SCRM	>6
	.BYTE	"EPJA.",0
	SCRM	>5
	.BYTE	"BIFA.",0
	SCRM	>5
	.BYTE	"UNKA.",0
	SCRM	>5
	.BYTE	"UTBA.",0
	SCRM	>4
	.BYTE	"CRLA.",0
	SCRM	>4
	.BYTE	"TDGA.",0
	SCRM	>4
	.BYTE	"ASBA.",0
STREAK_TABLE_ENTRIES	EQU	($-STREAK_ROM_TABLE)/ROM_ENTRY_SIZE

PIN_SPEED_TAB_ROM_TABLE

	SCRM	>7000		;****ZERO ENTRY...NOT SEEN!
	.BYTE	"EPJA.",0
	SCRM	>6000 
	.BYTE	"MJTI.",0
	SCRM	>6100
	.BYTE	"SALI.",0
	SCRM	>6200
	.BYTE	"JMSG.",0
	SCRM	>6300
	.BYTE	"JYTF.",0
	SCRM	>6400
	.BYTE	"JAKE.",0
	SCRM	>6500
	.BYTE	"OEGD.",0
	SCRM	>6600
	.BYTE	"MJLC.",0
	SCRM	>6700
	.BYTE	"UTBB.",0
	SCRM	>6800 
	.BYTE	"ASBA.",0

PIN_SPEED_TAB_ENTRIES	EQU	($-PIN_SPEED_TAB_ROM_TABLE)/ROM_ENTRY_SIZE

BEATEN_ROM_TABLE
	SCRM	>22122145		;****ZERO ENTRY...NOT SEEN!
	.BYTE	"EPJAB",0
B_ROM_ENTRY_SIZE	EQU	$-BEATEN_ROM_TABLE
	SCRM	>11101
	.BYTE	"MIKE ",0
	SCRM	>1001
	.BYTE	"JAMIT",0
	SCRM	>100
	.BYTE	"TEAL ",0
	SCRM	>1000
	.BYTE	"DINK ",0
	SCRM	>10000
	.BYTE	"JAKE ",0
	SCRM	>100000
	.BYTE	"DRJ  ",0
	SCRM	>1000000
	.BYTE	"CHICK",0
	SCRM	>10000000
	.BYTE	"SHAWN",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
BEATEN_TAB_ENTRIES	EQU	($-BEATEN_ROM_TABLE)/B_ROM_ENTRY_SIZE

INTER_ROM_TABLE
	SCRM	>22122145		;****ZERO ENTRY...NOT SEEN!
	.BYTE	"EPJAB",0
I_ROM_ENTRY_SIZE	EQU	$-INTER_ROM_TABLE
	SCRM	>111
	.BYTE	"MARK ",0
	SCRM	>101
	.BYTE	"SAL  ",0
	SCRM	>100
	.BYTE	"JASON",0
	SCRM	>1000
	.BYTE	"LICK ",0
	SCRM	>10000
	.BYTE	"JAKE ",0
	SCRM	>100000
	.BYTE	"DIESL",0
	SCRM	>1000000
	.BYTE	"FUJI ",0
	SCRM	>10000000
	.BYTE	"SHAWN",0
	SCRM	>1000000
	.BYTE	"BIFF ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
	SCRM	>0000000
	.BYTE	"     ",0
INTER_TAB_ENTRIES	EQU	($-INTER_ROM_TABLE)/I_ROM_ENTRY_SIZE

TAG_ROM_TABLE
	SCRM	>22122145		;****ZERO ENTRY...NOT SEEN!
	.BYTE	"EPJAB",0
T_ROM_ENTRY_SIZE	EQU	$-TAG_ROM_TABLE
	SCRM	>9000
	.BYTE	"BOON ",0
	SCRM	>9000
	.BYTE	"SAL  ",0
	SCRM	>9500
	.BYTE	"ERMAC",0
	SCRM	>9500
	.BYTE	"KANO ",0
	SCRM	>10000
	.BYTE	"SONYA",0
	SCRM	>10000
	.BYTE	"GENE ",0
	SCRM	>10500
	.BYTE	"MIKE ",0
	SCRM	>10500
	.BYTE	"SHAWN",0
	SCRM	>11000
	.BYTE	"JASON",0
	SCRM	>11000
	.BYTE	"JOSH ",0
	SCRM	>11500
	.BYTE	"JOHN ",0
	SCRM	>11500
	.BYTE	"JAKE ",0
	SCRM	>12000
	.BYTE	"JOE  ",0
	SCRM	>12000
	.BYTE	"EDWIN",0
	SCRM	>12500
	.BYTE	"BILL ",0
	SCRM	>12500
	.BYTE	"MARKP",0
	SCRM	>13000
	.BYTE	"STEVE",0
	SCRM	>13000
	.BYTE	"TONY ",0
TAG_TAB_ENTRIES	EQU	($-TAG_ROM_TABLE)/T_ROM_ENTRY_SIZE


******************************************************************************

	.end
