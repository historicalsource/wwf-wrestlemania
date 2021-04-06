**************************************************************
*
* Software:		Michael J. Lynch
* Initiated:		5/02/95
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"finiseq.asm"
	.title	"Finish moves sequences"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"macros.h"
	.include	"mproc.equ"		;Mproc equates
	.include	"sys.equ"
	.include	"game.equ"
	.include	"plyr.equ"
	.include	"anim.equ"
	.include	"sound.h"
	.include	"ring.equ"
	.include	"display.equ"
	.include	"ring.equ"

	.include	"takerimg.h"
	.include	"bretimg.h"
	.include	"doinkimg.h"
	.include	"yokoimg.h"
	.include	"razorimg.h"
	.include	"leximg.h"
	.include	"shawnimg.h"
	.include	"bamimg.h"

	.include	"damage.equ"
	.include	"miscimg.glo"
	.INCLUDE	"SWEAT.EQU"

	BSSX	close_the_door,16
	BSSX	close_the_floor,16
	BSSX	dead_wrestler,32
	BSSX	finish_completed,16
	BSSX	wres_mv_done,16
	BSSX	guy_in,16
	BSSX	guy_up,16

	.bss	pal_test,16*64

	.ref	KILL
	.ref	triple_sound
	.ref	change_anim1a
	.ref	DO_CROWD_CHEER
	.ref	UNDNEG_P
	.ref	RNDRNG0
	.ref	do_roll





******************************************************************************
*                                                                            *
* Bret Hart Finish Move Sequences                                            *
*                                                                            *
******************************************************************************

	.if NUM_BRET_FINISHES
#******************************************************************
*
* Bret Hart finish move #1

 SUBR	hrt_finish1_move
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

	.endif

	.if NUM_BRET_FINISHES > 1
#******************************************************************
*
* Bret Hart finish move #2

 SUBR	hrt_finish2_move
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

	.endif





******************************************************************************
*                                                                            *
* Bam Bam Bigelow Finish Move Sequences                                      *
*                                                                            *
******************************************************************************

	.if NUM_BAM_FINISHES
#******************************************************************
*
* Bam Bam finish move #1

 SUBR	bam_finish1_move
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

	.endif

	.if NUM_BAM_FINISHES > 1
#******************************************************************
*
* Bam Bam finish move #2

 SUBR	bam_finish2_move
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

	.endif





******************************************************************************
*                                                                            *
* Yokozuna Finish Move Sequences                                             *
*                                                                            *
******************************************************************************

	.if NUM_YOKO_FINISHES
#******************************************************************
*
* Yokozuna finish move #1

 SUBR	yok_finish1_move
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

	.endif

	.if NUM_YOKO_FINISHES > 1
#******************************************************************
*
* Yokozuna finish move #2

 SUBR	yok_finish2_move
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

	.endif





******************************************************************************
*                                                                            *
* Doink The Clown Finish Move Sequences                                      *
*                                                                            *
******************************************************************************

	.if NUM_DOINK_FINISHES
#******************************************************************
*
* Doink finish move #1

 SUBR	dnk_finish1_move
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

	.endif

	.if NUM_DOINK_FINISHES > 1
#******************************************************************
*
* Doink finish move #2

 SUBR	dnk_finish2_move
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

	.endif






******************************************************************************
*                                                                            *
* Razor Ramon Finish Move Sequences                                          *
*                                                                            *
******************************************************************************

	.if NUM_RAZOR_FINISHES
#******************************************************************
*
* Razor Ramon finish move #1

 SUBR	rzr_finish1_move
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

	.endif

	.if NUM_RAZOR_FINISHES > 1
#******************************************************************
*
* Razor Ramon finish move #2

 SUBR	rzr_finish2_move
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

	.endif






******************************************************************************
*                                                                            *
* Lex Lugar Finish Move Sequences                                            *
*                                                                            *
******************************************************************************

	.if NUM_LEX_FINISHES
#******************************************************************
*
* Lex Lugar finish move #1

 SUBR	lex_finish1_move
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

	.endif

	.if NUM_LEX_FINISHES > 1
#******************************************************************
*
* Lex Lugar finish move #2

 SUBR	lex_finish2_move
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

	.endif






******************************************************************************
*                                                                            *
* Undertaker Finish Move Sequences                                           *
*                                                                            *
******************************************************************************

	.if NUM_TAKER_FINISHES
	.endif
	.if NUM_TAKER_FINISHES > 1
#******************************************************************
*
* Undertaker finish move #2

 SUBR	und_finish2_move
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

	.endif






******************************************************************************
*                                                                            *
* Shawn Michaels Finish Move Sequences                                       *
*                                                                            *
******************************************************************************

	.if NUM_SHAWN_FINISHES
#******************************************************************
*
* Shawn Michaels finish move #1

 SUBR	shn_finish1_move
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

	.endif

	.if NUM_SHAWN_FINISHES > 1
#******************************************************************
*
* Shawn Michaels finish move #2

 SUBR	shn_finish2_move
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

	.endif

******************************************************************************


;
; The wrestler being knocked into the coffin MUST start at a Z of
; greater than 1430h and end up at a Z of 1428h when in the coffin.
;

HOLE_XPOS	.equ	1250
HOLE_YPOS	.equ	197

