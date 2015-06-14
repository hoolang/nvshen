//
//  NSString+Date.h
//  nvshen
//
//  Created by hoolang on 15/6/1.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)
- (NSString *)getNewStyleByCompareNow;
- (NSString *)getNewStyleByCompareNow:(NSString *) dateFormat;
@end
