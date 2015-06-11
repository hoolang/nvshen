//
//  HLTopPostsCell.m
//  nvshen
//
//  Created by hoolang on 15/6/4.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLTopPostsCell.h"
#import "HLTopPhotosView.h"
#import "HLTopPostsFrame.h"
#import "HLStatus.h"
#import "HLPosts.h"
#import "HLPhoto.h"
#import "UIImageView+WebCache.h"
#import "HLStatusPhotosView.h"
#import "HLTopDetailViewController.h"

@interface HLTopPostsCell()
/** 占位图片 */
@property (nonatomic, weak) UIImageView *firstView;
@property (nonatomic, weak) HLTopPhotosView * lastView;
@property (nonatomic, weak) UILabel *bottomView;
@property (nonatomic, copy) NSString *sourceURL;
@property (nonatomic, copy) NSString *vcTitle;
@end

@implementation HLTopPostsCell

- (void)setupOriginal{
    /** 整体 */
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    
    /** 占位符 */
    UIImageView *firstView = [[UIImageView alloc] init];
    [originalView addSubview:firstView];
    self.firstView = firstView;
    
    /** scroll view*/
    HLTopPhotosView *lastView = [[HLTopPhotosView alloc] init];
    [originalView addSubview:lastView];
    self.lastView = lastView;
    
    /** 底部文字 */
    UILabel *bottomView = [[UILabel alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [originalView addSubview:bottomView];
    self.bottomView = bottomView;
    
}
- (void)setTopPostsArray:(NSArray *) topPostsArray{
    
    _topPostsArray = topPostsArray;
    
}

- (void)setTopPostsFrame:(HLTopPostsFrame *) topPostsFrame{
    
    _topPostsFrame = topPostsFrame;
    
    self.originalView.frame = topPostsFrame.originalViewF;
    [self.originalView setUserInteractionEnabled:YES];
    
    /** 占位符 */
    self.firstView.frame =  topPostsFrame.firstViewF;
    
    // 设置图片                                       //@"http://192.168.168.188:8008/nvshen/photos/1432729264571.jpg"
    //[self.firstView sd_setImageWithURL:[NSURL URLWithString:@"http://192.168.168.188:8008/nvshen/photos/1432729264571.jpg"] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    


    /** scroolView Frame*/
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (int i = 0; i < topPostsFrame.topPostsM.count; i++) {
        HLTopPostsFrame *tpFrame = topPostsFrame.topPostsM[i];
        HLStatus *topPosts = tpFrame.topPosts;
        HLPhoto *photo = [[HLPhoto alloc] init];
                    
        photo.thumbnail_pic = topPosts.posts.photo;
        photo.topPosts = topPosts;
        [photos addObject:photo];
    }
    self.lastView.photos = photos;
    self.lastView.frame = topPostsFrame.lastViewF;

    /** 底部文字 */
    self.bottomView.frame = topPostsFrame.bottomViewF;
    //self.bottomView.text = topPostsFrame.topPosts.posts.content;
    self.bottomView.textColor = HLColor(100, 100, 100);
    self.bottomView.font = [UIFont systemFontOfSize:12];

}

/** 设置文字 */
- (void)setupBottom:(NSString *) buttomText
{
        self.bottomView.text = buttomText;
}
/** 设置占位图片 */
- (void)setupFirstView:(NSString *) imageUIL withURL:(NSString *)URL andTitle:(NSString *)title
{
    self.sourceURL = URL;
    self.vcTitle = title;
    
    /** 允许交互 */
    self.firstView.userInteractionEnabled = YES;
    [self.firstView sd_setImageWithURL:[NSURL URLWithString:imageUIL] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firstViewToDetailVC)];
    [self.firstView addGestureRecognizer:tapGesture];
}
/** 通知代理 */
- (void)firstViewToDetailVC
{
    HLLog(@"clickFirstView:(NSString *)URL withTitle:(NSString *)title");
    if ([self.delegate respondsToSelector:@selector(clickFirstView: withTitle:)]) {
        [self.delegate clickFirstView:self.sourceURL withTitle:self.vcTitle];
    }

}

@end
