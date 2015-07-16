//
//  ILPushNoticeController.m
//  ItheimaLottery
//
//  Created by apple on 14-9-10.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import "HLPushNoticeController.h"

#import "HLSettingCell.h"

#import "HLSettingItem.h"

#import "HLSettingArrowItem.h"
#import "HLSettingSwitchItem.h"

#import "HLSettingGroup.h"

#import "HLScoreNoticeViewController.h"

@interface HLPushNoticeController ()

@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation HLPushNoticeController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 0组
    [self addGroup0];
    
}

- (void)addGroup0
{
    
    // 0组
    HLSettingArrowItem *push = [HLSettingArrowItem itemWithIcon:nil title:@"接收好友信息提醒" destVcClass:nil];
    
    
    HLSettingItem *anim = [HLSettingArrowItem itemWithIcon:nil title:@"中奖动画"];
    
    HLSettingItem *score = [HLSettingArrowItem itemWithIcon:nil title:@"比分直播" destVcClass:[HLScoreNoticeViewController class]];
    HLSettingItem *timer = [HLSettingArrowItem itemWithIcon:nil title:@"购彩定时提醒"];
    
    HLSettingGroup *group0 = [[HLSettingGroup alloc] init];
    group0.items = @[push,anim,score,timer];
    
    [self.dataList addObject:group0];

}

@end
