//
//  HLEmotionAttachment.m

//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
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
