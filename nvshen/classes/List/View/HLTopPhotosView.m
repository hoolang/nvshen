//
//  HLTopPhotosView.m
//  nvshen
//
//  Created by hoolang on 15/6/4.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLTopPhotosView.h"
#import "HLStatusPhotoView.h"
#define HLTopPhotoWH 80
#define HLTopPhotoMargin 5

@interface HLTopPhotosView()
@end

@implementation HLTopPhotosView

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
//    while (self.subviews.count < photosCount) {
//        HLStatusPhotoView *photoView = [[HLStatusPhotoView alloc] init];
//        [self addSubview:photoView];
//    }
    
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i< photosCount; i++) {
        HLStatusPhotoView *photoView = [[HLStatusPhotoView alloc] init];
        photoView.photo = photos[i];
        [self addSubview:photoView];
    }
}

+ (CGSize)sizeWithCount:(NSUInteger)count
{
    CGFloat photosW =  10 * (count -1) + count * HLTopPhotoWH;
    
    CGFloat photosH = HLTopPhotoWH;
    
    return CGSizeMake(photosW, photosH);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    NSUInteger photosCount = self.photos.count;

    for (int i = 0; i<photosCount; i++) {
        HLStatusPhotoView *photoView = self.subviews[i];
        
        photoView.x = i * HLTopPhotoWH + i * HLTopPhotoMargin;
        photoView.y = 0;
        photoView.width = HLTopPhotoWH;
        photoView.height = HLTopPhotoWH;
    }
    
    self.contentSize = CGSizeMake(2 * self.bounds.size.width - (ScreenWidth - HLTopPhotoWH - HLTopPhotoMargin), 0);
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}

#pragma mark - ScrollView的代理方法
// 滚动视图停下来，修改页面控件的小点（页数）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

@end
