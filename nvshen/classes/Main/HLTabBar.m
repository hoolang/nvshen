//
//  HLTabBar.m
//  nvshen
//
//  Created by hoolang on 15/5/10.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLTabBar.h"
#import "HLProfileViewController.h"
#import "UIView+MGBadgeView.h"
@interface HLTabBar()
@property(nonatomic, weak) UIButton *plusBtn;
@end


@implementation HLTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加一个按钮到tabbar中
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
//        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
//        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        plusBtn.size = plusBtn.currentBackgroundImage.size;
        
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        //CGFloat height = plusBtn.size.height;
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }

    return self;
}

/**
 *加好按钮点击事件
*/
- (void)plusClick
{
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegate tabBarDidClickPlusButton:self];
    }
}

- (void)layoutSubviews
{
#warning [super layoutSubviews] 一定要调用
    [super layoutSubviews];
    HLLog(@"layoutSubviews-====");
    // 1.设置加号按钮的位置
    self.plusBtn.centerX = self.width * 0.5;
    self.plusBtn.centerY = self.height * 0.5;
    
    // 2.设置其他tabbarButton的位置和尺寸
    CGFloat tabbarButtonW = self.width / 5;
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {

        HLLog(@"child ===== %@", child);
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置宽度
            child.width = tabbarButtonW;
            // 设置x
            child.x = tabbarButtonIndex * tabbarButtonW;
            
            child.tag = tabbarButtonIndex;
            
            // 增加索引
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex++;
            }

        }
    }
}
#pragma mark 设置bagde显示
- (void)setupChatBadge
{
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            HLLog(@"child ===== %@", child);
            // 增加索引
            tabbarButtonIndex++;

            if (tabbarButtonIndex == 3) {
                [child.badgeView setBadgeValue:11];
                [child.badgeView setOutlineWidth:0.0];
                [child.badgeView setPosition:MGBadgePositionTopRight];
                [child.badgeView setBadgeColor:[UIColor orangeColor]];
                [child.badgeView setTextColor:[UIColor whiteColor]];
            }
        }
    }
}

 
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
