<div align="center">

# 一个AMD游戏调度优化方案

</div>

![](https://github.com/Yukiriri/win-amd-optimization/blob/main/res/effect_drawing.png?raw=true)

<table>
  <tr><th>Zen架构</th><th>型号参考</th><th>大小核类型</th><th>方案选择</th></tr>
  <tr><td>Zen/Zen+</td><td>Ryzen 1xxx-2xxx</td><td rowspan="5">全大核</td><td rowspan="5"><a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/P Only.bat">P Only.bat</a></td></tr>
  <tr><td>Zen2</td><td>Ryzen 3xxx-4xxx, 7x2x</td></tr>
  <tr><td>Zen3</td><td>Ryzen 5xxx-6xxx, 7x3x</td></tr>
  <tr><td>Zen4</td><td>Ryzen 7xxx-8xxx, 7x4x</td></tr>
  <tr><td>Zen5</td><td>Ryzen 9xxx</td></tr>
  <tr><td>Zen5c</td><td>咕咕咕？？？</td><td>大小核</td><td>咕咕咕？？？</td></tr>
</table>

已修改电源计划：平衡 高性能 卓越性能<br/><br/>
如果想修改SMT的休眠，可以使用<a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/SMT%20Hibernate%20On.bat">SMT Hibernate On.bat</a> <a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/SMT%20Hibernate%20Off.bat">SMT Hibernate Off.bat</a><br/>
如果想解锁常用隐藏电源选项，可以导入仓库中的<a href="https://github.com/Yukiriri/win-amd-optimization/blob/main/UnlockSettings.reg">UnlockSettings.reg</a><br/>

本预设开发所用环境是Windows11 23H2，你也应当安装最新或次新版Windows<br/>
以防万一，下载bat后建议还是以管理员身份运行<br/>

# 研究经验

关于AMD CPPC的理解：
  - ![](https://github.com/Yukiriri/win-amd-optimization/blob/main/res/CPPC.png?raw=true)

  - 英特尔的第一个核心是最高倍频，然后从第二个核心开始递减，直到后面所有核心的倍频都一致。
  - 而AMD CPPC核心列表所表示的是体质排序，开头2个核心是体质最好的核心，也就是广泛称呼的金银核心，向后则递减，默认全核都为同一个倍频上限，想要挖掘出金银核心的上限就得自己去超频。
  - 但好玩的来了，Windows对这个CPPC顺序的识别过于逆天，把金银核心当成了大小核当中的大核，默认使用就出现了上面图片当中有2个核心占用很高。至于为什么是逻辑核心交替牙齿状占用，应该也要背锅给Windows无法正确调度物理核心与超线程的负载。这对AMD是相当恶劣的负优化。

  - 能不关闭CPPC就不关闭，以我的实验结论是：关闭CPPC后帧的画面延迟会变低，但动态模糊出现了不正确

关于单核间歇负载乱飞其他核心：
  - 还在研究

关于Win11 24H2：
  - 优化来得更明显
  - 好一堆二三线主板装不上

# 学习参考

- <a href="https://blog.csdn.net/u011617151/article/details/140035903">https://blog.csdn.net/u011617151/article/details/140035903</a>
- <a href="https://learn.microsoft.com/windows-hardware/customize/power-settings/configure-processor-power-management-options">https://learn.microsoft.com/windows-hardware/customize/power-settings/configure-processor-power-management-options</a>
- <a href="https://nga.178.com/read.php?tid=38104750&rand=312">https://nga.178.com/read.php?tid=38104750&rand=312</a>
- <a href="https://forums.guru3d.com/threads/smt-powerplan-settings.447431/">https://forums.guru3d.com/threads/smt-powerplan-settings.447431/</a>
- <a href="https://www.overclockers.at/articles/the-hpet-bug-what-it-is-and-what-it-isnt/">https://www.overclockers.at/articles/the-hpet-bug-what-it-is-and-what-it-isnt</a>

# 无用的感慨

AMD想用的舒服确实不适合小白和不爱折腾的人，我也许买英特尔会更省心（前提不出12-14代的问题），虽然但是，我毕竟是有梦想组一台线程撕裂者巨型工作站的人，英特尔在这方面没有平替，所以提前试水和折腾AMD是必经之路，早打基础早为以后铺路

# 大胆的想法

想找出Windows实现调度所在的DLL，并重写更优调度，从根源上优化
