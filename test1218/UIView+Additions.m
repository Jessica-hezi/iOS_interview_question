//
//  UIView+Additions.m
//  test1218
//
//  Created by he gao on 2019/12/19.
//  Copyright © 2019 he gao. All rights reserved.
//

#import "UIView+Additions.h"

//#import <AppKit/AppKit.h>


@implementation UIView (Additions)

// 错误解法
//- (UIView *)viewWithLocalPoint:(CGPoint)p{
//    for (UIView *v in self.subviews) {
//      // 判断坐标系点是否在视图范围内
//        if ([v pointInside:p withEvent:nil]) {
//             return v;
//        }
//    }
//     return nil;
//}

- (UIView *)viewWithLocalPoint:(CGPoint)p{

    UIView *view;
    for (UIView *v in self.subviews) {
        //转换坐标系点
        CGPoint convertPoint = [self convertPoint:p toView:v];
        // 判断坐标系点是否在视图范围内
        if ([v pointInside:convertPoint withEvent:nil]) {
            view = v;
        }
    }

    if (view != nil) {
        return view;
    }else{
        return nil;
    }
}

// 误入
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    if ([self pointInside:point withEvent:event]) {
//
//        for (UIView* v in self.subviews) {
//            if ([v pointInside:point withEvent:nil]) {
//                NSLog(@"v--%@",v);
//                return v;
//            }
////            CGPoint makepoint = [view convertPoint:point fromView:self];
//////            UIView* hitView = [view hitTest:makepoint withEvent:event];
////            if (hitView) {
////                 NSLog(@"v--%@",hitView);
////                return hitView;
////            }
//        }
//
//        return self;
//    }
//    return nil;
//}

@end
