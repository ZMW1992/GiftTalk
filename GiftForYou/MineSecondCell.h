//
//  MineSecondCell.h
//  GiftForYou
//
//  Created by zhumingwen on 16/3/11.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RemenModel;
@class ShouyeModel;
typedef void(^SecondCellHightBolck)(CGFloat height);

// 协议方法
@protocol MineSecondCellDelegate <NSObject>

- (void)collectionViewItemClick:(RemenModel *)remenModel;
- (void)tableViewCellClick:(ShouyeModel *)shouyeModel;

@end


@interface MineSecondCell : UITableViewCell



@property (nonatomic, copy) SecondCellHightBolck secondCellHightBolck;
@property (nonatomic, weak) id<MineSecondCellDelegate> delegate;

@end
