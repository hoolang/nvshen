//
//  HLTopPostsDetailCell.h
//  04-瀑布流
//
//  Created by apple on 14/12/4.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HLTopPosts;
@class HLTopPostsCategoryFrame;
@interface HLTopPostsCategoryCell : UICollectionViewCell
@property (nonatomic, strong) HLTopPosts *topPosts;

/** 整体 */
@property (nonatomic, weak) UIView *originalView;

@property (nonatomic, strong) HLTopPostsCategoryFrame *topPostsCategoryFrame;

- (void)setupOriginal;
@end