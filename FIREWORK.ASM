**************************************************************
*
* Software:	Mike Lynch, Jason Skiles, Mark Turmell
* Initiated:	05/12/95
*
* Modified:
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"fireword.asm"
	.title	"wrestling game program"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"macros.h"
	.include	"mproc.equ"		;Mproc equates
	.include	"display.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"sys.equ"
	.include	"wwfsec.equ"
	.include	"game.equ"
	.include	"audit.equ"
	.include	"plyr.equ"
	.include	"anim.equ"
	.include	"sound.h"
	.include	"ring.equ"
	.include	"sound.equ"
	.include	"damage.equ"
	.include	"jjxm.h"

	.include	"imgtbl.glo"
	.include	"fontsimg.glo"
	.include	"bgndtbl.glo"
	.include	"miscimg.glo"

	.ref	RNDRNG0
	.ref	BEGINOBJP
	.ref	PRCSLP
	.ref	DELOBJA8
	.ref	obj_aniq
	.ref	flash_white
	.ref	pal_clean
	.ref	fade_up
	.ref	fade_down
	.ref	BGND_UD1
	.ref	crowd_anim
	.ref	crowd_cheer
	.ref	reduce_bog
	.ref	is_8_on_1
	.ref	print_message
	.ref	wsf14_ascii
	.ref	royal_rumble
	.ref	print_string_C2
	.ref	print_string_C
	.ref	font9_ascii
	.ref	setup_message
	.ref	mess_objid
	.ref	SNDSND
	.ref	crowd_process
	.ref	process_ptrs
	.ref	ogmd10_ascii

	.bss	fizzle_flare,16
	.bss	pan_down,16

EXP_FW_SND	.equ	1252
FLR_FW_SND	.equ	1244

#**********************************************************************
*
 SUBRP	#fwexa_anim
	.long	FWEXPA01
	.long	FWEXPA02
	.long	FWEXPA03
	.long	FWEXPA04
	.long	FWEXPA05
	.long	FWEXPA06
	.long	FWEXPA07
	.long	FWEXPA08
	.long	FWEXPA09
	.long	FWEXPA10
	.long	FWEXPA11
	.long	0

 SUBRP	#fwexb_anim
	.long	FWEXPB01
	.long	FWEXPB02
	.long	FWEXPB03
	.long	FWEXPB04
	.long	FWEXPB05
	.long	FWEXPB06
	.long	FWEXPB07
	.long	FWEXPB08
	.long	FWEXPB09
	.long	FWEXPB10
	.long	FWEXPB11
	.long	0

 SUBRP	#fwexp_tbl
	.long	#fwexa_anim
	.long	#fwexb_anim

 SUBRP	#flare_anim
	.long	FWFLAR01
	.long	FWFLAR02
	.long	FWFLAR03
	.long	FWFLAR04
	.long	FWFLAR05
 SUBRP	#flare_anim2
	.long	FWFLAR06
	.long	FWFLAR07
	.long	FWFLAR08
	.long	FWFLAR09
	.long	FWFLAR10
	.long	FWFLAR11
	.long	FWFLAR12
	.long	FWFLAR13
	.long	0

 SUBRP	#fw_pals
	.long	FWWHT_P
	.long	FWBLV_P
	.long	FWPNK_P
	.long	FWBLU_P
	.long	FWYEL_P

EXP_FWY	.equ	-260

 SUBRP	#animate_fwexp

	; First Get a random position to place the explosion
	movi	96,a0		; Get a random vertical position
	calla	RNDRNG0
	addi	EXP_FWY-48,a0
	move	a0,a9		; Save it away

	movi	350,a0		; Get a random horizontal postion
	calla	RNDRNG0
	addi	850,a0	
	move	a0,a10

	movi	200h,a0		; Get a random Zpos
	calla	RNDRNG0
	addi	700h,a0		; Make sure we can see it
	move	a0,a3

	; Now get a random firework explosion to use
	movi	1,a0		; Get a random explosion to use
	calla	RNDRNG0
	sll	5,a0
	addi	#fwexp_tbl,a0
	move	*a0,a11,L	; Get pointer to image table
	move	*a11+,a2,L	; Get the first image

	; Set up some additional object creation junk
	movi	DMAWNZ|M_3D,a4
	movi	CLSNEUT,a5	; Set the Object ID
	clr	a6		; Set the X velocity
	clr	a7		; Set the Y velocity

	; Get a random palette to use
	movi	4,a0		; Get a random palette number
	calla	RNDRNG0
	move	a0,b0		; Get entry from palette table
	sll	5,b0
	addi	#fw_pals,b0
	move	*b0,b0,L
	
	; Set up the x and y positions for the object
	move	a9,a1		; Get saved YPOS
	sll	16,a1		; Shift it for object creation
	move	a10,a0		; Get saved XPOS
	sll	16,a0		; Shift it for object creattion

	; Now create the first image
	calla	BEGINOBJP	; Create the object

	; Make an explosion sound
	movi	EXP_FW_SND,a3
	calla	SNDSND

	; And animate the whole works
	move	*a8(OCTRL),a10
	move	*a8(OYPOS),a9
