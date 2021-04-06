**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		5/7/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"tables.asm"
	.title	"various data tables"
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


******************************************************************************
* EXTERNAL REFERENCES

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
*
* ARGUMENTS:	a0  = target area
*		a11 = * target wrestler process
*		a13 = * wrestler process
*
* TRASHES:	a0,a1,a14
*
 SUBR	set_target_offsets


	move	*a11(WRESTLERNUM),a14
	movi	5,a1
	mpyu	a14,a1

	add	a0,a1			; + target area
	movi	3*16,a0
	mpyu	a0,a1			; * 3 WORDS

	move	*a11(PLYRMODE),a0
	X32	a0
	addi	#mode_table,a0
	move	*a0,a0,L
	add	a0,a1

	move	*a1+,a0
	move	a0,*a13(TGT_XOFF)
	move	*a1+,a0
	move	a0,*a13(TGT_YOFF)
	move	*a1,a0
	move	a0,*a13(TGT_ZOFF)

	rets


******************************************************************************
*
* >a0=wrestler ptr, <a0=height (word)

 SUBR	get_mode_height

	PUSH	a1

	move	*a0(WRESTLERNUM),a1

	;mult a1 by 15, then by 10h, then add 10h
	move	a1,a14
	X16	a1
	sub	a14,a1
	X16	a1

	addk	10h,a1		;head Y

	move	*a0(PLYRMODE),a0
	X32	a0
	addi	#mode_table,a0
	move	*a0,a0,L
	add	a1,a0
	move	*a0,a0,W

	PULL	a1

	rets

#mode_table
	.long	mode_normal		;0
	.long	mode_running		;1
	.long	mode_inair		;2
	.long	mode_attached		;3
	.long	mode_onground		;4
	.long	mode_bouncing		;5
	.long	mode_onturnbkl		;6
	.long	mode_block		;7
	.long	mode_dizzy		;8
	.long	mode_dead		;9
	.long	mode_oppoverhead	;10
	.long	mode_climbturnbkl	;11
	.long	mode_waitanim		;12
	.long	mode_grapple		;13
	.long	mode_master		;14
	.long	mode_slave		;15
	.long	mode_headhold		;16
	.long	mode_normal	;17
	.long	mode_normal	;18
	.long	mode_headheld		;19
	.long	mode_puppet		;20
	.long	mode_inair2		;21
	.long	mode_normal	;22
	.long	mode_normal	;23
	.long	mode_chokehold		;24
	.long	mode_choking		;25


************************
mode_normal		;0
mode_running		;1
mode_inair		;2
mode_attached		;3
mode_block		;7
mode_dizzy		;8
mode_grapple		;13
mode_master		;14
mode_slave		;15
mode_headhold		;16
;mode_headheld		;19
mode_puppet		;20
mode_inair2		;21
mode_chokehold		;24
mode_choking		;25

;		x,y,z
;0 Bret Hart
	.word	7,105,0		;0 HEAD
	.word	6,85,0		;1 CHEST
	.word	0,57,0		;2 GROIN
	.word	17,37,0		;3 KNEES
	.word	21,9,0		;4 FEET
;1 Razor Ramon
	.word	11,106,0	;0 HEAD
	.word	6,86,0		;1 CHEST
	.word	1,58,0		;2 GROIN
	.word	21,34,0		;3 KNEES
	.word	20,4,0		;4 FEET
;2 Undertaker
	.word	11,110,0	;0 HEAD
	.word	6,88,0		;1 CHEST
	.word	1,61,0		;2 GROIN
	.word	13,36,0		;3 KNEES
	.word	8,5,0		;4 FEET
;3 Yokozuna
	.word	10,100,0	;0 HEAD
	.word	8,79,0		;1 CHEST
	.word	2,46,0		;2 GROIN
	.word	17,28,0		;3 KNEES
	.word	2,5,0		;4 FEET

;4 Shawn Michaels
	.word	4,97,0		;0 HEAD
	.word	2,77,0		;1 CHEST
	.word	-3,49,0		;2 GROIN
	.word	1,32,0		;3 KNEES
	.word	2,3,0		;4 FEET

