//
//  HLEditNickNameViewController.m
//  nvshen
//
//  Created by hoolang on 15/6/25.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLEditNickNameViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"

@interface HLEditNickNameViewController ()
@property (nonatomic, weak) UITextField *nicknameField;
@end

@implementation HLEditNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HLColor(239, 239, 239);
    self.title = @"修改昵称";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    
    UITextField *nickname = [[UITextField alloc] init];
    nickname.frame = CGRectMake(10, 74, ScreenWidth - 20, 44);
    nickname.backgroundColor = [UIColor whiteColor];
    nickname.textColor = [UIColor blackColor];
    nickname.text = self.nickname;
    self.nicknameField = nickname;
    
    [self.view addSubview:nickname];
    
}

/*完成编辑*/
- (void)done
{
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //设置响应内容类型
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user.uid"] = self.uid;
    params[@"user.username"] = [HLUserInfo sharedHLUserInfo].user;
    params[@"user.nickname"] = [[self.nicknameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];

    [MBProgressHUD showMessage:@"正在保存..."];
    // 3.发送请求
    [mgr POST:HL_UPDATE_USER parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 通知代理
        if ([self.delegate respondsToSelector:@selector(reloadNickname:)]) {
             [self.delegate reloadNickname:self.nicknameField.text];
        }
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"昵称已修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络异常，请稍后再试！"];
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    HLLog(@"%s", __func__);
    [HLNotificationCenter removeObserver:self];
}
@end
