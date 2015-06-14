//
//  HLMessage.h
//
//  Created by apple on 14-8-22.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    HLMessageMe = 0,
    HLMessageOther = 1
}HLMessageType;
@interface HLMessage : NSObject

//正文
@property (nonatomic, copy)NSString *text;

//时间
@property (nonatomic, copy)NSString *time;

//发送类型
@property (nonatomic, assign)HLMessageType type;

//是否隐藏时间
@property (nonatomic,assign)BOOL hideTime;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)messageWithDict:(NSDictionary *)dict;

@end
