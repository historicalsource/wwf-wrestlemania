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
	.include	"game.equ"

	.REF	MAYBE_GIDDUP


#*****************************************************************************
* WRESTLER HAS JUST BEEN HIT
*
* a10 = * offensive process (attacker)
* a13 = * defensive process (victim)

 SUBR	set_getup_time

	PUSH	a0,a1,A8
	move	*a13(GETUP_TIME),a14
	jrnz	#out
	move	*a10(ATTACK_MODE),a0	;type of attack that hit
	X64	a0
	addi	#hit_table,a0
	MOVE	A0,A8
	move	*a0,a0,L
	move	*a13(WRESTLERNUM),a1
	X16	a1
	add	a1,a0
	move	*a0,a0
	move	a0,*a13(GETUP_TIME)
	move	*a13(DELAY_METER),A0
	JRNZ	#out
	MOVE	*A8(020H),A0,L
	JRZ	#out
	CALL	A0
#out	PULL	a0,a1,A8
	rets

#hit_table
	.long	_punch,0		;0
	.long	_hdbutt,0		;1
	.long	_kick,MAYBE_GIDDUP		;2
	.long	_flykick,MAYBE_GIDDUP	;3
	.long	_grabthrow,0	;4

	.long	_uprcut,MAYBE_GIDDUP		;5
	.long	_lbowdrop,0	;6
	.long	_grabhold,0	;7
	.long	_grabfling,0	;8
	.long	_push,0		;9

	.long	_hiptoss,MAYBE_GIDDUP	;10
	.long	_bigboot,MAYBE_GIDDUP	;11
	.long	_knee,0		;12
	.long	_grapple,0	;13
	.long	_superpunch,0	;14

	.long	_stomp,0		;15
	.long	_spinkick,0	;16
	.long	_cline,MAYBE_GIDDUP		;17
	.long	_headhold,0	;18
	.long	_jumpkick,0	;19

	.long	_run,0		;20
	.long	_puppet,0		;21
	.long	_backhand,0	;22
	.long	_buzz,0		;23
	.long	_haymaker,0 	;24

	.long	_blbowdrop,MAYBE_GIDDUP	;25
	.long	_bstomp,MAYBE_GIDDUP		;26
	.long	_headknees,0	;27

	.long	_earslap,0	;28
	.long	_hammer,MAYBE_GIDDUP		;29

	.long	_buttstomp,0	;30
	.long	_null,0		;31
	.long	_null,0		;32
	.long	_tomb,0		;33
	.long	_bigknee,MAYBE_GIDDUP	;34

	.long	_shnbfkik,0	;35
	.long	_shnspdkik,0	;36
	.long	_shnspdkik2,MAYBE_GIDDUP	;37
	.long	_null,0		;38
	.long	_armbreak,MAYBE_GIDDUP	;39

	.long	_buttdrop,0	;40
	.long	_null,0		;41
	.long	_null,0		;42
	.long	_null,0		;43
	.long	_null,0		;44
	.long	_null,0		;45
	.long	_null,0		;46
	.long	_null,0		;47

#************************
;DEFAULT
_null
;	.word	1,1,1,1,1,1,1,1,1,1	;get right back up
	.word	0,0,0,0,0,0,0,0,0,0	;get right back up

#************************
_punch
_hdbutt
_kick
_grabthrow
_uprcut
_lbowdrop
_grabhold
_grabfling
_push
_knee
_grapple   
_superpunch
_stomp	   
_buttstomp
_spinkick  
_cline	   
_headhold  
_jumpkick  
_run	   
_puppet	   
_backhand  
_buzz	   
_haymaker  
_blbowdrop 
_bstomp	   
_headknees 
_earslap   
_hammer	   
_tomb	   
_shnbfkik  
_shnspdkik 
_shnspdkik2
_armbreak  
_buttdrop  
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
;AMODE_HIPTOSS	10
;AMODE_BIGBOOT	11
_hiptoss
_bigboot
_flykick
_bigknee
	.word	STAY_TIME	;0	(Bret)
	.word	STAY_TIME	;1	(Razor)
	.word	STAY_TIME	;2	(Taker)
	.word	STAY_TIME	;3	(Yoko)
	.word	STAY_TIME	;4	(Shawn)
	.word	STAY_TIME	;5	(Bam Bam)
	.word	STAY_TIME	;6	(Doink)
	.word	STAY_TIME	;7	(Adam)
	.word	STAY_TIME	;8	(Lex)
	.word	STAY_TIME	;9	(Referee)


******************************************************************************

	.end
