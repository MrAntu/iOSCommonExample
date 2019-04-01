//
//  GCDViewController.m
//  MultiThreading
//
//  Created by 叮咚钱包富银 on 2018/5/25.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController () {
    dispatch_semaphore_t _semaphoreLock;
}
@property (nonatomic, assign) NSInteger ticketCount;
@end

@implementation GCDViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self syncConCurrent];
//    [self asyncConCurrent];
    
//    [self syncSerial];
//    [self asyncSerial];
    
//    [self barrier];
    
//    [self after];
    
//    [self groupNotify];
//    [self groupWait];
    
//    [self semaphoreSync];
    
//    [self initTicketStatusSave];
}

#pragma mark -- GCD
//GCD 有很多好处啊，具体如下：
//GCD 可用于多核的并行运算
//GCD 会自动利用更多的 CPU 内核（比如双核、四核）
//GCD 会自动管理线程的生命周期（创建线程、调度任务、销毁线程）
//程序员只需要告诉 GCD 想要执行什么任务，不需要编写任何线程管理代码

//GCD 的基本使用
//1.1 同步执行 + 并发队列
//在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
- (void)syncConCurrent {
//    2018-07-24 14:42:15.203613+0800 MultiThreading[93742:13873487] <NSThread: 0x604000069980>{number = 1, name = main}
//    2018-07-24 14:42:15.203798+0800 MultiThreading[93742:13873487] syncConCurrent -- begin
//    2018-07-24 14:42:17.204990+0800 MultiThreading[93742:13873487] 1-----<NSThread: 0x604000069980>{number = 1, name = main}
//    2018-07-24 14:42:19.206588+0800 MultiThreading[93742:13873487] 2-----<NSThread: 0x604000069980>{number = 1, name = main}
//    2018-07-24 14:42:21.207498+0800 MultiThreading[93742:13873487] 3-----<NSThread: 0x604000069980>{number = 1, name = main}
//    2018-07-24 14:42:21.207761+0800 MultiThreading[93742:13873487] syncConCurrent -- end

//    所有任务都是在当前线程（主线程）中执行的，没有开启新的线程（同步执行不具备开启新线程的能力）。
//    所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间执行的（同步任务需要等待队列的任务执行结束）。
//    任务按顺序执行的。按顺序执行的原因：虽然并发队列可以开启多个线程，并且同时执行多个任务。但是因为本身不能创建新线程，只有当前线程这一个线程（同步任务不具备开启新线程的能力），所以也就不存在并发。
    NSLog(@"%@",[NSThread currentThread]);
    
    NSLog(@"syncConCurrent -- begin");
    //创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("syncConCurrent", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1-----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2-----%@",[NSThread currentThread]);
    });
    
    
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"3-----%@",[NSThread currentThread]);
    });
    
    NSLog(@"syncConCurrent -- end");

}

//1.2 异步执行 + 并发队列
//2018-07-24 14:41:33.562718+0800 MultiThreading[93633:13871947] <NSThread: 0x604000073a80>{number = 1, name = main}
//2018-07-24 14:41:33.562981+0800 MultiThreading[93633:13871947] asyncConCurrent -- begin
//2018-07-24 14:41:33.563145+0800 MultiThreading[93633:13871947] asyncConCurrent -- end
//2018-07-24 14:41:35.566343+0800 MultiThreading[93633:13872159] 1-----<NSThread: 0x604000269740>{number = 3, name = (null)}
//2018-07-24 14:41:35.566408+0800 MultiThreading[93633:13872378] 3-----<NSThread: 0x600000662d00>{number = 4, name = (null)}
//2018-07-24 14:41:35.566444+0800 MultiThreading[93633:13872370] 2-----<NSThread: 0x600000662c80>{number = 5, name = (null)}

- (void)asyncConCurrent {
    
//    除了当前线程（主线程），系统又开启了3个线程，并且任务是交替/同时执行的。（异步执行具备开启新线程的能力。且并发队列可开启多个线程，同时执行多个任务）。
//    所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才执行的。说明当前线程没有等待，而是直接开启了新线程，在新线程中执行任务（异步执行不做等待，可以继续执行任务）。
    
    NSLog(@"%@",[NSThread currentThread]);
    
    NSLog(@"asyncConCurrent -- begin");
    //创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("syncConCurrent", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1-----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2-----%@",[NSThread currentThread]);
    });
    
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"3-----%@",[NSThread currentThread]);
    });
    
    NSLog(@"asyncConCurrent -- end");
}

