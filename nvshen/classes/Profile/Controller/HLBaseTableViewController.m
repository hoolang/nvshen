//
//  ILBaseTableViewController.m
//  ItheimaLottery
//
//  Created by apple on 14-9-10.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HLBaseTableViewController.h"

#import "HLSettingCell.h"

#import "HLSettingItem.h"

#import "HLSettingArrowItem.h"
#import "HLSettingSwitchItem.h"

#import "HLSettingGroup.h"

@interface HLBaseTableViewController ()

@end

@implementation HLBaseTableViewController

- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}


// 初始化方法
- (id)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 244 243 241
    
    
    // ios6 backgroundView > backgroundColor
    //self.tableView.backgroundView = nil;
    //self.tableView.backgroundColor = ILColor(244, 243, 241);
    
    
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    HLSettingGroup *group = self.dataList[section];
    return group.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 创建cell
    HLSettingCell *cell = [[HLSettingCell class] cellWithTableView:tableView];
    
    // 取出模型
    HLSettingGroup *group = self.dataList[indexPath.section];
    HLSettingItem *item = group.items[indexPath.row];
    
    
    // 传递模型
    cell.item = item;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    HLSettingGroup *group = self.dataList[section];
    return group.header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    HLSettingGroup *group = self.dataList[section];
    return group.footer;
}
#warning 点击某一行cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 取出模型
    HLSettingGroup *group = self.dataList[indexPath.section];
    HLSettingItem *item = group.items[indexPath.row];
    
    // 执行操作
    if (item.option) {
        item.option();
        return;
    }
    
    if ([item isKindOfClass:[HLSettingArrowItem class]]) { // 需要跳转控制器
        HLSettingArrowItem *arrowItem = (HLSettingArrowItem *)item;
        
        
        // 创建跳转的控制器
        if (arrowItem.destVcClass) {
            
            UIViewController *vc = [[arrowItem.destVcClass alloc] init];
            vc.title = item.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
    }
    
}


@end
