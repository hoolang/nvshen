//
//  HLTopPostsCategoryFrame.m
//  nvshen
//
//  Created by hoolang on 15/6/8.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLTopPostsCategoryFrame.h"
#import "HLPosts.h"
#import "HLUser.h"
#import "HLStatusPhotosView.h"

@implementation HLTopPostsCategoryFrame
- (void)setTopPosts:(HLStatus *)topPosts{
    _topPosts = topPosts;
    // cell的宽度
    CGFloat cellW = CollectionWidth;
    
    /** 头像 */
    CGFloat iconWH = 30;
    CGFloat iconX = HLTopPostsCategoryBorderW;
    CGFloat iconY = HLTopPostsCategoryBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + HLTopPostsCategoryBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [topPosts.posts.user.name sizeWithFont:HLTopPostsCategoryNameFont];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    //    /** 会员图标 */
    //    if (user.isVip) {
    //        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + HWStatusCellBorderW;
    //        CGFloat vipY = nameY;
    //        CGFloat vipH = nameSize.height;
    //        CGFloat vipW = 14;
    //        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    //    }
    
    /** 时间 */
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF)+ HLTopPostsCategoryBorderW * 0.5;
    CGSize timeSize = [topPosts.posts.created_at sizeWithFont:HLTopPostsCategoryTimeFont];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    
    /** 配图 */
    CGFloat originalH = 0;
    
    // 配图
    CGFloat photoX = 0;
    CGFloat photoY = CGRectGetMaxY(self.iconViewF) + HLTopPostsCategoryBorderW;
    
//    CGSize photoSize = [HLStatusPhotosView sizeWithCount:1];
    self.photosViewF = (CGRect){{photoX, photoY}, cellW ,cellW};
    
    /** 点赞按钮*/
    CGFloat likeX = 0;
    CGFloat likeY = CGRectGetMaxY(self.photosViewF) + HLTopPostsCategoryBorderW * 0.5;
    CGSize likeSize = CGSizeMake(60, 15);
    self.likeLabelF = (CGRect){{likeX, likeY}, likeSize};
    
    /** 点赞统计*/
    CGSize likeCountSize = [[NSString stringWithFormat:@"%d", topPosts.likes_count] sizeWithFont:HLTopPostsCategoryTimeFont];
    CGFloat likeCountX = cellW - HLTopPostsCategoryBorderW - likeCountSize.width;
    CGFloat likeCountY = likeY;

    self.likeCountLabelF = (CGRect){{likeCountX, likeCountY}, likeCountSize};
    
    originalH = CGRectGetMaxY(self.likeLabelF) + HLTopPostsCategoryBorderW;
    
    /** 整体 */
    CGFloat originalX = 0;
    CGFloat originalY = HLTopPostsCategoryMargin;
    CGFloat originalW = cellW;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);

    /* cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.originalViewF);}
@end