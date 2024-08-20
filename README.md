<div align="center">

# 一个AMD游戏调度优化方案

</div>

<!-- ![](https://github.com/Yukiriri/win-amd-optimization/blob/main/res/effect_draw_table.png?raw=true) -->

<table>
  <tr>
    <th>大小核类型</th>
    <th>CCD结构</th>
    <th>选择建议</th>
  </tr>

  <tr>
    <td rowspan="2">全大核</td>
    <td>单CCD</td>
    <td>
      <a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/P Opt.bat">P Opt.bat</a><br/>
      <a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/P SMT On.bat">P SMT On.bat（可选）</a><br/>
    </td>
  </tr>

  <tr>
    <td>多CCD</td>
    <td>
      <a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/P Opt.bat">P Opt.bat</a><br/>
      <a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/P SMT Off.bat">P SMT Off.bat</a><br/>
    </td>
  </tr>

  <tr>
    <td>大小核</td>
    <td>单CCD</td>
    <td>
      <del><a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/P+E Opt.bat">P+E Opt.bat</a></del><br/>
      咕咕咕！！！现在还不能用
    </td>
  </tr>
</table>

<table>
  <tr>
    <th>文件</th>
    <th>功能作用</th>
  </tr>

  <tr><td><a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/P Opt.bat">P Opt.bat</a></td><td>全大核专用优化调度</td></tr>
  <tr><td><a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/P SMT Off.bat">P SMT Off.bat</a></td><td>全大核专用尽可能休眠超线程</td></tr>
  <tr><td><a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/P SMT On.bat">P SMT On.bat</a></td><td>全大核专用重新启用超线程</td></tr>
  <tr><td><a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/P+E Opt.bat">P+E Opt.bat</a></td><td>大小核专用优化调度（开发中）</td></tr>
  <tr><td><a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/P+E SMT Off.bat">P+E SMT Off.bat</a></td><td>大小核专用尽可能休眠超线程（开发中）</td></tr>
  <tr><td><a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/P+E SMT On.bat">P+E SMT On.bat</a></td><td>大小核专用重新启用超线程（开发中）</td></tr>
  <tr><td><a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/RestoreDefault.bat">RestoreDefault.bat</a></td><td>恢复所有电源计划为默认（包括熄屏和睡眠时间）</td></tr>
  <tr><td><a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/UnlockSettings.reg">UnlockSettings.reg</a></td><td>解锁常用隐藏电源选项（在控制面板里）</td></tr>
</table>

- 有效作用电源计划：平衡 高性能
- 环境基准：Windows11 23H2 或更高
- 以防万一，建议以管理员身份运行bat

# 研究经验

- 开启CPPC的好处和坏处：
  - 好处：在中低负载时对多CCD的CPU可能有略微提升
  - 坏处：
    - 所有同一个CCX内的逻辑核心负载都会被定期强制搬到另一个逻辑核心，这毫无意义
    - 金银核心会被尽可能撑满，高负载时适得其反

- 关闭CPPC的好处和坏处：
  - 好处：线程亲和性恢复正常
  - 坏处：有的游戏的动态模糊会产生微妙的变化

- Win11 24H2变化：
  - 优化来得更明显
  - 好一堆二三线主板装不上

# 学习参考

- <a href="https://blog.csdn.net/u011617151/article/details/140035903">https://blog.csdn.net/u011617151/article/details/140035903</a>
- <a href="https://learn.microsoft.com/windows-hardware/customize/power-settings/configure-processor-power-management-options">https://learn.microsoft.com/windows-hardware/customize/power-settings/configure-processor-power-management-options</a>
- <a href="https://nga.178.com/read.php?tid=38104750&rand=312">https://nga.178.com/read.php?tid=38104750&rand=312</a>
- <a href="https://forums.guru3d.com/threads/smt-powerplan-settings.447431/">https://forums.guru3d.com/threads/smt-powerplan-settings.447431/</a>
- <a href="https://www.overclockers.at/articles/the-hpet-bug-what-it-is-and-what-it-isnt/">https://www.overclockers.at/articles/the-hpet-bug-what-it-is-and-what-it-isnt</a>

# 无用的感慨

AMD想用的舒服确实不适合小白和不爱折腾的人，我也许买Intel会更省心（前提不出12-14代的问题），虽然但是，我毕竟是有梦想组一台线程撕裂者巨型工作站的人，Intel在这方面没有平替，所以提前试水和折腾AMD是必经之路，早打基础早为以后铺路

# 大胆的想法

想找出Windows实现调度所在的DLL，并重写更优调度，从根源上优化
