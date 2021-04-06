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
	.include	"crowdimg.glo"
	.include	"fontsimg.glo"
	.include	"miscimg.glo"
	.include	"bgndtbl.glo"
	.include	"ropeimg.glo"

	.include	"logo.tbl"
	.include	"logo.glo"
	.include	"dip.equ"

******************************************************************************
* EXTERNAL REFERENCES

	.ref	ADJ_PAGE,BAKMODS,BEATEN_TAB_ENTRIES,BGND_UD1
	.ref	BLOW_0_TO_1,CLOSE_PROGRESS_SCREEN,CRD_SCRN2
	.ref	DELETE_ANY_OFF_TOP,DUMRETS,GAMSTATE,HALT,GET_ADJ
	.ref	IRQSKYE,MOVE_ALL_OBJS_UP,RC_BYTEI,RD7FONT
	.ref	RESET_FROM_PIXEL_WIPE,RNDRNG0,RNDRNGS,RemapIO
	.ref	SET_UP_PIXEL_WIPE,SOUNDSUP,SPECIAL_WIPEOUT,STOP_ALL_OBJS
	.ref	STRCNRMO_2,WHICH_SCREEN,WIPEOUT
	.ref	copy_string,current_round
	.ref	dec_to_asc,dpageflip,draw_each_beaten_table_entry,fade_down
	.ref	fade_up,get_all_buttons_cur2,index1,match_cnt
	.ref	mess_cursx,mess_cursy,mess_line_spacing,nosounds
	.ref	p1rounds,p2rounds,page_addr,pal_clean,pal_getf,print_beaten
	.ref	print_hscores,print_string2,print_string_C2
	.ref	print_winstreaks,setup_message,start_match
	.ref	starting_num,table_cmos_check,total_matches,triple_sound
	.ref	wrestler_mugs2,set_volume,INIT_LADDER_TABLE
	.ref	wsf14_ascii,wsf10_ascii,print_string
	.ref	message_ascii,mess_cursx2
	.ref	osgemd_ascii,LADDER,CURRENT_LADDER,NUM_OPPS
	.ref	hscore_colcyc2,ogmd10_ascii,CLOSE_SCREEN_LINE
	.ref	OPEN_SCREEN_LINE,HORZTRN1,HORZTRN2,TOP_LEFT
	.ref	BOT_RIGHT,LINES,not_blank,doing_dcs_reset,QSNDRST
	.REF	MUSIC_HAP,JUDDER_SHADOW
	.REF	DRKTRPLTP
	.ref	STRCNRMO_1
	.ref	_clk_rd
	.ref	_auto_update_save
	.ref	_GetTime
	.ref	print_message
	.ref	concat_string
	.ref	concat_rom_string
	.ref	print_string_C
	.ref	print_string_C2
	.ref	copy_rom_string
	.ref	wgsf24_ascii
	.ref	wsf14_ascii
	.ref	WSF_R_P
	.ref	_tseconds
	.ref	_tminutes
	.ref	_thours
	.ref	_tday
	.ref	_tdate
	.ref	_tmonth
	.ref	_tyear
	.ref	WHERE_WRESTLMANIA_SPARKLES,SPRINKLE_GLINTS
	.ref	RANDOM_SPARKLE
	.ref	READ_DIP
	.globl	hstd_mod
	.ref	print_inter,belt_type
	.ref	draw_each_inter_table_entry
	.ref	INTER_TAB_ENTRIES
	.REF	print_tag
	.REF	RNDPER
	.REF	MAYBE_TOUGH_ENOUGH
	.ref	osgmd8_ascii,SGMD8WHT
	.ref	story_bgnd
	.ref	hscore_colcyc,hscore_colcyc2

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

	.BSS	LOGOMOD_START,(40H*20)+32
	.BSS	LOGOMOD_END,0

	.bss	bios_type,16
	.bss	nb_save,16

	.text


********************************
* Attract mode (Process)


 SUBR	attract_mode

	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT

	;let the sound board reset finish up.
	SLEEPK	8

	clr	a3
	calla	SNDSND

	movi	INAMODE,a14		;set GAMSTATE
	move	a14,@GAMSTATE

	clr	a0			;clear matches since attmode cntr
	move	a0,@total_matches,W
	MOVE	A0,@AMODE_LOOPS
	MOVE	A0,@MUSIC_HAP

	movk	1,a0
	move	a0,@dpageflip		;page flipping on

	calla	display_unblank



	JSRP	dan_test






;	;temp!
;#foo	JSRP	DO_HINTS
;	jruc	#foo

#loop
* Please, stop messing with this ! If you want it changed, ask me ! - Jake
	JSRP	show_hstd
;TEST PURPOSES ONLY
;	.ref	show_wrestler_end_story
;	.ref	which_player
;	.ref	PSTATUS
;
;	clr	a14
;	move	a14,@PSTATUS
;
;	move	a14,@which_player
;	JSRP	show_wrestler_end_story
;
;	movk	1,a14
;	move	a14,@which_player
;	JSRP	show_wrestler_end_story
;
;	movk	2,a14
;	move	a14,@which_player
;	JSRP	show_wrestler_end_story
;
;	movk	3,a14
;	move	a14,@which_player
;	JSRP	show_wrestler_end_story
;
;	movk	4,a14
;	move	a14,@which_player
;	JSRP	show_wrestler_end_story
;
;	movk	5,a14
;	move	a14,@which_player
;	JSRP	show_wrestler_end_story
;
;	movk	6,a14
;	move	a14,@which_player
;	JSRP	show_wrestler_end_story
;
;	movk	8,a14
;	move	a14,@which_player
;	JSRP	show_wrestler_end_story
;
;END TEST

	JSRP	DCS_LOGO
;	JSRP	show_sports_logo
	JSRP	show_gameplay
	JSRP	creditscreen
	JSRP	show_title
	JSRP	show_gameplay
	JSRP	creditscreen
	JSRP	DO_HINTS
	JSRP	show_gen_tips
	JSRP	show_bios
	movk	1,a14
	move	a14,@bios_type
	move	@next_bio,a14
	move	a14,@nb_save
	dec	a14
	andi	7,a14
	move	a14,@next_bio
	movi	story_bgnd,a0
	JSRP	show_bios_tips
	clr	a14
	move	a14,@bios_type
	move	@nb_save,a14
	move	a14,@nb_save
	JSRP	show_operatormsg

	calla	RemapIO			;Remap the I/O
	MOVE	@AMODE_LOOPS,A0
	INC	A0
	MOVE	A0,@AMODE_LOOPS

	btst	0,a0
	jrnz	#loop
	JSRP	creditscreen
;	JSRP	show_hstd
	JSRP	show_time_date
	
	MOVE	@AMODE_LOOPS,A0
	andk	7,a0
	jrnz	#loop
	
	JSRP	show_copyright
	JSRP	aama_message

	clr	a0
	move	a0,@AMODE_LOOPS
	move	a0,@SOUNDSUP		;turn all sounds on

	jruc	#loop

aama_message
	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT

	clr	a0
	move	a0,@HALT
	move	a0,@dtype		;2d mode
	move	a0,@IRQSKYE

	clr	a0	;movk	1,a0			;page flipping on
	move	a0,@dpageflip

	SLEEPK	2

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

;	movi	hstd_mod,a0
;	move	a0,@BAKMODS,L
;	calla	BGND_UD1		;create objects for background
;
;	SLEEPK	2
	 
;	calla	display_unblank


	movi	blue_grad_pal,a0
	JSRP	do_the_grad_thang

	clr	a0
	movi	[>1111,0000],a6		;pal 0, color 17
	movi	#ln1,a8
	movi	[54+60-20,200],a9
 	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_2

	clr	a0
	movi	[>1111,0000],a6		;pal 0, color 17
	movi	#ln2,a8
	movi	[54+60,>b1],a9
	JSRP	STRCNRMO_2

	clr	a0
	movi	[>0606,0000],a6		;pal 0, color 17
	movi	#ln2b,a8
	movi	[54+60,>104],a9
	JSRP	STRCNRMO_2

	clr	a0
	movi	[>1111,0000],a6		;pal 0, color 17
	movi	#ln3,a8
	movi	[54+71,200],a9
	JSRP	STRCNRMO_2

	clr	a0
	movi	[>1111,0000],a6		;pal 0, color 17
	movi	#ln4,a8
	movi	[54+82,200],a9
	JSRP	STRCNRMO_2

	clr	a0
	movi	[>1111,0000],a6		;pal 0, color 17
	movi	#ln5,a8
	movi	[54+93,200],a9
	JSRP	STRCNRMO_2


	clr	a10
	movk	8,a11
	CREATE	FADE_PID,fade_up

	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	2
	calla	display_unblank

;Explanation - We MUST allow the fade process created above
;to finish because if someone wacks out below, the fade
;process is still running and JakeO's code to do his wipe
;across the screen stuff for the high score table starts running.
;His code uses the FADERAM area for those screen wipes and if a fader
;is running, the data in those areas gets changed by the fader process.
;Unfortunately, some of the data he is using is used as pointers in a
;memory to memory copy loop and if those values get changed the memory to
;memory copy goes haywire and starts scribbling all over the place causing
;a lockup.  NOTE - The errant writes CAN and do occur into the CMOS area.
;There are 4 ways to solve the problem.
;
;   1. Guarentee that the fader is allowed to run to completion.
;
;   2. Kill off the fader after wacking out.
;
;   3. Use a different area of memory for the screen wipes.
;
;   4. Shoot Jake.
;
;Not wanting to go to jail I chose option 3 cause we got plenty of memory.
;
	SLEEPK	20

	movi	4*TSEC,a10
	JSRP	wait_on_butn

