	.FILE "razorimg.asm"
	.OPTION B,D,L,T

	.include imgtbl.glo
	.DATA
	.even

	.include razorimg.tbl
	.include razorimg.h

******************************************************************************

	.even
	.include "razor.seq"

******************************************************************************

	.end
