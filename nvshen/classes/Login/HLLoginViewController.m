//
//  HLLoginViewController.m
//
//  Created by apple on 14/12/8.
//  Copyright (c) 2014年 hoolang. All rights reserved.
//

#import "HLLoginViewController.h"
#import "HLRegisgerViewController.h"
#import "HLNavigationController.h"
#import "MBProgressHUD+MJ.h"

@interface HLLoginViewController()<HLRegisgerViewControllerDelegate>
@property (strong, nonatomic) UILabel *userLabel;
@property (weak, nonatomic) UILabel *pwdLabel;

@property (weak, nonatomic) UITextField *userField;
@property (weak, nonatomic) UITextField *pwdField;
@property (weak, nonatomic) UIButton *loginBtn;

@end

@implementation HLLoginViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:HLColor(239, 239, 239)];

    CGFloat x = 50;
    CGFloat y = 50;
    CGFloat w = ScreenWidth - 2 * x;
    CGFloat h = 30;
    
    /** 用户名 */
    UITextField *userField = [[UITextField alloc] init];
    userField.placeholder = @"（*）请输入用户名";
    userField.frame = CGRectMake(x, y, w, h);
    userField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:userField];
    self.userField =  userField;
    
    /** 密码*/
    UITextField *pwdField = [[UITextField alloc] init];
    pwdField.backgroundColor = [UIColor whiteColor];
    pwdField.secureTextEntry = YES;
    pwdField.frame = CGRectMake(x, CGRectGetMaxY(userField.frame) + h, w, h);
    pwdField.placeholder = @" (*)请输入密码";
    self.pwdField = pwdField;
    [self.view addSubview:pwdField];
    
    /** 登录按钮 */
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CGFloat width = 60;
    CGFloat loginX = (ScreenWidth - 60) * 0.5;
    loginBtn.frame = CGRectMake(loginX, CGRectGetMaxY(pwdField.frame), width, h);
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn = loginBtn;
    [self.view addSubview:loginBtn];

    
    
    // 设置TextField和Btn的样式
//    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
//    
//  
//    [self.pwdField addLeftViewWithImage:@"Card_Lock"];
//    
//    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
//    
//    
//    // 设置用户名为上次登录的用户名
//    
//    //从沙盒获取用户名
//    NSString *user = [HLUserInfo sharedHLUserInfo].user;
//    self.userLabel.text = user;
}


- (void)loginBtnClick:(id)sender {
    
    // 保存数据到单例
    
    HLUserInfo *userInfo = [HLUserInfo sharedHLUserInfo];
    userInfo.user = self.userField.text;
    userInfo.pwd = self.pwdField.text;
    
    // 调用父类的登录
    [super login];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // 获取注册控制器
    id destVc = segue.destinationViewController;
    
    
    if ([destVc isKindOfClass:[HLNavigationController class]]) {
        HLNavigationController *nav = destVc;
        //获取根控制器
        
        if ([nav.topViewController isKindOfClass:[HLRegisgerViewController class]]) {
            HLRegisgerViewController *registerVc =  (HLRegisgerViewController *)nav.topViewController;
            // 设置注册控制器的代理
            registerVc.delegate = self;
        }
        
    }
    
}

#pragma mark regisgerViewController的代理
-(void)regisgerViewControllerDidFinishRegister{
    HLLog(@"完成注册");
    // 完成注册 userLabel显示注册的用户名
    self.userLabel.text = [HLUserInfo sharedHLUserInfo].registerUser;
    
    // 提示
    [MBProgressHUD showSuccess:@"请重新输入密码进行登录" toView:self.view];
    
    
}

@end
