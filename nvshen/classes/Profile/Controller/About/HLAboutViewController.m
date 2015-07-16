//
//  ILAboutViewController.m
//
//  Created by apple on 14-9-12.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import "HLAboutViewController.h"

#import "HLSettingItem.h"

#import "HLSettingArrowItem.h"
#import "HLSettingGroup.h"

#import "HLAboutHeaderView.h"

@interface HLAboutViewController ()

@end

@implementation HLAboutViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 0组
    [self addGroup0];
    
    self.tableView.tableHeaderView = [HLAboutHeaderView headerView];
    
}

- (void)addGroup0
{
    // 0组
    HLSettingArrowItem *score = [HLSettingArrowItem itemWithIcon:nil title:@"评分支持" destVcClass:nil];
    
    
    HLSettingItem *tel = [HLSettingArrowItem itemWithIcon:nil title:@"客服电话"];
    tel.subTitle = @"15818587820";
    
    HLSettingGroup *group0 = [[HLSettingGroup alloc] init];
    group0.items = @[score,tel];
    
    [self.dataList addObject:group0];
}


@end
