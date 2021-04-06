**************************************************************
*
* Software:		Jamie Rivett
* Initiated:		9/10/93
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"collis.asm"
	.title	"game collision code"
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
	.include	"special.equ"


******************************************************************************
* EXTERNAL REFERENCES

	.ref	process_ptrs
	.ref	get_opp_plyrmode
	.ref	round_tickcount
	.ref	wrestler_hit
	.ref	special_hit
	.ref	wrestler_hit_special


	.ref	plyr1_objlist
	.ref	plyr2_objlist
	.ref	neutral_objlist


******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

#*****************************************************************************

 SUBR	overlap_collision


	movi	process_ptrs,a9
	movi	NUM_WRES,a10
#collis_loop
;RJR START
	.align
;RJR END
	move	*a9+,a11,L
	jrz	#inactive
	cmp	a11,a13
	jreq	#skip			;skip self


	move	*a11(ANIMODE),a0
	btst	MODE_OVERLAP_BIT,a0	;allow overlap?
	jrnz	#skip

	move	*a13(ANIMODE),a0
	move	*a11(ANIMODE),a1
	or	a1,a0
	btst	MODE_NOCOLLIS_BIT,a0
	jrnz	#skip

	move	*a11(ATTACH_PROC),a0,L		;skip this if attached
	cmp	a0,a13
	jreq	#skip


	move	*a13(PLYRMODE),a0	;if player is on ground and
	cmpi	MODE_ONGROUND,a0	;then he can't move
	jreq	#skip

	move	*a13(PLYRMODE),a0	;if player is running (or bouncing)
	cmpi	MODE_RUNNING,a0		;and opponent is on ground
	jreq	#running		;then run through him
	cmpi	MODE_BOUNCING,a0
	jrne	#not_running
#running
	calla	get_opp_plyrmode
	cmpi	MODE_ONGROUND,a0
	jreq	#skip
#not_running


	move	*a13(ANIMODE),a0
	btst	MODE_OVERLAP_BIT,a0	;allow overlap?
	jrnz	#skip

	move	*a13(OBJ_COLLX2),a5
	move	*a11(OBJ_COLLX1),a1
	sub	a1,a5			;Ax2 - Bx1
	jrle	#no_overlap		;a5 = ROX

	move	*a13(OBJ_COLLX1),a0
	move	*a11(OBJ_COLLX2),a6
	sub	a0,a6			;Bx2 - Ax1
	jrle	#no_overlap		;a6 = LOX

	move	*a13(OBJ_COLLZ2),a7
	move	*a11(OBJ_COLLZ1),a1
	sub	a1,a7			;Az2 - Bz1
	jrle	#no_overlap		;a7 = BOZ

	move	*a13(OBJ_COLLZ1),a0
	move	*a11(OBJ_COLLZ2),a8
	sub	a0,a8			;Bz2 - Az1
	jrle	#no_overlap		;a8 = TOZ

	move	*a13(OBJ_COLLY2),a1
	move	*a11(OBJ_COLLY1),a0
	sub	a0,a1			;Ay2 - By1
	jrle	#no_overlap

	move	*a13(OBJ_COLLY1),a1
	move	*a11(OBJ_COLLY2),a0
	sub	a1,a0			;By2 - Ay1
	jrle	#no_overlap

	move	*a13(PLYRMODE),a0
	cmpi	MODE_RUNNING,a0
	jreq	#up_down

	move	a5,a0
	cmp	a6,a5			;a5-a6	(ROX-LOX)
	jrlt	#rox_min
	move	a6,a0
#rox_min
	move	a7,a1
	cmp	a8,a7			;a7-a8	(BOZ-TOZ)
	jrlt	#boz_min
	move	a8,a1
#boz_min

	move	*a11(PLYRMODE),a14	;if opp is on ground then
	cmpi	MODE_ONGROUND,a14	;slide off in Z
	jrne	#skp

	srl	1,a0			;DZ / 2
#skp

	cmp	a1,a0			;a0-a1	(MOX-MOZ)

;MJT Start
	jrgt	#up_down


;X glitch too big?
	cmpi	3dh,a1
	jrgt	#up_down
;MJT End


;#left_right

	cmp	a6,a5			;a5-a6	(ROX-LOX)
	jrgt	#right

;#left
	move	*a13(OBJ_XPOSINT),a0
	sub	a5,a0			;XPOS-ROX
	move	a0,*a13(OBJ_XPOSINT)

	jruc	#ud2

#right
	move	*a13(OBJ_XPOSINT),a0
	add	a6,a0			;XPOS+LOX
	move	a0,*a13(OBJ_XPOSINT)

