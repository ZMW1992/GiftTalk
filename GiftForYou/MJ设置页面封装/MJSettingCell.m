//
//  MJSettingCell.m
//  00-ItcastLottery
//
//  Created by apple on 14-4-17.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJSettingCell.h"
#import "MJSettingItem.h"
#import "MJSettingSwitchItem.h"
#import "MJSettingArrowItem.h"
#import "MJSettingLabelItem.h"

@interface MJSettingCell()
/**
 *  箭头
 */
@property (nonatomic, strong) UIImageView *arrowView;
/**
 *  开关
 */
@property (nonatomic, strong) UISwitch *switchView;

/**
 *  标签
 */
@property (nonatomic, strong) UILabel *labelView;
@end

@implementation MJSettingCell

- (UIImageView *)arrowView
{
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellArrow"]];
    }
    return _arrowView;
}

- (UISwitch *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
    }
    return _switchView;
}

- (UILabel *)labelView
{
    if (_labelView == nil) {
        _labelView = [[UILabel alloc] init];
        _labelView.bounds = CGRectMake(0, 0, 100, 30);
        _labelView.backgroundColor = [UIColor redColor];
    }
    return _labelView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"setting";
    MJSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MJSettingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setItem:(MJSettingItem *)item
{
    _item = item;
    
    // 1.设置数据
    [self setupData];
    
    // 2.设置右边的内容
    [self setupRightContent];
}

/**
 *  设置右边的内容(cell重用的时候，cell的内容要覆盖，cell的状态也要覆盖)
 */
- (void)setupRightContent
{
    if ([self.item isKindOfClass:[MJSettingArrowItem class]]) { // 箭头
        self.accessoryView = self.arrowView;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else if ([self.item isKindOfClass:[MJSettingSwitchItem class]]) { // 开关
        self.accessoryView = self.switchView;
        
        if (self.switchOption) {
            self.switchOption(self.switchView);
        }
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if ([self.item isKindOfClass:[MJSettingLabelItem class]]) { // 标签
        self.accessoryView = self.labelView;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else {
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}

/**
 *  设置数据
 */
- (void)setupData
{
    if (self.item.icon) {
        self.imageView.image = [UIImage imageNamed:self.item.icon];
    }
    self.textLabel.text = self.item.title;
}

@end
