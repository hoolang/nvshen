//
//  HLChatsTool.m
//  Hoolang
//
//  Created by apple on 14/11/20.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import "HLChatsTool.h"
#import "FMDB.h"
#import "HLHttpTool.h"
#import "HLProfile.h"
#import "MJExtension.h"

#define hl_chats @"hl_chats"
#define hl_newfriends @"hl_newfriends"
@implementation HLChatsTool

static FMDatabase *_db;
+ (void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chats.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    // 2.创表
    // 保存最近联系人
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS hl_chats (username text PRIMARY KEY, user blob NOT NULL,updatetime text, cteatetime text);"];
    // 保存好友请求
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS hl_newfriends (username text PRIMARY KEY, user blob NOT NULL, status text, updatetime text, cteatetime text, selfname text);"];
    // 保存消息
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS hl_message (id integer PRIMARY KEY, username text , user blob NOT NULL, status text, updatetime text, cteatetime text, selfname text);"];
}

+ (NSArray *)chatsWithParams:(NSDictionary *)params
{
    // 根据请求参数生成对应的查询SQL语句
    NSString *sql = nil;
//    if (params[@"since_id"]) {
//        sql = [NSString stringWithFormat:@"SELECT * FROM t_status WHERE idstr > %@ ORDER BY idstr DESC LIMIT 20;", params[@"since_id"]];
//    } else if (params[@"max_id"]) {
//        sql = [NSString stringWithFormat:@"SELECT * FROM t_status WHERE idstr <= %@ ORDER BY idstr DESC LIMIT 20;", params[@"max_id"]];
//    } else {
//        sql = @"SELECT * FROM t_status ORDER BY idstr DESC LIMIT 20;";
//    }
    
    sql = @"SELECT * FROM hl_chats ORDER BY date(updatetime) ASC, time(updatetime) ASC LIMIT 20;";
    
    // 执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *users = [NSMutableArray array];
    while (set.next) {
        NSData *userData = [set objectForColumnName:@"user"];
        NSDictionary *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        [users addObject:user];
    }

    return users;
}

+ (void)saveChats:(HLUser *)user
{
    NSArray *array = [self seleteChatsByUsername:user.username];
    HLLog(@"saveChats array.count %ld", array.count);
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    
    if (array.count > 0) {
        HLLog(@"update sql  %@", [NSString stringWithFormat:@"update hl_chats set updatetime = '%@' where username = '%@'", strDate, user.username]);
        [_db executeUpdateWithFormat:@"update hl_chats set updatetime = '%@' where username = '%@'", strDate, user.username];
    }else{
        // 要将一个对象存进数据库的blob字段,最好先转为NSData
        // 一个对象要遵守NSCoding协议,实现协议中相应的方法,才能转成NSData
        // NSDictionary --> NSData
        
        [_db executeUpdateWithFormat:@"INSERT INTO hl_chats(username, user, updatetime, cteatetime) VALUES (%@,%@, %@, %@, %@);", user.username, userData, user.text, strDate, strDate];
    }

}

/**
 *  查找该用户信息是否存在
 *
 *  @param username 用户名
 *
 *  @return 返回用户数组
 */
+ (NSArray *)seleteChatsByUsername:(NSString *)username
{
    NSString *sql = [NSString stringWithFormat: @"SELECT * FROM hl_chats where username = '%@';", username ];
    
    HLLog(@"SQL %@", sql);
    
    // 执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *users = [NSMutableArray array];
    while (set.next) {
        NSData *userData = [set objectForColumnName:@"user"];
        NSDictionary *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        [users addObject:user];
    }

    return users;
}

#pragma mark -好友请求
/**
 *  保存新的好友请求数据到沙盒
 *
 *  @param user 
 */
