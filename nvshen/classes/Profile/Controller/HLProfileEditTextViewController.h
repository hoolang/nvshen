//
//  HLProfileEditTextViewController.h
//  nvshen
//
//  Created by hoolang on 15/6/25.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HLProfileEditTextDelegate<NSObject>
@optional
- (void)reloadText:(NSString *)text;
@end
@interface HLProfileEditTextViewController : UIViewController
@property (nonatomic, copy) NSString* text;
@property (nonatomic, copy) NSString* uid;
@property (nonatomic, weak) id<HLProfileEditTextDelegate> delegate;
@end
