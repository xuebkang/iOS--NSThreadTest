//
//  ViewController.m
//  多线程---NSThread_Test
//
//  Created by CJW on 2019/8/5.
//  Copyright © 2019 CJW. All rights reserved.
//

#import "ViewController.h"
#import "TicketManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"NSThread测试" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(50, 100, self.view.bounds.size.width - 100, 40);
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(nsThreadTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *button2  = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"NSThread线程保护测试" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button2.frame = CGRectMake(50, 200, self.view.bounds.size.width - 100, 40);
    button2.backgroundColor = [UIColor whiteColor];
    [button2 addTarget:self action:@selector(saleTickets) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    
}
- (void)nsThreadTest{
    NSLog(@"主线程执行！！！");
    //1：通过alloc  init方式创建NSThread
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(runThread1) object:nil];
    [thread1 setName:@"子线程1"];
     // 设置优先级 优先级从0到1 1最高
    [thread1 setThreadPriority:0.9];
    //启动线程
    [thread1 start];
    
    //2:使用NSThread类方法显式创建并启动线程
//    [NSThread detachNewThreadSelector:@selector(runThread1) toTarget:self withObject:nil];
    
    //隐式创建并启动线程
//    [self performSelectorInBackground:@selector(runThread1) withObject:nil];
}

- (void)runThread1{
    
 
    NSLog(@"子线程执行！！！");
    NSLog(@"子线程名称： %@", [NSThread currentThread].name);
    // 线程阻塞 -- 延迟到某一时刻 --- 这里的时刻是2秒以后
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    NSLog(@"sleep end");
    NSLog(@"sleep again");
    // 线程阻塞 -- 延迟多久 -- 这里延迟2秒
    [NSThread sleepForTimeInterval:2];
     NSLog(@"sleep again end");

    for (int i = 0; i < 15; i++) {
        NSLog(@"i = %d", i);
        if (i == 10) {
            //
            [[NSThread currentThread] cancel];
            NSLog(@"线程结束状态标志");
        }
        if ([[NSThread currentThread] isCancelled]) {
            //结束线程
            NSLog(@"线程结束！！！");
            [NSThread exit];
        }
    }
}
//卖票方法
- (void)saleTickets{
    TicketManager *manager = [[TicketManager alloc] init];
    [manager startToSale];
}

@end
