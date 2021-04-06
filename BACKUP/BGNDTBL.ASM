	include	bgndtbl.glo

	.OPTION	B,D,L,T
	.include	"BGNDTBL.GLO"
	.DATA

ing9HDRS:
	.word	12,9	;x size, y size
	.long	0333DE02H	;address
	.word	06000H	;dma ctrl
	.word	72,31
	.long	0333E08AH
	.word	05000H
	.word	68,121
	.long	03340C22H
	.word	07000H
	.word	68,63
	.long	0334ED1EH
	.word	06000H
	.word	224,72
	.long	03355186H
	.word	00H
	.word	104,91
	.long	03374986H
	.word	00H
	.word	56,75
	.long	03387146H
	.word	06000H
	.word	76,55
	.long	0338D3B6H
	.word	06000H
	.word	60,67
	.long	033935AEH
	.word	06000H
	.word	28,86
	.long	033993E6H
	.word	06000H
	.word	72,47
	.long	0339CC56H
	.word	06000H
	.word	96,51
	.long	033A1BA6H
	.word	06000H
	.word	108,129
	.long	033A8E66H
	.word	06000H
	.word	76,32
	.long	033BD4EEH
	.word	05000H
	.word	48,47
	.long	033C046EH
	.word	06000H
	.word	72,96
	.long	033C394EH
	.word	06000H
	.word	20,28
	.long	033CDB4EH
	.word	06000H
	.word	92,173
	.long	033CE86EH
	.word	00H
	.word	68,31
	.long	033ED9CEH
	.word	05000H
	.word	76,64
	.long	033F02FAH
	.word	00H
	.word	60,177
	.long	033F9AFAH
	.word	06000H
	.word	100,71
	.long	034093E2H
	.word	06000H
	.word	144,92
	.long	03413A4AH
	.word	06000H
	.word	60,76
	.long	034270CAH
	.word	06000H
	.word	100,132
	.long	0342DBAAH
	.word	06000H
	.word	104,176
	.long	0344110AH
	.word	00H
	.word	124,113
	.long	03464D0AH
	.word	00H
	.word	48,71
	.long	034802EAH
	.word	06000H
	.word	92,66
	.long	034852CAH
	.word	06000H
	.word	40,59
	.long	0348E11AH
	.word	06000H
	.word	40,61
	.long	0349186AH
	.word	06000H
	.word	124,176
	.long	0349519AH
	.word	00H
	.word	72,172
	.long	034BFB9AH
	.word	00H
	.word	108,71
	.long	034D7E9AH
	.word	06000H
	.word	56,33
	.long	034E3252H
	.word	06000H
	.word	36,34
	.long	034E5DA2H
	.word	06000H
	.word	112,97
	.long	034E7A52H
	.word	00H
	.word	152,75
	.long	034FCDD2H
	.word	00H
	.word	64,68
	.long	03513212H
	.word	00H
	.word	156,99
	.long	0351BA12H
	.word	00H
	.word	224,109
	.long	03539CB2H
	.word	07000H
	.word	68,69
	.long	03563852H
	.word	06000H
	.word	44,34
	.long	0356A64AH
	.word	06000H
	.word	12,98
	.long	0356C95AH
	.word	05000H
	.word	80,19
	.long	0356E052H
	.word	06000H
	.word	60,48
	.long	035703F2H
	.word	06000H
	.word	36,63
	.long	03574772H
	.word	06000H
	.word	108,67
	.long	03577C9AH
	.word	05000H
	.word	48,36
	.long	035809EEH
	.word	06000H
	.word	116,75
	.long	0358326EH
	.word	06000H
	.word	232,9
	.long	0358FE56H
	.word	06000H
	.word	12,12
	.long	03592F46H
	.word	05000H
	.word	44,13
	.long	03593216H
	.word	06000H
	.word	8,93
	.long	03593F7EH
	.word	05000H
	.word	44,37
	.long	03594E06H
	.word	06000H
	.word	28,61
	.long	0359742EH
	.word	05000H
	.word	36,75
	.long	0359958AH
	.word	00H
	.word	152,99
	.long	0359E9EAH
	.word	00H
	.word	172,6
	.long	035BC02AH
	.word	06000H
	.word	136,66
	.long	035BD85AH
	.word	05000H
	.word	36,35
	.long	035C87AAH
	.word	06000H
	.word	192,75
	.long	035CA532H
	.word	00H
	.word	120,109
	.long	035E6732H
	.word	07000H
	.word	36,32
	.long	035FCCDAH
	.word	06000H
	.word	52,38
	.long	035FE7DAH
	.word	06000H
	.word	228,39
	.long	0360162AH
	.word	06000H
	.word	52,99
	.long	0360E692H
	.word	00H
	.word	56,66
	.long	03618772H
	.word	00H
	.word	96,111
	.long	0361FAF2H
	.word	06000H
	.word	44,36
	.long	0362F4B2H
	.word	06000H
	.word	100,9
	.long	036319D2H
	.word	06000H
	.word	100,6
	.long	03632EEAH
	.word	06000H
	.word	72,109
	.long	03633CFAH
	.word	06000H
	.word	100,99
	.long	0363F4EAH
	.word	00H
	.word	124,66
	.long	03652A4AH
	.word	05000H
	.word	52,36
	.long	0365CA22H
	.word	06000H
	.word	44,36
	.long	0365F602H
	.word	06000H
	.word	104,66
	.long	03661B22H
	.word	05000H
	.word	60,49
	.long	0366A132H
	.word	06000H
	.word	220,75
	.long	0366E61AH
	.word	00H
	.word	76,68
	.long	0368E9BAH
	.word	00H
	.word	72,97
	.long	03698B3AH
	.word	00H
	.word	248,36
	.long	036A657AH
	.word	00H
	.word	196,73
	.long	036B7C7AH
	.word	00H
	.word	96,111
	.long	036D3B9AH
	.word	00H
	.word	104,92
	.long	036E889AH
	.word	00H
	.word	40,63
	.long	036FB39AH
	.word	00H
	.word	72,78
	.long	0370025AH
	.word	06000H
	.word	104,102
	.long	037085FAH
	.word	06000H
