//
//  ViewController.m
//  多线程---NSThread_Test
//
//  Created by CJW on 2019/8/5.
//  Copyright © 2019 CJW. All rights reserved.
//  NSThread 可以直接操作线程对象，不过需要自己来管理线程的生命周期（主要是创建）。开发中，使用频率不高，我们会经常调用[NSThread currentThread]来显示当前的进程信息。

#import "ViewController.h"
#import "TicketManager.h"
@interface ViewController ()
@property (nonatomic, strong) UIButton    *downloadImgBtn;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton    *nsthreadTestBtn;
@property (nonatomic, strong) UIButton    *saleButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.nsthreadTestBtn];
    [self.view addSubview:self.saleButton];
    [self.view addSubview:self.downloadImgBtn];
    [self.view addSubview:self.imageView];
}

- (UIButton *)nsthreadTestBtn{
    if (!_nsthreadTestBtn) {
        _nsthreadTestBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_nsthreadTestBtn setTitle:@"NSThread测试" forState:UIControlStateNormal];
        [_nsthreadTestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _nsthreadTestBtn.frame = CGRectMake(50, 70, self.view.bounds.size.width - 100, 40);
        _nsthreadTestBtn.backgroundColor = [UIColor whiteColor];
        [_nsthreadTestBtn addTarget:self action:@selector(nsThreadTest) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nsthreadTestBtn;
}
- (UIButton *)saleButton{
    if (!_saleButton) {
        _saleButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saleButton setTitle:@"NSThread线程保护测试--卖车票实例" forState:UIControlStateNormal];
        [_saleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _saleButton.frame = CGRectMake(50, 130, self.view.bounds.size.width - 100, 40);
        if (@available(iOS 8.2, *)) {
            _saleButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:0.4];
        } else {
            _saleButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        }
        _saleButton.backgroundColor = [UIColor whiteColor];
        [_saleButton addTarget:self action:@selector(saleTickets) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saleButton;;
}

- (UIButton *)downloadImgBtn{
    if (!_downloadImgBtn) {
        _downloadImgBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_downloadImgBtn setTitle:@"测试下载图片并显示" forState:UIControlStateNormal];
        [_downloadImgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _downloadImgBtn.frame = CGRectMake(50, 190, self.view.bounds.size.width - 100, 40);
        _downloadImgBtn.backgroundColor = [UIColor whiteColor];
        [_downloadImgBtn addTarget:self action:@selector(downLoadImg:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadImgBtn;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 250, [UIScreen mainScreen].bounds.size.width - 100, 200)];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _imageView;
}
- (void)nsThreadTest{
    NSLog(@"主线程执行！！！");
    //创建线程的三种方式****************************
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
//    [self performSelectorOnMainThread:@selector(runThread1) withObject:self waitUntilDone:YES];
}

//线程相关用法
- (void)NSThreadUsed{
    // 获得主线程
//    + (NSThread *)mainThread;

    // 判断是否为主线程(对象方法)
//    - (BOOL)isMainThread;

    // 判断是否为主线程(类方法)
//    + (BOOL)isMainThread;

    // 获得当前线程
//    NSThread *current = [NSThread currentThread];

    // 线程的名字——setter方法
//    - (void)setName:(NSString *)n;

    // 线程的名字——getter方法
//    - (NSString *)name;

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
            //结束线程, 线程进入死亡状态
            NSLog(@"线程结束！！！");
            [NSThread exit];
        }
    }
}

//线程之间的通信********************************************************
// 在主线程上执行操作
//- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait{
//
//}
//- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray<NSString *> *)array{
//
//}
//  // equivalent to the first method with kCFRunLoopCommonModes
//
//// 在指定线程上执行操作
//- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray *)array NS_AVAILABLE(10_5, 2_0){
//
//}
//- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait NS_AVAILABLE(10_5, 2_0){
//
//}

// 在当前线程上执行操作，调用 NSObject 的 performSelector:相关方法
//- (id)performSelector:(SEL)aSelector{
//
//}
//- (id)performSelector:(SEL)aSelector withObject:(id)object{
//
//}
//- (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2{
//
//}

//通过一个经典的下载图片 DEMO 来展示线程之间的通信。具体步骤如下：
//1:开启一个子线程，在子线程中下载图片。
//2:回到主线程刷新 UI，将图片展示在 UIImageView 中。

- (void)downLoadImg:(id)sender{
    //显式创建一个线程下载图片
     [NSThread detachNewThreadSelector:@selector(downloadImage) toTarget:self withObject:nil];
}


//下载图片，完成后回到主线程刷新UI
- (void)downloadImage{
    NSLog(@"current thread ---%@", [NSThread currentThread].name);
    NSURL *imageUrl = [NSURL URLWithString:@"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRipUWKZw9OZZ6NWcIEUXYhXDHOmY_U5ODnNE-_EHeoeWFthlY2&usqp=CAU"];
     //  从 imageUrl 中读取数据(下载图片) -- 耗时操作
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    //通过二进制 data 创建 image
    UIImage *image = [UIImage imageWithData:imageData];
    //回到主线程进行图片赋值和界面刷新
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:YES];

}
////主线程刷新UI
- (void)updateImage:(UIImage *)image{
    NSLog(@"current thread -- %@", [NSThread currentThread].name);
    //图片赋值
    self.imageView.image = image;
}

//卖票方法
- (void)saleTickets{
    TicketManager *manager = [[TicketManager alloc] init];
    [manager startToSale];
}

@end
