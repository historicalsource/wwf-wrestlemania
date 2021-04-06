	.FILE "bretimg.asm"
	.OPTION B,D,L,T

	.include imgtbl.glo
	.DATA
	.even

	.include bretimg.tbl
	.include bretimg.h

******************************************************************************

	.even
	.include "bret.seq"

******************************************************************************
; END
