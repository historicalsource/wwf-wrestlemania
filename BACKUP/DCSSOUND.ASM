**************************************************************
*
* Software:		Ed Boon
* Initiated:		?
*
* Modified:		Jason Skiles,	23 Nov 93 - WWF conversion
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

	.text
;**************************************************************************
;*											      *
;* OK people, there are several ready made speech call routines for		 *
;* you to use. I'll go through them, with where you should call them	 *
;* from and what they are for.									 *
;* vvvvvv All These to be called from scripts VVVVVVVV				 *
;* CALL_MISSES - If you attempt to do something and miss,				 *
;* 	E.g. head grab....									 *
;* CALL_SPECIAL_MOVE - For the 5 dollar moves, the pile drivers etc		 *
;* CALL_ANI_AVERAGE_MOVE - For the Average moves that are fairly easy to	 *
;* 	fire off. E.g. Back hand slap, Shawns spin kick				 *
;* DO_REVERSAL - When a move is reversed against the opponent			 *
;* CALL_MISS_YOKO -  For use when you try to do a move against YOKO and f *
;* CALL_THROWN_OUT - Been chucked out of the ring					 *
;* CALL_OTHER_AVERAGE - Another Average move speech call, to provide vari *
;* CALL_NASTY_MOVE - When you do something against the rules, 			 *
;* 	E.g. Doink buzzer, Doink Hammer, Shawn arm break				 *
;* CALL_SETUP - Set up for a better move, E.g. Head grab, Picking up over *
;* 												 *
;* vvvvvv All these calls come from the REACT subroutines VVVVV		 *
;* CALL_FACE_HIT - Any thing that *JUST* hits the face Eg. Head butts	 *
;* CALL_MID_HIT - Any thing that *JUST* hits the midsection			 *
;* CALL_DROP_KICK - For any move that results in both wrestlers		 *
;* 	hitting the ground.									 *
;*											      *
;**************************************************************************


	.DEF	CALL_ANI_AVERAGE_MOVE

	.def	SNDSND, SET_LOWER_VOL, FADE_MASTER_VOL
	.DEF	CALL_NASTY_MOVE

	.DEF	CALL_MISS_YOKO, CLEAR_SPEECH_REPEAT

	.DEF	CALL_OTHER_AVERAGE

	.DEF	ADD_VOICE, RESET_VOICE_QUEUE
	.DEF	ANNOUNCE_VOICE
	.DEF	IF_SILENT_ADD_VOICE
	BSSX	DONE_HOWARD,16
	.DEF	VINCE_START_GAME
	.DEF	nosounds
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
	.REF	index1,index2,process_ptrs,NUM_OPPS,PSTATUS
	.REF	total_matches

	;for various files
	.def	DEFAULT_SOUND_TABLE,MASTER_SOUND_TABLE

	;from AUDIT.ASM
	.ref	PUT_ADJ,GET_ADJ,F_ADC_S

	;from UTIL.ASM
	.ref	RNDRNG0

	;from WRESTLE.ASM
	.ref	GAMSTATE

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

	BSSX	vincechan,16,1		; channel vince is on, if any
	BSSX	vincedur,16,1		; vince duration

	BSSX	randychan,16,1		; channel randy is on, if any
	BSSX	randydur,16,1		; randy duration

	BSSX	howardchan,16,1		; channel howard is on, if any
	BSSX	howarddur,16,1		; howard duration

	BSSX	SOUNDSUP,16,1		; SOUND ENABLED FLAG
	.BSS	LAST_VOICE,64		;LAST SPEECH CALL MADE
	.BSS	WHICH_LAST_VOICE,32
	BSSX	REPEAT_STATE,16

	bssx	ANNOUNCE_QUEUE,32*20
	.BSS	EOF_ANNOUNCE_QUEUE,0
	BSSX	NEXT_ANN_QUEUE,32
	BSSX	CURRENT_ANN_QUEUE,32


**************************************************************************
*												*
*	Sound type priorities
*												*
**************************************************************************

