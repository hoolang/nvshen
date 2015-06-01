//
//  HLEmotionPopView.m
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HLEmotionPopView.h"
#import "HLEmotion.h"
#import "HLEmotionButton.h"

@interface HLEmotionPopView()
@property (weak, nonatomic) IBOutlet HLEmotionButton *emotionButton;
@end

@implementation HLEmotionPopView

+ (instancetype)popView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HLEmotionPopView" owner:nil options:nil] lastObject];
}

- (void)showFrom:(HLEmotionButton *)button
{
    if (button == nil) return;
    
    // 给popView传递数据
    self.emotionButton.emotion = button.emotion;
    
    // 取得最上面的window
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    // 计算出被点击的按钮在window中的frame
    CGRect btnFrame = [button convertRect:button.bounds toView:nil];
    self.y = CGRectGetMidY(btnFrame) - self.height; // 100
    self.centerX = CGRectGetMidX(btnFrame);
}

@end
