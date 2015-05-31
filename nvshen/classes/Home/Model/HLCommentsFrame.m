//
//  HLCommentsFrame.m
//  nvshen
//
//  Created by hoolang on 15/6/1.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLCommentsFrame.h"
#import "HLComments.h"
#import "HLUser.h"
@implementation HLCommentsFrame
- (void)setStatus:(HLComments *)comments
{
    _comments = comments;
    
    
    HLLog(@"status %@", comments);
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /* 原创微博 */
    
    /** 头像 */
    CGFloat iconWH = 35;
    CGFloat iconX = HLStatusCellBorderW;
    CGFloat iconY = HLStatusCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + HLStatusCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [comments.user.name sizeWithFont:HLStatusCellNameFont];
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
    CGSize timeSize = [comments.commentDate sizeWithFont:HLStatusCellTimeFont];
    CGFloat timeX = cellW - HLStatusCellBorderW - timeSize.width;
    CGFloat timeY = nameY;
    
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    
    /** 正文 */
    CGFloat contentX = nameX;
    CGFloat contentY = CGRectGetMaxY(self.nameLabelF)+ HLStatusCellBorderW;
    CGFloat maxW = cellW - contentX - HLStatusCellBorderW;
    CGSize contentSize = [comments.comment sizeWithFont:HLStatusCellContentFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    CGFloat originalH = 0;
    originalH = CGRectGetMaxY(self.contentLabelF) + HLStatusCellBorderW;
    
    
    /** 评论整体 */
    CGFloat originalX = 0;
    CGFloat originalY = HLStatusCellMargin;
    CGFloat originalW = cellW;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
   
    
    /* cell的高度 */
    HLLog(@"CGRectGetMaxY(self.toolbarF)%f", CGRectGetMaxY(self.originalViewF));
    self.cellHeight = CGRectGetMaxY(self.originalViewF);
}
@end
