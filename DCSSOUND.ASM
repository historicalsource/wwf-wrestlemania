**************************************************************
*
* Software:		Ed Boon
* Initiated:		?
*
* Modified:		Jason Skiles,	23 Nov 93 - WWF conversion
*			Jake Simpson,	Announcers, new scheduling,
*					and various other features.
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 1/10/94 12:02
**************************************************************

	.file	"dcssound.asm"
	.title	"sound processor"
	.width	132
	.option	b,d,l,t
	.mnolist

	.include	"macros.h"
	.include	"mproc.equ"
	.include	"sys.equ"
	.include	"game.equ"
	.include	"plyr.equ"
	.include	"audit.equ"
	.include	"macros.h"
	.include	"display.equ"
	.INCLUDE	"GSP.EQU"
	.INCLUDE	"SOUND.equ"
	.include	"snddebug.h"

	.text
;************************************************************************
;*									*
;* OK people, there are several ready made speech call routines for	*
;* you to use. I'll go through them, with where you should call them	*
;* from and what they are for.						*
;* vvvvvv All These to be called from scripts VVVVVVVV			*
;* CALL_MISSES - If you attempt to do something and miss,		*
;* 	E.g. head grab....						*
;* CALL_SPECIAL_MOVE - For the 5 dollar moves, the pile drivers etc	*
;* CALL_ANI_AVERAGE_MOVE - For the Average moves that are fairly easy to*
;* 	fire off. E.g. Back hand slap, Shawns spin kick			*
;* DO_REVERSAL - When a move is reversed against the opponent		*
;* CALL_MISS_YOKO -  For use when you try to do a move against YOKO and *
;*		     fail.						*
;* CALL_THROWN_OUT - Been chucked out of the ring			*
;* CALL_OTHER_AVERAGE - Another Average move speech call, to provide	*
;*			variety.					*
;* CALL_NASTY_MOVE - When you do something against the rules, 		*
;* 	E.g. Doink buzzer, Doink Hammer, Shawn arm break		*
;* CALL_SETUP - Set up for a better move, E.g. Head grab, Picking up	*
;*		over							*
;* 									*
;* vvvvvv All these calls come from the REACT subroutines VVVVV		*
;* CALL_FACE_HIT - Any thing that *JUST* hits the face Eg. Head butts	*
;* CALL_MID_HIT - Any thing that *JUST* hits the midsection		*
;* CALL_DROP_KICK - For any move that results in both wrestlers		*
;* 	hitting the ground.						*
;*									*
;************************************************************************

	.DEF	MAYBE_SHOCKING
	.DEF	MAYBE_TOUGH_ENOUGH
	.DEF	MAYBE_HIGH_RISK
	.DEF	MAYBE_BOUNCE_ROPE
	.DEF	CALL_BONE_BREAK
	.DEF	MAYBE_GIDDUP
	.DEF	FIND_AND_KILL_ENDLESS
	.DEF	DO_DOINK_SLAM
	.DEF	DO_NONO,DO_OTHERNONO
	.DEF	DO_RAZOR_RUG_SPEECH
	.def	DO_RAZOR_PUSH
	.DEF	DO_WAIL
	.DEF	DO_CHOKE
	.DEF	DO_SCREAM
	.DEF	DO_BLOCKED
	.DEF	MAKE_HIM_SCREAM

	.DEF	DO_BLOCK_SND
	.DEF	DO_FLAME_HIT_SND
	.DEF	DO_FLAME_SND
	.DEF	CALL_ANI_AVERAGE_MOVE

	.def	SNDSND, SET_LOWER_VOL, FADE_MASTER_VOL
	.DEF	CALL_NASTY_MOVE

	.DEF	CLEAR_SPEECH_REPEAT
	.def	CALL_MISS_YOKO

	.DEF	CALL_OTHER_AVERAGE

	.DEF	ADD_VOICE, RESET_VOICE_QUEUE
	.DEF	IF_SILENT_ADD_VOICE
	BSSX	DONE_HOWARD,16
	.DEF	VINCE_START_GAME
	.def	WALK_SOUND
	.DEF	SMALL_RUN
	.REF	RNDPER
	.DEF	ADD_TO_QUEUE
	.DEF	ADD_IF_SILENT
	.DEF	CLIMB_ROPES
	.DEF	JUMP_ROPES
	.DEF	CALL_DROP_KICK
	.DEF	DO_REVERSAL,CALL_THROWN_OUT
	.DEF	CALL_FACE_HIT,CALL_MID_HIT
	.DEF	CALL_MISSES,CALL_SETUP
	.DEF	CALL_MATCH_OVER,CALL_AVERAGE_MOVE
	.DEF	CALL_SPECIAL_MOVE
	.DEF	HIT_THE_MAT
	.def	SMALL_BOUNCE
	.DEF	VINCE_START_ROUND2_3
	.ref	index1,index2,process_ptrs,PSTATUS

	;for various files
	.def	DEFAULT_SOUND_TABLE,MASTER_SOUND_TABLE

	;from AUDIT.ASM
	.ref	PUT_ADJ,GET_ADJ,F_ADC_S

	;from UTIL.ASM
	.ref	RNDRNG0

	;from WRESTLE.ASM
	.ref	GAMSTATE
	.REF	p1winstreak

	.ref	crowd_cheer
	.REF	get_health

	.ref	_coin_addr
	.ref	_sound_addr
	.ref	_soundirq_addr
	.ref	_coin_counter_addr

send	.set	>0001			; script command --> send sound code
setpri	.set	>0002			; script command --> set priority
endtune	.set	>0003			; script command --> end of tune script
sleep	.set	>0004			; script command --> sleep next byte
send2	.set	>0005


sndpri	.set	0			; priority offset
snddur	.set	10h			; duration offset
sndscp	.set	20h			; script pointer offset

ex	.set	>8000			; flag: extended sound call !!

	.bss	chan1ram,0,1
	BSSX	chan1pri,16,1		; sound channel #1 priority
	BSSX	chan1dur,16,1		; sound channel #1 duration (timer)
	.bss	chan1scp,32,1		; sound channel #1 script pointer
	BSSX	chan1snd,16,1		; sound channel #1 current sound

	BSSX	chan2pri,16,1		; sound channel #2 priority
	BSSX	chan2dur,16,1		; sound channel #2 duration (timer)
	.bss	chan2scp,32,1		; sound channel #2 script pointer
	BSSX	chan2snd,16,1		; sound channel #2 current sound

	BSSX	chan3pri,16,1		; sound channel #3 priority
	BSSX	chan3dur,16,1		; sound channel #3 duration (timer)
	.bss	chan3scp,32,1		; sound channel #3 script pointer
	BSSX	chan3snd,16,1		; sound channel #3 current sound

	BSSX	chan4pri,16,1		; sound channel #4 priority
	BSSX	chan4dur,16,1		; sound channel #4 duration (timer)
	.bss	chan4scp,32,1		; sound channel #4 script pointer
	BSSX	chan4snd,16,1		; sound channel #4 current sound

	.bss	vincechan,16,1		; channel vince is on, if any
	.bss	vincedur,16,1		; vince duration

	.bss	randychan,16,1		; channel randy is on, if any
	.bss	randydur,16,1		; randy duration

	.bss	howardchan,16,1		; channel howard is on, if any
	.bss	howarddur,16,1		; howard duration

	BSSX	SOUNDSUP,16,1		; SOUND ENABLED FLAG
	.BSS	LAST_VOICE,64		;LAST SPEECH CALL MADE
	.BSS	WHICH_LAST_VOICE,32
	BSSX	REPEAT_STATE,16

	bssx	ANNOUNCE_QUEUE,32*20
	.BSS	EOF_ANNOUNCE_QUEUE,0
	BSSX	NEXT_ANN_QUEUE,32
	BSSX	CURRENT_ANN_QUEUE,32

	BSSX	ENDLESS_SOUND,16
	BSSX	doing_dcs_reset,16

	.if SND_DEBUG
	;keep these in order and adjacent
	BSSX	SDRAM,SNDCALSIZ*64
	BSSX	sdram_ptr,32
	.endif

	.bss	crowd_dummy_exists,16
	.bss	repeat_mode_exists,16
	.bss	razor_swear_exists,16

**************************************************************************
*												*
*	Sound type priorities
*												*
**************************************************************************

sp_robo		equ	 1 << 8			; robotron sounds
sp_mat1		equ	 4 << 8			; mat noises
sp_woosh	equ	 8 << 8			; attack whoosh
sp_attkv	equ	12 << 8			; attack grunt
sp_reacv	equ	14 << 8			; react grunt
sp_losmack	equ	15 << 8			; just under smack
sp_smack	equ	16 << 8			; smack
sp_mat2		equ	20 << 8			; mat noises
sp_wspch	equ	24 << 8			; wrestler speech
sp_system1	equ	36 << 8			; system stuff
sp_system2	equ	40 << 8			; system stuff
sp_system3	equ	44 << 8			; system stuff
sp_anncer	equ	100 << 8		; announcer speech


**************************************************************************
*											     *
*    TRIPLE SOUND TABLE format:								     *
* 											     *
*              .word   >aaaa,>bbbb							     *
* 											     *
*       where:  aaaa = priority / duration						     *
*               bbbb = channel 1 sound call					     *
*											     *
**************************************************************************

triple_sndtab
	.word	0,0			;  0 =
	.word	sp_smack|17,>80		;  1 = face hit #0
	.word	sp_smack|14,>84		;  2 = face hit #1
	.word  	sp_system2|90,1480	;  3 = combo earned sound
	.word	sp_mat2|15,>88		;  4 = body hit #0
	.word	sp_smack|17,>8c		;  5 = body hit #1
	.word	sp_smack|15,>90		;  6 = kick #0
	.word	sp_mat2|13,>94		;  7 = kick #1
	.word	sp_mat2|15,>98		;  8 = kick #2

	.word	sp_mat2|13,156		;  9 = fall to mat #0
	.word	sp_mat1|70,460		;  a = clock tick
	.word	sp_mat1|62,412		;  b = mat crash #0
	.word	sp_mat1|53,416		;  c = mat rattle #0
	.word	sp_mat1|39,424		;  d = mat rattle #2

	.word	sp_woosh|21,>a8		;  e = whoosh #0
	.word	sp_woosh|20,>ac		;  f = whoosh #1
	.word	sp_woosh|21,>b0		; 10 = whoosh #2
	.word	sp_woosh|13,>b4		; 11 = whoosh #3
	.word	sp_woosh|12,>b8		; 12 = whoosh #4
	.word	sp_woosh|10,>bc		; 13 = whoosh #5
	.word	sp_woosh|13,>c0		; 14 = whoosh #6
	.word	sp_woosh|15,>c4		; 15 = whoosh #7
	.word	sp_woosh|14,>c8		; 16 = whoosh #8
	.word	sp_woosh|11,>cc		; 17 = whoosh #9

	.word	sp_smack|20,>d0		; 18 = hard hit #0
	.word	sp_smack|11,>d4		; 19 = hard hit #1
	.word	sp_smack|21,>d8		; 1a = hard hit #2
	.word	sp_smack|24,>dc		; 1b = hard hit #3
	.word	sp_smack|20,>e0		; 1c = hard hit #4

	.word	sp_system1|56,>e4		; 1d = New Deep Crunchy bone break (ALLDUCK)
	.word	sp_attkv|40,>e8		; 1e = long effort grunt #1
	.word	sp_attkv|29,>ec		; 1f = long effort grunt #2
	.word	sp_attkv|42,>f0		; 20 = long effort grunt #3
	.word	sp_attkv|36,>f4		; 21 = long effort grunt #4
	.word	sp_attkv|26,>f8		; 22 = long effort grunt #5
	.word	sp_attkv|31,>fc		; 23 = long effort grunt #6
	.word	sp_attkv|34,>100	; 24 = long effort grunt #7
	.word	sp_attkv|33,>104	; 25 = long effort grunt #8
	.word	sp_attkv|30,>108	; 26 = long effort grunt #9
	.word	sp_attkv|29,>10c	; 27 = long effort grunt #10
	.word	sp_attkv|28,>110	; 28 = long effort grunt #11
	.word	sp_attkv|42,>114	; 29 = long effort grunt #12

	.word	sp_attkv|19,>118	; 2a = short effort grunt #0
	.word	sp_attkv|23,>11c	; 2b = short effort grunt #1
	.word	sp_attkv|24,>120	; 2c = short effort grunt #2
	.word	sp_attkv|13,>124	; 2d = short effort grunt #3
	.word	sp_attkv|16,>128	; 2e = short effort grunt #4
	.word	sp_attkv|26,>12c	; 2f = short effort grunt #5
	.word	sp_attkv|20,>130	; 30 = short effort grunt #6
	.word	sp_attkv|22,>134	; 31 = short effort grunt #7
	.word	sp_attkv|23,>138	; 32 = short effort grunt #8
	.word	sp_smack|70,236		; 33 = baseball bat smack
	.word	sp_system2|24,>dc	; 34 = hard hit #3 (with higher priority)
	.word	sp_system3|21,>b0	; 35 = whoosh (screen close)
	.word	0,0	; 36
	.word	sp_mat2|77,>104		; 37 = CEMENT body slam outside the ring
	.word	0,0	; 38
	.word	sp_system2|96,1616		; 39 = robo coinin
	.word	0,0	; 3a
	.word	0,0	; 3b
	.word	sp_woosh|37,1284	; 3c	= rope twang
	.word	sp_mat2|62,408	 	; 3d	= ring mat crash #0
	.word	sp_wspch|92,1448 	; 3e	= doink joy buzzer
	.word	sp_attkv|67,1452	; 3f	= doink water spray
	.word	sp_attkv|21,176 	; 40	= urn materialisation
	.word	sp_attkv|57,1236 	; 41	= Bam Bam rising in flames
	.word	sp_attkv|185,904 	; 42	= Bam Bam taunt
	.word	sp_smack|70,1436	; 43	= doink big glove slap
	.word	sp_smack|84,1440	; 44	= doink big foot hit
	.word	sp_mat2|80,1444		; 45	= doink big hammer hit
	.word	sp_attkv|11,428		; 46	= footsteps on mat #0
	.word	sp_attkv|15,432		; 47	= footsteps on mat #1
	.word	sp_system2|131,1376   ; 48	= COIN IN SOUNDS

	.word	sp_anncer|53,1512    ; 49	= buy in sound
	.word	sp_woosh|19,1556   	; 4a	= flashbulb #0
	.word	sp_woosh|32,1560   	; 4b	= flashbulb #1
	.word	sp_woosh|40,1564   	; 4c	= flashbulb #2
	.word	sp_smack|35,1568   	; 4d	= flash the "W" after a victory
	.word	sp_reacv|99,160	 	; 4e	=BOWLING PINS strike #0
	.word	sp_reacv|93,164	 	; 4f	=BOWLING PINS strike #1

	;DOINK SPEECH
	.word	sp_wspch|53,>20c	; 50 = wait a minute, wait a minute
	.word	sp_wspch|29,>210	; 51 = time out
	.word	0,0			; 52 = 
	.word	sp_wspch|23,>218	; 53 = times
	.word	sp_wspch|39,>21c	; 54 = wait, wait
	.word	sp_wspch|79,>220	; 55 = laugh #0
	.word	sp_wspch|140,>224	; 56 = laugh #1
	.word	sp_wspch|42,>228	; 57 = laugh #2
	.word	sp_wspch|123,>22c	; 58 = laugh #3
	.word	sp_wspch|91,>230	; 59 = yell as tossed

	;RAZOR SPEECH
	.word	sp_wspch|94,>300	; 5a = you picked the right guy
	.word	sp_wspch|69,>304	; 5b = check me out, maing...
	.word	0,0			; 5c
	.word	0,0			; 5d
	.word	0,0			; 5e
	.word	0,0			; 5f

	;SHAWN SPEECH
;	.word	sp_wspch|269,>280	; 60 = lucky you...breaking bones
	.word	sp_wspch|255,>280	; 60 = lucky you...breaking bones
	.word	sp_wspch|130,>284	; 61 = wrestler o' 90's
	.word	sp_wspch|132,>288	; 62 = how could...hurt so bad
	.word	sp_wspch|26,>28c	; 63 = no no
	.word	sp_wspch|21,>290	; 64 = please

	;BAM BAM SPEECH
	.word	0,0	             ; 65 = 
	.word	sp_wspch|147,900   	; 66 = the beast from the east
	.word	sp_wspch|185,904   	; 67 = bam bam - bam bam - yeah!
	.word	sp_wspch|162,908   	; 68 = bam bam bigelow
	.word	sp_wspch|160,912   	; 69 = burn, baby, burn!
	.word	sp_wspch|24,916	     ; 6a = hey! #0
	.word	sp_wspch|23,920	     ; 6b = no no
	.word	0,0	             ; 6c = 
	.word	0,0	             ; 6d = 
	.word	sp_wspch|36,932	     ; 6e = no no no
	.word	sp_wspch|103,936	; 6f = get out of my ring


	.word	0,0			; 70
	.word	sp_reacv|30,>45c	; 71 = DOINK pain #1
	.word	sp_reacv|40,>460	; 72 = DOINK pain #2

	.word	sp_reacv|42,>464	; 73 = DOINK gut hit #0
	.word	sp_reacv|40,>468	; 74 = DOINK gut hit #1
	.word	sp_reacv|18,>46c	; 75 = DOINK gut hit #2

	;low-priority mat crashes
	.word	sp_losmack|75-25,>500	; 76 = Plywood crash #0
	.word	sp_losmack|77-25,>508	; 77 = Plywood crash #2
	.word	sp_losmack|83-25,>510	; 78 = Plywood crash #4

	.word	sp_reacv|24,>47c	; 79 = RAZOR generic grunt #0
	.word	0,0			; 7a
	.word	0,0			; 7b

	.word	sp_reacv|29,>488	; 7c = RAZOR gut hit #0
	.word	sp_system1|64,1528	; 7d	=SCREEN WIPE upward in pitch #1
	.word	sp_system1|64,1536	; 7e	=SCREEN WIPE upward in pitch #3
	.word	sp_system1|70,1544	; 7f	=SCREEN WIPE downward in pitch #1
	.word	sp_system1|73,1552	; 80	=SCREEN WIPE downward in pitch #3
	.word	0,0			; 81

	.word	sp_reacv|62,1196	; 82 = BAM BAM effort #1

	.word	0,0	;* 83 = JASON effort grunt #0
	.word	0,0	;* 84 = JASON effort grunt #1
	.word	sp_attkv|39,>415	; 85 = JASON effort grunt #2
	.word	sp_attkv|31,>418	; 86 = JASON effort grunt #3
	.word	sp_attkv|31,>41b	; 87 = JASON effort grunt #4
	.word	sp_attkv|39,>41e	; 88 = JASON effort grunt #5
	.word	sp_attkv|40,>421	; 89 = JASON effort grunt #6
	.word	sp_attkv|34,>424	; 8a = JASON effort grunt #7
	.word	sp_attkv|27,>427	; 8b = JASON effort grunt #8
	.word	sp_attkv|35,>42a	; 8c = CG effort grunt #0
	.word	sp_attkv|44,>42d	; 8d = CG effort grunt #1
	.word	sp_attkv|35,>430	; 8e = CG effort grunt #2
	.word	sp_attkv|36,>433	; 8f = CG effort grunt #3
	.word	sp_attkv|36,>433	; 90 = CG effort grunt #4
	.word	sp_attkv|25,>436	; 91 = CG effort grunt #5
	.word	sp_attkv|34,>439	; 92 = CG effort grunt #6
	.word	sp_attkv|49,>43c	; 93 = CG effort grunt #7
	.word	sp_attkv|57,>43f	; 94 = CG effort grunt #8
	.word	0,0	;* 95 = SAL pain grunt #0
	.word	0,0	;* 96 = SAL pain grunt #1
	.word	0,0	;* 97 = SAL pain grunt #2
	.word	sp_system1|58,464   ; 98	=BONEBREAK for Lex/BamBam/Piledrivers

	.word	sp_smack|38,1228 	; 99	=BAMBAM flaming punch woosh #0
	.word	sp_smack|36,1232 	; 9a	=BAMBAM flaming punch woosh #1
	.word	sp_system1|32,1492   ; 9b	=BONEBREAK for Lex/BamBam/Piledrivers
	.word	sp_attkv|74,1240	; 9c	=BAMBAM flaming splash
	.word	sp_smack|60,1244 	; 9d	=BAMBAM lands flaming punch #0
	.word	sp_smack|59,1248 	; 9e	=BAMBAM lands flaming punch #1
	.word	sp_smack|61,1252 	; 9f	=BAMBAM lands flaming blow #2
	.word	sp_smack|28,1256 	; a0	=BAMBAM lands flaming blow #3
	.word	sp_smack|24,1260	; a1	=BAMBAM lands flaming blow #4
	.word	sp_attkv|81,1264	; a2	=BAMBAM jumps off the turnbuckle & flames up
	.word	sp_attkv|235,1268	; a3	=BAMBAM's opponent explodes in flames
	.word	0,0			; a4	=
	.word	sp_system2|77-25,>508	; a5 = Plywood crash #2 (duplicate with higher priority)
	.word	0,0			; a6	=
	.word	0,0			; a7	=
	.word	sp_system1|212,232	; a8	= PERFECT VICTORY sparkly
	.word	sp_system1|41,>628	; a9 = RAZOR slash whoosh
	.word	sp_system1|42,>168	; aa = CARTOON richocet bonk
	.word	sp_wspch|72,>4D4	; ab = BAMBAM morph out of mat
	.word	sp_smack|40,>15C	; ac = CARTOON bong #2
	.word	sp_smack|58,>170	; ad = CARTOON crash/bong #0
	.word	sp_reacv|33,1220	; ae = SHAWN pain #1
	.word	sp_reacv|33,1224	; af = SHAWN gut hit #0

	;MISCELLANEOUS SOUNDS
	.word	sp_mat1|29,>315	     ; b0 = some blip sound
	.word   sp_anncer|90,0148h	; b1 = round start bell
	.word   sp_smack|19,>160	; b2 = squeeze horn honk #0
	.word   sp_smack|75,014fh	; b3 = twist - slam
	.word	sp_mat1|46,344	     ; b4 = bong (temp!)
	.word	sp_mat1|15,>1b2		; b5 = footstep on mat #1

	.word	sp_system1|34,>178	; b6 = Quick whistle for transitions

	.word	sp_system1|9,1364	; b7 = timer tick #0 
	.word	sp_system1|11,1368	; b8 = timer tock #0
	.word	sp_system1|84,1484	; b9 = danger sound
	.word	sp_system1|102,1488	; ba	= combo performed
	.word	sp_system1|125,1520	; bb	= reversal_sound 

	.word	sp_system1|118,1472	; bc	=ALARM companion to 1520
	.word	sp_system1|126,1476	; bd	=ALARM snarl alarm #0
	.word	sp_mat1|51,>17c		; be = wobble (danger!)
	.word	sp_mat2|75-25,>500	; bf = Plywood crash #0
	.word	sp_mat1|39,316    	; c0 = fall to mat #0
	.word	sp_mat2|77-25,>508	; c1 = Plywood crash #2
	.word	sp_mat1|26,320    	; c2 = fall to mat #1
	.word	sp_mat2|83-25,>510	; c3 = Plywood crash #4
	.word	sp_mat2|74,1516		; c4	= VICTORY "w" flys up the screen
	.word	sp_mat2|101,>518	; c5 = Chair crash #1
	.word	sp_smack|46,1580  	; c6	= HORIZON RING clatter/crash against fence #0
	.word	sp_system1|9,1456	; c7	= player 1 moves cursor #1
	.word	sp_system1|9,1460	; c8	= player 2 moves cursor #1
	.word	0,0	; c9	= player 1 moves cursor #2
	.word	0,0	; ca	= player 2 moves cursor #2
	.word	sp_system2|63,244	; cb	= player 1 selects #1
	.word	sp_system2|63,248	; cc	= player 2 selects #1
	.word	sp_smack|90,324		; cd	= FX wild metallic clang/chain drag
	.word	sp_system1|142,1180 	; ce	=UNDERTAKER fires a ghost at you (try for both)
	.word	sp_mat2|100,1184 	; cf	=UNDERTAKER bats flutter (endless)
	.word	sp_system1|14,1188  	; d0	=UNDERTAKER tombstone morphs into his hands
	.word	sp_system1|24,1192  	; d1	=UNDERTAKER hits you with his tombstone
	.word	sp_system1|48,1208 	; d2	=UNDERTAKER multi-exposures over & grabs you
	.word	sp_wspch|57,588		; d3	=FROM THE CROWD "pin him!!" #0
	.word	sp_wspch|72,592		; d4	=FROM THE CROWD "pin him!!" #1
	.word	sp_wspch|50,596		; d5	=FROM THE CROWD "pin him!!" #2
	.word	sp_wspch|65,600		; d6	=FROM THE CROWD female scream
	.word	sp_reacv|7,468		; d7	=SHAWN hearts kissy-face #0
	.word	sp_reacv|29,472		; d8	=SHAWN hearts kissy-face #1
	.word	sp_reacv|11,476		; d9	=YOKO hams circle #0
	.word	sp_reacv|19,480		; da	=YOKO hams circle #1
	.word	sp_reacv|18,484		; db	=YOKO fishes circle #0
	.word	sp_reacv|31,488		; dc	=YOKO fishes circle #1
	.word	sp_system1|20,>d0	; dd = random select sound (hard hit)
	.word	0,0			; de
	.word	0,0			; df

	;ANNOUNCER SPEECH - must be contiguous
