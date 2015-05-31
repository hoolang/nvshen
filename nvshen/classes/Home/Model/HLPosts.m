//
//  HLPostsl.m
//  nvshen
//
//  Created by hoolang on 15/5/28.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLPosts.h"
#import "HLPhoto.h"
#import "MJExtension.h"
@implementation HLPosts

- (NSString *)created_at
{
    return [_created_at getNewStyleByCompareNow];
}
@end
