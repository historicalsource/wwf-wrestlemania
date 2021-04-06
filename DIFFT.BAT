@echo off
dir %1
dir t\%1
diff %1 t\%1