announcer_start
	;VINCE MCMAHON
	.word	sp_anncer|89,3072	; e0 = VINCE greeting
	.word	sp_anncer|18,3076	; e1 = VINCE ascending Doink #1
	.word	sp_anncer|19,3080	; e2 = VINCE ascending Doink #2
	.word	sp_anncer|21,3084	; e3 = VINCE ascending Doink #3
	.word	sp_anncer|24,3088	; e4 = VINCE ascending Doink #4

	.word	sp_anncer|26,3092	; e5 = VINCE ascending Shawn #1
	.word	sp_anncer|26,3096	; e6 = VINCE ascending Shawn #2
	.word	sp_anncer|28,3100	; e7 = VINCE ascending Shawn #3
	.word	sp_anncer|31,3104	; e8 = VINCE ascending Shawn #4

	.word	sp_anncer|26,3108	; e9 = VINCE ascending Razor #1
	.word	sp_anncer|27,3112	; ea = VINCE ascending Razor #2
	.word	sp_anncer|30,3116	; eb = VINCE ascending Razor #3
	.word	sp_anncer|31,3120	; ec = VINCE ascending Razor #4

	.word	sp_anncer|105,3124	; ed = VINCE Unbeeleeevable! #0
	.word	sp_anncer|66,3128	; ee = VINCE Forget about it!
	.word	sp_anncer|48,3132	; ef = VINCE Here's the setup...
	.word	sp_anncer|86,3136	; f0 = VINCE aaaaannnnd OH!
	.word	sp_anncer|49,3140	; f1 = VINCE Oh, my!
	.word	sp_anncer|61,3144	; f2 = VINCE Congratulations

	.word	sp_anncer|34,3148	; f3 = VINCE ascending Undertaker #1
	.word	sp_anncer|37,3152	; f4 = VINCE ascending Undertaker #2
	.word	sp_anncer|36,3156	; f5 = VINCE ascending Undertaker #3
	.word	sp_anncer|44,3160	; f6 = VINCE ascending Undertaker #4

	.word	sp_anncer|32,3164	; f7 = VINCE ascending Bam Bam #1
	.word	sp_anncer|30,3168	; f8 = VINCE ascending Bam Bam #2
	.word	sp_anncer|32,3172	; f9 = VINCE ascending Bam Bam #3
	.word	sp_anncer|34,3176	; fa = VINCE ascending Bam Bam #4

	.word	sp_anncer|22,3180	; fb = VINCE ascending Luger #1
	.word	sp_anncer|21,3184	; fc = VINCE ascending Luger #2
	.word	sp_anncer|21,3188	; fd = VINCE ascending Luger #3
	.word	sp_anncer|26,3192	; fe = VINCE ascending Luger #4

	.word	sp_anncer|26,3196	; ff = VINCE ascending Hitman #1
	.word	sp_anncer|26,3200	;100 = VINCE ascending Hitman #2
	.word	sp_anncer|27,3204	;101 = VINCE ascending Hitman #3
	.word	sp_anncer|25,3208	;102 = VINCE ascending Hitman #4

	.word	sp_anncer|27,3212	;103 = VINCE ascending Yoko #1
	.word	sp_anncer|26,3216	;104 = VINCE ascending Yoko #2
	.word	sp_anncer|30,3220	;105 = VINCE ascending Yoko #3
	.word	sp_anncer|32,3224	;106 = VINCE ascending Yoko #4

	.word	sp_anncer|63,3228	;107 = VINCE Here we go!
	.word	sp_anncer|93,3232	;108 = VINCE What a matchup this is!

					;      VINCE Very impressive move by
	.word	sp_anncer|92,3236	;109 = ...Doink!
	.word	sp_anncer|113,3240	;10a = ...Shawn Michaels!
	.word	sp_anncer|108,3244	;10b = ...Razor Ramon!
	.word	sp_anncer|113,3248	;10c = ...the Undertaker!
	.word	sp_anncer|125,3252	;10d = ...Bam Bam Bigelow!
	.word	sp_anncer|107,3256	;10e = ...Lex Luger!
	.word	sp_anncer|110,3260	;10f = ...Bret Hart!
	.word	sp_anncer|121,3264	;110 = ...Yokozuna!
;LEAVE PLENTY OF SPACE FOR FUTURE SOUNDS
					;Tonites match up....
	.word	sp_anncer|100,3412   ;111	= ...Doink!
	.word	sp_anncer|100,3416   ;112	= ...Shawn Michaels!
	.word	sp_anncer|99,3420    ;113	= ...Razor Ramon!
	.word	sp_anncer|127,3424   ;114	= ...Bam Bam Bigelow!
	.word	sp_anncer|105,3428   ;115	= ...the Undertaker!
	.word	sp_anncer|98,3432    ;116	= ...Lex Luger!
	.word	sp_anncer|121,3436   ;117	= ...Bret Hart!
	.word	sp_anncer|116,3440   ;118	= ...Yokozuna!
					;In the square circle tonite..
	.word	sp_anncer|126,3444   ;119	=...Doink! 
	.word	sp_anncer|126,3448   ;11a	=...Shawn Michaels! 
	.word	sp_anncer|125,3452   ;11b	=...Razor Ramon! 
	.word	sp_anncer|153,3456   ;11c	=...Bam Bam Bigelow!
	.word	sp_anncer|131,3460   ;11d	=...the Undertaker!
	.word	sp_anncer|124,3464   ;11e	=...Lex Luger! 
	.word	sp_anncer|147,3468   ;11f	=...Bret Hart! 
	.word	sp_anncer|142,3472   ;120	=...Yokozuna! 
	.word	sp_anncer|82,3476    ;121	=versus Doink! 
	.word	sp_anncer|83,3480    ;122	=versus Shawn Michaels! 
	.word	sp_anncer|72,3484    ;123	=versus Razor Ramon! 
	.word	sp_anncer|104,3488   ;124	=versus Bam Bam Bigelow!
	.word	sp_anncer|83,3492    ;125	=versus the Undertaker!
	.word	sp_anncer|75,3496    ;126	=versus Lex Luger! 
	.word	sp_anncer|98,3500    ;127	=versus Bret Hart! 
	.word	sp_anncer|87,3504    ;128	=versus Yokozuna! 
	.word	sp_anncer|135,3360   ;129	=this is a complete disaster 
	.word	sp_anncer|86,3356    ;12a	=this is a debacle 
	.word	sp_anncer|54,3640    ;12b	=doink the clown 
	.word	sp_anncer|55,3644    ;12c	=shawn michaels 
	.word	sp_anncer|44,3648    ;12d	=razor ramon 
	.word	sp_anncer|76,3652    ;12e	=bam bam 
	.word	sp_anncer|54,3656    ;12f	=undertaker 
	.word	sp_anncer|47,3660    ;130	=lex luger 
	.word	sp_anncer|70,3664    ;131	=bret hart
	.word	sp_anncer|59,3668    ;132	=yoko
	.word	sp_anncer|28,3672    ;133	=and
	.word	sp_anncer|62,3228    ;134 =here we go
	.word	sp_anncer|93,3232    ;135	=what a matchup this is
	.word	sp_anncer|104,3628   ;136	=a capacity crowd here
	.word	sp_anncer|75,3528    ;137	=at wrestlemania
	.word	sp_anncer|73,3508    ;138	=who will be the victor ?
	.word	sp_anncer|73,3512    ;139	=its anybody's guess
	.word	sp_anncer|150,3516   ;13a	=anything can happen here in wwf
	.word	sp_anncer|48,3532    ;13b	=theres the bell
	.word	sp_anncer|73,3564	;13c	=he's going to the top rope
	.word	sp_anncer|75,3300 	;13d	=he's going to the top
	.word	sp_anncer|52,3328	;13e	=here it comes
	.word	sp_anncer|57,3368	;13f	=boomshakalaka
	.word	sp_anncer|83,3380	;140	=and....	#1
	.word	sp_anncer|57,3384	;141	=and....	#2
	.word	sp_anncer|90,3388	;142	=and....	#3
	.word	sp_anncer|63,3556	;143	=look at this
	.word	sp_anncer|69,3568	;144	=off the top rope
	.word	sp_anncer|108,3396	;145	=ooh (for kaboom)
	.word	sp_anncer|74,3400	;146	=kaboom
	.word	sp_anncer|109,3392	;147	=long oooh
	.word	sp_anncer|59,3316	;148	=with authority
	.word	sp_anncer|97,3320	;149	=oh my goodness #0
	.word	sp_anncer|34,3324	;14a	=look out
	.word	sp_anncer|56,3332	;14b	=did you see that
	.word	sp_anncer|39,3336 	;14c	=and..... #0
	.word	sp_anncer|31,3340	;14d	=oh ! #0
	.word	sp_anncer|68,3352	;14e	=oooh! #0
	.word	sp_anncer|53,3364  	;14f	=thats gotta hurt
	.word	sp_anncer|84,3372	;150	=wow! #0
	.word	sp_anncer|61,3376	;151	=wow! #1
	.word	sp_anncer|65,3404	;152	=almost
	.word	sp_anncer|50,3536	;153	=nicely done
	.word	sp_anncer|93,3540	;154	=heaves him clear out of the ring
	.word	sp_anncer|48,3544	;155	=nice escape
	.word	sp_anncer|64,3548	;156	=nice execution
	.word	sp_anncer|128,3312	;157	=can he get up in time
	.word	sp_anncer|85,3308	;158 =trying to get back to his feet	
	.word	sp_anncer|31,3580	;159	=a miss
	.word	sp_anncer|62,3584	;15a	=and misses
	.word	sp_anncer|56,3588	;15b	=into the ropes
	.word	sp_anncer|43,3592	;15c	=a quick reversal
	.word	0,0	;15d
	.word	sp_anncer|51,3600	;15e	=this could be it
	.word	sp_anncer|53,3604	;15f	=no, wait a minute
	.word	sp_anncer|63,3608	;160	=Unbeeleeevable! #1
	.word	sp_anncer|92,3612	;161	=Unbeeleeevable! #2
	.word	sp_anncer|54,3616	;162	=oh my goodness #1
	.word	0,0	;163
	.word	sp_anncer|95,3624	;164	=listen to the crowd
	.word	sp_anncer|71,3632	;165	=did you hear that
	.word	sp_anncer|106,3636	;166	=ive never seen anything like that
	.word	sp_anncer|86,3268	;167	=give credit to doink
	.word	sp_anncer|110,3272	;168	=give credit to shawn
	.word	sp_anncer|108,3276	;169	=give credit to razor
	.word	sp_anncer|119,3280	;16a	=give credit to bam
	.word	sp_anncer|112,3284	;16b	=give credit to undertaker
	.word	sp_anncer|104,3288	;16c	=give credit to lex luger
	.word	sp_anncer|105,3292	;16d	=give credit to bret hart
	.word	sp_anncer|118,3296	;16e	=give credit to yoko
	.word	sp_anncer|90,3680	;16f	=not a good idea
	.word	sp_anncer|70,3684	;170	=what was he thinking
	.word	sp_anncer|94,3688	;171	=you cant get any closer than that
	.word	sp_anncer|120,3692	;172	=now its doink coming back
	.word	sp_anncer|120,3696	;173	=now its shawn michaels coming back
	.word	sp_anncer|119,3700	;174	=now its razor ramone coming back
	.word	sp_anncer|126,3704	;175	=now its the undertaker coming back
	.word	sp_anncer|147,3708	;176	=now its bam bam bigelow	coming back
	.word	sp_anncer|118,3712	;177	=now its lex luger coming back
	.word	sp_anncer|142,3716	;178	=now its bret hart coming back
	.word	sp_anncer|136,3720	;179	=now its yokozuna coming back
	.word	sp_anncer|112,3724	;17a =whats keeping these guys up
	.word	sp_anncer|109,3728	;17b	=it looks like its all over
	.word	0,0	;17c 
	.word	sp_anncer|130,3736	;17d	=its pandemonium in the ring
	.word	sp_anncer|39,3740	;17e =whats this
	.word	sp_anncer|100,3744	;17f	=what a turn of events this is
	.word	sp_anncer|95,3748    ;180	=magnificent!
	.word	sp_anncer|80,3752    ;181	=can you believe that!
	.word	sp_anncer|88,3756    ;182	=rejected!!
	.word	sp_anncer|62,3760    ;183	=what a beating!
	.word	sp_anncer|40,3764    ;184	=to the face!
	.word	sp_anncer|54,3768    ;185	=to the midsection!
	.word	0,0    ;186	=and another!
	.word	sp_anncer|112,3776   ;187	=I wouldn't want to be on the receiving end of that!
	.word	sp_anncer|54,3780    ;188	=what power!
	.word	0,0    ;189   
	.word	sp_anncer|67,3788    ;18a	=what skill!
	.word	sp_anncer|67,3792	;18b	=what a blow!
	.word	sp_anncer|52,3796	;18c	=awesome...
	.word	sp_anncer|89,3800	;18d	=just awesome!
	.word	sp_anncer|82,3804	;18e	=good night!
	.word	sp_anncer|28,3808	;18f	=hello!
	.word	sp_anncer|130,3992	;190	=this is for all the marbles
	.word	sp_anncer|174,3996	;191	=are you tough enough to step into the squared circle
	.word	sp_anncer|128,4000	;*192	=what an unbelievable comeback
	.word	0,0	;193	=
	.word	0,0	;194	=
	.word	0,0	;195	=
	.word	0,0	;196	=
	.word	0,0	;197	=
	.word	sp_anncer|74,3844	;198	=can anybody stop him!?
	.word	0,0	;199  
	.word	sp_anncer|28,3852	;19a	=What the --
	.word	sp_anncer|34,3856	;19b	=Wait a minute --
	.word	sp_anncer|49,3860	;19c	=He can't do that
	.word	sp_anncer|42,3864	;19d	=Is that legal?
	.word	sp_anncer|66,3868	;19e	=Now that was cheap!
	.word	sp_anncer|62,3872	;19f	=That's not very fair!
	.word	sp_anncer|70,3876	;1A0	=Somebody call security!
	.word	sp_anncer|66,3880	;1A1	=That wasn't very nice!
	.word	sp_anncer|64,3884	;1A2	=I can't watch this!
	.word	sp_anncer|87,3888	;1A3	=Most impressive!
	.word	sp_anncer|130,3892	;1A4	=incredible combination move!
	.word	sp_anncer|25,3896	;1A5	=No!!
	.word	sp_anncer|28,3900	;1A6	=Yess!!
	.word	sp_anncer|74,3904	;1A7	=High-Risk Manuever --
	.word	sp_anncer|75,3908	;1A8	=What a slam!
	.word	sp_anncer|0,0	;1A9	=it's a donnybrook
	.word	sp_anncer|124,3916	;1Aa	=he's just gone berserk
	.word	0,0	;1Ab	=the joybuzzer
	.word	sp_anncer|64,3924	;1Ac	=shocking
	.word	sp_anncer|110,3928	;1Ad	=can you believe what you've just seen?
	.word	sp_anncer|44,3932	;1Ae	=he's got him
	.word	0,0	;1Af	
	.word	0,0	;1B0	
	.word	0,0	;1B1	
	.word	0,0	;1B2	
	.word	0,0	;1B3	
	.word	0,0	;1B4	
	.word	0,0	;1B5	
	.word	0,0	;1B6	
	.word	0,0	;1B7	
	.word	0,0	;1B8	
	.word	0,0	;1B9	
	.word	sp_anncer|136,3980	;1Ba	=Somehow I don't think this grudge will end here
	.word	sp_anncer|80,3984	;1Bb	=Sign here please
	.word	sp_anncer|67,3988	;1Bc	=good night!
	.word	0,0	;1Bd	
	.word	0,0	;1Be	
	.word	0,0	;1Bf	
	.word	0,0	;1C0	
	.word	0,0	;1C1
	.word	0,0	;1C2
	.word	0,0	;1C3
	.word	0,0	;1C4
	.word	0,0	;1C5
	.word	0,0	;1C6
	.word	0,0	;1C7
	.word	0,0	;1C8
	.word	0,0	;1C9
	.word	0,0	;1Ca
	.word	0,0	;1Cb
	.word	0,0	;1Cc
	.word	0,0	;1Cd
	.word	0,0	;1Ce
	.word	0,0	;1Cf
vince_end	;end of vince speech section
	;RANDY SAVAGE
	.word	sp_anncer|57,6400  	;1D0 =Dawuz beautiful
	.word	sp_anncer|93,6364	;1D1	=taste of his own medicine
	.word	sp_anncer|47,6368	;1D2	=look at this
	.word	sp_anncer|57,6464	;1D3	=right to the kisser
	.word	sp_anncer|62,6468	;1D4	=Wudda moron
	.word	sp_anncer|52,6448	;1D5	=Thawuz close
	.word	sp_anncer|58,6436	;1D6	=did you see that 
	.word	sp_anncer|100,6444	;1D7	=ive never seen anything like that
	.word	sp_anncer|50,6388	;1D8	=oh yeah
	.word	sp_anncer|54,6380	;1D9	=this could be it
	.word	sp_anncer|57,6384	;1Da	=no, wait a minute
	.word	sp_anncer|83,6164	;1Db	=what a move by Shawn Michaels
	.word	sp_anncer|65,6156	;1Dc	=what a move by Doink
	.word	sp_anncer|86,6168	;1Dd	=what a move by Razor Ramone
	.word	sp_anncer|78,6172	;1De	=what a move by the Undertaker
	.word	sp_anncer|88,6176	;1Df	=what a move by Bam Bam
	.word	sp_anncer|72,6180	;1E0	=what a move by Lex
	.word	sp_anncer|76,6192	;1E1	=what a move by the Hitman
	.word	sp_anncer|82,6196	;1E2	=what a move by Yokozuna
	.word	sp_anncer|75,6476	;1E3	=That'll cost him
	.word	sp_anncer|80,6392	;1E4	=Ha what an idiot
	.word	sp_anncer|66,6480	;1E5	=Oooh that hurts
	.word	sp_anncer|52,6484	;1E6	=Game over
	.word	sp_anncer|51,6500	;1E7	=What power
	.word	sp_anncer|54,6504	;1E8	=What speed
	.word	sp_anncer|59,6396	;1E9	=Dawuz great
	.word	sp_anncer|47,6508	;1Ea	=awesome
	.word	sp_anncer|39,6404	;1Eb	=Alright
	.word	sp_anncer|62,6408	;1Ec	=Wuzat cheater up to?
	.word	sp_anncer|76,6536	;1Ed	=What's going on?
	.word	sp_anncer|59,6532	;1Ee	=He can't do that
	.word	sp_anncer|51,6540	;1Ef	=That was cheap
	.word	sp_anncer|75,6564	;1F0	=Somebody call security
	.word	sp_anncer|61,6572	;1F1	=That wasn't very nice
	.word	sp_anncer|93,6580	;1F2	=I can't watch
	.word	sp_anncer|47,6588	;1F3	=Incredible
	.word	sp_anncer|114,6584 	;1F4	=I could watch this all day long
	.word	sp_anncer|60,6600	;1F5	=I think he broke it
	.word	sp_anncer|84,6604	;1F6	=Nobody gets up from that
	.word	sp_anncer|70,6696	;1F7	=Lights out
	.word	sp_anncer|64,6556	;1F8	=Aw c'mon #1
	.word	sp_anncer|115,6144   ;*1F9 =Here we are at Midway's Wrestlemania
	.word	sp_anncer|106,6148   ;*1Fa =And me Jerry the King Lawler
