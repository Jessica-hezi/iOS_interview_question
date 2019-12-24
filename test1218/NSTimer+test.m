//
//  NSTimer+test.m
//  test1218
//
//  Created by he gao on 2019/12/19.
//  Copyright © 2019 he gao. All rights reserved.
//

#import "NSTimer+test.h"

//#import <AppKit/AppKit.h>



@implementation NSTimer (test)

+ (instancetype)repeatWithInterval:(NSTimeInterval)interval block:(void(^)(NSTimer *timer))block {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(trigger:) userInfo:[block copy] repeats:YES];
    return timer;
}

+ (void)trigger:(NSTimer *)timer {
    void(^block)(NSTimer *timer) = [timer userInfo];
    if (block) {
        block(timer);
    }
}

@end
