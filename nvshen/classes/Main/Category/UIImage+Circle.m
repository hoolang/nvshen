//
//  UIImage+Circle.m
//  nvshen
//
//  Created by hoolang on 15/6/16.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "UIImage+Circle.h"

@implementation UIImage (Circle)
- (UIImage *)clipCircleImageWithBorder:(CGFloat) border borderColor:(UIColor *)color
{
    // 圆环的宽度
    CGFloat borderW = border;
    
    // 新的图片尺寸
    CGFloat imageW = self.size.width + 2 * borderW;
    CGFloat imageH = self.size.height + 2 * borderW;
    
    // 设置新的图片尺寸
    CGFloat circirW = imageW > imageH ? imageH : imageW;
    
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(circirW, circirW), NO, 0.0);
    
    // 画大圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, circirW, circirW)];
    
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加到上下文
    CGContextAddPath(ctx, path.CGPath);
    
    [color set];
    
    // 渲染
    CGContextFillPath(ctx);
    
    CGRect clipR = CGRectMake(borderW, borderW, self.size.width, self.size.height);
    
    // 画圆：正切于旧图片的圆
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:clipR];
    
    // 设置裁剪区域
    [clipPath addClip];
    
    
    // 画图片
    [self drawAtPoint:CGPointMake(borderW, borderW)];
    
    // 获取新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

//等比例缩放
-(UIImage*)scaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}
@end
