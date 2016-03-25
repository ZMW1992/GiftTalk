//
//  ItemCell.m
//  礼物说
//
//  Created by zhumingwen on 16/3/6.
//  Copyright (c) 2016年 zhumingwen. All rights reserved.
//

#import "SelectionCell.h"
#import "ShouyeModel.h"
#import "DBManager2.h"

@interface SelectionCell ()
{
    UIImageView  *_picIV;
    UIButton     *_bgBtn;
    UIButton     *_titleBtn;
}
@end
@implementation SelectionCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cellid";
    SelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SelectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = MLBackColor;
        [cell addSubviews];
    }
    return cell;
}

- (void)addSubviews
{
    _picIV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, kWindowW - 10, kWindowH / 4 - 7)];
    _picIV.layer.cornerRadius = 5;
    _picIV.clipsToBounds = YES;
    [self.contentView addSubview:_picIV];
    
    _bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWindowW - 65, 10, 55, 25)];
    _bgBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 5, 3, 31);
    _bgBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    _bgBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
    [_bgBtn setBackgroundImage:MLImage(@"bg_feed_favourite") forState:UIControlStateNormal];
    [_bgBtn setImage:MLImage(@"ic_feed_favourite_normal") forState:UIControlStateNormal];
    [_bgBtn setImage:MLImage(@"ic_feed_favourite_selected") forState:UIControlStateSelected];
    [_bgBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_bgBtn];
    
    _titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, kWindowH / 4 - 32, kWindowW - 10, 30)];
    [_titleBtn setTitle:@"你造吗，秋日里的衬衫这样搭才好看" forState:UIControlStateNormal];
    _titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    _titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _titleBtn.titleLabel.font = MLFont(18.0);
    _titleBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_titleBtn setBackgroundImage:[Viewer createGradualWithFrame:CGRectMake(5, kWindowH / 4 - 32, kWindowW - 10, 30)] forState:UIControlStateNormal];
    _titleBtn.layer.cornerRadius = 5;
    _titleBtn.layer.masksToBounds = YES;
    [self.contentView addSubview:_titleBtn];
    
    _picIV.image = MLImage(@"ig_holder_image");
    [_bgBtn setTitle:@"1234" forState:UIControlStateNormal];
    
}

- (void)btnClick
{
    _bgBtn.selected = !_bgBtn.selected;
    if (_bgBtn.selected) {
        [[DBManager2 shareManager] insertDataWithSelectionModel:_model];
    } else {
        [[DBManager2 shareManager] deleteDataWithSelectionID:[_model.idd stringValue]];
    }
}
- (void)setModel:(ShouyeModel *)model
{
    _model = model;
    BOOL isExist = [[DBManager2 shareManager] selectOneDataWithSelectionID:[_model.idd stringValue]];
    if (isExist) {
        _bgBtn.selected = YES;
    } else {
        _bgBtn.selected = NO;
    }
    [_picIV sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url] placeholderImage:MLImage(@"ig_holder_image")];
    
    
    [_bgBtn setTitle:[NSString stringWithFormat:@"%@",model.likes_count] forState:UIControlStateNormal];
    [_titleBtn setTitle:model.title forState:UIControlStateNormal];
    
    // 根据字体设置赞的按钮宽度
    CGFloat width = [Helper widthOfString:_bgBtn.titleLabel.text font:[UIFont boldSystemFontOfSize:11.0] height:25];
    _bgBtn.width = 30 + width;
    _bgBtn.maxX = kWindowW - 10;
    _bgBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 5, 3, 6.1 + width);
    
    // 判断是否是今日创建的
    // 昨日日期
    NSDate *date1 = [[NSDate date] dateByAddingTimeInterval:-24 * 3600];
    // 创建日期
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:[model.updated_at floatValue]];
    if ([Helper isSameDay:date1 date2:date2]) {
        UIImageView *newIV = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 55, 55)];
        newIV.image = MLImage(@"ig_marker_fresh");
        [self.contentView addSubview:newIV];
    }
}


+ (CGFloat)cellHeight
{
    return kWindowH / 4;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}

@end
