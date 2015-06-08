//
//  HLShopCell.m
//  04-瀑布流
//
//  Created by apple on 14/12/4.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import "HLTopPostsCategoryCell.h"
#import "HLUser.h"
#import "HLPosts.h"
#import "HLPhoto.h"
#import "HLIconView.h"
#import "HLTopPosts.h"
#import "HLStatusPhotosView.h"
#import "UIImageView+WebCache.h"
#import "HLTopPostsCategoryFrame.h"


@interface HLTopPostsCategoryCell()
/** 头像 */
@property (nonatomic, weak) HLIconView *iconView;
/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/** 配图 */
@property (nonatomic, weak) UIImageView *photosView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 点赞 */
@property (nonatomic, weak) UIButton *likeButton;
/** 点赞统计数 */
@property (nonatomic, weak) UILabel *likeCountLabel;

@end

@implementation HLTopPostsCategoryCell

- (void)setupOriginal
{
    /** 原创整体 */
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    
    /** 头像 */
    HLIconView *iconView = [[HLIconView alloc] init];
    [originalView addSubview:iconView];
    self.iconView = iconView;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = HLTopPostsCategoryTimeFont;
    timeLabel.textColor = [UIColor grayColor];
    [originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 会员图标 */
    UIImageView *vipView = [[UIImageView alloc] init];
    vipView.contentMode = UIViewContentModeCenter;
    [originalView addSubview:vipView];
    self.vipView = vipView;
    
    
    /** 配图 */
    UIImageView *photosView = [[UIImageView alloc] init];
    [originalView addSubview:photosView];
    self.photosView = photosView;
    
    /** 昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = HLTopPostsCategoryNameFont;
    [originalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 点赞 */
    UIButton *likeButton = [[UIButton alloc] init];

    [likeButton setTitleColor:HLTopPostsCategoryContentColor forState:UIControlStateNormal];
    [likeButton.titleLabel setFont:HLTopPostsCategoryContentFont];
    [originalView addSubview:likeButton];
    self.likeButton = likeButton;
    
    /** 点赞统计 */
    UILabel *likeCountLabel = [[UILabel alloc] init];
    likeCountLabel.font = HLTopPostsCategoryContentFont;
    likeCountLabel.textColor = HLTopPostsCategoryContentColor;
    //likeCountLabel.numberOfLines = 0;
    [originalView addSubview:likeCountLabel];
    self.likeCountLabel = likeCountLabel;
    
}
- (void)setTopPostsCategoryFrame:(HLTopPostsCategoryFrame *)topPostsCategoryFrame
{
    _topPostsCategoryFrame = topPostsCategoryFrame;

    /** 整体 */
    self.originalView.frame = topPostsCategoryFrame.originalViewF;
    
    /** 头像 */
    self.iconView.frame = topPostsCategoryFrame.iconViewF;
    self.iconView.user = topPostsCategoryFrame.topPosts.posts.user;

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
    self.photosView.frame = topPostsCategoryFrame.photosViewF;
    
    NSURL *url = [NSURL URLWithString:topPostsCategoryFrame.topPosts.posts.photo];
    [self.photosView sd_setImageWithURL:url];
    
    /** 昵称 */
    self.nameLabel.text = topPostsCategoryFrame.topPosts.posts.user.name;
    self.nameLabel.frame = topPostsCategoryFrame.nameLabelF;
    
    /** 时间 */
    NSString *time = topPostsCategoryFrame.topPosts.posts.created_at;
    self.timeLabel.frame = topPostsCategoryFrame.timeLabelF;
    self.timeLabel.text = time;

    /** 点赞 */
    self.likeButton.frame = topPostsCategoryFrame.likeLabelF;
    [self.likeButton setTitle:@"点赞" forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"timeline_icon_unlike"]forState:UIControlStateNormal];
    [self.likeButton addTarget:self action:@selector(clickLike) forControlEvents:UIControlEventTouchUpInside];
    
    /** 点赞统计数 */
    self.likeCountLabel.text = [NSString stringWithFormat:@"%d",topPostsCategoryFrame.topPosts.likes_count];
    self.likeCountLabel.frame = topPostsCategoryFrame.likeCountLabelF;

}

- (void)clickLike
{
    HLLog(@"++++++++++click like on top posts category ++++++++++++");
}
@end
