**************************************************************
*
* Software:	Mike Lynch, Jason Skiles, Mark Turmell
* Initiated:	04/04/95
*
* Modified:
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"award.asm"
	.title	"wrestling game program"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"macros.h"
	.include	"mproc.equ"		;Mproc equates
	.include	"display.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"sys.equ"
	.include	"wwfsec.equ"
	.include	"game.equ"
	.include	"audit.equ"
	.include	"plyr.equ"
	.include	"anim.equ"
	.include	"sound.h"
	.include	"ring.equ"
	.include	"sound.equ"
	.include	"damage.equ"
	.include	"jjxm.h"

	.include	"imgtbl.glo"
	.include	"fontsimg.glo"
	.include	"bgndtbl.glo"
	.include	"miscimg.glo"


SHOW_ACCUM_ICONS	.set	0

BLOCK_ICONS		.equ	2	; 2 single rnd 5 for 2
DBL_BLOCK_ICONS		.equ	5
PERFECT_ICONS		.equ	2
DBL_PERFECT_ICONS	.equ	5
BIG_COMEBACK_ICONS	.equ	2
TWO_ROUND_SWEEP_ICONS	.equ	1
FIVE_WINS_ICONS		.equ	3
QUICK_VICTORY_ICONS	.equ	1

POWER_MOVE_ICONS	.equ	0
REVERSALS_ICONS		.equ	0
HIGH_RISK_MOVE_ICONS	.equ	0
COMBOS_STARTED_ICONS	.equ	0
COMBO_REVERSALS_ICONS	.equ	0
COMBO_BREAKER_ICONS	.equ	0
ULTRA_COMBOS_ICONS	.equ	0
FIRST_HIT_ICONS		.equ	0
DEFEAT_HUMAN_ICONS	.equ	0
GAME_COMPLETE_ICONS	.equ	0
SUPER_QWK_VICTORY_ICONS	.equ	0
VERY_QWK_VICTORY_ICONS	.equ	0

MAX_BONUS_BARS		.equ	(NUM_AWARDS*2)
BONUS_RECORD_SIZE	.equ	6
BONUS_BAR_YPOS		.equ	230
BONUS_BAR_VEL		.equ	20
BONUS_BAR_YSPACE	.equ	20
BONUS_BAR_END_XPOS	.equ	180
BONUS_LTEXT_START_XPOS	.equ	-((BONUS_BAR_END_XPOS+22)/2)
BONUS_RTEXT_START_XPOS	.equ	-BONUS_LTEXT_START_XPOS

BONUS_ICON1_START_XPOS	.equ	-22
BONUS_ICON2_START_XPOS	.equ	-37
BONUS_ICON3_START_XPOS	.equ	-52


;fer know
LIFE_MAX	.equ	163		;green pixels in life bar

BONUS_MSG_XPOS1		.equ	81
BONUS_MSG_XPOS2		.equ	321
BONUS_MSG_YPOS		.equ	198
BONUS_ICON_XPOS1	.equ	BONUS_MSG_XPOS1
BONUS_ICON_XPOS2	.equ	BONUS_MSG_XPOS2
BONUS_ICON_YPOS		.equ	BONUS_MSG_YPOS+22


PROG_BICON_XPOS	.equ	56
PROG_BICON_YPOS	.equ	93

	.if 0
DUFUS_BOX_YPOS	.equ	144
DUFUS_BOX_RXPOS	.equ	399-(119+40)
DUFUS_BOX_LXPOS	.equ	40
	.else
DUFUS_BOX_YPOS	.equ	144+23
DUFUS_BOX_RXPOS	.equ	399-(59+40)
DUFUS_BOX_LXPOS	.equ	40+59
	.endif


BOX_OUT_SOUND	.equ	0aah
ZIP_IN_SOUND	.equ	0b6h


POWERUP_CODE_ON	.set	1


PUNCH	.equ	1
BLOCK	.equ	2
SUPERP	.equ	4
KICK	.equ	8


UP	.equ	32
DOWN	.equ	64
LEFT	.equ	128
RIGHT	.equ	256


PU_START_Y	.equ	210
PU_BAR_YSPACE	.equ	-15

PU_LEND_X	.equ	125
PU_REND_X	.equ	400-PU_LEND_X
PU_LTEXT_XPOS	.equ	-(PU_LEND_X/2)
PU_RTEXT_XPOS	.equ	400+(PU_LEND_X/2)
PU_BAR_VELOCITY	.equ	25

LPUBAROID	.equ	TYPVELALWAYS+010h
RPUBAROID	.equ	TYPVELALWAYS+011h

MKDEBUG		.equ	0


PUPWAITSWITCH	.macro	SWITCHES,FAILADDR
lp?
	SLEEPK	1
	dec	a11
	jrz	:FAILADDR:
	move	a8,a0
	calla	get_but_val_down
	move	a0,a1
	move	a8,a0
	calla	get_stick_val_down
	sll	5,a0
	or	a1,a0
	jrz	lp?
	cmpi	:SWITCHES:,a0
	jrnz	lp?

	.endm


;performed by each player.  They are used at the end of a match to award
;icons to the player.  These are cleared before each match.
;
;The pxrnd_award arrays are used to keep track of awards on a per round basis.
;The pxmtch_award arrays are used to keep track of awards on a per match basis.
;The pxws_award arrays are used to keep track of awards on a per winstreak basis.
;
	BSSX	p1rnd_award,	8*NUM_AWARDS	;player 1 round awards
	BSSX	p2rnd_award,	8*NUM_AWARDS	;player 2 round awards
	BSSX	p1mtch_award,	8*NUM_AWARDS	;player 1 match awards
	BSSX	p2mtch_award,	8*NUM_AWARDS	;player 2 match awards
	BSSX	p1ws_award,	16*NUM_AWARDS	;player 1 winstreak awards
	BSSX	p2ws_award,	16*NUM_AWARDS	;player 2 winstreak awards
	BSSX	award_ok_to_die,32
	BSSX	pcomeback,	32*2		;Player big comeback status
	BSSX	dboxes_on,32
	BSSX	powerup_requests,32
	BSSX	powerup_die,32
	BSSX	show_options_die,16
	BSSX	do_show_options,16

	BSSX	blocking_off,16
	BSSX	ring_out_on,16
	BSSX	buddy_mode_on,16
	BSSX	move_names_on,16
	BSSX	drone_meters_on,16
	BSSX	instant_combos_on,16
	BSSX	hyper_speed_on,16
	BSSX	no_ring_on,16
	BSSX	mk3_tip_number,16
	.bss	mk_cycram,16*16
	
	.bss	pwsarm,		32*2		;Player big comeback status
	.bss	ptotal,		32*2		;Player total Icon counts
	.bss	bar_obj_ptr,	MAX_BONUS_BARS*BONUS_RECORD_SIZE*32*2
	.bss	bonus_bar_size,	32
	.bss	picon,		32*3*MAX_BONUS_BARS*2
	.bss	player_award_state,32
	BSSX	p1icon_total,	32
	BSSX	p2icon_total,	32
	.bss	icon_digit_adjust,32
	.bss	p1bicon,32*8
	.bss	p2bicon,32*8
	.bss	icon_string_width,32
	.bss	progress_icons,32*8
	.bss	p1dufus_obj,32*2
	.bss	p2dufus_obj,32*2
	.bss	p1dufus_msg_flags,32
	.bss	p2dufus_msg_flags,32
	BSSX	p1powerup_request,32
	BSSX	p2powerup_request,32
	BSSX	p1pins,16
	BSSX	p2pins,16

	.ref	match_time,ck_live_teammates
	.ref	PSTATUS,royal_rumble
	.ref	process_ptrs
	.ref	p1winstreak
	.ref	p2winstreak
	.ref	get_health
	.ref	p1oldwinstreak
	.ref	p2oldwinstreak
	.ref	FLASHME,FINAL_PTR
	.ref	triple_sound
	.ref	BEGINOBJ_TBL
	.ref	get_but_val_down
	.ref	get_stick_val_down
	.ref	get_all_buttons_cur
	.ref	END_MATCH_SPEECH
	.ref	fade_down
	.ref	pal_clean
	.ref	fade_up
	.ref	GET_AUD
	.ref	STORE_AUDIT
	.ref	is_8_on_1
	.ref	wrestler_count
	.ref	in_finish_move
	.ref	NUM_OPPS


#***************************************************************
* rst_awards - Used to zero out per round and/or per match award arrays
* Clears both players award arrays!!!
* a14 = pointer to awards array to clear
*
 SUBR	rst_awards
	PUSH	a0,a1
	movi	(NUM_AWARDS*2)-1,a0
	clr	a1
#rst_award_loop
	movb	a1,*a14
	addk	8,a14
	dsjs	a0,#rst_award_loop
	movi	pcomeback,a0
	move	a1,*a0+,L
	move	a1,*a0,L
	PULL	a0,a1
	rets


 SUBRP	accumulate_player_awards
	move	@royal_rumble,a14
	jrnz	#apa_done
	X32	a0
	addi	process_ptrs,a0
	move	*a0,a1,L
	jrz	#apa_done
	move	a5,a0
	addi	(BLOCKS_AWD*8),a0
	movb	*a0,a1
	jrz	#no_blocks
	clr	a1
	jruc	#do_accumulate
#no_blocks
	movk	BLOCK_ICONS,a1
#do_accumulate
	movb	a1,*a0
	movi	NUM_RND_AWARDS,a2	; number of awards
#acc_awards_loop
	movb	*a6,a3			; Get current value of match award
	movb	*a5,a4			; Get per round award
	add	a4,a3			; Add to per match award
	movb	a3,*a6			; Store back to per match award
	addk	8,a6			; Increment round awards pointer
	addk	8,a5			; Increment match awards pointer
	dsjs	a2,#acc_awards_loop	; Keep going until all are accumulated
#apa_done
	rets


#***************************************************************
* accumulate_awards - accumulates the per round awards into the
* per match awards.
*
 SUBR	accumulate_awards
	PUSH	a0,a1,a2,a3,a4,a5,a6	; Save reggies I'm gonna trash

	clr	a0
	movi	p1rnd_award,a5
	movi	p1mtch_award,a6
	callr	accumulate_player_awards

	movk	1,a0
	movi	p2rnd_award,a5
	movi	p2mtch_award,a6
	callr	accumulate_player_awards

	PULL	a0,a1,a2,a3,a4,a5,a6	; Restore reggies
	movi	p1rnd_award,a14		; Clear out per round awards
	callr	rst_awards
	rets
	
	
#***************************************************************
* rst_winstreak_awards - Used to zero out per winstreak award arrays
* a14 = pointer to player winstreak award table to clear
*
 SUBR	rst_winstreak_awards
	PUSH	a0,a1
	movi	NUM_AWARDS-1,a0
	clr	a1
#rst_ws_award_loop
	move	a1,*a14+,W
	dsjs	a0,#rst_ws_award_loop
	PULL	a0,a1
	rets

#***************************************************************
*
* This array contains the number of ICONS to award for each item in
* the awards stuff.  This array MUST be in the same order as the
* awards indecies in game.equ
*
 SUBRP	award_icons:
	.byte	POWER_MOVE_ICONS     	;POWER_MOVE_AWD	
	.byte	REVERSALS_ICONS		;REVERSAL_AWD	
	.byte	HIGH_RISK_MOVE_ICONS	;HIGH_RISK_AWD	
	.byte	BLOCK_ICONS     	;BLOCKS_AWD	
	.byte	COMBOS_STARTED_ICONS	;COMBOS_AWD	
	.byte	COMBO_REVERSALS_ICONS	;COMBO_REV_AWD	
	.byte	COMBO_BREAKER_ICONS	;COMBO_BRKR_AWD	
	.byte	ULTRA_COMBOS_ICONS	;UCOMBOS_AWD	
	.byte	PERFECT_ICONS		;PERFECT_AWD	
	.byte	FIRST_HIT_ICONS		;FIRST_HIT_AWD	
	.byte	BIG_COMEBACK_ICONS	;COMEBACK_AWD	
	.byte	SUPER_QWK_VICTORY_ICONS	;SUPER_QUICK_AWD
	.byte	VERY_QWK_VICTORY_ICONS	;VERY_QUICK_AWD	
	.byte	QUICK_VICTORY_ICONS	;QUICK_AWD	
	.byte	DEFEAT_HUMAN_ICONS	;DFT_HUMAN_AWD	
	.byte	0			;Not used
	.byte	0			;Not used
	.byte	0			;Not used
	.byte	0			;Not used
	.byte	0			;Not used
	.byte	0			;Not used
	.byte	0			;Not used
	.byte	0			;Not used
	.byte	0			;Not used
	.byte	DBL_PERFECT_ICONS	;DBL_PERFECT_AWD
	.byte	TWO_ROUND_SWEEP_ICONS	;TWO_RND_AWD	
	.byte	0			;Not used
	.byte	0			;Not used
	.byte	GAME_COMPLETE_ICONS	;GAME_CMPLT_AWD
	.byte	FIVE_WINS_ICONS	  	;FIVE_WINS_AWD	
	.byte	0			;Not used
	.byte	0			;Not used
	.even

