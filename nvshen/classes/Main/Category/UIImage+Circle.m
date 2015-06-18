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
@end