#animate_loop
	SLEEPK	1
	move	*a11+,a0,L	; Get the next image
	jrz	#fwanim_done	; Are we done ? - br = yes
	move	a10,a1
	calla	obj_aniq	; Change the image
	addk	4,a9
	move	a9,*a8(OYPOS)
	jruc	#animate_loop	; Go do next image

	; We all done - soooo get rid of the object and die
#fwanim_done
	calla	DELOBJA8	; Kill off the object
	DIE			; And die


 SUBRP	firework_flare
	movk	25,a0
	calla	RNDRNG0
	addk	1,a0
	calla	PRCSLP

	movk	4,a0
	calla	RNDRNG0
	move	a0,b0
	sll	5,b0
	addi	#fw_pals,b0
	move	*b0,b0,L

	move	a9,a0
	srl	16,a0
	sll	16,a0

	move	a9,a1
	sll	16,a1

	movi	#flare_anim,a9
	move	*a9+,a2,L

	movi	810h,a3
	movi	DMAWNZ|M_3D,a4
	movi	CLSFRWK,a5
	clr	a6
	clr	a7

	calla	BEGINOBJP



;	PUSH	a0,a1,a2,a3,a4,a5,a6,a7
;	calla	flash_white
;	movi	FLR_FW_SND,a3
;	calla	SNDSND
;	PULL	a0,a1,a2,a3,a4,a5,a6,a7



	move	*a8(OCTRL),a10
#flare_loop
	SLEEPK	2
#fl_loop
	move	*a9+,a0,L
	jrz	#reset_flare
	move	a10,a1
	calla	obj_aniq
	jruc	#flare_loop

#reset_flare
	move	@fizzle_flare,a9
	jrnz	#flare_fizzle
	movi	#flare_anim2,a9
	jruc	#fl_loop

#flare_fizzle

	movi	#flare_anim2,a9
#ff_loop
	SLEEPK	4
	cmpi	#flare_anim,a9
	jrz	#ff_exit
	move	-*a9,a0,L
	move	a10,a1
	calla	obj_aniq
	jruc	#ff_loop
#ff_exit

	calla	DELOBJA8
	DIE



 SUBR	do_fireworks

;	RETP
	PUSHP	a9,a10

	calla	pal_clean	; Get rid of extra palettes

	clr	a10		; Fade down the lights
	move	a10,@fizzle_flare
	movk	32,a11
	CREATE0	fade_down
	SLEEPK	30

	movi	ANNC_PID,a0
	calla	KIL1C		; Kill off any announcer processes

	movi	METER_PID,a0
	calla	KIL1C		; Kill off meter processes

	movi	TIMER_PID,a0
	calla	KIL1C		; Kill off match timer process

	movi	FLASH_PID,a0
	calla	KIL1C		; Kill off any flasher processes

	movi	ICON_PID,a0
	calla	KIL1C		; Kill off any icon flashers

	movi	SMOVE_PID,a0
	calla	KIL1C		; Kill off special move processes

	movi	PINHIM_ANIM_PID,a0
	calla	KIL1C		; Kill off pin him processes

	movi	REWIRE_PID,a0
	calla	KIL1C		; Kill off rewire processes

	movi	ZSHIFT_PID,a0
	calla	KIL1C		; Kill off something to do with progress ladder

	movi	GETUP_PID,a0
	calla	KIL1C		; Kill off getup meter processes

	movi	FLASH_COMBO_PID,a0
	calla	KIL1C		; Kill off any combo flashers


