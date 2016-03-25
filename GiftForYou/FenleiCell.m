//
//  FenleiCell.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/4.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "FenleiCell.h"
#import "GroupDetailModel.h"
#import "FLSmallModel.h"
#import <UIImageView+WebCache.h>
@interface FenleiCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation FenleiCell


- (void)setDetailModel:(GroupDetailModel *)detailModel {
    _detailModel = detailModel;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:detailModel.icon_url] placeholderImage:[UIImage imageNamed:@""]];
    
    self.titleLabel.text = detailModel.name;
    
    
}



- (void)setSmallModel:(FLSmallModel *)smallModel {
    _smallModel = smallModel;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:smallModel.icon_url] placeholderImage:[UIImage imageNamed:@""]];
    
    self.titleLabel.text = smallModel.name;
    
}







- (void)awakeFromNib {
    // Initialization code
}










@end
