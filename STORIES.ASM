**************************************************************
*
* Software:	Mike Lynch
* Initiated:	04/16/95
*
* Modified:
*
* COPYRIGHT (C) 1995 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"stories.asm"
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

	.include	"imgtbl.glo"
	.include	"fontsimg.glo"
	.include	"bgndtbl.glo"
	.include	"miscimg.glo"
	.include	"logo.glo"

	.include	"bamst.h"
	.include	"bretst.h"
	.include	"doinkst.h"
;	.include	"yokost1.h"
;	.include	"yokost2.h"
;	.include	"yokost3.h"
;	.include	"yokost4.h"
	.include	"yokost.h"
	.include	"lexst.h"
	.include	"razorst.h"
	.include	"takerst.h"
	.include	"shawnst.h"

	.ref	p1oldwinstreak,p2oldwinstreak,print_string,ogmd10_ascii
	.ref	SGMD8GLD,setup_message,message_buffer
	.ref	BAKMODS,decompress_string,BGND_UD1,WIPEOUT,dpageflip
	.ref	wrestler_mugs,obj_del1c,mess_objid,scrn_rel_off,pal_clean
	.ref	fade_down,get_but_val_cur,which_player,PSTATUS,mess_cursy
	.ref	osgmd8_ascii

	BSSX	wrestler_number,32

blank_line
	.byte	0
	.even

	.globl	story_bgnd
story_bgnd
	.long	endstoryBMOD
	.word	0,0
	.long	0

; These need to be in the same order as the wrestler numbers
#wrestler_stories_table
	.long	bret_stories		; Bret Hart
	.long	razor_stories		; Razor Ramon
	.long	taker_stories		; The Undertaker
	.long	yoko_stories		; Yokozuna
	.long	shawn_stories		; Shawn Michaels
	.long	bam_stories		; Bam Bam Bigelow
	.long	doink_stories		; Doink The Clown
	.long	doink_stories		; Doink The Clown
	.long	lex_stories		; Lex Luger



#story_line1_setup
	JAM_STR	osgmd8_ascii,5,0,15,90,SGMD8GLD,print_string
	.even



;
; A1 = *wrestler story line table
;
 SUBR	print_story
	PUSHP	a0,a1,a2,a3,a4
#do_more_lines
	movi	90,a3
#print_story_loop
	move	*a1+,a0,L			; Get pointer to text line
	jrz	#print_story_done		; Last line ? br = yes
	calla	decompress_string		; Decompress string
	movi	#story_line1_setup,a2
	calla	setup_message			; Set it up
	move	a3,@mess_cursy
	movi	TYPWCCOUNT,a14
	move	a14,@mess_objid
	PUSHP	a1,a3
	calla	print_string			; Print it
	PULLP	a1,a3
	addi	12,a3
	cmpi	230,a3
	jrlt	#print_story_loop

	PUSHP	a0,a1
	SLEEP	TSEC*5				; Minimum time to display

	PUSHP	a9
;of real time.
;	movi	TSEC*60,a9			; Allow up to 1 minute per pg
	movi	TSEC*15,a9			; Allow up to 1 minute per pg
#w_loop
	SLEEPK	1
	clr	a0
	calla	get_but_val_cur
	move	a0,a0
	jrnz	#we_done
	movk	1,a0
	calla	get_but_val_cur
	move	a0,a0
	jrnz	#we_done
	dsjs	a9,#w_loop
#we_done
	PULLP	a9
	PULLP	a0,a1

	move	*a1,a0,L			; Are there more lines ?
	jrz	#print_story_done		; br = no - don't erase them

	movi	TYPWCCOUNT,a0
	PUSHP	a1
	calla	obj_del1c
	PULLP	a1
	jruc	#do_more_lines

	jruc	#print_story_loop		; Keep going
#print_story_done
	PULLP	a0,a1,a2,a3,a4

	SLEEPK	TSEC/2			; A little delay before we leave

	RETP




w_logos
	.long	HRT3
	.long	RZR3
	.long	UND3
	.long	YOK3
	.long	SHN3
	.long	BAM3
	.long	DNK3
	.long	0
	.long	LEX3

 SUBR	show_wrestler_end_story
