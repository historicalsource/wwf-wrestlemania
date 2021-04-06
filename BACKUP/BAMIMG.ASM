	.FILE "bamimg.asm"
	.OPTION B,D,L,T

	.include imgtbl.glo
	.DATA
	.even

	.include bamimg.tbl
	.include bamimg.h

******************************************************************************

	.even
	.include "bam.seq"

******************************************************************************
; END