;Jake adds 1 to FLASH_COMBO_PID to point at plyr 2!
	movi	FLASH_COMBO_PID+1,a0
	calla	KIL1C		; Kill off any combo flashers


	movi	CYCPID,a0
	calla	KIL1C		; Kill any cyclers

	movi	FX_PID,a0
	calla	KIL1C		; Kill and FX processes

	movi	ADD_INIT_PID,a0
	calla	KIL1C		; Kill any perfect processes

	movi	OVRHED_PID,a0
	calla	KIL1C		; Kill any of these that are laying around

	.if DEBUG
	movi	CDEBUG_PID,a0
	calla	KIL1C		; Kill off collision box debug processes
	.endif

;	movi	ROPE_PID,a0
;	calla	KIL1C		; Kill off any rope processes

	callr	knockout_drones	; Knock out any wrestler process that are drone wrestlers
	
	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
	calla	obj_del1c	; Kill off any announcer objects

	movi	CLSNEUT|TYPNEUT|SUBMFRAME,a0
	calla	obj_del1c	; Kill off the meter objects

	movi	CLSNEUT|TYPNEUT|SUBLBAR,a0
	calla	obj_del1c	; Kill off meter bars

	movi	TYPTIMERDIGIT,a0
	calla	obj_del1c	; Kill off the match timer objects

	movi	TYPWWFICON,a0
	calla	obj_del1c	; Kill off any WWF Icon objects

	movi	CLSDEAD,a0
	calla	obj_del1c	; Kill off winstreak number

	movi	TYPPINHIM,a0
	calla	obj_del1c	; Kill off any pin him objects

	movi	TYPPERFECT,a0
	calla	obj_del1c	; Kill off any perfect objects

	clr	a0			; Turn off bog reduction
	move	a0,@reduce_bog		; Animate the crowd
;	CREATE	CROWD_PID,crowd_anim

	;wake up the crowd
	move	@crowd_process,a0,L
	movk	1,a14
	move	a14,*a0(PTIME)

	calla	pal_clean	; Clean any other palettes we freed by
				; Getting rid of all of the above shit

	;ORIGINAL MIKE CODE
	;JASON'S QUICK-HACK VERSION



	calla	flash_white
	movi	FLR_FW_SND,a3
	calla	SNDSND


	; Back of ring flares
	movk	12,a10		; Make 12 flares
	movi	[798,128],a9	; [sx,y] of flare positions
#do_flare
	CREATE	FIREWRK_PID,firework_flare
	addi	[50,0],a9	; Increment x position
	dsjs	a10,#do_flare	; go do next flare

	; Left Side flares
	movi	[770,148],a9
	CREATE	FIREWRK_PID,firework_flare
	movi	[753,168],a9
	CREATE	FIREWRK_PID,firework_flare
	movi	[736,188],a9
	CREATE	FIREWRK_PID,firework_flare
	movi	[719,208],a9
	CREATE	FIREWRK_PID,firework_flare
	movi	[702,228],a9
	CREATE	FIREWRK_PID,firework_flare

	; Right Side flares
	movi	[1372,148],a9
	CREATE	FIREWRK_PID,firework_flare
	movi	[1389,168],a9
	CREATE	FIREWRK_PID,firework_flare
	movi	[1406,188],a9
	CREATE	FIREWRK_PID,firework_flare
	movi	[1423,208],a9
	CREATE	FIREWRK_PID,firework_flare
	movi	[1440,228],a9
	CREATE	FIREWRK_PID,firework_flare

	clr	a10		; Lights back on
	movi	64,a11
	CREATE0	fade_up
	SLEEPK	16

	calla	flash_white
	movi	FLR_FW_SND,a3
	calla	SNDSND

	;sleep while flares go off
	SLEEP	TSEC

	;now slowly pan up
	clr	a14
	move	a14,@pan_down
	CREATE0	pan_around

	;do fireworks

	movi	TSEC*6,a8

#do_exfw_loop
	CREATE0	#animate_fwexp	; Create an exploding firework

	movk	6,a0		; Sleep a random amount of time
	calla	RNDRNG0
	addk	1,a0		; Make sure we sleep at least 1
	sub	a0,a8
	calla	PRCSLP		; Sleep
	move	a8,a8
	jrgt	#do_exfw_loop

