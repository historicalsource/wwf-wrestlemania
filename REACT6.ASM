**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		8/8/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"react6.asm"
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

	.ref	change_anim1a
;	.ref	inc_burnout
	.ref	set_getup_time
	.ref	wres_collis_off

******************************************************************************
* EXTERNAL ANIM SEQUENCES

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************
;AMODE_ATT28	28
 SUBR	hit_att28

	rets


#*****************************************************************************
;AMODE_ATT29	29
 SUBR	hit_att29

	rets


******************************************************************************

	.end
