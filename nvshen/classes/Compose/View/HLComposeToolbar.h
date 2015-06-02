//
//  HWComposeToolbar.h
//  黑马微博2期
//
//  Created by apple on 14-10-20.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HLComposeToolbarTypeCamera, // 拍照
    HLComposeToolbarTypePicture, // 相册
    HLComposeToolbarTypeMention, // @
    HLComposeToolbarTypeTrend, // #
    HLComposeToolbarTypeSend,    //发送
    HLComposeToolbarTypeEmotion // 表情
} HLComposeToolbarButtonType;

@class HLComposeToolbar;
@class HLEmotionTextView;

@protocol HLComposeToolbarDelegate <NSObject>
@optional
- (void)composeToolbar:(HLComposeToolbar *)toolbar didClickButton:(HLComposeToolbarButtonType)buttonType;
- (void)composeToolbar:(HLComposeToolbar *)toolbar refreshToolbarFrame:(CGFloat)diffrence;
@end

@interface HLComposeToolbar : UIView
@property (nonatomic, weak) id<HLComposeToolbarDelegate> delegate;
/** 输入控件 */
@property (nonatomic, weak) HLEmotionTextView *textView;
/** 是否要显示键盘按钮  */
@property (nonatomic, assign) BOOL showKeyboardButton;
@end
