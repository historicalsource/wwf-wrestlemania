**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		10/12/93
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"admseq2.asm"
	.title	"Adam Bomb animation sequences"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"macros.h"
	.include	"mproc.equ"		;Mproc equates
	.include	"sys.equ"
	.include	"display.equ"
	.include	"game.equ"
	.include	"plyr.equ"
	.include	"anim.equ"
	.include	"sound.h"

	.include	"adamimg.h"


******************************************************************************
* EXTERNAL REFERENCES

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

TSEC 	equ	53

#*****************************************************************************
*
* NORMAL #2 PUNCH

#PUNCH_SPD	equ	3
 SUBR	adm_2_punch_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	2,A2PU3D+FR1
	WL	2,A2PU3D+FR2
	WL	5,A2PU3D+FR3
	WL	3,A2PU3D+FR4
	WL	3,A2PU3D+FR5

	.word	ANI_ATTACK_ON, AMODE_PUNCH,78,104,38,14	;mode,x,y,w,h
	WL	5,A2PU3D+FR6
	.word	ANI_ATTACK_OFF

	WL	3,A2PU3D+FR7
	WL	3,A2PU3D+FR8
	WL	3,A2PU3D+FR9
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* NORMAL #4 PUNCH

 SUBR	adm_4_punch_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	2,A4PU3C+FR1
	WL	2,A4PU3C+FR2
	WL	5,A4PU3C+FR3
	WL	3,A4PU3C+FR4
	WL	3,A4PU3C+FR5

	.word	ANI_ATTACK_ON, AMODE_PUNCH,88,100,38,14	;mode,x,y,w,h
	WL	5,A4PU3C+FR6
	.word	ANI_ATTACK_OFF

	WL	3,A4PU3C+FR7
	WL	3,A4PU3C+FR8
	WL	3,A4PU3C+FR9
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 UPPERCUT

 SUBR	adm_2_uprcut_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	3,A2UP3A+FR1
	WL	3,A2UP3A+FR3
	WL	3,A2UP3A+FR4
	WL	3,A2UP3A+FR5

	.word	ANI_ATTACK_ON, AMODE_UPRCUT,58,130,30,50 ;mode,x,y,w,h
	WL	10,A2UP3A+FR6
	.word	ANI_ATTACK_OFF

	WL	4,A2UP3A+FR7
	WL	4,A2UP3A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #4 UPPERCUT

 SUBR	adm_4_uprcut_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	4,A4UP3A+FR1
	WL	3,A4UP3A+FR2
	WL	3,A4UP3A+FR3
	WL	3,A4UP3A+FR4
	WL	3,A4UP3A+FR5

	.word	ANI_ATTACK_ON, AMODE_UPRCUT,53,140,20,62 ;mode,x,y,w,h
	WL	10,A4UP3A+FR6
	.word	ANI_ATTACK_OFF
	WL	4,A4UP3A+FR7
	WL	4,A4UP3A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END
	
#*****************************************************************************
*
* #2 HEADBUTT

#BUTT_SPD	equ	3
 SUBR	adm_2_butt_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	#BUTT_SPD,A2BC3B+FR1
	WL	#BUTT_SPD,A2BC3B+FR2
	WL	#BUTT_SPD,A2BC3B+FR3

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,42,119,23,23	;mode,x,y,w,h
	WL	#BUTT_SPD,A2BC3B+FR4
	.word	ANI_ATTACK_OFF

	WL	#BUTT_SPD,A2BC3B+FR5
	WL	#BUTT_SPD,A2BC3B+FR6
	WL	#BUTT_SPD,A2BC3B+FR7
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #4 HEADBUTT

#BUTT_SPD	equ	3
 SUBR	adm_4_butt_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	#BUTT_SPD,A4BC3A+FR2
	WL	#BUTT_SPD,A4BC3A+FR3

	.word	ANI_ATTACK_ON, AMODE_HDBUTT,37,118,28,23	;mode,x,y,w,h
	WL	#BUTT_SPD,A4BC3A+FR4
	.word	ANI_ATTACK_OFF

	WL	#BUTT_SPD,A4BC3A+FR5
	WL	#BUTT_SPD,A4BC3A+FR6
	WL	#BUTT_SPD,A4BC3A+FR7
	WL	#BUTT_SPD,A4BC3A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* NORMAL #2 KICK

 SUBR	adm_2_kick_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	3,A2KM3A+FR1
	WL	3,A2KM3A+FR2
	WL	3,A2KM3A+FR3

	.word	ANI_ATTACK_ON, AMODE_KICK,92,85,40,20	;mode,x,y,w,h
	WL	8,A2KM3A+FR4
	.word	ANI_ATTACK_OFF

	WL	3,A2KM3A+FR5
	WL	3,A2KM3A+FR6
	WL	3,A2KM3A+FR7
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* NORMAL #4 KICK

 SUBR	adm_4_kick_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	2,A4KM3C+FR1
	WL	2,A4KM3C+FR2
	WL	2,A4KM3C+FR3
;	WL	2,A4KM3C+FR4
	WL	3,A4KM3C+FR5

	.word	ANI_ATTACK_ON, AMODE_KICK,88,80,40,20	;mode,x,y,w,h
	WL	8,A4KM3C+FR6
	.word	ANI_ATTACK_OFF

	WL	3,A4KM3C+FR7
	WL	3,A4KM3C+FR8
	WL	3,A4KM3C+FR9
;	WL	2,A4KM3C+FR10
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 KNEE

;not currently implemented
#KNEE_SPD	equ	4
 SUBR	adm_2_knee_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	#KNEE_SPD,A2NM3A+FR1
	WL	#KNEE_SPD,A2NM3A+FR2
	WL	#KNEE_SPD,A2NM3A+FR3
	WL	#KNEE_SPD,A2NM3A+FR4
	WL	#KNEE_SPD,A2NM3A+FR5
	WL	#KNEE_SPD,A2NM3A+FR6
	WL	#KNEE_SPD,A2NM3A+FR7
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #4 KNEE

;not currently implemented
#KNEE_SPD	equ	4
 SUBR	adm_4_knee_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	#KNEE_SPD,A4NM3A+FR1
	WL	#KNEE_SPD,A4NM3A+FR2
	WL	#KNEE_SPD,A4NM3A+FR3
	WL	#KNEE_SPD,A4NM3A+FR4
	WL	#KNEE_SPD,A4NM3A+FR5
	WL	#KNEE_SPD,A4NM3A+FR6
	WL	#KNEE_SPD,A4NM3A+FR7
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #3 FLYING KICK

