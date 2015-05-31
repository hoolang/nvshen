//
//  HLStatusCellTableViewCell.h
//  nvshen
//
//  Created by hoolang on 15/5/28.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HLStatusFrame;
@interface HLCommonCell : UITableViewCell
/** 原创微博整体 */
@property (nonatomic, weak) UIView *originalView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setupOriginal;

- (UIView *)returnOriginalView;

@property (nonatomic, strong) HLStatusFrame *statusFrame;
@end
