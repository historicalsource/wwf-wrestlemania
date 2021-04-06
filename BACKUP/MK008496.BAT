echo off
set MAKE_EEK=
CRNCHLST >nul: wrestle.lst
if errorlevel 1 goto make_end
:make_end
