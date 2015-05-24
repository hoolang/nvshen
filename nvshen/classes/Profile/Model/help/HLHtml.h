//
//  ILHtml.h
//  ItheimaLottery
//
//  Created by apple on 14-9-12.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 
 "title" : "如何提现？",
 "html" : "help.html",
 "id" : "howtowithdraw"
 */
@interface HLHtml : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *html;


+ (instancetype)htmlWithDict:(NSDictionary *)dict;

@end
