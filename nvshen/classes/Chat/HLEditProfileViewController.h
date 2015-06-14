//
//  HLEditProfileViewController.h
//
//  Created by apple on 14/12/9.
//  Copyright (c) 2014年 HOOLANG. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HLEditProfileViewControllerDelegate <NSObject>

-(void)editProfileViewControllerDidSave;


@end

@interface HLEditProfileViewController : UITableViewController

@property (nonatomic, strong) UITableViewCell *cell;

@property (nonatomic, weak) id<HLEditProfileViewControllerDelegate> delegate;

@end