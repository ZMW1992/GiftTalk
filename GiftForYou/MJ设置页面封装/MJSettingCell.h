//
//  MJSettingCell.h
//  00-ItcastLottery
//
//  Created by apple on 14-4-17.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJSettingItem;


typedef void (^SwitchViewAction)(UISwitch *switchView);

@interface MJSettingCell : UITableViewCell

@property (nonatomic, strong) MJSettingItem *item;

@property (nonatomic, copy) SwitchViewAction switchOption;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
