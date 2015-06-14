//
//  HLMessageCell.h
//
//  Created by apple on 14-8-22.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HLMessageFrame;
@interface HLMessageCell : UITableViewCell

+ (instancetype)messageCellWithTableView:(UITableView *)tableview;

//frame 的模型
@property (nonatomic, strong)HLMessageFrame *frameMessage;

@end