;MAT_BACK_Z	.equ	((RING_TOP+20)|1000h)
MAT_BACK_Z	.equ	((RING_Z_CENTER+20)|1000h)
TMBSTN_Z	.equ	MAT_BACK_Z
MAT_FRONT_Z	.equ	MAT_BACK_Z+27
COF_BACK_Z	.equ	MAT_BACK_Z+28
COF_FRONT_Z	.equ	COF_BACK_Z+2
DOOR_CLOSE_Z	.equ	COF_FRONT_Z+2
WRES_Z		.equ	((COF_BACK_Z)&0fffh)
EXP_Z		.equ	MAT_FRONT_Z+1

COFFIN_VEL	.equ	4
NUM_PUFFS	.equ	25

#********************************************************************
*
* Do little explosions and puffs of smoke above hole in ring
*

 SUBRP	#exp1_anim
	.long	SMOKE01
	.long	SMOKE02
	.long	SMOKE03
	.long	SMOKE04
	.long	SMOKE05
	.long	SMOKE06
	.long	SMOKE07
	.long	SMOKE08
	.long	SMOKE09
	.long	SMOKE10
	.long	0

 SUBRP	#exp2_anim
	.long	SMOKEB01
	.long	SMOKEB02
	.long	SMOKEB03
	.long	SMOKEB04
	.long	SMOKEB05
	.long	SMOKEB06
	.long	SMOKEB07
	.long	SMOKEB08
	.long	SMOKEB09
	.long	SMOKEB10
	.long	0

 SUBRP	#ltl_puff
	.long	#exp1_anim
	.long	#exp2_anim



 SUBRP	ltl_exp

	movk	10,a0		; Sleep a random amount of time before
	calla	RNDRNG0		; we start the little puff of smoke
	addk	1,a0
	calla	PRCSLP

	movi	80,a0		; Get a random X position above the hole
	calla	RNDRNG0		; To fire off the puff of smoke
	subi	40,a0
	movi	HOLE_XPOS,a14
	add	a14,a0		; Translate to hole position
	move	a0,*a13(256)

	movi	30,a0		; Get a random Y position above the hole
	calla	RNDRNG0		; To fire off the puff of smoke
	subi	25,a0
	addi	HOLE_YPOS,a0	; Translate to hole position
	move	a0,*a13(256+16)	

	movi	10,a0		; Get a random Z position
	calla	RNDRNG0
	addi	EXP_Z,a0	; Translate to hole Z position (in front of coffin)
	move	a0,*a13(256+32)

	movi	7,a0		; Get a random velocity to use
	calla	RNDRNG0
	addk	2,a0
	move	a0,*a13(256+48)

	movk	1,a0		; Get a random smoke puff to use
	calla	RNDRNG0
	sll	5,a0
	movi	#ltl_puff,a9
	add	a0,a9
	move	*a9,a9,L	; Pointer to puff animation

	move	*a13(256),a0	; Get X position
	sll	16,a0
	move	*a13(256+16),a1	; Get Y position
	sll	16,a1
	move	*a13(256+32),a3	; Get Z position
	move	*a9+,a2,L	; Get first image
	movi	DMAWNZ|M_3D,a4	; Flags
	movi	CLSFRWK,a5	; This is the class
	clr	a6		; No velocities
	clr	a7

	calla	BEGINOBJ	; Make the first one

; Now make an explosion sound
	movi	1252,a3
	calla	SNDSND

#puff_lp
	SLEEPK	3		; Let us see it
	move	*a9+,a0,L	; Get next image
	jrz	#puff_done	; br = no more images
	move	*a8(OCTRL),a1	; Change the image
	calla	obj_aniq
	move	*a8(OYPOS),a14	; Get current Y Position
	move	*a13(256+48),a1	; Get the velocity
	sub	a1,a14		; Add it
	move	a14,*a8(OYPOS)	; Write it back
	jruc	#puff_lp	; Go do next image in sequence

#puff_done
	calla	DELOBJA8	; Kill off the object

	DIE


#********************************************************************
*
* Do Undertakers Coffin rising from below
*

 SUBRP	#mat_anim
	.long	MATCOF01
	.long	MATCOF02
	.long	MATCOF03
	.long	MATCOF04
 SUBRP	#mat_anim2
	.long	0

 SUBRP	#cof_anim1
	.long	COFFIN02
	.long	COFFIN03
	.long	COFFIN04
	.long	COFFIN05
 SUBRP	#cof_anim2
	.long	0

 SUBRP	#tstone_anim
	.long	TMBSTN01
 SUBRP	#tstone_test
	.long	TMBSTN02
	.long	TMBSTN03
	.long	TMBSTN04
	.long	TMBSTN05
	.long	TMBSTN06
	.long	TMBSTN07
	.long	TMBSTN08
	.long	0

 SUBR	und_coffin_up

	clr	a14			; Set up the state machine
	move	a14,@close_the_door
	move	a14,@close_the_floor

	SLEEP	TSEC*2

	movi	#mat_anim,a9		; Start up the mat animation

	movi	[HOLE_XPOS,0],a0
	movi	DMAWNZ|M_3D,a4
	movi	[HOLE_YPOS,0],a1
	move	*a9+,a2,L
	movi	MAT_BACK_Z,a3
	movi	CLSFRWK,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ

#man_loop
	SLEEPK	3			; Display the frame
	move	*a9+,a0,L		; Are we done ?
	jrz	#do_open_mat		; br = yes
	move	*a8(OCTRL),a1		; Change to next frame
	calla	obj_aniq
	jruc	#man_loop

#do_open_mat
	move	a8,a11			; Save the the object pointer
	move	*a8(OCTRL),a1		; Change the image to the front piece
	movi	MATCOF05B,a0
	calla	obj_aniq
	
	movi	[HOLE_XPOS,0],a0	; Create the front piece
	movi	DMAWNZ|M_3D,a4
	movi	[HOLE_YPOS,0],a1
	movi	MATCOF05A,a2,L
	movi	MAT_FRONT_Z,a3
	movi	CLSFRWK,a5
	clr	a6
	clr	a7

	calla	BEGINOBJ
	SLEEPK	2

