//
//  ShouyeCell.h
//  GiftForYou
//
//  Created by lanouhn on 16/3/3.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShouyeCell;
@class ShouyeModel;
@protocol  ShouyeCellDelegate <NSObject>

@optional

- (void)dianZan:(UIButton *)button;

@end

@interface ShouyeCell : UITableViewCell

@property (weak, nonatomic) id<ShouyeCellDelegate> delegate;

@property (nonatomic, strong)ShouyeModel *shouyeModel;


@end
