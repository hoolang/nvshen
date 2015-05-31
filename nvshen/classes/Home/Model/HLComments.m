//
//  HLComments.m
//  nvshen
//
//  Created by hoolang on 15/6/1.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLComments.h"

@implementation HLComments

- (NSString *)commentDate{
    return [_commentDate getNewStyleByCompareNow];
}

@end
