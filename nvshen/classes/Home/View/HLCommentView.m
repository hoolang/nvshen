//
//  HLCommentView.m
//  nvshen
//
//  Created by hoolang on 15/5/31.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLCommentView.h"
#import "HLCommentToolbar.h"
#import "HLStatus.h"
#import "HLPosts.h"
#import "HLUser.h"
#import "HLStatusFrame.h"
#import "HLPhoto.h"
#import "UIImageView+WebCache.h"

#import "HLStatusPhotosView.h"
#import "HLIconView.h"
#import "HLPhoto.h"

@interface HLCommentView()
/* 原创微博 */

/** 头像 */
@property (nonatomic, weak) HLIconView *iconView;
/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/** 配图 */
@property (nonatomic, weak) HLStatusPhotosView *photosView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文 */
@property (nonatomic, weak) UILabel *contentLabel;

@property (nonatomic, weak) UIButton *btn;

@property (nonatomic, weak) UITextView *textView;

/* 转发微博 */
/** 转发微博整体 */
@property (nonatomic, weak) UIView *retweetView;
/** 转发微博正文 + 昵称 */
@property (nonatomic, weak) UILabel *retweetContentLabel;


/** 工具条 */
@property (nonatomic, weak) HLCommentToolbar *toolbar;

@end
@implementation HLCommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupOriginal];
        [self setupToolbar];
    }
    return self;
}
- (void)setupOriginal{
    /** 原创微博整体 */
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor whiteColor];

    [originalView setUserInteractionEnabled:YES];
    [self addSubview:originalView];
    
    self.originalView = originalView;
    
    /** 头像 */
    HLIconView *iconView = [[HLIconView alloc] init];
    [originalView addSubview:iconView];
    self.iconView = iconView;
    
    /** 会员图标 */
    UIImageView *vipView = [[UIImageView alloc] init];
    vipView.contentMode = UIViewContentModeCenter;
    [originalView addSubview:vipView];
    self.vipView = vipView;
    
    /** 配图 */
    HLStatusPhotosView *photosView = [[HLStatusPhotosView alloc] init];
    [originalView addSubview:photosView];
    self.photosView = photosView;
    
    /** 昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = HLStatusCellNameFont;
    [originalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = HLStatusCellTimeFont;
    timeLabel.textColor = [UIColor orangeColor];
    [originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 正文 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = HLStatusCellContentFont;
    contentLabel.textColor = HLStatusCellContentColor;
    contentLabel.numberOfLines = 0;
    [originalView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    HLLog(@"%@", self.contentLabel.text);
}

- (void)onClick{
    HLLog(@"btn click");
}
- (void)setStatusFrame:(HLStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    HLLog(@"setStatusFrame =》》》》》%@",statusFrame);
    
    /** show的整体 */
    self.originalView.frame = statusFrame.originalViewF;
    
    /** 头像 */
    self.iconView.frame = statusFrame.iconViewF;
    self.iconView.user = statusFrame.status.posts.user;
    //HLLog(@"statusFrame.status.posts.user %@",statusFrame.status.posts.user.icon);
    
    /** 会员图标 */
    //    if (user.isVip) {
    //        self.vipView.hidden = NO;
    //
    //        self.vipView.frame = statusFrame.vipViewF;
    //        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank];
    //        self.vipView.image = [UIImage imageNamed:vipName];
    //
    //        self.nameLabel.textColor = [UIColor orangeColor];
    //    } else {
    //        self.nameLabel.textColor = [UIColor blackColor];
    //        self.vipView.hidden = YES;
    //    }
    
    /** 配图 */
    self.photosView.frame = statusFrame.photosViewF;
    
    
    HLPhoto *poto = [[HLPhoto alloc] init];
    poto.thumbnail_pic = statusFrame.status.posts.photo;
    HLLog(@"poto.thumbnail_pic >>> %@",poto.thumbnail_pic);
    NSArray *arr = [[NSArray alloc]initWithObjects:poto, nil];
    
    self.photosView.photos = arr;
    
    self.photosView.hidden = NO;
    //    if (status.pic_urls.count) {
    //        self.photosView.frame = statusFrame.photosViewF;
    //        self.photosView.photos = status.pic_urls;
    //        self.photosView.hidden = NO;
    //    } else {
    //        self.photosView.hidden = YES;
    //    }
    
    /** 昵称 */
    self.nameLabel.text = statusFrame.status.posts.user.nickname;
    HLLog(@"statusFrame.status.posts.user >>> %@",statusFrame.status.posts.user.icon);
    self.nameLabel.frame = statusFrame.nameLabelF;
    
    /** 时间 */
    NSString *time = statusFrame.status.posts.created_at;
    HLLog(@"status.created_at >>>>%@", statusFrame.status.posts.created_at);
    CGFloat timeX = statusFrame.nameLabelF.origin.x;
    CGFloat timeY = CGRectGetMaxY(statusFrame.nameLabelF) + HLStatusCellBorderW * 0.5;
    CGSize timeSize = [time sizeWithFont:HLStatusCellTimeFont];
    self.timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    self.timeLabel.textColor = HLStatusCellContentColor;
    self.timeLabel.text = time;
    
    
    /** 正文 */
    self.contentLabel.text = statusFrame.status.posts.content;
    self.contentLabel.frame = statusFrame.contentLabelF;
    HLLog(@"self.contentLabel.text>>>> %@", statusFrame.status.posts.content);
    
    /** 工具条 */
    self.toolbar.frame = statusFrame.toolbarF;
    self.toolbar.status = statusFrame.status;
    HLLog(@"self.toolbar >>>>>>%@",self.toolbar);

}

- (void)setupToolbar
{
    HLCommentToolbar *toolbar = [HLCommentToolbar toolbar];
    HLLog(@"setupToolbar-=====");
    [self addSubview:toolbar];
    self.toolbar = toolbar;
}

@end