#FKICK_SPD	equ	3

 SUBR	adm_flying_kick_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
;	WL	3,A3DC3B+FR1
;	WL	2,A3DC3B+FR2
	WL	2,A3DC3B+FR3
	WL	ANI_CODE,#get_xvel
	WL	ANI_SET_YVEL,70000h

	WL	6,A3DC3B+FR4
	WL	7,A3DC3B+FR5

	.word	ANI_ATTACK_ON, AMODE_FLYKICK,90,90,67,37 ;mode,x,y,w,h
	WL	7,A3DC3B+FR6
	.word	ANI_ATTACK_OFF

	WL	6,A3DC3B+FR7
	WL	3,A3DC3B+FR8
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SOUND,bounce_l1
	WL	3,A3DC3B+FR9
	.word	ANI_XFLIP

	WL	ANI_GOTO,adm_facedown_getup_anim


;Give player correct XVEL
 SUBRP	#get_xvel


	move	*a13(FACING_DIR),a0

	move	*a13(OBJ_XVEL),a14,L
	jrnz	#mv

	;Wrestler not moving toward opponent

	movi	20000h,a1
	btst	PLAYER_RIGHT_BIT,a0
	jrnz	#setxvel

	movi	-20000h,a1
	jruc	#setxvel

#mv
	;Is wrestler backing away from opponent?
	move	*a13(FACING_DIR),a1
	btst	MOVE_LEFT_BIT,a1
	jrnz	#face_lft
	clr	a1
	move	a14,a14
	jrn	#setxvel		;Wrestler was back pedaling
	jruc	#lunge
#face_lft
	clr	a1
	move	a14,a14
	jrnn	#setxvel 		;Wrestler was back pedaling

#lunge
	;Will lunge kick forward
	movi	40000h,a1
	btst	PLAYER_RIGHT_BIT,a0
	jrnz	#setxvel

	movi	-40000h,a1
#setxvel
	move	a1,*a13(OBJ_XVEL),L
	rets


#*****************************************************************************
*
* BODY HIT

#BODY_HIT_SPD	equ	3
 SUBR	adm_4_body_hit_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	ANI_CODE,#get_xvel
	WL	ANI_SET_YVEL,48000h
	WL	4,A4AM4B+FR1
	WL	4,A4AM4B+FR2
	WL	6,A4AM4B+FR3
	WL	4,A4AM4B+FR4
	.word	ANI_ZEROVELS
	WL	6,A4AM4B+FR5
	WL	3,A4AM4B+FR6
	WL	3,A4AM4B+FR7
	WL	ANI_CODE,#setface
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	adm_2_body_hit_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	ANI_CODE,#get_xvel
	WL	ANI_SET_YVEL,48000h
	WL	4,A2AM2A+FR1
	WL	4,A2AM2A+FR2
	WL	6,A2AM2A+FR3
	WL	4,A2AM2A+FR4
	.word	ANI_ZEROVELS
	WL	6,A2AM2A+FR5
	WL	3,A2AM2A+FR6
	WL	3,A2AM2A+FR7
	WL	ANI_CODE,#setface
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#setface
;Need to set facing dir because of this odd getup sequence
	movk	10,a1
	move	*a13(OBJ_CONTROL),a0
	btst	B_FLIPH,a0
	jrz	#rgt
	movk	6,a1
#rgt	move	a1,*a13(FACING_DIR)
	rets

#get_xvel

;Give player correct XVEL
;BUG!!!  If this guy gets hit in the butt, he will lunge back into kicker!
;What is the best way to jump back from opponent?  Use the closest stuff?
;Maybe we should start the XVEL back when we start the BODY_HIT.

 	move	*a13(FACING_DIR),a0

	movi	20000h,a1
	btst	PLAYER_RIGHT_BIT,a0
	jrz	#setxvel

	movi	-20000h,a1
#setxvel
	move	a1,*a13(OBJ_XVEL),L
	rets


#*****************************************************************************
*
* FALL BACK

 SUBR	adm_fall_back_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	5,A3FD3B+FR1
	WL	5,A3FD3B+FR2
	WL	5,A3FD3B+FR3
	WL	5,A3FD3B+FR4
	.word	ANI_WAITHITGND
	WL	4,A3FD3B+FR5
	WL	4,A3FD3B+FR6
	WL	4,A3FD3B+FR7
	.word	ANI_SOUND,bounce_l1
	.word	ANI_SHAKER,3
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_END

#*****************************************************************************
*
* GET UP

 SUBR	adm_facedown_getup_anim
	WL	4,A3GD2A+FR1
	WL	4,A3GD2A+FR2
	WL	4,A3GD2A+FR3
	WL	4,A3GD2A+FR4
	WL	ANI_CODE,#choose_dir
	WL	ANI_IFSTATUS,#getup_in_2
#getup_in_4
	WL	4,A3GD4A+FR5
	WL	4,A3GD4A+FR6
	WL	4,A3GD4A+FR7
	WL	4,A3GD4A+FR8
	WL	ANI_GOTO,#getup_done
#getup_in_2
	WL	4,A3GD2A+FR5
	WL	4,A3GD2A+FR6
	WL	4,A3GD2A+FR7
	WL	4,A3GD2A+FR8
#getup_done
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


; Routine to choose #2 or #4 getup.  clear MODE_STATUS bit to start,
; then set if for a getup in 2, or leave clear for a getup in 4.

#choose_dir
	;facing dir is pretty much screwed at this point, so we'll re-
	;calculate it.  get the left or right bits from the B_FLIPH bit
	;in OBJ_CONTROL.  get the up or down bits from the facing_dir table.

	movi	MOVE_RIGHT,a1
	move	*a13(OBJ_CONTROL),a0
	btst	B_FLIPH,a0
	jrnz	#rgt
	movi	MOVE_LEFT,a1
#rgt
	ori	MOVE_DOWN,a1

	move	*a13(ANIMODE),a0
	andni	MODE_STATUS,a0
	move	a0,*a13(ANIMODE)

	move	*a13(NEW_FACING_DIR),a0
	btst	PLAYER_UP_BIT,a0
	jrz	#cd_done

	move	*a13(ANIMODE),a0
	ori	MODE_STATUS,a0
	move	a0,*a13(ANIMODE)

	andni	MOVE_DOWN,a1
	ori	MOVE_UP,a1
