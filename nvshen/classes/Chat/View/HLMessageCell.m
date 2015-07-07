//
//  HLMessageCell.m
//
//  Created by apple on 14-8-22.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import "HLMessageCell.h"
#import "HLMessageFrame.h"
#import "HLMessage.h"
#import "Constant.h"
#import "UIImage+ResizImage.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Circle.h"
@interface HLMessageCell()
//时间
@property (nonatomic, weak)UILabel *time;
//正文
@property (nonatomic, weak)UIButton *textView;
//用户头像
@property (nonatomic, weak)UIImageView *icon;

@end

@implementation HLMessageCell
+ (instancetype)messageCellWithTableView:(UITableView *)tableview
{
    static NSString *ID = @"messageCell";
    HLMessageCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HLMessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       //1.时间
        UILabel *time = [[UILabel alloc]init];
        time.textAlignment = NSTextAlignmentCenter;
        time.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:time];
        self.time = time;
        
        //1.正文
        UIButton *textView = [[UIButton alloc]init];
        textView.titleLabel.font = bBtnFont;
        textView.titleLabel.numberOfLines = 0;//自动换行
        textView.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [textView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:textView];
        self.textView = textView;
        
        //1.头像
        UIImageView *icon = [[UIImageView alloc]init];
        [self.contentView addSubview:icon];
        self.icon = icon;
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

//设置内容和frame
- (void)setFrameMessage:(HLMessageFrame *)frameMessage
{
    _frameMessage = frameMessage;
    
    HLMessage *model = frameMessage.message;
    
    //1.时间
    self.time.frame = frameMessage.timeF;
    self.time.text = model.time;
    
    //2.头像
    self.icon.frame = frameMessage.iconF;
    self.icon.image = frameMessage.message.avatar;
    
    if (!frameMessage.message.avatar) {
        self.icon.image = [UIImage imageNamed:@"avatar_default_small"];
        self.icon.image = [self.icon.image clipCircleImageWithBorder:0 borderColor:[UIColor whiteColor]];
    }else{
        self.icon.image = [frameMessage.message.avatar clipCircleImageWithBorder:0 borderColor:[UIColor whiteColor]];
    }
    //3.正文
    self.textView.frame = frameMessage.textViewF;
    [self.textView setTitle:model.text forState:UIControlStateNormal];
    
    
    if (model.type == HLMessageMe) {
        [self.textView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.textView setBackgroundImage:[UIImage resizeWithImageName:@"chat_send_nor"] forState:UIControlStateNormal];
    }else{
        [self.textView setBackgroundImage:[UIImage resizeWithImageName:@"chat_recive_nor"] forState:UIControlStateNormal];
    }
    
}

//返回一个可拉伸的图片
@end