ringBLKS:
	.word	04046H	;flags
	.word	0,0 ;x,y
	.word	00H	;pal5,pal4,hdr13-0
	.word	04044H,155,586,01H
	.word	04050H,176,744,02H
	.word	03F49H,183,626,03H
	.word	06A40H,183,796,04H
	.word	03F40H,186,764,05H
	.word	04044H,198,618,06H
	.word	04444H,201,524,07H
	.word	04040H,201,691,01008H
	.word	0414AH,203,687,09H
	.word	03F44H,203,579,0AH
	.word	03F44H,203,693,0BH
	.word	0264BH,209,461,0CH
	.word	04044H,219,612,0DH
	.word	04444H,227,519,01H
	.word	04050H,241,686,02H
	.word	03F49H,248,626,03H
	.word	04044H,254,646,0EH
	.word	02144H,265,367,0FH
	.word	04040H,272,687,01010H
	.word	04444H,274,551,06H
	.word	04040H,287,682,011H
	.word	02144H,293,377,012H
	.word	04444H,295,547,0DH
	.word	03E40H,297,689,013H
	.word	04049H,313,626,03H
	.word	0284BH,316,430,014H
	.word	04444H,330,579,0EH
	.word	02144H,334,408,07H
	.word	02144H,335,463,0AH
	.word	04DH,336,305,015H
	.word	044FH,338,376,016H
	.word	02144H,359,404,01H
	.word	02E4BH,363,542,017H
	.word	02A4BH,374,446,018H
	.word	04150H,376,567,02H
	.word	04040H,378,679,019H
	.word	04040H,383,566,01AH
	.word	02C4CH,395,523,01BH
	.word	06A40H,403,796,04H
	.word	02144H,406,435,06H
	.word	02144H,427,432,0DH
	.word	024EH,434,310,01CH
	.word	04150H,442,508,02H
	.word	0244CH,450,477,01DH
	.word	0640H,461,429,0101EH
	.word	02144H,462,463,0EH
	.word	04040H,480,679,01FH
	.word	044FH,480,376,016H
	.word	04040H,506,507,020H
	.word	0841H,507,435,01021H
	.word	0E4AH,517,474,022H
	.word	04DH,529,305,015H
	.word	0124AH,576,473,023H
	.word	04040H,578,582,024H
	.word	04040H,578,507,025H
	.word	06940H,586,689,026H
	.word	04040H,589,756,027H
	.word	06446H,594,580,01028H
	.word	0640H,609,418,0101EH
	.word	0A42H,611,440,01029H
	.word	0404AH,620,473,02AH
	.word	044FH,622,376,016H
	.word	06A40H,623,796,04H
	.word	024EH,630,310,01CH
	.word	06842H,640,585,02BH
	.word	06455H,641,665,02CH
	.word	06944H,648,700,0102DH
	.word	06747H,649,585,02EH
	.word	06940H,649,689,02FH
	.word	0104CH,671,471,030H
	.word	0C43H,675,434,01031H
	.word	06445H,691,669,032H
	.word	06558H,716,577,033H
	.word	06445H,719,587,034H
	.word	06448H,719,497,035H
	.word	04DH,721,305,015H
	.word	0164AH,723,470,036H
	.word	06545H,724,502,01037H
	.word	04040H,727,507,038H
	.word	04040H,744,756,039H
	.word	04040H,746,507,038H
	.word	06445H,752,589,03AH
	.word	06940H,757,689,03BH
	.word	044FH,764,376,016H
	.word	0184AH,770,472,03CH
	.word	04040H,774,507,038H
	.word	04040H,774,507,038H
	.word	0841H,789,436,01021H
	.word	04040H,799,507,03DH
	.word	06446H,816,580,0103EH
	.word	024EH,818,311,01CH
	.word	01A4AH,820,475,03FH
	.word	06A40H,842,796,04H
	.word	01C4AH,859,469,040H
	.word	06944H,877,707,01041H
	.word	04040H,893,756,042H
	.word	06940H,893,689,043H
	.word	0541H,894,382,044H
	.word	01E4AH,914,471,045H
	.word	06445H,921,669,046H
	.word	06445H,922,589,047H
	.word	06446H,933,580,01048H
	.word	04040H,943,756,049H
	.word	06840H,947,689,04AH
	.word	0124AH,966,473,023H
	.word	04DH,974,305,015H
	.word	0841H,976,436,01021H
	.word	044FH,977,376,016H
	.word	04046H,980,0,00H
	.word	04050H,987,507,03DH
	.word	06456H,1000,580,0103EH
	.word	0144AH,1008,471,04BH
	.word	06455H,1019,669,032H
	.word	06455H,1019,589,03AH
	.word	04050H,1040,756,039H
	.word	06940H,1047,689,04AH
	.word	0224AH,1061,471,04CH
	.word	06A40H,1061,796,04H
	.word	024EH,1073,310,01CH
	.word	0C43H,1080,432,01031H
	.word	0104CH,1099,471,030H
	.word	0640H,1104,423,0101EH
	.word	06456H,1118,580,01028H
	.word	044FH,1119,376,016H
	.word	0E4AH,1150,474,022H
	.word	04DH,1163,305,015H
	.word	06940H,1170,689,04DH
	.word	06455H,1179,587,034H
	.word	04040H,1179,507,038H
	.word	06555H,1188,501,01037H
	.word	04050H,1191,756,027H
	.word	0A42H,1198,439,01029H
	.word	04040H,1207,507,038H
	.word	0164AH,1210,470,036H
	.word	06548H,1214,577,033H
	.word	06458H,1215,497,035H
	.word	06445H,1217,665,02CH
	.word	06944H,1221,704,0104EH
	.word	04040H,1241,507,04FH
	.word	04050H,1245,582,024H
	.word	06757H,1252,585,02EH
	.word	0184AH,1258,472,03CH
	.word	024EH,1260,310,01CH
	.word	044FH,1261,376,016H
	.word	0841H,1268,437,01021H
	.word	06940H,1274,689,050H
	.word	06A40H,1281,796,04H
	.word	06852H,1285,585,02BH
	.word	01C4AH,1302,469,040H
	.word	04050H,1332,679,01FH
	.word	04DH,1350,305,015H
	.word	01E4AH,1357,471,045H
	.word	04040H,1357,582,051H
	.word	0C43H,1376,432,01031H
	.word	0144AH,1401,471,04BH
	.word	044FH,1403,376,016H
	.word	03F50H,1428,566,01AH
	.word	04040H,1443,580,052H
	.word	024EH,1450,310,01CH
	.word	0404AH,1450,473,02AH
	.word	04050H,1454,679,019H
	.word	04040H,1458,507,053H
	.word	04040H,1484,616,052H
	.word	0A42H,1489,438,01029H
	.word	01A4AH,1495,475,03FH
	.word	06A40H,1500,796,04H
	.word	04040H,1524,652,052H
	.word	02154H,1531,462,0EH
	.word	02154H,1538,430,0DH
	.word	04DH,1541,305,015H
	.word	044FH,1545,376,016H
	.word	04050H,1557,683,011H
	.word	04040H,1563,687,052H
	.word	02154H,1579,434,06H
	.word	04250H,1601,519,054H
	.word	04040H,1603,723,052H
	.word	02154H,1611,401,01H
	.word	04140H,1629,507,02H
	.word	02154H,1632,406,07H
	.word	02154H,1634,461,0AH
	.word	04040H,1644,759,052H
	.word	0245CH,1647,473,01DH
	.word	04040H,1649,763,055H
	.word	04250H,1656,574,054H
	.word	02A5BH,1664,444,018H
	.word	02154H,1681,374,012H
	.word	04250H,1685,578,056H
	.word	04040H,1686,795,052H
	.word	04140H,1694,565,02H
	.word	02C5CH,1698,518,01BH
	.word	02154H,1705,365,0FH
	.word	02E5BH,1717,541,017H
	.word	04250H,1717,632,054H
	.word	06A40H,1720,796,04H
	.word	04040H,1725,831,052H
	.word	04140H,1759,623,02H
	.word	04254H,1761,579,0EH
	.word	0285BH,1764,429,014H
	.word	04454H,1768,547,0DH
	.word	04543H,1769,626,057H
	.word	04250H,1777,688,054H
	.word	04250H,1807,692,056H
	.word	04454H,1809,551,06H
	.word	0265BH,1823,460,0CH
	.word	04140H,1823,681,02H
	.word	04250H,1837,743,054H
	.word	04264H,1837,626,0AH
	.word	04543H,1840,631,058H
	.word	04454H,1841,519,01H
	.word	04454H,1862,523,07H
	.word	04454H,1864,579,0AH
	.word	03249H,1878,727,03H
	.word	04140H,1888,739,02H
	.word	07374H,1907,624,0AH
	.word	0FFFFH	;End Marker