#cd_done
	move	a1,*a13(FACING_DIR)
	rets


;#getup_face
;	move	*a13(PLYRNUM),a0
;	sll	4,a0			;x 16
;	addi	facing_dir,a0
;	move	*a0,a0
;	move	*a13(OBJ_CONTROL),a1
;	btst	B_FLIPH,a1
;	jrz	#noflip
;	btst	MOVE_RIGHT_BIT,a0
;	jrz	#gf_done
;	xori	M_FLIPH,a1
;	move	a1,*a13(OBJ_CONTROL)
;	rets
;
;#noflip
;	btst	MOVE_LEFT_BIT,a0
;	jrz	#gf_done
;	xori	M_FLIPH,a1
;	move	a1,*a13(OBJ_CONTROL)
;#gf_done
;	rets


#GETUP_SPD	equ	4

 SUBR	adm_faceup_getup_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	#GETUP_SPD,A3GU4A+FR1
	WL	#GETUP_SPD,A3GU4A+FR2
	WL	#GETUP_SPD,A3GU4A+FR3
	WL	#GETUP_SPD,A3GU4A+FR4
	WL	#GETUP_SPD,A3GU4A+FR5
	WL	#GETUP_SPD,A3GU4A+FR6
	WL	#GETUP_SPD,A3GU4A+FR7
	WL	#GETUP_SPD,A3GU4A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #4 HEAD HIT

#HEAD_HIT_SPD	equ	3
#LB_SPEED	equ	3
 SUBR	adm_4_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	WL	#HEAD_HIT_SPD,A4AH4C+FR1
	WL	#HEAD_HIT_SPD,A4AH4C+FR2
	WL	#HEAD_HIT_SPD+1,A4AH4C+FR3
	WL	#HEAD_HIT_SPD+1,A4AH4C+FR4
	WL	#HEAD_HIT_SPD,A4AH4C+FR6
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #2 HEAD HIT

#HEAD_HIT_SPD	equ	3
#LB_SPEED	equ	3
 SUBR	adm_2_head_hit_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	WL	#HEAD_HIT_SPD,A2AH2A+FR1
	WL	#HEAD_HIT_SPD+1,A2AH2A+FR2
	WL	#HEAD_HIT_SPD+1,A2AH2A+FR3
	WL	#HEAD_HIT_SPD+1,A2AH2A+FR4
	WL	#HEAD_HIT_SPD+1,A2AH2A+FR5
	WL	#HEAD_HIT_SPD+1,A2AH2A+FR6

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* FACE HIT (HANDS ON FACE)

#FACE_2_HIT_SPD	equ	4
 SUBR	adm_2_face_hit_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_FRICTION,3000h
	WL	#FACE_2_HIT_SPD,A3AE2A+FR1
	WL	#FACE_2_HIT_SPD,A3AE2A+FR2
	WL	#FACE_2_HIT_SPD,A3AE2A+FR3
	WL	#FACE_2_HIT_SPD,A3AE2A+FR4
	WL	#FACE_2_HIT_SPD,A3AE2A+FR5
	WL	#FACE_2_HIT_SPD,A3AE2A+FR6
	WL	#FACE_2_HIT_SPD,A3AE2A+FR7
	.word	ANI_OFFSET,-13,0,0			;x,y,z
	WL	2,A2ST2D+FR1
	WL	ANI_CODE,#setface
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#FACE_4_HIT_SPD	equ	4
 SUBR	adm_4_face_hit_anim
	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_FRICTION,3000h
	WL	#FACE_4_HIT_SPD,A3AE4A+FR1
	WL	#FACE_4_HIT_SPD,A3AE4A+FR2
	WL	#FACE_4_HIT_SPD,A3AE4A+FR3
	WL	#FACE_4_HIT_SPD,A3AE4A+FR4
	WL	#FACE_4_HIT_SPD,A3AE4A+FR5
	WL	#FACE_4_HIT_SPD,A3AE4A+FR6
	WL	#FACE_4_HIT_SPD,A3AE4A+FR7
	.word	ANI_OFFSET,-13,0,0			;x,y,z
	WL	2,A4ST4J+FR1
	WL	ANI_CODE,#setface
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#setface
	movk	10,a1
	move	*a13(OBJ_CONTROL),a0
	btst	B_FLIPH,a0
	jrz	#rgt
	movk	6,a1
#rgt	move	a1,*a13(FACING_DIR)
	rets


#*****************************************************************************
*
* GRAB & THROW

;this isn't called yet.
#GRABTHR_SPD	equ	3
 SUBR	adm_grab_throw_anim
;	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_ZEROVELS
;	WL	#GRABTHR_SPD,A3GS3A+FR1
;	WL	#GRABTHR_SPD,A3GS3A+FR2
;
;	.word	ANI_ATTACK_ON, AMODE_GRABTHROW,80,75,32,31 ;mode,x,y,w,h
;	.word	ANI_ATTACHZ,76,54,0
;	WL	#GRABTHR_SPD,A3GS3A+FR3
;	WL	#GRABTHR_SPD,A3GS3A+FR4
;	.word	ANI_ATTACK_OFF
;
;	.word	ANI_ATTACH,63,69			;xoff,yoff
;	WL	#GRABTHR_SPD,A3GS3A+FR5
;
;	.word	ANI_ATTACH,56,81
;	WL	#GRABTHR_SPD,A3GS3A+FR6
;
;	.word	ANI_ATTACH,37,107
;	WL	#GRABTHR_SPD,A3GS3A+FR7
;
;	.word	ANI_ATTACH,15,121
;	WL	#GRABTHR_SPD,A3GS3A+FR8
;
;	.word	ANI_ATTACH,-8,118
;	WL	#GRABTHR_SPD,A3GS3A+FR9
;
;	.word	ANI_ATTACH,-33,104
;	WL	#GRABTHR_SPD,A3GS3A+FR10
;
;	.word	ANI_ATTACH,-59,48
;	WL	#GRABTHR_SPD,A3GS3A+FR11
;
;	.word	ANI_ATTACH,-53,37
;	WL	#GRABTHR_SPD,A3GS3A+FR12
;	.word	ANI_DETACH
;
;	WL	#GRABTHR_SPD,A3GS3A+FR13
;	WL	#GRABTHR_SPD,A3GS3A+FR14
;	WL	#GRABTHR_SPD,A3GS3A+FR15
;	WL	#GRABTHR_SPD,A3GS3A+FR16
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 FLYING CLOTHESLINE

