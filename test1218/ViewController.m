//
//  ViewController.m
//  test1218
//
//  Created by he gao on 2019/12/18.
//  Copyright © 2019 he gao. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+test.h"
#import "timerVC.h"
#import "coreView.h"
#import "UIView+Additions.h"

@interface ViewController ()
{
    UIImageView *mImageView;
    UIView *view1;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//以下代码存在的问题是：定时器不执行，因为子线程中定时器需要手动调用 RunLoop
// [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(actionTime:) userInfo:nil repeats:YES];
//    });
//    dispatch_queue_t queue = dispatch_queue_create("com.apple.www", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue, ^{
//       [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(actionTime:) userInfo:nil repeats:YES];
//    });
    
    
//   死锁
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        printf("1");
//    });
//    printf("2");
    
    
// 找出编译错误
//    NSError * error = nil;
//    // NSError ** plError = &error;
//    __strong NSError ** pError1 = &error;
//    NSError __strong ** pError2 = &error ;
//    NSError * __strong * pError3 = &error;
// NSError ** __strong pError4 = &error; 错误写法
    
    
    [self test6];
    [self test5_Point];
    [self test4_Coretext];
    [self test3_currentQueue];
    [self test2_NSTimer];
    [self test1_Image];
}

#pragma mark - 6. 一个数如果恰好等于它的因子之和，这个数就被称为“完数”。例如 6 = 1 + 2 + 3，请找出 1000 以内的所有完数。
- (void)test6 {
    for (int i=1; i<=1000;i++ ) {
        int temp=0;
        for (int j=1; j<(i%2==0?i/2+1:(i+1)/2); j++) {
            if (i%j==0) {
                temp+=j;
                if ((j==i/2||j+1==(i+1)/2)&&temp == i) {
                   NSLog(@"i==%d",i);
               }
            }
           
        }
    }
}

#pragma mark - 5. 请实现如下定义的 UIView Category 方法，返回 self 上用于响应位于点 P 的点击事件的子视图（包含点 P 的最上层的子视图）。
- (void)test5_Point {
    view1 = [[UIView alloc]initWithFrame:CGRectMake(10, 50, 360, 500)];
    view1.backgroundColor=[UIColor blackColor];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(50, 100, 280, 400)];
     view2.backgroundColor=[UIColor yellowColor];
     [self.view addSubview:view2];
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(90, 150, 200, 300)];
     view3.backgroundColor=[UIColor redColor];
     [self.view addSubview:view3];
    
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(130, 200, 120, 200)];
     view4.backgroundColor=[UIColor blueColor];
     [self.view addSubview:view4];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(170, 300, 60, 30)];
    label.backgroundColor = [UIColor greenColor];
    [self.view addSubview:label];

    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(30, 600, 120, 100)];
    view5.backgroundColor=[UIColor systemPinkColor];
    [self.view addSubview:view5];
    
}

#pragma mark - 4. 使用 CoreText API 绘制文字“我是中国人”，要求字体大小：18，颜色：“我是”黑色，“中国人”红色。
- (void)test4_Coretext {
    coreView *view = [[coreView alloc]initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
}

#pragma mark - 3. 如何实现在当前线程等待一个子线程任务执行结束，然后继续执行当前线程任务（比如，使用 NSURLSession 封装一个同步的网络请求）
- (void)test3_currentQueue {
    [self GCD_syncTest];
    [self GCD_groupTest];
    [self GCD_semaphoreTest];
}

- (void)GCD_semaphoreTest {
    
    // dispatch_semaphore_create 用于创建信号量，此处需要设置为 0 ，其他应用中可以设置10、100都行
    // dispatch_semaphore_signal 用于将信号量加1
    // dispatch_semaphore_wait 会一直等待直到信号量大于等于 1 才会执行后续操作
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        //[网络请求:^{
            //请求回调
            dispatch_semaphore_signal(sema);
       // }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
    
}

- (void)GCD_groupTest {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"I'm in dispatch_get_global_queue");//DISPATCH_QUEUE_CONCURRENT //DISPATCH_QUEUE_SERIAL==NULL
        dispatch_queue_t queue =dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT );
    

        dispatch_group_t _waitGroup = dispatch_group_create();
        dispatch_group_async(_waitGroup, queue, ^{
             for (int i = 0; i<10; i++) {
                NSLog(@"dispatch_group_async %d",i);
            }
        });
        dispatch_group_async(_waitGroup, queue, ^{
             for (int i = 10; i<20; i++) {
                NSLog(@"dispatch_group_async %d",i);
            }
        });
        dispatch_group_async(_waitGroup, queue, ^{
             for (int i = 30; i<40; i++) {
                NSLog(@"dispatch_group_async %d",i);
            }
        });
        
        //两种通知方式1
        dispatch_group_notify(_waitGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             NSLog(@"I have done dispatch_group_async");
        });
    
        //两种通知方式2
        long result = dispatch_group_wait(_waitGroup, DISPATCH_TIME_FOREVER);
        if (result == 0) {
            NSLog(@"dispatch_group_t have done");
        }

    });
}

