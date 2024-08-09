@echo off & chcp 65001 >nul

rem 电源计划：平衡、高性能、卓越性能
for %%i in (SCHEME_BALANCED SCHEME_MIN SCHEME_MAX) do (
    powercfg -setacvalueindex %%i SUB_PROCESSOR HETEROPOLICY 0
    echo %%i 生效的异类策略=使用异类策略0
    powercfg -setacvalueindex %%i SUB_PROCESSOR SCHEDPOLICY 2
    echo %%i 异类线程调度策略=首选高性能处理器
    powercfg -setacvalueindex %%i SUB_PROCESSOR SHORTSCHEDPOLICY 2
    echo %%i 异类短运行线程调度策略=首选高性能处理器
    echo.
)

reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power /v EventProcessorEnabled /t REG_DWORD /d 0 /f
bcdedit /deletevalue useplatformclock >nul

pause
