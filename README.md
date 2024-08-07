<div align="center">

# 一个AMD游戏调度优化方案

</div>

![](https://github.com/Yukiriri/win-amd-optimize/blob/main/res/result.png?raw=true)

|Zen架构|大小核类型|使用选择|
|:-|:-|:-|
|Zen/Zen+|全大核|<a target="_blank" href="https://github.com/Yukiriri/win-amd-optimize/blob/main/Zen1-5.bat">Zen1-5.bat</a>|
|Zen2|全大核|<a target="_blank" href="https://github.com/Yukiriri/win-amd-optimize/blob/main/Zen1-5.bat">Zen1-5.bat|
|Zen3|全大核|<a target="_blank" href="https://github.com/Yukiriri/win-amd-optimize/blob/main/Zen1-5.bat">Zen1-5.bat|
|Zen4|全大核|<a target="_blank" href="https://github.com/Yukiriri/win-amd-optimize/blob/main/Zen1-5.bat">Zen1-5.bat|
|Zen5|全大核|<a target="_blank" href="https://github.com/Yukiriri/win-amd-optimize/blob/main/Zen1-5.bat">Zen1-5.bat|
|Zen5c|大小核|研究ing|

目前修改的电源方案：平衡、高性能、卓越性能<br/>
如果想要开启常用隐藏选项，可以导入仓库中的<a target="_blank" href="https://github.com/Yukiriri/win-amd-optimize/blob/main/UnlockSetting.reg">UnlockSetting.reg</a>

# 研究经验
关于AMD CPPC的理解：<br/>
  - 英特尔的第一个核心是最高倍频，然后从第二个核心开始递减，直到后面所有核心的倍频都一致。
  - 而AMD CPPC核心列表所表示的是体质排序，开头2个核心是体质最好的核心，也就是广泛称呼的金银核心，向后则递减，默认全核都为同一个倍频上限，想要挖掘出金银核心的上限就得自己去超频。
  - 但好玩的来了，Windows对这个CPPC顺序的识别过于逆天，把金银核心当成了大小核当中的大核，默认使用就出现了上面图片当中有2个核心占用很高。至于为什么是逻辑核心交替牙齿状占用，应该也要背锅给Windows无法正确调度物理核心与超线程的负载。这对AMD是相当恶劣的负优化。

  - ![](https://github.com/Yukiriri/win-amd-optimize/blob/main/res/CPPC.png?raw=true)

  - 能不关闭CPPC就不关闭，以我的实验结论是：关闭CPPC后帧的画面延迟会变低，但动态模糊出现了不正确

关于单核间歇负载乱飞其他核心：
  - 还在研究

# 学习参考

https://blog.csdn.net/u011617151/article/details/140035903

https://seeizo.com/posts/amd-win-fix/

# 无用的感慨

AMD想用的舒服确实不适合小白和不爱折腾的人，我也许买英特尔会更省心（前提不出12-14代的问题），虽然但是，我毕竟是有梦想想用线程撕裂者组巨型工作站的人，英特尔在这方面没有平替，所以提前试水和折腾AMD是必经之路，早打基础早为以后铺路

# 大胆的想法

想找出Windows实现调度所在的DLL，并重写更优调度，从根源上优化