;Kill text on scrn

	movk	1,a0
	move	a0,@pan_down
	movi	TSEC*2,a9
	jruc	#cheer_lp
#no_exp_fw
	movi	TSEC*5,a9
#cheer_lp
	move	a9,a9
	jrle	#clp_done
	PUSH	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	movk	1,a3		; And make 'em do something
	calla	crowd_cheer
	PULL	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	SLEEPK	15
	subk	15,a9
	jruc	#cheer_lp
#clp_done
	

	movk	1,a0		; Tell flares to fizzle out
	move	a0,@fizzle_flare


	SLEEP	TSEC		; Give flares time to die out


	PULLP	a9,a10
	RETP

	.bss	pan_status,16

panning_points					; figure 8  

INIT_PAN_SPEED	.equ	TSEC

	.long	INIT_PAN_SPEED,[850,0],[EXP_FWY+0,0]
	.long	3,[848,0],[EXP_FWY-10,0]
	.long	3,[844,0],[EXP_FWY-20,0]
	.long	3,[836,0],[EXP_FWY-28,0]
	.long	3,[825,0],[EXP_FWY-36,0]
	.long	3,[812,0],[EXP_FWY-42,0]
	.long	3,[798,0],[EXP_FWY-46,0]
	.long	3,[783,0],[EXP_FWY-48,0]
	.long	3,[767,0],[EXP_FWY-48,0]
	.long	3,[752,0],[EXP_FWY-46,0]
	.long	3,[738,0],[EXP_FWY-42,0]
	.long	3,[725,0],[EXP_FWY-36,0]
	.long	3,[714,0],[EXP_FWY-28,0]
	.long	3,[706,0],[EXP_FWY-20,0]
	.long	3,[702,0],[EXP_FWY-10,0]
	.long	3,[700,0],[EXP_FWY+0,0]
	.long	3,[702,0],[EXP_FWY+10,0]
	.long	3,[706,0],[EXP_FWY+20,0]
	.long	3,[714,0],[EXP_FWY+28,0]
	.long	3,[725,0],[EXP_FWY+36,0]
	.long	3,[737,0],[EXP_FWY+42,0]
	.long	3,[752,0],[EXP_FWY+46,0]
	.long	3,[767,0],[EXP_FWY+48,0]
	.long	3,[783,0],[EXP_FWY+48,0]
	.long	3,[798,0],[EXP_FWY+46,0]
	.long	3,[812,0],[EXP_FWY+42,0]
	.long	3,[825,0],[EXP_FWY+36,0]
	.long	3,[836,0],[EXP_FWY+28,0]
	.long	3,[844,0],[EXP_FWY+20,0]
	.long	3,[848,0],[EXP_FWY+10,0]
	.long	3,[850,0],[EXP_FWY+0,0]
	.long	3,[852,0],[EXP_FWY-10,0]
	.long	3,[856,0],[EXP_FWY-20,0]
	.long	3,[864,0],[EXP_FWY-28,0]
	.long	3,[875,0],[EXP_FWY-36,0]
	.long	3,[888,0],[EXP_FWY-42,0]
	.long	3,[902,0],[EXP_FWY-46,0]
	.long	3,[917,0],[EXP_FWY-48,0]
	.long	3,[933,0],[EXP_FWY-48,0]
	.long	3,[948,0],[EXP_FWY-46,0]
	.long	3,[962,0],[EXP_FWY-42,0]
	.long	3,[975,0],[EXP_FWY-36,0]
	.long	3,[986,0],[EXP_FWY-28,0]
	.long	3,[994,0],[EXP_FWY-20,0]
	.long	3,[998,0],[EXP_FWY-10,0]
	.long	3,[1000,0],[EXP_FWY+0,0]
	.long	3,[998,0],[EXP_FWY+10,0]
	.long	3,[994,0],[EXP_FWY+20,0]
	.long	3,[986,0],[EXP_FWY+28,0]
	.long	3,[975,0],[EXP_FWY+36,0]
	.long	3,[963,0],[EXP_FWY+42,0]
	.long	3,[948,0],[EXP_FWY+46,0]
	.long	3,[933,0],[EXP_FWY+48,0]
	.long	3,[917,0],[EXP_FWY+48,0]
	.long	3,[902,0],[EXP_FWY+46,0]
	.long	3,[888,0],[EXP_FWY+42,0]
	.long	3,[875,0],[EXP_FWY+36,0]
	.long	3,[864,0],[EXP_FWY+28,0]
	.long	3,[856,0],[EXP_FWY+20,0]
	.long	3,[852,0],[EXP_FWY+10,0]
	.long	3,[850,0],[EXP_FWY+0,0]
	.long	0

	.bss	ticks,32		; Ticks for this move
	.bss	dx,32			; X movement per tick
	.bss	dy,32			; Y movement per tick
	.bss	targ_x,16		; Target X position
	.bss	targ_y,16		; Target Y position
	.bss	final_x,32		; Final X position to pan to
	.bss	final_y,32		; Final Y position to pan to
	.bss	p1x,32			; Start X point
	.bss	p1y,32			; Start Y point
	.bss	p2x,32			; End X point
	.bss	p2y,32			; End Y point

