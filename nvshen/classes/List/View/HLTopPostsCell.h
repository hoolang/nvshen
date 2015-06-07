//
//  HLTopPostsCell.h
//  nvshen
//
//  Created by hoolang on 15/6/4.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HLTopPostsFrame;
@interface HLTopPostsCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** 评论整体 */
@property (nonatomic, weak) UIView *originalView;

@property (nonatomic, strong) HLTopPostsFrame *topPostsFrame;

@property (nonatomic,strong) NSArray *topPostsArray;
@end
