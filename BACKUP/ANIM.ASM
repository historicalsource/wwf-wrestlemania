**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		6/93
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"anim.asm"
	.title	"animation routines"
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
	.include	"ring.equ"
	.include	"sound.h"

	.include	"fontsimg.glo"
	.include	"bgndtbl.glo"
	.include	"miscimg.glo"

******************************************************************************
*
* external references

	.REF	p2rounds,p1rounds

	.ref	wres_get_but_val_cur,get_opp_process,clear_damage_log
	.ref	PCNT,slowmo,do_roll,match_over,triple_sound
	.ref	match_winner,process_ptrs,square_root,set_target_offsets
	.ref	calc_line_x,RNDPER,crowd_cheer,wrtable_sound,rope_command
	.ref	set_rope_z,SHAKER2,get_all_buttons_down,right_rproc
	.ref	left_rproc,adjust_health,create_dizzy_proc,get_mpart_offsets
	.ref	get_mpart_xsize,pal_find
	.ref	round_tickcount

	.ref	get_rope_x
	.ref	ADD_TO_COMBO_COUNT

******************************************************************************
*
* external definitions

#*****************************************************************************

OANIMODE	equ	0			;word
OANIBASE	equ	OANIMODE+10h		;long
OANIPC		equ	OANIBASE+20h		;long
OANICNT		equ	OANIPC+20h		;word
OCUR_FRAME	equ	OANICNT+10h		;long


 SUBR	animate_wrestler

	PUSH	a4,a10

	.ref	match_time
	move	@match_time,a0,L
	jrz	#x

;	callr	animate_wrestler1
;	callr	animate_wrestler2

	move	a13,a10
	addi	ANIMODE,a10		;primary animation
	callr	animate

	move	a13,a10
	addi	ANIMODE2,a10		;secondary animation
	callr	animate

#x
	PULL	a4,a10
	rets


 SUBR	animate_wrestler1

	PUSH	a4,a10

	move	a13,a10
	addi	ANIMODE,a10		;primary animation
	callr	animate

	PULL	a4,a10
	rets

 SUBR	animate_wrestler2

	PUSH	a4,a10

	move	a13,a10
	addi	ANIMODE2,a10		;secondary animation
	callr	animate

	PULL	a4,a10
	rets

********
animate	;a10 = * anim variables base

	move	*a10(OANIMODE),a0	;current animation ended???
	btst	MODE_END_BIT,a0
	jrnz	_exit

 .if 0
*** temp patch to step through images on player 1 !!!!

	move	*a13(PLYRNUM),a0
	jrnz	#skippit

	move	*a10(OANIBASE),a0,L
	move	*a10(OANIPC),a1,L
	cmp	a0,a1
	jreq	_next_command

	.ref	get_but_val_down
	move	*a13(PLYRNUM),a0
	calla	get_but_val_down
	move	a0,a0
	jrnz	_next_command
	rets
#skippit
 .endif

***


	move	*a10(OANICNT),a0	;cur tick count
	dec	a0
	move	a0,*a10(OANICNT)
	jrgt	_exit

_next_command
	move	*a10(OANIPC),a4,L
	move	*a4+,a0			;tick count or command
	jrn	#command
	jrz	_ani_zip		;no-op

	move	*a13(ANI_SPEED),a1
	mpyu	a0,a1
	srl	8,a1
	move	a1,*a10(OANICNT)	;# ticks to hold cur frame

;	move	a0,a1
;	sll	8,a1			;* 256
;	move	*a13(ANI_SPEED),a0	;divisor * 256
;	divu	a0,a1			;a1/a0
;	move	a1,*a10(OANICNT)	;# ticks to hold cur frame

	move	*a4+,a0,L		;* * multi image object
	move	*a0,a0,L		;* image
 .if DEBUG
 	jrnz	#ok
	LOCKUP
	jruc	#skp
#ok
 .endif
	move	a0,*a10(OCUR_FRAME),L
#skp
	move	a4,*a10(OANIPC),L

_exit
	rets


#command
	andi	0ffh,a0
	sll	5,a0			;x 32
	addi	#ani_commands,a0
	move	*a0,a0,L
	jump	a0

#ani_commands
	.long	_ani_zip		;0
	.long	_ani_repeat		;1
	.long	_ani_setmode		;2
	.long	_ani_zerovels		;3
	.long	_ani_setplyrmode	;4
	.long	_ani_set_yvel		;5
	.long	_ani_attack_on		;6
	.long	_ani_attack_off		;7
	.long	_ani_leapatopp		;8
	.long	_ani_attach		;9
	.long	_ani_detach		;10
	.long	_ani_waithitgnd		;11
	.long	_ani_xflip		;12
	.long	_ani_bounce		;13
	.long	_ani_attack_on_Z	;14
	.long	_ani_gravity_on		;15
	.long	_ani_gravity_off	;16
	.long	_ani_goto		;17
	.long	_ani_attachz		;18
	.long	_ani_slowmo		;19
	.long	_ani_waitrelease	;20
	.long	_ani_offset		;21
	.long	_ani_friction		;22
	.long	_ani_endmatch		;23
	.long	_ani_attachvel		;24
	.long	_ani_throw1		;25
	.long	_ani_sound		;26
	.long	_ani_setfacing		;27
	.long	_ani_pause		;28
	.long	_ani_ifstatus		;29
	.long	_ani_code		;30
	.long	_ani_shaker		;31
	.long	_ani_changeanim		;32
	.long	_ani_faceup		;33
	.long	_ani_facedown		;34
	.long	_ani_bouncerope		;35
	.long	_ani_shakeropes		;36
	.long	_ani_bendrope		;37
	.long	_ani_setspeed		;38
	.long	_ani_leapatpos		;39
	.long	_ani_zero_xzvels	;40
	.long	_ani_rope_z		;41
	.long	_ani_round_loop		;42
;MJT Start
	.long	_ani_zip		;43
;MJT End
	.long	_ani_set_xvel		;44
	.long	_ani_ifnotstatus	;45
	.long	_ani_slide_back		;46
	.long	_ani_clr_damage		;47
	.long	_ani_set_zvel		;48
	.long	_ani_master_throw	;49
	.long	_ani_face		;50
	.long	_ani_setword		;51
	.long	_ani_getup		;52
	.long	_ani_getup_wait		;53
	.long	_ani_clr_stars		;54
	.long	_ani_shakeall		;55
	.long	_ani_damage		;56
	.long	_ani_start_dizzy	;57
	.long	_ani_clr_status		;58
	.long	_ani_set_target		;59
	.long	_ani_max_x		;60
	.long	_ani_max_z		;61
	.long	_ani_max_y_vel		;62
	.long	_ani_superslave		;63
	.long	_ani_slaveanim		;64
	.long	_ani_rawsound		;65
	.long	_ani_damageopp		;66
	.long	_ani_rndper		;67
	.long	_ani_waithitopp		;68
	.long	_ani_attchimage		;69
	.long	_ani_ifoppmode		;99
	.long	_ani_ifbuttons		;71
	.long	_ani_ifnohitblock	;72
	.long	_ani_end		;73
	.long	_ani_ifrope		;74
	.long	_ani_ifnotrope		;75
	.long	_ani_opp_getup		;76
	.long	_ani_shakecorner	;77
	.long	_ani_singlestep		;78
	.long	_ani_superslave2	;79
	.long	_ani_setoppmode		;80
	.long	_ani_clroppmode		;81
	.long	_ani_oppoffset		;82
	.long	_ani_ifblocked		;83
	.long	_ani_waitroll		;84
	.long	_ani_setoppfacing	;85
	.long	_ani_ifopp		;86
	.long	_ani_snot		;87

	.long	_ani_if_butcount_ge	;88
	.long	_ani_if_butcount_lt	;89
	.long	_ani_if_rptcount	;90
	.long	_ani_ifnot_rptcount	;91

	.long	_ani_ringcheck		;92
	.long	_ani_debrisat		;93
	.long	_ani_debris		;94
	.long	_ani_set_wrestler_xflip ;95
	.long	_ani_slideatopp		;96

	.long	_ani_clr_butcount	;97
	.long	_ani_set_rptcount	;98
	.long	_ani_dec_rptcount	;99

	.long	_ani_shadowtrail	;100
	.long	_ani_createproc		;101
	.long	_ani_target		;102
	.long	_ani_hmbwait		;103
	.long	_ani_safe_time		;104
	.long	_ani_setopp_plyrmode	;105
	.long	_ani_xflip_opp		;106
	.long	_ani_setlong		;107
	.long	_ani_immobilize		;108
	.long	_ani_xflip_tbl		;109
	.long	_ani_setoppvels		;110
	.long	_ani_waithitgnd2	;111
	.LONG	_ani_set_opp_xvel	;112
	.long	_ani_set_attach		;113
	.long	_ani_inc_combo_count	;114
	.long	_ani_clear_combo_count	;115
	.long	_ani_add_move		;116
	.long	_ani_startattack	;117
	.long	_ani_changeanim_tbl	;118
	.long	_ani_if_rptcount_ge	;119
	.long	_ani_if_rptcount_lt	;120

#********
_ani_zip	;0
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_repeat	;1
	move	*a10(OANIBASE),a4,L
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_setmode	;2
	move	*a4+,a0			;mode bits
	move	a0,*a10(OANIMODE)
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_zerovels	;3
	clr	a0
	move	a0,*a13(OBJ_XVEL),L
	move	a0,*a13(OBJ_YVEL),L
	move	a0,*a13(OBJ_ZVEL),L
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_setplyrmode ;4

	;clear the climbin bit, just in case...
	clr	a14
	move	a14,*a13(CLIMBING_THRU)

	move	*a4+,a0
	move	*a13(PLYRMODE),a1		;this is a temp fudge!!!
	cmpi	MODE_DEAD,a1
	jreq	#noset

;If going into head hold mode, don't allow getup meter
;to come out for awhile.
	cmpi	MODE_HEADHOLD,a0
	jrnz	#skp
	move	*a13(DELAY_METER),a14
	cmpi	5*60,a14
	jrge	#skp
	movi	6*60,a14
	move	a14,*a13(DELAY_METER)
#skp

	move	a0,*a13(PLYRMODE)
#noset
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_set_yvel	;5
	move	*a4+,a0,L
	move	a0,*a13(OBJ_YVEL),L
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_attack_on	;6

;I'm not sure we want to zero attach_proc just for starting an attack!
;Watch this....
	clr	a0				;start out not attached
;	move	a0,*a13(ATTACH_PROC),L		;to anything

	move	a0,*a13(HITBLOCKER)

	move	*a13(ANIMODE),a0
	ori	MODE_CHECKHIT,a0
	move	a0,*a13(ANIMODE)

	move	*a4+,a0
	move	a0,*a13(ATTACK_MODE)
	move	*a4+,a0
	move	a0,*a13(OBJ_ATTXOFF)
	move	*a4+,a0
	move	a0,*a13(OBJ_ATTYOFF)
	move	*a4+,a0
	move	a0,*a13(OBJ_ATTWIDTH)
	move	*a4+,a0
	move	a0,*a13(OBJ_ATTHEIGHT)

;;;	clr	a0
;;;	move	a0,*a13(OBJ_ATTZOFF)
;;;	move	a0,*a13(OBJ_ATTDEPTH)

	movi	-30,a0				;default z width (10)
	move	a0,*a13(OBJ_ATTZOFF)
	movi	30*2,a0				;10*2
	move	a0,*a13(OBJ_ATTDEPTH)

	move	a4,*a10(OANIPC),L

	jruc	_next_command

#********
_ani_attack_off	;7

	move	*a13(ANIMODE),a0
	andni	MODE_CHECKHIT,a0
	move	a0,*a13(ANIMODE)

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_leapatopp	;8

;	# ticks to reach dest
;	max total distance (X and Z)
;	max X distance
;	max Z distance
;	max Y vel
;	target area of opponent
;	x,y,z offset of attack box

	STRUCT	0
	WORD	#TICKS
	WORD	#MAX_TOTAL_DIST
	WORD	#MAX_X_DIST
	WORD	#MAX_Z_DIST
	LONG	#MAX_Y_VEL
	WORD	#TRGT
	WORD	#ATT_X_OFF
	WORD	#ATT_Y_OFF
	WORD	#ATT_Z_OFF
	LABEL	#SIZE


	.bss	oppx,32
	.bss	oppz,32
	.bss	oppy,32


	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	move	*a13(CLOSEST_NUM),a11
	X32	a11
	addi	process_ptrs,a11
	move	*a11,a11,L

	move	*a11(OBJ_XVEL),a5,L

	move	*a11(PLYRMODE),a14
	cmpi	MODE_RUNNING,a14
	jrne	#outring

	move	a0,a0
	jrnz	#outring