;all new priorities.  whee.
sp_woosh	equ	 4 << 8			; attack whoosh
sp_attkv	equ	 8 << 8			; attack grunt
sp_mat1		equ	12 << 8			; mat noises
sp_mat2		equ	16 << 8			; mat noises
sp_reacv	equ	16 << 8			; react grunt
sp_smack	equ	20 << 8			; smack
sp_wspch	equ	24 << 8			; wrestler speech
sp_anncer	equ	100 << 8			; announcer speech
sp_system1	equ	36 << 8			; system stuff
sp_system2	equ	40 << 8			; system stuff


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
	.word	sp_smack|15,>88		;  4 = body hit #0
	.word	sp_smack|17,>8c		;  5 = body hit #1
	.word	sp_attkv|15,>90		;  6 = kick #0
	.word	sp_attkv|13,>94		;  7 = kick #1
	.word	sp_attkv|15,>98		;  8 = kick #2

	.word	sp_mat1|13,156		;  9 = fall to mat #0
	.word	sp_wspch|70,460		;  a = clock tick
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

	.word	sp_attkv|32,>e4		; 1d = long effort grunt #0
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
	.word	sp_smack|35,>530	; 33 = bones breaking #0
	.word	sp_smack|39,>534	; 34 = bones breaking #1
	.word	sp_smack|33,>538	; 35 = bones breaking #2
	.word	sp_smack|54,>53c	; 36 = bones breaking #3
	.word	sp_smack|34,>540	; 37 = bones breaking #4
	.word	sp_smack|33,>544	; 38 = bones breaking #5
	.word	sp_smack|42,>548	; 39 = bones breaking #6
	.word	sp_smack|44,>54c	; 3a = bones breaking #7
	.word	sp_smack|28,>550	; 3b = bones breaking #8
	.word	sp_attkv|85,1292	; 3c	= plywood crash #3
	.word	sp_attkv|62,408 	; 3d	= ring mat crash #0
	.word	sp_smack|149,1448 	; 3E	= doink joy buzzer
	.word	sp_attkv|67,1452	; 3f	= doink water spray
	.word	sp_attkv|21,176 	; 40	= urn materialisation
	.word	sp_attkv|21,176 	; 41	= Bam Bam rising in flames
	.word	sp_attkv|185,904 	; 42	= Bam Bam taunt
	.word	sp_smack|70,1436	; 43	= doink big glove slap
	.word	sp_smack|84,1440	; 44	= doink big foot hit
	.word	sp_smack|80,1444	; 45	= doink big hammer hit
	.word	sp_attkv|11,428		; 46	= footsteps on mat #0
	.word	sp_attkv|15,432		; 47	= footsteps on mat #1
	.word	sp_anncer|131,1376 ; 48	= COIN IN SOUNDS

	.word	sp_anncer|53,1512 ; 49	= buy in sound
	.word	sp_woosh|19,1556   	; 4a	= flashbulb #0
	.word	sp_woosh|32,1560   	; 4b	= flashbulb #1
	.word	sp_woosh|40,1564   	; 4c	= flashbulb #2
	.word	sp_smack|35,1568   	; 4d	= flash the "W" after a victory
	.word	0,0			; 4e
	.word	0,0			; 4f

	;DOINK SPEECH
	.word	sp_wspch|53,>20c	; 50 = wait a minute, wait a minute
	.word	sp_wspch|29,>210	; 51 = time out
	.word	sp_wspch|40,>214	; 52 = chokes #0
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
	.word	sp_wspch|81,>308	; 5c = Razor...Ramon!
	.word	0,0			; 5d
	.word	0,0			; 5e
	.word	0,0			; 5f

	;SHAWN SPEECH
	.word	sp_wspch|269,>280	; 60 = lucky you...breaking bones
	.word	sp_wspch|130,>284	; 61 = wrestler o' 90's
	.word	sp_wspch|132,>288	; 62 = how could...hurt so bad
	.word	sp_wspch|26,>28c	; 63 = no no
	.word	sp_wspch|21,>290	; 64 = please

	;BAM BAM SPEECH
	.word	sp_wspch|75,>290	; 65 = deadly choice
	.word	sp_wspch|147,>290	; 66 = the beast from the east
	.word	sp_wspch|185,>290	; 67 = bam bam - bam bam - yeah!
	.word	sp_wspch|162,>290	; 68 = bam bam bigelow
	.word	sp_wspch|160,>290	; 69 = burn, baby, burn!
	.word	sp_wspch|24,>290	; 6a = hey! #0
	.word	sp_wspch|23,>290	; 6b = no no
	.word	sp_wspch|18,>290	; 6c = no
	.word	sp_wspch|20,>290	; 6d = hey! #1
	.word	sp_wspch|36,>290	; 6e = no no no
	.word	sp_wspch|103,>290	; 6f = get out of my ring


	.word	sp_reacv|34,>458	; 70 = DOINK pain #0
	.word	sp_reacv|30,>45c	; 71 = DOINK pain #1
	.word	sp_reacv|40,>460	; 72 = DOINK pain #2

	.word	sp_reacv|42,>464	; 73 = DOINK gut hit #0
	.word	sp_reacv|40,>468	; 74 = DOINK gut hit #1
	.word	sp_reacv|18,>46c	; 75 = DOINK gut hit #2

	.word	sp_reacv|16,>470	; 76 = RAZOR pain #0
	.word	sp_reacv|12,>474	; 77 = RAZOR pain #1
	.word	sp_reacv|25,>478	; 78 = RAZOR pain #2

	.word	sp_reacv|24,>47c	; 79 = RAZOR generic grunt #0
	.word	sp_reacv|16,>480	; 7a = RAZOR generic grunt #1
	.word	sp_reacv|21,>484	; 7b = RAZOR generic grunt #2

	.word	sp_reacv|29,>488	; 7c = RAZOR gut hit #0
	.word	sp_reacv|38,>48c	; 7d = RAZOR gut hit #1
	.word	sp_reacv|42,>490	; 7e = RAZOR gut hit #2

	.word	sp_reacv|32,>31e	; 7f = RAZOR choke #0 (more voice)
	.word	sp_reacv|17,>321	; 80 = RAZOR choke #0 (more air)
	.word	sp_reacv|97,>324	; 81 = RAZOR lift & throw something

	.word	sp_wspch|62,1196	; 82 = BAM BAM effort #1

	.word	sp_reacv|48,>40f	; 83 = JASON effort grunt #0
	.word	sp_reacv|36,>412	; 84 = JASON effort grunt #1
	.word	sp_reacv|39,>415	; 85 = JASON effort grunt #2
	.word	sp_reacv|31,>418	; 86 = JASON effort grunt #3
	.word	sp_reacv|31,>41b	; 87 = JASON effort grunt #4
	.word	sp_reacv|39,>41e	; 88 = JASON effort grunt #5
	.word	sp_reacv|40,>421	; 89 = JASON effort grunt #6
	.word	sp_reacv|34,>424	; 8a = JASON effort grunt #7
	.word	sp_reacv|27,>427	; 8b = JASON effort grunt #8
	.word	sp_reacv|35,>42a	; 8c = CG effort grunt #0
	.word	sp_reacv|44,>42d	; 8d = CG effort grunt #1
	.word	sp_reacv|35,>430	; 8e = CG effort grunt #2
	.word	sp_reacv|36,>433	; 8f = CG effort grunt #3
	.word	sp_reacv|36,>433	; 90 = CG effort grunt #4
	.word	sp_reacv|25,>436	; 91 = CG effort grunt #5
	.word	sp_reacv|34,>439	; 92 = CG effort grunt #6
	.word	sp_reacv|49,>43c	; 93 = CG effort grunt #7
	.word	sp_reacv|57,>43f	; 94 = CG effort grunt #8
	.word	sp_reacv|31,>400	; 95 = SAL pain grunt #0
	.word	sp_reacv|53,>403	; 96 = SAL pain grunt #1
	.word	sp_reacv|82,>409	; 97 = SAL pain grunt #2
	.word	sp_reacv|37,>40c	; 98 = SAL pain grunt #3
	.word	0,0			; 99
	.word	0,0			; 9a
	.word	0,0			; 9b
	.word	0,0			; 9c
	.word	0,0			; 9d
	.word	0,0			; 9e
	.word	0,0			; 9f
	.word	0,0			; a0
	.word	0,0			; a1
	.word	0,0			; a2
	.word	0,0			; a3
	.word	0,0			; a4
	.word	0,0			; a5
	.word	0,0			; a6
	.word	0,0			; a7
	.word	0,0			; a8
	.word	0,0			; a9
	.word	0,0			; aa
	.word	sp_reacv|72,>4D4	; ab = BAMBAM morph out of mat
	.word	sp_reacv|40,>15C	; ac = CARTOON bong #2
	.word	sp_reacv|58,>170	; ad = CARTOON crash/bong #0
	.word	sp_reacv|33,1220	; ae = SHAWN pain #1
	.word	sp_reacv|33,1224	; af = SHAWN gut hit #0

	;MISCELLANEOUS SOUNDS
	.word	sp_mat1|29,>315	; b0 = some blip sound
	.word   sp_system1|90,0148h	; b1 = round start bell
	.word   sp_smack|19,>160	; b2 = squeeze horn honk #0
	.word   sp_smack|75,014fh	; b3 = twist - slam
	.word	sp_mat1|46,344	; b4 = bong (temp!)
	.word	sp_mat1|15,>1b2		; b5 = footstep on mat #1

	.word	sp_system1|34,>178	; b6 = Quick whistle for transitions

	.word	sp_system1|9,1364	; b7 = timer tick #0 
	.word	sp_system1|11,1368	; b8 = timer tock #0
	.word	sp_attkv|84,1484     ; b9 = danger sound
	.word	sp_attkv|102,1488    ; ba	= combo performed
	.word	sp_system1|125,1520	; bb	= reversal_sound 

	.word	sp_mat1|46,>152	     ; bc = bong! (timer?)
	.word	sp_mat1|42,>164	     ; bd = ricochet bonk
	.word	sp_mat1|51,>17c	     ; be = wobble (danger!)
	.word	sp_mat1|51|75,>500	; bf = Plywood crash #0
	.word	sp_mat1|39,316    	; c0 = fall to mat #0
	.word	sp_mat2|77,>508	     ; c1 = Plywood crash #2
	.word	sp_mat1|26,320    	; c2 = fall to mat #1
	.word	sp_mat2|83,>510	     ; c3 = Plywood crash #4
	.word	sp_smack|101,>514	; c4 = Chair crash #0
	.word	sp_smack|101,>518	; c5 = Chair crash #1
	.word	sp_smack|90,>51c	; c6 = Chair crash #2
	.word	sp_system1|9,1456	; c7	= player 1 moves cursor #1
	.word	sp_system1|9,1460	; c8	= player 2 moves cursor #1
	.word	sp_system1|10,1464	; c9	= player 1 moves cursor #2
	.word	sp_system1|9,1468	; ca	= player 2 moves cursor #2
	.word	sp_system1|35,1504	; cb	= player 1 selects #1
	.word	sp_system1|35,1508	; cc	= player 2 selects #1
	.word	0,0			; cd
	.word	0,0			; ce
	.word	0,0			; cf
	.word	0,0			; d0
	.word	0,0			; d1
	.word	0,0			; d2
	.word	0,0			; d3
	.word	0,0			; d4
	.word	0,0			; d5
	.word	0,0			; d6
	.word	0,0			; d7
	.word	0,0			; d8
	.word	0,0			; d9
	.word	0,0			; da
	.word	0,0			; db
	.word	0,0			; dc
	.word	0,0			; dd
	.word	0,0			; de
	.word	0,0			; df

	;ANNOUNCER SPEECH - must be contiguous
