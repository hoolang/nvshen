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
- (void)setComments:(HLComments *)comments
{
    _comments = comments;
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /* 原创微博 */
    
    /** 头像 */
    CGFloat iconWH = 30;
    CGFloat iconX = HLCommentCellBorderW;
    CGFloat iconY = HLCommentCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + HLCommentCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [comments.user.name sizeWithFont:HLCommentCellNameFont];
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
    CGSize timeSize = [comments.commentDate sizeWithFont:HLCommentCellTimeFont];
    CGFloat timeX = cellW - HLCommentCellBorderW - timeSize.width;
    CGFloat timeY = nameY;
    
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    
    /** 正文 */
    CGFloat contentX = nameX;
    CGFloat contentY = CGRectGetMaxY(self.nameLabelF)+ 2;
    CGFloat maxW = cellW - contentX - HLCommentCellBorderW;
    CGSize contentSize = [comments.comment sizeWithFont:HLCommentCellContentFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    CGFloat originalH = 0;
    originalH = CGRectGetMaxY(self.contentLabelF) + HLCommentCellBorderW;
    
    
    /** 评论整体 */
    CGFloat originalX = 0;
    CGFloat originalY = HLCommentCellMargin;
    CGFloat originalW = cellW;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
   
    
    /* cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.originalViewF);
}
@end
