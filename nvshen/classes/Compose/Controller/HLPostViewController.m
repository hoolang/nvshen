//
//  HLPostViewController.m
//  nvshen
//
//  Created by hoolang on 15/5/18.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLPostViewController.h"
#import "HLEmotionTextView.h"
#import "HLEmotion.h"

@interface HLPostViewController ()<UITextViewDelegate>
/** 输入控件 */
@property (nonatomic, weak) HLEmotionTextView *textView;
@property (nonatomic, weak) HLEmotionTextView *textView2;


@property (strong, nonatomic) IBOutlet HLEmotionTextView *postText;
@end

@implementation HLPostViewController
@synthesize postText;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(submit) image:@"navigationbar_back" highImage:@"navigationbar_back_highlighted"];
  
    HLEmotionTextView *textView = [[HLEmotionTextView alloc] init];
    // 垂直方向上可以拖拽
    textView.alwaysBounceVertical = YES;
    CGFloat screen = [UIScreen mainScreen].bounds.size.width;
    
    textView.frame = CGRectMake(10, 74, screen - self.postImageView.frame.size.width -10 -10,self.postImageView.frame.size.height
                                );
    textView.font = [UIFont systemFontOfSize:13];
    textView.delegate = self;
    textView.placeholder = @"秀秀我的态度";
    [textView becomeFirstResponder];
    
    //_postText.placeholder = textView.placeholder;

    _postImageView.image = _image;
    
    [self.view addSubview:textView];
    
    // 文字改变的通知
    [HLNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:postText];
    
//    // 键盘通知
//    // 键盘的frame发生改变时发出的通知（位置和尺寸）
//    [HLNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    
//    // 表情选中的通知
//    [HLNotificationCenter addObserver:self selector:@selector(emotionDidSelect:) name:HWEmotionDidSelectNotification object:nil];
//    
//    // 删除文字的通知
//    [HLNotificationCenter addObserver:self selector:@selector(emotionDidDelete) name:HWEmotionDidDeleteNotification object:nil];
}

#pragma mark - 监听方法
/**
 *  删除文字
 */
- (void)emotionDidDelete
{
    [self.postText deleteBackward];
}

-(void)submit{
    HLLog(@"submit");
}
-(void)textDidChange{
    HLLog(@"textDidChange");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
