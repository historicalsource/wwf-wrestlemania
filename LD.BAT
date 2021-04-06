@echo off
c:
cd \video\wwf
cls
echo.
echo	*********** WWF image loader *************
echo.
echo.
echo		A.............load everything
echo.
echo		B.............build everything
echo.
echo		C.............build main.lod
echo.
echo		D.............build bam.lod
echo.
echo		E.............build bret.lod
echo.
echo		F.............build doink.lod
echo.
echo		G.............build lex.lod
echo.
echo		H.............build razor.lod
echo.
echo		I.............build shawn.lod
echo.
echo		J.............build taker.lod
echo.
echo		K.............build yoko.lod
echo.
echo		L.............build misc.lod
echo.
choice /C:ABCDEFGHIJKL	 "	Choose wisely! - "
echo.

if errorlevel 12 goto misc
if errorlevel 11 goto yoko
if errorlevel 10 goto taker
if errorlevel 9 goto shawn
if errorlevel 8 goto razor
if errorlevel 7 goto lex
if errorlevel 6 goto doink
if errorlevel 5 goto bret
if errorlevel 4 goto bam
if errorlevel 3 goto main
if errorlevel 2 goto buildall
if errorlevel 1 goto loadall


:misc
loadw misc /A /TS /FI /E
goto end

:yoko
loadw yoko /A /TS /FI /E
goto end

:taker
loadw taker /A /TS /FI /E
goto end

:shawn
loadw shawn /A /TS /FI /E
goto end

:razor
loadw razor /A /TS /FI /E
goto end

:lex
loadw lex /A /TS /FI /E
goto end

:doink
loadw doink /A /TS /FI /E
goto end

:bret
loadw bret /A /TS /FI /E
goto end

:bam
loadw bam /A /TS /FI /E
goto end

:main
loadw main /A /TS /FI /E
goto end

:buildall
del bgndpal.asm
del bgndtbl.asm
del bampal.asm
del bretpal.asm
del doinkpal.asm
del lexpal.asm
del razorpal.asm
del shawnpal.asm
del takerpal.asm
del yokopal.asm
del fontspal.asm
del imgpal.asm
del imgtbl.asm
del robopal.asm

loadw main /TS /FI /E
loadw bam /A /TS /FI /E
loadw bret /A /TS /FI /E
loadw doink /A /TS /FI /E
loadw lex /A /TS /FI /E
loadw razor /A /TS /FI /E
loadw shawn /A /TS /FI /E
loadw taker /A /TS /FI /E
loadw yoko /A /TS /FI /E
loadw misc /A /TS /FI /E
copy bgndglo.txt + bgndtbl.asm temp.xyz
copy temp.xyz bgndtbl.asm
copy bgndglo.txt + bgndpal.asm temp.xyz
copy temp.xyz bgndpal.asm
del temp.xyz
goto end

:loadall
loadw main /RI /E
loadw bam /RI /E
loadw bret /RI /E
loadw doink /RI /E
loadw lex /RI /E
loadw razor /RI /E
loadw shawn /RI /E
loadw taker /RI /E
loadw yoko /RI /E
loadw misc /RI /E
goto end

:end

del junkxxxx
del *.~sm
del *.~bl
del l2temp
echo.
echo.
echo.
echo	done...
echo.

