****************************************************************
*
* Software:	Jamie Rivett
* Initiated:	
*
* Modified:
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 10/9/92 23:07
****************************************************************
	.file	"string.asm"
	.title	"string printing stuff"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"
	.include	"display.equ"
	.include	"sys.equ"
	.include	"gsp.equ"
	.include	"macros.h"
	.include	"game.equ"
	.include	"audit.equ"

	.include	"fontsimg.glo"
	.include	"bgndtbl.glo"

;sounds


******************************************************************************
* EXTERNAL REFERENCES

	.ref	BINBCD

******************************************************************************

;symbols defined in this file

	.def	message_palette
	.def	mess_space_width
	.def	print_string,print_string2,print_string_C,print_string_C2
	.def	print_string_R,print_string_R2
	.def	message_ascii
	.def	mess_spacing
	.def	mess_objid
	.def	mess_cursx
	.def	mess_cursy
	.def	osgemd_ascii,sgmd8_ascii,osgmd8_ascii
	.def	lgmd_ascii,omlgmd_ascii,ogmd10_ascii
	.def	font9_ascii

	.def	message_buffer
	.def	message_buffer2
	.def	dec_to_asc,dec_to_pct
	.def	copy_string,copy_rom_string
	.def	concat_string,concat_rom_string

	.def	print_message,setup_message
	.def	mess_line_spacing
	.def	get_string_len2
	.def	dec_to_asc_new_entry

MBUFF_SIZE	equ	40

;ram
	.bss	message_ascii,	32	;* ascii lookup table
	.bss	message_palette,32	;* palette
	.bss	message_buffer,	16*MBUFF_SIZE ;null terminated string
	.bss	message_buffer2, 16*MBUFF_SIZE
	.bss	mess_cursx,	16	;message cursor pos X original
	.bss	mess_cursx2,	16	;message cursor pos X temp
	.bss	mess_cursy,	16	;message cursor pos Y
	.bss	mess_space_width, 16	;width in pixels of space char
	.bss	mess_spacing,16		;spacing between chars
	.bss	mess_line_spacing,16	;spacing between lines
	.bss	mess_objid,16		;OBJECT ID for string
	.bss	mess_justify,32		;justification method
	.bss	ptr_player_data,32	;start address of player data
	BSSX	IGNORE_CHAR_WIDTH,16
	.text

#*****************************************************************************

 SUBRP	clear_buffers

	callr	clear_buffer
	callr	clear_buffer2
	rets

clear_buffer
	movi	MBUFF_SIZE,a2
	clr	a0
	movi	message_buffer,a1
#clear_loop1
	move	a0,*a1+
	dsj	a2,#clear_loop1
	rets

clear_buffer2
	movi	MBUFF_SIZE,a2
	clr	a0
	movi	message_buffer2,a1
#clear_loop2
	move	a0,*a1+
	dsj	a2,#clear_loop2
	rets


#*****************************************************************************
*
* INPUT:	a0 = number to convert
*		a1 = max value
* converts value in A0 to an decimal ASCII string in message_buffer2
* - removes leading spaces
*
*-----------------------------------------------------------------------------

 SUBRP	dec_to_asc

	cmp	a0,a1			;a1-a0
	jrhi	#not_max
	move	a1,a0			;set num to max
#not_max

	calla	BINBCD			;dec number in A0
	move	a0,a1
	movi	message_buffer2,a2

dec_to_asc_new_entry

	clr	a3			;leading zero flag

	andi	0f000000h,a0
	srl	6*4,a0
	jrnz	#no_zero_n3
	move	a3,a3			;leading zero
	jrz	#skip_zero_n3
#no_zero_n3
	inc	a3
	addi	'0',a0
	movb	a0,*a2
	addk	8,a2
#skip_zero_n3

	move	a1,a0
	andi	0f00000h,a0
	srl	5*4,a0
	jrnz	#no_zero_n2
	move	a3,a3			;leading zero
	jrz	#skip_zero_n2