; Now make some little explosions above the hole
	movi	NUM_PUFFS,a9   		; Make 25 little puffs of smoke
#exp_clp
	CREATE0	ltl_exp
	dsjs	a9,#exp_clp


; Now start the coffin rising up
	CREATE0	do_up_coffin		; Make the coffin come up through
					; the floor

#wait_fclose
	SLEEPK	1			; Wait to be told to close the floor
	move	@close_the_floor,a14
	jrz	#wait_fclose

	SLEEPK	15

	calla	DELOBJA8		; Delete the back piece
	movi	#mat_anim2,a9		; Set up for close animation
	move	a11,a8			; Get saved object pointer
#fc_loop
	move	*-a9,a0,L		; Change the image
	move	*a8(OCTRL),a1
	calla	obj_aniq
	SLEEPK	3
	cmpi	#mat_anim,a9		; Are we done ?
	jrnz	#fc_loop		; br = no
	calla	DELOBJA8		; Get rid of this mat piece

	SLEEPK	3

	movk	2,a14
	move	a14,@close_the_floor	; Let whoever know floor is closed


; Now Bring up the tombstone

	movi	0fh,a0
	calla	triple_sound

;	movi	#tstone_anim,a9		; Set up to bring up the tombstone
	movi	#tstone_test,a9		; Set up to bring up the tombstone

	movi	[HOLE_XPOS,0],a0	; And create the first object
	movi	DMAWNZ|M_3D,a4
	movi	[HOLE_YPOS-18,0],a1
	move	*a9+,a2,L
	movi	TMBSTN_Z,a3
	movi	CLSFRWK,a5
	clr	a6
	clr	a7

	push	a9
	calla	BEGINOBJ
	pull	a9
	SLEEPK	4			; Let's see it

#stn_up
	move	*a9+,a0,L		; Get the next image
	jrz	#stn_done		; br = no more images
	move	*a8(OCTRL),a1
	calla	obj_aniq		; Change the image
	SLEEPK	4			; Let's see it
	jruc	#stn_up			; Do next image

#stn_done
	movk	3,a14
	move	a14,@close_the_floor	; Let whoever know tombstone is up
	move	a14,@finish_completed

	DIE



 SUBRP	do_up_coffin

	movi	#cof_anim1,a9

	movi	[HOLE_XPOS+7,0],a0	; Create the Coffin
	movi	DMAWNZ|M_3D,a4		
	movi	[HOLE_YPOS+108,0],a1
	move	a1,a10
	movi	COFFIN01,a2
	movi	COF_BACK_Z,a3		; Make it in front of mat pieces
	movi	CLSFRWK,a5
	clr	a6
	clr	a7

	calla	BEGINOBJ

	move	a8,*a13(256),L		; Save the object pointer

; Make some sound while moving up
	movi	014h,a0
	calla	triple_sound

	movk	COFFIN_VEL,a14		; Start it 4 pixels high
	move	a14,*a8(OSIZEY)

#mv_up_lp
	SLEEPK	1
	move	*a8(OSIZEY),a14		; Get the size of the object
	cmpi	136,a14			; Are we at full size yet ?
	jrz	#open_lp		; br = yes
	addk	COFFIN_VEL,a14 		; Make it 4 pixels larger
	move	a14,*a8(OSIZEY)
	move	*a8(OYPOS),a14		; Get its current position
	subk	COFFIN_VEL,a14		; Move it up 4 pixels
	move	a14,*a8(OYPOS)		; Write it back
	jruc	#mv_up_lp		; Go display it

#open_lp
	move	*a9+,a0,L		; Now open the coffin door
	cmpi	COFFIN05,a0		; Is the door open ?
	jrz	#open_done		; br = yes
	move	*a8(OCTRL),a1
	calla	obj_aniq
	SLEEPK	3
	jruc	#open_lp

#open_done
	movk	1,a14
	move	a14,@close_the_door

	move	*a8(OCTRL),a1		; Keep the last piece
	calla	obj_aniq
	move	*a8(OYPOS),a14		; Get the current position
	movi	DMAWNZ|M_3D,a4
	movi	[HOLE_XPOS+7,0],a0	; And create the front piece
	move	a14,a1
	sll	16,a1
	movi	COFFIN6A,a2
	movi	COF_FRONT_Z,a3		; Make sure its in front of back piece
	movi	CLSFRWK,a5
	clr	a6
	clr	a7

	calla	BEGINOBJ

	move	a8,*a13(256+32),L	; Save away it's object pointer

	move	*a13(256),a9,L		; Back piece object pointer
	movi	HOLE_XPOS+7,a14
	move	a14,*a13(256+64)
	move	*a9(OYPOS),*a13(256+80)	; Save the Y position
	move	*a13(256+32),a10,L	; Front piece object pointer
	CREATE0	hover_coffin
	move	a0,*a13(256+96),L	; Save the process pointer

#wait_to_close
	SLEEPK	3			; Now wait until told to close the
	move	@close_the_door,a14	; coffin door
	cmpi	2,a14
	jrlt	#wait_to_close

	move	*a13(256+96),a0,L	; Get the hover craft process pointer
	calla	KILL			; And kill him off

	move	*a13(256),a8,L		; Get the back piece object pointer
	movi	#cof_anim2,a9		; Now close the door
