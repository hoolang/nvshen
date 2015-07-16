//
//  ILAboutHeaderView.m
//
//  Created by Hoolang on 13-12-23.
//  Copyright (c) 2013年 Hoolang. All rights reserved.
//

#import "HLAboutHeaderView.h"

@implementation HLAboutHeaderView

+ (instancetype)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:@"HLAboutHeaderView" owner:nil options:nil][0];
}
@end
