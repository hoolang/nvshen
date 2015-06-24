//
//  HLLoginViewController.m
//
//  Created by apple on 14/12/8.
//  Copyright (c) 2014年 hoolang. All rights reserved.
//

#import "HLLoginViewController.h"
#import "HLRegisgerViewController.h"
#import "MBProgressHUD+MJ.h"
#import "HLNavigationController.h"
#import "HLMD5.h"

@interface HLLoginViewController()<HLRegisgerViewControllerDelegate>
@property (strong, nonatomic) UILabel *userLabel;
@property (weak, nonatomic) UILabel *pwdLabel;

@property (weak, nonatomic) UITextField *userField;
@property (weak, nonatomic) UITextField *pwdField;
@property (weak, nonatomic) UIButton *loginBtn;
@property (weak, nonatomic) UIButton *registerBtn;
@end

@implementation HLLoginViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.view setBackgroundColor:HLColor(239, 239, 239)];

    CGFloat x = 10;
    CGFloat y = 50;
    CGFloat w = ScreenWidth - 2 * x;
    CGFloat h = 30;
    
    /** 用户名 */
    UITextField *userField = [[UITextField alloc] init];
    userField.placeholder = @"（*）请输入用户名";
    userField.frame = CGRectMake(x, y, w, h);
    userField.backgroundColor = [UIColor whiteColor];
    userField.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:userField];
    [userField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    self.userField =  userField;
    
    /** 密码*/
    UITextField *pwdField = [[UITextField alloc] init];
    pwdField.backgroundColor = [UIColor whiteColor];
    pwdField.secureTextEntry = YES;
    pwdField.frame = CGRectMake(x, CGRectGetMaxY(userField.frame) + x, w, h);
    pwdField.placeholder = @"（*）请输入密码";
    pwdField.font = [UIFont systemFontOfSize:12];
    
    self.pwdField = pwdField;
    [pwdField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:pwdField];
    
    /** 登录按钮 */
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    loginBtn.enabled = NO;
    
    CGFloat width = 60;
    CGFloat loginX = HLHorizontalCenter(width + 10);
    CGFloat loginY = CGRectGetMaxY(pwdField.frame) + 10;
    loginBtn.frame = CGRectMake(loginX, loginY, width, h);
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.loginBtn = loginBtn;
    [self.view addSubview:loginBtn];
    
    /** 注册按钮 */
    UIButton *registerBtn = [[UIButton alloc] init];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:12];


    registerBtn.frame = CGRectMake(CGRectGetMaxX(pwdField.frame) - width, loginY, width, h);
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.registerBtn = registerBtn;
    [self.view addSubview:registerBtn];


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

/** 是否可以登录 */
- (void)textFieldDidChange{
    if (self.userField.hasText && self.pwdField.hasText) {
        self.loginBtn.enabled = YES;
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.loginBtn setBackgroundColor:[UIColor orangeColor]];
    }else{
        self.loginBtn.enabled = NO;
        [self.loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.loginBtn setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)loginBtnClick:(id)sender {
    
    // 保存数据到单例
    HLUserInfo *userInfo = [HLUserInfo sharedHLUserInfo];
    // 删除字符串两边的空格 然后转为小写
    userInfo.user = [[self.userField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    HLLog(@"userInfo.user %@", userInfo.user );
    userInfo.pwd = self.pwdField.text;
    
    // 调用父类的登录
    [super login];
    
}

- (void)registerBtnClick{
    HLRegisgerViewController *registerVC = [[HLRegisgerViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}



#pragma mark regisgerViewController的代理
-(void)regisgerViewControllerDidFinishRegister{
    HLLog(@"完成注册");
    // 完成注册 userLabel显示注册的用户名
    self.userLabel.text = [HLUserInfo sharedHLUserInfo].registerUser;
    
    // 提示
    [MBProgressHUD showSuccess:@"请重新输入密码进行登录" toView:self.view];
    
}

-(void)dealloc
{
    HLLog(@"login view deallo");
    [HLNotificationCenter removeObserver:self];
}
@end
