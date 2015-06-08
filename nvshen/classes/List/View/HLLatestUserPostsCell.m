//
//  HLLatestUserPostsCell.m
//  nvshen
//
//  Created by hoolang on 15/6/7.
//  Copyright (c) 2015年 Hoolang. All rights reserved.
//

#import "HLLatestUserPostsCell.h"

@implementation HLLatestUserPostsCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HLLatestUserPostsCell";
    HLLatestUserPostsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HLLatestUserPostsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // 点击cell的时候不要变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 设置选中时的背景为蓝色
        //        UIView *bg = [[UIView alloc] init];
        //        bg.backgroundColor = [UIColor blueColor];
        //        self.selectedBackgroundView = bg;
        
        // 这个做法不行
        //        self.selectedBackgroundView.backgroundColor = [UIColor blueColor];
        [super setupOriginal];
        [super setupBottom:@"新鲜出炉的女神驾到"];
        [super setupFirstView:@"http://192.168.168.188:8008/nvshen/photos/1432729264571.jpg" withURL:HL_TOP_CATEGORY_LATEST_USER_LATEST_POSTS_URL andTitle:@"最新用户"];
    }
    return self;
}
@end
