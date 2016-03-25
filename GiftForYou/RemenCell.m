//
//  RemenCell.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/3.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "RemenCell.h"
#import "RemenModel.h"
#import <UIImageView+WebCache.h>

@interface RemenCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bacImg;

@end

@implementation RemenCell




- (void)setRemenModel:(RemenModel *)remenModel {
    
    _remenModel = remenModel;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:remenModel.cover_image_url] placeholderImage:[UIImage imageNamed:@"im_img_placeholder@3x"]];
    
    self.titleLabel.text = remenModel.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", remenModel.price];
     NSString *likes_count = [NSString stringWithFormat:@"%@", remenModel.favorites_count];
    
    self.likeLabel.text = likes_count;
}


- (void)awakeFromNib {
    
    self.imgView.layer.cornerRadius = 7;
    self.imgView.layer.masksToBounds = YES;
}

@end