#ud2
	move	*a13(MOVE_DIR),a0
	jrz	#exit
	andi	MOVE_UP|MOVE_DOWN,a0
	jrnz	#exit

	movi	3,a0
	cmp	a8,a7			;a7-a8	(BOZ-TOZ)
	jrgt	#d2
	neg	a0
#d2
	move	*a13(OBJ_ZPOSINT),a14
	add	a0,a14
	move	a14,*a13(OBJ_ZPOSINT)
	rets





#up_down
	cmp	a8,a7			;a7-a8	(BOZ-TOZ)
	jrgt	#down
;#up
	move	*a13(OBJ_ZPOSINT),a0
	sub	a7,a0			;XPOS-BOZ
	move	a0,*a13(OBJ_ZPOSINT)
	jruc	#lr2

#down
	move	*a13(OBJ_ZPOSINT),a0
	add	a8,a0			;XPOS-TOZ
	move	a0,*a13(OBJ_ZPOSINT)

#lr2
	move	*a13(MOVE_DIR),a0
	jrz	#exit
	andi	MOVE_LEFT|MOVE_RIGHT,a0
	jrnz	#exit

	movi	3,a0
	cmp	a6,a5			;a5-a6	(ROX-LOX)
	jrgt	#r2
	neg	a0
#r2
	move	*a13(OBJ_XPOSINT),a14
	add	a0,a14
	move	a14,*a13(OBJ_XPOSINT)
	rets






#no_overlap

#skip
#inactive
	dsj	a10,#collis_loop
#exit
	rets

#*****************************************************************************

 SUBR	set_collision_boxes


	move	*a13(CUR_FRAME),a4,L

;;	move	*a4(12*16),*a13(OBJ_BOXXOFF)	;x off
;;	move	*a4(13*16),*a13(OBJ_BOXYOFF)	;y off
;;	move	*a4(14*16),*a13(OBJ_BOXWIDTH)	;width
;;	move	*a4(15*16),*a13(OBJ_BOXHEIGHT)	;height

	movi	-30,a0
	move	a0,*a13(OBJ_BOXZOFF)
	movi	60,a0
	move	a0,*a13(OBJ_BOXDEPTH)

	move	*a13(PLYRMODE),a0
	cmpi	MODE_ONGROUND,a0

;If running, have a smaller Z depth

	jrnz	#next

	movi	-15,a0
	move	a0,*a13(OBJ_BOXZOFF)
	movi	30,a0
	move	a0,*a13(OBJ_BOXDEPTH)
	jruc	#norm

#next
	cmpi	MODE_RUNNING,a0
	jrnz	#norm

	movi	-5,a0
	move	a0,*a13(OBJ_BOXZOFF)
	movi	10,a0
	move	a0,*a13(OBJ_BOXDEPTH)

#norm



;***********************************************************
;
;XJR	- maybe add 100 or so to the initial Y-pos so
;	  that colly1 or y2 never become negative...
;
;***********************************************************



	move	*a13(OBJ_YPOSINT),a0
	move	*a4(14*16),a1		;BOX YOFF
	sub	a1,a0
	move	a0,*a13(OBJ_COLLY2)
	move	*a4(16*16),a1		;BOX HEIGHT
	sub	a1,a0
	move	a0,*a13(OBJ_COLLY1)

	move	*a13(OBJ_ZPOSINT),a0
	move	*a13(OBJ_BOXZOFF),a1
	add	a1,a0
	move	a0,*a13(OBJ_COLLZ1)
	move	*a13(OBJ_BOXDEPTH),a1
	add	a1,a0
	move	a0,*a13(OBJ_COLLZ2)

	move	*a13(OBJ_CONTROL),a0
	btst	B_FLIPH,a0
	jrz	#not_flipped

;#flipped
	move	*a13(OBJ_XPOSINT),a0
	move	*a4(13*16),a1		;BOX XOFF
	sub	a1,a0
	move	a0,*a13(OBJ_COLLX2)
	move	*a4(15*16),a1		;BOX WIDTH
	sub	a1,a0
	move	a0,*a13(OBJ_COLLX1)
	rets

#not_flipped
	move	*a13(OBJ_XPOSINT),a0
	move	*a4(13*16),a1		;BOX XOFF
	add	a1,a0
	move	a0,*a13(OBJ_COLLX1)
	move	*a4(15*16),a1		;BOX WIDTH
	add	a1,a0
	move	a0,*a13(OBJ_COLLX2)
	rets

