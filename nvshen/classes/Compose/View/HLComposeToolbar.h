//
//  HWComposeToolbar.h
//  黑马微博2期
//
//  Created by apple on 14-10-20.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HLComposeToolbarButtonTypeCamera, // 拍照
    HLComposeToolbarButtonTypePicture, // 相册
    HLComposeToolbarButtonTypeMention, // @
    HLComposeToolbarButtonTypeTrend, // #
    HLComposeToolbarButtonTypeEmotion // 表情
} HLComposeToolbarButtonType;

@class HLComposeToolbar;

@protocol HLComposeToolbarDelegate <NSObject>
@optional
- (void)composeToolbar:(HLComposeToolbar *)toolbar didClickButton:(HLComposeToolbarButtonType)buttonType;
@end

@interface HLComposeToolbar : UIView
@property (nonatomic, weak) id<HLComposeToolbarDelegate> delegate;
/** 是否要显示键盘按钮  */
@property (nonatomic, assign) BOOL showKeyboardButton;
@end
