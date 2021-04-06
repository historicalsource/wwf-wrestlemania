****************************************************************
*
* Software:	?
* Initiated:	?
*
* Modified:	Shawn Liptak 8/6/91  - Hiscore display and entry (Total carnage)
* 		Shawn Liptak 11/9/91 - Title screen
* 		Shawn Liptak 2/7/92  - Stripped for basketball
*		Jason Skiles 12/9/93 - Stripped for WWF
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 12/9/93 12:35
****************************************************************
	.file	"attract.asm"
	.title	"attract mode"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"
	.include	"display.equ"
	.include	"sys.equ"
	.include	"gsp.equ"
	.include	"macros.h"
	.include	"game.equ"
	.include	"audit.equ"
	.include	"link.equ"
	.include	"sound.h"

	.include	"imgtbl.glo"
	.include	"fontsimg.glo"
	.include	"miscimg.glo"
	.include	"bgndtbl.glo"
	.include	"ropeimg.glo"

******************************************************************************
* EXTERNAL REFERENCES

	.ref	GET_ADJ,nosounds,CLOSE_PROGRESS_SCREEN
	.ref	SPECIAL_WIPEOUT,BLOW_0_TO_1,RESET_FROM_PIXEL_WIPE
	.ref	SET_UP_PIXEL_WIPE,wrestler_mugs2
	.ref	BAKMODS,HALT,GAMSTATE,pal_getf
	.ref	dpageflip,CRD_SCRN2,RC_BYTEI,IRQSKYE
	.ref	BGND_UD1,ADJ_PAGE,WIPEOUT,setup_message
	.ref	STRCNRMO_1,RNDRNG0,SOUNDSUP,fade_up
	.ref	fade_down

	;from DCSSOUND.ASM
	.ref	triple_sound

	;from DISPLAY.ASM
	.ref	BEGINOBJW_TBL

	;from HSTD.ASM
	.ref	print_hscores,print_winstreaks
	.ref	table_cmos_check
	.REF	draw_beaten_table_entry
	.ref	print_beaten
	.REF	STOP_ALL_OBJS
	.REF	MOVE_ALL_OBJS_UP
	.REF	DELETE_ANY_OFF_TOP
	.REF	BEATEN_TAB_ENTRIES
	.REF	starting_num
	.ref	draw_each_beaten_table_entry

	;from MAIN.ASM
	.ref	RemapIO

	;from PAL.ASM
	.ref	pal_clean

	;from ROBO.ASM

	;from SELECT.ASM
	.ref	wrestler_attributes,attbars
	.ref	RD7FONT

	;from STRING.ASM
	.ref	osgmd8_ascii,mess_cursx,mess_cursy,mess_line_spacing
	.ref	print_string2,copy_string,dec_to_asc
	.ref	print_string_C2,print_string_R2,concat_rom_string
	.ref	print_string_R,concat_string

	;from UNZIP.ASM
	.ref	movie_run

	;from UTIL.ASM
	.ref	get_all_buttons_cur2

	;from WRESTLE.ASM
	.ref	total_matches

	.REF	WHICH_SCREEN
	.REF	page_addr
	.REF	RNDRNGS
	.REF	DUMRETS

	.DEF	GENERIC_DISPLAY

******************************************************************************

;symbols defined in this file

	.def	MAKE_UP_LOGO

******************************************************************************
;symbols defined externally

;ram

	BSSX	hisclong	,16	;!0=Show hiscore table longer

	BSSX	SHOW_CRD_FLAG,16	;Show credits in amode gameplay

	.bss	cycram		,8*2*16	;Palette cycle mem
	.bss	cycram2		,7*2*16	;^

;	.bss	team_cnts	,32	;left team cnt, +16=rgt team cnt
;	.bss	stick		,32	;stick ram for team selection

;	.bss	loop,		16	;

	.bss	TEMP,16

	.BSS	AMODE_LOOPS,16
	.BSS	DCS_PAL,16
	.BSS	DCS_BIT_TABLE,(32*7)*(31*44)

	.text


********************************
* Attract mode (Process)


 SUBR	attract_mode

	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT

	movi	INAMODE,a14		;set GAMSTATE
	move	a14,@GAMSTATE

	clr	a0			;clear matches since attmode cntr
	move	a0,@total_matches,W
	MOVE	A0,@AMODE_LOOPS

	movk	1,a0
	move	a0,@dpageflip		;page flipping on

	calla	display_unblank

#loop

	JSRP	show_title
;	JSRP	creditscreen
	JSRP	DCS_LOGO
;MJT Start
;	JSRP	show_big_wwf_logo_screen_thingie
;MJT End
	JSRP	show_copyright
	JSRP	show_hstd
	JSRP	show_bios
	JSRP	show_gameplay
	JSRP	show_operatormsg

	calla	RemapIO			;Remap the I/O
	MOVE	@AMODE_LOOPS,A0
	INC	A0
	MOVE	A0,@AMODE_LOOPS

	jruc	#loop


#****************************************************************
* show_gameplay

 SUBRP	show_gameplay

	movk	1,a0
	move	a0,@current_round
	move	a0,@match_cnt


	.ref	p1rounds
	.ref	p2rounds
	move	a0,@p1rounds
	move	a0,@p2rounds



	.ref	current_round
	.ref	match_cnt
	.ref	start_match2
	.ref	index1
	.ref	index2

	movk	7,a0
	calla	RNDRNG0
	cmpi	7,a0
	jrnz	#bug
	inc	a0
