***************************************************************************
*
* Mnemonics for sound calls
*

MUSIC_ON	equ	1

SELECT_TUNE	equ	15h

bounce_l1	equ	009h	;sound of landing on the mat

;run_snd		equ	009h	;sound of footsteps while running
run_snd		equ	0C0h	;sound of footsteps while running

seltimer_onsnd	equ	001h
seltimer_offsnd	equ	002h

clock_snd	equ	07Ch

bounce_snd  	equ	001h

;NOT triple_snd calls!
d_up_snd	equ	3d4h
d_dn_snd	equ	3d5h

d_enter_snd	equ	3d6h
d_escape_snd	equ	3d7h
d_warning_snd	equ	3d8h

d_beep1_snd	equ	3d9h
d_beep2_snd	equ	3dah

d_misc1_snd	equ	3dbh
d_misc2_snd	equ	3dch
d_misc3_snd	equ	3ddh


beep1_snd   	equ	3d9h
beep2_snd   	equ	3dah
cursor_snd4 	equ	3dbh
select_snd1 	equ	3dch


coin_snd    	equ	048h
musicoff_snd	equ	005h
snd_play1ovr	equ	006h

W_BRET		equ	0
W_RAZOR		equ	1
W_TAKER		equ	2
W_YOKO		equ	3
W_SHAWN		equ	4
W_BAMBAM	equ	5
W_DOINK		equ	6
W_ADAM		equ	7
W_LUGER		equ	8
W_REF		equ	9


PUNCH_T1	equ	0
PUNCH_T2	equ	1
PUNCH_L1	equ	2
PUNCH_L2	equ	3
HDBUTT_T1	equ	4
HDBUTT_T2	equ	5
HDBUTT_L1	equ	6
HDBUTT_L2	equ	7
KICK_T1		equ	8
KICK_T2		equ	9
KICK_L1		equ	10
KICK_L2		equ	11
FLYKICK_T1	equ	12
FLYKICK_T2	equ	13
FLYKICK_L1	equ	14
FLYKICK_L2	equ	15
GRABTHROW_T1	equ	16
GRABTHROW_T2	equ	17
GRABTHROW_L1	equ	18
GRABTHROW_L2	equ	19
UPRCUT_T1	equ	20
UPRCUT_T2	equ	21
UPRCUT_L1	equ	22
UPRCUT_L2	equ	23
LBOWDROP_T1	equ	24
LBOWDROP_T2	equ	25
LBOWDROP_L1	equ	26
LBOWDROP_L2	equ	27
GRABHOLD_T1	equ	28
GRABHOLD_T2	equ	29
GRABHOLD_L1	equ	30
GRABHOLD_L2	equ	31
GRABFLING_T1	equ	32
GRABFLING_T2	equ	33
GRABFLING_L1	equ	34
GRABFLING_L2	equ	35
PUSH_T1		equ	36
PUSH_T2		equ	37
PUSH_L1		equ	38
PUSH_L2		equ	39
HIPTOSS_T1	equ	40
HIPTOSS_T2	equ	41
HIPTOSS_L1	equ	42
HIPTOSS_L2	equ	43
;BIGBOOT_T1	equ	44
;BIGBOOT_T2	equ	45
;BIGBOOT_L1	equ	46
;BIGBOOT_L2	equ	47

SPUNCH_T1	equ	48
SPUNCH_T2	equ	49
SPUNCH_L1	equ	50
SPUNCH_L2	equ	51

TURNDIVE_T1	equ	52
TURNDIVE_T2	equ	53

RUGSLAM_YELL	equ	54
RUGSLAM_IMPACT	equ	55

YELL_THROW	equ	56

LAST_MOVE	equ	YELL_THROW

W_LOOKUP	equ	8000h


	.ref	DEFAULT_SOUND_TABLE,MASTER_SOUND_TABLE,table_sound

WRSND	.macro	WRESTLER,SOUND1,SOUND2

	movi	MASTER_SOUND_TABLE+(:WRESTLER:*10h*(LAST_MOVE+1))+(:SOUND1:*16),a0
	move	*a0,a0,W
	jrnn	OKAY?

	;oops.  use the default instead
	movi	DEFAULT_SOUND_TABLE+(:SOUND1:*16),a0
	move	*a0,a0,W

OKAY?
	calla	table_sound

	.if $isname(SOUND2)
	movi	MASTER_SOUND_TABLE+(:WRESTLER:*10h*(LAST_MOVE+1))+(:SOUND2:*16),a0
	move	*a0,a0,W
	jrnn	OKAY2?

	;oops.  use the default instead
	movi	DEFAULT_SOUND_TABLE+(:SOUND2:*16),a0
	move	*a0,a0,W

OKAY2?
	calla	table_sound

	.endif
	.endm

WRSNDXI	.macro	REG,SOUND1
	PUSH	a0,a1

	move	*:REG:(WRESTLERNUM),a1,W
	movi	(LAST_MOVE+1),a14
	mpyu	a14,a1
	X16	a1
	addi	(:SOUND1:*10h),a1
	addi	MASTER_SOUND_TABLE,a1
	move	*a1,a0,W
	jrnn	OKAY?

	;oops.  use the default instead
	movi	DEFAULT_SOUND_TABLE+(:SOUND1:*10h),a1
	move	*a1,a0,W
OKAY?
	calla	table_sound
	PULL	a0,a1
	.endm

WRSNDX	.macro	P1,P2,P3
	.if $isreg(P1)
		WRSNDXI	:P1:,:P2:
		.if $isname(P3)
		WRSNDXI	:P1:,:P3:
		.endif
	.else
		WRSNDXI	a13,:P1:
		.if $isname(P2)
		WRSNDXI	a13,:P2:
		.endif
	.endif
	.endm


