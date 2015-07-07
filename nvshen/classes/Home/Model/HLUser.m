//
//  HLUser.m
//  nvshen
//
//  Created by hoolang on 15/5/28.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLUser.h"

@implementation HLUser
- (void)encodeWithCoder:(NSCoder *)encoder
{
    /** 用户ID*/
//    @property (nonatomic, copy) NSString *uid;
//    ///** 用户性别*/
//    @property (nonatomic, copy) NSString *sex;
//    /** 用户名*/
//    @property (nonatomic, copy) NSString *username;
//    /** name */
//    @property (nonatomic, copy) NSString *nickname;
//    /** email */
//    @property (nonatomic, copy) NSString *email;
//    /** 用户图标*/
//    @property (nonatomic, copy) NSString *icon;
//    ///** 省份*/
//    @property (nonatomic, copy) NSString *province;
//    ///** 城市*/
//    @property (nonatomic, copy) NSString *city;
//    /** 用户描述*/
//    @property (nonatomic, copy) NSString *text;
//    ///** 注册时间*/
//    //@property (nonatomic, copy) NSDate *registerTime;
//    ///** 更新时间*/
//    //@property (nonatomic, copy) NSDate *updateTime;
//    /** 认证类型 */
//    @property (nonatomic, assign) HLUserVerifiedType verified_type;
    [encoder encodeObject:self.uid forKey:@"uid"];
    [encoder encodeObject:self.sex forKey:@"sex"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.nickname forKey:@"nickname"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.icon forKey:@"icon"];
    [encoder encodeObject:self.province forKey:@"province"];
    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.text forKey:@"text"];
    [encoder encodeInt:self.verified_type forKey:@"verified_type"];

}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.sex = [decoder decodeObjectForKey:@"sex"];
        self.username = [decoder decodeObjectForKey:@"username"];
        self.nickname = [decoder decodeObjectForKey:@"nickname"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.icon = [decoder decodeObjectForKey:@"icon"];
        self.province = [decoder decodeObjectForKey:@"province"];
        self.city = [decoder decodeObjectForKey:@"city"];
        self.text = [decoder decodeObjectForKey:@"text"];
        self.verified_type = [decoder decodeIntForKey:@"verified_type"];


    }
    return self;
}@end
