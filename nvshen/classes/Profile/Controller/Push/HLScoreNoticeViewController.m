//
//  ILScoreNoticeViewController.m
//  ItheimaLottery
//
//  Created by apple on 14-9-10.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import "HLScoreNoticeViewController.h"

#import "HLSettingSwitchItem.h"
#import "HLSettingGroup.h"
#import "HLSettingLabelItem.h"

#import "HLSaveTool.h"

@interface HLScoreNoticeViewController ()

@property (nonatomic, strong) HLSettingLabelItem *start;

@end

@implementation HLScoreNoticeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 0组
    [self addGroup0];
    // 1组
    [self addGroup1];
    // 2组
    [self addGroup2];
    
}

- (void)addGroup0
{
    HLSettingSwitchItem *notice = [HLSettingSwitchItem itemWithIcon:nil title:@"提醒我关注比赛"];
    
    HLSettingGroup *group = [[HLSettingGroup alloc] init];
    group.items = @[notice];
    //group.footer = @"asdsad";
    [self.dataList addObject:group];
}

- (void)addGroup1
{
    HLSettingLabelItem *start = [HLSettingLabelItem itemWithIcon:nil title:@"开始时间"];
    _start = start;
    
    if (!start.text.length) {
        start.text = @"00:00";
    }
    
    start.option = ^{
        UITextField *textField = [[UITextField alloc] init];
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        // 设置模式
        datePicker.datePickerMode = UIDatePickerModeTime;
        
        // 设置地区
        datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        
        // 创建日期格式对象
        NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
        dateF.dateFormat = @"HH:mm";
        // 设置日期
        datePicker.date = [dateF dateFromString:@"00:00"];
        
        // 监听UIDatePicker
        [datePicker addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        
        // 设置键盘
        textField.inputView = datePicker;
        
        [textField becomeFirstResponder];
        [self.view addSubview:textField];

    
    };
    HLSettingGroup *group = [[HLSettingGroup alloc] init];
    group.items = @[start];
    group.header = @"213214234324";
    [self.dataList addObject:group];
}


- (void)valueChange:(UIDatePicker *)datePicker
{
    // 创建日期格式对象
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    dateF.dateFormat = @"HH:mm";
    _start.text = [dateF stringFromDate:datePicker.date];
    
    [self.tableView reloadData];
}
- (void)addGroup2
{
    HLSettingLabelItem *stop = [HLSettingLabelItem itemWithIcon:nil title:@"结束时间"];
    stop.text = @"00:00";
    HLSettingGroup *group = [[HLSettingGroup alloc] init];
    group.items = @[stop];
   
    [self.dataList addObject:group];
}
@end
