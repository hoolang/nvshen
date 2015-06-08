//
//  HLPostsl.h
//  nvshen
//
//  Created by hoolang on 15/5/28.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HLUser;

@interface HLPosts : NSObject

/**	string	字符串型的微博ID*/
@property (nonatomic, copy) NSString *pid;

/**	string	show内容*/
@property (nonatomic, copy) NSString *content;

/**	object	show作者的用户信息字段 详细*/
@property (nonatomic, strong) HLUser *user;

/**	string	show创建时间*/
@property (nonatomic, copy) NSString *created_at;

/** show配图地址。*/
@property (nonatomic, copy) NSString *photo;
@end