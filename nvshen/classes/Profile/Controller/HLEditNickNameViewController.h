//
//  HLEditNickNameViewController.h
//  nvshen
//
//  Created by hoolang on 15/6/25.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HLEditNickNameDelegate<NSObject>
@optional
- (void)reloadNickname:(NSString *)nickname;
@end
@interface HLEditNickNameViewController : UIViewController
@property (nonatomic, copy) NSString* nickname;
@property (nonatomic, copy) NSString* uid;
@property (nonatomic, weak) id<HLEditNickNameDelegate> delegate;
@end
