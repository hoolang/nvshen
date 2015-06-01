//
//  HWComposePhotosView.m
//  黑马微博2期
//
//  Created by apple on 14-10-20.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HLComposePhotosView.h"

@interface HLComposePhotosView()
@end

@implementation HLComposePhotosView

//- (NSMutableArray *)addedPhotos
//{
//    if (!_addedPhotos) {
////        self.addedPhotos = [[NSMutableArray alloc] init];
//        self.addedPhotos = [NSMutableArray array];
//    }
//    return _addedPhotos;
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photos = [NSMutableArray array];
    }
    return self;
}

- (void)addPhoto:(UIImage *)photo
{
    UIImageView *photoView = [[UIImageView alloc] init];
    photoView.image = photo;
    [self addSubview:photoView];
    
    // 存储图片
//    [_photos addObject:photo];
    [self.photos addObject:photo];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    NSUInteger count = self.subviews.count;
    int maxCol = 4;
    CGFloat imageWH = 70;
    CGFloat imageMargin = 10;
    
    for (int i = 0; i<count; i++) {
        UIImageView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = col * (imageWH + imageMargin);
        
        int row = i / maxCol;
        photoView.y = row * (imageWH + imageMargin);
        photoView.width = imageWH;
        photoView.height = imageWH;
    }
}

//- (NSArray *)photos
//{
//    return self.addedPhotos;
//}

//- (NSArray *)photos
//{
//    NSMutableArray *photos = [NSMutableArray array];
//    for (UIImageView *imageView in self.subviews) {
//        [photos addObject:imageView.image];
//    }
//    return photos;
//}

@end
