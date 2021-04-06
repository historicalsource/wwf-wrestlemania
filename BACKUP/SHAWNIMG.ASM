	.FILE "shawnimg.asm"
	.OPTION B,D,L,T

	.include imgtbl.glo
	.DATA
	.even

	.include shawnimg.tbl
	.include shawnimg.h


******************************************************************************

	.even
	.include "shawn.seq"
 
******************************************************************************
; END
