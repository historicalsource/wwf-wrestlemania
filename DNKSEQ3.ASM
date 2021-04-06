**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		5/2/94
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"dnkseq3.asm"
	.title	"Krusty the Clown animation sequences"
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
	.include	"ring.equ"


	.include	"bretimg.h"
	.include	"razorimg.h"
	.include	"takerimg.h"
	.include	"yokoimg.h"
	.include	"shawnimg.h"
	.include	"bamimg.h"
	.include	"doinkimg.h"
	.include	"leximg.h"

	.include	"fontsimg.glo"
	.include	"miscimg.glo"
	.include	"damage.equ"

******************************************************************************
* EXTERNAL REFERENCES

	.ref	PCNT,MOVE_NAME_ANNC,DO_WAIL,DO_NONO,DO_DOINK_SLAM
	.ref	FIND_AND_KILL_ENDLESS,CALL_MISS_YOKO,triple_sound
	.ref	RNDRNG0,HIT_THE_MAT,SMALL_BOUNCE,CALL_MISSES,CALL_SETUP
	.ref	CALL_THROWN_OUT,CALL_SPECIAL_MOVE,get_leap,shake_all_ropes
	.ref	dnk_dizzy_anim,dnk_2_faceup_getup_anim,no_debris,reduce_bog
	.ref	dnk_4_faceup_getup_anim,dnk_hitonground_anim
	.ref	dnk_faceup_getup_anim,dnk_hitonground_xflip_anim
	.ref	dnk_4_combo_butt_anim,DO_COMBO_MESS,dnk_4_box_anim
	.ref	dnk_4_knee_fall_anim,dnk_flying_kick_anim,NUM_OPPS
	.ref	MAYBE_SHOCKING,target_whoihit,PSTATUS,royal_rumble
	.ref	punch_dtime1,change_anim_anim,dnk_combo_box_anim
	.ref	dnk_fall_back_anim,dnk_combo_knee_fall_anim
	.ref	pal_getf,lex_break_face2_anim,dnk_combo_flying_kick_anim
	.ref	set_xdrift,CALL_OTHER_AVERAGE,get_health
	.ref	lex_break_neck2_anim,ckzpos,dnk_stand4_anim
	.ref	yok_3_head_held_brk_anim,lex_break_face_anim
	.ref	free_toss_check,setup_freetoss,process_ptrs
	.ref	dnk_2_hiptoss_anim

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

TSEC 	equ	53

*****************************************************************************
*
* JOY BUZZER

 SUBR	dnk_2_buzz_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_FRICTION,2000h
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS

	.word	ANI_STARTATTACK,AT_PUPPET,20
	WL	2,D1TT5Z+FR2
	WL	2,D1TT5Z+FR3
	WL	ANI_GOTO,#cont

 SUBR	dnk_4_buzz_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_FRICTION,2000h
	.word	ANI_SETSPEED,100h
	.word	ANI_ZEROVELS

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

;Comes in from head held mode!
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_DETACH

#cont
	.word	ANI_STARTATTACK,AT_PUPPET,20
	WL	3,D4BZ3A+FR1

	.word	ANI_ZEROVELS
	.WORD	ANI_SOUND,020FH		;PUT IT THERE

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2
	.word	ANI_ATTACK_ON, AMODE_PUPPET,23,62,59,29	;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,35,D4BZ3A+FR2
	.word	ANI_ATTACK_OFF
#cont4
	WL	ANI_IFSTATUS,#gothim


	WL	35,D4BZ3A+FR2


	WL	ANI_GOTO,#cont2

#gothim
;	WL	ANI_CODE,merge_xvels

	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,1,D4BZ3A+FR3,#puppet_tbl,0

	;SMART-TARGET, so we buzz the right guy!
	WL	ANI_CODE,target_whoihit

	.word	ANI_ATTACK_ON, AMODE_BUZZ,53,62,50,29	;mode,x,y,w,h
	WL	1,D4BZ3A+FR3
	.word	ANI_ATTACK_OFF

	WL	ANI_CODE,start_sparks

	WL	1,D4BZ3A+FR3
	WL	3,D4BZ3A+FR4
	WL	3,D4BZ3A+FR5
	WL	3,D4BZ3A+FR6
	WL	3,D4BZ3A+FR3
	WL	3,D4BZ3A+FR4

	.word	ANI_DRAW_NAME,28

;	.word	ANI_WAITHITGND
;	.word	ANI_ZEROVELS

	WL	3,D4BZ3A+FR5
	.word	ANI_ZERO_XZVELS
	WL	3,D4BZ3A+FR6
	WL	3,D4BZ3A+FR3
	WL	3,D4BZ3A+FR4
	WL	3,D4BZ3A+FR5
	WL	3,D4BZ3A+FR6
	WL	3,D4BZ3A+FR3
	WL	3,D4BZ3A+FR4
	WL	3,D4BZ3A+FR5
	WL	3,D4BZ3A+FR6
	WL	3,D4BZ3A+FR3
	WL	3,D4BZ3A+FR4
	WL	3,D4BZ3A+FR5
	WL	3,D4BZ3A+FR6

;Stay in this buzz sequence longer if player keeps whacking on his punch button!

	WWL	ANI_SLIDE_BACK,30h,-70000h,#cont2

	WL	ANI_SET_YVEL,30000h
	WL	3,D4BZ3A+FR2
#cont2
	WL	6,D4BZ3A+FR2
	WL	3,D4BZ3A+FR1

	WL	ANI_CODE,#zero_butn

	.word	ANI_DETACH
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

 SUBR	dnk_2_buzz2_anim
;Running or pushing toward buzzer

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_FRICTION,2000h
	.word	ANI_SETSPEED,100h

;	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
;	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_STARTATTACK,AT_LEAPING,9
	WL	3,D1TT5Z+FR2
	WL	3,D1TT5Z+FR3
	WL	ANI_GOTO,#cont3

 SUBR	dnk_4_buzz2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_FRICTION,2000h
	.word	ANI_SETSPEED,100h

;	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
;	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SETPLYRMODE,MODE_NORMAL

#cont3
	.word	ANI_STARTATTACK,AT_LEAPING,3
	WL	3,D4BZ3A+FR1

	WL	ANI_CODE,get_leap
	WL	ANI_IFNOTSTATUS,#normal

	.word	ANI_ZEROVELS
	.word	ANI_CLR_STATUS
	WL	ANI_GOTO,#contz

#normal
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 9,999,38h,80,90000h,TGT_HEAD,80,85,0
;	WL	ANI_SET_YVEL,30000h

#contz
	.WORD	ANI_SOUND,020FH		;PUT IT THERE
	.word	ANI_ATTACK_ON, AMODE_PUPPET,23,62,59,29	;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,20,D4BZ3A+FR2
	.word	ANI_ATTACK_OFF
	WLW	ANI_SET_ZVEL,0h,AM_ABS
	WL	ANI_GOTO,#cont4

 SUBR	dnk_combo_buzz2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_FRICTION,2000h
	.word	ANI_SETSPEED,100h

	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_STARTATTACK,AT_LEAPING,3
	WL	3,D4BZ3A+FR1

	WL	ANI_CODE,get_leap
	WL	ANI_IFNOTSTATUS,#normalc

	.word	ANI_ZEROVELS
	.word	ANI_CLR_STATUS
	WL	ANI_GOTO,#contzc

#normalc
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 9,999,38h,80,90000h,TGT_HEAD,80,85,0

#contzc
	.word	ANI_ATTACK_ON, AMODE_PUPPET,23,62,59,29	;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,20,D4BZ3A+FR2
	.word	ANI_ATTACK_OFF
	WLW	ANI_SET_ZVEL,0h,AM_ABS
	.WORD	ANI_INC_COMBO
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_GOTO,#cont4

#zero_butn
;Force player to start holding his button down starting at the end
;of the current buzz sequence.

	move	*a13(PLYRNUM),a0
	X16	a0
	addi	punch_dtime1,a0
	clr	a14
	move	a14,*a0
	rets


start_sparks
	move	@no_debris,a14
	move	@reduce_bog,a1
	or	a1,a14
	jrnz	#rets
	move	a13,a10
	CREATE0	hand_sparks
#rets
	CREATE0	MAYBE_SHOCKING
	rets

#puppet_tbl
 .long #Bret
 .long #Razor
 .long #Taker
 .long #Yokozuna
 .long #Shawn
 .long #BamBam
 .long #Doink
 .long #Adam
 .long #Lex

#Bret
	.ref	H4BZ4A
 LWWW H4BZ4A+FR1,80,28,1
#Razor
	.ref	R4BZ4A
 LWWW R4BZ4A+FR1,75,30,1
#Taker
	.ref	U4BZ4A
 LWWW U4BZ4A+FR1,75,30,1
#Yokozuna
	.ref	Y4BZ4A
 LWWW Y4BZ4A+FR1,75,26,1
#Shawn
	.ref	S4BZ4A
 LWWW S4BZ4A+FR1,75,24,1
#BamBam
	.ref	B4BZ4A
 LWWW B4BZ4A+FR1,75,15,1
#Doink
 LWWW D4BZ4A+FR1,75,30,1
#Adam
 .long 0
#Lex
	.ref	L4BZ4A
 LWWW L4BZ4A+FR1,75,23,1

#*****************************************************************************
*
* GET BUZZED FROM DOINK

 SUBR	dnk_get_buzz_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
;	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;	.word	ANI_XFLIP
	.word	ANI_GRAVITY_OFF


;Put this Doink into the blue doink pal, then replace whatever
;pal he was using at the end!

;We have to change pals on whatever guy we are showing in order
;to show the blue skeleton.

	WL	ANI_CODE,set_position
	WL	2,D4SK4A+FR1
	WL	3,D4BZ4A+FR1

	WL	ANI_CODE,make_white
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_norm
	
	WL	3,D4BZ4A+FR1
	WL	3,D4SK4A+FR1
	WL	3,D4BZ4A+FR1
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_white
	WL	3,D4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,D4SK4A+FR1
	WL	3,D4BZ4A+FR1
	WL	3,D4SK4A+FR1
	WL	3,D4BZ4A+FR1
	WL	ANI_CODE,make_white
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,D4BZ4A+FR1
	WL	3,D4SK4A+FR1
	WL	ANI_CODE,start_smoke

	.word	ANI_DETACH
	.word	ANI_GRAVITY_ON
	WL	ANI_SET_YVEL,60000h
	WLW	ANI_SET_XVEL,-30000h,AM_FACE_REL
	WLW	ANI_SET_ZVEL,20000h,AM_ABS
	WL	ANI_CODE,#make_black
	WL	3,D4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,D4BZ4A+FR1
	WL	ANI_CODE,#make_black
	WL	3,D4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,D4BZ4A+FR1
	WL	ANI_CODE,#make_black
	WL	3,D4BZ4A+FR1
	WL	ANI_CODE,make_norm
	WL	3,D4BZ4A+FR1

	.word	ANI_WAITHITGND
	.word	ANI_XFLIP
	.word	ANI_FACEDOWN
	.word	ANI_OFFSET,-20,0,0			;x,y,z

	WL	1,D4ST4E+FR3

	WL	ANI_CODE,am_I_dead
;If I'm dead, goto fall back
	WL	ANI_IFNOTSTATUS,#nodead

	WL	ANI_CHANGEANIM,dnk_fall_back_anim
;	.word	ANI_END

#nodead
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

 SUBR 	am_I_dizzy
	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1
	move	*a13(PLYRMODE),a0
	cmpi	MODE_DEAD,a0
	jrz	#not_dizzy
	move	*a13(PLYR_DIZZY),a0
	jrz	#not_dizzy
	ori	MODE_STATUS,a1
#not_dizzy
	move	a1,*a13(ANIMODE)
	rets

 SUBR 	am_I_dead
	
	move	*a13(PLYRNUM),a1
	calla	get_health
	jrnz	#notdead

	move	*a13(ANIMODE),a1
	ori	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	movi	MODE_DEAD,a1
	move	a1,*a13(PLYRMODE)
	rets
#notdead
	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1
	move	*a13(PLYRMODE),a0
	cmpi	MODE_DEAD,a0
	jrnz	#not_dead
	ori	MODE_STATUS,a1
#not_dead
	move	a1,*a13(ANIMODE)
	rets

 SUBR 	make_white
	movi	0101h,a14
	move	a14,*a13(OBJ_CONST)
	move	*a13(OBJ_CONTROL),a14
	andni	01111b,a14
	ori	M_CONNON,a14
	move	a14,*a13(OBJ_CONTROL)
	rets

