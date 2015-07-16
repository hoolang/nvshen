//
//  ILSettingArrowItem.h
//  ItheimaLottery
//
//  Created by apple on 14-9-10.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import "HLSettingItem.h"

@interface HLSettingArrowItem : HLSettingItem

// 调整的控制器的类名
@property (nonatomic, assign) Class destVcClass;


+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;

@end
