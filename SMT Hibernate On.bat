@echo off & chcp 65001 >nul

for %%i in (SCHEME_BALANCED SCHEME_MIN) do (
    powercfg -setacvalueindex %%i SUB_PROCESSOR CPMINCORES 50
    @REM powercfg -setacvalueindex %%i SUB_PROCESSOR CPMINCORES1 50
    powercfg -setacvalueindex %%i SUB_PROCESSOR CPHEADROOM 98
    powercfg -setacvalueindex %%i SUB_PROCESSOR CPDECREASEPOL 1
    powercfg -setacvalueindex %%i SUB_PROCESSOR CPINCREASEPOL 1

    echo [%%i][处理器性能核心放置最小核心数量]=50%%
    @REM echo [%%i][针对第1类处理器电源效率的处理器性能核心放置最小核心数量]=50%%
    echo [%%i][处理器性能内核休止并发空间阈值]=98%%
    echo [%%i][处理器性能核心放置减小策略]=单一核心
    echo [%%i][处理器性能核心放置增加策略]=单一核心
    
    echo [%%i][Processor performance core parking min cores]=50%%
    @REM echo [%%i][Processor performance core parking min cores for Processor Power Efficiency Class 1]=50%%
    echo [%%i][Processor performance core parking concurrency threshold]=98%%
    echo [%%i][Processor performance core parking decrease policy]=Single core
    echo [%%i][Processor performance core parking increase policy]=Single core
    echo.
)

powercfg -setactive SCHEME_CURRENT

pause
