//
//  HLTextView.h
//
//  Created by apple on 14-10-20.
//  增强：带有占位文字

#import <UIKit/UIKit.h>

@interface HLTextView : UITextView
/** 占位文字 */
@property (nonatomic, strong) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
@end