#*****************************************************************************

	.bss	x1,16
	.bss	x2,16
	.bss	y1,16
	.bss	y2,16
	.bss	z1,16
	.bss	z2,16


 SUBR	check_collisions


	callr	object_collisions

	PUSH	a13


	move	@round_tickcount,a0
	andi	1,a0
	jrz	#even



;odd
	movi	process_ptrs+32*NUM_WRES,a4
	movi	NUM_WRES,a5
#collis_loop1
	move	-*a4,a10,L
	jrz	#inactive1

	move	*a10(ANIMODE),a0
	btst	MODE_CHECKHIT_BIT,a0
	jrz	#inactive1

	PUSH	a4,a5

	callr	set_xyz


	movi	process_ptrs,a4
	movi	NUM_WRES,a5
#collis_loop2
	move	*a4+,a13,L
	jrz	#inactive2
	cmp	a10,a13
	jreq	#skip_self

	PUSH	a4,a5

	callr	check_collis

	PULL	a4,a5
	move	*a10(ANIMODE),a0
	btst	MODE_STATUS_BIT,a0	;hit someone?
	jrnz	#done
#skip_self
#inactive2
	dsj	a5,#collis_loop2



	PULL	a4,a5
#inactive1
	dsj	a5,#collis_loop1

	PULL	a13
	rets

#done
	PULL	a4,a5
	PULL	a13
	rets



#even
#*
	movi	process_ptrs,a4
	movi	NUM_WRES,a5
#collis_loop1
	move	*a4+,a10,L
	jrz	#inactive1

	move	*a10(ANIMODE),a0
	btst	MODE_CHECKHIT_BIT,a0
	jrz	#inactive1

	PUSH	a4,a5

	callr	set_xyz


	movi	process_ptrs,a4
	movi	NUM_WRES,a5
#collis_loop2
	move	*a4+,a13,L
	jrz	#inactive2
	cmp	a10,a13
	jreq	#skip_self

	PUSH	a4,a5

	callr	check_collis

	PULL	a4,a5
	move	*a10(ANIMODE),a0
	btst	MODE_STATUS_BIT,a0	;hit someone?
	jrnz	#done
#skip_self
#inactive2
	dsj	a5,#collis_loop2



	PULL	a4,a5
#inactive1
	dsj	a5,#collis_loop1


	PULL	a13
	rets
#done
	PULL	a4,a5
	PULL	a13
	rets

#*****************************************************************************
* a10 = * offensive process
* a13 = * defensive process

 SUBRP	check_collis

	move	*a13(ANIMODE),a0
	btst	MODE_NOCOLLIS_BIT,a0
	jrnz	#no_hit

	move	*a13(SAFE_TIME),a0
	jrnz	#no_hit

	move	@x1,a0
	move	*a13(OBJ_COLLX2),a1
	cmp	a0,a1		;Dx2 - Ox1
	jrlt	#no_hit		;if Dx2 < Ox1

	move	@x2,a0
	move	*a13(OBJ_COLLX1),a1
	cmp	a0,a1		;Dx1 - Ox2
	jrgt	#no_hit		;if Dx1 > Ox2

	move	@y1,a0
	move	*a13(OBJ_COLLY2),a1
	cmp	a0,a1		;Dy2 - Oy1
	jrlt	#no_hit		;if Dy2 < Oy1

	move	@y2,a0
	move	*a13(OBJ_COLLY1),a1
	cmp	a0,a1		;Dy1 - Oy2
	jrgt	#no_hit		;if Dy1 > Oy2

	move	@z1,a0
	move	*a13(OBJ_COLLZ2),a1
	cmp	a0,a1		;Dz2 - Oz1
	jrlt	#no_hit		;Dz2 < Oz1

	move	@z2,a0
	move	*a13(OBJ_COLLZ1),a1
	cmp	a0,a1		;Dz1 - Oz2
	jrgt	#no_hit		;Dz1 > Oz2

	;if attacker is in MODE_WAITHITOPP, clear said bit and zero ANICNTs.
	move	*a10(ANIMODE),a14
	btst	MODE_WAITHITOPP_BIT,a14
	jrz	#skip_whopp

	andni	MODE_WAITHITOPP,a14
	move	a14,*a10(ANIMODE)
	clr	a14
	move	a14,*a10(ANICNT)
	move	a14,*a10(ANICNT2)
#skip_whopp

	move	a10,*a13(WHOHITME),L
	move	a13,*a10(WHOIHIT),L

	clr	a14			;false
	move	*a13(PLYRMODE),a0
	cmpi	MODE_BLOCK,a0
	jrne	#noblock
	inc	a14			;true
