//
//  HLEmotionTabBar.h
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 Hoolang All rights reserved.
//  表情键盘底部的选项卡

#import <UIKit/UIKit.h>

typedef enum {
    HLEmotionTabBarButtonTypeRecent, // 最近
    HLEmotionTabBarButtonTypeDefault, // 默认
    HLEmotionTabBarButtonTypeEmoji, // emoji
    HLEmotionTabBarButtonTypeLxh, // 浪小花
} HLEmotionTabBarButtonType;

@class HLEmotionTabBar;

@protocol HLEmotionTabBarDelegate <NSObject>

@optional
- (void)emotionTabBar:(HLEmotionTabBar *)tabBar didSelectButton:(HLEmotionTabBarButtonType)buttonType;
@end

@interface HLEmotionTabBar : UIView
@property (nonatomic, weak) id<HLEmotionTabBarDelegate> delegate;
@end
