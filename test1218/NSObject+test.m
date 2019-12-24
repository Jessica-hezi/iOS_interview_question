//
//  NSObject+test.m
//  test1218
//
//  Created by he gao on 2019/12/18.
//  Copyright © 2019 he gao. All rights reserved.
//

#import "NSObject+test.h"
#import <objc/runtime.h>
//#import <AppKit/AppKit.h>


@implementation NSObject (test)

void dynamicMethodIMP(id self, SEL _cmd) {
    NSLog(@" >> dynamicMethodIMP");
}

+ (BOOL)resolveClassMethod:(SEL)sel{
    
    return YES;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{
     
      if (sel == @selector(test)) {
          IMP imp = [self instanceMethodForSelector:@selector(myClassMethod)];
          class_addMethod(self, sel, imp, "v@:");
          return YES;
      }
    return YES;
}
- (void)myClassMethod {
    NSLog(@"resolveInstanceMethod");
}
@end
