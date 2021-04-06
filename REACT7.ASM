**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		8/8/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"react7.asm"
	.title	"wrester reactions to hits"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"macros.h"
	.include	"mproc.equ"		;Mproc equates
	.include	"display.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"sys.equ"
	.include	"game.equ"
	.include	"plyr.equ"
	.include	"anim.equ"
	.include	"audit.equ"
	.include	"sound.h"
	.include 	"ring.equ"
	.include	"lifebar.h"


******************************************************************************
* EXTERNAL REFERENCES

******************************************************************************
* EXTERNAL ANIM SEQUENCES

;BAM BAM
;DOINK
;BRET
;LEX
;RAZOR
;SHAWN
;TAKER
;YOKO


******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************


#*****************************************************************************
;AMODE_ATT30	30
 SUBR	hit_att30

	rets


#*****************************************************************************
;AMODE_ATT31	31
 SUBR	hit_att31

	rets


#*****************************************************************************
;AMODE_ATT32	32
 SUBR	hit_att32

	rets


#*****************************************************************************
;AMODE_ATT33	33
 SUBR	hit_att33

	rets


#*****************************************************************************
;AMODE_ATT34	34
 SUBR	hit_att34

	rets


******************************************************************************

	.end