announcer_start
	;VINCE MCMAHON
	.word	sp_anncer|249,3072	; e0 = VINCE greeting
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
	.word	sp_anncer|82,3572	;157	=oh that hurts #0
	.word	sp_anncer|70,3576	;158	=oh that hurts #1
	.word	sp_anncer|31,3580	;159	=a miss
	.word	sp_anncer|62,3584	;15a	=and misses
	.word	sp_anncer|56,3588	;15b	=into the ropes
	.word	sp_anncer|43,3592	;15c	=a quick reversal
	.word	sp_anncer|63,3596	;15d	=both men down
	.word	sp_anncer|51,3600	;15e	=this could be it
	.word	sp_anncer|53,3604	;15f	=no, wait a minute
	.word	sp_anncer|63,3608	;160	=Unbeeleeevable! #1
	.word	sp_anncer|92,3612	;161	=Unbeeleeevable! #2
	.word	sp_anncer|54,3616	;162	=oh my goodness #1
	.word	sp_anncer|99,3620	;163	=oh my goodness #2
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
	.word	sp_anncer|101,3732	;17c	=its pandemonium out there
	.word	sp_anncer|130,3736	;17d	=its pandemonium in the ring
	.word	sp_anncer|39,3740	;17e =whats this
	.word	sp_anncer|100,3744	;17f	=what a turn of events this is
	.word	sp_anncer|95,3748    ;180	=magnificent!
	.word	sp_anncer|80,3752    ;181	=can you believe that!
	.word	sp_anncer|88,3756    ;182	=rejected!!
	.word	sp_anncer|62,3760    ;183	=what a beating!
	.word	sp_anncer|40,3764    ;184	=to the face!
	.word	sp_anncer|54,3768    ;185	=to the midsection!
	.word	sp_anncer|44,3772    ;186	=and another!
	.word	sp_anncer|112,3776   ;187	=I wouldn't want to be on the receiving end of that!
	.word	sp_anncer|54,3780    ;188	=what power!
	.word	sp_anncer|72,3784    ;189	=what speed!
	.word	sp_anncer|67,3788    ;18a	=what skill!
	.word	sp_anncer|67,3792	;18b	=what a blow!
	.word	sp_anncer|52,3796	;18c	=awesome...
	.word	sp_anncer|89,3800	;18d	=just awesome!
	.word	sp_anncer|82,3804	;18e	=good night!
	.word	sp_anncer|28,3808	;18f	=hello!
	.word	sp_anncer|120,3812	;190	=it doesn't look good for Doink the Clown!
	.word	sp_anncer|121,3816	;191	=it doesn't look good for Shawn Michaels!
	.word	sp_anncer|104,3820	;192	=it doesn't look good for Razor Ramone!
	.word	sp_anncer|116,3824	;193	=it doesn't look good for The Undertaker!
	.word	sp_anncer|142,3828	;194	=it doesn't look good for Bam Bam Bigelow!
	.word	sp_anncer|107,3832	;195	=it doesn't look good for Lex Luger!
	.word	sp_anncer|134,3836	;196	=it doesn't look good for Bret the Hitman Hart!
	.word	sp_anncer|121,3840	;197	=it doesn't look good for Yokozuna!
	.word	sp_anncer|74,3844	;198	=can anybody stop him!?
	.word	sp_anncer|19,3848	;199	=what --
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
	.word	sp_anncer|106,3912	;1A9	=it's a donnybrook
	.word	sp_anncer|124,3916	;1Aa	=he's just gone berserk
	.word	sp_anncer|56,3920	;1Ab	=the joybuzzer
	.word	sp_anncer|64,3924	;1Ac	=shocking
	.word	sp_anncer|110,3928	;1Ad	=can you believe what you've just seen?
	.word	sp_anncer|44,3932	;1Ae	=he's got him
	.word	sp_anncer|55,3936	;1Af	=a cross-body!
	.word	sp_anncer|61,3940	;1B0	=suplex!
	.word	sp_anncer|46,3944	;1B1	=neck-breaker!
	.word	sp_anncer|87,3948	;1B2	=the tombstone piledriver!
	.word	sp_anncer|72,3952	;1B3	=he's got him in a sharpshooter!
	.word	sp_anncer|52,3956	;1B4	=Banzai Drop!
	.word	sp_anncer|55,3960	;1B5	=the Razor's edge!
	.word	sp_anncer|53,3964	;1B6	=Back Suplex!
	.word	sp_anncer|49,3968	;1B7	=Savate Kick!
	.word	sp_anncer|78,3972	;1B8	=The Awesome Forearm!
	.word	sp_anncer|76,3976	;1B9	=Flying Head Butt!
	.word	sp_anncer|136,3980	;1Ba	=Somehow I don't think this grudge will end here
	.word	sp_anncer|80,3984	;1Bb	=Sign here please
	.word	sp_anncer|67,3988	;1Bc	=good night!
	.word	sp_anncer|0,0	;1Bd	
	.word	sp_anncer|0,0	;1Be	
	.word	sp_anncer|0,0	;1Bf	
	.word	sp_anncer|0,0	;1C0	
	.word	sp_anncer|0,0	;1C1
	.word	sp_anncer|0,0	;1C2
	.word	sp_anncer|0,0	;1C3
	.word	sp_anncer|0,0	;1C4
	.word	sp_anncer|0,0	;1C5
	.word	sp_anncer|0,0	;1C6
	.word	sp_anncer|0,0	;1C7
	.word	sp_anncer|0,0	;1C8
	.word	sp_anncer|0,0	;1C9
	.word	sp_anncer|0,0	;1Ca
	.word	sp_anncer|0,0	;1Cb
	.word	sp_anncer|0,0	;1Cc
	.word	sp_anncer|0,0	;1Cd
	.word	sp_anncer|0,0	;1Ce
	.word	sp_anncer|0,0	;1Cf
