@echo off & chcp 65001 >nul

for %%i in (SCHEME_BALANCED SCHEME_MIN) do (
    powercfg -setacvalueindex %%i SUB_PROCESSOR CPMINCORES1 50
    @REM powercfg -setacvalueindex %%i SUB_PROCESSOR CPHEADROOM 98

    echo [%%i][针对第1类处理器电源效率的处理器性能核心放置最小核心数量]=50%%
    @REM echo [%%i][处理器性能内核休止并发空间阈值]=98%%
    
    echo [%%i][Processor performance core parking min cores for Processor Power Efficiency Class 1]=50%%
    @REM echo [%%i][Processor performance core parking concurrency threshold]=98%%
    echo.
)

powercfg -setactive SCHEME_CURRENT

pause