#***************************************************************
* round_award - adds in round ICONS for a player.
* a0 = pointer to player data.
* a10 = award index.
*
 SUBR	round_award
	PUSH	a9,a8
	move	*a0(PLYRNUM),a9,W	; Get the player number
	cmpi	2,a9			; Is this a human player
	jrge	#ra_out			; br = nope - get out
	X8	a10			; Mult award index by 8
	move	a10,a8
	movb	*a0(PLYR_SIDE),a9	; What side are we ?
	jrz	#cks_rnd_p1		; br = player 1
	addi	p2rnd_award,a10		; add player 2 round table base to index
	jruc	#cks_rnd_go		; increment counter
#cks_rnd_p1
	addi	p1rnd_award,a10		; add player 2 round table base to index
#cks_rnd_go
	addi	award_icons,a8
	movb	*a8,a8			; Get # ICONs to award
	movb	*a10,a9			; Get current value
	add	a8,a9			; Add em in
	movb	a9,*a10			; Put it back
#ra_out	PULL	a9,a8			; Restore A9
	rets				; Get the hell out


#***************************************************************
* match_award - adds round ICONS to match ICONS total
* a0 = pointer to player data.
* a10 = award index.
*
 SUBR	match_award
	PUSH	a9,a8
	move	*a0(PLYRNUM),a9,W	; Get the player number
	cmpi	2,a9			; Is this a human player
	jrge	#ma_out			; br = nope - get out
	X8	a10			; Mult award index by 8
	move	a10,a8
	movb	*a0(PLYR_SIDE),a9	; What side are we ?
	jrz	#cks_match_p1		; br = player 1
	addi	p2mtch_award,a10	; add player 2 round table base to index
	jruc	#cks_match_go		; increment counter
#cks_match_p1
	addi	p1mtch_award,a10	; add player 2 round table base to index
#cks_match_go
	addi	award_icons,a8
	movb	*a8,a8			; Get # ICONs to award
	movb	*a10,a9			; Get current value
	add	a8,a9			; Add em in
	movb	a9,*a10			; Put it back
#ma_out	PULL	a9,a8			; Restore A9
	rets				; Get the hell out

	
#* NOTE - These MUST Be in the same order as the award indexes in game.equ
*
 SUBRP	award_text
	.long	PWRMVEC		; Power Move
	.long	HIGHRSKC	; Reversal
	.long	HIGHRSKC	; High Risk
	.long	NOBLOCK		; No Blocks
	.long	HIGHRSKC	; Combos Started
	.long	CMBOREVC	; Combo Reversals
	.long	HIGHRSKC	; Combo Breakers
	.long	HIGHRSKC	; Ultra Combos
	.long	PERFECT		; Perfect
	.long	CMBOREVC	; First Hit
	.long	BIGCOME		; Big Comeback
	.long	HIGHRSKC	; Super Quick Pin
	.long	HIGHRSKC	; Very Quick Pin
	.long	FASTVIC		; Quick Pin
	.long	HIGHRSKC	; Defeated Human
	.long	0		; Not Yet Used
	.long	0		; Not Yet Used
	.long	0		; Not Yet Used
	.long	0		; Not Yet Used
	.long	0		; Not Yet Used
	.long	0		; Not Yet Used
	.long	0		; Not Yet Used
	.long	0		; Not Yet Used
	.long	0		; Not Yet Used
	.long	DOUBPERF	; DBL Perfect
	.long	TWOROUND	; First Two round win
	.long	0		; Not Yet Used
	.long	0		; Not Yet Used
	.long	HIGHRSKC	; Game Completed with < 5 buyins
	.long	FIVEWIN		; 5 Winstreak
	.long	0		; Not Yet Used
	.long	0		; Not Yet Used


;a8 = player number 0=1 1=2
;a9 = *bar record
;a11 = zip out on state #, zip in then die on state #+1
 SUBRP	zip_award_bar
	move	@player_award_state,a10,L
	cmp	a10,a11
	jrz	#zip_out
	SLEEPK	1
	jruc	zip_award_bar

#zip_out
	movi	ZIP_IN_SOUND,a0
	calla	triple_sound

	subi	(BONUS_RECORD_SIZE*32),a9
	addk	1,a11
	move	*a9((BONUS_RECORD_SIZE-1)*32),a0,W
	move	a8,a8
	jrz	#p1_zip_out
	movi	[-BONUS_BAR_VEL,0],a1
	jruc	#zip_out_loop
#p1_zip_out
	movi	[BONUS_BAR_VEL,0],a1
#zip_out_loop
	move	*a9,a10,L			; Bar
	move	*a10(OXVAL),a14,L
	add	a1,a14
	move	a14,*a10(OXVAL),L

	move	*a9(32),a10,L			; Text
	move	*a10(OXVAL),a14,L
	add	a1,a14
	move	a14,*a10(OXVAL),L

	move	*a9(64),a10,L			; 1st Icon
	move	*a10(OXVAL),a14,L
	add	a1,a14
	move	a14,*a10(OXVAL),L

	move	*a9(96),a10,L			; 2nd Icon
	jrz	#zout_done
	move	*a10(OXVAL),a14,L
	add	a1,a14
	move	a14,*a10(OXVAL),L

	move	*a9(128),a10,L			; 3rd Icon
	jrz	#zout_done
	move	*a10(OXVAL),a14,L
	add	a1,a14
	move	a14,*a10(OXVAL),L
#zout_done
	PUSHP	a0,a1
	SLEEPK	1
	PULLP	a0,a1
	move	*a9,a10,L
	move	*a10(OXPOS),a10,W
	cmp	a10,a0
	jrnz	#zip_out_loop

;	JSRP	flash_bar_icons

	move	*a9(((BONUS_RECORD_SIZE-1)*32)+16),a10,W
	jrnz	#no_zip_in

#wait_2nd_state	
	move	@player_award_state,a10,L
	cmp	a10,a11
	jrle	#zip_in
	SLEEPK	1
	jruc	#wait_2nd_state

#zip_in
	SLEEPK	3
	move	a8,a8
	jrz	#p1_zip_in
	movi	[BONUS_BAR_VEL,0],a1
	movi	399,a0
	jruc	#zip_in_loop
#p1_zip_in
	movi	[-BONUS_BAR_VEL,0],a1
	clr	a0
#zip_in_loop
	move	*a9,a10,L			; Bar
	move	*a10(OXVAL),a14,L
	add	a1,a14
	move	a14,*a10(OXVAL),L

	move	*a9(32),a10,L			; Text
	move	*a10(OXVAL),a14,L
	add	a1,a14
	move	a14,*a10(OXVAL),L

	move	*a9(64),a10,L			; 1st Icon
	move	*a10(OXVAL),a14,L
	add	a1,a14
	move	a14,*a10(OXVAL),L

	move	*a9(96),a10,L			; 2nd Icon
	jrz	#zin_done
	move	*a10(OXVAL),a14,L
	add	a1,a14
	move	a14,*a10(OXVAL),L

	move	*a9(128),a10,L			; 3rd Icon
	jrz	#zin_done
	move	*a10(OXVAL),a14,L
	add	a1,a14
	move	a14,*a10(OXVAL),L
#zin_done
	PUSHP	a0,a1
	SLEEPK	1
	PULLP	a0,a1
	move	*a9,a10,L
	move	*a10(OXPOS),a10,W
	cmp	a10,a0
	jrnz	#zip_in_loop

#zip_exit
	move	*a9,a0,L		; Bar
	calla	DELOBJ
	move	*a9(32),a0,L		; Text
	calla	DELOBJ
	move	*a9(64),a0,L		; 1st Icon
	calla	DELOBJ
	move	*a9(96),a0,L		; 2nd Icon
	jrz	#zip_die
	calla	DELOBJ
	move	*a9(128),a0,L		; 3rd Icon
	jrz	#zip_die
	calla	DELOBJ
#zip_die
	DIE

#no_zip_in
;	JSRP	flash_bar_icons
	move	@award_ok_to_die,a10,L
	addi	1,a10
	move	a10,@award_ok_to_die,L
#no_zip_in_wait
	move	@award_ok_to_die,a10,L
	cmpi	4,a10
	jrz	#zip_exit
	SLEEPK	1
	jruc	#no_zip_in_wait


 SUBRP	flash_bar_icons
	PUSHP	a8,a9
	move	a9,a10
	addi	64,a10
	movi	0101h,a9
#iflash_loop
	move	*a10+,a8,L
	jrz	#fbi_exit
	CREATE	AWARD_PID,FLASHME
	jruc	#iflash_loop
#fbi_exit
	SLEEPK	10
	PULLP	a8,a9
	RETP


 SUBRP	get_num_awards:
	PUSH	a6,a7,a8,a9,a11
	clr	a8
	movi	award_text,a6
	movi	NUM_AWARDS,a9
#gna_loop
	movb	*a10,a11
	jrz	#no_inc
	move	a11,*a7+,L
	cmpi	5,a11
	jrge	#gna_big_icon
	clr	a11
	jruc	#gna_get_text_obj
#gna_big_icon
	movi	1,a11
#gna_get_text_obj
	move	a11,*a7+,L
	move	*a6,*a7,L
	addi	32,a7
	addk	1,a8
#no_inc
	addi	32,a6
	addk	8,a10
	dsjs	a9,#gna_loop
	move	a8,a10
	cmpi	6,a8
	jrle	#no_limit
	movk	6,a10
#no_limit
	PULL	a6,a7,a8,a9,a11
	rets


#****************************************************************
*
* adjust_perfects - This function is called to check to see if 2 perfects
* have been registered for a match.  If so the perfects are deleted from
* a double perfect is put into the match awards and the 2 single perfects
* are removed.  This allows the double perfect to be registered in the
* winstreak accumulation and the proper icon bar to be displayed at the
* end of the match.
*
 SUBRP	adjust_perfects
	PUSH	a9,a10
	movi	p1mtch_award,a9
	addi	(PERFECT_AWD*8),a9
	movb	*a9,a10				; How many perfects for match
	cmpi	(PERFECT_ICONS*2),a10		; Is it 2?
	jrnz	#nop1_dbl_perfect		; br = nope
	clr	a10				; Reset match perfects
	movb	a10,*a9
	subi	(PERFECT_AWD*8),a9		; Add a double perfect
	addi	(DBL_PERFECT_AWD*8),a9
	movb	*a9,a10
	addk	DBL_PERFECT_ICONS,a10
	movb	a10,*a9
	jruc	#ap_done
#nop1_dbl_perfect
	movi	p2mtch_award,a9
	addi	(PERFECT_AWD*8),a9
	movb	*a9,a10
	cmpi	(PERFECT_ICONS*2),a10
	jrnz	#ap_done
	clr	a10
	movb	a10,*a9
	subi	(PERFECT_AWD*8),a9
	addi	(DBL_PERFECT_AWD*8),a9
	movb	*a9,a10
	addk	DBL_PERFECT_ICONS,a10
	movb	a10,*a9
#ap_done
#adjust_blocks
	movi	p1mtch_award,a9
	addi	(BLOCKS_AWD*8),a9
	movb	*a9,a10				; How many block awards for match
	cmpi	(BLOCK_ICONS*2),a10		; Is it >= 2?
	jrlt	#nop1_dbl_block			; br = nope
	movk	DBL_BLOCK_ICONS,a10		; Give bigger award for multiround no blocking
	movb	a10,*a9
#nop1_dbl_block
	movi	p2mtch_award,a9
	addi	(BLOCKS_AWD*8),a9
	movb	*a9,a10
	cmpi	(BLOCK_ICONS*2),a10
	jrlt	#ab_done
	movk	DBL_BLOCK_ICONS,a10
	movb	a10,*a9