;	RETP

	PUSHP	a0,a1,a2	; Save reggies

	move	@PSTATUS,a14	; Get which player won
	srl	1,a14		; Index into table
	sll	4,a14
	addi	which_player,a14
	move	*a14,a8		; Get winning wrestler number

	cmpi	7,a8		; Is this wrestler number 7 ?
	jrz	inval_wnum	; br = yes (not a valid wrestler number)

	calla	pal_clean	; Get rid of extra palettes

	clr	a10		; Fade down the lights
	movk	32,a11
	CREATE0	fade_down
	SLEEPK	30

	calla	WIPEOUT
	movk	1,a0		; Page flipping on
	move	a0,@dpageflip

	calla	pal_clean	; Get rid of extra palettes

	movi	story_bgnd,a0	; Setup background
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	move	a8,a10		; Restore the wrestler number

	; Create the wrestlers mugshot
	move	a10,a9		; Get wrestler number
	sll	5,a9		; Index into table
	addi	wrestler_mugs,a9
	move	*a9,a9,L	; Get pointer to mugshot image pieces
#mk_mug
	move	*a9+,a2,L	; Get pointer to image piece
	jrz	#mug_done	; Is that all of them ? - br = yes
	movi	[017ah,0],a0	; X position
	movi	[0Afh,0],a1	; Y position
	clr	a3		; Z position
	movi	DMAWNZ|M_FLIPH,a4
	movi	CLSMK3,a5	; Make it this class so's I kin delete it
	clr	a6		; No velocity
	clr	a7
	calla	BEGINOBJ	; Create the buger
	jruc	#mk_mug		; Get get next piece
#mug_done

	; And now his logo
	move	a10,a2		; Lookup the logo image fer this guy
	sll	5,a2
	addi	w_logos,a2
	move	*a2,a2,L	; Get the image pointer
	move	*a2(ISIZEX),a0	; Get image width
	srl	1,a0		; Divide it by 2
	move	*a2(ISIZEY),a1	; Get the image height
	srl	1,a1		; Divide it by 2
	sll	16,a0		; Shift width up into integer portion
	sll	16,a1		; Shift height up into integer portion
	neg	a0		; Negate the width
	neg	a1		; Negate the height
	addi	[120,0],a0	; Translate in X dir
	addi	[50,0],a1	; Translate in Y dir
	clr	a3		; Z position
	movi	DMAWNZ,a4	; Blit method
	movi	CLSMK3,a5	; Make it this class so's I kin delete it
	clr	a6		; No velocity
	clr	a7
	calla	BEGINOBJ	; Create it

	; Put a WWF belt below the mugshot
	movi	[316,0],a0	; Center X point on plate below mugshot
	movi	[198,0],a1	; Center Y point on plate below mugshot
	movi	SWWFBLT,a2	; WWF Belt Image
	clr	a3		; Z Position
	movi	DMAWNZ,a4	; How to blit it
	movi	CLSMK3,a5	; Make it this class so's I kin delete it
	clr	a6		; No velocity
	clr	a7
	calla	BEGINOBJ	; Create it

	move	a10,a1
	sll	5,a1				; Get wrestler stories table ptr
	addi	#wrestler_stories_table,a1
	move	*a1,a1,L			; Get pointer to wrestler stories
	move	*a1,a1,L			; Get pointer to string table
	JSRP	print_story

;of real time.
;	movi	TSEC*60,a9			; Allow up to 1 minute per pg
	movi	TSEC*15,a9			; Allow up to 1 minute per pg
#but_wait
	SLEEPK	1
	clr	a0		; Check the p1 buttons
	calla	get_but_val_cur
	move	a0,a0		; Any get pressed ?
	jrnz	#but_hit	; br = yes
	movk	1,a0		; Check the p2 buttons
	calla	get_but_val_cur
	move	a0,a0		; Any get pressed ?
	jrnz	#but_hit	; br = yes
	dsjs	a9,#but_wait	; 3 seconds elapsed ? - br = no
#but_hit

	movi	CLSMK3,a0	; Ok now delete all the object I created
	calla	obj_del1c

	movi	TYPWCCOUNT,a0
	calla	obj_del1c

	PULLP	a0,a1,a2	; Restore the reggies
inval_wnum
	RETP			; I be done!!!

******************************************************************************
	
	.end
