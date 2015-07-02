//
//  ViewController.h
//  HLImageCrop
//
//  Created by hoolang on 15/6/26.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HLImageCropDelegate <NSObject>
@optional
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage;
- (void)cropImageFromCamera:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage;

@end

@interface HLImageCrop : UIViewController<UIScrollViewDelegate>

//下面俩哪个后面设置，即是哪个有效
@property(nonatomic,strong) UIImage *image;
@property (nonatomic, assign) BOOL isCamera;
@property(nonatomic,weak) id<HLImageCropDelegate> delegate;
@property(nonatomic,assign) CGFloat ratioOfWidthAndHeight; //截取比例，宽高比


@end

