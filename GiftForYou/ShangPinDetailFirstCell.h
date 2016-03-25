//
//  ShangPinDetailFirstCell.h
//  GiftForYou
//
//  Created by zhumingwen on 16/3/10.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShangPinDetailModel;

@interface ShangPinDetailFirstCell : UITableViewCell

@property (strong, nonatomic)  ShangPinDetailModel *tempModel;


- (CGFloat)getHeightForCellByModel:(ShangPinDetailModel *)model;
@end
