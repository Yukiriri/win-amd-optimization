@echo off & chcp 65001 >nul

@REM 电源计划：平衡、高性能、卓越性能
for %%i in (SCHEME_BALANCED SCHEME_MIN e9a42b02-d5df-448d-aa00-03f14749eb61) do (
    powercfg -setacvalueindex %%i SUB_PROCESSOR HETEROPOLICY 4
    echo %%i 生效的异类策略=使用异类策略4
    powercfg -setacvalueindex %%i SUB_PROCESSOR SCHEDPOLICY 0
    echo %%i 异类线程调度策略=所有处理器
    powercfg -setacvalueindex %%i SUB_PROCESSOR SHORTSCHEDPOLICY 0
    echo %%i 异类短运行线程调度策略=所有处理器
    echo.
)
powercfg -setacvalueindex SCHEME_BALANCED SUB_PROCESSOR CPMINCORES 50
echo SCHEME_BALANCED 处理器性能核心放置最小核心数量=50%%
powercfg -setacvalueindex SCHEME_BALANCED SUB_PROCESSOR CPHEADROOM 50
echo SCHEME_BALANCED 处理器性能内核休止并发空间阈值=50%%
powercfg -setacvalueindex SCHEME_BALANCED SUB_PROCESSOR CPDECREASEPOL 1
echo SCHEME_BALANCED 处理器性能核心放置减小策略=单一核心
powercfg -setacvalueindex SCHEME_BALANCED SUB_PROCESSOR CPINCREASEPOL 1
echo SCHEME_BALANCED 处理器性能核心放置增加策略=单一核心
powercfg -setacvalueindex SCHEME_BALANCED SUB_PROCESSOR SMTUNPARKPOLICY 2
echo SCHEME_BALANCED SMT线程启动策略=循环配置
echo.

reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power /v EventProcessorEnabled /t REG_DWORD /d 0 /f
bcdedit /deletevalue useplatformclock >nul

pause
