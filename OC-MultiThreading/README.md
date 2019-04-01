# OC-MultiThreading
OC中的三种多线程详细使用Demo：

1.NSThread

2.NSOpreration

3.GCD

•NSThread:
–优点：NSThread 比其他两个轻量级，使用简单
–缺点：需要自己管理线程的生命周期、线程同步、加锁、睡眠以及唤醒等。线程同步对数据的加锁会有一定的系统开销
 
•NSOperation：
–不需要关心线程管理，数据同步的事情，可以把精力放在自己需要执行的操作上
–NSOperation是面向对象的
-NSOperation 可以实现一些 GCD 中实现不了，或者实现比较复杂的功能。比如：设置最大并发数，设置线程间的依赖关系。

•GCD：
–Grand Central Dispatch是由苹果开发的一个多核编程的解决方案。iOS4.0+才能使用，是替代NSThread， NSOperation的高效和强大的技术
–GCD是基于C语言的

实现某个多线程功能，使用 GCD，简单易用。实现某个多线程模块，使用 NSOperation，方便类的管理。

