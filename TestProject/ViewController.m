//
//  ViewController.m
//  TestProject
//
//  Created by Apple on 15/2/2.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "Account.h"
#import "DownloadImgOperation.h"
#import "Person.h"

#define NOTIFICATIONNAME @"notifiName"
#define PROGRESS_CHANGED @"progress_changed"

@interface ViewController (){
    NSOperationQueue *_queue;
    UIProgressView *_progressView;
    UIButton *_btn;
    NSThread *_thread;
    UIImageView *_imageView;
    
    dispatch_queue_t _serialQueue;
    dispatch_queue_t _conCurrentQueue;
}

@end

@implementation ViewController{
    Account *_account;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATIONNAME object:nil];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    Person *person = [[Person alloc] init];
    [person setValue:@"小明" forKey:@"name"];
    NSLog(@"person->_name:%@  person->name:%@",person->_name,person->name);
    [person setValue:nil forKey:@"age"];
    NSLog(@"person->age:%@",[person valueForKey:@"age"]);

    //本地通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:NOTIFICATIONNAME object:nil];
//    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFICATIONNAME object:nil queue:nil usingBlock:^(NSNotification *noti){
//        NSLog(@"%@",noti.userInfo);
//    }];
    
    UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(100, 60, 0, 0)];
    NSLog(@"%@",NSStringFromCGRect(switchBtn.frame));
    [switchBtn addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchBtn];
    
    //自定义通知
    _btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    _btn.frame = CGRectMake(100, 120, 50, 30);
    [_btn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 160, self.view.frame.size.width-20, 5)];
    [self.view addSubview:_progressView];
    
    _queue = [[NSOperationQueue alloc] init];
    _queue.maxConcurrentOperationCount = 10;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:PROGRESS_CHANGED object:nil];
    
    //线程
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 350, 80, 30)];
//    [btn setTitle:@"取消线程" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(cancelThread) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//    
//    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(runThread) object:nil];
//    [_thread start];
    
    //线程优先级
//    NSLog(@"UI线程的优先级为%f",[NSThread threadPriority]);
//    
//    NSThread *threadA = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
//    NSLog(@"线程A的优先级%f",[threadA threadPriority]);
//    threadA.name = @"线程A";
//    threadA.threadPriority = 0.0;
//    
//    NSThread *threadB = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
//    NSLog(@"线程B的优先级%f",[threadB threadPriority]);
//    threadB.name = @"线程B";
//    threadB.threadPriority = 1.0;
//    
//    [threadA start];
//    [threadB start];
    
    
    //银行取钱
    _account = [[Account alloc] initWithAccountNo:@"12306" balance:1000.0];
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 180, 80, 30)];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 setTitle:@"取钱" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(draw) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    //GCD
    _serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    _conCurrentQueue = dispatch_queue_create("conCurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    UIButton *btnSerial = [[UIButton alloc] initWithFrame:CGRectMake(30, 220, 100, 30)];
    [btnSerial setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnSerial setTitle:@"SerialQueue" forState:UIControlStateNormal];
    [btnSerial addTarget:self action:@selector(serial) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSerial];
    
    UIButton *btnConcurrent = [[UIButton alloc] initWithFrame:CGRectMake(150, 220, 150, 30)];
//    [btnConcurrent setBackgroundImage:[UIImage imageNamed:@"1_phunxm.jpg"] forState:UIControlStateHighlighted];
//    [btnConcurrent setBackgroundImage:[UIImage imageNamed:@"6(T%HBCN}0WOIQ(L`I8YU6B.jpg"] forState:UIControlStateNormal];
    [btnConcurrent setTitle:@"ConcurrentQueue" forState:UIControlStateNormal];
    [btnConcurrent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnConcurrent addTarget:self action:@selector(operationSubClassTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnConcurrent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBack:) name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-100, self.view.frame.size.width, 100)];
    [self.view addSubview:_imageView];
}

- (void)operationSubClassTest{
    DownloadImgOperation *operation = [[DownloadImgOperation alloc] initWith:[NSURL URLWithString:@"http://www.crazyit.org/logo.jpg"] imageView:_imageView];
    [_queue addOperation:operation];
}

- (void)blockOperationTest{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.crazyit.org/logo.jpg"]];
        UIImage *image = [UIImage imageWithData:data];
        if (image != nil) {
            [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
        }else{
            NSLog(@"下载图片出现错误、、、");
        }
    }];
    [_queue addOperation:operation];
}

- (void)updateUI:(UIImage *)image{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 100)];
    imgView.image = image;
    [self.view addSubview:imgView];
}

- (void)enterBack:(NSNotification *)notification{
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier backTaskId = [app beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"额外申请的时间内未完成任务");
        [app endBackgroundTask:backTaskId];
    }];
    if (backTaskId == UIBackgroundTaskInvalid) {
        NSLog(@"后台任务启动失败");
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"额外申请的后台任务时间：%f",[app backgroundTimeRemaining]);
        
        for (int i=0; i<100; i++) {
            NSLog(@"后台任务完成%d%%",i);
            [NSThread sleepForTimeInterval:1];
        }
        
        NSLog(@"剩余的后台任务时间为：%f",[app backgroundTimeRemaining]);
        [app endBackgroundTask:backTaskId];
    });
}

- (void)dispatchOnce{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"执行dispatch_once代码块");
        [NSThread sleepForTimeInterval:3];
    });
}

- (void)dispatchApply{
    dispatch_apply(5, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t time){
        NSLog(@"%@---%zu",[NSThread currentThread],time);
    });
}

