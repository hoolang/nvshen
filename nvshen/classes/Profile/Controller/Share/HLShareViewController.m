//
//  ILShareViewController.m
//  ItheimaLottery
//
//  Created by apple on 14-9-12.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HLShareViewController.h"

#import "HLSettingItem.h"

#import "HLSettingArrowItem.h"
#import "HLSettingGroup.h"

@interface HLShareViewController ()

@end

@implementation HLShareViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    // 0组
    [self addGroup0];
    
}

- (void)addGroup0
{
    // 0组
    HLSettingArrowItem *sina = [HLSettingArrowItem itemWithIcon:@"WeiboSina" title:@"新浪分享" ];
    
    
    HLSettingItem *sms = [HLSettingArrowItem itemWithIcon:@"SmsShare" title:@"短信分享"];
    
    HLSettingItem *mail = [HLSettingArrowItem itemWithIcon:@"MailShare" title:@"邮件分享"];
    
    
    HLSettingGroup *group0 = [[HLSettingGroup alloc] init];
    
    group0.items = @[sina,sms,mail];
    
    [self.dataList addObject:group0];
}


@end