;	clr	a10
;	movk	16,a11
;	CREATE	FADE_PID,fade_down
;
;	SLEEP	TSEC
;
;	calla	display_blank

	RETP

;	movi	CLSNEUT|TYPTEXT|SUBTXT,a0
;	calla	obj_del1c


;	calla	display_on
;	calla	view_page_0
;	movi	>40*6,a10
;	JSRP	fadein_jsrp
;	jruc	amode_fade_retp

;	RETP

#ln1	.string	"AAMA PARENTAL ADVISORY",0
#ln2	.string	"LIFE-LIKE VIOLENCE",0
#ln2b	.string	"- MILD",0
#ln3	.string	"CONTAINS SELECTED SCENES INVOLVING",0
#ln4	.string	"HUMAN-LIKE CHARACTERS ENGAGED IN",0
#ln5	.string	"COMBATIVE ACTIVITY.",0
	.byte	0
	.even


do_the_grad_thang

	calla	pal_getf

	SLEEPK	2

	clr	a3
    	movi	>00000101,a1

	movi	31,a10
loop	movi	>00020190,a2
	movi	>2000000,a4
	movi	>800c,a5
	calla	QDMAN	;dman
	addi	>01010000,a1
	addi	>00020000,a3
	dsj	a10,loop

	addi	>00840000,a3

	movi	32,a10
loop2	movi	>00020190,a2
	movi	>2000000,a4
	movi	>800c,a5
	calla	QDMAN	;dman
	subi	>01010000,a1
	addi	>00020000,a3
	dsj	a10,loop2

	SLEEPK	4

	RETP

**************************************************************************
*                                                                        *
* dman - manual dma, all regs must be setup upon calling		 		*
* a1 = [constant color,palette]						 			*
* a2 = size [h,w]							 			*
* a3 = destination [y,x]						 				*
* a4 = starting address							 			*
* a5 = [offset,control]							 			*
*                                                                        *
**************************************************************************
dman

*manual dma (setup your own regs)
*inputs:
*a1: constant color:palette
*a2: vsize:hsize
*a3: destination y:x
*a4: sag
*a5: offset:control
qdman:
	MMTM	sp,a2,a4,a13
	jruc	qdma1


**************************************************************************
*												*
*		   dma queue support routines						*
*												*
**************************************************************************
*
* qdma puts image on dma q
* inputs:
* a1: constant color:palette
* a3: destination y:x
* a5: offset:control
* a14: address of image header
* gets: a2=h/w; a4=sag
*
;qdma
;	mmtm	sp,a2,a4,a13
;	move	*a14,a2,l		;get vsize:hsize
;	move	*a14(isag),a4,l		;get sag

qdma1
;	movk	1,a13
;	move	a13,@qdmaflg,w		;q being modified

	.ref	DMAQCUR,DMAQ

	move	@DMAQCUR,a13,L
	cmpi	DMAQ,a13
	jrls	qdmax			;q overload, can it

	mmtm	a13,a1,a2,a3,a4,a5
	move	a13,@DMAQCUR,L

;	clr	a13
;	move	a13,@qdmaflg,w

qdmax	MMFM	sp,a2,a4,a13
	rets

;*************************************************************************

blue_grad_pal
	.word	32

	.word	31
	.word	30
	.word	29
	.word	28
	.word	27
	.word	26
	.word	25
	.word	24
	.word	23
	.word	22
	.word	21
	.word	20
	.word	19
	.word	18
	.word	17
	.word	16

	.word	15
	.word	14
	.word	13
	.word	12
	.word	11
	.word	10
	.word	9
	.word	8
	.word	7
	.word	6
	.word	5
	.word	4
	.word	3
	.word	2
	.word	1
	.word	0

************  clear screen routine  *********************

;clr_scrn
;	clr	a0
;	mmtm	sp,a1,a2,a3
;	move	@displayon,a3,w
;	clr	a1
;	move	a1,@displayon,w
;;	callr	dmaqwait			;wait on dma
;	clr	a1
;	move	a1,@cmapsel,w			;select color map 0
;	movi	screen,a1,l
;	movi	((scrne-2000h)-screen)/32,a2,l
;clrlp	move	a0,*a1+,l
;	dsjs	a2,clrlp
;	move	a3,@displayon,w
;	mmfm	sp,a1,a2,a3
;	rets


#****************************************************************
* show_gameplay

 SUBRP	show_gameplay

	movk	1,a0
	move	a0,@current_round
	move	a0,@match_cnt

	move	a0,@p1rounds
	move	a0,@p2rounds

	movk	7,a0
	calla	RNDRNG0
	cmpi	7,a0
	jrnz	#bug
	inc	a0

#bug	move	a0,@index1

	;initialize NUM_OPPS and CURRENT_LADDER
	;choose at random a battle between #2 and #6 on the ladder

	clr	a14
	move	a14,@belt_type

	calla	INIT_LADDER_TABLE

	movk	5,a0
	calla	RNDRNG0
	addk	1,a0
	X32	a0
	addi	LADDER,a0
	move	a0,@CURRENT_LADDER,L
	move	*a0,a14,L
	srl	24,a14
	move	a14,@NUM_OPPS

	CALLR	TURN_SOUNDS_OFF_IF_NEED

	JSRP	CLOSE_PROGRESS_SCREEN
	calla	SPECIAL_WIPEOUT

;Eventually, we should show just quick clips of cool gameplay.
	movk	1,a0
	move	a0,@SHOW_CRD_FLAG

	CALLR	TURN_SOUNDS_OFF_IF_NEED

	CREATE	AMODE_GAMEPLAY_PID,start_match

	CALLA	MAYBE_TOUGH_ENOUGH

	SLEEP	3*60

	movi	10*TSEC,a10
	JSRP	wait_on_butn

;Freeze action in interesting spots...
;knockout processes
	movk	1,a0
	move	a0,@HALT

;Stop wrestler procs
;Stop sweat
;Allow shadows to still shake

	CREATE0	DO_SET_IMAGES

	movi	ACTIVE,a3,L

#lp	move	*a3,a3,L	;Get next
	jrz	#x		;End?
	move	*a3(PWAKE),a0,L
	.ref	DO_SET_IMAGES
	cmpi	DO_SET_IMAGES,a0
	jrz	#lp

	move	*a3(PTIME),a14	;Add sleep
	addi	3*60,a14
	move	a14,*a3(PTIME)
	jruc	#lp
#x
	SLEEP	60

;fade down
	clr	a10
	movk	16,a11
	CREATE	FADE_PID,fade_down

	SLEEPK	32

	calla	display_blank

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
* Show time and date
*

 SUBRP	show_time_date

	calla	READ_DIP
	btst	DPTDON_B,a0
	jrz	#std_exit

	move	@_clk_rd,a8,L		;Save current auto update state
	move	a8,@_auto_update_save,L
	clr	a8			;Enable auto update
	move	a8,@_clk_rd,L
	JSRP	_GetTime

	SLEEPK	30

	JSRP	GENERIC_DISPLAY

	movi	#date_time_prompt,a2
	calla	print_message
	
	movi	#day_of_week_setup,a2
	calla	setup_message
	move	@_tday,a4
	cmpi	1,a4
	jrlt	#bad_day
	cmpi	8,a4
	jrlt	#do_day
#bad_day
	movk	1,a4
#do_day
	subk	1,a4
	sll	5,a4
	addi	#day_of_week_table,a4
	move	*a4,a4,L
	calla	print_string_C2
	

	move	@_tmonth,a4
	cmpi	1,a4
	jrlt	#bad_month
	cmpi	13,a4
	jrlt	#do_month
#bad_month
	movk	1,a4
#do_month
	subk	1,a4
	sll	5,a4
	addi	#month_table,a4
	move	*a4,a4,L
	calla	copy_rom_string

	move	@_tdate,a0
	cmpi	1,a0
	jrlt	#bad_date
	cmpi	32,a0
	jrlt	#do_date
#bad_date
	movk	1,a0
#do_date
	movi	31,a1
	calla	dec_to_asc
	calla	concat_string

	movi	#d_sep,a4
	calla	concat_rom_string

	move	@_tyear,a0
	jrn	#bad_year
	cmpi	99,a0
	jrlt	#do_year
#bad_year
	clr	a0
#do_year
	cmpi	9,a0
	jrgt	#year_gt_9
	movi	#zero_year,a4
	PUSHP	a0
	calla	concat_rom_string
	PULLP	a0
#year_gt_9
	movi	99,a1
	calla	dec_to_asc
	calla	concat_string

	movi	#date_setup,a2
	calla	setup_message
	calla	print_string_C

	move	@_thours,a0
	jrn	#bad_hour
	cmpi	24,a0
	jrlt	#do_hour
#bad_hour
	clr	a0
#do_hour
	movi	12,a1
	modu	a1,a0
	jrnz	#not_mid_or_noon
	movk	12,a0
#not_mid_or_noon
	movi	13,a1
	calla	dec_to_asc
	calla	copy_string

	movi	#t_sep,a4
	calla	concat_rom_string

	move	@_tminutes,a0
	jrn	#bad_minute
	cmpi	60,a0
	jrlt	#do_minute
#bad_minute
	clr	a0
#do_minute
	cmpi	9,a0
	jrgt	#min_gt_9
	movi	#zero_year,a4
	PUSHP	a0
	calla	concat_rom_string
	PULLP	a0