#bug
	move	a0,@index1
	movk	7,a0
	calla	RNDRNG0
	cmpi	7,a0
	jrnz	#bug2
	inc	a0
#bug2
	move	a0,@index2

	CALLR	TURN_SOUNDS_OFF_IF_NEED

	JSRP	CLOSE_PROGRESS_SCREEN
	calla	SPECIAL_WIPEOUT

;Eventually, we should show just quick clips of cool gameplay.
	movk	1,a0
	move	a0,@SHOW_CRD_FLAG

	CALLR	TURN_SOUNDS_OFF_IF_NEED

	CREATE0	start_match2

;MJT Start
	SLEEP	3*60

	movi	15*TSEC,a10
;MJT End
	JSRP	wait_on_butn

	clr	a0
	move	a0,@SHOW_CRD_FLAG
	CALLA	nosounds

	RETP

TURN_SOUNDS_OFF_IF_NEED
	ADJUST	ADJMUSIC
	JRNZ	TURN_OFF_SOUNDS

	MOVE	@AMODE_LOOPS,A0
	CMPI	2,A0
	JRLT	SOUNDS_SHOULD_BE_ON
TURN_OFF_SOUNDS
	MOVK	2,A0
	MOVE	A0,@SOUNDSUP
SOUNDS_SHOULD_BE_ON
	RETS

#****************************************************************
* Show an operator message if one has been entered

	STRUCTPD
	WORD	som_string


 SUBR	show_operatormsg

	calla	ADJ_PAGE
	movk	CMESS_LINES,a2		;>Check for a message
	movi	CUSTOM_MESSAGE,a7
#cmlp
	calla	RC_BYTEI
	jrnz	#msg
	addi	CMESS_LINE_SIZE,a7
	dsj	a2,#cmlp
	jruc	#x
#msg
	JSRP	GENERIC_DISPLAY
	movk	CMESS_LINES,a2		;>Check for a message
	movi	CUSTOM_MESSAGE,a7
	movi	[50,200],a9
#prtlp
	PUSHP	a2,a7

	calla	ADJ_PAGE

	move	a13,a2
	addi	som_string,a2
#getlp	calla	RC_BYTEI
	movb	a0,*a2
	addk	8,a2
	move	a0,a0
	jrnz	#getlp


	movi	GOLD,a0
	calla	pal_getf
	move	a0,a6

	move	a13,a8
	addi	som_string,a8
	clr	a0
	movk	1,a10
	movi	osgfont_t,a11
	PUSHP	a9
	JSRP	STRCNRMO_1
	PULLP	a9

	movi	OBJLST,a14

#olp	move	*a14,a14,L	;A14=*Next
	jrz	#oend
	move	*a14(ODATA_p),a0,L
	jrnz	#olp
	movi	[>320,>320],a1
	move	a1,*a14(ODATA_p),L
	jruc	#olp
#oend

;	PUSHP	a6
;	SLEEPK	30
;	PULLP	a6
	PULLP	a2,a7
#nxt
	addi	[45,0],a9

	addi	CMESS_LINE_SIZE,a7
	dsj	a2,#prtlp

	SLEEP	2*60

	movi	6*TSEC,a10
	JSRP	wait_on_butn

	JSRP	scrn_scaleout

	calla	WIPEOUT

#x	RETP

#*****************************************************************************


	.def	osgfont_t