//1.3  同步执行 + 串行队列
- (void)syncSerial {
    
    NSLog(@"syncSerial -- begin");
    //创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("syncConCurrent", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1-----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2-----%@",[NSThread currentThread]);
    });
    
    
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"3-----%@",[NSThread currentThread]);
    });
    
    NSLog(@"syncSerial -- end");
}

//1.4  异步执行 + 串行队列
- (void)asyncSerial {
    
//    开启了一条新线程（异步执行具备开启新线程的能力，串行队列只开启一个线程）。
//    所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才开始执行的（异步执行不会做任何等待，可以继续执行任务）。
//    任务是按顺序执行的（串行队列每次只有一个任务被执行，任务一个接一个按顺序执行）。

    NSLog(@"asyncSerial -- begin");
    //创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("syncConCurrent", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1-----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2-----%@",[NSThread currentThread]);
    });
    
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"3-----%@",[NSThread currentThread]);
    });
    
    NSLog(@"asyncSerial -- end");
}

//1.5  同步执行 + 主队列
//在主线程中会造成死锁
//在分线程中不会卡死
- (void)syncMain {
    NSLog(@"syncMain -- begin");

    dispatch_sync(dispatch_get_main_queue(), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1-----%@",[NSThread currentThread]);
    });
    NSLog(@"syncMain -- end");
}

//2. GCD 栅栏方法：dispatch_barrier_async
//2018-07-24 10:15:11.110202+0800 MultiThreading[65968:13591915] barrier -- begin
//2018-07-24 10:15:11.113672+0800 MultiThreading[65968:13591915] barrier -- end
//2018-07-24 10:15:13.116170+0800 MultiThreading[65968:13592295] 1-----<NSThread: 0x6000004733c0>{number = 3, name = (null)}
//2018-07-24 10:15:16.116118+0800 MultiThreading[65968:13592292] 2-----<NSThread: 0x60400046a640>{number = 4, name = (null)}
//2018-07-24 10:15:18.117594+0800 MultiThreading[65968:13592292] 3-----<NSThread: 0x60400046a640>{number = 4, name = (null)}
//2018-07-24 10:15:20.121517+0800 MultiThreading[65968:13592295] 5-----<NSThread: 0x6000004733c0>{number = 3, name = (null)}
//2018-07-24 10:15:20.121517+0800 MultiThreading[65968:13592292] 4-----<NSThread: 0x60400046a640>{number = 4, name = (null)}

- (void)barrier {
//    在执行完栅栏前面的操作之后，才执行栅栏操作，最后再执行栅栏后边的操作。
    dispatch_queue_t queue = dispatch_queue_create("barrier", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"barrier -- begin");

    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1-----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:5];
        NSLog(@"2-----%@",[NSThread currentThread]);
    });
    
    dispatch_barrier_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"3-----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"4-----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"5-----%@",[NSThread currentThread]);
    });
    NSLog(@"barrier -- end");

}

- (void)after {

    //先执行完start，end后再执行after里面
    NSLog(@"after -- start");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"after-----%@",[NSThread currentThread]);
    });
    NSLog(@"after -- end");

}

//3. GCD 的队列组：dispatch_group
//有时候我们会有这样的需求：分别异步执行2个耗时任务，然后当2个耗时任务都执行完毕后再回到主线程执行任务。这时候我们可以用到 GCD 的队列组。

