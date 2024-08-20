@echo off

reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power /v EventProcessorEnabled /t REG_DWORD /d 1 /f
powercfg -restoredefaultschemes
powercfg -setactive SCHEME_CURRENT

pause
