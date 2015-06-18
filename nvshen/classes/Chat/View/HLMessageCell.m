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
        textView.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
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
    if (model.type == HLMessageMe) {

        NSString *imageURL = [USER_ICON_URL stringByAppendingString:@"1434377515057.jpg"];
        
        [self.icon sd_setImageWithURL:[NSURL URLWithString:imageURL ] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.icon.image = [image clipCircleImageWithBorder:5 borderColor:[UIColor whiteColor]];
        }];
        
    }else{
        
        NSString *imageURL = [USER_ICON_URL stringByAppendingString:@"1432890642284.jpg"];
        
        [self.icon sd_setImageWithURL:[NSURL URLWithString:imageURL ] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.icon.image = [image clipCircleImageWithBorder:5 borderColor:[UIColor whiteColor]];
        }];
    }
    
    //3.正文
    self.textView.frame = frameMessage.textViewF;
    [self.textView setTitle:model.text forState:UIControlStateNormal];
    
    
    if (model.type == HLMessageMe) {
        [self.textView setBackgroundImage:[UIImage resizeWithImageName:@"chat_send_nor"] forState:UIControlStateNormal];
    }else{
        [self.textView setBackgroundImage:[UIImage resizeWithImageName:@"chat_recive_nor"] forState:UIControlStateNormal];
    }
    
}

//返回一个可拉伸的图片
@end
