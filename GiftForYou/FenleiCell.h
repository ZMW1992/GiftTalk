//
//  FenleiCell.h
//  GiftForYou
//
//  Created by zhumingwen on 16/3/4.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupDetailModel;
@class FLSmallModel;
@interface FenleiCell : UICollectionViewCell


@property (nonatomic, strong) GroupDetailModel *detailModel;
@property (nonatomic, strong) FLSmallModel *smallModel;

@end