#noblock
	move	a14,*a10(HITBLOCKER)

	movi	MOVE_RIGHT,a0
	move	*a10(OBJ_XPOSINT),a1
	move	*a13(OBJ_XPOSINT),a2
	cmp	a2,a1
	jrgt	#hit_from_right
	movi	MOVE_LEFT,a0
#hit_from_right
	movi	MOVE_DOWN,a14
	move	*a10(OBJ_ZPOS),a1,L
	move	*a13(OBJ_ZPOS),a2,L
	cmp	a2,a1
	jrgt	#hit_from_below
	movi	MOVE_UP,a14
#hit_from_below
	or	a14,a0
	move	a0,*a13(PLYR_HIT_SIDE)
	move	a0,*a10(PLYR_HIT_SIDE)

	move	*a10(ANIMODE),a0
	ori	MODE_STATUS,a0		;this flag set whenever
	move	a0,*a10(ANIMODE)	;a successful hit

	calla	wrestler_hit
#no_hit
	rets



#*****************************************************************************
* a10 = *process
* sets x1,x2,y1,y2,z1 and z2

 SUBRP set_xyz

	move	*a10(OBJ_YPOSINT),a0
	move	*a10(OBJ_ATTYOFF),a1
	add	a1,a0
	move	a0,@y1
	move	*a10(OBJ_ATTHEIGHT),a1
	add	a1,a0
	move	a0,@y2

	move	*a10(OBJ_ZPOSINT),a0
	move	*a10(OBJ_ATTZOFF),a1
	add	a1,a0
	move	a0,@z1
	move	*a10(OBJ_ATTDEPTH),a1
	add	a1,a0
	move	a0,@z2


;	move	*a10(FACING_DIR),a14
;	btst	PLAYER_RIGHT_BIT,a14
;	jrnz	#facing_right

	move	*a10(OBJ_CONTROL),a14
	btst	B_FLIPH,a14
	jrz	#facing_right


;facing_left
	move	*a10(OBJ_XPOSINT),a0
	move	*a10(OBJ_ATTXOFF),a1
	sub	a1,a0
	move	a0,@x2
	move	*a10(OBJ_ATTWIDTH),a1
	sub	a1,a0
	move	a0,@x1
	rets

#facing_right
	move	*a10(OBJ_XPOSINT),a0
	move	*a10(OBJ_ATTXOFF),a1
	add	a1,a0
	move	a0,@x1
	move	*a10(OBJ_ATTWIDTH),a1
	add	a1,a0
	move	a0,@x2

	rets


#*****************************************************************************
*
* a10 = * wrestler process to turn collisions off

 SUBR	wres_collis_off

	move	*a10(ANIMODE),a0
	andni	MODE_CHECKHIT,a0
	move	a0,*a10(ANIMODE)
	rets


#*****************************************************************************

 SUBR	object_collisions

;MJT Start
;FIX!!!  This can point to a non existent proc
;MJT End

	movi	plyr1_objlist,a0
	callr	set_spobj_boxes

	movi	plyr2_objlist,a0
	callr	set_spobj_boxes

	movi	neutral_objlist,a0
	callr	set_spobj_boxes


	movi	plyr1_objlist,a6
	movi	plyr2_objlist,a7
	callr	objlist2objlist_collis


	movi	plyr1_objlist,a10
	callr	objlist2player_collis

	movi	plyr2_objlist,a10
	callr	objlist2player_collis

	movi	neutral_objlist,a10
	callr	objlist2player_collis


	rets


#*****************************************************************************
;a10 = objlist1

objlist2player_collis

	PUSH	a13

	move	*a10,a10,L
	jrz	#done
#lp1

	move	*a10(SP_COLLX1),a0
	move	*a10(SP_COLLX2),a1

	move	*a10(SP_COLLY1),a2
	move	*a10(SP_COLLY2),a3

	move	*a10(SP_COLLZ1),a4
	move	*a10(SP_COLLZ2),a5


	movi	process_ptrs,a7
	movi	NUM_WRES,a6
#collis_loop
	move	*a7+,a13,L
	jrz	#inactive

;MJT Start
	move	*a13(ANIMODE),a14
	btst	MODE_NOCOLLIS_BIT,a14
	jrnz	#no_hit
;MJT End

