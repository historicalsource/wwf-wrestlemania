/*	Game linker command file				*/
-e WARMSET		/* entry point of program		*/
-f 0xFFFF		/* fill unspecified memory with value	*/
-o d:\wrestle.out	/* specify output file			*/
-m d:\wrestle.map	/* map file				*/
-s			/* Kill the symbol table		*/
display.obj		/*IMAGE HANDLER*/
main.obj		/*INITIALIZATION AND INTERRUPTS*/
util.obj		/*UTILITIES*/
pal.obj			/*PALETTE ROUTINES*/
mproc.obj		/*MULTI-TASKER*/
bakgnd.obj		/*BACKGROUND GENERATOR*/
bgndtbl.obj		/*BACKGROUND TABLES*/
bgndpal.obj		/*BACKGROUND PALETTES*/
wrespal.obj

imgpal.obj
ropeimg.obj
miscimg.obj

bamimg.obj
bretimg.obj
doinkimg.obj
leximg.obj
razorimg.obj
shawnimg.obj
takerimg.obj
yokoimg.obj

wrestle.obj		/*FIRST GAME MODULE*/
wrestle2.obj
anim.obj
special.obj
getup.obj
drone.obj
award.obj
dcssound.obj
patch.obj
text.obj
attract.obj
string.obj
square.obj
adjust.obj
audit.obj
test.obj
diag.obj
menu.obj
hstd.obj
select.obj
/* robo.obj
coll2.obj */
tables.obj
ropes.obj
lifebar.obj
screen.obj
progress.obj
firework.obj
stories.obj

react1.obj
react2.obj
react3.obj
react4.obj
react5.obj
react6.obj
react7.obj
react8.obj
react9.obj

bam.obj
bret.obj
doink.obj
razor.obj
lex.obj
shawn.obj
taker.obj
yoko.obj

bamseq1.obj
bamseq2.obj
bamseq3.obj
bamseq4.obj

dnkseq1.obj
dnkseq2.obj
dnkseq3.obj
dnkseq4.obj

hrtseq1.obj
hrtseq2.obj
hrtseq3.obj
hrtseq4.obj

lexseq1.obj
lexseq2.obj
lexseq3.obj
lexseq4.obj

rzrseq1.obj
rzrseq2.obj
rzrseq3.obj
rzrseq4.obj

shnseq1.obj
shnseq2.obj
shnseq3.obj
shnseq4.obj

undseq1.obj
undseq2.obj
undseq3.obj
undseq4.obj

yokseq1.obj
yokseq2.obj
yokseq3.obj
yokseq4.obj

finiseq.obj

collis.obj
crowd.obj


MEMORY        			/* set up memory for sdb board */
{
 SCRATCH	: org = 0x01000000,	len = 0x3F7300
 SCRATCH2	: org = 0x013F7300,	len = 0x8D00
 ROM		: org = 0xFF800000,	len = 0x7FFC00
 TRAP31		: org = 0xFFFFFC00,	len = 0x400
 IROM		: org = 0x02000000,	len = 0x400000
}

SECTIONS       /* linker sections directive */
 {
	VECTORS:  {} 	> TRAP31
	GROUP:
	      {
		unzip: {}
		FIXED: {}
		OFIXED: {}
	       .bss: {}
	      } > SCRATCH

	.text:	{}	> ROM
	.data:	{}	> ROM

 }
                                                        

/* END								*/
