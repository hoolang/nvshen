//
//  SegmentedControl.m
//  SegmentedControlNavigation
//
//  Created by Hoolang on 5/30/15.
//  Copyright (c) 2015 Hoolang. All rights reserved.
//

#import "SegmentedControl.h"

@implementation SegmentedControl{
    // 这里假设要分两个栏目：最近联系、好友列表，分别对应一个 ViewController
    NSArray *buttons;
    UIButton *recentButton; // 最近联系 按钮
    UIButton *listButton; // 好友列表 按钮
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize]; //调用自定义的方法
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}


-(void)initialize{
    recentButton = [[UIButton alloc] init];
    [recentButton setBackgroundImage:[UIImage imageNamed:@"recordButtonBg"]
                            forState:UIControlStateNormal];
    [recentButton setBackgroundImage:[UIImage imageNamed:@"recordButtonBgActive"]
                            forState:UIControlStateSelected];
//    [recentButton setTitle:@"消息" forState:UIControlStateNormal];
//    [recentButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//    [recentButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    recentButton.frame = CGRectMake(0, 0, 54, 32);
    [self addSubview:recentButton];
    
    listButton = [[UIButton alloc] init];
    [listButton setBackgroundImage:[UIImage imageNamed:@"knowledgeButtonBg"]
                               forState:UIControlStateNormal];
    [listButton setBackgroundImage:[UIImage imageNamed:@"knowledgeButtonBgActive"]
                               forState:UIControlStateSelected];
    
//    [listButton setTitle:@"好友" forState:UIControlStateNormal];
//    [listButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//    [listButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    listButton.frame = CGRectMake(54, 0, 54, 32);
    [self addSubview:listButton];
    

    
    [recentButton addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
    [listButton addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];

    
    buttons = @[recentButton, listButton];
    
    self.selectedSegmentIndex = UISegmentedControlNoSegment;
    
    [self sizeToFit];
    
    NSLog(@"SegmentedControl initialize");
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(108, 32);
}

- (void)touchUpInsideAction:(UIButton *)button {
    NSLog(@"SegmentedControl touchUpInsideAction");
    for (UIButton *button in buttons) {
        button.selected = NO;
    }
    button.selected = YES;
    NSInteger index = [buttons indexOfObject:button];
    if (self.selectedSegmentIndex != index) {
        self.selectedSegmentIndex = index;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end

