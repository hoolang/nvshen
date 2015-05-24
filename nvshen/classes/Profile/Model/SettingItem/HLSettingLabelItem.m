//
//  ILSettingLabelItem.m
//  ItheimaLottery
//
//  Created by apple on 14-9-10.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HLSettingLabelItem.h"

#import "HLSaveTool.h"

@implementation HLSettingLabelItem

- (void)setText:(NSString *)text
{
    _text = text;
    
    [HLSaveTool setObject:text forKey:self.title];
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    _text = [HLSaveTool objectForKey:self.title];
}

@end