#close_loop
	move	*-a9,a0,L		; Pointer to image header
	cmpi	COFFIN02,a0		; Are we at this image
	jrnz	#no_z_adj		; br = no
	move	*a13(256+32),a8,L	; Get front piece object pointer
	push	a0
	calla	DELOBJA8		; Get rid of front piece
	pull	a0
	move	*a13(256),a8,L		; Get back piece object pointer
	movi	DOOR_CLOSE_Z,a14	; Change its Z to in front of wrestler
	move	a14,*a8(OZPOS)
#no_z_adj
	move	*a8(OCTRL),a1		; Change the image
	calla	obj_aniq
	SLEEPK	1			; Lets see it
	cmpi	#cof_anim1,a9		; Are we done closing the door ?
	jrne	#close_loop		; br = no

	movi	COFFIN01,a0		; Change the image to the closed
	move	*a8(OCTRL),a1		; coffin image
	calla	obj_aniq

	movk	3,a14
	move	a14,@close_the_door

; Make a slamming door sound
	movi	03dh,a0
	calla	triple_sound

; Shake the coffin around when the door slams shut
	movk	16,a9			; Number of shakes
#shk_lp
	movk	4,a0
	calla	RNDRNG0
	subk	2,a0
	move	*a13(256+64),a14
	add	a0,a14
	move	a14,*a8(OXPOS)
	movk	2,a0
	calla	RNDRNG0
	subk	2,a0
	move	*a13(256+80),a14
	add	a0,a14
	move	a14,*a8(OYPOS)
	SLEEPK	1
	dsjs	a9,#shk_lp

	move	*a13(256+64),*a8(OXPOS)
	move	*a13(256+80),*a8(OYPOS)

; Now make some little explosions above the hole
	movi	NUM_PUFFS,a9   		; Make 25 little puffs of smoke
exp_clp
	CREATE0	ltl_exp
	dsjs	a9,exp_clp

; Make some sound while moving down
	movi	011h,a0
	calla	triple_sound

	movi	136,a14			; Set starting size of image
	move	a14,*a8(OSIZEY)
#mv_dn_lp

	CREATE0	ltl_exp
	SLEEPK	1			; Lets see it
	move	*a8(OSIZEY),a14		; Get current size
	cmpi	1,a14			; Are we at <= 1 pixel
	jrle	#mv_dn_done		; br = yes
	subk	COFFIN_VEL,a14		
	move	a14,*a8(OSIZEY)
	move	*a8(OYPOS),a14		; Get the current position
	addk	COFFIN_VEL,a14
	move	a14,*a8(OYPOS)		; And write it back
	jruc	#mv_dn_lp
#mv_dn_done
	calla	DELOBJA8		; Get rid of the coffin
	movk	1,a14			; Tell the floor to close up
	move	a14,@close_the_floor

	DIE				; We done


#*************************************************************
*
* Hover coffin - makes the coffin look like it's hovering
* This guy runs until killed by process that creates it
*
* a9 =  *object 1
* a10 = *object 2

 SUBRP	hover_coffin
	move	*a10(OYPOS),a11		; Get start Y position
#reset_a8
	movk	1,a8			; Start with move down
#do_agin
	SLEEPK	7
	move	*a9(OYPOS),a14		; Get current Y position
	add	a8,a14			; Add in delta
	move	a14,*a9(OYPOS)		; Write it back
	move	*a10(OYPOS),a14		; Get current Y position
	add	a8,a14			; Add it delta
	move	a14,*a10(OYPOS)		; Write it back
	sub	a11,a14			; Subtract current from start
	abs	a14			; Make sure its positive
	cmpi	2,a14			; <= 3
	jrle	#do_agin		; br = yes
	move	a8,a8			; a8 negative ?
	jrn	#reset_a8		; br = yes
	movk	1,a8			; set to -1
	not	a8
	CREATE0	ltl_exp
	CREATE0	ltl_exp
	CREATE0	ltl_exp
	CREATE0	ltl_exp
	CREATE0	ltl_exp
	CREATE0	ltl_exp
	CREATE0	ltl_exp
	CREATE0	ltl_exp
	jruc	#do_agin		; keep a bouncin

	DIE

#*****************************************************************************
*
* Closes the coffin door
*
 SUBRP	close_door
	movk	2,a14
	move	a14,@close_the_door
	rets

#****************************************************************************
*
* Checks to see if coffin door is open
*
 SUBRP	is_door_open
	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1

	move	@close_the_door,a14
	jrz	#door_not_open

	ori	MODE_STATUS,a1
#door_not_open
	move	a1,*a13(ANIMODE)
	rets
	
#****************************************************************************
*
* Checks to see if the dead guy is ready to be stuffed into the coffin
*
 SUBRP	is_guy_up
	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1

	move	@guy_up,a14
	jrz	#guy_not_up

	ori	MODE_STATUS,a1
#guy_not_up
	move	a1,*a13(ANIMODE)
	rets

#****************************************************************************
*
* Checks to see if the dead guy is in the coffin
*
 SUBRP	is_he_in
	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1

	move	@guy_in,a14
	jrz	#guy_not_in

	ori	MODE_STATUS,a1
#guy_not_in
	move	a1,*a13(ANIMODE)
	rets

#****************************************************************************
*
* Makes a wrestler disappear after being shut into the coffin
*
 SUBRP	disappear_wrestler
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY|MODE_NOSHADOW|MODE_INVISIBLE
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_DEAD
	.word	ANI_ROT