#make_black
	movi	0b0bh,a14
	move	a14,*a13(OBJ_CONST)
	move	*a13(OBJ_CONTROL),a14
	andni	01111b,a14
	ori	M_CONNON,a14
	move	a14,*a13(OBJ_CONTROL)
	rets

 SUBR	make_norm
	move	*a13(OBJ_CONTROL),a14
	andni	01111b,a14
	ori	DMAWNZ,a14
	move	a14,*a13(OBJ_CONTROL)
	rets

 SUBR	set_position
	move	*a13(WHOHITME),a0,L
	move	*a0(OBJ_XPOSINT),a1
	move	*a13(OBJ_XPOSINT),a2
	cmp	a1,a2
	jrlt	#lft
#rgt
	addi	140,a1
	move	*a10(OBJ_XPOSINT),a2
#lft	subi	70,a1
;	move	a1,*a13(OBJ_XPOSINT)
	move	*a0(OBJ_YPOSINT),a1
	addi	12,a1
;	move	a1,*a13(OBJ_YPOSINT)
	move	*a0(OBJ_ZPOSINT),a1
	subi	20,a1
;	move	a1,*a13(OBJ_ZPOSINT)
	movi	DNKBLU_P,a0
	calla	pal_getf
	move	a0,*a13(SKELETON_PAL)
	move	*a13(OBJ_PAL),a0
	move	a0,*a13(MY_PAL)
	
	rets

 SUBR	set_skeleton_pal
	move	*a13(SKELETON_PAL),a0
	move	a0,*a13(OBJ_PAL)

	;set the TEMP_PAL bit
	move	*a13(STATUS_FLAGS),a14
	ori	M_TEMP_PAL,a14
	move	a14,*a13(STATUS_FLAGS)

	rets

 SUBR	set_my_pal
	move	*a13(MY_PAL),a0
	move	a0,*a13(OBJ_PAL)

	;clear TEMP_PAL bit
	move	*a13(STATUS_FLAGS),a14
	andni	M_TEMP_PAL,a14
	move	a14,*a13(STATUS_FLAGS)

	rets

 SUBR	start_smoke

	move	@no_debris,a14
	jrnz	#rets
	move	@reduce_bog,a14
	jrnz	#rets

	move	a13,a10
	CREATE0	body_smoke

#rets	rets

#*****************************************************************************

 SUBR	dnk_3_pile_driver_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

;Put cool cheers here

	.word	ANI_ATTACK_ON, AMODE_PUPPET,32,15,45,41 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,4,D4GH3A+FR8	;D3PP3Z+FR1
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;Check to see if I have tried to pile drive Yokozuna!

	.word	ANI_SOUND,82h			;Effort grunt

;got him
	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,4,D3PP3Z+FR1,#puppet_tbl,0
	.word	ANI_WAITHITGND

	.WORD	ANI_ADD_MOVE,MOVE_C_5,2,2

	WWLLW	ANI_SUPERSLAVE2,4,D3PP3Z+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,20,D3PP3Z+FR3,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,D3PP3Z+FR4,#puppet_tbl,3

	WL	ANI_SET_YVEL,80000h
;Float toward the center of ring!
	WL	ANI_CODE,set_xdrift

	WWLLW	ANI_SUPERSLAVE2,3,D3PP3Z+FR5,#puppet_tbl,4
	.word	ANI_OFFSET,0,26,0			;x,y,z

	WWLLW	ANI_SUPERSLAVE2,3,D3PP3Z+FR6,#puppet_tbl,5
	WWLLW	ANI_SUPERSLAVE2,3,D4HS3B+FR6,#puppet_tbl,6
	WWLLW	ANI_SUPERSLAVE2,7,D4HS3B+FR6,#puppet_tbl,7

;Mess with the physics!

	WL	ANI_SET_YVEL,-20000h

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

;Maybe do a bounce

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,40
	.word	ANI_DAMAGEOPP,D_PILEDRIVER,RD_PILEDRIVER

	WWLLW	ANI_SUPERSLAVE2,4,D4HS3B+FR7,#puppet_tbl,8
	WWLLW	ANI_SUPERSLAVE2,4,D4HS3B+FR8,#puppet_tbl,9

	WL	ANI_CODE,CALL_SPECIAL_MOVE
	WL	ANI_CODE,#set_opp_xflip

	WL	ANI_SLAVEANIM,#rollout_tbl
	.word	ANI_CLROPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	.word	ANI_DETACH
	WL	18,D4HS3B+FR8

	WLW	ANI_SET_ZVEL,-10000h,AM_ABS

;Getting up, set no_collis
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS|MODE_NOAUTOFLIP	;uninterruptable

	WL	3,D3GU4A+FR5
	WL	3,D3GU4A+FR6
;Check for a flip here
	WL	1,D3GU4A+FR7
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,D3GU4A+FR7
	WL	3,D3GU4A+FR8
	WL	3,D3GU4A+FR9

	.word	ANI_SAFE_TIME,30

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,37,88,63,9
	WL	1,D3GU4A+FR9
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	.ref	dnk_4_push_anim
	WL	ANI_CHANGEANIM,dnk_4_push_anim
#no_freetoss

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#missed
	WL	ANI_CODE,CALL_MISSES
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WL	3,D3PP3Z+FR1
	WL	3,D3PP3Z+FR2
	WL	3,D3PP3Z+FR3
	WL	3,D3PP3Z+FR4

	WL	ANI_SET_YVEL,80000h

	WL	3,D3PP3Z+FR5
	.word	ANI_OFFSET,0,26,0			;x,y,z

	WL	3,D3PP3Z+FR6
	WL	3,D4HS3B+FR6
	WL	7,D4HS3B+FR6

;	WL	ANI_SET_YVEL,-20000h

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

;Maybe do a bounce

	;impact
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30

	WL	4,D4HS3B+FR7
	WL	4,D4HS3B+FR8

;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	WL	18,D4HS3B+FR8

	WLW	ANI_SET_ZVEL,-10000h,AM_ABS

;Getting up, set no_collis
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS|MODE_NOAUTOFLIP	;uninterruptable

	WL	3,D3GU4A+FR5
	WL	3,D3GU4A+FR6
;Check for a flip here
	WL	1,D3GU4A+FR7
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,D3GU4A+FR7
	WL	3,D3GU4A+FR8
	WL	3,D3GU4A+FR9

	.word	ANI_SAFE_TIME,30

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss2
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,37,88,63,9
	WL	1,D3GU4A+FR9
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss2

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,dnk_4_push_anim
#no_freetoss2

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#set_opp_xflip
	move	*a13(ATTACH_PROC),a0,L

	move	*a0(OBJ_CONTROL),a14
	xori	M_FLIPH,a14
	move	a14,*a0(OBJ_CONTROL)

	rets

;Check to see if I have tried to pile drive Yokozuna!

 SUBR	is_this_yoko

	move	*a13(ATTACH_PROC),a0,L
	move	*a0(WRESTLERNUM),a0
	cmpi	3,a0
	jrnz	#ok

;Yes, this is Yoko!

	move	*a13(ANIMODE),a1
	ori	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets
#ok
	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets

;For Yoko breaking free
#break
	move	*a13(ATTACH_PROC),a2,L
	movi	yok_3_head_held_brk_anim,a0
;a0 = * animation script
;a2 = * wrestler process
	calla	change_anim_anim
	rets


#puppet_tbl
 .long #Bret
 .long #Razor
 .long #Taker
 .long #Yokozuna
 .long #Shawn
 .long #BamBam
 .long #Doink
 .long #Adam
 .long #Lex

#Bret
	.ref	H4AM3A,H3BF3A,H3PP3X
 LWWW H4AM3A+FR5,48,-37,0
 LWWW H3BF3A+FR3,32,-34,0
 LWWW H3PP3X+FR1,9,-30,0
 LWWW H3PP3X+FR2,4,9,0
 LWWW H3PP3X+FR3,13,23,0
 LWWW H3PP3X+FR4,36,23,0
 LWWW H3PP3X+FR5,54,44,0
 LWWW H3PP3X+FR6,60,48,0
 LWWW H3PP3X+FR7,63,18,0
 LWWW H3PP3X+FR8,59,8,0
 .long 0
#Razor
	.ref	R4AM4B,R3BF3A,R3GP3Z
 LWWW R4AM4B+FR5,42,-33,0
 LWWW R3BF3A+FR9,26,-32,0
 LWWW R3GP3Z+FR1,14,-20,0
 LWWW R3GP3Z+FR2,14,-16,0
 LWWW R3GP3Z+FR3,23,6,0
 LWWW R3GP3Z+FR4,54,22,0
 LWWW R3GP3Z+FR5,63,41,0
 LWWW R3GP3Z+FR6,70,43,0
 LWWW R3GP3Z+FR7,66,32,0
 LWWW R3GP3Z+FR8,62,0,0
 .long 0
#Taker
	.ref	U4MP4A,U4BF3Z,U3PP3X,U3GP3X
 LWWW U4MP4A+FR7,46,-11,0
 LWWW U4BF3Z+FR1,28,-26,0
 LWWW U3PP3X+FR1,15,-22,1
 LWWW U3PP3X+FR2,18,-18,1
 LWWW U3PP3X+FR3,20,-22,1
 LWWW U3PP3X+FR4,36,-8,1
 LWWW U3PP3X+FR5,57,35,1
 LWWW U3PP3X+FR6,65,60,1
 LWWW U3GP3X+FR1,62,8,1
 LWWW U3GP3X+FR2,69,-7,1
 .long 0
#Yokozuna
	.ref	Y4AM4A,Y3BF3A,Y3PP3Q,Y3FD3N
 LWWW Y4AM4A+FR4,59,-27,0
 LWWW Y3BF3A+FR11,31,-25,0
 LWWW Y3PP3Q+FR1,16,-15,0
 LWWW Y3PP3Q+FR2,13,-17,0
 LWWW Y3PP3Q+FR3,26,-20,0
 LWWW Y3PP3Q+FR4,52,-18,0
 LWWW Y3PP3Q+FR6,50,5,0
 LWWW Y3PP3Q+FR7,52,13,0
 LWWW Y3FD3N+FR2,57,13,0
 LWWW Y3FD3N+FR3,58,22,0
 LWWW Y3FD3N+FR4,63,11,0
 .long 0
#Shawn
	.ref	S4BF3A,S3BF3A,S3GP3X,S3OS3X,S3FD3X
 LWWW S4BF3A+FR3,25,-24,0
 LWWW S3BF3A+FR5,14,-39,0
 LWWW S3GP3X+FR1,15,-24,0
 LWWW S3GP3X+FR2,12,-19,0
 LWWW S3GP3X+FR3,27,-5,0
 LWWW S3GP3X+FR4,53,23,0
 LWWW S3GP3X+FR5,67,39,0
 LWWW S3OS3X+FR8,71,31,1
 LWWW S3FD3X+FR2,69,23,0
 LWWW S3GP3X+FR6,66,4,0
 .long 0
#BamBam
 	.ref	B3BF3C,B4AM4A,B3PP3Q,B3FD3C
 LWWW B3BF3C+FR5,48,-27,0
 LWWW B4AM4A+FR5,27,-24,0
 LWWW B3PP3Q+FR1,12,-26,0
 LWWW B3PP3Q+FR2,11,-15,0
 LWWW B3PP3Q+FR3,31,3,0
 LWWW B3PP3Q+FR4,57,16,0
 LWWW B3PP3Q+FR5,64,33,0
 LWWW B3PP3Q+FR6,57,40,0
 LWWW B3PP3Q+FR7,60,28,0
 LWWW B3PP3Q+FR7,61,46,0
; LWWW B3PP3Q+FR7,61,46,0
; LWWW B3FD3C+FR1,57,13,0
 .long 0
#Doink
 LWWW D3HT3Z+FR1,36,-41,1
 LWWW D3BF3A+FR1,27,-34,0
 LWWW D3PD3Z+FR1,16,-35,1
 LWWW D3PD3Z+FR2,13,-22,1
 LWWW D3PD3Z+FR3,23,0,1
 LWWW D3PD3Z+FR4,39,25,1
 LWWW D3PD3Z+FR5,46,33,1
 LWWW D3PD3Z+FR6,58,23,1
 LWWW D3PD3Z+FR8,58,7,1
 LWWW D3PD3Z+FR9,59,-3,1
 .long 0