osgfont_t
	.long	OSGEMD_EXP,OSGEMD_APO,OSGEMD_NUM,OSGEMD_DOL	;!"#$
	.long	OSGEMD_SPC,OSGEMD_AND,OSGEMD_APO,OSGEMD_OBR	;%&'(
	.long	OSGEMD_CBR,OSGEMD_SPC,OSGEMD_SPC,OSGEMD_SPC	;)*+,
	.long	OSGEMD_DAS,OSGEMD_DOT,OSGEMD_SLS		;-./
	.long	OSGEMD_0,OSGEMD_1,OSGEMD_2,OSGEMD_3,OSGEMD_4
	.long	OSGEMD_5,OSGEMD_6,OSGEMD_7,OSGEMD_8,OSGEMD_9
	.long	OSGEMD_COL,OSGEMD_SPC,OSGEMD_SPC,OSGEMD_SPC	;:;<=
	.long	OSGEMD_SPC,OSGEMD_QUE,OSGEMD_SPC		;>?@
	.long	OSGEMD_A,OSGEMD_B,OSGEMD_C,OSGEMD_D
	.long	OSGEMD_E,OSGEMD_F,OSGEMD_G,OSGEMD_H
	.long	OSGEMD_I,OSGEMD_J,OSGEMD_K,OSGEMD_L
	.long	OSGEMD_M,OSGEMD_N,OSGEMD_O,OSGEMD_P
	.long	OSGEMD_Q,OSGEMD_R,OSGEMD_S,OSGEMD_T
	.long	OSGEMD_U,OSGEMD_V,OSGEMD_W,OSGEMD_X
	.long	OSGEMD_Y,OSGEMD_Z
	.long	OSGEMD_SPC,OSGEMD_SPC,OSGEMD_SPC,OSGEMD_END	;[\]^
	.long	OSGEMD_BAK,OSGEMD_SPC,OSGEMD_SPC		;_`


#*****************************************************************************
* Show credits screen
*

 SUBRP	creditscreen

	calla	pal_clean

	movk	1,a10
	JSRP	CRD_SCRN2
	movi	AMODE_PID,a0
	move	a0,*a13(PROCID)

	;fade down
;	clr	a10
;	movk	16,a11
;	CREATE0	fade_down
;
;	SLEEP	TSEC

	RETP


#*****************************************************************************

 SUBRP	show_copyright

	calla	display_blank
	calla	WIPEOUT

	clr	a0
	move	a0,@dtype		;2D

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L
	move	a0,@IRQSKYE

	SLEEPK	2

;Establish a pal!
;This pal has pure white as the first color!  That is what the STRING
;routine uses.

	movi	ATTMTR_P,a0
	calla	pal_getf

	clr	a0
	clr	a6
	movi	#ln1,a8
	movi	[50+60,200],a9
 	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_1

	clr	a0
	movi	#ln2,a8
	movi	[62+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_1

	clr	a0
	movi	#ln3,a8
	movi	[74+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_1

	clr	a0
	movi	#ln4,a8
	movi	[86+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_1

	clr	a0
	movi	#ln5,a8
	movi	[98+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_1

	clr	a0
	movi	#ln6,a8
	movi	[110+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_1

	clr	a0
	movi	#ln7,a8
	movi	[122+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_1

	clr	a0
	movi	#ln8,a8
	movi	[134+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_1

	clr	a0
	movi	#ln9,a8
	movi	[146+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_1

;MJT Start
;Place the correct WWF logo here (The one from Title page)
;	movi	[200,0],a0
;	movi	[4bh-5,0],a1
;	movi	WWFLGO1,a2			;* image
;	movi	20000,a3
;	movi	DMAWNZ|M_NOCOLL,a4
;	movi	CLSDEAD,a5
;	clr	a6
;	clr	a7
;	calla	BEGINOBJ
;MJT End

	clr	a10
	movk	8,a11
	CREATE0	fade_up

	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	2
	calla	display_unblank

	SLEEP	30

	movi	6*TSEC,a10
	JSRP	wait_on_butn

	RETP

#ln1	.string	"VIDEO GAME SOFTWARE DESIGNED AND DEVELOPED",0
#ln2	.string	"BY MIDWAY MANUFACTURING COMPANY",0
#ln3	.string	"(C) 1995 ASSIGNED TO ACCLAIM ENTERTAINMENT, INC.",0
#ln4	.string	"[ (C) 1995 TITAN SPORTS, INC. ]",0
#ln5	.string	"ALL DISTINCTIVE NAMES AND CHARACTER LIKENESSES",0
#ln6	.string	"USED HEREIN ARE TRADEMARKS OF TITAN SPORTS, INC.",0
#ln7	.string	"SUBLICENSED BY MIDWAY MANUFACTURING COMPANY",0
#ln8	.string	"FROM ACCLAIM ENTERTAINMENT INC.",0
#ln9	.string	"ALL RIGHTS RESERVED.",0
	.EVEN

#*****************************************************************************
*
* Show high score tables
*

 SUBRP	show_hstd
	calla	table_cmos_check	;make sure hscore CMOS is okay

	movi	hstd_mod,a0
	CALLA	SET_UP_PIXEL_WIPE

	movi	1,a5

	JSRP	print_beaten

	SLEEPK	1

	JSRP	BLOW_0_TO_1

	CALLA	RESET_FROM_PIXEL_WIPE

	SLEEP	TSEC/2
	MOVE	@starting_num,a9
	DEC	A9
	move	a9,@starting_num
	CMPI	BEATEN_TAB_ENTRIES-6,A9
	JRLT	SCROLL_TABLE_LOOP
	MOVI	BEATEN_TAB_ENTRIES-1,A9
	move	a9,@starting_num

SCROLL_TABLE_LOOP
	MOVK	22,A10
WAIT_ON_THOSE_BUTS
	SLEEP	1
	calla	get_all_buttons_cur2
	JRNZ	JUST_WAIT
	DSJS	A10,WAIT_ON_THOSE_BUTS
	CALLA	DELETE_ANY_OFF_TOP
	sleep	1
	MOVE	@starting_num,a9
	cmpi	BEATEN_TAB_ENTRIES-1,a9
	JRGE	JUST_WAIT
	inc	a9
	move	a9,@starting_num
	CALLA	draw_each_beaten_table_entry
	CALLA	MOVE_ALL_OBJS_UP
	jruc	SCROLL_TABLE_LOOP

JUST_WAIT
	CALLA	STOP_ALL_OBJS
	movi	5*TSEC,a10
	JSRP	wait_on_butn


	calla	table_cmos_check	;make sure hscore CMOS is okay

	movi	hstd_mod,a0
	CALLA	SET_UP_PIXEL_WIPE

	JSRP	print_hscores

	SLEEPK	1

	JSRP	BLOW_0_TO_1

	CALLA	RESET_FROM_PIXEL_WIPE

	SLEEP	TSEC/2
	movi	5*TSEC,a10
	JSRP	wait_on_butn

	MOVI	hstd_mod,A0
	CALLA	SET_UP_PIXEL_WIPE

	JSRP	print_winstreaks

	SLEEPK	1

	JSRP	BLOW_0_TO_1

	CALLA	RESET_FROM_PIXEL_WIPE

	SLEEP	TSEC/2
	movi	5*TSEC,a10
	JSRP	wait_on_butn

	RETP

hstd_mod
	.long	slateBMOD
	.word	0,0
	.long	0

#*****************************************************************************
*
* Show lava title page
*

 SUBRP	show_title

	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT

	clr	a0
	move	a0,@HALT
	move	a0,@dtype		;2d mode
	move	a0,@IRQSKYE

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	SLEEPK	2

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	movi	#title_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1		;create objects for background

	SLEEPK	2

	calla	display_unblank

	CREATE	CYCPID,#cycle_lava

	SLEEP	TSEC/2
	movi	8*TSEC,a10
	JSRP	wait_on_butn

	movi	CYCPID,a0
	calla	KIL1C

;fade down
	clr	a10
	movk	16,a11
	CREATE0	fade_down

	SLEEP	TSEC

	calla	display_blank

	RETP

#title_mod
	.long	LAVAPGBMOD
	.word	0,0
	.long	0

#cycle_lava
	movi	#cyc_t,a9
#lp0
	move	*a9+,a0,L

	calla	pal_getf
	move	a0,a8			;Pal thats needs changing

	move	*a9,a0,L
    	jrz	#cycle_lava

	calla	pal_getf
	move	a0,a11			;Pal to change into

	movi	BAKLST,a14
#lp
	move	*a14,a14,L
	jrz	#x
	move	*a14(OPAL),a2
	cmp	a8,a2
	jrne	#lp
;Found matching pal
	move	a11,*a14(OPAL)
	jruc	#lp	

#x	SLEEP	5
	jruc	#lp0

#cyc_t	.long	LAVA1_P
	.long	LAVA2_P
	.long	LAVA3_P
	.long	LAVA4_P
	.long	LAVA5_P
	.long	LAVA6_P
	.long	LAVA7_P
	.long	LAVA8_P
	.long	LAVA10_P
	.long	LAVA10_P
	.long	LAVA10_P
;	.long	LAVA9_P
	.long	LAVA10_P
	.long	LAVA8_P
	.long	LAVA7_P
	.long	LAVA6_P
	.long	LAVA5_P
	.long	LAVA4_P
	.long	LAVA3_P
	.long	LAVA2_P
	.long	LAVA1_P
	.long	LAVA1_P
	.long	LAVA1_P
	.long	LAVA1_P
	.long	LAVA1_P
	.long	LAVA1_P
	.long	LAVA1_P
	.long	LAVA1_P
	.long	LAVA1_P
	.long	LAVA1_P
	.long	LAVA1_P
	.long	LAVA1_P
	.long	LAVA1_P
	.long	0

;MJT Start
;Replace with correct artwork
;Keep this code around
;
;#*****************************************************************************
;*
;* Show WWF logo
;
; SUBRP	show_big_wwf_logo_screen_thingie
;
;	calla	display_blank
;	calla	WIPEOUT			;CLEAN SYSTEM OUT
;
;	clr	a0
;	move	a0,@HALT
;	move	a0,@dtype		;2d mode
;	move	a0,@IRQSKYE
;
;	movk	1,a0			;page flipping on
;	move	a0,@dpageflip
;
;	SLEEPK	2
;
;	movi	SCRNEND,a0		;[256,405]
;	move	a0,@SCRNLR,L
;
;	clr	a0
;	move	a0,@WORLDTLX,L
;	move	a0,@WORLDTLY,L
;
;	movi	#blank_mod,a0
;	move	a0,@BAKMODS,L
;	calla	BGND_UD1		;create objects for background
;
;	SLEEPK	2
;
;	calla	display_unblank
;
;	SLEEPK	10
;
;	movi	#logo_mod,a0
;	CALLA	SET_UP_PIXEL_WIPE
;
;	SLEEPK	1
;	
;	JSRP	BLOW_0_TO_1
;
;
;	SLEEP	TSEC/2
;	movi	8*TSEC,a10
;	JSRP	wait_on_butn
;
;;fade down
;	clr	a10
;	movk	16,a11
;	CREATE0	fade_down
;
;	SLEEP	TSEC
;
;	calla	display_blank
;
;	RETP
;
;#logo_mod
;	.long	comesoonBMOD
;	.word	0,0
;	.long	0
;#blank_mod
;	.long	wwfblankBMOD
;	.word	0,0
;	.long	0
;MJT End

#*****************************************************************************
*
* Show wrestler bios
*
	.bss	next_bio,16

 SUBRP	show_bios

	movi	#bio_mod,a0
	CALLA	SET_UP_PIXEL_WIPE

	movb	@next_bio,a10
	andi	00001111b,a10
	inc	a10
	cmpi	8,a10
	jrlt	#in_range
	clr	a10
#in_range
	
	;draw the logo
	PUSH	a10
	movb	a10,@next_bio


	MOVI	0AAh,a3
	MOVI	01Ah,a4
	MOVI	#bio_logos,a5
	clr	a7

	CALLR	MAKE_UP_LOGO

	;draw the mugshot
	PULL	a10
	PUSH	a10
	X32	a10
	addi	wrestler_mugs2,a10
	move	*a10,a9,L
	movi	[025h,0],a0
	movi	[0ACh,0],a1

	move	*a9+,a2,L
	clr	a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7

#mugcreatloop
	PUSH	a0,a1,a3,a4,a5,a6,a7
	calla	BEGINOBJ
	PULL	a0,a1,a3,a4,a5,a6,a7
	move	*a9+,a2,L
	jrnz	#mugcreatloop

	;attributes
	movi	[025h,0],a0
	movi	[0BCh,0],a1
	movi	ATTPL_G,a2
	movi	10,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7
	PUSH	a0,a1,a4,a5,a6,a7
	calla	BEGINOBJ
	PULL	a0,a1,a4,a5,a6,a7
	subi	2,a1
	movi	ATT_TXT,a2
	movi	11,a3
	PUSH	a0,a1
	calla	BEGINOBJ
	PULL	a0,a1

	;attribute bars
	PULL	a10
	PUSH	a10
	addi	[61,0],a0
	addi	[12,0],a1
	movi	ATTMTR_0,a2
	movi	11,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7

	movi	4,a9			;bar count
	X64	a10
	addi	wrestler_attributes,a10

#abc_loop
	PUSH	a0,a1,a3,a4,a5,a6,a7
	move	*a10+,a2,W
	X32	a2
	addi	attbars,a2
	move	*a2,a2,L
	calla	BEGINOBJ
	PULL	a0,a1,a3,a4,a5,a6,a7
	addi	[8,0],a1
	dsj	a9,#abc_loop

	;print the bio text
	;a11 becomes the halfwidth for current wrestler

	PULL	a10
	PUSH	a10
	X32	a10
	addi	#bio_data,a10
	move	*a10,a10,L
	move	*a10+,a11,W

	movi	20,a14
	move	a14,@mess_line_spacing

	movi	#bio_setup1,a2
	calla	setup_message
	movi	#bio_center,a14
	sub	a11,a14
	move	a14,@mess_cursx
	movi	#bio_message1,a4
	calla	print_string2

	movi	#bio_setup2,a2
	calla	setup_message
	movi	#bio_center,a14
	sub	a11,a14
	move	a14,@mess_cursx
	movi	#bio_message2,a4
	calla	print_string2

	;from text
	movi	#bio_y,a14
	move	a14,@mess_cursy
	movi	#bio_center,a14
	add	a11,a14
	move	a14,@mess_cursx

	move	*a10+,a4,L
	calla	print_string_R2

	;weight
	movi	#bio_y+20,a14
	move	a14,@mess_cursy
	movi	#bio_center,a14
	add	a11,a14
	move	a14,@mess_cursx

	move	*a10+,a0,W
	movi	999,a1
	calla	dec_to_asc
	calla	copy_string
	movi	#pounds,a4
	calla	concat_rom_string
	calla	print_string_R

	;height
	movi	#bio_y+40,a14
	move	a14,@mess_cursy
	movi	#bio_center,a14
	add	a11,a14
	move	a14,@mess_cursx

	move	*a10+,a0,W
	movi	999,a1
	calla	dec_to_asc
	calla	copy_string
	movi	#feet,a4
	calla	concat_rom_string
	move	*a10+,a0,W
	movi	999,a1
	calla	dec_to_asc
	calla	concat_string
	movi	#inches,a4
	calla	concat_rom_string
	calla	print_string_R


	;finish move
	movi	#bio_y+71,a14
	move	a14,@mess_cursy
	movi	#bio_center,a14
	add	a11,a14
	move	a14,@mess_cursx

	move	*a10+,a4,L
	calla	print_string_R2


	;quote
	movi	#bio_y+92,a14
	move	a14,@mess_cursy
	movi	#bio_center,a14
	move	a14,@mess_cursx
	movi	13,a14
	move	a14,@mess_line_spacing
	move	*a10+,a4,L
	calla	print_string_C2

	;music
	PULL	a10

	MOVE	@AMODE_LOOPS,A0
	CMPI	2,A0
	JRGE	NO_MUSIC

	ADJUST	ADJMUSIC
	JRNZ	NO_MUSIC

	X16	a10
	addi	#wrestler_tunes,a10
	move	*a10,a3,L
	.if MUSIC_ON
	calla	SNDSND
	.endif
NO_MUSIC

	JSRP	BLOW_0_TO_1

	CALLA	RESET_FROM_PIXEL_WIPE

	SLEEP	2*TSEC

	movi	6*TSEC,a10
	JSRP	wait_on_butn

	RETP


MAKE_UP_LOGO
	X64	a10
	add	A5,a10
	move	*a10+,a9,L
	move	*a10+,a0,W
	move	*a10,a1,W
	add	A3,a0
	add	A4,a1
	sll	16,a0
	sll	16,a1

	move	*a9+,a2,L
	clr	a3
	movi	DMAWNZ|M_SCRNREL,a4
	movi	CLSNEUT,a5
	clr	a6

#creatloop
	MOVE	A8,A10
	PUSH	a0,a1,a3,a4,a5,a6,a7
	calla	BEGINOBJ
	PULL	a0,a1,a3,a4,a5,a6,a7
	move	*a9+,a2,L
	jrnz	#creatloop
	RETS


#bio_center	.equ	270
#bio_halfwidth	.equ	87

#bio_y		.equ	118

#bio_setup1
	JAM_STR	osgmd8_ascii,5,0,0,#bio_y,SGMD8YEL,print_string2
#bio_message1
	.byte	"FROM:",1,"WEIGHT:",1,"HEIGHT:",1,"FINISHING",0
	.even

#bio_setup2
	JAM_STR	osgmd8_ascii,5,0,0,#bio_y+71,SGMD8YEL,print_string2
#bio_message2
	.byte	"MOVE:",0
	.even

#pounds
	.byte	" pounds",0
	.even

#feet
	.byte	" feet ",0
	.even

#inches
	.byte	" inches",0
	.even

#bio_data
	.long	#bhart_data,#razor_data,#taker_data,#yoko_data,#shawn_data
	.long	#bambam_data,#doink_data,#luger_data

#bhart_data
	.word	79			;halfwidth
	.long	#bhart_fromstr		;from
	.word	234,6,1			;pounds, feet, inches
	.long	#bhart_finish		;finishing move text
	.long	#bhart_quote		;quote text

#razor_data
	.word	77			;halfwidth
	.long	#razor_fromstr		;from
	.word	270,6,4			;pounds, feet, inches
	.long	#razor_finish		;finishing move text
	.long	#razor_quote		;quote text

#taker_data
	.word	78			;halfwidth
	.long	#taker_fromstr		;from
	.word	322,6,11		;pounds, feet, inches
	.long	#taker_finish		;finishing move text
	.long	#taker_quote		;quote text

#yoko_data
	.word	78			;halfwidth
	.long	#yoko_fromstr		;from
	.word	505,6,3			;pounds, feet, inches
	.long	#yoko_finish		;finishing move text
	.long	#yoko_quote		;quote text

#shawn_data
	.word	78			;halfwidth
	.long	#shawn_fromstr		;from
	.word	210,6,0			;pounds, feet, inches
	.long	#shawn_finish		;finishing move text
	.long	#shawn_quote		;quote text

#bambam_data
	.word	78			;halfwidth
	.long	#bambam_fromstr		;from
	.word	400,6,6			;pounds, feet, inches
	.long	#bambam_finish		;finishing move text
	.long	#bambam_quote		;quote text

#doink_data
	.word	78			;halfwidth
	.long	#doink_fromstr		;from
	.word	220,5,11		;pounds, feet, inches
	.long	#doink_finish		;finishing move text
	.long	#doink_quote		;quote text

#luger_data
	.word	81			;halfwidth
	.long	#luger_fromstr		;from
	.word	270,6,4			;pounds, feet, inches
	.long	#luger_finish		;finishing move text
	.long	#luger_quote		;quote text

#bhart_fromstr
	.byte	"calgary, alberta",0
	.even
#razor_fromstr
	.byte	"miami, florida",0
	.even
#taker_fromstr
	.byte	"death valley",0
	.even
#yoko_fromstr
	.byte	"polynesia",0
	.even
#shawn_fromstr
	.byte	"san antonio, tx",0
	.even
#bambam_fromstr
	.byte	"asbury park, nj",0
	.even
#doink_fromstr
	.byte	"ringling bros.",0
	.even
#luger_fromstr
	.byte	"world gym",0
	.even


#bhart_finish
	.byte	"sharpshooter",0
	.even
#razor_finish
	.byte	"razor's edge",0
	.even
#taker_finish
	.byte	"the tombstone",0
	.even
#yoko_finish
	.byte	"banzai splash",0
	.even
#shawn_finish
	.byte	"back suplex",0
	.even
#bambam_finish
	.byte	"flying headbutt",0
	.even
#doink_finish
	.byte	"poke in the eye",0
	.even
#luger_finish
	.byte	"charging forearm",0
	.even


#bhart_quote
	.byte	"{i am the excellence",1,"of execution.}",0
	.even
#razor_quote
	.byte	"{take a look at",1,"the bad guy.}",0
	.even
#taker_quote
	.byte	"{rest in peace}",0
	.even
#yoko_quote
	.byte	"{food!!!}",0
	.even
#shawn_quote
	.byte	"{shawn michaels is the",1,"sexiest man alive.}",0
	.even
#bambam_quote
	.byte	"{burn! burn! burn!}",0
	.even
#doink_quote
	.byte	"{i like little boys...heh heh!}",0
#luger_quote
	.byte	"{no! i am not a wrestler!}",0
	.even

#bio_mod
;	.long	bioscrnBMOD			;wrestler bios
	.long	slateBMOD			;wrestler bios
	.word	0,0
	.long	0

#bio_logos
	LWW	#bhart_logo,15,9
	LWW	#razor_logo,16,9
	LWW	#under_logo,17,9
	LWW	#yoko_logo,20,7
	LWW	#michael_logo,18,8
	LWW	#bambam_logo,18,7
	LWW	#doink_logo,24,8
	LWW	#luger_logo,10,7

#bhart_logo
	.long	HRT3,0
#razor_logo
	.long	RZR3,0
#under_logo	 
	.long	UND3,0
#yoko_logo
	.long	YOK3,0
#michael_logo
	.long	SHN3,0
#bambam_logo
	.long	BAM3,0
#doink_logo
	.long	DNK3,0
#luger_logo
	.long	LEX3,0

#wrestler_tunes
	.word	5,2,1,7,6,4,8,3

******************************************************************************
*
* A10 = # of ticks before timing out

 SUBR	wait_on_butn

#lp	SLEEPK	1

	calla	get_all_buttons_cur2
	jrz	#nobutn

	move	@SOUNDSUP,a0
	move	a0,@TEMP

      	clr	a0
	move	a0,@SOUNDSUP		;turn all sounds on

	movi	>b6,a0
	calla	triple_sound

	move	@TEMP,a0
	move	a0,@SOUNDSUP		;turn all sounds off
	jruc	#exit

#nobutn
	dsj	a10,#lp

#exit
	RETP

;MJT Start
;
;#*****************************************************************************
;* play vid clips (test)
;
; SUBRP	show_movie
;
;;bank select 0 bit is bit 8 of SYSCTRL register.
;
;	calla	display_blank
;	calla	WIPEOUT			;CLEAN SYSTEM OUT
;	calla	pal_clean
;
;	clr	a0
;	move	a0,@HALT
;	move	a0,@dtype		;2d mode
;	move	a0,@IRQSKYE
;
;	movk	1,a0			;page flipping on
;	move	a0,@dpageflip
;
;	SLEEPK	2
;
;	movi	SCRNEND,a0		;[256,405]
;	move	a0,@SCRNLR,L
;
;	clr	a0
;	move	a0,@WORLDTLX,L
;	move	a0,@WORLDTLY,L
;
;	movi	#movie_mod,a0
;	move	a0,@BAKMODS,L
;	calla	BGND_UD1		;create objects for background
;
;	calla	display_unblank
;
;;;;->	movi	shnvid_f,a8
;	clr	a9
;	movi	(100+20*512)*8,a10
;	JSRP	movie_run
;
;	clr	a0
;	move	a0,@dpageflip		;kill the page-flipping!
;
;	movi	6*TSEC,a10
;	JAUC	wait_on_butn
;
;#movie_mod
;	.long	slateBMOD			;wrestler bios
;	.word	0,0
;	.long	0
;
;
;#*****************************************************************************
;* print that big picture of 'vince'
;* leave up whatever was on screen until we're ready to make the switch
;
; SUBRP	show_vince
;
;	;disable auto page flipping
;	clr	a14
;	move	a14,@dpageflip
;
;	;dump the pic to the draw (inactive) page
;;;;->	movi	vinsml_f,a8
;	clr	a9
;	movi	(#vince_x+512*(#vince_y))*8,a10
;	JSRP	movie_run
;
;	;swap 'em...
;	callr	page_flip
;
;	;...and wait
;	movi	6*TSEC,a10
;	JSRP	wait_on_butn
;
;	;fade down
;	clr	a10
;	movk	16,a11
;	CREATE0	fade_down
;
;	SLEEP	TSEC
;
;	RETP
;
;
;#vince_x	equ	(400->186)/2
;#vince_y	equ	(256->F5)/2
;

#*****************************************************************************
* flips the active page
;
; SUBRP	page_flip
;
;	movi	->1004,a0
;	move	@dpage,a14
;	jrz	#tp1
;	movi	-4,a0
;#tp1
;	move	a0,@DPYSTRT
;	move	a0,@DPYADR
;
;	move	@dpage,a0
;	not	a0
;	move	a0,@dpage
;
;	rets
;MJT End

#*****************************************************************************

;NOW LETS SEE...
;WORD	TWO PIXELS
;WORD	TWO PIXELS
;WORD	TWO PIXELS
;WORD	TWO PIXELS
;LONG	XVEL
;LONG	YVEL
;LONG	XPOS
;LONG	YPOS

DCS_LOGO
	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT
	movk	1,a0
	move	a0,@dpageflip		;page flipping on

	calla	display_unblank

	MOVI	[200,0],A0
	MOVI	[120,0],A1
	MOVI	dcslogo,a2
	CLR	A3
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	addi	CLSNEUT,a5	;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	CALLA	BEGINOBJW
	MOVE	*A8(OPAL),A0
	MOVE	A0,@DCS_PAL
	SLEEP	10

	MOVI	DMACTRL,B1
WAIT_110
	MOVE	*B1,B2,L
	JRN	WAIT_110
	PUSHST
	DINT
	PUSH	A8

	MOVI	(186*5),A6
	MOVI	[6,0],A5
	MOVI	DCS_BIT_TABLE,A2
	MOVI	44,A11
	MOVE	*A8(OSAG),A8,L
	ADDI	02000000H,A8

NEXT_X_PIXEL1
	MOVI	31,A10
	MOVI	[107,0],A4

NEXT_X_PIXEL2
	CALLR	SETUP_ALL_PIX1

	MOVI	32000H,A0
	CALLA	RNDRNGS
	MOVE	A0,A1
	SRA	7,A1
	NEG	A1
	MOVE	A1,*A2+,L  ;XVEL
	
	MOVE	A0,*A2+,L  ;XVEL

	MOVE	A4,*A2+,L  ;XPOS
	ADD	A5,A4 
	ADDK	30,A8
	DSJS	A10,NEXT_X_PIXEL2
	ADD	A6,A8
	DSJS	A11,NEXT_X_PIXEL1

	PULL	A8
	POPST
	SLEEP	1
	MOVE	*A8(OFLAGS),A1
	ORI	M_NODISP,A1
	MOVE	A1,*A8(OFLAGS)

	MOVI	ADD_PIXEL_ROT,A0
	MOVE	A0,@WHICH_SCREEN,L
	SLEEP	254

	MOVI	DUMRETS,A0
	MOVE	A0,@WHICH_SCREEN,L

	MOVE	*A8(OFLAGS),A1
	ANDI	0FFFFH-M_NODISP,A1
	MOVE	A1,*A8(OFLAGS)

	SLEEP	10


	MOVI	DMACTRL,B1
WAIT_111
	MOVE	*B1,B2,L
	JRN	WAIT_111

	PUSHST
	DINT
	PUSH	A8
	MOVI	4C000H,A3

	MOVI	(186*5)*3,A6
	MOVE	*A8(OSAG),A8,L
	ADDI	02000000H,A8
	MOVI	DCS_BIT_TABLE,A2
	MOVI	020H,A5
	MOVI	04000H,A7
	MOVI	21,A11
NEXT_Y_PIXELS
	MOVI	0358H,A4
	MOVI	46,A10
NEXT_X_PIXELS

	CALLR	SETUP_ALL_PIX1
	CALLR	SETUP_ALL_PIX2

	ADDK	20,A8

	MOVI	0FH,A0
	PUSH	A1
	CALLA	RNDRNGS
	PULL	A1
	MOVE	A0,*A2+,L  ;XVEL

	MOVI	2100H,A0
	PUSH	A1
	CALLA	RNDRNGS
	PULL	A1
	SLL	1,A0
	MOVE	A0,*A2+,L  ;YVEL

	MOVE	A4,*A2+,L  ;XPOS
	MOVE	A3,*A2+,L  ;YPOS
	ADD	A5,A4 
	DSJS	A10,NEXT_X_PIXELS
	ADDK	10,A8
	ADD	A6,A8
	ADD	A7,A3
	DEC	A11
	JRNZ	NEXT_Y_PIXELS

	PULL	A8
	POPST

	CALLA	DELOBJA8

	MOVI	ADD_PIXEL_VEL,A0
	MOVE	A0,@WHICH_SCREEN,L

	MOVK	3,A8
FLASH_WHITE
	MOVI	0FFFFH,A0
	MOVE	A0,@IRQSKYE
			   
	SLEEP	1

	CLR	A0
	MOVE	A0,@IRQSKYE
			   
	SLEEP	1
	DSJS	A8,FLASH_WHITE

	SLEEP	100

	RETP

SETUP_ALL_PIX2
	MOVE	A8,A14
	ADD	A6,A14
	ADD	A6,A14
	CALLR	SETUP_TWO_PIX
	ADDK	10,A14
	JRUC	SETUP_TWO_PIX

SETUP_ALL_PIX1
	MOVE	A8,A14
	CALLR	SETUP_TWO_PIX
	ADDK	10,A14
	CALLR	SETUP_TWO_PIX

	MOVE	A8,A14
	ADD	A6,A14
	CALLR	SETUP_TWO_PIX
	ADDK	10,A14

SETUP_TWO_PIX
	MOVE	*A14,A0
	SLL	32-5,A0
	SRL	32-5,A0

	MOVE	*A14(5),A9
	SLL	32-5,A9
	SRL	32-5-8,A9

	OR	A9,A0
	MOVE	A0,*A2+
	RETS

ADD_PIXEL_VEL
	MOVI	DMACTRL,B1
	MOVE	@DCS_PAL,A3
	CALLR	SET_UP_PAL

	MOVI	01F0H,A4
	MOVI	966,A9
	MOVI	3*32,A12
	MOVE	@page_addr+010h,a14
	MOVE	@page_addr,A10
	sll	3,a10
	sll	12,a14
	or	a14,a10

	MOVI	0FA000H,A14
	MOVI	0FF000H,A13
	MOVI	0FFFF8H,A11

	PUSHST
	DINT
	MOVI	DCS_BIT_TABLE,A8
	.ALIGN
NEXT_PIXEL_VEL
	MMFM	A8,A0,A1,A2,A3,A5,A6,A7
	ADD	A4,A2	;DO YACCEL
	JRZ	NO_PLOT_ANYTHING

	ADD	A2,A0	;Y
	CMP	A14,A0
	JRGE	NO_WORRY_ABOUT_Y_BOUNCE
	ADD	A3,A1	;X
	MMTM	A8,A0,A1,A2

	AND	A11,A1
	AND	A13,A0
	OR	A0,A1
	ADD	A10,A1

	MOVE	A7,*A1,L
	MOVE	A6,*A1(01000H),L
	MOVE	A5,*A1(02000H),L
	ADD	A12,A8
NO_PLOT_ANYTHING
	DSJS	A9,NEXT_PIXEL_VEL
	POPST
	RETS

NO_WORRY_ABOUT_Y_BOUNCE
	MOVE	A4,A2
	NEG	A2
	MMTM	A8,A0,A1,A2
	ADD	A12,A8
	DEC	A9
	JRNZ	NEXT_PIXEL_VEL
	POPST
	RETS

SET_UP_PAL	;PAL IN A3
	MOVE	*B1,B2,L
	JRN	SET_UP_PAL
	MMTM	SP,A2,A3,A4,A5,A6,A7,A9
	MOVI	01000100H,A2
	MOVI	[4,4],A4
	CLR	A5
	MOVI	020000000H,A6
	MOVI	0E0020000H,A9

	MOVI	DMAREGS,A7

	mmtm	A7,A2,A3,A4,A5,A6,A9

	MMFM	SP,A2,A3,A4,A5,A6,A7,A9
	RETS

ADD_PIXEL_ROT
	MOVI	DMACTRL,B1
	MOVE	@DCS_PAL,A3
	CALLR	SET_UP_PAL

	MOVI	2*32,A5
	MOVE	@page_addr+010h,a14
	MOVE	@page_addr,A10
	sll	3,a10
	sll	12,a14
	or	a14,a10
	ADDI	4C000H,A10
	MOVI	44,A9
	MOVI	31,A13
	MOVI	02000H,A4

	MOVI	0FFFF8H,A11

	MOVI	DCS_BIT_TABLE,A12
	.ALIGN
NEXT_PIXEL_ROT
	MMFM	A12,A0,A1,A2,A6,A7

	ADD	A2,A1	;XVEL
	ADD	A1,A0	;X POS
	MMTM	A12,A0,A1

	SRA	16-3,A0
	AND	A11,A0
	ADD	A10,A0

	MOVE	A7,*A0,L
	MOVE	A6,*A0(01000H),L
	ADD	A5,A12
	DSJS	A13,NEXT_PIXEL_ROT
	ADD	A4,A10
	MOVI	31,A13
	DSJS	A9,NEXT_PIXEL_ROT
	RETS


******************************************************************************

GENERIC_DISPLAY
	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT

	clr	a0
	move	a0,@HALT
	move	a0,@dtype		;2d mode
	move	a0,@IRQSKYE

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	SLEEPK	2

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	movi	hstd_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1		;create objects for background

	SLEEPK	2

	calla	display_unblank
	RETP


	.end