#****************************************************************************
*
* Make wrestler disappear - Monitors the state of the coffin door and makes
* the dead wrestler invisible when the door is closed.
*
 SUBRP	make_wres_disappear
	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1

	move	@close_the_door,a14
	cmpi	3,a14
	jrnz	#not_time

	PUSH	a1,a13
	move	@dead_wrestler,a13,L
	movi	disappear_wrestler,a0
	calla	change_anim1a
	PULL	a1,a13

	ori	MODE_STATUS,a1
#not_time
	move	a1,*a13(ANIMODE)
	rets


#*****************************************************************************
*
* Set the flag to tell that the guy is ready to be knocked into the coffin
*
 SUBRP	guy_is_up
	movk	1,a14
	move	a14,@guy_up
	rets

#*****************************************************************************
*
* Adjust facing checks the wrestlers facing direction.
*
 SUBRP	adjust_facing
	move	*a13(FACING_DIR),a14
	ori	(MOVE_LEFT|MOVE_DOWN),a14
	andni	(MOVE_RIGHT|MOVE_UP),a14
	move	a14,*a13(FACING_DIR)
	move	*a13(OBJ_CONTROL),a14
	ori	M_FLIPH,a14
	move	a14,*a13(OBJ_CONTROL)
	rets

#*****************************************************************************
*
* Adjust taker facing checks takers facing direction.
*
 SUBRP	adjust_taker_facing
	move	*a13(FACING_DIR),a14
	andni	(MOVE_LEFT|MOVE_DOWN),a14
	ori	(MOVE_RIGHT|MOVE_UP),a14
	move	a14,*a13(FACING_DIR)
	move	*a13(OBJ_CONTROL),a14
	andni	M_FLIPH,a14
	move	a14,*a13(OBJ_CONTROL)
	rets

#*****************************************************************************
*
* Check roll checks to see if the dead guy nees to be rolled down and does it
* if need be.
*
 SUBRP	check_roll
	move	*a13(ANIMODE),a0
	andni	MODE_STATUS,a0
	move	*a13(OBJ_ZPOSINT),a1
	cmpi	(RING_Z_CENTER+20),a1
	jrgt	#roll_done
	move	*a13(STICK_VAL_CUR),a1
	ori	MOVE_DOWN,a1
	move	a1,*a13(STICK_VAL_CUR)
	PUSH	a0
	calla	do_roll
	PULL	a0
	ori	MODE_STATUS,a0
#roll_done
	move	a0,*a13(ANIMODE)
	rets

#*****************************************************************************
*
* Stand wrestler changes the dead wrestlers animation to a standing position
*
 SUBRP	rzr_stand_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	; First roll the guy down to the bottom of the ring if need be
#rl_loop
	.word	ANI_PAUSE,1
	WL	ANI_CODE,check_roll
	WL	ANI_IFSTATUS,#rl_loop

	; Now Stand the bugger up
	WL	3,R3GU2A+FR1
	WL	3,R3GU2A+FR2
	WL	3,R3GU4A+FR3
	WL	3,R3GU4A+FR4
	WL	3,R3GU4A+FR5
	WL	3,R3GU4A+FR6
	WL	3,R3GU4A+FR7
	WL	3,R3GU4A+FR8
	WL	3,R3GU4A+FR9
	WL	3,R3GU4A+FR10


	; Tell all he's up there
	WL	ANI_CODE,guy_is_up

	; Face him the right direction
	WL	ANI_CODE,adjust_facing

	; And finally make him dizzy
 SUBRP	rzr_fdizzy_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
#loop
	WL	8,R4WP5C+FR1
	WL	8,R4WP5C+FR2
	WL	8,R4WP5C+FR3
	WL	8,R4WP5C+FR4
	WL	8,R4WP5C+FR5
	WL	8,R4WP5C+FR6
	WL	8,R4WP5C+FR7
	WL	8,R4WP5C+FR8
	WL	8,R4WP5C+FR7
	WL	8,R4WP5C+FR6
	WL	8,R4WP5C+FR5
	WL	8,R4WP5C+FR4
	WL	8,R4WP5C+FR3
	WL	8,R4WP5C+FR2
	WL	ANI_GOTO,#loop


#*****************************************************************************
*
* Stand wrestler changes the dead wrestlers animation to a standing position
*
 SUBRP	hrt_stand_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	; First roll the guy down to the bottom of the ring if need be
#rl_loop
	.word	ANI_PAUSE,1
	WL	ANI_CODE,check_roll
	WL	ANI_IFSTATUS,#rl_loop

	WL	7,H3GU4A+FR1
	WL	7,H3GU4A+FR2
	WL	7,H3GU4A+FR3
	WL	7,H3GU4A+FR4
	WL	7,H3GU4A+FR5
	WL	7,H3GU4A+FR6
	WL	7,H3GU4A+FR7
	WL	7,H3GU4A+FR8
	WL	7,H3GU4A+FR9
	WL	7,H3GU4A+FR10

	; Tell all he's up there
	WL	ANI_CODE,guy_is_up

	; Face him the right direction
	WL	ANI_CODE,adjust_facing

	; And finally make him dizzy
 SUBRP	hrt_fdizzy_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
#loop
	WL	5,H4TI4B+FR1
	WL	5,H4TI4B+FR2
	WL	5,H4TI4B+FR3
	WL	5,H4TI4B+FR4
	WL	5,H4TI4B+FR5
	WL	5,H4TI4B+FR6
	WL	5,H4TI4B+FR7
	WL	5,H4TI4B+FR8
	WL	5,H4TI4B+FR7
	WL	5,H4TI4B+FR6
	WL	5,H4TI4B+FR5
	WL	5,H4TI4B+FR4
	WL	5,H4TI4B+FR3
	WL	5,H4TI4B+FR2
	WL	ANI_GOTO,#loop