#no_zero_n2
	inc	a3
	addi	'0',a0
	movb	a0,*a2
	addk	8,a2
#skip_zero_n2

	move	a1,a0
	andi	0f0000h,a0
	srl	4*4,a0
	jrnz	#no_zero_n1
	move	a3,a3			;leading zero
	jrz	#skip_zero_n1
#no_zero_n1
	inc	a3
	addi	'0',a0
	movb	a0,*a2
	addk	8,a2
#skip_zero_n1

	move	a1,a0


	andi	0f000h,a0
	srl	3*4,a0
	jrnz	#no_zero0
	move	a3,a3			;leading zero
	jrz	#skip_zero0
#no_zero0
	inc	a3
	addi	'0',a0
	movb	a0,*a2
	addk	8,a2
#skip_zero0

	move	a1,a0
	andi	0f00h,a0
	srl	2*4,a0
	jrnz	#no_zero1
	move	a3,a3			;leading zero
	jrz	#skip_zero1
#no_zero1
	inc	a3
	addi	'0',a0
	movb	a0,*a2
	addk	8,a2
#skip_zero1

	move	a1,a0
	andi	0f0h,a0
	srl	1*4,a0
	jrnz	#no_zero2
	move	a3,a3			;leading zero
	jrz	#skip_zero2
#no_zero2
	inc	a3
	addi	'0',a0
	movb	a0,*a2
	addk	8,a2
#skip_zero2

	move	a1,a0
	andi	0fh,a0
	addi	'0',a0
	movb	a0,*a2
	addk	8,a2
	clr	a0
	movb	a0,*a2			;null terminate string

	rets


#*****************************************************************************
*
* INPUT:	a0 = number to convert
* converts value in A0 to an decimal ASCII % string in message_buffer2
* range 000-999
*
*-----------------------------------------------------------------------------

 SUBRP	dec_to_pct

	calla	BINBCD			;dec number in A0
	move	a0,a1
	movi	message_buffer2,a2

	andi	0f00h,a0
	srl	2*4,a0
	addi	'0',a0
	movb	a0,*a2
	addk	8,a2

	move	a1,a0
	andi	0f0h,a0
	srl	1*4,a0
	addi	'0',a0
	movb	a0,*a2
	addk	8,a2

	move	a1,a0
	andi	0fh,a0
	addi	'0',a0
	movb	a0,*a2
	addk	8,a2
	clr	a0
	movb	a0,*a2			;null terminate string

	rets


#*****************************************************************************
*
* copies string in message_buffer2 to message_buffer
*
*-----------------------------------------------------------------------------

 SUBRP	copy_string

	movi	message_buffer-8,a2
	movi	message_buffer2-8,a3

#next_char
	addk	8,a2
	addk	8,a3
	movb	*a3,*a2
	movb	*a3,a0				;NULL?
	jrnz	#next_char

	rets

#*****************************************************************************
*
* concatenates string in message_buffer2 to string in message_buffer
*
*-----------------------------------------------------------------------------

 SUBRP	concat_string

	movi	message_buffer-8,a2
	movi	message_buffer2-8,a3
#next_char
	addk	8,a2
	movb	*a2,a0
	jrnz	#next_char
	subk	8,a2

#next_char2
	addk	8,a2
	addk	8,a3
	movb	*a3,*a2
	movb	*a3,a0				;NULL?
	jrnz	#next_char2

	rets

#*****************************************************************************
*
* INPUT:	a4 = * null terminated rom string
*
* copies string in rom to message_buffer
*
*-----------------------------------------------------------------------------

 SUBRP	copy_rom_string

	movi	message_buffer-8,a1

	subk	8,a4

#next_char
	addk	8,a1
	addk	8,a4
	movb	*a4,*a1
	movb	*a4,a0				;NULL ?
	jrnz	#next_char

	rets

