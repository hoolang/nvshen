//
//  HLWaterflowLayout.h
//  04-瀑布流
//
//  Created by apple on 14/12/4.
//  Copyright (c) 2014年 hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HLWaterflowLayout;

@protocol HLWaterflowLayoutDelegate <NSObject>
- (CGFloat)waterflowLayout:(HLWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;
@end

@interface HLWaterflowLayout : UICollectionViewLayout
@property (nonatomic, assign) UIEdgeInsets sectionInset;
/** 每一列之间的间距 */
@property (nonatomic, assign) CGFloat columnMargin;
/** 每一行之间的间距 */
@property (nonatomic, assign) CGFloat rowMargin;
/** 显示多少列 */
@property (nonatomic, assign) int columnsCount;

@property (nonatomic, weak) id<HLWaterflowLayoutDelegate> delegate;

@end
