//
//  HLEmotionPageView.h
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//  用来表示一页的表情（里面显示1~20个表情）

#import <UIKit/UIKit.h>

// 一页中最多3行
#define HLEmotionMaxRows 3
// 一行中最多7列
#define HLEmotionMaxCols 7
// 每一页的表情个数
#define HLEmotionPageSize ((HLEmotionMaxRows * HLEmotionMaxCols) - 1)

@interface HLEmotionPageView : UIView
/** 这一页显示的表情（里面都是HWEmotion模型） */
@property (nonatomic, strong) NSArray *emotions;
@end
