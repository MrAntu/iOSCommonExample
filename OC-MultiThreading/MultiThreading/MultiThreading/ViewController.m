//
//  ViewController.m
//  MultiThreading
//
//  Created by 叮咚钱包富银 on 2018/5/25.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "ViewController.h"
#import "ThreadViewController.h"
#import "OperationViewController.h"
#import "GCDViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (IBAction)threadAction:(id)sender {
    ThreadViewController *vc = [[ThreadViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)operationAction:(id)sender {
    OperationViewController *vc = [[OperationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)gcdAction:(id)sender {
    GCDViewController *vc = [[GCDViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

@end
