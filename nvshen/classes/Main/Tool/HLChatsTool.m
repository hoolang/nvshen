//
//  HLChatsTool.m
//  Hoolang
//
//  Created by apple on 14/11/20.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import "HLChatsTool.h"
#import "FMDB.h"
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
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS hl_newfriends (username text PRIMARY KEY, user blob NOT NULL, status text, updatetime text, cteatetime text);"];
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
    HLLog(@"array.count %ld", array.count);
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
 *  删除
 *
 *  @param chatId username
 */
+ (void)deleteChats:(NSString *)username
{
    NSString *sql = [NSString stringWithFormat:@"delete from hl_chats where username = '%@' ;", username];
    HLLog(@"deleteChats:%@", sql);
    [_db executeUpdate:sql];
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
        
        HLLog(@"update sql  %@", [NSString stringWithFormat:@"UPDATE hl_newfriends  SET updatetime = '%@', status = '%@' WHERE username = '%@';", strDate, user.text, user.username]);
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE hl_newfriends  SET updatetime = '%@', status = '%@' WHERE username = '%@';", strDate, user.text, user.username];
        
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
        
        [_db executeUpdateWithFormat:@"INSERT INTO hl_newfriends(username, user, status, updatetime, cteatetime) VALUES (%@,%@, %@, %@, %@);", user.username, userData, user.text, strDate, strDate];
    }
}

+ (NSArray *)seleteFriendByUsername:(NSString *)username
{
    NSString *sql = [NSString stringWithFormat: @"SELECT * FROM hl_newfriends where username = '%@';", username ];
    
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
    NSString *sql = @"SELECT * FROM hl_newfriends ORDER BY date(updatetime) ASC, time(updatetime) ASC LIMIT 20;";
    
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
    NSString *sql = @"SELECT * FROM hl_newfriends where status = '未处理' ORDER BY date(updatetime) ASC, time(updatetime) ASC LIMIT 20;";
    
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
 *  删除
 *
 *  @param chatId username
 */
+ (void)deleteSubscription:(NSString *)username
{
    NSString *sql = [NSString stringWithFormat:@"delete from hl_newfriends where username = '%@' ;", username];
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

    NSString *sql = [NSString stringWithFormat:@"update hl_newfriends set updatetime = '%@',status = '%@' where username = '%@';",strDate, status, username];
    
    HLLog(@"sql :%@", sql);
    [_db executeUpdate:sql];
}
@end
