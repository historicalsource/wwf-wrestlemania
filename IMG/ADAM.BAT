@echo off
@wwfld adam adm_hit.img adm_kik.img adm_msc.img adm_pnc.img adm_wlk.img
@copy adam.ld1 + adam.ld2 adam.lod
@move adam.h ..\adamimg.h
@move adam.seq ..