vince_end	;end of vince speech section
	;RANDY SAVAGE
	.word	sp_anncer|73,6144	;1D0 =nicely done
	.word	sp_anncer|152,6148	;1D1	=taste of his own medicine
	.word	sp_anncer|52,6152	;1D2	=look at this
	.word	sp_anncer|99,6156	;1D3	=right to the kisser
	.word	sp_anncer|93,6160	;1D4	=that was dumb
	.word	sp_anncer|89,6164	;1D5	=that was ugly
	.word	sp_anncer|71,6168	;1D6	=did you see that 
	.word	sp_anncer|130,6172	;1D7	=ive never seen anything like that
	.word	sp_anncer|77,6176	;1D8	=oh yeah
	.word	sp_anncer|59,6180	;1D9	=this could be it
	.word	sp_anncer|75,6184	;1Da	=no, wait a minute
	.word	sp_anncer|128,6188	;1Db	=what a move by Shawn Michaels
	.word	sp_anncer|79,6192	;1Dc	=what a move by Doink
	.word	sp_anncer|144,6196	;1Dd	=what a move by Razor Ramone
	.word	sp_anncer|146,6200	;1De	=what a move by the Undertaker
	.word	sp_anncer|111,6204	;1Df	=what a move by Bam Bam
	.word	sp_anncer|91,6208	;1E0	=what a move by Lex
	.word	sp_anncer|124,6212	;1E1	=what a move by the Hitman
	.word	sp_anncer|139,6216	;1E2	=what a move by Yokozuna
	.word	sp_anncer|85,6220	;1E3	=That'll cost him
	.word	sp_anncer|116,6224	;1E4	=Rejected
	.word	sp_anncer|59,6228	;1E5	=That's gotta hurt
	.word	sp_anncer|133,6232	;1E6	=Game over
	.word	sp_anncer|86,6236	;1E7	=What power
	.word	sp_anncer|85,6240	;1E8	=What speed
	.word	sp_anncer|105,6244	;1E9	=What agility
	.word	sp_anncer|67,6248	;1Ea	=awesome
	.word	sp_anncer|95,6252	;1Eb	=goodnight
	.word	sp_anncer|30,6256	;1Ec	=hello
	.word	sp_anncer|72,6260	;1Ed	=What's going on?
	.word	sp_anncer|65,6264	;1Ee	=He can't do that
	.word	sp_anncer|64,6268	;1Ef	=That was cheap
	.word	sp_anncer|111,6272	;1F0	=Somebody call security
	.word	sp_anncer|108,6276	;1F1	=That wasn't very nice
	.word	sp_anncer|80,6280	;1F2	=I can't watch
	.word	sp_anncer|82,6284	;1F3	=Incredible
	.word	sp_anncer|96,6288 	;1F4	=This could be trouble
	.word	sp_anncer|129,6292	;1F5	=I think he broke it
	.word	sp_anncer|134,6296	;1F6	=Nobody gets up from that
	.word	sp_anncer|51,6300	;1F7	=Dig it
	.word	sp_anncer|122,6304	;1F8	=Oooo Vicious
	.word	sp_anncer|0,0	;1F9
	.word	sp_anncer|0,0	;1Fa
randy_end	;end of randy speech section
	;HOWARD FINKEL
	.word	sp_anncer|117,2560 		;1Fb	=good evening ladies and gents
	.word	sp_anncer|130,2564 		;1Fc	=my name is howard finkel
	.word	sp_anncer|226,2568 		;1Fd	=and welcome to wrestlmainia by midway
	.word	sp_anncer|192,2576 		;1Fe	=we have a winner
	.word	sp_anncer|188,2572 		;1Ff	=this match is scheduled for 2 falls

