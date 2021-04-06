	.FILE "adamimg.asm"
	.OPTION B,D,L,T

	.include imgtbl.glo
	.DATA
	.even

	.include adamimg.tbl
	.include adamimg.h

******************************************************************************

	.even
	.include "adam.seq"

******************************************************************************
; END
