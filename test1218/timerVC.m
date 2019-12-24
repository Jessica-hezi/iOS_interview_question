//
//  timerVC.m
//  test1218
//
//  Created by he gao on 2019/12/19.
//  Copyright © 2019 he gao. All rights reserved.
//

#import "timerVC.h"
#import "NSTimer+test.h"

@interface timerVC ()
//@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (assign, nonatomic) BOOL stopTimer;
@end

@implementation timerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];
    __weak typeof(self) weakSelf = self;
    _queue = dispatch_queue_create("com.apple.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(_queue, ^{
//        weakSelf.timer =[NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            [weakSelf timerRun];
//        }];
//        NSTimer *timer =[NSTimer timerWithTimeInterval:1.0 target:weakSelf selector:@selector(timerRun) userInfo:nil repeats:YES];
        NSTimer *timer =[NSTimer repeatWithInterval:1.0 block:^(NSTimer * _Nonnull timer) {
            [weakSelf timerRun];
        }];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        
    });
}

- (void)timerRun {
    NSLog(@"thread - %@ - %s", [NSThread currentThread], __func__);
}

- (void)dealloc {
    [self stop];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [self stop];
}
- (void)stop {
//    __weak typeof(self) weakSelf = self;
//    dispatch_async(_queue, ^{
        // 设置标记为YES
        self.stopTimer = YES;
        // 停止RunLoop
//    [self.timer invalidate];
        CFRunLoopStop(CFRunLoopGetCurrent());
        NSLog(@"停止RunLoop");
//    });
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
