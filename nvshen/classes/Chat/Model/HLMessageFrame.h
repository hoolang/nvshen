//
//  HLMessageFrame.h
//
//  Created by apple on 14-8-22.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HLMessage;
@interface HLMessageFrame : NSObject

//时间的frame
@property (nonatomic, assign,readonly)CGRect timeF;

//正文的frame
@property (nonatomic, assign,readonly)CGRect textViewF;

//图片
@property (nonatomic, assign,readonly)CGRect iconF;

//cell
@property (nonatomic, assign,readonly)CGFloat cellH;

//数据模型
@property (nonatomic, strong)HLMessage *message;
@end