#*************************************************************
*
 SUBRP	calc_dxdy
	PUSH	a8,a9,a10,a11

	movi	p1x,a8			; Get pointer to start and end points

	move	@ticks,a10,L		; Get ticks for this move

	move	*a8,a11,L		; Get start X position
	move	*a8(64),a9,L		; Get End X position
	sub	a11,a9			; Get X difference
	divs	a10,a9			; Divide by ticks to get there
	move	a9,@dx,L		; Store delta X

	move	*a8(32),a11,L		; Get start Y position
	move	*a8(96),a9,L		; Get End Y position
	sub	a11,a9			; Get Y difference
	divs	a10,a9			; Divide by ticks to get there
	move	a9,@dy,L		; Store delta Y

	PULL	a8,a9,a10,a11
	rets


#*************************************************************
*
 SUBRP	move_camera
	PUSH	a0

	move	@WORLDTLX,a14,L		; Get Current X position
	move	@dx,a0,L		; Get Delta X
	add	a0,a14			; Add to Current X postion
	move	a14,@WORLDTLX,L		; Write new position


	move	@WORLDTLY,a14,L		; Get Current Y position
	move	@dy,a0,L		; Get Delta Y
	add	a0,a14			; Add to Current Y position
	move	a14,@WORLDTLY,L		; Write new Y position

	PULL	a0
	rets

#**************************************************************
*
 SUBRP	check_camera_position
	PUSH	a0

	move	@WORLDTLX,a14,L		; Get current X position
	sra	16,a14			; Get rid of fractional portion
	move	@targ_x,a0		; Get current target X position
	sub	a0,a14			; Subtract the two
	abs	a14			; Make sure it is positive
	cmpi	3,a14			; Are we within 3 ?
	jrgt	#check_y		; br = no
	clr	a14
	move	a14,@dx,L		; Stop X movement

#check_y
	move	@WORLDTLY,a14,L		; Get current Y position
	sra	16,a14			; Get rid of fractional portion
	move	@targ_y,a0		; Get current target Y position
	sub	a0,a14			; Subtract the two
	abs	a14			; Make sure it is positive
	cmpi	3,a14			; Are we within 3 ?
	jrgt	#check_done		; br = no
	clr	a14
	move	a14,@dy,L		; Stop Y movement

#check_done
	PULL	a0
	rets

#*******************************************************************
*
 SUBRP	pan_around

	SLEEP	TSEC/2

	clr	a14
	move	a14,@pan_status

	move	@WORLDTLX,a14,L		; Get current X position
	move	a14,@final_x,L		; Save off for pan back
	move	a14,@p1x,L		; Set as the starting X point
	move	@WORLDTLY,a14,L		; Get current Y position
	move	a14,@final_y,L		; Save off for pan back
	move	a14,@p1y,L		; Set as the starting Y point

#pan_again
	movi	panning_points,a8	; Get pointer to pan points table

#p1on8_lp
	move	*a8+,a14,L		; Get Ticks for the move
	move	a14,@ticks,L		; Set ticks for this move
	move	*a8+,a14,L		; Get Target X position
	move	a14,@p2x,L		; Set Ending X position
	srl	16,a14			; Lop off fractional part
	move	a14,@targ_x		; Store it as the target X position
	move	*a8+,a14,L		; Get Target Y position
	move	a14,@p2y,L		; Set Ending Y position
	srl	16,a14			; Lop off fractional part
	move	a14,@targ_y		; Store it as the target Y position
	movk	15,a10			; Number of ticks for this move
	callr	calc_dxdy		; Calculate dx and dy