ringBMOD:
	.word	1979,868,215	;x size, y size, #blocks
	.long	ringBLKS, ing9HDRS, ing9PALS

kpgHDRS:
	.word	204,133	;x size, y size
	.long	03717E9AH	;address
	.word	05000H	;dma ctrl
	.word	204,119
	.long	03739086H
	.word	05000H
	.word	204,5
	.long	03756AAAH
	.word	04000H
	.word	196,133
	.long	03757A9AH
	.word	05000H
	.word	196,119
	.long	037777BEH
	.word	05000H
	.word	196,5
	.long	03793F4AH
	.word	04000H
	.word	76,62
	.long	03794E9AH
	.word	04680H
	.word	76,62
	.long	03797D12H
	.word	04680H
wwfblankBLKS:
	.word	0140H	;flags
	.word	0,0 ;x,y
	.word	00H	;pal5,pal4,hdr13-0
	.word	0140H,0,133,01H
	.word	04040H,0,251,02H
	.word	0140H,204,0,03H
	.word	0140H,204,133,04H
	.word	04040H,204,251,05H
	.word	0FFFFH	;End Marker
slateBLKS:
	.word	0140H	;flags
	.word	0,133 ;x,y
	.word	01H	;pal5,pal4,hdr13-0
	.word	0140H,0,0,00H
	.word	04040H,0,251,02H
	.word	04041H,17,12,06H
	.word	04042H,17,178,07H
	.word	04041H,157,12,06H
	.word	04042H,157,178,07H
	.word	0140H,204,133,04H
	.word	0140H,204,0,03H
	.word	04040H,204,251,05H
	.word	04041H,298,12,06H
	.word	04042H,298,178,07H
	.word	0FFFFH	;End Marker