howards_end	;extremely dull british film - YOU SAID IT !
	.word	sp_attkv|20,4500	; 200 =DOINK takes a punch to the face
	.word	sp_attkv|26,4504	; 201 =DOINK takes a head-butt
	.word	sp_attkv|27,4508	; 202 =DOINK takes a special weapon to the face/head
	.word	sp_attkv|21,4512	; 203 =DOINK takes a hit to the gut
	.word	sp_attkv|21,4516	; 204 =DOINK takes a kick/knee to the gut
	.word	sp_attkv|33,4520	; 205 =DOINK takes a gut hit (alternate)
	.word	sp_attkv|21,4524	; 206 =DOINK short effort grunt before kick/punch #0
	.word	sp_attkv|44,4536	; 207 =DOINK medium effort grunt before lifting/reaching for something
	.word	sp_attkv|61,4540	; 208 =DOINK long effort grunt before throwing something
	.word	sp_attkv|70,4544	; 209 =DOINK long effort grunt before jumping from top rope maybe
	.word	sp_attkv|39,4548	; 20a =DOINK short scream of pain #0
	.word	sp_attkv|50,4552	; 20b =DOINK short scream of pain #1
	.word	sp_attkv|46,4556	; 20c =DOINK medium scream of pain #0
	.word	sp_attkv|63,4560	; 20d =DOINK medium scream of pain #1
	.word	sp_attkv|104,4564	; 20e =DOINK long scream of pain #0
	.word	sp_attkv|71,4568	; 20f =DOINK JOYBUZZER: put'er there pal
	.word	sp_attkv|54,4572	; 210 =DOINK JOYBUZZER: pleased to meet you
	.word	sp_attkv|66,4576	; 211 =DOINK JOYBUZZER BLOCKED allllrighty then!
	.word	sp_attkv|70,4580	; 212 =DOINK REVERSAL I don't think so!
	.word	sp_attkv|48,4584	; 213 =DOINK REVERSAL O no you don't
	.word	sp_attkv|77,4588	; 214 =DOINK 1st Fall victory (?)
	.word	sp_attkv|17,4592	; 215 =DOINK Jarvis laugh for repeat punch #0
	.word	sp_attkv|18,4596	; 216 =DOINK Jarvis laugh for repeat punch #1
	.word	sp_attkv|21,4600	; 217 =DOINK Jarvis laugh for repeat punch #2
	.word	sp_attkv|40,4604	; 218 =DOINK Jarvis laugh for repeat punch #3
	.word	sp_attkv|100,4608	; 219 =DOINK nonono loop - endless 
	.word	sp_attkv|100,4612	; 21a =DOINK choking loop (endless)

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

	.word	0000h,0079h,0000h,0026h	;push
	.word	0000h,0028h,0000h,001ah	;hiptoss
	.word	0017h,007Ah,0074h,0000h	;big boot
	.word	0012h,0032h,001Bh,002Dh	;super punch

	.word	0000h,0079h		;turndive
	.word	            1002h,1003h	;rug slam
	.word	0059h			;yellthrow

MASTER_SOUND_TABLE
;Bret Hart	00
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
	.word	DEFLT			;yellthrow

;Razor Ramon	01
	.word	DEFLT,0031h,DEFLT,DEFLT	;punch
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
	.word	DEFLT,DEFLT,DEFLT,0078h	;big boot

	.word	DEFLT,DEFLT,DEFLT,DEFLT	;super punch

	.word	DEFLT,DEFLT		;turndive
	.word	            DEFLT,DEFLT	;rug slam
	.word	DEFLT			;yellthrow

;Undertaker	02
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
	.word	DEFLT			;yellthrow

;Shawn Michaels	04
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

	.word	DEFLT,DEFLT,DEFLT,DEFLT	;super punch

	.word	DEFLT,DEFLT		;turndive
	.word	            DEFLT,DEFLT	;rug slam
	.word	DEFLT			;yellthrow

;Doink the Clown 06
	;	whsh  grunt smak  ouch
	.word	DEFLT,0206H,DEFLT,0200H	;punch
	.word	DEFLT,0206H,1000h,0201H	;headbutt
	.word	DEFLT,DEFLT,DEFLT,0204H	;kick
	.word	DEFLT,0207H,DEFLT,0202H	;flykick

	.word	DEFLT,0207H,DEFLT,020CH	;grabthrow
	.word	DEFLT,0206H,DEFLT,0203H	;uppercut
	.word	DEFLT,0206H,DEFLT,020AH	;elbow drop
	.word	DEFLT,0207H,DEFLT,0219H	;grabhold

	.word	DEFLT,0208H,DEFLT,020DH	;grabfling
	.word	DEFLT,0206H,DEFLT,0206H	;push
	.word	DEFLT,0084h,DEFLT,0207H	;hiptoss
	.word	DEFLT,0207H,DEFLT,020Bh	;big boot

	.word	DEFLT,0206H,DEFLT,020CH	;super punch

	.word	DEFLT,DEFLT		;turndive
	.word	            DEFLT,DEFLT	;rug slam
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
	.word	DEFLT			;yellthrow

;Lex Luger	08
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
	.word	DEFLT			;yellthrow

;Ref		09
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
	.word	DEFLT			;yellthrow

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
	callr	set_volume

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


 SUBRP	delay_code_a3

#loop1
	;if this is the only delay_code_a3 process, do the sound, wait out
	; the duration, then die.

	movi	DELAYSND_PID,a0
	movi	0FFFFh,a1
	calla	EXISTP
	jrz	#go
	SLEEPK	1
	jruc	#loop1

#go
	move	a8,a3
	callr	send_code_a3

#loop2
	SLEEPK	1
	dsj	a9,#loop2

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
	jrlt	#error1
	cmpi	vince_end,a1
	jrlt	#vince
	cmpi	randy_end,a1
	jrlt	#randy
	cmpi	howards_end,a1
	jrlt	#howard

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
	.if DEBUG
	LOCKUP
	.endif
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

	move	@SOUNDSUP,b3,W		; are we allowed ??
	jrne	send_rets		; no

	PUSH	a0,a1,a2,a3,a4,a5,a6
	X32	a0			; 32 bits per table entry
	addi	triple_sndtab,a0 	; a0 --> our entry
	cmpi	triple_end,a0		; past the end of the table ?
	jrhs	tsnd9			; yes, sans

tsnd0	move	*a0+,a1,W		; a1 = [priority , duration]
	jreq	tsnd9			; zero entry = skip
	jrn	triple_tune		; ffff = tune script

	move	a1,a4
	srl	8,a1			; a1 = priority only
	sll	32-8,a4
	srl	32-8,a4			; a4 = duration only
	move	*a0+,a3,W		; a3 = channel 1 sound call
*
* a1 = priority
* a3 = channel 1 sound call
* a4 = duration
*
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

;Old Method = find first call that I outrank and bump it.
;
;	move	@chan1pri,a0,W
;	cmp	a0,a1			; who is more important ?
;	jrhs	tsnd1			; me ---> do it
;	move	@chan2pri,a0,W
;	cmp	a0,a1			; who is more important ?
;	jrhs	tsnd2			; me ---> do it
;	move	@chan3pri,a0,W
;	cmp	a0,a1			; who is more important ?
;	jrhs	tsnd3			; me ---> do it
;	move	@chan4pri,a0,W
;	cmp	a0,a1			; who is more important ?
;	jrhs	tsnd4			; me ---> do it

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
	jump	a6
		
#no_preempt
	PULL	a0,a1,a2,a3,a4,a5,a6
	clr	a14
