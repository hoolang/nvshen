//
//  HLProfileEditTextViewController.m
//  nvshen
//
//  Created by hoolang on 15/6/25.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLProfileEditTextViewController.h"
#import "HLEmotionTextView.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
@interface HLProfileEditTextViewController ()<UITextViewDelegate>
@property (nonatomic, weak) HLEmotionTextView *textView;
@property (nonatomic, weak) UILabel *tempLabel;

@end

@implementation HLProfileEditTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HLColor(239, 239, 239);
    self.title = @"修改简介";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    
    /** 测试的label */
    UILabel *tempLabel = [[UILabel alloc] init];
    //tempLabel.frame = CGRectMake(10, 73, ScreenWidth , 1);
    [self.view addSubview:tempLabel];
    
    HLEmotionTextView *textView = [[HLEmotionTextView alloc] init];
    textView.font = [UIFont systemFontOfSize:12];
    textView.frame = CGRectMake(10, 74, ScreenWidth - 20, 120);
    textView.backgroundColor = [UIColor whiteColor];
    textView.textColor = [UIColor blackColor];
    // 垂直方向上可拖拽
    textView.alwaysBounceVertical = YES;
    textView.text = self.text;
    textView.delegate = self;
    textView.placeholder = @"填写简介";
    [textView becomeFirstResponder];
    self.textView = textView;
    
    
    [self.view addSubview:textView];

}

- (void)done
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //设置响应内容类型
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user.uid"] = self.uid;
    params[@"user.username"] = [HLUserInfo sharedHLUserInfo].user;
    params[@"user.text"] = [[self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    
    [MBProgressHUD showMessage:@"正在保存..."];
    // 3.发送请求
    [mgr POST:HL_UPDATE_TEXT_USER parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 通知代理
        if ([self.delegate respondsToSelector:@selector(reloadText:)]) {
            [self.delegate reloadText:self.textView.text];
        }
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"简介已修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络异常，请稍后再试！"];
        [MBProgressHUD hideHUD];
    }];
}
#pragma mark - UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    HLLog(@"%s", __func__);
}

@end
