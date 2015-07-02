//
//  UIImage+MLImageCrop_Addition.h
//  HLImageCrop
//
//  Created by hoolang on 15/6/26.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefualRatioOfWidthAndHeight 1.0f

@interface UIImage (HLImageCrop_Addition)

//将根据所定frame来截取图片
- (UIImage*)HLImageCrop_imageByCropForRect:(CGRect)targetRect;
- (UIImage *)HLImageCrop_fixOrientation;
@end
