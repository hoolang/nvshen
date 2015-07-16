//
//  ILHtml.m
//
//  Created by apple on 14-9-12.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import "HLHtml.h"

@implementation HLHtml


+ (instancetype)htmlWithDict:(NSDictionary *)dict
{
    HLHtml *html = [[HLHtml alloc] init];
    
    html.title = dict[@"title"];
    html.html = dict[@"html"];
    html.ID = dict[@"id"];
    return html;
}

@end
