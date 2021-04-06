@echo off
c:
cd \video\wwf\zips
cls

echo.
echo.
choice /c:yn /tn,20 ZIP CODE  
if errorlevel 2 goto art
move /Y code.zip back
pkzip code \video\wwf\*.* -x*.obj -x*.lst -x*.out -x*.tbl -x*.map -x*.zip -x*.glo -x*.rst -x*.tvs

:art
echo.
echo.
choice /c:yn /tn,20 ZIP ART  
if errorlevel 2 goto done

move /Y bam.zip back
pkzip bam \video\wwf\img\bam_???.img bam.lod -x*.~mg

move /Y dnk.zip back
pkzip dnk \video\wwf\img\dnk_???.img doink.lod -x*.~mg

move /Y hrt.zip back
pkzip hrt \video\wwf\img\hrt_???.img hrt.lod -x*.~mg

move /Y lex.zip back
pkzip lex \video\wwf\img\lex_???.img lex.lod -x*.~mg

move /Y rzr.zip back
pkzip rzr \video\wwf\img\rzr_???.img razor.lod -x*.~mg

move /Y shn.zip back
pkzip shn \video\wwf\img\shn_???.img shawn.lod -x*.~mg

move /Y und.zip back
pkzip und \video\wwf\img\und_???.img taker.lod -x*.~mg

move /Y yok.zip back
pkzip yok \video\wwf\img\yok_???.img yoko.lod -x*.~mg

move /Y art.zip back
pkzip art \video\wwf\img\*.* -x???_???.img -x*.irw -x*.out -x*.zip -x*.rst -x*.~mg

:done
echo.
echo done...

cd \video\wwf
