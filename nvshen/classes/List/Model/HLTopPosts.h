//
//  HLTopPosts.h
//  nvshen
//
//  Created by hoolang on 15/6/4.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HLPosts;
@interface HLTopPosts : NSObject
/**	object	show作者的用户信息字段 详细*/
@property (nonatomic, strong) HLPosts *posts;
/**	int	评论数*/
@property (nonatomic, assign) int comment_count;
/**	int	表态数*/
//@property (nonatomic, assign) int likes_count;
@end