#min_gt_9
	movi	60,a1
	calla	dec_to_asc
	calla	concat_string

	movi	#time_setup,a2
	calla	setup_message
	calla	print_string_C


	movi	#its_time_to_message,a2
	calla	print_message

	movi	#wrestlemania_message,a2
	calla	print_message

	SLEEPK	25		; Min time to display

	movi	TSEC*5,a2
#wait_loop
	PUSHP	a2
	SLEEPK	1
	PULLP	a2
	calla	get_all_buttons_cur2
	jrnz	#time_date_done
	dsjs	a2,#wait_loop
#time_date_done
;	move	@_auto_update_save,a8,L	;Restore Auto Update state
	clr	a8
	not	a8
	move	a8,@_clk_rd,L

#std_exit
	RETP

#date_time_prompt
	JAM_STR	ogmd10_ascii,10,0,200,40,SGMD8GLD,print_string_C2
	.string	"THE DATE AND TIME IS...",0
	.even

#its_time_to_message
	JAM_STR	ogmd10_ascii,10,0,200,150,SGMD8GLD,print_string_C2
	.string	"THAT MEANS IT'S TIME TO PLAY...",0
	.even

#wrestlemania_message
	JAM_STR	wgsf24_ascii,10,0,200,180,WGFS_W_P,print_string_C2
	.string	"WRESTLEMANIA",0
	.even

#day_of_week_setup
	JAM_STR	wsf14_ascii,10,0,200,72,WSF_R_P,print_string_C2
	.even

#date_setup
	JAM_STR	wsf14_ascii,10,0,200,92,WSF_R_P,print_string_C2
	.even

#time_setup
	JAM_STR	wsf14_ascii,10,0,200,112,WSF_R_P,print_string_C2
	.even

#d_sep
	.string	", 19",0
	.even

#t_sep
	.string	":",0
	.even

#zero_year
	.string	"0",0
	.even

#monday_str
	.string	"MONDAY",0
	.even
#tuesday_str
	.string	"TUESDAY",0
	.even
#wednesday_str
	.string	"WEDNESDAY",0
	.even
#thursday_str
	.string	"THURSDAY",0
	.even
#friday_str
	.string	"FRIDAY",0
	.even
#saturday_str
	.string	"SATURDAY",0
	.even
#sunday_str
	.string	"SUNDAY",0
	.even

#january_str
	.string	"JANUARY ",0
	.even
#february_str
	.string	"FEBRUARY ",0
	.even
#march_str
	.string	"MARCH ",0
	.even
#april_str
	.string	"APRIL ",0
	.even
#may_str
	.string	"MAY ",0
	.even
#june_str
	.string	"JUNE ",0
	.even
#july_str
	.string	"JULY ",0
	.even
#august_str
	.string	"AUGUST ",0
	.even
#september_str
	.string	"SEPTEMBER ",0
	.even
#october_str
	.string	"OCTOBER ",0
	.even
#november_str
	.string	"NOVEMBER ",0
	.even
#december_str
	.string	"DECEMBER ",0
	.even

#day_of_week_table
	.long	#sunday_str
	.long	#monday_str
	.long	#tuesday_str
	.long	#wednesday_str
	.long	#thursday_str
	.long	#friday_str
	.long	#saturday_str

