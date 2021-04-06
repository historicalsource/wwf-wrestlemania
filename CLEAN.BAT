grep -v -e ";JMS" -v -e ";MJT" -v -e "* JAKE" -v -e ";SL;" -v -e ";RJR" %1.asm > %1.cln
diff %1.asm %1.cln
copy %1.asm %1.pcl
copy %1.cln %1.asm
