//
//  ILAboutHeaderView.m
//  01-ItcastLottery
//
//  Created by yz on 13-12-23.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "HLAboutHeaderView.h"

@implementation HLAboutHeaderView

+ (instancetype)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:@"HLAboutHeaderView" owner:nil options:nil][0];
}
@end