;check if projectile should hit this guy...(same side)

	move	*a13(OBJ_COLLX2),a14
	cmp	a0,a14		;Dx2 - Ox1
	jrlt	#no_hit		;if Dx2 < Ox1

	move	*a13(OBJ_COLLX1),a14
	cmp	a1,a14		;Dx1 - Ox2
	jrgt	#no_hit		;if Dx1 > Ox2

	move	*a13(OBJ_COLLY2),a14
	cmp	a2,a14		;Dy2 - Oy1
	jrlt	#no_hit		;if Dy2 < Oy1

	move	*a13(OBJ_COLLY1),a14
	cmp	a3,a14		;Dy1 - Oy2
	jrgt	#no_hit		;if Dy1 > Oy2

	move	*a13(OBJ_COLLZ2),a14
	cmp	a4,a14		;Dz2 - Oz1
	jrlt	#no_hit		;Dz2 < Oz1

	move	*a13(OBJ_COLLZ1),a14
	cmp	a5,a14		;Dz1 - Oz2
	jrgt	#no_hit		;Dz1 > Oz2

;hit
	calla	wrestler_hit_special

	jruc	#done

#no_hit
#inactive
	dsj	a6,#collis_loop


	move	*a10(SP_NEXT),a10,L
	jrnz	#lp1

#done

	PULL	a13
	rets


#*****************************************************************************
;a6 = objlist1
;a7 = objlist2

objlist2objlist_collis

	move	*a6,a6,L
	jrz	#done
#lp1
	move	a7,a8
	move	*a8,a8,L
	jrz	#done

	move	*a6(SP_COLLX1),a0
	move	*a6(SP_COLLX2),a1

	move	*a6(SP_COLLY1),a2
	move	*a6(SP_COLLY2),a3

	move	*a6(SP_COLLZ1),a4
	move	*a6(SP_COLLZ2),a5

#lp2
	move	*a8(SP_COLLX2),a14
	cmp	a0,a14		;Dx2 - Ox1
	jrlt	#no_hit		;if Dx2 < Ox1

	move	*a8(SP_COLLX1),a14
	cmp	a1,a14		;Dx1 - Ox2
	jrgt	#no_hit		;if Dx1 > Ox2

	move	*a8(SP_COLLY2),a14
	cmp	a2,a14		;Dy2 - Oy1
	jrlt	#no_hit		;if Dy2 < Oy1

	move	*a8(SP_COLLY1),a14
	cmp	a3,a14		;Dy1 - Oy2
	jrgt	#no_hit		;if Dy1 > Oy2

	move	*a8(SP_COLLZ2),a14
	cmp	a4,a14		;Dz2 - Oz1
	jrlt	#no_hit		;Dz2 < Oz1

	move	*a8(SP_COLLZ1),a14
	cmp	a5,a14		;Dz1 - Oz2
	jrgt	#no_hit		;Dz1 > Oz2

;hit
	calla	special_hit

	jruc	#done

#no_hit

	move	*a8(SP_NEXT),a8,L
	jrnz	#lp2

	move	*a6(SP_NEXT),a6,L
	jrnz	#lp1

#done
	rets


#*****************************************************************************

set_spobj_boxes

	move	*a0,a0,L
	jrz	#done
#lp

	move	*a0(SP_OBJ_YPOSINT),a1
	move	*a0(SP_YOFF),a14
	add	a14,a1
	move	a1,*a0(SP_COLLY1)
	move	*a0(SP_HEIGHT),a14
	add	a14,a1
	move	a1,*a0(SP_COLLY2)


	move	*a0(SP_OBJ_ZPOSINT),a1
	move	*a0(SP_ZOFF),a14
	add	a14,a1
	move	a1,*a0(SP_COLLZ1)
	move	*a0(SP_DEPTH),a14
	add	a14,a1
	move	a1,*a0(SP_COLLZ2)


	move	*a0(SP_OBJCONTROL),a14
	btst	B_FLIPH,a14
	jrz	#not_flipped

;#flipped
	move	*a0(SP_OBJ_XPOSINT),a1
	move	*a0(SP_XOFF),a14
	sub	a14,a1
	move	a1,*a0(SP_COLLX2)
	move	*a0(SP_WIDTH),a14
	sub	a14,a1
	move	a1,*a0(SP_COLLX1)
	jruc	#cnt

#not_flipped
	move	*a0(SP_OBJ_XPOSINT),a1
	move	*a0(SP_XOFF),a14
	add	a14,a1
	move	a1,*a0(SP_COLLX1)
	move	*a0(SP_WIDTH),a14
	add	a14,a1
	move	a1,*a0(SP_COLLX2)

#cnt
	move	*a0(SP_NEXT),a0,L
	jrnz	#lp

#done
	rets


******************************************************************************
	.end
