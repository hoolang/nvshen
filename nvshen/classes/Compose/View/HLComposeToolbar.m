//
//  HWComposeToolbar.m
//  黑马微博2期
//
//  Created by apple on 14-10-20.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HLComposeToolbar.h"
#import "HLEmotionTextView.h"
@interface HLComposeToolbar()<UITextViewDelegate>
@property (nonatomic, weak) UIButton *emotionButton;

@property (nonatomic, weak) UIButton *sendButton;
@end

@implementation HLComposeToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        self.backgroundColor = HLColor(239, 239, 239);

        self.frame = CGRectMake(0, 0, ScreenWidth, 44);
        
        // 初始化按钮
        self.emotionButton = [self setupBtn:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted" type:HLComposeToolbarTypeEmotion];
        self.emotionButton.frame = CGRectMake(0, 0, 44, 44);
        
        // 输入控件初始化
        HLEmotionTextView *textView = [[HLEmotionTextView alloc] init];
        textView.textColor = [UIColor grayColor];
        textView.delegate = self;
        textView.placeholder = @"添加评论";
        self.textView = textView;
        [self addSubview:textView];
        
        CGFloat sendBtnWidth = 60;
        CGFloat sendBtnHeight = 44;
        CGFloat textViewWidth = ScreenWidth - self.emotionButton.width - sendBtnWidth;
        self.textView.frame = CGRectMake(44, 5.5, textViewWidth, 33);

        
        // 发送按钮初始化
        CGFloat sendBtnX = ScreenWidth - sendBtnWidth;
        UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(sendBtnX, 0, sendBtnWidth, sendBtnHeight)];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        sendButton.tag = HLComposeToolbarTypeSend;
        sendButton.enabled = NO;
        [sendButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

        self.sendButton = sendButton;
        [self addSubview:sendButton];
        
        //[self setupBtn:@"compose_toolbar_picture" highImage:@"compose_toolbar_picture_highlighted" type:HWComposeToolbarButtonTypePicture];
        
        //[self setupBtn:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted" type:HWComposeToolbarButtonTypeMention];
        
        //[self setupBtn:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted" type:HWComposeToolbarButtonTypeTrend];
        
       //[HLNotificationCenter addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:self.textView];
    }
    return self;
}

- (void)setShowKeyboardButton:(BOOL)showKeyboardButton
{
    _showKeyboardButton = showKeyboardButton;
    
//     默认的图片名
    NSString *image = @"compose_emoticonbutton_background";
    NSString *highImage = @"compose_emoticonbutton_background_highlighted";
    
//     显示键盘图标
    if (showKeyboardButton) {
        image = @"compose_keyboardbutton_background";
        highImage = @"compose_keyboardbutton_background_highlighted";
    }
    
//     设置图片
    [self.emotionButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self.emotionButton setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
}

/**
 * 创建一个按钮
 */
- (UIButton *)setupBtn:(NSString *)image highImage:(NSString *)highImage type:(HLComposeToolbarButtonType)type
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = type;
    [self addSubview:btn];
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.textView.font = [UIFont systemFontOfSize:14];
    
    HLLog(@"self.height : %f", self.bounds.size.height);
    
    // 设置所有按钮的frame
//    NSUInteger count = self.subviews.count;
//    CGFloat btnW = self.width / count;
//    CGFloat btnH = self.height;
//    for (NSUInteger i = 0; i<count; i++) {
//        UIButton *btn = self.subviews[i];
//        btn.y = 0;
//        btn.width = btnW;
//        btn.x = i * btnW;
//        btn.height = btnH;
//    }
}

- (void)textViewDidChange:(UITextView *)textView{
    
    [textView flashScrollIndicators];   // 闪动滚动条
    
    static CGFloat maxHeight = 130.0f;
    CGRect frame = textView.frame;
    //HLLog(@"frame.size.height %f", frame.size.height);
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height >= maxHeight)
    {
        size.height = maxHeight;
        textView.scrollEnabled = YES;   // 允许滚动
    }
    else
    {
        textView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
    }

    // self最新高度
    CGFloat selfNewHeight = size.height + 11;
    // self最新高度和旧高度之差
    CGFloat difference = selfNewHeight - self.height;
    self.textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    self.height = selfNewHeight;
    if(self.textView.hasText)
    {
        self.sendButton.enabled = YES;
        [self.sendButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }else{
        self.sendButton.enabled = NO;
        [self.sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    HLLog(@"self.sendButton.enabled %d",self.sendButton.enabled);
    if ([self.delegate respondsToSelector:@selector(composeToolbar:refreshToolbarFrame:)]) {
        [self.delegate composeToolbar:self refreshToolbarFrame:difference];
    }

}

- (void)btnClick:(UIButton *)btn
{
    self.sendButton.enabled = NO;
    [self.sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(composeToolbar:didClickButton:)]) {
//        NSUInteger index = (NSUInteger)(btn.x / btn.width);
        [self.delegate composeToolbar:self didClickButton:btn.tag];
    }
}
@end
