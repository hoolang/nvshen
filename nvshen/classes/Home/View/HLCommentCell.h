//
//  HLCommentCell.h
//  nvshen
//
//  Created by hoolang on 15/5/31.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLCommonCell.h"
#import "HLCommentsFrame.h"
@interface HLCommentCell : HLCommonCell
/** 原创微博整体 */
@property (nonatomic, weak) UIView *originalView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setupOriginal;

@property (nonatomic, strong) HLCommentsFrame *commentsFrame;
@end
