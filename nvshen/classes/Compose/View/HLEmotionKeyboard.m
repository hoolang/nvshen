//
//  HWEmotionKeyboard.m
//  黑马微博2期
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HLEmotionKeyboard.h"
#import "HLEmotionListView.h"
#import "HLEmotionTabBar.h"
#import "HLEmotion.h"
#import "MJExtension.h"
#import "HLEmotionTool.h"

@interface HLEmotionKeyboard() <HLEmotionTabBarDelegate>
/** 保存正在显示listView */
@property (nonatomic, weak) HLEmotionListView *showingListView;
/** 表情内容 */
@property (nonatomic, strong) HLEmotionListView *recentListView;
//@property (nonatomic, strong) HLEmotionListView *defaultListView;
@property (nonatomic, strong) HLEmotionListView *emojiListView;
//@property (nonatomic, strong) HLEmotionListView *lxhListView;
/** tabbar */
@property (nonatomic, weak) HLEmotionTabBar *tabBar;
@end

@implementation HLEmotionKeyboard

#pragma mark - 懒加载
- (HLEmotionListView *)recentListView
{
    if (!_recentListView) {
        self.recentListView = [[HLEmotionListView alloc] init];
        // 加载沙盒中的数据
        self.recentListView.emotions = [HLEmotionTool recentEmotions];
    }
    return _recentListView;
}

//- (HLEmotionListView *)defaultListView
//{
//    if (!_defaultListView) {
//        self.defaultListView = [[HLEmotionListView alloc] init];
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
//        self.defaultListView.emotions = [HLEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
//    }
//    return _defaultListView;
//}

- (HLEmotionListView *)emojiListView
{
    if (!_emojiListView) {
        self.emojiListView = [[HLEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        self.emojiListView.emotions = [HLEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _emojiListView;
}

//- (HLEmotionListView *)lxhListView
//{
//    if (!_lxhListView) {
//        self.lxhListView = [[HLEmotionListView alloc] init];
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
//        self.lxhListView.emotions = [HLEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
//    }
//    return _lxhListView;
//}

#pragma mark - 初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // tabbar
        HLEmotionTabBar *tabBar = [[HLEmotionTabBar alloc] init];
        tabBar.delegate = self;
        [self addSubview:tabBar];
        self.tabBar = tabBar;
        
        // 表情选中的通知
        [HLNotificationCenter addObserver:self selector:@selector(emotionDidSelect) name:HLEmotionDidSelectNotification object:nil];
    }
    return self;
}

- (void)emotionDidSelect
{
    self.recentListView.emotions = [HLEmotionTool recentEmotions];
}

- (void)dealloc
{
    [HLNotificationCenter removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.tabbar
    self.tabBar.width = self.width;
    self.tabBar.height = 37;
    self.tabBar.x = 0;
    self.tabBar.y = self.height - self.tabBar.height;
    
    // 2.表情内容
    self.showingListView.x = self.showingListView.y = 0;
    self.showingListView.width = self.width;
    self.showingListView.height = self.tabBar.y;
}

#pragma mark - HLEmotionTabBarDelegate
- (void)emotionTabBar:(HLEmotionTabBar *)tabBar didSelectButton:(HLEmotionTabBarButtonType)buttonType
{
    // 移除正在显示的listView控件
    [self.showingListView removeFromSuperview];
    
    // 根据按钮类型，切换键盘上面的listview
    switch (buttonType) {
        case HLEmotionTabBarButtonTypeRecent: { // 最近
            // 加载沙盒中的数据
//            self.recentListView.emotions = [HWEmotionTool recentEmotions];
            [self addSubview:self.recentListView];
            break;
        }
            
        case HLEmotionTabBarButtonTypeDefault: { // 默认
            //[self addSubview:self.defaultListView];
            break;
        }
            
        case HLEmotionTabBarButtonTypeEmoji: { // Emoji
            [self addSubview:self.emojiListView];
            break;
        }
            
        case HLEmotionTabBarButtonTypeLxh: { // Lxh
            //[self addSubview:self.lxhListView];
            break;
        }
    }
    
    // 设置正在显示的listView
    self.showingListView = [self.subviews lastObject];
    
    // 设置frame
    [self setNeedsLayout];
}

@end