#next_move
	callr	move_camera		; Move the camera
	calla	BGND_UD1		; Update the background
	SLEEPK	1			; Let it actually move
	PUSH	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	movk	1,a3
	calla	crowd_cheer		; Make the crowd cheer
	PULL	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	callr	check_camera_position	; Adjust dx and dy

	move	@dx,a14,L		; Get current dx
	move	@dy,a0,L		; Get current dy
	or	a0,a14			; Or 'em together
	jrnz	#next_move		; Done with this segment ? - br - no

	; This is probably where I want to put up different lines of text
	move	@pan_status,a14
	jrnz	#text_is_up

	SLEEPK	5

	movk	1,a14
	move	a14,@pan_status
	move	@royal_rumble,a14
	jrnz	#do_8_on_2
	calla	is_8_on_1
	jrc	#do_8_on_1

#do_3_on_1
	; Print 1vs3 congrats message - GAWD IS THIS UUUUGGGLY
	clr	a14
	jruc	#pcx
#do_8_on_2
	; Print 2vs8 congrats message - GAWD IS THIS UUUUGGGLY
	movk	2,a14
	jruc	#pcx
#do_8_on_1
	; Print 1vs8 congrats message - GAWD IS THIS UUUUGGGLY
	movk	1,a14
#pcx	callr	print_congrats
	SLEEPK	2
#text_is_up


	move	@p2x,a14,L		; Get Last End X position
	move	a14,@p1x,L		; Store as new Start X position
	move	@p2y,a14,L		; Get Last End Y position
	move	a14,@p1y,L		; Store as new Start Y position
	move	@pan_down,a14
	jrnz	#pan_done
	move	*a8,a14,L		; Get next X target
	jrnz	#p1on8_lp		; Done ? - br = no

	move	@pan_down,a14
	jrz	#pan_again

#pan_done

	movi	CLSMK3,a0
	calla	obj_del1c	; Get rid of the text when we pan back down

	move	@final_x,a14,L		; Get final X position
	move	a14,@p2x,L		; Store it as new End Y postion
	srl	16,a14			; Lop off fractional part
	move	a14,@targ_x		; Store it as the target X position
	move	@final_y,a14,L		; Get final Y position
	move	a14,@p2y,L		; Store it as new End Y postion
	srl	16,a14			; Lop off fractional part
	move	a14,@targ_y		; Store it as the target Y position

	movi	INIT_PAN_SPEED,a14
	move	a14,@ticks,L		; Store ticks for this move

	callr	calc_dxdy		; Calculate dx and dy
#npb_move
	callr	move_camera		; Move the camera
	calla	BGND_UD1		; Update the background
	SLEEPK	1			; Let it actually move
	PUSH	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	movk	1,a3
	calla	crowd_cheer		; Make the crowd cheer
	PULL	a0,a1,a2,a3,a4,a5,a6,a7,a8,a9
	callr	check_camera_position	; Adjust dx and dy

	move	@dx,a14,L		; Get current dx
	move	@dy,a0,L		; Get current dy
	or	a0,a14			; Or 'em together
	jrnz	#npb_move		; Done with last segment ? - br = no

	DIE

#*****************************************
*
 SUBRP	knockout_drones
	movi	process_ptrs,a9
#next
	move	*a9+,a8,L
	jrz	#ko_done
	move	*a8(PLYR_TYPE),a14
	jrz	#next
	movi	7fffh,a14
	move	a14,*a8(PTIME)
	jruc	#next
#ko_done
	rets

#***************************************
*
 SUBRP	#c1v3s_tbl
	.long	#congrat_1v8_1
	.long	#congrat_1v8_2
	.long	#congrat_1v8_3
