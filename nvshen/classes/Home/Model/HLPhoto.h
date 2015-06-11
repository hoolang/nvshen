//
//  HLPhoto.h
//  nvshen
//
//  Created by hoolang on 15/5/28.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLStatus.h"
@interface HLPhoto : NSObject
/** 缩略图地址 */
@property (nonatomic, copy) NSString *thumbnail_pic;
/** 存放对应的status地址 */
@property (nonatomic, strong) HLStatus *topPosts;
@end
