//
//  HLOtherLoginViewController.m
//
//  Created by apple on 14/12/8.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import "HLOtherLoginViewController.h"
#import "AppDelegate.h"

@interface HLOtherLoginViewController()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation HLOtherLoginViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"其它方式登录";
    
    // 判断当前设备的类型 改变左右两边约束的距离
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        self.leftConstraint.constant = 10;
        self.rightConstraint.constant = 10;
    }
    
    // 设置TextFeild的背景
    self.userField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
    
    
}



-(void)dealloc{
    HLLog(@"%s",__func__);
}
@end
