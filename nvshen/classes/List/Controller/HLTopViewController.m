//
//  HLListControllerTableViewController.m
//  nvshen
//
//  Created by hoolang on 15/5/9.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLTopViewController.h"

@interface HLTopViewController ()

@end

@implementation HLTopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // style : 这个参数是用来设置背景的，在iOS7之前效果比较明显, iOS7中没有任何效果
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"写私信" style:UIBarButtonItemStylePlain target:self action:@selector(composeMsg)];
    // 这个item不能点击(目前放在viewWillAppear就能显示disable下的主题)
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    //HLLog(@"HLListViewController-viewDidLoad");
}

- (void)composeMsg{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
