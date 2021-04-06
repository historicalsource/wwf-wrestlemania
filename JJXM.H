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

SMRTTGT		.macro	REG,TGT
	move	*:REG:(STATUS_FLAGS),a14
	ori	M_SMART_ATTACK,a14
	move	a14,*:REG:(STATUS_FLAGS)
	move	*:REG:(:TGT:),*:REG:(SMART_TARGET),L
		.endm

RND_AWARD	.macro	REG,AWARD_INDEX
	PUSH	a0,a10
	move	:REG:,a0
	movi	:AWARD_INDEX:,a10
	calla	round_award
	PULL	a0,a10
		.endm

MATCH_AWARD	.macro	REG,AWARD_INDEX
	PUSH	a0,a10
	move	:REG:,a0
	movi	:AWARD_INDEX:,a10
	calla	match_award
	PULL	a0,a10
		.endm
