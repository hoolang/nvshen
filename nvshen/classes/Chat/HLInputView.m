//
//  WCInputView.m
//  WeChat
//
//  Created by apple on 14/12/11.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HLInputView.h"

@implementation HLInputView


+(instancetype)inputView{
    return [[[NSBundle mainBundle] loadNibNamed:@"HLInputView" owner:nil options:nil] lastObject];
}
@end
