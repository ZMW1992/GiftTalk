//
//  AllGLZhuantiCell.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/7.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "AllGLZhuantiCell.h"
#import "CollectionModel.h"
#import <UIImageView+WebCache.h>
@implementation AllGLZhuantiCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addAllViews];
    }
    return self;
}

- (void)addAllViews
{
    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowW*0.027, kWindowW*0.027, kWindowW - (kWindowW*0.027 * 2), kWindowW*0.479)] ;
    self.coverImageView.layer.cornerRadius = 7;
    self.coverImageView.layer.masksToBounds = YES;
    [self addSubview:_coverImageView];
    
    self.titleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWindowW*0.027, kWindowW*0.133, kWindowW - (kWindowW*0.027 * 2), kWindowW*0.080)] ;
    self.subtitleNameLabel.font = [UIFont systemFontOfSize:30];
    _titleNameLabel.textAlignment = NSTextAlignmentCenter;
    _titleNameLabel.textColor = [UIColor whiteColor];
    _titleNameLabel.font = [UIFont boldSystemFontOfSize:25];
    [self addSubview:_titleNameLabel];
    
    self.subtitleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWindowW*0.027, kWindowW*0.027 * 9, kWindowW - (kWindowW*0.027 * 2), kWindowW*0.027 * 3)] ;
    self.subtitleNameLabel.font = [UIFont systemFontOfSize:15];
    _subtitleNameLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleNameLabel.textColor = [UIColor whiteColor];
    _subtitleNameLabel.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:_subtitleNameLabel];
    
    
}


+ (CGFloat)cellHeight
{
    return kWindowW / 4 + 17;
}


- (void)setModel:(CollectionModel *)model {
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url]];
    _titleNameLabel.text = model.titleName;
    _subtitleNameLabel.text = model.subtitle;
    
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
