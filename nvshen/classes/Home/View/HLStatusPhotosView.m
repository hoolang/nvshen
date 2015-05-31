//
//  HLStatusPhotosView.m
//  nvshen
//
//  Created by hoolang on 15/5/28.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLStatusPhotosView.h"
#import "HLStatusPhotosView.h"
#import "HLPhoto.h"
#import "HLStatusPhotoView.h"

#define HLStatusPhotoWH [UIScreen mainScreen].bounds.size.width
#define HLStatusPhotoMargin 10
#define HLStatusPhotoMaxCol(count) 1//((count==4)?2:3)

@implementation HLStatusPhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    NSUInteger photosCount = photos.count;
    HLLog(@"setPhotos %ld",photosCount);
    
    // 创建足够数量的图片控件
    // 这里的self.subviews.count不要单独赋值给其他变量
    while (self.subviews.count < photosCount) {
        HLStatusPhotoView *photoView = [[HLStatusPhotoView alloc] init];
        [self addSubview:photoView];
    }
    
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i<self.subviews.count; i++) {
        HLStatusPhotoView *photoView = self.subviews[i];
        
        if (i < photosCount) { // 显示
            photoView.photo = photos[i];
            photoView.hidden = NO;
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    NSUInteger photosCount = self.photos.count;
    int maxCol = HLStatusPhotoMaxCol(photosCount);
    for (int i = 0; i<photosCount; i++) {
        HLStatusPhotoView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = col * (HLStatusPhotoWH + HLStatusPhotoMargin);
        
        int row = i / maxCol;
        photoView.y = row * (HLStatusPhotoWH + HLStatusPhotoMargin);
        photoView.width = HLStatusPhotoWH;
        photoView.height = HLStatusPhotoWH;
    }
}

+ (CGSize)sizeWithCount:(NSUInteger)count
{
    // 最大列数（一行最多有多少列）
    int maxCols = HLStatusPhotoMaxCol(count);
    
    NSUInteger cols = (count >= maxCols)? maxCols : count;
    CGFloat photosW = cols * HLStatusPhotoWH + (cols - 1) * HLStatusPhotoMargin;
    
    // 行数
    NSUInteger rows = (count + maxCols - 1) / maxCols;
    CGFloat photosH = rows * HLStatusPhotoWH + (rows - 1) * HLStatusPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}

@end
