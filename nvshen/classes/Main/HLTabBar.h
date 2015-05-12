//
//  HLTabBar.h
//  nvshen
//
//  Created by hoolang on 15/5/10.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HLTabBar;

#warning 因为HLTabBar继承自UITabBar，所以称为HLTabBar的代理，也必须实现UITabBar的代理协议
@protocol HLTabBarDelegate <UITabBarDelegate>
@optional
- (void)tabBarDidClickPlusButton:(HLTabBar *)tabBar;
@end

@interface HLTabBar : UITabBar
@property (nonatomic, weak) id<HLTabBarDelegate> delegate;
@end
