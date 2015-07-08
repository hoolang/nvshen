//
//  HLChatDealSubscribeViewController.h
//  nvshen
//
//  Created by hoolang on 15/7/8.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLUser.h"

@protocol HLChatDealSubscribeDelegate <NSObject>

- (void)changeStatus:(NSString *)status withTag:(NSInteger)tag;

@end
@interface HLChatDealSubscribeViewController : UIViewController
@property (nonatomic, strong) HLUser *user;
@property (nonatomic, weak) id<HLChatDealSubscribeDelegate> delegate;
@property (nonatomic, assign) NSInteger tag;
@end
