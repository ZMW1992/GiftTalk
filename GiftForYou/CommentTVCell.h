//
//  CommentTVCell.h
//  GiftTalk
//
//  Created by zhumingwen on 16/1/15.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsModel.h"

@interface CommentTVCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) CommentsModel *tempModel;

@end