+ (void)saveNewSubscription:(HLUser *)user
{
    NSArray *array = [self seleteFriendByUsername:user.username];
    HLLog(@"saveNewSubscription array.count %ld", array.count);
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    
    if (array.count > 0) {
        
        HLLog(@"update sql  %@", [NSString stringWithFormat:@"UPDATE hl_newfriends  SET updatetime = '%@', status = '%@' WHERE username = '%@' and selfname = '%@';", strDate, user.text, user.username, [HLUserInfo sharedHLUserInfo].user]);
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE hl_newfriends  SET updatetime = '%@', status = '%@' WHERE username = '%@' and selfname = '%@';", strDate, user.text, user.username, [HLUserInfo sharedHLUserInfo].user];
        
        BOOL res = [_db executeUpdate:sql];
        
        if (!res) {
            HLLog(@"error when update db table");
        } else {
            HLLog(@"success to update db table");
        }

    }else{
        // 要将一个对象存进数据库的blob字段,最好先转为NSData
        // 一个对象要遵守NSCoding协议,实现协议中相应的方法,才能转成NSData
        // NSDictionary --> NSData
        
        [_db executeUpdateWithFormat:@"INSERT INTO hl_newfriends(username, user, status, updatetime, cteatetime, selfname) VALUES (%@,%@, %@, %@, %@, %@);", user.username, userData, user.text, strDate, strDate, [HLUserInfo sharedHLUserInfo].user];

    }
}

+ (NSArray *)seleteFriendByUsername:(NSString *)username
{
    NSString *sql = [NSString stringWithFormat: @"SELECT * FROM hl_newfriends where username = '%@' and selfname = '%@';", username, [HLUserInfo sharedHLUserInfo].user ];
    
    HLLog(@"SQL %@", sql);
    
    // 执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *users = [NSMutableArray array];
    while (set.next) {
        NSData *userData = [set objectForColumnName:@"user"];
        NSDictionary *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        [users addObject:user];
    }

    return users;
}
/**
 *  统计好友请求
 *
 *  @param params 
 *
 *  @return
 */

+ (NSArray *)subscriptionWithParams:(NSDictionary *)params
{
    // 根据请求参数生成对应的查询SQL语句
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM hl_newfriends where selfname = '%@' ORDER BY date(updatetime) ASC, time(updatetime) ASC LIMIT 20;", [HLUserInfo sharedHLUserInfo].user ];
    
    // 执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *users = [NSMutableArray array];
    while (set.next) {
        NSData *userData = [set objectForColumnName:@"user"];
        NSDictionary *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        [users addObject:user];
    }

    return users;
}
/**
 *  最新的好友请求
 *
 *  @param params
 *
 *  @return
 */

+ (NSArray *)newSubscriptions
{
    // 根据请求参数生成对应的查询SQL语句
    //NSString *sql = @"SELECT * FROM hl_newfriends where status = '未处理' and selfname = '%@' ORDER BY date(updatetime) ASC, time(updatetime) ASC LIMIT 20;";
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM hl_newfriends where status = '未处理' and selfname = '%@' ORDER BY date(updatetime) ASC, time(updatetime) ASC LIMIT 20;", [HLUserInfo sharedHLUserInfo].user ];
    
    // 执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *users = [NSMutableArray array];
    while (set.next) {
        NSData *userData = [set objectForColumnName:@"user"];
        NSDictionary *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        [users addObject:user];
    }

    [set close];
    return users;
}

/**
 *  删除
 *
 *  @param chatId username
 */
+ (void)deleteSubscription:(NSString *)username
{
    NSString *sql = [NSString stringWithFormat:@"delete from hl_newfriends where username = '%@' and selfname = '%@';", username, [HLUserInfo sharedHLUserInfo].user];
    HLLog(@"deleteChats:%@", sql);
    [_db executeUpdate:sql];
}
/**
 *  更新好友请求状态
 *
 *  @param username
 */
+ (void)updateSubscriptionFromUsername:(NSString *)username Status:(NSString *)status
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];

    NSString *sql = [NSString stringWithFormat:@"update hl_newfriends set updatetime = '%@',status = '%@' where username = '%@' and selfname = '%@';",strDate, status, username, [HLUserInfo sharedHLUserInfo].user];
    
    HLLog(@"sql :%@", sql);
    [_db executeUpdate:sql];
}
/**
 *  更新所有好友请求状态
 *
 *  @param username
 */
+ (void)updateSubscriptionsStatus:(NSString *)status
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *sql = [NSString stringWithFormat:@"update hl_newfriends set updatetime = '%@',status = '%@' where selfname = '%@';",strDate, status, [HLUserInfo sharedHLUserInfo].user];
    
    HLLog(@"sql :%@", sql);
    [_db executeUpdate:sql];
}
#pragma mark-消息处理======================
/**
 *  保存消息
 *
 *  @param user
 */
