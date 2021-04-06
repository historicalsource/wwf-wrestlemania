echo off
set MAKE_EEK=
CRNCHLST >nul: display.lst
if errorlevel 1 goto make_end
:make_end