;if opponent is inside the ring, running and near the ropes
;then target where he is now (don't add in xvel)

	move	*a11(OBJ_XPOSINT),a1

	move	a5,a5		;xvel
	jrp	#run_right
;run_left
	cmpi	RING_X_CENTER,a1
	jrgt	#outring
	jruc	#cnt

#run_right
	cmpi	RING_X_CENTER,a1
	jrlt	#outring
#cnt

	PUSH	a13
	move	a11,a13
	calla	get_rope_x
	PULL	a13
	move	*a11(OBJ_XPOSINT),a1
	sub	a1,a0
	abs	a0
	cmpi	70,a0
	jrgt	#outring

	clr	a5		;clr xvel
#outring

	move	*a11(OBJ_ZVEL),a6,L
	move	*a11(OBJ_YVEL),a7,L
	move	*a11(GROUND_Y),a8
	sll	16,a8
	addi	[256,0],a8

	move	*a11(OBJ_XPOS),a1,L
	move	*a11(OBJ_ZPOS),a2,L
	move	*a11(OBJ_YPOS),a3,L
	addi	[256,0],a3


	move	*a4(#TICKS),a0

	move	*a13(OBJ_GRAVITY),a14,L
#lp0
	add	a5,a1			;x + xvel
	add	a6,a2			;z + zvel

	move	a7,a7
	jrz	#ok

	add	a7,a3			;y + yvel
	sub	a14,a7		;yvel - gravity
	cmp	a3,a8		;hit ground?
	jrgt	#ok
	move	a8,a3
	jruc	#dn
#ok
	dsj	a0,#lp0
#dn
	subi	[256,0],a3

	move	a1,@oppx,L
	move	a2,@oppz,L
	move	a3,@oppy,L


	move	*a4(#TRGT),a0
	jrn	#user
	calla	set_target_offsets
#user

	move	*a13(TGT_XOFF),a0	;target x offset
	sll	16,a0
	move	*a11(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#right1
	neg	a0
#right1
;;;	move	*a11(OBJ_XPOS),a1,L
	move	@oppx,a1,L
	add	a0,a1			;def target x

	move	*a4(#ATT_X_OFF),a0
	sll	16,a0
	move	*a13(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#right0
	neg	a0
#right0
	move	*a13(OBJ_XPOS),a2,L
	add	a0,a2			;att x

	sub	a2,a1			;def x - att x
	move	a1,a14
	abs	a14

	move	*a4(#MAX_X_DIST),a0
	jrn	#xok
	sll	16,a0
	cmp	a14,a0
	jrge	#xok

	move	a1,a1
	jrp	#no_negx
	neg	a0
#no_negx
	move	a0,a1
#xok
	move	a1,a5			;delta x
	move	*a4(#TICKS),a0
	divs	a0,a1			;a1 / a0
	move	a1,*a13(OBJ_XVEL),L



	move	*a13(TGT_ZOFF),a0	;target z offset
	sll	16,a0
;;;	move	*a11(OBJ_ZPOS),a1,L
	move	@oppz,a1,L
	add	a0,a1			;def target z

	move	*a13(OBJ_ZPOS),a2,L
	move	*a4(#ATT_Z_OFF),a0
	sll	16,a0
	add	a0,a2			;att z

	sub	a2,a1			;def z - att z
	move	a1,a14
	abs	a14

	move	*a4(#MAX_Z_DIST),a0
	jrn	#zok
	sll	16,a0
	cmp	a14,a0
	jrge	#zok

	move	a1,a1
	jrp	#no_negz
	neg	a0
#no_negz
	move	a0,a1
#zok
	move	a1,a6			;delta z
	move	*a4(#TICKS),a0
	divs	a0,a1			;a1 / a0
	move	a1,*a13(OBJ_ZVEL),L


	move	*a4(#MAX_TOTAL_DIST),a9
	jrn	#maxok

	abs	a5
	srl	16,a5
	move	a5,a1
	mpyu	a5,a1			;deltax^2
	move	a1,a5

	abs	a6
	srl	16,a6
	move	a6,a1
	mpyu	a6,a1			;deltaz^2
	move	a1,a0

	add	a5,a0
	calla	square_root

	cmp	a0,a9			;a9-a0 (will we exceed max dist?)
	jrgt	#maxok

	sll	8,a9			;x 256 (8 bits fractional)
	divu	a0,a9			;a9/a0

	move	a9,a1
	move	*a13(OBJ_XVEL),a0,L
	mpys	a0,a1			;scale down xvel
	sra	8,a1			;shift off fractional
	move	a1,*a13(OBJ_XVEL),L

	move	a9,a1
	move	*a13(OBJ_ZVEL),a0,L
	mpys	a0,a1			;scale down yvel
	sra	8,a1			;shift off fractional
	move	a1,*a13(OBJ_ZVEL),L
#maxok




;to calculate YVEL taking into account gravity:
;use y-y0 = v0*t + 0.5*a*t^2


	move	*a4(#TICKS),a8
	move	a8,a1
	mpyu	a8,a1			;t^2
	move	*a13(OBJ_GRAVITY),a0,L
	mpyu	a0,a1			;a*t^2
	srl	1,a1			;1/2*a*t^2

;;;	move	*a11(OBJ_YPOS),a0,L	;opp y
	move	@oppy,a0,L

	move	*a13(TGT_YOFF),a14	;target y offset
	sll	16,a14
	add	a14,a0

	move	*a13(OBJ_YPOS),a2,L	;y0
	move	*a4(#ATT_Y_OFF),a14
	sll	16,a14

	add	a14,a2

	sub	a2,a0			;a0 = a0-a2 (y - y0)
	add	a0,a1
	jrnn	#yvel_okay

;	LOCKUP

	clr	a1
	jruc	#yok
#yvel_okay
	divu	a8,a1			;a1 = a1/a8 ( ((y-y0)+(1/2*a*t^2)) / t )

	move	*a4(#MAX_Y_VEL),a0,L
	cmp	a1,a0
	jrge	#yok
	move	a0,a1
#yok
	move	a1,*a13(OBJ_YVEL),L


	;make sure both have the same INRING value
	move	*a11(INRING),a0
	move	*a13(INRING),a1
	cmp	a0,a1
	jreq	#done

	;uh-oh.  our INRING's don't match.  Unless we're on the
	; turnbuckle, zero the X and Z velocities and set the Y
	; velocity to 50000h or something
	move	*a13(PLYRMODE),a14,W
	cmpi	MODE_ONTURNBKL,a14
	jreq	#done

	;no good.  leap in place
	clr	a14
	move	a14,*a13(OBJ_XVEL),L
	move	a14,*a13(OBJ_ZVEL),L
	movi	[5,0],a14
	move	a14,*a13(OBJ_YVEL),L

#done
	jruc	_next_command


#********
_ani_attach	;9

	move	*a4+,a0			;xoff
	move	a0,*a13(ATTACH_XOFF)
	move	*a4+,a0
	move	a0,*a13(ATTACH_YOFF)

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_detach	;10

	move	*a13(ATTACH_PROC),a1,L
	jrz	#done
	clr	a0
	move	a0,*a13(ATTACH_PROC),L		;not attached to anything

	move	*a1(ATTACH_PROC),a2,L
	cmp	a2,a13
	jrne	#done

	move	a0,*a1(ATTACH_PROC),L		;not attached to anything
#done
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_waithitgnd	;11

	move	*a13(OBJ_YVEL),a0,L	;must have down velocity
	jrp	#no_gnd

	;if we're the master and the attach is valid, check and see if
	; our puppet has hit the ground.
	move	*a13(ANIMODE),a14
	btst	MODE_KEEPATTACHED_BIT,a14
	jrz	#skip_pcheck

	move	*a13(ATTACH_PROC),a0,L
	jrz	#skip_pcheck		;we're attached?
	move	*a0(ATTACH_PROC),a14,L
	jrz	#skip_pcheck		;they're attached?
	cmp	a13,a14
	jrne	#skip_pcheck		;to each other?

	;ah, but if the opponent's MODE_GHOST bit is set, ignore him
	move	*a0(ANIMODE),a14
	btst	MODE_GHOST_BIT,a14
	jrnz	#skip_pcheck

	move	*a0(OBJ_YPOSINT),a1,W
	move	*a0(GROUND_Y),a2,W
	sub	a1,a2

	jrnn	#hit_gnd

#skip_pcheck

	move	*a13(OBJ_YPOSINT),a0
	move	*a13(GROUND_Y),a1
	cmp	a1,a0			;a0-a1
	jrgt	#no_gnd

#hit_gnd
	.REF	SMALL_BOUNCE
	CALLA	SMALL_BOUNCE
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#no_gnd
	movk	1,a0
	move	a0,*a10(OANICNT)	;# ticks to hold cur frame
	rets


#********
_ani_xflip	;12

	move	*a13(OBJ_CONTROL),a0
	xori	M_FLIPH,a0
	move	a0,*a13(OBJ_CONTROL)

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_bounce	;13

	move	*a4+,a0			;Bounce value
	sll	16,a0
	move	a0,*a13(OBJ_YVEL),L

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_attack_on_Z ;14

;I'm not sure we want to zero attach_proc just for starting an attack!
;Watch this....
	clr	a0				;start out not attached
;	move	a0,*a13(ATTACH_PROC),L		;to anything

	move	a0,*a13(HITBLOCKER)
	move	a0,*a13(ATTACH_ZOFF)

	move	*a13(ANIMODE),a0
	ori	MODE_CHECKHIT,a0
	move	a0,*a13(ANIMODE)

	move	*a4+,a0
	move	a0,*a13(ATTACK_MODE)
	move	*a4+,a0
	move	a0,*a13(OBJ_ATTXOFF)
	move	*a4+,a0
	move	a0,*a13(OBJ_ATTYOFF)
	move	*a4+,a0
	move	a0,*a13(OBJ_ATTZOFF)
	move	*a4+,a0
	move	a0,*a13(OBJ_ATTWIDTH)
	move	*a4+,a0
	move	a0,*a13(OBJ_ATTHEIGHT)
	move	*a4+,a0
	move	a0,*a13(OBJ_ATTDEPTH)

	move	a4,*a10(OANIPC),L

	jruc	_next_command

#********
_ani_gravity_on	;15

	move	*a13(ANIMODE),a0
	andni	MODE_NOGRAVITY,a0
	move	a0,*a13(ANIMODE)

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_gravity_off ;16

	move	*a13(ANIMODE),a0
	ori	MODE_NOGRAVITY,a0
	move	a0,*a13(ANIMODE)

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_goto	;17

	move	*a4+,a4,L
	move	a4,*a10(OANIPC),L

	jruc	_next_command

#********
_ani_attachz	;18

	move	*a4+,a0			;xoff
	move	a0,*a13(ATTACH_XOFF)
	move	*a4+,a0
	move	a0,*a13(ATTACH_YOFF)
	move	*a4+,a0
	move	a0,*a13(ATTACH_ZOFF)

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_slowmo	;19

	move	*a4+,a0			;frame delay
	move	a0,@slowmo

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_waitrelease ;20

	move	a13,a0
	calla	wres_get_but_val_cur

	move	*a4+,a1			;button bit
	btst	a1,a0			;still down?
	jrz	#button_up

	movk	1,a0
	move	a0,*a10(OANICNT)	;# ticks to hold cur frame
	rets

#button_up
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_offset	;21

	move	*a4+,a1			;x offset
	move	*a13(FACING_DIR),a0
	btst	MOVE_RIGHT_BIT,a0
	jrnz	#right
	neg	a1
#right
	move	*a13(OBJ_XPOSINT),a0
	add	a1,a0
	move	a0,*a13(OBJ_XPOSINT)

	move	*a4+,a1			;y offset
	move	*a13(OBJ_YPOSINT),a0
	add	a1,a0
	move	a0,*a13(OBJ_YPOSINT)

	move	*a4+,a1			;z offset
	move	*a13(OBJ_ZPOSINT),a0
	add	a1,a0
	move	a0,*a13(OBJ_ZPOSINT)

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_friction	;22

	move	*a4+,a0			;friction value
	move	a0,*a13(OBJ_FRICTION)

	move	*a13(ANIMODE),a0
	ori	MODE_FRICTION,a0
	move	a0,*a13(ANIMODE)

	move	a4,*a10(OANIPC),L
	jruc	_next_command


#********
_ani_endmatch	;23

	movk	1,a0
	move	a0,@match_over

	move	*a13(PLYRNUM),a1
	movk	1,a0
	sll	a1,a0			;set bit for player who won
	move	a0,@match_winner

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_attachvel	;24

	STRUCT	0
	LONG	#XVEL
	LONG	#YVEL
	LONG	#ZVEL
	LABEL	#SIZE

	;x velocity is always relative to attacker FACING_DIR

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	move	*a13(ATTACH_PROC),a2,L		;proc attached to
	jrz	#not_attached
	move	*a2(ATTACH_PROC),a0,L
	jrz	#not_attached

	move	*a4(#YVEL),a0,L
	move	a0,*a2(OBJ_YVEL),L
	move	*a4(#ZVEL),a0,L
	move	a0,*a2(OBJ_ZVEL),L

	move	*a4(#XVEL),a0,L
	move	*a13(FACING_DIR),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#xok
	neg	a0
#xok
	move	a0,*a2(OBJ_XVEL),L

#not_attached
	jruc	_next_command

#********
_ani_throw1	;25

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_sound	;26

	move	*a4+,a0
	cmpi	run_snd,a0
	jrne	#not_run

	;if there's been another foot noise from this guy within the last
	; 12 ticks, give it a miss.
	move	@PCNT,a14
	zext	a14,W
	move	*a13(FOOT_PCNT),a1
	sub	a1,a14
	abs	a14
	cmpi	12,a14
	jrlt	#done
	move	@PCNT,a1
	move	a1,*a13(FOOT_PCNT)
	calla	triple_sound
	jruc	#done

#not_run
	move	a0,a0
	jrn	#table_lookup
	calla	triple_sound
	jruc	#done

#table_lookup
	calla	wrtable_sound

#done
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_setfacing	;27

	move	*a13(NEW_FACING_DIR),a0
	move	a0,*a13(FACING_DIR)

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_pause	;28

	;hold current frame for a few ticks
	move	*a4+,a14
	move	a4,*a10(OANIPC),L
	move	a14,*a10(OANICNT)
	rets


#********
_ani_ifstatus	;29

	move	*a4+,a0,L		;this is a conditional goto
	move	*a13(ANIMODE),a1	;if MODE_STATUS set then
	btst	MODE_STATUS_BIT,a1	;branch is taken
	jrz	#skip

	move	a0,a4			;new ani pc
#skip
	move	a4,*a10(OANIPC),L
	jruc	_next_command


#********
_ani_code	;30

	move	*a4+,a0,L		;code to execute
	move	a4,*a10(OANIPC),L
	PUSH	a10
	call	a0
	PULL	a10
	jruc	_next_command

#********
_ani_shaker	;31

	push	a10

	move	*a4+,a10,W		;shaker mode value
	calla	SHAKER2

	pull	a10

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_changeanim ;32

	move	*a4+,a4,L
	move	a4,*a10(OANIPC),L
	move	a4,*a10(OANIBASE),L

	jruc	_next_command
	

#********
_ani_faceup	;33

	movk	MOVE_UP_RIGHT,a1
	move	*a13(OBJ_CONTROL),a0
	btst	B_FLIPH,a0
	jrz	#right
	movk	MOVE_UP_LEFT,a1
#right	move	a1,*a13(FACING_DIR)

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_facedown	;34

	movk	MOVE_DOWN_RIGHT,a1
	move	*a13(OBJ_CONTROL),a0
	btst	B_FLIPH,a0
	jrz	#right
	movk	MOVE_DOWN_LEFT,a1
#right	move	a1,*a13(FACING_DIR)

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_bouncerope	;35

	movi	ROPE_LEFT,a0
	move	*a13(OBJ_XPOSINT),a14
	cmpi	RING_X_CENTER,a14
	jrle	#dir_set
	movi	ROPE_RIGHT,a0
#dir_set
	movi	ROPE_SIDES,a1
	move	*a13(OBJ_ZPOS),a3,L
	move	*a4+,a2,W
	move	a4,*a10(OANIPC),L
	jrnn	#no_release
	movi	ROPE_SIDESR,a1
#no_release
	calla	rope_command
	jruc	_next_command

#********
_ani_shakeropes	;36

	movi	ROPE_BOUNCEUD,a1
	move	*a4+,a2,W
	move	a4,*a10(OANIPC),L

	;force a2 into range, just to be safe...
	andi	03h,a2

	movi	ROPE_BACK,a0
	calla	rope_command

	movi	ROPE_LEFT,a0
	move	*a13(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrnz	#cont

	movi	ROPE_RIGHT,a0
#cont
	calla	rope_command

	jruc	_next_command

#********
_ani_bendrope	;37

	movi	ROPE_LEFT,a0
	move	*a13(OBJ_XPOSINT),a14
	cmpi	RING_X_CENTER,a14
	jrle	#dir_set
	movi	ROPE_RIGHT,a0
#dir_set
	movi	ROPE_DOWNS,a1
	move	*a13(OBJ_ZPOS),a3,L
	move	*a4+,a2,W
	move	a4,*a10(OANIPC),L
	jrnn	#no_release
	movi	ROPE_DOWNSR,a1
#no_release
	calla	rope_command
	jruc	_next_command

#********
_ani_setspeed	;38

	move	*a4+,a0
	move	a0,*a13(ANI_SPEED)

	move	a4,*a10(OANIPC),L
	jruc	_next_command


#********
_ani_leapatpos	;39

;WORD	- #ticks to reach destination
;WORD	- max distance to travel
;WORD	- x,y,z offset of attack box (eg. attacker's fist)

;NB	- user must set TGT_XOFF,YOFF & ZOFF <-- these are the actual target


	move	*a4+,a8			;# ticks
	move	*a4+,a9			;max distance to travel

#user
	move	*a13(TGT_XOFF),a1	;target x
	sll	16,a1

	move	*a4+,a0			;attack x offset
	sll	16,a0
	move	*a13(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#right0
	neg	a0
#right0
	move	*a13(OBJ_XPOS),a2,L
	add	a0,a2			;att x

	sub	a2,a1			;def x - att x
	move	a1,a5			;delta x
	move	a8,a0			;ticks
	divs	a0,a1			;a1 / a0
	move	a1,*a13(OBJ_XVEL),L


;to calculate YVEL taking into account gravity:
;use y-y0 = v0*t + 0.5*a*t^2

	move	a8,a1
	mpyu	a8,a1			;t^2
	move	*a13(OBJ_GRAVITY),a0,L
	mpyu	a0,a1			;a*t^2
	srl	1,a1			;1/2*a*t^2

	move	*a13(TGT_YOFF),a0	;target y
	sll	16,a0

	move	*a4+,a14		;attack y offset
	sll	16,a14
	move	*a13(OBJ_YPOS),a2,L	;y0
	sub	a14,a2

	sub	a2,a0			;a0 = a0-a2 (y - y0)
	add	a0,a1
	divu	a8,a1			;a1 = a1/a8 ( ((y-y0)+(1/2*a*t^2)) / t )

	cmpi	>0f0000,a1
	jrlt	#yok
	movi	>0f0000,a1
#yok	move	a1,*a13(OBJ_YVEL),L


	move	*a13(TGT_ZOFF),a1	;target z
	sll	16,a1

	move	*a4+,a0			;attack z offset
	sll	16,a0
	move	*a13(OBJ_ZPOS),a2,L
	add	a0,a2			;att z

	sub	a2,a1			;def z - att z
	move	a1,a6			;delta z
	move	a8,a0			;ticks
	divs	a0,a1			;a1 / a0
	move	a1,*a13(OBJ_ZVEL),L


	abs	a5
	srl	16,a5
	move	a5,a1
	mpyu	a5,a1			;deltax^2
	move	a1,a5

	abs	a6
	srl	16,a6
	move	a6,a1
	mpyu	a6,a1			;deltaz^2
	move	a1,a0

	add	a5,a0
	calla	square_root

	cmp	a0,a9			;a9-a0 (will we exceed max dist?)
	jrgt	#ok

	sll	8,a9			;x 256 (8 bits fractional)
	divu	a0,a9			;a9/a0

	move	a9,a1
	move	*a13(OBJ_XVEL),a0,L
	mpys	a0,a1			;scale down xvel
	sra	8,a1			;shift off fractional
	move	a1,*a13(OBJ_XVEL),L

	move	a9,a1
	move	*a13(OBJ_ZVEL),a0,L
	mpys	a0,a1			;scale down yvel
	sra	8,a1			;shift off fractional
	move	a1,*a13(OBJ_ZVEL),L

#ok
	move	a4,*a10(OANIPC),L
	jruc	_next_command


#********
_ani_zero_xzvels	;40

	clr	a0
	move	a0,*a13(OBJ_XVEL),L
	move	a0,*a13(OBJ_ZVEL),L
	move	a4,*a10(OANIPC),L
	jruc	_next_command


#********
_ani_rope_z		;41
	;.word	ANI_ROPE_Z,R_TOP,RZ_HIGH

	;which rope has he hit?
	move	@right_rproc,a0,L
	move	*a13(OBJ_XPOS),a14,L
	cmpi	RING_X_CENTER<<16,a14
	jrgt	#right

	move	@left_rproc,a0,L
#right
	move	*a4+,a1,W		;rope index
	move	*a4+,a2,W		;action
	calla	set_rope_z
	move	a4,*a10(OANIPC),L
	jruc	_next_command


#********
_ani_round_loop		;42

	move	@p1rounds,a0
	cmpi	2,a0
	jrz	#at_end
	move	@p2rounds,a0
	cmpi	2,a0
	jreq	#at_end

	movk	1,a0
	move	a0,*a10(OANICNT)
	rets

#at_end
	move	a4,*a10(OANIPC),L
	jruc	_next_command


#********
;MJT Start
;_ani_set_opp_getup	;43
;
;;args:	.word (GETUP_TIME)
;
;	move	*a4+,a0
;
;	move	*a13(WHOIHIT),a14,L
;	move	a0,*a14(GETUP_TIME)
;
;	move	a4,*a10(OANIPC),L
;	jruc	_next_command
;
;MJT End


#********
_ani_set_xvel		;44

;args:	.long (XVEL) .word (MODE)	;if MODE=0  vel is absolute
					;if MODE=1  vel is facing relative
					;if MODE=2  vel is hit relative
					;if MODE=3  vel is new_face relative
	move	*a4+,a0,L
	move	*a4+,a1
	jrz	#abs
	dec	a1
	jrz	#face
	dec	a1
	jrz	#hit

;new_facing relative
	move	*a13(NEW_FACING_DIR),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#abs			;right
	neg	a0			;left
	jruc	#abs

#hit
;hit relative
	move	*a13(PLYR_HIT_SIDE),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#abs			;hit from right

	neg	a0			;hit from left
	jruc	#abs
#face
	move	*a13(FACING_DIR),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#abs			;right
	neg	a0			;left
#abs
	move	a0,*a13(OBJ_XVEL),L

	move	a4,*a10(OANIPC),L
	jruc	_next_command


#********
_ani_ifnotstatus	;45

	move	*a4+,a0,L		;this is a conditional goto
	move	*a13(ANIMODE),a1	;if MODE_STATUS clear then
	btst	MODE_STATUS_BIT,a1	;branch is taken
	jrnz	#skip

	move	a0,a4			;new ani pc
#skip
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_slide_back

	move	*a4+,a8			;range
	move	*a4+,a9,L		;x-vel
	move	*a4+,a7,L		;new ani PC if no slide
	move	a4,*a10(OANIPC),L

	move	*a13(ANIMODE),a14	;was there a collision?
	btst	MODE_STATUS_BIT,a14
	jrz	#no_slide


	move	*a13(WHOIHIT),a6,L

	move	*a6(PLYRMODE),a5
	cmpi	MODE_BLOCK,a5
	jrz	#no_slide

	move	*a6(OBJ_XPOSINT),a5
	move	*a13(OBJ_XPOSINT),a0

	cmp	a5,a0			;a0-a5
	jrgt	#hit_from_right

;hit_from_left
	move	*a13(INRING),a0
	jrnz	#outside1

	PUSH	a6,a13
	move	a6,a13
	movi	vln_right_rope,a6
	calla	calc_line_x
	PULL	a6,a13
	move	*a6(OBJ_XPOSINT),a1
	sub	a1,a0
	abs	a0
	cmp	a8,a0
	jrgt	#no_slide
	jruc	#slide
#outside1
	jruc	#no_slide




#hit_from_right
	move	*a13(INRING),a0
	jrnz	#outside2

	PUSH	a6,a13
	move	a6,a13
	movi	vln_left_rope,a6
	calla	calc_line_x
	PULL	a6,a13
	move	*a6(OBJ_XPOSINT),a1
	sub	a1,a0
	abs	a0
	cmp	a8,a0
	jrgt	#no_slide

	neg	a9
	jruc	#slide
#outside2
	jruc	#no_slide


#slide
	move	a9,*a13(OBJ_XVEL),L


	movi	3000h,a0
	move	a0,*a13(OBJ_FRICTION)

	move	*a13(ANIMODE),a0
	ori	MODE_FRICTION,a0
	move	a0,*a13(ANIMODE)
	jruc	_next_command

#no_slide
	move	a7,*a10(OANIPC),L
	jruc	_next_command


#********
_ani_clr_damage	;47

	move	a4,*a10(OANIPC),L
	calla	clear_damage_log
	jruc	_next_command

#********
_ani_set_zvel		;48

;args:	.long (ZVEL) .word (MODE)	;if MODE=0  vel is absolute
					;if MODE=1  vel is facing relative
					;if MODE=2  vel is hit relative
	move	*a4+,a0,L
	move	*a4+,a1
	jrz	#abs
	dec	a1
	jrz	#face
;hit relative
	move	*a13(PLYR_HIT_SIDE),a14
	btst	MOVE_UP_BIT,a14
	jrnz	#abs			;hit from above

	neg	a0			;hit from below
	jruc	#abs
#face
	move	*a13(FACING_DIR),a14
	btst	MOVE_DOWN_BIT,a14
	jrnz	#abs			;down
	neg	a0			;up
#abs
	move	a0,*a13(OBJ_ZVEL),L

	move	a4,*a10(OANIPC),L
	jruc	_next_command


#********
_ani_master_throw	;49


	move	*a4+,a5,L		;x vel
	move	*a4+,a6,L		;z vel
	move	*a4+,a7,L		;y vel
	move	*a4+,a8,L		;ani seq (for slave)
	move	a4,*a10(OANIPC),L

	move	*a13(ATTACH_PROC),a2,L		;proc attached to
	jrz	#not_attached
	move	*a2(ATTACH_PROC),a0,L
	jrz	#not_attached

	clr	a0
	move	a0,*a13(ATTACH_PROC),L		;not attached to anything
	move	a0,*a2(ATTACH_PROC),L		;not attached to anything

	move	*a2(PLYR_HIT_SIDE),a0
	btst	MOVE_RIGHT_BIT,a0
	jrnz	#no_neg				;hit from right
	neg	a5
#no_neg
	move	a5,*a2(OBJ_XVEL),L
	move	a6,*a2(OBJ_ZVEL),L
	move	a7,*a2(OBJ_YVEL),L

	move	a8,a0				;ani seq
	callr	change_anim_anim		;a2 = * process

	jruc	_next_command


	move	*a2(WRESTLERNUM),a0
	X32	a0
;;;	addi	#heldthrown_table,a0
	move	*a0,a0,L
	callr	change_anim_anim		;a2 = * process

	movi	MODE_INAIR,a0
	move	a0,*a2(PLYRMODE)

	movi	TSEC*4,a0		;!!!! this must be passed
	move	a0,*a2(GETUP_TIME)

#not_attached
	jruc	_next_command



#********
_ani_face	;50

	move	*a4+,a0
	move	a4,*a10(OANIPC),L

	move	*a13(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#no_flip
	xori	MOVE_LEFT|MOVE_RIGHT,a0
#no_flip
	move	a0,*a13(FACING_DIR)

	jruc	_next_command


#********
_ani_setword	;51

;sets a word in the procs pdata area
;	.word	ANI_SETWORD,OFFSET,VAL

	move	*a4+,a0		;OFFSET
	add	a13,a0
	move	*a4+,a1		;VAL
	move	a1,*a0
	move	a4,*a10(OANIPC),L

	jruc	_next_command

#********
_ani_getup	;52

;args:	.word (GETUP_TIME)

	move	*a4+,a0

	move	*a13(PLYR_DIZZY),a14
	jrnz	#skip

	move	a0,*a13(GETUP_TIME)
#skip
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_getup_wait	;53

	move	*a13(GETUP_TIME),a0
	jrnz	#no_done

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#no_done
	movk	1,a0
	move	a0,*a10(OANICNT)	;# ticks to hold cur frame
	rets

#********
_ani_clr_stars	;54

	clr	a0
	move	a0,*a13(STARS_FLAG)
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_shakeall	;55

	movi	ROPE_BOUNCEUD,a1
	move	*a4+,a2,W
	move	a4,*a10(OANIPC),L

	;force a2 into range, just to be safe...
	andi	03h,a2

	move	@NUM_OPPS,A0
	CMPI	2,A0
	JRGE	_next_command

	movi	ROPE_BACK,a0
	calla	rope_command
	movi	ROPE_LEFT,a0
	calla	rope_command
	movi	ROPE_RIGHT,a0
	calla	rope_command
	movi	ROPE_FRONT,a0
	calla	rope_command

	jruc	_next_command

#********
_ani_damage	;56

	move	*a4+,a0
	neg	a0			;positive a0 = health increase...
	move	*a13(PLYRNUM),a1
	calla	adjust_health

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_start_dizzy ;57

;	clr	a0
;	move	a0,*a13(PLYR_DIZZY)
	PUSH	a10
	move	*a4+,a10			;Where do stars go?
	calla	create_dizzy_proc
	PULL	a10

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_clr_status ;58

	move	*a13(ANIMODE),a1
	andni	MODE_STATUS,a1
	move	a1,*a13(ANIMODE)

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_set_target	;59

	move	*a4+,a0
	move	a4,*a10(OANIPC),L
	calla	set_target_offsets
	jruc	_next_command

#********
_ani_max_x	;60

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_max_z	;61

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_max_y_vel	;62

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_superslave	;63

;	long	pointer to slave table
;	word	index into table

	move	*a4+,a5,L		;* table
	move	*a4+,a6			;index to frame & offsets
	move	a4,*a10(OANIPC),L

	move	*a13(ATTACH_PROC),a11,L
	move	*a11(ATTACH_PROC),a0,L
	cmp	a13,a0
	jrne	#done

	move	*a11(WRESTLERNUM),a0
	X32	a0
	add	a5,a0
	move	*a0,a5,L
 .if DEBUG
 	move	*a5,a0,L		;table defined?
	jrnz	#ok1
	LOCKUP
;	no slave table defined!
#ok1
 .endif

	movi	80,a1	;LWWW
	mpyu	a6,a1

	add	a1,a5
	move	*a5+,a0,L		;* * image
	move	*a0,a0,L		;* image
 .if DEBUG
 	jrnz	#ok
	LOCKUP
;	image not loaded! (null pointer)
#ok
 .endif
	move	a0,*a11(CUR_FRAME),L	;primary frame

	move	*a5+,a0			;xoff
	move	a0,*a13(ATTACH_XOFF)
	move	*a5+,a0
	move	a0,*a13(ATTACH_YOFF)

	move	*a11(OBJ_CONTROL),a3

	move	*a13(FACING_DIR),a14
	btst	PLAYER_RIGHT_BIT,a14
	jrnz	#right
;left
	andni	M_FLIPH,a3		;clear flip bit
	jruc	#cnt
#right
	ori	M_FLIPH,a3		;set flip
#cnt
	move	*a5+,a0			;flip flag
	jrz	#skip

	xori	M_FLIPH,a3		;invert
#skip
	move	a3,*a11(OBJ_CONTROL)

#done
	jruc	_next_command

#********
*
;same as old slaveanim except this executes
;the animation up to the 1st sleep

_ani_slaveanim	;64

	move	*a4+,a5,L		;* table
	move	a4,*a10(OANIPC),L

	move	*a13(ATTACH_PROC),a2,L
	move	*a2(ATTACH_PROC),a0,L
	cmp	a13,a0
	jrne	#done

	move	*a2(WRESTLERNUM),a0
	X32	a0
	add	a0,a5
	move	*a5,a0,L
	jrnz	#ok1
 .if DEBUG
	LOCKUP
;	no slave anim table defined!
 .endif
	jruc	_next_command
#ok1
;a0 = * animation script
;a2 = * wrestler process

	PUSH	a10,a13

	move	a2,a13
	callr	change_anim1a	;execute animation

	PULL	a10,a13

#done
	jruc	_next_command

#********
_ani_rawsound	;65

	move	*a4+,a3,W
	calla	SNDSND
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_damageopp	;66

	move	*a4+,a0
	neg	a0
	move	*a13(ATTACH_PROC),a2,L
	jrz	#done
	move	*a2(PLYRNUM),a1
	calla	adjust_health

#done
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_rndper	;67

	;word	probability
	;long	jump here if hit

	move	*a4+,a0,W
	move	*a4+,a2,L
	calla	RNDPER
	jrls	#done

	;ANI_GOTO a2
	move	a2,*a10(OANIPC),L
	jruc	_next_command

#done
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_waithitopp	;68

	;NOTE:	This is just like an ordinary "WL ticks,frame" type command
	;	except that the ANICNT is zeroed if we hit the opponent.

	;word	max ticks to wait
	;long	frame to hold

	move	*a13(ANIMODE),a14
	ori	MODE_WAITHITOPP,a14
	move	a14,*a13(ANIMODE)

	move	a4,*a10(OANIPC),L
	jruc	_next_command


#********
_ani_attchimage	;69

;long *image,word zoff

	;update OANIPC
	move	a4,a14
	addi	30h,a14
	move	a14,*a10(OANIPC),L

	move	*a4+,a0,L
	jrz	#offimg

	move	*a4+,a1
	move	a1,*a13(ATTIMG_ZOFF)
#off
	move	*a13(ATTIMG_CUR_FRAME),*a13(ATTIMG_LAST_FRAME),L

	move	*a0,a0,L
 .if DEBUG
	jrnz	#ok
	LOCKUP
;NULL IMAGE POINTER!!!
#ok
 .endif
;#offimg
	move	a0,*a13(ATTIMG_CUR_FRAME),L
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#offimg
	move	a0,*a13(ATTIMG_CUR_FRAME),L
	addk	16,a4
	move	a4,*a10(OANIPC),L
	jruc	_next_command

 .if 0

	move	*a4+,a0,L
	jrz	#off
	move	*a4+,a1
	move	a1,*a13(ATTIMG_ZOFF)

	move	*a0,a0,L
 .if DEBUG
	jrnz	#ok
	LOCKUP
;NULL IMAGE POINTER!!!
#ok
 .endif

	move	a0,*a13(ATTIMG_CUR_FRAME),L
	move	*a13(ATTIMG_IMG),a8,L

	move	a0,*a8(OIMG),L
	move	*a0(0),*a8(OSIZE),L
	move	*a0(ISAG),*a8(OSAG),L

	move	*a0(ICMAP),a0,L
	calla	pal_find
	jrnz	#AOK

	LOCKUP	;can't find palette

#AOK
	move	a0,*a8(OPAL)
	move	*a8(OIMG),a0,L
	movb	*a0(ICTRL+7),*a8(OCTRL+7)	;Write 5 z comp bits + bits pp

	move	*a13(OBJ_CONTROL),a7	;flip bits & pixel ops
	andi	0111111b,a7
	setf	6,0,0
	move	a7,*a8(OCTRL)			;Write 6 low bits
	setf	16,1,0

	move	*a13(OBJ_CONST),*a8(OCONST)

	jruc	_next_command

#off
	move	a0,*a13(ATTIMG_CUR_FRAME),L
	jruc	_next_command

 .endif

#********
_ani_ifoppmode		;70

	;If opponent PLYRMODE is #MODE, jump to #BRANCH
	;If the high bit of #MODE is set, jump on PLYRMODE != ~#MODE

	STRUCT	0
	WORD	#MODE
	LONG	#BRANCH
	LABEL	#SIZE

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	move	*a13(CLOSEST_NUM),a11
	X32	a11
	addi	process_ptrs,a11
	move	*a11,a11,L
	move	*a11(PLYRMODE),a14

	move	*a4(#MODE),a0
	jrn	#not
	cmp	a0,a14
	jrne	#done
	jruc	#branch

#not
	not	a0
	cmp	a0,a14
	jreq	#done

#branch
	move	*a4(#BRANCH),a0,L
	move	a0,*a10(OANIPC),L

#done
	jruc	_next_command

#********
_ani_ifbuttons	;71

;buttons (WORD), ani address (LONG)

;SL
	move	a13,a0
	calla	wres_get_but_val_cur

	move	*a4+,a1			;button vals
	move	*a4+,a2,L		;ani address

	and	a1,a0
	cmp	a1,a0
	jrne	#fail

	move	a2,a4	;jump to new ani address
#fail
	move	a4,*a10(OANIPC),L
	jruc	_next_command


#********
_ani_ifnohitblock	;72

;ani address (LONG)

	move	*a4+,a0,L		;this is a conditional goto
	move	*a13(HITBLOCKER),a14
	jrnz	skip?
	move	a0,a4
skip?
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_end	;73
	move	*a10(OANIMODE),a0
	ori	MODE_END,a0
	move	a0,*a10(OANIMODE)
	jruc	_exit

#********
_ani_ifrope	;74
	clr	a11
	jruc	_ani_ifrope_common

#********
_ani_ifnotrope	;75

#MODE	equ	0	;UHW
#DIST	equ	10h	;UHW
#ADDR	equ	20h	;UHL
#SIZE	equ	40h

	;word	distance
	;long	jump here if close enough
	;word	mode	RC_FRONT    - check rope in front of caller
	;		RC_BACK     - check rope behind caller
	;		RC_EITHER   - check nearest rope
	;	or'ed with:
	;		RC_PLAYER   - check for caller
	;		RC_OPPONENT - check for caller's closest opponent

	movk	1,a11

_ani_ifrope_common
	;prepare OANIPC before doing anything else
	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	;;;a9 is process ptr of person for whom we're checking
	move	a13,a9
	move	*a4(#MODE),a0
	sra	8,a0			;mask off the low byte
	jrz	#player_set		;RC_PLAYER == 0

	move	*a13(CLOSEST_NUM),a9
	X32	a9
	addi	process_ptrs,a9
	move	*a9,a9,L
#player_set

	move	*a4(#MODE),a14,W	;mode
	andi	00FFh,a14		;mask off the high byte
	jrz	#check_front		;RC_FRONT == 0
	dec	a14
	jrz	#check_back

	;;;RC_(FRONT|BACK|EITHER) cases
#check_closest
	move	*a9(OBJ_XPOSINT),a1
	cmpi	RING_X_CENTER,a1
	jrgt	#check_right_rope
	jruc	#check_left_rope

#check_front
	move	*a9(FACING_DIR),a0
	btst	MOVE_RIGHT_BIT,a0
	jrnz	#check_right_rope
	jruc	#check_left_rope

#check_back
	move	*a9(FACING_DIR),a0
	btst	MOVE_LEFT_BIT,a0
	jrnz	#check_right_rope
	jruc	#check_left_rope


	;now do the actual check
#check_left_rope
	movi	vln_left_rope,a6
	jruc	#check_xxx_rope
#check_right_rope
	movi	vln_right_rope,a6
#check_xxx_rope
	calla	calc_line_x
	move	*a9(OBJ_XPOSINT),a1
	sub	a0,a1
	abs	a1
	move	*a4(#DIST),a0
	cmp	a0,a1
	jrle	#close_enough


	;a11 is one if we are an IFNOTROPE command, so swap outcomes.
#too_far
	dec	a11
	jrz	#close_enough

	jruc	_next_command

#close_enough
	dec	a11
	jrz	#too_far

	move	*a4(#ADDR),a0,L
	move	a0,*a10(OANIPC),L
	jruc	_next_command


#********
_ani_opp_getup	;76

;if TIME is negative, then clear DELAY_METER

#TIME	equ	0	;UHW
#SIZE	equ	10h

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	move	*a13(ATTACH_PROC),a1,L
	jrnz	#victim_set

	;not attached.  check WHOIHIT
	move	*a13(WHOIHIT),a1,L
	jrz	#done

#victim_set

	move	*a4(#TIME),a0
	jrnn	#norm

	clr 	a14
	move	a14,*a1(DELAY_METER)	;always do delay

	abs	a0			;make GETUP_TIME positive

#norm
	move	*a1(PLYR_DIZZY),a14
	jrnz	#done

	move	a0,*a1(GETUP_TIME)
#done
	jruc	_next_command

#********
_ani_shakecorner	;77

	movk	1,a2
	movi	ROPE_BOUNCEUD,a1
	movi	ROPE_BACK,a0
	calla	rope_command

	movi	ROPE_LEFT,a0
	move	*a13(OBJ_XPOSINT),a14
	cmpi	RING_X_CENTER,a14
	jrle	#dir_set
	movi	ROPE_RIGHT,a0
#dir_set

	movi	ROPE_BOUNCEUD,a1
	calla	rope_command

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_singlestep		;78

	
	calla	get_all_buttons_down
	move	a0,a0
	jrnz	#done
	move	a1,*a10(OANICNT)
	jruc	_exit

#done
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_superslave2	;79

;	# ticks
;	attacker frame
;	table address
;	table index

	STRUCT	0		;ANI_SUPERSLAVE data
	WORD	#TICKS
	LONG	#ATTACKER
	LONG	#TABLE
	WORD	#INDEX
	LABEL	#SIZE

	STRUCT	0		;table data
	LONG	#FRAME
	WORD	#XOFF
	WORD	#YOFF
	WORD	#FLIP
	LABEL	#TABLE_SIZE

	;set OANIPC
	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	;verify the links
	move	*a13(ATTACH_PROC),a11,L
	move	*a11(ATTACH_PROC),a0,L
	cmp	a13,a0
	jrne	#done

	move	*a4(#TICKS),a0
	move	*a13(ANI_SPEED),a1
	mpyu	a0,a1
	srl	8,a1
	move	a1,*a10(OANICNT)
	move	*a4(#ATTACKER),a0,L
	move	*a0,a0,L

	.if DEBUG
	jrnz	#ok0
	LOCKUP	;image not loaded! (null pointer)
#ok0
	.endif
	;set the attacker frame
	move	a0,*a10(OCUR_FRAME),L


	;get the slave table
	move	*a11(WRESTLERNUM),a0
	X32	a0
	move	*a4(#TABLE),a14,L
	add	a14,a0
	move	*a0,a5,L

	.if DEBUG
	move	*a5,a0,L
	jrnz	#ok1
	LOCKUP	;no slave table defined!
#ok1
	.endif

	;get the defender frame
	move	*a4(#INDEX),a14
	movi	#TABLE_SIZE,a1
	mpyu	a14,a1
	add	a1,a5
	move	*a5(#FRAME),a0,L
	move	*a0,a0,L

	.if DEBUG
	jrnz	#ok
	LOCKUP	;image not loaded! (null pointer)
#ok
	.endif

	;set the defender frame
	move	a0,*a11(CUR_FRAME),L

	;compute attach offsets
	; attach Y is raw(table)x + defender Xoff - attacker Xoff

	;attacker anis in a8, defender in a9
	move	*a13(CUR_FRAME),a0,L	;attacker frame
	calla	get_mpart_offsets
	move	a0,a8
	move	*a11(CUR_FRAME),a0,L	;defender frame
	calla	get_mpart_offsets
	move	a0,a9

	;attacker size in a6, defender in a7
	move	*a13(CUR_FRAME),a0,L	;attacker frame
	calla	get_mpart_xsize
	move	a0,a6
	move	*a11(CUR_FRAME),a0,L	;defender frame
	calla	get_mpart_xsize
	move	a0,a7

	;compute Y offset
	move	*a5(#YOFF),a1		;raw Y

	move	a9,a14
	sra	16,a14
	sub	a14,a1			;sub defender aniY

	move	a8,a14
	sra	16,a14
	add	a14,a1			;add attacker aniY

	move	a1,*a13(ATTACH_YOFF)

	;attach Xoff:
	; no flip:       raw x + def xoff - att xoff
	; def flip:      raw x + (def xsz - def xoff) - att xoff

	;compute X offset
	move	*a5(#XOFF),a1			;raw X

	;defender part in a2
	move	a9,a2
	andi	0FFFFh,a2		;def xoff
	sext	a2
	callr	#attacker_flip_test
	jrc	#af_match

	;attack X's don't match up
	move	*a5(#FLIP),a14
	jrz	#def_set
	neg	a2
	add	a7,a2			;def xsize
	jruc	#def_set

	;attack X's match up
#af_match
	move	*a5(#FLIP),a14
	jrnz	#def_set
	neg	a2
	add	a7,a2			;def xsize
#def_set

	;attacker part in a3
	move	a8,a3
	andi	0FFFFh,a3		;att xoff

	add	a2,a1
	sub	a3,a1

	;if X's don't match, negate this
	calla	#attacker_flip_test
	jrc	#foox
	neg	a1
#foox

	move	a1,*a13(ATTACH_XOFF)


	;set flip bits properly
	move	*a11(OBJ_CONTROL),a3
	move	*a13(FACING_DIR),a14
	btst	PLAYER_RIGHT_BIT,a14
	jrnz	#right
;left
	andni	M_FLIPH,a3		;clear flip bit
	jruc	#cnt
#right
	ori	M_FLIPH,a3		;set flip
#cnt
	move	*a5(#FLIP),a0		;flip flag
	jrz	#skip

	xori	M_FLIPH,a3		;invert
#skip
	move	a3,*a11(OBJ_CONTROL)

#done
	jruc	_exit

 SUBRP	#attacker_flip_test
	;Test for attacker flip.  When facing right, flip should be off.
	; When facing left, should be on.  Set the carry flag if everything
	; is okay.
	PUSH	a0,a1
	move	*a13(FACING_DIR),a0
	move	*a13(OBJ_CONTROL),a1
	btst	B_FLIPH,a1
	jrnz	#ttf_set

#ttf_clear
	btst	MOVE_LEFT_BIT,a0
	jrnz	#ttf_flip
	jruc	#ttf_noflip
#ttf_set
	btst	MOVE_RIGHT_BIT,a0
	jrnz	#ttf_flip
	jruc	#ttf_noflip

#ttf_flip
	PULL	a0,a1
	clrc
	rets
#ttf_noflip
	PULL	a0,a1
	setc
	rets

#********
_ani_setoppmode		;80

	STRUCT	0
	WORD	#MODE
	LABEL	#SIZE

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	move	*a13(ATTACH_PROC),a0,L
	jrz	#done
	move	*a0(ATTACH_PROC),a14,L
	jrz	#done

	move	*a0(ANIMODE),a1
	move	*a4(#MODE),a14
	or	a14,a1
	move	a1,*a0(ANIMODE)

#done
	jruc	_next_command

#********
_ani_clroppmode		;81

	STRUCT	0
	WORD	#MODE
	LABEL	#SIZE

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	move	*a13(ATTACH_PROC),a0,L
	jrz	#done
	move	*a0(ATTACH_PROC),a14,L
	jrz	#done

	move	*a0(ANIMODE),a1
	move	*a4(#MODE),a14
	andn	a14,a1
	move	a1,*a0(ANIMODE)

#done
	jruc	_next_command

#********
_ani_oppoffset		;82

	STRUCT	0
	LONG	#TABLE
	LABEL	#SIZE

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	move	*a13(ATTACH_PROC),a0,L
	jrz	#done
	move	*a0(ATTACH_PROC),a14,L
	jrz	#done

	move	*a0(WRESTLERNUM),a1
	X32	a1

	move	*a4(#TABLE),a14,L
	jrz	#done
	add	a14,a1

	move	*a0(OBJ_XPOSINT),a2
	move	*a1+,a3
	move	*a0(FACING_DIR),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#right
	neg	a3
#right
	add	a3,a2
	move	a2,*a0(OBJ_XPOSINT)

	move	*a0(OBJ_YPOSINT),a2
	move	*a1+,a3
	add	a3,a2
	move	a2,*a0(OBJ_YPOSINT)

#done
	jruc	_next_command

#********
_ani_ifblocked	;83

	move	*a4+,a0,L		;this is a conditional goto
	move	*a13(HITBLOCKER),a1
	jrz	#skip

	move	a0,a4			;new ani pc
#skip
	move	a4,*a10(OANIPC),L
	jruc	_next_command

;MJT Start
#********
_ani_waitroll	;84

	;DEAD check
	move	*a13(PLYRMODE),a14
	cmpi	MODE_DEAD,a14
	jreq	#repeat
;MJT Start
	move	*a13(I_WILL_DIE),a14
	jrnz	#repeat
;MJT End

	;since we're not dead, set mode onground, just to be safe
	movi	MODE_ONGROUND,a14
	move	a14,*a13(PLYRMODE)

	move	*a13(IMMOBILIZE_TIME),a0
	jrnz	#repeat

	move	*a13(GETUP_TIME),a0
	jrnz	#repeat

	;clear stars
	clr	a0
	move	a0,*a13(STARS_FLAG)

	calla	do_roll
	jrz	#getup

#repeat	;come back again next tick.
	clr	a0
	move	a0,*a13(Z_BOUND)
	movk	1,a0
	move	a0,*a10(OANICNT)
	rets

#getup
	move	a4,*a10(OANIPC),L
	jruc	_next_command

;MJT End

#********
_ani_setoppfacing	;85

	move	*a13(ATTACH_PROC),a0,L
	jrz	#done
	move	*a0(ATTACH_PROC),a14,L
	jrz	#done

	move	*a0(NEW_FACING_DIR),a14
	move	a14,*a0(FACING_DIR)

#done
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_ifopp		;86

;	.word	ANI_IFOPP,wrestler1,wrestler2,...,wrestler3,-1
; sets STATUS if opponent is one of the wrestlers in the list, else clears.

	move	*a13(CLOSEST_NUM),a11
	X32	a11
	addi	process_ptrs,a11
	move	*a11,a11,L

	move	*a11(WRESTLERNUM),a11

	;clear mode_status
	move	*a13(ANIMODE),a0
	andni	MODE_STATUS,a0
	move	a0,*a13(ANIMODE)

	;compare loop
#loop
	move	*a4+,a0,W
	jrn	#done
	cmp	a0,a11
	jrne	#loop

	;hit.  set mode_status
	move	*a13(ANIMODE),a0
	ori	MODE_STATUS,a0
	move	a0,*a13(ANIMODE)

	;run off the rest of the list
#runoff
	move	*a4+,a14
	jrnn	#runoff

#done
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_snot	;87

	move	a4,a0
	addi	32+4*16,a0		;LWWWW
	move	a0,*a10(OANIPC),L

	push	a10
	clr	a1		;proc ID
	move	*a4+,a7,L	;wake address
	move	a4,a8		;* arguments
	move	a13,a11
	calla	GETPRC
	pull	a10

	jruc	_next_command

#********
_ani_if_butcount_ge	;88

	STRUCT	0
	WORD	#BUTTON
	WORD	#BUTCNT
	LONG	#ADDR
	LABEL	#SIZE

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	move	*a4(#BUTTON),a14
	add	a13,a14
	move	*a14,a14		;button count
	move	*a4(#BUTCNT),a0
	cmp	a0,a14			;#of presses needed to repeat
	jrlt	#fail

	move	*a4(#ADDR),*a10(OANIPC),L	;take branch
#fail
	jruc	_next_command


*********
_ani_if_butcount_lt	;89

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	move	*a4(#BUTTON),a14
	add	a13,a14
	move	*a14,a14		;button count
	move	*a4(#BUTCNT),a0
	cmp	a0,a14			;#of presses needed to repeat
	jrge	#fail2

	move	*a4(#ADDR),*a10(OANIPC),L	;take branch
#fail2
	jruc	_next_command

#********
_ani_if_rptcount	;90

	STRUCT	0
	LONG	#ADDR
	LABEL	#SIZE

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	move	*a13(RPT_COUNT),a14
	jrz	#fail

	move	*a4(#ADDR),*a10(OANIPC),L	;take branch
#fail
	jruc	_next_command

*********
_ani_ifnot_rptcount	;91

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	move	*a13(RPT_COUNT),a14
	jrnz	#fail2

	move	*a4(#ADDR),*a10(OANIPC),L	;take branch
#fail2
	jruc	_next_command


#********
_ani_ringcheck		;92

	;If caller and nearest opponent's INRING values don't match, jump
	; to #BRANCH

	STRUCT	0
	LONG	#BRANCH
	LABEL	#SIZE

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	move	*a13(CLOSEST_NUM),a11
	X32	a11
	addi	process_ptrs,a11
	move	*a11,a11,L
	move	*a11(INRING),a0
	move	*a13(INRING),a1
	cmp	a0,a1
	jreq	#done

	move	*a4(#BRANCH),a0,L
	move	a0,*a10(OANIPC),L

#done
	jruc	_next_command

#********

;--> use this in a PUPPET sequence
;this is the same as calling ani_debris except that
;everything is relative to the wrestler attached to me

_ani_debrisat		;93

	move	a4,a14
	addi	4*16,a14
	move	a14,*a10(OANIPC),L

	move	*a13(ATTACH_PROC),a11,L
	jrz	#done
	move	*a11(ATTACH_PROC),a14,L
	cmp	a13,a14
	jreq	db94
#done
	jruc	_next_command


#********
_ani_debris		;94

	.ref	react_debris

	move	a4,a14
	addi	4*16,a14
	move	a14,*a10(OANIPC),L
	move	a13,a11
db94

	.ref	NUM_OPPS
	move	@NUM_OPPS,A1
	CMPI	2,A1
	JRGE	_next_command
;MJT Start
;Stop debris if other smoke is going on!  Bog reduction...
	.ref	no_debris
	move	@no_debris,a1
	jrnz	_next_command
;MJT End

	push	a10
	clr	a1		;proc ID

	movi	react_debris,a7	;wake address
	move	a4,a8		;* arguments
	calla	GETPRC
	pull	a10

	jruc	_next_command


#********
_ani_set_wrestler_xflip	;95

	move	*a13(FACING_DIR),a14
	btst	PLAYER_RIGHT_BIT,a14
	jrnz	#right

	move	*a13(OBJ_CONTROL),a14
	ori	M_FLIPH,a14
	move	a14,*a13(OBJ_CONTROL)

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#right
	move	*a13(OBJ_CONTROL),a14
	andni	M_FLIPH,a14
	move	a14,*a13(OBJ_CONTROL)

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_slideatopp		;96

;	max ticks to slide
;	target velocity
;	max Z distance
;	target area of opponent
;	x,y,z offset of attack box

	STRUCT	0
	WORD	#MAX_TICKS
	WORD	#VELOCITY
	WORD	#MAX_Z_DIST
	WORD	#TRGT
	WORD	#ATT_X_OFF
	WORD	#ATT_Y_OFF
	WORD	#ATT_Z_OFF
	LABEL	#SIZE


	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	move	*a13(CLOSEST_NUM),a11
	X32	a11
	addi	process_ptrs,a11
	move	*a11,a11,L

	;make sure both have the same INRING value
	move	*a11(INRING),a0
	move	*a13(INRING),a1
	cmp	a0,a1
	jrne	_next_command

	move	*a11(OBJ_XPOS),a1,L
	move	*a11(OBJ_ZPOS),a2,L
	move	*a11(OBJ_YPOS),a3,L
	addi	[256,0],a3

	move	*a11(OBJ_XVEL),a5,L
	move	*a11(OBJ_ZVEL),a6,L
	move	*a11(OBJ_YVEL),a7,L
	move	*a11(GROUND_Y),a8
	sll	16,a8
	addi	[256,0],a8

	move	*a4(#MAX_TICKS),a0

#lp0
	add	a5,a1			;x + xvel
	add	a6,a2			;z + zvel

	move	a7,a7
	jrz	#ok

	add	a7,a3			;y + yvel
;;;;	subi	GRAVITY,a7	;yvel - gravity

	cmp	a3,a8		;hit ground?
	jrgt	#ok
	move	a8,a3
	jruc	#dn
#ok
	dsj	a0,#lp0
#dn
	subi	[256,0],a3

	move	a1,@oppx,L
	move	a2,@oppz,L
	move	a3,@oppy,L

	move	*a4(#TRGT),a0
	jrn	#user
	calla	set_target_offsets
#user

	move	*a13(TGT_XOFF),a0	;target x offset
	sll	16,a0
	move	*a11(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#right1
	neg	a0
#right1
;;;	move	*a11(OBJ_XPOS),a1,L
	move	@oppx,a1,L
	add	a0,a1			;def target x

	move	*a4(#ATT_X_OFF),a0
	sll	16,a0
	move	*a13(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#right0
	neg	a0
#right0
	move	*a13(OBJ_XPOS),a2,L
	add	a0,a2			;att x



	move	*a4(#VELOCITY),a0,L
	move	*a13(FACING_DIR),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#pos
	neg	a0			;left
#pos
	move	a0,*a13(OBJ_XVEL),L


;	move	*a4(#MAX_TICKS),a0
;	move	a0,*a10(OANICNT)

	jruc	_next_command


#********
_ani_clr_butcount	;97

	move	a4,*a10(OANIPC),L
	clr	a14
	move	a14,*a13(PUNCHB_COUNT)
	move	a14,*a13(BLOCKB_COUNT)
	move	a14,*a13(SPUNCHB_COUNT)
	move	a14,*a13(KICKB_COUNT)
	move	a14,*a13(SKICKB_COUNT)

;;;	move	a14,*a13(BUT_COUNT)
	jruc	_next_command

#********
_ani_set_rptcount	;98

	move	*a4+,a0
	move	a0,*a13(RPT_COUNT)

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_dec_rptcount	;99

	move	*a13(RPT_COUNT),a0
	jrz	#atz
	dec	a0
#atz
	move	a0,*a13(RPT_COUNT)

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_shadowtrail	;100

	STRUCT	0
	LONG	#PALETTE
	WORD	#RATE
	WORD	#LIFESPAN
	LABEL	#SIZE

	move	*a4,a0
	jrnz	#not_off

	addi	010h,a4
	move	a4,*a10(OANIPC),L

	move	*a13(SHADTRAIL_PROC),a0,L	;check proc still exists
	jrz	#huh

	calla 	KILL

	clr	a0
	move	a0,*a13(SHADTRAIL_PROC),L	;proc is toast
#huh
	jruc	_next_command




#not_off
	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L
	push	a10

	move	a4,a8			;* arguments
	move	a13,a11			;* wrestler proc

;	move	*a13(PLYRNUM),a0
;	ori	SHADGEN_PID,a0		;proc ID
;	move	a0,a1			;mask
;	calla	EXISTP			;does process already exist?
;	jrz	#no_proc

	move	*a13(SHADTRAIL_PROC),a0,L
	jrz	#no_proc
					;exists, so restart with new arguments
	move	*a13(PLYRNUM),a1
	ori	SHADGEN_PID,a1		;same proc ID
	movi	shadow_gen,a7		;wake address
	calla	XFERPROC
	jruc	#exit

#no_proc
	move	*a13(PLYRNUM),a1
	ori	SHADGEN_PID,a1		;proc ID
	movi	shadow_gen,a7		;wake address
	calla	GETPRC
	move	a0,*a13(SHADTRAIL_PROC),L

#exit
	pull	a10
	jruc	_next_command



***
;a8  = * arguments
;a11 = * wrestler proc

shadow_gen

#lp
	move	*a11(SHADTRAIL_PROC),a0,L
	jrz	#die

	move	*a11(CUR_FRAME),a10,L	;* multi-part image

	clr	a1			;proc ID
	movi	shadow_proc,a7		;wake address
	calla	GETPRC			;create proc for piece

	move	*a10(-10h),a9		;# pieces
	addi	(17-7)*16,a10		;1st header
#loop
	dec	a9
	jrz	#done
	addi	7*16,a10

	clr	a1			;proc ID
	movi	shadow_proc,a7		;wake address
	calla	GETPRC			;create proc for piece

	jruc	#loop
#done
	move	*a8(#RATE),a0
	calla	PRCSLP			;sleep

	jruc	#lp
#die
	DIE


***
;created from shadow_gen - creates an image, sleeps, delobj & dies
shadow_proc

	move	*a8(#LIFESPAN),a9

	movi	Y_SCALE_MULTIPLIER,a0
	move	*a11(OBJ_ZPOSINT),a1
	mpyu	a0,a1
	move	*a11(OBJ_YPOSINT),a0
	sll	16,a0
	sub	a0,a1			;y pos

	move	*a11(OBJ_XPOS),a0,L	;x pos

	move	a10,a2			;* image

	move	*a11(OBJ_PRIORITY),a3,L
	srl	16,a3			;z pos

	move	*a11(OBJ_CONTROL),a4	;DMA flags

	PUSHP	a0,a1,a2,a3,a4
	SLEEP	1
	PULLP	a0,a1,a2,a3,a4

	move	*a8(#PALETTE),a5,L
	move	a5,b0			;palette to use

	clr	a5			;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJP

	move	a9,a0			;lifespan
	calla	PRCSLP			;sleep
;#slp
;	move	@PCNT,a1
;	andi	1,a1
;	sll	12,a1
;	move	*a8(OXPOS),a0
;	andi	0fffh,a0
;	or	a1,a0
;	move	a0,*a8(OXPOS)
;	SLEEP	1
;	dsj	a9,#slp

	calla	DELOBJA8
	DIE


#********
_ani_createproc	;101

	STRUCT	0
	LONG	#ADDR
	WORD	#PROCID
	WORD	#WORD1
	WORD	#WORD2
	WORD	#WORD3
	LABEL	#SIZE


	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L
	move	a13,a11

	push	a10
	move	*a4(#PROCID),a1	;proc ID
	move	*a4(#ADDR),a7,L	;wake address
	addi	#WORD1,a4
	move	a4,a8		;* arguments
	calla	GETPRC
	pull	a10

	jruc	_next_command


#********
_ani_target	;102

	;sets leapat target to #TARGET1 or #TARGET2, depending on the
	; value of #MODE.
	;ex: ANI_TARGET,TGT_HEAD,TGT_KNEES,ATM_CLOSEST
	;    target the victim's head or victim's knees, whichever
	;    is closest.

	;NOTE: This assumes that victim is on the ground.  If he's
	; not, the results will be screwy.

	STRUCT	0
	WORD	#TARGET1		;TGT_???
	WORD	#TARGET2		;TGT_???
	WORD	#MODE			;ATM_CLOSEST|ATM_FARTHEST
	LABEL	#SIZE

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L


	;first, figure out the orientation of the wrestlers
	calla	get_opp_process
	move	a0,a11

	;see if our flip bits match
	move	*a13(OBJ_CONTROL),a0
	move	*a11(OBJ_CONTROL),a1
	xor	a1,a0
	btst	B_FLIPH,a0

	;if Z is set, the flips match and thus the we're facing our
	; opponent's feet, thus the #TARGET with the highest value
	; is closest.  if Z isn't set, the opposite is true.
	jrz	#facing_feet
	jruc	#facing_head

#facing_feet
	move	*a4(#MODE),a14
	cmpi	ATM_CLOSEST,a14
	jreq	#choose_highest
	jruc	#choose_lowest

#facing_head
	move	*a4(#MODE),a14
	cmpi	ATM_CLOSEST,a14
	jreq	#choose_lowest
	jruc	#choose_highest

#choose_highest
	move	*a4(#TARGET1),a0
	move	*a4(#TARGET2),a1
	cmp	a1,a0
	jrge	#set
	jruc	#switch

#choose_lowest
	move	*a4(#TARGET1),a0
	move	*a4(#TARGET2),a1
	cmp	a1,a0
	jrle	#set
	jruc	#switch

#switch
	move	a1,a0
#set
	calla	set_target_offsets
	jruc	_next_command

#********
_ani_hmbwait	;103

	STRUCT	0
	WORD	#HIT
	WORD	#MISSED
	WORD	#BLOCKED
	LABEL	#SIZE

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	;first check for a block
	move	*a13(HITBLOCKER),a1
	jrz	#check_hit

	move	*a4(#BLOCKED),*a10(OANICNT)
	jrz	_next_command
	rets

	;then for a hit
#check_hit
	move	*a13(ANIMODE),a14
	btst	MODE_STATUS_BIT,a14
	jrz	#missed

	move	*a4(#HIT),*a10(OANICNT)
	jrz	_next_command
	rets

	;assume a miss
#missed
	move	*a4(#MISSED),*a10(OANICNT)
	jrz	_next_command
	rets

#********
_ani_safe_time	;104

	move	*a4+,a0
	move	a0,*a13(SAFE_TIME)

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
;this won't do anything unless they're attached

_ani_setopp_plyrmode	;105

	move	*a4+,a0
	move	a4,*a10(OANIPC),L

	move	*a13(ATTACH_PROC),a11,L
	move	*a11(ATTACH_PROC),a14,L
	cmp	a13,a14
	jrne	#done

	move	a0,*a11(PLYRMODE)
#done
	jruc	_next_command

#********
;this won't do anything unless they're attached

_ani_xflip_opp		;106

	move	*a13(ATTACH_PROC),a11,L
	move	*a11(ATTACH_PROC),a14,L
	cmp	a13,a14
	jrne	#done

	move	*a11(OBJ_CONTROL),a0
	xori	M_FLIPH,a0
	move	a0,*a11(OBJ_CONTROL)

#done
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
;sets a LONG in wrestler PDATA
_ani_setlong	;107

	STRUCT	0
	WORD	#PDOFF
	LONG	#LONG
	LABEL	#SIZE

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	move	*a4(#PDOFF),a0
	add	a13,a0
	move	*a4(#LONG),a1,L
	move	a1,*a0,L

	jruc	_next_command

#********
*
_ani_immobilize	;108

	move	*a4+,a0

	move	*a13(PLYR_DIZZY),a14
	jrnz	#skip
	move	*a13(WHOIHIT),a14,L

	move	a0,*a14(IMMOBILIZE_TIME)
#skip
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
;this flips your opponent based upon flip table
;this won't do anything unless they're attached

_ani_xflip_tbl	;109

	STRUCT	0
	LONG	#FLIPTBL
	LABEL	#SIZE

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	move	*a13(ATTACH_PROC),a11,L
	move	*a11(ATTACH_PROC),a14,L
	cmp	a13,a14
	jrne	#done

	move	*a11(WRESTLERNUM),a0
	X16	a0

	move	*a4(#FLIPTBL),a1,L
	add	a1,a0
	move	*a0,a0
	jrz	#done			;no flip

	move	*a11(OBJ_CONTROL),a0
	xori	M_FLIPH,a0
	move	a0,*a11(OBJ_CONTROL)
#done
	jruc	_next_command

#********
* this sets the vels for a wrestler you're attached to
* x-vel and z-vel are relative to attackers facing dir

_ani_setoppvels		;110

	STRUCT	0
	LONG	#XVEL
	LONG	#YVEL
	LONG	#ZVEL
	LABEL	#SIZE

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	move	*a13(ATTACH_PROC),a11,L
	move	*a11(ATTACH_PROC),a14,L
	cmp	a13,a14
	jrne	#done

	move	*a4(#YVEL),*a11(OBJ_YVEL),L

	move	*a4(#XVEL),a0,L
	move	*a13(FACING_DIR),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#xok			;right
	neg	a0			;left
#xok
	move	a0,*a11(OBJ_XVEL),L

	move	*a4(#ZVEL),a0,L
	btst	MOVE_DOWN_BIT,a14
	jrnz	#zok			;down
	neg	a0			;up
#zok
	move	a0,*a11(OBJ_ZVEL),L

#done
	jruc	_next_command


#********
;same as waithitgnd except you pass an offset to add to ground Y
;(so you can make the guy hit the ground sooner)

_ani_waithitgnd2	;111

	STRUCT	0
	WORD	#OFFSET
	LABEL	#SIZE


	move	*a13(OBJ_YVEL),a0,L	;must have down velocity
	jrp	#no_gnd

	;if we're the master and the attach is valid, check and see if
	; our puppet has hit the ground.
	move	*a13(ANIMODE),a14
	btst	MODE_KEEPATTACHED_BIT,a14
	jrz	#skip_pcheck

	move	*a13(ATTACH_PROC),a0,L
	jrz	#skip_pcheck		;we're attached?
	move	*a0(ATTACH_PROC),a14,L
	jrz	#skip_pcheck		;they're attached?
	cmp	a13,a14
	jrne	#skip_pcheck		;to each other?

	;ah, but if the opponent's MODE_GHOST bit is set, ignore him
	move	*a0(ANIMODE),a14
	btst	MODE_GHOST_BIT,a14
	jrnz	#skip_pcheck

	move	*a0(OBJ_YPOSINT),a1,W
	move	*a0(GROUND_Y),a2,W
	move	*a4(#OFFSET),a14
	add	a14,a2
	cmp	a2,a1
	jrle	#hit_gnd

#skip_pcheck

	move	*a13(OBJ_YPOSINT),a0
	move	*a13(GROUND_Y),a2
	move	*a4(#OFFSET),a14
	add	a14,a2
	cmp	a2,a0			;a0-a1
	jrgt	#no_gnd

#hit_gnd
	sll	16,a2
	move	a2,*a0(OBJ_YPOS),L

	.REF	SMALL_BOUNCE
	CALLA	SMALL_BOUNCE

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L
	jruc	_next_command

#no_gnd
	movk	1,a0
	move	a0,*a10(OANICNT)	;# ticks to hold cur frame
	rets


#********
_ani_set_opp_xvel	;112

;args:	.long (XVEL) .word (MODE)	;if MODE=0  vel is absolute
					;if MODE=1  vel is facing relative
					;if MODE=2  vel is hit relative
					;if MODE=3  vel is new_face relative

	move	*a13(ATTACH_PROC),a11,L
	move	*a11(ATTACH_PROC),a14,L
	cmp	a13,a14
	jrne	#done

	move	*a4+,a0,L
	move	*a4+,a1
	jrz	#abs
	dec	a1
	jrz	#face
	dec	a1
	jrz	#hit

;new_facing relative
	move	*a13(NEW_FACING_DIR),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#abs			;right
	neg	a0			;left
	jruc	#abs

#hit
;hit relative
	move	*a13(PLYR_HIT_SIDE),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#abs			;hit from right

	neg	a0			;hit from left
	jruc	#abs
#face
	move	*a13(FACING_DIR),a14
	btst	MOVE_RIGHT_BIT,a14
	jrnz	#abs			;right
	neg	a0			;left
#abs
	move	a0,*a11(OBJ_XVEL),L

#done
	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_set_attach	;113
	move	*a13(WHOIHIT),a0,L
	move	a0,*a13(ATTACH_PROC),L
	move	a13,*a0(ATTACH_PROC),L

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_inc_combo_count ;114
	move	*a13(COMBO_COUNT),a0
	inc	a0
	move	a0,*a13(COMBO_COUNT)

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_clear_combo_count ;115
	CLR	A0
	move	a0,*a13(COMBO_COUNT)
;	MOVE	A0,*A13(COMBO_START)

	MOVE	*a13(WHOIHIT),A0,L
	MOVE	*A0(GETUP_TIME),A14
	JRZ	NO_WORRIES_MATEY
	MOVI	40,A14
	move	a14,*a0(IMMOBILIZE_TIME)
	CLR	A14
	MOVE	A14,*A0(GETUP_TIME)
NO_WORRIES_MATEY
	MOVI	120,A14
	MOVE	A14,*A0(DELAY_METER)

;	MMTM	SP,A0,A4,A8,A10
;	CALLA	REWIRE_COMBO_METER
;	MMFM	SP,A0,A4,A8,A10

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
_ani_add_move ;116
	move	*a4+,a7
	move	*a4+,a5
	move	*a4+,a6
	mmtm	sp,a0,a4,a8,a10
	calla	ADD_TO_COMBO_COUNT
	mmfm	sp,a0,a4,a8,a10

	move	a4,*a10(OANIPC),L
	jruc	_next_command

#********
;
;if num_ticks is negative then use default value
;
_ani_startattack ;117

	STRUCT	0
	WORD	#ATT_TYPE
	WORD	#NUM_TICKS
	LABEL	#SIZE

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	move	*a4(#ATT_TYPE),*a13(ATTACK_TYPE)

	move	*a4(#NUM_TICKS),a1
	jrp	#ok

	movk	15,a1			;default tick count
#ok
	move	@round_tickcount,a0
	add	a0,a1
	move	a1,*a13(ATTACK_TIME)

	jruc	_next_command

#********
_ani_changeanim_tbl	;118

	STRUCT	0
	LONG	#TABLE
	LABEL	#END

	move	*a13(WRESTLERNUM),a0
	X32	a0
	move	*a4(#TABLE),a14,L
	add	a14,a0
	move	*a0,a0,L

	move	a0,*a10(OANIBASE),L
	move	a0,*a10(OANIPC),L

	jruc	_next_command

#********
_ani_if_rptcount_ge	;119

	STRUCT	0
	WORD	#VAL
	LONG	#ADDR
	LABEL	#SIZE

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	move	*a13(RPT_COUNT),a14
	move	*a4(#VAL),a0,W
	cmp	a0,a14
	jrlt	#fail

	move	*a4(#ADDR),*a10(OANIPC),L	;take branch
#fail
	jruc	_next_command

#********
_ani_if_rptcount_lt	;120

	STRUCT	0
	WORD	#VAL
	LONG	#ADDR
	LABEL	#SIZE

	move	a4,a14
	addi	#SIZE,a14
	move	a14,*a10(OANIPC),L

	move	*a13(RPT_COUNT),a14
	move	*a4(#VAL),a0,W
	cmp	a0,a14
	jrge	#fail

	move	*a4(#ADDR),*a10(OANIPC),L	;take branch
#fail
	jruc	_next_command


#*****************************************************************************
* used inside anim commands - doesn't call animate_wrestler
;a0 = * animation script
;a2 = * wrestler process

 SUBR	change_anim_anim

	move	a0,*a2(ANIBASE),L
	move	a0,*a2(ANIPC),L

	movi	GRAVITY,a0		;reset gravity
	move	a0,*a2(OBJ_GRAVITY),L
	clr	a0
	move	a0,*a2(ANIMODE)
	movk	1,a0
	move	a0,*a2(ANICNT)

	rets

#*****************************************************************************
;primary animation
;a0 = * animation script

 SUBR	change_anim1

	move	*a13(ANIMODE),a2
	btst	MODE_END_BIT,a2		;if anim has ended, then
	jrnz	change_anim1a		;always restart it

	move	*a13(ANIBASE),a2,L
	cmp	a0,a2
	jreq	#no_change

 SUBR	change_anim1a

	move	a0,*a13(ANIBASE),L
	move	a0,*a13(ANIPC),L

	clr	a0
	move	a0,*a13(ANIMODE)
	movk	1,a0
	move	a0,*a13(ANICNT)

	movi	GRAVITY,a0		;reset gravity
	move	a0,*a13(OBJ_GRAVITY),L
	callr	animate_wrestler1

#no_change
	rets

#*****************************************************************************
;secondary animation
;a0 = * animation script

 SUBR	change_anim2

	move	*a13(ANIMODE2),a2
	btst	MODE_END_BIT,a2		;if anim has ended, then
	jrnz	change_anim2a		;always restart it

	move	*a13(ANIBASE2),a2,L
	cmp	a0,a2
	jreq	#no_change

 SUBR	change_anim2a

	move	a0,*a13(ANIBASE2),L
	move	a0,*a13(ANIPC2),L

	clr	a0
	move	a0,*a13(ANIMODE2)
	movk	1,a0
	move	a0,*a13(ANICNT2)

	callr	animate_wrestler2

#no_change
	rets

#*****************************************************************************

 SUBR	slaveanim_tbl

 .long wres_slave_anim	;Bret
 .long wres_slave_anim	;Razor
 .long wres_slave_anim	;Taker
 .long wres_slave_anim	;Yokozuna
 .long wres_slave_anim	;Shawn
 .long wres_slave_anim	;BamBam
 .long wres_slave_anim	;Doink
 .long wres_slave_anim	;Adam
 .long wres_slave_anim	;Lex


 SUBR	wres_slave_anim

	.word	ANI_SETMODE,MODE_UNINT+MODE_NOAUTOFLIP+MODE_NOGRAVITY
	.word	ANI_ZEROVELS
	.word	ANI_SETSPEED,100h
	.word	ANI_END

#*****************************************************************************

 SUBR	set_images

	PUSH	a13

	movi	process_ptrs,a1
	movi	NUM_WRES,a2
#slp
	move	*a1+,a13,L
	jrz	#skp_mtp
	PUSH	a1,a2
	callr	#set_image
	PULL	a1,a2
#skp_mtp
	dsj	a2,#slp

	PULL	a13
	rets


#set_image

;	CLR	A5
;	MOVE	A5,*A13(SCREENY)

	move	*a13(OBJ_ZPOS),a0,L
	ori	[01000h,0],a0
	move	*a13(INRING),a14
	jrz	#inring
	cmpi	[015ach,0],a0
	jrgt	#inring

	subi	[01e5h,0],a0		;below mat
#inring
	move	a0,*a13(OBJ_PRIORITY),L


	move	*a13(OBJ_XPOS),a5,L	;x val

	movi	Y_SCALE_MULTIPLIER,a0
	move	*a13(OBJ_ZPOSINT),a1
	mpyu	a0,a1
	move	a1,a6			;y val

	move	*a13(OBJ_BASE),a3,L


	move	a3,a0
	movk	MAX_PIECES,a1
	movi	[-100,0],a14		;set all images offscreen
	move	*a13(OBJ_PRIORITY),a2,L
	clr	a7
#lp
	move	*a0+,a8,L
	move	a7,*a8(OSAG),L
	move	a14,*a8(OXVAL),L
	move	a6,*a8(OYVAL),L		;keep updating YVAL to keep priorities
	move	a2,*a8(OZVAL),L
	dsj	a1,#lp

;	move	*a13(OBJ_CONTROL),a7	;flip bits & pixel ops
;	andni	00111b,a7
;	movi	DMAWNZ,a0
;	andi	01111b,a0
;	or	a0,a7

	move	*a13(OBJ_CONTROL),a7	;flip bits & pixel ops
	andi	0110000b,a7
	ori	DMAWNZ,a7

	clr	a10			;x offset
	move	*a13(GROUND_Y),a11	;y offset


;	move	*a13(CUR_FRAME),a0,L
;	move	*a0(12*16),a0		;shadow index
	clr	a0			;<------temp!!!!!!
	move	a0,*a13(PLYR_SHADOW)
;	X32	a0
;	addi	shadows,a0
;	move	*a0,a0,L

	movi	shadow,a0

;make shadow low priority

	move	*a13(OBJ_PRIORITY),a14,L
	PUSH	a14

	movi	[013c8h,0],a14		;inside ring
	move	*a13(INRING),a1
	jrz	#in
	movi	[01095h,0],a14		;outside ring
#in
	move	a14,*a13(OBJ_PRIORITY),L

	callr	#plot_object		;plot shadow
	PULL	a14
	move	a14,*a13(OBJ_PRIORITY),L

	move	*a8(OXPOS),a0

	move	*a13(ANIMODE),a14
	btst	MODE_NOSHADOW_BIT,a14
	jrz	#shadow_on
	clr	a0
#shadow_on
	andni	1,a0
	move	@PCNT,a1
	andi	1,a1
	or	a1,a0
	move	*a8(OYPOS),a1
	andi	1,a1
	xor	a1,a0
	move	a0,*a8(OXPOS)		;shake shadow

	;leave him off if in mode_invisible
	move	*a13(ANIMODE),a14
	btst	MODE_INVISIBLE_BIT,a14
	jrnz	#done2


	move	*a13(OBJ_CONTROL),a7	;flip bits & pixel ops
	andi	0111111b,a7


	clr	a10			;x offset
	move	*a13(OBJ_YPOSINT),a11	;y offset


	move	*a13(CUR_FRAME),a0,L
	callr	#plot_object		;image

	move	*a13(OBJ_PAL),a1
	move	a1,*a8(OPAL)

	move	*a0(-10h),a4		;# pieces
	addi	(13+4-7)*16,a0		;1st header
#loop1
	dec	a4
	jrz	#done1
	addi	7*16,a0
	callr	#plot_object		;image

	move	*a13(OBJ_PAL),a1
	move	a1,*a8(OPAL)

	jruc	#loop1
#done1

	move	*a13(CUR_FRAME),a9,L
	move	*a9(IANI2X),a14,L		;secondary X & Y
	inc	a14				;should be 0
	jrz	#no_2nd_piece

	move	*a9(IANIOFFX),a10		;display x offset
	move	*a9(IANI2X),a14			;secondary X
	sub	a14,a10

	move	*a9(IANIOFFY),a1		;display y offset
	move	*a9(IANI2Y),a14			;secondary Y
	sub	a14,a1
	add	a1,a11

	move	*a13(CUR_FRAME2),a0,L
	callr	#plot_object

	move	*a13(OBJ_PAL),a1
	move	a1,*a8(OPAL)

	move	*a0(-10h),a4		;# pieces
	addi	(13+4-7)*16,a0		;1st header
#loop2
	dec	a4
	jrz	#done2
	addi	7*16,a0
	callr	#plot_object		;image

	move	*a13(OBJ_PAL),a1
	move	a1,*a8(OPAL)

	jruc	#loop2

#no_2nd_piece
	movi	MODE_END,a0		;don't bother animating
	move	a0,*a13(ANIMODE2)	;if no 2nd piece

#done2

;	move	a13,a3
;	addi	ATTACH_IMG1,a3
;	movk	4,a4
;#attloop
;	move	*a3+,a8,L
;	jrz	#skip

;set the x,y & z of image
;;	LOCKUP

	move	*a13(ATTIMG_IMG),a8,L
	move	*a13(ATTIMG_CUR_FRAME),a0,L
	jrnz	#onscr

	move	a0,*a8(OXVAL),L
	movi	[-100,0],a0			;set all images offscreen
	move	a0,*a8(OYVAL),L
	rets

#onscr
	move	*a13(ATTIMG_LAST_FRAME),a1,L
	cmp	a0,a1
	jreq	#no_change

;image has just changed

	move	*a13(ATTIMG_IMG),a8,L
	move	a0,*a8(OIMG),L
	move	*a0(0),*a8(OSIZE),L
	move	*a0(ISAG),*a8(OSAG),L

	move	*a0(ICMAP),a0,L

	.ref	pal_getf
	calla	pal_getf
;;;	calla	pal_find
	jrnz	#AOK

	LOCKUP	;can't get palette

#AOK
	move	a0,*a8(OPAL)
	move	*a8(OIMG),a0,L
	movb	*a0(ICTRL+7),*a8(OCTRL+7)	;Write 5 z comp bits + bits pp

	move	*a13(OBJ_CONTROL),a7	;flip bits & pixel ops
	andi	0111111b,a7
	setf	6,0,0
	move	a7,*a8(OCTRL)			;Write 6 low bits
	setf	16,1,0

	move	*a13(OBJ_CONST),*a8(OCONST)

	move	*a13(ATTIMG_CUR_FRAME),*a13(ATTIMG_LAST_FRAME),L

#no_change

	move	a5,*a8(OXVAL),L
	move	a6,*a8(OYVAL),L

	move	*a13(OBJ_PRIORITY),a0,L
	move	*a13(ATTIMG_ZOFF),a1
	sll	16,a1
	add	a1,a0
	move	a0,*a8(OZVAL),L

	move	*a13(OBJ_YPOSINT),a11	;y offset
	move	*a8(OIMG),a0,L
	move	*a0(IANIOFFY),a1
	add	a11,a1			;add in Y pos & ani-offset
	move	a1,*a8(ODYOFF)		;display y offset

	move	*a0(IANIOFFX),*a8(ODXOFF)

#skip
;	dsj	a4,#attloop

	rets

#plot_object

	move	*a3+,a8,L		;* object

	move	a5,*a8(OXVAL),L
	move	a6,*a8(OYVAL),L

	move	*a13(OBJ_PRIORITY),*a8(OZVAL),L

	move	a0,*a8(OIMG),L
	move	*a0(0),*a8(OSIZE),L
	move	*a0(ISAG),*a8(OSAG),L

	move	*a0(IANIOFFX),a1
	add	a10,a1				;add in X ani-offset (if any)
	move	a1,*a8(ODXOFF)			;display x offset

	move	*a0(IANIOFFY),a1
	add	a11,a1				;add in Y pos & ani-offset
	move	a1,*a8(ODYOFF)			;display y offset

	movb	*a0(ICTRL+7),*a8(OCTRL+7)	;Write 5 z comp bits + bits pp

	setf	6,0,0
	move	a7,*a8(OCTRL)			;Write 6 low bits
	setf	16,1,0

	move	*a13(OBJ_CONST),*a8(OCONST)

	rets


#*****************************************************************************



shadows
	.ref	shadow
	.long	shadow


******************************************************************************
	.end

