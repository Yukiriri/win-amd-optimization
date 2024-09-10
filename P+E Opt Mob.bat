@echo off & chcp 65001 >nul

for %%i in (SCHEME_BALANCED SCHEME_MIN) do (
    powercfg -setacvalueindex %%i SUB_PROCESSOR HETEROPOLICY 1
    powercfg -setacvalueindex %%i SUB_PROCESSOR SCHEDPOLICY 5
    powercfg -setacvalueindex %%i SUB_PROCESSOR SHORTSCHEDPOLICY 5
    powercfg -setacvalueindex %%i SUB_PROCESSOR PERFCHECK 30

    echo [%%i][生效的异类策略]=使用异类策略1
    echo [%%i][异类线程调度策略]=自动
    echo [%%i][异类短运行线程调度策略]=自动
    echo [%%i][处理器性能时间检查间隔]=30ms
    
    echo [%%i][Heterogeneous policy in effect]=Use heterogeneous policy 1
    echo [%%i][Heterogeneous thread scheduling policy]=Automatic
    echo [%%i][Heterogeneous short running thread scheduling policy]=Automatic
    echo [%%i][Processor performance time check interval]=30ms
    echo.
)

powercfg -setactive SCHEME_CURRENT

pause
