	.FILE "leximg.asm"
	.OPTION B,D,L,T

	.include imgtbl.glo
	.DATA
	.even

	.include leximg.tbl
	.include leximg.h

******************************************************************************

	.even
	.include "lex.seq"

******************************************************************************

	.end
