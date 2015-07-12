//
//  HLChatMainViewController.h
//  nvshen
//
//  Created by hoolang on 15/7/6.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLChatRecentViewController.h"
#import "HLChatListViewController.h"

@interface HLChatMainViewController : UIViewController
- (void)setupChatBadge;
@property (nonatomic, strong) HLChatRecentViewController *recentVC;
@property (nonatomic, strong) HLChatListViewController *chatListVC;
@end
