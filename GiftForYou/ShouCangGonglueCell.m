//
//  ShouCangGonglueCell.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/11.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "ShouCangGonglueCell.h"
#import "ShouyeModel.h"

@interface ShouCangGonglueCell ()

@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end


@implementation ShouCangGonglueCell



- (void)setShouyeModel:(ShouyeModel *)shouyeModel {
    _shouyeModel = shouyeModel;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:shouyeModel.cover_image_url] placeholderImage:[UIImage imageNamed:@"ig_holder_image"]];
    
    self.nameLabel.text = shouyeModel.title;
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