;5 Bam Bam
	.word	6,103,0		;0 HEAD
	.word	5,86,0		;1 CHEST
	.word	1,54,0		;2 GROIN
	.word	20,33,0		;3 KNEES
	.word	26,7,0		;4 FEET
;6 Doink
	.word	6,100,0		;0 HEAD
	.word	6,75,0		;1 CHEST
	.word	6,51,0		;2 GROIN
	.word	19,30,0		;3 KNEES
	.word	20,7,0		;4 FEET
;7 Adam Bomb
	.word	0,0,0		;0 HEAD
	.word	0,0,0		;1 CHEST
	.word	0,0,0		;2 GROIN
	.word	0,0,0		;3 KNEES
	.word	0,0,0		;4 FEET
;8 Lex Luger
	.word	4,107,0		;0 HEAD
	.word	4,88,0		;1 CHEST
	.word	1,59,0		;2 GROIN
	.word	20,37,0		;3 KNEES
	.word	20,9,0		;4 FEET



************************
mode_onground		;4
;This is for dead mode on the ground!?!?!?!
mode_dead		;9
;		x,y,z
;0 Bret Hart

	.word	51,9,0		;0 HEAD
	.word	23,9,0		;1 CHEST
	.word	-2,8,0		;2 GROIN
	.word	-33,7,0		;3 KNEES
	.word	-69,9,0		;4 FEET

;1 Razor Ramon
	.word	53,11,0		;0 HEAD
	.word	22,15,0		;1 CHEST
	.word	-4,14,0		;2 GROIN
	.word	-36,13,0	;3 KNEES
	.word	-77,12,0	;4 FEET
;2 Undertaker
	.word	62,18,0		;0 HEAD
	.word	23,0,0		;1 CHEST
	.word	-6,19,0		;2 GROIN
	.word	-37,16,0	;3 KNEES
	.word	-73,15,0	;4 FEET
;3 Yokozuna
	.word	47,18,0		;0 HEAD
	.word	21,20,0		;1 CHEST
	.word	-6,20,0		;2 GROIN
	.word	-26,28,0	;3 KNEES
	.word	-48,18,0	;4 FEET

;4 Shawn Michaels
	.word	47,10,0		;0 HEAD
	.word	20,12,0		;1 CHEST
	.word	-6,11,0		;2 GROIN
	.word	-32,15,0	;3 KNEES
	.word	-70,6,0		;4 FEET

;5 Bam Bam
	.word	67,0,0		;0 HEAD
	.word	25,0,0		;1 CHEST
	.word	-2,0,0		;2 GROIN
	.word	-38,0,0		;3 KNEES
	.word	-12,0,0		;4 FEET
;6 Doink
	.word	40,11,0		;0 HEAD
	.word	12,13,0		;1 CHEST
	.word	-12,15,0	;2 GROIN
	.word	-35,17,0	;3 KNEES
	.word	-65,10,0	;4 FEET
;7 Adam Bomb
	.word	0,0,0		;0 HEAD
	.word	0,0,0		;1 CHEST
	.word	0,0,0		;2 GROIN
	.word	0,0,0		;3 KNEES
	.word	0,0,0		;4 FEET
;8 Lex Luger
	.word	54,14,0		;0 HEAD
	.word	29,16,0		;1 CHEST
	.word	-3,16,0		;2 GROIN
	.word	-32,15,0	;3 KNEES
	.word	-55,14,0	;4 FEET

************************
mode_bouncing		;5
mode_onturnbkl		;6
mode_oppoverhead	;10
mode_climbturnbkl	;11
mode_waitanim		;12
;		x,y,z
;0 Bret Hart
	.word	7,105,0		;0 HEAD
	.word	6,85,0		;1 CHEST
	.word	0,57,0		;2 GROIN
	.word	17,37,0		;3 KNEES
	.word	21,9,0		;4 FEET
;1 Razor Ramon
	.word	2,110,0		;0 HEAD
	.word	4,87,0		;1 CHEST
	.word	5,60,0		;2 GROIN
	.word	17,33,0		;3 KNEES
	.word	22,3,0		;4 FEET
