## Computer Architecture 2021Lab
**此仓库用于发布USTC体系结构课程2021年秋季学期的实验代码和要求，同时可用于学生的意见反馈。**  
实验成绩占课程成绩的40%，实验验收方式主要为课堂当面验收和实验报告的提交。  
本学期计划实验时长为10周

* Lab1（第4-5周）  【15%】： 熟悉RISC-V指令集，完成RV32I指令集流水线CPU的设计报告；
* Lab2（第6-9周）  【40%】： 完成RV32I流水线CPU的Verilog代码；利用RISCV-test测试文件进行仿真和CPU功能验证
* Lab3（第10-11周） 【20%】： cache设计和实现
* Lab4（第12-13周）【15%】： 分支预测设计与实现
* Lab5（第14-15周）   【10%】： 学习使用提供的Tomasulo软件模拟器和多Cache一致性软件模拟器，并完成实验报告


签到与补交

## 签到与补交

* 学生总数106人左右，每周一晚上实验课
* 验收和报告补交在一周内扣除15%成绩，介于一周两周之内补交扣除30%成绩，超过两周不予验收。
* 为了照顾对流水线不熟悉的学生和鼓励实验课出勤，每堂课设置签到。（每次实验课开始20分钟后停止签到）。
* 上周和本周连续两次满勤可以申请本周实验晚交一周不做扣分处理。（比如Lab2阶段一验收是第6周，如果到了第6周实验课结束了实验还没做完，如果你第5周和第6周都满勤，可以在第6周签离时向助教申请晚交一周同时不扣分。）希望对流水线和verilog不熟悉的同学可以积极参与实验课，届时有问题多问问助教，助教可以一对一讲解或者统一指导。
* 签到记录不以其他方式影响成绩

## 助教统一讲解
*  每周实验课的开始时间，**助教准点（14:30或18:30）**开始**本周实验指导**和**下周实验内容简单介绍**
* 大家可以参考提供的实验文档，如果有疑惑，可以在课程QQ群，或者仓库提Issue询问助教。


## 实验资源


* 实验教学中心提供了一个基于互联网的远程进行硬件、系统和软件 7x24 教学实验的平台，可校外登录使用，支持 SSH、浏览器和 VNC 远程桌面的方式来使用（方便 Windows 用户使用 Linux）。这个平台可以通过虚拟机的方式来进行软件和系统方面的实验（基于 Linux 容器的方式使得线上体验和线下机房一致），还能够远程操作已部署好的 FPGA 集群进行硬件实验。
平台集群基于 Linux 容器搭建，计算与存储分离，提供给学生 7x24 小时使用。架构方面和 Linux 容器部署使用方面的稳定性已经经过多年验证。系统架构方面的瓶颈仅受限于网络带宽。
这套系统基于 Linux 容器来支持各类系统和软件的虚拟化及远程使用。现有容量支持 300 名以上的轻度使用用户同时在线使用，支持 150 名左右的中度使用用户同时在线，支持 90 名左右的重度使用用户（计算密集型）同时在线。
使用说明：[https://vlab.ustc.edu.cn/docs/vm/](https://vlab.ustc.edu.cn/docs/vm/)，平台地址：[https://vlab.ustc.edu.cn/](https://vlab.ustc.edu.cn/)。欢迎大家试用

* 课程实验用到的语言是system verilog(sv, verilog的超集)，所以理论上支持sv并且能仿真的IDE都可以用来做实验，但推荐使用vivado工具(ise 也可)，这里给出vivado的下载链接。链接：[https://vlab.ustc.edu.cn/docs/downloads/](https://vlab.ustc.edu.cn/docs/downloads/)


## 实验发布、验收和报告

* **2021.4.1 Release Lab1**  
  请提交CPU设计报告 截止日期：2021.4.19  （由于特殊原因，Lab01最终实验报告提交截止日期为5月10日，不再延后。）
  提交至BB平台  
  提交格式：要求包括一份**pdf格式**实验报告（如果无法打开会影响最终成绩）  

* **2021.4.14 Release Lab2**  
  阶段一课堂验收 截止日期：2021.4.26  
  阶段二课堂验收 截止日期：2021.5.10  
  阶段三课堂验收 截止日期：2021.5.10  
  实验报告 截止日期：2021.5.17  
  提交至BB平台  
  提交格式：Lab2-学号-姓名.rar(or .zip) 要求包括一份pdf格式实验报告和用到的源代码集合的文件夹  

* **2021.5.9 Release Lab3**  
  阶段一二课堂验收 截止日期：2021.5.24  (只进行一次统一验收，验收时间为5.24日)  
  实验报告 截止日期：2021.5.31  
  提交至BB平台  
  提交格式：Lab3-学号-姓名.rar(or .zip) 要求包括一份pdf格式实验报告和用到的源代码集合的文件夹  

## 实验课安排

* lab1答案分析+Lab2预先讲解 
  2021.4.19晚（18:30-21:00 电三楼406）

* lab2阶段一检查 
  2021.4.26晚（18:30-21:00 电三楼406）

* lab2阶段二三检查（未检查的同学在本次阶段检查中完成Lab2所有阶段检查）  
  2021.5.10晚（18:30-21:00 电三楼406）

* lab3检查（Lab2未检查的同学可以进行检查Lab2）
  注：Lab3阶段1,2截止时间均在Lab3实验结束时完成 本次检查不做阶段1,2要求 在最终实验结束之前完成检查即可  
  2021.5.17晚（18:30-21:30 电三楼406）

* lab3最终检查 - 未开始  
  注：本次检查为最终检查时间 - 如没有签到两次则无法延迟验收或延迟提交实验报告  
  2021.5.24晚（18:30-21:30 电三楼406） 