randy_end	;end of randy speech section
	;HOWARD FINKEL
	.word	sp_anncer|117,2560 	;1Fb	=good evening ladies and gents
	.word	sp_anncer|130,2564 	;1Fc	=my name is howard finkel
	.word	sp_anncer|226,2568 	;1Fd	=and welcome to wrestlmainia by midway
	.word	sp_anncer|192,2576 	;1Fe	=we have a winner
	.word	sp_anncer|188,2572 	;1Ff	=this match is scheduled for 2 falls

howards_end	;extremely dull british film - YOU SAID IT !
	.word	sp_reacv|20,4500	; 200 =DOINK takes a punch to the face
	.word	sp_reacv|26,4504	; 201 =DOINK takes a head-butt
	.word	sp_reacv|27,4508	; 202 =DOINK takes a special weapon to the face/head
	.word	sp_reacv|21,4512	; 203 =DOINK takes a hit to the gut
	.word	sp_reacv|21,4516	; 204 =DOINK takes a kick/knee to the gut
	.word	sp_reacv|33,4520	; 205 =DOINK takes a gut hit (alternate)
	.word	sp_attkv|21,4524	; 206 =DOINK short effort grunt before kick/punch #0
	.word	sp_attkv|44,4536	; 207 =DOINK medium effort grunt before lifting/reaching for something
	.word	sp_attkv|61,4540	; 208 =DOINK long effort grunt before throwing something
	.word	sp_attkv|70,4544	; 209 =DOINK long effort grunt before jumping from top rope maybe
	.word	sp_reacv|39,4548	; 20a =DOINK short scream of pain #0
	.word	sp_reacv|50,4552	; 20b =DOINK short scream of pain #1
	.word	sp_reacv|46,4556	; 20c =DOINK medium scream of pain #0
	.word	sp_wspch|63,4560	; 20d =DOINK medium scream of pain #1
	.word	sp_reacv|104,4564	; 20e =DOINK long scream of pain #0
	.word	sp_attkv|71,4568	; 20f =DOINK JOYBUZZER: put'er there pal
	.word	sp_attkv|54,4572	; 210 =DOINK JOYBUZZER: pleased to meet you
	.word	sp_attkv|66,4576	; 211 =DOINK JOYBUZZER BLOCKED allllrighty then!
	.word	sp_attkv|70,4580	; 212 =DOINK REVERSAL I don't think so!
	.word	sp_attkv|48,4584	; 213 =DOINK REVERSAL O no you don't
	.word	sp_attkv|77,4588	; 214 =DOINK 1st Fall victory (?)
	.word	sp_wspch|17,4592	; 215 =DOINK Jarvis laugh for repeat punch #0
	.word	sp_wspch|18,4596	; 216 =DOINK Jarvis laugh for repeat punch #1
	.word	sp_wspch|21,4600	; 217 =DOINK Jarvis laugh for repeat punch #2
	.word	sp_wspch|40,4604	; 218 =DOINK Jarvis laugh for repeat punch #3
	.word	sp_wspch|200,4608	; 219 =DOINK nonono loop - endless 
	.word	sp_attkv|160,4612	; 21a =DOINK choking loop (endless)

	.WORD	sp_attkv|21,4616	;21b =DOINK short effort grunt #3
	.WORD	sp_attkv|18,4620	;21c =DOINK short effort grunt #4
	.WORD	sp_attkv|48,4624	;21d =DOINK double effort grunt #0
	.WORD	sp_attkv|47,4628	;21e =DOINK double effort grunt #1
	.WORD	sp_attkv|52,4632	;21f =DOINK double effort grunt #2
	.WORD	sp_attkv|55,4636	;220 =DOINK reaches out/down & grabs you #0
	.WORD	sp_attkv|40,4640	;221 =DOINK reaches out/down & grabs you #1
	.WORD	sp_attkv|76,4644	;222 =DOINK lifts you up #0
	.WORD	sp_attkv|74,4648	;223 =DOINK lifts you up #1
	.WORD	sp_attkv|26,4652	;224 =DOINK shakes you like a rug #0
	.WORD	sp_attkv|25,4656	;225 =DOINK shakes you like a rug #1
	.WORD	sp_attkv|27,4660	;226 =DOINK shakes you like a rug #2
	.WORD	sp_attkv|17,4664	;227 =DOINK pushes you #0
	.WORD	sp_attkv|13,4668	;228 =DOINK pushes you #1
	.WORD	sp_attkv|67,4672	;229 =DOINK jumps from the turnbuckle #0
	.WORD	sp_attkv|68,4676	;22a =DOINK jumps from the turnbuckle #1
	.WORD	sp_attkv|29,4680	;22b =DOINK takes a head butt #0
	.WORD	sp_attkv|29,4684	;22c =DOINK takes a hit to the gut #3
	.WORD	sp_attkv|33,4688	;22d =DOINK takes a hit to the gut #4
	.WORD	sp_attkv|55,4692	;22e =DOINK gets lifted up #0
	.WORD	sp_attkv|59,4696	;22f =DOINK gets lifted up #1
	.WORD	sp_attkv|44,4700	;230 =DOINK gets pushed #0
	.WORD	sp_attkv|42,4704	;231 =DOINK gets pushed #1
	.WORD	sp_attkv|36,4708	;232 =DOINK gets tossed #0
	.WORD	sp_attkv|52,4712	;233 =DOINK gets tossed #1
	.WORD	sp_attkv|19,4528	;234 =DOINK short effort grunt before kick/punch #1
	.WORD	sp_attkv|16,4532	;235 =DOINK short effort grunt before kick/punch #2

	.WORD	sp_attkv|62,4800	;236 =SAL as BRET REVERSAL o no you 
	.WORD	sp_attkv|62,4804	;237 =SAL as BRET REVERSAL right bac
	.WORD	sp_attkv|42,4808	;238 =SAL as BRET excellent!
	.WORD	sp_attkv|20,4812	;239 =SAL as BRET GRABS AN OPPONENT 
	.WORD	sp_attkv|39,4816	;23a =SAL as BRET GRABS AN OPPONENT 
	.WORD	sp_attkv|31,4820	;23b =SAL as BRET TAUNTS AN OPPONENT
	.WORD	sp_attkv|200,4824	;23c =SAL as BRET nonono loop - endl
	.WORD	sp_attkv|23,4828	;23d =SAL short effort grunt #0
	.WORD	sp_attkv|35,4832	;23e =SAL short effort grunt #1
	.WORD	sp_attkv|31,4836	;23f =SAL short effort grunt #2
	.WORD	sp_attkv|28,4840	;240 =SAL short effort grunt #3
	.WORD	sp_attkv|24,4844	;241 =SAL short effort grunt #4
	.WORD	sp_attkv|22,4848	;242 =SAL short effort grunt #5
	.WORD	sp_attkv|37,4852	;243 =SAL medium effort grunt #0
	.WORD	sp_attkv|36,4856	;244 =SAL medium effort grunt #1
	.WORD	sp_attkv|62,4860	;245 =SAL long effort grunt #0
	.WORD	sp_attkv|64,4864	;246 =SAL long effort grunt #1
	.WORD	sp_attkv|50,4868	;247 =SAL double effort grunt #0
	.WORD	sp_attkv|47,4872	;248 =SAL double effort grunt #1
	.WORD	sp_attkv|45,4876	;249 =SAL double effort grunt #2
	.WORD	sp_attkv|21,4880	;24a =SAL throws a head butt #0
	.WORD	sp_attkv|33,4884	;24b =SAL reaches & grabs #0
	.WORD	sp_attkv|30,4888	;24c =SAL reaches & grabs #1
	.WORD	sp_attkv|25,4892	;24d =SAL throws a kick #0
	.WORD	sp_attkv|44,4896	;24e =SAL leaps from the turnbuckle 
	.WORD	sp_attkv|28,4900	;24f =SAL pushes #0
	.WORD	sp_reacv|27,4904	;250 =SAL takes a face hit #0
	.WORD	sp_reacv|20,4908	;251 =SAL takes a face hit #1
	.WORD	sp_reacv|30,4912	;252 =SAL takes a face hit #2
	.WORD	sp_reacv|28,4916	;253 =SAL takes a face hit #3
	.WORD	sp_reacv|28,4920	;254 =SAL takes a gut hit #0
	.WORD	sp_reacv|36,4924	;255 =SAL takes a gut hit #1
	.WORD	sp_reacv|34,4928	;256 =SAL takes a gut hit #2
	.WORD	sp_reacv|21,4932	;257 =SAL takes a gut hit #3
	.WORD	sp_attkv|29,4936	;258 =SAL gets grabbed #0
	.WORD	sp_attkv|41,4940	;259 =SAL gets grabbed #1
	.WORD	sp_attkv|46,4944	;25a =SAL gets lifted #0
	.WORD	sp_attkv|43,4948	;25b =SAL gets lifted #1
	.WORD	sp_attkv|31,4952	;25c =SAL gets head-butted
	.WORD	sp_attkv|30,4956	;25d =SAL gets pushed #0
	.WORD	sp_attkv|34,4960	;25e =SAL gets pushed #1
	.WORD	sp_wspch|46,4964	;25f =SAL gets tossed #0
	.WORD	sp_attkv|111,4968   	;260 =SAL gets tossed #1
	.WORD	sp_attkv|50,4972	;261 =SAL gets turnbuckle-dived #0
	.WORD	sp_attkv|44,4976	;262 =SAL short pain yell #0
	.WORD	sp_attkv|42,4980	;263 =SAL short pain yell #1
	.WORD	sp_attkv|70,4984	;264 =SAL medium pain yell #0
	.WORD	sp_attkv|55,4988	;265 =SAL medium pain yell #1
	.WORD	sp_attkv|56,4992	;266 =SAL medium pain yell #2

	.WORD	sp_reacv|28,5000	;267 =BOON face hit #0
	.WORD	sp_reacv|28,5004	;268 =BOON face hit #1
	.WORD	sp_reacv|27,5008	;269 =BOON head butted #0
	.WORD	sp_reacv|24,5012	;26A =BOON gut hit #0
	.WORD	sp_reacv|21,5016	;26b =BOON gut hit #1
	.WORD	sp_reacv|27,5020	;26c =BOON gut hit #2
	.WORD	sp_attkv|46,5024	;26d =BOON grabbed
	.WORD	sp_attkv|55,5028	;26e =BOON lifted
	.WORD	sp_reacv|45,5032	;26f =BOON short pain scream #0
	.WORD	sp_wspch|72,5036	;270 =BOON tossed #0
	.WORD	sp_reacv|44,5040	;271 =BOON medium pain scream
	.WORD	sp_attkv|14,5044	;272 =BOON short effort grunt #0
	.WORD	sp_attkv|17,5048	;273 =BOON short effort grunt #1
	.WORD	sp_attkv|13,5052	;274 =BOON head butts an opponent
	.WORD	sp_attkv|35,5056	;275 =BOON double effort grunt #0
	.WORD	sp_attkv|34,5060	;276 =BOON double effort grunt #1
	.WORD	sp_attkv|33,5064	;277 =BOON double effort grunt #2
	.WORD	sp_attkv|56,5068	;278 =BOON dives from the turnbuckle
	.WORD	sp_attkv|57,5072	;279 =BOON lifts someone
	.WORD	sp_system1|29,5076	;27A =BOON as RAZOR special repeat body slam #0
	.WORD	sp_system1|27,5080	;27B =BOON as RAZOR special repeat body slam #1
	.WORD	sp_system1|14,5084	;27C =BOON as RAZOR special repeat body slam #2
	.WORD	sp_system1|39,5088	;27D =BOON as RAZOR special repeat body slam #3
	.WORD	sp_attkv|64,5092	;27E =BOON as RAZOR special being pushed
	.WORD	sp_attkv|86,5096	;27F =BOON as RAZOR special being grabbed
	.WORD	sp_attkv|120,5100	;280 =BOON as RAZOR special being grabbed #2
	.WORD	sp_attkv|200,5104	;281 =BOON as RAZOR nonono loop
					   
	.WORD	sp_attkv|91,564	     ;282 =VP as DOINK pushed
	.WORD	sp_attkv|112,568	;283 =BOOTY as SHAWN pushed
	.WORD	sp_attkv|40,572	     ;284 =BOOTY as SHAWN blocks
	.WORD	sp_attkv|63,576	     ;285 =SAL as BRET pushed
	.WORD	sp_attkv|97,580	     ;286 =GRANNER as LEX pushed
	.WORD	sp_attkv|55,584	     ;287 =GRANNER as LEX blocks
	.word	0,0	;288 
	.word	0,0	;289 
	.word	0,0	;28a 
	.word	0,0	;28b 
	.word	0,0	;28c
	.word	0,0	;28d
	.word	0,0	;28e
	.word	0,0	;28f

	.word	sp_robo|71,1600		;290 = ROBOTRON shot
	.word	sp_robo|212,1604	;291 = ROBOTRON human dies
	.word	sp_robo|58,1608		;292 = ROBOTRON spawn enforcer
	.word	sp_robo|6,1612		;293 = ROBOTRON robot footstep
	.word	sp_robo|96,1616		;294 = ROBOTRON effect (?)
	.word	sp_robo|164,1620	;295 = ROBOTRON player dies
	.word	sp_robo|39,1624		;296 = ROBOTRON rescue
	.word	sp_robo|23,1628		;297 = ROBOTRON grunt dies
	.word	sp_robo|178,1632	;298 = ROBOTRON wave start/end
	.word	sp_robo|17,1636		;299 = ROBOTRON hit hulk

	.word	0,0	;29a
	.word	0,0	;29b
	.word	0,0	;29c
	.word	0,0	;29d
	.word	0,0	;29e
	.word	0,0	;29f
	.word	0,0	;2a0
	.word	0,0	;2a1
	.word	0,0	;2a2
	.word	0,0	;2a3
	.word	0,0	;2a4
	.word	0,0	;2a5
	.word	0,0	;2a6
	.word	0,0	;2a7
	.word	0,0	;2a8
	.word	0,0	;2a9
	.word	0,0	;2aa
	.word	0,0	;2ab
	.word	0,0	;2ac
	.word	0,0	;2ad
	.word	0,0	;2ae
	.word	0,0	;2af
more_jerry
	.word	0,0	;2b0  
	.word	sp_anncer|0,0	;2b1	= 
	.word	sp_anncer|0,0	;2b2	= 
	.word	sp_anncer|0,0	;2b3	= 
	.word	sp_anncer|86,6200	;2b4	= It duddin look good fer Doink
	.word	sp_anncer|0,0	;2b5	= 
	.word	sp_anncer|101,6208	;2b6	= It duddin look good fer Shawn Michaels
	.word	sp_anncer|105,6212	;2b7	= It duddin look good fer Razor Ramone
	.word	sp_anncer|107,6216	;2b8	= It duddin look good fer the Undertaker
	.word	sp_anncer|119,6220	;2b9	= It duddin look good fer BamBam Bigelow
	.word	sp_anncer|102,6224	;2ba	= It duddin look good fer Hox Lugie
	.word	sp_anncer|98,6236	;2bb	= It duddin look good fer the hit man
	.word	sp_anncer|0,0	;2bc	= 
	.word	sp_anncer|0,0	;2bd	= 
	.word	sp_anncer|106,6240	;2be	= It duddin look good fer Yucko Zima
	.word	sp_anncer|0,0	;2bf	= 
	.word	sp_anncer|0,0	;2c0	= 
	.word	sp_anncer|0,0	;2c1	= 
	.word	sp_anncer|0,0	;2c2	= 
	.word	sp_anncer|0,0	;2c3	= 
	.word	sp_anncer|0,0	;2c4	= 
	.word	sp_anncer|0,0	;2c5	= 
	.word	sp_anncer|0,0	;2c6	= 
	.word	sp_anncer|44,6276	;2c7	= (non-partisan) Giddup Doink
	.word	sp_anncer|46,6280	;2c8	= (non-partisan) Giddup Shawn
	.word	sp_anncer|47,6284	;2c9	= (non-partisan) Giddup Ramone
	.word	sp_anncer|58,6288	;2ca	= (non-partisan) Giddup Undertaker
	.word	sp_anncer|53,6292	;2cb	= (non-partisan) Giddup BamBam
	.word	sp_anncer|43,6296	;2cc	= (non-partisan) Giddup Luger
	.word	sp_anncer|51,6300	;2cd	= (non-partisan) Giddup Hitman
	.word	sp_anncer|61,6304	;2ce	= (non-partisan) Giddup Yokozuna
	.word	sp_anncer|104,6308	;2cf	= Doink got exactly what he deserved
	.word	sp_anncer|0,0	;2d0	= 
	.word	sp_anncer|130,6316	;2d1	= Shawn Michaels got exactly what he deserved
	.word	sp_anncer|129,6320	;2d2	= Razor Ramone got exactly what he deserved
	.word	sp_anncer|134,6324	;2d3	= the Undertaker got exactly what he deserved
	.word	sp_anncer|131,6328	;2d4	= BamBam Bigelow got exactly what he deserved
	.word	sp_anncer|128,6332	;2d5	= Hox Lugie got exactly what he deserved
	.word	sp_anncer|117,6336	;2d6	= Wet Fart got exactly what he deserved
	.word	sp_anncer|0,0	;2d7	= 
	.word	sp_anncer|129,6344	;2d8	= Yucko Zima got exactly what he deserved
	.word	sp_anncer|140,6348	;2d9	= Anything can happen here at the WWF
	.word	sp_anncer|111,6352	;2da	= Anything can happen here at Wrestlemania
	.word	sp_anncer|103,6356	;2db	= Quiet McMahon I'm trying to watch this
	.word	sp_anncer|70,6360	;2dc	= heaves him over the ropes
	.word	sp_anncer|73,6376	;2dd	= He's goin' fer the top rope
	.word	sp_anncer|54,6412	;2de	= who does he think he is?
	.word	sp_anncer|0,0	;2df	= 
	.word	0,0	;2e0 
	.word	sp_anncer|65,6424	;2e1	= Listen to the crowd
	.word	sp_anncer|90,6428	;2e2	= They're cheering for me McMahon
	.word	sp_anncer|68,6432	;2e3	= What morons
	.word	sp_anncer|52,6440	;2e4	= Jew hear that?
	.word	sp_anncer|54,6452	;2e5	= Wuwuzzee thinkin'?
	.word	sp_anncer|54,6456	;2e6	= Wussy up to?
	.word	sp_anncer|71,6460	;2e7	= Nadda good idea
	.word	sp_anncer|48,6472	;2e8	= Wudda jerk
	.word	sp_anncer|53,6488	;2e9	= Wudda comeback
	.word	sp_anncer|106,6492	;2ea	= I wooden wanna beonna recieving end uh that
	.word	sp_anncer|99,6496	;2eb	= I think I saw some teeth pop out
	.word	sp_anncer|74,6512	;2ec	= Yes the chair
	.word	sp_anncer|81,6516	;2ed	= The chair the chair
	.word	sp_anncer|55,6520	;2ee	= Hiddim hiddim
	.word	sp_anncer|54,6528	;2ef	= Mr Fuji ? 
	.word	0,0	;2f0	= 
	.word	sp_anncer|51,6540	;2f1	= Aawuz cheap
	.word	sp_anncer|85,6544	;2f2	= Hey I didn't see anything
	.word	sp_anncer|86,6548	;2f3	= What kyna cheap move wuzzat?
	.word	sp_anncer|55,6552	;2f4	= Wudda ripoff
	.word	sp_anncer|80,6560	;2f5	= Aw wudda scam
	.word	sp_anncer|52,6568	;2f6	= Don't bother
	.word	sp_anncer|62,6576	;2f7	= Sure it was
	.word	sp_anncer|98,6592	;2f8	= If I didn't see it I wouldn't believe it
	.word	sp_anncer|67,6608	;2f9	= No one kin touch im
	.word	sp_anncer|40,6612	;2fa	= He did it
	.word	sp_anncer|81,6616	;2fb	= I can't believe he pulled that off
	.word	sp_anncer|73,6620	;2fc	= Adwuddneevena challenge
	.word	sp_anncer|79,6624	;2fd	= And stay down
	.word	sp_anncer|120,6628	;2fe	= He got exactly what he deserved
	.word	sp_anncer|223,6632	;2ff	= Congratulations to the new WWF champion
	.word	sp_anncer|163,6636	;300	= Sign yer name to the Midway Hall of Fame
	.word	sp_anncer|88,6640	;301	= Back to the sandbox
	.word	sp_anncer|66,6644	;302	= Aw c'mon #2
wrestle_end

triple_end	;end of triple sound tables


******************************************************************************
*
* sound table format:  each row contains the triple_sound_table indices of
* the four sound calls associated with a given move.  the first two are the
* noises a wrestler makes when he throws the move, and the second two are
* the noises he makes when he's hit with the move.  if the value is DEFLT,
* the value will be read from DEFAULT_SOUND_TABLE instead of the wrestler's
* custom table.
*

DEFLT	.equ	8000h

