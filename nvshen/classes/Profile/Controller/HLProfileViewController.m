//
//  HLProfileViewController.m
//  nvshen
//
//  Created by hoolang on 15/5/10.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLProfileViewController.h"
#import "HLSettingTableViewController.h"
#import "XMPPvCardTemp.h"
#import "HLHttpTool.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "HLProfile.h"
#import "HLUser.h"
#import "NSString+Extension.h"
#import "HLProfileEditViewController.h"

@interface HLProfileViewController ()

@end
@interface HLProfileViewController()
@property (weak, nonatomic) UIImageView *icon;      //头像
@property (weak, nonatomic) UILabel *nicknameLabel; //昵称
@property (weak, nonatomic) UILabel *sexLabel;      //性别
@property (weak, nonatomic) UILabel *local;         //地区
@property (weak, nonatomic) UILabel *countLikes;        //地区
@property (weak, nonatomic) UIButton *editPrifleBtn;    //编辑个人资料按钮
@property (weak, nonatomic) UILabel *text;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *nickname;

/** 标记是否已经加载数据 */
@property (nonatomic, assign) BOOL didLoad;

@end

@implementation HLProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HLLog(@"%s", __func__);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 如果此用户名为空，则表示查看自己的个人资料，可以显示导航栏的按钮
    if (_username == nil) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
        
        // style : 这个参数是用来设置背景的，在iOS7之前效果比较明显, iOS7中没有任何效果
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    // 判断是否已经加载数据
    if (!self.didLoad) {
        // 还没有加载就调用此方法
        [self loadUserInfo];
    }
    
}

/** 加载个人信息 */
- (void)loadUserInfo
{
    // 1.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 自己的用户名
    params[@"user.username"] = [HLUserInfo sharedHLUserInfo].user;
    
    if (_username != nil) {
        // 要查看的用户名
        params[@"user.username"] = _username;
    }
    
    // 2.发送请求
    [HLHttpTool get:HL_ONE_USER_URL params:params success:^(id json) {
        
        self.didLoad = YES;
        
        // 将 "字典"数组 转为 "模型"数组
        NSArray *userInfo = [HLProfile objectArrayWithKeyValuesArray:json[@"userinfo"]];
        
        HLProfile *profile = userInfo[0];
        
        HLUser *user = profile.user;
        
        // 设置uid和nickname传值
        self.uid = user.uid;
        self.nickname = user.nickname;
        
        // 设置标题
        self.navigationItem.title = user.nickname;

        // 头像
        CGFloat x = 10;
        CGFloat y = 74;
        CGFloat width = 64;
        CGFloat border = 10;
        UIImageView *icon = [[UIImageView alloc] init];

        NSString *url = [NSString stringWithFormat:@"%@%@", USER_ICON_URL,user.icon];
        [icon sd_setImageWithURL:[NSURL URLWithString: url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"] options:SDWebImageRefreshCached];
        
        HLLog(@"url:%@", url);
        
        icon.frame = CGRectMake(x, y, width, width);
        self.icon = icon;
        [self.view addSubview:icon];
        
        // 性别
        UILabel *sex = [[UILabel alloc] init];
        sex.text = user.sex;
        sex.frame = CGRectMake(CGRectGetMaxX(icon.frame) + border, y, 20, 20);
        sex.font = [UIFont systemFontOfSize:12];
        self.sexLabel = sex;
        [self.view addSubview:sex];
        
        // 地区
        UILabel *local = [[UILabel alloc] init];
        local.text = [NSString stringWithFormat:@" , %@-%@",user.province,user.city];
        local.frame = CGRectMake(sex.frame.origin.x + border, y, 200, 20);
        local.font = [UIFont systemFontOfSize:12];
        self.local = local;
        [self.view addSubview:local];
        
        // 被赞的次数
        UILabel *countLikes = [[UILabel alloc] init];
        countLikes.text = [NSString stringWithFormat:@"被赞了%@%@", profile.like_count, @"次"];
        countLikes.frame = CGRectMake(CGRectGetMaxX(icon.frame) + border, CGRectGetMaxY(sex.frame), 100, 20);
        [countLikes setFont:[UIFont systemFontOfSize:12]];
        self.countLikes = countLikes;
        [self.view addSubview:countLikes];
        
        // 编辑个人资料
        UIButton *editPrifleBtn = [[UIButton alloc] init];
        [editPrifleBtn setTitle:@"编辑个人资料" forState:UIControlStateNormal];
        [editPrifleBtn setBackgroundColor:HLColor(239, 239, 239)];
        editPrifleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [editPrifleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        CGFloat editPrifleBtnH = 20;
        CGFloat editPrifleBtnY = y + width - editPrifleBtnH;
        editPrifleBtn.frame = CGRectMake(CGRectGetMaxX(icon.frame) + border, editPrifleBtnY, 130, editPrifleBtnH);
        [editPrifleBtn addTarget:self action:@selector(editProfile) forControlEvents:UIControlEventTouchUpInside];
        self.editPrifleBtn = editPrifleBtn;
        
        /**
         *  如果传过来的用户名为空，则为查看自己的个人信息，需要添加编辑按钮
         */
        if (_username == nil) {
            [self.view addSubview:editPrifleBtn];
        }

        // 个人说明
        UILabel *text = [[UILabel alloc] init];
        text.text = user.text;
        text.font = [UIFont systemFontOfSize:12];
        text.textColor = [UIColor grayColor];
        CGSize size =  [text.text sizeWithFont:[UIFont systemFontOfSize:12]];
        text.frame = CGRectMake(border, CGRectGetMaxY(icon.frame), ScreenWidth - 2 * border, size.height);
        [text setNumberOfLines:0];
        self.text = text;
        
        [self.view addSubview:text];

    } failure:^(NSError *error) {
        HLLog(@"请求失败-%@", error);
    }];
}

/**
 跳转到编辑个人信息界面
 */
- (void)editProfile
{
    /**
     @property (weak, nonatomic) UIImageView *icon;      //头像
     @property (weak, nonatomic) UILabel *nicknameLabel; //昵称
     @property (weak, nonatomic) UILabel *sexLabel;      //性别
     @property (weak, nonatomic) UILabel *local;         //地区
     @property (weak, nonatomic) UILabel *countLikes;        //地区
     @property (weak, nonatomic) UIButton *editPrifleBtn;    //编辑个人资料按钮
     */
    HLProfileEditViewController *editProfile = [[HLProfileEditViewController alloc] init];
//    editProfile.avatar = self.icon.image;
//    editProfile.nickname = self.nickname;
//    editProfile.sex = self.sexLabel.text;
//    editProfile.local = self.local.text;
//    editProfile.text = self.text.text;
//    editProfile.uid = self.uid;
//    HLLog(@"self.uid: %@", self.uid);
    [self.navigationController pushViewController:editProfile animated:YES];
}

/**
 注销
 */
- (void) logout{
    [[HLXMPPTool sharedHLXMPPTool] xmppUserlogout];
}

/**
 设置
 */
- (void) setting{
    // 创建设置口控制器
    HLSettingTableViewController *settingVc = [[HLSettingTableViewController alloc] init];
    
    // 跳转到设置界面
    [self.navigationController pushViewController:settingVc animated:YES];
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