#Adam
 .long 0
#Lex
	.ref	L4AM4B,L3BF3B,L3GP3Z,L3FH3A,L3FD3B
 LWWW L4AM4B+FR6,52,-39,0
 LWWW L3BF3B+FR1,9,-34,0
 LWWW L3GP3Z+FR1,13,-22,0
 LWWW L3GP3Z+FR2,16,-16,0
 LWWW L3GP3Z+FR3,27,-16,0
 LWWW L3GP3Z+FR4,46,-5,0
 LWWW L3GP3Z+FR5,63,13,0
 LWWW L3GP3Z+FR6,67,33,0
 LWWW L3FH3A+FR6,58,20,0
 LWWW L3FD3B+FR1,61,2,0
 .long 0

#rollout_tbl
	REFLONG	hrt_break_neck2_anim,rzr_break_neck2_anim
	REFLONG	und_break_neck2_anim
	REFLONG	yok_break_neck2_anim
	REFLONG	shn_break_neck2_anim,bam_break_neck2_anim
	REFLONG	dnk_break_neck2_anim
	.long	0
	REFLONG	lex_break_neck2_anim


#*****************************************************************************
 SUBR	dnk_combo_head_slam_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

;Put cool cheers here

	.word	ANI_ATTACK_ON, AMODE_PUPPET,32,49,50,21 ;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,3,D4GH3A+FR8
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missedc

;got him
	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

; attacker sequence
	WL	ANI_CODE,DO_DOINK_SLAM
	WL	ANI_SET_YVEL,60000h	;50000h

;Float toward the center of ring!
	WL	ANI_CODE,set_xdrift

	.word	ANI_SET_RPTCOUNT,4	;2 times
	.word	ANI_CLR_BUTCOUNT

	WWLLW	ANI_SUPERSLAVE2,3,D4HS3B+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,D4HS3B+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,D4HS3B+FR3,#puppet_tbl,2
;On the way down!
	WWLLW	ANI_SUPERSLAVE2,3,D4HS3B+FR5,#puppet_tbl,3
	.word	ANI_OFFSET,0,34,0			;x,y,z
	WWLLW	ANI_SUPERSLAVE2,3,D4HS3B+FR6,#puppet_tbl,4
	.word	ANI_WAITHITGND
	.WORD	ANI_ADD_MOVE,MOVE_C_6,2,2
	.word	ANI_ZEROVELS
	WWLLW	ANI_SUPERSLAVE2,3,D4HS3B+FR7,#puppet_tbl,5
	.word	ANI_SOUND,33h			;neck break (5-7 ticks late)
	WWLLW	ANI_SUPERSLAVE2,2,D4HS3B+FR8,#puppet_tbl,6

;Maybe do a bounce

	.WORD	ANI_INC_COMBO
	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_DAMAGEOPP,D_FACESLAM1,RD_FACESLAM1
	WWLLW	ANI_SUPERSLAVE2,1,D4HS3B+FR8,#puppet_tbl,6

#try_rptc

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,3,#norepeatc
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#slam_againc
	WL	ANI_GOTO,#norepeatc

#slam_againc
	.WORD	ANI_INC_COMBO
	.word	ANI_CLR_BUTCOUNT

;Slam him again using detach/reattach if button pressed again!
	WL	ANI_SLAVEANIM,#faced2_tbl
	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WL	2,D4HS3B+FR8
	WL	ANI_CODE,DO_DOINK_SLAM
	WL	ANI_SET_YVEL,50000h
	WL	2,D4HS3B+FR7
	WL	13,D4HS3B+FR6

;Reattach me to who I'm slamming
	WL	ANI_CODE,#reattach

	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,3,D4HS3B+FR6,#puppet_tbl,4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WWLLW	ANI_SUPERSLAVE2,3,D4HS3B+FR7,#puppet_tbl,5
;	.word	ANI_SOUND,33h			;neck break (5-7 ticks late)
	WWLLW	ANI_SUPERSLAVE2,1,D4HS3B+FR8,#puppet_tbl,6

;Maybe do a bounce

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_DAMAGEOPP,D_FACESLAM2,RD_FACESLAM2
	WWLLW	ANI_SUPERSLAVE2,1,D4HS3B+FR8,#puppet_tbl,6
	WL	ANI_GOTO,#try_rptc

#norepeatc
	WL	ANI_SLAVEANIM,#faced_tbl
	.word	ANI_DETACH

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	WL	18,D4HS3B+FR8

	WLW	ANI_SET_ZVEL,-10000h,AM_ABS

;Getting up, set no_collis
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS|MODE_NOAUTOFLIP|MODE_OVERLAP	;uninterruptable
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO

	WL	3,D3GU4A+FR5
	WL	3,D3GU4A+FR6
;Check for a flip here
	WL	1,D3GU4A+FR7
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,D3GU4A+FR7
	WL	3,D3GU4A+FR8
	WL	3,D3GU4A+FR9

	.word	ANI_SAFE_TIME,30

	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,37,88,63,9
	WL	1,D3GU4A+FR9
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,dnk_4_push_anim
#no_freetoss

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missedc
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	ANI_CODE,CALL_MISSES
	WL	6,D4HS3B+FR1

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


*******************************************************************************

 SUBR	dnk_3_head_slam_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

;Put cool cheers here

	.word	ANI_ATTACK_ON, AMODE_PUPPET,32,49,50,21 ;mode,x,y,w,h

	WWL	ANI_WAITHITOPP,3,D4GH3A+FR8
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;got him
	.word	ANI_SOUND,82h			;Effort grunt

	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

; attacker sequence
	WL	ANI_CODE,DO_DOINK_SLAM
	WL	ANI_SET_YVEL,60000h	;50000h

;Float toward the center of ring!
	WL	ANI_CODE,set_xdrift

	.word	ANI_SET_RPTCOUNT,4	;2 times
	.word	ANI_CLR_BUTCOUNT

	WWLLW	ANI_SUPERSLAVE2,3,D4HS3B+FR1,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,D4HS3B+FR2,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,D4HS3B+FR3,#puppet_tbl,2
;On the way down!
	WWLLW	ANI_SUPERSLAVE2,3,D4HS3B+FR5,#puppet_tbl,3
	.word	ANI_OFFSET,0,34,0			;x,y,z
	WWLLW	ANI_SUPERSLAVE2,3,D4HS3B+FR6,#puppet_tbl,4
	.word	ANI_WAITHITGND
	.WORD	ANI_ADD_MOVE,MOVE_C_6,2,2
	.word	ANI_ZEROVELS
	WWLLW	ANI_SUPERSLAVE2,3,D4HS3B+FR7,#puppet_tbl,5
;	.word	ANI_SOUND,33h			;neck break (5-7 ticks late)
	WWLLW	ANI_SUPERSLAVE2,2,D4HS3B+FR8,#puppet_tbl,6

;Maybe do a bounce

;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_DAMAGEOPP,D_FACESLAM1,RD_FACESLAM1
	WWLLW	ANI_SUPERSLAVE2,1,D4HS3B+FR8,#puppet_tbl,6

#try_rpt

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,2,#norepeat
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#slam_again
	WL	ANI_GOTO,#norepeat

#slam_again
	.WORD	ANI_ADD_MOVE,MOVE_C_6,2,2
	.word	ANI_CLR_BUTCOUNT

;Slam him again using detach/reattach if button pressed again!
	WL	ANI_SLAVEANIM,#faced2_tbl
	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP

	WL	2,D4HS3B+FR8
	WL	ANI_CODE,DO_DOINK_SLAM
	WL	ANI_SET_YVEL,50000h
	WL	2,D4HS3B+FR7
	WL	13,D4HS3B+FR6

;Reattach me to who I'm slamming
	WL	ANI_CODE,#reattach

	.word	ANI_ATTACHZ,0,0,-2		;x & y don't matter.
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,3,D4HS3B+FR6,#puppet_tbl,4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WWLLW	ANI_SUPERSLAVE2,3,D4HS3B+FR7,#puppet_tbl,5
;	.word	ANI_SOUND,33h			;neck break (5-7 ticks late)
	WWLLW	ANI_SUPERSLAVE2,1,D4HS3B+FR8,#puppet_tbl,6

;Maybe do a bounce

	;impact
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,30
	.word	ANI_DAMAGEOPP,D_FACESLAM2,RD_FACESLAM2
	WWLLW	ANI_SUPERSLAVE2,1,D4HS3B+FR8,#puppet_tbl,6
	WL	ANI_GOTO,#try_rpt

#norepeat
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	.word	ANI_DRAW_NAME,20

	WL	ANI_SLAVEANIM,#faced_tbl
	.word	ANI_DETACH

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	WL	18,D4HS3B+FR8

	WLW	ANI_SET_ZVEL,-10000h,AM_ABS

;Getting up, set no_collis
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOCOLLIS|MODE_NOAUTOFLIP|MODE_OVERLAP	;uninterruptable

	WL	3,D3GU4A+FR5
	WL	3,D3GU4A+FR6
;Check for a flip here
	WL	1,D3GU4A+FR7
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP
	WL	2,D3GU4A+FR7
	WL	3,D3GU4A+FR8
	WL	3,D3GU4A+FR9

	.word	ANI_SAFE_TIME,30


	WL	ANI_CODE,free_toss_check
	WL	ANI_IFNOTSTATUS,#no_freetoss3
	.word	ANI_ATTACK_ON,AMODE_HITCHECK,37,88,63,9
	WL	1,D3GU4A+FR9
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#no_freetoss3

	;Opponent standing too close -- free toss
	WL	ANI_CODE,setup_freetoss
	WL	ANI_CHANGEANIM,dnk_4_push_anim
#no_freetoss3

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
	WL	6,D4HS3B+FR1

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#reattach
	move	*a13(WHOIHIT),a0,L
	move	a0,*a13(ATTACH_PROC),L
	move	a13,*a0(ATTACH_PROC),L
	rets

#puppet_tbl
 .long #Bret
 .long #Razor
 .long #Taker
 .long #Yokozuna
 .long #Shawn
 .long #BamBam
 .long #Doink
 .long #Adam
 .long #Lex

#Bret
	.ref	H3MS3Z,H3MS3X
 LWWW H3MS3Z+FR1,36,-5,0
 LWWW H3MS3Z+FR2,39,0,0
 LWWW H3MS3Z+FR3,51,-1,0
 LWWW H3MS3Z+FR4,58,-4,0
 LWWW H3MS3Z+FR5,62,-6,0
 LWWW H3MS3Z+FR6,57,-11,0
 LWWW H3MS3X+FR5,71,-24,0
 .long 0
#Razor
	.ref	R3MS3Z,R3MS3Q
 LWWW R3MS3Z+FR1,48,-6,0
 LWWW R3MS3Z+FR2,46,5,0
 LWWW R3MS3Z+FR3,53,-2,0
 LWWW R3MS3Z+FR4,65,1,0
 LWWW R3MS3Z+FR5,71,-4,0
 LWWW R3MS3Z+FR6,73,-28,0
 LWWW R3MS3Q+FR1,76,-11,0
 .long 0
#Taker
	.ref	U3MS3Z,U3CF3Q
 LWWW U3MS3Z+FR1,37,9,0
 LWWW U3MS3Z+FR2,25,17,0
 LWWW U3MS3Z+FR3,28,0,0
 LWWW U3MS3Z+FR4,44,-1,0
 LWWW U3MS3Z+FR5,53,4,0
 LWWW U3MS3Z+FR6,55,-14,0
 LWWW U3CF3Q+FR1,61,-26,0
 .long 0
#Yokozuna
	.ref	Y3MS3Z,Y3KF3B
 LWWW Y3MS3Z+FR1,54,-8,0
 LWWW Y3MS3Z+FR2,53,12,0
 LWWW Y3MS3Z+FR3,53,10,0
 LWWW Y3MS3Z+FR4,59,6,0
 LWWW Y3MS3Z+FR5,61,-1,0
 LWWW Y3MS3Z+FR6,62,-27,0
 LWWW Y3KF3B+FR1,66,-2,0
 .long 0
#Shawn
	.ref	S3MS3Z,S3CF3Z
 LWWW S3MS3Z+FR1,31,-10,0
 LWWW S3MS3Z+FR2,29,3,0
 LWWW S3MS3Z+FR3,39,7,0
 LWWW S3MS3Z+FR4,55,5,0
 LWWW S3MS3Z+FR5,61,3,0
 LWWW S3MS3Z+FR6,74,-39,0
 LWWW S3CF3Z+FR1,82,-23,0
 .long 0
