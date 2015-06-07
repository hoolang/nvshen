//
//  HLTopPostsFrame.h
//  nvshen
//
//  Created by hoolang on 15/6/4.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <Foundation/Foundation.h>

// cell之间的间距
#define HLTopPostsCellMargin 5
#define HLTopPostsCellBorderW 10
@class HLTopPosts;
@interface HLTopPostsFrame : NSObject
@property (nonatomic, strong) HLTopPosts *topPosts;
/** Show整体 */
@property (nonatomic, assign) CGRect originalViewF;
/** 第一个图片占位符 */
@property (nonatomic, assign) CGRect firstViewF;
/** scrollView */
@property (nonatomic, assign) CGRect lastViewF;
/** 底部 */
@property (nonatomic, assign) CGRect bottomViewF;
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) NSArray *topPostsM;
@end