#*****************************************************************************
*
* INPUT:	a4 = * null terminated rom string
*
* concatenates string in rom to string in message_buffer
*
*-----------------------------------------------------------------------------

 SUBRP	concat_rom_string

	movi	message_buffer-8,a1
#next_char
	addk	8,a1
	movb	*a1,a0
	jrnz	#next_char

	subk	8,a1
	subk	8,a4

#next_char2
	addk	8,a1
	addk	8,a4
	movb	*a4,*a1
	movb	*a4,a0				;NULL ?
	jrnz	#next_char2

	rets

#*****************************************************************************
*
* INPUT:	a4 = * NULL terminated ASCII string (print_string2)
*
* RETURN:	a2 = width of string in pixels
*
*-----------------------------------------------------------------------------

 SUBRP	get_string_len

	movi	message_buffer,a4
get_string_len2
	clr	a2
	subk	8,a4
#next_char
	addk	8,a4
	movb	*a4,a0
	andi	0ffh,a0
	jrz	#done
	cmpi	1,a0
	jreq	#done
	cmpi	32,a0
	jrne	#no_space
	move	@mess_space_width,a0
	add	a0,a2
	jruc	#next_char
#no_space
	sll	5,a0			;x 32 bits
	move	@message_ascii,a1,L
	add	a1,a0
	move	*a0,a1,L		;* image
	jrz	#next_char
	MOVE	@IGNORE_CHAR_WIDTH,A0
	JRNZ	#IGNORE_IT
	move	*a1,a0			;image width
	add	a0,a2
#IGNORE_IT
	move	@mess_spacing,a0
	add	a0,a2
	jruc	#next_char

#done
	move	@mess_spacing,a0
	sub	a0,a2
	rets

#*****************************************************************************
*
* INPUT:	a4 = * NULL terminated ASCII string (print_string_C2)
*		centers & prints a text string
*
*-----------------------------------------------------------------------------

 SUBRP	print_string_C

	movi	message_buffer,a4
	movi	#center_justify,a0
	move	a0,@mess_justify,L	;justification method
	callr	#center_justify
	callr	print_string2b
	rets

print_string_C2
	movi	#center_justify,a0
	move	a0,@mess_justify,L	;justification method
	callr	#center_justify
	callr	print_string2b
	rets

#center_justify
	PUSH	a2,a4
	callr	get_string_len2
	srl	1,a2			;/2
	move	@mess_cursx,a0
	sub	a2,a0			;- string_width/2
	move	a0,@mess_cursx2		;message cursor pos X
	PULL	a2,a4
	rets

#*****************************************************************************
*
* INPUT:	a4 = * NULL terminated ASCII string (print_string_C2)
*		right justifies & prints a text string
*
*-----------------------------------------------------------------------------

 SUBRP	print_string_R

	movi	message_buffer,a4
	movi	#right_justify,a0
	move	a0,@mess_justify,L	;justification method
	callr	#right_justify
	callr	print_string2b
	rets

print_string_R2
	movi	#right_justify,a0
	move	a0,@mess_justify,L	;justification method
	callr	#right_justify
	callr	print_string2b
	rets

#right_justify
	PUSH	a2,a4
	callr	get_string_len2
	move	@mess_cursx,a0
	sub	a2,a0			;- string_width/2
	move	a0,@mess_cursx2		;message cursor pos X
	PULL	a2,a4
	rets

#*****************************************************************************
*
* INPUT:	a4 = * NULL terminated ASCII string (print_string2)
*
*-----------------------------------------------------------------------------

#left_justify
	move	@mess_cursx,a0
	move	a0,@mess_cursx2
	rets

 SUBRP	print_string

	movi	message_buffer,a4

print_string2
	movi	#left_justify,a0
	move	a0,@mess_justify,L	;justification method
	move	@mess_cursx,a0
	move	a0,@mess_cursx2
print_string2b

	subk	8,a4
#next_char
	addk	8,a4
	movb	*a4,a0
	andi	0ffh,a0
	jrz	#done
	cmpi	1,a0
	jrne	#no_newline
