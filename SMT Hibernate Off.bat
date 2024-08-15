@echo off & chcp 65001 >nul

for %%i in (SCHEME_BALANCED SCHEME_MIN e9a42b02-d5df-448d-aa00-03f14749eb61) do (
    powercfg -setacvalueindex SCHEME_BALANCED SUB_PROCESSOR CPMINCORES 100

    echo [%%i][处理器性能核心放置最小核心数量]=100%%
    
    echo [%%i][Processor performance core parking min cores]=100%%
    echo.
)

pause
