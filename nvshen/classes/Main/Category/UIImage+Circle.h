//
//  UIImage+Circle.h
//  nvshen
//
//  Created by hoolang on 15/6/16.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Circle)
- (UIImage *)clipCircleImageWithBorder:(CGFloat) border borderColor:(UIColor *)color;
-(UIImage*)scaleToSize:(CGSize)size;
@end
