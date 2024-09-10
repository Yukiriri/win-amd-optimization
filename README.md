<div align="center">

# 一个AMD游戏调度优化方案

</div>

提供了 修改系统调度 和 后台辅助程序 这2种方式帮助游戏运行得更好<br/>
两者互不冲突，可以都用也可以只用其中一个，随你需要<br/>
后台辅助程序会对前台程序进行规则判断来识别是不是游戏进程，如果是游戏进程，就提高进程优先级，并把进程的CPU分配绑定在所有物理性能核<br/>
注意，如果要用后台辅助程序，不能在开启CPPC PC的情况下修改SMT为循环配置<br/>

![](https://github.com/Yukiriri/win-amd-optimization/blob/main/res/effect_draw_table.png?raw=true)

<table>
  <tr>
    <th>自选文件</th>
    <th>功能作用</th>
  </tr>

  <tr><td><a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/P Opt.bat">P Opt.bat</a></td><td>优化系统全大核调度</td></tr>
  <tr><td><a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/P+E Opt Desk.bat">P+E Opt Desk.bat</a></td><td>优化系统大小核调度（桌面端）（开发中）</td></tr>
  <tr><td><a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/P+E Opt Mob.bat">P+E Opt Mob.bat</a></td><td>优化系统大小核调度（移动端）（开发中）</td></tr>
  <tr><td><a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/RestoreDefault.bat">RestoreDefault.bat</a></td><td>恢复所有电源计划为默认（包括熄屏和睡眠时间）</td></tr>
  <tr><td><a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/UnlockSettings.reg">UnlockSettings.reg</a></td><td>解锁常用隐藏电源选项（在控制面板里）</td></tr>
</table>

- 有效作用电源计划：平衡 高性能
- 环境基准：Windows11 23H2 或更高
- 以防万一，建议以管理员身份运行bat

# 待实现功能

  - 识别AMD多CCD
  - 托盘化
  - 不符合游戏进程时撤销绑核

# 构建

  - mingw64
    ```
    git clone https://github.com/Yukiriri/win-amd-optimization.git
    cd win-amd-optimization
    cd bg_service
    build
    ```
  - Visual Studio

    自己建sln项目（）

# 研究经验

- 开和关CPPC PC的好处和坏处：
  - 开启：
    - 好处：在中低负载时对多CCD的CPU可能有略微提升
    - 坏处：
      - 同一个CCX内的2个逻辑核心负载会被定期强制互相调换，这毫无意义
      - 金银核心会被尽可能撑满，高负载时适得其反
  - 关闭：
    - 好处：线程亲和性恢复正常
    - 坏处：有的游戏的动态模糊会产生微妙的变化

- Win11 24H2变化：
  - 优化来得更明显
  - 好一堆二三线主板装不上

# 学习参考

- <a href="https://blog.csdn.net/u011617151/article/details/140035903">https://blog.csdn.net/u011617151/article/details/140035903</a>
- <a href="https://learn.microsoft.com/windows-hardware/customize/power-settings/configure-processor-power-management-options">https://learn.microsoft.com/windows-hardware/customize/power-settings/configure-processor-power-management-options</a>
- <a href="https://www.overclockers.at/articles/the-hpet-bug-what-it-is-and-what-it-isnt/">https://www.overclockers.at/articles/the-hpet-bug-what-it-is-and-what-it-isnt</a>

# 无用的感慨

AMD想用的舒服确实不适合小白和不爱折腾的人，我也许买Intel会更省心（前提不出12-14代的问题），虽然但是，我毕竟是有梦想组一台线程撕裂者巨型工作站的人，Intel在这方面没有平替，所以提前试水和折腾AMD是必经之路，早打基础早为以后铺路
