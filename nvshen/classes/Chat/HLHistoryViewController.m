//
//  HLHistoryViewController.m
//
//  Created by apple on 14/12/11.
//  Copyright (c) 2014年 hoolang. All rights reserved.
//

#import "HLHistoryViewController.h"

@interface HLHistoryViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation HLHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 监听一个登录状态的通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xxx:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChange:) name:HLLoginStatusChangeNotification object:nil];
}

-(void)loginStatusChange:(NSNotification *)noti{
    
    //通知是在子线程被调用，刷新UI在主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        HLLog(@"%@",noti.userInfo);
        // 获取登录状态
        int status = [noti.userInfo[@"loginStatus"] intValue];
        
        switch (status) {
            case XMPPResultTypeConnecting://正在连接
                [self.indicatorView startAnimating];
                break;
            case XMPPResultTypeNetErr://连接失败
                [self.indicatorView stopAnimating];
                break;
            case XMPPResultTypeLoginSuccess://登录成功也就是连接成功
                [self.indicatorView stopAnimating];
                break;
            case XMPPResultTypeLoginFailure://登录失败
                [self.indicatorView stopAnimating];
                break;
            default:
                break;
        }
    });
    
}


@end
