;Sound scheduling debug stuff

	.if DEBUG
SND_DEBUG	.equ	1
	.else
SND_DEBUG	.equ	0	;this one is always zero!
	.endif

*STRUCT SNDCAL
INDEX	.set	0	;UHW triple_sound table index
TSTMP	.set	20h	;UDW PCNT timestamp (stored long, only show low word)
CALLER	.set	30h	;UHL address of call
CHAN0	.set	50h	;UHW channel 0 call #
PRI	.set	60h	;UHW priority
DUR	.set	70h	;UDW duration
CHANL	.set	80h	;UHW channel played on (-1=not played)
ACTION	.set	90h	;UHW see list below
ADRS	.set	0A0h	;UHL address of table entry
*ENDSTRUCT
SNDCALSIZ .set	0C0h

SDA_EMPTY	.equ	0	;sound call okay, played on empty channel
SDA_PREEMPT	.equ	1	;sound call okay, preempts another call
SDA_LOPRI	.equ	2	;sound call okay, dropped -- priority too low
SDA_BADNDX	.equ	3	;bad index -- ignored
SDA_ZCALL	.equ	4	;index in range, but points to a zero entry
