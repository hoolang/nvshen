//
//  HLChatsTool.h
//
//
//  Created by apple on 14/11/20.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//  联系人工具类:用来处理最近联系人的缓存

#import <Foundation/Foundation.h>
#import "HLUser.h"

@interface HLChatsTool : NSObject
/**
 *  根据请求参数去沙盒中加载缓存的联系人数据
 *
 *  @param params 请求参数
 */
+ (NSArray *)chatsWithParams:(NSDictionary *)params;

/**
 *  存储联系人据到沙盒中
 *
 *  @param statuses 需要存储的联系数据
 */
+ (void)saveChats:(HLUser *)usser;
/**
 *  删除沙盒中的联系人
 *
 *  @param chatId 联系人对应的id
 */
+ (void)deleteChats:(NSString *)username;

#pragma mark-好友请求
/**
 *  统计好友请求
 *
 *  @param params <#params description#>
 *
 *  @return <#return value description#>
 */
+ (NSArray *)subscriptionWithParams:(NSDictionary *)params;
/**
 *  删除沙河中的数据
 *
 *  @param username
 */
+ (void)deleteSubscription:(NSString *)username;
/**
 *  保存好友请求信息到沙盒中
 *
 *  @param user <#user description#>
 */
+ (void)saveNewSubscription:(HLUser *)user;
/**
 *  最新的好友请求（未处理）
 *
 *  @return <#return value description#>
 */
+ (NSArray *)newSubscriptions;
/**
 *  更新好友请求状态
 *
 *  @param username
 */
+ (void)updateSubscriptionFromUsername:(NSString *)username Status:(NSString *)status;
@end
