//
//  CollectionCell.h
//  GiftForYou
//
//  Created by zhumingwen on 16/3/5.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class CollectionModel;

@protocol CollectionCellDelegate <NSObject>

- (void)collectionCellViewClicked:(NSString *)collectionID title:(NSString *)title;
- (void)collectionCellBtnClicked;

@end



@interface CollectionCell : UITableViewCell

@property (nonatomic, weak) id<CollectionCellDelegate> delegate;

//@property (nonatomic, strong) CollectionModel *collectionModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView modelArr:(NSArray *)modelArr;

@end
