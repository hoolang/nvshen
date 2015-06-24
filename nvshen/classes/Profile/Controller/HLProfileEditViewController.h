//
//  HLProfileEditViewController.h
//  nvshen
//
//  Created by hoolang on 15/6/24.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLProfileEditViewController : UIViewController
@property (weak, nonatomic) UIImageView *icon;      //头像
@property (weak, nonatomic) UILabel *nicknameLabel; //昵称
@property (weak, nonatomic) UILabel *sexLabel;      //性别
@property (weak, nonatomic) UILabel *local;         //地区
@property (weak, nonatomic) UITextView *text;
@end