- (void)GCD_syncTest {
    dispatch_queue_t queue =dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT );
    
    dispatch_async(queue, ^{
            NSLog(@"dispatch_async %d",1);
    });

    dispatch_async(queue, ^{
            NSLog(@"dispatch_async %d",2);
    });

    dispatch_sync(queue, ^{
        for (int i = 0; i<100; i++) {
            NSLog(@"dispatch_barrier_async %d",i);
        }
    });

    dispatch_async(queue, ^{
            NSLog(@"dispatch_async %d",3);
    });

    dispatch_async(queue, ^{
            NSLog(@"dispatch_async %d",4);
    });
    
    #if OS_OBJECT_USE_OBJC //ios 6 以后 GCD 无须自行释放

    #else
       dispatch_release(queue);
    #endif
}

#pragma mark - 2.请简单描述一下在子线程中创建并 schedule 一个 NSTimer 的步骤，简要描述一下 NSTimer 在使用过程中可能出现的问题。
- (void)test2_NSTimer {
    [self presentViewController:[timerVC new] animated:YES completion:nil];
}

#pragma mark - 1.给定一个宽度任意、高度为1的 UIImageView,以宽度的80%为圆心，进行旋转，请写出实现该动画效果的关键代码。
- (void)test1_Image {
    mImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 200, 200, 1)];
    mImageView.backgroundColor=[UIColor greenColor];
    [self.view addSubview:mImageView];
    
    UIImageView *mImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(220, 200, 1, 1)];
    mImageView2.backgroundColor=[UIColor redColor];
    [self.view addSubview:mImageView2];
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2 ];//旋转一圈 360°
    rotationAnimation.duration = 3.0;  //动画时间
    rotationAnimation.cumulative = YES;  // 指定累计
    rotationAnimation.repeatCount = 3.0;  //动画重复的次数
    //'(0, 0)' is the bottom left corner of the bounds rect, '(1, 1)' is the top right corner. Defaults to'(0.5, 0.5)'
    mImageView.layer.anchorPoint = CGPointMake(0.8, 0.5);//锚定点 X 偏移到80%,即0.8,Y 无须偏移
    //这里必须设置position,否则圆心仍旧是 mImageView 的中心位置, X、Y 都是相对于 mImageView 父视图的绝对值 X =（60+200*0.8）
    mImageView.layer.position = CGPointMake(220, 200);
    [mImageView.layer addAnimation:rotationAnimation forKey:@"animation"];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取点击点的坐标
    CGPoint touchPoint = [[touches  anyObject] locationInView:self.view];
    [self.view viewWithLocalPoint:touchPoint];
}


//- (void)testImage {
//    UIImageView *mImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image.png"]];
//    mImageView.style = @"style001";
//    NSLog(@"The style is %@",mImageView.style);
//
//}

- (void)actionTime:(NSTimer *)time {
    NSLog(@"------ %@",[NSDate date]);
    [self stopThread];
//    [self performSelector:@selector(test)];
}

// 用于停止子线程的RunLoop
- (void)stopThread {
    // 设置标记为YES
//    self.stopTimer = YES;
    // 停止RunLoop
    CFRunLoopStop(CFRunLoopGetCurrent());
    // 清空线程
//    self.thread = nil;
    NSLog(@"test end");
}

@end