;2 Undertaker
	.word	11,110,0	;0 HEAD
	.word	6,88,0		;1 CHEST
	.word	1,61,0		;2 GROIN
	.word	13,36,0		;3 KNEES
	.word	8,5,0		;4 FEET
;3 Yokozuna
	.word	5,109,0		;0 HEAD
	.word	0,91,0		;1 CHEST
	.word	-2,53,0		;2 GROIN
	.word	8,33,0		;3 KNEES
	.word	14,10,0		;4 FEET

;4 Shawn Michaels
	.word	15,94,0		;0 HEAD
	.word	9,75,0		;1 CHEST
	.word	1,52,0		;2 GROIN
	.word	4,31,0		;3 KNEES
	.word	-1,0,0		;4 FEET
;5 Bam Bam
	.word	6,103,0		;0 HEAD
	.word	5,86,0		;1 CHEST
	.word	1,54,0		;2 GROIN
	.word	20,33,0		;3 KNEES
	.word	26,7,0		;4 FEET
;6 Doink
	.word	6,100,0		;0 HEAD
	.word	6,75,0		;1 CHEST
	.word	6,51,0		;2 GROIN
	.word	19,30,0		;3 KNEES
	.word	20,7,0		;4 FEET
;7 Adam Bomb
	.word	0,0,0		;0 HEAD
	.word	0,0,0		;1 CHEST
	.word	0,0,0		;2 GROIN
	.word	0,0,0		;3 KNEES
	.word	0,0,0		;4 FEET
;8 Lex Luger
	.word	4,107,0		;0 HEAD
	.word	4,88,0		;1 CHEST
	.word	1,59,0		;2 GROIN
	.word	20,37,0		;3 KNEES
	.word	20,9,0		;4 FEET
 
************************
mode_headheld		;19
;0 Bret Hart
	.word	39,58,0		;0 HEAD
	.word	9,62,0		;1 CHEST
	.word	-8,55,0		;2 GROIN
	.word	-2,36,0		;3 KNEES
	.word	3,2,0		;4 FEET
;1 Razor Ramon
	.word	30,49,0		;0 HEAD
	.word	5,57,0		;1 CHEST
	.word	-13,54,0	;2 GROIN
	.word	0,34,0		;3 KNEES
	.word	-4,2,0		;4 FEET
;2 Undertaker
	.word	38,67,0		;0 HEAD
	.word	13,67,0		;1 CHEST
	.word	-10,58,0	;2 GROIN
	.word	13,38,0		;3 KNEES
	.word	6,6,0		;4 FEET
;3 Yokozuna
	.word	34,61,0		;0 HEAD
	.word	9,56,0		;1 CHEST
	.word	-12,50,0	;2 GROIN
	.word	-7,29,0		;3 KNEES
	.word	-1,4,0		;4 FEET
;4 Shawn Michaels
	.word	35,56,0		;0 HEAD
	.word	12,57,0		;1 CHEST
	.word	-10,53,0	;2 GROIN
	.word	1,34,0		;3 KNEES
	.word	0,8,0		;4 FEET
;5 Bam Bam
	.word	46,60,0		;0 HEAD
	.word	20,56,0		;1 CHEST
	.word	-1,49,0		;2 GROIN
	.word	6,32,0		;3 KNEES
	.word	15,7,0		;4 FEET
;6 Doink
	.word	33,61,0		;0 HEAD
	.word	6,63,0		;1 CHEST
	.word	-13,53,0	;2 GROIN
	.word	-2,33,0		;3 KNEES
	.word	5,4,0		;4 FEET
;7 Adam Bomb
	.word	0,0,0		;0 HEAD
	.word	0,0,0		;1 CHEST
	.word	0,0,0		;2 GROIN
	.word	0,0,0		;3 KNEES
	.word	0,0,0		;4 FEET
;8 Lex Luger
	.word	48,62,0		;0 HEAD
	.word	20,54,0		;1 CHEST
	.word	1,46,0		;2 GROIN
	.word	27,31,0		;3 KNEES
	.word	19,6,0		;4 FEET

******************************************************************************

	.end