#BamBam
	.ref	B3MS3Z,B3RL1A
 LWWW B3MS3Z+FR1,47,2,0
 LWWW B3MS3Z+FR2,49,-4,0
 LWWW B3MS3Z+FR3,52,-2,0
 LWWW B3MS3Z+FR4,65,7,0
 LWWW B3MS3Z+FR5,70,21,0
 LWWW B3MS3Z+FR6,72,3,0
 LWWW B3RL1A+FR7,73,-15,0
 .long 0
#Doink
 LWWW D3GS3X+FR1,52,-15,0
 LWWW D3GS3X+FR3,45,2,0
 LWWW D3GS3X+FR4,51,-2,0
 LWWW D3GS3X+FR5,61,-4,0
 LWWW D3GS3X+FR7,68,-4,0
 LWWW D3GS3X+FR8,67,-39,0
 LWWW D3GS3X+FR9,75,-15,0
 .long 0
#Adam
 .long 0
#Lex
	.ref	L3MS3Z,L3TF3X
 LWWW L3MS3Z+FR1,55,-3,0
 LWWW L3MS3Z+FR2,44,4,0
 LWWW L3MS3Z+FR3,46,1,0
 LWWW L3MS3Z+FR4,57,-4,0
 LWWW L3MS3Z+FR5,60,1,0
 LWWW L3MS3Z+FR6,64,-26,0
 LWWW L3TF3X+FR1,60,-19,0
 .long 0


#faced2_tbl
	REFLONG	hrt_break_face2_anim,rzr_break_face2_anim
	REFLONG	und_break_face2_anim
	REFLONG	yok_break_face2_anim
	REFLONG	shn_break_face2_anim,bam_break_face2_anim
	REFLONG	dnk_break_face2_anim
	.long	0
	REFLONG	lex_break_face2_anim

#faced_tbl
	REFLONG	hrt_break_face_anim,rzr_break_face_anim
	REFLONG	und_break_face_anim
	REFLONG	yok_break_face_anim
	REFLONG	shn_break_face_anim,bam_break_face_anim
	REFLONG	dnk_break_face_anim
	.long	0
	REFLONG	lex_break_face_anim


#*****************************************************************************
*
* Head slams into mat
;From head slam - repeated head slam

 SUBR	dnk_break_face2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS

	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off
	WL	1,D3GS3X+FR9
	WL	ANI_SET_YVEL,80000h
	WL	3,D3GS3X+FR9
	WL	5,D3GS3X+FR10
	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	.word	ANI_WAITROLL
	WL	3,D3GS3X+FR9
	WL	ANI_CHANGEANIM,dnk_faceup_getup_anim
	

 SUBR	dnk_break_face3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS

	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off
	WL	3,D3GS3X+FR4
	WL	ANI_SET_YVEL,078000h
	WL	100,D3GS3X+FR4
	.word	ANI_WAITHITGND
	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,dnk_faceup_getup_anim
	

* Head slams into mat
;From head slam

 SUBR	dnk_break_face_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS

	WL	1,D3GS3X+FR8
	.word	ANI_DEBRIS,100,1,-8,12,0	;%chance, tbl index, x,y,z off
	WL	ANI_SET_YVEL,40000h
	WL	2,D3GS3X+FR8
	WL	5,D3GS3X+FR9
	WL	5,D3GS3X+FR10
	.word	ANI_WAITHITGND
	WL	ANI_CODE,SMALL_BOUNCE
	.word	ANI_ZEROVELS
	WL	4,D3GS3X+FR8
	WL	4,D3GS3X+FR9
	WL	4,D3GS3X+FR10
	WL	4,D3GS3X+FR8

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	1,D3GS3X+FR8		;Face down
	.word	ANI_WAITROLL

	WL	ANI_CHANGEANIM,dnk_faceup_getup_anim

#*****************************************************************************

;	.bss	#opp_xvel,32

 SUBR	dnk_3_fake_hold_anim
;Head hold when standing next to player
;No collisions possible
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold

	.word	ANI_STARTATTACK,AT_PUPPET,6
	WL	2,D4GH3A+FR1
	WL	2,D4GH3A+FR2
	WL	2,D4GH3A+FR3
	WL	7,D4GH3A+FR4
	WL	ANI_GOTO,#missed

 SUBR	dnk_3_head_hold2_anim
;Head hold when standing next to player
;No collisions possible
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold

	.word	ANI_STARTATTACK,AT_PUPPET,6
	WL	2,D4GH3A+FR1
	WL	2,D4GH3A+FR2
	WL	2,D4GH3A+FR3
	.word	ANI_ATTACK_ON, AMODE_PUPPET_HDGRAB,32,60,62,45 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,7,D4GH3A+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb

	.WORD	ANI_ADD_MOVE,MOVE_C_7,2,2

	WL	ANI_GOTO,#gothim

 SUBR	dnk_3_head_hold_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

;#4 grab to head hold
	.word	ANI_STARTATTACK,AT_PUPPET,7

	WL	2,D4GH3A+FR1
	WL	2,D4GH3A+FR2
	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
;	LEAPATOPP 6,999,65,45,90000h,TGT_HEAD,60,105,0	;88
	LEAPATOPP 9,999,40,45,90000h,TGT_HEAD,60,105,0	;88

	WL	3,D4GH3A+FR3
	.word	ANI_ATTACK_ON, AMODE_PUPPET,32,60,62,45 ;mode,x,y,w,h
	WWL	ANI_WAITHITOPP,5,D4GH3A+FR4
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	WL	ANI_IFBLOCKED,#missedb

#gothim
;got him
	.word	ANI_SETWORD,USR_VAR2,0
	.word	ANI_CLR_BUTCOUNT
	WL	ANI_CODE,head_grab_time

	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	WL	ANI_CODE,DO_NONO
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	WWLLW	ANI_SUPERSLAVE2,1,D4GH3A+FR4,#puppet_tbl,0

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WWLLW	ANI_SUPERSLAVE2,4,D4GH3A+FR4,#puppet_tbl,0

	WWLLW	ANI_SUPERSLAVE2,4,D4GH3A+FR5,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,4,D4GH3A+FR7,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,4,D4GH3A+FR8,#puppet_tbl,3

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	WL	1,D4GH3A+FR8

;	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missedb
	.word	ANI_ZEROVELS
	WL	ANI_SET_YVEL,30000h

	WL	3,D4GH3A+FR4
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	3,D4GH3A+FR3
	WL	3,D4GH3A+FR2
	WL	3,D4GH3A+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END
#missed
	WL	ANI_CODE,CALL_MISSES

	.word	ANI_ZERO_XZVELS
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	5,D4GH3A+FR4
	WL	3,D4GH3A+FR3
	WL	3,D4GH3A+FR2
	WL	3,D4GH3A+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


 SUBR	head_grab_time

	move	@PCNT,a14,L			;use 32-bit PCNT!
	move	a14,*a13(LAST_HEADHOLD),L
	calla	CALL_SETUP
	;fall through

 SUBR	clear_opp_counts
;Zero opponents buttons for later counting
	clr	a14
	move	*a13(ATTACH_PROC),a0,L
	move	a14,*a0(PUNCHB_COUNT)
	move	a14,*a0(BLOCKB_COUNT)
	move	a14,*a0(SPUNCHB_COUNT)
	move	a14,*a0(KICKB_COUNT)
	move	a14,*a0(SKICKB_COUNT)

	rets

;;new xvel is (attacker xvel + defender xvel)/4
; SUBR	merge_xvels
;
;	move	@#opp_xvel,a0,L
;	move	*a13(OBJ_XVEL),a1,L
;	add	a1,a0
;;	sra	2,a0
;	move	a0,*a13(OBJ_XVEL),L
;#rets
;	rets

;save opponent's x-velocity
; SUBR	store_opp_xvel
;	move	*a13(CLOSEST_NUM),a0
;	X32	a0
;	addi	process_ptrs,a0
;	move	*a0,a0,L
;	move	*a0(OBJ_XVEL),a0,L
;	move	a0,@#opp_xvel,L
;	rets

#puppet_tbl
 .long #Bret
 .long #Razor
 .long #Taker
 .long #Yokozuna
 .long #Shawn
 .long #BamBam
 .long #Doink
 .long #Adam
 .long #Lex

#Bret
 LWWW H4AH3A+FR1,72,17,0
 LWWW H3HB3A+FR3,66,5,0
 LWWW H3HB3A+FR2,56,-6,0
 LWWW H3BF3A+FR1,48,-35,0
 .long 0
#Razor
 LWWW R4AH4C+FR3,70,16,0
 LWWW R3HB3A+FR3,67,3,0
 LWWW R3HB3A+FR2,63,-17,0
 LWWW R3BF3A+FR1,53,-37,0
 .long 0
#Taker
 LWWW U4AH3A+FR2,65,26,0
 LWWW U4BF3A+FR2,60,17,0
 LWWW U4BF3A+FR3,30,-3,0
 LWWW U4BF3Z+FR5,52,-16,0
 .long 0
#Yokozuna
 LWWW Y4AE4A+FR2,80,7,0
 LWWW Y4AM4A+FR1,79,6,0
 LWWW Y4AM4A+FR2,69,-5,0
 LWWW Y3BF3A+FR1,55,-25,0
 .long 0
#Shawn
 LWWW S4AH3D+FR5,73,6,0
 LWWW S4AH3D+FR1,66,10,0
 LWWW S4BF3A+FR2,62,-9,0
 LWWW S3BF3A+FR1,37,-36,0
 .long 0
#BamBam
 LWWW B4AH4A+FR1,68,11,0
 LWWW B4BF3A+FR1,74,15,0
 LWWW B3HB3A+FR2,62,-20,0
 LWWW B3BF3C+FR5,54,-29,0
 .long 0
#Doink
 LWWW D3AH3B+FR1,60,13,0
 LWWW D3AK3A+FR3,59,16,0
 LWWW D3AK3A+FR2,64,-5,0
 LWWW D3BF3A+FR2,51,-35,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L4AH4B+FR3,68,9,0
 LWWW L3BF3A+FR1,74,11,1
 LWWW L3BF3A+FR2,65,-10,1
 LWWW L3BF3B+FR5,49,-33,0
 .long 0

#headheld_tbl
	REFLONG	hrt_3_head_held_anim
	REFLONG	rzr_3_head_held_anim
	REFLONG	und_3_head_held_anim
	REFLONG	yok_3_head_held_anim
	REFLONG	shn_3_head_held_anim
	REFLONG	bam_3_head_held_anim
	REFLONG	dnk_3_head_held_anim
	.long	0
	REFLONG	lex_3_head_held_anim

#*****************************************************************************

 SUBR	dnk_3_head_held_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_HEADHELD
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim

;	WL	4,D3BF3Z+FR1
;	WL	4,D3BF3Z+FR2

	.word	ANI_SETWORD,USR_VAR1,0		;loop count

#loop
	WL	4,D3BF3A+FR2
	WL	4,D3BF3A+FR3
	WL	4,D3BF3A+FR4
	WL	4,D3BF3A+FR5
	WL	4,D3BF3A+FR6
	WL	4,D3BF3A+FR7
	WL	4,D3BF3A+FR8
	WL	4,D3BF3A+FR1
	WL	ANI_CODE,#inc_loop
	WL	ANI_IFNOTSTATUS,#loop

;Continue into break...

 SUBR	dnk_3_head_held_brk_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	ANI_CODE,FIND_AND_KILL_ENDLESS

	WLW	ANI_SET_XVEL,-38000h,AM_NEWFACE_REL
	WL	ANI_SET_YVEL,40000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	WL	4,D3AK3A+FR2
	.word	ANI_DETACH

;Standard #2 head hit from spin kick
	WL	3,D2AH2A+FR1
	WL	4,D2AH2A+FR2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	4,D2AH2A+FR3

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


;Loop 4 times, then break out!
#inc_loop
	move	*a13(USR_VAR1),a0
	inc	a0
	move	a0,*a13(USR_VAR1)
	cmpi	2,a0
	jrgt	#breakout
	
;He may have let me go by hitting his block butn!
;Handled in mode_headheld!
;	move	*a13(ATTACH_PROC),a0,L
;	jrz	#breakout

	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets

