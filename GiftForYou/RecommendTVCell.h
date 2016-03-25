//
//  RecommendTVCell.h
//  GiftTalk
//
//  Created by zhumingwen on 16/1/12.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShouyeModel.h"

@interface RecommendTVCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *picImageView;
@property (strong, nonatomic) IBOutlet UILabel *describeLabel;
@property (strong, nonatomic) IBOutlet UIView *likeView;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) ShouyeModel *tempModel;

@end
