//
//  NSTimer+test.h
//  test1218
//
//  Created by he gao on 2019/12/19.
//  Copyright © 2019 he gao. All rights reserved.
//

//#import <AppKit/AppKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (test)
+ (instancetype)repeatWithInterval:(NSTimeInterval)interval block:(void(^)(NSTimer *timer))block;

@end

NS_ASSUME_NONNULL_END
