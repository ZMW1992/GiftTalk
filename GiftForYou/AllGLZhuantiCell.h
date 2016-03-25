//
//  AllGLZhuantiCell.h
//  GiftForYou
//
//  Created by zhumingwen on 16/3/7.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CollectionModel;
@interface AllGLZhuantiCell : UITableViewCell

@property (nonatomic, retain) UIImageView *coverImageView;
@property (nonatomic, retain) UILabel *titleNameLabel;
@property (nonatomic, retain) UILabel *subtitleNameLabel;


@property (nonatomic, strong) CollectionModel *model;

+ (CGFloat)cellHeight;

@end
