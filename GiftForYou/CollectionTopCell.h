//
//  CollectionTopCell.h
//  GiftForYou
//
//  Created by zhumingwen on 16/3/6.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionTopCellDelegate <NSObject>

- (void)collectionTopCellViewClicked:(NSString *)collectionID title:(NSString *)title;
- (void)collectionTopCellBtnClicked;

@end


@interface CollectionTopCell : UICollectionViewCell

@property (nonatomic, weak) id<CollectionTopCellDelegate> delegate;

@property (nonatomic, strong) NSArray *topModelArr;


@end