send_rets
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
	callr	SNDSND
	or	a4,a2
	move	a2,a14

tsnd9	PULL	a0,a1,a2,a3,a4,a5,a6
	setc	 			; carry set = success
	rets

*
*   tune script decoding
*
triple_tune

	addk	16,a0
	move	*a0,a1,L		; a1 = tune table
	move	*a1+,a2,W 		; a2 = priority

	movb	*a1(8),a0 		; grab player 1 channel
	move	*a13(PLYRNUM),a3,W
	jrz	tune4			; player 1?
	movb	*a1,a0			; grab player 1 channel
tune4	addk	16,a1			; a1 ---> next command

	dec	a0	     		; a0 = channel = (0-2)
	sll	6,a0	     		; 64 bits / channel ram storage area
	addi	chan1ram,a0  		; a0 = our channel's ram         
	move	*a0(sndpri),a3,W 	; a3 = current priority		
	cmp	a3,a2		 	; who is more important ?
	jrlo	tune9		 	; not me...

	move	a2,*a0(sndpri),W 	; i am the new priority !!
	callr	do_tune_commands

tune9	PULL	a0,a1,a2,a3,a4,a5,a6

	rets

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
 SUBR	send_code_a3

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
	MOVI	6,A0
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

NO_ADD
	MMFM	SP,A1,A2
	MOVI	-1,A0
	RETS

ANNOUNCE_VOICE
	MOVE	@NEXT_ANN_QUEUE,A1,L
	MOVE	@CURRENT_ANN_QUEUE,A2,L
	CMP	A1,A2
	JREQ	NOTHING_TO_DO_NOW
	MOVE	*A2+,A0
	JRN	TIME_TO_DIE
	CMPI	EOF_ANNOUNCE_QUEUE,A2
	JRNE	NO_RESET_QUEUE2
	MOVI	ANNOUNCE_QUEUE,A2
NO_RESET_QUEUE2
	MOVE	A2,@CURRENT_ANN_QUEUE,L
	CMPI	0E0H,A0
	JRLT	DO_TRIPLE_SOUND
	CALLA	announcer_sound
	CALLA	PRCSLP
	JRUC	ANNOUNCE_VOICE

DO_TRIPLE_SOUND
	CALLA	triple_sound
	CALLA	PRCSLP
	JRUC	ANNOUNCE_VOICE

NOTHING_TO_DO_NOW
	SLOOP	1,ANNOUNCE_VOICE

TIME_TO_DIE
	DIE


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
	MOVE	A0,A0
	JRNN	OKAY
	LOCKUP
OKAY
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
	MOVI	CROWD_SOUND_PID,A0
	MOVI	-1,A1
	CALLA	EXISTP
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
	MOVE	A9,A0
	CALLA	PRCSLP
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
	MOVI	REPEAT_MODE_PID,A0
	MOVI	-1,A1
	CALLA	EXISTP
	JRZ	NO_DUMMY_TO_SET
	MOVI	80,A1
	MOVE	A1,*A0(PTIME)
NO_DUMMY_TO_SET
	PULL	A1
	RETS

REPEAT_DUMMY
	MOVE	A9,A0
	CALLA	PRCSLP
	CLR	A0
	MOVE	A0,@REPEAT_STATE
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
	.WORD	10,010H
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

	.WORD	GOING_TO_TOP_ROPE
	.WORD	GOING_TO_TOP
	.WORD	HERE_IT_COMES
	.WORD	AND_1

	.WORD	0
	.LONG	ROPES_CHEER
	.WORD	7,020H
JUMP_ROPES
	.WORD	KABOOM_OH,KABOOM
	.WORD	REPEAT_MODE,0
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
	CREATE0	PROC_MISSES
	RETS

PROC_MISSES
	SLEEP	5
	MOVI	MISSES,A2
	MOVI	700,A0
	CALLR	ADD_IF_SILENT
	DIE

	.WORD	-1
	.LONG	CROWD_FAIL
	.WORD	10,010H
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

	.WORD	A_MISS
	.WORD	AND_MISSES
	.WORD	ALMOST
	.WORD	R_REJECTED

CALL_SPECIAL_MOVE
	MOVE	*A13(WRESTLERNUM),A9
	CREATE0	PROC_SPECIAL_MOVE
	RETS

PROC_SPECIAL_MOVE
	SLEEP	10
	MOVE	A9,A5
	MOVI	SPECIAL_MOVE,A2
	MOVI	800,A0
	CALLR	ADD_IF_SILENT
	DIE

	.WORD	0
	.LONG	CROWD_SPECIAL
	.WORD	27,020H
SPECIAL_MOVE
	.WORD	END_GAME_STUFF,0
	.WORD	LISTEN_TO_THE_CROWD,0
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
	.WORD	LOOK_AT_THIS,0
	.WORD	R_DID_YOU_SEE_THAT,UNBEELEVABLE_0
	.WORD	WHAT_A_TURN_OF_EVENTS,R_INCREDIBLE
	.WORD	R_TASTE_OF_HIS_OWN,0
	.WORD	WHAT_A_BEATING,R_NICELY_DONE
	.WORD	I_WOULD_RECEIVE_THAT,0
	.WORD	R_LOOK_AT_THIS,CAN_YOU_BELIEVE_THAT
	.WORD	CAN_ANYBODY_STOP_HIM,R_INCREDIBLE
	.WORD	R_THATS_GOTTA_HURT,YES_V
	.WORD	WHAT_A_SLAM,R_IVE_NEVER_SEEN
	.WORD	I_CANT_WATCH_THIS,0
	.WORD	CAN_ANYBODY_STOP_HIM,0
	.WORD	R_I_THINK_HE_BROKE_IT,0
	.WORD	R_NOBODY_GETS_UP,0

	.WORD	LISTEN_TO_THE_CROWD,0
	.WORD	DID_YOU_SEE_THAT,0
	.WORD	THATS_GOTTA_HURT,0
	.WORD	NICELY_DONE,0

CALL_DROP_KICK
	MOVE	*A10(WRESTLERNUM),A9
	CREATE0	PROC_DROP_KICK
	RETS

PROC_DROP_KICK
	SLEEP	15
	MOVE	A9,A5
	MOVI	DROP_KICK,A2
	MOVI	600,A0
	CALLR	ADD_IF_SILENT
	DIE

	.WORD	0
	.LONG	CROWD_CHEER
	.WORD	16,010H
