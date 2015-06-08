//
//  HLTopPostsCell.h
//  nvshen
//
//  Created by hoolang on 15/6/4.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HLTopPostsFrame;
@protocol HLTopPostsCellDelegate <NSObject>

@optional
- (void)clickFirstView:(NSString *)URL withTitle:(NSString *)title;
@end

@interface HLTopPostsCell : UITableViewCell
/** 设置整体 */
- (void)setupOriginal;
/** 设置底部文字 */
- (void)setupBottom:(NSString *) buttomText;
/** 设置占位图片URL和标题还有点击URL */
- (void)setupFirstView:(NSString *) imageUIL withURL:(NSString *)URL andTitle:(NSString *)title;

/** 代理 */
@property (nonatomic, weak) id<HLTopPostsCellDelegate> delegate;
/** 评论整体 */
@property (nonatomic, weak) UIView *originalView;

@property (nonatomic, strong) HLTopPostsFrame *topPostsFrame;

@property (nonatomic,strong) NSArray *topPostsArray;
@end
