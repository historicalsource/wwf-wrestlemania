cd c:\video\wwf\zips\back
xcopy c:\video\wwf\*.asm /a
xcopy c:\video\wwf\*.equ /a
xcopy c:\video\wwf\*.h /a
xcopy c:\video\wwf\makefile /a
xcopy c:\video\wwf\make.ini /a
xcopy c:\video\wwf\*.cmd /a
xcopy c:\video\wwf\*.bat /a
xcopy c:\video\wwf\img\*.bat /a
xcopy c:\video\wwf\img\*.lod /a
xcopy c:\video\wwf\img\*.ld1 /a
xcopy c:\video\wwf\img\*.bdb /a
xcopy c:\video\wwf\img\*.bdd /a
xcopy c:\video\wwf\img\*.img /a
pkzip stuff.zip *.*
split stuff 500 zip