#breakout
	move	*a13(ANIMODE),a1
	ori	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets

 SUBR	dnk_3_head_held_stand_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WL	3,D3AK3A+FR2
	WL	3,D1TT5Z+FR2	;2.5
	.word	ANI_DETACH

	.word	ANI_FACEUP
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* KNEE TO HEAD HELD OPPONENT

 SUBR	dnk_3_knee_to_head_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_KNEE,9
	WL	2,D3SK3X+FR1
	WL	2,D3SK3X+FR2
	WL	2,D3SK3X+FR3

	.word	ANI_ATTACK_ON, AMODE_KNEE,20,62,68,16
	WL	2,D3SK3X+FR4
	.word	ANI_ATTACK_OFF
	WL	17,D3SK3X+FR4

	WL	3,D3SK3X+FR5
	WL	3,D3SK3X+FR6
	WL	3,D3SK3X+FR7

	.word	ANI_FACEUP
;	.word	ANI_FACE,MOVE_RIGHT|MOVE_DOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


 SUBR	dnk_3_knees_to_head_anim

;Need to do a move which kicks guys in the ass!

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SET_RPTCOUNT,3	;2 times
	.WORD	ANI_ADD_MOVE,MOVE_C_4,2,2
	WL	ANI_GOTO,#skp
#rpt
	.word	ANI_STARTATTACK,AT_KNEE,10
	WL	3,D4KH3A+FR3
#skp
	WL	ANI_SET_YVEL,30000h
	.word	ANI_CLR_BUTCOUNT

	WL	2,D4KM3A+FR2
	WL	2,D4KM3A+FR3
	WL	3,D4KM3A+FR4

	.word	ANI_ATTACK_ON, AMODE_HEADKNEES,20,42,68,36
	WL	4,D4KM3A+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#exit
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#rpt

	.word	ANI_CLR_BUTCOUNT

	WL	2,D4KM3A+FR4
	WL	2,D4KM3A+FR3
	WL	ANI_SET_YVEL,40000h
	WL	2,D4KM3A+FR2
	WL	2,D4KM3A+FR3
	WL	2,D4KM3A+FR4

	.word	ANI_ATTACK_ON, AMODE_HEADKNEES,20,42,68,36
	WL	4,D4KM3A+FR5
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	WWWL	ANI_IF_BUTCOUNT_GE,SPUNCHB_COUNT,1,#do_pile

#exit
#missed
	.word	ANI_DETACH
	.word	ANI_OFFSET,0,0,-5			;x,y,z
	WL	2,D4KM3A+FR6
	WL	2,D4KM3A+FR7
	WL	2,D4KM3A+FR8
 	WL	2,D4KM3A+FR9
	WL	2,D4KM3A+FR10
	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#do_pile
	WL	2,D4KM3A+FR6
	WL	2,D4KM3A+FR7
	WL	2,D4KM3A+FR8
 	WL	2,D4KM3A+FR9
	WL	2,D4KM3A+FR10

	.word	ANI_DETACH
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,dnk_3_pile_driver_anim
;	.word	ANI_END


#*****************************************************************************
*
* UPPERCUT TO HEAD HELD OPPONENT

 SUBR	dnk_uppercut_to_head_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_KNEE,16
	WL	2,D4GP3C+FR2
	WL	2,D4GP3C+FR3
	WL	2,D4GP3C+FR4
	WL	2,D4GP3C+FR5
	.WORD	ANI_SOUND,43H
	.word	ANI_ATTACK_ON, AMODE_KNEE,44,57,32,37 ;mode,x,y,w,h
	WL	10,D4GP3C+FR6
	.word	ANI_ATTACK_OFF
	WL	3 ,D4GP3C+FR7

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#*****************************************************************************
*
* UPPERCUT TO IN CLOSE OPPONENT

 SUBR	dnk_4_uppercut_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_PUNCH,6
	WL	1,D4GP3C+FR2
	WL	1,D4GP3C+FR3
	WL	2,D4GP3C+FR4
	WL	2,D4GP3C+FR5
;	.WORD	ANI_SOUND,43H
	.word	ANI_ATTACK_ON, AMODE_UPRCUT,44,57,32,37 ;mode,x,y,w,h
	WL	2,D4GP3C+FR6
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed
	.WORD	ANI_ADD_MOVE,MOVE_C_4,2,2
	WL	ANI_IFBLOCKED,#missedb		;Yes, I hit blocker
;Got him
;Hit, spray some explosions

	.word	ANI_SET_ATTACH
	.word	ANI_DEBRISAT,400,1,10,50,0	;%chance, tbl index, x,y,z off
	.word	ANI_DETACH
	WL	ANI_CODE,CALL_OTHER_AVERAGE
	.WORD	ANI_SOUND,43H

	WL	ANI_CODE,#set_zvel
	.word	ANI_SHAKER,35
;	WL	ANI_CODE,HIT_THE_MAT
	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2
	WL	10,D4GP3C+FR6
#no_hit2
	WL	15,D4GP3C+FR6
	WL	4,D4GP3C+FR7

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#set_zvel
	move	*a13(WHOIHIT),a0,L
	move	*a0(OBJ_ZVEL),a14,L
	jrnz	#skip
	movi	10000h,a14
	move	a14,*a0(OBJ_ZVEL),L
#skip	rets

#missedb
	WL	12,D4GP3C+FR6
#missed
	WL	3,D4GP3C+FR6
	WL	3,D4GP3C+FR7

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


;FIX!!!  Make cooler...
#*****************************************************************************
*
* UPPERCUT TO HEAD HELD OPPONENT

 SUBR	dnk_combo_uppercut_to_head_anim

	.WORD	ANI_CLEAR_COMBO
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	WLW	ANI_SET_XVEL,30000h,AM_FACE_REL

	.word	ANI_STARTATTACK,AT_KNEE,9
	WL	2,D4GP3C+FR2
	WL	3,D4GP3C+FR3

	WL	2,D4GP3C+FR4
	WL	2,D4GP3C+FR5
	.WORD	ANI_SOUND,43H
	.WORD	ANI_INC_COMBO
	.word	ANI_ATTACK_ON, AMODE_KNEE,44,37,32,57 ;mode,x,y,w,h
	WL	1,D4GP3C+FR6
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#miss
	WL	ANI_CODE,SET_OPTIMAL_POSITION
	.WORD	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,0h,0h		;x,y,z vels
	.word	ANI_STARTATTACK,AT_KNEE,12
	WL	3,D4GP3C+FR6
	WL	3 ,D4GP3C+FR7

	.word	ANI_CLR_BUTCOUNT

	WL	2,D4GP3C+FR2
	WL	1,D4GP3C+FR3

	WL	2,D4GP3C+FR4
	WL	1,D4GP3C+FR5
	.WORD	ANI_SOUND,43H
	.word	ANI_ATTACK_ON, AMODE_KNEE,44,37,32,57 ;mode,x,y,w,h
	WL	1,D4GP3C+FR6
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#miss
	.WORD	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,0h,0h		;x,y,z vels

	.word	ANI_STARTATTACK,AT_KNEE,8
	WL	1,D4GP3C+FR6
	WL	2 ,D4GP3C+FR7

	WL	1,D4GP3C+FR2
	WL	2,D4GP3C+FR3

	WL	1,D4GP3C+FR4
	WL	1,D4GP3C+FR5
	.WORD	ANI_SOUND,43H
	.word	ANI_ATTACK_ON, AMODE_KNEE,44,37,32,57 ;mode,x,y,w,h
	WL	1,D4GP3C+FR6
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#miss
	.WORD	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,0h,0h		;x,y,z vels
	.word	ANI_STARTATTACK,AT_KNEE,8
	WL	1,D4GP3C+FR6
	WL	2 ,D4GP3C+FR7

	WL	1,D4GP3C+FR2
	WL	2,D4GP3C+FR3

	WL	1,D4GP3C+FR4
	WL	1,D4GP3C+FR5
	.WORD	ANI_SOUND,43H
	.word	ANI_ATTACK_ON, AMODE_KNEE,44,37,32,57 ;mode,x,y,w,h
	WL	1,D4GP3C+FR6
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#miss
	.WORD	ANI_INC_COMBO
;	.word	ANI_SET_ATTACH
	WLLL	ANI_SETOPPVELS,0,0h,0h		;x,y,z vels
	WLW	ANI_SET_XVEL,80000h,AM_FACE_REL
	WL	1,D4GP3C+FR6
	WL	2 ,D4GP3C+FR7
	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#NEXT_CHECK_2
	WL	ANI_CHANGEANIM,dnk_combo_box_anim
#NEXT_CHECK_2
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#NEXT_CHECK
	WL	ANI_CHANGEANIM,dnk_combo_knee_fall_anim

#NEXT_CHECK
	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#miss
	WL	ANI_CHANGEANIM,dnk_4_combo_butt_anim

#miss
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_DETACH
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

SET_OPTIMAL_POSITION
	MOVE	*A13(WHOIHIT),A0,L
	MOVE	*A13(OBJ_XPOS),A2,L
	MOVI	[70,0],A1
	MOVE	*A13(FACING_DIR),A3
	BTST	MOVE_LEFT_BIT,A3
	JRZ	NO_NEED_TO_NEG_XDIR
	NEG	A1
NO_NEED_TO_NEG_XDIR
	ADD	A1,A2
	MOVE	A2,*A0(OBJ_XPOS),L
	RETS


 SUBR	dnk_uppercuts_to_head_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.WORD	ANI_ADD_MOVE,MOVE_C_4,2,2

	.word	ANI_SETWORD,USR_VAR2,0

	.word	ANI_CLR_BUTCOUNT
	.word	ANI_SET_RPTCOUNT,3	;rpt 2 times
	WL	3,D4GP3C+FR2
	WL	3,D4GP3C+FR3
	WL	ANI_GOTO,#skp
#rpt
	.word	ANI_CLR_BUTCOUNT

	WL	2,D4GP3C+FR8
	WL	2,D4GP3C+FR9
	WL	2,D4GP3C+FR3
#skp
	WL	2,D4GP3C+FR4
	WL	2,D4GP3C+FR5
	.WORD	ANI_SOUND,43H
	.word	ANI_ATTACK_ON, AMODE_HEADKNEES,44,57,32,37 ;mode,x,y,w,h
	WL	3,D4GP3C+FR6
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	.word	ANI_SET_ATTACH
	.word	ANI_DEBRISAT,250,1,10,50,0	;%chance, tbl index, x,y,z off
;	.word	ANI_DETACH

	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,1,#exit
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#rpt

;Completed multiple uppercuts, allow flings, etc.
;	.word	ANI_SET_ATTACH
;	.word	ANI_SETOPP_PLYRMODE,MODE_NORMAL
;	.word	ANI_DETACH

	.word	ANI_SETWORD,USR_VAR2,1
	.word	ANI_CLR_BUTCOUNT

	WL	2,D4GP3C+FR8
	WL	2,D4GP3C+FR9
	WL	2,D4GP3C+FR3
	WL	2,D4GP3C+FR4
	WL	2,D4GP3C+FR5
	.WORD	ANI_SOUND,43H
	.word	ANI_ATTACK_ON, AMODE_HEADKNEES,44,57,32,37 ;mode,x,y,w,h
	WL	3,D4GP3C+FR6
	.word	ANI_ATTACK_OFF
	WL	ANI_IFNOTSTATUS,#missed

	WL	ANI_CODE,#go_high

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#exit

	WL	3,D4GP3C+FR7

	WL	ANI_CHANGEANIM,dnk_flying_kick_anim
;	.word	ANI_END

#exit
#missed
	.word	ANI_OFFSET,0,0,-5			;x,y,z
	WL	3,D4GP3C+FR7
	.word	ANI_DETACH
	.word	ANI_FACEDOWN

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


#go_high
;Got rid of this because attach_proc is a zero after a hit
;	move	*a13(ATTACH_PROC),a0,L
;	move	*a0(WRESTLERNUM),A14
;	cmpi	3,a14				;Yoko
;	jrz	#x
;	movi	50000h,a14
;	move	a14,*a0(OBJ_YVEL),L

	move	*a13(CLOSEST_NUM),a14
	X32	a14
	addi	process_ptrs,a14
	move	*a14,a14,L

	move	*a14(WRESTLERNUM),a0
	cmpi	3,a0				;Yoko too fat
	jrz	#x

	movi	50000h,a0			;Go higher for last hit!
	move	a0,*a14(OBJ_YVEL),L
#x	rets


#chk_count
	move	*a13(ANIMODE),a0
	andni	MODE_STATUS,a0
	move	*a13(BUT_COUNT),a14
	jrz	#fail
	ori	MODE_STATUS,a0
