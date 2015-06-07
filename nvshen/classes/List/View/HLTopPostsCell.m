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
#import "HLTopPosts.h"
#import "HLPosts.h"
#import "HLPhoto.h"
#import "UIImageView+WebCache.h"
#import "HLStatusPhotosView.h"

@interface HLTopPostsCell()
/** 占位图片 */
@property (nonatomic, weak) UIImageView *firstView;
@property (nonatomic, weak) HLTopPhotosView * lastView;
@property (nonatomic, weak) UILabel *bottomView;
@end

@implementation HLTopPostsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"topPost";
    HLTopPostsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HLTopPostsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
/**
  *  cell的初始化方法，一个cell只会调用一次
  *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
  */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // 点击cell的时候不要变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 设置选中时的背景为蓝色
        //        UIView *bg = [[UIView alloc] init];
        //        bg.backgroundColor = [UIColor blueColor];
        //        self.selectedBackgroundView = bg;
        
        // 这个做法不行
        //        self.selectedBackgroundView.backgroundColor = [UIColor blueColor];
        [self setupOriginal];
        
    }
    return self;
}

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
    
    [self.firstView sd_setImageWithURL:[NSURL URLWithString:topPostsFrame.topPosts.posts.photo] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];

    /** scroolView Frame*/
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (int i = 0; i < topPostsFrame.topPostsM.count; i++) {
        HLTopPostsFrame *tpFrame = topPostsFrame.topPostsM[i];
        HLTopPosts *topPosts = tpFrame.topPosts;
        HLPhoto *photo = [[HLPhoto alloc] init];
        
        photo.thumbnail_pic = topPosts.posts.photo;
        [photos addObject:photo];
    }
    self.lastView.photos = photos;
    self.lastView.frame = topPostsFrame.lastViewF;

    /** 底部文字 */
    self.bottomView.frame = topPostsFrame.bottomViewF;
    self.bottomView.text = topPostsFrame.topPosts.posts.content;
    self.bottomView.textColor = HLColor(100, 100, 100);
    self.bottomView.font = [UIFont systemFontOfSize:12];

}

@end
