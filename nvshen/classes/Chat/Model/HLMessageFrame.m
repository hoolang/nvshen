//
//  HLMessageFrame.m
//
//  Created by apple on 14-8-22.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import "HLMessageFrame.h"
#import "Constant.h"
#import "HLMessage.h"
@implementation HLMessageFrame

- (void)setMessage:(HLMessage *)message
{
    _message = message;
    
    CGFloat padding = 10;
    //1. 时间
    if (message.hideTime == NO) {
        CGFloat timeX = 0;
        CGFloat timeY = 0;
        CGFloat timeW = bScreenWidth;
        CGFloat timeH = bNormalH;
        
        _timeF = CGRectMake(timeX, timeY, timeW, timeH);
    }
    
    //2.头像
    CGFloat iconX;
    CGFloat iconY = CGRectGetMaxY(_timeF);
    CGFloat iconW = bIconW;
    CGFloat iconH = bIconH;
    
    if (message.type == HLMessageMe) {//自己发的
        
        iconX = bScreenWidth - iconW - padding;
        
    }else{//别人发的
        iconX = padding;
    }
    
    _iconF =  CGRectMake(iconX, iconY, iconW, iconH);
    //3.正文
    
    CGFloat textX;
    CGFloat textY = iconY;
    
    CGSize textMaxSize = CGSizeMake(150, MAXFLOAT);
    CGSize textRealSize = [message.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:bBtnFont} context:nil].size;
    
    CGSize btnSize = CGSizeMake(textRealSize.width + 40, textRealSize.height + 40);
    
    if (message.type == HLMessageMe) {
        textX = bScreenWidth - iconW - padding*2 - btnSize.width;
    }else{
        textX = padding + iconW;
    }
    
//    _textViewF = CGRectMake(textX, textY, <#CGFloat width#>, <#CGFloat height#>)
    _textViewF = (CGRect){{textX,textY},btnSize};
    
    //4.cell高度
    
    CGFloat iconMaxY = CGRectGetMaxY(_iconF);
    CGFloat textMaxY = CGRectGetMaxY(_textViewF);
    
    _cellH = MAX(iconMaxY, textMaxY);
    
}

@end
