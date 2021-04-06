*************************************************************
*
* Software:		Jason Skiles
* Initiated:		9 March 94
*
* COPYRIGHT (C) 1995 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************

	.file	"ropes.asm"
	.title	"rope code"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"display.equ"
	.include	"game.equ"
	.include	"macros.h"
	.include	"mproc.equ"
	.include	"sys.equ"
	.include	"ring.equ"

	.include	"miscimg.glo"
	.include	"ropeimg.glo"

******************************************************************************
* EXTERNAL REFERENCES

	.ref	XFERPROC,front_rproc,reduce_bog

******************************************************************************
* SYMBOLS DEFINED IN THIS FILE

******************************************************************************
* EQUATES FOR THIS FILE

;Don't add any more rope commands!  It won't work.  RANI_SETPRIORITY
; was only being used in one place, and it wasn't doing much, so to strip
; this time-comsuming rope thing down, I've removed most of the command
; structure, and any word with bit 15 set will be treated as RANI_GOTO.

RANI_GOTO		.equ	0 + 8000h

SSPRING_PRI	.equ	10
DSPRING_PRI	.equ	9
SHAKE_PRI	.equ	5

#*****************************************************************************
*
* IN: a11 = group # (0=front, 1=back, 2=left, 3=right )
*

	STRUCTPD

	LONG	ROPE_ACTION		;UHW

	LONG	#RED_OBJ		;UHL top rope
	LONG	#RED_OBJ2		;UHL top rope (right half)
	LONG	#RED_SCPTR		;UHL top rope script ptr
	WORD	#RED_SCCNT		;UHW top rope script counter
	LONG	#RED_SQPTR		;UHL top rope sequence ptr
	WORD	#RED_SQCNT		;UHW top rope sequence counter
	WORD	#RED_PRIORITY		;UHW top rope anim priority

	LONG	#WHITE_OBJ		;UHL middle rope
	LONG	#WHITE_OBJ2		;UHL middle rope (right half)
	LONG	#WHITE_SCPTR		;UHL middle rope script ptr
	WORD	#WHITE_SCCNT		;UHW middle rope script counter
	LONG	#WHITE_SQPTR		;UHL middle rope sequence ptr
	WORD	#WHITE_SQCNT		;UHW middle rope sequence counter
	WORD	#WHITE_PRIORITY		;UHW middle rope anim priority

	LONG	#BLUE_OBJ 		;UHL bottom rope
	LONG	#BLUE_OBJ2 		;UHL bottom rope (right half)
	LONG	#BLUE_SCPTR		;UHL bottom rope script ptr
	WORD	#BLUE_SCCNT		;UHW bottom rope script counter
	LONG	#BLUE_SQPTR		;UHL bottom rope sequence ptr
	WORD	#BLUE_SQCNT		;UHW bottom rope sequence counter
	WORD	#BLUE_PRIORITY		;UHW bottom rope anim priority

	LONG	#SHAD_OBJ 		;UHL rope shadow
	LONG	#SHAD_OBJ2 		;UHL rope shadow (right half)
	LONG	#SHAD_SCPTR		;UHL rope shadow script ptr
	WORD	#SHAD_SCCNT		;UHW rope shadow script counter
	LONG	#SHAD_SQPTR		;UHL rope shadow sequence ptr
	WORD	#SHAD_SQCNT		;UHW rope shadow sequence counter
	WORD	#SHAD_PRIORITY		;UHW rope shadow anim priority

PDBLKSTART	.equ	#RED_OBJ
PDBLKSIZ	.equ	#WHITE_OBJ-#RED_OBJ