#CLINE_SPD	equ	3
 SUBR	adm_2_fly_cline_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_INAIR
	WL	#CLINE_SPD,A3LC3A+FR1
	WL	#CLINE_SPD,A3LC3A+FR2
	WL	#CLINE_SPD,A3LC3A+FR3

	WL	ANI_SET_YVEL,58000h

	WL	#CLINE_SPD,A3LC3A+FR4

	.word	ANI_OFFSET,-5,50,0

	WL	#CLINE_SPD,A3LC3A+FR5
	WL	#CLINE_SPD,A3LC3A+FR6

	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_ZEROVELS
	.word	ANI_SHAKER,3
	.word	ANI_SOUND,bounce_l1

	WL	#CLINE_SPD,A3LC3A+FR7
	WL	#CLINE_SPD,A3LC3A+FR8
	WL	#CLINE_SPD,A3LC3A+FR9

	WL	ANI_GOTO,adm_facedown_getup_anim

#*****************************************************************************
*
* #4 FLYING CLOTHESLINE

#CLINE_SPD	equ	3
 SUBR	adm_4_fly_cline_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_INAIR
	WL	#CLINE_SPD,A3RC3A+FR1
	WL	#CLINE_SPD,A3RC3A+FR2
	WL	#CLINE_SPD,A3RC3A+FR3

	WL	ANI_SET_YVEL,58000h

	WL	#CLINE_SPD,A3RC3A+FR4
	WL	#CLINE_SPD,A3RC3A+FR5

	.word	ANI_OFFSET,0,43,0

	WL	#CLINE_SPD,A3RC3A+FR6

	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_ZEROVELS
	.word	ANI_SHAKER,3
	.word	ANI_SOUND,bounce_l1

	WL	#CLINE_SPD,A3RC3A+FR7
	WL	#CLINE_SPD,A3RC3A+FR8

	WL	ANI_GOTO,adm_facedown_getup_anim

#*****************************************************************************
*
* CARRYING FRAMES

carry2_anim
;	WL	1,S2CA2
	.word	ANI_END

carry4_anim
;	WL	1,S4CA4
	.word	ANI_END

#*****************************************************************************
*
* #2 ELBOW DROP

 SUBR	adm_2_lbowdrop_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	3,A2PJ2C+FR1
	WL	3,A2PJ2C+FR2
	WL	ANI_SET_YVEL,68000h
	WL	3,A2PJ2C+FR3
	.word	ANI_OFFSET,0,34,0
	WL	3,A2PJ2C+FR4
	.word	ANI_ATTACK_ON_Z, AMODE_LBOWDROP,50,40,-45,25,30,0 ;mode,x,y,z,w,h,d
	.word	ANI_WAITHITGND
	.word	ANI_SOUND,bounce_l1
	.word	ANI_SHAKER,3
	.word	ANI_SHAKEROPES,0
	WL	3,A2PJ2C+FR5
	WL	3,A2PJ2C+FR6
	.word	ANI_ATTACK_OFF
	WL	3,A2PJ2C+FR7
	WL	4,A3GD2A+FR6
	WL	4,A3GD2A+FR7
	WL	4,A3GD2A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #4 ELBOW DROP

 SUBR	adm_4_lbowdrop_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	4,A3PJ3B+FR1
	WL	4,A3PJ3B+FR2
	WL	ANI_SET_YVEL,68000h
	.word	ANI_OFFSET,0,34,0
	WL	4,A3PJ3B+FR3
	WL	4,A3PJ3B+FR4
	.word	ANI_ATTACK_ON_Z, AMODE_LBOWDROP,30,20,45,25,20,0 ;mode,x,y,z,w,h,d
	.word	ANI_WAITHITGND
	.word	ANI_SOUND,bounce_l1
	.word	ANI_SHAKER,3
	.word	ANI_SHAKEROPES,0
	WL	2,A3PJ3B+FR5
	WL	6,A3PJ3B+FR6
	.word	ANI_ATTACK_OFF
	WL	4,A3GD4A+FR4
	WL	4,A3GD4A+FR5
	WL	4,A3GD4A+FR6
	WL	4,A3GD4A+FR7
	WL	4,A3GD4A+FR8
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 STOMP ON FALLEN OPPONENT

#STOMP_SPD	equ	3
 SUBR	adm_2_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	#STOMP_SPD,A2JT2A+FR7
	WL	#STOMP_SPD,A2JT2A+FR8
	WL	#STOMP_SPD,A2JT2A+FR1

	WL	ANI_SET_YVEL,58000h

	WL	#STOMP_SPD,A2JT2A+FR2
	WL	#STOMP_SPD,A2JT2A+FR3
	WL	#STOMP_SPD,A2JT2A+FR4
	WL	#STOMP_SPD,A2JT2A+FR5
	.word	ANI_ATTACK_ON_Z, AMODE_LBOWDROP,38,40,-40,60,20,0 ;mode,x,y,z,w,h,d
	.word	ANI_WAITHITGND
	.word	ANI_ATTACK_OFF
	WL	#STOMP_SPD,A2JT2A+FR6
	WL	#STOMP_SPD,A2JT2A+FR7
	WL	#STOMP_SPD,A2JT2A+FR8
	WL	#STOMP_SPD,A2JT2A+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #4 STOMP ON FALLEN OPPONENT

#STOMP_SPD	equ	4
 SUBR	adm_4_stomp_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	#STOMP_SPD,A4MP4B+FR1
	WL	#STOMP_SPD,A4MP4B+FR2
	WL	#STOMP_SPD,A4MP4B+FR3

	.word	ANI_ATTACK_ON_Z, AMODE_LBOWDROP,28,19,40,17,19,0 ;mode,x,y,z,w,h,d
	WL	#STOMP_SPD,A4MP4B+FR4
	.word	ANI_ATTACK_OFF
	WL	#STOMP_SPD,A4MP4B+FR5
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* HITS ON GROUND

#HIT_SPD	equ	2
 SUBR	adm_hitonground_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	WL	#HIT_SPD,A3CP3A+FR1
	WL	#HIT_SPD,A3CP3A+FR2
	WL	#HIT_SPD,A3CP3A+FR4
	WL	#HIT_SPD,A3CP3A+FR5
	WL	#HIT_SPD,A3CP3A+FR6
	WL	#HIT_SPD,A3CP3A+FR7
	WL	#HIT_SPD,A3CP3A+FR8
	.word	ANI_END