#ab_done
	PULL	a9,a10
	rets

; A8 = Player number
; A9 = *next bar icon record
 SUBRP	adjust_text_position
	PUSH	a9
	subi	((BONUS_RECORD_SIZE-3)*32),a9	;Point at Icon 2 object
#adj_t_loop
	move	*a9,a0,L		;Object exist ?
	jrz	#atp_exit		;br = no
	move	*a0(OIMG),a14,L		;Get image pointer
	move	*a14,a14,W		;Get image width
	move	a8,a8			;Player 1?
	jrnz	#do_tadjust		;br = no
	neg	a14
#do_tadjust
	move	*a9(OXPOS),a0,W		;Get current XPos
	add	a14,a0			;Adjust it
	move	a0,*a9(OXPOS),W		;Write it back
	addi	32,a9
	jruc	#adj_t_loop
#atp_exit
	PULL	a9
	rets


 SUBRP	create_player_awards

	movi	bar_obj_ptr,a9
	movi	p1mtch_award,a10
	movi	picon,a7
	move	a8,a8						; player 1 ?
	jrz	#dpa_p1						; br = yes
	addi	(MAX_BONUS_BARS*BONUS_RECORD_SIZE*32),a9
	addi	(MAX_BONUS_BARS*3*32),a7
	movi	p2mtch_award,a10
#dpa_p1
	callr	get_num_awards				; Get the number of awards
	move	a10,a10
	jrz	#no_awards

	move	a7,a0
	PUSH	a0
	movk	1,a11
	movi	[BONUS_BAR_YPOS,0],a1			;Start Y position
	movi	1800h,a3				;Start Z position
	movi	TYPVELALWAYS,a5				;Object ID
	clr	a6
	clr	a7					;Y velocity

; Make a bonus bar
#do_next_award_bar
	movi	BONUSBAR,a2				;Image Pointer
	movi	[399,0],a0				;Start X position
	movi	DMAWNZ|M_3D|M_SCRNREL,a4		;DMA flags
	movi	DPLT_R_P,b0				;Make em BLUE
	move	a8,a8					;Player 1?
	jrnz	#do_bar					;br = no
	clr	a0
	movi	DMAWNZ|M_3D|M_SCRNREL|M_FLIPH,a4	;DMA flags
	movi	DPLT_B_P,b0				;Make em BLUE
#do_bar
	mmtm	sp,a1,a8
	calla	BEGINOBJP				;Bonus Bar
	move	a8,*a9+,L
	mmfm	sp,a1,a8

; Make the bonus bar text
	movi	DMAWNZ|M_3D|M_SCRNREL,a4		;DMA flags
	PULL	a0
	move	*a0(64),a2,L
	PUSH	a0
	movi	[399+BONUS_RTEXT_START_XPOS,0],a0
	move	a8,a8					;Player 1?
	jrnz	#do_text				;br = no
	movi	[BONUS_LTEXT_START_XPOS,0],a0
#do_text
	addi	10h,a3
	mmtm	sp,a1,a8
	calla	BEGINOBJ				;Bonus Bar
	move	a8,*a9+,L
	mmfm	sp,a1,a8

; Make the bonus bar icon 1
	PULL	a0
	callr	get_bbicons
	PUSH	a0
	movi	[399-BONUS_ICON1_START_XPOS,0],a0	;Start X position
	move	a8,a8					;Player 1?
	jrnz	#do_icon_1				;br = no
	movi	[BONUS_ICON1_START_XPOS,0],a0		;Start X position
#do_icon_1
	addi	10h,a3
	mmtm	sp,a1,a8
	move	*a9,a2,L
	calla	BEGINOBJ				;Icon 1
	move	a8,*a9+,L
	mmfm	sp,a1,a8

; Make the bonus bar icon 2
	move	*a9,a2,L
	jrz	#no_2nd_icon
	movi	[399-BONUS_ICON2_START_XPOS,0],a0	;Start X position
	move	a8,a8					;Player 1?
	jrnz	#do_icon_2				;br = no
	movi	[BONUS_ICON2_START_XPOS,0],a0		;Start X position
#do_icon_2
	addi	10h,a3
	mmtm	sp,a1,a8
	calla	BEGINOBJ				;Icon 2
	move	a8,*a9+,L
	mmfm	sp,a1,a8
	jruc	#chk_3rd_icon
#no_2nd_icon
	clr	a2
	move	a2,*a9+,L
	jruc	#no_more_icons
#chk_3rd_icon

; Make the bonus bar icon 3
	move	*a9,a2,L
	jrz	#no_more_icons
	movi	[399-BONUS_ICON3_START_XPOS,0],a0	;Start X position
	move	a8,a8					;Player 1?
	jrnz	#do_icon_3				;br = no
	movi	[BONUS_ICON3_START_XPOS,0],a0		;Start X position
#do_icon_3
	addi	10h,a3
	mmtm	sp,a1,a8
	calla	BEGINOBJ				;Icon 3
	move	a8,*a9+,L
	mmfm	sp,a1,a8
	jruc	#icon_3_done

#no_more_icons
	clr	a2
	move	a2,*a9+,L
#icon_3_done
	movi	(399-BONUS_BAR_END_XPOS),a0
	move	a8,a8					;Player 1?
	jrnz	#do_td_pos				;br = no
	movi	BONUS_BAR_END_XPOS,a0			;End for check award
#do_td_pos
	move	a0,*a9+,W				;Store Ending position
	clr	a0
	move	a0,*a9+,W				;Store NOT last

	callr	adjust_text_position			;Adjust text position based on number of icons

#create_bar_proc
	mmtm	sp,a1,a7
	CREATE	AWARD_PID,zip_award_bar			; Process to control this bar
	mmfm	sp,a1,a7

	addk	1,a11
	PULL	a0
	addi	96,a0
	PUSH	a0
	dsj	a10,#do_next_award_bar

	movk	1,a0
	move	a0,-*a9,W				;Store last
	PULL	a0
	rets
#no_awards
	move	@award_ok_to_die,a9,L
	addi	1,a9
	move	a9,@award_ok_to_die,L
	rets


 SUBRP	total_icons
	move	a8,a8
	jrz	#tot_p1_icons
	movi	p2mtch_award,a9
	movi	p2icon_total,a10
	jruc	#tot_awards
#tot_p1_icons
	movi	p1mtch_award,a9
	movi	p1icon_total,a10
#tot_awards
	movi	NUM_AWARDS,a11
	move	*a10,a8,L
#tot_awards_loop
	movb	*a9,a14
	sll	24,a14
	srl	24,a14
	add	a14,a8
	addk	8,a9
	dsjs	a11,#tot_awards_loop
	move	a8,*a10,L
	rets



 SUBR	clear_icon_total
	move	a8,a8
	jrz	#clr_p1_icons
	clr	a8
	move	a8,@p2icon_total,L
	rets
#clr_p1_icons
	move	a8,@p1icon_total,L
	rets
	

#****************************************************************
*
* create_end_rnd_awards - This PROCESS creates the icon bars displayed
* at the end of a match.
*
 SUBR	create_end_rnd_awards
	move	@royal_rumble,a14
	jrz	#cera_ok
	DIE
#cera_ok

	callr	adjust_perfects

	movi	(MAX_BONUS_BARS*BONUS_RECORD_SIZE*2),a8
	movi	bar_obj_ptr,a9
	clr	a11
#clr_array_loop
	move	a11,*a9+,L
	dsjs	a8,#clr_array_loop

	clr	a8				; Clear the state machine
	move	a8,@player_award_state,L

;1PLYR
	move	*a10(PLYR_SIDE),a8

	callr	create_player_awards		; Create awards for player 1
;1PLYR	movk	1,a8
;1PLYR	callr	create_player_awards		; Create awards for player 2

	movk	1,a8				; Start the state machine
	move	a8,@player_award_state,L

#state_loop
	movi	((TSEC*3)/4),a9			; How long each bar is diplayed
#state_loop1
	SLEEPK	1
	calla	get_all_buttons_cur
	jrnz	#quick_states
	dsjs	a9,#no_state_advance		; Is it time to advance the state machine?
	addk	1,a8				; Yes
	move	a8,@player_award_state,L
	jruc	#state_loop			; Reset the Sleeper time
#no_state_advance
	move	@award_ok_to_die,a10,L		; Is it time to exit ?
;1PLYR	cmpi	2,a10
	cmpi	1,a10
	jrnz	#state_loop1			; br = no

	clr	a8
	callr	total_icons
	movk	1,a8
	callr	total_icons

	movi	TSEC/2,a8
#wait
	SLEEPK	1
	calla	get_all_buttons_cur
	jrnz	#wait_abort
	dsjs	a8,#wait
#wait_abort
	movk	3,a8
	move	a8,@award_ok_to_die,L

	DIE

#quick_states
	SLEEPK	5
	addk	1,a8
	move	a8,@player_award_state,L
	jruc	#no_state_advance


#****************************************************************
* 
* is_it_a_really_quick_win - This function determines whether the win
* by the player (a10) was quick enough to be awarded an icon.  If so
* an icon is awarded. 
* 
  SUBR	is_it_a_really_quick_win
	PUSH	a0,a1,a2
	move	@match_time,a0,L
	move	a0,a2
	andi	0fh,a0
	movk	10,a1
	mpyu	a0,a1
	srl	16,a2
	add	a2,a1
	cmpi	69,a1
	jrgt	#quick
	jruc	#iiarqw_done

	cmpi	79,a1
	jrgt	#super_quick
	cmpi	73,a1
	jrgt	#very_quick
	cmpi	64,a1
	jrgt	#quick
	jruc	#iiarqw_done
#super_quick
	RND_AWARD	a10,SUPER_QUICK_AWD
	jruc	#iiarqw_done
#very_quick
	RND_AWARD	a10,VERY_QUICK_AWD
	jruc	#iiarqw_done
#quick
	RND_AWARD	a10,QUICK_AWD
#iiarqw_done
	PULL	a0,a1,a2
	rets


#****************************************************************
* 
* give_award_if_opponent_is_human - This function awards the player
* with ICONs if he/she defeated a human player.
* 
  SUBR	give_award_if_opponent_is_human
	PUSH	a9
	movb	*a10(PLYR_SIDE),a9
	jrz	#i_am_player1
	move	@PSTATUS,a9
	andi	01b,a9
	jruc	#gaioih_award
#i_am_player1
	move	@PSTATUS,a9
	andi	10b,a9
#gaioih_award
	jrz	#gaioih_done
	RND_AWARD a10,DFT_HUMAN_AWD
#gaioih_done
	PULL	a9
	rets
	rets


#****************************************************************
* 
* arm_comeback_award - This function arms the big comeback ICON
* awarding system.
* 
* a10 = Index number of player
* 

  SUBR	arm_comeback_award
	cmpi	2,a10
	jrlt	#ok_to_arm
	rets
#ok_to_arm

	;figure out if all opponents are at 80%+ strength.
	movi	process_ptrs,a8
	movi	NUM_WRES,a9
#lp	move	*a8+,a0,L
	jrz	#nxt		;skip inactive

	move	*a0(PLYR_SIDE),a14
	cmp	a14,a10		;humans only, so PLYRNUM == PLYR_SIDE
	jreq	#nxt		;skip teammates

	move	*a0(PLYRNUM),a1
	calla	get_health
	cmpi	(LIFE_MAX*80)/100,a0
	jrlt	#rets		;abort if any enemy is under 80% strength
    
#nxt	dsj	a9,#lp

	PUSH	a0,a10
	X32	a10
	addi	pcomeback,a10
	movk	1,a0
	move	a0,*a10,L
	PULL	a0,a10
#rets	rets


#****************************************************************
* 
* check_for_award_for_big_comeback - This function awards ICONS for a
* player who cameback from the brink of disaster
* 
  SUBR	check_for_award_for_big_comeback
	PUSH	a9
	movb	*a10(PLYR_SIDE),a9
	jrz	#i_am_player1
	move	@(pcomeback+32),a9,L
	jrz	#gfbc_done
	jruc	#gfbc_award
#i_am_player1
	move	@pcomeback,a9,L
	jrz	#gfbc_done
#gfbc_award
	RND_AWARD a10,COMEBACK_AWD
#gfbc_done
	PULL	a9
	rets


