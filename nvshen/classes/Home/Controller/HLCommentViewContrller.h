//
//  HLCommentViewContrller.h
//  nvshen
//
//  Created by hoolang on 15/6/2.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HLComments;
@class HLStatus;
@interface HLCommentViewContrller : UIViewController
@property (nonatomic, strong) HLComments *comments;
@property (nonatomic, strong) HLStatus *status;
@end
