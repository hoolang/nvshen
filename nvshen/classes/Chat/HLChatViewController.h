//
//  HLChatViewController.h
//
//  Created by apple on 14/12/11.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPJID.h"
@interface HLChatViewController : UIViewController
/** 对方的头像 */
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) XMPPJID *friendJid;
@end
