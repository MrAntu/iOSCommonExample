//
//  OperationViewController.m
//  MultiThreading
//
//  Created by 叮咚钱包富银 on 2018/5/25.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "OperationViewController.h"

@interface OperationViewController ()

@end

@implementation OperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self userInvovationOperation];
//    [self userBlockOperation];
//    [self useBlockOperationAddExecutionBlock];
//    [self addOperationToQueue];
    
//    [self setMaxConcurrentOperationCount];
    
    [self addDependency];
}

#pragma mark -- NSOperation
//NSOperation、NSOperationQueue 是苹果提供给我们的一套多线程解决方案。实际上 NSOperation、NSOperationQueue 是基于 GCD 更高一层的封装，完全面向对象。但是比 GCD 更简单易用、代码可读性也更高。
//为什么要使用 NSOperation、NSOperationQueue？
//
//可添加完成的代码块，在操作完成后执行。
//可控制最大并发数，来控制并发、串行
//可以很方便的取消一个操作的执行。
//添加操作之间的依赖关系，方便的控制执行顺序。
//设定操作执行的优先级。
//使用 KVO 观察对操作执行状态的更改：isExecuteing、isFinished、isCancelled。


//1.NSOperation 和 NSOperationQueue 基本使用
//NSOperation 是个抽象类，不能用来封装操作。我们只有使用它的子类来封装操作。我们有三种方式来封装操作。
//使用子类 NSInvocationOperation
//使用子类 NSBlockOperation
//自定义继承自 NSOperation 的子类，通过实现内部相应的方法来封装操作。

//在不使用 NSOperationQueue，单独使用 NSOperation 的情况下系统同步执行操作，下面我们学习以下操作的三种创建方式。

//1.1使用子类 NSInvocationOperation
- (void)userInvovationOperation {
    
    //1。创建
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task) object:nil];
    
    //2 开启 ,没有添加queue,默认在主线程
    [op start];
}

- (void)task {
    NSLog(@"NSInvocationOperation---%@",[NSThread currentThread]);
}

//1.2 使用子类 NSBlockOperation
- (void)userBlockOperation {
    //1.创建
    NSBlockOperation *bp = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"NSBlockOperation---%@",[NSThread currentThread]);
    }];
    //2 开启 ,没有添加queue,默认在主线程
    [bp start];
}

//通过 addExecutionBlock: 就可以为 NSBlockOperation 添加额外的操作。这些操作（包括 blockOperationWithBlock 中的操作）可以在不同的线程中同时（并发）执行。只有当所有相关的操作已经完成执行时，才视为完成。
- (void)useBlockOperationAddExecutionBlock {
    //1.创建
    NSBlockOperation *bp = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"NSBlockOperation---%@",[NSThread currentThread]);
        
    }];
    
    [bp addExecutionBlock:^{
        NSLog(@"addExecutionBlock--1---%@",[NSThread currentThread]);

    }];
    
    [bp addExecutionBlock:^{
        NSLog(@"addExecutionBlock--2---%@",[NSThread currentThread]);
        
    }];
    
    [bp addExecutionBlock:^{
        NSLog(@"addExecutionBlock--3---%@",[NSThread currentThread]);
        
    }];
    
    //2 开启 ,没有添加queue,默认在主线程
    [bp start];
}

//2 创建队列
- (void)addOperationToQueue {
    
    //NSOperationQueue 一共有两种队列：主队列、自定义队列。其中自定义队列同时包含了串行、并发功能。下边是主队列、自定义队列的基本创建方法和特点
    //主队列
    // NSOperationQueue *queue = [NSOperationQueue mainQueue];
    //自定义队列，默认并发执行
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task) object:nil];
    
    NSBlockOperation *bp = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"NSBlockOperation---%@",[NSThread currentThread]);
    }];
    
    //addExecutionBlock  将操作加入到操作队列后能够开启新线程，进行并发执行。
    [bp addExecutionBlock:^{
        NSLog(@"addExecutionBlock--2---%@",[NSThread currentThread]);
        
    }];
    [bp addExecutionBlock:^{
        NSLog(@"addExecutionBlock--2---%@",[NSThread currentThread]);
        
    }];
    
    //将操作加入到操作队列后能够开启新线程，进行并发执行。
    [queue addOperation:op];
    [queue addOperation:bp];
}

//2.1  NSOperationQueue 控制串行执行、并发执行

//最大并发操作数：maxConcurrentOperationCount
//maxConcurrentOperationCount 默认情况下为-1，表示不进行限制，可进行并发执行。
//maxConcurrentOperationCount 为1时，队列为串行队列。只能串行执行。
//maxConcurrentOperationCount 大于1时，队列为并发队列。操作并发执行，当然这个值不应超过系统限制，即使自己设置一个很大的值，系统也会自动调整为 min{自己设定的值，系统设定的默认最大值}。
- (void)setMaxConcurrentOperationCount {
    //1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //2.设置最大并发数
//    queue.maxConcurrentOperationCount = 1; //串行队列
//    queue.maxConcurrentOperationCount = 2; //并发队列
    queue.maxConcurrentOperationCount = 8; //并发队列

    //3.添加操作
    [queue addOperationWithBlock:^{
        NSLog(@"addOperationWithBlock--1---%@",[NSThread currentThread]);

    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"addOperationWithBlock--2---%@",[NSThread currentThread]);
        
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"addOperationWithBlock--3---%@",[NSThread currentThread]);
        
    }];
    
    
    NSLog(@"setMaxConcurrentOperationCount-----%@",[NSThread currentThread]);
}

//3 NSOperation 操作依赖
//NSOperation、NSOperationQueue 最吸引人的地方是它能添加操作之间的依赖关系。通过操作依赖，我们可以很方便的控制操作之间的执行先后顺序。NSOperation 提供了3个接口供我们管理和查看依赖。
//现在考虑这样的需求，比如说有 A、B 两个操作，其中 A 执行完操作，B 才能执行操作
- (void)addDependency {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"NSBlockOperation- 1--%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"NSBlockOperation- 2--%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"NSBlockOperation- 3--%@",[NSThread currentThread]);
    }];
    
    //添加依赖
    [op2 addDependency:op1]; //op2依赖于op1，则先执行完op1，再执行op2
    [op3 addDependency:op2];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    
    NSLog(@"addDependency-----%@",[NSThread currentThread]);
}
@end