#****************************************************************
* 
* arm_winstreak_award - This function arms the winstreak ICON
* awarding system.
* 
* a1 = Winstreak Value
* a2 = Player Number
* 
  SUBR	arm_winstreak_award
	move	a1,a1
	jrz	#awa_exit
	PUSHP	a0,a1
	X32	a2
	addi	pwsarm,a2
	movk	5,a0
	modu	a0,a1
	jrnz	#awa_disarm
	movk	1,a0
	jruc	#awa_ok
#awa_disarm
	clr	a0
#awa_ok
	move	a0,*a2,L
	PULLP	a0,a1
#awa_exit
	rets


#****************************************************************
* 
* check_for_award_for_winstreak
* player who cameback from the brink of disaster
* 
  SUBR	check_for_award_for_winstreak
	PUSH	a0,a9,a10
	move	a10,a0
	movb	*a10(PLYR_SIDE),a9
	jrz	#i_am_player1
	movi	(pwsarm+32),a10
	move	*a10,a9,L
	jrz	#cfafw_done
	jruc	#cfafw_award
#i_am_player1
	movi	pwsarm,a10
	move	*a10,a9,L
	jrz	#cfafw_done
#cfafw_award
	MATCH_AWARD a0,FIVE_WINS_AWD
	clr	a9
	move	a9,*a10,L
#cfafw_done
	PULL	a0,a9,a10
	rets

; A0 = *num icons
; A9 = *objects
 SUBR	get_bbicons
	PUSH	a0,a1,a9
	move	*a0,a0,L	; Get number of Icons
	cmpi	5,a0		; Num < 5?
	jrlt	#small_icons	; br = yes
	cmpi	10,a0		; Num < 10?
	jrlt	#s_and_l_icons	; br = yes
	movi	BICON_10,a0
	move	a0,*a9+,L	; Store the image pointer
	jruc	#gbb_done
#small_icons
	movi	BICON_1,a1
	cmpi	4,a0
	jrlt	#small_loop
	.if DEBUG
	LOCKUP
	.endif
	subk	1,a0
#small_loop
	move	a1,*a9+,L	; Store Icon image
	dsjs	a0,#small_loop
	jruc	#gbb_done
#s_and_l_icons
	cmpi	5,a0
	jrz	#is_five
	cmpi	7,a0
	jrlt	#gt5_ok
	.if DEBUG
	LOCKUP
	.endif
	movk	7,a0
#gt5_ok
	movi	BICON_1,a1
#sloop
	move	a1,*a9+,L
	subk	1,a0
	cmpi	5,a0
	jrnz	#sloop
#is_five
	movi	BICON_5,a1
	move	a1,*a9+,L
#gbb_done
	clr	a0
	move	a0,*a9,L
	PULL	a0,a1,a9
	rets
	



 SUBRP	bbicon_table
	.long	BICON_1A
	.long	BICON_5A
	.long	BICON_10A
	.long	BICON_20A
	.long	BICON_30A
	.long	BICON_40A
	.long	BICON_50A
	.long	BICON_60A
	.long	BICON_70A
	.long	BICON_80A
	.long	BICON_90A
	.long	BICON_100A


 SUBRP	get_bonus_icons
	PUSH	a0,a1,a2,a3,a4,a9
	addi	32,a9
	clr	a4
	move	a1,a3
	move	a1,a0
	cmpi	100,a3
	jrge	#icon_max

	clr	a2
#get_tens_loop
	cmpi	10,a3
	jrlt	#tens_done
	subi	10,a3
	addk	1,a2
	jruc	#get_tens_loop
#tens_done
	move	a2,a2
	jrz	#no_tens
	addk	1,a2
	sll	5,a2
	addi	bbicon_table,a2
	move	*a2,a1,L
	move	a1,*a9+,L
	move	*a1,a1,W
	add	a1,a4
#no_tens
	move	a0,a3
	movk	10,a2
	modu	a2,a3
	cmpi	5,a3
	jrlt	#less_five
	move	@(bbicon_table+32),a2,L
	move	a2,*a9+,L
	move	*a2,a1,W
	add	a1,a4
	subi	5,a3
#less_five
	move	a3,a3
	jrz	#no_ones
	move	@bbicon_table,a2,L
	move	*a2,a1,W
#ones_loop
	move	a2,*a9+,L
	add	a1,a4
	dsjs	a3,#ones_loop
#no_ones
	srl	1,a4
	move	a4,@icon_string_width,L
	clr	a2
	move	a2,*a9,L
	PULL	a0,a1,a2,a3,a4,a9
	rets
#icon_max
	movi	BICON_100A,a2
	move	a2,*a9+,L
	move	*a2,a1
	add	a1,a4
	jruc	#no_ones

; a10 = player num
; a1  = num icons
 SUBRP	audit_icons
	PUSH	a0,a1,a2
	move	a1,a2
	movi	AUD_P1ICONMAX,a0
	move	a10,a10
	jrz	#p1_audit
	movi	AUD_P2ICONMAX,a0
#p1_audit
	calla	GET_AUD
	cmp	a1,a2
	jrle	#not_higher
	move	a2,a1
	calla	STORE_AUDIT
#not_higher
	PULL	a0,a1,a2
	rets



  SUBR	show_bonus_icons
	PUSH	a0,a1,a2,a3,a4,a5,a6,a7,a9,a11
	movi	[BONUS_MSG_XPOS1,0],a0
	move	a10,a10
	jrz	#p1bonus
	movi	p2bicon,a9
	move	@p2winstreak,a1,W

	.if SHOW_ACCUM_ICONS
	move	@p2oldwinstreak,a2,W
	cmp	a1,a2
	.endif

	jrz	#total_reset
	move	@p2icon_total,a1,L
	jrz	#no_bonus
	callr	audit_icons
	movi	[BONUS_MSG_XPOS2,0],a0
	jruc	#do_bonus
#p1bonus
	movi	p1bicon,a9
	move	@p1winstreak,a1,W

	.if SHOW_ACCUM_ICONS
	move	@p1oldwinstreak,a2,W
	cmp	a1,a2
	.endif

	jrz	#total_reset
	move	@p1icon_total,a1,L
	jrz	#no_bonus
	callr	audit_icons
#do_bonus
	callr	get_bonus_icons

	movi	[BONUS_MSG_YPOS,0],a1
	movi	SKILBON,a2
	movi	104+200,a3
	movi	DMAWNZ|M_SCRNREL,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ
	move	a8,*a9+,L

	move	a10,a10
	jrz	#p1icon
	movi	[BONUS_ICON_XPOS2,0],a0
	jruc	#dobicon
#p1icon
	movi	[BONUS_ICON_XPOS1,0],a0
#dobicon
	move	@icon_string_width,a1,L
	sll	16,a1
	sub	a1,a0
	move	*a9,a2,L
#dobicon_loop
	movi	[BONUS_ICON_YPOS,0],a1
	PUSH	a0
	calla	BEGINOBJ
	PULL	a0
	move	*a2,a11,W
	sll	16,a11
	add	a11,a0
	move	a8,*a9+,L
	move	*a9,a2,L
	jrnz	#dobicon_loop
#no_bonus
	clr	a0
	move	a0,*a9,L
	PULL	a0,a1,a2,a3,a4,a5,a6,a7,a9,a11
	rets



 SUBRP	#total_reset
	move	a10,a10
	jrz	#p1_reset
	clr	a0
	move	a0,@p2icon_total,L
	jruc	#no_bonus
#p1_reset
	clr	a0
	move	a0,@p1icon_total,L
	jruc	#no_bonus


 SUBR	del_bonus_icons
	PUSH	a0,a2
	move	a10,a10
	jrnz	#del_p2
	movi	p1bicon,a2
	jruc	#del_bicon
#del_p2
	movi	p2bicon,a2
#del_bicon
	move	*a2+,a0,L
	jrz	#del_done
	calla	DELOBJ
	jruc	#del_bicon
#del_done
	PULL	a0,a2
	rets



 SUBR	show_progress_bicons
	PUSH	a0,a1,a2,a3,a4,a5,a6,a6,a9,a10
	move	@p2icon_total,a1,L
	jrnz	#do_spb
#spb_p1
	move	@p1icon_total,a1,L
	jrz	#no_picons
#do_spb
	movi	progress_icons,a9
	callr	get_bonus_icons
	movi	[PROG_BICON_XPOS,0],a0
	move	@icon_string_width,a1,L
	sll	16,a1
	sub	a1,a0
	move	*a9,a2,L
	movi	>2000,a3
	movi	DMAWNZ|M_SCRNREL,a4
	movi	CLSNEUT,a5
	clr	a6
	clr	a7
	addi	32,a9
	move	*a9,a2,L
#dopicon_loop
	movi	[PROG_BICON_YPOS,0],a1
	PUSH	a0
	calla	BEGINOBJ
	PULL	a0
	move	*a2,a10,W
	sll	16,a10
	add	a10,a0
	move	a8,*a9+,L
	move	*a9,a2,L
	jrnz	#dopicon_loop
#no_picons
	clr	a6
	move	a6,*a9,L
	PULL	a0,a1,a2,a3,a4,a5,a6,a6,a9,a10
	rets


 SUBR	del_progress_icon
	PUSH	a0,a2
	movi	progress_icons,a2	; Get pointer to progess screen icon array
	addi	32,a2
#del_picon
	move	*a2+,a0,L		; Get pointer to object
	jrz	#delp_done		; br = not valid object pointer
	calla	DELOBJ			; Delete the object
	jruc	#del_picon		; Go get next
#delp_done
	PULL	a0,a2
	rets


; Displays dufus messages for each HUMAN player

 SUBR	show_dufus_messages

	PUSHP	a9,a10				; Save o reggie

	clr	a9				; Set up state machine
	move	a9,@award_ok_to_die,L
	move	a9,@dboxes_on,L

f_wait
	move	@in_finish_move,a14		; Are we doing a finishing move ?
	jrz	f_done				; br = no
	SLEEPK	10
	jruc	f_wait
f_done

	movk	1,a10				; Msg number to show
	CREATE	AWARD_PID,display_dufus_message	; Show msgs for player 1

	movk	1,a10				; Msg number to show
	movk	1,a9
	CREATE	AWARD_PID,display_dufus_message	; Show msgs for player 2

	SLEEPK	15				; Give it a little time

	PULLP	a9,a10				; All done
	RETP


 SUBRP	dufus_msgs
	.long	TORUN			; 1st Dufus Message (RUN)
	.long	CONTROLI		; 2nd Dufus Message (GETUP INSTRUCTIONS)
	.long	OUTRING			; 3rd Dufus Message (OUTRING INSTRUCTIONS)


; A13 = *player data
; A1 = message number (1-3)
 SUBR	dufus_msg_off
	PUSH	a0,a2,a3
	move	*a13(PLYRNUM),a2,W	; Get the player number
	cmpi	2,a2			; Is this a human player
	jrge	#dmoff_exit		; br = nope - get out

	movi	p1dufus_msg_flags,a2	; Get pointer to player 1 msg flags
	movb	*a13(PLYR_SIDE),a0	; Are we player 1?
	jrz	#do_dufus_msg_off	; br = yes
	movi	p2dufus_msg_flags,a2	; Get pointer to player 2 msg flags
#do_dufus_msg_off
	subk	1,a1			; Decrement msg number
	move	*a2,a0,L		; Get msg flags
	movk	1,a3			; Set up for bit shift
	sll	a1,a3
	andn	a3,a0			; Disable this msg
	move	a0,*a2,L		; Write it back
#dmoff_exit
	PULL	a0,a2,a3
	rets


; A9 = message number
; A10 = *player data
 SUBR	dufus_msg_on

	move	*a10(PLYRNUM),a8,W		; Get the player number
	cmpi	2,a8				; Is this a human player
	jrge	#dmo_exit			; br = nope - get out
	move	@p1dufus_msg_flags,a14,L	; Get Player 1 msg flags
	movi	p1winstreak,a11
;	movb	*a10(PLYR_SIDE),a8		; Get Player number
	movb	*a10(PLYRNUM),a8		; Get Player number
	jrz	#p1_dmo				; br = player 1
	move	@p2dufus_msg_flags,a14,L	; Get Player 2 msg flags
	movi	p2winstreak,a11
