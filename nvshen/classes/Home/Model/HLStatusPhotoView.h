//
//  HLStatusPhotoView.h
//  nvshen
//
//  Created by hoolang on 15/5/28.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HLPhoto;
@interface HLStatusPhotoView : UIImageView
@property (nonatomic, strong) HLPhoto *photo;
@property (nonatomic, strong) HLPhoto *photoURL;
@end
