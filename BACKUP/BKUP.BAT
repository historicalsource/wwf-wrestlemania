@echo Backing up DOC directory...
c:
cd \video\doc
i:
cd \video\doc
xcopy c:*.doc /m /v
@echo Backing up Wrestlemania...
c:
cd \video\wwf
i:
cd \video\wwf
xcopy c:*.asm /m /v
xcopy c:*.equ /m /v
xcopy c:*.h /m /v
xcopy c:makefile /m /v
xcopy c:make.ini /m /v
xcopy c:*.cmd /m /v
xcopy c:*.bat /m /v
c:
cd img
i:
cd img
xcopy c:*.bat /m /v
xcopy c:*.lod /m /v
xcopy c:*.ld1 /m /v
xcopy c:*.bdb /m /v
xcopy c:*.bdd /m /v
xcopy c:*.img /m /v
ww