+ (void)saveMessage:(XMPPMessage *)message isCurrent:(BOOL)current
{
    NSRange rang = [message.fromStr rangeOfString:@"@"];
    NSString *username = [message.fromStr substringToIndex:rang.location];
    
    // username = message.from.user
    HLLog(@"from username: %@", username);

    
    // 如果消息来自当前登录用户
    if (current && username == nil) {
        // 则用户名是接受方
        NSRange rang = [message.toStr rangeOfString:@"@"];
        username = [message.toStr substringToIndex:rang.location];
        // username = message.to.user
    }
    
    NSArray *array = [self seleteMessageByUsername:username];
    HLLog(@"saveMessage array.count %ld", array.count);

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];

    // 如果数据库里面有该用户的信息，则不用去服务器查找改用户的数据
    if (array.count > 0) {
        HLUser *user = array[0];
        user.text = message.body;
        user.updateTime = strDate;
        // email字段充当status字段
        user.email = @"未读";
        // 如果是当前聊天界面就表示已读
        if (current) user.email = @"已读";


        NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
        
        BOOL flag = [_db executeUpdateWithFormat:@"INSERT INTO hl_message(id,username, user, status, updatetime, cteatetime, selfname) VALUES (%@,%@,%@, %@, %@, %@, %@);", nil, user.username, userData, user.email, strDate, strDate,[HLUserInfo sharedHLUserInfo].user];
        
        
        if (flag)
            HLLog(@"命令执行成功");
        else
            HLLog(@"命令执行失败");
        
    }else{// 第一次插入数据，先根据用户名去服务器查找该用户的数据

        // 1.拼接请求参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"user.username"] = username;
        
        // 2.发送请求
        [HLHttpTool get:HL_ONE_USER_URL params:params success:^(id json) {
            
            // 将 "字典"数组 转为 "模型"数组
            NSArray *userInfo = [HLProfile objectArrayWithKeyValuesArray:json[@"userinfo"]];
            
            HLProfile *profile = userInfo[0];
            
            HLUser *user = profile.user;
            user.text = message.body;
            user.updateTime = strDate;
            // email字段充当status字段
            user.email = @"未读";
            // 如果是当前聊天界面就表示已读
            if (current) user.email = @"已读";
            
            NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
            
            // 关闭数据库
            [_db close];
            [_db open];
            
            BOOL flag = [_db executeUpdateWithFormat:@"INSERT INTO hl_message(id,username, user, status, updatetime, cteatetime, selfname) VALUES (%@, %@,%@, %@, %@, %@, %@);",nil, user.username, userData, user.email, strDate, strDate, [HLUserInfo sharedHLUserInfo].user];
            
            
            if (flag)
                HLLog(@"命令执行成功");
            else
                HLLog(@"命令执行失败");
            
        } failure:^(NSError *error) {
            HLLog(@"请求失败-%@", error);
        }];
    }
}
/**
 *  最新的好友请求
 *
 *  @param params
 *
 *  @return
 */

