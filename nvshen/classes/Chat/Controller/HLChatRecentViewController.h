//
//  HLChatRecentViewController.h
//  nvshen
//
//  Created by hoolang on 15/7/6.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HLChatViewController;
@protocol HLChatRecentVCDelegate <NSObject>

- (void)pushRecentToChatView:(UIViewController *)chatView;
- (void)pushRecentToSubscriptionView:(HLChatViewController *)chatView;
- (void)chatRecentRefreshMainViewBadge;

@end

@interface HLChatRecentViewController : UIViewController
@property (nonatomic, weak) id<HLChatRecentVCDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
- (void)loadDataSources;
- (void)subscriptions;
@end
