//
//  HLCommentToolbar.h
//  nvshen
//
//  Created by hoolang on 15/5/31.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLStatus.h"
@interface HLCommentToolbar : UIView
+ (instancetype)toolbar;

@property (nonatomic, strong) HLStatus *status;
@end
