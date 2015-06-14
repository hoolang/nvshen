//
//  HLBaseLoginViewController.m
//
//  Created by apple on 14/12/8.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import "HLBaseLoginViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD+MJ.h"
#import "HLTabBarViewController.h"

@implementation HLBaseLoginViewController


- (void)login{
    // 登录
    
    /*
     * 官方的登录实现
     
     * 1.把用户名和密码放在WCUserInfo的单例
     
     
     * 2.调用 AppDelegate的一个login 连接服务并登录
     */
    
    //隐藏键盘
    [self.view endEditing:YES];
    
    // 登录之前给个提示
    
    [MBProgressHUD showMessage:@"正在登录中..." toView:self.view];
    
    [HLXMPPTool sharedHLXMPPTool].registerOperation = NO;
    __weak typeof(self) selfVc = self;
    
    [[HLXMPPTool sharedHLXMPPTool] xmppUserLogin:^(XMPPResultType type) {
        [selfVc handleResultType:type];
    }];
}


-(void)handleResultType:(XMPPResultType)type{
    // 主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view
         ];
        switch (type) {
            case XMPPResultTypeLoginSuccess:
                NSLog(@"登录成功");
                [self enterMainPage];
                break;
            case XMPPResultTypeLoginFailure:
                NSLog(@"登录失败");
                [MBProgressHUD showError:@"用户名或者密码不正确" toView:self.view];
                break;
            case XMPPResultTypeNetErr:
                [MBProgressHUD showError:@"网络不给力" toView:self.view];
            default:
                break;
        }
    });
    
}


-(void)enterMainPage{
    
    // 更改用户的登录状态为YES
    [HLUserInfo sharedHLUserInfo].loginStatus = YES;
    
    // 把用户登录成功的数据，保存到沙盒
    [[HLUserInfo sharedHLUserInfo] saveUserInfoToSanbox];
    
    // 隐藏模态窗口
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // 登录成功来到主界面
    // 此方法是在子线程补调用，所以在主线程刷新UI
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    UIWindow *window = self.view.window;
//    window.rootViewController = storyboard.instantiateInitialViewController;
    [UIStoryboard showInitialVCWithName:@"Main"];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[HLTabBarViewController alloc] init];
}

@end
