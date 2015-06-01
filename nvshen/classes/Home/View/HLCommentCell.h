//
//  HLCommentCell.h
//  nvshen
//
//  Created by hoolang on 15/5/31.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HLCommentsFrame.h"
@interface HLCommentCell : UITableViewCell
/** 评论整体 */
@property (nonatomic, weak) UIView *originalView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) HLCommentsFrame *commentsFrame;
@end
