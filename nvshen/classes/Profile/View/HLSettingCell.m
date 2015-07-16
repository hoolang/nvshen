//
//  ILSettingCell.m
//  ItheimaLottery
//
//  Created by apple on 14-9-10.
//  Copyright (c) 2014年 Hoolang. All rights reserved.
//

#import "HLSettingCell.h"

#import "HLSettingItem.h"

#import "HLSettingArrowItem.h"
#import "HLSettingSwitchItem.h"
#import "HLSettingLabelItem.h"

@interface HLSettingCell()


@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UILabel *labelView;

@end

@implementation HLSettingCell

- (UILabel *)labelView
{
    if (_labelView == nil) {
        _labelView = [[UILabel alloc] init];
        _labelView.bounds = CGRectMake(0, 0, 100, 44);
        _labelView.textColor = [UIColor redColor];
        _labelView.textAlignment = NSTextAlignmentRight;
    }
    return _labelView;
}

- (UIImageView *)imgView
{
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellArrow"]];
    }
    return _imgView;
}

- (UISwitch *)switchView
{
    if (_switchView == nil) {
        
        _switchView = [[UISwitch alloc] init];
    }
    return _switchView;
}


- (void)setItem:(HLSettingItem *)item
{
    _item = item;
    
    
    // 1.设置cell的子控件的数据
    [self setUpData];
    
    // 2.设置右边视图
    [self setUpAccessoryView];

}

// 设置cell的子控件的数据
- (void)setUpData
{
    if (_item.icon.length) {
        
        self.imageView.image = [UIImage imageNamed:_item.icon];
    }
    self.textLabel.text = _item.title;
    
    self.detailTextLabel.text = _item.subTitle;
}

// 设置右边视图
- (void)setUpAccessoryView
{
    if ([_item isKindOfClass:[HLSettingArrowItem class]]) { // 箭头
        self.accessoryView = self.imgView;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else if ([_item isKindOfClass:[HLSettingSwitchItem class]]){ // Switch
        self.accessoryView = self.switchView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if ([_item isKindOfClass:[HLSettingLabelItem class]]){
        self.accessoryView = self.labelView;
        
        HLSettingLabelItem *labelItem = (HLSettingLabelItem *)_item;
        self.labelView.text = labelItem.text;
        self.labelView.font = [UIFont systemFontOfSize:12];
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else{
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    HLSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    
    if (cell == nil) {
        cell = [[HLSettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 237 233 218
       
        // 设置背景
        [self setUpBg];
        // 清空子视图的背景
        [self setSubViews];
        
    }
    
    return self;
}
- (void)setUpBg
{
    // 设置背景图片
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor whiteColor];
    self.backgroundView = bg;
    
    
    // 设置选中的背景图片
    UIView *selectedBg = [[UIView alloc] init];
    selectedBg.backgroundColor = HLColor(237, 233, 218);
    self.selectedBackgroundView = selectedBg;
}

- (void)setSubViews
{
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.font = [UIFont systemFontOfSize:12];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
}


- (void)setFrame:(CGRect)frame
{
    frame.size.width += 20;
    frame.origin.x -= 10;

    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
