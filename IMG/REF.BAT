@echo off
@wwfld ref ref_hit.img ref_wlk.img
@copy ref.ld1 + ref.ld2 ref.lod
@move ref.h ..\refimg.h
@move ref.seq ..
