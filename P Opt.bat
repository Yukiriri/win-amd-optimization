@echo off & chcp 65001 >nul

for %%i in (SCHEME_BALANCED SCHEME_MIN) do (
    powercfg -setacvalueindex %%i SUB_PROCESSOR HETEROPOLICY 4
    powercfg -setacvalueindex %%i SUB_PROCESSOR SCHEDPOLICY 0
    powercfg -setacvalueindex %%i SUB_PROCESSOR SHORTSCHEDPOLICY 0
    powercfg -setacvalueindex %%i SUB_PROCESSOR SMTUNPARKPOLICY 2
    powercfg -setacvalueindex %%i SUB_PROCESSOR PERFCHECK 30

    echo [%%i][生效的异类策略]=使用异类策略4
    echo [%%i][异类线程调度策略]=所有处理器
    echo [%%i][异类短运行线程调度策略]=所有处理器
    echo [%%i][SMT线程启动策略]=循环配置
    echo [%%i][处理器性能时间检查间隔]=30ms
    
    echo [%%i][Heterogeneous policy in effect]=Use heterogeneous policy 4
    echo [%%i][Heterogeneous thread scheduling policy]=All processors
    echo [%%i][Heterogeneous short running thread scheduling policy]=All processors
    echo [%%i][Smt threads unpark policy]=Round robin
    echo [%%i][Processor performance time check interval]=30ms
    echo.
)

powercfg -setactive SCHEME_CURRENT

pause
