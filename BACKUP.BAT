@xcopy /A *.asm \modified
@xcopy /A *.equ \modified
@xcopy /A *.bat \modified
@move \backup\back8.zip \backup\back9.zip
@move \backup\back7.zip \backup\back8.zip
@move \backup\back6.zip \backup\back7.zip
@move \backup\back5.zip \backup\back6.zip
@move \backup\back4.zip \backup\back5.zip
@move \backup\back3.zip \backup\back4.zip
@move \backup\back2.zip \backup\back3.zip
@move \backup\back1.zip \backup\back2.zip
@del mc*
@del mk*.bat
@del *.axx
pkzip -i -x*.lst -x*.out -x*.obj -x*.tbl -x*.glo \backup\back1.zip \video\wwf\*.*
