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
/**
 *  设置Badge
 */
- (void)setupChatBadge;
// 最近联系人控制器
@property (nonatomic, strong) HLChatRecentViewController *recentVC;
// 联系人列表控制器
@property (nonatomic, strong) HLChatListViewController *chatListVC;
@end