DROP_KICK
	.WORD	LISTEN_TO_THE_CROWD
	.WORD	REPEAT_MODE
	.WORD	NICELY_DONE
	.WORD	BOTH_MEN_DOWN
	.WORD	OH_MY
	.WORD	OH_THAT_HURTS_0
	.WORD	WITH_AUTHORITY
	.WORD	KABOOM
	.WORD	BOOMSHAKALAKA
	.WORD	R_TASTE_OF_HIS_OWN
	.WORD	VERY_IMPRESSIVE
	.WORD	ITS_PAND_OUT_THERE
	.WORD	WHAT_SPEED
	.WORD	TO_THE_FACE
	.WORD	AWESOME
	.WORD	GOODNIGHT
	.WORD	WHAT_A_BLOW

	.WORD	LISTEN_TO_THE_CROWD
	.WORD	NICELY_DONE
	.WORD	BOTH_MEN_DOWN
	.WORD	OH_MY

CALL_FACE_HIT
	MOVE	*A10(WRESTLERNUM),A9
	CREATE0	PROC_FACE_HIT
	RETS

PROC_FACE_HIT
	SLEEP	8
	MOVE	A9,A5
	MOVI	FACE_HIT,A2
	MOVI	300,A0
	CALLR	ADD_IF_SILENT
	DIE

	.WORD	0
	.LONG	CROWD_ORDINARY
	.WORD	7,010H
FACE_HIT
	.WORD	TO_THE_FACE
	.WORD	R_WHAT_SPEED
	.WORD	TO_THE_FACE
	.WORD	WHAT_POWER
	.WORD	TO_THE_FACE
	.WORD	WHAT_A_BLOW
	.WORD	HELLO
	.WORD	R_GOODNIGHT

	.WORD	TO_THE_FACE
	.WORD	WHAT_SPEED
	.WORD	R_WHAT_POWER
	.WORD	OH_MY

CALL_MID_HIT
	MOVE	*A10(WRESTLERNUM),A9
	CREATE0	PROC_MID_HIT
	RETS

PROC_MID_HIT
	SLEEP	8
	MOVE	A9,A5
	MOVI	MID_HIT,A2
	MOVI	300,A0
	CALLR	ADD_IF_SILENT
	DIE

	.WORD	0
	.LONG	CROWD_ORDINARY
	.WORD	7,010H
MID_HIT
	.WORD	TO_THE_MIDSECTION
	.WORD	WHAT_SPEED
	.WORD	TO_THE_MIDSECTION
	.WORD	R_WHAT_POWER
	.WORD	TO_THE_MIDSECTION
	.WORD	WHAT_SKILL
	.WORD	WHAT_A_BLOW
	.WORD	R_HELLO

	.WORD	TO_THE_MIDSECTION
	.WORD	WHAT_SPEED
	.WORD	R_WHAT_POWER
	.WORD	OH_MY

CALL_AVERAGE_MOVE
	MOVE	*A10(WRESTLERNUM),A9
	CREATE0	PROC_AVERAGE_MOVE
	RETS

CALL_ANI_AVERAGE_MOVE
	MOVE	*A13(WRESTLERNUM),A9
	CREATE0	PROC_AVERAGE_MOVE
	RETS

PROC_AVERAGE_MOVE
	SLEEP	10
	MOVE	A9,A5
	MOVI	AVERAGE_MOVE,A2
	MOVI	700,A0
	CALLR	ADD_IF_SILENT
	DIE

	.WORD	0
	.LONG	CROWD_CHEER
	.WORD	20,010H
AVERAGE_MOVE
	.WORD	END_GAME_STUFF
	.WORD	OH_THAT_HURTS_1
	.WORD	REPEAT_MODE
	.WORD	OH_0
	.WORD	WITH_AUTHORITY
	.WORD	NICELY_DONE
	.WORD	NICE_EXECUTION
	.WORD	OOOH_0
	.WORD	OH_MY_GOODNESS_2
	.WORD	R_RIGHT_TO_THE_KISSER
	.WORD	ITS_PAND_IN_THE_RING
	.WORD	WHAT_POWER
	.WORD	WHAT_SKILL
	.WORD	R_WHAT_AGILITY
	.WORD	R_AWESOME
	.WORD	R_HELLO
	.WORD	WHAT_A_BLOW
	.WORD	GOODNIGHT
	.WORD	MOST_IMPRESSIVE
	.WORD	AWESOME
	.WORD	R_IMPRESSIVE_MOVE

	.WORD	OH_THAT_HURTS_1
	.WORD	OH_0
	.WORD	WITH_AUTHORITY
	.WORD	NICELY_DONE

DO_REVERSAL
	push	a8
	MOVE	*A13(WRESTLERNUM),A5
	MOVI	REVERSAL,A2
	MOVI	700,A0
	CALLR	ADD_IF_SILENT
	pull	a8
	RETS

	.WORD	0
	.LONG	CROWD_CHEER
	.WORD	13,010H
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
	.WORD	WHAT
	.WORD	WHAT_THE
	.WORD	MOST_IMPRESSIVE
	.WORD	YES_V
	.WORD	WAIT_A_MINUTE

	.WORD	NO_WAIT_A_MINUTE
	.WORD	NICE_ESCAPE
	.WORD	WOW_1
	.WORD	LOOK_OUT

CALL_MISS_YOKO
	CREATE0	PROC_MISS_YOKO
	RETS

PROC_MISS_YOKO
	SLEEP	10
	MOVI	MISS_YOKO,A2
	MOVI	600,A0
	CALLR	ADD_IF_SILENT
	DIE

	.WORD	-1
	.LONG	0
	.WORD	5,010H
MISS_YOKO
	.WORD	FORGET_ABOUT_IT
	.WORD	R_THAT_WAS_DUMB
	.WORD	NOT_A_GOOD_IDEA
	.WORD	WHAT_WAS_HE_THINKING
	.WORD	AND_OH
	.WORD	REJECTED
;	.WORD	R_WHAT_WAS_HE_THINKING

	.WORD	FORGET_ABOUT_IT
	.WORD	R_THAT_WAS_DUMB
	.WORD	NOT_A_GOOD_IDEA
	.WORD	WHAT_WAS_HE_THINKING

	.WORD	-1
	.LONG	CROWD_THROWN
	.WORD	14,010H
THROWN_OUT
	.WORD	HEAVES_HIM
	.WORD	VERY_IMPRESSIVE
	.WORD	NICE_EXECUTION
	.WORD	UNBEELEVABLE_1
	.WORD	IVE_NEVER_SEEN_THAT
	.WORD	OH_THAT_HURTS_0
	.WORD	WITH_AUTHORITY
	.WORD	WHAT_A_TURN_OF_EVENTS
	.WORD	WHAT_POWER
	.WORD	R_WHAT_SPEED
	.WORD	WHAT_SKILL
	.WORD	R_WHAT_AGILITY
	.WORD	MAGNIFICENT
	.WORD	JUST_AWESOME

	.WORD	HEAVES_HIM
	.WORD	NICE_EXECUTION
	.WORD	UNBEELEVABLE_1
	.WORD	IVE_NEVER_SEEN_THAT

