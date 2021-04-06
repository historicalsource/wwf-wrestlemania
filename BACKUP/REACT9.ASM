**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		8/8/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"react9.asm"
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
;AMODE_BUTTDROP	40
 SUBR	hit_buttdrop

	rets

#*****************************************************************************
;AMODE_ATT41	41
 SUBR	hit_att41

	rets


#*****************************************************************************
;AMODE_ATT42	42
 SUBR	hit_att42

	rets


#*****************************************************************************
;AMODE_ATT43	43
 SUBR	hit_att43

	rets


#*****************************************************************************
;AMODE_ATT44	44
 SUBR	hit_att44

	rets


******************************************************************************

	.end
