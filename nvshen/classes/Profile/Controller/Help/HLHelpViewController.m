//
//  ILHelpViewController.m
//  ItheimaLottery
//
//  Created by apple on 14-9-12.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HLHelpViewController.h"


#import "HLSettingCell.h"

#import "HLSettingItem.h"

#import "HLSettingArrowItem.h"
#import "HLSettingSwitchItem.h"

#import "HLSettingGroup.h"

#import "HLHtml.h"

#import "HLHtmlViewController.h"

//#import "HLNavigationController.h"

@interface HLHelpViewController ()
@property (nonatomic, strong) NSMutableArray *htmls;
@end

@implementation HLHelpViewController

- (NSMutableArray *)htmls
{
    if (_htmls == nil) {
        _htmls = [NSMutableArray array];
        
        
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"help.json" ofType:nil];
        NSData *data =  [NSData dataWithContentsOfFile:fileName];
        
        NSArray *jsonArr =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *dict in jsonArr) {
            HLHtml *html = [HLHtml htmlWithDict:dict];
            [_htmls addObject:html];
        }
    }
    return _htmls;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 0组
    [self addGroup0];
    
}

- (void)addGroup0
{

    // 0组
    NSMutableArray *items = [NSMutableArray array];
    for (HLHtml *html in self.htmls) {
        HLSettingArrowItem *item = [HLSettingArrowItem itemWithIcon:nil title:html.title destVcClass:nil];
        [items addObject:item];
    }
  
    
    HLSettingGroup *group0 = [[HLSettingGroup alloc] init];
    group0.items = items;
    
    [self.dataList addObject:group0];
    
}


// 重写tableView的点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出每一行对应的Html模型
    HLHtml *html = self.htmls[indexPath.row];
    
    HLHtmlViewController *htmlVc = [[HLHtmlViewController alloc] init];
    htmlVc.title = html.title;
    htmlVc.html = html;
    
    //ILNavigationController *nav = [[ILNavigationController alloc] initWithRootViewController:htmlVc];
    UINavigationController *nav =  [[UINavigationController alloc] initWithRootViewController:htmlVc];
    
    [self presentViewController:nav animated:YES completion:nil];
}

@end
