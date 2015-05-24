//
//  AppDelegate.m
//  nvshen
//
//  Created by hoolang on 15/5/8.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "AppDelegate.h"
#import "HLTabBarViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置友盟社会化组件appkey
    //[UMSocialData setAppKey:UmengAppkey];
    //[UMSocialQQHandler setQQWithAppId:@"1104653034" appKey:@"H6WMgzXsRf5k7zig" url:@"http://www.umeng.com/social"];
    
    //打开调试log的开关
    //[UMSocialData openLog:YES];
    
    // 1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    // 2.设置根控制器
    self.window.rootViewController = [[HLTabBarViewController alloc] init];

    
    // 4.显示窗口
    [self.window makeKeyAndVisible];
    return YES;
}

///**
// 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
// */
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
//}
//
///**
// 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
// */
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    [UMSocialSnsService  applicationDidBecomeActive];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