wwfblankBMOD:
	.word	400,256,6	;x size, y size, #blocks
	.long	wwfblankBLKS, kpgHDRS, kpgPALS
slateBMOD:
	.word	400,256,12	;x size, y size, #blocks
	.long	slateBLKS, kpgHDRS, kpgPALS

ELBKHDRS:
	.word	76,62	;x size, y size
	.long	0379AB8AH	;address
	.word	04680H	;dma ctrl
	.word	76,62
	.long	0379DA02H
	.word	04680H
	.word	204,133
	.long	037A087AH
	.word	05000H
	.word	204,119
	.long	037C1A66H
	.word	05000H
	.word	204,5
	.long	037DF48AH
	.word	04000H
	.word	128,9
	.long	037E047AH
	.word	04080H
	.word	8,135
	.long	037E1672H
	.word	04000H
	.word	124,61
	.long	037E2752H
	.word	05000H
	.word	124,145
	.long	037EBB0EH
	.word	05000H
	.word	40,44
	.long	03801A3AH
	.word	05080H
	.word	196,133
	.long	03803C7EH
	.word	05000H
	.word	196,119
	.long	038239A2H
	.word	05000H
	.word	196,5
	.long	0384012EH
	.word	04000H
	.word	124,145
	.long	0384107EH
	.word	05000H
	.word	124,61
	.long	03856FAAH
	.word	05000H