;newline
	move	@mess_line_spacing,a0
	move	@mess_cursy,a1
	add	a0,a1
	move	a1,@mess_cursy

	move	@mess_justify,a0,L	;justification method
	addi	8,a4			;skip newline char
	call	a0
	subi	8,a4
	jruc	#next_char
#no_newline
	cmpi	32,a0
	jrne	#no_space
;space
	move	@mess_space_width,a0
	move	@mess_cursx2,a1
	add	a0,a1
	move	a1,@mess_cursx2
	jruc	#next_char
#no_space
	sll	5,a0			;x 32 bits
	move	@message_ascii,a1,L
	add	a1,a0
	move	*a0,a2,L		;* image
	jrz	#next_char

	PUSH	a4,a8
	move	@message_palette,b0,L	;* palette
	move	@mess_cursx2,a0
	sll	16,a0			;x val
	move	@mess_cursy,a1
	sll	16,a1			;y val
;	movi	120,a3			;z pos
	movi	20000,a3		;Z
	movi	DMAWNZ|M_SCRNREL,a4	;DMA flags
	move	@mess_objid,a5		;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJP
	move	@mess_cursx2,a1
	MOVE	@IGNORE_CHAR_WIDTH,A0
	JRNZ	#IGNORE_IT
	move	*a8(OSIZEX),a0
	add	a0,a1
#IGNORE_IT
	move	@mess_spacing,a0
	add	a0,a1
	move	a1,@mess_cursx2
	PULL	a4,a8
	jruc	#next_char

#done
	rets

#*****************************************************************************
*
* INPUT	:	a2 = * to message
*
*-----------------------------------------------------------------------------

 SUBRP	setup_message

	movi	TYPTEXT,a0
	move	a0,@mess_objid		;OBJ ID's for text

	move	*a2+,a0,L		;* ascii lookup table
	move	a0,@message_ascii,L	;
	move	*a2+,a0			;space char width
	move	a0,@mess_space_width	;
	move	*a2+,a0			;spacing between chars
	move	a0,@mess_spacing	;
	move	*a2+,a0			;message cursor pos X
	move	a0,@mess_cursx		;
	move	*a2+,a0			;message cursor pos Y
	move	a0,@mess_cursy		;
	move	*a2+,a0,L
	move	a0,@message_palette,L
	movi	#rets,a0
	move	a0,@mess_justify,L	;justification method
#rets
	rets


#*****************************************************************************
*
* INPUT	:	a2 = * to message
*
*-----------------------------------------------------------------------------

 SUBRP	print_message

	PUSH	a4,a5,a6,a7,a8,a9,a10,a11

	movi	TYPTEXT,a0
	move	a0,@mess_objid		;OBJ ID's for text

	move	*a2+,a0,L		;* ascii lookup table
	move	a0,@message_ascii,L	;
	move	*a2+,a0			;space char width
	move	a0,@mess_space_width	;
	move	*a2+,a0			;spacing between chars
	move	a0,@mess_spacing	;
	move	*a2+,a0			;message cursor pos X
	move	a0,@mess_cursx		;
	move	*a2+,a0			;message cursor pos Y
	move	a0,@mess_cursy		;
	move	*a2+,a0,L
	move	a0,@message_palette,L
	move	*a2+,a0,L		;print method

	move	a2,a4			;* text string
	call	a0

	PULL	a4,a5,a6,a7,a8,a9,a10,a11
	rets


#*****************************************************************************

init_convert_table
	.word	'A','B','C','D','E','F','G','H'
	.word	'I','J','K','L','M','N','O','P'
	.word	'Q','R','S','T','U','V','W','X'
	.word	'Y','Z',' '

#*****************************************************************************