#*****************************************************************************
*
* Stand wrestler changes the dead wrestlers animation to a standing position
*
 SUBRP	und_stand_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	; First roll the guy down to the bottom of the ring if need be
#rl_loop
	.word	ANI_PAUSE,1
	WL	ANI_CODE,check_roll
	WL	ANI_IFSTATUS,#rl_loop

	WL	7,U3SU4A+FR1
	WL	7,U3SU4A+FR2
	WL	7,U3SU4A+FR3
	WL	7,U3SU4A+FR4
	WL	7,U3SU4A+FR5
	WL	7,U3SU4A+FR6
	WL	7,U3SU4A+FR7
	WL	7,U3SU4A+FR8

	; Tell all he's up there
	WL	ANI_CODE,guy_is_up

	; Face him the right direction
	WL	ANI_CODE,adjust_facing

	; And finally make him dizzy
 SUBRP	und_fdizzy_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
#loop
	WL	10,U4TI4C+FR1
	WL	10,U4TI4C+FR3
	WL	10,U4TI4C+FR5
	WL	10,U4TI4C+FR7
	WL	10,U4TI4C+FR5
	WL	10,U4TI4C+FR3
	WL	ANI_GOTO,#loop


#*****************************************************************************
*
* Stand wrestler changes the dead wrestlers animation to a standing position
*
 SUBRP	yok_stand_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	; First roll the guy down to the bottom of the ring if need be
#rl_loop
	.word	ANI_PAUSE,1
	WL	ANI_CODE,check_roll
	WL	ANI_IFSTATUS,#rl_loop

	WL	7,Y3GU2A+FR1
	WL	7,Y3GU2A+FR2
	WL	7,Y3GU2A+FR3
	WL	7,Y3GU2A+FR4
	WL	7,Y3GU2A+FR6
	WL	7,Y3GU2A+FR7
	WL	7,Y3GU2A+FR8
	WL	7,Y3GU2A+FR10
	WL	7,Y3GU2A+FR11
	WL	7,Y3GU2A+FR12
	WL	7,Y3GU4A+FR13
	WL	7,Y3GU4A+FR14

	; Tell all he's up there
	WL	ANI_CODE,guy_is_up

	; Face him the right direction
	WL	ANI_CODE,adjust_facing

	; And finally make him dizzy
 SUBRP	yok_fdizzy_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
#loop
	WL	10,Y4TI4C+FR4
	WL	10,Y4TI4C+FR5
	WL	10,Y4TI4C+FR6
	WL	10,Y4TI4C+FR7
	WL	10,Y4TI4C+FR8
	WL	10,Y4TI4C+FR7
	WL	10,Y4TI4C+FR6
	WL	10,Y4TI4C+FR5
	WL	ANI_GOTO,#loop



#*****************************************************************************
*
* Stand wrestler changes the dead wrestlers animation to a standing position
*
 SUBRP	shn_stand_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	; First roll the guy down to the bottom of the ring if need be
#rl_loop
	.word	ANI_PAUSE,1
	WL	ANI_CODE,check_roll
	WL	ANI_IFSTATUS,#rl_loop

	WL	7,S3GU2A+FR1
	WL	7,S3GU2A+FR2
	WL	7,S3GU4A+FR3
	WL	7,S3GU4A+FR4
	WL	7,S3GU4A+FR5
	WL	7,S3GU4A+FR6
	WL	7,S3GU4A+FR7
	WL	7,S3GU4A+FR8
	WL	7,S3GU4A+FR9

	; Tell all he's up there
	WL	ANI_CODE,guy_is_up

	; Face him the right direction
	WL	ANI_CODE,adjust_facing

	; And finally make him dizzy
 SUBRP	shn_fdizzy_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
#loop
	WL	9,S4TI4B+FR1
	WL	9,S4TI4B+FR2
	WL	9,S4TI4B+FR3
	WL	9,S4TI4B+FR4
	WL	9,S4TI4B+FR3
	WL	9,S4TI4B+FR2
	WL	ANI_GOTO,#loop


#*****************************************************************************
*
* Stand wrestler changes the dead wrestlers animation to a standing position
*
 SUBRP	bam_stand_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	; First roll the guy down to the bottom of the ring if need be
#rl_loop
	.word	ANI_PAUSE,1
	WL	ANI_CODE,check_roll
	WL	ANI_IFSTATUS,#rl_loop

	WL	7,B3GU4A+FR1
	WL	7,B3GU4A+FR2
	WL	7,B3GU4A+FR3
	WL	7,B3GU4A+FR4
	WL	7,B3GU4A+FR5
	WL	7,B3GU4A+FR6
	WL	7,B3GU4A+FR7
	WL	7,B3GU4A+FR8
	WL	7,B3GU4A+FR9
	WL	7,B3GU4A+FR10
	WL	7,B3GU4A+FR11
	WL	7,B3GU4A+FR12

	; Tell all he's up there
	WL	ANI_CODE,guy_is_up

	; Face him the right direction
	WL	ANI_CODE,adjust_facing

	; And finally make him dizzy
 SUBRP	bam_fdizzy_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
#loop
	WL	8,B4TI4A+FR1
	WL	8,B4TI4A+FR2
	WL	8,B4TI4A+FR3
	WL	8,B4TI4A+FR4
	WL	8,B4TI4A+FR5
	WL	8,B4TI4A+FR6
	WL	8,B4TI4A+FR7
	WL	8,B4TI4A+FR6
	WL	8,B4TI4A+FR5
	WL	8,B4TI4A+FR4
	WL	8,B4TI4A+FR3
	WL	8,B4TI4A+FR2
	WL	ANI_GOTO,#loop


