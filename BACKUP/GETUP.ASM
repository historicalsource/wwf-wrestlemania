**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		5/1/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"getup.asm"
	.title	"getup time tables"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"macros.h"
	.include	"mproc.equ"
	.include	"sys.equ"
	.include	"plyr.equ"


#*****************************************************************************
* WRESTLER HAS JUST BEEN HIT
*
* a10 = * offensive process (attacker)
* a13 = * defensive process (victim)

 SUBR	set_getup_time

	PUSH	a0,a1
	move	*a13(GETUP_TIME),a14
	jrnz	#out
	move	*a10(ATTACK_MODE),a0	;type of attack that hit
	X32	a0
	addi	#hit_table,a0
	move	*a0,a0,L
	move	*a13(WRESTLERNUM),a1
	X16	a1
	add	a1,a0
	move	*a0,a0
	move	a0,*a13(GETUP_TIME)
#out	PULL	a0,a1
	rets

#hit_table
	.long	_punch		;0
	.long	_hdbutt		;1
	.long	_kick		;2
	.long	_flykick	;3
	.long	_grabthrow	;4

	.long	_uprcut		;5
	.long	_lbowdrop	;6
	.long	_grabhold	;7
	.long	_grabfling	;8
	.long	_push		;9

	.long	_hiptoss	;10
	.long	_bigboot	;11
	.long	_knee		;12
	.long	_grapple	;13
	.long	_superpunch	;14

	.long	_stomp		;15
	.long	_spinkick	;16
	.long	_cline		;17
	.long	_headhold	;18
	.long	_jumpkick	;19

	.long	_run		;20
	.long	_puppet		;21
	.long	_backhand	;22
	.long	_buzz		;23
	.long	_haymaker 	;24

	.long	_blbowdrop	;25
	.long	_bstomp		;26
	.long	_headknees	;27

	.long	_earslap	;28
	.long	_hammer		;29

	.long	_buttstomp	;30
	.long	_null		;31
	.long	_null		;32
	.long	_tomb		;33
	.long	_bigknee	;34

	.long	_shnbfkik	;35
	.long	_shnspdkik	;36
	.long	_shnspdkik2	;37
	.long	_null		;38
	.long	_armbreak	;39

	.long	_buttdrop	;40
	.long	_null		;41
	.long	_null		;42
	.long	_null		;43
	.long	_null		;44

#************************
;DEFAULT
_null
;	.word	1,1,1,1,1,1,1,1,1,1	;get right back up
	.word	0,0,0,0,0,0,0,0,0,0	;get right back up

#************************
;AMODE_PUNCH	0
_punch
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)

#************************
;AMODE_HDBUTT	1
_hdbutt
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
;AMODE_KICK	2
_kick
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
;AMODE_FLYKICK	3
_flykick
_bigknee
	.word	300	;0	(Bret)
	.word	300	;1	(Razor)
	.word	300	;2	(Taker)
	.word	300	;3	(Yoko)
	.word	300	;4	(Shawn)
	.word	300	;5	(Bam Bam)
	.word	300	;6	(Doink)
	.word	300	;7	(Adam)
	.word	300	;8	(Lex)
	.word	300	;9	(Referee)


#************************
;AMODE_GRABTHROW 4
_grabthrow
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
;AMODE_UPRCUT	5
_uprcut
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
;AMODE_LBOWDROP	6
_lbowdrop
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
;AMODE_GRABHOLD	7
_grabhold
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
;AMODE_GRABFLING 8
_grabfling
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
;AMODE_PUSH	9
_push
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
;AMODE_HIPTOSS	10
_hiptoss
;MJT Start
;	.word	000	;0	(Bret)
;	.word	000	;1	(Razor)
;	.word	000	;2	(Taker)
;	.word	000	;3	(Yoko)
;	.word	000	;4	(Shawn)
;	.word	000	;5	(Bam Bam)
;	.word	000	;6	(Doink)
;	.word	000	;7	(Adam)
;	.word	000	;8	(Lex)
;	.word	000	;9	(Referee)

;MJT End

#************************
;AMODE_BIGBOOT	11
_bigboot
	.word	300	;0	(Bret)
	.word	300	;1	(Razor)
	.word	300	;2	(Taker)
	.word	300	;3	(Yoko)
	.word	300	;4	(Shawn)
	.word	300	;5	(Bam Bam)
	.word	300	;6	(Doink)
	.word	300	;7	(Adam)
	.word	300	;8	(Lex)
	.word	300	;9	(Referee)


#************************
;AMODE_KNEE	12
_knee
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
_grapple	;13
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
_superpunch	;14
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)

#************************
_stomp		;15
_buttstomp
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)

#************************
_spinkick	;16
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)

#************************
_cline		;17
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)

#************************
_headhold		;18
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
_jumpkick		;19
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
_run			;20
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
_puppet		;21
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
_backhand		;22
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
_buzz		;23
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
_haymaker		;24
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
_blbowdrop		;25
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
_bstomp		;26
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
_headknees		;27
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
_earslap		;28
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


#************************
_hammer			;29
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)

#************************
_tomb	    		;33
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)

#************************
_shnbfkik		;35
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)

#************************
_shnspdkik		;36
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)

#************************
_shnspdkik2		;37
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)

#************************
_armbreak		;39
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)

#************************
_buttdrop		;40
	.word	000	;0	(Bret)
	.word	000	;1	(Razor)
	.word	000	;2	(Taker)
	.word	000	;3	(Yoko)
	.word	000	;4	(Shawn)
	.word	000	;5	(Bam Bam)
	.word	000	;6	(Doink)
	.word	000	;7	(Adam)
	.word	000	;8	(Lex)
	.word	000	;9	(Referee)


******************************************************************************

	.end
