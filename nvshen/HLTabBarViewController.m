//
//  HLTabBarViewController.m
//  nvshen
//
//  Created by hoolang on 15/5/9.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLTabBarViewController.h"
#import "HLHomeViewController.h"
#import "HLNavigationController.h"
#import "HLListViewController.h"
#import "HLProfileViewController.h"
#import "HLDiscoverViewController.h"
#import "HLTabBar.h"
#import "HLComposeViewController.h"
#import "DoImagePickerController.h"

@interface HLTabBarViewController ()<HLTabBarDelegate>

@end

@implementation HLTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.初始化子控制器
    HLHomeViewController *home = [[HLHomeViewController alloc] init];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    HLListViewController *list = [[HLListViewController alloc] init];
    [self addChildVc:list title:@"排行榜" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    
    HLDiscoverViewController *discover = [[HLDiscoverViewController alloc] init];
    [self addChildVc:discover title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    
    HLProfileViewController *profile = [[HLProfileViewController alloc] init];
    [self addChildVc:profile title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    // 2.更换系统自带的tabbar
    HLTabBar *tabBar = [[HLTabBar alloc] init];
    tabBar.delegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    //    childVc.tabBarItem.title = title; // 设置tabbar的文字
    //    childVc.navigationItem.title = title; // 设置navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = HLColor(123, 123, 123);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    childVc.view.backgroundColor = HLRandomColor;
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    HLNavigationController *nav = [[HLNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}

#pragma mark - HLTabBarDelegate 代理方法
- (void)tabBarDidClickPlusButton:(HLTabBar *)tabBar{
    
    //HLComposeViewController *compose = [[HLComposeViewController alloc] init];
    

    
    DoImagePickerController *ipc = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    ipc.delegate = self;
    ipc.nResultType = DO_PICKER_RESULT_UIIMAGE;
    ipc.nMaxCount = 1;
    //    if (_sgMaxCount.selectedSegmentIndex == 0)
    //        cont.nMaxCount = 1;
    //    else if (_sgMaxCount.selectedSegmentIndex == 1)
    //        cont.nMaxCount = 4;
    //    else if (_sgMaxCount.selectedSegmentIndex == 2)
    //    {
    //        cont.nMaxCount = DO_NO_LIMIT_SELECT;
    //        cont.nResultType = DO_PICKER_RESULT_ASSET;  // if you want to get lots photos, you'd better use this mode for memory!!!
    //    }
    
    //cont.nColumnCount = _sgColumnCount.selectedSegmentIndex + 2;
    ipc.nColumnCount = 3;
    
    HLNavigationController *nav = [[HLNavigationController alloc] initWithRootViewController:ipc];
    
    
    nav.navigationBar.hidden = YES;

    
    [self presentViewController:nav animated:YES completion:nil];
    
    
    

//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
//    
//    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
//    ipc.sourceType = type;
//    ipc.delegate = self;
//    [self presentViewController:ipc animated:YES completion:nil];
    
}
@end
