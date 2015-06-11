//
//  HLStatusToolbar.m
//  nvshen
//
//  Created by hoolang on 15/5/28.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLStatusToolbar.h"
#import "HLStatus.h"
#import "HLPosts.h"
#import "HLUser.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
@interface HLStatusToolbar()
/** 里面存放所有的按钮 */
@property (nonatomic, strong) NSMutableArray *btns;
/** 里面存放所有的分割线 */
@property (nonatomic, strong) NSMutableArray *dividers;

@property (nonatomic, weak) UIButton *chatBtn;
@property (nonatomic, weak) UIButton *commentBtn;
@property (nonatomic, weak) UIButton *attitudeBtn;
@end

@implementation HLStatusToolbar

- (NSMutableArray *)btns
{
    if (!_btns) {
        self.btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSMutableArray *)dividers
{
    if (!_dividers) {
        self.dividers = [NSMutableArray array];
    }
    return _dividers;
}

+ (instancetype)toolbar
{
    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
        
        // 添加按钮
        self.chatBtn = [self setupBtn:@"转发" icon:@"timeline_icon_retweet" action:@selector(chat)];

        self.commentBtn = [self setupBtn:@"评论" icon:@"timeline_icon_comment" action:@selector(clickCommentBtn)];

        self.attitudeBtn = [self setupBtn:@"赞" icon:@"timeline_icon_unlike" action:@selector(addLike:)];
        
        // 添加分割线
        [self setupDivider];
        [self setupDivider];
    }
    return self;
}
/**
 聊天
 */
- (void) chat{
    HLLog(@"chat %@",_status.posts.pid);
    
}
/**
 点击评论按钮
 */
- (void) clickCommentBtn{
    //NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_status.posts.pid, @"pid", nil];
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_status, @"status", nil];
    
    NSNotification *notification =[NSNotification notificationWithName:@"clickCommentBtnNotification" object:nil userInfo:dict];
    //通过通知中心发送通知
    [HLNotificationCenter postNotification:notification];
}
/**
 点击喜欢
 */
- (void)addLike:(UIButton *) btn{
    HLLog(@"btn.titlelabe.text: %@",btn.titleLabel.text);
    HLLog(@"addLike^66666");

    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"post.pid"] = _status.posts.pid;
    params[@"user.uid"] = _status.posts.user.uid;
    
    
    [mgr POST:HL_ADD_LIKE parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 拼接文件数据
        //UIImage *image = _image;
        //NSData *data = UIImageJPEGRepresentation(image, 0.7);
        //[formData appendPartWithFileData:data name:@"file" fileName:@"test.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_status.posts.pid, @"pid",responseObject, @"response", nil];
        
        NSNotification *notification =[NSNotification notificationWithName:@"addLikeNotification" object:nil userInfo:dict];
        //通过通知中心发送通知
        [HLNotificationCenter postNotification:notification];
        
        //[MBProgressHUD showSuccess:@"谢谢点赞"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络不稳定，请稍微再试"];
    }];

}
/**
 * 添加分割线
 */
- (void)setupDivider
{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    [self addSubview:divider];
    
    [self.dividers addObject:divider];
}

/**
 * 初始化一个按钮
 * @param title : 按钮文字
 * @param icon : 按钮图标
 */
- (UIButton *)setupBtn:(NSString *)title icon:(NSString *)icon action:(SEL) action
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:btn];
    
    [self.btns addObject:btn];
    
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    NSUInteger btnCount = self.btns.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = self.btns[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
    
    // 设置分割线的frame
    NSUInteger dividerCount = self.dividers.count;
    for (int i = 0; i<dividerCount; i++) {
        UIImageView *divider = self.dividers[i];
        divider.width = 1;
        divider.height = btnH;
        divider.x = (i + 1) * btnW;
        divider.y = 0;
    }
}

- (void)setStatus:(HLStatus *)status
{
    _status = status;
    //    status.reposts_count = 580456; // 58.7万
    //    status.comments_count = 100004; // 1万
    //    status.attitudes_count = 604; // 604
    
    // 转发
    [self setupBtnCount:0 btn:self.chatBtn title:@"私聊"];
    // 评论
    [self setupBtnCount:status.comments_count btn:self.commentBtn title:@"评论"];
    // 赞
    [self setupBtnCount:status.likes_count btn:self.attitudeBtn title:@"赞"];
}

- (void)setupBtnCount:(int)count btn:(UIButton *)btn title:(NSString *)title
{
    if (count) { // 数字不为0
        if (count < 10000) { // 不足10000：直接显示数字，比如786、7986
            title = [NSString stringWithFormat:@"%d", count];
        } else { // 达到10000：显示xx.x万，不要有.0的情况
            double wan = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万", wan];
            // 将字符串里面的.0去掉
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
    }
    [btn setTitle:title forState:UIControlStateNormal];
    //强转long 可能以后会出错
    //HLLog(@"强转long 可能以后会出错");
    //[btn setTag:(NSInteger)_status.posts.pid];
}


@end