font9_ascii
 .long 0,0,0,0,0,0,0,0							;$00
 .long 0,0,0,0,0,0,0,0							;$08
 .long FNT9_SPC,FNT9_DEL,FNT9_END,0,0,0,0,0	    		;$10	SPC,BAK,END
 .long 0,0,0,0,0,0,0,0							;$18
 .long 0,FNT9_EXP,0,0,0,0,0,0						;$20	SP! " # $ % & '
 .long 0,0,0,0,0,0,0,0							;$28	( ) * + , - . /
 .long FNT9_0,FNT9_1,FNT9_2,FNT9_3,FNT9_4,FNT9_5,FNT9_6,FNT9_7		;$30	0 1 2 3 4 5 6 7
 .long FNT9_8,FNT9_9,FNT9_COL,0,0,0,0,0					;$38	8 9 : ; < - > ?
 .long 0,FNT9_A,FNT9_B,FNT9_C,FNT9_D,FNT9_E,FNT9_F,FNT9_G		;$40	@ A B C D E F G
 .long FNT9_H,FNT9_I,FNT9_J,FNT9_K,FNT9_L,FNT9_M,FNT9_N,FNT9_O		;$48	H I J K L M N O
 .long FNT9_P,FNT9_Q,FNT9_R,FNT9_S,FNT9_T,FNT9_U,FNT9_V,FNT9_W		;$50	P Q R S T U V W
 .long FNT9_X,FNT9_Y,FNT9_Z,0,0,0,0,0					;$58	X Y Z [ \ ] ^ _
 .long 0,FNT9_A,FNT9_B,FNT9_C,FNT9_D,FNT9_E,FNT9_F,FNT9_G		;$60	` a b c d e f g
 .long FNT9_H,FNT9_I,FNT9_J,FNT9_K,FNT9_L,FNT9_M,FNT9_N,FNT9_O		;$68	h i j k l m n o
 .long FNT9_P,FNT9_Q,FNT9_R,FNT9_S,FNT9_T,FNT9_U,FNT9_V,FNT9_W		;$70	p q r s t u v w
 .long FNT9_X,FNT9_Y,FNT9_Z,0,0,0,0,0					;$78	x y z { | } ~

osgemd_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long OSGEMD_SPC,OSGEMD_DEL,OSGEMD_END,0,0,0,0,0				;$10	SPC,BAK,END
 .long 0,0,0,0,0,0,0,0								;$18
 .long 0,OSGEMD_EXP,0,OSGEMD_NUM,OSGEMD_DOL,0,OSGEMD_AND,OSGEMD_APO		;$20	SP! " # $ % & '
 .long OSGEMD_OBR,OSGEMD_CBR,0,0,0,OSGEMD_DAS,OSGEMD_DOT,OSGEMD_SLS		;$28	( ) * + , - . /
 .long OSGEMD_0,OSGEMD_1,OSGEMD_2,OSGEMD_3,OSGEMD_4,OSGEMD_5,OSGEMD_6,OSGEMD_7	;$30	0 1 2 3 4 5 6 7
 .long OSGEMD_8,OSGEMD_9,OSGEMD_COL,0,0,0,0,OSGEMD_QUE				;$38	8 9 : ; < - > ?
 .long 0,OSGEMD_A,OSGEMD_B,OSGEMD_C,OSGEMD_D,OSGEMD_E,OSGEMD_F,OSGEMD_G		;$40	@ A B C D E F G
 .long OSGEMD_H,OSGEMD_I,OSGEMD_J,OSGEMD_K,OSGEMD_L,OSGEMD_M,OSGEMD_N,OSGEMD_O	;$48	H I J K L M N O
 .long OSGEMD_P,OSGEMD_Q,OSGEMD_R,OSGEMD_S,OSGEMD_T,OSGEMD_U,OSGEMD_V,OSGEMD_W	;$50	P Q R S T U V W
 .long OSGEMD_X,OSGEMD_Y,OSGEMD_Z,0,0,0,0,0					;$58	X Y Z [ \ ] ^ _
 .long 0,OSGEMD_A,OSGEMD_B,OSGEMD_C,OSGEMD_D,OSGEMD_E,OSGEMD_F,OSGEMD_G		;$60	` a b c d e f g
 .long OSGEMD_H,OSGEMD_I,OSGEMD_J,OSGEMD_K,OSGEMD_L,OSGEMD_M,OSGEMD_N,OSGEMD_O	;$68	h i j k l m n o
 .long OSGEMD_P,OSGEMD_Q,OSGEMD_R,OSGEMD_S,OSGEMD_T,OSGEMD_U,OSGEMD_V,OSGEMD_W	;$70	p q r s t u v w
 .long OSGEMD_X,OSGEMD_Y,OSGEMD_Z,0,0,0,0,0					;$78	x y z { | } ~