DEFAULT_SOUND_TABLE
	;	whsh  grunt smak  ouch
	.word	0012h,0032h,1001h,002Dh	;punch
	.word	0017h,0000h,001Bh,002Eh	;headbutt
	.word	0011h,0032h,0018h,007Ch	;kick
	.word	0011h,0079h,001Bh,0071h	;flykick

	.word	0000h,0028h,0000h,001Ah	;grabthrow
	.word	0016h,002Ch,0001h,0072h	;uppercut
	.word	0011h,0032h,0005h,0073h	;elbow drop
	.word	0000h,0028h,0000h,0000h	;grabhold

	.word	0000h,0028h,0000h,001Ah	;grabfling

	.word	0000h,0079h,0007h,0026h	;push
	.word	0000h,0028h,0000h,001ah	;hiptoss
	.word	0017h,007Ah,0074h,0000h	;big boot
	.word	0012h,0032h,001Bh,002Dh	;super punch

	.word	0000h,0079h		;turndive
	.word	            1002h,1003h	;rug slam

	.word	            00A9h,0072h	;rzr slash
	.word	0059h			;yellthrow

MASTER_SOUND_TABLE
;Bret Hart	00
	;	whsh  grunt smak  ouch
	.word	DEFLT,1022H,DEFLT,1030H	;punch
	.word	DEFLT,1023H,DEFLT,1031H	;headbutt
	.word	DEFLT,1024H,DEFLT,1032H	;kick
	.word	DEFLT,1025H,DEFLT,1033H	;flykick

	.word	DEFLT,1027H,DEFLT,1035H	;grabthrow
	.word	DEFLT,1026H,DEFLT,1034H	;uppercut
	.word	DEFLT,1029H,DEFLT,1037H	;elbow drop
	.word	DEFLT,1028H,DEFLT,1036H	;grabhold

	.word	DEFLT,1027H,DEFLT,1035H	;grabfling
	.word	DEFLT,102BH,DEFLT,1039H	;push
	.word	DEFLT,102CH,DEFLT,103AH	;hiptoss
	.word	DEFLT,102AH,DEFLT,1038H	;big boot

	.word	DEFLT,102EH,DEFLT,103CH	;super punch

	.word	DEFLT,DEFLT		;turndive
	.word	            DEFLT,103DH	;rug slam
	.word	            DEFLT,DEFLT	;rzr slash
	.word	DEFLT			;yellthrow

;Razor Ramon	01
	;	whsh  grunt smak  ouch
	.word	DEFLT,0031h,DEFLT,103fh	;punch
	.word	DEFLT,0274H,DEFLT,0269H	;headbutt
	.word	DEFLT,1040h,DEFLT,103fh	;kick
	.word	DEFLT,1041h,DEFLT,103eh	;flykick

	.word	DEFLT,1041h,DEFLT,026EH	;grabthrow
	.word	DEFLT,1040h,DEFLT,103eh	;uppercut
	.word	DEFLT,0278H,DEFLT,103eh	;elbow drop
	.word	DEFLT,0279H,DEFLT,026eH	;grabhold

	.word	DEFLT,1041h,DEFLT,026dH	;grabfling
	.word	DEFLT,1040h,DEFLT,026fh	;push
	.word	DEFLT,1041h,DEFLT,0270h	;hiptoss
	.word	DEFLT,0271H,DEFLT,0077h	;big boot

	.word	DEFLT,1041h,DEFLT,103eh	;super punch

	.word	DEFLT,1041h		;turndive
	.word	            DEFLT,DEFLT	;rug slam
	.word	            DEFLT,026fH	;rzr slash
	.word	DEFLT			;yellthrow

;Undertaker	02
	.word	DEFLT,1022H,DEFLT,1030H	;punch
	.word	DEFLT,1023H,DEFLT,1031H	;headbutt
	.word	DEFLT,1024H,DEFLT,1032H	;kick
	.word	DEFLT,1025H,DEFLT,1033H	;flykick

	.word	DEFLT,1027H,DEFLT,1035H	;grabthrow
	.word	DEFLT,1026H,DEFLT,1034H	;uppercut
	.word	DEFLT,1029H,DEFLT,1037H	;elbow drop
	.word	DEFLT,1028H,DEFLT,1036H	;grabhold

	.word	DEFLT,1027H,DEFLT,1035H	;grabfling
	.word	DEFLT,102BH,DEFLT,1039H	;push
	.word	DEFLT,102CH,DEFLT,103AH	;hiptoss
	.word	DEFLT,102AH,DEFLT,1038H	;big boot

	.word	DEFLT,102EH,DEFLT,103CH	;super punch

	.word	DEFLT,DEFLT		;turndive
	.word	            DEFLT,103DH	;rug slam
	.word	            DEFLT,DEFLT	;rzr slash
	.word	DEFLT			;yellthrow

;Yokozuna	03
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;punch
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;headbutt
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;kick
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;flykick

	.word	DEFLT,DEFLT,DEFLT,DEFLT	;grabthrow
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;uppercut
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;elbow drop
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;grabhold

	.word	DEFLT,DEFLT,DEFLT,DEFLT	;grabfling
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;push
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;hiptoss
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;big boot

	.word	DEFLT,DEFLT,DEFLT,DEFLT	;super punch

	.word	DEFLT,DEFLT		;turndive
	.word	            DEFLT,DEFLT	;rug slam
	.word	            DEFLT,DEFLT	;rzr slash
	.word	DEFLT			;yellthrow

;Shawn Michaels	04
	;	whsh  grunt smak  ouch
	.word	DEFLT,1022H,DEFLT,1030H	;punch
	.word	DEFLT,1023H,DEFLT,1031H	;headbutt
	.word	DEFLT,1024H,DEFLT,1032H	;kick
	.word	DEFLT,1025H,DEFLT,1033H	;flykick

	.word	DEFLT,1027H,DEFLT,1035H	;grabthrow
	.word	DEFLT,1026H,DEFLT,1034H	;uppercut
	.word	DEFLT,1029H,DEFLT,1037H	;elbow drop
	.word	DEFLT,1028H,DEFLT,1036H	;grabhold

	.word	DEFLT,1027H,DEFLT,1035H	;grabfling
	.word	DEFLT,102BH,DEFLT,1039H	;push
	.word	DEFLT,102CH,DEFLT,103AH	;hiptoss
	.word	DEFLT,102AH,DEFLT,1038H	;big boot

	.word	DEFLT,102EH,DEFLT,103CH	;super punch

	.word	DEFLT,DEFLT		;turndive
	.word	            DEFLT,103DH	;rug slam
	.word	            DEFLT,DEFLT	;rzr slash
	.word	DEFLT			;yellthrow


;Bam Bam Bigelow 05
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;punch
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;headbutt
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;kick
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;flykick

	.word	DEFLT,DEFLT,DEFLT,DEFLT	;grabthrow
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;uppercut
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;elbow drop
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;grabhold

	.word	DEFLT,DEFLT,DEFLT,DEFLT	;grabfling
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;push
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;hiptoss
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;big boot

	.word	1042h,DEFLT,DEFLT,DEFLT	;super punch

	.word	DEFLT,DEFLT		;turndive
	.word	            DEFLT,DEFLT	;rug slam
	.word	            DEFLT,DEFLT	;rzr slash
	.word	DEFLT			;yellthrow

;Doink the Clown 06
	;	whsh  grunt smak  ouch
	.word	DEFLT,1006h,DEFLT,1013H	;punch
	.word	DEFLT,1007h,1000h,1014H	;headbutt
	.word	DEFLT,1008h,DEFLT,1015H	;kick
	.word	DEFLT,1009h,DEFLT,1016H	;flykick

	.word	DEFLT,1020h,DEFLT,1021H	;grabthrow
	.word	DEFLT,1011h,DEFLT,101eH	;uppercut
	.word	DEFLT,100ch,DEFLT,1019H	;elbow drop
	.word	DEFLT,100bh,DEFLT,1018H	;grabhold

	.word	DEFLT,1020h,DEFLT,1021H	;grabfling
	.word	DEFLT,100eh,DEFLT,101bH	;push
	.word	DEFLT,100fh,DEFLT,101cH	;hiptoss
	.word	DEFLT,0202h,DEFLT,020ch	;big boot

	.word	DEFLT,1011h,DEFLT,101eH	;super punch

	.word	DEFLT,DEFLT		;turndive
	.word	            DEFLT,101FH	;rug slam
	.word	            DEFLT,DEFLT	;rzr slash
	.word	DEFLT			;yellthrow

;Adam Bomb	07
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;punch
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;headbutt
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;kick
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;flykick

	.word	DEFLT,DEFLT,DEFLT,DEFLT	;grabthrow
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;uppercut
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;elbow drop
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;grabhold

	.word	DEFLT,DEFLT,DEFLT,DEFLT	;grabfling
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;push
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;hiptoss
	.word	DEFLT,DEFLT,DEFLT,DEFLT	;big boot

	.word	DEFLT,DEFLT,DEFLT,DEFLT	;super punch

	.word	DEFLT,DEFLT		;turndive
	.word	            DEFLT,DEFLT	;rug slam
	.word	            DEFLT,DEFLT	;rzr slash
	.word	DEFLT			;yellthrow

;Lex Luger	08
	.word	DEFLT,1022H,DEFLT,1030H	;punch
	.word	DEFLT,1023H,DEFLT,1031H	;headbutt
	.word	DEFLT,1024H,DEFLT,1032H	;kick
	.word	DEFLT,1025H,DEFLT,1033H	;flykick

	.word	DEFLT,1027H,DEFLT,1035H	;grabthrow
	.word	DEFLT,1026H,DEFLT,1034H	;uppercut
	.word	DEFLT,1029H,DEFLT,1037H	;elbow drop
	.word	DEFLT,1028H,DEFLT,1036H	;grabhold

	.word	DEFLT,1027H,DEFLT,1035H	;grabfling
	.word	DEFLT,102BH,DEFLT,1039H	;push
	.word	DEFLT,102CH,DEFLT,103AH	;hiptoss
	.word	DEFLT,102AH,DEFLT,1038H	;big boot

	.word	DEFLT,102EH,DEFLT,103CH	;super punch

	.word	DEFLT,DEFLT		;turndive
	.word	            DEFLT,103DH	;rug slam
	.word	            DEFLT,DEFLT	;rzr slash
	.word	DEFLT			;yellthrow
;MISSING LINES

