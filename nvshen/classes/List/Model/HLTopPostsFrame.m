//
//  HLTopPostsFrame.m
//  nvshen
//
//  Created by hoolang on 15/6/4.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLTopPostsFrame.h"
#import "HLTopPosts.h"
#import "HLTopPhotosView.h"

@implementation HLTopPostsFrame
- (void)setTopPosts:(HLTopPosts *)topPosts
{
    _topPosts = topPosts;
    
    /** 占位图 */
    CGFloat firstViewWH = 80;
    CGFloat firstViewX = 0;
    CGFloat firstViewY = HLTopPostsCellMargin;
    self.firstViewF = CGRectMake(firstViewX, firstViewY, firstViewWH, firstViewWH);
    
    /** scrollview*/
    CGFloat lastViewX = CGRectGetMaxX(self.firstViewF) + HLTopPostsCellMargin;
    CGFloat lastViewY = HLTopPostsCellMargin;
    CGSize lastViewFSize = [HLTopPhotosView sizeWithCount:3];
    self.lastViewF = (CGRect){{lastViewX, lastViewY}, lastViewFSize};

    /** 底部文字 */
    CGFloat bottomViewX = firstViewX;
    CGFloat bottomViewY = CGRectGetMaxY(self.firstViewF);
    self.bottomViewF = CGRectMake(bottomViewX, bottomViewY, ScreenWidth, 30);
    
    /** 整体 */
    self.originalViewF = CGRectMake(firstViewX, firstViewX, ScreenWidth, firstViewWH);
    
    self.cellHeight = CGRectGetMaxY(self.bottomViewF) + HLTopPostsCellBorderW;
    
}

-(void)setTopPostsM:(NSArray *)TopPostsM{
    _topPostsM = TopPostsM;
}
@end
