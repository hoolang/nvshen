//
//  ILSettingGroup.h
//  ItheimaLottery
//
//  Created by apple on 14-9-10.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLSettingGroup : NSObject

@property (nonatomic, copy) NSString *header;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, copy) NSString *footer;

@end
