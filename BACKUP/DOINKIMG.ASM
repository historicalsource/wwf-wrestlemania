	.FILE "doinkimg.asm"
	.OPTION B,D,L,T

	.include imgtbl.glo
	.DATA
	.even

	.include doinkimg.tbl
	.include doinkimg.h

******************************************************************************

	.even
	.include "doink.seq"

	.global	D2ST2B03

******************************************************************************
; END