wwfselbkBLKS:
	.word	0545H	;flags
	.word	0,13 ;x,y
	.word	00H	;pal5,pal4,hdr13-0
	.word	0546H,0,177,01H
	.word	0143H,44,0,02H
	.word	0143H,44,133,03H
	.word	04043H,44,251,04H
	.word	0240H,54,236,05H
	.word	0243H,54,101,06H
	.word	0343H,54,36,06H
	.word	0A51H,59,175,07H
	.word	0A51H,59,30,08H
	.word	0545H,200,7,00H
	.word	0546H,200,186,01H
	.word	04044H,204,180,09H
	.word	04044H,204,90,09H
	.word	04044H,204,45,09H
	.word	04044H,204,135,09H
	.word	04044H,244,180,09H
	.word	04044H,244,135,09H
	.word	04044H,244,90,09H
	.word	04044H,244,45,09H
	.word	0143H,248,0,0AH
	.word	0143H,248,133,0BH
	.word	04043H,248,251,0CH
	.word	0A42H,300,30,0DH
	.word	0A42H,300,175,0EH
	.word	0240H,304,236,05H
	.word	0545H,400,13,00H
	.word	0546H,400,177,01H
	.word	0253H,421,101,06H
	.word	0353H,421,36,06H
	.word	0FFFFH	;End Marker
wwfselbkBMOD:
	.word	476,256,30	;x size, y size, #blocks
	.long	wwfselbkBLKS, ELBKHDRS, ELBKPALS

ERHDRS:
	.word	92,66	;x size, y size
	.long	03860366H	;address
	.word	06980H	;dma ctrl
	.word	100,40
	.long	03867236H
	.word	07000H
	.word	72,61
	.long	0386DF96H
	.word	06580H
	.word	144,92
	.long	038726AEH
	.word	06080H
	.word	192,2
	.long	03885BBEH
	.word	04000H
	.word	192,2
	.long	038861BEH
	.word	04000H
	.word	192,2
	.long	038867BEH
	.word	04000H
	.word	100,71
	.long	03886DBEH
	.word	06980H
	.word	12,84
	.long	0388F666H
	.word	05080H
