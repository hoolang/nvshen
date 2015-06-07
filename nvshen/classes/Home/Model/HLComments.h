//
//  HLComments.h
//  nvshen
//
//  Created by hoolang on 15/6/1.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HLUser;
@class HLPosts;
@interface HLComments : UIView
/**
 "cid": 1,
 "comment": "11111",
 "commentDate": "2015-05-29 16:44:57",
 user
 */
//评论ID
@property (nonatomic, copy) NSString *cid;
//评论内容
@property (nonatomic, copy) NSString *comment;
//评论时间
@property (nonatomic, copy) NSString *commentDate;
//评论的用户
@property (nonatomic, strong) HLUser *user;
//评论的Post
@property (nonatomic, strong) HLPosts *post;

@end
