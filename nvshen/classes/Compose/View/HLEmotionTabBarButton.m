//
//  HLEmotionTabBarButton.m
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import "HLEmotionTabBarButton.h"

@implementation HLEmotionTabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        // 设置字体
        self.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    // 按钮高亮所做的一切操作都不在了
}
@end
