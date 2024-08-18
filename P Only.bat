@echo off & chcp 65001 >nul

for %%i in (SCHEME_BALANCED SCHEME_MIN e9a42b02-d5df-448d-aa00-03f14749eb61) do (
    powercfg -setacvalueindex %%i SUB_PROCESSOR HETEROPOLICY 4
    powercfg -setacvalueindex %%i SUB_PROCESSOR SCHEDPOLICY 0
    powercfg -setacvalueindex %%i SUB_PROCESSOR SHORTSCHEDPOLICY 0
    powercfg -setacvalueindex %%i SUB_PROCESSOR SMTUNPARKPOLICY 2

    echo [%%i][生效的异类策略]=使用异类策略4
    echo [%%i][异类线程调度策略]=所有处理器
    echo [%%i][异类短运行线程调度策略]=所有处理器
    echo [%%i][SMT线程启动策略]=循环配置
    
    echo [%%i][Heterogeneous policy in effect]=Use heterogeneous policy 4
    echo [%%i][Heterogeneous thread scheduling policy]=All processors
    echo [%%i][Heterogeneous short running thread scheduling policy]=All processors
    echo [%%i][Smt threads unpark policy]=Round robin
    echo.
)

powercfg -S SCHEME_CURRENT
@REM reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power /v EventProcessorEnabled /t REG_DWORD /d 0 /f

pause
