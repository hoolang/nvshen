//
//  HLAddCommentViewController.h
//  nvshen
//
//  Created by hoolang on 15/5/30.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLComments.h"
#import "HLStatus.h"
@interface HLAddCommentViewController : UITableViewController

@property (nonatomic, strong) HLComments *comments;
@property (nonatomic, strong) HLStatus *status;
@end
