@echo off & chcp 65001 >nul

for %%i in (SCHEME_BALANCED SCHEME_MIN e9a42b02-d5df-448d-aa00-03f14749eb61) do (
    powercfg -setacvalueindex %%i SUB_PROCESSOR HETEROPOLICY 0
    powercfg -setacvalueindex %%i SUB_PROCESSOR SCHEDPOLICY 2
    powercfg -setacvalueindex %%i SUB_PROCESSOR SHORTSCHEDPOLICY 2
    powercfg -setacvalueindex %%i SUB_PROCESSOR SMTUNPARKPOLICY 2

    echo [%%i][生效的异类策略]=使用异类策略0
    echo [%%i][异类线程调度策略]=首选高性能处理器
    echo [%%i][异类短运行线程调度策略]=首选高性能处理器
    echo [%%i][SMT线程启动策略]=循环配置
    
    echo [%%i][Heterogeneous policy in effect]=Use heterogeneous policy 0
    echo [%%i][Heterogeneous thread scheduling policy]=Prefer performant processors
    echo [%%i][Heterogeneous short running thread scheduling policy]=Prefer performant processors
    echo [%%i][Smt threads unpark policy]=Round robin
    echo.
)

powercfg -S SCHEME_CURRENT

pause
