//
//  HLHttpTool.h
//  nvshen
//
//  Created by hoolang on 14-10-25.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLHttpTool : NSObject
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end
