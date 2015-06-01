//
//  HLCommentsFrame.h
//  nvshen
//
//  Created by hoolang on 15/6/1.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HLComments;
// 昵称字体
#define HLCommentCellNameFont [UIFont systemFontOfSize:12]
// 时间字体
#define HLCommentCellTimeFont [UIFont systemFontOfSize:11]
// 来源字体
#define HLCommentCellSourceFont HLStatusCellTimeFont
// 正文字体
#define HLCommentCellContentFont [UIFont systemFontOfSize:12]

#define HLCommentCellContentColor [UIColor grayColor]
// cell之间的间距
#define HLCommentCellMargin 1
#define HLCommentCellBorderW 10
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
