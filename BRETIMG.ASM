	.FILE "bretimg.asm"
	.OPTION B,D,L,T

	.include imgtbl.glo
	.DATA
	.even

	.include bretimg.tbl
	.include bretimg.h

	.def	H4ST4A02

******************************************************************************

	.even
	.include "bret.seq"

******************************************************************************

	.end
