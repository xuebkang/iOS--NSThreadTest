//
//  TicketManager.m
//  多线程---NSThread_Test
//
//  Created by CJW on 2019/8/7.
//  Copyright © 2019 CJW. All rights reserved.
//

#import "TicketManager.h"
#define TotalTicket  50
@interface TicketManager ()
@property  int tickets;  //剩余票数
@property  int saleCount; //卖出票数

@property (nonatomic, strong) NSThread *threadBJ;
@property (nonatomic, strong) NSThread *threadSH;
@property (nonatomic, strong) NSCondition *ticketCondition;  //线程保护
@end

@implementation TicketManager
- (instancetype)init{
    self = [super init];
    if (self) {
        self.ticketCondition = [[NSCondition alloc] init];
        self.tickets = TotalTicket;
        
        self.threadBJ = [[NSThread alloc] initWithTarget:self selector:@selector(sale) object:nil];
        [self.threadBJ setName:@"北京站"];
        
        self.threadSH = [[NSThread alloc] initWithTarget:self selector:@selector(sale) object:nil];
        [self.threadSH setName:@"上海站"];
    }
    return self;
}

//- (void)sale{
//        while (true) {
//            //剩余票数 > 0
//             //利用线程锁 -- 线程保护
//            @synchronized (self) {
//                if (self.tickets > 0) {
//                    //间隙为1秒
//                    [NSThread sleepForTimeInterval:0.3];
//                    self.tickets--;
//                    self.saleCount = TotalTicket - self.tickets;
//                    NSLog(@"%@: 当前余票：%d   售出票数：%d ",[NSThread currentThread].name ,self.tickets, self.saleCount);
//                }
//            }
//        }
//}

- (void)sale{
    while (true) {
        //剩余票数 > 0
        [self.ticketCondition lock];  //线程锁
        if (self.tickets > 0) {
                //间隙为1秒
                [NSThread sleepForTimeInterval:0.3];
                self.tickets--;
                self.saleCount = TotalTicket - self.tickets;
                NSLog(@"%@: 当前余票：%d   售出票数：%d ",[NSThread currentThread].name ,self.tickets, self.saleCount);
            }
        [self.ticketCondition unlock];  //线程解锁
    }
}
//卖票的方法
- (void)startToSale{
    [self.threadBJ start];
    [self.threadSH start];
}
@end