#*****************************************************************************
*
* Stand wrestler changes the dead wrestlers animation to a standing position
*
 SUBRP	dnk_stand_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	; First roll the guy down to the bottom of the ring if need be
#rl_loop
	.word	ANI_PAUSE,1
	WL	ANI_CODE,check_roll
	WL	ANI_IFSTATUS,#rl_loop

	WL	7,D3GU4A+FR1
	WL	7,D3GU4A+FR2
	WL	7,D3GU4A+FR3
	WL	7,D3GU4A+FR4
	WL	7,D3GU4A+FR5
	WL	7,D3GU4A+FR6
	WL	7,D3GU4A+FR7
	WL	7,D3GU4A+FR8
	WL	7,D3GU4A+FR9

	; Tell all he's up there
	WL	ANI_CODE,guy_is_up

	; Face him the right direction
	WL	ANI_CODE,adjust_facing

	; And finally make him dizzy
 SUBRP	dnk_fdizzy_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
#loop
	WL	6,D4SW4C+FR1
	WL	6,D4SW4C+FR2
	WL	6,D4SW4C+FR3
	WL	6,D4SW4C+FR4
	WL	6,D4SW4C+FR5
	WL	6,D4SW4C+FR6
	WL	6,D4SW4C+FR5
	WL	6,D4SW4C+FR4
	WL	6,D4SW4C+FR3
	WL	6,D4SW4C+FR2
	WL	ANI_GOTO,#loop



#*****************************************************************************
*
* Stand wrestler changes the dead wrestlers animation to a standing position
*
 SUBRP	lex_stand_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	; First roll the guy down to the bottom of the ring if need be
#rl_loop
	.word	ANI_PAUSE,1
	WL	ANI_CODE,check_roll
	WL	ANI_IFSTATUS,#rl_loop

	WL	7,L3GU4A+FR1
	WL	7,L3GU4A+FR2
	WL	7,L3GU4A+FR3
	WL	7,L3GU4A+FR4
	WL	7,L3GU4A+FR5
	WL	7,L3GU4A+FR6
	WL	7,L3GU4A+FR7
	WL	7,L3GU4A+FR8
	WL	7,L3GU4A+FR9
	WL	7,L3GU4A+FR10

	; Tell all he's up there
	WL	ANI_CODE,guy_is_up

	; Face him the right direction
	WL	ANI_CODE,adjust_facing

	; And finally make him dizzy
 SUBRP	lex_fdizzy_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
#loop
	WL	8,L4TI4B+FR5
	WL	8,L4TI4B+FR6
	WL	8,L4TI4B+FR7
	WL	8,L4TI4B+FR8
	WL	8,L4TI4B+FR9
	WL	8,L4TI4B+FR8
	WL	8,L4TI4B+FR7
	WL	8,L4TI4B+FR6
	WL	ANI_GOTO,#loop




 SUBRP	stand_table
	.long	hrt_stand_anim	;0 Bret Hart
	.long	rzr_stand_anim	;1 Razor Ramon
	.long	und_stand_anim	;2 Undertaker
	.long	yok_stand_anim	;3 Yokozuna
	.long	shn_stand_anim	;4 Shawn Michaels
	.long	bam_stand_anim	;5 Bam Bam
	.long	dnk_stand_anim	;6 Doink
	.long	0		;7 spare
	.long	lex_stand_anim	;8 Lex Luger


 SUBRP	stand_wrestler
	FACETBL	stand_table
	calla	change_anim1a
	rets

 SUBRP	dizzy_table
	.long	hrt_fdizzy_anim	;0 Bret Hart
	.long	rzr_fdizzy_anim	;1 Razor Ramon
	.long	und_fdizzy_anim	;2 Undertaker
	.long	yok_fdizzy_anim	;3 Yokozuna
	.long	shn_fdizzy_anim	;4 Shawn Michaels
	.long	bam_fdizzy_anim	;5 Bam Bam
	.long	dnk_fdizzy_anim	;6 Doink
	.long	0		;7 spare
	.long	lex_fdizzy_anim	;8 Lex Luger


 SUBRP	dizzy_wrestler
	FACETBL	dizzy_table
	calla	change_anim1a
	rets



#*****************************************************************************
*
* Raise dead anim
*
 SUBRP	raise_dead_anim

	; Uninterruptable, no autoflip, no gravity
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_PAUSE,(TSEC/2)

	; Now make him stand up
	WL	ANI_CODE,stand_wrestler



#*****************************************************************************
*
* Raises the dead guy off the floor and starts a standing dizzy animation
* for the dead guy.
*
 SUBRP	raise_dead
	SLEEP	TSEC/2		; Give him a bit before standing up
	PUSH	a13
	move	@dead_wrestler,a13,L
	movi	raise_dead_anim,a0
	calla	change_anim1a
	PULL	a13
	DIE

TIME_FOR_MOVE	.equ	16

#*****************************************************************************
*
* This sets the guy is in the coffin flag
*
 SUBRP	guy_is_in
	movk	1,a14
	move	a14,@guy_in
	rets

