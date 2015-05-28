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
/** 用户ID*/
@property (nonatomic, copy) NSString *uid;
///** 用户性别*/
//@property (nonatomic, assign) char *sex;
/** 用户名*/
@property (nonatomic, copy) NSString *name;
/** 用户图标*/
@property (nonatomic, copy) NSString *icon;
///** 省份*/
//@property (nonatomic, copy) NSString *province;
///** 城市*/
//@property (nonatomic, copy) NSString *city;
/** 用户描述*/
@property (nonatomic, copy) NSString *text;
///** 注册时间*/
//@property (nonatomic, copy) NSDate *registerTime;
///** 更新时间*/
//@property (nonatomic, copy) NSDate *updateTime;
/** 认证类型 */
@property (nonatomic, assign) HLUserVerifiedType verified_type;


/**
 private int uid;
	private String name;
	private String icon;
	private char sex;
	private String province;
	private String ;
	private String description;
	private Date registerTime;
	private Date updateTime;
 */
@end
