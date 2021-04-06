**************************************************************
*
* Software:	Jason Skiles
* Initiated:	4 Oct 93
*
* COPYRIGHT (C) 1993 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 12/8/93 11:15
**************************************************************

	.file	"robo.asm"
	.title	"robotron game"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"		;Mproc equates
	.include	"display.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"sys.equ"
	.include	"game.equ"
	.include	"audit.equ"
	.include	"macros.h"
	.include	"link.equ"

;	.include	"roboimg.glo"
	.include	"roboimg.tbl"
	.include	"fontsimg.glo"

	;kludge
	.ref	robo_p

#*****************************************************************************

	;from ADJUST.ASM
	.ref	BINBCD

	;from COLL2.ASM
	.ref	collisions,CCCCount

	;from DCSSOUND.ASM
	.ref	nosounds,SNDSND

	;from DISPLAY.ASM
	.ref	pal_getf,STOPOBJS,fg2bg

	;from MAIN.ASM
	.ref	dpageflip,IRQSKYE

	;from MPROC.ASM
	.ref	KIL1C

	;from STRING.ASM
	.ref	setup_message,print_string_R,mess_objid,copy_string
	.ref	dec_to_asc

	;from UTIL.ASM
	.ref	get_all_buttons_cur,get_stick_val_cur,RNDRNG0,get_start_cur
	.ref	WIPEOUT,CYCLE_TABLE,civani,civanic

	;from WRESTLE.ASM	
	.if DEBUG
	.ref	CPULEFT
	.endif
	.ref	HALT,PCNT

	;for WRESTLE.ASM
	.def	RE_DEADPLAYER,RE_WAVEDONE,RE_ABORT,RE_BACKUP

	.ref	_switch_addr,_switch2_addr,ADD_VOICE

#*****************************************************************************

	BSSX	robo_end,	16	;reason for wave end
	BSSX	robotron_score,	32	;UHL score
	.bss	player_dead,	16
	.bss	starts_down,	16	;are both starts down?
	.bss	player_object,	32	;pointer to char1 obj
	.bss	gun_proc,	32	;gun process address
	.bss	robo_wave,	16	;which wave to perform?
	.bss	live_badguys,	16	;wave-preserving badguy count
	.bss	forward,	16	;skip wave
	.bss	backward,	16	;drop back a wave

#*****************************************************************************

ROBO_DEBUG	equ	0
WAVE_CONTROL	equ	0
BOG_MONITOR	equ	0

ROBO_PAGE	equ	0*256

ROBJ_MOM	equ	1
ROBJ_DAD	equ	2
ROBJ_KID	equ	3

;termination causes
RE_DEADPLAYER	equ	1
RE_WAVEDONE	equ	2
RE_ABORT	equ	3
RE_BACKUP	equ	4


#*****************************************************************************
******************************************************************************
******************************************************************************
	.ref	robo_icon_trigger
	.ref	p1icon_total
	.ref	p2icon_total


 SUBR	robo_check

	.if DEBUG
	jruc	#robo_ok
	.endif
	jruc	#robo_end

	move	@p1icon_total,a0,L
	move	@robo_icon_trigger,a14
	cmp	a0,a14
	jrle	#robo_ok
	move	@p2icon_total,a0,L
	cmp	a0,a14
	jrgt	#robo_end
#robo_ok
	sll	1,a14
	move	a14,@robo_icon_trigger
	callr	reset_roboscore
	callr	robo_sound_init

;	movi	-1,a0
;	calla	ADD_VOICE

	clr	a0
#robo_loop
	JSRP	robo_game
	move	@robo_end,a14
	cmpi	RE_DEADPLAYER,a14
	jreq	#player_died
	cmpi	RE_WAVEDONE,a14
	jreq	#wave_successful
	cmpi	RE_ABORT,a14
	jreq	#wave_aborted
	cmpi	RE_BACKUP,a14
	jreq	#back_up
	jruc	#robo_end

#player_died
	jruc	#robo_loop

#wave_successful
	inc	a0
	cmpi	16,a0
	jrne	#robo_loop
	jruc	#robo_end

#wave_aborted
	jruc	#robo_end

#back_up
	dec	a0
	jrnn	#robo_loop
	clr	a0
	jruc	#robo_loop

#robo_end
	RETP


#*****************************************************************************
******************************************************************************
******************************************************************************

 SUBRP	reset_roboscore

	clr	a14
	move	a14,@robotron_score,L
	rets


#*****************************************************************************
******************************************************************************
******************************************************************************

 SUBR	robo_game

	sla	4,a0
	move	a0,@robo_wave,W

	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT

	clr	a0
	move	a0,@HALT
	move	a0,@dtype		;2d mode
	move	a0,@IRQSKYE
	move	a0,@CCCCount

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	SLEEPK	1

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	SLEEPK	2

	calla	nosounds		;kill the select music

	;draw the frame
	move	@robo_wave,a0
	addi	#border_colors,a0
	move	*a0,a0,W
	callr	draw_frame

	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	2

	clr	a14
	move	a14,@player_dead,W	;clear the done flag

	;initialize the robo palette color cycles
	callr	robo_pal_cycles

	;initialize the badguy count
	clr	a14
	move	a14,@live_badguys,W

	;place the wave count
	callr	wave_count

	;create the score monitor
	CREATE	ROBOSCORE_PID,score

	;set up the player object
	CREATE	ROBOMAN_PID,our_hero		;start the little guy up
	CREATE	PLYRGUN_PID,player_gun	;give him a weapon
	move	a0,@gun_proc,L		;save the address

	;set up some grunts
	move	@robo_wave,a0
	addi	#wave_grunts,a0
	move	*a0,a0,W
	move	@robo_wave,a2
	addi	#grunt_speeds,a2
	move	*a2,a2,W
	callr	make_grunts

	;make some hulks
	move	@robo_wave,a0
	addi	#wave_hulks,a0
	move	*a0,a0,W
	callr	make_hulks

	;sphereoids
	move	@robo_wave,a0
	addi	#wave_sphereoids,a0
	move	*a0,a0,W
	callr	make_sphereoids

	;quarks
	move	@robo_wave,a0
	addi	#wave_quarks,a0
	move	*a0,a0,W
	callr	make_quarks

	;make a few posts
	move	@robo_wave,a0
	addi	#wave_posts,a0
	move	*a0,a0,W

	move	@robo_wave,a1
	addi	#post_types,a1
	move	*a1,a1,W

	move	@robo_wave,a2
	addi	#post_colors,a2
	move	*a2,a2,W

	callr	make_posts

	;and some people
	move	@robo_wave,a0
	move	a0,a1
	move	a0,a2
	addi	#wave_moms,a0
	addi	#wave_dads,a1	
	addi	#wave_kids,a2
	move	*a0,a0,W
	move	*a1,a1,W
	move	*a2,a2,W
	callr	make_humans

	;start the collision checker
	CREATE	COLL_PID,collisions

	;create the both-start-btn watcher
	clr	a0
	move	a0,@starts_down,W
	move	a0,@forward,W
	move	a0,@backward,W
	CREATE	MISC_PID,watch_both_starts

	.if	WAVE_CONTROL
	CREATE	MISC_PID,wave_mover
	.endif

	.if DEBUG
	.if BOG_MONITOR
	CREATE	MISC_PID,bog_o_meter
	.endif
	.endif

	calla	display_unblank

#not_done
	SLEEPK	1
	move	@live_badguys,a14
	jrz	#wave_done

	move	@player_dead,a14
	jrnz	#dead_hero

	move	@starts_down,a14
	jrnz	#wave_abort

	move	@forward,a14
	jrnz	#wave_done

	move	@backward,a14
	jrnz	#back_up
	jruc	#not_done


#wave_done
	movi	RE_WAVEDONE,a14
	jruc	#quit
#dead_hero
	movi	RE_DEADPLAYER,a14
	jruc	#quit
#wave_abort
	movi	RE_ABORT,a14
	jruc	#quit

#back_up
	movi	RE_BACKUP,a14
	jruc	#quit

#quit
	move	a14,@robo_end,W

	;put the wave back in a0 just like we found it
	move	@robo_wave,a0,W
	sra	4,a0
	RETP


#border_colors
	.if	ROBO_DEBUG
	.word	1
	.endif
	.word	01,06,01,14,07,03,02,08
	.word	00,10,01,06,01,14,07,03

#wave_grunts
	.if	ROBO_DEBUG
	.word	4
	.endif
;	.word	15,17,22,34,20,30,00,30
;	.word	30,25,30,00,30,27,25,30

	.word	15,17,22,34,20,32,00,35
	.word	60,25,35,00,35,27,25,35

#grunt_speeds
	.if	ROBO_DEBUG
	.word	1000
	.endif
	.word	20,15,15,15,15,15,15,15
	.word	15,15,14,14,14,14,14,13

#wave_posts
	.if	ROBO_DEBUG
	.word	15
	.endif
	.word	05,15,25,25,20,25,00,25
	.word	00,20,25,00,25,05,20,25

#post_types
	.if	ROBO_DEBUG
	.word	0
	.endif
	.word	0,1,3,8,4,2,0,7
	.word	0,5,0,1,3,8,4,2

#post_colors
	.if	ROBO_DEBUG
	.word	0Fh
	.endif
	.word	15,14,11,13,14,15,14,11
	.word	14,10,15,14,11,13,14,15

#wave_hulks
	.if	ROBO_DEBUG
	.word	0
	.endif
	.word	00,05,06,07,00,07,12,08
	.word	04,00,08,13,08,20,02,03

#wave_sphereoids
	.if	ROBO_DEBUG
	.word	0
	.endif
	.word	00,01,03,04,01,04,00,05
	.word	05,01,05,00,05,02,01,05

#wave_quarks
	.if	ROBO_DEBUG
	.word	0
	.endif
	.word	00,00,00,00,00,00,10,00
	.word	00,00,00,12,00,00,00,00

#wave_moms
	.if	ROBO_DEBUG
	.word	2
	.endif
	.word	01,01,02,02,15,03,04,03
	.word	03,00,03,03,03,05,00,03

#wave_dads
	.if	ROBO_DEBUG
	.word	2
	.endif
	.word	01,01,02,02,00,03,04,03
	.word	03,22,03,03,03,05,00,03

#wave_kids
	.if	ROBO_DEBUG
	.word	2
	.endif
	.word	00,01,02,02,01,03,04,03
	.word	03,00,03,03,03,05,22,03