#p1_dmo
	move	*a11,a11,W			; 3 or more wins ?
	cmpi	3,a11				
	jrge	#dmo_exit			; br = yes
	move	a9,a10				; Save msg number
	move	a8,a9				; Save player number
	move	a10,a11
	subk	1,a11				; sub 1 from msg num
	movk	1,a8				; set up for bit shift
	sll	a11,a8				; shift by msg num-1
	and	a8,a14				; will this msg be displayed?
	jrz	#dmo_exit			; br = no

	clr	a8				; Set up state machine
	move	a8,@award_ok_to_die,L

	CREATE	4000h|AWARD_PID,display_dufus_message

	movi	TSEC,a10			; Let box get displayed for 1 second
#min_time_loop
	SLEEPK	1
	callr	suspend_all			; Put all but unsuspendables to sleep
	dsjs	a10,#min_time_loop		; 1 second? - br = no

	movi	TSEC*2,a10			; Allow up to 2 more seconds
#wait_die_loop
	SLEEPK	1
	callr	suspend_all			; Put all but unsuspendables to sleep
	calla	get_all_buttons_cur		; Anybody pressing buttons?
	jrnz	#dmo_abort			; br = yes
	dsjs	a10,#wait_die_loop		; 2 seconds? - br = no
#dmo_abort
	movk	1,a9				; Tell display_dufus_msg to die
	move	a9,@award_ok_to_die,L
#dmo_exit
	DIE
	

 SUBRP	suspend_all
	movi	ACTIVE,a3,L

#lp	move	*a3,a3,L	;Get next
	jrz	#x		;End?
	move	*a3(PROCID),a14	;Get Process ID
	andi	0c000h,a14	;Is this either an indestructable or unsuspendable process?
	jrnz	#lp		;br = yes

	move	*a3(PTIME),a14	;Get current Sleep time
	addk	1,a14		;Add 1 to it
	move	a14,*a3(PTIME)	;Write it back
	jruc	#lp		;Go check next process

#x	rets



 SUBR	reset_dufus_msgs
	PUSH	a0,a1
	movi	p1dufus_msg_flags,a1		; Pointer to player 1 msg enables
	move	a0,a0				; Reset player 1 msgs?
	jrz	#rst_d_p1			; br = yes
	movi	p2dufus_msg_flags,a1		; Pointer to player 2 msg enables
#rst_d_p1
	movk	0fh,a0				; Enable all msgs
	move	a0,*a1,L
	PULL	a0,a1
	rets

;a9  = player number
;a11 = *objects (2)
;a2  = current scale divisor
 SUBRP	#adjust_tl
	PUSH	a2,a7,a10
	srl	8,a2
	andni	0ffh,a2			; Mask lower scale bits
	move	*a11(32),a14,L		; Get pointer to object
	move	*a14(OIMG),a3,L		; Get pointer to image header

	move	*a3,a7,W		; Get image Width
	sll	15,a7			; x 10000h
	divu	a2,a7			; divide by scale factor
	movi	DUFUS_BOX_LXPOS,a10
	move	a9,a9			; Am I player 1?
	jrz	#atl_right		; br = yes
	movi	DUFUS_BOX_RXPOS,a10
#atl_right
	sub	a7,a10			; Upper left X
	move	a10,*a14(OXPOS)		; Set box X
	move	*a11,a14,L		; Get text object pointer
	move	a10,*a14(OXPOS)		; Set text X

	move	*a3(16),a7,W		; Get image Width
	sll	15,a7			; x 10000h
	divu	a2,a7			; divide by scale factor
	movi	DUFUS_BOX_YPOS,a10
	sub	a7,a10			; Upper Left Y
	move	*a11(32),a14,L		; Get Box object pointer
	move	a10,*a14(OYPOS)		; Set Box Y
	move	*a11,a14,L		; Get text object pointer
	move	a10,*a14(OYPOS)		; Set Text Y
	PULL	a2,a7,a10

	rets
	


; Displays dufus messages for a player
; A9 = player number
; A10 = message number (1 - 4)
 SUBR	display_dufus_message

	move	@PSTATUS,a14
	move	a9,a9				; Player 1?
	jrz	#p1_is_dufus			; br = yes
	move	@p2winstreak,a0,W		; Is this player on a winstreak?
	cmpi	3,a0
	jrge	#no_dufus_msg			; br = yes (no dufus msgs)
	movi	p2dufus_msg_flags,a1		; 
	movi	[DUFUS_BOX_RXPOS,0],a0		; Set p2 box x position
	movi	p2dufus_obj,a11			; Pointer to be used later
	jruc	#dufus_msg_box			; Go do it
#p1_is_dufus
	move	@p1winstreak,a0,W		; Is this player on a winstreak?
	cmpi	4,a0
	jrge	#no_dufus_msg			; br = yes (no dufus msgs)
	movi	p1dufus_msg_flags,a1		; Get which msgs to show
	movi	p1dufus_obj,a11			; Pointer to used later
	movi	[DUFUS_BOX_LXPOS,0],a0		; Set p1 box x position
#dufus_msg_box
	btst	a9,a14				; Is this really a human ?
	jrz	#no_dufus_msg			; br = no
	move	*a1,a2,L			; Get enabled msg flags
	movk	1,a3				; Generate bit number of msg we want displayed
	subi	1,a10				; Subtract 1 from msg number
	move	a10,a8				; Save msg number
	sll	a10,a3				; Shift bit up
	move	a2,a10				; Save bit
	and	a3,a2				; Ok to display msg ?
	jrz	#no_dufus_msg			; br = no
	andn	a3,a10				; Disable this msg
	move	a10,*a1,L			; Write it back
	move	a8,a3				; Get msg number
	sll	5,a3				; Offset into table
	addi	dufus_msgs,a3			; Add table pointer
	movk	1,a2
	move	a2,@dboxes_on,L
	move	*a3,a2,L			; Get image pointer (text)
	movi	[DUFUS_BOX_YPOS,0],a1		; Vertical Position
	movi	>2000,a3			; Z Position
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	; DMACTRL
	movi	CLSNEUT,a5			; Object ID
	clr	a6				; X Velocity 
	clr	a7				; Y Velocity
	PUSH	a0,a1				; Save these
	calla	BEGINOBJ			; Create Text Object
	PULL	a0,a1				; Restore regs
	move	a8,*a11,L			; Save off object pointer
	movi	05000500h,a2			; Set initial text scale factor
	move	a2,*a8(OSCALE),L
	movi	INFOBOX,a2			; Box Image Pointer
	subi	10h,a3	 			; Make sure box is behind text
	movi	DPLT_B_P,b0			; Player 1 palette
	move	a9,a9				; Are we player 1?
	jrz	#p1_dufus_box_pal		; br = yes
	movi	DPLT_R_P,b0			; Player 2 palette
#p1_dufus_box_pal
	calla	BEGINOBJP			; Create the box
	move	a8,*a11(32),L			; Save box object pointer
	movi	05000500h,a2			; Set initial box scale factor
	move	a2,*a8(OSCALE),L
	movi	02000200h,a3			; Initial amount to adjust scale factor
#dufus_wait
	PUSHP	a2,a3,a8			; Savey reggies
	callr	#adjust_tl			; Adjust top/left corner position
	SLEEPK	1				; Wait
	PULLP	a2,a3,a8 			; Getty reggies
	cmpi	01000100h,a2			; Are we at full size
	jrz	#dufus_flash			; br = yes
	sub	a3,a2				; Adjust scale factor
	cmpi	00010001h,a3			; Scaling value = 1?
	jrz	#no_more_shift			; br = yes
	srl	1,a3				; Adjust scaling value
#no_more_shift					
	move	*a11,a8,L			; Get pointer to text object
	move	a2,*a8(OSCALE),L		; Set new scale factor
	move	*a11(32),a8,L			; Get pointer to box object
	move	a2,*a8(OSCALE),L		; Set new scale factor
	jruc	#dufus_wait			; Do it again
#dufus_flash
	movi	BOX_OUT_SOUND,a0
	calla	triple_sound
	move	*a11(32),a8,L			; Get the object pointer
	movi	0101h,a9			; Constant color (white)
	CREATE	4000h|AWARD_PID,FLASHME		; Flash him once
	SLEEPK	5
	CREATE	4000h|AWARD_PID,FLASHME		; Flash him twice
	SLEEPK	5
#dufus_done
	SLEEPK	1
	move	@award_ok_to_die,a0,L		; Should I croak?
	jrz	#dufus_done			; br = no

	move	*a11,a0,L			; Get rid of text object
	calla	DELOBJ
	move	*a11(32),a0,L			; Get rid of box object
	calla	DELOBJ
#no_dufus_msg
	DIE					; Crooooak!!!



	.bss	pin_objects,32*2


******************************************************************************
*
* a9 is dead team (0 or 1).  Figure out if we need to post the message or
* not.

 SUBR	pin_prompt

	move	@royal_rumble,a14	; Are we in royal rumble mode ?
	jrnz	#check_count		; br = yes
	calla	is_8_on_1		; Are is 8 on 1 mode ?
	jrnc	#not_8_on_1		; br = no
#check_count
	move	@wrestler_count,a14	; Are there any drones left to kill ?
	jrnz	#die			; br = yes
#not_8_on_1

	;quit if there's already one of these going. (not likely)
	movi	PINHIM_ANIM_PID,a0
	movi	-1,a1
	calla	EXISTP
	jrnz	#die

	;look for a live human from the winning team inside the ring.
	;quit if there isn't one.
	movi	process_ptrs,a0
	movi	2,a1			;only check humans
