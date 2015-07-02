//
//  HLStatusFrame.m
//  nvshen
//
//  Created by hoolang on 15/5/28.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLStatusFrame.h"
#import "HLStatus.h"
#import "HLPosts.h"
#import "HLUser.h"
#import "HLStatusPhotosView.h"


@implementation HLStatusFrame

- (void)setStatus:(HLStatus *)status
{
    _status = status;
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /** 头像 */
    CGFloat iconWH = 35;
    CGFloat iconX = HLStatusCellBorderW;
    CGFloat iconY = HLStatusCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + HLStatusCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [status.posts.user.nickname sizeWithFont:HLStatusCellNameFont];
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
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF)-2;
    CGSize timeSize = [status.posts.created_at sizeWithFont:HLStatusCellTimeFont];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    
    /** 配图 */
    CGFloat originalH = 0;
    
    // 配图
    CGFloat photosX = 0;
    CGFloat photosY = CGRectGetMaxY(self.iconViewF) + HLStatusCellBorderW;
    
    CGSize photosSize = [HLStatusPhotosView sizeWithCount:1];
    self.photosViewF = (CGRect){{photosX, photosY}, photosSize};
    
    
    /** 正文 */
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.photosViewF), CGRectGetMaxY(self.timeLabelF)) + HLStatusCellBorderW;
    CGFloat maxW = cellW - 2 * contentX;
    CGSize contentSize = [status.posts.content sizeWithFont:HLStatusCellContentFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    originalH = CGRectGetMaxY(self.contentLabelF) + HLStatusCellBorderW;
   
    
    /** 原创整体 */
    CGFloat originalX = 0;
    CGFloat originalY = HLStatusCellMargin;
    CGFloat originalW = cellW;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
    
    CGFloat toolbarY = 0;
    /* 被转发微博 */
//    if (status.retweeted_status) {
//        HWStatus *retweeted_status = status.retweeted_status;
//        HWUser *retweeted_status_user = retweeted_status.user;
//        
//        /** 被转发微博正文 */
//        CGFloat retweetContentX = HWStatusCellBorderW;
//        CGFloat retweetContentY = HWStatusCellBorderW;
//        NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", retweeted_status_user.name, retweeted_status.text];
//        CGSize retweetContentSize = [retweetContent sizeWithFont:HWStatusCellRetweetContentFont maxW:maxW];
//        self.retweetContentLabelF = (CGRect){{retweetContentX, retweetContentY}, retweetContentSize};
    
//        /** 被转发微博配图 */
//        CGFloat retweetH = 0;
//        if (retweeted_status.pic_urls.count) { // 转发微博有配图
//            CGFloat retweetPhotosX = retweetContentX;
//            CGFloat retweetPhotosY = CGRectGetMaxY(self.retweetContentLabelF) + HWStatusCellBorderW;
//            CGSize retweetPhotosSize = [HWStatusPhotosView sizeWithCount:retweeted_status.pic_urls.count];
//            self.retweetPhotosViewF = (CGRect){{retweetPhotosX, retweetPhotosY}, retweetPhotosSize};
//            
//            retweetH = CGRectGetMaxY(self.retweetPhotosViewF) + HWStatusCellBorderW;
//        } else { // 转发微博没有配图
//            retweetH = CGRectGetMaxY(self.retweetContentLabelF) + HWStatusCellBorderW;
//        }
//        
//        /** 被转发微博整体 */
//        CGFloat retweetX = 0;
//        CGFloat retweetY = CGRectGetMaxY(self.originalViewF);
//        CGFloat retweetW = cellW;
//        self.retweetViewF = CGRectMake(retweetX, retweetY, retweetW, retweetH);
//        
//        toolbarY = CGRectGetMaxY(self.retweetViewF);
//    } else {
//        toolbarY = CGRectGetMaxY(self.originalViewF);
//    }
    toolbarY = CGRectGetMaxY(self.originalViewF);
    
    /** 工具条 */
    CGFloat toolbarX = 0;
    CGFloat toolbarW = cellW;
    CGFloat toolbarH = 35;
    self.toolbarF = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
    
    /* cell的高度 */
    HLLog(@"CGRectGetMaxY(self.toolbarF)%f", CGRectGetMaxY(self.toolbarF));
    self.cellHeight = CGRectGetMaxY(self.toolbarF);
}

@end
