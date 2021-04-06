@cls
@pkzip -x*.obj -x*.lst -x*.tbl -x*.glo -x*.out temp.xyz *.*
@cls
@echo INSERT DISK INTO DRIVE B:
@pause
@echo copying zip file...
@copy temp.xyz b:\wwf.zip
@del temp.xyz
@echo ALL DONE... have a nice day :)
