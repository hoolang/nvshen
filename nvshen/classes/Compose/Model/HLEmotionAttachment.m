//
//  HWEmotionAttachment.m
//  黑马微博2期
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HLEmotionAttachment.h"
#import "HLEmotion.h"

@implementation HLEmotionAttachment
- (void)setEmotion:(HLEmotion *)emotion
{
    _emotion = emotion;
    
    self.image = [UIImage imageNamed:emotion.png];
}
@end
