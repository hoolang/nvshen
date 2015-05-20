//
//  HWEmotionTextView.h
//  黑马微博2期
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HLTextView.h"
@class HLEmotion;

@interface HLEmotionTextView : HLTextView
- (void)insertEmotion:(HLEmotion *)emotion;

- (NSString *)fullText;
@end
