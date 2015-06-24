//
//  HLProfile.h
//  nvshen
//
//  Created by hoolang on 15/6/24.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HLUser;
@interface HLProfile : NSObject
@property (nonatomic, strong) HLUser *user;
@property (nonatomic, copy) NSString *like_count;
@end
