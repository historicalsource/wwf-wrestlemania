	.FILE "yokoimg.asm"
	.OPTION B,D,L,T

	.include imgtbl.glo
	.DATA
	.even

	.include yokoimg.tbl
	.include yokoimg.h

******************************************************************************

	.even
	.include "yoko.seq"

******************************************************************************

	.end
