JJXM_DEBUG	.equ	1

JJXM_INIT	.macro

	calla	get_opp_plyrmode
	move	*a13(CLOSEST_XDIST),a1
	move	*a13(CLOSEST_ZDIST),a2

		.endm


JJXM		.macro	MODE,DX,DZ,LESS,MORE

	cmpi	MODE_:MODE:,a0
	jrne	DONE?

	.if $isname(DX)
	jruc	:DX:
	.else
	cmpi	:DX:,a1
	jrgt	:MORE:
	cmpi	:DZ:,a2
	jrgt	:MORE:
	jruc	:LESS:
	.endif

DONE?
		.endm

JJXM_END	.macro
	.if JJXM_DEBUG
	LOCKUP
	rets
	.endif
		.endm



