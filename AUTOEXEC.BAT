rem @loadhigh C:\DOS\SHARE.EXE /l:500 /f:5100
@echo off
PATH C:\DOS;d:\;c:\bat;c:\bin;c:\brief;c:\norton;c:\mw;c:\ca\bin;c:\ca\binb;c:\windows;C:\laplink\
set mouse=c:\mouse
c:\qemm\loadhi /r:2 C:\DOS\mouse
rem c:\qemm\loadhi /r:2 C:\DOS\smartdrv.exe
c:\qemm\loadhi /r:3 c:\uv\uv /l
c:\qemm\loadhi /r:1 C:\DOS\doskey /insert
set temp=d:
set tmp=d:
set dircmd=/o
set bpath=c:\brief\macros
set bhelp=c:\brief\help
set bfile=c:\brief\state.rst
set bbackup=c:\brief\backup
set bsuffix=ASM
set bflags=-i120k2l130Mpu100 -mSL -mrestore -m120 -Dega -D101key
set btmp=d:\
set bcasm="!make"
set bcc="!cl /c /W2 /Od %%s.c"
set lib=c:\ca\lib
set include=c:\ca\include
set link=/CP:1
set helpfiles=c:\ca\help\*.hlp
set init=c:\ca\init
set asmex=c:\ca\samples
set imgdir=c:\video\wwf\img
set srcdir=c:\video\wwf
set vdadir=c:\video\bball\vda
set artaddr=2a0
set trgtaddr=280
set mwmouse=32
set mwcard=560
set mwpath=c:\mw
set mwfont=system08.fnt
set tvpath=d:
set tvparm=d:
set tvopts=/v80,50
set itusr1=g:\wwf\img\dnk
set itusr2=g:\wwf\img\bam
set itusr3=g:\wwf\img\und
ldkey
copy c:\command.com d:
copy c:\brief\e.exe d:
copy c:\brief\101key.drv d:
copy c:\bin\make.exe d:
copy c:\bin\gspa.exe d:
copy c:\bin\gsplnk.exe d:
copy c:\bin\tv.exe d:
copy c:\bin\crnchlst.exe d:
copy c:\bin\preasm.exe d:
mkdir d:\mw
copy c:\mw\*.* d:\mw
cd video\wwf
copy make.ini d:
copy wrestle.tvs d:
copy wrestle.map d:
copy wrestle.cmd d:
C:\DOS\mode con rate=30 delay=1
prompt $p$g
echo *********************************
echo * Wrestlemania development mode *
echo *********************************


