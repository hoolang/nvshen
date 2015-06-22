//
//  HLProvinces.h
//  nvshen
//
//  Created by hoolang on 15/6/18.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLProvinces : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)NSArray *cities;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)provinceWithDict:(NSDictionary *)dict;
@end
