//
//  HLEmotionPageView.m
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HLEmotionPageView.h"
#import "HLEmotion.h"
#import "HLEmotionPopView.h"
#import "HLEmotionButton.h"
#import "HLEmotionTool.h"

@interface HLEmotionPageView()
/** 点击表情后弹出的放大镜 */
@property (nonatomic, strong) HLEmotionPopView *popView;
/** 删除按钮 */
@property (nonatomic, weak) UIButton *deleteButton;
@end

@implementation HLEmotionPageView

- (HLEmotionPopView *)popView
{
    if (!_popView) {
        self.popView = [HLEmotionPopView popView];
    }
    return _popView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.删除按钮
        UIButton *deleteButton = [[UIButton alloc] init];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        self.deleteButton = deleteButton;
        
        // 2.添加长按手势
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPageView:)]];
    }
    return self;
}

/**
 *  根据手指位置所在的表情按钮
 */
- (HLEmotionButton *)emotionButtonWithLocation:(CGPoint)location
{
    NSUInteger count = self.emotions.count;
    for (int i = 0; i<count; i++) {
        HLEmotionButton *btn = self.subviews[i + 1];
        if (CGRectContainsPoint(btn.frame, location)) {
            
            // 已经找到手指所在的表情按钮了，就没必要再往下遍历
            return btn;
        }
    }
    return nil;
}

/**
 *  在这个方法中处理长按手势
 */
- (void)longPressPageView:(UILongPressGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:recognizer.view];
    // 获得手指所在的位置\所在的表情按钮
    HLEmotionButton *btn = [self emotionButtonWithLocation:location];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: // 手指已经不再触摸pageView
            // 移除popView
            [self.popView removeFromSuperview];
            
            // 如果手指还在表情按钮上
            if (btn) {
                // 发出通知
                [self selectEmotion:btn.emotion];
            }
            break;
            
        case UIGestureRecognizerStateBegan: // 手势开始（刚检测到长按）
        case UIGestureRecognizerStateChanged: { // 手势改变（手指的位置改变）
            [self.popView showFrom:btn];
            break;
        }
            
        default:
            break;
    }
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    NSUInteger count = emotions.count;
    for (int i = 0; i<count; i++) {
        HLEmotionButton *btn = [[HLEmotionButton alloc] init];
        [self addSubview:btn];
        
        // 设置表情数据
        btn.emotion = emotions[i];
        
        // 监听按钮点击
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

// CUICatalog: Invalid asset name supplied: (null), or invalid scale factor: 2.000000
// 警告原因：尝试去加载的图片不存在

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 内边距(四周)
    CGFloat inset = 20;
    NSUInteger count = self.emotions.count;
    CGFloat btnW = (self.width - 2 * inset) / HLEmotionMaxCols;
    CGFloat btnH = (self.height - inset) / HLEmotionMaxRows;
    for (int i = 0; i<count; i++) {
        UIButton *btn = self.subviews[i + 1];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = inset + (i%HLEmotionMaxCols) * btnW;
        btn.y = inset + (i/HLEmotionMaxCols) * btnH;
    }
    
    // 删除按钮
    self.deleteButton.width = btnW;
    self.deleteButton.height = btnH;
    self.deleteButton.y = self.height - btnH;
    self.deleteButton.x = self.width - inset - btnW;
}

/**
 *  监听删除按钮点击
 */
- (void)deleteClick
{
    [HLNotificationCenter postNotificationName:HLEmotionDidDeleteNotification object:nil];
}

/**
 *  监听表情按钮点击
 *
 *  @param btn 被点击的表情按钮
 */
- (void)btnClick:(HLEmotionButton *)btn
{
    // 显示popView
    [self.popView showFrom:btn];
    
    // 等会让popView自动消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    
    // 发出通知
    [self selectEmotion:btn.emotion];
}

/**
 *  选中某个表情，发出通知
 *
 *  @param emotion 被选中的表情
 */
- (void)selectEmotion:(HLEmotion *)emotion
{
    // 将这个表情存进沙盒
    [HLEmotionTool addRecentEmotion:emotion];
    
    // 发出通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[HLSelectEmotionKey] = emotion;
    [HLNotificationCenter postNotificationName:HLEmotionDidSelectNotification object:nil userInfo:userInfo];
}
@end
