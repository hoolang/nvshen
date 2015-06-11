//
//  HLTopPostsCategoryFrame.h
//  nvshen
//
//  Created by hoolang on 15/6/8.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLStatus.h"
#import "HLTopPostsCategoryFrame.h"

// 昵称字体
#define HLTopPostsCategoryNameFont [UIFont systemFontOfSize:12]
// 时间字体
#define HLTopPostsCategoryTimeFont [UIFont systemFontOfSize:11]
// 来源字体
#define HLTopPostsCategorySourceFont HLStatusCellTimeFont
// 正文字体
#define HLTopPostsCategoryContentFont [UIFont systemFontOfSize:12]

#define HLTopPostsCategoryContentColor [UIColor grayColor]
// cell之间的间距
#define HLTopPostsCategoryMargin 1
#define HLTopPostsCategoryBorderW 5

@interface HLTopPostsCategoryFrame : UIViewController
@property (nonatomic, strong) HLStatus *topPosts;

/** Show整体 */
@property (nonatomic, assign) CGRect originalViewF;
/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 会员图标 */
@property (nonatomic, assign) CGRect vipViewF;
/** 配图 */
@property (nonatomic, assign) CGRect photosViewF;
/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 点赞按钮 */
@property (nonatomic, assign) CGRect likeLabelF;
/** 点赞统计 */
@property (nonatomic, assign) CGRect likeCountLabelF;
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
