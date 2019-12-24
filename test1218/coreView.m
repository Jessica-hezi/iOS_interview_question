//
//  coreView.m
//  test1218
//
//  Created by he gao on 2019/12/20.
//  Copyright © 2019 he gao. All rights reserved.
//

#import "coreView.h"
#import <CoreText/CoreText.h>

@implementation coreView

- (void)drawRect:(CGRect)rect{
    
    //1.获取当前绘图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //2.旋转坐标系(默认和UIKit坐标是相反的)
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //3.创建绘制局域
    CGMutablePathRef path = CGPathCreateMutable();
    
    //4:创建一个矩形文本区域。
    CGRect bounds = CGRectMake(100.0,self.bounds.size.height-150,200.0,50.0);
    CGPathAddRect(path,NULL,bounds);
    
    // 完成了文本区域的设置,开始准备显示的素材,这里就显示一段文字。
     CFStringRef textString = CFSTR("我是中国人");
     
    //创建一个多属性字段,maxlength为0；maxlength是提示系统有需要多少内部空间需要保留,0表示不用提示限制。
     CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
     
    //为attrString添加内容,也可以用CFAttributedStringCreate 开头的几个方法,根据不同的需要和参数选择合适的方法。这里用替换的方式,完成写入。
     CFAttributedStringReplaceString (attrString, CFRangeMake(0, 0),textString);//此时attrString就有内容了
    
    //为多属性字符串增添一个颜色的属性,这里就是奇妙之处,富文本的特点就在这里可以自由的调整文本的属性：比如,颜色,大小,字体,下划线,斜体,字间距,行间距等
     CGColorSpaceRef rgbColorSpace =CGColorSpaceCreateDeviceRGB();
    
    //创建一个颜色容器对象,这里我们用RGB,当然还有很多其他颜色容器对象,可以根据需要和方便自由搭配,总有一款适合你的。
     //创建一个红色的对象
     CGFloat components[] = {1.0,0.0,0.0,0.8};
     CGColorRef red = CGColorCreate(rgbColorSpace,components);

    //创建一个黑色的对象
    CGFloat components_b[] = {0.0,0.0,0.0,1.0};
    CGColorRef black = CGColorCreate(rgbColorSpace,components_b);
    CGColorSpaceRelease(rgbColorSpace);//不用的对象要及时回收哦

     //给前2个字符增添红色属性
     CFAttributedStringSetAttribute(attrString,CFRangeMake(0,2),kCTForegroundColorAttributeName,black);
     CFAttributedStringSetAttribute(attrString,CFRangeMake(2,3),kCTForegroundColorAttributeName,red);
    
    //设置字体大小
     UIFont  *uiFont = [UIFont fontWithName:@"Helvetica" size:18.0];
     CTFontRef ctFont = CTFontCreateWithName((CFStringRef) uiFont.fontName, uiFont.pointSize, NULL);
     CFAttributedStringSetAttribute(attrString,CFRangeMake(0,5), kCTFontAttributeName, ctFont);
    
    //kCTForegroundColorAttributeName,是CT定义的表示文本字体颜色的常量,类似的常量茫茫多,组成了编辑富文本的诸多属性。
    //通过多属性字符,可以得到一个文本显示范围的工厂对象,我们最后渲染文本对象是通过这个工厂对象进行的。这部分需要引入#import<CoreText/CoreText.h>
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
     
     //创建一个有文本内容的范围
     CTFrameRef frame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0),path,NULL);
     //把内容显示在给定的文本范围内；
     CTFrameDraw(frame,context);
    
     //完成任务就把我们创建的对象回收掉,内存宝贵,不用了就回收,这是好习惯。
     CFRelease(frame);
     CFRelease(framesetter);
     CFRelease(path);
     CFRelease(ctFont);
     CFRelease(attrString);
}

@end
