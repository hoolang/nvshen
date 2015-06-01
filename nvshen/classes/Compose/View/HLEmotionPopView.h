//
//  HWEmotionPopView.h
//  黑马微博2期
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HLEmotion, HLEmotionButton;

@interface HLEmotionPopView : UIView
+ (instancetype)popView;

- (void)showFrom:(HLEmotionButton *)button;
@end