#fail
	move	a0,*a13(ANIMODE)
	rets


#*****************************************************************************
*
* #2 SLAP


 SUBR	dnk_2_slap_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_SPINKIK,30
	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2
	WL	2,D2BS3A+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 0dh,999,4ah-5,50,90000h,TGT_HEAD,96,105,-30

	WL	3,D2BS3A+FR2
	WL	07h,D2BS3A+FR3
	WL	3,D2BS3A+FR4

	.word	ANI_ATTACK_ON, AMODE_BACKHAND,75,81,36,28	;mode,x,y,w,h
	WL	3,D2BS3A+FR5
	WL	3,D2BS3A+FR6

	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit

	WL	ANI_SET_YVEL,40000h
	WL	10,D2BS3A+FR6
#no_hit

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	5,D2BS3A+FR6


	WL	ANI_CODE,spunch_delay
	WL	ANI_IFNOTSTATUS,#none
	WL	15,D2BS3A+FR6
#none


	WL	3,D2BS3A+FR8
	WL	3,D2BS3A+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#*
* #4 SLAP

 SUBR	dnk_4_slap_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_STARTATTACK,AT_SPINKIK,30
	.WORD	ANI_ADD_MOVE,MOVE_C_3,2,2
	WL	2,D4BS3A+FR1

	;	ticks,range max,hiX,hiZ,hiYvel,tgt,Xoff,Yoff,Zoff
	LEAPATOPP 0dh,999,4ah-5,50,90000h,TGT_HEAD,96,105,30

	WL	3,D4BS3A+FR2
	WL	07h,D4BS3A+FR3
	WL	3,D4BS3A+FR4

	.word	ANI_ATTACK_ON, AMODE_BACKHAND,75,81,36,28	;mode,x,y,w,h
	WL	3,D4BS3A+FR5
	WL	3,D4BS3A+FR6

	.word	ANI_ATTACK_OFF

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit2

	WL	ANI_SET_YVEL,40000h
	WL	10,D4BS3A+FR6
#no_hit2
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	WL	5,D4BS3A+FR6

	WL	ANI_CODE,spunch_delay
	WL	ANI_IFNOTSTATUS,#none
	WL	15,D4BS3A+FR6
#none

	WL	3,D4BS3A+FR8
	WL	3,D4BS3A+FR9

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END


 SUBR	spunch_delay

     	move	@royal_rumble,a0
	jrnz	#ok
	move	@PSTATUS,a0
	subk	3,a0
	jrz	#cont
	move	@NUM_OPPS,a0
	subk	1,a0
	jrnz	#ok
#cont
	move	*a13(LAST_SPUNCH),a14,L
	move	@PCNT,a0,L			;use 32-bit PCNT!
	move	a0,*a13(LAST_SPUNCH),L
	sub	a14,a0
	cmpi	2*60,a0
	jrge	#ok

;This blocked fling attempt is too close (in terms of time) to most recent grab
	move	*a13(ANIMODE),a1
	ori	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets

#ok	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)
	rets

#*****************************************************************************
*
* EAR SLAP


 SUBR	dnk_2_earslap_anim
 SUBR	dnk_4_earslap_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	.word	ANI_SET_RPTCOUNT,4	;3 times
	.word	ANI_CLR_BUTCOUNT

	.word	ANI_STARTATTACK,AT_LEAPING,14
	WL	2,D3ES3A+FR1

	LEAPATOPP 0dh,999,58h,80,90000h,TGT_HEAD,106,105,-30

	WL	3,D3ES3A+FR2
	WL	5,D3ES3A+FR3
	WL	3,D3ES3A+FR4
	WL	3,D3ES3A+FR5

	.word	ANI_ZERO_XZVELS

	.word	ANI_ATTACK_ON, AMODE_EARSLAP,70,74,60,42	;mode,x,y,w,h
	.word	ANI_SOUND,43h
	.word	ANI_SHAKER,22
	WL	3,D3ES3A+FR6

	.word	ANI_ATTACK_OFF

	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	WL	ANI_IFBLOCKED,#contz
	WL	ANI_IFSTATUS,#gothim

#cont
	WL	10,D3ES3A+FR6
	WL	ANI_GOTO,#no_hit2
#contz
	WL	ANI_CODE,CALL_SPECIAL_MOVE
	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	WL	ANI_GOTO,#no_hitz
#gothim
	.word	ANI_DRAW_NAME,22
	.word	ANI_DAMAGEOPP,D_EARSLAP1,RD_EARSLAP1
	WL	ANI_CODE,CALL_SPECIAL_MOVE

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_DEBRIS,100,4,120,100,0	;%chance, tbl index, x,y,z off
#no_hitz
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,2,#fail
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#dnk_quick_earslap
#fail

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hit3

	WL	ANI_SET_YVEL,40000h
	WL	10,D3ES3A+FR6
#no_hit3
	WL	ANI_CODE,CALL_MISSES
	WL	8,D3ES3A+FR6
	WL	3,D3ES3A+FR5
	WL	3,D3ES3A+FR4
	WL	3,D3ES3A+FR3
	WL	3,D3ES3A+FR2
	WL	3,D3ES3A+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#dnk_quick_earslap
	.word	ANI_CLR_BUTCOUNT
	.word	ANI_STARTATTACK,AT_EARSLAP1,14
	WL	2,D3ES3A+FR5
	WL	2,D3ES3A+FR4
	WL	2,D3ES3A+FR3
	WL	2,D3ES3A+FR2
	WL	2,D3ES3A+FR3
	WL	2,D3ES3A+FR4
	WL	2,D3ES3A+FR5

	.word	ANI_ATTACK_ON, AMODE_EARSLAP,70,74,60,42	;mode,x,y,w,h
	.word	ANI_SHAKER,22
	WL	3,D3ES3A+FR6
	.word	ANI_ATTACK_OFF
	WL	ANI_IFBLOCKED,#cont

	.WORD	ANI_ADD_MOVE,MOVE_C_8,2,2
	WWWL	ANI_IF_BUTCOUNT_LT,PUNCHB_COUNT,2,#fail2
	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#dnk_quick_earslap
#fail2

;	.word	ANI_ATTACK_ON, AMODE_BACKHAND,90,74,40,42	;mode,x,y,w,h
	.word	ANI_ATTACK_ON, AMODE_HDBUTT,70,74,60,42	;mode,x,y,w,h

	.word	ANI_SHAKER,22
	WL	3,D3ES3A+FR6
	.word	ANI_ATTACK_OFF

	WL	ANI_CODE,#set_opp_y

;Stay in this buzz sequence longer if player keeps whacking on his punch button!

;	WL	ANI_SLAVEANIM,#drift_tbl
;	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP
;
;	.word	ANI_DETACH

	WWL	ANI_SLIDE_BACK,30h,-70000h,#no_hitx

	WL	ANI_SET_YVEL,40000h
	WL	10,D3ES3A+FR6
#no_hitx
	WL	15-8,D3ES3A+FR6

#no_hit2
	WL	8,D3ES3A+FR6
	WL	3,D3ES3A+FR5
	WL	3,D3ES3A+FR4
	WL	3,D3ES3A+FR3
	WL	3,D3ES3A+FR2
	WL	3,D3ES3A+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#set_opp_y
	move	*a13(WHOIHIT),a0,L
	movi	[4,0],a14
	move	a14,*a0(OBJ_YVEL),L
	rets

 SUBR	dnk_4_combo_earslap_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_SET_RPTCOUNT,4	;2 times

;	.word	ANI_STARTATTACK,AT_EARSLAP1,17

	WL	3,D3ES3A+FR1

	LEAPATOPP 0dh,999,50h,80,90000h,TGT_HEAD,106,105,-30

	WL	3,D3ES3A+FR2

	WL	5,D3ES3A+FR3
	WL	3,D3ES3A+FR4
	WL	3,D3ES3A+FR5

	.word	ANI_ZERO_XZVELS

	.word	ANI_ATTACK_ON, AMODE_EARSLAP,70,74,60,42	;mode,x,y,w,h
	.word	ANI_SOUND,43h
	.word	ANI_SHAKER,22
	WL	12,D3ES3A+FR6

	.word	ANI_ATTACK_OFF

	WL	ANI_IFSTATUS,#gothimc
	WL	12,D3ES3A+FR6
	WL	ANI_GOTO,#no_hit2c

#gothimc
	.WORD	ANI_INC_COMBO
	.word	ANI_DAMAGEOPP,D_EARSLAP2,RD_EARSLAP2

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS

	.word	ANI_CLR_BUTCOUNT

#dnk_quick_combo_earslap
;	.word	ANI_STARTATTACK,AT_EARSLAP1,10
	WL	1,D3ES3A+FR5
	WL	2,D3ES3A+FR4
	WL	1,D3ES3A+FR3
	WL	2,D3ES3A+FR2
	WL	1,D3ES3A+FR3
	WL	2,D3ES3A+FR4
	WL	1,D3ES3A+FR5

	.word	ANI_ATTACK_ON, AMODE_EARSLAP,70,74,60,42	;mode,x,y,w,h
	.word	ANI_SHAKER,22
	WL	3,D3ES3A+FR6
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#no_hit2c
	.WORD	ANI_INC_COMBO

	.word	ANI_DEC_RPTCOUNT
	WL	ANI_IF_RPTCOUNT,#dnk_quick_combo_earslap

	WL	3,D3ES3A+FR6
	WL	3,D3ES3A+FR5
	WL	3,D3ES3A+FR4

	WWWL	ANI_IF_BUTCOUNT_LT,KICKB_COUNT,1,#NEXT_CHECK

	.word	ANI_IMMOBILIZE,30
	WLW	ANI_SET_XVEL,10000h,AM_FACE_REL
	WL	ANI_CHANGEANIM,dnk_combo_buzz2_anim

#NEXT_CHECK
	WWWL	ANI_IF_BUTCOUNT_LT,SPUNCHB_COUNT,1,#NEXT_CHEK2

	WL	3,D3ES3A+FR3
	WL	3,D3ES3A+FR2
	WL	3,D3ES3A+FR1

	WLW	ANI_SET_XVEL,10000h,AM_FACE_REL
	WL	ANI_CHANGEANIM,dnk_combo_flying_kick_anim
#NEXT_CHEK2
	WWWL	ANI_IF_BUTCOUNT_LT,SKICKB_COUNT,1,#missed

	WLW	ANI_SET_XVEL,50000h,AM_FACE_REL

	WL	3,D3ES3A+FR3
	WL	3,D3ES3A+FR2
	WL	3,D3ES3A+FR1

	WL	ANI_CHANGEANIM,dnk_combo_head_slam_anim

#missed
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

#no_hit2c
	WL	ANI_CODE,DO_COMBO_MESS
	.WORD	ANI_CLEAR_COMBO
	WL	8,D3ES3A+FR6
	WL	3,D3ES3A+FR5
	WL	3,D3ES3A+FR4
	WL	3,D3ES3A+FR3
	WL	3,D3ES3A+FR2
	WL	3,D3ES3A+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END

	
#*******************************
* Smoke trail (Process)
* A10=*wrestler proc

 SUBR	body_smoke

	clr	a11
#lp	CREATE0	smokepuff
	SLEEPK	1
	inc	a11
	cmpi	17,a11
	jrlt	#lp

	DIE