+ (NSArray *)loadMessages
{
    HLLog(@"%s", __func__);
    
    // 根据请求参数生成对应的查询SQL语句
    
    NSString *recents = [NSString stringWithFormat:@"SELECT * FROM hl_message WHERE id in (SELECT MAX(id) from hl_message GROUP BY username) AND selfname = '%@' GROUP BY username ORDER BY id DESC", [HLUserInfo sharedHLUserInfo].user];

    
    HLLog(@"recents:%@", recents);
    
    NSString *count = [NSString stringWithFormat:@"SELECT * , count(username) as cusername FROM hl_message where status = '未读' and selfname = '%@' GROUP BY username;", [HLUserInfo sharedHLUserInfo].user];
    

    // 执行SQL
    FMResultSet *recentsSet = [_db executeQuery:recents];
    
    FMResultSet *countSet = [_db executeQuery:count];

    NSMutableArray *users = [NSMutableArray array];
    
    NSMutableArray *counts = [NSMutableArray array];
    
    // 先循环统计未读数的结果集
    while (countSet.next) {
//        HLLog(@"countSet.next=>>>>>");
        NSData *userData = [countSet objectForColumnName:@"user"];
        HLUser *countUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        countUser.sex = [countSet objectForColumnName:@"cusername"];
//        HLLog(@"countUser.username %@", countUser.username);
        [counts addObject:countUser];
    }
    
    // 为最近联系人添加未读数
    while (recentsSet.next) {
        
        NSData *userData = [recentsSet objectForColumnName:@"user"];
        HLUser *recentUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
        [recentUser setSex:@"0"];
        
        for (HLUser *user in counts) {
//            HLLog(@"recentUser.username:%@ user.username:%@", recentUser.username, user.username);
            if ([recentUser.username isEqualToString: user.username]) {
                [recentUser setSex:user.sex];
            }
        }
//        HLLog(@"messages id: %@", [recentsSet objectForColumnName:@"id"]);
//        HLLog(@"messages user.text: %@", recentUser.text);
//        HLLog(@"messages user.sex:%@",recentUser.sex);
//        HLLog(@"messages recentUser.updateTime:%@",recentUser.updateTime);
        [users addObject:recentUser];
    }
    HLLog(@"messages users.count : %ld", users.count);
    
    [recentsSet close];
    [countSet close];

    return users;
}
/**
 *  获取user
 *
 *  @return
 */
+ (NSArray *)seleteMessageByUsername:(NSString *)username
{
    NSString *sql = [NSString stringWithFormat: @"SELECT * FROM hl_message where username = '%@' and selfname = '%@' LIMIT 1;", username, [HLUserInfo sharedHLUserInfo].user ];
    
    HLLog(@"SQL %@", sql);
    
    // 执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *users = [NSMutableArray array];
    while (set.next) {
        NSData *userData = [set objectForColumnName:@"user"];
        NSDictionary *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        [users addObject:user];
    }
    
    [set close];
    return users;
}
#pragma mark - 加载个人信息
/** 加载个人信息 */
- (void)loadUserInfo:(NSString *)username
{
    /**
     @property (strong, nonatomic) UIImage *avatar;      //头像
     @property (copy, nonatomic) NSString *nickname; //昵称
     @property (copy, nonatomic) NSString *sex;      //性别
     @property (copy, nonatomic) NSString *local;         //地区
     @property (copy, nonatomic) NSString *text;
     @property (nonatomic, copy) NSString *uid;
     */
    // 1.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user.username"] = username;
    
    // 2.发送请求
    [HLHttpTool get:HL_ONE_USER_URL params:params success:^(id json) {
        
        // 将 "字典"数组 转为 "模型"数组
        NSArray *userInfo = [HLProfile objectArrayWithKeyValuesArray:json[@"userinfo"]];
        
        HLProfile *profile = userInfo[0];
        
        HLUser *user = profile.user;
        user.text = @"未处理";
        // 保存请求好友的用户到沙盒
        [HLChatsTool saveNewSubscription:user];
        
        // NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_status.posts.pid, @"pid", nil];
        
        NSNotification *notification =[NSNotification notificationWithName:@"SetUpChatBadgeNotification" object:nil userInfo:nil];
        //通过通知中心发送通知
        [HLNotificationCenter postNotification:notification];
        
    } failure:^(NSError *error) {
        HLLog(@"请求失败-%@", error);
    }];
}
/**
 *  更新消息状态
 *  当从最近联系人那里点击跳转到聊天界面时执行该方法
 *  @param user 聊天对象
 */
+ (void)updateMessage:(NSString *)username
{
    NSString *sql = [NSString stringWithFormat:@"update hl_message set status = '已读' where username = '%@' and selfname = '%@';", username, [HLUserInfo sharedHLUserInfo].user];
    HLLog(@"updateMessage:%@", sql);
    [_db executeUpdate:sql];
}
/**
 *  删除最近联系人
 *
 *  @param username 要删除的联系人
 */
+ (void)deleteMessage:(NSString *)username
{
    NSString *sql = [NSString stringWithFormat:@"delete from hl_message where username = '%@' and selfname = '%@';", username, [HLUserInfo sharedHLUserInfo].user];
    HLLog(@"updateMessage:%@", sql);
    
    BOOL flag= [_db executeUpdate:sql];
    
    if (flag) HLLog(@"命令执行成功");
    
    else HLLog(@"命令执行失败");
}
@end
