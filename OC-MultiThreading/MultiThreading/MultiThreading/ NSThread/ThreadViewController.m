//
//  ThreadViewController.m
//  MultiThreading
//
//  Created by 叮咚钱包富银 on 2018/5/25.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "ThreadViewController.h"

@interface ThreadViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) NSInteger ticketCount;
@end

@implementation ThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //NSThread
    [self createNSThread];
    [self autoStartThread];
}

#pragma mark --- NSThread 简单使用
//NSThread 是基于pthread面向对象，简单易用，可以直接操作线程对象，不过需要程序员自己管理线程的生活周期（主要是创建）

//先创建，在启动
- (void)createNSThread {
    //1.创建线程
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    //2.启动线程
    [thread start];
}

- (void)run {
    NSLog(@"%@",[NSThread currentThread]);
}

//创建线程后自动启动线程
- (void)autoStartThread {
    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
}

#pragma mark -- 图片下载

- (void)downloadImage {
    NSLog(@"current-thread --- %@",[NSThread currentThread]);
    
    //下载图片
    NSURL *url = [NSURL URLWithString:@"http://www.taopic.com/uploads/allimg/140714/234975-140G4155Z571.jpg"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    //回到主线程刷新界面
    [self performSelectorOnMainThread:@selector(refreshOnMainThread:) withObject:image waitUntilDone:YES];
}

- (void)refreshOnMainThread:(UIImage *)image {
    NSLog(@"current thread -- %@", [NSThread currentThread]);
    // 赋值图片到imageview
    self.imageView.image = image;
}

- (IBAction)downloadAction:(id)sender {
    [NSThread detachNewThreadSelector:@selector(downloadImage) toTarget:self withObject:nil];
}

#pragma mark -- 线程安全，加锁，卖火车票案例

- (IBAction)sellTicketAcion:(id)sender {
    
    [self initTicketStatusSave];
}

/**
 初始化卖火车票线程
 */
- (void)initTicketStatusSave {
    
    //1、设置总票数
    self.ticketCount = 100;
    
    //2.初始化两个窗口售卖
    NSThread *window1 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicketSafe) object:nil];
    window1.name = @"北京火车站";
    
    NSThread *window2 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicketSafe) object:nil];
    window2.name = @"广州火车站";
    
    //3.开启线程
    [window1 start];
    [window2 start];
}

- (void)saleTicketSafe {
    while (1) {
        //1.加互斥锁
        @synchronized(self) {
            if (self.ticketCount > 0) {
                self.ticketCount--;
                NSLog(@"剩余票数：%ld 窗口： %@",self.ticketCount, [NSThread currentThread].name);
                //让当前线程睡眠0.2s
                [NSThread sleepForTimeInterval:0.2];
            } else {
                NSLog(@"已经全部卖完");
                break;
            }
        }
    }
}

@end
