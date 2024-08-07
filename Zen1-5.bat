@echo off & chcp 65001 >nul

rem 电源计划：平衡、高性能、卓越性能
set scheme=381b4222-f694-41f0-9685-ff5bb260df2e 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c e9a42b02-d5df-448d-aa00-03f14749eb61

rem 处理器电源管理
set sub_group=54533251-82be-4824-96c1-47b60b740d00

for %%i in (%scheme%) do (
    powercfg -setacvalueindex %%i %sub_group% 7f2f5cfa-f10c-4823-b5e1-e93ae85f46b5 4
    echo %%i生效的异类策略 设置完成
    powercfg -setacvalueindex %%i %sub_group% 93b8b6dc-0698-4d1c-9ee4-0644e900c85d 0
    echo %%i异类线程调度策略 设置完成
    powercfg -setacvalueindex %%i %sub_group% bae08b81-2d5e-4688-ad6a-13243356654b 0
    echo %%i异类短运行线程调度策略 设置完成
    echo.
)

bcdedit /deletevalue useplatformclock >nul
bcdedit /set useplatformclock false

pause