#*****************************************************************************
*
* CLIMB UP TURNBUCKLES

#CLIMB_SPD	equ	5
 SUBR	adm_climb_up_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE | MODE_NOGRAVITY
	.word	ANI_ZEROVELS
;	WL	ANI_SET_YVEL,4000h	;27000	
;	.word	ANI_OFFSET,-8,-3,-16			;x,y,z
	.word	ANI_SLOWMO,5
	WL	#CLIMB_SPD,A2CT2B+FR1
	WL	#CLIMB_SPD,A2CT2B+FR2
	WL	#CLIMB_SPD,A2CT2B+FR3
	WL	#CLIMB_SPD,A2CT2B+FR4
	.word	ANI_OFFSET,4,19,0			;x,y,z
	WL	#CLIMB_SPD,A2CT2B+FR5
	WL	#CLIMB_SPD,A2CT2B+FR6
	WL	#CLIMB_SPD,A2CT2B+FR7
	.word	ANI_OFFSET,15,13,0
	WL	#CLIMB_SPD,A2CT2B+FR8
	WL	#CLIMB_SPD,A2CT2B+FR9
	WL	#CLIMB_SPD,A2CT2B+FR10
	WL	#CLIMB_SPD,A2CT2B+FR11
	.word	ANI_SLOWMO,0
	.word	ANI_ZEROVELS

	.word	ANI_OFFSET,0,6,0			;x,y,z
	WL	#CLIMB_SPD,A2CT2B+FR2
	.word	ANI_OFFSET,10,18h,0			;x,y,z
	WL	#CLIMB_SPD,A2CT2B+FR4
	.word	ANI_OFFSET,-2,0dh,0			;x,y,z
	WL	#CLIMB_SPD,A2CT2B+FR6

	.word	ANI_SETPLYRMODE,MODE_ONTURNBKL
	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE | MODE_NOGRAVITY

	.word	ANI_OFFSET,2,0,0			;x,y,z
#repeat
	WL	#CLIMB_SPD,A4SB4A+FR1
	WL	#CLIMB_SPD,A4SB4A+FR2
	WL	#CLIMB_SPD,A4SB4A+FR3
	WL	#CLIMB_SPD,A4SB4A+FR4
	WL	#CLIMB_SPD,A4SB4A+FR5
	WL	#CLIMB_SPD,A4SB4A+FR6
	WL	#CLIMB_SPD,A4SB4A+FR7
	WL	#CLIMB_SPD,A4SB4A+FR8
	WL	ANI_GOTO,#repeat

#*****************************************************************************
*
* CLIMB DOWN TURNBUCKLES

#CLIMB_SPD	equ	5
 SUBR	adm_climb_down_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE | MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_OFFSET,0,2,0			;x,y,z
	WL	#CLIMB_SPD*4,A2ST2D+FR1
;	WL	#CLIMB_SPD,A2CT2B+FR6
	.word	ANI_OFFSET,0,-13,0			;x,y,z
;	WL	#CLIMB_SPD,A2CT2B+FR4

	WL	ANI_SET_YVEL,-4000h
;
	.word	ANI_OFFSET,-8,-26,0			;x,y,z
;	WL	#CLIMB_SPD,A2CT2B+FR2
	.word	ANI_OFFSET,0,-5,0			;x,y,z
;	WL	#CLIMB_SPD,A2CT2A+FR12
	.word	ANI_OFFSET,0,-10,0			;x,y,z
;	WL	#CLIMB_SPD,A2CT2A+FR9
	.word	ANI_OFFSET,0,-10,0			;x,y,z
;	WL	#CLIMB_SPD,A2CT2A+FR7
	.word	ANI_OFFSET,-9,-9,0			;x,y,z
;	WL	#CLIMB_SPD,A2CT2A+FR2

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* SECOND WIND

#SWIND_SPD	equ	3
 SUBR	adm_2ndwind_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	#SWIND_SPD,A4SW4A+FR1
	WL	#SWIND_SPD,A4SW4A+FR2
	WL	#SWIND_SPD,A4SW4A+FR3
	WL	#SWIND_SPD,A4SW4A+FR4
	WL	#SWIND_SPD,A4SW4A+FR5
	WL	#SWIND_SPD,A4SW4A+FR6
	WL	#SWIND_SPD,A4SW4A+FR7
	WL	#SWIND_SPD,A4SW4A+FR8
	WL	#SWIND_SPD,A4SW4A+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* DIVE OFF TURNBUCKLE

#DIVETB_SPD	equ	2
 SUBR	adm_diveofftb_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP | MODE_NOCONFINE | MODE_NOCOLLIS
	.word	ANI_ZEROVELS
	.word	ANI_XFLIP		;make an ANI_FACEOUT and ANI_FACEIN

	.word	ANI_LEAPATOPP,40,180,TGT_HEAD,20,0,0	;#ticks,dist,xoff,yoff,zoff

	WL	#DIVETB_SPD,A4PM4A+FR1
	WL	#DIVETB_SPD,A4PM4A+FR2
	WL	#DIVETB_SPD,A4PM4A+FR3
	WL	#DIVETB_SPD,A4PM4A+FR4
	WL	#DIVETB_SPD,A4PM4A+FR5
	WL	#DIVETB_SPD,A4PM4A+FR6
	WL	#DIVETB_SPD,A4PM4A+FR7
	WL	#DIVETB_SPD,A4PM4A+FR8

	WL	1,A4ST4J+FR1
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_BOUNCE,4

	.word	ANI_SOUND,bounce_l1
	.word	ANI_SHAKER,3
	.word	ANI_SHAKEROPES,0
	WL	1,A4ST4J+FR1
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_SOUND,bounce_l1
	.word	ANI_SHAKER,3
	.word	ANI_SHAKEROPES,0
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* GRAB & FLING OPPONENT (INTO A RUN)

#GRABFLNG_SPD	equ	4
 SUBR	adm_2_grabfling_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	3,A1TR5Z+FR2
	WL	3,A1TR5Z+FR3
	WL	ANI_GOTO,#cont

 SUBR	adm_4_grabfling_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

