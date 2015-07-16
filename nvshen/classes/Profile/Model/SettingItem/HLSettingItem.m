//
//  ILSettingItem.m
//  ItheimaLottery
//
//  Created by apple on 14-9-10.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import "HLSettingItem.h"

@implementation HLSettingItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title
{
    HLSettingItem *item = [[self alloc] init];
    
    item.icon = icon;
    item.title = title;
    
    return item;
}

@end