#*******************************
* Smoke trail puff (Process)
* A10=*wrestler proc

 SUBRP	smokepuff

	move	*a10(OBJ_ZPOSINT),a3
	movk	3,a0
	calla	RNDRNG0
	subk	2,a0
	add	a0,a3			;-2 to 1
	addk	16,a3
	ori	1000h,a3

	movk	3,a0
	calla	RNDRNG0
	sll	5,a0			;*32
	addi	smoke_t,a0
	move	*a0,a9,L

	movi	[1,8000h],a6
	movi	[-2,0],a7

	move	a11,a14
	sll	4,a14
	addi	#x_tbl,a14
	move	*a14,a1

	move	*a10(OBJ_XPOSINT),a0

	move	*a10(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#no_flip
	neg	a6
	neg	a1
#no_flip
	add	a1,a0
	sll	16,a0			;X

	move	a11,a14
	sll	4,a14
	addi	#y_tbl,a14
	move	*a14,a14

	movi	Y_SCALE_MULTIPLIER,a2
	move	*a10(OBJ_ZPOSINT),a1
	mpyu	a2,a1
	move	*a10(OBJ_YPOSINT),a2
	sub	a14,a2
	addi	0h,a2
	sll	16,a2
	sub	a2,a1

	movi	CLDB1ORNG,a2
	movi	DMAWNZ|M_3D|M_NOCOLL,a4
	movi	CLSDEAD,a5

	calla	BEGINOBJ

	SLEEPK	3

	jauc	FRQDELDIE

#x_tbl	.word	-14,-3,10,25,30,31,30,39,26,-3,17,32,53,54,41,32,45
#y_tbl	.word	-14,-33,-51,-59,-39,-20,-2,-67,-75,-76,-84,-77,-57,-81
	.word	-86,-98,-108

	.def	smoke_t
smoke_t
	.long	cldbw_l,cldblg_l,cldbgry_l,cldblg2_l

cldbw_l
	LW	CLDB2,3
	LWL	CLDB3,NEWPALET|3,ORNGPAL
	LW	CLDB4,2
	LWL	CLD5,NEWPALET|2,WHTPAL
	LW	CLD6,2
	LW	CLD7,2
	LW	CLD8,2
	LW	CLD9,2
	LWL0	CLD10,2
cldblg_l
	LW	CLDB2,2
	LWL	CLDB3,NEWPALET|3,ORNGPAL
	LW	CLDB4,2
	LWL	CLD5,NEWPALET|2,LGRYPAL
	LW	CLD6,2
	LW	CLD7,2
	LW	CLD8,2
	LW	CLD9,2
	LWL0	CLD10,2
cldbgry_l
	LW	CLDB2,3
	LWL	CLDB3,NEWPALET|2,ORNGPAL
	LW	CLDB4,2
	LWL	CLD5,NEWPALET|2,GREYPAL
	LW	CLD6,2
	LW	CLD7,2
	LW	CLD8,2
	LW	CLD9,2
	LWL0	CLD10,2
cldblg2_l
	LW	CLDB2,2
	LWL	CLDB3,NEWPALET|2,ORNGPAL
	LWL	CLDB4,NEWPALET|2,LGRYPAL
	LW	CLD5,2
	LW	CLD6,2
	LW	CLD7,2
	LW	CLD8,2
	LW	CLD9,2
	LWL0	CLD10,2

#*******************************
* Start sparks in AMODE
* A10=*wrestler proc

 SUBRP	hand_sparks

	movi	11,a11		;13
#lp	CREATE0	one_spark
	CREATE0	one_spark
	SLEEPK	3
	dsj	a11,#lp
	DIE

GRAV		equ	04000h	;9000h	;a000h	;6000h

#********************************
* Spark from hand buzzer (Process)
* A10=*wrestler proc

 SUBR	one_spark

	movk	>a,a0
	calla	RNDRNG0
	subk	5,a0
	sll	14,a0			;XVel
	move	a0,a6

	movk	>3,a0
	calla	RNDRNG0
	addk	1,a0
	sll	16,a0			;YVel
	neg	a0
	move	a0,a7

	move	*a10(OBJ_ZPOSINT),a3
	movk	3,a0
	calla	RNDRNG0
	subk	2,a0
	add	a0,a3			;-2 to 1
	addk	16,a3
	ori	1000h,a3

	movi	40h,a1
	move	*a10(OBJ_XPOSINT),a0
	move	*a10(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#no_flip
	neg	a1
#no_flip
	add	a1,a0
	sll	16,a0

	movi	Y_SCALE_MULTIPLIER,a14
	move	*a10(OBJ_ZPOSINT),a1
	mpyu	a14,a1
	move	*a10(OBJ_YPOSINT),a14
	addi	52h,a14
	sll	16,a14
	sub	a14,a1

	movi	SPARK1,a2
	movi	DMAWNZ|M_3D|M_NOCOLL,a4
	movi	CLSDEAD,a5
	calla	BEGINOBJ

	movk	>f,a0
	calla	RNDRNG0
	subk	7,a0
	sll	14,a0
	move	a0,*a8(OZVEL),L

	movi	spark_l,a9

	movk	3,a11
	jruc	#strt

#lp	dsj	a10,#noani
#strt
	move	a11,a10
	move	*a9,a0,L
	jrz	#die			;noani
	addk	32,a9

	move	*a8(OCTRL),a1
	calla	obj_aniq
#noani
	SLEEPK	3
	move	*a8(OYVEL),a2,L
	addi	GRAV*2,a2
	move	a2,*a8(OYVEL),L
	jruc	#lp			;Going up?

#die
	clr	a0
	move	a0,*a8(OXVEL),L
	move	a0,*a8(OYVEL),L
	move	a0,*a8(OZVEL),L

	jauc	DELOBJDIE


spark_l
	.long	SPARK2
	.long	SPARK2
	.long	SPARK2
	.long	SPARK2
	.long	SPARK2
	.long	SPARK3
	.long	SPARK3
	.long	SPARK3
	.long	0

#*******************************
* Start sparks in AMODE
* A10=*wrestler proc

clobber_sparks

	movk	8,a11		;13
#lp	CREATE0	clb_spark
	CREATE0	clb_spark
	SLEEPK	1
	dsj	a11,#lp
	DIE

GRAV		equ	04000h	;9000h	;a000h	;6000h

#********************************
* Spark from hand buzzer (Process)
* A10=*wrestler proc

clb_spark

	movk	30,a0
	calla	RNDRNG0
	subk	15,a0
	sll	14,a0			;XVel
	move	a0,a6
	move	*a10(OBJ_XVEL),a0,L
	sra	1,a0
	add	a0,a6

	movk	>5,a0
	calla	RNDRNG0
	addk	2,a0
	sll	16,a0			;YVel
	neg	a0
	move	a0,a7

	move	*a10(OBJ_ZPOSINT),a3
	movk	3,a0
	calla	RNDRNG0
	subk	2,a0
	add	a0,a3			;-2 to 1
	addk	16,a3
	ori	1000h,a3

	movi	0h,a1
	move	*a10(OBJ_XPOSINT),a0
	move	*a10(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#no_flip
	neg	a1
#no_flip
	add	a1,a0
	sll	16,a0

	movi	Y_SCALE_MULTIPLIER,a14
	move	*a10(OBJ_ZPOSINT),a1
	mpyu	a14,a1
	move	*a10(OBJ_YPOSINT),a14
	addi	52h,a14
	sll	16,a14
	sub	a14,a1

	movi	SPARK1,a2
	movi	DMAWNZ|M_3D|M_NOCOLL,a4
	movi	CLSDEAD,a5
	calla	BEGINOBJ

	movk	>f,a0
	calla	RNDRNG0
	subk	7,a0
	sll	14,a0
	move	a0,*a8(OZVEL),L

	movi	spark_l,a9

	movk	3,a11
	jruc	#strt

#lp	dsj	a10,#noani
#strt
	move	a11,a10
	move	*a9,a0,L
	jrz	#die			;noani
	addk	32,a9

	move	*a8(OCTRL),a1
	calla	obj_aniq
#noani
	SLEEPK	3
	move	*a8(OYVEL),a2,L
	addi	GRAV*4,a2
	move	a2,*a8(OYVEL),L
	jruc	#lp			;Going up?

#die
	clr	a0
	move	a0,*a8(OXVEL),L
	move	a0,*a8(OYVEL),L
	move	a0,*a8(OZVEL),L

	jauc	DELOBJDIE

#*****************************************************************************
*
* ROLL OVER AND BREAK YER STINKIN' NECK

 SUBR	dnk_break_neck2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

;Maybe put this z float in other neck2_anim seqs.
;FIX!
	WL	ANI_CODE,ckzpos

	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,60000h
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	WL	15,D3FD3E+FR4
	WL	3,D3FD3E+FR5
	WL	3,D3FD3E+FR6
	WL	3,D3FD3E+FR7
	WL	3,D3FD3E+FR8
	.word	ANI_WAITHITGND
	WL	4,D3FD3E+FR9

;hit.  stay.
	WL	ANI_CODE,SMALL_BOUNCE
;Fix!!!???
;Based on flip, this offset is fucked up!
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
;	.word	ANI_OFFSET,-20,-3,0
	.word	ANI_ZEROVELS

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	20,D3RC3A+FR9
	.word	ANI_WAITROLL

	WL	ANI_CHANGEANIM,dnk_faceup_getup_anim
;	.word	ANI_END

 SUBR	dnk_break_neck3_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP

	WLW	ANI_SET_XVEL,-20000h,AM_HIT_REL
	WL	ANI_SET_YVEL,58000h
	WLW	ANI_SET_ZVEL,18000h,AM_ABS

	WL	ANI_CODE,ckzpos

	WL 	15,D4POGO+FR4
	.word	ANI_WAITHITGND
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_XFLIP
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim

	WL	3,D3FD3E+FR6
	WL	3,D3FD3E+FR7
	WL	3,D3FD3E+FR8
	.word	ANI_WAITHITGND
	WL	4,D3FD3E+FR9

;hit.  stay.
	WL	ANI_CODE,SMALL_BOUNCE
;Fix!!!???
;Based on flip, this offset is fucked up!
	.word	ANI_OFFSET,-20,-3,0
	.word	ANI_ZEROVELS

	.word	ANI_SETPLYRMODE,MODE_ONGROUND	;So we can stomp him!
	WL	10,D3RC3A+FR9
	.word	ANI_WAITROLL

	WL	ANI_CHANGEANIM,dnk_faceup_getup_anim
;	.word	ANI_END

 SUBR	dnk_break_neck_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_ZEROVELS

	WWWL	ANI_IFROPE,RC_FRONT,100,#fall_back

	;plenty o' room.  roll over
	WL	4,D3FD3E+FR4
	.word	ANI_OFFSET,-7,0,0
	WL	4,D3FD3E+FR5
	.word	ANI_OFFSET,-5,0,0
	WL	4,D3FD3E+FR6
	.word	ANI_OFFSET,-2,0,0
	WL	4,D3FD3E+FR7
	.word	ANI_OFFSET,-3,0,0
	WL	4,D3FD3E+FR8
	.word	ANI_OFFSET,-22,0,0
;	WL	4,D3FD3E+FR9
	.word	ANI_OFFSET,-25,0,0

	;impact
	WL	ANI_CODE,SMALL_BOUNCE
	WL	4,D3GS3X+FR8	;10	;Face down

	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,dnk_faceup_getup_anim
;	.word	ANI_END

#fall_back
	;too close to the ropes.  fall back
	WL	7,D3FD3E+FR3
	.word	ANI_OFFSET,-12,0,0
	WL	4,D3FD3E+FR2
	.word	ANI_OFFSET,-25,0,0
	WL	4,D3UC3A+FR9
	.word	ANI_OFFSET,-1,0,0
	WL	4,D3UC3A+FR10
	WL	4,D3UC3A+FR11
	.word	ANI_OFFSET,-3,0,0

	.word	ANI_XFLIP
	WL	4,D3SA3A+FR9
	.word	ANI_SETPLYRMODE,MODE_ONGROUND
	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,dnk_faceup_getup_anim
;	.word	ANI_END


#******************************************************************************

 SUBR	dnk_2_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h

	.word	ANI_STARTATTACK,AT_PUPPET,8

	WL	2,D1TT5Z+FR2	;2.5
	WL	2,D1TT5Z+FR3	;3.5

 SUBR	dnk_4_hair_pickup_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP	;uninterruptable
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.WORD	ANI_ADD_MOVE,MOVE_C_4,2,2
	.word	ANI_STARTATTACK,AT_PUPPET,8
	WL	3,D3PP3A+FR1

	LEAPATOPP 8,999,80,80,40000h,TGT_HEAD,46,6,-2
	WL	4,D3PP3A+FR2
	WL	4,D3PP3A+FR3
	.word	ANI_ZERO_XZVELS

;FIX!! on other guys!
;PUPPET2 MODE!
;If no getup time for other guy, do a miss!
	.word	ANI_ATTACK_ON, AMODE_PUPPET2,21,1,43,23 ;mode,x,y,w,h
	WL	4,D3PP3A+FR3
	.word	ANI_ATTACK_OFF

	WL	ANI_IFNOTSTATUS,#missed

;got him
	.word	ANI_CLR_BUTCOUNT
	WL	ANI_CODE,clear_opp_counts
	.word	ANI_ATTACHZ,0,0,-4		;x & y don't matter.
	WL	ANI_CODE,DO_NONO
	.word	ANI_SETOPPMODE,MODE_GHOST
	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_OVERLAP|MODE_KEEPATTACHED

	.word	ANI_SOUND,98h			;neck break (5-7 ticks late)
	WL	ANI_CODE,CALL_SETUP

	WWLLW	ANI_SUPERSLAVE2,3,D3PP3A+FR5,#puppet_tbl,0
	WWLLW	ANI_SUPERSLAVE2,3,D3PP3A+FR6,#puppet_tbl,1
	WWLLW	ANI_SUPERSLAVE2,3,D3PP3A+FR7,#puppet_tbl,2
	WWLLW	ANI_SUPERSLAVE2,3,D3PP3A+FR8,#puppet_tbl,3
	WWLLW	ANI_SUPERSLAVE2,3,D3PP3A+FR9,#puppet_tbl,4
	WWLLW	ANI_SUPERSLAVE2,3,D4GH3A+FR8,#puppet_tbl,5

	.word	ANI_SETPLYRMODE,MODE_HEADHOLD
	WL	ANI_SLAVEANIM,#headheld_tbl

	.word	ANI_SETWORD,USR_VAR2,0

	WL	1,D4GH3A+FR8
	.word	ANI_CLROPPMODE,MODE_GHOST

	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_END

#missed
	WL	ANI_CODE,CALL_MISSES
	WL	20,D3PP3A+FR3
	WL	4,D3PP3A+FR2
	WL	4,D3PP3A+FR1

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	.word	ANI_END


 SUBR	ck_getup

	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)

	move	*a13(WHOIHIT),a0,L

	move	*a0(GETUP_TIME),a0
	jrz	#misshim

	move	*a13(ANIMODE),a1
	ori	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)

#misshim
	rets

#headheld_tbl
	.long	hrt_3_head_held_anim
	.long	rzr_3_head_held_anim
	.long	und_3_head_held_anim
	.long	yok_3_head_held_anim
	.long	shn_3_head_held_anim
	.long	bam_3_head_held_anim
	.long	dnk_3_head_held_anim
	.long	0
	.long	lex_3_head_held_anim

#puppet_tbl
 .long #Bret
 .long #Razor
 .long #Taker
 .long #Yokozuna
 .long #Shawn
 .long #BamBam
 .long #Doink
 .long #Adam
 .long #Lex

#Bret
 LWWW H3GU4A+FR1,37,-31,0
 LWWW H3GU4A+FR2,49,-33,0
 LWWW H3GU4A+FR3,63,-42,0
 LWWW H3DU3A+FR3,58,-39,1
 LWWW H3DU3A+FR4,60,-29,1
 LWWW H3BF3A+FR1,53,-35,0
 .long 0
#Razor
 LWWW R3GU2A+FR3,41,-22,0
 LWWW R3GU4A+FR3,52,-27,0
 LWWW R3GU4A+FR4,54,-36,0
 LWWW R3GU4A+FR5,59,-42,0
 LWWW R3DU3B+FR2,53,-43,1
 LWWW R3BF3A+FR1,53,-37,0
 .long 0
#Taker
 LWWW U3DU3B+FR2,42,-23,1
 LWWW U3DU3B+FR5,53,-23,1
 LWWW U3DU3B+FR6,59,-29,1
 LWWW U3DU3B+FR8,49,-26,1
 LWWW U3DU3B+FR10,59,-21,1
 LWWW U4BF3Z+FR5,54,-16,0
 .long 0
#Yokozuna
 LWWW Y3GU2A+FR1,47,-17,0
 LWWW Y3GU2A+FR2,57,-18,0
 LWWW Y3GU2A+FR4,44,-25,0
 LWWW Y3GU2A+FR7,44,-37,0
 LWWW Y3GU2A+FR11,60,-30,0
 LWWW Y3BF3A+FR1,57,-25,0
 .long 0
#Shawn
 LWWW S3GU2A+FR1,44,-25,0
 LWWW S3GU4A+FR2,51,-25,0
 LWWW S3GU4A+FR4,58,-36,0
 LWWW S3GU4A+FR5,58,-35,0
 LWWW S3GU4A+FR6,59,-30,0
 LWWW S3BF3A+FR1,41,-36,0
 .long 0
#BamBam
 LWWW B3GU4A+FR3,49,-21,0
 LWWW B3GU4A+FR4,57,-28,0
 LWWW B3GU4A+FR5,64,-33,0
 LWWW B3GU4A+FR8,60,-25,0
 LWWW B3GU4A+FR9,60,-23,0
 LWWW B3BF3C+FR5,59,-29,0
 .long 0
#Doink
 LWWW D3GU4A+FR2,50,-28,0
 LWWW D3GU4A+FR3,56,-31,0
 LWWW D3GU4A+FR4,57,-43,0
 LWWW D3GU4A+FR5,52,-34,0
 LWWW D3GU4A+FR7,68,-36,0
 LWWW D3BF3A+FR2,55,-35,0
 .long 0
#Adam
 .long 0
#Lex
 LWWW L3GU4A+FR1,50,-26,0
 LWWW L3DU3A+FR4,42,-23,1
 LWWW L3DU3A+FR6,49,-31,1
 LWWW L3DU3A+FR7,55,-29,1
 LWWW L3DU3A+FR9,64,-29,1
 LWWW L3BF3B+FR5,57,-32,0
 .long 0

#*****************************************************************************
*
* THROWN FROM RING (shn_bslm, shn_frnk)

 SUBR	dnk_flyout_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETSPEED,100h
	.word	ANI_SET_IDIOT
	WWL	ANI_SETLONG,OBJ_GRAVITY,0f000h
	WL	ANI_CODE,DO_WAIL

	WL	8,D3OS3A+FR4
	WL	8,D3OS3A+FR5
#cont	WL	8,D3OS3A+FR6
	.word	ANI_OFFSET,0,45,0
	WL	1,D3FD3E+FR2
	.word	ANI_WAITHITGND
	WWL	ANI_SETLONG,OBJ_GRAVITY,GRAVITY
	WL	ANI_CODE,HIT_THE_MAT
	.word	ANI_SHAKEALL,2
	.word	ANI_SHAKER,60

	.word	ANI_DAMAGE,D_HIPTOSS

;	.word	ANI_SETWORD,DELAY_METER,0
;	.word	ANI_GETUP,500

	WL	ANI_CHANGEANIM,dnk_hitonground_xflip_anim


 SUBR	dnk_flyout2_anim

	.word	ANI_SETMODE,MODE_UNINT|MODE_NOAUTOFLIP|MODE_NOCONFINE
	.word	ANI_SETPLYRMODE,MODE_INAIR
	.word	ANI_SETSPEED,100h
	.word	ANI_SET_IDIOT
	WWL	ANI_SETLONG,OBJ_GRAVITY,0E000h
	WL	ANI_CODE,DO_WAIL
	WL	ANI_GOTO,#cont

#******************************************************************************

 SUBR	dnk_4_taunt_anim

	.word	ANI_SETMODE,MODE_UNINT
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_SETPLYRMODE,MODE_NORMAL

	.word	ANI_SETFACING		;ANI_XFLIP <- not primary anim
	.word	ANI_SET_WRESTLER_XFLIP

	WL	4,D4CO4A+FR1
	WL	4,D4CO4A+FR2
	WL	4,D4CO4A+FR3
	WL	4,D4CO4A+FR4
	WL	4,D4CO4A+FR5
	WL	4,D4CO4A+FR6

	WL	4,D4CO4A+FR5
	WL	4,D4CO4A+FR4
	WL	4,D4CO4A+FR3
	WL	4,D4CO4A+FR4
	WL	4,D4CO4A+FR5
	WL	4,D4CO4A+FR6

	WL	3,D4CO4A+FR5
	WL	3,D4CO4A+FR4
	WL	3,D4CO4A+FR3
	WL	3,D4CO4A+FR2
	WL	3,D4CO4A+FR1

;	WL	ANI_CODE,set_taunt_bit

	.word	ANI_FACEDOWN
	.word	ANI_SETMODE,MODE_NORMAL
	.word	ANI_SETPLYRMODE,MODE_NORMAL
	WL	ANI_CHANGEANIM,dnk_stand4_anim
;	.word	ANI_END


; SUBR	set_taunt_bit
;;Successful taunt achieved!
;
;	move	*a13(STATUS_FLAGS),a14
;	ori	M_DID_TAUNT,a14
;	move	a14,*a13(STATUS_FLAGS)
;	rets

#*****************************************************************************
*
* END OF BACK BROKEN SEQ.

 SUBR	dnk_backbroken_anim

	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
;	.word	ANI_DETACH

	.word	ANI_GRAVITY_OFF
	WL	5,D3BK3Z+FR7
	.word	ANI_GRAVITY_ON

	WL	ANI_SET_YVEL,070000h
	WLW	ANI_SET_ZVEL,20000h,AM_ABS

	WL	25,D3BK3Z+FR7

	WL	4,D3BK3Z+FR6
;	WL	4,D3UC3A+FR5

	.word	ANI_WAITHITGND
	.word	ANI_ZEROVELS
	.word	ANI_BOUNCE,2
	.word	ANI_XFLIP
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT
	WL	ANI_CODE,HIT_THE_MAT

	.word	ANI_DEBRIS,100,1,0,8,0		;%chance, tbl index, x,y,z off

	WL	2,D3SA3A+FR2
	WL	3,D3SA3A+FR3
	WL	6,D3SA3A+FR4
	WL	3,D3SA3A+FR5

	WL	3,D3SA3A+FR7
	WL	2,D3SA3A+FR8
	WL	3,D3SA3A+FR9

	.word	ANI_SETPLYRMODE,MODE_ONGROUND

;No stars around head here...

	.word	ANI_DETACH

	WL	5,D3SA3A+FR9

	.word	ANI_WAITROLL
	WL	ANI_CHANGEANIM,dnk_faceup_getup_anim
;	.word	ANI_END

;#*****************************************************************************
;*
;* CHAIR STUFF
;
; SUBR	dnk_pkup_chair_anim
;
;	.word	ANI_SETMODE,MODE_UNINT | MODE_NOAUTOFLIP
;	.word	ANI_ZEROVELS
;	.word	ANI_SETSPEED,100h
;
;#lp
;	WL	4,D4WA4A+FR1
;	WL	4,D4WA4A+FR2
;	WL	4,D4WA4A+FR3
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR1,42,-10,1 ;image, x,y,zoff
;	WL	4,D4WA4A+FR4
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR1,42,0,1 ;image, x,y,zoff
;	WL	4,D4WA4A+FR5
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR2,48,37,1 ;image, x,y,zoff
;	WL	4,D4WA4A+FR6
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR3,48,90,1 ;image, x,y,zoff
;	WL	4,D4WA4A+FR7
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR4,19,124,1 ;image, x,y,zoff
;	WL	4,D4WA4A+FR8
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR4,-5,141,1 ;image, x,y,zoff
;	WL	4,D4WA4A+FR10
;
;; .word ANI_SINGLESTEP
;
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR6,-31,131,1 ;image, x,y,zoff
;	WL	4,D3CS3Z+FR2
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR6,-38,123,1 ;image, x,y,zoff
;	WL	4,D3CS3Z+FR3
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR7,9,130,1 ;image, x,y,zoff
;	WL	4,D3CS3Z+FR4
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR8,67,100,1 ;image, x,y,zoff
;	WL	4,D3CS3Z+FR5
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR9,77,46,1 ;image, x,y,zoff
;	WL	4,D3CS3Z+FR6
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR9,83,66,1 ;image, x,y,zoff
;	WL	4,D3CS3Z+FR7
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR7,3,140,1 ;image, x,y,zoff
;	WL	4,D3CS3Z+FR8
;	WLWWW	ANI_ATTCHIMAGE2,CHAIR_SWING+FR6,-25,129,1 ;image, x,y,zoff
;	WL	4,D3CS3Z+FR9
;
;; .word ANI_SINGLESTEP
;	WLW	ANI_ATTCHIMAGE,0,0
;
;	WL	ANI_GOTO,#lp
;
; SUBR	CHAIR_SWING
;	.long	0		;0
;	.long	CHSWNG01	;1
;	.long	CHSWNG02	;2
;	.long	CHSWNG03	;3
;	.long	CHSWNG04	;4
;	.long	CHSWNG05	;5
;	.long	CHSWNG06	;6
;	.long	CHSWNG07	;7
;	.long	CHSWNG08	;8
;	.long	CHSWNG09	;9
;	.long	CHSWNFL		;10
;

******************************************************************************

	.end