sgmd8_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long 0,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0								;$18
 .long 0,SGMD8_EXP,0,SGMD8_NUM,0,SGMD8_PCT,SGMD8_AND,SGMD8_APO			;$20	SP! " # $ % & '
 .long SGMD8_OBR,SGMD8_CBR,0,0,SGMD8_COM,SGMD8_DAS,SGMD8_DOT,SGMD8_SLS		;$28	( ) * + , - . /
 .long SGMD8_0,SGMD8_1,SGMD8_2,SGMD8_3,SGMD8_4,SGMD8_5,SGMD8_6,SGMD8_7		;$30	0 1 2 3 4 5 6 7
 .long SGMD8_8,SGMD8_9,SGMD8_COL,0,0,0,0,0					;$38	8 9 : ; < - > ?
 .long 0,SGMD8_A,SGMD8_B,SGMD8_C,SGMD8_D,SGMD8_E,SGMD8_F,SGMD8_G		;$40	@ A B C D E F G
 .long SGMD8_H,SGMD8_I,SGMD8_J,SGMD8_K,SGMD8_L,SGMD8_M,SGMD8_N,SGMD8_O		;$48	H I J K L M N O
 .long SGMD8_P,SGMD8_Q,SGMD8_R,SGMD8_S,SGMD8_T,SGMD8_U,SGMD8_V,SGMD8_W		;$50	P Q R S T U V W
 .long SGMD8_X,SGMD8_Y,SGMD8_Z,0,0,0,0,0					;$58	X Y Z [ \ ] ^ _
 .long 0,SGMD8_A,SGMD8_B,SGMD8_C,SGMD8_D,SGMD8_E,SGMD8_F,SGMD8_G		;$60	` a b c d e f g
 .long SGMD8_H,SGMD8_I,SGMD8_J,SGMD8_K,SGMD8_L,SGMD8_M,SGMD8_N,SGMD8_O		;$68	h i j k l m n o
 .long SGMD8_P,SGMD8_Q,SGMD8_R,SGMD8_S,SGMD8_T,SGMD8_U,SGMD8_V,SGMD8_W		;$70	p q r s t u v w
 .long SGMD8_X,SGMD8_Y,SGMD8_Z,0,0,0,0,0					;$78	x y z { | } ~

osgmd8_ascii
 .long 0,0,0,0,0,0,0,0									;$00
 .long 0,0,0,0,0,0,0,0									;$08
 .long 0,0,0,0,0,0,0,0									;$10
 .long 0,0,0,0,0,0,0,0									;$18
 .long 0,osgmd8_EXP,0,osgmd8_NUM,0,osgmd8_PCT,osgmd8_AND,osgmd8_APO			;$20	SP! " # $ % & '
 .long osgmd8_OBR,osgmd8_CBR,0,0,osgmd8_COM,osgmd8_DAS,osgmd8_DOT,osgmd8_SLS		;$28	( ) * + , - . /
 .long osgmd8_0,osgmd8_1,osgmd8_2,osgmd8_3,osgmd8_4,osgmd8_5,osgmd8_6,osgmd8_7		;$30	0 1 2 3 4 5 6 7
 .long osgmd8_8,osgmd8_9,osgmd8_COL,0,0,0,0,0						;$38	8 9 : ; < - > ?
 .long 0,osgmd8_A,osgmd8_B,osgmd8_C,osgmd8_D,osgmd8_E,osgmd8_F,osgmd8_G			;$40	@ A B C D E F G
 .long osgmd8_H,osgmd8_I,osgmd8_J,osgmd8_K,osgmd8_L,osgmd8_M,osgmd8_N,osgmd8_O		;$48	H I J K L M N O
 .long osgmd8_P,osgmd8_Q,osgmd8_R,osgmd8_S,osgmd8_T,osgmd8_U,osgmd8_V,osgmd8_W		;$50	P Q R S T U V W
 .long osgmd8_X,osgmd8_Y,osgmd8_Z,0,0,0,0,0						;$58	X Y Z [ \ ] ^ _
 .long 0,osgmd8_A,osgmd8_B,osgmd8_C,osgmd8_D,osgmd8_E,osgmd8_F,osgmd8_G			;$60	` a b c d e f g
 .long osgmd8_H,osgmd8_I,osgmd8_J,osgmd8_K,osgmd8_L,osgmd8_M,osgmd8_N,osgmd8_O		;$68	h i j k l m n o
 .long osgmd8_P,osgmd8_Q,osgmd8_R,osgmd8_S,osgmd8_T,osgmd8_U,osgmd8_V,osgmd8_W		;$70	p q r s t u v w
 .long osgmd8_X,osgmd8_Y,osgmd8_Z,osgmd8_OPQ,0,osgmd8_CLQ,0,0				;$78	x y z { | } ~

