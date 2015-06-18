//
//  HLRegisgerViewController.m
//
//  Created by apple on 14/12/8.
//  Copyright (c) 2014年 HOOLANG. All rights reserved.
//

#import "HLRegisgerViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "HLHttpTool.h"
#import "HLUser.h"
#import "HLMD5.h"
#import "HLRegisgerIconViewController.h"

@interface HLRegisgerViewController()
<
UITextFieldDelegate
>

@property (weak, nonatomic) UITextField *userField;
@property (weak, nonatomic) UITextField *pwdField;
@property (weak, nonatomic) UITextField *rePwdField;
@property (weak, nonatomic) UIButton *registerBtn;


@end

@implementation HLRegisgerViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = HLColor(239, 239, 239);
    self.title = @"（1/2）创建账号资料";

    /** 用户名*/
    UITextField *userField = [[UITextField alloc] init];
    CGFloat borderW = 30;
    CGFloat height = 34;
    userField.frame = CGRectMake(borderW, 100, ScreenWidth - borderW * 2, height);
    userField.backgroundColor = [UIColor whiteColor];
    userField.placeholder = @"（*）请输入用户名";
    userField.font = [UIFont systemFontOfSize:12];
    self.userField = userField;
    [userField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:userField];
    
    /** 密码 */
    UITextField *pwdField = [[UITextField alloc] init];
    pwdField.frame = CGRectMake(borderW, CGRectGetMaxY(userField.frame) + borderW, ScreenWidth - borderW * 2, height);
    pwdField.backgroundColor = [UIColor whiteColor];
    pwdField.placeholder = @"（*）请输入密码";
    pwdField.font = [UIFont systemFontOfSize:12];
    self.pwdField = pwdField;
    [pwdField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:pwdField];
    
    /** 重复密码*/
    UITextField *rePwdField = [[UITextField alloc] init];
    rePwdField.frame = CGRectMake(borderW, CGRectGetMaxY(pwdField.frame) + borderW, ScreenWidth - borderW * 2, height);
    rePwdField.backgroundColor = [UIColor whiteColor];
    rePwdField.placeholder = @"（*）请再次输入密码";
    rePwdField.font = [UIFont systemFontOfSize:12];
    
    self.rePwdField = rePwdField;
    [rePwdField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    self.rePwdField.delegate = self;
    [self.view addSubview:rePwdField];
    
    /** 下一步按钮 */
    UIButton *registerBtn = [[UIButton alloc] init];
    CGFloat btnW = 60;
    registerBtn.frame = CGRectMake((ScreenWidth - btnW) * 0.5, CGRectGetMaxY(rePwdField.frame) + borderW, btnW, height);
    [registerBtn setTitle:@"下一步" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    registerBtn.enabled = NO;
    self.registerBtn = registerBtn;
    [self.view addSubview:registerBtn];
    
}
/** 是否可以下一步 */
- (void)textFieldDidChange{
    HLLog(@"self.userField:%@,self.pwdField.text:%@, self.rePwdField.hasText: %@",self.userField.text, self.pwdField.text, self.rePwdField.text);
    if (self.userField.hasText && self.pwdField.hasText && self.rePwdField.hasText) {
        self.registerBtn.enabled = YES;
        [self.registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        self.registerBtn.enabled = NO;
        [self.registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (void)registerBtnClick {

    [self.view endEditing:YES];
    
    if (!self.userField.hasText)
    {
        [MBProgressHUD showError:@"请输入用户名" toView:self.view];
        return;
    }
    if (![self.pwdField.text isEqualToString:self.rePwdField.text]) {
        [MBProgressHUD showError:@"两次密码不一致，请重新输入" toView:self.view];
        return;
    }else{
        HLRegisgerIconViewController *registerIcon = [[HLRegisgerIconViewController alloc] init];
        registerIcon.username = self.userField.text;
        registerIcon.password = [HLMD5 md5:self.pwdField.text];
        [self.navigationController pushViewController:registerIcon animated:YES];
    }
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //设置响应内容类型
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"user.name"] = [self.userField.text lowercaseString];
    params[@"user.password"] = [HLMD5 md5:self.pwdField.text];
    
    // 3.发送请求
    [mgr POST:HL_ADD_USER parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 拼接文件数据
        //        UIImage *image = _image;
        //        //
        //        NSData *data = UIImageJPEGRepresentation(image, 0.6);
        //        [formData appendPartWithFileData:data name:@"file" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [MBProgressHUD showSuccess:@"注册成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络异常，请稍后再试！"];
    }];
    
    // 1.把用户注册的数据保存单例
//    HLUserInfo *userInfo = [HLUserInfo sharedHLUserInfo];
//    userInfo.registerUser = @"oooooooo";
//    userInfo.registerPwd = @"123456";
    

    
    // 2.调用WCXMPPTool的xmppUserRegister

//    [HLXMPPTool sharedHLXMPPTool].registerOperation = YES;
//    
//    // 提示
//    
//    [MBProgressHUD showMessage:@"正在注册中....." toView:self.view];
//    
//    __weak typeof(self) selfVc = self;
//    [[HLXMPPTool sharedHLXMPPTool] xmppUserRegister:^(XMPPResultType type) {
//        
//        [selfVc handleResultType:type];
//    }];
    
}

/**
 *  处理注册的结果
 */
-(void)handleResultType:(XMPPResultType)type{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        switch (type) {
            case XMPPResultTypeNetErr:
                [MBProgressHUD showError:@"网络不稳定" toView:self.view];
                break;
            case XMPPResultTypeRegisterSuccess:
                [MBProgressHUD showError:@"注册成功" toView:self.view];
                // 回到上个控制器
                [self dismissViewControllerAnimated:YES completion:nil];
                
                if ([self.delegate respondsToSelector:@selector(regisgerViewControllerDidFinishRegister)]) {
                    [self.delegate regisgerViewControllerDidFinishRegister];
                }
                break;
                
            case XMPPResultTypeRegisterFailure:
                [MBProgressHUD showError:@"注册失败,用户名重复" toView:self.view];
                break;
            default:
                break;
        }
    });
    
    
}

/** 即将开始编辑 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 + 150);
    
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    
    return YES;
}

/** 即将结束编辑 */
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{

        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = 0;
            self.view.frame = frame;
        }];
    
    return YES;
}

/** 取消编辑 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)textChange {
    
    HLLog(@"xxx");
    // 设置注册按钮的可能状态
    BOOL enabled = (self.userField.text.length != 0 && self.pwdField.text.length != 0);
    self.registerBtn.enabled = enabled;
}


@end