;	.long	#congrat_1v8_4
;	.long	#congrat_1v8_5
	.long	#congrat_1v8_5
	.long	#congrat_1v8_6
	.long	0

 SUBRP	#c1v8s_tbl
	.long	#congrat_1v8_1
	.long	#congrat_1v8_2
	.long	#congrat_1v8_3
	.long	#congrat_1v8_4
	.long	#congrat_1v8_6
	.long	0

 SUBRP	#c2v8s_tbl
	.long	#congrat_1v8_1
	.long	#congrat_1v8_2
	.long	#congrat_1v8_3
	.long	#congrat_1v8_6
	.long	0

 SUBRP	#congrats_setup_tbl
	.long	#c1v3s_tbl
	.long	#c1v8s_tbl
	.long	#c2v8s_tbl


 SUBRP	#c1v3_tbl
	.long	#congrat_1v8_1_str
	.long	#congrat_1v3_2_str
	.long	#congrat_1v3_3_str
	.long	#congrat_1v3_4_str
	.long	#congrat_1v8_5_str

 SUBRP	#c1v8_tbl
	.long	#congrat_1v8_1_str
	.long	#congrat_1v8_2_str
	.long	#congrat_1v8_3_str
	.long	#congrat_1v8_4_str
	.long	#congrat_1v8_5_str

 SUBRP	#c2v8_tbl
	.long	#congrat_1v8_1_str
	.long	#congrat_2v8_2_str
	.long	#congrat_2v8_3_str
	.long	#congrat_2v8_4_str

 SUBRP	#congrats_str_tbl
	.long	#c1v3_tbl
	.long	#c1v8_tbl
	.long	#c2v8_tbl

; a14 = 0 - 1v3, 1 - 1vs8, 2 - 2vs 8
 SUBRP	print_congrats
	PUSH	a8,a9,a10,a11
	sll	5,a14
	move	a14,a9
	move	a14,a10
	addi	#congrats_setup_tbl,a9
	addi	#congrats_str_tbl,a10
	move	*a9,a9,L
	move	*a10,a10,L
#print_clp
	move	*a9+,a8,L
	jrz	#c_done
	move	*a10+,a11,L
	move	a8,a2
	calla	setup_message
	movi	CLSMK3,a4
	move	a4,@mess_objid
	move	a11,a4
	calla	print_string_C2
	jruc	#print_clp
#c_done
	PULL	a8,a9,a10,a11
	rets

#congrat_1v3_2_str
	.string	"YOU ARE THE INTERCONTINENTAL CHAMPION!",0
	.even
#congrat_1v3_3_str
	.string	"IT'S TIME TO SEEK A BIGGER CHALLENGE:",0
	.even
#congrat_1v3_4_str
	.string	"COMPETE FOR THE WORLD CHAMPIONSHIP!",0
	.even


#congrat_1v8_1_str
	.string	"CONGRATULATIONS!!!",0
	.even
#congrat_1v8_2_str
	.string	"YOU ARE THE NEW WWF WORLD CHAMPION!",0
	.even
#congrat_1v8_3_str
	.string	"YOUR NAME WILL LIVE FOREVER AMONG THE",0
	.even
#congrat_1v8_4_str
	.string	"GREATEST WRESTLERS OF ALL TIME!!!",0
	.even
#congrat_1v8_5_str
	.string	"...THANK YOU FOR PLAYING...",0
	.even


#congrat_2v8_2_str
	.string	"YOU ARE THE NEW WORLD WRESTLING",0
	.even
#congrat_2v8_3_str
	.string	"FEDERATION TAG TEAM CHAMPIONS!!!",0
	.even
#congrat_2v8_4_str
	.string	"PREPARE TO BATTLE EACH OTHER!!!",0
	.even


#congrat_1v8_1
	JAM_STR	wsf14_ascii,10,0,200,60,WSF_R_P,print_string_C2
	.even
#congrat_1v8_2
	JAM_STR	ogmd10_ascii,10,0,200,100,SGMD8YEL,print_string_C2
	.even
#congrat_1v8_3
	JAM_STR	ogmd10_ascii,10,0,200,113,SGMD8YEL,print_string_C2
	.even
#congrat_1v8_4
	JAM_STR	ogmd10_ascii,10,0,200,126,SGMD8YEL,print_string_C2
	.even
#congrat_1v8_5
	JAM_STR	ogmd10_ascii,10,0,200,152,SGMD8WHT,print_string_C2
	.even
#congrat_1v8_6
	JAM_STR	ogmd10_ascii,10,0,200,178,SGMD8BLU,print_string_C2
	.even


******************************************************************************

	.end
