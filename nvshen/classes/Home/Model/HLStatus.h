//
//  HLStatus.h
//  nvshen
//
//  Created by hoolang on 15/5/28.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HLPosts;
@interface HLStatus : NSObject
/**
"Comments": 0,
"Posts": {
    "content": "好图片要分享",
    "date": "2015-05-27 20:21:05",
    "photo": "1432729264571.jpg",
    "pid": 1,
    "user": {
        "icon": "",
        "name": "3333",
        "uid": 1
    }
},
"Likes": 1
*/

/**	object	show作者的用户信息字段 详细*/
@property (nonatomic, strong) HLPosts *posts;
/**	int	评论数*/
@property (nonatomic, assign) int comments_count;
/**	int	表态数*/
@property (nonatomic, assign) int likes_count;

@end
