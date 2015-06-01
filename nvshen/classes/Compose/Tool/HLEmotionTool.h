//
//  HLEmotionTool.h
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 HOOLANG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HLEmotion;

@interface HLEmotionTool : NSObject
+ (void)addRecentEmotion:(HLEmotion *)emotion;
+ (NSArray *)recentEmotions;
@end
