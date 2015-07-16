//
//  ILSettingItem.h
//  ItheimaLottery
//
//  Created by apple on 14-9-10.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void(^HLSettingItemOption)();

@interface HLSettingItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *subTitle;

// 保存一段功能，在恰当的时候调用
@property (nonatomic, copy) HLSettingItemOption option;


+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;

@end