CALL_THROWN_OUT
	MOVE	*A13(WRESTLERNUM),A9
	CREATE0	PROC_THROWN_OUT
	RETS

PROC_THROWN_OUT
	SLEEP	10
	MOVE	A9,A5
	MOVI	THROWN_OUT,A2
	MOVI	700,A0
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
	.WORD	OH_THAT_HURTS_0
	.WORD	WITH_AUTHORITY
	.WORD	WHAT_A_TURN_OF_EVENTS
	.WORD	WHAT_POWER
	.WORD	R_WHAT_SPEED
	.WORD	WHAT_SKILL
	.WORD	R_WHAT_AGILITY
	.WORD	MAGNIFICENT
	.WORD	JUST_AWESOME

	.WORD	MAGNIFICENT
	.WORD	NICE_EXECUTION
	.WORD	UNBEELEVABLE_1
	.WORD	IVE_NEVER_SEEN_THAT

CALL_OTHER_AVERAGE
	MOVE	*A13(WRESTLERNUM),A9
	CREATE0	PROC_OTHER_AVERAGE
	RETS

PROC_OTHER_AVERAGE
	SLEEP	10
	MOVE	A9,A5
	MOVI	OTHER_AVERAGE,A2
	MOVI	700,A0
	CALLR	ADD_IF_SILENT
	DIE

CALL_NASTY_MOVE
	MOVE	*A13(WRESTLERNUM),A9
	CREATE0	PROC_NASTY_MOVE
	RETS

PROC_NASTY_MOVE
	SLEEP	10
	MOVE	A9,A5
	MOVI	NASTY_MOVE,A2
	MOVI	700,A0
	CALLR	ADD_IF_SILENT
	DIE

	.WORD	-1
	.LONG	CROWD_FAIL
	.WORD	8,020H
NASTY_MOVE
	.WORD	R_WHATS_GOING_ON,IS_THAT_LEGAL
	.WORD	HE_CANT_DO_THAT,R_SOMEONE_CALL_SECURITY
	.WORD	NOW_THAT_WAS_CHEAP,R_I_CANT_WATCH
	.WORD	THATS_NOT_VERY_FAIR,0
	.WORD	SOMEONE_CALL_SECURITY,0
	.WORD	THAT_WASNT_VERY_NICE,R_GOODNIGHT
	.WORD	I_CANT_WATCH_THIS,R_OH_VICIOUS
	.WORD	R_THATS_GOTTA_HURT,THATS_NOT_VERY_FAIR
	.WORD	SHOCKING,0

	.WORD	R_WHATS_GOING_ON,IS_THAT_LEGAL
	.WORD	HE_CANT_DO_THAT,R_SOMEONE_CALL_SECURITY
	.WORD	NOW_THAT_WAS_CHEAP,R_I_CANT_WATCH
	.WORD	THATS_NOT_VERY_FAIR,0

CALL_SETUP
	MOVE	*A13(WRESTLERNUM),A9
	CREATE0	PROC_SETUP_MOVE
	RETS

PROC_SETUP_MOVE
	SLEEP	5
	MOVE	A9,A5
	MOVI	SETUP_MOVE,A2
	MOVI	700,A0
	CALLR	ADD_IF_SILENT
	DIE

	.WORD	0
	.LONG	SETUP_TABLE
	.WORD	12,010H
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
	.WORD	IT_DOESNT_LOOK_GOOD

	.WORD	THIS_COULD_BE_IT
	.WORD	R_THIS_COULD_BE_IT
	.WORD	YOU_CANT_GET_ANY_CLOSER
	.WORD	WHAT_KEEPING_THEM_UP

CALL_MATCH_OVER
	CREATE0	PROC_MATCH_OVER
	RETS

PROC_MATCH_OVER
	SLEEP	5
	move	*a10(WRESTLERNUM),a5
	MOVE	@HCOUNT,A0
	SRL	1,A0
	JRNC	WRESTLER_SPEECH
	MOVI	MATCH_OVER,A2
	MOVI	900,A0
	CALLR	ADD_IF_SILENT
	DIE

	.WORD	-1
	.LONG	0
	.WORD	5,010H
MATCH_OVER
	.WORD	GIVE_CREDIT
	.WORD	TOTAL_DISASTER
	.WORD	TOTAL_DEBUNK
	.WORD	UNBEELEVABLE_0
	.WORD	CONGRATULATIONS
	.WORD	R_OH_YEAH

	.WORD	GIVE_CREDIT
	.WORD	TOTAL_DISASTER
	.WORD	TOTAL_DEBUNK
	.WORD	UNBEELEVABLE_0

WRESTLER_SPEECH
	SLL	5,A5
	ADDI	WHICH_WRESTLER_TALKS,A5
	MOVE	*A5,A2,L
	MOVI	500,A0
	CALLR	ADD_IF_SILENT
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
	.WORD	0

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
	.WORD	0

HIT_THE_MAT
	MOVK	4,A0
	CALLA	RNDRNG0
	SLL	4,A0
	ADDI	MATT_HITS,a0
	MOVE	*A0,A0
	CALLA	triple_sound
	RETS

	.WORD	4,010H
MATT_HITS
	.word	0BFH,0C1H,0C3H,0BH
	.word	0DH

SMALL_BOUNCE
	MOVK	2,A0
	CALLA	RNDRNG0
	SLL	4,A0
	ADDI	small_bounce_sounds,a0
	MOVE	*A0,A0
	CALLA	triple_sound
	RETS

SMALL_RUN
	MOVK	1,A0
	CALLA	RNDRNG0
	SLL	4,A0
	ADDI	small_bounce_sounds,a0
	MOVE	*A0,A0
	CALLA	triple_sound
	RETS

small_bounce_sounds
	.word	0C0H,0C2H,0DH

WALK_SOUND

	MOVI	046H,A0
	MOVE	@HCOUNT,A1
	SRL	1,A1
	JRNC	WALK_SET
	MOVI	047H,A0
WALK_SET
	CALLA	triple_sound
	RETS

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

;A11 = WHICH CHANNEL, -1 = MASTER
;A8 = TICKS TO FADE OVER
FADE_MASTER_VOL
	MOVI	ADJVOLUME,A0
	CALLA	GET_ADJ
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


******************************************************************************
	.end




