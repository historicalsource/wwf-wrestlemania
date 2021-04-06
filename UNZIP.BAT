@echo off
c:
cls

echo.
echo.
choice /c:yn /tn,20 UNZIP CODE  
if errorlevel 2 goto art
cd \video\wwf
pkunzip -o \video\wwf\zips\code

:art
echo.
echo.
choice /c:yn /tn,20 UNZIP ART  
if errorlevel 2 goto done
cd \video\wwf\img
pkunzip -o \video\wwf\zips\bam
pkunzip -o \video\wwf\zips\dnk
pkunzip -o \video\wwf\zips\hrt
pkunzip -o \video\wwf\zips\lex
pkunzip -o \video\wwf\zips\rzr
pkunzip -o \video\wwf\zips\shn
pkunzip -o \video\wwf\zips\und
pkunzip -o \video\wwf\zips\yok

pkunzip -o \video\wwf\zips\art

:done
echo.
echo done...

cd \video\wwf