#*****************************************************************************
******************************************************************************
******************************************************************************
*
*	PLAYER SECTION
*

	;reg use
	; a4  - current position in animation script
	; a5  - head of current animation script
	; a6  - tail of current animation script
	; a8  - player object
	; a9  - motion count accumulator
	; a10 - direction of motion

 SUBRP	our_hero

	;create the player object
	movi	[#start_x,0],a0
	movi	[#start_y,0],a1
	movi	man_d1,a2
	clr	a3
	movi	DMAWNZ,a4
	movi	CLSPLYR|TYPPLYR,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	;set the global pointer
	move	a8,@player_object,L

	; initiailize direction of motion
	clr	a10

#not_done
	PUSHP	a4,a5,a6
	SLEEPK	1
	PULLP	a4,a5,a6

	; move him first
	callr	#move_player

	; change his animation frame, if neccesary
	callr	#change_frame

	jruc	#not_done

#player_dead
	;kill the gun process
	move	@gun_proc,a0,L
	calla	KILL

	movi	BULLET_PID,a0
	calla	KIL1C

	movi	GRUNT_PID,a0
	calla	KIL1C

	movi	HULK_PID,a0
	calla	KIL1C

	movi	HUMAN_PID,a0
	calla	KIL1C

	movi	SPHEREOID_PID,a0
	calla	KIL1C

	movi	ENFORCER_PID,a0
	calla	KIL1C

	movi	SPARK_PID,a0
	calla	KIL1C

	movi	QUARK_PID,a0
	calla	KIL1C

	movi	TANK_PID,a0
	calla	KIL1C

	movi	SHELL_PID,a0
	calla	KIL1C

	calla	STOPOBJS

	;switch frames
	movi	robo_dead,a0,L
	calla	civanic

	;death sound
	movi	RS_DIE,a0
	calla	robo_sound

	SLEEP	120
	movk	1,a14
	move	a14,@player_dead,W

	DIE

******************************************************************************
*
*	player move routine
*

 SUBRP	#move_player

	clr	a0
	calla	get_stick_val_cur
	btst	JOYDN,a0
	jrnz	#move_down
	btst	JOYUP,a0
	jrnz	#move_up
	btst	JOYRGT,a0
	jrnz	#move_right
	btst	JOYLFT,a0
	jrnz	#move_left
	jruc	#no_move

#move_down
	btst	JOYRGT,a0
	jrnz	#move_downright
	btst	JOYLFT,a0
	jrnz	#move_downleft

	;increment Y
	move	*a8(OYPOS),a14,W
	inc	a14
	move	a14,*a8(OYPOS),W
	jruc	#move_done

#move_up
	btst	JOYRGT,a0
	jrnz	#move_upright
	btst	JOYLFT,a0
	jrnz	#move_upleft

	;decrement Y
	move	*a8(OYPOS),a14,W
	dec	a14
	move	a14,*a8(OYPOS),W
	jruc	#move_done

#move_right
	;increment X
	move	*a8(OXPOS),a14,W
	inc	a14
	move	a14,*a8(OXPOS),W
	jruc	#move_done

#move_left
	;decrement X
	move	*a8(OXPOS),a14,W
	dec	a14
	move	a14,*a8(OXPOS),W
	jruc	#move_done

#move_upright
	; decrement Y and increment X
	move	*a8(OYPOS),a14,W
	dec	a14
	move	a14,*a8(OYPOS),W
	move	*a8(OXPOS),a14,W
	inc	a14
	move	a14,*a8(OXPOS),W
	jruc	#move_done

#move_upleft
	; decrement Y and decrement X
	move	*a8(OYPOS),a14,W
	dec	a14
	move	a14,*a8(OYPOS),W
	move	*a8(OXPOS),a14,W
	dec	a14
	move	a14,*a8(OXPOS),W
	jruc	#move_done

#move_downright
	; increment Y and increment X
	move	*a8(OYPOS),a14,W
	inc	a14
	move	a14,*a8(OYPOS),W
	move	*a8(OXPOS),a14,W
	inc	a14
	move	a14,*a8(OXPOS),W
	jruc	#move_done

#move_downleft
	; increment Y and decrement X
	move	*a8(OYPOS),a14,W
	inc	a14
	move	a14,*a8(OYPOS),W
	move	*a8(OXPOS),a14,W
	dec	a14
	move	a14,*a8(OXPOS),W
	jruc	#move_done

#move_done
	; check bounds
	move	*a8(OXPOS),a14,W
	cmpi	#low_x,a14,W
	jrgt	#not_lowx
	; too low on x
	inc	a14
	move	a14,*a8(OXPOS),W

#not_lowx
	cmpi	#high_x,a14,W
	jrle	#not_highx
	; too high on x
	dec	a14
	move	a14,*a8(OXPOS),W

#not_highx

	move	*a8(OYPOS),a14,W
	cmpi	#low_y,a14,W
	jrgt	#not_lowy
	; too low on y
	inc	a14
	move	a14,*a8(OYPOS),W

#not_lowy
	cmpi	#high_y,a14,W
	jrle	#not_highy
	; too high on y
	dec	a14
	move	a14,*a8(OYPOS),W

#not_highy
#no_move

#done_moving
	rets

******************************************************************************
*
*	player animation routine
*


 SUBRP	#change_frame
	;reg use
	; a0  scratch
	; a1  sctatch
	; a3  new direction of motion
	; a10 old direction of motion - update

	clr	a0
	clr	a2
	calla	get_stick_val_cur
	move	a0,a3

	cmp	a0,a10
	jreq	#same_direction
	jruc	#new_direction

#new_direction
	; start a new script.  first use the joystick bits to compute an
	; offset into the script table.
	X32	a0		;multiply by 32
	addi	#script_map,a0	;add the address of the script table
	move	*a0,a0,L	;get the address of the script

	; get the tail and head of the image list for this script
	move	*a0+,a6,L
	move	a0,a5

	;a5 now points to the first image in the script.  change to it.
	move	*a5,a0,L
	calla	civanic

	;set the new direction thingie and script pointer
	move	a3,a10
	move	a5,a4

	;set the motion count
	movi	#motion_count,a9
	jruc	#done_changing

#same_direction
	;check the motion count
	dec	a9
	jrnz	#done_changing

	;reset the motion count
	movi	#motion_count,a9

	;increment the pointer, wrap if neccesary
	addi	20h,a4
	cmp	a4,a6
	jrne	#no_wrap
	move	a5,a4

#no_wrap
	;a4 is the new image.  change to it.
	move	*a4,a0,L
	calla	civanic

	jruc	#done_changing

#done_changing
	rets


******************************************************************************
*
*	player collision routines
*

 SUBR	player_die
	PUSH	a1,a7

	;we hit some kind of bad guy and are dead
	movi	CLSDEAD,a14
	move	a14,*a8(OID),W
	move	*a8(OPLINK),a0,L
	movi	DEADPLAYER_PID,a1
	movi	#player_dead,a7
	calla	XFERPROC

	PULL	a1,a7
	rets


******************************************************************************
*
*	player configuration data
*

;start position
#start_x	equ	197
#start_y	equ	123

; motion boundaries
#low_x		equ	53
#high_x		equ	347-7
#low_y		equ	45
#high_y		equ	231-12

;motion count - controls animation speed
#motion_count	equ	2	;there will be trouble if this is zero

; walking animation scripts
#ani_holdstill
	.long	#ani_holdstillx
	.long	man_d1
#ani_holdstillx

#ani_walkup
	.long	#ani_walkupx
	.long	man_u1
	.long	man_u2
	.long	man_u1
	.long	man_u3
#ani_walkupx

#ani_walkdown
	.long	#ani_walkdownx
	.long	man_d1
	.long	man_d2
	.long	man_d1
	.long	man_d3
#ani_walkdownx

#ani_walkright
	.long	#ani_walkrightx
	.long	man_r1
	.long	man_r2
	.long	man_r1
	.long	man_r3
#ani_walkrightx

#ani_walkleft
	.long	#ani_walkleftx
	.long	man_l1
	.long	man_l2
	.long	man_l1
	.long	man_l3
#ani_walkleftx

#ani_bad
	.long	#ani_badx
	.long	robo_bad
#ani_badx

; direction - script mappings: use AND combo of joy bits as index
#script_map
	.long	#ani_holdstill
	.long	#ani_walkup
	.long	#ani_walkdown
	.long	#ani_bad
	.long	#ani_walkleft
	.long	#ani_walkleft
	.long	#ani_walkleft
	.long	#ani_bad
	.long	#ani_walkright
	.long	#ani_walkright
	.long	#ani_walkright
	.long	#ani_bad
	.long	#ani_bad
	.long	#ani_bad
	.long	#ani_bad
	.long	#ani_bad
#script_mapx


#*****************************************************************************
*
*	player gun process
*

	;reg use
	;a9  time till next shot is allowed

 SUBRP	player_gun

	clr	a9
	jruc	#sleep

#check_shot
	movk	1,a0
	calla	get_stick_val_cur
	jrz	#sleep			;no shot

	;fire in the indicated direction
	move	a0,a10
	CREATE	BULLET_PID,bullet
	movi	#rate_of_fire,a9

	;shoot sound
	movi	RS_SHOOT,a0
	callr	robo_sound

	jruc	#sleep
	
#too_soon
	dec	a9
	jruc	#sleep

#sleep
	SLEEPK	1
	move	a9,a9
	jrnz	#too_soon
	jruc	#check_shot

#done
	DIE

#rate_of_fire	equ	6	;min ticks between shots


#*****************************************************************************
*
*	player bullet process
*

	;reg use
	; a4 velocity accumulator (used to pick the correct bullet)
	; a5 vert indicator
	; a8 bullet object
	;a10 (in) stick bits

 SUBRP	bullet

	;create a bullet object
	movi	[500,0],a0
	clr	a1
	movi	bullet_hrz,a2
	clr	a3
	movi	DMAWNZ,a4
	movi	CLSPLYR|TYPBULLET,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	;set the speed and start position
	move	@player_object,a9,L
	clr	a4
	clr	a5
	move	*a9(OXPOS),a0,W
	addk	#bstart_xoff,a0
	move	a0,*a8(OXPOS),W
	move	*a9(OYPOS),a0,W
	addk	#bstart_yoff,a0
	move	a0,*a8(OYPOS),W

	btst	JOYRGT,a10
	jrz	#not_right
	move	*a8(OXPOS),a14,W	;pos
	addi	#bstart_radj,a14
	move	a14,*a8(OXPOS),W
	movi	#bullet_speed,a0	;speed
	move	a0,*a8(OXVEL),L
	inc	a4

#not_right

	btst	JOYLFT,a10
	jrz	#not_left
	move	*a8(OXPOS),a14,W	;pos
	addi	#bstart_ladj,a14
	move	a14,*a8(OXPOS),W
	movi	-#bullet_speed,a0	;speed
	move	a0,*a8(OXVEL),L
	dec	a4

#not_left

	btst	JOYUP,a10
	jrz	#not_up
	move	*a8(OYPOS),a14,W	;pos
	addi	#bstart_uadj,a14
	move	a14,*a8(OYPOS),W
	movi	-#bullet_speed,a0	;speed
	move	a0,*a8(OYVEL),L
	dec	a4
	inc	a5

#not_up

	btst	JOYDN,a10
	jrz	#not_down
	move	*a8(OYPOS),a14,W	;pos
	addi	#bstart_dadj,a14
	move	a14,*a8(OYPOS),W
	movi	#bullet_speed,a0	;speed
	move	a0,*a8(OYVEL),L
	inc	a4
	inc	a5

#not_down

	;set the image
	movi	bullet_hrz,a0
	move	a5,a5
	jrz	#horiz
	movi	bullet_vrt,a0
#horiz

	;vert/horz is set.  check for diagonal instead
	cmpi	1,a4
	jreq	#image_set
	cmpi	-1,a4
	jreq	#image_set

	;it's a diagonal.  if a4 is 0, use frontslash
	move	a4,a4
	jrz	#front_slash
	movi	bullet_bck,a0
	jruc	#image_set

#front_slash
	movi	bullet_fnt,a0

#image_set
	calla	civanic

#loop
	callr	bounds_check
	move	a0,a0
	jrnz	#hit_wall
	SLEEPK	1
	jruc	#loop

#hit_wall
	;zoinks!  We've hit a wall. back up to be flush against it.
	; a2 holds the number of pixels we have to back up.

	;well, we can overlap on the wall a LITTLE.  say, 2 pixels.
	subk	2,a2

	move	*a8(OXVEL),a0,L
	jrz	#y_adjust
	jrn	#neg_xvel
	move	*a8(OXPOS),a0,W
	sub	a2,a0
	move	a0,*a8(OXPOS),W
	jruc	#y_adjust
#neg_xvel
	move	*a8(OXPOS),a0,W
	add	a2,a0
	move	a0,*a8(OXPOS),W

#y_adjust
	move	*a8(OYVEL),a0,L
	jrz	#kill_bullet
	jrn	#neg_yvel
	move	*a8(OYPOS),a0,W
	sub	a2,a0
	move	a0,*a8(OYPOS),W
	jruc	#kill_bullet
#neg_yvel
	move	*a8(OYPOS),a0,W
	add	a2,a0
	move	a0,*a8(OYPOS),W

#kill_bullet
	SLEEPK	1
	calla	DELOBJA8
	DIE


******************************************************************************
*
* player bullet collision routines
*

 SUBR	bullet_die
	PUSH	a1,a7,a9,a10,a11

	;we hit some kind of bad guy and are stopped.
	movi	CLSDEAD,a14
	move	a14,*A8(OID)
	move	*a8(OPLINK),a0,L
	movi	DEADBULLET_PID,a1
	movi	#kill_bullet,a7
	calla	XFERPROC

	PULL	a1,a7,a9,a10,a11
	rets


#bullet_speed	equ	00080000h	;pixels per frame

#low_x		equ	53
#high_x		equ	346
#low_y		equ	45
#high_y		equ	230

;hero anim point is top left.  bullet anim point is center.  use these to
; adjust the starting position of the bullet.
; No.  The bullet anim points are gone now.  Unk.
#bstart_xoff	equ	3
#bstart_yoff	equ	5

#bstart_radj	equ	7
#bstart_ladj	equ	-13
#bstart_uadj	equ	-14
#bstart_dadj	equ	8


#*****************************************************************************
******************************************************************************
******************************************************************************
*
*	GRUNT SECTION
*

	;reg use
	; a0 (in) # of grunts
	; a1 scratch
	; a2 (in) initial speed

 SUBRP	make_grunts

	move	a0,a0
	jrz	#done

#another_grunt
	PUSHP	a0

#get_pos
	movi	#max_x-#min_x,a0
	calla	RNDRNG0
	move	a0,a9
	movi	#max_y-#min_y,a0
	calla	RNDRNG0
	move	a0,a10

	addi	#min_x,a9
	addi	#min_y,a10

	cmpi	#mid_x1,a9
	jrle	#place_grunt
	cmpi	#mid_x2,a9
	jrge	#place_grunt
	cmpi	#mid_y1,a10
	jrle	#place_grunt
	cmpi	#mid_y2,a10
	jrge	#place_grunt
	jruc	#get_pos

#place_grunt
	;assign a random starting position
	move	a2,a11
	CREATE	GRUNT_PID,grunt
	PULLP	a0
	dsj	a0,#another_grunt

#done
	rets


#min_x	equ	53	;grunt start outer boundaries
#max_x	equ	347-9
#min_y	equ	45
#max_y	equ	231-13

#mid_x1	equ	200-60	;grunt start inner boundaries
#mid_x2	equ	200+60
#mid_y1	equ	138-60
#mid_y2	equ	138+60


#*****************************************************************************
*
*	grunt process
*

	STRUCTPD
	WORD	#ACCEL_TIMER	;UHW accelerator count
	LONG	#DEATH_SEQUENCE	;UHL anim to use when dying
				;    (set by coll routines)

	;reg use
	; a8 object handle
	; a9 (in)  starting x
	; a9 (use) ticks between moves
	;a10 (in)  starting y
	;a10 (use) ticks until next move
	;a11 (in)  initial speed
	;a11 (use) frame count

 SUBRP	grunt

	;increment the badguy count
	move	@live_badguys,a14,W
	inc	a14
	move	a14,@live_badguys,W

	;create a grunt object
	move	a9,a0
	sla	16,a0
	move	a10,a1
	sla	16,a1
	movi	grunt_1,a2
	clr	a3
	movi	DMAWNZ,a4
	movi	CLSENMY|TYPGRUNT,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	;initialize move timer
	move	a11,a9

	;initialize time till next move
	move	a9,a0
	calla	RNDRNG0
	add	a11,a0
	move	a0,a10

	;initialize accel counter
	movi	#acceleration,a14
	move	a14,*a13(#ACCEL_TIMER),W

	;initialize frame counter
	clr	a11

#loop
	move	*a13(#ACCEL_TIMER),a14,W
	dec	a14
	jrnz	#no_accel

	movi	#acceleration,a14
	cmpi	#top_speed,a9
	jreq	#no_accel
	dec	a9

#no_accel
	move	a14,*a13(#ACCEL_TIMER),W
	SLEEPK	1

	dsj	a10,#loop
	callr	#move_grunt
	move	a9,a10
	jruc	#loop

#die
	;we've croaked
	;decrement the badguy count
	move	@live_badguys,a14,W
	dec	a14
	move	a14,@live_badguys,W

	;set up the animation
	move	*a13(#DEATH_SEQUENCE),a9,L
	move	*a8(OCTRL),a0

#dieloop
	move	*a9+,a0,L
	jrz	#dead_n_buried
	calla	civanic
	sleepk	#death_speed
	jruc	#dieloop

#dead_n_buried
	calla	DELOBJA8

	DIE

******************************************************************************
*
*	grunt move routine
*

 SUBRP	#move_grunt
	move	@player_object,a14,L

	;move in X
	move	*a14(OXPOS),a0,W
	move	*a8(OXPOS),a1,W
	sub	a1,a0
	jrz	#done_movex
	jrn	#move_left
	jruc	#move_right

#move_left
	move	*a8(OXPOS),a1,W
	addi	-#xmotion_inc,a1
	move	a1,*a8(OXPOS),W
	jruc	#done_movex

#move_right
	move	*a8(OXPOS),a1,W
	addi	#xmotion_inc,a1
	move	a1,*a8(OXPOS),W
	jruc	#done_movex

#done_movex

	move	*a14(OYPOS),a0,W
	move	*a8(OYPOS),a1,W
	sub	a1,a0
	jrz	#done_movey
	jrn	#move_up
	jruc	#move_down

#move_up
	move	*a8(OYPOS),a1,W
	addi	-#ymotion_inc,a1
	move	a1,*a8(OYPOS),W
	jruc	#done_movey

#move_down
	move	*a8(OYPOS),a1,W
	addi	#ymotion_inc,a1
	move	a1,*a8(OYPOS),W
	jruc	#done_movey

#done_movey

	;step through the animation
	inc	a11
	cmpi	4,a11
	jrne	#no_wrap
	clr	a11

#no_wrap
	move	a11,a14
	X32	a14
	addi	#walk_script,a14
	move	*a14,a0,L
	calla	civanic

	;sound
	movi	RS_GRUNT,a0
	callr	robo_sound
	rets


******************************************************************************
*
*	grunt collision routines
*

 SUBR	grunt_shot
	;hit by player gunfire
	PUSH	a1,a7

	;jeepers.  we're dead.
	movi	CLSDEAD,a14
	move	a14,*a8(OID),W

	move	*a0(OXVEL),a14,L
	jrz	#vert_bullet
	move	*a0(OYVEL),a1,L
	jrz	#horz_bullet

	add	a1,a14
	jrz	#diag_13
	jruc	#diag_24

#horz_bullet
	movi	#die_vert,a14
	jruc	#death_set
#vert_bullet
	movi	#die_horz,a14
	jruc	#death_set
#diag_13
	movi	#die_diag24,a14
	jruc	#death_set
#diag_24
	movi	#die_diag13,a14
	jruc	#death_set

#death_set

	move	*a8(OPLINK),a0,L
	move	a14,*a0(#DEATH_SEQUENCE),L
	movi	DEADGRUNT_PID,a1
	movi	#die,a7

	move	*a0(PA9),a9,L
	move	*a0(PA10),a10,L
	calla	XFERPROC

	movi	#grunt_points,a0
	callr	score_points

	;die sound
	movi	RS_HIT,a0
	calla	robo_sound

	PULL	a1,a7
	rets


 SUBR	grunt_die
	;hit a mine or something

	PUSH	a1,a7

	movi	CLSDEAD,a14
	move	a14,*a8(OID),W
	move	*a8(OPLINK),a0,L
	movi	#die_vert,a14
	move	a14,*a0(#DEATH_SEQUENCE),L
	movi	DEADGRUNT_PID,a1
	movi	#die,a7
	move	*a0(PA9),a9,L
	move	*a0(PA10),a10,L
	calla	XFERPROC

	PULL	a1,a7
	rets


******************************************************************************
*
*	grunt configuration data
*


#walk_script
	.long	grunt_1
	.long	grunt_2
	.long	grunt_1
	.long	grunt_3
#walk_scriptx

#die_vert
	.long	grunt_xv1
	.long	grunt_xv2
	.long	grunt_xv3
	.long	grunt_xv4
	.long	0
#die_vertx

#die_horz
	.long	grunt_xh1
	.long	grunt_xh2
	.long	grunt_xh3
	.long	grunt_xh4
	.long	0
#die_horzx

#die_diag13
	.long	grunt_xdf1
	.long	grunt_xdf2
	.long	grunt_xdf3
	.long	grunt_xdf4
	.long	0
#die_diag13x

#die_diag24
	.long	grunt_xdb1
	.long	grunt_xdb2
	.long	grunt_xdb3
	.long	grunt_xdb4
	.long	0
#die_diag24x

#death_speed	equ	3		;death seq anim speed

#acceleration	equ	100		;decrement motion clock every X cycles
#top_speed	equ	3		;as fast as they get
#xmotion_inc	equ	0004h
#ymotion_inc	equ	0004h

#grunt_points	equ	100		;points for killing a grunt

#*****************************************************************************
******************************************************************************
******************************************************************************
*
*	POST SECTION
*
	;reg use
	; a0 - (in) # of posts to create
	; a1 - (in) type (0-8)
	; a2 - (in) color (0-F)

 SUBRP	make_posts

	move	a0,a9		;move the inputs to safer spots
	jrz	#done

	move	a1,a10		;type

	move	a2,a11		;color
	sla	8,a11
	or	a2,a11

#another_post
#get_pos
	movi	#max_y-#min_y,a0
	calla	RNDRNG0
	move	a0,a2			;hide a0
	movi	#max_x-#min_x,a0
	calla	RNDRNG0
	move	a2,a1			;put it back

	addi	#min_x,a0
	addi	#min_y,a1

	cmpi	#mid_x1,a0
	jrle	#place_post
	cmpi	#mid_x2,a0
	jrge	#place_post
	cmpi	#mid_y1,a1
	jrle	#place_post
	cmpi	#mid_y2,a1
	jrge	#place_post
	jruc	#get_pos

#place_post
	sla	16,a0			;X pos
	sla	16,a1			;Y pos

	;create the post object
	move	a10,a14
	X32	a14
	addi	#post_types,a14
	move	*a14,a14,L
	move	*a14,a2,L		;DON'T advance

	clr	a3
	movi	DMACNZ,a4
	movi	CLSNEUT|TYPPOST,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	move	a10,*a8(OMISC),W	;stuff the type in the object

	move	a11,*a8(OCONST),W

	movi	robo_p,a0
	calla	pal_getf
	move	a0,*a8(OPAL),W

	dsj	a9,#another_post

#done
	rets


#min_x	equ	53	;post start outer boundaries
#max_x	equ	347-17
#min_y	equ	45
#max_y	equ	231-10

#mid_x1	equ	200-50	;post start inner boundaries
#mid_x2	equ	200+50
#mid_y1	equ	138-50
#mid_y2	equ	138+50


******************************************************************************
*
*	post collision routines
*

 SUBR	post_die

	movi	CLSDEAD,a14
	move	a14,*a8(OID),W
	CREATE	DEADPOST_PID,kill_post

	rets


	;reg use
	; a8 - * image
	; a9 - anim pointer

 SUBR	kill_post

	move	*a8(OMISC),a0,W
	X32	a0
	addi	#post_types,a0
	move	*a0,a9,L
	move	*a8(OCTRL),a14,W
	xori	DMACNZ,a14
	ori	DMAWNZ,a14
	move	a14,*a8(OCTRL),W
#kploop
	move	*a9+,a0,L
	jrz	#kpdone
	calla	civanic
	SLEEPK	#die_speed
	jruc	#kploop

#kpdone
	calla	DELOBJA8
	DIE


#die_speed	equ	3

#post_types
	.long	#star		;0
	.long	#crystal	;1
	.long	#diamond	;2
	.long	#square		;3
	.long	#rectangle	;4
	.long	#R2084		;5
	.long	#pcube		;6
	.long	#spiral		;7
	.long	#triangle	;8
	.long	0
#post_typesx

#star
	.long	star_1,star_2,star_3,0

#crystal
	.long	crystal_1,crystal_2,crystal_3,0

#diamond
	.long	diamond_1,diamond_2,diamond_3,0

#square
	.long	square_1,square_2,square_3,0

#rectangle
	.long	rectangle_1,rectangle_2,rectangle_3,0

#R2084
	.long	R2084_1,R2084_2,R2084_3,0

#pcube
	.long	pcube_1,pcube_2,pcube_3,0

#spiral
	.long	spiral_1,spiral_2,spiral_3,0

#triangle
	.long	triangle_1,triangle_2,triangle_3,0


#*****************************************************************************
******************************************************************************
******************************************************************************
*
*	HUMAN SECTION
*

	.bss	humans_saved,	16

	;reg use
	; a0 # of moms
	; a1 # of dads
	; a2 # of kids 

 SUBRP	make_humans

	;initialize the savecount
	clr	a14
	move	a14,@humans_saved,W

	;first make the moms
	move	a0,a0
	jrz	#skip_moms
#mom_loop
	PUSHP	a0,a1,a2
	callr	#rand_position
	movi	ROBJ_MOM,a9
	CREATE	HUMAN_PID,human
	PULLP	a0,a1,a2
	dsj	a0,#mom_loop

#skip_moms

	;dads
	move	a1,a1
	jrz	#skip_dads
#dad_loop
	PUSHP	a1,a2
	callr	#rand_position
	movi	ROBJ_DAD,a9
	CREATE	HUMAN_PID,human
	PULLP	a1,a2
	dsj	a1,#dad_loop

#skip_dads

	;kids
	move	a2,a2
	jrz	#skip_kids
#kid_loop
	PUSHP	a2
	callr	#rand_position
	movi	ROBJ_KID,a9
	CREATE	HUMAN_PID,human
	PULLP	a2
	dsj	a2,#kid_loop

#skip_kids
	rets


	;reg use
	; no input
	;a10 - (ret) an X val
	;a11 - (ret) a Y val

 SUBRP #rand_position
	movi	#max_x-#min_x,a0
	calla	RNDRNG0
	move	a0,a10
	addi	#min_x,a10

	movi	#max_y-#min_y,a0
	calla	RNDRNG0
	move	a0,a11
	addi	#min_y,a11

	rets


******************************************************************************
*
*	human process
*
	STRUCTPD
	LONG	#HITPOST	;UHL post we've hit

	;reg use
	; a8 - hObject
	; a9 - (in)  OID
	; a9 - (use) image table address (#mom_table, #dad_table...)
	;a10 - (in)  x
	;a10 - (use) direction of motion (1-8)
	;a11 - (in)  y
	;a11 - (use) frame index (0-3)


 SUBRP	human

	cmpi	ROBJ_MOM,a9
	jreq	#init_mom
	cmpi	ROBJ_DAD,a9
	jreq	#init_dad
	cmpi	ROBJ_KID,a9
	jreq	#init_kid

	LOCKUP	;bad objid

#init_mom
	movi	#mom_table,a9
	jruc	#make_obj

#init_dad
	movi	#dad_table,a9
	jruc	#make_obj

#init_kid
	movi	#kid_table,a9
	jruc	#make_obj

#make_obj
	;cweate a widdle people object
	move	a10,a0
	sla	16,a0
	move	a11,a1
	sla	16,a1
	move	*a9(#walk_down),a2,L
	clr	a3
	movi	DMAWNZ,a4
	movi	CLSNEUT|TYPHUMAN,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	;choose a direction of motion
	movi	7,a0
	calla	RNDRNG0
	inc	a0
	move	a0,a10

	;set the frame index
	movi	3,a11
	callr	#advance_frame

#move_loop
	SLEEPK	#sleep_time
	callr	#rand_dirchange
	callr	#move_onestep
	move	a0,a0
	jrnz	#hit_wall
	callr	#advance_frame
	jruc	#move_loop

#hit_wall
	;sleep first because: If you move and bump into both a wall and a
	; post at the same time (could happen), and then you immediately
	; reverse direction, you'll then get flipped AGAIN when you hit
	; the post and get forwarded right through the wall.  yuck.  so
	; instead when you hit a wall, wait a frame and let the post
	; collisions sort themselves out, THEN change direction.
	SLEEPK	1
	callr	#reverse_direction
	callr	#advance_frame
	jruc	#move_loop

#hit_post
	callr	post_adjust
	callr	#advance_frame
	jruc	#move_loop

#saved
	;sound
	movi	RS_RESCUE,a0
	callr	robo_sound

	;increment the save count
	move	@humans_saved,a14,W
	inc	a14
	move	a14,@humans_saved,W

	cmpi	5,a14
	jrle	#no_cap
	movi	5,a14
#no_cap
	dec	a14

	PUSH	a14
	sla	4,a14
	addi	#score_table,a14
	move	*a14,a0,W
	callr	score_points
	PULL	a14

	X32	a14
	addi	#saved_table,a14
	move	*a14,a0,L
	calla	civanic

	SLEEP	120
	calla	DELOBJA8
	jruc	#done

#killed
	movi	skull,a0
	calla	civanic

	SLEEP	120
	calla	DELOBJA8
;	jruc	#done		;fall through

#done
	DIE


******************************************************************************
* Human has bounced into or started inside a post.  Make it better.
* Do this by reversing the direction of the human and moving it forward
* in the new direction until it's clear of the post.
*

	;reg use
	; a0 - X overlap
	; a1 - Y overlap

 SUBRP	post_adjust
	PUSH	a0,a1,a2,a3,a7

	move	*a13(#HITPOST),a7,L

	callr	#reverse_direction

	;calculate degree of X and Y overlap
	move	a10,a2
	X32	a2
	addi	#walk_increments,a2
	move	*a2+,a3,W	;y vel
	jrn	#yvel_neg
	jrz	#yvel_zero

#yvel_pos
	move	*a7(OYPOS),a1
	move	*a7(OSIZEY),a14
	add	a14,a1
	move	*a8(OYPOS),a14
	sub	a14,a1
	jruc	#do_xvel
#yvel_zero
	movi	100h,a1
	jruc	#do_xvel
#yvel_neg
	move	*a8(OYPOS),a1
	move	*a8(OSIZEY),a14
	add	a14,a1
	move	*a7(OYPOS),a14
	sub	a14,a1
;	jruc	#do_xvel

#do_xvel
	move	*a2,a3,W	;x vel
	jrn	#xvel_neg
	jrz	#xvel_zero

#xvel_pos
	move	*a7(OXPOS),a0
	move	*a7(OSIZEX),a14
	add	a14,a0
	move	*a8(OXPOS),a14
	sub	a14,a0
	jruc	#ovlap_done
#xvel_zero
	movi	100h,a0
	jruc	#ovlap_done
#xvel_neg
	move	*a8(OXPOS),a0
	move	*a8(OSIZEX),a14
	add	a14,a0
	move	*a7(OXPOS),a14
	sub	a14,a0
;	jruc	#ovlap_done

#ovlap_done
	;a0 and a1 are the X and Y overlaps, respectively.  We need only
	; worry about the smallest of the two and move that many steps.  Note
	; that if velocity in a given direction is zero, the overlap is
	; set to some outrageously large value so that the other direction
	; is all that counts.
	cmp	a1,a0
	jrle	#low_set
	move	a1,a0
#low_set
	;a0 is now the smallest.
	move	a0,a1
	move	a10,a2
	X32	a2
	addi	#walk_increments,a2
	move	*a2+,a3,W	;y vel
	mpys	a3,a1
	move	*a2,a3,W	;x vel
	mpys	a0,a3
	move	a3,a0

	;a0 and a1 now hold X and Y adjustments, respectively.
	move	*a8(OXPOS),a14
	add	a0,a14
	move	a14,*a8(OXPOS)
	move	*a8(OYPOS),a14
	add	a1,a14
	move	a14,*a8(OYPOS)
	
	PULL	a0,a1,a2,a3,a7
	rets


******************************************************************************
*
*	human movement/animation routine
*

	;reg use
	; a0 - scratch
	; a0 (out) - walls hit (0-2)
	; a1 - scratch
	; a8 - (in)  hObject
	; a9 - (in)  image table address (#mom_table, #dad_table...)
	;a10 - (in)  direction of motion (1-8)
	;a11 - (in)  frame index (0-3)

 SUBRP	#move_onestep

	;move the object
	move	a10,a1
	X32	a1
	addi	#walk_increments,a1
	move	*a1+,a14,W
	move	*a8(OYPOS),a0,W
	add	a14,a0
	move	a0,*a8(OYPOS),W
	move	*a1+,a14,W
	move	*a8(OXPOS),a0,W
	add	a14,a0
	move	a0,*a8(OXPOS),W

	clr	a1
	move	*a8(OXPOS),a0,W

	cmpi	#min_x,a0
	jrge	#not_lowx

	;low x
	inc	a1
	movi	#min_x,a0
	move	a0,*a8(OXPOS),W

#not_lowx
	cmpi	#max_x,a0
	jrle	#not_highx

	;high x
	inc	a1
	movi	#max_x,a0
	move	a0,*a8(OXPOS),W

#not_highx

	move	*a8(OYPOS),a0,W

	cmpi	#min_y,a0
	jrge	#not_lowy

	;low y
	inc	a1
	movi	#min_y,a0
	move	a0,*a8(OYPOS),W

#not_lowy
	cmpi	#max_y,a0
	jrle	#not_highy

	;high y
	inc	a1
	movi	#max_y,a0
	move	a0,*a8(OYPOS),W

#not_highy
	move	a1,a0
	rets


******************************************************************************
* Changes direction one time in #dirchange_chance.
*

 SUBRP	#rand_dirchange

	;1 chance in #dirchange_chance of spontaneously switching direction
	movi	#dirchange_chance,a0
	calla	RNDRNG0
	move	a0,a0
	jrnz	#dirchange_done
	movi	7,a0
	calla	RNDRNG0
	inc	a0
	move	a0,a10

#dirchange_done
	rets


******************************************************************************
* Reverses direction
*

 SUBRP	#reverse_direction

	;reverse direction of motion
	subi	4,a10
	jrp	#rd_done
	addi	8,a10
#rd_done
	rets

******************************************************************************
* Advances the frame
*

 SUBRP	#advance_frame

	;advance the frame and set the new image
	inc	a11
	cmpi	4,a11
	jrne	#no_wrap
	;wraparound.  reset to start
	clr	a11

#no_wrap
	;calculate the next frame
	move	a9,a0
	move	a10,a1
	sla	4,a1		;mult by 10h
	addi	#motion_table,a1

	;a1 now points to one of the entries in #motion table
	move	*a1,a1,W
	add	a1,a0

	;a0 now points to an entry in #xxx_table
	move	a11,a1
	X32	a1		;mult by 20h
	add	a1,a0
	move	*a0,a0,L

	calla	civanic

	rets


******************************************************************************
*
*	human collision routines
*

 SUBR	human_saved
	PUSH	a1,a7

	;change the obj id
	movi	CLSDEAD,a14
	move	a14,*a8(OID),W
	move	*a8(OPLINK),a0,L
	movi	SAVEDHUMAN_PID,a1
	movi	#saved,a7
	calla	XFERPROC

	PULL	a1,a7
	rets

 SUBR	human_killed
	PUSH	a1,a7

	movi	CLSDEAD,a14
	move	a14,*a8(OID),W
	move	*a8(OPLINK),a0,L
	movi	DEADHUMAN_PID,a1
	movi	#killed,a7
	calla	XFERPROC

	PULL	a1,a7
	rets


 SUBR	human_hitpost
	PUSH	a1,a7

	move	a0,a1
	move	*a8(OPLINK),a0,L
	move	a1,*a0(#HITPOST),L
	move	*a0(PA8),a8,L
	move	*a0(PA9),a9,L
	move	*a0(PA10),a10,L
	move	*a0(PA11),a11,L
	movi	HUMAN_PID,a1
	movi	#hit_post,a7
	calla	XFERPROC

	PULL	a1,a7
	rets

******************************************************************************
*
*	human configuration data
*


#min_x	equ	53	;human start/motion outer boundaries
#max_x	equ	347-11
#min_y	equ	45
#max_y	equ	231-13

#sleep_time	equ	7
#x_step		equ	1
#y_step		equ	1

#dirchange_chance	equ	40

#walk_increments
	.word	0,0			;because direction is 1-8, not 0-7
	.word	-#y_step,0
	.word	-#y_step,#x_step
	.word	0,#x_step
	.word	#y_step,#x_step
	.word	#y_step,0
	.word	#y_step,-#x_step
	.word	0,-#x_step
	.word	-#y_step,-#x_step
#walk_incrementsx

#motion_table
	.word	0			;because direction is 1-8, not 0-7
	.word	#walk_up
	.word	#walk_right
	.word	#walk_right
	.word	#walk_right
	.word	#walk_down
	.word	#walk_left
	.word	#walk_left
	.word	#walk_left
#motion_tablex

;image table direction offsets
#walk_left	equ	0000h
#walk_right	equ	#walk_left + (4 * 20h)
#walk_up	equ	#walk_right + (4 * 20h)
#walk_down	equ	#walk_up + (4 * 20h)

#score_table
	.word	1000,2000,3000,4000,5000
#score_tablex

;image tables
#mom_table
	.long	mom_l1
	.long	mom_l2
	.long	mom_l1
	.long	mom_l3

	.long	mom_r1
	.long	mom_r2
	.long	mom_r1
	.long	mom_r3

	.long	mom_u1
	.long	mom_u2
	.long	mom_u1
	.long	mom_u3

	.long	mom_d1
	.long	mom_d2
	.long	mom_d1
	.long	mom_d3
#mom_tablex

#dad_table
	.long	dad_l1
	.long	dad_l2
	.long	dad_l1
	.long	dad_l3

	.long	dad_r1
	.long	dad_r2
	.long	dad_r1
	.long	dad_r3

	.long	dad_u1
	.long	dad_u2
	.long	dad_u1
	.long	dad_u3

	.long	dad_d1
	.long	dad_d2
	.long	dad_d1
	.long	dad_d3
#dad_tablex

#kid_table
	.long	kid_l1
	.long	kid_l2
	.long	kid_l1
	.long	kid_l3

	.long	kid_r1
	.long	kid_r2
	.long	kid_r1
	.long	kid_r3

	.long	kid_u1
	.long	kid_u2
	.long	kid_u1
	.long	kid_u3

	.long	kid_d1
	.long	kid_d2
	.long	kid_d1
	.long	kid_d3
#kid_tablex

#saved_table
	.long	one_k
	.long	two_k
	.long	three_k
	.long	four_k
	.long	five_k
#saved_tablex


#*****************************************************************************
******************************************************************************
******************************************************************************
*
*	HULK SECTION
*

	;reg use
	; a0 - (in) # of hulks

 SUBRP	make_hulks

	move	a0,a0
	jrz	#done

#another_hulk
	PUSHP	a0

#get_pos
	movi	#max_x-#min_x,a0
	calla	RNDRNG0
	move	a0,a9
	movi	#max_y-#min_y,a0
	calla	RNDRNG0
	move	a0,a10

	addi	#min_x,a9
	addi	#min_y,a10

	cmpi	#mid_x1,a9
	jrle	#place_hulk
	cmpi	#mid_x2,a9
	jrge	#place_hulk
	cmpi	#mid_y1,a10
	jrle	#place_hulk
	cmpi	#mid_y2,a10
	jrge	#place_hulk
	jruc	#get_pos

#place_hulk
	;assign a random starting position
	CREATE	HULK_PID,hulk
	PULLP	a0
	dsj	a0,#another_hulk

#done
	rets


#min_x	equ	53	;hulk start outer boundaries
#max_x	equ	347-13
#min_y	equ	45
#max_y	equ	231-16

#mid_x1	equ	200-50	;hulk start inner boundaries
#mid_x2	equ	200+50
#mid_y1	equ	138-50
#mid_y2	equ	138+50


#*****************************************************************************
*
*	hulk process
*

	STRUCTPD
	LONG	#PD_SCRIPT	;UHL script head
	WORD	#PD_FRAME_NDX	;UHW frame index

	;reg use
	; a8 - object handle
	; a9 - (in)  starting x
	; a9 - (use) frame change count
	;a10 - (in)  starting y
	;a11 - direction of motion (0-3)

 SUBRP	hulk

	;choose a direction of motion
	movi	3,a0
	calla	RNDRNG0
	move	a0,a11

	X32	a0
	addi	#anim_list,a0
	move	*a0,a6,L
	move	a6,*a13(#PD_SCRIPT),L
	clr	a7
	move	a7,*a13(#PD_FRAME_NDX),W

	;create the hulk object
	move	a9,a0		;x pos
	sla	16,a0
	move	a10,a1		;y pos
	sla	16,a1

	move	a7,a14		;img
	X32	a14
	add	a6,a14
	move	*a14,a2,L

	clr	a3
	movi	DMAWNZ,a4
	movi	CLSENMY|TYPHULK,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	;set the move counter
	movi	#move_freq/2,a0
	calla	RNDRNG0
	addi	#move_freq,a0
	move	a0,a9

#loop
	SLEEPK	1
	dsj	a9,#loop
	callr	#move_hulk
	movi	#move_freq,a9
	jruc	#loop


#been_shot	;we immediately wake up here if we've been hit and moved
		; by a player bullet.
	callr	#do_bounds_check
	jruc	#loop

	DIE


******************************************************************************
*
*	hulk move routine
*

	;reg use
	; a0 scratch
	; a1 scratch
	; a8 object handle
	;a11 direction of motion (0-3)

 SUBRP	#move_hulk
	;move him
	move	a11,a14
	X32	a14
	addi	#move_table,a14
	move	*a14+,a0,W
	move	*a14,a1,W
	move	*a8(OXPOS),a14,W
	add	a0,a14
	move	a14,*a8(OXPOS),W
	move	*a8(OYPOS),a14,W
	add	a1,a14
	move	a14,*a8(OYPOS),W

	;
	;note the fall-through here
	;

	;bounds check
 SUBRP	#do_bounds_check
	clr	a1

	clr	a0
	move	*a8(OXPOS),a0,W
	cmpi	#low_x,a0
	jrlt	#too_left
	cmpi	#high_x,a0
	jrgt	#too_right
	jruc	#vert_check

#too_left
	movi	#low_x,a14
	move	a14,*A8(OXPOS),W
	ori	M_HIT_LEFT,a1
	jruc	#vert_check

#too_right
	movi	#high_x,a14
	move	a14,*A8(OXPOS),W
	ori	M_HIT_RIGHT,a1
;	jruc	#vert_check

#vert_check
	clr	a0
	move	*a8(OYPOS),a0,W
	cmpi	#low_y,a0
	jrlt	#too_high
	cmpi	#high_y,a0
	jrgt	#too_low
	jruc	#done_boundcheck

#too_high
	movi	#low_y,a14
	move	a14,*A8(OYPOS),W
	ori	M_HIT_TOP,a1
	jruc	#done_boundcheck

#too_low
	movi	#high_y,a14
	move	a14,*A8(OYPOS),W
	ori	M_HIT_BOTTOM,a1
	jruc	#done_boundcheck

#done_boundcheck
	move	a1,a1
	jrnz	#change_direction

#no_wallhit
	movi	#turn_prob,a0
	PUSH	a1
	calla	RNDRNG0
	PULL	a1
	move	a0,a0
	jrnz	#done_moving

	;spontaneous direction change.  random for now
;	jruc	#change_direction	;fall through

#change_direction
	;turn 90 degrees by randomly incrementing or decrementing direction
	movi	1,a0
	PUSH	a1
	calla	RNDRNG0
	PULL	a1
	move	a0,a0
	jrz	#inc_direction
	dec	a11
	jruc	#dir_rangecheck
	
#inc_direction
	inc	a11

#dir_rangecheck
	cmpi	-1,a11
	jrne	#dir_notlow
	movi	3,a11

#dir_notlow
	cmpi	4,a11
	jrne	#dir_changed
	clr	a11

#dir_changed

	;verify that this is a good direction
	cmpi	0,a11
	jreq	#validate_up
	cmpi	1,a11
	jreq	#validate_right
	cmpi	2,a11
	jreq	#validate_down
	cmpi	3,a11
	jreq	#validate_left

#validate_up
	andi	M_HIT_TOP,a1
	jrnz	#change_direction
	jruc	#valid_dir
#validate_right
	andi	M_HIT_RIGHT,a1
	jrnz	#change_direction
	jruc	#valid_dir
#validate_down
	andi	M_HIT_BOTTOM,a1
	jrnz	#change_direction
	jruc	#valid_dir
#validate_left
	andi	M_HIT_LEFT,a1
	jrnz	#change_direction
	jruc	#valid_dir

#valid_dir

	move	a11,a0
	X32	a0
	addi	#anim_list,a0
	move	*a0,a0,L
	move	a0,*a13(#PD_SCRIPT),L

#done_moving
	
#new_frame
	move	*a13(#PD_FRAME_NDX),a14,W
	move	*a13(#PD_SCRIPT),a6,L
	inc	a14
	cmpi	4,a14
	jrne	#no_wrap
	clr	a14
#no_wrap
	move	a14,*a13(#PD_FRAME_NDX),W
	X32	a14
	add	a6,a14
	move	*a14,a0,L
	calla	civanic

	rets


******************************************************************************
*
*	hulk collision routines
*

 SUBR	hulk_pushback
	PUSH	a1,a7,a9,a10,a11,a13

	;immediately move the hulk in the direction of the bullet's motion
	move	*a0(OXVEL),a14,L
	sra	17,a14
	move	*a8(OXPOS),a1,W
	add	a14,a1
	move	a1,*a8(OXPOS),W

	move	*a0(OYVEL),a14,L
	sra	17,a14
	move	*a8(OYPOS),a1,W
	add	a14,a1
	move	a1,*a8(OYPOS),W

	;wake up at the collision check
	move	*a8(OPLINK),a0,L
	move	*a0(PA9),a9,L
	move	*a0(PA10),a10,L
	move	*a0(PA11),a11,L
	movi	HULK_PID,a1
	movi	#been_shot,a7
	calla	XFERPROC
	PULL	a1,a7,a9,a10,a11,a13

	rets


******************************************************************************
*
*	hulk configuration data
*

#step_x		equ	4
#step_y		equ	4

#low_x		equ	53	;hulk move boundaries
#high_x		equ	347-13
#low_y		equ	45
#high_y		equ	231-16

#move_freq	equ	8	;frames between moves

#turn_prob	equ	30	;chance per frame of spontaneously changing
				;direction
#move_table
	.word	0,-#step_y
	.word	#step_x,0
	.word	0,#step_y
	.word	-#step_x,0
#move_tablex

#anim_list
	.long	#anim_vert
	.long	#anim_right
	.long	#anim_vert
	.long	#anim_left
#anim_listx

#anim_vert
	.long	hulk_ud1
	.long	hulk_ud2
	.long	hulk_ud1
	.long	hulk_ud3
#anim_vertx

#anim_left
	.long	hulk_l1
	.long	hulk_l2
	.long	hulk_l1
	.long	hulk_l3
#anim_leftx

#anim_right
	.long	hulk_r1
	.long	hulk_r2
	.long	hulk_r1
	.long	hulk_r3
#anim_rightx


#*****************************************************************************
******************************************************************************
******************************************************************************
*
*	SPHEREOID SECTION
*

	;reg use
	; a0 - (in) # of sphereoids

 SUBRP	make_sphereoids

	move	a0,a0
	jrz	#done

#another_sphereoid
	PUSHP	a0

#get_pos
	movi	#max_x-#min_x,a0
	calla	RNDRNG0
	move	a0,a9
	movi	#max_y-#min_y,a0
	calla	RNDRNG0
	move	a0,a10

	addi	#min_x,a9
	addi	#min_y,a10

	cmpi	#mid_x1,a9
	jrle	#place_sphereoid
	cmpi	#mid_x2,a9
	jrge	#place_sphereoid
	cmpi	#mid_y1,a10
	jrle	#place_sphereoid
	cmpi	#mid_y2,a10
	jrge	#place_sphereoid
	jruc	#get_pos

#place_sphereoid
	;assign a random starting position
	CREATE	SPHEREOID_PID,sphereoid
	PULLP	a0
	dsj	a0,#another_sphereoid

#done
	rets


#mid_x1	equ	200-80	;sphereoid start inner boundaries
#mid_x2	equ	200+80
#mid_y1	equ	138-80
#mid_y2	equ	138+80


*******************************************************************************
*
*	sphereoid process
*

	STRUCTPD
	LONG	#OXACC		;UHL x acceleration
	LONG	#OYACC		;UHL y acceleration
	WORD	#OCHILDREN	;UHW # of children left to spawn
	WORD	#OSTAGE		;UHW stage in life cycle

	;reg use
	; a7 (use) event timer (related to #OSTAGE)
	; a8 (use) * object
	; a9 (in)  x pos
	; a9 (use) anim counter
	;a10 (in)  y pos
	;a10 (use) frame pointer
	;a11 (use) time until next vel change

 SUBRP	sphereoid

	;increment the badguy count
	move	@live_badguys,a14,W
	inc	a14
	move	a14,@live_badguys,W

	;create the sphereoid object
	move	a9,a0		;x pos
	sll	16,a0
	move	a10,a1		;y pos
	sll	16,a1
	movi	#standard_script,a10
	move	*a10+,a2,L	;img
	clr	a3
	movi	DMAWNZ,a4
	movi	CLSENMY|TYPSPHEREOID,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	;initialize anim counter
	movi	#anim_speed,a9

	;set initial velocities and accelerations
	callr	#set_va

	;initialize life cycle and event timer
	movi	#STAGE_YOUTH,a14
	move	a14,*a13(#OSTAGE),W
	movi	#youth_time/2,a0
	calla	RNDRNG0
	addi	#youth_time*3/4,a0
	move	a0,a7

#loop
	PUSHP	a7
	SLEEPK	1
	PULLP	a7
	dec	a9
	jrnz	#no_anim

	;advance the frame
	move	*a10+,a0,L
	jrnz	#newframe

	;reset script.  depends on the stage
	move	*a13(#OSTAGE),a14,W
	cmpi	#STAGE_PARENT,a14
	jreq	#set_parent_script
	movi	#standard_script,a10
	jruc	#script_set
#set_parent_script
	movi	#parent_script,a10

#script_set
	move	*a10+,a0,L

#newframe
	calla	civanic

	;reset the counter
	movi	#anim_speed,a9

#no_anim
	;adjust velocities
	callr	#acc_add

	;bounds check
	callr	#in_bounds

	;adjust vel and acc if it's time
	dec	a11
	jrnz	#no_va_change
	callr	#set_va

#no_va_change

	;do event?
	dec	a7
	jrnz	#no_event

	;event.  depends on the stage in the life cycle
	move	*a13(#OSTAGE),a14,W
	cmpi	#STAGE_YOUTH,a14
	jreq	#youth_event
	cmpi	#STAGE_PARENT,a14
	jreq	#parent_event
	;default
	jruc	#dotage_event

#youth_event
	;switch to middle age
	movi	#STAGE_PARENT,a14
	move	a14,*a13(#OSTAGE),W

	;set the number of kids to be spawned
	movi	#max_kids-#min_kids,a0
	calla	RNDRNG0
	addi	#min_kids,a0
	move	a0,*a13(#OCHILDREN),W

	;set the spawn timer
	movi	#spawn_time/2,a0
	calla	RNDRNG0
	addi	#spawn_time*3/4,a0
	move	a0,a7
	jruc	#no_event

#parent_event
	;spawn a brat
	PUSHP	a10,a11
	move	*a8(OXVAL),a10,L
	move	*a8(OYVAL),a11,L
	CREATE	ENFORCER_PID,enforcer
	PULLP	a10,a11

	;decrement the kid count
	move	*a13(#OCHILDREN),a14,W
	dec	a14
	jrz	#barren
	move	a14,*a13(#OCHILDREN),W
	movi	#spawn_time/2,a0
	calla	RNDRNG0
	addi	#spawn_time*3/4,a0
	move	a0,a7
	jruc	#no_event

#barren
	;that was the last kid.  age
	movi	#STAGE_DOTAGE,a14
	move	a14,*a13(#OSTAGE),W
	movi	#old_age_time,a7
	jruc	#no_event

#dotage_event
	;nothing fancy.  just die.
	jruc	#die_peacefully
	
#no_event
	jruc	#loop

#been_shot
	;crud.  we've been shot.  score the points
	movi	#sphereoid_points,a0
	callr	score_points

	;decrement the badguy count
	move	@live_badguys,a14,W
	dec	a14
	move	a14,@live_badguys,W

	;clear the velocity
	clr	a14
	move	a14,*a8(OXVEL),L
	move	a14,*a8(OYVEL),L

	;go through the death routine
	movi	#parent_script,a10,L
	move	*a8(OCTRL),a14,W
	xori	DMAWNZ,a14
	ori	DMACNZ,a14
	move	a14,*a8(OCTRL),W
	movi	#diecolor,a14
	move	a14,*a8(OCONST),W
	movi	robo_p,a0
	calla	pal_getf
	move	a0,*a8(OPAL),W

#die_loop
	SLEEPK	#anim_speed
	move	*a10+,a0,L
	jrz	#score_msg
	calla	civanic
	jruc	#die_loop

#score_msg
	movi	#score_image,a0
	move	*a8(OCTRL),a1,W
	xori	DMACNZ,a1
	ori	DMAWNZ,a1
	calla	civani
	movi	#score_xoff,a14
	move	a14,*a8(ODXOFF),W
	movi	#score_yoff,a14	
	move	a14,*a8(ODYOFF),W
	SLEEP	#score_time
	jruc	#expire

#die_peacefully
	;decrement the badguy count
	move	@live_badguys,a14,W
	dec	a14
	move	a14,@live_badguys,W

#expire
	calla	DELOBJA8

	DIE


 SUBRP	#set_va

	movi	#high_v*2,a0
	calla	RNDRNG0
	subi	#high_v,a0
	move	a0,*a8(OXVEL),L

	movi	#high_v*2,a0
	calla	RNDRNG0
	subi	#high_v,a0
	move	a0,*a8(OYVEL),L

	movi	#high_a*2,a0
	calla	RNDRNG0
	subi	#high_a,a0
	move	a0,*a13(#OXACC),L

	movi	#high_a*2,a0
	calla	RNDRNG0
	subi	#high_a,a0
	move	a0,*a13(#OYACC),L

	movi	#va_change_time,a0
	calla	RNDRNG0
	inc	a0
	move	a0,a11

	rets


 SUBRP	#acc_add
	move	*a13(#OXACC),a14,L
	move	*a8(OXVEL),a0,L
	add	a14,a0
	move	a0,*a8(OXVEL),L

	move	*a13(#OYACC),a14,L
	move	*a8(OYVEL),a0,L
	add	a14,a0
	move	a0,*a8(OYVEL),L

	rets


 SUBRP	#in_bounds

	move	*a8(OXPOS),a14,W
	movi	#min_x,a0
	cmp	a0,a14
	jrlt	#x_adjust

	movi	#max_x,a0
	cmp	a0,a14
	jrgt	#x_adjust
	jruc	#y_check

#x_adjust
	move	a0,*a8(OXPOS),W
	clr	a0
	move	a0,*a8(OXVEL),L
	move	a0,*a13(#OXACC),L

#y_check
	move	*a8(OYPOS),a14,W
	movi	#min_y,a0
	cmp	a0,a14
	jrlt	#y_adjust

	movi	#max_y,a0
	cmp	a0,a14
	jrgt	#y_adjust
	jruc	#done_check

#y_adjust
	move	a0,*a8(OYPOS),W
	clr	a0
	move	a0,*a8(OYVEL),L
	move	a0,*a13(#OYACC),L

#done_check
	rets


******************************************************************************
*
*	sphereoid collision routines
*

 SUBR	sphereoid_die
	PUSH	a1,a7

	movi	CLSDEAD,a14
	move	a14,*a8(OID),W
	move	*a8(OPLINK),a0,L
	movi	DEADSPHERE_PID,a1
	movi	#been_shot,a7
	calla	XFERPROC

	PULL	a1,a7
	rets


******************************************************************************
*
*	sphereoid configuration data
*

#anim_speed	equ	3

#va_change_time	equ	180

#sphereoid_points	equ	1000

#youth_time	equ	180	;time before we have kids
#spawn_time	equ	120	;time between kids
#old_age_time	equ	180	;time between last kid and natural death

#min_kids	equ	3	;lower limit on spawned enforcers
#max_kids	equ	7	;upper limit

#high_v		equ	00004000h
#high_a		equ	00000C00h

#min_x	equ	53	;sphereoid move bounds
#max_x	equ	347-15
#min_y	equ	45
#max_y	equ	231-15

#score_image	equ	one_k	;image on being shot
#diecolor	equ	0909h	;color on being shot
#score_time	equ	60	;time to display score value
#score_xoff	equ	-3	;shotimage offset
#score_yoff	equ	-5

;life cycle stages
#STAGE_YOUTH 	equ	0000h
#STAGE_PARENT	equ	0001h
#STAGE_DOTAGE	equ	0002h

#standard_script
	.long	circle_1
	.long	circle_2
	.long	circle_3
	.long	circle_4
	.long	circle_5
	.long	0

#parent_script
	.long	circle_1
	.long	circle_2
	.long	circle_3
	.long	circle_4
	.long	circle_5
	.long	circle_6
	.long	circle_7
	.long	circle_8
	.long	0


#*****************************************************************************
******************************************************************************
******************************************************************************
*
*	ENFORCER SECTION
*

	.bss	num_enforcers,		16	;active enforcers
	.bss	picket_duty,		32	;*img of picket enforcer

	;reg use
	;  a8 (use) *img
	;  a9 (use) next move timer (move/fire phase)
	;  a9 (use) frame pointer (death phase)
	; a10 (in)  initial X
	; a10 (use) frame pointer (grow phase)
	; a11 (in)  initial Y
	; a11 (use) next shot timer (move/fire phase)

 SUBRP	enforcer

	;increment the badguy count
	move	@live_badguys,a14,W
	inc	a14
	move	a14,@live_badguys,W
	move	@num_enforcers,a14,W
	inc	a14
	move	a14,@num_enforcers,W

	;create the enforcer object
	move	a10,a0
	move	a11,a1
	movi	#grow_script,a10
	move	*a10+,a2,L
	clr	a3
	movi	DMAWNZ,a4
	movi	CLSENMY|TYPENFORCER,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	;grow phase

#grow_loop
	SLEEPK	#grow_speed
	move	*a10+,a0,L
	jrz	#mf_phase
	calla	civanic
	jruc	#grow_loop

#mf_phase
	;begin move/fire phase.  set initial course
	callr	#new_course
	movi	#turn_time,a9
	movi	#fire_time/2,a0
	calla	RNDRNG0
	addi	#fire_time*3/4,a0
	move	a0,a11

#main_loop
	SLEEPK	1
	dec	a9
	jrnz	#no_turn


	;picket phase
	;two cases: we're on picket duty, or we're not.
	move	@picket_duty,a14,L
	cmp	a14,a8
	jreq	#on_picket

	;we're not on picket duty
	;if we're the only enforcer, quit now.
	move	@num_enforcers,a14,W
	cmpi	1,a14
	jreq	#picket_done

	;there are multiple enforcers.   If there is no picket, see if we
	; take the job.  If there is, quit.
	move	@picket_duty,a14,L
	jrnz	#picket_done

	;there is no picket.
	movi	#picket_prob,a0
	calla	RNDRNG0
	move	a0,a0
	jrnz	#picket_done

	;we're going to take picket duty
	move	a8,@picket_duty,L
	jruc	#picket_done

#on_picket
	;we are on picket duty
	;if we're the only enforcer, see if we leave picket mode.
	move	@num_enforcers,a14,W
	cmpi	1,a14
	jrne	#multiple_enforcers

	;we're the only enforcer
	movi	#stand_down_prob,a0
	calla	RNDRNG0
	move	a0,a0
	jrnz	#picket_done

	;and we've decided to stand down.
;	clr	a0	;unneccesary.  it's already 0 from above.
	move	a0,@picket_duty,L
	jruc	#picket_done

#multiple_enforcers
	;we may abandon our post
	movi	#abandon_post_prob,a0
	calla	RNDRNG0
	move	a0,a0
	jrnz	#picket_done

	;yep.  we quit.
;	clr	a0	;unneccesary.  it's already 0 from above.
	move	a0,@picket_duty,L
;	jruc	#picket_done

#picket_done

	;change course
	callr	#new_course
	movi	#turn_time,a9

#no_turn

	dec	a11
	jrnz	#no_shot

	;fire a spark
	PUSHP	a10
	move	*a8(OXVAL),a10,L
	move	*a8(OYVAL),a11,L
	CREATE	SPARK_PID,spark
	PULLP	a10
	movi	#fire_time/2,a0
	calla	RNDRNG0
	addi	#fire_time*3/4,a0
	move	a0,a11

#no_shot

	;bounds check
	callr	#in_bounds

	jruc	#main_loop

#die
	;decrement the badguy count
	move	@live_badguys,a14,W
	dec	a14
	move	a14,@live_badguys,W
	move	@num_enforcers,a14,W
	dec	a14
	move	a14,@num_enforcers,W

	;zero our velocity
	clr	a14
	move	a14,*a8(OXVEL),L
	move	a14,*a8(OYVEL),L

	;set up the animation
#dieloop
	move	*a9+,a0,L
	jrz	#dead_n_buried
	calla	civanic
	sleepk	#death_speed
	jruc	#dieloop

#dead_n_buried
	calla	DELOBJA8

	DIE


 SUBRP	#new_course

	;two cases.  picket or !picket
	move	@picket_duty,a14,L
	cmp	a8,a14
	jrne	#nc_notpicket

#nc_picket
	;we're on picket duty.  if we're not against a wall, move toward the
	; nearest one.  if we are against a wall but not in a corner, move
	; toward the nearest corner.  if we're in a corner, sit tight.
;	jruc	#nc_done

#nc_notpicket
	;velocity is the distance between enforcer and player / 64 / 2
	move	@player_object,a0,L
	move	*a0(OXVAL),a14,L
	move	*a8(OXVAL),a1,L
	sub	a1,a14
	sra	7,a14
	
	move	a14,*a8(OXVEL),L

	move	*a0(OYVAL),a14,L
	move	*a8(OYVAL),a1,L
	sub	a1,a14
	sra	7,a14
	move	a14,*a8(OYVEL),L

#nc_done
	rets

 SUBRP	#in_bounds

	move	*a8(OXPOS),a14,W
	movi	#min_x,a0
	cmp	a0,a14
	jrlt	#x_adjust

	movi	#max_x,a0
	cmp	a0,a14
	jrgt	#x_adjust
	jruc	#y_check

#x_adjust
	move	a0,*a8(OXPOS),W
	clr	a0
	move	a0,*a8(OXVEL),L

#y_check
	move	*a8(OYPOS),a14,W
	movi	#min_y,a0
	cmp	a0,a14
	jrlt	#y_adjust

	movi	#max_y,a0
	cmp	a0,a14
	jrgt	#y_adjust
	jruc	#done_check

#y_adjust
	move	a0,*a8(OYPOS),W
	clr	a0
	move	a0,*a8(OYVEL),L

#done_check
	rets


******************************************************************************
*
*	enforcer collision routines
*

 SUBR	enforcer_die
	;hit by player gunfire
	PUSH	a1,a7

	;jeepers.  we're dead.
	movi	CLSDEAD,a14
	move	a14,*a8(OID),W

	move	*a0(OXVEL),a14,L
	jrz	#vert_bullet
	move	*a0(OYVEL),a1,L
	jrz	#horz_bullet

	add	a1,a14
	jrz	#diag_13
	jruc	#diag_24

#horz_bullet
	movi	#die_vert,a9
	jruc	#death_set
#vert_bullet
	movi	#die_horz,a9
	jruc	#death_set
#diag_13
	movi	#die_diag24,a9
	jruc	#death_set
#diag_24
	movi	#die_diag13,a9
	jruc	#death_set

#death_set
	move	*a8(OPLINK),a0,L
	movi	DEADNFORCER_PID,a1
	movi	#die,a7
	move	*a0(PA10),a10,L
	calla	XFERPROC

	movi	#enforcer_points,a0
	callr	score_points

	PULL	a1,a7
	rets


******************************************************************************
*
*	enforcer configuration data
*

#enforcer_points	equ	100

#picket_prob	equ	4	;one chance in X of becoming the picket if
				; there are multiple enforcers and none is
				; on the job already.

#stand_down_prob equ	4	;one chance in X of leaving picket duty if
				; we're the only enforcer left.

#abandon_post_prob equ	8	;one chance in X of leaving picket duty if
				; there are other enforcers around.

#turn_time	equ	150
#fire_time	equ	90

#grow_speed	equ	6

#min_x	equ	53	;enforcer move bounds
#max_x	equ	347-9
#min_y	equ	45
#max_y	equ	231-11

#grow_script
	.long	enf_g1
	.long	enf_g2
	.long	enf_g3
	.long	enf_g4
	.long	enf_g5
	.long	enf_1
	.long	0
#grow_scriptx

#die_vert
	.long	enf_xv1
	.long	enf_xv2
	.long	enf_xv3
	.long	enf_xv4
	.long	enf_xv5
	.long	0
#die_vertx

#die_horz
	.long	enf_xh1
	.long	enf_xh2
	.long	enf_xh3
	.long	enf_xh4
	.long	0
#die_horzx

#die_diag13
	.long	enf_xf1
	.long	enf_xf2
	.long	enf_xf3
	.long	enf_xf4
	.long	0
#die_diag13x

#die_diag24
	.long	enf_xb1
	.long	enf_xb2
	.long	enf_xb3
	.long	enf_xb4
	.long	0
#die_diag24x

#death_speed	equ	3		;death seq anim speed


#*****************************************************************************
******************************************************************************
******************************************************************************
*
*	SPARK SECTION
*

	;reg use
	;  a6 (use) x acc
	;  a7 (use) y acc
	;  a8 (use) *image
	;  a9 (use) anim timer
	; a10 (in)  initial X
	; a10 (use) anim pointer
	; a11 (in)  initial Y
	; a11 (use) life timer

 SUBRP	spark

	;create a spark object
	move	a10,a0
	move	a11,a1

	movi	#script,a10
	move	*a10+,a2,L
	clr	a3
	movi	DMAWNZ,a4
	movi	CLSENMY|TYPSPARK,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	;set the initial velocity.
	move	@player_object,a0,L
	move	*a0(OXVAL),a1,L
	move	*a8(OXVAL),a2,L
	sub	a2,a1
	sra	5,a1
	move	a1,*a8(OXVEL),L

	move	*a0(OYVAL),a1,L
	move	*a8(OYVAL),a2,L
	sub	a2,a1
	sra	5,a1
	move	a1,*a8(OYVEL),L

	;and then add a little 'spin' by giving them some acceleration
	movi	#high_acc*2,a0
	calla	RNDRNG0
	subi	#high_acc,a0
	move	a0,a6
	movi	#high_acc*2,a0
	calla	RNDRNG0
	subi	#high_acc,a0
	move	a0,a7

	movi	#anim_time,a9
	movi	#life_time,a11

#loop
	PUSHP	a6,a7
	SLEEPK	1
	PULLP	a6,a7

	;bounds check
	callr	#in_bounds

	;apply accelerations
	move	*a8(OXVEL),a14,L
	add	a6,a14
	move	a14,*a8(OXVEL),L

	move	*a8(OYVEL),a14,L
	add	a7,a14
	move	a14,*a8(OYVEL),L

	dec	a9
	jrnz	#no_anim

	move	*a10+,a0,L
	jrnz	#no_wrap
	movi	#script,a10
	move	*a10+,a0,L
#no_wrap
	calla	civanic
	movi	#anim_time,a9

#no_anim
	dec	a11
	jrz	#expire
	jruc	#loop

#expire
	calla	DELOBJA8

	DIE


 SUBRP	#in_bounds

	move	*a8(OXPOS),a14,W
	movi	#min_x,a0
	cmp	a0,a14
	jrlt	#x_adjust

	movi	#max_x,a0
	cmp	a0,a14
	jrgt	#x_adjust
	jruc	#y_check

#x_adjust
	move	a0,*a8(OXPOS),W
	clr	a6
	move	a6,*a8(OXVEL),L

#y_check
	move	*a8(OYPOS),a14,W
	movi	#min_y,a0
	cmp	a0,a14
	jrlt	#y_adjust

	movi	#max_y,a0
	cmp	a0,a14
	jrgt	#y_adjust
	jruc	#done_check

#y_adjust
	move	a0,*a8(OYPOS),W
	clr	a7
	move	a7,*a8(OYVEL),L

#done_check
	rets


******************************************************************************
*
*	spark collision routines
*

 SUBR	spark_die
	PUSH	a1,a7

	movi	CLSDEAD,a14
	move	a14,*a8(OID),W
	move	*a8(OPLINK),a0,L
	movi	DEADSPARK_PID,a1
	movi	#expire,a7
	calla	XFERPROC

	PULL	a1,a7
	rets


******************************************************************************
*
*	spark configuration data
*

#life_time	equ	180		;how long they last
#anim_time	equ	3		;frame rate

#high_acc	equ	00000200h	;top acceleration

#min_x	equ	53	;spark move bounds
#max_x	equ	347-7
#min_y	equ	45
#max_y	equ	231-7

#script
	.long	spark_1
	.long	spark_2
	.long	spark_3
	.long	spark_4
	.long	0


#*****************************************************************************
******************************************************************************
******************************************************************************
*
*	QUARK SECTION
*

	;reg use
	; a0 - (in) # of quarks

 SUBRP	make_quarks

	move	a0,a0
	jrz	#done

#another_quark
	PUSHP	a0

#get_pos
	;assign a random starting position
	movi	#max_x-#min_x,a0
	calla	RNDRNG0
	move	a0,a9
	movi	#max_y-#min_y,a0
	calla	RNDRNG0
	move	a0,a10

	addi	#min_x,a9
	addi	#min_y,a10

	cmpi	#mid_x1,a9
	jrle	#place_quark
	cmpi	#mid_x2,a9
	jrge	#place_quark
	cmpi	#mid_y1,a10
	jrle	#place_quark
	cmpi	#mid_y2,a10
	jrge	#place_quark
	jruc	#get_pos

#place_quark
	CREATE	QUARK_PID,quark
	PULLP	a0
	dsj	a0,#another_quark

#done
	rets


#mid_x1	equ	200-60	;quark start inner boundaries
#mid_x2	equ	200+60
#mid_y1	equ	138-60
#mid_y2	equ	138+60


*******************************************************************************
*
*	quark process
*

	STRUCTPD
	WORD	#OCHILDREN	;UHW # of children left to spawn
	WORD	#OSTAGE		;UHW stage in life cycle

	;reg use
	; a7 (use) event timer (related to #OSTAGE)
	; a8 (use) * object
	; a9 (in)  x pos
	; a9 (use) anim counter
	;a10 (in)  y pos
	;a10 (use) frame pointer
	;a11 (use) time until next vel change

 SUBRP	quark

	;increment the badguy count
	move	@live_badguys,a14,W
	inc	a14
	move	a14,@live_badguys,W

	;create the quark object
	move	a9,a0		;x pos
	sll	16,a0
	move	a10,a1		;y pos
	sll	16,a1
	movi	#standard_script,a10
	move	*a10+,a2,L	;img
	clr	a3
	movi	DMAWNZ,a4
	movi	CLSENMY|TYPQUARK,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	;initialize anim counter
	movi	#anim_speed,a9

	;set initial velocities and accelerations
	callr	#set_v

	;initialize life cycle and event timer
	movi	#STAGE_YOUTH,a14
	move	a14,*a13(#OSTAGE),W
	movi	#youth_time,a7

#loop
	PUSHP	a7
	SLEEPK	1
	PULLP	a7
	dec	a9
	jrnz	#no_anim

	;advance the frame
	move	*a10+,a0,L
	jrnz	#newframe

	;reset script.  depends on the stage
	move	*a13(#OSTAGE),a14,W
	cmpi	#STAGE_PARENT,a14
	jreq	#set_parent_script
	movi	#standard_script,a10
	jruc	#script_set
#set_parent_script
	movi	#parent_script,a10

#script_set
	move	*a10+,a0,L

#newframe
	calla	civanic

	;reset the counter
	movi	#anim_speed,a9

#no_anim
	;bounds check
	callr	#in_bounds

	;adjust vel if it's time
	dec	a11
	jrnz	#no_v_change
	callr	#set_v

#no_v_change

	;do event?
	dec	a7
	jrnz	#no_event

	;event.  depends on the stage in the life cycle
	move	*a13(#OSTAGE),a14
	cmpi	#STAGE_YOUTH,a14
	jreq	#youth_event
	cmpi	#STAGE_PARENT,a14
	jreq	#parent_event
	;default
	jruc	#dotage_event

#youth_event
	;switch to middle age
	movi	#STAGE_PARENT,a14
	move	a14,*a13(#OSTAGE),W

	;set the number of kids to be spawned
	movi	#max_kids-#min_kids,a0
	calla	RNDRNG0
	addi	#min_kids,a0
	move	a0,*a13(#OCHILDREN),W

	;set the spawn timer
	movi	#spawn_time,a7
	jruc	#no_event

#parent_event
	;spawn a brat
	PUSHP	a10,a11
	move	*a8(OXVAL),a10,L
	move	*a8(OYVAL),a11,L
	CREATE	TANK_PID,tank
	PULLP	a10,a11

	;decrement the kid count
	move	*a13(#OCHILDREN),a14,W
	dec	a14
	jrz	#barren
	move	a14,*a13(#OCHILDREN),W
	movi	#spawn_time,a7
	jruc	#no_event

#barren
	;that was the last kid.  age
	movi	#STAGE_DOTAGE,a14
	move	a14,*a13(#OSTAGE),W
	movi	#old_age_time,a7
	jruc	#no_event

#dotage_event
	;nothing fancy.  just die.
	jruc	#die_peacefully
	
#no_event
	jruc	#loop


#been_shot
	;crud.  we've been shot

#die_peacefully

	;decrement the badguy count
	move	@live_badguys,a14,W
	dec	a14
	move	a14,@live_badguys,W

	calla	DELOBJA8

	DIE


 SUBRP	#set_v

	movi	#high_v,a0
	calla	RNDRNG0
	cmpi	#high_v/2,a0
	jrgt	#positive_x

	subi	#high_v,a0

#positive_x
	move	a0,*a8(OXVEL),L

	movi	#high_v,a0
	calla	RNDRNG0
	cmpi	#high_v/2,a0
	jrgt	#positive_y

	subi	#high_v,a0

#positive_y
	move	a0,*a8(OYVEL),L

	movi	#v_change_time/2,a0
	calla	RNDRNG0
	addi	#v_change_time/2,a0
	move	a0,a11

	rets


 SUBRP	#in_bounds

	move	*a8(OXPOS),a1,W
	movi	#min_x,a0
	move	*a8(ODXOFF),a14,W
	add	a14,a0
	cmp	a0,a1
	jrlt	#x_adjust

	move	*a8(OSIZEX),a0,W
	neg	a0
	move	*a8(ODXOFF),a14,W
	add	a14,a0
	addi	#max_x,a0
	cmp	a0,a1
	jrgt	#x_adjust
	jruc	#y_check

#x_adjust
	move	a0,*a8(OXPOS),W
	move	*a8(OXVEL),a0,L
	neg	a0
	move	a0,*a8(OXVEL),L

#y_check
	move	*a8(OYPOS),a1,W
	movi	#min_y,a0
	move	*a8(ODYOFF),a14,W
	add	a14,a0
	cmp	a0,a1
	jrlt	#y_adjust

	move	*a8(OSIZEY),a0,W
	neg	a0
	move	*a8(ODYOFF),a14,W
	add	a14,a0
	addi	#max_y,a0
	cmp	a0,a1
	jrgt	#y_adjust
	jruc	#done_check

#y_adjust
	move	a0,*a8(OYPOS),W
	move	*a8(OYVEL),a0,L
	neg	a0
	move	a0,*a8(OYVEL),L

#done_check
	rets


******************************************************************************
*
*	quark collision routines
*

 SUBR	quark_die
	PUSH	a1,a7

	movi	CLSDEAD,a14
	move	a14,*a8(OID),W
	move	*a8(OPLINK),a0,L
	movi	DEADQUARK_PID,a1
	movi	#been_shot,a7
	calla	XFERPROC

	PULL	a1,a7
	rets


******************************************************************************
*
*	quark configuration data
*

#anim_speed	equ	3

#v_change_time	equ	600	;time between random course changes

#youth_time	equ	90	;time before we have kids
#spawn_time	equ	90	;time between kids
#old_age_time	equ	120	;time between last kid and natural death

#min_kids	equ	3	;lower limit on spawned tanks
#max_kids	equ	7	;upper limit

#high_v		equ	0001C000h

#min_x	equ	53	;quark move bounds
#max_x	equ	347-0
#min_y	equ	45
#max_y	equ	231-0

;life cycle stages
#STAGE_YOUTH 	equ	0000h
#STAGE_PARENT	equ	0001h
#STAGE_DOTAGE	equ	0002h

#standard_script
	.long	quark_1
	.long	quark_1
	.long	quark_2
	.long	quark_3
	.long	quark_4
	.long	0

#parent_script
	.long	quark_1
	.long	quark_2
	.long	quark_3
	.long	quark_4
	.long	quark_5
	.long	quark_6
	.long	quark_7
	.long	quark_8
	.long	0


#*****************************************************************************
******************************************************************************
******************************************************************************
*
*	TANK SECTION
*

	STRUCTPD
	WORD	#OSHOTS		;UHW shots left to be fired

	;reg use
	;  a7 (use) anim timer
	;  a8 (use) *img
	;  a9 (use) next move timer (move/fire phase)
	;  a9 (use) frame pointer (death phase)
	; a10 (in)  initial X
	; a10 (use) frame pointer (grow + move/fire phases)
	; a11 (in)  initial Y
	; a11 (use) next shot timer (move/fire phase)

 SUBRP	tank

	;increment the badguy count
	move	@live_badguys,a14,W
	inc	a14
	move	a14,@live_badguys,W

	;create the tank object
	move	a10,a0
	move	a11,a1
	movi	#grow_script,a10
	move	*a10+,a2,L
	clr	a3
	movi	DMAWNZ,a4
	movi	CLSENMY|TYPTANK,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	;grow phase

#grow_loop
	SLEEPK	#grow_speed
	move	*a10+,a0,L
	jrz	#mf_phase
	calla	civanic
	jruc	#grow_loop

#mf_phase
	;begin move/fire phase.  set initial course
	callr	#set_v
	movi	#anim_time,a7
	movi	#right_script,a10
	movi	#fire_time/2,a0
	calla	RNDRNG0
	addi	#fire_time*3/4,a0
	move	a0,a11
	movi	#num_shots,a14
	move	a14,*a13(#OSHOTS),W

#main_loop
	PUSHP	a7
	SLEEPK	1
	PULLP	a7
	dec	a9
	jrnz	#no_turn

	;change course
	callr	#set_v

#no_turn

	dec	a11
	jrnz	#no_shot

	move	*a13(#OSHOTS),a14,W
	jrz	#no_shot

	;fire a shell
	PUSHP	a7,a10,a11
	move	*a8(OXVAL),a10,L
	move	*a8(OYVAL),a11,L
	create	SHELL_PID,tank_shell
	PULLP	a7,a10,a11
	movi	#fire_time/2,a0
	calla	RNDRNG0
	addi	#fire_time*3/4,a0
	move	a0,a11

#no_shot

	;bounds check
	callr	#in_bounds

	;animate?
	dec	a7
	jrnz	#no_anim
	move	*a10+,a0,L
	jrnz	#no_wrap
	movi	#right_script,a10
	move	*a10+,a0,L

#no_wrap
	calla	civanic
	movi	#anim_time,a7

#no_anim
	jruc	#main_loop

#die
	;decrement the badguy count
	move	@live_badguys,a14,W
	dec	a14
	move	a14,@live_badguys,W

	;zero our velocity
	clr	a14
	move	a14,*a8(OXVEL),L
	move	a14,*a8(OYVEL),L

	;set up the animation
#dieloop
	move	*a9+,a0,L
	jrz	#dead_n_buried
	calla	civanic
	sleepk	#death_speed
	jruc	#dieloop

#dead_n_buried
	calla	DELOBJA8

	DIE


 SUBRP	#set_v

	movi	#high_v,a0
	calla	RNDRNG0
	cmpi	#high_v/2,a0
	jrgt	#positive_x

	subi	#high_v,a0

#positive_x
	move	a0,*a8(OXVEL),L

	movi	#high_v,a0
	calla	RNDRNG0
	cmpi	#high_v/2,a0
	jrgt	#positive_y

	subi	#high_v,a0

#positive_y
	move	a0,*a8(OYVEL),L

	movi	#v_change_time/2,a0
	calla	RNDRNG0
	addi	#v_change_time/2,a0
	move	a0,a9

	rets


 SUBRP	#in_bounds

	move	*a8(OXPOS),a14,W
	movi	#min_x,a0
	cmp	a0,a14
	jrlt	#x_adjust

	movi	#max_x,a0
	cmp	a0,a14
	jrgt	#x_adjust
	jruc	#y_check

#x_adjust
	move	a0,*a8(OXPOS),W
	move	*a8(OXVEL),a0,L
	neg	a0
	move	a0,*a8(OXVEL),L

#y_check
	move	*a8(OYPOS),a14,W
	movi	#min_y,a0
	cmp	a0,a14
	jrlt	#y_adjust

	movi	#max_y,a0
	cmp	a0,a14
	jrgt	#y_adjust
	jruc	#done_check

#y_adjust
	move	a0,*a8(OYPOS),W
	move	*a8(OYVEL),a0,L
	neg	a0
	move	a0,*a8(OYVEL),L

#done_check
	rets


******************************************************************************
*
*	tank collision routines
*

 SUBR	tank_die
	;hit by player gunfire
	PUSH	a1,a7

	;jeepers.  we're dead.
	movi	CLSDEAD,a14
	move	a14,*a8(OID),W

	move	*a0(OXVEL),a14,L
	jrz	#vert_bullet
	move	*a0(OYVEL),a1,L
	jrz	#horz_bullet

	add	a1,a14
	jrz	#diag_13
	jruc	#diag_24

#horz_bullet
	movi	#die_vert,a9
	jruc	#death_set
#vert_bullet
	movi	#die_horz,a9
	jruc	#death_set
#diag_13
	movi	#die_diag24,a9
	jruc	#death_set
#diag_24
	movi	#die_diag13,a9
	jruc	#death_set

#death_set
	move	*a8(OPLINK),a0,L
	movi	DEADTANK_PID,a1
	movi	#die,a7
	move	*a0(PA10),a10,L
	calla	XFERPROC

	movi	#tank_points,a0
	callr	score_points

	PULL	a1,a7
	rets


******************************************************************************
*
*	tank configuration data
*

#tank_points	equ	200

#num_shots	equ	21

#v_change_time	equ	250
#fire_time	equ	90

#high_v		equ	00010000h

#grow_speed	equ	6
#anim_time	equ	2

#min_x	equ	53	;tank move bounds
#max_x	equ	347-13
#min_y	equ	45
#max_y	equ	231-16

#grow_script
	.long	tank_g1
	.long	tank_g2
	.long	tank_g3
	.long	tank_g4
	.long	tank_1
	.long	0

#right_script
	.long	tank_1
	.long	tank_2
	.long	tank_3
	.long	tank_4
	.long	0

#die_vert
	.long	enf_xv1
	.long	enf_xv2
	.long	enf_xv3
	.long	enf_xv4
	.long	enf_xv5
	.long	0

#die_horz
	.long	enf_xh1
	.long	enf_xh2
	.long	enf_xh3
	.long	enf_xh4
	.long	0

#die_diag13
	.long	enf_xf1
	.long	enf_xf2
	.long	enf_xf3
	.long	enf_xf4
	.long	0

#die_diag24
	.long	enf_xb1
	.long	enf_xb2
	.long	enf_xb3
	.long	enf_xb4
	.long	0

#death_speed	equ	3		;death seq anim speed


#*****************************************************************************
******************************************************************************
******************************************************************************
*
*	SHELL SECTION
*

	;reg use
	;  a8 (use) *image
	; a10 (in)  initial X
	; a11 (in)  initial Y
	; a11 (use) life timer

 SUBRP	tank_shell

	;create a shell object
	move	a10,a0
	move	a11,a1
	movi	shell,a2
	clr	a3
	movi	DMAWNZ,a4
	movi	CLSENMY|TYPSHELL,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	;set the initial velocity.
	move	@player_object,a0,L
	move	*a0(OXVAL),a1,L
	move	*a8(OXVAL),a2,L
	sub	a2,a1
	sra	5,a1
	move	a1,*a8(OXVEL),L

	move	*a0(OYVAL),a1,L
	move	*a8(OYVAL),a2,L
	sub	a2,a1
	sra	5,a1
	move	a1,*a8(OYVEL),L

	movi	#life_time,a11

#loop
	PUSHP	a6,a7
	SLEEPK	1
	PULLP	a6,a7

	;bounds check
	callr	#in_bounds

	dsj	a11,#loop

#expire
	calla	DELOBJA8

	DIE


 SUBRP	#in_bounds

	move	*a8(OXPOS),a14,W
	movi	#min_x,a0
	cmp	a0,a14
	jrlt	#x_adjust

	movi	#max_x,a0
	cmp	a0,a14
	jrgt	#x_adjust
	jruc	#y_check

#x_adjust
	move	a0,*a8(OXPOS),W
	move	*a8(OXVEL),a0,L
	neg	a0
	move	a0,*a8(OXVEL),L

#y_check
	move	*a8(OYPOS),a14
	movi	#min_y,a0
	cmp	a0,a14
	jrlt	#y_adjust

	movi	#max_y,a0
	cmp	a0,a14
	jrgt	#y_adjust
	jruc	#done_check

#y_adjust
	move	a0,*a8(OYPOS),W
	move	*a8(OYVEL),a0,L
	neg	a0
	move	a0,*a8(OYVEL),L

#done_check
	rets


******************************************************************************
*
*	shell collision routines
*

 SUBR	shell_die
	PUSH	a1,a7

	movi	CLSDEAD,a14
	move	a14,*a8(OID),W
	move	*a8(OPLINK),a0,L
	movi	DEADSHELL_PID,a1
	movi	#expire,a7
	calla	XFERPROC

	PULL	a1,a7
	rets


******************************************************************************
*
*	shell configuration data
*

#life_time	equ	240		;how long they last

#min_x	equ	53	;shell move bounds
#max_x	equ	347-7
#min_y	equ	45
#max_y	equ	231-7


#*****************************************************************************
******************************************************************************
******************************************************************************
*
*	color cycling processes
*

 SUBRP	robo_pal_cycles

	;laser flash cycle
	movi	[0Ah,1],a8		;cycle color A
	movi	robo_p,a9		;pal name
	movi	COLTAB_LFLASH,a10	;use the LFLASH table
	movk	1,a11			;cycle speed
	CREATE	CYCPID,CYCLE_TABLE

	;rgb cycle
	movi	[0Bh,1],a8		;cycle color B
	movi	robo_p,a9		;pal name
	movi	COLTAB_RGB,a10		;use the RGB table
	movk	8,a11			;cycle speed
	CREATE	CYCPID,CYCLE_TABLE

	;decay cycle
	movi	[0Ch,1],a8		;cycle color C
	movi	robo_p,a9		;pal name
	movi	COLTAB_DECAY,a10	;use the DECAY table
	movk	2,a11			;cycle speed
	CREATE	CYCPID,CYCLE_TABLE

	;laser cycle
	movi	[0Dh,1],a8		;cycle color D
	movi	robo_p,a9		;pal name
	movi	COLTAB_LASER,a10	;use the LASER table
	movk	20,a11			;cycle speed
	CREATE	CYCPID,CYCLE_TABLE

	;blue-purple-red cycle
	movi	[0Eh,1],a8		;cycle color E
	movi	robo_p,a9		;pal name
	movi	COLTAB_BLUPURRED,a10	;use the BPR table
	movk	1,a11			;cycle speed
	CREATE	CYCPID,CYCLE_TABLE

	;red-gold cycle
	movi	[0Fh,1],a8		;cycle color F
	movi	robo_p,a9		;pal name
	movi	COLTAB_REDGOLD,a10	;use the RED-GOLD table
	movk	10,a11			;cycle speed
	CREATE	CYCPID,CYCLE_TABLE

	rets


COLTAB_LFLASH
	.WORD	0380H,1380H,2380H,3380H,4380H,5380H,6380H,7380H,7300H
	.WORD	7280H,7200H,7180H,7080H,7008H,7008H,7010H,7010H,701CH
	.WORD	701CH,601CH,501CH,409CH,309CH,209CH,219CH,029CH,039CH
	.WORD	139CH,239CH,339CH,539CH,739CH,7390H,7380H,6380H,4380H
	.word	-1

;	.word	7C00h,7FFFh,7FFFh,03E0h,7FFFh,7FFFh,001Fh,7FFFh,7FFFh

COLTAB_RGB
	.WORD	07C00H,001FH,77A0h,741Ah
	.word	-1

;	.word	7C00h,03E0h,001Fh

COLTAB_DECAY
	.WORD	001CH,001CH,011CH,021CH,031CH,039CH,239CH,2390H,2388H
	.WORD	2380H,4300H,5280H,7180H,6180H,7080H,7000H,6000H,5000H
	.WORD	4000H,3000H,2000H,1000H
	.word	-1

;	.word	7FFFh,6F7Bh,5EF7h,4E73h,3DEFh,2D6Bh,1CE7h,0C63h,0000h

COLTAB_LASER
	.word	7C1Fh,7FFFh,7F00h
	.word	-1

COLTAB_BLUPURRED
	.WORD	001CH,101CH,201CH,301CH,401CH,501CH,601CH,701CH,7010H
	.WORD	7010H,7008H,7008H,7000H,7000H,7008H,7008H,7010H,7010H
	.WORD	701CH,701CH,601CH,501CH,401CH,301CH,201CH,101CH
;	.word	001Fh,7C1Fh,7C00h
	.word	-1

COLTAB_REDGOLD
	.word	7C00h,7F00h
	.word	-1


#*****************************************************************************
******************************************************************************
******************************************************************************
*
*	score stuff
*

	;reg use
	; a11 score

 SUBRP	score

	;initialize score
	move	@robotron_score,a11,L
	callr	#print_score

#loop
	SLEEPK	1
	move	@robotron_score,a14,L
	cmp	a11,a14
	jrne	#score_change
	jruc	#loop

#score_change
	move	a14,a11
	callr	#zorch_score
	callr	#print_score
	jruc	#loop

	DIE


 SUBRP	#zorch_score
	movi	TYPTEXT|SUBSCOR,a0
	calla	obj_del1c

	rets


 SUBRP	#print_score

	movi	#score_setup,a2
	calla	setup_message
	movi	TYPTEXT|SUBSCOR,a14
	move	a14,@mess_objid
	move	@robotron_score,a0,L
	movi	#max_score,a1
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_R

	rets


#score_setup
	JAM_STR	robotron_ascii,3,1,#score_xpos,#score_ypos,robo_p,0
	.even

#max_score	.equ	9999999		;that's all dec_to_asc can handle

******************************************************************************
* adds to score
* >a0 amount to add

 SUBRP	score_points

	move	@robotron_score,a14,L
	add	a0,a14
	move	a14,@robotron_score,L
	rets


#score_ypos	.equ	36
#score_xpos	.equ	130

#*****************************************************************************
******************************************************************************
******************************************************************************
*
*	miscellaneous functions / processes
*

******************************************************************************
* Draws the frame
* >a0=color value
*

 SUBRP	draw_frame


	move	a0,a9
	sla	8,a9
	or	a0,a9

	movi	robo_p,a0
	calla	pal_getf
	move	a0,a10

	movi	#frame_data,a11

#loop
	move	*a11+,a0,L
	jrz	#done
	move	*a11+,a1,L
	movi	#frame_image,a2
	movi	100,a3				;z pos
	movi	DMACAL,a4			;DMA flags
	movi	CLSDEAD,a5			;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ

	move	a8,a0
	calla	fg2bg

	move	*a11+,a14,W
	move	a14,*a8(OSIZEX),W
	move	*a11+,a14,W
	move	a14,*a8(OSIZEY),W

	move	a9,*a8(OCONST),W
	move	a10,*a8(OPAL),W

	jruc	#loop
#done
	rets


#frame_image	equ	man_d1

#frame_data
	.long	[53,0],[43,0]	;position X,Y
	.word	294,2		;size X,Y

	.long	[53,0],[231,0]	;position X,Y
	.word	294,2		;size X,Y

	.long	[50,0],[43,0]	;position X,Y
	.word	3,190		;size X,Y

	.long	[347,0],[43,0]	;position X,Y
	.word	3,190		;size X,Y

	.long	0

#frame_datax


#*****************************************************************************
* Draws the wave indicator
*

 SUBRP	wave_count

	;wave text
	movi	[#wave_x,0],a0			;x pos
	movi	[#wave_y,0],a1			;y pos
	movi	wave_text,a2			;* image
	clr	a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ

	;ones digit
;	move	@robo_wave,a2,W
;	addi	HEXTODEC+0010h,a2		;extra 10 cuz we count from 0
;	move	*a2,a2,W
;	andi	00FFh,a2
	move	@robo_wave,a0,W
	sra	4,a0
	inc	a0
	calla	BINBCD
	move	a0,a2
	andi	0Fh,a2
	X32	a2
	addi	#wave_font,a2

	movi	[#wave_onesx,0],a0		;x pos
	movi	[#wave_y,0],a1			;y pos
	move	*a2,a2,L			;* image
	clr	a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ

	;tens digit
	move	@robo_wave,a0,W
	sra	4,a0
	inc	a0
	calla	BINBCD
	move	a0,a2
	srl	4,a2
	andi	0Fh,a2
	jrz	#done
	X32	a2
	addi	#wave_font,a2
	movi	[#wave_tensx,0],a0		;x pos
	movi	[#wave_y,0],a1			;y pos
	move	*a2,a2,L			;* image
	clr	a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ

#done
	rets

#wave_y		.equ	234
#wave_x		.equ	198
#wave_tensx	.equ	184
#wave_onesx	.equ	188

#wave_font
	.long	rsmall_0
	.long	rsmall_1
	.long	rsmall_2
	.long	rsmall_3
	.long	rsmall_4
	.long	rsmall_5
	.long	rsmall_6
	.long	rsmall_7
	.long	rsmall_8
	.long	rsmall_9
#wave_fontx

#*****************************************************************************
* Check to see if an object is completely on the playfield
* a8=OBJ
* >a0=walls hit (bit 0=top, 1=right, 2=bottom, 3=left)
* >a2=degree of overlap (in pixels)
* Trashes scratch

 SUBRP	bounds_check
	PUSH	a1,a3
	clr	a0
	clr	a2
	clr	a3

	;check for hit top
	move	*a8(OYPOS),a1
	move	*a8(ODYOFF),a14
	sub	a14,a1
	cmpi	#low_y,a1
	jrgt	#not_high
	movi	#low_y,a2
	sub	a1,a2
	ori	M_HIT_TOP,a0
	jruc	#not_low		;assume won't be both high and low

#not_high
	;check for hit bottom
	move	*a8(ODYOFF),a14		;subtract the offset AGAIN because
	sub	a14,a1			; we assume the anim point is there
	move	*a8(OSIZEY),a14		; to center the object.
	add	a14,a1
	cmpi	#high_y,a1
	jrlt	#not_low
	move	a1,a2
	subi	#high_y,a2
	ori	M_HIT_BOTTOM,a0

#not_low
	;check for hit left
	move	*a8(OXPOS),a1
	move	*a8(ODXOFF),a14
	sub	a14,a1
	cmpi	#low_x,a1
	jrgt	#not_left
	movi	#low_x,a3
	sub	a1,a3
	ori	M_HIT_LEFT,a0
	jruc	#done			;assume won't be both right and left

#not_left
	move	*a8(ODXOFF),a14
	sub	a14,a1
	move	*a8(OSIZEX),a14
	add	a14,a1
	cmpi	#high_x,a1
	jrlt	#done
	move	a1,a3
	subi	#high_x,a3
	ori	M_HIT_RIGHT,a0

#done
	;a2 is y overlap, a3 is x overlap.  a2 should be greatest of the two.
	cmp	a2,a3
	jrn	#retval_set
	move	a3,a2
#retval_set
	PULL	a1,a3
	rets


;boundaries
#low_x	equ	53
#high_x	equ	346
#low_y	equ	45
#high_y	equ	230

;ret values
B_HIT_TOP	equ	0
B_HIT_BOTTOM	equ	2
B_HIT_LEFT	equ	3
B_HIT_RIGHT	equ	1

M_HIT_TOP	equ	0001h
M_HIT_BOTTOM	equ	0004h
M_HIT_LEFT	equ	0008h
M_HIT_RIGHT	equ	0002h


#*****************************************************************************
* If ever both start buttons are down, this proc sets the robo_done flag
* and dies.
*

 SUBRP	watch_both_starts

#loop
	SLEEPK	4		;no need to check EVERY frame
	clr	a0
	calla	get_start_cur
	jrz	#loop
	movk	1,a0
	calla	get_start_cur
	jrz	#loop

	;both starts are down.
	movk	1,a0
	move	a0,@starts_down

	DIE

#*****************************************************************************
* Watches for wave advance/back up key combo.
*

 SUBRP	wave_mover

#loop
	SLEEPK	4
	calla	get_all_buttons_cur
	jrz	#loop

	cmpi	1,a0
	jreq	#back
	cmpi	2,a0
	jreq	#fwd
	jruc	#loop

#back
	move	a0,@backward
	jruc	#done
#fwd
	move	a0,@forward

#done
	DIE


	.if DEBUG

#*****************************************************************************
* Makes bog meters
*

 SUBRP	bog_o_meter

	movi	robo_p,a0
	calla	pal_getf
	move	a0,a9

	;create the background
	movi	[360,0],a0
	movi	[192,0],a1
	movi	man_d1,a2
	clr	a3
	movi	DMACAL|M_FLIPV,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	move	a9,*a8(OPAL)
	movi	0707h,a14
	move	a14,*a8(OCONST)

	movi	8,a0
	move	a0,*a8(OSIZEX)
	movi	128,a0
	move	a0,*a8(OSIZEY)
	move	a8,a10

	;create the foreground
	movi	[360,0],a0
	movi	[65,0],a1
	movi	man_d1,a2
	movi	1,a3
	movi	DMACAL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJW

	move	a9,*a8(OPAL)
	movi	0808h,a14
	move	a14,*a8(OCONST)
	
	movi	8,a0
	move	a0,*a8(OSIZEX)

	movi	#scale,a9

#loop
	SLEEPK	2
	move	@CPULEFT,a1
	jrnz	#nobog

	;BOG!!
	nop
#nobog
	mpyu	a9,a1
	srl	16,a1
	move	a1,*a8(OSIZEY)
	cmpi	10h,a1
	jrle	#red

	movi	0707h,a0
	move	a0,*a10(OCONST)
	jruc	#loop
#red
	movi	0101h,a0
	move	a0,*a10(OCONST)
	jruc	#loop

	DIE

#scale	equ	800000h/03DCh

	.endif

#*****************************************************************************

robotron_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long 0,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0								;$18
 .long 0,rfont_exc,0,0,0,0,0,0								;$20	SP! " # $ % & '
 .long rfont_lparens,rfont_rparens,0,0,rfont_comma,0,rfont_period,rfont_fslash	;$28	( ) * + , - . /
 .long rfont_0,rfont_1,rfont_2,rfont_3,rfont_4,rfont_5,rfont_6,rfont_7		;$30	0 1 2 3 4 5 6 7
 .long rfont_8,rfont_9,0,0,0,0,0,0						;$38	8 9 : ; < - > ?
 .long 0,rfont_a,rfont_b,rfont_c,rfont_d,rfont_e,rfont_f,rfont_g		;$40	@ A B C D E F G
 .long rfont_h,rfont_i,rfont_j,rfont_k,rfont_l,rfont_m,rfont_n,rfont_o		;$48	H I J K L M N O
 .long rfont_p,rfont_q,rfont_r,rfont_s,rfont_t,rfont_u,rfont_v,rfont_w		;$50	P Q R S T U V W
 .long rfont_x,rfont_y,rfont_z,0,0,0,0,0					;$58	X Y Z [ \ ] ^ _
 .long 0,rfont_a,rfont_b,rfont_c,rfont_d,rfont_e,rfont_f,rfont_g		;$60	` a b c d e f g
 .long rfont_h,rfont_i,rfont_j,rfont_k,rfont_l,rfont_m,rfont_n,rfont_o		;$68	h i j k l m n o
 .long rfont_p,rfont_q,rfont_r,rfont_s,rfont_t,rfont_u,rfont_v,rfont_w		;$70	p q r s t u v w
 .long rfont_x,rfont_y,rfont_z,0,0,0,0,0					;$78	x y z { | } ~

#*****************************************************************************
*
* Sound section
* >a0 = snd call

RS_GRUNT	.equ	0
RS_DIE		.equ	1
RS_RESCUE	.equ	2
RS_SHOOT	.equ	3
RS_HIT		.equ	4

sp_grunt	.equ	1<<8
sp_shoot	.equ	2<<8
sp_hit		.equ	3<<8
sp_rescue	.equ	4<<8
sp_die		.equ	5<<8

robosnd_tbl
	;	duration, call#
	.word	sp_grunt|6,96		;0 = grunt footstep
	.word	sp_die|96,98		;1 = die
	.word	sp_rescue|39,99		;2 = rescue
	.word	sp_shoot|17,102		;3 = shoot
	.word	sp_hit|23,100		;4 = hit
robosnd_end

	.bss	rs_snd,16		;current sound call (0-3)
	.bss	rs_time,32		;timeout on current call (long)PCNT
	.bss	rs_pri,16		;priority on current call
	.bss	last_grunt_snd,32	;PCNT of last grunt footstep


 SUBRP	robo_sound_init

	clr	a14
	move	a14,@rs_snd
	move	a14,@rs_time,L
	move	a14,@last_grunt_snd,L
	rets


 SUBRP	robo_sound

	PUSH	a2,a3,a4

	;reggies:
	;a0 = call index
	;a1 = priority
	;a2 = duration
	;a3 = call #

	;decode table index
	move	a0,a14
	X32	a14
	addi	robosnd_tbl,a14
	move	*a14,a1,W
	srl	8,a1
	move	*a14+,a2,W
	andi	0FFh,a2
	move	*a14,a3,W

	;check old duration - if there's nothing going on, do the sound.
	move	@rs_time,a4
	move	@PCNT,a14,L
	cmp	a4,a14
	jrgt	#dosnd

	;old sound still going.  check for an override
	TEST	a0
	jrnz	#ng
	move	@rs_snd,a14
	jrz	#grxgr		;special grunt-overriding-grunt case

#ng	move	@rs_pri,a14
	cmp	a14,a1
	jrge	#dosnd
	jruc	#done

#grxgr	;do new call if old one has 3 or fewer ticks to live
	move	@rs_time,a14,L
	move	@PCNT,a4,L
	sub	a4,a14
	cmpi	3,a4
	jrle	#dosnd
	jruc	#done

#dosnd	calla	SNDSND
	move	a0,@rs_snd
	move	@PCNT,a14,L
	add	a2,a14
	move	a14,@rs_time,L
	move	a1,@rs_pri

#done	PULL	a2,a3,a4
	rets


******************************************************************************

	.end