- (void)sync{
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=0; i<100; i++) {
            NSLog(@"%@===%d",[[NSThread currentThread] name],i);
            [NSThread sleepForTimeInterval:0.1];
        }
    });
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=0; i<100; i++) {
            NSLog(@"%@===%d",[[NSThread currentThread] name],i);
            [NSThread sleepForTimeInterval:0.1];
        }
    });
}

- (void)downloadImage{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.crazyit.org/logo.jpg"]];
        UIImage *image = [[UIImage alloc] initWithData:data];
        if (image != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 100)];
                iv.image = image;
                [self.view addSubview:iv];
            });
        }else{
            NSLog(@"下载图片失败");
        }
    });
}

- (void)serial{
    dispatch_async(_serialQueue, ^(void){
        for (int i=0; i<100; i++) {
            NSLog(@"%@===%d",[[NSThread currentThread] name],i);
        }
    });
    dispatch_async(_serialQueue, ^(void){
        for (int i=0; i<100; i++) {
            NSLog(@"%@===%d",[[NSThread currentThread] name],i);
        }
    });
}

- (void)conCurrent{
    dispatch_async(_conCurrentQueue, ^(void){
        for (int i=0; i<100; i++) {
            NSLog(@"%@===%d",[[NSThread currentThread] name],i);
        }
    });
    dispatch_async(_conCurrentQueue, ^{
        for (int i=0; i<100; i++) {
            NSLog(@"%@===%d",[[NSThread currentThread] name],i);
        }
    });
}

- (void)draw{
//    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(drawMethod:) object:[NSNumber numberWithInt:800]];
//    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(drawMethod:) object:[NSNumber numberWithInt:800]];
//    [thread1 start];
//    [thread2 start];
    [NSThread detachNewThreadSelector:@selector(drawMethod:) toTarget:self withObject:[NSNumber numberWithInt:800]];
    [NSThread detachNewThreadSelector:@selector(drawMethod:) toTarget:self withObject:[NSNumber numberWithInt:800]];
    [NSThread detachNewThreadSelector:@selector(drawMethod:) toTarget:self withObject:[NSNumber numberWithInt:800]];
    [NSThread detachNewThreadSelector:@selector(depositMethod:) toTarget:self withObject:[NSNumber numberWithInt:800]];
}

- (void)drawMethod:(NSNumber *)drawNumber{
    for (int i=0; i<100; i++) {
        [NSThread currentThread].name = @"消费者";
        [_account draw:[drawNumber doubleValue]];
    }
}

- (void)depositMethod:(NSNumber *)depositNumber{
    for (int i=0; i<100; i++) {
        [NSThread currentThread].name = @"生产者";
        [_account deposit:800.0];
    }
}

- (void)run{
    for (int i=0; i<100; i++) {
        NSLog(@"%@:%d",[[NSThread currentThread] name],i);
    }
}

- (void)runThread{
    for (int i=0; i<100; i++) {
        if ([[NSThread currentThread] isCancelled]) {
            [NSThread exit];
        }
        NSLog(@"----%@----%d",[NSThread currentThread].name,i);
        [NSThread sleepForTimeInterval:0.5];
    }
}

- (void)cancelThread{
    [_thread cancel];
}

- (void)switchValueChanged:(id)sender{
    UISwitch *sw = (UISwitch *)sender;
    if (sw.on) {
        UILocalNotification *localNoti = [[UILocalNotification alloc] init];
        localNoti.fireDate = [NSDate dateWithTimeIntervalSinceNow:6];
        localNoti.timeZone = [NSTimeZone defaultTimeZone];
        localNoti.repeatInterval = NSCalendarUnitMinute;
        localNoti.alertAction = @"查看";
        localNoti.hasAction = NO;
        localNoti.alertLaunchImage = @"1_phunxm.jpg";
        localNoti.alertBody = @"这是一条本地通知";
        localNoti.applicationIconBadgeNumber = 1;
        localNoti.userInfo = @{@"testValue":@"testKey"};
        [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
    }else{
        NSArray *localNotiArr = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *noti in localNotiArr) {
            [[UIApplication sharedApplication] cancelLocalNotification:noti];
            
//            NSDictionary *dict = noti.userInfo;
//            if ([[dict objectForKey:@"testKey"] isEqualToString:@"testValue"]) {
//                [[UIApplication sharedApplication] cancelLocalNotification:noti];
//            }
        }
    }
}

- (void)doPostNoti{
    NSDictionary *dict = @{@"key1":@"value1",@"key2":@"value2"};
    NSNotification *notifi = [[NSNotification alloc] initWithName:NOTIFICATIONNAME object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notifi];
}

- (void)didReceiveNoti:(NSNotification *)notification{
    NSLog(@"接受:%@",notification.userInfo);
}

- (void)start:(id)sender{
    __block int progStatus = 0;
    [sender setEnabled:NO];
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(void){
        for (int i=0; i<100; i++) {
            [NSThread sleepForTimeInterval:0.5];
            [[NSNotificationCenter defaultCenter] postNotificationName:PROGRESS_CHANGED object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:++progStatus],@"prog", nil]];
        }
    }];
    [_queue addOperation:operation];
}

- (void)update:(NSNotification *)noti{
    NSNumber *progStatus = [noti.userInfo objectForKey:@"prog"];
    NSLog(@"%d",progStatus.intValue);
    dispatch_async(dispatch_get_main_queue(), ^{
        _progressView.progress = progStatus.intValue/100.0;
        if (progStatus.intValue == 100) {
            [_btn setEnabled:YES];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
