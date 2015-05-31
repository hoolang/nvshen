//
//  HLCommentsFrame.h
//  nvshen
//
//  Created by hoolang on 15/6/1.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLComments.h"
// 昵称字体
#define HLStatusCellNameFont [UIFont systemFontOfSize:15]
// 时间字体
#define HLStatusCellTimeFont [UIFont systemFontOfSize:12]
// 来源字体
#define HLStatusCellSourceFont HLStatusCellTimeFont
// 正文字体
#define HLStatusCellContentFont [UIFont systemFontOfSize:14]

// cell之间的间距
#define HLStatusCellMargin 15
#define HLStatusCellBorderW 10
@interface HLCommentsFrame : NSObject
@property (nonatomic, strong) HLComments *comments;

/** Show整体 */
@property (nonatomic, assign) CGRect originalViewF;
/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 会员图标 */
@property (nonatomic, assign) CGRect vipViewF;
/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;

/** 正文 */
@property (nonatomic, assign) CGRect contentLabelF;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
@end
