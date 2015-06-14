//
//  HLInputView.h
//
//  Created by apple on 14/12/11.
//  Copyright (c) 2014年 hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLInputView : UIView
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

+(instancetype)inputView;

@end