lgmd_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long 0,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0								;$18
 .long 0,lgmd_EXP,0,lgmd_NUM,0,0,0,0						;$20	SP! " # $ % & '
 .long 0,0,0,0,0,0,lgmd_DOT,0							;$28	( ) * + , - . /
 .long lgmd_0,lgmd_1,lgmd_2,lgmd_3,lgmd_4,lgmd_5,lgmd_6,lgmd_7			;$30	0 1 2 3 4 5 6 7
 .long lgmd_8,lgmd_9,lgmd_COL,0,0,0,0,0						;$38	8 9 : ; < - > ?
 .long 0,lgmd_A,lgmd_B,lgmd_C,lgmd_D,lgmd_E,lgmd_F,lgmd_G			;$40	@ A B C D E F G
 .long lgmd_H,lgmd_I,lgmd_J,lgmd_K,lgmd_L,lgmd_M,lgmd_N,lgmd_O			;$48	H I J K L M N O
 .long lgmd_P,lgmd_Q,lgmd_R,lgmd_S,lgmd_T,lgmd_U,lgmd_V,lgmd_W			;$50	P Q R S T U V W
 .long lgmd_X,lgmd_Y,lgmd_Z,0,0,0,0,0						;$58	X Y Z [ \ ] ^ _
 .long 0,lgmd_A,lgmd_B,lgmd_C,lgmd_D,lgmd_E,lgmd_F,lgmd_G			;$60	` a b c d e f g
 .long lgmd_H,lgmd_I,lgmd_J,lgmd_K,lgmd_L,lgmd_M,lgmd_N,lgmd_O			;$68	h i j k l m n o
 .long lgmd_P,lgmd_Q,lgmd_R,lgmd_S,lgmd_T,lgmd_U,lgmd_V,lgmd_W			;$70	p q r s t u v w
 .long lgmd_X,lgmd_Y,lgmd_Z,0,0,0,0,0						;$78	x y z { | } ~

omlgmd_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long 0,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0								;$18
 .long 0,omlgmd_EXP,0,0,0,0,0,0							;$20	SP! " # $ % & '
 .long 0,0,0,0,0,0,omlgmd_DOT,0							;$28	( ) * + , - . /
 .long 0,0,0,0,0,0,0,0								;$30	0 1 2 3 4 5 6 7
 .long 0,0,0,0,0,0,0,0								;$38	8 9 : ; < - > ?
 .long 0,omlgmd_A,omlgmd_B,omlgmd_C,omlgmd_D,omlgmd_E,omlgmd_F,omlgmd_G		;$40	@ A B C D E F G
 .long omlgmd_H,omlgmd_I,omlgmd_J,omlgmd_K,omlgmd_L,omlgmd_M,omlgmd_N,omlgmd_O	;$48	H I J K L M N O
 .long omlgmd_P,omlgmd_Q,omlgmd_R,omlgmd_S,omlgmd_T,omlgmd_U,omlgmd_V,omlgmd_W	;$50	P Q R S T U V W
 .long omlgmd_X,omlgmd_Y,omlgmd_Z,0,0,0,0,0					;$58	X Y Z [ \ ] ^ _
 .long 0,omlgmd_A,omlgmd_B,omlgmd_C,omlgmd_D,omlgmd_E,omlgmd_F,omlgmd_G		;$60	` a b c d e f g
 .long omlgmd_H,omlgmd_I,omlgmd_J,omlgmd_K,omlgmd_L,omlgmd_M,omlgmd_N,omlgmd_O	;$68	h i j k l m n o
 .long omlgmd_P,omlgmd_Q,omlgmd_R,omlgmd_S,omlgmd_T,omlgmd_U,omlgmd_V,omlgmd_W	;$70	p q r s t u v w
 .long omlgmd_X,omlgmd_Y,omlgmd_Z,0,0,0,0,0					;$78	x y z { | } ~

