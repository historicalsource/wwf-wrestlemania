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

	.file	"finish.asm"
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

#****************************************************************
*
;a0 = number of lights
 SUBR	yok_falling_lights
	PUSHP	a9,a10
	movi	100,a9
	move	a0,a10
#create_lts
	CREATE0	yok_falling_light
	SLEEPK	5
	addk	20,a9
	dsjs	a10,#create_lts

	SLEEP	TSEC*20

	PULLP	a9,a10
	RETP

#*****************************************************************
*
 SUBRP	lt_smk_tbl
	.long	YKLTSMK01
	.long	YKLTSMK02
	.long	YKLTSMK03
	.long	YKLTSMK04
	.long	YKLTSMK05
	.long	YKLTSMK06
	.long	YKLTSMK07
	.long	0

#*****************************************************************
*
;a9 - starting x position
 SUBRP	yok_falling_light

	move	a9,a0				; Set up horizontal position
	clr	a10				; Save off current y
	sll	16,a0				; Set up vertical position
	clr	a1
	movi	YKLIGHT01,a2			; This is a light
	movi	1000h|RING_Z_CENTER,a3			; Z position
	movi	DMAWNZ|M_3D|M_SCRNREL,a4	; Control goop
	cmpi	200,a9				; light more'n half way?
	jrlt	#no_flip			; br = nope
	ori	M_FLIPH,a4			; flip
#no_flip
	movi	CLSFINI,a5			; Light object id
	clr	a6				; velocity
	clr	a7				; velocity

	calla	BEGINOBJ			; make it

#fall_loop					; Make the light fall
	SLEEPK	1
	cmpi	(255-MAT_Y),a10
	jrgt	#fall_done
	addk	15,a10
	move	a10,*a8(OYPOS)
	jruc	#fall_loop

#fall_done					; Embed it in the mat
	move	a8,a0
	calla	DELOBJ

	move	a9,a0
	sll	16,a0
	move	a10,a1
	sll	16,a1
	movi	YKLIGHT02A,a2			; This is an embedded light
	movi	(1000h|RING_Z_CENTER)+10h,a3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4
	cmpi	200,a9
	jrlt	#no_lt2a_flip
	ori	M_FLIPH,a4
#no_lt2a_flip
	movi	CLSFINI,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ
	.if 1
	move	a9,a0
	sll	16,a0
	move	a10,a1
	sll	16,a1
	movi	YKLIGHT02B,a2			; This is an embedded light lens
	movi	(1000h|RING_Z_CENTER)+20h,a3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4
	cmpi	200,a9
	jrlt	#no_lt2b_flip
	ori	M_FLIPH,a4
#no_lt2b_flip
	movi	CLSFINI,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ
	.endif

;	CREATE0	buzz_wire			; Make the wire buzz around
;	CREATE0	shatter_lens			; Shatter the lens

	SLEEPK	5

	movk	15,a0
#more_smoke
	movi	lt_smk_tbl,a11			; Make it smoke
#smoke_loop
	move	*a11+,a2,L
	jrz	#smoke_done
	move	a9,a0
	sll	16,a0
	move	a10,a1
	sll	16,a1
	movi	(1000h|RING_Z_CENTER)+30h,a3
	movi	DMAWNZ|M_3D|M_SCRNREL,a4
	cmpi	200,a9
	jrlt	#no_smk_flip
	ori	M_FLIPH,a4
#no_smk_flip
	movi	CLSFINI,a5
	clr	a6
	clr	a7

	calla	BEGINOBJ

	PUSHP	a0
	SLEEPK	5
	PULLP	a0

	move	a8,a0
	calla	DELOBJ

	jruc	#smoke_loop
#smoke_done
	dsj	a0,#more_smoke

	SLEEP	TSEC*5

	movi	CLSFINI,a0
	calla	obj_del1c

	DIE
	
******************************************************************************

	.end
