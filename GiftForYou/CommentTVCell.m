//
//  CommentTVCell.m
//  GiftTalk
//
//  Created by zhumingwen on 16/1/15.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "CommentTVCell.h"
#import "UIImageView+WebCache.h"

@implementation CommentTVCell

- (void)awakeFromNib {
    // Initialization code
    
    self.headerImageView.layer.cornerRadius = 22;
    self.headerImageView.layer.masksToBounds = YES;
    
}




//重写setTempModel,为cell赋值
- (void)setTempModel:(CommentsModel *)tempModel {
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:tempModel.user.avatar_url]];
    self.userNameLabel.text = tempModel.user.nickname;
    self.contentLabel.text = tempModel.content;
    
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
