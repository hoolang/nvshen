//
//  AppDelegate.m
//  nvshen
//
//  Created by hoolang on 15/5/8.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"
#import "HLTabBarViewController.h"
#import "HLNavigationController.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "HLLoginViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    // 从沙里加载用户的数据到单例
    [[HLUserInfo sharedHLUserInfo] loadUserInfoFromSanbox];
    
    // 判断用户的登录状态，YES 直接来到主界面
    if([HLUserInfo sharedHLUserInfo].loginStatus){
//        UIStoryboard *storayobard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        self.window.rootViewController = storayobard.instantiateInitialViewController;
        
        // 2.设置根控制器
        self.window.rootViewController = [[HLTabBarViewController alloc] init];

        
        // 自动登录服务
        // 1秒后再自动登录
#warning 一般情况下，都不会马上连接，会稍微等等
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[HLXMPPTool sharedHLXMPPTool] xmppUserLogin:nil];
        });
        
    }else{
        HLLoginViewController *login = [[HLLoginViewController alloc] init];
        HLNavigationController *nav = [[HLNavigationController alloc] initWithRootViewController:login];
        self.window.rootViewController = nav;
        
    }
    
    //注册应用接收通知
    if ([[UIDevice currentDevice].systemVersion doubleValue] > 8.0){
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }

    
    // 4.显示窗口
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
