;temp buckoff debugging stuff

*STRUCT DBGEVENT
TSTMP		.set	0	;UHW PCNT timestamp
EVENT		.set	20h	;UHW event type
DATA1		.set	30h	;UHL data #1
DATA2		.set	50h	;UHL data #2
DATA3		.set	70h	;UHL data #3
*ENDSTRUCT
EVENTSIZ 	.set	90h

;Event codes
BDE_DIES	.equ	1	;wrestler dies
				;DATA1 = wrestler process
				;DATA2 = wrestlernum
				;DATA3 = playernum
BDE_MAYBE_BUCK	.equ	2	;dead guy who can buckoff found
				;DATA1 = wrestler process
				;DATA2 = wrestlernum
				;DATA3 = playernum
BDE_DONE_BUCK	.equ	3	;successful buckoff
				;DATA1 = wrestler process
				;DATA2 = wrestlernum
				;DATA3 = playernum
BDE_ARW_START	.equ	4	;announce_rnd_winner starts
				;DATA1 = arw process
				;DATA2 = creator
				;DATA3 = loc of creation
BDE_ARW_DEXIST	.equ	5	;announce_rnd_winner dies on EXISTP call
				;DATA1 = arw process
				;DATA2 = creator
				;DATA3 = loc of creation
BDE_ARW_FLAGDIE	.equ	6	;announce_rnd_winner dies on flag test
				;DATA1 = arw process
				;DATA2 = creator
				;DATA3 = loc of creation
BDE_ARW_ATTEMPT	.equ	7	;ann_rnd_wnr finds a potential bucker and sleeps
				;DATA1 = arw process
				;DATA2 = creator
				;DATA3 = loc of creation
BDE_ARW_WAKEUP	.equ	8	;ann_rnd_wnr wakes up to look for buckoffs
				;DATA1 = arw process
				;DATA2 = creator
				;DATA3 = loc of creation
BDE_ARW_NOBUCK	.equ	9	;ann_rnd_wnr finds no buckers
				;DATA1 = arw process
				;DATA2 = creator
				;DATA3 = loc of creation
BDE_ARW_ENDRND	.equ	10	;ann_rnd_wnr goes off
				;DATA1 = arw process
				;DATA2 = creator
				;DATA3 = loc of creation
BDE_ALL_DEAD	.equ	11	;all-dead condition found by match_timer
BDE_ALL_ALIVE	.equ	12	;ann_rnd_wnr finds both teams alive and dies
				;DATA1 = arw process
				;DATA2 = creator
				;DATA3 = loc of creation


NUM_EVENTS	.equ	50

	.global	event_data
	.global	event_ptr

DBEVENT	.macro	ETYPE,D1,S1,D2,S2,D3,S3
	mmtm	sp,a0,a14
	move	@event_ptr,a0,L
	move	@PCNT,a14,L
	move	a14,*a0(TSTMP),L
	movi	:ETYPE:,a14
	move	a14,*a0(EVENT)
	move	:D1:,*a0(DATA1),:S1:
	move	:D2:,*a0(DATA2),:S2:
	move	:D3:,*a0(DATA3),:S3:
	addi	EVENTSIZ,a0
	cmpi	event_data+(EVENTSIZ*NUM_EVENTS),a0
	jrlt	ok?
	movi	event_data,a0
ok?	move	a0,@event_ptr,L
	mmfm	sp,a0,a14
	.endm