#*****************************************************************************
*
* Play a sound from the tables.
* >a0 = sound number (or'ed with 1000h for a random table)
*

 SUBR	table_sound

	btst	12,a0
	jreq	triple_sound

	;it's a random sound
	PUSH	a2
	xori	1000h,a0
	X32	a0
	addi	#random_sound_tables,a0
	move	*a0,a2,L
	move	*a2+,a0,W
	calla	RNDRNG0
	X16	a0
	add	a0,a2
	move	*a2,a0,W
	PULL	a2
	jruc	triple_sound

#random_sound_tables
	.long	#doink_hdbutt_l		; 0
	.long	#generic_punch_l	; 1
	.long	#generic_rugslam_l	; 2
	.long	#generic_rslam_impact_l	; 3
	.long	#doink_rugslam_l	; 4
	.long	#doink_rugslam_impact_l	; 5

	.long	#doink_face_a	   ;6
	.long	#doink_head_a	   ;7
	.long	#doink_kick_a	   ;8
	.long	#doink_drop_a	   ;9
	.long	#doink_knee_a	   ;a
	.long	#doink_reach_a	   ;b
	.long	#doink_elbow_a	   ;c
	.long	#doink_stomp_a	   ;d
	.long	#doink_push_a	   ;e
	.long	#doink_hip_a	   ;f
	.long	#doink_jump_a	   ;10
	.long	#doink_super_a	   ;11
	.long	#doink_slam_a	   ;12

	.long	#doink_face_v	   ;13
	.long	#doink_head_v	   ;14
	.long	#doink_kick_v	   ;15
	.long	#doink_drop_v	   ;16
	.long	#doink_knee_v	   ;17
	.long	#doink_reach_v	   ;18
	.long	#doink_elbow_v	   ;19
	.long	#doink_stomp_v	   ;1a
	.long	#doink_push_v	   ;1b
	.long	#doink_hip_v	   ;1c
	.long	#doink_jump_v	   ;1d
	.long	#doink_super_v	   ;1e
	.long	#doink_slam_v	   ;1f
		
	.long	#doink_lift_a	   ;20
	.long	#doink_lift_v	   ;21

	.long	#hart_face_a	   ;22
	.long	#hart_head_a	   ;23
	.long	#hart_kick_a	   ;24
	.long	#hart_drop_a	   ;25
	.long	#hart_knee_a	   ;26
	.long	#hart_reach_a	   ;27
	.long	#hart_lift_a	   ;28
	.long	#hart_elbow_a	   ;29
	.long	#hart_stomp_a	   ;2a
	.long	#hart_push_a	   ;2b
	.long	#hart_hip_a	   ;2c
	.long	#hart_jump_a	   ;2d
	.long	#hart_super_a	   ;2e
	.long	#hart_slam_a	   ;2f

	.long	#hart_face_v	   ;30
	.long	#hart_head_v	   ;31
	.long	#hart_kick_v	   ;32
	.long	#hart_drop_v	   ;33
	.long	#hart_knee_v	   ;34
	.long	#hart_reach_v	   ;35
	.long	#hart_lift_v	   ;36
	.long	#hart_elbow_v	   ;37
	.long	#hart_stomp_v	   ;38
	.long	#hart_push_v	   ;39
	.long	#hart_hip_v	   ;3a
	.long	#hart_jump_v	   ;3b
	.long	#hart_super_v	   ;3c
	.long	#hart_slam_v	   ;3d

	.long	#razor_medium_pain	;3e
	.long	#razor_face_hit		;3f
	.long	#razor_medium_effort	;40
	.long	#razor_double_effort	;41

	.long	#bam_mult_fire_hits  ;42
		
#doink_hdbutt_l
	.word	3,1Bh,1Bh,1Bh,0B2h

#generic_punch_l
	.word	3,1h,2h,19h,1Bh

#generic_rugslam_l
	.word	5,072h,071h,07Ch,074h,0AEh,0AFh

#generic_rslam_impact_l
	.word	1,0C1h,0C3h

#doink_rugslam_l
	.word	5,072h,071h,07Ch,074h,0AEh,0AFh

#doink_rugslam_impact_l
	.word	5,0C1h,0C1h,0C3h,0C3h,0ACh,0ADh


#doink_face_a
	.word	1,235h,21bh
#doink_head_a
	.word	1,234h,21ch
#doink_kick_a
#doink_knee_a
#doink_slam_a
	.word	2,224h,225h,226h
#doink_drop_a
#doink_elbow_a
	.word	2,21dh,21eh,21fh
#doink_reach_a
	.word	1,220h,221h
#doink_lift_a
	.word	1,222h,223h
#doink_stomp_a
	.word	3,21bh,224h,225h,226h
#doink_push_a
	.word	1,227h,228h
#doink_hip_a
	.word	5,21dh,21eh,21fh,207h,208h,209H
#doink_jump_a
	.word	1,229h,22ah
#doink_super_a
	.word	1,206h,21bh


#doink_face_v
	.word	2,200h,201h,202h
#doink_head_v
	.word	1,200H,22BH
#doink_kick_v
	.word	1,205H,22CH
#doink_drop_v
	.word	5,22BH,200H,202H,202H,202H,202H
#doink_knee_v
#doink_elbow_v
	.word	2,22CH,203H,22DH
#doink_reach_v
#doink_lift_v
	.word	1,22EH,22FH
#doink_stomp_v
	.word	2,22CH,22DH,204H,20BH
#doink_push_v
	.word	1,230H,231H
#doink_hip_v
	.word	1,232H,233H
#doink_jump_v
	.word	2,22BH,204H,22CH
#doink_super_v
	.word	1,20AH,20CH,20DH
#doink_slam_v
	.word	2,203H,204H,22CH

#hart_face_a
	.word	2,23Eh,240H,242H
#hart_head_a
	.word	2,23DH,240H,24AH
#hart_kick_a
	.word	1,242H,24DH
#hart_drop_a	
	.word	2,247H,248h,249h
#hart_knee_a
	.word	1,241H,24DH
#hart_reach_a
	.word	2,23FH,24BH,24CH
#hart_lift_a
	.word	1,243H,244H
#hart_elbow_a
	.word	2,247H,248H,249H
#hart_stomp_a
	.word	1,23DH,240H
#hart_push_a
	.word	1,24FH,24AH
#hart_hip_a
	.word	4,242H,244H,247H,248H,249H
#hart_jump_a
	.word	1,245H,24EH
#hart_super_a
	.word	1,242H,24DH
#hart_slam_a
	.word	2,240H,24FH,240H

#hart_face_v
	.word	2,251H,252H,253H
#hart_head_v
	.word	2,25CH,253H,262H
#hart_kick_v
#hart_knee_v
	.word	2,250H,254H,255H
#hart_drop_v	
	.word	3,251H,252H,253H,25CH
#hart_reach_v
	.word	1,258H,259H
#hart_lift_v
	.word	1,25AH,25BH
#hart_elbow_v
#hart_stomp_v
	.word	1,256H,257H
#hart_push_v
	.word	1,25DH,25EH
#hart_hip_v
	.word	1,25FH,260H
#hart_jump_v
	.word	2,264H,256H,261H
#hart_super_v
	.word	2,262H,25CH,261H
#hart_slam_v
	.word	2,261H,256H,257H

#razor_medium_pain
	.word	3,26ah,26bh,26ch,271h
#razor_face_hit
	.word	3,267h,268h,269h,26fh
#razor_medium_effort
	.word	2,272h,273h,274h
#razor_double_effort
	.word	3,275h,276h,277h,279h
#bam_mult_fire_hits
	.word	1,99h,9ah


******************************************************************************
*												*
* reset sound board										*
*												*
* this is a full reset, checksum dings and all. this is the same routine
* that was in the old (gspsnd) processor. (ed boon)
*
* NOTE: If any data are sent to the sound board within ~270msec of the
*       reset signal, diagnostics will be skipped and there won't be any
*       loud and annoying bongs.
*

 SUBR	snd_reset

	;initialize snd_debug ptr
	.if SND_DEBUG
	movi	SDRAM,a14
	move	a14,@sdram_ptr,L
	.endif

	PUSH	a0,a1		;Need an extra reggie

	movi	SNDRSTBIT|32,a0
	move	@_coin_counter_addr,a1,L
	move	a0,*a1

	movi	6000,a0		;wait for it to catch
	dsjs	a0,$

	movi	32,a0
	move	@_coin_counter_addr,a1,L
	move	a0,*a1

	PULL	a0,a1		; Restore the reggies
	rets


******************************************************************************
*
* quiet sound board reset
*
* Just like snd_reset, but without the diagnostic tests and consequent chimes.
* It also sets the volume to the CMOS level.
* 
* NOTE: Don't CALLx this function, JSRP it.  It SLEEPs.
*
* Trashes everything except the reggies which get saved by default when
* you sleep...

 SUBR	QSNDRST

	;initialize snd_debug ptr
	.if SND_DEBUG
	movi	SDRAM,a14
	move	a14,@sdram_ptr,L
	.endif

	;doing an EXISTP on QSNDRST_PID isn't enough because this can
	; be JSRP'd from other places too.
	movk	1,a14
	move	a14,@doing_dcs_reset

	movi	SNDRSTBIT|32,a0
	move	@_coin_counter_addr,a1,L	; IS A1 SAFE?
	move	a0,*a1,W


	movi	6000,a0		;wait for it to catch
	dsjs	a0,$	

	movi	32,a0
	move	@_coin_counter_addr,a1,L	; IS A1 SAFE?
	move	a0,*a1,W

	SLEEPK	2
	move	@_sound_addr,a0,L
	movb	a14,*a0
	SLEEPK	4
	movi	ADJVOLUME,a0
	calla	GET_ADJ
	BADCHK	a0,0,255,28		;reg, lo, hi, val if bad
	callr	set_volume		;set master volume to CMOS level

	clr	a14
	move	a14,@doing_dcs_reset

	RETP

#*****************************************************************************
* Process that quietly resets the sound board, then dies.  Useful when you
* don't feel like waiting for the reset to finish before you move on.

 SUBR	qsndrst_proc

	JSRP	QSNDRST

	DIE

******************************************************************************

 SUBR	snd_play1
	rets


#*****************************************************************************
* Wrestlemania tune

 SUBR	wmania_tune

	movi	11,a3
	callr	SNDSND
#loop
	SLEEP	TSEC*8
	movi	14,a3
	callr	SNDSND
	SLEEP	TSEC*8
	movi	13,a3
	callr	SNDSND
	jruc	#loop


#*****************************************************************************
* Rings the match start bell a few times. (process)
*
* Note:  This uses the channel_sound routine to conserve tracks.  If, for
*        whatever reason, these rings are spaced out by more than 89 ticks,
*        (the duration of the bell sound), then this should NOT be done as
*        it could result in other sound calls being truncated prematurely.
*

bell_snd	equ	0B1h

	STRUCTPD
	WORD	#BELL_CHANNEL	;UHW snd channel of bell

 SUBR	ring_bell

	movi	bell_snd,a0
	callr	triple_sound
	sra	16,a14
	move	a14,*a13(#BELL_CHANNEL),W

	SLEEP	TSEC/3

	movi	bell_snd,a0
	move	*a13(#BELL_CHANNEL),a1,W
	callr	channel_sound

	SLEEP	TSEC/3

	movi	bell_snd,a0
	move	*a13(#BELL_CHANNEL),a1,W
	callr	channel_sound

	DIE


#*****************************************************************************
* Runs the speech call for a given wrestler, after waiting for channel 1 to
* clear.
*
*>a0=wrestler #

 SUBR	select_speech

	X32	a0
	addi	#wrestler_sounds,a0
	move	*a0+,a8,W
	jrz	#done
	move	*a0,a9,W

	CREATE	DELAYSND_PID,delay_code_a3

#done
	rets

	.bss	delay_code_a3_exists,16

 SUBRP	delay_code_a3

#loop1
	;if this is the only delay_code_a3 process, do the sound, wait out
	; the duration, then die.
;	movi	DELAYSND_PID,a0
;	movi	0FFFFh,a1
;	calla	EXISTP
;	jrz	#go
;	SLEEPK	1
;	jruc	#loop1

	move	@delay_code_a3_exists,a14
	jrz	#no_exist
	SLEEPK	1
	jruc	#loop1
#no_exist
	movk	1,a14
	move	a14,@delay_code_a3_exists

#go
	move	a8,a3
	callr	send_code_a3

#loop2
	SLEEPK	1
	dsj	a9,#loop2

	clr	a14
	move	a14,@delay_code_a3_exists

	DIE


#wrestler_sounds
	.word	0000h,0		;HART
	.word	0300h,94	;RAZOR
	.word	0000h,0		;TAKER
	.word	0000h,0		;YOKO
	.word	0000h,0		;SHAWN
	.word	0000h,0		;BAM BAM
	.word	0200h,88	;DOINK
	.word	0000h,0		;ADAM BOMB
	.word	0000h,0		;PERFECT
	.word	0000h,0		;LUGER
#wrestler_soundsX


#*****************************************************************************
* channel_sound
*
* like triple_sound, only you specify the channel it goes on, priorities
* notwithstanding.  This isn't quite the same thing as SNDSND, tho, since
* chanXpri, chanXdur, and chanXsnd are updated.
*
* >a0 = sound call (index), >a1=channel (1-4)
*

 SUBR	channel_sound

	PUSH	a0,a1,a2,a3,a4

	X32	a0
	addi	triple_sndtab,a0
	move	*a0,a2,W
	andi	0ffh,a2		;a2 = duration
	move	*a0+,a3,W
	sra	8,a3		;a3 = priority
	move	*a0,a4,W	;a4 = call (channel 1)

	dec	a1
	jrz	#chan1
	inc	a4
	dec	a1
	jrz	#chan2
	inc	a4
	dec	a1
	jrz	#chan3
	inc	a4
	dec	a1
	jrz	#chan4

	;error!
	.if DEBUG
	LOCKUP
	.endif
	jruc	#done
#chan1
	move	a2,@chan1dur,W
	move	a3,@chan1pri,W
	move	a4,@chan1snd,W
	jruc	#send
#chan2
	move	a2,@chan2dur,W
	move	a3,@chan2pri,W
	move	a4,@chan2snd,W
	jruc	#send
#chan3
	move	a2,@chan3dur,W
	move	a3,@chan3pri,W
	move	a4,@chan3snd,W
	jruc	#send
#chan4
	move	a2,@chan4dur,W
	move	a3,@chan4pri,W
	move	a4,@chan4snd,W
;	jruc	#send

#send
	move	a4,a3
	callr	send_code_a3

#done
	PULL	a0,a1,a2,a3,a4
	rets

#*****************************************************************************
* announcer_sound
*
* Lots like triple_sound, except that it identifies the announcer who's
* talking, and if he's already saying something, the new call cuts off
* the old one.
*
* >a0 = sound call (index into triple_sound table)
* <a0 = sound call duration in ticks (-1 if not announcer speech)
*

WHO_IS_IT
	;figure out who it is.
	move	a0,a1
	X32	a1
	addi	triple_sndtab,a1

	cmpi	announcer_start,a1
	jrlt	#error1			;too low -- not an announcer

	cmpi	vince_end,a1
	jrlt	#vince			;it's vince

	cmpi	randy_end,a1
	jrlt	#randy			;it's jerry

	cmpi	howards_end,a1
	jrlt	#howard			;it's howard

	cmpi	more_jerry,a1
	jrlt	#error2			;between howard and jerry - bogus

	cmpi	triple_end,a1
	jrge	#error3			;long after the table.  error.
	jruc	#randy			;more jerry (randy)
	
#vince
	movi	vincechan,a1
	movi	vincedur,a2
	jruc	#cont
#randy
	movi	randychan,a1
	movi	randydur,a2
	jruc	#cont
#howard
	movi	howardchan,a1	;a1 = pointer to announcer channel
	movi	howarddur,a2	;a2 = pointer to announcer duration

#cont
	clrc
	move	*a2,a14
	RETS

#error1
	.if DEBUG
;	LOCKUP		;call # too low - not an announcer.
	.endif
	setc
	rets

#error2
	.if DEBUG
;	LOCKUP		;call # in that range between howard and 2nd jerry.
	.endif
	setc
	rets


#error3
	.if DEBUG
;	LOCKUP		;call # higher than end of table - not an announcer.
	.endif
	setc
	rets


 SUBR	announcer_sound

	PUSH	a1,a2,a3,a4,a5
	CALLR	WHO_IS_IT

	JRC	#error
	jrz	#no_cutoff

	;Guy is already talking.  Start the new call on the same track.
	X32	a0
	addi	triple_sndtab,a0
	move	*a0,a3,W
	andi	0FFh,a3		;a3 = duration of new call
	move	*a0+,a4,W
	sra	8,a4		;a4 = priority of new call
	move	*a0+,a5		;a5 = sound call base (must adjust for chan)

	move	*a1,a0
	dec	a0
	jrz	#chan1
	inc	a5
	dec	a0
	jrz	#chan2
	inc	a5
	dec	a0
	jrz	#chan3
	inc	a5
	dec	a0
	jrz	#chan4

	;bad channel?!  This should never happen.  Stop right there.
	.if DEBUG
	LOCKUP
	.endif
	movi	-1,a0
	jruc	#end

#chan1
	move	a4,@chan1pri,W
	move	a3,@chan1dur,W
	jruc	#fire
#chan2
	move	a4,@chan2pri,W
	move	a3,@chan2dur,W
	jruc	#fire
#chan3
	move	a4,@chan3pri,W
	move	a3,@chan3dur,W
	jruc	#fire
#chan4
	move	a4,@chan4pri,W
	move	a3,@chan4dur,W
;	jruc	#fire

#fire
	move	a3,*a2,W	;set announcer duration
	move	a3,a0
	move	a5,a3
	callr	send_code_a3
	jruc	#end

#error
	;not an announcer call!  Desist!
	movi	-1,a0
	jruc	#end

#no_cutoff
	;announcer isn't already talking.  Fire off a triple_sound as normal
	calla	triple_sound
	move	a14,*a2,W
	move	a14,a0
	andi	0ffh,a0
	sra	16,a14
	move	a14,*a1,W

#end
	PULL	a1,a2,a3,a4,a5
	rets


#*****************************************************************************
* wrtable_sound
*
* performs a sound call from the master table for a wrestler
*
* >a10 = *wrestlerproc >a0 = sound call index (might be OR'ed with 8000h)
*

 SUBR	wrtable_sound

	push	a1,a4

	;undo the |W_LOOKUP if present
	sll	32-15,a0
	srl	32-15,a0

	move	*a10(WRESTLERNUM),a1,W
	movi	MASTER_SOUND_TABLE-DEFAULT_SOUND_TABLE,a2
	mpyu	a2,a1
	X16	a0
	add	a0,a1
	addi	MASTER_SOUND_TABLE,a1
	move	*a1,a1,W
	jrnn	#okay

	;oops.  use the default table instead
	addi	DEFAULT_SOUND_TABLE,a0
	move	*a0,a1,W
#okay
	move	a1,a0
	jrz	#done
	calla	triple_sound

#done
	pull	a1,a4
	rets

#*****************************************************************************
*
*  triple_sound - Make a sound call from the triple_sndtab sound table
*
*  input: a0 = sound call offset into table
*  output: a14 = [channel,duration] of call. (0 if not played)
*

 SUBR	triple_sound

	cmpi	211h,a3
	jrne	#okx
	LOCKUP
#okx
	move	@SOUNDSUP,b3,W		; are we allowed ??
	jrne	send_rets		; no

	clr	a14
	PUSH	a0,a1,a2,a3,a4,a5,a6

	.if SND_DEBUG
	.ref	PCNT
	move	@sdram_ptr,a1,L
	move	a0,*a1(INDEX),W
	move	@PCNT,a14,L
	move	a14,*a1(TSTMP),L
	move	a0,a2
	X32	a2
	addi	triple_sndtab,a2
	move	a2,*a1(ADRS),L
	move	*a2,a14,W
	srl	8,a14
	move	a14,*a1(PRI)
	move	*a2+,a14,W
	sll	24,a14
	srl	24,a14
	move	a14,*a1(DUR)
	move	*a2,a14,W
	move	a14,*a1(CHAN0)
	move	*SP(0E0h),a14,L
	subi	30h,a14
	move	a14,*a1(CALLER),L
	movi	-1,a14
	move	a14,*a1(CHANL)
	.endif

	TEST	a0
	jrn	#a0lo

	X32	a0			; 32 bits per table entry
	addi	triple_sndtab,a0 	; a0 --> our entry
	cmpi	triple_end,a0		; past the end of the table ?
	jrhs	#a0hi			; yes, sans

tsnd0	move	*a0+,a1,W		; a1 = [priority , duration]
	jreq	tsnd9			; zero entry = skip

	move	a1,a4
	srl	8,a1			; a1 = priority only
	sll	32-8,a4
	srl	32-8,a4			; a4 = duration only
	move	*a0+,a3,W		; a3 = channel 1 sound call
	jrz	#zcall			; quit if zero
*
* a1 = priority
* a3 = channel 1 sound call
* a4 = duration
*

	.if SND_DEBUG
	;tentatively set SDA_EMPTY.  we might change that later.
	move	@sdram_ptr,a0,L
	movi	SDA_EMPTY,a14
	move	a14,*a0(ACTION)
	.endif

	move	@chan1pri,a0,W
	jreq	tsnd1			; channel 1
	move	@chan2pri,a0,W
	jreq	tsnd2			; channel 2
	move	@chan3pri,a0,W
	jreq	tsnd3			; channel 3
	move	@chan4pri,a0,W
	jreq	tsnd4			; channel 4
*
* all channels used up ---> see if I am more important
*


;New Method = find lowest-priority call and bump it if I outrank it.

	move	@chan1pri,a5,W
	movi	tsnd1,a6

	move	@chan2pri,a14
	cmp	a5,a14
	jrge	#check_3
	move	a14,a5
	movi	tsnd2,a6
#check_3
	move	@chan3pri,a14
	cmp	a5,a14
	jrge	#check_4
	move	a14,a5
	movi	tsnd3,a6
#check_4
	move	@chan4pri,a14
	cmp	a5,a14
	jrge	#lowest_found
	move	a14,a5
	movi	tsnd4,a6

#lowest_found
	cmp	a5,a1			; who is more important ?
	jrlt	#no_preempt		; him.  forget it.

	.if SND_DEBUG
	;set ACTION to SDA_PREEMPT
	move	@sdram_ptr,a0,L
	movi	SDA_PREEMPT,a14
	move	a14,*a0(ACTION)
	.endif

	jump	a6
		
#no_preempt
	.if SND_DEBUG
	;set ACTION to SDA_LOPRI
	move	@sdram_ptr,a0,L
	movi	SDA_LOPRI,a14
	move	a14,*a0(ACTION)
	.endif

	PULL	a0,a1,a2,a3,a4,a5,a6
send_rets
	.if SND_DEBUG
	;increment sdram_ptr
	callr	#inc_sdram
	.endif
	clr	a14
	clrc
	rets

tsnd1	move	a1,@chan1pri,W		; new priority for channel 1
	move	a4,@chan1dur,W		; new duration
	movi	[1,0],a2
	move	a3,@chan1snd,W
	jruc	tsnd7

tsnd2	move	a1,@chan2pri,W		; new priority for channel 2
	move	a4,@chan2dur,W		; new duration
	inc	a3			; switch to channel 2 sound call
	move	a3,@chan2snd,W
	movi	[2,0],a2
	jruc	tsnd7

tsnd3	move	a1,@chan3pri,W		; new priority for channel 3
	move	a4,@chan3dur,W		; new duration
	addk	2,a3			; switch to channel 3 sound call
	move	a3,@chan3snd,W
	movi	[3,0],a2
	jruc	tsnd7

tsnd4	move	a1,@chan4pri,W		; new priority for channel 4
	move	a4,@chan4dur,W		; new duration
	addk	3,a3			; switch to channel 4 sound call
	move	a3,@chan4snd,W
	movi	[4,0],a2

tsnd7
	.if SND_DEBUG
	PUSH	a2
	move	@sdram_ptr,a14,L
	srl	16,a2
	move	a2,*a14(CHANL)
	PULL	a2
	.endif

	callr	SNDSND
	movx	a4,a2
	move	a2,a14

tsnd9
	.if SND_DEBUG
	;increment sdram_ptr
	callr	#inc_sdram
	.endif

	PULL	a0,a1,a2,a3,a4,a5,a6
	setc	 			; carry set = success
	rets

#zcall
	.if SND_DEBUG
	move	@sdram_ptr,a0,L
	movi	SDA_ZCALL,a1
	move	a1,*a0(ACTION)
	.endif
	jruc	tsnd9

#a0hi
#a0lo
	.if SND_DEBUG
	move	@sdram_ptr,a0,L
	movi	SDA_BADNDX,a1
	move	a1,*a0(ACTION)
	.endif
	jruc	tsnd9

	.if SND_DEBUG

 SUBRP	#inc_sdram

	PUSH	a14

	move	@sdram_ptr,a14,L
	addi	SNDCALSIZ,a14
	cmpi	sdram_ptr,a14
	jrlt	#is_ok
	movi	SDRAM,a14

#is_ok	move	a14,@sdram_ptr,L
	PULL	a14
	rets

	.endif




#*****************************************************************************

 SUBR	snd_update

	;update announcer bits
	move	@vincedur,a0,W
	jrz	#no_vince
	dec	a0
	move	a0,@vincedur,W
#no_vince

	move	@randydur,a0,W
	jrz	#no_randy
	dec	a0
	move	a0,@randydur,W
#no_randy

	move	@howarddur,a0,W
	jrz	#no_howard
	dec	a0
	move	a0,@howarddur,W
#no_howard

	move	@chan1dur,a0,W			; channel #1 timing down ?
	jrz	sup2				; nope....
;	inc	a0
;	jrz	sup2
;	dec	a0
	dec	a0				; yes, count this tick !!
	move	a0,@chan1dur,W			; update duration ram
	jrnz	sup2

	move	@chan1scp,a1,L			; we doing a tune script ?
	jrz	sup1				; no
	movi	chan1pri,a0			; a0 = input = chan 1 ram pointer
	callr	do_tune_commands
	jruc	sup2
sup1	move	a1,@chan1pri,W			; no script --> priority = 0

sup2	move	@chan2dur,a0,W			; channel #2 timing down ?
	jrz	sup3				; nope....
;	inc	a0
;	jrz	sup3
;	dec	a0
	dec	a0				; yes, count this tick !!
	move	a0,@chan2dur,W			; update duration ram
	jrnz	sup3
	move	@chan2scp,a1,L			; a1 = input = chan 2 script point
	jrz	sup25				; we are not processing a tune !!
	movi	chan2pri,a0			; a0 = input = chan 2 ram pointer
	callr	do_tune_commands
	jruc	sup3
sup25	move	a1,@chan2pri,W			; no script --> priority = 0

sup3	move	@chan3dur,a0,W			; channel #3 timing down ?
	jrz	sup4				; nope....
;	inc	a0
;	jrz	sup4
;	dec	a0
	dec	a0				; yes, count this tick !!
	move	a0,@chan3dur,W			; update duration ram
	jrnz	sup4
	move	@chan3scp,a1,L			; a1 = input = chan 3 script point
	jrz	sup35				; we are not processing a tune !!
	movi	chan3pri,a0			; a0 = input = chan 3 ram pointer
	callr	do_tune_commands
	jruc	sup4
sup35	move	a1,@chan3pri,W			; no script --> priority = 0

sup4	move	@chan4dur,a0,W			; channel #4 timing down ?
	jrz	supexit				; nope....
;	inc	a0
;	jrz	supexit
;	dec	a0
	dec	a0				; yes, count this tick !!
	move	a0,@chan4dur,W			; update duration ram
	jrnz	supexit
	move	@chan4scp,a1,L			; a1 = input = chan 4 script point
	jrz	sup45				; we are not processing a tune !!
	movi	chan4pri,a0			; a0 = input = chan 4 ram pointer
	callr	do_tune_commands
	rets
sup45	move	a1,@chan4pri,W			; no script --> priority = 0

supexit	rets

#*****************************************************************************
*  do_tune_commands
*
*  run and execute a list of tune commands until a "sleep" or "endtune"
*  is reached
*
*  input:
*	a0 = top of current channel's ram storage
*	a1 = current script position
*

 SUBRP	do_tune_commands
	move	*a1+,a3,W			; get [parameter,command]
	sll	16,a3
	srl	16,a3				; mask out the "ffff" scum

	move	a3,a2				; save [command,parameter]
	sll	24,a2
	srl	24,a2
	dec	a2   				; a2 = command offset
	X32	a2

	addi	tune_commands,a2
	move	*a2,a2,L			; grab address
	jump	a2				; execute

tune_commands		
	.long	tc_send		; 1
	.long	tc_setpri	; 2
	.long	tc_endtune	; 3
	.long	tc_sleep	; 4
	.long	tc_send2	; 5


tc_send
	srl	8,a3		    	; yes --> a3 = code to send
	calla	SNDSND		    	; send it and return
	jruc	do_tune_commands

tc_setpri
	srl	8,a3		    	; yes --> a3 = priority to set to
	move	a3,*a1(sndpri),W    	; set it
	jruc	do_tune_commands

tc_endtune
	clr	a1
	move	a1,*a0(sndpri),W
	move	a1,*a0(snddur),W
	move	a1,*a0(sndscp),L  	; clear this channel		
	rets

tc_sleep
	srl	8,a3		  	; yes --> a3 = sleep time
	move	a3,*a0(snddur),W  	; store into duration area
	move	a1,*a0(sndscp),L  	; save current script pointer
	clr	a1		  	; signal --> we are done
	rets

tc_send2
	push	a1			; save script position
tcs1	subk	8,a1
	movb	*a1,a2
	cmpi	endtune,a2		; search backwards for "endtune"
	jrne	tcs1
	addk	24,a1			; a1 ---> channel
	movb	*a1,a2			; a2 = current channel
	pull	a1			; restore script position

	cmpi	1,a2
	jreq	tcs2
	cmpi	2,a2
	jreq	tcs2		  	; channel 1 or 2 = player 1

	movb	*a1,a3		  	; grab it player 2 sound call
	sll	8,a3			; adjust for next line of code

tcs2	addk	8,a1		  	; a1 ---> next command
	srl	8,a3		  	; yes --> a3 = code to send
	callr	SNDSND		  	; send it and return
	jruc	do_tune_commands


tc_setpri2
	srl	8,a3		    	; yes --> a3 = priority to set to
	move	a3,*a1(sndpri),W    	; set it
	jruc	do_tune_commands

#*****************************************************************************
*  nosounds
*
*  cancels all sound calls. zeros all priorities and stops all
*  currently running tunes.
*

 SUBR	nosounds

	PUSH	a0,a1
	clr	a3
	callr	SNDSND			; silence the music board
	callr	clear_sound_ram
	PULL	a0,a1

	rets

#*****************************************************************************

 SUBRP	clear_sound_ram

	clr	a0
	movi	chan1ram,a1
nos2	move	a0,*a1+,W		; zero u out !!!
	cmpi	chan4scp+32,a1		; everyone cleared ??
	jrne	nos2			; nope, do more

	rets

#*****************************************************************************
* Sets the volume of the DCS.
* >a0=volume (0-255)
*

 SUBR	set_volume

	PUSH	a0,a1,a3

	andi	0FFh,a0			;forces value into range
	movi	55AAh,a3
	callr	send_code_a3
	
	move	a0,a3			; volume
	move	a0,a1
	not	a1			; sans volume
	sll	32-8,a1
	srl	32-8,a1
	sll	8,a3
	or	a1,a3			; a3 = [volume,sans volume]
	callr	send_code_a3

	move	a0,a1
	movi	ADJVOLUME,a0
	calla	PUT_ADJ
	calla	F_ADC_S

	PULL	a0,a1,a3
	rets

#*****************************************************************************
* Raw hardware sound call.
* >a3=sound code (0-1ff)

 SUBR	SNDSND
 SUBRP	send_code_a3

	PUSH	a0,a1,a2,a3,a4
	move	@SOUNDSUP,a0		; are we allowed ??
	jrnz	sendx			; no

	move	a3,a3			; is it a null call (negative)?
	jrn	sendx

	move	a3,a0
	sll	32-16,a3
	srl	32-8,a3			; a3 = high byte
*
* send high byte
*
	move	@_sound_addr,a4,L
	move	a3,*a4

	movk	2,a2
	dsj	a2,$			; time for signal to get through
 	callr	poll_sirq
*
* send low byte
*
	sll	32-8,a0
	srl	32-8,a0			; a3 = low byte
	move	@_sound_addr,a4,L
	move	a0,*a4

	callr	poll_sirq

sendx	PULL	a0,a1,a2,a3,a4
	rets

#*****************************************************************************
* Poll sound IRQ.  When IRQ goes high, sound board is ready for next call.
* Do timeout so sound board can't screw things up.
*

 SUBRP	poll_sirq
	movi	390/3,a4		; 180 micros max firq delay on snd board

;#poll3	movb	@SOUNDIRQ+B_SIRQ-7,a1

#poll3
	move	@_soundirq_addr,a1,L
	addi	(B_SIRQ-7),a1
	movb	*a1,a1

	jrn	#poll9			; done?
	dsj	a4,#poll3
#poll9	rets

#*****************************************************************************

VOLDN	.equ	11
VOLUP	.equ	12

 SUBR	VOLBTN_PRESS

	;in diagnostics?
	move	@GAMSTATE,a0,W
	jrn	#done

	;already adjusting?
	movi	VOLADJ_PID,a0
	movi	0FFFFh,a1
	calla	EXISTP
	jrnz	#done

	;okay, adjust
	movi	VOLADJ_PID,a14
	move	a14,*a13(PROCID),W

;	move	@COINS,a0
	move	@_coin_addr,a0,L
	move	*a0,a0
	btst	VOLDN,a0
	jrz	#voldn_loop
	

#volup_loop
	;increment the volume
	movi	ADJVOLUME,a0
	calla	GET_ADJ
	BADCHK	a0,0,255,28		;reg, lo, hi, val if bad
	inc	a0
	cmpi	255,a0
	jrle	#up_okay
	movi	255,a0
#up_okay
	calla	set_volume
	SLEEPK	1

	;if the vol+ button is no longer down, die
;	move	@COINS,a0
	move	@_coin_addr,a0,L
	move	*a0,a0
	btst	VOLUP,a0
	jrnz	#done
	jruc	#volup_loop

#voldn_loop
	;decrement the volume
	movi	ADJVOLUME,a0
	calla	GET_ADJ
	BADCHK	a0,0,255,28		;reg, lo, hi, val if bad
	dec	a0
	jrnn	#dn_okay
	clr	a0
#dn_okay
	calla	set_volume
	SLEEPK	1

	;if the vol- button is no longer down, die
;	move	@COINS,a0
	move	@_coin_addr,a0,L
	move	*a0,a0
	btst	VOLDN,a0
	jrnz	#done
	jruc	#voldn_loop

#done
	DIE

;missing KILL_HOWARD

;missing DO_HOWARD
VINCE_START_GAME
	MOVI	MATCHUP_TAB,A2
	MOVE	@HCOUNT,A1
	SRL	1,A1
	JRNC	START_CHOSEN
	MOVI	SQUARED_TAB,A2
START_CHOSEN
	movi	index1,a3
	MOVI	index2,a8
	MOVE	@PSTATUS,A0
	CMPI	3,A0
	JREQ	USE_BOTH_INDEXES
	MOVI	index1,a4
	SRL	1,A0
	JRC	INDEX_USE_SET
	MOVI	index2,a4
INDEX_USE_SET
	CALLA	MAKE_ANNOUNCEMENT
	MOVE	@process_ptrs+020h,a4,L
	ADDI	WRESTLERNUM,A4
	MOVI	VERSUS_TAB,A2
	CALLA	MAKE_ANNOUNCEMENT
	MOVE	@process_ptrs+040h,a4,L
	JRZ	NO_MORE_OPPS
	MOVE	@process_ptrs+060h,a2,L
	JRNZ	JUST_VERSUS
	MOVI	133H,A0
	CALLA	ADD_VOICE
JUST_VERSUS
	ADDI	WRESTLERNUM,A4
	MOVI	WHICH_WRESTLER,A2
	CALLA	MAKE_ANNOUNCEMENT
	MOVE	@process_ptrs+060h,a4,L
	JRZ	NO_MORE_OPPS
	MOVI	133H,A0
	CALLA	ADD_VOICE
	ADDI	WRESTLERNUM,A4
	MOVI	WHICH_WRESTLER,A2
	CALLA	MAKE_ANNOUNCEMENT
NO_MORE_OPPS
	DIE

USE_BOTH_INDEXES
	MOVE	A3,A4
	CALLA	MAKE_ANNOUNCEMENT
	MOVE	A8,A4
	MOVI	VERSUS_TAB,A2
	CALLA	MAKE_ANNOUNCEMENT
	DIE

MAKE_ANNOUNCEMENT
	MOVE	*A4,A1
	SLL	4,A1
	ADD	A2,A1
	MOVE	*A1,A0
	CALLA	ADD_VOICE
	RETS

;Bret
;Razor
;Taker
;Yoko
;Shawn
;Bam Bam
;Doink
;spare
;Lex
WHICH_WRESTLER
	.WORD	131H
	.WORD	12DH
	.WORD	12FH
	.WORD	132H
	.WORD	12CH
	.WORD	12EH
	.WORD	12BH
	.WORD	0
	.WORD	130H

VERSUS_TAB
	.WORD	127h
	.WORD	123h
	.WORD	125h
	.WORD	128h
	.WORD	122h
	.WORD	124h
	.WORD	121h
	.WORD	0
	.WORD	126h

SQUARED_TAB
	.WORD	11Fh
	.WORD	11Bh
	.WORD	11Dh
	.WORD	120h
	.WORD	11Ah
	.WORD	11Ch
	.WORD	119h
	.WORD	0
	.WORD	11Eh

MATCHUP_TAB
	.WORD	117h
	.WORD	113h
	.WORD	115h
	.WORD	118h
	.WORD	112h
	.WORD	114h
	.WORD	111h
	.WORD	0
	.WORD	116h

VINCE_START_ROUND2_3
	MOVI	8,A0
	CALLA	RNDRNG0
	MOVE	A0,A1
	SLL	5,A1
	ADDI	RAND_START_2_3,A1
	MOVE	*A1+,A0
	CALLA	ADD_VOICE
	MOVE	*A1,A0
	JRZ	NO_TWO_STEP
	CALLA	ADD_VOICE
NO_TWO_STEP
	RETS

RAND_START_2_3
	.WORD	134H,0
	.WORD	135H,0
	.WORD	136H,0
	.WORD	138H,137H
	.WORD	138H,139H
	.WORD	13AH,0
	.WORD	13BH,0
	.WORD	2D9H,0
	.WORD	2DAH,0

;**************************************************************************
;*											      *
;* TABLES ARE SET UP AS FOLLOWS -								 *
;* 	WORD x(NUMBER OF TABLE ENTRIES -1), TABLE ENTRY SIZE			 *
;* LABEL												 *
;* 	WORD TABLE ENTRY 1									 *
;* 	...											 *
;* 	WORD TABLE ENTRY x									 *
;* 												 *
;* TABLES CAN HAVE MORE THAN ONE CALL PER ENTRY						 *
;* CALL EITHER ADD_TO_QUEUE OF ADD_IF_SILENT WITH TABLE ADDRESS IN A2	 *
;* CALL WITH A0 SET TO RANDOMNESS OF ACTUALLY MAKING A SOUND CALL		 *
;* A0 = 0 NO CHANCE, A0=1000 100% CHANCE							 *
;* IF CALLING A TABLE WITH EITHER 'GIVE CREDIT' OR					 *
;* 'VERY_IMPRESSIVE' IN IT, A5 MUST REFLECT THE ATTACKING WRESTLER NUMBER *
;*											      *
;**************************************************************************

RESET_VOICE_QUEUE
	MOVI	ANNOUNCE_QUEUE,A1
	MOVE	A1,@NEXT_ANN_QUEUE,L
	MOVE	A1,@CURRENT_ANN_QUEUE,L
	RETS

IF_SILENT_ADD_VOICE
	MMTM	SP,A1,A2
	MOVE	@NEXT_ANN_QUEUE,A1,L
	MOVE	@CURRENT_ANN_QUEUE,A2,L
	CMP	A1,A2
	JRNE	NO_ADD
	CALLR	WHO_IS_IT
	JRC	NOT_ANNOUNCER
	JRNZ	NO_ADD
NOT_ANNOUNCER
	MMFM	SP,A1,A2
ADD_VOICE
	PUSH	A1
	MOVE	@NEXT_ANN_QUEUE,A1,L

	CMPI	(triple_end-triple_sndtab)/32,A0
	JRGT	OUT_OF_RANGE_SOUND
	MOVE	A0,A0
	JRN	OUT_OF_RANGE_SOUND

;	;temp!
;	cmpi	9Eh,a0
;	jrne	#foo
;	LOCKUP
;#foo

	MOVE	A0,*A1+
	CMPI	EOF_ANNOUNCE_QUEUE,A1
	JRNE	NO_RESET_QUEUE
	MOVI	ANNOUNCE_QUEUE,A1
NO_RESET_QUEUE
	MOVE	A1,@NEXT_ANN_QUEUE,L
	PULL	A1
	CLR	A0
	MOVE	A0,A0
	RETS

OUT_OF_RANGE_SOUND
	PULL	a1
	.IF	DEBUG
	LOCKUP
	.ENDIF
	MOVI	-1,A0
	RETS

NO_ADD
	MMFM	SP,A1,A2
	MOVI	-1,A0
	RETS

 SUBR	ANNOUNCE_VOICE
	MOVE	@NEXT_ANN_QUEUE,A1,L
	MOVE	@CURRENT_ANN_QUEUE,A2,L
	CMP	A1,A2
	JREQ	NOTHING_TO_DO_NOW


;	move	@GAMSTATE,a0
;	subk	INAMODE,a0
;	jrnz	#no
;Check AMODE SOUND ON CMOS flag
;	ADJUST	ADJMUSIC
;	jrnz	NOTHING_TO_DO_NOW
;#no



	MOVE	*A2+,A0
	JRN	TIME_TO_DIE
	CMPI	EOF_ANNOUNCE_QUEUE,A2
	JRNE	NO_RESET_QUEUE2
	MOVI	ANNOUNCE_QUEUE,A2
NO_RESET_QUEUE2
	MOVE	A2,@CURRENT_ANN_QUEUE,L
	CMPI	0E0H,A0
	JRLT	DO_TRIPLE_SOUND
	CALLR	FIND_AND_KILL_ENDLESS
	CALLA	announcer_sound
	CALLA	PRCSLP
	JRUC	ANNOUNCE_VOICE

DO_TRIPLE_SOUND
	CALLR	FIND_AND_KILL_ENDLESS
	CALLA	triple_sound
	CALLA	PRCSLP
	JRUC	ANNOUNCE_VOICE

NOTHING_TO_DO_NOW
	SLOOP	1,ANNOUNCE_VOICE

TIME_TO_DIE
	CMPI	EOF_ANNOUNCE_QUEUE,A2
	JRNE	NO_RESET_QUEUE3
	MOVI	ANNOUNCE_QUEUE,A2
NO_RESET_QUEUE3
	MOVE	A2,@CURRENT_ANN_QUEUE,L
	SLOOP	1,ANNOUNCE_VOICE

*******************************************************************************

	bssx	which_table,32
	bssx	which_one_first,16

ADD_TO_QUEUE
	MOVI	-1,B3
	JRUC	IN_HERE
ADD_IF_SILENT
	CLR	B3
IN_HERE
	move	a2,@which_table,L

	MMTM	SP,A0,A1,A2,A3
	MOVE	*A2(-050H),A3
	JRZ	NO_RESET_REPEAT
	CLR	A3
	MOVE	A3,@REPEAT_STATE
NO_RESET_REPEAT
	MOVE	*A2(-040H),A3,L
	JRZ	NO_CROWD
	CALLA	DO_CROWD_ANYWAY
NO_CROWD
	MOVE	@REPEAT_STATE,A4
	JRZ	NO_DO_REPEAT
	MOVI	REPEAT_MODE,A0
	MOVK	010H,A3
	JRUC	DO_REPEAT
NO_DO_REPEAT
	CALLA	RNDPER
	JRLS	NO_MORE
	MOVE	*A2(-010H),A3
	MOVE	*A2(-020H),A0
	CALLA	RNDRNG0
	move	a0,@which_one_first
	MPYU	A3,A0
	ADD	A2,A1
ADD_AGAIN
	MOVE	*A1+,A0
DO_REPEAT
	CMPI	END_GAME_STUFF,A0
	JREQ	DO_END_STUFF
	CMPI	GIVE_CREDIT,A0
	JREQ	SPECIAL_SET_UP
	CMPI	VERY_IMPRESSIVE,A0
	JREQ	SPECIAL_SET_UP
	CMPI	IT_DOESNT_LOOK_GOOD,A0
	JREQ	SPECIAL_SET_UP
	CMPI	R_IMPRESSIVE_MOVE,A0
	JREQ	SPECIAL_SET_UP
	CMPI	GIDDUP_MODE,A0
	JREQ	SPECIAL_SET_UP
	CMPI	REPEAT_MODE,A0
	JRNE	NO_SPECIAL_SET_UP
SPECIAL_SET_UP
	CALLR	SET_UP_PERSONAL_CALL
	CALLR	ARE_WE_REPEATING
	JRC	SET_NO_MORE
	JRUC	DO_THE_SPEECH
NO_SPECIAL_SET_UP
	CALLR	ARE_WE_REPEATING
	JRNC	DO_THE_SPEECH
NO_SPECIAL_END_STUFF
	SUBI	010H,A1
	ADD	A3,A1
	JRUC	ADD_AGAIN

DO_THE_SPEECH
	CALLR	ADD_SPEECH_TO_LIST
	MOVE	B3,B3
	JRNZ	ADD_ANYWAY
**************************************
	.IF DEBUG
	MOVE	A0,A0
	JRNN	OKAY
	LOCKUP
OKAY
	.ENDIF
**************************************
	CALLA	IF_SILENT_ADD_VOICE
	JRUC	SPEECH_ADDED
ADD_ANYWAY
	CALLA	ADD_VOICE
SPEECH_ADDED
	JRN	NO_MORE
	SUBI	010H,A3
	JRZ	NO_MORE
ADD_AGAIN3
	MOVE	*A1+,A0
	JRZ	NO_MORE
	CALLA	ADD_VOICE
	SUBI	010H,A3
	JRNZ	ADD_AGAIN3
NO_MORE
	MMFM	SP,A0,A1,A2,A3
	RETS
SET_NO_MORE
	MOVI	-1,A0
	MMFM	SP,A0,A1,A2,A3
	RETS


ARE_WE_REPEATING
	PUSH	A1,A2,A3
	MOVI	LAST_VOICE,A1
	MOVK	4,A3
NEXT_SPEECH
	MOVE	*A1+,A2
	CMP	A0,A2
	JREQ	YES_WE_ARE
	DSJS	A3,NEXT_SPEECH
	PULL	A1,A2,A3
	CLRC
	RETS
YES_WE_ARE
	PULL	A1,A2,A3
	SETC
	RETS

ADD_SPEECH_TO_LIST
	PUSH	A1
	MOVE	@WHICH_LAST_VOICE,A1,L
	ADDK	16,A1
	CMPI	WHICH_LAST_VOICE,A1
	JRNE	NO_RESET_SPEECH_REPEAT
	MOVI	LAST_VOICE,A1
NO_RESET_SPEECH_REPEAT
	MOVE	A1,@WHICH_LAST_VOICE,L
	MOVE	A0,*A1
	PULL	A1
	RETS

CLEAR_SPEECH_REPEAT
	MOVI	LAST_VOICE,A1
	MOVE	A1,@WHICH_LAST_VOICE,L
	CLR	A0
	MOVE	A0,*A1+,L
	MOVE	A0,*A1+,L
	RETS

DO_CROWD_ANYWAY
	MMTM	SP,A0,A1,A3,A5
	MOVE	*A3(-010H),A0
	CALLA	RNDRNG0
	SLL	6,A0
	ADD	A3,A0
	MOVE	A0,A4
;	MOVI	CROWD_SOUND_PID,A0
;	MOVI	-1,A1
;	CALLA	EXISTP
	move	@crowd_dummy_exists,a0
	JRNZ	NO_CROWD_ALREADY_GOING
	MOVE	A4,A0
	MOVE	*A0,A3
	CALLA	SNDSND
	MOVE	*A0(010H),A9
	CREATE	CROWD_SOUND_PID,CROWD_DUMMY
NO_CROWD_ALREADY_GOING
	MOVE	A4,A0
	MOVE	*A0(020H),A3
	BTST	B_RANDOM,A3
	JRZ	NO_NEED_FOR_A4
	MOVE	*A0(030H),A4
NO_NEED_FOR_A4
	CALLA	crowd_cheer
	MMFM	SP,A0,A1,A3,A5
	RETS

CROWD_DUMMY
	movk	1,a0
	move	a0,@crowd_dummy_exists
	MOVE	A9,A0
	CALLA	PRCSLP
	clr	a0
	move	a0,@crowd_dummy_exists
	DIE

SET_UP_PERSONAL_CALL
	PUSH	A1
	SLL	4,A5
	MOVI	GIVE_CREDIT_TO,A1
	INC	A0
	JRZ	MADE_RIGHT_TABLE
	MOVI	VERY_IMPRESSIVE_MOVE,A1
	INC	A0
	JRZ	MADE_RIGHT_TABLE
	MOVI	IT_DOESNT_LOOK_GOOD_FOR,A1
	INC	A0
	INC	A0
	JRZ	MADE_RIGHT_TABLE
	MOVI	VERY_IMPRESSIVE_MOVE_R,A1
	INC	A0
	JRZ	MADE_RIGHT_TABLE
	MOVI	GIDDUP_ALL,A1
	INC	A0
	JRZ	MADE_RIGHT_TABLE
	MOVE	@REPEAT_STATE,A0
	JRNZ	ALREADY_IN_REPEAT_MODE
	MOVI	80,A9
	CREATE	REPEAT_MODE_PID,REPEAT_DUMMY
	MOVK	4,A0
ALREADY_IN_REPEAT_MODE
	DEC	A0
	MOVE	A0,@REPEAT_STATE
	SLL	4,A0
	SLL	2,A5
	MOVI	ASCENDING_TABLE,A1
	ADD	A0,A5
	CALLR	SET_DUMMY_SLEEP
MADE_RIGHT_TABLE
	ADD	A5,A1
	MOVE	*A1,A0
	PULL	A1
	RETS

SET_DUMMY_SLEEP
	PUSH	A1
	move	@repeat_mode_exists,a0
;	MOVI	REPEAT_MODE_PID,A0
;	MOVI	-1,A1
;	CALLA	EXISTP
	JRZ	NO_DUMMY_TO_SET
	MOVI	80,A1
	MOVE	A1,*A0(PTIME)
NO_DUMMY_TO_SET
	PULL	A1
	RETS

REPEAT_DUMMY
	movk	1,a14
	move	a14,@repeat_mode_exists
	MOVE	A9,A0
	CALLA	PRCSLP
	CLR	A0
	MOVE	A0,@REPEAT_STATE
	clr	a14
	move	a14,@repeat_mode_exists
	DIE

DO_END_STUFF
	PUSH	A1
	MOVI	NUM_WRES,A1
CHECK_NEXT
	PUSH	A1
	DEC	A1
	CALLA	get_health
	PULL	A1
	CMPI	40,A0
	JRLT	YES_WE_NEAR_END
	DSJS	A1,CHECK_NEXT
	PULL	A1
	JRUC	NO_SPECIAL_END_STUFF
YES_WE_NEAR_END
	PULL	A1
	MOVI	SPECIAL_LAST_STUFF,A2
	MOVE	*A2(-010H),A3
	MOVE	*A2(-020H),A0
	CALLA	RNDRNG0
	MPYU	A3,A0
	ADD	A2,A1
	MOVE	*A1+,A0
	CALLR	ARE_WE_REPEATING
	JRC	SET_NO_MORE
	CLR	A4
	MOVE	A4,@REPEAT_STATE
	CMPI	IT_DOESNT_LOOK_GOOD,A0
	JREQ	SPECIAL_SET_UP
	JRUC	DO_THE_SPEECH

ASCENDING_TABLE
	.WORD	102H,101H,100H,0FFH
	.WORD	0ECH,0EBH,0EAH,0E9H
	.WORD	0F6H,0F5H,0F4H,0F3H
	.WORD	106H,105H,104H,103H
	.WORD	0E8H,0E7H,0E6H,0E5H
	.WORD	0FAH,0F9H,0F8H,0F7H
	.WORD	0E4H,0E3H,0E2H,0E1H
	.WORD	0,0,0,0
	.WORD	0FEH,0FDH,0FCH,0FBH

GIDDUP_ALL
	.WORD	L_GIDDUP_HART
	.WORD	L_GIDDUP_RAZOR
	.WORD	L_GIDDUP_UNDER
	.WORD	L_GIDDUP_YOKO
	.WORD	L_GIDDUP_SHAWN
	.WORD	L_GIDDUP_BAM
	.WORD	L_GIDDUP_DOINK
	.WORD	0
	.WORD	L_GIDDUP_LUGER

VERY_IMPRESSIVE_MOVE
	.WORD	VERY_IMP_HART
	.WORD	VERY_IMP_RAZOR
	.WORD	VERY_IMP_UNDER
	.WORD	VERY_IMP_YOKO
	.WORD	VERY_IMP_SHAWN
	.WORD	VERY_IMP_BAM
	.WORD	VERY_IMP_DOINK
	.WORD	0
	.WORD	VERY_IMP_LUGER

VERY_IMPRESSIVE_MOVE_R
	.WORD	R_MOVE_BY_HITMAN
	.WORD	R_MOVE_BY_RAZOR
	.WORD	R_MOVE_BY_UNDER
	.WORD	R_MOVE_BY_YOKO
	.WORD	R_MOVE_BY_SHAWN
	.WORD	R_MOVE_BY_BAM
	.WORD	R_MOVE_BY_DOINK
	.WORD	0
	.WORD	R_MOVE_BY_LEX

IT_DOESNT_LOOK_GOOD_FOR
	.WORD	IT_DOESNT_LOOK_BRET
	.WORD	IT_DOESNT_LOOK_RAZOR
	.WORD	IT_DOESNT_LOOK_UNDER
	.WORD	IT_DOESNT_LOOK_YOKO
	.WORD	IT_DOESNT_LOOK_SHAWN
	.WORD	IT_DOESNT_LOOK_BAMBAM
	.WORD	IT_DOESNT_LOOK_DOINK
	.WORD	0
	.WORD	IT_DOESNT_LOOK_LEX

GIVE_CREDIT_TO
	.WORD	GIVE_CRED_HART
	.WORD	GIVE_CRED_RAZOR
	.WORD	GIVE_CRED_UNDER
	.WORD	GIVE_CRED_YOKO
	.WORD	GIVE_CRED_SHAWN
	.WORD	GIVE_CRED_BAM
	.WORD	GIVE_CRED_DOINK
	.WORD	0
	.WORD	GIVE_CRED_LUGER

	.WORD	-1
	.LONG	CRESCENDO_TABLE
	.WORD	12,010H
CLIMB_ROPES
	.WORD	GOING_TO_TOP_ROPE
	.WORD	GOING_TO_TOP
	.WORD	HERE_IT_COMES
	.WORD	AND_1
	.WORD	AND_2
	.WORD	AND_3
	.WORD	LOOK_AT_THIS
	.WORD	HERES_THE_SETUP
	.WORD   R_OH_YEAH
	.WORD	WHATS_THIS
	.WORD	R_LOOK_AT_THIS
	.WORD	L_WHO_DOES_HE_THINK
	.WORD	L_GOING_FOR_ROPE

	.WORD	GOING_TO_TOP_ROPE
	.WORD	GOING_TO_TOP
	.WORD	HERE_IT_COMES
	.WORD	AND_1

	.WORD	0
	.LONG	ROPES_CHEER
	.WORD	6,020H
JUMP_ROPES
	.WORD	KABOOM_OH,KABOOM
;	.WORD	REPEAT_MODE,0
	.WORD	OOOH,0
	.WORD	BOOMSHAKALAKA,0
	.WORD	OFF_THE_TOP,0
	.WORD	LOOK_OUT,0
	.WORD	R_NICELY_DONE,0
	.WORD	I_WOULD_RECEIVE_THAT,0

	.WORD	KABOOM_OH,KABOOM
	.WORD	OOOH,0
	.WORD	BOOMSHAKALAKA,0
	.WORD	OFF_THE_TOP,0

CALL_MISSES
	CREATE	SOUND_PID,PROC_MISSES
	RETS

PROC_MISSES
	SLEEP	5
	MOVI	MISSES,A2
	MOVI	350,A0
	CALLR	ADD_IF_SILENT
	DIE

	.WORD	-1
	.LONG	CROWD_FAIL
	.WORD	17,010H
MISSES
	.WORD	A_MISS
	.WORD	NO_V
	.WORD	AND_MISSES
	.WORD	ALMOST
	.WORD	FORGET_ABOUT_IT
	.WORD	R_THAT_WAS_DUMB
	.WORD	R_THAT_WAS_UGLY
	.WORD	AND_OH
	.WORD	REJECTED
	.WORD	R_THATLL_COST_HIM
	.WORD	AND_OH
	.WORD	FORGET_ABOUT_IT
	.WORD	NOT_A_GOOD_IDEA
	.WORD	WHAT_WAS_HE_THINKING
	.WORD	L_WHAT_A_JERK
	.WORD	L_DONT_BOTHER
	.WORD	L_NOT_A_GOOD_IDEA
	.WORD	L_WHAT_WAS_HE_THINKING

	.WORD	A_MISS
	.WORD	AND_MISSES
	.WORD	ALMOST
	.WORD	R_REJECTED

CALL_SPECIAL_MOVE
	MOVE	*A13(WRESTLERNUM),A9
	CREATE	SOUND_PID,PROC_SPECIAL_MOVE
	RETS

PROC_SPECIAL_MOVE
	SLEEP	10
	MOVE	A9,A5
	MOVI	SPECIAL_MOVE,A2
	MOVI	550,A0
	CALLR	ADD_IF_SILENT
	DIE

	.WORD	0
	.LONG	CROWD_SPECIAL
	.WORD	31,020H
SPECIAL_MOVE
	.WORD	END_GAME_STUFF,0
	.WORD	LISTEN_TO_THE_CROWD,L_CHEER_FOR_ME
	.WORD	REPEAT_MODE,0
	.WORD	DID_YOU_SEE_THAT,0
	.WORD	VERY_IMPRESSIVE,0
	.WORD	THATS_GOTTA_HURT,0
	.WORD	NICELY_DONE,0
	.WORD	IVE_NEVER_SEEN_THAT,0
	.WORD	OH_MY,0
	.WORD	OH_MY_GOODNESS_0,0
	.WORD	DID_YOU_SEE_THAT,R_IVE_NEVER_SEEN
	.WORD	DID_YOU_SEE_THAT,R_OH_YEAH
	.WORD	WOW_0,0
	.WORD	UNBEELEVABLE_0,0
	.WORD	LOOK_AT_THIS,L_I_WOULDNT_BELIEVE_IT
	.WORD	R_DID_YOU_SEE_THAT,UNBEELEVABLE_0
	.WORD	WHAT_A_TURN_OF_EVENTS,R_INCREDIBLE
	.WORD	R_TASTE_OF_HIS_OWN,0
	.WORD	WHAT_A_BEATING,R_NICELY_DONE
	.WORD	I_WOULD_RECEIVE_THAT,0
	.WORD	R_LOOK_AT_THIS,CAN_YOU_BELIEVE_THAT
	.WORD	CAN_ANYBODY_STOP_HIM,R_INCREDIBLE
	.WORD	R_THATS_GOTTA_HURT,YES_V
	.WORD	WHAT_A_SLAM,R_IVE_NEVER_SEEN
	.WORD	I_CANT_WATCH_THIS,L_I_DIDNT_SEE
	.WORD	CAN_ANYBODY_STOP_HIM,0
	.WORD	R_I_THINK_HE_BROKE_IT,0
	.WORD	R_NOBODY_GETS_UP,0
	.WORD	LISTEN_TO_THE_CROWD,L_QUIET
	.WORD	L_WHAT_KIND_OF_CHEAP,0
	.WORD	L_NO_ONE_CAN_TOUCH,0
	.WORD	WHAT_POWER,0

	.WORD	LISTEN_TO_THE_CROWD,0
	.WORD	DID_YOU_SEE_THAT,0
	.WORD	THATS_GOTTA_HURT,0
	.WORD	NICELY_DONE,0

CALL_DROP_KICK
	MOVE	*A10(WRESTLERNUM),A9
	CREATE	SOUND_PID,PROC_DROP_KICK
	RETS

PROC_DROP_KICK
	SLEEP	15
	MOVE	A9,A5
	MOVI	DROP_KICK,A2
	MOVI	400,A0
	CALLR	ADD_IF_SILENT
	DIE

	.WORD	0
	.LONG	CROWD_CHEER
	.WORD	14,010H
DROP_KICK
	.WORD	LISTEN_TO_THE_CROWD
	.WORD	REPEAT_MODE
	.WORD	NICELY_DONE
;	.WORD	BOTH_MEN_DOWN
	.WORD	OH_MY
;	.WORD	OH_THAT_HURTS_0
	.WORD	WITH_AUTHORITY
	.WORD	KABOOM
	.WORD	BOOMSHAKALAKA
	.WORD	R_TASTE_OF_HIS_OWN
	.WORD	VERY_IMPRESSIVE
;	.WORD	ITS_PAND_OUT_THERE
;	.WORD	WHAT_SPEED
	.WORD	TO_THE_FACE
	.WORD	AWESOME
	.WORD	GOODNIGHT
	.WORD	WHAT_A_BLOW
	.WORD	L_NO_ONE_CAN_TOUCH
	.WORD	L_SOMETHING

	.WORD	LISTEN_TO_THE_CROWD
	.WORD	NICELY_DONE
	.WORD	GOODNIGHT
;	.WORD	BOTH_MEN_DOWN
	.WORD	OH_MY

CALL_FACE_HIT
	MOVE	*A10(WRESTLERNUM),A9
	CREATE	SOUND_PID,PROC_FACE_HIT
	RETS

PROC_FACE_HIT
	SLEEP	8
	MOVE	A9,A5
	MOVI	FACE_HIT,A2
	MOVI	200,A0
	CALLR	ADD_IF_SILENT
	DIE

	.WORD	0
	.LONG	CROWD_ORDINARY
	.WORD	7,010H
FACE_HIT
	.WORD	TO_THE_FACE
	.WORD	R_WHAT_SPEED
	.WORD	TO_THE_FACE
;	.WORD	WHAT_POWER
	.WORD	TO_THE_FACE
	.WORD	WHAT_A_BLOW
	.WORD	HELLO
	.WORD	R_GOODNIGHT

	.WORD	TO_THE_FACE
;	.WORD	WHAT_SPEED
	.WORD	R_WHAT_POWER
	.WORD	OH_MY
	.WORD	HELLO

CALL_MID_HIT
	MOVE	*A10(WRESTLERNUM),A9
	CREATE	SOUND_PID,PROC_MID_HIT
	RETS

PROC_MID_HIT
	SLEEP	8
	MOVE	A9,A5
	MOVI	MID_HIT,A2
	MOVI	200,A0
	CALLR	ADD_IF_SILENT
	DIE

	.WORD	0
	.LONG	CROWD_ORDINARY
	.WORD	7,010H
MID_HIT
	.WORD	TO_THE_MIDSECTION
;	.WORD	WHAT_SPEED
	.WORD	TO_THE_MIDSECTION
	.WORD	R_WHAT_POWER
	.WORD	TO_THE_MIDSECTION
	.WORD	WHAT_SKILL
	.WORD	WHAT_A_BLOW
	.WORD	R_HELLO
	.WORD	L_HIT_HIM

	.WORD	TO_THE_MIDSECTION
;	.WORD	WHAT_SPEED
	.WORD	R_WHAT_POWER
	.WORD	OH_MY
	.WORD	L_HIT_HIM

CALL_AVERAGE_MOVE
	MOVE	*A10(WRESTLERNUM),A9
	CREATE	SOUND_PID,PROC_AVERAGE_MOVE
	RETS

CALL_ANI_AVERAGE_MOVE
	MOVE	*A13(WRESTLERNUM),A9
	CREATE	SOUND_PID,PROC_AVERAGE_MOVE
	RETS

PROC_AVERAGE_MOVE
	SLEEP	10
	MOVE	A9,A5
	MOVI	AVERAGE_MOVE,A2
	MOVI	500,A0
	CALLR	ADD_IF_SILENT
	DIE

	.WORD	0
	.LONG	CROWD_CHEER
	.WORD	17,010H
AVERAGE_MOVE
	.WORD	END_GAME_STUFF
;	.WORD	OH_THAT_HURTS_1
	.WORD	REPEAT_MODE
	.WORD	OH_0
	.WORD	WITH_AUTHORITY
	.WORD	NICELY_DONE
	.WORD	NICE_EXECUTION
	.WORD	OOOH_0
;	.WORD	OH_MY_GOODNESS_2
	.WORD	R_RIGHT_TO_THE_KISSER
	.WORD	ITS_PAND_IN_THE_RING
;	.WORD	WHAT_POWER
	.WORD	WHAT_SKILL
	.WORD	R_WHAT_AGILITY
	.WORD	R_AWESOME
	.WORD	R_HELLO
	.WORD	WHAT_A_BLOW
	.WORD	GOODNIGHT
	.WORD	MOST_IMPRESSIVE
	.WORD	AWESOME
	.WORD	R_IMPRESSIVE_MOVE

;	.WORD	OH_THAT_HURTS_1
	.WORD	AWESOME
	.WORD	OH_0
	.WORD	WITH_AUTHORITY
	.WORD	NICELY_DONE

DO_REVERSAL
	CALLA	FIND_AND_KILL_ENDLESS
	push	a8
	MOVE	*A8(WRESTLERNUM),A5

	;make sure wrestlernum is valid!
	jrn	#bad_a5
	cmpi	7,a5
	jreq	#bad_a5
	cmpi	8,a5
	jrle	#ok_a5
#bad_a5
	.if DEBUG
	LOCKUP
	.endif
	jruc	#dr_done
#ok_a5

	MOVI	REVERSAL,A2
	MOVI	500,A0
	CALLR	ADD_IF_SILENT
	pull	a8
#dr_done
	RETS

	.WORD	0
	.LONG	CROWD_CHEER
	.WORD	14,010H
REVERSAL
	.WORD	NO_WAIT_A_MINUTE
	.WORD	NICE_ESCAPE
	.WORD	WOW_1
	.WORD	LOOK_OUT
	.WORD	FORGET_ABOUT_IT
	.WORD	A_QUICK_REVERSAL
	.WORD	R_THAT_WAS_DUMB
	.WORD	WHATS_THIS
	.WORD	R_NO_WAIT_A_MINUTE
;	.WORD	WHAT
	.WORD	WHAT_THE
	.WORD	MOST_IMPRESSIVE
	.WORD	YES_V
	.WORD	WAIT_A_MINUTE
	.WORD	L_WHO_DOES_HE_THINK
	.WORD	L_PULLED_IT_OFF

	.WORD	NO_WAIT_A_MINUTE
	.WORD	NICE_ESCAPE
	.WORD	WOW_1
	.WORD	LOOK_OUT

CALL_MISS_YOKO
	CREATE	SOUND_PID,PROC_MISS_YOKO
	RETS

PROC_MISS_YOKO
	SLEEP	10
	MOVI	MISS_YOKO,A2
	MOVI	400,A0
	CALLR	ADD_IF_SILENT
	DIE

	.WORD	-1
	.LONG	0
	.WORD	6,010H
MISS_YOKO
	.WORD	FORGET_ABOUT_IT
	.WORD	R_THAT_WAS_DUMB
	.WORD	NOT_A_GOOD_IDEA
	.WORD	WHAT_WAS_HE_THINKING
	.WORD	AND_OH
	.WORD	REJECTED
	.WORD	L_AND_STAY_DOWN

	.WORD	FORGET_ABOUT_IT
	.WORD	R_THAT_WAS_DUMB
	.WORD	NOT_A_GOOD_IDEA
	.WORD	WHAT_WAS_HE_THINKING

	.WORD	-1
	.LONG	CROWD_THROWN
	.WORD	12,010H
THROWN_OUT
	.WORD	HEAVES_HIM
	.WORD	VERY_IMPRESSIVE
	.WORD	NICE_EXECUTION
	.WORD	UNBEELEVABLE_1
	.WORD	IVE_NEVER_SEEN_THAT
;	.WORD	OH_THAT_HURTS_0
	.WORD	WITH_AUTHORITY
	.WORD	WHAT_A_TURN_OF_EVENTS
;	.WORD	WHAT_POWER
	.WORD	R_WHAT_SPEED
	.WORD	WHAT_SKILL
	.WORD	R_WHAT_AGILITY
	.WORD	MAGNIFICENT
	.WORD	JUST_AWESOME
	.WORD	L_HEAVES

	.WORD	HEAVES_HIM
	.WORD	NICE_EXECUTION
	.WORD	UNBEELEVABLE_1
	.WORD	IVE_NEVER_SEEN_THAT

CALL_THROWN_OUT
	MOVE	*A13(WRESTLERNUM),A9
	CREATE	SOUND_PID,PROC_THROWN_OUT
	RETS

PROC_THROWN_OUT
	SLEEP	10
	MOVE	A9,A5
	MOVI	THROWN_OUT,A2
	MOVI	500,A0
	CALLR	ADD_IF_SILENT
	DIE

	.WORD	-1
	.LONG	CROWD_THROWN
	.WORD	12,010H
OTHER_AVERAGE
	.WORD	VERY_IMPRESSIVE
	.WORD	NICE_EXECUTION
	.WORD	UNBEELEVABLE_1
	.WORD	IVE_NEVER_SEEN_THAT
;	.WORD	OH_THAT_HURTS_0
	.WORD	WITH_AUTHORITY
	.WORD	WHAT_A_TURN_OF_EVENTS
;	.WORD	WHAT_POWER
	.WORD	R_WHAT_SPEED
	.WORD	WHAT_SKILL
	.WORD	R_WHAT_AGILITY
	.WORD	MAGNIFICENT
	.WORD	JUST_AWESOME
	.WORD	L_TEETH_POP
	.WORD	L_SOMETHING

	.WORD	MAGNIFICENT
	.WORD	NICE_EXECUTION
	.WORD	UNBEELEVABLE_1
	.WORD	IVE_NEVER_SEEN_THAT

CALL_OTHER_AVERAGE
	MOVE	*A13(WRESTLERNUM),A9
	CREATE	SOUND_PID,PROC_OTHER_AVERAGE
	RETS

PROC_OTHER_AVERAGE
	SLEEP	10
	MOVE	A9,A5
	MOVI	OTHER_AVERAGE,A2
	MOVI	500,A0
	CALLR	ADD_IF_SILENT
	DIE

CALL_NASTY_MOVE
	MOVE	*A13(WRESTLERNUM),A9
	CREATE	SOUND_PID,PROC_NASTY_MOVE
	RETS

PROC_NASTY_MOVE
	SLEEP	10
	MOVE	A9,A5
	MOVI	NASTY_MOVE,A2
	MOVI	500,A0
	CALLR	ADD_IF_SILENT
	DIE

	.WORD	-1
	.LONG	CROWD_FAIL
	.WORD	17,020H
NASTY_MOVE
	.WORD	R_WHATS_GOING_ON,IS_THAT_LEGAL
	.WORD	HE_CANT_DO_THAT,R_SOMEONE_CALL_SECURITY
	.WORD	NOW_THAT_WAS_CHEAP,R_I_CANT_WATCH
	.WORD	THATS_NOT_VERY_FAIR,L_EXACT_WHAT_HE_DESERVED
	.WORD	SOMEONE_CALL_SECURITY,0
	.WORD	THAT_WASNT_VERY_NICE,L_SURE_IT_WAS
	.WORD	I_CANT_WATCH_THIS,R_OH_VICIOUS
	.WORD	R_THATS_GOTTA_HURT,THATS_NOT_VERY_FAIR
	.WORD	SHOCKING,0
	.WORD	L_WHAT_A_JERK,0
	.WORD	L_LISTEN_TO_THE_CROWD,L_WHAT_MORONS
	.WORD	L_THAT_WAS_CHEAP,0
	.WORD	L_TEETH_POP,0
	.WORD	LISTEN_TO_THE_CROWD,L_CHEER_FOR_ME
	.WORD	LISTEN_TO_THE_CROWD,L_QUIET
	.WORD	L_WHAT_MORONS,0
	.WORD	L_AW_CMON_2,IS_THAT_LEGAL
	.WORD	L_WHO_DOES_HE_THINK,0

	.WORD	R_WHATS_GOING_ON,IS_THAT_LEGAL
	.WORD	HE_CANT_DO_THAT,R_SOMEONE_CALL_SECURITY
	.WORD	NOW_THAT_WAS_CHEAP,R_I_CANT_WATCH
	.WORD	THATS_NOT_VERY_FAIR,0

CALL_SETUP
	MOVE	*A13(WRESTLERNUM),A9
	CREATE	SOUND_PID,PROC_SETUP_MOVE
	RETS

PROC_SETUP_MOVE
	SLEEP	5
	MOVE	A9,A5
	MOVI	SETUP_MOVE,A2
	MOVI	500,A0
	CALLR	ADD_IF_SILENT
	DIE

	.WORD	0
	.LONG	SETUP_TABLE
	.WORD	15,010H
SETUP_MOVE
	.WORD	END_GAME_STUFF
	.WORD	REPEAT_MODE
	.WORD	HERES_THE_SETUP
	.WORD	AND_1
	.WORD	HERE_IT_COMES
	.WORD	AND_2
	.WORD	LOOK_AT_THIS
	.WORD	OOOH
	.WORD	R_LOOK_AT_THIS
	.WORD	WHATS_THIS
	.WORD	ITS_PAND_IN_THE_RING
	.WORD	R_THIS_COULD_BE_TROUBLE
	.WORD	R_DIG_IT
	.WORD	L_WHATS_HE_UP_TO
	.WORD	L_WHO_DOES_HE_THINK
;	.WORD	L_THE_SUSPENSE
	.WORD	HES_GOT_HIM

	.WORD	HERES_THE_SETUP
	.WORD	AND_1
	.WORD	HERE_IT_COMES
	.WORD	AND_2
	.WORD	LOOK_AT_THIS

	.WORD	6,010H
SPECIAL_LAST_STUFF
	.WORD	THIS_COULD_BE_IT
	.WORD	R_THIS_COULD_BE_IT
	.WORD	YOU_CANT_GET_ANY_CLOSER
	.WORD	WHAT_KEEPING_THEM_UP
	.WORD	LOOKS_LIKE_ITS_OVER
	.WORD	R_GAME_OVER
	.WORD	L_NO_ONE_CAN_TOUCH
;	.WORD	L_THE_SUSPENSE

	.WORD	THIS_COULD_BE_IT
	.WORD	R_THIS_COULD_BE_IT
	.WORD	YOU_CANT_GET_ANY_CLOSER
	.WORD	WHAT_KEEPING_THEM_UP

******************************************************************************

	.ref	match_winner

* >a0 = winning team (0 or 1)

 SUBR	CALL_MATCH_OVER

	movk	1,a8
	sll	a0,a8		;turn winning team # into a match_winner
	move	@PSTATUS,a9
	CREATE	SOUND_PID,PROC_MATCH_OVER
	RETS


 SUBRP	PROC_MATCH_OVER

	SLEEPK	5

	;did a drone lose?
	xor	a8,a9
	jrz	#drn_l

	movi	MATCH_OVER,A2
	jruc	#cont
#drn_l	movi	MATCH_OVER_DL,A2
#cont	move	*a10(WRESTLERNUM),a5
	MOVI	200,A0
	CALLA	RNDPER
	JRHI	WRESTLER_SPEECH

	MOVE	*A10(PLYRNUM),A0
	SLL	4,A0
	ADDI	p1winstreak,A0
	MOVE	*A0,A0
	CMPI	4,A0
	JRLT	NO_SPECIAL_FOR_OVER_4_WINS

	MOVI	200,A0
	CALLA	RNDPER
	JRHI	SPECIAL_FOR_OVER_4_WINS
NO_SPECIAL_FOR_OVER_4_WINS

	movi	1000,A0
	callr	ADD_TO_QUEUE
	DIE

SPECIAL_FOR_OVER_4_WINS
	MOVI	CAN_ANYBODY_STOP_HIM,A2
	MOVI	500,A0
	CALLA	RNDPER
	JRLO	SPECIAL_DONE
	MOVI	L_NO_ONE_CAN_TOUCH,A2
SPECIAL_DONE
	MOVE	A2,A0
	CALLA	ADD_VOICE
	DIE



;Use this table if the loser is a player.  Lawlor cheers/Vince gripes
	.word	-1
	.long	0
	.word	6,010H
MATCH_OVER
	.word	TOTAL_DISASTER
	.word	TOTAL_DEBUNK
	.word	L_HE_DID_IT
	.word	L_PULLED_IT_OFF
	.word	L_EXACT_WHAT_HE_DESERVED
	.WORD	GOOD_NIGHT_2
	.WORD	L_BACK_TO_SANDBOX

	.word	TOTAL_DEBUNK
	.word	L_HE_DID_IT
	.word	L_PULLED_IT_OFF
	.word	L_EXACT_WHAT_HE_DESERVED

;Use this table if the loser is a drone.  Vince cheers/Lawlor gripes
	.word	-1
	.long	0
	.word	3,010H
MATCH_OVER_DL
	.word	GIVE_CREDIT
	.word	UNBEELEVABLE_0
	.word	L_WHAT_A_RIPOFF
	.word	L_WHAT_A_SCAM


	.word	GIVE_CREDIT
	.word	UNBEELEVABLE_0
	.word	L_WHAT_A_RIPOFF
	.word	L_WHAT_A_SCAM

******************************************************************************

WRESTLER_SPEECH
	SLL	5,A5
	ADDI	WHICH_WRESTLER_TALKS,A5
	MOVE	*A5,A2,L
	MOVI	1000,A0
	CALLR	ADD_TO_QUEUE
	DIE

WHICH_WRESTLER_TALKS
	.LONG	HART_FINISHES
	.LONG	RAZOR_FINISHES
	.LONG	UNDERTAKER_FINISHES
	.LONG	YOKO_FINISHES
	.LONG	SHAWN_FINISHES
	.LONG	BAM_FINISHES
	.LONG	DOINK_FINISHES
	.LONG	0
	.LONG	LUGER_FINISHES

	.LONG	0
	.WORD	0,010H
HART_FINISHES
	.WORD	238H

	.LONG	0
	.WORD	0,010H
RAZOR_FINISHES
	.WORD	RAZOR_RIGHT_GUY

	.LONG	0
	.WORD	0,010H
UNDERTAKER_FINISHES
	.WORD	0

	.LONG	0
	.WORD	0,010H
YOKO_FINISHES
	.WORD	0

	.LONG	0
	.WORD	1,010H
SHAWN_FINISHES
	.WORD	SHAWN_LUCKY_YOU
	.WORD	SHAWN_WRESTLER_90

	.LONG	0
	.WORD	2,010H
BAM_FINISHES
	.WORD	BAM_BEAST_FROM_EAST
	.WORD	BAM_BAM_YEAH
	.WORD	BAM_GET_OUT

	.LONG	0
	.WORD	0,010H
DOINK_FINISHES
	.WORD	DOINK_LAUGH_1

	.LONG	0
	.WORD	0,010H
LUGER_FINISHES
	.word	1f3h
	.WORD	0

 SUBR	END_MATCH_SPEECH

;	MOVI	IT_DOESNT_LOOK_GOOD,A0
;	MOVE	*A13(WRESTLERNUM),A5
;	CALLR	SET_UP_PERSONAL_CALL
;	CALLR	ADD_VOICE

	CLR	A9
	CREATE	PIN_HIM_PID,PIN_HIM_PROC
	RETS

PIN_HIM_PROC
	movi	150,a0
	calla	RNDPER
	jals	SUCIDE

	movk	8,a11
#lp
	movk	3,a0
	CALLA	RNDRNG0
	MOVE	A0,A1
	SLL	4,A1
	ADDI	WHICH_PIN_HIM,A1
	MOVE	*A1,A0
	CMP	A0,A9
	JRNE	NO_NEED_TO_DO_NEXT_ONE
	MOVE	*A1(010H),A0
NO_NEED_TO_DO_NEXT_ONE
	MOVE	A0,A9
	CALLA	triple_sound
	CLR	A0
	MOVX	A14,A0
	subk	20,a0
	CALLA	PRCSLP
	dsj	a11,#lp

	DIE

;	JRUC	PIN_HIM_PROC

WHICH_PIN_HIM
	.WORD	0D3H,0D4H,0D5H,0d3h,0D4H

 SUBR    KILL_PIN_HIM
	MOVI	PIN_HIM_PID,A0
	CLR	A1
	NOT	A1
	CALLA	KILALL
	RETS

*****************************************************************
* INDIVIDUAL SOUND ROUTINES

HIT_THE_MAT
;	;if I'm outside the ring, do the concrete sound instead
;	;;;No, don't.  It doesn't sound right.  Wrong call, maybe?
;	movi	37h,a0
;	move	*a13(INRING),a14
;	jrnz	#hm_snd

	MOVI	0C1H,A0
	CALLA	triple_sound
	MOVK	2,A0
	CALLA	RNDRNG0
	SLL	4,A0
	ADDI	MAT_HITS,a0
	MOVE	*A0,A0
#hm_snd	CALLA	triple_sound
#rets	RETS

	;low-priority mat hits
MAT_HITS
	.word	76h,77h,78h

SMALL_BOUNCE
	MOVK	2,A0
	CALLA	RNDRNG0
	SLL	4,A0
	ADDI	small_bounce_sounds,a0
	MOVE	*A0,A0
	CALLA	triple_sound
	RETS

SMALL_RUN
	MOVK	2,A0
	CALLA	RNDRNG0
	SLL	4,A0
	ADDI	small_run_sounds,a0
	MOVE	*A0,A0
	CALLA	triple_sound
	RETS

small_bounce_sounds
	.word	0C0H,0C2H,0DH	;<--- this one is way too loud
;	.word	0dh,0ch,0bh

small_run_sounds
	.word	0C0H,0C2H,0C0H

DO_FLAME_SND
	MOVK	1,A0
	CALLA	RNDRNG0
	SLL	4,A0
	ADDI	FLAME_SOUNDS,a0
	MOVE	*A0,A0
	CALLA	triple_sound
	RETS

FLAME_SOUNDS
	.WORD	99H,9AH

DO_FLAME_HIT_SND
	MOVK	4,A0
	CALLA	RNDRNG0
	SLL	4,A0
	ADDI	FLAME_HIT_SOUNDS,a0
	MOVE	*A0,A0
	CALLA	triple_sound
	RETS

FLAME_HIT_SOUNDS
	.WORD	9DH,9EH,9FH,0A0H,0A1H

 SUBR    DO_LEX_PUSH
	MOVI	LEX_WHICH,A10
	JRUC	DO_PUSH_SPEECH
 SUBR    DO_BRET_PUSH
	MOVI	BRET_WHICH,A10
	JRUC	DO_PUSH_SPEECH
 SUBR    DO_DOINK_PUSH
	MOVI	DOINK_WHICH,A10
	JRUC	DO_PUSH_SPEECH
 SUBR    DO_SHAWN_PUSH
	MOVI	SHAWN_WHICH,A10
	JRUC	DO_PUSH_SPEECH

DO_RAZOR_PUSH
	MOVI	RAZOR_WHICH,A10

DO_PUSH_SPEECH
	MOVI	500,A0
	CALLA	RNDPER
	JRLS	NO_SOUNDS
;	MOVI	RAZOR_SWEAR_PID,A0
;	CLR	A1
;	NOT	A1
;	CALLA	EXISTP
	move	@razor_swear_exists,a14
	JRNZ	NO_SOUNDS
	CREATE	RAZOR_SWEAR_PID,DUMMY_WAIT
	MOVE	*A10(-10H),A0
	CALLA	RNDRNG0
	SLL	4,A0
	ADD	A10,A0
	MOVE	*A0,A0
	CALLA	triple_sound
NO_SOUNDS
	RETS

	.WORD	2
RAZOR_WHICH
	.WORD	27EH,27FH,280H

	.WORD	0
DOINK_WHICH
	.WORD	282H

	.WORD	0
SHAWN_WHICH
	.WORD	283H

	.WORD	0
BRET_WHICH
	.WORD	285H

	.WORD	0
LEX_WHICH
	.WORD	286H


DUMMY_WAIT
	movk	1,a14
	move	a14,@razor_swear_exists
	SLEEP	60
	clr	a14
	move	a14,@razor_swear_exists
	DIE

DO_WAIL
	MOVE	*A13(WRESTLERNUM),A1
	SLL	4,A1
	ADDI	WHICH_WAIL,A1
	MOVE	*A1,A0
	CALLA	triple_sound
	RETS

WHICH_WAIL
	.WORD  25FH	;0	(Bret)
	.WORD  270H	;1	(Razor)
	.WORD  20DH	;2	(Taker)
	.WORD  20DH 	;3	(Yoko)
	.WORD  20DH	;4	(Shawn)
	.WORD  20DH 	;5	(Bam Bam)
	.WORD  20DH	;6	(Doink)
	.WORD  0	;7	spare
	.WORD  20DH	;8	(Lex)

DO_DOINK_SLAM
	MOVI	218H,A0
	MOVE	*a13(RPT_COUNT),a14
	JRZ	FOUND_SOUND
	DEC	A14	
	JRZ	FOUND_SOUND
	CMPI	4,A14
	JRGE	NO_MORE_DOINK_SPEECH
	SLL	4,A14
	ADDI	DOINK_WHICH_SLAM,A14
	MOVE	*A14,A0
FOUND_SOUND
	CALLA	triple_sound
NO_MORE_DOINK_SPEECH
	RETS
DOINK_WHICH_SLAM
	.WORD	215H,216H,217H

DO_CHOKE
	CALLR	FIND_AND_KILL_ENDLESS
	MOVE	*A13(WRESTLERNUM),A0
	SLL	4,A0
	ADDI	WHICH_CHOKE,A0
	MOVE	*A0,A0
	CALLA	triple_sound
	SRL	16,A14
	MOVE	A14,@ENDLESS_SOUND
	RETS

WHICH_CHOKE
	.WORD	21AH ;HART
	.WORD	21AH ;RAZOR
	.WORD	21AH ;UND
	.WORD	21AH ;YOKO
	.WORD	21AH ;SHAWN
	.WORD   21AH ;BAM
	.WORD	21AH ;DOINK
	.WORD	0
	.WORD	21AH ;LEX


DO_OTHERNONO
	CALLR	FIND_AND_KILL_ENDLESS
	MOVE	*A13(WRESTLERNUM),A0
	JRUC	RE_ENTER_NONO

DO_NONO
	CALLR	FIND_AND_KILL_ENDLESS
	MOVE	*A13(ATTACH_PROC),A0,L
	MOVE	*A0(WRESTLERNUM),A0
RE_ENTER_NONO
	SLL	4,A0
	ADDI	WHICH_NONO,A0
	MOVE	*A0,A0
	CALLA	triple_sound
	SRL	16,A14
	MOVE	A14,@ENDLESS_SOUND
	RETS

WHICH_NONO
	.WORD	23CH ;HART
	.WORD	281H ;RAZOR
	.WORD	23CH ;UND
	.WORD	23CH ;YOKO
	.WORD	23CH ;SHAWN
	.WORD   23CH ;BAM
	.WORD	219H ;DOINK
	.WORD	0
	.WORD	23CH ;LEX

FIND_AND_KILL_ENDLESS
	MMTM	SP,A0,A3,A1,A14
	MOVE	@ENDLESS_SOUND,A0
	JRZ	NO_ENDLESS_GOING
	MOVE	A0,A14
	DEC	A14
	SLL	7,A14
	ADDI	WHICH_CHANNEL,A14
	MOVE	*A14+,A0,L
	CLR	A1
	MOVE	A1,*A0,L
	MOVE	*A14+,A0,L
	MOVE	A1,*A0,L
	MOVE	*A14,A3
	CALLA	SNDSND
	CLR	A3
	MOVE	A3,@ENDLESS_SOUND

NO_ENDLESS_GOING
	MMFM	SP,A0,A3,A1,A14
	RETS

WHICH_CHANNEL
	.LONG	chan1pri,chan1dur,994,0
	.LONG	chan2pri,chan2dur,995,0
	.LONG	chan3pri,chan3dur,996,0
	.LONG	chan4pri,chan4dur,997,0


DO_BLOCK_SND
	MOVK	2,A0
	CALLA	RNDRNG0
	SLL	4,A0
	ADDI	BLOCK_SOUNDS,a0
	MOVE	*A0,A0
;	MOVK	19H,A0
	CALLA	triple_sound
	RETS

BLOCK_SOUNDS
	.WORD	4,7,8

 SUBR   BLOCK_WOOSH
	MOVI	16h,A0
	CALLA	triple_sound
	RETS

WALK_SOUND
	MOVI	046H,A0
	MOVE	@HCOUNT,A1
	SRL	1,A1
	JRNC	WALK_SET
	MOVI	047H,A0
WALK_SET
	CALLA	triple_sound
	RETS

DO_RAZOR_RUG_SPEECH
	MOVE	*a13(RPT_COUNT),a14
	DEC	A14	
	CMPI	4,A14
	JRGE	NO_MORE_RAZOR_SPEECH
	SLL	4,A14
	ADDI	RAZOR_RUG_TABLE,A14
	MOVE	*A14,A0
	CALLA	triple_sound
NO_MORE_RAZOR_SPEECH
	RETS

RAZOR_RUG_TABLE
	.WORD	27DH,27CH,27BH,27AH

DO_BLOCKED
	MOVI	50,A0
	CALLA	RNDPER
	JRLS	NOT_BLOCKED
	MOVE	*A13(WRESTLERNUM),A1
	SLL	4,A1
	ADDI	WHICH_BLOCK_SPEECH,A1
	MOVE	*A1,A0
	JRZ	NOT_BLOCKED
	CALLA	triple_sound
NOT_BLOCKED
	RETS

WHICH_BLOCK_SPEECH
	.WORD	236H ;HART
	.WORD	280H ;RAZOR
	.WORD	23DH ;UND
	.WORD	23EH ;YOKO
	.WORD	284H ;SHAWN
	.WORD	06AH ;BAM
	.WORD	212H ;DOINK
	.WORD	0
	.WORD	287H ;LEX

MAKE_HIM_SCREAM
	MOVE	*A13(WHOIHIT),A4,L
	MOVE	*A4(WRESTLERNUM),A3
	JRUC	ACTUAL_SCREAM

DO_SCREAM
	MOVE	*A13(WRESTLERNUM),A3
ACTUAL_SCREAM
	SLL	6,A3
	ADDI	WHICH_SCREAM,A3
	MOVK	3,A0
	CALLA	RNDRNG0
	SLL	4,A0
	ADD	A0,A3
	MOVE	*A3,A0
	JRZ	NO_SCREAM
	CALLA	triple_sound
NO_SCREAM
	RETS

WHICH_SCREAM
	.WORD	265H,266H,262H,263H	;HART
	.WORD	268H,269H,26FH,26CH	;RAZOR	
	.WORD	265H,266H,262H,263H	;UND	!Using Bret screams	
	.WORD	268H,269H,26FH,26CH	;!
	.WORD	265H,266H,262H,263H	;SHAWN	!
	.WORD	265H,266H,262H,263H	;BAM	!
	.WORD	71H,72H,20AH,20CH	;DOINK
	.WORD	0,0,0,0
	.WORD	268H,269H,26FH,26CH	;LEX	!

 SUBR	GOUGE_SOUND
	MOVI	0A9H,A0
	CALLA	triple_sound
	RETS

MAYBE_GIDDUP
	MOVE	*A13(WRESTLERNUM),A9
	CREATE0	MAYBE_GIDDUP_PROC
	RETS

MAYBE_GIDDUP_PROC
	SLEEP	40
	MOVK	2,A0
	CALLA	RNDRNG0
	MOVE	A0,A0
	JRZ	OKAY_DO_GIDDUP
	ADDI	156,A0
	CALLA	IF_SILENT_ADD_VOICE
	DIE
OKAY_DO_GIDDUP
	MOVE	A9,A5
	MOVI	GIDDUP_MODE,A0
	CALLA	SET_UP_PERSONAL_CALL
	CALLR	ADD_SPEECH_TO_LIST
	CALLA	IF_SILENT_ADD_VOICE
	DIE

CALL_BONE_BREAK
	MOVK	2,A0
	CALLA	RNDRNG0
	SLL	4,A0
	ADDI	BONE_BREAK_SOUNDS,a0
	MOVE	*A0,A0
	CALLA	triple_sound
	JRNC	NOT_HEARD
	CREATE0	DID_YOU_HEAR_THAT_PROC
NOT_HEARD
	RETS

BONE_BREAK_SOUNDS
	.WORD	1dh,9bh,98h

DID_YOU_HEAR_THAT_PROC
	SLEEP	50
	MOVI	DID_YOU_HEAR_THAT,A0
	CALLA	IF_SILENT_ADD_VOICE
	DIE

MAYBE_BOUNCE_ROPE
	MOVK	10,A0
	CALLA	RNDRNG0
	MOVE	A0,A0
	JRNZ	NO_BOUNCE_ROPE_CALL
	MOVI	INTO_THE_ROPES,A0
	CALLA	IF_SILENT_ADD_VOICE
NO_BOUNCE_ROPE_CALL
	RETS

MAYBE_HIGH_RISK
	MOVK	4,A0
	CALLA	RNDRNG0
	MOVE	A0,A0
	JRNZ	NO_HIGH_RISK
	MOVI	HIGH_RISK_MANUEVER,A0
	CALLA	IF_SILENT_ADD_VOICE
NO_HIGH_RISK
	DIE

MAYBE_TOUGH_ENOUGH
	MOVK	4,A0
	CALLA	RNDRNG0
	MOVE	A0,A0
	JRNZ	#not_tough
	MOVI	ARE_YOU_TOUGH_ENOUGH,A0
	CALLA	ADD_VOICE
#not_tough
	rets

MAYBE_SHOCKING
	movi	3eh,a0
	calla	triple_sound
	SLEEP	92
	MOVK	4,A0
	CALLA	RNDRNG0
	MOVE	A0,A0
	JRNZ	NO_SHOCKING
	MOVI	SHOCKING,A0
	CALLA	IF_SILENT_ADD_VOICE
NO_SHOCKING
	DIE

**************************************************************
*CROWD TABLES
	.WORD	3
SETUP_TABLE
	.WORD	CROWD_CRESCENDO,D_CROWD_CRESCENDO,C_LONG|C_OVERIDE,0
	.WORD	CROWD_OH_1,D_CROWD_OH_1,C_LONG|C_OVERIDE,0
	.WORD	CROWD_HEY_LOOP,D_CROWD_HEY_LOOP,C_LONG|C_OVERIDE,0
	.WORD	CROWD_YEAH_0,D_CROWD_YEAH_0,C_LONG|C_OVERIDE,0

	.WORD	0
CRESCENDO_TABLE
	.WORD	CROWD_CRESCENDO,D_CROWD_CRESCENDO,C_LONG|C_RANDOM,700

	.WORD	2
ROPES_CHEER
	.WORD	CROWD_WHISTLE_1,D_CROWD_WHISTLE_1,C_LONG|C_RANDOM,600
	.WORD	CROWD_WHOA_1,D_CROWD_WHOA_1,C_LONG|C_RANDOM,600
	.WORD	CROWD_OH_1,D_CROWD_OH_1,C_LONG|C_RANDOM,600

	.WORD	2
CROWD_FAIL
	.WORD	CROWD_OH_FAIL,D_CROWD_OH_FAIL,C_LONG|C_RANDOM,600
	.WORD	CROWD_OH_0,D_CROWD_OH_0,C_LONG|C_RANDOM,600
	.WORD	CROWD_BOO,D_CROWD_BOO,C_LONG|C_RANDOM,600

	.WORD	2
CROWD_SPECIAL
	.WORD	CROWD_OH_CHEER,D_CROWD_OH_CHEER,C_LONG|C_OVERIDE,0
	.WORD	CROWD_HOORAY,D_CROWD_HOORAY,C_LONG|C_OVERIDE,0
	.WORD	CROWD_VICTORY_LOOP,D_CROWD_VICTORY_LOOP,C_LONG|C_OVERIDE,0

	.WORD	4
CROWD_CHEER
	.WORD	CROWD_YEAH_0,D_CROWD_YEAH_0,C_LONG|C_RANDOM,600
	.WORD	CROWD_WHISTLE_1,D_CROWD_WHISTLE_1,C_LONG|C_RANDOM,600
	.WORD	CROWD_CHEER_0,D_CROWD_CHEER_0,C_LONG|C_RANDOM,600
	.WORD	CROWD_CHEER_1,D_CROWD_CHEER_1,C_LONG|C_RANDOM,600
	.WORD	CROWD_DOUBLE_WHOA,D_CROWD_DOUBLE_WHOA,C_LONG|C_RANDOM,600

	.WORD	1
CROWD_THROWN
	.WORD	CROWD_OH_CHEER,D_CROWD_OH_CHEER,C_SHORT|C_OVERIDE,0
	.WORD	CROWD_WHISTLE_1,D_CROWD_WHISTLE_1,C_SHORT|C_OVERIDE,0

	.WORD	1
CROWD_ORDINARY
	.WORD	CROWD_OH_CHEER,D_CROWD_OH_CHEER,C_SHORT|C_OVERIDE|C_RANDOM,250
	.WORD	CROWD_WHISTLE_1,D_CROWD_WHISTLE_1,C_SHORT|C_OVERIDE|C_RANDOM,250

****************************************************************************
* SOUND VOLUME CONTROLS

;A11 = WHICH CHANNEL, -1 = MASTER
;A8 = TICKS TO FADE OVER
FADE_MASTER_VOL
	MOVI	ADJVOLUME,A0
	CALLA	GET_ADJ
	BADCHK	a0,0,255,28		;reg, lo, hi, val if bad
	MOVE	A0,A9
	SLL	16,A9
	MOVE	A9,A10
	DIVU	A8,A9
NEXT_FADE
	SUB	A9,A10
	MOVE	A10,A0
	SRL	16,A0
	MOVE	A11,A1
	CALLR	SET_LOWER_VOL
	SLEEPK	1
	DSJS	A8,NEXT_FADE
	CLR	A0
	MOVE	A11,A1
	CALLR	SET_LOWER_VOL
	DIE

;A1 WHICH CHANNEL
;A0 WHAT TO SET CHANNEL VOL TO 255=100%
SET_LOWER_VOL
	MOVI	55ABH,A3
	ADD	A1,A3
	CALLA	SNDSND
	MOVE	A0,A3
	SLL	8,A0
	NOT	A3
	SLL	24,A3
	SRL	24,A3
	OR	A0,A3
	CALLA	SNDSND
	RETS

 SUBR	KILL_ALL_CHANNELS
	CLR	A0
	MOVE	A0,@chan1dur
	MOVE	A0,@chan1pri
	movi	994,a3
	calla	SNDSND
	MOVE	A0,@chan2dur
	MOVE	A0,@chan2pri
	movi	995,a3
	calla	SNDSND
	MOVE	A0,@chan3dur
	MOVE	A0,@chan3pri
	movi	996,a3
	calla	SNDSND
	MOVE	A0,@chan4dur
	MOVE	A0,@chan4pri
	movi	997,a3
	calla	SNDSND
	rets

******************************************************************************

	.end
