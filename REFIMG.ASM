	.FILE "refimg.asm"
	.OPTION B,D,L,T

	.include imgtbl.glo
	.DATA
	.even

	.include refimg.h
	.include refimg.tbl

******************************************************************************

	.even
	.include "ref.seq"

******************************************************************************
; END
