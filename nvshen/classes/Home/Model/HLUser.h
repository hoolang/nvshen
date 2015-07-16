//
//  HLUser.h
//  nvshen
//
//  Created by hoolang on 15/5/28.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HLUserVerifiedTypeNone = -1, // 没有任何认证
    HLUserVerifiedPersonal = 0,  // 个人认证
    HLUserVerifiedOrgEnterprice = 2, // 企业官方：CSDN、EOE、搜狐新闻客户端
    HLUserVerifiedOrgMedia = 3, // 媒体官方：程序员杂志、苹果汇
    HLUserVerifiedOrgWebsite = 5, // 网站官方：猫扑
    HLUserVerifiedDaren = 220 // 微博达人
} HLUserVerifiedType;

@interface HLUser : NSObject
/**
 city = "\U5e7f\U5dde";
 email = "";
 icon = "1434984711554.jpg";
 name = hoolang;
 password = e10adc3949ba59abbe56e057f20f883e;
 province = "\U5e7f\U4e1c";
 sex = "\U7537";
 text = "";
 uid = 2;
 username = hoolang;
 "verified_type" = 0;
 */
/** 用户ID*/
@property (nonatomic, copy) NSString *uid;
///** 用户性别*/
@property (nonatomic, copy) NSString *sex;
/** 用户名*/
@property (nonatomic, copy) NSString *username;
/** name */
@property (nonatomic, copy) NSString *nickname;
/** email */
@property (nonatomic, copy) NSString *email;
/** 用户图标*/
@property (nonatomic, copy) NSString *icon;
///** 省份*/
@property (nonatomic, copy) NSString *province;
///** 城市*/
@property (nonatomic, copy) NSString *city;
/** 用户描述*/
@property (nonatomic, copy) NSString *text;
///** 注册时间*/
//@property (nonatomic, copy) NSDate *registerTime;
///** 更新时间*/
@property (nonatomic, copy) NSString *updateTime;
/** 认证类型 */
@property (nonatomic, assign) HLUserVerifiedType verified_type;

@end