#cont
	WL	#GRABFLNG_SPD,A4GF3A+FR1
	WL	#GRABFLNG_SPD,A4GF3A+FR2

	.word	ANI_ATTACK_ON, AMODE_GRABFLING,76,72,22,14 ;mode,x,y,w,h
	.word	ANI_ATTACHZ,72,0,32
	WL	#GRABFLNG_SPD,A4GF3A+FR3
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#gothim
;missed
	WL	8,A4GF3A+FR3
	WL	4,A4GF3A+FR2
	WL	4,A4GF3A+FR1

	WL	ANI_CODE,#setface

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#gothim
	.word	ANI_ATTACH,67,0
	WL	#GRABFLNG_SPD,A4GF3A+FR4
	.word	ANI_ATTACH,57,0
	WL	#GRABFLNG_SPD,A4GF3A+FR5
	.word	ANI_ATTACH,40,0
	WL	#GRABFLNG_SPD,A4GF3A+FR6
	.word	ANI_ATTACH,5,0
	WL	#GRABFLNG_SPD,A4GF3A+FR7
	.word	ANI_ATTACH,-59,0
	WL	#GRABFLNG_SPD,A4GF3A+FR8
	.word	ANI_DETACH
	WL	#GRABFLNG_SPD+4,A4GF3A+FR9
	WL	#GRABFLNG_SPD+4,A4GF3A+FR10
	WL	#GRABFLNG_SPD+4,A4GF3A+FR11
	WL	#GRABFLNG_SPD+4,A4GF3A+FR12

	.word	ANI_SETFACING

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#setface
;Need to set current facing dir
	movk	10,a1
	move	*a13(OBJ_CONTROL),a0
	btst	B_FLIPH,a0
	jrz	#rgt
	movk	6,a1
#rgt	move	a1,*a13(FACING_DIR)
	rets

#*****************************************************************************
*
* GRAB OPPONENT AND HOLD OVERHEAD


#GRABOH_SPD	equ	3
 SUBR	adm_2_graboh_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	WL	3,A1TR5Z+FR2
	WL	3,A1TR5Z+FR3
	WL	3,A3PO4B+FR1
	WL	3,A3PO4B+FR2

	.word	ANI_ATTACK_ON_Z, AMODE_GRABHOLD,78,69,20,21,34,40 ;mode,x,y,z,w,h,d
	.word	ANI_ATTACHZ,45,65,4
	WL	3,A3PO4B+FR3
	WL	6,A3PO4B+FR4
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#gothim
;missed
	WL	3,A3PO4B+FR3
	WL	3,A3PO4B+FR2
	WL	3,A3PO4B+FR1
	WL	3,A1TR5Z+FR3
	WL	3,A1TR5Z+FR2
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


 SUBR	adm_4_graboh_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	WL	3,A3PO4B+FR1
	WL	3,A3PO4B+FR2
	WL	3,A3PO4B+FR3

	.word	ANI_ATTACK_ON_Z, AMODE_GRABHOLD,78,69,20,21,34,40 ;mode,x,y,z,w,h,d
	.word	ANI_ATTACHZ,45,65,4
	WL	6,A3PO4B+FR4
	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#gothim
;missed
	WL	6,A3PO4B+FR4
	WL	3,A3PO4B+FR3
	WL	3,A3PO4B+FR2
	WL	3,A3PO4B+FR1
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#gothim
	.word	ANI_ATTACH,50,85
	WL	6,A3PO4B+FR5
	.word	ANI_ATTACH,20,120
	WL	6,A3PO4B+FR6
	.word	ANI_ATTACH,0,120
	WL	6,A3PO4B+FR7
	.word	ANI_ATTACH,0,125
	WL	6,A4UT4Z+FR1

	.word	ANI_SETPLYRMODE,MODE_OPPOVERHEAD
	.word	ANI_SETMODE,+MODE_NOAUTOFLIP
	.word	ANI_END

#*****************************************************************************
*
* FROM HOLD OVERHEAD, THROW OPPONENT STRAIGHT UP IN AIR

#OHTHROW_SPD	equ	4
 SUBR	adm_ohthrow1_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

	.word	ANI_SOUND,29h
	.word	ANI_ATTACH,9,124
	WL	#OHTHROW_SPD,A4UT3A+FR1
	.word	ANI_ATTACH,9,108
	WL	#OHTHROW_SPD,A4UT3A+FR2
	.word	ANI_ATTACH,9,82
	WL	#OHTHROW_SPD+8,A4UT3A+FR3
	.word	ANI_ATTACH,9,120
	WL	#OHTHROW_SPD-2,A4UT3A+FR4
	.word	ANI_ATTACH,9,145

	.word	ANI_THROW1

	.word	ANI_SOUND,42h

	WL	#OHTHROW_SPD+6,A4UT3A+FR5
	WL	#OHTHROW_SPD,A4UT3A+FR6
	WL	#OHTHROW_SPD,A4UT3A+FR7
	WL	#OHTHROW_SPD,A4UT3A+FR8

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* HELD OVERHEAD ANIMATION

#HELD_SPD	equ	3
 SUBR	adm_heldoh_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	WL	#HELD_SPD,A4PM4A+FR1
	WL	#HELD_SPD,A4PM4A+FR2
	WL	#HELD_SPD,A4PM4A+FR3
	WL	#HELD_SPD,A4PM4A+FR4
	WL	#HELD_SPD,A4PM4A+FR5
	WL	#HELD_SPD,A4PM4A+FR6
	WL	#HELD_SPD,A4PM4A+FR7
	WL	#HELD_SPD,A4PM4A+FR8
	.word	ANI_REPEAT
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* BEEN THROWN FROM HELD OVERHEAD

#HELD_SPD	equ	3
 SUBR	adm_heldthrown_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_XFLIP

	WL	1,A3FD3B+FR6
	.word	ANI_WAITHITGND
	.word	ANI_SOUND,bounce_l1

	.word	ANI_BOUNCE,4

	WL	1,A3FD3B+FR6
	.word	ANI_WAITHITGND
	.word	ANI_SOUND,bounce_l1
	.word	ANI_ZEROVELS
	.word	ANI_XFLIP
	WL	1,A3RL1A+FR1
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_END


#*****************************************************************************
*
* FLYING BUTT DROP

 .if 0
#BUTTDRP_SPD	equ	3
 SUBR	adm_buttdrp_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	WL	ANI_SET_YVEL,60000h

