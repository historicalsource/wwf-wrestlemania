**************************************************************
*
* Software:     Jason Skiles
* Initiated:    25 Apr 94
*
* COPYRIGHT (C) 1993 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"lifebar.h"
	.title	"meters, names, messages, and scores"
	.width	132
	.option	b,d,l,t
	.mnolist

	.ref	adjust_health
	.ref	get_health


* INCLUDE AFTER GAME.EQU

******************************************************************************
GETLIFE	.macro
	move	*a13(PLYRNUM),a1
	calla	get_health
	.endm
******************************************************************************

