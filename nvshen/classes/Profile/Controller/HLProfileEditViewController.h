//
//  HLProfileEditViewController.h
//  nvshen
//
//  Created by hoolang on 15/6/24.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLProfileEditViewController : UIViewController
@property (strong, nonatomic) UIImage *avatar;      //头像
@property (strong, nonatomic) UILabel *avatarLabel; //头像Label
@property (strong, nonatomic) UILabel *nicknameLabel; //昵称
@property (strong, nonatomic) UILabel *sexLabel;      //性别
@property (strong, nonatomic) UILabel *localLabel;         //地区
@property (strong, nonatomic) UILabel *text;
@property (nonatomic, copy) NSString *uid;
@end