;	WL	#BUTTDRP_SPD,A3JK3A+FR1
;	WL	#BUTTDRP_SPD,A3JK3A+FR2
;	WL	#BUTTDRP_SPD,A3JK3A+FR3
;	WL	#BUTTDRP_SPD,A3JK3A+FR4
;	WL	#BUTTDRP_SPD,A3JK3A+FR5
;	WL	#BUTTDRP_SPD,A3JK3A+FR6

;	WL	1,A3JK3A+FR7
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_BOUNCE,4

;	WL	1,A3JK3A+FR7
	.word	ANI_WAITHITGND
;	WL	TSEC*1,A3JK3A+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END
 .endif

#*****************************************************************************
*
* #2 BLOCK

#BLOCK_SPD	equ	3
#HITBLOCK_SPD	equ	4
 SUBR	adm_2_block_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS


	WL	#BLOCK_SPD,A2BK3B+FR1
	WL	#BLOCK_SPD,A2BK3B+FR2
	WL	#BLOCK_SPD,A2BK3B+FR3
	.word	ANI_SETPLYRMODE,MODE_BLOCK
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
	WL	#BLOCK_SPD,A2BK3B+FR2
	WL	#BLOCK_SPD,A2BK3B+FR1
	.word	ANI_END

 SUBR	adm_2_hitblock_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_FRICTION,3000h

	WL	#HITBLOCK_SPD,A2BK3B+FR7
	WL	#HITBLOCK_SPD,A2BK3B+FR8
	WL	#HITBLOCK_SPD,A2BK3B+FR6
	WL	#HITBLOCK_SPD,A2BK3B+FR5
	WL	#HITBLOCK_SPD,A2BK3B+FR4
	WL	#HITBLOCK_SPD,A2BK3B+FR3

	.word	ANI_ZEROVELS
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_END

#*****************************************************************************
*
* #4 BLOCK

#BLOCK_SPD	equ	3
#HITBLOCK_SPD	equ	4

 SUBR	adm_4_block_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS


	WL	#BLOCK_SPD,A4BK3C+FR1
	WL	#BLOCK_SPD,A4BK3C+FR2
	WL	#BLOCK_SPD,A4BK3C+FR3
	.word	ANI_SETPLYRMODE,MODE_BLOCK
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_WAITRELEASE,PLAYER_BLOCK_BIT
	WL	#BLOCK_SPD,A4BK3C+FR2
	WL	#BLOCK_SPD,A4BK3C+FR1
	.word	ANI_END

 SUBR	adm_4_hitblock_anim


	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_FRICTION,3000h
	WL	#HITBLOCK_SPD,A4BK3C+FR4
	WL	#HITBLOCK_SPD,A4BK3C+FR5
	WL	#HITBLOCK_SPD,A4BK3C+FR7
	WL	#HITBLOCK_SPD,A4BK3C+FR8
	WL	#HITBLOCK_SPD,A4BK3C+FR6
	WL	#HITBLOCK_SPD,A4BK3C+FR3


	.word	ANI_ZEROVELS
	.word	ANI_SETMODE,MODE_NOAUTOFLIP
	.word	ANI_END

#*****************************************************************************
*
* HIP TOSS RUNNING OPPONENT

;put in #2 and #4 hiptosses
#HIPTOSS_SPD	equ	3
 SUBR	adm_hiptoss_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS

;;;	.word	ANI_SLOWMO,5

	WL	#HIPTOSS_SPD,A4HT3A+FR1
	WL	#HIPTOSS_SPD,A4HT3A+FR2
	.word	ANI_ATTACK_ON, AMODE_HIPTOSS,76-20,74,32,32 ;mode,x,y,w,h
	WL	#HIPTOSS_SPD,A4HT3A+FR3
	.word	ANI_ATTACK_OFF
	WL	#HIPTOSS_SPD,A4HT3A+FR4
	WL	#HIPTOSS_SPD,A4HT3A+FR5
	WL	#HIPTOSS_SPD,A4HT3A+FR6
	WL	#HIPTOSS_SPD,A4HT3A+FR7
	WL	#HIPTOSS_SPD,A4HT3A+FR8

;;;	.word	ANI_SLOWMO,0

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* FLIP/FALL FROM HIPTOSS

#TOSSFALL_SPD	equ	3
 SUBR	adm_hiptossfall_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable

	WL	#TOSSFALL_SPD,A3FH3A+FR1
	WL	#TOSSFALL_SPD,A3FH3A+FR2
	WL	#TOSSFALL_SPD,A3FH3A+FR3
	WL	#TOSSFALL_SPD,A3FH3A+FR4
	WL	#TOSSFALL_SPD,A3FH3A+FR5
	WL	#TOSSFALL_SPD,A3FH3A+FR6
	WL	#TOSSFALL_SPD,A3FH3A+FR7
	WL	#TOSSFALL_SPD,A3FH3A+FR8

	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_ZEROVELS
	.word	ANI_XFLIP
	WL	1,A3RL1A+FR1

;;;	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 PUSH

#PUSH_SPD	equ	4
 SUBR	adm_2_push_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	#PUSH_SPD,A2PS3A+FR1
	WL	#PUSH_SPD,A2PS3A+FR2
	WL	#PUSH_SPD,A2PS3A+FR3
	WL	#PUSH_SPD,A2PS3A+FR4
	.word	ANI_ATTACK_ON, AMODE_PUSH,84,97,40,26 ;mode,x,y,w,h
	WL	#PUSH_SPD,A2PS3A+FR5
	.word	ANI_ATTACK_OFF
	WL	#PUSH_SPD,A2PS3A+FR6
	WL	#PUSH_SPD,A2PS3A+FR7
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #4 PUSH

#PUSH_SPD	equ	4
 SUBR	adm_4_push_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	#PUSH_SPD,A4PS3A+FR1
	WL	#PUSH_SPD,A4PS3A+FR2
	WL	#PUSH_SPD,A4PS3A+FR3
	.word	ANI_ATTACK_ON, AMODE_PUSH,79,101,34,18 ;mode,x,y,w,h
	WL	#PUSH_SPD,A4PS3A+FR4
	.word	ANI_ATTACK_OFF
	WL	#PUSH_SPD,A4PS3A+FR5
	WL	#PUSH_SPD,A4PS3A+FR6
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #2 LOSE BALANCE