#lp0	move	*a0+,a2,L
	jrz	#nxt0			;skip inactive
	move	*a2(PLYR_SIDE),a14
	cmp	a9,a14
	jreq	#nxt0			;skip dead team
	move	*a2(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#nxt0			;skip dead guys (shouldn't be any)
	move	*a2(INRING),a14
	jrnz	#nxt0			;skip outside guys
	jruc	#f_dead			;got one.  move on.
#nxt0	dsj	a1,#lp0
	jruc	#die			;no live winning human found.  quit.

#f_dead	;Make sure everyone on the dead team is actually dead and not
	; a zombie.  Further, make sure at least one is inside the ring.
	move	a2,a8			;save proc ptr of pinner.
	clr	a10			;"found pinable guy" flag

	movi	process_ptrs,a0
	movi	NUM_WRES,a1		;check everyone
#lp1	move	*a0+,a2,L
	jrz	#nxt1			;skip inactive
	move	*a2(PLYR_SIDE),a14
	cmp	a9,a14
	jrne	#nxt1			;skip live team
	move	*a2(INRING),a14
	jrnz	#nxt1			;skip outside guys
	move	*a2(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jrne	#die			;found live guy - quit
	move	*a2(STATUS_FLAGS),a14,L
	btst	B_ZOMBIE,a14
	jrnz	#die			;found zombie - quit
	inc	a10			;got one.
#nxt1	dsj	a1,#lp1



	;done looking, and everyone on the dead team is dead and not a
	;zombie.  If a10 is set, that means we also found at least one
	;inside the ring, so we can go ahead and flash the message.
#fp_dn	TEST	a10
	jrz	#die


	calla	END_MATCH_SPEECH	;do the obnoxious "PIN HIM!" crap.

	MOVI	0BBH,A0			;Move name annc snd
	CALLA	triple_sound


	movi	pin_objects,a9
	
	movi	[128,0],a1
	movi	CHOICBK,a2
	movi	1800h,a3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	; DMACTRL
	movi	TYPPINHIM,a5
	clr	a6				; X Velocity 
	clr	a7				; Y Velocity

	move	*a8(PLYR_SIDE),a14
	jrnz	#onrt

	;left
	move	@p1pins,a0
	addk	1,a0
	move	a0,@p1pins
	movi	[-100,0],a0
	movi	[-50,0],b6
	clr	a10
	movi	DPLT_B_P,b0
	movk	5,a11
	jruc	#do_it

#onrt	;right
	move	@p2pins,a0
	addk	1,a0
	move	a0,@p2pins
	movi	[399+101,0],a0
	movi	[399+50,0],b6
	movi	400,a10
	movi	DPLT_R_P,b0
	movi	-5,a11

#do_it
	mmtm	sp,a0,a1
	calla	BEGINOBJP
	mmfm	sp,a0,a1
	move	a8,*a9,L

	movi	1810h,a3
	move	b6,a0
	movi	PINHIM09,a2
	calla	BEGINOBJ
	move	a8,*a9(32),L

	move	a11,a0

#zin
	move	*a9,a8,L
	move	*a8(OXPOS),a11,W
	cmp	a10,a11
	jrz	#zin_done
	add	a0,a11
	move	a11,*a8(OXPOS),W
	move	*a9(32),a8,L
	move	*a8(OXPOS),a11,W
	add	a0,a11
	move	a11,*a8(OXPOS),W
	PUSHP	a0
	SLEEPK	1
	PULLP	a0
	jruc	#zin

#zin_done

	PUSHP	a0
	CREATE	PINHIM_ANIM_PID,#flash_pin_txt

	PUSHP	a0
	SLEEP	TSEC*2
	PULLP	a0
	calla	KILL
	PULLP	a0

#zout
	move	*a9,a8,L
	move	*a8(OXPOS),a11,W
	cmpi	-107,a11
	jrlt	#zout_done
	cmpi	500,a11
	jrgt	#zout_done
	sub	a0,a11
	move	a11,*a8(OXPOS),W
	move	*a9(32),a8,L
	move	*a8(OXPOS),a11,W
	sub	a0,a11
	move	a11,*a8(OXPOS),W
	PUSHP	a0
	SLEEPK	1
	PULLP	a0
	jruc	#zout

#zout_done
	move	*a9,a0,L
	calla	DELOBJ
	move	*a9(32),a0,L
	calla	DELOBJ

#die	DIE


#flash_pin_txt

	.ref	setup_back_anim
	.ref	ANIM_CROWD
		  
	move	*a9(32),a8,L
	movk	5,a9

#lpa	PUSHP	a9
	.ref	PIN_FLASH_ANIM
	movi	PIN_FLASH_ANIM,a1
	calla	setup_back_anim

	JSRP	ANIM_CROWD

	PULLP	a9
	dsj	a9,#lpa

	DIE


***********************************************************
#*
;A8 = player side (0,1)
 SUBRP	no_block_powerup_check
#lp
	;no no-block allowed if royal rumble.
	move	@royal_rumble,a14
	jrnz	#die

	clr	a11
	PUPWAITSWITCH	BLOCK,#lp

	movi	TSEC*2,a11
	PUPWAITSWITCH	BLOCK,#lp
	PUPWAITSWITCH	BLOCK,#lp

	sll	5,a8
	addi	p1powerup_request,a8

	move	*a8,a9,L
	ori	BLOCKING_OFF,a9
	move	a9,*a8,L

#die	DIE

***********************************************************
#*
;A8 = player side (0,1)
 SUBRP	move_names_powerup_check
#lp
	clr	a11
	PUPWAITSWITCH	PUNCH,#lp

	movi	TSEC*2,a11
	PUPWAITSWITCH	PUNCH,#lp
	PUPWAITSWITCH	PUNCH,#lp
	PUPWAITSWITCH	PUNCH,#lp

	sll	5,a8
	addi	p1powerup_request,a8

	move	*a8,a9,L
	ori	MOVE_NAMES_ON,a9
	move	a9,*a8,L

	DIE



***********************************************************
#*
;A8 = player side (0,1)
 SUBRP	drone_meters_powerup_check

	;only in one-player games
	move	@PSTATUS,a11
	cmpi	3,a11
	jrz	#onep_only

	;only in one-on-one games
	move	@NUM_OPPS,a14
	dec	a14
	jrnz	#onep_only
#lp


;	clr	a11
;	PUPWAITSWITCH	KICK,#lp
;			     
;	movi	TSEC*2,a11
;	PUPWAITSWITCH	KICK,#lp
;	PUPWAITSWITCH	KICK,#lp

	sll	5,a8
	addi	p1powerup_request,a8

	move	*a8,a9,L
	ori	D_METERS_ON,a9
	move	a9,*a8,L
	move	a9,@drone_meters_on

#onep_only
	DIE


***********************************************************
#*
;A8 = player side (0,1)
 SUBRP	hyper_match_powerup_check
#lp
	clr	a11
	PUPWAITSWITCH	LEFT,#lp

	movi	TSEC*2,a11
	PUPWAITSWITCH	PUNCH,#lp
	PUPWAITSWITCH	PUNCH,#lp
	PUPWAITSWITCH	BLOCK,#lp

	sll	5,a8
	addi	p1powerup_request,a8

	move	*a8,a9,L
	ori	HYPER_MATCH_ON,a9	; Disabled for now
	move	a9,*a8,L

	DIE


***********************************************************
#*
;A8 = player side (0,1)
 SUBRP	combos_powerup_check
#lp
	clr	a11
	PUPWAITSWITCH	RIGHT,#lp

	movi	TSEC*2,a11
	PUPWAITSWITCH	PUNCH,#lp
	PUPWAITSWITCH	SUPERP,#lp

	sll	5,a8
	addi	p1powerup_request,a8

	move	*a8,a9,L
	ori	COMBOS_ON,a9
	move	a9,*a8,L

	DIE


***********************************************************
#*
;A8 = player side (0,1)
 SUBRP	ring_out_powerup_check
#lp
	clr	a11
	PUPWAITSWITCH	DOWN,#lp

	movi	TSEC*2,a11
	PUPWAITSWITCH	PUNCH,#lp
	PUPWAITSWITCH	KICK,#lp
	PUPWAITSWITCH	BLOCK,#lp

	sll	5,a8
	addi	p1powerup_request,a8

	move	*a8,a9,L
	ori	RING_OUTS_ON,a9
	move	a9,*a8,L

	DIE


***********************************************************
#*
;A8 = player side (0,1)
 SUBRP	no_ring_powerup_check
#lp
	clr	a11
	PUPWAITSWITCH	UP,#lp

	movi	TSEC*2,a11
	PUPWAITSWITCH	RIGHT,#lp
	PUPWAITSWITCH	DOWN,#lp
	PUPWAITSWITCH	LEFT,#lp

	sll	5,a8
	addi	p1powerup_request,a8

	move	*a8,a9,L
	ori	NO_RING,a9
	move	a9,*a8,L

	DIE


***********************************************************
#*
;A8 = player side (0,1)

	BSSX	buddy_mode_checked,16

 SUBRP	buddy_mode_powerup_check

#lp	;no buddy mode allowed if royal rumble.
	move	@royal_rumble,a14
	jrnz	#die

	;clear the too late flag
	clr	a14
	move	a14,@buddy_mode_checked

	clr	a11
	PUPWAITSWITCH	BLOCK,#lp

	movi	TSEC*2,a11
	PUPWAITSWITCH	BLOCK,#lp
	PUPWAITSWITCH	BLOCK,#lp
	PUPWAITSWITCH	BLOCK,#lp
	PUPWAITSWITCH	BLOCK,#lp

	;too late?
	move	@buddy_mode_checked,a14
	jrnz	#die

	sll	5,a8
	addi	p1powerup_request,a8

	move	*a8,a9,L
	ori	BUDDY_MODE,a9
	move	a9,*a8,L

#die	DIE


***********************************************************
#*
;A8 = player side (0,1)
 SUBRP	player_powerup_checker

	CREATE	PU_CHECK_PID,no_block_powerup_check
	CREATE	PU_CHECK_PID,move_names_powerup_check
	CREATE	PU_CHECK_PID,drone_meters_powerup_check
;	CREATE	PU_CHECK_PID,no_ring_powerup_check	; Disable until we get blimp module
	CREATE	PU_CHECK_PID,hyper_match_powerup_check
	CREATE	PU_CHECK_PID,combos_powerup_check
	CREATE	PU_CHECK_PID,ring_out_powerup_check
	CREATE	PU_CHECK_PID,buddy_mode_powerup_check

	DIE


***********************************************************
#*
 SUBR	powerup_check

	move	@do_show_options,a14
	jrz	#powerup_check_die

	clr	a8
	move	a8,@p1powerup_request,L
	move	a8,@p2powerup_request,L

	move	a8,@blocking_off
	move	a8,@ring_out_on
	move	a8,@move_names_on
	move	a8,@drone_meters_on
	move	a8,@instant_combos_on
	move	a8,@hyper_speed_on
	move	a8,@no_ring_on

	.if POWERUP_CODE_ON

	CREATE	PU_CHECK_PID,player_powerup_checker

	movk	1,a8
	CREATE	PU_CHECK_PID,player_powerup_checker

#powerup_check_die
	.endif

	DIE


***********************************************************
#*
 SUBR	get_powerups
	move	@p1powerup_request,a9,L		; Player 1 powerups
	move	@p2powerup_request,a10,L	; Player 2 powerups
	move	a10,a11				; Save Player 2 powerups
	and	a9,a11				; Get h/h only powerups
	andi	BOTH_P_MASK,a11
	andni	BOTH_P_MASK,a9
	andni	BOTH_P_MASK,a10
	or	a11,a9
	or	a11,a10
	move	a9,@p1powerup_request,L
	move	a10,@p2powerup_request,L
	or	a9,a10
;Both players must select these
	move	a9,a8
	andi	BLOCKING_OFF,a8
	jrz	#blocking_on
	movi	2020h,a8
	jruc	#set_blocking
#blocking_on
	clr	a8
#set_blocking
	move	a8,@blocking_off

	move	a9,a8
	andi	COMBOS_ON,a8
	move	a8,@instant_combos_on

	move	a9,a8
	andi	RING_OUTS_ON,a8
	move	a8,@ring_out_on

	move	a9,a8
	andi	NO_RING,a8
	move	a8,@no_ring_on

	;this one is done earlier in the wrestle code!
;	move	a9,a8
;	andi	BUDDY_MODE,a8
;	move	a8,@buddy_mode_on

	move	a9,a8
	andi	HYPER_MATCH_ON,a8
	jrz	#hyper_off
	movi	1,a8
	jruc	#set_hyper
#hyper_off
	clr	a8
#set_hyper
	move	a8,@hyper_speed_on

;Either player can select these
	move	a10,a8
	andi	D_METERS_ON,a8
	move	a8,@drone_meters_on

	rets



***********************************************************
#*
 SUBR	show_options
	.if POWERUP_CODE_ON

	move	@do_show_options,a9
	jrnz	#ok_to_show_options
	DIE
#ok_to_show_options
	callr	get_powerups

	clr	a8
	move	a8,@show_options_die

	CREATE0	show_player_options

	movk	1,a8
	CREATE0	show_player_options

;Make sure combo meter starts flashing!
	.ref	SET_FLASHING

	move	@instant_combos_on,a14
	jrz	#no

	clr	a10
	calla	SET_FLASHING
	movk	1,a10
	calla	SET_FLASHING
#no

	SLEEP	TSEC

	movi	TSEC*2,a9
#show_opt_wait
	SLEEPK	1
	calla	get_all_buttons_cur
	jrnz	#show_opt_done
	dsjs	a9,#show_opt_wait
#show_opt_done
	movk	1,a8
	move	a8,@show_options_die

	movi	RPUBAROID,a0
	calla	obj_del1c
	movi	LPUBAROID,a0
	calla	obj_del1c

	clr	a8
	move	a8,@do_show_options

	.endif
	DIE


***********************************************************
#*
 SUBRP	pu_bar_text
	.long	NOBLOCKA	; Blocking off
	.long	INSTCOMB	; Combos on
	.long	RINGOUT		; Ring outs on
	.long	SANSRING	; No Ring
	.long	MOVNAMES	; Move names off
	.long	DRONMETR	; Drone meters off
	.long	HYPERSPD	; Hyper match on
	.long	BUDDY		; Buddy mode on


***********************************************************
#*
 SUBRP	move_pu_bars_on
	PUSHP	a8,a9,a10,a11

	movi	PU_LEND_X,a11		; Amount we gonna move em

	movi	LPUBAROID,a9		; Player 1 pu bar objects
	movk	PU_BAR_VELOCITY,a10	; Player 1 bar velocity
	move	a8,a8			; Are we player 1?
	jrz	#p1_pu_bars		; br = yes
	movi	RPUBAROID,a9		; Player 2 pu bar objects
	neg	a10			; Player 2 bar velocity
#p1_pu_bars
	movi	OBJLST,a14		; Top of object list
#move_lp
	move	*a14,a14,L		; Get object pointer
	jrz	#list_end		; List end? - br = yes
	move	*a14(OID),a1		; Get object ID
	cmp	a9,a1			; Is this one I'm a lookin fer
	jrnz	#move_lp

	move	*a14(OXPOS),a1		; Get current X position
	add	a10,a1			; Add velocity
	move	a1,*a14(OXPOS)		; Write it back
	jruc	#move_lp		; Go chck next

#list_end
	SLEEPK	1			; Show em

	subk	PU_BAR_VELOCITY,a11	; Are we done?
	jrnz	#p1_pu_bars		; br = no

	PULLP	a8,a9,a10,a11
	RETP



***********************************************************
#*
;a8 = player number
 SUBRP	show_player_options
	move	@PSTATUS,a9
	btst	a8,a9
	jrz	#spo_die

fini_wait
	move	@in_finish_move,a14	; Are we doing a finishing move ?
	jrz	fini_done		; br = no
	SLEEPK	10
	jruc	fini_wait
fini_done

	movi	[PU_START_Y,0],a11

	move	a8,a9
	sll	5,a9
	addi	p1powerup_request,a9
	move	*a9,a9,L

	movk	(NUM_POWERUPS-1),a10
#pu_request
	btst	a10,a9
	jrz	#no_pu

	clr	a0
	movi	DPLT_B_P,b0
	move	a8,a8
	jrz	#p1_xpos
	movi	DPLT_R_P,b0
	movi	[399,0],a0
#p1_xpos
	move	a11,a1
	movi	BONUSBAR,a2
	movi	1800h,a3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4
	move	a8,a8
	jrnz	#no_hflip
	ori	M_FLIPH,a4
#no_hflip
	movi	LPUBAROID,a5
	move	a8,a8
	jrz	#p1_boid
	movi	RPUBAROID,a5
#p1_boid
	clr	a6
	clr	a7
	PUSH	a8
	calla	BEGINOBJP
	PULL	a8

	movi	[PU_LTEXT_XPOS,0],a0
	move	a8,a8
	jrz	#lpu_p1_text
	movi	[PU_RTEXT_XPOS,0],a0
#lpu_p1_text
	move	a11,a1
	move	a10,a2
	sll	5,a2
	addi	pu_bar_text,a2
	move	*a2,a2,L
	movi	1810h,a3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4
	movi	LPUBAROID,a5
	move	a8,a8
	jrz	#p1_toid
	movi	RPUBAROID,a5
#p1_toid
	clr	a6
	clr	a7
	movi	WINFONT,b0
	PUSH	a8
	calla	BEGINOBJP
	PULL	a8
	
	addi	[PU_BAR_YSPACE,0],a11
#no_pu
	subk	1,a10
	jrnn	#pu_request

	JSRP	move_pu_bars_on

#wait_die
	SLEEPK	1
	move	@show_options_die,a14
	jrz	#wait_die

#spo_die
	DIE

**********************************************************************
#*

MYOBJ_REC_SIZE	.equ	(16*11)
SIZEOF_JAM_STR	.equ	(16*10)

MYOBJECT	.macro	x,y,z,img,ctrl,id,xv,yv
	.word	:x:,:y:,:z:
	.long	:img:
	.word	:ctrl:,:id:
	.long	:xv:,:yv:
	.endm

 SUBRP	BLACKOUT
	.word	400,256,0,0
	.long	2000000h
	.word	04000h
	.even

	.ref	ogmd10_ascii
	.ref	wsf14_ascii
	.ref	print_string_C2
	.ref	RNDRNG0
	.ref	setup_message
	.ref	mess_objid
	.ref	WSF_W_P

 SUBRP	#mk3_tip_prompt1
	JAM_STR	wsf14_ascii,10,0,200,30,WSF_R_P,print_string_C2
	.string	"CONGRATULATIONS!!!",0
	.even
 SUBRP	#mk3_tip_prompt2
	JAM_STR	ogmd10_ascii,10,0,200,70,SGMD8GLD,print_string_C2
	.string "YOU'VE ACHIEVED A LEVEL OF",0
	.even
 SUBRP	#mk3_tip_prompt4
	JAM_STR	ogmd10_ascii,10,0,200,85,SGMD8GLD,print_string_C2
	.string "PERFORMANCE THAT ENTITLES YOU",0
	.even
 SUBRP	#mk3_tip_prompt5
	JAM_STR	ogmd10_ascii,10,0,200,100,SGMD8GLD,print_string_C2
	.string "TO A TIP FOR MORTAL KOMBAT 3",0
	.even

 SUBRP	#mk3_tip1_str1
	JAM_STR	ogmd10_ascii,10,0,200,130,SGMD8BLU,print_string_C2
; Compressed string "FOR TWO PLAYER GAMES, USE THE"
	.byte	027h,03ch,007h,035h,00eh,007h,071h,02bh
	.byte	0eah,0e6h,01ch,0a0h,0a2h,06bh,0d2h,04dh
	.byte	060h,0d3h,066h,050h,0a7h,026h,000h
	.even
 SUBRP	#mk3_tip1_str2
	JAM_STR	ogmd10_ascii,10,0,200,145,SGMD8BLU,print_string_C2
; Compressed string "FOLLOWING CODE TO ENABLE A"
	.byte	027h,0dch,0b6h,030h,0aeh,0beh,068h,040h
	.byte	0c2h,0a5h,019h,0d4h,070h,060h,0beh,0e2h
	.byte	0d8h,09ah,081h,008h,000h
	.even
 SUBRP	#mk3_tip1_str3
	JAM_STR	ogmd10_ascii,10,0,200,160,SGMD8BLU,print_string_C2
; Compressed string "SPECIAL FEATURE."
	.byte	074h,06ch,092h,0aah,0d8h,006h,0a7h,029h
	.byte	0d6h,0f6h,06ch,03eh,000h
	.even


 SUBRP	#mk3_tip2_str1
	JAM_STR	ogmd10_ascii,10,0,200,130,SGMD8BLU,print_string_C2
; Compressed string "IN TWO PLAYER GAMES, ENTER"
	.byte	0eah,01bh,0d4h,038h,01ch,0c4h,0adh,0a8h
	.byte	09bh,073h,080h,08ah,0aeh,049h,037h,081h
	.byte	0f9h,0d6h,0e6h,00ch,000h
	.even
 SUBRP	#mk3_tip2_str2
	JAM_STR	ogmd10_ascii,10,0,200,145,SGMD8BLU,print_string_C2
; Compressed string "THE CODE BELOW TO TURN ON A"
	.byte	075h,06ah,006h,024h,05ch,09ah,0c1h,068h
	.byte	0b6h,030h,01eh,0d4h,070h,050h,0dbh,0f3h
	.byte	01bh,0c0h,06fh,020h,002h
	.even
 SUBRP	#mk3_tip2_str3
	JAM_STR	ogmd10_ascii,10,0,200,160,SGMD8BLU,print_string_C2
; Compressed string "HIDDEN FEATURE."
	.byte	0a9h,05ah,096h,0e6h,01bh,09ch,0a6h,058h
	.byte	0dbh,0b3h,0f9h,000h
	.even



 SUBRP	#mk_code1_1
	.word	127+2+(24*0),179,4010h	;x,y,z
	.long	I_GORO	;Image
	.word	DMAWNZ|M_3D|M_SCRNREL
	.word	CLSMK3
	.long	0,0
 SUBRP	#mk_code1_2
	.word	127+2+(24*1),179,4010h	;x,y,z
	.long	I_SHOKAHN		;Image
	.word	DMAWNZ|M_3D|M_SCRNREL
	.word	CLSMK3
	.long	0,0
 SUBRP	#mk_code1_3
	.word	127+2+(24*2),179,4010h	;x,y,z
	.long	I_SHOKAHN	;Image
	.word	DMAWNZ|M_3D|M_SCRNREL
	.word	CLSMK3
	.long	0,0
 SUBRP	#mk_code1_4
	.word	127+2+(24*3),179,4010h	;x,y,z
	.long	I_QUESTION	;Image
	.word	DMAWNZ|M_3D|M_SCRNREL
	.word	CLSMK3
	.long	0,0
 SUBRP	#mk_code1_5
	.word	127+2+(24*4),179,4010h	;x,y,z
	.long	I_YINYANG	;Image
	.word	DMAWNZ|M_3D|M_SCRNREL
	.word	CLSMK3
	.long	0,0
 SUBRP	#mk_code1_6
	.word	127+2+(24*5),179,4010h	;x,y,z
	.long	I_YINYANG	;Image
	.word	DMAWNZ|M_3D|M_SCRNREL
	.word	CLSMK3
	.long	0,0



 SUBRP	#mk_code2_1
	.word	127+2+(24*0),179,4010h	;x,y,z
	.long	I_QUESTION	;Image
	.word	DMAWNZ|M_3D|M_SCRNREL
	.word	CLSMK3
	.long	0,0
 SUBRP	#mk_code2_2
	.word	127+2+(24*1),179,4010h	;x,y,z
	.long	I_GORO		;Image
	.word	DMAWNZ|M_3D|M_SCRNREL
	.word	CLSMK3
	.long	0,0
 SUBRP	#mk_code2_3
	.word	127+2+(24*2),179,4010h	;x,y,z
	.long	I_GORO		;Image
	.word	DMAWNZ|M_3D|M_SCRNREL
	.word	CLSMK3
	.long	0,0
 SUBRP	#mk_code2_4
	.word	127+2+(24*3),179,4010h	;x,y,z
	.long	I_QUESTION	;Image
	.word	DMAWNZ|M_3D|M_SCRNREL
	.word	CLSMK3
	.long	0,0
 SUBRP	#mk_code2_5
	.word	127+2+(24*4),179,4010h	;x,y,z
	.long	I_GORO		;Image
	.word	DMAWNZ|M_3D|M_SCRNREL
	.word	CLSMK3
	.long	0,0
 SUBRP	#mk_code2_6
	.word	127+2+(24*5),179,4010h	;x,y,z
	.long	I_GORO		;Image
	.word	DMAWNZ|M_3D|M_SCRNREL
	.word	CLSMK3
	.long	0,0

 SUBRP	#mk_code_frame
	.word	127,177,4000h	;x,y,z
	.long	BOX2		;Image
	.word	DMAWNZ|M_3D|M_SCRNREL
	.word	CLSMK3
	.long	0,0

 SUBRP	#mk_code_tbl1
	.long	#mk_code1_1
	.long	#mk_code1_2
	.long	#mk_code1_3
	.long	#mk_code1_4
	.long	#mk_code1_5
	.long	#mk_code1_6
	.long	#mk_code_frame
	.long	0

 SUBRP	#mk_code_tbl2
	.long	#mk_code2_1
	.long	#mk_code2_2
	.long	#mk_code2_3
	.long	#mk_code2_4
	.long	#mk_code2_5
	.long	#mk_code2_6
	.long	#mk_code_frame
	.long	0

 SUBRP	#mk3_tip1_str_tbl
	.long	#mk3_tip1_str1
	.long	#mk3_tip1_str2
	.long	#mk3_tip1_str3
	.long	0
	.long	#mk_code_tbl1
	
 SUBRP	#mk3_tip2_str_tbl
	.long	#mk3_tip2_str1
	.long	#mk3_tip2_str2
	.long	#mk3_tip2_str3
	.long	0
	.long	#mk_code_tbl2


 SUBRP	#mk3_tip_str_tbl
	.long	#mk3_tip1_str_tbl
	.long	#mk3_tip2_str_tbl

 SUBRP	#mk3_tip_prompt_str_tbl
	.long	#mk3_tip_prompt1
	.long	#mk3_tip_prompt2
	.long	#mk3_tip_prompt4
	.long	#mk3_tip_prompt5
	.long	0

	.bss	resume,16

 SUBRP	suspend_game
#lp
	move	@resume,a10
	jrnz	#ok_to_resume
	SLEEPK	1
	callr	suspend_all
	jruc	#lp
#ok_to_resume
	DIE

 SUBRP	mk3_coin
	.long	MKCOIN_01
	.long	MKCOIN_02
	.long	MKCOIN_03
	.long	MKCOIN_04
	.long	MKCOIN_05
	.long	MKCOIN_06
	.long	MKCOIN_07
	.long	MKCOIN_08
	.long	MKCOIN_09
	.long	0

 SUBRP	mk3_smoke
	.long	MKLIGHT1
	.long	MKLIGHT2
	.long	MKLIGHT3
	.long	MKLIGHT4
	.long	MKLIGHT5
	.long	MKLIGHT6
	.long	MKLIGHT7
	.long	MKLIGHT8
	.long	MKLIGHT9
	.long	MKLIGHT10
	.long	MKLIGHT11
	.long	MKLIGHT12
	.long	MKLIGHT13
	.long	MKLIGHT14
	.long	MKLIGHT15
	.long	MKLIGHT16
	.long	MKLIGHT17
	.long	MKLIGHT18
	.long	MKLIGHT19
	.long	MKLIGHT20
	.long	0

	.ref	obj_aniq

;a11 = [xpos,ypos]
;a10 = *img tbl
;a8  = flip/noflip
 SUBRP	anim_mk
	move	a10,a9
	move	a11,a1
	sll	16,a1

	srl	16,a11
	sll	16,a11
	move	a11,a0
	move	*a9+,a2,L
	movi	4000h,a3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4
	move	a8,a8
	jrz	#no_flip
	ori	M_FLIPH,a4
#no_flip
	movi	CLSMK3,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ
#mk_anim_lp
	SLEEPK	5
	move	*a9+,a0,L
	jrnz	#do_mka
	move	a10,a9
	move	*a9+,a0,L
#do_mka
	move	*a8(OCTRL),a1
	calla	obj_aniq
	jruc	#mk_anim_lp
	DIE


 SUBR	show_mk3_tip

;Disabled until we get real tips from end

	clr	a0			; Make everyone wait
	move	a0,@resume
	CREATE	4000h,suspend_game
	SLEEPK	1

	calla	pal_clean
	clr	a10
	movk	16,a11
	CREATE	FADE_PID|4000h,fade_down
	SLEEPK	32
	.if MKDEBUG
	clr	a0
	move	a0,@mk3_tip_number
	.endif

	.ref	display_blank
	.if MKDEBUG
#reenter
	.endif
	calla	display_blank

	clr	a0
	clr	a1
	movi	BLACKOUT,a2
	movi	3ff0h,a3
	movi	DMACNZ|DMACZ|M_3D|M_SCRNREL,a4
	movi	CLSMK3,a5
	clr	a6
	clr	a7
	movi	DPLT_R_P,b0
	calla	BEGINOBJP
	clr	a0
	move	a0,*a8(OCONST)

	movi	[200,0],a0
	movi	[254,0],a1
	movi	TRADEMARK,a2
	movi	4000h,a3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4
	movi	CLSMK3,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ

	SLEEPK	1

	clr	a8
	movi	[25,205],a11
	movi	mk3_coin,a10
	CREATE	4001h,anim_mk

	clr	a8
	movi	[101,205],a11
	movi	mk3_coin,a10
	CREATE	4001h,anim_mk

	clr	a8
	movi	[178,205],a11
	movi	mk3_coin,a10
	CREATE	4001h,anim_mk

	clr	a8
	movi	[254,205],a11
	movi	mk3_coin,a10
	CREATE	4001h,anim_mk

	clr	a8
	movi	[331,205],a11
	movi	mk3_coin,a10
	CREATE	4001h,anim_mk

	clr	a8
	movi	[0,1],a11
	movi	mk3_smoke,a10
	CREATE	4001h,anim_mk

	movk	1,a8
	movi	[399,1],a11
	movi	mk3_smoke,a10
	CREATE	4001h,anim_mk

	SLEEPK	1

	movi	#mk3_tip_prompt_str_tbl,a9
#mk3_tp_loop
	move	*a9+,a2,L
	jrz	#mk3_tp_done
	move	a2,a10
	calla	setup_message
	movi	CLSMK3,a0
	move	a0,@mess_objid
	addi	SIZEOF_JAM_STR,a10
	move	a10,a4
	calla	print_string_C2
	jruc	#mk3_tp_loop

#mk3_tp_done
	movk	1,a0			; Get a random tip to show
	calla	RNDRNG0
	.if MKDEBUG
	move	@mk3_tip_number,a0
	.endif
	sll	5,a0
	addi	#mk3_tip_str_tbl,a0
	move	*a0,a9,L		; a9 = *str table

#mk3_t_loop
	move	*a9+,a2,L
	jrz	#mk3_tip_done
	move	a2,a10
	calla	setup_message
	movi	CLSMK3,a0
	move	a0,@mess_objid
	addi	SIZEOF_JAM_STR,a10
	move	a10,a0
	callr	decompress_string
	.ref	message_buffer

	movi	message_buffer,a4
	calla	print_string_C2
	SLEEPK	15
	jruc	#mk3_t_loop
	
#mk3_tip_done
	move	*a9,a2,L
	jrz	#no_code
	move	a2,a9
#mk3_c_loop
	move	*a9+,a0,L
	jrz	#code_done
	calla	BEGINOBJ_TBL
	jruc	#mk3_c_loop
#code_done
	CREATE	4001h,sparkle_frame

#no_code
	.ref	display_unblank
	calla	display_unblank
	.ref	SNDSND
	movk	16,a3
	calla	SNDSND


	.if MKDEBUG
	movi	TSEC*120,a9
	.else
	SLEEP	TSEC*2			; Minimum amount of time to display it

	movi	TSEC*8,a9
	.endif
#delay_loop				; Now wait on a button
	SLEEPK	1
	calla	get_all_buttons_cur
	jrnz	#mk3t_exit
	dsjs	a9,#delay_loop

#mk3t_exit
	movi	4001h,a0
	calla	KIL1C

	movi	CLSMK3,a0
	calla	obj_del1c

	SLEEPK	10			; Let em all die off

	.if MKDEBUG
	move	@mk3_tip_number,a14
	addk	1,a14
	andi	1,a14
	move	a14,@mk3_tip_number
	jruc	#reenter
	.endif
	clr	a10
	movk	16,a11
	CREATE	4000h|FADE_PID,fade_up
	SLEEPK	31
	movk	1,a0			; Set ok to resume game
	move	a0,@resume

	DIE


sparkle_img
	.long	SPRKLA01
	.long	SPRKLA02
	.long	SPRKLA03
	.long	SPRKLA04
	.long	SPRKLA05
	.long	SPRKLA06
	.long	SPRKLA07
	.long	SPRKLA08
	.long	SPRKLA09
	.long	SPRKLA10
	.long	SPRKLA11
	.long	SPRKLA12
	.long	SPRKLA13
	.long	0

; A9 = [x,y]
 SUBRP	anim_sparkle

	movi	sparkle_img,a10

	move	a9,a0
	srl	16,a0
	sll	16,a0

	move	a9,a1
	sll	16,a1
	
	move	*a10+,a2,L
	movi	4020h,a3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4
	movi	CLSMK3+10,a5
	clr	a6
	clr	a7
	movi	SPARKL_P,b0
	calla	BEGINOBJP

spa_loop
	SLEEPK	3
	move	*a10+,a0,L
	jrz	sp_exit
	move	*a8(OCTRL),a1
	calla	obj_aniq
	move	*a8(OXPOS),a1
	addk	2,a1
	move	a1,*a8(OXPOS)
	jruc	spa_loop
sp_exit
	calla	DELOBJA8
	DIE


 SUBRP	sparkle_frame

	movi	121,a0			; Get a random x starting position
	calla	RNDRNG0
	move	a0,a9

	movk	1,a0			; Get a random top/bottom
	calla	RNDRNG0

	sll	16,a9			; Set X position
	move	a0,a0			; top or bottom of frame ?
	jrz	#top			; br = top
	ori	19,a9			; Set bottom
#top
	addi	[127,177],a9		; Adjust for frame position
	CREATE	4000h,anim_sparkle	; Animate a frame sparkle

	movi	TSEC,a0			; Random Sleep before creating next sparkle
	calla	RNDRNG0
	addi	TSEC,a0			; Minimum of 1 second between sparkles
	calla	PRCSLP
	jruc	sparkle_frame
	
	DIE

;
; A0 = *compressed string
;
 SUBR	decompress_string
	PUSH	a1,a2
	movi	message_buffer,a1,L
	pushst			; Save status
	dint			; No interrupts during this
	setf	6,0,0		; Field size = 6
#decompress_loop
	move	*a0+,a2
	jrz	#decompress_done
	addi	01fh,a2
	movb	a2,*a1
	addk	8,a1
	jruc	#decompress_loop
#decompress_done
	popst
	clr	a0
	movb	a0,*a1
	PULL	a1,a2
	rets

	.if 0

hello_prompt
	JAM_STR	ogmd10_ascii,10,0,200,80,SGMD8GLD,print_string_C2
	.string	"HELLO GAME DESIGNER!!!"
	.byte	0,1
	.even
hello_prompt1
	JAM_STR	ogmd10_ascii,10,0,200,110,SGMD8GLD,print_string_C2
	.string	"MIDWAY GAME DESIGNERS"
	.byte	0,1
	.even
hello_prompt2
	JAM_STR	ogmd10_ascii,10,0,200,125,SGMD8GLD,print_string_C2
	.string	"ARE THE WORLD'S BEST"
	.byte	0,1
	.even
hello_prompt3
	JAM_STR	ogmd10_ascii,10,0,200,140,SGMD8GLD,print_string_C2
	.string	"GAME DESIGNERS!!!!!"
	.byte	0,0
	.even


 SUBRP	hi_programmer
	clr	a0			; Make everyone wait
	move	a0,@resume
	CREATE	4000h,suspend_game
	SLEEPK	1

	calla	pal_clean
	clr	a10
	movk	16,a11
	CREATE	FADE_PID|4000h,fade_down
	SLEEPK	32

	.ref	print_message

	movi	hello_prompt,a2
	calla	print_message
	movi	hello_prompt1,a2
	calla	print_message
	movi	hello_prompt2,a2
	calla	print_message
	movi	hello_prompt3,a2
	calla	print_message

	DIE


 SUBR	prog_specials

	calla	get_all_buttons_cur
	jrz	#no_prog
	cmpi	B_PUNCH|B_SPUNCH|B_KICK|B_SKICK,a0
	jrnz	#no_prog

	move	*a13(PROCID),a2
	ori	4000h,a2
	move	a2,*a13(PROCID)

	CREATE	4000h,hi_programmer
	SLEEP	TSEC
	movi	TSEC*5,a2
#wait_loop
	PUSHP	a2
	SLEEPK	1
	PULLP	a2
	calla	get_all_buttons_cur
	jrnz	#ps_exit
	dsjs	a2,#wait_loop
#ps_exit
	movk	1,a0			; Set ok to resume game
	move	a0,@resume

	move	*a13(PROCID),a2
	andni	4000h,a2
	move	a2,*a13(PROCID)

	clr	a10
	movk	16,a11
	CREATE	FADE_PID,fade_up
	SLEEPK	31
#no_prog
	RETP


#si_table
	.long	0006864bh		; MARK
	.long	00a0cdeeh		; JASON
	.long	00050565h		; JAKE
	.long	0006a565h		; MIKE
	.long	00053d0eh		; JOHN
	.long	000029e5h		; JOE
	.long	0001258ch		; BILL
	.long	013a16c5h		; STEVE
	.long	00004c2ch		; SAL
	.long	00053e68h		; JOSH
	.long	000395c5h		; GENE
	.long	013406eeh		; SHAWN
	.long	000000a4h		; ED
	.long	0072be47h		; GEORG
	.long	00525d2eh		; EDWIN
	.long	00d0c970h		; MARKP
	.long	000a3dd9h		; TONY
	.long	0

; A4 = *beginning of string
; A0 = character to add
;
; Returns
;   Z  - Special Inits
;   NZ - Not Special Inits
;
 SUBR	are_special_inits
	PUSH	a0,a1,a2,a4,a5,a6
	move	a4,a6
	subk	8,a6
#recheck1
	addk	8,a6
	move	a6,a4
	movb	*a6,a2
	jrz	#not_special_inits1
	clr	a1
#get_inits_loop1
	movb	*a4,a2
	jrz	#recheck1
	cmpi	20h,a2
	jrz	#not_alpha1
	cmpi	21h,a2
	jrz	#not_alpha1
	cmpi	19h,a2
	jrz	#not_alpha1
	sll	5,a1
	subi	40h,a2
	andi	1fh,a2
	or	a2,a1
	callr	#check_it1
#not_alpha1
	addk	8,a4
	jruc	#get_inits_loop1
#gi_done1

#check_it1
	PUSH	a4
	movi	#si_table,a4
	clr	a0
#check_dw_loop1
	move	*a4+,a5,L
	jrz	#check_done1
	cmp	a1,a5
	jrz	#is_special
	jruc	#check_dw_loop1
#check_done1
	PULL	a4
	rets

#is_special
	PULL	a4,a14			; This sucks don't change this
	movk	1,a0			; or it will break
	jruc	#aid_exit1
#not_special_inits1
	clr	a0
#aid_exit1
	move	a0,a0
	PULL	a0,a1,a2,a4,a5,a6
	rets

	.endif



******************************************************************************

	.end