LADDERBLKS:
	.word	05841H	;flags
	.word	0,118 ;x,y
	.word	00H	;pal5,pal4,hdr13-0
	.word	06440H,8,260,01H
	.word	05647H,9,71,02H
	.word	05948H,10,183,03H
	.word	05A54H,68,190,04H
	.word	05A55H,68,214,05H
	.word	05A56H,68,236,06H
	.word	05742H,84,112,07H
	.word	05647H,93,10,02H
	.word	06440H,107,260,01H
	.word	05647H,138,96,02H
	.word	05948H,151,183,03H
	.word	05841H,177,117,00H
	.word	05647H,201,30,02H
	.word	06440H,206,260,01H
	.word	05A43H,260,176,08H
	.word	05742H,264,112,07H
	.word	05A46H,269,236,06H
	.word	05A44H,270,190,04H
	.word	05A45H,270,214,05H
	.word	05647H,280,70,02H
	.word	05948H,292,183,03H
	.word	06440H,305,260,01H
	.word	05647H,342,5,02H
	.word	05841H,364,117,00H
	.word	06440H,404,260,01H
	.word	05647H,408,80,02H
	.word	05948H,433,183,03H
	.word	05742H,454,112,07H
	.word	05A56H,461,236,06H
	.word	05A54H,462,190,04H
	.word	05A55H,462,214,05H
	.word	05647H,502,52,02H
	.word	06440H,503,260,01H
	.word	05841H,552,117,00H
	.word	05647H,570,100,02H
	.word	05948H,574,183,03H
	.word	05647H,597,16,02H
	.word	06440H,602,260,01H
	.word	05742H,637,112,07H
	.word	05647H,643,82,02H
	.word	05A43H,653,176,08H
	.word	05A45H,662,214,05H
	.word	05A46H,662,236,06H
	.word	05A44H,662,190,04H
	.word	06440H,701,260,01H
	.word	05647H,711,28,02H
	.word	05948H,716,182,03H
	.word	05841H,726,116,00H
	.word	05647H,774,67,02H
	.word	05647H,790,0,02H
	.word	06440H,800,260,01H
	.word	05742H,809,111,07H
	.word	04040H,899,260,01H
	.word	0FFFFH	;End Marker

;file LADDER blocks not in any module
;	.word	04056H	;flags
;	.word	1388,337 ;x,y
;	.word	06H	;pal5,pal4,hdr13-0
;	.word	04054H,1389,291,04H
;	.word	04055H,1389,315,05H
;	.word	04040H,1438,361,01H
;	.word	04040H,1537,361,01H
;	.word	04043H,1580,277,08H
;	.word	04044H,1590,291,04H
;	.word	04045H,1590,315,05H
;	.word	04046H,1590,337,06H
;	.word	04040H,1636,361,01H
;	.word	04040H,1735,361,01H
;	.word	0FFFFH	;End Marker
LADDERBMOD:
	.word	999,300,54	;x size, y size, #blocks
	.long	LADDERBLKS, ERHDRS, ERPALS

PGHDRS:
	.word	200,131	;x size, y size
	.long	0389096EH	;address
	.word	00H	;dma ctrl
	.word	200,125
	.long	038C3C2EH
	.word	00H
	.word	200,77
	.long	038F496EH
	.word	0F80H
	.word	88,81
	.long	0390F216H
	.word	04E80H
	.word	36,24
	.long	0391171EH
	.word	04580H
	.word	120,102
	.long	03911B9EH
	.word	04B80H
	.word	192,10
	.long	039156BEH
	.word	03080H
	.word	100,71
	.long	03916CE0H
	.word	04D80H
	.word	124,16
	.long	03919750H
	.word	02080H
	.word	92,52
	.long	0391A686H
	.word	0480H
	.word	104,102
	.long	03921CDEH
	.word	04B80H
	.word	192,67
	.long	039258FEH
	.word	080H
	.word	200,131
	.long	0393E59EH
	.word	00H
	.word	200,125
	.long	0397185EH
	.word	00H
	.word	144,92
	.long	039A259EH
	.word	04F80H
	.word	88,55
	.long	039AA03EH
	.word	04A80H
LAVAPGBLKS:
	.word	04043H	;flags
	.word	0,125 ;x,y
	.word	00H	;pal5,pal4,hdr13-0
	.word	04043H,1,0,01H
	.word	05F41H,2,102,02H
	.word	04044H,8,153,03H
	.word	04044H,12,91,04H
	.word	04044H,77,28,05H
	.word	04042H,109,79,06H
	.word	04044H,124,154,07H
	.word	04040H,140,198,08H
	.word	05F45H,158,19,09H
	.word	04044H,196,31,0AH
	.word	05F41H,199,103,0BH
	.word	04043H,200,126,0CH
	.word	04043H,201,0,0DH
	.word	04044H,229,133,0EH
	.word	04044H,316,66,0FH
	.word	0FFFFH	;End Marker
LAVAPGBMOD:
	.word	404,257,16	;x size, y size, #blocks
	.long	LAVAPGBLKS, PGHDRS, PGPALS
