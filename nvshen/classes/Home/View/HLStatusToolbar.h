//
//  HLStatusToolbar.h
//  nvshen
//
//  Created by hoolang on 15/5/28.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HLStatus;

@interface HLStatusToolbar : UIView
+ (instancetype)toolbar;

@property (nonatomic, strong) HLStatus *status;

@end
