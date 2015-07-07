//
//  HLChatListViewController.h
//  nvshen
//
//  Created by hoolang on 15/6/12.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HLChatViewController;

@protocol HLChatListVCDelegate<NSObject>

- (void)pushToChatView:(HLChatViewController *)chatView;

@end
@interface HLChatListViewController : UIViewController

/** 标记是否已经加载数据 */
@property (nonatomic, assign) BOOL didLoad;
@property (nonatomic, weak) id<HLChatListVCDelegate> delegate;
-(void)loadFriends;
@end
