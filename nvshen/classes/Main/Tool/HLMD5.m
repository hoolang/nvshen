//
//  HLMD5.m
//  nvshen
//
//  Created by hoolang on 15/6/17.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLMD5.h"
#import <CommonCrypto/CommonDigest.h>
@implementation HLMD5

/**md5 32位 加密 （小写）*/
+ (NSString *)md5:(NSString *)str {
    
    const char *cStr = [str UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH *2];
    
    for(int i =0; i < CC_MD5_DIGEST_LENGTH; i++){
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

@end