- (void)groupNotify {
//    2018-05-25 17:13:38.068535+0800 MultiThreading[45245:414417] groupNotify -- start
//    2018-05-25 17:13:38.070223+0800 MultiThreading[45245:414417] groupNotify -- end
//    2018-05-25 17:13:40.075271+0800 MultiThreading[45245:414758] 2-----<NSThread: 0x604000460fc0>{number = 4, name = (null)}
//    2018-05-25 17:13:40.075256+0800 MultiThreading[45245:414568] 1-----<NSThread: 0x60000046de80>{number = 3, name = (null)}
//    2018-05-25 17:13:42.076021+0800 MultiThreading[45245:414417] 3-----<NSThread: 0x600000078e00>{number = 1, name = main}

    NSLog(@"groupNotify -- start");
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1-----%@",[NSThread currentThread]);
    });

    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2-----%@",[NSThread currentThread]);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"3-----%@",[NSThread currentThread]);
    });
    NSLog(@"groupNotify -- end");

}

- (void)groupWait {
//    2018-05-25 17:15:48.912091+0800 MultiThreading[45501:417099] groupWait -- start
//    2018-05-25 17:15:50.916053+0800 MultiThreading[45501:417182] 1-----<NSThread: 0x60400046b780>{number = 4, name = (null)}
//    2018-05-25 17:15:50.916053+0800 MultiThreading[45501:417181] 2-----<NSThread: 0x60000047ae40>{number = 3, name = (null)}
//    2018-05-25 17:15:50.917401+0800 MultiThreading[45501:417099] groupWait -- end

    //dispatch_group_wait 会等它之前的任务执行完后,才会往下继续执行
    NSLog(@"groupWait -- start");
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1-----%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2-----%@",[NSThread currentThread]);
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"groupWait -- end");
}

//4 GCD 信号量：dispatch_semaphore
//GCD 中的信号量是指 Dispatch Semaphore，是持有计数的信号。类似于过高速路收费站的栏杆。可以通过时，打开栏杆，不可以通过时，关闭栏杆。在 Dispatch Semaphore 中，使用计数来完成这个功能，计数为0时等待，不可通过。计数为1或大于1时，计数减1且不等待，可通过。
//Dispatch Semaphore 提供了三个函数。
//
//dispatch_semaphore_create：创建一个Semaphore并初始化信号的总量
//dispatch_semaphore_signal：发送一个信号，让信号总量加1
//dispatch_semaphore_wait：可以使总信号量减1，当信号总量为0时就会一直等待（阻塞所在线程），否则就可以正常执行。

//Dispatch Semaphore 在实际开发中主要用于：
//
//保持线程同步，将异步执行任务转换为同步执行任务
//保证线程安全，为线程加锁

- (void)semaphoreSync {
    //保持线程同步
//    2018-05-25 17:26:57.508234+0800 MultiThreading[46635:428154] semaphoreSync -- start
//    2018-05-25 17:26:59.513794+0800 MultiThreading[46635:428309] 1-----<NSThread: 0x60400046acc0>{number = 3, name = (null)}
//    2018-05-25 17:26:59.514558+0800 MultiThreading[46635:428154] semaphoreSync -- start,number = 100
    NSLog(@"semaphoreSync -- start");
    
    dispatch_semaphore_t semp = dispatch_semaphore_create(0);  //必须为0 ，才是线程同步 ,信号总量为0时就会一直等待（阻塞所在线程）
    __block int number = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1-----%@",[NSThread currentThread]);
        number = 100;
        dispatch_semaphore_signal(semp);
    });

    dispatch_semaphore_wait(semp, DISPATCH_TIME_FOREVER);
    NSLog(@"semaphoreSync -- start,number = %d",number);
}

//5.线程安全（使用 semaphore 加锁）

- (void)initTicketStatusSave {
    
    self.ticketCount = 100;
    //创建两个队列，代表两个售票点
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_SERIAL);

    //创建信号总量为1
    _semaphoreLock = dispatch_semaphore_create(1);
    
    __weak typeof(self)weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketSafe];
    });
}

- (void)saleTicketSafe {
    while (1) {
        dispatch_semaphore_wait(_semaphoreLock, DISPATCH_TIME_FOREVER);
        if (self.ticketCount > 0) {
            self.ticketCount--;
            NSLog(@"剩余票数： %ld, 窗口: %@", self.ticketCount, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.2];
        } else {
            NSLog(@"票数售完");
            dispatch_semaphore_signal(_semaphoreLock);
            break;
        }
        dispatch_semaphore_signal(_semaphoreLock);
    }
}
@end
