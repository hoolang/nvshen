//
//  HLCommentView.m
//  nvshen
//
//  Created by hoolang on 15/5/31.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLCommentCell.h"

#import "HLComments.h"
#import "HLUser.h"
#import "HLCommentsFrame.h"
#import "UIImageView+WebCache.h"
#import "HLIconView.h"

@interface HLCommentCell()
/* 原创微博 */

/** 头像 */
@property (nonatomic, weak) HLIconView *iconView;
/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文 */
@property (nonatomic, weak) UILabel *contentLabel;


@end
@implementation HLCommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"comment";
    HLCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HLCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupOriginal];
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
    
    /** 来源 */
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = HLStatusCellSourceFont;
    [originalView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    /** 正文 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = HLStatusCellContentFont;
    contentLabel.numberOfLines = 0;
    [originalView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    HLLog(@"%@", self.contentLabel.text);
    
}

- (void)setStatusFrame:(HLCommentsFrame *)commentsFrame
{
    _commentsFrame = commentsFrame;
    
    HLLog(@"setStatusFrame =》》》》》%@",commentsFrame);
    
    /** 原创微博整体 */
    self.originalView.frame = commentsFrame.originalViewF;
    
    /** 头像 */
    self.iconView.frame = commentsFrame.iconViewF;
    self.iconView.user = commentsFrame.comments.user;
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
    
    
    /** 昵称 */
    self.nameLabel.text = commentsFrame.comments.user.name;
    HLLog(@"statusFrame.status.posts.user >>> %@",commentsFrame.comments.user.icon);
    self.nameLabel.frame = commentsFrame.nameLabelF;
    
    /** 时间 */
    NSString *time = commentsFrame.comments.commentDate;
    //    HLLog(@"status.created_at >>>>%@", commentsFrame.comments.commentDate);
    //    CGFloat timeX = commentsFrame.nameLabelF.origin.x;
    //    CGFloat timeY = CGRectGetMaxY(commentsFrame.nameLabelF) + HLStatusCellBorderW;
    //    CGSize timeSize = [time sizeWithFont:HLStatusCellTimeFont];
    self.timeLabel.frame = commentsFrame.timeLabelF;//(CGRect){{timeX, timeY}, timeSize};
    self.timeLabel.text = time;
    
    
    /** 正文 */
    self.contentLabel.text = commentsFrame.comments.comment;
    self.contentLabel.frame = commentsFrame.contentLabelF;
    HLLog(@"self.contentLabel.text>>>> %@", commentsFrame.comments.comment);
    
}


@end
