//
//  RecommendTVCell.m
//  GiftTalk
//
//  Created by zhumingwen on 16/1/12.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "RecommendTVCell.h"
#import "UIImageView+WebCache.h"

@implementation RecommendTVCell

- (void)awakeFromNib {
    // Initialization code
    self.likeView.layer.cornerRadius = 5;
    self.likeView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setTempModel:(ShouyeModel *)tempModel {
    _tempModel = tempModel;
    
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:tempModel.cover_image_url]];
    self.describeLabel.text = tempModel.title;
    
    NSString *likeCountStr = nil;
    if ([tempModel.likes_count integerValue] > 1000) {
        
        likeCountStr = [NSString stringWithFormat:@"%.1fk", [tempModel.likes_count integerValue] / 1000.0];
        
        
    }else {
        likeCountStr = [tempModel.likes_count stringValue];
    
    }

    self.likeLabel.text = likeCountStr;
}





@end