#*****************************************************************************
*
* Sets the X, Y, and Z velocities of the dead wrestler being pushed into the
* coffin.
*
 SUBRP	set_speeds
	move	*a13(OBJ_XPOSINT),a2
	movi	HOLE_XPOS+7,a1
	sub	a2,a1
	movi	TIME_FOR_MOVE,a2
	sll	16,a1
	divs	a2,a1
	move	a1,*a13(OBJ_XVEL),L

	move	*a13(OBJ_ZPOSINT),a2
	cmpi	WRES_Z,a2
	jrge	#is_in_front
	movi	WRES_Z,a2
	move	a2,*a13(OBJ_ZPOSINT)
#is_in_front
	movi	WRES_Z,a1
	sub	a2,a1
	movi	TIME_FOR_MOVE,a2
	sll	16,a1
	divs	a2,a1
	move	a1,*a13(OBJ_ZVEL),L

	rets

#*****************************************************************************
*
* Push in animation - pushes the dead wrestler into the coffin
*
 SUBRP	push_in_anim
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOGRAVITY|MODE_NOSHADOW
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	; Set the X,Y,and Z velocities
	WL	ANI_CODE,set_speeds

	; Make a woosh sound while he's moving to coffin
	.word	ANI_SOUND,014h

	; Wait for him to get there
	.word	ANI_PAUSE,TIME_FOR_MOVE

	; Stop him from moving anymore
	.word	ANI_ZEROVELS

	; Make a crash sound when he's in
	.word	ANI_SOUND,0bh

	; Glitch him up 27 pixels
	WL	ANI_SET_YVEL,1b0000h
	.word	ANI_PAUSE,1

	; Stop him from moving
	.word	ANI_ZEROVELS

	; Tell everyone who is interested that he's made it
	WL	ANI_CODE,guy_is_in

	; Make him be dizzy
	WL	ANI_CODE,dizzy_wrestler


#*****************************************************************************
*
* Pushes the dead guy into the coffin
*
 SUBRP	push_to_coffin
	PUSH	a13
	move	@dead_wrestler,a13,L
	movi	push_in_anim,a0
	calla	change_anim1a
	PULL	a13
	rets


#*****************************************************************************
*
* #2 Undertaker raise the dead animation
*

 SUBR	und_2_raise_dead_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	WL	ANI_CODE,adjust_taker_facing

	; This rises the dead guy up off of the floor to a standing dizzy
	; position.
	WLWWWW	ANI_CREATEPROC,raise_dead,0,0,0,0

	; Start the coffin rising up
	WLWWWW	ANI_CREATEPROC,und_coffin_up,0,0,0,0

	WLWW	ANI_SHADOWTRAIL,UNDNEG_P,5,15	;pal,rate,lifespan

	; This is what taker does to raise the dead guy
	WL	4,U5RV5A+FR1
	WL	4,U5RV5A+FR2
	WL	4,U5RV5A+FR3
#loopa
	WL	5,U5RV5A+FR4
	WL	5,U5RV5A+FR5
	WL	15,U5RV5A+FR6
	WL	5,U5RV5A+FR5
	WL	ANI_CODE,DO_CROWD_CHEER
	WL	ANI_CODE,is_guy_up
	WL	ANI_IFNOTSTATUS,#loopa

	; Let the dead guy stand there being dizzy fer a bit
#loop
	WL	5,U5RV5A+FR4
	WL	5,U5RV5A+FR5
	WL	15,U5RV5A+FR6
	WL	5,U5RV5A+FR5

	WL	ANI_CODE,DO_CROWD_CHEER
	WL	ANI_CODE,is_door_open
	WL	ANI_IFNOTSTATUS,#loop
	WL	5,U5RV5A+FR4
	WL	4,U5RV5A+FR3
	WL	4,U5RV5A+FR2
	WL	4,U5RV5A+FR1

	; This is what taker does to push the guy into the coffin
	WLWW	ANI_SHADOWTRAIL,UNDNEG_P,2,8	;pal,rate,lifespan
	WL	7,U4PS3A+FR1
	WL	7,U4PS3A+FR2
	WL	7,U4PS3A+FR3

	; This pushes the dead guy into the coffin and lets him stand in it
	; being dizzy for a bit
	; Make a grunt sound when push start
	.word	ANI_SOUND,02dh

	WL	ANI_CODE,push_to_coffin
	.word	ANI_SET_RPTCOUNT,(TSEC*3)/(7*6)
#loop1
	WL	7,U4PS3A+FR5
	WL	7,U4PS3A+FR6
	WL	7,U4PS3A+FR7
	WL	7,U4PS3A+FR8
	WL	7,U4PS3A+FR7
	WL	7,U4PS3A+FR6

	WL	ANI_CODE,DO_CROWD_CHEER
	WL	ANI_CODE,is_he_in
	WL	ANI_IFNOTSTATUS,#loop1
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#loop1

	; Now close the door
	.word	ANI_SOUND,2dh		; Push door shut effort grunt
	WL	ANI_CODE,close_door

#d_loop
	.word	ANI_PAUSE,5
	WL	ANI_CODE,make_wres_disappear
	WL	ANI_IFNOTSTATUS,#d_loop

	WL	7,U4PS3A+FR5
	WL	7,U4PS3A+FR3
	WL	7,U4PS3A+FR2
	WL	7,U4PS3A+FR1

	; And last but not least raise arm and leave crowd cheering
	.word	ANI_SHADOWTRAIL,0	;off
	WL	4,U5RV5A+FR1
	WL	4,U5RV5A+FR2
	WL	4,U5RV5A+FR3
	WL	4,U5RV5A+FR4
	WL	4,U5RV5A+FR5
#loop3
	WL	ANI_CODE,DO_CROWD_CHEER
	WL	50,U5RV5A+FR6
	WL	ANI_GOTO,#loop3


	.end