#LB_SPEED	equ	4
#FRICTION_VAL	equ	3000h
 SUBR	adm_2_losebal_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_FRICTION,#FRICTION_VAL
	WL	#LB_SPEED,A2LB2B+FR1
	WL	#LB_SPEED,A2LB2B+FR2
	WL	#LB_SPEED,A2LB2B+FR3
	WL	#LB_SPEED,A2LB2B+FR4
	WL	#LB_SPEED,A2LB2B+FR5
	WL	#LB_SPEED,A2LB2B+FR6
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


******************************************************************************
*
* #4 LOSE BALANCE

 SUBR	adm_4_losebal_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_FRICTION,#FRICTION_VAL
	WL	#LB_SPEED,A4LB4A+FR1
	WL	#LB_SPEED,A4LB4A+FR2
	WL	#LB_SPEED,A4LB4A+FR3
	WL	#LB_SPEED,A4LB4A+FR4
	WL	#LB_SPEED,A4LB4A+FR5
	WL	#LB_SPEED,A4LB4A+FR6
	WL	#LB_SPEED,A4LB4A+FR7
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* #2 BIG BOOT

#BIGBOOT_SPD	equ	3
 SUBR	adm_2_bigboot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	#BIGBOOT_SPD,A2BG3A+FR1
	WL	#BIGBOOT_SPD,A2BG3A+FR3
	WL	#BIGBOOT_SPD,A2BG3A+FR4
	WL	#BIGBOOT_SPD,A2BG3A+FR5

	.word	ANI_ATTACK_ON, AMODE_BIGBOOT,79,105,19,25 ;mode,x,y,w,h
	WL	#BIGBOOT_SPD,A2BG3A+FR6
	.word	ANI_WAITRELEASE,PLAYER_KICK_BIT
	.word	ANI_ATTACK_OFF

	WL	#BIGBOOT_SPD,A2BG3A+FR7
	WL	#BIGBOOT_SPD,A2BG3A+FR8
	WL	#BIGBOOT_SPD,A2BG3A+FR9
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* #4 BIG BOOT

#BIGBOOT_SPD	equ	3
 SUBR	adm_4_bigboot_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	WL	#BIGBOOT_SPD,A4BG3A+FR1
	WL	#BIGBOOT_SPD,A4BG3A+FR3
	WL	#BIGBOOT_SPD,A4BG3A+FR4
	WL	#BIGBOOT_SPD,A4BG3A+FR5

	.word	ANI_ATTACK_ON, AMODE_BIGBOOT,79,105,19,25 ;mode,x,y,w,h
	WL	#BIGBOOT_SPD,A4BG3A+FR6
	.word	ANI_WAITRELEASE,PLAYER_KICK_BIT
	.word	ANI_ATTACK_OFF

	WL	#BIGBOOT_SPD,A4BG3A+FR7
	WL	#BIGBOOT_SPD,A4BG3A+FR8
	WL	#BIGBOOT_SPD,A4BG3A+FR9
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*****************************************************************************
*
* DIZZY

#DIZZY_SPD	equ	6
 SUBR	adm_dizzy_anim

	.word	ANI_SETMODE,MODE_UNINT		;uninterruptable
	.word	ANI_ZEROVELS
	WL	#DIZZY_SPD,A4SW4A+FR1
	WL	#DIZZY_SPD,A4SW4A+FR2
	WL	#DIZZY_SPD,A4SW4A+FR3
	WL	#DIZZY_SPD,A4SW4A+FR4
	WL	#DIZZY_SPD,A4SW4A+FR5
	WL	#DIZZY_SPD,A4SW4A+FR6
	WL	#DIZZY_SPD,A4SW4A+FR7
	WL	#DIZZY_SPD,A4SW4A+FR8
	WL	#DIZZY_SPD,A4SW4A+FR9
	.word	ANI_REPEAT


#****************************************************************************
*
* RAISE ARM IN VICTORY

#RARM_SPD	equ	8
 SUBR	adm_raisearm_anim

	.word	ANI_SETMODE,MODE_UNINT		;uninterruptable
	.word	ANI_ZEROVELS

;	WL	#RARM_SPD+10,A5WN5B+FR1
;	WL	#RARM_SPD-2,A5WN5B+FR2
;	WL	#RARM_SPD-2,A5WN5B+FR3
;	WL	#RARM_SPD-2,A5WN5B+FR4
;	WL	#RARM_SPD-2,A5WN5B+FR5
;
;	WL	#RARM_SPD,A5WN5Z+FR1
;	WL	#RARM_SPD,A5WN5Z+FR2
;	WL	#RARM_SPD,A5WN5Z+FR3
;	WL	#RARM_SPD,A5WN5Z+FR4
;
;	WL	#RARM_SPD,A5WN5Z+FR1
;	WL	#RARM_SPD,A5WN5Z+FR2
;	WL	#RARM_SPD,A5WN5Z+FR3
;	WL	#RARM_SPD,A5WN5Z+FR4
;
;	WL	#RARM_SPD,A5WN5Z+FR1
;	WL	#RARM_SPD,A5WN5Z+FR2
;	WL	#RARM_SPD,A5WN5Z+FR3
;	WL	#RARM_SPD,A5WN5Z+FR4
;
;	WL	#RARM_SPD,A5WN5Z+FR1
;	WL	#RARM_SPD,A5WN5Z+FR2
;	WL	#RARM_SPD,A5WN5Z+FR3
;	WL	#RARM_SPD,A5WN5Z+FR4
;
;	WL	#RARM_SPD,A5WN5Z+FR1
;	WL	#RARM_SPD,A5WN5Z+FR2
;	WL	#RARM_SPD,A5WN5Z+FR3
;	WL	#RARM_SPD+50,A5WN5Z+FR4

	.word	ANI_ENDMATCH
	.word	ANI_REPEAT

#*****************************************************************************
*
 SUBR	adm_lockup2_anim
 SUBR	adm_lockup4_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_END

#*****************************************************************************

 SUBR	adm_roll_frames

	.word	9		;speed
	.long	30000h		;z velocity
	.long	10000h*8/255	;inv multiply (0-255 -> 0-8)

	.long	A3RL1A+FR1	;0
	.long	A3RL1A+FR2	;1
	.long	A3RL1A+FR3	;2
	.long	A3RL1A+FR4	;3
	.long	A3RL1A+FR5	;4
	.long	A3RL1A+FR6	;5
	.long	A3RL1A+FR7	;6
	.long	A3RL1A+FR8	;7
	.long	A3RL1A+FR9	;8
	.long	0,0,0,0,0,0


******************************************************************************
	.end