PD_OBJ		.equ	#RED_OBJ - #RED_OBJ
PD_OBJ2		.equ	#RED_OBJ2 - #RED_OBJ
PD_SCPTR	.equ	#RED_SCPTR - #RED_OBJ
PD_SCCNT	.equ	#RED_SCCNT - #RED_OBJ
PD_SQPTR	.equ	#RED_SQPTR - #RED_OBJ
PD_SQCNT	.equ	#RED_SQCNT - #RED_OBJ
PD_PRIORITY	.equ	#RED_PRIORITY - #RED_OBJ


	;reg use (overall)
	; a11 = * to our entry in the #master_table

 SUBR	rope

	;position a11 at the beginning of the #master_table entry for
	; the current bank of ropes.
	move	a11,a10
	movi	#mtable_size,a14
	mpyu	a14,a11
	addi	#master_table,a11

	;set priority and action
	clr	a14
	move 	a14,*a13(ROPE_ACTION),L

	;initialize the shadow stuff to zero in case this is a horz rope
	clr	a14
	move	a14,*a13(#SHAD_OBJ),L
	move	a14,*a13(#SHAD_OBJ2),L
	move	a14,*a13(#SHAD_SCPTR),L
	move	a14,*a13(#SHAD_SCCNT),W
	move	a14,*a13(#SHAD_SQPTR),L
	move	a14,*a13(#SHAD_SQCNT),W
	move	a14,*a13(#SHAD_PRIORITY),W

	;reg use (creation)
	; a0-a8 - create stuff
	; a9    - #???_OBJ ptr
	; a10   - pointer to initial position table entry

	;create the ropes
	move	*a11(#POS_TABLE),a10,L
	move	a13,a9
	addi	#RED_OBJ,a9

#create_loop
	move	*a10+,a2,L
	jrz	#first3_done
	move	*a10+,a4,W
	ori	DMAWNZ|M_3D,a4
	move	*a10+,a5,W
	move	*a10+,a0,W
	move	*a10+,a1,W
	move	*a10+,a3,W
	clr	a6
	clr	a7

	;This is ugly as sin, but it'll do for now.
	addi	104,a0
	addi	-258,a1

#no_flip
	
	sla	16,a0
	sla	16,a1

	calla	BEGINOBJ

	;set the various rope PDATA
	move	a8,*a9(PD_OBJ),L
	clr	a8
	move	a8,*a9(PD_OBJ2),L
	move	a8,*a9(PD_SCPTR),L
	move	a8,*a9(PD_SCCNT),W
	move	a8,*a9(PD_SQPTR),L
	move	a8,*a9(PD_SQCNT),W
	move	a8,*a9(PD_PRIORITY),W
	addi	PDBLKSIZ,a9
	jruc	#create_loop

#first3_done
	;first three objects down and we hit one zero.  If there's another
	; zero after that one, then we're done.  If there's another table
	; entry, then we need to make three more ropes and stick them in
	; the OBJ2 slots.  These are the right-half ropes in the front and
	; back banks, and the bottom-half ropes on the sides

	move	a13,a9
	addi	#RED_OBJ,a9

#create2_loop
	move	*a10+,a2,L
	jrz	#create_done
	move	*a10+,a4,W
	ori	DMAWNZ|M_3D,a4
	move	*a10+,a5,W
	move	*a10+,a0,W
	move	*a10+,a1,W
	move	*a10+,a3,W
	clr	a6
	clr	a7

	;This is ugly as sin, but it'll do for now.
	addi	104,a0
	addi	-258,a1

#no_flip2
	
	sla	16,a0
	sla	16,a1

	calla	BEGINOBJ

	;set the various rope PDATA
	move	a8,*a9(PD_OBJ2),L
	addi	PDBLKSIZ,a9

	jruc	#create2_loop

new_command_wake
	;the only way to get here is an XFERPROC.
	;read our new orders from pdata ROPE_ACTION and carry them out.
	move	*a13(ROPE_ACTION),a0,L

	;prepare the red rope pointers
	move	*a0+,a14,W		;priority check
	move	*a0+,a1,L
	move	*a13(#RED_PRIORITY),a2,W
	cmp	a14,a2
	jrgt	#skip_red
	move	a14,*a13(#RED_PRIORITY),W
	move	a1,*a13(#RED_SCPTR),L
	move	*a1+,a2,W
	move	a2,*a13(#RED_SCCNT),W
	move	*a1+,a2,L
	move	a2,*a13(#RED_SQPTR),L
	movk	1,a2
	move	a2,*a13(#RED_SQCNT),W
#skip_red

	;prepare the white rope pointers
	move	*a0+,a14,W		;priority check
	move	*a0+,a1,L
	move	*a13(#WHITE_PRIORITY),a2,W
	cmp	a14,a2
	jrgt	#skip_white
	move	a14,*a13(#WHITE_PRIORITY),W
	move	a1,*a13(#WHITE_SCPTR),L
	move	*a1+,a2,W
	move	a2,*a13(#WHITE_SCCNT),W
	move	*a1+,a2,L
	move	a2,*a13(#WHITE_SQPTR),L
	movk	1,a2
	move	a2,*a13(#WHITE_SQCNT),W
#skip_white

	;prepare the blue rope pointers
	move	*a0+,a14,W		;priority check
	move	*a0+,a1,L
	move	*a13(#BLUE_PRIORITY),a2,W
	cmp	a14,a2
	jrgt	#skip_blue
	move	a14,*a13(#BLUE_PRIORITY),W
	move	a1,*a13(#BLUE_SCPTR),L
	move	*a1+,a2,W
	move	a2,*a13(#BLUE_SCCNT),W
	move	*a1+,a2,L
	move	a2,*a13(#BLUE_SQPTR),L
	movk	1,a2
	move	a2,*a13(#BLUE_SQCNT),W

#skip_blue
	;prepare the rope shadow pointers
	move	*a13(#SHAD_OBJ),a14,L	;exist check
	jrz	#skip_shadow

	move	*a0+,a14,W		;priority check
	move	*a0+,a1,L
	move	*a13(#SHAD_PRIORITY),a2,W
	cmp	a14,a2
	jrgt	#skip_shadow
	move	a14,*a13(#SHAD_PRIORITY),W
	move	a1,*a13(#SHAD_SCPTR),L
	move	*a1+,a2,W
	move	a2,*a13(#SHAD_SCCNT),W
	move	*a1+,a2,L
	move	a2,*a13(#SHAD_SQPTR),L
	movk	1,a2
	move	a2,*a13(#SHAD_SQCNT),W

#skip_shadow
	jruc	#main_loop


#master_table
	.long	#front_ptable
	.long	#back_ptable
#siderope_start
	.long	#left_ptable
	.long	#right_ptable
#master_tablex

#mtable_size	.equ	(#master_tablex-#master_table)/4

#POS_TABLE	.equ	0


;Initial position tables


#front_ptable
	;FRONT LEFT
	LWWWWW	ROPE_F_R,0,CLSNEUT|SUBROPE|SUBHORZ,673+1,402-2,015aah
	LWWWWW	ROPE_F_W,0,CLSNEUT|SUBROPE|SUBHORZ,671+1,426-2,015aah
	LWWWWW	ROPE_F_B,0,CLSNEUT|SUBROPE|SUBHORZ,672+1,449-2,015aah
	.long	0

	;FRONT RIGHT
	LWWWWW	ROPE_F_R,M_FLIPH,CLSNEUT|SUBROPE|SUBHORZ,919+349,402-2,015aah
	LWWWWW	ROPE_F_W,M_FLIPH,CLSNEUT|SUBROPE|SUBHORZ,919+349,426-2,015aah
	LWWWWW	ROPE_F_B,M_FLIPH,CLSNEUT|SUBROPE|SUBHORZ,922+349,449-2,015aah
	.long	0,0


#back_ptable
	;BACK LEFT
	LWWWWW	ROPE_B_R,0,CLSNEUT|SUBROPE|SUBHORZ,749+1,318-2,013cah
	LWWWWW	ROPE_B_W,0,CLSNEUT|SUBROPE|SUBHORZ,749+1,341-2,013cah
	LWWWWW	ROPE_B_B,0,CLSNEUT|SUBROPE|SUBHORZ,749+1,364-2,013cah
	.long	0

	;BACK RIGHT
	LWWWWW	ROPE_B_R,M_FLIPH,CLSNEUT|SUBROPE|SUBHORZ,1093+101-3,318-2,013cah
	LWWWWW	ROPE_B_W,M_FLIPH,CLSNEUT|SUBROPE|SUBHORZ,1093+101-3,341-2,013cah
	LWWWWW	ROPE_B_B,M_FLIPH,CLSNEUT|SUBROPE|SUBHORZ,1093+101-3,364-2,013cah
	.long	0,0



#left_ptable
	;LEFT TOP
	LWWWWW	ROPE_S_Ra,0,CLSNEUT|SUBROPE|SUBSIDE,676+1,323-2,013cch
	LWWWWW	ROPE_S_Wa,0,CLSNEUT|SUBROPE|SUBSIDE,676+1,346-2,013cbh
	LWWWWW	ROPE_S_Ba,0,CLSNEUT|SUBROPE|SUBSIDE,676+1,369-2,013cah
	LWWWWW	ROPSHADA,0,CLSNEUT|SUBROPE|SUBSIDE,2c7h,189h,013c8h
	.long	0

	;LEFT BOTTOM
	LWWWWW	ROPE_S_Rb,0,CLSNEUT|SUBROPE|SUBSIDE,676+1,323-2,013cch
	LWWWWW	ROPE_S_Wb,0,CLSNEUT|SUBROPE|SUBSIDE,676+1,346-2,013cbh
	LWWWWW	ROPE_S_Bb,0,CLSNEUT|SUBROPE|SUBSIDE,676+1,369-2,013cah
	LWWWWW	ROPSHADB,0,CLSNEUT|SUBROPE|SUBSIDE,2c7h,189h,013c8h
	.long	0,0

#right_ptable
	;RIGHT TOP
	LWWWWW	ROPE_S_Ra,M_FLIPH,CLSNEUT|SUBROPE|SUBSIDE,1164+1+100,322-2,013cch
	LWWWWW	ROPE_S_Wa,M_FLIPH,CLSNEUT|SUBROPE|SUBSIDE,1164+1+100,345-2,013cbh
	LWWWWW	ROPE_S_Ba,M_FLIPH,CLSNEUT|SUBROPE|SUBSIDE,1164+1+100,368-2,013cah
	LWWWWW	ROPSHADA,M_FLIPH,CLSNEUT|SUBROPE|SUBSIDE,469h+100,189h,013c8h
	.long	0

	;RIGHT BOTTOM
	LWWWWW	ROPE_S_Rb,M_FLIPH,CLSNEUT|SUBROPE|SUBSIDE,1164+1+100,322-2,013cch
	LWWWWW	ROPE_S_Wb,M_FLIPH,CLSNEUT|SUBROPE|SUBSIDE,1164+1+100,345-2,013cbh
	LWWWWW	ROPE_S_Bb,M_FLIPH,CLSNEUT|SUBROPE|SUBSIDE,1164+1+100,368-2,013cah
	LWWWWW	ROPSHADB,M_FLIPH,CLSNEUT|SUBROPE|SUBSIDE,469h+100,189h,013c8h
	.long	0,0

#create_done

	;sleep a bit, then check the reduce_bog flag
	SLEEPK	2
	move	@reduce_bog,a14
	jrz	#bog_ok

	cmpi	#siderope_start,a11
	jrge	#bog_ok

	;we're a front or back rope.  Die.

	;while we're at it, clear the front and back rope processes
	movi	front_rproc,a0
	clr	a14
	move	a14,*a0+,L
	move	a14,*a0,L
	DIE

	;yikes!  We're in bog-reduction mode.  Die if we're a horz rope proc.

#bog_ok	;reg use (main loop)
	; a9  -  permanent storage of rope_update() address
	;a10  -  temp storage of rope_update() address
	;a11  -  pointer to our entry in the #master_table

	movi	rope_update,a9

	.align

#main_loop
	SLEEPK	1

	move	a13,a5
	addi	#RED_OBJ,a5		;top rope

	movi	fastanic,a1		;required by rope_update
	movi	PDBLKSIZ,a3

	movk	4,a2

#tightloop
	move	a9,a10
	exgpc	a10
	add	a3,a5
	dsjs	a2,#tightloop
	jruc	#main_loop

#*****************************************************************************
*
*  a5 = ptr to section of PDATA for the current rope (use those PD_???
*       offsets defined earlier to access the data )
*
*  a1 = address of fastanic routine (helps speed things up a shade)
*
* a10 = return address (this routine is called with exgpc)
*

;NOTES:
;	PD_OBJ contains the object pointer for a rope
;	---> since PD_OBJ is zero, we simply use *aN instead of *aN(PD_OBJ)
;	PD_SCPTR points to the CURRENTLY ACTIVE sequence in the script
;		table.
;	PD_SCCNT is the number of repetitions of a the current sequence
;		to be performed.
;	PD_SQPTR points to the NEXT frame in the current sequence.
;	PD_SQCNT is the number of ticks to hold the current frame.
;

	;WARNING!!!!!
	;This routine is heavily compacted in the name of speed and size
	; optimization.  It makes heavy use of questionable assumptions
	; about the contents of various registers and how long said
	; contents are to remain valid.  It works, but any changes are
	; quite likely to topple the whole rickety mess.  Watch out.

 SUBRP	rope_update

	;time to move on to the next frame in our sequence?
	move	*a5(PD_SQCNT),a6,W
	jrz	#done			;not even IN a sequence.  quit

	;make sure this rope exists
	move	*a5,a8,L	;*a5 == *a5(PD_OBJ)
	jrz	#done		;rope doesn't exist.  ignore it.

	;dec frame time
	dec	a6
	jrnz	#hold_current_frame

#new_sequence_frame
	;timer has run out on current frame.  get a new one.
	move	*a5(PD_SQPTR),a6,L
	move	*a6+,a7,W		;next time increment
	jrp	#next_frame
	jrn	#sequence_goto

#end_of_sequence
	;that was the last frame in the sequence.  look at the script.
	move	*a5(PD_SCCNT),a6,W
	dec	a6
	jrnz	#repeat_sequence

	;move on to the next sequence
#new_sequence
	move	*a5(PD_SCPTR),a6,L
	addi	30h,a6			;point at next entry
	move	a6,*a5(PD_SCPTR),L	;and stuff it.
	move	*a6,a6,W		;get the repeat count
	jrp	#repeat_sequence
	jrn	#script_goto

#end_of_script
	clr	a14
	move	a14,*a5(PD_SQCNT),L	;This hits both CNT and PRIORITY

#done
	jump	a10

	;it's some kind of special command
	;Just assume it's a goto, the only legal command these days.
#sequence_goto
	move	*a6(0),*a5(PD_SQPTR),L
	jruc	#new_sequence_frame

#hold_current_frame
	;timer hasn't run out on current frame.  stuff the new counter
	; and return
	move	a6,*a5(PD_SQCNT),W
	jump	a10		;return address

	;there's another valid frame in the sequence.  use it.
#next_frame
	;figure out if this is a front/back rope or a side rope.  They're
	; handled differently.
	move	*a8(OID),a14,W

	move	a7,*a5(PD_SQCNT),W

	btst	SUBHORZ_BIT,a14
	jrnz	#fb_rope


#side_rope	;it's a side rope
	;for these ropes, the 'image' in the sequence is a label where
	; we'll find the top and bottom image header pointers, in that order.
	; thus the extra indirection.
	move	*a6+,a7,L
	move	*a7+,a0,L
	move	*a7,a4,L

#rope_common
	move	a1,a14		;a1 = fastanic
	exgpc	a14
	move	*a5(PD_OBJ2),a8,L

	move	a4,a0
	move	a1,a14		;a1 = fastanic
	exgpc	a14
	move	a6,*a5(PD_SQPTR),L
	jump	a10		;return address

#fb_rope	;it's a front or back rope
	;for these ropes, the image is in the sequence, and it's used
	; for both halves.  The one on the right is flipped.
	move	*a6+,a0,L
	move	a0,a4
	jruc	#rope_common

	;it's some kind of special command
	;assume it's a GOTO.  It'd sure as hell BETTER be...
#script_goto
	move	*a5(PD_SCPTR),a6,L
	move	*a6(10h),*a5(PD_SCPTR),L
	jruc	#new_sequence

#repeat_sequence
	move	a6,*a5(PD_SCCNT),W
	move	*a5(PD_SCPTR),a6,L
	addk	10h,a6			;skip the repeat count
	move	*a6,a6,L		;points now to a sequence
	move	a6,*a5(PD_SQPTR),L	;stuff it as the new SQPTR
	jruc	#new_sequence_frame	;and pretend we got there normally...

#*****************************************************************************
* Change an objects image (Doesn't check VFLIP)
* A0=*New image
* A8=*Obj
* Trashes scratch
*
* ---> This is more or less identical to the civanic found in ROBO.ASM,
*      but it's called with EXGPC instead of CALL[R/A].
*
* ---> returns via JUMP a14

 SUBRP	fastanic

	cmpi	ROM,a0
	jrlo	#anierr

	;set new anim points
	move	*a0(IANIOFF),*a8(ODOFF),L

	move	a0,*a8(OIMG),L
	move	*a0(0),*a8(OSIZE),L
	move	*a0(ISAG),*a8(OSAG),L

	setf	5,0,0
	move	*a0(ICTRL+7),*a8(OCTRL+7) ;Write 5 z comp bits
	setf	16,1,0

#x	jump	a14

#anierr 
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	2,2
	.endif
	jruc	#x


#*****************************************************************************
*
* a0 = rope process
* a1 = rope index (R_TOP,R_MIDDLE,R_BOTTOM)
* a2 = rope action (RZ_NORM,RZ_HIGH)
*

 SUBR	set_rope_z

	PUSH	a4

	addi	PDBLKSTART,a0
	movi	PDBLKSIZ,a14
	mpyu	a14,a1
	add	a1,a0

	move	*a0(PD_OBJ),a3,L		;top half
	move	*a0(PD_OBJ2),a4,L		;bottom half

	movi	015a9h,a0

	cmpi	RZ_HIGH,a2
	jreq	#set_high

	move	*a3(OZPOS),a0,W

#set_high
	move	a0,*a4(OZPOS)

	PULL	a4

	rets

#*****************************************************************************
*
* a0 = rope number (use defined constants from game.equ)
* a1 = type of action
* a2 = rope position(0-5) (for side bounces)
* a2 = magnitude(0-3) (for general shakes)
* a3 = Z position of wrestler (only for side springs)
*

	;reg use
	; a0-3  input
	; a4    script pointer
	; a5	rope process pointer

 SUBR	rope_command

	push	a0,a1,a2,a3,a4,a7,a10

	;get the action script pointer
	move	a0,a5
	X32	a5
	movk	ROPE_COMMANDS,a14
	mpyu	a14,a5
	move	a5,a4
	
	addi	#command_table,a4
	move	a1,a14
	X32	a14
	add	a14,a4
	move	*a4,a4,L
	jrz	#invalid_action
     
	;get the rope proc pointer
	move	a0,a5
	X32	a5
	addi	front_rproc,a5
	move	*a5,a5,L
	jrz	#done		;ignore if there's no process for that rope.

	;check for a side-spring
	cmpi	#sspring,a4
	jreq	#sloop
	cmpi	#dspring,a4
	jreq	#sloop
	jruc	#no_spring

	;it's a side-spring.  figure out which one to use
#sloop
	move	*a4+,a14,L
	cmp	a14,a3
	jrlt	#sfound
	addi	20h*6,a4
	jruc	#sloop

#sfound
	move	a2,a14
	X32	a14
	add	a14,a4
	move	*a4,a4,L
	jruc	#script_set

#no_spring
	;check for a side shake
	cmpi	ROPE_BOUNCEUD,a1
	jrne	#no_updown

	;it's an up-down shake.
	move	a2,a14
	X32	a14
	add	a14,a4
	move	*a4,a4,L
	jruc	#script_set

#no_updown
#script_set
	;start the bank of ropes doing it's thing
	move	a4,*a5(ROPE_ACTION),L

	move	*a5(PROCID),a1,W
	movi	new_command_wake,a7
	move	*a5(PA8),a8,L
	move	*a5(PA9),a9,L
	move	*a5(PA10),a10,L
	move	*a5(PA11),a11,L
	move	a5,a0
	calla	XFERPROC
#invalid_action
#done

	pull	a0,a1,a2,a3,a4,a7,a10

	rets

#command_table
	.long	#frontud_table,0,0,0,0,0
	.long	#backud_table,0,0,0,0,0
	.long	#sideud,side_bounceio_t,#sspring,#dspring,sspr_trans_t,dspr_trans_t
	.long	#sideud,side_bounceio_t,#sspring,#dspring,sspr_trans_t,dspr_trans_t

#frontud_table
	.long	front_bounceud1_t
	.long	front_bounceud2_t
	.long	front_bounceud3_t
	.long	front_bounceud4_t

#backud_table
	.long	back_bounceud1_t
	.long	back_bounceud2_t
	.long	back_bounceud3_t
	.long	back_bounceud4_t

#sideud
	.long	side_bounceud1_t
	.long	side_bounceud2_t
	.long	side_bounceud3_t
	.long	side_bounceud4_t

#LANE_WIDTH	.equ	(RING_BOT - RING_TOP) / 5

#sspring
	.long	( RING_TOP + ( 1 * #LANE_WIDTH )) << 16
	.long	sspr11_t,sspr12_t,sspr13_t,sspr14_t,sspr15_t,0
	.long	( RING_TOP + ( 2 * #LANE_WIDTH )) << 16
	.long	sspr11_t,sspr22_t,sspr23_t,sspr24_t,sspr25_t,0
	.long	( RING_TOP + ( 3 * #LANE_WIDTH )) << 16
	.long	sspr21_t,sspr32_t,sspr33_t,sspr34_t,sspr35_t,0
	.long	( RING_TOP + ( 4 * #LANE_WIDTH )) << 16
	.long	sspr31_t,sspr42_t,sspr43_t,sspr44_t,sspr45_t,0
	.long	7FFFFFFFh
	.long	sspr41_t,sspr52_t,sspr53_t,sspr54_t,sspr55_t,0

#dspring
	.long	( RING_TOP + ( 1 * #LANE_WIDTH )) << 16
	.long	dspr11_t,dspr12_t,dspr13_t,dspr14_t,dspr15_t,dspr16_t
	.long	( RING_TOP + ( 2 * #LANE_WIDTH )) << 16
	.long	dspr11_t,dspr22_t,dspr23_t,dspr24_t,dspr25_t,dspr26_t
	.long	( RING_TOP + ( 3 * #LANE_WIDTH )) << 16
	.long	dspr21_t,dspr32_t,dspr33_t,dspr34_t,dspr35_t,dspr36_t
	.long	( RING_TOP + ( 4 * #LANE_WIDTH )) << 16
	.long	dspr31_t,dspr42_t,dspr43_t,dspr44_t,dspr45_t,dspr46_t
	.long	7FFFFFFFh
	.long	dspr41_t,dspr52_t,dspr53_t,dspr54_t,dspr55_t,dspr56_t

#***************************************
*
* Front ropes, up and down
*

 SUBRP	front_bounceud4_t	;(script table)
	WL	SHAKE_PRI,front_bounceud4_R
	WL	SHAKE_PRI,front_bounceud4_W
	WL	SHAKE_PRI,front_bounceud4_B

 SUBRP	front_bounceud3_t	;(script table)
	WL	SHAKE_PRI,front_bounceud3_R
	WL	SHAKE_PRI,front_bounceud3_W
	WL	SHAKE_PRI,front_bounceud3_B

 SUBRP	front_bounceud2_t	;(script table)
	WL	SHAKE_PRI,front_bounceud2_R
	WL	SHAKE_PRI,front_bounceud2_W
	WL	SHAKE_PRI,front_bounceud2_B

 SUBRP	front_bounceud1_t	;(script table)
	WL	SHAKE_PRI,front_bounceud1_R
	WL	SHAKE_PRI,front_bounceud1_W
	WL	SHAKE_PRI,front_bounceud1_B

 SUBRP	front_bounceud4_R	;(script)
	WL	1,#f_bncud1_R
 SUBRP	front_bounceud3_R	;(script)
	WL	1,#f_bncud2_R
 SUBRP	front_bounceud2_R	;(script)
	WL	2,#f_bncud3
 SUBRP	front_bounceud1_R	;(script)
	WL	3,#f_bncud4
	.word	0

 SUBRP	front_bounceud4_W	;(script)
	WL	1,#f_bncud1_W
 SUBRP	front_bounceud3_W	;(script)
	WL	1,#f_bncud2_W
 SUBRP	front_bounceud2_W	;(script)
	WL	2,#f_bncud3
 SUBRP	front_bounceud1_W	;(script)
	WL	3,#f_bncud4
	.word	0

 SUBRP	front_bounceud4_B	;(script)
	WL	1,#f_bncud1_B
 SUBRP	front_bounceud3_B	;(script)
	WL	1,#f_bncud2_B
 SUBRP	front_bounceud2_B	;(script)
	WL	2,#f_bncud3
 SUBRP	front_bounceud1_B	;(script)
	WL	3,#f_bncud4
	.word	0

#f_bncud1_R	;(sequence)
	WL	1,RPFBUP02
#f_bncud1_B	;(sequence)
	WL	1,RPFBUP03
#f_bncud1_W	;(sequence)
	WL	1,RPFBUP05
	WL	1,RPFBUP04
	WL	1,RPFBUP03
	WL	1,RPFBUP01
	WL	1,RPFBDN01
	WL	1,RPFBDN03
	WL	1,RPFBDN05
	WL	1,RPFBDN04
	WL	1,RPFBDN03
	WL	1,RPFBDN02
	WL	1,ROPE_F_R
	.word	0

#f_bncud2_R	;sequence
	WL	1,RPFBUP02
#f_bncud2_B	;sequence
	WL	1,RPFBUP03
#f_bncud2_W	;sequence
	WL	1,RPFBUP04
	WL	1,RPFBUP03
	WL	1,RPFBUP01
	WL	1,RPFBDN02
	WL	1,RPFBDN03
	WL	1,RPFBDN04
	WL	1,RPFBDN03
	WL	1,RPFBDN02
	WL	1,ROPE_F_R
	.word	0

#f_bncud3	;sequence
	WL	1,RPFBUP02
	WL	1,RPFBUP03
	WL	1,RPFBUP02
	WL	1,ROPE_F_R
	WL	1,RPFBDN02
	WL	1,RPFBDN03
	WL	1,RPFBDN02
	WL	1,ROPE_F_R
	.word	0

#f_bncud4	;sequence
	WL	1,RPFBUP01
	WL	1,RPFBUP02
	WL	1,RPFBUP01
	WL	1,ROPE_F_R
	WL	1,RPFBDN01
	WL	1,RPFBDN02
	WL	1,RPFBDN01
	WL	1,ROPE_F_R
	.word	0


****************************************
*
* Back ropes, up and down
*

 SUBRP	back_bounceud4_t	;(script table)
	WL	SHAKE_PRI,back_bounceud4_R
	WL	SHAKE_PRI,back_bounceud4_W
	WL	SHAKE_PRI,back_bounceud4_B

 SUBRP	back_bounceud3_t	;(script table)
	WL	SHAKE_PRI,back_bounceud3_R
	WL	SHAKE_PRI,back_bounceud3_W
	WL	SHAKE_PRI,back_bounceud3_B

 SUBRP	back_bounceud2_t	;(script table)
	WL	SHAKE_PRI,back_bounceud2_R
	WL	SHAKE_PRI,back_bounceud2_W
	WL	SHAKE_PRI,back_bounceud2_B

 SUBRP	back_bounceud1_t	;(script table)
	WL	SHAKE_PRI,back_bounceud1_R
	WL	SHAKE_PRI,back_bounceud1_W
	WL	SHAKE_PRI,back_bounceud1_B

 SUBRP	back_bounceud4_R	;(script)
	WL	1,#b_bncud1_R
 SUBRP	back_bounceud3_R	;(script)
	WL	1,#b_bncud2_R
 SUBRP	back_bounceud2_R	;(script)
	WL	2,#b_bncud3_R
 SUBRP	back_bounceud1_R	;(script)
	WL	3,#b_bncud4_R
	.word	0

 SUBRP	back_bounceud4_W	;(script)
	WL	1,#b_bncud1_W
 SUBRP	back_bounceud3_W	;(script)
	WL	1,#b_bncud2_W
 SUBRP	back_bounceud2_W	;(script)
	WL	2,#b_bncud3_W
 SUBRP	back_bounceud1_W	;(script)
	WL	3,#b_bncud4_W
	.word	0

 SUBRP	back_bounceud4_B	;(script)
	WL	1,#b_bncud1_B
 SUBRP	back_bounceud3_B	;(script)
	WL	1,#b_bncud2_B
 SUBRP	back_bounceud2_B	;(script)
	WL	2,#b_bncud3_B
 SUBRP	back_bounceud1_B	;(script)
	WL	3,#b_bncud4_B
	.word	0


#b_bncud1_B	;(sequence)
	WL	1,RPBBUP02
#b_bncud1_R	;(sequence)
	WL	1,RPBBUP03
#b_bncud1_W	;(sequence)
	WL	1,RPBBUP05
	WL	1,RPBBUP04
	WL	1,RPBBUP03
	WL	1,RPBBUP01
	WL	1,RPBBDN01
	WL	1,RPBBDN03
	WL	1,RPBBDN05
	WL	1,RPBBDN04
	WL	1,RPBBDN03
	WL	1,RPBBDN02
	WL	1,ROPE_B_R
	.word	0

#b_bncud2_B	;(sequence)
	WL	1,RPBBUP02
#b_bncud2_R	;(sequence)
	WL	1,RPBBUP03
#b_bncud2_W	;(sequence)
	WL	1,RPBBUP04
	WL	1,RPBBUP03
	WL	1,RPBBUP01
	WL	1,RPBBDN02
	WL	1,RPBBDN03
	WL	1,RPBBDN04
	WL	1,RPBBDN03
	WL	1,RPBBDN02
	WL	1,ROPE_B_R
	.word	0

#b_bncud3_R	;(sequence)
#b_bncud3_W	;(sequence)
	WL	1,RPBBUP02
#b_bncud3_B	;(sequence)
	WL	1,RPBBUP03
	WL	1,RPBBUP02
	WL	1,ROPE_B_R
	WL	1,RPBBDN02
	WL	1,RPBBDN03
	WL	1,RPBBDN02
	WL	1,ROPE_B_R
	.word	0

#b_bncud4_W	;(sequence)
#b_bncud4_B	;(sequence)
	WL	1,RPBBUP01
#b_bncud4_R	;(sequence)
	WL	1,RPBBUP02
	WL	1,RPBBUP01
	WL	1,ROPE_B_R
	WL	1,RPBBDN01
	WL	1,RPBBDN02
	WL	1,RPBBDN01
	WL	1,ROPE_B_R
	.word	0


****************************************
*
* Side ropes, up and down
*

 SUBRP	side_bounceud4_t	;(script table)
	WL	SHAKE_PRI,side_bounceud4_R
	WL	SHAKE_PRI,side_bounceud4_W
	WL	SHAKE_PRI,side_bounceud4_B
	WL	SHAKE_PRI,side_bounceud_S

 SUBRP	side_bounceud3_t	;(script table)
	WL	SHAKE_PRI,side_bounceud3_R
	WL	SHAKE_PRI,side_bounceud3_W
	WL	SHAKE_PRI,side_bounceud3_B
	WL	SHAKE_PRI,side_bounceud_S

 SUBRP	side_bounceud2_t	;(script table)
	WL	SHAKE_PRI,side_bounceud2_R
	WL	SHAKE_PRI,side_bounceud2_W
	WL	SHAKE_PRI,side_bounceud2_B
	WL	SHAKE_PRI,side_bounceud_S

 SUBRP	side_bounceud1_t	;(script table)
	WL	SHAKE_PRI,side_bounceud1_R
	WL	SHAKE_PRI,side_bounceud1_W
	WL	SHAKE_PRI,side_bounceud1_B
	WL	SHAKE_PRI,side_bounceud_S

 SUBRP	side_bounceud_S		;(script)
	WL	1,#s_bncud_S
	.word	0

 SUBRP	side_bounceud4_R	;(script)
	WL	1,#s_bncud1_R
 SUBRP	side_bounceud3_R	;(script)
	WL	1,#s_bncud2_R
 SUBRP	side_bounceud2_R	;(script)
	WL	2,#s_bncud3_R
 SUBRP	side_bounceud1_R	;(script)
	WL	3,#s_bncud4_R
	.word	0

 SUBRP	side_bounceud4_W	;(script)
	WL	1,#s_bncud1_W
 SUBRP	side_bounceud3_W	;(script)
	WL	1,#s_bncud2_W
 SUBRP	side_bounceud2_W	;(script)
	WL	2,#s_bncud3_W
 SUBRP	side_bounceud1_W	;(script)
	WL	3,#s_bncud4_W
	.word	0

 SUBRP	side_bounceud4_B	;(script)
	WL	1,#s_bncud1_B
 SUBRP	side_bounceud3_B	;(script)
	WL	1,#s_bncud2_B
 SUBRP	side_bounceud2_B	;(script)
	WL	2,#s_bncud3_B
 SUBRP	side_bounceud1_B	;(script)
	WL	3,#s_bncud4_B
	.word	0

#s_bncud1_B	;(sequence)
	WL	1,RPSBUP02
#s_bncud1_W	;(sequence)
	WL	1,RPSBUP03
#s_bncud1_R	;(sequence)
	WL	1,RPSBUP05
	WL	1,RPSBUP04
	WL	1,RPSBUP03
	WL	1,RPSBUP01
	WL	1,RPSBDN01
	WL	1,RPSBDN03
	WL	1,RPSBDN05
	WL	1,RPSBDN04
	WL	1,RPSBDN03
	WL	1,RPSBDN02
	WL	1,ROPE_S_R
	.word	0

#s_bncud2_B	;(sequence)
	WL	1,RPSBUP02
#s_bncud2_W	;(sequence)
	WL	1,RPSBUP03
#s_bncud2_R	;(sequence)
	WL	1,RPSBUP04
	WL	1,RPSBUP03
	WL	1,RPSBUP01
	WL	1,RPSBDN02
	WL	1,RPSBDN03
	WL	1,RPSBDN04
	WL	1,RPSBDN03
	WL	1,RPSBDN02
	WL	1,ROPE_S_R
	.word	0

#s_bncud3_R	;(sequence)
#s_bncud3_W	;(sequence)
	WL	1,RPSBUP02
#s_bncud3_B	;(sequence)
	WL	1,RPSBUP03
	WL	1,RPSBUP02
	WL	1,ROPE_S_R
	WL	1,RPSBDN02
	WL	1,RPSBDN03
	WL	1,RPSBDN02
	WL	1,ROPE_S_R
	.word	0

#s_bncud4_R	;(sequence)
#s_bncud4_B	;(sequence)
	WL	1,RPSBUP01
#s_bncud4_W	;(sequence)
	WL	1,RPSBUP02
	WL	1,RPSBUP01
	WL	1,ROPE_S_R
	WL	1,RPSBDN01
	WL	1,RPSBDN02
	WL	1,RPSBDN01
	WL	1,ROPE_S_R
	.word	0

#s_bncud_S	;(sequence)
	WL	1,ROPSHAD
	.word	0


****************************************
*
* Side ropes, in and out
*

 SUBRP	side_bounceio_t		;(script table)
	WL	SHAKE_PRI,side_bounceio_R
	WL	SHAKE_PRI,side_bounceio_W
	WL	SHAKE_PRI,side_bounceio_B
	WL	SHAKE_PRI,side_bounceio_S

 SUBRP	side_bounceio_S		;(script)
	WL	1,#s_bncio_S
	.word	0

 SUBRP	side_bounceio_R		;(script)
	WL	1,#s_bncio1_R
 SUBRP	side_bounceio2_R	;(script)
;	WL	RANI_SETPRIORITY,SHAKE_PRI-1
	WL	1,#s_bncio2_R
	WL	1,#s_bncio3
	WL	2,#s_bncio4
	.word	0

 SUBRP	side_bounceio_W		;(script)
	WL	1,#s_bncio1_W
 SUBRP	side_bounceio2_W	;(script)
	WL	1,#s_bncio2_W
	WL	1,#s_bncio3
	WL	2,#s_bncio4
	.word	0

 SUBRP	side_bounceio_B		;(script)
	WL	1,#s_bncio1_B
	WL	1,#s_bncio2_B
	WL	1,#s_bncio3
	WL	2,#s_bncio4
	.word	0


#s_bncio1_R	;(sequence)
	WL	1,RPSBIN02
#s_bncio1_B	;(sequence)
	WL	1,RPSBIN03
#s_bncio1_W	;(sequence)
	WL	1,RPSBIN05
	WL	1,RPSBIN04
	WL	1,RPSBIN03
	WL	1,RPSBIN01
	WL	1,RPSBOU01
	WL	1,RPSBOU03
	WL	1,RPSBOU05
	WL	1,RPSBOU04
	WL	1,RPSBOU03
	WL	1,RPSBOU02
	WL	1,ROPE_S_R
	.word	0

#s_bncio2_R	;(sequence)
	WL	1,RPSBIN02
#s_bncio2_B	;(sequence)
	WL	1,RPSBIN03
#s_bncio2_W	;(sequence)
	WL	1,RPSBIN04
	WL	1,RPSBIN03
	WL	1,RPSBIN01
	WL	1,RPSBOU02
	WL	1,RPSBOU03
	WL	1,RPSBOU04
	WL	1,RPSBOU03
	WL	1,RPSBOU02
	WL	1,ROPE_S_R
	.word	0

#s_bncio3	;(sequence)
	WL	1,RPSBIN02
	WL	1,RPSBIN03
	WL	1,RPSBIN02
	WL	1,ROPE_S_R
	WL	1,RPSBOU02
	WL	1,RPSBOU03
	WL	1,RPSBOU02
	WL	1,ROPE_S_R
	.word	0

#s_bncio4	;(sequence)
	WL	1,RPSBIN01
	WL	1,RPSBIN02
	WL	1,RPSBIN01
	WL	1,ROPE_S_R
	WL	1,RPSBOU01
	WL	1,RPSBOU02
	WL	1,RPSBOU01
	WL	1,ROPE_S_R
	.word	0

#s_bncio_S	;(sequence)
	WL	1,ROPSHAD
	.word	0

****************************************
*
* Side ropes, spring sideways
*

sspr11_t	;(script table)
	WLWL	SSPRING_PRI,#sspr11,SSPRING_PRI,#ssprXX
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad11
sspr12_t	;(script table)
	WLWL	SSPRING_PRI,#sspr12,SSPRING_PRI,#sspr11
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad12
sspr13_t	;(script table)
	WLWL	SSPRING_PRI,#sspr13,SSPRING_PRI,#sspr12
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad13
sspr14_t	;(script table)
	WLWL	SSPRING_PRI,#sspr14,SSPRING_PRI,#sspr12
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad13
sspr15_t	;(script table)
	WLWL	SSPRING_PRI,#sspr15,SSPRING_PRI,#sspr11
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad12

sspr21_t	;(script table)
	WLWL	SSPRING_PRI,#sspr21,SSPRING_PRI,#ssprXX
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad21
sspr22_t	;(script table)
	WLWL	SSPRING_PRI,#sspr22,SSPRING_PRI,#sspr21
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad22
sspr23_t	;(script table)
	WLWL	SSPRING_PRI,#sspr23,SSPRING_PRI,#sspr22
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad23
sspr24_t	;(script table)
	WLWL	SSPRING_PRI,#sspr24,SSPRING_PRI,#sspr22
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad23
sspr25_t	;(script table)
	WLWL	SSPRING_PRI,#sspr25,SSPRING_PRI,#sspr21
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad22

sspr31_t	;(script table)
	WLWL	SSPRING_PRI,#sspr31,SSPRING_PRI,#ssprXX
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad31
sspr32_t	;(script table)
	WLWL	SSPRING_PRI,#sspr32,SSPRING_PRI,#sspr31
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad32
sspr33_t	;(script table)
	WLWL	SSPRING_PRI,#sspr33,SSPRING_PRI,#sspr32
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad33
sspr34_t	;(script table)
	WLWL	SSPRING_PRI,#sspr34,SSPRING_PRI,#sspr32
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad33
sspr35_t	;(script table)
	WLWL	SSPRING_PRI,#sspr35,SSPRING_PRI,#sspr31
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad32

sspr41_t	;(script table)
	WLWL	SSPRING_PRI,#sspr41,SSPRING_PRI,#ssprXX
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad41
sspr42_t	;(script table)
	WLWL	SSPRING_PRI,#sspr42,SSPRING_PRI,#sspr41
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad42
sspr43_t	;(script table)
	WLWL	SSPRING_PRI,#sspr43,SSPRING_PRI,#sspr42
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad43
sspr44_t	;(script table)
	WLWL	SSPRING_PRI,#sspr44,SSPRING_PRI,#sspr42
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad43
sspr45_t	;(script table)
	WLWL	SSPRING_PRI,#sspr45,SSPRING_PRI,#sspr41
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad42

sspr51_t	;(script table)
	WLWL	SSPRING_PRI,#sspr51,SSPRING_PRI,#ssprXX
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad51
sspr52_t	;(script table)
	WLWL	SSPRING_PRI,#sspr52,SSPRING_PRI,#sspr51
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad52
sspr53_t	;(script table)
	WLWL	SSPRING_PRI,#sspr53,SSPRING_PRI,#sspr52
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad53
sspr54_t	;(script table)
	WLWL	SSPRING_PRI,#sspr54,SSPRING_PRI,#sspr52
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad53
sspr55_t	;(script table)
	WLWL	SSPRING_PRI,#sspr55,SSPRING_PRI,#sspr51
	WLWL	SSPRING_PRI,#ssprXX,SSPRING_PRI,#sprshad52

sspr_trans_t	;(script table)
	WL	SSPRING_PRI,#sspr_trans_R
	WL	SSPRING_PRI,#sspr_trans_W
	WL	SSPRING_PRI,#sspr_trans_B
	WL	SSPRING_PRI,#sprshad_trans

#ssprXX		;(script)
	WL	1,#s_stop
	.word	0
#sspr11		;(script)
	WL	1,#s_sspr11
	.word	0
#sspr12		;(script)
	WL	1,#s_sspr12
	.word	0
#sspr13		;(script)
	WL	1,#s_sspr13
	.word	0
#sspr14		;(script)
	WL	1,#s_sspr14
	.word	0
#sspr15		;(script)
	WL	1,#s_sspr15
	.word	0
#sspr16		;(script)
	WL	1,#s_sspr16
	.word	0
#sspr21		;(script)
	WL	1,#s_sspr21
	.word	0
#sspr22		;(script)
	WL	1,#s_sspr22
	.word	0
#sspr23		;(script)
	WL	1,#s_sspr23
	.word	0
#sspr24		;(script)
	WL	1,#s_sspr24
	.word	0
#sspr25		;(script)
	WL	1,#s_sspr25
	.word	0
#sspr26		;(script)
	WL	1,#s_sspr26
	.word	0
#sspr31		;(script)
	WL	1,#s_sspr31
	.word	0
#sspr32		;(script)
	WL	1,#s_sspr32
	.word	0
#sspr33		;(script)
	WL	1,#s_sspr33
	.word	0
#sspr34		;(script)
	WL	1,#s_sspr34
	.word	0
#sspr35		;(script)
	WL	1,#s_sspr35
	.word	0
#sspr36		;(script)
	WL	1,#s_sspr36
	.word	0
#sspr41		;(script)
	WL	1,#s_sspr41
	.word	0
#sspr42		;(script)
	WL	1,#s_sspr42
	.word	0
#sspr43		;(script)
	WL	1,#s_sspr43
	.word	0
#sspr44		;(script)
	WL	1,#s_sspr44
	.word	0
#sspr45		;(script)
	WL	1,#s_sspr45
	.word	0
#sspr46		;(script)
	WL	1,#s_sspr46
	.word	0
#sspr51		;(script)
	WL	1,#s_sspr51
	.word	0
#sspr52		;(script)
	WL	1,#s_sspr52
	.word	0
#sspr53		;(script)
	WL	1,#s_sspr53
	.word	0
#sspr54		;(script)
	WL	1,#s_sspr54
	.word	0
#sspr55		;(script)
	WL	1,#s_sspr55
	.word	0
#sspr56		;(script)
	WL	1,#s_sspr56
	.word	0

#sprshad11	;(script)
	WL	1,#s_sprshad11
	.word	0
#sprshad12	;(script)
	WL	1,#s_sprshad12
	.word	0
#sprshad13	;(script)
	WL	1,#s_sprshad13
	.word	0
#sprshad14	;(script)
	WL	1,#s_sprshad14
	.word	0
#sprshad15	;(script)
	WL	1,#s_sprshad15
	.word	0
#sprshad21	;(script)
	WL	1,#s_sprshad21
	.word	0
#sprshad22	;(script)
	WL	1,#s_sprshad22
	.word	0
#sprshad23	;(script)
	WL	1,#s_sprshad23
	.word	0
#sprshad24	;(script)
	WL	1,#s_sprshad24
	.word	0
#sprshad25	;(script)
	WL	1,#s_sprshad25
	.word	0
#sprshad31	;(script)
	WL	1,#s_sprshad31
	.word	0
#sprshad32	;(script)
	WL	1,#s_sprshad32
	.word	0
#sprshad33	;(script)
	WL	1,#s_sprshad33
	.word	0
#sprshad34	;(script)
	WL	1,#s_sprshad34
	.word	0
#sprshad35	;(script)
	WL	1,#s_sprshad35
	.word	0
#sprshad41	;(script)
	WL	1,#s_sprshad41
	.word	0
#sprshad42	;(script)
	WL	1,#s_sprshad42
	.word	0
#sprshad43	;(script)
	WL	1,#s_sprshad43
	.word	0
#sprshad44	;(script)
	WL	1,#s_sprshad44
	.word	0
#sprshad45	;(script)
	WL	1,#s_sprshad45
	.word	0
#sprshad51	;(script)
	WL	1,#s_sprshad51
	.word	0
#sprshad52	;(script)
	WL	1,#s_sprshad52
	.word	0
#sprshad53	;(script)
	WL	1,#s_sprshad53
	.word	0
#sprshad54	;(script)
	WL	1,#s_sprshad54
	.word	0
#sprshad55	;(script)
	WL	1,#s_sprshad55
	.word	0

#sspr_trans_R	;(script)
	WL	1,#s_sspr_trans_R
	WL	RANI_GOTO,side_bounceio2_R

#sspr_trans_W	;(script)
	WL	1,#s_sspr_trans_W
	WL	RANI_GOTO,side_bounceio2_W

#sspr_trans_B	;(script)
	WL	2,#s_bncio4
	.word	0

#sprshad_trans	;(script)
	WL	1,#s_sprshad_trans
	WL	1,#s_stop_shadow
	.word	0

#s_sspr11	;(sequence)
	WL	10,RPSS1_01
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr12	;(sequence)
	WL	10,RPSS1_02
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr13	;(sequence)
	WL	10,RPSS1_03
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr14	;(sequence)
	WL	10,RPSS1_04
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr15	;(sequence)
	WL	10,RPSS1_05
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr16	;(sequence)
	WL	10,RPSS1_06
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr21	;(sequence)
	WL	10,RPSS2_01
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr22	;(sequence)
	WL	10,RPSS2_02
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr23	;(sequence)
	WL	10,RPSS2_03
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr24	;(sequence)
	WL	10,RPSS2_04
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr25	;(sequence)
	WL	10,RPSS2_05
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr26	;(sequence)
	WL	10,RPSS2_06
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr31	;(sequence)
	WL	10,RPSS3_01
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr32	;(sequence)
	WL	10,RPSS3_02
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr33	;(sequence)
	WL	10,RPSS3_03
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr34	;(sequence)
	WL	10,RPSS3_04
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr35	;(sequence)
	WL	10,RPSS3_05
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr36	;(sequence)
	WL	10,RPSS3_06
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr41	;(sequence)
	WL	10,RPSS4_01
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr42	;(sequence)
	WL	10,RPSS4_02
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr43	;(sequence)
	WL	10,RPSS4_03
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr44	;(sequence)
	WL	10,RPSS4_04
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr45	;(sequence)
	WL	10,RPSS4_05
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr46	;(sequence)
	WL	10,RPSS4_06
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr51	;(sequence)
	WL	10,RPSS5_01
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr52	;(sequence)
	WL	10,RPSS5_02
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr53	;(sequence)
	WL	10,RPSS5_03
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr54	;(sequence)
	WL	10,RPSS5_04
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr55	;(sequence)
	WL	10,RPSS5_05
	WL	RANI_GOTO,#s_stop
	.word	0
#s_sspr56	;(sequence)
	WL	10,RPSS5_06
	WL	RANI_GOTO,#s_stop
	.word	0

#s_sprshad11	;(sequence)
	WL	10,RCSH1_01
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad12	;(sequence)
	WL	10,RCSH1_02
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad13	;(sequence)
	WL	10,RCSH1_03
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad14	;(sequence)
	WL	10,RCSH1_04
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad15	;(sequence)
	WL	10,RCSH1_05
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad21	;(sequence)
	WL	10,RCSH2_01
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad22	;(sequence)
	WL	10,RCSH2_02
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad23	;(sequence)
	WL	10,RCSH2_03
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad24	;(sequence)
	WL	10,RCSH2_04
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad25	;(sequence)
	WL	10,RCSH2_05
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad31	;(sequence)
	WL	10,RCSH3_01
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad32	;(sequence)
	WL	10,RCSH3_02
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad33	;(sequence)
	WL	10,RCSH3_03
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad34	;(sequence)
	WL	10,RCSH3_04
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad35	;(sequence)
	WL	10,RCSH3_05
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad41	;(sequence)
	WL	10,RCSH4_01
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad42	;(sequence)
	WL	10,RCSH4_02
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad43	;(sequence)
	WL	10,RCSH4_03
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad44	;(sequence)
	WL	10,RCSH4_04
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad45	;(sequence)
	WL	10,RCSH4_05
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad51	;(sequence)
	WL	10,RCSH5_01
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad52	;(sequence)
	WL	10,RCSH5_02
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad53	;(sequence)
	WL	10,RCSH5_03
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad54	;(sequence)
	WL	10,RCSH5_04
	WL	RANI_GOTO,#s_stop_shadow
	.word	0
#s_sprshad55	;(sequence)
	WL	10,RCSH5_05
	WL	RANI_GOTO,#s_stop_shadow
	.word	0

#s_sspr_trans_R	;(sequence)
	WL	1,RPSBIN06
	WL	2,RPSBIN08
	WL	1,RPSBIN07
	WL	1,RPSBIN06
	WL	1,ROPE_S_R
	WL	1,RPSBOU01
	WL	1,RPSBOU03
	WL	1,RPSBOU06
#s_sspr_trans_W	;(sequence)
	WL	1,RPSBOU04
	WL	1,RPSBOU03
	WL	1,RPSBOU02
	.word	0

#s_sprshad_trans ;(sequence)
	WL	2,RBSH_02
	WL	2,RBSH_03
	WL	2,RBSH_04
	WL	2,RBSH_05
	WL	2,RBSH_06
	WL	2,RBSH_07
	WL	2,RBSH_01
	.word	0

#s_stop		;(sequence) - halt a side rope entirely
	WL	1,ROPE_S_R
	.word	0

#s_stop_shadow	;(sequence) - halt a side shadow entirely
	WL	1,ROPSHAD
	.word	0

****************************************
*
* Side ropes, spring up and down
*

dspr11_t	;(script table)
	WLWL	DSPRING_PRI,#dspr15,DSPRING_PRI,#dspr11
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr12_t	;(script table)
	WLWL	DSPRING_PRI,#dspr16,DSPRING_PRI,#dspr12
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr13_t	;(script table)
	WLWL	DSPRING_PRI,#dspr17,DSPRING_PRI,#dspr13
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr14_t	;(script table)
	WLWL	DSPRING_PRI,#dspr17,DSPRING_PRI,#dspr14
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr15_t	;(script table)
	WLWL	DSPRING_PRI,#dspr16,DSPRING_PRI,#dspr15
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr16_t	;(script table)
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dspr15
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad

dspr21_t	;(script table)
	WLWL	DSPRING_PRI,#dspr25,DSPRING_PRI,#dspr21
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr22_t	;(script table)
	WLWL	DSPRING_PRI,#dspr26,DSPRING_PRI,#dspr22
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr23_t	;(script table)
	WLWL	DSPRING_PRI,#dspr27,DSPRING_PRI,#dspr23
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr24_t	;(script table)
	WLWL	DSPRING_PRI,#dspr27,DSPRING_PRI,#dspr24
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr25_t	;(script table)
	WLWL	DSPRING_PRI,#dspr26,DSPRING_PRI,#dspr25
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr26_t	;(script table)
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dspr25
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad

dspr31_t	;(script table)
	WLWL	DSPRING_PRI,#dspr35,DSPRING_PRI,#dspr31
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr32_t	;(script table)
	WLWL	DSPRING_PRI,#dspr36,DSPRING_PRI,#dspr32
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr33_t	;(script table)
	WLWL	DSPRING_PRI,#dspr37,DSPRING_PRI,#dspr33
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr34_t	;(script table)
	WLWL	DSPRING_PRI,#dspr37,DSPRING_PRI,#dspr34
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr35_t	;(script table)
	WLWL	DSPRING_PRI,#dspr36,DSPRING_PRI,#dspr35
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr36_t	;(script table)
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dspr35
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad

dspr41_t	;(script table)
	WLWL	DSPRING_PRI,#dspr45,DSPRING_PRI,#dspr41
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr42_t	;(script table)
	WLWL	DSPRING_PRI,#dspr46,DSPRING_PRI,#dspr42
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr43_t	;(script table)
	WLWL	DSPRING_PRI,#dspr47,DSPRING_PRI,#dspr43
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr44_t	;(script table)
	WLWL	DSPRING_PRI,#dspr47,DSPRING_PRI,#dspr44
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr45_t	;(script table)
	WLWL	DSPRING_PRI,#dspr46,DSPRING_PRI,#dspr45
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr46_t	;(script table)
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dspr45
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad

dspr51_t	;(script table)
	WLWL	DSPRING_PRI,#dspr55,DSPRING_PRI,#dspr51
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr52_t	;(script table)
	WLWL	DSPRING_PRI,#dspr56,DSPRING_PRI,#dspr52
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr53_t	;(script table)
	WLWL	DSPRING_PRI,#dspr57,DSPRING_PRI,#dspr53
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr54_t	;(script table)
	WLWL	DSPRING_PRI,#dspr57,DSPRING_PRI,#dspr54
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr55_t	;(script table)
	WLWL	DSPRING_PRI,#dspr56,DSPRING_PRI,#dspr55
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad
dspr56_t	;(script table)
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dspr55
	WLWL	DSPRING_PRI,#dsprXX,DSPRING_PRI,#dsprshad

dspr_trans_t	;(script table)
	WL	DSPRING_PRI,#dspr_trans_R
	WL	DSPRING_PRI,#dspr_trans_W
	WL	DSPRING_PRI,#dspr_trans_B
	WL	DSPRING_PRI,#dsprshad

#dsprshad	;(script)
	WL	1,#s_dsprshad
	.word	0

#dsprXX		;(script)
	WL	1,#s_stop
	.word	0
#dspr11		;(script)
	WL	1,#s_dspr11
	.word	0
#dspr12		;(script)
	WL	1,#s_dspr12
	.word	0
#dspr13		;(script)
	WL	1,#s_dspr13
	.word	0
#dspr14		;(script)
	WL	1,#s_dspr14
	.word	0
#dspr15		;(script)
	WL	1,#s_dspr15
	.word	0
#dspr16		;(script)
	WL	1,#s_dspr16
	.word	0
#dspr17		;(script)
	WL	1,#s_dspr17
	.word	0
#dspr21		;(script)
	WL	1,#s_dspr21
	.word	0
#dspr22		;(script)
	WL	1,#s_dspr22
	.word	0
#dspr23		;(script)
	WL	1,#s_dspr23
	.word	0
#dspr24		;(script)
	WL	1,#s_dspr24
	.word	0
#dspr25		;(script)
	WL	1,#s_dspr25
	.word	0
#dspr26		;(script)
	WL	1,#s_dspr26
	.word	0
#dspr27		;(script)
	WL	1,#s_dspr27
	.word	0
#dspr31		;(script)
	WL	1,#s_dspr31
	.word	0
#dspr32		;(script)
	WL	1,#s_dspr32
	.word	0
#dspr33		;(script)
	WL	1,#s_dspr33
	.word	0
#dspr34		;(script)
	WL	1,#s_dspr34
	.word	0
#dspr35		;(script)
	WL	1,#s_dspr35
	.word	0
#dspr36		;(script)
	WL	1,#s_dspr36
	.word	0
#dspr37		;(script)
	WL	1,#s_dspr37
	.word	0
#dspr41		;(script)
	WL	1,#s_dspr41
	.word	0
#dspr42		;(script)
	WL	1,#s_dspr42
	.word	0
#dspr43		;(script)
	WL	1,#s_dspr43
	.word	0
#dspr44		;(script)
	WL	1,#s_dspr44
	.word	0
#dspr45		;(script)
	WL	1,#s_dspr45
	.word	0
#dspr46		;(script)
	WL	1,#s_dspr46
	.word	0
#dspr47		;(script)
	WL	1,#s_dspr47
	.word	0
#dspr51		;(script)
	WL	1,#s_dspr51
	.word	0
#dspr52		;(script)
	WL	1,#s_dspr52
	.word	0
#dspr53		;(script)
	WL	1,#s_dspr53
	.word	0
#dspr54		;(script)
	WL	1,#s_dspr54
	.word	0
#dspr55		;(script)
	WL	1,#s_dspr55
	.word	0
#dspr56		;(script)
	WL	1,#s_dspr56
	.word	0
#dspr57		;(script)
	WL	1,#s_dspr57
	.word	0

#dspr_trans_R	;(script)
	WL	1,#s_dspr_trans_R
	WL	RANI_GOTO,side_bounceud2_R

#dspr_trans_W	;(script)
	WL	1,#s_dspr_trans_W
	WL	RANI_GOTO,side_bounceud2_W

#dspr_trans_B	;(script)
	WL	2,#s_bncio4
	.word	0

#s_dsprshad	;(seqence)
	WL	1,ROPSHAD
	.word	0

#s_dspr11	;(sequence)
	WL	1,RPDS1_01
	.word	0
#s_dspr12	;(sequence)
	WL	1,RPDS1_02
	.word	0
#s_dspr13	;(sequence)
	WL	1,RPDS1_03
	.word	0
#s_dspr14	;(sequence)
	WL	1,RPDS1_04
	.word	0
#s_dspr15	;(sequence)
	WL	1,RPDS1_05
	.word	0
#s_dspr16	;(sequence)
	WL	1,RPDS1_06
	.word	0
#s_dspr17	;(sequence)
	WL	1,RPDS1_07
	.word	0
#s_dspr21	;(sequence)
	WL	1,RPDS2_01
	.word	0
#s_dspr22	;(sequence)
	WL	1,RPDS2_02
	.word	0
#s_dspr23	;(sequence)
	WL	1,RPDS2_03
	.word	0
#s_dspr24	;(sequence)
	WL	1,RPDS2_04
	.word	0
#s_dspr25	;(sequence)
	WL	1,RPDS2_05
	.word	0
#s_dspr26	;(sequence)
	WL	1,RPDS2_06
	.word	0
#s_dspr27	;(sequence)
	WL	1,RPDS2_07
	.word	0
#s_dspr31	;(sequence)
	WL	1,RPDS3_01
	.word	0
#s_dspr32	;(sequence)
	WL	1,RPDS3_02
	.word	0
#s_dspr33	;(sequence)
	WL	1,RPDS3_03
	.word	0
#s_dspr34	;(sequence)
	WL	1,RPDS3_04
	.word	0
#s_dspr35	;(sequence)
	WL	1,RPDS3_05
	.word	0
#s_dspr36	;(sequence)
	WL	1,RPDS3_06
	.word	0
#s_dspr37	;(sequence)
	WL	1,RPDS3_07
	.word	0
#s_dspr41	;(sequence)
	WL	1,RPDS4_01
	.word	0
#s_dspr42	;(sequence)
	WL	1,RPDS4_02
	.word	0
#s_dspr43	;(sequence)
	WL	1,RPDS4_03
	.word	0
#s_dspr44	;(sequence)
	WL	1,RPDS4_04
	.word	0
#s_dspr45	;(sequence)
	WL	1,RPDS4_05
	.word	0
#s_dspr46	;(sequence)
	WL	1,RPDS4_06
	.word	0
#s_dspr47	;(sequence)
	WL	1,RPDS4_07
	.word	0
#s_dspr51	;(sequence)
	WL	1,RPDS5_01
	.word	0
#s_dspr52	;(sequence)
	WL	1,RPDS5_02
	.word	0
#s_dspr53	;(sequence)
	WL	1,RPDS5_03
	.word	0
#s_dspr54	;(sequence)
	WL	1,RPDS5_04
	.word	0
#s_dspr55	;(sequence)
	WL	1,RPDS5_05
	.word	0
#s_dspr56	;(sequence)
	WL	1,RPDS5_06
	.word	0
#s_dspr57	;(sequence)
	WL	1,RPDS5_07
	.word	0

#s_dspr_trans_R	;(sequence)
	WL	1,RPSBUP05
#s_dspr_trans_W	;(sequence)
	WL	1,RPSBUP02
	WL	1,RPSBDN01
	WL	1,RPSBDN03
	WL	1,RPSBDN05
	WL	1,RPSBDN04
	WL	1,RPSBDN03
	WL	1,RPSBDN02
	.word	0

SIDEROPE_START
ROPE_S_R	.long	ROPE_S_Ra,ROPE_S_Rb
ROPE_S_W	.long	ROPE_S_Wa,ROPE_S_Wb
ROPE_S_B	.long	ROPE_S_Ba,ROPE_S_Bb
RPSBUP01	.long	RPSBUP01a,RPSBUP01b
RPSBUP02	.long	RPSBUP02a,RPSBUP02b
RPSBUP03	.long	RPSBUP03a,RPSBUP03b
RPSBUP04	.long	RPSBUP04a,RPSBUP04b
RPSBUP05	.long	RPSBUP05a,RPSBUP05b
RPSBUP06	.long	RPSBUP06a,RPSBUP06b
RPSBDN01	.long	RPSBDN01a,RPSBDN01b
RPSBDN02	.long	RPSBDN02a,RPSBDN02b
RPSBDN03	.long	RPSBDN03a,RPSBDN03b
RPSBDN04	.long	RPSBDN04a,RPSBDN04b
RPSBDN05	.long	RPSBDN05a,RPSBDN05b
RPSBDN06	.long	RPSBDN06a,RPSBDN06b
RPSBIN01	.long	RPSBIN01a,RPSBIN01b
RPSBIN02	.long	RPSBIN02a,RPSBIN02b
RPSBIN03	.long	RPSBIN03a,RPSBIN03b
RPSBIN04	.long	RPSBIN04a,RPSBIN04b
RPSBIN05	.long	RPSBIN05a,RPSBIN05b
RPSBIN06	.long	RPSBIN06a,RPSBIN06b
RPSBIN07	.long	RPSBIN07a,RPSBIN07b
RPSBIN08	.long	RPSBIN08a,RPSBIN08b
RPSBOU01	.long	RPSBOU01a,RPSBOU01b
RPSBOU02	.long	RPSBOU02a,RPSBOU02b
RPSBOU03	.long	RPSBOU03a,RPSBOU03b
RPSBOU04	.long	RPSBOU04a,RPSBOU04b
RPSBOU05	.long	RPSBOU05a,RPSBOU05b
RPSBOU06	.long	RPSBOU06a,RPSBOU06b
RPSBOU07	.long	RPSBOU07a,RPSBOU07b
RPSBOU08	.long	RPSBOU08a,RPSBOU08b
RPSS1_01	.long	RPSS1_01a,RPSS1_01b
RPSS1_02	.long	RPSS1_02a,RPSS1_02b
RPSS1_03	.long	RPSS1_03a,RPSS1_03b
RPSS1_04	.long	RPSS1_04a,RPSS1_04b
RPSS1_05	.long	RPSS1_05a,RPSS1_05b
RPSS1_06	.long	RPSS1_06a,RPSS1_06b
RPSS2_01	.long	RPSS2_01a,RPSS2_01b
RPSS2_02	.long	RPSS2_02a,RPSS2_02b
RPSS2_03	.long	RPSS2_03a,RPSS2_03b
RPSS2_04	.long	RPSS2_04a,RPSS2_04b
RPSS2_05	.long	RPSS2_05a,RPSS2_05b
RPSS2_06	.long	RPSS2_06a,RPSS2_06b
RPSS3_01	.long	RPSS3_01a,RPSS3_01b
RPSS3_02	.long	RPSS3_02a,RPSS3_02b
RPSS3_03	.long	RPSS3_03a,RPSS3_03b
RPSS3_04	.long	RPSS3_04a,RPSS3_04b
RPSS3_05	.long	RPSS3_05a,RPSS3_05b
RPSS3_06	.long	RPSS3_06a,RPSS3_06b
RPSS4_01	.long	RPSS4_01a,RPSS4_01b
RPSS4_02	.long	RPSS4_02a,RPSS4_02b
RPSS4_03	.long	RPSS4_03a,RPSS4_03b
RPSS4_04	.long	RPSS4_04a,RPSS4_04b
RPSS4_05	.long	RPSS4_05a,RPSS4_05b
RPSS4_06	.long	RPSS4_06a,RPSS4_06b
RPSS5_01	.long	RPSS5_01a,RPSS5_01b
RPSS5_02	.long	RPSS5_02a,RPSS5_02b
RPSS5_03	.long	RPSS5_03a,RPSS5_03b
RPSS5_04	.long	RPSS5_04a,RPSS5_04b
RPSS5_05	.long	RPSS5_05a,RPSS5_05b
RPSS5_06	.long	RPSS5_06a,RPSS5_06b
RPDS1_01	.long	RPDS1_01a,RPDS1_01b
RPDS1_02	.long	RPDS1_02a,RPDS1_02b
RPDS1_03	.long	RPDS1_03a,RPDS1_03b
RPDS1_04	.long	RPDS1_04a,RPDS1_04b
RPDS1_05	.long	RPDS1_05a,RPDS1_05b
RPDS1_06	.long	RPDS1_06a,RPDS1_06b
RPDS1_07	.long	RPDS1_07a,RPDS1_07b
RPDS1_08	.long	RPDS1_08a,RPDS1_08b
RPDS2_01	.long	RPDS2_01a,RPDS2_01b
RPDS2_02	.long	RPDS2_02a,RPDS2_02b
RPDS2_03	.long	RPDS2_03a,RPDS2_03b
RPDS2_04	.long	RPDS2_04a,RPDS2_04b
RPDS2_05	.long	RPDS2_05a,RPDS2_05b
RPDS2_06	.long	RPDS2_06a,RPDS2_06b
RPDS2_07	.long	RPDS2_07a,RPDS2_07b
RPDS2_08	.long	RPDS2_08a,RPDS2_08b
RPDS3_01	.long	RPDS3_01a,RPDS3_01b
RPDS3_02	.long	RPDS3_02a,RPDS3_02b
RPDS3_03	.long	RPDS3_03a,RPDS3_03b
RPDS3_04	.long	RPDS3_04a,RPDS3_04b
RPDS3_05	.long	RPDS3_05a,RPDS3_05b
RPDS3_06	.long	RPDS3_06a,RPDS3_06b
RPDS3_07	.long	RPDS3_07a,RPDS3_07b
RPDS3_08	.long	RPDS3_08a,RPDS3_08b
RPDS4_01	.long	RPDS4_01a,RPDS4_01b
RPDS4_02	.long	RPDS4_02a,RPDS4_02b
RPDS4_03	.long	RPDS4_03a,RPDS4_03b
RPDS4_04	.long	RPDS4_04a,RPDS4_04b
RPDS4_05	.long	RPDS4_05a,RPDS4_05b
RPDS4_06	.long	RPDS4_06a,RPDS4_06b
RPDS4_07	.long	RPDS4_07a,RPDS4_07b
RPDS4_08	.long	RPDS4_08a,RPDS4_08b
RPDS5_01	.long	RPDS5_01a,RPDS5_01b
RPDS5_02	.long	RPDS5_02a,RPDS5_02b
RPDS5_03	.long	RPDS5_03a,RPDS5_03b
RPDS5_04	.long	RPDS5_04a,RPDS5_04b
RPDS5_05	.long	RPDS5_05a,RPDS5_05b
RPDS5_06	.long	RPDS5_06a,RPDS5_06b
RPDS5_07	.long	RPDS5_07a,RPDS5_07b
RPDS5_08	.long	RPDS5_08a,RPDS5_08b

ROPSHAD		.long	ROPSHADA,ROPSHADB
RCSH1_01	.long	RCSH1_01A,RCSH1_01B
RCSH1_02	.long	RCSH1_02A,RCSH1_02B
RCSH1_03	.long	RCSH1_03A,RCSH1_03B
RCSH1_04	.long	RCSH1_04A,RCSH1_04B
RCSH1_05	.long	RCSH1_05A,RCSH1_05B
RCSH2_01	.long	RCSH2_01A,RCSH2_01B
RCSH2_02	.long	RCSH2_02A,RCSH2_02B
RCSH2_03	.long	RCSH2_03A,RCSH2_03B
RCSH2_04	.long	RCSH2_04A,RCSH2_04B
RCSH2_05	.long	RCSH2_05A,RCSH2_05B
RCSH3_01	.long	RCSH3_01A,RCSH3_01B
RCSH3_02	.long	RCSH3_02A,RCSH3_02B
RCSH3_03	.long	RCSH3_03A,RCSH3_03B
RCSH3_04	.long	RCSH3_04A,RCSH3_04B
RCSH3_05	.long	RCSH3_05A,RCSH3_05B
RCSH4_01	.long	RCSH4_01A,RCSH4_01B
RCSH4_02	.long	RCSH4_02A,RCSH4_02B
RCSH4_03	.long	RCSH4_03A,RCSH4_03B
RCSH4_04	.long	RCSH4_04A,RCSH4_04B
RCSH4_05	.long	RCSH4_05A,RCSH4_05B
RCSH5_01	.long	RCSH5_01A,RCSH5_01B
RCSH5_02	.long	RCSH5_02A,RCSH5_02B
RCSH5_03	.long	RCSH5_03A,RCSH5_03B
RCSH5_04	.long	RCSH5_04A,RCSH5_04B
RCSH5_05	.long	RCSH5_05A,RCSH5_05B
RBSH_01		.long	RBSH_01A,RBSH_01B
RBSH_02		.long	RBSH_02A,RBSH_02B
RBSH_03		.long	RBSH_03A,RBSH_03B
RBSH_04		.long	RBSH_04A,RBSH_04B
RBSH_05		.long	RBSH_05A,RBSH_05B
RBSH_06		.long	RBSH_06A,RBSH_06B
RBSH_07		.long	RBSH_07A,RBSH_07B

******************************************************************************

	.end
