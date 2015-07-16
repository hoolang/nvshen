//
//  ILSettingCell.h
//  ItheimaLottery
//
//  Created by apple on 14-9-10.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HLSettingItem;

@interface HLSettingCell : UITableViewCell

@property (nonatomic, strong) HLSettingItem *item;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
