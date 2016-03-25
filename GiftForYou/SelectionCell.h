//
//  ItemCell.h
//  礼物说
//
//  Created by zhumingwen on 16/3/6.
//  Copyright (c) 2016年 zhumingwen. All rights reserved.
//  首页3

#import <UIKit/UIKit.h>

@class ShouyeModel;
@interface SelectionCell : UITableViewCell

@property (nonatomic, strong) ShouyeModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;


@end
