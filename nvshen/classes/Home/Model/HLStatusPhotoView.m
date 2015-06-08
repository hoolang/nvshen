//
//  HLStatusPhotoView.m
//  nvshen
//
//  Created by hoolang on 15/5/28.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLStatusPhotoView.h"
#import "HLPhoto.h"
#import "UIImageView+WebCache.h"
@interface HLStatusPhotoView()
@property (nonatomic, weak) UIImageView *gifView;
@end
@implementation HLStatusPhotoView

//- (UIImageView *)gifView
//{
//    if (!_gifView) {
//        UIImage *image = [UIImage imageNamed:@"timeline_image_gif"];
//        UIImageView *gifView = [[UIImageView alloc] initWithImage:image];
//        [self addSubview:gifView];
//        self.gifView = gifView;
//    }
//    return _gifView;
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 内容模式
        self.contentMode = UIViewContentModeScaleAspectFill;
        // 超出边框的内容都剪掉
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setPhoto:(HLPhoto *)photo
{
    _photo = photo;
    HLLog(@"photo.thumbnail_pic %@",photo.thumbnail_pic);

    // 设置图片                                       //@"http://192.168.168.100:8008/nvshen/photos/1432729264571.jpg"
    [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic ] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    // 显示\隐藏gif控件_thumbnail_pic	__NSCFString *	@"http://192.168.168.188:8008/nvshen/photos/1433251444499.jpg"	0x00007f8573da0f40    // 判断是够以gif或者GIF结尾
    //self.gifView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
    
    self add
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    
//    self.gifView.x = self.width - self.gifView.width;
//    self.gifView.y = self.height - self.gifView.height;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