#month_table
	.long	#january_str
	.long	#february_str
	.long	#march_str
	.long	#april_str
	.long	#may_str
	.long	#june_str
	.long	#july_str
	.long	#august_str
	.long	#september_str
	.long	#october_str
	.long	#november_str
	.long	#december_str



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

	clr	a0
	movi	[>1111,0000],a6		;pal 0, color 17
	movi	#ln1,a8
	movi	[50+60,200],a9
 	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_2

	clr	a0
	movi	#ln2,a8
	movi	[62+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_2

	clr	a0
	movi	#ln3,a8
	movi	[74+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_2

	clr	a0
	movi	#ln4,a8
	movi	[86+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_2

	clr	a0
	movi	#ln5,a8
	movi	[98+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_2

	clr	a0
	movi	#ln6,a8
	movi	[110+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_2

	clr	a0
	movi	#ln7,a8
	movi	[122+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_2

	clr	a0
	movi	#ln8,a8
	movi	[134+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_2

	clr	a0
	movi	#ln9,a8
	movi	[146+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_2

	movi	[200,0],a0
	movi	[4bh-10,0],a1
	movi	SMWWF2,a2			;* image
	movi	20000,a3
	movi	DMAWNZ|M_NOCOLL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ

	clr	a10
	movk	8,a11
	CREATE	FADE_PID,fade_up

	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	2
	calla	display_unblank

	SLEEPK	20

	movi	3*TSEC,a10
	JSRP	wait_on_butn

	movi	CLSNEUT|TYPTEXT|SUBTXT,a0
	calla	obj_del1c


	clr	a0
	movi	[>1111,0000],a6		;pal 0, color 17
	movi	#ln10,a8
	movi	[50+60,200],a9
 	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_2

	clr	a0
	movi	#ln11,a8
	movi	[62+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_2

	clr	a0
	movi	#ln12,a8
	movi	[74+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_2

	clr	a0
	movi	#ln13,a8
	movi	[86+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_2

	clr	a0
	movi	#ln14,a8
	movi	[98+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_2

	clr	a0
	movi	#ln15,a8
	movi	[110+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_2

	clr	a0
	movi	#ln16,a8
	movi	[122+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_2

	clr	a0
	movi	#ln17,a8
	movi	[134+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_2

	clr	a0
	movi	#ln18,a8
	movi	[146+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_2

	clr	a0
	movi	#ln19,a8
	movi	[158+60,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_2

	SLEEPK	20

	movi	3*TSEC,a10
	JSRP	wait_on_butn

	RETP

#ln1	.string	"VIDEO GAME SOFTWARE DESIGNED AND DEVELOPED",0
#ln2	.string	"BY MIDWAY MANUFACTURING COMPANY",0
#ln3	.string	"(C) 1995 ASSIGNED TO ACCLAIM ENTERTAINMENT, INC.",0
#ln4	.string	"[ (C) 1995 TITANSPORTS, INC. ]",0
#ln5	.string	"ALL DISTINCTIVE NAMES AND CHARACTER LIKENESSES",0
#ln6	.string	"USED HEREIN ARE TRADEMARKS OF TITANSPORTS, INC.",0
#ln7	.string	"SUBLICENSED BY MIDWAY MANUFACTURING COMPANY",0
#ln8	.string	"FROM ACCLAIM ENTERTAINMENT INC.",0
#ln9	.string	"ALL RIGHTS RESERVED.",0

#ln10	.string	"'WRESTLEMANIA'",0
#ln11	.string	"COMPOSED/PERFORMED BY MICHAEL STOCK,",0
#ln12	.string	"PETER WATERMAN, JAMES HART & J.J. MAGUIRE",0
#ln13	.string	"COURTESY OF TITANSPORTS INC.  USED BY PERMISSION -",0
#ln14	.string	"ALL RIGHTS RESERVED",0
#ln15	.string	"'WRESTLEMANIA' BY WWF SUPERSTARS. (P) 1993  THE",0
#ln16	.string	"COPYRIGHT IN THIS SOUND RECORDING IS OWNED BY",0
#ln17	.string	"BMG EURODISC LIMITED AND IS USED BY PERMISSION.",0
#ln18	.string	"COMPOSED BY STOCK/WATERMAN/WWF AND PUBLISHED BY",0
#ln19	.string	"BMG MUSIC PUBLISHING LTD./ALL BOYS MUSIC LTD.",0
	.EVEN


#********************************************************
*
* Print general tips
*
 SUBRP	print_gen_tips

	movi	#gen_tip_mes,a2
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

	movi	#gen_tip_table,a1
	movi	60,a3
#sgt_loop
	move	*a1+,a4,L
	jrz	#done
	PUSHP	a1,a3
	calla	copy_rom_string
	movi	#gt_line_setup,a2
	calla	setup_message
	move	a3,@mess_cursy
	calla	print_string_C
	PULLP	a1,a3
	addk	15,a3
	jruc	#sgt_loop

#done
	calla	hscore_colcyc
;	calla	hscore_colcyc2

	RETP

#gt_line_setup
	JAM_STR	ogmd10_ascii,6,0,200,90,SGMD8YEL,print_string
	.even

#gen_tip_mes
	JAM_STR	osgemd_ascii,10,0,200,10,BLUE,print_string_C2
	.byte	"TONS O' TIPS",0,0
	.even

#gen_tip1
	.string	"PUT YOUR OPPONENT INTO A HEAD HOLD",0
	.even
#gen_tip1a
	.string	"USING TOWARD-TOWARD-POWERPUNCH.",0
	.even
#gen_tip2
	.string	"FLING YOUR OPPONENT TO THE ROPES",0
	.even
#gen_tip2a
	.string	"USING AWAY-AWAY-POWERPUNCH.",0
	.even
#gen_tip3
	.string	"WHEN IN CLOSE TO YOUR OPPONENT",0
	.even
#gen_tip3a
	.string	"USE AWAY-AWAY-PUNCH TO HIP TOSS HIM.",0
	.even
#gen_tip4
	.string	"WHEN AN OPPONENT IS RUNNING AT YOU",0
	.even
#gen_tip4a
	.string	"USE POWERPUNCH & AWAY TO FLING HIM.",0
	.even

#gen_tip_table
	.long	#gen_tip1
	.long	#gen_tip1a
	.long	blank
	.long	#gen_tip2
	.long	#gen_tip2a
	.long	blank
	.long	#gen_tip3
	.long	#gen_tip3a
	.long	blank
	.long	#gen_tip4
	.long	#gen_tip4a
	.long	0


#********************************************************
*
* Show General Gameplay tips
*
 SUBRP	show_gen_tips

	movi	hstd_mod,a0
	calla	SET_UP_PIXEL_WIPE
	JSRP	print_gen_tips
	SLEEPK	1
	JSRP	BLOW_0_TO_1
	calla	RESET_FROM_PIXEL_WIPE

	SLEEP	TSEC

	movi	10*TSEC,a10
	JSRP	wait_on_butn

	movi	FLASH_PID,a0
	calla	KIL1C

	movi	CYCPID,a0
	calla	KIL1C

	RETP

#*****************************************************************************
*
* Show high score tables
*

 SUBRP	show_hstd

	calla	table_cmos_check	;make sure hscore CMOS is okay

	movi	hstd_mod,a0
	CALLA	SET_UP_PIXEL_WIPE

	movi	1,a5

	JSRP	print_inter

	SLEEPK	1

	JSRP	BLOW_0_TO_1

	CALLA	RESET_FROM_PIXEL_WIPE

	SLEEP	TSEC/2
	MOVE	@starting_num,a9
	DEC	A9
	move	a9,@starting_num
	CMPI	INTER_TAB_ENTRIES-6,A9
	JRLT	SCROLL_TABLE_LOOP_2_I
	MOVI	INTER_TAB_ENTRIES-1,A9
	move	a9,@starting_num

SCROLL_TABLE_LOOP_2_I
	clr	a0
	move	a0,@not_blank
	MOVK	4,A11

SCROLL_TABLE_LOOP_I
	MOVI	36,A10
WAIT_ON_THOSE_BUTS_I
	SLEEP	1
	calla	get_all_buttons_cur2
	JRNZ	JUST_WAIT_I
	DSJS	A10,WAIT_ON_THOSE_BUTS_I
	PUSH	A11
	CALLA	DELETE_ANY_OFF_TOP
	PULL	A11
	sleep	1
	MOVE	@starting_num,a9
	cmpi	INTER_TAB_ENTRIES-1,a9
	JRGE	JUST_WAIT_I
	DEC	A11
	JRZ	DELAY_SCROLL_I
BACK_IN_AGAIN_I
	inc	a9
	move	a9,@starting_num
	PUSH	A11
	CALLA	draw_each_inter_table_entry
	CALLA	MOVE_ALL_OBJS_UP
	PULL	A11
	MOVI	34,A10
	jruc	WAIT_ON_THOSE_BUTS_I

DELAY_SCROLL_I
	MOVK	3,A11
	SLEEP	15H			;scroll last three off
	PUSH	A11
	CALLA	STOP_ALL_OBJS
	PULL	A11
	MOVI	85,A8
MORE_WAITING_I
	SLEEP	1			;delay on each three displayed
	calla	get_all_buttons_cur2
	JRNZ	JUST_WAIT_I
	DSJS	A8,MORE_WAITING_I
	move	@not_blank,a0
	jrnz	JUST_WAIT_I
	clr	a0
	JRUC	BACK_IN_AGAIN_I

JUST_WAIT_I

	CALLA	STOP_ALL_OBJS
	movi	5*TSEC,a10
	JSRP	wait_on_butn

	MOVI	FLASH_PID,A0
	CLR	A1
	NOT	A1
	CALLA	KILALL

*********************************************************************************
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
	JRLT	SCROLL_TABLE_LOOP_2
	MOVI	BEATEN_TAB_ENTRIES-1,A9
	move	a9,@starting_num

SCROLL_TABLE_LOOP_2
	clr	a0
	move	a0,@not_blank
	MOVK	4,A11

SCROLL_TABLE_LOOP
	MOVI	36,A10
WAIT_ON_THOSE_BUTS
	SLEEP	1
	calla	get_all_buttons_cur2
	JRNZ	JUST_WAIT
	DSJS	A10,WAIT_ON_THOSE_BUTS
	PUSH	A11
	CALLA	DELETE_ANY_OFF_TOP
	PULL	A11
	sleep	1
	MOVE	@starting_num,a9
	cmpi	BEATEN_TAB_ENTRIES-1,a9
	JRGE	JUST_WAIT
	DEC	A11
	JRZ	DELAY_SCROLL
BACK_IN_AGAIN
	inc	a9
	move	a9,@starting_num
	PUSH	A11
	CALLA	draw_each_beaten_table_entry
	CALLA	MOVE_ALL_OBJS_UP
	PULL	A11
	MOVI	34,A10
	jruc	WAIT_ON_THOSE_BUTS

DELAY_SCROLL
	MOVK	3,A11
	SLEEP	15H			;scroll last three off
	PUSH	A11
	CALLA	STOP_ALL_OBJS
	PULL	A11
	MOVI	85,A8
MORE_WAITING
	SLEEP	1			;delay on each three displayed
	calla	get_all_buttons_cur2
	JRNZ	JUST_WAIT
	DSJS	A8,MORE_WAITING
	move	@not_blank,a0
	jrnz	JUST_WAIT
	clr	a0
	JRUC	BACK_IN_AGAIN

JUST_WAIT

	CALLA	STOP_ALL_OBJS
	movi	5*TSEC,a10
	JSRP	wait_on_butn

	MOVI	FLASH_PID,A0
	CLR	A1
	NOT	A1
	CALLA	KILALL

***********************
	movi	hstd_mod,a0
	CALLA	SET_UP_PIXEL_WIPE

	JSRP	print_tag

	SLEEPK	1

	JSRP	BLOW_0_TO_1

	CALLA	RESET_FROM_PIXEL_WIPE

	SLEEP	TSEC/2
	movi	5*TSEC,a10
	JSRP	wait_on_butn

***********************
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

	.if	1

rule_str
	JAM_STR	osgmd8_ascii,6,0,200,225,SGMD8WHT,print_string_C2
	.string	"{WE MAKE THE GAMES THAT MAKE THE INDUSTRY}",0
	.even






 SUBRP	dan_test

	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT

	clr	a0
	move	a0,@HALT
	move	a0,@dtype		;2d mode
	move	a0,@IRQSKYE		;Sky color

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	SLEEPK	2

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L


;Turn on background module
	MOVI	#logo_mod,A0
	move	a0,@BAKMODS,L
	calla	BGND_UD1		;create objects for background


	movi	#gen_tip_mes,a2
	calla	print_message

	SLEEPK	1
	clr	a10
	movk	4,a11
	CREATE	FADE_PID,fade_up

	movk	1,a0
	move	a0,@DISPLAYON

	calla	display_unblank

;	SLEEPK	32
;	CREATE	WATER_PID,MOVE_BACK_OFF_SCREEN

;Turn some stuff on
	CREATE	BALL_PID,DISPATCH

	SLEEPK	32
	calla	hscore_colcyc

;Wait for 8 more seconds
#loop	movi	118*TSEC,a10
	JSRP	wait_on_butn
	jruc	#loop
;Timed out or hit a button


	movi	BALL_PID,a0
	calla	KIL1C
	movi	BALL_ID,a0
	calla	obj_del1c

	RETP


BALL_PID .equ	1			;Process ID
BALL_ID	 .equ	2			;IMG ID


 SUBRP	DISPATCH

	movi	32,a9			;100 balls

#lpx	CREATE	BALL_PID,ONE_BALL
	SLEEPK	5

	dsjs	a9,#lpx

	DIE

	.ref	PCNT

 SUBRP	ONE_BALL
;Turn on 1 ball at center of screen, random vels

	movi	80000h,a0
	calla	RNDRNG0			;# between 0 and a0
	subi	40000h,a0
	move	a0,a6			;XVEL

	movi	60000h,a0
	calla	RNDRNG0			;# between 0 and a0
	subi	30000h,a0
	move	a0,a7			;YVEL

	movi	[200,0],a0		;200 pixels over in x
	movi	[160,0],a1		;Y pos

	movi	BALLD05A,a2		;IMG to turn on
	move	@PCNT,a3
	andi	07fffh,a3		;ZPOS
	movi	DMAWNZ,a4		;IMG flags
	movi	BALL_ID,a5		;ID


	calla	BEGINOBJW		;Begin obj with world added in
;a8=obj pointer


#lp	SLEEPK	1

	move	*a8(OXVEL),a1,L
	move	*a8(OXPOS),a0
	cmpi	400,a0
	jrlo	#xok
	neg	a1
	move	a1,*a8(OXVEL),L
	SLEEPK	2
#xok
	move	*a8(OYVEL),a1,L
	move	*a8(OYPOS),a0
	cmpi	255,a0
	jrlo	#yok
	neg	a1
	move	a1,*a8(OYVEL),L
	SLEEPK	2
#yok
	jruc	#lp

#gen_tip_mes
	JAM_STR	osgemd_ascii,10,0,200,20,BLUE,print_string_C2
	.byte	"WRESTLEMANIA LITE!",0,0
	.even





MOVE_BACK_OFF_SCREEN

	MOVE	@WORLDTLX,A0,L
	SUBI	[2,0],A0
	MOVE	A0,@WORLDTLX,L

	MOVE	@WORLDTLY,A0,L
	ADDI	[2,0],A0
	MOVE	A0,@WORLDTLY,L

	CALLA	BGND_UD1

	SLOOP	1,MOVE_BACK_OFF_SCREEN












LOGO_CREATLOOP
	PUSH	a0,a1,a3,a4,a5,a6,a7
	calla	BEGINOBJ
	PULL	a0,a1,a3,a4,a5,a6,a7
	move	*a9+,a2,L
	jrnz	LOGO_CREATLOOP
	RETS

#logo_mod
	.long	SPORTBKBMOD
	.word	-400-(400*0),400*0
	.long	SPORTBKBMOD
	.word	-400-(400*1),400*1
	.long	SPORTBKBMOD
	.word	-400-(400*2),400*2
	.long	SPORTBKBMOD
	.word	-400-(400*3),400*3
	.long	SPORTBKBMOD
	.word	-400-(400*4),400*4
	.long	SPORTBKBMOD
	.word	-400-(400*5),400*5
	.LONG	0

LOGO_LIST
	.LONG	SPRTLG01
	.LONG	SPRTLG02
	.LONG	SPRTLG03
	.LONG	SPRTLG04
	.LONG	SPRTLG05
	.LONG	SPRTLG06
	.LONG	SPRTLG07
	.LONG	SPRTLG08
	.LONG	SPRTLG09
	.LONG	SPRTLG10
	.LONG	SPRTLG11
	.LONG	SPRTLG12
	.LONG	SPRTLG13
	.LONG	SPRTLG14
	.LONG	SPRTLG15
	.LONG	SPRTLG16
	.LONG	SPRTLG17
	.LONG	0


;MOVE_BACK_OFF_SCREEN
;
;	MOVE	@WORLDTLX,A0,L
;	SUBI	[2,0],A0
;	MOVE	A0,@WORLDTLX,L
;
;	MOVE	@WORLDTLY,A0,L
;	ADDI	[2,0],A0
;	MOVE	A0,@WORLDTLY,L
;
;	CALLA	BGND_UD1
;
;	SLOOP	1,MOVE_BACK_OFF_SCREEN
;

; SUBRP	show_big_wwf_title
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
;	movi	#big_wwf_mod,a0
;	move	a0,@BAKMODS,L
;	calla	BGND_UD1		;create objects for background
;
;	SLEEPK	2
;
;	calla	display_unblank
;
;	SLEEP	TSEC/2
;	movi	10*TSEC,a10
;	JSRP	wait_on_butn
;
;	retp
;
;#big_wwf_mod
;	.long	bigwwfBMOD
;	.word	0,0
;	.long	0

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


	MOVI	[102,7],A8
	MOVI	WHERE_WRESTLMANIA_SPARKLES,A10
	MOVK	4,A9
	CREATE	FLASH_PID,SPRINKLE_GLINTS

	CREATE	ATTRACT_ANIMPID,RANDOM_SPARKLE

	SLEEP	TSEC/2
	movi	10*TSEC,a10
	JSRP	wait_on_butn

	movi	CYCPID,a0
	calla	KIL1C
	MOVI	FLASH_PID,A0
	calla	KIL1C
	MOVI	ATTRACT_ANIMPID,A0
	calla	KIL1C

	RETP


 SUBRP	show_title2

	CREATE	CYCPID,#cycle_lava

	SLEEP	TSEC/2
	movi	8*TSEC,a10
	JSRP	wait_on_butn

	movi	CYCPID,a0
	calla	KIL1C

;fade down
	clr	a10
	movk	16,a11
	CREATE	FADE_PID,fade_down

	SLEEP	TSEC

	calla	display_blank

	RETP

#title_mod
	.long	NTITLESCBMOD
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

	.endif


;Keep this code around
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

#*****************************************************************************
*
* Show wrestler bios
*
	.bss	next_bio,16

 SUBRP	show_bios

	movi	#bio_mod,a0
 SUBRP	show_bios_tips
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


	MOVI	018h,a3
	MOVI	00bh,a4
	MOVI	#bio_logos,a5
	clr	a7

	CALLR	MAKE_UP_LOGO

	;draw the mugshot
	PULL	a10
	PUSH	a10
	X32	a10
	addi	wrestler_mugs2,a10
	move	*a10,a9,L
	movi	[017ah,0],a0
	movi	[0Afh,0],a1

	move	*a9+,a2,L
	clr	a3
	movi	DMAWNZ|M_FLIPH,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7

#mugcreatloop
	PUSH	a0,a1,a3,a4,a5,a6,a7
	calla	BEGINOBJ
	PULL	a0,a1,a3,a4,a5,a6,a7
	move	*a9+,a2,L
	jrnz	#mugcreatloop


	.ref	wrestler_attributes,attbars
	;attributes
	movi	[0ffh,0],a0
	movi	[0aeh,0],a1
;	movi	ATTPL_G,a2
;	movi	10,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7
;	PUSH	a0,a1,a4,a5,a6,a7
;	calla	BEGINOBJ
;	PULL	a0,a1,a4,a5,a6,a7
;	subi	2,a1
	movi	ATT_TXT,a2
	movk	11,a3
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

	move	@bios_type,a14
	jrnz	show_wres_tips

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

;	movi	#bio_setup1,a2
;	calla	setup_message
;	movi	#bio_center,a14
;	sub	a11,a14
;	move	a14,@mess_cursx
;	movi	#bio_message1,a4
;	calla	print_string2
;
;	movi	#bio_setup2,a2
;	calla	setup_message
;	movi	#bio_center,a14
;	sub	a11,a14
;	move	a14,@mess_cursx
;	movi	#bio_message2,a4
;	calla	print_string2
;

	movi	#bio_setup1,a2
	calla	setup_message

	;from text
	movi	#bio_y,a14
	move	a14,@mess_cursy
	movi	#bio_center,a14
	move	a14,@mess_cursx

	move	*a10+,a4,L
	calla	print_string2

	;weight

	movi	#bio_y+50,a14
	move	a14,@mess_cursy
	movi	#bio_center,a14
	addi	16,a14
	move	a14,@mess_cursx

	move	*a10+,a0,W
	movi	999,a1
	calla	dec_to_asc
	calla	copy_string
	calla	print_string

	movi	wsf10_ascii,a0
	move	a0,@message_ascii,L
	movi	#pounds,a4
	movi	#bio_y+54,a14
	move	a14,@mess_cursy
	move	@mess_cursx2,a0
	move	a0,@mess_cursx
	calla	print_string2

	;height
	movi	#bio_y+25,a14
	move	a14,@mess_cursy
	movi	#bio_center,a14
	addi	8,a14
	move	a14,@mess_cursx

	movi	wsf14_ascii,a0
	move	a0,@message_ascii,L
	move	*a10+,a0,W
	movi	999,a1
	calla	dec_to_asc
	calla	copy_string
	calla	print_string

	movi	wsf10_ascii,a0
	move	a0,@message_ascii,L
	movi	#feet,a4
	move	@mess_cursx2,a0
	move	a0,@mess_cursx
	movi	#bio_y+29,a14
	move	a14,@mess_cursy
	calla	print_string2

	movi	wsf14_ascii,a0
	move	a0,@message_ascii,L
	move	*a10+,a0,W
	movi	999,a1
	calla	dec_to_asc
	calla	copy_string
	movi	#bio_y+25,a14
	move	a14,@mess_cursy
	move	@mess_cursx2,a0
	move	a0,@mess_cursx
	calla	print_string

	movi	wsf10_ascii,a0
	move	a0,@message_ascii,L
	movi	#inches,a4
	movi	#bio_y+29,a14
	move	a14,@mess_cursy
	move	@mess_cursx2,a0
	move	a0,@mess_cursx
	calla	print_string2


	;quote
	movi	#bio_y+96+4,a14
	move	a14,@mess_cursy
	movi	#bio_center,a14
	addk	15,a14
	move	a14,@mess_cursx
	movk	14,a14
	move	a14,@mess_line_spacing
	move	*a10+,a4,L
	calla	print_string_C2

	;music
	PULL	a10
no_attr

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

wt_line1_setup
	JAM_STR	ogmd10_ascii,6,0,10,90,SGMD8YEL,print_string
	.even
wt_title_setup
	JAM_STR	ogmd10_ascii,6,0,135,95,SGMD8RED,print_string_C2
	.string	"SPECIAL MOVES"
	.byte	0,0
	.even

blank
	.byte	0
	.even

bret_tip1
	.string	"CHARGE POWERPUNCH 2 SEC.",0
	.even
bret_tip1a
	.string	"TO DO A DDT.",0
	.even
bret_tip2
	.string	"DOWN-DOWN-PUNCH TO DO",0
	.even
bret_tip2a
	.string	"A SUPER UPPERCUT.",0
	.even
bret_tip3
	.string	"CHARGE POWERKICK 2 SEC",0
	.even
bret_tip3a
	.string	"TO DO A FLYING KICK.",0
	.even

bret_tips
	.long	bret_tip1
	.long	bret_tip1a
	.long	blank
	.long	bret_tip2
	.long	bret_tip2a
	.long	blank
	.long	bret_tip3
	.long	bret_tip3a
	.long	0


razor_tip1
	.string	"CHARGE POWERKICK 2 SEC.",0
	.even
razor_tip1a
	.string	"TO DO A FLYING KICK.",0
	.even
razor_tip2
	.string	"1/4 CIRCLE D,DT,T - PUNCH",0
	.even
razor_tip2a
	.string	"DOES DOWN SLASHES.",0
	.even
razor_tip3
	.string	"CHARGE PUNCH 2 SECONDS",0
	.even
razor_tip3a
	.string	"TO DO SLASHES.",0
	.even

razor_tips
	.long	razor_tip1
	.long	razor_tip1a
	.long	blank
	.long	razor_tip2
	.long	razor_tip2a
	.long	blank
	.long	razor_tip3
	.long	razor_tip3a
	.long	0

taker_tip1
	.string	"CHARGE PUNCH 2 SECONDS",0
	.even
taker_tip1a
	.string	"TO DO A NECKBREAKER.",0
	.even
taker_tip2
	.string	"TOWARD-TOWARD-POWERKICK",0
	.even
taker_tip2a
	.string	"DOES A TOMBSTONE SMASH.",0
	.even
taker_tip3
	.string	"1/4 CIRCLE D,DT,T - PUNCH",0
	.even
taker_tip3a
	.string	"DOES A SLIDING CHOKE HOLD.",0
	.even

taker_tips
	.long	taker_tip1
	.long	taker_tip1a
	.long	blank
	.long	taker_tip2
	.long	taker_tip2a
	.long	blank
	.long	taker_tip3
	.long	taker_tip3a
	.long	0


yoko_tip1
	.string	"CHARGE PUNCH 2 SECONDS",0
	.even
yoko_tip1a
	.string	"TO DO A SALT THROW.",0
	.even
yoko_tip2
	.string	"TOWARD-TOWARD-PUNCH",0
	.even
yoko_tip2a
	.string	"DOES A GUT PUSH.",0
	.even
yoko_tip3
	.string	"TOWARD-TOWARD-POWERKICK",0
	.even
yoko_tip3a
	.string	"DOES A SCISSORS.",0
	.even

yoko_tips
	.long	yoko_tip1
	.long	yoko_tip1a
	.long	blank
	.long	yoko_tip2
	.long	yoko_tip2a
	.long	blank
	.long	yoko_tip3
	.long	yoko_tip3a
	.long	0


shawn_tip1
	.string	"CHARGE POWERKICK 2 SEC.",0
	.even
shawn_tip1a
	.string	"TO DO A FLYING KICK",0
	.even
shawn_tip2
	.string	"TOWARD-TOWARD-POWERKICK",0
	.even
shawn_tip2a
	.string	"DOES A FRANKENSTEINER.",0
	.even
shawn_tip3
	.string	"TOWARD-TOWARD-KICK DOES",0
	.even
shawn_tip3a
	.string	"A SLIDING KICKTOSS.",0
	.even

shawn_tips
	.long	shawn_tip1
	.long	shawn_tip1a
	.long	blank
	.long	shawn_tip2
	.long	shawn_tip2a
	.long	blank
	.long	shawn_tip3
	.long	shawn_tip3a
	.long	0


bam_tip1
	.string	"AWAY-AWAY-POWERKICK",0
	.even
bam_tip1a
	.string	"DOES A JUMP KICK.",0
	.even
bam_tip2
	.string	"CHARGE PUNCH 2 SECONDS",0
	.even
bam_tip2a
	.string	"TO DO A FIREPUNCH.",0
	.even
bam_tip3
	.string	"CHARGE POWERPUNCH 2 SEC",0
	.even
bam_tip3a
	.string	"TO DO A NECKBREAKER.",0
	.even

bam_tips
	.long	bam_tip1
	.long	bam_tip1a
	.long	blank
	.long	bam_tip2
	.long	bam_tip2a
	.long	blank
	.long	bam_tip3
	.long	bam_tip3a
	.long	0


doink_tip1
	.string	"CHARGE PUNCH 2 SECONDS",0
	.even
doink_tip1a
	.string	"TO DO A JOY BUZZER.",0
	.even
doink_tip2
	.string	"TOWARD-TOWARD-POWERKICK",0
	.even
doink_tip2a
	.string	"DOES A HAPPY HAMMER.",0
	.even
doink_tip3
	.string	"SEVEN RAPID PUNCHES DOES",0
	.even
doink_tip3a
	.string	"A BOXING PUNCH.",0

doink_tips
	.long	doink_tip1
	.long	doink_tip1a
	.long	blank
	.long	doink_tip2
	.long	doink_tip2a
	.long	blank
	.long	doink_tip3
	.long	doink_tip3a
	.long	0


lex_tip1
	.string	"CHARGE PUNCH 2 SECONDS",0
	.even
lex_tip1a
	.string	"TO DO A CLOBBER.",0
	.even
lex_tip2
	.string	"TOWARD-TOWARD-PUNCH",0
	.even
lex_tip2a
	.string	"DOES A SLIDING ELBOW.",0
	.even
lex_tip3
	.string	"TOWARD-TOWARD-POWERKICK",0
	.even
lex_tip3a
	.string	"DOES A HAMMER BLOW.",0
	.even

lex_tips
	.long	lex_tip1
	.long	lex_tip1a
	.long	blank
	.long	lex_tip2
	.long	lex_tip2a
	.long	blank
	.long	lex_tip3
	.long	lex_tip3a
	.long	0

wrestler_tips
	.long	bret_tips
	.long	razor_tips
	.long	taker_tips
	.long	yoko_tips
	.long	shawn_tips
	.long	bam_tips
	.long	doink_tips
	.long	lex_tips

 SUBRP	show_wres_tips

	movi	wt_title_setup,a2
	calla	print_message

	PULL	a10		; This is the wrestler number (0-7)

	move	a10,a1
	X32	a1
	addi	wrestler_tips,a1
	movi	120,a3
	move	*a1,a1,L
swt_loop
	move	*a1+,a4,L
	jrz	no_attr
	PUSHP	a1,a3
	calla	copy_rom_string
	movi	wt_line1_setup,a2
	calla	setup_message
	move	a3,@mess_cursy
	calla	print_string
	PULLP	a1,a3
	addk	15,a3
	jruc	swt_loop


 SUBR	MAKE_UP_LOGO
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


#bio_center	.equ	100
#bio_halfwidth	.equ	87

#bio_y		.equ	106

;#bio_setup1
;	JAM_STR	osgmd8_ascii,5,0,0,#bio_y,SGMD8YEL,print_string2
;#bio_message1
;	.byte	"FROM:",1,"WEIGHT:",1,"HEIGHT:",1,"FINISHING",0
;	.even
;
;#bio_setup2
;	JAM_STR	osgmd8_ascii,5,0,0,#bio_y+71,SGMD8YEL,print_string2
;#bio_message2
;	.byte	"MOVE:",0
;	.even

;FIX!!
	.even
#bio_setup1
	JAM_STR	wsf14_ascii,6,0,0,#bio_y+75,WSF_Y_P,print_string2
	.even
;#bio_setup2
;	JAM_STR	wsf10_ascii,6,10,0,#bio_y+75,WSF_Y_P,print_string2
;	.even

#pounds
	.byte	" LBS.",0
	.even

#feet
	.byte	" FT. ",0
	.even

#inches
	.byte	" IN.",0
	.even

#bio_data
	.long	#bhart_data,#razor_data,#taker_data,#yoko_data,#shawn_data
	.long	#bambam_data,#doink_data,#luger_data

#bhart_data
	.word	79			;halfwidth
	.long	#bhart_fromstr		;from
	.word	234,6,1			;pounds, feet, inches
	.long	#bhart_quote		;quote text

#razor_data
	.word	77			;halfwidth
	.long	#razor_fromstr		;from
	.word	262,6,7			;pounds, feet, inches
	.long	#razor_quote		;quote text

#taker_data
	.word	78			;halfwidth
	.long	#taker_fromstr		;from
	.word	322,6,11		;pounds, feet, inches
	.long	#taker_quote		;quote text

#yoko_data
	.word	78			;halfwidth
	.long	#yoko_fromstr		;from
	.word	568,6,4			;pounds, feet, inches
	.long	#yoko_quote		;quote text

#shawn_data
	.word	78			;halfwidth
	.long	#shawn_fromstr		;from
	.word	235,6,1			;pounds, feet, inches
	.long	#shawn_quote		;quote text

#bambam_data
	.word	78			;halfwidth
	.long	#bambam_fromstr		;from
	.word	400,6,4			;pounds, feet, inches
	.long	#bambam_quote		;quote text

#doink_data
	.word	78			;halfwidth
	.long	#doink_fromstr		;from
	.word	243,6,0			;pounds, feet, inches
	.long	#doink_quote		;quote text

#luger_data
	.word	81			;halfwidth
	.long	#luger_fromstr		;from
	.word	270,6,4			;pounds, feet, inches
	.long	#luger_quote		;quote text

#bhart_fromstr
;	.byte	"CALGARY, ALBERTA",0		;Too long
	.byte	"CALGARY",0
	.even
#razor_fromstr
	.byte	"MIAMI, FLORIDA",0
	.even
#taker_fromstr
	.byte	"DEATH VALLEY",0
	.even
#yoko_fromstr
	.byte	"TOKYO, JAPAN",0
	.even
#shawn_fromstr
	.byte	"SAN ANTONIO, TX",0
	.even
#bambam_fromstr
	.byte	"ASBURY PARK, NJ",0
	.even
#doink_fromstr
	.byte	"THE CIRCUS",0
	.even
#luger_fromstr
	.byte	"ATLANTA, GA",0
	.even




#bhart_quote
	.byte	"{I AM THE EXCELLENCE",1,"OF EXECUTION.}",0
	.even
#razor_quote
	.byte	"{TAKE A LOOK AT",1,"THE BAD GUY.}",0
	.even
#taker_quote
	.byte	"{REST IN PEACE}",0
	.even
#yoko_quote
	.byte	"{BANZAI !!!}",0
	.even
#shawn_quote
	.byte	"{I'M THE GREATEST THING",1,"GOING ON GOD'S GREEN EARTH.}",0
	.even
#bambam_quote
	.byte	"{I'M THE BEAST",1,"FROM THE EAST!",0
	.even
#doink_quote
	.byte	"{LIFE'S A JOKE!",0
#luger_quote
	.byte	"{LEX LUGER IS THE",1,"ALL AMERICAN HERO}",0
	.even

#bio_mod
	.long	biopageBMOD			;wrestler bios
;	.long	slateBMOD			;wrestler bios
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
#under_logo		.long	UND3,0
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

	;set CMOS volume!
	movi	ADJVOLUME,a0
	calla	GET_ADJ
	BADCHK	a0,0,255,28		;reg, lo, hi, val if bad
	calla	set_volume

	movi	>b6,a0
	calla	triple_sound

	move	@TEMP,a0
	move	a0,@SOUNDSUP		;turn all sounds off
	jruc	#exit

#nobutn
	dsj	a10,#lp

#exit
	RETP


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


#*****************************************************************************
* flips the active page

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
	clr	a0
	move	a0,@IRQSKYE

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

	clr	a10
	movk	8,a11
	CREATE	FADE_PID,fade_up

	movk	1,a0
	move	a0,@DISPLAYON

	calla	display_unblank

	MOVE	@AMODE_LOOPS,A0
	CMPI	2,A0
	JRGE	NO_BANG

	ADJUST	ADJMUSIC
	JRNZ	NO_BANG

	MOVI	1005,A3
	CALLA	SNDSND
NO_BANG

	SLEEP	42h

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

	SLEEP	60

	MOVI	254-60,A10
loop_it
	SLEEPK	1
	calla	get_all_buttons_cur2
	JRNZ	nobutn1
	dsj	a10,loop_it

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

	SLEEPK	30

	movi	100,a10
	JSRP	wait_on_butn
nobutn1
	CLR	A3
	CALLA	SNDSND
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

 SUBR	GENERIC_DISPLAY
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

****************************************************************
* THIS SHOULD BE CALLED IN PLACE OF ANY JRxx $
* IN CASE OF ERROR. IF WE ARE IN DEBUG MODE
* IT WILL HANG, IF NOT, THE ERROR WILL BE LOGGED
* AND IT WILL RETURN.
* A1 = RETURN ADDRESS OF CALLING ROUTINE
* A2 = ERROR CODE

ERRORLOG
	MMTM	SP,A2,A3,A4,A5,A6,A7
;	SLL	16,A2
;ERRLOGG				;A8 IS IN A8
;
;	MOVE	A13,A7		;PROC. BLOCK IN A7
;	MOVE	*A7(PROCID),A6
;	SLL	16,A6
;	MOVE	*A8(OID),A3
;	MOVX	A3,A6		;A6 = [PROCID:*A8(OID)]
;
;;	MOVE	@CIRCUIT,A5
;;	SLL	16,A5
;;	MOVE	@WAVE,A3
;	MOVX	A3,A5		;A5 = [CIRCUIT#:WAVE#,)]
;
;	MOVI	AUD1STRT,A4	;PLAY #
;	callr	GETAUD4
;
;	SLL	16,A4
;	MOVE	*A0(OID),A3	;A4 = [STRT#:*A0(OID)]
;	MOVX	A3,A4
;
;	MOVE	@GAMSTATE,A3	;A2 = [PSTATUS:GAMSTATE]
;	MOVX	A3,A2
;
;	MOVE	@PSTATUS,A3	;A2 = [ERROR CODE:PSTATUS]
;	MOVX	A3,A2
;;	MOVE	*SP(0C0H),A3,L	;A3=GET THE RETURN ADDRESS
;	MOVE	*SP(0E0H),A1,L	;A1=CALLING ADDRESS
;;	CALLA	ADD_DUMP

	MMFM	SP,A2,A3,A4,A5,A6,A7
	RETS

******************************************************************************

NUM_HINTS	.EQU	5

	.bss	last_hint,16

 SUBR	DO_HINTS
	movk	18,a8
	movk	6,a9
	JSRP	CLOSE_SCREEN_LINE
	calla	SPECIAL_WIPEOUT

	clr	a0
	move	a0,@HALT
	move	a0,@dtype		;2d mode
	move	a0,@IRQSKYE

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	movi	hstd_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1		;create objects for background

	CLR	A1
	MOVE	A1,@TOP_LEFT,L
	MOVE	A1,@BOT_RIGHT,L

	MOVI	100,A0
	CALLA	RNDPER

	;temp!
	JRUC	WE_DO_THE_DESIGNER_HINTS
;	JRLO	WE_DO_THE_DESIGNER_HINTS

;	MOVK	NUM_HINTS,A0
;	CALLA	RNDRNG0
;
;	SLL	6,A0
;	ADDI	GENERAL_HINT,A0
;	MOVE	*A0+,A4,L
;	MOVE	*A0+,A5,L
;	PUSH	A5,A4
;
;	CALLA	PUT_UP_BAR
;
;	MOVI	GENTIP,A2
;	CALLA	PUT_UP_TIP_NAME
;
;	JRUC	GEN_TIP_BACK_IN_HERE

WE_DO_THE_DESIGNER_HINTS

	move	@last_hint,a0
	jrn	#reset_chint
	inc	a0
	cmpi	NUM_HINTS,a0
	jrge	#reset_chint
	jruc	#shint

#reset_chint
	clr	a0
#shint	move	a0,@last_hint

	PUSHP	A0
	SLL	7,A0
	ADDI	WHICH_HINT,A0
	MOVE	*A0+,A4,L
	MOVE	*A0+,A5,L
	PUSH	A5,A4
	PUSH	A0

	CALLA	PUT_UP_BAR

	PULL	A0
	MOVE	*A0+,A2,L
	PUSH	A0

	CALLA	PUT_UP_TIP_NAME

	PULLP	A2
	SLL	5,A2
	ADDI	WHICH_22_NUM,A2
	MOVE	*A2,A2,L

	MOVE	*A8(OSIZEX),A0
	SRL	1,A0
	ADDI	200,A0
	SLL	16,A0

	MOVI	[9,0],A1
	movi	1800H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	CLR	A6
	CLR	A7
	movi	WGFS_W_P,b0
	calla	BEGINOBJP

	MOVI	[400,0],A0
	MOVI	[254,0],A1
	MOVI	MUGBAK,A2
	movi	17FFH,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	CLR	A6
	CLR	A7
	calla	BEGINOBJ

	MOVI	[400,0],A0
	MOVI	[254,0],A1
	MOVI	MUGFRNT,A2
	movi	1801H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	CLR	A6
	CLR	A7
	calla	BEGINOBJ

	PULL	A0
	MOVE	*A0+,A2,L

	MOVI	[400,0],A0
	MOVI	[254,0],A1
	movi	1800H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	CLR	A6
	CLR	A7
	calla	BEGINOBJ

GEN_TIP_BACK_IN_HERE

	MOVI	#SETUP_LINE_1,A2
	CALLA	setup_message
	CALLA	hscore_colcyc2
	PULL	A4
	CALLA	print_string_C2
	PULL	A4
	PUSHP	A4

;	movk	18,a8
;	movk	6,a9
;	JSRP	OPEN_SCREEN_LINE

	MOVI	#SETUP_LINE,A2
	CALLA	setup_message

	MOVI	15,A0
	MOVE	A0,@mess_line_spacing

	PULLP	A4
	MOVE	A4,A10
	MOVE	*A10+,A9,L
NEXT_HINT
	MOVE	*A10+,A4,L
	CALLA	print_string_C2
	move	@mess_cursy,A0
	ADDI	15,A0
	move	a0,@mess_cursy

	DSJS	A9,NEXT_HINT

	movk	18,a8
	movk	6,a9
	JSRP	OPEN_SCREEN_LINE

	SLEEP	80
	movi	15*TSEC,a10
	JSRP	wait_on_butn

	movi	FLASH_PID,a0
	clr	a1
	not	a1
	CALLA	KILALL

	RETP		;?????? GOOD IDEA?

PUT_UP_TIP_NAME
	MOVI	[190,0],A0
	MOVI	[21,0],A1
	movi	1800H,a3
	movi	DMAWNZ,a4
	movi	CLSNEUT,a5
	CLR	A6
	CLR	A7
	movi	WGFS_W_P,b0
;	calla	BEGINOBJ
	calla	BEGINOBJP

	RETS

PUT_UP_BAR
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
	RETS

#title_mod
	.long	slateBMOD
;	.long	LAVAPGBMOD
	.word	0,0
	.long	0

WHICH_22_NUM
	.LONG	WGSF22_1
	.LONG	WGSF22_2
	.LONG	WGSF22_3
	.LONG	WGSF22_4
	.LONG	WGSF22_5
	.LONG	WGSF22_6
	.LONG	WGSF22_7
	.LONG	WGSF22_8
	.LONG	WGSF22_9
	.LONG	WGSF22_0

WHICH_HINT
	.LONG	#HNTT_2,#HNT_2,JMSTIP,JASMUG
	.LONG	#HNTT_4,#HNT_4,MIKTIP,MIKMUG	 
	.LONG	#HNTT_3,#HNT_3,MJTTIP,MRKMUG
	.LONG	#HNTT_7,#HNT_7,EUGTIP,EUGMUG
	.LONG	#HNTT_5,#HNT_5,SHNTIP,SHNMUG
	.LONG	#HNTT_8,#HNT_8,JAKTIP,JAKMUG
	.LONG	#HNTT_1,#HNT_1,SALTIP,SALMUG
	.LONG	#HNTT_6,#HNT_6,TONTIP,TONMUG
	.LONG	#HNTT_9,#HNT_9,JOSTIP,JSHMUG
	.LONG	#HNTT_9,#HNT_9,JOSTIP,JSHMUG

;GENERAL_HINT
;	.LONG	#HNTT_10,#HNT_10
;	.LONG	#HNTT_10,#HNT_10
;	.LONG	#HNTT_10,#HNT_10
;	.LONG	#HNTT_10,#HNT_10
;	.LONG	#HNTT_10,#HNT_10
;	.LONG	#HNTT_10,#HNT_10


#SETUP_LINE_1
	JAM_STR	osgemd_ascii,10,0,200,50+12,RUBYPAL,print_string_C2

#SETUP_LINE
	JAM_STR	wsf10_ascii,10,1,200,90+18,WSF_Y_P,print_string_C2

#HNTT_1	.byte	"OUT OF RING",0,0
	.even
#HNT_1	.long	4,#HNT_1A,#HNT_1B,#HNT_1C,#HNT_1D
#HNT_1A	.byte	"DON'T STAY OUT OF THE RING FOR",0,0
#HNT_1B	.byte	"LONG.  YOU SUFFER DAMAGE UNTIL",0,0
#HNT_1C	.byte	"YOU RE-ENTER THE RING OR YOUR",0,0
#HNT_1D	.byte	"OPPONENT JOINS YOU OUTSIDE.",0,0
	.even


#HNTT_2	.byte	"IN-AIR PICK OFF",0,0
	.even
#HNT_2	.long	4,#HNT_2A,#HNT_2B,#HNT_2C,#HNT_2D
#HNT_2A	.byte	"WHEN YOUR OPPONENT IS RUNNING",0,0
#HNT_2B	.byte	"OR LEAPING AT YOU, AWAY AWAY",0,0
#HNT_2C	.byte	"PUNCH CAN BE USED TO PICK HIM",0,0
#HNT_2D	.byte	"OFF AND DELIVER A BODY SLAM!",0,0
	.even


#HNTT_3	.byte	"TURNBUCKLE LEAPS",0,0
	.even
#HNT_3	.long	6,#HNT_3A,#HNT_3B,#HNT_3C,#HNT_3D,#HNT_3E,#HNT_3F
#HNT_3A	.byte	"CLIMB THE TURNBUCKLE AND LEAP AT",0,0
#HNT_3B	.byte	"YOUR OPPONENT, USING THE JOYSTICK",0,0
#HNT_3C	.byte	"TO GUIDE YOUR FLIGHT.  THESE ATTACKS",0,0
#HNT_3D	.byte	"CANNOT BE BLOCKED.  HOWEVER, THEY",0,0
#HNT_3E	.byte	"CAN BE PICKED OFF WITH A WELL TIMED",0,0
#HNT_3F	.byte	"KICK.",0,0
	.even


#HNTT_4	.byte	"COMBO MODE",0,0
	.even
#HNT_4	.long	6,#HNT_4A,#HNT_4B,#HNT_4C,#HNT_4D,#HNT_4E,#HNT_4F
#HNT_4A	.byte	"PERFORMING A VARIETY OF MOVES",0,0
#HNT_4B	.byte	"ACTIVATES 'COMBO MODE'.  THIS ALLOWS",0,0
#HNT_4C	.byte	"YOU TO LAUNCH SPECIAL DEVASTATING",0,0
#HNT_4D	.byte	"COMBO MOVES FROM THE HEADHOLD.",0,0
#HNT_4E	.byte	"MOST COMBOS START WITH TOWARD",0,0
#HNT_4F	.byte	"TOWARD AND A BUTTON PRESS.",0,0
	.even


#HNTT_5	.byte	"REVERSALS",0,0
	.even
#HNT_5	.long	5,#HNT_5A,#HNT_5B,#HNT_5C,#HNT_5D,#HNT_5E
#HNT_5A	.byte	"MANY HEADHOLD MOVES, SUCH AS THE",0,0
#HNT_5B	.byte	"PILEDRIVER, CAN BE DONE BY EITHER",0,0
#HNT_5C	.byte	"WRESTLER.  WHOEVER DOES THE CORRECT",0,0
#HNT_5D	.byte	"STICK AND BUTTON COMBINATION FIRST",0,0
#HNT_5E	.byte	"WILL DO THE MOVE.",0,0
	.even


#HNTT_6	.byte	"HIGH RISK MANEUVERS",0,0
	.even
#HNT_6	.long	3,#HNT_6A,#HNT_6B,#HNT_6C
#HNT_6A	.byte	"BOUNCE OFF THE ROPES JUST BEFORE",0,0
#HNT_6B	.byte	"PERFORMING MANY JUMPING ATTACKS",0,0
#HNT_6C	.byte	"FOR AN EXTRA DAMAGE BONUS!",0,0
	.even


#HNTT_7	.byte	"SECOND WIND",0,0
	.even
#HNT_7	.long	6,#HNT_7A,#HNT_7B,#HNT_7C,#HNT_7D,#HNT_7E,#HNT_7F
	.long	#HNT_7G,#HNT_7H
#HNT_7A	.byte	"WHEN YOU'RE ABOUT TO BE PINNED",0,0
#HNT_7B	.byte	"FOR THE SECOND TIME, YOU CAN",0,0
#HNT_7C	.byte	"GET YOUR SECOND WIND AND FIGHT",0,0
#HNT_7D	.byte	"ON, BUT ONLY IF YOUR COMBO METER",0,0
#HNT_7E	.byte	"IS LIT.  QUICKLY HIT THE BUTTONS",0,0
#HNT_7F	.byte	"ONCE YOUR HEALTH METER RUNS OUT.",0,0
#HNT_7G	.byte	"NOTE THAT THIS DOES NOT WORK IF",0,0
#HNT_7H	.byte	"IF YOU DIE OUTSIDE THE RING.",0,0
	.even


#HNTT_8	.byte	"HEAD HOLDS",0,0
	.even
#HNT_8	.long	6,#HNT_8A,#HNT_8B,#HNT_8C,#HNT_8D,#HNT_8E,#HNT_8F
#HNT_8A	.byte	"RAPIDLY PRESSING THE BUTTONS FROM",0,0
#HNT_8B	.byte	"A HEADHOLD WILL EVENTUALLY CAUSE",0,0
#HNT_8C	.byte	"A PILEDRIVER OR OTHER SPECIAL MOVE",0,0
#HNT_8D	.byte	"TO HAPPEN.  BUT THERE ARE MUCH",0,0
#HNT_8E	.byte	"FASTER WAYS TO DO THEM, SUCH AS",0,0
#HNT_8F	.byte	"TOWARD TOWARD POWER PUNCH.",0,0
	.even



#HNTT_9	.byte	"EXCESSIVE BLOCKING",0,0
	.even
#HNT_9	.long	5,#HNT_9A,#HNT_9B,#HNT_9C,#HNT_9D,#HNT_9E
#HNT_9A	.byte	"IF YOUR OPPONENT IS CONSTANTLY",0,0
#HNT_9B	.byte	"BLOCKING,  TRY GETTING IN CLOSE",0,0
#HNT_9C	.byte	"TO PUT HIM IN A HEADHOLD.  THEY",0,0
#HNT_9D	.byte	"CAN'T BE BLOCKED.  HIP TOSSES",0,0
#HNT_9E	.byte	"ARE ALSO DIFFICULT TO BLOCK.",0,0
	.even


#*****************************************************************************
*
* successful octopus brings us to this page.  It's a top-level process, just
* like the normal attract mode loop

	.ref	_switch_addr,_switch2_addr

OCTOBTN	.macro	VAL,TIMEOUT
	movi	:VAL:,a8
	movi	:TIMEOUT:,a9
	JSRP	#wait_but
	jrc	#octo_init
	.endm

 SUBR	octopus_page

	;make sure we're in attract mode
	move	@GAMSTATE,a14
	cmpi	INAMODE,a14
	jane	SUCIDE

	calla	SPECIAL_WIPEOUT

	;let the sound board reset finish up.
	SLEEPK	8

	clr	a3
	calla	SNDSND

	;put up some wallpaper
	JSRP	GENERIC_DISPLAY

	;draw the text/pix

	calla	display_unblank

	movi	TSEC*10,a10

#octo_init

	;check overall timeout
	TEST	a10
	jrn	attract_mode

	;octopus
	OCTOBTN	>fffeffff,TSEC/3	;kick
	OCTOBTN	>ffffffdf,TSEC/3	;block
	OCTOBTN	>ffffffbf,TSEC/3	;pwr pnch
	OCTOBTN	>ffffffef,TSEC/3	;pnch
	OCTOBTN	>ffffffdf,TSEC/3	;block
	OCTOBTN	>fffdffff,TSEC/3	;pwr kick

	;success!
	movi	DIAGP,a14
	move	a14,*a13(PROCID)
	.ref	HID_P
	jauc	HID_P

	;begin a normal attract mode
	jruc	attract_mode

 SUBRP	#wait_but

	calla	#mk_a0
	cmp	a0,a8
	jreq	#gotit
	SLEEPK	1
	dec	a10
	dsj	a9,#wait_but
	setc
	RETP
#gotit	clrc
	RETP


 SUBRP	#mk_a0
	move	@_switch_addr,a0,L
	move	@_switch2_addr,a1,L
	move	*a0,a0
	move	*a1,a1
	rl	16,a1
	and	a1,a0
	rets

******************************************************************************

	.end
