@echo off & chcp 65001 >nul

for %%i in (SCHEME_BALANCED SCHEME_MIN e9a42b02-d5df-448d-aa00-03f14749eb61) do (
    powercfg -setacvalueindex SCHEME_BALANCED SUB_PROCESSOR CPMINCORES 50
    echo [%%i][处理器性能核心放置最小核心数量]=50%%
    echo [%%i][Processor performance core parking min cores]=50%%
    @REM powercfg -setacvalueindex SCHEME_BALANCED SUB_PROCESSOR CPMINCORES1 50
    @REM echo [%%i][针对第1类处理器电源效率的处理器性能核心放置最小核心数量]=50%%
    @REM echo [%%i][Processor performance core parking min cores for Processor Power Efficiency Class 1]=50%%
    powercfg -setacvalueindex SCHEME_BALANCED SUB_PROCESSOR CPHEADROOM 98
    echo [%%i][处理器性能内核休止并发空间阈值]=98%%
    echo [%%i][Processor performance core parking concurrency threshold]=98%%
    powercfg -setacvalueindex SCHEME_BALANCED SUB_PROCESSOR CPDECREASEPOL 1
    echo [%%i][处理器性能核心放置减小策略]=单一核心
    echo [%%i][Processor performance core parking decrease policy]=单一核心
    powercfg -setacvalueindex SCHEME_BALANCED SUB_PROCESSOR CPINCREASEPOL 1
    echo [%%i][处理器性能核心放置增加策略]=单一核心
    echo [%%i][Processor performance core parking increase policy]=单一核心
    powercfg -setacvalueindex SCHEME_BALANCED SUB_PROCESSOR PERFCHECK 30
    echo [%%i][处理器性能时间检查间隔]=30ms
    echo [%%i][Processor performance time check interval]=30ms
    powercfg -setacvalueindex SCHEME_BALANCED SUB_PROCESSOR SMTUNPARKPOLICY 2
    echo [%%i][SMT线程启动策略]=循环配置
    echo [%%i][Smt threads unpark policy]=循环配置
    echo.
)

pause
