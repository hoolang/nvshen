//
//  HLProvinces.m
//  nvshen
//
//  Created by hoolang on 15/6/18.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLProvinces.h"
@implementation HLProvinces
-(instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}
+(instancetype)provinceWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
