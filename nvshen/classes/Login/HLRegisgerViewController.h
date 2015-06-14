//
//  HLRegisgerViewController.h
//
//  Created by apple on 14/12/8.
//  Copyright (c) 2014年 HOOLANG. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HLRegisgerViewControllerDelegate <NSObject>

/**
 *  完成注册
 */
-(void)regisgerViewControllerDidFinishRegister;

@end
@interface HLRegisgerViewController : UIViewController

@property (nonatomic, weak) id<HLRegisgerViewControllerDelegate> delegate;

@end