ogmd10_ascii
 .long 0,0,0,0,0,0,0,0									;$00
 .long 0,0,0,0,0,0,0,0									;$08
 .long 0,0,0,0,0,0,0,0									;$10
 .long 0,0,0,0,0,0,0,0									;$18
 .long 0,osgmd10_EXP,0,osgmd10_NUM,osgmd10_DOL,osgmd10_PCT,osgmd10_AND,osgmd10_APO	;$20	SP! " # $ % & '
 .long osgmd10_OBR,osgmd10_CBR,0,0,osgmd10_COM,osgmd10_DAS,osgmd10_DOT,osgmd10_SLS	;$28	( ) * + , - . /
 .long osgmd10_0,osgmd10_1,osgmd10_2,osgmd10_3,osgmd10_4,osgmd10_5,osgmd10_6,osgmd10_7	;$30	0 1 2 3 4 5 6 7
 .long osgmd10_8,osgmd10_9,osgmd10_COL,0,0,0,0,0					;$38	8 9 : ; < - > ?
 .long 0,osgmd10_A,osgmd10_B,osgmd10_C,osgmd10_D,osgmd10_E,osgmd10_F,osgmd10_G		;$40	@ A B C D E F G
 .long osgmd10_H,osgmd10_I,osgmd10_J,osgmd10_K,osgmd10_L,osgmd10_M,osgmd10_N,osgmd10_O	;$48	H I J K L M N O
 .long osgmd10_P,osgmd10_Q,osgmd10_R,osgmd10_S,osgmd10_T,osgmd10_U,osgmd10_V,osgmd10_W	;$50	P Q R S T U V W
 .long osgmd10_X,osgmd10_Y,osgmd10_Z,0,0,0,0,0						;$58	X Y Z [ \ ] ^ _
 .long 0,osgmd10_A,osgmd10_B,osgmd10_C,osgmd10_D,osgmd10_E,osgmd10_F,osgmd10_G		;$60	` a b c d e f g
 .long osgmd10_H,osgmd10_I,osgmd10_J,osgmd10_K,osgmd10_L,osgmd10_M,osgmd10_N,osgmd10_O	;$68	h i j k l m n o
 .long osgmd10_P,osgmd10_Q,osgmd10_R,osgmd10_S,osgmd10_T,osgmd10_U,osgmd10_V,osgmd10_W	;$70	p q r s t u v w
 .long osgmd10_X,osgmd10_Y,osgmd10_Z,0,0,0,0,0						;$78	x y z { | } ~

******************************************************************************

;end




