//
//  HLTopPhotosView.h
//  nvshen
//
//  Created by hoolang on 15/6/4.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HLStatus;

@protocol UIScrollViewTouchesDelegate
-(void)scrollViewTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event whichView:(id)scrollView;
@end

@interface HLTopPhotosView : UIScrollView
@property (nonatomic, strong) NSArray *photos;

/**
 *  根据图片个数计算相册的尺寸
 */
+ (CGSize)sizeWithCount:(NSUInteger)count;


@property(nonatomic,assign) id<UIScrollViewTouchesDelegate> touchesdelegate;
@end