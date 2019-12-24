//
//  UIImageView+test.m
//  test1218
//
//  Created by he gao on 2019/12/18.
//  Copyright © 2019 he gao. All rights reserved.
//

#import "UIImageView+test.h"
#import <objc/runtime.h>

//#import <AppKit/AppKit.h>


@implementation UIImageView (test)

static char styleKey;
- (void) setStyle:(NSObject *) style
{
    objc_setAssociatedObject(self, &styleKey, style, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSObject *) style
{
   return objc_getAssociatedObject(self, &styleKey);
}
@end

//
//- (NSObject *) getStyle0
//{
//   return objc_getAssociatedObject(self, &styleKey);
//}

