	.FILE "takerimg.asm"
	.OPTION B,D,L,T

	.include imgtbl.glo
	.DATA
	.even

	.include takerimg.tbl
	.include takerimg.h

******************************************************************************

	.even
	.include "taker.seq"

******************************************************************************

	.end
